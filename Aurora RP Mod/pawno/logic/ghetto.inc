#if defined _ghetto_included
	#endinput
#endif
#define _ghetto_included // ( Ghetto Pass & Kill Table systems )

#define GHETTO_CAPTIRE_MIN_PLAYERS		(1)

enum GHETTO_e {
	ghettoKills,
	Float:ghettoDMG,
	ghettoDeaths,
	ghettoPassLevel,
	Float:ghettoLevelDMG,
	bool:GhettoGUI,
}
new GhettoInfo[MAX_PLAYERS][GHETTO_e];

static 
	Text:GhettoTableTD[36], 
	PlayerText:GhettoTablePTD[MAX_PLAYERS][3];

static const ghettoGangBoxTDColors[] = { -16711917, -5963725, 8388633, 16777034, -1378294198 };

ghetto_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (!zahvat || !IsAGang(playerid)) 
		return false;
	if ((newkeys & KEY_YES) && !(oldkeys & KEY_YES)) {
		if (!ghetto_ShowGUI(playerid)) ghetto_HideGUI(playerid);
		return true;
	}
	return false;
}
alias:captstats("cstats");
CMD:captstats(playerid) {
	if (!zahvat || !IsAGang(playerid)) 
		return true;
	if (!ghetto_ShowGUI(playerid)) ghetto_HideGUI(playerid);

	return true;
}
ghetto_OnPlayerConnect(playerid) {
	GhettoInfo[playerid][ghettoPassLevel] = 1;
	GhettoInfo[playerid][ghettoDMG] = 0.0;
}
ghetto_OnPlayerDisconnect(playerid) {
	ghetto_HideGUI(playerid);
}
ghetto_OnGameModeInit() {
	ghetto_CreateTD();
}
stock ghetto_ShowGUI(playerid) {
	if (!zahvat || GhettoInfo[playerid][GhettoGUI]) 
		return false;
	ghetto_UpdateGUI();
	ghetto_CreatePTD(playerid);

	GhettoInfo[playerid][GhettoGUI] = true;
	ghetto_UdatePlayerGUI(playerid);

	for (new td_id = 0; td_id < sizeof (GhettoTableTD); td_id++) 
		TextDrawShowForPlayer(playerid, GhettoTableTD[td_id]);
	for (new ptd_id = 0; ptd_id < sizeof (GhettoTablePTD[]); ptd_id++) 
		PlayerTextDrawShow(playerid, GhettoTablePTD[playerid][ptd_id]);
	return true;
}
stock ghetto_UdatePlayerGUI(playerid) {
	if (!GhettoInfo[playerid][GhettoGUI]) return;
	new damageSTR[8];
	switch (floatround(GhettoInfo[playerid][ghettoDMG])) {
		case 000..009: format(damageSTR, sizeof (damageSTR), "___%i", floatround(GhettoInfo[playerid][ghettoDMG]));
		case 010..099: format(damageSTR, sizeof (damageSTR),  "__%i", floatround(GhettoInfo[playerid][ghettoDMG]));
		case 100..999: format(damageSTR, sizeof (damageSTR),   "_%i", floatround(GhettoInfo[playerid][ghettoDMG]));
		default: format(damageSTR, sizeof (damageSTR), 			"%i", floatround(GhettoInfo[playerid][ghettoDMG]));
	}
	new Float:K_D = GhettoInfo[playerid][ghettoDeaths];
	if (K_D < 1.0) K_D = 1.0;
	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s%i    ~y~~h~%s%i   %s   %s%i    %.1f",
		/* (LEVEL) */(GhettoInfo[playerid][ghettoPassLevel] < 10 ? " " : ""), GhettoInfo[playerid][ghettoPassLevel],
		/* (KILLS) */(GhettoInfo[playerid][ghettoKills] < 10 ? " " : ""), GhettoInfo[playerid][ghettoKills],
		/* (DMG) */damageSTR,
		/* (DEATHS) */(GhettoInfo[playerid][ghettoDeaths] < 10 ? " " : ""), GhettoInfo[playerid][ghettoDeaths],
		/* (K/D) */Float:(GhettoInfo[playerid][ghettoKills] / K_D)
	);
	PlayerTextDrawSetString(playerid, GhettoTablePTD[playerid][0], STRING_GLOBAL);

	new Float:progress = GhettoInfo[playerid][ghettoLevelDMG] / (GhettoInfo[playerid][ghettoPassLevel] * 1500 / 100.0);
	PlayerTextDrawTextSize(playerid, GhettoTablePTD[playerid][1], progress * 1.82, 2.000000);
	PlayerTextDrawShow(playerid, GhettoTablePTD[playerid][1]);

	new pass_level = GhettoInfo[playerid][ghettoPassLevel];
	if (pass_level < 1) pass_level = 1;

	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%.1f / %.1f DMG", 
		GhettoInfo[playerid][ghettoLevelDMG], 
		pass_level * 1500.0
	);
	PlayerTextDrawSetString(playerid, GhettoTablePTD[playerid][2], STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}
stock ghetto_UpdateGUI() {
	if (!zahvat) return;
	new	
		attack_players[30][2], attack_idx = 0, attack_fraction = PlayerGangID[1],
		defend_players[30][2], defend_idx = 0, defend_fraction = PlayerGangID[0];
	
	foreach (new playerid: Player) {
		if (!TI[playerid][tLogin] || AntiCheatIsKickedWithDecync(playerid) || !IsAGang(playerid)) 
			continue;
		if (PI[playerid][pMember] == attack_fraction) {
			attack_players[attack_idx][0] = playerid;
			attack_players[attack_idx++][1] = floatround(GhettoInfo[playerid][ghettoDMG]);
		}
		else if (PI[playerid][pMember] == defend_fraction) {
			defend_players[defend_idx][0] = playerid;
			defend_players[defend_idx++][1] = floatround(GhettoInfo[playerid][ghettoDMG]);
		}
	}
	SortDeepArray(attack_players, 1, .order = SORT_DESC);
	SortDeepArray(defend_players, 1, .order = SORT_DESC);

	for (new i = 0, damageSTR[8], playerid; i < 6; i++) {
		TextDrawBoxColor(GhettoTableTD[i + 6], ghettoGangBoxTDColors[attack_fraction - fBALLAS]);

		if (attack_players[i][1] == 0) {
			TextDrawSetString(GhettoTableTD[i + 6], "__");
			TextDrawSetString(GhettoTableTD[i + 18], "__");
		} else {
			playerid = attack_players[i][0];
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "__%s", player_name[playerid]);
			TextDrawSetString(GhettoTableTD[i + 6], STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

			switch (floatround(GhettoInfo[playerid][ghettoDMG])) {
				case 0..9: format(damageSTR, sizeof (damageSTR), "___%i", floatround(GhettoInfo[playerid][ghettoDMG]));
				case 10..99: format(damageSTR, sizeof (damageSTR), "__%i", floatround(GhettoInfo[playerid][ghettoDMG]));
				case 100..999: format(damageSTR, sizeof (damageSTR), "_%i", floatround(GhettoInfo[playerid][ghettoDMG]));
				default: format(damageSTR, sizeof (damageSTR), "%i", floatround(GhettoInfo[playerid][ghettoDMG]));
			}
			new Float:K_D = GhettoInfo[playerid][ghettoDeaths];
			if (K_D < 1.0) K_D = 1.0;

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "~y~~h~%s%i    ~w~%s%i   %s   %s%i    %.1f",
				/* (LEVEL) */(GhettoInfo[playerid][ghettoPassLevel] < 10 ? " " : ""), GhettoInfo[playerid][ghettoPassLevel],
				/* (KILLS) */(GhettoInfo[playerid][ghettoKills] < 10 ? " " : ""), GhettoInfo[playerid][ghettoKills],
				/* (DMG) */damageSTR,
				/* (DEATHS) */(GhettoInfo[playerid][ghettoDeaths] < 10 ? " " : ""), GhettoInfo[playerid][ghettoDeaths],
				/* (K/D) */Float:(GhettoInfo[playerid][ghettoKills] / K_D)
			);
			TextDrawSetString(GhettoTableTD[i + 18], STRING_GLOBAL);
		}
		TextDrawBoxColor(GhettoTableTD[i + 12], ghettoGangBoxTDColors[defend_fraction - fBALLAS]);

		if (defend_players[i][1] == 0) {
			TextDrawSetString(GhettoTableTD[i + 12], "__");
			TextDrawSetString(GhettoTableTD[i + 24], "__");
		} else {
			playerid = defend_players[i][0];
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "__%s", player_name[playerid]);
			TextDrawSetString(GhettoTableTD[i + 12], STRING_GLOBAL);

			switch (floatround(GhettoInfo[playerid][ghettoDMG])) {
				case 0..9:  format(damageSTR, sizeof (damageSTR), "   %i", floatround(GhettoInfo[playerid][ghettoDMG]));
				case 10..99: format(damageSTR, sizeof (damageSTR), "  %i", floatround(GhettoInfo[playerid][ghettoDMG]));
				case 100..999: format(damageSTR, sizeof (damageSTR), " %i", floatround(GhettoInfo[playerid][ghettoDMG]));
				default: format(damageSTR, sizeof (damageSTR), "%i", floatround(GhettoInfo[playerid][ghettoDMG]));
			}
			new Float:K_D = GhettoInfo[playerid][ghettoDeaths];
			if (K_D < 1.0) K_D = 1.0;

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "~y~~h~%s%i    ~w~%s%i   %s   %s%i    %.1f",
				/* (LEVEL) */(GhettoInfo[playerid][ghettoPassLevel] < 10 ? " " : ""), GhettoInfo[playerid][ghettoPassLevel],
				/* (KILLS) */(GhettoInfo[playerid][ghettoKills] < 10 ? " " : ""), GhettoInfo[playerid][ghettoKills],
				/* (DMG) */damageSTR,
				/* (DEATHS) */(GhettoInfo[playerid][ghettoDeaths] < 10 ? " " : ""), GhettoInfo[playerid][ghettoDeaths],
				/* (K/D) */Float:(GhettoInfo[playerid][ghettoKills] / K_D)
			);
			TextDrawSetString(GhettoTableTD[i + 24], STRING_GLOBAL);
		}
	}
	STRING_GLOBAL[0] = EOS;
}
stock ghetto_HideGUI(playerid) {
	if (!GhettoInfo[playerid][GhettoGUI]) 
		return false;
	for (new td_id = 0; td_id < sizeof (GhettoTableTD); td_id++) 
		TextDrawHideForPlayer(playerid, GhettoTableTD[td_id]);
	for (new ptd_id = 0; ptd_id < sizeof (GhettoTablePTD[]); ptd_id++) 
		PlayerTextDrawDestroy(playerid, GhettoTablePTD[playerid][ptd_id]);
	return GhettoInfo[playerid][GhettoGUI] = false;
}
stock ghetto_OnPlayerKill(playerid, targetid) {
	GhettoInfo[playerid][ghettoKills]++;
	GhettoInfo[targetid][ghettoDeaths]++;
	ghetto_UdatePlayerGUI(playerid);
}
stock ghetto_OnPlayerDMG(playerid, targetid, Float:amount) {
	GhettoInfo[playerid][ghettoDMG] += amount, GhettoInfo[playerid][ghettoLevelDMG] += amount;
	if (GhettoInfo[playerid][ghettoLevelDMG] >= (GhettoInfo[playerid][ghettoPassLevel] * 1500.0)) {
		GhettoInfo[playerid][ghettoLevelDMG] -= GhettoInfo[playerid][ghettoPassLevel] * 1500.0;
		GhettoInfo[playerid][ghettoPassLevel]++;
	}
	#pragma unused targetid
	ghetto_UdatePlayerGUI(playerid);
}
stock ghetto_CreateTD() {
	GhettoTableTD[0] = TextDrawCreate(106.249954, 72.144851, "bg");
	TextDrawTextSize(GhettoTableTD[0], 427.000000, 383.000000);
	TextDrawAlignment(GhettoTableTD[0], 1);
	TextDrawColor(GhettoTableTD[0], 128);
	TextDrawSetShadow(GhettoTableTD[0], 0);
	TextDrawFont(GhettoTableTD[0], 5);
	TextDrawBackgroundColor(GhettoTableTD[0], 0);
	TextDrawSetProportional(GhettoTableTD[0], 0);
	TextDrawSetPreviewModel(GhettoTableTD[0], 2729);
	TextDrawSetPreviewRot(GhettoTableTD[0], 0.000000, 0.000000, 0.000000, 1.000000);

	GhettoTableTD[1] = TextDrawCreate(235.000000, 165.33000, "NAME");
	GhettoTableTD[2] = TextDrawCreate(343.333343, 165.33000, "KILLS");
	GhettoTableTD[3] = TextDrawCreate(368.267089, 165.33000, "DMG");
	GhettoTableTD[4] = TextDrawCreate(395.600341, 165.33000, "DEATHS");
	GhettoTableTD[5] = TextDrawCreate(424.583435, 165.33000, "K/D");

	for (new td_id = 1; td_id < 6; td_id++) {
		TextDrawColor(GhettoTableTD[td_id], td_id % 2 != 0 ? (-1061109505) : (-1));
		TextDrawLetterSize(GhettoTableTD[td_id], 0.166078, 0.787406);
		TextDrawTextSize(GhettoTableTD[td_id], 0.000000, 440.000000);
		TextDrawAlignment(GhettoTableTD[td_id], 2);
		TextDrawSetShadow(GhettoTableTD[td_id], 0);
		TextDrawSetOutline(GhettoTableTD[td_id], 1);
		TextDrawBackgroundColor(GhettoTableTD[td_id], 255);
		TextDrawFont(GhettoTableTD[td_id], 1);
		TextDrawSetProportional(GhettoTableTD[td_id], 1);
	}
	GhettoTableTD[6] = TextDrawCreate(200.000000, 178.500000, "__");
	GhettoTableTD[7] = TextDrawCreate(200.000000, 192.150000, "__");
	GhettoTableTD[8] = TextDrawCreate(200.000000, 205.800000, "__");
	GhettoTableTD[9] = TextDrawCreate(200.000000, 219.450000, "__");
	GhettoTableTD[10] = TextDrawCreate(200.000000, 233.100000, "__");
	GhettoTableTD[11] = TextDrawCreate(200.000000, 246.750000, "__");
	GhettoTableTD[12] = TextDrawCreate(200.000000, 273.600000, "__");
	GhettoTableTD[13] = TextDrawCreate(200.000000, 287.250000, "__");
	GhettoTableTD[14] = TextDrawCreate(200.000000, 300.900000, "__");
	GhettoTableTD[15] = TextDrawCreate(200.000000, 314.550000, "__");
	GhettoTableTD[16] = TextDrawCreate(200.000000, 328.200000, "__");
	GhettoTableTD[17] = TextDrawCreate(200.000000, 341.850000, "__");

	for (new td_id = 6; td_id < 18; td_id++) {
		TextDrawColor(GhettoTableTD[td_id], td_id % 2 == 0 ? (-2139062017) : (-1061109505));
		TextDrawLetterSize(GhettoTableTD[td_id], 0.210078, 0.967408);
		TextDrawTextSize(GhettoTableTD[td_id], 440.000000, 0.000000);
		TextDrawAlignment(GhettoTableTD[td_id], 1);
		TextDrawUseBox(GhettoTableTD[td_id], 1);
		TextDrawBoxColor(GhettoTableTD[td_id], -16711917);
		TextDrawSetShadow(GhettoTableTD[td_id], 0);
		TextDrawSetOutline(GhettoTableTD[td_id], 1);
		TextDrawBackgroundColor(GhettoTableTD[td_id], 255);
		TextDrawFont(GhettoTableTD[td_id], 1);
		TextDrawSetProportional(GhettoTableTD[td_id], 1);
	}
	GhettoTableTD[18] = TextDrawCreate(312.048461, 178.500000, "__");
	GhettoTableTD[19] = TextDrawCreate(312.048461, 192.149993, "__");
	GhettoTableTD[20] = TextDrawCreate(312.048461, 205.800003, "__");
	GhettoTableTD[21] = TextDrawCreate(312.048461, 219.449996, "__");
	GhettoTableTD[22] = TextDrawCreate(312.048461, 233.100006, "__");
	GhettoTableTD[23] = TextDrawCreate(312.048461, 246.750000, "__");
	GhettoTableTD[24] = TextDrawCreate(312.048461, 273.600006, "__");
	GhettoTableTD[25] = TextDrawCreate(312.048461, 287.250000, "__");
	GhettoTableTD[26] = TextDrawCreate(312.048461, 300.899993, "__");
	GhettoTableTD[27] = TextDrawCreate(312.048461, 314.549987, "__");
	GhettoTableTD[28] = TextDrawCreate(312.048461, 328.200012, "__");
	GhettoTableTD[29] = TextDrawCreate(312.048461, 341.850006, "__");

	for (new td_id = 18; td_id < 30; td_id++) {
		TextDrawLetterSize(GhettoTableTD[td_id], 0.210078, 0.967408);
		TextDrawTextSize(GhettoTableTD[td_id], 604.000000, 0.000000);
		TextDrawAlignment(GhettoTableTD[td_id], 1);
		TextDrawColor(GhettoTableTD[td_id], -1465581313);
		TextDrawSetShadow(GhettoTableTD[td_id], 0);
		TextDrawSetOutline(GhettoTableTD[td_id], 1);
		TextDrawBackgroundColor(GhettoTableTD[td_id], 255);
		TextDrawFont(GhettoTableTD[td_id], 1);
		TextDrawSetProportional(GhettoTableTD[td_id], 0);
	}
	GhettoTableTD[30] = TextDrawCreate(320.000000, 369.179595, "PRESS \"Y\"");
	TextDrawLetterSize(GhettoTableTD[30], 0.166078, 0.787406);
	TextDrawTextSize(GhettoTableTD[30], 0.000000, 440.000000);
	TextDrawAlignment(GhettoTableTD[30], 2);
	TextDrawColor(GhettoTableTD[30], -1061109710);
	TextDrawSetShadow(GhettoTableTD[30], 0);
	TextDrawSetOutline(GhettoTableTD[30], 1);
	TextDrawBackgroundColor(GhettoTableTD[30], 255);
	TextDrawFont(GhettoTableTD[30], 1);
	TextDrawSetProportional(GhettoTableTD[30], 1);

	GhettoTableTD[31] = TextDrawCreate(200.000000, 260.199188, "__~>~ ~y~~h~Your personal");
	TextDrawLetterSize(GhettoTableTD[31], 0.210078, 0.967408);
	TextDrawTextSize(GhettoTableTD[31], 440.000000, 0.000000);
	TextDrawAlignment(GhettoTableTD[31], 1);
	TextDrawColor(GhettoTableTD[31], -1);
	TextDrawUseBox(GhettoTableTD[31], 1);
	TextDrawBoxColor(GhettoTableTD[31], 75);
	TextDrawSetShadow(GhettoTableTD[31], 0);
	TextDrawSetOutline(GhettoTableTD[31], 1);
	TextDrawBackgroundColor(GhettoTableTD[31], 255);
	TextDrawFont(GhettoTableTD[31], 1);
	TextDrawSetProportional(GhettoTableTD[31], 1);

	GhettoTableTD[32] = TextDrawCreate(316.731719, 158.229568, "~y~~h~GHETTO~n~~y~~h~PASS");
	TextDrawLetterSize(GhettoTableTD[32], 0.166078, 0.787406);
	TextDrawTextSize(GhettoTableTD[32], 0.000000, 440.000000);
	TextDrawAlignment(GhettoTableTD[32], 2);
	TextDrawColor(GhettoTableTD[32], -5963521);
	TextDrawSetShadow(GhettoTableTD[32], 0);
	TextDrawSetOutline(GhettoTableTD[32], 1);
	TextDrawBackgroundColor(GhettoTableTD[32], 255);
	TextDrawFont(GhettoTableTD[32], 1);
	TextDrawSetProportional(GhettoTableTD[32], 1);

	GhettoTableTD[33] = TextDrawCreate(229.166656, 366.163116, "LD_SPAC:white");
	TextDrawTextSize(GhettoTableTD[33], 182.000000, 2.000000);
	TextDrawAlignment(GhettoTableTD[33], 1);
	TextDrawColor(GhettoTableTD[33], 174);
	TextDrawSetShadow(GhettoTableTD[33], 0);
	TextDrawBackgroundColor(GhettoTableTD[33], 255);
	TextDrawFont(GhettoTableTD[33], 4);
	TextDrawSetProportional(GhettoTableTD[33], 0);

	GhettoTableTD[34] = TextDrawCreate(316.731719, 153.329269, "SEASON-1");
	TextDrawLetterSize(GhettoTableTD[34], 0.132074, 0.617406);
	TextDrawTextSize(GhettoTableTD[34], -0.259999, 442.000000);
	TextDrawAlignment(GhettoTableTD[34], 2);
	TextDrawColor(GhettoTableTD[34], -5963521);
	TextDrawSetShadow(GhettoTableTD[34], 0);
	TextDrawSetOutline(GhettoTableTD[34], 1);
	TextDrawBackgroundColor(GhettoTableTD[34], 255);
	TextDrawFont(GhettoTableTD[34], 1);
	TextDrawSetProportional(GhettoTableTD[34], 1);

	GhettoTableTD[35] = TextDrawCreate(229.566665, 358.392333, "LEVEL PROGRESS");
	TextDrawLetterSize(GhettoTableTD[35], 0.143333, 0.682222);
	TextDrawTextSize(GhettoTableTD[35], 503.000000, 0.000000);
	TextDrawAlignment(GhettoTableTD[35], 1);
	TextDrawColor(GhettoTableTD[35], -2139094785);
	TextDrawSetShadow(GhettoTableTD[35], 0);
	TextDrawSetOutline(GhettoTableTD[35], 1);
	TextDrawBackgroundColor(GhettoTableTD[35], 255);
	TextDrawFont(GhettoTableTD[35], 1);
	TextDrawSetProportional(GhettoTableTD[35], 1);
}
stock ghetto_CreatePTD(playerid) {
	GhettoTablePTD[playerid][0] = CreatePlayerTextDraw(playerid, 312.048461, 260.199188, " 0    ~y~~h~ 0      0    0    0.0");
	PlayerTextDrawLetterSize(playerid, GhettoTablePTD[playerid][0], 0.210078, 0.967408);
	PlayerTextDrawTextSize(playerid, GhettoTablePTD[playerid][0], 604.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, GhettoTablePTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, GhettoTablePTD[playerid][0], -5963521);
	PlayerTextDrawSetShadow(playerid, GhettoTablePTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, GhettoTablePTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, GhettoTablePTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, GhettoTablePTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, GhettoTablePTD[playerid][0], 0);

	GhettoTablePTD[playerid][1] = CreatePlayerTextDraw(playerid, 229.166656, 366.163116, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, GhettoTablePTD[playerid][1], 20.000000, 2.000000);
	PlayerTextDrawAlignment(playerid, GhettoTablePTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, GhettoTablePTD[playerid][1], -2139094868);
	PlayerTextDrawSetShadow(playerid, GhettoTablePTD[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, GhettoTablePTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, GhettoTablePTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, GhettoTablePTD[playerid][1], 0);

	GhettoTablePTD[playerid][2] = CreatePlayerTextDraw(playerid, 411.649963, 368.425750, "0 / 1500 DMG");
	PlayerTextDrawLetterSize(playerid, GhettoTablePTD[playerid][2], 0.143333, 0.682222);
	PlayerTextDrawTextSize(playerid, GhettoTablePTD[playerid][2], 503.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, GhettoTablePTD[playerid][2], 3);
	PlayerTextDrawColor(playerid, GhettoTablePTD[playerid][2], -2139094785);
	PlayerTextDrawSetShadow(playerid, GhettoTablePTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, GhettoTablePTD[playerid][2], 1);
	PlayerTextDrawBackgroundColor(playerid, GhettoTablePTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, GhettoTablePTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, GhettoTablePTD[playerid][2], 1);
}