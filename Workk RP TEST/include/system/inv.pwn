// ================================================
// СИСТЕМА ИНВЕНТАРЯ
// ================================================

// ---- ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ----
//new Text:InventoryTD[23];
new PlayerText:InvSlotTD[MAX_PLAYERS][5];

// ---- СТОКИ ДЛЯ РАБОТЫ С ИНВЕНТАРЕМ ----

stock ShowInv(playerid)
{
    CloseInv(playerid);
    
    // Скрываем чат
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
    
    // Показываем фон
    TextDrawShowForPlayer(playerid, InventoryTD[0]);
    TextDrawShowForPlayer(playerid, InventoryTD[1]);
    TextDrawShowForPlayer(playerid, InventoryTD[2]); // Кнопка выйти
    TextDrawShowForPlayer(playerid, InventoryTD[3]);
    TextDrawShowForPlayer(playerid, InventoryTD[4]);
    TextDrawShowForPlayer(playerid, InventoryTD[5]);
    TextDrawShowForPlayer(playerid, InventoryTD[6]);
    
    new fmt_player[24], fmt_money[20], fmt_donate[20];
    format(fmt_player, sizeof(fmt_player), "%s", GetPlayerNameEx(playerid));
    TextDrawSetString(InventoryTD[3], fmt_player);
    
    format(fmt_money, sizeof(fmt_money), "%d", GetPlayerMoneyEx(playerid));
    TextDrawSetString(InventoryTD[4], fmt_money);
    
    format(fmt_donate, sizeof(fmt_donate), "%d", GetPlayerDonateRub(playerid));
    TextDrawSetString(InventoryTD[5], fmt_donate);
    
    TextDrawSetPreviewModel(InventoryTD[6], GetPlayerData(playerid, P_SKIN));
    
    for(new i = 0; i < 5; i++)
    {
        InvSlotShow(playerid, i);
    }
    
    SelectTextDraw(playerid, 0xFFFFFFFF);
    return 1;
}

stock CloseInv(playerid)
{
    // Показываем чат обратно
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
    
    for(new i = 0; i < 23; i++)
    {
        TextDrawHideForPlayer(playerid, InventoryTD[i]);
    }
    
    for(new i = 0; i < 5; i++)
    {
        PlayerTextDrawHide(playerid, InvSlotTD[playerid][i]);
    }
    
    CancelSelectTextDraw(playerid);
    return 1;
}

stock InvSlotShow(playerid, slot)
{
    new count;
    new str[10];
    
    switch(slot)
    {
        case 0:
        {
            count = GetPlayerData(playerid, P_MED_CHEST);
            if(count > 0)
            {
                TextDrawShowForPlayer(playerid, InventoryTD[7]);
                TextDrawShowForPlayer(playerid, InventoryTD[12]);
                format(str, sizeof(str), "%d", count);
                PlayerTextDrawSetString(playerid, InvSlotTD[playerid][0], str);
                PlayerTextDrawShow(playerid, InvSlotTD[playerid][0]);
            }
        }
        case 1:
        {
            count = GetPlayerData(playerid, P_MASK);
            if(count > 0)
            {
                TextDrawShowForPlayer(playerid, InventoryTD[8]);
                TextDrawShowForPlayer(playerid, InventoryTD[13]);
                format(str, sizeof(str), "%d", count);
                PlayerTextDrawSetString(playerid, InvSlotTD[playerid][1], str);
                PlayerTextDrawShow(playerid, InvSlotTD[playerid][1]);
            }
        }
        case 2:
        {
            count = GetPlayerData(playerid, P_PHONE);
            if(count > 0)
            {
                TextDrawShowForPlayer(playerid, InventoryTD[9]);
                TextDrawShowForPlayer(playerid, InventoryTD[14]);
                format(str, sizeof(str), "%d", count);
                PlayerTextDrawSetString(playerid, InvSlotTD[playerid][2], str);
                PlayerTextDrawShow(playerid, InvSlotTD[playerid][2]);
            }
        }
        case 3:
        {
            count = GetPlayerData(playerid, P_PLAY_PLAYER);
            if(count > 0)
            {
                TextDrawShowForPlayer(playerid, InventoryTD[10]);
                TextDrawShowForPlayer(playerid, InventoryTD[15]);
                format(str, sizeof(str), "%d", count);
                PlayerTextDrawSetString(playerid, InvSlotTD[playerid][3], str);
                PlayerTextDrawShow(playerid, InvSlotTD[playerid][3]);
            }
        }
        case 4:
        {
            count = GetPlayerData(playerid, P_REPCARID);
            if(count > 0)
            {
                TextDrawShowForPlayer(playerid, InventoryTD[11]);
                TextDrawShowForPlayer(playerid, InventoryTD[16]);
                format(str, sizeof(str), "%d", count);
                PlayerTextDrawSetString(playerid, InvSlotTD[playerid][4], str);
                PlayerTextDrawShow(playerid, InvSlotTD[playerid][4]);
            }
        }
    }
    return 1;
}

stock InvUseItem(playerid, slot)
{
    switch(slot)
    {
        case 0:
        {
            if(GetPlayerData(playerid, P_MED_CHEST) > 0)
            {
                SetPlayerData(playerid, P_MED_CHEST, GetPlayerData(playerid, P_MED_CHEST) - 1);
                UpdatePlayerDatabaseInt(playerid, "med_chest", GetPlayerData(playerid, P_MED_CHEST));
                
                new Float:health;
                GetPlayerHealth(playerid, health);
                health += 60.0;
                if(health > 100.0) health = 100.0;
                SetPlayerHealth(playerid, health);
                
                GameTextForPlayer(playerid, "~b~+60 HP", 3000, 3);
                ShowNotification(playerid, 3, "Bы использовали аптечку! +60 HP", 5, "", "");
                
                ApplyAnimation(playerid, "PED", "GUM_EAT", 4.1, 0, 0, 0, 0, 0, 1);
                
                ShowInv(playerid);
                return 1;
            }
            else
            {
                ShowNotification(playerid, 3, "Y вас нет аптечек!", 3, "", "");
                return 1;
            }
        }
        case 1:
        {
            if(GetPlayerData(playerid, P_MASK) > 0)
            {
                ShowNotification(playerid, 3, "Y вас есть маска. Используйте /mask", 3, "", "");
                ShowInv(playerid);
                return 1;
            }
        }
        case 2:
        {
            if(GetPlayerData(playerid, P_PHONE) > 0)
            {
                ShowNotification(playerid, 3, "Y вас есть сим-карта. Используйте /phone", 3, "", "");
                ShowInv(playerid);
                return 1;
            }
        }
        case 3:
        {
            if(GetPlayerData(playerid, P_PLAY_PLAYER) > 0)
            {
                if(GetPlayerData(playerid, P_PLAY_PLAYER) == 1)
                {
                    SetPlayerData(playerid, P_PLAY_PLAYER, 2);
                    ShowNotification(playerid, 3, "Bы включили наушники", 3, "", "");
                }
                else
                {
                    SetPlayerData(playerid, P_PLAY_PLAYER, 1);
                    ShowNotification(playerid, 3, "Bы выключили наушники", 3, "", "");
                }
                ShowInv(playerid);
                return 1;
            }
        }
        case 4:
        {
            if(GetPlayerData(playerid, P_REPCARID) > 0)
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                if(!vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
                {
                    ShowNotification(playerid, 3, "Bы должны быть водителем!", 3, "", "");
                    return 0;
                }
                
                new Float:health;
                GetVehicleHealth(vehicleid, health);
                if(health > 990.0)
                {
                    ShowNotification(playerid, 3, "Tранспорт в отличном состоянии!", 3, "", "");
                    return 0;
                }
                
                SetPlayerData(playerid, P_REPCARID, GetPlayerData(playerid, P_REPCARID) - 1);
                UpdatePlayerDatabaseInt(playerid, "repcarid", GetPlayerData(playerid, P_REPCARID));
                
                SetVehicleHealth(vehicleid, 1000.0);
                ShowNotification(playerid, 3, "Bы отремонтировали транспорт!", 3, "", "");
                ShowInv(playerid);
                return 1;
            }
        }
    }
    return 1;
}

// ---- ЗАГРУЗКА ТЕКСТДРАВОВ ----
stock TextDrawInvLoad()
{
    // ФОН ИНВЕНТАРЯ
    InventoryTD[0] = TextDrawCreate(155.3999, 149.0266, "kuzia:inven");
    TextDrawTextSize(InventoryTD[0], 253.0000, 266.0000);
    TextDrawAlignment(InventoryTD[0], 1);
    TextDrawColor(InventoryTD[0], -1);
    TextDrawBackgroundColor(InventoryTD[0], 255);
    TextDrawFont(InventoryTD[0], 4);
    TextDrawSetProportional(InventoryTD[0], 0);
    TextDrawSetShadow(InventoryTD[0], 0);
    
    // ФОН ИГРОКА (СЕРЫЙ)
    InventoryTD[1] = TextDrawCreate(415.4000, 156.4933, "kuzia:player");
    TextDrawTextSize(InventoryTD[1], 181.0000, 255.0000);
    TextDrawAlignment(InventoryTD[1], 1);
    TextDrawColor(InventoryTD[1], 0x888888AA); // СЕРЫЙ ЦВЕТ
    TextDrawBackgroundColor(InventoryTD[1], 255);
    TextDrawFont(InventoryTD[1], 4);
    TextDrawSetProportional(InventoryTD[1], 0);
    TextDrawSetShadow(InventoryTD[1], 0);
    
    // КНОПКА ВЫЙТИ
    InventoryTD[2] = TextDrawCreate(459.3999, 389.4536, "kuzia:guiclose");
    TextDrawTextSize(InventoryTD[2], 42.0000, 19.0000);
    TextDrawAlignment(InventoryTD[2], 1);
    TextDrawColor(InventoryTD[2], -1);
    TextDrawBackgroundColor(InventoryTD[2], 255);
    TextDrawFont(InventoryTD[2], 4);
    TextDrawSetProportional(InventoryTD[2], 0);
    TextDrawSetShadow(InventoryTD[2], 0);
    TextDrawSetSelectable(InventoryTD[2], true);
    
    // ИМЯ ИГРОКА
    InventoryTD[3] = TextDrawCreate(417.9999, 110.1066, "Игрок");
    TextDrawLetterSize(InventoryTD[3], 0.4823, 1.8463);
    TextDrawTextSize(InventoryTD[3], -58.0000, 0.0000);
    TextDrawAlignment(InventoryTD[3], 1);
    TextDrawColor(InventoryTD[3], -1);
    TextDrawBackgroundColor(InventoryTD[3], 255);
    TextDrawFont(InventoryTD[3], 1);
    TextDrawSetProportional(InventoryTD[3], 1);
    TextDrawSetShadow(InventoryTD[3], -1);
    
    // ДЕНЬГИ
    InventoryTD[4] = TextDrawCreate(415.5999, 139.9732, "0");
    TextDrawLetterSize(InventoryTD[4], 0.2928, 1.1967);
    TextDrawTextSize(InventoryTD[4], -22.0000, 0.0000);
    TextDrawAlignment(InventoryTD[4], 1);
    TextDrawColor(InventoryTD[4], -1);
    TextDrawBackgroundColor(InventoryTD[4], 255);
    TextDrawFont(InventoryTD[4], 1);
    TextDrawSetProportional(InventoryTD[4], 1);
    TextDrawSetShadow(InventoryTD[4], 0);
    
    // ДОНАТ
    InventoryTD[5] = TextDrawCreate(488.3999, 139.9732, "0");
    TextDrawLetterSize(InventoryTD[5], 0.2928, 1.1967);
    TextDrawTextSize(InventoryTD[5], -22.0000, 0.0000);
    TextDrawAlignment(InventoryTD[5], 1);
    TextDrawColor(InventoryTD[5], -5963521);
    TextDrawBackgroundColor(InventoryTD[5], 255);
    TextDrawFont(InventoryTD[5], 1);
    TextDrawSetProportional(InventoryTD[5], 1);
    TextDrawSetShadow(InventoryTD[5], 0);
    
    // СКИН
    InventoryTD[6] = TextDrawCreate(432.9999, 171.4266, "");
    TextDrawTextSize(InventoryTD[6], 93.0000, 202.0000);
    TextDrawAlignment(InventoryTD[6], 1);
    TextDrawColor(InventoryTD[6], -1);
    TextDrawBackgroundColor(InventoryTD[6], 255);
    TextDrawFont(InventoryTD[6], 5);
    TextDrawSetProportional(InventoryTD[6], 0);
    TextDrawSetShadow(InventoryTD[6], 0);
    TextDrawSetSelectable(InventoryTD[6], true);
    TextDrawSetPreviewRot(InventoryTD[6], 0.0000, 0.0000, 0.0000, 1.0000);
    
    // АПТЕЧКА
    InventoryTD[7] = TextDrawCreate(156.2000, 154.2532, "kuzia:apt");
    TextDrawTextSize(InventoryTD[7], 88.0000, 74.0000);
    TextDrawAlignment(InventoryTD[7], 1);
    TextDrawColor(InventoryTD[7], -1);
    TextDrawBackgroundColor(InventoryTD[7], 255);
    TextDrawFont(InventoryTD[7], 4);
    TextDrawSetProportional(InventoryTD[7], 0);
    TextDrawSetShadow(InventoryTD[7], 0);
    TextDrawSetSelectable(InventoryTD[7], true);
    
    // МАСКА
    InventoryTD[8] = TextDrawCreate(237.0000, 155.0000, "kuzia:maska");
    TextDrawTextSize(InventoryTD[8], 88.0000, 74.0000);
    TextDrawAlignment(InventoryTD[8], 1);
    TextDrawColor(InventoryTD[8], -1);
    TextDrawBackgroundColor(InventoryTD[8], 255);
    TextDrawFont(InventoryTD[8], 4);
    TextDrawSetProportional(InventoryTD[8], 0);
    TextDrawSetShadow(InventoryTD[8], 0);
    TextDrawSetSelectable(InventoryTD[8], true);
    
    // СИМ-КАРТА
    InventoryTD[9] = TextDrawCreate(316.2000, 154.9999, "kuzia:simcard");
    TextDrawTextSize(InventoryTD[9], 88.0000, 74.0000);
    TextDrawAlignment(InventoryTD[9], 1);
    TextDrawColor(InventoryTD[9], -1);
    TextDrawBackgroundColor(InventoryTD[9], 255);
    TextDrawFont(InventoryTD[9], 4);
    TextDrawSetProportional(InventoryTD[9], 0);
    TextDrawSetShadow(InventoryTD[9], 0);
    TextDrawSetSelectable(InventoryTD[9], true);
    
    // НАУШНИКИ
    InventoryTD[10] = TextDrawCreate(156.2000, 215.4799, "kuzia:naush");
    TextDrawTextSize(InventoryTD[10], 88.0000, 74.0000);
    TextDrawAlignment(InventoryTD[10], 1);
    TextDrawColor(InventoryTD[10], -1);
    TextDrawBackgroundColor(InventoryTD[10], 255);
    TextDrawFont(InventoryTD[10], 4);
    TextDrawSetProportional(InventoryTD[10], 0);
    TextDrawSetShadow(InventoryTD[10], 0);
    TextDrawSetSelectable(InventoryTD[10], true);
    
    // РЕМКОМПЛЕКТ
    InventoryTD[11] = TextDrawCreate(236.2000, 215.4799, "kuzia:repair");
    TextDrawTextSize(InventoryTD[11], 88.0000, 74.0000);
    TextDrawAlignment(InventoryTD[11], 1);
    TextDrawColor(InventoryTD[11], -1);
    TextDrawBackgroundColor(InventoryTD[11], 255);
    TextDrawFont(InventoryTD[11], 4);
    TextDrawSetProportional(InventoryTD[11], 0);
    TextDrawSetShadow(InventoryTD[11], 0);
    TextDrawSetSelectable(InventoryTD[11], true);
    
    // КНОПКИ "ИСПОЛЬЗОВАТЬ"
    InventoryTD[12] = TextDrawCreate(193.0000, 199.0000, "Использовать");
    TextDrawLetterSize(InventoryTD[12], 0.25, 1.0);
    TextDrawAlignment(InventoryTD[12], 1);
    TextDrawColor(InventoryTD[12], 0x00FF00FF);
    TextDrawBackgroundColor(InventoryTD[12], 255);
    TextDrawFont(InventoryTD[12], 1);
    TextDrawSetProportional(InventoryTD[12], 1);
    TextDrawSetShadow(InventoryTD[12], 0);
    TextDrawSetSelectable(InventoryTD[12], true);
    
    InventoryTD[13] = TextDrawCreate(275.0000, 199.0000, "Использовать");
    TextDrawLetterSize(InventoryTD[13], 0.25, 1.0);
    TextDrawAlignment(InventoryTD[13], 1);
    TextDrawColor(InventoryTD[13], 0x00FF00FF);
    TextDrawBackgroundColor(InventoryTD[13], 255);
    TextDrawFont(InventoryTD[13], 1);
    TextDrawSetProportional(InventoryTD[13], 1);
    TextDrawSetShadow(InventoryTD[13], 0);
    TextDrawSetSelectable(InventoryTD[13], true);
    
    InventoryTD[14] = TextDrawCreate(353.0000, 199.0000, "Использовать");
    TextDrawLetterSize(InventoryTD[14], 0.25, 1.0);
    TextDrawAlignment(InventoryTD[14], 1);
    TextDrawColor(InventoryTD[14], 0x00FF00FF);
    TextDrawBackgroundColor(InventoryTD[14], 255);
    TextDrawFont(InventoryTD[14], 1);
    TextDrawSetProportional(InventoryTD[14], 1);
    TextDrawSetShadow(InventoryTD[14], 0);
    TextDrawSetSelectable(InventoryTD[14], true);
    
    InventoryTD[15] = TextDrawCreate(193.0000, 260.0000, "Использовать");
    TextDrawLetterSize(InventoryTD[15], 0.25, 1.0);
    TextDrawAlignment(InventoryTD[15], 1);
    TextDrawColor(InventoryTD[15], 0x00FF00FF);
    TextDrawBackgroundColor(InventoryTD[15], 255);
    TextDrawFont(InventoryTD[15], 1);
    TextDrawSetProportional(InventoryTD[15], 1);
    TextDrawSetShadow(InventoryTD[15], 0);
    TextDrawSetSelectable(InventoryTD[15], true);
    
    InventoryTD[16] = TextDrawCreate(275.0000, 260.0000, "Использовать");
    TextDrawLetterSize(InventoryTD[16], 0.25, 1.0);
    TextDrawAlignment(InventoryTD[16], 1);
    TextDrawColor(InventoryTD[16], 0x00FF00FF);
    TextDrawBackgroundColor(InventoryTD[16], 255);
    TextDrawFont(InventoryTD[16], 1);
    TextDrawSetProportional(InventoryTD[16], 1);
    TextDrawSetShadow(InventoryTD[16], 0);
    TextDrawSetSelectable(InventoryTD[16], true);
    
    // КНОПКА ЗАКРЫТЬ (КРАСНАЯ)
    InventoryTD[17] = TextDrawCreate(530.0000, 389.0000, "Закрыть");
    TextDrawLetterSize(InventoryTD[17], 0.3, 1.2);
    TextDrawAlignment(InventoryTD[17], 1);
    TextDrawColor(InventoryTD[17], 0xFF0000FF);
    TextDrawBackgroundColor(InventoryTD[17], 255);
    TextDrawFont(InventoryTD[17], 1);
    TextDrawSetProportional(InventoryTD[17], 1);
    TextDrawSetShadow(InventoryTD[17], 0);
    TextDrawSetSelectable(InventoryTD[17], true);
    
    // PlayerTextDraw
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        for(new s = 0; s < 5; s++)
        {
            new Float:xpos = 218.0000;
            if(s == 0) xpos = 218.0000;
            else if(s == 1) xpos = 297.0000;
            else if(s == 2) xpos = 375.0000;
            else if(s == 3) xpos = 218.0000;
            else if(s == 4) xpos = 297.0000;
            
            InvSlotTD[i][s] = CreatePlayerTextDraw(i, xpos, 202.0000, "0");
            PlayerTextDrawLetterSize(i, InvSlotTD[i][s], 0.2887, 1.1519);
            PlayerTextDrawAlignment(i, InvSlotTD[i][s], 1);
            PlayerTextDrawColor(i, InvSlotTD[i][s], -1);
            PlayerTextDrawBackgroundColor(i, InvSlotTD[i][s], 255);
            PlayerTextDrawFont(i, InvSlotTD[i][s], 1);
            PlayerTextDrawSetProportional(i, InvSlotTD[i][s], 1);
            PlayerTextDrawSetShadow(i, InvSlotTD[i][s], 0);
        }
    }
    
    return 1;
}

// ---- КОМАНДА ----
CMD:inv1(playerid)
{
    ShowInv(playerid);
    return 1;
}