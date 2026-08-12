
////////////// pInfo


	pCasinoDice,
	pCasinoChips,
	pPokerChips,
	pPokerTutorialKey,
	pPokerTutorialStep,
	pPokerTableID,
	pPokerLanguage,
	pCasinoLanguage,
	pPokerOptions,
	pPokerActiveHand,
	pPokerActionActive,
	pPokerStatus_STR[32],
	pPokerResult_STR[32],
	pPokerCard[2],
	pPokerStatus,
	pPokerRaised,
	pPokerRaisedTime,
	pPokerBet,
	pPokerActiveID,
	pPokerTime,
	pPokerDealer,
	pPokerSeatID,
	pPokerHandRanking,
	Float:pPokerPos[3],
	pPokerWinner,
	pPokerHide,
	pPokerResult[2],
	pPokerGUI,
	pPokerDealerIcon,


////////////// pInfo













	tCasinoChipsPTD,
	tCasinoRouletteTable,
	tCasinoRouletteBet,
	tCasinoRouletteChips,
	tCasinoRouletteChipsPos,
	tCasinoRouletteChipsObject,

/////////////// pTemp


































	
	#if defined _poker_included
	case DIALOG_POKER_LEAVE: {
		if (!response)
			return true;
		if (PI[playerid][pPokerTutorialStep])
			poker_StopTutorial(playerid);
		else poker_LeaveGame(playerid);

		return true;
	}
	case DIALOG_POKER_CALL: {
		PI[playerid][pPokerActionActive] = 0;

		if (!response)
			return true;
		new
			tableid = (PI[playerid][pPokerTableID] - 1),
			poker_actual_bet = (pokerTableInfo[tableid][pokerTableBet] - PI[playerid][pPokerBet])
		;
		new poker_text_td[MAX_PLAYER_NAME + 22];
		if (poker_actual_bet > (PI[playerid][pPokerChips] + PI[playerid][pPokerBet])) {
			PI[playerid][pPokerBet] += PI[playerid][pPokerChips];
			PI[playerid][pPokerChips] = 0;
		}
		else {
			PI[playerid][pPokerChips] -= poker_actual_bet;
			PI[playerid][pPokerBet] = pokerTableInfo[tableid][pokerTableBet];
		}
		//SetPlayerInt(GetName(playerid), "casino_chips", PI[playerid][pPokerChips]);
		pokerTableInfo[tableid][pokerTablePot] += PI[playerid][pPokerBet];
		format(PI[playerid][pPokerStatus_STR], 32, "~p~%d~n~~y~CALLED", PI[playerid][pPokerBet]);

		PI[playerid][pPokerRaisedTime] = 0;

		format(poker_text_td, sizeof(poker_text_td), "%s ~y~CALLED TO ~p~%d", GetName(playerid), PI[playerid][pPokerBet]);
		poker_SendChat(tableid, poker_text_td);
		poker_NextTurn(tableid);

		ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);

		return true;
	}
	case DIALOG_POKER_RAISE: {
		PI[playerid][pPokerActionActive] = 0;

		if (!response)
			return true;
		new
			tableid = (PI[playerid][pPokerTableID] - 1),
			poker_actual_raise = strval(inputtext) - PI[playerid][pPokerBet]
		;
		if (strval(inputtext) >= pokerTableInfo[tableid][pokerTableBet] + pokerTableInfo[tableid][pokerTableBlind] / 2 && strval(inputtext) <= PI[playerid][pPokerBet] + PI[playerid][pPokerChips]) {
			PI[playerid][pPokerRaised] = pokerTableInfo[tableid][pokerTableCardsActive];
			PI[playerid][pPokerRaisedTime]++;
			pokerTableInfo[tableid][pokerTableLastRaiseID] = playerid;

			PI[playerid][pPokerChips] -= poker_actual_raise;
			PI[playerid][pPokerBet] = (pokerTableInfo[tableid][pokerTableBet] = strval(inputtext));
			format(PI[playerid][pPokerStatus_STR], 32, "~p~%d~n~~y~RAISED", PI[playerid][pPokerBet]);

			//SetPlayerInt(GetName(playerid), "casino_chips", PI[playerid][pPokerChips]);
			pokerTableInfo[tableid][pokerTablePot] += poker_actual_raise;
			pokerTableInfo[tableid][pokerTableRot] = 0;

			new poker_text_td[MAX_PLAYER_NAME + 22];
			format(poker_text_td, sizeof(poker_text_td), "%s ~y~RAISED TO ~p~%d", GetName(playerid), PI[playerid][pPokerBet]);
			poker_SendChat(tableid, poker_text_td);

			poker_NextTurn(tableid);

			ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
		}
		else poker_ShowMenu(playerid, PM_MENU_RAISE);

		return true;
	}
	#endif

	#if defined _blackjack_included
	case DIALOG_BLACKJACK_BET: {
		if (!response)
			return SelectTextDraw(playerid, 0x000000FF), false;

		new tableid = (BJ_PlayerInfo[playerid][pBlackJackTableID] - 1), amount = strval(inputtext);

		if (blackjackTableInfo[tableid][blackjackTableStatus] != BLACKJACK_STATUS_STARTING) {
			SelectTextDraw(playerid, 0x000000FF);
			return true;
		}
		if (amount < blackjackTableInfo[tableid][blackjackTableMinBet] || amount > blackjackTableInfo[tableid][blackjackTableMaxBet] || amount > PI[playerid][pCasinoChips]) {
			format(t_string, sizeof(t_string),
				"{FFFFFF}Введите сумму ставки {9932CC}(%d - %d){FFFFFF}:\n\nУ вас в наличии: {9932CC}%d фишек",
				blackjackTableInfo[tableid][blackjackTableMinBet], blackjackTableInfo[tableid][blackjackTableMaxBet], PI[playerid][pCasinoChips]
			);
			return ShowPlayerDialog(playerid, DIALOG_BLACKJACK_BET, DIALOG_STYLE_INPUT, "{9932CC}Black Jack", t_string, "Принять", "Выйти"), t_string[0] = EOS;
		}

		SetPVarInt(playerid, "Anticheat::Dialog_ID", 0);
		BJ_PlayerInfo[playerid][pBlackJackLastBet] =
		BJ_PlayerInfo[playerid][pBlackJackBet][BJ_PlayerInfo[playerid][pBlackJackBlockID]] = amount;

		SelectTextDraw(playerid, 0x000000FF);

		ApplyAnimation(playerid, "CASINO", "cards_raise", 4.1, 0, 1, 1, 1, 1, 1);
		return true;
	}

	case DIALOG_BLACKJACK_LEAVE: {
		SelectTextDraw(playerid, 0x000000FF);
		if (response) blackjack_LeaveGame(playerid);
		return true;
	}
	#endif


















///pickup main

			#if defined _casino_included
			case 98: {
				
			}
			#endif















	#if defined _casino_included
		casino_OnPlayerConnect(playerid);
	#endif




	
	#if defined _casino_included
		casino_OnPlayerDisconnect(playerid);
	#endif
	#if defined _poker_included
		poker_OnPlayerDisconnect(playerid);
	#endif
	#if defined _blackjack_included
		blackjack_OnPlayerDisconnect(playerid);
	#endif







	
	#if defined _casino_included
		casino_OnPlayerDeath(playerid);
	#endif
	#if defined _poker_included
		poker_OnPlayerDeath(playerid);
	#endif
	#if defined _blackjack_included
		blackjack_OnPlayerDeath(playerid);
	#endif







// second update
	
	#if defined _casino_included
		casino_Timer();
	#endif
	#if defined _poker_included
		poker_Timer();
	#endif
	#if defined _blackjack_included
		blackjack_Timer();
	#endif




		#if defined _casino_included
			casino_PlayerTimer(playerid);
		#endif



	
public OnGameModeExit()
{
	#if defined _poker_included
		Iter_Clear(pokerTables);
	#endif
	#if defined _blackjack_included
		Iter_Clear(blackjackTables);
	#endif









	
	#if defined _casino_included
		casino_OnGameModeInit();
	#endif
	#if defined _poker_included
		poker_OnGameModeInit();
	#endif
	#if defined _blackjack_included
		blackjack_OnGameModeInit();
	#endif







	
	#if defined _casino_included
		if (casino_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)) return true;
	#endif
	#if defined _poker_included
		if (poker_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)) return true;
	#endif
	#if defined _blackjack_included
		if (blackjack_OnPlayerKStateChange(playerid, newkeys, oldkeys)) return true;
	#endif








	
	#if defined _poker_included
		if (poker_OnPlayerClickTextDraw(playerid, clickedid)) return true;
	#endif
	#if defined _blackjack_included
		if (blackjack_OnPlayerClickTextDraw(playerid, clickedid)) return true;
	#endif




	#if defined _poker_included
		if (poker_OnPlayerClickPTextDraw(playerid, playertextid)) return true;
	#endif



	
#include "../source/casino/casino.inc"
#include "../source/casino/poker.inc"
#include "../source/casino/blackjack.inc"


#include "../source/systems/gate_move.pwn"///





	#if defined _blackjack_included
		BJ_PlayerInfo[playerid] = NULL_BJ_PI;
	#endif












public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	#if defined _casino_included
		if (casino_OnPlayerLeaveDynamicArea(playerid, areaid)) return true;
	#endif






stock CreateTextDraws(playerid)////
	
	#if defined _casino_included
	CasinoRoulettePTD[playerid] = CreatePlayerTextDraw(playerid, 320.000000, 120.000000, " ");
	PlayerTextDrawLetterSize(playerid, CasinoRoulettePTD[playerid], 0.479583, 2.419258);
	PlayerTextDrawTextSize(playerid, CasinoRoulettePTD[playerid], 0.000000, 410.000000);
	PlayerTextDrawAlignment(playerid, CasinoRoulettePTD[playerid], 2);
	PlayerTextDrawColor(playerid, CasinoRoulettePTD[playerid], 336860415);
	PlayerTextDrawSetShadow(playerid, CasinoRoulettePTD[playerid], 0);
	PlayerTextDrawSetOutline(playerid, CasinoRoulettePTD[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, CasinoRoulettePTD[playerid], 255);
	PlayerTextDrawFont(playerid, CasinoRoulettePTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, CasinoRoulettePTD[playerid], 1);
	#endif