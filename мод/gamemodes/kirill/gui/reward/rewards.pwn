#if defined _POKOE_REWARD_GUI_INCLUDED
    #endinput
#endif
#define _POKOE_REWARD_GUI_INCLUDED

// /reward для структуры pokoe_67.
// Подключать после gamemodes/kirill/gui/cases/cases.pwn и до gamemodes/kirill/ipacket.inc.

#if !defined GUIReward
    #define GUIReward 74
#endif

#if !defined BP_REWARD_CASE_STANDARD
    #define BP_REWARD_CASE_STANDARD (90)
#endif
#if !defined BP_REWARD_CASE_PREMIUM
    #define BP_REWARD_CASE_PREMIUM (91)
#endif

stock Rewards_DBInit()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `rewards` (`id` INT NOT NULL AUTO_INCREMENT, `uid` INT NOT NULL, `award_id` INT NOT NULL, `case_id` INT NOT NULL, PRIMARY KEY (`id`), KEY `uid` (`uid`), KEY `case_id` (`case_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251;"
    );
    return 1;
}

stock GetPlayerDustValue(playerid)
{
    return pCasesDust[playerid];
}

stock AddPlayerDustValue(playerid, amount)
{
    pCasesDust[playerid] += amount;
    if(pCasesDust[playerid] < 0) pCasesDust[playerid] = 0;
    Cases_SavePlayer(playerid);
    return pCasesDust[playerid];
}

stock Reward_FormatName(rewardType, rewardValue, rewardCount, name[], name_size = sizeof(name))
{
    switch(rewardType)
    {
        case REWARD_TYPE_EXP: format(name, name_size, "%d EXP", rewardCount);
        case REWARD_TYPE_MONEY: format(name, name_size, "%d Р", rewardCount);
        case REWARD_TYPE_BC: format(name, name_size, "%d BC", rewardCount);
        case REWARD_TYPE_CASE: format(name, name_size, "Кейс x%d", rewardCount);
        case REWARD_TYPE_VEHICLE: format(name, name_size, "Транспорт %d", rewardValue);
        case REWARD_TYPE_VIP: format(name, name_size, "VIP %d на %d ч.", rewardValue, rewardCount);
        case REWARD_TYPE_BP_EXP: format(name, name_size, "%d BP EXP", rewardCount);
        case REWARD_TYPE_ITEM:
        {
            if(rewardValue == 134) format(name, name_size, "Скин %d", rewardCount);
            else format(name, name_size, "Предмет %d x%d", rewardValue, rewardCount);
        }
        case REWARD_TYPE_DUST: format(name, name_size, "Пыль x%d", rewardCount);
        case REWARD_TYPE_EVENT_RES: format(name, name_size, "Ивент ресурс x%d", rewardCount);
        default: format(name, name_size, "Награда");
    }
    return 1;
}

stock Reward_GetElementId(rewardType, rewardValue, rewardCount)
{
    switch(rewardType)
    {
        case REWARD_TYPE_MONEY, REWARD_TYPE_BC, REWARD_TYPE_EXP, REWARD_TYPE_BP_EXP, REWARD_TYPE_DUST, REWARD_TYPE_EVENT_RES:
            return rewardCount;
    }
    return rewardValue;
}

stock Reward_FindAwardData(caseId, awardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity, &sprayPrice, name[], name_size = sizeof(name))
{
    new caseIdx = Cases_GetIndex(caseId);
    if(caseIdx == -1) return 0;

    // В новой системе awardId обычно является id награды из cases.json.
    for(new i = 0; i < CaseData[caseIdx][cAwardsCount]; i++)
    {
        if(CaseAwards[caseIdx][i][aId] == awardId)
        {
            rewardType = CaseAwards[caseIdx][i][aType];
            rewardValue = CaseAwards[caseIdx][i][aInternalId];
            rewardCount = CaseAwards[caseIdx][i][aCount];
            rewardRarity = CaseAwards[caseIdx][i][aRarity];
            sprayPrice = CaseAwards[caseIdx][i][aPriceSprayed];
            Reward_FormatName(rewardType, rewardValue, rewardCount, name, name_size);
            return 1;
        }
    }


    // Case bonus reward support: /reward can store bonus id in award_id too.
    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++)
    {
        if(CaseBonus[caseIdx][b][bId] == awardId)
        {
            rewardType = CaseBonus[caseIdx][b][bType];
            rewardValue = CaseBonus[caseIdx][b][bInternalId];
            rewardCount = CaseBonus[caseIdx][b][bCount];
            rewardRarity = CaseBonus[caseIdx][b][bRarity];
            sprayPrice = CaseBonus[caseIdx][b][bPriceSprayed];
            Reward_FormatName(rewardType, rewardValue, rewardCount, name, name_size);
            return 1;
        }
    }

    // Старые записи rewards могли хранить award_id как индекс массива с 0.
    if(awardId >= 0 && awardId < CaseData[caseIdx][cAwardsCount])
    {
        rewardType = CaseAwards[caseIdx][awardId][aType];
        rewardValue = CaseAwards[caseIdx][awardId][aInternalId];
        rewardCount = CaseAwards[caseIdx][awardId][aCount];
        rewardRarity = CaseAwards[caseIdx][awardId][aRarity];
        sprayPrice = CaseAwards[caseIdx][awardId][aPriceSprayed];
        Reward_FormatName(rewardType, rewardValue, rewardCount, name, name_size);
        return 1;
    }

    return 0;
}

stock Reward_AddVehicle(playerid, modelid)
{
    new query[1024], Cache:result;
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `ownable_cars` (`owner_id`,`model_id`,`comfort`,`sport`,`sport_plus`,`drift`,`wheels_kl`,`wheels_size`,`wheels_raz`,`wheels_otkl`,`color_1`,`color_2`,`pos_x`,`pos_y`,`pos_z`,`angle`,`number`,`region`,`number_type`,`status`,`alarm`,`key_in`,`mileage`,`create_time`,`vinilcar`,`pt_engine`,`pt_brake`,`pt_stability`,`nitro`,`launch`,`fars`,`diski`,`fuel`,`health`) VALUES (%d,%d,0,0,0,0,0.0,0.0,0,0.0,1,1,2477.5002,-741.7479,11.3153,69.2541,'none','--',0,0,0,0,0.0,%d,0,0,0,0,0,0,0,0,40.0,1000.0)",
        GetPlayerAccountID(playerid), modelid, gettime());
    result = mysql_query(mysql, query, true);
    cache_delete(result);
    if(mysql_errno())
    {
        SendClientMessage(playerid, 0xFF5533FF, "{FF5252}| {FFFFFF}Ошибка добавления транспорта в гараж.");
        return 0;
    }
    SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Транспорт добавлен. Загрузите его через /car.");
    return 1;
}


stock Reward_IsCaseSkinModel(modelid)
{
    // SkinMapping is not present in this mod structure.
    // Accept standard GTA skins and BR/CRMP custom skins used by cases.
    if(0 <= modelid <= 311) return 1;
    if(5000 <= modelid <= 30000) return 1;
    return 0;
}

stock Reward_AddInventoryItem(playerid, itemId, count)
{
    // Case reward may store skin as raw modelid. Convert it to skin item 134.
    if(itemId != 134 && count <= 1 && Reward_IsCaseSkinModel(itemId))
    {
        count = itemId;
        itemId = 134;
    }

    // case reward may store accessory as modelid; convert it to inventory item id.
    if(itemId != 134)
    {
        new convertedItem = -1;

        if(Accessory_GetModelIdByItemId(itemId) == -1)
        {
            convertedItem = Accessory_GetItemIdByModel(itemId);
            if(convertedItem == -1 && count > 0) convertedItem = Accessory_GetItemIdByModel(count);

            if(convertedItem != -1)
            {
                itemId = convertedItem;
                count = 1;
            }
        }
        else
        {
            count = 1;
        }
    }

    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1) return 0;

    new plate[32] = "";
    if(itemId == 58)
    {
        new phoneNumber = 1000000 + random(9000000);
        format(plate, sizeof(plate), "%d", phoneNumber);
    }
    if(itemId == 59 || itemId == 81 || itemId == 82 || itemId == 83)
    {
        format(plate, sizeof(plate), "A123AA 777");
    }

    if(!Inventory_AddItem(playerid, itemId, freeSlot, count, plate)) return 0;
    SaveInventoryItem(playerid, freeSlot);
    return 1;
}

stock Reward_GiveToPlayer(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus)
{
    #pragma unused rewardRarity
    #pragma unused isBonus

    switch(rewardType)
    {
        case REWARD_TYPE_EXP:
        {
            AddPlayerData(playerid, P_EXP, +, rewardCount);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            new msg[96];
            format(msg, sizeof(msg), "Вы получили EXP: %d", rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        case REWARD_TYPE_MONEY:
        {
            GivePlayerMoneyEx(playerid, rewardCount, "Reward", true, true);
        }
        case REWARD_TYPE_BC:
        {
            GivePlayerDonateRub(playerid, rewardCount, "Reward", true, true);
        }
        case REWARD_TYPE_CASE:
        {
            Cases_GivePlayerCaseById(playerid, rewardValue, rewardCount);
            new msg[96];
            format(msg, sizeof(msg), "Вы получили кейс x%d", rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        case REWARD_TYPE_VEHICLE:
        {
            Reward_AddVehicle(playerid, rewardValue);
        }
        case REWARD_TYPE_VIP:
        {
            new addTime = rewardCount * 3600;
            new baseTime = GetPlayerData(playerid, P_PREMIUM_DATE);
            if(baseTime < gettime()) baseTime = gettime();

            SetPlayerData(playerid, P_PREMIUM, rewardValue);
            SetPlayerData(playerid, P_PREMIUM_DATE, baseTime + addTime);
            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
            ShowNotificationKirill(playerid, 1, 5, 1, 0, "VIP награда активирована", "");
        }
        case REWARD_TYPE_BP_EXP:
        {
            // В этом моде полноценный Black Pass не подключен, поэтому BP EXP не теряется: выдаём как обычный EXP.
            AddPlayerData(playerid, P_EXP, +, rewardCount);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            new msg[96];
            format(msg, sizeof(msg), "Вы получили BP EXP: %d", rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        case REWARD_TYPE_ITEM:
        {
            if(!Reward_AddInventoryItem(playerid, rewardValue, rewardCount))
                return ShowNotificationKirill(playerid, 2, 5, 1, 1, "Нет свободного места в инвентаре", ""), 0;

            new msg[96];
            if(rewardValue == 134) format(msg, sizeof(msg), "Вы получили скин: %d", rewardCount);
            else format(msg, sizeof(msg), "Вы получили предмет %d x%d", rewardValue, rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        case REWARD_TYPE_DUST:
        {
            AddPlayerDustValue(playerid, rewardCount);
            new msg[96];
            format(msg, sizeof(msg), "Вы получили пыль: %d", rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        case REWARD_TYPE_EVENT_RES:
        {
            // Отдельной валюты события в моде нет, поэтому сохраняем ценность награды пылью.
            AddPlayerDustValue(playerid, rewardCount);
            new msg[96];
            format(msg, sizeof(msg), "Вы получили ивент ресурс: %d", rewardCount);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        default:
        {
            return 0;
        }
    }
    SavePlayerAccount(playerid);
    return 1;
}

forward Cases_OnRewardTaken(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus);
public Cases_OnRewardTaken(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus)
{
    return Reward_GiveToPlayer(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus);
}

stock Rewards_LoadPageMode(playerid, offset, mode)
{
    SetPVarInt(playerid, "reward_offset", offset);
    SetPVarInt(playerid, "reward_view_mode", mode);

    new query[320];
    switch(mode)
    {
        case 1: // BP rewards only
        {
            mysql_format(mysql, query, sizeof(query),
                "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d AND `case_id` IN (%d,%d) LIMIT %d, 19",
                GetPlayerAccountID(playerid), BP_REWARD_CASE_STANDARD, BP_REWARD_CASE_PREMIUM, offset);
        }
        case 2: // full reward list, including BP and cases
        {
            mysql_format(mysql, query, sizeof(query),
                "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT %d, 19",
                GetPlayerAccountID(playerid), offset);
        }
        default: // normal /reward: only case/donate rewards, without BP
        {
            mysql_format(mysql, query, sizeof(query),
                "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d AND `case_id` NOT IN (%d,%d) LIMIT %d, 19",
                GetPlayerAccountID(playerid), BP_REWARD_CASE_STANDARD, BP_REWARD_CASE_PREMIUM, offset);
        }
    }
    mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
    return 1;
}

stock Rewards_LoadPage(playerid, offset)
{
    if(GetPVarInt(playerid, "reward_view_bp") == 1) return Rewards_LoadPageMode(playerid, offset, 1);
    if(GetPVarInt(playerid, "reward_view_full") == 1) return Rewards_LoadPageMode(playerid, offset, 2);
    return Rewards_LoadPageMode(playerid, offset, 0);
}

CMD:reward(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 1;
    DeletePVar(playerid, "reward_view_bp");
    DeletePVar(playerid, "reward_view_full");
    return Rewards_LoadPageMode(playerid, 0, 0);
}

CMD:rewardfull(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid)) return 1;
    DeletePVar(playerid, "reward_view_bp");
    SetPVarInt(playerid, "reward_view_full", 1);
    return Rewards_LoadPageMode(playerid, 0, 2);
}

CMD:rewardall(playerid, params[])
{
    #pragma unused params
    return callcmd::rewardfull(playerid, "");
}

CMD:rf(playerid, params[])
{
    #pragma unused params
    return callcmd::rewardfull(playerid, "");
}

forward OnPlayerRewardsLoad(playerid);
public OnPlayerRewardsLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    if(rows == 0)
    {
        if(GetPVarInt(playerid, "reward_offset") == 0)
            ShowNotificationKirill(playerid, 2, 4, 1, 1, "У вас нет доступных наград", "");

        new Node:emptyObj = JSON_Object();
        JSON_SetInt(emptyObj, "o", 1);
        JSON_SetInt(emptyObj, "pc", GetPlayerDustValue(playerid));
        JSON_SetInt(emptyObj, "next_page", 0);
        JSON_SetArray(emptyObj, "pr", JSON_Array());
        SendPacketToClient(playerid, GUIReward, emptyObj);
        JSON_Cleanup(emptyObj);
        return 1;
    }

    new Node:response = JSON_Object();
    JSON_SetInt(response, "o", 1);
    JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
    JSON_SetInt(response, "next_page", (rows > 18) ? 1 : 0);

    new Node:prArray = JSON_Array();
    new displayRows = (rows > 18) ? 18 : rows;

    for(new j = 0; j < displayRows; j++)
    {
        new awardId = cache_get_field_content_int(j, "award_id", mysql);
        new dbId = cache_get_field_content_int(j, "id", mysql);
        new caseId = cache_get_field_content_int(j, "case_id", mysql);
        new rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice, name[32];

        if(Reward_FindAwardData(caseId, awardId, rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice, name, sizeof(name)))
        {
            new Node:item = JSON_Object();
            JSON_SetInt(item, "el", Reward_GetElementId(rewardType, rewardValue, rewardCount));
            JSON_SetInt(item, "id", dbId);
            JSON_SetString(item, "n", name);
            JSON_SetInt(item, "st", 1);
            JSON_SetInt(item, "td", rewardType);
            JSON_SetInt(item, "sp", sprayPrice);

            new Node:tempArray = JSON_Array(item);
            prArray = JSON_Append(prArray, tempArray);
        }
    }

    JSON_SetArray(response, "pr", prArray);
    SendPacketToClient(playerid, GUIReward, response);
    JSON_Cleanup(response);
    return 1;
}

forward OnRewardDebug(playerid, dbId, rewardAction);
public OnRewardDebug(playerid, dbId, rewardAction)
{
    new rows = cache_num_rows();
    if(rows <= 0) return 1;

    new awardId = cache_get_field_content_int(0, "award_id", mysql);
    new caseId = cache_get_field_content_int(0, "case_id", mysql);
    new rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice, name[32];

    if(!Reward_FindAwardData(caseId, awardId, rewardType, rewardValue, rewardCount, rewardRarity, sprayPrice, name, sizeof(name)))
        return 1;

    new bool:deleteReward = true;
    if(rewardAction == 3)
    {
        if(sprayPrice > 0)
        {
            AddPlayerDustValue(playerid, sprayPrice);
            new msg[96];
            format(msg, sizeof(msg), "Вы распылили награду и получили %d пыли", sprayPrice);
            ShowNotificationKirill(playerid, 1, 5, 1, 0, msg, "");
        }
        else
        {
            ShowNotificationKirill(playerid, 2, 4, 1, 1, "Эту награду нельзя распылить", "");
            deleteReward = false;
        }
    }
    else
    {
        if(!Reward_GiveToPlayer(playerid, rewardType, rewardValue, rewardCount, rewardRarity, 0))
            deleteReward = false;
    }

    if(deleteReward)
    {
        new query[96];
        mysql_format(mysql, query, sizeof(query), "DELETE FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1", dbId, GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query, "", "");

        new Node:res = JSON_Object();
        JSON_SetInt(res, "t", 4);
        JSON_SetInt(res, "s", 1);
        JSON_SetInt(res, "id", dbId);
        JSON_SetInt(res, "pc", GetPlayerDustValue(playerid));
        SendPacketToClient(playerid, GUIReward, res);
        JSON_Cleanup(res);

        // После забора награды перезагружаем текущую страницу, чтобы GUI не закрывался и не оставался пустым.
        SetTimerEx("RewardReloadPageTimer", 650, false, "i", playerid);
    }
    return 1;
}


forward RewardReloadPageTimer(playerid);
public RewardReloadPageTimer(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    return Rewards_LoadPageMode(playerid, GetPVarInt(playerid, "reward_offset"), GetPVarInt(playerid, "reward_view_mode"));
}

stock Rewards_OnPacket(playerid, Node:json)
{
    new type;
    JSON_GetInt(json, "t", type);

    switch(type)
    {
        case 1:
        {
            Rewards_LoadPageMode(playerid, 0, GetPVarInt(playerid, "reward_view_mode"));
        }
        case 2:
        {
            new offset = GetPVarInt(playerid, "reward_offset") + 18;
            Rewards_LoadPageMode(playerid, offset, GetPVarInt(playerid, "reward_view_mode"));
        }
        case 3:
        {
            callcmd::cases(playerid, "");
        }
        case 4:
        {
            new rewardDbId, rewardAction;
            JSON_GetInt(json, "id", rewardDbId);
            JSON_GetInt(json, "s", rewardAction);
            if(rewardAction != 1 && rewardAction != 3) rewardAction = 1;

            new query[160];
            mysql_format(mysql, query, sizeof(query),
                "SELECT `award_id`, `case_id` FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1",
                rewardDbId, GetPlayerAccountID(playerid));
            mysql_tquery(mysql, query, "OnRewardDebug", "iii", playerid, rewardDbId, rewardAction);
        }
    }
    return 1;
}
