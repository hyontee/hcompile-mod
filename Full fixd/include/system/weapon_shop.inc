
#define MAX_WEAPONS 5
#define WEAPON_CATEGORY_ALL 0
#define WEAPON_CATEGORY_PISTOL 1
#define WEAPON_CATEGORY_RIFLE 2
#define WEAPON_CATEGORY_SHOTGUN 3
#define WEAPON_CATEGORY_SNIPER 4
#define WEAPON_CATEGORY_MELEE 5
#define WEAPON_CATEGORY_AMMO 6
#define WEAPON_CATEGORY_ARMOR 7

#define DIALOG_GUN_SHOP_MAIN 2000
#define DIALOG_GUN_SHOP_PISTOLS 2001
#define DIALOG_GUN_SHOP_RIFLES 2002
#define DIALOG_GUN_SHOP_SHOTGUNS 2003
#define DIALOG_GUN_SHOP_SNIPERS 2004
#define DIALOG_GUN_SHOP_CONFIRM 2005
#define DIALOG_GUN_SHOP_AMMO 2006
#define DIALOG_GUN_SHOP_ARMOR 2007

enum WeaponData
{
	W_ID,
	W_NAME[64],
	W_PRICE,
	W_AMMO,
	W_CATEGORY,
	W_DESCRIPTION[128]
};

new Weapons[MAX_WEAPONS][WeaponData] = 
{
	{25, "Дробовик", 140, 50, WEAPON_CATEGORY_SHOTGUN, "Дробовик с 50 патронами"},
	{29, "MP5", 60, 100, WEAPON_CATEGORY_RIFLE, "MP5 с 100 патронами"},
	{30, "АК-74М", 120, 100, WEAPON_CATEGORY_RIFLE, "АК-74М с 100 патронами"},
	{33, "Винтовка", 70, 50, WEAPON_CATEGORY_SNIPER, "Винтовка с 50 патронами"},
	{24, "Desert Eagle", 100, 50, WEAPON_CATEGORY_PISTOL, "Desert Eagle с 50 патронами"}
};

enum AmmoPackData
{
	A_NAME[64],
	A_PRICE,
	A_AMOUNT,
	A_DESCRIPTION[128]
};

new AmmoPacks[4][AmmoPackData] =
{
	{"\xcf\xe0\xf2\xf0\xee\xed\xfb +50", 1680, 50, "\xc4\xee\xef\xee\xeb\xed\xe8\xf2\xe5\xeb\xfc\xed\xfb\xe5 50 \xef\xe0\xf2\xf0\xee\xed\xee\xe2"},
	{"Патроны +100", 3600, 100, "Дополнительные 100 патронов"},
	{"Патроны +30", 1200, 30, "Дополнительные 30 патронов"},
	{"Патроны +40", 1250, 40, "Дополнительные 40 патронов"}
};

enum ArmorData
{
	AR_NAME[64],
	AR_PRICE,
	AR_AMOUNT,
	AR_DESCRIPTION[128]
};

new Armor[4][ArmorData] =
{
	{"\xc1\xf0\xee\xed\xe6\xe8\xeb\xe5\xf2 50", 2500, 50, "\xc1\xf0\xee\xed\xff 50 \xe5\xe4\xe8\xed\xe8\xf6"},
	{"Бронежилет 100", 5000, 100, "Броня 100 единиц"},
	{"Бронежилет 150", 8000, 150, "Броня 150 единиц"},
	{"Бронежилет 200", 12000, 200, "Броня 200 единиц"}
};

new g_PlayerSelectedWeapon[MAX_PLAYERS] = {-1, ...};
new g_PlayerSelectedAmmoPack[MAX_PLAYERS] = {-1, ...};
new g_PlayerSelectedArmor[MAX_PLAYERS] = {-1, ...};
new g_PlayerWeaponCategory[MAX_PLAYERS] = {WEAPON_CATEGORY_ALL, ...};

#define STATIC_GUN_SHOP_COUNT (7)
#define STATIC_GUN_SHOP_INTERIOR (1)
#define STATIC_GUN_SHOP_WORLD (0)
#define STATIC_GUN_SHOP_PICKUP_MODEL (19132)
#define STATIC_GUN_SHOP_BUY_RANGE (2.2)
#define STATIC_GUN_SHOP_EXIT_DISTANCE (2.5)

new const Float:g_static_gun_shop_pos[STATIC_GUN_SHOP_COUNT][3] =
{
	{207.629000, 829.766000, 13.383100},
	{2350.050000, -2138.410000, 22.570600},
	{-2381.790000, -60.819000, 26.752400},
	{-1788.000000, 671.136000, 35.399800},
	{1950.070000, 1899.340000, 15.558000},
	{-1931.960000, 2380.450000, 58.652100},
	{-2560.400000, 1078.310000, 10.390000}
};

new const Float:g_static_gun_shop_enter_pos[4] = {2896.4705, 2900.3047, 1501.0000, 360.0};
new const Float:g_static_gun_shop_exit_pos[4] = {2894.7336, 2900.0076, 1501.0000, 180.0};
new const Float:g_static_gun_shop_buy_pos[3] = {2904.6665, 2900.7778, 1501.0000};

new g_static_gun_shop_exit_area = -1;
new g_static_gun_shop_player_entrance[MAX_PLAYERS] = {-1, ...};
new Float:g_static_gun_shop_player_exit_pos[MAX_PLAYERS][4];

stock bool:WeaponShop_IsPlayerNearStaticBuy(playerid)
{
	if(GetPlayerInterior(playerid) != STATIC_GUN_SHOP_INTERIOR) return false;
	if(GetPlayerVirtualWorld(playerid) != STATIC_GUN_SHOP_WORLD) return false;
	if(!IsPlayerInRangeOfPoint(playerid, STATIC_GUN_SHOP_BUY_RANGE, g_static_gun_shop_buy_pos[0], g_static_gun_shop_buy_pos[1], g_static_gun_shop_buy_pos[2])) return false;
	return true;
}

stock WeaponShop_UpdateStaticShopExitPos(playerid, shopid)
{
	new Float:x, Float:y, Float:z, Float:angle;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, angle);

	new Float:dir_x = x - g_static_gun_shop_pos[shopid][0];
	new Float:dir_y = y - g_static_gun_shop_pos[shopid][1];
	new Float:distance = floatsqroot((dir_x * dir_x) + (dir_y * dir_y));

	if(distance < 0.25)
	{
		dir_x = floatsin(-angle + 180.0, degrees);
		dir_y = floatcos(-angle + 180.0, degrees);
	}
	else
	{
		dir_x /= distance;
		dir_y /= distance;
	}

	g_static_gun_shop_player_exit_pos[playerid][0] = g_static_gun_shop_pos[shopid][0] + (dir_x * STATIC_GUN_SHOP_EXIT_DISTANCE);
	g_static_gun_shop_player_exit_pos[playerid][1] = g_static_gun_shop_pos[shopid][1] + (dir_y * STATIC_GUN_SHOP_EXIT_DISTANCE);
	g_static_gun_shop_player_exit_pos[playerid][2] = g_static_gun_shop_pos[shopid][2];
	g_static_gun_shop_player_exit_pos[playerid][3] = angle;
	return 1;
}

stock WeaponShop_CreateStaticShops()
{
	new label_text[160];
	format(label_text, sizeof label_text, "{FFFF00}Магазин оружии\n{FFFFFF}Крыша: отсутствует\n{FFFFFF}Бизнес продается /buybiz\n{FFFFFF}цена: 35000000");

	for(new i; i < STATIC_GUN_SHOP_COUNT; i++)
	{
		CreatePickup(STATIC_GUN_SHOP_PICKUP_MODEL, 23, g_static_gun_shop_pos[i][0], g_static_gun_shop_pos[i][1], g_static_gun_shop_pos[i][2], STATIC_GUN_SHOP_WORLD, PICKUP_ACTION_TYPE_STATIC_GUN_SHOP, i);
		CreateDynamic3DTextLabel(label_text, 0xFFFF00FF, g_static_gun_shop_pos[i][0], g_static_gun_shop_pos[i][1], g_static_gun_shop_pos[i][2] + 1.0, 10.0, _, _, _, STATIC_GUN_SHOP_WORLD, 0);
	}


	// Exit is now an invisible dynamic area. Do not create another pickup here,
	// because the business interior already has its own pickup at this position.
	g_static_gun_shop_exit_area = CreateDynamicSphere(g_static_gun_shop_exit_pos[0], g_static_gun_shop_exit_pos[1], g_static_gun_shop_exit_pos[2], 1.5, STATIC_GUN_SHOP_WORLD, STATIC_GUN_SHOP_INTERIOR);
	return 1;
}

stock WeaponShop_EnterStaticShop(playerid, shopid)
{
	if(shopid < 0 || shopid >= STATIC_GUN_SHOP_COUNT) shopid = 0;
	g_static_gun_shop_player_entrance[playerid] = shopid;
	WeaponShop_UpdateStaticShopExitPos(playerid, shopid);
	SetPlayerInBiz(playerid, -1);
	SetPlayerPosEx(playerid, g_static_gun_shop_enter_pos[0], g_static_gun_shop_enter_pos[1], g_static_gun_shop_enter_pos[2], g_static_gun_shop_enter_pos[3], STATIC_GUN_SHOP_INTERIOR, STATIC_GUN_SHOP_WORLD);
	SetTimerEx("WeaponShop_OpenAfterEnter", 150, false, "i", playerid);
	return 1;
}

stock WeaponShop_ExitStaticShop(playerid)
{
	new shopid = g_static_gun_shop_player_entrance[playerid];
	new bool:has_exit_pos = (0 <= shopid < STATIC_GUN_SHOP_COUNT);
	if(!has_exit_pos) shopid = 0;
	g_static_gun_shop_player_entrance[playerid] = -1;

	if(has_exit_pos)
	{
		SetPlayerPosEx(playerid, g_static_gun_shop_player_exit_pos[playerid][0], g_static_gun_shop_player_exit_pos[playerid][1], g_static_gun_shop_player_exit_pos[playerid][2], g_static_gun_shop_player_exit_pos[playerid][3], 0, STATIC_GUN_SHOP_WORLD);
	}
	else
	{
		SetPlayerPosEx(playerid, g_static_gun_shop_pos[shopid][0], g_static_gun_shop_pos[shopid][1] - STATIC_GUN_SHOP_EXIT_DISTANCE, g_static_gun_shop_pos[shopid][2], 0.0, 0, STATIC_GUN_SHOP_WORLD);
	}
	return 1;
}

forward WeaponShop_OpenAfterEnter(playerid);
public WeaponShop_OpenAfterEnter(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(g_static_gun_shop_player_entrance[playerid] == -1) return 0;
	ShowGunShopMenu(playerid);
	return 1;
}

stock WeaponShop_OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == g_static_gun_shop_exit_area)
	{
		if(g_static_gun_shop_player_entrance[playerid] != -1)
			WeaponShop_ExitStaticShop(playerid);
		return 1;
	}
	return 0;
}

stock ShowGunShopMenu(playerid)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина.");

	new string[1024];
	string[0] = '\0';
	for(new i = 0; i < MAX_WEAPONS; i++)
	{
		new temp[160];
		format(temp, sizeof(temp), "{FF5252}%d.\t{FFFFFF}%s\t{FF5252}%d руб.\n", i + 1, Weapons[i][W_NAME], Weapons[i][W_PRICE]);
		strcat(string, temp);
	}

	Dialog(playerid, DIALOG_GUN_SHOP_MAIN, DIALOG_STYLE_TABLIST,
		"{FF5252}Магазин оружия", string, "Выбрать", "Выход");
	return 1;
}

stock WeaponShop_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid != DIALOG_BIZ_SHOP_GUN && dialogid != DIALOG_GUN_SHOP_MAIN && dialogid != DIALOG_GUN_SHOP_PISTOLS && dialogid != DIALOG_GUN_SHOP_AMMO && dialogid != DIALOG_GUN_SHOP_ARMOR && dialogid != DIALOG_GUN_SHOP_CONFIRM)
		return 0;

	if(dialogid == DIALOG_BIZ_SHOP_GUN)
	{
		if(!response) return 1;
		ShowGunShopMenu(playerid);
		return 1;
	}

	if(dialogid == DIALOG_GUN_SHOP_MAIN)
	{
		if(!response) return 1;
		if(listitem < 0 || listitem >= MAX_WEAPONS) return 1;
		ShowWeaponConfirmDialog(playerid, listitem);
		return 1;
	}

	if(dialogid == DIALOG_GUN_SHOP_PISTOLS)
	{
		if(!response)
		{
			ShowGunShopMenu(playerid);
			return 1;
		}

		new category = g_PlayerWeaponCategory[playerid];
		new count = 0, weaponid = -1;

		for(new i = 0; i < MAX_WEAPONS; i++)
		{
			if(category == WEAPON_CATEGORY_ALL || Weapons[i][W_CATEGORY] == category)
			{
				if(count == listitem)
				{
					weaponid = i;
					break;
				}
				count++;
			}
		}

		if(weaponid == -1)
		{
			ShowWeaponsByCategory(playerid, category);
			return 1;
		}

		ShowWeaponConfirmDialog(playerid, weaponid);
		return 1;
	}

	if(dialogid == DIALOG_GUN_SHOP_AMMO)
	{
		if(!response)
		{
			ShowGunShopMenu(playerid);
			return 1;
		}

		new ammoid = listitem;
		if(ammoid < 0 || ammoid >= 4)
		{
			ShowAmmoShopMenu(playerid);
			return 1;
		}

		ShowAmmoConfirmDialog(playerid, ammoid);
		return 1;
	}

	if(dialogid == DIALOG_GUN_SHOP_ARMOR)
	{
		if(!response)
		{
			ShowGunShopMenu(playerid);
			return 1;
		}

		new armorid = listitem;
		if(armorid < 0 || armorid >= 4)
		{
			ShowArmorShopMenu(playerid);
			return 1;
		}

		ShowArmorConfirmDialog(playerid, armorid);
		return 1;
	}

	if(dialogid == DIALOG_GUN_SHOP_CONFIRM)
	{
		if(!response)
		{
			if(g_PlayerWeaponCategory[playerid] == WEAPON_CATEGORY_AMMO)
				return ShowAmmoShopMenu(playerid), 1;
			else if(g_PlayerWeaponCategory[playerid] == WEAPON_CATEGORY_ARMOR)
				return ShowArmorShopMenu(playerid), 1;
			return ShowWeaponsByCategory(playerid, g_PlayerWeaponCategory[playerid]), 1;
		}

		if(g_PlayerWeaponCategory[playerid] == WEAPON_CATEGORY_AMMO)
			BuyAmmoFromShop(playerid);
		else if(g_PlayerWeaponCategory[playerid] == WEAPON_CATEGORY_ARMOR)
			BuyArmorFromShop(playerid);
		else
			BuyWeaponFromShop(playerid);
		return 1;
	}

	return 0;
}

stock ShowWeaponsByCategory(playerid, category)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;
	
	new string[2048], count = 0, temp[256], i;
	string[0] = '\0';
	
	strcat(string, "Название\tЦена\n");
	new category_name[32] = "";
	
	if(category == WEAPON_CATEGORY_PISTOL)
	{
		format(category_name, sizeof(category_name), "Оружие");
	}
	else if(category == WEAPON_CATEGORY_RIFLE)
	{
		format(category_name, sizeof(category_name), "Оружие");
	}
	else if(category == WEAPON_CATEGORY_SHOTGUN)
	{
		format(category_name, sizeof(category_name), "Оружие");
	}
	else if(category == WEAPON_CATEGORY_SNIPER)
	{
		format(category_name, sizeof(category_name), "Оружие");
	}
	else if(category == WEAPON_CATEGORY_MELEE)
	{
		format(category_name, sizeof(category_name), "Оружие");
	}

	for(i = 0; i < MAX_WEAPONS; i++)
	{
		if(category == WEAPON_CATEGORY_ALL || Weapons[i][W_CATEGORY] == category)
		{
			format(temp, sizeof(temp), "{FF5252}%d.\t{FFFFFF}%s\t{FF5252}%d руб.\n",
				count + 1,
				Weapons[i][W_NAME],
				Weapons[i][W_PRICE]
			);
			strcat(string, temp);
			count++;
		}
	}
	
	if(count == 0) return SendClientMessage(playerid, 0xFF0000FF, "В магазине нет товаров."), 0;
	
	new title[128];
	format(title, sizeof(title), "{FF5252}Магазин оружии {FFFFFF}| %s", category_name);
	
	Dialog(playerid, DIALOG_GUN_SHOP_PISTOLS, DIALOG_STYLE_TABLIST_HEADERS,
		title, string, "", "");
	
	g_PlayerWeaponCategory[playerid] = category;
	return 1;
}

stock ShowAmmoShopMenu(playerid)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;


	new string[2048], count = 0, temp[256], i;
	string[0] = '\0';
	strcat(string, "Название\tЦена\n");

	for(i = 0; i < 4; i++)
	{
		format(temp, sizeof(temp), "{FF5252}%d.\t{FFFFFF}%s\t{FF5252}%d руб.\n",
			i + 1,
			AmmoPacks[i][A_NAME],
			AmmoPacks[i][A_PRICE]
		);
		strcat(string, temp);
		count++;
	}

	if(count == 0) return SendClientMessage(playerid, 0xFF0000FF, "В магазине нет брони."), 0;

	Dialog(playerid, DIALOG_GUN_SHOP_AMMO, DIALOG_STYLE_TABLIST_HEADERS,
		"{FF5252}Магазин оружия",
		string,
		"", "");

	g_PlayerWeaponCategory[playerid] = WEAPON_CATEGORY_AMMO;
	return 1;
}

stock ShowAmmoConfirmDialog(playerid, ammoid)
{
	if(ammoid < 0 || ammoid >= 4) return SendClientMessage(playerid, 0xFF0000FF, "Неверный набор патронов."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;

	new message[512];
	format(message, sizeof(message),
		"{FFFFFF}Вы выбрали: {FF5252}%s{FFFFFF}.\n\n\
		{FFFFFF}Количество: {FF5252}%d шт.{FFFFFF}, цена: {FF5252}%d руб.",
		AmmoPacks[ammoid][A_NAME],
		AmmoPacks[ammoid][A_AMOUNT],
		AmmoPacks[ammoid][A_PRICE]
	);

	Dialog(playerid, DIALOG_GUN_SHOP_CONFIRM, DIALOG_STYLE_MSGBOX,
		"{FF5252}Магазин оружия",
		message, "Купить", "Отмена");

	g_PlayerSelectedAmmoPack[playerid] = ammoid;
	return 1;
}

stock BuyAmmoFromShop(playerid)
{
	new ammoid = g_PlayerSelectedAmmoPack[playerid];

	if(ammoid < 0 || ammoid >= 4) return SendClientMessage(playerid, 0xFF0000FF, "Неверный набор патронов."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;

	new price = AmmoPacks[ammoid][A_PRICE];
	if(price <= 0) return SendClientMessage(playerid, 0xFF0000FF, "Неверная цена товара."), 0;

	if(GetPlayerMoneyEx(playerid) < price)
	{
		new msg[128];
		format(msg, sizeof(msg), "Недостаточно денег. Необходимо %d руб.", price);
		return SendClientMessage(playerid, 0xFF0000FF, msg), 0;
	}

	new query[512];
	format(query, sizeof query,
		"UPDATE accounts SET money=%d WHERE id=%d LIMIT 1",
		GetPlayerMoneyEx(playerid) - price,
		GetPlayerAccountID(playerid)
	);
	mysql_query(mysql, query, false);

	if(mysql_errno() != 0) return SendClientMessage(playerid, 0xFF0000FF, "Ошибка базы данных. Попробуйте позже."), 0;

	AddPlayerData(playerid, P_AMMO, +, AmmoPacks[ammoid][A_AMOUNT]);
	UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));
	GivePlayerMoneyEx(playerid, -price, " ", false, true);

	new playername[24];
	GetPlayerName(playerid, playername, sizeof(playername));
	new chatmsg[128];
	format(chatmsg, sizeof(chatmsg), "%s, вы приобрели %s (%d шт.) за %d руб.", playername, AmmoPacks[ammoid][A_NAME], AmmoPacks[ammoid][A_AMOUNT], price);
	SendClientMessage(playerid, 0xFFFFFFFF, chatmsg);

	new notify[128];
	format(notify, sizeof(notify), "Списано %d руб.", price);
	ShowNotificationLaird(playerid, 0, 6, 0, 0, notify, " ");

	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);

	g_PlayerSelectedAmmoPack[playerid] = -1;
	return 1;
}

stock ShowWeaponConfirmDialog(playerid, weaponid)
{
	if(weaponid < 0 || weaponid >= MAX_WEAPONS) return SendClientMessage(playerid, 0xFF0000FF, "Неверное оружие."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;
	
	new message[512];
	format(message, sizeof(message),
		"{FFFFFF}Вы хотите приобрести: {FF5252}%s{FFFFFF}.\n\n\
		{FFFFFF}Цена: {FF5252}%d руб.",
		Weapons[weaponid][W_NAME],
		Weapons[weaponid][W_PRICE]
	);
	
	Dialog(playerid, DIALOG_GUN_SHOP_CONFIRM, DIALOG_STYLE_MSGBOX,
		"{FF5252}Магазин оружия", message, "Купить", "Отмена");
	
	g_PlayerSelectedWeapon[playerid] = weaponid;
	return 1;
}

stock WeaponShop_GetWeaponSlot(weapon_id)
{
	switch(weapon_id)
	{
		case 0, 1: return 0;
		case 2..9: return 1;
		case 22..24: return 2;
		case 25..27: return 3;
		case 28, 29, 32: return 4;
		case 30, 31: return 5;
		case 33, 34: return 6;
		case 35..38: return 7;
		case 16..18: return 8;
		case 41..43: return 9;
		case 10..15: return 10;
		case 44..46: return 11;
		case 40: return 12;
	}
	return 0;
}

stock WeaponShop_GiveReplacementWeapon(playerid, weapon_id, weapon_ammo)
{
	new replace_slot = WeaponShop_GetWeaponSlot(weapon_id);
	new slot_weapon[13], slot_ammo[13];

	for(new idx; idx < 13; idx++)
	{
		GetPlayerWeaponData(playerid, idx, slot_weapon[idx], slot_ammo[idx]);
	}

	ResetPlayerWeapons(playerid);

	for(new idx; idx < 13; idx++)
	{
		if(idx == replace_slot) continue;
		if(slot_weapon[idx] == 0 || slot_ammo[idx] <= 0) continue;

		GivePlayerWeapon(playerid, slot_weapon[idx], slot_ammo[idx]);
	}

	GivePlayerWeapon(playerid, weapon_id, weapon_ammo);
	return 1;
}

stock BuyWeaponFromShop(playerid)
{
	new weaponid = g_PlayerSelectedWeapon[playerid];
	
	if(weaponid < 0 || weaponid >= MAX_WEAPONS) return SendClientMessage(playerid, 0xFF0000FF, "Неверное оружие."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;
	
	new price = Weapons[weaponid][W_PRICE];
	new weapon_name[32];
	
	if(price <= 0) return SendClientMessage(playerid, 0xFF0000FF, "Неверная цена товара."), 0;
	strmid(weapon_name, Weapons[weaponid][W_NAME], 0, strlen(Weapons[weaponid][W_NAME]));
	
	if(GetPlayerMoneyEx(playerid) < price)
	{
		new msg[128];
		format(msg, sizeof(msg), "Недостаточно денег. Необходимо %d руб.", price);
		return SendClientMessage(playerid, 0xFF0000FF, msg), 0;
	}
	
	new query[512];
	format(query, sizeof query, 
		"UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", 
		GetPlayerMoneyEx(playerid) - price, 
		GetPlayerAccountID(playerid)
	);
	
	mysql_query(mysql, query, false);
	
	if(mysql_errno() != 0) return SendClientMessage(playerid, 0xFF0000FF, "Ошибка базы данных. Попробуйте позже."), 0;
	
	WeaponShop_GiveReplacementWeapon(playerid, Weapons[weaponid][W_ID], Weapons[weaponid][W_AMMO]);
	SetPVarInt(playerid, "weapon_shop_last_weapon", Weapons[weaponid][W_ID]);
	SetPVarInt(playerid, "weapon_shop_last_ammo", Weapons[weaponid][W_AMMO]);
	GivePlayerMoneyEx(playerid, -price, " ", false, true);

	new playername[24];
	GetPlayerName(playerid, playername, sizeof(playername));
	new chatmsg[128];
	format(chatmsg, sizeof(chatmsg), "%s, вы приобрели %s (1 шт.) за %d руб.", playername, weapon_name, price);
	SendClientMessage(playerid, 0xFFFFFFFF, chatmsg);

	new notify[128];
	format(notify, sizeof(notify), "Списано %d руб.", price);
	ShowNotificationLaird(playerid, 0, 6, 0, 0, notify, " ");
	
	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);
	
	g_PlayerSelectedWeapon[playerid] = -1;
	return 1;
}

stock GetWeaponIndexByName(const weapon_name[])
{
	for(new i = 0; i < MAX_WEAPONS; i++)
	{
		if(!strcmp(Weapons[i][W_NAME], weapon_name, true)) return i;
	}
	return -1;
}

stock GetWeaponNameByID(weaponid)
{
	for(new i = 0; i < MAX_WEAPONS; i++)
	{
		if(Weapons[i][W_ID] == weaponid) return i;
	}
	return -1;
}

stock ShowArmorShopMenu(playerid)
{
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;


	new string[2048], count = 0, temp[256], i;
	string[0] = '\0';
	strcat(string, "{FFFFFF}Название\tЦена\n");

	for(i = 0; i < 4; i++)
	{
		format(temp, sizeof(temp), "{FF5252}%d.\t{FFFFFF}%s\t{FF5252}%d руб.\n",
			i + 1,
			Armor[i][AR_NAME],
			Armor[i][AR_PRICE]
		);
		strcat(string, temp);
		count++;
	}

	if(count == 0) return SendClientMessage(playerid, 0xFF0000FF, "В магазине нет брони."), 0;

	Dialog(playerid, DIALOG_GUN_SHOP_ARMOR, DIALOG_STYLE_TABLIST_HEADERS,
		"{FF5252}Магазин оружия",
		string,
		"", "");

	g_PlayerWeaponCategory[playerid] = WEAPON_CATEGORY_ARMOR;
	return 1;
}

stock ShowArmorConfirmDialog(playerid, armorid)
{
	if(armorid < 0 || armorid >= 4) return SendClientMessage(playerid, 0xFF0000FF, "Неверный товар."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;

	new message[512];
	format(message, sizeof(message),
		"{FFFFFF}Вы хотите приобрести: {FF5252}%s{FFFFFF}.\n\n\
		{FFFFFF}Цена: {FF5252}%d руб.",
		Armor[armorid][AR_NAME],
		Armor[armorid][AR_PRICE]
	);

	Dialog(playerid, DIALOG_GUN_SHOP_CONFIRM, DIALOG_STYLE_MSGBOX,
		"{FF5252}Магазин оружия", message, "Купить", "Отмена");

	g_PlayerSelectedArmor[playerid] = armorid;
	return 1;
}

stock BuyArmorFromShop(playerid)
{
	new armorid = g_PlayerSelectedArmor[playerid];

	if(armorid < 0 || armorid >= 4) return SendClientMessage(playerid, 0xFF0000FF, "Неверный товар."), 0;
	if(!IsPlayerLogged(playerid)) return 0;
	if(!WeaponShop_IsPlayerNearStaticBuy(playerid)) return SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться у прилавка оружейного магазина."), 0;

	new price = Armor[armorid][AR_PRICE];
	if(price <= 0) return SendClientMessage(playerid, 0xFF0000FF, "Неверная цена товара."), 0;

	if(GetPlayerMoneyEx(playerid) < price)
	{
		new msg[128];
		format(msg, sizeof(msg), "Недостаточно денег. Необходимо %d руб.", price);
		return SendClientMessage(playerid, 0xFF0000FF, msg), 0;
	}

	new query[512];
	format(query, sizeof query,
		"UPDATE accounts SET money=%d WHERE id=%d LIMIT 1",
		GetPlayerMoneyEx(playerid) - price,
		GetPlayerAccountID(playerid)
	);
	mysql_query(mysql, query, false);

	if(mysql_errno() != 0) return SendClientMessage(playerid, 0xFF0000FF, "Ошибка базы данных. Попробуйте позже."), 0;

	SetPlayerArmour(playerid, Armor[armorid][AR_AMOUNT]);
	GivePlayerMoneyEx(playerid, -price, " ", false, true);

	new playername[24];
	GetPlayerName(playerid, playername, sizeof(playername));
	new chatmsg[128];
	format(chatmsg, sizeof(chatmsg), "%s, вы приобрели %s за %d руб.", playername, Armor[armorid][AR_NAME], price);
	SendClientMessage(playerid, 0xFFFFFFFF, chatmsg);

	new broadcast[128];
	format(broadcast, sizeof(broadcast), "%s приобрел(а) %s", playername, Armor[armorid][AR_NAME]);
	SendClientMessage(-1, 0xFF66CCFF, broadcast);

	new notify[128];
	format(notify, sizeof(notify), "Списано %d руб.", price);
	ShowNotificationLaird(playerid, 0, 6, 0, 0, notify, " ");

	PlayerPlaySound(playerid, 1149, 0.0, 0.0, 0.0);

	g_PlayerSelectedArmor[playerid] = -1;
	return 1;
}
