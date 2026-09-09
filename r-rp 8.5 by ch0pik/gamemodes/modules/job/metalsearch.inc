#define METAL_DETECTOR_ID       127
#define METAL_SCRAP_ID          27
#define METAL_SHOVEL_ID         125
#define METAL_BATTERY_ID        126

#define METAL_DETECTOR_PRICE    15000000
#define METAL_SHOVEL_PRICE      3000000
#define METAL_BATTERY_PRICE     500000
#define METAL_BOUGHT_PRICE      1500000

#define DIALOG_METALSHOP        9555
#define SEARCH_COOLDOWN         600
#define SEARCH_RADIUS           40.0
#define ACTIVATION_RADIUS       100.0

#define MAX_METAL_TREASURES     48

new pMetalSearchStatus[MAX_PLAYERS];
new Text3D:pAdminMetalLabels[MAX_PLAYERS][MAX_METAL_TREASURES];
new pMetalSearchCharge[MAX_PLAYERS];
new pSearchTimer[MAX_PLAYERS];
new Float:pSearchTarget[MAX_PLAYERS][3];
new pLastPointCollect[MAX_PLAYERS][MAX_METAL_TREASURES];
new pSearchTargetID[MAX_PLAYERS];
new pMetalSearchNotifyFlag[MAX_PLAYERS];

new Float:MetalTreasures[MAX_METAL_TREASURES][3] = {
	// Зона 1
	{-2616.2151, -126.6425, 14.6458},
	{-2618.7163, -151.3131, 17.4927},
	{-2587.6853, -132.5324, 14.4925},
	{-2572.9336, -143.9219, 15.1884},
	{-2572.6670, -149.1923, 15.9613},
	{-2576.6050, -167.7608, 19.2990},
	{-2561.9622, -182.5462, 22.2059},
	{-2577.0366, -200.9846, 26.0523},
	{-2598.9082, -214.1519, 27.4255},
	{-2605.9673, -237.6338, 29.7624},
	{-2584.4683, -250.1567, 32.1046},
	{-2558.3713, -246.5598, 34.2919},
	{-2521.9199, -233.7760, 34.2396},
	{-2476.0403, -214.2448, 28.7292},
	{-2443.7390, -233.8254, 31.4343},
	{-2408.6077, -223.6292, 25.1871},
	{-2384.5984, -213.2263, 21.7865},
	{-2370.7927, -246.9163, 25.0449},
	{-2379.9888, -269.8487, 28.9839},
	{-2406.2607, -319.4198, 38.7632},
	{-2427.6035, -325.6985, 39.6956},
	{-2456.4785, -341.7665, 41.4664},
	{-2511.9963, -352.2372, 37.6225},
	{-2534.7246, -367.4451, 33.8284},
	{-2525.3816, -384.9978, 33.4545},
	{-2482.8093, -394.1129, 36.2148},
	{-2460.5825, -380.7912, 38.6314},
	{-2421.2058, -381.4939, 39.6800},
	{-2397.1482, -373.0609, 40.8978},
	{-2361.4229, -340.5438, 35.1767},
	{-2334.2419, -313.8101, 27.0133},
	{-2323.7544, -341.9963, 27.3623},
	{-2331.3250, -365.4728, 32.7483},
	{-2344.3547, -382.5024, 38.4066},
	{-2358.4785, -415.8690, 41.6854},
	{-2366.1123, -444.2609, 39.8414},
	{-2386.1421, -467.9141, 39.4702},
	{-2411.0781, -470.3771, 38.8098},
	{-2445.1121, -456.1600, 36.1594},
	{-2480.6199, -458.8135, 32.1874},
	{-2453.8047, -474.6218, 34.5817},
	{-2447.4839, -484.2517, 35.0464},
	{-2429.1582, -483.9211, 37.1212},
	{-2413.9890, -473.5429, 38.5996},
	{-2400.4397, -458.0891, 39.3520},
	{-2374.0090, -459.5142, 39.4699},
	{-2364.9326, -443.8712, 39.8698},
	{-2319.6765, -423.5509, 38.2747}
};

stock ShowMetalShop(playerid)
{
	new szShop[1024];
	format(szShop, sizeof szShop, "Наименование предмета                     \tСтоимость покупки/продажи\n");
	format(szShop, sizeof szShop, "%sМеталлоискатель\t{42B02C}15.000.000 руб.\n", szShop);
	format(szShop, sizeof szShop, "%sБатарейка\t\t{42B02C}500.000 руб.\n", szShop);
	format(szShop, sizeof szShop, "%sЛопата\t\t{42B02C}3.000.000 руб.\n", szShop);
	format(szShop, sizeof szShop, "%s{AFAFAF}Продать собранный металлолом\t{42B02C}1,500.000 руб./ед.", szShop);
	Dialog(playerid, DIALOG_METALSHOP, DIALOG_STYLE_TABLIST_HEADERS, "{FFD83D}Магазин оборудования", szShop, "Выбрать", "Закрыть");
	return 1;
}

forward MetalShop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
public MetalShop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(!response) return 0;

	if(dialogid == DIALOG_METAL_MENU)
	{
		switch(listitem)
		{
			case 0:
			{
				Dialog(playerid, DIALOG_METAL_GPS, DIALOG_STYLE_LIST, "{FFD83D}Металлоискатель - GPS", "1. Магазин/Скупка лома\n2. Зона с металлом №1", "Выбрать", "Назад");
			}
			case 1:
			{
				Dialog(playerid, DIALOG_METAL_INFO, DIALOG_STYLE_MSGBOX, "{FFD83D}Инфо", "{FFFFFF}Добро пожаловать в ряды искателей сокровищ!\n\n{FFD83D}1. Подготовка:\n{FFFFFF}Посетите магазин на заводе (в GPS), чтобы купить оборудование:\n- Металлоискатель, Батареи и Лопату.\n\n{FFD83D}2. Процесс:\n{FFFFFF}В зоне поиска включите прибор. Чем быстрее сигнал - тем ближе клад.\nПри достижении 100% сигнала используйте лопату, чтобы выкопать лом.\n\n{FFD83D}3. Продажа:\n{FFFFFF}Сдавайте лом на заводе. Цена: {66CC33}1.500.000 руб. за ед.\n\n{FFD83D}4. Правило ЕПП:\n{FFFFFF}По полям можно ездить {FF0000}ТОЛЬКО{FFFFFF} на транспорте, подходящем для ЕПП\n(внедорожники, кроссоверы). Нарушение карается администрацией!", "ОК", "");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_METAL_GPS)
	{
		switch(listitem)
		{
			case 0:
			{
                EnablePlayerGPS(playerid, 37, 163.2720, 410.3226, 11.0386, "* Вы установили метку на магазин металлоискателей. Найти его можно по GPS.");
			}
			case 1:
			{
				EnablePlayerGPS(playerid, 37, -2479.3779, -251.9856, 36.6884, "* Вы установили метку на зону поиска №1. Найти её можно по GPS.");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_METAL_INFO) return 1;

	if(dialogid != DIALOG_METALSHOP) return 0;

	switch(listitem)
	{
		case 0:
		{
			if(Craft_GetPlayerItemCount(playerid, METAL_DETECTOR_ID) >= 1)
				return SendClientMessage(playerid, 0xCECECEFF, "* У вас уже есть металлоискатель!");

			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), METAL_DETECTOR_PRICE))
				return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег! Стоимость: 15.000.000 руб.");

			GivePlayerMoneyEx(playerid, -METAL_DETECTOR_PRICE, "Металлоискатель", true, true);
			GiveIteam(playerid, METAL_DETECTOR_ID, 1, 1, 0);
			pMetalSearchCharge[playerid] = 100;
			SendClientMessage(playerid, 0x66CC33FF, "Вы успешно приобрели металлоискатель.");
		}
		case 1:
		{
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), METAL_BATTERY_PRICE))
				return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег! Стоимость: 500.000 руб.");

			GivePlayerMoneyEx(playerid, -METAL_BATTERY_PRICE, "Батарейка", true, true);
			GiveIteam(playerid, METAL_BATTERY_ID, 1, 1, 0);
			SendClientMessage(playerid, 0x66CC33FF, "Вы успешно приобрели батарейку.");
		}
		case 2:
		{
			if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), METAL_SHOVEL_PRICE))
				return SendClientMessage(playerid, 0xCECECEFF, "* Недостаточно денег! Стоимость: 3.000.000 руб.");

			GivePlayerMoneyEx(playerid, -METAL_SHOVEL_PRICE, "Лопата", true, true);
			GiveIteam(playerid, METAL_SHOVEL_ID, 1, 1, 0);
			SendClientMessage(playerid, 0x66CC33FF, "Вы успешно приобрели лопату.");
		}
		case 3:
		{
			new scrap_count = Craft_GetPlayerItemCount(playerid, METAL_SCRAP_ID);
			if(scrap_count <= 0)
				return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет металлолома на продажу.");

			new profit = scrap_count * METAL_BOUGHT_PRICE;
			GiveIteam(playerid, METAL_SCRAP_ID, 0, scrap_count, 0);
			GivePlayerMoneyEx(playerid, profit, "Продажа лома", true, true);

			new str_shop[128];
			format(str_shop, sizeof str_shop, "Вы продали %d ед. металлолома на сумму %d руб.", scrap_count, profit);
			SendClientMessage(playerid, 0x66CC33FF, str_shop);
		}
	}
	return 1;
}

forward MetalSearchUpdate(playerid);
public MetalSearchUpdate(playerid)
{
	if(!pMetalSearchStatus[playerid])
	{
		KillTimer(pSearchTimer[playerid]);
		return 1;
	}

	new Float:d_u = GetPlayerDistanceFromPoint(playerid, pSearchTarget[playerid][0], pSearchTarget[playerid][1], pSearchTarget[playerid][2]);
	new s_u = 0;

	if(d_u < SEARCH_RADIUS)
	{
		s_u = floatround(100.0 - (d_u * 2.5));
		if(s_u < 0) s_u = 0;
		if(s_u > 100) s_u = 100;
	}

	if(random(15) == 0)
	{
		pMetalSearchCharge[playerid] -= 1;
		new slot = GetMetalDetectorSlot(playerid);
		if(slot != -1)
		{
			SetPlayerItem(slot, PI_PATRON, pMetalSearchCharge[playerid]);
			new query[128];
			mysql_format(mysql, query, sizeof query, "UPDATE items SET patron=%d WHERE id=%d LIMIT 1", pMetalSearchCharge[playerid], GetPlayerItem(slot, PI_SQL_ID));
			mysql_tquery(mysql, query);
		}
	}

	if(pMetalSearchCharge[playerid] <= 0)
	{
		pMetalSearchCharge[playerid] = 0;
		SendClientMessage(playerid, 0xCECECEFF, "* Металлоискатель разрядился!");
		OnPlayerOffMetalSearch(playerid);
		return 1;
	}

	new f_u[384];
	format(f_u, sizeof f_u, "if(window.getInterfaceStatus('GarbageMetalSearch')) { window.interface('GarbageMetalSearch').getSearchInfo('[1, %d, %d]'); }", s_u, pMetalSearchCharge[playerid]);

	if(s_u > 0)
	{
		new snd_id = 1;
		if(s_u > 30) snd_id = 2;
		if(s_u > 60) snd_id = 3;
		if(s_u > 85) snd_id = 4;

		new snd_s[64];
		format(snd_s, sizeof snd_s, " window.interface('GarbageMetalSearch').playSignal('%d', 0.5);", snd_id);
		strcat(f_u, snd_s);
	}

	if(s_u > 91)
	{
		if(pMetalSearchNotifyFlag[playerid] == 0)
		{
			SendClientMessage(playerid, 0x66CC33FF, "{66CC33}* Сигнал максимальный! Нажмите ALT, чтобы выкопать клад.");
			pMetalSearchNotifyFlag[playerid] = 1;
		}
	}
	else pMetalSearchNotifyFlag[playerid] = 0;

	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, f_u);
	return 1;
}

forward FindItemInterf_OnPlayerSearch(playerid);
public FindItemInterf_OnPlayerSearch(playerid)
{
	new target_id = pSearchTargetID[playerid];
	pLastPointCollect[playerid][target_id] = gettime();

	new r_a = random(3) + 1;
	GiveIteam(playerid, METAL_SCRAP_ID, 1, r_a, 0);

	new f_f[128];
	format(f_f, sizeof f_f, "Вы очистили тайник и нашли %d ед. металлолома!", r_a);
	SendClientMessage(playerid, 0x3399FFFF, f_f);

	MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.interface('GarbageMetalSearch').playSignal('0', 0);");
	return 1;
}

forward OnPlayerOffMetalSearch(playerid);
public OnPlayerOffMetalSearch(playerid)
{
	if(pMetalSearchStatus[playerid])
	{
		KillTimer(pSearchTimer[playerid]);
		pMetalSearchStatus[playerid] = 0;

		SendClientMessage(playerid, 0xCECECEFF, "* Металлоискатель выключен.");
		MoralPacket_1(playerid, s_CefInterface, t_CefHide, "GarbageMetalSearch");
		MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "window.interface('GarbageMetalSearch').playSignal('0', 0);");
		RemovePlayerAttachedObject(playerid, 9);
	}
	return 1;
}

stock StartMetalSearch(playerid)
{
	new slot = GetMetalDetectorSlot(playerid);
	if(slot == -1)
		return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет металлоискателя.");

	if(pMetalSearchStatus[playerid])
	{
		OnPlayerOffMetalSearch(playerid);
		return 1;
	}

	pMetalSearchCharge[playerid] = GetPlayerItem(slot, PI_PATRON);
	if(pMetalSearchCharge[playerid] <= 0)
		return SendClientMessage(playerid, 0xCECECEFF, "* Металлоискатель разряжен!");

	new available_points[MAX_METAL_TREASURES], available_count = 0;
	new now = gettime();
	new bool:is_near_any = false;

	for(new i = 0; i < sizeof(MetalTreasures); i++)
	{
		if(now - pLastPointCollect[playerid][i] >= SEARCH_COOLDOWN)
		{
			if(GetPlayerDistanceFromPoint(playerid, MetalTreasures[i][0], MetalTreasures[i][1], MetalTreasures[i][2]) <= ACTIVATION_RADIUS)
			{
				available_points[available_count++] = i;
				is_near_any = true;
			}
		}
	}

	if(!is_near_any)
		return SendClientMessage(playerid, 0xCECECEFF, "* Поблизости нет подходящих мест для поиска.");

	if(available_count == 0)
		return SendClientMessage(playerid, 0xCECECEFF, "* Все точки поблизости исчерпаны. Попробуйте через 10 минут.");

	new rand_idx = random(available_count);
	new point_id = available_points[rand_idx];

	pSearchTarget[playerid][0] = MetalTreasures[point_id][0];
	pSearchTarget[playerid][1] = MetalTreasures[point_id][1];
	pSearchTarget[playerid][2] = MetalTreasures[point_id][2];
	pSearchTargetID[playerid] = point_id;

	pMetalSearchStatus[playerid] = 1;
	pMetalSearchNotifyFlag[playerid] = 0;

	new s_s[32];
	format(s_s, sizeof s_s, "[0, 0, %d]", pMetalSearchCharge[playerid]);
	MoralPacket_2(playerid, s_CefInterface, t_CefShow, "GarbageMetalSearch", s_s);

	pSearchTimer[playerid] = SetTimerEx("MetalSearchUpdate", 1000, true, "i", playerid);
	SendClientMessage(playerid, 0x66CC33FF, "Металлоискатель включен.");
	SetPlayerAttachedObject(playerid, 9, 10804, 6, -0.017998, 0.035999, -0.068999, -176.499954, -120.199928, 90.299972, 1.000000, 1.000000, 1.000000);
	return 1;
}

stock UseMetalBattery(playerid)
{
	new slot = GetMetalDetectorSlot(playerid);
	if(slot == -1)
		return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет металлоискателя.");

	pMetalSearchCharge[playerid] = 100;
	SetPlayerItem(slot, PI_PATRON, 100);

	new query[128];
	mysql_format(mysql, query, sizeof query, "UPDATE items SET patron=100 WHERE id=%d LIMIT 1", GetPlayerItem(slot, PI_SQL_ID));
	mysql_tquery(mysql, query);

	GiveIteam(playerid, METAL_BATTERY_ID, 0, 1, 0);
	SendClientMessage(playerid, 0x66CC33FF, "Батарейка заменена.");
	return 1;
}

forward MetalSearch_OnKeyStateChange(playerid, newkeys);
public MetalSearch_OnKeyStateChange(playerid, newkeys)
{
	if((newkeys & KEY_WALK) && IsPlayerInRangeOfPoint(playerid, 2.0, 163.2720, 410.3226, 11.0386))
	{
		ShowMetalShop(playerid);
		return 1;
	}

	if((newkeys & KEY_WALK) && pMetalSearchStatus[playerid] == 1)
	{
		if(Craft_GetPlayerItemCount(playerid, METAL_SHOVEL_ID) < 1)
			return SendClientMessage(playerid, 0xCECECEFF, "* У вас нет лопаты!");

		if(GetPlayerDistanceFromPoint(playerid, pSearchTarget[playerid][0], pSearchTarget[playerid][1], pSearchTarget[playerid][2]) <= 5.0)
		{
			MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "if(window.interface('GarbageMetalSearch')) { window.interface('GarbageMetalSearch').playSignal('0', 0); window.interface('GarbageMetalSearch').getSearchInfo('[0, 0, 0]'); }");
			MoralPacket_1(playerid, s_CefInterface, t_CefHide, "GarbageMetalSearch");

			KillTimer(pSearchTimer[playerid]);
			pMetalSearchStatus[playerid] = 0;

			SendClientMessage(playerid, 0x66CC33FF, "Вы начали раскопки...");
			SetPlayerAttachedObject(playerid, 9, 19626, 6, 0.040000, 0.027000, 0.176999, -121.399986, 0.000000, 0.000000);
			ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 0, 1);

			SetTimerEx("RemoveShovel", 4000, false, "i", playerid);
			return 1;
		}
	}
	return 0;
}

forward RemoveShovel(playerid);
public RemoveShovel(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		RemovePlayerAttachedObject(playerid, 9);
		ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
		FindItemInterf_OnPlayerSearch(playerid);
		MoralPacket_1(playerid, s_CefInterface, t_CefHide, "GarbageMetalSearch");
	}
	return 1;
}

stock GetMetalDetectorSlot(playerid)
{
	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_ITEM) != METAL_DETECTOR_ID) continue;
		return i;
	}
	return -1;
}

CMD:metal(playerid, params[])
{
	Dialog(playerid, DIALOG_METAL_MENU, DIALOG_STYLE_LIST, "{FFD83D}Поиск металла", "1. GPS\n2. Информация о работе", "Выбрать", "Закрыть");
	return 1;
}

forward MetalSearch_OnGameModeInit();
public MetalSearch_OnGameModeInit()
{
	for(new i = 0; i < MAX_PLAYERS; i++) {
		for(new j = 0; j < MAX_METAL_TREASURES; j++) {
			pAdminMetalLabels[i][j] = Text3D:INVALID_3DTEXT_ID;
		}
	}

	Create3DTextLabel("{FFD83D}Магазин инструментов\n{FFFFFF}Используйте ALT для взаимодействия", 0xFFFFFFFF, 163.2720, 410.3226, 11.0386 + 0.5, 20.0, 0, 1);
	CreateDynamicPickup(19132, 23, 163.2720, 410.3226, 11.0386, 0);
	return 1;
}

CMD:mcharge(playerid)
{
    if(!admin_logged[playerid] || GetPlayerAdminEx(playerid) < 10 || GetPlayerBuyAdminEx(playerid) == 1) return 1;
    
    pMetalSearchCharge[playerid] = 100;
    SendClientMessage(playerid, 0x66CC33FF, "[Admin] Заряд металлоискателя пополнен до 100%.");
    return 1;
}

CMD:mtp(playerid)
{
    if(!admin_logged[playerid] || GetPlayerAdminEx(playerid) < 10 || GetPlayerBuyAdminEx(playerid) == 1) return 1;
    if(pMetalSearchStatus[playerid] != 1) return SendClientMessage(playerid, COLOR_RED, "Вы не начали поиск металла.");
    
    SetPlayerPos(playerid, pSearchTarget[playerid][0], pSearchTarget[playerid][1], pSearchTarget[playerid][2] + 1.0);
    SendClientMessage(playerid, 0x66CC33FF, "[Admin] Вы телепортированы к цели поиска.");
    return 1;
}

CMD:mshowall(playerid)
{
    if(!admin_logged[playerid] || GetPlayerAdminEx(playerid) < 10 || GetPlayerBuyAdminEx(playerid) == 1) return 1;
    
    if(pAdminMetalLabels[playerid][0] == Text3D:INVALID_3DTEXT_ID)
    {
        for(new i = 0; i < MAX_METAL_TREASURES; i++)
        {
            pAdminMetalLabels[playerid][i] = CreateDynamic3DTextLabel("[Клад]", 0x66CC33FF, MetalTreasures[i][0], MetalTreasures[i][1], MetalTreasures[i][2], 40.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, playerid);
        }
        SendClientMessage(playerid, 0x66CC33FF, "[Admin] Все точки сокровищ теперь видны (только вам).");
    }
    else
    {
        for(new i = 0; i < MAX_METAL_TREASURES; i++)
        {
            if(pAdminMetalLabels[playerid][i] != Text3D:INVALID_3DTEXT_ID)
            {
                DestroyDynamic3DTextLabel(pAdminMetalLabels[playerid][i]);
                pAdminMetalLabels[playerid][i] = Text3D:INVALID_3DTEXT_ID;
            }
        }
        SendClientMessage(playerid, 0xCECECEFF, "[Admin] Отображение точек отключено.");
    }
    return 1;
}
