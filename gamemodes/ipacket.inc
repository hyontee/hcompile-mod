#define LAREK   10
#define notifcmdcont    102
#include "../include/system/electric_job.pwn"
new g_PlayerOpenType[MAX_PLAYERS];
stock IsCharNumeric(c) {
    return (c >= '0' && c <= '9');
}
#define GUI_TECHCENTER  1
#define GUI_TUNGUI         2
#define GUI_NONE    3
new player_gui_type[MAX_PLAYERS];
IPacket:252(playerid, BitStream:bitstream)
{
    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length, json_data[256];
    BS_ReadValue(bitstream, PR_UINT32, length);
    BS_ReadValue(bitstream, PR_STRING, json_data, length);

    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(!IsPlayerConnected(playerid)) return 0;

    if(length <= 0 || length >= sizeof(json_data)) return 0;

    new Node:json = JSON_Object();
    JSON_Parse(json_data, json);

    switch (guiid)
    {
        case 46:
{
    new type;
    JSON_GetInt(json, "button", type);

    switch (type)
    {
        case 6: // ������� �� ������ "������� �������"
        {
            printf("[FractionSystem] Player %d requested fraction quests interface", playerid);

            new Node:response = JSON_Object();

            JSON_SetInt(response, "page", 3);           // page=3 � ��������� �������
            JSON_SetInt(response, "fraction_id", 7);
            JSON_SetInt(response, "task_rank", 2);

            printf("[FractionSystem] Opening quests for player %d (fraction: %d, rank: %d)",
                playerid, 7, 2);

            OnPacketIncoming(playerid, 46, response);

            JSON_Cleanup(response);
        }

        default:
        {
            printf("[FractionSystem][WARN] Unhandled 't' in packet 46! player=%d, t=%d",
                playerid, type);

            // ������ JSON �����
            new debug_str[1024];
            JSON_Stringify(json, debug_str);
            printf("[FractionSystem][DEBUG] Raw JSON: %s", debug_str);
        }
    }
}
            case 63: // NPC Interaction GUI
        {
            new buttonKey;
            if(JSON_GetInt(json, "bt", buttonKey))
            {
                printf("[DEBUG][63] Player %d pressed button with bk=%d", playerid, buttonKey);
                
                switch(buttonKey)
                {
                    case 1: // ������� ������
                    {
                        printf("[DEBUG][63] Green button pressed: '��, ������!'");
                        SendClientMessage(playerid, -1, "�� �������: '��, ������!'");
                        //ShowNewDialog(playerid, "������� �����!");
                    }
                    
                    case 2: // ����� ������
                    {
                        printf("[DEBUG][63] Gray button pressed: '����� ����...'");
                        SendClientMessage(playerid, -1, "�� �������: '����� ����...'");
                      //  ShowNewDialog(playerid, "�� ������� ���...");
                    }
                    
                    case 3: // ������� ������
                    {
                        printf("[DEBUG][63] Red button pressed: '���, �� ������!'");
                        SendClientMessage(playerid, -1, "�� �������: '���, �� ������!'");
                       // ShowNewDialog(playerid, "�� ��������� �� ����!");
                    }
                    
                    default:
                    {
                        printf("[DEBUG][63][WARN] Unknown buttonKey! player=%d, bk=%d",
                            playerid, buttonKey);
                  //      SendClientMessage(playerid, -1, "����������� ������...");
                    }
                }
                
            }
        }

case 33:
{
    new type;
    JSON_GetInt(json, "t", type);

    new Node:response = JSON_Object();

    new item_type, pos;

    if (type == 19)
    {
        JSON_GetInt(json, "ga", item_type);
        JSON_GetInt(json, "s", pos);
        
        if(item_type == 134) 
        {
            new Node:itArray;
            JSON_GetArray(json, "it", itArray);

            new skin_id = 0;
            new array_length;
            JSON_ArrayLength(itArray, array_length);

            if(array_length > (pos * 4 + 1))
            {
                new Node:skinNode;
                if(JSON_ArrayObject(itArray, pos * 4 + 1, skinNode))
                {
                    JSON_GetNodeInt(skinNode, skin_id);
                }
            }
            
            if(skin_id != 0)
            {
                SetPlayerSkin(playerid, skin_id);
                
                new message[128];
                format(message, sizeof(message), "���� � ID %d �����������!", skin_id);
                SendClientMessage(playerid, -1, message);
                
                printf("[DEBUG] ����� %d ����������� ���� ID: %d (���: %d, ���: %d)", playerid, skin_id, item_type, pos);
                
                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 1);
                JSON_SetInt(response, "ps", skin_id);
            }
            else
            {
                if(pos == 0) skin_id = 122;
                else if(pos == 1) skin_id = 123;
                else if(pos == 2) skin_id = 124;
                
                if(skin_id != 0)
                {
                    SetPlayerSkin(playerid, skin_id);
                    
                    new message[128];
                    format(message, sizeof(message), "���� � ID %d �����������!", skin_id);
                    SendClientMessage(playerid, -1, message);
                    
                    printf("[DEBUG] ����� %d ����������� ���� ID: %d (fallback �����, ���: %d)", playerid, skin_id, pos);
                    
                    JSON_SetInt(response, "t", 19);
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "ps", skin_id);
                }
                else
                {
                    JSON_SetInt(response, "t", 19);
                    JSON_SetInt(response, "s", 0);
                }
            }
        }
        else if(item_type == 22) 
        {
            new hunger = 100;
            hunger = (hunger + 20 > 100) ? 100 : hunger + 20;
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "s", hunger);
        } 
        else if(item_type == 58) 
        {
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
        }
        else
        {
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
        }
    }

    OnPacketIncoming(playerid, 33, response);
    JSON_Cleanup(response);
}

case 113:
{
    new appid;
    JSON_GetInt(json, "a", appid);
    
    switch(appid) 
    {               
        case 13:
        {
            ShowNotificationNew(playerid, 4, 6, 1, 0, "DONATE", "ок");
            OnPacketIncoming(playerid, 113, json);
        }
        case 18:
        {
            ShowNotificationNew(playerid, 4, 6, 0, 0, "Calendar", "ок");
           OnPacketIncoming(playerid, 113, json);
        }
   }
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
    
    JSON_SetInt(response, "m", 1500000);
    
    new Node:yArray = JSON_Array(
        JSON_Int(6),
        JSON_Int(3),
        JSON_Int(1)
    );
    JSON_SetArray(response, "y", yArray);

    OnPacketIncoming(playerid, 45, response);
    JSON_Cleanup(response);
}
case 6:
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 6);
    
    new Node:mArray = JSON_Array();
    
    new fam_sql = GetPlayerFamily(playerid, ID_SQL_FAMILY);
    
    if(fam_sql != -1)
    {
        mysql_format(mysql, f_string64, sizeof f_string64, 
            "SELECT a.ad_text, b.name FROM family_ad a LEFT JOIN accounts b ON a.create_id = b.id WHERE a.family = %d ORDER BY a.id DESC LIMIT 5", 
            fam_sql);
        new Cache:cache = mysql_query(mysql, f_string64);
        
        if(cache_num_rows() > 0)
        {
            new ad_text[128], creator_name[24], combined_text[256];
            
            for(new i = 0; i < cache_num_rows(); i++)
            {
                cache_get_field_content(i, "ad_text", ad_text, mysql, 128);
                cache_get_field_content(i, "name", creator_name, mysql, 24);

                format(combined_text, sizeof(combined_text), "%s [%s]", ad_text, creator_name);
                JSON_Append(mArray, JSON_String(combined_text));
            }
            
            cache_delete(cache);
        }
        else
        {
            JSON_Append(mArray, JSON_String("not ad's"));
        }
    }
    
    JSON_SetArray(response, "m", mArray);
    
    // ��������� xArray ��� ����
    new Node:xArray = JSON_Array(
        JSON_Int(42539),
        JSON_Int(42286),
        JSON_Int(41810),
        JSON_Int(41810),
        JSON_Int(41810)
    );
    JSON_SetArray(response, "x", xArray);
    
    OnPacketIncoming(playerid, 45, response);
    JSON_Cleanup(response);
}
case 7:
{
    new Node:response = JSON_Object();
    
    JSON_SetInt(response, "p", 266);
    JSON_SetInt(response, "tp", 1);
    JSON_SetInt(response, "tr", 5);
    JSON_SetInt(response, "tz", 12);
    JSON_SetInt(response, "t", 7);
    

    new Node:mnArray = JSON_Array(
        JSON_String("{AA0000}HARD"),
        JSON_String("{FF0000}SPARTA "),
        JSON_String("{FF0000}Hollwexx {FFFFFF}Killmachine "),
        JSON_String("{FF0000}VENSKIE {F5F5F5}SQUAD"),
        JSON_String("{00FFFF} Kingdom {FFFF00} Line"),
        JSON_String("{FF69B4}Demonik {FF00FF}Chocolate "),
        JSON_String("{00FFFF}ATAKILLOV {C0C0C0}COMEBACK"),
        JSON_String("Royal_Empire"),
        JSON_String("{FF66FF}DOMINANT {66FFFF}COMEBACK "),
        JSON_String("{00FFFF}Avengersov {808080}Revenge"),
        JSON_String("{FF0000} K O {0000FF} R E {FFFFFF} A"),
        JSON_String("{00ffff}Treepsize {a9a9a9}Squad "),
        JSON_String("{000000}SHTORM {8B0000}REVENGE"),
        JSON_String("{FFFFFF}Mill{0000FF}enni{FF0000}als"),
        JSON_String("kuznetskiy squad")
    );
    JSON_SetArray(response, "mn", mnArray);
    
    // ������ "m" � ������� [8211, 1256, 1, 8014, 104, 1, ...]
    new m_numbers[] = {
        8211, 1256, 1,
        8014, 104, 1,
        3080, 92, 1,
        2425, 55, 1,
        1971, 29, 1,
        1693, 19, 1,
        1505, 62, 1,
        1421, 14, 1,
        1184, 183, 1,
        1155, 28, 1,
        871, 57, 1,
        535, 23, 1,
        493, 34, 1,
        381, 385, 1,
        355, 3, 1
    };
    
    // ������� ������ "m" ����� ����
    new Node:mArray = JSON_Array();
    for(new i = 0; i < sizeof(m_numbers); i++)
    {
        // ���������� JSON_Append ��� ���������� ���������
        mArray = JSON_Append(mArray, JSON_Array(JSON_Int(m_numbers[i])));
    }
    JSON_SetArray(response, "m", mArray);

    OnPacketIncoming(playerid, 45, response);
    JSON_Cleanup(response);
}
case 2:
{
    new status;
    JSON_GetInt(json, "s", status);

    if(status != 1 && status != 2)
    {
        // status == 0 - ��������� ������ �����
        new f = GetPlayerIdFamily(playerid);
        
        // ������� ����� response ������
        new Node:response = JSON_Object();
        JSON_SetInt(response, "t", 2); 
        JSON_SetInt(response, "s", 0); 
        JSON_SetInt(response, "g", 1);    

        if(f != -1)
        {
            // �������� ��� ������ �����
            mysql_format(mysql, f_string64, sizeof f_string64, 
                "SELECT * FROM family_cars WHERE family_owner = %d", 
                GetFamily(f, family_database));
            new Cache:cache = mysql_query(mysql, f_string64);
            
            if(!mysql_errno())
            {
                new rows = cache_num_rows();
                
                if(rows == 0)
                {
                    // ��� ����� - ������ �������
                    JSON_SetArray(response, "id", JSON_Array());
                    JSON_SetArray(response, "n", JSON_Array());
                }
                else
                {
                    // ������� ������������ �������
                    new car_ids[256], car_names[256];
                    new count = 0;
                    
                    for(new i = 0; i < rows && i < 20; i++) // ��������� 20 ��� ������������
                    {
                        new model_id = cache_get_field_content_int(i, "model_id");
                        new car_name[32];
                        format(car_name, sizeof(car_name), "%s", 
                            GetVehicleInfo(model_id - 400, VI_NAME));
                        
                        // ����������� ������
                        if(count == 0)
                        {
                            format(car_ids, sizeof(car_ids), "JSON_Int(%d)", model_id);
                            format(car_names, sizeof(car_names), "JSON_String(\"%s\")", car_name);
                        }
                        else
                        {
                            format(car_ids, sizeof(car_ids), "%s, JSON_Int(%d)", car_ids, model_id);
                            format(car_names, sizeof(car_names), "%s, JSON_String(\"%s\")", car_names, car_name);
                        }
                        count++;
                    }
                    
                    // ������� ������� ������� � ����������� �� ����������
                    new Node:carsArray, Node:namesArray;
                    
                    if(count == 1)
                    {
                        new model_id = cache_get_field_content_int(0, "model_id");
                        new car_name[32];
                        format(car_name, sizeof(car_name), "%s", 
                            GetVehicleInfo(model_id - 400, VI_NAME));
                        
                        carsArray = JSON_Array(JSON_Int(model_id));
                        namesArray = JSON_Array(JSON_String(car_name));
                    }
                    else if(count == 2)
                    {
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new car_name1[32], car_name2[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(JSON_Int(model_id1), JSON_Int(model_id2));
                        namesArray = JSON_Array(JSON_String(car_name1), JSON_String(car_name2));
                    }
                    else if(count == 3)
                    {
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new model_id3 = cache_get_field_content_int(2, "model_id");
                        new car_name1[32], car_name2[32], car_name3[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        format(car_name3, sizeof(car_name3), "%s", GetVehicleInfo(model_id3 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(JSON_Int(model_id1), JSON_Int(model_id2), JSON_Int(model_id3));
                        namesArray = JSON_Array(JSON_String(car_name1), JSON_String(car_name2), JSON_String(car_name3));
                    }
                    else if(count == 4)
                    {
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new model_id3 = cache_get_field_content_int(2, "model_id");
                        new model_id4 = cache_get_field_content_int(3, "model_id");
                        new car_name1[32], car_name2[32], car_name3[32], car_name4[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        format(car_name3, sizeof(car_name3), "%s", GetVehicleInfo(model_id3 - 400, VI_NAME));
                        format(car_name4, sizeof(car_name4), "%s", GetVehicleInfo(model_id4 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(JSON_Int(model_id1), JSON_Int(model_id2), JSON_Int(model_id3), JSON_Int(model_id4));
                        namesArray = JSON_Array(JSON_String(car_name1), JSON_String(car_name2), JSON_String(car_name3), JSON_String(car_name4));
                    }
                    else if(count == 5)
                    {
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new model_id3 = cache_get_field_content_int(2, "model_id");
                        new model_id4 = cache_get_field_content_int(3, "model_id");
                        new model_id5 = cache_get_field_content_int(4, "model_id");
                        new car_name1[32], car_name2[32], car_name3[32], car_name4[32], car_name5[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        format(car_name3, sizeof(car_name3), "%s", GetVehicleInfo(model_id3 - 400, VI_NAME));
                        format(car_name4, sizeof(car_name4), "%s", GetVehicleInfo(model_id4 - 400, VI_NAME));
                        format(car_name5, sizeof(car_name5), "%s", GetVehicleInfo(model_id5 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(
                            JSON_Int(model_id1), JSON_Int(model_id2), JSON_Int(model_id3), 
                            JSON_Int(model_id4), JSON_Int(model_id5)
                        );
                        namesArray = JSON_Array(
                            JSON_String(car_name1), JSON_String(car_name2), JSON_String(car_name3), 
                            JSON_String(car_name4), JSON_String(car_name5)
                        );
                    }
                    else if(count == 6)
                    {
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new model_id3 = cache_get_field_content_int(2, "model_id");
                        new model_id4 = cache_get_field_content_int(3, "model_id");
                        new model_id5 = cache_get_field_content_int(4, "model_id");
                        new model_id6 = cache_get_field_content_int(5, "model_id");
                        new car_name1[32], car_name2[32], car_name3[32], car_name4[32], car_name5[32], car_name6[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        format(car_name3, sizeof(car_name3), "%s", GetVehicleInfo(model_id3 - 400, VI_NAME));
                        format(car_name4, sizeof(car_name4), "%s", GetVehicleInfo(model_id4 - 400, VI_NAME));
                        format(car_name5, sizeof(car_name5), "%s", GetVehicleInfo(model_id5 - 400, VI_NAME));
                        format(car_name6, sizeof(car_name6), "%s", GetVehicleInfo(model_id6 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(
                            JSON_Int(model_id1), JSON_Int(model_id2), JSON_Int(model_id3), 
                            JSON_Int(model_id4), JSON_Int(model_id5), JSON_Int(model_id6)
                        );
                        namesArray = JSON_Array(
                            JSON_String(car_name1), JSON_String(car_name2), JSON_String(car_name3), 
                            JSON_String(car_name4), JSON_String(car_name5), JSON_String(car_name6)
                        );
                    }
                    else
                    {
                        // ��� 7+ ����� ���������� �������������� ������
                        // ������� ������ � ������� 6 ��������
                        new model_id1 = cache_get_field_content_int(0, "model_id");
                        new model_id2 = cache_get_field_content_int(1, "model_id");
                        new model_id3 = cache_get_field_content_int(2, "model_id");
                        new model_id4 = cache_get_field_content_int(3, "model_id");
                        new model_id5 = cache_get_field_content_int(4, "model_id");
                        new model_id6 = cache_get_field_content_int(5, "model_id");
                        new car_name1[32], car_name2[32], car_name3[32], car_name4[32], car_name5[32], car_name6[32];
                        format(car_name1, sizeof(car_name1), "%s", GetVehicleInfo(model_id1 - 400, VI_NAME));
                        format(car_name2, sizeof(car_name2), "%s", GetVehicleInfo(model_id2 - 400, VI_NAME));
                        format(car_name3, sizeof(car_name3), "%s", GetVehicleInfo(model_id3 - 400, VI_NAME));
                        format(car_name4, sizeof(car_name4), "%s", GetVehicleInfo(model_id4 - 400, VI_NAME));
                        format(car_name5, sizeof(car_name5), "%s", GetVehicleInfo(model_id5 - 400, VI_NAME));
                        format(car_name6, sizeof(car_name6), "%s", GetVehicleInfo(model_id6 - 400, VI_NAME));
                        
                        carsArray = JSON_Array(
                            JSON_Int(model_id1), JSON_Int(model_id2), JSON_Int(model_id3), 
                            JSON_Int(model_id4), JSON_Int(model_id5), JSON_Int(model_id6)
                        );
                        namesArray = JSON_Array(
                            JSON_String(car_name1), JSON_String(car_name2), JSON_String(car_name3), 
                            JSON_String(car_name4), JSON_String(car_name5), JSON_String(car_name6)
                        );
                        
                        printf("[INFO] Family has %d cars, showing first 6", rows);
                    }
                    
                    JSON_SetArray(response, "id", carsArray);
                    JSON_SetArray(response, "n", namesArray);
                    JSON_SetInt(response, "tc", rows); // total cars - ����� ���������� �����
                }
            }
            else
            {
                printf("[ERROR] Family cars query failed: %d", mysql_errno());
                JSON_SetArray(response, "id", JSON_Array());
                JSON_SetArray(response, "n", JSON_Array());
            }
            
            if(cache) cache_delete(cache);
        }
        else
        {
            JSON_SetArray(response, "id", JSON_Array());
            JSON_SetArray(response, "n", JSON_Array());
        }
        
        OnPacketIncoming(playerid, 45, response);
        JSON_Cleanup(response);
        return 1;
    }
    else if(status == 1)
    {
        // ��������� ������ ������
        new selectedCar;
        JSON_GetInt(json, "id", selectedCar);

        printf("[FamilySystem] ����� %d ������ ������ %d\n", playerid, selectedCar);

        // ������� ����� response ��� status == 1
        new Node:response = JSON_Object();
        JSON_SetInt(response, "t", 2);
        JSON_SetInt(response, "s", 1); 
        JSON_SetInt(response, "id", selectedCar);
        JSON_SetInt(response, "md", selectedCar);

        OnPacketIncoming(playerid, 45, response);
        JSON_Cleanup(response);
        return 1;
    }
    else if(status == 2)
    {
        // ��������� �������� � �������
        new actionId, carId, access;
        JSON_GetInt(json, "id", actionId);  
        JSON_GetInt(json, "md", carId);      
        
        // ���������� ������ � ����������� �� ����� ������
        new f = GetPlayerIdFamily(playerid);
        if(f != -1)
        {
            // �������� ���� ������ �� ����
            mysql_format(mysql, f_string64, sizeof f_string64, 
                "SELECT rang FROM family_cars WHERE id = %d AND family_owner = %d", 
                carId, GetFamily(f, family_database));
            new Cache:cache = mysql_query(mysql, f_string64);
            
            if(cache_num_rows() > 0)
            {
                new car_rang = cache_get_field_content_int(0, "rang");
                new player_rang = GetPlayerRangFamily(playerid);
                
                // ��������� ������
                if(player_rang >= car_rang || GetPlayerRangFamily(playerid) == 5) // ����� ������ ����� ������
                {
                    access = 1; // ������ ����
                }
                else
                {
                    access = 0; // ��� �������
                }
                new node:response = JSON_Object();
                // ����� ��������� ������ ������ (���������/���������)
                new car_status = GetStatusFamilyCar(carId);
                JSON_SetInt(response, "d", car_status); // ��������� ������ ������ */
            }
            else
            {
                access = 0; // ������ �� �������
            }
            
            if(cache) cache_delete(cache);
        }
        else
        {
            access = 0; // ����� �� � �����
        }

        // ��������� ��������
        switch(actionId)
        {
            case 0: // �������� GPS
            {
                printf("[FamilySystem] ����� %d ������� GPS ������ %d\n", playerid, carId);
                
                // �������� ���������� ������
                mysql_format(mysql, f_string64, sizeof f_string64, 
                    "SELECT pos_x, pos_y, pos_z FROM family_cars WHERE id = %d", carId);
                new Cache:cache = mysql_query(mysql, f_string64);
                
                if(cache_num_rows() > 0)
                {
                    new Float:x = cache_get_field_content_float(0, "pos_x");
                    new Float:y = cache_get_field_content_float(0, "pos_y");
                    new Float:z = cache_get_field_content_float(0, "pos_z");
                    
                    // ���������� GPS ��� ������
                    EnablePlayerGPS(playerid, x, y, z, "�������������� ��������� ����������");
                }
                
                if(cache) cache_delete(cache);
            }
            case 1: // ��������� ������ � ����
            {
                printf("[FamilySystem] ����� %d ��������� ������ %d\n", playerid, carId);
                
                if(access)
                {
                    // ���������, �� ��������� �� ��� ������
                    if(!GetStatusFamilyCar(carId))
                    {
                        if(LoadFamilyCar(carId))
                        {
                            // ������� ���������
                            format(f_string144, sizeof f_string144,"%s �������� �������� ���������.",
                                GetPlayerNameEx(playerid));
                            SendFamilyMessage(f, f_string144);
                            SendFamilyLog(type_log_car, playerid, -1, f_string144);
                        }
                    }
                }
            }
            case 2: // ��������� ������ �� ����
            {
                printf("[FamilySystem] ����� %d ��������� ������ %d\n", playerid, carId);
                
                if(access)
                {
                    // ���������, ��������� �� ������
                    if(GetStatusFamilyCar(carId))
                    {
                        new vehicleid = GetVehicleFamilyCar(carId);
                        
                        // ���������, �� ��������� �� ���-�� � ������
                        if(GetVehicleDriver(vehicleid) != INVALID_PLAYER_ID && GetPlayerRangFamily(playerid) != 5)
                        {
                            printf("[FamilySystem] ������ %d ������, ������ ���������\n", carId);
                            access = 2; // ������ ������
                        }
                        else if(UnLoadFamilyCar(carId))
                        {
                            // ������� ���������
                            format(f_string144, sizeof f_string144, "%s �������� �������� ���������.",
                                GetPlayerNameEx(playerid));
                            SendFamilyMessage(f, f_string144);
                            SendFamilyLog(type_log_car, playerid, -1, f_string144);
                        }
                    }
                }
            }
            case 4: // ������� ������ (������ ��� ������)
            {
                printf("[FamilySystem] ����� %d ������� ������ %d\n", playerid, carId);
                
                if(GetPlayerRangFamily(playerid) == 5) // ������ �����
                {
                    // TODO: ����������� �������� ������ �� ����
                }
                else
                {
                    access = 0; // ��� ����
                }
            }
            case 5: // �������� ���� ������� � ������
            {
                printf("[FamilySystem] ����� %d �������� ���� ������� ������ %d\n", playerid, carId);
                
                if(GetPlayerRangFamily(playerid) == 5) // ������ �����
                {
                    // TODO: ������� ������ ��� ��������� �����
                }
                else
                {
                    access = 0; // ��� ����
                }
            }
            case 7: // �������� ����� ������
            {
                printf("[FamilySystem] ����� %d �������� ����� ������ %d\n", playerid, carId);
                
                if(GetPlayerRangFamily(playerid) == 5) // ������ �����
                {
                    // TODO: ������� ������ ��� ��������� ������
                }
                else
                {
                    access = 0; // ��� ����
                }
            }
            default:
                printf("[FamilySystem] ����� %d �������� ����������� �������� %d ��� ������ %d\n", 
                    playerid, actionId, carId);
        }

        // ������� response ��� status == 2
        new Node:response = JSON_Object();
        JSON_SetInt(response, "t", 2);
        JSON_SetInt(response, "s", 2);  
        JSON_SetInt(response, "id", actionId);
        JSON_SetInt(response, "d", 1); 
        JSON_SetInt(response, "r", 4);  

        OnPacketIncoming(playerid, 45, response);
        JSON_Cleanup(response);
        return 1;
    }
}

        case 5:
        {
            new f = GetPlayerIdFamily(playerid);
            
            if(f != -1 && GetFamily(f, family_database) != -1)
            {
                new Node:response = JSON_Object();

                JSON_SetInt(response, "t", 5);
                JSON_SetInt(response, "id", 0);
                JSON_SetInt(response, "r", GetFamily(f, family_reputation));
                JSON_SetInt(response, "am", GetFamily(f, family_count_people));
                JSON_SetInt(response, "s", GetPlayerSkinEx(playerid));

                // ������ ���������
                new Node:ugArray = JSON_Array();
                ugArray = JSON_Append(ugArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_lvl_storage)), 
                    JSON_Int(7)
                ));
                ugArray = JSON_Append(ugArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_lvl_weapon)), 
                    JSON_Int(7)
                ));
                ugArray = JSON_Append(ugArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_lvl_compound)), 
                    JSON_Int(7)
                ));
                JSON_SetArray(response, "ug", ugArray);

                // ������ ����� - ��������� �������
                new storage_level = GetFamily(f, family_lvl_storage);
                new weapon_level = GetFamily(f, family_lvl_weapon);
                
                new Node:myArray = JSON_Array();
                myArray = JSON_Append(myArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_money)), 
                    JSON_Int((storage_level > 0 && storage_level <= 7) ? count_money_level[storage_level-1] : 0)
                ));
                JSON_SetArray(response, "my", myArray);

                // ��������� �����
                new Node:msArray = JSON_Array();
                msArray = JSON_Append(msArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_material)), 
                    JSON_Int((storage_level > 0 && storage_level <= 7) ? count_material_level[storage_level-1] : 0)
                ));
                JSON_SetArray(response, "ms", msArray);

                // ����� �����
                new Node:mkArray = JSON_Array();
                mkArray = JSON_Append(mkArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_mask)), 
                    JSON_Int((storage_level > 0 && storage_level <= 7) ? count_mask_level[storage_level-1] : 0)
                ));
                JSON_SetArray(response, "mk", mkArray);

                // �������� ������� (���������� ������� ��� ������)
                new Node:kbArray = JSON_Array();
                kbArray = JSON_Append(kbArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_heath_kit)), 
                    JSON_Int((storage_level > 0 && storage_level <= 7) ? count_heath_kit_level[storage_level-1] : 0)
                ));
                JSON_SetArray(response, "kb", kbArray);

                // �����������
                new Node:btArray = JSON_Array();
                btArray = JSON_Append(btArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_armour)), 
                    JSON_Int((storage_level > 0 && storage_level <= 7) ? count_armour_level[storage_level-1] : 0)
                ));
                JSON_SetArray(response, "bt", btArray);

                // �������
                new Node:pnArray = JSON_Array();
                pnArray = JSON_Append(pnArray, JSON_Array(
                    JSON_Int(GetFamily(f, family_patron)), 
                    JSON_Int((weapon_level > 0 && weapon_level <= 7) ? count_patron_level[weapon_level-1] : 0)
                ));
                JSON_SetArray(response, "pn", pnArray);

                OnPacketIncoming(playerid, 45, response);
                JSON_Cleanup(response);
            }
            else
            {
                // ���� ����� �� � �����, ���������� ������ ��� ������ �����
                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 5);
                JSON_SetInt(response, "id", -1); // -1 �������� ��� �����
                OnPacketIncoming(playerid, 45, response);
                JSON_Cleanup(response);
            }
        }
        
        // ������ case...
    }
}
    
case 40:
{
    new Node:out = JSON_Object();

    new type; // ������, �������� ����� ������ �� JSON ��� ���� �������������
    JSON_GetInt(json, "t", type);
    switch (type)
    {
        case 1:
        {
            // �������� �������� � �� / ���������
            SetHospitalSpawn(playerid);
        }
    }

    OnPacketIncoming(playerid, 40, out);
    JSON_Cleanup(out);
}

        case 1:
{
    new Node:out = JSON_Object();
    new type, country;
    new plate_text[32], region[8];
    
    JSON_GetInt(json, "t", type);
    
    switch(type) {
        case 0: {
            new Node:cena_out = JSON_Object();
            JSON_SetInt(cena_out, "t", 0);
            JSON_SetInt(cena_out, "p", 5000);
            JSON_SetInt(cena_out, "pr", 2000);
            OnPacketIncoming(playerid, 1, cena_out);
            JSON_Cleanup(cena_out);
        }
        
        case 1: { // ����� ������
            JSON_GetInt(json, "c", country);
            
            // ��������� ������ ��� ������
            switch(country) {
                case 0: { // ������: A123BC
                    new chars_ru[] = "abcehkmopxty";
                    plate_text[0] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[5] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[6] = EOS;
                    region = "77"; // ������
                }
                case 1: { // �������: AA 1234 OO
                    new chars_ua[] = "ABCEHKMOPXTY";
                    plate_text[0] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[1] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[2] = ' ';
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = '0' + random(10);
                    plate_text[5] = '0' + random(10);
                    plate_text[6] = '0' + random(10);
                    plate_text[7] = ' ';
                    plate_text[8] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[9] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[10] = EOS;
                    region = "tt";
                }
                case 2: { // ��������: 1234 AB-1
                    plate_text[0] = '0' + random(10);
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = ' ';
                    new chars_by[] = "ABCEHKMOPXTY";
                    plate_text[5] = chars_by[random(sizeof(chars_by)-1)];
                    plate_text[6] = chars_by[random(sizeof(chars_by)-1)];
                    plate_text[7] = '-';
                    plate_text[8] = '0' + random(10);
                    plate_text[9] = EOS;
                    region = "tt";
                }
                case 3: { // ���������: 123ABC
                    plate_text[0] = '0' + random(10);
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    new chars_kz[] = "ABCEHKMOPXTY";
                    plate_text[3] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[4] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[5] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[6] = EOS;
                    region = "02"; // ������
                }
            }
            
            JSON_SetInt(out, "t", 2);
            JSON_SetString(out, "p", plate_text);
            JSON_SetString(out, "r", region);
        }
        
        case 2: { // ���������� ������
            JSON_GetInt(json, "c", country);
            
            if(GetPlayerMoney(playerid) < 10000) {
                JSON_SetInt(out, "t", 1);
                JSON_SetString(out, "h", "������������ ����� ��� ����������!");
                OnPacketIncoming(playerid, 1, out);
                JSON_Cleanup(out);
                return 1;
            }
            
            GivePlayerMoney(playerid, -10000);
            
            // ��������� ������ ������
            switch(country) {
                case 0: {
                    new chars_ru[] = "abcehkmopxty";
                    plate_text[0] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[5] = chars_ru[random(sizeof(chars_ru)-1)];
                    plate_text[6] = EOS;
                    region = "77";
                }
                case 1: {
                    new chars_ua[] = "ABCEHKMOPXTY";
                    plate_text[0] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[1] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[2] = ' ';
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = '0' + random(10);
                    plate_text[5] = '0' + random(10);
                    plate_text[6] = '0' + random(10);
                    plate_text[7] = ' ';
                    plate_text[8] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[9] = chars_ua[random(sizeof(chars_ua)-1)];
                    plate_text[10] = EOS;
                    region = "tt";
                }
                case 2: {
                    plate_text[0] = '0' + random(10);
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    plate_text[3] = '0' + random(10);
                    plate_text[4] = ' ';
                    new chars_by[] = "ABCEHKMOPXTY";
                    plate_text[5] = chars_by[random(sizeof(chars_by)-1)];
                    plate_text[6] = chars_by[random(sizeof(chars_by)-1)];
                    plate_text[7] = '-';
                    plate_text[8] = '0' + random(10);
                    plate_text[9] = EOS;
                    region = "tt";
                }
                case 3: {
                    plate_text[0] = '0' + random(10);
                    plate_text[1] = '0' + random(10);
                    plate_text[2] = '0' + random(10);
                    new chars_kz[] = "ABCEHKMOPXTY";
                    plate_text[3] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[4] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[5] = chars_kz[random(sizeof(chars_kz)-1)];
                    plate_text[6] = EOS;
                    region = "02";
                }
            }
            
            JSON_SetInt(out, "t", 2);
            JSON_SetString(out, "p", plate_text);
            JSON_SetString(out, "r", region);
        }
        
        case 3: { // ������� ������
            JSON_GetString(json, "p", plate_text);
            JSON_GetString(json, "r", region);
            JSON_GetInt(json, "c", country);
            
            if(GetPlayerMoney(playerid) < 50000) {
                JSON_SetInt(out, "t", 1);
                JSON_SetString(out, "h", "������������ ����� ��� �������!");
                OnPacketIncoming(playerid, 1, out);
                JSON_Cleanup(out);
                return 1;
            }
            
            GivePlayerMoney(playerid, -50000);
            
            // ����� ������ ���� ������ ���������� � ��
            new query[256];
            mysql_format(mysql, query, sizeof(query),
                "INSERT INTO player_plates (player_id, country, plate_text, region, purchase_date) VALUES (%d, %d, '%e', '%e', %d)",
                GetPlayerAccountID(playerid), country, plate_text, region, gettime());
            mysql_query(mysql, query, false);
            
            JSON_SetInt(out, "t", 1);
            JSON_SetString(out, "h", "����� ������� ������!");
        }
        
        case 4: { // ��������� ������
            JSON_GetString(json, "p", plate_text);
            JSON_GetString(json, "r", region);
            JSON_GetInt(json, "c", country);
            
            // �������� ������� ������
            new valid = 1;
            switch(country) {
                case 0: valid = (strlen(plate_text) == 6 && !IsCharNumeric(plate_text[0]) && IsCharNumeric(plate_text[1]) && IsCharNumeric(plate_text[2]) && IsCharNumeric(plate_text[3]) && !IsCharNumeric(plate_text[4]) && !IsCharNumeric(plate_text[5]));
                case 1: valid = (strlen(plate_text) == 10 && !IsCharNumeric(plate_text[0]) && !IsCharNumeric(plate_text[1]) && plate_text[2] == ' ' && IsCharNumeric(plate_text[3]) && IsCharNumeric(plate_text[4]) && IsCharNumeric(plate_text[5]) && IsCharNumeric(plate_text[6]) && plate_text[7] == ' ' && !IsCharNumeric(plate_text[8]) && !IsCharNumeric(plate_text[9]));
                case 2: valid = (strlen(plate_text) == 9 && IsCharNumeric(plate_text[0]) && IsCharNumeric(plate_text[1]) && IsCharNumeric(plate_text[2]) && IsCharNumeric(plate_text[3]) && plate_text[4] == ' ' && !IsCharNumeric(plate_text[5]) && !IsCharNumeric(plate_text[6]) && plate_text[7] == '-' && IsCharNumeric(plate_text[8]));
                case 3: valid = (strlen(plate_text) == 6 && IsCharNumeric(plate_text[0]) && IsCharNumeric(plate_text[1]) && IsCharNumeric(plate_text[2]) && !IsCharNumeric(plate_text[3]) && !IsCharNumeric(plate_text[4]) && !IsCharNumeric(plate_text[5]));
            }
            
            if(!valid) {
                JSON_SetInt(out, "t", 1);
                JSON_SetString(out, "h", "�������� ������ ������!");
            } else {
                JSON_SetInt(out, "t", 1);
                JSON_SetString(out, "h", "����� ��������!");
            }
        }
    }
    
    OnPacketIncoming(playerid, 1, out);
    JSON_Cleanup(out);
}
       case 3:
        {
            new Node:out = JSON_Object();

            new type;
            JSON_GetInt(json, "t", type);

            if (type == 0)
            {
                JSON_SetInt(out, "t", 0);
            }
            else if (type == 1) 
            {
                new order;
                JSON_GetInt(json, "r", order);

                new totalPrice = 500;
                new satiety = 0;

                new eatsPrice[6]   = {120, 230, 350, 580, 80, 30};
                new eatsSatiety[6] = {5,   10,  15,  20,  3,  2};

                for (new i = 0; i < 6; i++)
                {
                    if (order & (1 << i))
                    {
                        totalPrice += eatsPrice[i];
                        satiety    += eatsSatiety[i];
                    }
                }

                if (GetPlayerMoney(playerid) >= totalPrice)
                {
                    GivePlayerMoney(playerid, -totalPrice);
                    new Float:currentHealth = GetPlayerHealth(playerid);
                    new Float:newHealth = currentHealth + float(satiety);
                    
                    if(newHealth > 100.0) newHealth = 100.0;
                    
                    SetPlayerHealth(playerid, newHealth);

                    JSON_SetInt(out, "t", 1);
                    JSON_SetInt(out, "s", 1);
                    JSON_SetInt(out, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    JSON_SetInt(out, "t", 1);
                    JSON_SetInt(out, "s", 0);
                }
            }

            OnPacketIncoming(playerid, 3, out);
            JSON_Cleanup(out);
        }
        case 28:
        {
            new Node:json_packet_data = JSON_Object();
            new outcoming_data[512];

            new type, detal_id;
            new vinyl[64];

            JSON_GetInt(json, "t", type);
            JSON_GetInt(json, "d", detal_id);
            JSON_GetString(json, "v", vinyl, sizeof(vinyl));

            new vehicleid = GetPlayerVehicleID(playerid);
            new index = INVALID_VEHICLE_ID;
            if(IsValidVehicle(vehicleid)) index = GetVehicleData(vehicleid, V_ACTION_ID);

            switch(type)
            {
                case 0:
                {
                    new Float:x, Float:y, Float:z, Float:a;

                    if(player_gui_type[playerid] == GUI_TECHCENTER)
                    {
                        x = -413.339;
                        y = 1027.331;
                        z = 11.235;
                        a = 1.000;
                    }
                    else
                    {
                        x = 2296.146240;
                        y = -2613.668457;
                        z = 21.829063;
                        a = 0.0;
                    }

                    SetPlayerVirtualWorld(playerid, 0);
                    SetPlayerInterior(playerid, 0);

                    if(IsValidVehicle(vehicleid))
                    {
                        SetVehicleVirtualWorld(vehicleid, 0);
                        SetVehiclePos(vehicleid, x, y, z);
                        SetVehicleZAngle(vehicleid, a);
                    }
                    else
                    {
                        SetPlayerPos(playerid, x, y, z);
                        SetPlayerFacingAngle(playerid, a);
                    }

                    TogglePlayerControllable(playerid, true);
                    SetCameraBehindPlayer(playerid);
                    player_gui_type[playerid] = GUI_NONE;

                    JSON_SetInt(json_packet_data, "t", 0);
                    JSON_SetInt(json_packet_data, "s", 1);
                }
                case 1:
                {
                    JSON_SetInt(json_packet_data, "t", 1);
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(json_packet_data, "s", 1);
                }
                case 3:
                {
                    JSON_SetInt(json_packet_data, "t", 3);
                    JSON_SetInt(json_packet_data, "d", detal_id);
                    JSON_SetInt(json_packet_data, "p", detal_id);

                    if(!IsValidVehicle(vehicleid) || index == INVALID_VEHICLE_ID)
                    {
                        JSON_SetInt(json_packet_data, "s", 0);
                    }
                    else if(GetPlayerMoneyEx(playerid) < 50000)
                    {
                        JSON_SetInt(json_packet_data, "s", 0);
                    }
                    else
                    {
                        new textureName[64];
                        format(textureName, sizeof(textureName), "%s", vinyl);

                        if(textureName[0] == EOS)
                        {
                            JSON_SetInt(json_packet_data, "s", 0);
                        }
                        else
                        {
                            GivePlayerMoneyEx(playerid, -50000);
                            SetVehicleVinyl(vehicleid, textureName);
                            format(g_ownable_car[index][OC_VINYL], 64, "%s", textureName);

                            new query[256];
                            mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET vinyl='%e' WHERE id='%d'", textureName, GetOwnableCarData(index, OC_SQL_ID));
                            mysql_query(mysql, query);

                            JSON_SetString(json_packet_data, "v", textureName);
                            JSON_SetInt(json_packet_data, "s", 1);
                        }
                    }
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                }
                case 7:
                {
                    JSON_SetInt(json_packet_data, "t", 7);
                    JSON_SetInt(json_packet_data, "p", detal_id);

                    if(!IsValidVehicle(vehicleid) || index == INVALID_VEHICLE_ID)
                    {
                        JSON_SetInt(json_packet_data, "s", 0);
                    }
                    else
                    {
                        new bool:ok = false;
                        new model = GetVehicleModel(vehicleid);
                        new car_price = (model >= 400 && model <= 611) ? GetVehicleInfo(model - 400, VI_PRICE) : 0;

                        switch(detal_id)
                        {
                            case 0, 1, 2:
                            {
                                new price = GetNitroPrice(car_price, detal_id);
                                if(GetPlayerMoneyEx(playerid) >= price)
                                {
                                    GivePlayerMoneyEx(playerid, -price);
                                    switch(detal_id)
                                    {
                                        case 0: { AddVehicleComponent(vehicleid, 1009); SetOwnableCarData(index, OC_NITRO, 20); }
                                        case 1: { AddVehicleComponent(vehicleid, 1008); SetOwnableCarData(index, OC_NITRO, 50); }
                                        case 2: { AddVehicleComponent(vehicleid, 1010); SetOwnableCarData(index, OC_NITRO, 100); }
                                    }
                                    SaveOwnableCarNitro(index);
                                    ok = true;
                                }
                            }
                            case 4, 9, 14, 19, 24,
                                 5, 10, 15, 20, 25,
                                 6, 11, 16, 21, 26,
                                 7, 12, 17, 22, 27:
                            {
                                new tune_type = GetTuningTypeByCase(detal_id);
                                if(tune_type != -1)
                                {
                                    new price = GetTuningPrice(car_price, tune_type);
                                    if((tune_type == TUNING_SPORT_PL && GetPlayerDonateRub(playerid) >= price) ||
                                       (tune_type != TUNING_SPORT_PL && GetPlayerMoneyEx(playerid) >= price))
                                    {
                                        if(tune_type == TUNING_SPORT_PL) GivePlayerDonateRub(playerid, -price, "������", true);
                                        else GivePlayerMoneyEx(playerid, -price);

                                        BuyPart(vehicleid, detal_id, tune_type);
                                        switch(tune_type)
                                        {
                                            case TUNING_COMFORT: SetOwnableCarData(index, OC_COMFORT_PL, detal_id);
                                            case TUNING_SPORT: SetOwnableCarData(index, OC_SPORT, detal_id);
                                            case TUNING_SPORT_PL: SetOwnableCarData(index, OC_SPORT_PL, detal_id);
                                            case TUNING_DRIFT: SetOwnableCarData(index, OC_DRIFT, detal_id);
                                        }
                                        SaveOwnableCarFirmware(index);
                                        ok = true;
                                    }
                                }
                            }
                            case 28, 29, 30, 31, 32:
                            {
                                if(GetPlayerMoneyEx(playerid) >= 50000)
                                {
                                    new strob_type = detal_id - 28;
                                    GivePlayerMoneyEx(playerid, -50000);
                                    SetVehicleStroboscope(vehicleid, strob_type, 1);

                                    new query[128];
                                    mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET strob='%d', enable_strob='1' WHERE id='%d'", strob_type, GetOwnableCarData(index, OC_SQL_ID));
                                    mysql_query(mysql, query);
                                    ok = true;
                                }
                            }
                            case 130:
                            {
                                if(GetPlayerMoneyEx(playerid) >= 50000)
                                {
                                    GivePlayerMoneyEx(playerid, -50000);
                                    new query[128];
                                    mysql_format(mysql, query, sizeof(query), "UPDATE ownable_cars SET high_lights='1', enable_high_lights='1' WHERE id='%d'", GetOwnableCarData(index, OC_SQL_ID));
                                    mysql_query(mysql, query);
                                    ok = true;
                                }
                            }
                            case 299: ok = true;
                        }

                        JSON_SetInt(json_packet_data, "s", ok ? 1 : 0);
                    }

                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                }
                case 26:
                {
                    JSON_SetInt(json_packet_data, "t", 26);
                    JSON_SetString(json_packet_data, "v", vinyl);
                    JSON_SetInt(json_packet_data, "s", 1);
                }
                default:
                {
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 0);
                }
            }

            new packet_status = 0;
            JSON_GetInt(json_packet_data, "s", packet_status);
            if(packet_status == 0 && type != 26)
            {
                SendClientMessage(playerid, 0xCECECEFF, "������������ ������� ��� �������� ����������!");
            }

            JSON_Stringify(json_packet_data, outcoming_data);
            OnPacketIncoming(playerid, 28, json_packet_data);
            JSON_Cleanup(json_packet_data);
        }

        case 13:
        {
            new t, sub_id, id;
            JSON_GetInt(json, "t", t);
            JSON_GetInt(json, "s", id);
            JSON_GetInt(json, "b", sub_id);

            switch (t)
            {
                case 0: // ??????? ?? ??????
                {
                    switch (id)
                    {
                        case 1: return 1;
                        case notifcmdyes: callcmd::yes(playerid, "");
                        case notifcmde: callcmd::e(playerid, "");
                        case vodolaz: callcmd::interact_vodo(playerid, "");
                        case notifcmdpost: callcmd::posteeenujno(playerid, "");
                        case notifcmdopendoor: callcmd::opendoor(playerid, "");
                        case notifcmdcont:
                        {
                            callcmd::cont(playerid);
                        }
                        case notifcmdsanich:
                        {
                            callcmd::sanich(playerid);
                        }
                        case notifcmdelectricarenda:
                        {
                            callcmd::electricarenda(playerid);
                        }
                        case notifcmdelectricstartordergame:
                        {
                            callcmd::electricstartordergame(playerid);
                        }
                        case notifycmdarmykpp:
                        {
                            new team = GetPlayerTeamEx(playerid);
                            new rank = GetPlayerJob(playerid);

                            if (!IsWorkDayStarted(playerid)) return 1;

                            if ((team == TEAM_ARMY && rank >= 3) || (team >= 9 && team <= 11 && rank >= 6))
                            {
                                callcmd::kpp(playerid, "");
                            }
                            else
                            {
                                SendClientMessage(playerid, COLOR_GREY, "??? ?????????? ?????? ????????.");
                            }
                            return 1;
                        }
                    case LAREK: // ARZ
                    {
                     //   callcmd::lareklarekovichezz(playerid);
                    }
                        case notifcmdkamerzek: callcmd::tptocamerafsin(playerid, "");
                        case notifcmdkarcerfsin: callcmd::tptokarcerfsin(playerid, "");
                    }
                    return 1;
                }

                case 1: // ???????? ???????????
                {
                    switch (id)
                    {
                        case 1: return 1;
                        case 99: SCM(playerid, 0xFFAAAAAA, "??????????? ID 99 ???????");
                    }
                    return 1;
                }
            }
        }
        case 14:
        {
            new t, i;

            JSON_GetInt(json, "t", t);
            JSON_GetInt(json, "i", i);

            switch(t)
            {
                case 0:
                {
                    callcmd::gps(playerid, "");
                }

                case 1:
                {

                }

                case 2:
                {
                    callcmd::mm(playerid, "");
                }

                case 3:
                {

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
                    callcmd::report(playerid);
                }
            }

            new Node:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);

            new outcoming_data[256];
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 14, json_packet_data);

            JSON_Cleanup(json_packet_data);
        }
case 22:
        {
            new type;
            JSON_GetInt(json, "t", type);
			
			new ty;
			JSON_GetInt(json, "ty", ty);

			new latype;
			JSON_GetInt(json, "la", latype);

            switch(type)
            {
				case -1:
				{			
					switch(ty)
					{
                                case -1: // ������� BLACK PASS
								{
									printf("DONATE: la[case 10234]");
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", 0);
									JSON_SetInt(json, "la", 1);
									JSON_SetInt(json, "lv", 16);
									JSON_SetInt(json, "ec", 500);
									
									new tk1 = JSON_Object();
									JSON_SetInt(tk1, "id", 1);
									JSON_SetInt(tk1, "p", 0);
									JSON_SetInt(tk1, "s", 4);

									new tk2 = JSON_Object();
									JSON_SetInt(tk2, "id", 6);
									JSON_SetInt(tk2, "p", 1);
									JSON_SetInt(tk2, "s", 6);

									new tk3 = JSON_Object();
									JSON_SetInt(tk3, "id", 7);
									JSON_SetInt(tk3, "p", 0);
									JSON_SetInt(tk3, "s", 2);

									new tk4 = JSON_Object();
									JSON_SetInt(tk4, "id", 8);
									JSON_SetInt(tk4, "p", 0);
									JSON_SetInt(tk4, "s", 4);

									new tk5 = JSON_Object();
									JSON_SetInt(tk5, "id", 56);
									JSON_SetInt(tk5, "p", 0);
									JSON_SetInt(tk5, "s", 2);

									new tk6 = JSON_Object();
									JSON_SetInt(tk6, "id", 97);
									JSON_SetInt(tk6, "p", 0);
									JSON_SetInt(tk6, "s", 2);

									new tk7 = JSON_Object();
									JSON_SetInt(tk7, "id", 99);
									JSON_SetInt(tk7, "p", 0);
									JSON_SetInt(tk7, "s", 4);

									new tk8 = JSON_Object();
									JSON_SetInt(tk8, "id", 100);
									JSON_SetInt(tk8, "p", 0);
									JSON_SetInt(tk8, "s", 4);

									new tk9 = JSON_Object();
									JSON_SetInt(tk9, "id", 104);
									JSON_SetInt(tk9, "p", 0);
									JSON_SetInt(tk9, "s", 2);

									new tk10 = JSON_Object();
									JSON_SetInt(tk10, "id", 143);
									JSON_SetInt(tk10, "p", 0);
									JSON_SetInt(tk10, "s", 4);

									new tk11 = JSON_Object();
									JSON_SetInt(tk11, "id", 148);
									JSON_SetInt(tk11, "p", 0);
									JSON_SetInt(tk11, "s", 4);

									new tk12 = JSON_Object();
									JSON_SetInt(tk12, "id", 158);
									JSON_SetInt(tk12, "p", 0);
									JSON_SetInt(tk12, "s", 4);

									new tk13 = JSON_Object();
									JSON_SetInt(tk13, "id", 251);
									JSON_SetInt(tk13, "p", 0);
									JSON_SetInt(tk13, "s", 4);

									new tk14 = JSON_Object();
									JSON_SetInt(tk14, "id", 254);
									JSON_SetInt(tk14, "p", 1);
									JSON_SetInt(tk14, "s", 6);

									new tk15 = JSON_Object();
									JSON_SetInt(tk15, "id", 255);
									JSON_SetInt(tk15, "p", 1);
									JSON_SetInt(tk15, "s", 4);

									new tk16 = JSON_Object();
									JSON_SetInt(tk16, "id", 256);
									JSON_SetInt(tk16, "p", 0);
									JSON_SetInt(tk16, "s", 2);

									new tk17 = JSON_Object();
									JSON_SetInt(tk17, "id", 257);
									JSON_SetInt(tk17, "p", 0);
									JSON_SetInt(tk17, "s", 2);

									// �������� ��� ������� � ������
									new Node:tkArray = JSON_Array(tk1, tk2, tk3, tk4, tk5, tk6, tk7, tk8, tk9, tk10, tk11, tk12, tk13, tk14, tk15, tk16, tk17);
									JSON_SetArray(json, "tk", tkArray);
									
									JSON_SetInt(json, "tm", 151833);
									
									OnPacketIncoming(playerid, 22, json);
								}
						case 0:
						{
							switch(latype)
							{
								case 0: // �������� ���� BLACK PASS
								{
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", -1);
									JSON_SetInt(json, "la", 0);
									JSON_SetInt(json, "a", 0);
									JSON_SetString(json, "sn", "����� ��������"); // �������� BLACK PASS
									JSON_SetString(json, "ln", "Flash_Flash"); // ��� ������ BLACK PASS
									JSON_SetInt(json, "lv", 16); // ������� BLACK PASS
									JSON_SetInt(json, "td", 840360); // �� ����� ������
									JSON_SetInt(json, "ec", 200); // �������� ������
									JSON_SetInt(json, "sp", 0);
									JSON_SetInt(json, "is", 0);
											
									OnPacketIncoming(playerid, 22, json);
								}
								case 1: // ������� BLACK PASS
								{
									printf("DONATE: la[case 1]");
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", 0);
									JSON_SetInt(json, "la", 1);
									JSON_SetInt(json, "lv", 16);
									JSON_SetInt(json, "ec", 500);
									
									new tk1 = JSON_Object();
									JSON_SetInt(tk1, "id", 1);
									JSON_SetInt(tk1, "p", 0);
									JSON_SetInt(tk1, "s", 4);

									new tk2 = JSON_Object();
									JSON_SetInt(tk2, "id", 6);
									JSON_SetInt(tk2, "p", 1);
									JSON_SetInt(tk2, "s", 6);

									new tk3 = JSON_Object();
									JSON_SetInt(tk3, "id", 7);
									JSON_SetInt(tk3, "p", 0);
									JSON_SetInt(tk3, "s", 2);

									new tk4 = JSON_Object();
									JSON_SetInt(tk4, "id", 8);
									JSON_SetInt(tk4, "p", 0);
									JSON_SetInt(tk4, "s", 4);

									new tk5 = JSON_Object();
									JSON_SetInt(tk5, "id", 56);
									JSON_SetInt(tk5, "p", 0);
									JSON_SetInt(tk5, "s", 2);

									new tk6 = JSON_Object();
									JSON_SetInt(tk6, "id", 97);
									JSON_SetInt(tk6, "p", 0);
									JSON_SetInt(tk6, "s", 2);

									new tk7 = JSON_Object();
									JSON_SetInt(tk7, "id", 99);
									JSON_SetInt(tk7, "p", 0);
									JSON_SetInt(tk7, "s", 4);

									new tk8 = JSON_Object();
									JSON_SetInt(tk8, "id", 100);
									JSON_SetInt(tk8, "p", 0);
									JSON_SetInt(tk8, "s", 4);

									new tk9 = JSON_Object();
									JSON_SetInt(tk9, "id", 104);
									JSON_SetInt(tk9, "p", 0);
									JSON_SetInt(tk9, "s", 2);

									new tk10 = JSON_Object();
									JSON_SetInt(tk10, "id", 143);
									JSON_SetInt(tk10, "p", 0);
									JSON_SetInt(tk10, "s", 4);

									new tk11 = JSON_Object();
									JSON_SetInt(tk11, "id", 148);
									JSON_SetInt(tk11, "p", 0);
									JSON_SetInt(tk11, "s", 4);

									new tk12 = JSON_Object();
									JSON_SetInt(tk12, "id", 158);
									JSON_SetInt(tk12, "p", 0);
									JSON_SetInt(tk12, "s", 4);

									new tk13 = JSON_Object();
									JSON_SetInt(tk13, "id", 251);
									JSON_SetInt(tk13, "p", 0);
									JSON_SetInt(tk13, "s", 4);

									new tk14 = JSON_Object();
									JSON_SetInt(tk14, "id", 254);
									JSON_SetInt(tk14, "p", 1);
									JSON_SetInt(tk14, "s", 6);

									new tk15 = JSON_Object();
									JSON_SetInt(tk15, "id", 255);
									JSON_SetInt(tk15, "p", 1);
									JSON_SetInt(tk15, "s", 4);

									new tk16 = JSON_Object();
									JSON_SetInt(tk16, "id", 256);
									JSON_SetInt(tk16, "p", 0);
									JSON_SetInt(tk16, "s", 2);

									new tk17 = JSON_Object();
									JSON_SetInt(tk17, "id", 257);
									JSON_SetInt(tk17, "p", 0);
									JSON_SetInt(tk17, "s", 2);

									// �������� ��� ������� � ������
									new Node:tkArray = JSON_Array(tk1, tk2, tk3, tk4, tk5, tk6, tk7, tk8, tk9, tk10, tk11, tk12, tk13, tk14, tk15, tk16, tk17);
									JSON_SetArray(json, "tk", tkArray);
									
									JSON_SetInt(json, "tm", 151833);
									
									OnPacketIncoming(playerid, 22, json);
								}
								case 2:
								{
									printf("DONATE: la[case 2]");
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", 0);
									JSON_SetInt(json, "la", 2);
									
									OnPacketIncoming(playerid, 22, json);
								}
								case 3: // ������ �������
								{
									printf("DONATE: la[case 3] btn: �������");
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", 0);
									JSON_SetInt(json, "la", 3);
									
									new marathonPlayer = JSON_Object();
									JSON_SetString(marathonPlayer, "n", "Didar_Didar");
									JSON_SetInt(marathonPlayer, "och", 112200);
									
									new marathonPlayer1 = JSON_Object();
									JSON_SetString(marathonPlayer1, "n", "Didar_Coder");
									JSON_SetInt(marathonPlayer1, "och", 10000);
									
									new marathonPlayer2 = JSON_Object();
									JSON_SetString(marathonPlayer2, "n", "Kranin_Studio");
									JSON_SetInt(marathonPlayer2, "och", 10000);
									
									new Node:mPlayerArray = JSON_Array(marathonPlayer, marathonPlayer1, marathonPlayer2);
									JSON_SetArray(json, "j", mPlayerArray);
									
									JSON_SetInt(json, "m", 1);
									
									OnPacketIncoming(playerid, 22, json);
								}
								case 4: // ������� ������� BLACK PASS
								{
									printf("DONATE: la[case 4]");
									JSON_SetInt(json, "t", -1);
									JSON_SetInt(json, "ty", 0);
									JSON_SetInt(json, "la", 4);
									JSON_SetInt(json, "p", 790);
									JSON_SetInt(json, "pp", 1690);
									JSON_SetInt(json, "a", 0);
									
									OnPacketIncoming(playerid, 22, json);
								}
							}
							
							OnPacketIncoming(playerid, 22, json);
						}
/*						case 1: // ���� �� ������ "��������" � ��� �������� ������
						{
							printf("DONATE: ty[case 1]");
							JSON_SetInt(json, "t", -1);
							JSON_SetInt(json, "ty", 1);
							
							OnPacketIncoming(playerid, 22, json);
						} */
						case 2:
						{
							printf("DONATE: ty[case 2]");
							JSON_SetInt(json, "t", -1);
							JSON_SetInt(json, "ty", 2);
							JSON_SetInt(json, "s", 1);
							JSON_SetInt(json, "id", 18);
							JSON_SetInt(json, "p", 0);
							
							OnPacketIncoming(playerid, 22, json);
						}	
					}
					OnPacketIncoming(playerid, 22, json);
				}
                case 2:
                {
                 //   if(GetPlayerData(playerid, P_SALE_TIME) != 0) return 1;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}�������", "��� �������� �������, �� �������� ��������� �������!", "�������", "");

                 //   SetPlayerData(playerid, P_SALE_TIME, 7200); // 2 ���� � ��������
		           // UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_SetInt(json, "t", 2);
                //    JSON_SetInt(json, "p", GetPlayerData(playerid, P_SALE_TIME));

                    OnPacketIncoming(playerid, 22, json);

                    JSON_Cleanup(json);

                    // TODO: ����������� ������ ������� ������������ (��� ����� ������� ��������)
                }

                case 0:
                {                    
                   new price, internal_id;

                   JSON_GetInt(json, "p", internal_id);
                   JSON_GetInt(json, "m", price);

                   new result = GetPlayerDonateRub(playerid) - price;
                   printf("result = %d", result);

                   new result_json[256];
                   JSON_Stringify(json, result_json);

                   printf("result (json) = %s", result_json);

                   if (GetPlayerDonateRub(playerid) < price || GetPlayerDonateRub(playerid) < GetPlayerDonateRub(playerid) - price)
                   {
                        JSON_SetInt(json, "t", 0);
                        JSON_SetInt(json, "y", 0);
                        JSON_SetInt(json, "k", 1);

                        JSON_SetString(json, "m", "������������ �������.");
                        JSON_SetString(json, "n", "��������� ���� ����� ������!");

                        OnPacketIncoming(playerid, 22, json);

                        JSON_Cleanup(json);

                        return 1;
                   }

                   switch(internal_id)
                   {
                        case 349,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,201,202,195,211,212,213,214,215,216,217,218,219,220,353,221,222,223,224,275,276,327,328,329,330,331,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484:
                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 0);
                                JSON_SetInt(json, "k", -1);

                                JSON_SetString(json, "m", "��� ����� ��� ������� ������\n��������� ������.");
                                JSON_SetString(json, "n", "�� ������ ��������� �� � ������� {FFFF00}������.");
                                
                                OnPacketIncoming(playerid, 22, json);

                                JSON_Cleanup(json);
                                
                                return 1;
                            }

                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), 0);
                            GivePlayerDonateRub(playerid, -price);

                            JSON_SetInt(json, "t", 0);
                            JSON_SetInt(json, "y", 1);

                            JSON_SetInt(json, "g", internal_id);

                            JSON_SetInt(json, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(json, "m", "�� ������� ��������� ����������!");
                            JSON_SetString(json, "n", "��� ���� ����� ��������� ����,\n����������� /car");

                            OnPacketIncoming(playerid, 22, json);

                            JSON_Cleanup(json);
                        }
                        case 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210:
                        {
                            JSON_SetInt(json, "t", 0);
                            JSON_SetInt(json, "y", 1);

                            JSON_SetInt(json, "g", internal_id);

                            JSON_SetInt(json, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(json, "m", "�� ������� ��������� ������");
                            JSON_SetString(json, "n", "��� ���� ����� ����� �, ����������� ���������");

                            OnPacketIncoming(playerid, 22, json);

                            JSON_Cleanup(json);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }
                        //������ 
                        case 102: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: ��������� �����");
                                    
                                    ShowPlayerChangeNameDialog(playerid);

                                    GivePlayerDonateRub(playerid, -50, "����", true);
									
                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //����
                        case 103: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: ������ ��������������");
                                    
                                    SetPlayerData(playerid, P_WARN, 		0);
                                    SetPlayerData(playerid, P_WARN_TIME, 	0);

                                    UpdatePlayerDatabaseInt(playerid, "warn", 		0);
                                    UpdatePlayerDatabaseInt(playerid, "warn_time", 	0);

                                    GivePlayerDonateRub(playerid, -100, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��������
                                case 104: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 150)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ ��� ��������");

                                    SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                    UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));

                                    GivePlayerDonateRub(playerid, -150, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //������� �������
                        case 106: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 75)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ ������� �������");

                                    SetPlayerData(playerid, P_HEALTH, 100);
	                                SetPlayerHealthEx(playerid, 100);

                                    GivePlayerDonateRub(playerid, -75, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��������� ��� �����
                        case 107: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ ��������� ���� �����");

                                    ShowChangeNameDialog(playerid);

                                    GivePlayerDonateRub(playerid, -100, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //�������� �����
                        case 108: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: �������� �����");

                                    GivePlayerDonateRub(playerid, -100, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //������� �����
                        case 109: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 130)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ ������� �����");

                                    GivePlayerDonateRub(playerid, -130, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        case 111: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 500)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ �������");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ �������!");

                                    GivePlayerDonateRub(playerid, -500, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��������
                        case 112: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 1000)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ �������");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ��������, ��� �� ������������ ��������� /anymusic");

                                    GivePlayerDonateRub(playerid, -1000, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //���� ��� ����
                        case 113: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 2500)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: ���. ���� ��� ����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ��� ���� ��� ����");

                                    GivePlayerDonateRub(playerid, -2500, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //���� ��� �������
                        case 114: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 5000)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: ���. ���� ��� �������");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ��� ���� �� ������");

                                    GivePlayerDonateRub(playerid, -5000, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //���������� �����
                        case 115: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������: ���������� �����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ���������� ����� ��� ����!");

                                    GivePlayerDonateRub(playerid, -300, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //������ ��� �����
                        case 116: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ������ ���. �����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ������ ���. �����");

                                    GivePlayerDonateRub(playerid, -300, "����", true);
									
                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��������� ��� �����
                        case 117: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ���. �����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ���. �����");

                                    GivePlayerDonateRub(playerid, -100, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //���� ������ 
                        case 118: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ����. ������ �� ����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ���������� ������ �� ����");

                                    GivePlayerDonateRub(playerid, -50, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //�������
                        case 119: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 5)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ��������� �����-���");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ��������� �����-���");

                                    GivePlayerDonateRub(playerid, -5, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��� ���� �� ���� � �����
                        case 120: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ���. ���� �� ���� � �����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ���. ���� �� ���� � �����!");

                                    GivePlayerDonateRub(playerid, -300, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //����� ����
                        case 121: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� ��������");
                                    JSON_SetString(json, "n", "�� ������ ����� ����");

                                    SendClientMessage(playerid, 0xCECECEFF, "�� ������� ������ ����� ����");

                                    GivePlayerDonateRub(playerid, -50, "����", true);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        //��� ���� �� ����
                        case 122: {
                                JSON_SetInt(json, "t", 0);
                                JSON_SetInt(json, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json, "m", "�������� �������");
                                    JSON_SetString(json, "n", "�� ������ �������������� ���� ��� ����������");

                                    GivePlayerDonateRub(playerid, -100, "�����", true);

                                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

                                    new fmt_text[200];
                                    format(fmt_text, sizeof fmt_text, "�� ������ ���� ��� ����������. �������� ������: %d", GetPlayerData(playerid, P_CAR_SLOTS));
                                    SendClientMessage(playerid, 0x66CC00FF, fmt_text);

                                    OnPacketIncoming(playerid, 22, json);
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);
                                    JSON_SetString(json, "n", "������������ �����-������");
                                    OnPacketIncoming(playerid, 22, json);
                                }

                        }
                        case 123: {
                                if(GetPlayerDonateRub(playerid) >= 85)
                                {
                                    callcmd::buynomber(playerid, "");
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }
                        }
                        
                        case 124: {
                                if(GetPlayerDonateRub(playerid) >= 70)
                                {
                                    callcmd::buyphonenum(playerid, "");
                                }
                                else {
                                    JSON_SetInt(json, "t", 0);
                                    JSON_SetInt(json, "y", 0);
                                    JSON_SetInt(json, "k", 1);

                                    JSON_SetString(json, "n", "������������ �������");

                                    OnPacketIncoming(playerid, 22, json);
                                }
                        }
                        
                        case 179:
                        {
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "���������", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "������", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "��������", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoney(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�������", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoney(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "�� �������", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoney(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "����������", price, internal_id);
                        }
                   }
                }
            }
        }
        
        case 27:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new index = GetVehicleData(vehicleid, V_ACTION_ID);

            new type;
            JSON_GetInt(json, "t", type);

            switch(type)
            {
                case 1:
                {
                    callcmd::park(playerid);
                    return 1;
                }

                case 2:
                {
                    callcmd::key(playerid);
                    if(GetOwnableCarData(index, OC_KEY_IN)) JSON_SetInt(json, "s", 1);
                    else JSON_SetInt(json, "s", 0);
                    return 1;
                }

                case 3:
                {
                    callcmd::lock(playerid);
                    if(GetVehicleParam(vehicleid, V_LOCK)) JSON_SetInt(json, "s", 1);
                    else JSON_SetInt(json, "s", 0);
                    return 1;
                }

                case 6:
                {
                    callcmd::e(playerid);
                    if(GetVehicleParam(vehicleid, V_ENGINE)) JSON_SetInt(json, "s", 1);
                    else JSON_SetInt(json, "s", 0);

                    OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

                    if(!GetVehicleParam(vehicleid, V_ENGINE))
                    {
                        JSON_SetInt(json, "s", 0);

                        JSON_SetInt(json, "t", 12);
                        OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

                        JSON_SetInt(json, "t", 13);
                        OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

                        JSON_SetInt(json, "t", 14);
                        OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

                        JSON_SetInt(json, "t", 15);
                        OnPacketIncoming(playerid, GUIRadialMenuForCar, json);
                    }
                    return 1;
                }

                case 14:
                {
                    callcmd::l(playerid);
                    if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(json, "s", 1);
                    else
                    {
                        JSON_SetInt(json, "s", 0);
                        OnPacketIncoming(playerid, 27, json);

                        JSON_SetInt(json, "t", 13);
                        OnPacketIncoming(playerid, 27, json);

                        JSON_SetInt(json, "t", 14);
                        OnPacketIncoming(playerid, 27, json);

                        JSON_SetInt(json, "t", 15);
                        OnPacketIncoming(playerid, 27, json);
                    }
                    return 1;
                }

                case 15:
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    if(vInfo[vehicleid][vStrob] >= 0)
    {
        if(GetVehicleParam(vehicleid, V_ENGINE))
        {
            if(!vInfo[vehicleid][vEnableStrob])
            {
                vInfo[vehicleid][vEnableStrob] = true;

                SetVehicleStroboscope(vehicleid, vInfo[vehicleid][vStrob]);

                JSON_SetInt(json, "s", 1);
                OnPacketIncoming(playerid, 27, json);
                JSON_SetInt(json, "t", 14);
            }
            else
            {
                // ��������� �����
                vInfo[vehicleid][vEnableStrob] = false;

                SetVehicleStroboscope(vehicleid, 5, 1);

                JSON_SetInt(json, "s", 0);
            }
        }
    }
    return 1;
}


                case 19:
                {
                    if(vInfo[vehicleid][vHydraulics])
                    {
                        if(!vInfo[vehicleid][vEnableHydraulics])
                        {
                            vInfo[vehicleid][vEnableHydraulics] = true;
                            SetVehicleHydraulics(vehicleid, 1);
                            JSON_SetInt(json, "s", 1);
                        }
                        else
                        {
                            vInfo[vehicleid][vEnableHydraulics] = false;
                            RemoveVehicleComponent(vehicleid, 1087);
                            SetVehicleHydraulics(vehicleid, 0);
                            JSON_SetInt(json, "s", 0);
                        }
                    }
                    return 1;
                }
            }

            OnPacketIncoming(playerid, 27, json);
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
            new email[128], password[24];
            JSON_GetString(json, "s", email);
            JSON_GetString(json, "p", password);

            strmid(CheckPass[playerid], password, 0, strlen(password), 65);

            if(strlen(email) != 0)
            {
                strmid(GetPlayerData(playerid, P_EMAIL), email, 0, strlen(email), 65);
            }

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 3);
            OnPacketIncoming(playerid, 38, response);
            JSON_Cleanup(response);

            return 1;
        }

        case 3:
        {
            new gender;
            JSON_GetInt(json, "r", gender);
            SetPlayerData(playerid, P_SEX, gender);

            if(CreatePlayerAccount(playerid))
            {
                SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);
                SpawnPlayer(playerid);
                
                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 0);
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            }
            else
            {
                ShowNotificationNew(playerid, 1, 5, 0, 0, "Error creating account!",">");
                Kick(playerid);
            }
            return 1;
        }

        case 4:
        {
            new invite_nick[MAX_PLAYER_NAME];
            JSON_GetString(json, "s", invite_nick);

            if (strlen(invite_nick) == 0)
            {
                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 0);
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
                return 1;
            }

            new query[75], Cache: result;
            mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
            result = mysql_query(mysql, query);

            if(cache_num_rows())
                SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
            cache_delete(result);

            if(!GetPlayerData(playerid, P_REFER))
            {
                ShowNotificationNew(playerid, 1, 5, 0, 0, "Invite not found!",">");
                return 1;
            }

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
            SetPlayerData(playerid, P_SKIN, final_skin);

            HidePlayerSelectPanel(playerid);
            HidePlayerSelectPanelPrice(playerid);
            SetPlayerData(playerid, P_SELECT_SKIN, -1);
            SetPlayerSpawnInit(playerid);
            SetPlayerData(playerid, P_MONEY, 70000000);
            UpdatePlayerDatabaseInt(playerid, "money", 70000000);
            SpawnPlayer(playerid);
            SetPlayerInit(playerid);
            ShowSpawnSelectionDialog(playerid);

            new query[90];
            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
            mysql_query(mysql, query, false);
            
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", -1);
            OnPacketIncoming(playerid, 38, response);
            JSON_Cleanup(response);
            
            return 1;
        }

        case 6:
        {
            new password[24], hash[65], auto_login;
            JSON_GetString(json, "s", password);
            JSON_GetInt(json, "r", auto_login);
            
            strmid(CheckPass[playerid], password, 0, strlen(password), 65);
            SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

            if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
            {
                SetPlayerData(playerid, P_AUTH_TIME, -1);
                LoadPlayerData(playerid);
                SetPlayerLogged(playerid, true);

                new Node:response = JSON_Object();
                JSON_SetInt(response, "c", 1);
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            } 
            else
            {
                ShowNotificationNew(playerid, 0, 5, 0, 0, "Wrong password!",">");
            }
            return 1;
        }
    }
}
case 56:
{
    new t;
    JSON_GetInt(json, "t", t);

    new mg = player_electric_game[playerid];
    new orderId = player_electric_order[playerid];
    new city = player_electric_city[playerid];

    if(t == 2) 
    {
        new salary = 0;
        new exp = 0;
        switch(mg)
        {
            case ELECTRIC_FIND_PROBLEM: { salary = 5000; exp = 1; }
            case ELECTRIC_SUM_CONTACTS: { salary = 8000; exp = 1; }
            case ELECTRIC_RAISE_CHARGE: { salary = 11000; exp = 1; }
            case ELECTRIC_COLLECT_SCHEME: { salary = 14000; exp = 1; }
        }
        
        GivePlayerMoneyEx(playerid, salary);
        GivePlayerElectricExp(playerid, exp);
       
       new log_text[128];
  format(log_text, sizeof(log_text), "�������� ����� ��������� � ������� %d ������", salary);
//  SendLog(playerid, LOG_TYPE_MONEY, log_text);

        IncreaseElectricOrderStats(playerid, player_electric_ordertype[playerid]);
        
        new msg[128];
        format(msg, sizeof(msg), "{FFFFFF}�� ������� ��������� ����� � �������� {FFFF00}%d ���. {FFFFFF}� {FFFF00}%d �����", salary, exp);
        SendClientMessage(playerid, -1, msg);
        SendClientMessage(playerid, -1, "{FFFFFF}��� ������ ������ ������ ����������� - {FFFF00} /elist");
        
        if(player_electric_area[playerid] != -1)
        {
            DestroyDynamicArea(player_electric_area[playerid]);
            player_electric_area[playerid] = -1;
        }
        
        if(city >= 1 && city <= 4)
        {
            SetOrderCooldown(city, orderId);

            switch(city)
            {
                case 1: 
                {
                    if(orderId < sizeof(orders_electric_city1))
                    {
                        orders_electric_city1[orderId][E_PLAYER_ID] = -1;
                        if(orders_electric_city1[orderId][E_LABEL] != Text3D:INVALID_3DTEXT_ID)
                        {
                            UpdateDynamic3DTextLabelText(orders_electric_city1[orderId][E_LABEL], 0x00000000, " ");
                            DestroyDynamic3DTextLabel(orders_electric_city1[orderId][E_LABEL]);
                            orders_electric_city1[orderId][E_LABEL] = Text3D:INVALID_3DTEXT_ID;
                        }
                    }
                }
                case 2: 
                {
                    if(orderId < sizeof(orders_electric_city2))
                    {
                        orders_electric_city2[orderId][E_PLAYER_ID] = -1;
                        if(orders_electric_city2[orderId][E_LABEL] != Text3D:INVALID_3DTEXT_ID)
                        {
                            UpdateDynamic3DTextLabelText(orders_electric_city2[orderId][E_LABEL], 0x00000000, " ");
                            DestroyDynamic3DTextLabel(orders_electric_city2[orderId][E_LABEL]);
                            orders_electric_city2[orderId][E_LABEL] = Text3D:INVALID_3DTEXT_ID;
                        }
                    }
                }
                case 3: 
                {
                    if(orderId < sizeof(orders_electric_city3))
                    {
                        orders_electric_city3[orderId][E_PLAYER_ID] = -1;
                        if(orders_electric_city3[orderId][E_LABEL] != Text3D:INVALID_3DTEXT_ID)
                        {
                            UpdateDynamic3DTextLabelText(orders_electric_city3[orderId][E_LABEL], 0x00000000, " ");
                            DestroyDynamic3DTextLabel(orders_electric_city3[orderId][E_LABEL]);
                            orders_electric_city3[orderId][E_LABEL] = Text3D:INVALID_3DTEXT_ID;
                        }
                    }
                }
                case 4: 
                {
                    if(orderId < sizeof(orders_electric_city4))
                    {
                        orders_electric_city4[orderId][E_PLAYER_ID] = -1;
                        if(orders_electric_city4[orderId][E_LABEL] != Text3D:INVALID_3DTEXT_ID)
                        {
                            UpdateDynamic3DTextLabelText(orders_electric_city4[orderId][E_LABEL], 0x00000000, " ");
                            DestroyDynamic3DTextLabel(orders_electric_city4[orderId][E_LABEL]);
                            orders_electric_city4[orderId][E_LABEL] = Text3D:INVALID_3DTEXT_ID;
                        }
                    }
                }
            }
        }
        
        player_orders_electric[playerid] = -1;
        player_electric_game[playerid] = 0;
        player_electric_order[playerid] = -1;
        player_electric_frozen[playerid] = false;
        TogglePlayerControllable(playerid, true);
        ClearAnimations(playerid);
    }
    else if(t == 3) 
    {
        new Float:health;
        GetPlayerHealth(playerid, health);
        SetPlayerHealth(playerid, health - 10.0);
        
        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, 0, 1);
        SendClientMessage(playerid, -1, "{FFFFFF}�� ��������� ������ � �������� ���� �����");
        
        player_electric_frozen[playerid] = true;
        TogglePlayerControllable(playerid, false);

        SetTimerEx("ElectricRetryGame", 5000, false, "ii", playerid, orderId);
    }
    else if(t == 4)
    {
        player_electric_game[playerid] = 0;
        player_electric_order[playerid] = -1;
        TogglePlayerControllable(playerid, true);
    }
    JSON_Cleanup(json);
    return 1;
}
        case 66:
{
    new buttonId, screenType, closeFlag;
    
    JSON_GetInt(json, "b", buttonId);
    JSON_GetInt(json, "t", screenType);
    JSON_GetInt(json, "c", closeFlag);
    
    if(closeFlag == 1)
    {
        StopSpectate(playerid);
        return 1;
    }
    
    new targetid = GetPlayerSpectateData(playerid, S_PLAYER);
    
    if(targetid == -1 || !IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF3333FF, "????? ?? ??????!");
        return 1;
    }
    
    switch(buttonId)
    {
        case 1:
        {
            if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
            {
                SetPlayerInterior(playerid, GetPlayerInterior(targetid));
                SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
                
                PlayerSpectatePlayer(playerid, targetid);
                
                ShowSpectateGUI(playerid, targetid);
            }
        }
        
        case 2:
        {
            new prevPlayer = FindPreviousPlayer(targetid);
            if(prevPlayer != -1)
            {
                StartSpectate(playerid, prevPlayer);
                ShowSpectateGUI(playerid, prevPlayer);
            }
            else
            {
                ShowNotificationNew(playerid, 0, 3, 0, 0, "??????? ?? ???????", "");
            }
        }
        
        case 3:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_KICK, DIALOG_STYLE_LIST,
                "??????? ??????",
                "??????? ??????\n???? ??????? ??????",
                "???????", "??????");
        }
        
        case 4:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_MUTE, DIALOG_STYLE_LIST,
                "?????????? ????? ??????", 
                "?????? ???\n????? ???",
                "???????", "??????");
        }
        
        case 5:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_JAIL, DIALOG_STYLE_LIST,
                "???????? ??????",
                "???????? ? ??????\n????????? ?? ??????",
                "???????", "??????");
        }
        
        case 6:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_WARN, DIALOG_STYLE_LIST,
                "?????????? ??????? ??????",
                "?????? ??????????????\n????? ??????????????",
                "???????", "??????");
        }
        
        case 7:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_SLAP, DIALOG_STYLE_LIST,
                "?????????? ??????",
                "?????????? ?????\n?????????? ????",
                "???????", "??????");
        }
        
        case 8:
        {
            ShowPlayerDialog(playerid, DIALOG_ADMIN_BAN, DIALOG_STYLE_LIST,
                "???????? ??????",
                "?????? ????????? ???\n?????? ???????????? ???",
                "???????", "??????");
        }
        
        case 9:
        {
            new nextPlayer = FindNextPlayer(targetid);
            if(nextPlayer != -1)
            {
                StartSpectate(playerid, nextPlayer);
                ShowSpectateGUI(playerid, nextPlayer);
            }
            else
            {
                ShowNotificationNew(playerid, 0, 3, 0, 0, "??????? ?? ???????", "");
            }
        }
        
        case 10:
        {
            new params[128];
		    format(params, sizeof(params), "%d", targetid);
		    callcmd::stats(playerid, params);
        }
        
        case 11:
        {
            callcmd::af(playerid, "");
        }
        
        default:
        {
            printf("[IPacket:66] Unknown button: %d", buttonId);
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
            offset += 18;
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
            JSON_GetInt(json, "id", reward_db_id);
            JSON_GetInt(json, "s", reward_action);
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
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO rewards (uid, award_id, case_id) VALUES (%d, %d, %d)",
        GetPlayerData(playerid, P_ACCOUNT_ID), reward_ui_id - 1, cs_val
    );
    mysql_tquery(mysql, query, "", "");
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
            JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
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
        if(GetPlayerDonateRub(playerid) < price)
        {
            JSON_SetInt(response, "s", 0);
            JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
            ShowNotificationCases(playerid, 2, 4, 1, 1, "������������ ������ ��� Black Coin!", "");
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

    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
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
}
}


// Stock ��� �������� 1 �������
stock SendCaseReward_1(playerid)
{
    printf("[DEBUG] ����� stock ��� 1 �������");
    
    new Node:open_response = JSON_Object(); 
    JSON_SetInt(open_response, "t", 2); 
    JSON_SetInt(open_response, "bc", 2000); 
    JSON_SetInt(open_response, "s", 1); 
    
    new Node:prArray = JSON_Array();
    prArray = JSON_Append(prArray, JSON_Int(28)); // ���� ������� ID 28
    JSON_SetArray(open_response, "pr", prArray);
    
    OnPacketIncoming(playerid, 73, open_response); 
    JSON_Cleanup(open_response);
    
    printf("[DEBUG] ���������� 1 �������");
}

// Stock ��� �������� 10 ������
stock SendCaseReward_10(playerid)
{
    printf("[DEBUG] ����� stock ��� 10 ������");
    
    new Node:open_response = JSON_Object(); 
    JSON_SetInt(open_response, "t", 2); 
    JSON_SetInt(open_response, "bc", 2000); 
    JSON_SetInt(open_response, "s", 1); 
    
    new Node:prArray = JSON_Array();
    // 10 ������
    prArray = JSON_Append(prArray, JSON_Int(1));   // ���� 1
    prArray = JSON_Append(prArray, JSON_Int(2));   // ���� 2  
    prArray = JSON_Append(prArray, JSON_Int(3));   // ���� 3
    prArray = JSON_Append(prArray, JSON_Int(3));   // ���� 4
    prArray = JSON_Append(prArray, JSON_Int(4));   // ���� 5
    prArray = JSON_Append(prArray, JSON_Int(4));   // ���� 6
    prArray = JSON_Append(prArray, JSON_Int(5));   // ���� 7
    prArray = JSON_Append(prArray, JSON_Int(6));   // ���� 8
    prArray = JSON_Append(prArray, JSON_Int(4));   // ���� 9
    prArray = JSON_Append(prArray, JSON_Int(10));  // ���� 10
    JSON_SetArray(open_response, "pr", prArray);
    
    OnPacketIncoming(playerid, 73, open_response); 
    JSON_Cleanup(open_response);
    
    printf("[DEBUG] ���������� 10 ������");
}
CMD:tungui(playerid, params[])
{
    player_gui_type[playerid] = GUI_TUNGUI;
    new Node:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "j", 9000000); // ����� ������� ����� ������� �������� ���� ��������� ��, ��� �� ���� �� ������ ���� ����������
    JSON_SetInt(tuning_json, "s", 5);

    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(GetVehicleModel(GetPlayerVehicleID(playerid))));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    SetPlayerInterior(playerid, 1);

    new carid = GetPlayerVehicleID(playerid);
    if (carid != 0)
    {
        SetVehiclePos(carid, 1000.0, 1500.0, 1498.0);
        SetVehicleZAngle(carid, 180.0);
    }

    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    ShowPlayerGUI(playerid, 28, tuning_json);

    return 1;
}

stock SetVehicleVinyl(vehicleid, const texture[])
{
    format(vInfo[vehicleid][vVinylTexture], 32, "%s", texture);

    foreach (new playerid : streamed_players_in_veh[vehicleid])
    SetVehicleVinylForPlayer(playerid, vehicleid, texture);
}

stock SetVehicleVinylForPlayer(playerid, vehicleid, const texture[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 12);
    BS_WriteValue(bitstream, PR_UINT8, strlen(texture));
    BS_WriteValue(bitstream, PR_STRING, texture);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

CMD:vinyl(playerid, params[])
{
    // ���������, ��� ����� ��������� � ������
    new vehicleid = GetPlayerVehicleID(playerid);
    if (vehicleid == 0)
        return SendClientMessage(playerid, COLOR_RED, "�� ������ ���������� � ����������!");

    // ��������� ������� ��������� (�������� ��������)
    new texture[32];
    if (sscanf(params, "s[32]", texture))
        return SendClientMessage(playerid, COLOR_WHITE, "�������������: /vinyl [��������_��������]");

    // ������������� �����
    SetVehicleVinyl(vehicleid, texture, 1);

    new string[64];
    format(string, sizeof string, "����� '%s' ������� ��������!", texture);
    SendClientMessage(playerid, COLOR_GREEN, string);

    return 1;
}

CMD:lareklarekovichezz(playerid, params[])
{
    new Node:json = JSON_Object();

    JSON_SetInt(json, "m", GetPlayerMoney(playerid));

    ShowPlayerGUI(playerid, 3, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:plates(playerid, params[])
{
    new Node:plate_json = JSON_Object();
   // JSON_SetInt(plate_json, "t", 0);
    JSON_SetInt(plate_json, "p", 5000); 
    JSON_SetInt(plate_json, "pr", 2000);
    ShowPlayerGUI(playerid, 1, plate_json);
    JSON_Cleanup(plate_json);
    return 1;
}

CMD:family2(playerid, params[])
{
    new f = GetPlayerIdFamily(playerid);
    
    if(f == -1)
    {

    }
    

    mysql_format(mysql, f_string64, sizeof f_string64, "SELECT COUNT(*) as count FROM family_ad WHERE family = %d", GetFamily(f, family_database));
    new Cache:cache = mysql_query(mysql, f_string64);
    
    new ad_count = 0;
    if(cache_num_rows())
    {
        ad_count = cache_get_field_content_int(0, "count");
    }
    cache_delete(cache);
    
    new Node:response = JSON_Object();
    JSON_SetInt(response, "o", 1);
    
    new fam_name_with_color[128];
    format(fam_name_with_color, sizeof fam_name_with_color, "%s%s", family_type_color[GetFamily(f, family_color)], GetFamily(f, family_name));
    JSON_SetString(response, "n", fam_name_with_color);
    
    JSON_SetInt(response, "k", (GetPlayerRangFamily(playerid) == 5) ? 1 : 0);
    JSON_SetInt(response, "m", 0); 
    JSON_SetInt(response, "j", 0);
    JSON_SetInt(response, "y", ad_count); 
    JSON_SetInt(response, "b", 0); 

    JSON_SetInt(response, "pi", 1);
    JSON_SetString(response, "pn", GetPlayerNameEx(playerid));
    JSON_SetInt(response, "is", 0); 
    
    OnPacketIncoming(playerid, 45, response);
    return 1;
}

CMD:frac(playerid, params[])
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "page", 1); // INTERFACE_MAIN
    JSON_SetInt(json, "fraction_id", 7); // FRACTION_ID_FSB
    
    // Rank status array: [1 (current), 2 (next), 0 (unavailable), ..., 5 (contact leader for rank 10)]
    new Node:s1 = JSON_Int(4);
    new Node:s2 = JSON_Int(1);
    new Node:s3 = JSON_Int(2);
    new Node:s4 = JSON_Int(0);
    new Node:s5 = JSON_Int(0);
    new Node:s6 = JSON_Int(0);
    new Node:s7 = JSON_Int(0);
    new Node:s8 = JSON_Int(5);
    new Node:s9 = JSON_Int(5);
    new Node:s10 = JSON_Int(5);
    new Node:rank_status = JSON_Array(s1, s2, s3, s4, s5, s6, s7, s8, s9, s10);
    JSON_SetArray(json, "rank_status", rank_status);
    
    // Rank progress array: [75% for current, 0 for others]
    new Node:p1 = JSON_Int(5);
    new Node:p2 = JSON_Int(25);
    new Node:p3 = JSON_Int(50);
    new Node:p4 = JSON_Int(0);
    new Node:p5 = JSON_Int(0);
    new Node:p6 = JSON_Int(0);
    new Node:p7 = JSON_Int(0);
    new Node:p8 = JSON_Int(0);
    new Node:p9 = JSON_Int(0);
    new Node:p10 = JSON_Int(0);
    new Node:rank_progress = JSON_Array(p1, p2, p3, p4, p5, p6, p7, p8, p9, p10);
    JSON_SetArray(json, "rank_progress", rank_progress);

    ShowPlayerGUI(playerid, 46, json);

    return 1;
}

stock SetVehicleStroboscope(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vStrob] = type;
	foreach(new playerid: Player) SetVehicleStroboscopeForPlayer(playerid, vehicleid, type);
}

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 19);

	BS_WriteValue(bitstream, PR_UINT32, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

CMD:strab(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Vehicle!");

	extract params -> new type, setvalue; else return Send(playerid, -1, "/strab [type] [value]");

    new vehicleid = GetPlayerVehicleID(playerid);

    SetVehicleStroboscope(vehicleid, type, setvalue);

    return 1;
}

stock SetVehicleBodyColor(playerid, vehicleid, color1, color2 = 0, color3 = 0, color4 = 0)
{
	new BitStream:bs = BS_New();
	
	// ID ���������� (16 ���)
	BS_WriteValue(bs, PR_UINT16, vehicleid);
	
	// ��� �������: 0x12 = ���� ������ (18 � ����������)
	BS_WriteValue(bs, PR_UINT8, 18);
	
	// 4 ����� ������ (�� 32 ���� ������)
	BS_WriteValue(bs, PR_UINT32, color1);  // �������� ����
	BS_WriteValue(bs, PR_UINT32, color2);  // ��������� ����
	BS_WriteValue(bs, PR_UINT32, color3);  // ������ ����
	BS_WriteValue(bs, PR_UINT32, color4);  // ��������� ����
	
	// ���������� RPC (167 - ��� ID RPC ScrCustomizeVehicle)
	PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bs);
	
	return 1;
}

CMD:color(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, !"�� �� � ������!");
    
    // ������� ���� � ������� HEX (RRGGBB)
    new color = 0xFF0000; // �������
    
    // ������������� ��� 4 ����� ����� ������
    SetVehicleBodyColor(playerid, vehicleid, color, color, color, color);
    
    SendClientMessage(playerid, -1, !"���� ������ ������� �� �������!");
    return 1;
}

CMD:techcentergui(playerid, params[])
{
    player_gui_type[playerid] = GUI_TECHCENTER;

    new vehicleid = GetPlayerVehicleID(playerid);
    if (!vehicleid) return 1;

    new oc_idx = GetVehicleData(vehicleid, V_ACTION_ID);
    if (oc_idx == INVALID_VEHICLE_ID) return 1;

    new car_nitro = GetOwnableCarData(oc_idx, OC_NITRO);

    new nitro_2x = 2;
    new nitro_5x = 2;
    new nitro_10x = 2;

    if (car_nitro == 20) nitro_2x = 20;
    else if (car_nitro == 50) nitro_5x = 50;
    else if (car_nitro == 100) nitro_10x = 100;

    // ��������� ������ �������, ���� ������ ��� � ������ 2
    new Node:k_array = JSON_Array(
        VehicleTuning[vehicleid][TUNING_COMFORT][0] ? VehicleTuning[vehicleid][TUNING_COMFORT][0] : 2,
        VehicleTuning[vehicleid][TUNING_COMFORT][1] ? VehicleTuning[vehicleid][TUNING_COMFORT][1] : 2,
        VehicleTuning[vehicleid][TUNING_COMFORT][2] ? VehicleTuning[vehicleid][TUNING_COMFORT][2] : 2,
        VehicleTuning[vehicleid][TUNING_COMFORT][3] ? VehicleTuning[vehicleid][TUNING_COMFORT][3] : 2,
        VehicleTuning[vehicleid][TUNING_COMFORT][4] ? VehicleTuning[vehicleid][TUNING_COMFORT][4] : 2,

        VehicleTuning[vehicleid][TUNING_SPORT][0] ? VehicleTuning[vehicleid][TUNING_SPORT][0] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT][1] ? VehicleTuning[vehicleid][TUNING_SPORT][1] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT][2] ? VehicleTuning[vehicleid][TUNING_SPORT][2] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT][3] ? VehicleTuning[vehicleid][TUNING_SPORT][3] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT][4] ? VehicleTuning[vehicleid][TUNING_SPORT][4] : 2,

        VehicleTuning[vehicleid][TUNING_SPORT_PL][0] ? VehicleTuning[vehicleid][TUNING_SPORT_PL][0] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT_PL][1] ? VehicleTuning[vehicleid][TUNING_SPORT_PL][1] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT_PL][2] ? VehicleTuning[vehicleid][TUNING_SPORT_PL][2] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT_PL][3] ? VehicleTuning[vehicleid][TUNING_SPORT_PL][3] : 2,
        VehicleTuning[vehicleid][TUNING_SPORT_PL][4] ? VehicleTuning[vehicleid][TUNING_SPORT_PL][4] : 2,

        VehicleTuning[vehicleid][TUNING_DRIFT][0] ? VehicleTuning[vehicleid][TUNING_DRIFT][0] : 2,
        VehicleTuning[vehicleid][TUNING_DRIFT][1] ? VehicleTuning[vehicleid][TUNING_DRIFT][1] : 2,
        VehicleTuning[vehicleid][TUNING_DRIFT][2] ? VehicleTuning[vehicleid][TUNING_DRIFT][2] : 2,
        VehicleTuning[vehicleid][TUNING_DRIFT][3] ? VehicleTuning[vehicleid][TUNING_DRIFT][3] : 2,
        VehicleTuning[vehicleid][TUNING_DRIFT][4] ? VehicleTuning[vehicleid][TUNING_DRIFT][4] : 2,

        35,        // launch control
        nitro_2x,  // nitro 2x
        nitro_5x,  // nitro 5x
        nitro_10x  // nitro 10x
    );

    new Node:tuning_json = JSON_Object();

    // ��������� ��������� GUI
    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "j", 9000000);
    JSON_SetInt(tuning_json, "s", 5);

    JSON_SetArray(tuning_json, "k", k_array);

    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", GetVehicleNameByModel(GetVehicleModel(vehicleid)));
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    // ����������� ��� � ��������
    new vw = playerid + 1000;
    SetPlayerVirtualWorld(playerid, vw);
    SetVehicleVirtualWorld(vehicleid, vw);
    SetPlayerInterior(playerid, 1);
    SetVehiclePos(vehicleid, 996.1070, 999.4791, 1000.5);
    SetVehicleZAngle(vehicleid, -90.0);

    SetPlayerCameraPos(playerid, 1001.1626, 1002.8044, 1000.9689);
    SetPlayerCameraLookAt(playerid, 1000.3796, 1002.1858, 1001.0136);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}


stock GetTuningPrice(gosCost, tuneId)
{
    new Float:percent;
    new addedValue;

    switch(tuneId)
    {
        case 0: { percent = 4.0; addedValue = 15000; }
        case 1: { percent = 7.0; addedValue = 15000; }
        case 2: { percent = 0.005; addedValue = 20; }
        case 3: { percent = 5.0; addedValue = 15000; }
        default: return 0;
    }

    return floatround((float(gosCost) * percent / 100.0) + float(addedValue));
}

stock GetNitroPrice(gosCost, nitroId)
{
    new Float:percent;
    switch(nitroId)
    {
        case 0: percent = 2.0;
        case 1: percent = 5.0;
        case 2: percent = 7.0;
        default: return 0;
    }
    return floatround((float(gosCost) * percent / 100.0) + 15000.0);
}

