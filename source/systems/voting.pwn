#if defined _voting_inc
	#endinput
#endif
#define _voting_inc

#define MAX_VOTING_CANDIDATES	(5)
#define TABLE_VOTING			"s_voting"
/*
OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]):
	#if defined _voting_inc
		if (voting_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return true;
	#endif

OnGameModeInit():
	#if defined _voting_inc
		voting_OnGameModeInit();
	#endif 

OnPlayerClickPlayerTextDraw(playerid, playertextid):
	#if defined _voting_inc
		if (voting_OnPlayerClickPlayerTD(playerid, playertextid)) return true;
	#endif

OnPlayerClickTextDraw(playerid, clickedid):
	#if defined _voting_inc
		if (voting_OnPlayerClickTextDraw(playerid, clickedid)) return true;
	#endif

OnPlayerDisconnect(playerid):
	#if defined _voting_inc
		voting_OnPlayerDisconnect(playerid);
	#endif

OnPlayerSpawn(playerid):
	#if defined _voting_inc
		voting_OnPlayerSpawn(playerid);
	#endif

Fresh():
	#if defined _voting_inc
		OnVotingTimer();
	#endif

*/
#define GetVotingSizeY(%0) \
	(144.352005 + (((292.829833 - 144.352005) / 100) * (100 - %0)))

enum E_VOTING {
	votingTime,
	votingLastTime,
	votingPoints[MAX_VOTING_CANDIDATES],
}
static 
	VotingInfo[E_VOTING], VotingCandidatesName[MAX_VOTING_CANDIDATES][MAX_PLAYER_NAME + 1],
	PlayerText:VotingPTD[MAX_PLAYERS][10], Text:VotingTD[24], VotingTempID[MAX_PLAYERS],
	bool:VotingPanelShowed[MAX_PLAYERS], VotingTempCandidateNames[MAX_PLAYERS][MAX_PLAYER_NAME + 1];

enum {
	D_VOTING_PANEL = 23000,
	D_VOTING_EDIT_CANDIDATE,
}
stock OnPlayerLoginVoting(playerid)
{
	if (VotingInfo[votingTime] && pInfo[playerid][pVotingID] != 1) {
		SendClientMessage(playerid, 0x2641EDFF, !"Уважаемые игроки, в штате проходят выборы Мэра");
		SendClientMessage(playerid, 0x2641EDFF, !"Вы можете проголосовать в избирательном участке Мэрии.");
		SendClientMessage(playerid, 0x2641EDFF, !"Вы можете отдать свой голос за понравившего кандидата.");
		SendClientMessage(playerid, 0x2641EDFF, !"Для того чтобы отдать свой голос вы должны проживать в штате минимум 3 года.");
	}
}
stock ShowVotingEditMenu(playerid, dialogid) {
	switch (dialogid) {
		case D_VOTING_PANEL: {
			t_string[0] = EOS;
			for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
				format(t_string, sizeof (t_string), "%s{FFFFFF}\
					[%i] Кандидат %i {999999}[%s]{FFFFFF}\n", t_string, i, i + 1, VotingTempCandidateNames[i]
				);
			}
			if (!VotingInfo[votingTime]) strcat(t_string, "[>>] {6B8E23}Начать выборы");
			else strcat(t_string, "[>>] {800000}Остановить выборы досрочно");

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Управление выборами", t_string, "Выбрать", "Отмена");
		}
		case D_VOTING_EDIT_CANDIDATE: {
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Изменение кандидата", "{FFFFFF}\
				Введите никнейм нового кандидата:", "Принять", "Назад"
			);
		}
	}
	t_string[0] = EOS;
	return true;
}
voting_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
	switch (dialogid) {
		case D_VOTING_PANEL: {
			if (!response) {
				return true;
			}
			switch (listitem + 1) {
				case 1 .. MAX_VOTING_CANDIDATES: {
					if (!VotingInfo[votingTime]) {
						VotingTempID[playerid] = listitem;
						ShowVotingEditMenu(playerid, D_VOTING_EDIT_CANDIDATE);
					} else {
						ShowVotingEditMenu(playerid, D_VOTING_PANEL);
					}
				}
				case MAX_VOTING_CANDIDATES + 1: {
					if (!VotingInfo[votingTime]) {
						StartVoting(pInfo[playerid][pName],
							VotingTempCandidateNames[0], VotingTempCandidateNames[1],
							VotingTempCandidateNames[2], VotingTempCandidateNames[3],
							VotingTempCandidateNames[4]
						);
						format(t_string, sizeof t_string, "[A] %s[%d] начал выборы штата.",  
							pInfo[playerid][pName], playerid
						);
					} else {
						StopVoting();
						format(t_string, sizeof t_string, "[A] %s[%d] завершил выборы штата досрочно.",  
							pInfo[playerid][pName], playerid
						);
					}
					SendAdminMessage(COLOR_GREY, t_string), t_string[0] = EOS;
				}
			}
			return true;
		}
		case D_VOTING_EDIT_CANDIDATE: {
			if (!response) {
				ShowVotingEditMenu(playerid, D_VOTING_PANEL);
				return true;
			}
			new voting_id = VotingTempID[playerid];
			if (!(4 <= strlen(inputtext) <= MAX_PLAYER_NAME) || strfind(inputtext, "~") != -1) {
				ShowVotingEditMenu(playerid, D_VOTING_EDIT_CANDIDATE);
				return true;
			} 
			format(VotingTempCandidateNames[voting_id], MAX_PLAYER_NAME + 1, inputtext);
			SendClientMessage(playerid, -1, !"Вы изменили никнейм кандидата.");
			ShowVotingEditMenu(playerid, D_VOTING_PANEL);
			return true;
		}
	}
	return false;
}
voting_OnPlayerSpawn(playerid) {
	HideVotingTD(playerid);
}
voting_OnPlayerDisconnect(playerid) {
	HideVotingTD(playerid);
}
voting_OnGameModeInit() {
	LoadVotingData();
	CreateVotingTD();
}
voting_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid) {
	if (!VotingPanelShowed[playerid]) 
		return false;
	new bool:isReturn = false;
	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
		if (playertextid != VotingPTD[playerid][i]) continue;
		ChosePlayerVoting(playerid, i);
		isReturn = true;
		break;
	}
	if (isReturn) return true;
	return false;
}
voting_OnPlayerClickTextDraw(playerid, Text:clickedid) { 
	if (!VotingPanelShowed[playerid]) 
		return false;
	if (clickedid == Text:INVALID_TEXT_DRAW) {
		HideVotingTD(playerid);
		return true;
	}
	return false;
}
stock CreateVotingTD() {
	VotingTD[0] = TextDrawCreate(450.100006, 120.918647, "LD_BEAT:chit");
	VotingTD[1] = TextDrawCreate(166.000000, 120.918647, "LD_BEAT:chit");
	VotingTD[2] = TextDrawCreate(450.100006, 330.881622, "LD_BEAT:chit");
	VotingTD[3] = TextDrawCreate(166.000000, 330.881622, "LD_BEAT:chit");

	VotingTD[4] = TextDrawCreate(170.000000, 134.296203, "LD_SPAC:white");
	TextDrawTextSize(VotingTD[4], 300.000000, 208.000000);
	TextDrawColor(VotingTD[4], COLOR_SERVER);
	VotingTD[5] = TextDrawCreate(170.000000, 138.196441, "LD_SPAC:white");
	TextDrawTextSize(VotingTD[5], 300.000000, 200.000000);
	TextDrawColor(VotingTD[5], 421075306);
	VotingTD[6] = TextDrawCreate(177.166717, 124.762962, "LD_SPAC:white");
	TextDrawTextSize(VotingTD[6], 286.000000, 12.000000);
	TextDrawColor(VotingTD[6], COLOR_SERVER);
	VotingTD[7] = TextDrawCreate(177.166717, 338.911071, "LD_SPAC:white");
	TextDrawTextSize(VotingTD[7], 286.000000, 12.000000);
	TextDrawColor(VotingTD[7], COLOR_SERVER);

	VotingTD[8] = TextDrawCreate(171.666641, 133.940719, "particle:lamp_shad_64");
	TextDrawTextSize(VotingTD[8], 294.000000, 170.000000);
	TextDrawAlignment(VotingTD[8], 1);
	TextDrawColor(VotingTD[8], -241);
	TextDrawSetShadow(VotingTD[8], 0);
	TextDrawBackgroundColor(VotingTD[8], 255);
	TextDrawFont(VotingTD[8], 4);
	TextDrawSetProportional(VotingTD[8], 0);

	VotingTD[9] = TextDrawCreate(320.000000, 126.740699, "VOTING");
	TextDrawLetterSize(VotingTD[9], 0.167500, 0.998519);
	TextDrawAlignment(VotingTD[9], 2);
	TextDrawColor(VotingTD[9], 255);
	TextDrawSetShadow(VotingTD[9], 0);
	TextDrawBackgroundColor(VotingTD[9], 255);
	TextDrawFont(VotingTD[9], 2);
	TextDrawSetProportional(VotingTD[9], 1);

	VotingTD[10] = TextDrawCreate(190.699981, 303.500000, "LD_SPAC:white");
	TextDrawColor(VotingTD[10], -2147483448);
	VotingTD[11] = TextDrawCreate(222.298309, 303.500000, "LD_SPAC:white");
	TextDrawColor(VotingTD[11], -5963576);
	VotingTD[12] = TextDrawCreate(254.200256, 303.500000, "LD_SPAC:white");
	TextDrawColor(VotingTD[12], 1879113672);
	VotingTD[13] = TextDrawCreate(285.600341, 303.500000, "LD_SPAC:white");
	TextDrawColor(VotingTD[13], -2139094840);
	VotingTD[14] = TextDrawCreate(317.599853, 303.500000, "LD_SPAC:white");
	TextDrawColor(VotingTD[14], 8388808);

	VotingTD[15] = TextDrawCreate(350.000000, 157.748443, "_");
	TextDrawColor(VotingTD[15], -1523963170);
	VotingTD[16] = TextDrawCreate(350.000000, 186.716613, "_");
	TextDrawColor(VotingTD[16], -609943330);
	VotingTD[17] = TextDrawCreate(350.000000, 215.277160, "_");
	TextDrawColor(VotingTD[17], 1593901022);
	VotingTD[18] = TextDrawCreate(350.000000, 242.293060, "_");
	TextDrawColor(VotingTD[18], -2139094818);
	VotingTD[19] = TextDrawCreate(350.000000, 270.083953, "_");
	TextDrawColor(VotingTD[19], 8388830);

	VotingTD[20] = TextDrawCreate(433.233032, 313.407531, "_");
	TextDrawLetterSize(VotingTD[20], 0.268750, 1.231852);
	TextDrawTextSize(VotingTD[20], 467.000000, 0.000000);
	TextDrawAlignment(VotingTD[20], 3);
	TextDrawColor(VotingTD[20], -1061109505);
	TextDrawSetShadow(VotingTD[20], 0);
	TextDrawBackgroundColor(VotingTD[20], 255);
	TextDrawFont(VotingTD[20], 2);
	TextDrawSetProportional(VotingTD[20], 1);

	VotingTD[21] = TextDrawCreate(167.500030, 337.901855, "particle:lamp_shad_64");
	TextDrawTextSize(VotingTD[21], 308.000000, -35.000000);
	TextDrawAlignment(VotingTD[21], 1);
	TextDrawColor(VotingTD[21], -224);
	TextDrawSetShadow(VotingTD[21], 0);
	TextDrawBackgroundColor(VotingTD[21], 255);
	TextDrawFont(VotingTD[21], 4);
	TextDrawSetProportional(VotingTD[21], 0);

	VotingTD[22] = TextDrawCreate(359.166687, 310.555633, "LD_SPAC:white");
	TextDrawTextSize(VotingTD[22], 99.000000, 17.000000);
	TextDrawAlignment(VotingTD[22], 1);
	TextDrawColor(VotingTD[22], 43);
	TextDrawSetShadow(VotingTD[22], 0);
	TextDrawBackgroundColor(VotingTD[22], 255);
	TextDrawFont(VotingTD[22], 4);
	TextDrawSetProportional(VotingTD[22], 0);

	VotingTD[23] = TextDrawCreate(320.000000, 339.851806, "PRESS 'ESC' TO CLOSE");
	TextDrawLetterSize(VotingTD[23], 0.167500, 0.998519);
	TextDrawTextSize(VotingTD[23], 0.000000, 180.000000);
	TextDrawAlignment(VotingTD[23], 2);
	TextDrawColor(VotingTD[23], 255);
	TextDrawSetShadow(VotingTD[23], 0);
	TextDrawBackgroundColor(VotingTD[23], 255);
	TextDrawFont(VotingTD[23], 2);
	TextDrawSetProportional(VotingTD[23], 1);

	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
		TextDrawTextSize(VotingTD[i + 10], 23.000000, -150.000000);
		TextDrawAlignment(VotingTD[i + 10], 1);
		TextDrawSetShadow(VotingTD[i + 10], 0);
		TextDrawBackgroundColor(VotingTD[i + 10], 255);
		TextDrawFont(VotingTD[i + 10], 4);
		TextDrawSetProportional(VotingTD[i + 10], 0);

		TextDrawLetterSize(VotingTD[i + 15], 0.164994, 0.998516);
		TextDrawTextSize(VotingTD[i + 15], 464.833343, 0.000000);
		TextDrawAlignment(VotingTD[i + 15], 1);
		TextDrawUseBox(VotingTD[i + 15], 1);
		TextDrawBoxColor(VotingTD[i + 15], -16711936);
		TextDrawSetShadow(VotingTD[i + 15], 0);
		TextDrawSetOutline(VotingTD[i + 15], 1);
		TextDrawBackgroundColor(VotingTD[i + 15], 255);
		TextDrawFont(VotingTD[i + 15], 2);
		TextDrawSetProportional(VotingTD[i + 15], 1);

		if (i >= 4) continue;
		TextDrawTextSize(VotingTD[i], 24.000000, 24.000000);
		TextDrawAlignment(VotingTD[i], 1);
		TextDrawColor(VotingTD[i], COLOR_SERVER);
		TextDrawSetShadow(VotingTD[i], 0);
		TextDrawBackgroundColor(VotingTD[i], 255);
		TextDrawFont(VotingTD[i], 4);
		TextDrawSetProportional(VotingTD[i], 0);

		TextDrawAlignment(VotingTD[i + 4], 1);
		TextDrawSetShadow(VotingTD[i + 4], 0);
		TextDrawBackgroundColor(VotingTD[i + 4], 255);
		TextDrawFont(VotingTD[i + 4], 4);
		TextDrawSetProportional(VotingTD[i + 4], 0);
	}
}
stock UpdateVotingTD() {
	new Float:percent[MAX_VOTING_CANDIDATES], Float:sum;
	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) 
		sum += float(VotingInfo[votingPoints][i]);
	for (new i = 0, Float:sizeY; i < MAX_VOTING_CANDIDATES; i++) {
		if (!strcmp(VotingCandidatesName[i], "None", true)) {
			format(t_string, sizeof (t_string), "_");
			sizeY = 0.0;
		} else {
			if (sum <= 0) percent[i] = 0.0;
			else percent[i] = float(VotingInfo[votingPoints][i]) / sum * 100.0;
			sizeY = percent[i] * -1.5;

			if (sizeY < -150.0) sizeY = -150.0;
			else if (sizeY > -2.0) sizeY = -2.0;

			format(t_string, sizeof (t_string), "_%i) ~w~%s~n~_____~y~~h~(%i) votes)", 
				i + 1, VotingCandidatesName[i], VotingInfo[votingPoints][i]
			);
		}
		TextDrawSetString(VotingTD[i + 15], t_string), t_string[0] = EOS;
		TextDrawTextSize(VotingTD[i + 10], 23.000000, sizeY);
	}
}
stock StartVoting(const startedBy[], const candidate_1[], const candidate_2[], const candidate_3[], const candidate_4[], const candidate_5[]) {
	format(VotingCandidatesName[0], MAX_PLAYER_NAME + 1, candidate_1);
	format(VotingCandidatesName[1], MAX_PLAYER_NAME + 1, candidate_2);
	format(VotingCandidatesName[2], MAX_PLAYER_NAME + 1, candidate_3);
	format(VotingCandidatesName[3], MAX_PLAYER_NAME + 1, candidate_4);
	format(VotingCandidatesName[4], MAX_PLAYER_NAME + 1, candidate_5);

	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++)
		VotingInfo[votingPoints][i] = 0;
	VotingInfo[votingTime] = gettime() + (12 * 3600);
	
	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_VOTING" SET time = %i, points = '%i|%i|%i|%i|%i', startedBy = '%s', \
		candidate_1 = '%s', candidate_2 = '%s', candidate_3 = '%s', candidate_4 = '%s', candidate_5 = '%s' \
		WHERE 1", 
		VotingInfo[votingTime], VotingInfo[votingPoints][0], 
		VotingInfo[votingPoints][1], VotingInfo[votingPoints][2], 
		VotingInfo[votingPoints][3], VotingInfo[votingPoints][4],
		startedBy, candidate_1, candidate_2, candidate_3, candidate_4, candidate_5
	);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

	foreach(new playerid: PlayerInLogin) pInfo[playerid][pVotingID] = 0;
	mysql_tquery(dbHandle, "UPDATE `s_users` SET pVotingID = 0 WHERE 1", "", "");

	UpdateVotingTD();
	foreach(new playerid: PlayerInLogin) {
		if (!VotingPanelShowed[playerid]) continue;
		ShowVotingTD(playerid, .update = 1);
	}
	SendClientMessageToAll(0x2641EDFF, !"Внимание! В штате начались выборы и продлятся 12 часов!");
	SendClientMessageToAll(0x2641EDFF, !"Проголосовать и посмотреть кандидатов можно в мэрии штата.");
}
stock LoadVotingData() {
	new rows, Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_VOTING" WHERE 1");
	cache_get_row_count(rows);
	if (!rows) {
		printf("[Загрузка ...] Данные из "TABLE_VOTING" не были загружены из-за ошибки.");
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	cache_get_value_name_int(0, "time", VotingInfo[votingTime]);
	cache_get_value_name_int(0, "lastTime", VotingInfo[votingLastTime]);

	new candidates[MAX_PLAYER_NAME * MAX_VOTING_CANDIDATES + 2];
	cache_get_value_name(0, "points", candidates, sizeof (candidates));
	sscanf(candidates, "p<|>iiiii", VotingInfo[votingPoints][0],
		VotingInfo[votingPoints][1], VotingInfo[votingPoints][2],
		VotingInfo[votingPoints][3], VotingInfo[votingPoints][4]
	);
	cache_get_value_name(0, "candidate_1", VotingCandidatesName[0], MAX_PLAYER_NAME + 1);
	cache_get_value_name(0, "candidate_2", VotingCandidatesName[1], MAX_PLAYER_NAME + 1);
	cache_get_value_name(0, "candidate_3", VotingCandidatesName[2], MAX_PLAYER_NAME + 1);
	cache_get_value_name(0, "candidate_4", VotingCandidatesName[3], MAX_PLAYER_NAME + 1);
	cache_get_value_name(0, "candidate_5", VotingCandidatesName[4], MAX_PLAYER_NAME + 1);

	printf("[Загрузка ...] Данные из "TABLE_VOTING" успешно загружены.");
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
}
stock ChosePlayerVoting(playerid, voting_id) {
	if (!VotingInfo[votingTime] || pInfo[playerid][pVotingID]) 
		return false;
	if (!strcmp(VotingCandidatesName[voting_id], "None", true)) 
		return false;
	VotingInfo[votingPoints][voting_id]++;

	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_VOTING" SET points = '%i|%i|%i|%i|%i' WHERE 1", 
		VotingInfo[votingPoints][0], VotingInfo[votingPoints][1], VotingInfo[votingPoints][2], 
		VotingInfo[votingPoints][3], VotingInfo[votingPoints][4]
	);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

	pInfo[playerid][pVotingID] = voting_id + 1;
	SavePlayerInteger(playerid, "pVotingID", pInfo[playerid][pVotingID]);

	format(t_string, sizeof (t_string), "Вы проголосовали за %s.", VotingCandidatesName[voting_id]);
	SendClientMessage(playerid, 0x999999FF, t_string), t_string[0] = EOS;

	UpdateVotingTD();
	ShowVotingTD(playerid, .update = 1);
	return true;
}
stock SaveVoting(const query_string[]) {
	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_VOTING" SET %s WHERE id = %i LIMIT 1", query_string
	);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
stock StopVoting() {
	VotingInfo[votingTime] = 0;
	VotingInfo[votingLastTime] = gettime() + (3600 * 2);

	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_VOTING" SET time = %i, lastTime = %i WHERE 1", 
		VotingInfo[votingTime], VotingInfo[votingLastTime]
	);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

	UpdateVotingTD();
	foreach(new playerid: PlayerInLogin) {
		if (!VotingPanelShowed[playerid]) continue;
		ShowVotingTD(playerid, .update = 1);
	}
	TextDrawSetString(VotingTD[20], "_");

	SendClientMessageToAll(0x2641EDFF, !"Внимание! Выборы были успешно завершены!");
	SendClientMessageToAll(0x2641EDFF, !"Результаты можно посмотреть в мэрии штата.");
}
OnVotingTimer() {
	if (!VotingInfo[votingTime]) return;
	
	new time = VotingInfo[votingTime] - gettime();
	switch (time) {
		case 3600 / 2: SendClientMessageToAll(0x2641EDFF, !"Внимание! До завершения выборов остается полчаса!");
		case 1 * 3600: SendClientMessageToAll(0x2641EDFF, !"Внимание! До завершения выборов остался ровно 1 час!");
		case 6 * 3600: SendClientMessageToAll(0x2641EDFF, !"Внимание! До завершения выборов остается 6 часов!");
	}
	format(t_string, sizeof (t_string), "%02d:%02d:%02d", 
		time / 3600, time % 3600 / 60, time % 3600 % 60
	);
	TextDrawSetString(VotingTD[20], t_string), t_string[0] = EOS;

	if (gettime() > VotingInfo[votingTime]) StopVoting();
}
stock ShowVotingTD(playerid, update = 0) {
	if (!VotingInfo[votingTime] && VotingInfo[votingLastTime] <= gettime()) {
		SendClientMessage(playerid, COLOR_GREY, "В данный момент в штате не проходят выборы!");
		return false;
	}
	if (!update) UpdateVotingTD();

	new Float:percent[MAX_VOTING_CANDIDATES], Float:sum;
	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) sum += float(VotingInfo[votingPoints][i]);

	if (!update) {
		VotingPTD[playerid][0] = CreatePlayerTextDraw(playerid, 193.550, 310.500, "ld_chat:thumbup");
		VotingPTD[playerid][1] = CreatePlayerTextDraw(playerid, 226.016, 310.500, "ld_chat:thumbup");
		VotingPTD[playerid][2] = CreatePlayerTextDraw(playerid, 257.799, 310.500, "ld_chat:thumbup");
		VotingPTD[playerid][3] = CreatePlayerTextDraw(playerid, 289.216, 310.500, "ld_chat:thumbup");
		VotingPTD[playerid][4] = CreatePlayerTextDraw(playerid, 321.649, 310.500, "ld_chat:thumbup");
	}
	for (new i = 0, Float:sizeX, Float:sizeY, color; i < sizeof (VotingTD); i++) {
		if (i < sizeof (VotingPTD[])) {
			if (i < MAX_VOTING_CANDIDATES) {
				if (sum <= 0) percent[i] = 0.0;
				else percent[i] = float(VotingInfo[votingPoints][i]) / sum * 100.0;

				switch (i) {
					case 0: sizeX = 202.099914, color = -2147483426;
					case 1: sizeX = 233.583236, color = -5963562;
					case 2: sizeX = 265.666595, color = 2046885854;
					case 3: sizeX = 296.833251, color = -2139094818;
					case 4: sizeX = 328.766693, color = 8388830;
				}
				if (!strcmp(VotingCandidatesName[i], "None", true)) t_string = "_";
				else if (percent[i] < 100.0) format(t_string, sizeof (t_string), "%.2f%%", percent[i]);
				else format(t_string, sizeof (t_string), "%.1f%%", percent[i]);

				sizeY = GetVotingSizeY(percent[i]);
				if (sizeY < 144.352005) sizeY = 144.352005;
				else if (sizeY > 292.829833) sizeY = 292.829833;
				if (update) PlayerTextDrawDestroy(playerid, VotingPTD[playerid][i + 5]);
				VotingPTD[playerid][i + 5] = CreatePlayerTextDraw(playerid, sizeX, sizeY, t_string);
				PlayerTextDrawColor(playerid, VotingPTD[playerid][i + 5], color);
				PlayerTextDrawLetterSize(playerid, VotingPTD[playerid][i + 5], 0.212497, 1.019258);
				PlayerTextDrawAlignment(playerid, VotingPTD[playerid][i + 5], 2);
				PlayerTextDrawSetShadow(playerid, VotingPTD[playerid][i + 5], 0);
				PlayerTextDrawBackgroundColor(playerid, VotingPTD[playerid][i + 5], 255);
				PlayerTextDrawFont(playerid, VotingPTD[playerid][i + 5], 2);
				PlayerTextDrawSetProportional(playerid, VotingPTD[playerid][i + 5], 1);

				if (update) continue;
				PlayerTextDrawTextSize(playerid, VotingPTD[playerid][i], 16.000000, 18.000000);
				PlayerTextDrawAlignment(playerid, VotingPTD[playerid][i], 1);
				PlayerTextDrawColor(playerid, VotingPTD[playerid][i], -141); // 8388863
				PlayerTextDrawSetShadow(playerid, VotingPTD[playerid][i], 0);
				PlayerTextDrawBackgroundColor(playerid, VotingPTD[playerid][i], 255);
				PlayerTextDrawFont(playerid, VotingPTD[playerid][i], 4);
				PlayerTextDrawSetProportional(playerid, VotingPTD[playerid][i], 0);
				PlayerTextDrawSetSelectable(playerid, VotingPTD[playerid][i], true);
			}
			if (i < MAX_VOTING_CANDIDATES) { 
				if (strcmp(VotingCandidatesName[i], "None", true)) PlayerTextDrawShow(playerid, VotingPTD[playerid][i]);
			}
			else PlayerTextDrawShow(playerid, VotingPTD[playerid][i]);
		}
		TextDrawShowForPlayer(playerid, VotingTD[i]);
	}
	if (pInfo[playerid][pVotingID]) {
		for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
			if (i == pInfo[playerid][pVotingID] - 1) {
				PlayerTextDrawColor(playerid, VotingPTD[playerid][i], 8388863);
				PlayerTextDrawSetSelectable(playerid, VotingPTD[playerid][i], false);
				PlayerTextDrawShow(playerid, VotingPTD[playerid][i]);
			} else {
				PlayerTextDrawHide(playerid, VotingPTD[playerid][i]);
			}
		}
	}
	else if (!VotingInfo[votingTime]) {
		for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
			PlayerTextDrawHide(playerid, VotingPTD[playerid][i]);
		}
	}
	SelectTextDraw(playerid, 0xDC143CFF);
	VotingPanelShowed[playerid] = true;

	t_string[0] = EOS;
	return true;
}
stock HideVotingTD(playerid) {
	if (!VotingPanelShowed[playerid]) 
		return false;
	for (new i = 0; i < sizeof (VotingTD); i++) {
		if (i < sizeof (VotingPTD[])) {
			PlayerTextDrawDestroy(playerid, VotingPTD[playerid][i]);
		}
		TextDrawHideForPlayer(playerid, VotingTD[i]);
	}
	VotingPanelShowed[playerid] = false;
	CancelSelectTextDraw(playerid);
	return true;
}
CMD:editvoting(playerid) {
	if (pInfo[playerid][pAdmin] < 6) 
		return true;
	for (new i = 0; i < MAX_VOTING_CANDIDATES; i++) {
		format(VotingTempCandidateNames[i], MAX_PLAYER_NAME + 1, "None");
	}
	ShowVotingEditMenu(playerid, D_VOTING_PANEL);
	return true;
}
CMD:voting(playerid) { 
	if (pInfo[playerid][pAdmin] < 6) 
		return true;
	ShowVotingTD(playerid);
	return true;
}