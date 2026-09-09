static Craft_Buffer[65536];
new Craft_kd[MAX_PLAYERS];

enum E_CRAFT_RECIPE
{
	RECIPE_INDEX,
	RECIPE_SOURCE,
	RECIPE_ITEMID,
	RECIPE_NAME[32],
	RECIPE_CATEGORY,
	RECIPE_BRENCH,
	RECIPE_CHANCE,
	RECIPE_PRICE,
	RECIPE_COMP_COUNT,
	
	RECIPE_COMP[48]
};

static const Craft_Recipes[][E_CRAFT_RECIPE] =
{
    {0,  0,   31, "Кастет",                    3, 1,  0,       0,  2, {124,10,0, 157,1,0}},
    {1,  0,   29, "Отмычка",                   4, 0,  0,       0,  2, {124,5,0,  137,1,0}},
    {2,  0,    2, "Аптечка",                   4, 0,  0,       0,  3, {142,1,0,  299,3,0,  141,1,0}},
    {3,  0,  151, "Денежная печат.машинка",    5, 0,  0,       0,  3, {152,3,0,  153,1,0,  160,1,0}},
    {4,  0,   15, "Обрез",                     3, 1,  0,       0,  2, {14,1,0,   158,1,0}},
    {5,  0,   22, "Снайперская винтовка",      3, 1,  0,       0,  2, {42,1,0,   146,1,0}},
    {6,  0,  123, "Ноутбук Apple",             5, 0,  0,       0,  2, {75,1,0,   150,1,0}},
    {7,  2, 9991, "Bandos",                    7, 1,  0,       0,  6, {156,2,0,  155,4,0,  154,5,0,  124,100,0, 153,5,0,  106,1,0}},
    {8,  0,  218, "Запчасти к двигателю",      5, 1,  0,       0,  3, {124,100,0,153,1,0,  138,3,0}},
    {9,  0,  179, "Материалы для оружия",      1, 1,  0,       0,  3, {124,50,0, 153,1,0,  144,1,0}},
    {10, 0,  119, "Руль AMG",                  5, 0,  0,       0,  2, {189,1,0,  190,20,0}},
    {11, 0,   44, "Рем.комплект",              4, 0,  0,       0,  2, {124,20,0, 153,1,0}},
    {12, 2, 9992, "Ford Shelby Cobra 42",      7, 1,  0,       0,  9, {156,2,0,  155,4,0,  154,5,0,  124,350,0, 153,3,0,  188,1,0,  189,1,0,  190,30,0, 191,4,0}},
    {13, 2, 9993, "Napier Railton",            7, 1,  0,       0,  9, {156,4,0,  155,4,0,  154,10,0, 124,350,0, 153,9,0,  188,3,0,  189,1,0,  190,50,0, 191,4,0}},
    {14, 0,  180, "Сабвуфер",                  5, 1,  0,       0,  2, {304,1,0,  305,1,0}},
    {15, 0,  127, "Металлоискатель BHJ",       1, 1,  0,       0,  2, {306,1,0,  307,1,0}},
    {16, 0,  125, "Лопата",                    1, 1,  0,       0,  2, {308,1,0,  309,1,0}},
    {17, 0,  254, "Аппарат для диагностики",   1, 1,  0,       0,  2, {310,1,0,  311,1,0}},
    {18, 0,  164, "Наручные часы",             0, 1,  0,       0,  4, {312,1,0,  313,1,0,  314,1,0,  315,1,0}},
    {19, 0,  100, "Одежда",                    2, 1,  0,       0,  3, {317,1,0,  318,1,0,  319,1,0}},
    {20, 0, 9955, "Ремонт бронежилета",        6, 1,  0,       0,  3, {154,2,0,  138,1,0,  323,2,0}},
    {21, 0,  323, "Бронепластина",             1, 1,  0,       0,  1, {124,45,0}},
    {22, 2,15639, "ZAZ E-Zaz",                 7, 1, 10,       0, 10, {156,6,0,  155,4,0,  301,2,0,  122,4,0,  191,4,0,  124,250,0, 180,2,0,  105,2,0,  543,1,2, 555,1,2}},
    {23, 0,  110, "Телефон iPhone",            5, 0,  0,       0,  2, {148,1,0,  149,2,0}},
    {24, 2,15649, "Chevrolet Camper",          7, 1, 45, 1500000, 12, {156,2,0,  188,1,0,  122,4,0,  190,10,0, 301,1,0,  155,4,0,  191,1,0,  124,350,0, 180,1,0,  192,1,0,  104,4,0, 77,1,0}},
    {25, 1,15563, "Хасбик Шейх",               2, 1, 35,10000000,  5, {15850,2,3,15849,1,3,15498,1,1,332,1,0,  138,5,0}},
    {26, 0,  331, "Канистра для воды",         1, 1,  0,       0,  2, {124,5,0,  153,1,0}},
    {27, 1,15559, "МакГрегор Поло",            2, 1, 35, 9000000,  5, {14628,1,3,15848,1,3,175,1,1,  332,1,0,  138,5,0}},
    {28, 1,15588, "Богданчик в футболке",      2, 1, 15, 4500000,  5, {15751,1,3,16224,1,3,15426,1,1,332,1,0,  200,1,0}},
    {29, 1,17029, "Санрайз в майке",           2, 1, 50, 2500000,  4, {17014,1,1,22,1,1,  318,1,0,  332,1,0}},
    {30, 1,17041, "Мэлстрой Гучи",             2, 1, 13, 5000000,  5, {15518,1,1,13962,1,3,14614,1,3,14628,1,3,332,1,0}},
    {31, 1,17032, "Аарон Плей",                2, 1, 35, 2500000,  4, {15434,1,1,466,2,2,  259,1,2,  332,1,0}},
    {32, 2,15680, "ZIL 131 КУНГ",              7, 1, 30, 8000000,  9, {68,1,0,   106,2,0,  124,350,0,156,2,0,  188,1,0,  155,4,0,  122,4,0,  191,1,0,  154,10,0}},
    {33, 2,15686, "Rolls Royce Spectre",       7, 1, 15,10000000, 12, {409,1,2,  502,2,2,  15146,1,2,156,1,0,  188,1,0,  155,4,0,  122,4,0,  106,2,0,  124,350,0,191,1,0,  119,1,0,  153,5,0}},
    {34, 0,15685, "Mercedes SL 63 MANSORY",    7, 1,  0,       0,  2, {15684,1,2,354,1,0}},
    {35, 1,17058, "Наглаженный Тёмчик",        2, 1, 25, 5000000,  6, {17051,1,1,186,1,1,  15485,1,1,14615,1,3,332,1,0,  47,1,0}},
    {36, 2,15689, "Lamborghini Revuelto",      7, 1, 40,10000000,  9, {415,1,2,  605,1,2,  156,1,0,  106,2,0,  188,1,0,  122,4,0,  190,30,0, 153,3,0,  155,4,0}},
    {37, 1,17067, "Малфой",                    2, 1,  5,  100000,  6, {317,1,0,  318,1,0,  319,1,0,  110,1,0,  111,1,0,  332,1,0}},
    {38, 2,  423, "GAZ Spooky Bus",            7, 1,  0,       0,  2, {15692,1,2,358,1,0}},
    {39, 2,15696, "BMW M5 G90",                7, 1, 20, 2500000,  8, {15107,2,2,612,1,2,  13978,1,3,156,1,0,  106,2,0,  188,1,0,  124,200,0,153,2,0}},
    {40, 0,  369, "Болгарка",                  4, 1,  0,       0,  4, {124,50,0, 153,1,0,  156,1,0,  370,1,0}},
    {41, 1,17080, "Стэн Лютер",                2, 1, 30, 1000000,  8, {15420,1,1,15298,1,2,19006,1,3,111,5,0,  8,1,0,    47,1,0,  332,1,0}},
    {42, 2,17425, "GAZ Volgatti",              7, 1, 20, 2100000,  9, {15085,1,2,15694,1,2,156,1,0,  106,2,0,  188,1,0,  122,4,0,  153,2,0,  155,4,0,  154,10,0}},
    {43, 1,17066, "Янг Харди",                 2, 1, 30,50000000,  2, {17048,1,1,15331,1,1}},
    {44, 0,  375, "Лом",                       4, 1,  0,       0,  3, {124,50,0, 153,1,0,  154,1,0}},
    {45, 2,17432, "Ferrari SF90 XX",           7, 1, 30,18000000, 12, {15252,1,2,15182,1,2,451,1,2, 156,2,0,  106,2,0,  188,1,0,  155,4,0,  122,4,0,  153,2,0,  191,1,0,  124,300,0,154,2,0}},
    {46, 2,17443, "Mercedes Brabus Rocket G",  7, 1, 50,       0,  9, {15684,1,2,15645,2,2,15685,1,2,  122,4,0,  156,1,0,  188,1,0,  106,2,0,  124,300,0,191,1,0}},
    {47, 2,17451, "Volkswagen Multivan Bunker",  7, 1, 40,       0,  11, {15117,2,2, 17450,2,2, 156,1,0, 188,1,0, 155,4,0,  122,4,0, 105,2,0, 153,2,0, 154,1,0, 191,1,0, 323,10,0}}
};

stock Craft_GetPlayerItemCount(playerid, itemid)
{
	new count;
	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_TYPE) != 1) continue;
		if(GetPlayerItem(i, PI_TYPE_ITEM) != 0) continue;
		if(GetPlayerItem(i, PI_ITEM) != itemid) continue;
		count = GetPlayerItem(i, PI_COUNT);
		return count;
	}
	return count;
}

stock Craft_GetPlayerSkinCount(playerid, skinid)
{
	new count;
	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_SKIN_ID) != skinid) continue;
		count++;
	}
	return count;
}

stock Craft_GetPlayerCarCount(playerid, carid)
{
	//Debug_ShowPlayerCars(playerid);
    new count;
    new query[128];

    mysql_format(
        mysql,
        query,
        sizeof query,
        "SELECT COUNT(*) AS cnt FROM ownable_cars WHERE owner_id=%d AND model_id=%d",
        GetPlayerAccountID(playerid),
        carid
    );

    new Cache:cache = mysql_query(mysql, query, true);

    if(cache_num_rows() > 0)
    {
        count = cache_get_field_content_int(0, "cnt");
    }

    cache_delete(cache);
    return count;
}

stock Craft_GetPlayerAllCarsCount(playerid) {
	new count;
	new query[128];
	mysql_format(mysql, query, sizeof query, "SELECT COUNT(*) FROM ownable_cars WHERE owner_id=%d", GetPlayerAccountID(playerid));
	new Cache:result = mysql_query(mysql, query, true);
	if(cache_num_rows() > 0)
	{
		count = cache_get_field_content_int(0);
	}
	cache_delete(result);
	return count;
}



stock Craft_GetPlayerAccessoryCount(playerid, aksid)
{
	new count;
	for(new i; i < MAX_PLAYER_ITEMS; i++)
	{
		if(GetPlayerItem(i, PI_OWNER_ID) != GetPlayerAccountID(playerid)) continue;
		if(GetPlayerItem(i, PI_AKS_ID) != aksid) continue;
		count++;
	}
	return count;
}

stock Craft_GetComponentCount(playerid, sourcetype, itemid)
{
	switch(sourcetype)
	{
		case 0: return Craft_GetPlayerItemCount(playerid, itemid);
		case 1: return Craft_GetPlayerSkinCount(playerid, itemid);
		case 2: return Craft_GetPlayerCarCount(playerid, itemid);
		case 3: return Craft_GetPlayerAccessoryCount(playerid, itemid);
	}
	return 0;
}
CMD:craft(playerid)
{
    if(Craft_kd[playerid] != 0)
        return GameText(playerid, "~y~Подождите немного..", 1500, 2);

    Craft_Buffer[0] = EOS;
    strcat(Craft_Buffer, "[3000,[[");

    new bool:first_recipe = true;
    new item[1024], comp[128], comps[1024];

    for(new i = 0; i < sizeof(Craft_Recipes); i++)
    {
        comps[0] = EOS;

        for(new c = 0; c < Craft_Recipes[i][RECIPE_COMP_COUNT]; c++)
        {
            new itemid  = Craft_Recipes[i][RECIPE_COMP][c * 3];
            new count   = Craft_Recipes[i][RECIPE_COMP][c * 3 + 1];
            new type    = Craft_Recipes[i][RECIPE_COMP][c * 3 + 2];

            new have = Craft_GetComponentCount(playerid, type, itemid);

            format(comp, sizeof(comp),
                "%s[%d,%d,%d,%d]",
                (c == 0) ? "" : ",",
                type,
                itemid,
                count,
                have
            );
            strcat(comps, comp);
        }

        format(item, sizeof(item),
            "%s[%d,%d,%d,\"%s\",%d,%d,%d,%d,[%s]]",
            first_recipe ? "" : ",",

            Craft_Recipes[i][RECIPE_INDEX],
            Craft_Recipes[i][RECIPE_SOURCE],
            Craft_Recipes[i][RECIPE_ITEMID],
            Craft_Recipes[i][RECIPE_NAME],

            Craft_Recipes[i][RECIPE_CATEGORY],
            Craft_Recipes[i][RECIPE_BRENCH],
            Craft_Recipes[i][RECIPE_CHANCE],
            Craft_Recipes[i][RECIPE_PRICE],

            comps
        );

        strcat(Craft_Buffer, item);
        first_recipe = false;
    }

    strcat(Craft_Buffer, "]],1]");
    SendClientEventWithArg(playerid, t_CefShow, "Craft", Craft_Buffer);

    Craft_kd[playerid] = 3;
    return 1;
}
new craftfinish[MAX_PLAYERS] = -1;

stock OnPlayerCraftingFinish(playerid)
{
    new r = craftfinish[playerid];
    if(r < 0 || r >= sizeof(Craft_Recipes)) return 1;

    if(!GetILPlayerInt(GetPlayerMoneyEx(playerid), Craft_Recipes[r][RECIPE_PRICE]))
        return GameText(playerid, "~r~Недостаточно~n~средств", 3000, 2);

    for(new c2; c2 < Craft_Recipes[r][RECIPE_COMP_COUNT]; c2++)
    {
        new ci = Craft_Recipes[r][RECIPE_COMP][c2*3];
        new cq = Craft_Recipes[r][RECIPE_COMP][c2*3+1];
        new ct = Craft_Recipes[r][RECIPE_COMP][c2*3+2];

        switch(ct)
        {
            case 0:
            {
                GiveIteam(playerid, ci, 0, cq, 0);
            }
            case 1:
            {
                DestroySkin(playerid, ci, cq);
            }
            case 2:
            {
                Craft_RemovePlayerCars(playerid, ci, cq);
            }
            case 3:
            {
                DestroyAcs(playerid, ci, cq);
            }
        }
    }

    if(Craft_Recipes[r][RECIPE_PRICE] > 0)
        GivePlayerMoneyEx(playerid, -Craft_Recipes[r][RECIPE_PRICE], "Крафт");

    new roll = random(100) + 1;
    new success = (Craft_Recipes[r][RECIPE_CHANCE] == 0) ? 1 : ((roll <= Craft_Recipes[r][RECIPE_CHANCE]) ? 1 : 0);

    if(success)
    {
        switch(Craft_Recipes[r][RECIPE_SOURCE])
        {
            case 0: // предмет
            {
                new itemid = Craft_Recipes[r][RECIPE_ITEMID];

                if(itemid == 31)
                {
                    GivePlayerWeapon(playerid, 1, 1);
                }
                else if(itemid == 15)
                {
                    GivePlayerWeapon(playerid, 26, 80);
                }
                else if(itemid == 22)
                {
                    GivePlayerWeapon(playerid, 34, 30);
                }
                else
                {
                    GivePlayerMyPrizes(playerid,
                        Craft_Recipes[r][RECIPE_NAME],
                        8,
                        itemid,
                        0,
                        1,
                        -1);
                }
            }

            case 1: // скин
            {
                new skin = Craft_Recipes[r][RECIPE_ITEMID];

                GivePlayerMyPrizes(playerid,
                    Craft_Recipes[r][RECIPE_NAME],
                    4,
                    skin,
                    0,
                    1,
                    -1);
            }

            case 2: // машина
            {
                new car = Craft_Recipes[r][RECIPE_ITEMID];

                GivePlayerMyPrizes(playerid,
                    Craft_Recipes[r][RECIPE_NAME],
                    3,
                    car,
                    0,
                    1,
                    -1);
            }
        }

        GameText(playerid, "~g~Успешно вадима забрали тцк", 3000, 3);
        SendClientEvent(playerid, t_CefUpdate, "interface('Craft').showResult()");
        OnBattlePass_Perfomance(playerid, 15, 1);
    }
    else
    {
        GameText(playerid, "~r~Неудача юра влюбился в хиллера", 3000, 3);
        SendClientEvent(playerid, t_CefHide, "Craft");
    }

    return 1;
}

stock Debug_ShowPlayerCars(playerid) {
	new query[256];
	mysql_format(mysql, query, sizeof query, "SELECT id, model_id FROM ownable_cars WHERE owner_id=%d", GetPlayerAccountID(playerid));
	printf("[DEBUG] Debug_ShowPlayerCars: playerid=%d, query=%s", playerid, query);
	new Cache:result = mysql_query(mysql, query, true);
	new rows = cache_num_rows();
	printf("[DEBUG] Debug_ShowPlayerCars: found %d cars", rows);
	for(new i = 0; i < rows; i++) {
		new car_id = cache_get_field_content_int(i, "id");
		new model_id = cache_get_field_content_int(i, "model_id");
		printf("[DEBUG] Car %d: id=%d, model_id=%d", i, car_id, model_id);
	}
	cache_delete(result);
}


stock Craft_RemovePlayerCars(playerid, modelid, amount)
{
    new query[256];

    mysql_format(
        mysql,
        query,
        sizeof query,
        "DELETE FROM ownable_cars \
         WHERE owner_id=%d AND model_id=%d \
         ORDER BY id ASC \
         LIMIT %d",
        GetPlayerAccountID(playerid),
        modelid,
        amount
    );

    mysql_tquery(mysql, query);
    return 1;
}
forward Craft_KD_Timer(playerid);
public Craft_KD_Timer()
{
    foreach(new i : Player)
    {
        if(Craft_kd[i] > 0)
            Craft_kd[i]--;
    }
}
