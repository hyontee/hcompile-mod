public OnPlayerEnterDynamicArea(playerid, areaid) {
	if(!TI[playerid][tLogin]) return 1;
	if(SERIU[playerid][sID] != INVALID_PLAYER_ID) return 1;
	if(GetPVarInt(playerid,"ChangingSkin")) {
		A_SetPlayerSkin(playerid, GetPVarInt(playerid, "curskin"));
		cancel_skin(playerid);
	}
    new pstate = GetPlayerState(playerid);

	if(areaid >= GREENZONE[0][grid] && areaid <= GREENZONE[TOTALZONE][grid]) {
		SetPVarInt(playerid, "showGreenZoneTD", 1);
		for (new i; i < 5; i++) TextDrawShowForPlayer(playerid, greenZoneTD[i]); 
	}
	if(areaid >= TeleportPickup[0] && areaid <= TeleportPickup[sizeof(gTeleportsToD)-1] && pstate == PLAYER_STATE_ONFOOT) {
		new tp = areaid - TeleportPickup[0];
		switch(tp) {
			case 3,5,7: {
				if(PI[playerid][pHospital]) return ErrorMessage(playerid, "Вы не прошли полный курс лечения");
				TI[playerid][tHeal] = false;
			}
			case 8: { } // Центр занятости
			case 10,12,14: {
				if(!IsAMedic(playerid)) return ErrorMessage(playerid,"Доступно для работников МЗ");
				if(PI[playerid][pHospital]) return ErrorMessage(playerid, "Вы не прошли полный курс лечения");
				TI[playerid][tHeal] = false;
			}
			case 40: { } // FBI
			case 41: { } // FBI
			case 58: if(PI[playerid][pMember] != fBALLAS && !TI[playerid][tEnter][fBALLAS]) return ErrorMessage(playerid,"Вы не состоите в данной организации/У Вас нет пропуска");
			case 60: if(PI[playerid][pMember] != fVAGOS && !TI[playerid][tEnter][fVAGOS]) return ErrorMessage(playerid,"Вы не состоите в данной организации/У Вас нет пропуска");
			case 62: if(PI[playerid][pMember] != fGROVE && !TI[playerid][tEnter][fGROVE]) return ErrorMessage(playerid,"Вы не состоите в данной организации/У Вас нет пропуска");
			case 64: if(PI[playerid][pMember] != fAZTEC && !TI[playerid][tEnter][fAZTEC]) return ErrorMessage(playerid,"Вы не состоите в данной организации/У Вас нет пропуска");
			case 66: if(PI[playerid][pMember] != fRIFA && !TI[playerid][tEnter][fRIFA]) return ErrorMessage(playerid,"Вы не состоите в данной организации/У Вас нет пропуска");
			case 68: {
				TI[playerid][tClothesWork][0] = 1;
				TI[playerid][tClothesWork][1] = 1;
				SendOk(playerid,"Можете приступать к работе");
				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
			}
			case 69: {
				TI[playerid][tClothesWork][0] = 0;
				TI[playerid][tClothesWork][1] = 0;
				if(GetPVarInt(playerid,"zp_clothes")) PI[playerid][pSalary] += GetPVarInt(playerid,"zp_clothes"),SendClientMessage(playerid,CGOLD,"Деньги будут зачислены на Ваш банковский счёт во время зарплаты (PayDay)");
				DeletePVar(playerid,"zp_clothes");
				UpdatePlayerData(playerid,"salary",PI[playerid][pSalary]);
				if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
			}
			case 75: {
				if(player_to_race_lv[playerid]) return ErrorMessage(playerid,"Участнику гонок запрещено покидать помещение");
				if(player_to_golod[playerid]) return ErrorMessage(playerid,"Участнику голодных игр запрещено покидать помещение");
			}
			case 76: {
				if(PI[playerid][pLevel] < 3) return ErrorMessage(playerid,"Вход в казино возможен с 3 уровня");
				if(!casino) return ErrorMessage(playerid, "Вход в казино временно закрыт");
			}
			case 77: if(GetPVarInt(playerid,"krup")) return ErrorMessage(playerid, "Необходимо закончить работу крупье");
			case 78,80: if(!IsAArm(playerid)) return ErrorMessage(playerid,"У Вас нет доступа");
			case 92,94: if(!IsAArm(playerid) || !start_work[playerid]) return ErrorMessage(playerid,"У Вас нет доступа");
			case 93,95: if(PI[playerid][pHospital]) return ErrorMessage(playerid, "Вы не прошли полный курс лечения");
			case 96..99: if(!IsACop(playerid) || !start_work[playerid]) return ErrorMessage(playerid,"У Вас нет доступа");
			case 28,32,36: if(!IsACop(playerid)) return ErrorMessage(playerid,"У Вас нет доступа");
			case 84: if(PI[playerid][pMember] != fLCN && TI[playerid][tMasked] != fLCN) return ErrorMessage(playerid,"У Вас нет доступа");
			case 108: if(PI[playerid][pMember] != fYAKUZA && TI[playerid][tMasked] != fYAKUZA) return ErrorMessage(playerid,"У Вас нет доступа");
			case 110: if(PI[playerid][pMember] != fRM && TI[playerid][tMasked] != fRM) return ErrorMessage(playerid,"У Вас нет доступа");
			case 112,114,116: {
				if(!TI[playerid][tTir]) return ErrorMessage(playerid,"У Вас нет пропуска в тир. Приобрести пропуск можно на кассе");
			}
			case 118: // Army SF, Army LV
			{
			    if(!IsAArm(playerid)) return ErrorMessage(playerid,"У Вас нет доступа");
			}
			case 113,115,117,119,121,123,125,127,129,131,133,135: { //тир //выход
				SetPVarInt(playerid, "ShootingStart", 0);
			}
		}
		if(tp > 1 && gTeleportsToD[tp][tpExitInt] != 6 && tp != 95 && gTeleportsToD[tp][tpExitInt] != 3 && tp != 89 && tp != 17 && tp != 113 && tp != 115 && tp != 117 && tp != 112 && tp != 114 && tp != 116) OnPlayerUpdateLoadingMode(playerid);
		SetPlayerFacingAngle(playerid, gTeleportsToD[tp][tpExitPos_A]);
		SetPlayerPosAC(playerid, gTeleportsToD[tp][tpExitPos_X], gTeleportsToD[tp][tpExitPos_Y], gTeleportsToD[tp][tpExitPos_Z],gTeleportsToD[tp][tpExitWorld],gTeleportsToD[tp][tpExitInt]);
		SetCameraBehindPlayer(playerid);
		FreezePlayerForTime(playerid,3);
		return true;
	}
	if(areaid >= gPickID[0] && areaid <= gPickID[PICKUPS_COUNT-1] && pstate == PLAYER_STATE_ONFOOT) { // ПИКАПЫ
		new pick = areaid - gPickID[0];
		switch(pick) {
			case 0: {
				static const f_str[] =
					""GREEN"1.Общие положения:"W"\n\
					1.1 Участники дорожного движения обязаны знать и неукоснительно выполнять требования этих Правил,\n\
					\tа также быть взаимно вежливыми.\n\
					1.2 Обгон транспортного средства разрешен только с левой стороны, при этом водитель обязан убедиться,\n\
					\tчто встречная полоса свободна на достаточном для обгона расстоянии.\n\
					1.3 Управлять транспортным средством имеет право особа достигшая возраста 18 лет при этом имея вод.удостоверение.\n\
					1.4 При ДТП водители обязаны немедленно остановиться на месте случившегося, вызвать и дождаться полицию.\n\
					1.5 Ближний свет фар требуется включать в любое время суток.\n\
					1.6 Гос. Номера должны быть всегда видимыми спереди и сзади.\n\n\
					"GREEN"2.Скорость движения:"W"\n\
					2.1 В пределах города разрешается движение транспортных средств со скоростью не более 60 км/ч\n\
					2.2 За пределами города разрешается движение транспортных средств со скоростью не более 120 км/ч\n\n\
					"GREEN"3. Остановка и стоянка:"W"\n\
					3.1 Остановка на магистрали разрешена только на спец. площадках для стоянки\n\n\
					"GREEN"4. Спец. Сигналы:"W"\n\
					4.1 В случае приближения транспортного средства с включенным проблесковым маячком и (или)\n\
					\tспециальным звуковым сигналом водители других транспортных средств,\n\
					\tкоторые могут создавать ему препятствие для движения, обязаны уступить ему дорогу.";
				new string[sizeof(f_str)];
				format(string,sizeof(string),"%s",f_str);
				D(playerid,DIALOG_NONE,DSM, ""P"Правила Дорожного Движения",string,"Закрыть","");
			}
			case 1: D(playerid,D_JOB,DSL,""P"Трудоустройство",""W"1. Водитель автобуса\t\t\t\t| "P"2 лвл\n"W"2. Механик\t\t\t\t| "P"3 лвл\n"W"3. Развозчик еды\t\t\t| "P"3 лвл\n"W"4. Развозчик продуктов/топлива\t| "P"4 лвл\n"W"5. Мойщик дорог\t\t\t| "P"4 лвл\n"W"6. Газонокосильщик\t\t\t| "P"5 лвл", "Выбрать", "Закрыть");
			case 2: {
				new price_car,price_gun,price_boat,price_air;
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller_car = floatround(500/100*BonusInfo[act_buylic]);
					new seller_air = floatround(15000/100*BonusInfo[act_buylic]);
					new seller_boat = floatround(10000/100*BonusInfo[act_buylic]);
					new seller_gun = floatround(20000/100*BonusInfo[act_buylic]);
					price_car = (500-seller_car);
					price_air = (15000-seller_air);
					price_boat = (10000-seller_boat);
					price_gun = (20000-seller_gun);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller_car = floatround(500/100*BonusInfo[act_buylic]);
					new seller_air = floatround(15000/100*BonusInfo[act_buylic]);
					new seller_boat = floatround(10000/100*BonusInfo[act_buylic]);
					new seller_gun = floatround(20000/100*BonusInfo[act_buylic]);
					price_car = (500-seller_car);
					price_air = (15000-seller_air);
					price_boat = (10000-seller_boat);
					price_gun = (20000-seller_gun);
				}
			    else {
					price_car = 500;
					price_air = 15000;
					price_boat = 10000;
					price_gun = 20000;
			    }
				new string[512];
				format(string,sizeof(string),""P"1."W" Водительское удостоверение [%s] - "ORANGE"$%d\n"P"2."W" Лицензия на полёты [%s] - "ORANGE"$%d\n"P"3."W" Лицензия на водный транспорт [%s] - "ORANGE"$%d\n"P"4."W" Лицензия на оружие [%s] - "ORANGE"$%d",lic[playerid][0] == 1 ? (""P"Имеется"W""):(""G"Отсутствует"W""),price_car,lic[playerid][1] == 1 ? (""P"Имеется"W""):(""G"Отсутствует"W""),price_air,lic[playerid][2] == 1 ? (""P"Имеется"W""):(""G"Отсутствует"W""),price_boat,lic[playerid][3] == 1 ? (""P"Имеется"W""):(""G"Отсутствует"W""),price_gun);
				D(playerid,D_LICENSES,DSL,""P"Покупка лицензий",string, "Купить", "Отмена");
			}
			case 3: {
				if(TI[playerid][tTPpick]) {
					TI[playerid][tTPpick] = false;
					return 1;
				}
				new otelid = GetPVarInt(playerid,"selectedhotel");
				TI[playerid][tTPpick] = true;
				SetPlayerPosAC(playerid,gHotels[otelid][hotelAreaX],gHotels[otelid][hotelAreaY],gHotels[otelid][hotelAreaZ],0,0);
				SetCameraBehindPlayer(playerid);
			}
			case 4: {
				new hotel = -1;
				switch(GetPlayerVirtualWorld(playerid)) {
					case 0: hotel = 1;
					case 1: hotel = 2;
					case 2: hotel = 3;
					case 3: hotel = 4;
					default: hotel = -1;
				}
				if(hotel == PI[playerid][pHotel]) return D(playerid,D_HOTEL,DSL,""P"Ресепшн",""P"1."W" Список номеров\n"P"2."W" Управление отелем","Выбрать","Отмена");
				else ShowHotelRooms(playerid);
			}
			case 5: {
				if(TI[playerid][tTPpick]) {
					TI[playerid][tTPpick] = false;
					return 1;
				}
				D(playerid,D_HOTEL_LIFT_1,DSL,""P"Лифт","2 этаж\n3 этаж\n4 этаж\n5 этаж\n6 этаж\n7 этаж","Перейти","Отмена");
			}
			case 6: {
				if(TI[playerid][tTPpick]) {
					TI[playerid][tTPpick] = false;
					return 1;
				}
				D(playerid,D_HOTEL_LIFT_2,DSL,""P"Лифт","Ресепшн\n2 этаж\n3 этаж\n4 этаж\n5 этаж\n6 этаж\n7 этаж","Перейти","Отмена");
			}
			case 7: {
				if(PI[playerid][pMedCard]) return ErrorMessage(playerid,"У Вас уже есть мед. карта");

				new price;

				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(1000/100*BonusInfo[act_medcard]);
					price = 1000 - seller;
					
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(1000/100*BonusInfo[act_medcard]);
					price = 1000 - seller;
				}
			    else price = 1000;

				if(GetPlayerMoneyEx(playerid) < price) {

					new string_error[64];

					format(string_error, sizeof(string_error), "У Вас недостаточно средств. Стоимость медицинской карты - $%d", price);
					return ErrorMessage(playerid,string_error);
				}
				static const fmt_str[] = ""W"Стоимость медицинской карты - "GREEN"$%d\n"W"Вы действительно хотите получить мед. карту?";
				new string_dialog[sizeof(fmt_str) + 5 * 2 + 1 + (-2 + 4)];

				format(string_dialog, sizeof(string_dialog), fmt_str, price);

				D(playerid,D_MEDCARD,DSM, ""P"Медицинская карта",string_dialog,"Получить","Отмена");
			}
			case 8: {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");

				new price;
				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(50000/100*vip_status[PI[playerid][pVips]][vip_changesex]);
					if(GetPlayerMoneyEx(playerid) < (50000-seller)) return ErrorMessage(playerid,"У Вас недостаточно денег для операции. Стоимость операции - $50.000");
					price = (50000-seller);
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(50000/100*BonusInfo[act_changesex]);
						if(GetPlayerMoneyEx(playerid) < (50000-seller)) return ErrorMessage(playerid,"У Вас недостаточно денег для операции. Стоимость операции - $50.000");
						price = (50000-seller);
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(50000/100*BonusInfo[act_changesex]);
						if(GetPlayerMoneyEx(playerid) < (50000-seller)) return ErrorMessage(playerid,"У Вас недостаточно денег для операции. Стоимость операции - $50.000");
						price = (50000-seller);
					}
				    else price = 50000;
				}

				static const f_str[] = ""W"Трансгендерный переход может включать в себя социализацию в новой гендерной роли,\n\
														медицинские процедуры по коррекции пола,\n\
														смену паспортного имени и юридического пола\n\
														"W"Стоимость хирургического вмешательства - "GREEN"$%d\n\n\
														"NO"Примечание: при смене пола будет изменен Ваш скин";
				new string[sizeof(f_str) +1 + (-2 + 5)];
				format(string,sizeof(string),f_str,price);
				D(playerid,D_MEDSEX,DSM,""P"Трансгендерный переход", string ,"Операция","Отмена");
			}
			case 9: {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
				new string[105];
				format(string,sizeof(string),""W"Вы хотите "ORANGE"%s"W" работу крупье?", (GetPVarInt(playerid,"krup")) ? ("закончить") : ("начать"));
				D(playerid,D_CASINO,DSM, ""P"Казино",string,"Да","Нет");
			}
			case 10,97:
			{
				D(playerid,D_FAQ,DSL, ""P"Помощь по игре",""W"1. О проекте\n2. Защита аккаунта\n3. С чего начать игру","Далее","Отмена");
			}
			case 11, 98..104: {
				if(PI[playerid][pLevel] > 2) return ErrorMessage(playerid,"Только для новичков (1-2 уровень)");
				if(GetPVarInt(playerid,"anti_eat") > unix) return ErrorMessage(playerid,"Брать еду можно раз в минуту");
				SetPlayerHealth(playerid, 100);
				GiveFullness(playerid, 30);
				MeAction(playerid,"перекусил(а)");
				ApplyAnimation(playerid,"FOOD","EAT_Burger", 2.0,0,0,0,0,5000,1);
				SetPVarInt(playerid, "anti_eat", unix+60);
				FreezePlayerForTime(playerid,2);

				//if(IsPlayerAttachedObjectSlotUsed(playerid,6)) RemovePlayerAttachedObject(playerid,6);
				//ApplyAnimation(playerid,"CARRY","putdwn",4.1,0,0,0,0,0);
				return 1;
			}
			case 12: {
				if(!PI[playerid][pSearch]) return ErrorMessage(playerid,"Вы не находитесь в розыске");
				static const f_str[] = ""W"Вы собираетесь сдаться с повинной\n\
										Это укоротит Ваш срок вдвое\n\
										Ваш уровень розыска: "P"%d\n\
										"W"Примерное время заключения: "P"%d сек\n\
										"W"При добровольной сдаче время заключения составит: "GREEN"%d сек\n\n\
										"YELLOW"Вы действительно хотите сдаться добровольно?";
				new string[sizeof(f_str) +1 + (-2 + 5) + (-2 + 4) + (-2 + 5)];
				format(string,sizeof(string),f_str,PI[playerid][pSearch],PI[playerid][pSearch]*600,PI[playerid][pSearch]*600/2);
				D(playerid,D_COP_ARREST,DSM, ""P"Сдача с повинной",string,"Да","Отмена");
			}
			case 13: {
				new bizz = TI[playerid][tSelectedBusinessID];
				switch(GetPlayerVirtualWorld(playerid)) {
					case 2..4: {
						if(PI[playerid][bizz_work] == bizz+1) {
							static const f_str[] = "Таксопарк {%s}%s";
							new string[sizeof(f_str) +1 + (-2 + 36)];
							format(string,sizeof(string),f_str,color_td[FuncBizz[bizz+1][funcbColor]][col_rgb],FuncBizz[bizz+1][funcbName]);
							D(playerid,D_BIZZ_TAXI_INFO,DSL,string,""ORANGE"1."W" Информация\n"ORANGE"2."W" Уволиться из таксопарка","Выбрать","Отмена");
						}
						else showstattaxi(playerid,bizz+1);
					}
					case 5..7: {
						if(PI[playerid][bizz_work] == bizz+1) {
							static const f_str[] = "Транспортная компания {%s}%s";
							new string[sizeof(f_str) +1 + (-2 + 36)];
							format(string,sizeof(string),f_str,color_td[FuncBizz[bizz+1][funcbColor]][col_rgb],FuncBizz[bizz+1][funcbName]);
							D(playerid,D_BIZZ_TK_INFO,DSL,string,""ORANGE"1."W" Информация\n"ORANGE"2."W" Узнать свой доход\n"ORANGE"3."W" Уволиться из транспортной компании","Выбрать","Отмена");
						}
						else showstattk(playerid,bizz+1);
					}
					case 8..10: {
						static const f_str[] = "\n\n"ORANGE"Название:\t\t"W"%s\n\
											"ORANGE"Владелец:\t\t"W"%s\n\
											"ORANGE"Гос. цена\t\t"W"%d\n\n\n\
											"ORANGE"Процент комиссии за переводы:\t\t\t"W"%.1f%\n\
											"ORANGE"Процент комиссии за оплату недвижимости:\t\t"W"%d\n\
											"ORANGE"Процент комиссии пользования банкоматами:\t"W"%d";
						new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + MAX_PLAYER_NAME) + (-2 + 8) + (-2 + 5) + (-2 + 4) + (-2 + 6) + (-2 + 6) + (-2 + 6) + (-2 + 6) + (-2 + 4) + (-2 + 4)];
						format(string,sizeof(string),f_str,FuncBizz[bizz+1][funcbName],gBusiness[bizz][bizzOwner],gBusiness[bizz][bizzSellPrice],
						FuncBizz[bizz+1][funcbPercent2],FuncBizz[bizz+1][funcbPercent],FuncBizz[bizz+1][funcbPercent3]);
						D(playerid,DIALOG_NONE,DSM, ""P"Банковское отделение",string,"Закрыть","");
					}
				}
			}
			case 14: {
				switch(GetPlayerVirtualWorld(playerid)) {
					case 49: if(PI[playerid][pLeader] != fLCN) return ErrorMessage(playerid,"Доступно лидеру организации");
					case 50: if(PI[playerid][pLeader] != fYAKUZA) return ErrorMessage(playerid,"Доступно лидеру организации");
					case 51: if(PI[playerid][pLeader] != fRM) return ErrorMessage(playerid,"Доступно лидеру организации");
				}
				new string[512],member = -1;
				switch(PI[playerid][pMember])
				{
				    case fLCN: member = 0;
				    case fYAKUZA: member = 1;
				    case fRM: member = 2;
				}
				if(member == -1) return ErrorMessage(playerid,"Временно недоступно");

				new year, month, day, hour, minute, second;

				strcat(string,"Рабочий №\tСтатус\tСрок найма\n");
				for(new i; i < 8; i ++) {
					if(!l_actor[member][i]) format(string,sizeof(string),"%sРабочий №%d\t"G"Не нанят\t--\n",string,i+1);
					else {
						timestamp_to_date(l_actort[member][i]-unix, year, month, day, hour, minute, second);
						format(string,sizeof(string), "%sРабочий №%d\t"NO"Нанят\t%dд %dч %dм\n",string,i+1,day-1,hour,minute);
					}
				}
				D(playerid,D_LAB,DSTH,""P"Найм работников",string,"Выбрать","Закрыть");
			}
			case 15: return D(playerid, D_GAME_DM, DSL, ""P"Сумасшедшие войны",""P"1."W" Регистрация на сумасшедшие войны\n"P"2."W" Информация о данном мероприятии", "Выбрать", "Закрыть");
			case 16: {
				if(PI[playerid][pLeader] != fWHITEHOUSE) return ErrorMessage(playerid,"Доступно только Президенту штата");
				D(playerid,D_ECONOMY,DSL,""P"Управление штатом","\
											"P"1."W" Информация\n\
											"P"2."W" Зарплата на оружейном заводе\n\
											"P"3."W" Зарплата на нефтезаводе\n\
											"P"4."W" Зарплата яблочный сад\n\
											"P"5."W" Зарплата в алькатрасе\n\
											"P"6."W" Зарплата лесопилка\n\
											"P"7."W" Зарплата грузчика\n\
											"P"8."W" Зарплата шахтёра\n\
											"P"9."W" Налогообложение бизнесов\n\
											"P"10."W" Налоги заработных плат гос.структур\n\
											"P"11."W" Заработные платы\n\
											"P"12."W" Переводы денежных средств организациям\n\
											"P"13."W" Управление пенсией\n\
											"P"14."W" Пополнить казну\n\
											"P"15."W" Снять деньги с казны","Выбрать","Отмена");
			}
			case 17: {
				if(!TI[playerid][tJobGun][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу "ORANGE"сборщик оружия?\n"W"Стоимость сборки 1 ящика - "GREEN"$%d\n"W"Примерное время работы - "P"25 сек\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[0]);
					D(playerid,D_JOB_GUNS,DSM, ""P"Сборщик оружия",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_GUNS,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
			}
			case 18: {
				if(!TI[playerid][tJobGun][0]) return 1;
				if(TI[playerid][tJobGun][1] != 1 || TI[playerid][tJobGun][2]) return 1;
				SendOk(playerid,"Вы взяли заготовку. Пройдите к свободному столу, для сборки оружия");
				new objectmodel = GunWorkWeapon[Random(0,6)];
				if(!IsPlayerAttachedObjectSlotUsed(playerid, 8)) SetPlayerAttachedObject(playerid,8,objectmodel,6);
				//SetPVarInt(playerid,"pgunmodel",objectmodel);
				TI[playerid][tJobGun][1] = 2;
			}
			case 19: {
				if(!TI[playerid][tJobOil][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу "ORANGE"нефтяника?\n"W"Стоимость переноса 1 бочки - "GREEN"$%d\n"W"Примерное время работы - "P"1мин 10 сек\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[1]);
					D(playerid,D_JOB_OIL,DSM, ""P"Нефте-Завод",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_OIL,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
			}
			case 20: {
				if(!TI[playerid][tJobSad][0]) return 1;
				if(GetPVarInt(playerid,"bailer_1") == 1) return ErrorMessage(playerid,"У Вас в руках лейка");
				if(GetPVarInt(playerid,"bailer_2") == 1 || GetPVarInt(playerid,"bailer_3") == 1) return ErrorMessage(playerid,"Вы уже взяли ящик");
				SetPlayerAttachedObject(playerid, 4, 19639, 5, 0.342999,-0.158999,0.041999, 0.000000,177.799957,-0.300001, 1.000000,0.520000,0.699000);
				SetPVarInt(playerid,"bailer_2",1);
			}
			case 21: {
				if(!TI[playerid][tJobSad][0]) return ErrorMessage(playerid,"Необходимо надеть рабочую форму");
				if(GetPVarInt(playerid,"bailer") == 1) return ErrorMessage(playerid,"Вы уже взяли лейку");
				SetPlayerAttachedObject(playerid, 7, 19621, 6, 0.068000, 0.040999, 0.001000, 0.000000, 0.000000, 94.299972, 1.000000, 1.000000, 1.000000); //
				SetPVarInt(playerid,"bailer",1);
			}
			case 22: {
				if(!TI[playerid][tJobSad][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу в "ORANGE"яблочневом саду?\n"W"Стоимость сбора яблок с 1 дерева - "GREEN"$%d/кг\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[3]);
					D(playerid,D_JOB_SAD,DSM, ""P"Яблочневый сад",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_SAD,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
			}
			case 23: {
				D(playerid,D_MAYOR,DSL,""P"Информация","\
											"P"1."W" Информация о налогах\n\
											"P"2."W" Пожертвовать деньги в казну\n\
											"P"3."W" Самые щедрые жители","Выбрать","Отмена");
			}
			case 24: {
				if(!IsACop(playerid) || !start_work[playerid]) return 1;
				ShowGetGun(playerid);
			}
			case 25: {
				if(GetTeamID(playerid) != fFBI || !start_work[playerid]) return 1;
				ShowGetGun(playerid);
			}
			case 26: {
				if(!IsAArm(playerid) || !start_work[playerid]) return 1;
				switch(GetPlayerVirtualWorld(playerid)) {
					case 30: if(FI[fARMYLV][fMats] < 100) return ErrorMessage(playerid,"Недостаточно боеприпасов");
					case 31: if(FI[fARMYSF][fMats] < 100) return ErrorMessage(playerid,"Недостаточно боеприпасов");
					case 35: if(zavodsklad < 100) return ErrorMessage(playerid,"Недостаточно боеприпасов");
				}
				if(GunTickGet[playerid][0] > unix) return ErrorMessage(playerid,"Нельзя брать оружие слишком часто");
				switch(GetPlayerVirtualWorld(playerid)) {
					case 30: FI[fARMYLV][fMats] -= 100,UpdateFraction(fARMYLV,"Mats",FI[fARMYLV][fMats]);
					case 31: FI[fARMYSF][fMats] -= 100,UpdateFraction(fARMYSF,"Mats",FI[fARMYSF][fMats]);
					case 35: zavodsklad -= 100;
				}
				GunTickGet[playerid][0] = unix+20;
				AC_GivePlayerWeapon(playerid,31,150);
				AC_GivePlayerWeapon(playerid,24,30);
				SetPlayerArmour(playerid, 100.0);
				SetPlayerHealth(playerid,100);
				SetFullness(playerid, 100);
				SendOk(playerid,"Вам выдано: M4(150пт), Deagle(30пт), бронежилет, сух.паек");
			}
			case 27: {
				new string[128];
				format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
				D(playerid,D_VEH_NUMBER,DSL,""P"Покупка гос. номера",string,"Выбрать","Закрыть");
			}
			case 28: {
				if(TI[playerid][tClothesWork][1] != 1) return 1;
				SendOk(playerid,"Вы взяли заготовку. Пройдите к свободному столу, для пошива одежды");
				ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,1,1,1,1,1);
				if(!IsPlayerAttachedObjectSlotUsed(playerid, 8)) SetPlayerAttachedObject(playerid, 8, 2384, 5,  0.100000, 0.100000, 0.200000,  100.000000, 170.0, 100.000000,  1.000000, 1.000000, 1.000000); // 155
				TI[playerid][tClothesWork][1] = 2;
			}
			case 29: {
				if(TI[playerid][tClothesWork][1] != 3) return 1;
				if(GetPVarInt(playerid,"pOff9") > gettime()) return 1;
				ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,1,1,0,0,1);
				SetPVarInt(playerid,"zp_clothes",GetPVarInt(playerid,"zp_clothes") + WorkSalary[2]);

				new string[24];
				format(string,sizeof(string),"MONEY:_%d",GetPVarInt(playerid,"zp_clothes"));
				PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);
				if(IsPlayerAttachedObjectSlotUsed(playerid, 8))RemovePlayerAttachedObject(playerid,8);
				TI[playerid][tClothesWork][1] = 1;
			}
			case 30..35, 86..87: {
				new vw = GetPlayerVirtualWorld(playerid);

				switch(pick)
				{
				    case 30:
				    {
				        switch(vw)
				        {
				            case 40: if(PI[playerid][pMember] != fLSPD) return ErrorMessage(playerid,"Вы не состоите в Полиции г. ЛС");
				            case 41: if(PI[playerid][pMember] != fSFPD) return ErrorMessage(playerid,"Вы не состоите в Полиции г. СФ");
				            case 42: if(PI[playerid][pMember] != fLVPD) return ErrorMessage(playerid,"Вы не состоите в Полиции г. ЛВ");
				        }
				    }
				    case 31: if(PI[playerid][pMember] != fFBI) return ErrorMessage(playerid,"Вы не состоите в ФБР");
				    case 32: {
						switch(vw)
						{
						    case 20: if(PI[playerid][pMember] != fMEDICLS) return ErrorMessage(playerid,"Вы не состоите в Больнице г. ЛС");
						    case 21: if(PI[playerid][pMember] != fMEDICSF) return ErrorMessage(playerid,"Вы не состоите в Больнице г. СФ");
						    case 22: if(PI[playerid][pMember] != fMEDICLV) return ErrorMessage(playerid,"Вы не состоите в Больнице г. ЛВ");
						}
				    }
				    case 33,86:
				    {
				        if(vw == 60 && PI[playerid][pMember] != fARMYLV) return ErrorMessage(playerid,"Вы не состоите в Армии г. ЛВ");
				        else if(vw == 59 && PI[playerid][pMember] != fARMYSF) return ErrorMessage(playerid,"Вы не состоите в Армии г. СФ");
				    }
				    case 34:
				    {
				        switch(vw)
				        {

				            case 10: if(PI[playerid][pMember] != fLSNEWS) return ErrorMessage(playerid,"Вы не состоите в Радиоцентре г. ЛС");
							case 11: if(PI[playerid][pMember] != fSFNEWS) return ErrorMessage(playerid,"Вы не состоите в Радиоцентре г. СФ");
							case 12: if(PI[playerid][pMember] != fLVNEWS) return ErrorMessage(playerid,"Вы не состоите в Радиоцентре г. ЛВ");
				        }
				    }
				    case 35: if(PI[playerid][pMember] != fWHITEHOUSE) return ErrorMessage(playerid,"Вы не состоите в Белом Доме");
				    case 87: if(PI[playerid][pMember] != fMAYOR) return ErrorMessage(playerid,"Вы не состоите в Мэрии");
				}
				new string[128];
				format(string,sizeof(string),"\n\n"W"Вы действительно хотите %s"W" рабочий день?\n\n",(!start_work[playerid]) ? (""ORANGE"начать") : (""ORANGE"закончить"));
				D(playerid,D_WORK,DSM, ""P"Раздевалка",string,"Да","Нет");
			}
			case 36: return D(playerid,D_FAMILY_CREATE_2,DSL, ""P"Семьи",""P"1."W" ТОП Семей\n"P"2."W" Создание семьи","Выбрать","Отмена");
			case 37: {
				return ErrorMessage(playerid,"Скоро будет обновление");
				/*static const f_str[] = ""W"%s "NO"VS"W" %s\n\
										"W"%s "NO"VS"W" %s\n\
										"W"%s "NO"VS"W" %s\n\
										"W"%s "NO"VS"W" %s\n\
										"W"%s "NO"VS"W" %s\n";
				new string[512];
				new name[25];
				if(RingInfo[0][rgPlayer][0] == -1) name = "None";
				else name = player_name[RingInfo[0][rgPlayer][0]];
				new name1[25];
				if(RingInfo[0][rgPlayer][1] == -1) name1 = "None";
				else name1 = player_name[RingInfo[0][rgPlayer][1]];

				new name2[25];
				if(RingInfo[1][rgPlayer][0] == -1) name2 = "None";
				else name2 = player_name[RingInfo[1][rgPlayer][0]];
				new name3[25];
				if(RingInfo[1][rgPlayer][1] == -1) name3 = "None";
				else name3 = player_name[RingInfo[1][rgPlayer][1]];

				new name4[25];
				if(RingInfo[2][rgPlayer][0] == -1) name4 = "None";
				else name4 = player_name[RingInfo[2][rgPlayer][0]];
				new name5[25];
				if(RingInfo[2][rgPlayer][1] == -1) name5 = "None";
				else name5 = player_name[RingInfo[2][rgPlayer][1]];

				new name6[25];
				if(RingInfo[3][rgPlayer][0] == -1) name6 = "None";
				else name6 = player_name[RingInfo[3][rgPlayer][0]];
				new name7[25];
				if(RingInfo[3][rgPlayer][1] == -1) name7 = "None";
				else name7 = player_name[RingInfo[3][rgPlayer][1]];

				new name8[25];
				if(RingInfo[4][rgPlayer][0] == -1) name8 = "None";
				else name8 = player_name[RingInfo[4][rgPlayer][0]];
				new name9[25];
				if(RingInfo[4][rgPlayer][1] == -1) name9 = "None";
				else name9 = player_name[RingInfo[4][rgPlayer][1]];

				format(string,sizeof(string),f_str,name,name1,name2,name3,name4,name5, name6,name7,name8,name9);
				return D(playerid,DIALOG_NONE,DSM, ""P"Информация",string,"Скрыть","");*/
			}
			case 38: {
				if(PI[playerid][pMember] != fWHITEHOUSE || !start_work[playerid]) return 1;
				if(PI[playerid][pRank] < 3) return ErrorMessage(playerid,"Доступно только начиная от охранника (с 3 ранга)");
				if(GunTickGet[playerid][0] > unix) return ErrorMessage(playerid,"Нельзя брать оружие слишком часто");
				GunTickGet[playerid][0] = unix+20;
				AC_GivePlayerWeapon(playerid,24,30);
				SetPlayerArmour(playerid, 100.0);
				SetPlayerHealth(playerid,100);
				SetFullness(playerid, 100);
				SendOk(playerid,"Вам выдано: Deagle(30пт), бронежилет, сух.паек");
			}
			case 39: {
				if(!TI[playerid][tJobWood][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу "ORANGE"лесоруба?\n"W"Стоимость спила 1 дерева - "GREEN"$%d\n"W"Примерное время работы - "P"30 сек\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[4]);
					D(playerid,D_JOB_WOOD,DSM, ""P"Лесопилка",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_WOOD,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
			}
			case 40: return D(playerid, D_GAME_GOLOD, DSL, ""P"Голодные игры",""P"1."W" Регистрация на голодные игры\n"P"2."W" Информация о данном мероприятии", "Выбрать", "Закрыть");
			case 41: {
				if(PI[playerid][pMember] != fFBI || !start_work[playerid]) return ErrorMessage(playerid, "Вы не агент FBI");
				if(TI[playerid][tMasked]) {
					A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
					SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
					TI[playerid][tMasked] = 0;
					return 1;
				}
				if(PI[playerid][pRank] < 3) return ErrorMessage(playerid, "Доступно с должности Агент FBI");
				new string[34 * MAX_FRACTIONS + 1];
				for(new i = 1;i < MAX_FRACTIONS;i ++) {
					if(i == fFBI) continue;
					format(string,sizeof(string),"%s%s\n", string, FI[i][fName]);
				}
				D(playerid, D_SPY, DSL, ""P"Выберите фракцию", string, "Выбрать", "Закрыть");
			}
			case 42..46: {
				switch(pick) {
					case 42: if(PI[playerid][pMember] != fBALLAS) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 43: if(PI[playerid][pMember] != fVAGOS) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 44: if(PI[playerid][pMember] != fGROVE) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 45: if(PI[playerid][pMember] != fAZTEC) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 46: if(PI[playerid][pMember] != fRIFA) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
				}
				new gunamount = GetPVarInt(playerid,"carrygun")*500;
				if(gunamount) {
					DeletePVar(playerid,"carrygun");
					RemovePlayerAttachedObject(playerid,1);
					ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
					if(FI[GetTeamID(playerid)][fMats] + gunamount > 300000) return ErrorMessage(playerid,"На складе недостаточно места");
					else FI[GetTeamID(playerid)][fMats] += gunamount;
					UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
					return 1;
				}
				else if(IsAGang(playerid)) return D(playerid,D_BAND_STOCK,DSL,""P"Склад",""P"1."W" Положить деньги в банк банды\n"P"2."W" Снять деньги с банка банды\n"P"3."W" Положить боеприпасы на склад\n"P"4."W" Взять боеприпасы со склада\n"P"5."W" Положить наркотики на склад\n"P"6."W" Взять наркотики со склада\n"P"7."W" Взять оружие\n"P"8."W" Заказать наркотики", "Выбрать", "Закрыть");
			}
			case 47: {
				switch(GetPlayerVirtualWorld(playerid)) {
					case 49: if(PI[playerid][pMember] != fLCN) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 50: if(PI[playerid][pMember] != fYAKUZA) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
					case 51: if(PI[playerid][pMember] != fRM) return ErrorMessage(playerid,"У Вас нет доступа к этому складу");
				}
				new gunamount = GetPVarInt(playerid,"carrygun")*500;
				if(gunamount) {
					DeletePVar(playerid,"carrygun");
					RemovePlayerAttachedObject(playerid,1);
					ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
					if(FI[GetTeamID(playerid)][fMats] + gunamount > 300000) return ErrorMessage(playerid,"На складе недостаточно места");
					else FI[GetTeamID(playerid)][fMats] += gunamount;
					UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
					return 1;
				}
				if(IsAMafia(playerid)) return D(playerid,D_MAFIA_STOCK,DSL,""P"Склад",""P"1."W" Положить деньги в банк мафии\n"P"2."W" Снять деньги с банка мафии\n"P"3."W" Положить боеприпасы на склад\n"P"4."W" Взять боеприпасы со склада\n"P"5."W" Положить наркотики на склад\n"P"6."W" Взять наркотики со склада", "Выбрать", "Закрыть");
			}
			case 48,49: return bank_dialog(playerid);
			case 50: return D(playerid,D_BANK_OPLATA,DSL,""P"Оплата недвижимости",""P"1."W" Дом\n"P"2."W" Бизнес\n"P"3."W" Отель\n"P"4."W" Аэропорт","Выбрать","Отмена");
			case 51: return GetTickets(playerid);
			case 52..55: {
				new houseid = TI[playerid][tSelectHouse];
				SetPlayerPosAC(playerid,hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][0],hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][1],hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][2],houseid+1,hinterior_info[gHouses[houseid][houseHint]][h_interior]);
				SetPlayerFacingAngle(playerid,hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][3]);
				SetCameraBehindPlayer(playerid);
				TI[playerid][tInHouse] = true;
			}
			case 56: {
				new id = TI[playerid][tSelectedBusinessID];
				switch(GetPlayerVirtualWorld(playerid)) {
					case 1: D(playerid,D_AUTOSALON,DSL,""P"Автосалон","2 этаж\nВыход","Перейти","Отмена");
					case 2: D(playerid,D_AUTOSALON,DSL,""P"Автосалон","1 этаж\nВыход","Перейти","Отмена");
					case 3: D(playerid,D_AUTOSALON,DSL,""P"Автосалон","2 этаж\nВыход","Перейти","Отмена");
					case 4: D(playerid,D_AUTOSALON,DSL,""P"Автосалон","1 этаж\nВыход","Перейти","Отмена");
					case 5..6: {
						TI[playerid][tTPpick] = true;
						SetPlayerPosAC(playerid,gBusiness[id][bizzX],gBusiness[id][bizzY],gBusiness[id][bizzZ],0,0);
						SetPlayerFacingAngle(playerid,gBusiness[id][bizzR]);
						SetCameraBehindPlayer(playerid);
					}
				}
			}
			case 57: return D(playerid, D_GAME_RACE, DSL, ""P"Гонки",""P"1."W" Регистрация на гонки\n"P"2."W" Информация о данном мероприятии", "Выбрать", "Закрыть");
			case 58: {
				SetPlayerPosAC(playerid,1680.2532,693.7829,589.5544,GetPVarInt(playerid, "selectedhotel"),101);
				SetPlayerFacingAngle(playerid,179.9865);
				SetCameraBehindPlayer(playerid);
				OnPlayerUpdateLoadingMode(playerid);
			}
			case 59: {
				SetPlayerPosAC(playerid,1405.0586,-28.2474,1000.8589,GetPVarInt(playerid, "selectedhotel"),79);
				SetPlayerFacingAngle(playerid,2.6381);
				SetCameraBehindPlayer(playerid);
				OnPlayerUpdateLoadingMode(playerid);
			}
			case 60..64: {
				switch(pick) {
					case 60: if(PI[playerid][pMember] != fBALLAS) return ErrorMessage(playerid,"У Вас нет доступа к этой аптечки");
					case 61: if(PI[playerid][pMember] != fVAGOS) return ErrorMessage(playerid,"У Вас нет доступа к этой аптечки");
					case 62: if(PI[playerid][pMember] != fGROVE) return ErrorMessage(playerid,"У Вас нет доступа к этой аптечки");
					case 63: if(PI[playerid][pMember] != fAZTEC) return ErrorMessage(playerid,"У Вас нет доступа к этой аптечки");
					case 64: if(PI[playerid][pMember] != fRIFA) return ErrorMessage(playerid,"У Вас нет доступа к этой аптечки");
				}
				if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
				if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
					new str[128];
					format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
					ErrorMessage(playerid,str);
					return 1;
				}
				if(!FI[GetTeamID(playerid)][fHealth]) return ErrorMessage(playerid,"На складе недостаточно аптечек");
				if(GetPVarInt(playerid, "gang_heal") > gettime()) return ErrorMessage(playerid,"Брать аптечку можно один раз в 15 секунд");
				new Float:health;
				GetPlayerHealth(playerid,health);
				if(health >= 160) return ErrorMessage(playerid,"Вы здоровы");
				if(health + 60.0 < 160.0 ) health += 60.0;
				else health = 160.0;
				SetPlayerHealth(playerid,health);
				MeAction(playerid,"использовал(а) аптечку");
				SetPlayerChatBubble(playerid,"+60 HP",COLOR_YELLOW,20.0,10000);
				ApplyAnimation(playerid,"ped","gum_eat",4.0,0,0,0,0,0,1);
				FI[GetTeamID(playerid)][fHealth] --;
				UpdateFraction(GetTeamID(playerid),"Health",FI[GetTeamID(playerid)][fHealth]);
				SetPVarInt(playerid, "gang_heal", gettime()+15);

				static const f_str[] = "[F] %s[%d] использовал аптечку";
				new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4)];

	         	format(string,sizeof(string),f_str,player_name[playerid],playerid);
				SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
				return 1;
			}
			case 65, 66,67,68: {
				if(!TI[playerid][tTir]) return ErrorMessage(playerid,"У Вас нету пропуска в тир");
				if(!GetPVarInt(playerid, "ShootingStart")) {
					return D(playerid, D_AMMOSG, DSM, ""P"Тир",""W" Вы действительно хотите начать тренировку?", "Да", "Нет");
				}
				else return D(playerid, D_AMMOSG, DSM, ""P"Тир",""W" Вы действительно хотите закончить тренировку?", "Да", "Нет");
			}
			case 69: {}
			case 70: {}
			case 71: {}
			case 72: {}
			case 73: {}
			case 74: {}
			case 75: {}
			case 76: {}
			case 77..81: {
				if(!IsAGang(playerid)) return ErrorMessage(playerid,"Вы не бандит");
				ghetto_info(playerid);
			}
			case 82,83: {
				if(!TI[playerid][tJobWood][1]) return 1;
		        ClearAnimations(playerid);
		        RemovePlayerAttachedObject(playerid,9);
		        DisablePlayerCheckpoint(playerid);
		        TI[playerid][tJobWood][1] = 0;
		        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		        SetPlayerAttachedObject(playerid,8,341,6);
		        if(pick == 82) {
		        	new obj = CreateDynamicObject(1463,-539.6312, -1584.1210, 10.3435, 0.00000, 0.00000, 0.00000);
			        SetGVarInt("WoodConv",1,obj);
			        MoveDynamicObject(obj,-539.6312, -1581.4810, 10.3435,1,0.00000, 0.00000, 0.00000);
		        }
		        else if(pick == 83) {
		        	new obj = CreateDynamicObject(1463,-531.6816, -1584.0610, 10.3435,   0.00000, 0.00000, 0.00000);
			        SetGVarInt("WoodConv",1,obj);
			        MoveDynamicObject(obj,-531.6816, -1581.4810, 10.3435,1,0.00000, 0.00000, 00.00000);
		        }
		        TI[playerid][tJobWood][3] = 1;
				TI[playerid][tJobSalary] += WorkSalary[4];
				new string[24];
				format(string,sizeof(string),"MONEY:_%d",TI[playerid][tJobSalary]);
				PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);

				if(QuestProgress[playerid][8] < 10 && AcceptQuest[playerid][8] != 0) QuestProgress[playerid][8] ++,save_quest(playerid,8);
				if(QuestProgress[playerid][8] == 10 && AcceptQuest[playerid][8] != 0) {
					D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно спилили и перенесли 10 ед древесины. Данное задание можно завершить и забрать за него награду","Закрыть","");
					NextStapQI(playerid,8);
				}
		    }
		    case 84:
		    {
				if(!TI[playerid][tJobLoader][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу "ORANGE"грузчика?\n"W"Стоимость 1 перенесенного ящика - "GREEN"$%d\n"W"Примерное время работы - "P"25 сек\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[5]); // Сделать динамическую ЗП
					D(playerid,D_JOB_LOADER,DSM, ""P"Грузчик",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_LOADER,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
		    }
			case 85:
			{
				switch(TI[playerid][tAutoSchool])
				{
				    case 1:
					{
						if(GetPVarInt(playerid,"use_test") == 1) return 1;
						if(GetPVarInt(playerid,"pWaitingExam") == 1) return ErrorMessage(playerid,"Вы уже сдали теоретическую часть");
						static const f_str[] = ""W"Добро пожаловать в автошколу!\n\n\
							Для получения доступа к практическому экзамену,\n\
							Вам необходимо ответить "P"ВЕРНО"W" на 5 теоретических вопросов.\n\
							Стоимость прохождения теста составит - "ORANGE"$%d\n\n\
							"W"Вы хотите приступить к решению теста?";
						new string[sizeof(f_str) +1 + (-2 + 5)];
						format(string,sizeof(string),f_str,500);
						D(playerid,D_AUTOSCHOOL_1,DSM, ""P"Сдача экзамена",string,"Да","Отмена");
						SetPVarInt(playerid,"use_test", 1);
						DeletePVar(playerid,"error_test");
						DeletePVar(playerid,"pTestQNumber");
						TestASKMassive[playerid] = { 0, 1, 2, 3 , 4, 5, 6};
						RandomMassive(TestASKMassive[playerid], 7);
				    }
				    case 2..3: D(playerid,D_AUTOSCHOOL_3,DSM, ""P"Экзамен","\n\n"W"Вы действительно хотите приступить к экзамену?\n\n","Да","Отмена");
					default: {
						ErrorMessage(playerid, "Подойдите к стойке покупки лицензий");
						EnableGPSForPlayer(playerid, 728.1974,-1371.6168,1.4270);
					}
				}
			}
			case 88:
			{
				if(PI[playerid][pMember] != fMAYOR || !start_work[playerid]) return 1;
				// if(PI[playerid][pRank] != 2 && PI[playerid][pRank] != 5) return ErrorMessage(playerid,"Доступно только охранникам");
				if(GunTickGet[playerid][0] > unix) return ErrorMessage(playerid,"Нельзя брать оружие слишком часто");
				GunTickGet[playerid][0] = unix+20;
				AC_GivePlayerWeapon(playerid,3,1);
				AC_GivePlayerWeapon(playerid,29,30);
				SetPlayerArmour(playerid, 100.0);
				SetPlayerHealth(playerid,100);
				SetFullness(playerid, 100);
				SendOk(playerid,"Вам выдано: MP5(30 пт.), дубинка, бронежилет");
			}
			case 89..90, 93..94:
			{
			    switch(pick)
			    {
				    case 89: SetPlayerPosAC(playerid,280.4901,1823.4368,17.6709,0,0);
				    case 90: SetPlayerPosAC(playerid,289.9789,1824.4294,17.6509,0,0);
					case 93: SetPlayerPosAC(playerid,135.3344,1948.7473,19.3771,0,0);
					case 94: SetPlayerPosAC(playerid,134.9621,1933.0717,19.2444,0,0);
				}
			}
			/*
			case 99..102: // Аренда скутеров
			{
			    if(PI[playerid][pLevel] > 3) return ErrorMessage(playerid, "Данный транспорт доступен только для новичков (до 4 лвл)");
			    if(TI[playerid][tArendaCar] != -1) return ErrorMessage(playerid, "Вы уже арендуете транспорт");
				D(playerid, D_RENT_SPAWN_LS, DSM, ""P"Аренда скутера", "\n\n"G"Вы хотите арендовать скутер "GREEN"бесплатно?\n\n", "Арендовать", "Отмена");
			}
			*/
			case 105:
		    {
				if(!TI[playerid][tJobMine][0]) {
					static const f_str[] = "\n\n"W"Вы действительно хотите начать работу "ORANGE"шахтера?\n"W"Стоимость 1 кг руды - "GREEN"$%d\n"W"Примерное время работы - "P"25 сек\n\n";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,WorkSalary[6]); // Сделать динамическую ЗП
					D(playerid,D_JOB_MINE,DSM, ""P"Шахтер",string,"Да","Нет");
				}
				else {
					static const f_str[] = "\n\n"W"Вы хотите закончить работу и забрать "GREEN"$%d?\n\n";
					new string[sizeof(f_str) +1 + (-2 + 7)];
					format(string,sizeof(string),f_str,TI[playerid][tJobSalary]);
					D(playerid,D_JOB_MINE,DSM, ""P"Завершение работы",string,"Да","Нет");
				}
		    }
			case 106: {
				return D(playerid, D_NEWS_LIFT, DSL, ""P"Лифт", ""W"На улицу\nКрыша", "Выбрать", "Отмена");
			}
		}
	}
	else if(areaid >= gHouseArea[0] && areaid <= gHouseArea[gHouseCount-1] && pstate == PLAYER_STATE_ONFOOT) {
		if(TI[playerid][tTPpick]) {
			TI[playerid][tTPpick] = false;
			return 1;
		}
		new houseid = areaid - gHouseArea[0];
		if(houseid == -1) return true;
		TI[playerid][tSelectHouse] = houseid;
		//TI[playerid][tTPpick] = true;
		new classname[20], mes2[200];
		switch(gHouses[houseid][houseClass]) {
			case 0:classname = "Эконом";
			case 1:classname = "Cредний";
			case 2:classname = "Элитный";
			case 3:classname = "Особняк";
			default: classname = "Неизвестно";
		}
		if(!gHouses[houseid][houseOwner]) {
			format(mes2,sizeof(mes2),""W"Цена: "ORANGE"$%d\n\
									"W"Класс: "P"%s\n\
									"W"Номер дома: "P"№%d",
									gHouses[houseid][housePrice],
									classname,
									gHouses[houseid][houseID]);
			D(playerid,D_HOUSE,DSM, ""P"Дом",mes2,"Купить","Отмена");
		}
		else {
			format(mes2,sizeof(mes2),""W"Владелец: "ORANGE"%s\n\
									"W"Дом: "P"№%d\n\
									"W"Класс: "P"%s",
									gHouses[houseid][houseOwner],
									gHouses[houseid][houseID],
									classname);
			D(playerid,D_HOUSE,DSM, ""P"Дом",mes2,"Войти","Отмена");
		}
	}
	else if(areaid >= gHotelArea[0] && areaid <= gHotelArea[HOTEL_COUNT-1] && pstate == PLAYER_STATE_ONFOOT) {
		if(TI[playerid][tTPpick]) {
			TI[playerid][tTPpick] = false;
			return 1;
		}
		new otelid=areaid - gHotelArea[0];
		if(otelid == -1) return true;
		SetPVarInt(playerid,"selectedhotel",otelid);
		if(!gHotels[otelid][hotelOwnerID]) {
			new string[128];
			format(string,sizeof(string),""W"Данный отель продается за "GREEN"$%d",gHotels[otelid][hotelPrice]);
			D(playerid,D_HOTEL_BUY,DSM, ""P"Отель",string,"Купить","Войти");
		}
		else {
			TI[playerid][tTPpick] = true;
			SetPlayerPosAC(playerid,1405.3140,-15.8006,1000.9132,otelid,79);
			SetPlayerFacingAngle(playerid,90.1475);
			SetCameraBehindPlayer(playerid);
			gHotels[otelid][hotelVisitors]++;
			UpdateHotelData(otelid+1,"visitors",gHotels[otelid][hotelVisitors]);
			OnPlayerUpdateLoadingMode(playerid);
		}
	}
	else if(areaid >= gAirArea[0] && areaid <= gAirArea[AIR_COUNT-1] && pstate == PLAYER_STATE_ONFOOT) {
		if(TI[playerid][tTPpick]) {
			TI[playerid][tTPpick] = false;
			return 1;
		}
		new airs=areaid - gAirArea[0];
		if(airs == -1) return true;
		SetPVarInt(playerid,"selectedair",airs);
		if(!gAirs[airs][airOwnerID]) {
			new string[128];
			format(string,sizeof(string),""W"Данный аэропорт продается за "GREEN"$%d",gAirs[airs][airPrice]);
			D(playerid,D_AIRPORT_BUY,DSM, ""P"Аэропорт",string,"Купить","Отмена");
			return 1;
		}
		if(GetString(player_name[playerid],gAirs[airs][airOwner])) D(playerid,D_AIRPORT,DSL,""P"Аэропорт",""P"1."W" Баланс аэропорта\n"P"2."W" Снять деньги\n"P"3."W" Статистика аэропорта\n"P"4."W" Установить цену за аренду\n"P"5."NO" Продать аэропорт","Выбрать","Отмена");
	}
    else if(areaid >= b_area[0] && areaid <= b_area[gBusinessCount - 1] && pstate == PLAYER_STATE_ONFOOT) {
  		if(TI[playerid][tTPpick]) {
			TI[playerid][tTPpick] = false;
			return 1;
		}
		new businessid = areaid - b_area[0];
		new mes2[128];
		if(businessid < 0) return SendClientMessage(playerid,COLOR_GREY,"Ошибка (#100)");
		if(!gBusiness[businessid][bizzStatus]) return true;
		TI[playerid][tSelectedBusinessID] = businessid;
		if((!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] != 7) && (!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] != 11) && (!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] != 14) && (!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] != 15)) {
			format(mes2,sizeof(mes2),""W"Данный бизнес продается за "GREEN"$%d",gBusiness[businessid][bizzSellPrice]);
			return D(playerid,D_BIZZ_BUY,DSM, ""P"Бизнес",mes2,"Купить","Войти");
		}
		else {
			if(gBusiness[businessid][bizzType] == 8) {
				if(IsPlayerInRangeOfPoint(playerid,5.0, 545.7042,-1293.4833,17.2422)) SetPVarInt(playerid,"sellcarClass",1);
				if(IsPlayerInRangeOfPoint(playerid,5.0, -1965.6605,293.9383,35.4688)) SetPVarInt(playerid,"sellcarClass",3);
				if(IsPlayerInRangeOfPoint(playerid,5.0, 2200.8638,1394.8074,11.0625)) SetPVarInt(playerid,"sellcarClass",5);
				if(IsPlayerInRangeOfPoint(playerid,5.0, 2131.8152,-1151.3242,24.0600)) SetPVarInt(playerid,"sellcarClass",6);
				return D(playerid,dBuyCarSalon,DSM, ""P"Автосалон","\n\n"W"Вы хотите посмотреть список машин?\n\n","Да","Нет");
			}
			else {
				if(gBusiness[businessid][bizzEnter] && gBusiness[businessid][bizzOwnerID] != PI[playerid][pID]) {
					new string[128];
					format(string,sizeof(string),""W"Стоимость входа "GREEN"$%d",gBusiness[businessid][bizzEnter]);
					D(playerid,D_BIZZ_ENTERS,DSM, ""P"Бизнес",string,"Войти","Отмена");
					return 1;
				}
				new bint = gBusiness[businessid][bizzBint]-1;
				if(bint < 0 || bint >= BINT_COUNT) return 1;
				TI[playerid][tTPpick] = true;
				SetPlayerPosAC(playerid,gBints[bint][bintX],gBints[bint][bintY],gBints[bint][bintZ],businessid+1,gBints[bint][bintInterior]);
				SetPlayerFacingAngle(playerid,gBints[bint][bintR]);
				FreezePlayerForTime(playerid,3);
				gBusiness[businessid][bizzVisitors]++;
				SetCameraBehindPlayer(playerid);
				if(gBusiness[businessid][bizzType] == 10 || gBusiness[businessid][bizzType] == 11 || gBusiness[businessid][bizzType] == 14 || gBusiness[businessid][bizzType] == 15) OnPlayerUpdateLoadingMode(playerid);
			}
		}
	}
	else if(areaid >= car_pickup[0] && areaid <= car_pickup[78-1]) {
		new carid = areaid - car_pickup[0];
		new model = autosaloncar[carid][autoCars];
		new modelid = model - 400;
		new classname[10];
		switch(autosaloncar[carid][autoClass]) {
			case 0: strcat(classname,"эконом");
			case 1: strcat(classname,"стандарт");
			case 2: strcat(classname,"спорт");
			case 3: strcat(classname,"мото");
		}
		SetPVarInt(playerid,"car_number",modelid);

		new price;
		if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
			new seller = floatround(gTransport[modelid][trPrice]/100*vip_status[PI[playerid][pVips]][vip_buycar]);
			price = gTransport[modelid][trPrice]-seller;
		}
		else {
			if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
				new seller = floatround(gTransport[modelid][trPrice]/100*BonusInfo[act_buycar]);
				price = gTransport[modelid][trPrice]-seller;
			}
			else if(BonusInfo[act_select] == 2) {
				new seller = floatround(gTransport[modelid][trPrice]/100*BonusInfo[act_buycar]);
				price = gTransport[modelid][trPrice]-seller;
			}
		    else price = gTransport[modelid][trPrice];
		}

		new string[256];
		format(string,sizeof(string),""W"Название автомобиля: "P"%s "W"[%s класс]\n\n\
										"W"Цена автомобиля: "GREEN"$%d\n\
										"W"Вместимость бензобака: "O"%d\n\
										"W"Расход топлива на 100 КМ: "O"%d",gTransport[modelid][trName],
										classname,price,gTransport[modelid][trTank],gTransport[modelid][trConsumption]);
		D(playerid,D_BUY_CAR,DSM, ""P"Информация",string,"Купить","Отмена");
		return 1;
	}
	else if(areaid >= gBintEnterArea[0] && areaid <= gBintEnterArea[BINT_COUNT-1]) {
  		if(TI[playerid][tTPpick]) {
			TI[playerid][tTPpick] = false;
			return 1;
		}
		new id = TI[playerid][tSelectedBusinessID];
		if(id < 0) return true;
		if(id == 75 && TI[playerid][tGym]) return ErrorMessage(playerid,"Необходимо закончить тренировку");
		new vw, int;
		switch(id) {
			case 7: vw = 46,int = 78;
			case 8: vw = 47,int = 78;
			case 9: vw = 48,int = 78;
			default: vw = 0,int = 0;
		}
		TI[playerid][tTPpick] = true;
		SetPlayerPosAC(playerid,gBusiness[id][bizzX],gBusiness[id][bizzY],gBusiness[id][bizzZ],vw,int);
		SetPlayerFacingAngle(playerid,gBusiness[id][bizzR]);
		SetCameraBehindPlayer(playerid);
		if(gBusiness[id][bizzType] == 15) OnPlayerUpdateLoadingMode(playerid);
	}
	else if(areaid >= gBintBuyArea[0] && areaid <= gBintBuyArea[BINT_COUNT-1]) {
		new id = TI[playerid][tSelectedBusinessID];
		if(id < 0) return true;
		new products = gBusiness[id][bizzProduct];
		new type = gBusiness[id][bizzType];
		switch(type) {
			case 1: { if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось"); show_tavern(playerid,id);} // закусочная
			case 2:	{ if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось"); show_24(playerid,id); }
			case 3..4: {
 				if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
			    new string[128];
				format(string,sizeof(string),"Наименование\tСтоимость\nПиво \t$%d\nВодка \t$%d\nШампанское \t$%d\nВино \t$%d\nТекила \t$%d\nКоньяк \t$%d", gBusiness[id][bizzPrice] * 10 * gBarCosts[0],gBusiness[id][bizzPrice] * 10 * gBarCosts[1],gBusiness[id][bizzPrice] * 10 * gBarCosts[2],gBusiness[id][bizzPrice] * 10 * gBarCosts[3],gBusiness[id][bizzPrice] * 10 * gBarCosts[4],gBusiness[id][bizzPrice] * 10 * gBarCosts[5]);
				D(playerid, D_BIZZ_BAR, DSTH, "Меню", string, "Купить", "Отмена");
			}
			case 5: {
		  		if(TI[playerid][tTPpick]) {
					TI[playerid][tTPpick] = false;
					return 1;
				}
				else {
  					if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
					if(GetPVarInt(playerid,"ChangingSkin") == 0) {
						SetPVarInt(playerid,"ChangingSkin",1);
						new Float: pos[4];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						GetPlayerFacingAngle(playerid, pos[3]);
						SetPVarFloat(playerid, "posx", pos[0]);
						SetPVarFloat(playerid, "posy", pos[1]);
						SetPVarFloat(playerid, "posz", pos[2]);
						SetPVarFloat(playerid, "posa", pos[3]);
						SetPVarInt(playerid, "interior", GetPlayerInterior(playerid));
						SetPVarInt(playerid, "vw", GetPlayerVirtualWorld(playerid));
						TogglePlayerControllable(playerid, 0);
						SetPlayerPosAC(playerid, 258.7497, -41.3828, 1002.0234,playerid + 1,14);
						SetPlayerFacingAngle(playerid, 70.0);
						SetPlayerCameraPos(playerid, 258.7498 + (2.5 * floatsin(-70.0, degrees)), -41.3828 + (2.5 * floatcos(-70.0, degrees)), 1002.5);
						SetPlayerCameraLookAt(playerid, 258.7497, -41.3828, 1002.0234);
					}
					for(new i = 0; i < 20; i++) SendClientMessage(playerid, -1, "\n");
					SCM(playerid, CGOLD, "Используйте "W"/next для просмотра следующего и "W"/prev для предыдущего");
		 			SCM(playerid, CGOLD, "Используйте "W"/buy для покупки и "W"/cancel для отмены.");
					SetPVarInt(playerid, "curskin", GetPlayerSkin(playerid));
					switch(PI[playerid][pSex]) {
						case 1: SetPVarInt(playerid,"join_ped_item",0);
						case 2: SetPVarInt(playerid,"join_ped_item",71);
					}
					A_SetPlayerSkin(playerid,ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][0]);

					for(new i=0; i<9; i++) {
						TextDrawShowForPlayer(playerid,buy_skins[i]);
					}
					PlayerTextDrawShow(playerid,buy_player_skins[playerid]);

					new price;
					if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
						new seller = floatround(ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]/100*vip_status[PI[playerid][pVips]][vip_chose]);
						price = (ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]-seller);
					}
					else {
   						if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
				    	if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
							new seller = floatround(ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]/100*BonusInfo[act_buyskin]);
							price = (ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]-seller);
						}
						else if(BonusInfo[act_select] == 2) {
							new seller = floatround(ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]/100*BonusInfo[act_buyskin]);
							price = (ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1]-seller);
						}
					    else price = ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1];
					}

					new string[12];
					format(string,sizeof(string),"$%d",price);
					PlayerTextDrawSetString(playerid,buy_player_skins[playerid],string);

					SelectTextDraw(playerid, 0x0080FFFF);
				}
			}
			case 6: {
 				if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
				if(!lic[playerid][3]) return ErrorMessage(playerid,"У Вас нет лицензии на оружие");
				new gun_name[32 + 1],string[512];
				for(new i = 0; i < 12; i++) {
					GetWeaponName(gSellGun[i],gun_name,32);
					format(string, 1500, "%s%s\t$%i\n",string, gun_name, gSellGunPrice[i] * gBusiness[id][bizzPrice]);
				}
				//
				new str[90];
				format(str, sizeof(str), "Armour\t$%i\nПропуск в тир\t$%i", gSellGunPrice[12] * gBusiness[id][bizzPrice], gSellGunPrice[13] * gBusiness[id][bizzPrice]);
				strcat(string, str);
				D(playerid, D_AMMO, DST, "Меню аммо", string, "Далее", "Отмена");
			}
			case 7: return true;//авиа
			case 9: { if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось"); show_fish(playerid); }
			case 10: {
 				if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
				static const fmt_str[] = "\
					"W"Билет [30 мин]\t"GREEN"$%d\n\
					"W"Билет [1 час]\t"GREEN"$%d\n\
					"W"Билет [2 часа]\t"GREEN"$%d\n\
					"W"Билет [3 часа]\t"GREEN"$%d";

			    new string[sizeof(fmt_str) + 5 * 4 + 1 * 4 + (-2 * 4 + 4 * 4)];

				format(string, sizeof(string), fmt_str, gBusiness[id][bizzPrice] * gCompCosts[0],gBusiness[id][bizzPrice] * gCompCosts[1],gBusiness[id][bizzPrice] * gCompCosts[2],gBusiness[id][bizzPrice] * gCompCosts[3]);
				D(playerid, D_BIZZ_COMP, DST, "Меню", string, "Купить", "Отмена");
			}
			case 11,14,15: {
				new businessid = TI[playerid][tSelectedBusinessID];
				if(!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] == 11) {
					new string[65];
					format(string,sizeof(string),"\n\n"W"Этот таксопарк продается за "GREEN"$%d\n\n",gBusiness[businessid][bizzSellPrice]);
					return D(playerid,D_BIZZ_UPDATE,DSM, ""P"Таксопарк",string,"Купить","Отмена");
				}
				else if(!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] == 14) {
					new string[70];
					format(string,sizeof(string),"\n\n"W"Эта транспортная компания продается за "GREEN"$%d\n\n",gBusiness[businessid][bizzSellPrice]);
					return D(playerid,D_BIZZ_UPDATE,DSM, ""P"Транспортная компания",string,"Купить","Отмена");
				}
				else if(!gBusiness[businessid][bizzOwnerID] && gBusiness[businessid][bizzType] == 15) {
					new string[70];
					format(string,sizeof(string),"\n\n"W"Это банковское отделение продается за "GREEN"$%d\n\n",gBusiness[businessid][bizzSellPrice]);
					return D(playerid,D_BIZZ_UPDATE,DSM, ""P"Банковское отделение",string,"Купить","Отмена");
				}
				else {
					switch(businessid) {
						case 1..3: {
							if(PI[playerid][pBusiness]-1 == businessid) {
								return D(playerid, D_BIZZ_TAXI, DSL, ""P"Меню таксопарка", ""P"1."W" Информация\n"P"2."W" Управление кассой\n"P"3."W" Управление автомобилями\n"P"4."W" Управление цветом\n"P"5."W" Управление цветом шашки\n"P"6."W" Управление названием таксопарка\n"P"7."W" Управление текстом на автомобилях\n"P"8."W" Изменение тарифов\n"P"9."W" Изменение процента от прибыли\n"P"10."W" Покупка номера телефона\n"P"11."W" Сотрудники\n"P"12."W" Статистика\n"P"13."W" Продать таксопарк", "Выбрать", "Отмена");
							}
							else if(PI[playerid][bizz_work]-1 == businessid && PI[playerid][bizz_status] == 5) {
								return D(playerid, D_BIZZ_TAXI_ZAM, DSL, ""P"Меню таксопарка", ""P"1."W" Информация\n"P"2."W" Сотрудники\n"P"3."W" Статистика", "Выбрать", "Отмена");
							}
							else return ErrorMessage(playerid,"Управление таксопарком доступно только руководителю бизнеса и управляющему");
						}
						case 4..6: {
							if(PI[playerid][pBusiness]-1 == businessid) {
								return D(playerid, D_BIZZ_TK, DSL, ""P"Меню транспортной компании", ""P"1."W" Информация\n"P"2."W" Управление кассой\n"P"3."W" Управление автомобилями\n"P"4."W" Управление цветом\n"P"5."W" Управление названием транспортной компании\n"P"6."W" Изменение процента от прибыли\n"P"7."W" Сотрудники\n"P"8."W" Статистика\n"P"9."W" Продать транспортную компанию", "Выбрать", "Отмена");
							}
							else if(PI[playerid][bizz_work]-1 == businessid && PI[playerid][bizz_status] == 2) {
								return D(playerid, D_BIZZ_TK_ZAM, DSL, ""P"Меню транспортной компании", ""P"1."W" Информация\n"P"2."W" Сотрудники\n"P"3."W" Статистика", "Выбрать", "Отмена");
							}
							else return ErrorMessage(playerid,"Управление транспортной компанией доступно только руководителю бизнеса и управляющему");
						}
						case 7..9: {
							if(PI[playerid][pBusiness]-1 == businessid) {
								return D(playerid, D_BIZZ_BO, DSL, ""P"Меню банковского отделения", ""P"1."W" Информация\n"P"2."W" Управление кассой\n"P"3."W" Управление цветом\n"P"4."W" Управление названием банковского отделения\n"P"5."W" Изменение комиссии переводов\n"P"6."W" Изменение комиссии за оплату недвижимости\n"P"7."W" Изменение комиссии за пользование банкоматами\n"P"8."W" Управление банкоматами\n"P"9."W" Статистика\n"P"10."W" Продать банковское отделение", "Выбрать", "Отмена");
							}
							/*else if(PI[playerid][bizz_work]-1 == businessid && PI[playerid][bizz_status] == 2) {
								return D(playerid, D_BIZZ_BO_ZAM, DSL, "Меню банковского отделения", ""P"1."W" Информация\n"P"2."W" Сотрудники\n"P"3."W" Статистика", "Выбрать", "Отмена");
							}*/
							else return ErrorMessage(playerid,"Управление банковским отделением доступно только руководителю бизнеса и управляющему");
						}
					}
				}
				return 1;
			}
			case 12: D(playerid, D_RIELTOR, DSL, ""P"Риэлторское агенство", ""P"1."W" Дома\n"P"2."W" Бизнесы", "Выбрать", "Отмена");
			case 13: {
 				if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
				if(TI[playerid][tGym]) {
					static const f_str[] = ""P"Наименование\t"P"Стоимость\n"P"1."W" Спортивная форма\t"ORANGE"$%d\n"P"2."W" Стиль боя Бокс\t"ORANGE"$5000\n"P"3."W" Стиль боя Кунг-Фу\t"ORANGE"$5000\n"P"4."W" Стиль боя Кик-Бокс\t"ORANGE"$5000\n"P"5."W" Шейкер Smart [0.25л/250ударов]\t"ORANGE"$200\n"P"6."W" Шейкер BSN [0.5л/500ударов]\t"ORANGE"$350\n"P"7."W" Шейкер Biotech [0.75л/750ударов]\t"ORANGE"$500\n"P"-"W" Информация\n"P"-"W" Закончить тренировку";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,gBusiness[id][bizzPrice]*150);
					D(playerid,D_BOX_2,DSTH, "Спортзал",string,"Выбрать","Отмена");
				}
				else {
					static const f_str[] = ""P"Наименование\t"P"Стоимость\n"P"1."W" Спортивная форма\t"ORANGE"$%d\n"P"2."W" Стиль боя Бокс\t"ORANGE"$5000\n"P"3."W" Стиль боя Кунг-Фу\t"ORANGE"$5000\n"P"4."W" Стиль боя Кик-Бокс\t"ORANGE"$5000\n"P"5."W" Шейкер Smart [0.25л/250ударов]\t"ORANGE"$200\n"P"6."W" Шейкер BSN [0.5л/500ударов]\t"ORANGE"$350\n"P"7."W" Шейкер Biotech [0.75л/750ударов]\t"ORANGE"$500\n"P"-"W" Информация";
					new string[sizeof(f_str) +1 + (-2 + 6)];
					format(string,sizeof(string),f_str,gBusiness[id][bizzPrice]*150);
					D(playerid,D_BOX_2,DSTH, "Спортзал",string,"Выбрать","Отмена");
				}
			}
			case 17: {//sanek228
				if(TI[playerid][tTPpick]) {
					TI[playerid][tTPpick] = false;
					return 1;
				}
				if(!GetPVarInt(playerid,"buy_accses")) {
  					if(!products) return ErrorMessage(playerid,"К сожалению, товара не осталось");
					SetPVarInt(playerid,"buy_accses",1);
					new Float: pos[4];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					GetPlayerFacingAngle(playerid, pos[3]);
					SetPVarFloat(playerid, "posx", pos[0]);
					SetPVarFloat(playerid, "posy", pos[1]);
					SetPVarFloat(playerid, "posz", pos[2]);
					SetPVarFloat(playerid, "posa", pos[3]);
					TogglePlayerControllable(playerid, 0);
					SetPlayerPosAC(playerid, 212.5107,-41.5253,1002.0234,playerid + 1,1);
					SetPlayerFacingAngle(playerid, 89.8527);
					SetPlayerCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234);
					SetPlayerCameraLookAt(playerid, 212.5107,-41.5253,1002.0234);
					buyacces(playerid);
				}
			}
		}// ПК ТРАНСПОРТ
	}
	else if(areaid == gAreas[arZavod] && TI[playerid][tJobGun][0] && TI[playerid][tJobGun][2] && pstate == PLAYER_STATE_ONFOOT) {
	    if(GetPVarInt(playerid,"pOff9") > gettime()) return ErrorMessage(playerid,"Подождите");
		ApplyAnimation(playerid,"CARRY","putdwn",4.0,0,1,1,0,0,1);
		TI[playerid][tJobSalary] += WorkSalary[0];

        RemovePlayerMapIcon(playerid, 20);

		if(QuestProgress[playerid][3] < 10 && AcceptQuest[playerid][3] != 0) QuestProgress[playerid][3] ++,save_quest(playerid,3);
		if(QuestProgress[playerid][3] == 10 && AcceptQuest[playerid][3] != 0) {
			D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно собрали 10 ед оружия. Данное задание можно завершить и забрать за него награду","Закрыть","");
			NextStapQI(playerid,3);
		}

		new string[24];
		format(string,sizeof(string),"MONEY:_%d",TI[playerid][tJobSalary]);
		PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);

		zavodsklad += 500;
		if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
		TI[playerid][tJobGun][2] = 0;
		SetPVarInt(playerid,"pOff9",gettime()+20);
		TI[playerid][tJobGun][1] = 1;

		new store_text[44];
        format(store_text,sizeof(store_text),"Боеприпасов на складе: "ORANGE"%d",zavodsklad);
		UpdateDynamic3DTextLabelText(gun_3dtext[0],-1,store_text);
	}
 	else if(areaid == gAreas[arZavodSklad] && IsAGang(playerid) || areaid == gAreas[arArmyLVSklad] && IsAGang(playerid) || areaid == gAreas[arArmyLVSklad] && IsAMafia(playerid) || areaid == gAreas[arArmyLVSklad] && GetTeamID(playerid) == fARMYLV && pstate == PLAYER_STATE_ONFOOT) {
		SendOk(playerid,"Нажмите "ORANGE"'ALT'"G" чтобы взять боеприпасы со склада");
	}
	else if(areaid == gAreas[arArmySFSklad] && IsAGang(playerid) || areaid == gAreas[arArmySFSklad] && IsAMafia(playerid) && pstate == PLAYER_STATE_ONFOOT) {
		SendOk(playerid,"Нажмите "ORANGE"'ALT'"G" чтобы взять боеприпасы со склада");
	}
	else if(areaid == gAreas[arArmySFSklad]) {
		if(GetTeamID(playerid) == fARMYSF) {
			new gunamount = GetPVarInt(playerid,"carrygun")*500;
			if(gunamount) {
				DeletePVar(playerid,"carrygun");
				RemovePlayerAttachedObject(playerid,1);
				ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
				if(FI[fARMYSF][fMats] + gunamount > 1000000) return ErrorMessage(playerid,"На складе недостаточно места");
				else FI[fARMYSF][fMats] += gunamount;
			}
		}
	}
	else if((areaid == gAreas[arOil][0] || areaid == gAreas[arOil][1]) && TI[playerid][tJobOil][0] && !TI[playerid][tJobOil][1] && pstate == PLAYER_STATE_ONFOOT) {
		ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
		SetPlayerAttachedObject(playerid, 8 , 3632, 1, 0.051999,0.418000,-0.008999, -85.699913,94.600028,-5.600045, 0.701999,0.684000,0.805999);
		SetTimerEx("CarryDelay",1000,false,"i",playerid);
		RemovePlayerMapIcon(playerid, 2);
		SetPlayerMapIcon(playerid,1,281.5784,1446.3842,10.6189,11,-1,MAPICON_GLOBAL);
		SetPlayerCheckpoint(playerid, 281.5784,1446.3842,10.6189, 4.0);
		TI[playerid][tJobOil][1] = true;
	}
	else if(areaid == gAreas[arOil][2] && TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1] && pstate == PLAYER_STATE_ONFOOT) {
		if(GetPVarInt(playerid,"pOff9") > gettime()) return 1;
		TI[playerid][tJobOil][1] = false;
		if(IsPlayerAttachedObjectSlotUsed(playerid, 8)) RemovePlayerAttachedObject(playerid,8);
		ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
		TI[playerid][tJobSalary] += WorkSalary[1];

		if(QuestProgress[playerid][7] < 10 && AcceptQuest[playerid][7] != 0) QuestProgress[playerid][7] ++,save_quest(playerid,7);
		if(QuestProgress[playerid][7] == 10 && AcceptQuest[playerid][7] != 0) {
			D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно перенесли 10 бочек с нефтью. Данное задание можно завершить и забрать за него награду","Закрыть","");
			NextStapQI(playerid,7);
		}
		new string[24];
		format(string,sizeof(string),"MONEY:_%d",TI[playerid][tJobSalary]);
		PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);

		DisablePlayerCheckpoint(playerid);
		SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
		SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);
		if(PI[playerid][pProgress] <= 150) PI[playerid][pProgress]++;
		oilsklad ++;
		SetPVarInt(playerid,"pOff9",gettime()+51);

		new store_text[38];
        format(store_text,sizeof(store_text),"Бочек на складе: "ORANGE"%d",oilsklad);
		UpdateDynamic3DTextLabelText(oil_3dtext,-1,store_text);



	}
	else if((areaid == gAreas[arOil][3] || areaid == gAreas[arOil][4]) && TI[playerid][tJobOil][0] && !TI[playerid][tJobOil][1] && VehicleInfo[GetPlayerVehicleID(playerid)][vJob] == 50) {
		object_oil[playerid] = CreateDynamicObject(3633, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
		AttachDynamicObjectToVehicle(object_oil[playerid], GetPlayerVehicleID(playerid), 0.000, 0.670, 0.400, 0.000, 0.000, 0.000);
		RemovePlayerMapIcon(playerid, 1),RemovePlayerMapIcon(playerid, 2);
		SetPlayerMapIcon(playerid,1,274.2075,1447.0771,10.6189,11,-1,MAPICON_GLOBAL);
		TI[playerid][tJobOil][1] = true;
	}
	else if(areaid == gAreas[arOil][5] && TI[playerid][tJobOil][0] && TI[playerid][tJobOil][1] && VehicleInfo[GetPlayerVehicleID(playerid)][vJob] == 50) {
		if(GetPVarInt(playerid,"pOff9") > gettime()) return 1;
		SetPVarInt(playerid,"pOff9",gettime()+40);
		TI[playerid][tJobOil][1] = false;
		DestroyDynamicObject(object_oil[playerid]);
		RemovePlayerMapIcon(playerid, 1);//удаляем склад
		SetPlayerMapIcon(playerid,1,525.7095,1470.6411,4.0315,11,-1,MAPICON_GLOBAL);
		SetPlayerMapIcon(playerid,2,481.0192,1308.8954,9.3572,11,-1,MAPICON_GLOBAL);
		TI[playerid][tJobSalary] += floatround(WorkSalary[1]*1.5);

		new string[24];
		format(string,sizeof(string),"MONEY:_%d",TI[playerid][tJobSalary]);
		PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);
		oilsklad += 3;
	}
	else if(areaid >= sad_area[0] && areaid <= sad_area[119-1] && pstate == PLAYER_STATE_ONFOOT) {

		if(!TI[playerid][tJobSad][0]) return 1;
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) return 1;
		new id = areaid - sad_area[0];
		if(SI[id][sad_temp] != 0 && !GetString(SI[id][sad_fermer],player_name[playerid])) return ErrorMessage(playerid,"Вы не ухаживаете за этим деревом");
		if(SI[id][sad_temp] == 0 || SI[id][sad_temp] == 4) {
			if(SI[id][sad_temp] == 0) {
				if(GetPVarInt(playerid,"sad_uxod") == 1) return ErrorMessage(playerid,"Вы уже ухаживаете за деревом");
				if(!GetPVarInt(playerid,"bailer")) return ErrorMessage(playerid,"У Вас нет лейки в руках");
				if(GetPVarInt(playerid,"bailer_3")) return ErrorMessage(playerid,"Вы не можете полить дерево с ящиком яблок в руках");

				JobTempProcess[playerid] = 1;
				SI[id][sad_temp] = 1;
				SetString(SI[id][sad_fermer],player_name[playerid]);
				new string[33 + MAX_PLAYER_NAME];
				format(string,sizeof(string),"Яблоня\nСтадия: сохнет\nФермер: %s",SI[id][sad_fermer]);
				UpdateDynamic3DTextLabelText(SI[id][sad_3dtext],-1,string);

			}
			if(SI[id][sad_temp] == 4 && GetString(SI[id][sad_fermer],player_name[playerid])) {
				if(!GetPVarInt(playerid,"bailer_2")) return ErrorMessage(playerid,"У Вас нет ящика для сбора яблок в руках");
				JobTempProcess[playerid] = 2;
				if(SI[id][sad_temp] == 4) {
					if(GetPVarInt(playerid,"bailer_4")) return 1;
					SetPVarInt(playerid,"bailer_4",1);
				}
			}
			TI[playerid][tJobSad][1] = id+1;
			TI[playerid][tProcess][0] = 0;
			TI[playerid][tProcess][1] = 10;
			StartJobProcess(playerid);

		}
	}
	else if(areaid == gAreas[arLoadProds][0]) {
		if(PI[playerid][pJob] != 3) return 1;
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 456) {
			D(playerid,dProdGet,DSI, ""P"Покупка продуктов","\n\n"W"Введите количество продуктов для покупки:\nПримечание: "ORANGE"1"W" продукт = "GREEN"$1\n\n","Купить","Отмена");
		}
	}
	else if(areaid == gAreas[arLoadProds][1]) {
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609) {
			D(playerid,dProdGet,DSI, ""P"Покупка топлива","\n\n"W"Введите количество литров для покупки:\nПримечание: "ORANGE"1"W" литр = "GREEN"$1\n\n","Купить","Отмена");
		}
	}
	else if(areaid == theftarea[playerid][0]) { //угон
	   	DisablePlayerCheckpoint(playerid);
  		DestroyDynamicArea(areaid);
	   	if(theftCheck[playerid][1] == 1){
			new Float:vehx, Float:vehy, Float:vehz;
			GetVehiclePos(theftIDveh[playerid][0], vehx, vehy, vehz);
			if(!PlayerToPoint(5.0,playerid,vehx, vehy, vehz)){
				GetCoordDoorVehicle(theftIDveh[playerid][0], vehx, vehy, vehz);
				theftCheck[playerid][0] = CreateDynamicCP(vehx,vehy,vehz, 1.0,0,0,playerid);
			}
			else {

			}
		}
		else if(theftCheck[playerid][1] == 4){
			new houseid = PI[theftIDveh[playerid][1]][pHouse]-1;
			theftCheck[playerid][0] = CreateDynamicCP(gHouses[houseid][houseX], gHouses[houseid][houseY], gHouses[houseid][houseZ], 1.0,0,0,playerid);
		}
 		else {
			switch(theftarea[playerid][1]){
				case 0: theftCheck[playerid][0] = CreateDynamicCP(2415.5767,-2467.5305,13.6250, 2.0,0,0,playerid);
				case 1: theftCheck[playerid][0] = CreateDynamicCP(951.9211,2070.2153,10.8203, 2.0,0,0,playerid);
				case 2: theftCheck[playerid][0] = CreateDynamicCP(-2117.7361,-249.2475,35.3203, 2.0,0,0,playerid);
			}
		}
	}
	else if(areaid == gAreas[arSad] && pstate == PLAYER_STATE_ONFOOT) {
		if(!TI[playerid][tJobSad][0]) return 1;
		if(!GetPVarInt(playerid,"bailer_3")) return ErrorMessage(playerid,"Вы не собрали урожай");
		if(IsPlayerAttachedObjectSlotUsed(playerid, 4)) RemovePlayerAttachedObject(playerid,4);
		ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
		DeletePVar(playerid,"bailer_3");
		TI[playerid][tJobSalary] += TI[playerid][tJobSad][2]*WorkSalary[3];
		TI[playerid][tJobSad][2] = 0;
		new string[24];
		format(string,sizeof(string),"MONEY:_%d",TI[playerid][tJobSalary]);
		PlayerTextDrawSetString(playerid,work_td_local[playerid][0],string);
	}
	else if(areaid >= gAreas[arClothes][0] && areaid <= gAreas[arClothes][8] && TI[playerid][tClothesWork][0]) {
		if(TI[playerid][tClothesWork][1] != 2) return ErrorMessage(playerid,"Необходимо взять заготовку");
		new id;
		for(new i ;i < 9;i++) {
			if(gAreas[arClothes][i] == areaid) id = i;
		}
		SetPVarInt(playerid,"clothes_id",id);

		JobTempProcess[playerid] = 4;
		TI[playerid][tProcess][0] = 0;
		TI[playerid][tProcess][1] = 10;
		StartJobProcess(playerid);
		// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
		// for(new YN = 0;YN < 3;YN++) {
		// 	TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
		// 	if(YN < 2) PlayerTextDrawShow(playerid,YandNsysTDPlayer[playerid][YN]);
		// }
		// RandomYareNforJOBS(playerid);
	}
	else if(areaid == gAreas[arPobeg][0]) {
		D(playerid,DIALOG_NONE,DSM, ""P"Побег",""W"Мысли...\n\nТак, с этого поганого места я выбрался..\nНадо где-то найти лодку, чтобы покинуть этот чёртов остров..\nДа еще и времени мало..\nПоторопиться бы...","Закрыть","");
		SetPlayerPosAC(playerid,-2255.0234,1785.5853,36.6691,0,0);
		SetPlayerFacingAngle(playerid,121.4531);
		SetCameraBehindPlayer(playerid);
		FreezePlayerForTime(playerid,3);
	}
	else if(areaid == gAreas[arPobeg][1] && TI[playerid][tAlcotraz][0] > 0) {
		D(playerid,DIALOG_NONE,DSM, ""P"Побег",""W"Мысли...\n\nУРА!! СВОБОДА!!!","Закрыть","");
		SetVehicleToRespawn(GetPlayerVehicleID(playerid));
		if(PI[playerid][pMember] && start_work[playerid]) {
			A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
			SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
		}
		else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
		PI[playerid][pSearch] = 0;
		ANDROID_SetPlayerWantedLevel(playerid,PI[playerid][pSearch]);
		PI[playerid][pJail] = 0;
		UpdatePlayerData(playerid,"pJail",0);
		PI[playerid][pJailTime] = 0;
		UpdatePlayerData(playerid,"pJailTime",0);
		TI[playerid][tAlcotraz][0] = 0;
	}
	else if(areaid >= gAreas[arManiken][0] && areaid <= gAreas[arManiken][17] && TI[playerid][tAlcotraz][2] && TI[playerid][tAlcotraz][1]) {
		new id;
		for(new i ;i < 18;i++) {
			if(gAreas[arManiken][i] == areaid) id = i;
		}
		maniken[playerid] = CreateDynamicObject(3092,alcatraz_maniken[id][0],alcatraz_maniken[id][1],alcatraz_maniken[id][2],90.00,-90.00,90.00);
		TI[playerid][tAlcotraz][1] = 0;
	}
	else if(areaid >= gAreas[arGripp][0] && areaid <= gAreas[arGripp][2]) {
		if(PI[playerid][pDisease][0] || PI[playerid][pDDisease] || GetPlayerVirtualWorld(playerid) != 0) return 1;
		if(TI[playerid][tDMArea][0] || TI[playerid][tGunArea][0]) return 1;
		new rand = random(9);
		if(rand > 3) return 1;
		if(areaid == gAreas[arGripp][0] && disease == 0) return send_disease(playerid);
		else if(areaid == gAreas[arGripp][1] && disease == 1) return send_disease(playerid);
		else if(areaid == gAreas[arGripp][2] && disease == 2) return send_disease(playerid);
	}
	else if(areaid == gAreas[arPerfomans][0] || areaid == gAreas[arPerfomans][1]) {
		if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
		if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
		D(playerid, D_TUNE_LIST, DSL, ""P"Perfomance Tune", ""P"1."W" Улучшение двигателя\n"P"2."W" Улучшение тормозов", "Далее", "Закрыть");
	}
	else if(WD::[0][woodZone] <= areaid <= WD::[MAX_WOODS - 1][woodZone] && pstate == PLAYER_STATE_ONFOOT) {
	    new j = areaid - WD::[0][woodZone];
		if(TI[playerid][tJobWood][1]) return 1;
	    if(TI[playerid][tJobWood][0]) {
			if(TI[playerid][tJobWood][3]) {
				if(WD::[j][woodUse] != false) return ErrorMessage(playerid,"Дерево уже кто-то пилит");
				TI[playerid][tJobWood][2] = j;
				WD::[j][woodUse] = true;
				JobTempProcess[playerid] = 5;
				TI[playerid][tProcess][0] = 0;
				TI[playerid][tProcess][1] = 10;
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
	else if(areaid == RobPlayer[playerid][RobArea]) {
		if(RobPlayer[playerid][AttachObj]) return 1;
		ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
		switch(random(14)) {
			case 0: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2317, 4, 0.1169, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV5"
			case 1: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 1518, 4, 0.0829, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV4"
			case 2: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2648, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV3"
			case 3: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2318, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV2"
			case 4: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2320, 4, 0.1299, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV1"
			case 5: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 19921, 4, 0.3669, -0.5089, 0.0979, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "yashik"
			case 6: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 1738, 4, 0.1219, -0.4249, 0.0419, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "truba"
			case 7: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2124, 4, 0.1580, -0.4499, 0.0710, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul2"
			case 8: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2120, 4, 0.2660, -0.3600, 0.1139, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul"
			case 9: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2102, 4, 0.3619, -0.3669, 0.1609, -64.8999, -120.6999, -72.7999, 0.9789, 0.9900, 1.0000, 0, 0); // "muzlo"
			case 10: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2421, 4, 0.2540, -0.1539, 0.3339, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "Mikrov"
			case 11: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 1727, 4, 0.5619, -0.2700, -0.1969, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "kreslo"
			case 12: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 19614, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "huyznaetcheeto"
			case 13: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 2226, 4, 0.3699, -0.3359, 0.1049, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "bumbox"
			case 14: RobPlayer[playerid][AttachObj] = SetPlayerAttachedObject(playerid, 0, 11743, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "blender"
		}
		RobPlayer[playerid][RobRand]--;
		new string[65];
		format(string,sizeof(string),"Доступно техники: "O"%iед",RobPlayer[playerid][RobRand]);
		UpdateDynamic3DTextLabelText(RobPlayer[playerid][RobText], COLOR_WHITE, string);
		if(RobPlayer[playerid][RobRand] == 0) {
			DestroyDynamicPickup(RobPlayer[playerid][RobPickup]);
			DestroyDynamicArea(RobPlayer[playerid][RobArea]);
			DestroyDynamic3DTextLabel(RobPlayer[playerid][RobText]);
		}
	}
	if(IsAGang(playerid) || IsAArm(playerid) || IsAMafia(playerid)) {
		for(new i = GetVehiclePoolSize()+1; --i != 0;) {
			if(areaid == VG[i][vgArea]) {
				if(VG[i][vgLoading] == true && GetPVarInt(playerid,"carrygun")) {
					new gunamount = GetPVarInt(playerid,"carrygun");
					DeletePVar(playerid,"carrygun");
					RemovePlayerAttachedObject(playerid,1);
					ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
					switch(GetVehicleModel(i)) {
						case 433: if(VG[i][vgAmount][0] + gunamount > 70) return ErrorMessage(playerid,"Недостаточно места"),FI[fARMYLV][fMats] += 500;
						case 482: if(VG[i][vgAmount][0] + gunamount > 30) return ErrorMessage(playerid,"Недостаточно места"),FI[fARMYLV][fMats] += 500;
						case 573: if(VG[i][vgAmount][0] + gunamount > 200) return ErrorMessage(playerid,"Недостаточно места");
					}
					if(gunamount) VG[i][vgAmount][0] += gunamount;

					new string[64];
					switch(GetVehicleModel(i)) {
						case 433: format(string,sizeof(string),"Ящиков: "O"%i/40",VG[i][vgAmount][0]);
						case 482: format(string,sizeof(string),"Ящиков: "O"%i/30",VG[i][vgAmount][0]);
						case 573: format(string,sizeof(string),"Ящиков: "O"%i/200",VG[i][vgAmount][0]);
					}
					UpdateDynamic3DTextLabelText(VG[i][vgText],COLOR_WHITE,string);
				}
				else if(VG[i][vgUnloading] == true && !GetPVarInt(playerid,"carrygun")) {
					if(VG[i][vgAmount][0] < 1) return ErrorMessage(playerid,"В автомобиле недостаточно боеприпасов");
					VG[i][vgAmount][0] -= 1;
					SetPVarInt(playerid,"carrygun",1);
					new string[64];
					switch(GetVehicleModel(i)) {
						case 433: format(string,sizeof(string),"Ящиков: "O"%i/40",VG[i][vgAmount][0]);
						case 482: format(string,sizeof(string),"Ящиков: "O"%i/30",VG[i][vgAmount][0]);
					}
					UpdateDynamic3DTextLabelText(VG[i][vgText],COLOR_WHITE,string);

					ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
					SetTimerEx("CarryDelay",1000,false,"i",playerid);
					SetPlayerAttachedObject(playerid,1,2358,6,0.0,0.10,-0.2, -110.0,0.0,78.0);
				}
				else if(VG[i][vgRobHouse] == true && RobPlayer[playerid][AttachObj]) {
					new gunamount = RobPlayer[playerid][AttachObj];
					RemovePlayerAttachedObject(playerid,1);
					ApplyAnimation(playerid,"CARRY","putdwn",1.0,0,1,1,0,0,1);
					if(gunamount) VG[i][vgAmount][0] += gunamount;
					RobPlayer[playerid][AttachObj] = 0;
					RemovePlayerAttachedObject(playerid, 0);
					ClearAnims(playerid);
					new string[64];
					format(string,sizeof(string),"Техника: "O"%i ед",VG[i][vgAmount][0]);
					UpdateDynamic3DTextLabelText(VG[i][vgText],COLOR_WHITE,string);
				}
				return true;
			}
		}
		if(areaid == invent_area && invent_zone_id != -1) {
			if(invent_mats < 5000) return ErrorMessage(playerid, "На корабле недостаточно боеприпасов");
			if(!GetPVarInt(playerid,"carrygun")) {
				invent_mats -= 5000;
				SetPlayerFacingAngle(playerid,270.0);
				ClearAnimations(playerid);
				ApplyAnimation(playerid,"CARRY","liftup",1.0,0,1,1,0,0,1);
				SetTimerEx("CarryDelay",1000,false,"i",playerid);
				SetPlayerAttachedObject(playerid,1,2358,6,0.0,0.10,-0.2, -110.0,0.0,78.0);
				SetPVarInt(playerid,"carrygun",1);
			}
		}
	}
	new state_ship = GetPlayerState(playerid);
	new state_vehicle = GetPlayerVehicleID(playerid);
	foreach(new x:Player) {
		if(!TI[x][tLogin] || AntiCheatIsKickedWithDecync(x)) continue;
		if(areaid == GetPVarInt(x,"Ships") && state_ship == PLAYER_STATE_DRIVER) {
			new panels, tires;
			GetVehicleDamageStatus(state_vehicle, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(state_vehicle, panels, doors, lights, 15);
			GameTextForPlayer(playerid, "~r~stalling", 1000, 6);
			break;
		}
	}
	for(new c = 0; c < MAX_TABLES_DICE; c++) {
		if(areaid==InfoDice[c][dice_area]) GameTextForPlayer(playerid,"~n~~n~~n~~n~~n~~n~~n~~n~~n~~g~PRESS ALT",3000,3);
	}
	return true;
}

public OnPlayerLeaveDynamicArea(playerid, areaid) {
	if(GetPVarInt(playerid, "showGreenZoneTD")) {
		SetPVarInt(playerid, "showGreenZoneTD", 0);
		for (new i; i < 5; i++) TextDrawHideForPlayer(playerid, greenZoneTD[i]); 

	}
	if(areaid >= gHouseArea[0] && areaid <= gHouseArea[gHouseCount]) {
		TI[playerid][tSelectHouse] = 0;
	}
	else if(areaid >= b_area[0] && areaid <= b_area[gBusinessCount - 1]) {
		if(TI[playerid][tTPpick] == false) TI[playerid][tSelectedBusinessID] = -1;
	}
	else if(areaid >= sad_area[0] && areaid <= sad_area[119-1]) {
		if(!TI[playerid][tJobSad][0] || !TI[playerid][tJobSad][1]) return 1;
		new field = TI[playerid][tJobSad][1]-1;
		if(SI[field][sad_temp] == 1) {
			UpdateDynamic3DTextLabelText(SI[field][sad_3dtext],-1,"Дерево\nСтадия - сохнет\nФермер - Отсутствует");
			SI[field][sad_temp] = 0;
		}
		TI[playerid][tJobSad][1] = 0;
		DeletePVar(playerid,"bailer_4");
		TI[playerid][tProcess][0] = -1;
		TI[playerid][tProcess][1] = -1;
		JobTempProcess[playerid] = 0;
		// for(new YN = 0;YN < 3;YN++) {
		// 	TextDrawHideForPlayer(playerid, YandNsysTD[YN]);
		// 	if(YN < 2) PlayerTextDrawDestroy(playerid,YandNsysTDPlayer[playerid][YN]);
		// }
	}
	if(areaid >= gAreas[arClothes][0] && areaid <= gAreas[arClothes][8] && TI[playerid][tClothesWork][0]) {
		TI[playerid][tProcess][0] = -1;
		TI[playerid][tProcess][1] = -1;
		if(GetPVarInt(playerid,"id_object")) {
			DestroyDynamicObject(GetPVarInt(playerid,"id_object"));
			DeletePVar(playerid,"id_object");
		}
		// for(new YN = 0;YN < 3;YN++) {
		// 	TextDrawHideForPlayer(playerid, YandNsysTD[YN]);
		// 	if(YN < 2) PlayerTextDrawDestroy(playerid,YandNsysTDPlayer[playerid][YN]);
		// }
		JobTempProcess[playerid] = 0;
	}
	else if(Casino_Flag[playerid][select_casino_table] != -1) {
		if(!InfoDice[Casino_Flag[playerid][select_casino_table]][dice_game_start]) {
			ShowCasino_TD(playerid, Casino_Flag[playerid][select_casino_table]);
			Casino_Flag[playerid][select_casino_table] = -1;
		}
	}
	else if(areaid >= gAreas[arNews][0] && areaid <= gAreas[arNews][1] && TI[playerid][tEther]) {
		ether_closed(playerid);
		TI[playerid][tEther] = false;
		SendOk(playerid,"Вы вышли из прямого эфира");
	}
	else if(WD::[0][woodZone] <= areaid <= WD::[MAX_WOODS - 1][woodZone]) {
		if(TI[playerid][tJobWood][2] != -1) {
			WD::[TI[playerid][tJobWood][2]][woodUse] = false;
			TI[playerid][tProcess][0] = -1;
			TI[playerid][tProcess][1] = -1;
			// for(new YN = 0;YN < 3;YN++) {
			// 	TextDrawHideForPlayer(playerid, YandNsysTD[YN]);
			// 	if(YN < 2) PlayerTextDrawDestroy(playerid,YandNsysTDPlayer[playerid][YN]);
			// }
			JobTempProcess[playerid] = 0;
			if(TI[playerid][tJobWood][1]) TogglePlayerControllable(playerid,true);
			TI[playerid][tJobWood][2] = -1;
		}
	}
	else if(areaid >= area_golod[0] && areaid <= area_golod[20]) {
		if(time_gamegolod && player_to_golod[playerid]) {
			new Float:POS[3];
		    GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
		    CreateExplosionForPlayer(playerid, POS[0], POS[1], POS[2], 7, 5.0);
		}
	}
	else if(areaid >= gAreas[arJob][0] && areaid <= gAreas[arJob][5]) {
		if(TI[playerid][tJobOil][0]) EndOil(playerid);
		//if(TI[playerid][tJobSad][0]) EndSad(playerid);
		if(TI[playerid][tJobGun][0]) EndGun(playerid);
		if(GetPVarInt(playerid,"fish_place")) 
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				switch(random(2))
				{
					case 0: SetVehiclePos(GetPlayerVehicleID(playerid), -265.9645,-506.3624,-0.3594);
					default:SetVehiclePos(GetPlayerVehicleID(playerid), -220.6464,-502.0705,-0.3329);
				}
				SetPlayerVirtualWorld(playerid, 0);
			}
			else EndFish(playerid);
			ErrorMessage(playerid, "Вы покинули зону рыбалки.");
		}
		if(TI[playerid][tJobWood][0]) EndWood(playerid);
		if(TI[playerid][tDMArea][0]) pc_cmd_exitdm(playerid);
	}
	if(areaid == GetPVarInt(playerid, "BBArea"))
	{
		new get_station[100];
		GetPVarString(playerid, "BBStation", get_station, 100);
		if(!isnull(get_station))
		{
			PlayStream(playerid, get_station, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 20.0, 1);
			SendClientMessage(playerid, COLOR_YELLOW, "Вы попали в зону бумбокса (если вы не слышите музыку настройте громкость)");
		}
		return 1;
	}
	return 1;
}