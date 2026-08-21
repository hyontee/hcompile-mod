/*
	OnTimerMinuteOne
*/

stock OnTimerMinuteOne()
{
	new
		hour, minute,
		time = gettime(hour, minute, _),
		AutoRaceType:ar_type = s_autorace_Server_Type;

	switch (s_autorace_Server_Stage) {
		case s_AutoRaceNone: {
			if ((hour == 15 || hour == 18 || hour == 21) && (minute == 30)) {
				if (ar_type == t_AutoRaceNone) {
					ar_type = (s_autorace_Server_Type = t_AutoRaceMotorbike);
					s_autorace_Server_Stage = s_AutoRaceStart;
					s_autorace_Server_Time[_:ar_type] = (time + 180);
					SendClientMessageToAll(0xFFFFFFFF, "Внимание! Начало гонок через 5 минут. Подробнее "c_s"/gps > Развлечения");
				}
			}
		}
		case s_AutoRaceStart: {
			if ((ar_type != t_AutoRaceNone)
				&& (s_autorace_Server_Time[_:ar_type] < time)) {
				s_autorace_Server_Stage = s_AutoRaceGogogo;
				s_autorace_Server_Time[_:ar_type] = (time + 120);
				SendClientMessageToAll(0xFFFFFFFF, "Внимание! Начало гонок через 2 минуты. Подробнее "c_s"/gps > Развлечения");
			}
		}
		case s_AutoRaceGogogo: {
			if ((ar_type != t_AutoRaceNone)
				&& (s_autorace_Server_Time[_:ar_type] < time)) {
				if (s_autorace_Server_Count[_:ar_type] < MIN_AUTORACE_PLAYERS) {

					new
						ar_playerid;

					s_autorace_Server_Type = t_AutoRaceNone;
					s_autorace_Server_Stage = s_AutoRaceNone;
					s_autorace_Server_Time[_:ar_type] = 0;
					for (new i = s_autorace_Server_Count[_:ar_type] - 1; i != -1; i--) {
						ar_playerid = s_autorace_Server_PlayerID[_:ar_type][i];
						if ((ar_playerid != INVALID_PLAYER_ID)
							&& ((p_autorace_Player_Type[ar_playerid] == ar_type) && (p_autorace_Player_State[ar_playerid] != AUTORACE_STATE_NONE))) {
							s_autorace_Server_PlayerID[_:ar_type][i] = INVALID_PLAYER_ID;
							p_autorace_Player_Type[ar_playerid] = t_AutoRaceNone;
							p_autorace_Player_State[ar_playerid] = AUTORACE_STATE_NONE;
							p_autorace_Player_Count{ar_playerid} = 0;
						}
					}
					s_autorace_Server_Countdown[_:ar_type] = 3;
					s_autorace_Server_Count[_:ar_type] = 0;
					SendClientMessageToAll(0xFFFFFFFF, "Внимание! Гонка отменена из-за недостаточного количества участников");
					return 1;
				}

				new
					ar_playerid;

				s_autorace_Server_Stage = s_AutoRaceNone;
				s_autorace_Server_Places[_:ar_type] = 0;
				for (new i = s_autorace_Server_Count[_:ar_type] - 1; i != -1; i--) {
					ar_playerid = s_autorace_Server_PlayerID[_:ar_type][i];
					if ((ar_playerid != INVALID_PLAYER_ID)
						&& ((p_autorace_Player_Type[ar_playerid] == ar_type) && (p_autorace_Player_State[ar_playerid] == AUTORACE_STATE_ONFOOT))) {
						p_autorace_Player_State[ar_playerid] = AUTORACE_STATE_DRIVER;
						SetPlayerVirtualWorld(ar_playerid, s_autorace_Vehicle_World[_:ar_type]);
						p_autorace_Player_VehicleID[ar_playerid] = CreateVehicle(s_autorace_Vehicle_Model[_:ar_type], s_autorace_Vehicle_PosS[_:ar_type][i][0], s_autorace_Vehicle_PosS[_:ar_type][i][1], s_autorace_Vehicle_PosS[_:ar_type][i][2], s_autorace_Vehicle_PosS[_:ar_type][i][3], random(128), random(128), -1);
						SetVehicleVirtualWorld(p_autorace_Player_VehicleID[ar_playerid], s_autorace_Vehicle_World[_:ar_type]);
						PutPlayerInVehicle(ar_playerid, p_autorace_Player_VehicleID[ar_playerid], 0);
						p_autorace_Player_RaceCPID[ar_playerid] = CreateDynamicRaceCP(0, s_autorace_RaceCP_PosS[_:ar_type][0][0], s_autorace_RaceCP_PosS[_:ar_type][0][1], s_autorace_RaceCP_PosS[_:ar_type][0][2],
																						s_autorace_RaceCP_PosS[_:ar_type][1][0], s_autorace_RaceCP_PosS[_:ar_type][1][1], s_autorace_RaceCP_PosS[_:ar_type][1][2], 6.0, .playerid = ar_playerid, .streamdistance = FLOAT_INFINITY);
						Streamer_Update(ar_playerid, STREAMER_TYPE_RACE_CP);
						TogglePlayerControllable(ar_playerid, false);
					}
				}
				s_autorace_Server_TimerID[_:ar_type] = SetTimer("@__OnServerTimerAutoRace", 1000, false);
			}
		}
	}
	return 1;
}

/*
	OnPlayerDisconnectAndSpawn
*/

stock OnPlayerDisconnectAndSpawn(playerid, reason)
{
	new
		AutoRaceType:ar_type = p_autorace_Player_Type[playerid];

	if ((ar_type != t_AutoRaceNone)
		|| (p_autorace_Player_State[playerid] != AUTORACE_STATE_NONE)) {

		// LONEXS FIX: old code used s_autorace_Server_Count as an array index during
		// disconnect. When a player crashed/kicked from registration it wrote to
		// p_autorace_Player_Count{INVALID_PLAYER_ID}, corrupted memory and could
		// freeze every connected player.
		if (_:ar_type < 0 || _:ar_type >= MAX_AUTORACES) {
			p_autorace_Player_Type[playerid] = t_AutoRaceNone;
			p_autorace_Player_State[playerid] = AUTORACE_STATE_NONE;
			p_autorace_Player_Count{playerid} = 0;
			return 1;
		}

		new ar_slot = p_autorace_Player_Count{playerid};

		if (p_autorace_Player_State[playerid] == AUTORACE_STATE_ONFOOT) {
			new ar_last = s_autorace_Server_Count[_:ar_type] - 1;

			if (ar_last < 0) {
				s_autorace_Server_Count[_:ar_type] = 0;
			}
			else if (ar_slot >= 0 && ar_slot < MAX_AUTORACE_VEHICLES && ar_last < MAX_AUTORACE_VEHICLES) {
				new ar_playerid = s_autorace_Server_PlayerID[_:ar_type][ar_last];
				s_autorace_Server_PlayerID[_:ar_type][ar_slot] = ar_playerid;
				s_autorace_Server_PlayerID[_:ar_type][ar_last] = INVALID_PLAYER_ID;

				if (ar_playerid != INVALID_PLAYER_ID && IsPlayerConnected(ar_playerid))
				{
					p_autorace_Player_Count{ar_playerid} = ar_slot;
				}
				s_autorace_Server_Count[_:ar_type] = ar_last;
			}
		}
		else {
			if (ar_slot >= 0 && ar_slot < MAX_AUTORACE_VEHICLES) {
				s_autorace_Server_PlayerID[_:ar_type][ar_slot] = INVALID_PLAYER_ID;
			}
		}
		p_autorace_Player_Type[playerid] = t_AutoRaceNone;
		p_autorace_Player_State[playerid] = AUTORACE_STATE_NONE;
		p_autorace_Player_Count{playerid} = 0;
		if (p_autorace_Player_VehicleID[playerid] != INVALID_VEHICLE_ID) {
			DestroyVehicle(p_autorace_Player_VehicleID[playerid]);
			p_autorace_Player_VehicleID[playerid] = INVALID_VEHICLE_ID;
		}
		if (p_autorace_Player_RaceCPID[playerid] != INVALID_STREAMER_ID) {
			DestroyDynamicRaceCP(p_autorace_Player_RaceCPID[playerid]);
			p_autorace_Player_RaceCPID[playerid] = INVALID_STREAMER_ID;
		}
		if (reason == -1) {
			SendClientMessage(playerid, 0xCECECEFF, "Вы завершили участие в гонках");
		}
	}
	return 1;
}