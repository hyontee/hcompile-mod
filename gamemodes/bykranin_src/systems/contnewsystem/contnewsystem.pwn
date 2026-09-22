//>> Файл: bykranin_src/systems/contnewsystem/contnewsystem.pwn  (1205 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: ContNewSystem_IsValidContainer, ContNewSystem_IsSpecialSlot, ContNewSystem_ResetContainerRuntime, ContNewSystem_ResetPlayer, ContNewSystem_CloseLegacyTextdraw, ContNewSystem_Close, ContNewSystem_GetTypeName
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: contnewsystem.pwn
#if defined _inc_contnewsystem
    #endinput
#endif
#define _inc_contnewsystem

#include "bykranin_src/systems/contnewsystem/contnewsystem_data.inc"
#include "bykranin_src/systems/contnewsystem/contnewsystem_carids.inc"
#include "bykranin_src/systems/contnewsystem/contnewsystem_ru.inc"

#define CONT_NEW_GUI_ID (125)
#define CONT_NEW_WIN_TIMER (30)
#define CONT_NEW_RESPAWN_MS (10000)
#define CONT_NEW_CLOSE_IGNORE_MS (2500)

#if !defined HUD_ELEMENT_CHAT
    #define HUD_ELEMENT_CHAT (0)
#endif

#if !defined HUD_ELEMENT_SHOW
    #define HUD_ELEMENT_SHOW (1)
#endif

#if CONT_NEW_SLOT_COUNT > MAX_CONT
    #error CONT_NEW_SLOT_COUNT is bigger than MAX_CONT
#endif

new g_cont_gui_current[MAX_PLAYERS];
new bool:g_cont_gui_open[MAX_PLAYERS];
new bool:g_cont_gui_reward_view[MAX_PLAYERS];
new g_cont_gui_ignore_close_until[MAX_PLAYERS];

new g_cont_runtime_type[MAX_CONT + 1];
new g_cont_runtime_award_id[MAX_CONT + 1];
new g_cont_runtime_award_type[MAX_CONT + 1];
new g_cont_runtime_award_internal[MAX_CONT + 1];
new g_cont_runtime_award_cost[MAX_CONT + 1];
new g_cont_runtime_award_rarity[MAX_CONT + 1];

stock bool:ContNewSystem_IsValidContainer(contid)
{
    return contid >= 1 && contid <= CONT_NEW_SLOT_COUNT;
}

stock bool:ContNewSystem_IsSpecialSlot(contid)
{
    return contid == CONT_NEW_SLOT_COUNT;
}

stock ContNewSystem_ResetContainerRuntime(contid)
{
    if(contid < 1 || contid > MAX_CONT) return 0;

    g_cont_runtime_type[contid] = -1;
    g_cont_runtime_award_id[contid] = -1;
    g_cont_runtime_award_type[contid] = -1;
    g_cont_runtime_award_internal[contid] = 0;
    g_cont_runtime_award_cost[contid] = 0;
    g_cont_runtime_award_rarity[contid] = 0;
    return 1;
}

stock ContNewSystem_ResetPlayer(playerid)
{
    g_cont_gui_current[playerid] = 0;
    g_cont_gui_open[playerid] = false;
    g_cont_gui_reward_view[playerid] = false;
    g_cont_gui_ignore_close_until[playerid] = 0;
    return 1;
}

stock ContNewSystem_CloseLegacyTextdraw(playerid)
{
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

    TextDrawHideForPlayer(playerid, cont_fon);
    TextDrawHideForPlayer(playerid, cont_take);
    TextDrawHideForPlayer(playerid, cont_sell);
    TextDrawHideForPlayer(playerid, cont_close);
    CancelSelectTextDraw(playerid);

    for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        TextDrawHideForPlayer(playerid, cont_name[cont]);
        TextDrawHideForPlayer(playerid, cont_price[cont]);
        TextDrawHideForPlayer(playerid, cont_model[cont]);
    }
    return 1;
}

stock ContNewSystem_Close(playerid, bool:hide_gui = true)
{
    ContNewSystem_CloseLegacyTextdraw(playerid);

    g_cont_gui_current[playerid] = 0;
    g_cont_gui_open[playerid] = false;
    g_cont_gui_reward_view[playerid] = false;
    g_cont_gui_ignore_close_until[playerid] = 0;

    if(hide_gui)
    {
        HidePlayerGUI(playerid, CONT_NEW_GUI_ID);
    }
    return 1;
}

stock ContNewSystem_GetTypeName(type_id, out[], size = sizeof(out))
{
    if(type_id < 0 || type_id >= CONT_NEW_TYPE_COUNT)
    {
        format(out, size, "Неизвестно");
        return 0;
    }

    format(out, size, "%s", g_cont_new_type_names_ru[type_id]);
    return 1;
}

stock ContNewSystem_GetTypeNameRu(type_id, out[], size = sizeof(out))
{
    if(type_id < 0 || type_id >= CONT_NEW_TYPE_COUNT)
    {
        format(out, size, "Неизвестно");
        return 0;
    }

    format(out, size, "%s", g_cont_new_type_names_ru[type_id]);
    return 1;
}

stock ContNewSystem_GetRewardTypeNameRu(contid, out[], size = sizeof(out))
{
    if(!ContNewSystem_IsValidContainer(contid))
    {
        format(out, size, "Неизвестно");
        return 0;
    }

    if(g_cont_runtime_award_type[contid] >= 0
        && g_cont_runtime_award_type[contid] < sizeof(g_cont_new_award_type_names_ru))
    {
        format(out, size, "%s", g_cont_new_award_type_names_ru[g_cont_runtime_award_type[contid]]);
        return 1;
    }

    format(out, size, "Неизвестно");
    return 0;
}

stock ContNewSystem_GetRewardName(contid, out[], size = sizeof(out))
{
    if(!ContNewSystem_IsValidContainer(contid))
    {
        format(out, size, "Неизвестно");
        return 0;
    }

    switch(g_cont_runtime_award_type[contid])
    {
        case 0:
        {
            new vehicle_name[32];
            GetVehicleModelName(ContNewSystem_GetVehicleGameId(g_cont_runtime_award_internal[contid]), vehicle_name, sizeof(vehicle_name));
            format(out, size, "%s", vehicle_name);
        }
        case 1: format(out, size, "Одежда #%d", g_cont_runtime_award_internal[contid]);
        case 2: format(out, size, "Аксессуар #%d", g_cont_runtime_award_internal[contid]);
        default: format(out, size, "Награда #%d", g_cont_runtime_award_internal[contid]);
    }
    return 1;
}

stock ContNewSystem_GetVisualRewardModel(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 959;

    switch(g_cont_runtime_award_type[contid])
    {
        case 1:
        {
            if(g_cont_runtime_award_rarity[contid] >= 5) return 100418;
            if(g_cont_runtime_award_rarity[contid] >= 3) return 100416;
            return 100414;
        }
        case 2:
        {
            if(g_cont_runtime_award_rarity[contid] >= 5) return 100412;
            if(g_cont_runtime_award_rarity[contid] >= 3) return 100410;
            return 100408;
        }
    }
    return 959;
}

stock ContNewSystem_GetVehicleGameId(internal_id)
{
    for(new i = 0; i < sizeof(g_cont_new_car_game_ids); i++)
    {
        if(g_cont_new_car_game_ids[i][0] == internal_id)
        {
            return g_cont_new_car_game_ids[i][1];
        }
    }
    return internal_id;
}

stock ContNewSystem_GetContainerTimer(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;
    if(cInfo[contid][SaleTime] > 0) return cInfo[contid][SaleTime];
    if(cInfo[contid][Saled]) return CONT_NEW_WIN_TIMER;
    return 0;
}

stock Float:ContNewSystem_GetInteractRange()
{
    // V11 container realfix: use the original small interaction radius.
    // The previous 7m spheres overlapped neighbouring container slots and
    // made the mobile interaction button select/hide against the wrong slot.
    return 4.0;
}

stock ContNewSystem_GetStep(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new step = floatround(float(cInfo[contid][BetPrice]) * 0.05);
    if(step < 1) step = 1;
    return step;
}

stock ContNewSystem_GetNearestContainer(playerid)
{
    // V11 container realfix: choose the physically nearest BUY/interaction
    // point from the original map layout instead of returning the first
    // overlapping 7m area.
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest = 0;
    new Float:best_dist_sq = 999999.0;
    new Float:max_range = ContNewSystem_GetInteractRange();
    new Float:max_dist_sq = max_range * max_range;

    for(new cont = 1; cont <= CONT_NEW_SLOT_COUNT; cont++)
    {
        new Float:dx = px - ContBuyTextPos[cont - 1][0];
        new Float:dy = py - ContBuyTextPos[cont - 1][1];
        new Float:dz = pz - ContBuyTextPos[cont - 1][2];
        new Float:dist_sq = dx * dx + dy * dy + dz * dz;

        if(dist_sq <= max_dist_sq && dist_sq < best_dist_sq)
        {
            best_dist_sq = dist_sq;
            nearest = cont;
        }
    }
    return nearest;
}

stock ContNewSystem_WeightedPick(const ids[], const weights[], count)
{
    new total = 0;

    for(new i = 0; i < count; i++)
    {
        if(ids[i] < 0 || weights[i] <= 0) continue;
        total += weights[i];
    }

    if(total <= 0)
    {
        return ids[0];
    }

    new roll = random(total);
    new cursor = 0;

    for(new i = 0; i < count; i++)
    {
        if(ids[i] < 0 || weights[i] <= 0) continue;

        cursor += weights[i];
        if(roll < cursor)
        {
            return ids[i];
        }
    }
    return ids[0];
}

stock ContNewSystem_PickTypeForSlot(contid)
{
    if(ContNewSystem_IsSpecialSlot(contid))
    {
        return ContNewSystem_WeightedPick(
            g_cont_new_special_ids,
            g_cont_new_special_weights,
            CONT_NEW_SPECIAL_TYPE_COUNT
        );
    }

    return ContNewSystem_WeightedPick(
        g_cont_new_regular_ids,
        g_cont_new_regular_weights,
        CONT_NEW_REGULAR_TYPE_COUNT
    );
}

stock ContNewSystem_FindAwardIndexById(award_id)
{
    for(new i = 0; i < CONT_NEW_AWARD_COUNT; i++)
    {
        if(g_cont_new_awards[i][CNA_AWARD_ID] == award_id) return i;
    }
    return -1;
}

stock ContNewSystem_PickAwardForType(type_id, &award_index)
{
    award_index = -1;
    if(type_id < 0 || type_id >= CONT_NEW_TYPE_COUNT) return 0;

    new picked_award_id = ContNewSystem_WeightedPick(
        g_cont_new_type_award_ids[type_id],
        g_cont_new_type_award_weights[type_id],
        g_cont_new_type_award_count[type_id]
    );

    award_index = ContNewSystem_FindAwardIndexById(picked_award_id);
    return award_index != -1;
}

stock ContNewSystem_UpdateLabel(contid, status, winner_name[] = "")
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new type_name[32];
    new reward_type_name[32];
    new base_price[32];
    new last_bid[32];
    new label[320];
    new timer_line[64];

    ContNewSystem_GetTypeNameRu(g_cont_runtime_type[contid], type_name, sizeof(type_name));
    ContNewSystem_GetRewardTypeNameRu(contid, reward_type_name, sizeof(reward_type_name));
    ConvertMoney(cInfo[contid][ContPrice], base_price);
    ConvertMoney(cInfo[contid][BetPrice], last_bid);
    timer_line[0] = '\0';

    switch(status)
    {
        case 0:
        {
            format(label, sizeof(label),
                CONT_NEW_LABEL_NO_BID,
                contid, type_name, reward_type_name, base_price);
        }
        case 1:
        {
            format(label, sizeof(label),
                CONT_NEW_LABEL_BID,
                contid, type_name, reward_type_name, last_bid, base_price, cInfo[contid][BetedName]);
            format(timer_line, sizeof(timer_line), CONT_NEW_LABEL_TIMER, cInfo[contid][SaleTime]);
            strcat(label, "\n");
            strcat(label, timer_line);
        }
        case 2:
        {
            format(label, sizeof(label),
                CONT_NEW_LABEL_WIN,
                contid, type_name, reward_type_name, last_bid, base_price, winner_name);
        }
        default:
        {
            format(label, sizeof(label),
                CONT_NEW_LABEL_NO_BID,
                contid, type_name, reward_type_name, base_price);
        }
    }

    if(ContsText[contid] == Dynamic3DTextLabel:INVALID_3DTEXT_ID)
    {
        ContsText[contid] = CreateDynamic3DTextLabel(
            label,
            -1,
            cContsPos[contid - 1][0],
            cContsPos[contid - 1][1],
            cContsPos[contid - 1][2] + 1.0,
            10.0,
            INVALID_PLAYER_ID,
            INVALID_VEHICLE_ID,
            false,
            -1
        );
    }
    else
    {
        UpdateDynamic3DTextLabelText(ContsText[contid], -1, label);
    }
    return 1;
}

stock ContNewSystem_SendPacket(playerid, Node:json, bool:open_gui)
{
    new payload[512];
    JSON_Stringify(json, payload, sizeof(payload), false);
    printf("[CONTGUI] outgoing player=%d open=%d payload=%s", playerid, open_gui, payload);

    if(open_gui) ShowPlayerGUI(playerid, CONT_NEW_GUI_ID, json);
    else UpdatePlayerGUI(playerid, CONT_NEW_GUI_ID, json);

    JSON_Cleanup(json);
    return 1;
}

stock ContNewSystem_SendReset(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "cmd", 5);
    OnPacketIncoming(playerid, CONT_NEW_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock ContNewSystem_SendActionStatus(playerid, status)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "cmd", 4);
    JSON_SetInt(json, "status", status);
    OnPacketIncoming(playerid, CONT_NEW_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

stock ContNewSystem_SendAuctionState(playerid, contid, bool:open_gui)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new bidder_name[MAX_PLAYER_NAME];
    bidder_name[0] = '\0';

    if(cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        if(IsPlayerConnected(cInfo[contid][BetedId]))
        {
            GetPlayerName(cInfo[contid][BetedId], bidder_name, sizeof(bidder_name));
        }
        else
        {
            format(bidder_name, sizeof(bidder_name), "%s", cInfo[contid][BetedName]);
        }
    }

    if(!strlen(bidder_name))
    {
        GetPlayerName(playerid, bidder_name, sizeof(bidder_name));
    }

    new step = ContNewSystem_GetStep(contid);
    new Node:json = JSON_Object();

    JSON_SetInt(json, "cmd", 0);
    JSON_SetInt(json, "aid", cInfo[contid][BetedId] == playerid ? 1 : 0);
    JSON_SetInt(json, "bc", cInfo[contid][BetPrice]);
    JSON_SetInt(json, "bhz", step);
    JSON_SetInt(json, "bi", cInfo[contid][ContPrice]);
    JSON_SetInt(json, "bm", cInfo[contid][BetPrice] + step);
    JSON_SetString(json, "bp", bidder_name);
    JSON_SetInt(json, "bs", step);
    JSON_SetInt(json, "bx", GetPlayerMoney(playerid));
    JSON_SetInt(json, "id", g_cont_runtime_type[contid]);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "tm", ContNewSystem_GetContainerTimer(contid));
    JSON_SetInt(json, "type", 1);

    return ContNewSystem_SendPacket(playerid, json, open_gui);
}

stock ContNewSystem_SendRewardState(playerid, contid, bool:open_gui)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new reward_name[64];
    ContNewSystem_GetRewardName(contid, reward_name, sizeof(reward_name));

    new Node:json = JSON_Object();
    JSON_SetInt(json, "cmd", 2);
    JSON_SetInt(json, "id", g_cont_runtime_award_id[contid]);
    JSON_SetString(json, "n", reward_name);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "p", g_cont_runtime_award_cost[contid]);
    JSON_SetInt(json, "pr", g_cont_runtime_award_type[contid]);

    return ContNewSystem_SendPacket(playerid, json, open_gui);
}

stock ContNewSystem_RefreshPlayer(playerid)
{
    if(!g_cont_gui_open[playerid]) return 0;

    new contid = g_cont_gui_current[playerid];
    if(!ContNewSystem_IsValidContainer(contid))
    {
        ContNewSystem_Close(playerid);
        return 0;
    }

    if(!cInfo[contid][Saled] && cInfo[contid][BetedId] == playerid)
    {
        g_cont_gui_reward_view[playerid] = true;
        return ContNewSystem_SendRewardState(playerid, contid, false);
    }

    g_cont_gui_reward_view[playerid] = false;
    return ContNewSystem_SendAuctionState(playerid, contid, false);
}

stock ContNewSystem_RefreshViewers(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!g_cont_gui_open[i]) continue;
        if(g_cont_gui_current[i] != contid) continue;

        ContNewSystem_RefreshPlayer(i);
    }
    return 1;
}

stock ContNewSystem_Open(playerid, contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    ContNewSystem_CloseLegacyTextdraw(playerid);

    g_cont_gui_current[playerid] = contid;
    g_cont_gui_open[playerid] = true;
    g_cont_gui_ignore_close_until[playerid] = GetTickCount() + CONT_NEW_CLOSE_IGNORE_MS;

    printf("[CONTGUI] open player=%d cont=%d type=%d saled=%d bidder=%d price=%d tm=%d",
        playerid,
        contid,
        g_cont_runtime_type[contid],
        cInfo[contid][Saled],
        cInfo[contid][BetedId],
        cInfo[contid][BetPrice],
        ContNewSystem_GetContainerTimer(contid));

    if(!cInfo[contid][Saled] && cInfo[contid][BetedId] == playerid)
    {
        g_cont_gui_reward_view[playerid] = true;
        ContNewSystem_SendReset(playerid);
        return ContNewSystem_SendRewardState(playerid, contid, true);
    }

    g_cont_gui_reward_view[playerid] = false;
    return ContNewSystem_SendAuctionState(playerid, contid, true);
}

stock ContNewSystem_OpenNearby(playerid)
{
    new contid = ContNewSystem_GetNearestContainer(playerid);
    if(!contid) return 0;
    return ContNewSystem_Open(playerid, contid);
}

stock ContNewSystem_ReadBidAmount(Node:json, &amount)
{
    amount = 0;

    if(JSON_GetInt(json, "b", amount)) return 1;
    if(JSON_GetInt(json, "sum", amount)) return 1;
    if(JSON_GetInt(json, "money", amount)) return 1;
    if(JSON_GetInt(json, "bet", amount)) return 1;
    if(JSON_GetInt(json, "bid", amount)) return 1;
    if(JSON_GetInt(json, "value", amount)) return 1;
    if(JSON_GetInt(json, "v", amount)) return 1;
    if(JSON_GetInt(json, "m", amount)) return 1;
    if(JSON_GetInt(json, "bc", amount)) return 1;
    if(JSON_GetInt(json, "bm", amount)) return 1;

    new raw_value[32];

    JSON_GetString(json, "b", raw_value, sizeof(raw_value));
    if(strlen(raw_value))
    {
        amount = strval(raw_value);
        return 1;
    }

    JSON_GetString(json, "sum", raw_value, sizeof(raw_value));
    if(strlen(raw_value))
    {
        amount = strval(raw_value);
        return 1;
    }

    JSON_GetString(json, "money", raw_value, sizeof(raw_value));
    if(strlen(raw_value))
    {
        amount = strval(raw_value);
        return 1;
    }

    JSON_GetString(json, "bet", raw_value, sizeof(raw_value));
    if(strlen(raw_value))
    {
        amount = strval(raw_value);
        return 1;
    }

    JSON_GetString(json, "bid", raw_value, sizeof(raw_value));
    if(strlen(raw_value))
    {
        amount = strval(raw_value);
        return 1;
    }

    return 0;
}

stock ContNewSystem_OpenNative(playerid, contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    if(!IsPlayerInRangeOfPoint(playerid, ContNewSystem_GetInteractRange(),
        ContBuyTextPos[contid - 1][0],
        ContBuyTextPos[contid - 1][1],
        ContBuyTextPos[contid - 1][2]))
    {
        SendClientMessage(playerid, CLR_RED, "Подойдите ближе к контейнеру.");
        return 1;
    }

    // V11 container interaction realfix: the user's mobile client does not
    // expose the custom GUI 125 used by ContNewSystem_Open(). Use ordinary
    // SA-MP dialogs here so interaction works on every launcher build.
    g_cont_gui_current[playerid] = 0;
    g_cont_gui_open[playerid] = false;
    g_cont_gui_reward_view[playerid] = false;
    pInfo[playerid][BetUseCont] = contid;
    pInfo[playerid][BuyUseCont] = contid;

    if(!cInfo[contid][Saled])
    {
        if(cInfo[contid][BetedId] != playerid)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Торги по этому контейнеру завершены", " ");
            return 1;
        }

        new reward_name[64], reward_price[32], reward_body[192], reward_title[64];
        ContNewSystem_GetRewardName(contid, reward_name, sizeof(reward_name));
        ConvertMoney(g_cont_runtime_award_cost[contid], reward_price);
        format(reward_title, sizeof(reward_title), "Контейнер #%d | Награда", contid);
        format(reward_body, sizeof(reward_body),
            "Забрать: %s\nПродать за %s руб.",
            reward_name, reward_price);
        return ShowPlayerDialog(playerid, DIALOG_CONT_NATIVE_REWARD, DIALOG_STYLE_LIST, reward_title, reward_body, "Выбрать", "Закрыть");
    }

    new current_bid[32], min_bid_str[32], start_price[32], bidder_name[MAX_PLAYER_NAME];
    new bid_title[64], bid_body[512];
    ConvertMoney(cInfo[contid][BetPrice], current_bid);
    ConvertMoney(cInfo[contid][BetPrice] + ContNewSystem_GetStep(contid), min_bid_str);
    ConvertMoney(cInfo[contid][ContPrice], start_price);

    if(cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        if(IsPlayerConnected(cInfo[contid][BetedId])) GetPlayerName(cInfo[contid][BetedId], bidder_name, sizeof(bidder_name));
        else format(bidder_name, sizeof(bidder_name), "%s", cInfo[contid][BetedName]);
    }
    else format(bidder_name, sizeof(bidder_name), "Нет");

    format(bid_title, sizeof(bid_title), "Контейнер #%d | Торги", contid);
    format(bid_body, sizeof(bid_body),
        "Начальная ставка: %s руб.\nТекущая ставка: %s руб.\nЛидер: %s\nМинимальная новая ставка: %s руб.\nДо конца торгов: %d сек.\n\nВведите сумму ставки:",
        start_price, current_bid, bidder_name, min_bid_str, ContNewSystem_GetContainerTimer(contid));
    return ShowPlayerDialog(playerid, DIALOG_CONT_NATIVE_BID, DIALOG_STYLE_INPUT, bid_title, bid_body, "Ставка", "Закрыть");
}

stock ContNewSystem_TryBid(playerid, contid, bid_amount)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new notify_msg[144];

    if(!cInfo[contid][Saled])
    {
        format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_AUCTION_CLOSED);
        ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
        ContNewSystem_RefreshPlayer(playerid);
        return 1;
    }

    if(cInfo[contid][BetedId] == playerid)
    {
        format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_ALREADY_LEADER);
        ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
        ContNewSystem_RefreshPlayer(playerid);
        return 1;
    }

    new min_bid = cInfo[contid][BetPrice] + ContNewSystem_GetStep(contid);
    if(bid_amount < min_bid)
    {
        new error_msg[96], moneystr[32];
        ConvertMoney(min_bid, moneystr);
        format(error_msg, sizeof(error_msg), CONT_NEW_MSG_MIN_BID_FMT, contid, moneystr);
        ShowNotificationNew(playerid, 2, 6, 0, 0, error_msg, " ");
        ContNewSystem_RefreshPlayer(playerid);
        return 1;
    }

    if(GetPlayerMoney(playerid) < bid_amount)
    {
        format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_NOT_ENOUGH_MONEY);
        ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
        ContNewSystem_RefreshPlayer(playerid);
        return 1;
    }

    if(cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        new old_bidder = cInfo[contid][BetedId];
        if(IsPlayerConnected(old_bidder))
        {
            new overbid_msg[144];
            GivePlayerMoneyEx(old_bidder, cInfo[contid][BetPrice]);
            format(overbid_msg, sizeof(overbid_msg), CONT_NEW_CHAT_BID_OVERBID, contid);
            ShowNotificationNew(old_bidder, 2, 6, 0, 0, overbid_msg, " ");
            SendClientMessage(old_bidder, -1, overbid_msg);
        }
    }

    new player_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, player_name, sizeof(player_name));

    cInfo[contid][BetPrice] = bid_amount;
    cInfo[contid][BetedId] = playerid;
    format(cInfo[contid][BetedName], MAX_PLAYER_NAME, "%s", player_name);

    GivePlayerMoneyEx(playerid, -bid_amount, "Container GUI bid", true, true);
    StartContBidding(contid);

    printf("[CONTGUI] bid success player=%d cont=%d bid=%d step=%d type=%d",
        playerid, contid, bid_amount, ContNewSystem_GetStep(contid), g_cont_runtime_type[contid]);

    new bid_money[32], bid_success_msg[144], reserve_msg[144];
    ConvertMoney(bid_amount, bid_money);
    format(bid_success_msg, sizeof(bid_success_msg), CONT_NEW_CHAT_BID_SUCCESS, contid, bid_money);
    format(reserve_msg, sizeof(reserve_msg), CONT_NEW_CHAT_BID_RESERVED, bid_money, contid);
    ShowNotificationNew(playerid, 3, 6, 0, 0, bid_success_msg, " ");
    SendClientMessage(playerid, -1, bid_success_msg);
    SendClientMessage(playerid, -1, reserve_msg);

    ContNewSystem_RefreshViewers(contid);
    return 1;
}

stock bool:ContNewSystem_GiveReward(playerid, contid)
{
    switch(g_cont_runtime_award_type[contid])
    {
        case 0:
        {
            new internal_id = g_cont_runtime_award_internal[contid];
            new game_id = ContNewSystem_GetVehicleGameId(internal_id);
            SetPVarInt(playerid, "BUY_CAR_COLOR", cInfo[contid][ContVehicleColor]);
            if(BuyPlayerCar(playerid, internal_id, game_id, cInfo[contid][ContVehicleColor]) == -1)
            {
                DeletePVar(playerid, "BUY_CAR_COLOR");
                printf("[CONTGUI] reward vehicle failed player=%d cont=%d internal=%d game=%d color=%d",
                    playerid, contid, internal_id, game_id, cInfo[contid][ContVehicleColor]);
                return false;
            }
            return true;
        }
        case 1:
        {
            GivePlayerOwnableSkinEx(playerid, g_cont_runtime_award_internal[contid]);
            return true;
        }
        case 2:
        {
            new inv_item_id, acc_modelid;
            if(!Inv11_ResolveAccessoryReward(g_cont_runtime_award_internal[contid], inv_item_id, acc_modelid))
            {
                printf("[CONTGUI] reward accessory unresolved player=%d cont=%d internal=%d",
                    playerid, contid, g_cont_runtime_award_internal[contid]);
                return false;
            }

            if(Inventory11_AddItemToDatabase(playerid, inv_item_id, acc_modelid, 1, 0, 0) == -1)
            {
                printf("[CONTGUI] reward accessory add failed player=%d cont=%d item=%d model=%d",
                    playerid, contid, inv_item_id, acc_modelid);
                return false;
            }
            return true;
        }
    }
    return false;
}

stock ContNewSystem_ProcessRewardAction(playerid, contid, bool:sell_reward)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new notify_msg[160];

    if(cInfo[contid][Saled] || cInfo[contid][BetedId] != playerid)
    {
        format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_REWARD_UNAVAILABLE);
        ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
        ContNewSystem_RefreshPlayer(playerid);
        return 1;
    }

    if(!IsPlayerInRangeOfPoint(playerid, ContNewSystem_GetInteractRange(),
        ContBuyTextPos[contid - 1][0],
        ContBuyTextPos[contid - 1][1],
        ContBuyTextPos[contid - 1][2]))
    {
        format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_CLOSER);
        ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
        return 1;
    }

    new reward_name[64], moneystr[32], reward_msg[160];
    ContNewSystem_GetRewardName(contid, reward_name, sizeof(reward_name));

    if(sell_reward)
    {
        GivePlayerMoneyEx(playerid, g_cont_runtime_award_cost[contid]);
        ConvertMoney(g_cont_runtime_award_cost[contid], moneystr);
        format(reward_msg, sizeof(reward_msg), CONT_NEW_HINT_REWARD_SELL, moneystr, reward_name);
        ShowNotificationNew(playerid, 1, 6, 0, 0, reward_msg, " ");
        SendClientMessage(playerid, -1, reward_msg);
    }
    else
    {
        if(!ContNewSystem_GiveReward(playerid, contid))
        {
            format(notify_msg, sizeof(notify_msg), "%s", CONT_NEW_MSG_REWARD_FAILED);
            ShowNotificationNew(playerid, 2, 6, 0, 0, notify_msg, " ");
            return 1;
        }

        format(reward_msg, sizeof(reward_msg), CONT_NEW_HINT_REWARD_TAKE, reward_name);
        ShowNotificationNew(playerid, 3, 6, 0, 0, reward_msg, " ");
        SendClientMessage(playerid, -1, reward_msg);
    }

    DestroyObject(cInfo[contid][ContObjectId]);
    DestroyObject(cInfo[contid][ContObjectDoorLId]);
    DestroyObject(cInfo[contid][ContObjectDoorRId]);
    DestroyObject(cInfo[contid][ContObjectOdejdaId]);
    DestroyVehicle(cInfo[contid][ContVehicleId]);
    KillTimer(ContsTimer[contid]);
    ResetContInfo(contid);
    ContNewSystem_ResetContainerRuntime(contid);
    pInfo[playerid][BuyUseCont] = 0;
    pInfo[playerid][BetUseCont] = 0;

    if(ContsRespawnTimer[contid] != 0) KillTimer(ContsRespawnTimer[contid]);
    ContsRespawnTimer[contid] = SetTimerEx("SpawnNewCont", CONT_NEW_RESPAWN_MS, false, "i", contid);

    // Native-dialog users never opened GUI 125, so do not send unknown
    // GUI packets back to their client after taking/selling the reward.
    if(g_cont_gui_open[playerid])
    {
        ContNewSystem_SendActionStatus(playerid, 1);
        ContNewSystem_Close(playerid);
    }
    else
    {
        ContNewSystem_Close(playerid, false);
    }
    ContNewSystem_RefreshViewers(contid);

    printf("[CONTGUI] reward action player=%d cont=%d sell=%d award=%d type=%d",
        playerid, contid, sell_reward, g_cont_runtime_award_id[contid], g_cont_runtime_award_type[contid]);
    return 1;
}

stock bool:ContNewSystem_IsClosePayload(payload[])
{
    if(strfind(payload, "\"c\":1", true) != -1) return true;
    if(strfind(payload, "\"c\": 1", true) != -1) return true;
    return false;
}

stock ContNewSystem_HandlePacket(playerid, Node:json)
{
    new payload[512];
    JSON_Stringify(json, payload, sizeof(payload), false);
    printf("[CONTGUI] incoming player=%d payload=%s", playerid, payload);

    new cmd = -1;
    JSON_GetInt(json, "cmd", cmd);

    new contid = g_cont_gui_current[playerid];
    if(!ContNewSystem_IsValidContainer(contid))
    {
        contid = ContNewSystem_GetNearestContainer(playerid);
        if(contid) g_cont_gui_current[playerid] = contid;
    }

    if(cmd == 5 || (cmd == -1 && ContNewSystem_IsClosePayload(payload)))
    {
        if(GetTickCount() < g_cont_gui_ignore_close_until[playerid])
        {
            printf("[CONTGUI] ignore close player=%d cont=%d payload=%s", playerid, contid, payload);
            return ContNewSystem_RefreshPlayer(playerid);
        }

        printf("[CONTGUI] close player=%d cont=%d", playerid, contid);
        return ContNewSystem_Close(playerid, false);
    }

    if(!ContNewSystem_IsValidContainer(contid))
    {
        new cont_error[64];
        format(cont_error, sizeof(cont_error), "%s", CONT_NEW_MSG_CONTAINER_NOT_FOUND);
        ShowNotificationNew(playerid, 2, 6, 0, 0, cont_error, " ");
        return 1;
    }

    switch(cmd)
    {
        case 0, 1:
        {
            new bid_amount;
            if(ContNewSystem_ReadBidAmount(json, bid_amount) && bid_amount > 0)
            {
                return ContNewSystem_TryBid(playerid, contid, bid_amount);
            }
            return ContNewSystem_SendAuctionState(playerid, contid, false);
        }
        case 2:
        {
            if(!cInfo[contid][Saled] && cInfo[contid][BetedId] == playerid)
            {
                return ContNewSystem_SendRewardState(playerid, contid, false);
            }
            return ContNewSystem_SendAuctionState(playerid, contid, false);
        }
        case 3:
        {
            return ContNewSystem_ProcessRewardAction(playerid, contid, false);
        }
        case 4:
        {
            return ContNewSystem_ProcessRewardAction(playerid, contid, true);
        }
    }

    printf("[CONTGUI] unknown cmd player=%d cont=%d cmd=%d", playerid, contid, cmd);
    ContNewSystem_RefreshPlayer(playerid);
    return 1;
}

stock ContNewSystem_SpawnContainer(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new type_id = ContNewSystem_PickTypeForSlot(contid);
    new award_index;
    if(!ContNewSystem_PickAwardForType(type_id, award_index))
    {
        printf("[CONTGUI] spawn failed cont=%d type=%d: no award", contid, type_id);
        return 1;
    }

    g_cont_runtime_type[contid] = type_id;
    g_cont_runtime_award_id[contid] = g_cont_new_awards[award_index][CNA_AWARD_ID];
    g_cont_runtime_award_type[contid] = g_cont_new_awards[award_index][CNA_TYPE];
    g_cont_runtime_award_internal[contid] = g_cont_new_awards[award_index][CNA_INTERNAL_ID];
    g_cont_runtime_award_rarity[contid] = g_cont_new_awards[award_index][CNA_RARITY];
    g_cont_runtime_award_cost[contid] = g_cont_new_awards[award_index][CNA_COST];
    if(g_cont_runtime_award_cost[contid] <= 0)
    {
        g_cont_runtime_award_cost[contid] = g_cont_new_types[type_id][CNT_START_PRICE];
    }

    cInfo[contid][ContRegion] = 0;
    cInfo[contid][ItemType] = g_cont_runtime_award_type[contid];
    cInfo[contid][Item] = g_cont_runtime_award_internal[contid];
    cInfo[contid][ContPrice] = g_cont_new_types[type_id][CNT_START_PRICE];
    cInfo[contid][BetPrice] = cInfo[contid][ContPrice];
    cInfo[contid][ItemPrice] = g_cont_runtime_award_cost[contid];
    cInfo[contid][Saled] = true;
    cInfo[contid][SaleTime] = 0;
    cInfo[contid][BetedId] = INVALID_PLAYER_ID;
    cInfo[contid][BetedName][0] = '\0';
    cInfo[contid][ContVehicleColor] = 1 + random(126);

    // V11 container realfix: use the original map geometry. The custom
    // g_cont_new_slots coordinates placed bodies too low / too close and
    // doors at mismatched offsets, which caused visible intersections.
    cInfo[contid][ContObjectId] = CreateObject(
        g_cont_new_types[type_id][CNT_OBJ_MODEL],
        cContsPos[contid - 1][0],
        cContsPos[contid - 1][1],
        cContsPos[contid - 1][2],
        0.0,
        0.0,
        cContsPos[contid - 1][3]
    );

    cInfo[contid][ContObjectDoorLId] = CreateObject(
        g_cont_new_types[type_id][CNT_DOOR_MODEL_L],
        cContsPos[contid - 1][4],
        cContsPos[contid - 1][5],
        cContsPos[contid - 1][6],
        0.0,
        0.0,
        cContsPos[contid - 1][7]
    );

    cInfo[contid][ContObjectDoorRId] = CreateObject(
        g_cont_new_types[type_id][CNT_DOOR_MODEL_R],
        cContsPos[contid - 1][8],
        cContsPos[contid - 1][9],
        cContsPos[contid - 1][10],
        0.0,
        0.0,
        cContsPos[contid - 1][11]
    );

    if(ContsText[contid] != Dynamic3DTextLabel:INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(ContsText[contid]);
        ContsText[contid] = Dynamic3DTextLabel:INVALID_3DTEXT_ID;
    }

    if(ContArea[contid] != 0)
    {
        DestroyDynamicArea(ContArea[contid]);
    }
    ContArea[contid] = CreateDynamicSphere(
        ContBuyTextPos[contid - 1][0],
        ContBuyTextPos[contid - 1][1],
        ContBuyTextPos[contid - 1][2],
        ContNewSystem_GetInteractRange()
    );

    ContNewSystem_UpdateLabel(contid, 0);
    ContNewSystem_RefreshViewers(contid);

    printf("[CONTGUI] spawn cont=%d type=%d award=%d reward_type=%d internal=%d cost=%d",
        contid,
        type_id,
        g_cont_runtime_award_id[contid],
        g_cont_runtime_award_type[contid],
        g_cont_runtime_award_internal[contid],
        g_cont_runtime_award_cost[contid]);
    return 1;
}

stock ContNewSystem_StartBidding(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    new moneystr[32];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);

    cInfo[contid][Saled] = true;
    cInfo[contid][SaleTime] = CONT_NEW_WIN_TIMER;
    KillTimer(ContsTimer[contid]);
    ContsTimer[contid] = SetTimerEx("TimerSecondUpdateCont", 1000, true, "ds", contid, moneystr);

    ContNewSystem_UpdateLabel(contid, cInfo[contid][BetedId] != INVALID_PLAYER_ID ? 1 : 0);
    ContNewSystem_RefreshViewers(contid);
    return 1;
}

stock ContNewSystem_OpenRewardPreview(contid)
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    if(g_cont_runtime_award_type[contid] == 0)
    {
        new vehicle_model = ContNewSystem_GetVehicleGameId(g_cont_runtime_award_internal[contid]);
        cInfo[contid][ContVehicleId] = CreateVehicle(
            vehicle_model,
            cContsPos[contid - 1][0],
            cContsPos[contid - 1][1],
            cContsPos[contid - 1][2] + 0.6,
            cContsPos[contid - 1][3] + 90.0,
            cInfo[contid][ContVehicleColor],
            1,
            0
        );
        SetVehicleParamsEx(cInfo[contid][ContVehicleId], false, false, false, true, false, false, false);
        ChangeVehicleColor(cInfo[contid][ContVehicleId], cInfo[contid][ContVehicleColor], 0);
        return 1;
    }

    cInfo[contid][ContObjectOdejdaId] = CreateObject(
        ContNewSystem_GetVisualRewardModel(contid),
        cContsPos[contid - 1][0],
        cContsPos[contid - 1][1],
        cContsPos[contid - 1][2],
        0.0,
        0.0,
        cContsPos[contid - 1][3]
    );
    return 1;
}

stock ContNewSystem_TimerSecondUpdate(contid, moneystart[])
{
    if(!ContNewSystem_IsValidContainer(contid)) return 0;

    if(cInfo[contid][SaleTime] > 0)
    {
        cInfo[contid][SaleTime]--;
        ContNewSystem_UpdateLabel(contid, cInfo[contid][BetedId] != INVALID_PLAYER_ID ? 1 : 0);
        ContNewSystem_RefreshViewers(contid);
        return 1;
    }

    KillTimer(ContsTimer[contid]);
    ContsTimer[contid] = 0;
    cInfo[contid][Saled] = false;

    if(cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        new winnerid = cInfo[contid][BetedId];
        new winner_name[MAX_PLAYER_NAME];
        GetPlayerName(winnerid, winner_name, sizeof(winner_name));

        // V11 container realfix: keep the original hinge position and use
        // the original +/-128 degree door swing. The custom open coordinates
        // visibly detached / crossed the doors on several slots.
        MoveObject(
            cInfo[contid][ContObjectDoorLId],
            cContsPos[contid - 1][4],
            cContsPos[contid - 1][5],
            cContsPos[contid - 1][6],
            8.5,
            0.0,
            0.0,
            cContsPos[contid - 1][7] + 128.0
        );

        MoveObject(
            cInfo[contid][ContObjectDoorRId],
            cContsPos[contid - 1][8],
            cContsPos[contid - 1][9],
            cContsPos[contid - 1][10],
            8.5,
            0.0,
            0.0,
            cContsPos[contid - 1][11] - 128.0
        );

        ContNewSystem_OpenRewardPreview(contid);
        ContNewSystem_UpdateLabel(contid, 2, winner_name);

        new win_money[32], win_msg[144];
        ConvertMoney(cInfo[contid][BetPrice], win_money);
        format(win_msg, sizeof(win_msg), CONT_NEW_CHAT_BID_WIN, contid, win_money);
        ShowNotificationNew(winnerid, 3, 6, 0, 0, win_msg, " ");
        SendClientMessage(winnerid, -1, win_msg);

        printf("[CONTGUI] winner cont=%d player=%d award=%d type=%d internal=%d",
            contid, winnerid, g_cont_runtime_award_id[contid], g_cont_runtime_award_type[contid], g_cont_runtime_award_internal[contid]);

        if(ContsRespawnTimer[contid] != 0) KillTimer(ContsRespawnTimer[contid]);
        ContsRespawnTimer[contid] = SetTimerEx("SpawnNewCont", 60000, false, "i", contid);
    }
    else
    {
        printf("[CONTGUI] no bids cont=%d respawn=%d", contid, CONT_NEW_RESPAWN_MS);
        if(ContsRespawnTimer[contid] != 0) KillTimer(ContsRespawnTimer[contid]);
        ContsRespawnTimer[contid] = SetTimerEx("SpawnNewCont", CONT_NEW_RESPAWN_MS, false, "i", contid);
    }

    ContNewSystem_RefreshViewers(contid);
    return 1;
}

CMD:contgui(playerid, params[])
{
    new contid = 0;
    if(strlen(params)) contid = strval(params);
    else contid = ContNewSystem_GetNearestContainer(playerid);

    if(!ContNewSystem_IsValidContainer(contid))
    {
        SendClientMessage(playerid, CLR_RED, CONT_NEW_MSG_CONTGUI_USAGE);
        return 1;
    }

    return ContNewSystem_Open(playerid, contid);
}
// END INLINED: contnewsystem.pwn
