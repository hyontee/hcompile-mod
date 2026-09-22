//>> Файл: bykranin_src/core/admin/admin_05.inc  (333 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: ReportGUI_IsAdminAuthorized, ReportGUI_CountPending, ReportGUI_UpdateCounter, ReportGUI_ClearAdminState, ReportGUI_Enqueue, ReportGUI_RequeueActive, ReportGUI_Dequeue
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#define REPORT_GUI_ID              (66)
#define REPORT_GUI_QUEUE_MAX       (128)
#define REPORT_GUI_TEXT_MAX        (144)

new g_report_gui_player[REPORT_GUI_QUEUE_MAX];
new g_report_gui_account[REPORT_GUI_QUEUE_MAX];
new g_report_gui_text[REPORT_GUI_QUEUE_MAX][REPORT_GUI_TEXT_MAX];
new g_report_gui_head;
new g_report_gui_tail;
new g_report_gui_count;
new g_report_counter_last = -1;

stock ReportGUI_IsAdminAuthorized(playerid)
{
    return IsPlayerConnected(playerid)
        && GetPlayerAdminEx(playerid) >= 1
        && GetPlayerData(playerid, P_ADMIN_LOGGED);
}

stock ReportGUI_CountPending()
{
    new count;

    // Считаем только живые жалобы в очереди.
    for(new offset; offset < g_report_gui_count; offset++)
    {
        new queue_index = (g_report_gui_head + offset) % REPORT_GUI_QUEUE_MAX;
        new targetid = g_report_gui_player[queue_index];
        if(!IsPlayerConnected(targetid)) continue;
        if(GetPlayerAccountID(targetid) != g_report_gui_account[queue_index]) continue;
        count++;
    }

    // Жалоба, которую администратор уже открыл, всё ещё считается необработанной.
    foreach(new adminid : Player)
    {
        if(!GetPVarInt(adminid, "REPORT_GUI_ACTIVE")) continue;
        new targetid = GetPVarInt(adminid, "ANS_TARGET");
        if(!IsPlayerConnected(targetid)) continue;
        if(GetPlayerAccountID(targetid) != GetPVarInt(adminid, "ANS_TARGET_ACCOUNT")) continue;
        count++;
    }
    return count;
}

stock ReportGUI_UpdateCounter()
{
    new count = ReportGUI_CountPending();

    // Обновляем строку принудительно. В моде остались старые функции UpdateReportText*,
    // которые тоже меняют этот TextDraw; ежесекундная запись гарантирует, что REP
    // всегда показывает очередь новой системы репортов, а не устаревший счётчик.
    new counter_text[20];
    format(counter_text, sizeof counter_text, "REP:_%d", count);
    TextDrawSetString(report_edit_TD, counter_text);
    g_report_counter_last = count;
    return 1;
}

stock ReportGUI_ClearAdminState(playerid)
{
    DeletePVar(playerid, "REPORT_GUI_ACTIVE");
    DeletePVar(playerid, "REPORT_GUI_CUSTOM");
    DeletePVar(playerid, "ANS_TARGET");
    DeletePVar(playerid, "ANS_TARGET_ACCOUNT");
    DeletePVar(playerid, "ANS_TEXT");
    ReportGUI_UpdateCounter();
    return 1;
}

stock ReportGUI_Enqueue(playerid, const text[])
{
    if(g_report_gui_count >= REPORT_GUI_QUEUE_MAX) return 0;

    g_report_gui_player[g_report_gui_tail] = playerid;
    g_report_gui_account[g_report_gui_tail] = GetPlayerAccountID(playerid);
    format(g_report_gui_text[g_report_gui_tail], REPORT_GUI_TEXT_MAX, "%s", text);

    g_report_gui_tail = (g_report_gui_tail + 1) % REPORT_GUI_QUEUE_MAX;
    g_report_gui_count++;
    return 1;
}

stock ReportGUI_RequeueActive(playerid)
{
    if(!GetPVarInt(playerid, "REPORT_GUI_ACTIVE")) return 0;

    new targetid = GetPVarInt(playerid, "ANS_TARGET");
    new target_account = GetPVarInt(playerid, "ANS_TARGET_ACCOUNT");
    new report_text[REPORT_GUI_TEXT_MAX];
    GetPVarString(playerid, "ANS_TEXT", report_text, sizeof report_text);

    if(IsPlayerConnected(targetid)
        && GetPlayerAccountID(targetid) == target_account
        && strlen(report_text))
    {
        ReportGUI_Enqueue(targetid, report_text);
    }

    ReportGUI_ClearAdminState(playerid);
    return 1;
}

stock ReportGUI_Dequeue(&targetid, text[], len)
{
    while(g_report_gui_count > 0)
    {
        new queue_index = g_report_gui_head;
        g_report_gui_head = (g_report_gui_head + 1) % REPORT_GUI_QUEUE_MAX;
        g_report_gui_count--;

        targetid = g_report_gui_player[queue_index];
        if(!IsPlayerConnected(targetid)) continue;
        if(GetPlayerAccountID(targetid) != g_report_gui_account[queue_index]) continue;

        format(text, len, "%s", g_report_gui_text[queue_index]);
        return 1;
    }
    ReportGUI_UpdateCounter();
    return 0;
}

stock ReportGUI_Submit(playerid, const report_text[], bool:from_utf8 = false)
{
    if(!IsPlayerConnected(playerid) || GetPlayerAccountID(playerid) <= 0) return 0;
    if(IsPlayerMuted(playerid))
        return SendClientMessage(playerid, 0xFF6600FF, "У вас бан чата!");
    if(strlen(report_text) >= REPORT_GUI_TEXT_MAX)
        return SendClientMessage(playerid, 0xCECECEFF, "Максимальная длина жалобы — 143 символа.");

    new text[REPORT_GUI_TEXT_MAX];
    format(text, sizeof text, "%s", report_text);
    if(from_utf8) utf8_to_cp1251(text);

    new text_len = strlen(text);
    if(text_len < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Введите текст жалобы.");
    if(text_len >= REPORT_GUI_TEXT_MAX)
        return SendClientMessage(playerid, 0xCECECEFF, "Максимальная длина жалобы — 143 символа.");

    new now = gettime();
    new next_time = GetPVarInt(playerid, "REPORT_GUI_NEXT_TIME");
    if(next_time > now)
    {
        new cooldown_message[96];
        format(cooldown_message, sizeof cooldown_message, "Следующую жалобу можно подать через %d сек.", next_time - now);
        return SendClientMessage(playerid, 0xCECECEFF, cooldown_message);
    }

    if(!ReportGUI_Enqueue(playerid, text))
        return SendClientMessage(playerid, 0xFF3333FF, "Очередь жалоб переполнена. Попробуйте позже.");

    SetPVarInt(playerid, "REPORT_GUI_NEXT_TIME", now + 60);
    ReportGUI_UpdateCounter();

    new message[256];
    format(message, sizeof message, "{704214}[A] Игрок %s[%d] подал жалобу: {FFAE42}%s", GetPlayerNameEx(playerid), playerid, text);
    SendMessageToAdmins(message, 0xFFFFFFFF, 1);
    SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Жалоба отправлена администрации и добавлена в очередь.");
    SendLog(playerid, LOG_TYPE_REPORT, text);
    return 1;
}

stock ReportGUI_Show(playerid, targetid, const report_text[])
{
    if(!ReportGUI_IsAdminAuthorized(playerid) || !IsPlayerConnected(targetid)) return 0;

    // Старые include требуют изменяемую строку в SetPVarString/JSON_SetString.
    new report_text_safe[REPORT_GUI_TEXT_MAX];
    format(report_text_safe, sizeof report_text_safe, "%s", report_text);

    SetPVarInt(playerid, "REPORT_GUI_ACTIVE", 1);
    SetPVarInt(playerid, "ANS_TARGET", targetid);
    SetPVarInt(playerid, "ANS_TARGET_ACCOUNT", GetPlayerAccountID(targetid));
    SetPVarString(playerid, "ANS_TEXT", report_text_safe);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 3);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "id", targetid);
    JSON_SetString(json, "pn", GetPlayerNameEx(targetid));
    JSON_SetString(json, "tr", report_text_safe);
    OnPacketIncoming(playerid, REPORT_GUI_ID, json);
    JSON_Cleanup(json);
    ReportGUI_UpdateCounter();
    return 1;
}

stock ReportGUI_SendTemplates(playerid)
{
    if(!ReportGUI_IsAdminAuthorized(playerid) || !GetPVarInt(playerid, "REPORT_GUI_ACTIVE")) return 0;

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 4);

    new Node:t1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Работа по жалобе"), "be", JSON_String("Здравствуйте, работаю по вашей жалобе. // Приятной игры"));
    new Node:t2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Не по теме"), "be", JSON_String("Здравствуйте, Ваша жалоба не по теме. // Приятной игры"));
    new Node:t3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("RolePlay путем"), "be", JSON_String("Здравствуйте, решите ситуацию RolePlay путем. // Приятной игры"));
    JSON_SetArray(json, "bt", JSON_Array(t1, t2, t3));

    OnPacketIncoming(playerid, REPORT_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock ReportGUI_DeliverAnswer(targetid, adminid, const answer[])
{
    if(!IsPlayerConnected(targetid)) return 0;

    // SA-MP/mobile chat has a strict per-message length limit.  Keep the
    // service prefix separate and split the custom answer into safe chunks.
    new header[144];
    format(header, sizeof header, "{704214}[REPORT] {FFFFFF}\xc0\xe4\xec\xe8\xed\xe8\xf1\xf2\xf0\xe0\xf2\xee\xf0 %s[%d] \xee\xf2\xe2\xe5\xf2\xe8\xeb \xed\xe0 \xe2\xe0\xf8\xf3 \xe6\xe0\xeb\xee\xe1\xf3:", GetPlayerNameEx(adminid), adminid);
    if(!SendClientMessage(targetid, 0xFFFFFFFF, header)) return 0;

    new answer_length = strlen(answer);
    new offset = 0;
    while(offset < answer_length)
    {
        new end = offset + 96;
        if(end > answer_length) end = answer_length;

        new chunk[100];
        strmid(chunk, answer, offset, end, sizeof chunk);
        if(!SendClientMessage(targetid, 0xFFAE42FF, chunk)) return 0;

        offset = end;
    }
    return 1;
}

stock ReportGUI_SendAnswer(playerid, const answer[])
{
    if(!ReportGUI_IsAdminAuthorized(playerid) || !GetPVarInt(playerid, "REPORT_GUI_ACTIVE")) return 0;

    new targetid = GetPVarInt(playerid, "ANS_TARGET");
    new target_account = GetPVarInt(playerid, "ANS_TARGET_ACCOUNT");
    if(!IsPlayerConnected(targetid) || GetPlayerAccountID(targetid) != target_account)
    {
        ReportGUI_ClearAdminState(playerid);
        return SendClientMessage(playerid, 0xFF3333FF, "\xc8\xe3\xf0\xee\xea \xf3\xe6\xe5 \xe2\xfb\xf8\xe5\xeb \xf1 \xf1\xe5\xf0\xe2\xe5\xf0\xe0.");
    }

    new answer_len = strlen(answer);
    if(answer_len < 1 || answer_len > 143)
        return SendClientMessage(playerid, 0xCECECEFF, "\xce\xf2\xe2\xe5\xf2 \xe4\xee\xeb\xe6\xe5\xed \xf1\xee\xe4\xe5\xf0\xe6\xe0\xf2\xfc \xee\xf2 1 \xe4\xee 143 \xf1\xe8\xec\xe2\xee\xeb\xee\xe2.");

    // Do not mark the report as answered until the player actually receives
    // all chat chunks.  This fixes custom replies being counted but invisible.
    if(!ReportGUI_DeliverAnswer(targetid, playerid, answer))
    {
        SendClientMessage(playerid, 0xFF3333FF, "\xcd\xe5 \xf3\xe4\xe0\xeb\xee\xf1\xfc \xe4\xee\xf1\xf2\xe0\xe2\xe8\xf2\xfc \xee\xf2\xe2\xe5\xf2 \xe8\xe3\xf0\xee\xea\xf3. \xd0\xe5\xef\xee\xf0\xf2 \xed\xe5 \xe7\xe0\xea\xf0\xfb\xf2, \xef\xee\xef\xf0\xee\xe1\xf3\xe9\xf2\xe5 \xee\xf2\xef\xf0\xe0\xe2\xe8\xf2\xfc \xee\xf2\xe2\xe5\xf2 \xe5\xf9\xb8 \xf0\xe0\xe7.");
        ReportGUI_UpdateCounter();
        return 0;
    }

    new message[320];
    format(message, sizeof message, "{704214}[A] %s[%d] \xee\xf2\xe2\xe5\xf2\xe8\xeb %s[%d]: {FFAE42}%s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, answer);
    SendMessageToAdmins(message, 0xFFFFFFFF, 1);
    AdminStats_AddReportAnswer(playerid);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, message);

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, REPORT_GUI_ID, close_json);
    JSON_Cleanup(close_json);

    ReportGUI_ClearAdminState(playerid);
    SendClientMessage(playerid, 0x66CC33FF, "\xce\xf2\xe2\xe5\xf2 \xf3\xf1\xef\xe5\xf8\xed\xee \xee\xf2\xef\xf0\xe0\xe2\xeb\xe5\xed \xe8\xe3\xf0\xee\xea\xf3.");
    return 1;
}

stock ReportGUI_SendTemplateAnswer(playerid, template_id)
{
    new answer[144];
    switch(template_id)
    {
        case 1: format(answer, sizeof answer, "Здравствуйте, работаю по вашей жалобе. // Приятной игры");
        case 2: format(answer, sizeof answer, "Здравствуйте, Ваша жалоба не по теме. // Приятной игры");
        case 3: format(answer, sizeof answer, "Здравствуйте, решите ситуацию RolePlay путем. // Приятной игры");
        default: return 0;
    }
    return ReportGUI_SendAnswer(playerid, answer);
}

stock ReportGUI_OnPlayerDisconnect(playerid)
{
    // Если администратор вышел во время обработки — возвращаем живую жалобу в очередь.
    if(GetPVarInt(playerid, "REPORT_GUI_ACTIVE")) ReportGUI_RequeueActive(playerid);
    else ReportGUI_ClearAdminState(playerid);
    DeletePVar(playerid, "REPORT_GUI_NEXT_TIME");
    ReportGUI_UpdateCounter();
    return 1;
}

stock ReportGUI_ReadCustomAnswer(Node:json, output[], len)
{
    output[0] = EOS;
    if(JSON_GetType(json, "rt") == JSON_NODE_STRING)
        JSON_GetString(json, "rt", output, len);
    if(!strlen(output) && JSON_GetType(json, "text") == JSON_NODE_STRING)
        JSON_GetString(json, "text", output, len);
    if(!strlen(output) && JSON_GetType(json, "r") == JSON_NODE_STRING)
        JSON_GetString(json, "r", output, len);
    if(!strlen(output) && JSON_GetType(json, "a") == JSON_NODE_STRING)
        JSON_GetString(json, "a", output, len);
    if(!strlen(output) && JSON_GetType(json, "v") == JSON_NODE_STRING)
        JSON_GetString(json, "v", output, len);
    if(!strlen(output) && JSON_GetType(json, "m") == JSON_NODE_STRING)
        JSON_GetString(json, "m", output, len);
    if(!strlen(output) && JSON_GetType(json, "msg") == JSON_NODE_STRING)
        JSON_GetString(json, "msg", output, len);
    if(!strlen(output) && JSON_GetType(json, "answer") == JSON_NODE_STRING)
        JSON_GetString(json, "answer", output, len);
    if(!strlen(output) && JSON_GetType(json, "input") == JSON_NODE_STRING)
        JSON_GetString(json, "input", output, len);
    return strlen(output);
}

stock AdminHUD_UpdateDateTime()
{
    new hour, minute, second, year, month, day;
    gettime(hour, minute, second);
    getdate(year, month, day);

    new text[40];
    format(text, sizeof text, "%02d.%02d.%04d_|_%02d:%02d:%02d",
        day, month, year, hour, minute, second);
    TextDrawSetString(admin_datetime_TD, text);
    return 1;
}

