// ------------------------------------------------------------
//  Spec AdminTools (GUI 66) - тестовая система под /testspt
//  Автор: ChatGPT (сделано под Windows-1251 Cyrillic)
//  Назначение: открыть GUI спека (66) и под-GUI для кнопки BAN,
//  как на примере. Реальный бан/логика наказаний НЕ встроены,
//  но все клики обрабатываются и есть точки расширения.
// ------------------------------------------------------------

#if defined _INC_spec_admintools_test
    #endinput
#endif
#define _INC_spec_admintools_test

#include "../include/json.inc"

// Если в моде нет SC (префикс цвета) — задаём безопасный
#if !defined SC
    #define SC "{FFFFFF}"
#endif

// GUI ID клиента
#define GUI_ADMINTOOLS            (66)

// Типы экранов (см. AdminToolsActionWithJSON / ViewModel)
#define AT_SCREEN_TRACKING        (1)  // основной экран спека
#define AT_SCREEN_TABLE           (2)  // под-таблица/под-диалог (используем под BAN)

// Кнопки (см. AdminToolsValue)
#define AT_BTN_UPDATE             (1)  // используем как "Выбрать"
#define AT_BTN_PREVIOUS           (2)  // используем как "Назад"
#define AT_BTN_BAN                (8)  // BAN в нижней панели

// Иконки в инфо-виджете (см. AdminToolsConstants)
#define AT_INFO_LEVEL             (1)
#define AT_INFO_HP                (2)
#define AT_INFO_ARMOR             (3)
#define AT_INFO_SPEED             (4)
#define AT_INFO_PING              (5)
#define AT_INFO_MONEY             (6)
#define AT_INFO_TRANSPORT         (7)

// PVar-ключи (не пересекаются со старыми системами)
#define PVAR_SPT_TARGET           "spt_target"
#define PVAR_SPT_BAN_DAYS         "spt_ban_days"

// ------------------------------------------------------------
// ВАЖНО: эта функция должна вызываться из ipacket.inc:
// case 66: { SpecAT_OnPacket(playerid, json); }
// ------------------------------------------------------------
forward SpecAT_OnPacket(playerid, Node:json);

// ------------------------------------------------------------
// Внутренние helpers
// ------------------------------------------------------------
stock SpecAT_GetPluralDays(days, out[], out_size)
{
    // 1 день / 2-4 дня / 5+ дней, 11-14 дней
    new d2 = days % 100;
    new d1 = days % 10;

    if (d2 >= 11 && d2 <= 14) format(out, out_size, "%d дней", days);
    else if (d1 == 1) format(out, out_size, "%d день", days);
    else if (d1 >= 2 && d1 <= 4) format(out, out_size, "%d дня", days);
    else format(out, out_size, "%d дней", days);

    return 1;
}

stock SpecAT_Send(playerid, Node:out)
{
    // В твоём моде GUI обычно обновляется повторным ShowPlayerGUI
    ShowPlayerGUI(playerid, GUI_ADMINTOOLS, out);
    return 1;
}

stock SpecAT_BuildPlayerInfoItem(Node:arr, iconId, const title[], value)
{
    new Node:item = JSON_Object();
    JSON_SetInt(item, "p", iconId);
    
    new titleBuf[64];
    format(titleBuf, sizeof(titleBuf), "%s", title);
    JSON_SetString(item, "n", titleBuf);
    
    JSON_SetInt(item, "v", value);
    JSON_ArrayAppend(arr, "", item);
    JSON_Cleanup(item);
    return 1;
}

stock SpecAT_OpenMain(playerid, targetid)
{
    new Node:out = JSON_Object();
    JSON_SetInt(out, "t", AT_SCREEN_TRACKING);
    JSON_SetInt(out, "id", targetid);

    new name[MAX_PLAYER_NAME+1];
    // Если есть GetPlayerNameEx — используем его, иначе стандартный
    #if defined GetPlayerNameEx
        format(name, sizeof(name), "%s", GetPlayerNameEx(targetid));
    #else
        GetPlayerName(targetid, name, sizeof(name));
    #endif
    JSON_SetString(out, "pn", name);

    // Список инфо справа (pi)
    new Node:pi = JSON_Array();

    new Float:hp, Float:arm;
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, arm);

    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_PING, "Пинг", GetPlayerPing(targetid));
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_SPEED, "Скорость", 0); // TODO: если в моде есть скорость — подставишь сюда
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_HP, "Здоровье", floatround(hp));
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_ARMOR, "Броня", floatround(arm));
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_LEVEL, "Уровень", GetPlayerScore(targetid));
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_MONEY, "Деньги", GetPlayerMoney(targetid));

    new veh = GetPlayerVehicleID(targetid);
    new vehModel = (veh ? GetVehicleModel(veh) : 0);
    SpecAT_BuildPlayerInfoItem(pi, AT_INFO_TRANSPORT, "Транспорт", vehModel);

    JSON_SetArray(out, "pi", pi);
    JSON_Cleanup(pi);

    // Сохраняем выбранного игрока для под-GUI BAN
    SetPVarInt(playerid, PVAR_SPT_TARGET, targetid);
    DeletePVar(playerid, PVAR_SPT_BAN_DAYS);

    SpecAT_Send(playerid, out);
    JSON_Cleanup(out);
    return 1;
}

stock SpecAT_OpenBanSubGui(playerid)
{
    // Открываем под-таблицу (экран 2) — будем использовать как BAN-диалог
    // Список кнопок/пунктов — в массиве "bt" (ATTemplateModel):
    // bi = id, bn = title, be = desc, br = time (опционально)
    new Node:out = JSON_Object();
    JSON_SetInt(out, "t", AT_SCREEN_TABLE);

    new Node:bt = JSON_Array();

    static const daysList[4] = { 1, 3, 7, 14 };
    new title[32];

    for (new i = 0; i < 4; i++)
    {
        new d = daysList[i];
        SpecAT_GetPluralDays(d, title, sizeof(title));

        new Node:row = JSON_Object();
        JSON_SetInt(row, "bi", d);          // id пункта
        JSON_SetString(row, "bn", title);   // заголовок
        
        new emptyDesc[1] = "";
        JSON_SetString(row, "be", emptyDesc);      // описание (пока пусто)
        
        JSON_SetInt(row, "br", d);          // time (на будущее)
        JSON_ArrayAppend(bt, "", row);
        JSON_Cleanup(row);
    }

    JSON_SetArray(out, "bt", bt);
    JSON_Cleanup(bt);

    // Обнуляем выбор
    DeletePVar(playerid, PVAR_SPT_BAN_DAYS);

    SpecAT_Send(playerid, out);
    JSON_Cleanup(out);
    return 1;
}

stock SpecAT_CloseSubGui(playerid)
{
    // t=7 в клиенте закрывает таблицу/под-окно (см. ViewModel case 7)
    new Node:out = JSON_Object();
    JSON_SetInt(out, "t", 7);
    SpecAT_Send(playerid, out);
    JSON_Cleanup(out);

    DeletePVar(playerid, PVAR_SPT_BAN_DAYS);
    return 1;
}

// ------------------------------------------------------------
// Команда теста
// /testspt [id] — открывает GUI спека 66
// ------------------------------------------------------------
CMD:testspt(playerid, params[])
{
    // Если хочешь ограничить админам — раскомментируй и подставь свою проверку:
    // if(!GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нет доступа.");

    new targetid;
    if (sscanf(params, "i", targetid))
        targetid = playerid;

    if (targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, ""SC"Игрок не найден.");

    return SpecAT_OpenMain(playerid, targetid);
}

// ------------------------------------------------------------
// Главный обработчик входящих пакетов GUI 66
// Подключение в ipacket.inc: case 66: { SpecAT_OnPacket(playerid, json); }
// ------------------------------------------------------------
public SpecAT_OnPacket(playerid, Node:json)
{
    // Клиент может отправить {"c":1} при закрытии
    new closeFlag;
    if (JSON_GetInt(json, "c", closeFlag) && closeFlag == 1)
    {
        DeletePVar(playerid, PVAR_SPT_BAN_DAYS);
        DeletePVar(playerid, PVAR_SPT_TARGET);
        return 1;
    }

    new t;
    JSON_GetInt(json, "t", t);

    // b — id нажатой кнопки (нижняя панель или кнопки в под-окне)
    new b;
    if (!JSON_GetInt(json, "b", b)) b = 0;

    // bi — id выбранного пункта таблицы (для под-окна)
    new bi;
    if (!JSON_GetInt(json, "bi", bi)) bi = 0;

    // ----------------------------
    // Основной экран спека
    // ----------------------------
    if (t == AT_SCREEN_TRACKING)
    {
        if (b == AT_BTN_BAN)
        {
            // Нажали BAN — открываем под-GUI как на примере
            return SpecAT_OpenBanSubGui(playerid);
        }
        return 1;
    }

    // ----------------------------
    // Под-окно (BAN)
    // ----------------------------
    if (t == AT_SCREEN_TABLE)
    {
        // Выбор пункта (дней)
        if (bi > 0)
        {
            SetPVarInt(playerid, PVAR_SPT_BAN_DAYS, bi);

            new msg[96], title[32];
            SpecAT_GetPluralDays(bi, title, sizeof(title));
            format(msg, sizeof(msg), ""SC"Вы выбрали срок: %s. Теперь нажмите \"Выбрать\".", title);
            SendClientMessage(playerid, 0xFFFFFFAA, msg);
            return 1;
        }

        // Кнопки под-окна:
        // UPDATE(1) используем как "Выбрать"
        // PREVIOUS(2) используем как "Назад"
        if (b == AT_BTN_PREVIOUS)
        {
            return SpecAT_CloseSubGui(playerid);
        }
        if (b == AT_BTN_UPDATE)
        {
            new days = GetPVarInt(playerid, PVAR_SPT_BAN_DAYS);
            if (days <= 0)
                return SendClientMessage(playerid, 0xCECECEFF, ""SC"Сначала выберите срок (1/3/7/14).");

            // Тут в будущем ты добавишь реальную логику наказания (бан/причина/лог)
            new target = GetPVarInt(playerid, PVAR_SPT_TARGET);
            new tname[MAX_PLAYER_NAME+1];
            #if defined GetPlayerNameEx
                format(tname, sizeof(tname), "%s", GetPlayerNameEx(target));
            #else
                GetPlayerName(target, tname, sizeof(tname));
            #endif

            new title[32], outmsg[144];
            SpecAT_GetPluralDays(days, title, sizeof(title));
            format(outmsg, sizeof(outmsg), ""SC"[TEST] BAN: игрок %s, срок %s (логика наказания будет добавлена позже).", tname, title);
            SendClientMessage(playerid, 0x00FF00AA, outmsg);

            SpecAT_CloseSubGui(playerid);
            return 1;
        }
        return 1;
    }

    return 1;
}
