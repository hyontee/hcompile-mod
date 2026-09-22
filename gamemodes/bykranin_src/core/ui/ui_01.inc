//>> Файл: bykranin_src/core/ui/ui_01.inc  (368 строк)
//>> Тема: интерфейс: текстдравы, панели, уведомления, меню
//>> Внутри: BuyDonateCar, FixBugMoneyMinus, CreateAutosalonTextDraws, HideAutosalonTextDraws, CreateTDAutosalon, CreateBusinessMenuTextDraws, HideBusinessMenuTextDraws
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock BuyDonateCar(playerid)
{
    new text[700];


	format
	(
		text, sizeof text,
		""c_s"1) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"2) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"3) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"4) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"5) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"6) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"7) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"8) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"9) "c_b"%s (ID: %d) Цена: %d DONATE_RUB\n\
		"c_s"10) "c_b"%s (ID: %d) Цена: %d DONATE_RUB",
		GetVehicleInfo(DONATE_CAR_ID_1, VI_NAME),
		DONATE_CAR_ID_1,
		DONATE_CAR_PRICE_1,
		GetVehicleInfo(DONATE_CAR_ID_2, VI_NAME),
		DONATE_CAR_ID_2,
		DONATE_CAR_PRICE_2,
		GetVehicleInfo(DONATE_CAR_ID_3, VI_NAME),
		DONATE_CAR_ID_3,
		DONATE_CAR_PRICE_3,
		GetVehicleInfo(DONATE_CAR_ID_4, VI_NAME),
		DONATE_CAR_ID_4,
		DONATE_CAR_PRICE_4,
		GetVehicleInfo(DONATE_CAR_ID_5, VI_NAME),
		DONATE_CAR_ID_5,
		DONATE_CAR_PRICE_5,
		GetVehicleInfo(DONATE_CAR_ID_6, VI_NAME),
		DONATE_CAR_ID_6,
		DONATE_CAR_PRICE_6,
		GetVehicleInfo(DONATE_CAR_ID_7, VI_NAME),
		DONATE_CAR_ID_7,
		DONATE_CAR_PRICE_7,
		GetVehicleInfo(DONATE_CAR_ID_8, VI_NAME),
		DONATE_CAR_ID_8,
		DONATE_CAR_PRICE_8,
		GetVehicleInfo(DONATE_CAR_ID_9, VI_NAME),
		DONATE_CAR_ID_9,
		DONATE_CAR_PRICE_9,
		GetVehicleInfo(DONATE_CAR_ID_10, VI_NAME),
		DONATE_CAR_ID_10,
		DONATE_CAR_PRICE_10
	);

	Dialog(playerid, DIALOG_BUY_DONATE_CAR, DIALOG_STYLE_LIST, "Покупка транспорта", text, "Купить", "Закрыть");
}

stock FixBugMoneyMinus(playerid)
{
	new money = GetPlayerData(playerid, P_MONEY);
	
	if(GetPlayerMoneyEx(playerid) < 0)
	{
		SendClientMessage(playerid,-1, "Ваш баланс выведен из минуса");
		
		SetPlayerData(playerid, P_MONEY, 2000000000);
		UpdatePlayerDatabaseInt(playerid, "money", 2000000000);
		GivePlayerMoney(playerid, money);

	}
	
	if(GetPlayerData(playerid, P_BANK) < 0)
	{
        SetPlayerData(playerid, P_BANK, 2000000000);
	    UpdatePlayerDatabaseInt(playerid, "bank", 2000000000);
	    SendClientMessage(playerid,-1, "Ваш баланс банка выведен из минуса");
	
	}
}
stock CreateAutosalonTextDraws(playerid)
{
    for(new idx; idx < sizeof avtsln_TD; idx ++)
		TextDrawShowForPlayer(playerid, avtsln_TD[idx]);

	for(new idx; idx < sizeof avtsln_PTDD[]; idx ++)
		PlayerTextDrawShow(playerid, avtsln_PTDD[playerid][idx]);

	SelectTextDraw(playerid, COR_SERVER);
	CallLocalFunction("BuyCarPTDUpdate", "i", playerid);

	return 1;
}
stock HideAutosalonTextDraws(playerid)
{
    for(new idx; idx < sizeof avtsln_PTDD[]; idx ++)
		PlayerTextDrawHide(playerid, avtsln_PTDD[playerid][idx]);

	for(new idx; idx < sizeof avtsln_TD; idx ++)
		TextDrawHideForPlayer(playerid, avtsln_TD[idx]);

    CancelSelectTextDraw(playerid);
}
stock CreateTDAutosalon(playerid)
{
	/*autosalon_select_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 297.1998, 399.5642, "BMW_X5"); // generated
	PlayerTextDrawLetterSize(playerid, autosalon_select_PTD[playerid][0], 0.3619, 1.2017);
	PlayerTextDrawAlignment(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, autosalon_select_PTD[playerid][0], -2139062017);
	PlayerTextDrawBackgroundColor(playerid, autosalon_select_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, autosalon_select_PTD[playerid][0], 0);


	autosalon_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 89.6000, 214.3911, "25000000_P"); // пусто
	PlayerTextDrawLetterSize(playerid, autosalon_price_PTD[playerid][0], 0.3615, 1.4805);
	PlayerTextDrawTextSize(playerid, autosalon_price_PTD[playerid][0], -20.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, autosalon_price_PTD[playerid][0], 8388863);
	PlayerTextDrawBackgroundColor(playerid, autosalon_price_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, autosalon_price_PTD[playerid][0], 0);*/

}

stock CreateBusinessMenuTextDraws(playerid)
{
    new fmt_str[80];
	new fmt_text[80];
	new string[80];
	new businessid = GetPlayerBusiness(playerid);

	SelectTextDraw(playerid, COR_SERVER);

	CreateTDBusinessMenu(playerid);

	for(new idx; idx < sizeof business_menu_TD; idx ++)
		TextDrawShowForPlayer(playerid, business_menu_TD[idx]);


    for(new idx; idx < sizeof business_menu_PTD[]; idx ++)
		PlayerTextDrawShow(playerid, business_menu_PTD[playerid][idx]);


    format(fmt_str, sizeof fmt_str, "%s", GetBusinessInteriorInfo(GetBusinessData(businessid, B_INTERIOR), BT_NAME));
	PlayerTextDrawSetString(playerid, business_menu_PTD[playerid][0], fmt_str);
	
	format(fmt_str, sizeof fmt_str, "%s", GetBusinessData(businessid, B_OWNER_NAME));
	PlayerTextDrawSetString(playerid, business_menu_PTD[playerid][1], fmt_str);
	
	format(string, sizeof string, "%dP", GetBusinessData(businessid, B_PRICE));
	PlayerTextDrawSetString(playerid, business_menu_PTD[playerid][2], string);
	
	format(fmt_text, sizeof fmt_text, "%dP", 5000);
	PlayerTextDrawSetString(playerid, business_menu_PTD[playerid][3], fmt_text);

	return 1;
}

stock HideBusinessMenuTextDraws(playerid)
{
	for(new idx; idx < sizeof business_menu_TD; idx ++)
		TextDrawHideForPlayer(playerid, business_menu_TD[idx]);

    for(new idx; idx < sizeof business_menu_PTD[]; idx ++)
		PlayerTextDrawHide(playerid, business_menu_PTD[playerid][idx]);

    CancelSelectTextDraw(playerid);

}

stock CreateTDBusinessMenu(playerid)
{
    business_menu_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 205.1999, 144.7021, "Business_Name"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][0], 0.2031, 1.2167);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][0], -16776961);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][0], 0);

	business_menu_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 205.1999, 189.5022, "Jackson_Vendetta"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][1], 0.1951, 1.4257);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][1], -16776961);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][1], 0);

	business_menu_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 206.4000, 235.2977, "100000000$"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][2], 0.2627, 1.5552);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][2], 8388863);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][2], 0);

	business_menu_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 209.1999, 282.5866, "50000$"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][3], 0.2643, 1.4855);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][3], 8388863);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][3], 0);
}

stock CreateClothesShopTextDraws(playerid)
{

	SelectTextDraw(playerid, COR_SERVER);

	CreateTDClothesShop(playerid);

	for(new idx; idx < sizeof shop_clothes_TD; idx ++)
		TextDrawShowForPlayer(playerid, shop_clothes_TD[idx]);


 //   for(new idx; idx < sizeof shop_clothes_PTD[]; idx ++)
//		PlayerTextDrawShow(playerid, shop_clothes_PTD[playerid][idx]);
		

    PlayerTextDrawShow(playerid, shop_clothes_PTD[playerid][0]);
 //   PlayerTextDrawShow(playerid, shop_clothes_PTD[playerid][0]);



	return 1;
}

stock HideClothesShopTextDraws(playerid)
{
	for(new idx; idx < sizeof shop_clothes_TD; idx ++)
		TextDrawHideForPlayer(playerid, shop_clothes_TD[idx]);

 //   for(new idx; idx < sizeof shop_clothes_PTD[]; idx ++)
//		PlayerTextDrawHide(playerid, shop_clothes_PTD[playerid][idx]);
		
    //PlayerTextDrawHide(playerid, shop_clothes_PTD[playerid][0]);
    PlayerTextDrawHide(playerid, shop_clothes_PTD[playerid][0]);

    CancelSelectTextDraw(playerid);

}

stock CreateTDClothesShop(playerid)
{
	if(shop_clothes_PTD[playerid][0] != PlayerText: -1)
		PlayerTextDrawDestroy(playerid, shop_clothes_PTD[playerid][0]);

	shop_clothes_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 75.5999, 208.9155, ""); // generated
	PlayerTextDrawLetterSize(playerid, shop_clothes_PTD[playerid][0], 0.4000, 1.6000);
	PlayerTextDrawAlignment(playerid, shop_clothes_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, shop_clothes_PTD[playerid][0], 8388863);
	PlayerTextDrawBackgroundColor(playerid, shop_clothes_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, shop_clothes_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, shop_clothes_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, shop_clothes_PTD[playerid][0], 0);

}
//================================[тест команды]==============
CMD:shop(playerid)
{
    ShowPlayerClothingShopPanel(playerid);
    
    return 1;
}

CMD:speed0(playerid)
{
    //SetPlayerData(playerid, P_SPEEDOMETR, 0);
	UpdatePlayerDatabaseInt(playerid, "speedometr", 0);
}

CMD:bizid(playerid)
{
    new query[70];
    format(query, sizeof query, "[Информация]: "c_b"%d", GetPlayerData(playerid,P_IN_BUSINESS));
	SendClientMessage(playerid, COR_SERVER, query);
	return 1;
}

CMD:skinid(playerid)
{
    new query[70];
    format(query, sizeof query, "[Информация]: "c_b"%d", GetPlayerSelectSkin(playerid));
	SendClientMessage(playerid, COR_SERVER, query);
	return 1;
}

//==============================================================

stock CreateBuyCarNumberTextDraws(playerid)
{

	SelectTextDraw(playerid, COR_SERVER);

	CreateTDBuyCarNumber(playerid);

	for(new idx; idx < sizeof buy_car_number_TD; idx ++)
		TextDrawShowForPlayer(playerid, buy_car_number_TD[idx]);


    for(new idx; idx < sizeof buy_car_number_PTD[]; idx ++)
		PlayerTextDrawShow(playerid, buy_car_number_PTD[playerid][idx]);
		
    TextDrawHideForPlayer(playerid, buy_car_number_TD[1]); //rus
    TextDrawHideForPlayer(playerid, buy_car_number_TD[10]); //kz
    TextDrawHideForPlayer(playerid, buy_car_number_TD[12]); //ua
    TextDrawHideForPlayer(playerid, buy_car_number_TD[13]); //by

	return 1;
}

stock HideBuyCarNumberTextDraws(playerid)
{
	for(new idx; idx < sizeof buy_car_number_TD; idx ++)
		TextDrawHideForPlayer(playerid, buy_car_number_TD[idx]);

    for(new idx; idx < sizeof buy_car_number_PTD[]; idx ++)
		PlayerTextDrawHide(playerid, buy_car_number_PTD[playerid][idx]);


    CancelSelectTextDraw(playerid);

}

stock CreateTDBuyCarNumber(playerid)
{
    buy_car_number_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 214.3997, 197.4667, ""); // generated
	PlayerTextDrawLetterSize(playerid, buy_car_number_PTD[playerid][0], 1.0231, 5.7761);
	PlayerTextDrawAlignment(playerid, buy_car_number_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, buy_car_number_PTD[playerid][0], -1378294017);
	PlayerTextDrawBackgroundColor(playerid, buy_car_number_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, buy_car_number_PTD[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, buy_car_number_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, buy_car_number_PTD[playerid][0], 0);

	buy_car_number_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 585.2005, 203.9378, ""); // generated
	PlayerTextDrawLetterSize(playerid, buy_car_number_PTD[playerid][1], 0.4338, 2.0878);
	PlayerTextDrawAlignment(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, buy_car_number_PTD[playerid][1], 16711935);
	PlayerTextDrawBackgroundColor(playerid, buy_car_number_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, buy_car_number_PTD[playerid][1], 0);

}

/*stock CreateLogo(playerid)
{
	logo_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 79.1998, 430.4266, "1/1000"); // generated
	PlayerTextDrawLetterSize(playerid, logo_PTD[playerid][1], 0.2107, 1.0325);
	PlayerTextDrawAlignment(playerid, logo_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, logo_PTD[playerid][1], -1061109505);
	PlayerTextDrawBackgroundColor(playerid, logo_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, logo_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, logo_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, logo_PTD[playerid][1], 0);
	
	for(new idx; idx < sizeof logo_TD; idx ++)
		TextDrawShowForPlayer(playerid, logo_TD[idx]);
		
    for(new idx; idx < sizeof logo_PTD[]; idx ++)
		PlayerTextDrawShow(playerid, logo_PTD[playerid][idx]);
}*/

