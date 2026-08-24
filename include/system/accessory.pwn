


stock GetAccsIndexByModelId(modelid)
{
    for(new i = 0; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid)
        {
            return i;
        }
    }
    return -1;
}





// Глобальные текстдравы
new Text:acsmagaz_button_TD[5];

new Text: acss_fix_TD[26];
new PlayerText: acss_coords_fix_PTD[MAX_PLAYERS][1];

// Текстдравы для игроков
new PlayerText:acsmagaz_price_PTD[MAX_PLAYERS][1];
//new player_select_accessory[MAX_PLAYERS];

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
    acsmagaz_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 319.7778, 373.6799, "100.000_p."); // пусто
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
    acsmagaz_button_TD[0] = TextDrawCreate(69.0000, 202.0000, "txd:brrainleft"); // влево
    TextDrawTextSize(acsmagaz_button_TD[0], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[0], 1);
    TextDrawColor(acsmagaz_button_TD[0], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[0], 255);
    TextDrawFont(acsmagaz_button_TD[0], 4);
    TextDrawSetProportional(acsmagaz_button_TD[0], 0);
    TextDrawSetShadow(acsmagaz_button_TD[0], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[0], true);

    acsmagaz_button_TD[1] = TextDrawCreate(542.0000, 202.0000, "txd:brrainright"); // вправо
    TextDrawTextSize(acsmagaz_button_TD[1], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[1], 1);
    TextDrawColor(acsmagaz_button_TD[1], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[1], 255);
    TextDrawFont(acsmagaz_button_TD[1], 4);
    TextDrawSetProportional(acsmagaz_button_TD[1], 0);
    TextDrawSetShadow(acsmagaz_button_TD[1], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[1], true);

    acsmagaz_button_TD[2] = TextDrawCreate(234.7776, 371.0354, "txd:brtuning4nstage2"); // фон для текста
    TextDrawTextSize(acsmagaz_button_TD[2], 171.0000, 21.0000);
    TextDrawAlignment(acsmagaz_button_TD[2], 1);
    TextDrawColor(acsmagaz_button_TD[2], -12705281);
    TextDrawBackgroundColor(acsmagaz_button_TD[2], 255);
    TextDrawFont(acsmagaz_button_TD[2], 4);
    TextDrawSetProportional(acsmagaz_button_TD[2], 0);
    TextDrawSetShadow(acsmagaz_button_TD[2], 0);

    acsmagaz_button_TD[3] = TextDrawCreate(240.4443, 384.0000, "txd:braucubuy"); // купить
    TextDrawTextSize(acsmagaz_button_TD[3], 78.0000, 58.0000);
    TextDrawAlignment(acsmagaz_button_TD[3], 1);
    TextDrawColor(acsmagaz_button_TD[3], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[3], 255);
    TextDrawFont(acsmagaz_button_TD[3], 4);
    TextDrawSetProportional(acsmagaz_button_TD[3], 0);
    TextDrawSetShadow(acsmagaz_button_TD[3], 0);
    TextDrawSetSelectable(acsmagaz_button_TD[3], true);

    acsmagaz_button_TD[4] = TextDrawCreate(320.2221, 382.5065, "txd:braucexit"); // выход
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


public OnPlayerSpawn(playerid)
{
    LoadAccessory(playerid);
    #if defined name_OnPlayerSpawn
        return name_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn name_OnPlayerSpawn
#if defined name_OnPlayerSpawn
    forward name_OnPlayerSpawn(playerid);
#endif


public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == acsmagaz_button_TD[1]) //вперед
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
    if(clickedid == acsmagaz_button_TD[0]) //назад
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
    if(clickedid == acsmagaz_button_TD[4]) //выход
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

    }
    if(clickedid == acsmagaz_button_TD[3]) // купить
    {
        new acs = pl_accessory[playerid], price = accessory[acs][PRICE_ACCESSORY], query[128], biz_price = price * 20 / 100;
        if(GetPlayerMoneyEx(playerid) >= price)
        {
            new businessid = GetPlayerInBiz(playerid), take_prods = random(4) + 6;
            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
            {
                format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+biz_price, GetBusinessData(businessid, B_SQL_ID));
                mysql_query(mysql, query, false);
            }

            if(!mysql_errno())
            {
                if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                {
                    AddBusinessData(businessid, B_PRODS, -, take_prods);
                    AddBusinessData(businessid, B_BALANCE, +, biz_price);
                }

                mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
                mysql_query(mysql, query, false);
                GivePlayerMoneyEx(playerid, -price);
                
            ShowNotificationFan4iik(playerid, 3, 5, 0, 0, "Вы успешно купили аксессуар!", " ");
                GiveAccessoryToNewInventory(playerid, acs);
            }
        }
        else         ShowNotificationFan4iik(playerid, 2, 5, 0, 0, "У вас недостаточно денег!", " ");

    }
if(clickedid == acss_fix_TD[1])  // ?????
{
    for(new i; i < sizeof acss_fix_TD; i++)
    {
        TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
    }

    if(EditingAccNew[playerid])
    {
        // ??????? ?????????, ??? ??? ?????????????? ????????
        new attached_slot = GetPVarInt(playerid, "attached_slot");
        RemovePlayerAttachedObject(playerid, attached_slot);
        EditingAccNew[playerid] = false;
    }

    PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
    CancelSelectTextDraw(playerid);
    TogglePlayerControllable(playerid, true);
    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);

    DeletePVar(playerid, "edit_x");
    DeletePVar(playerid, "edit_y");
    DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX");
    DeletePVar(playerid, "edit_rY");
    DeletePVar(playerid, "edit_rZ");
    DeletePVar(playerid, "edit_scale");
    DeletePVar(playerid, "slot");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "attached_slot");
    DeletePVar(playerid, "acss_fix_TD_use");
}
if(clickedid == acss_fix_TD[2])  // ?????????
{
    for(new i; i < sizeof acss_fix_TD; i++)
    {
        TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
    }

    if(EditingAccNew[playerid])
    {
        // ????????? ?????? ?????????
        new slot = EditingAccNewSlot[playerid];
        PlayerInventory[playerid][slot][invPosX] = GetPVarFloat(playerid, "edit_x");
        PlayerInventory[playerid][slot][invPosY] = GetPVarFloat(playerid, "edit_y");
        PlayerInventory[playerid][slot][invPosZ] = GetPVarFloat(playerid, "edit_z");
        PlayerInventory[playerid][slot][invRotX] = GetPVarFloat(playerid, "edit_rX");
        PlayerInventory[playerid][slot][invRotY] = GetPVarFloat(playerid, "edit_rY");
        PlayerInventory[playerid][slot][invRotZ] = GetPVarFloat(playerid, "edit_rZ");
        PlayerInventory[playerid][slot][invScaleX] = GetPVarFloat(playerid, "edit_scale");
        PlayerInventory[playerid][slot][invScaleY] = GetPVarFloat(playerid, "edit_scale");
        PlayerInventory[playerid][slot][invScaleZ] = GetPVarFloat(playerid, "edit_scale");
        PlayerInventory[playerid][slot][invInUse] = 1;

        // ????????? ????????? ?? ?????? (??? ?????, ?????? ????????? ???????)
        new attached_slot = GetPVarInt(playerid, "attached_slot");
        RemovePlayerAttachedObject(playerid, attached_slot);
        SetPlayerAttachedObject(playerid, attached_slot,
            EditingAccNewModel[playerid],
            EditingAccNewBone[playerid],
            GetPVarFloat(playerid, "edit_x"),
            GetPVarFloat(playerid, "edit_y"),
            GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"),
            GetPVarFloat(playerid, "edit_rY"),
            GetPVarFloat(playerid, "edit_rZ"),
            GetPVarFloat(playerid, "edit_scale"),
            GetPVarFloat(playerid, "edit_scale"),
            GetPVarFloat(playerid, "edit_scale"));

        // ????????? ? ??
        new query[512];
        mysql_format(mysql, query, sizeof(query),
            "UPDATE `inventory` SET \
            `pos_x` = %f, `pos_y` = %f, `pos_z` = %f, \
            `rot_x` = %f, `rot_y` = %f, `rot_z` = %f, \
            `scale_x` = %f, `scale_y` = %f, `scale_z` = %f, \
            `in_use` = 1 \
            WHERE `id` = %d",
            GetPVarFloat(playerid, "edit_x"),
            GetPVarFloat(playerid, "edit_y"),
            GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"),
            GetPVarFloat(playerid, "edit_rY"),
            GetPVarFloat(playerid, "edit_rZ"),
            GetPVarFloat(playerid, "edit_scale"),
            GetPVarFloat(playerid, "edit_scale"),
            GetPVarFloat(playerid, "edit_scale"),
            EditingAccNewInvID[playerid]);
        mysql_tquery(mysql, query);
        EditingAccNew[playerid] = false;
    }

    PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
    CancelSelectTextDraw(playerid);
    TogglePlayerControllable(playerid, true);
    TogglePlayerAllHudElements(playerid, HUD_ELEMENT_SHOW);

    DeletePVar(playerid, "edit_x");
    DeletePVar(playerid, "edit_y");
    DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX");
    DeletePVar(playerid, "edit_rY");
    DeletePVar(playerid, "edit_rZ");
    DeletePVar(playerid, "edit_scale");
    DeletePVar(playerid, "slot");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "attached_slot");
    DeletePVar(playerid, "acss_fix_TD_use");
}
	if(acss_fix_TD[3] <= clickedid <= acss_fix_TD[9])
	{
		new TD;
		for(new i = 3; i < 10;i++) if(clickedid == acss_fix_TD[i]) TD = i;
		new td_use = GetPVarInt(playerid, "acss_fix_TD_use"), count_TD = TD - 3, Float:float_count;
		TextDrawHideForPlayer(playerid, acss_fix_TD[9 + td_use]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[2 + td_use]);
		TextDrawHideForPlayer(playerid, acss_fix_TD[16 + td_use]);
		TextDrawHideForPlayer(playerid, acss_fix_TD[3 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[10 + count_TD]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[17 + count_TD]);
		SetPVarInt(playerid, "acss_fix_TD_use", count_TD+1);

		switch(TD)
		{
			case 3:float_count = GetPVarFloat(playerid, "edit_x");
			case 4:float_count = GetPVarFloat(playerid, "edit_y");
			case 5:float_count = GetPVarFloat(playerid, "edit_z");
			case 6:float_count = GetPVarFloat(playerid, "edit_scale");
			case 7:float_count = GetPVarFloat(playerid, "edit_rX");
			case 8:float_count = GetPVarFloat(playerid, "edit_rY");
			case 9:float_count = GetPVarFloat(playerid, "edit_rZ");
		}
		
		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", float_count);
		PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
	}
if(clickedid == acss_fix_TD[24] || clickedid == acss_fix_TD[25])  // ?????? + ? -
{
    new Float: x = 0.0, Float: y = 0.0, Float: z = 0.0, Float: scale = 0.0, Float: Rx = 0.0, Float: Ry = 0.0, Float: Rz = 0.0;
    new acs_coords[18];
    new bool:is_plus = (clickedid == acss_fix_TD[24]);

    switch(GetPVarInt(playerid, "acss_fix_TD_use"))
    {
        case 1:  // ?????/?????? (X)
        {
            if(is_plus)
            {
                if(GetPVarFloat(playerid, "edit_z") >= 2.000000) return 1;
                z += 0.01;
            }
            else
            {
                if(GetPVarFloat(playerid, "edit_z") <= -2.000000) return 1;
                z -= 0.01;
            }
            format(acs_coords, sizeof(acs_coords), "%.3f", GetPVarFloat(playerid, "edit_z") + z);
        }
        case 2:  // ?????/???? (Y)
        {
            if(is_plus)
            {
                if(GetPVarFloat(playerid, "edit_x") >= 2.000000) return 1;
                x += 0.01;
            }
            else
            {
                if(GetPVarFloat(playerid, "edit_x") <= -2.000000) return 1;
                x -= 0.01;
            }
            format(acs_coords, sizeof(acs_coords), "%.3f", GetPVarFloat(playerid, "edit_x") + x);
        }
        case 3:  // ?? ????/?? ???? (Z)
        {
			if(is_plus)
            {
                if(GetPVarFloat(playerid, "edit_y") >= 2.000000) return 1;
                y += 0.01;
            }
            else
            {
                if(GetPVarFloat(playerid, "edit_y") <= -2.000000) return 1;
                y -= 0.01;
            }
            format(acs_coords, sizeof(acs_coords), "%.3f", GetPVarFloat(playerid, "edit_y") + y);
        }
        case 4:  // ???????
        {
            if(is_plus)
            {
                if(GetPVarFloat(playerid, "edit_scale") >= 5.000000) return 1;
                scale += 0.1;
            }
            else
            {
                if(GetPVarFloat(playerid, "edit_scale") <= 0.100000) return 1;
                scale -= 0.1;
            }
            format(acs_coords, sizeof(acs_coords), "%.2f", GetPVarFloat(playerid, "edit_scale") + scale);
        }
        case 5:  // ??????? X
        {
            if(is_plus)
            {
                Rx += 5.0;
            }
            else
            {
                Rx -= 5.0;
            }
            format(acs_coords, sizeof(acs_coords), "%.1f", GetPVarFloat(playerid, "edit_rX") + Rx);
        }
        case 6:  // ??????? Y
        {
            if(is_plus)
            {
                Ry += 5.0;
            }
            else
            {
                Ry -= 5.0;
            }
            format(acs_coords, sizeof(acs_coords), "%.1f", GetPVarFloat(playerid, "edit_rY") + Ry);
        }
        case 7:  // ??????? Z
        {
            if(is_plus)
            {
                Rz += 5.0;
            }
            else
            {
                Rz -= 5.0;
            }
            format(acs_coords, sizeof(acs_coords), "%.1f", GetPVarFloat(playerid, "edit_rZ") + Rz);
        }
    }

    // ????????? ????? ? ????????????
    PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
    PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
    PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);

    // ????????? PVars
    SetPVarFloat(playerid, "edit_x", GetPVarFloat(playerid, "edit_x") + x);
    SetPVarFloat(playerid, "edit_y", GetPVarFloat(playerid, "edit_y") + y);
    SetPVarFloat(playerid, "edit_z", GetPVarFloat(playerid, "edit_z") + z);
    SetPVarFloat(playerid, "edit_rX", GetPVarFloat(playerid, "edit_rX") + Rx);
    SetPVarFloat(playerid, "edit_rY", GetPVarFloat(playerid, "edit_rY") + Ry);
    SetPVarFloat(playerid, "edit_rZ", GetPVarFloat(playerid, "edit_rZ") + Rz);
    SetPVarFloat(playerid, "edit_scale", GetPVarFloat(playerid, "edit_scale") + scale);

    // ????????? ????????? ?? ?????? (?????????? ?????? ?? ????? ???????)
    new slot = GetPVarInt(playerid, "slot");
    new attached_slot = GetPVarInt(playerid, "attached_slot");

    RemovePlayerAttachedObject(playerid, attached_slot);
    SetPlayerAttachedObject(playerid, attached_slot,
        EditingAccNewModel[playerid],  // modelid ?? ????? ???????
        GetPVarInt(playerid, "bone"),
        GetPVarFloat(playerid, "edit_x"),
        GetPVarFloat(playerid, "edit_y"),
        GetPVarFloat(playerid, "edit_z"),
        GetPVarFloat(playerid, "edit_rX"),
        GetPVarFloat(playerid, "edit_rY"),
        GetPVarFloat(playerid, "edit_rZ"),
        GetPVarFloat(playerid, "edit_scale"),
        GetPVarFloat(playerid, "edit_scale"),
        GetPVarFloat(playerid, "edit_scale"));
}

    #if defined btn_OnPlayerClickTextDraw
        return btn_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw btn_OnPlayerClickTextDraw
#if defined btn_OnPlayerClickTextDraw
    forward btn_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnGameModeInit()
{
    CreateTextDrawButtonBR();
	CreateEditAccessoryTD();
	SetTimer("CREATE_TABLIST_ACCESSORY", 4500, false);
    #if defined acs_OnGameModeInit
        return acs_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit acs_OnGameModeInit
#if defined acs_OnGameModeInit
    forward acs_OnGameModeInit();
#endif

stock EntryAccessoryMarket(playerid)
{
    pl_accessory[playerid] = 0;
    SetPlayerPosEx(playerid, 2896.610839,1496.067871,2499.343750,355.015014, 1, playerid+1);
    HideHud(playerid);
    TogglePlayerControllable(playerid, false);

   // SetPlayerCameraLookAt(playerid, 2899.593261,1499.915283,2499.343750);

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");

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
    TogglePlayerControllable(playerid, false);
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


stock myacs(playerid)
{
    new fmt_text[2048],
        Cache: result,
        id;

    mysql_format(mysql, fmt_text, sizeof(fmt_text), "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows) 
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У вас нет аксессуаров!", "");
        cache_delete(result);
        return 1;
    }
    
    new query[128],
        acs, use, acs_use[70];

    format(fmt_text, sizeof(fmt_text), "№\tНазвание\tСтатус\n");

    for(new i = 0; i < rows; i++)
    {
        id = cache_get_field_content_int(i, "id");
        acs = cache_get_field_content_int(i, "acs_id");
        use = cache_get_field_content_int(i, "use");

        if(use > 0) 
            format(acs_use, sizeof(acs_use), "{8EF674}[ надет ]");
        else 
            format(acs_use, sizeof(acs_use), "{BEBEBE}[ можно надеть ]");

        format(query, sizeof(query), "{CA5757}%d\t{FFD700}%s\t%s\n",
            i + 1, 
            accessory[acs][NAME_ACCESSORY], 
            acs_use
        );
        strcat(fmt_text, query);
        
        SetPlayerListitemValue(playerid, i, id);

        format(query, sizeof(query), "acsuse%d", i);
        SetPVarInt(playerid, query, use);
    }

    Dialog(playerid, 1190, DIALOG_STYLE_TABLIST_HEADERS,
        "{CA5757}BEST RUSSIA {FFFFFF}| Выберите акссесуар из списка ниже",
        fmt_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);

    return 1;
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
if(dialogid == 1190)
{
    if(response)
    {
        new idx = GetPlayerListitemValue(playerid, listitem), string[24];
        SetPVarInt(playerid, "acs_id_sql", idx);

        format(string, sizeof string, "acsuse%d", listitem);

        if(!GetPVarInt(playerid, string))
        {
            Dialog
            (
                playerid, 1191, DIALOG_STYLE_TABLIST_HEADERS,
                "{CA5757}Управление аксессуаром {FFFFFF}| Выберите действие",
                "№\tДействие\tТип\tСтатус\n"\
                "{CA5757}1\t{FFFFFF}Использовать\t{FFFFFF}Надеть\t{8EF674}Доступно\n"\
                "{CA5757}2\t{FFFFFF}Продать игроку\t{FFFFFF}Обмен\t{8EF674}Доступно\n"\
                "{CA5757}3\t{FFFFFF}Удалить\t{FFFFFF}Выбросить\t{CA5757}Не вернуть",
                "Выбрать", "Закрыть"
            );
            SetPVarInt(playerid, "acs_use", 0);
        }
        else
        {
            Dialog
            (
                playerid, 1191, DIALOG_STYLE_TABLIST_HEADERS,
                "{CA5757}Управление аксессуаром {FFFFFF}| Выберите действие",
                "№\tДействие\tТип\tСтатус\n"\
                "{CA5757}1\t{FFFFFF}Снять\t{FFFFFF}Снятие\t{8EF674}Доступно\n"\
                "{CA5757}1\t{FFFFFF}Редактировать\t{FFFFFF}Настройки\t{FFD700}Изменить",
                "Выбрать", "Закрыть"
            );
            SetPVarInt(playerid, "acs_use", 1);
        }
    }
}
    if(dialogid == 1191)
    {
        if(response)
        {
            new id = GetPVarInt(playerid, "acs_id_sql");
           if(!GetPVarInt(playerid, "acs_use"))
            {
                switch(listitem)
                {
                    case 0:UseAccessory(playerid, id);
                    case 1:SellAccessory(playerid, id);
                    case 2:DeleteAccessory(playerid, id);
                }
            } else{
                switch(listitem)
                {
                    case 0:TakeOffAccessory(playerid, id);
                    case 1:EditAccessory(playerid, id);
                }      
            }
        }
    }
    if(dialogid == 1192)
    {
        if(response)
        {
            new player, price;
            if(sscanf(inputtext, "P<,>dd", player, price)) return SendClientMessage(playerid, -1, "Вы не правильно ввели данные.");

            if(player == playerid || !IsPlayerLogged(player) || !IsPlayerConnected(player))
                return SendClientMessage(playerid, -1, "Данного игрока не существует.");

			if(price >= 1_000_000_000 || price <= -1) return SendClientMessage(playerid, -1, "Цена должна быть меньше 1.000.000.000 руб.");


            SetPVarInt(playerid, "owner_accept_acs_sql", GetPVarInt(playerid, "acs_id_sql"));
            SetPVarInt(playerid, "owner_accept_price", price);
            
            SendPlayerOffer(playerid, player, OFFER_TYPE_ACCESSORY);
        }
    }
    #if defined acs_OnDialogResponse
return acs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse acs_OnDialogResponse
#if defined acs_OnDialogResponse
forward acs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif



stock UseAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accessory_inventory WHERE id = %d", database);
    cache = mysql_query(mysql, string);

    new id_acs = cache_get_field_content_int(0, "acs_id"), bone = accessory[id_acs][BONE_ACCESSORY], slot; 
    
    switch(bone)
    {
        case 1:slot = 1;
        case 2:slot = 2;
        case 3:slot = 3;
        case 4:slot = 4;
        case 5:slot = 5;
        case 6:slot = 6;
        case 7:slot = 6;
        case 8:slot = 7;
        case 9:slot = 7;
        case 10:slot  = 8;
        case 11:slot  = 8;
        case 12:slot  = 9;
        case 13:slot  = 9;
    }

    cache_delete(cache);
    new rows;

    mysql_format(mysql, string, sizeof string, "SELECT * FROM accessories_players WHERE `player_id` = %d AND `slot` = %d", GetPlayerAccountID(playerid), slot);
    cache = mysql_query(mysql, string, true);


    
        mysql_format(mysql, string, sizeof string, "INSERT INTO accessories_players (player_id,slot,bone,acs_id) VALUES (%d,%d,%d,%d)", GetPlayerAccountID(playerid), slot, bone, id_acs);
        mysql_query(mysql, string, false);
		
        mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET `use` = 1 WHERE `id`=%d", database);
        mysql_query(mysql, string, false);
        SCM(playerid, -1, "Вы успешно надели аксессуар");
        new obj = accessory[id_acs][ID_ACCESSORY];
        SetPlayerAttachedObject(playerid, slot, obj, bone);
    

    cache_delete(cache);
    return 1;
}

stock TakeOffAccessory(playerid, database)
{
    new slot = -1, string[184];
	mysql_format(mysql, string, sizeof string, "SELECT * FROM accessory_inventory WHERE id = %d",database);
	new Cache:cache = mysql_query(mysql, string, true);

	new acs_id = cache_get_field_content_int(0, "acs_id");

	cache_delete(cache);
    if(!mysql_errno())
    {
        mysql_format(mysql, string, sizeof string, "SELECT slot FROM accessories_players WHERE player_id = %d AND acs_id = %d", GetPlayerAccountID(playerid), acs_id);
        cache = mysql_query(mysql, string, true);

        if(cache_num_rows()) slot = cache_get_row_int(0, 0);

        cache_delete(cache);

        mysql_format(mysql, string, sizeof string, "DELETE FROM accessories_players WHERE player_id = %d AND acs_id = %d", GetPlayerAccountID(playerid), acs_id);
        mysql_query(mysql, string, false);

		mysql_format(mysql, string, sizeof string, "UPDATE accessory_inventory SET `use` = 0 WHERE `id`=%d", database);
    	mysql_query(mysql, string, false);


        if(slot != -1)
        {           
            RemovePlayerAttachedObject(playerid, slot);
            ShowNewNotification(playerid, 3, 6, 0, 0, "Аксессуар снят", "");
        }
    }

    return 1;
}

stock SellAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql,string, sizeof string, "SELECT acs_id FROM accessory_inventory WHERE id = %d", database);
    cache = mysql_query(mysql, string);

    SetPVarInt(playerid, "acs_id", cache_get_row_int(0, 0));

    cache_delete(cache);

    Dialog(
        playerid, 1192, DIALOG_STYLE_INPUT, 
        "{FF0000}Введите данные",
        "Напишите ID-игрока и цену за аксессуар\n"\
        "Пример: 0, 100000 (id, цена)\n"\
        "\nЕсли вы хотите передать — пишите цену «0»",
        "Далее", "Выйти"
    );
    
    return 1;
}

stock DeleteAccessory(playerid, database)
{
    new string[124], Cache:cache;

    mysql_format(mysql,string, sizeof string, "DELETE FROM accessory_inventory WHERE id = %d", database);
    mysql_query(mysql, string, false);

    if(!mysql_errno()) SendClientMessage(playerid, -1, "Аксессуар удалён.");
    else SendClientMessage(playerid, -1, "Ошибка в удалении аксессуара");

    return 1;
}

stock EditAccessory(playerid, database)
{
    new query[220], rows, Cache: result;

    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");

	format(query, sizeof query, "SELECT acs_id FROM accessory_inventory WHERE id=%d", database);
	result = mysql_query(mysql, query, true);

	new acs_id = cache_get_row_int(0, 0);

	cache_delete(result);

	format(query, sizeof query, "SELECT * FROM accessories_players WHERE player_id=%d AND acs_id=%d", GetPlayerAccountID(playerid), acs_id);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	if(rows)
	{
		new 
		bone = cache_get_field_content_int(0, "bone"),
		slot = cache_get_field_content_int(0, "slot"),
		Float: x =  cache_get_field_content_float(0, "x"),
		Float: y =  cache_get_field_content_float(0, "y"),
		Float: z =  cache_get_field_content_float(0, "z"),
		Float: rX = cache_get_field_content_float(0, "rX"),
		Float: rY = cache_get_field_content_float(0, "rY"),
		Float: rZ = cache_get_field_content_float(0, "rZ"),
		Float: scale =  cache_get_field_content_float(0, "scale");

       	SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "acs_id", acs_id);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "edit_y", y);
		SetPVarFloat(playerid, "edit_z", z);
		SetPVarFloat(playerid, "edit_x", x);
		SetPVarFloat(playerid, "edit_rX", rX);
		SetPVarFloat(playerid, "edit_rY", rY);
		SetPVarFloat(playerid, "edit_rZ", rZ);
		SetPVarFloat(playerid, "edit_scale", scale);

		RemovePlayerAttachedObject(playerid, slot);

		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			accessory[GetPVarInt(playerid, "acs_id")][ID_ACCESSORY],
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "edit_x"),
			GetPVarFloat(playerid, "edit_y"),
   			GetPVarFloat(playerid, "edit_z"),
      		GetPVarFloat(playerid, "edit_rX"),
			GetPVarFloat(playerid, "edit_rY"),
			GetPVarFloat(playerid, "edit_rZ"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale"),
			GetPVarFloat(playerid, "edit_scale")
		);

		SelectTextDraw(playerid, -1);

		for(new i; i < 11; i ++) TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[17]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[24]);
		TextDrawShowForPlayer(playerid, acss_fix_TD[25]);

		new acs_coords[18];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "edit_x"));

		acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
		PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
		PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
		PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
		PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);

		PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);

		SetPVarInt(playerid, "acss_fix_TD_use", 1);
		// TogglePlayerControllable(playerid, false); фу не удобно ыелси жепете кодер
		TogglePlayerAllHudElements(playerid, HUD_ELEMENT_HIDE);
        TogglePlayerControllable(playerid, true);
		TogglePlayerControllable(playerid, 0);
        //SetPlayerFrozen(playerid, true);
	}

	cache_delete(result);
}

stock GiveAccessoryToNewInventory(playerid, acs_index)
{
    new item, modelid, bone, name[64];

    // ?????? ???????: ????? ?????? -> ????? ?????????
    switch(acs_index)
    {
        case 0:  // Крылья Бабочки
        {
            item = 490;
            modelid = 4196;
            bone = 1;
        }
        case 1:  // Маска пчелы
        {
            item = 491;
            modelid = 4197;
            bone = 1;

        }
        case 2:  // Кленовая корона
        {
            item = 492;
            modelid = 4198;
            bone = 1;
        }
        case 3:  // Рюкзак - реактивный ранец
        {
            item = 493;
            modelid = 4199;
            bone = 1;
        }
        case 4:  // Кленовая сумка
        {
        	item = 494;
            modelid = 4200;
            bone = 2;
        }
        case 5:  // Метла
        {
            item = 495;
            modelid = 4201;
            bone = 2;
        }
        case 6:  // Рюкзак с овощами
        {
            item = 497;
            modelid = 4203;
            bone = 1;
        }
        case 7:  // Школьный рюкзак
        {
            item = 498;
            modelid = 4204;
            bone = 6;
        }
        case 8:  // Шапка - подсолнух
        {
        	item = 499;
            modelid = 4205;
            bone = 2;
        }
        case 9:  // Черный зонт
        {
            item = 500;
            modelid = 4206;
            bone = 2;
        }
       	case 10:  // Зонт с листьями
        {
            item = 501;
            modelid = 4207;
            bone = 2;
        }
        case 11:  // Розовый зонт
        {
            item = 502;
            modelid = 4208;
            bone = 1;
        }
        case 12:  // Крылья демона
        {
            item = 491;
            modelid = 14574;
            bone = 1;

        }
        case 13:  // Кленовая корона
        {
            item = 509;
            modelid = 14575;
            bone = 1;
        }
        case 14:  // Рюкзак - реактивный ранец
        {
            item = 517;
            modelid = 14593;
            bone = 1;
        }
        case 15:  // Кленовая сумка
        {
        	item = 135;
            modelid = 15134;
            bone = 2;
        }
        case 16:  // Метла
        {
            item = 136;
            modelid = 15135;
            bone = 2;
        }
        case 17:  // Рюкзак с овощами
        {
            item = 137;
            modelid = 15136;
            bone = 1;
        }
        case 18:  // Школьный рюкзак
        {
            item = 138;
            modelid = 15137;
            bone = 6;
        }
        case 19:  // Шапка - подсолнух
        {
        	item = 139;
            modelid = 15138;
            bone = 2;
        }
        case 20:  // Черный зонт
        {
            item = 140;
            modelid = 15139;
            bone = 2;
        }
       	case 21:  // Зонт с листьями
        {
            item = 141;
            modelid = 15140;
            bone = 2;
        }
        case 22:  // Крылья Бабочки
        {
            item = 142;
            modelid = 15141;
            bone = 1;
        }
        case 23:  // Маска пчелы
        {
            item = 143;
            modelid = 15142;
            bone = 1;

        }
        case 24:  // Кленовая корона
        {
            item = 144;
            modelid = 15143;
            bone = 1;
        }
        case 25:  // Рюкзак - реактивный ранец
        {
            item = 145;
            modelid = 15144;
            bone = 1;
        }
        case 26:  // Кленовая сумка
        {
        	item = 146;
            modelid = 15145;
            bone = 2;
        }
        case 27:  // Метла
        {
            item = 147;
            modelid = 15146;
            bone = 2;
        }
        case 28:  // Рюкзак с овощами
        {
            item = 148;
            modelid = 15147;
            bone = 1;
        }
        case 29:  // Школьный рюкзак
        {
            item = 149;
            modelid = 15148;
            bone = 6;
        }
        case 30:  // Шапка - подсолнух
        {
        	item = 150;
            modelid = 15149;
            bone = 2;
        }
        case 31:  // Черный зонт
        {
            item = 155;
            modelid = 15150;
            bone = 2;
        }
       	case 32:  // Зонт с листьями
        {
            item = 159;
            modelid = 15151;
            bone = 2;
        }
        case 33:  // Крылья Бабочки
        {
            item = 151;
            modelid = 15152;
            bone = 1;
        }
        case 34:  // Маска пчелы
        {
            item = 152;
            modelid = 15153;
            bone = 1;

        }
        case 35:  // Кленовая корона
        {
            item = 393;
            modelid = 7329;
            bone = 1;
        }
        case 36:  // Рюкзак - реактивный ранец
        {
            item = 493;
            modelid = 395;
            bone = 1;
        }
        case 37:  // Кленовая сумка
        {
        	item = 494;
            modelid = 396;
            bone = 2;
        }
        case 38:  // Метла
        {
            item = 397;
            modelid = 7333;
            bone = 2;
        }
        case 39:  // Рюкзак с овощами
        {
            item = 398;
            modelid = 7334;
            bone = 1;
        }
        case 40:  // Школьный рюкзак
        {
            item = 400;
            modelid = 7336;
            bone = 6;
        }
        case 41:  // Шапка - подсолнух
        {
        	item = 401;
            modelid = 7337;
            bone = 2;
        }
        case 42:  // Черный зонт
        {
            item = 402;
            modelid = 7338;
            bone = 2;
        }
       	case 43:  // Зонт с листьями
        {
            item = 403;
            modelid = 7339;
            bone = 2;
        }
        case 44:  // Крылья Бабочки
        {
            item = 405;
            modelid = 7341;
            bone = 1;
        }
        case 45:  // Маска пчелы
        {
            item = 406;
            modelid = 7342;
            bone = 1;

        }
        case 46:  // Кленовая корона
        {
            item = 407;
            modelid = 7343;
            bone = 1;
        }
        case 47:  // Рюкзак - реактивный ранец
        {
            item = 408;
            modelid = 7344;
            bone = 1;
        }
        case 48:  // Кленовая сумка
        {
        	item = 414;
            modelid = 7350;
            bone = 2;
        }
        case 49:  // Метла
        {
            item = 289;
            modelid = 18377;
            bone = 2;
        }
        case 50:  // Рюкзак с овощами
        {
            item = 288;
            modelid = 18386;
            bone = 1;
        }
        case 51:  // Школьный рюкзак
        {
            item = 301;
            modelid = 18389;
            bone = 6;
        }
        case 52:  // Шапка - подсолнух
        {
        	item = 302;
            modelid = 18390;
            bone = 2;
        }
        case 53:  // Черный зонт
        {
            item = 303;
            modelid = 18391;
            bone = 2;
        }
       	case 54:  // Зонт с листьями
        {
            item = 304;
            modelid = 18392;
            bone = 2;
        }
        case 55:  // Крылья Бабочки
        {
            item = 308;
            modelid = 18396;
            bone = 1;
        }
        case 56:  // Маска пчелы
        {
            item = 309;
            modelid = 18397;
            bone = 1;

        }
        case 57:  // Кленовая корона
        {
            item = 311;
            modelid = 18399;
            bone = 1;
        }
        case 58:  // Рюкзак - реактивный ранец
        {
            item = 312;
            modelid = 18400;
            bone = 1;
        }
        case 59:  // Кленовая сумка
        {
        	item = 313;
            modelid = 18401;
            bone = 2;
        }
        case 60:  // Метла
        {
            item = 314;
            modelid = 18402;
            bone = 2;
        }
        case 61:  // Рюкзак с овощами
        {
            item = 315;
            modelid = 18403;
            bone = 1;
        }
        case 62:  // Школьный рюкзак
        {
            item = 316;
            modelid = 18404;
            bone = 6;
        }
        case 63:  // Шапка - подсолнух
        {
        	item = 321;
            modelid = 18409;
            bone = 2;
        }
        case 64:  // Черный зонт
        {
            item = 417;
            modelid = 7353;
            bone = 2;
        }
       	case 65:  // Зонт с листьями
        {
            item = 418;
            modelid = 7354;
            bone = 2;
        }
        case 66:  // Крылья Бабочки
        {
            item = 419;
            modelid = 7355;
            bone = 1;
        }
        case 67:  // Маска пчелы
        {
            item = 420;
            modelid = 7356;
            bone = 1;

        }
        case 68:  // Кленовая корона
        {
            item = 426;
            modelid = 7362;
            bone = 1;
        }
        case 69:  // Рюкзак - реактивный ранец
        {
            item = 428;
            modelid = 7364;
            bone = 1;
        }
        case 70:  // Кленовая сумка
        {
        	item = 431;
            modelid = 7367;
            bone = 2;
        }
        case 71:  // Метла
        {
            item = 432;
            modelid = 7368;
            bone = 2;
        }
        case 72:  // Рюкзак с овощами
        {
            item = 433;
            modelid = 7369;
            bone = 1;
        }
        case 73:  // Школьный рюкзак
        {
            item = 434;
            modelid = 7370;
            bone = 6;
        }
        case 74:  // Шапка - подсолнух
        {
        	item = 435;
            modelid = 7371;
            bone = 2;
        }
        case 75:  // Черный зонт
        {
            item = 436;
            modelid = 7372;
            bone = 2;
        }
       	case 76:  // Зонт с листьями
        {
            item = 438;
            modelid = 7374;
            bone = 2;
        }
        // ???????? ?????? ??????? ?????...
        default:
        {
            ShowNotificationFan4iik(playerid, 2, 5, 0, 0, "??????! ????????? ?? ??????", " ");
            return 0;
        }
    }

    // ???? ????????? ???? ? ????? ?????????
    new slot = -1;
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        if(PlayerInventory[playerid][i][invItem] == 0)
        {
            slot = i;
            break;
        }
    }

    if(slot == -1)
    {
        ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "????????? ?????!", "?????????? ?????");
        return 0;
    }

    // ????????? ??????
    PlayerInventory[playerid][slot][invItem] = item;
    PlayerInventory[playerid][slot][invCount] = 1;
    PlayerInventory[playerid][slot][invValue] = modelid;
    PlayerInventory[playerid][slot][invBone] = bone;
    PlayerInventory[playerid][slot][invPosX] = 0.0;
    PlayerInventory[playerid][slot][invPosY] = 0.0;
    PlayerInventory[playerid][slot][invPosZ] = 0.0;
    PlayerInventory[playerid][slot][invRotX] = 0.0;
    PlayerInventory[playerid][slot][invRotY] = 0.0;
    PlayerInventory[playerid][slot][invRotZ] = 0.0;
    PlayerInventory[playerid][slot][invScaleX] = 1.0;
    PlayerInventory[playerid][slot][invScaleY] = 1.0;
    PlayerInventory[playerid][slot][invScaleZ] = 1.0;
    PlayerInventory[playerid][slot][invInUse] = 0;

    // ????????? ? ??
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `inventory` (`uid`, `item_id`, `count`, `value`, `slot`, `bone`, `pos_x`, `pos_y`, `pos_z`, `rot_x`, `rot_y`, `rot_z`, `scale_x`, `scale_y`, `scale_z`, `in_use`) \
         VALUES (%d, %d, 1, %d, %d, %d, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0)",
        GetPlayerAccountID(playerid),item, modelid, slot, bone);
    mysql_tquery(mysql, query, "OnItemInserted", "ii", playerid, slot);

    return 1;
}

public:LoadAccessory(playerid)
{
	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT * FROM accessories_players WHERE player_id= %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

    if(rows)
    {
        new slot, acs, bone, Float:x, Float:y, Float:z, 
        Float:rZ, Float:rY, Float:rX, Float:scale;

        for(new i; i < rows; i++)
        {
            slot = cache_get_field_content_int(i, "slot"),
            acs = cache_get_field_content_int(i, "acs_id"),
            bone = cache_get_field_content_int(i, "bone"),
            Float: x = cache_get_field_content_float(i, "x"),
            Float: y = cache_get_field_content_float(i, "y"),
            Float: z = cache_get_field_content_float(i, "z"),
            Float: rX = cache_get_field_content_float(i, "rX"),
            Float: rY = cache_get_field_content_float(i, "rY"),
            Float: rZ = cache_get_field_content_float(i, "rZ"),
            Float: scale = cache_get_field_content_float(i, "scale");

            SetPlayerAttachedObject(playerid, slot, accessory[acs][ID_ACCESSORY], bone, x, y, z, rX, rY, rZ, scale, scale, scale);
        }
    }

	cache_delete(result);

    return 1;
}


stock CreateEditAccessoryTD()//автор редактора не welsi
{
    	//ТЕКСТ  "РЕЖИМ КАСТОМИЗАЦИЙ"
	acss_fix_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acss_fix_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acss_fix_TD[0], 1);
	TextDrawColor(acss_fix_TD[0], -1);
	TextDrawBackgroundColor(acss_fix_TD[0], 255);
	TextDrawFont(acss_fix_TD[0], 4);

	//КНОПКА "ВЫХОД"
	acss_fix_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acss_fix_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[1], 1);
	TextDrawColor(acss_fix_TD[1], -1);
	TextDrawBackgroundColor(acss_fix_TD[1], 255);
	TextDrawFont(acss_fix_TD[1], 4);
	TextDrawSetSelectable(acss_fix_TD[1], true);

	//КНОПКА "СОХРАНИТЬ"
	acss_fix_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acss_fix_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acss_fix_TD[2], 1);
	TextDrawColor(acss_fix_TD[2], -1);
	TextDrawBackgroundColor(acss_fix_TD[2], 255);
	TextDrawFont(acss_fix_TD[2], 4);
	TextDrawSetSelectable(acss_fix_TD[2], true);

//-НЕ НАЖАТЫЕ КНОПКИ
   	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_fix_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acss_fix_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[3], 1);
	TextDrawColor(acss_fix_TD[3], -1);
	TextDrawBackgroundColor(acss_fix_TD[3], 255);
	TextDrawFont(acss_fix_TD[3], 4);
	TextDrawSetSelectable(acss_fix_TD[3], true);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_fix_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acss_fix_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[4], 1);
	TextDrawColor(acss_fix_TD[4], -1);
	TextDrawBackgroundColor(acss_fix_TD[4], 255);
	TextDrawFont(acss_fix_TD[4], 4);
	TextDrawSetSelectable(acss_fix_TD[4], true);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acss_fix_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[5], 1);
	TextDrawColor(acss_fix_TD[5], -1);
	TextDrawBackgroundColor(acss_fix_TD[5], 255);
	TextDrawFont(acss_fix_TD[5], 4);
	TextDrawSetSelectable(acss_fix_TD[5], true);

	//КНОПКА "МАСШТАБ"
	acss_fix_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acss_fix_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[6], 1);
	TextDrawColor(acss_fix_TD[6], -1);
	TextDrawBackgroundColor(acss_fix_TD[6], 255);
	TextDrawFont(acss_fix_TD[6], 4);
	TextDrawSetSelectable(acss_fix_TD[6], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acss_fix_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[7], 1);
	TextDrawColor(acss_fix_TD[7], -1);
	TextDrawBackgroundColor(acss_fix_TD[7], 255);
	TextDrawFont(acss_fix_TD[7], 4);
	TextDrawSetSelectable(acss_fix_TD[7], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acss_fix_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[8], 1);
	TextDrawColor(acss_fix_TD[8], -1);
	TextDrawBackgroundColor(acss_fix_TD[8], 255);
	TextDrawFont(acss_fix_TD[8], 4);
	TextDrawSetSelectable(acss_fix_TD[8], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acss_fix_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[9], 1);
	TextDrawColor(acss_fix_TD[9], -1);
	TextDrawBackgroundColor(acss_fix_TD[9], 255);
	TextDrawFont(acss_fix_TD[9], 4);
	TextDrawSetSelectable(acss_fix_TD[9], true);

//-НАЖАТЫЕ КНОПКИ
	//КНОПКА "ВЛЕВО/ВПРАВО"
	acss_fix_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acss_fix_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[10], 1);
	TextDrawColor(acss_fix_TD[10], -1);
	TextDrawBackgroundColor(acss_fix_TD[10], 255);
	TextDrawFont(acss_fix_TD[10], 4);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acss_fix_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acss_fix_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[11], 1);
	TextDrawColor(acss_fix_TD[11], -1);
	TextDrawBackgroundColor(acss_fix_TD[11], 255);
	TextDrawFont(acss_fix_TD[11], 4);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acss_fix_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[12], 1);
	TextDrawColor(acss_fix_TD[12], -1);
	TextDrawBackgroundColor(acss_fix_TD[12], 255);
	TextDrawFont(acss_fix_TD[12], 4);

	//КНОПКА "МАСШТАБ"
	acss_fix_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acss_fix_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[13], 1);
	TextDrawColor(acss_fix_TD[13], -1);
	TextDrawBackgroundColor(acss_fix_TD[13], 255);
	TextDrawFont(acss_fix_TD[13], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acss_fix_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[14], 1);
	TextDrawColor(acss_fix_TD[14], -1);
	TextDrawBackgroundColor(acss_fix_TD[14], 255);
	TextDrawFont(acss_fix_TD[14], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acss_fix_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[15], 1);
	TextDrawColor(acss_fix_TD[15], -1);
	TextDrawBackgroundColor(acss_fix_TD[15], 255);
	TextDrawFont(acss_fix_TD[15], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acss_fix_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[16], 1);
	TextDrawColor(acss_fix_TD[16], -1);
	TextDrawBackgroundColor(acss_fix_TD[16], 255);
	TextDrawFont(acss_fix_TD[16], 4);

	//РЕДАКТОР "ВЛЕВО/ВПРАВО"
	acss_fix_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acss_fix_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[17], 1);
	TextDrawColor(acss_fix_TD[17], -1);
	TextDrawBackgroundColor(acss_fix_TD[17], 255);
	TextDrawFont(acss_fix_TD[17], 4);
	TextDrawSetProportional(acss_fix_TD[17], 0);
	TextDrawSetShadow(acss_fix_TD[17], 0);

	//РЕДАКТОР "ВВЕРХ/ВНИЗ"
	acss_fix_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acss_fix_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[18], 1);
	TextDrawColor(acss_fix_TD[18], -1);
	TextDrawBackgroundColor(acss_fix_TD[18], 255);
	TextDrawFont(acss_fix_TD[18], 4);
	TextDrawSetProportional(acss_fix_TD[18], 0);
	TextDrawSetShadow(acss_fix_TD[18], 0);

	//РЕДАКТОР "ОТ СЕБЯ/НА СЕБЯ"
	acss_fix_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acss_fix_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[19], 1);
	TextDrawColor(acss_fix_TD[19], -1);
	TextDrawBackgroundColor(acss_fix_TD[19], 255);
	TextDrawFont(acss_fix_TD[19], 4);
	TextDrawSetProportional(acss_fix_TD[19], 0);
	TextDrawSetShadow(acss_fix_TD[19], 0);

	//РЕДАКТОР "МАСШТАБ"
	acss_fix_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acss_fix_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[20], 1);
	TextDrawColor(acss_fix_TD[20], -1);
	TextDrawBackgroundColor(acss_fix_TD[20], 255);
	TextDrawFont(acss_fix_TD[20], 4);
	TextDrawSetProportional(acss_fix_TD[20], 0);
	TextDrawSetShadow(acss_fix_TD[20], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ X"
	acss_fix_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acss_fix_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[21], 1);
	TextDrawColor(acss_fix_TD[21], -1);
	TextDrawBackgroundColor(acss_fix_TD[21], 255);
	TextDrawFont(acss_fix_TD[21], 4);
	TextDrawSetProportional(acss_fix_TD[21], 0);
	TextDrawSetShadow(acss_fix_TD[21], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Y"
	acss_fix_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acss_fix_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[22], 1);
	TextDrawColor(acss_fix_TD[22], -1);
	TextDrawBackgroundColor(acss_fix_TD[22], 255);
	TextDrawFont(acss_fix_TD[22], 4);
	TextDrawSetProportional(acss_fix_TD[22], 0);
	TextDrawSetShadow(acss_fix_TD[22], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Z"
	acss_fix_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acss_fix_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[23], 1);
	TextDrawColor(acss_fix_TD[23], -1);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[23], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[23], 0);

	acss_fix_TD[24] = TextDrawCreate(460.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[24], 1);
	TextDrawColor(acss_fix_TD[24], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[24], 255);
	TextDrawFont(acss_fix_TD[24], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[24], 0);
	TextDrawSetSelectable(acss_fix_TD[24], true);

	acss_fix_TD[25] = TextDrawCreate(530.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[25], 1);
	TextDrawColor(acss_fix_TD[25], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[25], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[25], 0);
	TextDrawSetSelectable(acss_fix_TD[25], true);
}

public: CREATE_TABLIST_ACCESSORY()
{
	mysql_query(mysql, "SELECT * FROM accessories_players");

	if(mysql_errno())
	{
		mysql_query(mysql, 
			"CREATE TABLE `accessories_players` (\
		`id` INT NOT NULL AUTO_INCREMENT , PRIMARY KEY (`id`),\
		`player_id` int(11) NOT NULL,\
		`slot` int(11) NOT NULL,\
		`bone` int(11) NOT NULL,\
		`acs_id` int(11) NOT NULL,\
		`x` float NOT NULL DEFAULT 0.01,\
		`y` float NOT NULL DEFAULT 0.01,\
		`z` float NOT NULL DEFAULT 0.01,\
		`rX` float NOT NULL DEFAULT 0.01,\
		`rY` float NOT NULL DEFAULT 0.01,\
		`rZ` float NOT NULL DEFAULT 0.01,\
		`scale` float NOT NULL DEFAULT 1.01) ENGINE=InnoDB DEFAULT CHARSET=utf8;", false);

		if(mysql_errno()) return printf("ERROR CREATE TABLE accessories_players");
	}

	mysql_query(mysql, "SELECT * FROM accessory_inventory");

	if(mysql_errno())
	{
		mysql_query(mysql, 
			"CREATE TABLE `accessory_inventory` ( `id` INT NOT NULL AUTO_INCREMENT , \
			`player_id` INT NOT NULL , \
			`acs_id` INT NOT NULL , \
			`use` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB;", false);

		if(mysql_errno()) return printf("ERROR CREATE TABLE accessory_inventory");
	}

	return 1;
}

// slil - @lildrugstudio52 and @lildrugbio buy project - lildrugshop.ru
