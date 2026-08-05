#if defined _key_minigame_inc
	#endinput
#endif
#define _key_minigame_inc

enum {
	KEY_MINIGAME_NONE = 0,
	KEY_MINIGAME_BREAK_CONTAINER = 1,
	KEY_MINIGAME_FIND_SCRAP,
}
enum {
	KEY_MINIGAME_STOP_NONE = 0,
	KEY_MINIGAME_STOP_ERROR,
	KEY_MINIGAME_STOP_SUCCESS,
}
static const KeyMinigameRandomKeys[] = { KEY_YES, KEY_NO, KEY_CTRL_BACK };

enum KEY_MINIGAME_e {
	pMinigameType,
	pMinigameKey,
	Float:pMinigameProgress,
	Float:pMinigameProgressValue,
	pMinigameContainerID,
}
new KeyMinigameInfo[MAX_PLAYERS][KEY_MINIGAME_e];

stock UpdateKeyMinigameProgress(playerid, stop_type = 0) {
	new type = KeyMinigameInfo[playerid][pMinigameType];
	if (!type) return;
	switch (type) {
		case KEY_MINIGAME_BREAK_CONTAINER, KEY_MINIGAME_FIND_SCRAP: {
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 1, 1);
		}
	}
	if (KeyMinigameInfo[playerid][pMinigameProgress] >= 100.0) {
		OnKeyMinigameEnd(playerid, KEY_MINIGAME_STOP_SUCCESS);
		return;
	}
	else if (KeyMinigameInfo[playerid][pMinigameProgress] < 0.0 || stop_type == KEY_MINIGAME_STOP_ERROR) {
		OnKeyMinigameEnd(playerid, KEY_MINIGAME_STOP_ERROR);
		return;
	}
	new progress = floatround(KeyMinigameInfo[playerid][pMinigameProgress] / 10.0);
	switch (progress) {
		case 0: {
			PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][1], "~w~IIIIIIIIII");
		}
		case 1..9: {
			new 
				minigameStr[20], 
				successValue = 10 - progress;

			for (new i = 0; i < progress; i++) {
				if (i == 0) strcat(minigameStr, "~g~I");
				else strcat(minigameStr, "I");
			}
			for (new i = 0; i < successValue; i++) {
				if (i == 0) strcat(minigameStr, "~w~I");
				else strcat(minigameStr, "I");
			}
			PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][1], minigameStr);
		}
		default: {
			PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][1], "~g~IIIIIIIIII");
		}
	}
	KeyMinigameInfo[playerid][pMinigameKey] = KeyMinigameRandomKeys[random(sizeof (KeyMinigameRandomKeys))];

	PlayerTextDrawFont(playerid, YandNsysTDPlayer[playerid][0], 1);
	switch (KeyMinigameInfo[playerid][pMinigameKey]) {
		case KEY_YES: PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][0], "~w~PRESS_~g~Y");
		case KEY_NO: PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][0], "~w~PRESS_~g~N");
		case KEY_CTRL_BACK: PlayerTextDrawSetString(playerid, YandNsysTDPlayer[playerid][0], "~w~PRESS_~g~H");
	}
	PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][0]);
}
km_OnPlayerKeyStateChange(playerid, newkeys) {
	new type = KeyMinigameInfo[playerid][pMinigameType];
	if (!type || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return false;

	if (newkeys & KeyMinigameRandomKeys[0] || newkeys & KeyMinigameRandomKeys[1] || newkeys & KeyMinigameRandomKeys[2]) {
		if (newkeys & KeyMinigameInfo[playerid][pMinigameKey]) {
			KeyMinigameInfo[playerid][pMinigameProgress] += KeyMinigameInfo[playerid][pMinigameProgressValue];
		} else {
			KeyMinigameInfo[playerid][pMinigameProgress] -= KeyMinigameInfo[playerid][pMinigameProgressValue];
		}
		UpdateKeyMinigameProgress(playerid);
		return true;
	}
	return false;
}
stock StartKeyMinigame(playerid, type, extra_id = 0) {
	if (KeyMinigameInfo[playerid][pMinigameType]) return 0;
	TogglePlayerControllable(playerid, false);
	SetPlayerArmedWeapon(playerid, 0);
	switch (type) {
		case KEY_MINIGAME_BREAK_CONTAINER: {
			KeyMinigameInfo[playerid][pMinigameContainerID] = extra_id;
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 1, 1);
			KeyMinigameInfo[playerid][pMinigameProgressValue] = 5.0;
			ErrorMessage(playerid, "Вы начали процесс вскрытия дверей контенейра!");
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 18634, 6, 0.073, 0.026, 0.000, 112.300, -112.200, 9.800, 1.000, 1.000, 0.704);// дали кирку
			SetPlayerPosAC(playerid, 
				CargoContainerInfo[extra_id][containerBreakPos][0], CargoContainerInfo[extra_id][containerBreakPos][1], CargoContainerInfo[extra_id][containerBreakPos][2]
			);
			SetPlayerFaceToPoint(playerid, CargoContainerInfo[extra_id][containerPos][0], CargoContainerInfo[extra_id][containerPos][1]);
		}
		case KEY_MINIGAME_FIND_SCRAP: {
			KeyMinigameInfo[playerid][pMinigameContainerID] = extra_id;
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 1, 1, 1);
			KeyMinigameInfo[playerid][pMinigameProgressValue] = 20.0;
			ErrorMessage(playerid, "Вы начали искать лом!");
			SetPlayerPosAC(playerid, 
				CargoShipFindScrapPos[extra_id][0], CargoShipFindScrapPos[extra_id][1], CargoShipFindScrapPos[extra_id][2]
			);
			SetPlayerFacingAngle(playerid, CargoShipFindScrapPos[extra_id][3]);
		}
	}
	PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);

	KeyMinigameInfo[playerid][pMinigameProgress] = 0.0;
	KeyMinigameInfo[playerid][pMinigameType] = type;
	UpdateKeyMinigameProgress(playerid);

	for (new td_id = 0; td_id < sizeof (YandNsysTD); td_id++) {
		TextDrawShowForPlayer(playerid, YandNsysTD[td_id]);
		if (td_id < 2) PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][td_id]);
	}
	return type;
}
OnKeyMinigameEnd(playerid, stop_type = KEY_MINIGAME_STOP_NONE) {
	new type = KeyMinigameInfo[playerid][pMinigameType];
	switch (type) {
		case KEY_MINIGAME_FIND_SCRAP: {
			switch (stop_type) {
				case KEY_MINIGAME_STOP_SUCCESS: {
					if (random(100) >= (100 - CARGO_FIND_SCRAP_CHANCE)) {
						GivePlayerItem(playerid, 504, 1);
						ErrorMessage(playerid, "Вы нашли лом!");
					} else {
						ErrorMessage(playerid, "Не удалось найти лом, попробуйте поискать еще!");
					}
				}
			}
		}
		case KEY_MINIGAME_BREAK_CONTAINER: {
			switch (stop_type) {
				case KEY_MINIGAME_STOP_SUCCESS: {
					new id = KeyMinigameInfo[playerid][pMinigameContainerID];
					if (!CargoContainerInfo[id][containerStatus])  {
						if (random(100) >= (100 - CARGO_SHIP_CONTAINER_CHANCE)) {
							OpenCargoContainer(id);
							ErrorMessage(playerid, "Контейнер успешно открыт!");
						} else {
							GivePlayerItem(playerid, 504, -1);
							ErrorMessage(playerid, "Не удалось открыть контейнер, лом был сломан!");
						}
					} else {
						ErrorMessage(playerid, "Контейнер уже открыт!");
					}
					RemovePlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2);
				}
			}
		}
	}
	for (new td_id = 0; td_id < sizeof (YandNsysTD); td_id++) {
		TextDrawHideForPlayer(playerid, YandNsysTD[td_id]);
		if (td_id < 2) PlayerTextDrawHide(playerid, YandNsysTDPlayer[playerid][td_id]);
	}
	ClearAnimations(playerid, 1);
	TogglePlayerControllable(playerid, true);

	ApplyAnimation(playerid, "CARRY", "null", 1.0, 0, 0, 0, 0, 0, 0);
	PlayerClearAnim[playerid] = 1;

	KeyMinigameInfo[playerid][pMinigameProgress] = 0.0;
	KeyMinigameInfo[playerid][pMinigameType] = 0;
}