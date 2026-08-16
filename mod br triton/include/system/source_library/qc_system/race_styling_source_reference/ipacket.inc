//alax gui ShowNotification by shram

#define TRUNK_GUI	2
#if !defined TRADE_GUI
    #define TRADE_GUI      3
#endif
#define OFFER_YES       4
#define OFFER_ENGINE 	5
#define EXIT_HOME 6

new g_IPacketSendBuffer[8192];
new g_IPacketRecvBuffer[8192];

//alax shram


#if !defined VF_SPORTA
    #define VF_SPORTA      (1)
    #define VF_DRIFTA      (2)
    #define VF_COMFORTA    (4)
    #define VF_SPORTPLUSA  (8)
    #define VF_STROB_ON    (16)
    #define VF_DALNIY_ON   (32)
#endif

stock bool:VehGetFlag(playerid, slot, flag)
{
    switch(flag)
    {
        case VF_SPORTA: return VehicleInfo[playerid][slot][vSportA];
        case VF_DRIFTA: return VehicleInfo[playerid][slot][vDriftA];
        case VF_COMFORTA: return VehicleInfo[playerid][slot][vComfortA];
        case VF_SPORTPLUSA: return VehicleInfo[playerid][slot][vSportPlusA];
        case VF_STROB_ON: return VehicleInfo[playerid][slot][vStrobState];
        case VF_DALNIY_ON: return VehicleInfo[playerid][slot][Dalniysvet];
    }
    return false;
}

stock VehSetFlag(playerid, slot, flag, bool:value)
{
    switch(flag)
    {
        case VF_SPORTA: VehicleInfo[playerid][slot][vSportA] = value;
        case VF_DRIFTA: VehicleInfo[playerid][slot][vDriftA] = value;
        case VF_COMFORTA: VehicleInfo[playerid][slot][vComfortA] = value;
        case VF_SPORTPLUSA: VehicleInfo[playerid][slot][vSportPlusA] = value;
        case VF_STROB_ON: VehicleInfo[playerid][slot][vStrobState] = value;
        case VF_DALNIY_ON: VehicleInfo[playerid][slot][Dalniysvet] = value;
    }
    return 1;
}

stock bool:VehToggleFlag(playerid, slot, flag)
{
    new bool:value = !VehGetFlag(playerid, slot, flag);
    VehSetFlag(playerid, slot, flag, value);
    return value;
}

stock bool:GetVehicleOwnerSlot(vehicleid, &owner, &slot)
{
    owner = -1;
    slot = -1;
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                owner = i;
                slot = v;
                return true;
            }
        }
    }
    return false;
}
stock OnPacketIncoming(playerid, guiid, Node:json)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 252);
	
	BS_WriteValue(bitstream, PR_UINT16, guiid);
	
	g_IPacketSendBuffer[0] = EOS;
    JSON_Stringify(json, g_IPacketSendBuffer); 
	
    BS_WriteValue(bitstream, PR_UINT32, strlen(g_IPacketSendBuffer));
    BS_WriteValue(bitstream, PR_STRING, g_IPacketSendBuffer);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
    return 1;
}

IPacket:252(playerid, BitStream:bitstream)
{
    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length;
    BS_ReadValue(bitstream, PR_UINT32, length);

    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(!IsPlayerConnected(playerid)) return 0;

    if(length <= 0 || length >= sizeof(g_IPacketRecvBuffer)) return 0;

    g_IPacketRecvBuffer[0] = EOS;
    BS_ReadValue(bitstream, PR_STRING, g_IPacketRecvBuffer, length);
    g_IPacketRecvBuffer[length] = EOS;

    new Node:json = JSON_Object();
    JSON_Parse(g_IPacketRecvBuffer, json);

    switch (guiid)
    {
case 13:
        {
            new t, sub_id, id;
            JSON_GetInt(json, "t", t);
            JSON_GetInt(json, "s", id);
            JSON_GetInt(json, "b", sub_id);

            switch(t)
            {
                case 0:
                {
                    switch(id)
                    {
                        case VODOLAZ_NOTIFY_CAPTAIN:
                        {
                            Vodolaz_ShowMainMenu(playerid);
                            return 1;
                        }
                        case VODOLAZ_NOTIFY_ITEM:
                        {
                            Vodolaz_TryCollectItem(playerid);
                            return 1;
                        }
                        case 1:
                        {
                            return 1;
                        }
                        case TRUNK_GUI:
                        {
                            callcmd::trunk(playerid, "");
                        }
                        case TRADE_GUI:
                        {
                            callcmd::atrade(playerid, "");
                        }
                        case OFFER_YES:
                        {
                            callcmd::car(playerid, "");
                        }
                        case OFFER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case EXIT_HOME:
                        {
                            callcmd::exit(playerid, "");
                        }
                    }
                    return 1;
                }
                case 1:
                {
                    switch(id)
                    {
                        case 1:
                        {
                            return 1;
                        }
                    }
                    return 1;
                }
            }
        }

case 45:
{
    PacketIncomingFamily(playerid, json);
    return 1;
}

case 34:
{
    Trunk_HandlePacket(playerid, json);
    return 1;
}


     case 66:
{
    new buttonId = 0, screenType = 0, closeFlag = 0, tableButtonId = 0;
    JSON_GetInt(json, "b", buttonId);
    JSON_GetInt(json, "t", screenType);
    JSON_GetInt(json, "c", closeFlag);
    JSON_GetInt(json, "bi", tableButtonId);

    if(closeFlag == 1)
    {
        pc_cmd_spoff(playerid, "");
        JSON_Cleanup(json);
        return 1;
    }

    switch(screenType)
    {
        case 1:
        {
            new targetid = GetPVarInt(playerid, "SpectatingID");
            if(targetid == -1 || !IsPlayerConnected(targetid))
            {
                SendClientMessage(playerid, 0xFF3333FF, "????? ?? ??????!");
                JSON_Cleanup(json);
                return 1;
            }

            switch(buttonId)
            {
                case 1:
                {
                    new count = 0, players[MAX_PLAYERS];
                    for(new i = 0; i <= GetPlayerPoolSize(); i++)
                    {
                        if(!IsPlayerConnected(i) || i == playerid || i == targetid || IsPlayerNPC(i)) continue;
                        if(GetPVarInt(i, "IsSpectating")) continue;
                        players[count++] = i;
                    }
                    if(count == 0) ShowNotification(playerid, 0, 3, 0, 0, "??????? ?? ???????", "");
                    else
                    {
                        new nextTarget = players[random(count)];
                        new str_id[16];
                        valstr(str_id, nextTarget);
                        pc_cmd_sp(playerid, str_id);
                        ShowSpectateGUI(playerid, nextTarget);
                    }
                }
                case 2:
                {
                    new prevPlayer = -1;
                    for(new i = targetid - 1; i >= 0; i--)
                    {
                        if(!IsPlayerConnected(i) || i == playerid || IsPlayerNPC(i)) continue;
                        if(GetPVarInt(i, "IsSpectating")) continue;
                        prevPlayer = i;
                        break;
                    }
                    if(prevPlayer == -1) ShowNotification(playerid, 0, 3, 0, 0, "??????? ?? ???????", "");
                    else
                    {
                        new str_id[16];
                        valstr(str_id, prevPlayer);
                        pc_cmd_sp(playerid, str_id);
                        ShowSpectateGUI(playerid, prevPlayer);
                    }
                }
                case 3: AT_SendPunishTemplates(playerid, 3);
                case 4: AT_SendPunishTemplates(playerid, 4);
                case 5: AT_SendPunishTemplates(playerid, 5);
                case 6: AT_SendPunishTemplates(playerid, 6);
                case 7: AT_SendPunishTemplates(playerid, 7);
                case 8: AT_SendPunishTemplates(playerid, 8);
                case 9:
                {
                    new nextPlayer = -1;
                    for(new i = targetid + 1; i <= GetPlayerPoolSize(); i++)
                    {
                        if(!IsPlayerConnected(i) || i == playerid || IsPlayerNPC(i)) continue;
                        if(GetPVarInt(i, "IsSpectating")) continue;
                        nextPlayer = i;
                        break;
                    }
                    if(nextPlayer == -1) ShowNotification(playerid, 0, 3, 0, 0, "??????? ?? ???????", "");
                    else
                    {
                        new str_id[16];
                        valstr(str_id, nextPlayer);
                        pc_cmd_sp(playerid, str_id);
                        ShowSpectateGUI(playerid, nextPlayer);
                    }
                }
                case 10:
                {
                    new params[16];
                    format(params, sizeof(params), "%d", targetid);
                    callcmd::stats(playerid, params);
                }
                case 11: ShowControlPanelGUI(playerid);
            }
        }

        case 2:
        {
            new targetid = GetPVarInt(playerid, "SpectatingID");
            if(targetid != -1 && IsPlayerConnected(targetid) && tableButtonId > 0)
            {
                AT_ApplyPunishTemplate(playerid, targetid, tableButtonId);
            }
        }

        case 3:
        {
            switch(buttonId)
            {
                case 1: AT_SendReportAnswerTemplates(playerid);
                case 2:
                {
                    new Node:close_json = JSON_Object();
                    JSON_SetInt(close_json, "c", 1);
                    OnPacketIncoming(playerid, 66, close_json);
                    JSON_Cleanup(close_json);
                }
            }
        }

        case 4:
        {
            if(tableButtonId > 0) AT_HandleReportTemplateReply(playerid, tableButtonId);
        }

        case 5:
        {
            new reportText[256];
            JSON_GetString(json, "rt", reportText, sizeof(reportText));
            if(!isnull(reportText)) AT_HandleReportCustomReply(playerid, reportText);
        }

        case 6:
        {
            if(tableButtonId == 0) AT_SendMyTemplates(playerid);
            else if(tableButtonId == 1)
            {
                new Node:json_response = JSON_Object();
                JSON_SetInt(json_response, "t", 9);
                JSON_SetString(json_response, "bn", "??????? ??????");
                OnPacketIncoming(playerid, 66, json_response);
                JSON_Cleanup(json_response);
            }
            else if(tableButtonId == 7) AT_SendCategories(playerid);
        }

        case 7:
        {
            if(tableButtonId >= 3 && tableButtonId <= 8) AT_SendPunishTemplates(playerid, tableButtonId);
        }

        case 8:
        {
            if(JSON_GetType(json, "bn") == JSON_NODE_STRING && JSON_GetType(json, "be") == JSON_NODE_STRING)
            {
                new title[64], desc[256], tm = 0;
                JSON_GetString(json, "bn", title, sizeof(title));
                JSON_GetString(json, "be", desc, sizeof(desc));
                JSON_GetInt(json, "br", tm);

                if(!strcmp(title, "fatal", true) && !strcmp(desc, "fatal", true))
                {
                    if(tableButtonId > 0)
                    {
                        new query[160];
                        mysql_format(db_handle, query, sizeof(query), "DELETE FROM admin_templates WHERE id=%d LIMIT 1", tableButtonId);
                        mysql_tquery(db_handle, query, "", "");
                        AT_LoadTemplates();
                    }
                }
                else
                {
                    if(tableButtonId > 0)
                    {
                        new query[512];
                        mysql_format(db_handle, query, sizeof(query), "UPDATE admin_templates SET title='%e', description='%e', time_value=%d WHERE id=%d", title, desc, tm, tableButtonId);
                        mysql_tquery(db_handle, query, "", "");
                        AT_LoadTemplates();
                    }
                }
                AT_SendMyTemplates(playerid);
            }
        }

        case 9:
        {
            new templateTitle[64], templateDesc[256], templateTime = 0;
            JSON_GetString(json, "bn", templateTitle, sizeof(templateTitle));
            JSON_GetString(json, "be", templateDesc, sizeof(templateDesc));
            JSON_GetInt(json, "br", templateTime);

            if(strlen(templateTitle) > 0 && strlen(templateDesc) > 0)
            {
                new query[700];
                mysql_format(db_handle, query, sizeof(query), "INSERT INTO admin_templates (category, title, description, time_value, created_by) VALUES (0, '%e', '%e', %d, %d)", templateTitle, templateDesc, templateTime, Player[playerid][pID]);
                mysql_tquery(db_handle, query, "", "");
                AT_LoadTemplates();
                AT_SendMyTemplates(playerid);
            }
        }

        case 82:
        {
            new templateId = 0, title[64], desc[256], tm = 0;
            JSON_GetInt(json, "bi", templateId);
            JSON_GetString(json, "bn", title, sizeof(title));
            JSON_GetString(json, "be", desc, sizeof(desc));
            JSON_GetInt(json, "br", tm);

            if(templateId > 0)
            {
                new query[512];
                mysql_format(db_handle, query, sizeof(query), "UPDATE admin_templates SET title='%e', description='%e', time_value=%d WHERE id=%d", title, desc, tm, templateId);
                mysql_tquery(db_handle, query, "", "");
                AT_LoadTemplates();
                AT_SendMyTemplates(playerid);
            }
        }
    }

    JSON_Cleanup(json);
    return 1;
}

        case 22:
{
    new type, ty, latype, internal_id, price;
    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "p", internal_id);
    JSON_GetInt(json, "m", price);
    JSON_GetInt(json, "la", latype);
    JSON_GetInt(json, "ty", ty);
    switch(type)
    {
        case 2:
        {
            Player[playerid][pCountBomjCases] += 1;
            new Node:json_gift = JSON_Object();
            JSON_SetInt(json_gift, "t", 2);
            JSON_SetInt(json_gift, "s", 1);
            Player[playerid][pGiftDelay] = 7200;
            SavePlayerAccount(playerid);
            JSON_SetInt(json_gift, "p", Player[playerid][pGiftDelay]);
            OnPacketIncoming(playerid, 22, json_gift);
            JSON_Cleanup(json_gift);
            new dialog_str[256];
            format(dialog_str, sizeof(dialog_str), "{FFFFFF}Поздравляем! Вы получили подарок:\n\n{FFFFFF}Подарок: {FFCC00}Бомж кейс (1 шт.)\n{CECECE}Воспользуйтесь /cases, чтобы открыть кейс!");
            ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFCC00}Подарок", dialog_str, "Закрыть", "");
            SendClientMessage(playerid, -1, "{FFFF00} {FFFFFF}Вы получили {FFCC00}бомж кейс, введите /cases для открытия!");
        }
        case 1:
        {
            callcmd::cases(playerid, "");
        }
        case -2:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", -1);
            JSON_SetInt(response, "ty", -1);
            JSON_SetInt(response, "la", 0);
            JSON_SetInt(response, "lc", 0);
            JSON_SetString(response, "sn", BP_SEASON_NAME);
            new leaderName[MAX_PLAYER_NAME];
            new leaderId = BlackPassTop[0][topUserID];
            if(leaderId > 0)
            {
                new q[128];
                mysql_format(db_handle, q, sizeof(q), "SELECT name FROM players WHERE id = %d", leaderId);
                new Cache:res = mysql_query(db_handle, q);
                if(cache_num_rows() > 0) cache_get_field_content(0, "name", leaderName, db_handle, MAX_PLAYER_NAME);
                else format(leaderName, MAX_PLAYER_NAME, "ID:%d", leaderId);
                cache_delete(res);
            }
            else format(leaderName, MAX_PLAYER_NAME, "None");
            JSON_SetString(response, "ln", leaderName);
            JSON_SetInt(response, "lv", PlayerBP[playerid][bpLevel]);
            JSON_SetInt(response, "td", 2505600);
            JSON_SetInt(response, "ec", PlayerBP[playerid][bpExp]);
            JSON_SetInt(response, "a", PlayerBP[playerid][bpPremium]);
            JSON_SetInt(response, "sp", 0);
            new Node:rewardsArray = JSON_Array();
            for(new i = 1; i <= MAX_BP_LEVEL; i++)
            {
                new Node:levelObj = JSON_Object();
                JSON_SetInt(levelObj, "id", i);
                new status = 0;
                if(i <= PlayerBP[playerid][bpLevel])
                {
                    if(IsBPRewardTaken(playerid, i)) status = 2;
                    else status = 1;
                }
                else status = 0;
                JSON_SetInt(levelObj, "is", status);
                JSON_ArrayAppend(rewardsArray, "", levelObj);
                JSON_Cleanup(levelObj);
            }
            JSON_SetArray(response, "r", rewardsArray);
            JSON_SetInt(response, "is", 0);
            OnPacketIncoming(playerid, 22, response);
            JSON_Cleanup(rewardsArray);
            JSON_Cleanup(response);
        }
        case -1:
        {
            switch(ty)
            {
                case -1:
                {
                    if(latype == 0)
                    {
                        new Node:response = JSON_Object();
                        JSON_SetInt(response, "t", -1);
                        JSON_SetInt(response, "ty", -1);
                        JSON_SetInt(response, "la", 0);
                        JSON_SetInt(response, "lc", 0);
                        JSON_SetString(response, "sn", BP_SEASON_NAME);
                        new leaderName[MAX_PLAYER_NAME];
                        new leaderId = BlackPassTop[0][topUserID];
                        if(leaderId > 0)
                        {
                            new q[128];
                            mysql_format(db_handle, q, sizeof(q), "SELECT name FROM players WHERE id = %d", leaderId);
                            new Cache:res = mysql_query(db_handle, q);
                            if(cache_num_rows() > 0) cache_get_field_content(0, "name", leaderName, db_handle, MAX_PLAYER_NAME);
                            else format(leaderName, MAX_PLAYER_NAME, "ID:%d", leaderId);
                            cache_delete(res);
                        }
                        else format(leaderName, MAX_PLAYER_NAME, "None");
                        JSON_SetString(response, "ln", leaderName);
                        JSON_SetInt(response, "lv", PlayerBP[playerid][bpLevel]);
                        JSON_SetInt(response, "td", 2505600);
                        JSON_SetInt(response, "ec", PlayerBP[playerid][bpExp]);
                        JSON_SetInt(response, "a", PlayerBP[playerid][bpPremium]);
                        JSON_SetInt(response, "sp", 0);
                        JSON_SetInt(response, "is", 0);
                        OnPacketIncoming(playerid, 22, response);
                        JSON_Cleanup(response);
                    }
                }
                case 0:
                {
                    if(latype == 0)
                    {
                        new Node:response = JSON_Object();
                        JSON_SetInt(response, "t", -1);
                        JSON_SetInt(response, "ty", -1);
                        JSON_SetInt(response, "la", -1);
                        JSON_SetInt(response, "lc", 0);
                        JSON_SetString(response, "sn", BP_SEASON_NAME);
                        new leaderName[MAX_PLAYER_NAME];
                        new leaderId = BlackPassTop[0][topUserID];
                        if(leaderId > 0)
                        {
                            new q[128];
                            mysql_format(db_handle, q, sizeof(q), "SELECT name FROM players WHERE id = %d", leaderId);
                            new Cache:res = mysql_query(db_handle, q);
                            if(cache_num_rows() > 0) cache_get_field_content(0, "name", leaderName, db_handle, MAX_PLAYER_NAME);
                            else format(leaderName, MAX_PLAYER_NAME, "ID:%d", leaderId);
                            cache_delete(res);
                        }
                        else format(leaderName, MAX_PLAYER_NAME, "None");
                        JSON_SetString(response, "ln", leaderName);
                        JSON_SetInt(response, "lv", PlayerBP[playerid][bpLevel]);
                        JSON_SetInt(response, "td", 2505600);
                        JSON_SetInt(response, "ec", PlayerBP[playerid][bpExp]);
                        JSON_SetInt(response, "a", PlayerBP[playerid][bpPremium]);
                        JSON_SetInt(response, "sp", 0);
                        JSON_SetInt(response, "is", 0);
                        OnPacketIncoming(playerid, 22, response);
                        JSON_Cleanup(response);
                    }
                    else if(latype == 1)
                    {
                        new Node:response = JSON_Object();
                        JSON_SetInt(response, "t", -1);
                        JSON_SetInt(response, "ty", 0);
                        JSON_SetInt(response, "la", 1);
                        JSON_SetString(response, "sn", BP_SEASON_NAME);
                        new leaderName[MAX_PLAYER_NAME];
                        new leaderId = BlackPassTop[0][topUserID];
                        if(leaderId > 0)
                        {
                            new q[128];
                            mysql_format(db_handle, q, sizeof(q), "SELECT name FROM players WHERE id = %d", leaderId);
                            new Cache:res = mysql_query(db_handle, q);
                            if(cache_num_rows() > 0) cache_get_field_content(0, "name", leaderName, db_handle, MAX_PLAYER_NAME);
                            else format(leaderName, MAX_PLAYER_NAME, "ID:%d", leaderId);
                            cache_delete(res);
                        }
                        else format(leaderName, MAX_PLAYER_NAME, "None");
                        JSON_SetString(response, "ln", leaderName);
                        JSON_SetInt(response, "lv", PlayerBP[playerid][bpLevel]);
                        new Node:tkArray = JSON_Array();
                        for(new i = 0; i < MAX_BP_TASKS; i++)
                        {
                            new Node:taskObj = JSON_Object();
                            JSON_SetInt(taskObj, "id", i + 1);
                            JSON_SetInt(taskObj, "p", PlayerBP[playerid][bpTaskProgress][i]);
                            JSON_SetInt(taskObj, "s", 4);
                            JSON_ArrayAppend(tkArray, "", taskObj);
                        }
                        JSON_SetArray(response, "tk", tkArray);
                        JSON_SetInt(response, "tm", 2505600);
                        OnPacketIncoming(playerid, 22, response);
                        JSON_Cleanup(tkArray);
                        JSON_Cleanup(response);
                    }
                    else if(latype == 2)
                    {
                        new Node:response = JSON_Object();
                        JSON_SetInt(response, "t", -1);
                        JSON_SetInt(response, "ty", 0);
                        JSON_SetInt(response, "la", 2);
                        OnPacketIncoming(playerid, 22, response);
                        JSON_Cleanup(response);
                    }
                    else if(latype == 3)
                    {
                        new Node:topArray = JSON_Array();
                        new query[256];
                        mysql_format(db_handle, query, sizeof(query), "SELECT p.name, bp.total_points FROM players p INNER JOIN black_pass bp ON p.id = bp.user_id ORDER BY bp.total_points DESC LIMIT 15");
                        new Cache:result = mysql_query(db_handle, query);
                        new rows = cache_num_rows();
                        for(new i = 0; i < rows; i++)
                        {
                            new playerName[MAX_PLAYER_NAME];
                            cache_get_field_content(i, "name", playerName, db_handle, MAX_PLAYER_NAME);
                            new points = cache_get_field_content_int(i, "total_points");
                            new Node:leader = JSON_Object();
                            JSON_SetString(leader, "n", playerName);
                            JSON_SetInt(leader, "och", points);
                            JSON_ArrayAppend(topArray, "", leader);
                            JSON_Cleanup(leader);
                        }
                        cache_delete(result);
                        new Node:response = JSON_Object();
                        JSON_SetInt(response, "t", -1);
                        JSON_SetInt(response, "ty", 0);
                        JSON_SetInt(response, "la", 3);
                        JSON_SetArray(response, "j", topArray);
                        JSON_SetInt(response, "m", 1);
                        OnPacketIncoming(playerid, 22, response);
                        JSON_Cleanup(topArray);
                        JSON_Cleanup(response);
                    }
                }
                case 1:
                {
                    if(latype == 0)
                    {
                        new levelsToBuy = internal_id;
                        new cost = levelsToBuy * 100;
                        if(GetPlayerBlackCoin(playerid) >= cost)
                        {
                            GivePlayerBlackCoin(playerid, -cost);
                            new newLevel = PlayerBP[playerid][bpLevel] + levelsToBuy;
                            if(newLevel > MAX_BP_LEVEL) newLevel = MAX_BP_LEVEL;
                            PlayerBP[playerid][bpLevel] = newLevel;
                            PlayerBP[playerid][bpExp] = 0;
                            SavePlayerBP(playerid);
                            UpdateBPLeaderboard(playerid);
                            new Node:update = JSON_Object();
                            JSON_SetInt(update, "t", -2);
                            OnPacketIncoming(playerid, 22, update);
                            JSON_Cleanup(update);
                        }
                        else ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно Black Coin!", "");
                    }
                    else if(latype == 1)
                    {
                        new taskId = internal_id;
                        if(taskId >= 1 && taskId <= MAX_BP_TASKS)
                        {
                            if(PlayerBP[playerid][bpTasks][taskId-1] == 0)
                            {
                                PlayerBP[playerid][bpTasks][taskId-1] = 1;
                                new rewardExp = 100;
                                GivePlayerBPExp(playerid, rewardExp);
                                SavePlayerBP(playerid);
                                new Node:update = JSON_Object();
                                JSON_SetInt(update, "t", -2);
                                OnPacketIncoming(playerid, 22, update);
                                JSON_Cleanup(update);
                            }
                        }
                    }
                    else if(latype == 3)
                    {
                        UpdateBPLeaderboard(playerid);
                        new Node:update = JSON_Object();
                        JSON_SetInt(update, "t", -2);
                        OnPacketIncoming(playerid, 22, update);
                        JSON_Cleanup(update);
                    }
                    else if(latype == 4)
                    {
                        new premiumId = internal_id;
                        if(premiumId == 1)
                        {
                            new cost = 5000;
                            if(GetPlayerBlackCoin(playerid) >= cost)
                            {
                                GivePlayerBlackCoin(playerid, -cost);
                                PlayerBP[playerid][bpPremium] = 1;
                                SavePlayerBP(playerid);
                                ShowNotification(playerid, 1, 5, 0, 0, "Поздравляем! Вы купили статус PREMIUM BLACK PASS!", "");
                                new Node:update = JSON_Object();
                                JSON_SetInt(update, "t", -2);
                                OnPacketIncoming(playerid, 22, update);
                                JSON_Cleanup(update);
                            }
                            else ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно Black Coin!", "");
                        }
                    }
                }
                case 2:
                {
                    new currentLayout = latype;
                    new rewardId = internal_id;
                    new isPremium = price;
                    if(isPremium == 0 || (isPremium == 1 && PlayerBP[playerid][bpPremium] == 1))
                    {
                        new level = rewardId;
                        if(level >= 1 && level <= PlayerBP[playerid][bpLevel])
                        {
                            if(!IsBPRewardTaken(playerid, level))
                            {
                                SetBPRewardTaken(playerid, level, true);
                                SavePlayerBP(playerid);
                                GiveBPRewardByLevel(playerid, level);
                                new Node:update = JSON_Object();
                                JSON_SetInt(update, "t", -2);
                                OnPacketIncoming(playerid, 22, update);
                                JSON_Cleanup(update);
                            }
                            else ShowNotification(playerid, 0, 5, 0, 0, "Вы уже получили эту награду!", "");
                        }
                        else ShowNotification(playerid, 0, 5, 0, 0, "Уровень ещё не достигнут!", "");
                    }
                    else ShowNotification(playerid, 0, 5, 0, 0, "У вас нет статуса PREMIUM!", "");
                }
            }
        }
    }
    return 1;
}

        case 74:
{
    new type;
    JSON_GetInt(json, "t", type);
    printf("[DEBUG] Case 74 | Player: %d | Type: %d", playerid, type);

    switch (type)
    {
        case 3:
        {
            JSON_SetInt(json, "c", 1);
            callcmd::cases(playerid, "");
        }
        case 1:
        {
            JSON_SetInt(json, "t", 1);
            SetPVarInt(playerid, "reward_offset", 0);
            new query[256];
            mysql_format(db_handle, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT 0, 19", Player[playerid][pID]);
            mysql_tquery(db_handle, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 2:
        {
            new offset = GetPVarInt(playerid, "reward_offset");
            offset += 18;
            SetPVarInt(playerid, "reward_offset", offset);

            new query[256];
            mysql_format(db_handle, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT %d, 19", Player[playerid][pID], offset);
            mysql_tquery(db_handle, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 4:
        {
            new reward_db_id, reward_action;
            JSON_GetInt(json, "id", reward_db_id);
            JSON_GetInt(json, "s", reward_action);
            if(reward_action != 1 && reward_action != 3) reward_action = 1;

            new query[256];
            mysql_format(db_handle, query, sizeof(query), "SELECT `award_id`, `case_id` FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1", reward_db_id, Player[playerid][pID]);
            mysql_tquery(db_handle, query, "OnRewardDebug", "iii", playerid, reward_db_id, reward_action);
        }
        default:
        {
            printf("[DEBUG] Unknown Type %d in Case 74 for Player %d", type, playerid);
        }
    }
    OnPacketIncoming(playerid, 74, json);
}

case 73:
{
    new type;
    JSON_GetInt(json, "t", type);

    switch (type)
    {
        case 3:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 3);
            JSON_SetInt(response, "s", 1);

            new cs_val = GetPVarInt(playerid, "case_open_cs");
            if(cs_val <= 0) JSON_GetInt(json, "cs", cs_val);

            if(JSON_GetType(json, "bt1") == JSON_NODE_ARRAY)
            {
                new Node:bt1_array, bt1_len;
                JSON_GetArray(json, "bt1", bt1_array);
                JSON_ArrayLength(bt1_array, bt1_len);

                new log_msg[256];
                format(log_msg, sizeof(log_msg), "[BattlePass] Player %d collected %d rewards. IDs: ", playerid, bt1_len);

                for(new i = 0; i < bt1_len; i++)
                {
                    new Node:elem, reward_ui_id;
                    JSON_ArrayObject(bt1_array, i, elem);
                    JSON_GetNodeInt(elem, reward_ui_id);

                    if(!ConsumeOpenedCaseReward(playerid, reward_ui_id)) continue;

                    new temp[16];
                    format(temp, sizeof(temp), "%d, ", reward_ui_id);
                    strcat(log_msg, temp);

                    if(cs_val > 0)
                    {
                        new query[160];
                        mysql_format(db_handle, query, sizeof(query), "INSERT INTO rewards (uid, award_id, case_id) VALUES (%d, %d, %d)", Player[playerid][pID], reward_ui_id - 1, cs_val);
                        mysql_tquery(db_handle, query, "", "");
                    }
                }

                printf("%s", log_msg);
                JSON_SetArray(response, "bt1", bt1_array);
            }

            if(JSON_GetType(json, "bt2") == JSON_NODE_ARRAY)
            {
                new Node:bt2_array, bt2_len;
                JSON_GetArray(json, "bt2", bt2_array);
                JSON_ArrayLength(bt2_array, bt2_len);

                new log_msg[256];
                format(log_msg, sizeof(log_msg), "[BattlePass] Player %d sprayed rewards IDs: ", playerid);

                new total_spray = 0;
                for(new i = 0; i < bt2_len; i++)
                {
                    new Node:elem, reward_ui_id;
                    JSON_ArrayObject(bt2_array, i, elem);
                    JSON_GetNodeInt(elem, reward_ui_id);

                    if(!ConsumeOpenedCaseReward(playerid, reward_ui_id)) continue;

                    new temp[16];
                    format(temp, sizeof(temp), "%d, ", reward_ui_id);
                    strcat(log_msg, temp);

                    total_spray += GetCaseAwardSprayPriceByIndex(cs_val, reward_ui_id - 1);
                }

                if(total_spray > 0)
                {
                    AddPlayerDustValue(playerid, total_spray);
                    SavePlayerAccount(playerid);
                }

                printf("%s", log_msg);
                JSON_SetArray(response, "bt2", bt2_array);
            }

            if(GetPVarInt(playerid, "case_open_total") <= 0)
            {
                ResetOpenedCaseRewards(playerid);
            }

            JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
          //  JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
        case 1:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 1);
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "bc", GetPlayerBlackCoin(playerid));
            JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
        //    JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));

            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
        case 6:
        {
            callcmd::reward(playerid, "");
        }
        case 2:
{
    new type_val = 1, cs_val = -1;
    JSON_GetInt(json, "type", type_val);
    JSON_GetInt(json, "cs", cs_val);

    SetPVarInt(playerid, "case_open_cs", cs_val);
    ResetOpenedCaseRewards(playerid);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 2);
    JSON_SetInt(response, "s", 1);

    new open_count = (type_val == 2) ? 10 : 1;
    new price = 0;
    
    switch(cs_val)
    {
        case 1: price = 0;
        case 2: price = (open_count == 10) ? 1000 : 100;
        case 3: price = (open_count == 10) ? 7000 : 700;
        case 4: price = (open_count == 10) ? 12000 : 1200;
        case 5: price = (open_count == 10) ? 100000 : 10000;
        default:
        {
            JSON_SetInt(response, "s", 0);
            JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
            return 1;
        }
    }

    if(cs_val < 1 || cs_val > 5) return 1;

    new have_cases = GetPlayerCaseCountByType(playerid, cs_val);
    new bool:use_bc = false;

    if(have_cases < open_count)
    {
        if(GetPlayerBlackCoin(playerid) < price)
        {
            JSON_SetInt(response, "s", 0);
            JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
            ShowNotification(playerid, 2, 4, 1, 1, "???????????? ?????? ??? Black Coin!", "");
            return 1;
        }
        use_bc = true;
    }

    if(use_bc) 
    {
        if(price > 0) GivePlayerBlackCoin(playerid, -price);
    }
    else 
    {
        AddPlayerCaseCountByType(playerid, cs_val, -open_count);
    }
    
    SavePlayerAccount(playerid);

    new max_range = GetCaseMaxRange(cs_val);
    if(max_range > 0)
    {
        if(open_count == 1)
        {
            new randOne = random(max_range);
            AddOpenedCaseReward(playerid, randOne + 1);
            JSON_SetArray(response, "pr", JSON_Array(JSON_Int(randOne + 1)));
        }
        else
        {
            new Node:prArray = JSON_Array();
            for(new i = 0; i < open_count; i++)
            {
                new r = random(max_range);
                AddOpenedCaseReward(playerid, r + 1);
                prArray = JSON_Append(prArray, JSON_Array(JSON_Int(r + 1)));
            }
            JSON_SetArray(response, "pr", prArray);
        }
    }
    else
    {
        JSON_SetInt(response, "s", 0);
    }

    JSON_SetInt(response, "bc", GetPlayerBlackCoin(playerid));
    JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
    OnPacketIncoming(playerid, 73, response);
    JSON_Cleanup(response);
}
        default:
        {
            printf("[DEBUG] Unknown Type %d in Case 73 for Player %d", type, playerid);
        }
    }
}
        case 27:
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new type;
    new owner = -1, slot = -1;
    JSON_GetInt(json, "t", type);

    new Node:json_radial_data = JSON_Object();
    JSON_SetInt(json_radial_data, "t", type);

    switch (type)
    {
        case 1:
        {
            callcmd::park(playerid, "");
            JSON_SetInt(json_radial_data, "s", 1);
        }
        case 3:
        {
            callcmd::lk(playerid);
            if(vehicleid == INVALID_VEHICLE_ID)
            {
                for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
                {
                    if(!GetVehicleModel(i)) continue;
                    new Float:pos[3];
                    GetVehiclePos(i, pos[0], pos[1], pos[2]);
                    if(IsPlayerInRangeOfPoint(playerid, 4.0, pos[0], pos[1], pos[2])) { vehicleid = i; break; }
                }
            }
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                JSON_SetInt(json_radial_data, "s", (doors == VEHICLE_PARAMS_ON) ? 1 : 0);
            }
        }
        case 6:
        {
            callcmd::e(playerid, "");
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                JSON_SetInt(json_radial_data, "s", (engine == VEHICLE_PARAMS_ON) ? 1 : 0);
            }
        }
        case 14:
        {
            callcmd::l(playerid);
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                JSON_SetInt(json_radial_data, "s", (lights == VEHICLE_PARAMS_ON) ? 1 : 0);
            }
        }
        case 13:
        {
            if(vehicleid != INVALID_VEHICLE_ID && GetVehicleOwnerSlot(vehicleid, owner, slot) && VehicleInfo[owner][slot][vDalniysvet] > 0)
            {
                new bool:dalniy_on = VehToggleFlag(owner, slot, VF_DALNIY_ON);
                for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
                {
                    if(IsPlayerConnected(p)) SetVehicleDlaniy(p, vehicleid, dalniy_on ? 1 : 0);
                }
                JSON_SetInt(json_radial_data, "s", dalniy_on ? 1 : 0);
            }
            else JSON_SetInt(json_radial_data, "s", 0);
        }
        case 15:
        {
            if(vehicleid != INVALID_VEHICLE_ID && GetVehicleOwnerSlot(vehicleid, owner, slot) && VehicleInfo[owner][slot][vStrob] >= 0)
            {
                new bool:strob_on = VehToggleFlag(owner, slot, VF_STROB_ON);
                new type_to_send = strob_on ? VehicleInfo[owner][slot][vStrob] : 5;
                JSON_SetInt(json_radial_data, "s", _:strob_on);

                for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
                {
                    if(IsPlayerConnected(p)) SetVehicleStroboscopeForPlayer(p, vehicleid, type_to_send);
                }
            }
            else JSON_SetInt(json_radial_data, "s", 0);
        }
        case 8..11:
        {
            if(vehicleid == INVALID_VEHICLE_ID || !GetVehicleOwnerSlot(vehicleid, owner, slot))
            {
                JSON_SetInt(json_radial_data, "s", 0);
            }
            else
            {
                new bool:has_parts = false;
                if(type == 8) has_parts = bool:IsFullSetInstalled(VehicleInfo[owner][slot][vDrift]);
                else if(type == 9) has_parts = bool:IsFullSetInstalled(VehicleInfo[owner][slot][vComfort]);
                else if(type == 10) has_parts = bool:IsFullSetInstalled(VehicleInfo[owner][slot][vSport]);
                else if(type == 11) has_parts = bool:IsFullSetInstalled(VehicleInfo[owner][slot][vSportPlus]);

                if(!has_parts)
                {
                    JSON_SetInt(json_radial_data, "s", 0);
                    ShowNotification(playerid, 2, 4, 1, 1, "??? ????? ?????? ???????? ?? ??????? ???????!", "");
                }
                else
                {
                    new bool:active;
                    if(type == 8) active = VehGetFlag(owner, slot, VF_DRIFTA);
                    else if(type == 9) active = VehGetFlag(owner, slot, VF_COMFORTA);
                    else if(type == 10) active = VehGetFlag(owner, slot, VF_SPORTA);
                    else if(type == 11) active = VehGetFlag(owner, slot, VF_SPORTPLUSA);

                    VehSetFlag(owner, slot, VF_SPORTA, false);
                    VehSetFlag(owner, slot, VF_DRIFTA, false);
                    VehSetFlag(owner, slot, VF_COMFORTA, false);
                    VehSetFlag(owner, slot, VF_SPORTPLUSA, false);
                    SetVehicleAcceleration(vehicleid, 0.0);

                    for(new p = 0, j = GetPlayerPoolSize(); p <= j; p++)
                    {
                        if(IsPlayerConnected(p)) SetVehicleDriftMode(p, vehicleid, false);
                    }

                    if(active)
                    {
                        JSON_SetInt(json_radial_data, "s", 0);
                    }
                    else
                    {
                        new Node:reset_json = JSON_Object();
                        for(new i = 8; i <= 11; i++)
                        {
                            JSON_SetInt(reset_json, "t", i);
                            JSON_SetInt(reset_json, "s", 0);
                            OnPacketIncoming(playerid, 27, reset_json);
                        }
                        JSON_Cleanup(reset_json);

                        switch(type)
                        {
                            case 8:
                            {
                                VehSetFlag(owner, slot, VF_DRIFTA, true);
                                SetVehicleDriftMode(playerid, vehicleid, true);
                            }
                            case 9:
                            {
                                VehSetFlag(owner, slot, VF_COMFORTA, true);
                                SetVehicleAcceleration(vehicleid, 31.8);
                            }
                            case 10:
                            {
                                VehSetFlag(owner, slot, VF_SPORTA, true);
                                SetVehicleAcceleration(vehicleid, 35.0);
                            }
                            case 11:
                            {
                                VehSetFlag(owner, slot, VF_SPORTPLUSA, true);
                                SetVehicleAcceleration(vehicleid, 36.0);
                            }
                        }

                        JSON_SetInt(json_radial_data, "s", 1);
                    }
                }
            }
        }
    }

    OnPacketIncoming(playerid, 27, json_radial_data);
    JSON_Cleanup(json_radial_data);
    return 1;
}

case 28:
{
    new Node:json_packet_data = JSON_Object();
    new outcoming_data[512];

    new type, status, detal_id, color[16], color_type;

    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "d", detal_id);
    JSON_GetInt(json, "m", color_type);
    JSON_GetString(json, "d", color);
    JSON_GetInt(json, "p", detal_id);
    JSON_GetInt(json, "s", status);
    printf("[DEBUG]  paclet 28. parameter 'p' (detal_id) = %d | Type = %d", detal_id, type);
    JSON_SetInt(json_packet_data, "s", 0);
    switch (type)
    {
        case 12:
        {
            JSON_SetInt(json_packet_data, "t", 12);
            JSON_SetInt(json_packet_data, "s", 1);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
        }
        case 3:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
            {
                if(VehicleInfo[playerid][v][vSpawned] && VehicleInfo[playerid][v][vID] == vehicleid)
                {
                    new price = GetUnivCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));
                    if(GetPlayerMoneyEx(playerid) >= price)
                    {
                        if(detal_id >= 0 && detal_id < sizeof(VinylNames))
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            VehicleInfo[playerid][v][vVinyl] = detal_id;

                            new query[128];
                            mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `vinyl`='%e' WHERE `id`=%d", VinylNames[detal_id], VehicleInfo[playerid][v][vDBID]);
                            mysql_tquery(db_handle, query);

                            SetVehicleVinylForPlayer(playerid, vehicleid, VinylNames[VehicleInfo[playerid][v][vVinyl]]);

                            JSON_SetInt(json_packet_data, "t", 3);
                            JSON_SetInt(json_packet_data, "s", 1);
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                        }
                    }
                }
            }
        }
        case 1:
        {
            printf("[DEBUG] TechCenter: Type: %d, ColorType: %d, Color: %s", type, color_type, color);
            new color_val, vehid = GetPlayerVehicleID(playerid);
            sscanf(color, "h", color_val); 

            for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
            {
                if(VehicleInfo[playerid][v][vSpawned] && VehicleInfo[playerid][v][vID] == vehid)
                {
                    new query[128];
                    if(color_type == 0)
                    {
                        new vehicleid = GetPlayerVehicleID(playerid);
                        new price = GetBodyPaintCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            VehicleInfo[playerid][v][vBodyColor] = color_val;
                            mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `body_color`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            mysql_tquery(db_handle, query);

                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                        else
                        {
                            JSON_SetInt(json_packet_data, "s", 0);
                        }
                    }
                    else if(color_type == 1)
                    {
                        new vehicleid = GetPlayerVehicleID(playerid);
                        new price = GetBodyPaintCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            VehicleInfo[playerid][v][vDiskColor] = color_val;
                            mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `disk_color`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            mysql_tquery(db_handle, query);

                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                        else
                        {
                            JSON_SetInt(json_packet_data, "s", 0);
                        }
                    }
                    else if(color_type == 10)
                    {
                        new vehicleid = GetPlayerVehicleID(playerid);
                        new price = GetDoubleCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            VehicleInfo[playerid][v][vLightsColor] = color_val;
                            mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `lights_color`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            mysql_tquery(db_handle, query);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                    else if(color_type == 3 || color_type == 4)
                    {
                        new vehicleid = GetPlayerVehicleID(playerid);
                        new price = GetExtraCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                            GivePlayerMoneyEx(playerid, -price);

                            if(color_type == 3)
                            {
                                VehicleInfo[playerid][v][vWindFront] = color_val;
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `pered_windcolor`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            }
                            else
                            {
                                VehicleInfo[playerid][v][vWindRear] = color_val;
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `zadni_windcolor`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            }
                            mysql_tquery(db_handle, query);
                        }
                    }
                    else if(color_type == 11 || color_type == 12 || color_type == 13)
                    {
                        new vehicleid = GetPlayerVehicleID(playerid);
                        new price = GetUnivCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                            GivePlayerMoneyEx(playerid, -price);

                            if(color_type == 11)
                            {
                                VehicleInfo[playerid][v][vNeonMain] = color_val;
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `neon_main`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            }
                            else if(color_type == 12)
                            {
                                VehicleInfo[playerid][v][vNeon1] = color_val;
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `neon1`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            }
                            else if(color_type == 13)
                            {
                                VehicleInfo[playerid][v][vNeon2] = color_val;
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `neon2`=%d WHERE `id`=%d", color_val, VehicleInfo[playerid][v][vDBID]);
                            }

                            mysql_tquery(db_handle, query);
                        }
                    }

                    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
                    {
                        if(!IsPlayerConnected(i)) continue;
                        if(color_type == 0) SetVehicleMainColorHEX(i, vehid, color_val);
                        else if(color_type == 1) SetVehicleDiskColorHEX(i, vehid, color_val);
                        else if(color_type == 10) SetVehicleLightsColorHEX(i, vehid, color_val);
                        else if(color_type == 3) UpdateVehicleTint(i, vehid, color_val, VehicleInfo[playerid][v][vWindRear]);
                        else if(color_type == 4) UpdateVehicleTint(i, vehid, VehicleInfo[playerid][v][vWindFront], color_val);
                        else if(color_type >= 11 && color_type <= 13) UpdateVehicleNeon(i, vehid, VehicleInfo[playerid][v][vNeonMain], VehicleInfo[playerid][v][vNeon1], VehicleInfo[playerid][v][vNeon2]);
                    }
                }
            }
            JSON_SetInt(json_packet_data, "t", 1);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
            JSON_SetInt(json_packet_data, "s", 1);
        }
        // ========== ШИНОМОНТАЖ (полностью исправленный) ==========
        case 20, 21, 22, 23, 24, 25, 26, 27, 28, 29:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new slot = GetPlayerVehicleSlot(playerid, vehicleid);
            if(slot != -1)
            {
                new Float:fval;
                new ival;
                new bool:is_float = true;
                new col_name[32];
                new price;
                switch(type)
                {
                    case 20: { JSON_GetFloat(json, "v", fval); col_name = "wheel_radius"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 5000; }
                    case 21: { JSON_GetFloat(json, "v", fval); col_name = "wheel_width_front"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 8000; }
                    case 22: { JSON_GetFloat(json, "v", fval); col_name = "wheel_width_rear"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 8000; }
                    case 23: { JSON_GetFloat(json, "v", fval); col_name = "offset_front"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 7000; }
                    case 24: { JSON_GetFloat(json, "v", fval); col_name = "offset_rear"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 7000; }
                    case 25: { JSON_GetFloat(json, "v", fval); col_name = "camber_front"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 6000; }
                    case 26: { JSON_GetFloat(json, "v", fval); col_name = "camber_rear"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 200) + 6000; }
                    case 27: { JSON_GetFloat(json, "v", fval); col_name = "clearance"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 150) + 10000; }
                    case 28: { JSON_GetInt(json, "v", ival); is_float = false; col_name = "hydra"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 100) + 50000; }
                    case 29: { JSON_GetInt(json, "v", ival); is_float = false; col_name = "pnevmo"; price = (GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 100) + 80000; }
                }
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);
                    new query[128];
                    if(is_float) {
                        mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%f WHERE `id`=%d", col_name, fval, VehicleInfo[playerid][slot][vDBID]);
                        mysql_tquery(db_handle, query, "");
                        if(type == 20) VehicleInfo[playerid][slot][vWheelRadius] = fval;
                        else if(type == 21) VehicleInfo[playerid][slot][vWheelWidthFront] = fval;
                        else if(type == 22) VehicleInfo[playerid][slot][vWheelWidthRear] = fval;
                        else if(type == 23) VehicleInfo[playerid][slot][vOffsetFront] = fval;
                        else if(type == 24) VehicleInfo[playerid][slot][vOffsetRear] = fval;
                        else if(type == 25) VehicleInfo[playerid][slot][vCamberFront] = fval;
                        else if(type == 26) VehicleInfo[playerid][slot][vCamberRear] = fval;
                        else if(type == 27) VehicleInfo[playerid][slot][vClearance] = fval;
                    } else {
                        mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `%s`=%d WHERE `id`=%d", col_name, ival, VehicleInfo[playerid][slot][vDBID]);
                        mysql_tquery(db_handle, query, "");
                        if(type == 28) VehicleInfo[playerid][slot][vHydra] = ival;
                        else if(type == 29) VehicleInfo[playerid][slot][vPnevmo] = ival;
                    }
                    // Визуальное применение
                    switch(type)
                    {
                        case 20: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleWheelSize(i, vehicleid, (fval / 250.0) + 0.7);
                        case 21: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleWheelWidth(i, vehicleid, (fval / 80.0) + 0.5, (VehicleInfo[playerid][slot][vWheelWidthRear] / 80.0) + 0.5);
                        case 22: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleWheelWidth(i, vehicleid, (VehicleInfo[playerid][slot][vWheelWidthFront] / 80.0) + 0.5, (fval / 80.0) + 0.5);
                        // case 23 и 24 — без визуала (нет функции SetVehicleWheelDepartureFP)
                        case 25: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleWheelCamber(i, vehicleid, fval / -200.0, VehicleInfo[playerid][slot][vCamberRear] / -200.0);
                        case 26: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleWheelCamber(i, vehicleid, VehicleInfo[playerid][slot][vCamberFront] / -200.0, fval / -200.0);
                        case 27: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleSuspension(i, vehicleid, fval / 50.0);
                        case 28: for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i)) SetVehicleHydraulic(i, vehicleid, ival ? true : false);
                    }
                    JSON_SetInt(json_packet_data, "s", 1);
                }
                else JSON_SetInt(json_packet_data, "s", 0);
            }
        }
        // =====================================================
        case 0: 
        {
            new carid = GetPlayerVehicleID(playerid);
            new Float:x, Float:y, Float:z, Float:a;

            if(InStailing[playerid])
            {
                x = 2297.6091; y = -2614.1564; z = 21.0541; a = 65.6191;
            }
            else
            {
                x = -413.339; y = 1027.331; z = 11.235; a = 1.000;
            }

            InStailing[playerid] = false;

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);

            if(carid != 0)
            {
                SetVehicleVirtualWorld(carid, 0);
                SetVehiclePos(carid, x, y, z);
                SetVehicleZAngle(carid, a);
                PutPlayerInVehicle(playerid, carid, 0);
            }
            else
            {
                SetPlayerPos(playerid, x, y, z);
                SetPlayerFacingAngle(playerid, a);
            }

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
        }
        case 7:
        {
            switch (detal_id)
            {
                case 130:
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    printf("[DEBUG] Process. VehicleID: %d", vehicleid);
                    for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
                    {
                        if(VehicleInfo[playerid][v][vSpawned] && VehicleInfo[playerid][v][vID] == vehicleid)
                        {
                            new price = GetDalniyCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));
                            if(GetPlayerMoneyEx(playerid) >= price)
                            {
                                GivePlayerMoneyEx(playerid, -price);
                                VehicleInfo[playerid][v][vDalniysvet] = 1;

                                new query[128];
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `dalniysvet` = 1 WHERE `id` = %d", VehicleInfo[playerid][v][vDBID]);
                                mysql_tquery(db_handle, query);

                                JSON_SetInt(json_packet_data, "t", 7);
                                JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                                JSON_SetInt(json_packet_data, "p", detal_id);
                                JSON_SetInt(json_packet_data, "s", 1);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "s", 0);
                            }
                        }
                    }
                }
                case 32:
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
                    {
                        if(VehicleInfo[playerid][v][vSpawned] && VehicleInfo[playerid][v][vID] == vehicleid)
                        {
                            new price = (((GetVehiclePriceByModel(GetVehicleModel(vehicleid)) / 100) + 10000 + 40000) * 3) / 1000;
                            
                            if(GetPlayerBlackCoin(playerid) >= price)
                            {
                                new strobLevel = 32 - 28;
                                GivePlayerBlackCoin(playerid, -price);
                                VehicleInfo[playerid][v][vStrob] = strobLevel;

                                new query[128];
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `strob` = %d WHERE `id` = %d", strobLevel, VehicleInfo[playerid][v][vDBID]);
                                mysql_tquery(db_handle, query);

                                for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
                                {
                                    if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
                                }

                                JSON_SetInt(json_packet_data, "t", 7);
                                JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid)); 
                                JSON_SetInt(json_packet_data, "p", 32);
                                JSON_SetInt(json_packet_data, "s", 1);
                            }
                            else JSON_SetInt(json_packet_data, "s", 0);
                            break;
                        }
                    }
                }
                case 28, 29, 30, 31:
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
                    {
                        if(VehicleInfo[playerid][v][vSpawned] && VehicleInfo[playerid][v][vID] == vehicleid)
                        {
                            new price = GetUnivCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));
                            if(GetPlayerMoneyEx(playerid) >= price)
                            {
                                new strobLevel = detal_id - 28;
                                GivePlayerMoneyEx(playerid, -price);
                                VehicleInfo[playerid][v][vStrob] = strobLevel;

                                new query[128];
                                mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `strob` = %d WHERE `id` = %d", strobLevel, VehicleInfo[playerid][v][vDBID]);
                                mysql_tquery(db_handle, query);

                                for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
                                {
                                    if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
                                }

                                JSON_SetInt(json_packet_data, "t", 7);
                                JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                                JSON_SetInt(json_packet_data, "p", detal_id);
                                JSON_SetInt(json_packet_data, "s", 1);
                            }
                            else JSON_SetInt(json_packet_data, "s", 0);
                            break;
                        }
                    }
                }
                case 4, 9, 14, 19, 24: // comfort 
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    new model = GetVehicleModel(vehicleid);
                    new price = GetTuningPrice(GetVehiclePriceByModel(model), 0);

                    if(GetPlayerMoneyEx(playerid) >= price)
                    {
                        if(BuyPart(playerid, vehicleid, detal_id)) 
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            JSON_SetInt(json_packet_data, "t", 7);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));   
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                }
                case 5, 10, 15, 20, 25: // sport
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    new model = GetVehicleModel(vehicleid);
                    new price = GetTuningPrice(GetVehiclePriceByModel(model), 1);

                    if(GetPlayerMoneyEx(playerid) >= price)
                    {
                        if(BuyPart(playerid, vehicleid, detal_id)) 
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            JSON_SetInt(json_packet_data, "t", 7);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));   
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                }
                case 6, 11, 16, 21, 26: // drift
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    new model = GetVehicleModel(vehicleid);
                    new price = GetTuningPrice(GetVehiclePriceByModel(model), 2);

                    if(GetPlayerMoneyEx(playerid) >= price)
                    {
                        if(BuyPart(playerid, vehicleid, detal_id)) 
                        {
                            GivePlayerMoneyEx(playerid, -price);
                            JSON_SetInt(json_packet_data, "t", 7);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));   
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                }
                case 7, 12, 17, 22, 27: // sport+
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    new model = GetVehicleModel(vehicleid);
                    new price = GetTuningPrice(GetVehiclePriceByModel(model), 3);

                    if(GetPlayerBlackCoin(playerid) >= price)
                    {
                        if(BuyPart(playerid, vehicleid, detal_id)) 
                        {
                            GivePlayerBlackCoin(playerid, -price);
                            JSON_SetInt(json_packet_data, "t", 7);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));   
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                }
                case 0, 1, 2:
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                    new model = GetVehicleModel(vehicleid);
                    new price = GetNitroPrice(GetVehiclePriceByModel(model), detal_id); 

                    if(GetPlayerMoneyEx(playerid) >= price)
                    {
                        if(BuyPart(playerid, vehicleid, detal_id)) 
                        {
                            new nitro_id;
                            switch(detal_id)
                            {
                                case 0: nitro_id = 1009;
                                case 1: nitro_id = 1008;
                                case 2: nitro_id = 1010;
                            }
                            AddVehicleComponent(vehicleid, nitro_id);
                            GivePlayerMoneyEx(playerid, -price);
                            JSON_SetInt(json_packet_data, "t", 7);
                            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));   
                            JSON_SetInt(json_packet_data, "p", detal_id);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 0);
                    }
                }
            }
        }
    }
    new packet_status = 0;
    JSON_GetInt(json_packet_data, "s", packet_status);
    if(packet_status == 0 && type != 12) ShowNotification(playerid, 2, 4, 1, 1, "Недостаточно средств или действие недоступно!", "");
    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncoming(playerid, 28, json_packet_data);
    JSON_Cleanup(json_packet_data);
}

case 33:
{
    Inventory_HandlePacket(playerid, json);
    return 1;
}

case 50:
{
    SpawnLocation_HandlePacket(playerid, json);
    return 1;
}

case 77:
{
    Marketplace_HandlePacket(playerid, json);
    return 1;
}
    
        case 38:
        {
            new t;
            JSON_GetInt(json, "t", t);

            switch(t)
            {
                case -1:
{
    new skin_id;
    JSON_GetInt(json, "i", skin_id);
    SetPlayerSkin(playerid, skin_id);
    
    return 1;
}
                case 1:
                {
                    new password[65];
                    JSON_GetString(json, "p", password);
                    format(Player[playerid][pPassword], 65, "%s", password);

                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", 3);
                    OnPacketIncoming(playerid, 38, response);
                    JSON_Cleanup(response);
                    return 1;
                }
case 3:
{
    SetPlayerPosEx(playerid, 1200.399902, 607.876281, 1349.309448, 184.824386, 1, playerid);
    SetPlayerCameraPos(playerid, 1201.510253, 604.738281, 1350.530395);
    SetPlayerCameraLookAt(playerid, 1193.910253, 630.0, 1342.530395);
    
    new query_reg[600];
    mysql_format(db_handle, query_reg, sizeof(query_reg),
        "INSERT INTO `players` (`name`,`password`,`level`,`money`,`skin`,`admlvl`,`admpass`,`admprefix`,`countbomjcases`,`giftdelay`) \
        VALUES ('%e','%e',1,150000,74,0,0,'None',1,7200)", 
        Player[playerid][pName], Player[playerid][pPassword]
    );

    mysql_tquery(db_handle, query_reg, "OnAccountRegister", "i", playerid);

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 0);
    OnPacketIncoming(playerid, 38, response);
    JSON_Cleanup(response);
    return 1;
}
case 5:
{
    new final_skin;
    JSON_GetInt(json, "r", final_skin);
    Player[playerid][pSkin] = final_skin;
    SetPlayerSkin(playerid, final_skin);
    
    SavePlayerAccount(playerid); 

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", -1); 
    JSON_SetInt(response, "c", 1); 
    new rand = random(sizeof(RandomSpawns));
    SetSpawnInfo(playerid, 0, Player[playerid][pSkin], RandomSpawns[rand][0], RandomSpawns[rand][1], RandomSpawns[rand][2], RandomSpawns[rand][3], 0, 0, 0, 0, 0, 0);
    if(Player[playerid][pID] > 0) SetTimerEx("LoadPlayerFamily", 500, false, "i", playerid);
    TogglePlayerSpectating(playerid, false);
    TogglePlayerControllable(playerid, true);
    SpawnPlayer(playerid);
    ShowNotification(playerid, 3, 5, 0, 0, "??? ??? ????? ???? ?????, ?? ???????????!", "");
    OnPacketIncoming(playerid, 38, response);
    JSON_Cleanup(response);
    return 1;
}
                case 6:
                {
                    new password[65];
                    if(!JSON_GetString(json, "s", password)) JSON_GetString(json, "p", password); 
                    
                    new query_log[256];
                    mysql_format(db_handle, query_log, sizeof(query_log), "SELECT * FROM `players` WHERE `name` = '%e' AND `password` = '%e' LIMIT 1", Player[playerid][pName], password);
                    mysql_function_query(db_handle, query_log, true, "OnAccountLoad", "i", playerid);
                    return 1;
                }
            }
        }
    }
    JSON_Cleanup(json);
    return 1;
}

stock GetCaseMaxRange(case_id)
{
    switch(case_id)
    {
        case 1: return 20;
        case 2: return 28;
        case 3: return 37;
        case 4: return 31;
        case 5: return 20;
        case 8: return 25;
    }
    return 0;
}

stock GetCaseAwardSprayPriceByIndex(case_id, award_id)
{
    if(award_id < 0) return 0;

    switch(case_id)
    {
        case 1: if(award_id < sizeof(CaseDailyAwards)) return CaseDailyAwards[award_id][aSprayPrice];
        case 2: if(award_id < sizeof(CaseBomjAwards)) return CaseBomjAwards[award_id][aSprayPrice];
        case 3: if(award_id < sizeof(CaseStandartAwards)) return CaseStandartAwards[award_id][aSprayPrice];
        case 4: if(award_id < sizeof(CaseAutoAwards)) return CaseAutoAwards[award_id][aSprayPrice];
        case 5: if(award_id < sizeof(CaseSpecialAwards)) return CaseSpecialAwards[award_id][aSprayPrice];
        case 8: if(award_id < sizeof(CaseDriveAwards)) return CaseDriveAwards[award_id][aSprayPrice];
    }
    return 0;
}

stock ResetOpenedCaseRewards(playerid)
{
    for(new i = 1; i <= 100; i++)
    {
        new key[24];
        format(key, sizeof(key), "open_case_%d", i);
        DeletePVar(playerid, key);
    }
    DeletePVar(playerid, "case_open_total");
    return 1;
}

stock AddOpenedCaseReward(playerid, reward_ui_id)
{
    if(reward_ui_id <= 0 || reward_ui_id > 100) return 0;

    new key[24];
    format(key, sizeof(key), "open_case_%d", reward_ui_id);
    SetPVarInt(playerid, key, GetPVarInt(playerid, key) + 1);
    SetPVarInt(playerid, "case_open_total", GetPVarInt(playerid, "case_open_total") + 1);
    return 1;
}

stock ConsumeOpenedCaseReward(playerid, reward_ui_id)
{
    if(reward_ui_id <= 0 || reward_ui_id > 100) return false;

    new key[24];
    format(key, sizeof(key), "open_case_%d", reward_ui_id);

    new cnt = GetPVarInt(playerid, key);
    if(cnt <= 0) return false;

    SetPVarInt(playerid, key, cnt - 1);

    new total = GetPVarInt(playerid, "case_open_total");
    if(total > 0) SetPVarInt(playerid, "case_open_total", total - 1);
    return true;
}
stock GetTuningPrice(gosCost, tuneId)
{
    new Float:percent;
    new addedValue;

    switch(tuneId)
    {
        case 0: { percent = 4.0; addedValue = 15000; } // Comfort
        case 1: { percent = 7.0; addedValue = 15000; } // Sport
        case 2: { percent = 5.0; addedValue = 15000; } // Drift
        case 3: { percent = 0.005; addedValue = 20; }  // Sport+ (Донат)
        default: return 0;
    }
    return floatround((float(gosCost) * percent / 100.0) + float(addedValue));
}

stock GetNitroPrice(gosCost, nitroId)
{
    new Float:percent;
    switch(nitroId)
    {
        case 0: percent = 2.0; // Нитро 2х
        case 1: percent = 5.0; // Нитро 5х
        case 2: percent = 7.0; // Нитро 10х
        default: return 0;
    }
    return floatround((float(gosCost) * percent / 100.0) + 15000.0);
}

stock SetPlayerPosEx(playerid, Float: x, Float: y, Float: z, Float: angle, interior = -1, virtual_world = -1, freeze = true)
{
	SetPlayerPos(playerid, x, y, z);

	SetPlayerFacingAngle(playerid, angle);
	SetCameraBehindPlayer(playerid);

	if(interior != -1)
	{
		SetPlayerInterior(playerid, interior);
	}
	if(virtual_world != -1)
	{
		SetPlayerVirtualWorld(playerid, virtual_world);
	}
	return 1;
}


