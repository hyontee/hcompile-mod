
// --- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
#define ENTER_ENGINE	2
#define ENTER_CONT      3
#define OFFER_YES       4
#define OFFER_ENGINE 	5
#define OFFER_UNLOCK_CAR 8 // ID для открытия дверей
#define EXIT_HOME 6
#define GUI_LOCK 7
#define FRACTION_DOOR 9
#include "../include/json.inc"

new const VinylNames[][] = {
    "remapbody8", "remapbody5", "remapbody32", "remapbody40", "remapbody21", "remapbody29",
    "remapbody41", "remapbody6", "remapbody31", "remapbody19", "remapbody28", "remapbody30",
    "remapbody11", "remapbody12", "remapbody15", "remapbody26", "remapbody16", "remapbody13",
    "remapbody18", "remapbody35", "remapbody10", "remapbody17", "remapbody38", "remapbody2",
    "remapbody23", "remapbody36", "remapbody4", "remapbody14", "remapbody37", "remapbody20",
    "remapbody7", "remapbody25", "remapbody39", "remapbody1", "remapbody33", "remapbody9",
    "remapbody22", "remapbody24", "remapbody34", "remapbody42", "remapbody47", "remapbody48",
    "remapbody43", "remapbody44", "remapbody49", "remapbody51", "remapbody45", "remapbody46",
    "remaphbody1", "remaphbody2", "remaphbody3", "remaphbody4", "remaphbody5", "remaphbody6",
    "remaphbody7", "remaphbody8", "remaphbody9", "remaphbody10", "remaphbody11", "remapnbody1",
    "remapnbody2", "remapnbody3", "remapnbody4", "remapnbody5", "remapnbody6", "remapnbody7",
    "remapnbody8", "remapnbody9", "remapnbody10", "remapnbody11", "remapnbody12", "remapnbody13",
    "remapnbody14", "remapnbody15", "remapnbody16", "remapnbody17", "remapmbody1", "remapmbody2",
    "remapmbody3", "remapmbody4", "remapmbody5", "remapmbody6", "remapmbody7", "remapmbody8",
    "remapmbody9", "remapmbody10", "remapmbody11", "remapmbody12", "remapmbody13", "remapmbody14",
    "remapmbody15", "remapmbody16", "remapmbody17", "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "remapnbody18", "remapnbody19", "remapnbody20", "remapnbody21",
    "remapnbody22", "remapnbody23", "remapnbody24", "remapnbody25", "remapnbody26", "remapnbody27"
};
//------------------------------------------------------------
IPacket:252(playerid, BitStream:bitstream)
{
        new data[512];
    new outcoming_data[512];
    new Node:json = JSON_Object();
    new Node:json_packet_data = JSON_Object();
    new Node:response = 0; // 0 == not created
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
	        case 33:
        {
            new type, test_pos;
            JSON_GetInt(JSONObject, "t", type);
            JSON_GetInt(JSONObject, "i", test_pos);

            new Node:response = JSON_Object();
            new item_id = 0, pos = 0, old_pos = 0, new_w = 13;
            if(type == 0)
            {
                new count = 0;
                new nt[32];
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", count);
                JSON_GetString(JSONObject, "nt", nt, sizeof(nt));
                JSON_SetInt(JSONObject, "t", 0);
                JSON_SetInt(JSONObject, "s", 1);
                OnPacketIncoming(playerid, 33, JSONObject);
            }
            else if(type == 1)
            {
                new count = 0;
                new nt[32];
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", count);
                JSON_GetString(JSONObject, "nt", nt, sizeof(nt));
                JSON_SetInt(JSONObject, "t", 1);
                JSON_SetInt(JSONObject, "s", 1);
                OnPacketIncoming(playerid, 33, JSONObject);
            }
            else if(type == 4)
            {
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "os", old_pos);
                JSON_GetInt(JSONObject, "s", pos);
                if(item_id == 134 && old_pos == 6)
                {
                    JSON_SetInt(JSONObject, "t", 4);
                    JSON_SetInt(JSONObject, "s", 0);
                }
                else
                {
                    JSON_SetInt(JSONObject, "t", 4);
                    JSON_SetInt(JSONObject, "s", 1);
                    JSON_SetInt(JSONObject, "nw", 50);
                    JSON_SetInt(JSONObject, "ns", 20);

                }
                OnPacketIncoming(playerid, 33, JSONObject);
            }
            else if(type == 5)
            {
                new count = 0;
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", pos);
                JSON_GetInt(JSONObject, "i", count);
                JSON_SetInt(JSONObject, "t", 5);
                JSON_SetInt(JSONObject, "s", 1);
                JSON_SetInt(JSONObject, "w", new_w);
                OnPacketIncoming(playerid, 33, JSONObject);
            }
            else if(type == 18)
            {
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", pos);
                new count;
                JSON_GetInt(JSONObject, "i", count);
                if(pos >= 0 && pos < MAX_INV_SLOTS && PlayerInventory[playerid][pos][invItem] == item_id)
                {
                    new query[144];
                    if(PlayerInventory[playerid][pos][invCount] == 1)
                    {
                        new dbid = PlayerInventory[playerid][pos][invID];
                        PlayerInventory[playerid][pos][invID] = 0;
                        PlayerInventory[playerid][pos][invItem] = 0;
                        PlayerInventory[playerid][pos][invCount] = 0;
                        PlayerInventory[playerid][pos][invValue] = 0;
                        mysql_format(mysql, query, sizeof(query), "DELETE FROM `inventory` WHERE `id` = %d", dbid);
                        mysql_tquery(mysql, query);
                        OnPacketIncoming(playerid, 33, JSONObject);
                    }
                    if(PlayerInventory[playerid][pos][invCount] > 1)
                    {
                        PlayerInventory[playerid][pos][invCount] = PlayerInventory[playerid][pos][invCount] - 1;
                        JSON_SetInt(JSONObject, "i", PlayerInventory[playerid][pos][invCount]);
                        mysql_format(mysql, query, sizeof(query), "UPDATE `inventory` SET `count` = %d WHERE `id` = %d", PlayerInventory[playerid][pos][invCount], PlayerInventory[playerid][pos][invID]);
                        mysql_tquery(mysql, query);
                        OnPacketIncoming(playerid, 33, JSONObject);
                    }
                    JSON_SetInt(JSONObject, "t", 18);
                    JSON_SetInt(JSONObject, "s", 1);
                }
                else
                {
                    JSON_SetInt(JSONObject, "t", 18);
                    JSON_SetInt(JSONObject, "s", 0);
                }
            }
            else if(type == 19)
            {
                new query[240];
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", pos);
                if(PlayerInventory[playerid][pos][invItem] != item_id) return ShowNotificationLonexs(playerid, 2, 4, 0, 0, "Так нельзя.", "");
                new Float:health;
                GetPlayerHealth(playerid, health);
                if(PlayerInventory[playerid][pos][invCount] > 1)
                {
                    PlayerInventory[playerid][pos][invCount] = PlayerInventory[playerid][pos][invCount] - 1;
                    JSON_SetInt(JSONObject, "i", PlayerInventory[playerid][pos][invCount]);
                    mysql_format(mysql, query, sizeof(query), "UPDATE `inventory` SET `count` = %d WHERE `id` = %d", PlayerInventory[playerid][pos][invCount], PlayerInventory[playerid][pos][invID]);
                    mysql_tquery(mysql, query);
                    OnPacketIncoming(playerid, 33, JSONObject);
                }
                if(item_id == 22) // фулл аптечка
                {
                    if(health >= 90.0) return ShowNotificationLonexs(playerid, 2, 3, 0, 0, "Вы не нуждаетесь в лечении.", "");
                    if(PlayerInventory[playerid][pos][invCount] == 1)
                    {
                        PlayerInventory[playerid][pos][invID] = 0;
                        PlayerInventory[playerid][pos][invItem] = 0;
                        PlayerInventory[playerid][pos][invCount] = 0;
                        PlayerInventory[playerid][pos][invValue] = 0;
                        mysql_format(mysql, query, sizeof(query), "DELETE FROM `inventory` WHERE `id` = %d", PlayerInventory[playerid][pos][invID]);
                        mysql_tquery(mysql, query);
                        OnPacketIncoming(playerid, 33, JSONObject);
                    }
					callcmd::healme(playerid, "");
                }
                else if(item_id == 134)
                {
                    if(pos >= 0 && pos < MAX_INV_SLOTS && PlayerInventory[playerid][pos][invItem] == 134)
                    {
                        new old_skin = g_player[playerid][P_SKIN]; //?? ???? ???? ????? ???? ?????
                        new new_skin = PlayerInventory[playerid][pos][invValue];
                        SetPlayerSkin(playerid, new_skin);
                        SetPlayerData(playerid, P_SKIN, new_skin);
                        if(GetPlayerSex(playerid) == 0) Action(playerid, "переоделся");
                        if(GetPlayerSex(playerid) == 1) Action(playerid, "переоделась");
                        ShowNotificationLonexs(playerid, 3, 6, 0, 0, "Вы успешно надели скин.", "");
                        PlayerInventory[playerid][pos][invValue] = old_skin;
                        mysql_format(mysql, query, sizeof(query), "UPDATE `inventory` SET `value` = %d WHERE `id` = %d", old_skin, PlayerInventory[playerid][pos][invID]);
                        mysql_tquery(mysql, query);
                        mysql_format(mysql, query, sizeof(query), "UPDATE `accounts` SET `skin` = %d WHERE `id` = %d", new_skin, GetPlayerAccountID(playerid));
                        mysql_tquery(mysql, query);

                        JSON_SetInt(JSONObject, "t", 19);
                        JSON_SetInt(JSONObject, "s", 1);
                        JSON_SetInt(JSONObject, "i", 6);
                        OnPacketIncoming(playerid, 33, JSONObject);
                    }
                    else
                    {
                        JSON_SetInt(JSONObject, "t", 19);
                        JSON_SetInt(JSONObject, "s", 0);
                        OnPacketIncoming(playerid, 33, JSONObject);
					}
				}
			else if(item_id == 1 || item_id == 490)  // ??????????
			{
			    new db_id = PlayerInventory[playerid][pos][invID];
			    new in_use = PlayerInventory[playerid][pos][invInUse];

			    if(in_use == 1)
			    {
			        // ??????? ?????????
			        for(new s = 0; s < MAX_PLAYER_ATTACHED_OBJECTS; s++)
			        {
			            if(IsPlayerAttachedObjectSlotUsed(playerid, s))
			            {
			                RemovePlayerAttachedObject(playerid, s);
			                break;
			            }
			        }

			        new query[256];
			        mysql_format(mysql, query, sizeof(query),
			            "UPDATE `inventory` SET `in_use` = 0 WHERE `id` = %d", db_id);
			        mysql_tquery(mysql, query);

			        PlayerInventory[playerid][pos][invInUse] = 0;
			        ShowNotificationLonexs(playerid, 3, 6, 0, 0, "Вы успешно сняли аксессуар.", "");

			        JSON_SetInt(response, "t", 19);
			        JSON_SetInt(response, "s", 1);
			        OnPacketIncoming(playerid, 33, JSONObject);
			    }
			    else
			    {
			        // ????????? ?????? ??????????
			        EditingAccNewInvID[playerid] = PlayerInventory[playerid][pos][invID];
			        EditingAccNewSlot[playerid] = pos;
			        EditingAccNewModel[playerid] = PlayerInventory[playerid][pos][invValue];
			        EditingAccNewBone[playerid] = PlayerInventory[playerid][pos][invBone];
			        EditingAccNewPosX[playerid] = PlayerInventory[playerid][pos][invPosX];
			        EditingAccNewPosY[playerid] = PlayerInventory[playerid][pos][invPosY];
			        EditingAccNewPosZ[playerid] = PlayerInventory[playerid][pos][invPosZ];
			        EditingAccNewRotX[playerid] = PlayerInventory[playerid][pos][invRotX];
			        EditingAccNewRotY[playerid] = PlayerInventory[playerid][pos][invRotY];
			        EditingAccNewRotZ[playerid] = PlayerInventory[playerid][pos][invRotZ];
			        EditingAccNewScaleX[playerid] = PlayerInventory[playerid][pos][invScaleX];
			        EditingAccNewScaleY[playerid] = PlayerInventory[playerid][pos][invScaleY];
			        EditingAccNewScaleZ[playerid] = PlayerInventory[playerid][pos][invScaleZ];

			        // ?????? ????? ??????????
			        Dialog(playerid, 1350, DIALOG_STYLE_MSGBOX,
			            "{FAD201}Кастомизация аксессуара",
			            "Желаете ли Вы изменить расположение аксессуара?",
			            "Да", "Нет");

			        JSON_SetInt(JSONObject, "t", 19);
			        JSON_SetInt(JSONObject, "s", 1);
			    }
			}
                else if(item_id == 23) // фулл аптечка
                {
                    if(PlayerInventory[playerid][pos][invCount] == 1)
                    {
                        PlayerInventory[playerid][pos][invID] = 0;
                        PlayerInventory[playerid][pos][invItem] = 0;
                        PlayerInventory[playerid][pos][invCount] = 0;
                        PlayerInventory[playerid][pos][invValue] = 0;
                        mysql_format(mysql, query, sizeof(query), "DELETE FROM `inventory` WHERE `id` = %d", PlayerInventory[playerid][pos][invID]);
                        mysql_tquery(mysql, query);
                    }
					callcmd::repaircar(playerid, "");
                }
                else if(item_id == 485 || item_id == 484 || item_id == 486 || item_id == 479 || item_id == 489) // фулл аптечка
                {
					ShowNotificationLonexs(playerid, 1, 6, 0, 0, "Используйте предмет у Капитана пирса!", "");
                }
                else if(item_id == 58)
                {
                    JSON_SetInt(JSONObject, "t", 19);
                    JSON_SetInt(JSONObject, "s", 1);
                }
                else
                {
                    JSON_SetInt(JSONObject, "t", 19);
                    JSON_SetInt(JSONObject, "s", 1);
                }
            }
            else if(type == 23)
            {
                new query[144];
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "os", old_pos);
                JSON_GetInt(JSONObject, "s", pos);
                new old_invID = PlayerInventory[playerid][old_pos][invID];
                new new_invID = PlayerInventory[playerid][pos][invID];
                if(new_invID != 0)
                {
                    mysql_format(mysql, query, sizeof(query), "DELETE FROM `inventory` WHERE `id` = %d", new_invID);
                    mysql_tquery(mysql, query);
               }
               PlayerInventory[playerid][pos][invItem] = PlayerInventory[playerid][old_pos][invItem];
               PlayerInventory[playerid][pos][invCount] = PlayerInventory[playerid][old_pos][invCount];
               PlayerInventory[playerid][pos][invValue] = PlayerInventory[playerid][old_pos][invValue];

               PlayerInventory[playerid][old_pos][invItem] = 0;
               PlayerInventory[playerid][old_pos][invCount] = 0;
               PlayerInventory[playerid][old_pos][invValue] = 0;

               if(old_invID != 0)
               {
                   mysql_format(mysql, query, sizeof(query), "UPDATE `inventory` SET `slot` = %d WHERE `id` = %d", pos, old_invID);
                   mysql_tquery(mysql, query);
               }
               JSON_SetInt(JSONObject, "t", 23);
               JSON_SetInt(JSONObject, "s", 1);
               JSON_SetInt(JSONObject, "i", pos);
               OnPacketIncoming(playerid, 33, JSONObject);
            }
            else if(type == 24)
            {
                JSON_GetInt(JSONObject, "ga", item_id);
                JSON_GetInt(JSONObject, "s", pos);

                JSON_SetInt(JSONObject, "t", 24);
                JSON_SetInt(JSONObject, "s", 1);
                JSON_SetInt(JSONObject, "w", new_w);
                OnPacketIncoming(playerid, 33, JSONObject);

            }
            else
            {
                JSON_SetInt(JSONObject, "t", type);
                JSON_SetInt(JSONObject, "s", 0);
                OnPacketIncoming(playerid, 33, JSONObject);
            }

            if(type == 19 || type == 18 || type == 23 || type == 4)
            {
                if(type == 19 || type == 18)
                {
                    // JSON_SetInt(response, "w", new_w);
                }
            }
   			 JSON_Cleanup(JSONObject);
        }
case 74:
{
    new type;
    JSON_GetInt(JSONObject, "t", type);
    printf("[DEBUG] Case 74 | Player: %d | Type: %d", playerid, type);

    switch (type)
    {
        case 3:
        {
            JSON_SetInt(JSONObject, "c", 1);
            callcmd::cases(playerid, "");
        }
        case 1:
        {
            JSON_SetInt(JSONObject, "t", 1);
            SetPVarInt(playerid, "reward_offset", 0);

            new query[128];
            mysql_format(mysql, query, sizeof(query),
                "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT 0, 19",
                GetPlayerData(playerid, P_ACCOUNT_ID)
            );
            mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 2:
        {
            new offset = GetPVarInt(playerid, "reward_offset");
            offset += 100;
            SetPVarInt(playerid, "reward_offset", offset);

            new query[128];
            mysql_format(mysql, query, sizeof(query),
                "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT %d, 19",
                GetPlayerData(playerid, P_ACCOUNT_ID), offset
            );
            mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 4:
        {
            new reward_db_id, reward_action;
            JSON_GetInt(JSONObject, "id", reward_db_id);
            JSON_GetInt(JSONObject, "s", reward_action);
            if(reward_action != 1 && reward_action != 3) reward_action = 1;

            new query[128];
            mysql_format(mysql, query, sizeof(query),
                "SELECT `award_id`, `case_id` FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1",
                reward_db_id, GetPlayerData(playerid, P_ACCOUNT_ID)
            );
            mysql_tquery(mysql, query, "OnRewardDebug", "iii", playerid, reward_db_id, reward_action);
        }
        default:
        {
            printf("[DEBUG] Unknown Type %d in Case 74 for Player %d", type, playerid);
        }
    }
    OnPacketIncoming(playerid, 74, JSONObject);
}

case 73:
{
    new type;
    JSON_GetInt(JSONObject, "t", type);

    switch (type)
    {
        case 3:
        {
            JSON_SetInt(JSONObject, "t", 3);
            JSON_SetInt(JSONObject, "s", 1);

            new cs_val = GetPVarInt(playerid, "case_open_cs");
            if(cs_val <= 0) JSON_GetInt(JSONObject, "cs", cs_val);

            if(JSON_GetType(JSONObject, "bt1") == JSON_NODE_ARRAY)
            {
                new Node:bt1_array, bt1_len;
                JSON_GetArray(JSONObject, "bt1", bt1_array);
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
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO rewards (uid, award_id, case_id) VALUES (%d, %d, %d)",
        GetPlayerData(playerid, P_ACCOUNT_ID), reward_ui_id - 1, cs_val
    );
    mysql_tquery(mysql, query, "", "");
}
                }

                printf("%s", log_msg);
                JSON_SetArray(JSONObject, "bt1", bt1_array);
            }

            if(JSON_GetType(JSONObject, "bt2") == JSON_NODE_ARRAY)
            {
                new Node:bt2_array, bt2_len;
                JSON_GetArray(JSONObject, "bt2", bt2_array);
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
                JSON_SetArray(JSONObject, "bt2", bt2_array);
            }

            if(GetPVarInt(playerid, "case_open_total") <= 0)
            {
                ResetOpenedCaseRewards(playerid);
            }

            JSON_SetInt(JSONObject, "pc", GetPlayerDustValue(playerid));
          //  JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 1:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(JSONObject, "t", 1);
            JSON_SetInt(JSONObject, "s", 1);
            JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
            JSON_SetInt(JSONObject, "pc", GetPlayerDustValue(playerid));
        //    JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));

            OnPacketIncoming(playerid, 73, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 6:
        {
            callcmd::reward(playerid, "");
        }
        case 2:
{
    new type_val = 1, cs_val = -1;
    JSON_GetInt(JSONObject, "type", type_val);
    JSON_GetInt(JSONObject, "cs", cs_val);

    SetPVarInt(playerid, "case_open_cs", cs_val);
    ResetOpenedCaseRewards(playerid);

    new Node:JSONObject = JSON_Object();
    JSON_SetInt(JSONObject, "t", 2);
    JSON_SetInt(JSONObject, "s", 1);

    new open_count = (type_val == 2) ? 10 : 1;
    new price = 0;

    switch(cs_val)
    {
        case 1: price = 0;
        case 2: price = (open_count == 10) ? 1000 : 100;
        case 3: price = (open_count == 10) ? 7000 : 700;
        case 4: price = (open_count == 10) ? 12000 : 1200;
        case 5: price = (open_count == 10) ? 100000 : 10000;
        case 6: price = (open_count == 10) ? 8550 : 900;
        case 7: price = (open_count == 10) ? 8550 : 900;
        case 8: price = (open_count == 10) ? 8550 : 900;
        case 9: price = (open_count == 10) ? 8550 : 900;
        case 10: price = (open_count == 10) ? 8550 : 900;
        case 11: price = (open_count == 10) ? 8550 : 900;
        default:
        {
            JSON_SetInt(JSONObject, "s", 0);
            JSON_SetArray(JSONObject, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, JSONObject);
            JSON_Cleanup(JSONObject);
            return 1;
        }
    }

    if(cs_val < 1 || cs_val > 11) return 1;

    new have_cases = GetPlayerCaseCountByType(playerid, cs_val);
    new bool:use_bc = false;

    if(have_cases < open_count)
    {
        if(GetPlayerDonateRub(playerid) < price)
        {
            JSON_SetInt(JSONObject, "s", 0);
            JSON_SetArray(JSONObject, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, JSONObject);
            JSON_Cleanup(JSONObject);
            ShowNotificationCases(playerid, 2, 4, 1, 1, "   Black Coin!", "");
            return 1;
        }
        use_bc = true;
    }

    if(use_bc)
    {
        if(price > 0) GivePlayerDonateRub(playerid, -price);
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
            JSON_SetArray(JSONObject, "pr", JSON_Array(JSON_Int(randOne + 1)));
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
            JSON_SetArray(JSONObject, "pr", prArray);
        }
    }
    else
    {
        JSON_SetInt(JSONObject, "s", 0);
    }

    JSON_SetInt(JSONObject, "bc", GetPlayerDonateRub(playerid));
    JSON_SetArray(JSONObject, "cc", BuildPlayerCasesArray(playerid));
    OnPacketIncoming(playerid, 73, JSONObject);
    JSON_Cleanup(JSONObject);
}
        default:
        {
            printf("[DEBUG] Unknown Type %d in Case 73 for Player %d", type, playerid);
        }
    }
}
            case 27:
    	{
			new vehid = GetFreeOwnableCarID(playerid);
			new vehicleid = GetPlayerVehicleID(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

	        new type;
	        JSON_GetInt(JSONObject, "t", type);
	        switch(type)
	        {
	        	//case 0: //????????
       			case 1: callcmd::park(playerid);
			    case 2:
			    {
			     	callcmd::key(playerid);
			     	if(GetOwnableCarData(index, OC_KEY_IN)) 	JSON_SetInt(JSONObject, "s", 1);
					else 										JSON_SetInt(JSONObject, "s", 0);


			    }
			    case 3:
			    {
			     	callcmd::lock(playerid);
			     	OnPacketIncoming(playerid, 27, JSONObject);
			     	if(GetVehicleParam(vehicleid, V_LOCK)) 	JSON_SetInt(JSONObject, "s", 1);
			     	else 									JSON_SetInt(JSONObject, "s", 0);
			    }
			    case 5:
			    {
			    		JSON_SetInt(JSONObject, "s", 1);
					    JSON_SetInt(JSONObject, "t", 1);
			    }
			    case 6:
			    {
			     	callcmd::e(playerid);

			     	if(GetVehicleParam(vehicleid, V_ENGINE)) 	JSON_SetInt(JSONObject, "s", 1);
			     	else 										JSON_SetInt(JSONObject, "s", 0);
					OnPacketIncoming(playerid, 27, JSONObject);

					if(!GetVehicleParam(vehicleid, V_ENGINE))
					{
						JSON_SetInt(JSONObject, "s", 0);

						JSON_SetInt(JSONObject, "t", 12);
						OnPacketIncoming(playerid, 27, JSONObject);

						JSON_SetInt(JSONObject, "t", 13);
						OnPacketIncoming(playerid, 27, JSONObject);


						JSON_SetInt(JSONObject, "t", 15);
     				}
			 	}
			    case 8: //?????
			    {
			     	
			    }
			    case 9: //???????
			    {
			     	
			    }
			    case 10: //?????
			    {
			     	
			    }
			    case 11: //?????+
			    {
			     	
			    }
			    case 12:
			    {
				/*		printf("[DEBUG] Neon check: %d, %d, %d", g_ownable_car[vehid][OC_NEON_1], g_ownable_car[vehid][OC_NEON_2], g_ownable_car[vehid][OC_NEON_3]);
					if(g_ownable_car[vehid][OC_NEON_1] == 1 || g_ownable_car[vehid][OC_NEON_2] == 1 || g_ownable_car[vehid][OC_NEON_3] == 1)
					{
						if(GetVehicleParam(vehicleid, V_ENGINE))
						{
						    if(!g_ownable_car[vehid][OC_ENABLE_NEON])
							{
							      g_ownable_car[vehid][OC_ENABLE_NEON] = true;
						 		SetVehicleLightingColor(vehicleid, vInfo[vehid][vNeon][0], vInfo[vehid][vNeon][1], vInfo[vehid][vNeon][2]);
								JSON_SetInt(json, "s", 1);
							}
							else
							{
							     g_ownable_car[vehid][OC_ENABLE_NEON] = false;
						 		SetVehicleLightingColor(vehicleid, 0x00000000, 0x00000000, 0x00000000);
								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowClientNotification(playerid, 2, 3, 99, 0, "? ??? ?? ??????????? ?????????!", "");*/
			    }
			    case 13:
			    {
					/*if(g_ownable_car[vehicleid][OC_HIGH_LIGHTS])
					{
						if(GetVehicleParam(vehicleid, V_ENGINE))
						{
						    if(!g_ownable_car[vehicleid][OC_ENABLE_HIGH_LIGHTS])
							{
							    g_ownable_car[vehicleid][OC_ENABLE_HIGH_LIGHTS] = true;

								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);

								JSON_SetInt(json, "s", 1);
								OnPacketIncoming(playerid, 27, json);

								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    g_ownable_car[vehicleid][OC_ENABLE_HIGH_LIGHTS] = false;


								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowClientNotification(playerid, 2, 3, 99, 0, "? ???? ?? ?????????? ??????? ???? ???.", "");*/
			    }
			    case 14:
			    {
			     	callcmd::l(playerid);
			     	if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(JSONObject, "s", 1);
			     	else
				 	{
					 	JSON_SetInt(JSONObject, "s", 0);
						OnPacketIncoming(playerid, 27, JSONObject);

						JSON_SetInt(JSONObject, "t", 13);
						OnPacketIncoming(playerid, 27, JSONObject);

						JSON_SetInt(JSONObject, "t", 14);
						OnPacketIncoming(playerid, 27, JSONObject);

						JSON_SetInt(JSONObject, "t", 15);
					}
			    }
			    case 15:
				{
					/*if(g_ownable_car[vehicleid][OC_STROB])
					{
						if(GetVehicleParam(vehicleid, V_ENGINE))
						{
						    if(!g_ownable_car[vehicleid][OC_ENABLE_STROB])
							{
							    g_ownable_car[vehicleid][OC_ENABLE_STROB] = true;
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);
				     			SetVehicleStroboscope(vehicleid, vInfo[vehicleid][vStrob]-1);



								JSON_SetInt(json, "s", 1);
								OnPacketIncoming(playerid, 27, json);

								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    g_ownable_car[vehicleid][OC_ENABLE_STROB] = false;
				     			SetVehicleStroboscope(vehicleid, 5);
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);

								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowClientNotification(playerid, 2, 3, 99, 0, "? ???? ?? ??????????? ???????????.", "");*/
			    }
			    case 16:
			    {
			    }
			    case 17:
			    {
			    }
			    case 18:
			    {
			    }
			    case 19:
			    {

					/*if(g_ownable_car[vehicleid][OC_HUDRAUILS])
					{
					    if(!g_ownable_car[vehicleid][OC_ENABLE_HUDRAILS])
						{
						    g_ownable_car[vehicleid][OC_ENABLE_HUDRAILS] = true;

							SetVehicleHydraulics(vehicleid, 1);
							JSON_SetInt(json, "s", 1);
						}
				 		else
				 		{
				 		    g_ownable_car[vehicleid][OC_ENABLE_HUDRAILS] = false;

							SetVehicleHydraulics(vehicleid, 0);
							JSON_SetInt(json, "s", 0);
				 		}
					}
					else ShowClientNotification(playerid, 2, 3, 99, 0, "? ??? ?? ??????????? ??????????!", "");*/
			    }
	        }
			OnPacketIncoming(playerid, 27, JSONObject);
        }
case 66:
{
    new buttonId, screenType, closeFlag;

    JSON_GetInt(JSONObject, "b", buttonId);
    JSON_GetInt(JSONObject, "t", screenType);
    JSON_GetInt(JSONObject, "c", closeFlag);

    // ???????? GUI
    if(closeFlag == 1)
    {
        StopSpectate(playerid);
        ExitSpectate(playerid);
        return 1;
    }

    switch(buttonId)
    {
        case 1:
        {
                        RefreshSpectate(playerid);
        }

        case 2:
        {
        	SpectateNextPlayerLeft(playerid);
        }

        case 3: // KICK
        {
           ShowPlayerDialog(playerid, 2006, DIALOG_STYLE_INPUT,
	                "{FF0000}"SERVER_NAME"{FFFFFF} | Выдача кика",
	                "Введите причину кика:",
	                "Продолжить", "Закрыть");
        }

        case 4: // MUTE
        {
            ShowPlayerDialog(playerid, 2004, DIALOG_STYLE_INPUT,
	                "{FF0000}"SERVER_NAME"{FFFFFF} | Выдача мута",
	                "Введите причину мута:",
	                "Продолжить", "Закрыть");
        }

        case 5: // JAIL
        {
 					ShowPlayerDialog(playerid, 2002, DIALOG_STYLE_INPUT,
	                "{FF0000}"SERVER_NAME"{FFFFFF} | Выдача деморгана",
	                "Введите причину:",
	                "Продолжить", "Закрыть");
        }

        case 6: // WARN
        {
            ShowPlayerDialog(playerid, 2007, DIALOG_STYLE_INPUT,
	                "{FF0000}"SERVER_NAME"{FFFFFF} | Выдача варна",
	                "Введите причину варна:",
	                "Продолжить", "Закрыть");
        }
		case 7:
		{
		ShowPlayerDialog(playerid, 2008, DIALOG_STYLE_LIST,
	                "{FF0000}"SERVER_NAME"{FFFFFF} | Выдача варна",
                	 "Подбросить вверх\nПодбросить вверх",
	                "Продолжить", "Закрыть");
		}
		case 8: // ?????? ???
		{
			ShowPlayerDialog(playerid, 2000, DIALOG_STYLE_INPUT,"{FF0000}"SERVER_NAME"{FFFFFF} | Блокировка аккаунта","Введите причину блокировки:","Продолжить", "Закрыть");
		}
        case 9:
        {
            SpectateNextPlayerRight(playerid);
        }

        case 10:
        {
            SendClientMessage(playerid, -1, "кнопка статистики без действия");
        }

        case 11:
        {
            callcmd::af(playerid);
        }

        default:
        {
            new str[64];
            format(str, sizeof(str), "error speck GUI!!!", buttonId);
            SendClientMessage(playerid, -1, str);
        }
    }

    return 1;
}
        case 14:
        {
            new t, i;

            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "i", i);

            switch(t)
            {
                case 0:
                {
                    callcmd::gps(playerid, "");
                }

                case 1:
                {
                    ShowNotificationLonexs(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 2:
                {
                    callcmd::mm(playerid, "");
                }

                case 3:
                {
                    //SendClientMessage(playerid, 0xFFFFFFFF, "communication");
                }

                case 4:
                {
                    callcmd::inv(playerid, "");
                }

                case 5:
                {
                    callcmd::anim(playerid, "");
                }

                case 6:
                {
                    callcmd::donate(playerid, "");
                }

                case 7:
                {
                    callcmd::car(playerid, "");
                }

                case 8:
                {
                    callcmd::promo(playerid, "");
                }

                case 9:
                {
                    callcmd::report(playerid, "");
                }

                case 10:
                {
                    ShowNotificationLonexs(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 11:
                {
                    ShowNotificationLonexs(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 12:
                {
                    ShowNotificationLonexs(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }
            }

            new Node:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);

            new outcoming_data[256];
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 14, json_packet_data);

            JSON_Cleanup(json_packet_data);
        }
        case 3:
        {
            new type, playerMoney, orderMask;
            new totalPrice = 0;
            new plusgolod = 0;
            new itemsPurchased[6];

            JSON_GetInt(JSONObject, "t", type);
            JSON_GetInt(JSONObject, "m", playerMoney);

            if(type == 0)
            {
                return 1;
            }
            else if(type == 1)
            {
                JSON_GetInt(JSONObject, "r", orderMask);

                for(new i = 0; i < 6; i++)
                {
                    if(orderMask & (1 << i))
                    {
                        switch(i + 1)
                        {
                            case 1:
                            {
                                totalPrice += 120;
                                plusgolod += 5;
                                itemsPurchased[i] = 1;
                            }
                            case 2:
                            {
                                totalPrice += 230;
                                plusgolod += 10;
                                itemsPurchased[i] = 1;
                            }
                            case 3:
                            {
                                totalPrice += 320;
                                plusgolod += 15;
                                itemsPurchased[i] = 1;
                            }
                            case 4:
                            {
                                totalPrice += 580;
                                plusgolod += 20;
                                itemsPurchased[i] = 1;
                            }
                            case 5:
                            {
                                totalPrice += 80;
                                plusgolod += 3;
                                itemsPurchased[i] = 1;
                            }
                            case 6:
                            {
                                totalPrice += 30;
                                plusgolod += 2;
                                itemsPurchased[i] = 1;
                            }
                        }
                    }
                }
            }

            if(g_player[playerid][P_GOLOD] >= 100) return ShowNotificationLonexs(playerid, 2, 4, 0, 0, "сасеш", "");

            if(GetPlayerMoney(playerid) >= totalPrice)
            {
                GivePlayerMoneyEx(playerid, -totalPrice);

                for(new i = 0; i < 6; i++)
                {
                    if(itemsPurchased[i])
                    {
                        switch(i + 1)
                        {
                            case 1:
                            {
                                g_player[playerid][P_GOLOD] += 5;
                            }
                            case 2:
                            {
                                g_player[playerid][P_GOLOD] += 10;
                            }
                            case 3:
                            {
                                g_player[playerid][P_GOLOD] += 15;
                            }
                            case 4:
                            {
                                g_player[playerid][P_GOLOD] += 20;
                            }
                            case 5:
                            {
                                g_player[playerid][P_GOLOD] += 3;
                            }
                            case 6:
                            {
                                g_player[playerid][P_GOLOD] += 2;
                            }
                        }
                    }
                }

                new message[128];
                format(message, sizeof(message), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ {FFFF00}%d {FFFFFF}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ {FFFF00}%d {FFFFFF}пїЅпїЅпїЅпїЅпїЅпїЅ.", totalPrice, plusgolod);
               // SendClientMessage(playerid, -1, message);
            }
            else
            {
                // ShowNotificationLonexs(playerid, 2, 5, 1, 1, "сасеш тест пїЅпїЅпїЅпїЅпїЅпїЅпїЅ.", "");
            }

            new Node:json_packet_data = JSON_Object();
            JSON_Stringify(json_packet_data, json_data);
            OnPacketIncoming(playerid, 3, json_packet_data);
            JSON_Cleanup(json_packet_data);
        }
        case 45:
        {
            new type;
            JSON_GetInt(json, "t", type);

            switch(type)
            {
                case 4:
                {
                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", 4);
                    JSON_SetInt(response, "s", 3);
                    JSON_SetInt(response, "g", 1);

                    OnPacketIncoming(playerid, 45, response);
                    JSON_Cleanup(response);
                }
                case 5:
{
    // РРіРЅРѕСЂРёСЂСѓРµРј status РёР· РІС…РѕРґСЏС‰РµРіРѕ json, РІСЃРµРіРґР° РѕС‚РїСЂР°РІР»СЏРµРј РґР°РЅРЅС‹Рµ РґР»СЏ main Р±Р»РѕРєР° (РєР°Рє РІ Java: t=5, id=0 РґР»СЏ С‚СЂРёРіРіРµСЂР° main)
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 5);
    JSON_SetInt(response, "s", 3);    // skin
    JSON_SetInt(response, "g", 1);
   // JSON_SetInt(response, "id", 0);  // id=0, С‡С‚РѕР±С‹ РїСЂРѕР№С‚Рё if(optInt9 !=4 && !=5) Рё РїРѕРїР°СЃС‚СЊ РІ main Р±Р»РѕРє

    // repPeopleSkin: mutableListOf(r, p, s) - rep, people, skin
//    JSON_SetInt(response, "r", 150);   // rep
    JSON_SetInt(response, "p", 12);    // people (GUIManagerKt.APPMETRICA_DEVICE_ID_KEY -> "p")

    // otherState: РєРѕРЅРєР°С‚РµРЅР°С†РёСЏ 6 СЃРїРёСЃРєРѕРІ РїРѕ 2 int (cur/max)
    // "my": money [cur, max]
    new Node:myNode = JSON_Array(JSON_Int(10000), JSON_Int(50000));
    JSON_SetArray(response, "my", myNode);

    // "mk": masks [cur, max]
    new Node:mkNode = JSON_Array(JSON_Int(50), JSON_Int(100));
    JSON_SetArray(response, "mk", mkNode);

    // "kb": oils [cur, max]
    new Node:kbNode = JSON_Array(JSON_Int(30), JSON_Int(75));
    JSON_SetArray(response, "kb", kbNode);

    // "pn": ammo [cur, max]
    new Node:pnNode = JSON_Array(JSON_Int(300), JSON_Int(1000));
    JSON_SetArray(response, "pn", pnNode);

    // upgrades: "ug" [6] int (store[0-1], weapons[2-3], family[4-5])
    new Node:ugNode = JSON_Array(
        JSON_Int(5), JSON_Int(7),  // store cur/max
        JSON_Int(3), JSON_Int(7),   // weapons cur/max
        JSON_Int(2), JSON_Int(7)    // family cur/max
    );
    JSON_SetArray(response, "ug", ugNode);

    OnPacketIncoming(playerid, 45, response);

    // Cleanup РІСЃРµС… РЅРѕРґРѕРІ
    JSON_Cleanup(response);
    JSON_Cleanup(myNode);
    JSON_Cleanup(mkNode);
    JSON_Cleanup(kbNode);
    JSON_Cleanup(pnNode);
    JSON_Cleanup(ugNode);
}

                case 6:
                {
                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", 6);
                    JSON_SetInt(response, "s", 3);
                    JSON_SetInt(response, "g", 1);

                    OnPacketIncoming(playerid, 45, response);
                    JSON_Cleanup(response);
                }
                case 7:
                {
                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", 7);
                    JSON_SetInt(response, "s", 3);
                    JSON_SetInt(response, "g", 1);

                    OnPacketIncoming(playerid, 45, response);
                    JSON_Cleanup(response);
                }
            }
        }
                case 1:
    {
        new type, country;
        JSON_GetInt(json, "t", type);

        switch(type)
        {
            case 0:
            {
                new price, priceRefresh;
                if(!JSON_GetInt(json, "p", price) || !JSON_GetInt(json, "pr", priceRefresh))
                {
                    printf("[PLATES] GUI closed by player %d", playerid);
                }
                else
                {
                    printf("[PLATES] Received prices - New: %d, Change: %d", price, priceRefresh);
                }
            }
            case 1:
            {
                JSON_GetInt(json, "c", country);

                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 1);

                new safeMsg[128];
                format(safeMsg, sizeof(safeMsg), "Страна %d выбрана", country);
                JSON_SetString(response, "h", safeMsg);

                OnPacketIncoming(playerid, 1, response);
                ~response;
            }
            case 2:
            {
                 new Node:response = JSON_Object();
                JSON_GetInt(json, "c", country);



                if(country == 0)
                {
                new randomPlate0[32], randomReg0[8];
                format(randomPlate0, sizeof(randomPlate0), RandomNumberPlate(0));
                format(randomReg0, sizeof(randomReg0), RandomNumberRegion(0));
                JSON_SetString(response, "p", randomPlate0);
                JSON_SetString(response, "r", randomReg0);
                }
                if(country == 1)
                {
                new randomPlate1[32];
                format(randomPlate1, sizeof(randomPlate1), RandomNumberPlate(1));
                JSON_SetString(response, "p", randomPlate1);

                }
                if(country == 2)
                {
                new randomPlate2[32];
                format(randomPlate2, sizeof(randomPlate2), RandomNumberPlate(2));
                JSON_SetString(response, "p", randomPlate2);

                }
                if(country == 3)
                {
                new randomPlate3[32], randomReg3[8];
                format(randomPlate3, sizeof(randomPlate3), RandomNumberPlate(3));
                format(randomReg3, sizeof(randomReg3), RandomNumberRegion(3));
                JSON_SetString(response, "p", randomPlate3);
                JSON_SetString(response, "r", randomReg3);
                }

                JSON_SetInt(response, "t", 2);


                OnPacketIncoming(playerid, 1, response);
                ~response;
            }
            case 3:
            {
                JSON_GetInt(json, "c", country);

                new plate[32], reg[10];
                JSON_GetString(json, "p", plate, sizeof(plate));
                JSON_GetString(json, "r", reg, sizeof(reg));

                printf("Куплены номера: %s, регион: %s", plate, reg);

                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 3);

                new successMsg[128];
                format(successMsg, sizeof(successMsg), "Номера %s установлены", plate);
                JSON_SetString(response, "h", successMsg);

                OnPacketIncoming(playerid, 1, response);
                ~response;
            }
        }
    }
case 50:
        {
			new spawn_id;
            JSON_GetInt(JSONObject, "t", spawn_id);

            switch(spawn_id)
            {
                case 1:
                {
                    new spawn_random = random(4);
                    new skin = GetPlayerSkinEx(playerid);

		 		SetSpawnInfo(
					playerid,
					0,
					skin,
					spawn_pos_data[spawn_random][0],
					spawn_pos_data[spawn_random][1],
					spawn_pos_data[spawn_random][2],
					spawn_pos_data[spawn_random][3],
					0, 0, 0, 0, 0, 0
				);
				SpawnPlayer(playerid);

				SetPlayerPosEx(
					playerid,
					spawn_pos_data[spawn_random][0],
					spawn_pos_data[spawn_random][1],
					spawn_pos_data[spawn_random][2],
					spawn_pos_data[spawn_random][3],
					0, 0
				);
				            SpawnPlayer(playerid);
				}

                case 0:
                {
                    new team_id = GetPlayerTeamEx(playerid);

				SetPlayerPosEx
				(
					playerid,
					GetTeamData(team_id, O_SPAWN)[0],
					GetTeamData(team_id, O_SPAWN)[1],
					GetTeamData(team_id, O_SPAWN)[2],
					GetTeamData(team_id, O_SPAWN)[3],
					GetTeamData(team_id, O_SPAWN_INT),
					GetTeamData(team_id, O_SPAWN_VW)
				);
                }

                case 4:
                {
                    EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));

                    // EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
                }
            }

            JSON_SetInt(JSONObject, "c", 1);
            new outcoming_data[256];
            JSON_Stringify(JSONObject, outcoming_data);

            OnPacketIncoming(playerid, 50, JSONObject);

            JSON_Cleanup(JSONObject);
        }
case 28: // ??? ? ??? ????????? GUI
{
	new outcoming_data[512];

	new type, status, detal_id, color[16], color_type;

	JSON_GetInt(JSONObject, "t", type);
	JSON_GetInt(JSONObject, "d", detal_id);
	JSON_GetInt(JSONObject, "m", color_type);
	JSON_GetString(JSONObject, "d", color);
	JSON_GetInt(JSONObject, "p", detal_id);
	JSON_GetInt(JSONObject, "s", status);
	printf("[DEUG]  paclet 28. parameter 'p' (detal_id) = %d | Type = %d", detal_id, type);
	JSON_SetInt(JSONObject, "s", 0);
    switch (type)
    {
        case 0: // ?????
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);

            switch(g_TuningType[playerid])
            {
                case 0:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 2296.146240, -2613.668457, 21.829063);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.0);
                }
                case 1:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 1742.453979, 2465.383544, 14.454860);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
            }

            SetPlayerInterior(playerid, 0);
            g_TuningType[playerid] = 0;

            JSON_SetInt(JSONObject, "t", 0);
            JSON_SetInt(JSONObject, "s", 1);
        }
		case 12:
		{
			JSON_SetInt(JSONObject, "t", 12);
			JSON_SetInt(JSONObject, "s", 1);
			JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
		}
		case 3:
		   {
			    if(detal_id >= 0 && detal_id < sizeof(VinylNames))
                {
                    new price = 50;
                    new vehicleid = GetPlayerVehicleID(playerid);
                    GivePlayerMoneyEx(playerid, -price);
                    vInfo[vehicleid][vVinyl] = detal_id;
					
                    new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_vinyl=%s WHERE id=%d LIMIT 1",VinylNames[detal_id], sql_id);
				    mysql_tquery(mysql, query);

                    SetVehicleVinylForPlayer(playerid, vehicleid, detal_id);

                    JSON_SetInt(JSONObject, "t", 3);
                    JSON_SetInt(JSONObject, "s", 1);
                    JSON_SetInt(JSONObject, "p", detal_id);
                    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
                }
			}

			case 1:
			{
			    printf("[DEBUG] TechCenter: Type: %d, ColorType: %d, Color: %s", type, color_type, color);
			    new color_val, vehid = GetPlayerVehicleID(playerid);
			    sscanf(color, "h", color_val);

			            new query[128];
               if(color_type == 0)
			            {
			                new vehicleid = GetPlayerVehicleID(playerid);
			                new price = 50;

			                if(GetPlayerMoneyEx(playerid) >= price)
			                {
			                    GivePlayerMoneyEx(playerid, -price);
			                    vInfo[vehicleid][viColorBody] = color_val;
                       			new query[256];
							    new index = GetVehicleData(vehicleid, V_ACTION_ID);
							    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
							    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET color_1=%d WHERE id=%d LIMIT 1",color_val, sql_id);
							    mysql_tquery(mysql, query);

			                    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
			                    JSON_SetInt(JSONObject, "s", 1);
			                }
			                else
			                {
			                    JSON_SetInt(JSONObject, "s", 0);
			                }
			            }
              			 else if(color_type == 1)
			            {
			                new vehicleid = GetPlayerVehicleID(playerid);
			                new price = 50;

			                if(GetPlayerMoneyEx(playerid) >= price)
			                {
			                    GivePlayerMoneyEx(playerid, -price);
			                    vInfo[vehicleid][viColorWheels] = color_val;
			                    new query[256];
							    new index = GetVehicleData(vehicleid, V_ACTION_ID);
							    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
							    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET color_2=%d WHERE id=%d LIMIT 1",color_val, sql_id);
							    mysql_tquery(mysql, query);

			                    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
			                    JSON_SetInt(JSONObject, "s", 1);
			                }
			                else
			                {
			                    JSON_SetInt(JSONObject, "s", 0);
			                }
			            }
			            else if(color_type == 3 || color_type == 4)
			            {
			                new vehicleid = GetPlayerVehicleID(playerid);
			                new price = 50;
			                new query[256];
							new index = GetVehicleData(vehicleid, V_ACTION_ID);
							new sql_id = GetOwnableCarData(index, OC_SQL_ID);

			                if(GetPlayerMoneyEx(playerid) >= price)
			                {
			                    GivePlayerMoneyEx(playerid, -price);

			                   if(color_type == 3)
						        {
						            // Исправлено: отдельно присваиваем каждому полю
						            vInfo[vehicleid][viTonerFront] = color_val;
						            vInfo[vehicleid][viTonerFrontSide] = color_val;

						            // Исправлено: убран лишний символ ` в запросе
						            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_toner_front=%d, tuning_toner_front_side=%d WHERE id=%d LIMIT 1", color_val, color_val, sql_id);
						        }
						        else // color_type == 4
						        {
						            // Исправлено: отдельно присваиваем каждому полю
						            vInfo[vehicleid][viTonerRear] = color_val;
						            vInfo[vehicleid][viTonerRearSide] = color_val;

						            // Исправлено: убран лишний символ ` в запросе
						            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_toner_rear=%d, tuning_toner_rear_side=%d WHERE id=%d LIMIT 1", color_val, color_val, sql_id);
						        }
			                    mysql_tquery(mysql, query);
			                }
			            }

			            else if(color_type == 10)
			            {
			                new vehicleid = GetPlayerVehicleID(playerid);
			                new price = 50;

			                if(GetPlayerMoneyEx(playerid) >= price)
			                {
			                    GivePlayerMoneyEx(playerid, -price);
			                    vInfo[vehicleid][vLightColor] = color_val;
			                    new query[256];
							    new index = GetVehicleData(vehicleid, V_ACTION_ID);
							    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
							    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_light_color=%d WHERE id=%d LIMIT 1",color_val, sql_id);
							    mysql_tquery(mysql, query);

			                    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
			                    JSON_SetInt(JSONObject, "s", 1);
			                }
			                else
			                {
			                    JSON_SetInt(JSONObject, "s", 0);
			                }
			            }
			            else if(color_type == 11 || color_type == 12 || color_type == 13)
			            {
			                new vehicleid = GetPlayerVehicleID(playerid);
			                new price = 50;
                   			new query[256];
							new index = GetVehicleData(vehicleid, V_ACTION_ID);
							new sql_id = GetOwnableCarData(index, OC_SQL_ID);

			                if(GetPlayerMoneyEx(playerid) >= price)
			                {
			                    GivePlayerMoneyEx(playerid, -price);

			                    if(color_type == 11)
			                    {
			                        vInfo[vehicleid][vNeon1] = color_val;
			                        mysql_format(mysql, query, sizeof query, "UPDATE `ownable_cars` SET `tuning_neon1`=%d WHERE `id`=%d LIMIT 1", color_val, sql_id);
			                    }
			                    else if(color_type == 12)
			                    {
			                        vInfo[vehicleid][vNeon2] = color_val;
			                        mysql_format(mysql, query, sizeof query, "UPDATE `ownable_cars` SET `tuning_neon2`=%d WHERE `id`=%d LIMIT 1", color_val, sql_id);
			                    }
			                    else if(color_type == 13)
			                    {
			                        vInfo[vehicleid][vNeon3] = color_val;
			                        mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_neon3`=%d WHERE `id`=%d LIMIT 1", color_val, sql_id);
			                    }

			                    mysql_tquery(mysql, query);
			                }
			            }
			    JSON_SetInt(JSONObject, "t", 1);
			    JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
			    JSON_SetInt(JSONObject, "s", 1);
			}
		case 7:
		{
		  switch (detal_id)
		  {

			case 99:
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
			    new hornid, price = 50;
			    if (GetPlayerMoneyEx(playerid) >= price)
			    {
			        GivePlayerMoneyEx(playerid, -price);
			        new hornid = 14;
			        vInfo[vehicleid][vHornSound] = hornid;
			        new query[500];
			    	new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    SetVehicleHornSoundForPlayer(vehicleid, hornid, 14);
			        mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET tuning_exhaust='14' WHERE id=%d LIMIT 1", sql_id);
			        mysql_query(mysql, query, false);
			        SetVehicleHornSoundForPlayer(playerid, vehicleid, hornid);
			            ShowNotificationLonexs(playerid, 2, 5, 0, 0, "ты долбаеб ебучий.", " ");
					JSON_SetInt(JSONObject, "t", 7);
					JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
					JSON_SetInt(JSONObject, "p", detal_id);
					JSON_SetInt(JSONObject, "s", 1);
			    }
				else
				{
				    JSON_SetInt(JSONObject, "s", 0);
				}
				
			}
			case 100:
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
			    new price = 50;
			    new beep = 15;
			    if (GetPlayerMoneyEx(playerid) >= price)
			    {
			        GivePlayerMoneyEx(playerid, -price);
			        new query[256];
			    	new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
			        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_beep=%d WHERE id=%d LIMIT 1", beep, sql_id);
			        mysql_tquery(mysql, query);
					JSON_SetInt(JSONObject, "t", 7);
					JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
					JSON_SetInt(JSONObject, "p", 100);
					JSON_SetInt(JSONObject, "s", 1);
			    }
			}

			case 101:
			{
			    new vehicleid = GetPlayerVehicleID(playerid);
			    new price = 50;
			    new beep = 16;
			    if (GetPlayerMoneyEx(playerid) >= price)
			    {
			        GivePlayerMoneyEx(playerid, -price);
			        new query[256];
			    	new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
			        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_beep=%d WHERE id=%d LIMIT 1", beep, sql_id);
			        mysql_tquery(mysql, query);
					JSON_SetInt(JSONObject, "t", 7);
					JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
					JSON_SetInt(JSONObject, "p", 101);
					JSON_SetInt(JSONObject, "s", 1);
			    }
			}
	        case 32:
			{
			    new price = 50;
			    new vehicleid = GetPlayerVehicleID(playerid);
			      new strobLevel = 32 - 28;
			      GivePlayerDonate(playerid, -price);
			      vInfo[vehicleid][vEnableStrob] = strobLevel;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
					new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_stroboscope=%d WHERE id=%d LIMIT 1",strobLevel, sql_id);
				    mysql_tquery(mysql, query);

				for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
				}

				JSON_SetInt(JSONObject, "t", 7);
				JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(JSONObject, "p", 32);
				JSON_SetInt(JSONObject, "s", 1);
			}

			case 31:
			{
			    new price = 50;
			    new vehicleid = GetPlayerVehicleID(playerid);
			      new strobLevel = 32 - 29;
			      GivePlayerMoney(playerid, -price);
			      vInfo[vehicleid][vEnableStrob] = strobLevel;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
					new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_stroboscope=%d WHERE id=%d LIMIT 1",strobLevel, sql_id);
				    mysql_tquery(mysql, query);

				for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
				}

				JSON_SetInt(JSONObject, "t", 7);
				JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(JSONObject, "p", 31);
				JSON_SetInt(JSONObject, "s", 1);
			}
			case 30:
			{
			    new price = 50;
			    new vehicleid = GetPlayerVehicleID(playerid);
			      new strobLevel = 32 - 30;
			      GivePlayerMoney(playerid, -price);
			      vInfo[vehicleid][vEnableStrob] = strobLevel;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
					new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_stroboscope=%d WHERE id=%d LIMIT 1",strobLevel, sql_id);
				    mysql_tquery(mysql, query);

				for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
				}

				JSON_SetInt(JSONObject, "t", 7);
				JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(JSONObject, "p", 30);
				JSON_SetInt(JSONObject, "s", 1);
			}
			case 29:
			{
			    new price = 50;
			    new vehicleid = GetPlayerVehicleID(playerid);
			      new strobLevel = 32 - 31;
			      GivePlayerMoney(playerid, -price);
			      vInfo[vehicleid][vEnableStrob] = strobLevel;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
					new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_stroboscope=%d WHERE id=%d LIMIT 1",strobLevel, sql_id);
				    mysql_tquery(mysql, query);

				for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
				}

				JSON_SetInt(JSONObject, "t", 7);
				JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(JSONObject, "p", 29);
				JSON_SetInt(JSONObject, "s", 1);
			}
			case 28:
			{
			    new price = 50;
			    new vehicleid = GetPlayerVehicleID(playerid);
			      new strobLevel = 32 - 32;
			      GivePlayerMoney(playerid, -price);
			      vInfo[vehicleid][vEnableStrob] = strobLevel;
                    SetVehicleStroboscope(vehicleid, strobLevel, 1);
					new query[256];
				    new index = GetVehicleData(vehicleid, V_ACTION_ID);
				    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
				    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET tuning_stroboscope=%d WHERE id=%d LIMIT 1",strobLevel, sql_id);
				    mysql_tquery(mysql, query);

				for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
				{
					if(IsPlayerConnected(i)) SetVehicleStroboscopeForPlayer(i, vehicleid, strobLevel);
				}

				JSON_SetInt(JSONObject, "t", 7);
				JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(JSONObject, "p", 28);
				JSON_SetInt(JSONObject, "s", 1);
			}
				case 130:
				{
				    new vehicleid = GetPlayerVehicleID(playerid);
				       new price = 50;
				       if(GetPlayerMoneyEx(playerid) >= price)
				       {
				       GivePlayerMoneyEx(playerid, -price);
				       vInfo[vehicleid][viHighLights] = 1;

						new query[256];
					    new index = GetVehicleData(vehicleid, V_ACTION_ID);
					    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
						mysql_format(mysql, query, sizeof(query), "UPDATE `ownable_cars` SET `tuning_beep` = 1 WHERE `id` = %d", sql_id);
						mysql_tquery(mysql, query);

						JSON_SetInt(JSONObject, "t", 7);
						JSON_SetInt(JSONObject, "m", GetPlayerMoneyEx(playerid));
						JSON_SetInt(JSONObject, "p", 130);
						JSON_SetInt(JSONObject, "s", 1);
 						}
			            else
			            {
			                JSON_SetInt(JSONObject, "s", 0);
			            }
			        }

			}
			}


        default:
        {
            JSON_SetInt(JSONObject, "t", type);
            JSON_SetInt(JSONObject, "s", 0);
            JSON_SetString(JSONObject, "m", "??????????? ????????!");
        }
    }

    JSON_Stringify(JSONObject, outcoming_data);
    OnPacketIncoming(playerid, 28, JSONObject);
    JSON_Cleanup(JSONObject);
}
        case 38:
        {
            new t;
            JSON_GetInt(JSONObject, "t", t);

            switch(t)
            {
                case -1:
                {
                    new skin_id;
                    JSON_GetInt(JSONObject, "i", skin_id);

                    SetPlayerSkin(playerid, skin_id);
                    return 1;
                }
                case 1:
                {
                    new email[128], password[24];
                    JSON_GetString(JSONObject, "s", email);
                    JSON_GetString(JSONObject, "p", password);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);

                    if(strlen(email) != 0)
                    {
                        strmid(GetPlayerData(playerid, P_EMAIL), email, 0, strlen(email), 65);
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
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
                        //SpawnPlayer(playerid);
                    }
                    else
                    {
                        ShowNotificationLonexs(playerid, 2, 5, -1, -1, "вова тест пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ!", "");
                        Kick(playerid);
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
                case 4:
                {
                    new invite_nick[MAX_PLAYER_NAME];
                    JSON_GetString(JSONObject, "s", invite_nick);

                    if(strlen(invite_nick) == 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 38, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    new query[75], Cache:result;
                    mysql_format(mysql, query, sizeof(query), "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
                    result = mysql_query(mysql, query);

                    if(cache_num_rows())
                        SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
                    cache_delete(result);

                    if(!GetPlayerData(playerid, P_REFER))
                    {
                        ShowNotificationLonexs(playerid, 2, 5, -1, -1, "тест вааава пїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ!", "");
                        return 1;
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
case 5:
{
    new final_skin;
    JSON_GetInt(JSONObject, "r", final_skin);

    SetPlayerData(playerid, P_SKIN, final_skin);

    HidePlayerSelectPanel(playerid);
    HidePlayerSelectPanelPrice(playerid);

    // бонусные деньги
    SetPlayerData(playerid, P_MONEY, bonus_money);
    UpdatePlayerDatabaseInt(playerid, "money", bonus_money);

    SetPlayerData(playerid, P_SELECT_SKIN, -1);

    GiveDefaultLicenses(playerid);

    // бонус донат
    new reason[144];
    format(reason, sizeof(reason), "Бонус при регистрации");
    GivePlayerDonateRub(playerid, bonus_donate, reason, true, true);

    // бонус уровень
    SetPlayerData(playerid, P_LEVEL, bonus_lvl);
    UpdatePlayerDatabaseInt(playerid, "level", bonus_lvl);

    // VIP
    SetPlayerData(playerid, P_PREMIUM, vip_type);
    SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
    UpdatePlayerDatabaseInt(playerid, "premium", vip_type);
    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

    // сообщение о VIP
    new prem_year, prem_month, prem_day;
    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);
    format(reason, sizeof(reason), "Вы получили VIP Gold до %02d.%02d.%d при регистрации!", prem_day, prem_month, prem_year);
    SendClientMessage(playerid, 0xFFD700FF, reason);

    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

    // Устанавливаем VW/Interior и спавним
    new spawn_random = random(4);
    SetPlayerSpawnInit(playerid);
    SpawnPlayer(playerid);
    SetPlayerPosEx(playerid, spawn_pos_data[spawn_random][0], spawn_pos_data[spawn_random][1], spawn_pos_data[spawn_random][2], spawn_pos_data[spawn_random][3], 0, 0);

    SetPlayerInit(playerid);

    SetTimerEx("UnfreezePlayerAfterRent", 5000, false, "i", playerid);

    new query[90];
    mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET skin=%d, last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}
                case 6: // Авторизация
                {
                    new password[24], hash[65], auto_login;
                    JSON_GetString(JSONObject, "s", password);
                    JSON_GetInt(JSONObject, "r", auto_login);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);
                    SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

                    printf("[DEBUG] Попытка авторизации игрока %d", playerid);

                    if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
                    {
                        SetPlayerData(playerid, P_AUTH_TIME, -1); // ОБЯЗАТЕЛЬНО!
                        printf("[DEBUG] Авторизация успешна для ID:%d", playerid);
                        
                        LoadPlayerData(playerid);
                        SetPlayerLogged(playerid, true);

                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "c", 1);
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 38, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        
                        // ДОБАВЬТЕ ЭТИ СТРОКИ:
                        SetTimerEx("LoadAccessoriesAfterLogin", 2500, false, "d", playerid);
                       // printf("[DEBUG] Запланирована загрузка аксессуаров после авторизации для ID:%d", playerid);
                    }
                    else
                    {
                        printf("[ERROR] Неверный пароль для игрока %d", playerid);
                        ShowNotificationLonexs(playerid, 2, 5, -1, -1, "Неверный пароль!", "");
                    }
                    return 1;
                }
            }
        }
       case 13:
        {
            new t, sub_id, id;
            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "s", id);
            JSON_GetInt(JSONObject, "b", sub_id);

            switch(t)
            {
                case 0:
                {
                    switch(id)
                    {
                        case 1:
                        {
                            return 1;
                        }
                        case ENTER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case ENTER_CONT:
                        {
                            callcmd::donate(playerid, "");
                        }
                        case OFFER_YES:
                        {
                          //  printf("DEBUG: OFFER_YES case triggered for playerid: %d", playerid);
                            callcmd::yes(playerid, "");
                        }
                        case OFFER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case OFFER_UNLOCK_CAR: // ID для открытия дверей:
                        {
                            callcmd::lock(playerid, "");
                        }
                        case EXIT_HOME:
                        {
                            callcmd::exit(playerid, "");
                        }
                        case GUI_LOCK:
                        {
                            callcmd::exit(playerid, "");
                        }
                        case FRACTION_DOOR:
						{
					    	callcmd::door(playerid, "");
						}
						case OFFER_TYPE_HANDSHAKE:
                    {
                        new offer_id = g_HandshakeOffer[playerid];
                        if(!IsPlayerConnected(offer_id))
                        {
                            ShowNotificationLonexs(playerid, 3, 6, 0, 0, "Игрок уже отключился.", "");
                            g_HandshakeOffer[playerid] = INVALID_PLAYER_ID;
                            // // JSON_Delete(JSONObject);
                            return 1;
                        }

                        new Float:to_x, Float:to_y, Float:z;
                        GetPlayerPos(playerid, to_x, to_y, z);

                        new Float:dist = GetPlayerDistanceFromPoint(offer_id, to_x, to_y, z);
                        if(0.5 <= dist <= 1.5)
                        {
                            new Float:x, Float:y;
                            new Float:angle;

                            GetPlayerPos(playerid, x, y, z);
                            angle = GetAngleToPoint(to_x, to_y, x, y);

                            SetPlayerFacingAngle(playerid, angle);
                            SetPlayerFacingAngle(offer_id, angle + 180.0);

                            new fmt_str[128];
                            format(fmt_str, sizeof fmt_str, "пожал(а) руку %s", GetPlayerNameEx(offer_id));
                            Action(playerid, fmt_str, _, false);

                            ApplyAnimationEx(playerid, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);
                            ApplyAnimationEx(offer_id, "GANGS", "hndshkfa", 4.1, 0, 1, 1, 0, 0, 1);

                            g_HandshakeOffer[playerid] = INVALID_PLAYER_ID;
                        }
                        else
                        {
                            ShowNotificationLonexs(playerid, 2, 6, 0, 0, "Вы слишком далеко.", "");
                        }
                    }
                    case OFFER_TYPE_CASINO_DICE: // ? Обработка игры в кости
                    {
                        new offer_id = g_CasinoOffer[playerid];
                        new bet = g_CasinoBet[playerid];

                        if(offer_id == INVALID_PLAYER_ID || !IsPlayerConnected(offer_id))
                        {
                            ShowNotificationLonexs(playerid, 2, 6, 0, 0, "Игрок уже отключился.", "");
                            g_CasinoOffer[playerid] = INVALID_PLAYER_ID;
                            g_CasinoBet[playerid] = 0;
                            // JSON_Delete(JSONObject);
                            return 1;
                        }

                        new biz_id = GetPlayerInBiz(playerid);

                        if(biz_id == -1 || GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CASINO)
                        {
                            ShowNotificationLonexs(playerid, 2, 6, 0, 0, "Вы должны находиться в казино", "");
                            // JSON_Delete(JSONObject);
                            return 1;
                        }

                        if(!IsPlayerInRangeOfPlayer(playerid, offer_id, 4.0))
                        {
                            ShowNotificationLonexs(playerid, 2, 6, 0, 0, "Игрок находится слишком далеко", "");
                            // JSON_Delete(JSONObject);
                            return 1;
                        }

                        if(GetPlayerMoneyEx(playerid) < bet || GetPlayerMoneyEx(offer_id) < bet)
                        {
                            ShowNotificationLonexs(playerid, 2, 6, 0, 0, "У одного из игроков недостаточно денег", "");
                            // JSON_Delete(JSONObject);
                            return 1;
                        }

                        // Играем кости
                        new player_dice = random(6) + 1;
                        new offer_dice = random(6) + 1;
                        new winner;
                        new fmt_text[90];

                        if(player_dice > offer_dice)
                            winner = playerid;
                        else if(player_dice < offer_dice)
                            winner = offer_id;
                        else
                            winner = -1;

                        format(fmt_text, sizeof fmt_text, "и %s бросили кости. Результат: {FFCD00}%d:%d",
                        GetPlayerNameEx(offer_id), player_dice, offer_dice);

                        Action(playerid, fmt_text, _, false);

                        if(winner == -1)
                        {
                            SetPlayerChatBubble(playerid, "Ничья!", 0xFFCD00FF, 20.0, 2000);
                            SetPlayerChatBubble(offer_id, "Ничья!", 0xFFCD00FF, 20.0, 2000);

                            ShowNotificationLonexs(playerid, 3, 6, 0, 0, "Выпало равное количество, Вы сыграли вничью", "");
                            ShowNotificationLonexs(offer_id, 3, 6, 0, 0, "Выпало равное количество, Вы сыграли вничью", "");
                        }
                        else
                        {
                            new loser = playerid == winner ? offer_id : playerid,
                                winner_dice = playerid == winner ? player_dice : offer_dice,
                                loser_dice = playerid == winner ? offer_dice : player_dice;

                            new percent = bet / 100,
                                cash = bet,
                                take_prods = random(5) + 6;

                            new query[255];

                            if(GetBusinessData(biz_id, B_PRODS) >= take_prods)
                            {
                                cash -= percent;

                                AddBusinessData(biz_id, B_PRODS, -, take_prods);
                                AddBusinessData(biz_id, B_BALANCE, +, percent);

                                format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
                                mysql_query(mysql, query, false);

                                mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(biz_id, B_SQL_ID), GetPlayerAccountID(winner), GetPlayerIpEx(winner), gettime(), percent, IsBusinessOwned(biz_id));
                                mysql_query(mysql, query, false);
                            }

                            // ? Уведомления вместо "Поздравляем" и "К сожалению"
                            new fmt_str[128];
                            format(fmt_str, sizeof fmt_str, "Вы получили %d рублей", cash);
                            ShowNotificationLonexs(winner, 3, 6, 0, 0, fmt_str, "");

                            GivePlayerMoneyEx(winner, cash, "Игра в кости (выиграл)", true, true);

                            format(fmt_str, sizeof fmt_str, "Вы потратили %d рублей", bet);
                            ShowNotificationLonexs(loser, 2, 6, 0, 0, fmt_str, "");

                            GivePlayerMoneyEx(loser, -bet, "Игра в кости (проиграл)", true, true);

                            format(fmt_text, sizeof fmt_text, "Выпало: %d", winner_dice);
                            SetPlayerChatBubble(winner, fmt_text, 0x66CC33FF, 20.0, 2000);

                            format(fmt_text, sizeof fmt_text, "Выпало: %d", loser_dice);
                            SetPlayerChatBubble(loser, fmt_text, 0xFF5533FF, 20.0, 2000);
                        }

                        // Очищаем
                        g_CasinoOffer[playerid] = INVALID_PLAYER_ID;
                        g_CasinoBet[playerid] = 0;
                        g_CasinoOffer[offer_id] = INVALID_PLAYER_ID;
                        g_CasinoBet[offer_id] = 0;
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
        case 22:
        {
            new type;
            JSON_GetInt(JSONObject, "t", type);

            switch(type)
            {
				case 1:
				{
				    callcmd::cases(playerid);
				}
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return 1;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}В разработке", "Данная система в разработке.", "Закрыть", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200);
                    UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    new Node:json_packet_data = JSON_Object();
                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 22, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                }
                case 0:
                {
                    new price, internal_id;
                    JSON_GetInt(JSONObject, "p", internal_id);
                    JSON_GetInt(JSONObject, "m", price);

                    new result = GetPlayerDonateRub(playerid) - price;

                    if(GetPlayerDonateRub(playerid) < price || result < 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);
                        JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
                        JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разлеле {FFFF00}услуги.");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    switch(internal_id)
                    {
                        case 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,195,201,202,211,212,213,214,215,216,217,218,219,220,221,222,223,224,275,276,327,328,329,330,331,347,348,349,350,351,352,353,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484,485,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,522,523,524:                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);
                                JSON_SetString(json_packet_data, "m", "Ошибка");
                                JSON_SetString(json_packet_data, "n", "У вас недостаточно слотов для транспорта");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }
							new color = 1;
							new game_id = GivePlayerCarDonate(playerid,internal_id, color);
	                        if(game_id == -1)
	                        {
	                            SendClientMessage(playerid, -1, "Ошибка: не найден game_id для этого скина");
	                            return 1;
	                        }


                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                             GivePlayerDonateRub(playerid, -price);
                        }
                        case 210,209,344,345,338,339,341,342,343,231,535,536,529,337,527,425,346,333,334,335,340,336,316,317,318,319,320,321,325,326,390,395,396,398,397,232,233,234,235,391,392,393,394,98,99,100,101,332,322,323,324,207,236,237,399,312,230,95,314,528,526,525,519,513,419,430,431,96,97,203,480,481,482,483,488,489,490,491,492,497,313,311,206,93,94,229,516,517,486,487,208,91,92,420,421,514,515,475,205,462,463,457,458,228,315,225,226,227:
                        {
                        
						new game_id = GivePlayerSkinDonate(playerid,internal_id);
                        if(game_id == -1)
                        {
                            SendClientMessage(playerid, -1, "Ошибка: не найден game_id для этого скина");
                            return 1;
                        }

                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 1);
                        JSON_SetInt(json_packet_data, "g", internal_id);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                        JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                        JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентарь (/inv)");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        GivePlayerDonateRub(playerid, -price);
                    }
                    case 531,534,533,530,532,518,493,494,495,496,476,478,422,423,368,361,362,308,369,370,371,372,277,279,285,287,288,289,290,291,292,293,294,298,299,300,301,302,303,304,305,306,307,309,310,274,253,266,373,374,375,357,358,359,360,363,278,280,295,296,297,281,282,283,284,286,247,248,249,250,251,252,477,479,464,432,433,434,436,437,438,439,440,441,442,443,435,376,377,379,380,381,383,384,385,386,389,354,365,241,242,255,265,355,356,364,264,267,259,260,261:
                    {
                        new modelid = GivePlayerAccessoryDonateCustom(playerid, internal_id, modelid);

                        if(modelid == -1)
                        {
                            SendClientMessage(playerid, -1, "{FAD201}Ошибка:{FFFFFF} Неверный аксессуар.");
                            return 1;
                        }
                            GivePlayerAccessoryDonateCustom(playerid, internal_id, modelid);
                            GivePlayerDonateRub(playerid, -price);

                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели аксессуар!");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентарь (/inv)");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);

                    }
                        case 102:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Вы приобрели услугу: изменить имя");
                                JSON_SetString(json_packet_data, "n", "Продолжите в диалоге:");
                                ShowPlayerChangeNameDialog(playerid);
                                GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 103:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: снятие предупреждения");
                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);
                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
                                GivePlayerDonateRub(playerid, -100, "тест", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 104:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 150)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Все лицензии");
                                SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
                                GivePlayerDonateRub(playerid, -150, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 106:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 75)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: вылечиться");
                                SetPlayerData(playerid, P_HEALTH, 100);
                                SetPlayerHealthEx(playerid, 100);
                                GivePlayerDonateRub(playerid, -75, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 107:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Измините имя семьи в диалоге:");
                              //  buyfamname(playerid);
                                GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 108:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат будет списан после передачи");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               // obmenfam(playerid);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 109:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 130)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Военный билет");
                                GivePlayerDonateRub(playerid, -130, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 111:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 500)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "ДАННАЯ УСЛУГА НЕДОСТУПНА");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ-пїЅпїЅпїЅпїЅпїЅпїЅпїЅ!");
                                GivePlayerDonateRub(playerid, 0, "", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 112:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 1000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "Данная услуга недоступна!");
                                // SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ /anymusic");
                                GivePlayerDonateRub(playerid, 0, "1", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 113:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 2500)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                           //     SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, 0, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 114:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, 0, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 115:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ!");
                      //          GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 116:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "ДОНАТ НЕ СПИСАН");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА В РАЗРАБОТКЕ");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅ");
                           //     GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 117:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Недоступно");
                                JSON_SetString(json_packet_data, "n", "Приобретите в ЦБ");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ");
                        //        GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 118:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "ВЫБЕРИТЕ МУЗЫКУ НА ВХОД:");
                            //     SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 119:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                         //       SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅ");
                              //  GivePlayerDonateRub(playerid, -5, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 120:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Услуга недоступна");
                                JSON_SetString(json_packet_data, "n", "Донат не списан");
                     //           SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ!");
                            //    GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 121:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТУПНО");
                      //          SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ");
                                //GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 122:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Прибавлен +1 слот на транспорт");
                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                           //     new fmt_text[200];
                            //    format(fmt_text, sizeof(fmt_text), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ: %d", GetPlayerData(playerid, P_CAR_SLOTS));
                     //           SendClientMessage(playerid, 0x66CC00FF, fmt_text);
                                GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= 85)
                            {
                                //callcmd::number(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                        case 124:
                        {
                            if(GetPlayerDonateRub(playerid) >= 70)
                            {
                                callcmd::buyphonenum(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                        case 179:
                        {
                            BuyPlayerCar(playerid, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Сельчанин", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 419,0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Бандит", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Молодой", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 527, 0);
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Гангстер", price, internal_id);
                        }
                        case 269:
                        {
                            
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Красотка", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoneyEx(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Бродяга", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoneyEx(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Всё впереди", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoneyEx(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Зажиточный", price, internal_id);
                        }
                    }
                }
            }
        }
    }
    JSON_Cleanup(JSONObject);
    return 1;
}

public FindGameId(internalId, array[][], array_size)
{
    for(new i = 0; i < array_size; i++)
    {
        if(array[i][0] == internalId)
        {
            return array[i][1];
        }
    }
    return -1;
}

public BuyPlayerCar(playerid, internal_id, color)
{
    if(internal_id == -1)
    {
        return 1;
    }

    new free_car_id = GetFreeOwnableCarID();
    new Float:pos_x = 2498.205810;
    new Float:pos_y = -742.256042;
    new Float:pos_z = 12.164166;
    new Float:angle = 356.240051;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, internal_id);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "regerds_test_number", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    format(database_query, sizeof(database_query), "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        GetPlayerAccountID(playerid), internal_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     //SetPlayerData(playerid, P_SKIN, game_id); // Сохраняем в данные игрока
//     SetPlayerSkin(playerid, game_id); // Надеваем скин на клиента

//     // Сохраняем скин в базу данных
//     new query[256];
//     format(query, sizeof query, "UPDATE accounts SET skin = %d WHERE id = %d", game_id, GetPlayerAccountID(playerid));
//     mysql_query(mysql, query, false);
// }

public ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), json_data[512];
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Покупка набора");
    JSON_SetString(json_packet_data, "n", pack_name);
    JSON_Stringify(json_packet_data, json_data);
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}

// CMD:testuved(playerid)
// {
//  ShowNotificationLonexs(playerid, OFFER_ENGINE, 6, 0, 0, "Взаимодействие", "");
//  return 1;
// } 
// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     GivePlayerOwnableSkin(playerid, game_id);
// }
public BuyPlayerSkin(playerid, internal_id, game_id)
{
    GivePlayerSkin(playerid, game_id);
}
// public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
// {
//     new Node:json_packet_data = JSON_Object(), json_data[512];

//     JSON_SetInt(json_packet_data, "t", 0);
//     JSON_SetInt(json_packet_data, "y", 1);

//     JSON_SetInt(json_packet_data, "g", internal_id);

//     JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
//     JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

//     JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
//     JSON_SetString(json_packet_data, "n", pack_name);

//     JSON_Stringify(json_packet_data, json_data);
//     OnPacketIncoming(playerid, 22, json_packet_data);

//     JSON_Cleanup(json_packet_data);
// }
stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 252);

	BS_WriteValue(bitstream, PR_UINT16, guiid);

	new data[1024]; //4294967295
    JSON_Stringify(json, data);

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}







stock GivePlayerSkinDonate(playerid,internal_id)
{
	new modelid;

	
	switch(internal_id)
	{
 		case 535:
        {
            modelid = 6871;
        }
 		case 536:
        {
            modelid = 6872;
        }
        case 529:
        {
            modelid = 6894;
        }
        case 527:
        {
            modelid = 6895;
        }
        case 528:
        {
            modelid = 6896;
        }
        case 526:
        {
            modelid = 6893;
        }
        case 519:
        {
            modelid = 6832;
        }
        case 563:
        {
            modelid = 6892;
        }
        case 567:
        {
            modelid = 6895;
        }
        case 566:
        {
            modelid = 6896;
        }
        case 564:
        {
            modelid = 6893;
        }
        case 407:
        {
            modelid = 6832;
        }
        case 513:
        {
            modelid = 529;
        }
        case 514:
        {
            modelid = 19273;
        }
        case 515:
        {
            modelid = 6780;
        }
        case 516:
        {
            modelid = 11961;
        }
        case 517:
        {
            modelid = 11962;
        }
        case 486:
        {
            modelid = 11956;
        }
        case 487:
        {
            modelid = 11958;
        }
        case 488:
        {
            modelid = 11953;
        }
        case 489:
        {
            modelid = 11948;
        }
        case 490:
        {
            modelid = 11951;
        }
        case 491:
        {
            modelid = 11947;
        }
        case 4922:
        {
            modelid = 11957;
        }
        case 497:
        {
            modelid = 11959;
        }
        case 480:
        {
            modelid = 11934;
        }
        case 481:
        {
            modelid = 11933;
        }
        case 482:
        {
            modelid = 11935;
        }
        case 483:
        {
            modelid = 11944;
        }
        case 475:
        {
            modelid = 11917;
        }
        case 462:
        {
            modelid = 12293;
        }
        case 463:
        {
            modelid = 12291;
        }
        case 457:
        {
            modelid = 14386;
        }
        case 458:
        {
            modelid = 14388;
        }
        case 419:
        {
            modelid = 5323;
        }
        case 430:
        {
            modelid = 5326;
        }
        case 431:
        {
            modelid = 5326;
        }
        case 425:
        {
            modelid = 5362;
        }
        case 420:
        {
            modelid = 5367;
        }
        case 421:
        {
            modelid = 5365;
        }
        case 399:
        {
            modelid = 18606;
        }
        case 390:
        {
            modelid = 310;
        }
        case 391:
        {
            modelid = 18621;
        }
        case 392:
        {
            modelid = 311;
        }
        case 393:
        {
            modelid = 18620;
        }
        case 394:
        {
            modelid = 18623;
        }
        case 395:
        {
            modelid = 18624;
        }
        case 396:
        {
            modelid = 18625;
        }
        case 397:
        {
            modelid = 18626;
        }
        case 398:
        {
            modelid = 18628;
        }
        case 346:
        {
            modelid = 2;
        }
        case 344:
        {
            modelid = 302;
        }
        case 345:
        {
            modelid = 301;
        }
        case 332:
        {
            modelid = 196;
        }
        case 333:
        {
            modelid = 129;
        }
        case 334:
        {
            modelid = 130;
        }
        case 335:
        {
            modelid = 24;
        }
        case 340:
        {
            modelid = 197;
        }
        case 336:
        {
            modelid = 245;
        }
        case 337:
        {
            modelid = 243;
        }
        case 338:
        {
            modelid = 89;
        }
        case 339:
        {
            modelid = 88;
        }
        case 341:
        {
            modelid = 10;
        }
        case 342:
        {
            modelid = 92;
        }
        case 343:
        {
            modelid = 99;
        }
        case 315:
        {
            modelid = 110;
        }
        case 313:
        {
            modelid = 108;
        }
        case 311:
        {
            modelid = 95;
        }
        case 322:
        {
            modelid = 49;
        }
        case 323:
        {
            modelid = 53;
        }
        case 324:
        {
            modelid = 160;
        }
        case 314:
        {
            modelid = 109;
        }
        case 312:
        {
            modelid = 106;
        }
        case 316:
        {
            modelid = 165;
        }
        case 317:
        {
            modelid = 166;
        }
        case 318:
        {
            modelid = 174;
        }
        case 319:
        {
            modelid = 5;
        }
        case 320:
        {
            modelid = 267;
        }
        case 321:
        {
            modelid = 283;
        }
        case 325:
        {
            modelid = 162;
        }
        case 326:
        {
            modelid = 210;
        }
		case 238:
        {
            modelid = 65;
        }
        case 257:
        {
            modelid = 209;
        }
        case 239:
        {
            modelid = 39;
        }
        case 240:
        {
            modelid = 207;
        }
        case 225:
        {
            modelid = 86;
        }
        case 226:
        {
            modelid = 224;
        }
        case 227:
        {
            modelid = 232;
        }
        case 228:
        {
            modelid = 269;
        }
        case 205:
        {
            modelid = 252;
        }
        case 206:
        {
            modelid = 236;
        }
        case 207:
        {
            modelid = 48;
        }
        case 208:
        {
            modelid = 63;
        }
		case 91:
        {
            modelid = 23;
        }
        case 92:
        {
            modelid = 22;
        }
        case 229:
        {
            modelid = 231;
        }
        case 93:
        {
            modelid = 220;
        }
        case 94:
        {
            modelid = 225;
        }
        case 230:
        {
            modelid = 175;
        }
        case 95:
        {
            modelid = 202;
        }
        case 96:
        {
            modelid = 204;
        }
        case 97:
        {
            modelid = 229;
        }
        case 203:
        {
            modelid = 57;
        }
        case 231:
        {
            modelid = 208;
        }
        case 232:
        {
            modelid = 199;
        }
        case 233:
        {
            modelid = 264;
        }
        case 234:
        {
            modelid = 262;
        }
        case 235:
        {
            modelid = 62;
        }
        case 98:
        {
            modelid = 200;
        }
        case 99:
        {
            modelid = 234;
        }
        case 100:
        {
            modelid = 249;
        }
        case 101:
        {
            modelid = 235;
        }
        case 236:
        {
            modelid = 298;
        }
        case 237:
        {
            modelid = 266;
        }
        case 209:
        {
            modelid = 270;
        }
        case 210:
        {
            modelid = 122;
        }
	}
        GivePlayerSkin(playerid, modelid);
}

stock GivePlayerCarDonate(playerid,internal_id)
{
	new modelid;
	new color = 1;

	switch(internal_id)
	{
 		case 5:
        {
            modelid = 555;
        }
 		case 6:
        {
            modelid = 549;
        }
        case 7:
        {
            modelid = 401;
        }
        case 8:
        {
            modelid = 479;
        }
        case 9:
        {
            modelid = 496;
        }
        case 10:
        {
            modelid = 404;
        }
        case 11:
        {
            modelid = 458;
        }
        case 12:
        {
            modelid = 586;
        }
        case 13:
        {
            modelid = 536;
        }
        case 14:
        {
            modelid = 529;
        }
        case 15:
        {
            modelid = 534;
        }
        case 16:
        {
            modelid = 542;
        }
        case 17:
        {
            modelid = 540;
        }
        case 18:
        {
            modelid = 559;
        }
        case 19:
        {
            modelid = 421;
        }
        case 20:
        {
            modelid = 2554;
        }
        case 21:
        {
            modelid = 2548;
        }
        case 22:
        {
            modelid = 419;
        }
        case 23:
        {
            modelid = 562;
        }
   		case 24:
        {
            modelid = 507;
        }
        case 25:
        {
            modelid = 426;
        }
        case 26:
        {
            modelid = 516;
        }
        case 27:
        {
            modelid = 467;
        }
        case 347:
        {
            modelid = 2580;
        }
        case 28:
        {
            modelid = 527;
        }
        case 29:
        {
            modelid = 445;
        }
        case 31:
        {
            modelid = 587;
        }
        case 32:
        {
            modelid = 436;
        }
        case 33:
        {
            modelid = 560;
        }
        case 34:
        {
            modelid = 550;
        }
        case 348:
        {
            modelid = 2584;
        }
        case 35:
        {
            modelid = 603;
        }
        case 36:
        {
            modelid = 2552;
        }
        case 37:
        {
            modelid = 565;
        }
        case 38:
        {
            modelid = 551;
        }
        case 39:
        {
            modelid = 526;
        }
        case 40:
        {
            modelid = 442;
        }
        case 41:
        {
            modelid = 489;
        }
        case 42:
        {
            modelid = 543;
        }
        case 43:
        {
            modelid = 480;
        }
        case 44:
        {
            modelid = 558;
        }
        case 45:
        {
            modelid = 495;
        }
        case 46:
        {
            modelid = 475;
        }
        case 47:
        {
            modelid = 503;
        }
        case 48:
        {
            modelid = 410;
        }
        case 49:
        {
            modelid = 402;
        }
        case 50:
        {
            modelid = 2553;
        }
        case 51:
        {
            modelid = 505;
        }
        case 52:
        {
            modelid = 2547;
        }
        case 53:
        {
            modelid = 502;
        }
        case 54:
        {
            modelid = 400;
        }
        case 55:
        {
            modelid = 604;
        }
        case 56:
        {
            modelid = 405;
        }
        case 57:
        {
            modelid = 506;
        }
        case 58:
        {
            modelid = 2550;
        }
        case 59:
        {
            modelid = 466;
        }
        case 60:
        {
            modelid = 2545;
        }
        case 61:
        {
            modelid = 490;
        }
        case 62:
        {
            modelid = 420;
        }
        case 349:
        {
            modelid = 2582;
        }
        case 63:
        {
            modelid = 533;
        }
        case 64:
        {
            modelid = 2546;
        }
        case 65:
        {
            modelid = 494;
        }
        case 66:
        {
            modelid = 429;
        }
        case 67:
        {
            modelid = 451;
        }
        case 68:
        {
            modelid = 2544;
        }
        case 69:
        {
            modelid = 2551;
        }
        case 70:
        {
            modelid = 2549;
        }
        case 71:
        {
            modelid = 579;
        }
        case 351:
        {
            modelid = 2578;
        }
        case 72:
        {
            modelid = 541;
        }
        case 352:
        {
            modelid = 2581;
        }
        case 73:
        {
            modelid = 411;
        }
        case 350:
        {
            modelid = 2579;
        }
        case 74:
        {
            modelid = 415;
        }
        case 75:
        {
            modelid = 2543;
        }
        case 76:
        {
            modelid = 462;
        }
        case 77:
        {
            modelid = 468;
        }
        case 78:
        {
            modelid = 461;
        }
        case 79:
        {
            modelid = 463;
        }
        case 80:
        {
            modelid = 523;
        }
		case 81:
        {
            modelid = 586;
        }
        case 82:
        {
            modelid = 521;
        }
        case 83:
        {
            modelid = 581;
        }
        case 84:
        {
            modelid = 522;
        }
        case 85:
        {
            modelid = 582;
        }
        case 86:
        {
            modelid = 597;
        }
        case 87:
        {
            modelid = 470;
        }
        case 88:
        {
            modelid = 416;
        }
        case 89:
        {
            modelid = 598;
        }
        case 90:
        {
            modelid = 596;
        }
        case 91:
        {
            modelid = 48;
        }
        case 201:
        {
            modelid = 413;
        }
		case 202:
        {
            modelid = 418;
        }
        case 195:
        {
            modelid = 440;
        }
        case 211:
        {
            modelid = 2555;
        }
        case 212:
        {
            modelid = 2557;
        }
        case 213:
        {
            modelid = 2565;
        }
        case 214:
        {
            modelid = 2566;
        }
        case 215:
        {
            modelid = 2560;
        }
        case 216:
        {
            modelid = 2561;
        }
        case 217:
        {
            modelid = 2568;
        }
        case 218:
        {
            modelid = 2567;
        }
        case 219:
        {
            modelid = 2559;
        }
        case 220:
        {
            modelid = 2558;
        }
        case 353:
        {
            modelid = 2583;
        }
        case 221:
        {
            modelid = 2564;
        }
        case 222:
        {
            modelid = 2563;
        }
        case 223:
        {
            modelid = 2570;
        }
        case 224:
        {
            modelid = 2569;
        }
        case 275:
        {
            modelid = 2571;
        }
        case 276:
        {
            modelid = 2572;
        }
        case 327:
        {
            modelid = 2574;
        }
        case 328:
        {
            modelid = 2575;
        }
        case 329:
        {
            modelid = 2573;
        }
        case 330:
        {
            modelid = 2577;
        }
        case 331:
        {
            modelid = 2576;
        }
        case 366:
        {
            modelid = 2586;
        }
        case 367:
        {
            modelid = 2585;
        }
        case 400:
        {
            modelid = 412;
        }
        case 401:
        {
            modelid = 439;
        }
		case 402:
        {
            modelid = 492;
        }
        case 403:
        {
            modelid = 547;
        }
        case 404:
        {
            modelid = 491;
        }
        case 405:
        {
            modelid = 546;
        }
        case 406:
        {
            modelid = 2589;
        }
        case 407:
        {
            modelid = 2588;
        }
        case 408:
        {
            modelid = 2587;
        }
        case 409:
        {
            modelid = 483;
        }
        case 410:
        {
            modelid = 2590;
        }
        case 411:
        {
            modelid = 2591;
        }
        case 413:
        {
            modelid = 452;
        }
        case 414:
        {
            modelid = 453;
        }
		case 415:
        {
            modelid = 454;
        }
        case 416:
        {
            modelid = 472;
        }
        case 417:
        {
            modelid = 473;
        }
        case 418:
        {
            modelid = 493;
        }
        case 424:
        {
            modelid = 2592;
        }
        case 426:
        {
            modelid = 2594;
        }
        case 427:
        {
            modelid = 2596;
        }
        case 428:
        {
            modelid = 2595;
        }
        case 429:
        {
            modelid = 2593;
        }
        case 444:
        {
            modelid = 2597;
        }
        case 445:
        {
            modelid = 2598;
        }
        case 446:
        {
            modelid = 2599;
        }
        case 447:
        {
            modelid = 2600;
        }
        case 448:
        {
            modelid = 2601;
        }
        case 449:
        {
            modelid = 2602;
        }
        case 450:
        {
            modelid = 2603;
        }
        case 451:
        {
            modelid = 2604;
        }
        case 452:
        {
            modelid = 2607;
        }
        case 453:
        {
            modelid = 2608;
        }
        case 454:
        {
            modelid = 2609;
        }
        case 455:
        {
            modelid = 2610;
        }
        case 456:
        {
            modelid = 2611;
        }
        case 459:
        {
            modelid = 448;
        }
        case 460:
        {
            modelid = 2616;
        }
        case 461:
        {
            modelid = 2617;
        }
        case 465:
        {
            modelid = 2618;
        }
        case 466:
        {
            modelid = 2619;
        }
        case 467:
        {
            modelid = 2620;
        }
        case 468:
        {
            modelid = 2621;
        }
        case 469:
        {
            modelid = 2622;
        }
        case 470:
        {
            modelid = 2623;
        }
        case 471:
        {
            modelid = 2624;
        }
        case 472:
        {
            modelid = 2625;
        }
        case 473:
        {
            modelid = 2626;
        }
        case 474:
        {
            modelid = 2627;
        }
        case 484:
        {
            modelid = 2604;
        }
		case 485:
		{
		    modelid = 2377;
		}

		case 498:
		{
		    modelid = 2380;
		}

		case 499:
		{
		    modelid = 2381;
		}

		case 500:
		{
		    modelid = 2385;
		}

		case 501:
		{
		    modelid = 2386;
		}

		case 502:
		{
		    modelid = 2387;
		}

		case 503:
		{
		    modelid = 2388;
		}

		case 504:
		{
		    modelid = 2389;
		}

		case 505:
		{
		    modelid = 2390;
		}

		case 506:
		{
		    modelid = 2391;
		}

		case 507:
		{
		    modelid = 2392;
		}

		case 508:
		{
		    modelid = 2393;
		}

		case 509:
		{
		    modelid = 2394;
		}

		case 510:
		{
		    modelid = 2382;
		}

		case 511:
		{
		    modelid = 2383;
		}

		case 512:
		{
		    modelid = 2384;
		}
		case 522:
		{
		    modelid = 614;
		}

		case 523:
		{
		    modelid = 613;
		}

		case 524:
		{
		    modelid = 622;
		}
        
	}
	BuyPlayerCar(playerid, modelid, color);
 }
stock GivePlayerAccessoryDonateCustom(playerid, internal_id, modelid)
{
	new item, bone, modelid;

    // ????????? ??? ??????? internal_id
    switch(internal_id)
    {
        case 531: 
        {
            item = 915;
            modelid = 2656;
            bone = 1;
        }
        case 530:
        {
            item = 914;
            modelid = 2655;
            bone = 1;
            
        }
        case 532:
        {
            item = 916;
            modelid = 2657;
            bone = 1;

        }
		case 533:
        {
            item = 917;
            modelid = 676;
            bone = 1;
        }

   		case 534:
        {
            item = 918;
            modelid = 677;
            bone = 1;

        }
        case 518:
        {
            item = 709;
            modelid = 16055;
            bone = 1;
        }
        case 493:
        {
            item = 660;
            modelid = 9824;
            bone = 1;

        }
        case 494:
        {
            item = 662;
            modelid = 9826;
            bone = 1;

        }
		case 495:
        {
            item = 663;
            modelid = 9827;
            bone = 1;
        }

   		case 496:
        {
            item = 664;
            modelid = 9828;
            bone = 1;

        }
        case 476:
        {
            item = 579;
            modelid = 11919;
            bone = 1;
        }
        case 477:
        {
            item = 582;
            modelid = 11922;
            bone = 1;

        }
        case 478:
        {
            item = 583;
            modelid = 11923;
            bone = 1;

        }
		case 479:
        {
            item = 585;
            modelid = 11925;
            bone = 1;
        }

   		case 463:
        {
            item = 576;
            modelid = 13801;
            bone = 1;
        }
   		case 464:
        {
            item = 578;
            modelid = 13803;
            bone = 1;
        }

   		case 432:
        {
            item = 513;
            modelid = 14589;
            bone = 1;

        }
        case 433:
        {
            item = 515;
            modelid = 14591;
            bone = 1;
        }
        case 434:
        {
            item = 516;
            modelid = 14592;
            bone = 1;

        }
        case 436:
        {
            item = 520;
            modelid = 14596;
            bone = 1;

        }
		case 437:
        {
            item = 521;
            modelid = 14597;
            bone = 1;
        }

   		case 438:
        {
            item = 522;
            modelid = 14598;
            bone = 1;

        }
        case 439:
        {
            item = 527;
            modelid = 14603;
            bone = 1;
        }
        case 440:
        {
            item = 531;
            modelid = 4160;
            bone = 1;

        }
        case 441:
        {
            item = 532;
            modelid = 4161;
            bone = 1;

        }
		case 442:
        {
            item = 533;
            modelid = 4126;
            bone = 1;
        }

   		case 443:
        {
            item = 534;
            modelid = 4163;
            bone = 1;

        }
        case 435:
        {
            item = 536;
            modelid = 4165;
            bone = 1;
        }
        case 422:
        {
            item = 511;
            modelid = 14575;
            bone = 1;

        }
        case 423:
        {
            item = 511;
            modelid = 14575;
            bone = 1;

        }
		case 368:
        {
            item = 359;
            modelid = 18509;
            bone = 1;
        }

   		case 369:
        {
            item = 360;
            modelid = 18510;
            bone = 1;

        }
        case 370:
        {
            item = 361;
            modelid = 18511;
            bone = 1;
        }
        case 371:
        {
            item = 362;
            modelid = 18512;
            bone = 1;

        }
        case 372:
        {
            item = 363;
            modelid = 18513;
            bone = 1;

        }
		case 373:
        {
            item = 364;
            modelid = 18514;
            bone = 1;
        }

   		case 374:
        {
            item = 365;
            modelid = 18515;
            bone = 1;
        }
   		case 375:
        {
            item = 366;
            modelid = 18516;
            bone = 1;
        }

   		case 376:
        {
            item = 367;
            modelid = 18617;
            bone = 1;

        }
        case 377:
        {
            item = 368;
            modelid = 18518;
            bone = 1;
        }
        case 378:
        {
            item = 369;
            modelid = 18519;
            bone = 1;

        }
        case 379:
        {
            item = 370;
            modelid = 18520;
            bone = 1;

        }
		case 380:
        {
            item = 371;
            modelid = 18521;
            bone = 1;
        }

   		case 381:
        {
            item = 372;
            modelid = 18522;
            bone = 1;

        }
		case 382:
        {
            item = 373;
            modelid = 18523;
            bone = 1;
        }

   		case 383:
        {
            item = 374;
            modelid = 18524;
            bone = 1;

        }
        case 384:
        {
            item = 375;
            modelid = 18525;
            bone = 1;
        }
        case 385:
        {
            item = 376;
            modelid = 18526;
            bone = 1;

        }
        case 386:
        {
            item = 377;
            modelid = 18527;
            bone = 1;

        }
		case 387:
        {
            item = 378;
            modelid = 18528;
            bone = 1;
        }

   		case 388:
        {
            item = 379;
            modelid = 18529;
            bone = 1;

        }
        case 389:
        {
            item = 380;
            modelid = 18530;
            bone = 1;
        }
        case 354:
        {
            item = 347;
            modelid = 18497;
            bone = 1;

        }
        case 355:
        {
            item = 348;
            modelid = 18498;
            bone = 1;

        }
		case 356:
        {
            item = 349;
            modelid = 18499;
            bone = 1;
        }

   		case 357:
        {
            item = 350;
            modelid = 18500;
            bone = 1;
        }
   		case 358:
        {
            item = 351;
            modelid = 18501;
            bone = 1;
        }

   		case 359:
        {
            item = 352;
            modelid = 18502;
            bone = 1;

        }
        case 360:
        {
            item = 353;
            modelid = 18503;
            bone = 1;
        }
        case 361:
        {
            item = 354;
            modelid = 18504;
            bone = 1;

        }
        case 362:
        {
            item = 355;
            modelid = 18505;
            bone = 1;

        }
		case 363:
        {
            item = 356;
            modelid = 18506;
            bone = 1;
        }

   		case 364:
        {
            item = 357;
            modelid = 18507;
            bone = 1;
        }
        case 365:
        {
            item = 358;
            modelid = 18508;
            bone = 1;
        }
        case 277:
        {
            item = 170;
            modelid = 18233;
            bone = 1;

        }
		case 278:
        {
            item = 169;
            modelid = 18232;
            bone = 1;
        }

   		case 279:
        {
            item = 180;
            modelid = 18243;
            bone = 1;

        }
        case 280:
        {
            item = 187;
            modelid = 18250;
            bone = 1;
        }
        case 295:
        {
            item = 295;
            modelid = 18383;
            bone = 1;

        }
        case 296:
        {
            item = 296;
            modelid = 18384;
            bone = 1;

        }
		case 281:
        {
            item = 200;
            modelid = 18263;
            bone = 1;
        }

   		case 282:
        {
            item = 201;
            modelid = 18264;
            bone = 1;
        }
   		case 283:
        {
            item = 210;
            modelid = 18273;
            bone = 1;
        }

   		case 284:
        {
            item = 216;
            modelid = 18279;
            bone = 1;

        }
/*        case 285:
        {
            item = 220;
            modelid = 18285;
            bone = 1;
        }
        case 286:
        {
            item = 221;
            modelid = 18286;
            bone = 1;

        }
        case 287:
        {
            item = 263;
            modelid = 18346;
            bone = 1;

        }
		case 288:
        {
            item = 264;
            modelid = 18347;
            bone = 1;
        }

   		case 289:
        {
            item = 265;
            modelid = 18348;
            bone = 1;

        }
		case 290:
        {
            item = 281;
            modelid = 18369;
            bone = 1;
        }

   		case 291:
        {
            item = 287;
            modelid = 18375;
            bone = 1;

        }
        case 292:
        {
            item = 289;
            modelid = 18377;
            bone = 1;
        }
        case 293:
        {
            item = 290;
            modelid = 18378;
            bone = 1;

        }
        case 294:
        {
            item = 291;
            modelid = 18379;
            bone = 1;

        }
		case 298:
        {
            item = 301;
            modelid = 18389;
            bone = 1;
        }

   		case 299:
        {
            item = 302;
            modelid = 18390;
            bone = 1;

        }
        case 300:
        {
            item = 303;
            modelid = 18391;
            bone = 1;
        }
        case 301:
        {
            item = 304;
            modelid = 18392;
            bone = 1;

        }
        case 302:
        {
            item = 308;
            modelid = 18396;
            bone = 1;

        }
		case 303:
        {
            item = 309
            modelid = 18397;
            bone = 1;
        }

   		case 304:
        {
            item = 313;
            modelid = 18401;
            bone = 1;
        }
   		case 305:
        {
            item = 316;
            modelid = 18404;
            bone = 1;
        }

   		case 306:
        {
            item = 321;
            modelid = 18409;
            bone = 1;

        }
        case 307:
        {
            item = 322;
            modelid = 18410;
            bone = 1;
        }
        case 308:
        {
            item = 323;
            modelid = 18411;
            bone = 1;

        }
        case 309:
        {
            item = 324;
            modelid = 18412;
            bone = 1;

        }
		case 310:
        {
            item = 326;
            modelid = 18414;
            bone = 1;
        }

   		case 243:
        {
            item = 138;
            modelid = 15137;
            bone = 1;
        }
   		case 244:
        {
            item = 139;
            modelid = 15138;
            bone = 1;
        }

   		case 245:
        {
            item = 140;
            modelid = 18502;
            bone = 1;

        }
        case 360:
        {
            item = 353;
            modelid = 18503;
            bone = 1;
        }
        case 361:
        {
            item = 354;
            modelid = 18504;
            bone = 1;

        }
        case 362:
        {
            item = 355;
            modelid = 18505;
            bone = 1;

        }
		case 363:
        {
            item = 356;
            modelid = 18506;
            bone = 1;
        }

   		case 364:
        {
            item = 357;
            modelid = 18507;
            bone = 1;
        }
        case 365:
        {
            item = 358;
            modelid = 18508;
            bone = 1;
        }
        case 277:
        {
            item = 170;
            modelid = 18233;
            bone = 1;

        }
		case 278:
        {
            item = 169;
            modelid = 18232;
            bone = 1;
        }

   		case 279:
        {
            item = 180;
            modelid = 18243;
            bone = 1;

        }
        case 280:
        {
            item = 187;
            modelid = 18250;
            bone = 1;
        }
        case 295:
        {
            item = 295;
            modelid = 18383;
            bone = 1;

        }
        case 296:
        {
            item = 296;
            modelid = 18384;
            bone = 1;

        }
		case 281:
        {
            item = 200
            modelid = 18263;
            bone = 1;
        }

   		case 282:
        {
            item = 201;
            modelid = 18264;
            bone = 1;
        }
   		case 283:
        {
            item = 210;
            modelid = 18273;
            bone = 1;
        }

   		case 284:
        {
            item = 216;
            modelid = 18279;
            bone = 1;

        }
        case 285:
        {
            item = 220;
            modelid = 18285;
            bone = 1;
        }
        case 286:
        {
            item = 221;
            modelid = 18286;
            bone = 1;

        }
        case 287:
        {
            item = 263;
            modelid = 18346;
            bone = 1;

        }
		case 288:
        {
            item = 264;
            modelid = 18347;
            bone = 1;
        }

   		case 289:
        {
            item = 265;
            modelid = 18348;
            bone = 1;

        }
		case 290:
        {
            item = 281;
            modelid = 18369;
            bone = 1;
        }

   		case 291:
        {
            item = 287;
            modelid = 18375;
            bone = 1;

        }
        case 292:
        {
            item = 289;
            modelid = 18377;
            bone = 1;
        }
        case 293:
        {
            item = 290;
            modelid = 18378;
            bone = 1;

        }
        case 294:
        {
            item = 291;
            modelid = 18379;
            bone = 1;

        }
		case 298:
        {
            item = 301;
            modelid = 18389;
            bone = 1;
        }

   		case 299:
        {
            item = 302;
            modelid = 18390;
            bone = 1;

        }
        case 300:
        {
            item = 303;
            modelid = 18391;
            bone = 1;
        }
        case 301:
        {
            item = 304;
            modelid = 18392;
            bone = 1;

        }
        case 302:
        {
            item = 308;
            modelid = 18396;
            bone = 1;

        }
		case 303:
        {
            item = 309
            modelid = 18397;
            bone = 1;
        }

   		case 304:
        {
            item = 313;
            modelid = 18401;
            bone = 1;
        }
   		case 305:
        {
            item = 316;
            modelid = 18404;
            bone = 1;
        }

   		case 306:
        {
            item = 321;
            modelid = 18409;
            bone = 1;

        }
        case 307:
        {
            item = 322;
            modelid = 18410;
            bone = 1;
        }
        case 308:
        {
            item = 323;
            modelid = 18411;
            bone = 1;

        }
        case 309:
        {
            item = 324;
            modelid = 18412;
            bone = 1;

        }
		case 310:
        {
            item = 326;
            modelid = 18414;
            bone = 1;
        }

   		case 243:
        {
            item = 138;
            modelid = 15137;
            bone = 1;
        }*/
        default:
        {
        }
    }

    // ???? ????????? ????
    new slot = -1;
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invItem] == 0)
        {
            slot = i;
            break;
        }
    }

    if(slot == -1) return 0;

    // ????????? ??????
    PlayerInventory[playerid][slot][invItem] = item;
    PlayerInventory[playerid][slot][invCount] = 1;
    PlayerInventory[playerid][slot][invValue] = modelid;
    PlayerInventory[playerid][slot][invBone] = bone;
    PlayerInventory[playerid][slot][invPosX] = 0.0;
    PlayerInventory[playerid][slot][invPosY] = 0.0;
    PlayerInventory[playerid][slot][invPosZ] = 0.0;
    PlayerInventory[playerid][slot][invRotX] = 0.0;
    PlayerInventory[playerid][slot][invRotY] = 0.0;
    PlayerInventory[playerid][slot][invRotZ] = 0.0;
    PlayerInventory[playerid][slot][invScaleX] = 1.0;
    PlayerInventory[playerid][slot][invScaleY] = 1.0;
    PlayerInventory[playerid][slot][invScaleZ] = 1.0;
    PlayerInventory[playerid][slot][invInUse] = 0;

    // ????????? ? ??
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `inventory` (`uid`, `item_id`, `count`, `value`, `slot`, `bone`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `scale_x`, `scale_y`, `scale_z`, `in_use`) \
         VALUES (%d, %d, 1, %d, %d, %d, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0)",
        GetPlayerAccountID(playerid),item, modelid, slot, bone);
    mysql_tquery(mysql, query, "OnItemInserted", "ii", playerid, slot);

    return 1;
}

