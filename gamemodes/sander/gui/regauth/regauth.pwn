stock PacketIncomingAuthReg(playerid, Node:JSONObject)
{
    new t, Node:json = JSON_Object();
    JSON_GetInt(JSONObject, "t", t);
    
    new json_debug[1024];
    JSON_Stringify(JSONObject, json_debug, 1024);
    printf("[DEBUG] case 38: получен JSON от игрока %d: %s", playerid, json_debug);

    switch(t)
    {
        case -1:
                {
                    new skin_id;
                    JSON_GetInt(JSONObject, "i", skin_id);

                    SetPlayerSkin(playerid, skin_id);
                    JSON_Cleanup(JSONObject);
                    return 1;
                }
                case 1:
                {
                    new email[61], password[24];
                    JSON_GetString(JSONObject, "s", email);
                    JSON_GetString(JSONObject, "p", password);

                    if(!(6 <= strlen(password) <= 32))
                    {
                        ShowNotificationSander(playerid, 2, 5, -1, -1, "Пароль должен быть от 6 до 32 символов", "");
                        JSON_Cleanup(JSONObject);
                        return 1;
                    }

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);

                    if(strlen(email) != 0)
                    {
                        format(g_player[playerid][P_EMAIL], 61, "%s", email);
                    }

                    SendPacketToClient(playerid, 38, json);
                    JSON_Cleanup(JSONObject);
                    JSON_Cleanup(json);
                    return 1;
                }
        case 3:
                {
                    new gender;
                    JSON_GetInt(JSONObject, "r", gender);

                    SetPlayerData(playerid, P_SEX, gender);

                    if(CreatePlayerAccount(playerid))
                    {
                        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);

                        SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
                        SpawnPlayer(playerid);
                    }
                    else
                    {
                        ShowNotificationSander(playerid, 2, 5, -1, -1, "Ошибка создания аккаунта!", "");
                        Kick(playerid);
                    }

                    SendPacketToClient(playerid, 38, json);
                    JSON_Cleanup(JSONObject);
                    JSON_Cleanup(json);
                    return 1;
                }
        case 4:
                {
                    new invite_nick[MAX_PLAYER_NAME];
                    JSON_GetString(JSONObject, "s", invite_nick);

                    if(strlen(invite_nick) == 0)
                    {
                        SendPacketToClient(playerid, 38, json);
                        JSON_Cleanup(JSONObject);
                        JSON_Cleanup(json);
                        return;
                    }

                    new query[75], Cache:result;
                    mysql_format(mysql, query, sizeof(query), "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
                    result = mysql_query(mysql, query);

                    if(cache_num_rows())
                        SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
                    cache_delete(result);

                    if(!GetPlayerData(playerid, P_REFER))
                    {
                        ShowNotificationSander(playerid, 2, 5, -1, -1, "Указанный Nick-Name не найден!", "");
                        JSON_Cleanup(JSONObject);
                        JSON_Cleanup(json);
                        return;
                    }

                    SendPacketToClient(playerid, 38, json);
                    JSON_Cleanup(JSONObject);
                    JSON_Cleanup(json);
                }
        case 5:
                {
                    new final_skin;
                    JSON_GetInt(JSONObject, "r", final_skin);

                    SetPlayerData(playerid, P_SKIN, final_skin);

                    HidePlayerSelectPanel(playerid);
                    HidePlayerSelectPanelPrice(playerid);

                    SetPlayerData(playerid, P_SELECT_SKIN, -1);
                    SetPlayerSpawnInit(playerid);

                    SetPlayerData(playerid, P_MONEY, bonus_money);
 				  UpdatePlayerDatabaseInt(playerid, "money", bonus_money);
   				GiveDefaultLicenses(playerid);
   				new reason[144];
       		    format(reason, sizeof(reason), "Бонус за регистрацию");
      		     GivePlayerDonateRub(playerid, bonus_donate, reason, true, true);

     		      SetPlayerData(playerid, P_LEVEL, bonus_lvl);
       		    UpdatePlayerDatabaseInt(playerid, "level", bonus_lvl);

       		    SetPlayerData(playerid, P_PREMIUM, vip_type);
         		  SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
        		   UpdatePlayerDatabaseInt(playerid, "premium", vip_type);
           		UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

           		AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
          		UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                    

                    
                    new spawn_random = random(4);
   				 SetPlayerPosEx(playerid, spawn_pos_data[spawn_random][0], spawn_pos_data[spawn_random][1], spawn_pos_data[spawn_random][2], spawn_pos_data[spawn_random][3], 0, 0);
					SpawnPlayer(playerid);
                    SetPlayerInit(playerid);
                    StopAudioStream(playerid);
                    new query[90];
                    mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET skin=%d, last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
                    mysql_query(mysql, query, false);

                    JSON_Cleanup(JSONObject);
                    JSON_Cleanup(json);
                }
        case 6:
                {
                    new password[24], hash[65], auto_login;
                    JSON_GetString(JSONObject, "s", password);
                    JSON_GetInt(JSONObject, "r", auto_login);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);
                    SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

                    if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
                    {
                        SetPlayerData(playerid, P_AUTH_TIME, -1);
                        LoadPlayerData(playerid);
                        SetPlayerLogged(playerid, true);
                        StopAudioStream(playerid);

                        SendPacketToClient(playerid, 38, json);
                    }
                    else
                    {
                        ShowNotificationSander(playerid, 2, 5, -1, -1, "Неверный пароль!", "");
                    }

                    JSON_Cleanup(JSONObject);
                    JSON_Cleanup(json);
                }
    }
}