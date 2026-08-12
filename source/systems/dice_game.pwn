#if defined _dice_game_inc
	#endinput
#endif
#define _dice_game_inc

// Кости
#define			MAX_BONE_TABLE		4	// кол-во столов в кости

new Iterator: DicePlayers[MAX_BONE_TABLE]<MAX_PLAYERS>;

new Text: Bone[4];
new PlayerText: PlayerBone[MAX_PLAYERS][4];

new
    Float: BoneCoor[MAX_BONE_TABLE][4] ={
	{1943.151123, 1030.103759, 991.968750, 0.0},
	{1943.151123, 1021.302612, 991.968750, 0.0},
	{1943.151123, 1014.682495, 991.968750, 0.0},
	{1943.151123, 1005.922973, 991.968750, 0.0}
};


enum _bone_table_info
{
	bPlayer[5], // id игроков в кости
	bRate, // ставка $
	bBank, // общая сумма
	bCroupier, // id крупье
	GameStart // старт отсчёт до завершения игры
}
new BoneInfo[MAX_BONE_TABLE][_bone_table_info];


stock IsPlayerNearBone(playerid)
{
	for(new i; i <sizeof(BoneCoor); i++) {
		if (IsPlayerInRangeOfPoint(playerid, 2.0, BoneCoor[i][0],BoneCoor[i][1],BoneCoor[i][2])) return i;
	}
  	return -1;
}

stock bone_OnGameModeInit()
{
    Iter_Init(DicePlayers);
    for(new i; i < MAX_BONE_TABLE; i++)
	{
        Iter_Clear(DicePlayers[i]);
		CreateDynamicObject(1824, BoneCoor[i][0], BoneCoor[i][1], BoneCoor[i][2], 0.0, 0.0, BoneCoor[i][3]);
        BoneInfo[i][bCroupier] = INVALID_PLAYER_ID;
    	for(new idx= 0; idx < 5; idx++){
            BoneInfo[i][bPlayer][idx] = INVALID_PLAYER_ID;
        }
    	BoneInfo[i][GameStart] = 0;
	} 
    return true;
}



stock bone_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {

    #pragma unused oldkeys
	switch (newkeys)
    {
        case KEY_SECONDARY_ATTACK:
        {
            if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
            {
                new NumberDiceTable = IsPlayerNearBone(playerid);

                if(NumberDiceTable != -1)
                {
                    //if (GetPlayerAdminSearch(playerid) != 0 && GetPlayerAdminSearch(playerid) < 5) return SendClientMessage(playerid, COLOR_GREY, !"На вопросы отвечайте, а не в казино играйте.");
                    
                    if (GetPVarInt(playerid,"CasinoRank") && BoneInfo[NumberDiceTable][bCroupier] != INVALID_PLAYER_ID) return SendClientMessage(playerid, COLOR_GREY, !"Тут уже работает крупье!");
                    if (pTemp[playerid][tDiceTable] != -1) return SendClientMessage(playerid, COLOR_GREY, !"Ты уже зарегистрирован на другом столе!");

                    if (!Iter_Contains(DicePlayers[NumberDiceTable], playerid)) {
                        Iter_Add(DicePlayers[NumberDiceTable], playerid);
                        pTemp[playerid][tDiceTable] = NumberDiceTable;

                        if (GetPVarInt(playerid,"CasinoRank")){
                            BoneInfo[NumberDiceTable][bCroupier] = playerid;
                        }

                        for (new i; i != 4; i++) {
                            TextDrawShowForPlayer(playerid, Bone[i]);
                            PlayerTextDrawShow(playerid, PlayerBone[playerid][i]);
                        }

                        SelectTextDraw(playerid, 0x33AAFFFF);
                        UpdateBone(NumberDiceTable);
                        return true;
                    }
                }
            }
        }
    }
    return false;
}


stock  bone_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(pTemp[playerid][tDiceTable] == -1) return false;

    new NumberDiceTable = pTemp[playerid][tDiceTable];

    if (clickedid == Text:INVALID_TEXT_DRAW){
        SelectTextDraw(playerid, 0x33AAFFFF);
        return true;
    }

    if (clickedid == Bone[1]) // SET_BET
    {
        new null = 0;
        for(new i; i < 5; i++){

            if(BoneInfo[NumberDiceTable][bPlayer][i] != INVALID_PLAYER_ID){
                null++;
            }
        }
        if (GetPVarInt(playerid,"CasinoRank"))
		{
			if (null > 0)
                SendClientMessage(playerid, COLOR_GREY, !"В данный момент вы не можете изменить ставку!");
            else
                ShowPlayerDialog(playerid,D_BONE_STAVKA,1,"Установка ставки для игры:","Ставка должна быть не менее $1000\nи не более $300.000.000 Введите сумму ставки..","Далее","Отмена");
        }
        else
        {
            if (null > 4){
                SendClientMessage(playerid, COLOR_GREY, !"В данный момент все игровые места заняты!");
            }
            else
            {
                if (BoneInfo[NumberDiceTable][bRate] < 1) return SendClientMessage(playerid, COLOR_GREY, !"Ставка не установлена!"),1;
                if (GetPVarInt(playerid,"BoneStol_")) return SendClientMessage(playerid, COLOR_GREY, !"Ты уже поставил ставку!"),1;

                if (kLibGetPlayerMoney(playerid) < BoneInfo[NumberDiceTable][bRate]) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно средств!"),1;
    	        if (BoneInfo[NumberDiceTable][GameStart] > 0) return SendClientMessage(playerid, COLOR_GREY, !"Игра уже запущена!"),1;
                new search_number;
                for(new i; i < 5; i++){

                    if(BoneInfo[NumberDiceTable][bPlayer][i] == INVALID_PLAYER_ID){
                        BoneInfo[NumberDiceTable][bPlayer][i] = playerid;
                        search_number++;
                        break;
                    }
                }
                if(!search_number) return false;

                kLibGivePlayerMoney(playerid, -BoneInfo[NumberDiceTable][bRate], "изменил ставку казино"/*,.type = PLAYER*/);

                BoneInfo[NumberDiceTable][bBank] += BoneInfo[NumberDiceTable][bRate];

                SetPVarInt(playerid,"BoneStol_",1);
                UpdateBone(NumberDiceTable);
            }
        }
        return true;
    }
    else if (clickedid == Bone[2]) // DICE
    {
        new null = 0;
        if (GetPVarInt(playerid,"CasinoRank"))
		{
            for(new i; i < 5; i++){

                if(BoneInfo[NumberDiceTable][bPlayer][i] != INVALID_PLAYER_ID){
                    null++;
                }
            }
            if(null < 2){
                SendClientMessage(playerid, COLOR_GREY, !"Нехватает игроков для старта!");
            }
            else{
                if(BoneInfo[NumberDiceTable][GameStart] > 0 ){
                    SendClientMessage(playerid, COLOR_GREY, !"Игра уже запущена!");
                }
                else BoneInfo[NumberDiceTable][GameStart] = 15;
            }
        }
        else
        {
            if (!GetPVarInt(playerid,"BoneStol_")) return SendClientMessage(playerid, COLOR_GREY, !"Вы не поставили ставку!"),1;
		    if (BoneInfo[NumberDiceTable][GameStart] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент нельзя кинуть кости"),1;
	  		if (GetPVarInt(playerid,"BoneStol_") > 1) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже кидали кубики в этом раунде!"),1;
            
			SetPVarInt(playerid,"BoneStol_",random(11) + 2);

            foreach(new i: DicePlayers[NumberDiceTable])
		 	{
                if (GetPVarInt(i,"BoneStol_") == 1) null++;
			}
			if (!null) BoneInfo[NumberDiceTable][GameStart] = 2;

            UpdateBone(NumberDiceTable);
        }
        return true;
    }
    else if (clickedid == Bone[3]) // EXIT
    {
        ShowPlayerDialog(playerid, D_EXIT_BONE, 0, "Предупреждение","Если вы сделали ставку и игра уже началась, то деньги вам не вернутся!\nВы точно хотите покинуть стол?","Ок","Отмена");
        return true;
    }

    return false;
}

stock bone_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused listitem
	switch(dialogid)
	{
        case D_EXIT_BONE:
        {
            if (!response) return 1;
            return ExitBone(playerid);
        }
        case D_BONE_STAVKA:
        {
            if (!response) return 1;

            if(pTemp[playerid][tDiceTable] == -1 || !GetPVarInt(playerid,"CasinoRank") ) {
                SendClientMessage(playerid, COLOR_GREY, !"[Ошибка] Вы не этим столом / крупье!");
                return false;
            }

            new 
                amount = strval(inputtext);
            if (amount < 1000 || amount > 300_000_000) {
                SendClientMessage(playerid, COLOR_GREY, !"Неверная ставка");
                return false;
            }
            new NumberDiceTable = pTemp[playerid][tDiceTable];
            if(NumberDiceTable == -1) return false;
            new null = 0;
            for(new i; i < 5; i++){
                if (GetPVarInt(BoneInfo[NumberDiceTable][bPlayer][i],"BoneStol_")) null++;
            }
            if (null > 0) {
                SendClientMessage(playerid, COLOR_GREY, !"Кто то из игроков уже поставил ставку");
                return false;
            }
            if (BoneInfo[NumberDiceTable][GameStart] != 0) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы не можете изменить ставку в процессе игры!");
                return false;
            }
            BoneInfo[NumberDiceTable][bRate] = amount;
            SendClientMessage(playerid,COLOR_INDIGO,!"Ставка успешно установлена!");
            UpdateBone(NumberDiceTable);
            return 1;
        }
    }
    return false;
}

stock bone_OnPlayerDisconnect(playerid)
{//
    ExitBone(playerid);
}

stock UpdateBone(idx)
{
	new 
		str_[MAX_PLAYER_NAME+4],
        str_bet[60],
        str_bets[26],
		string_[(MAX_PLAYER_NAME*5) + 16];

    string_[0] = EOS;

    for(new i_ = 0, id; i_ < 5; i_++)
    {
        id = BoneInfo[idx][bPlayer][i_];
        if (id != INVALID_PLAYER_ID && IsPlayerConnected(id)){
            format(str_, sizeof (str_), "%s~n~",pInfo[ id ][pName]);
            if(GetPVarInt(id,"BoneStol_") > 1) format(str_bet, sizeof(str_bet),"%d~n~",GetPVarInt(id,"BoneStol_"));
            else str_bet = "++~n~";
        }
        else {
            format(str_, sizeof (str_), "--~n~");
            str_bet = "--~n~";
        }
        strcat(string_, str_);
        strcat(str_bets, str_bet);
    }
    format(str_, sizeof str_, "Table:_%d", idx+1);

    foreach(new i: DicePlayers[idx])
    {
        PlayerTextDrawSetString(i,PlayerBone[i][0], str_);
        PlayerTextDrawSetString(i, PlayerBone[i][1], string_);
        PlayerTextDrawSetString(i,PlayerBone[i][2], str_bets);

        format(str_bet, sizeof(str_bet), "Bet:_%d~n~Bank:_%d~n~Money:_%d", BoneInfo[idx][bRate],BoneInfo[idx][bBank],pInfo[i][pCash]);
        PlayerTextDrawSetString(i,PlayerBone[i][3], str_bet);
    }

	return 1;
}


stock dicetable_Timer()
{
    for(new i; i < MAX_BONE_TABLE; i++)
 	{
   		if (BoneInfo[i][GameStart] > 0)
   		{
			BoneInfo[i][GameStart] --;
            foreach(new g: DicePlayers[i])
			{
                if (pTemp[g][tDiceTable] == i && (GetPVarInt(g,"BoneStol_") || BoneInfo[i][bCroupier] == g))
				{
				    if (BoneInfo[i][GameStart] <= 1 && GetPVarInt(g,"BoneStol_") == 1)
					{
						SetPVarInt(g,"BoneStol_",random(11) + 2);
						UpdateBone(i);
					}
				    else if (BoneInfo[i][GameStart] > 0)
				    {
				        new str_[18];
	 					format(str_,sizeof(str_),"~g~%d",BoneInfo[i][GameStart]);
	  					GameTextForPlayer(g,str_,1200,6);
					}
		 	 	}
		  	}
		  	if (BoneInfo[i][GameStart] <= 1)
		  		ShowItog(i);
		}
   	} 
}


stock ShowItog(idx)
{
	new itog[3] = {-1,-1,-1}, 
        string_[128];

    foreach(new i: DicePlayers[idx])
  	{
		if (GetPVarInt(i,"BoneStol_") > 1 && GetPVarInt(i,"BoneStol_") > itog[0])
		{
			itog[0] = GetPVarInt(i,"BoneStol_"); // запоминаем наибольшее число
			itog[1] = i; // запоминаем ид игрока у кого число больше
		}
		if (GetPVarInt(i,"BoneStol_") > 1 && i != itog[1] && GetPVarInt(i,"BoneStol_") == itog[0])
		{
			itog[2] = i; // находим 2 похожих числа ( максимальных )
		}
	}
	if (itog[2] > -1) // если есть 2 похожих числа
	{
	    foreach(new i: DicePlayers[idx])
	    {
		    if (GetPVarInt(i,"BoneStol_") == itog[0]) // если у кого-то такое же число
			{
				SetPVarInt(i,"BoneStol_",1); // даем возможность перекинуть
				BoneInfo[idx][GameStart] = 30;
				SendClientMessage(i,0x4B00B0AA,"Вы попали в следующий раунд. У вас есть 30 секунд, чтобы бросить кости");
			}
		    else // иначе забираем возможность перекинуть
			{
                for(new x; x < 5; x++){
                    if(BoneInfo[idx][bPlayer][x] == i){
                       BoneInfo[idx][bPlayer][x] = INVALID_PLAYER_ID;
                    }
                }
				DeletePVar(i,"BoneStol_");
			}
		}
		UpdateBone(idx);
	}
	else if (itog[1] > -1 && IsPlayerConnected(itog[1]) ) // иначе объявляяем победителя
	{
        if (!pInfo[ itog[1] ][pLogin] ) return 1;

	  	format(string_,sizeof(string_),"Игра окончена. Победитель игры: %s ( Кости: %d )",pInfo[ itog[1] ][pName],itog[0]);
	  	new 
		  	bank_s = BoneInfo[idx][bBank]/100*10;
        
		//new winvalue = (BoneInfo[idx][bBank] / 100) * 98;
		//new jobvalue = (BoneInfo[idx][bBank] / 100) * 1;
	  	switch(idx)
		{
  			case 0..5:
	    	{
      			if (CasinoInfo[1][caMafia] == 6) FractionInfo[6][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[6][fID], false);
		    	else if (CasinoInfo[1][caMafia] == 14) FractionInfo[14][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[14][fID], false);
		     	else if (CasinoInfo[1][caMafia] == 5) FractionInfo[5][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[5][fID], false);
		    }
		    default:
		    {
      			if (CasinoInfo[2][caMafia] == 6) FractionInfo[6][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[6][fID], false);
		    	else if (CasinoInfo[2][caMafia] == 14) FractionInfo[14][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[14][fID], false);
		     	else if (CasinoInfo[2][caMafia] == 5) FractionInfo[5][fMoney] += bank_s, SaveFractionInfoID(FractionInfo[5][fID], false);
		    }
		}
	  	if (BoneInfo[idx][bCroupier] != INVALID_PLAYER_ID && IsPlayerConnected(BoneInfo[idx][bCroupier])) {
			pInfo[ BoneInfo[idx][bCroupier] ][pPayCheck] += 150;
		}

	  	kLibGivePlayerMoney(itog[1], (BoneInfo[idx][bBank]-(BoneInfo[idx][bBank]/10)), "ShowItog победил"/*,.type = SERVER*/);

	  	BoneInfo[idx][GameStart] =
		BoneInfo[idx][bRate] =
		BoneInfo[idx][bBank] = 0;
        
        for(new x; x < 5; x++){
            BoneInfo[idx][bPlayer][x] = INVALID_PLAYER_ID;
        }

		foreach(new i: DicePlayers[idx])
		{
            SendClientMessage(i, 0x4B00B0AA, string_);

            if (GetPVarInt(i,"BoneStol_") )  DeletePVar(i,"BoneStol_");

            if (!IsPlayerInRangeOfPoint(i, 3.2, BoneCoor[idx][0],BoneCoor[idx][1],BoneCoor[idx][2])) 
            {
                ExitBone(i);
                continue;
            }
	  	}
	  	UpdateBone(idx);
	}
  	return 1;
}


stock ExitBone(playerid)
{
    new NumberDiceTable = pTemp[playerid][tDiceTable];
    if (NumberDiceTable == -1) return 1;

	new null[2] = 0;
	if (GetPVarInt(playerid,"BoneStol_") == 1 && BoneInfo[NumberDiceTable][GameStart] <= 0)
	{
		kLibGivePlayerMoney(playerid,BoneInfo[NumberDiceTable][bRate], "ExitBone"/*,.type = SERVER*/);
		BoneInfo[NumberDiceTable][bBank] -= BoneInfo[NumberDiceTable][bRate];
	}
    foreach(new i: DicePlayers[NumberDiceTable])
 	{
		if (!pInfo[i][pLogin]) continue;
		if (i != playerid && GetPVarInt(i,"BoneStol_") == 1) null[0]++;
		if (i != playerid && GetPVarInt(i,"BoneStol_") > 1) null[1]++;
	}
	if (null[0] == 0 && null[1] > 0)
	{
		ShowItog(NumberDiceTable);
	}
	if (BoneInfo[NumberDiceTable][bCroupier] == playerid)
	{
		BoneInfo[NumberDiceTable][bCroupier] = INVALID_PLAYER_ID;
	}
	for(new i; i != 4; i++){
        TextDrawHideForPlayer(playerid,Bone[i]);
        PlayerTextDrawHide(playerid,PlayerBone[playerid][i]);
    }
	for(new i_ = 0; i_ != 5; i_++)
	{
		if (BoneInfo[NumberDiceTable][bPlayer][i_] == playerid)
		{
			BoneInfo[NumberDiceTable][bPlayer][i_] = INVALID_PLAYER_ID;
            UpdateBone(NumberDiceTable);
		}
	}

    if (Iter_Contains(DicePlayers[NumberDiceTable], playerid)) {
        Iter_Remove(DicePlayers[NumberDiceTable], playerid);
    }

	DeletePVar(playerid,"BoneStol_");
    pTemp[playerid][tDiceTable] = -1;
    CancelSelectTextDraw(playerid);
	return 1;
}