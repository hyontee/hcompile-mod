#if defined _duels_inc
	#endinput
#endif
#define _duels_inc

#define MAX_DUEL_LOBBY			(30)
#define DUEL_LOBBY_MATCH_TIMER	(60 * 2)

#define DUEL_MIN_BET			1000
#define DUEL_MAX_BET			10000

enum {
	DUEL_TYPE_1X1 = 0,
	DUEL_TYPE_2X2,
}
enum {
	DUEL_STATUS_NONE = 0,
	DUEL_STATUS_CREATING = 1,
	DUEL_STATUS_CREATED,
	DUEL_STATUS_STARTED,
}
static const Float:DuelSpawnPos[][4] = {
	{ 965.9265, 2062.6470, 1465.8262, 180.000 }, // [RED] 1
	{ 929.6735, 2056.3928, 1465.8262, 180.000 }, // [RED] 2
	{ 966.2499, 2015.2319, 1465.8262, 0.00000 },  // [BLUE] 1
	{ 932.6212, 2007.0414, 1465.8262, 0.00000 } // [BLUE] 2
};
static const Float:DuelSpawnPosRED[][4] = {
	{ 965.9265, 2062.6470, 1465.8262, 180.000 }, // [RED] 1
	{ 929.6735, 2056.3928, 1465.8262, 180.000 } // [RED] 2
};
static const Float:DuelSpawnPosBLUE[][4] = {
	{ 966.2499, 2015.2319, 1465.8262, 0.00000 },  // [BLUE] 1
	{ 932.6212, 2007.0414, 1465.8262, 0.00000 } // [BLUE] 2
};
enum DUEL_TEMP_e {
	duelCreateID,
	duelMatchID,
	duelTeam,
	duelSpawned,
}
static DuelTempInfo[MAX_PLAYERS][DUEL_TEMP_e];

enum {
	DUEL_TEAM_RED = 0,
	DUEL_TEAM_BLUE,
}
enum DUEL_LOBBY_e {
	duelOwnerID,
	duelPlayerID[4],
	duelPlayers[2],
	duelType,
	duelBet,
	duelWeapon,
	duelStatus,
	duelTimer,
	duelTimerID,
	duelActivePlayers,
	duelWaitStatus,
}
static 
	DuelLobbyInfo[MAX_DUEL_LOBBY][DUEL_LOBBY_e], 
	DUEL_LOBBY_NULL[DUEL_LOBBY_e], 
	DuelCreationArea, DuelInteriorArea[1],
	PlayerText:TimeDuelPTD[MAX_PLAYERS];

new DISABLED_TYPE_2x2 = 0;
CMD:disableduell2x2(playerid) {
	if (DISABLED_TYPE_2x2) DISABLED_TYPE_2x2 = 0;
	else DISABLED_TYPE_2x2 = 1;
	return true;
}
duels_TimerPlayer(playerid) {
	if (!DuelTempInfo[playerid][duelMatchID]) return;
	new id = DuelTempInfo[playerid][duelMatchID] - 1;
	if (DuelLobbyInfo[id][duelStatus] == DUEL_STATUS_CREATED) {
		format(t_string, sizeof (t_string), "~y~%d/%d PLAYERS",
			DuelLobbyInfo[id][duelPlayers][0] + DuelLobbyInfo[id][duelPlayers][1],
			DuelLobbyInfo[id][duelType] == DUEL_TYPE_1X1 ? 2:4
		);
		for (new i = 0, targetid; i < 4; i++) {
			targetid = DuelLobbyInfo[id][duelPlayerID][i];
			if (targetid == INVALID_PLAYER_ID) continue;
			GameTextForPlayer(targetid, t_string, 500, 6);
		}
		t_string[0] = EOS;
	}
}
duels_OnPlayerLeaveDynamicArea(playerid, areaid) {
	if (areaid == DuelCreationArea) {
		DestroyDuelCreatingLobby(playerid);
		return true;
	}
	else if (areaid == DuelInteriorArea[0]) {
		// LeavePlayerDuel(playerid, .spawn = 0);
		return true;
	} 
	return false;
}
duels_OnPlayerDeath(playerid) {
	// LeavePlayerDuel(playerid, .spawn = 0);
	#pragma unused playerid
	return false;
}
duels_OnPlayerSpawn(playerid) {
	DestroyDuelCreatingLobby(playerid);
	if (LeavePlayerDuel(playerid)) 
		return true;
	if (GetPVarInt(playerid, "OnDuelSpawn")) {
		pTemp[playerid][tVirtualWorld] = 1;
		pTemp[playerid][tInterior] = DUEL_HOLL_LOBBY;
		SetPlayerPosAC(playerid, 2040.9175,-1773.0742,1323.5272, 1, DUEL_HOLL_LOBBY);
		SetPlayerFacingAngle(playerid, 90);
		DeletePVar(playerid, "OnDuelSpawn");
		return true;
	}
	return false;
}
duels_OnPlayerConnect(playerid) {
	TimeDuelPTD[playerid] = CreatePlayerTextDraw(playerid, 80.000000, 305.759918, "00:00");
    PlayerTextDrawLetterSize(playerid, TimeDuelPTD[playerid], 0.270999, 1.123999);
    PlayerTextDrawAlignment(playerid, TimeDuelPTD[playerid], 1);
    PlayerTextDrawColor(playerid, TimeDuelPTD[playerid], -1);
    PlayerTextDrawSetShadow(playerid, TimeDuelPTD[playerid], 0);
    PlayerTextDrawSetOutline(playerid, TimeDuelPTD[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, TimeDuelPTD[playerid], 51);
    PlayerTextDrawFont(playerid, TimeDuelPTD[playerid], 1);
    PlayerTextDrawSetProportional(playerid, TimeDuelPTD[playerid], 1);

	static DUEL_TEMP_NULL[DUEL_TEMP_e];

	DuelTempInfo[playerid] = DUEL_TEMP_NULL; // обнуление
}
duels_OnPlayerDisconnect(playerid) {
	DestroyDuelCreatingLobby(playerid);
	LeavePlayerDuel(playerid);
	DeletePVar(playerid, "OnDuelSpawn");
}
duels_OnGameModeInit() {
	for (new i = 1; i < 4; i++) {
		DUEL_LOBBY_NULL[duelPlayerID][i] = INVALID_PLAYER_ID;
	}
	DUEL_LOBBY_NULL[duelOwnerID] = INVALID_PLAYER_ID;
	DUEL_LOBBY_NULL[duelTimerID] = -1;

	for (new id = 0; id < sizeof (DuelLobbyInfo); id++) {
		DuelLobbyInfo[id] = DUEL_LOBBY_NULL;
	}
	DuelCreationArea = CreateDynamicSphere(2035.1104, -1768.9307, 1323.5272, 25.0, .worldid = 1, .interiorid = DUEL_HOLL_LOBBY);//2449.2881, -1962.8241, 13.5469
	DuelInteriorArea[0] = CreateDynamicSphere(965.9265, 2062.6470, 1465.8262, 150.0, .worldid = -1, .interiorid = 1);
}
duels_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) {
	switch (dialogid) {
		case D_DUEL_LIST: {
			if (!response) {
				return true;
			}
			switch (listitem) {
				case 0: {
					if (DuelTempInfo[playerid][duelCreateID]) {
						SendClientMessage(playerid, COLOR_GREY, !"У вас уже создано лобби!");
						ShowDuelLobbies(playerid);
						return true;
					}
					ShowPlayerDialog(playerid, D_DUEL_CREATE_TYPE, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор типа", ""colwhi"\
						[0] 1x1\n\
						[1] 2x2",
						"Далее", "Удалить"
					);
				}
				default: {
					new id = playerListItem[playerid][listitem];
					if (DuelLobbyInfo[id][duelOwnerID] == playerid) {
						ShowPlayerDialog(playerid, D_DUEL_EDIT, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Редактирование", ""colwhi"\
							[0] Редактировать\n\
							[1] Удалить лобби",
							"Выбрать", "Назад"
						);
					} else {
						if (DuelLobbyInfo[id][duelStatus] != DUEL_STATUS_CREATED) {
							ShowDuelLobbies(playerid);
							return true;
						}
						new gunname[32];
						GetWeaponName(DuelLobbyInfo[id][duelWeapon], gunname, sizeof (gunname));
						format(t_string, sizeof (t_string), ""colwhi"\
							Вы собираетесь вступить в лобби:\n\
							\t- Имя создателя: "colserver"%s\n\
							\t"colwhi"- Ставка: "collime"$%i\n\
							\t"colwhi"- Тип оружия: "colserver"%s\n\
							\t"colwhi"- Тип дуэли: "colserver"%s\n\n\
							"colwhi"Вступить в дуэль?",
							pInfo[DuelLobbyInfo[id][duelOwnerID]][pName],
							DuelLobbyInfo[id][duelBet],
							gunname,
							DuelLobbyInfo[id][duelType] == DUEL_TYPE_1X1 ? "1x1":"2x2"
						);
						ShowPlayerDialog(playerid, D_DUEL_SELECT, DIALOG_STYLE_MSGBOX, ""colserver"Выбор дуэли", t_string, "Да", "Назад");
					
						playerListItem[playerid][0] = id;
					}
					t_string[0] = EOS;
				}
			}
			return true;
		}
		case D_DUEL_SELECT: {
			if (!response) {
				ShowDuelLobbies(playerid);
				return true;
			}
			new id = playerListItem[playerid][0];
			if (DuelLobbyInfo[id][duelStatus] != DUEL_STATUS_CREATED) {
				ShowDuelLobbies(playerid);
				return true;
			}
			if (DuelTempInfo[playerid][duelMatchID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Вы уже состоите в одном из лобби!");
				ShowDuelLobbies(playerid);
				return true;
			}
			if (kLibGetPlayerMoney(playerid) < DuelLobbyInfo[id][duelBet]) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств для ставки!");
				ShowDuelLobbies(playerid);
				return true;
			}
			switch (DuelLobbyInfo[id][duelType]) {
				case DUEL_TYPE_2X2: {
					format(t_string, sizeof (t_string), ""colwhi"\
						[0] Команда красных [%i/2 игроков]\n\
						[1] Команда синих [%i/2 игроков]",
						DuelLobbyInfo[id][duelPlayers][0],
						DuelLobbyInfo[id][duelPlayers][1]
					);
					ShowPlayerDialog(playerid, D_DUEL_SELECT_TEAM, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор команды", t_string, "Выбрать", "Назад");
					t_string[0] = EOS;
				}
				default: {
					DuelTempInfo[playerid][duelMatchID] = id + 1;
					DuelTempInfo[playerid][duelTeam] = DUEL_TEAM_BLUE;
					DuelLobbyInfo[id][duelPlayerID][1] = playerid;
					DuelLobbyInfo[id][duelPlayers][1] = 1;
					StartDuelLobby(id);
				}
			}
			return true;
		}
		case D_DUEL_SELECT_TEAM: {
			if (!response) {
				return true;
			}
			new id = playerListItem[playerid][0];
			if (DuelLobbyInfo[id][duelStatus] != DUEL_STATUS_CREATED) {
				ShowDuelLobbies(playerid);
				return true;
			}
			if (DuelTempInfo[playerid][duelMatchID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Вы уже состоите в одном из лобби!");
				ShowDuelLobbies(playerid);
				return true;
			}
			if (kLibGetPlayerMoney(playerid) < DuelLobbyInfo[id][duelBet]) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств для ставки!");
				ShowDuelLobbies(playerid);
				return true;
			}
			new team = DUEL_TEAM_RED;
			switch (listitem) {
				case 0: team = DUEL_TEAM_RED;
				default: team = DUEL_TEAM_BLUE;
			}
			if (DuelLobbyInfo[id][duelPlayers][listitem] >= 2) {
				format(t_string, sizeof (t_string), ""colwhi"\
					[0] Команда красных [%i / 2 игроков]\n\
					[1] Команда синих [%i / 2 игроков]",
					DuelLobbyInfo[id][duelPlayers][0],
					DuelLobbyInfo[id][duelPlayers][1]
				);
				ShowPlayerDialog(playerid, D_DUEL_SELECT_TEAM, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор команды", t_string, "Выбрать", "Назад");
				t_string[0] = EOS;
				return true;
			}
			//printf("playerid = %i | listitem = %i | team == %i",playerid,listitem, team);
			DuelTempInfo[playerid][duelTeam] = team;
			DuelTempInfo[playerid][duelMatchID] = id + 1;
			DuelLobbyInfo[id][duelPlayers][listitem]++;

			for (new i = 1; i < 4; i++) {
				if (DuelLobbyInfo[id][duelPlayerID][i] != INVALID_PLAYER_ID) continue;
				DuelLobbyInfo[id][duelPlayerID][i] = playerid;
				break;
			}
			if ((DuelLobbyInfo[id][duelPlayers][0] + DuelLobbyInfo[id][duelPlayers][1]) >= 4) {
				StartDuelLobby(id);
			} else {
				SendClientMessage(playerid, COLOR_BLUE, !"Вы вступили в лобби, дождитесь всех участников!");
			}
			return true;
		}
		case D_DUEL_EDIT: {
			if (!response) {
				ShowDuelLobbies(playerid);
				return true;
			}
			switch (listitem) {
				case 0:  {
					if (DuelTempInfo[playerid][duelMatchID]) {
						SendClientMessage(playerid, COLOR_GREY, !"Вы уже участвуете в лобби!");
						ShowDuelLobbies(playerid);ShowDuelLobbies(playerid);
						return true;
					}
					ShowPlayerDialog(playerid, D_DUEL_CREATE_TYPE, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор типа", ""colwhi"\
						[0] 1x1\n\
						[1] 2x2",
						"Далее", "Удалить"
					);
				}
				case 1: {
					DestroyDuelCreatingLobby(playerid);
					ShowDuelLobbies(playerid);
				}
			}
			return true;
		}
		case D_DUEL_CREATE_TYPE: {
			if (!response) {
				DestroyDuelCreatingLobby(playerid);
				ShowDuelLobbies(playerid);
				return true;
			}
			new type = listitem;
			if (DISABLED_TYPE_2x2) {
				type = DUEL_TYPE_1X1;
				SendClientMessage(playerid, COLOR_GREY, !"Тип 2х2 временно отключен, выбран 1х1");
			}

			if (DuelTempInfo[playerid][duelCreateID]) {
				if (!DuelTempInfo[playerid][duelCreateID]) {
					SendClientMessage(playerid, COLOR_GREY, !"Произошла ошибка, попробуйте еще раз!");
					return true;
				}
				DuelLobbyInfo[DuelTempInfo[playerid][duelCreateID] - 1][duelType] = type;
			} else {
				if (DuelTempInfo[playerid][duelMatchID]) {
					SendClientMessage(playerid, COLOR_GREY, !"Вы уже участвуете в лобби!");
					return true;
				}
				if (!CreateDuelLobby(playerid, type)) {
					SendClientMessage(playerid, COLOR_GREY, !"В данный момент невозможно создать лобби!");
					return true;
				}
			}
			ShowPlayerDialog(playerid, D_DUEL_CREATE_BET, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Ставка", ""colwhi"\
				Введите ставку дуэли:\n\
				Примечание: ставка от "#DUEL_MIN_BET" до "#DUEL_MAX_BET" $.", "Далее", "Назад"
			);
			return true;
		}
		case D_DUEL_CREATE_BET: {
			if (!response) {
				
				ShowPlayerDialog(playerid, D_DUEL_CREATE_TYPE, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор типа", ""colwhi"\
					[0] 1x1\n\
					[1] 2x2",
					"Далее", "Отмена"
				);
				return true;
			}
			if (!DuelTempInfo[playerid][duelCreateID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Произошла ошибка, попробуйте еще раз!");
				return true;
			}
			new id = DuelTempInfo[playerid][duelCreateID] - 1, bet = strval(inputtext);
			if (kLibGetPlayerMoney(playerid) < bet) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас недостаточно денег!");
				ShowPlayerDialog(playerid, D_DUEL_CREATE_BET, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Ставка", ""colwhi"\
					Введите ставку дуэли:\n\
					Примечание: ставка от "#DUEL_MIN_BET" до "#DUEL_MAX_BET" $.", "Далее", "Назад"
				);
				return true;
			}
			if (!(DUEL_MIN_BET <= bet <= DUEL_MAX_BET)) {
				ShowPlayerDialog(playerid, D_DUEL_CREATE_BET, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Ставка", ""colwhi"\
					Введите ставку дуэли:\n\
					Примечание: ставка от "#DUEL_MIN_BET" до "#DUEL_MAX_BET" $.", "Далее", "Назад"
				);
				return true;
			}
			DuelLobbyInfo[id][duelBet] = bet;
			//ShowPlayerDialog(playerid, D_DUEL_CREATE_PASSWORD, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Пароль"
			ShowPlayerDialog(playerid, D_DUEL_CREATE_WEAPON, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор оружия", ""colwhi"\
				[0] Desert Eagle\n\
				[1] Shotgun\n\
				[2] MP5\n\
				[3] M4\n\
				[4] AK-47\n\
				[5] Rifle",
				"Далее", "Назад"
			);
			return true;
		}
		/*case D_DUEL_CREATE_PASSWORD: {
			if (!response) {
				ShowPlayerDialog(playerid, D_DUEL_CREATE_BET, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Ставка", ""colwhi"\
					Введите ставку дуэли:\n\
					Примечание: ставка от "#DUEL_MIN_BET" до "#DUEL_MAX_BET" $.", "Далее", "Назад"
				);
				return true;
			}
			if (!DuelTempInfo[playerid][duelCreateID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Произошла ошибка, попробуйте еще раз!");
				return true;
			}
		}*/
		case D_DUEL_CREATE_WEAPON: {
			if (!response) {
				ShowPlayerDialog(playerid, D_DUEL_CREATE_BET, DIALOG_STYLE_INPUT, ""colserver"Дуэль: "colwhi"Ставка", ""colwhi"\
					Введите ставку дуэли:\n\
					Примечание: ставка от "#DUEL_MIN_BET" до "#DUEL_MAX_BET" $.", "Далее", "Назад"
				);
				return true;
			}
			if (!DuelTempInfo[playerid][duelCreateID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Произошла ошибка, попробуйте еще раз!");
				return true;
			}
			new id = DuelTempInfo[playerid][duelCreateID] - 1, gunname[32];
			static const DuelLobbyWeapons[] = { 24, 25, 29, 31, 30, 33 };
			DuelLobbyInfo[id][duelWeapon] = DuelLobbyWeapons[listitem];

		    GetWeaponName(DuelLobbyInfo[id][duelWeapon], gunname, sizeof (gunname));
	
			format(t_string, sizeof (t_string), ""colwhi"\
				Вы собираетесь создать дуэль:\n\
				\t- Имя создателя: "colserver"%s\n\
				\t"colwhi"- Ставка: "collime"$%i\n\
				\t"colwhi"- Тип оружия: "colserver"%s\n\
				\t"colwhi"- Тип дуэли: "colserver"%s\n\n\
				"colwhi"Создать дуэль?",
				pInfo[DuelLobbyInfo[id][duelOwnerID]][pName],
				DuelLobbyInfo[id][duelBet],
				gunname,
				DuelLobbyInfo[id][duelType] == DUEL_TYPE_1X1 ? "1x1":"2x2"
			);
			ShowPlayerDialog(playerid, D_DUEL_CREATE_CONFIRM, DIALOG_STYLE_MSGBOX, ""colserver"Дуэль: "colwhi"Создание", t_string, "Да", "Назад");

			t_string[0] = EOS;
			return true;
		}
		case D_DUEL_CREATE_CONFIRM: {
			if (!response) {
				ShowPlayerDialog(playerid, D_DUEL_CREATE_WEAPON, DIALOG_STYLE_LIST, ""colserver"Дуэль: "colwhi"Выбор оружия", ""colwhi"\
					[0] Desert Eagle\n\
					[1] Shotgun\n\
					[2] MP5\n\
					[3] M4\n\
					[4] AK-47\n\
					[5] Rifle",
					"Далее", "Назад"
				);
				return true;
			}
			if (!DuelTempInfo[playerid][duelCreateID]) {
				SendClientMessage(playerid, COLOR_GREY, !"Произошла ошибка, попробуйте еще раз!");
				return true;
			}
			new id = DuelTempInfo[playerid][duelCreateID] - 1;
			if (kLibGetPlayerMoney(playerid) < DuelLobbyInfo[id][duelBet]) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств для ставки!");
				DestroyDuelCreatingLobby(playerid,1);
				return true;
			}
			DuelLobbyInfo[id][duelStatus] = DUEL_STATUS_CREATED;

			SendClientMessage(playerid, COLOR_WHITE, !"Вы успешно создали / изменили лобби!");
			return true;
		}
	}
	return false;
}
stock CreateDuelLobby(playerid, type = DUEL_TYPE_1X1) {
	new id = -1;
	for (new free_id = 0; free_id < sizeof (DuelLobbyInfo); free_id++) {
		if (DuelLobbyInfo[free_id][duelOwnerID] != INVALID_PLAYER_ID) continue;
		id = free_id;
		break;
	}
	if (id == -1) return false;

	DuelTempInfo[playerid][duelTeam] = DUEL_TEAM_RED;
	DuelTempInfo[playerid][duelCreateID] = id + 1;
	DuelTempInfo[playerid][duelMatchID] = id + 1;

	DuelLobbyInfo[id] = DUEL_LOBBY_NULL;
	DuelLobbyInfo[id][duelOwnerID] = playerid;
	DuelLobbyInfo[id][duelPlayerID][0] = playerid;
	DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_RED] = 1;
	DuelLobbyInfo[id][duelStatus] = DUEL_STATUS_CREATING;
	DuelLobbyInfo[id][duelType] = type;

	return true;
}
stock ShowDuelLobbies(playerid) {
    t_string = ""colserver"Создатель\t"colserver"Тип\t"colserver"Статус\n\
                "colwhi"- Создать новое соревнование\n";

    for (new id = 0, idx = 1, gunname[32]; id < sizeof (DuelLobbyInfo); id++) {
        if (DuelLobbyInfo[id][duelOwnerID] == INVALID_PLAYER_ID) continue;
        switch (DuelLobbyInfo[id][duelStatus]) {
            case DUEL_STATUS_CREATED: {
                GetWeaponName(DuelLobbyInfo[id][duelWeapon], gunname, sizeof (gunname));
                format(t_string, sizeof (t_string), "%s\
                    [%i] %s\t[%s - $%i]\t[%i/%i]\n", t_string,
                    idx, pInfo[DuelLobbyInfo[id][duelOwnerID]][pName], 
                    gunname, DuelLobbyInfo[id][duelBet],
                    (DuelLobbyInfo[id][duelPlayers][0] + DuelLobbyInfo[id][duelPlayers][1]),
                    DuelLobbyInfo[id][duelType] == DUEL_TYPE_1X1 ? 2:4
                );
            }
            case DUEL_STATUS_CREATING: {
                format(t_string, sizeof (t_string), "%s\
                    [%i] %s\t[ - ]\t[создается]\n", t_string,
                    idx, pInfo[DuelLobbyInfo[id][duelOwnerID]][pName]
                );
            }
            case DUEL_STATUS_STARTED: {
                GetWeaponName(DuelLobbyInfo[id][duelWeapon], gunname, sizeof (gunname));
                format(t_string, sizeof (t_string), "%s\
                    [%i] %s\t[%s - $%i]\t[началось]\n", t_string,
                    idx, pInfo[DuelLobbyInfo[id][duelOwnerID]][pName], 
                    gunname, DuelLobbyInfo[id][duelBet]
                );
            }
        }
        playerListItem[playerid][idx++] = id;
    }
    ShowPlayerDialog(playerid, D_DUEL_LIST, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Дуэли", t_string, "Выбрать", "Отмена");

    t_string[0] = EOS;
    return true;
}
stock DestroyDuelCreatingLobby(playerid, message = 1) {
	if (!DuelTempInfo[playerid][duelCreateID]) return false;
	new id = DuelTempInfo[playerid][duelCreateID] - 1;

	if (DuelLobbyInfo[id][duelStatus] != DUEL_STATUS_STARTED) {
		DuelLobbyInfo[id] = DUEL_LOBBY_NULL;
		DuelTempInfo[playerid][duelMatchID] = 0;
		for (new i = 0, targetid; i < 4; i++) {
			targetid = DuelLobbyInfo[id][duelPlayerID][i];
			if (targetid == INVALID_PLAYER_ID) continue;
			if (DuelTempInfo[targetid][duelMatchID] == id + 1) {
				DuelTempInfo[targetid][duelMatchID] = 0;
			}
		}
	} else {
		message = 0;
	}
	DuelTempInfo[playerid][duelCreateID] = 0;

	if (message) SendClientMessage(playerid, COLOR_WHITE, !"Ваше лобби в дуэлях было удалено!");
	return true;
}
forward duels_TimerLobby(id);
public duels_TimerLobby(id) {
	DuelLobbyInfo[id][duelTimerID] = -1;
	if (DuelLobbyInfo[id][duelTimer]) {
		DuelLobbyInfo[id][duelTimer]--;

		if (DuelLobbyInfo[id][duelTimer] == 0) {
			StopDuelLobby(id);
			return;
		}
		else if (DuelLobbyInfo[id][duelTimer] > DUEL_LOBBY_MATCH_TIMER) {
			new timer = DuelLobbyInfo[id][duelTimer] - DUEL_LOBBY_MATCH_TIMER;
			format(t_string, sizeof (t_string), "~r~%02d:%02d", timer / 60, timer);
			
			for (new i = 0, playerid; i < 4; i++) {
				playerid = DuelLobbyInfo[id][duelPlayerID][i];
				if (playerid == INVALID_PLAYER_ID) continue;
				GameTextForPlayer(playerid, t_string, 500, 6);
			}
			t_string[0] = EOS;
		}
		else if (DuelLobbyInfo[id][duelTimer] == DUEL_LOBBY_MATCH_TIMER) {
			for (new i = 0, playerid; i < 4; i++) {
				playerid = DuelLobbyInfo[id][duelPlayerID][i];
				if (playerid == INVALID_PLAYER_ID) continue;
				GameTextForPlayer(playerid, "~g~GOOD LUCK!", 1000, 6);
				TogglePlayerControllable(playerid, true);
			}
		}
		else {
			format(t_string, sizeof (t_string), "%s", Convert(DuelLobbyInfo[id][duelTimer]));
			for (new i = 0, playerid; i < 4; i++) {
				playerid = DuelLobbyInfo[id][duelPlayerID][i];
				if (playerid == INVALID_PLAYER_ID) continue;
				PlayerTextDrawSetString(playerid, TimeDuelPTD[playerid], t_string);
			}
			t_string[0] = EOS;
		}
		DuelLobbyInfo[id][duelTimerID] = SetTimerEx("duels_TimerLobby", 1000, false, "i", id);
	}
}
stock StartDuelLobby(id) {
	DuelLobbyInfo[id][duelStatus] = DUEL_STATUS_STARTED; 
	new spawnid[2] = {0,0};
	for (new i = 0, playerid, position, team; i < 4; i++) {
		playerid = DuelLobbyInfo[id][duelPlayerID][i];
		if (playerid == INVALID_PLAYER_ID) continue;
		team = DuelTempInfo[playerid][duelTeam];
		//printf("team = %d, playerid = %d, i = %i", team, playerid, i);
		
		switch (DuelLobbyInfo[id][duelType]) {
			case DUEL_TYPE_1X1: {
				position = (i == 0) ? 0:2;
				SetPlayerPosAC(playerid, DuelSpawnPos[position][0], DuelSpawnPos[position][1], DuelSpawnPos[position][2], id*2, 1);
				SetPlayerFacingAngle(playerid, DuelSpawnPos[position][3]);
			}
			case DUEL_TYPE_2X2: {
				new spawn_id = spawnid[team]++;
				//printf("spawn_id[%i] = %i", team, spawn_id);
				switch (team) {
					case DUEL_TEAM_BLUE: {
						SetPlayerPosAC(playerid, 
							DuelSpawnPosBLUE[spawn_id][0], DuelSpawnPosBLUE[spawn_id][1], DuelSpawnPosBLUE[spawn_id][2], id*2, 1
						);
						SetPlayerFacingAngle(playerid, DuelSpawnPosBLUE[spawn_id][3]);
						
					}
					default: {
						SetPlayerPosAC(playerid, 
							DuelSpawnPosRED[spawn_id][0], DuelSpawnPosRED[spawn_id][1], DuelSpawnPosRED[spawn_id][2], id*2, 1
						);
						SetPlayerFacingAngle(playerid, DuelSpawnPosRED[spawn_id][3]);
					}
				}
			}
		}
		kLibGivePlayerMoney(playerid, -DuelLobbyInfo[id][duelBet], "ставка дуэль");
		SetPlayerColor(playerid, DuelTempInfo[playerid][duelTeam] == DUEL_TEAM_RED ? COLOR_RED:COLOR_BLUE);
		TogglePlayerControllable(playerid, false);
		SetCameraBehindPlayer(playerid);
		SetPlayerHealth(playerid, 100.0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid, DuelLobbyInfo[id][duelWeapon], 400);
		SendClientMessage(playerid, COLOR_WHITE, !"Дуэль начинается, у Вас есть две минуты, чтобы победить!");

		DuelTempInfo[playerid][duelSpawned] = 1;

		for (new td_id = 0; td_id < sizeof (TimeDuel); td_id++) {
			if (td_id != 10) TextDrawShowForPlayer(playerid, TimeDuel[td_id]);
		}
		format(t_string, sizeof (t_string), "%s", Convert(DUEL_LOBBY_MATCH_TIMER));
		PlayerTextDrawSetString(playerid, TimeDuelPTD[playerid], t_string), t_string[0] = EOS;
		PlayerTextDrawShow(playerid, TimeDuelPTD[playerid]);
	}
	DuelLobbyInfo[id][duelTimer] = DUEL_LOBBY_MATCH_TIMER + 4;
	DuelLobbyInfo[id][duelTimerID] = SetTimerEx("duels_TimerLobby", 1000, false, "i", id);
}
stock StopDuelLobby(id, win_team = -1) {
	for (new i = 0, playerid; i < 4; i++) {
		playerid = DuelLobbyInfo[id][duelPlayerID][i];
		if (playerid == INVALID_PLAYER_ID) continue;
		
		if (DuelTempInfo[playerid][duelSpawned]) {
			SetPlayerHealth(playerid, 100.0);
			pTemp[playerid][tVirtualWorld] = 1;
			pTemp[playerid][tInterior] = DUEL_HOLL_LOBBY;
			SetPlayerPosAC(playerid, 2040.9175,-1773.0742,1323.5272, 1, DUEL_HOLL_LOBBY);
			SetPlayerFacingAngle(playerid, 90);
			SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
			SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
			ResetPlayerWeapons(playerid);
			TogglePlayerControllable(playerid, true);
			DuelTempInfo[playerid][duelSpawned] = 0;
		}
		if (win_team == -1) {
			SendClientMessage(playerid, COLOR_WHITE, !"Дуэль закончилась в ничью!");
		} else {
			switch (win_team) {
				case DUEL_TEAM_RED: SendClientMessage(playerid, COLOR_WHITE, !"Дуэль закончилась, победила команда красных!");
				case DUEL_TEAM_BLUE: SendClientMessage(playerid, COLOR_WHITE, !"Дуэль закончилась, победила команда синих!");
			}
			if (DuelTempInfo[playerid][duelTeam] == win_team) {
				kLibGivePlayerMoney(playerid, DuelLobbyInfo[id][duelBet]*2, "победа в дуэли");
				GiveFractionPoints(pInfo[playerid][pMember], 1);
				SendMes(playerid, COLOR_WHITE, "Вы выиграли $%i за победу. + 1 G-Point", DuelLobbyInfo[id][duelBet]);
				OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_DUEL_5);
				OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_GPOINT_100);
				OnPlayerAchievProgress(playerid, 20);
				OnPlayerAchievProgress(playerid, 30);
			} else {
				// kLibGivePlayerMoney(playerid, -DuelLobbyInfo[id][duelBet], "дуэль");
				SendMes(playerid, COLOR_WHITE, "Вы проиграли $%i за проигрыш.", DuelLobbyInfo[id][duelBet]);
			}
		}
		DuelTempInfo[playerid][duelMatchID] = 0;
		if (DuelLobbyInfo[id][duelOwnerID] != playerid) {
			DestroyDuelCreatingLobby(playerid, .message = 0);
		}
		for (new td_id = 0; td_id < sizeof (TimeDuel); td_id++) {
			if (td_id != 10) TextDrawHideForPlayer(playerid, TimeDuel[td_id]);
		}
		PlayerTextDrawHide(playerid, TimeDuelPTD[playerid]);
	}
	if (DuelLobbyInfo[id][duelTimerID] != -1) {
		KillTimer(DuelLobbyInfo[id][duelTimerID]);
		DuelLobbyInfo[id][duelTimerID] = -1;
	}
	if (DuelLobbyInfo[id][duelOwnerID] != INVALID_PLAYER_ID) {
		new playerid = DuelLobbyInfo[id][duelOwnerID];
		DestroyDuelCreatingLobby(playerid, .message = 0);
	}
	DuelLobbyInfo[id] = DUEL_LOBBY_NULL;
}
stock LeavePlayerDuel(playerid, spawn = 1) {
	if (DuelTempInfo[playerid][duelMatchID] && DuelTempInfo[playerid][duelSpawned]) {
		new id = DuelTempInfo[playerid][duelMatchID] - 1;
		SetPlayerHealth(playerid, 100.0);
		if (spawn) { 
			pTemp[playerid][tVirtualWorld] = 1;
			pTemp[playerid][tInterior] = DUEL_HOLL_LOBBY;
			SetPlayerPosAC(playerid, 2040.9175,-1773.0742,1323.5272, 1, DUEL_HOLL_LOBBY);
			SetPlayerFacingAngle(playerid, 90);

			SetPVarInt(playerid, "OnDuelSpawn", 0);
		} else {
			SetPVarInt(playerid, "OnDuelSpawn", 1);
		}
		SetPlayerSkinEx(playerid, pInfo[playerid][pModel]); 
		ResetPlayerWeapons(playerid);
		TogglePlayerControllable(playerid, true);
		for (new td_id = 0; td_id < sizeof (TimeDuel); td_id++) {
			if (td_id != 10) TextDrawHideForPlayer(playerid, TimeDuel[td_id]);
		}
		PlayerTextDrawHide(playerid, TimeDuelPTD[playerid]);
		DuelTempInfo[playerid][duelSpawned] = 0;

		DuelLobbyInfo[id][duelPlayers][DuelTempInfo[playerid][duelTeam]]--;
		if (DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_RED] == 0 || DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_BLUE] == 0) {
			new win_team = -1;
			if (DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_RED] > DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_BLUE]) win_team = DUEL_TEAM_RED;
			else if (DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_RED] < DuelLobbyInfo[id][duelPlayers][DUEL_TEAM_BLUE]) win_team = DUEL_TEAM_BLUE;
			StopDuelLobby(id, win_team);
		} else {
			SendMes(playerid, COLOR_BLUE, "Дождитесь окончания матча дуэли, осталось: %s.", Convert(DuelLobbyInfo[id][duelTimer]));
		}
		return true;
	}
	return false;
}
stock IsPlayerInDuel(playerid) {
	if (DuelTempInfo[playerid][duelMatchID] && DuelTempInfo[playerid][duelSpawned]) {
		return true;
	}
	return false;
}
stock IsPlayerCreateDuel(playerid) {
	if (DuelTempInfo[playerid][duelMatchID]) {
		return true;
	}
	return false;
}