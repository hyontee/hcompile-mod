//>> Файл: bykranin_src/core/callbacks/on_player_leave_dynamic_area.inc  (489 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerLeaveDynamicArea
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(FsinFull_OnLeaveDynamicArea(playerid,areaid)) return 1;
	if(FactionGate_OnLeaveArea(playerid, areaid)) return 1;
	if(Larek_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid)) return 1;

    if(Construction_IsForemanArea(areaid))
    {
        ToggleInteractionWindow(playerid, false);
        return 1;
    }

    if(IsMedBedDynamicArea(areaid))
    {
        // Beds can overlap slightly. Keep the button if another free nearby
        // bed is still in range; otherwise hide it just like the pier captain.
        new bedid = GetNearestMedBed(playerid, 2.8);
        if(bedid == -1 || g_med_bed_used[bedid] || GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
        {
            ToggleInteractionWindow(playerid, false);
        }
        return 1;
    }

    for(new vodo_idx = 0; vodo_idx < VODOLAZ_CAPTAIN_COUNT; vodo_idx++)
    {
        if(areaid == vodolazactor[vodo_idx])
        {
            ToggleInteractionWindow(playerid, false);
            return 1;
        }
    }
    if(areaid == vodolootsphere[0][0])
    {
        ToggleInteractionWindow(playerid, false);
        return 1;
    }
	for(new idx; idx < sizeof(ATM_Areas); idx++)
	{
		if(areaid == ATM_Areas[idx])
		{
			ToggleInteractionWindow(playerid, false);
			return 1;
		}
	}

if(areaid == moto_salon_range_area)
{
	DebugMotoSalonLog(playerid, "Area:MOTO_RANGE:leave");
	ToggleInteractionWindow(playerid, false);
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_MOTO_SALON)
	{
		HidePlayerSelectPanel(playerid);
	}
	return 1;
}
	for(new cont = 1; cont <= MAX_CONT; cont++)
{
    if(areaid == ContArea[cont])
    {
        // Keep the interaction button while the player is physically near
        // any container. This avoids Streamer enter/leave order races.
        if(ContNewSystem_GetNearestContainer(playerid) != 0) return 1;

        ToggleInteractionWindow(playerid, false);
        return 1;
    }
}
for(new idx; idx < sizeof g_casino_area; idx++)
{
    if(areaid == g_casino_area[idx])
    {
        ToggleInteractionWindow(playerid, false);
        HideCasinoDiceUi(playerid);
        return 1;
    }
}
for(new idx; idx < MAX_BJ_LOBBY; idx++)
{
    if(areaid == BlackJackSphere[idx])
    {
        ToggleInteractionWindow(playerid, false);
        return 1;
    }
}
if(areaid == openvorotamo1)
	{
			if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return ShowNotificationNew(playerid, 1, 5, 0, 0, "-", "");
    if(!(3 <= GetPlayerJob(playerid) <= 10))
     return ShowNotificationNew(playerid, 1, 5, 0, 0, "-", "");
             			MoveObject(vorotamo1,1910.21,1725.28,15.6666, 2.0, 0.0, 0.0, 0.0);
}
if(areaid == openvorotamo)
	{
			if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return ShowNotificationNew(playerid, 1, 5, 0, 0, "-", "");
    if(!(3 <= GetPlayerJob(playerid) <= 10))
     return ShowNotificationNew(playerid, 1, 5, 0, 0, "-", "");
             			MoveObject(vorotamo,1891.1486,1721.5555,16.4444, 1.0);
}
if(areaid == zona1)
{
if(GetPVarInt(playerid, "FermaGarelpva") == 0) return 1;
if(GetPVarInt(playerid, "Fermappbit")==0)
{
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
KillTimer(timerochkov);
SetPVarInt(playerid, "FermaGarelpva",0);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
new fmt_msg[120];
    new player_points = GetPlayerData(playerid, P_OHFAM);
format(fmt_msg, sizeof fmt_msg, "Игрок %s покинул территорию сражения и потерял %d очков",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	//format(fmt_msg, sizeof fmt_msg, "Вы покинули территорию сражения и потеряли %d очков",GetPlayerData(playerid, P_OHFAM));	
    //SendClientMessage(playerid, -1, fmt_msg);

    // Вычитание очков из семьи и обнуление личных очков
    
    AddFamilyData(fam_id, F_OCKIFARMA, -, player_points);
    
    format(fmt_text, sizeof fmt_text, "UPDATE family SET ochki=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_OCKIFARMA), fam_id);
    mysql_query(mysql, fmt_text, false);
SetPlayerData(playerid, P_OHFAM, 0);
UpdatePlayerDatabaseInt(playerid, "ocfam", GetPlayerData(playerid, P_OHFAM));
    // Обновление отображения очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki FROM family WHERE id=%d LIMIT 1", fam_id);
new    Cache: result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki");
        cache_delete(result);

        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
//CreateZakazZakaz(playerid);
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
for(new i=0; i <= 5; i++)
     {
    TextDrawHideForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }

    return 1;
    }
					else Send(playerid,-1,"Работает");
    }
if(areaid == zona2)
{
if(GetPVarInt(playerid, "Zavodpva") == 0) return 1;
if(GetPVarInt(playerid, "Fermappbit")==0)
{
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
KillTimer(timerzavodp);
SetPVarInt(playerid, "Zavodpva",0);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
new fmt_msg[120];
    new player_points = GetPlayerData(playerid, P_OHZAVOD);
format(fmt_msg, sizeof fmt_msg, "Игрок %s покинул территорию сражения и потерял %d очков",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHZAVOD));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	

    // Вычитание очков из семьи и обнуление личных очков
    
    AddFamilyData(fam_id, F_OCZAVOD, -, player_points);
    
    format(fmt_text, sizeof fmt_text, "UPDATE family SET ochki1=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_OCZAVOD), fam_id);
    mysql_query(mysql, fmt_text, false);
SetPlayerData(playerid, P_OHZAVOD, 0);
UpdatePlayerDatabaseInt(playerid, "oczav", GetPlayerData(playerid, P_OHZAVOD));
    // Обновление отображения очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family WHERE id=%d LIMIT 1", fam_id);
new    Cache: result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
//CreateZakazZakaz(playerid);
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
for(new i=0; i <= 5; i++)
     {
    TextDrawHideForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }

    return 1;
    }
					else Send(playerid,-1,"Работает");
    }
if(areaid == zona3)
{
if(GetPVarInt(playerid, "Arzpva") == 0) return 1;
if(GetPVarInt(playerid, "Fermappbit")==0)
{
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
KillTimer(timerarzl);
SetPVarInt(playerid, "Arzpva",0);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
new fmt_msg[120];
    new player_points = GetPlayerData(playerid, P_OHARZ);
format(fmt_msg, sizeof fmt_msg, "Игрок %s покинул территорию сражения и потерял %d очков",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHARZ));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}

    // Вычитание очков из семьи и обнуление личных очков
    
    AddFamilyData(fam_id, F_VISHARZ, -, player_points);
    
    format(fmt_text, sizeof fmt_text, "UPDATE family SET ochki2=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISHARZ), fam_id);
    mysql_query(mysql, fmt_text, false);
SetPlayerData(playerid, P_OHARZ, 0);
UpdatePlayerDatabaseInt(playerid, "ocarz", GetPlayerData(playerid, P_OHARZ));
    // Обновление отображения очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki2 FROM family WHERE id=%d LIMIT 1", fam_id);
new    Cache: result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki2");
        cache_delete(result);

        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
//CreateZakazZakaz(playerid);
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
for(new i=0; i <= 5; i++)
     {
    TextDrawHideForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }

    return 1;
    }
					else Send(playerid,-1,"Работает");
    }
if(areaid == zona5)
{
if(GetPVarInt(playerid, "Karakpva") == 0) return 1;
if(GetPVarInt(playerid, "Fermappbit")==0)
{
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
KillTimer(timerkarr);
SetPVarInt(playerid, "Karakpva",0);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
new fmt_msg[120];
    new player_points = GetPlayerData(playerid, P_OHKAR);
format(fmt_msg, sizeof fmt_msg, "Игрок %s покинул территорию сражения и потерял %d очков",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHKAR));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}

    // Вычитание очков из семьи и обнуление личных очков
    
    AddFamilyData(fam_id, F_VISHKAR, -, player_points);
    
    format(fmt_text, sizeof fmt_text, "UPDATE family SET ochki3=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISHKAR), fam_id);
    mysql_query(mysql, fmt_text, false);
SetPlayerData(playerid, P_OHKAR, 0);
UpdatePlayerDatabaseInt(playerid, "ockar", GetPlayerData(playerid, P_OHKAR));
    // Обновление отображения очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki3 FROM family WHERE id=%d LIMIT 1", fam_id);
new    Cache: result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki3");
        cache_delete(result);

        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
//CreateZakazZakaz(playerid);
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
for(new i=0; i <= 5; i++)
     {
    TextDrawHideForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }

    return 1;
    }
					else Send(playerid,-1,"Работает");
    }

if(areaid == zona4)
{
if(GetPVarInt(playerid, "Garelpva") == 0) return 1;
if(GetPVarInt(playerid, "Fermappbit")==0)
{
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
KillTimer(timerbuszl);
SetPVarInt(playerid, "Garelpva",0);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
new fmt_msg[120];
    new player_points = GetPlayerData(playerid, P_OHBUS);
format(fmt_msg, sizeof fmt_msg, "Игрок %s покинул территорию сражения и потерял %d очков",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHBUS));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}

    // Вычитание очков из семьи и обнуление личных очков
    
    AddFamilyData(fam_id, F_VISBUS, -, player_points);
    
    format(fmt_text, sizeof fmt_text, "UPDATE family SET ochki4=%d WHERE id=%d LIMIT 1", GetFamilyData(fam_id, F_VISBUS), fam_id);
    mysql_query(mysql, fmt_text, false);
SetPlayerData(playerid, P_OHBUS, 0);
UpdatePlayerDatabaseInt(playerid, "ocbus", GetPlayerData(playerid, P_OHBUS));
    // Обновление отображения очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki4 FROM family WHERE id=%d LIMIT 1", fam_id);
new    Cache: result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new ochki = cache_get_field_content_int(0, "ochki4");
        cache_delete(result);

        PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
        format(fmt_text, sizeof(fmt_text), "%d", ochki);
        PlayerTextDrawSetString(playerid, zakaz3_PTD[playerid][0], fmt_text);
        PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]);
    }
					else
    {
        cache_delete(result);
    }
//CreateZakazZakaz(playerid);
PlayerTextDrawHide(playerid, zakaz3_PTD[playerid][0]);
for(new i=0; i <= 5; i++)
     {
    TextDrawHideForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }

    return 1;
    }
					else Send(playerid,-1,"Работает");
    }

    foreach(Player, i)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            StopStream(playerid);
	            SendClientMessage(playerid, -1, "Вы покинули зону бумбокса");
				return 1;
	        }
	    }
	}
	new player_last_pickup = GetPlayerData(playerid, P_LAST_PICKUP);

	if(player_last_pickup != -1 && GetPickupInfo(player_last_pickup, P_DYNAMIC_ZONE) == areaid)
	{
		SetPlayerData(playerid, P_LAST_PICKUP, -1);
	}

	new green_zone_id = GetGreenZoneByArea(areaid);
	if(green_zone_id != -1)
	{
		HidePlayerGreenZoneText(playerid);
		SetPVarInt(playerid, "player_in_green_zone", 0);
		SetPlayerGreenZoneBrBonus(playerid, false);
	}

	if(!GetPlayerData(playerid, P_BLOCK_LEAVE_AREA))
	{
		if(areaid == miner_job_area)
		{
			EndPlayerTempJob(playerid, TEMP_JOB_MINER, true);
		}
					else if(areaid == factory_job_area)
		{
			EndPlayerTempJob(playerid, TEMP_JOB_FACTORY, true);
		}
					else if(g_fuel_station_loaded > 0 && GetFuelStationData(0, FS_AREA) <= areaid <= GetFuelStationData(g_fuel_station_loaded - 1, FS_AREA))
		{
			new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay") + GetPVarInt(playerid, "buy_fuel_pay_j");

			DeletePVar(playerid, "buy_fuel_count");
			DeletePVar(playerid, "buy_fuel_pay_j");
			DeletePVar(playerid, "buy_fuel_pay");

			new stationid = areaid - GetFuelStationData(0, FS_AREA);
			if(buy_fuel_pay > 0)
			{
				new query[155];

				mysql_format(mysql, query, sizeof query, "INSERT INTO fuel_stations_profit (fid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetFuelStationData(stationid, FS_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), buy_fuel_pay, IsFuelStationOwned(stationid) ? 1 : 0);
				mysql_query(mysql, query, false);
			}
		}
	}
					else SetPlayerData(playerid, P_BLOCK_LEAVE_AREA, false);

	return 1;
}

