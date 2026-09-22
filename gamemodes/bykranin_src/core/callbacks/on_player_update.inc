//>> Файл: bykranin_src/core/callbacks/on_player_update.inc  (506 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerUpdate
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerUpdate(playerid)
{
    g_sync_update_tick[playerid] = GetTickCount();
    FireExtVisual_Update(playerid);
	FixBugMoneyMinus(playerid);
    TuningStreamWatch_OnPlayerUpdate(playerid);
	SetPlayerData(playerid, P_AFK_TIME, 0);

	// TC hard trailer lock: if route sync drops the trailer at any angle, attach it
	// back immediately instead of waiting for the old multi-second recovery cycle.
	if(p_tc_order_progress[playerid] >= 2)
		TC_ForceTrailerLock(playerid, true);

    // Poll proximity hints at 2 Hz; gameplay checks below stay per-update.
    new hint_tick = GetTickCount();
    if(hint_tick - g_stability_hint_tick[playerid] >= 500)
    {
        g_stability_hint_tick[playerid] = hint_tick;
        HRDepartment_UpdateNotification(playerid);

        // V11 container interaction realfix: Streamer area callbacks can be
        // late or skipped on some mobile builds. While the player is really
        // standing at a container, refresh the same interaction button used
        // by action 18. The leave callback still hides it normally.
        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && ContNewSystem_GetNearestContainer(playerid) != 0)
        {
            ToggleInteractionWindow(playerid, true);
        }

        if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
        {
            new near_vehicle = INVALID_VEHICLE_ID;
            if(TrunkTest_GetNearbyPersonalVehicle(playerid, near_vehicle, 4.5))
            {
                new now_tick = GetTickCount();
                new lock_status = GetVehicleParam(near_vehicle, V_LOCK);

                if(lock_status)
                {
                    new exit_tick = GetPVarInt(playerid, PVAR_CARLOCK_EXIT_TICK);
                    new lock_hint_vehicle = GetPVarInt(playerid, PVAR_CARLOCK_HINT_VEHICLE);

                    if((exit_tick <= 0 || (now_tick - exit_tick) >= 11000) && (lock_hint_vehicle != near_vehicle || !GetPVarInt(playerid, PVAR_CARLOCK_HINT_SHOWN)))
                    {
                        ShowNotificationNew(playerid, 5, 10, 9102, near_vehicle, "Двери автомобиля закрыты", "ОТКРЫТЬ");
                        SetPVarInt(playerid, PVAR_CARLOCK_HINT_SHOWN, 1);
                        SetPVarInt(playerid, PVAR_CARLOCK_HINT_VEHICLE, near_vehicle);
                        SetPVarInt(playerid, PVAR_CARLOCK_HINT_TICK, now_tick);
                    }
                }
                else
                {
                    DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
                    DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
                    DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
                }

                if(TrunkTest_IsPlayerNearVehicleRear(playerid, near_vehicle, 2.8))
                {
                    new exit_trunk_tick = GetPVarInt(playerid, PVAR_TRUNKTEST_EXIT_TICK);
                    new trunk_hint_vehicle = GetPVarInt(playerid, PVAR_TRUNKTEST_HINT_VEHICLE);

                    if((exit_trunk_tick <= 0 || (now_tick - exit_trunk_tick) >= 5000) && (trunk_hint_vehicle != near_vehicle || !GetPVarInt(playerid, PVAR_TRUNKTEST_HINT_SHOWN)))
                    {
                        ShowNotificationNew(playerid, 5, 10, 9101, near_vehicle, "Багажник транспорта закрыт", "ОТКРЫТЬ");
                        SetPVarInt(playerid, PVAR_TRUNKTEST_HINT_SHOWN, 1);
                        SetPVarInt(playerid, PVAR_TRUNKTEST_HINT_VEHICLE, near_vehicle);
                        SetPVarInt(playerid, PVAR_TRUNKTEST_HINT_TICK, now_tick);
                    }
                }
                else
                {
                    DeletePVar(playerid, PVAR_TRUNKTEST_HINT_SHOWN);
                    DeletePVar(playerid, PVAR_TRUNKTEST_HINT_VEHICLE);
                    DeletePVar(playerid, PVAR_TRUNKTEST_HINT_TICK);
                }
            }
            else if(GetPVarInt(playerid, PVAR_TRUNKTEST_HINT_SHOWN) || GetPVarInt(playerid, PVAR_CARLOCK_HINT_SHOWN))
            {
                DeletePVar(playerid, PVAR_TRUNKTEST_HINT_SHOWN);
                DeletePVar(playerid, PVAR_TRUNKTEST_HINT_VEHICLE);
                DeletePVar(playerid, PVAR_TRUNKTEST_HINT_TICK);
                DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
                DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
                DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
            }
        }
        else if(GetPVarInt(playerid, PVAR_TRUNKTEST_HINT_SHOWN) || GetPVarInt(playerid, PVAR_CARLOCK_HINT_SHOWN))
        {
            DeletePVar(playerid, PVAR_TRUNKTEST_HINT_SHOWN);
            DeletePVar(playerid, PVAR_TRUNKTEST_HINT_VEHICLE);
            DeletePVar(playerid, PVAR_TRUNKTEST_HINT_TICK);
            DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
            DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
            DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
        }

    }
	new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;
	if((IsPlayerInGovernmentInteriorGreenZone(playerid) && !(IsPlayerInPoliceTeam(playerid) && GetPlayerWeapon(playerid) == WEAPON_NITESTICK)) ||
		(green_zone_id >= 0 && green_zone_id < g_green_zones_loaded && g_green_zones[green_zone_id][GZ_NO_WEAPON]))
	{
		new current_weapon = GetPlayerWeapon(playerid);
		if(current_weapon != 0)
		{
			SetPlayerArmedWeapon(playerid, 0);
		}
	}
	
	// CreateLogo is disabled. Do not send text to unassigned textdraw ID 0.
	if(logo_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW && g_stability_logo_power[playerid] != Config[sDonPower])
	{
		new string[50];
		format(string, sizeof string, "X%d", Config[sDonPower]);
		PlayerTextDrawSetString(playerid, logo_PTD[playerid][0], string);
		g_stability_logo_power[playerid] = Config[sDonPower];
	}
	new online = Iter_Count(Player);
	if(logo_PTD[playerid][1] != PlayerText:INVALID_TEXT_DRAW && g_stability_logo_online[playerid] != online)
	{
		new string[50];
		format(string, sizeof string, "%d/1000", online);
		PlayerTextDrawSetString(playerid, logo_PTD[playerid][1], string);
		g_stability_logo_online[playerid] = online;
	}
	
	/*if(IsPlayerInRangeOfPoint(playerid, 3.0, 609.434875,1729.022583,12.078809))
	{
	    vz(playerid);
	    
	}
	
	if(IsPlayerInRangeOfPoint(playerid, 3.0, 617.468688,1729.151977,12.078809))
	{
	    vz(playerid);

	}*/

	if(IsPlayerDriver(playerid))
	{
		new keys, gas_brake, left_right;

		GetPlayerKeys(playerid, keys, gas_brake, left_right);

		// SendClientMessage(playerid, -1, IntToString(gas_brake));

		new pedal_type = PEDAL_TYPE_NONE;

		if((keys & KEY_SPRINT) && !(keys & KEY_JUMP || keys & KEY_HANDBRAKE))
			pedal_type = PEDAL_TYPE_GAS;

		else if(keys & KEY_JUMP && !(keys & KEY_SPRINT || keys & KEY_HANDBRAKE))
			pedal_type = PEDAL_TYPE_BRAKE;

		player_press_pedal[playerid] = pedal_type;

		new vehicleid = GetPlayerVehicleID(playerid);

        if(vehicleid != INVALID_VEHICLE_ID && IsAOwnableCar(vehicleid))
        {
            new ownable_index = GetVehicleData(vehicleid, V_ACTION_ID);
            if(ownable_index >= 0 && ownable_index < MAX_OWNABLE_CARS)
            {
                new Float:v_speed = floatabs(GetVehicleSpeed(vehicleid));
                new bool:auto_lock_enabled = ((GetOwnableCarData(ownable_index, OC_PDVRADAR) & OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED) == 0);

                if(auto_lock_enabled && v_speed >= 70.0 && !GetVehicleParam(vehicleid, V_LOCK))
                {
                    if(!GetPVarInt(playerid, "car_autolock_by_speed"))
                    {
                        SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_ON);
                        SetPVarInt(playerid, "car_autolock_by_speed", 1);
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Транспорт был автоматически закрыт", " ");
                        PlayAudioStreamURL(playerid, "vehicle_sound_door.mp3");
                    }
                }
                else if(v_speed < 65.0 || !GetVehicleParam(vehicleid, V_LOCK))
                {
                    DeletePVar(playerid, "car_autolock_by_speed");
                }
            }
        }
	}
	if(gPlayerBlockedPickup[playerid] != -1 && !IsValidDynamicPickup(gPlayerBlockedPickup[playerid]))
        gPlayerBlockedPickup[playerid] = -1;
	if (gPlayerBlockedPickup[playerid] != -1)
    {
        new Float:px, Float:py, Float:pz;
        new Float:x, Float:y, Float:z;

        GetPlayerPos(playerid, px, py, pz);

        Streamer_GetFloatData(STREAMER_TYPE_PICKUP, gPlayerBlockedPickup[playerid], E_STREAMER_X, x);
        Streamer_GetFloatData(STREAMER_TYPE_PICKUP, gPlayerBlockedPickup[playerid], E_STREAMER_Y, y);
        Streamer_GetFloatData(STREAMER_TYPE_PICKUP, gPlayerBlockedPickup[playerid], E_STREAMER_Z, z);

        if (GetPlayerDistanceFromPoint(playerid, x, y, z) > 2.0)
        {
            gPlayerBlockedPickup[playerid] = -1;
        }
    }

	if(GetPlayerTempJobCheckAnim(playerid))
	{
		new anim_index = GetPlayerAnimationIndex(playerid);

		/*
			new fmt_str[32];

			format(fmt_str, sizeof fmt_str, "index: %d", anim_index);
			SendClientMessage(playerid, 0xCECECEFF, fmt_str);
		*/

		switch(GetPlayerTempJob(playerid))
		{
			case TEMP_JOB_LOADER:
			{
				if(!GetPlayerSex(playerid))
				{
					if(!(anim_index == 259 || anim_index == 1189 || anim_index == 1224))
					{
						anim_index = -1;
					}
				}
					else
				{
					if(!(anim_index == 259 || anim_index == 260 || anim_index == 1275 || anim_index == 1276 || anim_index == 1289))
					{
						anim_index = -1;
					}
				}

				if(anim_index == -1)
				{
					SetPlayerTempJobCheckAnim(playerid, false);
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LOADER_DROP_LOAD);
				}
			}
			case TEMP_JOB_MINER:
			{
				if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_UNLOAD)
				{
					if(!(anim_index == 616 || anim_index == 1189 || anim_index == 1224))
						SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_DROP_LOAD);
				}
			}
			case TEMP_JOB_FACTORY:
			{
				if(!GetPlayerSex(playerid))
				{
					if(!(anim_index == 259 || anim_index == 949 || anim_index == 1189 || anim_index == 1224 || anim_index == 1257 || anim_index == 1269))
					{
						anim_index = -1;
					}
				}
					else
				{
					if(!(anim_index == 259 || anim_index == 1196 || anim_index == 1275 || anim_index == 1276 || anim_index == 1269 || anim_index == 1283))
					{
						anim_index = -1;
					}
				}

				if(anim_index == -1)
				{
					SetPlayerTempJobCheckAnim(playerid, false);
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_DROP_P);
				}
			}
			case TEMP_JOB_LUMBERJACK:
			{
				if(!(anim_index == 1189 || anim_index == 1224 || anim_index == 260 || anim_index == 1275 || anim_index == 1276))
				{
					anim_index = -1;
				}

				if(anim_index == -1)
					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_DROP);
			}
			default:
			{
				SetPlayerTempJobCheckAnim(playerid, false);
			}
		}
	}
	/*
	if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_UNLOAD)
		{
			new anim_idx = GetPlayerAnimationIndex(playerid);

			if(!(anim_idx == 616 || anim_idx == 1189 || anim_idx == 1224))
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_DROP_LOAD);
		}
	}
	*/
	if(GetPVarInt(playerid, "test") == 1)
	{
		new fmt_str[64];

		format(fmt_str, sizeof fmt_str, "a_index: %d", GetPlayerAnimationIndex(playerid));
		SendClientMessage(playerid, 0xCECECEFF, fmt_str);
	}


	if(GetPlayerWeaponState(playerid) == 2) SetPlayerData(playerid, P_WEAPON_RELOADING, false);
	if(GetPlayerWeaponState(playerid) == 3 && !GetPlayerData(playerid, P_WEAPON_RELOADING))
	{
		SetPlayerData(playerid, P_WEAPON_RELOADING, true);

		switch(GetPlayerWeapon(playerid))
		{
			case 22:
			{
				if(GetPlayerData(playerid, P_SKILL_COLT) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][0]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[0] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][0] = 0;

						AddPlayerData(playerid, P_SKILL_COLT, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_colt", GetPlayerData(playerid, P_SKILL_COLT));

						SetPlayerSkillLevel(playerid, 0, GetPlayerData(playerid, P_SKILL_COLT) * 10);
					}
				}
			}
			case 23:
			{
				if(GetPlayerData(playerid, P_SKILL_SDPISTOL) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][1]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[1] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][1] = 0;

						AddPlayerData(playerid, P_SKILL_SDPISTOL, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_sdpistol", GetPlayerData(playerid, P_SKILL_SDPISTOL));

						SetPlayerSkillLevel(playerid, 1, GetPlayerData(playerid, P_SKILL_SDPISTOL) * 10);
					}
				}
			}
			case 24:
			{
				if(GetPlayerData(playerid, P_SKILL_DEAGLE) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][2]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[2] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][2] = 0;

						AddPlayerData(playerid, P_SKILL_DEAGLE, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_deagle", GetPlayerData(playerid, P_SKILL_DEAGLE));

						SetPlayerSkillLevel(playerid, 2, GetPlayerData(playerid, P_SKILL_DEAGLE) * 10);
					}
				}
			}
			case 25:
			{
				if(GetPlayerData(playerid, P_SKILL_SHOTGUN) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][3]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[3] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][3] = 0;

						AddPlayerData(playerid, P_SKILL_SHOTGUN, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_shotgun", GetPlayerData(playerid, P_SKILL_SHOTGUN));

						SetPlayerSkillLevel(playerid, 3, GetPlayerData(playerid, P_SKILL_SHOTGUN) * 10);
					}
				}
			}
			case 29:
			{
				if(GetPlayerData(playerid, P_SKILL_MP5) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][4]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[4] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][4] = 0;

						AddPlayerData(playerid, P_SKILL_MP5, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_mp5", GetPlayerData(playerid, P_SKILL_MP5));

						SetPlayerSkillLevel(playerid, 7, GetPlayerData(playerid, P_SKILL_MP5) * 10);
					}
				}
			}
			case 30:
			{
				if(GetPlayerData(playerid, P_SKILL_AK47) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][5]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[5] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][5] = 0;

						AddPlayerData(playerid, P_SKILL_AK47, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_ak47", GetPlayerData(playerid, P_SKILL_AK47));

						SetPlayerSkillLevel(playerid, 8, GetPlayerData(playerid, P_SKILL_AK47) * 10);
					}
				}
			}
			case 31:
			{
				if(GetPlayerData(playerid, P_SKILL_M4) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][6]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[6] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][6] = 0;

						AddPlayerData(playerid, P_SKILL_M4, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_m4", GetPlayerData(playerid, P_SKILL_M4));

						SetPlayerSkillLevel(playerid, 9, GetPlayerData(playerid, P_SKILL_M4) * 10);
					}
				}
			}
			case 34:
			{
				if(GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][7]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[7] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][7] = 0;

						AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));

						SetPlayerSkillLevel(playerid, 10, GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE) * 10);
					}
				}
			}
			case 26:
			{
				if(GetPlayerData(playerid, P_SKILL_SAWNOFF) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][8]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[8] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][8] = 0;

						AddPlayerData(playerid, P_SKILL_SAWNOFF, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_sawnoff", GetPlayerData(playerid, P_SKILL_SAWNOFF));

						SetPlayerSkillLevel(playerid, 4, GetPlayerData(playerid, P_SKILL_SAWNOFF) * 10);
					}
				}
			}
			case 27:
			{
				if(GetPlayerData(playerid, P_SKILL_COMBAT_SG) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][9]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[9] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][9] = 0;

						AddPlayerData(playerid, P_SKILL_COMBAT_SG, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_combat_sg", GetPlayerData(playerid, P_SKILL_COMBAT_SG));

						SetPlayerSkillLevel(playerid, 5, GetPlayerData(playerid, P_SKILL_COMBAT_SG) * 10);
					}
				}
			}
			case 28:
			{
				if(GetPlayerData(playerid, P_SKILL_MICRO_UZI) < 100)
				{
					g_player[playerid][P_RELOADINGS_COUNT][10]++;

					if(GetPlayerData(playerid, P_RELOADINGS_COUNT)[10] == 3)
					{
						g_player[playerid][P_RELOADINGS_COUNT][10] = 0;

						AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, 1);
						UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));

						SetPlayerSkillLevel(playerid, 6, GetPlayerData(playerid, P_SKILL_MICRO_UZI) * 10);
					}
				}
			}
		}
	}
	return 1;
}

