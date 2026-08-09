#if defined _accessory_editor_td_included
    #endinput
#endif
#define _accessory_editor_td_included

// TextDraw редактор аксессуаров вынесен из gamemodes/race.pwn в include.
// Используется при нажатии "одеть" в инвентаре и при редактировании уже надетого аксессуара.


stock Accessory_CreateDatabaseTable()
{
    new query[1024];

    strcat(query, "CREATE TABLE IF NOT EXISTS `accessories` (");
    strcat(query, "`id` int(11) NOT NULL,");
    strcat(query, "`slot` int(11) NOT NULL,");
    strcat(query, "`modelid` int(11) NOT NULL DEFAULT '0',");
    strcat(query, "`bone` int(11) NOT NULL DEFAULT '2',");
    strcat(query, "`x` float NOT NULL DEFAULT '0',");
    strcat(query, "`y` float NOT NULL DEFAULT '0',");
    strcat(query, "`z` float NOT NULL DEFAULT '0',");
    strcat(query, "`rX` float NOT NULL DEFAULT '0',");
    strcat(query, "`rY` float NOT NULL DEFAULT '0',");
    strcat(query, "`rZ` float NOT NULL DEFAULT '0',");
    strcat(query, "`scale` float NOT NULL DEFAULT '1',");
    strcat(query, "PRIMARY KEY (`id`, `slot`)");
    strcat(query, ") ENGINE=InnoDB DEFAULT CHARSET=cp1251;");

    mysql_tquery(mysql, query);
    return 1;
}

stock CreateAcsTextDraw(playerid)
{
    Accessory_CreateEditorTextDraws();
    CancelSelectTextDraw(playerid);

    for(new i = 0; i < 11; i++)
    {
        if(acss_fix_TD[i] != Text:INVALID_TEXT_DRAW)
            TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
    }

    if(acss_fix_TD[17] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[17]);

    if(acss_fix_TD[24] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[24]);

    if(acss_fix_TD[25] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[25]);

    new acs_coords[32];
    format(acs_coords, sizeof(acs_coords), "X: 0.00");

    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, acss_coords_fix_PTD[playerid][0]);
    }

    acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);

    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
        PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
        PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
        PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
        PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
        PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);
        PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);
    }

	SelectTextDraw(playerid, 0xFFFFFFFF);
	SelectTextDraw(playerid, 0xFFFFFFFF);
	SelectTextDraw(playerid, 0xFFFFFFFF);
	SetPVarInt(playerid, "acss_fix_TD_use", 1);
}



stock Accessory_ShowEquipMenu(playerid)
{
    return ShowPlayerDialog(playerid, DIALOG_ACS_EQUIP_MENU, DIALOG_STYLE_LIST,
        "RACE RUSSIA | Управление аксессуаром",
        "1. Отредактировать аксессуар\n2. Изменить часть тела\n3. Продолжить без изменений",
        "Выбрать", "Закрыть");
}

stock Accessory_ShowBoneMenu(playerid)
{
    return ShowPlayerDialog(playerid, DIALOG_ACS_SELECT_BONE, DIALOG_STYLE_LIST,
        "RACE RUSSIA | Выбор части тела",
        "Голова\nШея\nПозвоночник\nЛевое плечо\nПравое плечо\nЛевая рука\nПравая рука\nЛевая кисть\nПравая кисть\nЛевое бедро\nПравое бедро\nЛевая голень\nПравая голень\nЛевая стопа\nПравая стопа\nЧелюсть",
        "Выбрать", "Назад");
}

stock Accessory_GetBoneByListItem(listitem)
{
    switch(listitem)
    {
        case 0: return 2;   // head
        case 1: return 17;  // neck
        case 2: return 1;   // spine
        case 3: return 15;  // left shoulder/clavicle
        case 4: return 16;  // right shoulder/clavicle
        case 5: return 13;  // left forearm
        case 6: return 14;  // right forearm
        case 7: return 5;   // left hand
        case 8: return 6;   // right hand
        case 9: return 7;   // left thigh
        case 10: return 8;  // right thigh
        case 11: return 12; // left calf
        case 12: return 11; // right calf
        case 13: return 9;  // left foot
        case 14: return 10; // right foot
        case 15: return 18; // jaw
    }
    return 2;
}

stock Accessory_ApplyPreview(playerid)
{
    new slot = GetPVarInt(playerid, "slot");
    new modelid = GetPVarInt(playerid, "modelid");
    new bone = GetPVarInt(playerid, "bone");
    new Float:scale = GetPVarFloat(playerid, "num_7");

    if(slot < 0 || modelid <= 0 || bone <= 0) return 0;

    RemovePlayerAttachedObject(playerid, slot);
    SetPlayerAttachedObject(
        playerid,
        slot,
        modelid,
        bone,
        GetPVarFloat(playerid, "num_1"),
        GetPVarFloat(playerid, "num_2"),
        GetPVarFloat(playerid, "num_3"),
        GetPVarFloat(playerid, "num_4"),
        GetPVarFloat(playerid, "num_5"),
        GetPVarFloat(playerid, "num_6"),
        scale, scale, scale,
        0
    );
    return 1;
}

stock Accessory_ClearTempEquipData(playerid, bool:remove_object = false)
{
    new slot = GetPVarInt(playerid, "slot");

    if(remove_object && slot >= 0)
    {
        RemovePlayerAttachedObject(playerid, slot);
    }

    DeletePVar(playerid, "acs_use");
    DeletePVar(playerid, "acss_fix_TD_use");
    DeletePVar(playerid, "inv_slot");
    DeletePVar(playerid, "item_id");
    DeletePVar(playerid, "model_id");
    DeletePVar(playerid, "target_slot");
    DeletePVar(playerid, "target_bone");
    DeletePVar(playerid, "slot");
    DeletePVar(playerid, "modelid");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "num_1");
    DeletePVar(playerid, "num_2");
    DeletePVar(playerid, "num_3");
    DeletePVar(playerid, "num_4");
    DeletePVar(playerid, "num_5");
    DeletePVar(playerid, "num_6");
    DeletePVar(playerid, "num_7");
    DeletePVar(playerid, "updateacs");

    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
    }

    CancelSelectTextDraw(playerid);
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
    return 1;
}

stock Accessory_SaveInventoryPrepared(playerid)
{
    new query[512], Cache:result;

    new inv_slot = GetPVarInt(playerid, "inv_slot");
    new item_id = GetPVarInt(playerid, "item_id");
    new target_slot = GetPVarInt(playerid, "target_slot");
    new target_bone = GetPVarInt(playerid, "target_bone");

    if(inv_slot == -1 || item_id <= 0 || target_slot == -1 || target_bone <= 0)
        return 0;

    new count = g_PlayerInventory[playerid][inv_slot][inv_itemCount];
    new plate[32];
    strcpy(plate, g_PlayerInventory[playerid][inv_slot][inv_itemPlate], 32);

    new itemWeight = GetItemWeight(item_id);
    SetPlayerWeight(playerid, GetPlayerWeight(playerid) - itemWeight);

    g_PlayerInventory[playerid][inv_slot][inv_itemId] = 0;
    g_PlayerInventory[playerid][inv_slot][inv_itemCount] = 0;
    g_PlayerInventory[playerid][inv_slot][inv_itemPlate][0] = 0;

    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
        GetPlayerAccountID(playerid), inv_slot);
    mysql_tquery(mysql, query);

    g_PlayerActiveSlots[playerid][target_slot][inv_itemId] = item_id;
    g_PlayerActiveSlots[playerid][target_slot][inv_itemCount] = target_bone;
    g_PlayerActiveSlots[playerid][target_slot][inv_itemSlot] = target_slot;
    strcpy(g_PlayerActiveSlots[playerid][target_slot][inv_itemPlate], plate, 32);
    g_PlayerActiveSlots[playerid][target_slot][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][target_slot][inv_activeSlot] = target_slot;
    g_PlayerActiveSlots[playerid][target_slot][inv_itemType] = 6;
    g_PlayerActiveSlots[playerid][target_slot][inv_itemWeight] = itemWeight;
    GetItemName(item_id, g_PlayerActiveSlots[playerid][target_slot][inv_itemName], 64);

    SaveActiveSlotItem(playerid, target_slot);

    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `accessories` (`id`, `slot`, `modelid`, `bone`, `x`, `y`, `z`, `rX`, `rY`, `rZ`, `scale`) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f) ON DUPLICATE KEY UPDATE `modelid`=VALUES(`modelid`), `bone`=VALUES(`bone`), `x`=VALUES(`x`), `y`=VALUES(`y`), `z`=VALUES(`z`), `rX`=VALUES(`rX`), `rY`=VALUES(`rY`), `rZ`=VALUES(`rZ`), `scale`=VALUES(`scale`)",
        GetPlayerAccountID(playerid),
        GetPVarInt(playerid, "slot"),
        GetPVarInt(playerid, "modelid"),
        GetPVarInt(playerid, "bone"),
        GetPVarFloat(playerid, "num_1"),
        GetPVarFloat(playerid, "num_2"),
        GetPVarFloat(playerid, "num_3"),
        GetPVarFloat(playerid, "num_4"),
        GetPVarFloat(playerid, "num_5"),
        GetPVarFloat(playerid, "num_6"),
        GetPVarFloat(playerid, "num_7")
    );

    result = mysql_query(mysql, query, true);
    cache_delete(result);

    new itemName[64];
    GetItemName(item_id, itemName);
    ShowNotificationSile(playerid, 3, 5, -1, -1, "Аксессуар надет", itemName);

    Accessory_ClearTempEquipData(playerid, false);
    return 1;
}
