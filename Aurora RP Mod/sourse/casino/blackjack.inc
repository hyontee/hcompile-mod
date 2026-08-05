new PlayerText:BlackJacksforPlayer[MAX_PLAYERS][28];
new Text:BlackJacks[7];
new BlackJackCYSH = 0;
new UseBlack = -1;
new MyCard[MAX_PLAYERS][6];
new MyCard2[MAX_PLAYERS][6];
new DeckTextdrw[52][] = {
	"LD_CARD:cd1c", // A Clubs - 0
	"LD_CARD:cd2c", // 2 Clubs - 1
	"LD_CARD:cd3c", // 3 Clubs - 2
	"LD_CARD:cd4c", // 4 Clubs - 3
	"LD_CARD:cd5c", // 5 Clubs - 4
	"LD_CARD:cd6c", // 6 Clubs - 5
	"LD_CARD:cd7c", // 7 Clubs - 6
	"LD_CARD:cd8c", // 8 Clubs - 7
	"LD_CARD:cd9c", // 9 Clubs - 8
	"LD_CARD:cd10c", // 10 Clubs - 9
	"LD_CARD:cd11c", // J Clubs - 10
	"LD_CARD:cd12c", // Q Clubs - 11
	"LD_CARD:cd13c", // K Clubs - 12
	"LD_CARD:cd1d", // A Diamonds - 13
	"LD_CARD:cd2d", // 2 Diamonds - 14
	"LD_CARD:cd3d", // 3 Diamonds - 15
	"LD_CARD:cd4d", // 4 Diamonds - 16
	"LD_CARD:cd5d", // 5 Diamonds - 17
	"LD_CARD:cd6d", // 6 Diamonds - 18
	"LD_CARD:cd7d", // 7 Diamonds - 19
	"LD_CARD:cd8d", // 8 Diamonds - 20
	"LD_CARD:cd9d", // 9 Diamonds - 21
	"LD_CARD:cd10d", // 10 Diamonds - 22
	"LD_CARD:cd11d", // J Diamonds - 23
	"LD_CARD:cd12d", // Q Diamonds - 24
	"LD_CARD:cd13d", // K Diamonds - 25
	"LD_CARD:cd1h", // A Heats - 26
	"LD_CARD:cd2h", // 2 Heats - 27
	"LD_CARD:cd3h", // 3 Heats - 28
	"LD_CARD:cd4h", // 4 Heats - 29
	"LD_CARD:cd5h", // 5 Heats - 30
	"LD_CARD:cd6h", // 6 Heats - 31
	"LD_CARD:cd7h", // 7 Heats - 32
	"LD_CARD:cd8h", // 8 Heats - 33
	"LD_CARD:cd9h", // 9 Heats - 34
	"LD_CARD:cd10h", // 10 Heats - 35
	"LD_CARD:cd11h", // J Heats - 36
	"LD_CARD:cd12h", // Q Heats - 37
	"LD_CARD:cd13h", // K Heats - 38
	"LD_CARD:cd1s", // A Spades - 39
	"LD_CARD:cd2s", // 2 Spades - 40
	"LD_CARD:cd3s", // 3 Spades - 41
	"LD_CARD:cd4s", // 4 Spades - 42
	"LD_CARD:cd5s", // 5 Spades - 43
	"LD_CARD:cd6s", // 6 Spades - 44
	"LD_CARD:cd7s", // 7 Spades - 45
	"LD_CARD:cd8s", // 8 Spades - 46
	"LD_CARD:cd9s", // 9 Spades - 47
	"LD_CARD:cd10s", // 10 Spades - 48
	"LD_CARD:cd11s", // J Spades - 49
	"LD_CARD:cd12s", // Q Spades - 50
	"LD_CARD:cd13s" // K Spades - 51
};

stock TexDrawBlackJack(playerid) {
	BlackJacksforPlayer[playerid][0] = CreatePlayerTextDraw(playerid, 17.500000, 330.166687, "LD_CARD:cd6d");
	BlackJacksforPlayer[playerid][1] = CreatePlayerTextDraw(playerid, 32.875000, 330.000091, "LD_CARD:cd10h");
	BlackJacksforPlayer[playerid][2] = CreatePlayerTextDraw(playerid, 48.250000, 329.833221, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][3] = CreatePlayerTextDraw(playerid, 63.625000, 329.666625, "LD_CARD:cd7c");
	BlackJacksforPlayer[playerid][4] = CreatePlayerTextDraw(playerid, 78.375000, 330.083251, "LD_CARD:cd13c");
	BlackJacksforPlayer[playerid][5] = CreatePlayerTextDraw(playerid, 93.750000, 329.916564, "LD_CARD:cd1h");

	BlackJacksforPlayer[playerid][6] = CreatePlayerTextDraw(playerid, 87.500000, 311.500091, "1");
	PlayerTextDrawLetterSize(playerid, BlackJacksforPlayer[playerid][6], 0.449999, 1.600000);
	PlayerTextDrawTextSize(playerid, BlackJacksforPlayer[playerid][6], 5.000000, 145.249877);
	PlayerTextDrawAlignment(playerid, BlackJacksforPlayer[playerid][6], 2);
	PlayerTextDrawColor(playerid, BlackJacksforPlayer[playerid][6], -1);
	PlayerTextDrawUseBox(playerid, BlackJacksforPlayer[playerid][6], true);
	PlayerTextDrawBoxColor(playerid, BlackJacksforPlayer[playerid][6], -5963521);
	PlayerTextDrawSetOutline(playerid, BlackJacksforPlayer[playerid][6], 1);
	PlayerTextDrawBackgroundColor(playerid, BlackJacksforPlayer[playerid][6], 51);
	PlayerTextDrawFont(playerid, BlackJacksforPlayer[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, BlackJacksforPlayer[playerid][6], 1);

	BlackJacksforPlayer[playerid][7] = CreatePlayerTextDraw(playerid, 67.375000, 144.166519, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][8] = CreatePlayerTextDraw(playerid, 76.500000, 144.583175, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][9] = CreatePlayerTextDraw(playerid, 85.000000, 144.416503, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][10] = CreatePlayerTextDraw(playerid, 94.125000, 144.249847, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][11] = CreatePlayerTextDraw(playerid, 102.625000, 144.666519, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][12] = CreatePlayerTextDraw(playerid, 110.500000, 144.499862, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][13] = CreatePlayerTextDraw(playerid, 259.625000, 144.333190, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][14] = CreatePlayerTextDraw(playerid, 268.125000, 144.166534, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][15] = CreatePlayerTextDraw(playerid, 277.250000, 144.583206, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][16] = CreatePlayerTextDraw(playerid, 286.375000, 144.416549, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][17] = CreatePlayerTextDraw(playerid, 295.500000, 144.249847, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][18] = CreatePlayerTextDraw(playerid, 304.625000, 144.666519, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][19] = CreatePlayerTextDraw(playerid, 445.625000, 144.499862, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][20] = CreatePlayerTextDraw(playerid, 454.125000, 144.333190, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][21] = CreatePlayerTextDraw(playerid, 463.250000, 144.166534, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][22] = CreatePlayerTextDraw(playerid, 472.375000, 144.583206, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][23] = CreatePlayerTextDraw(playerid, 480.250000, 144.416549, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][24] = CreatePlayerTextDraw(playerid, 489.375000, 144.249877, "LD_CARD:cd13s");
	BlackJacksforPlayer[playerid][25] = CreatePlayerTextDraw(playerid, 56.250000, 128.333328, "Alvaro_Carmen~n~~n~~n~~n~~n~~n~        10");
	BlackJacksforPlayer[playerid][26] = CreatePlayerTextDraw(playerid, 249.125000, 128.749984, "Alvaro_Carmen~n~~n~~n~~n~~n~~n~        10");
	BlackJacksforPlayer[playerid][27] = CreatePlayerTextDraw(playerid, 433.250000, 128.583328, "Alvaro_Carmen~n~~n~~n~~n~~n~~n~        10");
	////////////////////////////////////////////////////////////////////////////////////
	for(new j = 0;j < 27;j++)
	{
	    if(j == 6) continue;
	    if(j < 6) PlayerTextDrawTextSize(playerid, BlackJacksforPlayer[playerid][j], 64.375000, 86.333312), PlayerTextDrawFont(playerid, BlackJacksforPlayer[playerid][j], 4);
	    if(j >= 7 && j < 25)
	    {
	        PlayerTextDrawLetterSize(playerid, BlackJacksforPlayer[playerid][j], -0.068749, -0.554166);
			PlayerTextDrawTextSize(playerid, BlackJacksforPlayer[playerid][j], 46.875000, 56.583316);
			PlayerTextDrawBackgroundColor(playerid, BlackJacksforPlayer[playerid][j], 255);
			PlayerTextDrawFont(playerid, BlackJacksforPlayer[playerid][j], 4);
	    }
	    if(j >= 25)
	    {
	        PlayerTextDrawLetterSize(playerid, BlackJacksforPlayer[playerid][j], 0.379999, 1.378332);
			PlayerTextDrawSetOutline(playerid, BlackJacksforPlayer[playerid][j], 1);
			PlayerTextDrawBackgroundColor(playerid, BlackJacksforPlayer[playerid][j], 51);
			PlayerTextDrawFont(playerid, BlackJacksforPlayer[playerid][j], 2);
			PlayerTextDrawSetProportional(playerid, BlackJacksforPlayer[playerid][j], 1);
	    }
	    PlayerTextDrawAlignment(playerid, BlackJacksforPlayer[playerid][j], 1);
		PlayerTextDrawColor(playerid, BlackJacksforPlayer[playerid][j], -1);
	}
}
stock ExitOfBlackJackPlayer(playerid) {
	new string[50];
	if(UseBlack == playerid && Iter_Count(BlackJackIT) >= 2) {
	    UseBlack = Iter_Next(BlackJackIT,playerid);
		if(!IsPlayerConnected(UseBlack)) UseBlack = Iter_First(BlackJackIT);
		if(!IsPlayerConnected(UseBlack)) UseBlack = Iter_Random(BlackJackIT);
		if(Iter_Count(BlackJackIT) < 1) UseBlack = -1,BlackJackCYSH = 0;
		else {
			if(UseBlack == Iter_First(BlackJackIT)) StartFindWinner();
			else SendClientMessage(UseBlack,-1,"Âàø õîä...");
			foreach(BlackJackIT,i) {
			    format(string,50,"%s âûøåë èç ïàðòèè!",PlayerInfo[playerid][pName]);
				SendClientMessage(i,-1,string);
		    }
		}
	}
	GiveTurnForPlayer(playerid);
	SetPVarInt(playerid,"BetBlack",0);
	SetPVarInt(playerid,"TDBlackJacks",0);
	Iter_Remove(BlackJackIT, playerid);
	for(new kyky = 0;kyky < 28;kyky++) {
		PlayerTextDrawHide(playerid,BlackJacksforPlayer[playerid][kyky]);
		if(kyky < 7)TextDrawHideForPlayer(playerid,BlackJacks[kyky]);
	}
	return true;
}
stock TranslateText(string[]) {
	new result[128];
	for(new i = 0; i < strlen(string); i++) {
		switch(string[i]) {
			case 'à': result[i] = 'a';
			case 'À': result[i] = 'A';
			case 'á': result[i] = '—';
			case 'Á': result[i] = '€';
			case 'â': result[i] = '¢';
			case 'Â': result[i] = '‹';
			case 'ã': result[i] = '™';
			case 'Ã': result[i] = '‚';
			case 'ä': result[i] = 'š';
			case 'Ä': result[i] = 'ƒ';
			case 'å': result[i] = 'e';
			case 'Å': result[i] = 'E';
			case '¸': result[i] = 'e';
			case '¨': result[i] = 'E';
			case 'æ': result[i] = '›';
			case 'Æ': result[i] = '„';
			case 'ç': result[i] = 'Ÿ';
			case 'Ç': result[i] = 'ˆ';
			case 'è': result[i] = 'œ';
			case 'È': result[i] = '…';
			case 'é': result[i] = '';
			case 'É': result[i] = '…';
			case 'ê': result[i] = 'k';
			case 'Ê': result[i] = 'K';
			case 'ë': result[i] = 'ž';
			case 'Ë': result[i] = '‡';
			case 'ì': result[i] = '¯';
			case 'Ì': result[i] = 'M';
			case 'í': result[i] = '®';
			case 'Í': result[i] = '­';
			case 'î': result[i] = 'o';
			case 'Î': result[i] = 'O';
			case 'ï': result[i] = '£';
			case 'Ï': result[i] = 'Œ';
			case 'ð': result[i] = 'p';
			case 'Ð': result[i] = 'P';
			case 'ñ': result[i] = 'c';
			case 'Ñ': result[i] = 'C';
			case 'ò': result[i] = '¦';
			case 'Ò': result[i] = '';
			case 'ó': result[i] = 'y';
			case 'Ó': result[i] = 'Y';
			case 'ô': result[i] = '';
			case 'Ô': result[i] = '';
			case 'õ': result[i] = 'x';
			case 'Õ': result[i] = 'X';
			case 'ö': result[i] = '‰';
			case 'Ö': result[i] = '‰';
			case '÷': result[i] = '¤';
			case '×': result[i] = '';
			case 'ø': result[i] = '¥';
			case 'Ø': result[i] = 'Ž';
			case 'ù': result[i] = '¡';
			case 'Ù': result[i] = 'Š';
			case 'ü': result[i] = '©';
			case 'Ü': result[i] = '’';
			case 'ú': result[i] = '';
			case 'Ú': result[i] = '§';
			case 'û': result[i] = '¨';
			case 'Û': result[i] = '‘';
			case 'ý': result[i] = 'ª';
			case 'Ý': result[i] = '“';
			case 'þ': result[i] = '«';
			case 'Þ': result[i] = '”';
			case 'ÿ': result[i] = '¬';
			case 'ß': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	return result;
}