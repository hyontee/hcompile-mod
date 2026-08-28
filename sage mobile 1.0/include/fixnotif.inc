CMD:notify(playerid)
{
    ShowNotificationNew(playerid,  2, 6, 0, 0, "привет", "qq"); // вызов уведомление
    return 1;
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
  new BitStream:bitstream = BS_New();
  BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);
  
  BS_WriteValue(bitstream, PR_UINT16, guiid);
  
  new data[1024]; //4294967295
    JSON_Stringify(json, data); 
  
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

  PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
  BS_Delete(bitstream);
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == questinteraction1)
	{
		ShowNotificationNew(playerid, 4, 7, 22, 22, "Взаимодействовать", "");
} 
    if(areaid == questinteraction2)
	{
		ShowNotificationNew(playerid, 4, 7, 22, 22, "Взаимодействовать", "");
}
    if(areaid == questinteraction3)
	{
		ShowNotificationNew(playerid, 4, 7, 22, 22, "Взаимодействовать", "");
}
    if(areaid == questinteraction4)
	{
		ShowNotificationNew(playerid, 4, 7, 22, 22, "Взаимодействовать", "");
}
 if(areaid == kostinteraction1)
	{
		ShowNotificationNew(playerid, 4, 7, 23, 23, "Взаимодействовать", "");
}
 if(areaid == kostinteraction2)
	{
		ShowNotificationNew(playerid, 4, 7, 23, 23, "Взаимодействовать", "");
}
 if(areaid == kostinteraction3)
	{
		ShowNotificationNew(playerid, 4, 7, 23, 23, "Взаимодействовать", "");
}
 if(areaid == kostinteraction4)
	{
		ShowNotificationNew(playerid, 4, 7, 23, 23, "Взаимодействовать", "");
}
if(areaid == koika1)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika2)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika3)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika4)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika5)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika6)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika7)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika8)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika9)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika10)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika11)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika12)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika13)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika14)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika15)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika16)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika17)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika18)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika19)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika20)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika21)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika22)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika23)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika24)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika25)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika26)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika27)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika28)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika29)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika30)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika31)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == koika32)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/medbed", ">>");
	}
	if(areaid == lift1)
	{
		 ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/lift1", ">>");
	}
	if(areaid == lift2)
	{
		ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/lift2", ">>");
	}

	if(areaid == helpspawn)
	{
	    ShowNotificationNew(playerid, 3, 4, 1, 1,  "Взаимодействовать", "/help", ">>");
	}

if(areaid == zona1)
{
//if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
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
if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семьеТЕСТ");
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
if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
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
if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
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
if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
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
if(areaid == vodolootsphere[0][0])
	{
	    if(vodolazrabota[playerid] == true)
	    {
	    	ShowNotification(playerid, 4, "Взаимодействие", 3, "/vodolootyashik", ">>");
		}
		else return 1;
	}
    if(areaid == vodolazactor)
	{
		ShowNotification(playerid, 4, "Взаимодействовать", 3, "/vodoact", ">>");
	}
	if(areaid == mysactor)
	{
		ShowNotification(playerid, 4, "Взаимодействовать", 3, "/dvornik", ">>");
	}
	if(areaid == kladactor)
	{
		ShowNotification(playerid, 4, "Взаимодействовать", 3, "/klado", ">>");
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
	if(g_green_zones[0][GZ_AREA] <= areaid <= g_green_zones[sizeof g_green_zones - 1][GZ_AREA])
	{
		new green_zone_id = areaid - g_green_zones[0][GZ_AREA];

		ShowPlayerGreenZoneText(playerid);

		SetPVarInt(playerid, "player_in_green_zone", green_zone_id + 1);
	}

	if(GetFuelStationData(0, FS_AREA) <= areaid <= GetFuelStationData(g_fuel_station_loaded - 1, FS_AREA))
	{
		SetPVarInt(playerid, "buy_fuel_count", 	0);
		SetPVarInt(playerid, "buy_fuel_pay_j",	0);
		SetPVarInt(playerid, "buy_fuel_pay", 	0);
	}
	else if(GetGangZoneData(0, GZ_AREA) <= areaid <= GetGangZoneData(g_gang_zones_loaded - 1, GZ_AREA))
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
