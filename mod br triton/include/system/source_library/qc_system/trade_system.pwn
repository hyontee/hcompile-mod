#if !defined MAX_INVENTORY_SLOTS
    #define MAX_INVENTORY_SLOTS 40
#endif

#define MAX_TRADE_SLOTS 12

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

forward UpdateTradeUI(playerid);
public UpdateTradeUI(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    return 1;
}

CMD:trade(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{FFCC00}Использование: /trade [ID/Никнейм]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "{FF0000}Игрок не в сети.");
    if(targetid == playerid) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете торговать сами с собой.");
    
    if(PlayerTrade[playerid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}У вас уже открыто окно трейда.");
    if(PlayerTrade[targetid][trade_IsOpen]) return SendClientMessage(playerid, -1, "{FF0000}Этот игрок уже торгует с кем-то другим.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(!IsPlayerInRangeOfPoint(targetid, 5.0, x, y, z)) return SendClientMessage(playerid, -1, "{FF0000}Игрок слишком далеко от вас.");

    SetPVarInt(targetid, "Trade_Request_From", playerid);
    
    new str[128], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(str, sizeof(str), "{66CC00}%s предложил вам обмен. Для согласия введите {FFFF00}/accept trade{66CC00}.", name);
    SendClientMessage(targetid, -1, str);
    
    GetPlayerName(targetid, name, sizeof(name));
    format(str, sizeof(str), "{66CC00}Игроку %s отправлено предложение обмена. Ожидайте ответа...", name);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:accept(playerid, params[])
{
    if(!strcmp(params, "trade", true))
    {
        new inviter = GetPVarInt(playerid, "Trade_Request_From");
        if(!IsPlayerConnected(inviter) || inviter == INVALID_PLAYER_ID) 
        {
            SendClientMessage(playerid, -1, "{FF0000}Предложение обмена не найдено или игрок вышел.");
            return 1;
        }
        
        DeletePVar(playerid, "Trade_Request_From");
        
        ResetTradeData(playerid, inviter);
        ResetTradeData(inviter, playerid);
        
        OpenTradeInterface(playerid);
        OpenTradeInterface(inviter);
        return 1;
    }
    return 0;
}

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

stock ClickItemInInventory(playerid, inv_slot, item_id, item_count)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили трейд!");

    for(new i = 0; i < MAX_TRADE_SLOTS; i++) {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == inv_slot) return SendClientMessage(playerid, -1, "{FF0000}Этот предмет уже добавлен в трейд!");
    }

    new trade_idx = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++) {
        if(PlayerTrade[playerid][trade_ItemSlot][i] == -1) {
            trade_idx = i;
            break;
        }
    }

    if(trade_idx == -1) return SendClientMessage(playerid, -1, "{FF0000}Вы не можете добавить более 12 предметов.");

    PlayerTrade[playerid][trade_ItemSlot][trade_idx] = inv_slot;
    PlayerTrade[playerid][trade_ItemId][trade_idx] = item_id;
    PlayerTrade[playerid][trade_ItemCount][trade_idx] = item_count;
    
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    UpdateTradeUI(playerid);
    UpdateTradeUI(targetid);
    return 1;
}

stock ClickItemInTradeOffer(playerid, trade_slot)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили трейд!");

    if(PlayerTrade[playerid][trade_ItemSlot][trade_slot] == -1) return 0;

    PlayerTrade[playerid][trade_ItemSlot][trade_slot] = -1;
    PlayerTrade[playerid][trade_ItemId][trade_slot] = 0;
    PlayerTrade[playerid][trade_ItemCount][trade_slot] = 0;

    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    UpdateTradeUI(playerid);
    UpdateTradeUI(targetid);
    return 1;
}

stock OfferMoneyInTrade(playerid, amount)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    if(PlayerTrade[playerid][trade_IsConfirmed]) return SendClientMessage(playerid, -1, "{FF0000}Вы уже подтвердили трейд!");
    if(GetPlayerMoney(playerid) < amount) return SendClientMessage(playerid, -1, "{FF0000}У вас нет столько денег.");

    PlayerTrade[playerid][trade_MoneyOffer] = amount;
    
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    new targetid = PlayerTrade[playerid][trade_TargetID];
    PlayerTrade[targetid][trade_IsConfirmed] = 0;

    UpdateTradeUI(playerid);
    UpdateTradeUI(targetid);
    return 1;
}

stock ClickConfirmTrade(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    if(PlayerTrade[playerid][trade_IsConfirmed])
    {
        PlayerTrade[playerid][trade_IsConfirmed] = 0;
        SendClientMessage(playerid, -1, "Вы отменили подтверждение.");
        UpdateTradeUI(playerid);
        UpdateTradeUI(targetid);
        return 1;
    }

    PlayerTrade[playerid][trade_IsConfirmed] = 1;
    SendClientMessage(playerid, -1, "{66CC00}Готовность подтверждена. Ожидание второго игрока...");
    
    UpdateTradeUI(playerid);
    UpdateTradeUI(targetid);

    if(PlayerTrade[playerid][trade_IsConfirmed] && PlayerTrade[targetid][trade_IsConfirmed])
    {
        FinalizeTrade(playerid, targetid);
    }
    return 1;
}

stock FinalizeTrade(p1, p2)
{
    if(GetPlayerMoney(p1) < PlayerTrade[p1][trade_MoneyOffer] || GetPlayerMoney(p2) < PlayerTrade[p2][trade_MoneyOffer])
    {
        SendClientMessage(p1, -1, "{FF0000}Сделка отменена: у одного из игроков недостаточно средств.");
        SendClientMessage(p2, -1, "{FF0000}Сделка отменена: у одного из игроков недостаточно средств.");
        CloseTrade(p1);
        CloseTrade(p2);
        return 0;
    }

    if(PlayerTrade[p1][trade_MoneyOffer] > 0)
    {
        GivePlayerMoney(p1, -PlayerTrade[p1][trade_MoneyOffer]);
        GivePlayerMoney(p2, PlayerTrade[p1][trade_MoneyOffer]);
    }
    if(PlayerTrade[p2][trade_MoneyOffer] > 0)
    {
        GivePlayerMoney(p2, -PlayerTrade[p2][trade_MoneyOffer]);
        GivePlayerMoney(p1, PlayerTrade[p2][trade_MoneyOffer]);
    }

    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(PlayerTrade[p1][trade_ItemSlot][i] != -1)
        {
            Inventory_DeleteSlot(p1, PlayerTrade[p1][trade_ItemSlot][i], PlayerTrade[p1][trade_ItemCount][i]);
            Inventory_Add(p2, PlayerTrade[p1][trade_ItemId][i], PlayerTrade[p1][trade_ItemCount][i]);
        }
        if(PlayerTrade[p2][trade_ItemSlot][i] != -1)
        {
            Inventory_DeleteSlot(p2, PlayerTrade[p2][trade_ItemSlot][i], PlayerTrade[p2][trade_ItemCount][i]);
            Inventory_Add(p1, PlayerTrade[p2][trade_ItemId][i], PlayerTrade[p2][trade_ItemCount][i]);
        }
    }

    Inventory_Save(p1);
    Inventory_Save(p2);

    CloseTrade(p1);
    CloseTrade(p2);

    SendClientMessage(p1, -1, "{00FF00}Обмен успешно завершен!");
    SendClientMessage(p2, -1, "{00FF00}Обмен успешно завершен!");
    return 1;
}

stock CancelTrade(playerid)
{
    if(!PlayerTrade[playerid][trade_IsOpen]) return 0;
    
    new targetid = PlayerTrade[playerid][trade_TargetID];
    
    CloseTrade(playerid);
    CloseTrade(targetid);
    
    SendClientMessage(playerid, -1, "{FF0000}Сделка отменена.");
    SendClientMessage(targetid, -1, "{FF0000}Второй игрок отменил сделку.");
    return 1;
}

stock CloseTrade(playerid)
{
    PlayerTrade[playerid][trade_IsOpen] = false;
    PlayerTrade[playerid][trade_TargetID] = INVALID_PLAYER_ID;
    PlayerTrade[playerid][trade_IsConfirmed] = 0;
    PlayerTrade[playerid][trade_MoneyOffer] = 0;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        PlayerTrade[playerid][trade_ItemSlot][i] = -1;
        PlayerTrade[playerid][trade_ItemId][i] = 0;
        PlayerTrade[playerid][trade_ItemCount][i] = 0;
    }
}