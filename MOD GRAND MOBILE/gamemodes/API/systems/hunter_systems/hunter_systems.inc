
static const Float:hunter_pos[][] = 
{
	{1045.0718,-2671.4106,3.7030},
	{825.3330,-2697.5662,26.4979},
	{649.5901,-2778.2012,7.9820},
	{317.4907,-2825.4297,20.1726},
	{208.0649,-2607.8386,44.2923},
	{59.3985,-2826.9602,33.5252},
	{-67.4843,-2890.1370,33.8866},
	{-184.6195,-2762.7058,39.3513},
	{-285.9872,-2684.8511,44.5290},
	{-547.2320,-2537.5537,1.3686},
	{-601.8312,-2432.5166,28.1319},
	{-663.7325,-2534.2632,28.0369},
	{-807.4494,-2510.4102,29.4351},
	{-824.2710,-2632.1316,29.8132},
	{-1045.7372,-2697.2795,18.4610},
	{-1443.0825,-2525.1104,19.9839},
	{-1541.6224,-2231.9744,34.0807},
	{-1492.4972,-1999.4735,32.8520},
	{-1538.5043,-1805.3905,36.4462},
	{-1716.7810,-1690.6875,42.0392},
	{-1690.8481,-1460.5188,52.0143},
	{-1868.3738,-1402.7521,48.3068},
	{-1984.5223,-1594.2281,47.6177},
	{-2164.8325,-1542.6854,49.9783},
	{-2367.1919,-1394.4562,35.7554},
	{-2429.8381,-1207.8777,35.9931},
	{-2518.1553,-946.1959,34.2467},
	{-2339.1641,-718.8104,37.3616},
	{-2556.2397,-184.6183,22.7040}, 
	{-1972.5765,-512.2784,40.7643},
	{-1697.1541,-665.0191,55.6660},
	{-1825.9069,-1073.3131,44.3506},
	{-1386.4818,-1288.5400,58.5657},
	{-1462.1036,-1512.4312,61.1642},
	{-1582.7635,-1737.4484,42.3338},
	{-2196.1860,-2059.2017,4.6954},
	{-1827.4115,-2670.5669,7.1931},
	{-1645.7990,-2865.0947,14.2687},
	{-1540.0444,-2822.8406,13.6635},
	{-1932.5087,-2779.9934,12.3129},
	{434.1535,-867.8880,34.9902},
	{460.9047,-816.7246,35.0450},
	{470.5439,-758.0743,35.0450},
	{586.7074,-788.4492,35.0450},
	{629.7454,-805.4094,33.1893},
	{543.7194,-1054.8199,29.1680},
	{780.0703,-1114.6827,33.1110},
	{1311.9016,-1178.5203,37.3310},
	{1314.3254,-1087.3423,41.4505},
	{1465.8868,-997.3259,37.3857},
	{1524.6039,-809.2515,41.2825},
	{1389.4878,-1298.9722,15.8098},
	{1420.5449,-1532.9398,14.4698},
	{1418.8525,-1676.9996,3.1027},
	{1268.0619,-1753.6855,11.2278},
	{1169.4581,-1981.1128,3.7415},
	{986.1612,-2135.3662,12.6376},
	{1016.5098,-2287.7024,4.0263},
	{1454.1965,-2476.2410,67.9313},
	{1581.2395,-2068.0986,57.2340},
	{2543.3171,-1401.2020,92.0155},
	{2731.2539,-1600.3823,21.9709},
	{2790.5964,-1962.1783,12.0985},
	{2199.5913,382.5563,18.8449},
	{2064.1150,594.1211,22.7716},
	{1968.9120,852.2599,18.4068},
	{2296.3293,859.3587,15.8969},
	{2434.5166,1015.2714,17.1329},
	{2299.5090,1177.5992,22.6598},
	{2208.6973,1320.1982,20.2202},
	{1953.6116,1355.3925,22.9185},
	{117.7336,2539.5713,16.0123},
	{-608.1624,2420.0264,44.1116},
	{-746.0531,2248.4485,44.0246},
	{-962.9813,2279.7217,42.2182},
	{-2622.6880,76.4131,12.5195},
	{2117.5090,841.4255,16.3667},
	{1278.2100,-900.1326,40.7701},
	{-840.8460,2181.5803,45.0924},
	{-715.0090,2496.6396,39.8128}
};

CMD:goto_hunter(playerid)
{
    if(pData[playerid][pAdmin] < 8) 
    	return NoCMD(playerid);

	new 
		hunter_poss = random(sizeof hunter_pos);

	SetPlayerPos(playerid, hunter_pos[hunter_poss][0], hunter_pos[hunter_poss][1], hunter_pos[hunter_poss][2]);

	return true;
}

stock destroy_hunter(i) 
{

	DestroyDynamicObject(hunter[i][hObject]);
	DestroyDynamic3DTextLabel(hunter[i][hText]);
	DestroyDynamic3DTextLabel(hunter[i][hText_live]);
	DestroyDynamicArea(hunter_zone_damage[i]);

	hunter[i][hSpawned] = false;
	hunter[i][hKilled] = false;
	hunter[i][hKT] = 0;

	return true;
} 


callback:: create_all_hunter() 
{

	for(new i = 0; i < MAX_HUNTER_POSITION; i++) 
	{ 
		if(!hunter[i][hSpawned] && random(2))  
		{
			new 
				hunter_models = hunter_object[random(4)];

			if(hunter_models == 18177)
			{
				hunter[i][hObject] = CreateDynamicObject(hunter_models, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 0.0, 0.0, 0.0, -1, -1, -1, 500.0);

				hunter[i][hText_live] = CreateDynamic3DTextLabel(""cBLUE" ", 0xFFFFFFFF, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 10.0);
				hunter[i][hSpawned] = true;

				hunter_zone_damage[i] = CreateDynamicSphere(hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2], 10.5);

				hunter[i][hunter_model] = hunter_models;
			}
			else if(hunter_models == 18178)
			{
				hunter[i][hObject] = CreateDynamicObject(hunter_models, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 0.0, 0.0, 0.0, -1, -1, -1, 500.0);
				hunter[i][hText_live] = CreateDynamic3DTextLabel(""cBLUE" ", 0xFFFFFFFF, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 10.0);
				hunter[i][hSpawned] = true;

				hunter_zone_damage[i] = CreateDynamicSphere(hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2], 10.5);

				hunter[i][hunter_model] = hunter_models;
			}
			else if(hunter_models == 18179)
			{
				hunter[i][hObject] = CreateDynamicObject(hunter_models, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 0.0, 0.0, 0.0, -1, -1, -1, 500.0);
				hunter[i][hText_live] = CreateDynamic3DTextLabel(""cBLUE" ", 0xFFFFFFFF, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 10.0);
				hunter[i][hSpawned] = true;

				hunter_zone_damage[i] = CreateDynamicSphere(hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2], 10.5);

				hunter[i][hunter_model] = hunter_models;
			}
			else if(hunter_models == 18180)
			{
				hunter[i][hObject] = CreateDynamicObject(hunter_models, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 0.0, 0.0, 0.0, -1, -1, -1, 500.0);
				hunter[i][hText_live] = CreateDynamic3DTextLabel(""cBLUE" ", 0xFFFFFFFF, hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2]-0.5, 10.0);
				hunter[i][hSpawned] = true;

				hunter_zone_damage[i] = CreateDynamicSphere(hunter_pos[i][0]+1, hunter_pos[i][1], hunter_pos[i][2], 10.5);

				hunter[i][hunter_model] = hunter_models;
			}
		}
		if(hunter[i][hSpawned] && hunter[i][hKilled]) 
		{
			if(hunter[i][hKT] > 1) 
			{
				destroy_hunter(i);
			} 
			else 
			{
				hunter[i][hKT]++;
			}
		}
		if(hunter[i][hKT] == 5)
		{
			hunter[i][hKT] = 6;
		}

		if(hunter[i][hKT] >= 6) 
		{
			destroy_hunter(i);
		}
	}
	return true;
}


stock create_hunter_system() 
{

	for(new i = 0; i < sizeof(hunter_pos); i++) 
	{
		hunter[i][hPosX] = hunter_pos[i][hpX];
		hunter[i][hPosY] = hunter_pos[i][hpY];
		hunter[i][hPosZ] = hunter_pos[i][hpZ];
	}

	SetTimer("create_all_hunter", HUNTER_TIME_UPDATE, 1);

	CreateDynamic3DTextLabel(" \n"cLRED" ", -1, -1639.5129,-2107.2820,29.8028, 17.0);
	CreateActor(46, -1639.5129,-2107.2820,29.8028,173.9292); // 
	actor_seller_no_legal_h = create_circle_pickup(-1639.6512,-2108.4402,29.7104, TRIGGER_LRED);

	CreateDynamic3DTextLabel(" \n"cLRED" ", -1, -1499.0259,-2228.8069,34.3277, 17.0);
	CreateActor(51, -1499.0259,-2228.8069,34.3277,128.6679); // 
	actor_seller_hunter = create_circle_pickup(-1500.0608,-2229.7354,34.2995, TRIGGER_LRED);

	return true;
}

public price_seller_hunter_legal()
{
	price_seller_hunter_leg[0] = RandomEx(500, 1500);
	price_seller_hunter_leg[1] = RandomEx(1000, 2500);
	price_seller_hunter_leg[2] = RandomEx(900, 2500);
	price_seller_hunter_leg[3] = RandomEx(1750, 4500);
	return true;
}

stock check_hunter_license(playerid)
{
	if(!pData[playerid][pHunterLic])
	{
		remove_inventory_items_full(playerid, 340);
	}
	return true;
}

stock show_sell_hunter_legal(playerid)
{

	new 
		count_meet[5],
		count_day_hunter[6];


	count_meet[0] = get_inventory_items(playerid, 336);
	count_meet[1] = get_inventory_items(playerid, 337);
	count_meet[2] = get_inventory_items(playerid, 338);
	count_meet[3] = get_inventory_items(playerid, 339);


	count_day_hunter[0] = pData[playerid][pHunterLic];
	count_day_hunter[1] = pData[playerid][pHunterLic];
	count_day_hunter[2] = pData[playerid][pHunterLic];
	count_day_hunter[3] = pData[playerid][pHunterLic];
	count_day_hunter[4] = pData[playerid][pHunterLic];

    format(String2048, sizeof(String2048), "\
        "cGREY"\t"cGREY"\t"cGREY"\n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        \t\n\
        "cBLUE"- "cWH"    (1 )\t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"    (3 )\t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"    (7 )\t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"    (14 )\t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"    (30 )\t"cGR"%d \t"cBLUE"%d \n\
        \t\n\
        "cBLUE"- "cWH"   ?\t"cGREY"\n\
        "cBLUE"- "cWH"  ?\t"cGREY"\n\
        "cBLUE"- "cWH"     ?\t"cGREY"\n\
        "cBLUE"- "cWH"  ?\t"cGREY"",


        price_seller_hunter_leg[0],
        count_meet[0],
        price_seller_hunter_leg[1],
        count_meet[1],
        price_seller_hunter_leg[2],
        count_meet[2],
        price_seller_hunter_leg[3],
        count_meet[3],

		PRICE_BUY_LIC_HUNTER_1,
		count_day_hunter[0],
		PRICE_BUY_LIC_HUNTER_3,
		count_day_hunter[1],
		PRICE_BUY_LIC_HUNTER_7,
		count_day_hunter[2],
		PRICE_BUY_LIC_HUNTER_14,
		count_day_hunter[3],
		PRICE_BUY_LIC_HUNTER_30,
		count_day_hunter[4]

        );
    return SPD(playerid, DIALOG_SELLER_HUNT_LEGAL, DIALOG_STYLE_TABLIST_HEADERS, !""cBLUE" ", String2048, !"", !""); 
}

stock price_seller_hunter()
{
	price_seller_hunter_leg[0] = RandomEx(500, 1500);
	price_seller_hunter_leg[1] = RandomEx(1000, 2500);
	price_seller_hunter_leg[2] = RandomEx(900, 2500);
	price_seller_hunter_leg[3] = RandomEx(1750, 4500);

	price_seller_hunter_no_leg[0] = RandomEx(100, 1000);
	price_seller_hunter_no_leg[1] = RandomEx(500, 1500);
	price_seller_hunter_no_leg[2] = RandomEx(450, 1500);
	price_seller_hunter_no_leg[3] = RandomEx(1550, 3500);

	foreach(new i: logged_players)
	{
		if(pData[i][pHunterLic] > 0)
		{
			SendInf(i, "     !  !");
		}
	}

	return true;
}

stock show_sell_hunter_no_legal(playerid)
{

	new 
		count_meet[5];


	count_meet[0] = get_inventory_items(playerid, 336);
	count_meet[1] = get_inventory_items(playerid, 337);
	count_meet[2] = get_inventory_items(playerid, 338);
	count_meet[3] = get_inventory_items(playerid, 339);

    format(String2048, sizeof(String2048), "\
        "cGREY"\t"cGREY"\t"cGREY"\n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        "cBLUE"- "cWH"  \t"cGR"%d \t"cBLUE"%d \n\
        \t\n\
        "cBLUE"- "cWH"   ?\t"cGREY"\n\
        "cBLUE"- "cWH"  ?\t"cGREY"\n\
        "cBLUE"- "cWH"     ?\t"cGREY"\n\
        "cBLUE"- "cWH"  ?\t"cGREY"",

        price_seller_hunter_no_leg[0],
        count_meet[0],
        price_seller_hunter_no_leg[1],
        count_meet[1],
        price_seller_hunter_no_leg[2],
        count_meet[2],
        price_seller_hunter_no_leg[3],
        count_meet[3]

        );
    return SPD(playerid, DIALOG_SELLER_HUNT_NO_LEGAL, DIALOG_STYLE_TABLIST_HEADERS, !""cBLUE" ", String2048, !"", !""); 
}


stock buy_license_hunter(playerid, type)
{
	switch(type)
	{
		case 1:
		{
			if(GetPlayerMoneyEx(playerid) < PRICE_BUY_LIC_HUNTER_1)
			{
				SendErr(playerid, "    !");
				return show_sell_hunter_legal(playerid);
			}

			show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_CENTER, "brilliantother:notify_player_work_30", 3500);

			give_money(playerid, -PRICE_BUY_LIC_HUNTER_1, "    (1 )");

			pData[playerid][pHunterLic] += 1;

			give_inventory_items(playerid, 340, 1);

			format(String144, sizeof(String144), "  .   - %d !", pData[playerid][pHunterLic]);
			SendSucc(playerid, String144);

			return show_sell_hunter_legal(playerid);
		}
		case 2:
		{
			if(GetPlayerMoneyEx(playerid) < PRICE_BUY_LIC_HUNTER_3)
			{
				SendErr(playerid, "    !");
				return show_sell_hunter_legal(playerid);
			}

			give_money(playerid, -PRICE_BUY_LIC_HUNTER_3, "    (3 )");

			show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_CENTER, "brilliantother:notify_player_work_30", 3500);

			pData[playerid][pHunterLic] += 3;

			give_inventory_items(playerid, 340, 3);

			format(String144, sizeof(String144), "  .   - %d !", pData[playerid][pHunterLic]);
			SendSucc(playerid, String144);

			return show_sell_hunter_legal(playerid);
		}
		case 3:
		{
			if(GetPlayerMoneyEx(playerid) < PRICE_BUY_LIC_HUNTER_7)
			{
				SendErr(playerid, "    !");
				return show_sell_hunter_legal(playerid);
			}

			give_money(playerid, -PRICE_BUY_LIC_HUNTER_7, "    (7 )");

			show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_CENTER, "brilliantother:notify_player_work_30", 3500);

			pData[playerid][pHunterLic] += 7;

			give_inventory_items(playerid, 340, 7);

			format(String144, sizeof(String144), "  .   - %d !", pData[playerid][pHunterLic]);
			SendSucc(playerid, String144);

			return show_sell_hunter_legal(playerid);
		}
		case 4:
		{
			if(GetPlayerMoneyEx(playerid) < PRICE_BUY_LIC_HUNTER_14)
			{
				SendErr(playerid, "    !");
				return show_sell_hunter_legal(playerid);
			}

			give_money(playerid, -PRICE_BUY_LIC_HUNTER_14, "    (14 )");

			show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_CENTER, "brilliantother:notify_player_work_30", 3500);

			pData[playerid][pHunterLic] += 14;

			give_inventory_items(playerid, 340, 14);

			format(String144, sizeof(String144), "  .   - %d !", pData[playerid][pHunterLic]);
			SendSucc(playerid, String144);

			return show_sell_hunter_legal(playerid);
		}
		case 5:
		{
			if(GetPlayerMoneyEx(playerid) < PRICE_BUY_LIC_HUNTER_30)
			{
				SendErr(playerid, "    !");
				return show_sell_hunter_legal(playerid);
			}

			give_money(playerid, -PRICE_BUY_LIC_HUNTER_30, "    (30 )");

			show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_CENTER, "brilliantother:notify_player_work_30", 3500);

			pData[playerid][pHunterLic] += 30;

			give_inventory_items(playerid, 340, 30);

			format(String144, sizeof(String144), "  .   - %d !", pData[playerid][pHunterLic]);
			SendSucc(playerid, String144);

			return show_sell_hunter_legal(playerid);
		}
	}
	return true;
}

stock show_info_hunter_legal(playerid, type)
{
	switch(type)
	{
		case 1:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"   ?", !"\
			"cBLUE" "cWH"\n\n\
			        ,   !\n\
			  -       ?\n\
			   - --- !      !\n\n\
			           !", !"", "");
		}
		case 2:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"  ?", !"\
			"cBLUE" "cWH"\n\n\
			    ,   . -   ,  - !\n\
			   ,      ,   !\n\n\
			 ,         !", !"", "");
		}
		case 3:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"     ?", !"\
			"cBLUE" "cWH"\n\n\
			          !\n\
			  -     ,    ,   !\n\n\
			       ?", !"", "");
		}
		case 4:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"  ?", !"\
			"cBLUE" "cWH"\n\n\
			   ,       !\n\n\
			   ,        **", !"", "");
		}
	}


	return true;
}

stock show_info_hunter_no_legal(playerid, type)
{
	switch(type)
	{
		case 1:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_NO_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"   ?", !"\
			"cBLUE" "cWH"\n\n\
			  ,   ,    !\n\
			   ? !        !\n\n\
			    -    !", !"", "");
		}
		case 2:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_NO_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"  ?", !"\
			"cBLUE" "cWH"\n\n\
			    ,   . -   ,  - !\n\
			   ,      ,   !\n\n\
			 ,         !", !"", "");
		}
		case 3:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_NO_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"     ?", !"\
			"cBLUE" "cWH"\n\n\
			   -    ,    !\n\
			    ,   ,     !", !"", "");
		}
		case 4:
		{
			SPD(playerid, DIALOG_BACK_HUNTER_NO_LEGAL, DIALOG_STYLE_MSGBOX, !""cBLUE"  ?", !"\
			"cBLUE" :"cWH"\n\n\
			   ,       !\n\n\
			   ,        **", !"", "");
		}
	}


	return true;
}

stock select_count_sell_meat(playerid, type)
{

	if(!pData[playerid][pHunterLic])
		return SendErr(playerid, "        !");

	switch(type)
	{
		case 0:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_leg[0], get_inventory_items(playerid, 336));
			SPD(playerid, DIALOG_SELL_LEG_MEET_1, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 1:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_leg[1], get_inventory_items(playerid, 337));
			SPD(playerid, DIALOG_SELL_LEG_MEET_2, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 2:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_leg[2], get_inventory_items(playerid, 338));
			SPD(playerid, DIALOG_SELL_LEG_MEET_3, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 3:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_leg[3], get_inventory_items(playerid, 339));
			SPD(playerid, DIALOG_SELL_LEG_MEET_4, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
	}


	return true;
}

stock select_count_sell_meat_n(playerid, type)
{
	switch(type)
	{
		case 0:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_no_leg[0], get_inventory_items(playerid, 336));
			SPD(playerid, DIALOG_SELL_LEG_MEET_1_N, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 1:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_no_leg[1], get_inventory_items(playerid, 337));
			SPD(playerid, DIALOG_SELL_LEG_MEET_2_N, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 2:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_no_leg[2], get_inventory_items(playerid, 338));
			SPD(playerid, DIALOG_SELL_LEG_MEET_3_N, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
		case 3:
		{
			format(String256, sizeof(String256), "\
				"cWH"     ?\n\n\
				"cWH" : "cGR"%d"cWH" \n\
				"cWH"   : "cBLUE"%d"cWH" ", price_seller_hunter_no_leg[3], get_inventory_items(playerid, 339));
			SPD(playerid, DIALOG_SELL_LEG_MEET_4_N, DIALOG_STYLE_INPUT, !""cBLUE"  ", String256, !"", !"");			
		}
	}


	return true;
}

stock dialog_all_hunter(playerid, dialogid, response, listitem, inputtext[])
{

	switch(dialogid)
	{

		case DIALOG_BACK_HUNTER_NO_LEGAL:
		{
			if(!response)
				return show_sell_hunter_no_legal(playerid);

			return show_sell_hunter_no_legal(playerid);			
		}
		case DIALOG_SELL_LEG_MEET_1_N:
		{
			if(!response)
				return show_sell_hunter_no_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_no_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			if(get_inventory_items(playerid, 336) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			check_remove_inventory(playerid, 336, get_inventory_items_slot(playerid, 336), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_no_leg[0];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_2_N:
		{
			if(!response)
				return show_sell_hunter_no_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_no_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			if(get_inventory_items(playerid, 337) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			check_remove_inventory(playerid, 337, get_inventory_items_slot(playerid, 337), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_no_leg[1];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_3_N:
		{
			if(!response)
				return show_sell_hunter_no_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_no_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			if(get_inventory_items(playerid, 338) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			check_remove_inventory(playerid, 338, get_inventory_items_slot(playerid, 338), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_no_leg[2];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_4_N:
		{
			if(!response)
				return show_sell_hunter_no_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_no_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			if(get_inventory_items(playerid, 339) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_no_legal(playerid);				
			}

			check_remove_inventory(playerid, 339, get_inventory_items_slot(playerid, 339), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_no_leg[3];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}


		case DIALOG_SELL_LEG_MEET_1:
		{
			if(!response)
				return show_sell_hunter_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			if(get_inventory_items(playerid, 336) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			check_remove_inventory(playerid, 336, get_inventory_items_slot(playerid, 336), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_leg[0];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_2:
		{
			if(!response)
				return show_sell_hunter_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			if(get_inventory_items(playerid, 337) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			check_remove_inventory(playerid, 337, get_inventory_items_slot(playerid, 337), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_leg[1];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_3:
		{
			if(!response)
				return show_sell_hunter_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			if(get_inventory_items(playerid, 338) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			check_remove_inventory(playerid, 338, get_inventory_items_slot(playerid, 338), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_leg[2];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELL_LEG_MEET_4:
		{
			if(!response)
				return show_sell_hunter_legal(playerid);

			if(!IsNumeric(inputtext) || !strlen(inputtext))
			{
				SendErr(playerid,"   !");
				return show_sell_hunter_legal(playerid);
			}

			new 
				count_meet_sell = strval(inputtext);

			if(count_meet_sell < 1)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			if(get_inventory_items(playerid, 339) < count_meet_sell)
			{
				SendErr(playerid,"      !");
				return show_sell_hunter_legal(playerid);				
			}

			check_remove_inventory(playerid, 339, get_inventory_items_slot(playerid, 339), -count_meet_sell);

			new 	
				final_money = count_meet_sell*price_seller_hunter_leg[3];

		 	format(String144, sizeof(String144), "    ", final_money);
			give_money(playerid, final_money, String144);					
		}

		case DIALOG_SELLER_HUNT_LEGAL:
		{
			if(!response)
				return true;

			switch(listitem)
			{
				case 0: return select_count_sell_meat(playerid, 0);
				case 1: return select_count_sell_meat(playerid, 1);
				case 2: return select_count_sell_meat(playerid, 2);
				case 3: return select_count_sell_meat(playerid, 3);
				case 4: return show_sell_hunter_legal(playerid);
				case 5: return buy_license_hunter(playerid, 1);
				case 6: return buy_license_hunter(playerid, 2);
				case 7: return buy_license_hunter(playerid, 3);
				case 8: return buy_license_hunter(playerid, 4);
				case 9: return buy_license_hunter(playerid, 5);
				case 10: return show_sell_hunter_legal(playerid);
				case 11: return show_info_hunter_legal(playerid, 1);
				case 12: return show_info_hunter_legal(playerid, 2);
				case 13: return show_info_hunter_legal(playerid, 3);
				case 14: return show_info_hunter_legal(playerid, 4);
			}
		}

		case DIALOG_SELLER_HUNT_NO_LEGAL:
		{
			if(!response)
				return true;

			switch(listitem)
			{
				case 0: return select_count_sell_meat_n(playerid, 0);
				case 1: return select_count_sell_meat_n(playerid, 1);
				case 2: return select_count_sell_meat_n(playerid, 2);
				case 3: return select_count_sell_meat_n(playerid, 3);
				case 4: return show_sell_hunter_no_legal(playerid);
				case 5: return show_info_hunter_no_legal(playerid, 1);
				case 6: return show_info_hunter_no_legal(playerid, 2);
				case 7: return show_info_hunter_no_legal(playerid, 3);
				case 8: return show_info_hunter_no_legal(playerid, 4);
			}
		}

		case DIALOG_BACK_HUNTER_LEGAL:
		{
			if(!response)
				return show_sell_hunter_legal(playerid);

			return show_sell_hunter_legal(playerid);
		}
	}


	return true;
}