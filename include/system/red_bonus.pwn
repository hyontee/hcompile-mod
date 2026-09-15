// Глобальные переменные для текстдрагов
new PlayerText: clothes_shop_TD[MAX_PLAYERS][10];
new PlayerText: price_select_TD[MAX_PLAYERS][2];

// Функция создания интерфейса магазина одежды
stock CreateClothesShopTextDraws(playerid)
{
    // Фон
    clothes_shop_TD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000, 240.000, "_");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][0], 0.600, 20.000);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][0], 298.500, 210.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][0], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][0], 255);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][0], 200);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][0], 0);

    // Заголовок
    clothes_shop_TD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000, 150.000, "МАГАЗИН ОДЕЖДЫ");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][1], 2);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][1], 0.300, 1.500);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][1], 400.000, 50.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][1], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][1], 255);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][1], 0);

    // Кнопка "Назад"
    clothes_shop_TD[playerid][2] = CreatePlayerTextDraw(playerid, 220.000, 350.000, "НАЗАД");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][2], 2);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][2], 0.300, 1.500);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][2], 80.000, 40.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][2], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][2], 0xAA3333FF);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][2], 1);

    // Кнопка "Купить"
    clothes_shop_TD[playerid][3] = CreatePlayerTextDraw(playerid, 420.000, 350.000, "КУПИТЬ");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][3], 2);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][3], 0.300, 1.500);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][3], 80.000, 40.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][3], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][3], 0x33AA33FF);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][3], 1);

    // Кнопка "Влево"
    clothes_shop_TD[playerid][4] = CreatePlayerTextDraw(playerid, 270.000, 250.000, "<");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][4], 2);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][4], 0.600, 2.000);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][4], 30.000, 30.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][4], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][4], 0x888888FF);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][4], 1);

    // Кнопка "Вправо"
    clothes_shop_TD[playerid][5] = CreatePlayerTextDraw(playerid, 370.000, 250.000, ">");
    PlayerTextDrawFont(playerid, clothes_shop_TD[playerid][5], 2);
    PlayerTextDrawLetterSize(playerid, clothes_shop_TD[playerid][5], 0.600, 2.000);
    PlayerTextDrawTextSize(playerid, clothes_shop_TD[playerid][5], 30.000, 30.000);
    PlayerTextDrawSetOutline(playerid, clothes_shop_TD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, clothes_shop_TD[playerid][5], 0);
    PlayerTextDrawAlignment(playerid, clothes_shop_TD[playerid][5], 2);
    PlayerTextDrawColor(playerid, clothes_shop_TD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, clothes_shop_TD[playerid][5], 255);
    PlayerTextDrawBoxColor(playerid, clothes_shop_TD[playerid][5], 0x888888FF);
    PlayerTextDrawUseBox(playerid, clothes_shop_TD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, clothes_shop_TD[playerid][5], 1);
    PlayerTextDrawSetSelectable(playerid, clothes_shop_TD[playerid][5], 1);

    // Цена
    price_select_TD[playerid][0] = CreatePlayerTextDraw(playerid, 320.000, 300.000, "Цена: $0");
    PlayerTextDrawFont(playerid, price_select_TD[playerid][0], 1);
    PlayerTextDrawLetterSize(playerid, price_select_TD[playerid][0], 0.300, 1.500);
    PlayerTextDrawTextSize(playerid, price_select_TD[playerid][0], 400.000, 20.000);
    PlayerTextDrawSetOutline(playerid, price_select_TD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, price_select_TD[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, price_select_TD[playerid][0], 2);
    PlayerTextDrawColor(playerid, price_select_TD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, price_select_TD[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, price_select_TD[playerid][0], 255);
    PlayerTextDrawUseBox(playerid, price_select_TD[playerid][0], 0);
    PlayerTextDrawSetProportional(playerid, price_select_TD[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, price_select_TD[playerid][0], 0);

    // Информация о текущем скине
    price_select_TD[playerid][1] = CreatePlayerTextDraw(playerid, 320.000, 200.000, "Скин 1/10");
    PlayerTextDrawFont(playerid, price_select_TD[playerid][1], 1);
    PlayerTextDrawLetterSize(playerid, price_select_TD[playerid][1], 0.300, 1.500);
    PlayerTextDrawTextSize(playerid, price_select_TD[playerid][1], 400.000, 20.000);
    PlayerTextDrawSetOutline(playerid, price_select_TD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, price_select_TD[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, price_select_TD[playerid][1], 2);
    PlayerTextDrawColor(playerid, price_select_TD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, price_select_TD[playerid][1], 255);
    PlayerTextDrawUseBox(playerid, price_select_TD[playerid][1], 0);
    PlayerTextDrawSetProportional(playerid, price_select_TD[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, price_select_TD[playerid][1], 0);

    return 1;
}

// Функция показа интерфейса
stock ShowClothesShopTextDraws(playerid)
{
    for(new i = 0; i < 6; i++)
    {
        PlayerTextDrawShow(playerid, clothes_shop_TD[playerid][i]);
    }
    PlayerTextDrawShow(playerid, price_select_TD[playerid][0]);
    PlayerTextDrawShow(playerid, price_select_TD[playerid][1]);
    
    SelectTextDraw(playerid, 0x00FF00FF);
    return 1;
}

// Функция скрытия интерфейса
stock HideClothesShopTextDraws(playerid)
{
    for(new i = 0; i < 6; i++)
    {
        PlayerTextDrawHide(playerid, clothes_shop_TD[playerid][i]);
    }
    PlayerTextDrawHide(playerid, price_select_TD[playerid][0]);
    PlayerTextDrawHide(playerid, price_select_TD[playerid][1]);
    
    CancelSelectTextDraw(playerid);
    return 1;
}

// Функция обновления информации о скине
stock UpdateShop(playerid)
{
    new businessid = GetPlayerInBiz(playerid);
    if(businessid == -1) return 0;
    
    new select_skin = GetPlayerSelectSkin(playerid);
    if(select_skin == -1) return 0;
    
    new sex = GetPlayerSex(playerid);
    new skin_id = g_business_clothing_skins[sex][select_skin][0];
    new price = g_business_clothing_skins[sex][select_skin][1];
    
    // Устанавливаем скин для предпросмотра
    SetPlayerSkin(playerid, skin_id);
    
    // Обновляем текст с ценой
    new str[64];
    format(str, sizeof(str), "Цена: $%d", price);
    PlayerTextDrawSetString(playerid, price_select_TD[playerid][0], str);
    
    // Обновляем номер скина
    new total_skins = GetTotalClothingSkins(sex);
    format(str, sizeof(str), "Скин %d/%d", select_skin + 1, total_skins);
    PlayerTextDrawSetString(playerid, price_select_TD[playerid][1], str);
    
    return 1;
}

// Функция скрытия магазина
stock HideShop(playerid)
{
    HideClothesShopTextDraws(playerid);
    return 1;
}

// Функция показа панели магазина
stock ShowPlayerClothingShopPanel(playerid)
{
    new businessid = GetPlayerInBiz(playerid);

    if(GetPlayerTeamEx(playerid) <= 0)
    {
        new select_skin = GetPlayerSelectSkin(playerid);

        if(select_skin == -1)
        {
            new type = GetBusinessData(businessid, B_INTERIOR);
            new interior = GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR);
            
            SetPlayerPosEx(playerid, 1200.4557, 607.9025, 1349.3094, 180.0000, interior, playerid + 32, false);

            SetPlayerCameraPos(playerid, 1200.0, 605.0, 1350.0, 5.0050);
            SetPlayerCameraLookAt(playerid, 1200.4557, 607.9025, 1349.3094);
            HideHud(playerid);
            TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);

            CreateClothesShopTextDraws(playerid);
            SetPlayerSelectClothingSkin(playerid, 0);

            UpdateShop(playerid);
            ShowClothesShopTextDraws(playerid);

            CallLocalFunction("BuySkinPTDUpdate", "i", playerid);

            TogglePlayerControllable(playerid, false);
        }
    }
    else SendClientMessage(playerid, 0xCECECEFF, "Вы состоите в организации, купить новую внешность нельзя");
}

// Функция выхода из магазина
stock ExitPlayerClothingShopPanel(playerid)
{
    new in_biz = GetPlayerInBiz(playerid);
    if(in_biz != -1)
    {
        HidePlayerSelectPanel(playerid);

        SetPlayerSkinInit(playerid);
        SetCameraBehindPlayer(playerid);
        TogglePlayerControllable(playerid, true);

        PlayerTextDrawSetString(playerid, price_select_TD[playerid][0], "exit...");
        SetTimerEx("HidePlayerSelectPanelPriceTimer", 1000, false, "i", playerid);

        SetPlayerData(playerid, P_SELECT_SKIN, -1);
        
        HideClothesShopTextDraws(playerid);

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
        HideShop(playerid);
        TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        ShowHud(playerid);
    }
}

// Обработка кликов по текстдрагам
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == clothes_shop_TD[playerid][2]) // Назад
    {
        ExitPlayerClothingShopPanel(playerid);
        return 1;
    }
    else if(playertextid == clothes_shop_TD[playerid][3]) // Купить
    {
        new businessid = GetPlayerInBiz(playerid);
        if(businessid != -1)
        {
            new select_skin = GetPlayerSelectSkin(playerid);
            if(select_skin != -1)
            {
                new sex = GetPlayerSex(playerid);
                new skin_id = g_business_clothing_skins[sex][select_skin][0];
                new price = g_business_clothing_skins[sex][select_skin][1];
                
                // Проверяем достаточно ли денег
                if(GetPlayerMoney(playerid) >= price)
                {
                    GivePlayerMoney(playerid, -price);
                    SetPlayerSkin(playerid, skin_id);
                    SetPlayerData(playerid, P_SKIN, skin_id);
                    
                    // Добавляем деньги бизнесу
                    new biz_money = GetBusinessData(businessid, B_MONEY);
                    SetBusinessData(businessid, B_MONEY, biz_money + price);
                    
                    SendClientMessage(playerid, 0x33AA33FF, "Вы успешно купили одежду!");
                    
                    // Выходим из магазина после покупки
                    ExitPlayerClothingShopPanel(playerid);
                }
                else
                {
                    SendClientMessage(playerid, 0xAA3333FF, "У вас недостаточно денег!");
                }
            }
        }
        return 1;
    }
    else if(playertextid == clothes_shop_TD[playerid][4]) // Влево (предыдущий скин)
    {
        new select_skin = GetPlayerSelectSkin(playerid);
        if(select_skin > 0)
        {
            SetPlayerSelectClothingSkin(playerid, select_skin - 1);
            UpdateShop(playerid);
        }
        else
        {
            SendClientMessage(playerid, 0xCECECEFF, "Это первый скин");
        }
        return 1;
    }
    else if(playertextid == clothes_shop_TD[playerid][5]) // Вправо (следующий скин)
    {
        new sex = GetPlayerSex(playerid);
        new select_skin = GetPlayerSelectSkin(playerid);
        new total_skins = GetTotalClothingSkins(sex);
        
        if(select_skin < total_skins - 1)
        {
            SetPlayerSelectClothingSkin(playerid, select_skin + 1);
            UpdateShop(playerid);
        }
        else
        {
            SendClientMessage(playerid, 0xCECECEFF, "Это последний скин");
        }
        return 1;
    }
    
    #if defined clothes_OnPlayerClickPlayerTextDraw
        return clothes_OnPlayerClickPlayerTextDraw(playerid, playertextid);
    #else
        return 0;
    #endif
}

// Вспомогательная функция для получения количества скинов
stock GetTotalClothingSkins(sex)
{
    new count = 0;
    for(new i = 0; i < MAX_CLOTHING_SKINS; i++)
    {
        if(g_business_clothing_skins[sex][i][0] != 0)
            count++;
        else
            break;
    }
    return count;
}

// Объявление для OnPlayerClickPlayerTextDraw
#if defined _ALS_OnPlayerClickPlayerTextDraw
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextDraw
#endif
#define OnPlayerClickPlayerTextDraw clothes_OnPlayerClickPlayerTextDraw
#if defined clothes_OnPlayerClickPlayerTextDraw
    forward clothes_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif