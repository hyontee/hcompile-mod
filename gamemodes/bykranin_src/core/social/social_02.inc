//>> ‘айл: bykranin_src/core/social/social_02.inc  (567 строк)
//>> “ема: телефон, чаты, объ€влени€, справка
//>> ¬нутри: CreateAutoMarketForPlayer, CreateAutoTuningForPlayer, IntToString, SendMessageInCasinoTableChat, SendMessageInChat, ChatMessageInit, SetPlayerChatInit
//>> ‘айл подключаетс€ из gamemodes/bykranin.pwn; пор€док include мен€ть нельз€ (см. bykranin_src/GUIDE.md).
stock CreateAutoMarketForPlayer(playerid)
{
	buy_menu_PTD[playerid] = CreatePlayerTextDraw(playerid, 317.600006, 347.199920, "---");
	PlayerTextDrawLetterSize(playerid, buy_menu_PTD[playerid], 0.346798, 1.861333);
	PlayerTextDrawAlignment(playerid, buy_menu_PTD[playerid], 2);
	PlayerTextDrawColor(playerid, buy_menu_PTD[playerid], -1);
	PlayerTextDrawSetShadow(playerid, buy_menu_PTD[playerid], 1);
	PlayerTextDrawSetOutline(playerid, buy_menu_PTD[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, buy_menu_PTD[playerid], 51);
	PlayerTextDrawFont(playerid, buy_menu_PTD[playerid], 2);
	PlayerTextDrawSetProportional(playerid, buy_menu_PTD[playerid], 1);

	buy_car_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 454.400146, 120.213172, "ABПO #0");
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][0], 0.593998, 2.406393);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][0], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][0], 1);

	buy_car_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 536.799865, 145.599868, "~b~~h~ЙEмA: 0 P~n~МPOАEВ: 0 km~n~~b~~h~CKOPOCПТ: 0 km/h~n~KЗACC: -");
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][1], 0.365597, 1.764965);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][1], 2);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][1], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][1], 1);

	buy_car_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 521.0, 226.916687, "ЙBEП  ");
	PlayerTextDrawTextSize(playerid, buy_car_PTD[playerid][2], 521.0 + 30.0, 7.0);	 // ----------------------
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][2], 0.180999, 0.975832);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][2], -1);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][2], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, buy_car_PTD[playerid][2], true);

	buy_car_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 475.5, 239.4, "_");
	PlayerTextDrawTextSize(playerid, buy_car_PTD[playerid][3], 475.5 + 36.5, 34.0);
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][3], 1.0, 4.1);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][3], -1);
	PlayerTextDrawUseBox(playerid, buy_car_PTD[playerid][3], true);
	PlayerTextDrawBoxColor(playerid, buy_car_PTD[playerid][3], 255);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][3], 1);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][3], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, buy_car_PTD[playerid][3], true);

	buy_car_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 516.5, 239.4, "_");
	PlayerTextDrawTextSize(playerid, buy_car_PTD[playerid][4], 516.5 + 36.5, 34.0);
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][4], 1.0, 4.1); // 4.108332);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][4], -1);
	PlayerTextDrawUseBox(playerid, buy_car_PTD[playerid][4], true);
	PlayerTextDrawBoxColor(playerid, buy_car_PTD[playerid][4], 255);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][4], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][4], 1);

	// ------

	buy_car_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 557.5, 239.4, "_");
	PlayerTextDrawTextSize(playerid, buy_car_PTD[playerid][5], 557.5 + 36.5, 34.0);
	PlayerTextDrawLetterSize(playerid, buy_car_PTD[playerid][5], 1.0, 4.1);
	PlayerTextDrawAlignment(playerid, buy_car_PTD[playerid][5], 1);
	PlayerTextDrawColor(playerid, buy_car_PTD[playerid][5], -1);
	PlayerTextDrawUseBox(playerid, buy_car_PTD[playerid][5], true);
	PlayerTextDrawBoxColor(playerid, buy_car_PTD[playerid][5], 255);
	PlayerTextDrawSetShadow(playerid, buy_car_PTD[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, buy_car_PTD[playerid][5], 1);
	PlayerTextDrawBackgroundColor(playerid, buy_car_PTD[playerid][5], 51);
	PlayerTextDrawFont(playerid, buy_car_PTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_PTD[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, buy_car_PTD[playerid][5], true);
}

stock CreateAutoTuningForPlayer(playerid)
{
	change_color_PTD[0][playerid] = CreatePlayerTextDraw(playerid, 321.889190, 346.457916, "цвет 1");
	PlayerTextDrawLetterSize(playerid, change_color_PTD[0][playerid], 0.193553, 0.913064);
	PlayerTextDrawTextSize(playerid, change_color_PTD[0][playerid], 27.999996, 26.382226);
	PlayerTextDrawAlignment(playerid, change_color_PTD[0][playerid], 2);
	PlayerTextDrawColor(playerid, change_color_PTD[0][playerid], -1);
	PlayerTextDrawUseBox(playerid, change_color_PTD[0][playerid], true);
	PlayerTextDrawBoxColor(playerid, change_color_PTD[0][playerid], -256);
	PlayerTextDrawSetShadow(playerid, change_color_PTD[0][playerid], 1);
	PlayerTextDrawSetOutline(playerid, change_color_PTD[0][playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, change_color_PTD[0][playerid], 51);
	PlayerTextDrawFont(playerid, change_color_PTD[0][playerid], 2);
	PlayerTextDrawSetProportional(playerid, change_color_PTD[0][playerid], 1);
	PlayerTextDrawSetSelectable(playerid, change_color_PTD[0][playerid], true);

	change_color_PTD[1][playerid] = CreatePlayerTextDraw(playerid, 342.444366, 359.402191, "usebox");
	PlayerTextDrawLetterSize(playerid, change_color_PTD[1][playerid], 0.000000, 4.030000);
	PlayerTextDrawTextSize(playerid, change_color_PTD[1][playerid], 300.222320, 0.000000);
	PlayerTextDrawAlignment(playerid, change_color_PTD[1][playerid], 1);
	PlayerTextDrawColor(playerid, change_color_PTD[1][playerid], 0);
	PlayerTextDrawUseBox(playerid, change_color_PTD[1][playerid], true);
	PlayerTextDrawBoxColor(playerid, change_color_PTD[1][playerid], 102);
	PlayerTextDrawSetShadow(playerid, change_color_PTD[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, change_color_PTD[1][playerid], 0);
	PlayerTextDrawFont(playerid, change_color_PTD[1][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, change_color_PTD[1][playerid], true);

	change_color_PTD[2][playerid] = CreatePlayerTextDraw(playerid, 402.999755, 359.406555, "usebox");
	PlayerTextDrawLetterSize(playerid, change_color_PTD[2][playerid], 0.000000, 4.030000);
	PlayerTextDrawTextSize(playerid, change_color_PTD[2][playerid], 360.666625, 0.000000);
	PlayerTextDrawAlignment(playerid, change_color_PTD[2][playerid], 1);
	PlayerTextDrawColor(playerid, change_color_PTD[2][playerid], 0);
	PlayerTextDrawUseBox(playerid, change_color_PTD[2][playerid], true);
	PlayerTextDrawBoxColor(playerid, change_color_PTD[2][playerid], -171);
	PlayerTextDrawSetShadow(playerid, change_color_PTD[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, change_color_PTD[2][playerid], 0);
	PlayerTextDrawFont(playerid, change_color_PTD[2][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, change_color_PTD[2][playerid], true);

	change_color_PTD[3][playerid] = CreatePlayerTextDraw(playerid, 283.555328, 359.411010, "usebox");
	PlayerTextDrawLetterSize(playerid, change_color_PTD[3][playerid], 0.000000, 4.030000);
	PlayerTextDrawTextSize(playerid, change_color_PTD[3][playerid], 241.111145, 0.000000);
	PlayerTextDrawAlignment(playerid, change_color_PTD[3][playerid], 1);
	PlayerTextDrawColor(playerid, change_color_PTD[3][playerid], 0);
	PlayerTextDrawUseBox(playerid, change_color_PTD[3][playerid], true);
	PlayerTextDrawBoxColor(playerid, change_color_PTD[3][playerid], 865730389);
	PlayerTextDrawSetShadow(playerid, change_color_PTD[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, change_color_PTD[3][playerid], 0);
	PlayerTextDrawFont(playerid, change_color_PTD[3][playerid], 0);
	PlayerTextDrawSetSelectable(playerid, change_color_PTD[3][playerid], true);
}

stock IntToString(integer)
{
	new string[sizeof integer + 5];

	format(string, sizeof string, "%d", integer);

	return string;
}

stock SendMessageInCasinoTableChat(playerid, text[])
{
    new table_idx = GetNearestCasinoTable(playerid);
    if(table_idx == -1) return 0;

    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    new playerColor = GetPlayerColorEx(playerid) >>> 8;
    new msg[170];
    format(msg, sizeof msg, "{CCCCCA}[—тол %d] - %s {%06x}(%s)[%d]", table_idx + 1, text, playerColor, playerName, playerid);

    foreach(new idx : Player)
    {
        if(!IsPlayerLogged(idx)) continue;
        if(!IsPlayerInDynamicArea(idx, g_casino_area[table_idx])) continue;

        SendClientMessage(idx, 0xCECECEFF, msg);
    }

    SetPlayerChatBubble(playerid, text, 0x00CCFFFF, 30.0, 8000);

    if(!IsPlayerDriver(playerid))
    {
        if(GetPlayerData(playerid, P_USE_ANIM_TYPE) == USE_ANIM_TYPE_NONE)
        {
            ApplyAnimationEx(playerid, "PED", "IDLE_chat", 4.100, 0, 1, 1, 1, 1, 0, USE_ANIM_TYPE_CHAT);
            SetTimerEx("ClearPlayerChatAnim", strlen(text) * 400, false, "i", playerid);
        }
    }

    return 1;
}
stock SendMessageInChat(playerid, text[], Float: radius = 30.0)
{
	new Float: dist, type;
	new Float: x, Float: y, Float: z;

	GetPlayerPos(playerid, x, y, z);
	SetPlayerChatBubble(playerid, text, 0x00CCFFFF, 30.0, 8000);

	ChatMessageInit(playerid, text);
	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		dist = GetPlayerDistanceFromPoint(idx, x, y, z);

		if(dist > radius) continue;
		type = GetPlayerChatType(idx);

		switch(GetPlayerSettingData(idx, S_CHAT_TYPE))
		{
			case SETTING_CHAT_ADVANCE:
			{
				if(dist < (radius / 4))
				{
					SendClientMessage(idx, 0xCECECEFF, chat_message[type]);
				}
					else if(dist < (radius / 2))
				{
					SendClientMessage(idx, 0x999999FF, chat_message[type]);
				}
					else
				{
					SendClientMessage(idx, 0x6B6B6BFF, chat_message[type]);
				}
			}
			case SETTING_CHAT_STANDART:
			{
				if(GetPlayerSettingData(idx, S_NICK_IN_CHAT))
				{
					SendPlayerMessageToPlayer(idx, playerid, chat_message[type]);
				}
					else SendClientMessage(idx, 0xCECECEFF, text);
			}
			default: continue;
		}
	}
	if(!IsPlayerDriver(playerid))
	{
		if(GetPlayerData(playerid, P_USE_ANIM_TYPE) == USE_ANIM_TYPE_NONE)
		{
			ApplyAnimationEx(playerid, "PED", "IDLE_chat", 4.100, 0, 1, 1, 1, 1, 0, USE_ANIM_TYPE_CHAT);
			SetTimerEx("ClearPlayerChatAnim", strlen(text) * 400, false, "i", playerid);
		}
	}
	return 1;
}

stock ChatMessageInit(playerid, text[])
{
	new playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

	new playerColor = GetPlayerColorEx(playerid) >>> 8;

    format(chat_message[0], 129, "- {%06x}(%s)[%d]: %s", playerColor, playerName, playerid, text);
	format(chat_message[1], 129, "- %s {%06x}(%s)[%d]", text, playerColor, playerName, playerid); // добавил ID
	format(chat_message[2], 129, "- %s (%s)[%d]", text, playerName, playerid); // ID р€дом с ником без цвета

	format(chat_message[3], 129, "(%d): %s", playerid, text);
	format(chat_message[4], 129, "%s (%s)[%d]", text, playerName, playerid); // ѕросто текст + им€[ID]
}


stock SetPlayerChatInit(playerid)
{
	new type = 0;
	switch(GetPlayerSettingData(playerid, S_CHAT_TYPE))
	{
		case SETTING_CHAT_ADVANCE:
		{
			if(GetPlayerSettingData(playerid, S_NICK_IN_CHAT) == SETTING_TYPE_ON)
			{
				if(GetPlayerSettingData(playerid, S_ID_IN_CHAT) == SETTING_TYPE_ON)
				{
					type = 0;
				}
					else type = 1;
			}
					else type = 2;
		}
		case SETTING_CHAT_STANDART:
		{
			if(GetPlayerSettingData(playerid, S_NICK_IN_CHAT) == SETTING_TYPE_ON)
			{
				type = 3;
			}
					else type = 4;
		}
		default: type = 0;
	}
	SetPlayerChatType(playerid, type);
}

stock SetPlayerSpawnInit(playerid)
{
	if(GetPlayerData(playerid, P_JAIL) > 0)
	{
		new jail_pos = random(sizeof g_jail_positions);
		SetPlayerInterior(playerid, 1);
		SetPlayerVirtualWorld(playerid, 6);
		SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid),
			g_jail_positions[jail_pos][0], g_jail_positions[jail_pos][1], g_jail_positions[jail_pos][2] + 0.15,
			g_jail_positions[jail_pos][3], 0, 0, 0, 0, 0, 0);
		return 1;
	}

	new spawn_id = random(5);
	
	SetSpawnInfo
	(
		playerid,
		0,
		GetPlayerSkinEx(playerid),
		spawn_pos_data[spawn_id][0], // + random(3),
		spawn_pos_data[spawn_id][1], // + random(3),
		spawn_pos_data[spawn_id][2],
		spawn_pos_data[spawn_id][3],
		0, 0, 0, 0, 0, 0
	);
	return 1;
}

stock SetPlayerSpawnPos(playerid)
{
	if(GetPlayerData(playerid, P_JAIL) > 0)
		return PlacePlayerInJail(playerid);

	return 1;
}

stock SetPlayerInit(playerid)
{
	SetPlayerLevelInit(playerid);
	SetPlayerColorInit(playerid);
	SetPlayerSuspectInit(playerid);
	SetPlayerSkinInit(playerid);
	SetPlayerChatInit(playerid);
	SetPlayerMoneyInit(playerid);

    // CreateTeleportObjects(playerid);
	// CreateSpeedometr01ForPlayer(playerid);
	// CreateSpeedometr02ForPlayer(playerid);
	CreateAutoMarketForPlayer(playerid);
	// CreatePlayerGreenZoneText(playerid);
	// CreateAutoTuningForPlayer(playerid);

	SetPlayerLogged(playerid, true);
	TC_OnPlayerDataLoaded(playerid);
	BlackPass_OnPlayerLogged(playerid);
}

stock GetPlayerSkinEx(playerid)
{
	if(1 <= GetPlayerTeamEx(playerid) < MAX_ORG && GetPVarInt(playerid, "Form"))
		return GetPlayerData(playerid, P_OSKIN);
	return GetPlayerData(playerid, P_SKIN);
}

stock PreLoadPlayerAnims(playerid)
{
	for(new idx; idx < sizeof g_anim_libs; idx ++)
	{
		PreloadAnimLib(playerid, g_anim_libs[idx]);
	}
}

stock PreloadAnimLib(playerid, animlib[])
{
	ApplyAnimationEx(playerid, animlib, "null", 0.0, 0, 0, 0, 0, 0, 0);
}

stock SetPlayerMoneyInit(playerid)
{
	ResetPlayerMoney(playerid);
	return GivePlayerMoney(playerid, GetPlayerMoneyEx(playerid));
}

stock SetPlayerColorInit(playerid)
{
	return SetPlayerColorEx(playerid, GetPlayerTeamColor(playerid));
}

stock SetPlayerColorEx(playerid, color)
{
	SetPlayerData(playerid, P_COLOR, color);
	return SetPlayerColor(playerid, color);
}

stock BuildStoreFromDB(vehicleid, JSON:tuning_jsonn)
{
    new JSON:d_array = JSON_Array();

    new componentid, states;

    for(new i; i < cache_num_rows(); i++)
    {
        componentid = cache_get_field_content_int(i, "componentid");
        states = cache_get_field_content_int(i, "state");

        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(componentid)));
        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(states)));
    }

    JSON_SetArray(tuning_jsonn, "k", d_array);
	JSON_Cleanup(d_array);
}

stock BuildStoreFromComponents(vehicleid, jsonid, JSON:tuning_jsonn)
{
    new JSON:d_array = JSON_Array();
    new start, count;

    if(GetVehicleComponents(jsonid, start, count))
    {
        for(new i; i < count; i++)
        {
            new component = gVehicleComponentList[start + i];

            d_array = JSON_Append(d_array, JSON_Array(JSON_Int(component)));
            d_array = JSON_Append(d_array, JSON_Array(JSON_Int(0)));
        }
    }

    JSON_SetArray(tuning_jsonn, "k", d_array);
	JSON_Cleanup(d_array);
}

stock InitVehicleStore(vehicleid, jsonid, JSON:tuning_jsonn)
{
    new start, count;

    if(GetVehicleComponents(jsonid, start, count))
    {
        new query[256];

        for(new i; i < count; i++)
        {
            new component = gVehicleComponentList[start + i];

            mysql_format(mysql, query, sizeof(query),
                "INSERT INTO vehicle_store_components (vehicleid,componentid,state) VALUES (%d,%d,0)",
                vehicleid,
                component
            );

            mysql_tquery(mysql, query);
        }
    }

    BuildStoreFromComponents(vehicleid, jsonid, tuning_jsonn);
}

forward OnVehicleStoreLoad(playerid, vehicleid, jsonid, JSON:tuning_jsonn);
public OnVehicleStoreLoad(playerid, vehicleid, jsonid, JSON:tuning_jsonn)
{
    if(!cache_num_rows())
    {
        InitVehicleStore(vehicleid, jsonid, tuning_jsonn);
    }
    else
    {
        BuildStoreFromDB(vehicleid, tuning_jsonn);
    }

     new json_string[1024];
    JSON_Stringify(tuning_jsonn, json_string, sizeof(json_string));
    printf("TUNING JSON: %s", json_string);

    ShowPlayerGUI(playerid, 28, tuning_jsonn);
	JSON_Cleanup(tuning_jsonn);
	return 1;

}

stock OpenVehicleStore(playerid, vehicleid, jsonid, JSON:tuning_jsonn)
{
    new query[128];

    mysql_format(mysql, query, sizeof(query),
        "SELECT componentid,state FROM vehicle_store_components WHERE vehicleid=%d",
        vehicleid
    );

   mysql_tquery(mysql, query, "OnVehicleStoreLoad", "iiii", playerid, vehicleid, jsonid, _:tuning_jsonn);
}

stock SetPlayerHealthEx(playerid, Float: health, bool: inc_health = false)
{
	if(inc_health)
	{
		AddPlayerData(playerid, P_HEALTH, +, health);
	}
					else SetPlayerData(playerid, P_HEALTH, health);

	if(GetPlayerData(playerid, P_HEALTH) > 100.0)
		SetPlayerData(playerid, P_HEALTH, 100.0);

	return SetPlayerHealth(playerid, GetPlayerData(playerid, P_HEALTH));
}

stock SetPlayerSuspectInit(playerid)
{
	return SetPlayerWantedLevel(playerid, GetPlayerSuspect(playerid));
}

stock SetPlayerSkinInit(playerid)
{
	return SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));
}

stock SetPlayerLevelInit(playerid)
{
	return SetPlayerScore(playerid, GetPlayerLevel(playerid));
}

stock SetPlayerSkillsInit(playerid)
{
	SetPlayerSkillLevel(playerid, 0, GetPlayerData(playerid, P_SKILL_COLT) * 10);
	SetPlayerSkillLevel(playerid, 1, GetPlayerData(playerid, P_SKILL_SDPISTOL) * 10);
	SetPlayerSkillLevel(playerid, 2, GetPlayerData(playerid, P_SKILL_DEAGLE) * 10);
	SetPlayerSkillLevel(playerid, 3, GetPlayerData(playerid, P_SKILL_SHOTGUN) * 10);
	SetPlayerSkillLevel(playerid, 4, GetPlayerData(playerid, P_SKILL_SAWNOFF) * 10);
	SetPlayerSkillLevel(playerid, 5, GetPlayerData(playerid, P_SKILL_COMBAT_SG) * 10);
	SetPlayerSkillLevel(playerid, 6, GetPlayerData(playerid, P_SKILL_MICRO_UZI) * 10);
	SetPlayerSkillLevel(playerid, 7, GetPlayerData(playerid, P_SKILL_MP5) * 10);
	SetPlayerSkillLevel(playerid, 8, GetPlayerData(playerid, P_SKILL_AK47) * 10);
	SetPlayerSkillLevel(playerid, 9, GetPlayerData(playerid, P_SKILL_M4) * 10);
	SetPlayerSkillLevel(playerid, 10, GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE) * 10);

	return 1;
}

stock SetPlayerSelectSkin(playerid, select_skin, skinid)
{
	SetPlayerData(playerid, P_SELECT_SKIN, select_skin);
	SetPlayerSkin(playerid, skinid);
}

stock SetPlayerPosEx(playerid, Float: x, Float: y, Float: z, Float: angle, interior = -1, virtual_world = -1, freeze = true)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    ResetPlayerVehicleStreamCache(playerid);

    // Complete the destination context before sending the position.
    if(interior != -1 && GetPlayerInterior(playerid) != interior)
        SetPlayerInterior(playerid, interior);
    if(virtual_world != -1 && GetPlayerVirtualWorld(playerid) != virtual_world)
        SetPlayerVirtualWorld(playerid, virtual_world);

    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, angle);
    SetCameraBehindPlayer(playerid);
    Streamer_Update(playerid);

    if(GetPlayerData(playerid, P_LAST_PICKUP) != -1)
        SetPlayerData(playerid, P_LAST_PICKUP, -1);

    if(freeze)
    {
        // A ping spike must not immobilize a player for ten seconds or longer.
        TeleportFreeze(playerid, GetPlayerPing(playerid) * 2 + 350);
    }
    else if(g_teleport_freeze_timer[playerid])
    {
        KillTimer(g_teleport_freeze_timer[playerid]);
        g_teleport_freeze_timer[playerid] = 0;
        g_teleport_freeze_epoch[playerid]++;
        TogglePlayerControllable(playerid, true);
    }

    QueuePlayerVehicleVisualRefresh(playerid);
    return 1;
}

