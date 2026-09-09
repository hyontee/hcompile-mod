#if defined _weapon_shop_included
    #endinput
#endif
#define _weapon_shop_included

new weaponPreviewObject[MAX_PLAYERS];
new WeaponShop_Menu_Kd[MAX_PLAYERS];

stock KeyWalkWeaponShop(playerid)
{
    if(GetPlayerData(playerid, P_WEAPON_LIC) != 1) return GameTextForParams(playerid, 3, "Нет лицензии на оружие", 3000, 0, -1, 1, 0, 3.00);
    
	if(WeaponShop_Menu_Kd[playerid] != 0)
	{
        new word[16];
        GetSecondWordForm(WeaponShop_Menu_Kd[playerid], word, sizeof(word));
		SCMF(playerid, COLOR_GREY, "Пожалуйста, для повторного открытия меню подождите %d %s.", WeaponShop_Menu_Kd[playerid], word);
		return 0;
	}

	SetPlayerVirtualWorld(playerid, playerid + 1);

	SetTimerEx("OpenWeaponShop", 2000, false, "i", playerid);

	WeaponShop_Menu_Kd[playerid] = 2; 

    InterpolateCameraPos(playerid, -2900.626953, 1701.006958, 1002.976928, -2900.552734, 1697.792480, 1002.222534, 2000);
    InterpolateCameraLookAt(playerid, -2898.635253, 1696.960327, 1000.818603, -2900.579833, 1694.161743, 998.784973, 2000);

    return 1;
}

public: WeaponShop_OnChangeCategory(playerid, category)
{
	switch(category)
	{
		case 0:
		{
			WeaponPrew(playerid, 0, 0);
            CEF_CREATE(playerid, 1, 2, "interface('WeaponShop').setCharacteristicsMaxValues('[6]')");
		    CEF_CREATE(playerid, 1, 2, "interface('WeaponShop').setTypes('[\"Холодное оружие\",\"Холодное оружие\"]')");
		}
		case 1:
		{
			WeaponPrew(playerid, 1, 0);
            CEF_CREATE(playerid, 1, 2, "interface('WeaponShop').setCharacteristicsMaxValues('[45,100,100,30]')");
			CEF_CREATE(playerid, 1, 2, "interface('WeaponShop').setTypes('[\"Пистолет\",\"Пистолет\",\"Дробовик\",\"Дробовик\",\"Карабин\",\"Штурмовая винтовка\",\"Штурмовая винтовка\",\"Снайперская винтовка\"]')");
		}
		case 2:
		{
			WeaponPrew(playerid, 2, 0);
            CEF_CREATE(playerid, 1, 2, "interface('WeaponShop').setTypes('[\"Упаковка патронов\",\"Упаковка патронов\",\"Упаковка патронов\",\"Упаковка патронов\",\"Упаковка патронов\",\"Упаковка патронов\",\"Упаковка патронов\"]')");
		}
	}
	return 1;
}
enum WeaponShop
{
    s_obj_id,
    Float:s_obj_x,
    Float:s_obj_y,
    Float:s_obj_z,
    Float:s_obj_RotX,
    Float:s_obj_RotY,
    Float:s_obj_RotZ
}

new const weapon_shop_object[3][8][WeaponShop] =
{
    {
        {331, -2901.26, 1697.08, 1001.02, 83.1, -46.0, 0.0},
        {336, -2901.33, 1696.95, 1001.03, 86.3001, 17.4, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    },

    {
        {346, -2901.24, 1696.92, 1001.02, 92.7999, -54.4, 0.0},
        {348, -2901.25, 1696.95, 1001.02, 86.9002, -53.5, 2.50004},
        {349, -2901.23, 1697.1, 1001.0, 84.2, -69.3999, 0.0},
        {351, -2901.17, 1697.07, 1001.03, 85.1, -69.0, -5.8},
        {353, -2901.19, 1697.07, 1001.07, 91.3, 7.90004, -80.8},
        {355, -2901.21, 1697.04, 1001.03, 81.9999, -70.7, 0.0},
        {356, -2901.23, 1697.02, 1001.03, 87.2999, -62.5, 0.0},
        {357, -2901.2, 1697.07, 1001.07, 90.9, -2.3, -65.4}
    },

    {
        {18532, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18536, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18537, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18531, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18534, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18533, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {18535, -2901.26, 1696.99, 1001.03, 0.0, 0.0, -153.1},
        {0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
    }
};

enum WeaponShopBuy
{
    e_weapon_id,
    e_weapon_name[32],
    e_weapon_price,
    e_p_price,
    e_weapon_count,
    e_p_id,
    e_patron_name[32]
}

new const WeaponBuy[3][8][WeaponShopBuy] =
{
    {
        {1, "Кастет", 8000, 0, 1, 0, ""},
        {5, "Бита", 20000, 0, 1, 0, ""},
        {0, "", 0, 0, 0, ""},
        {0, "", 0, 0, 0, ""},
        {0, "", 0, 0, 0, ""},
        {0, "", 0, 0, 0, ""},
        {0, "", 0, 0, 0, ""},
        {0, "", 0, 0, 0, ""}
    },
    
    {
        {12, "Glock 19", 20000, 4000, 96, 362, "9x19"},
        {19, "Desert Eagle", 80000, 20000, 42, 363, ".44 Magnum"},
        {14, "Remington 870", 50000, 12000, 48, 365, "12x70"},
        {16, "Сайга-12", 60000, 12000, 48, 365, "12x70"},
        {18, "АКС-74У", 70000, 24000, 240, 366, "5.45x39"},
        {21, "AKM", 80000, 40000, 240, 368, "7.62x39"},
        {20, "HK416", 100000, 44000, 240, 367, "5.56x45"},
        {42, "MSR", 120000, 44000, 48, 364, ".338 Magnum"}
    },

    {
        {362, "9x19", 4000, 0, 96, 0, ""},
        {363, ".44 Magnum", 20000, 0, 42, 0, ""},
        {364, ".338 Magnum", 44000, 0, 48, 0, ""},
        {365, "12x70", 12000, 0, 48, 0, ""},
        {366, "5.45x39", 24000, 0, 240, 0, ""},
        {367, "5.56x45", 44000, 0, 240, 0, ""},
        {368, "7.62x39", 40000, 0, 240, 0, ""},
        {0, "", 0, 0, 0, 0, ""}
    }
};
public: WeaponShop_OnSelectItem(playerid, event, item)
{
    if(weapon_shop_object[event][item][s_obj_id] == 0) return 0;

	WeaponPrew(playerid, event, item);
	return 1;
}

public: WeaponShop_OnBuyItem(playerid, event, item, patrons, w_value, p_value)
{
    if(event < 0 || event > 2) return 0;

    if(event == 0 && (item < 0 || item > 1)) return 0;
    if(event == 1 && (item < 0 || item > 7)) return 0;
    if(event == 2 && (item < 0 || item > 6)) return 0;

    if(WeaponBuy[event][item][e_weapon_id] == 0)
        return 0;

    switch(event)
    {
        case 0: HandleMeleeWeapon(playerid, item);
        case 1: HandleWeaponWithAmmo(playerid, item, w_value, p_value);
        case 2: HandleAmmoOnly(playerid, item, w_value);
    }

    UpdateWeaponShopUI(playerid);
    return 1;
}

public: WeaponShop_OnClose(playerid)
{
	if(IsValidDynamicObject(weaponPreviewObject[playerid]))
    {
        DestroyDynamicObject(weaponPreviewObject[playerid]);
        weaponPreviewObject[playerid] = INVALID_STREAMER_ID;
    }
	SetPlayerVirtualWorld(playerid, 340);
    SetCameraBehindPlayer(playerid);
}

public: OpenWeaponShop(playerid)
{
	STRING_GLOBAL[0] = EOS;

    WeaponPrew(playerid, 1, 0);

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "[%s, %d, 750, [\"Пистолет\",\"Пистолет\",\"Дробовик\",\"Дробовик\",\"Карабин\",\"Штурмовая винтовка\",\"Штурмовая винтовка\",\"Снайперская винтовка\"],[45,100,100,30],\
	[[[0,\"Кастет\",0.50,8000,1,[4.00]],[1,\"Бита\",1.00,20000,5,[6.00]]],\
	[[0,\"Glock 19\",0.70,20000,22,[9.00,29,30.00,15],[[9,0],[9,6],[9,12],[8,18],[7,24],[6,30]],0],\
	[1,\"Desert Eagle\",1.70,80000,24,[45.00,10,35.00,7],[[45,0],[45,7],[43,14],[38,21],[34,28],[30,35]],1],\
	[2,\"Remington 870\",3.50,50000,25,[30.00,6,25.00,1],[[30,0],[30,5],[24,10],[17,15],[11,20],[4,25]],3],\
	[3,\"Сайга-12\",3.55,60000,27,[35.00,17,25.00,8],[[35,0],[35,5],[27,10],[20,15],[12,20],[4,25]],3],\
	[4,\"АКС-74У\",3.00,70000,29,[10.00,62,35.00,30],[[10,0],[10,7],[10,14],[9,21],[8,28],[7,35]],4],\
	[5,\"АКМ\",3.50,80000,30,[10.00,49,75.00,30],[[10,0],[10,15],[9,30],[9,45],[8,60],[7,75]],6],\
	[6,\"HK416\",3.75,100000,31,[10.00,53,75.00,30],[[10,0],[10,15],[9,30],[9,45],[8,60],[7,75]],5],\
	[7,\"MSR\",4.20,120000,33,[30.00,6,100.00,1],[[30,0],[30,20],[30,40],[28,60],[24,80],[20,100]],2]],\
	[[0,\"Патроны 9x19\",0.96,4000,1,[0.96,0.01,96],[\"Glock 19\"],\"9x19\"],\
	[1,\"Патроны .44 Magnum\",1.05,20000,2,[1.05,0.02,42],[\"Desert Eagle\"],\".44 Magnum\"],\
	[2,\"Патроны .338 Magnum\",1.44,44000,3,[1.44,0.03,48],[\"AWM\",\"MSR\"],\".338 Magnum\"],\
	[3,\"Патроны 12x70\",1.20,12000,4,[1.20,0.02,48],[\"Remington 870\",\"Обрез\",\"Сайга-12\"],\"12x70\"],\
	[4,\"Патроны 5.45x39\",4.80,24000,5,[4.80,0.02,240],[\"ОЦ-14 Гроза\",\"АКС-74У\"],\"5.45x39\"],\
	[5,\"Патроны 5.56x45\",4.80,44000,6,[4.80,0.02,240],[\"HK416\"],\"5.56x45\"],\
	[6,\"Патроны 7.62x39\",4.80,40000,7,[4.80,0.02,240],[\"АКМ\"],\"7.62x39\"]]], [2.50, 30.00]]", 
	GetPlayerMoneyEx(playerid), GetPlayerCurrentDonate(playerid));
	CEF_CREATE(playerid, 2, 4, "WeaponShop", STRING_GLOBAL);
	return 1;
}

stock ShowWeaponPreview(playerid, modelid, Float:x, Float:y, Float:z, Float:RotX, Float:RotY, Float:RotZ)
{
    if(IsValidDynamicObject(weaponPreviewObject[playerid]))
    {
        DestroyDynamicObject(weaponPreviewObject[playerid]);
        weaponPreviewObject[playerid] = INVALID_STREAMER_ID;
    }

	weaponPreviewObject[playerid] = CreateDynamicObject(modelid, x, y, z, RotX, RotY, RotZ, -1, -1, playerid, 300.0);
	Streamer_Update(playerid);
}

stock GetSecondWordForm(seconds, output[], output_size)
{
    if(seconds % 10 == 1 && seconds % 100 != 11)
    {
        format(output, output_size, "секунду");
    }
    else if(seconds % 10 >= 2 && seconds % 10 <= 4 && (seconds % 100 < 10 || seconds % 100 >= 20))
    {
        format(output, output_size, "секунды");
    }
    else
    {
        format(output, output_size, "секунд");
    }
}

stock WeaponPrew(playerid, event, item)
{
    ShowWeaponPreview(playerid, 
        weapon_shop_object[event][item][s_obj_id], 
        weapon_shop_object[event][item][s_obj_x], 
        weapon_shop_object[event][item][s_obj_y], 
        weapon_shop_object[event][item][s_obj_z], 
        weapon_shop_object[event][item][s_obj_RotX], 
        weapon_shop_object[event][item][s_obj_RotY], 
        weapon_shop_object[event][item][s_obj_RotZ]
    );
    return 1;
}

stock CheckPlayerBalance(playerid, totalCost)
{
    return GetILPlayerInt(GetPlayerMoneyEx(playerid), totalCost);
}

stock ProcessBuy(playerid, totalCost)
{
    GivePlayerMoneyEx(playerid, -totalCost, "Покупка в магазине оружия", true, true);

    new bizProfit = totalCost * 40 / 100;
    AddBusinessProfit(playerid, GetPlayerInBiz(playerid), bizProfit, 1);
}

stock UpdateWeaponShopUI(playerid)
{
    STRING_GLOBAL[0] = EOS;
    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('WeaponShop').setBalance(%s)", GetPlayerMoneyEx(playerid));
    CEF_CREATE(playerid, 1, 2, STRING_GLOBAL);
}

stock HandleMeleeWeapon(playerid, item)
{
    new weaponID = WeaponBuy[0][item][e_weapon_id];
    new price = WeaponBuy[0][item][e_weapon_price];
    
    if(!CheckPlayerBalance(playerid, price)) return 1;

    ProcessBuy(playerid, price);

    GiveWeapon(playerid, weaponID, 1);

    SCMF(playerid, COLOR_ORANGE, "{B9D800}Вы приобрели оружие %s за %d руб.", WeaponBuy[0][item][e_weapon_name], price);

    return 1;
}

stock HandleWeaponWithAmmo(playerid, item, weaponCount, ammoPackCount)
{
    new weaponID = WeaponBuy[1][item][e_weapon_id];
    new price = WeaponBuy[1][item][e_weapon_price];
    new ammoID = WeaponBuy[1][item][e_p_id];
    new ammoPrice = WeaponBuy[1][item][e_p_price];
    new bulletsPerPack = WeaponBuy[1][item][e_weapon_count];

    new totalWeaponCost = weaponCount * price;
    new totalAmmoCost = ammoPackCount * ammoPrice;
    new totalCost = totalWeaponCost + totalAmmoCost;

    if(!CheckPlayerBalance(playerid, totalCost)) return 1;

    ProcessBuy(playerid, totalCost);

    GiveIteam(playerid, weaponID, 1, weaponCount, 0);

    if(ammoPackCount > 0)
    {
        GiveIteam(playerid, ammoID, 1, bulletsPerPack * ammoPackCount, 0);
        SCMF(playerid, COLOR_ORANGE, "{B9D800}Вы приобрели оружие %s (%d шт) и %d упаковки патронов %s (%d шт.) за %d руб.", WeaponBuy[1][item][e_weapon_name], weaponCount, ammoPackCount, WeaponBuy[1][item][e_patron_name], bulletsPerPack * ammoPackCount, totalCost);
    }
    else
    {
        SCMF(playerid, COLOR_ORANGE, "{B9D800}Вы приобрели оружие %s (%d шт) за %d руб.", WeaponBuy[1][item][e_weapon_name], weaponCount, totalCost);
    }

    return 1;
}

stock HandleAmmoOnly(playerid, item, packCount)
{
    new ammoID = WeaponBuy[2][item][e_weapon_id];
    new packPrice = WeaponBuy[2][item][e_weapon_price];
    new bulletsPerPack = WeaponBuy[2][item][e_weapon_count];
    new totalCost = packCount * packPrice;

    if(!CheckPlayerBalance(playerid, totalCost)) return 1;

    ProcessBuy(playerid, totalCost);

    GiveIteam(playerid, ammoID, 1, bulletsPerPack * packCount, 0);

    SCMF(playerid, COLOR_ORANGE, "{B9D800}Вы приобрели %d упаковки патронов %s (%d шт.) за %d руб.", packCount, WeaponBuy[2][item][e_weapon_name], bulletsPerPack * packCount, totalCost);

    return 1;
}