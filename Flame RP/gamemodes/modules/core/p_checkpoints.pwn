public OnPlayerEnterCheckpoint(playerid) {
    if(TI[playerid][tJobGun][0]) {
		if(TI[playerid][tJobGun][1] != 2) return ErrorMessage(playerid,"Необходимо взять заготовку");
		if(GetPlayerState(playerid) >= PLAYER_STATE_DRIVER) return 1;
		for(new id = 0;id < 24;id++) {
			if(IsPlayerInDynamicCP(playerid, gun_pickup[id])) {
		        SetPVarInt(playerid,"loadid",id);

				JobTempProcess[playerid] = 3;
				TI[playerid][tProcess][0] = 0;
				TI[playerid][tProcess][1] = 10;
				DisablePlayerCheckpoint(playerid);
				StartJobProcess(playerid);
				// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
				// for(new YN = 0;YN < 3;YN++) {
				// 	TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
				// 	if(YN < 2) PlayerTextDrawShow(playerid,YandNsysTDPlayer[playerid][YN]);
				// }
				// RandomYareNforJOBS(playerid);
			}
		}
	}
	else if(GetPVarInt(playerid,"WaitExam")) DisablePlayerCheckpoint(playerid);
	else if(TI[playerid][tJobMine][0]) {
		if(IsPlayerInRangeOfPoint(playerid, 3.1, -1864.2852,-1605.7734,21.7578))
		{
			if(GetPlayerState(playerid) >= PLAYER_STATE_DRIVER) return 1;
			SetPVarInt(playerid, "mineanim", 0);
			SetPVarInt(playerid, "minesuccess", 0);

			new 
				gotmoney = 27 + random(23),
				string[49];

			ApplyAnimation(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0);
			TI[playerid][tJobMine][1] += gotmoney;

			format(string, 43, "Вы доставили в кузницу %d кг руды", gotmoney);
			SendOk(playerid, string);

			string = "";
			format(string, 48, "Общее количество добытого сырья: %d кг", TI[playerid][tJobMine][1]);
			SendOk(playerid, string);

			TI[playerid][tJobSalary] += gotmoney*WorkSalary[6];// сделать динамическую зп
			new string_update_td[24];
			format(string_update_td,sizeof(string_update_td),"MONEY:_%d",TI[playerid][tJobSalary]);
			PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string_update_td);

			RemovePlayerAttachedObject(playerid, 2);
			RemovePlayerAttachedObject(playerid, 3);
			RemovePlayerAttachedObject(playerid, 6);
			SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);
			DisablePlayerCheckpoint(playerid);
			switch(random(4)) { 
				case 0: SetPlayerCheckpoint(playerid, -1810.9850,-1651.5428,22.9537, 1.5);
				case 1: SetPlayerCheckpoint(playerid, -1807.7166,-1646.6080,23.5568, 1.5);
				case 2: SetPlayerCheckpoint(playerid, -1811.6035,-1655.8864,22.7126, 1.5);
				case 3: SetPlayerCheckpoint(playerid, -1802.2560,-1649.0052,26.0626, 1.5);
			}
			mine_ruda[playerid][0] = CreateDynamicCP(-1810.9850,-1651.5428,22.9537, 3.0, 0, 0, playerid, 1.5);
			mine_ruda[playerid][1] = CreateDynamicCP(-1807.7166,-1646.6080,23.5568, 3.0, 0, 0, playerid, 1.5);
			mine_ruda[playerid][2] = CreateDynamicCP(-1811.6035,-1655.8864,22.7126, 3.0, 0, 0, playerid, 1.5);
			mine_ruda[playerid][3] = CreateDynamicCP(-1802.2560,-1649.0052,26.0626, 3.0, 0, 0, playerid, 1.5);
		}
	}
	else if(TI[playerid][tJobLoader][0])
	{
		if(GetPlayerState(playerid) >= PLAYER_STATE_DRIVER) return 1;
		if(GetPlayerVirtualWorld(playerid) != 0) return 1;
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 836.7643,-1203.7499,16.9766))
		{
			TI[playerid][tJobLoader][1] = 1;

			SetPVarInt(playerid, "anti_bot_time", unix + 12);
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1,0,1,1,1,1);
	  		if(!IsPlayerAttachedObjectSlotUsed(playerid, 2)) SetPlayerAttachedObject(playerid, 2, 2060, 5, 0.01, 0.1, 0.2, 100, 10, 85);

	  		SetPlayerCheckpoint(playerid, 851.1362,-1296.8186,13.6151, 4.0);
		}

		else if(IsPlayerInRangeOfPoint(playerid, 4.0, 851.1362,-1296.8186,13.6151)) {

			if(GetPVarInt(playerid, "anti_bot_time") > unix) {
				SetPVarInt(playerid, "anti_bot_warning_count", GetPVarInt(playerid, "anti_bot_warning_count") + 1);

				if(GetPVarInt(playerid, "anti_bot_warning_count") >= 3) {
					ErrorMessage(playerid, "Вы были кикнуты по подозрению в использовании чит-программ [#212]");
					return Kick(playerid);
				}
				else {
					if(Iter_Count(adminsCount) > 0) {
						new string[35  + MAX_PLAYER_NAME];

						format(string, sizeof(string), "[A] %s[%d] возможно бот [на %d сек.]", player_name[playerid], playerid, GetPVarInt(playerid, "anti_bot_time") - unix);
						SendAdminMessage(CADMIN_INFO, string);
					}
				}
			}
		    TI[playerid][tJobLoader][1] = 0;

		    SetPlayerCheckpoint(playerid, 836.7643,-1203.7499,16.9766, 4.0);

		    TI[playerid][tJobLoader][2] += 1;

		    TI[playerid][tJobSalary] += WorkSalary[5];

            RemovePlayerAttachedObject(playerid, 2);
            ApplyAnimation(playerid, "PED", "IDLE_tired", 4.1,0,1,1,0,1);

            /*new string_salary[17];

            format(string_salary, sizeof(string_salary), "~g~+%d$", WorkSalary[5]);

			GameTextForPlayer(playerid, string_salary, 5000, 5);*/

			new string_score[32];

			format(string_score,sizeof(string_score),"MONEY:_%d",TI[playerid][tJobSalary]);
			PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string_score);

           	new string_message[104];

			format(string_message,sizeof(string_message),"Вы перенесли мешок. Всего мешков перенесено - "ORANGE"%d шт",TI[playerid][tJobLoader][2]);

			SendUse(playerid,string_message);

			if(QuestProgress[playerid][1] < 10 && AcceptQuest[playerid][1] != 0) {
				QuestProgress[playerid][1] += 1;
				save_quest(playerid,1);
				if(QuestProgress[playerid][1] >= 10) QuestProgress[playerid][1] = 10;
			}
			if(QuestProgress[playerid][1] == 10 && AcceptQuest[playerid][1] != 0) {
				D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно перенесли 10 мешков. Данное задание можно завершить и забрать за него награду","Закрыть","");
				NextStapQI(playerid,1);
			}

		}
	}
	new vehicleid = GetPlayerVehicleID(playerid);
	switch(GetPVarInt(playerid,"MatsArmyCar")) {
		case 1..4: {
			DisablePlayerCheckpoint(playerid);
			if(GetPVarInt(playerid,"MatsArmyCar") == 1 && !IsPlayerInRangeOfPoint(playerid, 10.0, 1535.8534,-1674.4445,13.3828)) return 1;
			if(GetPVarInt(playerid,"MatsArmyCar") == 2 && !IsPlayerInRangeOfPoint(playerid, 10.0, -1606.6760,726.5093,12.0220)) return 1;
			if(GetPVarInt(playerid,"MatsArmyCar") == 3 && !IsPlayerInRangeOfPoint(playerid, 10.0, 2288.5105,2421.4209,10.8203)) return 1;
			if(GetPVarInt(playerid,"MatsArmyCar") == 4 && !IsPlayerInRangeOfPoint(playerid, 10.0, -1978.0072,-1008.3723,32.0234)) return 1;
			new string[96];
			if(VG[vehicleid][vgAmount][0] <= 0) return ErrorMessage(playerid,"Грузовик пуст");
			switch(GetPVarInt(playerid,"MatsArmyCar")) {
				case 1: {
					FI[fLSPD][fMats] += VG[vehicleid][vgAmount][0]*500;
					if(FI[fLSPD][fMats] > 500000) FI[fLSPD][fMats] = 500000;
					format(string,sizeof(string),"Боеприпасы успешно выгружены! На складе Полиции ЛС: "W"%i",FI[fLSPD][fMats]);
					SendOk(playerid,string);
				}
				case 2: {
					FI[fSFPD][fMats] += VG[vehicleid][vgAmount][0]*500;
					if(FI[fSFPD][fMats] > 500000) FI[fSFPD][fMats] = 500000;
					format(string,sizeof(string),"Боеприпасы успешно выгружены! На складе Полиции СФ: "W"%i",FI[fSFPD][fMats]);
					SendOk(playerid,string);
				}
				case 3: {
					FI[fLVPD][fMats] += VG[vehicleid][vgAmount][0]*500;
					if(FI[fLVPD][fMats] > 500000) FI[fLVPD][fMats] = 500000;
					format(string,sizeof(string),"Боеприпасы успешно выгружены! На складе Полиции ЛВ: "W"%i",FI[fLVPD][fMats]);
					SendOk(playerid,string);
				}
				case 4: {
					FI[fFBI][fMats] += VG[vehicleid][vgAmount][0]*500;
					if(FI[fFBI][fMats] > 500000) FI[fFBI][fMats] = 500000;
					format(string,sizeof(string),"Боеприпасы успешно выгружены! На складе ФБР: "W"%i",FI[fFBI][fMats]);
					SendOk(playerid,string);
				}
			}
			GiveMoney(playerid,1500,"доставка боеприпасов");
			VG[vehicleid][vgAmount][0] = 0;
			DeletePVar(playerid,"MatsArmyCar");
		}
		case 5: {
			static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,zavodsklad,30000-VG[vehicleid][vgAmount][0]);
			D(playerid, D_ARMY_CARM_SF_4, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 6: {
			static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,FI[fARMYSF][fMats],30000-VG[vehicleid][vgAmount][0]);
			D(playerid, D_ARMY_CARM_SF_5, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 7: {
			static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"На склад поместится: "ORANGE"%d";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYSF][fMats]);
			D(playerid, D_ARMY_CARM_SF_6, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 8: {
			static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"На склад поместится: "ORANGE"%d";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYLV][fMats]);
			D(playerid, D_ARMY_CARM_SF_7, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 10: {
			if(VG[vehicleid][vgAmount][0]) return ErrorMessage(playerid,"В автомобиле уже есть боеприпасы");
			if(FI[fARMYLV][fMats] < 12500) return ErrorMessage(playerid,"На складе армии недостаточно боеприпасов");
			VG[vehicleid][vgAmount][0] = 25;
			FI[fARMYLV][fMats] -= 500*25;
			SendOk(playerid,"Боеприпасы успешно загружены! Доступно ящиков: "W"25");
			SendOk(playerid,"Для разгрузки боеприпасов введите: "W"/unload");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 11: {
			if(VG[vehicleid][vgAmount][0]) return ErrorMessage(playerid,"В автомобиле уже есть боеприпасы");
			if(FI[fARMYSF][fMats] < 12500) return ErrorMessage(playerid,"На складе армии недостаточно боеприпасов");
			VG[vehicleid][vgAmount][0] = 25;
			FI[fARMYSF][fMats] -= 500*25;
			SendOk(playerid,"Боеприпасы успешно загружены! Доступно ящиков: "W"25");
			SendOk(playerid,"Для разгрузки боеприпасов введите: "W"/unload");
			DeletePVar(playerid,"MatsArmyCar");
			DisablePlayerCheckpoint(playerid);
		}
	}
	switch(GetPVarInt(playerid,"DrugsMafiaCar")) {
		case 1: {
			if(VG[vehicleid][vgDrugs] >= 500) return ErrorMessage(playerid,"Грузовик полон");
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите загрузить в грузовик:\n\n\
									Доступно наркотиков: "ORANGE"%d\n\
									"W"В грузовик поместится: "ORANGE"%d";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,FI[PI[playerid][pMember]][fDrugs],500-VG[vehicleid][vgDrugs]);
			D(playerid, D_MAFIA_CARM_2, DSI, ""P"Загрузка наркотиков",string, "Загрузить", "Отмена");
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
		}
		case 2: {
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
			if(!FI[fBALLAS][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков") ;
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать The Ballas:\n\n\
									Доступно наркотиков: "ORANGE"%d"W"\n\
									Склад банды: "ORANGE"%d\n\
									"W"Заказ банды: "ORANGE"%d / $%d 1г";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgDrugs],FI[fBALLAS][fDrugs],FI[fBALLAS][fDrugsBuy],FI[fBALLAS][fDrugsPrice]);
			D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
			SetPVarInt(playerid,"sell_gdrugs",1);
		}
		case 3: {
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
			if(!FI[fVAGOS][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков") ;
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать The Vagos:\n\n\
									Доступно наркотиков: "ORANGE"%d"W"\n\
									Склад банды: "ORANGE"%d\n\
									"W"Заказ банды: "ORANGE"%d / $%d 1г";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgDrugs],FI[fVAGOS][fDrugs],FI[fVAGOS][fDrugsBuy],FI[fVAGOS][fDrugsPrice]);
			D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
			SetPVarInt(playerid,"sell_gdrugs",2);
		}
		case 4: {
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
			if(!FI[fGROVE][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков") ;
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать The Grove:\n\n\
									Доступно наркотиков: "ORANGE"%d"W"\n\
									Склад банды: "ORANGE"%d\n\
									"W"Заказ банды: "ORANGE"%d / $%d 1г";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgDrugs],FI[fGROVE][fDrugs],FI[fGROVE][fDrugsBuy],FI[fGROVE][fDrugsPrice]);
			D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
			SetPVarInt(playerid,"sell_gdrugs",3);
		}
		case 5: {
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
			if(!FI[fAZTEC][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков") ;
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать The Aztec:\n\n\
									Доступно наркотиков: "ORANGE"%d"W"\n\
									Склад банды: "ORANGE"%d\n\
									"W"Заказ банды: "ORANGE"%d / $%d 1г";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgDrugs],FI[fAZTEC][fDrugs],FI[fAZTEC][fDrugsBuy],FI[fAZTEC][fDrugsPrice]);
			D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
			SetPVarInt(playerid,"sell_gdrugs",4);
		}
		case 6: {
			DeletePVar(playerid,"DrugsMafiaCar");
			DisablePlayerCheckpoint(playerid);
			if(!FI[fRIFA][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков") ;
			static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать The Rifa:\n\n\
									Доступно наркотиков: "ORANGE"%d"W"\n\
									Склад банды: "ORANGE"%d\n\
									"W"Заказ банды: "ORANGE"%d / $%d 1г";
			new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
			format(string,sizeof(string),f_str,VG[vehicleid][vgDrugs],FI[fRIFA][fDrugs],FI[fRIFA][fDrugsBuy],FI[fRIFA][fDrugsPrice]);
			D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
			SetPVarInt(playerid,"sell_gdrugs",5);
		}
	}
	if(TI[playerid][tTrucker][0]) {
		SendOk(playerid,"Посигнальте для разгрузки груза");
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(gpss[playerid]) {
		gpss[playerid] = 0;
		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	return 1;
}
public OnPlayerLeaveCheckpoint(playerid) {
	if(TI[playerid][tJobGun][0]) {
		if(TI[playerid][tProcess][0] == -1) return 1;
		for(new id = 0;id < 24;id++) {
			if(!IsPlayerInDynamicCP(playerid, gun_pickup[id])) {
				TI[playerid][tProcess][0] = -1;
				TI[playerid][tProcess][1] = -1;
				// for(new YN = 0;YN < 3;YN++) {
				// 	TextDrawHideForPlayer(playerid, YandNsysTD[YN]);
				// 	if(YN < 2) PlayerTextDrawDestroy(playerid,YandNsysTDPlayer[playerid][YN]);
				// }
				JobTempProcess[playerid] = 0;
				KillTimer(timer_job[playerid]);
				ClearAnimations(playerid,1);
				ClearAnimationsEX(playerid);
			}
		}
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid) {
	if(gpss[playerid]) gpss[playerid] = 0;
	if(!GetPVarInt(playerid,"route") && !GetPVarInt(playerid,"check_job_cleaner")) DisablePlayerRaceCheckpoint(playerid);
	if(GetPVarInt(playerid,"WaitExam")) {
		if(GetPlayerState(playerid) != 2) return 1;
		new slot = GetPVarInt(playerid,"LessonSlot");
		if(slot == AUTO_CP_COUNT) {
			new Float:health;
			new vehicleid = GetPlayerVehicleID(playerid);
			GetVehicleHealth(vehicleid,health);
			if(health >= 850) {
				SendClientMessage(playerid,CGOLD,"Поздравляем с получением водительского удостоверения");
				lic[playerid][0] = 1;
				UpdateLicenses(playerid);
			}
			else SendOk(playerid,"Тест по вождению завален, Вы еще плохо водите автомобиль");
			VehicleInfo[vehicleid][vFuel] = 60.0;
			GetVehicleParamsEx(vehicleid,engine,lights,alarm,doors,bonnet,boot,objective);
    		SetVehicleParamsEx(vehicleid,engine,lights,alarm,0,bonnet,boot,objective);

			SetVehicleToRespawn(vehicleid);
			DisablePlayerRaceCheckpoint(playerid);
			DeletePVar(playerid,"LessonSlot");
			DeletePVar(playerid,"WaitExam");
			DeletePVar(playerid,"pWaitingExam");
			TI[playerid][tAutoSchool] = 0;
		}
		else if(slot >= AUTO_CP_COUNT - 1) SetPlayerRaceCheckpoint(playerid, 1, AutoCP[AUTO_CP_COUNT - 1][0], AutoCP[AUTO_CP_COUNT - 1][1], AutoCP[AUTO_CP_COUNT - 1][2], 0.0,0.0,0.0, 3.0);
		else SetPlayerRaceCheckpoint(playerid, 0, AutoCP[slot][0], AutoCP[slot][1], AutoCP[slot][2], AutoCP[slot+1][0], AutoCP[slot+1][1], AutoCP[slot+1][2], 3.0);
		SetPVarInt(playerid,"LessonSlot", slot + 1);
		return 1;
	}
	if(TI[playerid][tAutoSchool] == 2) {
		if(car_autoschool[playerid] == INVALID_VEHICLE_ID) return 1;
		if(GetPlayerState(playerid) != 2) return 1;
		new slot = GetPVarInt(playerid,"LessonSlotMav");
		if(slot == 16) {
			new Float:health;
			GetVehicleHealth(car_autoschool[playerid],health);
			if(health >= 850) {
				SendClientMessage(playerid,CGOLD,"Поздравляем с получением лицензии на полёты");
				lic[playerid][1] = 1;
				UpdateLicenses(playerid);
			}
			else SendOk(playerid,"Тест по завален, Вы еще плохо управляете воздушным транспортом");
			A_DestroyVehicle(car_autoschool[playerid]);
			car_autoschool[playerid] = INVALID_VEHICLE_ID;
			DisablePlayerRaceCheckpoint(playerid);
			DeletePVar(playerid,"LessonSlotMav");
			SetPlayerPosAC(playerid,GetPVarFloat(playerid,"pos_x_autos"),GetPVarFloat(playerid,"pos_y_autos"),GetPVarFloat(playerid,"pos_z_autos"),45,3,true);
			TI[playerid][tAutoSchool] = 0;
		}
		else if(slot >= 16 - 1) SetPlayerRaceCheckpoint(playerid, 4, AutoCPMav[16 - 1][0], AutoCPMav[16 - 1][1], AutoCPMav[16 - 1][2], 0.0,0.0,0.0, 5.0);
		else SetPlayerRaceCheckpoint(playerid, 3, AutoCPMav[slot][0], AutoCPMav[slot][1], AutoCPMav[slot][2], AutoCPMav[slot+1][0], AutoCPMav[slot+1][1], AutoCPMav[slot+1][2], 5.0);
		SetPVarInt(playerid,"LessonSlotMav", slot + 1);
		return 1;
	}
	if(TI[playerid][tAutoSchool] == 3) {
		if(car_autoschool[playerid] == INVALID_VEHICLE_ID) return 1;
		if(GetPlayerState(playerid) != 2) return 1;
		new slot = GetPVarInt(playerid,"LessonSlotBoat");
		if(slot == 17) {
			new Float:health;
			GetVehicleHealth(car_autoschool[playerid],health);
			if(health >= 850) {
				SendClientMessage(playerid,CGOLD,"Поздравляем с получением лицензии на водный транспорт");
				lic[playerid][2] = 1;
				UpdateLicenses(playerid);
			}
			else SendOk(playerid,"Тест по завален, Вы еще плохо управляете водным транспортом");
			A_DestroyVehicle(car_autoschool[playerid]);
			car_autoschool[playerid] = INVALID_VEHICLE_ID;
			DisablePlayerRaceCheckpoint(playerid);
			DeletePVar(playerid,"LessonSlotBoat");
			SetPlayerPosAC(playerid,GetPVarFloat(playerid,"pos_x_autos"),GetPVarFloat(playerid,"pos_y_autos"),GetPVarFloat(playerid,"pos_z_autos"),45,3,true);
			TI[playerid][tAutoSchool] = 0;
		}
		else if(slot >= 17 - 1) SetPlayerRaceCheckpoint(playerid, 1, AutoCPBoat[17 - 1][0], AutoCPBoat[17 - 1][1], AutoCPBoat[17 - 1][2], 0.0,0.0,0.0, 4.5);
		else SetPlayerRaceCheckpoint(playerid, 0, AutoCPBoat[slot][0], AutoCPBoat[slot][1], AutoCPBoat[slot][2], AutoCPBoat[slot+1][0], AutoCPBoat[slot+1][1], AutoCPBoat[slot+1][2], 4.5);
		SetPVarInt(playerid,"LessonSlotBoat", slot + 1);
		return 1;
	}
	else if(GetPlayerState(playerid) == 2 && GetPlayerVehicleID(playerid) != 0 && GetPVarInt(playerid, "id_cp") && GetPVarInt(playerid,"route") && VehicleInfo[GetPlayerVehicleID(playerid)][vJob] == 1) {
		//if(!IsPlayerInRangeOfPoint(playerid,30,gBusCPs[GetPVarInt(playerid,"route")][GetPVarInt(playerid, "id_cp")][1],gBusCPs[GetPVarInt(playerid,"route")][GetPVarInt(playerid, "id_cp")][2],gBusCPs[GetPVarInt(playerid,"route")][GetPVarInt(playerid, "id_cp")][3])) Kick(playerid);
		SetNextBusCP(playerid);
		return 1;
	}
	if(GetPVarInt(playerid,"RaceCP") != 0) {
		SetNextRaceCP(playerid,race_type);
		return 1;
	}
	if(GetPVarInt(playerid,"check_job_cleaner") && GetPVarInt(playerid, "check_job_cleaner") && GetPlayerState(playerid) == 2 && GetPlayerVehicleID(playerid) != 0 && VehicleInfo[GetPlayerVehicleID(playerid)][vJob] == 5) {
		SetNextJobClearCP(playerid,GetPVarInt(playerid, "route_job_cleaner"));
		return 1;
	}
	return 1;
}
public OnPlayerLeaveRaceCheckpoint(playerid) {
	return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid) {
	if(SERIU[playerid][sID] != INVALID_PLAYER_ID) return 1;
	if(checkpointid == gPlayerProdCP[playerid] && GetPVarInt(playerid,"prod_id") && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
		//if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609 && !GetVehicleTrailer(GetPlayerVehicleID(playerid))) return ErrorMessage(playerid,"У Вас нет цистерны с топливом");
		static const fmt_str[] = ""W"Бизнес: "P"%s\n\n\
										"W"Требуется продуктов: "O"%d\n\
										"W"Доступно для разгрузки: "O"%d\n\
										"W"Введите кол-во продуктов для продажи:";
		new string[sizeof(fmt_str) - 2 * 3 + 32 + 5 * 2 + 5 + 1 + 7 * 7];
		new bizid = GetPVarInt(playerid,"prod_id")-1;
		format(string, sizeof(string), fmt_str ,gBusiness[bizid][bizzName],gBusiness[bizid][bizzProdOrder],GetPVarInt(playerid,"count_prod"));
		return D(playerid,dProdSell,DSI, ""P"Доставка",string,"Продать","Отмена");
	}
	if(RingCP[0] <= checkpointid <= RingCP[1]) {
		if(RingInfo[0][rgPlayer][0] != playerid && RingInfo[0][rgPlayer][1] != playerid) return ErrorMessage(playerid,"В данный момент не Ваша очередь");
		//if(RingInfo[0][rgTime]) return ErrorMessage(playerid, "В данный момент недоступно");
		if(IsPlayerInDynamicCP(RingInfo[0][rgPlayer][1], RingCP[1]) || IsPlayerInDynamicCP(RingInfo[0][rgPlayer][0], RingCP[0])) return ErrorMessage(playerid, "Данное место для Вашего соперника");
		else SendOk(playerid, "Ожидайте соперника");
		return true;
	}
	if(mine_ruda[playerid][0] <= checkpointid <= mine_ruda[playerid][3])
	{
	    if(GetPVarInt(playerid, "minesuccess") == 1) return 1;
		if(!TI[playerid][tJobMine][0]) return 1;
	    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 0, 0, 1, 10000);
	    SetPVarInt(playerid, "mineanim", 1);
		for (new i; i < 4; i++) DestroyDynamicCP(mine_ruda[playerid][i]);
	    SetTimerEx("mining", 10000, false, "i", playerid);
	}
	if(checkpointid == theftCheck[playerid][0]) { //угон
		if(theftCheck[playerid][1] == 1){
			DestroyDynamicCP(theftCheck[playerid][0]);
			if(theftIDveh[playerid][1] != 1010)	SendOk(theftIDveh[playerid][1],"У вашей машины сработала сигнализация!");
			TogglePlayerControllable(playerid, false);
			TI[playerid][tProcess][0] = 0;
			TI[playerid][tProcess][1] = 10;
			JobTempProcess[playerid] = 15;
			StartJobProcess(playerid);
			// RandomYareNforJOBS(playerid);
			// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
			// for(new YN = 0;YN < 3;YN++) {
			// 	TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
			// 	if(YN < 2) PlayerTextDrawShow(playerid,YandNsysTDPlayer[playerid][YN]);
			// }

		}
		else if(theftCheck[playerid][1] == 4){
			DestroyDynamicCP(theftCheck[playerid][0]);
			SendOk(playerid,"Чтобы взломать дом введите /theftrob");
		}
		else {
			switch(GetPlayerState(playerid)){
				case PLAYER_STATE_ONFOOT:{
					SendClientMessage(playerid,  COLOR_YELLOW, "SMS: Где машина? « Отправитель: James_Sattora [т. 1218181 ]");
				}
				case PLAYER_STATE_DRIVER:{
					if(GetPlayerVehicleID(playerid) != theftIDveh[playerid][0]) return SendClientMessage(playerid,  COLOR_YELLOW, "SMS: Ты привез не ту машину! « Отправитель: James_Sattora [т. 1218181]");
					theftCheck[playerid][1] = 3;
					DestroyDynamicCP(theftCheck[playerid][0]);
					A_DestroyVehicle(theftIDveh[playerid][0]);
					theftIDveh[playerid][0] = INVALID_VEHICLE_ID;
					SendOk(playerid,"Отлично, получай свои деньги и вали от сюда, мы не хотим проблем с копами");
					thefttime[playerid] = 0;
					PlayerTextDrawHide(playerid, theft_PTD[playerid][0]);
					theftCheck[playerid][1] = 3;
					PI[playerid][ptheftExp]++;
					PI[playerid][ptheftTime] = gettime()+GetLimitTheeft(playerid);
					UpdatePlayerData(playerid,"theftTime",PI[playerid][ptheftTime]);
					UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
					GiveMoney(playerid, GetSalaryTheeft(playerid), "Получение с помощью угона");

					//if(PI[playerid][pMember]) add_gang_points(PI[playerid][pMember],1);

					if(TheftSkillMax[PI[playerid][ptheftSkill]] == PI[playerid][ptheftExp] && PI[playerid][ptheftSkill] != 25){
						PI[playerid][ptheftSkill] ++, UpdatePlayerData(playerid,"theftSkill",PI[playerid][ptheftSkill]);
						PI[playerid][ptheftExp] = 0, UpdatePlayerData(playerid,"theftExp",PI[playerid][ptheftExp]);
						SendOk(playerid,"Ваш навык автоугонщика повысился. Просмотр своих навыков /theftprogress");
					}
				}
				default: SendClientMessage(playerid,  COLOR_YELLOW, "SMS: Ну и где машина? « Отправитель: James_Sattora [т. 1218181]");
			}

		}
	}
	if(checkpointid == TI[playerid][tRaceCP]) {
		srace_end(playerid,0);
	}
	return 1;
}
public OnPlayerLeaveDynamicCP(playerid, checkpointid) {
	return true;
}