#include <a_samp>
#include <Pawn.CMD> // АВТОР СЛИВА: @TomarisCRMP

// --- НАСТРОЙКИ И ДЕФАЙНЫ ---
#if !defined MAX_INVENTORY_SLOTS
    #define MAX_INVENTORY_SLOTS 40
#endif

#define MAX_TRADE_SLOTS 12 // На скрине 1000039008.jpg слева 12 слотов (3х4)

enum e_TRADE_STATUS
{
    trade_TargetID,       // С кем торгуем
    trade_IsConfirmed,    // Нажал ли кнопку "Обменяться"
    bool:trade_IsOpen,    // Открыто ли окно трейда сейчас
    trade_MoneyOffer,     // Сколько денег предлагает игрок
    // Храним информацию о предметах в самом трейде
    trade_ItemSlot[MAX_TRADE_SLOTS],  // Из какого слота инвентаря взят предмет
    trade_ItemId[MAX_TRADE_SLOTS],    // ID предмета
    trade_ItemCount[MAX_TRADE_SLOTS]  // Количество / ID скина
};

new PlayerTrade[MAX_PLAYERS][e_TRADE_STATUS];

// Переменные из твоей новой модульной системы инвентаря (для совместимости)
extern g_PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][inv_itemId];
extern g_PlayerInventory[MAX_PLAYERS][MAX_INVENTORY_SLOTS][inv_itemCount];

// --- ВСПЛЫВАЮЩИЕ ФУНКЦИИ И СИНХРОНИЗАЦИЯ ---

// Обновление интерфейса для ОБОИХ игроков
forward UpdateTradeUI(playerid);
public UpdateTradeUI(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    // 1. Отправляем на CEF/Текстдравы playerid его собственное окно
    // Тут должен быть твой код вызова пакетов/кастомных функций для отрисовки.
    // Пример концепта:
    // CallRemoteFunction("CEF_UpdateTradeLeft", "i", playerid); // Показываем то, что отдаем
    // CallRemoteFunction("CEF_UpdateInventoryRight", "i", playerid); // Показываем остаток инвентаря
    
    // 2. СИНХРОНИЗАЦИЯ: Отправляем данные второму игроку (targetid), чтобы у него ИЗМЕНИЛОСЬ окно "Игрок предлагает вам"
    if(PlayerTrade[targetid][trade_IsOpen] && PlayerTrade[targetid][trade_TargetID] == playerid)
    {
        // Передаем на CEF targetid данные о предметах в PlayerTrade[playerid]
        // Таким образом у второго игрока сразу ПРИНУДИТЕЛЬНО ОБНОВЛЯЕТСЯ И ОТКРЫВАЕТСЯ то, что добавил первый.
        // Пример:
        // CEF_RefreshPartnerOffer(targetid, playerid);
    }
    return 1;
}

// --- КОМАНДА ДЛЯ ОТПРАВКИ ТРЕЙДА ---

CMD:trade(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /trade [ID/Никнейм]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети.");
    if(targetid == playerid) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете торговать сами с собой.");
    
    if(PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас уже открыт трейд.");
    if(PlayerTrade[targetid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}Этот игрок сейчас занят другим обменом.");

    // Проверяем дистанцию между игроками
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, 5.0, x, y, z)) return SendClientMessage(playerid, -1, "{FF0000}Игрок слишком далеко от вас.");

    // Отправляем предложение
    SetPVarInt(targetid, "Trade_Request_From", playerid);
    
    new str[128];
    format(str, sizeof(str), "{66CC00}%s предлагает вам обменяться предметами. Введите {FFFF00}/accept trade{66CC00} для согласия.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, -1, str);
    
    format(str, sizeof(str), "{66CC00}Вы отправили предложение обмена %s. Ожидайте ответа...", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, str);
    return 1;
}

// Принятие трейда (вставлять в твою команду /accept)
stock AcceptTradeOffer(playerid)
{
    new inviter = GetPVarInt(playerid, "Trade_Request_From");
    if(!IsPlayerConnected(inviter) || inviter == INVALID_PLAYER_ID) 
    {
        SendClientMessage(playerid, -1, "{FF0000}Предложение обмена не найдено или игрок вышел.");
        return 0;
    }
    
    DeletePVar(playerid, "Trade_Request_From");
    
    // Инициализируем очистку данных трейда для обоих
    ResetTradeData(playerid, inviter);
    ResetTradeData(inviter, playerid);
    
    // Открываем CEF интерфейс (как на скрине 1000039008.jpg)
    OpenTradeInterface(playerid);
    OpenTradeInterface(inviter);
    return 1;
}

// Очистка данных перед началом сделки
stock ResetTradeData(playerid, targetid)
{
    PlayerTrade[playerid][trade_TargetID] = targetid;
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    PlayerTrade[playerid][trade_IsOpen] = true;
    PlayerTrade[playerid][trade_MoneyOffer] = 0;
    
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        PlayerTrade[playerid][trade_ItemSlot[i]] = -1;
        PlayerTrade[playerid][trade_ItemId[i]] = 0;
        PlayerTrade[playerid][trade_ItemCount[i]] = 0;
    }
}

stock OpenTradeInterface(playerid)
{
    // Здесь вызывается показ твоего CEF диалога, который на скрине 1000039008.jpg
    // Передаем туда ник игрока (Вы отдаете %s), баланс, предметы из инвентаря.
    UpdateTradeUI(playerid);
}

// --- ЛОГИКА НАЖАТИЯ НА ПРЕДМЕТЫ (ПЕРЕМЕЩЕНИЕ И ИСЧЕЗНОВЕНИЕ) ---

// Функция срабатывает, когда игрок кликает на предмет в ИНВЕНТАРЕ (Справа на скрине)
stock ClickItemInInventory(playerid, inv_slot)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили сделку! Сбросьте её, чтобы изменить предметы.");

    // Проверяем, не пустой ли слот в инвентаре
    if(g_PlayerInventory[playerid][inv_slot][inv_itemId] == 0) return 0;[span_1](start_span)[span_1](end_span)

    // Проверяем, не добавлен ли этот слот УЖЕ в трейд
    for(new i = 0; i < MAX_TRADE_SLOTS; i++) {
        if(PlayerTrade[playerid][trade_ItemSlot[i]] == inv_slot) return SendClientMessage(playerid, -1, "{FF0000}Этот предмет уже в трейде!");
    }

    // Ищем свободное место в левом окне трейда (Предложение)
    new trade_idx = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++) {
        if(PlayerTrade[playerid][trade_ItemSlot[i]] == -1) {
            trade_idx = i;
            break;
        }
    }

    if(trade_idx == -1) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете выставить больше 12 предметов на обмен.");

    // Переносим данные в трейд
    PlayerTrade[playerid][trade_ItemSlot[trade_idx]] = inv_slot;
    PlayerTrade[playerid][trade_ItemId[trade_idx]] = g_PlayerInventory[playerid][inv_slot][inv_itemId];[span_2](start_span)[span_2](end_span)
    PlayerTrade[playerid][trade_ItemCount[trade_idx]] = g_PlayerInventory[playerid][inv_slot][inv_itemCount];[span_3](start_span)[span_3](end_span)

    // Сбрасываем статус готовности у обоих (так как условия сделки поменялись)
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    // Обновляем UI — предмет визуально «пропадает» из инвентаря и прыгает в трейд,
    // а у второго игрока моментально обновляется список входящих вещей
    UpdateTradeUI(playerid);
    return 1;
}

// Функция срабатывает, когда игрок кликает на предмет в своем ТРЕЙДЕ (Слева на скрине, хочет убрать его из сделки)
stock ClickItemInTradeOffer(playerid, trade_slot)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили сделку! Сбросьте её сначала.");

    if(PlayerTrade[playerid][trade_ItemSlot[trade_slot]] == -1) return 0;

    // Просто очищаем слот в трейде (в инвентаре `g_PlayerInventory` он и так лежал, мы его не удаляли из памяти)
    PlayerTrade[playerid][trade_ItemSlot[trade_slot]] = -1;
    PlayerTrade[playerid][trade_ItemId[trade_slot]] = 0;
    PlayerTrade[playerid][trade_ItemCount[trade_slot]] = 0;

    // Сбрасываем готовность обоих игроков
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    // Обновляем визуальную часть для обоих сторон
    UpdateTradeUI(playerid);
    return 1;
}

// --- ЧАТ ВНУТРИ ТРЕЙДА ---

// Вызывай эту функцию, когда игрок пишет сообщение в поле "ОТКРЫТЬ ЧАТ" (на скрине снизу по центру)
stock SendTradeChatMessage(playerid, const text[])
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    new str[150];

    // Форматируем сообщение локального чата сделки
    format(str, sizeof(str), "[Трейд] %s: %s", GetPlayerNameEx(playerid), text);
    
    // Отправляем обоим участникам сделки в чат (или в кастомное окно чата на CEF)
    SendClientMessage(playerid, 0xFFAA00AA, str);
    SendClientMessage(targetid, 0xFFAA00AA, str);
    return 1;
}

// --- ПОДТВЕРЖДЕНИЕ И ОКОНЧАТЕЛЬНЫЙ ОБМЕН ---

// Вызывается при нажатии кнопки "ОБМЕНЯТЬСЯ" (Оранжевая кнопка справа снизу)
stock ClickConfirmTrade(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    if(PlayerTrade[playerid][trade_IsConfirmed])
    {
        // Если уже нажимал, повторное нажатие отменяет готовность
        PlayerTrade[playerid][trade_IsConfirmed] = 0;
        SendClientMessage(playerid, -1, "Вы отменили подтверждение сделки.");
        UpdateTradeUI(playerid);
        return 1;
    }

    PlayerTrade[playerid][trade_IsConfirmed] = 1;
    SendClientMessage(playerid, -1, "{66CC00}Вы подтвердили готовность к обмену. Ожидание второго игрока...");
    
    // Сигнализируем второму игроку через UI (Например, плашка снизу "Вам нужно подождать...") изменит текст
    UpdateTradeUI(playerid);

    // Если ОБА игрока подтвердили — проводим финальную выдачу/удаление предметов
    if(PlayerTrade[playerid][trade_IsConfirmed] && PlayerTrade[targetid][trade_IsConfirmed])
    {
        FinalizeTrade(playerid, targetid);
    }
    return 1;
}

// Проведение транзакции и чистка инвентарей
stock FinalizeTrade(p1, p2)
{
    // 1. Проверяем лимиты веса свободных мест у обоих игроков перед удалением чего-либо
    // (Используем функции `Inventory_CanAddEntryWeight` из твоей системы инвентаря)

    // 2. Проводим циклы удаления предметов из оригинальных слотов `g_PlayerInventory` и запись их новому владельцу
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        // Предметы от Первого игрока ко Второму
        if(PlayerTrade[p1][trade_ItemSlot[i]] != -1)
        {
            new orig_slot = PlayerTrade[p1][trade_ItemSlot[i]];
            // Добавляем второму игроку
            Inventory_Add(p2, PlayerTrade[p1][trade_ItemId[i]], PlayerTrade[p1][trade_ItemCount[i]]);
            // Удаляем у первого
            Inventory_DeleteSlot(p1, orig_slot);
        }

        // Предметы от Второго игрока к Первому
        if(PlayerTrade[p2][trade_ItemSlot[i]] != -1)
        {
            new orig_slot = PlayerTrade[p2][trade_ItemSlot[i]];
            // Добавляем первому игроку
            Inventory_Add(p1, PlayerTrade[p2][trade_ItemId[i]], PlayerTrade[p2][trade_ItemCount[i]]);
            // Удаляем у второго
            Inventory_DeleteSlot(p2, orig_slot);
        }
    }

    // 3. Обмен деньгами (если вводились суммы в поле "Ваши денежные средства")
    // GivePlayerMoney(p1, -PlayerTrade[p1][trade_MoneyOffer]);
    // GivePlayerMoney(p2, PlayerTrade[p1][trade_MoneyOffer]);
    // ... и наоборот для p2 ...

    // Сохраняем инвентари в базу данных
    Inventory_Save(p1);
    Inventory_Save(p2);

    // Закрываем интерфейсы
    CloseTrade(p1);
    CloseTrade(p2);

    SendClientMessage(p1, -1, "{00FF00}Обмен успешно совершен!");
    SendClientMessage(p2, -1, "{00FF00}Обмен успешно совершен!");
}

stock CloseTrade(playerid)
{
    PlayerTrade[playerid][trade_IsOpen] = false;
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    // Код закрытия CEF окна на клиенте
}

// Вспомогательный сток получения имени
stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
