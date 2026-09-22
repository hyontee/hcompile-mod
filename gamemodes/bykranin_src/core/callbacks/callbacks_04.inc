//>> Файл: bykranin_src/core/callbacks/callbacks_04.inc  (231 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: HidePlayerSelectPanelPriceTimer, OnVehicleMod, OnVehiclePaintjob, OnVehicleRespray, OnPlayerSelectedMenuRow, OnPlayerExitedMenu, OnPlayerInteriorChange
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: HidePlayerSelectPanelPriceTimer(playerid)
{
	if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_NONE)
	{
		HidePlayerSelectPanelPrice(playerid);
	}
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
    // A legitimate client can emit this while custom tuning is being restored.
    // Returning 0 rejects an unsolicited modification without disconnecting it.
    printf("[TUNING][CLIENT_MOD_REJECTED] player=%d vehicle=%d component=%d", playerid, vehicleid, componentid);
    return 0;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
    printf("[TUNING][CLIENT_PAINTJOB_REJECTED] player=%d vehicle=%d paintjob=%d", playerid, vehicleid, paintjobid);
    return 0;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
    printf("[TUNING][CLIENT_RESPRAY_REJECTED] player=%d vehicle=%d colors=%d/%d", playerid, vehicleid, color1, color2);
    return 0;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	if(GetPlayerMenu(playerid) == admin_spec_menu)
	{
		if(GetPlayerSpectateData(playerid, S_PLAYER) == -1) return HideMenuForPlayer(admin_spec_menu, playerid);

		new fmt_text[100],
			spec_player = GetPlayerSpectateData(playerid, S_PLAYER);

		switch(row)
		{
			case 0, 8: StopSpectate(playerid);
			case 1:
			{
				StartSpectate(playerid, spec_player);
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 2:
			{
				//ShowPlayerStats(spec_player, playerid);
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 3:
			{
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 4:
			{
				format(fmt_text, sizeof fmt_text, "%d 5", spec_player);
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 5:
			{
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 6:
			{
				// callcmd::test(playerid, IntToString(spec_player));
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
			case 7:
			{
				format(fmt_text, sizeof fmt_text, "[SP] %s[%d]  |  PING %d  |  IP  %s  |  R-IP  %s",
				GetPlayerNameEx(spec_player), spec_player, GetPlayerPing(spec_player), GetPlayerIpEx(spec_player), GetPlayerData(spec_player, P_REG_IP));
				SendClientMessage(playerid, 0x00CC66FF, fmt_text);
				ShowMenuForPlayer(admin_spec_menu, playerid);
			}
		}
	}

	/*
	if(GetPlayerMenu(playerid) == reg_select_skin_menu)
    {
		if(!IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
			{
				new sex = GetPlayerSex(playerid);
				new select_skin = GetPlayerSelectSkin(playerid);

				switch(row)
				{
					case 0:
					{
						if(++select_skin >= sizeof reg_skin_data[] || !reg_skin_data[sex][select_skin])
						{
							select_skin = 0;
						}
					}
					case 1:
					{
						if(--select_skin < 0)
						{
							select_skin = sizeof(reg_skin_data[])-1;

							if(!sex)
								select_skin -= 2;
						}
					}
					case 2:
					{
						SetPlayerData(playerid, P_SKIN, reg_skin_data[sex][select_skin]);

						new query[90];
						format(query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							SetPlayerData(playerid, P_MONEY, 500);
							SetPlayerData(playerid, P_SELECT_SKIN, -1);

							HideMenuForPlayer(reg_select_skin_menu, playerid);

							SetPlayerSpawnInit(playerid);
							SpawnPlayer(playerid);

							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
							SetPlayerInit(playerid);

							SendClientMessage(playerid, 0xFFFF00FF, "Рекомендуем прочитать раздел {FF3300}Помощь по игре.{FFFF00} Он находится слева от Вас");
							SendClientMessage(playerid, 0xFFFF00FF, "В нем Вы найдете всю интересующую Вас информацию. Удачи и приятной игры!");

							return 1;
						}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 01)");
					}
				}

				SetPlayerSelectSkin(playerid, select_skin, reg_skin_data[sex][select_skin]);
				ShowMenuForPlayer(reg_select_skin_menu, playerid);
			}
		}
    }
	*/
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	/*
	if(GetPlayerMenu(playerid) == reg_select_skin_menu)
	{
		if(!IsPlayerLogged(playerid))
		{
			if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_REG_SKIN)
			{
				ShowMenuForPlayer(reg_select_skin_menu, playerid);
			}
		}
	}
	*/
	if(GetPlayerMenu(playerid) == admin_spec_menu)
	{
		if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
		{
			ShowMenuForPlayer(admin_spec_menu, playerid);
		}
	}
	return 1;
}

#define DIALOG_SELECT_PLAYER_PROPERTY 5501
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}
#define VEHICLE_MODEL_OFFSET 400

enum E_SELLCAR_PRICE_MAP
{
    SELLCAR_MODEL_ID,
    SELLCAR_PRICE
};
#define MAX_VEHICLE_JSON_ID 537

static const VehicleIdToModelId[MAX_VEHICLE_JSON_ID+1] =
{
    0,400,401,402,403,404,405,406,407,408,409,410,411,412,413,414,415,416,417,418,419,420,421,
    422,423,424,425,426,427,428,429,430,431,432,433,434,435,436,437,438,439,440,441,442,443,
    444,445,446,447,448,449,450,451,452,453,454,455,456,457,458,459,460,461,462,463,464,465,
    466,467,468,469,470,471,472,473,474,475,476,477,478,479,480,481,482,483,484,485,486,487,
    488,489,490,491,492,493,494,495,496,497,498,499,500,501,502,503,504,505,506,507,508,509,
    510,511,512,513,514,515,516,517,518,519,520,521,522,523,524,525,526,527,528,529,530,531,
    532,533,534,535,536,537,538,539,540,541,542,543,544,545,546,547,548,549,550,551,552,553,
    554,555,556,557,558,559,560,561,562,563,564,565,566,567,568,569,570,571,572,573,574,575,
    576,577,578,579,580,581,582,583,584,585,586,587,588,589,590,591,592,593,594,595,596,597,
    598,599,600,601,602,603,604,605,606,607,608,609,610,611,2543,2544,2545,2546,2547,2548,2549,
    2550,2551,2552,2553,2554,2555,2556,2557,2558,2559,2560,2561,2562,2563,2564,2565,2566,2567,
    2568,2569,2570,2571,2572,2573,2574,2575,2576,2577,2578,2579,2580,2581,2582,2583,2584,2585,
    2586,2587,2588,2589,2590,2591,2592,2593,2594,2595,2596,2597,2598,2599,2600,2601,2602,2603,
    2604,2605,2606,2607,2608,2609,2610,2611,2612,2613,2614,2615,2616,2617,2618,2619,2620,2621,
    2622,2623,2624,2625,2626,2627,2628,2629,2630,2631,2632,2633,2371,2372,2373,2374,2375,2376,
    2377,2378,2379,2380,2381,2382,2383,2384,2385,2386,2387,2388,2389,2390,2391,2392,2393,2394,
    2395,2396,2397,2398,2399,2400,2401,2402,2403,2404,2405,2406,2407,2408,2409,665,666,667,
    668,669,670,671,672,673,674,675,678,679,680,681,682,638,639,640,641,642,643,644,645,646,
    647,648,649,650,651,652,653,654,655,656,657,658,612,613,614,615,616,617,618,619,620,621,
    622,623,624,625,626,627,628,629,630,631,632,633,634,635,636,659,660,661,739,740,741,742,
    743,744,745,746,747,637,748,749,750,751,752,753,754,755,756,757,758,0,0,0,0,759,760,761,
    762,763,764,765,766,767,768,769,770,771,772,2392,28654,28655,28656,28657,28658,28659,28660,
    28661,28662,28663,28667,28673,28674,28675,28676,28677,28678,28679,28680,28681,28682,28683,
    28669,28670,28671,28672,28664,28665,28666,28668,28684,28685,28686,28687,28688,28689,28690,
    28691,28692,28693,28694,28695,28696,28697,28698,28699,28700,28701,28702,28703,28704,28705,
    28706,28707,28708,28709,28710,28711,28712,28713,28714,28715,28716,28717,28718,28719,28720,
    28721,28722,28723,28724,28725,28726,28727,28728,28729,28730,28731,28732,28733,28734,28735,28736,
	28737,28738,28739,28740,28741,28742,28743
};

stock GetVehicleJsonIdFromModel(modelid)
{
    for(new i = 0; i <= MAX_VEHICLE_JSON_ID; i++)
    {
        if(VehicleIdToModelId[i] == modelid)
        {
            return i;
        }
    }
    return -1;
}
