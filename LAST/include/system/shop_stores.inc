// Магазин одежды и аксессуаров (Black Russia style, TextDraw UI)
#if defined _SHOP_STORES_INC
	#endinput
#endif
#define _SHOP_STORES_INC

forward Shop247_OnExitBiz(playerid);
forward Player_FixInteriorWorldLeak(playerid);
forward Biz_GetInteriorVW(businessid);

#define SHOP_STATE_NONE      (0)
#define SHOP_STATE_CLOTHING  (1)
#define SHOP_STATE_ACCESSORY (2)

#define SHOP_CLOTHING_SKIN_ROWS (56)

#if !defined DIALOG_BIZ_CLOTHING_BUY
	#define DIALOG_BIZ_CLOTHING_BUY (19400)
#endif
#if !defined DIALOG_BIZ_ACCESSORY_BUY
	#define DIALOG_BIZ_ACCESSORY_BUY (19401)
#endif

enum E_SHOP_ACCESSORY_CAT
{
	SA_ITEM_ID,
	SA_PRICE,
	SA_NAME[40]
};

// Популярные аксессуары (item_id из inventory, цены как в BR)
static const g_shop_accessory_catalog[][E_SHOP_ACCESSORY_CAT] =
{
	{2,   300000, "Рюкзак классический"},
	{25,  250000, "Сумка спорт"},
	{28,  500000, "Рюкзак премиум"},
	{30,  900000, "Рюкзак стильный"},
	{66,  700000, "Очки солнцезащитные"},
	{135, 5000000, "Рюкзак FnaF"},
	{141, 300000, "Шляпа"},
	{262, 500000, "Маска светящаяся"},
	{705, 300000, "Рюкзак Nike-стиль"},
	{706, 300000, "Очки дизайнер"},
	{135, 12000000, "Рюкзак инопланетянин"},
	{136, 2000000, "Шляпа ведьмы"},
	{137, 2000000, "Шляпа ведьмы (2)"},
	{138, 2000000, "Шляпа звезды"},
	{139, 2500000, "Красная шляпа ведьмы"},
	{145, 500000, "Маска маньяка"},
	{146, 500000, "Плачущая маска"},
	{147, 700000, "Страшная маска"},
	{151, 3000000, "Маска ведущего"},
	{163, 300000, "Кепка"},
	{164, 300000, "Кепка 2"},
	{165, 400000, "Шляпа №1"},
	{166, 450000, "Шляпа №2"},
	{167, 500000, "Шляпа №4"},
	{168, 500000, "Шляпа №5"},
	{169, 350000, "Синяя шапка"},
	{170, 8000000, "Зонт разноцветный"},
	{171, 5000000, "Кожаный кейс"},
	{172, 10000000, "Кейс (2)"},
	{173, 12000000, "Черный кейс"},
	{174, 5000000, "Маска петуха"},
	{175, 5000000, "Маска голубя"},
	{176, 4000000, "Маска медведя"},
	{177, 1000000, "Катана"},
	{178, 1000000, "Катана 2"},
	{268, 1500000, "Шляпа самурая №1"},
	{180, 1500000, "Шляпа самурая №2"},
	{181, 1500000, "Шляпа индейца"},
	{182, 500000, "Доска для серфинга №1"},
	{183, 500000, "Доска для серфинга №2"},
	{184, 750000, "Акула"},
	{185, 700000, "Гитара №1"},
	{186, 700000, "Гитара №2"},
	{187, 750000, "Скейт №1"},
	{188, 750000, "Скейт №2"},
	{189, 4000000, "Новогодний дракон"},
	{190, 7000000, "Маска дракона"},
	{191, 5000000, "Весёлая тыква"},
	{192, 3000000, "Хеллоуинские ночи"},
	{193, 5000000, "Кукла Вуду"},
	{194, 4000000, "Призрачный портал"},
	{195, 6000000, "Акула на голову"},
	{196, 5000000, "Рюкзак Мопс"},
	{197, 6000000, "Маска оленя"}
};

static const g_business_clothing_skins[2][SHOP_CLOTHING_SKIN_ROWS][2] =
{
	{
		{29, 5500}, {33, 9000}, {30, 14500}, {43, 17000}, {142, 18000}, {36, 20000},
		{7, 28000}, {47, 30000}, {37, 35000}, {44, 37000}, {97, 40000}, {66, 42000},
		{176, 44000}, {156, 45000}, {96, 50000}, {60, 55000}, {143, 60000}, {144, 65000},
		{181, 80000}, {101, 95000}, {67, 100000}, {177, 100000}, {128, 110000}, {123, 120000},
		{127, 130000}, {153, 140000}, {180, 150000}, {189, 230000}, {182, 250000}, {183, 270000},
		{146, 300000}, {247, 320000}, {185, 350000}, {240, 600000}, {242, 800000}, {248, 1000000},
		{241, 1400000}, {120, 1500000}, {222, 2500000}, {221, 2800000}, {250, 3000000}, {217, 3200000},
		{98, 3300000}, {81, 3400000}, {126, 3500000}, {223, 3900000}, {80, 4000000}, {213, 4500000},
		{82, 5000000}, {125, 5000000}, {124, 6500000}, {83, 7000000}, {203, 7100000}, {121, 7300000},
		{84, 7500000}, {118, 10000000}
	},
	{
		{40, 4000}, {12, 8000}, {131, 25000}, {56, 30000}, {85, 50000}, {87, 70000},
		{246, 100000}, {178, 180000}, {219, 190000}, {55, 200000}, {152, 250000}, {169, 270000},
		{194, 320000}, {75, 500000}, {201, 550000}, {11, 600000}, {244, 650000}, {215, 700000},
		{211, 850000}, {216, 900000}, {237, 1100000}, {233, 1500000}, {238, 1700000}, {214, 2000000},
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0},
		{0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}, {0, 0}
	}
};

// Общая BR-панель: <<< | [КУПИТЬ | ВЫХОД | ЦЕНА] | >>>
#define SHOP_TD_COUNT           (13)
#define SHOP_TD_BTN_NEXT        (4)
#define SHOP_TD_BTN_PREV        (7)
#define SHOP_TD_BTN_BUY         (11)
#define SHOP_TD_BTN_EXIT        (12)

new Text:g_shop_br_TD[SHOP_TD_COUNT];
new PlayerText:g_shop_price_PTD[MAX_PLAYERS];
new g_shop_state[MAX_PLAYERS];
new g_shop_select_idx[MAX_PLAYERS];
new g_shop_preview_obj[MAX_PLAYERS];
new g_shop_saved_skin[MAX_PLAYERS];

#define SHOP_BR_BOX (-1607587841)

stock Shop_GetPlayerSexIndex(playerid)
{
	new skinid = Player[playerid][pSkin];
	switch(skinid)
	{
		case 9..17, 20..38, 55, 56, 69, 76..90, 93: return 1;
	}
	return 0;
}

stock Shop_Clothing_Count(sex)
{
	new count;
	for(new i; i < SHOP_CLOTHING_SKIN_ROWS; i++)
	{
		if(g_business_clothing_skins[sex][i][0] > 0) count++;
	}
	return count;
}

stock Shop_Clothing_GetSkin(sex, index, &skinid, &price)
{
	new seen;
	for(new i; i < SHOP_CLOTHING_SKIN_ROWS; i++)
	{
		if(g_business_clothing_skins[sex][i][0] <= 0) continue;
		if(seen == index)
		{
			skinid = g_business_clothing_skins[sex][i][0];
			price = g_business_clothing_skins[sex][i][1];
			return 1;
		}
		seen++;
	}
	return 0;
}

stock Shop_Accessory_Count()
{
	return sizeof g_shop_accessory_catalog;
}

stock Shop_IsInShop(playerid)
{
	return (g_shop_state[playerid] != SHOP_STATE_NONE);
}

stock Shop_DestroyPreview(playerid)
{
	if(g_shop_preview_obj[playerid] != INVALID_OBJECT_ID)
	{
		if(IsPlayerConnected(playerid)) DestroyPlayerObject(playerid, g_shop_preview_obj[playerid]);
		g_shop_preview_obj[playerid] = INVALID_OBJECT_ID;
	}
}

stock Shop_HideAllTextDraws(playerid)
{
	if(Shop_IsInShop(playerid))
	{
		for(new i; i < SHOP_TD_COUNT; i++)
			TextDrawHideForPlayer(playerid, g_shop_br_TD[i]);
	}
	if(g_shop_price_PTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid, g_shop_price_PTD[playerid]);
		g_shop_price_PTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
	CancelSelectTextDraw(playerid);
}

stock Shop_UpdatePricePTD(playerid)
{
	new fmt_str[48], price;
	if(g_shop_state[playerid] == SHOP_STATE_CLOTHING)
	{
		new skinid;
		if(!Shop_Clothing_GetSkin(Shop_GetPlayerSexIndex(playerid), g_shop_select_idx[playerid], skinid, price))
			price = 0;
	}
	else if(g_shop_state[playerid] == SHOP_STATE_ACCESSORY)
	{
		new idx = g_shop_select_idx[playerid];
		if(0 <= idx < sizeof g_shop_accessory_catalog)
			price = g_shop_accessory_catalog[idx][SA_PRICE];
		else price = 0;
	}
	else return;

	if(g_shop_price_PTD[playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		g_shop_price_PTD[playerid] = CreatePlayerTextDraw(playerid, 309.4163, 406.8438, "ЦЕНА:0");
		PlayerTextDrawLetterSize(playerid, g_shop_price_PTD[playerid], 0.1466, 0.9860);
		PlayerTextDrawAlignment(playerid, g_shop_price_PTD[playerid], 2);
		PlayerTextDrawColor(playerid, g_shop_price_PTD[playerid], 0x80FFFFFF);
		PlayerTextDrawBackgroundColor(playerid, g_shop_price_PTD[playerid], 255);
		PlayerTextDrawFont(playerid, g_shop_price_PTD[playerid], 1);
		PlayerTextDrawSetProportional(playerid, g_shop_price_PTD[playerid], 1);
		PlayerTextDrawSetShadow(playerid, g_shop_price_PTD[playerid], 0);
	}
	format(fmt_str, sizeof fmt_str, "ЦЕНА: %d", price);
	PlayerTextDrawSetString(playerid, g_shop_price_PTD[playerid], fmt_str);
	PlayerTextDrawShow(playerid, g_shop_price_PTD[playerid]);
}

stock Shop_Clothing_ApplyPreview(playerid)
{
	new skinid, price;
	if(!Shop_Clothing_GetSkin(Shop_GetPlayerSexIndex(playerid), g_shop_select_idx[playerid], skinid, price)) return;
	SetPlayerSkin(playerid, skinid);
	Shop_UpdatePricePTD(playerid);
}

stock Shop_Accessory_ApplyPreview(playerid)
{
	new idx = g_shop_select_idx[playerid];
	if(idx < 0 || idx >= sizeof g_shop_accessory_catalog) return;

	new item_id = g_shop_accessory_catalog[idx][SA_ITEM_ID];
	new model = IsItemAccessory(item_id);
	if(model <= 0) return;

	Shop_DestroyPreview(playerid);
	new Float:px = 2289.10, Float:py = 1503.38, Float:pz = 2499.06;
	g_shop_preview_obj[playerid] = CreatePlayerObject(playerid, model, px, py, pz, 0.0, 0.0, 0.0);
	Shop_UpdatePricePTD(playerid);
}

stock Shop_Clothing_Cycle(playerid, direction)
{
	new sex = Shop_GetPlayerSexIndex(playerid);
	new total = Shop_Clothing_Count(sex);
	if(total <= 0) return;

	if(direction > 0)
	{
		g_shop_select_idx[playerid]++;
		if(g_shop_select_idx[playerid] >= total) g_shop_select_idx[playerid] = 0;
	}
	else
	{
		g_shop_select_idx[playerid]--;
		if(g_shop_select_idx[playerid] < 0) g_shop_select_idx[playerid] = total - 1;
	}
	Shop_Clothing_ApplyPreview(playerid);
}

stock Shop_Accessory_Cycle(playerid, direction)
{
	new total = Shop_Accessory_Count();
	if(total <= 0) return;

	if(direction > 0)
	{
		g_shop_select_idx[playerid]++;
		if(g_shop_select_idx[playerid] >= total) g_shop_select_idx[playerid] = 0;
	}
	else
	{
		g_shop_select_idx[playerid]--;
		if(g_shop_select_idx[playerid] < 0) g_shop_select_idx[playerid] = total - 1;
	}
	Shop_Accessory_ApplyPreview(playerid);
}

stock Shop_Exit(playerid)
{
	new businessid = GetPlayerInBiz(playerid);
	new shop_mode = g_shop_state[playerid];

	Shop_HideAllTextDraws(playerid);
	Shop_DestroyPreview(playerid);

	if(shop_mode == SHOP_STATE_CLOTHING)
		SetPlayerSkin(playerid, g_shop_saved_skin[playerid]);

	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);
	g_shop_state[playerid] = SHOP_STATE_NONE;
	g_shop_select_idx[playerid] = 0;

	if(businessid != -1)
	{
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetPlayerPos(playerid,
			GetBusinessData(businessid, B_EXIT_POS_X),
			GetBusinessData(businessid, B_EXIT_POS_Y),
			GetBusinessData(businessid, B_EXIT_POS_Z));
		SetPlayerFacingAngle(playerid, GetBusinessData(businessid, B_EXIT_ANGLE));
		SetPlayerInBiz(playerid, -1);
		Shop247_OnExitBiz(playerid);
		Player_FixInteriorWorldLeak(playerid);
	}
}

stock Shop_ShowBRPanel(playerid)
{
	for(new i; i < SHOP_TD_COUNT; i++)
		TextDrawShowForPlayer(playerid, g_shop_br_TD[i]);
	SelectTextDraw(playerid, 0xFF5252FF);
	Shop_UpdatePricePTD(playerid);
}

stock Shop_ShowClothingUI(playerid)
{
	Shop_ShowBRPanel(playerid);
}

stock Shop_ShowAccessoryUI(playerid)
{
	Shop_ShowBRPanel(playerid);
}

stock Shop_Clothing_Open(playerid)
{
	if(Shop_IsInShop(playerid)) return 0;
	if(Player[playerid][pFamilyId] > 0)
	{
		SendClientMessage(playerid, 0xCECECEFF, "Вы состоите в организации — покупка внешности недоступна.");
		return 0;
	}

	new businessid = GetPlayerInBiz(playerid);
	if(businessid == -1) return 0;

	g_shop_saved_skin[playerid] = Player[playerid][pSkin];
	g_shop_state[playerid] = SHOP_STATE_CLOTHING;
	g_shop_select_idx[playerid] = 0;

	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, Biz_GetInteriorVW(businessid));
	SetPlayerPos(playerid, 1200.3999, 607.8763, 1349.3094);
	SetPlayerFacingAngle(playerid, 184.8244);
	SetPlayerCameraPos(playerid, 1201.5103, 604.7383, 1350.5304);
	SetPlayerCameraLookAt(playerid, 1193.9103, 630.0, 1342.5304);
	TogglePlayerControllable(playerid, false);

	Shop_Clothing_ApplyPreview(playerid);
	Shop_ShowClothingUI(playerid);
	return 1;
}

stock Shop_Accessory_Open(playerid)
{
	if(Shop_IsInShop(playerid)) return 0;

	new businessid = GetPlayerInBiz(playerid);
	if(businessid == -1) return 0;

	new Float:px, Float:py, Float:pz, Float:pa;
	if(!GetLairdBizDefaultCoords(BUSINESS_TYPE_ACCESSORY_SHOP, px, py, pz, pa))
	{
		px = 2286.0; py = 1837.0; pz = 1521.0; pa = 180.0;
	}

	g_shop_state[playerid] = SHOP_STATE_ACCESSORY;
	g_shop_select_idx[playerid] = 0;

	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, Biz_GetInteriorVW(businessid));
	SetPlayerPos(playerid, px, py, pz);
	SetPlayerFacingAngle(playerid, pa);
	InterpolateCameraPos(playerid, px + 15.0, py + 1.0, pz, px + 14.0, py + 3.0, pz + 0.02, 2000, CAMERA_MOVE);
	InterpolateCameraLookAt(playerid, px + 3.0, py, pz, px + 3.0, py + 3.0, pz + 0.2, 2000, CAMERA_MOVE);
	TogglePlayerControllable(playerid, false);

	Shop_Accessory_ApplyPreview(playerid);
	Shop_ShowAccessoryUI(playerid);
	return 1;
}

stock bool:Shop_TryEnterBusiness(playerid, businessid)
{
	new btype = GetBusinessData(businessid, B_TYPE);
	if(btype == BUSINESS_TYPE_CLOTHING_SHOP)
	{
		SetPlayerInBiz(playerid, businessid);
		Shop_Clothing_Open(playerid);
		return true;
	}
	if(btype == BUSINESS_TYPE_ACCESSORY_SHOP)
	{
		SetPlayerInBiz(playerid, businessid);
		Shop_Accessory_Open(playerid);
		return true;
	}
	return false;
}

stock bool:ShopStores_OnClickTextDraw(playerid, Text:clickedid)
{
	if(!Shop_IsInShop(playerid)) return false;

	if(g_shop_state[playerid] == SHOP_STATE_CLOTHING)
	{
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_NEXT]) { Shop_Clothing_Cycle(playerid, 1); return true; }
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_PREV]) { Shop_Clothing_Cycle(playerid, -1); return true; }
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_BUY])
		{
			ShowPlayerDialog(playerid, DIALOG_BIZ_CLOTHING_BUY, DIALOG_STYLE_MSGBOX,
				PROJECT_BRAND_DLG_SEP "Магазин одежды",
				"{FFFFFF}Вы действительно хотите приобрести этот образ?",
				"Купить", "Отмена");
			return true;
		}
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_EXIT]) { Shop_Exit(playerid); return true; }
	}
	else if(g_shop_state[playerid] == SHOP_STATE_ACCESSORY)
	{
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_NEXT]) { Shop_Accessory_Cycle(playerid, 1); return true; }
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_PREV]) { Shop_Accessory_Cycle(playerid, -1); return true; }
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_BUY])
		{
			ShowPlayerDialog(playerid, DIALOG_BIZ_ACCESSORY_BUY, DIALOG_STYLE_MSGBOX,
				PROJECT_BRAND_DLG_SEP "Магазин аксессуаров",
				"{FFFFFF}Вы действительно хотите купить этот аксессуар?",
				"Купить", "Отмена");
			return true;
		}
		if(clickedid == g_shop_br_TD[SHOP_TD_BTN_EXIT]) { Shop_Exit(playerid); return true; }
	}

	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		Shop_Exit(playerid);
		return true;
	}
	return false;
}

stock bool:ShopStores_OnDialogResponse(playerid, dialogid, response)
{
	if(dialogid == DIALOG_BIZ_CLOTHING_BUY)
	{
		if(!response) return true;
		new businessid = GetPlayerInBiz(playerid);
		if(businessid == -1 || g_shop_state[playerid] != SHOP_STATE_CLOTHING) return true;

		new skinid, price;
		if(!Shop_Clothing_GetSkin(Shop_GetPlayerSexIndex(playerid), g_shop_select_idx[playerid], skinid, price))
			return SendClientMessage(playerid, 0x999999FF, "Не удалось определить выбранный образ."), true;

		if(GetPlayerMoneyEx(playerid) < price)
			return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег."), true;

		if(!GivePlayerSkin(playerid, skinid))
			return SendClientMessage(playerid, 0x999999FF, "Инвентарь полон — освободите место для одежды."), true;

		new take_prods = random(6) + 2;
		new biz_share = price * 20 / 100;
		GivePlayerMoneyEx(playerid, -price);
		if(GetBusinessData(businessid, B_PRODS) >= take_prods)
		{
			AddBusinessData(businessid, B_PRODS, -, take_prods);
			AddBusinessData(businessid, B_BALANCE, +, biz_share);
		}
		Biz_LogProfit(GetBusinessData(businessid, B_SQL_ID), playerid, price, _:IsBusinessOwned(businessid));
		Biz_SaveBusinessRow(businessid);

		SendClientMessage(playerid, 0x66CC00FF, "Поздравляем с покупкой! Одежда добавлена в инвентарь.");
		Shop_Exit(playerid);
		return true;
	}

	if(dialogid == DIALOG_BIZ_ACCESSORY_BUY)
	{
		if(!response) return true;
		new businessid = GetPlayerInBiz(playerid);
		if(businessid == -1 || g_shop_state[playerid] != SHOP_STATE_ACCESSORY) return true;

		new idx = g_shop_select_idx[playerid];
		if(idx < 0 || idx >= sizeof g_shop_accessory_catalog)
			return true;

		new item_id = g_shop_accessory_catalog[idx][SA_ITEM_ID];
		new price = g_shop_accessory_catalog[idx][SA_PRICE];

		if(GetPlayerMoneyEx(playerid) < price)
			return SendClientMessage(playerid, 0x999999FF, "Недостаточно денег."), true;

		if(!GivePlayerItem(playerid, item_id, 1))
			return SendClientMessage(playerid, 0x999999FF, "Инвентарь полон."), true;

		new take_prods = random(4) + 1;
		new biz_share = price * 20 / 100;
		GivePlayerMoneyEx(playerid, -price);
		if(GetBusinessData(businessid, B_PRODS) >= take_prods)
		{
			AddBusinessData(businessid, B_PRODS, -, take_prods);
			AddBusinessData(businessid, B_BALANCE, +, biz_share);
		}
		Biz_LogProfit(GetBusinessData(businessid, B_SQL_ID), playerid, price, _:IsBusinessOwned(businessid));
		Biz_SaveBusinessRow(businessid);

		new msg[96];
		format(msg, sizeof msg, "Вы купили: %s", g_shop_accessory_catalog[idx][SA_NAME]);
		SendClientMessage(playerid, 0x66CC00FF, msg);
		Shop_Exit(playerid);
		return true;
	}
	return false;
}

stock ShopStores_CreateBRPanelTD()
{
	// Правая красная колонка >>>
	g_shop_br_TD[0] = TextDrawCreate(579.1665, 374.5928, "_");
	TextDrawLetterSize(g_shop_br_TD[0], 0.0087, 4.5451);
	TextDrawTextSize(g_shop_br_TD[0], 615.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[0], 1);
	TextDrawUseBox(g_shop_br_TD[0], 1);
	TextDrawBoxColor(g_shop_br_TD[0], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[0], 1);

	g_shop_br_TD[1] = TextDrawCreate(580.8331, 374.5928, "_");
	TextDrawLetterSize(g_shop_br_TD[1], 0.0170, 0.9518);
	TextDrawTextSize(g_shop_br_TD[1], 614.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[1], 1);
	TextDrawUseBox(g_shop_br_TD[1], 1);
	TextDrawBoxColor(g_shop_br_TD[1], 255);
	TextDrawFont(g_shop_br_TD[1], 1);

	g_shop_br_TD[2] = TextDrawCreate(580.4165, 405.7038, "_");
	TextDrawLetterSize(g_shop_br_TD[2], 0.0170, 0.9518);
	TextDrawTextSize(g_shop_br_TD[2], 614.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[2], 1);
	TextDrawUseBox(g_shop_br_TD[2], 1);
	TextDrawBoxColor(g_shop_br_TD[2], 255);
	TextDrawFont(g_shop_br_TD[2], 1);

	// Левая красная колонка <<<
	g_shop_br_TD[3] = TextDrawCreate(31.6666, 374.5927, "_");
	TextDrawLetterSize(g_shop_br_TD[3], 0.0087, 4.5451);
	TextDrawTextSize(g_shop_br_TD[3], 68.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[3], 1);
	TextDrawUseBox(g_shop_br_TD[3], 1);
	TextDrawBoxColor(g_shop_br_TD[3], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[3], 1);

	g_shop_br_TD[SHOP_TD_BTN_NEXT] = TextDrawCreate(584.9999, 388.0742, ">>>");
	TextDrawLetterSize(g_shop_br_TD[SHOP_TD_BTN_NEXT], 0.4053, 1.5273);
	TextDrawTextSize(g_shop_br_TD[SHOP_TD_BTN_NEXT], 609.0000, 80.0000);
	TextDrawAlignment(g_shop_br_TD[SHOP_TD_BTN_NEXT], 1);
	TextDrawColor(g_shop_br_TD[SHOP_TD_BTN_NEXT], -1);
	TextDrawUseBox(g_shop_br_TD[SHOP_TD_BTN_NEXT], 1);
	TextDrawBoxColor(g_shop_br_TD[SHOP_TD_BTN_NEXT], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[SHOP_TD_BTN_NEXT], 1);
	TextDrawSetSelectable(g_shop_br_TD[SHOP_TD_BTN_NEXT], true);

	g_shop_br_TD[5] = TextDrawCreate(33.3333, 374.5927, "_");
	TextDrawLetterSize(g_shop_br_TD[5], 0.0170, 0.9518);
	TextDrawTextSize(g_shop_br_TD[5], 67.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[5], 1);
	TextDrawUseBox(g_shop_br_TD[5], 1);
	TextDrawBoxColor(g_shop_br_TD[5], 255);
	TextDrawFont(g_shop_br_TD[5], 1);

	g_shop_br_TD[6] = TextDrawCreate(32.9166, 405.7038, "_");
	TextDrawLetterSize(g_shop_br_TD[6], 0.0170, 0.9518);
	TextDrawTextSize(g_shop_br_TD[6], 67.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[6], 1);
	TextDrawUseBox(g_shop_br_TD[6], 1);
	TextDrawBoxColor(g_shop_br_TD[6], 255);
	TextDrawFont(g_shop_br_TD[6], 1);

	g_shop_br_TD[SHOP_TD_BTN_PREV] = TextDrawCreate(37.9166, 388.0742, "<<<");
	TextDrawLetterSize(g_shop_br_TD[SHOP_TD_BTN_PREV], 0.3999, 1.4858);
	TextDrawTextSize(g_shop_br_TD[SHOP_TD_BTN_PREV], 64.0000, 80.0000);
	TextDrawAlignment(g_shop_br_TD[SHOP_TD_BTN_PREV], 1);
	TextDrawColor(g_shop_br_TD[SHOP_TD_BTN_PREV], -1);
	TextDrawUseBox(g_shop_br_TD[SHOP_TD_BTN_PREV], 1);
	TextDrawBoxColor(g_shop_br_TD[SHOP_TD_BTN_PREV], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[SHOP_TD_BTN_PREV], 1);
	TextDrawSetSelectable(g_shop_br_TD[SHOP_TD_BTN_PREV], true);

	// Центральная панель: КУПИТЬ | ВЫХОД + полоса цены
	g_shop_br_TD[8] = TextDrawCreate(257.4165, 378.2438, "_");
	TextDrawLetterSize(g_shop_br_TD[8], 0.0447, 4.2666);
	TextDrawTextSize(g_shop_br_TD[8], 365.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[8], 1);
	TextDrawUseBox(g_shop_br_TD[8], 1);
	TextDrawBoxColor(g_shop_br_TD[8], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[8], 1);

	g_shop_br_TD[9] = TextDrawCreate(259.0829, 380.6067, "_");
	TextDrawLetterSize(g_shop_br_TD[9], 0.0501, 3.8134);
	TextDrawTextSize(g_shop_br_TD[9], 363.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[9], 1);
	TextDrawUseBox(g_shop_br_TD[9], 1);
	TextDrawBoxColor(g_shop_br_TD[9], 255);
	TextDrawFont(g_shop_br_TD[9], 1);

	g_shop_br_TD[10] = TextDrawCreate(258.2500, 388.2810, "_");
	TextDrawLetterSize(g_shop_br_TD[10], 0.0430, 1.8402);
	TextDrawTextSize(g_shop_br_TD[10], 364.0000, 0.0);
	TextDrawAlignment(g_shop_br_TD[10], 1);
	TextDrawUseBox(g_shop_br_TD[10], 1);
	TextDrawBoxColor(g_shop_br_TD[10], SHOP_BR_BOX);
	TextDrawFont(g_shop_br_TD[10], 1);

	g_shop_br_TD[SHOP_TD_BTN_BUY] = TextDrawCreate(260.1662, 391.0807, "КУПИТЬ");
	TextDrawLetterSize(g_shop_br_TD[SHOP_TD_BTN_BUY], 0.2261, 1.3370);
	TextDrawTextSize(g_shop_br_TD[SHOP_TD_BTN_BUY], 296.0000, 80.0000);
	TextDrawAlignment(g_shop_br_TD[SHOP_TD_BTN_BUY], 1);
	TextDrawColor(g_shop_br_TD[SHOP_TD_BTN_BUY], -1);
	TextDrawUseBox(g_shop_br_TD[SHOP_TD_BTN_BUY], 1);
	TextDrawBoxColor(g_shop_br_TD[SHOP_TD_BTN_BUY], 255);
	TextDrawFont(g_shop_br_TD[SHOP_TD_BTN_BUY], 2);
	TextDrawSetSelectable(g_shop_br_TD[SHOP_TD_BTN_BUY], true);

	g_shop_br_TD[SHOP_TD_BTN_EXIT] = TextDrawCreate(321.9993, 391.0805, "ВЫХОД");
	TextDrawLetterSize(g_shop_br_TD[SHOP_TD_BTN_EXIT], 0.2726, 1.3414);
	TextDrawTextSize(g_shop_br_TD[SHOP_TD_BTN_EXIT], 362.0000, 80.0000);
	TextDrawAlignment(g_shop_br_TD[SHOP_TD_BTN_EXIT], 1);
	TextDrawColor(g_shop_br_TD[SHOP_TD_BTN_EXIT], -1);
	TextDrawUseBox(g_shop_br_TD[SHOP_TD_BTN_EXIT], 1);
	TextDrawBoxColor(g_shop_br_TD[SHOP_TD_BTN_EXIT], 255);
	TextDrawFont(g_shop_br_TD[SHOP_TD_BTN_EXIT], 2);
	TextDrawSetSelectable(g_shop_br_TD[SHOP_TD_BTN_EXIT], true);

	return 1;
}

stock ShopStores_CreateGlobalTD()
{
	return ShopStores_CreateBRPanelTD();
}

stock ShopStores_OnGameModeInit()
{
	ShopStores_CreateGlobalTD();
	return 1;
}

stock ShopStores_OnPlayerConnect(playerid)
{
	g_shop_state[playerid] = SHOP_STATE_NONE;
	g_shop_select_idx[playerid] = 0;
	g_shop_preview_obj[playerid] = INVALID_OBJECT_ID;
	g_shop_price_PTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
	g_shop_saved_skin[playerid] = 0;
	return 1;
}

stock ShopStores_OnPlayerDisconnect(playerid)
{
	Shop_DestroyPreview(playerid);
	if(g_shop_price_PTD[playerid] != PlayerText:INVALID_TEXT_DRAW)
	{
		PlayerTextDrawDestroy(playerid, g_shop_price_PTD[playerid]);
		g_shop_price_PTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
	}
	g_shop_state[playerid] = SHOP_STATE_NONE;
	return 1;
}
