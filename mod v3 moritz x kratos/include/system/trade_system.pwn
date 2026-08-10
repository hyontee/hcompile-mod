// ==========================================
//          СИСТЕМА ТРЕЙДА
// ==========================================

#include <a_samp>

// ---------- НАСТРОЙКИ ----------
#if !defined MAX_INVENTORY_SLOTS
    #define MAX_INVENTORY_SLOTS 40
#endif

#define MAX_TRADE_SLOTS 12

// ---------- СТРУКТУРА ТРЕЙДА ----------
enum e_TRADE_STATUS
{
    trade_TargetID,
    trade_IsConfirmed,
    bool:trade_IsOpen,
    trade_MoneyOffer,
    trade_ItemSlot[MAX_TRADE_SLOTS],
    trade_ItemId[MAX_TRADE_SLOTS],
    trade_ItemCount[MAX_TRADE_SLOTS]
};

new PlayerTrade[MAX_PLAYERS][e_TRADE_STATUS];

// ==========================================
//          КОМАНДЫ
// ==========================================

CMD:trade(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) 
        return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /trade [ID/Никнейм]");
    
    if(!IsPlayerConnected(targetid)) 
        return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети.");
    if(targetid == playerid) 
        return SendClientMessage(playerid, -1, "{FF0000}Вы не можете торговать сами с собой.");
    if(PlayerTrade[playerid][trade_IsOpen]) 
        return SendClientMessage(playerid, -1, "{FF0000}У вас уже открыт трейд.");
    if(PlayerTrade[targetid][trade_IsOpen]) 
        return SendClientMessage(playerid, -1, "{FF0000}Этот игрок сейчас занят другим обменом.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, 5.0, x, y, z)) 
        return SendClientMessage(playerid, -1, "{FF0000}Игрок слишком далеко от вас.");

    SetPVarInt(targetid, "Trade_Request_From", playerid);
    
    new str[128];
    format(str, sizeof(str), "{66CC00}%s предлагает вам обменяться предметами. Введите {FFFF00}/accept trade{66CC00} для согласия.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, -1, str);
    
    format(str, sizeof(str), "{66CC00}Вы отправили предложение обмена %s. Ожидайте ответа...", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, -1, str);
    return 1;
}

// ==========================================
//          ПРИНЯТИЕ ТРЕЙДА
// ==========================================

CMD:accept(playerid, params[])
{
    new arg[16];
    if(sscanf(params, "s[16]", arg)) 
        return SendClientMessage(playerid, -1, "{FFCC00}Используйте: /accept trade");
    
    if(strcmp(arg, "trade", true) == 0)
    {
        AcceptTradeOffer(playerid);
    }
    return 1;
}

stock AcceptTradeOffer(playerid)
{
    new inviter = GetPVarInt(playerid, "Trade_Request_From");
    if(!IsPlayerConnected(inviter) || inviter == INVALID_PLAYER_ID) 
    {
        SendClientMessage(playerid, -1, "{FF0000}Предложение обмена не найдено или игрок вышел.");
        return 0;
    }
    
    DeletePVar(playerid, "Trade_Request_From");
    
    ResetTradeData(playerid, inviter);
    ResetTradeData(inviter, playerid);
    
    OpenTradeInterface(playerid);
    OpenTradeInterface(inviter);
    return 1;
}

// ==========================================
//          ОСНОВНЫЕ ФУНКЦИИ
// ==========================================

stock ResetTradeData(playerid, targetid)
{
    PlayerTrade[playerid][trade_TargetID] = targetid;
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    PlayerTrade[playerid][trade_IsOpen] = true;
    PlayerTrade[playerid][trade_MoneyOffer] = 0;
    
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        PlayerTrade[playerid][trade_ItemSlot][i] = -1;
        PlayerTrade[playerid][trade_ItemId][i] = 0;
        PlayerTrade[playerid][trade_ItemCount][i] = 0;
    }
}

stock OpenTradeInterface(playerid)
{
    UpdateTradeUI(playerid);
}

// ==========================================
//          ОБНОВЛЕНИЕ UI
// ==========================================

forward UpdateTradeUI(playerid);
public UpdateTradeUI(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    // Здесь должен быть твой код обновления CEF/интерфейса
    
    return 1;
}

// ==========================================
//          РАБОТА С ПРЕДМЕТАМИ В ТРЕЙДЕ
// ==========================================

// Добавление предмета в трейд
stock ClickItemInInventory(playerid, inv_slot)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) 
        return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили сделку! Сбросьте её, чтобы изменить предметы.");

    // Проверка на существование предмета (заглушка)
    if(inv_slot < 0 || inv_slot >= MAX_INVENTORY_SLOTS) return 0;

    for(new i = 0; i < MAX_TRADE_SLOTS; i++) 
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == inv_slot) 
            return SendClientMessage(playerid, -1, "{FF0000}Этот предмет уже в трейде!");
    }

    new trade_idx = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++) 
    {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == -1) 
        {
            trade_idx = i;
            break;
        }
    }

    if(trade_idx == -1) 
        return SendClientMessage(playerid, -1, "{FF0000}Вы не можете выставить больше 12 предметов на обмен.");

    // Вместо g_PlayerInventory используем заглушку
    PlayerTrade[playerid][trade_ItemSlot][trade_idx] = inv_slot;
    PlayerTrade[playerid][trade_ItemId][trade_idx] = 1;
    PlayerTrade[playerid][trade_ItemCount][trade_idx] = 1;

    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    UpdateTradeUI(playerid);
    return 1;
}

// Удаление предмета из трейда
stock ClickItemInTradeOffer(playerid, trade_slot)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) 
        return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили сделку! Сбросьте её сначала.");

    if(trade_slot < 0 || trade_slot >= MAX_TRADE_SLOTS) return 0;
    if(PlayerTrade[playerid][trade_ItemSlot][trade_slot] == -1) return 0;

    PlayerTrade[playerid][trade_ItemSlot][trade_slot] = -1;
    PlayerTrade[playerid][trade_ItemId][trade_slot] = 0;
    PlayerTrade[playerid][trade_ItemCount][trade_slot] = 0;

    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    UpdateTradeUI(playerid);
    return 1;
}

// ==========================================
//          ЧАТ В ТРЕЙДЕ
// ==========================================

stock SendTradeChatMessage(playerid, const text[])
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;

    new targetid = PlayerTrade[playerid][trade_TargetID];
    new str[150];

    format(str, sizeof(str), "[Трейд] %s: %s", GetPlayerNameEx(playerid), text);
    
    SendClientMessage(playerid, 0xFFAA00AA, str);
    SendClientMessage(targetid, 0xFFAA00AA, str);
    return 1;
}

// ==========================================
//          ПОДТВЕРЖДЕНИЕ ОБМЕНА
// ==========================================

stock ClickConfirmTrade(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    if(PlayerTrade[playerid][trade_IsConfirmed])
    {
        PlayerTrade[playerid][trade_IsConfirmed] = 0;
        SendClientMessage(playerid, -1, "Вы отменили подтверждение сделки.");
        UpdateTradeUI(playerid);
        return 1;
    }

    PlayerTrade[playerid][trade_IsConfirmed] = 1;
    SendClientMessage(playerid, -1, "{66CC00}Вы подтвердили готовность к обмену. Ожидание второго игрока...");
    
    UpdateTradeUI(playerid);

    if(PlayerTrade[playerid][trade_IsConfirmed] && PlayerTrade[targetid][trade_IsConfirmed])
    {
        FinalizeTrade(playerid, targetid);
    }
    return 1;
}

// ==========================================
//          ФИНАЛЬНЫЙ ОБМЕН
// ==========================================

stock FinalizeTrade(p1, p2)
{
    // Обмен предметами от p1 к p2
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[p1][trade_ItemSlot][i] != -1)
        {
            // Здесь логика добавления предмета
            // Inventory_Add(p2, PlayerTrade[p1][trade_ItemId][i], PlayerTrade[p1][trade_ItemCount][i]);
            // Inventory_DeleteSlot(p1, PlayerTrade[p1][trade_ItemSlot][i]);
        }
    }

    // Обмен предметами от p2 к p1
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[p2][trade_ItemSlot][i] != -1)
        {
            // Здесь логика добавления предмета
            // Inventory_Add(p1, PlayerTrade[p2][trade_ItemId][i], PlayerTrade[p2][trade_ItemCount][i]);
            // Inventory_DeleteSlot(p2, PlayerTrade[p2][trade_ItemSlot][i]);
        }
    }

    CloseTrade(p1);
    CloseTrade(p2);

    SendClientMessage(p1, -1, "{00FF00}Обмен успешно совершен!");
    SendClientMessage(p2, -1, "{00FF00}Обмен успешно совершен!");
}

stock CloseTrade(playerid)
{
    PlayerTrade[playerid][trade_IsOpen] = false;
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    // Код закрытия окна
}

// ==========================================
//          ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ==========================================

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}