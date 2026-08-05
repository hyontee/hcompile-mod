#if defined _quests_included
	#endinput
#endif
#define _quests_included

#if defined _quests_included
	#define MAX_QUESTS_ACTOR 3
#endif
#define QUEST_CLUB_CODE			2808
#define MAX_QUEST_FIRE_OBJECTS	6

enum FIRE_E {
	fireObjectID[MAX_QUEST_FIRE_OBJECTS],
	fireStopObjectID[MAX_QUEST_FIRE_OBJECTS],
	fireProcess[MAX_QUEST_FIRE_OBJECTS],
	fireAreaID[MAX_QUEST_FIRE_OBJECTS],
}
new quests_FireObjects[MAX_PLAYERS][FIRE_E];

new Float:FireObjectPosition[MAX_QUEST_FIRE_OBJECTS][3] = {
	{-2821.109912, -1518.637131, 140.84},
	{-2820.475341, -1527.655517, 140.76},
	{-2820.475341, -1522.315551, 140.76},
	{-2815.973632, -1529.564819, 140.76},
	{-2819.184082, -1515.856201, 140.76},
	{-2812.883544, -1516.806640, 140.76}
	// {-2820.845703, -1518.884521, 140.76},
	// {-2821.496337, -1518.963378, 140.76}
};
enum quests_PLAYER_E {
	pBotTextTimer,
	Text3D:pBotText,
	pDialogStart,
	pMissionPassedTD,
	pMissionPassedTimer,
	pActorID[3],
	pQuestTimer,
	pPlaneObjectID,
	pCopObjectID,
	pAirplaneObjectID[22],
	pBoatSpawnID,
}
new quests_PI[MAX_PLAYERS][quests_PLAYER_E], quests_AreaID[5], quests_ActorsID[7];

enum {
	QUESTS_TYPE_MASON = 1,

	QUESTS_TYPE_BOSS,
	QUESTS_TYPE_RICHARD,
}
enum quests_ACTOR_E {
	questsName[24],
	questsSkin,
	questsVirtualWorldID,
	questsInteriorID,
	Float:questsPosition[4],
	questsType,

	Text3D:questsTextID,
	questsAreaID,
	questsActorID,
	questsCheckpointID,
	questsAnimation,
}
static quests_ActorsInfo[MAX_QUESTS_ACTOR][quests_ACTOR_E] = {
	{"Mason", 2, 0, 0, {1771.88, -1888.68, 13.56, 175.0}, QUESTS_TYPE_MASON},
	{"Richard", 179, 0, 0, {2336.4036, -1189.2058, 28.0621, 162.0246}, QUESTS_TYPE_RICHARD},
	{"Boss", 113, 1, 8, {-2829.4619, 1063.3688, 948.8719, 331.448}, QUESTS_TYPE_BOSS}
};
#define MAX_QUESTS_MASON			8
#define QUEST_MASON_MAKEGUN_COUNT	20

#define MAX_QUEST_VEHICLE			5
#define MAX_QUEST_VEHICLE_OBJECT	11

enum quests_VDE {
	qvVehicleID,
	Float:qvSpawnPos[4],
	qvObjectID[MAX_QUEST_VEHICLE_OBJECT],
};
new quests_VehicleData[MAX_QUEST_VEHICLE][quests_VDE] = {
	{INVALID_VEHICLE_ID, {-445.2313, -1885.1560, -0.4873, 290.0856}}, 
	{INVALID_VEHICLE_ID, {-364.3203, -1863.4431, -0.3031, 268.9265}}, 
	{INVALID_VEHICLE_ID, {-404.2647, -1848.7836, -0.1801, 284.9789}}, 
	{INVALID_VEHICLE_ID, {-348.9821, -1841.7529, -0.4425, 272.9229}}, 
	{INVALID_VEHICLE_ID, {92.458900, -1699.7040, -0.2691, 175.0776}}
};

static const Float:AttacObjectBoatPos[MAX_QUEST_VEHICLE_OBJECT][6] = {
	{-0.070, -3.693, 0.899, 0.000, 0.000, 0.000},
	{-0.850, -3.681, 0.899, 0.000, 0.000, 0.000},
	{0.800, -3.692, 0.879, 0.000, 0.000, 0.000},
	{0.000, -3.251, 0.899, 0.000, 0.000, 0.000},
	{0.760, -3.243, 0.889, 0.000, 0.000, 0.000},
	{-0.730, -3.252, 0.899, 0.000, 0.000, 0.000},
	{0.730, -3.462, 1.069, 0.000, 0.000, 0.000},
	{0.000, -3.492, 1.119, 0.000, 0.000, -9.599},
	{-0.750, -3.542, 1.099, 0.000, 0.000, 0.000},
	{0.000, -3.490, 1.369, 0.000, 0.000, 9.299},

	{-0.031, -2.472, 0.701, 0.000, 90.600, 0.999}
};

enum QUESTS_INFO_E {
	questsName[32],
	questsMoney,
	questsEXP,
	questsHELP[256]
};
static PlayerText:MissionPassedPTD[MAX_PLAYERS][2], Text:MissionLineTD[3];

#define QUESTS_AWARD_MONEY_1	150
#define QUESTS_AWARD_MONEY_2	280
#define QUESTS_AWARD_MONEY_3	210
#define QUESTS_AWARD_MONEY_4	200
#define QUESTS_AWARD_MONEY_5	210
#define QUESTS_AWARD_MONEY_6	260
#define QUESTS_AWARD_MONEY_7	230
#define QUESTS_AWARD_MONEY_8	210


static const quests_mason_info[MAX_QUESTS_MASON][QUESTS_INFO_E] = {
	{/* (1) */"Водительские права", QUESTS_AWARD_MONEY_1/* ($) */, 1/* (EXP) */, "Отправляйтесь в автошколу и получите водительские права"},
	{/* (2) */"Собери оружие", QUESTS_AWARD_MONEY_2/* ($) */, 1/* (EXP) */, "Отправляйтесь на оружейный завод и соберите 20 заготовок."},
	{/* (3) */"Всё, что осталось", QUESTS_AWARD_MONEY_3/* ($) */, 1/* (EXP) */, "Отправляйтесь на гору Чиллиад, найдите там старый домик и спасите брата Мэйсона - Томми."},
	{/* (4) */"Деньги или правосудие?", QUESTS_AWARD_MONEY_4/* ($) */, 1/* (EXP) */,
		"Сначала купите фотоаппарат к магазине 24/7, затем отправляйтесь к полицейскому участку Лос Сантос,\n\
		\t\t\tнайдите преступников и соберите (сфотографируйте) на них компромат. Передайте компромат Мэйсону."
	},
	{/* (5) */"Сбор наркотиков", QUESTS_AWARD_MONEY_5/* ($) */, 1/* (EXP) */, "Отправляйтесь к заброшенному аэропорту и проникните в самолет.\n\
		\t\t\tУспейте собрать наркотики и спрыгнуть из самолета на парашуте, отвезите их Мэйсону."},
	{/* (6) */"Свой среди чужих", QUESTS_AWARD_MONEY_6/* ($) */, 1/* (EXP) */, ""},
	{/* (7) */"Под чужим именем", QUESTS_AWARD_MONEY_7/* ($) */, 1/* (EXP) */, ""},
	{/* (8) */"Залечь на дно", QUESTS_AWARD_MONEY_8/* ($) */, 1/* (EXP) */, ""}
};

quests_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new bool:return_value = false;

	if (
		PI[playerid][pQuestCurrentID] == 5 && PI[playerid][pQuestProcess_Mason][4] == 3 &&
		GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)
	) {
		new Float:objectPos[3];
		GetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][12], objectPos[0], objectPos[1], objectPos[2]);

		if (IsPlayerInRangeOfPoint(playerid, 1.75, objectPos[0], objectPos[1], objectPos[2])) {
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 1, 1, 1, 1);
			PI[playerid][pQuestProcess_Mason][4] = 4;
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отлично! Отвезите собранную наркоту Мэйсону.");
			DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][12]);
			quests_PI[playerid][pAirplaneObjectID][12] = -1;
			return true;
		}
		// PI[playerid][pQuestProcess_Mason][4] = 3;
	}
	if (
		IsPlayerInRangeOfPoint(playerid, 1.75, 1034.5073, -1348.8934, 14.6285) && 
		GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)
	) {
		ShowPlayerDialog(playerid, D_QUESTS_6, DIALOG_STYLE_INPUT, ""P"Вход в клуб", ""W"Введите ключевой код, чтобы попасть в клуб:", "Принять", "Отмена");
		return true;
	}
	if (
		IsPlayerInRangeOfPoint(playerid, 50.0, 1638.25, -1665.44, 13.57) &&
		(newkeys & 132 && oldkeys & KEY_HANDBRAKE) &&
		PI[playerid][pQuestCurrentID] == 4 && PI[playerid][pQuestProcess_Mason][3] == 2 &&
		GetPlayerWeapon(playerid) == 43
	) {
		SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отлично! Отправляйтесь к Мэйсону и передайте ему собранный компромат.");
		PI[playerid][pQuestProcess_Mason][3] = 3;
		return true;
	}
	if (
		PI[playerid][pQuestCurrentID] == 3 && (PI[playerid][pQuestProcess_Mason][2] == 3) &&
		IsPlayerInRangeOfPoint(playerid, 1.5, -2813.9812, -1513.9934, 139.2891) &&
		GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)
	) {
		PI[playerid][pQuestProcess_Mason][2] = 4;
		SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Начинайте скорее тушить огонь!");
		
		AC_GivePlayerWeapon(playerid, 42, 30000);
		return true;
	}
	if (!quests_PI[playerid][pDialogStart] && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_WALK) && !(oldkeys & KEY_WALK)) {
		for(new actor_id = 0; actor_id < MAX_QUESTS_ACTOR; actor_id++) {
			if (!IsPlayerInRangeOfPoint(playerid, 1.75, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1], quests_ActorsInfo[actor_id][questsPosition][2]))
				continue;
			// if (GetPlayerVirtualWorld(playerid) != quests_ActorsInfo[actor_id][questsVirtualWorldID]) continue;
			SetPVarInt(playerid, "quests_ActorID", actor_id);

			quests_ActionBot(playerid);
			return_value = true;
		}
	}
	return return_value;
}
stock GetPlayerQuestCompleted(playerid, type = QUESTS_TYPE_MASON) {
	new amount = 0;

	switch(type) {
		case QUESTS_TYPE_MASON: for(new questid = 0; questid < MAX_QUESTS_MASON; questid++) if (PI[playerid][pQuestStatus_Mason][questid]) amount++;
	}
	return amount;
}
quest_OnPlayerComplete(playerid, type, questid) {
	switch(type) {
		case QUESTS_TYPE_MASON: {
			switch(questid) {
				case 1: {
					if (0 == GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON) && PI[playerid][pQuestCurrentID] == questid) {
						PI[playerid][pQuestProcess_Mason][(questid - 1)] = 1;
						SendClientMessage(playerid, CGOLD,
							""P"[Квестовая линия] "G"Вы успешно выполнили задание от Мэйсона, отправлятесь к нему и поговорите."
						);
					}
				}
				case 2: {
					if (1 == GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON) && PI[playerid][pQuestCurrentID] == questid) {
						PI[playerid][pQuestProcess_Mason][(questid - 1)] = 20;
						SendClientMessage(playerid, CGOLD,
							""P"[Квестовая линия] "G"Вы успешно выполнили задание от Мэйсона, отправлятесь к нему и поговорите."
						);
					}
				}
			}
		}
	}
	return true;
}
stock quests_SendMessage(playerid, const text[], messageid = 0, time = 3500) {
	if (!TI[playerid][tLogin])
		return false;
	new actor_id = GetPVarInt(playerid, "quests_ActorID");

	SetDynamicActorPos(quests_ActorsInfo[actor_id][questsActorID],
		quests_ActorsInfo[actor_id][questsPosition][0],
		quests_ActorsInfo[actor_id][questsPosition][1],
		quests_ActorsInfo[actor_id][questsPosition][2]
	);
	format(STRING_GLOBAL, 144, "- "P"%s: "W"%s", quests_ActorsInfo[actor_id][questsName], text);
	if (strlen(text) > 4) SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

	if (0 == quests_ActorsInfo[actor_id][questsAnimation] && strlen(text) > 4) {
		ApplyDynamicActorAnimation(quests_ActorsInfo[actor_id][questsActorID], "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);
		SetTimerEx("OnActorClearAnimText", (time - 500), false, "d", actor_id);
		quests_ActorsInfo[actor_id][questsAnimation] = 1;
	}
	if (GetPVarInt(playerid, "quests_BotMessage")) {
		if (quests_PI[playerid][pBotTextTimer] != (-1)) {
			KillTimer(quests_PI[playerid][pBotTextTimer]);
			printf("[KillTimer 34] quests_PI[playerid][pBotTextTimer] = '%d' killed", 
				quests_PI[playerid][pBotTextTimer]
			);
			quests_PI[playerid][pBotTextTimer] = (-1);
		}
		quests_PI[playerid][pBotTextTimer] = SetTimerEx("quests_StopMessage", time, false, "ii", playerid, messageid);
		UpdateDynamic3DTextLabelText(quests_PI[playerid][pBotText], 0xFFFFFFFF, text);
	}
	else {
		quests_PI[playerid][pBotText] = CreateDynamic3DTextLabel(text, 0xFFFFFFFF,
			quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1],
			quests_ActorsInfo[actor_id][questsPosition][2] + 1.2, 7.5, INVALID_PLAYER_ID, INVALID_PLAYER_ID, 0,
			GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid
		);
		quests_PI[playerid][pBotTextTimer] = SetTimerEx("quests_StopMessage", time, false, "ii", playerid, messageid);

		SetPVarInt(playerid, "quests_BotMessage", 1);
	}
	Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);

	return true;
}
stock quests_ApplyChatAnimation(playerid) {
	ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);

	PlayerChatFix[playerid] = (GetTickCount() + (100 * 40)), PlayerChatExFix[playerid] = 1;
}
forward quests_BoatMissionTimer(playerid, type);
public quests_BoatMissionTimer(playerid, type) {
	if (!IsPlayerConnected(playerid) || !TI[playerid][tLogin])
		return;
	switch(type) {
		case 0: {
			for(new td_id = 0; td_id < sizeof(MissionLineTD); td_id++)
				TextDrawShowForPlayer(playerid, MissionLineTD[td_id]);
			TogglePlayerControllable(playerid, false);
			
			SetTimerEx("quests_BoatMissionTimer", 1500, false, "ii", playerid, 1);
		}
		case 1: {
			TextDrawHideForPlayer(playerid, MissionLineTD[2]);

			new virtualworld = 0, interior = 0, Float:playerPos[3];
			GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
			SetPlayerPosAC(playerid, playerPos[0], playerPos[1], playerPos[2] + 0.1, virtualworld, interior);
			
			InterpolateCameraPos(playerid, 535.485, -2403.343, 16.291, 598.006, -2429.867, 16.254, 4000);
			InterpolateCameraLookAt(playerid, 535.417, -2408.202, 15.114, 593.786, -2432.250, 15.024, 4000);

			SetTimerEx("quests_BoatMissionTimer", 4500, false, "ii", playerid, 2);
		}
		case 2: {
			PI[playerid][pQuestProcess_Mason][5] = 4;

			if (quests_PI[playerid][pBoatSpawnID]) {
				//new boat_vehicleid = quests_VehicleData[quests_PI[playerid][pBoatSpawnID] - 1][qvVehicleID];

				for(new i = 0; i < MAX_QUEST_VEHICLE_OBJECT; i++) {
					DestroyDynamicObject(quests_VehicleData[quests_PI[playerid][pBoatSpawnID] - 1][qvObjectID][i]);
				}
				A_DestroyVehicle(quests_VehicleData[quests_PI[playerid][pBoatSpawnID] - 1][qvVehicleID]);
				quests_VehicleData[quests_PI[playerid][pBoatSpawnID] - 1][qvVehicleID] = INVALID_VEHICLE_ID;

				quests_PI[playerid][pBoatSpawnID] = 0;
			}
			// (453,166.3829,-1904.4010,-0.3454,357.9918,56,56); // 
			new virtualworld = 100, interior = 0;
			SetPlayerPosAC(playerid, 147.0985, -1950.4487, 3.7734, virtualworld, interior);

			InterpolateCameraPos(playerid, 227.264, -1959.534, 16.848, 208.925, -1890.974, 10.696, 4000);
			InterpolateCameraLookAt(playerid, 223.156, -1956.918, 15.715, 204.258, -1892.394, 9.598, 4000);

			SetTimerEx("quests_BoatMissionTimer", 4500, false, "ii", playerid, 3);
		}
		case 3: {

			for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
				TextDrawHideForPlayer(playerid, MissionLineTD[td_id]);
			new virtualworld = 0, interior = 0, Float:playerPos[3];
			GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
			SetPlayerPosAC(playerid, playerPos[0], playerPos[1], playerPos[2] + 0.05, virtualworld, interior);
			PI[playerid][pQuestProcess_Mason][5] = 4;

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			SendOk(playerid, "Поздравляем, квест успешно пройдет!");
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в Мэйсону, для завершения задания.");
		}
	}
}
forward quests_StopMessage(playerid, messageid);
public quests_StopMessage(playerid, messageid) {
	if (!IsPlayerConnected(playerid) || !TI[playerid][tLogin])
		return 0;
	if (1 == GetPVarInt(playerid, "quests_BotMessage")) {
		DestroyDynamic3DTextLabel(Text3D:quests_PI[playerid][pBotText]);
		DeletePVar(playerid, "quests_BotMessage");
	}
	new actor_id = GetPVarInt(playerid, "quests_ActorID");
	#pragma unused actor_id

	switch(messageid) {
		case 1: {
			format(STRING_GLOBAL, 144, "- Привет! Очень приятно, меня звать %s. {%s}(%s) [%d]",
				player_name[playerid], GetColor(playerid), player_name[playerid], playerid
			);
			SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

			quests_ApplyChatAnimation(playerid), quests_SendMessage(playerid, " ", 2, 3000);
		}
		case 2: quests_SendMessage(playerid, "Рад тебя видеть в нашем городе, наконец-то ты перебрался к нам.", 3, 4000);
		case 3: quests_SendMessage(playerid, "Мне понадобится во многом твоя помощь.", 4, 3000);
		case 4: quests_SendMessage(playerid, "Но для начала хотел бы узнать: у тебя есть права?", 5, 3500);
		case 5: {
			if (!lic[playerid][0])
				format(STRING_GLOBAL, 144, "- К сожалению, пока нет. {%s}(%s) [%d]", GetColor(playerid), player_name[playerid], playerid);
			else format(STRING_GLOBAL, 144, "- Да, у меня есть права. {%s}(%s) [%d]", GetColor(playerid), player_name[playerid], playerid);

			SendClientMessage(playerid, 0xFFFFFFFF, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

			quests_ApplyChatAnimation(playerid), quests_SendMessage(playerid, " ", 6, 3000);
		}
		case 6: {
			if (!lic[playerid][0])
				quests_SendMessage(playerid, "Нет? Тогда отправляйся в автошколу и получи их.", 7, 2000);
			else {
				PI[playerid][pQuestStatus_Mason][0] = 1;
				SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Задание было засчитано как \"выполненное\", продолжайте диалог.");

				SetCameraBehindPlayer(playerid);
				TogglePlayerControllable(playerid, true);

				quests_PI[playerid][pDialogStart] = 0;
				PI[playerid][pQuestCurrentID] = 1;
			}
		}
		case 7: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 747.1273, -1390.9849, 13.4882);
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в автошколу, которая помечена "R"красной меткой "G"на радаре.");

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;
			PI[playerid][pQuestProcess_Mason][0] = 0;
			PI[playerid][pQuestCurrentID] = 1;
		}
		case 8: {
			quests_SendMessage(playerid, "Держи, возмещаю!", 0, 1500);
			quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_1, 1);

			GiveMoney(playerid, QUESTS_AWARD_MONEY_1, "от Мэйсона (1)");
			UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 1));

			if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
				PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
				PI[playerid][pLevel] += 1;
				DollahScoreUpdate(playerid);
				SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

				if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
					GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
				}
			}
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestStatus_Mason][0] = 1;
		}
		case 9: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 2675.6917, -2405.5618, 13.4675);

			quests_SendMessage(playerid, "Отправляйся на оружейный завод и собери 20 заготовок.", 0, 3000);
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь на оружейный завод, который помечен "R"красной меткой "G"на радаре.");

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][1] = 0;
			PI[playerid][pQuestCurrentID] = 2;
		}
		case 10: {
			quests_SendMessage(playerid, "Дальше ждет крупное дело, оружие скоро будет готово.", 0, 3000);
			quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_2, 1);

			GiveMoney(playerid, QUESTS_AWARD_MONEY_2, "от Мэйсона (2)");
			UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 1));

			if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
				PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
				PI[playerid][pLevel] += 1;
				DollahScoreUpdate(playerid);
				SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

				if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
					GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
				}
			}
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestStatus_Mason][1] = 1;
		}
		case 11: {
			quests_SendMessage(playerid, "Держи, ты заработал. ", 0, 2500);
			quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_3, 1);

			GiveMoney(playerid, QUESTS_AWARD_MONEY_3, "от Мэйсона (3)");
			UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 1));

			if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
				PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
				PI[playerid][pLevel] += 1;
				DollahScoreUpdate(playerid);
				SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

				if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
					GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
				}
			}
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestStatus_Mason][2] = 1;
		}
		case 12: quests_SendMessage(playerid, "Тебе срочно нужно отыскать его по следам крови.", 13, 3500);
		case 13: quests_SendMessage(playerid, "Последний раз его видели около горы Чиллиад. ", 14, 3500);
		case 14: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, -2820.845703, -1518.884521, 140.76 - 4.0, 15.0);

			quests_PI[playerid][pActorID][0] = CreateDynamicActor(47, -2831.9102, -1513.2188, 138.8774, 252.9075, true, 100.0, -1, 0, playerid);
			quests_PI[playerid][pActorID][1] = CreateDynamicActor(48, -2832.2974, -1526.8118, 138.9348, 283.0295, true, 100.0, -1, 0, playerid);

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][2] = 1;
			PI[playerid][pQuestCurrentID] = 3;

			quests_SendMessage(playerid, "Арендуй машину и гони.", 0, 2000);
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь "NO"на гору Чилиад"G", которая помечена "R"красной меткой "G"на радаре.");
		}
		case 18: quests_SendMessage(playerid, "Отыщи этих мразей за участком Los Santos, и собери на них компромат.", 19, 4000);
		case 19: quests_SendMessage(playerid, "Не забудь купить фотоаппарат и будь осторожен.", 20, 2000);
		case 20: {
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в магазин 24/7 и купите "NO"фотоаппарат"G".");

			quests_PI[playerid][pActorID][0] = CreateDynamicActor(267, 1638.13, -1663.36, 13.573, 180.3, false, 50.0, 0, 0, playerid);
			quests_PI[playerid][pActorID][1] = CreateDynamicActor(47, 1638.250, -1665.44, 13.573, 5.000, false, 50.0, 0, 0, playerid);

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][3] = 1; // после покупки фотоаппарата (=2)
			PI[playerid][pQuestCurrentID] = 4;
		}
		case 21: quests_SendMessage(playerid, "Мы можем наказать их по закону, либо наказать самостоятельно.", 22, 4000);
		case 22: quests_SendMessage(playerid, "Выбирать тебе. ", 23, 1500);
		case 23: {
			ShowPlayerDialog(playerid, D_QUESTS_4, DSL, ""P"Выбирать тебе", ""P"1. "W"Наказать по закону\n"P"2. "W"Наказать самостоятельно", "Выбрать", "");
		}
		case 24: {
			PI[playerid][pQuestProcess_Mason][3] = 4;

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			AC_GivePlayerWeapon(playerid, 24, 10);
		}
		case 25: quests_SendMessage(playerid, "Сегодня грузовой самолет перевозит незаконно несколько тонн наркотиков.", 26, 5000);
		case 26: quests_SendMessage(playerid, "Тебе придется пробраться на него до его вылета и суметь собрать, что успеешь.", 27, 5000);
		case 27: {

			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 246.1924, 2503.5669, 18.1168 - 4.0, 15.0);

			quests_CreateTempAirplane(playerid);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][4] = 1;
			PI[playerid][pQuestCurrentID] = 5;

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь к заброшенному аэропорту, который помечен "R"красной меткой "G"на радаре.");
		}
		case 28: {
			quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_5, 2);

			GiveMoney(playerid, QUESTS_AWARD_MONEY_5, "от Мэйсона (5)");
			UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 2));

			if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
				PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
				PI[playerid][pLevel] += 1;
				DollahScoreUpdate(playerid);
				SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

				if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
					GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
				}
			}
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestStatus_Mason][4] = 1;
		}
		case 29: quests_SendMessage(playerid, "Отправляйся в клуб “Aurora Club”, но будь осторожен.", 30, 3000);
		case 30: quests_SendMessage(playerid, "На входе стоит охрана, которая потребует секретное слово для входа. ", 31, 4000);
		case 31: quests_SendMessage(playerid, "Слово я не знаю, но есть информация, что он зашифрован около клуба. ", 32, 4000);
		case 32: quests_SendMessage(playerid, "Найди кодовое слово, попади в клуб и отыщи Босса, он скажет, что делать дальше.  ", 33, 4000);
		case 33: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 1033.4148, -1347.6427, 14.6285);

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][5] = 1;
			PI[playerid][pQuestCurrentID] = 6;

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в Aurora Club, который помечен "R"красной меткой "G"на радаре.");
		}
		case 34: quests_SendMessage(playerid, "Мы поймали крысу из полиции, который сливает информацию бандитам.", 35, 3500);
		case 35: quests_SendMessage(playerid, "Отправляйся к Ричарду, сейчас он у него, заберешь его форму и удостоверение.", 36, 3500);
		case 36: quests_SendMessage(playerid, "Не забудь, что откопать информацию тебе придется от его имени.", 37, 3500);
		case 37: quests_SendMessage(playerid, "Дальше отправляйся В Форт Карсон, запомни людей, которые платят ему и отправляйся ко мне.", 38, 3600);
		case 38: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 2336.4036, -1189.2058, 28.0621);
			
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][6] = 1;
			PI[playerid][pQuestCurrentID] = 7;

			quests_PI[playerid][pCopObjectID] = CreateDynamicObject(3092, 
				2334.132324, -1189.164550, 27.246953, 90.000000, 90.000000, 8.099998, 
				0, 0, playerid, 100.00, 100.00
			);
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь к Ричарду, который помечен "R"красной меткой "G"на радаре.");
		}
		case 39: quests_SendMessage(playerid, "Запомни его имя и представляйся им.", 40, 2000);
		case 40: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, -141.9382, 1161.6935, 19.7500, 5.0);
			DestroyDynamicObject(quests_PI[playerid][pCopObjectID]), quests_PI[playerid][pCopObjectID] = -1;

			switch (PI[playerid][pSex]) {
				case 1: A_SetPlayerSkin(playerid, 280);
				case 2: A_SetPlayerSkin(playerid, 201);
			}
			
			InventoryTempInfo[playerid][tClothesSlotBlocked] = 1;
			PI[playerid][pQuestProcess_Mason][6] = 2;

			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			quests_SendMessage(playerid, "Отправляйся к месту их встречи, запомни их лица и имена, и не выдай себя!", 0, 3000);
			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь к месту встречи, которая помечена "R"красной меткой "G"на радаре.");
			
		}
		case 41: quests_SendMessage(playerid, "Оставаться на виду сейчас очень опасно.", 42, 2500);
		case 42: quests_SendMessage(playerid, "Мы обязательно встретимся вновь.", 43, 2500);
		case 43: {
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			EnableGPSForPlayer(playerid, 1514.685, -2418.599, 43.639 - 2.0, 10.0);
			
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			quests_PI[playerid][pDialogStart] = 0;

			PI[playerid][pQuestProcess_Mason][7] = 0;
			PI[playerid][pQuestCurrentID] = 8;

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в аэропорт Лос Сантос, который помечен "R"красной меткой "G"на радаре.");
		}
	}
	quests_PI[playerid][pBotTextTimer] = (-1);

	return true;
}
CMD:cquests(playerid, params[]) {
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) 
		return true;
	if (sscanf(params, "d", params[0]))
		return SendEsp(playerid, "/completequests [amount]");

	for(new questid = 0; questid < MAX_QUESTS_MASON; questid++) {
		PI[playerid][pQuestStatus_Mason][questid] = 0;
	}
	if (params[0]) for(new questid = 0; questid < params[0]; questid++) {
		PI[playerid][pQuestStatus_Mason][questid] = 1;
	}
	return true;
}
CMD:pquests(playerid, params[]) {
	if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) 
		return true;
	if (sscanf(params, "dd", params[0], params[1]))
		return SendEsp(playerid, "/pquests [id] [status]");

	PI[playerid][pQuestProcess_Mason][params[0]] = params[1];

	return true;
}
stock quests_ActionBot(playerid) {
	new actor_id = GetPVarInt(playerid, "quests_ActorID");

	switch(quests_ActorsInfo[actor_id][questsType]) {
		case QUESTS_TYPE_BOSS: {
			if (quests_PI[playerid][pDialogStart])
				return;
			if (PI[playerid][pQuestCurrentID] == 6 && PI[playerid][pQuestProcess_Mason][5] == 1) {
				if (!quests_CreateBoat(playerid)) {
					ErrorMessage(playerid, "Слишком много игроков выполняют данное задание, попробуйте позже..");
					return;
				}
			}
		}
		case QUESTS_TYPE_RICHARD: {
			if (quests_PI[playerid][pDialogStart])
				return;
			if (PI[playerid][pQuestCurrentID] != 7 || PI[playerid][pQuestProcess_Mason][6] != 1) 
				return;

			quests_SendMessage(playerid, "Держи его форму и удостоверение, некий Алекс.", 39, 3000);


			SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
			TogglePlayerControllable(playerid, false);

			quests_PI[playerid][pDialogStart] = 1;
		}
		case QUESTS_TYPE_MASON: {
			if (quests_PI[playerid][pDialogStart])
				return;
			new quests_completed = GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON);
			switch(quests_completed) {
				case 0: { // Начало-конец задания "1. Водительские права"
					if (1 != PI[playerid][pQuestCurrentID]) { // начало 1 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Привет, дружище! Меня зовут Мэйсон.", 1, 2000);

						return;
					}
					else {
						if (1 == PI[playerid][pQuestProcess_Mason][0]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Ты быстро справился! Надеюсь не дорого обошлось?", 8, 3000);
						}
						else {
							if (gpss[playerid]) {
								DisablePlayerCheckpoint(playerid);
								DisablePlayerRaceCheckpoint(playerid);
								gpss[playerid] = 0;
							}
							EnableGPSForPlayer(playerid, 747.1273, -1390.9849, 13.4882);
							SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Водительские права\" от Мэйсона.");
							SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь в автошколу, которая помечена "R"красной меткой "G"на радаре.");
						}
					}
				}
				case 1: { // Начало-конец задания "2. Собери оружие"
					if (2 != PI[playerid][pQuestCurrentID]) { // начало 2 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "В одном деле тебе понадобится оружие, но покупать его в магазине слишком опасно.", 9, 4000);

						return;
					}
					else {
						if (20 == PI[playerid][pQuestProcess_Mason][1]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Молодец, то что нужно.", 10, 1500);
						}
						else {
							if (gpss[playerid]) {
								DisablePlayerCheckpoint(playerid);
								DisablePlayerRaceCheckpoint(playerid);
								gpss[playerid] = 0;
							}
							EnableGPSForPlayer(playerid, 2675.6917, -2405.5618, 13.4675);
							SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Собери оружие\" от Мэйсона.");
							SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь на "NO"оружейный завод"G", который помечен "R"красной меткой "G"на радаре.");
						}
					}
				}
				case 2: { // Начало-конец задания "3. Всё, что осталось"
					if (3 != PI[playerid][pQuestCurrentID]) { // начало 3 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Моего брата Томми похитили какие-то сволочи. ", 12, 3500);
					//	SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" [debug] Начало 3 задания.."), PI[playerid][pQuestStatus_Mason][2] = 1;

						return;
					}
					else {
						if (5 == PI[playerid][pQuestProcess_Mason][2]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Большое спасибо, ты спас моему брату жизнь. ", 11, 3000);
						}
						if (7 == PI[playerid][pQuestProcess_Mason][2]) {
							quests_SendMessage(playerid, "О, нет.. Ты не смог его спасти. Оставь меня. ", 0, 3000);
							SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Попробуйте выполнить данное задание (\"Всё, что осталось\") снова.");
						}
						else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Всё, что осталось\" от Мэйсона.");
					}
				}
				case 3: { // Начало-конец задания "4. Деньги или правосудие?"
					if (4 != PI[playerid][pQuestCurrentID]) { // начало 4 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Дошла информация, что виновные в избиение моего брата хотят откупиться бабками у грязных копов.", 18, 5000);

						return;
					}
					else {
						if (3 == PI[playerid][pQuestProcess_Mason][3]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Спасибо за отличные снимки!", 21, 3000);
						}
						else if (5 == PI[playerid][pQuestProcess_Mason][3]) { // застрелил ботов
							quests_SendMessage(playerid, "Ты хороший друг! Спасибо, что столько делаешь для нас. ", 0, 3000);
							quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_4, 1);

							GiveMoney(playerid, QUESTS_AWARD_MONEY_4, "от Мэйсона (4)");
							UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 1));

							if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
								PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
								PI[playerid][pLevel] += 1;
								DollahScoreUpdate(playerid);
								SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

								if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
									GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
								}
							}
							SetCameraBehindPlayer(playerid);
							TogglePlayerControllable(playerid, true);
							quests_PI[playerid][pDialogStart] = 0;

							PI[playerid][pQuestStatus_Mason][3] = 1;

							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						}
						else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Всё, что осталось\" от Мэйсона.");
					}
				}
				case 4: { // Начало-конец задания "5. Сбор наркотиков"
					if (5 != PI[playerid][pQuestCurrentID]) { // начало 5 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Есть возможность получить огромные деньги.", 25, 3000);

						return;
					}
					else {
						if (4 == PI[playerid][pQuestProcess_Mason][4]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							if (quests_PI[playerid][pAirplaneObjectID][0] != (-1)) {
								for(new objectid = 0; objectid < 22; objectid++) if (quests_PI[playerid][pAirplaneObjectID][objectid] != (-1))
									DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][objectid]), quests_PI[playerid][pAirplaneObjectID][objectid] = (-1);
							}
							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Достаточно, чтобы обогатиться, получи свои проценты!", 28, 2000);
						}
						/*else if (5 == PI[playerid][pQuestProcess_Mason][4]) { // не собрал наркоты
							quests_SendMessage(playerid, "Ты хороший друг! Спасибо, что столько делаешь для нас. ", 0, 3000);
							quests_ShowMissionPTD(playerid, 3000, 1);

							GiveMoney(playerid, 3000, "от Мэйсона (5)");
							UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 1));

							SetCameraBehindPlayer(playerid);
							TogglePlayerControllable(playerid, true);
							quests_PI[playerid][pDialogStart] = 0;

							PI[playerid][pQuestStatus_Mason][4] = 1;

							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						}*/
						else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Всё, что осталось\" от Мэйсона.");
					}
				}
				case 5: { // Начало-конец задания "6. Свой среди чужих "
					if (6 != PI[playerid][pQuestCurrentID]) { // начало 6 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Раз уж мы тебе уже доверяем, тебе придется снова нам помочь. ", 29, 3500);

						return;
					}
					else {
						/*if (4 == PI[playerid][pQuestProcess_Mason][5]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							if (quests_PI[playerid][pAirplaneObjectID][0] != (-1)) {
								for(new objectid = 0; objectid < 22; objectid++) if (quests_PI[playerid][pAirplaneObjectID][objectid] != (-1))
									DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][objectid]), quests_PI[playerid][pAirplaneObjectID][objectid] = (-1);
							}
							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Достаточно, чтобы обогатиться, получи свои проценты!", 28, 2000);
						}
						else */
						if (4 == PI[playerid][pQuestProcess_Mason][5]) { // застрелил ботов
							quests_SendMessage(playerid, "Ты хорошо поработал, Босс тобой доволен. Держи, что заработал.  ", 0, 3000);
							quests_ShowMissionPTD(playerid, QUESTS_AWARD_MONEY_6, 2);

							GiveMoney(playerid, QUESTS_AWARD_MONEY_6, "от Мэйсона (6)");
							UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 2));

							if (PI[playerid][pExp] >= (PI[playerid][pLevel]) * 6) {
								PI[playerid][pExp] -= (PI[playerid][pLevel]) * 6;
								PI[playerid][pLevel] += 1;
								DollahScoreUpdate(playerid);
								SendClientMessage(playerid, CGOLD, "Поздравляем! Ваш уровень повышен");

								if (TYPE_VIP[playerid] != VIP_STATE_NONE) {
									GiveMoney(playerid, VipData[TYPE_VIP[playerid]][VipLevel], "LEVEL VIP");
								}
							}
							SetCameraBehindPlayer(playerid);
							TogglePlayerControllable(playerid, true);
							quests_PI[playerid][pDialogStart] = 0;

							PI[playerid][pQuestStatus_Mason][5] = 1;

							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						}
						else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Всё, что осталось\" от Мэйсона.");
					}
				}
				case 6: { // Начало-конец задания "7. Под чужим именем"
					if (7 != PI[playerid][pQuestCurrentID]) { // начало 7 задания
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "У нас для тебя есть еще одно важное дело, мы не всегда против закона.", 34, 3500);

						return;
					}
					else {
						/*if (4 == PI[playerid][pQuestProcess_Mason][6]) {
							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
							TogglePlayerControllable(playerid, false);

							InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
							InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

							if (quests_PI[playerid][pAirplaneObjectID][0] != (-1)) {
								for(new objectid = 0; objectid < 22; objectid++) if (quests_PI[playerid][pAirplaneObjectID][objectid] != (-1))
									DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][objectid]), quests_PI[playerid][pAirplaneObjectID][objectid] = (-1);
							}
							quests_PI[playerid][pDialogStart] = 1;
							quests_SendMessage(playerid, "Достаточно, чтобы обогатиться, получи свои проценты!", 28, 2000);
						}
						else */
						if (4 == PI[playerid][pQuestProcess_Mason][6] && !TI[playerid][tDialog]) { 
							quests_SendMessage(playerid, "Ну что? Ты их запомнил? Опиши внешность и имена.", 0, 3000);

							ShowPlayerDialog(playerid, D_QUESTS_7_2, DIALOG_STYLE_LIST, ""P"Опиши внешность", "\
								"P"1. "W"Байкер на вид лет 30 (в черной куртке) и мужчина в очках, клетчатой рубашке\n\
								"P"2. "W"Автомеханник в рабочей форме и мужчина азиатской внешности, в коричневой кофте\n\
								"P"3. "W"Женщина в синем костюме и мужчина лет 30, в военной форме",
								"Выбрать", ""
							);
						}
						/*else if (5 == PI[playerid][pQuestProcess_Mason][6]) { 
							quests_SendMessage(playerid, "молодец.", 0, 3000);
							quests_ShowMissionPTD(playerid, 4000, 2);

							GiveMoney(playerid, 4000, "от Мэйсона (6)");
							UpdatePlayerData(playerid, "pExp", (PI[playerid][pExp] += 2));

							SetCameraBehindPlayer(playerid);
							TogglePlayerControllable(playerid, true);
							quests_PI[playerid][pDialogStart] = 0;

							PI[playerid][pQuestStatus_Mason][6] = 1;

							SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						}*/
						else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Под чужим именем\" от Мэйсона.");
					}
				}
				case 7: { // Начало-конец задания "8. Залечь на дно"
					if (6 != PI[playerid][pQuestCurrentID]) { // начало 8 задания [конец]
						SetPlayerToFacePos(playerid, quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1]);
						TogglePlayerControllable(playerid, false);

						InterpolateCameraPos(playerid, 1771.370605, -1893.652709, 15.150268, 1775.188598, -1891.343505, 14.367681, 4000);
						InterpolateCameraLookAt(playerid, 1771.777709, -1888.832885, 13.883749, 1770.885864, -1888.854248, 13.828367, 4000);

						quests_PI[playerid][pDialogStart] = 1;
						quests_SendMessage(playerid, "Мы хорошо поработали, но нужно залечь на дно.", 41, 3500);

						return;
					}
					else SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы уже начали выполнять задание \"Всё, что осталось\" от Мэйсона.");
				}
				case 8: ErrorMessage(playerid, "Вы уже прошли все задания Мэйсона!");
			}
		}
	}
}
forward OnActorClearAnimText(actor_id);
public OnActorClearAnimText(actor_id) {
	quests_ActorsInfo[actor_id][questsAnimation] = 0;
	return ApplyDynamicActorAnimation(quests_ActorsInfo[actor_id][questsActorID], "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 0);
}
quests_OnGameModeInit() {
	MissionLineTD[0] = TextDrawCreate(0.000000, 0.000000, "black");
	TextDrawLetterSize(MissionLineTD[0], 0.000000, 13.000000);
	TextDrawTextSize(MissionLineTD[0], 640.000000, 0.000000);
	TextDrawAlignment(MissionLineTD[0], 1);
	TextDrawColor(MissionLineTD[0], -1);
	TextDrawUseBox(MissionLineTD[0], 1);
	TextDrawBoxColor(MissionLineTD[0], 255);
	TextDrawSetShadow(MissionLineTD[0], 0);
	TextDrawSetOutline(MissionLineTD[0], 0);
	TextDrawBackgroundColor(MissionLineTD[0], 255);
	TextDrawFont(MissionLineTD[0], 1);
	TextDrawSetProportional(MissionLineTD[0], 1);
	TextDrawSetShadow(MissionLineTD[0], 0);

	MissionLineTD[1] = TextDrawCreate(0.000000, 330.000000, "black");
	TextDrawLetterSize(MissionLineTD[1], 0.000000, 14.000000);
	TextDrawTextSize(MissionLineTD[1], 640.000000, 0.000000);
	TextDrawAlignment(MissionLineTD[1], 1);
	TextDrawColor(MissionLineTD[1], -1);
	TextDrawUseBox(MissionLineTD[1], 1);
	TextDrawBoxColor(MissionLineTD[1], 255);
	TextDrawSetShadow(MissionLineTD[1], 0);
	TextDrawSetOutline(MissionLineTD[1], 0);
	TextDrawBackgroundColor(MissionLineTD[1], 255);
	TextDrawFont(MissionLineTD[1], 1);
	TextDrawSetProportional(MissionLineTD[1], 1);
	TextDrawSetShadow(MissionLineTD[1], 0);

	MissionLineTD[2] = TextDrawCreate(0.000000, 0.000000, "black");
	TextDrawLetterSize(MissionLineTD[2], 0.000000, 60.000000);
	TextDrawTextSize(MissionLineTD[2], 640.000000, 0.000000);
	TextDrawAlignment(MissionLineTD[2], 1);
	TextDrawColor(MissionLineTD[2], -1);
	TextDrawUseBox(MissionLineTD[2], 1);
	TextDrawBoxColor(MissionLineTD[2], 255);
	TextDrawSetShadow(MissionLineTD[2], 0);
	TextDrawSetOutline(MissionLineTD[2], 0);
	TextDrawBackgroundColor(MissionLineTD[2], 255);
	TextDrawFont(MissionLineTD[2], 1);
	TextDrawSetProportional(MissionLineTD[2], 1);
	TextDrawSetShadow(MissionLineTD[2], 0);

	CreateDynamic3DTextLabel(""W"Чтобы взять огнетушитель\n \n"P"Нажмите ALT", 0xFFFFFFFF,
		-2813.9812, -1513.9934, 139.2891,
		7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1
	);
	CreateDynamicPickup(366, 23, -2813.9812, -1513.9934, 139.2891, -1, -1);

	CreateDynamicPickup(1318, 1, 1034.5073, -1348.8934, 14.6285, 0, 0);
	CreateDynamic3DTextLabel(""W"Чтобы войти\n \n"P"Нажмите ALT", 0xFFFFFFFF,
		1034.5073, -1348.8934, 14.6285,
		5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1
	);
	quests_AreaID[0] = CreateDynamicSphere(-2831.9102, -1513.2188, 138.8774, 100.0, 0, 0);
	quests_AreaID[1] = CreateDynamicSphere(246.1924, 2503.5669, 18.1168, 8.0, 0, 0);
	quests_AreaID[2] = CreateDynamicSphere(1514.685, -2418.599, 43.639, 50.0, 0, 0);
	quests_AreaID[3] = CreateDynamicSphere(-141.9382, 1161.6935, 19.7500, 5.0, 0, 0);
	quests_AreaID[4] = CreateDynamicSphere(554.6301, -2452.3413, -0.0080, 5.0, 0, 0); // boat unload checkpoint


	CreateDynamicObject(824, 2341.122558, -1190.549072, 27.363433, 0.000000, 0.000000, 0.000000, 0, 0, -1, 100.00, 100.00); // kust
	CreateDynamicObject(824, 2329.770507, -1190.549072, 27.363433, 0.000000, 0.000000, 0.000000, 0, 0, -1, 100.00, 100.00); // kust


	for(new actor_id = 0, actorid = (-1); actor_id < MAX_QUESTS_ACTOR; actor_id++) {
		format(STRING_GLOBAL, 128, "\
			"P"Квестовый персонаж %s\n \n\
			"W"Нажмите "P"\"ALT\""W", чтобы поговорить с ним",
			quests_ActorsInfo[actor_id][questsName]
		);
		quests_ActorsInfo[actor_id][questsTextID] = CreateDynamic3DTextLabel(STRING_GLOBAL, 0xFFFFFFFF,
			quests_ActorsInfo[actor_id][questsPosition][0],
			quests_ActorsInfo[actor_id][questsPosition][1],
			quests_ActorsInfo[actor_id][questsPosition][2] + 0.5,
			7.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, quests_ActorsInfo[actor_id][questsVirtualWorldID], quests_ActorsInfo[actor_id][questsInteriorID]
		);
		STRING_GLOBAL[0] = EOS;

		actorid = AI_CreateActor(quests_ActorsInfo[actor_id][questsSkin],
			quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1],
			quests_ActorsInfo[actor_id][questsPosition][2], quests_ActorsInfo[actor_id][questsPosition][3], 
			quests_ActorsInfo[actor_id][questsVirtualWorldID], quests_ActorsInfo[actor_id][questsInteriorID]
		);
		quests_ActorsInfo[actor_id][questsActorID] = actorid;
		quests_ActorsInfo[actor_id][questsAnimation] = 0;

		new objectid = CreateDynamicObject(1317,
			quests_ActorsInfo[actor_id][questsPosition][0], quests_ActorsInfo[actor_id][questsPosition][1],
			quests_ActorsInfo[actor_id][questsPosition][2] - 1.94, 0.0, 0.0, 0.0, 0, 0, -1, 7.5
		);
	    SetDynamicObjectMaterial(objectid, 0, 18646, "matcolours", "red", 0xAAFF0000);

		/*quests_ActorsInfo[actor_id][questsCheckpointID] = CreateDynamicCP(
			quests_ActorsInfo[actor_id][questsPosition][0],
			quests_ActorsInfo[actor_id][questsPosition][1],
			quests_ActorsInfo[actor_id][questsPosition][2],
			1.25, 0, 0, -1, 5.0
		);*/
	}
	quests_ActorsID[0] = CreateDynamicActor(163, 1033.4148, -1347.6427, 14.6285, 262.0507, true, 100.0, -1, 0, -1); // security aurora club
	quests_ActorsID[1] = CreateDynamicActor(164, 1035.5704, -1349.6958, 14.6285, 0.530276, true, 100.0, -1, 0, -1); // security aurora club

	quests_ActorsID[2] = CreateDynamicActor(113, -2829.4619, 1063.3688, 948.8719, 331.448, true, 100.0, 100 + 1, 8, -1); // boss
	quests_ActorsID[3] = CreateDynamicActor(91, -2829.2529, 1064.8470, 948.8719, 174.9166, true, 100.0, 1, 8, -1); // girl-boss

	quests_ActorsID[4] = CreateDynamicActor(123, -143.2402, 1162.6155, 19.7422, 249.4640, true, 100.0, -1, 0, -1); // bot-fort-carson-1
	quests_ActorsID[5] = CreateDynamicActor(185, -142.6828, 1160.3436, 19.7422, 328.7167, true, 100.0, -1, 0, -1); // bot-fort-carson-2
	quests_ActorsID[6] = CreateDynamicActor(248, -140.3051, 1161.3864, 19.7500, 63.7620, true, 100.0, -1, 0, -1); // bot-fort-carson-3
	// quests_ActorsID[7] = CreateDynamicActor(179, 2336.4036, -1189.2058, 28.0621, 162.0246, true, 100.0, -1, 0, -1); // bot-richard

	ApplyDynamicActorAnimation(quests_ActorsID[0], "DEALER", "DEALER_IDLE", 4.1, 1, 1, 1, 1, 1);
	ApplyDynamicActorAnimation(quests_ActorsID[1], "DEALER", "DEALER_IDLE", 4.1, 1, 1, 1, 1, 1);

	ApplyDynamicActorAnimation(quests_ActorsID[2], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
	ApplyDynamicActorAnimation(quests_ActorsID[3], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);

	ApplyDynamicActorAnimation(quests_ActorsID[4], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
	ApplyDynamicActorAnimation(quests_ActorsID[5], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);
	ApplyDynamicActorAnimation(quests_ActorsID[6], "PED", "IDLE_CHAT", 4.1, 1, 1, 1, 1, 1);


}
enum {
	QM_MAIN_ID = 1,
	QM_LIST_ID,
	QM_CURRENT_ID,
}
stock quests_ShowMenu(playerid, type = QM_MAIN_ID) {
	new quests_completed = GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON);
	STRING_GLOBAL[0] = CHAT_GLOBAL[0] = EOS;

	switch(type) {
		case QM_MAIN_ID: {
			ShowPlayerDialog(playerid, D_QUESTS_MM, DIALOG_STYLE_LIST, ""P"Квестовая линия от Мэйсона",
				""P"1. "W"Список заданий\n"P"2. "W"Текущее задание", "Выбрать", "Отмена"
			);
		}
		case QM_LIST_ID: {
			for(new questid = 1; questid < (MAX_QUESTS_MASON + 1); questid++) {
				if (PI[playerid][pQuestStatus_Mason][questid - 1])
					format(CHAT_GLOBAL, sizeof(CHAT_GLOBAL), ""P"%i. "W"%s {556B2F}[задание выполнено]\n", questid, quests_mason_info[questid - 1][questsName]); // ВЫПОЛНЕНО
				else if (PI[playerid][pQuestCurrentID] == questid)
					format(CHAT_GLOBAL, sizeof(CHAT_GLOBAL), ""P"%i. "W"%s "P"[текущее задание]\n", questid, quests_mason_info[questid - 1][questsName]); // ТЕКУЩЕЕ
				else format(CHAT_GLOBAL, sizeof(CHAT_GLOBAL), ""P"%i. "W"%s "G"[задание не выполнено]\n", questid, quests_mason_info[questid - 1][questsName]); // НЕ ВЫПОЛНЕНО

				strcat(STRING_GLOBAL, CHAT_GLOBAL);
			}
			ShowPlayerDialog(playerid, D_QUESTS_BACK, DIALOG_STYLE_LIST, ""P"Список заданий", STRING_GLOBAL, "Назад", "");
		}
		case QM_CURRENT_ID: {
			if (0 == PI[playerid][pQuestCurrentID] && !quests_completed)
				return SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы еще не получали ни одного задания от Мэйсона.");
			new quest_current_id = PI[playerid][pQuestCurrentID];

			format(STRING_GLOBAL, 512, "\
				"W"Текущее задание: "P"%s\n\
				"W"Награда за выполнение: %s%i %s%i%s\n \n\
				"W"Подсказка: "G"%s",
				(quests_mason_info[quest_current_id - 1][questsName]),

				(quests_mason_info[quest_current_id - 1][questsMoney] != 0) ? ("{228B22}$") : (""),
				(quests_mason_info[quest_current_id - 1][questsMoney] != 0) ? quests_mason_info[quest_current_id - 1][questsMoney] : EOS,

				(quests_mason_info[quest_current_id - 1][questsEXP] != 0) ? ("{FFA500}") : (""),
				(quests_mason_info[quest_current_id - 1][questsEXP] != 0) ? quests_mason_info[quest_current_id - 1][questsEXP] : EOS,
				(quests_mason_info[quest_current_id - 1][questsEXP] != 0) ? ("EXP") : (""),
				// status_string,
				(quests_mason_info[quest_current_id - 1][questsHELP])
			);
			ShowPlayerDialog(playerid, D_QUESTS_BACK, DIALOG_STYLE_MSGBOX, ""P"Текущее задание", STRING_GLOBAL, "Назад", "");
		}

	}
	STRING_GLOBAL[0] = CHAT_GLOBAL[0] = EOS;

	return true;
}
stock quests_ShowMissionPTD(playerid, money = 0, exp = 0) {
	if (quests_PI[playerid][pMissionPassedTD])
		for(new ptd_id = 0; ptd_id < 2; ptd_id++) PlayerTextDrawDestroy(playerid, MissionPassedPTD[playerid][ptd_id]);

	if (4 == exp) 
		format(STRING_GLOBAL, 32, "~y~~h~+1LEVEL");
	else if (0 == exp)
		format(STRING_GLOBAL, 32, "~g~~h~$%i", money);
	else if (0 == money)
		format(STRING_GLOBAL, 32, "~y~~h~%iEXP", exp);
	else format(STRING_GLOBAL, 32, "~g~~h~$%i~w~+~y~~h~%iEXP", money, exp);

	MissionPassedPTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 135.000000, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
	PlayerTextDrawLetterSize(playerid, MissionPassedPTD[playerid][1], 0.636134, 2.585832);
	PlayerTextDrawTextSize(playerid, MissionPassedPTD[playerid][1], 0.000000, 387.000000);
	PlayerTextDrawAlignment(playerid, MissionPassedPTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, MissionPassedPTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, MissionPassedPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MissionPassedPTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, MissionPassedPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, MissionPassedPTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, MissionPassedPTD[playerid][1], 1);

	MissionPassedPTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 110.000000, "~r~~h~~h~~h~MISSION PASSED!");
	PlayerTextDrawLetterSize(playerid, MissionPassedPTD[playerid][0], 0.729370, 2.766666);
	PlayerTextDrawTextSize(playerid, MissionPassedPTD[playerid][0], 0.000000, 447.000000);
	PlayerTextDrawAlignment(playerid, MissionPassedPTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, MissionPassedPTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, MissionPassedPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MissionPassedPTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, MissionPassedPTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, MissionPassedPTD[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, MissionPassedPTD[playerid][0], 1);

	for(new ptd_id = 0; ptd_id < 2; ptd_id++)
		PlayerTextDrawShow(playerid, MissionPassedPTD[playerid][ptd_id]);

	quests_PI[playerid][pMissionPassedTimer] = 5;
	return quests_PI[playerid][pMissionPassedTD] = 1;
}
stock quests_ShowFailedMissionPTD(playerid) {
	if (quests_PI[playerid][pMissionPassedTD])
		for(new ptd_id = 0; ptd_id < 2; ptd_id++) PlayerTextDrawDestroy(playerid, MissionPassedPTD[playerid][ptd_id]);

	MissionPassedPTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000000, 135.000000, "~w~TRY AGAIN!");
	PlayerTextDrawLetterSize(playerid, MissionPassedPTD[playerid][1], 0.636134, 2.585832);
	PlayerTextDrawTextSize(playerid, MissionPassedPTD[playerid][1], 0.000000, 387.000000);
	PlayerTextDrawAlignment(playerid, MissionPassedPTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, MissionPassedPTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, MissionPassedPTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, MissionPassedPTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, MissionPassedPTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, MissionPassedPTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, MissionPassedPTD[playerid][1], 1);

	MissionPassedPTD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000000, 110.000000, "~r~MISSION FAILED!");
	PlayerTextDrawLetterSize(playerid, MissionPassedPTD[playerid][0], 0.729370, 2.766666);
	PlayerTextDrawTextSize(playerid, MissionPassedPTD[playerid][0], 0.000000, 447.000000);
	PlayerTextDrawAlignment(playerid, MissionPassedPTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, MissionPassedPTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, MissionPassedPTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, MissionPassedPTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, MissionPassedPTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, MissionPassedPTD[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, MissionPassedPTD[playerid][0], 1);

	for(new ptd_id = 0; ptd_id < 2; ptd_id++)
		PlayerTextDrawShow(playerid, MissionPassedPTD[playerid][ptd_id]);

	quests_PI[playerid][pMissionPassedTimer] = 5;
	return quests_PI[playerid][pMissionPassedTD] = 1;
}
stock quests_HideMissionPTD(playerid) {
	if (0 == quests_PI[playerid][pMissionPassedTD])
		return 1;
	for(new ptd_id = 0; ptd_id < 2; ptd_id++)
		PlayerTextDrawDestroy(playerid, MissionPassedPTD[playerid][ptd_id]);
	return quests_PI[playerid][pMissionPassedTD] = quests_PI[playerid][pMissionPassedTimer] = 0;
}
forward quests_FireMissionTimer(playerid, type);
public quests_FireMissionTimer(playerid, type) {
	if (!IsPlayerConnected(playerid) || !TI[playerid][tLogin])
		return;
	switch(type) {
		case 1: {
			SetPlayerPosAC(playerid, -2819.6958, -1582.3876, 141.3203, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			if (gpss[playerid]) {
				DisablePlayerCheckpoint(playerid);
				DisablePlayerRaceCheckpoint(playerid);
				gpss[playerid] = 0;
			}
			/*new Float:playerPos[3];
			GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
			SetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);*/

			TogglePlayerControllable(playerid, false);

			for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
				TextDrawShowForPlayer(playerid, MissionLineTD[td_id]);
			PI[playerid][pQuestProcess_Mason][2] = 2;

			SetPlayerVirtualWorld(playerid, 1);
			SetPlayerInterior(playerid, 0);

			InterpolateCameraPos(playerid, -2824.280761, -1483.202758, 147.948760, -2836.122070, -1543.524536, 143.379577, 5000 + 1000);
			InterpolateCameraLookAt(playerid, -2823.411376, -1487.973754, 146.731689, -2833.818847, -1539.162475, 142.562164, 6000 + 1000);

			SetTimerEx("quests_FireMissionTimer", 6500, false, "ii", playerid, 2);

			if (quests_PI[playerid][pActorID][0] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
			if (quests_PI[playerid][pActorID][1] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][1]), quests_PI[playerid][pActorID][1] = (-1);

			quests_PI[playerid][pActorID][0] = CreateDynamicActor(47, -2831.9102, -1513.2188, 138.8774, 252.9075, true, 100.0, 1, 0, playerid);
			quests_PI[playerid][pActorID][1] = CreateDynamicActor(48, -2832.2974, -1526.8118, 138.9348, 283.0295, true, 100.0, 1, 0, playerid);

			Streamer_Update(playerid);
		}
		case 2: {
			for(new fire_id = 0; fire_id < MAX_QUEST_FIRE_OBJECTS; fire_id++) {
				quests_FireObjects[playerid][fireObjectID][fire_id] = CreateDynamicObject(18691,
					FireObjectPosition[fire_id][0], FireObjectPosition[fire_id][1], FireObjectPosition[fire_id][2] - 2.72,
					0.000000, 0.000000, 0.000000,
					(playerid + 2), 0, playerid, 200.00, 200.00
				);
				quests_FireObjects[playerid][fireStopObjectID][fire_id] = CreateDynamicObject(8408,
					FireObjectPosition[fire_id][0], FireObjectPosition[fire_id][1], FireObjectPosition[fire_id][2] - (2.72 + 3.0),
					180.000000, 0.000000, 0.000000,
					(playerid + 2), 0, playerid, 50.00, 50.00
				);
				SetDynamicObjectMaterial(quests_FireObjects[playerid][fireStopObjectID][fire_id], 0, 10101, "2notherbuildsfe", "ferry_build14", 0x000000FF);
				SetDynamicObjectMaterial(quests_FireObjects[playerid][fireStopObjectID][fire_id], 1, 10101, "2notherbuildsfe", "ferry_build14", 0x000000FF);
				SetDynamicObjectMaterial(quests_FireObjects[playerid][fireStopObjectID][fire_id], 2, 10101, "2notherbuildsfe", "ferry_build14", 0x000000FF);

				quests_FireObjects[playerid][fireAreaID][fire_id] = CreateDynamicSphere(
					FireObjectPosition[fire_id][0], FireObjectPosition[fire_id][1], FireObjectPosition[fire_id][2], 2.25, -1, -1
				);
				SetDynamicAreaType(quests_FireObjects[playerid][fireAreaID][fire_id], AREA_TYPE_QUESTS_FIRE, fire_id);
				quests_FireObjects[playerid][fireProcess][fire_id] = 0; // (0 / 100%)
			}
			quests_PI[playerid][pActorID][2] = CreateDynamicActor(23, -2816.4324, -1516.7139, 141.4841, 79.6397, true, 100.0, 1, 0, playerid);
			ApplyDynamicActorAnimation(quests_PI[playerid][pActorID][2], "CRACK", "crckdeth2", 4.0, 0, 0, 0, 1, 0);

			Streamer_Update(playerid);
			ApplyDynamicActorAnimation(quests_PI[playerid][pActorID][0], "GRENADE", "WEAPON_throw", 4.1, 0, 1, 1, 1, 1);
			ApplyDynamicActorAnimation(quests_PI[playerid][pActorID][1], "GRENADE", "WEAPON_throw", 4.1, 0, 1, 1, 1, 1);

			SetTimerEx("quests_FireMissionTimer", 2000, false, "ii", playerid, 3);
		}
		case 3: {
			SetPlayerVirtualWorld(playerid, (playerid + 2));

			if (quests_PI[playerid][pActorID][0] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
			if (quests_PI[playerid][pActorID][1] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][1]), quests_PI[playerid][pActorID][1] = (-1);
			if (quests_PI[playerid][pActorID][2] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][2]), quests_PI[playerid][pActorID][2] = (-1);

			quests_PI[playerid][pActorID][0] = CreateDynamicActor(47, -2831.9102, -1513.2188, 138.8774, 252.9075, true, 100.0, (playerid + 2), 0, playerid);
			quests_PI[playerid][pActorID][1] = CreateDynamicActor(48, -2832.2974, -1526.8118, 138.9348, 283.0295, true, 100.0, (playerid + 2), 0, playerid);
			quests_PI[playerid][pActorID][2] = CreateDynamicActor(23, -2816.4324, -1516.7139, 141.4841, 79.6397, true, 100.0, (playerid + 2), 0, playerid);

			Streamer_Update(playerid);

			ApplyDynamicActorAnimation(quests_PI[playerid][pActorID][2], "CRACK", "crckdeth2", 4.0, 0, 0, 0, 1, 0);

			InterpolateCameraPos(playerid, -2830.937011, -1544.973754, 143.845352, -2830.898193, -1510.596191, 142.723831, 5000);
			InterpolateCameraLookAt(playerid, -2827.717773, -1541.173095, 143.407638, -2826.458496, -1512.818969, 142.133804, 5000);

			SetTimerEx("quests_FireMissionTimer", 5500, false, "ii", playerid, 4);
		}
		case 4: {
			PI[playerid][pQuestProcess_Mason][2] = 3;

			for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
				TextDrawHideForPlayer(playerid, MissionLineTD[td_id]);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			if (quests_PI[playerid][pActorID][0] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
			if (quests_PI[playerid][pActorID][1] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][1]), quests_PI[playerid][pActorID][1] = (-1);

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Бегите быстрее и "NO"возьмите огнетушитель"W", затем потушите огонь!");
		}
		case 5: {
			for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
				TextDrawHideForPlayer(playerid, MissionLineTD[td_id]);
			if (quests_PI[playerid][pActorID][0] != (-1))
				DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			ResetPlayerWeapons(playerid);

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Вы спасли Томми, отправляйтесь к Мэйсону и поговорите с ним!");
		}
	}
}
stock quests_DestroyFire(playerid, fire_id) {
	if (fire_id < 0 || quests_FireObjects[playerid][fireObjectID][fire_id] == (-1)) return;

	if (fire_id == 0) SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Скорее потушите весь разгоревшийся огонь!");
	quests_FireObjects[playerid][fireProcess][fire_id] = 100;
	DestroyDynamicObject(quests_FireObjects[playerid][fireObjectID][fire_id]);
	DestroyDynamicObject(quests_FireObjects[playerid][fireStopObjectID][fire_id]);
	DestroyDynamicArea(quests_FireObjects[playerid][fireAreaID][fire_id]);
	quests_FireObjects[playerid][fireObjectID][fire_id] = quests_FireObjects[playerid][fireAreaID][fire_id] = (-1);

	new amount_fire = 0;
	for(new fireid = 0; fireid < MAX_QUEST_FIRE_OBJECTS; fireid++) {
		if (quests_FireObjects[playerid][fireObjectID][fireid] != (-1)) amount_fire++;
	}
	if (0 == amount_fire) {
		for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
			TextDrawShowForPlayer(playerid, MissionLineTD[td_id]);
		if (quests_PI[playerid][pActorID][0] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
		if (quests_PI[playerid][pActorID][1] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][1]), quests_PI[playerid][pActorID][1] = (-1);
		if (quests_PI[playerid][pActorID][2] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][2]), quests_PI[playerid][pActorID][2] = (-1);

		quests_PI[playerid][pActorID][0] = CreateDynamicActor(23, -2829.0796, -1521.4767, 139.10264, 180.9075, true, 100.0, GetPlayerVirtualWorld(playerid), 0, playerid);

		SetPlayerPosAC(playerid, -2828.7771, -1524.9170, 139.1148, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		SetPlayerFacingAngle(playerid, 6.497);
		Streamer_Update(playerid);

		SendClientMessage(playerid, 0xFFFFFFFF, "- "P"Томми: "W"Спасибо тебе большое!");
		ApplyDynamicActorAnimation(quests_PI[playerid][pActorID][0], "PED", "IDLE_CHAT", 4.1, 0, 1, 1, 1, 1);

		TogglePlayerControllable(playerid, false);
		InterpolateCameraPos(playerid, -2830.589599, -1531.605590, 141.283859, -2835.308349, -1523.105346, 140.547851, 4000);
		InterpolateCameraLookAt(playerid, -2828.670166, -1527.123779, 140.175430, -2830.353271, -1523.106079, 139.878768, 4000);
		SetTimerEx("quests_FireMissionTimer", 4500, false, "ii", playerid, 5);
		PI[playerid][pQuestProcess_Mason][2] = 5;
	}
}
public OnPlayerGiveDamageDynamicActor(playerid, STREAMER_TAG_ACTOR:actorid, Float:amount, weaponid, bodypart) {
	if (weaponid == 24 && PI[playerid][pQuestProcess_Mason][3] == 4) {

		if (actorid == quests_PI[playerid][pActorID][0]) {
			PI[playerid][pQuestProcess_Mason][3] = 5;

			if (bodypart == 9)
				ApplyDynamicActorAnimation(actorid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0);
			else ApplyDynamicActorAnimation(actorid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Вы наказали их, убегайте скорее с места преступления и поговорите с Мэйсоном!");
		}
		if (actorid == quests_PI[playerid][pActorID][1]) {
			PI[playerid][pQuestProcess_Mason][3] = 5;

			if (bodypart == 9)
				ApplyDynamicActorAnimation(actorid, "PED", "KO_shot_face", 4.1, 0, 0, 0, 1, 0);
			else ApplyDynamicActorAnimation(actorid, "CRACK", "crckdeth1", 4.1, 0, 0, 0, 1, 0);

			SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Вы наказали их, убегайте скорее с места преступления и поговорите с Мэйсоном!");
		}
	}

	return true;
}
/*stock quests_OnPlayerDeath(playerid) {
	new quests_completed = GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON);
	if (quests_completed && quests_completed + 1 == PI[playerid][pQuestCurrentID]) {
		switch(PI[playerid][pQuestCurrentID]) {
			case 1: {}
		}
	}
	if (quests_PI[playerid][pActorID][0] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][0]), quests_PI[playerid][pActorID][0] = (-1);
	if (quests_PI[playerid][pActorID][1] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][1]), quests_PI[playerid][pActorID][1] = (-1);
	if (quests_PI[playerid][pActorID][2] != (-1)) DestroyDynamicActor(quests_PI[playerid][pActorID][2]), quests_PI[playerid][pActorID][2] = (-1);
}*/

stock quests_CreateTempAirplane(playerid) {
	quests_PI[playerid][pAirplaneObjectID][0] = CreateDynamicObject(14553, 212.459716, 2503.641601, 20.214538, 12.600029, 0.000007, -90.000091, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][0], 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	quests_PI[playerid][pAirplaneObjectID][1] = CreateDynamicObject(14548, 216.134765, 2503.641601, 20.761753, 12.600029, 0.000007, -90.000091, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][1], 0, 10765, "airportgnd_sfse", "black64", 0x00000000);
	quests_PI[playerid][pAirplaneObjectID][2] = CreateDynamicObject(2991, 235.744384, 2506.546142, 19.278465, 0.000007, -0.000030, -0.000198, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][2], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][3] = CreateDynamicObject(2991, 230.273437, 2506.546142, 19.278465, 0.000007, -0.000030, -0.000198, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][3], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][4] = CreateDynamicObject(2991, 235.744384, 2500.556152, 19.278465, 0.000015, -0.000030, -0.000228, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][4], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][5] = CreateDynamicObject(2991, 230.273437, 2500.556152, 19.278465, 0.000015, -0.000030, -0.000228, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][5], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][6] = CreateDynamicObject(2991, 235.744384, 2506.635986, 20.528493, 0.000030, -0.000030, -0.000274, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][6], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][7] = CreateDynamicObject(2991, 230.273437, 2506.635986, 20.528493, 0.000030, -0.000030, -0.000274, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][7], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][8] = CreateDynamicObject(2991, 235.744384, 2500.575927, 20.528493, 0.000038, -0.000030, -0.000289, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][8], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][9] = CreateDynamicObject(2991, 230.273437, 2500.575927, 20.528493, 0.000038, -0.000030, -0.000289, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][9], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][10] = CreateDynamicObject(3571, 223.834228, 2503.632324, 20.001838, 0.000030, 0.000015, -90.000091, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][11] = CreateDynamicObject(3799, 226.659179, 2500.417968, 18.688978, 0.000030, 0.000007, -90.000091, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][12] = CreateDynamicObject(3800, 227.663818, 2506.650634, 18.688508, 0.000030, 0.000007, -90.000091, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][12], 0, -1, "none", "none", 0xFFFF0000);

	quests_PI[playerid][pAirplaneObjectID][13] = CreateDynamicObject(1327, 189.145599, 2503.640380, 16.267683, -22.599994, 0.000000, 90.000000, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][13], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][14] = CreateDynamicObject(1327, 225.465545, 2500.640380, 16.267683, -22.599985, 0.000000, 89.999977, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][14], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][15] = CreateDynamicObject(1327, 225.465545, 2506.640380, 16.267683, -22.599985, 0.000000, 89.999977, -1, 0, playerid, 300.00, 300.00);
	SetDynamicObjectMaterial(quests_PI[playerid][pAirplaneObjectID][15], 0, -1, "none", "none", 0xFFFFFFFF);
	quests_PI[playerid][pAirplaneObjectID][16] = CreateDynamicObject(1897, 189.093917, 2503.594970, 17.302600, 0.000000, 0.000000, 0.000000, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][17] = CreateDynamicObject(1897, 189.093917, 2502.864257, 17.302600, 0.000000, 0.000000, 0.000000, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][18] = CreateDynamicObject(1897, 225.413864, 2500.594970, 17.302600, 0.000000, 0.000007, 0.000000, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][19] = CreateDynamicObject(1897, 225.413864, 2499.864257, 17.302600, 0.000000, 0.000007, 0.000000, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][20] = CreateDynamicObject(1897, 225.413864, 2506.594970, 17.302600, 0.000000, 0.000007, 0.000000, -1, 0, playerid, 300.00, 300.00);
	quests_PI[playerid][pAirplaneObjectID][21] = CreateDynamicObject(1897, 225.413864, 2505.864257, 17.302600, 0.000000, 0.000007, 0.000000, -1, 0, playerid, 300.00, 300.00);

	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

}
stock quests_MoveTempAirplane(playerid) {
	InterpolateCameraPos(playerid, 294.883087, 2491.394775, 29.986171, 300.437072, 2511.922363, 41.617511, 6000);
	InterpolateCameraLookAt(playerid, 290.063201, 2492.544189, 29.317087, 295.548461, 2511.556396, 40.633865, 6000);

	new Float:TEMP_AIRPLANE_SPEED = 20.0;
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][0], 9.951652, 2503.641601, 47.719902, TEMP_AIRPLANE_SPEED, 3.800020, -0.000006, -90.000045);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][1], 13.667152, 2503.641601, 47.698444, TEMP_AIRPLANE_SPEED, 3.800020, -0.000006, -90.000045);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][2], 32.819015, 2506.546142, 43.232620, TEMP_AIRPLANE_SPEED, -0.000022, 8.799977, -0.000197);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][3], 27.412467, 2506.546142, 44.069599, TEMP_AIRPLANE_SPEED, -0.000022, 8.799977, -0.000197);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][4], 32.819015, 2500.556152, 43.232620, TEMP_AIRPLANE_SPEED, -0.000019, 8.799977, -0.000228);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][5], 27.412467, 2500.556152, 44.069599, TEMP_AIRPLANE_SPEED, -0.000019, 8.799977, -0.000228);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][6], 33.010253, 2506.635986, 44.467937, TEMP_AIRPLANE_SPEED, -0.000011, 8.799977, -0.000276);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][7], 27.603706, 2506.635986, 45.304916, TEMP_AIRPLANE_SPEED, -0.000011, 8.799977, -0.000276);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][8], 33.010253, 2500.575927, 44.467937, TEMP_AIRPLANE_SPEED, -0.000006, 8.799977, -0.000292);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][9], 27.603706, 2500.575927, 45.304916, TEMP_AIRPLANE_SPEED, -0.000006, 8.799977, -0.000292);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][10], 21.159729, 2503.632324, 45.769565, TEMP_AIRPLANE_SPEED, -8.799978, 0.000001, -90.000053);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][11], 23.750579, 2500.417968, 44.039981, TEMP_AIRPLANE_SPEED, -8.799978, -0.000006, -90.000053);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][12], 24.743309, 2506.650634, 43.885822, TEMP_AIRPLANE_SPEED, -8.799978, -0.000006, -90.000053);

	//for(new objectid = 13; objectid < 22; objectid++)
	//	DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][objectid]), quests_PI[playerid][pAirplaneObjectID][objectid] = (-1);
	return true;

}


forward quests_DestroyAirplaneTimer(playerid);
public quests_DestroyAirplaneTimer(playerid) {
	if (PI[playerid][pQuestProcess_Mason][4] == 3) {
		PI[playerid][pQuestCurrentID] = 4;
		PI[playerid][pQuestProcess_Mason][4] = 0;
		quests_ShowFailedMissionPTD(playerid);

		ErrorMessage(playerid, "Вы не успели собрать и провалили задание. Попробуйте выполнить еще раз.");
	}
	if (quests_PI[playerid][pAirplaneObjectID][0] != (-1)) {
		for(new objectid = 0; objectid < 22; objectid++) if (quests_PI[playerid][pAirplaneObjectID][objectid] != (-1))
			DestroyDynamicObject(quests_PI[playerid][pAirplaneObjectID][objectid]), quests_PI[playerid][pAirplaneObjectID][objectid] = (-1);
	}
}



forward quests_AirplaneMissionTimer(playerid);
public quests_AirplaneMissionTimer(playerid) {
	if (!IsPlayerConnected(playerid) || !TI[playerid][tLogin])
		return;

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][0], -351.147949, 2546.817138, 292.347320);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][0], 12.600028, 0.000007, -90.000091);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][1], -347.472900, 2546.817138, 292.894531);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][1], 12.600028, 0.000007, -90.000091);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][2], -327.863281, 2549.721679, 291.411254);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][2], 0.000007, -0.000029, -0.000197);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][3], -333.334228, 2549.721679, 291.411254);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][3], 0.000007, -0.000029, -0.000197);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][4], -327.863281, 2543.731689, 291.411254);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][4], 0.000014, -0.000029, -0.000228);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][5], -333.334228, 2543.731689, 291.411254);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][5], 0.000014, -0.000029, -0.000228);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][6], -327.863281, 2549.811523, 292.661285);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][6], 0.000029, -0.000029, -0.000273);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][7], -333.334228, 2549.811523, 292.661285);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][7], 0.000029, -0.000029, -0.000273);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][8], -327.863281, 2543.751464, 292.661285);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][8], 0.000037, -0.000029, -0.000288);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][9], -333.334228, 2543.751464, 292.661285);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][9], 0.000037, -0.000029, -0.000288);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][10], -339.773437, 2546.807861, 292.134613);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][10], 0.000029, 0.000014, -90.000091);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][11], -336.948486, 2543.593505, 290.821746);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][11], 0.000029, 0.000007, -90.000091);

	SetDynamicObjectPos(quests_PI[playerid][pAirplaneObjectID][12], -335.943847, 2549.826171, 290.821289);
	SetDynamicObjectRot(quests_PI[playerid][pAirplaneObjectID][12], 0.000029, 0.000007, -90.000091); // box for open

	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

	SetPlayerVirtualWorld(playerid, (playerid + 1));
	SetPlayerPosAC(playerid, -338.0358, 2547.2961, 291.829, (playerid + 1), GetPlayerInterior(playerid));
	SetPlayerFacingAngle(playerid, 270.0);

	SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Скорее вскройте "NO"красный ящик"G", соберите наркотики и прыгайте из самолета.");
	SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Чтобы вскрыть ящик, подойдите к нему и нажмите "NO"ALT"G".");

	PI[playerid][pQuestProcess_Mason][4] = 3;
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);
	AC_GivePlayerWeapon(playerid, 46, 1);

	new Float:TEMP_AIRPLANE_SPEED = 15.0;

	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][0], -1051.147949 - 300.0, 2546.817138, 292.347320, TEMP_AIRPLANE_SPEED, 12.600028, 0.000007, -90.000091);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][1], -1047.472900 - 300.0, 2546.817138, 292.894531, TEMP_AIRPLANE_SPEED, 12.600028, 0.000007, -90.000091);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][2], -1027.863281 - 300.0, 2549.721679, 291.411254, TEMP_AIRPLANE_SPEED, 0.000007, -0.000029, -0.000197);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][3], -1033.334228 - 300.0, 2549.721679, 291.411254, TEMP_AIRPLANE_SPEED, 0.000007, -0.000029, -0.000197);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][4], -1027.863281 - 300.0, 2543.731689, 291.411254, TEMP_AIRPLANE_SPEED, 0.000014, -0.000029, -0.000228);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][5], -1033.334228 - 300.0, 2543.731689, 291.411254, TEMP_AIRPLANE_SPEED, 0.000014, -0.000029, -0.000228);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][6], -1027.863281 - 300.0, 2549.811523, 292.661285, TEMP_AIRPLANE_SPEED, 0.000029, -0.000029, -0.000273);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][7], -1033.334228 - 300.0, 2549.811523, 292.661285, TEMP_AIRPLANE_SPEED, 0.000029, -0.000029, -0.000273);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][8], -1027.863281 - 300.0, 2543.751464, 292.661285, TEMP_AIRPLANE_SPEED, 0.000037, -0.000029, -0.000288);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][9], -1033.334228 - 300.0, 2543.751464, 292.661285, TEMP_AIRPLANE_SPEED, 0.000037, -0.000029, -0.000288);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][10], -1039.773437 - 300.0, 2546.807861, 292.134613, TEMP_AIRPLANE_SPEED, 0.000029, 0.000014, -90.000091);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][11], -1036.948486 - 300.0, 2543.593505, 290.821746, TEMP_AIRPLANE_SPEED, 0.000029, 0.000007, -90.000091);
	MoveDynamicObject(quests_PI[playerid][pAirplaneObjectID][12], -1035.943847 - 300.0, 2549.826171, 290.821289, TEMP_AIRPLANE_SPEED, 0.000029, 0.000007, -90.000091);

	SetTimerEx("quests_DestroyAirplaneTimer", 32000, false, "i", playerid);
}



forward QuestLastMissionTimer(playerid, type);
public QuestLastMissionTimer(playerid, type) {
	switch(type) {
		case 0: {
			GameTextForPlayer(playerid, "CЊYCЏ• 1 ‚Oѓ..", 1500, 1);
			TogglePlayerControllable(playerid, false);
			TextDrawHideForPlayer(playerid, MissionLineTD[2]);

			SetPlayerPosAC(playerid, 1688.1753, -2394.9900, 13.5547,  1, 0);
			SetPlayerVirtualWorld(playerid, 1);
			SetPlayerInterior(playerid, 0);

			quests_PI[playerid][pPlaneObjectID] = CreateDynamicObject(1683, 
				1309.855957, -2491.913818, 55.974689, 0.000000, 2.599999, 0.000000, 
				1, 0, playerid, 600.00, 600.00
			); 
			SetDynamicObjectMaterial(quests_PI[playerid][pPlaneObjectID], 1, 1613, "alleyprop", "stuffdirtcol", 0x000000FF);

			Streamer_Update(playerid, STREAMER_TYPE_OBJECT);

			MoveDynamicObject(quests_PI[playerid][pPlaneObjectID], 1477.05, -2491.91, 18.195, 20.0, 0.000000, 0.000000, 0.000000);

			InterpolateCameraPos(playerid, 1514.685, -2418.599, 43.639, 1668.329, -2424.336, 43.822, 18000);
			InterpolateCameraLookAt(playerid, 1511.023, -2421.962, 43.112, 1664.729, -2427.576, 42.580, 18000);

			quests_PI[playerid][pQuestTimer] = SetTimerEx("QuestLastMissionTimer", (20 * 1000), false, "ii", playerid, 1);
		}
		case 1: {
			DestroyDynamicObject(quests_PI[playerid][pPlaneObjectID]);
			quests_PI[playerid][pPlaneObjectID] = -1;
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, true);

			for(new td_id = 0; td_id < sizeof(MissionLineTD); td_id++)
				TextDrawHideForPlayer(playerid, MissionLineTD[td_id]);
			
			SetPlayerPosAC(playerid, 1641.7415, -2333.1687, 13.5469,  0, 0);
			SetPlayerFacingAngle(playerid, 0.0);

			PI[playerid][pLevel]++;
			DollahScoreUpdate(playerid);
			quests_ShowMissionPTD(playerid, 0, 4);

			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
			ClearAnims(playerid);
			
			DisablePlayerCheckpoint(playerid);
			DisablePlayerRaceCheckpoint(playerid);
			gpss[playerid] = 0;

			SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Спустя 1 год тут все улеглось. Начните свою историю и забудьте о прошлом!");
			SendClientMessage(playerid, COLOR_GREY, ""NO"*"G" Вы успешно закончили квестовую линию от Мэйсона, поздравляем!");
		}

		case 2: { // садится в самолет
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
			ClearAnims(playerid);

			GiveMoney(playerid, QUESTS_AWARD_MONEY_8, "от мейсона (8)");

			PI[playerid][pQuestStatus_Mason][7] = 1;
			TogglePlayerControllable(playerid, false);

			for(new td_id = 0; td_id < sizeof(MissionLineTD) - 1; td_id++)
				TextDrawShowForPlayer(playerid, MissionLineTD[td_id]);

			SetPlayerPosAC(playerid, 1664.8634, -2472.5903, 13.5547,  2, 0);
			SetPlayerFacingAngle(playerid, 90.0);
			ApplyAnimation(playerid, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 1);

			InterpolateCameraPos(playerid, 1702.728, -2437.495, 16.942, 1674.778, -2491.183, 16.933, 10000);
			InterpolateCameraLookAt(playerid, 1697.950, -2438.968, 16.899, 1671.824, -2487.149, 16.980, 10000);

			quests_PI[playerid][pQuestTimer] = SetTimerEx("QuestLastMissionTimer", 7500, false, "ii", playerid, 3);
		}
		case 3: {
			TogglePlayerControllable(playerid, true);
			TextDrawShowForPlayer(playerid, MissionLineTD[2]);

			quests_PI[playerid][pQuestTimer] = SetTimerEx("QuestLastMissionTimer", (2 * 1000), false, "ii", playerid, 0);
		}
	}
}
forward quests_MissionAlexDialog(playerid);
public quests_MissionAlexDialog(playerid) {
	SetCameraBehindPlayer(playerid);
}
stock quests_CreateBoat(playerid) {
	if (0 != quests_PI[playerid][pBoatSpawnID]) 
		return true;
	new vehicle_id = -1;

	for(new i = 0; i < MAX_QUEST_VEHICLE; i++) {
		if (quests_VehicleData[i][qvVehicleID] != INVALID_VEHICLE_ID) continue;
		vehicle_id = i;
		break;
	}
	if (vehicle_id == -1) return false;

	new vehicleid = A_CreateVehicle(453, 
		quests_VehicleData[vehicle_id][qvSpawnPos][0], quests_VehicleData[vehicle_id][qvSpawnPos][1], 
		quests_VehicleData[vehicle_id][qvSpawnPos][2], quests_VehicleData[vehicle_id][qvSpawnPos][3], 
		150, -1, -1, VEHICLE_TYPE_QUEST_BOAT
	);
	quests_VehicleData[vehicle_id][qvVehicleID] = vehicleid;
	for(new i = 0; i < MAX_QUEST_VEHICLE_OBJECT; i++) {
		if (i == MAX_QUEST_VEHICLE_OBJECT - 1) {
			quests_VehicleData[vehicle_id][qvObjectID][i] = CreateDynamicObject(19373,
				0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, 0, 0, -1, 50.0, 50.0
			);
			SetDynamicObjectMaterial(quests_VehicleData[vehicle_id][qvObjectID][i], 0, 18773, "tunnelsections", "stonewall4", -1);
		}
		else {
			quests_VehicleData[vehicle_id][qvObjectID][i] = CreateDynamicObject(2969,
				0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, 0, 0, -1, 50.0, 50.0
			);
		}
		AttachDynamicObjectToVehicle(quests_VehicleData[vehicle_id][qvObjectID][i], vehicleid, 
			AttacObjectBoatPos[i][0], AttacObjectBoatPos[i][1], AttacObjectBoatPos[i][2], 
			AttacObjectBoatPos[i][3], AttacObjectBoatPos[i][4], AttacObjectBoatPos[i][5]
		);
	}
	quests_PI[playerid][pBoatSpawnID] = (vehicle_id + 1);
	PI[playerid][pQuestProcess_Mason][5] = 2;

	if (gpss[playerid]) {
		DisablePlayerCheckpoint(playerid);
		DisablePlayerRaceCheckpoint(playerid);
		gpss[playerid] = 0;
	}
	EnableGPSForPlayer(playerid, 
		quests_VehicleData[vehicle_id][qvSpawnPos][0], quests_VehicleData[vehicle_id][qvSpawnPos][1], 
		quests_VehicleData[vehicle_id][qvSpawnPos][2], 2.0
	);
	SendClientMessage(playerid, COLOR_GREY, ""NO"* [Подсказка]"G" Отправляйтесь к красной метке, там стоит лодка.");

	return true;
}
/*stock quests_DestroyBoxFromBoat(playerid, vehicle_id) {
	for(new i = MAX_QUEST_VEHICLE_OBJECT - 1; i != -1; i--) {
		if (quests_VehicleData[vehicle_id][qvObjectID][i] == -1) continue;
		DestroyDynamicObject(quests_VehicleData[vehicle_id][qvObjectID][i]);
		quests_VehicleData[vehicle_id][qvObjectID][i] = -1;
	}
	return true;
}*/
/*-


quests_PI[playerid][pCopObjectID] = CreateDynamicObject(3092, 
	2334.132324, -1189.164550, 27.246953, 90.000000, 90.000000, 8.099998, 
	0, 0, playerid, 100.00, 100.00
);
*/
stock UpdateQuests(playerid) {
	if (1 <= PI[playerid][pQuestCurrentID] <= 8) {
		new questid = (PI[playerid][pQuestCurrentID] - 1);
		if (questid != 1 && PI[playerid][pQuestProcess_Mason][questid]) PI[playerid][pQuestProcess_Mason][questid] = 0;
		PI[playerid][pQuestCurrentID] = (GetPlayerQuestCompleted(playerid, QUESTS_TYPE_MASON));
	}
	MYSQL_GLOBAL[0] = EOS, format(MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE `accounts` SET \
		`quests_currentid` = '%i', \
		`quests_mason_status` = '%d,%d,%d,%d,%d,%d,%d,%d', \
		`quests_mason_process` = '%d,%d,%d,%d,%d,%d,%d,%d' \
		WHERE `pID` = '%d'", 
		PI[playerid][pQuestCurrentID],
		PI[playerid][pQuestStatus_Mason][0], PI[playerid][pQuestStatus_Mason][1], PI[playerid][pQuestStatus_Mason][2], 
		PI[playerid][pQuestStatus_Mason][3], PI[playerid][pQuestStatus_Mason][4], PI[playerid][pQuestStatus_Mason][5],
		PI[playerid][pQuestStatus_Mason][6], PI[playerid][pQuestStatus_Mason][7],
		PI[playerid][pQuestProcess_Mason][0], PI[playerid][pQuestProcess_Mason][1], PI[playerid][pQuestProcess_Mason][2], 
		PI[playerid][pQuestProcess_Mason][3], PI[playerid][pQuestProcess_Mason][4], PI[playerid][pQuestProcess_Mason][5],
		PI[playerid][pQuestProcess_Mason][6], PI[playerid][pQuestProcess_Mason][7],
		PI[playerid][pID]
	);
	mysql_pquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;
}