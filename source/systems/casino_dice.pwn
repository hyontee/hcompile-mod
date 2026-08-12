#if defined _casino_dice_inc
	#endinput
#endif
#define _casino_dice_inc

#define CASINO_DICE_MIN_BET	1000
#define CASINO_DICE_MAX_BET	50000000

enum CASINO_DICE_TABLE_e {
	tableWorld,
	tableInterior,
	Float:tablePos[6],
	tableObjectID,
	Text3D:tableTextID,
}
static CasinoDiceTableInfo[][CASINO_DICE_TABLE_e] = {
	{ -1, 9, {1180.021, -40.0962, 1000.14, 0.000, 0.000, 0.000} },
	{ -1, 9, {1176.130, -40.0962, 1000.14, 0.000, 0.000, 0.000} },
	{ -1, 9, {1186.181, -40.0962, 1000.14, 0.000, 0.000, 0.000} },
	{ -1, 9, {1189.421, -40.0962, 1000.14, 0.000, 0.000, 0.000} }
};
enum BIKERS_POOL_TABLE_e {
	tableWorld,
	tableInterior,
	Float:tablePos[6],
	tableObjectID,
	Text3D:tableTextID,
}
static BikersPoolTableInfo[][BIKERS_POOL_TABLE_e] = {
	{ 1, BIKERS_INT, {-1001.552062, 1948.104736, 1076.507934, 0.000000, 0.000000, 0.000000} },
	{ 2, BIKERS_INT, {-1001.552062, 1948.104736, 1076.507934, 0.000000, 0.000000, 0.000000} },
	{ 3, BIKERS_INT, {-1001.552062, 1948.104736, 1076.507934, 0.000000, 0.000000, 0.000000} } 
};
stock IsPlayerNearPoolTable(playerid) {
	new id = 0;
	for (new i = 0; i < sizeof (BikersPoolTableInfo); i++) {
		if (!IsPlayerInRangeOfPoint(playerid, 5.0,
			BikersPoolTableInfo[i][tablePos][0], BikersPoolTableInfo[i][tablePos][1], BikersPoolTableInfo[i][tablePos][2])
		) continue;
		if (GetPlayerInterior(playerid) != BikersPoolTableInfo[i][tableInterior]) 
			continue;
		if (GetPlayerVirtualWorld(playerid) != BikersPoolTableInfo[i][tableWorld]) 
			continue;
		id = i + 1;
		break;
	}
	return id;
}
stock IsPlayerNearDiceTable(playerid) {
	new id = 0;
	for (new i = 0; i < sizeof (CasinoDiceTableInfo); i++) {
		if (!IsPlayerInRangeOfPoint(playerid, 5.0,
			CasinoDiceTableInfo[i][tablePos][0], CasinoDiceTableInfo[i][tablePos][1], CasinoDiceTableInfo[i][tablePos][2])
		) continue;
		if (GetPlayerInterior(playerid) != CasinoDiceTableInfo[i][tableInterior]) 
			continue;
		id = i + 1;
		break;
	}
	return id;
}//tempobjid = CreateDynamicObject(2964, -1001.552062, 1948.104736, 1076.507934, 0.000000, 0.000000, 0.000000, -1, BIKERS_INT, -1, 300.00, 300.00); 
dice_OnGameModeInit() {
	for (new i = 0; i < sizeof (CasinoDiceTableInfo); i++) {
		CasinoDiceTableInfo[i][tableObjectID] = CreateDynamicObject(1824, //19474, 
			CasinoDiceTableInfo[i][tablePos][0], CasinoDiceTableInfo[i][tablePos][1], 
			CasinoDiceTableInfo[i][tablePos][2], CasinoDiceTableInfo[i][tablePos][3], 
			CasinoDiceTableInfo[i][tablePos][4], CasinoDiceTableInfo[i][tablePos][5], 
			CasinoDiceTableInfo[i][tableWorld], CasinoDiceTableInfo[i][tableInterior], -1, 100.00, 100.00
		); 
		CasinoDiceTableInfo[i][tableTextID] = CreateDynamic3DTextLabel(""colserver"Игра в кости\n \n"colwhi"Используйте: "colserver"/dice", -1, 
			CasinoDiceTableInfo[i][tablePos][0], CasinoDiceTableInfo[i][tablePos][1], 
			CasinoDiceTableInfo[i][tablePos][2] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
			CasinoDiceTableInfo[i][tableWorld], CasinoDiceTableInfo[i][tableInterior], -1
		);
	}
	for (new i = 0; i < sizeof (BikersPoolTableInfo); i++) {
		BikersPoolTableInfo[i][tableObjectID] = CreateDynamicObject(2964, //19474, 
			BikersPoolTableInfo[i][tablePos][0], BikersPoolTableInfo[i][tablePos][1], 
			BikersPoolTableInfo[i][tablePos][2], BikersPoolTableInfo[i][tablePos][3], 
			BikersPoolTableInfo[i][tablePos][4], BikersPoolTableInfo[i][tablePos][5], 
			BikersPoolTableInfo[i][tableWorld], BikersPoolTableInfo[i][tableInterior], -1, 100.00, 100.00
		); 
		BikersPoolTableInfo[i][tableTextID] = CreateDynamic3DTextLabel(""colserver"Игра в бильярд\n \n"colwhi"Используйте: "colserver"/pool", -1, 
			BikersPoolTableInfo[i][tablePos][0], BikersPoolTableInfo[i][tablePos][1], 
			BikersPoolTableInfo[i][tablePos][2] + 1.0, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1,
			BikersPoolTableInfo[i][tableWorld], BikersPoolTableInfo[i][tableInterior], -1
		);
	}
	return true;
}
/*
CMD:dice(playerid, params[])  {
	if (!IsPlayerNearDiceTable(playerid))
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
	new targetid, bet;
	if (sscanf(params, "ud", targetid, bet) || !(CASINO_DICE_MIN_BET <= bet <= CASINO_DICE_MAX_BET) || targetid == playerid)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dice [id игрока] [ставка] ("#CASINO_DICE_MIN_BET" - "#50_000_000")");
	if (!ProxDetectorS(8.0, playerid, targetid))
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игроком!");

	if (
		pTemp[targetid][tDicePlayerID] != INVALID_PLAYER_ID || 
		pTemp[targetid][tDiceTargetID] != INVALID_PLAYER_ID || 
		kLibGetPlayerMoney(targetid) < bet
	) return SendClientMessage(playerid, COLOR_GREY, !"Данный игрок не может сыграть с вами в данный момент!");

	if (
		pTemp[playerid][tDicePlayerID] != INVALID_PLAYER_ID || 
		pTemp[playerid][tDiceTargetID] != INVALID_PLAYER_ID
	) return SendClientMessage(playerid, COLOR_GREY, !"У вас уже есть активная игра!");

	if (kLibGetPlayerMoney(playerid) < bet) 
		return SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств!");
	
	if (gettime() < pTemp[playerid][tDiceFlood])
		return SendClientMessage(playerid, COLOR_GREY, !"Нельзя так часто предлагать.");
	pTemp[playerid][tDiceFlood] = gettime() + 3;

	SendMes(playerid, COLOR_BLUE, "Вы предложили %s сыграть в кости на %i вирт.", pInfo[targetid][pName], bet);
	SendMes(targetid, COLOR_BLUE, "%s предлагает Вам сыграть в кости на %i вирт.", pInfo[playerid][pName], bet);
	SendClientMessage(targetid, 0x6495EDFF,"(( Нажмите: {33AA33}Y {6495ED}- согласиться или "colred"N {6495ED}- отказаться))");

	pTemp[playerid][tDicePlayerID] = targetid;
	pTemp[targetid][tDiceTargetID] = playerid;
	pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = bet;

	return true;
}
dice_OnPlayerConnect(playerid) {
	pTemp[playerid][tDicePlayerID] = INVALID_PLAYER_ID;
	pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
}
dice_OnPlayerDisconnect(playerid) {
	if (pTemp[playerid][tDiceTargetID] != INVALID_PLAYER_ID) {
		new targetid = pTemp[playerid][tDiceTargetID];
		pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
		SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от игры в кости!");
	}
	if (pTemp[playerid][tDicePlayerID] != INVALID_PLAYER_ID) {
		new targetid = pTemp[playerid][tDicePlayerID];
		pTemp[playerid][tDicePlayerID] = INVALID_PLAYER_ID;
		pTemp[targetid][tDiceTargetID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
		SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от игры в кости!");
	}
}
dice_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (oldkeys & newkeys) 
		return false;
	if (pTemp[playerid][tDiceTargetID] == INVALID_PLAYER_ID) 
		return false;
	new targetid = pTemp[playerid][tDiceTargetID];
	if (newkeys & KEY_YES) {
		if (!IsPlayerNearDiceTable(playerid)) {
			pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
			SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
			SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от игры в кости!");
			return true;
		}
		if (!IsPlayerNearDiceTable(targetid)) {
			pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
			SendClientMessage(targetid, COLOR_GREY, !"Вы должны находиться рядом с игровым столом!");
			SendClientMessage(playerid, COLOR_GREY, !"Игрок отказался от игры в кости!");
			return true;
		}
		new bet = pTemp[playerid][tDiceBet];
		if (kLibGetPlayerMoney(playerid) < bet || kLibGetPlayerMoney(targetid) < bet) {
			pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
			pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
			SendClientMessage(targetid, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в кости!");
			SendClientMessage(playerid, COLOR_GREY, !"У вас или игрока недостаточно средств для игры в кости!");
			return true;
		}
		pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;

		new dice_numbers[2];
		dice_numbers[0] = 6 - random(6) + 1;
		dice_numbers[1] = 6 - random(6) + 1;

		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);
		ApplyAnimation(targetid, "CARRY", "crry_prtial", 4.1, 0, 1, 1, 1, 1);

		if (dice_numbers[0] > dice_numbers[1]) {
			kLibGivePlayerMoney(playerid, bet, "/dice");
			kLibGivePlayerMoney(targetid, -bet, "/dice");

			SendMes(playerid, COLOR_BLUE, "У вас выпало: %i, Вы победили игру в кости и получаете %i вирт!", dice_numbers[0], (bet - (bet/10)));
			SendMes(targetid, COLOR_BLUE, "У вас выпало: %i, Вы проиграли игру в кости и потеряли %i вирт!", dice_numbers[1], bet);
		}
		else if (dice_numbers[0] < dice_numbers[1]) {
			kLibGivePlayerMoney(playerid, -bet, "/dice");
			kLibGivePlayerMoney(targetid, bet, "/dice");

			SendMes(targetid, COLOR_BLUE, "У вас выпало: %i, Вы победили игру в кости и получаете %i вирт!", dice_numbers[1], (bet - (bet/10)));
			SendMes(playerid, COLOR_BLUE, "У вас выпало: %i, Вы проиграли игру в кости и потеряли %i вирт!", dice_numbers[0], bet);
		}
		else {
			SendClientMessage(targetid, COLOR_BLUE, !"Игра в кости закончилась в ничью!");
			SendClientMessage(playerid, COLOR_BLUE, !"Игра в кости закончилась в ничью!");
		}

		new id = pTemp[playerid][tBusinessID];
		BusinessInfo[id][bBank] += (bet/10);
		
		format(t_string, sizeof (t_string), "bBank = %i", BusinessInfo[id][bBank]);
		SaveBusiness(id, t_string);
	
		format(t_string, sizeof (t_string), "Выпало: %i", dice_numbers[0]);
		SetPlayerChatBubble(playerid, t_string, COLOR_YELLOW, 60.0, 5000);
		format(t_string, sizeof (t_string), "Выпало: %i", dice_numbers[1]);
		SetPlayerChatBubble(playerid, t_string, COLOR_YELLOW, 60.0, 5000);

		SetPlayerAttachedObject(playerid, 9, 1851, 6, 0.028000, 0.126000, -0.199999, 
			CasinoDiceAttachPos[dice_numbers[0] - 1][0], CasinoDiceAttachPos[dice_numbers[0] - 1][1], 
			CasinoDiceAttachPos[dice_numbers[0] - 1][2], 1.000000, 1.000000, 1.100999
		);
		SetPlayerAttachedObject(targetid, 9, 1851, 6, 0.028000, 0.126000, -0.199999, 
			CasinoDiceAttachPos[dice_numbers[1] - 1][0], CasinoDiceAttachPos[dice_numbers[1] - 1][1], 
			CasinoDiceAttachPos[dice_numbers[1] - 1][2], 1.000000, 1.000000, 1.100999
		);
		t_string[0] = EOS;

		SetTimerEx("ClearDiceAnim", 3000, false, "d", playerid);
		SetTimerEx("ClearDiceAnim", 3000, false, "d", targetid);

		return true;
	} 
	else if (newkeys & KEY_NO) {
		SendClientMessage(playerid, COLOR_GREY, !"Вы отказались от игры в кости!");
		SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от игры в кости!");
		pTemp[targetid][tDicePlayerID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceTargetID] = INVALID_PLAYER_ID;
		pTemp[playerid][tDiceBet] = pTemp[targetid][tDiceBet] = 0;
		return true;
	}
	return false;
}
*/ 
publics: ClearDiceAnim(playerid) {
	ClearAnim(playerid);
	//ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,1,1,1,1,1);
	RemovePlayerAttachedObject(playerid, 9);
}