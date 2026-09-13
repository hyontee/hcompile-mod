// =====================================================================
// system_trade.pwn - Обмен предметами/деньгами между игроками + /pay
// =====================================================================
//
// v3: НАЙДЕНА И ИСПРАВЛЕНА ПРИЧИНА, ПОЧЕМУ ОКНО ОБМЕНА НЕ РИСОВАЛОСЬ.
//
//   В v2 использовалось "tb":9 для JSON-пакета GUI (opcode 34) - это
//   значение было экспериментальным и НЕ было подтверждено клиентом.
//   Проверка в игре показала: клиент попросту не знает, что делать со
//   значением "tb":9, и не рисует сетку предметов вообще - остаётся
//   только текстовый лог в чате ("Обмен начат", "Вы: предметов нет" и
//   т.д.), который выводит функция UpdateTradeUI как побочный эффект,
//   а не как замена окну.
//
//   ПОДТВЕРЖДЕНО РАБОЧИМИ: "tb":0 рисует сетку багажника (invtrunk.pwn),
//   "tb":1 рисует сетку шкафа (invuse.pwn). Другие значения клиентом не
//   распознаются.
//
//   ИСПРАВЛЕНИЕ: TRADE_TB_MODE переключён с 9 на 0 - теперь окно обмена
//   использует тот же самый "tb":0, что и рабочий багажник, поэтому
//   сетка предметов (перетаскивание, иконки) должна рисоваться так же
//   надёжно, как на скриншоте багажника/шкафа.
//
//   ЧЕСТНО ПРО ОГРАНИЧЕНИЯ: у протокола opcode 34 ("tb":0/1) в принципе
//   нет полей под "ник партнёра", "поле суммы денег", кнопки
//   "Обменяться"/"Отменить обмен" и таймер - в присланных файлах нет
//   ни одного места, где клиент рисовал бы что-то подобное для этого
//   опкода. Экран с CALVIN_LEIN (скрин-референс) выглядит как отдельный,
//   более богатый нативный экран трейда - если он в принципе существует
//   в этом клиенте (com.fline.mobile), это отдельный протокол/opcode,
//   которого нет ни в одном из присланных файлов, и я не могу его
//   угадать или придумать. Поэтому деньги и подтверждение по-прежнему
//   идут через команды /trademoney и /tradeconfirm (см. ниже) - это
//   рабочий вариант, просто не в виде отдельных кнопок в самом окне.
//
//   ПОСЛЕ ТЕСТА В ИГРЕ напиши мне, что именно показал экран (сетки
//   появились? совпадает по виду с багажником? что не так) - подгоню
//   дальше, отталкиваясь от реального поведения клиента.
//
// БАГ, КОТОРЫЙ ПОПУТНО ПОЧИНЕН РАНЕЕ:
//   Обработчик ответов этого GUI (PacketIncomingTrunkOrCloset в
//   invtrunk.pwn) НИГДЕ не был подключён к диспетчеру пакетов в
//   nexus.pwn (switch(guiid) в IPacket:253) - т.е. перетаскивание
//   вещей в багажник/шкаф тоже не долетало до сервера. Теперь там
//   добавлен "case 34", который вызывает GUI34_OnPacket (определена
//   ниже) - она сама решает, отправить пакет в PacketIncomingTrunkOrCloset
//   (typeinv 1/2/3, как раньше) или в новый Trade_OnPacket34 (typeinv 4).
//
// КУДА ПОДКЛЮЧИТЬ (в nexus.pwn):
//   1) #include "../include/system/system_trade.pwn" - уже стоит.
//   2) В public OnPlayerDisconnect(playerid, reason) должна быть строка
//      Trade_OnDisconnect(playerid); - уже стоит.
//   3) В switch(guiid) внутри IPacket:253 должен быть:
//          case 34:
//          {
//              GUI34_OnPacket(playerid, JSONObject);
//              JSON_Cleanup(JSONObject);
//          }
//      (это уже подключено, судя по присланному nexus.pwn)
//
// =====================================================================
#if !defined MAX_INVENTORY_SLOTS
    #define MAX_INVENTORY_SLOTS 40
#endif

#define MAX_TRADE_SLOTS         12      // Сетка предложения - 12 слотов (3х4)
#define TRADE_INTERACT_DISTANCE 5.0     // Дистанция для /trade и /pay
#define TRADE_ADMIN_LOG_AMOUNT  1000000 // Суммы /pay от этой и выше - видно админам
#define TRADE_TYPEINV_MODE      4       // Значение PVar "typeinv" во время трейда
#define TRADE_TB_MODE           0       // "tb" в JSON-пакете 34 (см. шапку файла)

// Предметы, которые нельзя перекинуть в обычный трейд (у них своя логика:
// SIM привязана к номеру телефона, номера машин - к конкретному авто).
// При необходимости просто добавь/убери ID сюда.
new const TRADE_BLOCKED_ITEMS[] = {58, 59, 81, 82, 83};

enum e_TRADE_STATUS
{
    trade_TargetID,                        // С кем торгуем
    bool:trade_IsConfirmed,                // Нажал ли кнопку "Обменяться"
    bool:trade_IsOpen,                     // Открыто ли окно трейда сейчас
    trade_MoneyOffer,                      // Сколько денег предлагает игрок
    trade_ItemSlot[MAX_TRADE_SLOTS],       // Из какого слота инвентаря взят предмет (-1 = пусто)
    trade_ItemId[MAX_TRADE_SLOTS],         // ID предмета
    trade_ItemCount[MAX_TRADE_SLOTS]       // Количество
};

new PlayerTrade[MAX_PLAYERS][e_TRADE_STATUS];
// Номер/тег предмета (плашка) - отдельным массивом, т.к. 2D-поле внутри
// enum ("field[N][32]") ненадёжно компилируется в разных версиях pawncc.
new PlayerTradeItemPlate[MAX_PLAYERS][MAX_TRADE_SLOTS][32];
new PlayerTradeRequestFrom[MAX_PLAYERS] = {INVALID_PLAYER_ID, ...};

// --- ВСПОМОГАТЕЛЬНОЕ ---

stock bool:Trade_IsItemBlocked(item_id)
{
    for(new i = 0; i < sizeof(TRADE_BLOCKED_ITEMS); i++)
    {
        if(TRADE_BLOCKED_ITEMS[i] == item_id) return true;
    }
    return false;
}

stock Trade_CountOffered(playerid)
{
    new count = 0;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] != -1) count++;
    }
    return count;
}

stock Trade_CountFreeInventorySlots(playerid)
{
    new count = 0;
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0) count++;
    }
    return count;
}

stock Trade_TotalOfferedWeight(playerid)
{
    new weight = 0;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] != -1)
        {
            weight += GetItemWeight(PlayerTrade[playerid][trade_ItemId][i]) * PlayerTrade[playerid][trade_ItemCount][i];
        }
    }
    return weight;
}

// Слот инвентаря playerid уже выставлен на обмен? (чтобы не выставить дважды
// и чтобы скрыть его из "ic" панели своего инвентаря в GUI)
stock bool:Trade_IsInventorySlotOffered(playerid, inv_slot)
{
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == inv_slot) return true;
    }
    return false;
}

// --- GUI (opcode 34): построение пакетов ---

// Собирает JSON-массив "оставшегося" инвентаря playerid (без того, что уже
// выставлено на обмен - визуально выглядит, будто предмет "переместился"
// в панель обмена, хотя физически он ещё лежит в инвентаре до завершения сделки).
stock Node:Trade_BuildOwnInventoryArray(playerid)
{
    new Node:itemsArray = JSON_Array();
    new Node:tempArray;

    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 0) continue;
        if(Trade_IsInventorySlotOffered(playerid, i)) continue;

        new itemId = g_PlayerInventory[playerid][i][inv_itemId];

        if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
        {
            tempArray = JSON_Array(
                JSON_Int(itemId),
                JSON_String(g_PlayerInventory[playerid][i][inv_itemPlate]),
                JSON_Int(i),
                JSON_Int(0)
            );
        }
        else
        {
            tempArray = JSON_Array(
                JSON_Int(itemId),
                JSON_Int(g_PlayerInventory[playerid][i][inv_itemCount]),
                JSON_Int(i),
                JSON_Int(0)
            );
        }

        itemsArray = JSON_Append(itemsArray, tempArray);
    }

    return itemsArray;
}

// Собирает JSON-массив того, что offererid ВЫСТАВИЛ на обмен (это партнёр
// увидит в левой панели как "offererid отдаёт вам").
stock Node:Trade_BuildOfferArray(offererid)
{
    new Node:offerArray = JSON_Array();
    new Node:tempArray;

    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[offererid][trade_ItemSlot][i] == -1) continue;

        tempArray = JSON_Array(
            JSON_Int(PlayerTrade[offererid][trade_ItemId][i]),
            JSON_Int(PlayerTrade[offererid][trade_ItemCount][i]),
            JSON_Int(i),
            JSON_Int(0)
        );

        if(strlen(PlayerTradeItemPlate[offererid][i]) > 0)
        {
            JSON_SetString(tempArray, "nt", PlayerTradeItemPlate[offererid][i]);
        }

        offerArray = JSON_Append(offerArray, tempArray);
    }

    return offerArray;
}

// Отправляет playerid обновлённый экран трейда: справа - его собственный
// свободный инвентарь, слева - то, что предложил партнёр.
stock ShowPlayerTradeGUI(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    if(!IsPlayerConnected(targetid)) return 0;

    new Node:itemsArray = Trade_BuildOwnInventoryArray(playerid);
    new Node:partnerOfferArray = Trade_BuildOfferArray(targetid);

    new Node:json = JSON_Object
    (
        "o", JSON_Int(1),
        "tb", JSON_Int(TRADE_TB_MODE),
        "w", JSON_Int(0),
        "mw", JSON_Int(GetPlayerMaxWeight(playerid)),
        "bw", JSON_Int(0),
        "cw", JSON_Int(1500),
        "sl", JSON_Int(MAX_INVENTORY_SLOTS),
        "nm", JSON_Int(targetid),
        "it", itemsArray,
        "sb", JSON_Int(MAX_TRADE_SLOTS),
        "ai", JSON_Array(),
        "ic", partnerOfferArray
    );

    SetPVarInt(playerid, "typeinv", TRADE_TYPEINV_MODE);
    SendPacketToClient(playerid, 34, json);
    JSON_Cleanup(json);
    return 1;
}

// Обновляет экран(ы) сразу у обоих участников - вызывай после любого
// изменения предложения (добавили/убрали предмет).
stock Trade_RefreshBoth(playerid, targetid)
{
    ShowPlayerTradeGUI(playerid);
    if(IsPlayerConnected(targetid)) ShowPlayerTradeGUI(targetid);
    return 1;
}

// --- GUI (opcode 34): приём ответов от клиента ---

// Общий диспетчер для ВСЕХ режимов opcode 34 (багажник/шкаф/склад/трейд).
// Вызывается из nexus.pwn: case 34 в switch(guiid) внутри IPacket:253.
stock GUI34_OnPacket(playerid, Node:JSONObject)
{
    new mode = GetPVarInt(playerid, "typeinv");

    if(mode == 1 || mode == 2 || mode == 3)
    {
        // Старое поведение - без изменений (багажник/шкаф/склад)
        return PacketIncomingTrunkOrCloset(playerid, JSONObject);
    }

    if(mode == TRADE_TYPEINV_MODE)
    {
        return Trade_OnPacket34(playerid, JSONObject);
    }

    return 0;
}

stock Trade_SendAck(playerid, type, success)
{
    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", type);
    JSON_SetInt(response, "s", success);
    SendPacketToClient(playerid, 34, response);
    JSON_Cleanup(response);
    return 1;
}

// type 0 = предмет перетащен ИЗ своего инвентаря В панель обмена (os = слот
//          инвентаря, ns = желаемый слот в сетке обмена)
// type 1 = предмет перетащен ИЗ панели обмена ОБРАТНО в инвентарь (os = слот
//          в сетке обмена, который нужно освободить)
stock Trade_OnPacket34(playerid, Node:JSONObject)
{
    new type, item_id, old_pos, new_pos, count;
    JSON_GetInt(JSONObject, "t", type);

    if(!PlayerTrade[playerid][trade_IsOpen])
    {
        Trade_SendAck(playerid, type, 0);
        return 0;
    }

    new targetid = PlayerTrade[playerid][trade_TargetID];
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Игрок покинул сервер, обмен отменён.");
        CloseTrade(playerid);
        Trade_SendAck(playerid, type, 0);
        return 0;
    }

    if(PlayerTrade[playerid][trade_IsConfirmed])
    {
        SendClientMessage(playerid, -1, "{FF0000}Сначала снимите готовность (/tradeconfirm).");
        Trade_SendAck(playerid, type, 0);
        return 0;
    }

    switch(type)
    {
        case 0: // инвентарь -> обмен
        {
            JSON_GetInt(JSONObject, "ga", item_id);
            JSON_GetInt(JSONObject, "os", old_pos);
            JSON_GetInt(JSONObject, "ns", new_pos);
            JSON_GetInt(JSONObject, "v", count);

            if(old_pos < 0 || old_pos >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][old_pos][inv_itemId] == 0)
            {
                Trade_SendAck(playerid, 0, 0);
                return 0;
            }

            item_id = g_PlayerInventory[playerid][old_pos][inv_itemId];

            if(Trade_IsItemBlocked(item_id))
            {
                SendClientMessage(playerid, -1, "{FF0000}Этот предмет нельзя передавать через обмен.");
                Trade_SendAck(playerid, 0, 0);
                return 0;
            }

            if(Trade_IsInventorySlotOffered(playerid, old_pos))
            {
                Trade_SendAck(playerid, 0, 0);
                return 0;
            }

            new trade_idx = -1;
            if(new_pos >= 0 && new_pos < MAX_TRADE_SLOTS && PlayerTrade[playerid][trade_ItemSlot][new_pos] == -1)
            {
                trade_idx = new_pos;
            }
            else
            {
                for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                {
                    if(PlayerTrade[playerid][trade_ItemSlot][i] == -1) { trade_idx = i; break; }
                }
            }

            if(trade_idx == -1)
            {
                SendClientMessage(playerid, -1, "{FF0000}Вы не можете выставить больше 12 предметов на обмен.");
                Trade_SendAck(playerid, 0, 0);
                return 0;
            }

            PlayerTrade[playerid][trade_ItemSlot][trade_idx] = old_pos;
            PlayerTrade[playerid][trade_ItemId][trade_idx] = item_id;
            PlayerTrade[playerid][trade_ItemCount][trade_idx] = g_PlayerInventory[playerid][old_pos][inv_itemCount];
            strcpy(PlayerTradeItemPlate[playerid][trade_idx], g_PlayerInventory[playerid][old_pos][inv_itemPlate], 32);

            PlayerTrade[playerid][trade_IsConfirmed] = false;
            PlayerTrade[targetid][trade_IsConfirmed] = false;

            Trade_SendAck(playerid, 0, 1);
            Trade_RefreshBoth(playerid, targetid);
        }

        case 1: // обмен -> инвентарь (снимаем свой же предмет с предложения)
        {
            JSON_GetInt(JSONObject, "os", old_pos);

            if(old_pos < 0 || old_pos >= MAX_TRADE_SLOTS || PlayerTrade[playerid][trade_ItemSlot][old_pos] == -1)
            {
                Trade_SendAck(playerid, 1, 0);
                return 0;
            }

            PlayerTrade[playerid][trade_ItemSlot][old_pos] = -1;
            PlayerTrade[playerid][trade_ItemId][old_pos] = 0;
            PlayerTrade[playerid][trade_ItemCount][old_pos] = 0;
            PlayerTradeItemPlate[playerid][old_pos][0] = 0;

            PlayerTrade[playerid][trade_IsConfirmed] = false;
            PlayerTrade[targetid][trade_IsConfirmed] = false;

            Trade_SendAck(playerid, 1, 1);
            Trade_RefreshBoth(playerid, targetid);
        }

        default:
        {
            Trade_SendAck(playerid, type, 0);
        }
    }

    return 1;
}

// --- ТЕКСТОВЫЙ СТАТУС (запасной вариант, дублирует то же самое словами -
//     полезно, пока неизвестно, показывает ли GUI деньги/готовность) ---

stock UpdateTradeUI(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Игрок покинул сервер, обмен отменён.");
        CloseTrade(playerid);
        return 0;
    }

    Trade_SendStatus(playerid, targetid);
    Trade_SendStatus(targetid, playerid);

    return 1;
}

stock Trade_SendStatus(playerid, targetid)
{
    new str[144];

    format(str, sizeof(str), "{FFCC00}== Обмен с %s ==", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, str);

    new has_items = 0;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] != -1)
        {
            new name[64];
            GetItemName(PlayerTrade[playerid][trade_ItemId][i], name, sizeof(name));
            format(str, sizeof(str), "{FFFFFF}  Вы даёте [%d] %s x%d", i, name, PlayerTrade[playerid][trade_ItemCount][i]);
            SendClientMessage(playerid, -1, str);
            has_items = 1;
        }
    }
    if(!has_items) SendClientMessage(playerid, 0xCECECEFF, "  Вы: предметов нет");
    if(PlayerTrade[playerid][trade_MoneyOffer] > 0)
    {
        format(str, sizeof(str), "{FFFFFF}  Вы даёте деньги: %d руб.", PlayerTrade[playerid][trade_MoneyOffer]);
        SendClientMessage(playerid, -1, str);
    }

    has_items = 0;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[targetid][trade_ItemSlot][i] != -1)
        {
            new name[64];
            GetItemName(PlayerTrade[targetid][trade_ItemId][i], name, sizeof(name));
            format(str, sizeof(str), "{66CC00}  %s даёт %s x%d", GetPlayerNameEx(targetid), name, PlayerTrade[targetid][trade_ItemCount][i]);
            SendClientMessage(playerid, -1, str);
            has_items = 1;
        }
    }
    if(!has_items) format(str, sizeof(str), "  %s: предметов нет", GetPlayerNameEx(targetid)), SendClientMessage(playerid, 0xCECECEFF, str);

    if(PlayerTrade[targetid][trade_MoneyOffer] > 0)
    {
        format(str, sizeof(str), "{66CC00}  %s даёт деньги: %d руб.", GetPlayerNameEx(targetid), PlayerTrade[targetid][trade_MoneyOffer]);
        SendClientMessage(playerid, -1, str);
    }

    format(str, sizeof(str), "{888888}Готовность: вы - %s, %s - %s", PlayerTrade[playerid][trade_IsConfirmed] ? ("{66CC00}ДА") : ("{FF5555}нет"),
        GetPlayerNameEx(targetid), PlayerTrade[targetid][trade_IsConfirmed] ? ("{66CC00}ДА") : ("{FF5555}нет"));
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, 0x888888FF, "Предметы теперь перетаскиваются в открывшемся окне. Команды-дублёры: /tradeadd [слот], /traderemove [номер], /trademoney [сумма], /tradeconfirm, /canceltrade");
}

// --- ЗАПРОС / ПРИНЯТИЕ / ОТМЕНА ---

CMD:trade(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /trade [ID/Никнейм]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети.");
    if(!IsPlayerLogged(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок ещё не авторизован.");
    if(targetid == playerid) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете торговать сами с собой.");

    if(PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас уже открыт трейд.");
    if(PlayerTrade[targetid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}Этот игрок сейчас занят другим обменом.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, TRADE_INTERACT_DISTANCE, x, y, z)) return SendClientMessage(playerid, -1, "{FF0000}Игрок слишком далеко от вас.");

    PlayerTradeRequestFrom[targetid] = playerid;

    new str[128];
    format(str, sizeof(str), "{66CC00}%s предлагает вам обменяться предметами. Введите {FFFF00}/accepttrade{66CC00} для согласия.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, -1, str);

    format(str, sizeof(str), "{66CC00}Вы отправили предложение обмена %s. Ожидайте ответа...", GetPlayerNameEx(playerid));
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:accepttrade(playerid, params[])
{
    new inviter = PlayerTradeRequestFrom[playerid];
    if(inviter == INVALID_PLAYER_ID || !IsPlayerConnected(inviter))
    {
        SendClientMessage(playerid, -1, "{FF0000}Предложение обмена не найдено или игрок вышел.");
        return 1;
    }
    if(PlayerTrade[playerid][trade_IsOpen] || PlayerTrade[inviter][trade_IsOpen])
    {
        SendClientMessage(playerid, -1, "{FF0000}Кто-то из вас уже в обмене.");
        PlayerTradeRequestFrom[playerid] = INVALID_PLAYER_ID;
        return 1;
    }

    PlayerTradeRequestFrom[playerid] = INVALID_PLAYER_ID;

    Trade_ResetData(playerid, inviter);
    Trade_ResetData(inviter, playerid);

    SendClientMessage(playerid, 0x66CC00FF, "Обмен начат.");
    SendClientMessage(inviter, 0x66CC00FF, "Обмен начат.");

    Trade_RefreshBoth(playerid, inviter);
    UpdateTradeUI(playerid);
    return 1;
}

CMD:canceltrade(playerid, params[])
{
    if(PlayerTradeRequestFrom[playerid] != INVALID_PLAYER_ID)
    {
        PlayerTradeRequestFrom[playerid] = INVALID_PLAYER_ID;
        SendClientMessage(playerid, -1, "{FFCC00}Входящее предложение обмена отклонено.");
        return 1;
    }

    if(!PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас нет открытого обмена.");

    new targetid = PlayerTrade[playerid][trade_TargetID];

    CloseTrade(playerid);
    if(IsPlayerConnected(targetid)) CloseTrade(targetid);

    SendClientMessage(playerid, 0xFFCC00FF, "Вы отменили обмен.");
    if(IsPlayerConnected(targetid)) SendClientMessage(targetid, 0xFFCC00FF, "Обмен отменён вторым игроком.");
    return 1;
}

stock Trade_ResetData(playerid, targetid)
{
    PlayerTrade[playerid][trade_TargetID] = targetid;
    PlayerTrade[playerid][trade_IsConfirmed] = false;
    PlayerTrade[playerid][trade_IsOpen] = true;
    PlayerTrade[playerid][trade_MoneyOffer] = 0;

    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        PlayerTrade[playerid][trade_ItemSlot][i] = -1;
        PlayerTrade[playerid][trade_ItemId][i] = 0;
        PlayerTrade[playerid][trade_ItemCount][i] = 0;
        PlayerTradeItemPlate[playerid][i][0] = 0;
    }
}

stock CloseTrade(playerid)
{
    PlayerTrade[playerid][trade_IsOpen] = false;
    PlayerTrade[playerid][trade_IsConfirmed] = false;
    PlayerTrade[playerid][trade_TargetID] = INVALID_PLAYER_ID;

    if(GetPVarInt(playerid, "typeinv") == TRADE_TYPEINV_MODE)
    {
        SetPVarInt(playerid, "typeinv", 0);
    }
}

// Вызови эту функцию ОДНОЙ строкой из уже существующего в nexus.pwn
// public OnPlayerDisconnect(playerid, reason), чтобы у партнёра трейд
// корректно закрывался при выходе игрока.
stock Trade_OnDisconnect(playerid)
{
    PlayerTradeRequestFrom[playerid] = INVALID_PLAYER_ID;

    if(PlayerTrade[playerid][trade_IsOpen])
    {
        new targetid = PlayerTrade[playerid][trade_TargetID];
        CloseTrade(playerid);
        if(IsPlayerConnected(targetid))
        {
            CloseTrade(targetid);
            SendClientMessage(targetid, 0xFF0000FF, "Обмен отменён: партнёр покинул сервер.");
        }
    }

    // На случай, если кто-то ждал ответа именно от этого игрока
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(PlayerTradeRequestFrom[i] == playerid) PlayerTradeRequestFrom[i] = INVALID_PLAYER_ID;
    }
}

// --- ДОБАВЛЕНИЕ / УДАЛЕНИЕ ПРЕДМЕТОВ (команды-дублёры GUI, оставлены как
//     запасной вариант на случай проблем с перетаскиванием) ---

CMD:tradeadd(playerid, params[])
{
    new inv_slot;
    if(sscanf(params, "d", inv_slot)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /tradeadd [номер слота инвентаря]");

    if(!PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас нет открытого обмена.");
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили сделку. Сначала /tradeconfirm ещё раз, чтобы снять готовность.");

    if(inv_slot < 0 || inv_slot >= MAX_INVENTORY_SLOTS) return SendClientMessage(playerid, -1, "{FF0000}Неверный номер слота.");
    if(g_PlayerInventory[playerid][inv_slot][inv_itemId] == 0) return SendClientMessage(playerid, -1, "{FF0000}В этом слоте нет предмета.");

    new item_id = g_PlayerInventory[playerid][inv_slot][inv_itemId];
    if(Trade_IsItemBlocked(item_id)) return SendClientMessage(playerid, -1, "{FF0000}Этот предмет нельзя передавать через обмен.");

    if(Trade_IsInventorySlotOffered(playerid, inv_slot)) return SendClientMessage(playerid, -1, "{FF0000}Этот предмет уже в обмене.");

    new trade_idx = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == -1) { trade_idx = i; break; }
    }
    if(trade_idx == -1) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете выставить больше 12 предметов на обмен.");

    PlayerTrade[playerid][trade_ItemSlot][trade_idx] = inv_slot;
    PlayerTrade[playerid][trade_ItemId][trade_idx] = item_id;
    PlayerTrade[playerid][trade_ItemCount][trade_idx] = g_PlayerInventory[playerid][inv_slot][inv_itemCount];
    strcpy(PlayerTradeItemPlate[playerid][trade_idx], g_PlayerInventory[playerid][inv_slot][inv_itemPlate], 32);

    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[playerid][trade_IsConfirmed] = false;
    PlayerTrade[targetid][trade_IsConfirmed] = false;

    Trade_RefreshBoth(playerid, targetid);
    UpdateTradeUI(playerid);
    return 1;
}

CMD:traderemove(playerid, params[])
{
    new trade_slot;
    if(sscanf(params, "d", trade_slot)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /traderemove [номер из вашего списка обмена]");

    if(!PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас нет открытого обмена.");
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Сначала снимите готовность (/tradeconfirm).");
    if(trade_slot < 0 || trade_slot >= MAX_TRADE_SLOTS || PlayerTrade[playerid][trade_ItemSlot][trade_slot] == -1)
        return SendClientMessage(playerid, -1, "{FF0000}В этом слоте обмена ничего нет.");

    PlayerTrade[playerid][trade_ItemSlot][trade_slot] = -1;
    PlayerTrade[playerid][trade_ItemId][trade_slot] = 0;
    PlayerTrade[playerid][trade_ItemCount][trade_slot] = 0;
    PlayerTradeItemPlate[playerid][trade_slot][0] = 0;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[playerid][trade_IsConfirmed] = false;
    PlayerTrade[targetid][trade_IsConfirmed] = false;

    Trade_RefreshBoth(playerid, targetid);
    UpdateTradeUI(playerid);
    return 1;
}

CMD:trademoney(playerid, params[])
{
    new amount;
    if(sscanf(params, "d", amount)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /trademoney [сумма] (0 чтобы убрать)");

    if(!PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас нет открытого обмена.");
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Сначала снимите готовность (/tradeconfirm).");
    if(amount < 0) return SendClientMessage(playerid, -1, "{FF0000}Сумма не может быть отрицательной.");
    if(amount > GetPlayerMoneyEx(playerid)) return SendClientMessage(playerid, -1, "{FF0000}У вас нет столько денег.");

    PlayerTrade[playerid][trade_MoneyOffer] = amount;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[playerid][trade_IsConfirmed] = false;
    PlayerTrade[targetid][trade_IsConfirmed] = false;

    UpdateTradeUI(playerid);
    return 1;
}

// --- ПОДТВЕРЖДЕНИЕ И ФИНАЛИЗАЦИЯ ---

CMD:tradeconfirm(playerid, params[])
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас нет открытого обмена.");

    new targetid = PlayerTrade[playerid][trade_TargetID];
    if(!IsPlayerConnected(targetid)) { CloseTrade(playerid); return SendClientMessage(playerid, -1, "{FF0000}Партнёр вышел из игры."); }

    if(PlayerTrade[playerid][trade_IsConfirmed])
    {
        PlayerTrade[playerid][trade_IsConfirmed] = false;
        SendClientMessage(playerid, -1, "Вы отменили подтверждение сделки.");
        UpdateTradeUI(playerid);
        return 1;
    }

    PlayerTrade[playerid][trade_IsConfirmed] = true;
    SendClientMessage(playerid, 0x66CC00FF, "Вы подтвердили готовность к обмену. Ожидание второго игрока...");
    UpdateTradeUI(playerid);

    if(PlayerTrade[playerid][trade_IsConfirmed] && PlayerTrade[targetid][trade_IsConfirmed])
    {
        FinalizeTrade(playerid, targetid);
    }
    return 1;
}

// Проверка: поместятся ли у "to" все предметы, которые предлагает "from"
// (по количеству свободных слотов) и не превысит ли это лимит веса.
stock bool:Trade_CanReceive(from, to)
{
    new needed_slots = Trade_CountOffered(from);
    if(needed_slots == 0) return true;

    if(Trade_CountFreeInventorySlots(to) < needed_slots) return false;

    new incoming_weight = Trade_TotalOfferedWeight(from);
    if(GetPlayerWeight(to) + incoming_weight > GetPlayerMaxWeight(to)) return false;

    return true;
}

stock FinalizeTrade(p1, p2)
{
    // 1. Проверяем деньги (баланс мог измениться после того, как игрок выставил сумму)
    if(PlayerTrade[p1][trade_MoneyOffer] > GetPlayerMoneyEx(p1) || PlayerTrade[p2][trade_MoneyOffer] > GetPlayerMoneyEx(p2))
    {
        SendClientMessage(p1, -1, "{FF0000}Обмен отменён: у одного из игроков не хватает денег.");
        SendClientMessage(p2, -1, "{FF0000}Обмен отменён: у одного из игроков не хватает денег.");
        PlayerTrade[p1][trade_IsConfirmed] = false;
        PlayerTrade[p2][trade_IsConfirmed] = false;
        return 0;
    }

    // 2. Проверяем вес и свободные слоты у ОБЕИХ сторон ДО того, как начнём что-то удалять
    if(!Trade_CanReceive(p1, p2) || !Trade_CanReceive(p2, p1))
    {
        SendClientMessage(p1, -1, "{FF0000}Обмен отменён: у одного из игроков не хватает места в инвентаре.");
        SendClientMessage(p2, -1, "{FF0000}Обмен отменён: у одного из игроков не хватает места в инвентаре.");
        PlayerTrade[p1][trade_IsConfirmed] = false;
        PlayerTrade[p2][trade_IsConfirmed] = false;
        return 0;
    }

    // 3. Удаляем предметы у обоих ИЗ ОРИГИНАЛЬНЫХ слотов (пока ничего не выдаём)
    new p1_item_id[MAX_TRADE_SLOTS], p1_item_count[MAX_TRADE_SLOTS], p1_item_plate[MAX_TRADE_SLOTS][32], p1_n = 0;
    new p2_item_id[MAX_TRADE_SLOTS], p2_item_count[MAX_TRADE_SLOTS], p2_item_plate[MAX_TRADE_SLOTS][32], p2_n = 0;

    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[p1][trade_ItemSlot][i] != -1)
        {
            p1_item_id[p1_n] = PlayerTrade[p1][trade_ItemId][i];
            p1_item_count[p1_n] = PlayerTrade[p1][trade_ItemCount][i];
            strcpy(p1_item_plate[p1_n], PlayerTradeItemPlate[p1][i], 32);
            Inventory_DeleteItem(p1, PlayerTrade[p1][trade_ItemSlot][i]);
            p1_n++;
        }
        if(PlayerTrade[p2][trade_ItemSlot][i] != -1)
        {
            p2_item_id[p2_n] = PlayerTrade[p2][trade_ItemId][i];
            p2_item_count[p2_n] = PlayerTrade[p2][trade_ItemCount][i];
            strcpy(p2_item_plate[p2_n], PlayerTradeItemPlate[p2][i], 32);
            Inventory_DeleteItem(p2, PlayerTrade[p2][trade_ItemSlot][i]);
            p2_n++;
        }
    }

    // 4. Выдаём предметы новым владельцам (место уже гарантированно есть - проверили в шаге 2)
    for(new i = 0; i < p1_n; i++)
    {
        new free_slot = Inventory_GetFreeSlot(p2);
        if(free_slot != -1) Inventory_AddItem(p2, p1_item_id[i], free_slot, p1_item_count[i], p1_item_plate[i]);
    }
    for(new i = 0; i < p2_n; i++)
    {
        new free_slot = Inventory_GetFreeSlot(p1);
        if(free_slot != -1) Inventory_AddItem(p1, p2_item_id[i], free_slot, p2_item_count[i], p2_item_plate[i]);
    }

    // 5. Обмен деньгами
    if(PlayerTrade[p1][trade_MoneyOffer] > 0)
    {
        GivePlayerMoneyEx(p1, -PlayerTrade[p1][trade_MoneyOffer], "Передача денег через обмен", true, true);
        GivePlayerMoneyEx(p2, PlayerTrade[p1][trade_MoneyOffer], "Получение денег через обмен", true, true);
    }
    if(PlayerTrade[p2][trade_MoneyOffer] > 0)
    {
        GivePlayerMoneyEx(p2, -PlayerTrade[p2][trade_MoneyOffer], "Передача денег через обмен", true, true);
        GivePlayerMoneyEx(p1, PlayerTrade[p2][trade_MoneyOffer], "Получение денег через обмен", true, true);
    }

    Inventory_Save(p1);
    Inventory_Save(p2);

    CloseTrade(p1);
    CloseTrade(p2);

    SendClientMessage(p1, 0x00FF00FF, "{00FF00}Обмен успешно совершён!");
    SendClientMessage(p2, 0x00FF00FF, "{00FF00}Обмен успешно совершён!");
    return 1;
}

// =====================================================================
// /pay - передача денег другому игроку (уже упоминается в /help,
// но самой команды не было реализовано)
// =====================================================================

CMD:pay(playerid, params[])
{
    new targetid, amount;
    if(sscanf(params, "ud", targetid, amount)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /pay [ID/Никнейм] [сумма]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети.");
    if(!IsPlayerLogged(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок ещё не авторизован.");
    if(targetid == playerid) return SendClientMessage(playerid, -1, "{FF0000}Нельзя перевести деньги самому себе.");
    if(amount <= 0) return SendClientMessage(playerid, -1, "{FF0000}Сумма должна быть больше нуля.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, TRADE_INTERACT_DISTANCE, x, y, z)) return SendClientMessage(playerid, -1, "{FF0000}Игрок слишком далеко от вас.");

    if(amount > GetPlayerMoneyEx(playerid)) return SendClientMessage(playerid, -1, "{FF0000}У вас недостаточно денег.");

    new reason_out[96], reason_in[96];
    format(reason_out, sizeof(reason_out), "Перевод игроку %s", GetPlayerNameEx(targetid));
    format(reason_in, sizeof(reason_in), "Перевод от игрока %s", GetPlayerNameEx(playerid));

    if(GivePlayerMoneyEx(playerid, -amount, reason_out, true, true) == -1)
        return SendClientMessage(playerid, -1, "{FF0000}У вас недостаточно денег.");

    GivePlayerMoneyEx(targetid, amount, reason_in, true, true);

    new str[128];
    format(str, sizeof(str), "{66CC00}Вы перевели %d руб. игроку %s.", amount, GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, str);

    format(str, sizeof(str), "{66CC00}%s перевёл вам %d руб.", GetPlayerNameEx(playerid), amount);
    SendClientMessage(targetid, -1, str);

    if(amount >= TRADE_ADMIN_LOG_AMOUNT)
    {
        format(str, sizeof(str), "[Перевод] %s[%d] перевёл %s[%d] сумму %d руб.", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, amount);
        SendMessageToAdmins(str, 0x999999FF);
    }
    return 1;
}
