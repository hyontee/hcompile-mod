#if defined _blackjack_included
	#endinput
#endif
#define _blackjack_included


#define MAX_BJ_LOBBY 6
//------------------------------------------------------------------------------
#define		DSI		DIALOG_STYLE_INPUT
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define 	DSP		DIALOG_STYLE_PASSWORD
#define 	DST		DIALOG_STYLE_TABLIST
//------------------------------------------------------------------------------
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

new Text:bj_fon;

new Text:bj_double;
new Text:bj_stop;
new Text:bj_play;
new Text:bj_take;
new Text:bj_exit;
new Text:bj_dealer_score;
new Text:bj_help;

new Text:bj_log_text[MAX_BJ_LOBBY+1][2];
new Text:bj_table_ready[MAX_BJ_LOBBY+1][5];

new Text:bj_text_bet[2];
new Text:bj_text_start_time;
new Text:bj_text_start_timer[MAX_BJ_LOBBY+1];

new Text:bj_text_bj_table[MAX_BJ_LOBBY+1][4];
new Text:bj_text_point_table[MAX_BJ_LOBBY+1][4];

new Text:bj_dealer_card[MAX_BJ_LOBBY+1][4];
new Text:bj_result_table[MAX_BJ_LOBBY+1][4];

new PlayerText:bj_bet[MAX_PLAYERS]; //Ставка
new PlayerText:bj_money[MAX_PLAYERS]; //Деньги игрока

new PlayerText:bj_dealer_point[MAX_PLAYERS];

new PlayerText:bj_members_name[MAX_PLAYERS][4]; //НИКИ УЧАСТНИКОВ

new PlayerText:bj_card_table[MAX_PLAYERS][5][4]; //Карты игрока стола

new PlayerText:bj_panel_info[MAX_PLAYERS];

new areabj[MAX_BJ_LOBBY+1];





new Text3D: BlackJackText[MAX_BJ_LOBBY+1];

new Float:BlackJackPos[MAX_BJ_LOBBY+1][3] =
{
	{0.0,0.0,0.0},
	{2508.173583,2464.578857,2499.664062},
	{2512.847412,2461.920166,2499.664062},
	{2509.147949,2455.435302,2499.664062},
	{2514.589843,2455.347167,2499.664062},
	{2512.984375,2448.713623,2499.664062},
	{2508.083984,2445.854980,2499.664062}
};

enum BJ_Card_struct
{
	Pointscore,
	Cardtexture[32]
}

new BlackJackCard[13][4][BJ_Card_struct] =
{
	{{2, "txd:cards2c"}, {2, "txd:cards2d"}, {2, "txd:cards2h"}, {2, "txd:cards2s"}}, //двойки
	{{3, "txd:cards3c"}, {3, "txd:cards3d"}, {3, "txd:cards3h"}, {3, "txd:cards3s"}}, //тройки
	{{4, "txd:cards4c"}, {4, "txd:cards4d"}, {4, "txd:cards4h"}, {4, "txd:cards4s"}}, //четверки
	{{5, "txd:cards5c"}, {5, "txd:cards5d"}, {5, "txd:cards5h"}, {5, "txd:cards5s"}}, //пятерки
	{{6, "txd:cards6c"}, {6, "txd:cards6d"}, {6, "txd:cards6h"}, {6, "txd:cards6s"}}, //шестерки
	{{7, "txd:cards7c"}, {7, "txd:cards7d"}, {7, "txd:cards7h"}, {7, "txd:cards7s"}}, //семерки
	{{8, "txd:cards8c"}, {8, "txd:cards8d"}, {8, "txd:cards8h"}, {8, "txd:cards8s"}}, //восьмерки
	{{9, "txd:cards9c"}, {9, "txd:cards9d"}, {9, "txd:cards9h"}, {9, "txd:cards9s"}}, //девятки
	{{10, "txd:cards10c"}, {10, "txd:cards10d"}, {10, "txd:cards10h"}, {10, "txd:cards10s"}}, //десятки

	{{10, "txd:cardsjc"}, {10, "txd:cardsjd"}, {10, "txd:cardsjh"}, {10, "txd:cardsjs"}}, //валет
	{{10, "txd:cardsqc"}, {10, "txd:cardsqd"}, {10, "txd:cardsqh"}, {10, "txd:cardsqs"}}, //дама
	{{10, "txd:cardskc"}, {10, "txd:cardskd"}, {10, "txd:cardskh"}, {10, "txd:cardsks"}}, //король
	{{11, "txd:cardsac"}, {11, "txd:cardsad"}, {11, "txd:cardsah"}, {11, "txd:cardsas"}}  //туз
};


enum BJ_Lobby
{
	bool:ActivedLobby,
	bool:StartedLobby,
	StartTimer,
	StageLobby,
	DealerPoint,

	DealerTurnGived,
	TableTurn,
	TableTurnTime,

	Table1Id,
	Table2Id,
	Table3Id,
	Table4Id,

	Table1Point,
	Table2Point,
	Table3Point,
	Table4Point,

	Table1Result,
	Table2Result,
	Table3Result,
	Table4Result,
}
new BlackJackLobby[MAX_BJ_LOBBY+1][BJ_Lobby];

enum P_BJ_Info
{
	bool:OnLobby,
	pBJLobby,
	pBJTable,
	pBJBet,

	pBJTakedCard,
}
new pBJInfo[MAX_PLAYERS][P_BJ_Info];

public OnGameModeInit()
{
	BlackJack_Init();
	#if defined BlackJack_OnGameModeInit
		return BlackJack_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit BlackJack_OnGameModeInit

forward BlackJack_OnGameModeInit();

public OnPlayerDisconnect(playerid, reason)
{
	if(pBJInfo[playerid][OnLobby] == true)
	{
	    switch(pBJInfo[playerid][pBJTable])
	    {
	        case 1: { BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table1Id] = 1000; BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table1Point] = 0; }
	        case 2: { BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table2Id] = 1000; BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table2Point] = 0; }
	        case 3: { BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table3Id] = 1000; BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table3Point] = 0; }
	        case 4: { BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table4Id] = 1000; BlackJackLobby[pBJInfo[playerid][pBJLobby]][Table4Point] = 0; }
	    }
	    pBJInfo[playerid][pBJTable] = 0;
	    pBJInfo[playerid][pBJLobby] = 10;
	    pBJInfo[playerid][OnLobby] = false;
	    

	}
	SetPlayerData(playerid, P_FREEZE, false);
	#if defined BlackJack_OnPlayerDisconnect
		return BlackJack_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect BlackJack_OnPlayerDisconnect
#if defined BlackJack_OnPlayerDisconnect
	forward BlackJack_OnPlayerDisconnect(playerid, reason);
#endif


public OnPlayerClickTextDraw(playerid, Text:clickedid)
{

	if(clickedid == bj_help)
    {
        new str[1024];
        format(str, sizeof str,
		  	"BLACKJACK (Черный Валет) - одна из самых популярных карточных игр.\n"\
			"Задача игрока - набрать большее количество очков чем дилер, но не больше 21.\n"\
			"Помните, что игрок, набравший больше 21 очка сразу проигрывает игру,\n"\
			"за исключением ничьи с дилером (Если у дилера тоже больше 21 очка).\n"\
			"Вначале игры каждому участнику будут выданы по 2 карты. В последствии игрок может решить,\n"\
			"брать ему карту или нет, воспользовавшись кнопками: 'Взять' или 'Хватит' соответственно.\n"
		);

  		format(str, sizeof str, "%s"\
			"Если при раздаче двух карт игроку выпало 21 очко - он получил BLACKJACK, но не стоит радоваться,\n"\
			"ведь BLACKJACK может получить и дилер, а значит Вы сыграете вничью! \n"\
			"В зависимости от карт, Вы можете удвоить Вашу ставку. \n"\
			"В этом случае Вам будет выдана одна карта, а ставка будет увеличена в два раза. \n"\
			"Также, если первой картой Дилера будет ТУЗ, Вы можете застраховать свою ставку за половину суммы. \n",
		str);
		format(str, sizeof str, "%s"\
			"В случае, если у дилера будет BLАCKJАCK, Вы получите все деньги назад, но если у дилера не будет 21 очка - Вы проиграете всё.\n"\
			"Желаем Вам успехов в карточном деле! Играйте и выигрывайте!",
		str);

        SPD(playerid, 19998, DSM,"{00FFFF}Помощь", str, "Закрыть", "");
    }
	if(clickedid == bj_play)
    {
        SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "Введите сумму на которую хотите сыграть: (Минимально 1000 рублей, Максимально 500000 рублей.)", "Играть", "Закрыть");
    }

    if(clickedid == bj_double)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[lobby][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
	        if(GetPlayerMoneyEx(playerid) < pBJInfo[playerid][pBJBet]) return SCM(playerid, CLRED, "| "CW"У Вас недостаточно средств чтобы удвоить ставку.");

			TextDrawSetString(bj_log_text[lobby][0], GetPlayerNameEx(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "Yљўoњћ ўЁњ™pЁҐ");
			TextDrawColor(bj_log_text[lobby][1], -1);

			if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);


			GivePlayerMoneyEx(playerid, -pBJInfo[playerid][pBJBet]);
			pBJInfo[playerid][pBJBet] = pBJInfo[playerid][pBJBet]*2;

			new str[15];
			format(str, sizeof str, "%d pyб", pBJInfo[playerid][pBJBet]);
			PlayerTextDrawSetString(playerid, bj_bet[playerid], str);

			format(str, sizeof str, "%d pyб", GetPlayerMoneyEx(playerid));
			PlayerTextDrawSetString(playerid, bj_money[playerid], str);


	        switch(pBJInfo[playerid][pBJTable])
			{
			    case 1:
			    {
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table1Point] += BlackJackCard[suit][type][Pointscore];

					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table1Point]);
					TextDrawSetString(bj_text_point_table[lobby][0], str);

					ShowMembersCardBJL(lobby, 1, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

			    	pBJInfo[playerid][pBJTakedCard]++;
     				CheckTableBlackJack(lobby, 1);
			    }
			    case 2:
			    {
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table2Point] += BlackJackCard[suit][type][Pointscore];

					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table2Point]);
					TextDrawSetString(bj_text_point_table[lobby][1], str);

					ShowMembersCardBJL(lobby, 2, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

			    	pBJInfo[playerid][pBJTakedCard]++;
     				CheckTableBlackJack(lobby, 2);
			    }
			    case 3:
			    {
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table3Point] += BlackJackCard[suit][type][Pointscore];

					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table3Point]);
					TextDrawSetString(bj_text_point_table[lobby][2], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

			    	pBJInfo[playerid][pBJTakedCard]++;
     				CheckTableBlackJack(lobby, 3);
			    }
			    case 4:
			    {
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table4Point] += BlackJackCard[suit][type][Pointscore];

					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table4Point]);
					TextDrawSetString(bj_text_point_table[lobby][3], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

			    	pBJInfo[playerid][pBJTakedCard]++;
     				CheckTableBlackJack(lobby, 4);
			    }
			}
	    }
	    else ShowNotificationSile(playerid, 2, 5, -1, -1, "Сейчас не ваш ход", "");
	}
    if(clickedid == bj_take)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
			TextDrawSetString(bj_log_text[lobby][0], GetPlayerNameEx(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "Взял карту");
			TextDrawColor(bj_log_text[lobby][1], -1);

			if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);

	        switch(pBJInfo[playerid][pBJTable])
			{
			    case 1:
			    {
			    	pBJInfo[playerid][pBJTakedCard]++;
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table1Point] += BlackJackCard[suit][type][Pointscore];

					new str[10];
					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table1Point]);
					TextDrawSetString(bj_text_point_table[lobby][0], str);

					ShowMembersCardBJL(lobby, 1, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

     				CheckTableBlackJack(lobby, 1);
			    }
			    case 2:
			    {
			    	pBJInfo[playerid][pBJTakedCard]++;
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table2Point] += BlackJackCard[suit][type][Pointscore];

					new str[10];
					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table2Point]);
					TextDrawSetString(bj_text_point_table[lobby][1], str);

					ShowMembersCardBJL(lobby, 2, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

     				CheckTableBlackJack(lobby, 2);
			    }
			    case 3:
			    {
			    	pBJInfo[playerid][pBJTakedCard]++;
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table3Point] += BlackJackCard[suit][type][Pointscore];

					new str[10];
					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table3Point]);
					TextDrawSetString(bj_text_point_table[lobby][2], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

     				CheckTableBlackJack(lobby, 3);
			    }
			    case 4:
			    {
			    	pBJInfo[playerid][pBJTakedCard]++;
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table4Point] += BlackJackCard[suit][type][Pointscore];

					new str[10];
					format(str, sizeof str, "Очки: %d", BlackJackLobby[lobby][Table4Point]);
					TextDrawSetString(bj_text_point_table[lobby][3], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

     				CheckTableBlackJack(lobby, 4);
			    }
			}
	    }
	    else ShowNotificationSile(playerid, 2, 5, -1, -1, "Сейчас не ваш ход", "");
	}
    if(clickedid == bj_stop)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[lobby][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
			TextDrawSetString(bj_log_text[lobby][0], GetPlayerNameEx(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "Остановился");
			TextDrawColor(bj_log_text[lobby][1], -1);

			if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);

	        PlayerTextDrawHide(playerid, bj_panel_info[playerid]);
	        BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurnTime] = 0;
            BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurn]++;
	    }
	    else ShowNotificationSile(playerid, 2, 5, -1, -1, "Сейчас не ваш ход", "");
	}
	if(clickedid == bj_exit)
	{
   		new lobby = pBJInfo[playerid][pBJLobby];
   		new table = pBJInfo[playerid][pBJTable];
	    if(BlackJackLobby[lobby][StartedLobby]) return SCM(playerid, CLRED, "| "CW"Дождитесь окончания игры");
	    else ExitPlayerLobby(playerid, lobby, table);
	}
	#if defined BlackJack_OnPlayerClickTextDraw
		return BlackJack_OnPlayerClickTextDraw(playerid, clickedid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw BlackJack_OnPlayerClickTextDraw
#if defined BlackJack_OnPlayerClickTextDraw
	forward BlackJack_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new str[128];
 	if(dialogid == 19999)
	{
	    if(response)
	    {
	        if(pBJInfo[playerid][OnLobby])
	        {
				new bet;
	            if(sscanf(inputtext,"d",bet))
	            {
	                SCM(playerid, CLRED, "| "CW"Введите ставку на которую хотите сыграть!");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "Введите сумму на которую хотите сыграть: (Минимально 1000 рублей, Максимально 500000 рублей.)", "Играть", "Закрыть");
	                return 0;
	            }
	            if(!(999 < bet < 500001))
	            {
	                SCM(playerid, CLRED, "| "CW"Минимально 1000 рублей, Максимально 500000 рублей.");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "Введите сумму на которую хотите сыграть: (Минимально 1000 рублей, Максимально 500000 рублей.)", "Играть", "Закрыть");
	                return 0;
	            }
	            if(GetPlayerMoneyEx(playerid) < bet)
	            {
	                SCM(playerid, CLRED, "| "CW"У вас недостаточно средств.");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "Введите сумму на которую хотите сыграть: (Минимально 1000 рублей, Максимально 500000 рублей.)", "Играть", "Закрыть");
	                return 0;
	            }

				format(str, sizeof str, "%d pyб", bet);
				PlayerTextDrawShow(playerid, bj_bet[playerid]);
				PlayerTextDrawSetString(playerid, bj_bet[playerid], str);
				pBJInfo[playerid][pBJBet] = bet;

				TextDrawShowForPlayer(playerid, bj_text_bet[0]);
				TextDrawShowForPlayer(playerid, bj_text_bet[1]);

				new lobby = pBJInfo[playerid][pBJLobby];

				new str2[] = "ГОТОВ";
				utf8_to_cp1251(str2);
				TextDrawSetString(bj_table_ready[lobby][pBJInfo[playerid][pBJTable]], str2);
				TextDrawColor(bj_table_ready[lobby][pBJInfo[playerid][pBJTable]], 0x00FF00FF);

				if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_table_ready[lobby][pBJInfo[playerid][pBJTable]]);
				if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_table_ready[lobby][pBJInfo[playerid][pBJTable]]);
				if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_table_ready[lobby][pBJInfo[playerid][pBJTable]]);
				if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_table_ready[lobby][pBJInfo[playerid][pBJTable]]);

				SetTimerEx("TimerHideBetText", 3000, false, "d", playerid);
			}
		}
	}
	#if defined BlackJack_OnDialogResponse
		return BlackJack_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse BlackJack_OnDialogResponse
#if defined BlackJack_OnDialogResponse
	forward BlackJack_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif




stock InitPlayerLobby(playerid, lobby, table)
{
    pBJInfo[playerid][pBJTable] = table;

	TextDrawShowForPlayer(playerid, bj_fon);
	TextDrawShowForPlayer(playerid, bj_double);
	TextDrawShowForPlayer(playerid, bj_stop);
	TextDrawShowForPlayer(playerid, bj_play);
	TextDrawShowForPlayer(playerid, bj_take);
	TextDrawShowForPlayer(playerid, bj_exit);

	TextDrawShowForPlayer(playerid, bj_help);

	TextDrawShowForPlayer(playerid, bj_text_start_time);
	TextDrawShowForPlayer(playerid, bj_text_start_timer[lobby]);

	PlayerTextDrawShow(playerid, bj_bet[playerid]);
	PlayerTextDrawSetString(playerid, bj_bet[playerid], "0 pyб");

	new money = GetPlayerMoneyEx(playerid);

	new str[15];
	format(str, sizeof str, "%d pyб", money);
	PlayerTextDrawShow(playerid, bj_money[playerid]);
	PlayerTextDrawSetString(playerid, bj_money[playerid], str);

	FreezePlayerEx(playerid);
	HideHud(playerid);

	foreach(new i : Player)
	{
	    ShowPlayerNameTagForPlayer(playerid, i, 0);
	}

	if(BlackJackLobby[lobby][Table1Id] < 1000)
	{
	    new name[24];
		GetPlayerName(BlackJackLobby[lobby][Table1Id], name, 24);

		PlayerTextDrawShow(playerid, bj_members_name[playerid][0]);
		PlayerTextDrawSetString(playerid, bj_members_name[playerid][0], name);


		PlayerTextDrawShow(playerid, bj_card_table[playerid][1][0]); PlayerTextDrawShow(playerid, bj_card_table[playerid][1][1]); PlayerTextDrawShow(playerid, bj_card_table[playerid][1][2]); PlayerTextDrawShow(playerid, bj_card_table[playerid][1][3]);

		TextDrawShowForPlayer(playerid, bj_table_ready[lobby][1]);
		TextDrawSetString(bj_table_ready[lobby][1], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][1], -16776961);


		new table1 = BlackJackLobby[lobby][Table1Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table1, bj_members_name[table1][table-1]);
		PlayerTextDrawSetString(table1, bj_members_name[table1][table-1], name);


		PlayerTextDrawShow(table1, bj_card_table[table1][table][0]); PlayerTextDrawShow(table1, bj_card_table[table1][table][1]); PlayerTextDrawShow(table1, bj_card_table[table1][table][2]); PlayerTextDrawShow(table1, bj_card_table[table1][table][3]);

		TextDrawShowForPlayer(table1, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][table], -16776961);
	}
	if(BlackJackLobby[lobby][Table2Id] < 1000)
	{
	    new name[24];
		GetPlayerName(BlackJackLobby[lobby][Table2Id], name, 24);

		PlayerTextDrawShow(playerid, bj_members_name[playerid][1]);
		PlayerTextDrawSetString(playerid, bj_members_name[playerid][1], name);


		PlayerTextDrawShow(playerid, bj_card_table[playerid][2][0]); PlayerTextDrawShow(playerid, bj_card_table[playerid][2][1]); PlayerTextDrawShow(playerid, bj_card_table[playerid][2][2]); PlayerTextDrawShow(playerid, bj_card_table[playerid][2][3]);

		TextDrawShowForPlayer(playerid, bj_table_ready[lobby][2]);
		TextDrawSetString(bj_table_ready[lobby][2], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][2], -16776961);



		new table2 = BlackJackLobby[lobby][Table2Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table2, bj_members_name[table2][table-1]);
		PlayerTextDrawSetString(table2, bj_members_name[table2][table-1], name);


		PlayerTextDrawShow(table2, bj_card_table[table2][table][0]); PlayerTextDrawShow(table2, bj_card_table[table2][table][1]); PlayerTextDrawShow(table2, bj_card_table[table2][table][2]); PlayerTextDrawShow(table2, bj_card_table[table2][table][3]);

		TextDrawShowForPlayer(table2, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][table], -16776961);
	}
	if(BlackJackLobby[lobby][Table3Id] < 1000)
	{
	    new name[24];
		GetPlayerName(BlackJackLobby[lobby][Table3Id], name, 24);

		PlayerTextDrawShow(playerid, bj_members_name[playerid][2]);
		PlayerTextDrawSetString(playerid, bj_members_name[playerid][2], name);


		PlayerTextDrawShow(playerid, bj_card_table[playerid][3][0]); PlayerTextDrawShow(playerid, bj_card_table[playerid][3][1]); PlayerTextDrawShow(playerid, bj_card_table[playerid][3][2]); PlayerTextDrawShow(playerid, bj_card_table[playerid][3][3]);

		TextDrawShowForPlayer(playerid, bj_table_ready[lobby][3]);
		TextDrawSetString(bj_table_ready[lobby][3], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][3], -16776961);



		new table3 = BlackJackLobby[lobby][Table3Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table3, bj_members_name[table3][table-1]);
		PlayerTextDrawSetString(table3, bj_members_name[table3][table-1], name);


		PlayerTextDrawShow(table3, bj_card_table[table3][table][0]); PlayerTextDrawShow(table3, bj_card_table[table3][table][1]); PlayerTextDrawShow(table3, bj_card_table[table3][table][2]); PlayerTextDrawShow(table3, bj_card_table[table3][table][3]);

		TextDrawShowForPlayer(table3, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][table], -16776961);
	}
	if(BlackJackLobby[lobby][Table4Id] < 1000)
	{
	    new name[24];
		GetPlayerName(BlackJackLobby[lobby][Table4Id], name, 24);

		PlayerTextDrawShow(playerid, bj_members_name[playerid][3]);
		PlayerTextDrawSetString(playerid, bj_members_name[playerid][3], name);


		PlayerTextDrawShow(playerid, bj_card_table[playerid][4][0]); PlayerTextDrawShow(playerid, bj_card_table[playerid][4][1]); PlayerTextDrawShow(playerid, bj_card_table[playerid][4][2]); PlayerTextDrawShow(playerid, bj_card_table[playerid][4][3]);

		TextDrawShowForPlayer(playerid, bj_table_ready[lobby][4]);
		TextDrawSetString(bj_table_ready[lobby][4], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][4], -16776961);



		new table4 = BlackJackLobby[lobby][Table4Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table4, bj_members_name[table4][table-1]);
		PlayerTextDrawSetString(table4, bj_members_name[table4][table-1], name);


		PlayerTextDrawShow(table4, bj_card_table[table4][table][0]); PlayerTextDrawShow(table4, bj_card_table[table4][table][1]); PlayerTextDrawShow(table4, bj_card_table[table4][table][2]); PlayerTextDrawShow(table4, bj_card_table[table4][table][3]);

		TextDrawShowForPlayer(table4, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "НЕ ГОТОВ");
		TextDrawColor(bj_table_ready[lobby][table], -16776961);
	}
	SelectTextDraw(playerid, false);
	return 1;

}

stock HandleBlackjackWin(playerid, bet)
{
	new biz_id = GetPlayerInBiz(playerid);
	if(biz_id != -1 && GetBusinessData(biz_id, B_TYPE) == BUSINESS_TYPE_CASINO)
	{
		AddBusinessData(biz_id, B_BALANCE, -, bet);
		if(GetBusinessData(biz_id, B_BALANCE) < 0) SetBusinessData(biz_id, B_BALANCE, 0);

		new bj_win_query[128];
		format(bj_win_query, sizeof bj_win_query, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
		mysql_query(mysql, bj_win_query, false);
	}
	GivePlayerMoneyEx(playerid, bet * 2);
	return 1;
}

stock BJ_CasinoTakeLose(playerid, bet)
{
	new biz_id = GetPlayerInBiz(playerid);
	if(biz_id == -1) return 0;
	if(GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CASINO) return 0;

	AddBusinessData(biz_id, B_BALANCE, +, bet);

	new bj_lose_query[128];
	format(bj_lose_query, sizeof bj_lose_query, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
	mysql_query(mysql, bj_lose_query, false);

	return bet;
}

stock ExitPlayerLobby(playerid, lobby, table)
{
    switch(table)
	{
	    case 1: BlackJackLobby[lobby][Table1Id] = 1000;
	    case 2: BlackJackLobby[lobby][Table2Id] = 1000;
	    case 3: BlackJackLobby[lobby][Table3Id] = 1000;
	    case 4: BlackJackLobby[lobby][Table4Id] = 1000;
	}
	pBJInfo[playerid][OnLobby] = false;
	pBJInfo[playerid][pBJLobby] = 10;
	pBJInfo[playerid][pBJBet] = 0;
	pBJInfo[playerid][pBJTakedCard] = 0;

    TextDrawHideForPlayer(playerid, bj_fon);
	TextDrawHideForPlayer(playerid, bj_double);
	TextDrawHideForPlayer(playerid, bj_stop);
	TextDrawHideForPlayer(playerid, bj_play);
	TextDrawHideForPlayer(playerid, bj_take);
	TextDrawHideForPlayer(playerid, bj_exit);
	TextDrawHideForPlayer(playerid, bj_dealer_score);
	PlayerTextDrawHide(playerid, bj_dealer_point[playerid]);
	TextDrawHideForPlayer(playerid, bj_help);
	TextDrawHideForPlayer(playerid, bj_log_text[lobby][0]);
	TextDrawHideForPlayer(playerid, bj_log_text[lobby][1]);

	TextDrawHideForPlayer(playerid, bj_table_ready[lobby][1]);
	TextDrawHideForPlayer(playerid, bj_table_ready[lobby][2]);
	TextDrawHideForPlayer(playerid, bj_table_ready[lobby][3]);
	TextDrawHideForPlayer(playerid, bj_table_ready[lobby][4]);

    PlayerTextDrawHide(playerid, bj_panel_info[playerid]);
    PlayerTextDrawSetString(playerid, bj_panel_info[playerid], "br_tex_gui:brbjyouturn");

	TextDrawHideForPlayer(playerid, bj_dealer_card[lobby][1]);
	TextDrawHideForPlayer(playerid, bj_dealer_card[lobby][2]);
	TextDrawHideForPlayer(playerid, bj_dealer_card[lobby][3]);

	TextDrawHideForPlayer(playerid, bj_text_bet[0]);
	TextDrawHideForPlayer(playerid, bj_text_bet[1]);

	TextDrawHideForPlayer(playerid, bj_text_start_time);
	TextDrawHideForPlayer(playerid, bj_text_start_timer[lobby]);

	PlayerTextDrawHide(playerid, bj_bet[playerid]);
	PlayerTextDrawHide(playerid, bj_money[playerid]);

	PlayerTextDrawHide(playerid, bj_members_name[playerid][0]);
	PlayerTextDrawHide(playerid, bj_members_name[playerid][1]);
	PlayerTextDrawHide(playerid, bj_members_name[playerid][2]);
	PlayerTextDrawHide(playerid, bj_members_name[playerid][3]);

	TextDrawHideForPlayer(playerid, bj_text_point_table[lobby][0]);
	TextDrawHideForPlayer(playerid, bj_text_point_table[lobby][1]);
	TextDrawHideForPlayer(playerid, bj_text_point_table[lobby][2]);
	TextDrawHideForPlayer(playerid, bj_text_point_table[lobby][3]);

    TextDrawHideForPlayer(playerid, bj_result_table[lobby][0]);
    TextDrawHideForPlayer(playerid, bj_result_table[lobby][1]);
    TextDrawHideForPlayer(playerid, bj_result_table[lobby][2]);
    TextDrawHideForPlayer(playerid, bj_result_table[lobby][3]);

	SendChatBlock(playerid, false);

	for(new i = 1; i <= 4; i++)
	{
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][0]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][1]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][2]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][3]);

		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][0], "br_tex_gui:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][1], "br_tex_gui:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][2], "br_tex_gui:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][3], "br_tex_gui:cardscard");

		new apponent;
	    switch(i)
	    {
	        case 1:
			{
				if(BlackJackLobby[lobby][Table1Id] < 1000) apponent = BlackJackLobby[lobby][Table1Id];
				else apponent = 1000;
			}
	        case 2:
			{
				if(BlackJackLobby[lobby][Table2Id] < 1000) apponent = BlackJackLobby[lobby][Table2Id];
				else apponent = 1000;
			}
	        case 3:
			{
				if(BlackJackLobby[lobby][Table3Id] < 1000) apponent = BlackJackLobby[lobby][Table3Id];
				else apponent = 1000;
			}
	        case 4:
			{
				if(BlackJackLobby[lobby][Table4Id] < 1000) apponent = BlackJackLobby[lobby][Table4Id];
				else apponent = 1000;
			}
	   	}
		if(apponent < 1000)
		{
			PlayerTextDrawHide(apponent, bj_members_name[apponent][table-1]);
			PlayerTextDrawHide(apponent, bj_card_table[apponent][table][0]);
			PlayerTextDrawHide(apponent, bj_card_table[apponent][table][1]);
			PlayerTextDrawHide(apponent, bj_card_table[apponent][table][2]);
			PlayerTextDrawHide(apponent, bj_card_table[apponent][table][3]);

			TextDrawHideForPlayer(apponent, bj_text_point_table[lobby][0]);
			TextDrawHideForPlayer(apponent, bj_text_point_table[lobby][1]);
			TextDrawHideForPlayer(apponent, bj_text_point_table[lobby][2]);
			TextDrawHideForPlayer(apponent, bj_text_point_table[lobby][3]);


		}
	}

	TextDrawHideForPlayer(playerid, bj_text_bj_table[lobby][0]);
	TextDrawHideForPlayer(playerid, bj_text_bj_table[lobby][1]);
	TextDrawHideForPlayer(playerid, bj_text_bj_table[lobby][2]);
	TextDrawHideForPlayer(playerid, bj_text_bj_table[lobby][3]);


	CancelSelectTextDraw(playerid);
	unFreezePlayerEx(playerid);

	foreach(new i : Player)
	{
	    ShowPlayerNameTagForPlayer(playerid, i, 1);
	}
	return 1;
}


stock LoadBlackJack()
{
	print("Загрузка блек джека");
	
	LoadTextDrawBJ();
	LoadAreaBJ();

    for(new lobby; lobby < MAX_BJ_LOBBY; lobby++)
	{
	    ReloadTable(lobby+1);
    	LoadBJLobbyTimer(lobby+1);
    	LoadBJLobbyPoint(lobby+1);
    	LoadBJLobbyReady(lobby+1);
    	LoadBJLobbyDealerCard(lobby+1);
    	LoadBJTextBlackJack(lobby+1);
    	LoadBJLobbyResult(lobby+1);

		SetTimerEx("TimerSecondUpdateBJ", 1000, true, "d", lobby+1);

		new str[] = "Очки: 0";
		utf8_to_cp1251(str);
		TextDrawSetString(bj_text_point_table[lobby+1][0], str);
		TextDrawSetString(bj_text_point_table[lobby+1][1], str);
		TextDrawSetString(bj_text_point_table[lobby+1][2], str);
		TextDrawSetString(bj_text_point_table[lobby+1][3], str);

		new str1[] = "Игра началась";
		utf8_to_cp1251(str1);
		bj_log_text[lobby+1][0] = TextDrawCreate(317.600189, 145.600067, str1);
		TextDrawLetterSize(bj_log_text[lobby+1][0], 0.375598, 1.599999);
		TextDrawAlignment(bj_log_text[lobby+1][0], 2);
		TextDrawColor(bj_log_text[lobby+1][0], -1);
		TextDrawSetShadow(bj_log_text[lobby+1][0], 0);
		TextDrawSetOutline(bj_log_text[lobby+1][0], 1);
		TextDrawBackgroundColor(bj_log_text[lobby+1][0], 51);
		TextDrawFont(bj_log_text[lobby+1][0], 1);
		TextDrawSetProportional(bj_log_text[lobby+1][0], 1);

		bj_log_text[lobby+1][1] = TextDrawCreate(317.800201, 161.533416, "");
		TextDrawLetterSize(bj_log_text[lobby+1][1], 0.377198, 1.353598);
		TextDrawAlignment(bj_log_text[lobby+1][1], 2);
		TextDrawColor(bj_log_text[lobby+1][1], -65281);
		TextDrawSetShadow(bj_log_text[lobby+1][1], 0);
		TextDrawSetOutline(bj_log_text[lobby+1][1], 1);
		TextDrawBackgroundColor(bj_log_text[lobby+1][1], 51);
		TextDrawFont(bj_log_text[lobby+1][1], 1);
		TextDrawSetProportional(bj_log_text[lobby+1][1], 1);
	}
}

stock LoadBJLobbyTimer(lobby)
{
    BlackJackLobby[lobby][StartTimer] = 60;

    bj_text_start_timer[lobby] = TextDrawCreate(316.199981, 237.693496, "00:60");
	TextDrawLetterSize(bj_text_start_timer[lobby], 0.581197, 2.563199);
	TextDrawAlignment(bj_text_start_timer[lobby], 2);
	TextDrawColor(bj_text_start_timer[lobby], -1);
	TextDrawSetShadow(bj_text_start_timer[lobby], 0);
	TextDrawSetOutline(bj_text_start_timer[lobby], 1);
	TextDrawBackgroundColor(bj_text_start_timer[lobby], 51);
	TextDrawFont(bj_text_start_timer[lobby], 1);
	TextDrawSetProportional(bj_text_start_timer[lobby], 1);
}

stock LoadBJLobbyPoint(lobby)
{
	bj_text_point_table[lobby][0] = TextDrawCreate(76.000015, 306.879913, "point 0");
	TextDrawLetterSize(bj_text_point_table[lobby][0], 0.356397, 1.174399);
	TextDrawAlignment(bj_text_point_table[lobby][0], 2);
	TextDrawColor(bj_text_point_table[lobby][0], -1);
	TextDrawSetShadow(bj_text_point_table[lobby][0], 0);
	TextDrawSetOutline(bj_text_point_table[lobby][0], 1);
	TextDrawBackgroundColor(bj_text_point_table[lobby][0], 51);
	TextDrawFont(bj_text_point_table[lobby][0], 1);
	TextDrawSetProportional(bj_text_point_table[lobby][0], 1);

	bj_text_point_table[lobby][1] = TextDrawCreate(205.799972, 146.599792, "point 0");
	TextDrawLetterSize(bj_text_point_table[lobby][1], 0.356397, 1.174399);
	TextDrawAlignment(bj_text_point_table[lobby][1], 2);
	TextDrawColor(bj_text_point_table[lobby][1], -1);
	TextDrawSetShadow(bj_text_point_table[lobby][1], 0);
	TextDrawSetOutline(bj_text_point_table[lobby][1], 1);
	TextDrawBackgroundColor(bj_text_point_table[lobby][1], 51);
	TextDrawFont(bj_text_point_table[lobby][1], 1);
	TextDrawSetProportional(bj_text_point_table[lobby][1], 1);

	bj_text_point_table[lobby][2] = TextDrawCreate(457.200195, 146.853118, "point 0");
	TextDrawLetterSize(bj_text_point_table[lobby][2], 0.356397, 1.174399);
	TextDrawAlignment(bj_text_point_table[lobby][2], 2);
	TextDrawColor(bj_text_point_table[lobby][2], -1);
	TextDrawSetShadow(bj_text_point_table[lobby][2], 0);
	TextDrawSetOutline(bj_text_point_table[lobby][2], 1);
	TextDrawBackgroundColor(bj_text_point_table[lobby][2], 51);
	TextDrawFont(bj_text_point_table[lobby][2], 1);
	TextDrawSetProportional(bj_text_point_table[lobby][2], 1);

	bj_text_point_table[lobby][3] = TextDrawCreate(560.200500, 307.133239, "point 0");
	TextDrawLetterSize(bj_text_point_table[lobby][3], 0.356397, 1.174399);
	TextDrawAlignment(bj_text_point_table[lobby][3], 2);
	TextDrawColor(bj_text_point_table[lobby][3], -1);
	TextDrawSetShadow(bj_text_point_table[lobby][3], 0);
	TextDrawSetOutline(bj_text_point_table[lobby][3], 1);
	TextDrawBackgroundColor(bj_text_point_table[lobby][3], 51);
	TextDrawFont(bj_text_point_table[lobby][3], 1);
	TextDrawSetProportional(bj_text_point_table[lobby][3], 1);
}

stock LoadAreaBJ()
{
    for(new i = 1; i < MAX_BJ_LOBBY + 1; i++) 
    {
        areabj[i] = CreateDynamicSphere(BlackJackPos[i][0], BlackJackPos[i][1], BlackJackPos[i][2], 2.0);
        new fmt[256];
        format(fmt, sizeof(fmt), "{f6fa05}Стол №%d\n{FFFFFF}Подойдите для взаимодействия", i); 
        CreateDynamic3DTextLabel(fmt, 0xFF5252FF, BlackJackPos[i][0], BlackJackPos[i][1], BlackJackPos[i][2] + 1.0, 10.0);
    }
    return 1;
}

stock LoadBJLobbyReady(lobby)
{
	new str[] = "NOT READY";
	utf8_to_cp1251(str);
	bj_table_ready[lobby][1] = TextDrawCreate(77.600013, 320.319999, str);
	TextDrawLetterSize(bj_table_ready[lobby][1], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][1], 2);
	TextDrawColor(bj_table_ready[lobby][1], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][1], 0);
	TextDrawSetOutline(bj_table_ready[lobby][1], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][1], 51);
	TextDrawFont(bj_table_ready[lobby][1], 1);
	TextDrawSetProportional(bj_table_ready[lobby][1], 1);

	new str1[] = "NOT READY";
	utf8_to_cp1251(str1);
	bj_table_ready[lobby][2] = TextDrawCreate(206.800628, 160.293167, str1);
	TextDrawLetterSize(bj_table_ready[lobby][2], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][2], 2);
	TextDrawColor(bj_table_ready[lobby][2], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][2], 0);
	TextDrawSetOutline(bj_table_ready[lobby][2], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][2], 51);
	TextDrawFont(bj_table_ready[lobby][2], 1);
	TextDrawSetProportional(bj_table_ready[lobby][2], 1);

	new str2[] = "NOT READY";
	utf8_to_cp1251(str2);
	bj_table_ready[lobby][3] = TextDrawCreate(458.200958, 160.293167, str2);
	TextDrawLetterSize(bj_table_ready[lobby][3], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][3], 2);
	TextDrawColor(bj_table_ready[lobby][3], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][3], 0);
	TextDrawSetOutline(bj_table_ready[lobby][3], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][3], 51);
	TextDrawFont(bj_table_ready[lobby][3], 1);
	TextDrawSetProportional(bj_table_ready[lobby][3], 1);

	new str3[] = "NOT READY";
	utf8_to_cp1251(str3);
	bj_table_ready[lobby][4] = TextDrawCreate(561.800598, 320.319999, str3);
	TextDrawLetterSize(bj_table_ready[lobby][4], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][4], 2);
	TextDrawColor(bj_table_ready[lobby][4], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][4], 0);
	TextDrawSetOutline(bj_table_ready[lobby][4], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][4], 51);
	TextDrawFont(bj_table_ready[lobby][4], 1);
	TextDrawSetProportional(bj_table_ready[lobby][4], 1);
}

stock LoadBJLobbyDealerCard(lobby)
{
	bj_dealer_card[lobby][1] = TextDrawCreate(209.799957, 191.399993, "br_tex_gui:cardsas");
	TextDrawLetterSize(bj_dealer_card[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_card[lobby][1], 132.000015, 174.719879);
	TextDrawAlignment(bj_dealer_card[lobby][1], 1);
	TextDrawColor(bj_dealer_card[lobby][1], -1);
	TextDrawSetShadow(bj_dealer_card[lobby][1], 0);
	TextDrawSetOutline(bj_dealer_card[lobby][1], 0);
	TextDrawFont(bj_dealer_card[lobby][1], 4);

	bj_dealer_card[lobby][2] = TextDrawCreate(235.600021, 191.653320, "br_tex_gui:cardsas");
	TextDrawLetterSize(bj_dealer_card[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_card[lobby][2], 132.000015, 174.719879);
	TextDrawAlignment(bj_dealer_card[lobby][2], 1);
	TextDrawColor(bj_dealer_card[lobby][2], -1);
	TextDrawSetShadow(bj_dealer_card[lobby][2], 0);
	TextDrawSetOutline(bj_dealer_card[lobby][2], 0);
	TextDrawFont(bj_dealer_card[lobby][2], 4);

	bj_dealer_card[lobby][3] = TextDrawCreate(314.200042, 191.906646, "br_tex_gui:cardskd");
	TextDrawLetterSize(bj_dealer_card[lobby][3], 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_card[lobby][3], 132.000015, 174.719879);
	TextDrawAlignment(bj_dealer_card[lobby][3], 1);
	TextDrawColor(bj_dealer_card[lobby][3], -1);
	TextDrawSetShadow(bj_dealer_card[lobby][3], 0);
	TextDrawSetOutline(bj_dealer_card[lobby][3], 0);
	TextDrawFont(bj_dealer_card[lobby][3], 4);
}

stock LoadBJTextBlackJack(lobby)
{
    bj_text_bj_table[lobby][0] = TextDrawCreate(31.200008, 312.106567, "br_tex_gui:brbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][0], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][0], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][0], 1);
	TextDrawColor(bj_text_bj_table[lobby][0], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][0], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][0], 0);
	TextDrawFont(bj_text_bj_table[lobby][0], 4);

	bj_text_bj_table[lobby][1] = TextDrawCreate(161.000030, 152.079727, "br_tex_gui:brbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][1], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][1], 1);
	TextDrawColor(bj_text_bj_table[lobby][1], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][1], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][1], 0);
	TextDrawFont(bj_text_bj_table[lobby][1], 4);

	bj_text_bj_table[lobby][2] = TextDrawCreate(412.400238, 152.079727, "br_tex_gui:brbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][2], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][2], 1);
	TextDrawColor(bj_text_bj_table[lobby][2], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][2], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][2], 0);
	TextDrawFont(bj_text_bj_table[lobby][2], 4);

	bj_text_bj_table[lobby][3] = TextDrawCreate(515.400390, 312.106567, "br_tex_gui:brbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][3], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][3], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][3], 1);
	TextDrawColor(bj_text_bj_table[lobby][3], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][3], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][3], 0);
	TextDrawFont(bj_text_bj_table[lobby][3], 4);
}

stock LoadBJLobbyResult(lobby)
{

	bj_result_table[lobby][0] = TextDrawCreate(88.800003, 187.666666, "br_tex_gui:brbjwin");
 	TextDrawLetterSize(		bj_result_table[lobby][0], 0.000000, 0.000000);
	TextDrawTextSize( 		bj_result_table[lobby][0], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][0], 1);
	TextDrawColor(			bj_result_table[lobby][0], -1);
	TextDrawSetShadow(		bj_result_table[lobby][0], 0);
	TextDrawSetOutline(		bj_result_table[lobby][0], 0);
	TextDrawFont(			bj_result_table[lobby][0], 4);

	bj_result_table[lobby][1] = TextDrawCreate(215.400009, 27.133293, "br_tex_gui:brbjlose");
 	TextDrawLetterSize(		bj_result_table[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(		bj_result_table[lobby][1], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][1], 1);
	TextDrawColor(			bj_result_table[lobby][1], -1);
	TextDrawSetShadow(		bj_result_table[lobby][1], 0);
	TextDrawSetOutline(		bj_result_table[lobby][1], 0);
	TextDrawFont(			bj_result_table[lobby][1], 4);

	bj_result_table[lobby][2] = TextDrawCreate(466.800170, 27.133293, "br_tex_gui:brbjmydraw");
	TextDrawLetterSize(		bj_result_table[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(		bj_result_table[lobby][2], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][2], 1);
	TextDrawColor(			bj_result_table[lobby][2], -1);
	TextDrawSetShadow(		bj_result_table[lobby][2], 0);
	TextDrawSetOutline(		bj_result_table[lobby][2], 0);
	TextDrawFont(			bj_result_table[lobby][2], 4);

	bj_result_table[lobby][3] = TextDrawCreate(569.000610, 187.666666, "br_tex_gui:brbjmydraw");
	TextDrawLetterSize(		bj_result_table[lobby][3], 0.000000, 0.000000);
	TextDrawTextSize(		bj_result_table[lobby][3], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][3], 1);
	TextDrawColor(			bj_result_table[lobby][3], -1);
	TextDrawSetShadow(		bj_result_table[lobby][3], 0);
	TextDrawSetOutline(		bj_result_table[lobby][3], 0);
	TextDrawFont(			bj_result_table[lobby][3], 4);


}

stock ReloadTable(lobby)
{
    BlackJackLobby[lobby][Table1Id] = 1000;
    BlackJackLobby[lobby][Table2Id] = 1000;
    BlackJackLobby[lobby][Table3Id] = 1000;
    BlackJackLobby[lobby][Table4Id] = 1000;
}


forward TimerSecondUpdateBJ(lobby);
public TimerSecondUpdateBJ(lobby)
{
	new bool:members;
	if(BlackJackLobby[lobby][Table1Id] < 1000) members = true;
	else if(BlackJackLobby[lobby][Table2Id] < 1000) members = true;
	else if(BlackJackLobby[lobby][Table3Id] < 1000) members = true;
	else if(BlackJackLobby[lobby][Table4Id] < 1000) members = true;

	if(members == true)
	{
		BlackJackLobby[lobby][ActivedLobby] = true;
	    if(BlackJackLobby[lobby][StartedLobby])
	    {
			switch(BlackJackLobby[lobby][StageLobby])
			{
			    case 1:
			    {

		     		if(BlackJackLobby[lobby][Table1Id] < 1000)
					{
						for(new table; table < 4; table++)
						{
							PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table+1][0]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table+1][1]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table+1][2]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table+1][3]);
						}
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_play);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_score);
						PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]]);
						PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], "0");

						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_table_ready[lobby][1]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_table_ready[lobby][2]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_table_ready[lobby][3]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_table_ready[lobby][4]);

						TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);

						TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_point_table[lobby][0]);
						if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_point_table[lobby][1]);
						if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_point_table[lobby][2]);
						if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_point_table[lobby][3]);
					}
					if(BlackJackLobby[lobby][Table2Id] < 1000)
					{
						for(new table; table < 4; table++)
						{
							PlayerTextDrawHide(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table+1][0]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table+1][1]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table+1][2]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table+1][3]);
						}
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_play);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_score);
						PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]]);
						PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], "0");

						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_table_ready[lobby][1]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_table_ready[lobby][2]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_table_ready[lobby][3]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_table_ready[lobby][4]);

						TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);

						if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_point_table[lobby][0]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_point_table[lobby][1]);
						if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_point_table[lobby][2]);
						if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_point_table[lobby][3]);
					}
					if(BlackJackLobby[lobby][Table3Id] < 1000)
					{
						for(new table; table < 4; table++)
						{
							PlayerTextDrawHide(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table+1][0]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table+1][1]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table+1][2]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table+1][3]);
						}
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_play);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_score);
						PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]]);
						PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], "0");

						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_table_ready[lobby][1]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_table_ready[lobby][2]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_table_ready[lobby][3]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_table_ready[lobby][4]);

						TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);

						if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_point_table[lobby][0]);
						if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_point_table[lobby][1]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_point_table[lobby][2]);
						if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_point_table[lobby][3]);
					}
					if(BlackJackLobby[lobby][Table4Id] < 1000)
					{
						for(new table; table < 4; table++)
						{
							PlayerTextDrawHide(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table+1][0]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table+1][1]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table+1][2]);
							PlayerTextDrawHide(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table+1][3]);
						}
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_play);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_score);
						PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]]);
						PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], "0");

						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_table_ready[lobby][1]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_table_ready[lobby][2]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_table_ready[lobby][3]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_table_ready[lobby][4]);

						TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);

						if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_point_table[lobby][0]);
						if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_point_table[lobby][1]);
						if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_point_table[lobby][2]);
						TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_point_table[lobby][3]);
					}

				 	BlackJackLobby[lobby][StageLobby]++; BlackJackLobby[lobby][DealerTurnGived]++; 
				}


				case 2:
				{
				    switch(BlackJackLobby[lobby][DealerTurnGived])
				    {
				        case 1:
						{
							BlackJackLobby[lobby][DealerTurnGived] = 0; SetTimerEx("TimerDealerNext", 2000, false, "d", lobby);
							TextDrawSetString(bj_log_text[lobby][0], "Дилер раздает карты");
							TextDrawColor(bj_log_text[lobby][0], -1);
							TextDrawSetString(bj_log_text[lobby][1], "");
							TextDrawColor(bj_log_text[lobby][1], -65281);

					        new dealer_suit = random(13);
							new dealer_type = random(4);

							BlackJackLobby[lobby][DealerPoint] += BlackJackCard[dealer_suit][dealer_type][Pointscore];
							TextDrawSetString(bj_dealer_card[lobby][1], BlackJackCard[dealer_suit][dealer_type][Cardtexture]);

							if(BlackJackLobby[lobby][Table1Id] < 1000)
							{
								new str[2];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str);
								TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_card[lobby][1]);
							}
							if(BlackJackLobby[lobby][Table2Id] < 1000)
							{
								new str[2];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], str);
								TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_card[lobby][1]);
							}
							if(BlackJackLobby[lobby][Table3Id] < 1000)
							{
								new str[2];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], str);
								TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_card[lobby][1]);
							}
							if(BlackJackLobby[lobby][Table4Id] < 1000)
							{
								new str[2];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], str);
								TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_card[lobby][1]);
							}
						}
						case 2: BlackJackLobby[lobby][DealerTurnGived]++;
						case 3:
						{
							if(BlackJackLobby[lobby][Table1Id] < 1000)
							{
	                            BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str);

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table1Point] += BlackJackCard[suit][type][Pointscore];

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table1Point]);
								TextDrawSetString(bj_text_point_table[lobby][0], str);

								ShowMembersCardBJL(lobby, 1, 0, suit, type);

							}
							else BlackJackLobby[lobby][DealerTurnGived] = 5;
						}
						case 4: BlackJackLobby[lobby][DealerTurnGived]++;

						case 5:
						{
						    if(BlackJackLobby[lobby][Table2Id] < 1000)
							{
		                      	BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table2Point] += BlackJackCard[suit][type][Pointscore];

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table2Point]);
								TextDrawSetString(bj_text_point_table[lobby][1], str);

								ShowMembersCardBJL(lobby, 2, 0, suit, type);

							}
							else BlackJackLobby[lobby][DealerTurnGived] = 7;

						}
						case 6: BlackJackLobby[lobby][DealerTurnGived]++;

						case 7:
						{
						    if(BlackJackLobby[lobby][Table3Id] < 1000)
							{
	                            BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table3Point] += BlackJackCard[suit][type][Pointscore];

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table3Point]);
								TextDrawSetString(bj_text_point_table[lobby][2], str);

								ShowMembersCardBJL(lobby, 3, 0, suit, type);
							}
							else BlackJackLobby[lobby][DealerTurnGived] = 9;
						}
						case 8: BlackJackLobby[lobby][DealerTurnGived]++;

						case 9:
						{
							BlackJackLobby[lobby][DealerTurnGived] = 1; BlackJackLobby[lobby][StageLobby]++;
					 		if(BlackJackLobby[lobby][Table4Id] < 1000)
							{
								new str[10];

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table4Point] += BlackJackCard[suit][type][Pointscore];

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table4Point]);
								TextDrawSetString(bj_text_point_table[lobby][3], str);

								ShowMembersCardBJL(lobby, 4, 0, suit, type);
							}
						}
					}
				}


				case 3:
				{
				    switch(BlackJackLobby[lobby][DealerTurnGived])
				    {
				        case 1:
				        {
							TextDrawSetString(bj_dealer_card[lobby][2], "br_tex_gui:cardscard");

							BlackJackLobby[lobby][DealerTurnGived]++;

							if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_card[lobby][2]);
							if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_card[lobby][2]);
							if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_card[lobby][2]);
							if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_card[lobby][2]);
						}
						case 2: BlackJackLobby[lobby][DealerTurnGived]++;
						case 3:
						{
							if(BlackJackLobby[lobby][Table1Id] < 1000)
							{
	                            BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str);

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table1Point] += BlackJackCard[suit][type][Pointscore];
								CheckTableBlackJack(lobby, 1);


								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table1Point]);
								TextDrawSetString(bj_text_point_table[lobby][0], str);

								ShowMembersCardBJL(lobby, 1, 1, suit, type);
							}
							else BlackJackLobby[lobby][DealerTurnGived] = 5;
						}
						case 4: BlackJackLobby[lobby][DealerTurnGived]++;

						case 5:
						{
						    if(BlackJackLobby[lobby][Table2Id] < 1000)
							{
	                            BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], str);

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table2Point] += BlackJackCard[suit][type][Pointscore];
								CheckTableBlackJack(lobby, 2);

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table2Point]);
								TextDrawSetString(bj_text_point_table[lobby][1], str);

								ShowMembersCardBJL(lobby, 2, 1, suit, type);
							}
							else BlackJackLobby[lobby][DealerTurnGived] = 7;

						}
						case 6: BlackJackLobby[lobby][DealerTurnGived]++;

						case 7:
						{
						    if(BlackJackLobby[lobby][Table3Id] < 1000)
							{
		                  		BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], str);

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table3Point] += BlackJackCard[suit][type][Pointscore];
								CheckTableBlackJack(lobby, 3);

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table3Point]);
								TextDrawSetString(bj_text_point_table[lobby][2], str);

								ShowMembersCardBJL(lobby, 3, 1, suit, type);
							}
							else BlackJackLobby[lobby][DealerTurnGived] = 9;
						}
						case 8: BlackJackLobby[lobby][DealerTurnGived]++;

						case 9:
						{
							BlackJackLobby[lobby][DealerTurnGived] = 0; BlackJackLobby[lobby][StageLobby]++; BlackJackLobby[lobby][TableTurn]++; 
					 		if(BlackJackLobby[lobby][Table4Id] < 1000)
							{
		                      	BlackJackLobby[lobby][DealerTurnGived]++;
								new str[10];
								format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);
								PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], str);

								new suit = random(13);
								new type = random(4);

								BlackJackLobby[lobby][Table4Point] += BlackJackCard[suit][type][Pointscore];
								CheckTableBlackJack(lobby, 4);

								new str1[] = "очки: %d";
								format(str, sizeof str, str1, BlackJackLobby[lobby][Table4Point]);
								TextDrawSetString(bj_text_point_table[lobby][3], str);

								ShowMembersCardBJL(lobby, 4, 1, suit, type);
							}
						}
					}


				}

				case 4:
				{
				    switch(BlackJackLobby[lobby][TableTurn])
				    {
				        case 1:
				        {
				            if(BlackJackLobby[lobby][Table1Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table1Point] == 21 || BlackJackLobby[lobby][Table1Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table1Id]);

         							new str[24];
       						 	new str1[] = "Осталось времени 00:15";
									TextDrawSetString(bj_log_text[lobby][0], str1);
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table1Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

									new str2[] = "Время вышло";
                                    TextDrawSetString(bj_log_text[lobby][0], str2);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
        							new str1[] = "Осталось времени 00:%02d";
         							format(str, sizeof str, str1, BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
				        }
				        case 2:
				        {
				            if(BlackJackLobby[lobby][Table2Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table2Point] == 21 || BlackJackLobby[lobby][Table2Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table2Id]);

         							new str[24];
        							new str1[] = "Осталось времени 00:15";
									TextDrawSetString(bj_log_text[lobby][0], str1);
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table2Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

									new str2[] = "Время вышло";
                                    TextDrawSetString(bj_log_text[lobby][0], str2);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
        							new str1[] = "Осталось времени 00:%02d";
         							format(str, sizeof str, str1, BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
				        }
				        case 3:
				        {
				            if(BlackJackLobby[lobby][Table3Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table3Point] == 21 || BlackJackLobby[lobby][Table3Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table3Id]);

         							new str[24];
        							new str1[] = "Осталось времени 00:15";
									TextDrawSetString(bj_log_text[lobby][0], str1);
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table3Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

									new str2[] = "Время вышло";
                                    TextDrawSetString(bj_log_text[lobby][0], str2);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
        							new str1[] = "Осталось времени 00:%02d";
         							format(str, sizeof str, str1, BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
				        }
				        case 4:
				        {
				            if(BlackJackLobby[lobby][Table4Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table4Point] == 21 || BlackJackLobby[lobby][Table4Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table4Id]);

         							new str[24];
        							new str1[] = "Осталось времени 00:15";
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table4Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

									new str2[] = "Время вышло";
                                    TextDrawSetString(bj_log_text[lobby][0], str2);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
        							new str1[] = "Осталось времени 00:%02d";
         							format(str, sizeof str, str1, BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
				        }
				        case 5: { BlackJackLobby[lobby][TableTurn] = 0; BlackJackLobby[lobby][TableTurnTime] = 0; BlackJackLobby[lobby][StageLobby]++; }

				    }
				}

				case 5:
				{
					new str[] = "Дилер открывает карту";
					TextDrawSetString(bj_log_text[lobby][0], str);
					TextDrawColor(bj_log_text[lobby][0], -1);
					TextDrawSetString(bj_log_text[lobby][1], "");
					TextDrawColor(bj_log_text[lobby][1], -65281);

			        new dealer_suit = random(13);
					new dealer_type = random(4);

					BlackJackLobby[lobby][DealerPoint] += BlackJackCard[dealer_suit][dealer_type][Pointscore];


					TextDrawSetString(bj_dealer_card[lobby][2], BlackJackCard[dealer_suit][dealer_type][Cardtexture]);


					new str1[10];
					format(str1, sizeof str1, "%d", BlackJackLobby[lobby][DealerPoint]);

					if(BlackJackLobby[lobby][Table1Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_card[lobby][2]);
					if(BlackJackLobby[lobby][Table2Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_card[lobby][2]);
					if(BlackJackLobby[lobby][Table3Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_card[lobby][2]);
					if(BlackJackLobby[lobby][Table4Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_card[lobby][2]);

					if(BlackJackLobby[lobby][DealerPoint] < 16) BlackJackLobby[lobby][StageLobby]++;
					else BlackJackLobby[lobby][StageLobby] = 7;
				}
				case 6:
				{
			        new dealer_suit = random(13);
					new dealer_type = random(4);

					BlackJackLobby[lobby][DealerPoint] += BlackJackCard[dealer_suit][dealer_type][Pointscore];


					TextDrawSetString(bj_dealer_card[lobby][3], BlackJackCard[dealer_suit][dealer_type][Cardtexture]);

					new str1[] = "Дилер взял карту";
					TextDrawSetString(bj_log_text[lobby][0], str1);
					TextDrawColor(bj_log_text[lobby][0], -1);

					new str[10];
					format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);

					if(BlackJackLobby[lobby][Table1Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table2Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table3Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table4Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_card[lobby][3]);

					BlackJackLobby[lobby][StageLobby]++;
				}
				case 7:
				{
				TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
				TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
				TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]);
						TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);
					if(BlackJackLobby[lobby][Table1Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table1Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table1Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
				            GivePlayerMoneyEx(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][0], "br_tex_gui:brbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table1Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);

					            TextDrawSetString(bj_result_table[lobby][0], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][0], "br_tex_gui:brbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table1Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);

					            TextDrawSetString(bj_result_table[lobby][0], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table1Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][0], "br_tex_gui:brbjwin");
					    }
					}

					if(BlackJackLobby[lobby][Table2Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table2Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table2Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
				            GivePlayerMoneyEx(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][1], "br_tex_gui:brbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table2Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);

					            TextDrawSetString(bj_result_table[lobby][1], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][1], "br_tex_gui:brbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table2Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);

					            TextDrawSetString(bj_result_table[lobby][1], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table2Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][1], "br_tex_gui:brbjwin");
					    }
					}


					if(BlackJackLobby[lobby][Table3Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table3Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table3Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
				            GivePlayerMoneyEx(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][2], "br_tex_gui:brbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table3Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);

					            TextDrawSetString(bj_result_table[lobby][2], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][2], "br_tex_gui:brbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table3Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);

					            TextDrawSetString(bj_result_table[lobby][2], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table3Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][2], "br_tex_gui:brbjwin");
					    }
					}

					if(BlackJackLobby[lobby][Table4Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table4Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table4Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
				            GivePlayerMoneyEx(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][3], "br_tex_gui:brbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table4Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);

					            TextDrawSetString(bj_result_table[lobby][3], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][3], "br_tex_gui:brbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table4Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);

					            TextDrawSetString(bj_result_table[lobby][3], "br_tex_gui:brbjlose");

					BJ_CasinoTakeLose(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table4Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "br_tex_gui:brbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
					            HandleBlackjackWin(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);

					            TextDrawSetString(bj_result_table[lobby][3], "br_tex_gui:brbjwin");
					    }
     				}


					BlackJackLobby[lobby][StageLobby]++;
				}
				case 8:
				{
     				if(BlackJackLobby[lobby][Table1Id] < 1000)
			 		{
					 	TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_result_table[lobby][0]);
					 	if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_result_table[lobby][1]);
					 	if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_result_table[lobby][2]);
					 	if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_result_table[lobby][3]);
				    }
     				if(BlackJackLobby[lobby][Table2Id] < 1000)
			 		{
					 	if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_result_table[lobby][0]);
					 	TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_result_table[lobby][1]);
					 	if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_result_table[lobby][2]);
					 	if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_result_table[lobby][3]);
				    }
     				if(BlackJackLobby[lobby][Table3Id] < 1000)
			 		{
					 	if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_result_table[lobby][0]);
					 	if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_result_table[lobby][1]);
					 	TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_result_table[lobby][2]);
					 	if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_result_table[lobby][3]);
				    }
     				if(BlackJackLobby[lobby][Table4Id] < 1000)
			 		{
					 	if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_result_table[lobby][0]);
					 	if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_result_table[lobby][1]);
					 	if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_result_table[lobby][2]);
					 	TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_result_table[lobby][3]);
				    }
					BlackJackLobby[lobby][StageLobby]++;
				}
				case 9: BlackJackLobby[lobby][StageLobby]++;
				case 10: BlackJackLobby[lobby][StageLobby]++;
				case 11: 
				{
					new str[] = "очки: 0";
	            	TextDrawSetString(bj_text_point_table[lobby][0], str);
					TextDrawSetString(bj_text_point_table[lobby][1], str);
					TextDrawSetString(bj_text_point_table[lobby][2], str);
					TextDrawSetString(bj_text_point_table[lobby][3], str);

					BlackJackLobby[lobby][Table1Result] = 0;
					BlackJackLobby[lobby][Table2Result] = 0;
					BlackJackLobby[lobby][Table3Result] = 0;
					BlackJackLobby[lobby][Table4Result] = 0;

					BlackJackLobby[lobby][StageLobby]++;
				}
				case 12:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table1Id] < 1000)
					{
						new bj_p = BlackJackLobby[lobby][Table1Id];
						PlayerTextDrawSetString(bj_p, bj_dealer_point[bj_p], "0");
						ExitPlayerLobby(bj_p, lobby, 1);

						BlackJackLobby[lobby][Table1Id] = bj_p;
						pBJInfo[bj_p][OnLobby] = true;
						pBJInfo[bj_p][pBJLobby] = lobby;
						InitPlayerLobby(bj_p, lobby, 1);
					}
				}
				case 13:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table2Id] < 1000)
					{
						new bj_p = BlackJackLobby[lobby][Table2Id];
						PlayerTextDrawSetString(bj_p, bj_dealer_point[bj_p], "0");
						ExitPlayerLobby(bj_p, lobby, 2);

						BlackJackLobby[lobby][Table2Id] = bj_p;
						pBJInfo[bj_p][OnLobby] = true;
						pBJInfo[bj_p][pBJLobby] = lobby;
						InitPlayerLobby(bj_p, lobby, 2);
					}
				}
				case 14:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table3Id] < 1000)
					{
						new bj_p = BlackJackLobby[lobby][Table3Id];
						PlayerTextDrawSetString(bj_p, bj_dealer_point[bj_p], "0");
						ExitPlayerLobby(bj_p, lobby, 3);

						BlackJackLobby[lobby][Table3Id] = bj_p;
						pBJInfo[bj_p][OnLobby] = true;
						pBJInfo[bj_p][pBJLobby] = lobby;
						InitPlayerLobby(bj_p, lobby, 3);
					}
				}
				case 15:
				{
    				BlackJackLobby[lobby][StageLobby] = 0;
					BlackJackLobby[lobby][StartedLobby] = false;
					if(BlackJackLobby[lobby][Table4Id] < 1000)
					{
						new bj_p = BlackJackLobby[lobby][Table4Id];
						PlayerTextDrawSetString(bj_p, bj_dealer_point[bj_p], "0");
						ExitPlayerLobby(bj_p, lobby, 4);

						BlackJackLobby[lobby][Table4Id] = bj_p;
						pBJInfo[bj_p][OnLobby] = true;
						pBJInfo[bj_p][pBJLobby] = lobby;
						InitPlayerLobby(bj_p, lobby, 4);
					}
				}
			}
	    }
		else
	    {
	        if(BlackJackLobby[lobby][StartTimer]-1 == 0)
			{
				BlackJackLobby[lobby][StartedLobby] = true; BlackJackLobby[lobby][StageLobby] = 1; BJ_ShowNotification(lobby, 3, "Игра началась...");

				printf("Стол 1: %d", BlackJackLobby[lobby][Table1Id]);
				printf("Стол 2: %d", BlackJackLobby[lobby][Table2Id]);
				printf("Стол 3: %d", BlackJackLobby[lobby][Table3Id]);
				printf("Стол 4: %d", BlackJackLobby[lobby][Table4Id]);

				new str[15];

			    if(BlackJackLobby[lobby][Table1Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]) { ShowNotificationSile(BlackJackLobby[lobby][Table1Id], 2, 5, -1, -1, "Вы не поставили ставку, и были кикнуты", ""); ExitPlayerLobby(BlackJackLobby[lobby][Table1Id], lobby, 1); }
					else { GivePlayerMoneyEx(BlackJackLobby[lobby][Table1Id], -pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]); format(str, sizeof str, "%d руб", GetPlayerMoney(BlackJackLobby[lobby][Table1Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_money[BlackJackLobby[lobby][Table1Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table2Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]) { ShowNotificationSile(BlackJackLobby[lobby][Table1Id], 2, 5, -1, -1, "Вы не поставили ставку, и были кикнуты", ""); ExitPlayerLobby(BlackJackLobby[lobby][Table2Id], lobby, 2); }
					else { GivePlayerMoneyEx(BlackJackLobby[lobby][Table2Id], -pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]); format(str, sizeof str, "%d руб", GetPlayerMoney(BlackJackLobby[lobby][Table2Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_money[BlackJackLobby[lobby][Table2Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table3Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]) { ShowNotificationSile(BlackJackLobby[lobby][Table1Id], 2, 5, -1, -1, "Вы не поставили ставку, и были кикнуты", ""); ExitPlayerLobby(BlackJackLobby[lobby][Table3Id], lobby, 3); }
					else { GivePlayerMoneyEx(BlackJackLobby[lobby][Table3Id], -pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]); format(str, sizeof str, "%d руб", GetPlayerMoney(BlackJackLobby[lobby][Table3Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_money[BlackJackLobby[lobby][Table3Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table4Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]) { ShowNotificationSile(BlackJackLobby[lobby][Table1Id], 2, 5, -1, -1, "Вы не поставили ставку, и были кикнуты", ""); ExitPlayerLobby(BlackJackLobby[lobby][Table4Id], lobby, 4); }
					else { GivePlayerMoneyEx(BlackJackLobby[lobby][Table4Id], -pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]); format(str, sizeof str, "%d руб", GetPlayerMoney(BlackJackLobby[lobby][Table4Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_money[BlackJackLobby[lobby][Table4Id]], str); }
				}



				BlackJackLobby[lobby][StartTimer] = 60;

				if(BlackJackLobby[lobby][Table1Id] < 1000) {
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_start_time);
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_start_timer[lobby]);
				}
				if(BlackJackLobby[lobby][Table2Id] < 1000) {
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_start_time);
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_start_timer[lobby]);
				}
				if(BlackJackLobby[lobby][Table3Id] < 1000) {
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_start_time);
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_start_timer[lobby]);
				}
				if(BlackJackLobby[lobby][Table4Id] < 1000) {
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_start_time);
					TextDrawHideForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_start_timer[lobby]);
				}
			}
		    else
			{
				BlackJackLobby[lobby][StartTimer]--;
			    new timer[6];
				format(timer, sizeof timer, "00:%02d", BlackJackLobby[lobby][StartTimer]);
				TextDrawSetString(bj_text_start_timer[lobby], timer);
			}
	    }
	}
	else
	{ 
	    BlackJackLobby[lobby][ActivedLobby] = false;
		BlackJackLobby[lobby][StartedLobby] = false;
		BlackJackLobby[lobby][StartTimer] = 60;
		BlackJackLobby[lobby][StageLobby] = 0;
		BlackJackLobby[lobby][TableTurnTime] = 0;
		BlackJackLobby[lobby][TableTurn] = 0;
	    BlackJackLobby[lobby][DealerPoint] = 0;

		TextDrawSetString(bj_text_start_timer[lobby], "00:60");

		BlackJackLobby[lobby][Table1Point] = 0;
		BlackJackLobby[lobby][Table2Point] = 0;
		BlackJackLobby[lobby][Table3Point] = 0;
		BlackJackLobby[lobby][Table4Point] = 0;

		BlackJackLobby[lobby][Table1Result] = 0;
		BlackJackLobby[lobby][Table2Result] = 0;
		BlackJackLobby[lobby][Table3Result] = 0;
		BlackJackLobby[lobby][Table4Result] = 0;
	}
	return 1;
}

forward TimerDealerNext(lobby);
public TimerDealerNext(lobby)
{
	BlackJackLobby[lobby][DealerTurnGived] = 3;
}

forward TimerHideBetText(playerid);
public TimerHideBetText(playerid)
{
	TextDrawHideForPlayer(playerid, bj_text_bet[0]);
	TextDrawHideForPlayer(playerid, bj_text_bet[1]);
}
forward TimerHideYouTurn(playerid);
public TimerHideYouTurn(playerid) PlayerTextDrawHide(playerid, bj_panel_info[playerid]);



stock SCMBJL(lobby, color, message[]) 
{
	if(BlackJackLobby[lobby][Table1Id] < 1000) SCM(BlackJackLobby[lobby][Table1Id], color, message);
	if(BlackJackLobby[lobby][Table2Id] < 1000) SCM(BlackJackLobby[lobby][Table2Id], color, message);
	if(BlackJackLobby[lobby][Table3Id] < 1000) SCM(BlackJackLobby[lobby][Table3Id], color, message);
	if(BlackJackLobby[lobby][Table4Id] < 1000) SCM(BlackJackLobby[lobby][Table4Id], color, message);
}

stock BJ_ShowNotification(lobby, type, message[]) 
{
	if(BlackJackLobby[lobby][Table1Id] < 1000) ShowNotificationSile(BlackJackLobby[lobby][Table1Id], type, 5, -1, -1, message, "");
	if(BlackJackLobby[lobby][Table2Id] < 1000) ShowNotificationSile(BlackJackLobby[lobby][Table1Id], type, 5, -1, -1, message, "");
	if(BlackJackLobby[lobby][Table3Id] < 1000) ShowNotificationSile(BlackJackLobby[lobby][Table1Id], type, 5, -1, -1, message, "");
	if(BlackJackLobby[lobby][Table4Id] < 1000) ShowNotificationSile(BlackJackLobby[lobby][Table1Id], type, 5, -1, -1, message, "");
}

stock CheckTableBlackJack(lobby, table)
{
	switch(table)
	{
	    case 1:
		{
			if(BlackJackLobby[lobby][Table1Point] == 21) GiveTableBlackJack(lobby, BlackJackLobby[lobby][Table1Id], table);
			else if(BlackJackLobby[lobby][Table1Point] > 21) GiveTableLose(lobby, BlackJackLobby[lobby][Table1Id]);
		}
	    case 2:
		{
			if(BlackJackLobby[lobby][Table2Point] == 21) GiveTableBlackJack(lobby, BlackJackLobby[lobby][Table2Id], table);
			else if(BlackJackLobby[lobby][Table2Point] > 21) GiveTableLose(lobby, BlackJackLobby[lobby][Table2Id]);
		}
	    case 3:
		{
			if(BlackJackLobby[lobby][Table3Point] == 21) GiveTableBlackJack(lobby, BlackJackLobby[lobby][Table3Id], table);
			else if(BlackJackLobby[lobby][Table4Point] > 21) GiveTableLose(lobby, BlackJackLobby[lobby][Table3Id]);
		}
	    case 4:
		{
			if(BlackJackLobby[lobby][Table4Point] == 21) GiveTableBlackJack(lobby, BlackJackLobby[lobby][Table4Id], table);
			else if(BlackJackLobby[lobby][Table4Point] > 21) GiveTableLose(lobby, BlackJackLobby[lobby][Table4Id]);
		}
	}

}

stock GiveTableBlackJack(lobby, playerid, table)
{
	if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_bj_table[lobby][table-1]);  TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_text_bj_table[lobby][table-1]);
	if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_bj_table[lobby][table-1]);  TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_text_bj_table[lobby][table-1]);
	if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_bj_table[lobby][table-1]);  TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_text_bj_table[lobby][table-1]);
	if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_bj_table[lobby][table-1]);  TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_text_bj_table[lobby][table-1]);

    PlayerTextDrawSetString(playerid, bj_panel_info[playerid], "br_tex_gui:brbjyoubj");
    BlackJackLobby[lobby][TableTurn]++;
}

stock GiveTableLose(lobby, player)
{
	new str[32];
	format(str, sizeof str, "%s проиграл", GetPlayerNameEx(player));
	BJ_ShowNotification(lobby, 2, str);
}


stock ShowMembersCardBJL(lobby, table, card, suit, type)
{
	new apponent;
	switch(table)
	{
	    case 1: apponent = BlackJackLobby[lobby][Table1Id];
	    case 2: apponent = BlackJackLobby[lobby][Table2Id];
	    case 3: apponent = BlackJackLobby[lobby][Table3Id];
	    case 4: apponent = BlackJackLobby[lobby][Table4Id];
	}
	new give[MAX_PLAYER_NAME];
	format(give, sizeof give, "%s", GetPlayerNameEx(apponent));
	TextDrawSetString(bj_log_text[lobby][0], "Игрок взял карту");
	TextDrawColor(bj_log_text[lobby][0], -1);
	TextDrawSetString(bj_log_text[lobby][1], give);
	TextDrawColor(bj_log_text[lobby][1], -65281);

	if(BlackJackLobby[lobby][Table1Id] < 1000)
	{
		PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table][card]);
        PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table][card], BlackJackCard[suit][type][Cardtexture]);
		PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_card_table[BlackJackLobby[lobby][Table1Id]][table][card]);
	}
	if(BlackJackLobby[lobby][Table2Id] < 1000)
	{
		PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table][card]);
        PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table][card], BlackJackCard[suit][type][Cardtexture]);
		PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_card_table[BlackJackLobby[lobby][Table2Id]][table][card]);
	}
	if(BlackJackLobby[lobby][Table3Id] < 1000)
	{
		PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table][card]);
        PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table][card], BlackJackCard[suit][type][Cardtexture]);
		PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_card_table[BlackJackLobby[lobby][Table3Id]][table][card]);
	}
	if(BlackJackLobby[lobby][Table4Id] < 1000)
	{
		PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table][card]);
        PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table][card], BlackJackCard[suit][type][Cardtexture]);
		PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_card_table[BlackJackLobby[lobby][Table4Id]][table][card]);
	}
}

stock StartPlayerBJ(playerid)
{
	if(pBJInfo[playerid][OnLobby] == false)
	{
		new bool:distance;
		for(new i = 1; i <= MAX_BJ_LOBBY; i++)
		{
			if(CheckPlayerDistanceToPoint(playerid, BlackJackPos[i][0], BlackJackPos[i][1], BlackJackPos[i][2], 5))
		    {
	     		distance = true;
				if(BlackJackLobby[i][StartedLobby] == false)
				{
					if(BlackJackLobby[i][Table1Id] == 1000) 	 
					{ 
						BlackJackLobby[i][Table1Id] = playerid; 
						pBJInfo[playerid][OnLobby] = true; 
						pBJInfo[playerid][pBJLobby] = i; 
						InitPlayerLobby(playerid, i, 1); 
						SendChatBlock(playerid, true);
					}
					else if(BlackJackLobby[i][Table2Id] == 1000) 
					{ 
						BlackJackLobby[i][Table2Id] = playerid; 
						pBJInfo[playerid][OnLobby] = true; 
						pBJInfo[playerid][pBJLobby] = i; 
						InitPlayerLobby(playerid, i, 2); 
						SendChatBlock(playerid, true);
					}
					else if(BlackJackLobby[i][Table3Id] == 1000) 
					{ 
						BlackJackLobby[i][Table3Id] = playerid; 
						pBJInfo[playerid][OnLobby] = true; 
						pBJInfo[playerid][pBJLobby] = i; 
						InitPlayerLobby(playerid, i, 3); 
						SendChatBlock(playerid, true);
					}
					else if(BlackJackLobby[i][Table4Id] == 1000) 
					{ 
						BlackJackLobby[i][Table4Id] = playerid; 
						pBJInfo[playerid][OnLobby] = true; 
						pBJInfo[playerid][pBJLobby] = i; 
						InitPlayerLobby(playerid, i, 4); 
						SendChatBlock(playerid, true);
					}
					else SCM(playerid, CLRED, "| "CW"Данный стол уже занят.");
				}
				else SCM(playerid, CLRED, "| "CW"На этом столе уже началась игра.");
		    }
		    else continue;
		}
		if(distance == false) SCM(playerid, CLRED, "| "CW"Вы находитесь слишком далеко от блек джека");
	}
	return 1;
}

stock LoadTextDrawBJ()
{
	bj_fon = TextDrawCreate(0.000000, 0.000000, "br_tex_gui:brbj");
	TextDrawLetterSize(bj_fon, 0.000000, 0.000000);
	TextDrawTextSize(bj_fon, 640.000000, 448.000000);
	TextDrawAlignment(bj_fon, 1);
	TextDrawColor(bj_fon, -1);
	TextDrawSetShadow(bj_fon, 0);
	TextDrawSetOutline(bj_fon, 0);
	TextDrawFont(bj_fon, 4);

	bj_play = TextDrawCreate(268.399932, 389.773345, "br_tex_gui:brbjplay");
	TextDrawLetterSize(bj_play, 0.000000, 0.000000);
	TextDrawTextSize(bj_play, 96.799949, 36.586669);
	TextDrawAlignment(bj_play, 1);
	TextDrawColor(bj_play, -1);
	TextDrawSetShadow(bj_play, 0);
	TextDrawSetOutline(bj_play, 0);
	TextDrawFont(bj_play, 4);
	TextDrawSetSelectable(bj_play, true);

	bj_double = TextDrawCreate(16.600013, 389.773345, "br_tex_gui:brbjdouble");
	TextDrawLetterSize(bj_double, 0.000000, 0.000000);
	TextDrawTextSize(bj_double, 96.799949, 36.586669);
	TextDrawAlignment(bj_double, 1);
	TextDrawColor(bj_double, -1);
	TextDrawSetShadow(bj_double, 0);
	TextDrawSetOutline(bj_double, 0);
	TextDrawFont(bj_double, 4);
	TextDrawSetSelectable(bj_double, true);

	bj_stop = TextDrawCreate(121.600059, 389.773345, "br_tex_gui:brbjstop");
	TextDrawLetterSize(bj_stop, 0.000000, 0.000000);
	TextDrawTextSize(bj_stop, 96.799949, 36.586669);
	TextDrawAlignment(bj_stop, 1);
	TextDrawColor(bj_stop, -1);
	TextDrawSetShadow(bj_stop, 0);
	TextDrawSetOutline(bj_stop, 0);
	TextDrawFont(bj_stop, 4);
	TextDrawSetSelectable(bj_stop, true);

	bj_take = TextDrawCreate(420.800231, 389.773345, "br_tex_gui:brbjtake");
	TextDrawLetterSize(bj_take, 0.000000, 0.000000);
	TextDrawTextSize(bj_take, 96.799949, 36.586669);
	TextDrawAlignment(bj_take, 1);
	TextDrawColor(bj_take, -1);
	TextDrawSetShadow(bj_take, 0);
	TextDrawSetOutline(bj_take, 0);
	TextDrawFont(bj_take, 4);
	TextDrawSetSelectable(bj_take, true);

	bj_exit = TextDrawCreate(526.200256, 389.773345, "br_tex_gui:brbjexit");
	TextDrawLetterSize(bj_exit, 0.000000, 0.000000);
	TextDrawTextSize(bj_exit, 96.799949, 36.586669);
	TextDrawAlignment(bj_exit, 1);
	TextDrawColor(bj_exit, -1);
	TextDrawSetShadow(bj_exit, 0);
	TextDrawSetOutline(bj_exit, 0);
	TextDrawFont(bj_exit, 4);
	TextDrawSetSelectable(bj_exit, true);

	bj_dealer_score = TextDrawCreate(259.000030, 388.280212, "br_tex_gui:brbjscore");
	TextDrawLetterSize(bj_dealer_score, 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_score, 115.999938, 51.520008);
	TextDrawAlignment(bj_dealer_score, 1);
	TextDrawColor(bj_dealer_score, -1);
	TextDrawSetShadow(bj_dealer_score, 0);
	TextDrawSetOutline(bj_dealer_score, 0);
	TextDrawFont(bj_dealer_score, 4);


	bj_help = TextDrawCreate(16.799999, 123.200004, "Помощь");
	TextDrawLetterSize(bj_help, 0.5, 1.0);
	TextDrawAlignment(bj_help, 1);
	TextDrawColor(bj_help, -1);
	TextDrawSetShadow(bj_help, 1);
	TextDrawSetOutline(bj_help, 1);
	TextDrawBackgroundColor(bj_help, 0x000000AA);
	TextDrawFont(bj_help, 1);
	TextDrawSetSelectable(bj_help, true);


	new str[] = "Вы успешно";
	utf8_to_cp1251(str);
	bj_text_bet[0] = TextDrawCreate(320.800018, 71.680015, str);
	TextDrawLetterSize(bj_text_bet[0], 0.405198, 1.458132);
	TextDrawAlignment(bj_text_bet[0], 2);
	TextDrawColor(bj_text_bet[0], -65281);
	TextDrawSetShadow(bj_text_bet[0], 0);
	TextDrawSetOutline(bj_text_bet[0], 1);
	TextDrawBackgroundColor(bj_text_bet[0], 51);
	TextDrawFont(bj_text_bet[0], 1);
	TextDrawSetProportional(bj_text_bet[0], 1);
	
	new str1[] = "поставили ставку";
	utf8_to_cp1251(str1);
	bj_text_bet[1] = TextDrawCreate(320.200042, 86.120002, str1);
	TextDrawLetterSize(bj_text_bet[1], 0.405198, 1.458132);
	TextDrawAlignment(bj_text_bet[1], 2);
	TextDrawColor(bj_text_bet[1], -65281);
	TextDrawSetShadow(bj_text_bet[1], 0);
	TextDrawSetOutline(bj_text_bet[1], 1);
	TextDrawBackgroundColor(bj_text_bet[1], 51);
	TextDrawFont(bj_text_bet[1], 1);
	TextDrawSetProportional(bj_text_bet[1], 1);

	new str2[] = "До начало игры";
	utf8_to_cp1251(str2);
	bj_text_start_time = TextDrawCreate(315.999969, 215.040039, str2);
	TextDrawLetterSize(bj_text_start_time, 0.581197, 2.563199);
	TextDrawAlignment(bj_text_start_time, 2);
	TextDrawColor(bj_text_start_time, -1);
	TextDrawSetShadow(bj_text_start_time, 0);
	TextDrawSetOutline(bj_text_start_time, 1);
	TextDrawBackgroundColor(bj_text_start_time, 51);
	TextDrawFont(bj_text_start_time, 1);
	TextDrawSetProportional(bj_text_start_time, 1);
}

stock LoadPlayerTextDrawBJ(playerid)
{
	new str[] = "0 руб";
	utf8_to_cp1251(str);
	bj_bet[playerid] = CreatePlayerTextDraw(playerid, 19.200004, 58.240013, str);
	PlayerTextDrawLetterSize(playerid, bj_bet[playerid], 0.291599, 1.510398);
	PlayerTextDrawAlignment(playerid, bj_bet[playerid], 1);
	PlayerTextDrawColor(playerid, bj_bet[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_bet[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_bet[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_bet[playerid], 51);
	PlayerTextDrawFont(playerid, bj_bet[playerid], 1);
	PlayerTextDrawSetProportional(playerid, bj_bet[playerid], 1);

	new str1[] = "0 руб";
	utf8_to_cp1251(str1);
	bj_money[playerid] = CreatePlayerTextDraw(playerid, 19.200004, 92.093315, str1);
	PlayerTextDrawLetterSize(playerid, bj_money[playerid], 0.291599, 1.510398);
	PlayerTextDrawAlignment(playerid, bj_money[playerid], 1);
	PlayerTextDrawColor(playerid, bj_money[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_money[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_money[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_money[playerid], 51);
	PlayerTextDrawFont(playerid, bj_money[playerid], 1);
	PlayerTextDrawSetProportional(playerid, bj_money[playerid], 1);


	bj_dealer_point[playerid] = CreatePlayerTextDraw(playerid, 317.599853, 405.440093, "21");
	PlayerTextDrawLetterSize(playerid, bj_dealer_point[playerid], 0.364398, 1.719465);
	PlayerTextDrawAlignment(playerid, bj_dealer_point[playerid], 2);
	PlayerTextDrawColor(playerid, bj_dealer_point[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_dealer_point[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_dealer_point[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_dealer_point[playerid], 51);
	PlayerTextDrawFont(playerid, bj_dealer_point[playerid], 1);
	PlayerTextDrawSetProportional(playerid, bj_dealer_point[playerid], 1);


	bj_members_name[playerid][0] = CreatePlayerTextDraw(playerid, 19.600006, 197.626632, "Wendy_Knyazev");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][0], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][0], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][0], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][0], 1);


	bj_members_name[playerid][1] = CreatePlayerTextDraw(playerid, 147.200286, 40.586555, "t.me/studio_bistt.me/studio_bist");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][1], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][1], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][1], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][1], 1);

	bj_members_name[playerid][2] = CreatePlayerTextDraw(playerid, 397.800445, 40.586555, "t.me/studio_bist");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][2], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][2], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid,		 	bj_members_name[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][2], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][2], 1);

	bj_members_name[playerid][3] = CreatePlayerTextDraw(playerid, 496.600280, 197.626632, "t.me/studio_bist");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][3], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][3], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][3], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][3], 1);







	bj_card_table[playerid][1][0] = CreatePlayerTextDraw(playerid, 2.999999, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][0], 4);

	bj_card_table[playerid][1][1] = CreatePlayerTextDraw(playerid, 22.999999, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][1], 4);

	bj_card_table[playerid][1][2] = CreatePlayerTextDraw(playerid, 42.999999, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][2], 4);

	bj_card_table[playerid][1][3] = CreatePlayerTextDraw(playerid, 62.999999, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][3], 4);





	bj_card_table[playerid][2][0] = CreatePlayerTextDraw(playerid, 129.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][0], 4);

	bj_card_table[playerid][2][1] = CreatePlayerTextDraw(playerid, 149.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][1], 4);

	bj_card_table[playerid][2][2] = CreatePlayerTextDraw(playerid, 169.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][2], 4);

	bj_card_table[playerid][2][3] = CreatePlayerTextDraw(playerid, 189.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][3], 4);





	bj_card_table[playerid][3][0] = CreatePlayerTextDraw(playerid, 380.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][0], 4);

	bj_card_table[playerid][3][1] = CreatePlayerTextDraw(playerid, 400.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][1], 4);

	bj_card_table[playerid][3][2] = CreatePlayerTextDraw(playerid, 420.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][2], 4);

	bj_card_table[playerid][3][3] = CreatePlayerTextDraw(playerid, 440.999999, 46.559913, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][3], 4);




	bj_card_table[playerid][4][0] = CreatePlayerTextDraw(playerid, 481.000000, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][0], 4);

	bj_card_table[playerid][4][1] = CreatePlayerTextDraw(playerid, 502.000000, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][1], 4);

	bj_card_table[playerid][4][2] = CreatePlayerTextDraw(playerid, 523.000000, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][2], 4);

	bj_card_table[playerid][4][3] = CreatePlayerTextDraw(playerid, 544.000000, 206.079971, "br_tex_gui:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][3], 4);



	bj_panel_info[playerid] = CreatePlayerTextDraw(playerid, 155.146667, 249.386703, "br_tex_gui:bjyouturn");
	PlayerTextDrawLetterSize(playerid, bj_panel_info[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_panel_info[playerid], 326.133239, 106.026657);
	PlayerTextDrawAlignment(playerid, bj_panel_info[playerid], 1);
	PlayerTextDrawColor(playerid, bj_panel_info[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_panel_info[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_panel_info[playerid], 0);
	PlayerTextDrawFont(playerid, bj_panel_info[playerid], 4);
	
}

stock SendChatBlock(playerid, bool:enable) 
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT8, 0,             
        PR_UINT8, enable ? 1 : 0
    );
    PR_SendRPC(bs, playerid, 168, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock BlackJack_Init()
{
	LoadBlackJack();
	return 1;
}

public OnPlayerConnect(playerid)
{
	LoadPlayerTextDrawBJ(playerid);
	#if defined BlackJack_OnPlayerConnect
		return BlackJack_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect BlackJack_OnPlayerConnect
#if defined BlackJack_OnPlayerConnect
	forward BlackJack_OnPlayerConnect(playerid);
#endif


public OnPlayerEnterDynamicArea(playerid, areaid)
{
	for(new i = 0; i < MAX_BJ_LOBBY; i++)
	{
		if(areaid == areabj[i])
		{
			ShowNotificationSile(playerid, 4, 5, OFFER_BLACKJACK, -1, "Взаимодействовать", "");
		}
	}
	#if defined BlackJack_OnPlayerEnterDynamicArea
		return BlackJack_OnPlayerEnterDynamicArea(playerid, areaid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea BlackJack_OnPlayerEnterDynamicArea
#if defined BlackJack_OnPlayerEnterDynamicArea
	forward BlackJack_OnPlayerEnterDynamicArea(playerid, areaid);
#endif


stock CheckPlayerDistanceToPoint(playerid, Float:x, Float:y, Float:z, Float: distance)
{
	if(IsPlayerInRangeOfPoint(playerid, distance, x, y, z)) return 1;
	else return 0;
}