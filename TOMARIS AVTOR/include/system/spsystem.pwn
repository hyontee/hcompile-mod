stock ShowAdminTools(playerid) {
    new Node:json = JSON_Object();
    new Node:players_array = JSON_Array();

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) {
        if(IsPlayerConnected(i)) {
            new Node:player = JSON_Object();
            new name[MAX_PLAYER_NAME], Float:hp, Float:armor, Float:speed, ping, money, vehicleid, Float:vehicle_health;
            GetPlayerName(i, name, sizeof(name));
            GetPlayerHealth(i, hp);
            GetPlayerArmour(i, armor);
            ping = GetPlayerPing(i);
            money = GetPlayerMoney(i);
            vehicleid = GetPlayerVehicleID(i);
            GetVehicleHealth(vehicleid, vehicle_health);
            speed = GetPlayerSpeed(i);

            new Node:info_array = JSON_Array();

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(1),
                "n", JSON_String("Level"),
                "v", JSON_Int(1)
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(2),
                "n", JSON_String("Health"),
                "v", JSON_Int(floatround(hp))
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(3),
                "n", JSON_String("Armor"),
                "v", JSON_Int(floatround(armor))
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(4),
                "n", JSON_String("Speed"),
                "v", JSON_Int(floatround(speed))
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(5),
                "n", JSON_String("Ping"),
                "v", JSON_Int(ping)
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(6),
                "n", JSON_String("Money"),
                "v", JSON_Int(money)
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(7),
                "n", JSON_String("Transport"),
                "v", JSON_Int(vehicleid)
            ));

            JSON_Append(info_array, JSON_Object(
                "p", JSON_Int(8),
                "n", JSON_String("Vehicle Health"),
                "v", JSON_Int(floatround(vehicle_health))
            ));

            JSON_SetInt(player, "id", i);
            JSON_SetString(player, "name", name);
            JSON_SetArray(player, "info", info_array);
            JSON_Append(players_array, player);
            JSON_Cleanup(info_array);
        }
    }

    JSON_SetArray(json, "playerInfoList", players_array);
    JSON_SetString(json, "tableTitle", "Player Information");
    JSON_SetInt(json, "admin_id", playerid);
    JSON_SetBool(json, "isShowTable", true);
    JSON_SetInt(json, "screenType", 3);
    JSON_SetString(json, "categoryTitle", "Admin Actions");

    OnPacketIncoming(playerid, 66, json);

    JSON_Cleanup(players_array);
    JSON_Cleanup(json);
    return 1;
}

CMD:admtools(playerid)
{
    ShowAdminTools(playerid);
    return 1;
}


public OnPlayerGUIPacket(playerid, packetid, BitStream:bs) {
    if(packetid != 253) return 0;

    new guiid, dataLen, data[1024];
    BS_ReadValue(bs, PR_UINT16, guiid);
    BS_ReadValue(bs, PR_UINT32, dataLen);
    BS_ReadValue(bs, PR_STRING, data, dataLen);

    if(guiid != 66) return 0;

    new Node:json = JSON_Parse(data);

    new action[32];
    JSON_GetString(json, "action", action, sizeof(action));

    if(!strcmp(action, "select_player")) {
        new targetid;
        JSON_GetInt(json, "player_id", targetid);
        if(IsPlayerConnected(targetid)) {
            new name[MAX_PLAYER_NAME], message[128];
            GetPlayerName(targetid, name, sizeof(name));
            format(message, sizeof(message), "               %s (ID: %d)", name, targetid);
            SendClientMessage(playerid, -1, message);

            new Node:template_json = JSON_Object();
            JSON_SetInt(template_json, "player_id", targetid);
            JSON_SetString(template_json, "playerName", name);
            JSON_SetString(template_json, "action", "open_template");
            JSON_SetInt(template_json, "screenType", 1);
            OnPacketIncoming(playerid, 66, template_json);
            JSON_Cleanup(template_json);
        }
    }
    else if(!strcmp(action, "kick")) {
        new targetid, reason[100];
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        AdminKickPlayer(playerid, targetid, reason);
    }
    else if(!strcmp(action, "ban")) {
        new targetid, reason[100], days;
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        JSON_GetInt(json, "days", days);
        AdminBanPlayer(playerid, targetid, reason, days);
    }
    else if(!strcmp(action, "mute")) {
        new targetid, reason[100], minutes;
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        JSON_GetInt(json, "minutes", minutes);
        AdminMutePlayer(playerid, targetid, reason, minutes);
    }
    else if(!strcmp(action, "jail")) {
        new targetid, reason[100], minutes;
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        JSON_GetInt(json, "minutes", minutes);
        AdminJailPlayer(playerid, targetid, reason, minutes);
    }
    else if(!strcmp(action, "warn")) {
        new targetid, reason[100];
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        AdminWarnPlayer(playerid, targetid, reason);
    }
    else if(!strcmp(action, "slap")) {
        new targetid, reason[100];
        JSON_GetInt(json, "player_id", targetid);
        JSON_GetString(json, "reason", reason, sizeof(reason));
        AdminSlapPlayer(playerid, targetid, reason);
    }
    else if(!strcmp(action, "teleport")) {
        new targetid;
        JSON_GetInt(json, "player_id", targetid);
        AdminTeleportToPlayer(playerid, targetid);
    }
    else if(!strcmp(action, "create_template")) {
        new templateTitle[32], templateDesc[100], templateTime;
        JSON_GetString(json, "templateTitle", templateTitle, sizeof(templateTitle));
        JSON_GetString(json, "templateDesc", templateDesc, sizeof(templateDesc));
        JSON_GetInt(json, "templateTime", templateTime);
        AdminCreateTemplate(playerid, templateTitle, templateDesc, templateTime);
    }
    else if(!strcmp(action, "edit_template")) {
        new templateId, templateTitle[32], templateDesc[100], templateTime;
        JSON_GetInt(json, "templateId", templateId);
        JSON_GetString(json, "templateTitle", templateTitle, sizeof(templateTitle));
        JSON_GetString(json, "templateDesc", templateDesc, sizeof(templateDesc));
        JSON_GetInt(json, "templateTime", templateTime);
        AdminEditTemplate(playerid, templateId, templateTitle, templateDesc, templateTime);
    }
    else if(!strcmp(action, "delete_template")) {
        new templateId;
        JSON_GetInt(json, "templateId", templateId);
        AdminDeleteTemplate(playerid, templateId);
    }
    else if(!strcmp(action, "close")) {
        SendClientMessage(playerid, -1, "GUI        ");
    }

    JSON_Cleanup(json);
    return 1;
}

stock AdminKickPlayer(adminid, targetid, reason[]) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "kick");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 3); // AdminToolsConstants

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s        %s.        : %s", name, adminName, reason);
    SendClientMessageToAll(-1, message);
    Kick(targetid);
    return 1;
}

stock AdminBanPlayer(adminid, targetid, reason[], days) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "ban");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "days", days);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 8);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s         %s    %d     .        : %s", name, adminName, days, reason);
    SendClientMessageToAll(-1, message);
    BanEx(targetid, reason);
    return 1;
}

stock AdminMutePlayer(adminid, targetid, reason[], minutes) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "mute");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "minutes", minutes);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 4);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s         %s    %d      .        : %s", name, adminName, minutes, reason);
    SendClientMessageToAll(-1, message);
    return 1;
}

stock AdminJailPlayer(adminid, targetid, reason[], minutes) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "jail");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "minutes", minutes);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 5);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s                  %s    %d      .        : %s", name, adminName, minutes, reason);
    SendClientMessageToAll(-1, message);
    return 1;
}

stock AdminWarnPlayer(adminid, targetid, reason[]) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "warn");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 6);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s                           %s.        : %s", name, adminName, reason);
    SendClientMessageToAll(-1, message);
    return 1;
}

stock AdminSlapPlayer(adminid, targetid, reason[]) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "slap");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetString(json, "reason", reason);
    JSON_SetInt(json, "admin_id", adminid);
    JSON_SetInt(json, "categoryId", 7);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128], Float:x, Float:y, Float:z;
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + 5.0);
    format(message, sizeof(message), "%s                   %s.        : %s", name, adminName, reason);
    SendClientMessageToAll(-1, message);
    return 1;
}

stock AdminTeleportToPlayer(adminid, targetid) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "teleport");
    JSON_SetInt(json, "player_id", targetid);
    JSON_SetInt(json, "admin_id", adminid);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new Float:x, Float:y, Float:z, name[MAX_PLAYER_NAME], adminName[MAX_PLAYER_NAME], message[128];
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(adminid, x + 2.0, y, z);
    GetPlayerName(targetid, name, sizeof(name));
    GetPlayerName(adminid, adminName, sizeof(adminName));
    format(message, sizeof(message), "%s                    %s", adminName, name);
    SendClientMessageToAll(-1, message);
    return 1;
}

stock AdminCreateTemplate(adminid, templateTitle[], templateDesc[], templateTime) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "create_template");
    JSON_SetString(json, "templateTitle", templateTitle);
    JSON_SetString(json, "templateDesc", templateDesc);
    JSON_SetInt(json, "templateTime", templateTime);
    JSON_SetInt(json, "admin_id", adminid);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new message[128];
    format(message, sizeof(message), "       '%s'                %d", templateTitle, adminid);
    SendClientMessage(adminid, -1, message);
    return 1;
}

stock AdminEditTemplate(adminid, templateId, templateTitle[], templateDesc[], templateTime) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "edit_template");
    JSON_SetInt(json, "templateId", templateId);
    JSON_SetString(json, "templateTitle", templateTitle);
    JSON_SetString(json, "templateDesc", templateDesc);
    JSON_SetInt(json, "templateTime", templateTime);
    JSON_SetInt(json, "admin_id", adminid);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new message[128];
    format(message, sizeof(message), "       ID %d                        %d", templateId, adminid);
    SendClientMessage(adminid, -1, message);
    return 1;
}

stock AdminDeleteTemplate(adminid, templateId) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "delete_template");
    JSON_SetInt(json, "templateId", templateId);
    JSON_SetInt(json, "admin_id", adminid);

    OnPacketIncoming(adminid, 66, json);
    JSON_Cleanup(json);

    new message[128];
    format(message, sizeof(message), "       ID %d                %d", templateId, adminid);
    SendClientMessage(adminid, -1, message);
    return 1;
}

stock CloseAdminToolsGui(playerid) {
    new Node:json = JSON_Object();
    JSON_SetString(json, "action", "close");
    JSON_SetBool(json, "isNeedClose", true);
    OnPacketIncoming(playerid, 66, json);
    JSON_Cleanup(json);
    return 1;
}