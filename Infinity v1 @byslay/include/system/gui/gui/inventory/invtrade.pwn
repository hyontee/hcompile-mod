// trade.inc
#define MAX_TRADE_SLOTS 40
#define MAX_PLAYER_TRADES 10

// Статусы трейда
#define TRADE_STATUS_NONE 0
#define TRADE_STATUS_OFFERED 1
#define TRADE_STATUS_ACCEPTED 2
#define TRADE_STATUS_CONFIRMED 3
#define TRADE_STATUS_COMPLETED 4


// Данные трейда
enum E_TRADE_DATA
{
    trade_player1,
    trade_player2,
    trade_status1,
    trade_status2,
    trade_money1,
    trade_money2,
    trade_time,
    bool:trade_active,
    bool:trade_both_ready
}

// Предмет в трейде
enum E_TRADE_ITEM
{
    tr_itemId,
    tr_itemCount,
    tr_itemSlot,
    tr_itemPlate[32],
    tr_itemType,
    tr_itemWeight,
    tr_itemName[64],
    tr_fromSlot
}

// Глобальные переменные
new g_TradeData[MAX_PLAYER_TRADES][E_TRADE_DATA];
new g_PlayerTradeID[MAX_PLAYERS] = {-1, ...};
new g_PlayerTradeItems[MAX_PLAYERS][MAX_TRADE_SLOTS][E_TRADE_ITEM];
new g_PlayerTradeMoney[MAX_PLAYERS];
new g_PlayerTradeBlock[MAX_PLAYERS];

// ============================================================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ============================================================================

stock GetTradePartner(playerid)
{
    new tradeId = g_PlayerTradeID[playerid];
    if(tradeId == -1) return -1;
    
    if(g_TradeData[tradeId][trade_player1] == playerid)
        return g_TradeData[tradeId][trade_player2];
    else if(g_TradeData[tradeId][trade_player2] == playerid)
        return g_TradeData[tradeId][trade_player1];
    
    return -1;
}

stock ResetPlayerTradeItems(playerid)
{
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        g_PlayerTradeItems[playerid][i][tr_itemId] = 0;
        g_PlayerTradeItems[playerid][i][tr_itemCount] = 0;
        g_PlayerTradeItems[playerid][i][tr_itemSlot] = i;
        g_PlayerTradeItems[playerid][i][tr_itemPlate][0] = 0;
        g_PlayerTradeItems[playerid][i][tr_itemType] = 0;
        g_PlayerTradeItems[playerid][i][tr_itemWeight] = 0;
        g_PlayerTradeItems[playerid][i][tr_itemName][0] = 0;
        g_PlayerTradeItems[playerid][i][tr_fromSlot] = -1;
    }
    g_PlayerTradeMoney[playerid] = 0;
}

stock IsPlayerInTrade(playerid)
{
    return (g_PlayerTradeID[playerid] != -1);
}

stock TradeSendStatus(playerid, status)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", 7);
    JSON_SetInt(resp, "s", status);
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock TradeSendPartnerItem(playerid, packet_type, item_id, item_value, plate_text[])
{
    if(!IsPlayerConnected(playerid)) return 0;

    new Node:resp = JSON_Object();
    JSON_SetInt(resp, "t", packet_type);
    JSON_SetInt(resp, "ga", item_id);
    JSON_SetInt(resp, "s", item_value);
    if(strlen(plate_text))
    {
        JSON_SetString(resp, "nt", plate_text, strlen(plate_text));
    }
    SendPacketToClient(playerid, 33, resp);
    JSON_Cleanup(resp);
    return 1;
}

stock ShowPlayerTradeGUI(playerid, to_player)
{
    new Node:JSONObject = JSON_Object();
    new Node:itemsArray = JSON_Array();
    new Node:aiArray = JSON_Array();
    new Node:exchangeItems = JSON_Array();
    new Node:otherExchangeItems = JSON_Array();
    new Node:tempArray;
    
    new tradeId = g_PlayerTradeID[playerid];
    if(tradeId == -1)
    {
        JSON_Cleanup(JSONObject);
        return 0;
    }
    
    // Данные игрока
    new skinid = GetPlayerSkin(playerid);
    new weight = GetPlayerWeight(playerid);
    new maxWeight = GetPlayerMaxWeight(playerid);
    new money = GetPlayerMoney(playerid);
    new level = GetPlayerLevel(playerid);
    new phoneNumber = GetPlayerPhone(playerid);
    
    // Данные другого игрока
    new otherMoney = GetPlayerMoney(to_player);
    new otherSkin = GetPlayerSkin(to_player);
    new otherWeight = GetPlayerWeight(to_player);
    new otherMaxWeight = GetPlayerMaxWeight(to_player);
    
    // Ваш инвентарь
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] > 0)
        {
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
    }
    
    // Активные слоты
    for(new i = 0; i < MAX_ACTIVE_SLOTS; i++)
    {
        if(g_PlayerActiveSlots[playerid][i][inv_itemId] > 0)
        {
            new itemId = g_PlayerActiveSlots[playerid][i][inv_itemId];
            new itemCount = g_PlayerActiveSlots[playerid][i][inv_itemCount];
            
            if(itemId == 134)
            {
                tempArray = JSON_Array(
                    JSON_Int(134),
                    JSON_Int(GetPlayerSkin(playerid)),
                    JSON_Int(6),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(itemCount),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            if(strlen(g_PlayerActiveSlots[playerid][i][inv_itemPlate]) > 0)
            {
                JSON_SetString(tempArray, "nt", g_PlayerActiveSlots[playerid][i][inv_itemPlate]);
            }
            
            aiArray = JSON_Append(aiArray, tempArray);
        }
    }
    
    // Ваши предметы в трейде
    new otherPlayer = GetTradePartner(playerid);
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(g_PlayerTradeItems[playerid][i][tr_itemId] > 0)
        {
            new itemId = g_PlayerTradeItems[playerid][i][tr_itemId];
            
            if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_String(g_PlayerTradeItems[playerid][i][tr_itemPlate]),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            else
            {
                tempArray = JSON_Array(
                    JSON_Int(itemId),
                    JSON_Int(g_PlayerTradeItems[playerid][i][tr_itemCount]),
                    JSON_Int(i),
                    JSON_Int(0)
                );
            }
            
            exchangeItems = JSON_Append(exchangeItems, tempArray);
        }
        else
        {
            tempArray = JSON_Array(JSON_Int(0), JSON_Int(0), JSON_Int(i), JSON_Int(0));
            exchangeItems = JSON_Append(exchangeItems, tempArray);
        }
    }
    
    // Предметы другого игрока в трейде
    if(otherPlayer != -1)
    {
        for(new i = 0; i < MAX_TRADE_SLOTS; i++)
        {
            if(g_PlayerTradeItems[otherPlayer][i][tr_itemId] > 0)
            {
                new itemId = g_PlayerTradeItems[otherPlayer][i][tr_itemId];
                
                if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
                {
                    tempArray = JSON_Array(
                        JSON_Int(itemId),
                        JSON_String(g_PlayerTradeItems[otherPlayer][i][tr_itemPlate]),
                        JSON_Int(i),
                        JSON_Int(0)
                    );
                }
                else
                {
                    tempArray = JSON_Array(
                        JSON_Int(itemId),
                        JSON_Int(g_PlayerTradeItems[otherPlayer][i][tr_itemCount]),
                        JSON_Int(i),
                        JSON_Int(0)
                    );
                }
                
                otherExchangeItems = JSON_Append(otherExchangeItems, tempArray);
            }
            else
            {
                tempArray = JSON_Array(JSON_Int(0), JSON_Int(0), JSON_Int(i), JSON_Int(0));
                otherExchangeItems = JSON_Append(otherExchangeItems, tempArray);
            }
        }
    }
    
    // Статусы
    new status1 = g_TradeData[tradeId][trade_status1];
    new status2 = g_TradeData[tradeId][trade_status2];
    new myStatus = (g_TradeData[tradeId][trade_player1] == playerid) ? status1 : status2;
    new otherStatus = (g_TradeData[tradeId][trade_player1] == playerid) ? status2 : status1;
    
    JSONObject = JSON_Object(
        "o", JSON_Int(1),
        "i", JSON_Int(1),
        "n", JSON_String(GetPlayerNameEx(playerid)),
        "lv", JSON_Int(level),
        "id", JSON_Int(playerid),
        "v", JSON_Int(3),
        "ps", JSON_Int(skinid),
        "m", JSON_Int(money),
        "s", JSON_Int(79),
        "w", JSON_Int(weight),
        "mw", JSON_Int(maxWeight),
        "sl", JSON_Int(MAX_INVENTORY_SLOTS),
        "nm", JSON_Int(phoneNumber),
        "en", JSON_String(GetPlayerNameEx(to_player)),
        "gm", JSON_Int(otherMoney),
        "gs", JSON_Int(otherSkin),
        "gw", JSON_Int(otherWeight),
        "gmw", JSON_Int(otherMaxWeight),
        "ts", JSON_Int(myStatus),
        "to", JSON_Int(otherStatus),
        "tm", JSON_Int(g_PlayerTradeMoney[playerid]),
        "tom", JSON_Int(g_PlayerTradeMoney[to_player]),
        "it", itemsArray,
        "ai", aiArray,
        "ex", exchangeItems,
        "oe", otherExchangeItems
    );
    
    SendPacketToClient(playerid, 33, JSONObject);
    
    JSON_Cleanup(itemsArray);
    JSON_Cleanup(aiArray);
    JSON_Cleanup(exchangeItems);
    JSON_Cleanup(otherExchangeItems);
    JSON_Cleanup(JSONObject);
    
    return 1;
}