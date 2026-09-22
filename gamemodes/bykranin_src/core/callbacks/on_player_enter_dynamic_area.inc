//>> Файл: bykranin_src/core/callbacks/on_player_enter_dynamic_area.inc  (568 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerEnterDynamicArea
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(FsinFull_OnEnterDynamicArea(playerid,areaid)) return 1;
	if(FactionGate_OnEnterArea(playerid, areaid)) return 1;
	if(Construction_OnEnterArea(playerid, areaid)) return 1;
	if(Larek_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid)) return 1;
	for(new idx; idx < sizeof(ATM_Areas); idx++)
	{
		if(areaid == ATM_Areas[idx])
		{
			ToggleInteractionWindow(playerid, true);
			return 1;
		}
	}

if(areaid == moto_salon_range_area)
{
	if(GetPlayerInBiz(playerid) == STATIC_BIZ_ID_MOTO_SALON && GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID)
	{
		DebugMotoSalonLog(playerid, "Area:MOTO_RANGE:enter");
		ToggleInteractionWindow(playerid, true);
	}
	return 1;
}
	for(new cont = 1; cont <= MAX_CONT; cont++)
{
    if(areaid == ContArea[cont])
    {
        ToggleInteractionWindow(playerid, true);
        return 1;
    }
}
	for(new idx; idx < sizeof g_casino_area; idx++)
{
    if(areaid == g_casino_area[idx])
    {
        ToggleInteractionWindow(playerid, true);
        return 1;
    }
}
for(new idx; idx < MAX_BJ_LOBBY; idx++)
{
    if(areaid == BlackJackSphere[idx])
    {
        ToggleInteractionWindow(playerid, true);
        return 1;
    }
}
if(areaid == openvorotamo1)
	{
		if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return ShowNotificationNew(playerid, 2, 5, 1, 10, "Вы не служите в Армии!", "");
    if(!(3 <= GetPlayerJob(playerid) <= 10))
     return ShowNotificationNew(playerid, 2, 5, 1, 10, "Доступно только с 3 ранга!", "");
        			MoveObject(vorotamo1,1910.21,1725.28,15.6666, 2.0, -90.0, 0.0, 0.0);
}
	if(areaid == openvorotamo)
	{
		if(GetPlayerTeamEx(playerid) != TEAM_ARMY) return ShowNotificationNew(playerid, 2, 5, 1, 10, "Вы не служите в Армии!", "");
    if(!(3 <= GetPlayerJob(playerid) <= 10))
     return ShowNotificationNew(playerid, 2, 5, 1, 10, "Доступно только с 3 ранга!", "");
        			MoveObject(vorotamo,1891.1486,1714.2531,16.4444, 1.0);
}
if(IsMedBedDynamicArea(areaid))
	{
        // Same bottom interaction button used by the pier captain/containers.
        // The bed itself is handled only after the player presses that button.
		if(GetPlayerData(playerid, P_OCCUPIED_BED) == -1 && GetPlayerHealthEx(playerid) < 95.0)
		{
			new bedid = GetNearestMedBed(playerid, 2.8);
			if(bedid != -1 && !g_med_bed_used[bedid])
			{
                ToggleInteractionWindow(playerid, true);
			}
		}
        return 1;
	}
		if(areaid == lift1)
	{
		 ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", ">>");
	}
	if(areaid == lift2)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", ">>");
	}

	if(areaid == helpspawn)
	{
	    ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", ">>");
	}

if(areaid == zona1)
{
if(GetPlayerData(playerid, P_FAMILY) == 0) return 1;
if(GetPVarInt(playerid, "FermaGarelpva") == 1) return 1;
SetPVarInt(playerid, "FermaGarelpva",1);
SetPVarInt(playerid, "FermaYbit",1);
//g_capturef[F_STATUS] = true;
timerochkov = SetTimer("FERMAGAREL", 2000, true);
CreateZakazZakaz(playerid);
PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]); 
for(new i=0; i <= 5; i++)
     {
    TextDrawShowForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }
   new fmt_msg[120];
   format(fmt_msg, sizeof fmt_msg, "Игрок %s зашел на территорию сражения",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	format(fmt_msg, sizeof fmt_msg, "Вы вошли на территорию сражения",GetPlayerData(playerid, P_OHFAM));	
SendClientMessage(playerid,-1,fmt_msg);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;

    // Получение и отображение очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki FROM family WHERE id=%d LIMIT 1", fam_id);
  new  Cache: result = mysql_query(mysql, query, true);
    
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

    // Получение и отображение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki FROM family ORDER BY ochki DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki");
        cache_delete(result);

        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text); 
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]); 
    }
					else
    {
        cache_delete(result);
    }


      }
if(areaid == zona2)
{
if(GetPlayerData(playerid, P_FAMILY) == 0) return 1;
if(GetPVarInt(playerid, "Zavodpva") == 1) return 1;
SetPVarInt(playerid, "Zavodpva",1);
SetPVarInt(playerid, "FermaYbit",1);
//g_capturef[F_STATUS] = true;
timerzavodp = SetTimer("ZAVODBUSAEVO", 2000, true);
CreateZakazZakaz(playerid);
PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]); 
for(new i=0; i <= 5; i++)
     {
    TextDrawShowForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }
   new fmt_msg[120];
   format(fmt_msg, sizeof fmt_msg, "Игрок %s зашел на территорию сражения",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	format(fmt_msg, sizeof fmt_msg, "Вы вошли на территорию сражения",GetPlayerData(playerid, P_OHFAM));	
SendClientMessage(playerid,-1,fmt_msg);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;

    // Получение и отображение очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family WHERE id=%d LIMIT 1", fam_id);
  new  Cache: result = mysql_query(mysql, query, true);
    
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

    // Получение и отображение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family ORDER BY ochki1 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text); 
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]); 
    }
					else
    {
        cache_delete(result);
    }


      }
      if(areaid == zona3)
{
if(GetPlayerData(playerid, P_FAMILY) == 0) return 1;
if(GetPVarInt(playerid, "Arzpva") == 1) return 1;
SetPVarInt(playerid, "Arzpva",1);
//SetPVarInt(playerid, "FermaYbit",1);
//g_capturef[F_STATUS] = true;
timerarzl = SetTimer("ARZVISHKA", 2000, true);
CreateZakazZakaz(playerid);
PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]); 
for(new i=0; i <= 5; i++)
     {
    TextDrawShowForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }
   new fmt_msg[120];
   format(fmt_msg, sizeof fmt_msg, "Игрок %s зашел на территорию сражения",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	format(fmt_msg, sizeof fmt_msg, "Вы вошли на территорию сражения",GetPlayerData(playerid, P_OHFAM));	
SendClientMessage(playerid,-1,fmt_msg);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;

    // Получение и отображение очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family WHERE id=%d LIMIT 1", fam_id);
  new  Cache: result = mysql_query(mysql, query, true);
    
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

    // Получение и отображение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki1 FROM family ORDER BY ochki1 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki1");
        cache_delete(result);

        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text); 
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]); 
    }
					else
    {
        cache_delete(result);
    }


      }
      if(areaid == zona5)
{
if(GetPlayerData(playerid, P_FAMILY) == 0) return 1;
if(GetPVarInt(playerid, "Karakpva") == 1) return 1;
SetPVarInt(playerid, "Karakpva",1);
//SetPVarInt(playerid, "FermaYbit",1);
//g_capturef[F_STATUS] = true;
timerkarr = SetTimer("KARAKVISHKA", 2000, true);
CreateZakazZakaz(playerid);
PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]); 
for(new i=0; i <= 5; i++)
     {
    TextDrawShowForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }
   new fmt_msg[120];
   format(fmt_msg, sizeof fmt_msg, "Игрок %s зашел на территорию сражения",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	format(fmt_msg, sizeof fmt_msg, "Вы вошли на территорию сражения",GetPlayerData(playerid, P_OHFAM));	
SendClientMessage(playerid,-1,fmt_msg);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;

    // Получение и отображение очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki3 FROM family WHERE id=%d LIMIT 1", fam_id);
  new  Cache: result = mysql_query(mysql, query, true);
    
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

    // Получение и отображение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki3 FROM family ORDER BY ochki3 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki3");
        cache_delete(result);

        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text); 
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]); 
    }
					else
    {
        cache_delete(result);
    }


      }
if(areaid == zona4)
{
if(GetPlayerData(playerid, P_FAMILY) == 0) return 1;
if(GetPVarInt(playerid, "Garelpva") == 1) return 1;
SetPVarInt(playerid, "Garelpva",1);
//SetPVarInt(playerid, "FermaYbit",1);
//g_capturef[F_STATUS] = true;
timerbuszl = SetTimer("GARELVISHKA", 2000, true);
CreateZakazZakaz(playerid);
PlayerTextDrawShow(playerid, zakaz3_PTD[playerid][0]); 
for(new i=0; i <= 5; i++)
     {
    TextDrawShowForPlayer(playerid,zakaz3_TD[i]);
    // SelectTextDraw(playerid,0xFFFFFFFF);
   }
   new fmt_msg[120];
   format(fmt_msg, sizeof fmt_msg, "Игрок %s зашел на территорию сражения",GetPlayerNameEx(playerid), GetPlayerData(playerid, P_OHFAM));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, -1, fmt_msg);
	}
	format(fmt_msg, sizeof fmt_msg, "Вы вошли на территорию сражения",GetPlayerData(playerid, P_OHFAM));	
SendClientMessage(playerid,-1,fmt_msg);
    new query[128];
    new fmt_text[128];
    new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;

    // Получение и отображение очков семьи
    mysql_format(mysql, query, sizeof query, "SELECT ochki4 FROM family WHERE id=%d LIMIT 1", fam_id);
  new  Cache: result = mysql_query(mysql, query, true);
    
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

    // Получение и отображение очков лидера
    mysql_format(mysql, query, sizeof query, "SELECT ochki4 FROM family ORDER BY ochki4 DESC LIMIT 1");
    result = mysql_query(mysql, query, true);
    
    if (cache_num_rows(result))
    {
        new lider_ochki = cache_get_field_content_int(0, "ochki4");
        cache_delete(result);

        TextDrawHideForPlayer(playerid, zakaz3_TD[1]);
        format(fmt_text, sizeof(fmt_text), "%d", lider_ochki);
        TextDrawSetString(zakaz3_TD[1], fmt_text); 
        TextDrawShowForPlayer(playerid, zakaz3_TD[1]); 
    }
					else
    {
        cache_delete(result);
    }


      }
    for(new vodo_idx = 0; vodo_idx < VODOLAZ_CAPTAIN_COUNT; vodo_idx++)
    {
        if(areaid == vodolazactor[vodo_idx])
        {
            ToggleInteractionWindow(playerid, true);
            return 1;
        }
    }
    if(areaid == vodolootsphere[0][0])
    {
        if(vodolazrabota[playerid] == true && mestogovodo[playerid][0] == true && mestolootgo[playerid][0][0] == false)
            ToggleInteractionWindow(playerid, true);
        return 1;
    }
	if(areaid == mysactor)
	{
		ShowNotificationNew(playerid, 4, 3, 0, 0, "Взаимодействовать", ">>");
	}
	if(areaid == kladactor)
	{
		ShowNotificationNew(playerid, 4, 3, 0, 0, "Взаимодействовать", ">>");
	}
	
    foreach(Player, i)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            new station[256];
	            GetPVarString(i, "BBStation", station, sizeof(station));
	            if(!isnull(station))
				{
					PlayStream(playerid, station, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ"), 30.0, 1);
				 	SendClientMessage(playerid, -1, "Вы вошли в зону бумбокса");
	            }
				return 1;
	        }
	    }
	}
	new green_zone_id = GetGreenZoneByArea(areaid);
	if(green_zone_id != -1)
	{
		ShowPlayerGreenZoneText(playerid);
		SetPVarInt(playerid, "player_in_green_zone", green_zone_id + 1);
		SetPlayerGreenZoneBrBonus(playerid, true);
	}

	if(g_fuel_station_loaded > 0 && GetFuelStationData(0, FS_AREA) <= areaid <= GetFuelStationData(g_fuel_station_loaded - 1, FS_AREA))
	{
		SetPVarInt(playerid, "buy_fuel_count", 	0);
		SetPVarInt(playerid, "buy_fuel_pay_j",	0);
		SetPVarInt(playerid, "buy_fuel_pay", 	0);
	}
					else if(g_gang_zones_loaded > 0 && GetGangZoneData(0, GZ_AREA) <= areaid <= GetGangZoneData(g_gang_zones_loaded - 1, GZ_AREA))
	{
		if(TEAM_OPG_ARZAMASKAYA <= GetPlayerTeamEx(playerid) <= TEAM_OPG_LYTKARINSKAYA)
		{
			//new gangzoneid = GetGangZoneData(areaid - GetGangZoneData(0, GZ_AREA), GZ_ZONE);
			//UpdateGangZone(gangzoneid);
			return 1;
		}
	}
					else if(areaid == factory_put_zone)
	{
		if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
		{
			if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_PUT_PROD)
			{
			//	new objectid;
				new items = GetPlayerJobLoadItems(playerid);
				new Float: x, Float: y, Float: z, Float: angle;

				SetPlayerTempJobCheckAnim(playerid, false);

				ApplyAnimationEx(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

				TogglePlayerFactoryCP(playerid, true);
				SetPlayerJobLoadItems(playerid, items + 1);

				AddPlayerData(playerid, P_JOB_WAGE, +, random(20)+40);
				SendClientMessage(playerid, 0xFFFF00FF, "Продукт доставлен на склад");

			//	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);

				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, angle);

//				objectid = CreateDynamicObject(1279, x, -200.81883, 1006.51978, 0.9, 0.0, angle);
//				MoveDynamicObject(objectid, 263.8, -200.81880, 1006.51978, 2.0, 0.9, 0.0, angle);

//				Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, OBJECT_TYPE_FACTORY);
			}
		}
	}

	return 1;
}



