stock load_vote() {
	new 
		rows, 
		Cache:result = mysql_query(connects, "SELECT * FROM `vote`"); 
	cache_get_row_count(rows);
	if (!rows) {
		print (!"[Загрузка ...] Голосований нет");
		if (cache_is_valid(result)) cache_delete(result);
		return true;
	} 
	for(new i=0; i<rows; i++) {
		cache_get_value_index(i, 0, vote_name[i], 25);
		cache_get_value_index_int(i, 1, vote_count[i]);
	} 
	if (cache_is_valid(result)) cache_delete(result);
	print (!"[Загрузка ...] Голосование загружено");
	return 1;
}
stock load_bint() {
	new Cache:result = mysql_query(connects, "SELECT * FROM `bints`");
	new rows = cache_num_rows();
	if(rows != BINT_COUNT) print("Кол-во БИНТ'ов в базе не совпадает с предопределным количеством");
	else for(new i; i < rows;i++) {
		cache_get_value_name_int(i,"id", gBints[i][bintID]);
		cache_get_value_name_int(i,"interior", gBints[i][bintInterior]);

		cache_get_value_name_float(i, "x", gBints[i][bintX]);
        cache_get_value_name_float(i, "y", gBints[i][bintY]);
        cache_get_value_name_float(i, "z", gBints[i][bintZ]);
        cache_get_value_name_float(i, "r", gBints[i][bintR]);

        cache_get_value_name_float(i, "xb", gBints[i][bintXB]);
        cache_get_value_name_float(i, "yb", gBints[i][bintYB]);
        cache_get_value_name_float(i, "zb", gBints[i][bintZB]);

        cache_get_value_name(i, "name", gBints[i][bintName], 32);

		gBintEnterArea[i] = CreateDynamicSphere(gBints[i][bintX],gBints[i][bintY],gBints[i][bintZ],1.0);
		CreateDynamicPickup(19132,1,gBints[i][bintX],gBints[i][bintY],gBints[i][bintZ],-1);
		switch(gBints[i][bintID]) {
			case 22: CreateDynamicPickup(19893,1,gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB],-1);
			case 25: CreateDynamicPickup(1275,1,gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB],-1);
			default: CreateDynamicPickup(1239,1,gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB],-1);
		}
	}
	for(new i = 0;i<BINT_COUNT;i++) gBintBuyArea[i] = CreateDynamicSphere(gBints[i][bintXB],gBints[i][bintYB],gBints[i][bintZB],1.0);
	printf("[Загрузка ...] Интереьры бизнесов успешно загружены (%i шт.)",rows);
	if (cache_is_valid(result)) cache_delete(result);
	return true;
}
stock load_market() {
	new rows, Cache:result = mysql_query(connects, "SELECT * FROM `blackmarket`");
	rows = cache_num_rows();
	if(rows) {
		for(new i = 0; i < rows; i++) {
			cache_get_value_index_int(i,1, black_prods[0]);
			cache_get_value_index_int(i,2, black_prods[1]);
			cache_get_value_index_int(i,3, black_prods[2]);
			cache_get_value_index_int(i,4, black_prods[3]);
			cache_get_value_index_int(i,5, black_prods[4]);

			cache_get_value_index_int(i,6, black_prods[5]);
			cache_get_value_index_int(i,7, black_prods[6]);
			cache_get_value_index_int(i,8, black_prods[7]);
			cache_get_value_index_int(i,9, black_prods[8]);

			cache_get_value_index_int(i,10, black_prods[9]);
		}
	}
    if (cache_is_valid(result)) cache_delete(result);
    printf("[Загрузка ...] Черный рынок успешно загружен (%i шт.)",rows);
	check_terrs();
    return true;
}
stock load_labrary() {
	new rows;
	new Cache:result = mysql_query(connects, "SELECT * FROM `labrary`");
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
	for(new gang = 0; gang < 8; gang ++) {
		if(l_actor[0][gang]) UseLabrary(0,gang,1);
		if(l_actor[1][gang]) UseLabrary(1,gang,1);
		if(l_actor[2][gang]) UseLabrary(2,gang,1);
	}
    if (cache_is_valid(result)) cache_delete(result);
    printf("[Загрузка ...] Лаборатории успешно загружены (%i шт.)",rows);
    return true;
}
stock load_fracgun() {
	new rows, Cache:result = mysql_query (connects, "SELECT * FROM `frac_weapon`");
	rows = cache_num_rows();
	if(rows) {
		for(new i = 0, slot, fraction; i < rows ; i++) { 
		   cache_get_value_int(i,"Slot", slot);
		   cache_get_value_int(i,"Fraction", fraction);
		   cache_get_value_int(i,"fwID", FW[slot][fraction][fwID]);
		   cache_get_value_int(i,"fwGunID", FW[slot][fraction][fwGunID]);
		   cache_get_value_int(i,"fwGunAmmo", FW[slot][fraction][fwGunAmmo]);
		   cache_get_value_int(i,"fwArmor", FW[slot][fraction][fwArmor]);
		   cache_get_value_int(i,"fwRank", FW[slot][fraction][fwRank]);
		   cache_get_value(i, "fwName", FW[slot][fraction][fwName],64);
		}
	}
	if (cache_is_valid(result)) cache_delete(result);
	print("[Загрузка ...] Оружие фракций успешно загружены");
	return 1;
}
stock load_economy() {
	new rows, Cache:result = mysql_query(connects, "SELECT * FROM `economy`");
	rows = cache_num_rows();
    if(rows) {
		new data[256];
		cache_get_value(0, "salary_pd", data), sscanf(data,"p<|>a<i>[12]",FracSalary[0]);
		cache_get_value(0, "salary_fbi", data), sscanf(data,"p<|>a<i>[11]",FracSalary[1]);
		cache_get_value(0, "salary_mayor", data), sscanf(data,"p<|>a<i>[7]",FracSalary[2]);
		cache_get_value(0, "salary_army", data), sscanf(data,"p<|>a<i>[15]",FracSalary[3]);
		cache_get_value(0, "salary_medics", data), sscanf(data,"p<|>a<i>[10]",FracSalary[4]);
		cache_get_value(0, "salary_news", data), sscanf(data,"p<|>a<i>[10]",FracSalary[5]);
		cache_get_value(0, "salary_mafia", data), sscanf(data,"p<|>a<i>[10]",FracSalary[6]);
		cache_get_value(0, "salary_gang", data), sscanf(data,"p<|>a<i>[10]",FracSalary[7]);
		cache_get_value(0, "salary_whitehouse", data), sscanf(data,"p<|>a<i>[12]",FracSalary[8]);

		cache_get_value_name_int(0, "work_gun", WorkSalary[0]);
		cache_get_value_name_int(0, "work_oil", WorkSalary[1]);
		cache_get_value_name_int(0, "work_alco", WorkSalary[2]);
		cache_get_value_name_int(0, "work_apple", WorkSalary[3]);
		cache_get_value_name_int(0, "work_wood", WorkSalary[4]);
		cache_get_value_name_int(0, "work_loader", WorkSalary[5]);
		cache_get_value_name_int(0, "work_mine", WorkSalary[6]);

		cache_get_value_name_int(0, "nalog_1", Nalog[0]);//процентов от суммы дохода за час
		cache_get_value_name_int(0, "nalog_2", Nalog[1]);//пенсионный возраст
		cache_get_value_name_int(0, "nalog_3", Nalog[2]);//размер пенсии
		cache_get_value_name_int(0, "nalog_4", Nalog[3]);//процент от прибыли бизнеса государству
		cache_get_value_name_int(0, "nalog_5", Nalog[4]);//процент от прибыли бизнеса мафии
		cache_get_value_name_int(0, "nalog_6", Nalog[5]);//налог при переводе игроку виртуальной валюты через банк
		cache_get_value_name_int(0, "nalog_7", Nalog[6]);//20 % от гос. Стоимости дома и 50% от купленых улучшений ( при слёте ) – 80 % возвращается игроку.
    }
    if (cache_is_valid(result)) cache_delete(result);
    print("[Загрузка ...] Экономика успешно загружена");
    return true;
}
stock load_atm() {
	new rows, Cache:result = mysql_query(connects, "SELECT * FROM `atms`");
	cache_get_row_count(rows);
	if (!rows) {
		print("Не обнаружено ATMS в базе");
		if (cache_is_valid(result)) cache_delete(result);
		return true;
	} 
	for(new i = 0, atmID; i < rows;i++) { 
		cache_get_value_int(i, "atmID", atmID);

		cache_get_value_float(i, "ATM_X", ATMData[atmID][ATM_Pos][0]);
		cache_get_value_float(i, "ATM_Y", ATMData[atmID][ATM_Pos][1]);
		cache_get_value_float(i, "ATM_Z", ATMData[atmID][ATM_Pos][2]);
		cache_get_value_float(i, "ATM_ROTX", ATMData[atmID][ATM_Pos][3]);
		cache_get_value_float(i, "ATM_ROTY", ATMData[atmID][ATM_Pos][4]);
		cache_get_value_float(i, "ATM_ROTZ", ATMData[atmID][ATM_Pos][5]);

		ATMData[atmID][atm_Taken] = 1;

		cache_get_value_int(i, "ATM_VW", ATMData[atmID][atm_VW]);
		cache_get_value_int(i, "ATM_INT", ATMData[atmID][atm_INT]);

		cache_get_value_int(i, "ATM_BANK", ATMData[atmID][atm_Bank]);
		cache_get_value_int(i, "ATM_BANKTIME", ATMData[atmID][atm_BankTime]);

		ATMData[atmID][atm_Object] = CreateDynamicObject(2754, 
			ATMData[atmID][ATM_Pos][0], ATMData[atmID][ATM_Pos][1], ATMData[atmID][ATM_Pos][2], 
			0.0, 0.0, ATMData[atmID][ATM_Pos][5], ATMData[atmID][atm_VW], ATMData[atmID][atm_INT]
		);
		UpdateATMLabel(atmID);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Банкоматы успешно загружены (%i шт.)", rows);
	return 1;
}
stock load_funcbizz() {
	new 
		rows, 
		Cache:result = mysql_query(connects, "SELECT * FROM `business_func`"); 
    if(rows >= MAX_BUSINESS_COUNT) print("Кол-во func бизнеса в базе превышает предопределнное количество");
	else if(!rows) print("Не обнаружено func бизнесов в базе");
	else for(new i = 0, b_car[128], tarif[64]; i < rows;i++) {
		cache_get_value_name_int(i,"bizzID", FuncBizz[i][funcbID]);
		cache_get_value_name_int(i,"ID", FuncBizz[FuncBizz[i][funcbID]][funcbSlot]);
		cache_get_value_name(i, "name", FuncBizz[FuncBizz[i][funcbID]][funcbName], 20);
		cache_get_value_name(i, "name_car", FuncBizz[FuncBizz[i][funcbID]][funcbNameCar], 12);
		cache_get_value_name_int(i,"number", FuncBizz[FuncBizz[i][funcbID]][funcbNum]); 

		cache_get_value(i, "car", b_car);
		sscanf(b_car,"p<|>a<i>[20]",FuncBizz[FuncBizz[i][funcbID]][funcbCar]);
		cache_get_value(i, "tarif", tarif);
		sscanf(tarif,"p<|>a<i>[4]",FuncBizz[FuncBizz[i][funcbID]][funcbTarif]);

		cache_get_value_name_int(i,"color", FuncBizz[FuncBizz[i][funcbID]][funcbColor]);
		cache_get_value_name_int(i,"color_shash", FuncBizz[FuncBizz[i][funcbID]][funcbShash]);
		cache_get_value_name_int(i,"percent", FuncBizz[FuncBizz[i][funcbID]][funcbPercent]);
		cache_get_value_name_float(i,"percent2", FuncBizz[FuncBizz[i][funcbID]][funcbPercent2]);
		cache_get_value_name_int(i,"percent3", FuncBizz[FuncBizz[i][funcbID]][funcbPercent3]);
		switch(FuncBizz[i][funcbID]) {
			case 2 .. 4, 5 .. 7: {
				biz_text[FuncBizz[FuncBizz[i][funcbID]][funcbSlot]] = CreateDynamicObject(19482, 2402.697021, -33.206501, 1030.597290, 0.000000, 0.000000, 0.000000, FuncBizz[i][funcbID], -1, -1, 50.00);
				new string[54];
				format(string, sizeof(string),"{%s}%s", color_td[FuncBizz[FuncBizz[i][funcbID]][funcbColor]][col_rgb], FuncBizz[FuncBizz[i][funcbID]][funcbName]);
				SetDynamicObjectMaterialText(biz_text[FuncBizz[FuncBizz[i][funcbID]][funcbSlot]], 0, string, 130, "Segoe Script", 50, 1, 0xFF000000, 0x00000000, 1);

				for(new z = 0; z < 20; z++) {
					if(FuncBizz[FuncBizz[i][funcbID]][funcbCar][z] == 0) {
						FuncBizz[FuncBizz[i][funcbID]][funcbCars][z] = INVALID_VEHICLE_ID;
						continue;
					}
					creare_funccar(FuncBizz[i][funcbID],z);
				}
			}
		}
    }
    if (cache_is_valid(result)) cache_delete(result);
    printf("[Загрузка ...] Функции бизнеса успешно загружена (%i шт.)",rows);
    return true;
}
stock load_business() {
    new Cache:result;
	result = mysql_query(connects, "SELECT * FROM `business`");
	gBusinessCount = cache_num_rows();
	new sqlstring[67];
	if(gBusinessCount >= MAX_BUSINESS_COUNT) print("Кол-во бизнесов в базе превышает предопределнное количество");
	else if(!gBusinessCount) print("Не обнаружено бизнесов в базе");
	else for(new i; i<gBusinessCount;i++) {
		cache_get_value_name_int(i,"id", gBusiness[i][bizzID]);

        cache_get_value_name(i, "name", gBusiness[i][bizzName], 64);

        cache_get_value_name_int(i,"type", gBusiness[i][bizzType]);
        cache_get_value_name_int(i,"bint", gBusiness[i][bizzBint]);
        cache_get_value_name_int(i,"ownerid", gBusiness[i][bizzOwnerID]);
        cache_get_value_name_int(i,"sellprice", gBusiness[i][bizzSellPrice]);
        cache_get_value_name_int(i,"bank", gBusiness[i][bizzBank]);
		cache_get_value_name_int(i,"bankday", gBusiness[i][bizzBankDay]);
        cache_get_value_name_int(i,"price", gBusiness[i][bizzPrice]);
		cache_get_value_name_int(i,"enter", gBusiness[i][bizzEnter]);

		cache_get_value(i, "upgrade", sqlstring , 65), sscanf (sqlstring, "p<|>iii",
		gBusiness[i][bizzUpgrade][0], gBusiness[i][bizzUpgrade][1], gBusiness[i][bizzUpgrade][2]);

        cache_get_value_name_int(i,"product", gBusiness[i][bizzProduct]);
		cache_get_value_name_int(i,"order", gBusiness[i][bizzProdOrder]);
		cache_get_value_name_int(i,"orderprice", gBusiness[i][bizzProdOrderPrice]);

        cache_get_value_name_int(i,"status", gBusiness[i][bizzStatus]);

        cache_get_value_name_float(i, "x", gBusiness[i][bizzX]);
        cache_get_value_name_float(i, "y", gBusiness[i][bizzY]);
        cache_get_value_name_float(i, "z", gBusiness[i][bizzZ]);
        cache_get_value_name_float(i, "r", gBusiness[i][bizzR]);

		cache_get_value_name_int(i,"deliving", gBusiness[i][bizzDay]);
		cache_get_value_name_int(i,"mafia", gBusiness[i][bizzMafia]);

		cache_get_value_name(i, "owner", gBusiness[i][bizzOwner], MAX_PLAYER_NAME);

		switch(gBusiness[i][bizzID]) {
			case 8: {
				CreateDynamicPickup(19132,1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],46,78);
				gBusinessText[i] = CreateDynamic3DTextLabel("_",-1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]+1.0,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, 46, 78);
				b_area[i] = CreateDynamicSphere(gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],1.5,46,78,-1);
			}
			case 9: {
				CreateDynamicPickup(19132,1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],47,78);
				gBusinessText[i] = CreateDynamic3DTextLabel("_",-1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]+1.0,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, 47, 78);
				b_area[i] = CreateDynamicSphere(gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],1.5,47,78,-1);
			}
			case 10: {
				CreateDynamicPickup(19132,1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],48,78);
				gBusinessText[i] = CreateDynamic3DTextLabel("_",-1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]+1.0,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, 48, 78);
				b_area[i] = CreateDynamicSphere(gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],1.5,48,78,-1);
			}
			case 82: {
				CreateDynamicPickup(19627,1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],0,0);
				gBusinessText[i] = CreateDynamic3DTextLabel("_",-1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]+1.0,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, -1, -1);
				b_area[i] = CreateDynamicSphere(gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],1.5);
			}
			default: {
				if(gBusiness[i][bizzType] != 7) CreateDynamicPickup(19132,1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]);
				gBusinessText[i] = CreateDynamic3DTextLabel("_",-1,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]+1.0,20.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, -1, -1);
				b_area[i] = CreateDynamicSphere(gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ],1.5);
			}
		}
		new icon = 0, bint = gBusiness[i][bizzBint];
		switch(bint) {
			case 0: {
				if(gBusiness[i][bizzType] == 18) icon = 27;
				else icon = 47;
			}
			case 1..4,11,12: icon = 49;
			case 5, 7.. 10: icon = 45;
			case 6: icon = 7;
			case 16: icon = 10;
			case 17: icon = 14;
			case 18: icon = 29;
			case 19..21: icon = 6;
			case 50: icon = 55;
			case 22: icon = 42;
			case 23: icon = 48;
			case 24: icon = 34;
			case 25: icon = 54;
			case 13..15: icon = 17;
		}
		if(icon) {
			if(gBusiness[i][bizzType] != 15) gBusinessIcon[i] = CreateDynamicMapIcon(gBusiness[i][bizzX], gBusiness[i][bizzY], gBusiness[i][bizzZ], icon, -1);
		}
		UpdateBusinessText(i);
	}
	printf("[Загрузка ...] Бизнесы успешно загружены (%i шт.)",gBusinessCount);
	cache_delete(result);
	return 1;
}
stock load_heal() { 
	new rows,
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`MedHeal` FROM `accounts` WHERE `pMember` = 8 ORDER BY `MedHeal` DESC LIMIT 5");
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(med_turn_text[0], -1, ""W"Лучшие работники:\n\nЕще нет");
		load_heal_2();
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n";
	for(new i, member, heal, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "MedHeal",heal);
		new str_[64]; 
		format(str_, sizeof str_,""ORANGE"%d. "G"%s [%d]\n", 
			i+1, name_, heal
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(med_turn_text[0], -1, string_1024), string_1024[0] = EOS; 
	} 
	if (cache_is_valid(result)) cache_delete(result);
 
	disease = random(3);
	string_1024[0] = EOS;  
	string_1024 = ""W"Зона заражения:";
	switch(disease) {
		case 0: {
			format(string_1024, sizeof string_1024, "%s\n"P"Гетто", string_1024);
			UpdateDynamic3DTextLabelText(med_turn_text[3], -1, string_1024);
		}
		case 1: {
			format(string_1024, sizeof string_1024, "%s\n"P"Заброшеный аэропорт",string_1024);
			UpdateDynamic3DTextLabelText(med_turn_text[3], -1, string_1024);
		}
		case 2: {
			format(string_1024, sizeof string_1024, "%s\n"P"Карьер",string_1024);
			UpdateDynamic3DTextLabelText(med_turn_text[3], -1, string_1024);
		}
	}
	load_heal_2();
	return 1;
}
stock load_heal_2() {
	new rows,
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`MedHeal` FROM `accounts` WHERE `pMember` = 9 ORDER BY `MedHeal` DESC LIMIT 5");
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(med_turn_text[1], -1, ""W"Лучшие работники:\n\nЕще нет");
		load_heal_3();
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n"; 
	for(new i, member, heal, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "MedHeal",heal);
		new	
			str_[64];
		format(str_, sizeof str_, ""ORANGE"%d. "G"%s [%d]\n",
			i+1,name_,heal
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(med_turn_text[1], -1, string_1024);
	} 
	if (cache_is_valid(result)) cache_delete(result);
	load_heal_3();
	return 1;
}
stock load_heal_3() {
	new rows,
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`MedHeal` FROM `accounts` WHERE `pMember` = 10 ORDER BY `MedHeal` DESC LIMIT 5");
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(med_turn_text[2], -1, ""W"Лучшие работники:\n\nЕще нет");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n"; 
	for(new i, member, heal, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "MedHeal",heal);
		new	
			str_[64];
		format(str_, sizeof str_, ""ORANGE"%d. "G"%s [%d]\n",
			i+1,name_,heal
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(med_turn_text[2], -1, string_1024);
	} 
	string_1024[0] = EOS; 
	if (cache_is_valid(result)) cache_delete(result);
	return 1;
}
stock load_advert() { 
	new 
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`Advert` FROM `accounts` WHERE `pMember` = 11 ORDER BY `Advert` DESC LIMIT 5");

	new rows;
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(advert_turn_text[0], -1, ""W"Лучшие работники:\n\nЕще нет");
		load_advert_2();
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n";  
	for(new i, member, advert, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "Advert",advert);
		new 
			str_[64];
		format(str_, sizeof str_, ""ORANGE"%d. "G"%s [%d]\n",
			i + 1, name_, advert
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(advert_turn_text[0], -1, string_1024);
	}  
	if (cache_is_valid(result)) cache_delete(result);
	load_advert_2();
	return 1;
}
stock load_advert_2() {
	new 
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`Advert` FROM `accounts` WHERE `pMember` = 12 ORDER BY `Advert` DESC LIMIT 5"), rows;
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(advert_turn_text[1], -1, ""W"Лучшие работники:\n\nЕще нет");
		load_advert_3();
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n";  
	for(new i, member, advert, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "Advert",advert);
		new 
			str_[64];
		format(str_, sizeof str_, ""ORANGE"%d. "G"%s [%d]\n",
			i + 1, name_, advert
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(advert_turn_text[1], -1, string_1024);
	} 
	if (cache_is_valid(result)) cache_delete(result);
	load_advert_3();
	return 1;
}
stock load_advert_3() {
	new 
		Cache:result = mysql_query(connects, "SELECT `Name`,`pMember`,`Advert` FROM `accounts` WHERE `pMember` = 11 ORDER BY `Advert` DESC LIMIT 5"), rows;
	cache_get_row_count(rows);
	if(!rows) {
		UpdateDynamic3DTextLabelText(advert_turn_text[2], -1, ""W"Лучшие работники:\n\nЕще нет"); 
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	string_1024[0] = EOS; 
	string_1024 = ""W"Лучшие работники:\n\n";  
	for(new i, member, advert, name_[MAX_PLAYER_NAME]; i < rows; i ++) {
		cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME);
		cache_get_value_name_int(i, "pMember",member);
		cache_get_value_name_int(i, "Advert",advert);
		new 
			str_[64];
		format(str_, sizeof str_, ""ORANGE"%d. "G"%s [%d]\n",
			i + 1, name_, advert
		);
		strcat(string_1024, str_);
		UpdateDynamic3DTextLabelText(advert_turn_text[2], -1, string_1024);
	} 
	if (cache_is_valid(result)) cache_delete(result);
	return 1;
}
stock load_fracfreez() {
	new rows,
		Cache:result = mysql_query(connects, "SELECT * FROM `fracmorozed`");
	cache_get_row_count(rows);
    for(new f = 0; f < 8; f++) {
		cache_get_value_index_int(0, f, fracmoroz[f]);
	}
    if (cache_is_valid(result)) cache_delete(result);
    printf("[Загрузка ...] Фриз банд/мафий успешно загружен (%i шт.)",rows);
    return true;
}
stock load_airplane() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `plane`");
	gPlaneCount = cache_num_rows();
	for(new i = 1, str_[64]; i <= gPlaneCount; i++) {
		cache_get_value_name_int(i-1, "ID", gAirplanes[i][aID]);
		cache_get_value_name_int(i-1, "Airport", gAirplanes[i][aAirport]);
		cache_get_value_name_int(i-1, "Plane", gAirplanes[i][aPlane]);

		cache_get_value_name(i-1, "Owner", gAirplanes[i][aOwner], MAX_PLAYER_NAME);

		cache_get_value_name_int(i-1, "Time", gAirplanes[i][aTime]);
		cache_get_value_name_int(i-1, "Price", gAirplanes[i][aPrice]);

		cache_get_value_name_float(i-1, "Fuel", gAirplanes[i][aFuel]);
		cache_get_value_name_float(i-1, "PosX", gAirplanes[i][aPos][0]);
		cache_get_value_name_float(i-1, "PosY", gAirplanes[i][aPos][1]);
		cache_get_value_name_float(i-1, "PosZ", gAirplanes[i][aPos][2]);
		cache_get_value_name_float(i-1, "PosXY", gAirplanes[i][aPos][3]);

		gAirplanes[i][aCar] = CreateJobVehicle(99,gAirplanes[i][aPlane], gAirplanes[i][aPos][0], gAirplanes[i][aPos][1], gAirplanes[i][aPos][2], gAirplanes[i][aPos][3], -1, -1, 400);
		VehicleInfo[gAirplanes[i][aCar]][vFuel] = gAirplanes[i][aFuel]; 
		if(!strcmp(gAirplanes[i][aOwner],"State",true)) format(str_, sizeof str_,"Не арендован", gAirplanes[i][aOwner]);
		else format(str_, sizeof str_,"Арендатор - "O"%s", gAirplanes[i][aOwner]); 
		gAirplanes[i][aText] = CreateDynamic3DTextLabel(str_, -1, 0.0, 0.45, 1.1,20.0, INVALID_PLAYER_ID, gAirplanes[i][aCar], 0,-1,-1,-1, 15.0);
	}
 	if (cache_is_valid(result)) cache_delete(result);
 	printf("[Загрузка ...] Аэропланы успешно загружены (%i шт.)", gPlaneCount);
	return 1;
}
stock load_hotels() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `hotels`");
	gHotelCount = cache_num_rows();
	if(gHotelCount > HOTEL_COUNT) print(!"Кол-во отелей в базе больше максимального");
	else if(!gHotelCount) print(!"Отелей в базе не найдено");
	for(new i = 0; i < gHotelCount; i++) {
		cache_get_value_name_int(i,"id", gHotels[i][hotelID]);

		cache_get_value_name(i,"name", gHotels[i][hotelName]);

		cache_get_value_name_int(i,"ownerid", gHotels[i][hotelOwnerID]);

		cache_get_value_name(i,"owner", gHotels[i][hotelOwner]);

		cache_get_value_name_int(i,"price", gHotels[i][hotelPrice]);
		cache_get_value_name_int(i,"coast", gHotels[i][hotelCoast]);
		cache_get_value_name_int(i,"bank", gHotels[i][hotelBank]);
		cache_get_value_name_int(i,"bankday", gHotels[i][hotelBankDay]);
		cache_get_value_name_int(i,"visitors", gHotels[i][hotelVisitors]);
		cache_get_value_name_int(i,"day", gHotels[i][hotelDay]);

		cache_get_value_name_float(i, "x", gHotels[i][hotelAreaX]);
		cache_get_value_name_float(i, "y", gHotels[i][hotelAreaY]);
		cache_get_value_name_float(i, "z", gHotels[i][hotelAreaZ]);

		cache_get_value_name_int(i,"level", gHotels[i][hotelLevel]);
		CreateDynamicPickup(19132, 1, 
			gHotels[i][hotelAreaX], gHotels[i][hotelAreaY], gHotels[i][hotelAreaZ], .worldid = 0, .interiorid = 0
		);
		gHotelArea[i] = CreateDynamicSphere(gHotels[i][hotelAreaX],gHotels[i][hotelAreaY],gHotels[i][hotelAreaZ],1.0,0,0,-1); 
		gHotelText[i] = CreateDynamic3DTextLabel("_", -1, 
			gHotels[i][hotelAreaX],gHotels[i][hotelAreaY],gHotels[i][hotelAreaZ]+1.0, 20.0, .worldid = 0, .interiorid = 0
		);
		CreateDynamicMapIcon(gHotels[i][hotelAreaX],gHotels[i][hotelAreaY],gHotels[i][hotelAreaZ], 35, -1);
		UpdateHotelText(i);

		for(new b = 1, null; b <= 6; b++) {
			null++;
			gHotels[i][hotelVW][b] = null;
		}
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Отели успешно загружены (%i шт.)", gHotelCount);
	return 1;
}
stock load_airports() {
	new Cache:result = mysql_query(connects, "SELECT * FROM `airports`");
	gAirCount = cache_num_rows();
	if(gAirCount > HOTEL_COUNT) print(!"Кол-во аэропортов в базе больше максимального");
	else if(!gAirCount) print(!"Аэропорты в базе не найдены");
	for(new i = 0; i < gAirCount; i++) {
		cache_get_value_name_int(i,"id", gAirs[i][airID]);

		cache_get_value_name(i,"name", gAirs[i][airName]);

		cache_get_value_name_int(i,"ownerid", gAirs[i][airOwnerID]);

		cache_get_value_name(i,"owner", gAirs[i][airOwner]);

		cache_get_value_name_int(i,"price", gAirs[i][airPrice]);
		cache_get_value_name_int(i,"coast", gAirs[i][airCoast]);
		cache_get_value_name_int(i,"bank", gAirs[i][airBank]);
		cache_get_value_name_int(i,"day", gAirs[i][airDay]);

		cache_get_value_name_float(i, "x", gAirs[i][airAreaX]);
		cache_get_value_name_float(i, "y", gAirs[i][airAreaY]);
		cache_get_value_name_float(i, "z", gAirs[i][airAreaZ]);

		CreateDynamicPickup(2470, 1, 
			gAirs[i][airAreaX], gAirs[i][airAreaY], gAirs[i][airAreaZ], .worldid = 0, .interiorid = 0
		);
		gAirArea[i] = CreateDynamicSphere(gAirs[i][airAreaX],gAirs[i][airAreaY],gAirs[i][airAreaZ],1.0,0,0,-1);

		gAirText[i] = CreateDynamic3DTextLabel("_",-1,
			gAirs[i][airAreaX],gAirs[i][airAreaY],gAirs[i][airAreaZ]+1.0,20.0, .worldid = 0, .interiorid = 0
		);
		CreateDynamicMapIcon(gAirs[i][airAreaX],gAirs[i][airAreaY],gAirs[i][airAreaZ], 5, -1);
		UpdateAirportsText(i);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Аэропорты успешно загружены (%i шт.)",gAirCount);
	return 1;
}
stock load_family() {
	new 
		Cache:result = mysql_query (connects, "SELECT * FROM `family`");
	TotalFamily = cache_num_rows();
	if(TotalFamily >= FAMILY_COUNT) print(!"Кол-во семей в базе больше максимального");
	else if(!TotalFamily) print(!"Семьи в базе не найдены");
	else for(new i = 0; i < TotalFamily; i++) {
		cache_get_value_name_int(i,"id", gFamily[i][famID]);

		cache_get_value(i,"cname",gFamily[i][famCName], 32);
		cache_get_value(i,"name",gFamily[i][famName], 32);
		cache_get_value(i,"time",gFamily[i][famDate], 32);

		cache_get_value(i,"cowner",gFamily[i][famCOwner], MAX_PLAYER_NAME);
		cache_get_value(i,"owner",gFamily[i][famOwner], MAX_PLAYER_NAME);

		cache_get_value_int(i,"color",gFamily[i][famColor]);
		cache_get_value_int(i,"drugs",gFamily[i][famDrugs]);
		cache_get_value_int(i,"mats",gFamily[i][famMats]);

		cache_get_value_int(i,"invite",gFamily[i][famInvRang]);
		cache_get_value_int(i,"uninvite",gFamily[i][famUninvRang]);
		cache_get_value_int(i,"giverank",gFamily[i][famGiveRang]);
		cache_get_value_int(i,"sklad",gFamily[i][famSklad]);

		cache_get_value_name(i, "Rank_1", FamRanks[i][0], 24);
        cache_get_value_name(i, "Rank_2", FamRanks[i][1], 24);
        cache_get_value_name(i, "Rank_3", FamRanks[i][2], 24);
        cache_get_value_name(i, "Rank_4", FamRanks[i][3], 24);
        cache_get_value_name(i, "Rank_5", FamRanks[i][4], 24);
        cache_get_value_name(i, "Rank_6", FamRanks[i][5], 24);
        cache_get_value_name(i, "Rank_7", FamRanks[i][6], 24);
        cache_get_value_name(i, "Rank_8", FamRanks[i][7], 24);

        cache_get_value_name(i, "message", gFamily[i][famMessage], 71);

        cache_get_value_int(i,"exp",gFamily[i][famExp]);
		cache_get_value_int(i,"lvl",gFamily[i][famLvl]);
		cache_get_value_int(i,"point",gFamily[i][famPoint]);
		cache_get_value_int(i,"drugs_max",gFamily[i][famDrugsMax]);
		cache_get_value_int(i,"mats_max",gFamily[i][famMatsMax]);
		cache_get_value_int(i,"fuel",gFamily[i][famFuel]);
		cache_get_value_int(i,"fuel_max",gFamily[i][famFuelMax]);
		cache_get_value_int(i,"remp",gFamily[i][famRemp]);
		cache_get_value_int(i,"remp_max",gFamily[i][famRempMax]);
		cache_get_value_int(i,"armour",gFamily[i][famArmour]);
		cache_get_value_int(i,"armour_max",gFamily[i][famArmourMax]);
		cache_get_value_int(i,"health",gFamily[i][famHealth]);
		cache_get_value_int(i,"health_max",gFamily[i][famHealthMax]);
		cache_get_value_int(i,"mask",gFamily[i][famMask]);
		cache_get_value_int(i,"mask_max",gFamily[i][famMaskMax]);
		cache_get_value_int(i,"money",gFamily[i][famMoney]);
		cache_get_value_int(i,"money_max",gFamily[i][famMoneyMax]);
		cache_get_value_int(i,"house",gFamily[i][famHouse]);
		cache_get_value_int(i,"type",gFamily[i][famType]);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Семьи успешно загружены (%i шт.)",TotalFamily);
	return 1;
}
stock load_rooms() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `rooms`");
	gRoomsCount = cache_num_rows();
	if(gRoomsCount > 240) print(!"Номеров в отелях в базе больше максимального");
	else if(!gRoomsCount) print(!"Номеров в отелях в базе не найдены");
	else for(new i; i < gRoomsCount; i++) {
		cache_get_value_name_int(i,"id", gRooms[i][roomsID]);

		cache_get_value_name(i,"owner", gRooms[i][roomsOwner]);

		cache_get_value_name_float(i, "x", gRooms[i][roomsEnterX]);
		cache_get_value_name_float(i, "y", gRooms[i][roomsEnterY]);
		cache_get_value_name_float(i, "z", gRooms[i][roomsEnterZ]);
		cache_get_value_name_float(i, "r", gRooms[i][roomsEnterR]);

		cache_get_value_name_int(i,"doors", gRooms[i][roomsDoors]);
		cache_get_value_name_int(i,"day", gRooms[i][roomsDay]);
		cache_get_value_name_int(i,"hotel", gRooms[i][roomsHotel]);
		cache_get_value_name_int(i,"vw", gRooms[i][roomsWorld]);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Комнаты в отеле успешно загружены (%i шт.)", gRoomsCount);
	return 1;
}
stock load_house() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `houses`");
	gHouseCount = cache_num_rows(); 
	if(gHouseCount >= MAX_HOUSE_COUNT) print(!"Кол-во домов в базе больше максимального");
	else if(!gHouseCount) print(!"Домов в базе не найдено");
	else for(new i = 0, data_[64]; i < gHouseCount; i++) {
		cache_get_value_name_int(i,"id", gHouses[i][houseID]);

        cache_get_value_name_int(i, "class", gHouses[i][houseClass]);
		cache_get_value_name_int(i, "day", gHouses[i][houseDay]);
		cache_get_value_name_int(i, "price", gHouses[i][housePrice]);
		cache_get_value_name_int(i, "hint", gHouses[i][houseHint]);

		cache_get_value(i, "improve", data_ , sizeof data_);
		sscanf (data_, "p<|>iii", gHouses[i][houseImprove][0], gHouses[i][houseImprove][1], gHouses[i][houseImprove][2]);
		data_[0] = EOS;
		cache_get_value(i, "gun", data_ , sizeof data_);
		sscanf (data_, "p<|>iiiiiiiii", 
			gHouses[i][houseGun][0], gHouses[i][houseGun][1], gHouses[i][houseGun][2], gHouses[i][houseGun][3], gHouses[i][houseGun][4], 
			gHouses[i][houseGun][5], gHouses[i][houseGun][6], gHouses[i][houseGun][7], gHouses[i][houseGun][8]
		);
		data_[0] = EOS;
		cache_get_value(i, "skin", data_ , sizeof data_);
		sscanf (data_, "p<|>iii", gHouses[i][houseSkin][0], gHouses[i][houseSkin][1], gHouses[i][houseSkin][2]);
		data_[0] = EOS;
		cache_get_value_name_int(i, "safecode", gHouses[i][houseSafeCode]);
		cache_get_value_name_int(i, "safemoney", gHouses[i][houseSafeMoney]);
		cache_get_value_name_int(i, "drugs", gHouses[i][houseDrugs]);
		cache_get_value_name_int(i, "medkit", gHouses[i][houseHealth]);
		cache_get_value_name_int(i, "products", gHouses[i][houseProducts]);
		cache_get_value_name_int(i, "close", gHouses[i][houseClose]);

        cache_get_value_name_float(i, "x", gHouses[i][houseX]);
        cache_get_value_name_float(i, "y", gHouses[i][houseY]);
        cache_get_value_name_float(i, "z", gHouses[i][houseZ]);
        cache_get_value_name_float(i, "r", gHouses[i][houseR]);
        cache_get_value_name_float(i, "parkx", gHouses[i][houseParkX]);
        cache_get_value_name_float(i, "parky", gHouses[i][houseParkY]);
        cache_get_value_name_float(i, "parkz", gHouses[i][houseParkZ]);
        cache_get_value_name_float(i, "parkr", gHouses[i][houseParkR]);

		cache_get_value_name_int(i, "ownerid", gHouses[i][houseOwnerID]);

		cache_get_value_name(i, "owner", gHouses[i][houseOwner]);

		cache_get_value_name_int(i, "peopleid1", gHouses[i][houseHabitID][0]);
		cache_get_value_name_int(i, "peopleid2", gHouses[i][houseHabitID][1]);
		cache_get_value_name_int(i, "peopleid3", gHouses[i][houseHabitID][2]);

		cache_get_value_name(i, "people1", gHouseArendator[i][0]);
		cache_get_value_name(i, "people2", gHouseArendator[i][1]);
		cache_get_value_name(i, "people3", gHouseArendator[i][2]);

		cache_get_value_name_int(i, "family", gHouses[i][houseFamily]);

		gHouseArea[i] = CreateDynamicSphere(gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],1.5,0,0,-1); 
		gHousePickup[i] = CreateDynamicPickup((gHouses[i][houseOwner] == 0) ? 1273 : 1272,1,gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],0,0);
		gHouseIcon[i] = CreateDynamicMapIcon(gHouses[i][houseX],gHouses[i][houseY],gHouses[i][houseZ],(gHouses[i][houseOwner] == 0) ? 31 : 32,CWHITE); 
	} 
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Дома успешно загружены (%i шт.)", gHouseCount);
	return true;
}
stock load_greenzone() {
	new rows,
		Cache:result = mysql_query(connects, "SELECT * FROM `"TABLE_GREENZONE"`");
	cache_get_row_count(rows);
	for(new i = 1; i <= rows; i++) {

        cache_get_value_name_int(i-1, "id", GREENZONE[i][grid]);

        cache_get_value_name_float(i-1, "grx", GREENZONE[i][grX]);
  		cache_get_value_name_float(i-1, "gry", GREENZONE[i][grY]);
        cache_get_value_name_float(i-1, "grz", GREENZONE[i][grZ]);
  		cache_get_value_name_float(i-1, "grd", GREENZONE[i][grD]);

  		cache_get_value_name(i-1, "grname", GREENZONE[i][grName], 32);

  		cache_get_value_name_int(i-1, "grvirt", GREENZONE[i][grVirt]);
    	TOTALZONE++;
		GREENZONE[i][grid] = CreateDynamicSphere(GREENZONE[i][grX], GREENZONE[i][grY], GREENZONE[i][grZ], GREENZONE[i][grD], GREENZONE[i][grVirt]);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Зеленые зоны успешно загружены (%i шт.)",TOTALZONE);
	return 1;
}
stock load_gangzone() {
    new 
		Cache:result = mysql_query(connects, "SELECT * FROM `"TABLE_GANGZONE"`"),
		rows;

	cache_get_row_count(rows);

	for(new i = 0; i < rows; i++) {
        cache_get_value_name_int(i, "id", GZInfo[i][gID]);

        cache_get_value_name_float(i, "coord_one", GZInfo[i][gCoords][0]);
  		cache_get_value_name_float(i, "coord_two", GZInfo[i][gCoords][1]);
        cache_get_value_name_float(i, "coord_three", GZInfo[i][gCoords][2]);
  		cache_get_value_name_float(i, "coord_four", GZInfo[i][gCoords][3]);

  		cache_get_value_name_int(i, "gang_owner", GZInfo[i][gFrakVlad]);

		GZInfo[i][gZone] = GangZoneCreate(GZInfo[i][gCoords][0],GZInfo[i][gCoords][1],GZInfo[i][gCoords][2],GZInfo[i][gCoords][3]);

		VladGzone[GZInfo[i][gFrakVlad]]++;
		GZInfo[i][gTime] = 0;

    	TOTALGZ++;
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] ГангЗоны успешно загружены (%i шт.)",TOTALGZ);
	return 1;
}
stock load_fractions() { 
    for(new i; i < 15; i ++) {
		RankName[0][i] = "Гражданин";
	}
    new 
		Cache:result = mysql_query(connects, "SELECT * FROM `fractions`"),
		rows; 

	cache_get_row_count(rows);
	for(new i = 1;i <= rows;i ++) {
	    cache_get_value_name_int(i-1, "ID", FI[i][fID]);

	    cache_get_value_name(i-1, "Name", FI[i][fName], 32);
	    cache_get_value_name(i-1, "Leader", FI[i][fLeader], MAX_PLAYER_NAME);
		cache_get_value_name(i-1, "Admin", FI[i][fAdmin], MAX_PLAYER_NAME);
		cache_get_value_name(i-1, "Time", FI[i][fTime], 53);

		cache_get_value_name_int(i-1, "Bank", FI[i][fBank]);
		cache_get_value_name_int(i-1, "BankCash", FI[i][fBankCash]);
		cache_get_value_name_int(i-1, "Drugs", FI[i][fDrugs]);
		cache_get_value_name_int(i-1, "Mats", FI[i][fMats]);
		cache_get_value_name_int(i-1, "Health", FI[i][fHealth]);
		cache_get_value_name_int(i-1, "Sklad", FI[i][fSklad]);
		cache_get_value_name_int(i-1, "Price", FI[i][fPrice]);
		cache_get_value_name_int(i-1, "Skin", FI[i][fSkin]);
		cache_get_value_name_int(i-1, "MaxRang", FI[i][fMaxRang]);
		cache_get_value_name_int(i-1, "RangInvite", FI[i][fInviteRang]);
		cache_get_value_name_int(i-1, "RangUninvite", FI[i][fUninviteRang]);
		cache_get_value_name_int(i-1, "GiveRang", FI[i][fGiveRang]);
		cache_get_value_name_int(i-1, "UseStock", FI[i][fUseStock]);
		cache_get_value_name_int(i-1, "VW", FI[i][fVw]);
        cache_get_value_name_int(i-1, "INT", FI[i][fInt]);
		cache_get_value_name_int(i-1, "DrugsBuy", FI[i][fDrugsBuy]);
		cache_get_value_name_int(i-1, "DrugsPrice", FI[i][fDrugsPrice]);
		cache_get_value_name_int(i-1, "AntiTk", FI[i][fAntiTK]); 
		cache_get_value_name_int(i-1, "fRating", FI[i][fRating]);

        cache_get_value_name(i-1, "Rank_1", RankName[i][0], 24);
        cache_get_value_name(i-1, "Rank_2", RankName[i][1], 24);
        cache_get_value_name(i-1, "Rank_3", RankName[i][2], 24);
        cache_get_value_name(i-1, "Rank_4", RankName[i][3], 24);
        cache_get_value_name(i-1, "Rank_5", RankName[i][4], 24);
        cache_get_value_name(i-1, "Rank_6", RankName[i][5], 24);
        cache_get_value_name(i-1, "Rank_7", RankName[i][6], 24);
        cache_get_value_name(i-1, "Rank_8", RankName[i][7], 24);
        cache_get_value_name(i-1, "Rank_9", RankName[i][8], 24);
        cache_get_value_name(i-1, "Rank_10", RankName[i][9], 24);
        cache_get_value_name(i-1, "Rank_11", RankName[i][10], 24);
        cache_get_value_name(i-1, "Rank_12", RankName[i][11], 24);
        cache_get_value_name(i-1, "Rank_13", RankName[i][12], 24);
        cache_get_value_name(i-1, "Rank_14", RankName[i][13], 24);
        cache_get_value_name(i-1, "Rank_15", RankName[i][14], 24);

		cache_get_value_name(i-1, "Message", FI[i][fMessage], 70);
	}
	if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Фракции успешно загружены (%i шт.)",rows);
	return true;
}
stock load_anticheat() {
	new Cache:result, rows;
	result = mysql_query(connects, "SELECT * FROM `anticheats`");
	rows = cache_num_rows();
	for(new i = 0; i < rows; i++) {
		AntiCheat[i][acID] = i;

        cache_get_value_name(i, "cheatname", AntiCheat[i][acName],63);
		cache_get_value_name_int(i, "cheatvalue", AntiCheat[i][acValue]);
		//printf("%d %d %s",i,AntiCheat[i][acID],AntiCheat[i][acName]);
    }
    cache_delete(result);
	printf("[Загрузка ...] Античит успешно загружен (%i шт.)", rows);
	return 1;
}
stock load_diplomation() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `diplomation`"),
		rows;

	cache_get_row_count(rows);
	if(!rows) {
		print("Настройки Дипломатии не найдены");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	} 
	for(new i = 0, data_[32]; i < rows; i++) {
		cache_get_value(i, "f_dip", data_ , sizeof data_);
		sscanf (data_, "p<|>iiiiiiii", f_diplomacy[i][0], f_diplomacy[i][1], f_diplomacy[i][2],
			f_diplomacy[i][3], f_diplomacy[i][4], f_diplomacy[i][5], f_diplomacy[i][6], f_diplomacy[i][7]
		);
		data_[0] = EOS;
	} 
    if (cache_is_valid(result)) cache_delete(result);
	printf("[Загрузка ...] Дипломатия успешно загружена (%i шт.)", rows);
	return 1;
}
stock load_others() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `"TABLE_OTHERS"`"),
		rows;

	cache_get_row_count(rows);
	if(!rows) {
		print("Настройки Склада не найдены");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}   
	for(new i = 0; i < rows; i++) {
		cache_get_value_index_int(i, 1, action_server[0]);
		cache_get_value_index_int(i, 2, zavodsklad);
		cache_get_value_index_int(i, 3, oilsklad);
		cache_get_value_index_int(i, 4, pricedrugs);
		cache_get_value_index_int(i, 5, disease);
		cache_get_value_index_int(i, 6, action_server[1]);
		cache_get_value_index_int(i, 7, action_server[2]);
		cache_get_value_index_int(i, 8, casino);
		cache_get_value_index_int(i, 9, woodsklad);
		cache_get_value_index_int(i, 10, tk_unloading[0]);
		cache_get_value_index_int(i, 11, tk_unloading[1]);
		cache_get_value_index_int(i, 12, tk_unloading[2]);
		cache_get_value_index_int(i, 13, tk_unloading[3]);
		cache_get_value_index_int(i, 14, rep_system);
		cache_get_value_index_int(i, 15, duels);
 
		cache_get_value_index_int(i, 16, invite_frac[0]);//PD
		cache_get_value_index_int(i, 17, invite_frac[1]);//FBI
		cache_get_value_index_int(i, 18, invite_frac[2]);//ARMY
		cache_get_value_index_int(i, 19, invite_frac[3]);//MEDICS
		cache_get_value_index_int(i, 20, invite_frac[4]);//NEWS
		cache_get_value_index_int(i, 21, invite_frac[5]);//MAFIA
		cache_get_value_index_int(i, 22, invite_frac[6]);//BAND
		cache_get_value_index_int(i, 23, invite_frac[7]);//WH
 
		cache_get_value_index_int(i, 24, anti_tk);//anti tk
	} 
    if (cache_is_valid(result)) cache_delete(result);
    return true;
}
stock load_bonuses() {
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `bonuses`"),
		rows;

	cache_get_row_count(rows);
	if(!rows) {
		print("Настройки Бонусов не найдены");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}   
	for(new i = 0; i < rows; i++) {
		cache_get_value_index_int(i, 1, BonusInfo[act_level]);
		cache_get_value_index_int(i, 2, BonusInfo[act_select]);
		cache_get_value_index_int(i, 3, BonusInfo[act_time]);
 
		cache_get_value_index_int(i, 4, BonusInfo[act_skill]);
		cache_get_value_index_int(i, 5, BonusInfo[act_exp]);
		cache_get_value_index_int(i, 6, BonusInfo[act_sport]);
		cache_get_value_index_int(i, 7, BonusInfo[act_mp]);
		cache_get_value_index_int(i, 8, BonusInfo[act_gun]);
		cache_get_value_index_int(i, 9, BonusInfo[act_fish]);
		cache_get_value_index_int(i, 10, BonusInfo[act_renthotel]);
		cache_get_value_index_int(i, 11, BonusInfo[act_buyskin]);
		cache_get_value_index_int(i, 12, BonusInfo[act_buycar]);
		cache_get_value_index_int(i, 13, BonusInfo[act_rentcar]);
		cache_get_value_index_int(i, 14, BonusInfo[act_buylic]);
		cache_get_value_index_int(i, 15, BonusInfo[act_buyimprove]);
		cache_get_value_index_int(i, 16, BonusInfo[act_disease]);
		cache_get_value_index_int(i, 17, BonusInfo[act_changesex]);
		cache_get_value_index_int(i, 18, BonusInfo[act_medcard]);
		cache_get_value_index_int(i, 19, BonusInfo[act_buynubmbercar]);
		cache_get_value_index_int(i, 20, BonusInfo[act_perfomance]);
		cache_get_value_index_int(i, 21, BonusInfo[act_tune]);
		cache_get_value_index_int(i, 22, BonusInfo[act_payday]);
		cache_get_value_index_int(i, 23, BonusInfo[act_donate]);
	} 
    if (cache_is_valid(result)) cache_delete(result);
	if(!BonusInfo[act_select]) {
		SendRconCommand("hostname Flame RolePlay | Мы открылись!");
	}
	else if(BonusInfo[act_select] == 1) {
		SendRconCommand("hostname Flame RolePlay | Ускоренная прокачка для новичков");
	}
	else SendRconCommand("hostname Flame RolePlay | Скоро открытие");

	if(SELECT_SERVER != 1) SendRconCommand("hostname Flame RolePlay | Test Server");
    return true;
}
stock load_vip() { 
	new 
		Cache:result = mysql_query(connects, "SELECT * FROM `vip`"),
		rows;
		
	cache_get_row_count(rows);
	if(!rows) {
		print("Настройки VIP не найдены");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}   
	for(new i = 1; i <= rows; i++) {
		cache_get_value_name_int(i-1, "vip_payday", vip_status[i-1][vip_payday]);
		cache_get_value_name_int(i-1, "vip_carlic",vip_status[i-1][vip_carlic]);
		cache_get_value_name_int(i-1, "vip_lvl",vip_status[i-1][vip_lvl]);
		cache_get_value_name_int(i-1, "vip_healtime",vip_status[i-1][vip_healtime]);
		cache_get_value_name_int(i-1, "vip_arrest",vip_status[i-1][vip_arrest]);
		cache_get_value_name_int(i-1, "vip_mute",vip_status[i-1][vip_mute]);
		cache_get_value_name_int(i-1, "vip_admins",vip_status[i-1][vip_admins]);
		cache_get_value_name_int(i-1, "vip_mask_time",vip_status[i-1][vip_mask_time]);
		cache_get_value_name_int(i-1, "vip_armmats",vip_status[i-1][vip_armmats]);
		cache_get_value_name_int(i-1, "vip_search",vip_status[i-1][vip_search]);
		cache_get_value_name_int(i-1, "vip_heal",vip_status[i-1][vip_heal]);
		cache_get_value_name_int(i-1, "vip_mask",vip_status[i-1][vip_mask]);
		cache_get_value_name_int(i-1, "vip_fuel",vip_status[i-1][vip_fuel]);
		cache_get_value_name_int(i-1, "vip_jimmy",vip_status[i-1][vip_jimmy]);
		cache_get_value_name_int(i-1, "vip_mats",vip_status[i-1][vip_mats]);
		cache_get_value_name_int(i-1, "vip_drugs",vip_status[i-1][vip_drugs]);
		cache_get_value_name_float(i-1, "vip_satiety",vip_status[i-1][vip_satiety]);

		cache_get_value_name_int(i-1, "vip_fam_point",vip_status[i-1][vip_fam_point]);
		cache_get_value_name_int(i-1, "vip_transfer_bank",vip_status[i-1][vip_transfer_bank]);
		cache_get_value_name_int(i-1, "vip_percent_job",vip_status[i-1][vip_percent_job]);
		cache_get_value_name_int(i-1, "vip_percent_pension",vip_status[i-1][vip_percent_pension]);
		cache_get_value_name_int(i-1, "vip_percent_startjob",vip_status[i-1][vip_percent_startjob]);

		cache_get_value_name_int(i-1, "vip_flylic",vip_status[i-1][vip_flylic]);
		cache_get_value_name_int(i-1, "vip_fixcar",vip_status[i-1][vip_fixcar]);
		cache_get_value_name_int(i-1, "vip_fine",vip_status[i-1][vip_fine]);
		cache_get_value_name_int(i-1, "vip_hotel",vip_status[i-1][vip_hotel]);
		cache_get_value_name_int(i-1, "vip_chose",vip_status[i-1][vip_chose]);
		cache_get_value_name_int(i-1, "vip_buycar",vip_status[i-1][vip_buycar]);
		cache_get_value_name_int(i-1, "vip_rentcar",vip_status[i-1][vip_rentcar]);
		cache_get_value_name_int(i-1, "vip_houseupdate",vip_status[i-1][vip_houseupdate]);
		cache_get_value_name_int(i-1, "vip_changesex",vip_status[i-1][vip_changesex]);
		cache_get_value_name_int(i-1, "vip_number",vip_status[i-1][vip_number]);
		cache_get_value_name_int(i-1, "vip_perfonans",vip_status[i-1][vip_perfonans]);
		cache_get_value_name_int(i-1, "vip_tune",vip_status[i-1][vip_tune]);
		cache_get_value_name_int(i-1, "vip_hp",vip_status[i-1][vip_hp]);
		cache_get_value_name_int(i-1, "vip_useheal",vip_status[i-1][vip_useheal]);
		cache_get_value_name_int(i-1, "vip_changename",vip_status[i-1][vip_changename]);
		cache_get_value_name_int(i-1, "vip_gunlic",vip_status[i-1][vip_gunlic]);
		cache_get_value_name_int(i-1, "vip_radar",vip_status[i-1][vip_radar]);
		cache_get_value_name_int(i-1, "vip_report",vip_status[i-1][vip_report]);
		cache_get_value_name_int(i-1, "vip_ad",vip_status[i-1][vip_ad]);
		cache_get_value_name_int(i-1, "vip_enterbizz",vip_status[i-1][vip_enterbizz]);
		cache_get_value_name_int(i-1, "vip_vad",vip_status[i-1][vip_vad]);
		cache_get_value_name_int(i-1, "vip_sms",vip_status[i-1][vip_sms]);
		cache_get_value_name_int(i-1, "vip_disease",vip_status[i-1][vip_disease]);
		cache_get_value_name_int(i-1, "vip_pay",vip_status[i-1][vip_pay]);
		cache_get_value_name_int(i-1, "vip_chat",vip_status[i-1][vip_chat]);
		cache_get_value_name_int(i-1, "vip_call",vip_status[i-1][vip_call]);
		cache_get_value_name_int(i-1, "vip_report_color",vip_status[i-1][vip_report_color]);
	} 
	if (cache_is_valid(result)) cache_delete(result);
	return true;
}
stock load_graffity() {
	new Cache:result = mysql_query(connects, "SELECT * FROM `graffity`");

	CountGraffity = cache_num_rows();
	if(!CountGraffity) {
		print("Настройки Graffiti не найдены");
		if (cache_is_valid(result)) cache_delete(result);
		return 1;
	}  
	for(new idx = 1, obj; idx <= CountGraffity; idx++) { 
		//new obj,icon;
		cache_get_value_index_int(idx-1,0,GrafInfo[idx][gId]);
		cache_get_value_index_int(idx-1,1,GrafInfo[idx][gFrak]);
		cache_get_value_index_float(idx-1,2, GrafInfo[idx][gr_x][0]);
		cache_get_value_index_float(idx-1,3, GrafInfo[idx][gr_x][1]);
		cache_get_value_index_float(idx-1,4, GrafInfo[idx][gr_x][2]);
		cache_get_value_index_float(idx-1,5, GrafInfo[idx][gr_x][3]);
		cache_get_value_index_float(idx-1,6, GrafInfo[idx][gr_x][4]);
		cache_get_value_index_float(idx-1,7, GrafInfo[idx][gr_x][5]);
		switch(GrafInfo[idx][gFrak]) {
			case 0: obj = 18666;
			case 20: obj = 18659;
			case 21: obj = 18661;
			case 22: obj = 18663;
			case 18: obj = 18664;
			case 19: obj = 18665;
		}
		GrafInfo[idx][gObject] = CreateDynamicObject(obj, 
			GrafInfo[idx][gr_x][0], GrafInfo[idx][gr_x][1], GrafInfo[idx][gr_x][2], 
			GrafInfo[idx][gr_x][3], GrafInfo[idx][gr_x][4], GrafInfo[idx][gr_x][5]
		);
	}
	printf("[Загрузка ...] Граффити успешно загружено (%i шт.)", CountGraffity); 
    if (cache_is_valid(result)) cache_delete(result);
    return true;
}
stock load_vehicles() {
	new rows,
		Cache:result = mysql_query(connects, "SELECT * FROM `transport` ORDER BY `model`");
	cache_get_row_count(rows);
	for(new i=0;i<rows;i++) {
		cache_get_value_index_int(i,0,gTransport[i][trID]);
		cache_get_value_index_int(i,1,gTransport[i][trModel]);
		cache_get_value_index(i,2,gTransport[i][trName], 35);
		cache_get_value_index_int(i,3,gTransport[i][trPrice]);
		cache_get_value_index_int(i,4,gTransport[i][trTank]);
		cache_get_value_index_int(i,5,gTransport[i][trConsumption]);
		cache_get_value_index_int(i,6,gTransport[i][trClass]);
		cache_get_value_index_int(i,7,gTransport[i][trFuelable]);
		cache_get_value_index_int(i,7,gTransport[i][trSellable]);
		cache_get_value_index_int(i,9,gTransport[i][trProds]);
	}
	printf("[Загрузка ...] Транспорт успешно загружен (%i шт.)", rows);
	if (cache_is_valid(result)) cache_delete(result);
	return 1;
}