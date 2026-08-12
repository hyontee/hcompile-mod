#define DEALER_DEN_COUNT      10

#define TABLE_DRUGS_LAB         "s_drugs_lab"
#define TABLE_DRUGS_DEALER      "s_drugs_dealer"
new 
    l_actor[3][8], l_actort[3][8], l_actors[3][8];
new 
    hamcvhod[6], 
    wmcvhod[6], 
    pmcvhod[6];
//houselist
static const Float: l_actor_pos[8][4] = {
    {2031.1553, -1249.7645, 1147.3027, 357.5486}, // актер рабочий за столом
    {2028.7147, -1249.7648, 1147.3027, 359.5790}, // актер рабочий за столом
    {2017.6323, -1249.7645, 1147.3027, 0.0303},   // актер рабочий за столом
    {2019.8927, -1249.7645, 1147.3027, 359.6923}, // актер рабочий за столом
    {2029.0667, -1244.0895, 1147.4727, 318.2943}, // актер у куста
    {2031.3550, -1243.9274, 1147.4727, 308.9318}, // актер у куста
    {2019.1444, -1243.4154, 1147.4727, 166.7507}, // актер у куста
    {2015.1740, -1243.4586, 1147.4727, 150.6201}  // актер у куста
}; 
/* 
 - Сделать без CJ V
 - Сделать продажу нарко V
 - Сделать Завоз нарко V
 - Названия дать ботам V
 - Сделать Выдачу Ингридиентов для Байкеров 
 - Дополнить /clientslist
 - Изменить смысл капта (По очкам) V
 - Исправить S_ACOTRS_COUNT
*/

enum E_DEALER_DEN
{
	dID, //Nomer Dealer'a
	dSkin, //Nomer Skin Dealer'a
	Float: dPos[4], // Coord dealer's
    dWorld,
    dInterior,
	dFraction, //Control fraction
	dDrugs, //Kolvo Drugs in dealer's
    dSpeedDrugs,
	dCost[2], //Price Drugs 
	dArea //Area ID

}
new DealerInfo[DEALER_DEN_COUNT][E_DEALER_DEN], S_DEALER_DEN_COUNT;

Fraction_OnGameModeInit()
{   
    CreateDynamicPickup(1580, 23, 2802.1614,-1920.5946,13.5469, .worldid = 0, .interiorid = 0);//24 unload
	CreateDynamic3DTextLabel("Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фургон", -1,
		2802.1614,-1920.5946,13.5469 + 1.0, 7.5, .testlos = 1, .worldid = 0, .interiorid = 0
	);
    CreateDynamicPickup(1580, 23, 1949.0470,-2061.4534,13.5469, .worldid = 0, .interiorid = 0);//26 unload
	CreateDynamic3DTextLabel("Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фургон", -1,
		1949.0470,-2061.4534,13.5469 + 1.0, 7.5, .testlos = 1, .worldid = 0, .interiorid = 0
	);
    CreateDynamicPickup(1580, 23, 2178.6702,-1660.7566,14.9508, .worldid = 0, .interiorid = 0);//25 unload
	CreateDynamic3DTextLabel("Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фургон", -1,
		2178.6702,-1660.7566,14.9508 + 1.0, 7.5, .testlos = 1, .worldid = 0, .interiorid = 0
	);
    ghetto_priton[0] = CreateDynamicPickup(1318, 23, 2154.1172,-1606.4771,14.3754, 0, 0);//???? ? ?????? GROVE/RIFA
	ghetto_priton[1] = CreateDynamicPickup(1318, 23, 1010.1855,2321.0620,1152.5774, .worldid = 1, .interiorid = 5);
 
    CreateDynamicObject(2924, 2800.292724, -1907.683105, 13.746880, 0.000000, 0.000000, 0.000000, INTERIOR_NONE, INTERIOR_NONE, -1, 75.00, 75.00); // дверь притон ВАГОС/БАЛЛАС
    CreateDynamicObject(1508, 2801.308105, -1920.603149, 14.226889, 0.000000, 0.000000, 0.000000, INTERIOR_NONE, INTERIOR_NONE, -1, 75.00, 75.00); // варота разгрузки ВАГОС/
    ghetto_priton[2] = CreateDynamicPickup(1318, 23, 2799.5691, -1907.2731, 13.5469, 0, 0);//Вход в притон VAGOS/BALLAS
	ghetto_priton[3] = CreateDynamicPickup(1318, 23, 1010.1855,2321.0620,1152.5774, .worldid = 2, .interiorid = 5);

    ghetto_priton[4] = CreateDynamicPickup(1318, 23, 1942.1979,-2062.1309,13.5469, 0, 0);//Вход в притон AZTEC
	ghetto_priton[5] = CreateDynamicPickup(1318, 23, 1010.1855,2321.0620,1152.5774, .worldid = 3, .interiorid = 5);

    hamcvhod[0] = CreateDynamicPickup(1318, 23, 681.6178, -473.3481, 16.5363, 0, 0);
	hamcvhod[1] = CreateDynamicPickup(1318, 23, -994.8202, 1955.2634, 1077.5359, .worldid = 1, .interiorid = BIKERS_INT); 
	hamcvhod[2] = CreateDynamicPickup(1318, 23, -1001.8954, 1965.8075, 1077.5359, .worldid = 1, .interiorid = BIKERS_INT);//Лаба
	hamcvhod[3] = CreateDynamicPickup(1318, 23, 2011.9480, -1260.6843, 1147.3027, .worldid = 1, .interiorid = DRUGS_LAB_INT);//Лаба
    hamcvhod[4] = CreateDynamicPickup(1318, 23, 2034.2896,-1260.7386,1147.3027, .worldid = 1, .interiorid = DRUGS_LAB_INT);//Лаба exit 
    hamcvhod[5] = CreateDynamicPickup(1318, 23, 687.2487,-445.6446,16.3359, 0, 0);//Лаба enter street

	wmcvhod[0] = CreateDynamicPickup(1318, 23, -1271.3287,2713.2646,50.2663, 0, 0);//Bandidos
	wmcvhod[1] = CreateDynamicPickup(1318, 23, -994.8202, 1955.2634, 1077.5359, .worldid = 2, .interiorid = BIKERS_INT); 
    wmcvhod[2] = CreateDynamicPickup(1318, 23, -1001.8954, 1965.8075, 1077.5359, .worldid = 2, .interiorid = BIKERS_INT);//Лаба
	wmcvhod[3] = CreateDynamicPickup(1318, 23, 2011.9480, -1260.6843, 1147.3027, .worldid = 2, .interiorid = DRUGS_LAB_INT);//Лаба
    wmcvhod[4] = CreateDynamicPickup(1318, 23, 2034.2896,-1260.7386,1147.3027, .worldid = 2, .interiorid = DRUGS_LAB_INT);//Лаба exit 
    wmcvhod[5] = CreateDynamicPickup(1318, 23, -1272.7450,2724.5173,50.2663, 0, 0);//Лаба enter street
 
	pmcvhod[0] = CreateDynamicPickup(1318, 23, -314.0381,1774.7150,43.6406, 0, 0);/*Outlaws*/
	pmcvhod[1] = CreateDynamicPickup(1318, 23, -994.8202, 1955.2634, 1077.5359, .worldid = 3, .interiorid = BIKERS_INT); 
    pmcvhod[2] = CreateDynamicPickup(1318, 23, -1001.8954, 1965.8075, 1077.5359, .worldid = 3, .interiorid = BIKERS_INT);//Лаба
	pmcvhod[3] = CreateDynamicPickup(1318, 23, 2011.9480, -1260.6843, 1147.3027, .worldid = 3, .interiorid = DRUGS_LAB_INT);//Лаба
    pmcvhod[4] = CreateDynamicPickup(1318, 23, 2034.2896,-1260.7386,1147.3027, .worldid = 3, .interiorid = DRUGS_LAB_INT);//Лаба exit 
    pmcvhod[5] = CreateDynamicPickup(1318, 23, -306.1895,1797.3728,42.7813, 0, 0);//Лаба enter street 

    /* Biker Bar */
    CreateDynamic3DTextLabelEx("Вход в подвал", COLOR_ROSE,
		-1001.8954, 1965.8075, 1077.5359 + 1.0, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {BIKERS_INT}
	);
    CreateDynamic3DTextLabelEx("Выход", COLOR_ROSE,
		-994.8202, 1955.2634, 1077.5359 + 1.0, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {BIKERS_INT}
	);
    CreateDynamic3DTextLabelEx("Выход\nНа задний двор", COLOR_ROSE,
		2034.2896,-1260.7386,1147.3027 + 1.0, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {DRUGS_LAB_INT}
	);
    CreateDynamic3DTextLabelEx("Выход\nВ бар", COLOR_ROSE,
		2011.9480, -1260.6843, 1147.3027 + 1.0, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {DRUGS_LAB_INT}
	);
	CreateDynamic3DTextLabelEx(""colmaline"~~~~~~~~~~~~~~~~~\n"colwhi"Бар\n"colmaline"~~~~~~~~~~~~~~~~~", -1,
		-1006.0035,1948.3784,1077.5378, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {BIKERS_INT}
	); 
	CreateDynamicPickupEx(1486, 23, -1006.0035, 1948.3784, 1077.5378, .worlds = {1, 2, 3}, .interiors = {BIKERS_INT});
	gAreas[arBikersBar][0] = CreateDynamicSphereEx(-1006.0035,1948.3784,1077.5378, 1.0, .worlds = {1,2,3}, .interiors = {BIKERS_INT});

    CreateDynamic3DTextLabelEx("Управления лабораторией", COLOR_ROSE,
		2025.8535,-1253.1901,1147.3027 + 1.0, 7.5, .testlos = 1, .worlds = {1,2,3}, .interiors = {DRUGS_LAB_INT}
	);
	CreateDynamicPickupEx(1239, 23, 2025.8535,-1253.1901,1147.3027, .worlds = {1,2,3}, .interiors = {DRUGS_LAB_INT});
	gAreas[arBikersBar][1] = CreateDynamicSphereEx(2025.8535,-1253.1901,1147.3027, 1.0, .worlds = {1,2,3}, .interiors = {DRUGS_LAB_INT});
    OnLoadDrugsLabrary();
    OnLoadDrugsDealerDen();
    return;
}

stock OnLoadDrugsDealerDen()
{
	new 
        time = GetTickCount(), 
        Cache: tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_DRUGS_DEALER"");
	cache_get_row_count(S_DEALER_DEN_COUNT);
    if (!S_DEALER_DEN_COUNT) {
        print(!"[Загрузка ...] Данные из "#TABLE_DRUGS_DEALER" не получены!");
        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
        return 1;
    }
	for(new i = 0, data_[128], string_[128], name_dealer_[40]; i < S_DEALER_DEN_COUNT; i++)
	{ 
        cache_get_value_name_int(i, "dID", DealerInfo[i][dID]);
        cache_get_value_name_int(i, "dSkin", DealerInfo[i][dSkin]);
        cache_get_value_name(i, "dPos", data_, sizeof data_);
        sscanf(data_,"p<|>a<f>[4]", DealerInfo[i][dPos]); 
        cache_get_value_name_int(i, "dWorld", DealerInfo[i][dWorld]);
        cache_get_value_name_int(i, "dInterior", DealerInfo[i][dInterior]);
        cache_get_value_name_int(i, "dFraction", DealerInfo[i][dFraction]);
        cache_get_value_name_int(i, "dDrugs", DealerInfo[i][dDrugs]); 
        cache_get_value_name_int(i, "dSpeedDrugs", DealerInfo[i][dSpeedDrugs]); 
        cache_get_value_name(i, "dCost", data_, sizeof data_);
        sscanf(data_,"p<|>a<d>[2]", DealerInfo[i][dCost]); 

        //29//28//30//254
        switch(i) {
            case 0: name_dealer_ = "Стефан\n{CDCDB4}(( Наркодилер ))";
            case 1: name_dealer_ = "Шустрила\n{CDCDB4}(( Наркодилер ))";
            case 2: name_dealer_ = "Кеон\n{CDCDB4}(( Наркодилер ))";
            case 3: name_dealer_ = "Джони\n{CDCDB4}(( Наркодилер ))";
            default: name_dealer_ = "Джони\n{CDCDB4}(( Наркодилер ))";
        }
        format(string_, sizeof string_, "[%d] {006666}%s\n\n\n\n\n\n\n\n\n\n"colwhi"Используйте: \"ALT\"",DealerInfo[i][dID], name_dealer_);
		CreateDynamic3DTextLabel(string_, 0xFFFFFFFF, DealerInfo[i][dPos][0], DealerInfo[i][dPos][1], DealerInfo[i][dPos][2] + 1, 10.0, INVALID_PLAYER_ID,INVALID_VEHICLE_ID, 0, DealerInfo[i][dWorld], DealerInfo[i][dInterior]);

        DealerInfo[i][dID] = CreateDynamicActor(DealerInfo[i][dSkin], DealerInfo[i][dPos][0], DealerInfo[i][dPos][1], DealerInfo[i][dPos][2], DealerInfo[i][dPos][3]);
        SetDynamicActorVirtualWorld(DealerInfo[i][dID], DealerInfo[i][dWorld]);//  
       
     	DealerInfo[i][dArea] = CreateDynamicSphere(DealerInfo[i][dPos][0], DealerInfo[i][dPos][1], DealerInfo[i][dPos][2], 1.0, DealerInfo[i][dWorld], DealerInfo[i][dInterior]);
        SetDynamicAreaType(DealerInfo[i][dArea], AREA_TYPE_SELLER_DEALER_DEN, i);

	}
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery); 
    printf("[Загрузка ...] Данные из "#TABLE_DRUGS_DEALER" получены! (%d шт.) Время: %d", S_DEALER_DEN_COUNT, GetTickCount() - time);
	return true;
}
stock OnLoadDrugsLabrary() {
    new 
        time = GetTickCount(),
        Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_DRUGS_LAB""),
        rows = cache_num_rows();  
	if(rows) {
		for(new i = 0, data[128]; i < rows; i++) { 
			cache_get_value(0, "actor_1", data), sscanf(data,"p<|>a<i>[8]",l_actor[0]);
			cache_get_value(0, "actor_2", data), sscanf(data,"p<|>a<i>[8]",l_actor[1]);
			cache_get_value(0, "actor_3", data), sscanf(data,"p<|>a<i>[8]",l_actor[2]);

			cache_get_value(0, "actor_t1", data), sscanf(data,"p<|>a<i>[8]",l_actort[0]);
			cache_get_value(0, "actor_t2", data), sscanf(data,"p<|>a<i>[8]",l_actort[1]);
			cache_get_value(0, "actor_t3", data), sscanf(data,"p<|>a<i>[8]",l_actort[2]);
		}
	}
	for(new idx = 0; idx < 8; idx ++) {
		if(l_actor[0][idx]) UpdateDrugsLabrary(0, idx, 1);
		if(l_actor[1][idx]) UpdateDrugsLabrary(1, idx, 1);
		if(l_actor[2][idx]) UpdateDrugsLabrary(2, idx, 1);
	}
    if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
    printf("[Загрузка ...] Данные из "#TABLE_DRUGS_LAB" получены! Время: %d", GetTickCount() - time); 
    return true;
}
stock UpdateDrugsLabrary(lad_id, actor_id, status) {
	if(status == 1) {
		if(l_actor[lad_id][actor_id]) {
            new 
                crackSkin[] = {143, 144, 145, 146},
                rand = random(sizeof crackSkin);
			l_actors[lad_id][actor_id] = CreateDynamicActor(crackSkin[rand], l_actor_pos[actor_id][0], l_actor_pos[actor_id][1], l_actor_pos[actor_id][2], l_actor_pos[actor_id][3]);
			SetDynamicActorVirtualWorld(l_actors[lad_id][actor_id], lad_id + 1);  
			if(actor_id >= 4) ApplyDynamicActorAnimation(l_actors[lad_id][actor_id],"BOMBER", "BOM_Plant",4,1,0,0,1,0);
			else ApplyDynamicActorAnimation(l_actors[lad_id][actor_id],"FLAME","FLAME_FIRE",4,1,0,0,1,0);
		}
	}
	else {
		if(l_actors[lad_id][actor_id]) DestroyDynamicActor(l_actors[lad_id][actor_id]);
		SaveLabrary(lad_id);
	}
}
stock SaveLabrary(member) {
	new 
        data[48],
        data_2[128];
	for(new i; i < 8; i++) {
		if(!i) {
			format(data, sizeof data, "%d", l_actor[member][i]);
			format(data_2, sizeof data_2, "%d", l_actort[member][i]);
		}
		else {
			format(data, sizeof data, "%s|%d", data, l_actor[member][i]);
			format(data_2, sizeof data_2, "%s|%d", data_2, l_actort[member][i]);
		}
	}
	new 
        query_[256];
	format(query_, sizeof query_, 
        "UPDATE "TABLE_DRUGS_LAB" SET actor_%d = '%s', actor_t%d = '%s' LIMIT 1",
        member+1, data, member+1, data_2
    );
	mysql_tquery(dbHandle, query_, "","");
	return true;
}
Fraction_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
    #pragma unused inputtext
	switch (dialogid) {
        case D_BIKER_FUNC_1: {
            if(!response) {
                return 1;
            }
            if(!pInfo[playerid][pLeader]) return 1;
            new member = -1;
            if(pInfo[playerid][pMember] == FRACTION_MONGOLS_MC) member = 0;
            else if(pInfo[playerid][pMember] == FRACTION_BANDIDOS_MC) member = 1;
            else if(pInfo[playerid][pMember] == FRACTION_OUTLAWS_MC) member = 2;
            if(member == -1) return 1;
            if(l_actor[member][listitem]) return SendClientMessage(playerid, COLOR_GREY, !"Рабочий уже нанят");
            format(t_string, sizeof t_string, ""colwhi"Вы собираетесь нанять рабочего "colserver"№%d\n\n\
				"colwhi"Вы действительно хотите нанять рабочего за "collime"$40.000 "colwhi"на "colwarn"7 дней"colwhi"?",
                listitem+1
			); 
            ShowPlayerDialog(playerid, D_BIKER_FUNC_2, DIALOG_STYLE_MSGBOX, ""colserver"Лаборатория: "colwhi"Найм сотрудника", t_string, "Нанять", "Закрыть");
            SetPVarInt(playerid, "lactor", listitem);
            return 1;
        }
        case D_BIKER_FUNC_2: {
            if (!response) {
                DeletePVar(playerid, "lactor");
                return 1;
            }
            new 
                member = -1,
                list = GetPVarInt(playerid,"lactor"),
                fraction_id = pInfo[playerid][pMember];
            DeletePVar(playerid, "lactor");
            if (fraction_id == FRACTION_MONGOLS_MC) member = 0;
            else if (fraction_id == FRACTION_BANDIDOS_MC) member = 1;
            else if (fraction_id == FRACTION_OUTLAWS_MC) member = 2;
            if (member == -1) return 1;
            if (l_actor[member][list]) return SendClientMessage(playerid, COLOR_GREY, !"Рабочий уже нанят");
            if (FractionInfo[fraction_id][fMoney] < 40_000) return SendClientMessage(playerid, COLOR_GREY, !"В общаге клуба недостаточно средств");
            FractionInfo[fraction_id][fMoney] -= 40_000;
            UpdateFractionStore(fraction_id); 
            SendClientMessage(playerid, COLOR_GREEN, !"Рабочий успешно нанят на 7 дней");
            l_actort[member][list] = gettime() + 7*86400;
            l_actor[member][list] = 1;
            SaveLabrary(member);
            UpdateDrugsLabrary(member, list, 1);
            ShowListEmploeesBikersLabrary(playerid);
            return 1;
        }
        case D_BIKER_FUNC_3: {
            if (!response) {
                return 1;
            }
            switch(listitem) {
                case 0: {
                    ShowListEmploeesBikersLabrary(playerid);
                }
                case 1: {
                    new 
                        member = -1, count_ = 0, count_ped = 0,
                        fraction_id = pInfo[playerid][pMember];
                    if (fraction_id == FRACTION_MONGOLS_MC) member = 0;
                    else if (fraction_id == FRACTION_BANDIDOS_MC) member = 1;
                    else if (fraction_id == FRACTION_OUTLAWS_MC) member = 2;
                    if (member == -1) return SendClientMessage(playerid, COLOR_GREY, !"Временно недоступно");
                    for(new idx = 0; idx < 8; idx ++) { 
                        if (l_actor[member][idx] && l_actort[member][idx] > gettime()) {
                            count_ped++;
                            count_ += 10;
                        } 
                    }
                    new 
                    den_name[32], den_id = -1;
                    if (pInfo[playerid][pMember] == FRACTION_MONGOLS_MC) {
                        den_name = "Playa del Seville", den_id = 1;
                    }
                    else if (pInfo[playerid][pMember] == FRACTION_OUTLAWS_MC) {
                        den_name = "El Corona", den_id = 2;
                    }
                    else if (pInfo[playerid][pMember] == FRACTION_BANDIDOS_MC) {
                        den_name = "Idlewood", den_id = 0;
                    }

                        /* AddPlayerClass(100,2802.1614,-1920.5946,13.5469,89.1909,0,0,0,0,0,0); // Playa del sevli 24 unload
                        AddPlayerClass(100,1949.0470,-2061.4534,13.5469,172.8893,0,0,0,0,0,0); // el corona 26 unload
                        AddPlayerClass(100,2178.6702,-1660.7566,14.9508,44.0704,0,0,0,0,0,0); // idlewood 25 unload
                    */
                    if (den_id == -1) return SendClientMessage(playerid, COLOR_GREY, !"Временно недоступно");
                    format(t_string, sizeof t_string, 
                        ""colwhi"Лаборатория: {%s}%s\n\
                        "colwhi"Сотрудников: "C_PODS"%d\n\n\
                        "colwhi"За Час производиться: "C_PODS"%d грамм\n\
                        "colwhi"На складе:\n\
                        \t"colwhi"- Легкие наркотики: "C_PODS"%d/"#STORE_LIMITS_DRUGS" грамм\n\
                        \t"colwhi"- Тяжелые наркотики: "C_PODS"%d/"#STORE_LIMITS_DRUGS" грамм\n\n\
                        "colwhi"На складе притона: "colwarn"%s:\n\
                        \t"colwhi"- Легкие наркотики: "C_PODS"%d грамм "colwhi"Цена за грамм: "collime"$%d\n\
                        \t"colwhi"- Тяжелые наркотики: "C_PODS"%d грамм "colwhi"Цена за грамм: "collime"$%d\n\n", 
                        gFraction[fraction_id][fRGBColor], fInfo[fraction_id][fName], count_ped, (count_*60), 
                        FractionInfo[fraction_id][fSpeedDrugs], FractionInfo[fraction_id][fDrugs],
                        den_name, 
                        DealerInfo[den_id][dDrugs], DealerInfo[den_id][dCost][0],
                        DealerInfo[den_id][dSpeedDrugs], DealerInfo[den_id][dCost][1]
                    );
                    ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, ""colserver"Статистика: "colwhi"Лаборатория", t_string, "Закрыть", "");
                }
            }
            return 1;
        }
        case D_BIKER_FUNC_4: {
            if (!response) {
                return 1;
            }
            new 
                fraction_id = -1, string_[256];
            if(GetPlayerVirtualWorld(playerid) == 1) fraction_id = FRACTION_MONGOLS_MC;
            else if(GetPlayerVirtualWorld(playerid) == 2) fraction_id = FRACTION_BANDIDOS_MC;
            else if(GetPlayerVirtualWorld(playerid)  == 3) fraction_id = FRACTION_OUTLAWS_MC;
            if (fraction_id == -1) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в лабе");
                return 1;
            }
            switch(listitem) {
                case 0: {
                    if (pTemp[playerid][tTakeDrugsType] != 0) {
                        SendClientMessage(playerid, COLOR_GREY, !"У Вас в руках уже есть сумка!");
                        return 1;
                    }
                    if (FractionInfo[fraction_id][fDrugs] <= 1000) return SendClientMessage(playerid,COLOR_GRAD1, "На складе нет тяжелых наркотиков!");
                    pTemp[playerid][tTakeDrugsType] = 1;
                    FractionInfo[fraction_id][fDrugs] -= 1000; 
                    SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 11745, 5, 0.221999, 0.046998, -0.017000, 60.199977, -83.000000, 0.000000, 0.453999, 0.811001, 0.900001); 
                    SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отнесите сумку в фургон");
                }
                case 1: {
                    if (pTemp[playerid][tTakeDrugsType] != 0) {
                        SendClientMessage(playerid, COLOR_GREY, !"У Вас в руках уже есть сумка!");
                        return 1;
                    }
                    if (FractionInfo[fraction_id][fSpeedDrugs] <= 1000) return SendClientMessage(playerid,COLOR_GRAD1, "На складе нет тяжелых наркотиков!");
                    pTemp[playerid][tTakeDrugsType] = 2;
                    FractionInfo[fraction_id][fSpeedDrugs] -= 1000; 
                    SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 11745, 5, 0.221999, 0.046998, -0.017000, 60.199977, -83.000000, 0.000000, 0.453999, 0.811001, 0.900001); 
                    SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отнесите сумку в фургон");
                }
            } 
            format(string_, sizeof string_, "На складе:\n\n\
                "colwhi"Тяжелые наркотики: {F58B11}%d гр\n\
                "colwhi"Легкие наркотики: {F58B11}%d гр\n\n{CAFA0A}Используйте: ALT", FractionInfo[fraction_id][fDrugs], FractionInfo[fraction_id][fSpeedDrugs]
            );
            UpdateDynamic3DTextLabelText(FractionInfo[fraction_id][fLabText], -1, string_);
            return 1;
        }
        case D_BIKER_FUNC_5: {
            if (!response) {
                pTemp[playerid][tSelectDealerID] = -1;
                return 1;
            }
            new
                D_IDX = pTemp[playerid][tSelectDealerID],
                fraction_id = DealerInfo[D_IDX][dFraction];
            switch(listitem) {
                case 0: { 
                    format(t_string, sizeof t_string, "\n"colwhi"Введите количество грамм\n1 грамм стоит "collime"$%d\n\
                        "colwhi"В наличии: "C_PODS"%d грамм\n\
                        "colwhi"Контролирует: {%s}%s\n", 
                        DealerInfo[D_IDX][dCost][0], DealerInfo[D_IDX][dDrugs],
                        gFraction[fraction_id][fRGBColor], fInfo[fraction_id][fName]
                    );
                    ShowPlayerDialog(playerid, D_BIKER_FUNC_6, 1, ""colserver"Наркоторговец", t_string,"Купить","Отмена"), t_string[0] = EOS; 
                }
                case 1: { 
                }
            }
            return 1;
        }
        case D_BIKER_FUNC_6:
		{
			if (!response) {
                // return dealer dialog
                return 1;
            }
            new
                D_IDX = pTemp[playerid][tSelectDealerID],
                fraction_id = DealerInfo[D_IDX][dFraction],
                string_[128];
			if (isnull(inputtext)) {
                format(t_string, sizeof t_string, "\n"colwhi"Введите количество грамм\n1 грамм стоит "collime"$%d\n\
                    "colwhi"В наличии: "C_PODS"%d грамм\n\
                    "colwhi"Контролирует: {%s}%s\n", 
                    DealerInfo[D_IDX][dCost][0], DealerInfo[D_IDX][dDrugs],
                    gFraction[fraction_id][fRGBColor], fInfo[fraction_id][fName]
                );
                ShowPlayerDialog(playerid, D_BIKER_FUNC_6, 1, ""colserver"Наркоторговец", t_string,"Купить","Отмена"), t_string[0] = EOS;
                return 1;
            }
			new drugs_ = strval(inputtext);
			if (drugs_ < 1) {
                format(t_string, sizeof t_string, "\n"colwhi"Введите количество грамм\n1 грамм стоит "collime"$%d\n\
                    "colwhi"В наличии: "C_PODS"%d грамм\n\
                    "colwhi"Контролирует: {%s}%s\n", 
                    DealerInfo[D_IDX][dCost][0], DealerInfo[D_IDX][dDrugs],
                    gFraction[fraction_id][fRGBColor], fInfo[fraction_id][fName]
                );
                ShowPlayerDialog(playerid, D_BIKER_FUNC_6, 1, ""colserver"Наркоторговец", t_string,"Купить","Отмена"), t_string[0] = EOS;
                return 1;
            } 
            if (drugs_ > DealerInfo[D_IDX][dDrugs])
            {
                format(t_string, sizeof t_string, "\n"colwhi"Введите количество грамм\n1 грамм стоит "collime"$%d\n\
                    "colwhi"В наличии: "C_PODS"%d грамм\n\
                    "colwhi"Контролирует: {%s}%s\n", 
                    DealerInfo[D_IDX][dCost][0], DealerInfo[D_IDX][dDrugs],
                    gFraction[fraction_id][fRGBColor], fInfo[fraction_id][fName]
                );
                ShowPlayerDialog(playerid, D_BIKER_FUNC_6, 1, ""colserver"Наркоторговец", t_string,"Купить","Отмена"), t_string[0] = EOS;
                return 1;
            }
            if (drugs_ < 1 || drugs_ > 150) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя меньше 1 или больше 150 за раз!");
            if (kLibGetPlayerMoney(playerid) < (drugs_*DealerInfo[D_IDX][dCost][0]) ) return SendClientMessage(playerid, COLOR_GREY, !"У вас нет столько денег!");
            if (pInfo[playerid][pDrugs] + drugs_ > GetVIPLimitDrugs(playerid)) 
            {
                OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_DRUGS, 150);
                format(string_, sizeof string_, "Нельзя унести с собой более %d грамм!", GetVIPLimitDrugs(playerid));
                SendClientMessage(playerid, COLOR_GREY, string_);
                return 1;
            }
            kLibGivePlayerMoney(playerid, -(drugs_*DealerInfo[D_IDX][dCost][0]), "/get drugs");
            pInfo[playerid][pDrugs] += drugs_; 
            DealerInfo[D_IDX][dDrugs] -= drugs_;
            format(string_, sizeof(string_), "Вы купили %d грамм наркотиков за $%d (У вас есть %d тяжелых грамм)", drugs_, (drugs_*DealerInfo[D_IDX][dCost][0]), pInfo[playerid][pDrugs]);
            SendClientMessage(playerid, 0x6495EDFF, string_);

            OnPlayerQuestProgress(playerid, QUEST_GHETTO, QUEST_TASK_DRUGS, drugs_); 
			return 1;
		}
        case D_BIKER_FUNC_7: {
            if (response) {
                if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы не за рулем фургона");
                new 
            		V_IDX = GetPlayerVehicleID(playerid);
                if (VehicleInfo[ V_IDX - 1 ][vFarmText] != Text3D:-1) { 
                    DestroyDynamic3DTextLabel(VehicleInfo[ V_IDX - 1 ][vFarmText]); 
                    VehicleInfo[ V_IDX  - 1 ][vFarmText] = Text3D:-1;
                } 
                DestroyDynamicArea(VehicleInfo[ V_IDX - 1 ][vJobArea]);
                DestroyDynamicPickup(VehicleInfo[ V_IDX - 1 ][vJobPickup]); 
                VehicleInfo[ V_IDX - 1 ][vJobLoad] = false;
                if (pTemp[playerid][tTakeDrugsType]) {
                    if (IsPlayerAttachedObjectSlotUsed(playerid, ATTACHED_SLOT_JOB_1)) RemovePlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1);
                    pTemp[playerid][tTakeDrugsType] = 0;
                }  
                if (VehicleInfo[ V_IDX - 1 ][vJobAmount] != 0) {
                    new 
                        string_[128], den_name[32];
                    if (pInfo[playerid][pMember] == FRACTION_MONGOLS_MC) {
                        den_name = "Playa del Seville";
                        SetPlayerCheckpoint(playerid, 2817.7566,-1904.0908,11.1094,8);//нарко притон Playa del Sevile
                    }
                    else if (pInfo[playerid][pMember] == FRACTION_OUTLAWS_MC) {
                        den_name = "El Corona";
                        SetPlayerCheckpoint(playerid, 1942.5160,-2057.8594,13.5469,8);//нарко притон El corona 
                    }
                    else if (pInfo[playerid][pMember] == FRACTION_BANDIDOS_MC) {
                        den_name = "Idlewood";
                        SetPlayerCheckpoint(playerid, 2175.5417,-1670.3339,14.9977,8);//нарко притон Idlewood
                    } 
                    CP[playerid] = 777;
                    format(string_, sizeof string_, "[Подсказка] "colwhi"Отправляйтесь к Наркопритону: %s, для разгрузки фургона", den_name);
                    SendClientMessage(playerid, COLOR_YELLOW, string_);
                }   
			}
			else {
				SendClientMessage(playerid, COLOR_LI_RED, !"[Информация] "colwhi"Продолжайте загрузку фургона!");
				RemovePlayerFromVehicle(playerid); 
			}
			return true;
        }
        case D_BIKER_FUNC_8:
		{
			if (!response) { 
                return 1;
            }
            if (!IsPlayerInDynamicArea(playerid, FractionInfo[ pInfo[playerid][pMember] ][fSphere])) return 1;
			new 
                fraction_id = pInfo[playerid][pMember];
			switch(listitem)
			{
				case 0: ShowPlayerDialog(playerid, D_BIKER_FUNC_9, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
				case 1: ShowPlayerDialog(playerid, D_BIKER_FUNC_10, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
                case 2: {
                    ShowPlayerDialog(playerid, D_BIKER_FUNC_11, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                }
                case 3: {
                    ShowPlayerDialog(playerid, D_BIKER_FUNC_12, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Легкие наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                }
				case 4:
				{
					if (FractionInfo[fraction_id][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад организации закрыт!");
					ShowPlayerDialog(playerid, D_BIKER_FUNC_13, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
				}
				case 5:
				{
					if (FractionInfo[fraction_id][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад организации закрыт!");
					if (pInfo[playerid][pRank] < fInfo[fraction_id][fHelper][4])
					{
						new str_[128];
						format(str_, sizeof str_, "Деньги можно брать с %d ранга", fInfo[fraction_id][fHelper][4]);
						SendClientMessage(playerid, COLOR_GREY, str_);
						return 1;
					}
					ShowPlayerDialog(playerid, D_BIKER_FUNC_14, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
				}
                case 6: {
                    if (FractionInfo[fraction_id][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад организации закрыт!");
					ShowPlayerDialog(playerid, D_BIKER_FUNC_15, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                }
                case 7: {
                    if (FractionInfo[fraction_id][fLock] == 1) return SendClientMessage(playerid, COLOR_GREY, !"Склад организации закрыт!");
					ShowPlayerDialog(playerid, D_BIKER_FUNC_16, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Легкие накротики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                }
			}
			return 1;
		} 
        case D_BIKER_FUNC_9:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
			if (d_amount < 1 || d_amount > 10_000) {
				SendClientMessage(playerid, COLOR_GREY, !"За раз не меньше 1 и не более 10000 материалов можно класть!");
				return ShowPlayerDialog(playerid, D_BIKER_FUNC_9, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			}
			if (pInfo[playerid][pMats] < d_amount)
			{
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько материалов!");
				return ShowPlayerDialog(playerid, D_BIKER_FUNC_9, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			}
			if (FractionInfo[fraction_id][fMaterials] + d_amount > STORE_LIMITS_MATERIALS)
            {
				SendClientMessage(playerid, COLOR_GREY, !"Склад Вашей организации полный "#STORE_LIMITS_MATERIALS"!");
				return ShowPlayerDialog(playerid, D_BIKER_FUNC_9, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Материалы",""colwhi"Введите количество материалов, которое желаете положить:","Положить","Назад");
			}
			FractionInfo[fraction_id][fMaterials] += d_amount;
			pInfo[playerid][pMats] -= d_amount; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);
			format(str_, sizeof str_, "Вы положили на склад "colserver"%d материалов", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
			UpdateFractionStore(fraction_id);
			return 1;
		} 
        case D_BIKER_FUNC_10:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }			
            new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
			if (d_amount < 1 || d_amount > 5_000_000) return ShowPlayerDialog(playerid, D_BIKER_FUNC_10, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:\n\nДо 5.000.000","Положить","Назад");
			if (kLibGetPlayerMoney(playerid) < d_amount)
			{
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько денег!");
				return ShowPlayerDialog(playerid, D_BIKER_FUNC_10, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете положить:","Положить","Назад");
			}
			FractionInfo[fraction_id][fMoney] += d_amount;
			kLibGivePlayerMoney(playerid, -d_amount, "положил на склад");
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);
			format(str_, sizeof str_, "Вы положили на склад "collime"$%d", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			HistoryStoreLog(playerid, d_amount, "положил на склад");
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
			UpdateFractionStore(fraction_id);
			return 1;
		}
        
        case D_BIKER_FUNC_11:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
			if (d_amount < 1 || d_amount > 10_000) {
				SendClientMessage(playerid, COLOR_GREY, !"За раз не меньше 1 и не более 10.000 наркотиков можно класть!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_11, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			if (pInfo[playerid][pDrugs] < d_amount)
			{
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько тяжелых наркотиков!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_11, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			if (FractionInfo[fraction_id][fDrugs] + d_amount > WAREHOUSE_LIMITS_DRUGS)
            {
				SendClientMessage(playerid, COLOR_GREY, !"Склад Вашей организации полный "#WAREHOUSE_LIMITS_DRUGS"!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_11, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			FractionInfo[fraction_id][fDrugs] += d_amount;
			pInfo[playerid][pDrugs] -= d_amount; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);
			format(str_, sizeof str_, "Вы положили на склад "colserver"%d тяжелых наркотиков", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
			UpdateFractionStore(fraction_id);
			return 1;
		}
        case D_BIKER_FUNC_12:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
			if (d_amount < 1 || d_amount > 10_000) {
				SendClientMessage(playerid, COLOR_GREY, !"За раз не меньше 1 и не более 10.000 наркотиков можно класть!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_12, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Легкие наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			if (pInfo[playerid][pLDrugs] < d_amount)
			{
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет столько легких наркотиков!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_12, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Легкие наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			if (FractionInfo[fraction_id][fSpeedDrugs] + d_amount > WAREHOUSE_LIMITS_DRUGS)
            {
				SendClientMessage(playerid, COLOR_GREY, !"Склад Вашей организации полный "#WAREHOUSE_LIMITS_DRUGS"!");
				ShowPlayerDialog(playerid, D_BIKER_FUNC_12, DIALOG_STYLE_INPUT,""colserver"Положить: "colwhi"Легкие наркотики",""colwhi"Введите количество наркотиков, которое желаете положить:","Положить","Назад");
                return 1;
			}
			FractionInfo[fraction_id][fSpeedDrugs] += d_amount;
			pInfo[playerid][pLDrugs] -= d_amount; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);
			format(str_, sizeof str_, "Вы положили на склад "colserver"%d легких наркотиков", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
			UpdateFractionStore(fraction_id);
			return 1;
		}
        case D_BIKER_FUNC_13:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
				
			if (d_amount < 1 || d_amount > 500 ) {
                ShowPlayerDialog(playerid, D_BIKER_FUNC_13, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
                return 1; 
            }
			if (FractionInfo[fraction_id][fMaterials] < d_amount )
			{
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько материалов!");
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_13, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
                return 1;
			}
			if (pInfo[playerid][pMats] + d_amount > GetVIPLimitMaterials(playerid))
            {
			    SendMes(playerid, COLOR_GREY, "Нельзя при себе иметь более %d материалов!", GetVIPLimitMaterials(playerid));
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_13, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Материалы",""colwhi"Введите количество материалы, которое желаете взять:","Взять","Назад");
                return 1;
			}
			FractionInfo[fraction_id][fMaterials] -= d_amount ;
			pInfo[playerid][pMats] += d_amount ; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);

			format(str_, sizeof str_, "Вы взяли со склада "colserver"%d материалов", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			
			format(str_, sizeof str_, "%s взял со склада %d материалов", pInfo[playerid][pName], d_amount);
            //SendFamilyMessage(pInfo[playerid][pMember], 0x6BB3FFAA, str_);
            SendBeside(playerid, COLOR_PURPLE, str_, 10.0);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
            UpdateFractionStore(fraction_id);
            return 1;
		}
        case D_BIKER_FUNC_14:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				string_[128];

			if (d_amount < 1 || d_amount > 10_000_000) {
                ShowPlayerDialog(playerid, D_BIKER_FUNC_14, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
                return 1;
            }
			if (FractionInfo[fraction_id][fMoney] < d_amount)
			{
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько денег!");
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_14, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Деньги",""colwhi"Введите количество денег, которое желаете взять:","Взять","Назад");
                return 1;
			} 
			if (gFraction[fraction_id][fLimitWareHouse] + d_amount > 500_000) { 
				format(string_, sizeof string_, "Можно снять $%d. Дневной лимит (500.000)", 500_000 - gFraction[fraction_id][fLimitWareHouse]);
				return SendClientMessage(playerid, 0x6495EDFF, string_);
			}
			FractionInfo[fraction_id][fMoney] -= d_amount;
			gFraction[fraction_id][fLimitWareHouse] += d_amount;
			kLibGivePlayerMoney(playerid, d_amount, "взял со склада");
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);

			format(string_, sizeof string_, "Вы взяли со склада "colserver"$%d", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, string_);

			//format(string_, sizeof string_, "%s взял со склада $%d", pInfo[playerid][pName], d_amount);
            //SendFamilyMessage(pInfo[playerid][pMember], 0x6BB3FFAA, string_); 
			HistoryStoreLog(playerid, d_amount, "взял со склада");
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
            UpdateFractionStore(fraction_id);
            return 1;
		}
        case D_BIKER_FUNC_15:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[100];
				
			if (d_amount < 1 || d_amount > 500 ) {
                ShowPlayerDialog(playerid, D_BIKER_FUNC_15, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1; 
            }
			if (FractionInfo[fraction_id][fDrugs] < d_amount )
			{
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько тяжелых наркотиков!");
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_15, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1;
			}
			if (pInfo[playerid][pDrugs] + d_amount > GetVIPLimitDrugs(playerid))
            {
			    SendMes(playerid, COLOR_GREY, "Нельзя при себе иметь более %d грамм тяжелых наркотиков!", GetVIPLimitDrugs(playerid));
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_15, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Тяжелые наркотики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1;
			}
			FractionInfo[fraction_id][fDrugs] -= d_amount ;
			pInfo[playerid][pDrugs] += d_amount ; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);

			format(str_, sizeof str_, "Вы взяли со склада "colserver"%d грамм тяжелых наркотиков", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			
			format(str_, sizeof str_, "%s взял со склада %d грамм тяжелых наркотиков", pInfo[playerid][pName], d_amount);
            SendFamilyMessage(pInfo[playerid][pMember], COLOR_PURPLE, str_);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
            UpdateFractionStore(fraction_id);
            return 1;
		}
        case D_BIKER_FUNC_16:
		{
            if (!response) { 
                ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
					"[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
				);
                return 1;
            }
			new d_amount = strval(inputtext),
				fraction_id = pInfo[playerid][pMember],
				str_[64];
				
			if (d_amount < 1 || d_amount > 500 ) {
                ShowPlayerDialog(playerid, D_BIKER_FUNC_16, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Легкие накротики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1; 
            }
			if (FractionInfo[fraction_id][fSpeedDrugs] < d_amount )
			{
			    SendClientMessage(playerid, COLOR_GREY, !"На складе нет столько легких наркотиков!");
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_16, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Легкие накротики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1;
			}
			if (pInfo[playerid][pLDrugs] + d_amount > GetVIPLimitDrugs(playerid))
            {
			    SendMes(playerid, COLOR_GREY, "Нельзя при себе иметь более %d грамм легких наркотиков!", GetVIPLimitDrugs(playerid));
			    ShowPlayerDialog(playerid, D_BIKER_FUNC_16, DIALOG_STYLE_INPUT,""colserver"Взять: "colwhi"Легкие накротики",""colwhi"Введите количество наркотиков, которое желаете взять:","Взять","Назад");
                return 1;
			}
			FractionInfo[fraction_id][fSpeedDrugs] -= d_amount ;
			pInfo[playerid][pLDrugs] += d_amount ; 
			SaveFractionInfoID(FractionInfo[fraction_id][fID], false);

			format(str_, sizeof str_, "Вы взяли со склада "colserver"%d грамм легких наркотиков", d_amount);
			SendClientMessage(playerid, COLOR_WHITE, str_);
			
			format(str_, sizeof str_, "%s взял со склада %d грамм легких наркотиков", pInfo[playerid][pName], d_amount);
            SendFamilyMessage(pInfo[playerid][pMember], 0x6BB3FFAA, str_);
            ShowPlayerDialog(playerid, D_BIKER_FUNC_8, DIALOG_STYLE_LIST, ""colserver"Склад: "colwhi"Организации", 
                "[0] Положить материалы\n[1] Положить деньги\n[2] Положить тяжелые наркотики\n[3] Положить легкие наркотики\n[4] Взять материалы\n[5] Взять деньги\n[6] Взять тяжелые наркотики\n[3] Взять легкие наркотики", "Выбрать", "Закрыть"
            );
            UpdateFractionStore(fraction_id);
            return 1;
		}
    }
    return false;
}

stock Fraction_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new bool:isReturn = false;
	if ((oldkeys & newkeys))
		return isReturn;
	switch (newkeys) {
        case KEY_CROUCH: {
            if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {  
                new 
                    vehicleid = GetPlayerVehicleID(playerid);
               /* AddPlayerClass(100,2802.1614,-1920.5946,13.5469,89.1909,0,0,0,0,0,0); // Playa del sevli 24 unload
AddPlayerClass(100,1949.0470,-2061.4534,13.5469,172.8893,0,0,0,0,0,0); // el corona 26 unload
AddPlayerClass(100,2178.6702,-1660.7566,14.9508,44.0704,0,0,0,0,0,0); // idlewood 25 unload*/
                 
                if (IsABiker(playerid) && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_FRACTION && VehicleInfo[vehicleid - 1][vFraction] == FRACTION_MONGOLS_MC) {
                    if (IsPlayerInRangeOfPoint(playerid, 7.0, 2802.1614,-1920.5946,13.5469)/*Playa del sevli*/)
                    {
                        if (VehicleInfo[ vehicleid - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Завершите загрузку!"); 
                        if (VehicleInfo[ vehicleid - 1 ][vJobAmount][0] == 0 && VehicleInfo[ vehicleid - 1 ][vJobAmount][1] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
                        new	
                            amountsell = (VehicleInfo[ vehicleid - 1 ][vJobAmount][0]*150),
                            amountsell_ = (VehicleInfo[ vehicleid - 1 ][vJobAmount][1]*150),
                            string_[128];
                        kLibGivePlayerMoney(playerid, (amountsell+amountsell_), "bank in cash");
                        SetMoveCashServer(IN_SERVER, (amountsell+amountsell_));

                        format(string_, sizeof string_, "Вы разгрузили в притон тяжелых наркотиков "colmaline"%d %s "colwhi", легких наркотиков "colmaline"%d %s", 
                            (VehicleInfo[ vehicleid - 1 ][vJobAmount][0]*1000), Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][0], "грамм", "грамма", "грамм"),
                            (VehicleInfo[ vehicleid - 1 ][vJobAmount][1]*1000), Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][1], "грамм", "грамма", "грамм")
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);

                        format(string_, sizeof string_, "За доставку вы заработали: "collime"$%d", 
                            (amountsell+amountsell_)
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);
                        DealerInfo[1][dDrugs] += (VehicleInfo[ vehicleid - 1 ][vJobAmount][0]*1000);
                        DealerInfo[1][dSpeedDrugs] += (VehicleInfo[ vehicleid - 1 ][vJobAmount][1]*1000);
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][0] = 
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][1] = 0;
                        
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь дальше пополнять склад наркопритон"); 
                    }    
                    isReturn = true;
                } 
                if (IsABiker(playerid) && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_FRACTION && VehicleInfo[vehicleid - 1][vFraction] == FRACTION_OUTLAWS_MC) {
                    if (IsPlayerInRangeOfPoint(playerid, 7.0, 1949.0470,-2061.4534,13.5469)/*El Corona*/)
                    {
                        if (VehicleInfo[ vehicleid - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Завершите загрузку!"); 
                        if (VehicleInfo[ vehicleid - 1 ][vJobAmount][0] == 0 && VehicleInfo[ vehicleid - 1 ][vJobAmount][1] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
                        new	
                            amountsell = (VehicleInfo[ vehicleid - 1 ][vJobAmount][0]*150),
                            amountsell_ = (VehicleInfo[ vehicleid - 1 ][vJobAmount][1]*150),
                            string_[128];
                        kLibGivePlayerMoney(playerid, (amountsell+amountsell_), "bank in cash");
                        SetMoveCashServer(IN_SERVER, (amountsell+amountsell_));

                        format(string_, sizeof string_, "Вы разгрузили в притон тяжелых наркотиков "colmaline"%d %s "colwhi", легких наркотиков "colmaline"%d %s", 
                            VehicleInfo[ vehicleid - 1 ][vJobAmount][0], Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][0], "грамм", "грамма", "грамм"),
                            VehicleInfo[ vehicleid - 1 ][vJobAmount][1], Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][1], "грамм", "грамма", "грамм")
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);

                        format(string_, sizeof string_, "За доставку вы заработали: "collime"$%d", 
                            (amountsell+amountsell_)
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);
                        DealerInfo[2][dDrugs] += VehicleInfo[ vehicleid - 1 ][vJobAmount][0];
                        DealerInfo[2][dSpeedDrugs] += VehicleInfo[ vehicleid - 1 ][vJobAmount][1];
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][0] = 
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][1] = 0;
                        
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь дальше пополнять склад наркопритон"); 
                    }    
                    isReturn = true;
                }
                if (IsABiker(playerid) && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_FRACTION && VehicleInfo[vehicleid - 1][vFraction] == FRACTION_BANDIDOS_MC) {
                    if (IsPlayerInRangeOfPoint(playerid, 7.0, 2178.6702,-1660.7566,14.9508)/*Idlewood*/)
                    {
                        if (VehicleInfo[ vehicleid - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Завершите загрузку!"); 
                        if (VehicleInfo[ vehicleid - 1 ][vJobAmount][0] == 0 && VehicleInfo[ vehicleid - 1 ][vJobAmount][1] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
                        new	
                            amountsell = (VehicleInfo[ vehicleid - 1 ][vJobAmount][0]*150),
                            amountsell_ = (VehicleInfo[ vehicleid - 1 ][vJobAmount][1]*150),
                            string_[128];
                        kLibGivePlayerMoney(playerid, (amountsell+amountsell_), "bank in cash");
                        SetMoveCashServer(IN_SERVER, (amountsell+amountsell_));

                        format(string_, sizeof string_, "Вы разгрузили в притон тяжелых наркотиков "colmaline"%d %s "colwhi", легких наркотиков "colmaline"%d %s", 
                            VehicleInfo[ vehicleid - 1 ][vJobAmount][0], Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][0], "грамм", "грамма", "грамм"),
                            VehicleInfo[ vehicleid - 1 ][vJobAmount][1], Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount][1], "грамм", "грамма", "грамм")
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);

                        format(string_, sizeof string_, "За доставку вы заработали: "collime"$%d", 
                            (amountsell+amountsell_)
                        );
                        SendClientMessage(playerid, COLOR_WHITE, string_);
                        DealerInfo[0][dDrugs] += VehicleInfo[ vehicleid - 1 ][vJobAmount][0];
                        DealerInfo[0][dSpeedDrugs] += VehicleInfo[ vehicleid - 1 ][vJobAmount][1];
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][0] = 
                        VehicleInfo[ vehicleid - 1 ][vJobAmount][1] = 0;
                        
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь дальше пополнять склад наркопритон"); 
                    }    
                    isReturn = true;
                }
            }
            if (isReturn) return true; 
        }
		case KEY_WALK: {
			if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {  
				if (pTemp[playerid][tSelectDealerID] != -1) {
					new 
						D_IDX = pTemp[playerid][tSelectDealerID]/*,
                        fraction_id = DealerInfo[D_IDX][dFraction]*/; 
					if (IsPlayerInRangeOfPoint(playerid, 4.5, DealerInfo[D_IDX][dPos][0], DealerInfo[D_IDX][dPos][1], DealerInfo[D_IDX][dPos][2]) 
						&& GetPlayerVirtualWorld(playerid) == DealerInfo[D_IDX][dWorld] && GetPlayerInterior(playerid) == DealerInfo[D_IDX][dInterior])
					{   
                        //new 
                         //   family_id = pInfo[playerid][pFamily] - 1;
                       // if ( ((pInfo[playerid][pFamily] > 0) && FamilyHouse[ FamilyInfo[ family_id ][fHouse] ][fhBikers] == fraction_id) || (IsAGang(playerid) || pInfo[playerid][pAdmin])) {
                            format(t_string, sizeof t_string, ""colserver"[№] Тип наркотиков\t"colserver"Цена за грамм\t"colserver"Кол-во у торговца\n\
                                "colwhi"[0] Купить тяжелые наркотики\t"collime"$%d\t"colwhi"%d",
                                //[1] Купить Легкие наркотики\t"collime"$%d\t%d", 
                                DealerInfo[D_IDX][dCost][0], DealerInfo[D_IDX][dDrugs], DealerInfo[D_IDX][dCost][1], DealerInfo[D_IDX][dSpeedDrugs]
                            ); 
                            ShowPlayerDialog(playerid, D_BIKER_FUNC_5, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Наркопритон: "colwhi"Наркоторговец", t_string, "Выбрать", "Закрыть"), t_string[0] = EOS;
                        //} else {
                            //SendClientMessage(playerid, COLOR_GREY, !"Вы не бандит и не клиент данного притона!");
                        //}
						isReturn = true;
					}  
				}  
			}
			if (isReturn) return true; 
		}
	}
	return isReturn;
}
new 
    SecondMinite = 0;
Fraction_SecondTimer() {
    if (++SecondMinite > 60) {
        new 
            current_time = gettime(),
            string_[320];
        for(new idx = 0; idx < 8; idx ++) {
            if (l_actor[0][idx] && l_actort[0][idx] <= current_time) {
                l_actor[0][idx] = 0, UpdateDrugsLabrary(0,idx,0);
            }
            if (l_actor[1][idx] && l_actort[1][idx] <= current_time) {
                l_actor[1][idx] = 0, UpdateDrugsLabrary(1,idx,0);
            }
            if (l_actor[2][idx] && l_actort[2][idx] <= current_time) {
                l_actor[2][idx] = 0, UpdateDrugsLabrary(2,idx,0);
            }
            if (l_actor[0][idx] && l_actort[0][idx] > current_time) {
                if (FractionInfo[FRACTION_MONGOLS_MC][fDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_MONGOLS_MC][fDrugs] += 10;
                }
                if (FractionInfo[FRACTION_MONGOLS_MC][fSpeedDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_MONGOLS_MC][fSpeedDrugs] += 10;
                } 
                SaveFractionDrugsID(FractionInfo[FRACTION_MONGOLS_MC][fID]); 
            }
            if (l_actor[1][idx] && l_actort[1][idx] > current_time) {
                if (FractionInfo[FRACTION_BANDIDOS_MC][fDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_BANDIDOS_MC][fDrugs] += 10;
                }
                if (FractionInfo[FRACTION_BANDIDOS_MC][fSpeedDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_BANDIDOS_MC][fSpeedDrugs] += 10;
                } 
                SaveFractionDrugsID(FractionInfo[FRACTION_BANDIDOS_MC][fID]); 
            }
            if (l_actor[2][idx] && l_actort[2][idx] > current_time) {
                if (FractionInfo[FRACTION_OUTLAWS_MC][fDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_OUTLAWS_MC][fDrugs] += 10;
                }
                if (FractionInfo[FRACTION_OUTLAWS_MC][fSpeedDrugs] < STORE_LIMITS_DRUGS) {
                    FractionInfo[FRACTION_OUTLAWS_MC][fSpeedDrugs] += 10;
                } 
                SaveFractionDrugsID(FractionInfo[FRACTION_OUTLAWS_MC][fID]); 
            }
        }
        format(string_, sizeof string_, "На складе:\n\n\
            "colwhi"Тяжелые наркотики: {F58B11}%d гр\n\
            "colwhi"Легкие наркотики: {F58B11}%d гр\n\n{CAFA0A}Используйте: ALT", FractionInfo[FRACTION_MONGOLS_MC][fDrugs], FractionInfo[FRACTION_MONGOLS_MC][fSpeedDrugs]
        );
        UpdateDynamic3DTextLabelText(FractionInfo[FRACTION_MONGOLS_MC][fLabText], -1, string_);

        format(string_, sizeof string_, "На складе:\n\n\
            "colwhi"Тяжелые наркотики: {F58B11}%d гр\n\
            "colwhi"Легкие наркотики: {F58B11}%d гр\n\n{CAFA0A}Используйте: ALT", FractionInfo[FRACTION_BANDIDOS_MC][fDrugs], FractionInfo[FRACTION_BANDIDOS_MC][fSpeedDrugs]
        );
        UpdateDynamic3DTextLabelText(FractionInfo[FRACTION_BANDIDOS_MC][fLabText], -1, string_);

        format(string_, sizeof string_, "На складе:\n\n\
            "colwhi"Тяжелые наркотики: {F58B11}%d гр\n\
            "colwhi"Легкие наркотики: {F58B11}%d гр\n\n{CAFA0A}Используйте: ALT", FractionInfo[FRACTION_OUTLAWS_MC][fDrugs], FractionInfo[FRACTION_OUTLAWS_MC][fSpeedDrugs]
        );
        UpdateDynamic3DTextLabelText(FractionInfo[FRACTION_OUTLAWS_MC][fLabText], -1, string_);

        SecondMinite = 0;
        
    }
}

stock ShowListEmploeesBikersLabrary(playerid) {
    new 
        member = -1;
    if (pInfo[playerid][pMember] == FRACTION_MONGOLS_MC) member = 0;
    else if (pInfo[playerid][pMember] == FRACTION_BANDIDOS_MC) member = 1;
    else if (pInfo[playerid][pMember] == FRACTION_OUTLAWS_MC) member = 2;
    if (member == -1) return SendClientMessage(playerid, COLOR_GREY, !"Временно недоступно");
 
    t_string[0] = EOS;
    strcat(t_string, ""colserver"[№] Рабочий №[ID]\t"colserver"Статус\tСрок найма\n");
    for(new i; i < 8; i ++) {
        if (!l_actor[member][i]) format(t_string, sizeof t_string, "%s"colwhi"[%d] Рабочий №[%d]\t"colwarn"Не нанят\t"colwarn"Не нанят\n", t_string, i, i+1);
        else {
            timestamp_to_date(l_actort[member][i]-gettime(), year, month, day, hour, minute, second);
            format(t_string, sizeof t_string, "%s"colwhi"[%d] Рабочий №[%d]\t"collime"Нанят\t%dд %dч %dм\n", t_string, i, i+1, day-1, hour ,minute);
        }
    }
    ShowPlayerDialog(playerid, D_BIKER_FUNC_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Лаборатория: "colwhi"Сотрудники", t_string, "Выбрать", "Закрыть");
    return 1;
}
CMD:loaddrugs(playerid)
{
	if(IsABiker(playerid))
	{
        if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть за рулём автомобиля!");
		new 
            V_IDX = GetPlayerVehicleID(playerid); 
        if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
            (VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_MONGOLS_MC || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_BANDIDOS_MC || VehicleInfo[ V_IDX - 1 ][vFraction] == FRACTION_OUTLAWS_MC))
        {
            if (VehicleInfo[ V_IDX - 1 ][vModel] != 459) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в фургоне!");
            //if(!LoadMat(vehicleid)) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в фургоне для патрон или не в хамере!");
        // if (pTemp[playerid][pRentCar] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в рабочем транспорте!");
            //if (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
            //new string[10];//VehicleInfo[ V_IDX - 1 ][vJobLoad] = false; 
            if(VehicleInfo[ V_IDX - 1 ][vJobLoad])
            { 
                if (VehicleInfo[ V_IDX - 1 ][vFarmText] != Text3D:-1) { 
                    DestroyDynamic3DTextLabel(VehicleInfo[ V_IDX - 1 ][vFarmText]); 
                    VehicleInfo[ V_IDX  - 1 ][vFarmText] = Text3D:-1;
                } 
                DestroyDynamicArea(VehicleInfo[ V_IDX - 1 ][vJobArea]);
                DestroyDynamicPickup(VehicleInfo[ V_IDX - 1 ][vJobPickup]); 
                VehicleInfo[ V_IDX - 1 ][vJobLoad] = false;
                SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещения] "colwhi"Вы отменили загрузку");
                return 1;
            }
            new Float:angle,Float:distance,Float:vehx, Float:vehy, Float:vehz;
            GetVehicleModelInfo(VehicleInfo[ V_IDX - 1 ][vModel], 1, vehx, distance, vehz);
            distance = distance/2 + 0.1;
            GetVehiclePos(V_IDX, vehx, vehy, vehz); 
            GetVehicleZAngle(V_IDX, angle);
            vehx += (distance * floatsin(-angle+180, degrees));
            vehy += (distance * floatcos(-angle+180, degrees));

            new 
                string_[128];  
            format(string_, sizeof string_, ""colwhi"Тяжелые наркотики: "colmaline"%d/10 сумок\n"colwhi"Легкие наркотики: "colmaline"%d/10 сумок", 
                VehicleInfo[ V_IDX - 1 ][vJobAmount][0], VehicleInfo[ V_IDX - 1 ][vJobAmount][1]
            );
            if (VehicleInfo[ V_IDX - 1 ][vFarmText] == Text3D:-1) { 
                VehicleInfo[ V_IDX - 1 ][vFarmText] = CreateDynamic3DTextLabel(string_, COLOR_WHITE, vehx, vehy, vehz+0.5, 15.0);
            }  
            VehicleInfo[ V_IDX - 1 ][vJobPickup] = CreateDynamicPickup(11745,1, vehx, vehy, vehz-0.5);


            VehicleInfo[ V_IDX - 1 ][vJobArea] = CreateDynamicSphere(vehx, vehy, vehz, 1.0, 0, INTERIOR_NONE);
            SetDynamicAreaType(VehicleInfo[ V_IDX - 1 ][vJobArea], AREA_TYPE_TAKE_DRUGS, V_IDX); 

            VehicleInfo[ V_IDX - 1 ][vJobLoad] = true;
            RemovePlayerFromVehicle(playerid);  
            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Заполните фургон наркотиками..."); 
        }
        else SendClientMessage(playerid, COLOR_GREY, !"Вы не в фургоне!");
	}
	return 1;
}


CMD:clientlist(playerid,params[])
{ 
 	if(!IsABiker(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Данная команда доступна байкерским клубам"); 
	for(new i = 0, count_ammo = 1; i < S_FAMILY_HOUSE_COUNT; i++)  
 	{ 
    	format(t_string, (count_ammo*80),"%s"colwhi"[%d] Дом: %s\t[%s]\n", t_string, count_ammo, FamilyHouse[i][fhOwner], gFraction[ FamilyHouse[i][fhBikers] ][fName]);
        count_ammo++;
  	}
  	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_TABLIST, ""colserver"Список: "colwhi"Клиентов", t_string, "Выбрать", "Назад");
	return 1;
}
CMD:rundrugs(playerid, params[])
{
    if (pTemp[playerid][tPaintTeam] != 0 || IsPlayerInDuel(playerid)) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на дуэлях / PB");
	if (pTemp[playerid][tDMArea][0]) return SendClientMessage(playerid, COLOR_GRAD1, !"Нельзя использовать на ДМ-Арене");
	if (GetPVarInt(playerid, #PlayerAnimation ) == 1) {
		ClearAnimations(playerid);
		SetPVarInt(playerid, #PlayerAnimation, 0);
		TextDrawHideForPlayer(playerid, InfoAnimDraw);
	}

	if (pTemp[playerid][tAntiCrack] > gettime()) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны подождать перед следующим приемом наркотиков.");
	if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_GREY, !"Введите: /rundrugs [кол-во]"); 
	if (params[0] > 3 || params[0] < 1) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Нельзя меньше 1 грамма и больше 3 грамм!");
	if (!pInfo[playerid][pLDrugs]) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно наркотиков");
	if (pInfo[playerid][pLDrugs] < params[0]) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно наркотиков");
	pInfo[playerid][pLDrugs] -= params[1]; 
    ApplyAnimation(playerid,"SMOKING","M_smk_drag",4.1,0,0,0,0,0,1);
    pTemp[playerid][tAntiCrack] = gettime()+30;
    SetTimerEx("RunDrugs", 10_000, false, "i", playerid); 
    pTemp[playerid][tDrugsRun] = true;
    SetPlayerWeather(playerid, 1);
    SetPlayerDrunkLevel(playerid, 2600);
    if(GetPlayerHP(playerid)+5.0*params[0] > 160) SetPlayerHealth(playerid, 160.0);
    else SetPlayerHealth(playerid, GetPlayerHP(playerid)+5.0*params[0]);

	SendMes(playerid, COLOR_WHITE, "(( Здоровье пополнено до: %0.0f ))", GetPlayerHP(playerid));
    SendMes(playerid, COLOR_WHITE, "(( Осталось легких наркотиков: %d ))", pInfo[playerid][pLDrugs]);
	MeAction(playerid,"употребил легкие наркотики",0);
	return 1; 
}
publics: RunDrugs(playerid) { 
    pTemp[playerid][tDrugsRun] = false;
    new time[3];
    gettime(time[0], time[1], time[2]);
    SetPlayerTime(playerid, time[0], time[1]);
    SetPlayerWeather(playerid, 7);
    SetPlayerDrunkLevel(playerid, 0);
	return 1;
} 
stock SaveFractionDrugsID(idx, bool: save = true) {
	if (save) {
		new
		    query_[300];
		mysql_format(dbHandle, query_, sizeof query_, 
			"UPDATE `s_fractionbank` SET `fSpeedDrugs` = '%d', `fDrugs` = '%d' WHERE `fID` = '%d' LIMIT 1",
			FractionInfo[idx][fSpeedDrugs], FractionInfo[idx][fDrugs], 
			FractionInfo[idx][fID]
		);
		mysql_tquery(dbHandle, query_, "", ""); 
	} 
	return 1;
}
// a && b();              // if a, run b.
// a && b() || c();       // if a, run b. otherwise, run c.
// a || b();              // if not a, run b.
// a && b() || c && d();  // if a, run b. otherwise, if c, run d.
// a && b() && c();       // if a, run b. if b isn't false, run c.