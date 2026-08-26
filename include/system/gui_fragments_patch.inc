/*
    GUI patch:  ,  ,  BlackPass.
     :       CEF GUI-: RentGuiFragment=6, GUISmiEditor=24.
         .
*/
#if defined _inc_gui_fragments_patch
    #endinput
#endif
#define _inc_gui_fragments_patch

#if !defined RentGuiFragment
    #define RentGuiFragment 6
#endif
#if !defined GUISmiEditor
    #define GUISmiEditor 24
#endif
#if !defined BPBannerComposeGUIFrag
    #define BPBannerComposeGUIFrag 35
#endif
#if !defined GUI_PATCH_SHARED_GUI
    #define GUI_PATCH_SHARED_GUI 66 //   : 66 = AdminTools   
#endif

#define GUI_PATCH_ACTION_CONFIRM 9001
#define GUI_PATCH_ACTION_CANCEL  9002
#define GUI_PATCH_ACTION_BACK    9003

forward GuiBlackPass_ShowAuto(playerid);

stock GuiPatch_GetIntAny(Node:json, &value, k1[], k2[] = "", k3[] = "", k4[] = "", k5[] = "", k6[] = "")
{
    if(JSON_GetInt(json, k1, value)) return 1;
    if(k2[0] && JSON_GetInt(json, k2, value)) return 1;
    if(k3[0] && JSON_GetInt(json, k3, value)) return 1;
    if(k4[0] && JSON_GetInt(json, k4, value)) return 1;
    if(k5[0] && JSON_GetInt(json, k5, value)) return 1;
    if(k6[0] && JSON_GetInt(json, k6, value)) return 1;
    return 0;
}

stock GuiPatch_GetStringAny(Node:json, output[], len, k1[], k2[] = "", k3[] = "", k4[] = "", k5[] = "", k6[] = "")
{
    output[0] = EOS;
    if(JSON_GetString(json, k1, output, len)) return 1;
    if(k2[0] && JSON_GetString(json, k2, output, len)) return 1;
    if(k3[0] && JSON_GetString(json, k3, output, len)) return 1;
    if(k4[0] && JSON_GetString(json, k4, output, len)) return 1;
    if(k5[0] && JSON_GetString(json, k5, output, len)) return 1;
    if(k6[0] && JSON_GetString(json, k6, output, len)) return 1;
    return 0;
}

stock GuiPatch_ActionFromText(text[])
{
    if(!text[0]) return -1;
    if(!strcmp(text, "confirm", true) || !strcmp(text, "submit", true) || !strcmp(text, "send", true) || !strcmp(text, "ok", true) || !strcmp(text, "yes", true) || !strcmp(text, "save", true) || !strcmp(text, "publish", true)) return GUI_PATCH_ACTION_CONFIRM;
    if(!strcmp(text, "", true) || !strcmp(text, "", true) || !strcmp(text, "", true) || !strcmp(text, "", true)) return GUI_PATCH_ACTION_CONFIRM;
    if(!strcmp(text, "cancel", true) || !strcmp(text, "close", true) || !strcmp(text, "back", true) || !strcmp(text, "no", true) || !strcmp(text, "exit", true)) return GUI_PATCH_ACTION_CANCEL;
    if(!strcmp(text, "", true) || !strcmp(text, "", true) || !strcmp(text, "", true)) return GUI_PATCH_ACTION_CANCEL;
    if(text[0] >= '0' && text[0] <= '9') return strval(text);
    return -1;
}

stock GuiPatch_GetAction(Node:json)
{
    new action = -1;
    if(GuiPatch_GetIntAny(json, action, "bi", "b", "a", "action", "id", "button")) return action;
    if(GuiPatch_GetIntAny(json, action, "btn", "type", "tid", "item_id", "button_id", "sid")) return action;

    new row = -1;
    if(GuiPatch_GetIntAny(json, row, "row", "listitem", "index", "i", "slot", "selected") && row >= 0) return row + 1;

    if(GuiPatch_GetIntAny(json, action, "v", "value", "item", "itemid", "cmd", "p")) return action;

    new tmp[32];
    if(GuiPatch_GetStringAny(json, tmp, sizeof(tmp), "action", "a", "event", "button", "btn", "type"))
    {
        action = GuiPatch_ActionFromText(tmp);
        if(action != -1) return action;
    }
    if(GuiPatch_GetStringAny(json, tmp, sizeof(tmp), "id", "value", "item", "itemid", "bi", "b"))
    {
        action = GuiPatch_ActionFromText(tmp);
        if(action != -1) return action;
    }
    return -1;
}

stock GuiPatch_GetText(Node:json, output[], len)
{
    //    .
    if(GuiPatch_GetStringAny(json, output, len, "rt", "inputtext", "input", "text", "message", "msg")) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "content", "value", "textarea", "edit", "data", "comment")) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "be", "desc", "description", "str", "string", "result")) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "res", "payload", "s", "v", "p", "m")) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "bn", "name", "title", "n", "h", "d")) return 1;
    output[0] = EOS;
    return 0;
}

stock GuiPatch_CloseCEF(playerid, guiid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "c", 1);
    JSON_SetInt(json, "o", 0);
    OnPacketIncoming(playerid, guiid, json);
    JSON_Cleanup(json);
    return 1;
}

stock Node:GuiPatch_MakeButton(button_id, name[], desc[])
{
    new Node:item = JSON_Object();
    JSON_SetInt(item, "bi", button_id);
    JSON_SetInt(item, "b", button_id);
    JSON_SetInt(item, "id", button_id);
    JSON_SetInt(item, "a", button_id);
    JSON_SetInt(item, "action", button_id);
    JSON_SetString(item, "bn", name, strlen(name));
    JSON_SetString(item, "be", desc, strlen(desc));
    JSON_SetString(item, "name", name, strlen(name));
    JSON_SetString(item, "title", name, strlen(name));
    JSON_SetString(item, "desc", desc, strlen(desc));
    return item;
}

stock GuiRent_GetSpawnData(playerid, &Float:sx, &Float:sy, &Float:sz, &Float:sa)
{
    new spot = GetPVarInt(playerid, "transport_spot_id");
    if(spot >= 0 && spot < TotalTransportSpots)
    {
        sx = TransportSpots[spot][tSpawnX];
        sy = TransportSpots[spot][tSpawnY];
        sz = TransportSpots[spot][tSpawnZ];
        sa = TransportSpots[spot][tSpawnAngle];
        return 1;
    }

    new Float:px, Float:py, Float:pz, Float:pa;
    GetPlayerPos(playerid, px, py, pz);
    GetPlayerFacingAngle(playerid, pa);

    new nearest = -1;
    new Float:best = 999999.0;
    for(new i = 0; i < TotalTransportSpots; i++)
    {
        new Float:dist = floatsqroot(floatpower(px - TransportSpots[i][tPickupX], 2.0) + floatpower(py - TransportSpots[i][tPickupY], 2.0) + floatpower(pz - TransportSpots[i][tPickupZ], 2.0));
        if(dist < best)
        {
            best = dist;
            nearest = i;
        }
    }

    if(nearest != -1 && best <= 25.0)
    {
        SetPVarInt(playerid, "transport_spot_id", nearest);
        sx = TransportSpots[nearest][tSpawnX];
        sy = TransportSpots[nearest][tSpawnY];
        sz = TransportSpots[nearest][tSpawnZ];
        sa = TransportSpots[nearest][tSpawnAngle];
        return 1;
    }

    sx = px + 2.0;
    sy = py + 2.0;
    sz = pz + 0.5;
    sa = pa;
    return 1;
}

stock GuiRent_Open(playerid)
{
    SetPVarInt(playerid, "GuiRentState", 1);

    new n1[48], d1[128], n2[48], d2[128];
    format(n1, sizeof(n1), " ");
    format(d1, sizeof(d1), "      ");
    format(n2, sizeof(n2), "  ");
    format(d2, sizeof(d2), "   ");

    new Node:b1 = GuiPatch_MakeButton(1, n1, d1);
    new Node:b2 = GuiPatch_MakeButton(2, n2, d2);
    new Node:buttons = JSON_Array();
    JSON_ArrayAppend(buttons, "", b1);
    JSON_ArrayAppend(buttons, "", b2);
    new Node:json = JSON_Object();

    JSON_SetInt(json, "t", 6);
    JSON_SetInt(json, "o", 1);
    JSON_SetString(json, "bn", " ");
    JSON_SetString(json, "n", " ");
    JSON_SetString(json, "h", " ");
    JSON_SetString(json, "d", " ");
    JSON_SetArray(json, "bt", buttons);

    OnPacketIncoming(playerid, RentGuiFragment, json);

    JSON_Cleanup(json);
    JSON_Cleanup(buttons);
    JSON_Cleanup(b1);
    JSON_Cleanup(b2);
    return 1;
}

stock GuiRent_ShowPersonalCars(playerid)
{
    SetPVarInt(playerid, "GuiRentState", 2);

    new Node:buttons = JSON_Array();
    new count = 0;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] == 0) continue;

        new name[64], desc[96];
        format(name, sizeof(name), "#%d %s", i + 1, GetVehicleNameByModel(VehicleInfo[playerid][i][vModel]));
        if(VehicleInfo[playerid][i][vSpawned]) format(desc, sizeof(desc), " . ,    .");
        else format(desc, sizeof(desc), "  . ,    .");

        new Node:item = GuiPatch_MakeButton(100 + i, name, desc);
        JSON_ArrayAppend(buttons, "", item);
        count++;
    }

    if(count == 0)
    {
        DeletePVar(playerid, "GuiRentState");
        JSON_Cleanup(buttons);
        return ShowNotification(playerid, 0, 5, 0, 0, "    ", ""), 1;
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 6);
    JSON_SetInt(json, "o", 1);
    JSON_SetString(json, "bn", " ");
    JSON_SetString(json, "n", " ");
    JSON_SetString(json, "h", " ");
    JSON_SetString(json, "d", "   ");
    JSON_SetArray(json, "bt", buttons);

    OnPacketIncoming(playerid, RentGuiFragment, json);

    JSON_Cleanup(json);
    JSON_Cleanup(buttons);
    return 1;
}

stock GuiRent_RemoveActive(playerid)
{
    if(RentVehicle[playerid] == INVALID_VEHICLE_ID)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "    ", "");
        return 1;
    }
    DestroyVehicle(RentVehicle[playerid]);
    RentVehicle[playerid] = INVALID_VEHICLE_ID;
    KillTimer(RentTimer[playerid]);
    ShowNotification(playerid, 1, 5, 0, 0, "  ", "");
    return 1;
}

stock GuiRent_CallPersonalCar(playerid, car_index)
{
    if(car_index < 0 || car_index >= MAX_PLAYER_VEHICLES) return 1;
    if(VehicleInfo[playerid][car_index][vModel] == 0) return 1;

    new Float:sx, Float:sy, Float:sz, Float:sa;
    GuiRent_GetSpawnData(playerid, sx, sy, sz, sa);

    if(VehicleInfo[playerid][car_index][vSpawned] && VehicleInfo[playerid][car_index][vID] != INVALID_VEHICLE_ID)
    {
        SetVehiclePos(VehicleInfo[playerid][car_index][vID], sx, sy, sz);
        SetVehicleZAngle(VehicleInfo[playerid][car_index][vID], sa);
        PutPlayerInVehicle(playerid, VehicleInfo[playerid][car_index][vID], 0);
        ShowNotification(playerid, 1, 5, 0, 0, "  ", "");
        return 1;
    }

    if(VehicleInfo[playerid][car_index][vID] != INVALID_VEHICLE_ID) DestroyVehicle(VehicleInfo[playerid][car_index][vID]);
    VehicleInfo[playerid][car_index][vID] = CreateVehicle(CreateSafeVehicleModel(VehicleInfo[playerid][car_index][vModel]), sx, sy, sz, sa, VehicleInfo[playerid][car_index][vColor][0], VehicleInfo[playerid][car_index][vColor][1], 60000);
    VehicleInfo[playerid][car_index][vSpawned] = true;
    SetVehicleParamsInit(VehicleInfo[playerid][car_index][vID]);
    ApplySpectreVisual(playerid, car_index);
    PutPlayerInVehicle(playerid, VehicleInfo[playerid][car_index][vID], 0);
    ShowNotification(playerid, 1, 5, 0, 0, "  ", "");
    return 1;
}

stock GuiRent_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid
    #pragma unused dialogid
    #pragma unused response
    #pragma unused listitem
    #pragma unused inputtext
    return 0;
}

stock GuiRent_HandlePacket(playerid, Node:json)
{
    //  RentGuiFragment    .   ,   GUI.
    return GuiRent_HandleShared(playerid, json, 0, 0, GuiPatch_GetAction(json), 0);
}

CMD:rent(playerid, params[])
{
    #pragma unused params
    return GuiRent_Open(playerid);
}

CMD:arenda(playerid, params[])
{
    #pragma unused params
    return GuiRent_Open(playerid);
}

CMD:rentgui(playerid, params[])
{
    #pragma unused params
    return GuiRent_Open(playerid);
}



stock GuiSmi_Utf8ToCp1251(const input[], output[], len)
{
    output[0] = EOS;
    new out = 0;
    for(new i = 0; input[i] != EOS && out < len - 1; i++)
    {
        new c = input[i];
        if(c < 0) c += 256;

        if((c == 208 || c == 209) && input[i + 1] != EOS)
        {
            new n = input[i + 1];
            if(n < 0) n += 256;

            if(c == 208)
            {
                if(n == 129) { output[out++] = 168; i++; continue; }
                if(n >= 144 && n <= 191) { output[out++] = n + 48; i++; continue; }
            }
            else if(c == 209)
            {
                if(n >= 128 && n <= 143) { output[out++] = n + 112; i++; continue; }
                if(n == 145) { output[out++] = 184; i++; continue; }
            }
        }

        output[out++] = c;
    }
    output[out] = EOS;
    return 1;
}

stock GuiSmi_NormalizeText(const input[], output[], len)
{
    return GuiSmi_Utf8ToCp1251(input, output, len);
}

stock GuiSmi_SavePendingText(playerid, const text[])
{
    new fixed[512];
    GuiSmi_NormalizeText(text, fixed, sizeof(fixed));
    SetPVarString(playerid, "GuiSmiPendingText", fixed);
    SetPVarInt(playerid, "GuiSmiHasText", 1);
    return 1;
}

stock GuiSmi_GetPendingText(playerid, output[], len)
{
    output[0] = EOS;
    if(GetPVarInt(playerid, "GuiSmiHasText") <= 0) return 0;
    GetPVarString(playerid, "GuiSmiPendingText", output, len);
    return output[0] != EOS;
}

stock GuiSmi_ClearPendingText(playerid)
{
    DeletePVar(playerid, "GuiSmiPendingText");
    DeletePVar(playerid, "GuiSmiHasText");
    return 1;
}

stock GuiSmi_PublishDirect(playerid, action, const input[])
{
    new fixed[512];
    GuiSmi_NormalizeText(input, fixed, sizeof(fixed));
    if(!strlen(fixed)) return 1;

    new msg[220];
    switch(action)
    {
        case 2:
        {
            if(!Smi_IsStaff(playerid)) return 1;
            format(msg, sizeof(msg), "[ÑÌÈ] %s[%d]: %s", Player[playerid][pName], playerid, fixed);
            SendClientMessageToAll(0x3399FFFF, msg);
            FactionGUI_AddTaskProgress(playerid, 3, 1);
        }
        default:
        {
            if(!Smi_IsStaff(playerid)) return 1;
            format(msg, sizeof(msg), "[ÑÌÈ] %s[%d]: %s", Player[playerid][pName], playerid, fixed);
            SendClientMessageToAll(0x3399FFFF, msg);
            FactionGUI_AddTaskProgress(playerid, 3, 1);
        }
    }
    return 1;
}

stock GuiSmi_Submit(playerid, action, input[])
{
    new params[512];
    GuiSmi_NormalizeText(input, params, sizeof(params));

    switch(action)
    {
        case 1: return GuiSmi_PublishDirect(playerid, 1, params);
        case 2: return GuiSmi_PublishDirect(playerid, 2, params);
        case 3:
        {
            if(!Smi_IsStaff(playerid)) return 1;
            if(!strlen(params)) return 1;
            return callcmd::live(playerid, params);
        }
        case 4:
        {
            params[0] = EOS;
            return callcmd::endlive(playerid, params);
        }
    }
    return 1;
}

/*
         Android GUI BrDialogWindow = 10.
      ShowPlayerDialog SA-MP.    APK  EditText  .
    GUISmiEditor = 24   APK    ,    
      BrDialogWindow:    packet 252 / guiid 10.
*/
stock GuiSmi_OpenEditorEx(playerid, guiid, action)
{
    if(!Smi_IsStaff(playerid))
        return 1;

    SetPVarInt(playerid, "GuiSmiState", 1);
    SetPVarInt(playerid, "GuiSmiEditAction", action);
    SetPVarInt(playerid, "GuiSmiGuiId", guiid);
    DeletePVar(playerid, "GuiSmiSniff");

    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "t", action);
    JSON_SetInt(json, "a", action);
    JSON_SetInt(json, "d", action);
    JSON_SetInt(json, "s", 1);
    JSON_SetString(json, "title", "Redaktor SMI");
    JSON_SetString(json, "n", "Redaktor SMI");
    JSON_SetString(json, "h", "Redaktor SMI");
    JSON_SetString(json, "bn", "Redaktor SMI");
    if(action == 2)
    {
        JSON_SetString(json, "text", "Vvedite tekst novosti SMI");
        JSON_SetString(json, "dsc", "Novost SMI");
        JSON_SetString(json, "placeholder", "Tekst novosti");
    }
    else
    {
        JSON_SetString(json, "text", "Vvedite tekst obyavleniya SMI");
        JSON_SetString(json, "dsc", "Obyavlenie SMI");
        JSON_SetString(json, "placeholder", "Tekst obyavleniya");
    }
    JSON_SetString(json, "send", "Otpravit");
    JSON_SetString(json, "ok", "Otpravit");
    JSON_SetString(json, "cancel", "Otmena");
    JSON_SetString(json, "close", "Zakryt");

    ShowPlayerGUI(playerid, guiid, json);
    JSON_Cleanup(json);


    return 1;
}

stock GuiSmi_OpenEditor(playerid)
{
    return GuiSmi_OpenEditorEx(playerid, GUISmiEditor, 1);
}

stock GuiSmi_HandleBrDialogPacket(playerid, Node:json)
{
    // : BrDialogWindow = 10   -   .
    return 0;
}

stock GuiSmi_SendClose(playerid)
{
    // Close native GUISmiEditor=24 on client.
    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    JSON_SetInt(close_json, "o", 0);
    JSON_SetInt(close_json, "t", 0);
    OnPacketIncoming(playerid, GUISmiEditor, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "GuiSmiState");
    DeletePVar(playerid, "GuiSmiBrWindow");
    DeletePVar(playerid, "GuiSmiEditAction");
    DeletePVar(playerid, "GuiSmiGuiId");
    DeletePVar(playerid, "GuiSmiSniff");
    DeletePVar(playerid, "GuiSmiAlreadySent");
    GuiSmi_ClearPendingText(playerid);
    return 1;
}

stock GuiSmi_SendQueueUpdate(playerid, const text[] = "")
{
    #pragma unused playerid
    #pragma unused text
    return 1;
}

stock GuiSmi_SubmitNative(playerid, const text[])
{
    return GuiSmi_Submit(playerid, 1, text);
}

stock GuiSmi_IsBadText(const output[])
{
    if(!output[0]) return 1;
    if(!strcmp(output, "Redaktor SMI", true)) return 1;
    if(!strcmp(output, "SMI", true)) return 1;
    if(!strcmp(output, "Otpravit", true)) return 1;
    if(!strcmp(output, "Send", true)) return 1;
    if(!strcmp(output, "Submit", true)) return 1;
    if(!strcmp(output, "Otmena", true)) return 1;
    if(!strcmp(output, "Cancel", true)) return 1;
    if(!strcmp(output, "Zakryt", true)) return 1;
    if(!strcmp(output, "Close", true)) return 1;
    return 0;
}

stock GuiSmi_GetNativeText(Node:json, output[], len)
{
    output[0] = EOS;
    if(GuiPatch_GetStringAny(json, output, len, "s", "text", "input", "inputtext", "rt", "msg") && !GuiSmi_IsBadText(output)) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "message", "content", "value", "textarea", "edit", "data") && !GuiSmi_IsBadText(output)) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "comment", "desc", "description", "str", "string", "result") && !GuiSmi_IsBadText(output)) return 1;
    if(GuiPatch_GetStringAny(json, output, len, "res", "payload", "v", "p", "m", "i") && !GuiSmi_IsBadText(output)) return 1;
    output[0] = EOS;
    return 0;
}



stock GuiSmi_RawContains(const raw[], const needle[])
{
    return strfind(raw, needle, true) != -1;
}

stock GuiSmi_RawFindKey(const raw[], const key[], &start, &keylen)
{
    start = strfind(raw, key, true);
    if(start == -1) return 0;
    keylen = strlen(key);
    return 1;
}

stock GuiSmi_RawExtractText(const raw[], output[], len)
{
    output[0] = EOS;

    new start = -1, keylen = 0;
    if(!GuiSmi_RawFindKey(raw, "\"s\":\"", start, keylen)
    && !GuiSmi_RawFindKey(raw, "\"text\":\"", start, keylen)
    && !GuiSmi_RawFindKey(raw, "\"input\":\"", start, keylen)
    && !GuiSmi_RawFindKey(raw, "\"rt\":\"", start, keylen)
    && !GuiSmi_RawFindKey(raw, "\"msg\":\"", start, keylen)
    && !GuiSmi_RawFindKey(raw, "\"value\":\"", start, keylen)) return 0;

    start += keylen;
    new out = 0;
    for(new i = start; raw[i] != EOS && out < len - 1; i++)
    {
        if(raw[i] == '"') break;
        if(raw[i] == '\\')
        {
            i++;
            if(raw[i] == EOS) break;
            switch(raw[i])
            {
                case 'n': output[out++] = ' ';
                case 'r': output[out++] = ' ';
                case 't': output[out++] = ' ';
                case '"': output[out++] = '"';
                case '\\': output[out++] = '\\';
                default: output[out++] = raw[i];
            }
            continue;
        }
        output[out++] = raw[i];
    }
    output[out] = EOS;
    return out > 0;
}

stock GuiSmi_SubmitRawPacket(playerid, const raw[])
{
    if(GetPVarInt(playerid, "GuiSmiAlreadySent") > 0) return 1;

    new text[512];
    if(!GuiSmi_RawExtractText(raw, text, sizeof(text)))
    {
        return 1;
    }

    if(GuiSmi_IsBadText(text))
    {
        return 1;
    }

    new action = GetPVarInt(playerid, "GuiSmiEditAction");
    if(action <= 0) action = 1;

    new fixed[512];
    GuiSmi_NormalizeText(text, fixed, sizeof(fixed));
    if(!strlen(fixed))
    {
        return 1;
    }

    new msg[288];
    if(action == 2)
    {
        format(msg, sizeof(msg), "[ÑÌÈ] %s[%d]: %s", Player[playerid][pName], playerid, fixed);
        SendClientMessageToAll(0x3399FFFF, msg);
    }
    else
    {
        format(msg, sizeof(msg), "[ÑÌÈ] %s[%d]: %s", Player[playerid][pName], playerid, fixed);
        SendClientMessageToAll(0x3399FFFF, msg);
    }

    SetPVarInt(playerid, "GuiSmiAlreadySent", 1);
    GuiSmi_SendClose(playerid);
    return 1;
}

stock GuiSmi_HandleRawPacket(playerid, const raw[], length)
{
    #pragma unused length

    new text[512];

    if(GuiSmi_RawExtractText(raw, text, sizeof(text)))
    {
        if(GuiSmi_IsBadText(text)) return 1;
        GuiSmi_SavePendingText(playerid, text);

        if(GuiSmi_RawContains(raw, "\"t\":1"))
        {
            return GuiSmi_SubmitRawPacket(playerid, raw);
        }
        return 1;
    }

    if(GuiSmi_RawContains(raw, "\"t\":2"))
    {
        if(GetPVarInt(playerid, "GuiSmiAlreadySent") > 0)
        {
            GuiSmi_SendClose(playerid);
            return 1;
        }
        if(GuiSmi_GetPendingText(playerid, text, sizeof(text)))
        {
            GuiSmi_SendClose(playerid);
            return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
        }
        return 1;
    }

    if(GuiSmi_RawContains(raw, "\"t\":0"))
    {
        // In this APK GUISmiEditor sometimes sends t=0 after pressing Send.
        // If we already received/cached text from the editor, treat this packet as final submit.
        if(GuiSmi_GetPendingText(playerid, text, sizeof(text)))
        {
            SetPVarInt(playerid, "GuiSmiAlreadySent", 1);
            GuiSmi_SendClose(playerid);
            return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
        }
        GuiSmi_SendClose(playerid);
        return 1;
    }

    return 0;
}

stock GuiSmi_HandlePacket(playerid, Node:json)
{
    new text[512], type = -1;
    JSON_GetInt(json, "t", type);

    if(GuiSmi_GetNativeText(json, text, sizeof(text)) && strlen(text) > 0)
    {
        GuiSmi_SavePendingText(playerid, text);
        if(type == 1)
        {
            SetPVarInt(playerid, "GuiSmiAlreadySent", 1);
            GuiSmi_SendClose(playerid);
            return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
        }
        return 1;
    }

    if(type == 2)
    {
        if(GetPVarInt(playerid, "GuiSmiAlreadySent") > 0)
        {
            GuiSmi_SendClose(playerid);
            return 1;
        }
        if(GuiSmi_GetPendingText(playerid, text, sizeof(text)))
        {
            GuiSmi_SendClose(playerid);
            return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
        }
        return 1;
    }

    if(type == 0)
    {
        // Some client builds use t=0 as the last packet after Send.
        // Publish cached text if it exists, otherwise just close.
        if(GuiSmi_GetPendingText(playerid, text, sizeof(text)))
        {
            SetPVarInt(playerid, "GuiSmiAlreadySent", 1);
            GuiSmi_SendClose(playerid);
            return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
        }
        GuiSmi_SendClose(playerid);
        return 1;
    }
    return 1;
}

stock GuiSmi_HandleShared(playerid, Node:json, screenType, buttonId, tableButtonId, closeFlag)
{
    #pragma unused screenType
    #pragma unused buttonId
    #pragma unused tableButtonId
    if(GetPVarInt(playerid, "GuiSmiState") <= 0) return 0;
    if(closeFlag == 1) return GuiSmi_SendClose(playerid);
    return GuiSmi_HandlePacket(playerid, json);
}

stock GuiSmi_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid
    #pragma unused dialogid
    #pragma unused response
    #pragma unused listitem
    #pragma unused inputtext
    return 0;
}


stock GuiSmi_OpenNewsEditor(playerid)
{
    return GuiSmi_OpenEditorEx(playerid, GUISmiEditor, 2);
}

stock GuiSmi_ParseCommand(playerid, params[])
{
    if(!isnull(params))
    {
        if(!strcmp(params, "news", true) || !strcmp(params, "", true)) return GuiSmi_OpenNewsEditor(playerid);
    }
    return GuiSmi_OpenEditor(playerid);
}

CMD:smieditor(playerid, params[])
{
    return GuiSmi_ParseCommand(playerid, params);
}

CMD:smi_editor(playerid, params[])
{
    return GuiSmi_ParseCommand(playerid, params);
}

CMD:smiguitest(playerid, params[])
{
    new guiid = GUISmiEditor;
    if(!isnull(params)) guiid = strval(params);
    if(guiid <= 0 || guiid == 10 || guiid == 66)
        return 1;
    return GuiSmi_OpenEditorEx(playerid, guiid, 1);
}


CMD:smisend(playerid, params[])
{
    #pragma unused params
    new text[512];
    if(!GuiSmi_GetPendingText(playerid, text, sizeof(text)))
        return 1;
    GuiSmi_SendClose(playerid);
    return GuiSmi_Submit(playerid, GetPVarInt(playerid, "GuiSmiEditAction") ? GetPVarInt(playerid, "GuiSmiEditAction") : 1, text);
}

CMD:smidbg(playerid, params[])
{
    #pragma unused params
    if(GetPVarInt(playerid, "GuiSmiSniff"))
    {
        DeletePVar(playerid, "GuiSmiSniff");
        return 1;
    }
    DeletePVar(playerid, "GuiSmiSniff");
    return 1;
}

stock GuiRent_HandleShared(playerid, Node:json, screenType, buttonId, tableButtonId, closeFlag)
{
    #pragma unused screenType
    new rent_state = GetPVarInt(playerid, "GuiRentState");
    if(rent_state <= 0) return 0;

    if(closeFlag == 1)
    {
        DeletePVar(playerid, "GuiRentState");
        return 1;
    }

    new action = tableButtonId;
    if(action <= 0) action = buttonId;
    if(action <= 0) action = GuiPatch_GetAction(json);

    if(action == GUI_PATCH_ACTION_CANCEL || action == GUI_PATCH_ACTION_BACK || action == 0)
    {
        DeletePVar(playerid, "GuiRentState");
        return 1;
    }

    if(rent_state == 1)
    {
        switch(action)
        {
            case 1: return GuiRent_ShowPersonalCars(playerid);
            case 2:
            {
                DeletePVar(playerid, "GuiRentState");
                GuiPatch_CloseCEF(playerid, RentGuiFragment);
                return GuiRent_RemoveActive(playerid);
            }
        }
        return 1;
    }

    if(rent_state == 2)
    {
        if(action >= 100 && action < 100 + MAX_PLAYER_VEHICLES)
        {
            DeletePVar(playerid, "GuiRentState");
            GuiPatch_CloseCEF(playerid, RentGuiFragment);
            return GuiRent_CallPersonalCar(playerid, action - 100);
        }
        return 1;
    }
    return 1;
}

stock GuiPatch_HandleSharedGUI(playerid, Node:json, screenType, buttonId, tableButtonId, closeFlag)
{
    if(GetPVarInt(playerid, "GuiRentState") > 0) return GuiRent_HandleShared(playerid, json, screenType, buttonId, tableButtonId, closeFlag);
    if(GetPVarInt(playerid, "GuiSmiState") > 0) return GuiSmi_HandleShared(playerid, json, screenType, buttonId, tableButtonId, closeFlag);
    return 0;
}

stock GuiBlackPass_OpenMain(playerid)
{
    new Node:bp_json = JSON_Object();
    JSON_SetInt(bp_json, "t", -2);
    new result = BlackPass_HandlePacket(playerid, bp_json);
    JSON_Cleanup(bp_json);
    return result;
}

stock GuiBlackPass_OpenBanner(playerid)
{
    if(!BlackPass_LoadPlayer(playerid)) return 1;

    new level = BlackPass_GetCurrentLevel(playerid);
    new exp = g_blackpass_player[playerid][BP_EXPERIENCE];
    new need = BLACKPASS_LEVEL_EXP;
    new current = exp % BLACKPASS_LEVEL_EXP;
    new premium = BP_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "lv", level);
    JSON_SetInt(json, "level", level);
    JSON_SetInt(json, "exp", current);
    JSON_SetInt(json, "need", need);
    JSON_SetInt(json, "allExp", exp);
    JSON_SetInt(json, "premium", premium);
    JSON_SetString(json, "n", "BLACK PASS");
    JSON_SetString(json, "h", "  BlackPass");
    JSON_SetString(json, "d", " ,      .");
    JSON_SetString(json, "b", " BlackPass");
    JSON_SetString(json, "btn", "");

    ShowPlayerGUI(playerid, BPBannerComposeGUIFrag, json);
    JSON_Cleanup(json);
    return 1;
}

public GuiBlackPass_ShowAuto(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!IsPlayerLogged(playerid)) return 1;
    if(GetPVarInt(playerid, "BP_BANNER_AUTO_SHOWN")) return 1;
    SetPVarInt(playerid, "BP_BANNER_AUTO_SHOWN", 1);
    return GuiBlackPass_OpenBanner(playerid);
}

stock GuiBlackPass_HandleBanner(playerid, Node:json)
{
    #pragma unused json
    return GuiBlackPass_OpenMain(playerid);
}

CMD:bpbanner(playerid, params[])
{
    #pragma unused params
    return GuiBlackPass_OpenBanner(playerid);
}

CMD:bpban(playerid, params[])
{
    #pragma unused params
    return GuiBlackPass_OpenBanner(playerid);
}
