new RaceGoing[MAX_PLAYERS];

hook OnPlayerEnterCheckpoint(playerid)
{
    new value_1 = GetPlayerData(playerid, P_RACE_CASH);
	new offer_id = GetPlayerData(playerid, P_RACE_RIVAL_NAMEID);
	
	if(GetPVarInt(playerid, "RaceGoing") == 1)
	{
	  	new fmt_str[144];
		DisablePlayerCheckpoint(playerid);
		DisablePlayerCheckpoint(offer_id);
		format(fmt_str, sizeof fmt_str, "[{FFFF00}Гонка 1 на 1{FFFFFF}]: Вы победили в гонке и выиграли %d рублей", value_1);
		SendClientMessage(playerid, -1, fmt_str);
		format(fmt_str, sizeof fmt_str, "[{FFFF00}Гонка 1 на 1{FFFFFF}]: %s победил в гонке и выиграл %d рублей", GetPlayerNameEx(playerid), value_1);
		SendClientMessage(offer_id, -1, fmt_str);
		GivePlayerMoneyEx(playerid, value_1);
		
		new fmt_text[144];
		format(fmt_text, sizeof fmt_text, "Вы получили %d рублей", value_1);
		Notka(playerid, 1, fmt_text, 4, "", "");
		GivePlayerMoneyEx(offer_id, -value_1);
		format(fmt_text, sizeof fmt_text, "Вы потратили %d рублей", value_1);
		Notka(offer_id, 0, fmt_text, 4, "", "");
		SetPVarInt(playerid, "RaceGoing", 0);
		SetPVarInt(offer_id, "RaceGoing", 0);
	}

	if(GetPVarInt(playerid, "RacePoint") == 1)
	{
		DisablePlayerCheckpoint(playerid);
		SetPVarInt(playerid, "RacePoint", 0);
	}
    return Y_HOOKS_CONTINUE_RETURN_1
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    case DIALOG_RACE_POINT:
	{
	if(response)	
    {		
	SetPlayerCheckpoint(playerid, -2662.1933, 301.6230, 10.9561, 20.0);
	SetPVarInt(playerid, "RacePoint", 1);
	}
	return 1;
	}
	case DIALOG_RACE_STOP:
	{
	if(response)	
    {		
    new value_1 = GetPlayerData(playerid, P_RACE_CASH);
    new offer_id = GetPlayerData(playerid, P_RACE_RIVAL_NAMEID);

    new fmt_str[300];
    format(fmt_str, sizeof fmt_str, "[{FFFF00}Гонка 1 на 1{FFFFFF}]: Вы остановили гонку 1 на 1 с игроком {FFFF00}%s {FFFFFF}и ставкой: {FFFF00}%d {FFFFFF}рублей", GetPlayerNameEx(offer_id), value_1);
	SendClientMessage(playerid, -1, fmt_str);
	format(fmt_str, sizeof fmt_str, "[{FFFF00}Гонка 1 на 1{FFFFFF}]: Игрок {FFFF00}%s {FFFFFF}остановил гонку 1 на 1 со ставкой ставкой: {FFFF00}%d {FFFFFF}рублей", GetPlayerNameEx(playerid), value_1);
	SendClientMessage(offer_id, -1, fmt_str);
	
	SetPVarInt(playerid, "RaceGoing", 0);
	SetPVarInt(offer_id, "RaceGoing", 0);
	DisablePlayerCheckpoint(playerid);
    DisablePlayerCheckpoint(offer_id);
	SetPlayerData(playerid, P_RACE_CASH, 0);
	SetPlayerData(offer_id, P_RACE_CASH, 0);
	SetPlayerData(playerid, P_RACE_RIVAL_NAMEID, 0);
	SetPlayerData(offer_id, P_RACE_RIVAL_NAMEID, 0);
	}
	return 1;
	}
    return Y_HOOKS_CONTINUE_RETURN_1;
}

CMD:race(playerid, params[])
{
 if(GetPlayerLevel(playerid) < 3) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Команда доступна с 3 уровня");
 
 extract params -> new to_player, sum;
 
 if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /race [id игрока] [сумма]");
 
 if(!IsPlayerConnected(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
				
if(!IsPlayerDriver(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы должны сидеть за рулем");
if(!IsPlayerDriver(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок должен сидеть за рулем");

if(GetPlayerMoneyEx(playerid) < sum) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}У вас нет суммы которую Вы ввели");
if(GetPlayerMoneyEx(to_player) < sum) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}У игрока нет суммы которую Вы ввели");
if(sum >= 1000000) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Сумма не должна превышать 1.000.000 рублей");
 
 if(IsPlayerInRangeOfPoint(playerid, 20.0, -2662.1933, 301.6230, 10.9561) && IsPlayerInRangeOfPoint(to_player, 20.0, -2662.1933, 301.6230, 10.9561))
 {
 SendPlayerOffer(playerid, to_player, OFFER_TYPE_RACE, sum);
 }
 else SendClientMessage(playerid, 0xCECECEFF, "Вы и игрок должны находиться у моста Лыткарино. Используйте: /racepoint чтобы отметить.");
 
    return 1;
}

CMD:racepoint(playerid)
{
if(GetPlayerLevel(playerid) < 3) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Команда доступна с 3 уровня");

new fmt_text[300];

format(fmt_text, sizeof fmt_text, "Вы хотите отметить место для начала гонки?");
		
Dialog(playerid, DIALOG_RACE_POINT, DIALOG_STYLE_MSGBOX,"{FF6347}KNYAZEV MOBILE {FFFFFF}| Гонка 1 на 1", fmt_text, "Отметить", "Закрыть");

return 1;
}

CMD:racestop(playerid)
{
if(GetPlayerLevel(playerid) < 3) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Команда доступна с 3 уровня");

if(GetPVarInt(playerid, "RaceGoing") == 0) return SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не с кем не участвуете в гонке");

new fmt_text[300];

new value_1 = GetPlayerData(playerid, P_RACE_CASH);
new offer_id = GetPlayerData(playerid, P_RACE_RIVAL_NAMEID);

format(fmt_text, sizeof fmt_text, "Вы действительно хотите остановить гонку 1 на 1 с игроком {FFFF00}%s {FFFFFF}и ставкой: {FFFF00}%d {FFFFFF}рублей?", GetPlayerNameEx(offer_id), value_1);
		
Dialog(playerid, DIALOG_RACE_STOP, DIALOG_STYLE_MSGBOX,"{FF6347}KNYAZEV MOBILE {FFFFFF}| Гонка 1 на 1", fmt_text, "Остановить", "Закрыть");

return 1;
}