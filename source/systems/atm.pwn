#define TABLE_ATM		"s_atm"
#define MAX_ATM         30  // Макс кол-во банкоматов


enum E_SERVER_ATM
{
	aID,
	Float: aPos[4],
    aWorld,
    aInterior,
    
    Float: aCommission,
    aActionPos[3],
   // aCommissionLevel,
    aTotalCash,
    aATMObject,
	aATMArea,
	Text3D: aLabel
};
new ATMInfo[MAX_ATM][E_SERVER_ATM], S_ATM_COUNT = 0; 

new 
    Float: currentCommission[] = {
        0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0
    };
new 
    Float: DepCurrentCommission[] = {
        0.1, 0.2, 0.3, 0.4, 0.5, 1.0////%.1f%% 
    };
 

ATM_OnGameModeInit() {
    LoadATM();
    return;
}    
stock LoadATM() {
    /*
    Test - [Загрузка ...] Данные из Atm получены! (23 шт.) Время: 5
    Main - [Загрузка ...] Данные из Atm получены! (23 шт.) Время: 2 
    ALTER TABLE `s_atm` ADD `aworld` INT(11) NOT NULL DEFAULT '0' AFTER `arz`, ADD `aint` INT(11) NOT NULL DEFAULT '0' AFTER `aworld`;
    */

	new 
        time = GetTickCount(),
        Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_ATM""); 
    cache_get_row_count(S_ATM_COUNT);
	if (!S_ATM_COUNT) {
        print(!"[Загрузка ...] Данные из s_atm не получены!");
        if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
        return 1;
    }
	for(new A_IDX = 0/*, position_mass[32]*/; A_IDX < S_ATM_COUNT; A_IDX++) { 
        cache_get_value_name_int(A_IDX, "id", ATMInfo[A_IDX][aID]);
        cache_get_value_name_float(A_IDX, "ax", ATMInfo[A_IDX][aPos][0]);
        cache_get_value_name_float(A_IDX, "ay", ATMInfo[A_IDX][aPos][1]);
        cache_get_value_name_float(A_IDX, "az", ATMInfo[A_IDX][aPos][2]);
        cache_get_value_name_float(A_IDX, "arz", ATMInfo[A_IDX][aPos][3]); 
        cache_get_value_name_int(A_IDX, "aworld", ATMInfo[A_IDX][aWorld]);
        cache_get_value_name_int(A_IDX, "aint", ATMInfo[A_IDX][aInterior]);

        /*
        cache_get_value_name_float(A_IDX, "aCommission", ATMInfo[A_IDX][aCommission]); 
        cache_get_value_name(A_IDX, "aActionPos", position_mass, 32); //< - Место где мы будем создавать игроку действие
        sscanf(position_mass, "p<|>a<f>[3]", ATMInfo[A_IDX][aActionPos]);*/

        ATMInfo[A_IDX][aTotalCash] = RandomFIX(800, 2000);//< - Сохраняем
        //printf("aTotalCash: %d", ATMInfo[A_IDX][aTotalCash]);
        ATMInfo[A_IDX][aCommission] = currentCommission[3];//< - Динамическая коммисия (Считаем использования банкомата) (( ПРИДУМАТЬ АЛГОРИТМ))

        ATMInfo[A_IDX][aATMArea] = CreateDynamicSphere(
            ATMInfo[A_IDX][aPos][0], ATMInfo[A_IDX][aPos][1], ATMInfo[A_IDX][aPos][2],
            15.0, ATMInfo[A_IDX][aWorld], ATMInfo[A_IDX][aInterior]
        );
        SetDynamicAreaType(ATMInfo[A_IDX][aATMArea], AREA_TYPE_ATM, A_IDX); 
        ATMInfo[A_IDX][aATMObject] = CreateDynamicObject(2754, 
            ATMInfo[A_IDX][aPos][0], ATMInfo[A_IDX][aPos][1], ATMInfo[A_IDX][aPos][2], 
            0.0, 0.0, ATMInfo[A_IDX][aPos][3], 
            ATMInfo[A_IDX][aWorld], ATMInfo[A_IDX][aInterior]
        );
        ATMInfo[A_IDX][aLabel] = CreateDynamic3DTextLabel(
            "Нажмите: \"ENTER\"", 0x00D900FF, 
            ATMInfo[A_IDX][aPos][0], ATMInfo[A_IDX][aPos][1], ATMInfo[A_IDX][aPos][2] + 1.1, 10.0, 
            .worldid = ATMInfo[A_IDX][aWorld], .interiorid = ATMInfo[A_IDX][aInterior]
        );
	}
    if (cache_is_valid(tempQuery)) cache_delete(tempQuery); 
    printf("[Загрузка ...] Данные из s_atm получены! (%d шт.) Время: %d", S_ATM_COUNT, GetTickCount() - time); 
	return 1;
}

ATM_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    /*if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;*/
    new 
        bool:isReturn = false;
    if (newkeys & KEY_SECONDARY_ATTACK && !(oldkeys & KEY_SECONDARY_ATTACK)) { 
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		    return false;
        if (pTemp[playerid][tSelectATMID] != -1) {
            new 
                A_IDX = pTemp[playerid][tSelectATMID]; 
            if (IsPlayerInRangeOfPoint(playerid, 1.0, ATMInfo[A_IDX][aPos][0], ATMInfo[A_IDX][aPos][1], ATMInfo[A_IDX][aPos][2]) 
                && GetPlayerVirtualWorld(playerid) == ATMInfo[A_IDX][aWorld] && GetPlayerInterior(playerid) == ATMInfo[A_IDX][aInterior])
            {  
                ClearAnimations(playerid);
                ShowBankDialog(playerid, A_IDX);
                isReturn = true;
            }  
        }
        isReturn = false;  
    }  
    if (newkeys & KEY_CROUCH && !(oldkeys & KEY_CROUCH)) {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		    return false;
		new 
            vehicleid = GetPlayerVehicleID(playerid);

        if (pTemp[playerid][tJobHunter] && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[vehicleid - 1][vFraction] == PLAYER_JOB_HUNTER) {
            if (IsPlayerToHunterZone(playerid)) {
                if ( !VehicleInfo[ vehicleid - 1 ][vJobLoad]) {
                    ShowPlayerDialog(playerid, D_PLAYER_HUNTER_1, DIALOG_STYLE_MSGBOX, ""colserver"Работа: "colwhi"Сбор мяса", ""colwhi"Вы действительно желаете "collime"начать "colwhi"загрузку мяса в фургон?", "Выбрать", "Закрыть");
                } else {
                    ShowPlayerDialog(playerid, D_PLAYER_HUNTER_1, DIALOG_STYLE_MSGBOX, ""colserver"Работа: "colwhi"Сбор мяса", ""colwhi"Вы действительно желаете "colwarn"завершить "colwhi"загрузку мяса в фургон?", "Выбрать", "Закрыть");
                }
            } 
            else if (IsPlayerInRangeOfPoint(playerid, 7.0, -288.4075,-2163.3608,28.6325)) {
                if (VehicleInfo[ vehicleid - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Вам надо завершить загрузку!");
                if (VehicleInfo[ vehicleid - 1 ][vJobAmount] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
                new	
					amountsell = (VehicleInfo[ vehicleid - 1 ][vJobAmount]*300),
					string_[128];
				kLibGivePlayerMoney(playerid, amountsell, "bank in cash");
				SetMoveCashServer(IN_SERVER, amountsell);

				format(string_, sizeof string_, "Вы сдали "colmaline"%d %s "colwhi"мяса за "collime"$%d", 
					VehicleInfo[ vehicleid - 1 ][vJobAmount], Declension_ReturnWord(VehicleInfo[ vehicleid - 1 ][vJobAmount], "кусок", "куска", "кусков"),
					amountsell
				);
                
				VehicleInfo[ vehicleid - 1 ][vJobAmount] = 0;
				SendClientMessage(playerid, COLOR_WHITE, string_);
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь дальше загружать мясо в фургон");
            }
            isReturn = true;
        }

        if (pInfo[playerid][pJob] == 5 && pTemp[playerid][pRentCar] == vehicleid && VehicleInfo[ vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[ vehicleid - 1][vFraction] == PLAYER_JOB_DELIVERY) {
            if (IsPlayerInRangeOfPoint(playerid, 7.0, 2172.5198,-2237.1111,13.3451)/*FActory LS*/)
            {  
                if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ vehicleid - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ vehicleid - 1 ] [vSubFraction] == DELIVERY_TYPE_0)) {
                    ShowPlayerDialog(playerid, D_JOB_FUNC_2, DIALOG_STYLE_LIST, "Развозка продуктов", "[0] Покупка зерна\n[1] Продажа зерна\n[2] Покупка урожая\n[3] Продажа урожая", "Выбрать", "Отмена");
                }
                else if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ vehicleid - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ vehicleid - 1 ] [vSubFraction] == DELIVERY_TYPE_1)) { 
                    ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_MENU);  
                }
                else if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ vehicleid - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ vehicleid - 1 ] [vSubFraction] >= DELIVERY_TYPE_2)) { 
                    ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_MENU);  
                } 
            }
            isReturn = true;
        }
        if (pInfo[playerid][pJob] == JOB_TRUCKER && pTemp[playerid][id_arended_truck] == vehicleid && VehicleInfo[ vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[ vehicleid - 1][vFraction] == JOB_TRUCKER) {
            if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_SAWMILL_0]) || IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_SAWMILL_1])) {
                new 
                    cost_wood = 0;
                if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_SAWMILL_0])) {
                    cost_wood = Buyderevo[0];
                }
                else if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_SAWMILL_1])) {
                    cost_wood = Buyderevo[1];
                }
                format(t_string, sizeof t_string, ""colwhi"Введите количество тонн, которое желаете загрузить:\n\nВы можете максимально загрузить: %d %s\nСтоимость 1 тонны древесины: "collime"$%d", 
                    pInfo[playerid][pDMgruz], Declension_ReturnWord(pInfo[playerid][pDMgruz], "тонна", "тонны", "тонн"), cost_wood
                );
                ShowPlayerDialog(playerid, D_TRUCKER_BUY, DIALOG_STYLE_INPUT, ""colserver"Закупка: "colwhi"Древесины", t_string, "Загрузить", "Отмена");
            }
            else if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_COAL_0]) || IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_COAL_1])) {
                new 
                    cost_coal = 0;
                if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_COAL_0])) {
                    cost_coal = ugolbuy[0];
                }
                else if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_COAL_1])) {
                    cost_coal = ugolbuy[1];
                }
                format(t_string, sizeof t_string, ""colwhi"Введите количество тонн, которое желаете загрузить:\n\nВы можете максимально загрузить: %d %s\nСтоимость 1 тонны угля: "collime"$%d", 
                    pInfo[playerid][pDMgruz], Declension_ReturnWord(pInfo[playerid][pDMgruz], "тонна", "тонны", "тонн"), cost_coal
                );
                ShowPlayerDialog(playerid, D_TRUCKER_BUY, DIALOG_STYLE_INPUT, ""colserver"Закупка: "colwhi"Угля", t_string, "Загрузить", "Отмена");
            }
            else if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_OIL_0]) || IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_OIL_1])) {
                new 
                    cost_oil = 0;
                if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_OIL_0])) {
                    cost_oil = Benzbuy[0];
                }
                else if (IsPlayerInDynamicArea(playerid, gAreas[arLoadingTrucket][LOADING_OIL_1])) {
                    cost_oil = Benzbuy[1];
                }
                format(t_string, sizeof t_string, ""colwhi"Введите количество тонн, которое желаете загрузить:\n\nВы можете максимально загрузить: %d %s\nСтоимость 1 тонны топлива: "collime"$%d", 
                    pInfo[playerid][pDMgruz], Declension_ReturnWord(pInfo[playerid][pDMgruz], "тонна", "тонны", "тонн"), cost_oil
                );
                ShowPlayerDialog(playerid, D_TRUCKER_BUY, DIALOG_STYLE_INPUT, ""colserver"Закупка: "colwhi"Топлива", t_string, "Загрузить", "Отмена"); 
            } 
            isReturn = true;
        }
        if (pInfo[playerid][pJob] == JOB_TRUCKER && pTemp[playerid][id_arended_truck] == vehicleid && VehicleInfo[ vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[ vehicleid - 1][vFraction] == JOB_TRUCKER
            && pTemp[playerid][tTruckerTrailerBuy] != INVALID_VEHICLE_ID && GetVehicleTrailer(vehicleid) == pTemp[playerid][tTruckerTrailerBuy]) 
        {
            new 
                trailer_id = pTemp[playerid][tTruckerTrailerBuy],
                sell_cost_gruz = 0,
                string_[164];
            if (IsPlayerInDynamicArea(playerid, gAreas[arUnloadingTrucker][0])) {
                switch(trailer_type[ trailer_id - 1 ])
                {
                    case LOADING_SAWMILL_0, LOADING_SAWMILL_1: {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellderevo[0];
                        if (Sellderevo[1] >= 900)
                            Sellderevo[1] = 900;
                        else
                            Sellderevo[1] += 100;

                        if (Sellderevo[0] <= 300)
                            Sellderevo[0] = 300;
                        else
                            Sellderevo[0] -= 100;
                    }
                    case LOADING_COAL_0, LOADING_COAL_1:  {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellugol[0];
                        if (Sellugol[1] >= 900)
                            Sellugol[1] = 900;
                        else
                            Sellugol[1] += 100;

                        if (Sellugol[0] <= 300)
                            Sellugol[0] = 300;
                        else
                            Sellugol[0] -= 100;
                    }
                    case LOADING_OIL_0, LOADING_OIL_1: {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellbenz[0];
                        if (Sellbenz[1] >= 900)
                            Sellbenz[1] = 900;
                        else
                            Sellbenz[1] += 100;

                        if (Sellbenz[0] <= 300)
                            Sellbenz[0] = 300;
                        else
                            Sellbenz[0] -= 100;
                    } 
                    default: SendClientMessage(playerid, COLOR_GREY, !"[ERROR] /tunload | Сообщите в Тех.Раздел на форуме!");
                } 
                new d_exp = trailer_count[ trailer_id - 1 ]*1000; 
		        pInfo[playerid][pDExp] += GetVipBoostMaxPlayerValue(playerid, vSkillJobTruck, bSkillJobTruck, d_exp);
                Expirence(playerid);
                kLibGivePlayerMoney(playerid, sell_cost_gruz, "/tunload");
                format(string_, sizeof(string_), "Вы продали груз за: %d", sell_cost_gruz);
                SendClientMessage(playerid, 0x458E1DAA, string_);
                DestroyVehicle(trailer_id);
                HideTruckerMainMenu(playerid, .main = true, .timer = false);
                
                trailer_count[trailer_id - 1] = 0;
                trailer_type[trailer_id - 1] = -1;
                pTemp[playerid][tTruckerTrailerBuy] = INVALID_VEHICLE_ID;
                OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_TRUCK);
            }
            else if (IsPlayerInDynamicArea(playerid, gAreas[arUnloadingTrucker][1])) {
                switch(trailer_type[ trailer_id - 1 ])
                {
                    case LOADING_SAWMILL_0, LOADING_SAWMILL_1:
                    {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellderevo[1];
                        if (Sellderevo[0] >= 900)
                            Sellderevo[0] = 900;
                        else
                            Sellderevo[0] += 100;

                        if (Sellderevo[1] < 300)
                            Sellderevo[1] = 300;
                        else
                            Sellderevo[1] -= 100;
                    }
                    case LOADING_COAL_0, LOADING_COAL_1:
                    {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellugol[1];
                        if (Sellugol[0] >= 900)
                            Sellugol[0] = 900;
                        else
                            Sellugol[0] += 100;

                        if (Sellugol[1] < 300)
                            Sellugol[1] = 300;
                        else
                            Sellugol[1] -= 100;
                    }
                    case LOADING_OIL_0, LOADING_OIL_1:
                    {
                        sell_cost_gruz = trailer_count[ trailer_id - 1 ]*Sellbenz[1];
                        if (Sellbenz[0] >= 900)
                            Sellbenz[0] = 900;
                        else
                            Sellbenz[0] += 100;

                        if (Sellbenz[1] <= 300)
                            Sellbenz[1] = 300;
                        else
                            Sellbenz[1] -= 100;
                    } 
                    default: SendClientMessage(playerid, COLOR_GREY, !"[ERROR] /tunload | Сообщите в Тех.Раздел на форуме!");
                }
                new d_exp = trailer_count[ trailer_id - 1 ]*1000;
		        pInfo[playerid][pDExp] += GetVipBoostMaxPlayerValue(playerid, vSkillJobTruck, bSkillJobTruck, d_exp);
                kLibGivePlayerMoney(playerid, sell_cost_gruz, "/tunload");
                format(string_, sizeof(string_), "Вы продали груз за: %d", sell_cost_gruz);
                SendClientMessage(playerid, 0x458E1DAA, string_);
                DestroyVehicle(trailer_id);
                Expirence(playerid);
                HideTruckerMainMenu(playerid, .main = true, .timer = false);
                trailer_count[trailer_id - 1] = 0;
                trailer_type[trailer_id - 1] = -1;
                pTemp[playerid][tTruckerTrailerBuy] = INVALID_VEHICLE_ID;
                OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_TRUCK);
            }
            format(string_, sizeof string_, "Порт ЛС\n\n"colwhi"Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фуру\n"C_PODS"Нефть: $%d\nУголь: $%d\nДерево: $%d",Sellbenz[0],Sellugol[0],Sellderevo[0]);
            UpdateDynamic3DTextLabelText(Doki[0], 0xFFFF00FF, string_);
            format(string_, sizeof string_, "Порт СФ\n\n"colwhi"Нажмите: "colserver"\"H\"\n\n"colwhi"Для того, чтобы разгрузить фуру\n"C_PODS"Нефть: $%d\nУголь: $%d\nДерево: $%d",Sellbenz[1],Sellugol[1],Sellderevo[1]);
            UpdateDynamic3DTextLabelText(Doki[1], 0xFFFF00FF, string_);
            isReturn = true;
        }
		if (pInfo[playerid][pJob] == 8 && pTemp[playerid][pRentCar] == vehicleid && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[vehicleid - 1][vFraction] == PLAYER_JOB_COLLECTOR) {
            if (IsPlayerInRangeOfPoint(playerid, 7.0, -2198.5027,289.0024,35.3210)/*SF*/ || IsPlayerInRangeOfPoint(playerid, 7.0, 1383.1624,-1659.7816,13.5483)/*LS*/)
			{
                if ( VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже начали инкассацию!");
				if (pTemp[playerid][pRentCar] == INVALID_VEHICLE_ID) return SendClientMessage(playerid, COLOR_GREY, !"Вы не в рабочем транспорте!");
				if (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Ваш фургон пуст!"); 
				new	
					amountsell = (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount]*300),
					string_[128];
				kLibGivePlayerMoney(playerid, amountsell, "bank in cash");
				SetMoveCashServer(IN_SERVER, amountsell);

				format(string_, sizeof string_, "Вы сдали "colmaline"%d %s "colwhi"с деньгами за "collime"$%d", 
					VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount], Declension_ReturnWord(VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount], "сумку", "сумки", "сумок"),
					amountsell
				);
                
				VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount] = 0;
				SendClientMessage(playerid, COLOR_WHITE, string_);
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь дальше производить инкассацию банкоматов");
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте команду "colrose"\"/atmlist\" "colwhi"- для поиска банкомата с наличностью");
                OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_COLLECTOR); 
			}  
            new 
                A_IDX = pTemp[playerid][tSelectATMID]; 
			if (A_IDX > -1 && IsPlayerInRangeOfPoint(playerid, 15.0, ATMInfo[A_IDX][aPos][0], ATMInfo[A_IDX][aPos][1], ATMInfo[A_IDX][aPos][2])) {
                new Float:angle,Float:distance,Float:vehx, Float:vehy, Float:vehz;
                GetVehicleModelInfo(VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vModel], 1, vehx, distance, vehz);
                distance = distance/2 + 0.1;
                GetVehiclePos(pTemp[playerid][pRentCar], vehx, vehy, vehz); 
                GetVehicleZAngle(pTemp[playerid][pRentCar], angle);
                vehx += (distance * floatsin(-angle+180, degrees));
                vehy += (distance * floatcos(-angle+180, degrees));

                new 
                    string_[64];  
                
                format(string_, sizeof string_, "Сумок: "colmaline"%d/20 шт", VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount][0]);
                if (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vFarmText] == Text3D:-1) { 
                    VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vFarmText] = CreateDynamic3DTextLabel(string_, COLOR_WHITE, vehx, vehy, vehz+0.5, 15.0);
                }  
                VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobPickup] = CreateDynamicPickup(11745,1, vehx, vehy, vehz-0.5);


                VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobArea] = CreateDynamicSphere(vehx, vehy, vehz, 1.0, 0, INTERIOR_NONE);
                SetDynamicAreaType(VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobArea], AREA_TYPE_TAKE_MONEY, pTemp[playerid][pRentCar]); 

                VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobLoad] = true;
                RemovePlayerFromVehicle(playerid);  
                
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Отправляйтесь к банкомату!");
                if (CP[playerid] == 777) {
                    DisablePlayerCheckpoint(playerid);
                    CP[playerid] = 0;
                }
				//SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться у банкомата!");
				//return true;
			}  

            
			isReturn = true;
		}
        isReturn = false;
    }
    return isReturn;
}

 
CMD:atmlist(playerid) {
    if (pInfo[playerid][pJob] != 8) return SendClientMessage(playerid, COLOR_GREY, !"Вы не инкассатор");
    if (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobAmount] > 3) return SendClientMessage(playerid, COLOR_GREY, !"Сначала сдайте преведущию инкассацию");
    if (VehicleInfo[ pTemp[playerid][pRentCar] - 1 ][vJobLoad]) return SendClientMessage(playerid, COLOR_GREY, !"В данный момент идет инкассация!");
    t_string = ""colserver"[№] Дистанция\t"colserver"Инкассация(Сумма)\n";
    for(new i = 0, idx = 0, string_[128]/*, distance*/; i < S_ATM_COUNT; i++) {      
        if (ATMInfo[i][aTotalCash] < 1_000) continue;
        new Float:odist = GetPlayerDistanceFromPoint(playerid, ATMInfo[i][aPos][0],ATMInfo[i][aPos][1],ATMInfo[i][aPos][2]);
        format(string_, sizeof string_, ""colwhi"[%d] %.1f метров\t"collime"$%d\n", i, odist, ATMInfo[i][aTotalCash]);
        strcat(t_string, string_);
        playerListItem[playerid][idx++] = i;
    }
    ShowPlayerDialog(playerid, D_ATM_FUNC_4, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"ATM: "colwhi"Банкоматы для инкассации", t_string, "Выбрать", "Закрыть");	
    return 1;
}
CMD:atm(playerid) {
    if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"Нельзя использовать в машине");
    if (pTemp[playerid][tSelectATMID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться возле банкомата! (Используйте \"/gps\")"); 
    ClearAnimations(playerid);
    ShowBankDialog(playerid, pTemp[playerid][tSelectATMID]); 
    if (pInfo[playerid][pAdmin] == 10) {
        SendMes(playerid, -1, "ATM ID: %d", pTemp[playerid][tSelectATMID]);
    } 
	return 1;
}
CMD:createatm(playerid) {
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (S_ATM_COUNT >= MAX_ATM) return SendClientMessage(playerid, COLOR_GREY, !"Вы не можете больше устанавливать банкоматы (MAX_ATM)!");
    if (GetPVarInt(playerid, "CreateATMServer") > 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы уже устанавливаете банкомат!");
    ShowPlayerDialog(playerid, D_DEV_FUNC_2, 0, ""colserver"Добавить: "colwhi"Банкомат", ""colwhi"Вы хотите начать установку банкомата?", "Да", "Нет");
    return 1;
}
stock PlayerUseAimATM(playerid)
{
    PlayerPlaySound(playerid,4203,0.0, 0.0, 0.0);
	ApplyAnimation(playerid,!"CRIB",!"CRIB_Use_Switch",4.0,0,0,0,0,0);
}
new 
    bool: ATM_CLOSED = true;
CMD:atmclosed(playerid) {
    if (pInfo[playerid][pAdmin] < 8 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if(ATM_CLOSED) {
        ATM_CLOSED = false;
        SendClientMessage(playerid, -1, "ATM_CLOSED = false");
    }
    else {
        ATM_CLOSED = true;
        SendClientMessage(playerid, -1, "ATM_CLOSED = true");
    }
    return 1;
}
stock ShowBankDialog(playerid, idx)
{
    if(!ATM_CLOSED) return SendClientMessage(playerid, COLOR_GREY, !"Банкоматы в данный момент недоступны, воспользуйтесь услугами банка!");
	new string_[256];
    if (pInfo[playerid][pJob] == 8) {
        new 
            total_bag = (ATMInfo[idx][aTotalCash]/100);
        format(string_, sizeof string_, 
            ""colwhi"[0] Положить деньги на счёт\n[1] Снять деньги со счёта\n[2] Баланс: "collime"$%d "colwhi"| Комиссия: "C_PODS"%.1f%%\n"colwhi"[3] Оплатить квартплату\n[4] "C_PODS"Провести инкассацию (Суммок: %d)", 
            pInfo[playerid][pBank], ATMInfo[idx][aCommission], total_bag
        );
    } else {
        format(string_, sizeof string_, 
            ""colwhi"[0] Положить деньги на счёт\n[1] Снять деньги со счёта\n[2] Баланс: "collime"$%d "colwhi"| Комиссия: "C_PODS"%.1f%%\n"colwhi"[3] Оплатить квартплату", 
            pInfo[playerid][pBank], ATMInfo[idx][aCommission]
        );
    }
	
	ShowPlayerDialog(playerid, D_ATM_FUNC_0, DIALOG_STYLE_LIST, ""colserver"Банк: "colwhi"ATM", string_, "Выбрать", "Закрыть");
    //ApplyAnimation(playerid, "PED", "ATM", 4.1, 0, 0, 0, 0, 0, 0); 
    PlayerUseAimATM(playerid);
    return 1;
} 
ATM_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
    #pragma unused inputtext, listitem
	switch (dialogid) {
        case D_DEV_FUNC_2:
		{
			if (!response) {
                return true;
            }
			new 
                Float:x, Float:y, Float:z, Float:angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			x += floatsin(-angle, degrees);
			y += floatcos(-angle, degrees);
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Чтобы выйти, нажмите: "colserver"\"ESC\""colwhi" и чтобы сохранить, нажмите курсором: "colserver"\"СОХРАНИТЬ\"");
			new atm_sr = CreateDynamicObject(2754, x, y, z-0.35, 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			SetPVarInt(playerid, "CreateATMServer", atm_sr+1);
			EditDynamicObject(playerid, atm_sr);
			return true;
		}
    }
	return false;
}
ATM_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	#pragma unused objectid, rx, ry 
    if (GetPVarInt(playerid, "CreateATMServer") > 0)
	{
		if (response == EDIT_RESPONSE_FINAL)
		{
			S_ATM_COUNT++;
			ATMInfo[S_ATM_COUNT][aPos][0] = x;
			ATMInfo[S_ATM_COUNT][aPos][1] = y;
			ATMInfo[S_ATM_COUNT][aPos][2] = z;
			ATMInfo[S_ATM_COUNT][aPos][3] = rz;
            ATMInfo[S_ATM_COUNT][aWorld] = GetPlayerVirtualWorld(playerid);
            ATMInfo[S_ATM_COUNT][aInterior] = GetPlayerInterior(playerid);
			DestroyDynamicObject(GetPVarInt(playerid, "CreateATMServer")-1);
            ATMInfo[S_ATM_COUNT][aATMArea] = CreateDynamicSphere(
                ATMInfo[S_ATM_COUNT][aPos][0], ATMInfo[S_ATM_COUNT][aPos][1], ATMInfo[S_ATM_COUNT][aPos][2],
                1.5, ATMInfo[S_ATM_COUNT][aWorld], ATMInfo[S_ATM_COUNT][aInterior]
            );
            SetDynamicAreaType(ATMInfo[S_ATM_COUNT][aATMArea], AREA_TYPE_ATM, S_ATM_COUNT); 
            ATMInfo[S_ATM_COUNT][aATMObject] = CreateDynamicObject(2754, ATMInfo[S_ATM_COUNT][aPos][0], ATMInfo[S_ATM_COUNT][aPos][1], ATMInfo[S_ATM_COUNT][aPos][2], 0.0, 0.0, ATMInfo[S_ATM_COUNT][aPos][3], ATMInfo[S_ATM_COUNT][aWorld], ATMInfo[S_ATM_COUNT][aInterior]);           
            ATMInfo[S_ATM_COUNT][aLabel] = CreateDynamic3DTextLabel(
                "Нажмите: \"ENTER\"", 0x00D900FF, 
                ATMInfo[S_ATM_COUNT][aPos][0], ATMInfo[S_ATM_COUNT][aPos][1], ATMInfo[S_ATM_COUNT][aPos][2] + 1.1, 10.0, 
                .worldid = ATMInfo[S_ATM_COUNT][aWorld], .interiorid = ATMInfo[S_ATM_COUNT][aInterior]
            );  
			DeletePVar(playerid, "CreateATMServer"); 
  			format(t_string, sizeof t_string, "Банкомат под номером "colserver"%d"colwhi" установлен!", S_ATM_COUNT);
  			SendClientMessage(playerid, -1, t_string);

		   	format(t_string, sizeof t_string, 
                "INSERT INTO "TABLE_ATM" (id, ax, ay, az, arz, aworld, aint) \
                VALUES ('%d', '%f', '%f', '%f', '%f', '%d', '%d')",
		   	    S_ATM_COUNT, 
                ATMInfo[S_ATM_COUNT][aPos][0], 
                ATMInfo[S_ATM_COUNT][aPos][1],
                ATMInfo[S_ATM_COUNT][aPos][2], 
                ATMInfo[S_ATM_COUNT][aPos][3],
                ATMInfo[S_ATM_COUNT][aWorld],
                ATMInfo[S_ATM_COUNT][aInterior]
            );
			mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS; 
            return 1;
		}
		if (response == EDIT_RESPONSE_CANCEL) {
			DeletePVar(playerid, "CreateATMServer");
            DestroyDynamicObject( GetPVarInt(playerid, "CreateATMServer") -1);
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Установка банкомата отменена!");  
            return 1;
		} 
	} 
	return false;
}

/*

Header size:          33692 bytes
Code size:         10387892 bytes
Data size:         53246444 bytes
Stack/heap size:      16384 bytes; estimated max. usage=2920 cells (11680 bytes)
Total requirements:63684412 bytes 
Header size:          35296 bytes
Code size:         11981384 bytes
Data size:         53894956 bytes
Stack/heap size:      16384 bytes; estimated max. usage=2469 cells (9876 bytes)
Total requirements:65928020 bytes
*/