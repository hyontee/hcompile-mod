// Глобальные текстдравы для магазина
new Text:acsmagaz_button_TD[5];
new PlayerText:acsmagaz_price_PTD[MAX_PLAYERS][1];
new player_select_accessory[MAX_PLAYERS];

new pl_accessory[MAX_PLAYERS];
new pl_id_accessory[MAX_PLAYERS];

new bool:create_player_btn[MAX_PLAYERS];

stock ConvertMoneyACS(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}

stock CreatePlTDButtonBR(playerid)
{
    acsmagaz_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 319.7778, 373.6799, "100.000_p.");
    PlayerTextDrawLetterSize(playerid, acsmagaz_price_PTD[playerid][0], 0.2531, 1.3509);
    PlayerTextDrawTextSize(playerid, acsmagaz_price_PTD[playerid][0], 0.0000, -17.0000);
    PlayerTextDrawAlignment(playerid, acsmagaz_price_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, acsmagaz_price_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, acsmagaz_price_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, acsmagaz_price_PTD[playerid][0], 1);
    create_player_btn[playerid] = true;
    return 1;
}

stock CreateTextDrawButtonBR()
{
    acsmagaz_button_TD[0] = TextDrawCreate(69.0000, 202.0000, "txd:brrainleft");
    TextDrawTextSize(acsmagaz_button_TD[0], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[0], 1);
    TextDrawColor(acsmagaz_button_TD[0], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[0], 255);
    TextDrawFont(acsmagaz_button_TD[0], 4);
    TextDrawSetProportional(acsmagaz_button_TD[0], 0);
    TextDrawSetShadow(acsmagaz_button_TD[0], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[0], true);

    acsmagaz_button_TD[1] = TextDrawCreate(542.0000, 202.0000, "txd:brrainright");
    TextDrawTextSize(acsmagaz_button_TD[1], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[1], 1);
    TextDrawColor(acsmagaz_button_TD[1], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[1], 255);
    TextDrawFont(acsmagaz_button_TD[1], 4);
    TextDrawSetProportional(acsmagaz_button_TD[1], 0);
    TextDrawSetShadow(acsmagaz_button_TD[1], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[1], true);

    acsmagaz_button_TD[2] = TextDrawCreate(234.7776, 371.0354, "txd:brtuning4nstage2");
    TextDrawTextSize(acsmagaz_button_TD[2], 171.0000, 21.0000);
    TextDrawAlignment(acsmagaz_button_TD[2], 1);
    TextDrawColor(acsmagaz_button_TD[2], -12705281);
    TextDrawBackgroundColor(acsmagaz_button_TD[2], 255);
    TextDrawFont(acsmagaz_button_TD[2], 4);
    TextDrawSetProportional(acsmagaz_button_TD[2], 0);
    TextDrawSetShadow(acsmagaz_button_TD[2], 0);

    acsmagaz_button_TD[3] = TextDrawCreate(240.4443, 384.0000, "txd:braucubuy");
    TextDrawTextSize(acsmagaz_button_TD[3], 78.0000, 58.0000);
    TextDrawAlignment(acsmagaz_button_TD[3], 1);
    TextDrawColor(acsmagaz_button_TD[3], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[3], 255);
    TextDrawFont(acsmagaz_button_TD[3], 4);
    TextDrawSetProportional(acsmagaz_button_TD[3], 0);
    TextDrawSetShadow(acsmagaz_button_TD[3], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[3], true);

    acsmagaz_button_TD[4] = TextDrawCreate(320.2221, 382.5065, "txd:braucexit");
    TextDrawTextSize(acsmagaz_button_TD[4], 83.0000, 60.0000);
    TextDrawAlignment(acsmagaz_button_TD[4], 1);
    TextDrawColor(acsmagaz_button_TD[4], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[4], 255);
    TextDrawFont(acsmagaz_button_TD[4], 4);
    TextDrawSetProportional(acsmagaz_button_TD[4], 0);
    TextDrawSetShadow(acsmagaz_button_TD[4], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[4], true);

    return 1;
}

stock EntryAccessoryMarket(playerid)
{
    pl_accessory[playerid] = 0;
    SetPlayerPosEx(playerid, 2896.610839,1496.067871,2499.343750,355.015014, 1, playerid+1);
    HideHud(playerid);
    TogglePlayerControllable(playerid, false);

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");
    SetPlayerCleanChat(playerid, true);

    InterpolateCameraPos(playerid, 2901.951660,1498.124877,2499.343750, 2900.450927,1500.220703,2499.363750, 2000, CAMERA_MOVE);
    InterpolateCameraLookAt(playerid, 2903.739257,1499.161499,2499.343750, 2899.104980,1503.386230,2499.562500, 2000, CAMERA_MOVE);

    pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[0][ID_ACCESSORY], 2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);
        
    CreatePlTDButtonBR(playerid);

    SetPriceAccesory(playerid, 0);
	TogglePlayerControllable(playerid, 0);

    SelectTextDraw(playerid, 0xFF5252FF);
    for(new i;i < sizeof acsmagaz_button_TD;i++) TextDrawShowForPlayer(playerid, acsmagaz_button_TD[i]);
    PlayerTextDrawShow(playerid, acsmagaz_price_PTD[playerid][0]);

    new Float:x, Float:y, Float:z, string[124];
    GetPlayerCameraPos(playerid, x, y, z);
    return 1;
}

stock SetPriceAccesory(playerid, acs)
{
    new string[24], moneyStringAcs[15];

    ConvertMoney(accessory[acs][PRICE_ACCESSORY], moneyStringAcs);
    format(string, sizeof string, "%s_p.", moneyStringAcs);
    PlayerTextDrawSetString(playerid, acsmagaz_price_PTD[playerid][0], string);

    return 1;
}
stock bool:Accessory_BusinessTextDraw(playerid, Text:clickedid)
{
if(clickedid == acsmagaz_button_TD[1])
    {
        new acs = pl_accessory[playerid];
        if(acs < sizeof accessory-1)
        {
            DestroyPlayerObject(playerid, pl_id_accessory[playerid]);

            pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs+1][ID_ACCESSORY], 
            2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);

            pl_accessory[playerid] = acs+1;
            SetPriceAccesory(playerid, acs+1);
        }
    }
    if(clickedid == acsmagaz_button_TD[0])
    {
        new acs = pl_accessory[playerid];
        if(acs > 0)
        {
            DestroyPlayerObject(playerid, pl_id_accessory[playerid]);

            pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs-1][ID_ACCESSORY], 
            2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);

            pl_accessory[playerid] = acs-1;

            SetPriceAccesory(playerid, acs-1);
        }
    }
    if(clickedid == acsmagaz_button_TD[4])
    {
        DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = -1;

        pl_accessory[playerid] = -1;

        for(new i;i < sizeof acsmagaz_button_TD;i++) TextDrawHideForPlayer(playerid, acsmagaz_button_TD[i]);
        PlayerTextDrawHide(playerid, acsmagaz_price_PTD[playerid][0]);

        new in_biz = GetPlayerInBiz(playerid);
        SetPlayerPosEx
        (
            playerid,
            GetBusinessData(in_biz, B_EXIT_POS_X),
            GetBusinessData(in_biz, B_EXIT_POS_Y),
            GetBusinessData(in_biz, B_EXIT_POS_Z),
            GetBusinessData(in_biz, B_EXIT_ANGLE),
            0,
            0
        );
        SetPlayerInBiz(playerid, -1);
        CancelSelectTextDraw(playerid);
        TogglePlayerControllable(playerid, 1);
        ShowHud(playerid);

        SetPlayerCleanChat(playerid, false);
    }

if(clickedid == acsmagaz_button_TD[3])
{
    new acs = pl_accessory[playerid], price = accessory[acs][PRICE_ACCESSORY], query[128], biz_price = price * 20 / 100;
    
    if(GetPlayerMoneyEx(playerid) >= price)
    {
        new businessid = GetPlayerInBiz(playerid), take_prods = random(4) + 6;
        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
        {
            format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", 
                GetBusinessData(businessid, B_PRODS)-take_prods, 
                GetBusinessData(businessid, B_BALANCE)+biz_price, 
                GetBusinessData(businessid, B_SQL_ID));
            mysql_query(mysql, query, false);
        }

        if(!mysql_errno())
        {
            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
            {
                AddBusinessData(businessid, B_PRODS, -, take_prods);
                AddBusinessData(businessid, B_BALANCE, +, biz_price);
            }

            mysql_format(mysql, query, sizeof query, 
                "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", 
                GetBusinessData(businessid, B_SQL_ID), 
                GetPlayerAccountID(playerid), 
                GetPlayerIpEx(playerid), 
                gettime(), 
                price, 
                IsBusinessOwned(businessid));
            mysql_query(mysql, query, false);
            
            GivePlayerMoneyEx(playerid, -price);
            
            new inventoryItemId = Accessory_GetInventoryItemId(acs);
            
            if(inventoryItemId > 0)
            {
                new freeSlot = Inventory_GetFreeSlot(playerid);
                if(freeSlot == -1)
                {
                    ShowClientNotification (playerid, 2, 7, -1, -1, "Нет свободных слотов в инвентаре!", "");
                    return 0;
                }

                Inventory_AddItem(playerid, inventoryItemId, freeSlot, 1, "");
                
                SendClientMessage(playerid, -1, "Вы купили аксессуар. Он был добавлен в инвентарь. Используйте /inv чтобы надеть.");
                
                ShowPlayerInventory(playerid);
            }
            else
            {
                printf("[ERROR] Не найден ID инвентаря для аксессуара %d (модель: %d)", acs, accessory[acs][ID_ACCESSORY]);
                SendClientMessage(playerid, -1, "Ошибка при добавлении аксессуара в инвентарь.");
            }
        }
    }
    else SendClientMessage(playerid, -1, "У вас недостаточно денег.");
}
}