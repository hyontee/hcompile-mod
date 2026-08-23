/*
    Отдельный модуль GUI редактора СМИ.

    Клиентское окно: 24
    Сетевой пакет: 252

    Требуемые библиотеки:
      #include <a_samp>
      #include <Pawn.CMD>
      #include <Pawn.RakNet>

    Подключение:
      1. Подключите этот файл после Pawn.CMD и Pawn.RakNet.
      2. В обработчике IPacket:252 после чтения строки JSON вызовите
         SmiGui_HandleIncomingRaw(playerid, guiid, json_data, length).
      3. Добавьте public OnSmiGuiAccessCheck(playerid).
      4. Добавьте public OnSmiGuiSubmit(playerid, action, const text[]).

    ВАЖНО: русские надписи интерфейса передаются клиенту в UTF-8
    через шестнадцатеричные байты. Сам файл сохранён в Windows-1251.
*/

#if defined _smi_gui_included
    #endinput
#endif
#define _smi_gui_included

#if !defined SMI_GUI_ID
    #define SMI_GUI_ID (24)
#endif
#if !defined SMI_GUI_PACKET_ID
    #define SMI_GUI_PACKET_ID (252)
#endif
#if !defined SMI_GUI_MAX_TEXT
    #define SMI_GUI_MAX_TEXT (120)
#endif
#if !defined SMI_GUI_SEND_BUFFER
    #define SMI_GUI_SEND_BUFFER (1024)
#endif

#define SMI_GUI_ACTION_AD   (1)
#define SMI_GUI_ACTION_NEWS (2)

stock SmiGui_ResetPlayer(playerid)
{
    DeletePVar(playerid, "SmiGuiState");
    DeletePVar(playerid, "SmiGuiAction");
    DeletePVar(playerid, "SmiGuiHasText");
    DeletePVar(playerid, "SmiGuiPendingText");
    DeletePVar(playerid, "SmiGuiAlreadySent");
    return 1;
}

stock SmiGui_HasAccess(playerid)
{
    if(funcidx("OnSmiGuiAccessCheck") != -1)
        return CallLocalFunction("OnSmiGuiAccessCheck", "i", playerid);

    // Без настроенного адаптера доступ разрешён только RCON-администраторам.
    return IsPlayerAdmin(playerid);
}

stock SmiGui_SendRaw(playerid, guiid, const data[])
{
    if(!IsPlayerConnected(playerid)) return 0;

    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, SMI_GUI_PACKET_ID);
    BS_WriteValue(bs, PR_UINT16, guiid);
    BS_WriteValue(bs, PR_UINT32, strlen(data));
    BS_WriteValue(bs, PR_STRING, data);
    PR_SendPacket(bs, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bs);
    return 1;
}

stock SmiGui_Utf8ToCp1251(const input[], output[], len)
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
            else
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

stock SmiGui_SavePendingText(playerid, const input[])
{
    new fixed[SMI_GUI_MAX_TEXT + 1];
    SmiGui_Utf8ToCp1251(input, fixed, sizeof(fixed));
    SetPVarString(playerid, "SmiGuiPendingText", fixed);
    SetPVarInt(playerid, "SmiGuiHasText", 1);
    return 1;
}

stock SmiGui_GetPendingText(playerid, output[], len)
{
    output[0] = EOS;
    if(GetPVarInt(playerid, "SmiGuiHasText") <= 0) return 0;
    GetPVarString(playerid, "SmiGuiPendingText", output, len);
    return output[0] != EOS;
}

stock SmiGui_IsBadText(const text[])
{
    if(!text[0]) return 1;
    // Русские подписи интерфейса.
    if(!strcmp(text, "\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98", true)) return 1;
    if(!strcmp(text, "\xD0\xA1\xD0\x9C\xD0\x98", true)) return 1;
    if(!strcmp(text, "\xD0\x9E\xD1\x82\xD0\xBF\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x8C", true)) return 1;
    if(!strcmp(text, "\xD0\x9E\xD1\x82\xD0\xBC\xD0\xB5\xD0\xBD\xD0\xB0", true)) return 1;
    if(!strcmp(text, "\xD0\x97\xD0\xB0\xD0\xBA\xD1\x80\xD1\x8B\xD1\x82\xD1\x8C", true)) return 1;

    // Старые подписи оставлены только для совместимости с другими версиями APK.
    if(!strcmp(text, "Redaktor SMI", true)) return 1;
    if(!strcmp(text, "SMI", true)) return 1;
    if(!strcmp(text, "Otpravit", true)) return 1;
    if(!strcmp(text, "Send", true)) return 1;
    if(!strcmp(text, "Submit", true)) return 1;
    if(!strcmp(text, "Otmena", true)) return 1;
    if(!strcmp(text, "Cancel", true)) return 1;
    if(!strcmp(text, "Zakryt", true)) return 1;
    if(!strcmp(text, "Close", true)) return 1;
    return 0;
}

stock SmiGui_RawContains(const raw[], const needle[])
{
    return strfind(raw, needle, true) != -1;
}

stock SmiGui_RawFindKey(const raw[], const key[], &start, &keylen)
{
    start = strfind(raw, key, true);
    if(start == -1) return 0;
    keylen = strlen(key);
    return 1;
}

stock SmiGui_RawExtractText(const raw[], output[], len)
{
    output[0] = EOS;

    new start = -1, keylen = 0;
    if(!SmiGui_RawFindKey(raw, "\"s\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"text\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"input\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"inputtext\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"rt\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"msg\":\"", start, keylen)
    && !SmiGui_RawFindKey(raw, "\"value\":\"", start, keylen)) return 0;

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
                case 'n', 'r', 't': output[out++] = ' ';
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

stock SmiGui_Close(playerid)
{
    SmiGui_SendRaw(playerid, SMI_GUI_ID, "{\"c\":1,\"o\":0,\"t\":0}");
    SmiGui_ResetPlayer(playerid);
    return 1;
}

stock SmiGui_Submit(playerid, action, const input[])
{
    if(GetPVarInt(playerid, "SmiGuiAlreadySent") > 0) return 1;
    if(!SmiGui_HasAccess(playerid)) return SmiGui_Close(playerid);

    new text[SMI_GUI_MAX_TEXT + 1];
    SmiGui_Utf8ToCp1251(input, text, sizeof(text));
    if(!strlen(text) || SmiGui_IsBadText(text)) return 1;

    SetPVarInt(playerid, "SmiGuiAlreadySent", 1);

    if(funcidx("OnSmiGuiSubmit") != -1)
        CallLocalFunction("OnSmiGuiSubmit", "iis", playerid, action, text);
    else
    {
        new name[MAX_PLAYER_NAME], message[190];
        GetPlayerName(playerid, name, sizeof(name));
        format(message, sizeof(message), "[\xD1\xCC\xC8] %s[%d]: %s", name, playerid, text);
        SendClientMessageToAll(0x3399FFFF, message);
    }

    return SmiGui_Close(playerid);
}

stock SmiGui_OpenEditor(playerid, action = SMI_GUI_ACTION_AD)
{
    if(!SmiGui_HasAccess(playerid))
        return SendClientMessage(playerid, 0xFF6666FF, "\xD3 \xE2\xE0\xF1 \xED\xE5\xF2 \xE4\xEE\xF1\xF2\xF3\xEF\xE0 \xEA \xF0\xE5\xE4\xE0\xEA\xF2\xEE\xF0\xF3 \xD1\xCC\xC8."), 1;

    if(action != SMI_GUI_ACTION_NEWS) action = SMI_GUI_ACTION_AD;

    SmiGui_ResetPlayer(playerid);
    SetPVarInt(playerid, "SmiGuiState", 1);
    SetPVarInt(playerid, "SmiGuiAction", action);

    new payload[SMI_GUI_SEND_BUFFER];
    if(action == SMI_GUI_ACTION_NEWS)
    {
        format(payload, sizeof(payload),
            "{\"o\":1,\"t\":2,\"a\":2,\"d\":2,\"s\":1,"
            "\"title\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"n\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"h\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"bn\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"text\":\"\xD0\x92\xD0\xB2\xD0\xB5\xD0\xB4\xD0\xB8\xD1\x82\xD0\xB5\x20\xD1\x82\xD0\xB5\xD0\xBA\xD1\x81\xD1\x82\x20\xD0\xBD\xD0\xBE\xD0\xB2\xD0\xBE\xD1\x81\xD1\x82\xD0\xB8\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"dsc\":\"\xD0\x9D\xD0\xBE\xD0\xB2\xD0\xBE\xD1\x81\xD1\x82\xD1\x8C\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"placeholder\":\"\xD0\xA2\xD0\xB5\xD0\xBA\xD1\x81\xD1\x82\x20\xD0\xBD\xD0\xBE\xD0\xB2\xD0\xBE\xD1\x81\xD1\x82\xD0\xB8\",\"send\":\"\xD0\x9E\xD1\x82\xD0\xBF\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x8C\","
            "\"ok\":\"\xD0\x9E\xD1\x82\xD0\xBF\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x8C\",\"cancel\":\"\xD0\x9E\xD1\x82\xD0\xBC\xD0\xB5\xD0\xBD\xD0\xB0\",\"close\":\"\xD0\x97\xD0\xB0\xD0\xBA\xD1\x80\xD1\x8B\xD1\x82\xD1\x8C\"}"
        );
    }
    else
    {
        format(payload, sizeof(payload),
            "{\"o\":1,\"t\":1,\"a\":1,\"d\":1,\"s\":1,"
            "\"title\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"n\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"h\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"bn\":\"\xD0\xA0\xD0\xB5\xD0\xB4\xD0\xB0\xD0\xBA\xD1\x82\xD0\xBE\xD1\x80\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"text\":\"\xD0\x92\xD0\xB2\xD0\xB5\xD0\xB4\xD0\xB8\xD1\x82\xD0\xB5\x20\xD1\x82\xD0\xB5\xD0\xBA\xD1\x81\xD1\x82\x20\xD0\xBE\xD0\xB1\xD1\x8A\xD1\x8F\xD0\xB2\xD0\xBB\xD0\xB5\xD0\xBD\xD0\xB8\xD1\x8F\x20\xD0\xA1\xD0\x9C\xD0\x98\",\"dsc\":\"\xD0\x9E\xD0\xB1\xD1\x8A\xD1\x8F\xD0\xB2\xD0\xBB\xD0\xB5\xD0\xBD\xD0\xB8\xD0\xB5\x20\xD0\xA1\xD0\x9C\xD0\x98\","
            "\"placeholder\":\"\xD0\xA2\xD0\xB5\xD0\xBA\xD1\x81\xD1\x82\x20\xD0\xBE\xD0\xB1\xD1\x8A\xD1\x8F\xD0\xB2\xD0\xBB\xD0\xB5\xD0\xBD\xD0\xB8\xD1\x8F\",\"send\":\"\xD0\x9E\xD1\x82\xD0\xBF\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x8C\","
            "\"ok\":\"\xD0\x9E\xD1\x82\xD0\xBF\xD1\x80\xD0\xB0\xD0\xB2\xD0\xB8\xD1\x82\xD1\x8C\",\"cancel\":\"\xD0\x9E\xD1\x82\xD0\xBC\xD0\xB5\xD0\xBD\xD0\xB0\",\"close\":\"\xD0\x97\xD0\xB0\xD0\xBA\xD1\x80\xD1\x8B\xD1\x82\xD1\x8C\"}"
        );
    }

    return SmiGui_SendRaw(playerid, SMI_GUI_ID, payload);
}

stock SmiGui_HandleIncomingRaw(playerid, guiid, const raw[], length)
{
    #pragma unused length

    if(guiid != SMI_GUI_ID) return 0;
    if(GetPVarInt(playerid, "SmiGuiState") <= 0) return 0;

    new text[SMI_GUI_MAX_TEXT + 1];

    if(SmiGui_RawExtractText(raw, text, sizeof(text)))
    {
        if(SmiGui_IsBadText(text)) return 1;
        SmiGui_SavePendingText(playerid, text);

        if(SmiGui_RawContains(raw, "\"t\":1"))
            return SmiGui_Submit(playerid, GetPVarInt(playerid, "SmiGuiAction"), text);

        return 1;
    }

    if(SmiGui_RawContains(raw, "\"t\":2") || SmiGui_RawContains(raw, "\"t\":0"))
    {
        if(GetPVarInt(playerid, "SmiGuiAlreadySent") > 0)
            return SmiGui_Close(playerid);

        if(SmiGui_GetPendingText(playerid, text, sizeof(text)))
            return SmiGui_Submit(playerid, GetPVarInt(playerid, "SmiGuiAction"), text);

        return SmiGui_Close(playerid);
    }

    return 1;
}

stock SmiGui_ParseCommand(playerid, const params[])
{
    if(!strcmp(params, "news", true)
    || !strcmp(params, "\xED\xEE\xE2\xEE\xF1\xF2\xFC", true))
        return SmiGui_OpenEditor(playerid, SMI_GUI_ACTION_NEWS);

    return SmiGui_OpenEditor(playerid, SMI_GUI_ACTION_AD);
}

// В исходном моде команды уже существуют. Перед подключением include
// задайте SMI_GUI_DISABLE_COMMANDS, чтобы не получить повторное определение.
#if !defined SMI_GUI_DISABLE_COMMANDS
CMD:smieditor(playerid, params[])
{
    return SmiGui_ParseCommand(playerid, params);
}

CMD:smi_editor(playerid, params[])
{
    return SmiGui_ParseCommand(playerid, params);
}
#endif
