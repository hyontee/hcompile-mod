#if defined _GORDREEV_AUTH_GUI_INC_
    #endinput
#endif
#define _GORDREEV_AUTH_GUI_INC_

#define GUI_AUTH_ID (38)

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
    JSON_SetInt(json, "o", 1);
    OnPacketIncoming(playerid, guiid, json);
}

stock SendPlayerGUIData(playerid, guiid, Node:json)
{
    OnPacketIncoming(playerid, guiid, json);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
    new BitStream:bitstream = BS_New();

    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, guiid);

    new data[1024];
    JSON_Stringify(json, data);

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock ShowNotificationLaird(playerid, type, duration, id, subId, const caption[], const btnCaption[] = "")
{
    new Node:JSONObject = JSON_Object();
    new text_caption[144];
    new text_button[64];

    strmid(text_caption, caption, 0, strlen(caption), sizeof(text_caption));
    strmid(text_button, btnCaption, 0, strlen(btnCaption), sizeof(text_button));

    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", text_caption);
    JSON_SetString(JSONObject, "k", text_button);

    ShowPlayerGUI(playerid, 13, JSONObject);
    JSON_Cleanup(JSONObject);
}

stock ShowPlayerAuthGUI(playerid, bool:is_registered)
{
    new Node:json = JSON_Object();

    JSON_SetInt(json, "r", is_registered ? 1 : 0);

    ShowPlayerGUI(playerid, GUI_AUTH_ID, json);
    JSON_Cleanup(json);
}

stock SendAuthGuiResult(playerid, code)
{
    new Node:json = JSON_Object();

    JSON_SetInt(json, "c", code);
    SendPlayerGUIData(playerid, GUI_AUTH_ID, json);

    JSON_Cleanup(json);
}

stock SendAuthGuiAck(playerid)
{
    new Node:json = JSON_Object();
    SendPlayerGUIData(playerid, GUI_AUTH_ID, json);
    JSON_Cleanup(json);
}

stock StartRegisterSkinSelection(playerid)
{
    if(REG_AGE[playerid] != 1)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Вы не ввели возраст при регистрации.", "");
        return 1;
    }
    if(REG_SEX[playerid] != 1)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Вы не выбрали пол при регистрации.", "");
        return 1;
    }
    if(REG_EMAIL[playerid] != 1)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Вы не ввели почту при регистрации.", "");
        return 1;
    }
    if(REG_PASS[playerid] != 1)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Вы не ввели пароль при регистрации.", "");
        return 1;
    }

    PlayerRegistered[playerid] = 1;
    playerReg{playerid} = 0;

    if(PI[playerid][pSex] == 1)
        PI[playerid][pModel] = JoinRegM[0];
    else
        PI[playerid][pModel] = JoinRegF[0];

    SetPlayerHealth(playerid, 100.0);
    CreateAccount(playerid, PI[playerid][pPassword]);

    return 1;
}

stock HandleGuiRegisterData(playerid, email[], password[])
{
    if(!regstatus{playerid}) return 1;

    if(strlen(password) < 2 || strlen(password) > 32)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Пароль должен быть от 2 до 32 символов", "");
        return 1;
    }

    for(new i = strlen(password) - 1; i >= 0; i--)
    {
        switch(password[i])
        {
            case '0'..'9', 'а'..'я', 'a'..'z', 'А'..'Я', 'A'..'Z': continue;
            default:
            {
                ShowNotificationLaird(playerid, 2, 5, 0, 0, "В пароле допустимы только буквы и цифры", "");
                return 1;
            }
        }
    }

    if(strlen(email))
    {
        if(strlen(email) > 36 || !IsValidMail(email, strlen(email)))
        {
            ShowNotificationLaird(playerid, 2, 5, 0, 0, "Укажите корректную почту", "");
            return 1;
        }

        new query_mail[128], Cache:result;
        mysql_format(db_prod, query_mail, sizeof(query_mail), "SELECT mail FROM accounts WHERE mail = '%e' LIMIT 1", email);
        result = mysql_query(db_prod, query_mail);

        if(cache_num_rows())
        {
            cache_delete(result);
            ShowNotificationLaird(playerid, 2, 5, 0, 0, "Данный почтовый ящик уже занят", "");
            return 1;
        }
        cache_delete(result);

        strmid(PI[playerid][pMail], email, 0, strlen(email), 64);
    }
    else
    {
        strmid(PI[playerid][pMail], "undefinedmailurl", 0, strlen("undefinedmailurl"), 64);
    }

    settext(PI[playerid][pPassword], password);
    settext(PI[playerid][pReferal], "None");

    REG_PASS[playerid] = 1;
    REG_EMAIL[playerid] = 1;

    ShowNotificationLaird(playerid, 3, 4, 0, 0, "Данные регистрации сохранены", "");
    SendAuthGuiAck(playerid);

    return 1;
}

stock HandleGuiReferal(playerid, referal[])
{
    if(!regstatus{playerid}) return 1;

    if(!strlen(referal))
    {
        settext(PI[playerid][pReferal], "None");
        SendAuthGuiAck(playerid);
        return 1;
    }

    if(strlen(referal) > 23)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Слишком длинный ник реферала", "");
        return 1;
    }

    new query_ref[128], Cache:result;
    mysql_format(db_prod, query_ref, sizeof(query_ref), "SELECT name FROM accounts WHERE name = '%e' LIMIT 1", referal);
    result = mysql_query(db_prod, query_ref);

    if(!cache_num_rows())
    {
        cache_delete(result);
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Реферал с таким ником не найден", "");
        return 1;
    }

    cache_delete(result);

    settext(PI[playerid][pReferal], referal);
    ShowNotificationLaird(playerid, 3, 4, 0, 0, "Реферал сохранен", "");
    SendAuthGuiAck(playerid);

    return 1;
}

stock HandleGuiRegisterFinish(playerid, gender)
{
    if(!regstatus{playerid}) return 1;

    PI[playerid][pSex] = (gender == 0) ? 1 : 2;

    REG_SEX[playerid] = 1;
    if(REG_AGE[playerid] != 1)
    {
        PI[playerid][pAge] = 18;
        REG_AGE[playerid] = 1;
    }

    SendAuthGuiAck(playerid);
    return 1;
}

stock HandleGuiSkinPreview(playerid, skin_id)
{
    if(!regstatus{playerid}) return 1;
    if(skin_id < 0 || skin_id > 311) return 1;

    SetPlayerSkin(playerid, skin_id);
    return 1;
}

stock HandleGuiRegisterSkinFinalize(playerid, final_skin)
{
    if(!regstatus{playerid}) return 1;

    if(final_skin < 0 || final_skin > 311)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Некорректный скин", "");
        return 1;
    }

    PI[playerid][pModel] = final_skin;
    ChosenSkin[playerid] = final_skin;
    SetPlayerSkin(playerid, final_skin);

    StartRegisterSkinSelection(playerid);
    SendAuthGuiResult(playerid, 1);

    return 1;
}

stock HandleGuiLogin(playerid, password[])
{
    if(regstatus{playerid}) return 1;

    if(strlen(password) < 2 || strlen(password) > 32)
    {
        ShowNotificationLaird(playerid, 2, 5, 0, 0, "Пароль должен быть от 2 до 32 символов", "");
        return 1;
    }

    if(strcmp(password, PI[playerid][pPassword], false))
    {
        PlayerLogTries[playerid]++;

        if(PlayerLogTries[playerid] >= 4)
        {
            ShowNotificationLaird(playerid, 2, 5, 0, 0, "Вы ввели неверный пароль несколько раз", "");
            return KickEx(playerid, "reg_p_inv");
        }

        new msg[96];
        format(msg, sizeof msg, "Неверный пароль. Осталось попыток: %d", 3 - PlayerLogTries[playerid]);
        ShowNotificationLaird(playerid, 2, 5, 0, 0, msg, "");

        return 1;
    }

    AVT_PASS[playerid] = 1;

    STRING_GLOBAL[0] = EOS;
    mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "SELECT * FROM `bans` WHERE `name` = '%s' LIMIT 1;", GetName(playerid));
    mysql_tquery(db_prod, STRING_GLOBAL, "check_banlist", "i", playerid);

    ShowNotificationLaird(playerid, 3, 4, 0, 0, "Авторизация успешна", "");
    SendAuthGuiResult(playerid, 1);

    return 1;
}

IPacket:252(playerid, BitStream:bitstream)
{
    new data[512];
    new outcoming_data[512];
    new Node:json = JSON_Object();
    new Node:json_packet_data = JSON_Object();
    new Node:response = Node:0; // 0 == not created
    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length, json_data[256];
    BS_ReadValue(bitstream, PR_UINT32, length);
    BS_ReadValue(bitstream, PR_STRING, json_data, length);

    new Node:JSONObject = JSON_Object();
    JSON_Parse(json_data, JSONObject);

    switch(guiid)
    {
        case GUI_AUTH_ID:
        {
            new action;
            JSON_GetInt(JSONObject, "t", action);

            switch(action)
            {
                case -1:
                {
                    new skin_id;
                    JSON_GetInt(JSONObject, "i", skin_id);

                    HandleGuiSkinPreview(playerid, skin_id);
                }
                case 1:
                {
                    new email[64], password[33];
                    JSON_GetString(JSONObject, "s", email);
                    JSON_GetString(JSONObject, "p", password);

                    HandleGuiRegisterData(playerid, email, password);
                }
                case 3:
                {
                    new gender;
                    JSON_GetInt(JSONObject, "r", gender);

                    HandleGuiRegisterFinish(playerid, gender);
                }
                case 4:
                {
                    new referal[24];
                    JSON_GetString(JSONObject, "s", referal);

                    HandleGuiReferal(playerid, referal);
                }
                case 5:
                {
                    new final_skin;
                    JSON_GetInt(JSONObject, "r", final_skin);

                    HandleGuiRegisterSkinFinalize(playerid, final_skin);
                }
                case 6:
                {
                    new password[33];
                    JSON_GetString(JSONObject, "s", password);

                    HandleGuiLogin(playerid, password);
                }
            }
        }
        case 13:
        {
            new action, id, sub_id;
            JSON_GetInt(JSONObject, "t", action);
            JSON_GetInt(JSONObject, "s", id);
            JSON_GetInt(JSONObject, "b", sub_id);

            if(action == 0 && id == NOTIFY_ENTER_BIZ)
            {
                new idx = g_mobile_notify_bizid[playerid];
                if((1 <= idx <= TOTALBIZZ) && BizzInfo[idx][bType] != 2 && BizzInfo[idx][bType] != 7 && PlayerToPoint(2.0, playerid, BizzInfo[idx][bEntrx], BizzInfo[idx][bEntry], BizzInfo[idx][bEntrz]))
                {
                    new enter_str[50], owner_str[32], status_str[16];
                    if(BizzInfo[idx][bEnter] == 0) format(enter_str, sizeof enter_str, "Бесплатно");
                    else format(enter_str, sizeof enter_str, "%d рублей", BizzInfo[idx][bEnter]);

                    if(!strcmp(BizzInfo[idx][bOwner], "None", true)) format(owner_str, sizeof owner_str, "Отсутствует");
                    else format(owner_str, sizeof owner_str, "%s", BizzInfo[idx][bOwner]);

                    if(BizzInfo[idx][bLock] == 0) format(status_str, sizeof status_str, "Открыто");
                    else format(status_str, sizeof status_str, "Закрыто");

                    PlayerBizzSelect[playerid] = idx;
                    global_string = "";
                    format(global_string, 320, ""cWH"Бизнес:\t"cMain"%s (#%d)\n"cWH"Владелец:\t"cMain"%s\n"cWH"Статус:\t"cMain"%s\n\n"cWH"Вы действительно хотите войти в данный бизнес?\n"cWH"Стоимость входа:\t"cMain"%s", BizzInfo[idx][bName], idx, owner_str, status_str, enter_str);
                    ShowPlayerDialog(playerid, 106+9, DIALOG_STYLE_MSGBOX, "{FF4D4D}KING RUSSIA {FFFFFF}| Бизнес", global_string, "Далее", "Закрыть");
                }
            }
            else if(action == 0 && id == NOTIFY_EXIT_BIZ)
            {
                new idx = g_mobile_notify_bizid[playerid];
                if((1 <= idx <= TOTALBIZZ)
                && PlayerToPoint(1.2, playerid, BizzInfo[idx][bExitx], BizzInfo[idx][bExity], BizzInfo[idx][bExitz])
                && GetPlayerVirtualWorld(playerid) == BizzInfo[idx][bVirtual])
                {
                    if(playerHookID[playerid] != -1)
                    {
                        for(new slot; slot < 4; slot++)
                        {
                            new biz = idx, hook = playerHookID[playerid];
                            if(HookTableArendators[biz][hook][slot] == playerid)
                            {
                                HookTableArendators[biz][hook][slot] = INVALID_PLAYER_ID;
                                if(HookTableArendator[biz][hook] == playerid) HookTableArendator[biz][hook] = INVALID_PLAYER_ID;
                                if(GetHookArendators(biz, hook) == 0)
                                {
                                    ClearHookPos(biz, hook);
                                    SetHookLabel(biz);
                                }
                                playerHookID[playerid] = -1;
                                break;
                            }
                        }
                    }
                    if(BizzInfo[idx][bType] == 3) playerHookID[playerid] = -1;
                    PI[playerid][pInBiz] = -1;
                    SetPlayerPos(playerid, BizzInfo[idx][bEntrx], BizzInfo[idx][bEntry], BizzInfo[idx][bEntrz]);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                    SetCameraBehindPlayer(playerid);
                }
            }
        }
    }

    JSON_Cleanup(JSONObject);
    JSON_Cleanup(json);
    JSON_Cleanup(json_packet_data);

    if(response) JSON_Cleanup(response);

    data[0] = EOS;
    outcoming_data[0] = EOS;

    return 1;
}



























