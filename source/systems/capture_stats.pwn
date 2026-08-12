#if defined _capture_stats_inc
	#endinput
#endif
#define _capture_stats_inc

#define CAPTURE_SHOW_ALWAYS		// всегда можно смотреть

#define MAX_CAPTURE_STATS_PLAYERS		(7)  

enum {
	TYPE_CAPTURE_0 = 0,
	TYPE_CAPTURE_1,
	TYPE_CAPTURE_2,
	TYPE_WAR_MAFIA,
	TYPE_WAR_BIKERS
}
#define MAX_WAR_CAPTURE_SAMETIME		(5)

new 
	PlayerText:CapturePTD[MAX_PLAYERS],
	Text:CaptureTD[MAX_WAR_CAPTURE_SAMETIME][11];

enum CAPTURE_STATS_e {
	bool:pCaptureStatsGUI,
	pKills,
	pDeaths,
	Float:pDMG,
}
new CaptureInfo[MAX_PLAYERS][CAPTURE_STATS_e];

static 
	Text:CaptureStatsGUI_TD[16], 
	Text:CaptureStatsData_TD[MAX_WAR_CAPTURE_SAMETIME][32];


new capture_band_captureid[max_war_capture] = {-1, ...}, captureid_slots[MAX_WAR_CAPTURE_SAMETIME] = {-1, ...},
	setCaptureFreeID[MAX_WAR_CAPTURE_SAMETIME] = {-1, ...};
new capture_gangs[MAX_WAR_CAPTURE_SAMETIME][2];//, capture_total = 0;

static const Array_Hud_Frac_Capture[][] = {
	"hud:radar_gangP",
	"hud:radar_gangY",
	"hud:radar_gangG", 
	"hud:radar_gangB",
	"hud:radar_gangN",
	"hud:radar_datedrink",
	"hud:radar_triads",
	"hud:radar_emmetgun",
	"hud:radar_Flag",
	"hud:radar_Flag",
	"hud:radar_Flag",
	"hud:radar_gangY"
}; 
stock GetCaptureID() {
	new C_IDX = -1;
	for (new captureid = 0; captureid < MAX_WAR_CAPTURE_SAMETIME; captureid++) {
		if (setCaptureFreeID[captureid] != -1) continue;
		C_IDX = captureid;
		break;
	}
	return C_IDX;
} 

stock GetCaptureFractionID(fraction) {
	new	C_IDX = -1
	for (new captureid = 0; captureid < MAX_WAR_CAPTURE_SAMETIME; captureid++) {
		if (setCaptureFreeID[captureid] != fraction) continue;
		C_IDX = captureid;
		break;
	}
	return C_IDX;
} 
stock GetFreeCaptureID() {
	new capture_id;
	for (new captureid = 0; captureid < MAX_WAR_CAPTURE_SAMETIME; captureid++) {
		if (captureid_slots[captureid] != -1) continue;
		capture_id = captureid;
		break;
	}
	
	return capture_id;
}
stock GetGangCaptureID(memberid) {
	if (capture_band(memberid) >= sizeof (capture_band_captureid)) return 0;
	return capture_band_captureid[capture_band(memberid)];
}
 

stock cstats_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	
	//printf("cstats_OnPlayerKeyStateChange 1");
	if ((IsAGang(playerid) || IsAMafia(playerid)) && capture_band(pInfo[playerid][pMember]) < sizeof (capture_band_captureid) && capture_band_captureid[capture_band(pInfo[playerid][pMember])] != -1) {
		//printf("cstats_OnPlayerKeyStateChange 2");
		if ((newkeys & KEY_NO) && !(oldkeys & KEY_NO)) {
			//printf("cstats_OnPlayerKeyStateChange 3");
			if (!CaptureInfo[playerid][pCaptureStatsGUI]) 
				ShowCaptureStats_TD(playerid);
			else HideCaptureStats_TD(playerid);
			//printf("cstats_OnPlayerKeyStateChange 4");
			return true;
		}
	}
	return false;
}
stock cstats_OnPlayerSpawn(playerid) {
    HideCaptureStats_TD(playerid);
}
stock cstats_OnPlayerKill(playerid, targetid) {
	if (
		IsAGang(playerid) && !IsPlayerToGhetto(playerid) ||
		IsAMafia(playerid) && !IsPlayerToMafiaWar(playerid) ||
		IsABiker(playerid) && !IsPlayerToBikersWar(playerid, BikersFamilyHouseID)
	) return false;
	CaptureInfo[playerid][pKills]++;
	CaptureInfo[targetid][pDeaths]++;
	return true;
}
stock IsPlayerToMafiaWar(playerid) {
	if (!ZoneID) return false;
	new zoneid = ZoneID - 1;
	return IsPlayerToSquare(playerid, MafiaWarZonePos[zoneid][0], MafiaWarZonePos[zoneid][1], MafiaWarZonePos[zoneid][2], MafiaWarZonePos[zoneid][3]);
}
stock IsPlayerToBikersWar(playerid, house_id) {
	if (house_id == -1) return false; 
	new zoneid = house_id - 1;
	return IsPlayerToSquare(playerid, BikersWarZonePos[zoneid][0], BikersWarZonePos[zoneid][1], BikersWarZonePos[zoneid][2], BikersWarZonePos[zoneid][3]);
}
cstats_OnPlayerDamageDone(playerid, issuerid, Float:amount) {
	#pragma unused playerid
	if (capture_band(pInfo[playerid][pMember]) >= sizeof (capture_band_captureid) || issuerid > MAX_PLAYERS-1 ) return true;
	if (capture_band_captureid[capture_band(pInfo[playerid][pMember])] == -1) 
		return true;
	if (pInfo[playerid][pMember] == pInfo[issuerid][pMember]) 
		return true;
	if (
		IsAGang(playerid) && IsPlayerToGhetto(playerid) || 
		IsAMafia(playerid) && IsPlayerToMafiaWar(playerid) ||
		IsABiker(playerid) && IsPlayerToBikersWar(playerid, BikersFamilyHouseID)
	) { 
		CaptureInfo[issuerid][pDMG] += amount;
		if (IsAGang(playerid)) {
			OnPlayerQuestProgress(issuerid, QUEST_GHETTO, QUEST_TASK_DMG_5,floatround(amount));
		} 
	}
	return true;
}

static CaptureStatsTimer_ticks = 0;
stock CaptureStatsTimer() {
	/*if (!capture_total) 
		return;*/
	if (++CaptureStatsTimer_ticks%2 == 0) 
		return;

	for (new capture_id = 0; capture_id < MAX_WAR_CAPTURE_SAMETIME; capture_id++) {
		if (captureid_slots[capture_id] == 0) continue;
		UpdateCaptureStats_TD(capture_id);
	}
}
stock ShowCaptureStats_TD(playerid) {
	if (CaptureInfo[playerid][pCaptureStatsGUI]/* || !capture_total */|| !IsAGang(playerid) && !IsAMafia(playerid) && !IsABiker(playerid))
		return false;

	if (capture_band(pInfo[playerid][pMember]) >= sizeof (capture_band_captureid)) return false;

	new capture_id = capture_band_captureid[capture_band(pInfo[playerid][pMember])];
	
	for (new td_id = 0; td_id < sizeof (CaptureStatsGUI_TD); td_id++)
		TextDrawShowForPlayer(playerid, CaptureStatsGUI_TD[td_id]);
	
	for (new td_id = 0; td_id < sizeof (CaptureStatsData_TD[]); td_id++)
		TextDrawShowForPlayer(playerid, CaptureStatsData_TD[capture_id][td_id]);

	return CaptureInfo[playerid][pCaptureStatsGUI] = true;
}
stock HideCaptureStats_TD(playerid) {
	if (!CaptureInfo[playerid][pCaptureStatsGUI])
		return false;

	if (capture_band(pInfo[playerid][pMember]) >= sizeof (capture_band_captureid)) return false;

	new capture_id = capture_band_captureid[capture_band(pInfo[playerid][pMember])];

	for (new td_id = 0; td_id < sizeof (CaptureStatsGUI_TD); td_id++)
			TextDrawHideForPlayer(playerid, CaptureStatsGUI_TD[td_id]);

	for (new td_id = 0; td_id < sizeof (CaptureStatsData_TD[]); td_id++)
		TextDrawHideForPlayer(playerid, CaptureStatsData_TD[capture_id][td_id]);

	return CaptureInfo[playerid][pCaptureStatsGUI] = false;
}
stock OnCaptureStart(capture_id) {
	for (new i = 0, gang_name[24], text_color, box_color; i < sizeof (capture_gangs[]); i++) {
		switch (capture_gangs[capture_id][i]) {
			case FRACTION_GROVE: gang_name = "Grove Street Gang", text_color = -2139062222, box_color = 16711720;
			case FRACTION_BALLAS: gang_name = "The Ballas Gang", text_color = -902627329, box_color = -16711864;
			case FRACTION_AZTEC: gang_name = "Varios Los Aztecas", text_color = 16777124, box_color = 16777026;
			case FRACTION_VAGOS: gang_name = "Los Santos Gang", text_color = -5963570, box_color = -5963703;
			case FRACTION_RIFA: gang_name = "The Rifa Gang", text_color = -1378294056, box_color = -1378294209;

			case FRACTION_LCN: gang_name = "La Cosa Nostra", text_color = -5963540, box_color = -5963631;
			case FRACTION_YAKUZA: gang_name = "Yakuza", text_color = -2147483393, box_color = -2147483457;
			case FRACTION_RUSSIAN: gang_name = "Russian Mafia", text_color = -1061109505, box_color = -2139062097; 

			case FRACTION_MONGOLS_MC: gang_name = "Mongols MC", text_color = -5963540, box_color = -5963631;//color (Черный)
			case FRACTION_BANDIDOS_MC: gang_name = "Bandidos MC", text_color = -2147483393, box_color = -2147483457;//color (Оранге)
			case FRACTION_OUTLAWS_MC: gang_name = "Outlaws MC", text_color = -1061109505, box_color = -2139062097; //color (Серый)
		}
		if (i == 0) {
			format(gang_name, sizeof (gang_name), "~>~ %s", gang_name);
			TextDrawColor(CaptureStatsData_TD[capture_id][29], text_color);
		} else {
			format(gang_name, sizeof (gang_name), "%s ~<~", gang_name);
			TextDrawColor(CaptureStatsData_TD[capture_id][28], text_color);
		}
		TextDrawSetString(CaptureStatsData_TD[capture_id][i + 30], gang_name);
		TextDrawColor(CaptureStatsData_TD[capture_id][i + 30], text_color/*text_color*/);

		for (new idx = 0; idx < MAX_CAPTURE_STATS_PLAYERS; idx++) {
			TextDrawSetString(CaptureStatsData_TD[capture_id][idx + 14 + ((i == 0) ? (0) : (MAX_CAPTURE_STATS_PLAYERS))], "__");
			TextDrawSetString(CaptureStatsData_TD[capture_id][idx + ((i == 0) ? (0) : (MAX_CAPTURE_STATS_PLAYERS))], "__");
			TextDrawBoxColor(CaptureStatsData_TD[capture_id][idx + ((i == 0) ? (0) : (MAX_CAPTURE_STATS_PLAYERS))], box_color);
		}
	}
	foreach (new i: Player) {
		if (pInfo[i][pMember] == capture_gangs[capture_id][0] || pInfo[i][pMember] == capture_gangs[capture_id][1]) {
			CaptureInfo[i][pKills] = 0;
			CaptureInfo[i][pDeaths] = 0;
			CaptureInfo[i][pDMG] = 0;
		}
	}
	format(t_string, sizeof (t_string), "UPDATE `s_users` SET `pCaptureStats` = '0|0|0.0' WHERE `pMember` = '%i' OR `pMember` = '%i'",
		capture_gangs[capture_id][0], capture_gangs[capture_id][1]
	);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
stock UpdateCaptureStats_TD(capture_id) {
	new 
		idx[2], Float:dmg,
		attack_players[40][2], 
		defend_players[40][2]
	;
	if (capture_band(capture_gangs[capture_id][0]) >= sizeof (capture_kills)) return;
	if (capture_band(capture_gangs[capture_id][1]) >= sizeof (capture_kills)) return;
	new kills[2];
	kills[0] = capture_kills[capture_band(capture_gangs[capture_id][0])];
	kills[1] = capture_kills[capture_band(capture_gangs[capture_id][1])];

	if (kills[0] < 1 || kills[1] < 1) {
		kills[0]++;
		kills[1]++;
	}
	new Float:progress = 94.0 / (kills[0] + kills[1]);
	TextDrawTextSize(CaptureStatsData_TD[capture_id][29], (kills[0] * progress), 6.000000);

	foreach(new playerid: PlayerTeam[capture_gangs[capture_id][0]]) {
		dmg = CaptureInfo[playerid][pDMG];
		if (!dmg) continue;

		if (pInfo[playerid][pMember] == capture_gangs[capture_id][0] && (idx[0] + 1) < sizeof (attack_players)) {
			attack_players[idx[0]][0] = playerid;
			attack_players[idx[0]++][1] = floatround(dmg);
		}
	}
	foreach(new playerid: PlayerTeam[capture_gangs[capture_id][1]]) { 
		dmg = CaptureInfo[playerid][pDMG];
		if (!dmg) continue;

		if (pInfo[playerid][pMember] == capture_gangs[capture_id][1] && (idx[1] + 1) < sizeof (defend_players)) {
			defend_players[idx[1]][0] = playerid;
			defend_players[idx[1]++][1] = floatround(dmg);
		}
	}
	/*foreach (new playerid: PlayerInLogin) {
		if (!IsAGang(playerid)) 
			continue;
		dmg = CaptureInfo[playerid][pDMG];
		if (!dmg) continue;

		if (pInfo[playerid][pMember] == capture_gangs[capture_id][0] && (idx[0] + 1) < sizeof (attack_players)) {
			attack_players[idx[0]][0] = playerid;
			attack_players[idx[0]++][1] = floatround(dmg);
		}
		else if (pInfo[playerid][pMember] == capture_gangs[capture_id][1] && (idx[1] + 1) < sizeof (defend_players)) {
			defend_players[idx[1]][0] = playerid;
			defend_players[idx[1]++][1] = floatround(dmg);
		}
		else continue;
	}*/
	SortDeepArray(attack_players, 1, .order = SORT_DESC);
	SortDeepArray(defend_players, 1, .order = SORT_DESC);

	for (new i = 0, playerid, deaths; i < MAX_CAPTURE_STATS_PLAYERS; i++) {
		// gang id #1
		if (!attack_players[i][1]) {
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 0], "__");
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + 0], "__");
		} else {
			playerid = attack_players[i][0];
			
			format(t_string, sizeof (t_string), "__%s", pInfo[playerid][pName]);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 0], t_string);
			 
			deaths = CaptureInfo[playerid][pDeaths];
			if (deaths < 1) deaths = 1;
		
			format(t_string, sizeof (t_string), "%03d___%05d_____%03d_____%.1f",
				CaptureInfo[playerid][pKills], attack_players[i][1], CaptureInfo[playerid][pDeaths], 
				Float:(1.0 * CaptureInfo[playerid][pKills] / deaths)
			);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + 0], t_string);
		}

		// gang id #2
		if (!defend_players[i][1]) {
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + MAX_CAPTURE_STATS_PLAYERS], "__");
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + MAX_CAPTURE_STATS_PLAYERS], "__");
		} else {
			playerid = defend_players[i][0];
			
			format(t_string, sizeof (t_string), "__%s", pInfo[playerid][pName]);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + MAX_CAPTURE_STATS_PLAYERS], t_string);
			 
			deaths = CaptureInfo[playerid][pDeaths];
			if (deaths < 1) deaths = 1;
		
			format(t_string, sizeof (t_string), "%03d___%05d_____%03d_____%.1f",
				CaptureInfo[playerid][pKills], defend_players[i][1], CaptureInfo[playerid][pDeaths], 
				Float:(1.0 * CaptureInfo[playerid][pKills] / deaths)
			);
			TextDrawSetString(CaptureStatsData_TD[capture_id][i + 14 + MAX_CAPTURE_STATS_PLAYERS], t_string);
		}
	}
	t_string[0] = EOS;
}

stock CreateCaptureStats_TD() {
	for (new i = 0; i < max_war_capture; i++) {
		capture_band_captureid[i] = -1;
		if (i >= 2) continue;
		captureid_slots[i] = 0;
		capture_gangs[i][0] = 0;
		capture_gangs[i][1] = 0;

	}
	CaptureStatsGUI_TD[0] = TextDrawCreate(450.100006, 120.918647, "LD_BEAT:chit");
	CaptureStatsGUI_TD[1] = TextDrawCreate(166.000000, 120.918647, "LD_BEAT:chit");
	CaptureStatsGUI_TD[2] = TextDrawCreate(450.100006, 330.881622, "LD_BEAT:chit");
	CaptureStatsGUI_TD[3] = TextDrawCreate(166.000000, 330.881622, "LD_BEAT:chit");

	CaptureStatsGUI_TD[4] = TextDrawCreate(170.000000, 134.296203, "LD_SPAC:white");
	TextDrawTextSize(CaptureStatsGUI_TD[4], 300.000000, 208.000000);
	TextDrawAlignment(CaptureStatsGUI_TD[4], 1);
	TextDrawColor(CaptureStatsGUI_TD[4], COLOR_SERVER);
	TextDrawSetShadow(CaptureStatsGUI_TD[4], 0);
	TextDrawBackgroundColor(CaptureStatsGUI_TD[4], 255);
	TextDrawFont(CaptureStatsGUI_TD[4], 4);
	TextDrawSetProportional(CaptureStatsGUI_TD[4], 0);

	CaptureStatsGUI_TD[5] = TextDrawCreate(170.000000, 138.196441, "LD_SPAC:white");
	TextDrawTextSize(CaptureStatsGUI_TD[5], 300.000000, 200.000000);
	TextDrawAlignment(CaptureStatsGUI_TD[5], 1);
	TextDrawColor(CaptureStatsGUI_TD[5], 0x191919FF/*421075306*/);
	TextDrawSetShadow(CaptureStatsGUI_TD[5], 0);
	TextDrawBackgroundColor(CaptureStatsGUI_TD[5], 255);
	TextDrawFont(CaptureStatsGUI_TD[5], 4);
	TextDrawSetProportional(CaptureStatsGUI_TD[5], 0);

	CaptureStatsGUI_TD[6] = TextDrawCreate(177.166717, 124.762962, "LD_SPAC:white");
	CaptureStatsGUI_TD[7] = TextDrawCreate(177.166717, 338.911071, "LD_SPAC:white");

	CaptureStatsGUI_TD[8] = TextDrawCreate(171.666641, 133.740707, "particle:lamp_shad_64");
	TextDrawTextSize(CaptureStatsGUI_TD[8], 300.000000, 96.000000);
	CaptureStatsGUI_TD[9] = TextDrawCreate(171.666641, 347.888885, "particle:lamp_shad_64");
	TextDrawTextSize(CaptureStatsGUI_TD[9], 300.000000, -100.000000);

	CaptureStatsGUI_TD[15] = TextDrawCreate(372.083404, 237.185272, "right_gray_box");
	TextDrawLetterSize(CaptureStatsGUI_TD[15], 0.000000, 1.000000);
	TextDrawTextSize(CaptureStatsGUI_TD[15], 465.000000, 0.000000);
	TextDrawAlignment(CaptureStatsGUI_TD[15], 1);
	TextDrawColor(CaptureStatsGUI_TD[15], -1);
	TextDrawUseBox(CaptureStatsGUI_TD[15], 1);
	TextDrawBoxColor(CaptureStatsGUI_TD[15], -2139062222);
	TextDrawSetShadow(CaptureStatsGUI_TD[15], 0);
	TextDrawBackgroundColor(CaptureStatsGUI_TD[15], 0);
	TextDrawFont(CaptureStatsGUI_TD[15], 1);
	TextDrawSetProportional(CaptureStatsGUI_TD[15], 1);

	CaptureStatsGUI_TD[10] = TextDrawCreate(333.750030, 126.740699, "KILLS");
	CaptureStatsGUI_TD[11] = TextDrawCreate(364.999969, 126.740699, "DAMAGE");
	CaptureStatsGUI_TD[12] = TextDrawCreate(404.999908, 126.740699, "DEATHS");
	CaptureStatsGUI_TD[13] = TextDrawCreate(447.500030, 126.740699, "K / D");

	CaptureStatsGUI_TD[14] = TextDrawCreate(320.000000, 339.333312, "PRESS \"N\" TO CLOSE");
	TextDrawLetterSize(CaptureStatsGUI_TD[14], 0.167500, 0.998519);
	TextDrawTextSize(CaptureStatsGUI_TD[14], 0.000000, 188.000000);
	TextDrawAlignment(CaptureStatsGUI_TD[14], 2);
	TextDrawColor(CaptureStatsGUI_TD[14], 255);
	TextDrawSetShadow(CaptureStatsGUI_TD[14], 0);
	TextDrawBackgroundColor(CaptureStatsGUI_TD[14], 255);
	TextDrawFont(CaptureStatsGUI_TD[14], 2);
	TextDrawSetProportional(CaptureStatsGUI_TD[14], 1);

	for (new i = 0; i < 4; i++) {
		// "LD_BEAT:chit"
		TextDrawTextSize(CaptureStatsGUI_TD[i + 0], 24.000000, 24.000000);
		TextDrawAlignment(CaptureStatsGUI_TD[i + 0], 1);
		TextDrawColor(CaptureStatsGUI_TD[i + 0], COLOR_SERVER);
		TextDrawSetShadow(CaptureStatsGUI_TD[i + 0], 0);
		TextDrawBackgroundColor(CaptureStatsGUI_TD[i + 0], 255);
		TextDrawFont(CaptureStatsGUI_TD[i + 0], 4);
		TextDrawSetProportional(CaptureStatsGUI_TD[i + 0], 0);
		// "KILLS"__"DAMAGE"__"DEATHS"__"K / D"
		TextDrawLetterSize(CaptureStatsGUI_TD[i + 10], 0.167500, 0.998519);
		TextDrawAlignment(CaptureStatsGUI_TD[i + 10], 1);
		TextDrawColor(CaptureStatsGUI_TD[i + 10], 255);
		TextDrawSetShadow(CaptureStatsGUI_TD[i + 10], 0);
		TextDrawBackgroundColor(CaptureStatsGUI_TD[i + 10], 255);
		TextDrawFont(CaptureStatsGUI_TD[i + 10], 2);
		TextDrawSetProportional(CaptureStatsGUI_TD[i + 10], 1);
		if (i >= 2) continue;
		// "LD_SPAC:white"
		TextDrawTextSize(CaptureStatsGUI_TD[i + 6], 286.000000, 12.000000);
		TextDrawAlignment(CaptureStatsGUI_TD[i + 6], 1);
		TextDrawColor(CaptureStatsGUI_TD[i + 6], COLOR_SERVER);
		TextDrawSetShadow(CaptureStatsGUI_TD[i + 6], 0);
		TextDrawBackgroundColor(CaptureStatsGUI_TD[i + 6], 255);
		TextDrawFont(CaptureStatsGUI_TD[i + 6], 4);
		TextDrawSetProportional(CaptureStatsGUI_TD[i + 6], 0);
		// "particle:lamp_shad_64"
		TextDrawAlignment(CaptureStatsGUI_TD[i + 8], 1);
		TextDrawColor(CaptureStatsGUI_TD[i + 8], -224);
		TextDrawSetShadow(CaptureStatsGUI_TD[i + 8], 0);
		TextDrawBackgroundColor(CaptureStatsGUI_TD[i + 8], 255);
		TextDrawFont(CaptureStatsGUI_TD[i + 8], 4);
		TextDrawSetProportional(CaptureStatsGUI_TD[i + 8], 0);
	}
	for (new capture_id = 0; capture_id < MAX_WAR_CAPTURE_SAMETIME; capture_id++) {
		// "Nick_Name"
		CaptureStatsData_TD[capture_id][0] = TextDrawCreate(175.416702, 145.388916, "__");
		CaptureStatsData_TD[capture_id][1] = TextDrawCreate(175.416702, 157.333358, "__");
		CaptureStatsData_TD[capture_id][2] = TextDrawCreate(175.416702, 169.259277, "__");
		CaptureStatsData_TD[capture_id][3] = TextDrawCreate(175.416702, 181.185211, "__");
		CaptureStatsData_TD[capture_id][4] = TextDrawCreate(175.416702, 193.111145, "__");
		CaptureStatsData_TD[capture_id][5] = TextDrawCreate(175.416702, 205.037094, "__");
		CaptureStatsData_TD[capture_id][6] = TextDrawCreate(175.416702, 216.963027, "__");
		CaptureStatsData_TD[capture_id][7] = TextDrawCreate(175.416702, 251.185317, "__");
		CaptureStatsData_TD[capture_id][8] = TextDrawCreate(175.416702, 263.111328, "__");
		CaptureStatsData_TD[capture_id][9] = TextDrawCreate(175.416702, 275.037261, "__");
		CaptureStatsData_TD[capture_id][10] = TextDrawCreate(175.416702, 286.963226, "__");
		CaptureStatsData_TD[capture_id][11] = TextDrawCreate(175.416702, 298.889160, "__");
		CaptureStatsData_TD[capture_id][12] = TextDrawCreate(175.416702, 310.815155, "__");
		CaptureStatsData_TD[capture_id][13] = TextDrawCreate(175.416702, 322.741088, "__");
		// "000____0000_____000_____0"
		CaptureStatsData_TD[capture_id][14] = TextDrawCreate(462.083404, 144.388916, "__");
		CaptureStatsData_TD[capture_id][15] = TextDrawCreate(462.083404, 157.333358, "__");
		CaptureStatsData_TD[capture_id][16] = TextDrawCreate(462.083404, 169.259277, "__");
		CaptureStatsData_TD[capture_id][17] = TextDrawCreate(462.083404, 181.185211, "__");
		CaptureStatsData_TD[capture_id][18] = TextDrawCreate(462.083404, 193.111145, "__");
		CaptureStatsData_TD[capture_id][19] = TextDrawCreate(462.083404, 205.037094, "__");
		CaptureStatsData_TD[capture_id][20] = TextDrawCreate(462.083404, 216.963027, "__");
		CaptureStatsData_TD[capture_id][21] = TextDrawCreate(462.083404, 251.185317, "__");
		CaptureStatsData_TD[capture_id][22] = TextDrawCreate(462.083404, 263.111328, "__");
		CaptureStatsData_TD[capture_id][23] = TextDrawCreate(462.083404, 275.037261, "__");
		CaptureStatsData_TD[capture_id][24] = TextDrawCreate(462.083404, 286.963226, "__");
		CaptureStatsData_TD[capture_id][25] = TextDrawCreate(462.083404, 298.889160, "__");
		CaptureStatsData_TD[capture_id][26] = TextDrawCreate(462.083404, 310.815155, "__");
		CaptureStatsData_TD[capture_id][27] = TextDrawCreate(462.083404, 322.741088, "__");

		CaptureStatsData_TD[capture_id][28] = TextDrawCreate(272.916656, 235.370330, "LD_SPAC:white"); // progress bar 1
		TextDrawTextSize(CaptureStatsData_TD[capture_id][28], 94.000000, 6.000000);
		TextDrawColor(CaptureStatsData_TD[capture_id][28], -2147450699);
		CaptureStatsData_TD[capture_id][29] = TextDrawCreate(272.916656, 235.370330, "LD_SPAC:white"); // progress bar 2
		TextDrawTextSize(CaptureStatsData_TD[capture_id][29], 47.000000, 6.000000);
		TextDrawColor(CaptureStatsData_TD[capture_id][29], 8388789);

		for (new i = 0; i < (MAX_CAPTURE_STATS_PLAYERS * 2); i++) {
			// "__GHETTO_TAWER"
			TextDrawLetterSize(CaptureStatsData_TD[capture_id][i + 0], 0.164166, 0.899999/*1.039999*/);
			TextDrawTextSize(CaptureStatsData_TD[capture_id][i + 0], 465.000000, 0.000000);
			TextDrawAlignment(CaptureStatsData_TD[capture_id][i + 0], 1);
			TextDrawColor(CaptureStatsData_TD[capture_id][i + 0], -1061109505);
			TextDrawUseBox(CaptureStatsData_TD[capture_id][i + 0], 1);
			TextDrawBoxColor(CaptureStatsData_TD[capture_id][i + 0], -5963703);
			TextDrawSetShadow(CaptureStatsData_TD[capture_id][i + 0], 0);
			TextDrawBackgroundColor(CaptureStatsData_TD[capture_id][i + 0], 255);
			TextDrawFont(CaptureStatsData_TD[capture_id][i + 0], 2);
			TextDrawSetProportional(CaptureStatsData_TD[capture_id][i + 0], 1);
			// "000____0000_____000_____0.0"
			TextDrawLetterSize(CaptureStatsData_TD[capture_id][i + 14], 0.173748, 0.899999/*1.003702*/);
			TextDrawTextSize(CaptureStatsData_TD[capture_id][i + 14], 465.000000, 0.000000);
			TextDrawAlignment(CaptureStatsData_TD[capture_id][i + 14], 3);
			TextDrawColor(CaptureStatsData_TD[capture_id][i + 14], -1061109505);
			TextDrawSetShadow(CaptureStatsData_TD[capture_id][i + 14], 0);
			TextDrawBackgroundColor(CaptureStatsData_TD[capture_id][i + 14], 255);
			TextDrawFont(CaptureStatsData_TD[capture_id][i + 14], 2);
			TextDrawSetProportional(CaptureStatsData_TD[capture_id][i + 14], 0);
			if (i >= 2) continue;
			TextDrawAlignment(CaptureStatsData_TD[capture_id][i + 28], 1);
			TextDrawSetShadow(CaptureStatsData_TD[capture_id][i + 28], 0);
			TextDrawBackgroundColor(CaptureStatsData_TD[capture_id][i + 28], 255);
			TextDrawFont(CaptureStatsData_TD[capture_id][i + 28], 4);
			TextDrawSetProportional(CaptureStatsData_TD[capture_id][i + 28], 0);
		}
		CaptureStatsData_TD[capture_id][30] = TextDrawCreate(175.416702, 231.481521, "__");
		TextDrawLetterSize(CaptureStatsData_TD[capture_id][30], 0.189162, 0.941479);
		TextDrawTextSize(CaptureStatsData_TD[capture_id][30], 267.000000, 0.000000);
		TextDrawAlignment(CaptureStatsData_TD[capture_id][30], 1);
		TextDrawColor(CaptureStatsData_TD[capture_id][30], 11206911);
		TextDrawUseBox(CaptureStatsData_TD[capture_id][30], 1);
		TextDrawBoxColor(CaptureStatsData_TD[capture_id][30], -2139062222);
		TextDrawSetShadow(CaptureStatsData_TD[capture_id][30], 0);
		TextDrawBackgroundColor(CaptureStatsData_TD[capture_id][30], 255);
		TextDrawFont(CaptureStatsData_TD[capture_id][30], 2);
		TextDrawSetProportional(CaptureStatsData_TD[capture_id][30], 1);

		CaptureStatsData_TD[capture_id][31] = TextDrawCreate(458.333312, 237.185180, "__");
		TextDrawLetterSize(CaptureStatsData_TD[capture_id][31], 0.189162, 0.941479);
		TextDrawTextSize(CaptureStatsData_TD[capture_id][31], 486.000000, 0.000000);
		TextDrawAlignment(CaptureStatsData_TD[capture_id][31], 3);
		TextDrawColor(CaptureStatsData_TD[capture_id][31], -902627329);
		TextDrawSetShadow(CaptureStatsData_TD[capture_id][31], 0);
		TextDrawBackgroundColor(CaptureStatsData_TD[capture_id][31], 255);
		TextDrawFont(CaptureStatsData_TD[capture_id][31], 2);
		TextDrawSetProportional(CaptureStatsData_TD[capture_id][31], 1);
	}
}
/*stock UpdatePlayerKillsCapture(playerid) {
	// 0000_0000_00000_1.0
	new deaths = CaptureInfo[playerid][pDeaths];
	if (deaths < 1) deaths = 1;
	
	format(t_string, sizeof (t_string), "%04d_%04d_%05d_%.1f",
		CaptureInfo[playerid][pKills], CaptureInfo[playerid][pDeaths], floatround(CaptureInfo[playerid][pDMG]), 
		Float:(1.0 * CaptureInfo[playerid][pKills] / deaths)
	);
	PlayerTextDrawSetString(playerid, CapturePTD[playerid], t_string), t_string[0] = EOS;
}9m1 napad 10m2 vlad*/

stock SetStringMainTextDrawMafiaWar()
{
    //new index = TYPE_WAR_MAFIA;
    new m1,m2,sr[12];
    m1 = mafia_frac_id[0];
    m2 = mafia_frac_id[1];

    TextDrawColor(CaptureTD[TYPE_WAR_MAFIA][9], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[TYPE_WAR_MAFIA][10], GetGangZoneColor2(m2));
    TextDrawColor(CaptureTD[TYPE_WAR_MAFIA][4], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[TYPE_WAR_MAFIA][7], GetGangZoneColor2(m2));

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m1)]);
    TextDrawSetString(CaptureTD[TYPE_WAR_MAFIA][9], sr);

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m2)]);
    TextDrawSetString(CaptureTD[TYPE_WAR_MAFIA][10], sr);

    return 1;
}
stock SetStringMainTextDrawBikersWar()
{ 
    new m1,m2,sr[12];
    m1 = bikers_frac_id[0];//-5963540;
    m2 = bikers_frac_id[1];

    TextDrawColor(CaptureTD[TYPE_WAR_BIKERS][9], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[TYPE_WAR_BIKERS][10], GetGangZoneColor2(m2));
    TextDrawColor(CaptureTD[TYPE_WAR_BIKERS][4], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[TYPE_WAR_BIKERS][7], GetGangZoneColor2(m2));

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m1)]);
    TextDrawSetString(CaptureTD[TYPE_WAR_BIKERS][9], sr);

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m2)]);
    TextDrawSetString(CaptureTD[TYPE_WAR_BIKERS][10], sr);	

    return 1;
}
stock UpdateKillsMafiaWar() {
	new sr[12];
    format(sr, sizeof(sr), "%d", capture_kills[capture_band(mafia_frac_id[0])]);
    TextDrawSetString(CaptureTD[TYPE_WAR_MAFIA][9], sr);

    format(sr, sizeof(sr), "%d", capture_kills[capture_band(mafia_frac_id[1])]);
    TextDrawSetString(CaptureTD[TYPE_WAR_MAFIA][10], sr);

	return 1;
}
stock UpdateKillsBikersWar() { 
	new sr[12];
    format(sr, sizeof(sr), "%d", capture_kills[capture_band(bikers_frac_id[0])]);
    TextDrawSetString(CaptureTD[TYPE_WAR_BIKERS][9], sr);

    format(sr, sizeof(sr), "%d", capture_kills[capture_band(bikers_frac_id[1])]);
    TextDrawSetString(CaptureTD[TYPE_WAR_BIKERS][10], sr);

	return 1;
}
stock UpdateMafiaWarSeconds()
{
    new str_time[32], str[64];
    Convert_GZ(ZoneTimer,str_time);
    format(str,sizeof(str),"%s",str_time);
    TextDrawSetString(CaptureTD[TYPE_WAR_MAFIA][3], str);
    return 1;
}
stock UpdateBikersWarSeconds()
{
    new str_time[32], str[64];
    Convert_GZ(BikersTimer,str_time);
    format(str,sizeof(str),"%s",str_time);
    TextDrawSetString(CaptureTD[TYPE_WAR_BIKERS][3], str);
    return 1;
}
stock SetStringMainTextDrawCapture(i)
{
    new index = GZInfo[i][gTD];
    new m1,m2,sr[12];
    m1 = GZInfo[i][gNapad];
    m2 = GZInfo[i][gFrakVlad];

    TextDrawColor(CaptureTD[index][9], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[index][10], GetGangZoneColor2(m2));
    TextDrawColor(CaptureTD[index][4], GetGangZoneColor2(m1));
    TextDrawColor(CaptureTD[index][7], GetGangZoneColor2(m2));	

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m1)]);
    TextDrawSetString(CaptureTD[index][9], sr);

    format(sr, sizeof(sr), "%d",capture_kills[capture_band(m2)]);
    TextDrawSetString(CaptureTD[index][10], sr);	

    return 1;
}