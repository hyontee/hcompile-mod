#include 	<a_samp>
#define FILTERSCRIPT


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

#define RPC_CUSTOM_SHOW_HUD				0x35
#define RPC_CUSTOM_HIDE_HUD				0x36




#define MAX_BJ_LOBBY 1

#define SCM 			SendClientMessage
#define SCMTA   		SendClientMessageToAll
#define SPD         	ShowPlayerDialog
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

//------------------------------÷вет рации--------------------------------------

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

/*main()
{
    new a[][] =     {"Unarmed (Fist)","Brass K"};
	#pragma unused a
}*/



/*enum
{
	D_BJ_SET_BET,
    D_BJ_HELP,
}*/


//==============================================================================

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
//new Text:bj_





new PlayerText:bj_bet[MAX_PLAYERS]; //—тавка
new PlayerText:bj_money[MAX_PLAYERS]; //ƒеньги игрока

new PlayerText:bj_dealer_point[MAX_PLAYERS];

new PlayerText:bj_members_name[MAX_PLAYERS][4]; //Ќ» » ”„ј—“Ќ» ќ¬

new PlayerText:bj_card_table[MAX_PLAYERS][5][4]; // арты игрока стола

new PlayerText:bj_panel_info[MAX_PLAYERS];





new Text3D: BlackJackText[MAX_BJ_LOBBY+1];

new Float:BlackJackPos[MAX_BJ_LOBBY+1][3] =
{
	{0.0,0.0,0.0},
	{0.0,0.0,1000.0}
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
	{{5, "txd:cards5c"}, {5, "txd:cards5d"}, {5, "txd:cards5h"}, {5, "txd:cards5s"}}, //п€терки
	{{6, "txd:cards6c"}, {6, "txd:cards6d"}, {6, "txd:cards6h"}, {6, "txd:cards6s"}}, //шестерки
	{{7, "txd:cards7c"}, {7, "txd:cards7d"}, {7, "txd:cards7h"}, {7, "txd:cards7s"}}, //семерки
	{{8, "txd:cards8c"}, {8, "txd:cards8d"}, {8, "txd:cards8h"}, {8, "txd:cards8s"}}, //восьмерки
	{{9, "txd:cards9c"}, {9, "txd:cards9d"}, {9, "txd:cards9h"}, {9, "txd:cards9s"}}, //дев€тки
	{{10, "txd:cards10c"}, {10, "txd:cards10d"}, {10, "txd:cards10h"}, {10, "txd:cards10s"}}, //дес€тки

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


enum P_Info
{
    bool:pFreeze
}
new pInfo[MAX_PLAYERS][P_Info];
//==============================================================================

public OnGameModeInit()
{
	return 1;
}








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
	pInfo[playerid][pFreeze] = false;
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)//¬ѕ»—ј“№ ÷¬≈“ј!
{

	if(clickedid == bj_help)
    {
        new str[1024];
        format(str, sizeof str,
		  	"BLACKJACK („ерный ¬алет) - одна из самых попул€рных карточных игр.\n"\
			"«адача игрока - набрать большее количество очков чем дилер, но не больше 21.\n"\
			"ѕомните, что игрок, набравший больше 21 очка сразу проигрывает игру,\n"\
			"за исключением ничьи с дилером (≈сли у дилера тоже больше 21 очка).\n"\
			"¬начале игры каждому участнику будут выданы по 2 карты. ¬ последствии игрок может решить,\n"\
			"брать ему карту или нет, воспользовавшись кнопками: '¬з€ть' или '’ватит' соответственно.\n"
		);

  		format(str, sizeof str, "%s"\
			"≈сли при раздаче двух карт игроку выпало 21 очко - он получил BLACKJACK, но не стоит радоватьс€,\n"\
			"ведь BLACKJACK может получить и дилер, а значит ¬ы сыграете вничью! \n"\
			"¬ зависимости от карт, ¬ы можете удвоить ¬ашу ставку. \n"\
			"¬ этом случае ¬ам будет выдана одна карта, а ставка будет увеличена в два раза. \n"\
			"“акже, если первой картой ƒилера будет “”«, ¬ы можете застраховать свою ставку за половину суммы. \n",
		str);
		format(str, sizeof str, "%s"\
			"¬ случае, если у дилера будет BLјCKJјCK, ¬ы получите все деньги назад, но если у дилера не будет 21 очка - ¬ы проиграете всЄ.\n"\
			"∆елаем ¬ам успехов в карточном деле! »грайте и выигрывайте!",
		str);

        SPD(playerid, 19998, DSM,"{00FFFF}ѕомощь", str, "«акрыть", "");
    }
	if(clickedid == bj_play)
    {
        SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "¬ведите сумму на которую хотите сыграть: (ћинимально 1000 рублей, ћаксимально 500000 рублей.)", "»грать", "«акрыть");
    }

    if(clickedid == bj_double)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[lobby][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
	        if(playermoney(playerid) < pBJInfo[playerid][pBJBet]) return SCM(playerid, CLRED, "| "CW"” ¬ас недостаточно средств чтобы удвоить ставку.");

			TextDrawSetString(bj_log_text[lobby][0], playername(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "YЪҐoЬЮ Ґ®ЬЩp®•");
			TextDrawColor(bj_log_text[lobby][1], -1);

			if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);


			GivePlayerMoney(playerid, -pBJInfo[playerid][pBJBet]);
			pBJInfo[playerid][pBJBet] = pBJInfo[playerid][pBJBet]*2;

			new str[15];
			format(str, sizeof str, "%d pyЧ", pBJInfo[playerid][pBJBet]);
			PlayerTextDrawSetString(playerid, bj_bet[playerid], str);

			format(str, sizeof str, "%d pyЧ", playermoney(playerid));
			PlayerTextDrawSetString(playerid, bj_money[playerid], str);


	        switch(pBJInfo[playerid][pBJTable])
			{
			    case 1:
			    {
					new suit = random(13);
					new type = random(4);

					BlackJackLobby[lobby][Table1Point] += BlackJackCard[suit][type][Pointscore];

					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table1Point]);
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

					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table2Point]);
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

					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table3Point]);
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

					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table4Point]);
					TextDrawSetString(bj_text_point_table[lobby][3], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

			    	pBJInfo[playerid][pBJTakedCard]++;
     				CheckTableBlackJack(lobby, 4);
			    }
			}
	    }
	    else SCM(playerid, CLRED, "| —ейчас не ваш ход");
	}
    if(clickedid == bj_take)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
			TextDrawSetString(bj_log_text[lobby][0], playername(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "ЛЯђЮ kap¶y");
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
					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table1Point]);
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
					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table2Point]);
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
					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table3Point]);
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
					format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table4Point]);
					TextDrawSetString(bj_text_point_table[lobby][3], str);

					ShowMembersCardBJL(lobby, 3, 2+pBJInfo[playerid][pBJTakedCard], suit, type);

     				CheckTableBlackJack(lobby, 4);
			    }
			}
	    }
	    else SCM(playerid, CLRED, "| —ейчас не ваш ход");
	}
    if(clickedid == bj_stop)
	{
	    new lobby = pBJInfo[playerid][pBJLobby];
	    if(BlackJackLobby[lobby][TableTurn] == pBJInfo[playerid][pBJTable])
	    {
			TextDrawSetString(bj_log_text[lobby][0], playername(playerid));
			TextDrawColor(bj_log_text[lobby][0], -65281);

			TextDrawSetString(bj_log_text[lobby][1], "Oc¶aЃoҐЬЮcђ");
			TextDrawColor(bj_log_text[lobby][1], -1);

			if(BlackJackLobby[lobby][Table1Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table2Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table3Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_log_text[lobby][1]);
			if(BlackJackLobby[lobby][Table4Id] < 1000) TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][0]), TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_log_text[lobby][1]);

	        PlayerTextDrawHide(playerid, bj_panel_info[playerid]);
	        BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurnTime] = 0;
            BlackJackLobby[pBJInfo[playerid][pBJLobby]][TableTurn]++;
	    }
	    else SCM(playerid, CLRED, "| —ейчас не ваш ход");
	}
	if(clickedid == bj_exit)
	{
   		new lobby = pBJInfo[playerid][pBJLobby];
   		new table = pBJInfo[playerid][pBJTable];
	    if(BlackJackLobby[lobby][StartedLobby]) return SCM(playerid, CLRED, "| "CW"ƒождитесь окончани€ игры");
	    else ExitPlayerLobby(playerid, lobby, table);
	}
	return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	//if(pInfo[playerid][pInLogin] == true) {
	//if(pInfo[playerid][pFreeze] == true) { FreezePlayer(playerid); }
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
	                SCM(playerid, CLRED, "| "CW"¬ведите ставку на которую хотите сыграть!");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "¬ведите сумму на которую хотите сыграть: (ћинимально 1000 рублей, ћаксимально 500000 рублей.)", "»грать", "«акрыть");
	                return 0;
	            }
	            if(!(999 < bet < 5000001))
	            {
	                SCM(playerid, CLRED, "| "CW"ћинимально 1000 рублей, ћаксимально 500000 рублей.");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "¬ведите сумму на которую хотите сыграть: (ћинимально 1000 рублей, ћаксимально 500000 рублей.)", "»грать", "«акрыть");
	                return 0;
	            }
	            if(playermoney(playerid) < bet)
	            {
	                SCM(playerid, CLRED, "| "CW"” вас недостаточно средств.");
	                SPD(playerid, 19999, DSI, "{00FFFF}BlackJack", "¬ведите сумму на которую хотите сыграть: (ћинимально 1000 рублей, ћаксимально 500000 рублей.)", "»грать", "«акрыть");
	                return 0;
	            }

				format(str, sizeof str, "%d pyЧ", bet);
				PlayerTextDrawShow(playerid, bj_bet[playerid]);
				PlayerTextDrawSetString(playerid, bj_bet[playerid], str);
				pBJInfo[playerid][pBJBet] = bet;
				//SCM(playerid, CYELLOW, "| "CW"¬ы поставили ставку.");

				TextDrawShowForPlayer(playerid, bj_text_bet[0]);
				TextDrawShowForPlayer(playerid, bj_text_bet[1]);
				SetTimerEx("TimerHideBetText", 3000, false, "d", playerid);
			}
		}
	}
	return 1;
}









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
	PlayerTextDrawSetString(playerid, bj_bet[playerid], "0 pyЧ");

	new money = GetPlayerMoney(playerid);

	new str[15];
	format(str, sizeof str, "%d pyЧ", money);
	PlayerTextDrawShow(playerid, bj_money[playerid]);
	PlayerTextDrawSetString(playerid, bj_money[playerid], str);

	//PlayerTextDrawSetString(playerid, bj_bet[playerid], str);

	FreezePlayer(playerid);
	HidePlayerHud(playerid);

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
		TextDrawSetString(bj_table_ready[lobby][1], "HE ВOПOЛ");
		TextDrawColor(bj_table_ready[lobby][1], -16776961);


		new table1 = BlackJackLobby[lobby][Table1Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table1, bj_members_name[table1][table-1]);
		PlayerTextDrawSetString(table1, bj_members_name[table1][table-1], name);


		PlayerTextDrawShow(table1, bj_card_table[table1][table][0]); PlayerTextDrawShow(table1, bj_card_table[table1][table][1]); PlayerTextDrawShow(table1, bj_card_table[table1][table][2]); PlayerTextDrawShow(table1, bj_card_table[table1][table][3]);

		TextDrawShowForPlayer(table1, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "HE ВOПOЛ");
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
		TextDrawSetString(bj_table_ready[lobby][2], "HE ВOПOЛ");
		TextDrawColor(bj_table_ready[lobby][2], -16776961);



		new table2 = BlackJackLobby[lobby][Table2Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table2, bj_members_name[table2][table-1]);
		PlayerTextDrawSetString(table2, bj_members_name[table2][table-1], name);


		PlayerTextDrawShow(table2, bj_card_table[table2][table][0]); PlayerTextDrawShow(table2, bj_card_table[table2][table][1]); PlayerTextDrawShow(table2, bj_card_table[table2][table][2]); PlayerTextDrawShow(table2, bj_card_table[table2][table][3]);

		TextDrawShowForPlayer(table2, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "HE ВOПOЛ");
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
		TextDrawSetString(bj_table_ready[lobby][3], "HE ВOПOЛ");
		TextDrawColor(bj_table_ready[lobby][3], -16776961);



		new table3 = BlackJackLobby[lobby][Table3Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table3, bj_members_name[table3][table-1]);
		PlayerTextDrawSetString(table3, bj_members_name[table3][table-1], name);


		PlayerTextDrawShow(table3, bj_card_table[table3][table][0]); PlayerTextDrawShow(table3, bj_card_table[table3][table][1]); PlayerTextDrawShow(table3, bj_card_table[table3][table][2]); PlayerTextDrawShow(table3, bj_card_table[table3][table][3]);

		TextDrawShowForPlayer(table3, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "HE ВOПOЛ");
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
		TextDrawSetString(bj_table_ready[lobby][4], "HE ВOПOЛ");
		TextDrawColor(bj_table_ready[lobby][4], -16776961);



		new table4 = BlackJackLobby[lobby][Table4Id];

		GetPlayerName(playerid, name, 24);

		PlayerTextDrawShow(table4, bj_members_name[table4][table-1]);
		PlayerTextDrawSetString(table4, bj_members_name[table4][table-1], name);


		PlayerTextDrawShow(table4, bj_card_table[table4][table][0]); PlayerTextDrawShow(table4, bj_card_table[table4][table][1]); PlayerTextDrawShow(table4, bj_card_table[table4][table][2]); PlayerTextDrawShow(table4, bj_card_table[table4][table][3]);

		TextDrawShowForPlayer(table4, bj_table_ready[lobby][table]);
		TextDrawSetString(bj_table_ready[lobby][table], "HE ВOПOЛ");
		TextDrawColor(bj_table_ready[lobby][table], -16776961);
	}
	SelectTextDraw(playerid, false);
	return 1;

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
    PlayerTextDrawSetString(playerid, bj_panel_info[playerid], "blackjack:kbassbjyouturn");

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

	for(new i = 1; i <= 4; i++)
	{
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][0]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][1]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][2]);
		PlayerTextDrawHide(playerid, bj_card_table[playerid][i][3]);

		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][0], "blackjack:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][1], "blackjack:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][2], "blackjack:cardscard");
		PlayerTextDrawSetString(playerid, bj_card_table[playerid][i][3], "blackjack:cardscard");

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
	UnFreezePlayer(playerid);
	ShowPlayerHud(playerid);

	foreach(new i : Player)
	{
	    ShowPlayerNameTagForPlayer(playerid, i, 1);
	}

    ///PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_members_name[BlackJackLobby[lobby][Table1Id]][table]);
	///PlayerTextDrawHide(BlackJackLobby[lobby][Table1Id], bj_members_name[playerid][1]);
	///PlayerTextDrawHide(playerid, bj_members_name[playerid][2]);
	///PlayerTextDrawHide(playerid, bj_members_name[playerid][3]);

	//BlackJackLobby[lobby][Table1Id]
	return 1;
}


stock LoadBlackJack()
{
	print("«агрузка блек джека");
	TextDrawSetString(bj_text_bet[0], RusText("¬ы успешно"));
	TextDrawSetString(bj_text_bet[1], RusText("поставили ставку"));

	TextDrawSetString(bj_text_start_time, RusText("¬ремени до начала игры"));

    for(new lobby; lobby < MAX_BJ_LOBBY; lobby++)
	{
	    BlackJackText[lobby+1] = Create3DTextLabel("BLACK-JACK\n{FFFFFF}ƒл€ начала игры введите /blackjack", CLRED, BlackJackPos[lobby+1][0], BlackJackPos[lobby+1][1], BlackJackPos[lobby+1][2], 5.0, 0);
		ReloadTable(lobby+1);
    	LoadBJLobbyTimer(lobby+1);
    	LoadBJLobbyPoint(lobby+1);
    	LoadBJLobbyReady(lobby+1);
    	LoadBJLobbyDealerCard(lobby+1);
    	LoadBJTextBlackJack(lobby+1);
    	LoadBJLobbyResult(lobby+1);

        LoadTextDraw();

		SetTimerEx("TimerSecondUpdateBJ", 1000, true, "d", lobby+1);

		TextDrawSetString(bj_text_point_table[lobby+1][0], RusText("очки: 0"));
		TextDrawSetString(bj_text_point_table[lobby+1][1], RusText("очки: 0"));
		TextDrawSetString(bj_text_point_table[lobby+1][2], RusText("очки: 0"));
		TextDrawSetString(bj_text_point_table[lobby+1][3], RusText("очки: 0"));


		bj_log_text[lobby+1][0] = TextDrawCreate(317.600189, 145.600067, "BY KBAS's");
		TextDrawLetterSize(bj_log_text[lobby+1][0], 0.375598, 1.599999);
		TextDrawAlignment(bj_log_text[lobby+1][0], 2);
		TextDrawColor(bj_log_text[lobby+1][0], -1);
		TextDrawSetShadow(bj_log_text[lobby+1][0], 0);
		TextDrawSetOutline(bj_log_text[lobby+1][0], 1);
		TextDrawBackgroundColor(bj_log_text[lobby+1][0], 51);
		TextDrawFont(bj_log_text[lobby+1][0], 1);
		TextDrawSetProportional(bj_log_text[lobby+1][0], 1);

		bj_log_text[lobby+1][1] = TextDrawCreate(317.800201, 161.533416, "t.me/kbasstudio");
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

stock LoadBJLobbyReady(lobby)
{
	bj_table_ready[lobby][1] = TextDrawCreate(77.600013, 320.319999, "HE ВOПOЛ");
	TextDrawLetterSize(bj_table_ready[lobby][1], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][1], 2);
	TextDrawColor(bj_table_ready[lobby][1], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][1], 0);
	TextDrawSetOutline(bj_table_ready[lobby][1], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][1], 51);
	TextDrawFont(bj_table_ready[lobby][1], 1);
	TextDrawSetProportional(bj_table_ready[lobby][1], 1);

	bj_table_ready[lobby][2] = TextDrawCreate(206.800628, 160.293167, "HE ВOПOЛ");
	TextDrawLetterSize(bj_table_ready[lobby][2], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][2], 2);
	TextDrawColor(bj_table_ready[lobby][2], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][2], 0);
	TextDrawSetOutline(bj_table_ready[lobby][2], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][2], 51);
	TextDrawFont(bj_table_ready[lobby][2], 1);
	TextDrawSetProportional(bj_table_ready[lobby][2], 1);

	bj_table_ready[lobby][3] = TextDrawCreate(458.200958, 160.293167, "HE ВOПOЛ");
	TextDrawLetterSize(bj_table_ready[lobby][3], 0.365199, 1.219199);
	TextDrawAlignment(bj_table_ready[lobby][3], 2);
	TextDrawColor(bj_table_ready[lobby][3], -16776961);
	TextDrawSetShadow(bj_table_ready[lobby][3], 0);
	TextDrawSetOutline(bj_table_ready[lobby][3], 1);
	TextDrawBackgroundColor(bj_table_ready[lobby][3], 51);
	TextDrawFont(bj_table_ready[lobby][3], 1);
	TextDrawSetProportional(bj_table_ready[lobby][3], 1);

	bj_table_ready[lobby][4] = TextDrawCreate(561.800598, 320.319999, "HE ВOПOЛ");
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
	bj_dealer_card[lobby][1] = TextDrawCreate(209.799957, 191.399993, "blackjack:cardsas");
	TextDrawLetterSize(bj_dealer_card[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_card[lobby][1], 132.000015, 174.719879);
	TextDrawAlignment(bj_dealer_card[lobby][1], 1);
	TextDrawColor(bj_dealer_card[lobby][1], -1);
	TextDrawSetShadow(bj_dealer_card[lobby][1], 0);
	TextDrawSetOutline(bj_dealer_card[lobby][1], 0);
	TextDrawFont(bj_dealer_card[lobby][1], 4);

	bj_dealer_card[lobby][2] = TextDrawCreate(235.600021, 191.653320, "blackjack:cardsas");
	TextDrawLetterSize(bj_dealer_card[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_card[lobby][2], 132.000015, 174.719879);
	TextDrawAlignment(bj_dealer_card[lobby][2], 1);
	TextDrawColor(bj_dealer_card[lobby][2], -1);
	TextDrawSetShadow(bj_dealer_card[lobby][2], 0);
	TextDrawSetOutline(bj_dealer_card[lobby][2], 0);
	TextDrawFont(bj_dealer_card[lobby][2], 4);

	bj_dealer_card[lobby][3] = TextDrawCreate(314.200042, 191.906646, "blackjack:cardskd");
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
    bj_text_bj_table[lobby][0] = TextDrawCreate(31.200008, 312.106567, "blackjack:kbassbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][0], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][0], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][0], 1);
	TextDrawColor(bj_text_bj_table[lobby][0], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][0], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][0], 0);
	TextDrawFont(bj_text_bj_table[lobby][0], 4);

	bj_text_bj_table[lobby][1] = TextDrawCreate(161.000030, 152.079727, "blackjack:kbassbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][1], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][1], 1);
	TextDrawColor(bj_text_bj_table[lobby][1], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][1], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][1], 0);
	TextDrawFont(bj_text_bj_table[lobby][1], 4);

	bj_text_bj_table[lobby][2] = TextDrawCreate(412.400238, 152.079727, "blackjack:kbassbjblackjack");
	TextDrawLetterSize(bj_text_bj_table[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(bj_text_bj_table[lobby][2], 91.199974, 46.293384);
	TextDrawAlignment(bj_text_bj_table[lobby][2], 1);
	TextDrawColor(bj_text_bj_table[lobby][2], -1);
	TextDrawSetShadow(bj_text_bj_table[lobby][2], 0);
	TextDrawSetOutline(bj_text_bj_table[lobby][2], 0);
	TextDrawFont(bj_text_bj_table[lobby][2], 4);

	bj_text_bj_table[lobby][3] = TextDrawCreate(515.400390, 312.106567, "blackjack:kbassbjblackjack");
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
//bj_result_table

	bj_result_table[lobby][0] = TextDrawCreate(88.800003, 187.666666, "blackjack:kbassbjwin");
 	TextDrawLetterSize(		bj_result_table[lobby][0], 0.000000, 0.000000);
	TextDrawTextSize( 		bj_result_table[lobby][0], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][0], 1);
	TextDrawColor(			bj_result_table[lobby][0], -1);
	TextDrawSetShadow(		bj_result_table[lobby][0], 0);
	TextDrawSetOutline(		bj_result_table[lobby][0], 0);
	TextDrawFont(			bj_result_table[lobby][0], 4);

	bj_result_table[lobby][1] = TextDrawCreate(215.400009, 27.133293, "blackjack:kbassbjlose");
 	TextDrawLetterSize(		bj_result_table[lobby][1], 0.000000, 0.000000);
	TextDrawTextSize(		bj_result_table[lobby][1], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][1], 1);
	TextDrawColor(			bj_result_table[lobby][1], -1);
	TextDrawSetShadow(		bj_result_table[lobby][1], 0);
	TextDrawSetOutline(		bj_result_table[lobby][1], 0);
	TextDrawFont(			bj_result_table[lobby][1], 4);

	bj_result_table[lobby][2] = TextDrawCreate(466.800170, 27.133293, "blackjack:kbassbjmydraw");
	TextDrawLetterSize(		bj_result_table[lobby][2], 0.000000, 0.000000);
	TextDrawTextSize(		bj_result_table[lobby][2], 69.599975, 34.346652);
	TextDrawAlignment(		bj_result_table[lobby][2], 1);
	TextDrawColor(			bj_result_table[lobby][2], -1);
	TextDrawSetShadow(		bj_result_table[lobby][2], 0);
	TextDrawSetOutline(		bj_result_table[lobby][2], 0);
	TextDrawFont(			bj_result_table[lobby][2], 4);

	bj_result_table[lobby][3] = TextDrawCreate(569.000610, 187.666666, "blackjack:kbassbjmydraw");
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
			//SCMBJL(lobby, CLRED, "»√–ј »ƒ≈“....");
			switch(BlackJackLobby[lobby][StageLobby])
			{
			    case 1: //— –џ“»≈ Ќј„јЋ№Ќџ’  ј–“, показ очков дилера, начало раздачи //timerlobby
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

				 	BlackJackLobby[lobby][StageLobby]++; BlackJackLobby[lobby][DealerTurnGived]++; //+шаг
				}


				case 2: //–аздача первых карт участникам и дилеру //timerlobby
				{
				    switch(BlackJackLobby[lobby][DealerTurnGived])
				    {
				        case 1:
						{
							BlackJackLobby[lobby][DealerTurnGived] = 0; SetTimerEx("TimerDealerNext", 2000, false, "d", lobby);
							TextDrawSetString(bj_log_text[lobby][0], "ГЬЮep Ґ®ЪaЮ ceЧe kap¶y");
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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table1Point]);
								TextDrawSetString(bj_text_point_table[lobby][0], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table2Point]);
								TextDrawSetString(bj_text_point_table[lobby][1], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table3Point]);
								TextDrawSetString(bj_text_point_table[lobby][2], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table4Point]);
								TextDrawSetString(bj_text_point_table[lobby][3], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

								ShowMembersCardBJL(lobby, 4, 0, suit, type);
							}
						}
					}
				}


				case 3: //timerlobby
				{
				    switch(BlackJackLobby[lobby][DealerTurnGived])
				    {
				        case 1:
				        {

							//BlackJackLobby[lobby][DealerPoint] += BlackJackCard[dealer_suit][dealer_type][Pointscore];
							TextDrawSetString(bj_dealer_card[lobby][2], "blackjack:cardscard");

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



								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table1Point]);
								TextDrawSetString(bj_text_point_table[lobby][0], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table2Point]);
								TextDrawSetString(bj_text_point_table[lobby][1], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table3Point]);
								TextDrawSetString(bj_text_point_table[lobby][2], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

								ShowMembersCardBJL(lobby, 3, 1, suit, type);
							}
							else BlackJackLobby[lobby][DealerTurnGived] = 9;
						}
						case 8: BlackJackLobby[lobby][DealerTurnGived]++;

						case 9:
						{
							BlackJackLobby[lobby][DealerTurnGived] = 0; BlackJackLobby[lobby][StageLobby]++; BlackJackLobby[lobby][TableTurn]++; //очередь участников
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

								format(str, sizeof str, "o§kЬ: %d", BlackJackLobby[lobby][Table4Point]);
								TextDrawSetString(bj_text_point_table[lobby][3], str);
								//BlackJackLobby[lobby][Table1Card][0] = class;
								//BlackJackLobby[lobby][Table1Card][1] = type;

								ShowMembersCardBJL(lobby, 4, 1, suit, type);
							}
						}
					}


				}

				case 4: //timerlobby
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
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table1Id]);

         							new str[24];
									TextDrawSetString(bj_log_text[lobby][0], "Гo koЃЙa xoЪa 00:15");
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table1Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

                                    TextDrawSetString(bj_log_text[lobby][0], "Лpeѓђ Ьc¶ekЮo");
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
         							format(str, sizeof str, "Гo koЃЙa xoЪa 00:%02d", BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
							//do
				        }
				        case 2:
				        {
				            if(BlackJackLobby[lobby][Table2Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table2Point] == 21 || BlackJackLobby[lobby][Table2Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table2Id]);

         							new str[24];
									TextDrawSetString(bj_log_text[lobby][0], "Гo koЃЙa xoЪa 00:15");
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table2Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

                                    TextDrawSetString(bj_log_text[lobby][0], "Лpeѓђ Ьc¶ekЮo");
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
         							format(str, sizeof str, "Гo koЃЙa xoЪa 00:%02d", BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
							//do
				        }
				        case 3:
				        {
				            if(BlackJackLobby[lobby][Table3Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table3Point] == 21 || BlackJackLobby[lobby][Table3Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table3Id]);

         							new str[24];
									TextDrawSetString(bj_log_text[lobby][0], "Гo koЃЙa xoЪa 00:15");
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table3Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

                                    TextDrawSetString(bj_log_text[lobby][0], "Лpeѓђ Ьc¶ekЮo");
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
         							format(str, sizeof str, "Гo koЃЙa xoЪa 00:%02d", BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
							//do
				        }
				        case 4:
				        {
				            if(BlackJackLobby[lobby][Table4Id] < 1000)
				            {
				                if(BlackJackLobby[lobby][Table4Point] == 21 || BlackJackLobby[lobby][Table4Point] > 21) return BlackJackLobby[lobby][TableTurnTime] = 0, BlackJackLobby[lobby][TableTurn]++;
				                if(BlackJackLobby[lobby][TableTurnTime] == 0)
								{
									BlackJackLobby[lobby][TableTurnTime] = 15;
					                PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjyouturn");
					                PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
									SetTimerEx("TimerHideYouTurn", 2000, false, "d", BlackJackLobby[lobby][Table4Id]);

         							new str[24];
									TextDrawSetString(bj_log_text[lobby][0], "Гo koЃЙa xoЪa 00:15");
									TextDrawColor(bj_log_text[lobby][0], -1);
									GetPlayerName(BlackJackLobby[lobby][Table4Id], str, 24);
									TextDrawSetString(bj_log_text[lobby][1], str);
									TextDrawColor(bj_log_text[lobby][1], -65281);
								}
								else if(BlackJackLobby[lobby][TableTurnTime] == 1)
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
                                    BlackJackLobby[lobby][TableTurn]++;

                                    TextDrawSetString(bj_log_text[lobby][0], "Лpeѓђ Ьc¶ekЮo");
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
								else
								{
         							BlackJackLobby[lobby][TableTurnTime]--;
         							new str[24];
         							format(str, sizeof str, "Гo koЃЙa xoЪa 00:%02d", BlackJackLobby[lobby][TableTurnTime]);
									TextDrawSetString(bj_log_text[lobby][0], str);
									TextDrawColor(bj_log_text[lobby][0], -1);
								}
				            }
				            else BlackJackLobby[lobby][TableTurn]++;
							//do
				        }
				        case 5: { BlackJackLobby[lobby][TableTurn] = 0; BlackJackLobby[lobby][TableTurnTime] = 0; BlackJackLobby[lobby][StageLobby]++; }

				    }
				    //SCMBJL(lobby, CLRED, "DOOOO");
				}

				case 5: //timerlobby //раздача дилеру последней карты
				{
					TextDrawSetString(bj_log_text[lobby][0], "ГЬЮep o¶kp®Ю kap¶y");
					TextDrawColor(bj_log_text[lobby][0], -1);
					TextDrawSetString(bj_log_text[lobby][1], "");
					TextDrawColor(bj_log_text[lobby][1], -65281);

			        new dealer_suit = random(13);
					new dealer_type = random(4);

					BlackJackLobby[lobby][DealerPoint] += BlackJackCard[dealer_suit][dealer_type][Pointscore];


					TextDrawSetString(bj_dealer_card[lobby][2], BlackJackCard[dealer_suit][dealer_type][Cardtexture]);


					new str[10];
					format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);

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


					TextDrawSetString(bj_log_text[lobby][0], "ГЬЮep Ґ®ЪaЮ ceЧe kap¶y");
					TextDrawColor(bj_log_text[lobby][0], -1);

					new str[10];
					format(str, sizeof str, "%d", BlackJackLobby[lobby][DealerPoint]);

					if(BlackJackLobby[lobby][Table1Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table1Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table2Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table2Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table3Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table3Id], bj_dealer_card[lobby][3]);
					if(BlackJackLobby[lobby][Table4Id] < 1000) PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], str); TextDrawShowForPlayer(BlackJackLobby[lobby][Table4Id], bj_dealer_card[lobby][3]);

					BlackJackLobby[lobby][StageLobby]++;
				}
				case 7: //timerlobby //результаты result
				{
					if(BlackJackLobby[lobby][Table1Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table1Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table1Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
				            GivePlayerMoney(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][0], "blackjack:kbassbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table1Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);

					            TextDrawSetString(bj_result_table[lobby][0], "blackjack:kbassbjlose");
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][0], "blackjack:kbassbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table1Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);

					            TextDrawSetString(bj_result_table[lobby][0], "blackjack:kbassbjlose");
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table1Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table1Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table1Id], bj_panel_info[BlackJackLobby[lobby][Table1Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][0], "blackjack:kbassbjwin");
					    }
					}

					if(BlackJackLobby[lobby][Table2Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table2Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table2Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
				            GivePlayerMoney(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][1], "blackjack:kbassbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table2Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);

					            TextDrawSetString(bj_result_table[lobby][1], "blackjack:kbassbjlose");
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][1], "blackjack:kbassbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table2Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);

					            TextDrawSetString(bj_result_table[lobby][1], "blackjack:kbassbjlose");
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table2Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table2Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table2Id], bj_panel_info[BlackJackLobby[lobby][Table2Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table2Id], pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][1], "blackjack:kbassbjwin");
					    }
					}


					if(BlackJackLobby[lobby][Table3Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table3Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table3Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
				            GivePlayerMoney(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][2], "blackjack:kbassbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table3Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);

					            TextDrawSetString(bj_result_table[lobby][2], "blackjack:kbassbjlose");
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][2], "blackjack:kbassbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table3Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);

					            TextDrawSetString(bj_result_table[lobby][2], "blackjack:kbassbjlose");
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table3Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table3Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table3Id], bj_panel_info[BlackJackLobby[lobby][Table3Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table3Id], pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][2], "blackjack:kbassbjwin");
					    }
					}

					if(BlackJackLobby[lobby][Table4Id] < 1000)
					{
					    if(BlackJackLobby[lobby][DealerPoint] == BlackJackLobby[lobby][Table4Point] || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table4Point] > 21))
					    {
				            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjdraw");
					    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
				            GivePlayerMoney(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]);

					       	TextDrawSetString(bj_result_table[lobby][3], "blackjack:kbassbjmydraw");
					    }
					    else if(BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] < 21)
					    {
							if(BlackJackLobby[lobby][DealerPoint] > BlackJackLobby[lobby][Table4Point])
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);

					            TextDrawSetString(bj_result_table[lobby][3], "blackjack:kbassbjlose");
							}
							else
							{
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][3], "blackjack:kbassbjwin");
							}
					    }

					    else if((BlackJackLobby[lobby][DealerPoint] == 21 && BlackJackLobby[lobby][Table4Point] < 21) || (BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] > 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjyoulose");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);

					            TextDrawSetString(bj_result_table[lobby][3], "blackjack:kbassbjlose");
					    }
					    else if((BlackJackLobby[lobby][DealerPoint] < 21 && BlackJackLobby[lobby][Table4Point] == 21) || (BlackJackLobby[lobby][DealerPoint] > 21 && BlackJackLobby[lobby][Table4Point] < 21))
					    {
					            PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]], "blackjack:kbassbjyouwin");
						    	PlayerTextDrawShow(BlackJackLobby[lobby][Table4Id], bj_panel_info[BlackJackLobby[lobby][Table4Id]]);
					            GivePlayerMoney(BlackJackLobby[lobby][Table4Id], pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]*2);

					            TextDrawSetString(bj_result_table[lobby][3], "blackjack:kbassbjwin");
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
				case 11: //end
				{
	            	TextDrawSetString(bj_text_point_table[lobby][0], "o§kЬ: 0");
					TextDrawSetString(bj_text_point_table[lobby][1], "o§kЬ: 0");
					TextDrawSetString(bj_text_point_table[lobby][2], "o§kЬ: 0");
					TextDrawSetString(bj_text_point_table[lobby][3], "o§kЬ: 0");

					BlackJackLobby[lobby][Table1Result] = 0;
					BlackJackLobby[lobby][Table2Result] = 0;
					BlackJackLobby[lobby][Table3Result] = 0;
					BlackJackLobby[lobby][Table4Result] = 0;

					BlackJackLobby[lobby][StageLobby]++;
				}
				case 12:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table1Id] < 1000) { PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_dealer_point[BlackJackLobby[lobby][Table1Id]], "0"); ExitPlayerLobby(BlackJackLobby[lobby][Table1Id], lobby, 1); InitPlayerLobby(BlackJackLobby[lobby][Table1Id], lobby, 1); }
				}
				case 13:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table2Id] < 1000) { PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_dealer_point[BlackJackLobby[lobby][Table2Id]], "0"); ExitPlayerLobby(BlackJackLobby[lobby][Table2Id], lobby, 2); InitPlayerLobby(BlackJackLobby[lobby][Table2Id], lobby, 2); }
				}
				case 14:
				{
					BlackJackLobby[lobby][StageLobby]++;
					if(BlackJackLobby[lobby][Table3Id] < 1000) { PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_dealer_point[BlackJackLobby[lobby][Table3Id]], "0"); ExitPlayerLobby(BlackJackLobby[lobby][Table3Id], lobby, 3); InitPlayerLobby(BlackJackLobby[lobby][Table3Id], lobby, 3); }
				}
				case 15:
				{
    				BlackJackLobby[lobby][StageLobby] = 0;
					BlackJackLobby[lobby][StartedLobby] = false;
					if(BlackJackLobby[lobby][Table4Id] < 1000) { PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_dealer_point[BlackJackLobby[lobby][Table4Id]], "0"); ExitPlayerLobby(BlackJackLobby[lobby][Table4Id], lobby, 4); InitPlayerLobby(BlackJackLobby[lobby][Table4Id], lobby, 4); }
				}




			}
	    }
		else
	    {
	        if(BlackJackLobby[lobby][StartTimer]-1 == 0)
			{
				BlackJackLobby[lobby][StartedLobby] = true; BlackJackLobby[lobby][StageLobby] = 1; SCMBJL(lobby, CLRED, "»√–ј Ќј„јЋј—№...");

				printf("—тол 1: %d", BlackJackLobby[lobby][Table1Id]);
				printf("—тол 2: %d", BlackJackLobby[lobby][Table2Id]);
				printf("—тол 3: %d", BlackJackLobby[lobby][Table3Id]);
				printf("—тол 4: %d", BlackJackLobby[lobby][Table4Id]);

				new str[15];

			    if(BlackJackLobby[lobby][Table1Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]) { SCM(BlackJackLobby[lobby][Table1Id], CYELLOW, "| "CW"ѕродолжать играть могут только те кто поставил ставку"); ExitPlayerLobby(BlackJackLobby[lobby][Table1Id], lobby, 1); }
					else { GivePlayerMoney(BlackJackLobby[lobby][Table1Id], -pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]); format(str, sizeof str, "%d pyЧ", playermoney(BlackJackLobby[lobby][Table1Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table1Id], bj_money[BlackJackLobby[lobby][Table1Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table2Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]) { SCM(BlackJackLobby[lobby][Table2Id], CYELLOW, "| "CW"ѕродолжать играть могут только те кто поставил ставку"); ExitPlayerLobby(BlackJackLobby[lobby][Table2Id], lobby, 2); }
					else { GivePlayerMoney(BlackJackLobby[lobby][Table2Id], -pBJInfo[BlackJackLobby[lobby][Table2Id]][pBJBet]); format(str, sizeof str, "%d pyЧ", playermoney(BlackJackLobby[lobby][Table2Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table2Id], bj_money[BlackJackLobby[lobby][Table2Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table3Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]) { SCM(BlackJackLobby[lobby][Table3Id], CYELLOW, "| "CW"ѕродолжать играть могут только те кто поставил ставку"); ExitPlayerLobby(BlackJackLobby[lobby][Table3Id], lobby, 3); }
					else { GivePlayerMoney(BlackJackLobby[lobby][Table3Id], -pBJInfo[BlackJackLobby[lobby][Table3Id]][pBJBet]); format(str, sizeof str, "%d pyЧ", playermoney(BlackJackLobby[lobby][Table3Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table3Id], bj_money[BlackJackLobby[lobby][Table3Id]], str); }
				}
			    if(BlackJackLobby[lobby][Table4Id] < 1000) {
					if(!pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]) { SCM(BlackJackLobby[lobby][Table4Id], CYELLOW, "| "CW"ѕродолжать играть могут только те кто поставил ставку"); ExitPlayerLobby(BlackJackLobby[lobby][Table4Id], lobby, 4); }
					else { GivePlayerMoney(BlackJackLobby[lobby][Table4Id], -pBJInfo[BlackJackLobby[lobby][Table4Id]][pBJBet]); format(str, sizeof str, "%d pyЧ", playermoney(BlackJackLobby[lobby][Table4Id])); PlayerTextDrawSetString(BlackJackLobby[lobby][Table4Id], bj_money[BlackJackLobby[lobby][Table4Id]], str); }
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
	{ //timerdeath
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



stock SCMBJL(lobby, color, message[]) //SendCLientMessageBlackJackLobby
{
	if(BlackJackLobby[lobby][Table1Id] < 1000) SCM(BlackJackLobby[lobby][Table1Id], color, message);
	if(BlackJackLobby[lobby][Table2Id] < 1000) SCM(BlackJackLobby[lobby][Table2Id], color, message);
	if(BlackJackLobby[lobby][Table3Id] < 1000) SCM(BlackJackLobby[lobby][Table3Id], color, message);
	if(BlackJackLobby[lobby][Table4Id] < 1000) SCM(BlackJackLobby[lobby][Table4Id], color, message);
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

    PlayerTextDrawSetString(playerid, bj_panel_info[playerid], "blackjack:kbassbjyoubj");//GivePlayerMoney(BlackJackLobby[lobby][Table1Id], pBJInfo[BlackJackLobby[lobby][Table1Id]][pBJBet]*2);
    BlackJackLobby[lobby][TableTurn]++;
}

stock GiveTableLose(lobby, player)
{
	new str[32];
	format(str, sizeof str, "%s лох проиграл", playername(player));
	SCMBJL(lobby, CWHITE, str);
    //pBJInfo[playerid][pBJTakedCard] = 0;
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
	format(give, sizeof give, "%s", playername(apponent));
	TextDrawSetString(bj_log_text[lobby][0], "ГЬЮep Ґ®ЪaЮ kap¶y");
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

CMD:blackjack(playerid)
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
					if(BlackJackLobby[i][Table1Id] == 1000) 	 { BlackJackLobby[i][Table1Id] = playerid; pBJInfo[playerid][OnLobby] = true; pBJInfo[playerid][pBJLobby] = i; InitPlayerLobby(playerid, i, 1); }
					else if(BlackJackLobby[i][Table2Id] == 1000) { BlackJackLobby[i][Table2Id] = playerid; pBJInfo[playerid][OnLobby] = true; pBJInfo[playerid][pBJLobby] = i; InitPlayerLobby(playerid, i, 2); }
					else if(BlackJackLobby[i][Table3Id] == 1000) { BlackJackLobby[i][Table3Id] = playerid; pBJInfo[playerid][OnLobby] = true; pBJInfo[playerid][pBJLobby] = i; InitPlayerLobby(playerid, i, 3); }
					else if(BlackJackLobby[i][Table4Id] == 1000) { BlackJackLobby[i][Table4Id] = playerid; pBJInfo[playerid][OnLobby] = true; pBJInfo[playerid][pBJLobby] = i; InitPlayerLobby(playerid, i, 4); }
					else SCM(playerid, CLRED, "| "CW"ƒанный стол уже зан€т.");
				}
				else SCM(playerid, CLRED, "| "CW"Ќа этом столе уже началась игра.");
		    }
		    else continue;
		}
		if(distance == false) SCM(playerid, CLRED, "| "CW"¬ы находитесь слишком далеко от блек джека");
	}
	return 1;
}

/*CMD:setbjlog(playerid, params[])
{
	if(sscanf(params, "ds", params[0], params[1])) return SCM(playerid, CLRED, "no");
	new give[64];
	format(give, sizeof give, "%s", params[1]);
	TextDrawSetString(bj_log_text[params[0]], give);
	TextDrawShowForPlayer(playerid, bj_log_text[params[0]]);
	return 1;
}
CMD:stopbj(playerid)
{
	if(pBJInfo[playerid][pBJLobby] != 0)
	{
	    BlackJackLobby[pBJInfo[playerid][pBJLobby]][StartTimer] = 60;
	    BlackJackLobby[pBJInfo[playerid][pBJLobby]][StartedLobby] = false;
	    SCMBJL(pBJInfo[playerid][pBJLobby], CYELLOW, "| "CW"»гра завершена");
    }

}*/


































stock LoadTextDraw()
{
	bj_fon = TextDrawCreate(0.000000, 0.000000, "blackjack:kbassbj");
	TextDrawLetterSize(bj_fon, 0.000000, 0.000000);
	TextDrawTextSize(bj_fon, 640.000000, 448.000000);
	TextDrawAlignment(bj_fon, 1);
	TextDrawColor(bj_fon, -1);
	TextDrawSetShadow(bj_fon, 0);
	TextDrawSetOutline(bj_fon, 0);
	TextDrawFont(bj_fon, 4);

	bj_play = TextDrawCreate(268.399932, 389.773345, "blackjack:kbassbjplay");
	TextDrawLetterSize(bj_play, 0.000000, 0.000000);
	TextDrawTextSize(bj_play, 96.799949, 36.586669);
	TextDrawAlignment(bj_play, 1);
	TextDrawColor(bj_play, -1);
	TextDrawSetShadow(bj_play, 0);
	TextDrawSetOutline(bj_play, 0);
	TextDrawFont(bj_play, 4);
	TextDrawSetSelectable(bj_play, true);

	bj_double = TextDrawCreate(16.600013, 389.773345, "blackjack:kbassbjdouble");
	TextDrawLetterSize(bj_double, 0.000000, 0.000000);
	TextDrawTextSize(bj_double, 96.799949, 36.586669);
	TextDrawAlignment(bj_double, 1);
	TextDrawColor(bj_double, -1);
	TextDrawSetShadow(bj_double, 0);
	TextDrawSetOutline(bj_double, 0);
	TextDrawFont(bj_double, 4);
	TextDrawSetSelectable(bj_double, true);

	bj_stop = TextDrawCreate(121.600059, 389.773345, "blackjack:kbassbjstop");
	TextDrawLetterSize(bj_stop, 0.000000, 0.000000);
	TextDrawTextSize(bj_stop, 96.799949, 36.586669);
	TextDrawAlignment(bj_stop, 1);
	TextDrawColor(bj_stop, -1);
	TextDrawSetShadow(bj_stop, 0);
	TextDrawSetOutline(bj_stop, 0);
	TextDrawFont(bj_stop, 4);
	TextDrawSetSelectable(bj_stop, true);

	bj_take = TextDrawCreate(420.800231, 389.773345, "blackjack:kbassbjtake");
	TextDrawLetterSize(bj_take, 0.000000, 0.000000);
	TextDrawTextSize(bj_take, 96.799949, 36.586669);
	TextDrawAlignment(bj_take, 1);
	TextDrawColor(bj_take, -1);
	TextDrawSetShadow(bj_take, 0);
	TextDrawSetOutline(bj_take, 0);
	TextDrawFont(bj_take, 4);
	TextDrawSetSelectable(bj_take, true);

	bj_exit = TextDrawCreate(526.200256, 389.773345, "blackjack:kbassbjexit");
	TextDrawLetterSize(bj_exit, 0.000000, 0.000000);
	TextDrawTextSize(bj_exit, 96.799949, 36.586669);
	TextDrawAlignment(bj_exit, 1);
	TextDrawColor(bj_exit, -1);
	TextDrawSetShadow(bj_exit, 0);
	TextDrawSetOutline(bj_exit, 0);
	TextDrawFont(bj_exit, 4);
	TextDrawSetSelectable(bj_exit, true);

	bj_dealer_score = TextDrawCreate(259.000030, 388.280212, "blackjack:kbassbjscore");
	TextDrawLetterSize(bj_dealer_score, 0.000000, 0.000000);
	TextDrawTextSize(bj_dealer_score, 115.999938, 51.520008);
	TextDrawAlignment(bj_dealer_score, 1);
	TextDrawColor(bj_dealer_score, -1);
	TextDrawSetShadow(bj_dealer_score, 0);
	TextDrawSetOutline(bj_dealer_score, 0);
	TextDrawFont(bj_dealer_score, 4);


	bj_help = TextDrawCreate(16.799999, 123.200004, "textures:button");
	TextDrawLetterSize(bj_help, 0.000000, 0.000000);
	TextDrawTextSize(bj_help, 104.000000, 36.586654);
	TextDrawAlignment(bj_help, 1);
	TextDrawColor(bj_help, -1);
	TextDrawSetShadow(bj_help, 0);
	TextDrawSetOutline(bj_help, 0);
	TextDrawFont(bj_help, 4);
	TextDrawSetSelectable(bj_help, true);



	bj_text_bet[0] = TextDrawCreate(320.800018, 71.680015, "Bbl ycnewno");
	TextDrawLetterSize(bj_text_bet[0], 0.405198, 1.458132);
	TextDrawAlignment(bj_text_bet[0], 2);
	TextDrawColor(bj_text_bet[0], -65281);
	TextDrawSetShadow(bj_text_bet[0], 0);
	TextDrawSetOutline(bj_text_bet[0], 1);
	TextDrawBackgroundColor(bj_text_bet[0], 51);
	TextDrawFont(bj_text_bet[0], 1);
	TextDrawSetProportional(bj_text_bet[0], 1);

	bj_text_bet[1] = TextDrawCreate(320.200042, 86.120002, "noctavili ctavky");
	TextDrawLetterSize(bj_text_bet[1], 0.405198, 1.458132);
	TextDrawAlignment(bj_text_bet[1], 2);
	TextDrawColor(bj_text_bet[1], -65281);
	TextDrawSetShadow(bj_text_bet[1], 0);
	TextDrawSetOutline(bj_text_bet[1], 1);
	TextDrawBackgroundColor(bj_text_bet[1], 51);
	TextDrawFont(bj_text_bet[1], 1);
	TextDrawSetProportional(bj_text_bet[1], 1);



	bj_text_start_time = TextDrawCreate(315.999969, 215.040039, "Bpemeni do nachala igri");
	TextDrawLetterSize(bj_text_start_time, 0.581197, 2.563199);
	TextDrawAlignment(bj_text_start_time, 2);
	TextDrawColor(bj_text_start_time, -1);
	TextDrawSetShadow(bj_text_start_time, 0);
	TextDrawSetOutline(bj_text_start_time, 1);
	TextDrawBackgroundColor(bj_text_start_time, 51);
	TextDrawFont(bj_text_start_time, 1);
	TextDrawSetProportional(bj_text_start_time, 1);

	//bj_text_start_timer в моде

}

stock LoadPlayerTextDraw(playerid)
{
    bj_bet[playerid] = CreatePlayerTextDraw(playerid, 19.200004, 58.240013, "0 pyb");
	PlayerTextDrawLetterSize(playerid, bj_bet[playerid], 0.291599, 1.510398);
	PlayerTextDrawAlignment(playerid, bj_bet[playerid], 1);
	PlayerTextDrawColor(playerid, bj_bet[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_bet[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_bet[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, bj_bet[playerid], 51);
	PlayerTextDrawFont(playerid, bj_bet[playerid], 1);
	PlayerTextDrawSetProportional(playerid, bj_bet[playerid], 1);

	bj_money[playerid] = CreatePlayerTextDraw(playerid, 19.200004, 92.093315, "0 pyb");
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


	bj_members_name[playerid][0] = CreatePlayerTextDraw(playerid, 19.600006, 197.626632, "KBASs_STUDIO");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][0], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][0], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][0], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][0], 1);


	bj_members_name[playerid][1] = CreatePlayerTextDraw(playerid, 147.200286, 40.586555, "KBASs_STUDIO");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][1], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][1], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][1], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][1], 1);

	bj_members_name[playerid][2] = CreatePlayerTextDraw(playerid, 397.800445, 40.586555, "KBASs_STUDIO");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][2], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][2], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid,		 	bj_members_name[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][2], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][2], 1);

	bj_members_name[playerid][3] = CreatePlayerTextDraw(playerid, 496.600280, 197.626632, "KBASs_STUDIO");
	PlayerTextDrawLetterSize(playerid, 			bj_members_name[playerid][3], 0.286798, 1.390933);
	PlayerTextDrawAlignment(playerid, 			bj_members_name[playerid][3], 1);
	PlayerTextDrawColor(playerid, 				bj_members_name[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, 			bj_members_name[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, 			bj_members_name[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, 	bj_members_name[playerid][3], 51);
	PlayerTextDrawFont(playerid, 				bj_members_name[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, 	bj_members_name[playerid][3], 1);







	bj_card_table[playerid][1][0] = CreatePlayerTextDraw(playerid, 2.999999, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][0], 4);

	bj_card_table[playerid][1][1] = CreatePlayerTextDraw(playerid, 22.999999, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][1], 4);

	bj_card_table[playerid][1][2] = CreatePlayerTextDraw(playerid, 42.999999, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][2], 4);

	bj_card_table[playerid][1][3] = CreatePlayerTextDraw(playerid, 62.999999, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][1][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][1][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][1][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][1][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][1][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][1][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][1][3], 4);





	bj_card_table[playerid][2][0] = CreatePlayerTextDraw(playerid, 129.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][0], 4);

	bj_card_table[playerid][2][1] = CreatePlayerTextDraw(playerid, 149.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][1], 4);

	bj_card_table[playerid][2][2] = CreatePlayerTextDraw(playerid, 169.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][2], 4);

	bj_card_table[playerid][2][3] = CreatePlayerTextDraw(playerid, 189.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][2][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][2][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][2][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][2][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][2][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][2][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][2][3], 4);





	bj_card_table[playerid][3][0] = CreatePlayerTextDraw(playerid, 380.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][0], 4);

	bj_card_table[playerid][3][1] = CreatePlayerTextDraw(playerid, 400.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][1], 4);

	bj_card_table[playerid][3][2] = CreatePlayerTextDraw(playerid, 420.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][2], 4);

	bj_card_table[playerid][3][3] = CreatePlayerTextDraw(playerid, 440.999999, 46.559913, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][3][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][3][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][3][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][3][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][3][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][3][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][3][3], 4);




	bj_card_table[playerid][4][0] = CreatePlayerTextDraw(playerid, 481.000000, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][0], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][0], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][0], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][0], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][0], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][0], 4);

	bj_card_table[playerid][4][1] = CreatePlayerTextDraw(playerid, 502.000000, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][1], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][1], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][1], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][1], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][1], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][1], 4);

	bj_card_table[playerid][4][2] = CreatePlayerTextDraw(playerid, 523.000000, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][2], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][2], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][2], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][2], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][2], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][2], 4);

	bj_card_table[playerid][4][3] = CreatePlayerTextDraw(playerid, 544.000000, 206.079971, "blackjack:cardscard");
	PlayerTextDrawLetterSize(playerid, bj_card_table[playerid][4][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_card_table[playerid][4][3], 90.400009, 117.226631);
	PlayerTextDrawAlignment(playerid, bj_card_table[playerid][4][3], 1);
	PlayerTextDrawColor(playerid, bj_card_table[playerid][4][3], -1);
	PlayerTextDrawSetShadow(playerid, bj_card_table[playerid][4][3], 0);
	PlayerTextDrawSetOutline(playerid, bj_card_table[playerid][4][3], 0);
	PlayerTextDrawFont(playerid, bj_card_table[playerid][4][3], 4);



	bj_panel_info[playerid] = CreatePlayerTextDraw(playerid, 155.146667, 249.386703, "blackjack:kbassbjyouturn");
	PlayerTextDrawLetterSize(playerid, bj_panel_info[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, bj_panel_info[playerid], 326.133239, 106.026657);
	PlayerTextDrawAlignment(playerid, bj_panel_info[playerid], 1);
	PlayerTextDrawColor(playerid, bj_panel_info[playerid], -1);
	PlayerTextDrawSetShadow(playerid, bj_panel_info[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bj_panel_info[playerid], 0);
	PlayerTextDrawFont(playerid, bj_panel_info[playerid], 4);

}








public OnFilterScriptInit()
{
	print(" ¬ј— ќ  –”“»“ ћ»»»»–!!!!!!");
	LoadBlackJack();
    return 1;
}
public OnFilterScriptExit()
{
	return 1;
}


public OnPlayerConnect(playerid)
{
	LoadPlayerTextDraw(playerid);
	return 1;
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




stock FreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 0);
    pInfo[playerid][pFreeze] = true;
    return 1;
}

stock UnFreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
    pInfo[playerid][pFreeze] = false;
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


stock RusText(string[])
{
	new result[256];
	for (new i = 0; i < sizeof(result); i++)
	{
		switch(string[i])
		{
			case 'а': result[i] = 'a';
			case 'ј': result[i] = 'A';
			case 'б': result[i] = 'Ч';
			case 'Ѕ': result[i] = 'А';
			case 'в': result[i] = 'Ґ';
			case '¬': result[i] = 'Л';
			case 'г': result[i] = 'Щ';
			case '√': result[i] = 'В';
			case 'д': result[i] = 'Ъ';
			case 'ƒ': result[i] = 'Г';
			case 'е': result[i] = 'e';
			case '≈': result[i] = 'E';
			case 'Є': result[i] = 'e';
			case '®': result[i] = 'E';
			case 'ж': result[i] = 'Ы';
			case '∆': result[i] = 'Д';
			case 'з': result[i] = 'Я';
			case '«': result[i] = 'И';
			case 'и': result[i] = 'Ь';
			case '»': result[i] = 'Е';
			case 'й': result[i] = 'Э';
			case '…': result[i] = 'Е';
			case 'к': result[i] = 'k';
			case ' ': result[i] = 'K';
			case 'л': result[i] = 'Ю';
			case 'Ћ': result[i] = 'З';
			case 'м': result[i] = 'ѓ';
			case 'ћ': result[i] = 'M';
			case 'н': result[i] = 'Ѓ';
			case 'Ќ': result[i] = 'H';
			case 'о': result[i] = 'o';
			case 'ќ': result[i] = 'O';
			case 'п': result[i] = '£';
			case 'ѕ': result[i] = 'М';
			case 'р': result[i] = 'p';
			case '–': result[i] = 'P';
			case 'с': result[i] = 'c';
			case '—': result[i] = 'C';
			case 'т': result[i] = '¶';
			case '“': result[i] = 'П';
			case 'у': result[i] = 'y';
			case '”': result[i] = 'Y';
			case 'ф': result[i] = 'Б';
			case '‘': result[i] = 'Б';
			case 'х': result[i] = 'x';
			case '’': result[i] = 'X';
			case 'ц': result[i] = 'Й';
			case '÷': result[i] = 'Й';
			case 'ч': result[i] = '§';
			case '„': result[i] = 'Н';
			case 'ш': result[i] = '•';
			case 'Ў': result[i] = 'О';
			case 'щ': result[i] = '°';
			case 'ў': result[i] = 'К';
			case 'ь': result[i] = '©';
			case '№': result[i] = 'Т';
			case 'ъ': result[i] = 'Р';
			case 'Џ': result[i] = 'І';
			case 'ы': result[i] = '®';
			case 'џ': result[i] = 'С';
			case 'э': result[i] = '™';
			case 'Ё': result[i] = 'У';
			case 'ю': result[i] = 'Ђ';
			case 'ё': result[i] = 'Ф';
			case '€': result[i] = 'ђ';
			case 'я': result[i] = 'Х';
			default: result[i] = string[i];
		}
	}
	return result;
}


