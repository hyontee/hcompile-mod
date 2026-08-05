public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) 
{	
	TI[playerid][tDialog] = false;
	new bool:olddialog=true;
	if(dialogid != OldDialogID[playerid]) olddialog=false;
	new text_length = strlen(inputtext);
	for(new i = 0; i < text_length; i ++) {
		if(inputtext[i] == '{') {
			inputtext[i] = ' ';
		}
		if(inputtext[i] == '}') {
			inputtext[i] = ' ';
		}
		if(inputtext[i] == '%') {
            inputtext[i] = ' ';
        }
	}
	if(!olddialog) return 1;
	OldDialogID[playerid] = INVALID_DIALOG_ID;
	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
	switch(dialogid) {
		case DIALOG_NONE:
		{
			return 1;
		}
		case D_CONNECT_RETURN_BACK: 
		{
			if(!response) {
				SetPVarInt(playerid, "spCheckReturnBack", 2); 
				return load_load(playerid);
			}

			if(GetPVarInt(playerid, "spCheckReturnBack")) 
			{ 
				ErrorMessage(playerid, "Ошибка #001");
				return load_load(playerid); 
			}
			new select_query[134];

			format(select_query, sizeof(select_query), "SELECT `pLastPosX`, `pLastPosY`, `pLastPosZ`, `pLastPosR`, `pLastWorld`, `pLastInt` FROM `"TABLE_ACCOUNTS"` WHERE `pID` = '%d'", PI[playerid][pID]);
			new Cache:result = mysql_query(connects, select_query);

			new 
				Float: LastPosX,
				Float: LastPosY,
				Float: LastPosZ,
				Float: LastPosR,
				LastWorld,
				LastInt;

			cache_get_value_name_float(0, "pLastPosX", LastPosX);
			cache_get_value_name_float(0, "pLastPosY", LastPosY);
			cache_get_value_name_float(0, "pLastPosZ", LastPosZ);
			cache_get_value_name_float(0, "pLastPosR", LastPosR);
			cache_get_value_name_int(0, "pLastWorld", LastWorld);
			cache_get_value_name_int(0, "pLastInt", LastInt);

			cache_delete(result);

			SetPVarFloat(playerid, "pLastPosX", LastPosX);
			SetPVarFloat(playerid, "pLastPosY", LastPosY);
			SetPVarFloat(playerid, "pLastPosZ", LastPosZ);
			SetPVarFloat(playerid, "pLastPosR", LastPosR);
			SetPVarInt(playerid, "pLastWorld", LastWorld);
			SetPVarInt(playerid, "pLastInt", LastInt);

			
			SetPVarInt(playerid, "spCheckReturnBack", 1);
			return load_load(playerid);
		}
		case D_ALOGIN: {
			if(!response) return 1;
			new query[300];
			switch(GetPVarInt(playerid,"aLogin")) {
				case 1: {
					if(!strcmp(inputtext, "qwerty", true) || strfind(inputtext, "=",true) != -1 || strfind(inputtext, "'",true) != -1) return D(playerid, D_ALOGIN, DSP, ""P"Авторизация", "\n\n"W"Для доступа к правам администратора, Вам необходимо авторизоваться:\n\t"P"Придумайте пароль от 6 до 15 символов\n\n"NO"ЕСЛИ ВЫ ЗАБЫЛИ ПАРОЛЬ, НИКТО ВАМ ВОССТАНАВЛИВАТЬ ЕГО НЕ БУДЕТ", "Вход", "Отмена");
					SetPVarString(playerid,"inputtext",inputtext);
					format(query, sizeof(query), "SELECT * FROM `admin` WHERE `Name` = '%s' LIMIT 1", player_name[playerid]);
					mysql_pquery(connects, query, "alogin", "ds",playerid,player_name[playerid]);
				}
				case 0: {
					if(!strlen(inputtext)) return D(playerid, D_ALOGIN, DSP, ""P"Авторизация", ""W"Для доступа к правам администратора, Вам необходимо авторизоваться:", "Вход", "Отмена");
					format(query, sizeof(query), "SELECT * FROM `admin` WHERE `Name` = '%s' AND `password` = '%s' LIMIT 1", player_name[playerid], MD5_Hash(inputtext));
					mysql_pquery(connects, query, "password_adm","ds", playerid, inputtext);
				}
			}
			return 1;
		}
/* 		case D_HUD_CHOOSEGUN: {
			if(!response) return 1;

			if(IsValidWeaponID(GetPlayerWeapon(playerid))) { // если у человека есть ган, то мы его забираем из фиста
				ResetPlayerWeapons(playerid);
			}

			AC_GivePlayerWeapon(playerid, GunPlayer[playerid][listitem][0], GunPlayer[playerid][listitem][1]);

			// обновляем показатель патрон в худе под фистом
			if(GunPlayer[playerid][listitem][1] > 0) {
				new string_ammo[5];
				format(string_ammo, sizeof(string_ammo), "%d", GetPlayerAmmo(playerid));
				PlayerTextDrawSetString(playerid, mobile_local_hud[playerid][1], string_ammo);
			}

			return 1;
		} */
		case D_THEFT: { //угон
			if(!response) return true;
			theftveh[playerid][0] = INVALID_VEHICLE_ID;
			theftveh[playerid][2] = 0;
			if(PI[playerid][ptheftSkill] < 25) {
				if(!PI[playerid][pJemmy]) return ErrorMessage(playerid,"У Вас нет отмычки");
			}
			FindNearestHouseCar(playerid);
		}
		case D_THEFT_LIST: { //угон
			if(!response) return true;
			switch(listitem){
				case 0: {
					if(thefttime[playerid] > 0) return ErrorMessage(playerid, "Вы уже начали задание, для отмены введите команду /theftcancel");
					D(playerid,D_THEFT,DSM, ""P"Угон транспорта",""W"Здарова, я James Sattora, наш общий знакомый сказал,\nчто ты не против заработать на нелегальной работенке.\nСуть моего задания в том, что я передаю на GPS координаты тачки, которая мне нужна.\nПеред тем, как берешься за работу, нужно купить в магазине отмычки.\nНичего сложного нет, крадешь тачку и получаешь - легкие деньги.\nБудешь браться за дело?","Да","Нет");
				}
				case 1: {
					if(thefttime[playerid] == 0) return ErrorMessage(playerid, "Нужно сначала взять задание!");
					new car;
					theftveh[playerid][1] = 120;
					PlayerTextDrawShow(playerid, theft_PTD[playerid][1]);
					switch(PI[playerid][ptheftSkill]){
						case 1: car = 462;
						case 2: car = 481;
						case 3..25: car = 461;
					}

					switch (random(5)){
						case 0: theftveh[playerid][0] = A_CreateVehicle(car, 2516.0000,-1456.4834,23.5250,181.6838, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 1: theftveh[playerid][0] = A_CreateVehicle(car, 2514.4329,-1456.4664,23.5371,179.9724, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 2: theftveh[playerid][0] = A_CreateVehicle(car, 2512.7175,-1456.5023,23.5253,180.0509, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 3: theftveh[playerid][0] = A_CreateVehicle(car, 2511.2451,-1456.7246,23.5299,182.7245, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
						case 4: theftveh[playerid][0] = A_CreateVehicle(car, 2509.6570,-1456.8005,23.5466,181.3288, random(50), random(50), -1,VEHICLE_TYPE_ADMIN);
					}
					if(car == 461) VehicleInfo[theftveh[playerid][0]][vFuel] = 50.0;

				}
			}
		}
		case D_LOGIN:
		{
			if(!response) return callAccountRecovery(playerid);
			else {
				if(TI[playerid][tLogin]) return true;

				if(isnull(inputtext)) return showLoginDialog(playerid);

				else if(!strlen(inputtext) || !CheckPassword(inputtext)) {
					if(!CheckPassword(inputtext)) ErrorMessage(playerid,"Смените раскладку клавиатуры");
					return showLoginDialog(playerid);
				}
				else {
					if(strcmp(player_pass[playerid],MD5_Hash(inputtext),true)) {
						if(GetPVarInt(playerid, "wrongPass") == 2) return ErrorMessage(playerid,"Вы ввели неверный пароль. Используйте /q(uit) для выхода"), Kick(playerid);
						SetPVarInt(playerid, "wrongPass", GetPVarInt(playerid, "wrongPass")+1);

						static const f_str_1[] = "Авторизация | Вы ввели неправильный пароль. У Вас осталось "NO"%d попыток";
						new string_1[sizeof(f_str_1) + 3];
						format(string_1,sizeof(string_1), f_str_1,3-GetPVarInt(playerid, "wrongPass"));
						ErrorMessage(playerid,string_1);

						return showLoginDialog(playerid);
					}
					else {
						if(PI[playerid][pEmail] && PI[playerid][pEmailStatus] >= 2 && strcmp(player_ip_check[playerid], player_ip[playerid]) != 0)
						{
							TI[playerid][tLoginTime] = 90;
							SetPVarInt(playerid, "login_email_check", 1);
							return MailVerification(playerid);
						}
						else if(!GetString(PI[playerid][pKeyip], "-")) load_captcha(playerid);
						else { // успешная авторизация, закрытие диалога с телефона и пвар для подтверждения (для нажатия на подтверждение авторизации в тд)
/* 							if(TI[playerid][pAndroid]) {
								new string_stars[21];
								for (new i; i < strlen(inputtext); i++) {
									strcat(string_stars, "*");
								}
								PlayerTextDrawSetString(playerid, mobile_local_auth[playerid][1], string_stars);
								SetPVarInt(playerid, "successfulAuth", 1);
								SelectTextDraw(playerid, 0x000000ff);

							} else load_load(playerid);  */
							return load_load(playerid);
						}
					}
				}
			}
		}
		case D_REG: {
			if(!response) return Kick(playerid);
			SetPVarInt(playerid, "registration", 1);

			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20 || !CheckPassword(inputtext)) {
				return showRegisterDialog(playerid);
			}
			mysql_escape_string(inputtext,player_pass[playerid]);

/* 			if(TI[playerid][pAndroid]) { // вписываем пароль в интерфейсе
				new stringPoints[21];
				stringPoints = " "; // пробел чтобы получилось ровно
				for (new i; i < strlen(player_pass[playerid]); i++) {
					strcat(stringPoints, ".");
				}
				PlayerTextDrawSetString(playerid, mobile_local_register[playerid][6], stringPoints);
				SelectTextDraw(playerid, 0x000000ff);

			} else  */
			return showRegisterEmailDialog(playerid);
		}
		case D_REG_MAIL: {
			if(response) {
				if(strfind(inputtext,"|") != -1) {
					ErrorMessage(playerid,"В вашей почте присутствуют запрещенные символы");
					return showRegisterEmailDialog(playerid);
				}
				if(!IsValidEmail(inputtext)) {
					ErrorMessage(playerid,"Вы ввели неверный E-Mail, повторите попытку");
					return showRegisterEmailDialog(playerid);
				}
				if(IsBusyEmail(inputtext))
				{
					ErrorMessage(playerid, "Данный E-Mail адрес уже используется другим игроком");
					return showRegisterEmailDialog(playerid);
				}
				else {
					strmid(PI[playerid][pEmail], inputtext, 0, strlen(inputtext), strlen(inputtext)+5);
				}
			}
			else strmid(PI[playerid][pEmail], "no", 0, strlen("no"), strlen("-")+5);


/* 			if(TI[playerid][pAndroid]) { // вписываем email в интерфейсе
				PlayerTextDrawSetString(playerid, mobile_local_register[playerid][2], PI[playerid][pEmail]);
				SelectTextDraw(playerid, 0x000000ff);
			} else { */
			return D(playerid,D_REG_FRIEND,DSI, ""P"Регистрация", ""G"Введите "ORANGE"ник"G" игрока, пригласившего Вас на сервер.\n\n\
							При достижении 4 уровня он получит "P"награду", "Далее", "Пропуск");
		}
  		case D_REG_FRIEND: {
		    if(response) {
				if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 25) {
					D(playerid,D_REG_FRIEND,DSI, ""P"Регистрация", ""G"Введите "ORANGE"ник"G" игрока, пригласившего Вас на сервер.\n\n\
					При достижении 4 уровня он получит "P"награду", "Далее", "Пропуск");
					return 1;
				}
		        new query[128];
		        mysql_format(connects, query, sizeof(query), "SELECT `Name` FROM `"TABLE_ACCOUNTS"` WHERE `Name` = '%e'", inputtext);
				mysql_tquery(connects, query, "friend_detectd","is", playerid,inputtext);
			}
			else strmid(PI[playerid][pDrug], "-", 0, strlen("-"), strlen("-")+5);

			//
/* 			if(TI[playerid][pAndroid]) { // вписываем реферала в интерфейсе
				SCM(playerid, -1, "реферал вписался");
				new s[64];
				format(s, 32, "referal=%s", PI[playerid][pDrug]);
				SCM(playerid, -1, s);
				PlayerTextDrawSetString(playerid, mobile_local_register[playerid][13], PI[playerid][pDrug]);
				SelectTextDraw(playerid, 0x000000ff);
			} else { */
			return D(playerid,D_REG_SEX,DSM, ""P"Регистрация", "\n"G"Выберите пол для "ORANGE"Вашего"G" будущего персонажа:\n", "Мужской", "Женский");
		}
  		case D_REG_SEX: {
  		    PI[playerid][pSex] = (response ? 1 : 2);
			ChosePlayerSkin(playerid);
			return 1;
		}
		case D_BAND_STOCK: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid,D_BAND_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета банды:\n\n","Пополнить","Закрыть");
				case 1: {
					if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
					D(playerid,D_BAND_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета банды:\n\n","Снять","Закрыть");
				}
				case 2: D(playerid,D_BAND_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n","Положить","Закрыть");
				case 3: {
					if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
					if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
						new str[27];
						format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
						ErrorMessage(playerid,str);
						return 1;
					}
					D(playerid,D_BAND_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n","Взять","Закрыть");
				}
				case 4: D(playerid,D_BAND_STOCK_PUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n","Положить","Закрыть");
				case 5: {
					if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
					if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
						new str[27];
						format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
						ErrorMessage(playerid,str);
						return 1;
					}
					D(playerid,D_BAND_STOCK_INPUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n","Взять","Закрыть");
				}
				case 6: {
					if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
					if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
						new str[27];
						format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
						ErrorMessage(playerid,str);
						return 1;
					}
					D(playerid, D_BAND_GUN, DSL, ""P"Склад оружия",""P"1."W" SD Pistol\n"P"2."W" Desert Eagle\n"P"3."W" MP5\n"P"4."W" Shotgun\n"P"5."W" M4\n"P"6."W" AK-47\n"P"7."W" Rifle", "Выбрать", "Назад");
				}
				case 7: {
					if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
					if(FI[GetTeamID(playerid)][fDrugsBuy]) return ErrorMessage(playerid,"Вы уже сделали заказ. Ожидайте, когда мафии привезут наркотики");
					new string[156];
					format(string,sizeof(string),""W"\n\nВведите кол-во наркотиков, которое желаете заказать у мафий:\nДоступно нараоктиков на складе: "P"%d\n\n",FI[GetTeamID(playerid)][fDrugs]);
					D(playerid,D_BAND_DRUGS,DSI,""P"Заказ наркотиков",string,"Далее","Назад");
				}
			}
		}
		case D_BAND_DRUGS: {
			if(!response) return 1;
			new drugs = strval(inputtext);
			if(drugs < 500 || drugs > 10000) {
				new string[156];
				format(string,sizeof(string),""W"\n\nВведите кол-во наркотиков, которое желаете заказать у мафий:\nДоступно нараоктиков на складе: "P"%d\n"NO"*"G" От 500 и до 10000\n\n",FI[GetTeamID(playerid)][fDrugs]);
				return D(playerid,D_BAND_DRUGS,DSI,""P"Заказ наркотиков",string,"Далее","Назад");
			}
			if(FI[GetTeamID(playerid)][fDrugs]+drugs > 10000) {
				new string[156];
				format(string,sizeof(string),""W"\n\nВведите кол-во наркотиков, которое желаете заказать у мафий:\nДоступно нараоктиков на складе: "P"%d\n"NO"*"G" На Ваш склад не поместится столько наркотиков\n\n",FI[GetTeamID(playerid)][fDrugs]);
				return D(playerid,D_BAND_DRUGS,DSI,""P"Заказ наркотиков",string,"Далее","Назад");
			}
			SetPVarInt(playerid,"buy_gdrugs",drugs);
			D(playerid,D_BAND_DRUGS_2,DSI,""P"Заказ наркотиков",""W"\n\nВведите цену за "P"1г"W" наркотиков:\n"NO"*"G" От $30 до $50\n\n","Далее","Назад");
		}
		case D_BAND_DRUGS_2: {
			if(!response) return DeletePVar(playerid,"buy_gdrugs");
			new price = strval(inputtext);
			if(price < 15 || price > 30) {
				new string[156];
				format(string,sizeof(string),""W"\n\nВведите цену за "P"1г"W" наркотиков:\nЗаказ на "P"%dг\n\n"NO"*"G" От $15 до $30\n\n",GetPVarInt(playerid,"buy_gdrugs"));
				return D(playerid,D_BAND_DRUGS,DSI,""P"Заказ наркотиков",string,"Далее","Назад");
			}
			if(FI[GetTeamID(playerid)][fBank]-(price*GetPVarInt(playerid,"buy_gdrugs")) < 0) {
				new string[156];
				format(string,sizeof(string),""W"\n\nВведите цену за "P"1г"W" наркотиков:\nЗаказ на "P"%dг\n\n"NO"*"G" Недостаточно средств в общаге банды\n\n",GetPVarInt(playerid,"buy_gdrugs"));
				return D(playerid,D_BAND_DRUGS,DSI,""P"Заказ наркотиков",string,"Далее","Назад");
			}
			FI[GetTeamID(playerid)][fBank]-=(price*GetPVarInt(playerid,"buy_gdrugs"));
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			FI[GetTeamID(playerid)][fDrugsBuy] = GetPVarInt(playerid,"buy_gdrugs");
			UpdateFraction(GetTeamID(playerid),"DrugsBuy",FI[GetTeamID(playerid)][fDrugsBuy]);
			FI[GetTeamID(playerid)][fDrugsPrice] = price;
			UpdateFraction(GetTeamID(playerid),"DrugsPrice",FI[GetTeamID(playerid)][fDrugsPrice]);
			DeletePVar(playerid,"buy_gdrugs");
			SendOk(playerid,"Наркотики успешно заказаны. Ожидайте, когда одна из мафий их доставит");
		}
		case D_BAND_GUN: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_BAND_GUN_1, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"SD Pistol"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 1: D(playerid, D_BAND_GUN_2, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Desert Eagle"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 2: D(playerid, D_BAND_GUN_3, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"MP5"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 3: D(playerid, D_BAND_GUN_4, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Shotgun"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 4: D(playerid, D_BAND_GUN_5, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"M4"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 5: D(playerid, D_BAND_GUN_6, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"AK-47"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
				case 6: D(playerid, D_BAND_GUN_7, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Rifle"W", которое хотите взять со склада\n\n", "Взять", "Отмена");
			}
		}
		case D_BAND_GUN_1: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_1, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"SD Pistol"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			SetPVarInt(playerid,"noneedgun",0);
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 23) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[0][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_1, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"SD Pistol"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_1, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"SD Pistol"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[0][mgunamount];
			SetPVarInt(playerid,"noneedgun",0);

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[0][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_2: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_2, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Desert Eagle"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			SetPVarInt(playerid,"noneedgun",0);
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 24) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[1][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_2, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Desert Eagle"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_2, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Desert Eagle"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[1][mgunamount];
			SetPVarInt(playerid,"noneedgun",0);

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[1][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_3: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_3, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"MP5"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			SetPVarInt(playerid,"noneedgun",0);
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 29) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[2][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_3, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"MP5"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_3, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"MP5"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[2][mgunamount];
			DeletePVar(playerid,"noneedgun");

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[2][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_4: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_4, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Shotgun"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			DeletePVar(playerid,"noneedgun");
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 25) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[3][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_4, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Shotgun"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_4, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Shotgun"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[3][mgunamount];
			DeletePVar(playerid,"noneedgun");

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[3][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_5: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_5, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"M4"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			DeletePVar(playerid,"noneedgun");
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 31) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[4][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_5, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"M4"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_5, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"M4"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[4][mgunamount];
			DeletePVar(playerid,"noneedgun");

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[4][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_6: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_6, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"AK-47"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			DeletePVar(playerid,"noneedgun");
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 30) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[5][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_6, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"AK-47"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_6, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"AK-47"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[5][mgunamount];
			DeletePVar(playerid,"noneedgun");

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[5][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_GUN_7: {
			if(!response) return 1;
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			new gun = strval(inputtext);
			if(gun < 10 || gun > 200) return D(playerid, D_BAND_GUN_7, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Rifle"W", которое хотите взять со склада\n\n"NO"*"G" От 10 и до 200\n\n", "Взять", "Отмена");
			DeletePVar(playerid,"noneedgun");
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == 33) {
					SetPVarInt(playerid,"noneedgun",1);
					break;
				}
			}
			if(FI[GetTeamID(playerid)][fMats]<(gun+MakeGunData[6][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_7, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Rifle"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");
			if(FI[GetTeamID(playerid)][fMats]<gun && GetPVarInt(playerid,"noneedgun")) return D(playerid, D_BAND_GUN_7, DSI, ""P"Склад оружия","\n\n"W"Введите количество патрон "ORANGE"Rifle"W", которое хотите взять со склада\n\n"NO"*"G" На складе недостаточно боеприпасов\n\n", "Взять", "Отмена");

			MeAction(playerid,"взял(а) оружие со склада");
			if(!GetPVarInt(playerid,"noneedgun")) FI[GetTeamID(playerid)][fMats] -= MakeGunData[6][mgunamount];
			DeletePVar(playerid,"noneedgun");

			FI[GetTeamID(playerid)][fMats] -= gun;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);

			AC_GivePlayerWeapon(playerid,MakeGunData[6][mgunid],gun);
			static const f_str[] = "[F] %s[%d] взял(а) оружие со склада [%d пт]";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 4)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,gun);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
		}
		case D_BAND_STOCK_PUT_MONEY: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета банды:\n\n","Пополнить","Закрыть");
			new dengi = strval(inputtext);
			if(dengi < 1 || dengi > 500000) return D(playerid,D_BAND_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета банды:\n\n"NO"*"G" От $1 и до $500.000\n\n","Пополнить","Закрыть");
			if(PI[playerid][pCash] < dengi) return ErrorMessage(playerid,"У Вас нет столько денег");
			if(FI[GetTeamID(playerid)][fBank]+dengi > 3000000) return ErrorMessage(playerid,"Нельзя хранить более $3.000.000");
			FI[GetTeamID(playerid)][fBank] += dengi;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			GiveMoney(playerid, -dengi,"положил на счета банды");

			static const f_str[] = "[F] %s[%d] положил(а) в банк банды: "GREEN"$%d";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4)];

			format(string,sizeof(string),f_str,player_name[playerid],playerid,strval(inputtext));
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) деньги на склад");
		}
		case D_BAND_STOCK_INPUT_MONEY: {
			if(!response) return 1;
			if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета банды:\n\n","Снять","Закрыть");
			new dengi = strval(inputtext);
			if(dengi < 1 || dengi > 200000) return D(playerid,D_BAND_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета банды:\n\n"NO"*"G" От $1 и до $200.000\n\n","Снять","Закрыть");
			if(FI[GetTeamID(playerid)][fBankCash] + dengi > 200000) {
				new string[128];
				format(string,sizeof(string),"Суточный лимит на перевод/снятие средств с общага - $200.000. Доступный лимит: $%d",200000-FI[GetTeamID(playerid)][fBankCash]);
				ErrorMessage(playerid,string);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fBank] < dengi) return ErrorMessage(playerid,"В банке банды нет такой суммы");
			FI[GetTeamID(playerid)][fBank] -= dengi;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			FI[GetTeamID(playerid)][fBankCash] += dengi;
			UpdateFraction(GetTeamID(playerid),"BankCash",FI[GetTeamID(playerid)][fBankCash]);
			GiveMoney(playerid, dengi,"снял со счета банды");

			static const f_str[] = "[F] %s[%d] снял(а) с банка банды: "GREEN"$%d";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 6)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,dengi);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"взял(а) деньги со склада");
			return 1;
		}
		case D_BAND_STOCK_PUT_MATS: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n","Положить","Закрыть");
			new mats = strval(inputtext);
			if(mats < 1 || mats > 500) return D(playerid,D_BAND_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n"NO"*"G" От 1 и до 500\n\n","Положить","Закрыть");
			if(PI[playerid][pMats] < mats) return ErrorMessage(playerid,"У Вас нет столько боеприпасов");
			if(FI[GetTeamID(playerid)][fMats] +mats > 300000) return ErrorMessage(playerid,"Склад полон");
			FI[GetTeamID(playerid)][fMats] += mats;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
			PI[playerid][pMats] -= mats;
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);

			static const f_str[] = "[F] %s[%d] положил(а) %d боеприпасов на склад";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 +3)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,mats);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) боеприпасы на склад");
			return  1;
		}
		case D_BAND_STOCK_INPUT_MATS: {
			if(!response) return 1;
			if(PI[playerid][pRank] < 3) return ErrorMessage(playerid,"Доступно с 3 ранга");
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n","Взять","Закрыть");
			new mats = strval(inputtext);
			if(mats < 1 || mats > 500) return D(playerid,D_BAND_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n"NO"*"G" От 1 и до 500\n\n","Взять","Закрыть");
			if(PI[playerid][pMats]+mats > vip_status[PI[playerid][pVips]][vip_mats]) {
				new string[128];
				format(string,sizeof(string),"В кармане не поместится больше %d боеприпасов",vip_status[PI[playerid][pVips]][vip_mats]);
				ErrorMessage(playerid, string);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fSklad] == 0) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fMats] < mats) return ErrorMessage(playerid, "На складе нет боеприпасов");
			FI[GetTeamID(playerid)][fMats] -= mats;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
			PI[playerid][pMats] += mats;
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);

			static const f_str[] = "[F] %s[%d] взял(а) %d боеприпас(ы) со склада";
			new string[sizeof(f_str) + 1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 3)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,mats);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"взял(а) боеприпасы со склада");
			return true;
		}
		case D_BAND_STOCK_PUT_DRUGS: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_PUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n","Положить","Закрыть");
			new drugs = strval(inputtext);
			if(drugs < 1 || drugs > 500) return D(playerid,D_BAND_STOCK_PUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n"NO"*"G" От 1 и до 500\n\n","Положить","Закрыть");
			if(PI[playerid][pDrugs] < drugs) return ErrorMessage(playerid,"У Вас нет столько наркотиков");
			if(FI[GetTeamID(playerid)][fDrugs]+drugs > 10000) return ErrorMessage(playerid,"Склад полон");
			FI[GetTeamID(playerid)][fDrugs] += drugs;
			UpdateFraction(GetTeamID(playerid),"Drugs",FI[GetTeamID(playerid)][fDrugs]);
			PI[playerid][pDrugs] -= drugs;
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);

			static const f_str[] = "[F] %s[%d] положил(а) %d наркотик(ов) на склад";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 +3)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,drugs);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) наркотики на склад");
			return  1;
		}
		case D_BAND_STOCK_INPUT_DRUGS: {
			if(!response) return 1;
			if(PI[playerid][pRank] < 3) return ErrorMessage(playerid,"Доступно с 3 ранга");
			if(!strlen(inputtext)) return D(playerid,D_BAND_STOCK_INPUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n","Взять","Закрыть");
			new drugs = strval(inputtext);
			if(drugs < 1 || drugs > 50) return D(playerid,D_BAND_STOCK_INPUT_DRUGS,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n"NO"*"G" От 1 и до 50\n\n","Взять","Закрыть");
			if(PI[playerid][pDrugs]+drugs > vip_status[PI[playerid][pVips]][vip_drugs]) {
				new string[128];
				format(string,sizeof(string),"В кармане не поместится больше %d наркотиков",vip_status[PI[playerid][pVips]][vip_drugs]);
				ErrorMessage(playerid, string);
				return 1;
			}
			if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей банды закрыл доступ к складу");
			if(PI[playerid][pRank] < FI[GetTeamID(playerid)][fUseStock]) {
				new str[27];
				format(str,sizeof(str),"Склад доступен с %i ранга", FI[GetTeamID(playerid)][fUseStock]);
				ErrorMessage(playerid,str);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fDrugs] < drugs) return ErrorMessage(playerid, "На складе нет наркотиков");
			FI[GetTeamID(playerid)][fDrugs] -= drugs;
			UpdateFraction(GetTeamID(playerid),"Drugs",FI[GetTeamID(playerid)][fDrugs]);
			PI[playerid][pDrugs] += drugs;
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);

			static const f_str[] = "[F] %s[%d] взял(а) %d наркотик(ов) со склада";
			new string[sizeof(f_str) + 1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 3)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,drugs);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"взял(а) наркотики со склада");
			return true;
		}
		case D_MAFIA_STOCK: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid,D_MAFIA_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета мафии:\n\n","Пополнить","Закрыть");
				case 1: {
					if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
					D(playerid,D_MAFIA_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета мафии:\n\n","Снять","Закрыть");
				}
				case 2: D(playerid,D_MAFIA_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n","Положить","Закрыть");
				case 3: {
					if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей мафии закрыл доступ к складу");
					D(playerid,D_MAFIA_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n","Взять","Закрыть");
				}
				case 4: D(playerid,D_MAFIA_STOCK_PUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n","Положить","Закрыть");
				case 5: {
					if(!FI[GetTeamID(playerid)][fSklad]) return ErrorMessage(playerid,"Лидер вашей мафии закрыл доступ к складу");
					D(playerid,D_MAFIA_STOCK_INPUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n","Взять","Закрыть");
				}
			}
		}
		case D_MAFIA_STOCK_PUT_MONEY: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета мафии:\n\n","Пополнить","Закрыть");
			new dengi = strval(inputtext);
			if(dengi < 1 || dengi > 100000) return D(playerid,D_MAFIA_STOCK_PUT_MONEY,DSI, ""P"Введите сумму платежа","\n\n"W"Пополнение банковского счета мафии:\n\n"NO"*"G" От $1 и до $100000\n\n","Пополнить","Закрыть");
			if(PI[playerid][pCash] < dengi) return ErrorMessage(playerid,"У Вас нет столько денег");
			if(FI[GetTeamID(playerid)][fBank]+dengi > 4000000) return ErrorMessage(playerid,"Нельзя хранить более $4.000.000");
			FI[GetTeamID(playerid)][fBank] += dengi;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			GiveMoney(playerid, -dengi,"положил на счета мафии");

			static const f_str[] = "[F] %s[%d] положил(а) в банк мафии: "GREEN"$%d";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4)];

			format(string,sizeof(string),f_str,player_name[playerid],playerid,strval(inputtext));
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) деньги на склад");
		}
		case D_MAFIA_STOCK_INPUT_MONEY: {
			if(!response) return 1;
			if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета мафии:\n\n","Снять","Закрыть");
			new dengi = strval(inputtext);
			if(dengi < 1 || dengi > 300000) return D(playerid,D_MAFIA_STOCK_INPUT_MONEY,DSI, ""P"Введите сумму","\n\n"W"Снятие денег со счета мафии:\n\n"NO"*"G" От $1 и до $300.000\n\n","Снять","Закрыть");
			if(FI[GetTeamID(playerid)][fBank] < dengi) return ErrorMessage(playerid,"В банке мафии нет такой суммы");
			if(FI[GetTeamID(playerid)][fBankCash] + dengi > 300000) {
				new string[128];
				format(string,sizeof(string),"Суточный лимит на перевод/снятие средств с общага - $300.000. Доступный лимит: $%d",300000-FI[GetTeamID(playerid)][fBankCash]);
				ErrorMessage(playerid,string);
				return 1;
			}
			FI[GetTeamID(playerid)][fBank] -= dengi;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			FI[GetTeamID(playerid)][fBankCash] += dengi;
			UpdateFraction(GetTeamID(playerid),"BankCash",FI[GetTeamID(playerid)][fBankCash]);
			GiveMoney(playerid, dengi,"снял со счета мафии");

			static const f_str[] = "[F] %s[%d] снял(а) с банка фракции: "GREEN"$%d";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 6)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,dengi);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"снял(а) деньги со склада");
			return 1;
		}
		case D_MAFIA_STOCK_PUT_NARKO: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_PUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n","Положить","Закрыть");
			new drugs = strval(inputtext);
			if(drugs < 1 || drugs > 500) return D(playerid,D_MAFIA_STOCK_PUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Положить наркотики на склад:\n\n"NO"*"G" От 1 и до 500\n\n","Положить","Закрыть");
			if(PI[playerid][pDrugs] < drugs) return ErrorMessage(playerid,"У Вас нет столько наркотиков");
			if(FI[GetTeamID(playerid)][fDrugs]+drugs > 20000) return ErrorMessage(playerid,"Склад полон");
			FI[GetTeamID(playerid)][fDrugs] += drugs;
			UpdateFraction(GetTeamID(playerid),"Drugs",FI[GetTeamID(playerid)][fDrugs]);
			PI[playerid][pDrugs] -= drugs;
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);

			static const f_str[] = "[F] %s[%d] положил(а) %d наркотик(ов) на склад";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 +3)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,drugs);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) наркотики на склад");
			return  1;
		}
		case D_MAFIA_STOCK_INPUT_NARKO: {
			if(!response) return 1;
			if(PI[playerid][pRank] < 3) return ErrorMessage(playerid,"Доступно с 3 ранга");
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_INPUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n","Взять","Закрыть");
			new drugs = strval(inputtext);
			if(drugs < 1 || drugs > 50) return D(playerid,D_MAFIA_STOCK_INPUT_NARKO,DSI, ""P"Введите кол-во наркотиков","\n\n"W"Взять наркотики со склада:\n\n"NO"*"G" От 1 и до 50\n\n","Взять","Закрыть");
			if(PI[playerid][pDrugs]+drugs > vip_status[PI[playerid][pVips]][vip_drugs]) {
				new string[128];
				format(string,sizeof(string),"В кармане не поместится больше %d наркотиков",vip_status[PI[playerid][pVips]][vip_drugs]);
				ErrorMessage(playerid, string);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fSklad] == 0) return ErrorMessage(playerid,"Лидер вашей мафии закрыл доступ к складу");
			if(FI[GetTeamID(playerid)][fDrugs] < drugs) return ErrorMessage(playerid, "На складе нет наркотиков");
			FI[GetTeamID(playerid)][fDrugs] -= drugs;
			UpdateFraction(GetTeamID(playerid),"Drugs",FI[GetTeamID(playerid)][fDrugs]);
			PI[playerid][pDrugs] += drugs;
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);

			static const f_str[] = "[F] %s[%d] взял(а) %d наркотик(ов) со склада";
			new string[sizeof(f_str) + 1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 3)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,drugs);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"взял(а) наркотики со склада");
			return true;
		}
		case D_MAFIA_STOCK_PUT_MATS: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n","Положить","Закрыть");
			new mats = strval(inputtext);
			if(mats < 1 || mats > 500) return D(playerid,D_MAFIA_STOCK_PUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Положить боеприпасы на склад:\n\n"NO"*"G" От 1 и до 500\n\n","Положить","Закрыть");
			if(PI[playerid][pMats] < mats) return ErrorMessage(playerid,"У Вас нет столько боеприпасов");
			if(FI[GetTeamID(playerid)][fMats] +mats > 300000) return ErrorMessage(playerid,"Склад полон");
			FI[GetTeamID(playerid)][fMats] += mats;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
			PI[playerid][pMats] -= mats;
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);

			static const f_str[] = "[F] %s[%d] положил(а) %d боеприпасов на склад";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 +3)];

         	format(string,sizeof(string),f_str,player_name[playerid],playerid,mats);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"положил(а) боеприпасы на склада");
			return  1;
		}
		case D_MAFIA_STOCK_INPUT_MATS: {
			if(!response) return 1;
			if(PI[playerid][pRank] < 3) return ErrorMessage(playerid,"Доступно с 3 ранга");
			if(!strlen(inputtext)) return D(playerid,D_MAFIA_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n","Взять","Закрыть");
			new mats = strval(inputtext);
			if(mats < 1 || mats > 500) return D(playerid,D_MAFIA_STOCK_INPUT_MATS,DSI, ""P"Введите кол-во боеприпасов","\n\n"W"Взять боеприпасы со склада:\n\n"NO"*"G" От 1 и до 500\n\n","Взять","Закрыть");
			if(PI[playerid][pMats]+mats > vip_status[PI[playerid][pVips]][vip_mats]) {
				new string[128];
				format(string,sizeof(string),"В кармане не поместится больше %d боеприпасов",vip_status[PI[playerid][pVips]][vip_mats]);
				ErrorMessage(playerid, string);
				return 1;
			}
			if(FI[GetTeamID(playerid)][fSklad] == 0) return ErrorMessage(playerid,"Лидер вашей мафии закрыл доступ к складу");
			if(FI[GetTeamID(playerid)][fMats] < mats) return ErrorMessage(playerid, "На складе нет боеприпасов");
			FI[GetTeamID(playerid)][fMats] -= mats;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
			PI[playerid][pMats] += mats;
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);

			static const f_str[] = "[F] %s[%d] взял(а) %d боеприпас(ы) со склада";
			new string[sizeof(f_str) + 1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 3)];

      		format(string,sizeof(string),f_str,player_name[playerid],playerid,mats);
			SendFamilyMessage(PI[playerid][pMember],0x6699ccFF,string);
			MeAction(playerid,"взял(а) боеприпасы со склада");
			return true;
		}
		case D_REPORT: {
			if(!response) return 1;
			if(!strlen(inputtext)) return ErrorMessage(playerid,"Вы ничего не ввели");
			if(PI[playerid][pMute] > 0) return ErrorMessage(playerid,"У Вас бан чата");
			if(strlen(inputtext) > 64) return ErrorMessage(playerid, "Вы ввели слишком длинный текст");
			if(!rep_system) {
				static const f_str[] = ""P"%s[%i]:"W" %s";
				new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + 128)];

				format(string, sizeof(string), f_str, player_name[playerid], playerid, (inputtext));
				SendAdminMessage(COLOR_GOLD,string);

				new string_1[128];
				format(string_1, sizeof(string_1), "Жалоба: %s", inputtext);
				SendClientMessage(playerid,COLOR_YELLOW,string_1);

				SendClientMessage(playerid, COLOR_LIGHTRED, "Наберитесь терпения и ожидайте ответа от администратора");
			}
			else {
				new bool:report = false,reps = 0;
				for(new i;i<MAX_REPORTS;i++) {
					if(PlayerReport[i] != -1) reps++;
				}
				for(new i;i<MAX_REPORTS;i++) {
					if(PlayerReport[reps] != -1) {
						reps++;
						continue;
					}
					PlayerReport[reps] = playerid;
					strmid(TextReport[reps], (inputtext),0,strlen(inputtext),64);
					new string[150];
					if(PI[playerid][pVips] == VIP_PLATINA) {
						format(string, sizeof(string), ""P"[A] %s[%i]: %s."W" [%d] (/reps)", player_name[playerid], playerid, inputtext, reps+1);
						SendAdminMessage(COLOR_SERVER,string);
					}
					else {
						format(string, sizeof(string), ""P"[A] %s[%i]: %s."W" [%d] (/reps)", player_name[playerid], playerid, inputtext, reps+1);
						SendAdminMessage(COLOR_SERVER,string);
					}
					format(string, sizeof string, "Ваше обращение: "G"%s"YELLOW" — успешно отправлено.", inputtext);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					format(string, sizeof(string), "В скором времени вам ответит администратор. Вы в очереди репортов: "P"%d", reps+1);
					SendOk(playerid, string);
					//mysql_tquery(connects, "SELECT * FROM `reports`", "mysql_ReportShow", "i", playerid);
					report = true;
					break;
				}
				if(!report) return ErrorMessage(playerid,"Попробуйте позже");
			}
			SetPVarInt(playerid,"AntiReport",gettime()+30);
			return true;
		}
		case D_ASK: {
			if(!response) return 1;
			if(!strlen(inputtext)) return ErrorMessage(playerid,"Вы ничего не ввели");
			if(PI[playerid][pMute] > 0) return ErrorMessage(playerid,"У Вас бан чата");
			if(GetPVarInt(playerid,"AntiAsk") > gettime()) return ErrorMessage(playerid,"Задавать вопрос можно 1 раз в 30 секунд");
			if(Iter_Count(helpersCount) == 0) return ErrorMessage(playerid,"Хелперов нет в сети. Задавайте вопросы через /mn >> Связь с администрацией");
			if(PI[playerid][pHelper]) return ErrorMessage(playerid,"Вам запрещено задавать вопросы");
			new bool:report = false,reps = 0;
			for(new i;i<MAX_ASK;i++) {
				if(PlayerReportAsk[i] != -1) reps++;
			}
			for(new i;i<MAX_ASK;i++) {
				if(PlayerReportAsk[reps] != -1) {
					reps++;
					continue;
				}
				PlayerReportAsk[reps] = playerid;
				strmid(TextAsk[reps], (inputtext),0,strlen(inputtext),150);
				new string[143];
				format(string, sizeof(string), ""P"[H] %s[%i]: %s."W" [%d] (/asks)", player_name[playerid], playerid, inputtext, reps+1);
				SendHelperMessage(COLOR_SERVER,string);
				format(string, sizeof string, "Ваше обращение: "G"%s"YELLOW" — успешно отправлено.", inputtext);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				format(string, sizeof(string), "Ожидайте ответа от хелперов. Ваш вопрос в очереди: "P"%d", reps+1);
				SendOk(playerid, string);
				report = true;
				break;
			}
			if(!report) return ErrorMessage(playerid,"Попробуйте позже");
			SetPVarInt(playerid,"AntiAsk",gettime()+30);
			return true;
		}
		case D_CLIST: {
			if(response == 1) {
				switch(listitem) {
					case 0: SetPlayerColor(playerid, TEAM_HIT_COLOR);
					case 1: SetPlayerColor(playerid,0x089401FF);
					case 2: SetPlayerColor(playerid,0x56FB4EFF);
					case 3: SetPlayerColor(playerid,0x49E789FF);
					case 4: SetPlayerColor(playerid,0x2A9170FF);
					case 5: SetPlayerColor(playerid,0x9ED201FF);
					case 6: SetPlayerColor(playerid,0x279B1EFF);
					case 7: SetPlayerColor(playerid,0x003366FF);
					case 8: SetPlayerColor(playerid,0xFF0606FF);
					case 9: SetPlayerColor(playerid,0xFF6600FF);
					case 10: SetPlayerColor(playerid,0xF45000FF);
					case 11: SetPlayerColor(playerid,0xBE8A01FF);
					case 12: SetPlayerColor(playerid,0xB30000FF);
					case 13: SetPlayerColor(playerid,0x954F4FFF);
					case 14: SetPlayerColor(playerid,0xE7961DFF);
					case 15: SetPlayerColor(playerid,0xE6284EFF);
					case 16: SetPlayerColor(playerid,0xFF9DB6FF);
					case 17: SetPlayerColor(playerid,0x110CE7FF);
					case 18: SetPlayerColor(playerid,0x0CD7E7FF);
					case 19: SetPlayerColor(playerid,0x139BECFF);
					case 20: SetPlayerColor(playerid,0x2C9197FF);
					case 21: SetPlayerColor(playerid,0x114D71FF);
					case 22: SetPlayerColor(playerid,0x8813E7FF);
					case 23: SetPlayerColor(playerid,0xB313E7FF);
					case 24: SetPlayerColor(playerid,0x758C9DFF);
					case 25: SetPlayerColor(playerid,0xFFDE24FF);
					case 26: SetPlayerColor(playerid,0xFFEE8AFF);
					case 27: SetPlayerColor(playerid,0xDDB201FF);
					case 28: SetPlayerColor(playerid,0xDDA701FF);
					case 29: SetPlayerColor(playerid,0xB0B000FF);
					case 30: SetPlayerColor(playerid,0x868484FF);
					case 31: SetPlayerColor(playerid,0xB8B6B6FF);
					case 32: SetPlayerColor(playerid,0x333333FF);
					case 33: SetPlayerColor(playerid,0xF1965D9F);
				}
			}
			else return true;
		}
		case D_ACCOUNT_RECOVERY:
		{
			if(!response) {
				if(TI[playerid][pAndroid]) SelectTextDraw(playerid, 0xFF0000FF);
			}
			if(strlen(inputtext) < 6 || strlen(inputtext) > 20)
			{
				ErrorMessage(playerid, "Вы ввели недопустимый по длине пароль");
				return D(playerid, D_ACCOUNT_RECOVERY, DSI, ""P" Восстановление доступа к аккаунту", "{ffffff}Введите новый пароль для аккаунта в поле ниже", "Ввести", "Отмена");
			}
			if(!CheckPassword(inputtext))
			{
				ErrorMessage(playerid, "Вы использовали запрещенные символы в пароле");
				return D(playerid, D_ACCOUNT_RECOVERY, DSI, ""P" Восстановление доступа к аккаунту", "{ffffff}Введите новый пароль для аккаунта в поле ниже", "Ввести", "Отмена");
			}

			new
				query[200],
				string_password[48];

			mysql_format(connects, query, sizeof(query), "UPDATE `accounts` SET `pKey` = MD5('%s') WHERE `pID` = '%d' LIMIT 1", inputtext,PI[playerid][pID]);

			mysql_tquery(connects, query);

			format(string_password, sizeof(string_password), "Ваш новый пароль: "W"%s", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, string_password);

			SendClientMessage(playerid, COLOR_YELLOW, ""G"[Совет]"YELLOW" Мы рекомендуем Вам сделать скриншот. Клавиша "W"F8");

   			// if(TI[playerid][pAndroid]) {
			// 	destroyLoginInterface(playerid);
			// }
			return load_load(playerid);
		}
		case D_CHANGE_PASS_SELECT: {
			if(!response) return callcmd::menu(playerid,"");
			if(strlen(inputtext) < 6 || strlen(inputtext) > 20) return D(playerid,D_CHANGE_PASS_SELECT,DSI, ""P"Смена пароля","\n\n"W"Введите свой старый пароль:\n\n"NO"*"G" От 6 до 20 символов\n\n", "Ввод", "Назад");
			if(!CheckPassword(inputtext)) return D(playerid,D_CHANGE_PASS_SELECT,DSP,"Смена пароля","\n\n"W"Введите свой старый пароль:\n\n", "Ввод", "Назад");
			new query[200];
			format(query, sizeof(query), "SELECT * FROM `accounts` WHERE `pID` = '%d' AND `pKey` = MD5('%s') LIMIT 1",PI[playerid][pID],inputtext);
			mysql_tquery(connects, query, "OnPlayerSelectPassword", "is",playerid, inputtext);
			return 1;
		}
		case D_CHANGE_PASS: {
			if(!response) return callcmd::menu(playerid,"");
			if(strlen(inputtext) < 6 || strlen(inputtext) > 20) return D(playerid,D_CHANGE_PASS_SELECT,DSI, ""P"Смена пароля", "\n\n"W"Введите свой старый пароль:\n\n"NO"*"G" От 6 до 20 символов\n\n", "Ввод", "Назад");
			if(!CheckPassword(inputtext)) return D(playerid,D_CHANGE_PASS_SELECT,DSI, ""P"Смена пароля","\n\n"W"Введите свой старый пароль:\n\n", "Ввод", "Назад");
			new query[200],string[100];
			format(query, sizeof(query), "UPDATE `accounts` SET `pKey` = MD5('%s') WHERE `pID` = '%d' LIMIT 1",inputtext,PI[playerid][pID]);
			mysql_tquery(connects,query);
			format(string, sizeof(string), "Ваш новый пароль: "W"%s", inputtext);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			SendClientMessage(playerid, COLOR_YELLOW, ""G"[Совет]"YELLOW" Мы рекомендуем Вам сделать скриншот. Клавиша "W"F8");
			return 1;
		}
		case D_CONTROL_EDIT: {
			if(!response) return callcmd::menu(playerid,"");
			switch(listitem) {
			    case 0: D(playerid,D_CHANGE_PASS_SELECT,DSP,"Смена пароля","\n\n"W"Введите свой старый пароль:\n\n", "Ввод", "Назад");
				case 1: {
					if(GetString(PI[playerid][pKeyip],"-")) {
						D(playerid, dCode, DSI, ""P"Защитный ключ", "\n\n"W"Придумайте новый защитный ключ:\n"G"Защитный ключ будет запрашиваться после каждого входа в игру\n\n","Далее","Отмена");
					}
					else D(playerid, dChangeCode, DSL, ""P"Защитный ключ",""P"1."W" Сменить ключ\n"P"2."W" Отключить ключ\n"P"3."W" История входов","Выбрать", "Назад");
				}
				case 2: {
					if(!GetString(PI[playerid][pEmail],"no")) {
						switch(PI[playerid][pEmailStatus])
						{
						    case 0: return MailVerification(playerid);
						    case 1: {
  								static const fmt_str[] = "{FFFF00}Ваш E-Mail адрес: "W"%s подтверждён. "YELLOW"Желаете включить подтверждение входа по почте?";
								new string_dialog[167];

								format(string_dialog,sizeof(string_dialog), fmt_str, PI[playerid][pEmail]);

								return D(playerid, D_MAIL_CONTROL_SETACCEPT, DSM, ""P"E-Mail подтверждения входа по почте", string_dialog,"Включить","Отмена");
						    }
						    case 2: {
  								static const fmt_str[] = "{FFFF00}На вашем E-Mail адресе: "W"%s уже установлено подтверждение входа по почте.\n"YELLOW"Желаете отключить подтверждение входа по почте?";
								new string_dialog[203];

								format(string_dialog,sizeof(string_dialog), fmt_str, PI[playerid][pEmail]);

								return D(playerid, D_MAIL_CONTROL_SETACCEPT, DSM, ""P"E-Mail подтверждения входа по почте", string_dialog,"Отключить","Отмена");
							}
						}
					}
					else D(playerid,D_MAIL_CONTROL,DSI, ""P"E-Mail",""W"Укажите Вашу "GREEN"почту"W"\n\nУкажите ваш реальный "P"Email"W". C помощью него вы сможете восстановить пароль","Ввести","Отмена");
				}
			}
		}
		case D_MAIL_CONTROL_SETACCEPT:
		{
		    if(!response) return 1;

		    new string_status[68];

		    format(string_status, sizeof(string_status), "Вы успешно "W"%s "GREEN"подтверждение входа по почте", (PI[playerid][pEmailStatus] >= 2 ? "отключили" : "включили"));
		    SendOk(playerid, string_status);

		    PI[playerid][pEmailStatus] = (PI[playerid][pEmailStatus] == 1 ? 2 : 1);

		    UpdatePlayerData(playerid,"pEmailStatus",PI[playerid][pEmailStatus]);
		}
		case D_MAIL_CONTROL_VERIFICATION:
		{
		    if(!response) {
				if(TI[playerid][pAndroid]) SelectTextDraw(playerid, 0xFF0000FF);
			}

			if(strlen(inputtext) > 4)
			{

				ErrorMessage(playerid, "Вы указали неверный код, длина кода не может быть больше 4 символов");
				return D(playerid, D_MAIL_CONTROL_VERIFICATION, DSI, ""P"E-Mail", ""W"На ваш E-Mail адрес был отправлен код\nДля подтверждения почты введите код в поле ниже","Ввести","Отмена");
			}

			if(strval(inputtext) != GetPVarInt(playerid, "email_code"))
			{

				ErrorMessage(playerid, "Вы указали неверный код, перепроверьте почту");
				return D(playerid, D_MAIL_CONTROL_VERIFICATION, DSI, ""P"E-Mail", ""W"На ваш E-Mail адрес был отправлен код\nДля подтверждения почты введите код в поле ниже","Ввести","Отмена");
			}

			DeletePVar(playerid, "email_code");
			SendOk(playerid, "E-Mail адрес успешно подтвержден!");

			if(PI[playerid][pEmailStatus] == 0)
			{
				PI[playerid][pEmailStatus] = 1;
				new query[85];

				format(query, sizeof(query), "UPDATE "TABLE_ACCOUNTS" SET `pEmailStatus` = '1' WHERE `pID` = '%d' LIMIT 1", PI[playerid][pID]);
				mysql_tquery(connects, query);
			}
            if(!TI[playerid][tLogin])
			{
				if(GetPVarInt(playerid, "login_email_check"))
				{
				    DeletePVar(playerid, "login_email_check");
				    if(!TI[playerid][pAndroid]) load_load(playerid);
					else SelectTextDraw(playerid, 0xFF0000FF);
				}
				else return D(playerid, D_ACCOUNT_RECOVERY, DSI, ""P" Восстановление доступа к аккаунту", "{ffffff}Введите новый пароль для аккаунта в поле ниже", "Ввести", "Отмена");
			}
			return 1;
		}
		case D_MAIL_CONTROL: {
			if(!response) return callcmd::menu(playerid,"");
			if(strfind(inputtext,"|") != -1) {
				ErrorMessage(playerid,"У Вас в почте пристуствуют запрещенные символы");
				D(playerid,D_MAIL_CONTROL,DSI, ""P"E-Mail",""W"Укажите Вашу "GREEN"почту"W"\n\nУкажите ваш реальный "P"Email"W". C помощью него вы сможете восстановить пароль","Далее","Закрыть");
				return 1;
			}
			if(!IsValidEmail(inputtext)) {
				ErrorMessage(playerid,"E-Mail не верный. Повторите ввод");
				D(playerid,D_MAIL_CONTROL,DSI, ""P"E-Mail",""W"Укажите Вашу "GREEN"почту"W"\n\nУкажите ваш реальный "P"Email"W". C помощью него вы сможете восстановить пароль","Далее","Закрыть");
				return 1;
			}
            if(IsBusyEmail(inputtext)) {
				ErrorMessage(playerid,"Данный E-Mail адрес уже используется другим игроком");
				D(playerid,D_MAIL_CONTROL,DSI, ""P"E-Mail",""W"Укажите Вашу "GREEN"почту"W"\n\nУкажите ваш реальный "P"Email"W". C помощью него вы сможете восстановить пароль","Далее","Закрыть");
				return 1;
            }
			else {
				strmid(PI[playerid][pEmail], inputtext, 0, strlen(inputtext), strlen(inputtext)+5);
				new query[156];
				mysql_format(connects, query, sizeof(query), "UPDATE accounts SET pEmail = '%e' WHERE `pID` = '%d' LIMIT 1",PI[playerid][pEmail],PI[playerid][pID]);
				mysql_tquery(connects,query);

				static const fmt_str[] = "{FFFF00}Ваш E-Mail адрес: "W"%s. "YELLOW"Желаете подтвердить его прямо сейчас?";
				new string_dialog[113];

				format(string_dialog,sizeof(string_dialog), fmt_str, PI[playerid][pEmail]);

				return D(playerid, D_MAIL_CONTROL_OFFER, DSM, ""P"E-Mail", string_dialog, "Подтвердить", "Отмена");
			}
		}
		case D_MAIL_CONTROL_OFFER:
		{
		    if(!response) return 1;
		    return MailVerification(playerid);
		}
		case dChangeCode: {
			if(!response) return callcmd::menu(playerid,"");
			switch(listitem) {
				case 0: {
					if(GetString(PI[playerid][pKeyip],"-")) D(playerid,dCode,DSI, ""P"Защитный ключ", "\n\n"W"Придумайте новый защитный ключ:\n"G"Защитный ключ будет запрашиваться после каждого входа в игру\n\n","Далее","Отмена");
					else D(playerid,dCodeChange1,3,"Защитный ключ","\n\n"W"Введите Ваш старый ключ безопасности:\n\n","Ввод","Назад");
				}
				case 1: {
					SetString(PI[playerid][pKeyip],"-");
					new query[156];
					format(query,sizeof(query),"UPDATE `accounts` SET `pKeyip` = '-' WHERE `pID` = '%d' LIMIT 1",PI[playerid][pID]);
					mysql_tquery(connects,query);
					SendOk(playerid,"Ключ безопасности отключен");
				}
				case 2: {
					new string[164];
					format(string, sizeof(string), "SELECT * FROM `captchalog` WHERE `clName` = '%s' ORDER BY `captchalog`.`clID` DESC LIMIT 10", player_name[playerid]);
					mysql_tquery(connects, string, "OnPlayerCaptchaLoaded", "i", playerid);
				}
			}
		}
		case dCodeChange1: {
			if(!response) return callcmd::menu(playerid,"");
			if(!strcmp(inputtext,PI[playerid][pKeyip],false) && strlen(inputtext)) {
				D(playerid,dCode,DSI, ""P"Защитный ключ", "\n\n"W"Придумайте новый защитный ключ:\n"G"Защитный ключ будет запрашиваться после каждого входа в игру\n\n","Далее","Отмена");
			}
			else D(playerid,dCodeChange1,DSI, ""P"Защитный ключ","\n\n"W"Введите Ваш старый ключ безопасности:\n\n"NO"*"G" Ключ введён неверно\n\n","Ввод","Назад");
		}
		case dCode: {
			if(!response) return callcmd::menu(playerid,"");
			if(strlen(inputtext) != 4 || !IsNumber(inputtext)) return D(playerid, dCode, DSI, ""P"Защитный код:", "\n\n"W"Придумайте новый защитный ключ:\n"G"Защитный ключ будет запрашиваться после каждого входа в игру\n\n"NO"*"G" Ключ должен состоять из 4 цифр\n\n","Далее","Отмена");
			new string[200];
			format(string,sizeof(string),"Ваш новый защитный ключ: "W"%s."YELLOW" Он будет запрашиваться при входе в игру",(inputtext));
			SendClientMessage(playerid, COLOR_YELLOW,string);
			SendClientMessage(playerid, COLOR_YELLOW, ""G"[Совет]"YELLOW" Мы рекомендуем Вам сделать скриншот, восстановить ключ при утере будет невозможно. Клавиша "W"F8");
			SetString(PI[playerid][pKeyip],inputtext);
			new query[156];
			mysql_format(connects, query,sizeof(query),"UPDATE `accounts` SET `pKeyip` = '%e' WHERE `pID` = '%d' LIMIT 1",(inputtext),PI[playerid][pID]);
			mysql_pquery(connects,query);
			return 1;
		}
		case D_CHANGE_NAME: {
			if(!response) return callcmd::menu(playerid,"");
			if(!strlen(inputtext)) return D(playerid,D_CHANGE_NAME,DSI, ""P"Изменение нонРП ника", "Вы можете изменить имя своего персонажа, при условии если оно не соответствует RP формату\nЕсли же Вы имеет ник, соответствующий RP формату, то вам небходимо использовать /mn > Донат\n\nRP никнейм имеет формат Имя_Фамилия на английском языке.\nНапример: Jenny_Cane, Andrey_Rodionov, Vincento_Rodrigos", "Изменить", "Назад");
			if(strlen(inputtext) < 5 || strlen(inputtext) > 20) return ErrorMessage(playerid,"Длина ника должна быть от 5 до 20 символов");
			if(strfind(inputtext, " ") != -1) return ErrorMessage(playerid,"В Вашем нике замечен пробел");
			if(IsIP(inputtext) || CheckString(inputtext) || strcmp(inputtext, "_",true) == -1) return ErrorMessage(playerid,"Введите новый ник по формату: Имя_Фамилия (Nikita_Zhdanuk)");
			SetPVarString(playerid,"WantNickChange", inputtext);
			new query[100];
			mysql_format(connects,query, sizeof(query), "SELECT `Name` FROM `"TABLE_ACCOUNTS"` WHERE `Name` = '%e' LIMIT 1", inputtext);
			mysql_pquery(connects, query,  "CallChangeName", "d", playerid);
			return true;
		}
		case D_MENU: {
			if(!response) return 1;
			switch(listitem) {
				case 0: ShowStats(playerid,playerid,0);
				case 1: ShowSettings(playerid);
				case 2: D(playerid,D_MENU_COMMANDS,DSL, ""P"Список команд", ""P"1."W" Общие команды\n"P"2."W" Общение\n"P"3."W" Работы\n"P"4."W" Фракционные\n"P"5."W" Дом\n"P"6."W" Бизнес\n"P"7."W" Автомобиль\n"P"8."W" Семья\n"P"9."W" Лидер", "Выбрать", "Назад");
				case 3: {
					return callcmd::ask(playerid);
				}
				case 4: {
					return callcmd::report(playerid);
				}
				case 5: D(playerid, D_CONTROL_EDIT, DSL, ""P"Настройки безопасности", ""P"1."W" Изменить пароль\n"P"2."W" Защитный ключ\n"P"3."W" E-Mail адрес", "Выбрать", "Назад");
				case 6: {
					new plane = -1;
					for(new i=1;i<=gPlaneCount;i++) {
						if(GetString(player_name[playerid],gAirplanes[i][aOwner])) {plane = i; break;}
					}
					if(plane != -1) return ErrorMessage(playerid,"Для смены ника, необходимо отказаться от аренды воздушного транспорта");
					if(PI[playerid][pLeader]) return ErrorMessage(playerid,"Лидерам запрещено менять ник");
					D(playerid,D_CHANGE_NAME,DSI, ""P"Изменение нонРП ника", "Вы можете изменить имя своего персонажа, при условии если оно не соответствует RP формату\nЕсли же Вы имеет ник, соответствующий RP формату, то вам небходимо использовать /mn > Донат\n\nRP никнейм имеет формат Имя_Фамилия на английском языке.\nНапример: Jenny_Cane, Andrey_Rodionov, Vincento_Rodrigos", "Изменить", "Назад");
				}
                case 7: return callcmd::donate(playerid);
				case 8: return D(playerid, D_PROMO_ACTIVATION, DSI, !""P"Промокод", !""W"Чтобы использовать "P"промокод"W" введите его в поле ниже:\n\n"G"Чтобы посмотреть сколько осталось до получения бонуса\nИспользуйте команду: "W"/promolist", "Принять", "Закрыть");
			}
		}
		case D_MENU_SETTING: {
			if(!response) return callcmd::menu(playerid,"");
		    switch(listitem) {
				case 0: {
					if(PI[playerid][pSettings][0]) {
						foreach(new i:Player) {
							if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
							ShowPlayerNameTagForPlayer(playerid,i,0);
						}
						SendOk(playerid,"Вы отключили показ ников у игроков");
						PI[playerid][pSettings][listitem] = 0;
					}
					else {
						foreach(new i:Player) {
							if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
							ShowPlayerNameTagForPlayer(playerid,i,1);
						}
						SendOk(playerid,"Вы включили показ ников у игроков");
						PI[playerid][pSettings][listitem] = 1;
					}
				}
				case 1: {
					if(PI[playerid][pSettings][listitem] == 0) {
						PI[playerid][pSettings][listitem] = 1;
						SendOk(playerid,"Вы включили чат организации");
					}
					else if(PI[playerid][pSettings][listitem] == 1) {
						PI[playerid][pSettings][listitem] = 0;
						SendOk(playerid,"Вы отключили чат организации");
					}
				}
				case 2: {
					if(PI[playerid][pSettings][3] == 0) {
						PI[playerid][pSettings][3] = 1;
						SendOk(playerid,"Вы включили чат компании");
					}
					else if(PI[playerid][pSettings][3] == 1) {
						PI[playerid][pSettings][3] = 0;
						SendOk(playerid,"Вы отключили чат компании");
					}
				}
				case 3: return D(playerid, D_NEWS_SELECT, DSL, ""P"Эфиры", ""P"1."W" Радиоцентр LS\n"P"2."W" Радиоцентр SF\n"P"3."W" Радиоцентр LV\n"P"-"W" Выключить", "Выбрать", "Назад");
				case 4: return D(playerid, D_CHAT, DSL, ""P"Стиль разговора", ""P"1."W" Стандартный\n"P"2."W" Стиль 1\n"P"3."W" Стиль 2\n"P"4."W" Стиль 3\n"P"5."W" Стиль 4\n"P"6."W" Стиль 5\n"P"7."W" Стиль 6", "Выбрать", "Назад");
				case 5: return D(playerid, D_BOX, DSL, ""P"Стиль боя", ""P"1."W" Стандартный\n"P"2."W" Бокс\n"P"3."W" Кунг-Фу\n"P"4."W" Кик-Бокс", "Выбрать", "Назад");
				case 6: {
					if(PI[playerid][pSettings][6]) {
						SendOk(playerid,"Вы скрыли состояние голода");
						PI[playerid][pSettings][6] = 0;
						Hunger(playerid,1);
					}
					else {
						SendOk(playerid,"Вы включили состояние голода");
						PI[playerid][pSettings][6] = 1;
						Hunger(playerid,0);
					}
				}
				case 7: {
					if(PI[playerid][pSettings][7]) {
						SendOk(playerid,"Вы убрали демонстрацию кейса в руках");
						PI[playerid][pSettings][7] = 0;
					}
					else {
						SendOk(playerid,"Вы включили показ демонстрацию кейса в руках");
						PI[playerid][pSettings][7] = 1;
					}
				}
				case 8: {
					if(PI[playerid][pSettings][8]) {
						SendOk(playerid,"Вы убрали окно прогрузки текстур");
						PI[playerid][pSettings][8] = 0;
					}
					else {
						SendOk(playerid,"Вы включили окно прогрузки текстур");
						PI[playerid][pSettings][8] = 1;
					}
				}
				case 9: {
					if(!PI[playerid][pSettings][9]) {
						SendOk(playerid,"Вы включили название семьи над головой");
						PI[playerid][pSettings][9] = 1;
					}
					else {
						SendOk(playerid,"Вы убрали название семьи над головой");
						PI[playerid][pSettings][9] = 0;
					}
				}
				case 10: {
					if(!PI[playerid][pSettings][10]) {
						SendOk(playerid,"Вы включили оповещение о нанесении урона");
						PI[playerid][pSettings][10] = 1;
					}
					else {
						SendOk(playerid,"Вы выключили оповещение о нанесении урона");
						PI[playerid][pSettings][10] = 0;
					}
				}
				case 11: return D(playerid, D_SPAWN, DSL, ""P"Выбор спавна", ""P"1."W" Вокзал\n"P"2."W" Дом/Отель\n"P"3."W" Организация", "Выбрать", "Отмена");
				case 12: return D(playerid, D_BUYACS_4, DSL,""P"Управление аксесурами",""P"1."W" Головные уборы\n"P"2."W" Очки\n"P"3."W" Банданы\n"P"4."W" Наушники\n"P"5."W" Часы\n"P"6."W" Рюкзаки" , "Выбрать", "Отмена");
			}
			save_settings(playerid);
			ShowSettings(playerid);
		}
		case D_MENU_COMMANDS: {
			if(!response) return callcmd::menu(playerid,"");
			new string[1512];
			switch(listitem) {
				case 0: {
					strcat(string,""P"/id"W" - узнать ид игрока по нику\n");
					strcat(string,""P"/ad"W" - подать объявление\n");
					strcat(string,""P"/radio"W" - выбрать радиостанцию\n");
					strcat(string,""P"/leaders"W" - руководители организаций (online)\n");
					strcat(string,""P"/subleaders"W" - заместители организаций (online)\n");
					strcat(string,""P"/anim"W" - список анимаций\n");
					strcat(string,""P"/number"W" - узнать номер игрока\n");
					strcat(string,""P"/с(/call)"W" - совершить вызов\n");
					strcat(string,""P"/sms"W" - написать СМС\n");
					strcat(string,""P"/book"W" - адресная книга\n");
					strcat(string,""P"/time"W" - посмотреть время(времени на сервере,заключения, бан чата)\n");
					strcat(string,""P"/pass"W" - показать паспорт\n");
					strcat(string,""P"/lic"W" - показать лицензии\n");
					strcat(string,""P"/togphone"W" - выключить/включить телефон\n");
					strcat(string,""P"/pay"W" - передать деньги\n");
					strcat(string,""P"/hi"W" - пожать руку\n");
					strcat(string,""P"/namestore"W" - узнать прошлые ники игрока\n");
					strcat(string,""P"/buyfuel"W" - купить канистру с бензином\n");
					strcat(string,""P"/fillcar"W" - использовать канистру с бензином\n");
					strcat(string,""P"/propose"W" - сделать предложение\n");
					strcat(string,""P"/divorce"W" - развестись\n");
					strcat(string,""P"/medcard"W" - показать мед. карту\n");
					strcat(string,""P"/play"W" - онлайн радио\n");
					strcat(string,""P"/referals"W" - список рефералов\n");
					strcat(string,""P"/leave"W" - уволиться из организации\n");
					strcat(string,""P"/give"W" - передать предмет\n");
					strcat(string,""P"/wbook"W" - просмотр трудовой книжки\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 1: {
					strcat(string,""P"/b"W" - ООС чат\n");
					strcat(string,""P"/me"W" - чат действий\n");
					strcat(string,""P"/ame"W" - действий над головой\n");
					strcat(string,""P"/do"W" - чат от 3-го лица\n");
					strcat(string,""P"/ado"W" - чат от 3-го лица над головой\n");
					strcat(string,""P"/try"W" - попытка действия (Удачно, Неудачно)\n");
					strcat(string,""P"/todo"W" - разговор совмещён с действием\n");
					strcat(string,""P"/s"W" - кричать\n");
					strcat(string,""P"/w"W" - шептать\n");
					strcat(string,""P"/toss"W" - подбросить монетку\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 2: {
					switch(PI[playerid][pJob]) {
						case 1: {
							strcat(string,""GREEN"Чтобы начать работу водителя автобуса, необходимо арендовать автобус.\n");
							strcat(string,""GREEN"Место аренды автобусов Вы можете найти в GPS.\n");
							strcat(string,"\t\t\t"YELLOW"/gps >> работы\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
						}
						case 2: {
							strcat(string,""P"/repairs"W" - список вызовов\n");
							strcat(string,""P"/repair"W" - починить автомобиль\n");
							strcat(string,""P"/refill"W" - заправить автомобиль\n");
							strcat(string,""P"/contract"W" - купить топливо у АЗС\n");
							strcat(string,""P"/tow"W" - буксировать автомобиль\n");
							strcat(string,""P"/untow"W" - отцепить автомобиль\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
						}
						case 3: {
							strcat(string,""P"/prods"W" - список заказов продуктов/топлива\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
							strcat(string,""GREEN"Место аренды развозчиков продуктов/топлива Вы можете найти в GPS.\n");
							strcat(string,"\t\t\t"YELLOW"/gps >> работы\n");
						}
						case 4: {
							strcat(string,""P"/bhd"W" - купить хот-доги у закусочной\n");
							strcat(string,""P"/shd"W" - продать хот-дог игроку\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
						}
						case 5: {
							strcat(string,""GREEN"Место аренды Т/С для уборки дорог Вы можете найти в GPS.\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
						}
						case 6: {
							strcat(string,""P"/zonestatus"W" - список зон для скашивания травы\n");
							strcat(string,""P"/endwork"W" - завершение работы\n");
							strcat(string,""GREEN"Место аренды Т/С для скашивания травы Вы можете найти в GPS.\n");
						}
						default: return ErrorMessage(playerid,"Вы не трудоустроены"),callcmd::menu(playerid,"");
					}
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 3: {
					switch(GetTeamID(playerid)) {
						case fLSPD,fSFPD,fLVPD,fFBI: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/rr"W" - рация подфракций\n");
							strcat(string,""P"/m"W" - мегафон\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
							strcat(string,""P"/su"W" - выдать розыск\n");
							strcat(string,""P"/clear"W" - снять розыск\n");
							strcat(string,""P"/ud"W" - показать удостоверение\n");
							strcat(string,""P"/hold"W" - тащить за собой\n");
							strcat(string,""P"/tazer"W" - поразить электрошокером\n");
							strcat(string,""P"/cuff"W" - надеть наручники\n");
							strcat(string,""P"/uncuff"W" - снять наручники\n");
							strcat(string,""P"/obc"W" - бортовой компьютер\n");
							strcat(string,""P"/arrest"W" - посадить в КПЗ\n");
							strcat(string,""P"/push"W" - затолкать в автомобиль\n");
							strcat(string,""P"/unmask"W" - снять маску\n");
							strcat(string,""P"/look"W" - обыскать игрока\n");
							strcat(string,""P"/take"W" - изъять лицензии/вещи\n");
							strcat(string,""P"/ticket"W" - выписать штраф\n");
							strcat(string,""P"/spikes"W" - выбросить шипы\n");
							strcat(string,""P"/hack"W" - взломать дверь дома\n");
							strcat(string,""P"/fences"W" - установить ограждение\n");
							if(GetTeamID(playerid) == fFBI) {
								//strcat(string,""P"/demote"W" - понизить/уволить гос.служащего\n");
								strcat(string,""P"/fakepass"W" - показать поддельный паспорт\n");
								strcat(string,""P"/givekey"W" - выдать/забрать пропуск\n");
							}
						}
						case fMEDICLS,fMEDICSF,fMEDICLV: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/rr"W" - рация подфракций\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
							strcat(string,""P"/heal"W" - вылечить игрока\n");
							strcat(string,""P"/medics"W" - список вызовов\n");
							strcat(string,""P"/bheal"W" - вылечить от болезней\n");
							strcat(string,""P"/gmed"W" - поставить печать в лицензию на оружие\n");
						}
						case fLSNEWS,fSFNEWS,fLVNEWS: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/rr"W" - рация подфракций\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
							strcat(string,""P"/ether"W" - прямой эфир\n");
							strcat(string,""P"/edit"W" - объявления\n");
							strcat(string,""P"/skip"W" - положить тFCку\n");
							strcat(string,""P"/udjur"W" - показать удостоверение журналиста\n");
							strcat(string,""P"/audience"W" - рейтинг слушателей\n");
						}
						case fARMYLV,fARMYSF: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/rr"W" - рация подфракций\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
							strcat(string,""P"/load"W" - начать загрузку боеприпасов\n");
							strcat(string,""P"/unload"W" - начать разгрузку боеприпасов\n");
							strcat(string,""P"/carm"W" - начать перевозку боеприпасов\n");
						}
						case fBALLAS,fVAGOS,fGROVE,fAZTEC,fRIFA: {
							strcat(string,""P"/f"W" - рация\n");
							strcat(string,""P"/fb"W" - НонРП рация\n");
							strcat(string,""P"/bc"W" - чат банд\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/capture"W" - начать войну за территорию\n");
							strcat(string,""P"/kd"W" - узнать время до начала капта\n");
							strcat(string,""P"/zone"W" - узнать количество территорий\n");
							strcat(string,""P"/makegun"W" - сделать оружие\n");
							strcat(string,""P"/getgun"W" - взять оружие со склада\n");
							strcat(string,""P"/sellgun"W" - продать оружие\n");
							strcat(string,""P"/load"W" - начать загрузку материалов\n");
							strcat(string,""P"/unload"W" - начать разгрузку материалов\n");
							strcat(string,""P"/mask"W" - надеть маску\n");
							strcat(string,""P"/maskoff"W" - снять маску\n");
							strcat(string,""P"/dress"W" - переодеться в военную форму\n");
							strcat(string,""P"/givekey"W" - выдать/забрать пропуск\n");
							strcat(string,""P"/robhouse"W" - ограбить дом\n");
							strcat(string,""P"/srace"W" - уличные гонки\n");
							strcat(string,""P"/sellzone"W" - продать территорию\n");
							strcat(string,""P"/close"W" - открыть/закрыть склад\n");
							strcat(string,""P"/bmarket"W" - управление черным рынком\n");
							strcat(string,""P"/gspcars"W" - заспавнить незанятые авто\n");
							strcat(string,""P"/gpay"W" - выдать премию\n");
						}
						case fRM,fLCN,fYAKUZA: {
							strcat(string,""P"/f"W" - рация\n");
							strcat(string,""P"/fb"W" - НонРП рация\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/bizwar"W" - начать войну за бизнес\n");
							strcat(string,""P"/bizlist"W" - посмотреть список бизнесов под контролем\n");
							strcat(string,""P"/sellbizmafia"W" - продать контроль над бизнесов другой мафии\n");
							strcat(string,""P"/tie"W" - связать игрока\n");
							strcat(string,""P"/untie"W" - развязать игрока\n");
							strcat(string,""P"/takephone"W" - забрать телефон\n");
							strcat(string,""P"/givephone"W" - вернуть телефон\n");
							strcat(string,""P"/gag"W" - вставить/достать кляп\n");
							strcat(string,""P"/bag"W" - надеть/снять мешок с головы\n");
							strcat(string,""P"/close"W" - открыть/закрыть склад\n");
							strcat(string,""P"/makegun"W" - сделать оружие\n");
							strcat(string,""P"/load"W" - начать загрузку боеприпасов\n");
							strcat(string,""P"/unload"W" - начать разгрузку боеприпасов\n");
						}
						case fMAYOR: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
						}
						case fWHITEHOUSE: {
							strcat(string,""P"/r"W" - рация\n");
							strcat(string,""P"/rb"W" - НонРП рация\n");
							strcat(string,""P"/d"W" - рация гос. департамента\n");
							strcat(string,""P"/db"W" - НонРП рация гос. департамента\n");
							strcat(string,""P"/members"W" - посмотреть онлайн фракции\n");
							strcat(string,""P"/gnews"W" - гос. новости\n");
							//strcat(string,""P"/giveleader"W" - назначить лидером\n");
							strcat(string,""P"/free"W" - выпустить из тюрьмы\n");
							strcat(string,""P"/hold"W" - тащить за собой\n");


							strcat(string,""P"/cuff"W" - надеть наручники\n");
						}
						default: return ErrorMessage(playerid,"Вы не состоите в организации");
					}
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 4: {
					strcat(string,""P"/house"W" - меню управления домом\n");
					strcat(string,""P"/safe"W" - сейф\n");
					strcat(string,""P"/hhealme"W" - использовать аптечку\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 5: {
					strcat(string,""P"/bpanel (/bp)"W" - меню управления бизнесом\n");
					strcat(string,""P"/tinvite"W" - принять в таксопарк\n");
					strcat(string,""P"/trinvite"W" - принять в транспортную компанию\n");
					strcat(string,""P"/tr"W" - чат таксопарка/транспортной компании\n");
					strcat(string,""P"/trspcar"W" - спавн автомобилей транспортной компании\n");
					strcat(string,""P"/taxispcar"W" - спавн автомобилей таксопарка\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 6: {
					strcat(string,""P"/lock (/lk)"W" - открыть/закрыть Т/С\n");
					strcat(string,""P"/rlock (/rlk)"W" - открыть/закрыть арендованный Т/С\n");
					strcat(string,""P"/changecar"W" - продать/обменять Т/С\n");
					strcat(string,""P"/trunk"W" - багажник\n");
					strcat(string,""P"/slimit"W" - установить ограничение скорости Т/С\n");
					strcat(string,""P"/remp"W" - починить Т/С\n");
					strcat(string,""P"/style"W" - переключить режим езды (perfomance)\n");
					strcat(string,""P"/fixcar"W" - заспавнить авто\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 7: {
					if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
					strcat(string,""P"/fmenu"W" - меню семьи\n");
					strcat(string,""P"/fam"W" - чат семьи\n");
					strcat(string,""P"/finvite"W" - принять в семью\n");
					strcat(string,""P"/funinvite"W" - выгнать из семьи\n");
					strcat(string,""P"/foffuninvite"W" - выгнать из семьи в оффлайн\n");
					strcat(string,""P"/frang"W" - повысить/понизить члена семьи\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыть","");
				}
				case 8: {
					if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вы не лидер");
					strcat(string,""P"/invite"W" - принять игрока в организацию\n");
					strcat(string,""P"/uninvite"W" - выгнать игрока из организации\n");
					strcat(string,""P"/rang"W" - повысить/понизить ранг\n");
					strcat(string,""P"/changeskin"W" - сменить скин игроку\n");
					strcat(string,""P"/lpanel"W" - меню лидера\n");
					strcat(string,""P"/fwarn"W" - выдать выговор\n");
					strcat(string,""P"/funwarn"W" - снять выговор\n");
					strcat(string,""P"/showall"W" - члены фракции оффлайн\n");
					strcat(string,""P"/bl"W" - управление черным списком\n");
					strcat(string,""P"/fmute"W" - выдать заглушку\n");
					strcat(string,""P"/funmute"W" - снять заглушку\n");
					D(playerid,DIALOG_NONE,DSM, ""P"Команды",string,"Закрыт","");
				}
			}
		}
		case D_CHAT: {
			if(!response) return ShowSettings(playerid);
			PI[playerid][pSettings][4] = listitem;
			SendOk(playerid, "Вы выбрали новый стиль разговора для своего персонажа");
			save_settings(playerid);
			ShowSettings(playerid);
		}
		case D_BOX: {
			if(!response) return ShowSettings(playerid);
			if(PI[playerid][pBox] < listitem) return ErrorMessage(playerid,"Выбранный стиль еще не изучен. Отправляйтесь в спортзал"),ShowSettings(playerid);
			PI[playerid][pSettings][5] = listitem;
			SendOk(playerid, "Вы выбрали новый стиль боя для своего персонажа");
			switch(listitem) {
				case 0: SetPlayerFightingStyle(playerid, FIGHT_STYLE_NORMAL);
				case 1: SetPlayerFightingStyle(playerid, FIGHT_STYLE_BOXING);
				case 2: SetPlayerFightingStyle(playerid, FIGHT_STYLE_KUNGFU);
				case 3: SetPlayerFightingStyle(playerid, FIGHT_STYLE_KNEEHEAD);
			}
			save_settings(playerid);
			ShowSettings(playerid);
		}
		case D_NEWS_SELECT: {
			if(!response) return ShowSettings(playerid);
			switch(listitem) {
				case 0: PI[playerid][pSettings][2] = fLSNEWS;
				case 1: PI[playerid][pSettings][2] = fSFNEWS;
				case 2: PI[playerid][pSettings][2] = fLVNEWS;
				case 3: PI[playerid][pSettings][2] = 0;
			}
			SendOk(playerid, "Радиостанция успешно установлена");
			save_settings(playerid);
			ShowSettings(playerid);
		}
		case D_NEWS_SELECT_2: {
			if(!response) return 1;
			switch(listitem) {
				case 0: PI[playerid][pSettings][2] = fLSNEWS;
				case 1: PI[playerid][pSettings][2] = fSFNEWS;
				case 2: PI[playerid][pSettings][2] = fLVNEWS;
				case 3: PI[playerid][pSettings][2] = 0;
			}
			SendOk(playerid, "Радиостанция успешно установлена");
			save_settings(playerid);
		}
  		case D_BAN_LIST: {
			if(response) {
			    if(listitem == 20 || listitem == 21) CheckBanned(playerid,listitem);
       			else {
			        strmid(UnbanName[playerid], inputtext, 0, strlen(inputtext) );
			        if(GetString(inputtext, "<<< Назад")) return CheckBanned(playerid,21);
					new query[53 + MAX_PLAYER_NAME];
				    mysql_format(connects,query, sizeof(query), "SELECT * FROM `ban` WHERE BINARY `Name` = '%e' LIMIT 1", UnbanName[playerid]);
   					new Cache:result = mysql_query(connects, query);
   					new rows = cache_num_rows();
					if(rows > 0) {
						new NAME_ADMIN[MAX_PLAYER_NAME + 1], NAME_PLAYER[MAX_PLAYER_NAME + 1], BAN_REASON[32], UNBAN_DATA;
						cache_get_value_index(0,1,NAME_PLAYER,24);
						cache_get_value_index(0,2,NAME_ADMIN,24);
						cache_get_value_index(0,3,BAN_REASON,24);
						cache_get_value_index_int(0,4,UNBAN_DATA);
						if(UNBAN_DATA > unix) {
							new string[220];
							new date_ban[6];
							timestamp_to_date(UNBAN_DATA,date_ban[0],date_ban[1],date_ban[2],date_ban[3],date_ban[4],date_ban[5]);

							format(string,sizeof(string),"\
							"W"Заблокирован:\t"NO"%s\n\
							"W"Заблокировал:\t"ORANGE"%s\n\
							"W"Причина:\t\t"ORANGE"%s\n\
							"W"Разблокировка:\t"ORANGE"%02d/%02d/%02d %02d:%02d:%02d",
							NAME_PLAYER,NAME_ADMIN, BAN_REASON ,date_ban[2],date_ban[1],date_ban[0],date_ban[3],date_ban[4],date_ban[5]);
							D(playerid,D_UNBAN,DSM, ""P"Разблокировка",string,"Разбанить","Отмена");
						}
						else {
							static const f_str[] = "Игрок %s не забанен";
							new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];

							format(str, sizeof(str), f_str, UnbanName[playerid]);
							ErrorMessage(playerid, str);
						}
					}
				    cache_delete(result);
			    }
			}
		}
  		case D_TRUNK_LIST: {
		    if(response) {
		        new idofcar = idaofcar[playerid];
				switch(listitem) {
				    case 0: {
						if(idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Машина не принадлежит Вам"),trunk_close(playerid);
				        if(!TrunkInfo[idofcar][tOpen]) {
							TrunkInfo[idofcar][tOpen] = 1;
							callcmd::trunk(playerid);
						}
				        else TrunkInfo[idofcar][tOpen] = 0;
				        callcmd::trunk(playerid);
				    }
				    case 1: {
                        nedded[playerid] = 1;
						new string[128];
                        format(string,sizeof(string),""W"Достать канистру\nПоложить канистру\nДоступно: "P"[%d/2]",TrunkInfo[idofcar][tKanistra]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
        			case 2: {
                        nedded[playerid] = 2;
						new string[128];
                        format(string,sizeof(string),""W"Достать наркотики\nПоложить наркотики\nДоступно: "P"[%d/200]",TrunkInfo[idofcar][tNarko]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
                	case 3: {
                        nedded[playerid] = 3;
                        new string[128];
                        format(string,sizeof(string),""W"Достать боеприпасы\nПоложить боеприпасы\nДоступно: "P"[%d/1000]",TrunkInfo[idofcar][tMats]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
        			case 4: {
                        nedded[playerid] = 4;
                        new string[128];
                        format(string,sizeof(string),""W"Достать Deagle\nПоложить Deagle\nДоступно: "P"[%d/50]",TrunkInfo[idofcar][tGun][0]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
                	case 5: {
                        nedded[playerid] = 5;
                        new string[128];
                        format(string,sizeof(string),""W"Достать AK-47\nПоложить AK-47\nДоступно: "P"[%d/50]",TrunkInfo[idofcar][tGun][1]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
                    case 6: {
                        nedded[playerid] = 6;
						new string[128];
                        format(string,sizeof(string),""W"Достать M4\nПоложить M4\nДоступно: "P"[%d/50]",TrunkInfo[idofcar][tGun][2]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
                    case 7: {
                        nedded[playerid] = 7;
                        new string[128];
                        format(string,sizeof(string),""W"Достать ShotGun\nПоложить ShotGun\nДоступно: "P"[%d/50]",TrunkInfo[idofcar][tGun][3]);
                        D(playerid,D_TRUNK_SELECT,DSL,""P"Багажник",string,"Принять","Отмена");
				    }
				}
				SaveTrunk(idofcar);
		    }
			else return trunk_close(playerid);
		}
  		case D_TRUNK_SELECT: {
		    if(response) {
		        new item[30];
		        switch(nedded[playerid]) {
		            case 1: item = "канистр";
		            case 2: item = "наркотиков";
		            case 3: item = "боеприпасов";
		            case 4: item = "патронов Deagle";
		            case 5: item = "патронов AK47";
		            case 6: item = "патронов M4";
		            case 7: item = "патронов ShotGun";
		            default: return false;
		        }
				new string[128];
		        switch(listitem) {
		            case 0: {
		                format(string,sizeof(string),""W"Введите кол-во %s, которое хотите достать с багажника:",item);
		                D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",string,"Принять","Отмена");
		            }
		            case 1: {
					    format(string,sizeof(string),""W"Введите кол-во %s, которое хотите положить в багажник:",item);
		                D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",string,"Принять","Отмена");
					}
		        }
		    }
		    else callcmd::trunk(playerid);
		}
		case D_TRUNK_INPUT: {
		    if(response) {
		        if(!strlen(inputtext)) return callcmd::trunk(playerid);
		        new bitem = strval(inputtext),idofcar=idaofcar[playerid],string[156];
		        if(bitem<1) return callcmd::trunk(playerid),SendClientMessage(playerid,COLOR_RED,"Ошибка");
		        switch(nedded[playerid]) {
                    case 1: {
						if(bitem>TrunkInfo[idofcar][tKanistra]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во канистр, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва канистр","Принять","Отмена");
						}
						if((PI[playerid][pFuel]+bitem)>vip_status[PI[playerid][pVips]][vip_fuel]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во канистр, которое хотите достать с багажника:\n\n"NO"*"G" Вы не можете взять с собой так много канистр","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pFuel] +=bitem;
						UpdatePlayerData(playerid,"pFuel",PI[playerid][pFuel]);
						TrunkInfo[idofcar][tKanistra] -= bitem;
						callcmd::trunk(playerid),SendUse(playerid,"Вы взяли "ORANGE"1 "G"канистру с багажника");
		            }
                    case 2: {
						if(bitem>TrunkInfo[idofcar][tNarko]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во наркотиков, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва наркотиков","Принять","Отмена");
						}
						if((PI[playerid][pDrugs]+bitem)>vip_status[PI[playerid][pVips]][vip_drugs]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во наркотиков, которое хотите достать с багажника:\n\n"NO"*"G" Вы не можете взять с собой так много наркотиков","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pDrugs] += bitem;
						TrunkInfo[idofcar][tNarko] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"наркотиков с багажника",bitem);
						SendUse(playerid,string);
		            }
                    case 3: {
						if(bitem>TrunkInfo[idofcar][tMats]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во боеприпасов, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва боеприпасов","Принять","Отмена");
		                }
						if((PI[playerid][pMats]+bitem)>vip_status[PI[playerid][pVips]][vip_mats]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во боеприпасов, которое хотите достать с багажника:\n\n"NO"*"G" Вы не можете взять с собой так много боеприпасов","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pMats] += bitem;
						TrunkInfo[idofcar][tMats] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"боеприпасов с багажника",bitem);
						SendUse(playerid,string);
		            }
                    case 4: {
						if(bitem>TrunkInfo[idofcar][tGun][0]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во патронов Deagle, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва патронов Deagle","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 24, bitem);
						TrunkInfo[idofcar][tGun][0] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"патронов Deagle с багажника",bitem);
						SendUse(playerid,string);
		            }
                    case 5: {
						if(bitem>TrunkInfo[idofcar][tGun][1]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во патронов AK-47, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва патронов AK-47","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 30, bitem);
						TrunkInfo[idofcar][tGun][1] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"патронов AK-47 с багажника",bitem);
						SendUse(playerid,string);
		            }
                    case 6: {
						if(bitem>TrunkInfo[idofcar][tGun][2]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во патронов M4, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва патронов M4","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 31, bitem);
						TrunkInfo[idofcar][tGun][2] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"патронов M4 с багажника",bitem);
						SendUse(playerid,string);
		            }
                    case 7: {
						if(bitem>TrunkInfo[idofcar][tGun][3]) {
		                	return D(playerid,D_TRUNK_INPUT,DSI, ""P"Багажник",""W"Введите кол-во патронов ShotGun, которое хотите достать с багажника:\n\n"NO"*"G" В багажнике нет такого кол-ва патронов ShotGun","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 25, bitem);
						TrunkInfo[idofcar][tGun][3] -= bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы взяли "ORANGE"%d "G"патронов ShotGun с багажника",bitem);
						SendUse(playerid,string);
		            }
		            default: return true;
		        }
		        ApplyAnimation(playerid,"CRIB","CRIB_Use_Switch",4.0,0,0,0,0,0,0);
				SaveTrunk(idofcar);
		    }
		    else callcmd::trunk(playerid);
		}
		case D_TRUNK_PUT: {
		    if(response) {
		        if(!strlen(inputtext)) return callcmd::trunk(playerid);
		        new bitem = strval(inputtext),idofcar=idaofcar[playerid],string[156];
		        if(bitem<1)return callcmd::trunk(playerid),SendClientMessage(playerid,COLOR_RED,"Ошибка");
		        switch(nedded[playerid]) {
              		case 1: {
		                if((TrunkInfo[idofcar][tKanistra]+bitem)>2) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во канистр, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения канистр","Принять","Отмена");
						}
						if(bitem>PI[playerid][pFuel]) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во канистр, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько канистр","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pFuel]-=1;
						UpdatePlayerData(playerid,"pFuel",PI[playerid][pFuel]);
						TrunkInfo[idofcar][tKanistra]+=bitem;
						callcmd::trunk(playerid),SendUse(playerid,"Вы положили "ORANGE"1 "G"канистру в багажник");
		            }
              		case 2: {
		                if((TrunkInfo[idofcar][tDrugs]+bitem)>200) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во наркотиков, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения наркотиков","Принять","Отмена");
						}
						if(bitem>PI[playerid][pDrugs]) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во наркотиков, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько наркотиков","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pDrugs]-=bitem;
						TrunkInfo[idofcar][tNarko]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"наркотиков в багажник",bitem);
						SendUse(playerid,string);
		            }
                    case 3: {
		                if((TrunkInfo[idofcar][tMats]+bitem)>1000) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во боеприпасов, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения боеприпасов","Принять","Отмена");
						}
						if(bitem>PI[playerid][pMats]) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во боеприпасов, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько боеприпасов","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						PI[playerid][pMats]-=bitem;
						TrunkInfo[idofcar][tMats]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"боеприпасов в багажник",bitem);
						SendUse(playerid,string);
		            }
                    case 4: {
						if((TrunkInfo[idofcar][tGun][0]+bitem)>50) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов Deagle, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения патронов Deagle","Принять","Отмена");
						}
						if(GetPlayerWeapon(playerid) != 24 || GetPlayerAmmo(playerid) < bitem) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов Deagle, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько патронов Deagle","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 24, -bitem);
						TrunkInfo[idofcar][tGun][0]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"патронов Deagle в багажник",bitem);
						SendUse(playerid,string);
		            }
                    case 5: {
		                if((TrunkInfo[idofcar][tGun][1]+bitem)>50) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов AK-47, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения патронов AK-47","Принять","Отмена");
						}
						if(GetPlayerWeapon(playerid) != 30 || GetPlayerAmmo(playerid) < bitem) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов AK-47, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько патронов AK-47","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 30, -bitem);
						TrunkInfo[idofcar][tGun][1]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"патронов AK-47 в багажник",bitem);
						SendUse(playerid,string);
		            }
                    case 6: {
		                if((TrunkInfo[idofcar][tGun][2]+bitem)>50) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов M4, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения патронов M4","Принять","Отмена");
						}
						if(GetPlayerWeapon(playerid) != 31 || GetPlayerAmmo(playerid) < bitem) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов M4, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько патронов M4","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 31, -bitem);
						TrunkInfo[idofcar][tGun][2]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"патронов M4 в багажник",bitem);
						SendUse(playerid,string);
		            }
                    case 7: {
		                if((TrunkInfo[idofcar][tGun][3]+bitem)>50) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов ShotGun, которое хотите положить в багажника:\n\n"NO"*"G" В багажнике нет места для хранения патронов ShotGun","Принять","Отмена");
						}
						if(GetPlayerWeapon(playerid) != 25 || GetPlayerAmmo(playerid) < bitem) {
		                	return D(playerid,D_TRUNK_PUT,DSI, ""P"Багажник",""W"Введите кол-во патронов ShotGun, которое хотите положить в багажника:\n\n"NO"*"G" У Вас нет столько патронов ShotGun","Принять","Отмена");
						}
						if(!TrunkInfo[idofcar][tOpen] && idaofcar[playerid] != house_car[playerid][0] && idaofcar[playerid] != house_car[playerid][1]) return ErrorMessage(playerid, "Багажник закрыт"),trunk_close(playerid);
						AC_GivePlayerWeapon(playerid, 25, -bitem);
						TrunkInfo[idofcar][tGun][3]+=bitem;
						callcmd::trunk(playerid),format(string,sizeof(string),"Вы положили "ORANGE"%d "G"патронов ShotGun в багажник",bitem);
						SendUse(playerid,string);
		            }
		            default: idaofcar[playerid] = -1;
		        }
				SaveTrunk(idofcar);
		        ApplyAnimation(playerid,"CRIB","CRIB_Use_Switch",4.0,0,0,0,0,0,0);
		    }
		    else callcmd::trunk(playerid);
		}
		case D_NEWS: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					if(!TI[playerid][tEther]) {
						TI[playerid][tEther] = true;
						SendOk(playerid,"Вы в прямом эфире");
						PI[playerid][pSettings][2] = PI[playerid][pMember];
						save_settings(playerid);
						new string[24 + MAX_PLAYER_NAME];
						format(string,sizeof(string),"%s вышел(а) в прямой эфир",player_name[playerid]);
						SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
					}
					else {
						ether_closed(playerid);
						TI[playerid][tEther] = false;
						SendOk(playerid,"Вы вышли из прямого эфира");
						new string[23 + MAX_PLAYER_NAME];
						format(string,sizeof(string),"%s завершил(а) прямой эфир",player_name[playerid]);
						SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
					}
				}
				case 1: {
					new str[64];
					switch(PI[playerid][pMember]) {
						case fLSNEWS: {
							if(calls_news[0] == INVALID_PLAYER_ID) str = "Приём звонков - ["GREEN"Отсутствует"W"]";
							else format(str,sizeof(str),"Приём звонков - ["P"%s]",player_name[calls_news[0]]);
						}
						case fSFNEWS: {
							if(calls_news[1] == INVALID_PLAYER_ID) str = "Приём звонков - ["GREEN"Отсутствует"W"]";
							else format(str,sizeof(str),"Приём звонков - ["P"%s]",player_name[calls_news[1]]);
						}
						case fLVNEWS: {
							if(calls_news[2] == INVALID_PLAYER_ID) str = "Приём звонков - ["GREEN"Отсутствует"W"]";
							else format(str,sizeof(str),"Приём звонков - ["P"%s]",player_name[calls_news[2]]);
						}
					}
					new string[128];
					format(string,sizeof(string),""W"1. %s\n"W"2. Цена за звонки - ["GREEN"%d"W"]",str,FI[PI[playerid][pMember]][fPrice]);
					D(playerid,D_NEWS_ETHER, DSL, ""P"Меню эфира", string, "Далее", "Отмена");
				}
			}
		}
		case D_NEWS_ETHER: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					if(!TI[playerid][tEther]) return ErrorMessage(playerid,"Для приёма звонков необходимо находиться в прямом эфире");
					switch(PI[playerid][pMember]) {
						case fLSNEWS: {
							if(calls_news[0] == INVALID_PLAYER_ID) {
								calls_news[0] = playerid;
								new string[128];
								format(string,sizeof(string),"%s начал(а) приём звонков",player_name[playerid]);
								SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
							}
							else {
								if(calls_news[0] == playerid) {
									ether_closed(playerid);
								}
								else ErrorMessage(playerid,"Кто-то из сотрудников уже принимает звонки");
							}
						}
						case fSFNEWS: {
							if(calls_news[1] == INVALID_PLAYER_ID) {
								calls_news[1] = playerid;
								new string[128];
								format(string,sizeof(string),"%s начал(а) приём звонков",player_name[playerid]);
								SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
							}
							else {
								if(calls_news[1] == playerid) {
									ether_closed(playerid);
								}
								else ErrorMessage(playerid,"Кто-то из сотрудников уже принимает звонки");
							}
						}
						case fLVNEWS: {
							if(calls_news[2] == INVALID_PLAYER_ID) {
								calls_news[2] = playerid;
								new string[128];
								format(string,sizeof(string),"%s начал(а) приём звонков",player_name[playerid]);
								SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
							}
							else {
								if(calls_news[2] == playerid) {
									ether_closed(playerid);
								}
								else ErrorMessage(playerid,"Кто-то из сотрудников уже принимает звонки");
							}
						}
					}
				}
				case 1: {
					if(PI[playerid][pMember] < 9) return ErrorMessage(playerid,"Данная функция Вам недоступна");
					D(playerid,D_NEWS_ETHER_PRICE, DSI, ""P"Цена за звонки", ""W"Введите стоимость за звонки:", "Далее", "Отмена");
				}
			}
		}
		case D_NEWS_ETHER_PRICE: {
			if(!response) return 1;
			new price = strval(inputtext);
			if(price < 10 || price > 50) return D(playerid,D_NEWS_ETHER_PRICE,DSI, ""P"Цена за звонки",""W"Введите стоимость за звонки:\n\n"NO"*"G" От $10 до $50","Далее","Отмена");
			FI[PI[playerid][pMember]][fPrice] = price;
			new string[128];
			format(string,sizeof(string),"%s установил(а) цену звонков - %d",player_name[playerid],price);
			SendFamilyMessage(PI[playerid][pMember], 0x139BECFF, string);
		}
	 	case D_ADVERT_LIST: {
			if(!response) return 1;
		    SetPVarInt(playerid,"editadvert",listitem);
			new id = GetPVarInt(playerid,"editadvert");
			if(!gAdvert[listitem][adBusy] || gAdvert[listitem][adCheked] || gAdvert[listitem][adCheking]) return ShowAdvertList(playerid);
			gAdvert[listitem][adCheking] = true;
			SetPVarInt(playerid,"adchecking_fix",listitem+1);
			static const f_str[] = ""W"Отправитель: {33AA33}%s"W"\n\
				Текст: {FFD700}%s"W"\n\n\
				Для публикации объявления, нажмите: {73B461}'ОТПРАВИТЬ'"W"\n\
				Чтобы отклонить или отправить сообщение администрации, нажмите: {E11C1C}'РЕДАКТОР'";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 100)];

		    format(string,sizeof(string), f_str ,gAdvert[id][adSender],gAdvert[id][adText],gAdvert[id][adText]);
			D(playerid,D_ADVERT_LIST_EDIT,DSI, ""P"Редактирование",string,"Отправить","Редактор");
		}
		case D_ADVERT_LIST_2: {
			if(!response) {
				if(GetPVarInt(playerid,"adchecking_fix")) {
					gAdvert[GetPVarInt(playerid,"adchecking_fix")-1][adCheking]=false;
					DeletePVar(playerid,"adchecking_fix");
				}
				return 1;
			}
			DeletePVar(playerid,"adchecking_fix");
		    new id = GetPVarInt(playerid,"editadvert");
		    new player = GetCheckID(gAdvert[id][adSender]);

		    if(listitem == 1) {
				new string[143];
				format(string, sizeof(string), "[NEWS] %s[%d]: %s", gAdvert[id][adSender],gAdvert[id][adID], gAdvert[id][adText]);
				SendAdminMessage(0x008e8cff,string);
			}

		    static const f_str[] = "Ваше объявление было отклонено редактором: {33AA33}%s"G"";
		    new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 100)];
		    format(string,sizeof(string),f_str,player_name[playerid]);
			SendOk(player,string);

			strdel(gAdvert[id][adSender],0,24);
			gAdvert[id][adPhone] = 0;
			strdel(gAdvert[id][adText],0,100);
			gAdvert[id][adBusy] = false;
			gAdvert[id][adCheked] = false;
			gAdvert[id][adCheking] = false;
			if(gAdvertCount > 0) gAdvertCount--;
			return ShowAdvertList(playerid);
		}
		case D_ADVERT_LIST_EDIT: {
			if(!response) return D(playerid,D_ADVERT_LIST_2,DSL, ""P"Редактирование",""P"1."W" Отклонить объявление\n"P"2."W" Отклонить и отправить администрации","Выбрать","Отмена");
			new id = GetPVarInt(playerid,"editadvert");
            switch(PI[playerid][pMember]) {
                case fLSNEWS: gAdvert[id][adNews] = "LS";
                case fSFNEWS: gAdvert[id][adNews] = "SF";
                case fLVNEWS: gAdvert[id][adNews] = "LV";
            }
			if(strlen(inputtext)) format(gAdvert[id][adText],100,"%s",inputtext);
			format(gAdvert[id][adCheker],24,"%s",player_name[playerid]);

			FI[PI[playerid][pMember]][fBank] += gAdvert[id][adMoney];
			UpdateFraction(PI[playerid][pMember],"Bank",FI[PI[playerid][pMember]][fBank]);
			PI[playerid][pSalary] += 50;

            gAdvert[id][adTime] = gAdvertTime;
			gAdvertTime += 30;

			gAdvert[id][adCheking] = false;
			gAdvert[id][adCheked] = true;

			PI[playerid][pAdvert] ++;
			ShowAdvertList(playerid);
		}
	 	case D_ADVERT_START: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			new text[100];
			GetPVarString(playerid,"advert",text,100);
			DeletePVar(playerid,"advert");
			new price = GetPVarInt(playerid,"ad_price");
			DeletePVar(playerid,"ad_price");
			if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			gAdvertCount ++;
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			GiveMoney(playerid,-price,"подача объявления");
			gAdvert[slot][adMoney] = price;
			format(gAdvert[slot][adSender],24,"%s",player_name[playerid]);
			gAdvert[slot][adID] = playerid;
			gAdvert[slot][adPhone] = PI[playerid][pPhone];
			format(gAdvert[slot][adText],100,"%s",text);
			gAdvert[slot][adBusy] = true;
			gAdvert[slot][adTime] = gAdvertTime;
			if(PI[playerid][pVips] == VIP_ECSCLUSIVE || PI[playerid][pVips] == VIP_PLATINA) {
				gAdvert[slot][adVIP] = true;
			}
			gAdvertTime += 30;
			SetPVarInt(playerid, #pAdvertTime, gettime()+60);
			new mes[90];
			format(mes, sizeof mes, "[ ! ] Поступило новое объявление от %s | Отредактируйте: /edit", gAdvert[slot][adSender]);
			SendFamilyMessage(fLSNEWS, 0x139BECFF, mes);
			SendFamilyMessage(fSFNEWS, 0x139BECFF, mes);
			SendFamilyMessage(fLVNEWS, 0x139BECFF, mes);
			SendOk(playerid,"Объявление подано в редакцию. Ожидайте проверки");
		}
		case D_DJMSG: {
			if(response) {
				if(DJlvl[playerid] < 1 ) return 1;
				new string[144];
				switch(listitem)
				{
					case 0: {
						format(string, sizeof(string), "[DJ] Наслаждайтесь прямым эфиром от rDJ %s прямо сейчас! ", DJname[playerid]);
						SendClientMessageToAll(0xFFCD00AA,string);
						format(string, sizeof(string), "[DJ] Для прослушивания радио введите /play и подключитесь к Flame RADIO");
						SendClientMessageToAll(0xFFCD00AA,string);

					}
					case 1:{

						format(string, sizeof(string), "[DJ] Проводите время в удовольствие с нашей музыкой! Подключайтесь к нам /play > 1.Flame RADIO");
						SendClientMessageToAll(0xFFCD00AA,string);
					}
					case 2:
					{

						format(string, sizeof(string), "[DJ] Больше новостей и музыкальных постов, которых нигде нет! ВК: "RADIOVK_URL"");
						SendClientMessageToAll(0xFFCD00AA,string);
					}
					case 3:
					{

						format(string, sizeof(string), "[DJ] На форуме есть информация о стажировке на радио Flame FM. Успей подать свою заявку!");
						SendClientMessageToAll(0xFFCD00AA,string);
					}
					case 4:
					{

						format(string, sizeof(string), "[DJ] Хочешь стать радиоведущим? Обратись к главному администратору");
						SendClientMessageToAll(0xFFCD00AA,string);
					}
				}
				DJmsg = gettime()+600;
			}
		}
		case D_ADMIN_PANEL: {
			if(response) {
				if(PI[playerid][pAdmin] < 1 || dostup[playerid] == 0) return 1;
				switch(listitem) {
                	case 0: callcmd::admins(playerid);
					case 1: {
					    new params[5];

					    format(params, 4, "%d", playerid);

						callcmd::spawn(playerid, params);
					}
					case 2: D(playerid,D_JOB,DSL,""P"Трудоустройство",""W"1. Водитель автобуса\t\t| "P"2 лвл\n"W"2. Механик\t\t\t\t| "P"3 лвл\n"W"3. Развозчик еды\t\t\t| "P"3 лвл\n"W"4. Развозчик продуктов/топлива\t| "P"4 лвл\n"W"5. Мойщик дорог\t\t\t| "P"4 лвл\n"W"6. Газонокосильщик\t\t\t| "P"5 лвл", "Выбрать", "Закрыть");
					case 3: callcmd::jlist(playerid,"");
					case 4: callcmd::mutelist(playerid,"");
					case 5: PI[playerid][pAdmMSG] = (!PI[playerid][pAdmMSG])?(1):(0),UpdatePlayerData(playerid,"pAdmMSG",PI[playerid][pAdmMSG]),callcmd::apanel(playerid,"");
					case 6: {
						PI[playerid][pAdmKL] = (!PI[playerid][pAdmKL])?(1):(0),UpdatePlayerData(playerid,"pAdmKL",PI[playerid][pAdmKL]),callcmd::apanel(playerid,"");
						//for(new num; num < 10; num++) SendDeathMessageToPlayer(playerid,6000,5005, 255);
					}
					case 7: {
						if(PI[playerid][pAdmin] < 2 || dostup[playerid] == 0) return 1;
						new frac_online[MAX_FRACTIONS+1];
						foreach(new i:Player) {
							if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
							if(!PI[i][pMember]) continue;
							switch(PI[i][pMember]) {
								case fLSPD: frac_online[fLSPD] ++;
								case fSFPD: frac_online[fSFPD] ++;
								case fLVPD: frac_online[fLVPD] ++;
								case fFBI: frac_online[fFBI] ++;
								case fMAYOR: frac_online[fMAYOR] ++;
								case fARMYSF: frac_online[fARMYSF] ++;
								case fARMYLV: frac_online[fARMYLV] ++;
								case fMEDICLS: frac_online[fMEDICLS] ++;
								case fMEDICSF: frac_online[fMEDICSF] ++;
								case fMEDICLV: frac_online[fMEDICLV] ++;
								case fLSNEWS: frac_online[fLSNEWS] ++;
								case fSFNEWS: frac_online[fSFNEWS] ++;
								case fLVNEWS: frac_online[fLVNEWS] ++;
								case fLCN: frac_online[fLCN] ++;
								case fYAKUZA: frac_online[fYAKUZA] ++;
								case fRM: frac_online[fRM] ++;
								case fBALLAS: frac_online[fBALLAS] ++;
								case fVAGOS: frac_online[fVAGOS] ++;
								case fGROVE: frac_online[fGROVE] ++;
								case fAZTEC: frac_online[fAZTEC] ++;
								case fRIFA: frac_online[fRIFA] ++;
								case fWHITEHOUSE: frac_online[fWHITEHOUSE] ++;
							}
						}
						static const f_str[] = "Фракция\tИгроки\nПолиция ЛС\t%d\nПолиция СФ\t%d\nПолиция ЛВ\t%d\nФБР\t%d\n\
														Мэрия\t%d\nАрмия СФ\t%d\nАрмия ЛВ\t%d\n\
														Больница ЛС\t%d\nБольница СФ\t%d\nБольница ЛВ\t%d\n\
														Радиоцентр ЛС\t%d\nРадиоцентр СФ\t%d\nРадиоцентр ЛВ\t%d\n\
														Итальянская мафия\t%d\nЯпонская мафия\t%d\n\
														Русская мафия\t%d\nThe Ballas\t%d\nThe Vagos\t%d\n\
														The Grove\t%d\nThe Aztec\t%d\nThe Rifa\t%d\nПравительство\t%d";
						new string[sizeof(f_str) +1 + (30)];
						format(string,sizeof(string),f_str,frac_online[fLSPD],frac_online[fSFPD],frac_online[fLVPD],frac_online[fFBI],frac_online[fMAYOR],frac_online[fARMYSF],frac_online[fARMYLV],frac_online[fMEDICLS],frac_online[fMEDICSF],frac_online[fMEDICLV],
															frac_online[fLSNEWS],frac_online[fSFNEWS],frac_online[fLVNEWS],frac_online[fLCN],frac_online[fYAKUZA],frac_online[fRM],frac_online[fBALLAS],frac_online[fVAGOS],frac_online[fGROVE],
															frac_online[fAZTEC],frac_online[fRIFA],frac_online[fWHITEHOUSE]);
						D(playerid, D_AMEMBERS, DSTH, "Онлайн организаций", string, "Закрыть", "");

					}
					case 8: {
						if(PI[playerid][pAdmin] < 2 || dostup[playerid] == 0) return 1;
						if(!IsPlayerInAnyVehicle(playerid)) return ErrorMessage(playerid,"Вы не в автомобиле"),callcmd::apanel(playerid,"");
						callcmd::hp(playerid);
					}
					case 9: callcmd::awarehouse(playerid,"");
					case 10: {
						if(PI[playerid][pAdmin] < 3 || dostup[playerid] == 0) return 1;
						new year[8], month[8], day[8], hour[8], minute[8], second[8];
						if(fracmoroz[0] >= unix) {
							timestamp_to_date(fracmoroz[0]-unix, year[0], month[0], day[0], hour[0], minute[0], second[0]);
						}
						else hour[0] = minute[0] = second[0] = 0;
						if(fracmoroz[1] >= unix) {
							timestamp_to_date(fracmoroz[1]-unix, year[1], month[1], day[1], hour[1], minute[1], second[1]);
						}
						else hour[1] = minute[1] = second[1] = 0;
						if(fracmoroz[2] >= unix) {
							timestamp_to_date(fracmoroz[2]-unix, year[2], month[2], day[2], hour[2], minute[2], second[2]);
						}
						else hour[2] = minute[2] = second[2] = 0;
						if(fracmoroz[3] >= unix) {
							timestamp_to_date(fracmoroz[3]-unix, year[3], month[3], day[3], hour[3], minute[3], second[3]);
						}
						else hour[3] = minute[3] = second[3] = 0;
						if(fracmoroz[4] >= unix) {
							timestamp_to_date(fracmoroz[4]-unix, year[4], month[4], day[4], hour[4], minute[4], second[4]);
						}
						else hour[4] = minute[4] = second[4] = 0;
						if(fracmoroz[5] >= unix) {
							timestamp_to_date(fracmoroz[5]-unix, year[5], month[5], day[5], hour[5], minute[5], second[5]);
						}
						else hour[5] = minute[5] = second[5] = 0;
						if(fracmoroz[6] >= unix) {
							timestamp_to_date(fracmoroz[6]-unix, year[6], month[6], day[6], hour[6], minute[6], second[6]);
						}
						else hour[6] = minute[6] = second[6] = 0;
						if(fracmoroz[7] >= unix) {
							timestamp_to_date(fracmoroz[7]-unix, year[7], month[7], day[7], hour[7], minute[7], second[7]);
						}
						else hour[7] = minute[7] = second[7] = 0;
						static const f_str[] = ""P"1."W" The Ballas\t\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"2."W" The Vagos\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"3."W" The Grove\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"4."W" The Rifa\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"5."W" The Aztec\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"6."W" Итальянская мафия\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"7."W" Японская мафия\t\t"ORANGE"%dч %dмин %dсек\n\
												"P"8."W" Русская мафия\t\t\t"ORANGE"%dч %dмин %dсек";
						new string[sizeof(f_str) + 90];
						format(string,sizeof(string),f_str,hour[0], minute[0], second[0],hour[1], minute[1], second[1],hour[2], minute[2], second[2],hour[3], minute[3], second[3],
															hour[4], minute[4], second[4],hour[5], minute[5], second[5],hour[6], minute[6], second[6],hour[7], minute[7], second[7]);
						D(playerid,DIALOG_NONE,DST, "Информация о заморозках", string, "Закрыть", "");
					}
					case 11: {
						if(PI[playerid][pAdmin] < 4 || dostup[playerid] == 0) return 1;
						new names[MAX_PLAYER_NAME + 1],string[450],rows;
					    new Cache:result = mysql_query(connects, "SELECT `Name` FROM `ban` ORDER BY `ID` DESC LIMIT 0 , 20");
					    cache_get_row_count(rows);
					    if(rows == 0) return SendClientMessage(playerid, COLOR_GREY, "Список забаненных пуст");
					    FirstBL[playerid] = 0;
					    for(new i; i < rows; i ++) {
						    cache_get_value_name(i, "Name", names, MAX_PLAYER_NAME);
					        format(string, sizeof(string), "%s%s\n", string, names);
					    }
					    if(rows == 20) format(string, sizeof(string), "%s{1965D9}Далее >>>\n", string);
						cache_delete(result);
					    if(!D(playerid, D_BAN_LIST, DSL, ""P"Забаненые", string, "Выбрать", "Назад"))SendClientMessage(playerid, COLOR_GREY, "Недоступно в данный момент.");
					}
					case 12: {
						new string[1600],id = 0;
						string = ""P"Ник:\t"P"IP при регистрации\t"P"IP\n";
						new count;
						foreach(new i:Player) {
							count++;
							if(count > 20) break;
							if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
							if(!GetString(player_ip[i],PI[i][pIpReg])) format(string, sizeof(string), "%s"W"%s\tL-IP: %s\tR-IP: %s\n", string, player_name[i],PI[i][pIpReg],player_ip[i]),id++;
						}
						if(id == 0) return ErrorMessage(playerid,"Не найдено");
						else D(playerid, DIALOG_NONE, DSTH, ""P"Возможно взломаны", string, "Закрыть", "");
					}
					case 13: duels = (!duels)?(1):(0),UpdateOtherData("duels",casino),callcmd::apanel(playerid,"");
					case 14:
					{
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0)
							return 1;

						return dialog_anticheat(playerid);
					}
					case 15: {
						if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return 1;
						casino = (!casino)?(1):(0),UpdateOtherData("casino",casino),callcmd::apanel(playerid,"");
					}
					case 16: {
						if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return 1;
						rep_system = (!rep_system)?(1):(0),UpdateOtherData("rep_system",casino),callcmd::apanel(playerid,"");
					}
					case 17: {
						if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return 1;
						FI[fBALLAS][fMats] = 300000,UpdateFraction(fBALLAS,"Mats",FI[fBALLAS][fMats]);
						FI[fVAGOS][fMats] = 300000,UpdateFraction(fVAGOS,"Mats",FI[fVAGOS][fMats]);
						FI[fGROVE][fMats] = 300000,UpdateFraction(fGROVE,"Mats",FI[fGROVE][fMats]);
						FI[fAZTEC][fMats] = 300000,UpdateFraction(fAZTEC,"Mats",FI[fAZTEC][fMats]);
						FI[fRIFA][fMats] = 300000,UpdateFraction(fRIFA,"Mats",FI[fRIFA][fMats]);

						FI[fLCN][fMats] = 300000,UpdateFraction(fLCN,"Mats",FI[fLCN][fMats]);
						FI[fYAKUZA][fMats] = 300000,UpdateFraction(fYAKUZA,"Mats",FI[fYAKUZA][fMats]);
						FI[fRM][fMats] = 300000,UpdateFraction(fRM,"Mats",FI[fRM][fMats]);
						SendOk(playerid,"Склады банд/мафий успешно пополнены");
					}
					case 18: {
						if(PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) return 1;
						static const f_str[] =  ""P"Орагнизация\t"P"Уровень вступления\nПолиция\t%d\nФБР\t%d\nАрмии\t%d\nБольница\t%d\nНовости\t%d\nМафии\t%d\nБанды\t%d\nПравительство\t%d";
						new string[sizeof(f_str) +19];
						format(string,sizeof(string),f_str,invite_frac[0],invite_frac[1],invite_frac[2],invite_frac[3],invite_frac[4],invite_frac[5],invite_frac[6],invite_frac[7]);
						return D(playerid,D_ADMIN_INVITE,DSTH,""P"Ограничение Invite",string,"Выбрать","Закрыть");
					}
					case 19: {
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return 1;
						static const f_str[] = ""W"Оружейный завод - Порт г. СФ\t\t\t"ORANGE"$%d\n\
												"W"Лесопилка - Порт г. СФ\t\t"ORANGE"$%d\n\
												"W"Лесопилка - Порт г. ЛС\t\t\t"ORANGE"$%d\n\
												"W"Лесопилка - Оружейный завод\t\t\t"ORANGE"$%d";
						new string[sizeof(f_str) + 40];
						format(string,sizeof(string),f_str,tk_unloading[0],tk_unloading[1],tk_unloading[2],tk_unloading[3]);
						D(playerid,D_ADMIN_TK,DST, "Дальнобойщики", string, "Изменить", "Отмена");
					}
					case 20: {
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return 1;
						D(playerid, D_CREATE_PROMO, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Вам необходимо придумать промокод\nДлина промокода должна быть от 4 до 32 символов, состоящая из цифр и букв латинского алфавита\n\nВведите промокод в строчку ниже:", !"Далее", !"Закрыть");
					}
					case 21: {
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return 1;
						new str[3][20] = {"Отключены","Только для новичков","Для всех"};
						static const f_str[] = "Бонусы\t\t\t"P"[%s]"W"\n\
												Ограничение по уровню новичков\t\t"P"[%d уровень]"W"\n\
												Управление бонусами";
						new string[sizeof(f_str) + 90];
						format(string,sizeof(string),f_str,str[BonusInfo[act_select]],BonusInfo[act_level]);
						D(playerid,D_ADMIN_OSNOVA,DST, "Бонусы", string, "Выбрать", "Отмена");
					}
					case 22: {
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return 1;
						for(new i = 0; i < gBusinessCount; i ++) {
							if(gBusiness[i][bizzProdOrder] == 0) continue;
							gBusiness[i][bizzProduct] += gBusiness[i][bizzProdOrder];
							gBusiness[i][bizzProdOrder] = 0;
							gBusiness[i][bizzProdOrderPrice] = 0;
						}
						SendOk(playerid,"Продукты по бизнесам доставлены");
					}
					case 23: {
						if(PI[playerid][pAdmin] < 6 || dostup[playerid] == 0) return 1;
						anti_tk = (!anti_tk)?(1):(0),UpdateOtherData("anti_tk",anti_tk),callcmd::apanel(playerid,"");
					}
				}
			}
		}
		case D_ADMIN_INVITE: {
			if(!response) return 1;
			SetPVarInt(playerid,"invite_admin",listitem);
			D(playerid,D_ADMIN_INVITE_2,DSI, ""P"Ограничение Invite","\n\n"W"Введите ограничение на INVITE игроков в организацию:\n\n"NO"*"G" От 1 до 8\n\n","Изменить", "Отмена");
		}
		case D_ADMIN_INVITE_2: {
			if(!response) return DeletePVar(playerid,"invite_admin");
			if(strval(inputtext) < 1 || strval(inputtext) > 8) {
				D(playerid,D_ADMIN_INVITE_2,DSI, ""P"Ограничение Invite","\n\n"W"Введите ограничение на INVITE игроков в организацию:\n\n"NO"*"G" От 1 до 8\n\n","Изменить", "Отмена");
				return 1;
			}
			invite_frac[GetPVarInt(playerid,"invite_admin")] = strval(inputtext);

			new query[90];
			format(query,sizeof(query),"UPDATE `others` SET `invite_frac%d` = '%d' LIMIT 1",GetPVarInt(playerid,"invite_admin"),invite_frac[GetPVarInt(playerid,"invite_admin")]);
			mysql_tquery(connects, query);

			DeletePVar(playerid,"invite_admin");
			SendOk(playerid,"Ограничение установлено");
		}
     	case D_ADMIN_OSNOVA: {
     		if(!response) return 1;
            switch(listitem) {
				case 0: {
					BonusInfo[act_select] = (BonusInfo[act_select] == 0) ? 1 : (BonusInfo[act_select] == 1) ? 2 : 0;
					UpdateBonuses("act_select",BonusInfo[act_select]);
					if(!BonusInfo[act_select]) SendRconCommand("hostname Flame RolePlay | Открытое Бета Тестирование");
					else if(BonusInfo[act_select] == 1) SendRconCommand("hostname Flame RolePlay | Действует акция");
					else SendRconCommand("hostname Flame RolePlay | Действует акция");
				}
				case 1: {
					BonusInfo[act_level] = (BonusInfo[act_level] == 3) ? 5 : (BonusInfo[act_level] == 5) ? 7 : 3;
					UpdateBonuses("act_level",BonusInfo[act_level]);
				}
				case 2: return dialog_bonuses(playerid);
            }
			new str[3][20] = {"Отключены","Только для новичков","Для всех"};
			static const f_str[] = "Бонусы\t\t\t"P"[%s]"W"\n\
									Ограничение по уровню новичков\t\t"P"[%d уровень]"W"\n\
									Управление бонусами";
			new string[sizeof(f_str) + 90];
			format(string,sizeof(string),f_str,str[BonusInfo[act_select]],BonusInfo[act_level]);
			D(playerid,D_ADMIN_OSNOVA,DST, "Бонусы", string, "Выбрать", "Отмена");
		}
		case D_BONUSES: {
     		if(!response) return 1;
            switch(listitem) {
				case 0: {
					BonusInfo[act_exp] = (BonusInfo[act_exp] == 1) ? 2 : (BonusInfo[act_exp] == 2) ? 3 : 1;
					UpdateBonuses("act_exp",BonusInfo[act_exp]);
				}
				case 1: {
					BonusInfo[act_skill] = (BonusInfo[act_skill] == 1) ? 2 : (BonusInfo[act_skill] == 2) ? 3 : 1;
					UpdateBonuses("act_skill",BonusInfo[act_skill]);
				}
				case 2: {
					BonusInfo[act_sport] = (BonusInfo[act_sport] == 1) ? 2 : (BonusInfo[act_sport] == 2) ? 3 : 1;
					UpdateBonuses("act_sport",BonusInfo[act_sport]);
				}
				case 3: {
					BonusInfo[act_mp] = (BonusInfo[act_mp] == 1) ? 2 : (BonusInfo[act_mp] == 2) ? 3 : 1;
					UpdateBonuses("act_mp",BonusInfo[act_mp]);
				}
				case 4: {
					BonusInfo[act_gun] = (BonusInfo[act_gun] == 1) ? 2 : (BonusInfo[act_gun] == 2) ? 3 : 1;
					UpdateBonuses("act_gun",BonusInfo[act_gun]);
				}
				case 5: {
					BonusInfo[act_fish] = (BonusInfo[act_fish] == 1) ? 2 : (BonusInfo[act_fish] == 2) ? 3 : 1;
					UpdateBonuses("act_fish",BonusInfo[act_fish]);
				}
				case 6: {
					BonusInfo[act_renthotel] = (BonusInfo[act_renthotel] == 0) ? 3 : (BonusInfo[act_renthotel] == 3) ? 5 : (BonusInfo[act_renthotel] == 5) ? 10 : 0;
					UpdateBonuses("act_renthotel",BonusInfo[act_renthotel]);
				}
				case 7: {
					BonusInfo[act_buyskin] = (BonusInfo[act_buyskin] == 0) ? 3 : (BonusInfo[act_buyskin] == 3) ? 5 : (BonusInfo[act_buyskin] == 5) ? 10 : 0;
					UpdateBonuses("act_buyskin",BonusInfo[act_buyskin]);
				}
				case 8: {
					BonusInfo[act_buycar] = (BonusInfo[act_buycar] == 0) ? 3 : (BonusInfo[act_buycar] == 3) ? 5 : (BonusInfo[act_buycar] == 5) ? 10 : 0;
					UpdateBonuses("act_buycar",BonusInfo[act_buycar]);
				}
				case 9: {
					BonusInfo[act_rentcar] = (BonusInfo[act_rentcar] == 0) ? 3 : (BonusInfo[act_rentcar] == 3) ? 5 : (BonusInfo[act_rentcar] == 5) ? 10 : 0;
					UpdateBonuses("act_rentcar",BonusInfo[act_rentcar]);
				}
				case 10: {
					BonusInfo[act_buylic] = (BonusInfo[act_buylic] == 0) ? 3 : (BonusInfo[act_buylic] == 3) ? 5 : (BonusInfo[act_buylic] == 5) ? 10 : 0;
					UpdateBonuses("act_buylic",BonusInfo[act_buylic]);
				}
				case 11: {
					BonusInfo[act_buyimprove] = (BonusInfo[act_buyimprove] == 0) ? 3 : (BonusInfo[act_buyimprove] == 3) ? 5 : (BonusInfo[act_buyimprove] == 5) ? 10 : 0;
					UpdateBonuses("act_buyimprove",BonusInfo[act_buyimprove]);
				}
				case 12: {
					BonusInfo[act_disease] = (BonusInfo[act_disease] == 0) ? 3 : (BonusInfo[act_disease] == 3) ? 5 : (BonusInfo[act_disease] == 5) ? 10 : 0;
					UpdateBonuses("act_disease",BonusInfo[act_disease]);
				}
				case 13: {
					BonusInfo[act_changesex] = (BonusInfo[act_changesex] == 0) ? 3 : (BonusInfo[act_changesex] == 3) ? 5 : (BonusInfo[act_changesex] == 5) ? 10 : 0;
					UpdateBonuses("act_changesex",BonusInfo[act_changesex]);
				}
				case 14: {
					BonusInfo[act_medcard] = (BonusInfo[act_medcard] == 0) ? 3 : (BonusInfo[act_medcard] == 3) ? 5 : (BonusInfo[act_medcard] == 5) ? 10 : 0;
					UpdateBonuses("act_medcard",BonusInfo[act_medcard]);
				}
				case 15: {
					BonusInfo[act_buynubmbercar] = (BonusInfo[act_buynubmbercar] == 0) ? 3 : (BonusInfo[act_buynubmbercar] == 3) ? 5 : (BonusInfo[act_buynubmbercar] == 5) ? 10 : 0;
					UpdateBonuses("act_buynubmbercar",BonusInfo[act_buynubmbercar]);
				}
				case 16: {
					BonusInfo[act_perfomance] = (BonusInfo[act_perfomance] == 0) ? 3 : (BonusInfo[act_perfomance] == 3) ? 5 : (BonusInfo[act_perfomance] == 5) ? 10 : 0;
					UpdateBonuses("act_perfomance",BonusInfo[act_perfomance]);
				}
				case 17: {
					BonusInfo[act_tune] = (BonusInfo[act_tune] == 0) ? 3 : (BonusInfo[act_tune] == 3) ? 5 : (BonusInfo[act_tune] == 5) ? 10 : 0;
					UpdateBonuses("act_tune",BonusInfo[act_tune]);
				}
				case 18: {
					BonusInfo[act_payday] = (BonusInfo[act_payday] == 1) ? 2 : (BonusInfo[act_payday] == 2) ? 3 : 1;
					UpdateBonuses("act_payday",BonusInfo[act_payday]);
				}
				case 19: {
					BonusInfo[act_donate] = (BonusInfo[act_donate] == 1) ? 2 : (BonusInfo[act_donate] == 2) ? 3 : 1;
					UpdateBonuses("act_donate",BonusInfo[act_donate]);
				}
            }
			dialog_bonuses(playerid);
		}
		case D_ADMIN_TK: {
     		if(!response) return 1;
            switch(listitem) {
				case 0: {
					static const f_str[] = "\n\n"W"Заработная плата на рейсе [Оружейный завод - Порт г. СФ]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,tk_unloading[0]);
					D(playerid,D_ADMIN_TK_1,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
					return 1;
				}
				case 1: {
					static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Порт г. СФ]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,tk_unloading[1]);
					D(playerid,D_ADMIN_TK_2,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
					return 1;
				}
				case 2: {
					static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Порт г. ЛС]: "ORANGE"$%d\n\
												Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,tk_unloading[2]);
					D(playerid,D_ADMIN_TK_3,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
					return 1;
				}
				case 3: {
					static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Оружейный завод]: "ORANGE"$%d\n\
												Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,tk_unloading[3]);
					D(playerid,D_ADMIN_TK_4,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
					return 1;
				}
            }
		}
		case D_ADMIN_TK_1: {
			if(!response) return 1;
			new salary = strval(inputtext);
			if(salary < 0 || salary > 1000) {
				static const f_str[] = "\n\n"W"Заработная плата на рейсе [Оружейный завод - Порт г. СФ]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,tk_unloading[0]);
				D(playerid,D_ADMIN_TK_1,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
				return 1;
			}
			tk_unloading[0] = salary;
			UpdateOtherData("tk_unloading_0",tk_unloading[0]);
			SendOk(playerid,"Изменено");
			callcmd::apanel(playerid,"");
			return 1;
		}
		case D_ADMIN_TK_2: {
			if(!response) return 1;
			new salary = strval(inputtext);
			if(salary < 0 || salary > 1000) {
				static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Порт г. СФ]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,tk_unloading[1]);
				D(playerid,D_ADMIN_TK_2,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
				return 1;
			}
			tk_unloading[1] = salary;
			UpdateOtherData("tk_unloading_1",tk_unloading[1]);
			SendOk(playerid,"Изменено");
			callcmd::apanel(playerid,"");
			return 1;
		}
		case D_ADMIN_TK_3: {
			if(!response) return 1;
			new salary = strval(inputtext);
			if(salary < 0 || salary > 1000) {
				static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Порт г. ЛС]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,tk_unloading[2]);
				D(playerid,D_ADMIN_TK_3,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
				return 1;
			}
			tk_unloading[2] = salary;
			UpdateOtherData("tk_unloading_2",tk_unloading[2]);
			SendOk(playerid,"Изменено");
			callcmd::apanel(playerid,"");
			return 1;
		}
		case D_ADMIN_TK_4: {
			if(!response) return 1;
			new salary = strval(inputtext);
			if(salary < 0 || salary > 1000) {
				static const f_str[] = "\n\n"W"Заработная плата на рейсе [Лесопилка - Оружейный завод]: "ORANGE"$%d\n\
											Установите новую заработную плату:\n\n"NO"*"G" От $0 до $1000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,tk_unloading[3]);
				D(playerid,D_ADMIN_TK_4,DSI, ""P"Дальнобойщики",string,"Изменить", "Отмена");
				return 1;
			}
			tk_unloading[3] = salary;
			UpdateOtherData("tk_unloading_3",tk_unloading[3]);
			SendOk(playerid,"Изменено");
			callcmd::apanel(playerid,"");
			return 1;
		}
		case D_ANTICHEAT: {
			if(!response) return 1;
			AntiCheat[listitem][acValue] = (AntiCheat[listitem][acValue] == 0) ? 1 : (AntiCheat[listitem][acValue] == 1) ? 2 : 0;
			dialog_anticheat(playerid);
			new query[74];
			format(query,sizeof(query),"UPDATE `anticheats` SET `cheatvalue` = '%d' WHERE `chID` = '%d' LIMIT 1",AntiCheat[listitem][acValue],listitem+1);
			mysql_tquery(connects, query);
		}
		case D_TP_LIST: {
	        if(!response) return 1;
			string_1024[0] = EOS;
			for(new i = 0; i < MAX_TELEPORTS; i++)
			{
				if(TPLIST[i][tList] != listitem) continue;
				format(string_1024, sizeof(string_1024), "%s%s\n", string_1024, TPLIST[i][tName]);
			}
			D(playerid, D_TP_LIST_2, DSL,""P"Телепорт", string_1024, "Выбрать", "Отмена");
			SetPVarInt(playerid,"adm_tp",listitem);
		}
		case D_TP_LIST_2: {
			if(!response) return 1;
			new list = GetPVarInt(playerid,"adm_tp"),lis;
			switch(list) {
				case 0: lis = listitem;
				case 1: lis = (listitem+22);
				case 2: lis = (listitem+31);
				case 3: lis = (listitem+34);
				case 4: lis = (listitem+37);
				case 5: lis = (listitem+45);
				case 6: lis = (listitem+48);
			}
			if(GetPlayerState(playerid) == 2) {
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, TPLIST[lis][tPos][0],TPLIST[lis][tPos][1],TPLIST[lis][tPos][2]);
			}
			else {
				SetPlayerPosAC(playerid, TPLIST[lis][tPos][0],TPLIST[lis][tPos][1],TPLIST[lis][tPos][2], 0, 0);
			}
		}
  		case D_OBC_LIST: {
		    if(!response) return 1;
		    switch(listitem) {
		        case 0: {
		            new total_player_online = 0;
		            tick_wanted{total_player_online} = 0;
		            static const dialog_put_fmt[] = "%s\t%i\n";

					const string_length =
						sizeof(dialog_put_fmt) + 1 +
						(- 2 + MAX_PLAYER_NAME) + // Имя игрока
						(- 2 + 1);  // Уровень розыска

					goto skip_array_init;
					new onestring[(string_length * 30) / 4],
						tempstring[string_length];
					skip_array_init:

					new Float:pos[3];
            		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);

					onestring = !""W"Имя игрока\t"W"Уровень розыска\n";
		            foreach(new i:Player) {
		            	if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(PI[i][pSearch] > 0) {
							if(!IsPlayerInRangeOfPoint(i, 200.0, pos[0],pos[1],pos[2])) continue;
							format(tempstring, sizeof(tempstring), dialog_put_fmt, player_name[i], PI[i][pSearch]);
							strcat(onestring, tempstring);
							tick_wanted{total_player_online} = i;
							total_player_online = total_player_online + 1;
						}
					}
		            if(!total_player_online) return ErrorMessage(playerid,"Преступников в радиусе 200 метров не обнаружено");
		            return D(playerid,D_OBC_WANTED,DSTH,"Бортовой компьютер",onestring,"Выбрать","Отмена");
				}
				case 1: D(playerid, D_OBC_BD, DSL, ""P"База данных", ""P"1."W" Пробить по имени\n"P"2."W" Пробить по гос. номеру авто", "Выбрать", "Отмена");
				case 2: {
					new Float:pos[3];
            		GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
					new bool:callers = false;
					new string[700],str[30];
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!GetPVarInt(i,"call_police")) continue;
						if(!IsPlayerInRangeOfPoint(i, 1000.0, pos[0],pos[1],pos[2])) continue;
						format(str,sizeof(str),"%s\n",player_name[i]),strcat(string,str);
						callers = true;
					}
					if(!callers) return ErrorMessage(playerid,"Вызовы не поступали");
					D(playerid,D_OBC_SERVICESS,DSL,""P"Поступившие вызовы",string,"Выбрать","Отмена");
				}
		    }
		}
		case D_OBC_BD: {
			if(!response) return callcmd::obc(playerid);
			switch(listitem) {
				case 0: D(playerid,D_OBC_BD_NAME,DSI, ""P"База данных","\n\n"W"Введите ник игрока:\n\n","Выбрать","Отмена");
				case 1: D(playerid,D_OBC_BD_NUMBER,DSI, ""P"База данных","\n\n"W"Введите гос. номер автомобиля:\n"G"Примечание: X XXX XX - формат номера\n\n","Выбрать","Отмена");
			}
		}
		case D_OBC_BD_NAME: {
			if(!response) return callcmd::obc(playerid);
			if(strval(inputtext) >= 0 && strval(inputtext) < MAX_PLAYERS) {
		        if(!IsPlayerConnected(strval(inputtext))) return ErrorMessage(playerid,"Игрок не найден");
			}
		    if(GetPlayerID(inputtext) == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Игрок не найден");
			new id = GetPlayerID(inputtext);
			if(PI[id][pSearch] == 0) return ErrorMessage(playerid,"Человек не имеет розыска");
			static const f_str[] = ""W"Имя игрока:\t\t\t"YELLOW"%s\n\n\
				"W"Уровень розыска:\t\t"P"%d\n\
				"W"Сообщил:\t\t\t"P"%s\n\
				"W"Причина:\t\t\t"P"%s";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 2) + (-2 + MAX_PLAYER_NAME) + (-2 + 42)];
			format(string,sizeof(string), f_str, player_name[id], PI[id][pSearch], PI[id][pVictim],PI[id][pAccusedof]);
			D(playerid,DIALOG_NONE,DSM, ""P"База данных",string,"Закрыть","");
		}
		case D_OBC_BD_NUMBER: {
			if(!response) return callcmd::obc(playerid);
			if(strval(inputtext) != 7) return D(playerid,D_OBC_BD_NUMBER,DSI, ""P"База данных","\n\n"W"Введите гос. номер автомобиля:\n"G"Примечание: X XXX XX - формат номера\n\n","Выбрать","Отмена");
			new query[128];
			mysql_format(connects,query, sizeof(query), "SELECT HIGH_PRIORITY * FROM `"TABLE_CARS"` WHERE `number`='%e'",inputtext);
	        mysql_tquery(connects,query,"ShowNumber","ds",playerid,inputtext);
		}
		case D_OBC_SERVICESS: {
			if(!response) return 1;
			SetPVarInt(playerid,"police_id",GetPlayerID(inputtext));
			new str[190];
			format(str,sizeof(str),"\t"YELLOW"==== ИНФОРМАЦИЯ ====\n\n\
									"W"Имя: "P"%s\n\
									"W"Расстояние: "P"%.2f метров\n\n\
									"W"Вы действительно хотите принять вызов?",inputtext,GetDistanceBetweenPlayers(playerid,GetPlayerID(inputtext)));
			D(playerid, D_OBC_SERVICESS_INV, DSM, ""P"Вызов", str, "Принять", "Отмена");
		}
		case D_OBC_SERVICESS_INV: {
			if(!response) return DeletePVar(playerid,"police_id"),callcmd::obc(playerid);
			DeletePVar(GetPVarInt(playerid,"police_id"),"call_police");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(GetPVarInt(playerid,"police_id"), X, Y, Z);
			EnableGPSForPlayer(playerid, X, Y, Z);
			SendOk(playerid,"Вызов принят. Местоположение указано на вашей карте");
			SendOk(GetPVarInt(playerid,"police_id"),"Полицейский принял Ваш вызов. Для быстрого нахождения Вас полицейским, оставайтесь на данном месте");
		}
		case D_OBC_WANTED: {
		    if(!response) return 1;
		    patrul_id[playerid] = tick_wanted{listitem};

		    static const f_str[] = ""W"Имя игрока:\t\t\t"YELLOW"%s\n\n\
				"W"Уровень розыска:\t\t"P"%d\n\
				"W"Сообщил:\t\t\t"P"%s\n\
				"W"Причина:\t\t\t"P"%s";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 2) + (-2 + MAX_PLAYER_NAME) + (-2 + 32)];
			format(string,sizeof(string), f_str, player_name[patrul_id[playerid]], PI[patrul_id[playerid]][pSearch], PI[patrul_id[playerid]][pVictim],PI[patrul_id[playerid]][pAccusedof]);
			D(playerid,D_OBC_PATRUL,DSM, ""P"Бортовой компьютер",string,"Слежка","Назад");
		}
		case D_OBC_PATRUL: {
		    if(!response) return callcmd::obc(playerid);
      		if(GetPlayerInterior(patrul_id[playerid]) != 0) return ErrorMessage(playerid,"Не удалось обнаружить цель (объект в здании)");
			if(patrul_id[playerid] == playerid) return ErrorMessage(playerid,"Вы не можете начать слежку за собой");

			static const f_str[] = ""W"[ПАТРУЛИРОВАНИЕ]"G" %s(%d) начал преследование за %s";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 4) + (-2 + MAX_PLAYER_NAME)];

			format(string, sizeof(string), f_str, player_name[playerid],playerid,player_name[patrul_id[playerid]]);
			SendFamilyMessage(PI[playerid][pMember], 0x99CC00FF, string);

			SetPVarInt(playerid,"Patrul",1);
			time_wanted[playerid] = SetTimerEx("CopsWanted",3000,true,"ff",playerid,patrul_id[playerid]);
		}
		case D_MEDICS: {
			if(!response) return 1;
			SetPVarInt(playerid,"medic_id",GetPlayerID(inputtext));
			new str[190];
			format(str,sizeof(str),"\t"YELLOW"==== ИНФОРМАЦИЯ ====\n\n\
									"W"Имя: "P"%s\n\
									"W"Расстояние: "P"%.2f метров\n\n\
									"W"Вы действительно хотите принять вызов?",inputtext,GetDistanceBetweenPlayers(playerid,GetPlayerID(inputtext)));
			D(playerid, D_MEDICS_INV, DSM, ""P"Вызов", str, "Принять", "Отмена");
		}
		case D_MEDICS_INV: {
			if(!response) return DeletePVar(playerid,"medic_id"),callcmd::obc(playerid);
			DeletePVar(GetPVarInt(playerid,"medic_id"),"call_medics");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(GetPVarInt(playerid,"medic_id"), X, Y, Z);
			EnableGPSForPlayer(playerid, X, Y, Z);
			SendOk(playerid,"Вызов принят. Местоположение указано на карте");
			SendOk(GetPVarInt(playerid,"medic_id"),"Медик принял Ваш вызов. Для быстрого нахождения Вас медиком, оставайтесь на данном месте");
		}
		case D_REPAIRS: {
			if(!response) return 1;
			SetPVarInt(playerid,"repair_id",GetPlayerID(inputtext));
			new str[190];
			format(str,sizeof(str),"\t"YELLOW"==== ИНФОРМАЦИЯ ====\n\n\
									"W"Имя: "P"%s\n\
									"W"Расстояние: "P"%.2f метров\n\n\
									"W"Вы действительно хотите принять вызов?",inputtext,GetDistanceBetweenPlayers(playerid,GetPlayerID(inputtext)));
			D(playerid, D_REPAIRS_INV, DSM, ""P"Вызов", str, "Принять", "Отмена");
		}
		case D_REPAIRS_INV: {
			if(!response) return DeletePVar(playerid,"repair_id"),callcmd::obc(playerid);
			DeletePVar(GetPVarInt(playerid,"repair_id"),"call_mechanics");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(GetPVarInt(playerid,"repair_id"), X, Y, Z);
			EnableGPSForPlayer(playerid, X, Y, Z);
			SendOk(playerid,"Вызов принят. Местоположение указано на карте");
			SendOk(GetPVarInt(playerid,"repair_id"),"Механик принял Ваш вызов. Для быстрого нахождения Вас механиком, оставайтесь на данном месте");
		}
      	case D_MAKELEADER_INFO: {
			if(!response) return 1;
			//if((listitem == fMAYOR-1) && !FD(player_name[playerid])) return ErrorMessage(playerid,"Недоступно");
			static const f_str[] = ""P"%s "W"| "ORANGE"%s";
			new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + MAX_PLAYER_NAME)];

			SetPVarInt(playerid, "use_frac", listitem+1);
			format(string,sizeof(string),f_str,FI[GetPVarInt(playerid, "use_frac")][fName],FI[GetPVarInt(playerid, "use_frac")][fLeader]);
			D(playerid,D_MAKELEADER_LIST,DSL,string,""P"1."W" Информация о фракции\n"P"2."W" Назначить лидера\n"P"3."W" Снять лидера\n"P"4."W" Взять временную лидерку","Выбрать","Отмена");
		}
		case D_MAKELEADER_LIST: {
		    if(!response) return 1;
		    switch(listitem) {
		        case 0: {
					if(!strcmp(FI[GetPVarInt(playerid, "use_frac")][fLeader],"None",true)) return ErrorMessage(playerid, "У данной организации нет лидера");
					new query[64];
					format(query,sizeof(query),"SELECT `Name`,`pRank` FROM `accounts` WHERE `pMember` = '%i'", GetPVarInt(playerid, "use_frac"));
					mysql_pquery(connects, query, "info_fraction", "ii", playerid,GetPVarInt(playerid, "use_frac"));
				}
		        case 1: {
				    if(strcmp(FI[GetPVarInt(playerid, "use_frac")][fLeader],"None",true)) return ErrorMessage(playerid, "У данной организации уже есть лидер");

				    static const f_str[] = ""W"Укажите ID игрока,которого хотите назначить на должность лидера "P"%s";
				    new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + 24];

				    format(string,sizeof(string),f_str,FI[GetPVarInt(playerid, "use_frac")][fName]);
					D(playerid,D_MAKELEADER_ADD,DSI, ""P"Назначение",string,"Выбрать","Отмена");
				}
		        case 2: {
					if(!strcmp(FI[GetPVarInt(playerid, "use_frac")][fLeader],"None",true)) return ErrorMessage(playerid, "У данной организации нет лидера");
				    static const f_str[] = ""W"Вы действительно хотите снять "NO"%s "W"с поста лидера организации "P"%s";
				    new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + 24];

				    format(string,sizeof(string),f_str,FI[GetPVarInt(playerid, "use_frac")][fLeader],FI[GetPVarInt(playerid, "use_frac")][fName]);
					D(playerid,D_MAKELEADER_CLEAR,DSM, ""P"Снятие",string,"Выбрать","Отмена");
				}
		        case 3: {
					return callcmd::templeader(playerid);
		        }
		    }
		}
		case D_MAKELEADER_ADD: {
		    if(!response) return 1;
			if(!strlen(inputtext)) {
				static const f_str[] = ""W"Укажите ID игрока,которого хотите назначить на должность лидера "P"%s";
				new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];

				format(string,sizeof(string),f_str,FI[GetPVarInt(playerid, "use_frac")][fName]);
				D(playerid,D_MAKELEADER_ADD,DSI, ""P"Назначение",string,"Выбрать","Отмена");
				return 1;
			}
		    if(!IsPlayerConnected(strval(inputtext))) return ErrorMessage(playerid, "Игрок оффлайн");
		    if(!TI[strval(inputtext)][tLogin]) return ErrorMessage(playerid, "Игрок не авторизован на сервере");
		    if(PI[strval(inputtext)][pLeader] != 0) return ErrorMessage(playerid, "Игрок уже лидер организации");
			if(PI[strval(inputtext)][pMember] != 0) return ErrorMessage(playerid, "Игрок состоит в организации");
		    SetPVarInt(playerid, "use_leader", strval(inputtext));

		    static const f_str[] = ""W"Вы действительно хотите назначить "ORANGE"%s"W" на поста лидера организации "P"%s";
		    new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 24)];

		    format(string,sizeof(string),f_str,player_name[GetPVarInt(playerid, "use_leader")],FI[GetPVarInt(playerid, "use_frac")][fName]);
			D(playerid,D_MAKELEADER,DSM, ""P"Назначение",string,"Назначить","Отмена");
		}
		case D_MAKELEADER: {
		    if(!response) return 1;
			new ID = GetPVarInt(playerid, "use_leader");
			new frac = GetPVarInt(playerid, "use_frac");
	        format(FI[frac][fLeader], 24, "%s", player_name[ID]);
			format(FI[frac][fAdmin],  24, "%s", player_name[playerid]);

			new year, month, day;
			getdate(year, month, day);
			format(FI[frac][fTime],  53, "%02i/%02i/%02i", day, month, year);

            PI[ID][pLeader] = FI[frac][fID];
            PI[ID][pMember] = FI[frac][fID];
            PI[ID][pRank] 	= FI[frac][fMaxRang];

            static const f_str[] = ""W"%s"G" назначил Вас лидером организации "P"%s";
			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 24)];

            format(string,sizeof(string),f_str,player_name[playerid],FI[frac][fName]);
            SendOk(ID,string);

			format(string, sizeof(string), "[A] %s[%d] назначил %s[%d] на пост лидера %s",player_name[playerid],playerid,player_name[ID],ID,FI[frac][fName]);
			AdmMSG(0x1965D9AA, string,1);

			PI[ID][pFracSkin] = FI[frac][fSkin];
			PI[ID][pJob] 		= 0;
			A_SetPlayerSkin(ID,PI[ID][pFracSkin]);
			SetPlayerColor(ID,gFractionSpawn[PI[ID][pMember]][fracColor]);
			start_work[ID] = 1;
			PI[ID][pSpawn] = FRACTION_SPAWN;
			SaveAccount(ID);
			SaveFraction(frac);
			add_datefrac(ID);
	    }
     	case D_MAKELEADER_CLEAR: {
         	if(!response) return 1;
	        new ID = GetCheckID(FI[GetPVarInt(playerid, "use_frac")][fLeader]);
		    if(ID != INVALID_PLAYER_ID) {
				if(IsAGang(ID)) EndCapt(ID);
				add_jobinfo(ID,"Снят с поста лидера");
	        	PI[ID][pLeader] = 0;
				PI[ID][pMember] = 0;
    			PI[ID][pRank] = 0;
				start_work[ID] = 0;
    			static const f_str[] = ""W"%s "G"забрал у Вас полномочия лидера организации";
    			new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];

		    	format(string,sizeof(string),f_str,player_name[playerid]);
		    	SendOk(ID,string);

				format(string, sizeof(string), "[A] %s[%d] снял %s[%d] с поста лидера %s",player_name[playerid],playerid,player_name[ID],ID,FI[GetPVarInt(playerid, "use_frac")][fName]);
				AdmMSG(0x1965D9AA, string,1);

				if(PI[playerid][pHouse] > 0) PI[ID][pSpawn] = HOME_SPAWN;
				else PI[ID][pSpawn] = DEFAULT_SPAWN;
				skin_player(ID);
				SaveAccount(ID);
		    	PlayerSpawn(ID);
	        }
	        else {
				new string[128];
				format(string, sizeof(string), "[A] %s[%d] снял %s с поста лидера %s",player_name[playerid],playerid,FI[GetPVarInt(playerid, "use_frac")][fLeader],FI[GetPVarInt(playerid, "use_frac")][fName]);
				AdmMSG(0x1965D9AA, string,1);
				off_add_jobinfo(FI[GetPVarInt(playerid, "use_frac")][fName],"Недееспособен");
			    SendOk(playerid, "Лидер организации успешно снят в оффлайн");
			    new query[128];
			    mysql_format(connects,query, sizeof(query), "UPDATE `"TABLE_ACCOUNTS"` SET pLeader = '0',pMember = '0',pRank = '0',pModel = '0' WHERE Name = '%e'",FI[GetPVarInt(playerid, "use_frac")][fLeader]);
    			mysql_tquery(connects, query, "", "");
			}
	        format(FI[GetPVarInt(playerid, "use_frac")][fLeader], 5, "None");
	        SaveFraction(GetPVarInt(playerid, "use_frac"));
	    }
	    case D_TEMPLEADER_CHOOSE:
	    {
	        if(!response) return 1;

	        if(listitem != 0)
	        {
		        new id_fraction = listitem;

				PI[playerid][pLeader] = id_fraction;
				PI[playerid][pMember] = id_fraction;
				PI[playerid][pRank] = FI[id_fraction][fMaxRang];
				start_work[playerid] = 1;
				SaveAccount(playerid);

				if(IsAMafia(playerid) && BizWarTime > 0) for(new i; i < 8; i++) TextDrawShowForPlayer(playerid,Bizwar[i]);
				else if(IsAGang(playerid) && zahvat) for(new i; i < 7; i++) TextDrawShowForPlayer(playerid, ghettotablica_TD[i]);

				static const f_str[] = "[A]: %s[%d] назначил(а) себя временным лидером "P"%s (%d)";
			    new string[sizeof(f_str) + (-6 + MAX_PLAYER_NAME + 4 + 32)];

				format(string, sizeof(string), f_str, player_name[playerid], playerid, FI[id_fraction][fName], id_fraction);
				AdmMSG(0x1965D9AA, string,1);
				SendEsp(playerid, "/templeader, чтобы снять временную лидерку");
				PI[playerid][pFracSkin] = FI[id_fraction][fSkin];
				A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
				SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
				WriteLog(LOG_GUN,player_name[playerid],"-","временная лидерка");

				PI[playerid][pSpawn] = FRACTION_SPAWN;
				UpdatePlayerData(playerid,"pSpawn",FRACTION_SPAWN);

				SetPVarInt(playerid, "Templeader", 1);
			}
			else
			{
			    if(!GetPVarInt(playerid, "Templeader")) return ErrorMessage(playerid, "Вы не назначали себя временным лидером");
			    if(IsAMafia(playerid) && BizWarTime > 0) for(new i; i < 8; i++) TextDrawHideForPlayer(playerid,Bizwar[i]);
			    else if(IsAGang(playerid) && zahvat) for(new i; i < 7; i++) TextDrawHideForPlayer(playerid, ghettotablica_TD[i]);
   				PI[playerid][pLeader] = 0;
				PI[playerid][pMember] = 0;
				PI[playerid][pRank] = 0;
				start_work[playerid] = 0;

				PI[playerid][pSpawn] = DEFAULT_SPAWN;
				UpdatePlayerData(playerid,"pSpawn",DEFAULT_SPAWN);

				A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
				SetPlayerColor(playerid,TEAM_HIT_COLOR);
				DeletePVar(playerid, "Templeader");
			}
	        return 1;
	    }
		case D_BLACK_MARKET: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Введите стоимость за "P"1г"W" наркотика\nСейчас стоимость составляет: "GREEN"$%d";
					new string[sizeof(f_str) +1 +(-2 + 5)];
					format(string,sizeof(string),f_str,black_prods[5]);
					D(playerid,D_BLACK_MARKET_DRUGS,DSI, ""P"Стоимость наркотиков", string, "Изменить", "Назад");
				}
				case 1: {
					static const f_str[] = ""W"Введите стоимость за "P"1"W" боеприпас\nСейчас стоимость составляет: "GREEN"$%d";
					new string[sizeof(f_str) +1 +(-2 + 5)];
					format(string,sizeof(string),f_str,black_prods[6]);
					D(playerid,D_BLACK_MARKET_MATS,DSI, ""P"Стоимость боеприпасов", string, "Изменить", "Назад");
				}
				case 2: {
					static const f_str[] = ""W"Введите стоимость за "P"1"W" бронежилет\nСейчас стоимость составляет: "GREEN"$%d";
					new string[sizeof(f_str) +1 +(-2 + 5)];
					format(string,sizeof(string),f_str,black_prods[7]);
					D(playerid,D_BLACK_MARKET_ARMOUR,DSI, ""P"Стоимость бронежилет", string, "Изменить", "Назад");
				}
				case 3: {
					static const f_str[] = ""W"Введите стоимость за "P"1"W" армейскую форму\nСейчас стоимость составляет: "GREEN"$%d";
					new string[sizeof(f_str) +1 +(-2 + 5)];
					format(string,sizeof(string),f_str,black_prods[8]);
					D(playerid,D_BLACK_MARKET_SKIN,DSI, ""P"Стоимость армейской формы", string, "Изменить", "Назад");
				}
			}
		}
		case D_BLACK_MARKET_DRUGS: {
			if(!response) return callcmd::bmarket(playerid);
			if(strval(inputtext) < 1 || strval(inputtext) > 50) {
				static const f_str[] = ""W"Введите стоимость за "P"1г"W" наркотика\nСейчас стоимость составляет: "GREEN"$%d\n\n"NO"*"G" От $1 до $50";
				new string[sizeof(f_str) +1 +(-2 + 5)];
				format(string,sizeof(string),f_str,black_prods[5]);
				D(playerid,D_BLACK_MARKET_DRUGS,DSI, ""P"Стоимость наркотиков", string, "Изменить", "Назад");
				return 1;
			}
			black_prods[5] = strval(inputtext);
			SaveMarket();
			new string[128];
			format(string,sizeof(string),"Стоимость "P"1г "G"наркотиков составляет "ORANGE"$%d",black_prods[5]);
			SendUse(playerid,string);
			callcmd::bmarket(playerid);
		}
		case D_BLACK_MARKET_MATS: {
			if(!response) return callcmd::bmarket(playerid);
			if(strval(inputtext) < 10 || strval(inputtext) > 15) {
				static const f_str[] = ""W"Введите стоимость за "P"1"W" боеприпас\nСейчас стоимость составляет: "GREEN"$%d\n\n"NO"*"G" От $10 до $15";
				new string[sizeof(f_str) +1 +(-2 + 5)];
				format(string,sizeof(string),f_str,black_prods[6]);
				D(playerid,D_BLACK_MARKET_MATS,DSI, ""P"Стоимость боеприпасов", string, "Изменить", "Назад");
				return 1;
			}
			black_prods[6] = strval(inputtext);
			SaveMarket();
			new string[128];
			format(string,sizeof(string),"Стоимость "P"1 "G"боеприпаса составляет "ORANGE"$%d",black_prods[6]);
			SendUse(playerid,string);
			callcmd::bmarket(playerid);
		}
		case D_BLACK_MARKET_ARMOUR: {
			if(!response) return callcmd::bmarket(playerid);
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				static const f_str[] = ""W"Введите стоимость за "P"1"W" бронежилет\nСейчас стоимость составляет: "GREEN"$%d\n\n"NO"*"G" От $1 до $10.000";
				new string[sizeof(f_str) +1 +(-2 + 5)];
				format(string,sizeof(string),f_str,black_prods[7]);
				D(playerid,D_BLACK_MARKET_ARMOUR,DSI, ""P"Стоимость бронежилета", string, "Изменить", "Назад");
				return 1;
			}
			black_prods[7] = strval(inputtext);
			SaveMarket();
			new string[128];
			format(string,sizeof(string),"Стоимость "P"1 "G"бронежилета составляет "ORANGE"$%d",black_prods[7]);
			SendUse(playerid,string);
			callcmd::bmarket(playerid);
		}
		case D_BLACK_MARKET_SKIN: {
			if(!response) return 1;
			if(strval(inputtext) < 1 || strval(inputtext) > 10000) {
				static const f_str[] = ""W"Введите стоимость за "P"1"W" армейскую форму\nСейчас стоимость составляет: "GREEN"$%d\n\n"NO"*"G" От $1 до $10.000";
				new string[sizeof(f_str) +1 +(-2 + 5)];
				format(string,sizeof(string),f_str,black_prods[8]);
				D(playerid,D_BLACK_MARKET_SKIN,DSI, ""P"Стоимость армейской формы", string, "Изменить", "Назад");
				return 1;
			}
			black_prods[8] = strval(inputtext);
			SaveMarket();
			new string[128];
			format(string,sizeof(string),"Стоимость "P"1 "G"армейской формы составляет "ORANGE"$%d",black_prods[8]);
			SendUse(playerid,string);
			callcmd::bmarket(playerid);
		}
		case D_MARKET_NARKO: {
			if(!response) return 1;
		    if(strval(inputtext) < 1 || strval(inputtext) > 51) {
				static const f_str[] = ""W"Укажите количество наркотиков для покупки:\n\n\
                "O"Примечание:"W"\n\
                \tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
                \tДоступно грамм на складе: "P"%d"W"\n\
				\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,black_prods[5],black_prods[1],vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
				D(playerid,D_MARKET_NARKO,DSI, ""P"Покупка наркотиков", string, "Купить", "Отмена");
				return 1;
			}
			if(black_prods[1] < strval(inputtext)) return ErrorMessage(playerid,"На складе закончился товар");
		    if(PI[playerid][pDrugs] + strval(inputtext) > vip_status[PI[playerid][pVips]][vip_drugs]) return ErrorMessage(playerid,"Вы не можете взять слишком много");
			if(GetPlayerMoneyEx(playerid) < black_prods[5]*strval(inputtext)) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid,-black_prods[5]*strval(inputtext),"покупка нарко ЧР");
			PI[playerid][pDrugs] += strval(inputtext);
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
			black_prods[1] -= strval(inputtext);
			SaveMarket();
			FI[black_prods[0]][fBank] += black_prods[5]*strval(inputtext);
			new string[128];
			format(string,sizeof(string),"Вы приобрели "P"%dг "G"наркотиков за "ORANGE"$%d",strval(inputtext),black_prods[5]*strval(inputtext));
			SendUse(playerid,string);
		}
		case D_ROB_CAR: {
			if(!response) {
				new string[50];
				format(string,sizeof(string),"Видно что у тебя кишка тонка, вали от сюда");
				SendUse(playerid,string);
				return true;
			}
			D(playerid,DIALOG_NONE,DSM, ""P"Ограбление домов","Бери фургон в отмеченном месте и ищи дом в опасном районе\nНе забудь про отмычки, без них ты не сможешь взломать дверь дома", "Ок", "");
			rob_veh[playerid] = A_CreateVehicle(413, 2339.1440,-1315.3313,24.1655,0.0270, 150, -1, -1,VEHICLE_TYPE_NONE);
			EnableGPSForPlayer(playerid, 2339.9221,-1308.9105,24.2313);
			VehicleInfo[rob_veh[playerid]][vFuel] = 100;
			VehicleInfo[rob_veh[playerid]][vRobHouse] = true;
			SetVehicleParamsEx(rob_veh[playerid],false,false,false,false,false,false,false);
		}
		case D_MARKET_BUY: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new Float:armour;
					GetPlayerArmour(playerid,armour);
					if(PI[playerid][pAdmin]) return ErrorMessage(playerid,"Запрещено");
					if(armour < 50) return ErrorMessage(playerid,"У Вас нету бронежилета/либо он сильно изношен");
					if(black_prods[3]+1 > 50) return ErrorMessage(playerid,"На складе черного рынка недостаточно места");
					if(FI[black_prods[0]][fBank] < floatround(black_prods[7]/4)) return ErrorMessage(playerid,"На данный момент мы не можем приобрести Ваш товар");
					FI[black_prods[0]][fBank] -= floatround(black_prods[7]/4);
					UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
					black_prods[3] += 1;
					SaveMarket();
					GiveMoney(playerid,floatround(black_prods[7]/4),"продажа армора ЧР");
					SetPlayerArmour(playerid,0);
				}
				case 1: {
					if(!PI[playerid][pArmSkin]) return ErrorMessage(playerid,"У Вас нет армейской формы");
					if(black_prods[4]+1 > 50) return ErrorMessage(playerid,"На складе черного рынка недостаточно места");
					if(FI[black_prods[0]][fBank] < floatround(black_prods[8]/4)) return ErrorMessage(playerid,"На данный момент мы не можем приобрести Ваш товар");
					FI[black_prods[0]][fBank] -= floatround(black_prods[8]/4);
					UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
					black_prods[4] += 1;
					SaveMarket();
					GiveMoney(playerid,floatround(black_prods[8]/4),"продажа формы ЧР");
					PI[playerid][pArmSkin] = 0;
					UpdatePlayerData(playerid,"ArmSkin",0);
				}
				case 2: {
					static const f_str[] = ""W"Укажите количество наркотиков для продажи:\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
						\tДоступно грамм в кармане: "P"%d"W"\n\
						\tНа склад поместится: "P"%d"W"\n";
					new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

					format(string,sizeof(string),f_str,floatround(black_prods[5]/4),PI[playerid][pDrugs],2500-black_prods[1]);
					D(playerid,D_MARKET_NARKO_SELL,DSI, ""P"Продажа наркотиков", string, "Продать", "Отмена");
				}
				case 3: {
					static const f_str[] = ""W"Укажите количество боеприпасов для продажи:\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость "P"1г"W" боеприпаса: "GREEN"$%d"W"\n\
						\tДоступно боеприпасов в кармане: "P"%d"W"\n\
						\tНа склад поместится: "P"%d"W"\n";
					new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

					format(string,sizeof(string),f_str,floatround(black_prods[6]/4),PI[playerid][pMats],50000-black_prods[2]);
					D(playerid,D_MARKET_MATS_SELL,DSI, ""P"Продажа боеприпасов", string, "Продать", "Отмена");
				}
			}
		}
		case D_MARKET_NARKO_SELL: {
			if(!response) return 1;
		    if(strval(inputtext) < 1 || strval(inputtext) > 51) {
				static const f_str[] = ""W"Укажите количество наркотиков для продажи:\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
						\tДоступно грамм в кармане: "P"%d"W"\n\
						\tНа склад поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,floatround(black_prods[5]/4),PI[playerid][pDrugs],2500-black_prods[1]);
				D(playerid,D_MARKET_NARKO_SELL,DSI, ""P"Продажа наркотиков", string, "Продать", "Отмена");
				return 1;
			}
			if(black_prods[1]+strval(inputtext) >= 2500) return ErrorMessage(playerid,"На складе черного рынка недостаточно места");
		    if(PI[playerid][pDrugs] < strval(inputtext)) return ErrorMessage(playerid,"У Вас недостаточно наркотиков");
			if(FI[black_prods[0]][fBank] < floatround(black_prods[5]/4)) return ErrorMessage(playerid,"На данный момент мы не можем приобрести Ваш товар");
			GiveMoney(playerid,floatround((black_prods[5]*strval(inputtext))/4),"продажа нарко ЧР");
			PI[playerid][pDrugs] -= strval(inputtext);
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
			black_prods[1] += strval(inputtext);
			SaveMarket();
			FI[black_prods[0]][fBank] -= floatround((black_prods[5]*strval(inputtext))/4);
			UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
			new string[128];
			format(string,sizeof(string),"Вы продали "P"%dг "G"наркотиков за "ORANGE"$%d",strval(inputtext),floatround((black_prods[5]*strval(inputtext))/4));
			SendUse(playerid,string);
		}
		case D_MARKET_MATS_SELL: {
			if(!response) return 1;
		    if(strval(inputtext) < 1 || strval(inputtext) > 501) {
				static const f_str[] = ""W"Укажите количество боеприпасов для продажи:\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость "P"1г"W" боеприпаса: "GREEN"$%d"W"\n\
						\tДоступно боеприпасов в кармане: "P"%d"W"\n\
						\tНа склад поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,floatround(black_prods[6]/4),PI[playerid][pMats],50000-black_prods[2]);
				D(playerid,D_MARKET_MATS_SELL,DSI, ""P"Продажа боеприпасов", string, "Продать", "Отмена");
				return 1;
			}
			if(black_prods[2]+strval(inputtext) >= 50000) return ErrorMessage(playerid,"На складе черног рынка недостаточно места");
		    if(PI[playerid][pMats] < strval(inputtext)) return ErrorMessage(playerid,"У Вас недостаточно боеприпасов");
			if(FI[black_prods[0]][fBank] < floatround(black_prods[6]/4)) return ErrorMessage(playerid,"На данный момент мы не можем приобрести Ваш товар");
			GiveMoney(playerid,floatround((black_prods[6]*strval(inputtext))/4),"продажа матов ЧР");
			PI[playerid][pMats] -= strval(inputtext);
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);
			black_prods[2] += strval(inputtext);
			SaveMarket();
			FI[black_prods[0]][fBank] -= floatround((black_prods[6]*strval(inputtext))/4);
			UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
			new string[128];
			format(string,sizeof(string),"Вы продали "P"%dг "G"боеприпасов за "ORANGE"$%d",strval(inputtext),floatround((black_prods[6]*strval(inputtext))/4));
			SendUse(playerid,string);
		}
		case D_MARKET: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Вы действитлеьно хотите купить бронежилет?\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость бронежилет "GREEN"$%d"W"\n\
						\tДоступно на складе: "P"%d"W"";
					new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5)];
					format(string,sizeof(string),f_str,black_prods[7],black_prods[3]);
					D(playerid,D_MARKET_ARMOUR,DSM, ""P"Покупка бронежилет", string, "Купить", "Отмена");
				}
				case 1: {
					static const f_str[] = ""W"Вы действитлеьно хотите купить армейскую форму?\n\n\
						"O"Примечание:"W"\n\
						\tСтоимость армейской формы "GREEN"$%d"W"\n\
						\tДоступно на складе: "P"%d"W"";
					new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5)];
					format(string,sizeof(string),f_str,black_prods[8],black_prods[4]);
					D(playerid,D_MARKET_SKIN,DSM, ""P"Покупка армейской формы", string, "Купить", "Отмена");
				}
			}
		}
		case D_MARKET_ARMOUR: {
			if(!response) return 1;
			if(GetPlayerMoneyEx(playerid) < black_prods[7]) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(black_prods[3] < 1) return ErrorMessage(playerid,"На складе закончился товар");
			GiveMoney(playerid,-black_prods[7],"покупка брони ЧР");
			black_prods[3] -= 1;
			SaveMarket();
			FI[black_prods[0]][fBank] += black_prods[7];
			UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
			SetPlayerArmour(playerid,100);
			new string[100];
			format(string,sizeof(string),"Вы приобрели бронежилет за "ORANGE"$%d",black_prods[7]);
			SendUse(playerid,string);
		}
		case D_MARKET_SKIN: {
			if(!response) return 1;
			if(GetPlayerMoneyEx(playerid) < black_prods[8]) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(black_prods[4] < 1) return ErrorMessage(playerid,"На складе закончился товар");
			GiveMoney(playerid,-black_prods[8],"покупка формы ЧР");
			black_prods[4] -= 1;
			SaveMarket();
			FI[black_prods[0]][fBank] += black_prods[8];
			UpdateFraction(black_prods[0],"Bank",FI[black_prods[0]][fBank]);
			PI[playerid][pArmSkin] = 1;
			UpdatePlayerData(playerid,"ArmSkin",1);
			new string[100];
			format(string,sizeof(string),"Вы приобрели армейскую форму за "ORANGE"$%d",black_prods[8]);
			SendUse(playerid,string);
			SendOk(playerid,"Для использования армейской формы, введите: "W"/dress");
		}
		case D_MARKET_GUN: {
			if(!response) return 1;
		    if(strval(inputtext) < 1 || strval(inputtext) > 500) {
				static const f_str[] = ""W"Укажите количество боеприпасов для покупки:\n\n\
                "O"Примечание:"W"\n\
                \tСтоимость "P"1"W" боеприпаса: "GREEN"$%d"W"\n\
                \tДоступно боеприпасов на складе: "P"%d"W"\n\
				\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,black_prods[6],black_prods[2],vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats]);
				D(playerid,D_MARKET_GUN,DSI, ""P"Покупка боеприпасов", string, "Купить", "Отмена");
				return 1;
			}
			if(black_prods[2] < strval(inputtext)) return ErrorMessage(playerid,"На складе закончился товар");
		    if(PI[playerid][pMats] + strval(inputtext) > vip_status[PI[playerid][pVips]][vip_mats]) return ErrorMessage(playerid,"Вы не можете взять слишком много");
			if(GetPlayerMoneyEx(playerid) < black_prods[6]*strval(inputtext)) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid,-black_prods[6]*strval(inputtext),"покупка матов ЧР");
			PI[playerid][pMats] += strval(inputtext);
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);
			black_prods[2] -= strval(inputtext);
			SaveMarket();
			FI[black_prods[0]][fBank] += black_prods[6]*strval(inputtext);
			new string[128];
			format(string,sizeof(string),"Вы приобрели "P"%d "G"боеприпасов за "ORANGE"$%d",strval(inputtext),black_prods[6]*strval(inputtext));
			SendUse(playerid,string);
		}
		case D_JOB: {
			if(!response) return true;
			if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
			switch(listitem) {
				case 0: {
					if(PI[playerid][pLevel] < 2) return ErrorMessage(playerid,"Доступно со 2 уровня");
					PI[playerid][pJob] = 1;
				}
				case 1: {
					if(PI[playerid][pLevel] < 3) return ErrorMessage(playerid,"Доступно со 3 уровня");
					PI[playerid][pJob] = 2;
				}
				case 2: {
					if(PI[playerid][pLevel] < 3) return ErrorMessage(playerid,"Доступно со 3 уровня");
					PI[playerid][pJob] = 4;
				}
				case 3: {
					if(PI[playerid][pLevel] < 4) return ErrorMessage(playerid,"Доступно со 4 уровня");
					PI[playerid][pJob] = 3;
				}
				case 4: {
					if(PI[playerid][pLevel] < 4) return ErrorMessage(playerid,"Доступно со 4 уровня");
					PI[playerid][pJob] = 5;
				}
				case 5: {
					if(PI[playerid][pLevel] < 5) return ErrorMessage(playerid,"Доступно с 5 уровня");
					PI[playerid][pJob] = 6;
				}
			}
			SendOk(playerid,"Вы успешно трудоустроились!");
			SendOk(playerid,"Для просмотра доступных команд, введите: "W"/menu > Команды сервера > По работе");
		}
		case D_JOB_OIL: {
			if(!response) return true;
			if(!TI[playerid][tJobOil][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
				TI[playerid][tJobOil][0] = true;
				TI[playerid][tJobSalary] = 0;
				SendOk(playerid,"Поздравляем. Вы успешно устроились на работу "W"нефтяника");
				SendOk(playerid,"Для просмотра статистики, введите - "W"/progress");
				SendOk(playerid,"На мини-карте обозначены метки приёма бочки");

				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 27);
				else A_SetPlayerSkin(playerid, 131);
	
				SetPlayerMapIcon(playerid,1,415.0787,1405.1608,8.5656,11,-1,MAPICON_GLOBAL);
				SetPlayerMapIcon(playerid,2,401.2273,1456.7953,8.1906,11,-1,MAPICON_GLOBAL);

				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
			}
			else {
				if(!TI[playerid][tJobSalary]) EndOil(playerid);
				else D(playerid,D_JOB_OIL_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_OIL_1: {
			if(!response) return EndOil(playerid);
			SetPVarInt(playerid,"oil_salary",1);
			EndOil(playerid);
		}
		case D_JOB_SAD: {
			if(!response) return true;
			if(!TI[playerid][tJobSad][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
				TI[playerid][tJobSad][0] = 1;
				TI[playerid][tJobSad][2] = 0;
				TI[playerid][tJobSad][3] = 0;
				TI[playerid][tJobSalary] = 0;
		
				SendOk(playerid,"Поздравляем. Вы успешно устроились на "W"ферму");
				SendOk(playerid,"Для ухода за деревом, возьмите лейку и полейте дерево");
				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid,35);
				else A_SetPlayerSkin(playerid, 157);
				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
				//D(playerid,D_JOB_SAD_2,DSM, ""P"Яблочный сад","\n\n"W"Желаете пройти FAQ?\n\n","Да","Нет");
			}
			else {
				if(!TI[playerid][tJobSalary]) EndSad(playerid);
				else D(playerid,D_JOB_SAD_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_SAD_1: {
			if(!response) return EndSad(playerid);
			SetPVarInt(playerid,"sad_salary",1);
			EndSad(playerid);
		}
		case D_JOB_GUNS: {
			if(!response) return true;
			if(!TI[playerid][tJobGun][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
				TI[playerid][tJobGun][0] = 1;
				SendOk(playerid,"Поздравляем. Вы успешно устроились на "W"оружейный завод");
				SendOk(playerid,"Возьмите заготовку у стенда и займите свободный стол для сборки оружия");
				TI[playerid][tJobGun][1] = 1;
				TI[playerid][tJobSalary] = 0;
	
				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 73);
				else A_SetPlayerSkin(playerid, 53);
				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
			}
			else {
				if(!TI[playerid][tJobSalary]) EndGun(playerid);
				else D(playerid,D_JOB_GUNS_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_GUNS_1: {
			if(!response) return EndGun(playerid);
			SetPVarInt(playerid,"gun_salary",1);
			EndGun(playerid);
		}
		case D_JOB_WOOD: {
			if(!response) return true;
			if(!TI[playerid][tJobWood][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");
				TI[playerid][tJobWood][0] = 1;
				TI[playerid][tJobWood][3] = 1;
				TI[playerid][tJobSalary] = 0;
				SendOk(playerid,"Поздравляем. Вы успешно устроились на "W"лесопилку");
				SendOk(playerid,"Чтобы напилить древесины, подойдите к основанию дерева");
				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 260);
				else A_SetPlayerSkin(playerid, 131);
				SetPlayerAttachedObject(playerid,8,341,6);
				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
			}
			else {
				if(!TI[playerid][tJobSalary]) EndWood(playerid);
				else D(playerid,D_JOB_WOOD_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_WOOD_1: {
			if(!response) return EndWood(playerid);
			SetPVarInt(playerid,"wood_salary",1);
			EndWood(playerid);
		}
		case D_JOB_LOADER:
		{
			if(!response) return true;
			if(!TI[playerid][tJobLoader][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");

				TI[playerid][tJobLoader][0] = 1;
				TI[playerid][tJobLoader][1] = 0;
				TI[playerid][tJobLoader][2] = 0;
				TI[playerid][tJobSalary] = 0;

				SendOk(playerid,"Поздравляем. Вы успешно устроились на работу "W"грузчика");
				SendOk(playerid,"Ваша работа - доставка мешков на склад");


				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 16);
				else A_SetPlayerSkin(playerid, 131);

				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
				SetPlayerCheckpoint(playerid, 836.7643,-1203.7499,16.9766, 4.0);
			}
			else {
				if(!TI[playerid][tJobSalary]) EndLoader(playerid); // конец работы (если нет зп)
				else D(playerid,D_JOB_LOADER_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_LOADER_1:
		{
			if(!response) return EndLoader(playerid);
			SetPVarInt(playerid,"loader_salary",1);
			EndLoader(playerid);
		}
		case D_JOB_MINE: {
			if(!response) return true;
			if(!TI[playerid][tJobMine][0]) {
				if(start_work[playerid]) return ErrorMessage(playerid,"Необходимо закончить рабочий день в организации");

				TI[playerid][tJobMine][0] = 1;
				TI[playerid][tJobMine][1] = 0;
				TI[playerid][tJobSalary] = 0;

				SendOk(playerid,"Вы устроились на работу шахтёра");
				SendOk(playerid,"Ищите месторождения железной руды на территории шахты");
				SendOk(playerid,"Добытое сырьё относите в кузницу для переплавки");
				//online_questjobs[0]++;

				if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 16);
				else A_SetPlayerSkin(playerid, 131);

				SetPlayerAttachedObject(playerid, 4, 18634, 6, 0.078221, 0.034000, 0.028844, -67.902618, 264.126861, 193.350555, 1.861999, 1.884000, 1.727000);

				for(new i = 0;i < 5;i++) {
					TextDrawShowForPlayer(playerid,work_td_global[i]);
				}
				PlayerTextDrawShow(playerid, work_td_local[playerid][0]);
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
			else {
				if(!TI[playerid][tJobSalary]) EndMine(playerid); // конец работы (если нет зп)
				else D(playerid,D_JOB_MINE_1,DSM, ""P"Завершение работы","\n\n\t"YELLOW"Выберите способ оплаты\n\n"G"При выборе оплаты на банковский счёт,\nзаработная плата придёт во время PayDay\n\n","Наличными","Банк");
			}
		}
		case D_JOB_MINE_1: {
			if(!response) return EndMine(playerid);
			SetPVarInt(playerid,"mine_salary",1);
			EndMine(playerid);
			return 1;
		}
		case D_STOP_LOAD: {
  			if(!response) return RemovePlayerFromVehicleAC(playerid);
			else {
				new vehicleid = GetPlayerVehicleID(playerid);
				if(!vehicleid) return true;
				if(VG[vehicleid][vgLoading] == false && VG[vehicleid][vgUnloading] == false) return true;
				VG[vehicleid][vgLoading] = false;
				VG[vehicleid][vgUnloading] = false;

				if(IsValid3DTextLabel(VG[vehicleid][vgText])) DestroyDynamic3DTextLabelEx(VG[vehicleid][vgText]);

				DestroyDynamicPickup(VG[vehicleid][vgPickup]);
	            VG[vehicleid][vgPickup] = 0;
	            DestroyDynamicArea(VG[vehicleid][vgArea]);
				VG[vehicleid][vgArea] = 0;
			}
		}
		case D_STOP_LOAD_ROBHOUSE: {
  			if(!response) return RemovePlayerFromVehicleAC(playerid);
			else {
				new vehicleid = GetPlayerVehicleID(playerid);
				if(!vehicleid) return true;
				if(VG[vehicleid][vgRobHouse] == false) return true;
				VG[vehicleid][vgRobHouse] = false;

				if(IsValid3DTextLabel(VG[vehicleid][vgText])) DestroyDynamic3DTextLabelEx(VG[vehicleid][vgText]);
				DestroyDynamicPickup(VG[vehicleid][vgPickup]);
	            VG[vehicleid][vgPickup] = 0;
	            DestroyDynamicArea(VG[vehicleid][vgArea]);
				VG[vehicleid][vgArea] = 0;
				SendOk(playerid,"Награбленное можно продать на чёрном рынке");

				if(IsValidDynamicPickup(RobPlayer[playerid][RobPickup])) {
					DestroyDynamicPickup(RobPlayer[playerid][RobPickup]);
					DestroyDynamicArea(RobPlayer[playerid][RobArea]);
					DestroyDynamic3DTextLabel(RobPlayer[playerid][RobText]);
				}
			}
		}
		case D_RENT_SPAWN_LS:
		{ 

			//DisablePlayerCheckpoint(playerid);
		    if(!response) return 1;

			new rent_price = 50;

			switch(PI[playerid][pLevel]) {
				case 1..5: rent_price = 50;
				case 6..10: rent_price = 200;
				default: rent_price = 300;
			}

			if(PI[playerid][pCash] < rent_price) return ErrorMessage(playerid, "У вас недостаточно средств");
			if(TI[playerid][tArendaCar] != -1) return ErrorMessage(playerid, "Вы уже арендуете транспорт");

			GiveMoney(playerid, -rent_price, "аренда мопеда");

			new Float:X,Float:Y,Float:Z,Float:A;

			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid,A);

			X += 1.5;
   			new carid = A_CreateVehicle(462, X, Y, Z, A,0,0,-1, VEHICLE_TYPE_RENT_NEWBIE);
   			PutPlayerInVehicle(playerid, carid, 0);

			TI[playerid][tArendaCar] = carid;

		    SetVehicleParamsEx(carid,false,false,false,true,false,false,false);
			SetVehicleNumberPlate(carid, "Rent Car");
			VehicleInfo[carid][veX] = X;
			VehicleInfo[carid][veY] = Y;
			VehicleInfo[carid][veZ] = Z;
			VehicleInfo[carid][vFuel] = gTransport[GetVehicleModel(carid)-400][trTank];
			VehicleInfo[carid][vType] = VEHICLE_TYPE_RENT_NEWBIE;
			VehicleInfo[carid][vJob] = 0;

   			SendOk(playerid, "Транспорт успешно арендован");
			SendOk(playerid, "Используйте /rlock (/rlk) для открытия/закрытия арендованного транспорта");
		}
		case D_FAQ:
		{
		    if(!response) return 1;

			switch(listitem)
			{
			    case 0: // info
				{
					static const f_str[] =
						""GREEN"О проекте:"W"\n\
						Flame Role Play - это место где тебя всегда рады видеть. \n\
						Только у нас Вы можете окунутся в захватывающий мир легендарной игры GTA San Andreas в жанре Role Play. \n\
						Окунувшись в игровой процесс на нашем сервере, Вы сможете попробовать себя в разных игровых ролях, \n\
						устроиться в полицию, участвовать в выборах, стать мэром или вообще президентом и руководить штатом, \n\
						пойти против закона и стать лидером опасной группировки и завоевать все территории опасных районов в Лос-Сантосе\n\
						или стать крутым мафиози, создать империю оборота наркотиков в штате и взять под контроль своей мафии все бизнесы штата!\n\
						Только у нас Вы получаете качественный игровой мод, приятную атмосферу игры максимально приближенной к реальности.\n\
						Вас ждёт увлекательные знакомства на сервере, любой игрок в дальнейшем может стать Вашим другом\n\
						на которого Вы всегда сможете положится - всё это ждёт Вас на игровом сервере Flame Role Play.\n\n";

					new string[sizeof(f_str)];
					format(string,sizeof(string),"%s",f_str);

					D(playerid, DIALOG_NONE, DSM, ""P"О проекте", string, "Закрыть", "");
				}
				case 1: // security
				{
                	static const f_str[] =
						""GREEN"Защита аккаунта:"W"\n\
						Уважаемый игрок, помните, что аккаунт - это Ваша собственность и никто другой за неё не отвечает!\n\
						Администрация никогда не попросит пароль от Вашего аккаунта, ключ и т.д. никогда не сообщайте свои данные об аккаунте третьим лицам.\n\
						Не пользуйтесь автоматическими установками модов и прочих дополнениях для GTA San Andreas, советуем пользоваться только проверенными\n\
						и надёжными источниками, так как в посторонних модах/дополнениях может содержаться вредоносный вирус\n\
						через который злоумышленник сможет читать Ваши пароли - Ваш аккаунт в Ваших руках.\n\
						Для того чтобы максимально защитить свой аккаунт советуем зайти в настройки безопасности и установить защитный код.\n\
						( /mn > Безопасность > Защитный код )\n\n";

					new string[sizeof(f_str)];
					format(string,sizeof(string),"%s",f_str);

					D(playerid, DIALOG_NONE, DSM, ""P"Защита аккаунта", string, "Закрыть", "");

				}
				case 2: // how to start
				{

					static const f_str[] =
						""GREEN"Как начать игру:"W"\n\
						Сперва вам следует начать прохождение сюжетной линии у персонажа, находящегося на вашем спавне.\n\
						Проходя сюжетную линию, вы ознакомитесь с различными системами игрового мода, получите первые сведения о проекте.\n\
						Играя на сервере Вы будете набираться опыта, после накопления нужного опыта для определённого уровня.\n\
						Вам будет доступен переход на новый уровень, который откроет для Вас новые возможности игры на нашем сервере.\n\
						Вы можете посмотреть статистику своего персонажа войдя в меню.\n\
						( /mn > Статистика персонажа )";

					new string[sizeof(f_str)];
					format(string,sizeof(string),"%s",f_str);

					D(playerid, DIALOG_NONE, DSM, ""P"С чего начать", string, "Закрыть", "");

				}
			}
		}
		case D_BIZZ_BUY: {
			new businessid = TI[playerid][tSelectedBusinessID];
			if(businessid < 0) return true;
			if(!response) {
				if(gBusiness[businessid][bizzType] == 8) {
					if(IsPlayerInRangeOfPoint(playerid,10.0, 545.7042,-1293.4833,17.2422)) SetPVarInt(playerid,"sellcarClass",1);
					if(IsPlayerInRangeOfPoint(playerid,10.0, -1965.6605,293.9383,35.4688)) SetPVarInt(playerid,"sellcarClass",3);
					if(IsPlayerInRangeOfPoint(playerid,10.0, 2200.8638,1394.8074,11.0625)) SetPVarInt(playerid,"sellcarClass",5);
					if(IsPlayerInRangeOfPoint(playerid,10.0, 2131.8152,-1151.3242,24.0600)) SetPVarInt(playerid,"sellcarClass",6);
					new carclass = GetPVarInt(playerid,"sellcarClass");
					TI[playerid][tTPpick] = true;
					SetPlayerPosAC(playerid, 1449.4907,702.5972,1087.9011, carclass, 82);
					SetPlayerFacingAngle(playerid,88.9930);
					SetCameraBehindPlayer(playerid);
					gBusiness[businessid][bizzVisitors]++;
					return 1;
				}
				new bint = gBusiness[businessid][bizzBint]-1;
				if(bint < 0 || bint >= BINT_COUNT) return 1;
				TI[playerid][tTPpick] = true;
				SetPlayerInterior(playerid,gBints[bint][bintInterior]);
				SetPlayerVirtualWorld(playerid,businessid+1);
				SetPlayerPosAC(playerid, gBints[bint][bintX],gBints[bint][bintY],gBints[bint][bintZ], businessid+1, gBints[bint][bintInterior]);
				SetPlayerFacingAngle(playerid,gBints[bint][bintR]);
				FreezePlayerForTime(playerid,5);
				gBusiness[businessid][bizzVisitors]++;
				SetCameraBehindPlayer(playerid);
			}
			else {
				if(businessid < 0) return true;
				if(gBusiness[businessid][bizzOwnerID]) return ErrorMessage(playerid,"Этот бизнес уже кто-то купил");
				new mes[85];
				format(mes,sizeof(mes),""W"Вы действительно хотите купить этот бизнес за "GREEN"$%d"W"?",gBusiness[businessid][bizzSellPrice]);
				D(playerid,D_BIZZ_UPDATE,DSM, ""P"Бизнес",mes,"Да","Нет");
				return 1;
			}
		}
		case D_BIZZ_BUY_2: {
			if(!response) {
				if(GetPVarInt(playerid,"bizzProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"bizzProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"bizzPokupaet")-1;
					SendOk(playerid,"Вы отказались от покупки бизнеса");
					SendOk(id_prodaet,"Игрок отказался от покупки Вашего бизнеса");
					DeletePVar(playerid,"bizzProdaet");
					DeletePVar(playerid,"bizzCena");
					DeletePVar(id_pokupaet,"bizzPokupaet");
				}
			}
			else {
				if(GetPVarInt(playerid,"bizzProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"bizzProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"bizzPokupaet")-1;
					new bizz_cena = GetPVarInt(playerid,"bizzCena");
					if(id_pokupaet == playerid) {
						if(PI[playerid][pCash] < bizz_cena) {
							ErrorMessage(playerid,"У Вас недостаточно денег на руках");
							ErrorMessage(id_prodaet,"У покупателя недостаточно денег на руках");
							DeletePVar(playerid,"bizzProdaet");
							DeletePVar(playerid,"bizzCena");
							DeletePVar(id_pokupaet,"bizzPokupaet");
						}
						else {
							new string[128];
							format(string,64,"покупка бизнеса у %s",player_name[id_prodaet]);
							string[0] = EOS;
							GiveMoney(playerid,-bizz_cena,string);
							string[0] = EOS;
							format(string,64,"продажа бизнеса %s",player_name[playerid]);
							GiveMoney(id_prodaet,bizz_cena,string);
							PI[playerid][pBusiness] = PI[id_prodaet][pBusiness];
							PI[id_prodaet][pBusiness] = 0;
							UpdatePlayerData(id_prodaet,"bussiness",0);
							UpdatePlayerData(playerid,"bussiness",PI[playerid][pBusiness]);
							strmid(gBusiness[PI[playerid][pBusiness]-1][bizzOwner],player_name[playerid],0,strlen(player_name[playerid]),MAX_PLAYER_NAME);
							new query[82 + MAX_PLAYER_NAME];
							format(query,sizeof(query),"UPDATE `business` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],PI[playerid][pBusiness]);
							mysql_tquery(connects, query);
							new bizid = PI[playerid][pBusiness]-1;
							UpdateBusinessText(bizid);

							if(gBusiness[bizid][bizzType] == 11 || gBusiness[bizid][bizzType] == 14) {
								if(gBusiness[bizid][bizzType] == 11) PI[playerid][bizz_status] = 6;
								else if(gBusiness[bizid][bizzType] == 14) PI[playerid][bizz_status] = 3;
								PI[playerid][bizz_work] = gBusiness[bizid][bizzID];
								UpdatePlayerData(playerid,"bizz_status",PI[playerid][bizz_status]);
								UpdatePlayerData(playerid,"bizz_work",gBusiness[bizid][bizzID]);
								PI[playerid][bizz_cash] = 0;
								UpdatePlayerData(playerid,"bizz_cash",0);
								PI[playerid][bizz_lcash] = 0;
								UpdatePlayerData(playerid,"bizz_lcash",0);

								PI[id_prodaet][bizz_work] = 0;
								UpdatePlayerData(id_prodaet,"bizz_work",0);
								PI[id_prodaet][bizz_status] = 0;
								UpdatePlayerData(id_prodaet,"bizz_status",0);
							}

							format(string,sizeof(string),"Вы приобрели бизнес у "P"%s"G" за "ORANGE"$%i",player_name[id_prodaet],bizz_cena);
							SendUse(playerid,string);
							format(string,sizeof(string),"Вы продали бизнес "P"%s"G" за "ORANGE"$%i",player_name[playerid],bizz_cena);
							SendUse(id_prodaet,string);
							DeletePVar(playerid,"bizzProdaet");
							DeletePVar(playerid,"bizzCena");
							DeletePVar(id_pokupaet,"bizzPokupaet");
						}
					}
					else {
						ErrorMessage(playerid,"Игрок оффлайн");
						DeletePVar(playerid,"bizzProdaet");
						DeletePVar(playerid,"bizzCena");
					}
				}
			}
		}
		case D_BIZZ_BUY_FILL: {
			if(!response) return true;
			new businessid = GetPVarInt(playerid,"bfillingid");
			DeletePVar(playerid,"bfillingid");
			if(businessid < 0) return true;
			if(gBusiness[businessid][bizzOwnerID]) return ErrorMessage(playerid,"Этот бизнес уже кто-то купил");
			new price = gBusiness[businessid][bizzSellPrice];
			if(PI[playerid][pCash] < price) return  ErrorMessage(playerid,"У Вас недостаточно денег для покупки этого бизнеса");
			if(PI[playerid][pBusiness]) return  ErrorMessage(playerid,"У Вас уже есть бизнес");
			new query[128];
			format(query,sizeof(query),"UPDATE `business` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],businessid+1);
			mysql_tquery(connects, query,"","");
			gBusiness[businessid][bizzOwnerID] = PI[playerid][pID];
			SetString(gBusiness[businessid][bizzOwner],player_name[playerid]);
			SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили бизнес. Не забывайте оплачивать его, иначе его продадут государству!");
			SendClientMessage(playerid,CGOLD,"Панель управления бизнесом: "W"/bpanel (/bp)");

			gBusiness[businessid][bizzDay] = unix + 60*60*24;

			format(query,sizeof(query),"UPDATE `business` SET `deliving` = '%d' WHERE id = '%d'",gBusiness[businessid][bizzDay],gBusiness[businessid][bizzID]);
			mysql_tquery(connects, query,"","");

			gBusiness[businessid][bizzBank] = 0;
			gBusiness[businessid][bizzBankDay] = 0;
			gBusiness[businessid][bizzProduct] = 100;
			gBusiness[businessid][bizzPrice] = 12;
			gBusiness[businessid][bizzProdOrder] = 0;
			gBusiness[businessid][bizzProdOrderPrice] = 0;
			SaveBusiness(businessid);
			UpdateBusinessText(businessid);
			UpdatePlayerData(playerid,"bussiness",businessid+1);
			PI[playerid][pBusiness] = gBusiness[businessid][bizzID];
			GiveMoney(playerid, -price,"покупка бизнеса");
		}
		case D_BIZZ_UPDATE: {
			if(!response) return true;
			new businessid = TI[playerid][tSelectedBusinessID];
			if(businessid < 0) return true;
			if(gBusiness[businessid][bizzOwnerID]) return ErrorMessage(playerid,"Этот бизнес уже кто-то купил");
			new price = gBusiness[businessid][bizzSellPrice];
			if(PI[playerid][pCash] < price) return  ErrorMessage(playerid,"У Вас недостаточно денег для покупки этого бизнеса");
			if(PI[playerid][pBusiness]) return  ErrorMessage(playerid,"У Вас уже есть бизнес");
			new query[128];
			format(query,sizeof(query),"UPDATE `business` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],businessid+1);
			mysql_tquery(connects, query,"","");
			gBusiness[businessid][bizzOwnerID] = PI[playerid][pID];
			SetString(gBusiness[businessid][bizzOwner],player_name[playerid]);
			if(gBusiness[businessid][bizzType] == 11 || gBusiness[businessid][bizzType] == 14 || gBusiness[businessid][bizzType] == 15) {
				if(gBusiness[businessid][bizzType] == 11) {
					PI[playerid][bizz_status] = 6;
					SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили таксопарк. Не забывайте оплачивать его, иначе его продадут государству!");
				}
				else if(gBusiness[businessid][bizzType] == 14) {
					PI[playerid][bizz_status] = 3;
					SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили транспортную компанию. Не забывайте оплачивать ее, иначе ее продадут государству!");
				}
				else if(gBusiness[businessid][bizzType] == 15) {
					SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили банковское отделение. Не забывайте оплачивать его, иначе его продадут государству!");
				}
				PI[playerid][bizz_cash] = 0;
				PI[playerid][bizz_lcash] = 0;
				PI[playerid][bizz_work] = gBusiness[businessid][bizzID];
				UpdatePlayerData(playerid,"bizz_status",PI[playerid][bizz_status]);
				UpdatePlayerData(playerid,"bizz_work",gBusiness[businessid][bizzID]);
				UpdatePlayerData(playerid,"bizz_cash",0);
				UpdatePlayerData(playerid,"bizz_lcash",0);
				gBusiness[businessid][bizzUpgrade][2] = 1;
				UpdateBizzUpgrade(businessid);
			}
			else {
				SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили бизнес. Не забывайте оплачивать его, иначе его продадут государству!");
				SendClientMessage(playerid,CGOLD,"Панель управления бизнесом - "W"/bpanel (/bp)");
			}

			gBusiness[businessid][bizzDay] = unix + 60*60*24;
			UpdateBusinessData(businessid+1,"deliving",gBusiness[businessid][bizzDay]);

			gBusiness[businessid][bizzBank] = 0;
			gBusiness[businessid][bizzBankDay] = 0;
			gBusiness[businessid][bizzProduct] = 500;
			gBusiness[businessid][bizzPrice] = 1;
			SaveBusiness(businessid);
			UpdateBusinessText(businessid);
			UpdatePlayerData(playerid,"bussiness",businessid+1);
			PI[playerid][pBusiness] = gBusiness[businessid][bizzID];
			GiveMoney(playerid, -price,"покупка бизнеса");
		}
  		case D_BIZZ: {
			if(!response) return true;
			new bizz = PI[playerid][pBusiness]-1;
			if(bizz < 0) return true;
			switch(listitem) {
				case 0..5: dialog_business(playerid,bizz,listitem);
				case 6: dialog_business(playerid,bizz,7);
				case 7: dialog_business(playerid,bizz,8);
			}
		}
		case D_BIZZ_2: {
			if(!response) return true;
			new bizz = PI[playerid][pBusiness]-1;
			if(bizz < 0) return true;
			dialog_business(playerid,bizz,listitem);
		}
		case D_BIZZ_3: {
			if(!response) return true;
			new bizz = PI[playerid][pBusiness]-1;
			if(bizz < 0) return true;
			switch(listitem) {
				case 0: dialog_business(playerid,bizz,0);
				case 1: dialog_business(playerid,bizz,2);
				case 2: dialog_business(playerid,bizz,3);
				case 3: dialog_business(playerid,bizz,5);
				case 4: dialog_business(playerid,bizz,6);
				case 5: dialog_business(playerid,bizz,7);
				case 6: dialog_business(playerid,bizz,8);
			}
		}
		case D_BIZZ_4: {
			if(!response) return true;
			new bizz = PI[playerid][pBusiness]-1;
			if(bizz < 0) return true;
			switch(listitem) {
				case 0..4: dialog_business(playerid,bizz,listitem);
				case 5: dialog_business(playerid,bizz,7);
				case 6: dialog_business(playerid,bizz,8);
			}
		}
		case D_BIZZ_5: {
			if(!response) return true;
			new bizz = PI[playerid][pBusiness]-1;
			if(bizz < 0) return true;
			switch(listitem) {
				case 0..2: dialog_business(playerid,bizz,listitem);
				case 3: dialog_business(playerid,bizz,4);
				case 4: dialog_business(playerid,bizz,5);
				case 5: dialog_business(playerid,bizz,7);
				case 6: dialog_business(playerid,bizz,8);
			}
		}
		case D_BIZZ_UPGRADE: {
			if(!response) return callcmd::bpanel(playerid);
			if(!PI[playerid][pBusiness]) return 1;
			new bizid = PI[playerid][pBusiness]-1;
			switch(listitem) {
				case 0: {
					if(gBusiness[bizid][bizzBank] < 100000) return ErrorMessage(playerid, "На счету бизнеса недостаточно средств");
					if(gBusiness[bizid][bizzUpgrade][0] >= 10000) return ErrorMessage(playerid, "У Вас приобретено данное улучшение");
					gBusiness[bizid][bizzUpgrade][0] = 10000;
					gBusiness[bizid][bizzBank] -= 100000;
				}
				case 1: {
					if(gBusiness[bizid][bizzBank] < 200000) return ErrorMessage(playerid, "На счету бизнеса недостаточно средств");
					if(gBusiness[bizid][bizzUpgrade][1] == 1) return ErrorMessage(playerid, "У Вас приобретено данное улучшение");
					gBusiness[bizid][bizzUpgrade][1] = 1;
					gBusiness[bizid][bizzBank] -= 200000;
				}
				case 2: {
					if(gBusiness[bizid][bizzBank] < 200000) return ErrorMessage(playerid, "На счету бизнеса недостаточно средств");
					if(gBusiness[bizid][bizzUpgrade][2] == 1) return ErrorMessage(playerid, "У Вас приобретено данное улучшение");
					gBusiness[bizid][bizzUpgrade][2] = 1;
					gBusiness[bizid][bizzBank] -= 200000;
				}
			}
			SendClientMessage(playerid,CGOLD,"Поздравляем с покупкой улучшения в Ваш бизнес");
			UpdateBusinessData(bizid+1,"bank",gBusiness[bizid][bizzBank]);
			UpdateBizzUpgrade(bizid);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_SELL: {
			if(!response) return callcmd::bpanel(playerid);
			if(PI[playerid][pBusiness] < 1) return ErrorMessage(playerid,"У Вас нет бизнеса");
			new id = PI[playerid][pBusiness] - 1;
			new sum = floatround(gBusiness[id][bizzSellPrice]/100*80);

			FI[fWHITEHOUSE][fBank] += floatround(gBusiness[id][bizzSellPrice]/100*20);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			if(UpdateBusinessData(id+1,"ownerid",0)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #21");
			gBusiness[id][bizzOwnerID] = 0;
			gBusiness[id][bizzStatus] = 1;
			gBusiness[id][bizzUpgrade][0] = 5000;
			if(gBusiness[id][bizzType] != 16) gBusiness[id][bizzUpgrade][1] = 0;
			gBusiness[id][bizzUpgrade][2] = 0;
			gBusiness[id][bizzMafia] = 0;
			gBusiness[id][bizzPrice] = 5;
			SetString(gBusiness[id][bizzOwner],"");
			if(gBusiness[id][bizzType] != 16) {
				new query[282];
				format(query,sizeof(query),"UPDATE `business` SET `ownerid` = '0', `owner` = '', `status` = '1', `mafia` = '0', `price` = '5',`order` = '0',`orderprice` = '0',`upgrade` = '5000|0|0' WHERE `id` = '%d'",id+1);
				mysql_tquery(connects, query,"","");
			}
			if(gBusiness[id][bizzType] == 16) {
				new query[282];
				format(query,sizeof(query),"UPDATE `business` SET `ownerid` = '0', `owner` = '', `status` = '1', `mafia` = '0', `price` = '5',`order` = '0',`orderprice` = '0',`upgrade` = '5000|1|0' WHERE `id` = '%d'",id+1);
				mysql_tquery(connects, query,"","");
			}
			UpdateBusinessText(id);
			UpdatePlayerData(playerid,"bussiness",0);
			PI[playerid][pBusiness] = 0;
			GiveMoney(playerid,sum,"продажа бизнеса");
			if(gBusiness[id][bizzType] == 11) {
				sell_bizztaxi(id+1);
				SendOk(playerid,"Таксопарк продан государству");
			}
			else if(gBusiness[id][bizzType] == 14) {
				sell_bizztaxi(id+1);
				SendOk(playerid,"Транспортная компания продана государству");
			}
			else if(gBusiness[id][bizzType] == 15) {
				SendOk(playerid,"Банковское отделение продано государству");
			}
			else SendOk(playerid,"Бизнес продан государству");
		}
		case D_BIZZ_BANK: {
			if(!response) return callcmd::bpanel(playerid);
			if(!PI[playerid][pBusiness]) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Состояние счета: "GREEN"$%d\n"P"1."W" Снять деньги\n"P"2."W" Положить деньги";
					new string[sizeof(f_str) +1 + (-2 + 10)];
					format(string,sizeof(string),f_str,gBusiness[PI[playerid][pBusiness] - 1][bizzBank]);
					D(playerid,D_BIZZ_BANK,DSL,""P"Управление кассой",string,"Далее","Назад");
				}
				case 1: D(playerid,D_BIZZ_BANK_INPUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите взять с кассы бизнеса:\n\n","Взять","Отмена");
				case 2: D(playerid,D_BIZZ_BANK_PUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите положить в кассу бизнеса:\n\n","Положить","Отмена");
			}
		}
		case D_BIZZ_BANK_INPUT: {
			if(!response) return callcmd::bpanel(playerid);
			if(!PI[playerid][pBusiness]) return 1;
			new id = PI[playerid][pBusiness] - 1;
			new sum = strval(inputtext);
			if(sum < 1 || sum > 1000000) return D(playerid,D_BIZZ_BANK_INPUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите взять с кассы бизнеса:\n\n"NO"*"G" От $1 до $1.000.000\n\n","Взять","Отмена");
			if(gBusiness[id][bizzBank] < sum) return D(playerid,D_BIZZ_BANK_INPUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите взять с кассы бизнеса:\n\n"NO"*"G" В кассе недостаточно средств\n\n","Взять","Отмена");
			if(UpdateBusinessData(id+1,"bank",gBusiness[id][bizzBank] - sum)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #20");
			gBusiness[id][bizzBank] -= sum;
			UpdateBusinessData(id+1,"bank",gBusiness[id][bizzBank]);
			GiveMoney(playerid,sum,"прибыль с бизнеса");

			new string[128];
			format(string,sizeof(string),"Вы взяли с кассы бизнеса: "ORANGE"$%d",sum);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_BANK_PUT: {
			if(!response) return callcmd::bpanel(playerid);
			if(!PI[playerid][pBusiness]) return 1;
			new id = PI[playerid][pBusiness] - 1;
			new sum = strval(inputtext);
			if(sum < 1 || sum > 1000000) return D(playerid,D_BIZZ_BANK_PUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите положить в кассу бизнеса:\n\n"NO"*"G" От $1 до $1.000.000\n\n","Положить","Отмена");
			if(GetPlayerMoneyEx(playerid) < sum) return D(playerid,D_BIZZ_BANK_PUT,1,"Бизнес","\n\n"W"Введите сумму, которую хотите положить в кассу бизнеса:\n\n"NO"*"G" У Вас недостаточно средств\n\n","Положить","Отмена");
			if(UpdateBusinessData(id+1,"bank",gBusiness[id][bizzBank] + sum)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #20");
			gBusiness[id][bizzBank] += sum;
			UpdateBusinessData(id+1,"bank",gBusiness[id][bizzBank]);
			GiveMoney(playerid,-sum,"положил в банк бизнеса");

			new string[128];
			format(string,sizeof(string),"Вы положили в кассу бизнеса: "ORANGE"$%d",sum);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_PRICE: {
			if(!response) return callcmd::bpanel(playerid);
			new id = PI[playerid][pBusiness] - 1;
			if(id < 0) return true;
			new price = strval(inputtext);
			if(gBusiness[id][bizzType] == 7) {
				if(price < 12 || price > 24) return D(playerid,D_BIZZ_PRICE,DSI, ""P"Бизнес","\n\n"W"Введите цену за 1 литр\nПримечание: от "GREEN"$12"W" до "GREEN"$24\n\n","Изменить","Отмена");
			}
			else {
				if(price < 1 || price > 5) return D(playerid,D_BIZZ_PRICE,DSI, ""P"Бизнес","\n\n"W"Введите цену за "P"1"W" ед. товара\nПримечание: от "GREEN"$1"W" до "GREEN"$5\n\n","Изменить","Отмена");
			}
			gBusiness[id][bizzPrice] = price;
			UpdateBusinessData(id+1,"price",price);
			UpdateBusinessText(id);
			new string[128];
			if(gBusiness[id][bizzType] == 7) format(string,sizeof(string),"Цена за "P"1"G" литр установлена: "ORANGE"$%d",price);
			else format(string,sizeof(string),"Цена за "P"1"G" ед. товара установлена: "ORANGE"$%d",price);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_ENTER: {
			if(!response) return callcmd::bpanel(playerid);
			new id = PI[playerid][pBusiness] - 1;
			if(id < 0) return true;
			new price = strval(inputtext);
			if(price < 0 || price > 5000) return D(playerid,D_BIZZ_ENTER,DSI, ""P"Бизнес","\n\n"W"Введите цену за вход\nПримечание: от "GREEN"$0"W" до "GREEN"$5000\n\n","Изменить","Отмена");
			gBusiness[id][bizzEnter] = price;
			UpdateBusinessData(id+1,"enter",price);
			UpdateBusinessText(id);
			new string[128];
			format(string,sizeof(string),"Цена за вход установлена: "ORANGE"$%d",price);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_ENTERS: {
			if(!response) return 1;
			new businessid = TI[playerid][tSelectedBusinessID];
			if(businessid < 0) return true;
		    new price = gBusiness[businessid][bizzEnter];
			new bint = gBusiness[businessid][bizzBint]-1;
			if(bint < 0 || bint >= BINT_COUNT) return 1;
			if(PI[playerid][pVips] == VIP_PLATINA) {
				if(GetPlayerMoneyEx(playerid) < price/2) return ErrorMessage(playerid,"У Вас недостаточно денег");
				GiveMoney(playerid,-floatround(price/2),"вход в бизнес");
				bizz_pay(businessid,floatround(price/2));
			}
			else if(PI[playerid][pVips] == VIP_NONE || PI[playerid][pVips] == VIP_SILVER || PI[playerid][pVips] == VIP_GOLD || PI[playerid][pVips] == VIP_SILVER || PI[playerid][pVips] == VIP_SILVER) {
				if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
				GiveMoney(playerid,-price,"вход в бизнес");
				bizz_pay(businessid,price);
			}
			TI[playerid][tTPpick] = true;
			SetPlayerPosAC(playerid, gBints[bint][bintX],gBints[bint][bintY],gBints[bint][bintZ], businessid+1, gBints[bint][bintInterior]);
			SetPlayerFacingAngle(playerid,gBints[bint][bintR]);
			FreezePlayerForTime(playerid,5);
			gBusiness[businessid][bizzVisitors]++;
			SetCameraBehindPlayer(playerid);
			if(gBusiness[businessid][bizzType] == 10 || gBusiness[businessid][bizzType] == 11 || gBusiness[businessid][bizzType] == 14 || gBusiness[businessid][bizzType] == 15) OnPlayerUpdateLoadingMode(playerid);
		}
		case dBusinessProd: {
			if(!response) return callcmd::bpanel(playerid);
			new put = strval(inputtext);
			new bizid = PI[playerid][pBusiness]-1;
			if(gBusiness[bizid][bizzProdOrder]) return ErrorMessage(playerid,"Вы уже заказали продукты, ожидайте когда развозчики доставят его в Ваш бизнес");
			if(put < 500 || put > gBusiness[bizid][bizzUpgrade][0]) {
				static const f_str[] = "\n\n"W"Введите кол-во продуктов, которое хотите заказать:\n\n"NO"*"G" Минимум 500 максимум %d\n\n";
				new string[sizeof(f_str) +1 + (-2 + 6)];
				format(string,sizeof(string),f_str,gBusiness[bizid][bizzUpgrade][0]);
				D(playerid,dBusinessProd,DSI, ""P"Заказ продуктов", string, "Далее", "Отмена");
				return 1;
			}
			if(gBusiness[bizid][bizzProduct]+put > gBusiness[bizid][bizzUpgrade][0]) return D(playerid,dBusinessProd,DSI, ""P"Заказ продуктов", "\n\n"W"Введите кол-во продуктов, которое хотите заказать:\n\n"NO"*"G" На Вашем складе достаточно продуктов\n\n", "Далее", "Отмена");

			SetPVarInt(playerid,"buy_prod",put);
			D(playerid,dBusinessProd2,DSI, ""P"Заказ продуктов", "\n\n"W"Введите цену за "P"1"W" продукт:\nПримечание: от "GREEN"$2"W" до "GREEN"$4\n\n", "Заказать", "Отмена");
			return 1;
		}
		case dBusinessProd2: {
			if(!response) return callcmd::bpanel(playerid),DeletePVar(playerid,"buy_prod");
			new put;
			new bizid = PI[playerid][pBusiness]-1;
			if(sscanf(inputtext,"i",put)) return D(playerid,dBusinessProd2,DSI, ""P"Заказ продуктов", "\n\n"W"Введите цену за "P"1"W" продукт:\nПримечание: от "GREEN"$2"W" до "GREEN"$4\n\n", "Заказать", "Отмена");
			if(put < 2 || put > 4) return D(playerid,dBusinessProd2,DSI, ""P"Заказ продуктов", "\n\n"W"Введите цену за "P"1"W" продукт:\nПримечание: от "GREEN"$2"W" до "GREEN"$4\n\n", "Заказать", "Отмена");
			new string[144];
			new prod = GetPVarInt(playerid,"buy_prod") * put;
			if(gBusiness[bizid][bizzBank] < prod) {
				format(string, sizeof(string), "Недостаточно средств на счету бизнеса. Для оплаты необходимо: "NO"$%d",prod);
				ErrorMessage(playerid,string);
				DeletePVar(playerid,"buy_prod");
				return 1;
			}
			gBusiness[bizid][bizzBank] -= prod;
			gBusiness[bizid][bizzProdOrder] = GetPVarInt(playerid,"buy_prod");
			gBusiness[bizid][bizzProdOrderPrice] = put;

			SaveBusiness(bizid);

			format(string, sizeof(string), ""W"Заказано продуктов: "O"%d\n"W"Оплачено со счёта бизнеса: "GREEN"$%d",gBusiness[bizid][bizzProdOrder],gBusiness[bizid][bizzProdOrderPrice]*gBusiness[bizid][bizzProdOrder]);
			D(playerid,DIALOG_NONE,DSM, ""P"Заказ продуктов", string, "Закрыть", "");
			DeletePVar(playerid,"buy_prod");
			return 1;
		}
		case D_BIZZ_STATS: return callcmd::bpanel(playerid);
		case D_AMMO: {
			if(!response) return 1;
			switch(listitem) {
				case 0..5,12,13: {
					new bizid = TI[playerid][tSelectedBusinessID];
					new slot = listitem;
					if(PI[playerid][pCash] < gSellGunPrice[slot]*gBusiness[bizid][bizzPrice]) return ErrorMessage(playerid,"Недостаточно денег");
					new gun_name[32 + 1],string[128];
					GetWeaponName(gSellGun[slot],gun_name,32);
					if(gBusiness[bizid][bizzProduct]-gSellGunProds[slot] > 0) {
						gBusiness[bizid][bizzProduct] -= gSellGunProds[slot];
						bizz_pay(bizid,(gSellGunPrice[slot] * gBusiness[bizid][bizzPrice]));
					}
					UpdateBusinessText(bizid);

					if(listitem < 12) {
						format(string, sizeof(string), "Вы купили "P"%s "G"за "ORANGE"$%i",gun_name, gSellGunPrice[slot] * gBusiness[bizid][bizzPrice]);
						SendUse(playerid, string);
						AC_GivePlayerWeapon(playerid,gSellGun[slot],1);
					}
					else if(listitem == 12) {
						SetPlayerArmour(playerid,100);
						format(string, sizeof(string), "Вы купили "P"Armour "G"за "ORANGE"$%i", gSellGunPrice[slot] * gBusiness[bizid][bizzPrice]);
						SendUse(playerid, string);
					}
					else if(listitem == 13) {
						//return ErrorMessage(playerid,"В разработке. Уже скоро...");
						if(TI[playerid][tTir]) return ErrorMessage(playerid,"У Вас уже есть пропуск в тир");
						format(string, sizeof(string), "Вы купили "P"пропуск в тир "G"за "ORANGE"$%i", gSellGunPrice[slot] * gBusiness[bizid][bizzPrice]);
						SendUse(playerid, string);
						TI[playerid][tTir] = true;
					}
					GiveMoney(playerid,-gSellGunPrice[slot] * gBusiness[bizid][bizzPrice],"покупка оружия(аммо)");
				}
				case 6..11: {
					D(playerid,D_AMMO_2, DIALOG_STYLE_INPUT, "Меню аммо", ""W"Введите количество патрон, которое хотите купить:", "Далее", "Отмена");
					SetPVarInt(playerid,"slot_ammo", listitem);
				}
			}
			return 1;
		}
		case D_AMMO_2: {
			if(!response) return DeletePVar(playerid,"slot_ammo");
			new slot = GetPVarInt(playerid,"slot_ammo");
			new bizid = TI[playerid][tSelectedBusinessID];
			new patron = strval(inputtext);
			if(patron <= 0 || patron > 1000) return D(playerid,D_AMMO_2, DIALOG_STYLE_INPUT, "Меню аммо", ""W"Введите количество патрон, которое хотите купить:\n\n"NO"*"G" От 1 до 1000 патрон", "Далее", "Отмена");
			if(PI[playerid][pCash] < gSellGunPrice[slot]*gBusiness[bizid][bizzPrice] * patron) return D(playerid,D_AMMO_2, DIALOG_STYLE_INPUT, "Меню аммо", ""W"Введите количество патрон, которое хотите купить:\n\n"NO"*"G" Недостаточно средств", "Далее", "Отмена");
			new gun_name[32 + 1],string[128];
			GetWeaponName(gSellGun[slot],gun_name,32);
			format(string, sizeof(string), "Вы купили "P"%s [%i пат.] "G"за "ORANGE"$%i",gun_name,patron, gSellGunPrice[slot] * gBusiness[bizid][bizzPrice] * patron);
			SendUse(playerid, string);
			if(gBusiness[bizid][bizzProduct]-gSellGunProds[slot]*patron > 0) {
				gBusiness[bizid][bizzProduct] -= gSellGunProds[slot]*patron;
				bizz_pay(bizid,(gSellGunPrice[slot] * gBusiness[bizid][bizzPrice] * patron));
			}

			AC_GivePlayerWeapon(playerid,gSellGun[slot],patron);
			GiveMoney(playerid,-gSellGunPrice[slot] * gBusiness[bizid][bizzPrice] * patron,"покупка оружия(аммо)");
			DeletePVar(playerid,"slot_ammo");
			return 1;
		}
		case D_BOX_2: {
			if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			if(id < 0) return 1;
			switch(listitem) {
				case 0: {
					if(GetPlayerMoneyEx(playerid) < gBusiness[id][bizzPrice]*150) return ErrorMessage(playerid,"У Вас недостаточно денег");
					bizz_pay(id,gBusiness[id][bizzPrice]*150);
					GiveMoney(playerid, -gBusiness[id][bizzPrice]*150,"покупка в спортзале");
					if(PI[playerid][pSex] == 1) A_SetPlayerSkin(playerid, 80);
					else A_SetPlayerSkin(playerid,192);
					TI[playerid][tGym] = true;
					//SendOk(playerid,"Для выход на ринге введите '/fight'");
				}
				case 1..3: {
					if(!TI[playerid][tGym]) return ErrorMessage(playerid,"Для начала приобретите спортивную форму");
					if(TI[playerid][tGymSkill]) return ErrorMessage(playerid,"Вы уже изучаете стиль боя");
					if(PI[playerid][pBox] == listitem) return ErrorMessage(playerid,"У Вас уже изучен данный стиль боя");
					if(PI[playerid][pBox]+1 < listitem) return ErrorMessage(playerid,"Для начала изучите предыдущий стиль боя");
					if(GetPlayerMoneyEx(playerid) < 5000) return ErrorMessage(playerid,"У Вас недостаточно денег");
					if(gBusiness[id][bizzProduct]-130 > 0) {
						gBusiness[id][bizzProduct] -= 130;
						bizz_pay(id,5000);
					}
					GiveMoney(playerid, -5000,"покупка в спортзале");
					SendOk(playerid,"Вы начали тренировку, бейте по грушам для прокачки навыка боя");
					TI[playerid][tGymSkill] = listitem;
				}
				case 4: {
					if(GetPlayerMoneyEx(playerid) < 200) return ErrorMessage(playerid,"У Вас недостаточно денег");
					if(TI[playerid][tGyms] + 250 > 1000) return ErrorMessage(playerid,"Нельзя взять больше 1 литра шейкера");
					if(gBusiness[id][bizzProduct]-20 > 0) {
						gBusiness[id][bizzProduct] -= 20;
						bizz_pay(id,200);
					}
					GiveMoney(playerid, -200,"покупка в спортзале");
					TI[playerid][tGyms] += 250;
					SendOk(playerid,"Вы купили шейкер Smart 250мл на 250 ударов");
				}
				case 5: {
					if(GetPlayerMoneyEx(playerid) < 350) return ErrorMessage(playerid,"У Вас недостаточно денег");
					if(TI[playerid][tGyms] + 500 > 1000) return ErrorMessage(playerid,"Нельзя взять больше 1 литра шейкера");
					if(gBusiness[id][bizzProduct]-35 > 0) {
						gBusiness[id][bizzProduct] -= 35;
						bizz_pay(id,350);
					}
					GiveMoney(playerid, -350,"покупка в спортзале");
					TI[playerid][tGyms] += 500;
					SendOk(playerid,"Вы купили шейкер BSN 500мл на 500 ударов");
				}
				case 6: {
					if(GetPlayerMoneyEx(playerid) < 500) return ErrorMessage(playerid,"У Вас недостаточно денег");
					if(TI[playerid][tGyms] + 750 > 1000) return ErrorMessage(playerid,"Нельзя взять больше 1 литра шейкера");
					if(gBusiness[id][bizzProduct]-50 > 0) {
						gBusiness[id][bizzProduct] -= 50;
						bizz_pay(id,500);
					}
					GiveMoney(playerid, -500,"покупка в спортзале");
					TI[playerid][tGyms] += 750;
					SendOk(playerid,"Вы купили шейкер Biotech 750мл на 750 ударов");
				}
				case 7: {
					D(playerid,DIALOG_NONE,DSM, ""P"Информация",""W"Шейкер поможет тебе ускорить прокачку стиля боя на "ORANGE"30%.\n"W"Для наиоблее эффективной тренировки рекомендуем приобрести "ORANGE"1000мл шейкера.\n\n"NO"Внимание!"W" Если Вы вышли из игры не закончив тренировку, Ваш прогресс сохранится.\nЗа форму, тренировку и шейкер придётся заплатить снова. Удачной тренировки!\n\n","Закрыть","");
				}
				case 8: {
					if(PI[playerid][pMember] && start_work[playerid]) {
						A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
						SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
					}
					else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
					TI[playerid][tGym] = false;
					SendOk(playerid,"Вы закончили тренировку");
				}
			}
		}
		case D_BIZZ_24: {
			if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			if(id < 0) return 1;
			new price = gShopPrice[listitem]*gBusiness[id][bizzPrice];
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			switch(listitem) {
				case 0: {
					if(PI[playerid][pPhone]) return ErrorMessage(playerid,"У Вас уже есть телефон"),show_24(playerid,id);
					new number;
					number = Random(100000,999999);
					PI[playerid][pPhone] = number;
					UpdatePlayerData(playerid,"pPhone",number);
					new string[100];
					format(string,sizeof(string),"Поздравляем с приобретением телефона! Ваш номер: "ORANGE"%d",number);
					SendUse(playerid,string);

					if(QuestProgress[playerid][2] < 1 && AcceptQuest[playerid][2] != 0)
					{
						QuestProgress[playerid][2] ++,save_quest(playerid,2);
						SendUse(playerid,"Вы успешно завершили квест 'Сотовая связь'");
						SendUse(playerid,"Данное задание можно завершить и получите за него награду");
						NextStapQI(playerid,2);
					}
					
				}
				case 1: {
					AC_GivePlayerWeapon(playerid,43,20);
					SendUse(playerid,"Поздравляем с покупкой камеры! Вы можете запечатлить 20 кадров");
				}
				case 2: {
					if(PI[playerid][pWatch]) return ErrorMessage(playerid,"У Вас уже есть часы"),show_24(playerid,id);
					PI[playerid][pWatch] = 1;
					UpdatePlayerData(playerid,"watch",1);
					SendUse(playerid,"Поздравляем с приобретением часов! Посмотреть время - "ORANGE"/time");
				}
				case 3: {
					if(PI[playerid][pBook]) return ErrorMessage(playerid,"У Вас уже телефонная книга"),show_24(playerid,id);
					PI[playerid][pBook] = 1;
					UpdatePlayerData(playerid,"book",1);
					SendUse(playerid,"Поздравляем с приобретением телефонной книги! Контакты - "ORANGE"/book");
				}
				case 4: {
				    if(!PI[playerid][pPhone]) return ErrorMessage(playerid,"У Вас нет телефона"),show_24(playerid,id);
					return D(playerid,D_BIZZ_SIM,DSI, ""P"Покупка номера","\n\n"W"Введите номер, который хотите использовать (6 цифр):\n\n","Купить","Закрыть");
				}
				case 5: {
					if(PI[playerid][pMask] >= vip_status[PI[playerid][pVips]][vip_mask]) {
						new string[128];
						format(string,sizeof(string),"Нельзя хранить больше %d масок",vip_status[PI[playerid][pVips]][vip_mask]);
						ErrorMessage(playerid, string),show_24(playerid,id);
						return 1;
					}
     				PI[playerid][pMask] += 1;
					UpdatePlayerData(playerid,"pMask",PI[playerid][pMask]);
					SendUse(playerid,"Поздравляем с покупкой маски! Использовать маску - "ORANGE"/mask");
				}
				case 6: return D(playerid,D_BIZZ_MEDKIT,DSL, ""P"Покупка аптечки",""P"1."W" Себе\n"P"2."W" В дом\n"P"3."W" В банду","Купить","Закрыть");
				case 7: {
					for(new i; i <= 11; i++) {
						new gunid, ammo;
						GetPlayerWeaponData(playerid, i, gunid,ammo);
						if(gunid == 14) return ErrorMessage(playerid,"У Вас уже есть цветы"),show_24(playerid,id);
					}
					AC_GivePlayerWeapon(playerid,14,1);
					SendUse(playerid,"Поздравляем с покупкой цветов! Подарить цветы - "ORANGE"/flowers");
				}
				case 8: {
					if(PI[playerid][pInstrument] >= 5) return ErrorMessage(playerid,"Нельзя хранить больше 5 ремкомплектов");
					PI[playerid][pInstrument] ++;
					UpdatePlayerData(playerid,"pInstr",PI[playerid][pInstrument]);
					SendUse(playerid,"Поздравляем с покупкой ремкомплекта! Починть транспорт - "ORANGE"/remp");
				}
				case 9: {
					AC_GivePlayerWeapon(playerid,41,5000);
					SendUse(playerid,"Поздравляем с покупкой балончика с краской!");
				}
				case 10: {
					if(PI[playerid][pJemmy] >= vip_status[PI[playerid][pVips]][vip_jimmy]) {
						new string[128];
						format(string,sizeof(string),"Нельзя хранить больше %d отмычек",vip_status[PI[playerid][pVips]][vip_mask]);
						ErrorMessage(playerid, string),show_24(playerid,id);
						return 1;
					}
					PI[playerid][pJemmy] ++;
					UpdatePlayerData(playerid,"pJemmy",PI[playerid][pJemmy]);
					SendUse(playerid,"Поздравляем с покупкой отмычки! Она понадобится Вам при взломе дверного замка");
				}
				case 11: {
					if(PI[playerid][pBoomBox]) return ErrorMessage(playerid, "У вас уже есть бумбокс, используйте /boombox");
					PI[playerid][pBoomBox] = 1;
					UpdatePlayerData(playerid,"pBoomBox",PI[playerid][pBoomBox]);
					SendClientMessage(playerid,0x66cc00ff,"Вы купили Бумбокс. Используйте {FF9900}/boombox{66cc00} чтобы установить бумбокс");
				}
			}
			if(gBusiness[id][bizzProduct]-gShopProduct[listitem] > 0) {
				gBusiness[id][bizzProduct] -= gShopProduct[listitem];
				bizz_pay(id,price);
			}

			if(listitem != 0) show_24(playerid,id);

            GiveMoney(playerid, -price,"покупка в 24-7");
			show_24(playerid,id);
		}
		case D_BIZZ_SIM: {
      		if(!response) return true;
		    if(!IsNumber(inputtext) || strlen(inputtext) != 6 || inputtext[0] == '0') {
				D(playerid,D_BIZZ_SIM,DSI, ""P"Покупка номера","\n\n"W"Введите номер, который хотите использовать (6 цифр):\n\n"NO"*"G" Номер должен состоять из 6 цифр. Первая цифра не должны быть \"ноль\"\n\n","Купить","Закрыть");
				return true;
			}
			new query[128], id = TI[playerid][tSelectedBusinessID], price = gShopPrice[4]*gBusiness[id][bizzPrice];
			format(query,sizeof(query),"SELECT `pPhone` FROM `accounts` WHERE `pPhone` = '%i'",strval(inputtext));
			mysql_tquery(connects, query, "sim_shop", "dddd", playerid, strval(inputtext), id, price);
		}
		case D_BIZZ_MEDKIT: {
			if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			switch(listitem) {
				case 0: {
					if(PI[playerid][pMedKit] == vip_status[PI[playerid][pVips]][vip_heal]) {
						new string[128];
						format(string,sizeof(string),"Нельзя хранить больше %d аптечек",vip_status[PI[playerid][pVips]][vip_heal]);
						ErrorMessage(playerid, string),show_24(playerid,id);
						return 1;
					}
					static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ карман поместится: "P"%d"W" аптечек";
					new string[sizeof(f_str) + 5];
					format(string,sizeof(string),f_str,vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
					return D(playerid,D_BIZZ_MEDKIT_2,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
				}
				case 1: {
					if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома"),show_24(playerid,id);
					if(gHouses[PI[playerid][pHouse]-1][houseHealth] == 500) return ErrorMessage(playerid, "Нельзя хранить больше 500 аптечек в сейфе дома"),show_24(playerid,id);
					static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ сейф дома поместится: "P"%d"W" аптечек";
					new string[sizeof(f_str) + 5];
					format(string,sizeof(string),f_str,500-gHouses[PI[playerid][pHouse]-1][houseHealth]);
					return D(playerid,D_BIZZ_MEDKIT_4,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
				}
				case 2: {
					if(!IsAGang(playerid)) return ErrorMessage(playerid,"Вы не состоите в банде"),show_24(playerid,id);
					if(FI[PI[playerid][pMember]][fHealth] == 500) return ErrorMessage(playerid, "Нельзя хранить больше 500 аптечек на складе банды"),show_24(playerid,id);
					static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nНа склад банды поместится: "P"%d"W" аптечек";
					new string[sizeof(f_str) + 5];
					format(string,sizeof(string),f_str,500-FI[PI[playerid][pMember]][fHealth]);
					return D(playerid,D_BIZZ_MEDKIT_3,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
				}
			}
		}
		case D_BIZZ_MEDKIT_2: {
			if(!response) return true;
			if(strval(inputtext) < 1 || strval(inputtext) > vip_status[PI[playerid][pVips]][vip_heal]) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ карман поместится: "P"%d"W" аптечек\n\n"NO"*"G" От 1 и до %d";
				new string[sizeof(f_str) + 8];
				format(string,sizeof(string),f_str,vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit],vip_status[PI[playerid][pVips]][vip_heal]);
				return D(playerid,D_BIZZ_MEDKIT_2,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			if(PI[playerid][pMedKit]+strval(inputtext)>vip_status[PI[playerid][pVips]][vip_heal]) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ карман поместится: "P"%d"W" аптечек\n\n"NO"*"G" В карман не поместится столько аптечек";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
				return D(playerid,D_BIZZ_MEDKIT_2,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			new id = TI[playerid][tSelectedBusinessID];
			if(GetPlayerMoneyEx(playerid)<gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext)) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ карман поместится: "P"%d"W" аптечек\n\n"NO"*"G" У Вас недостаточно средств";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
				return D(playerid,D_BIZZ_MEDKIT_2,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			GiveMoney(playerid, -gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext), "покупка в 24-7");
			if(gBusiness[id][bizzProduct]-(gShopProduct[6]*strval(inputtext)) > 0) {
				gBusiness[id][bizzProduct]-= gShopProduct[6]*strval(inputtext);
				bizz_pay(id,gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext));
			}
			UpdateBusinessText(id);
			show_24(playerid,id);
			PI[playerid][pMedKit] += strval(inputtext);
			UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
			SendUse(playerid, "Поздравляем с покупкой аптечек! Использовать аптечку - "ORANGE"/healme");
		}
		case D_BIZZ_MEDKIT_3: {
			if(!response) return true;
			if(strval(inputtext) < 1 || strval(inputtext) > 500) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nНа склад банды поместится: "P"%d"W" аптечек\n\n"NO"*"G" От 1 и до 500";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-FI[PI[playerid][pMember]][fHealth]);
				return D(playerid,D_BIZZ_MEDKIT_3,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			if(FI[PI[playerid][pMember]][fHealth]+strval(inputtext)>500) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nНа склад банды поместится: "P"%d"W" аптечек\n\n"NO"*"G" На склад банды не поместится столько аптечек";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-FI[PI[playerid][pMember]][fHealth]);
				return D(playerid,D_BIZZ_MEDKIT_3,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			new id = TI[playerid][tSelectedBusinessID];
			if(GetPlayerMoneyEx(playerid)<gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext)) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nНа склад банды поместится: "P"%d"W" аптечек\n\n"NO"*"G" У Вас недостаточно средств";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-FI[PI[playerid][pMember]][fHealth]);
				return D(playerid,D_BIZZ_MEDKIT_3,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			GiveMoney(playerid, -gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext), "покупка в 24-7");
			if(gBusiness[id][bizzProduct]-(gShopProduct[6]*strval(inputtext)) > 0) {
				gBusiness[id][bizzProduct]-= gShopProduct[6]*strval(inputtext);
				bizz_pay(id,gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext));
			}
			UpdateBusinessText(id);
			show_24(playerid,id);
			FI[GetTeamID(playerid)][fHealth] += strval(inputtext);
			UpdateFraction(GetTeamID(playerid),"Health",FI[GetTeamID(playerid)][fHealth]);
			SendUse(playerid, "Поздравляем с покупкой аптечек!");
		}
		case D_BIZZ_MEDKIT_4: {
			if(!response) return true;
			if(!PI[playerid][pHouse]) return 1;
			new houseid = PI[playerid][pHouse]-1;
			if(strval(inputtext) < 1 || strval(inputtext) > 500) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ сейф дома поместится: "P"%d"W" аптечек\n\n"NO"*"G" От 1 и до 500";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-gHouses[houseid][houseHealth]);
				return D(playerid,D_BIZZ_MEDKIT_4,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			if(gHouses[houseid][houseHealth]+strval(inputtext)>500) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ сейф дома поместится: "P"%d"W" аптечек\n\n"NO"*"G" В сейф дома не поместится столько аптечек";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-gHouses[houseid][houseHealth]);
				return D(playerid,D_BIZZ_MEDKIT_4,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			new id = TI[playerid][tSelectedBusinessID];
			if(GetPlayerMoneyEx(playerid)<gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext)) {
				static const f_str[] = "\n\n"W"Введите кол-во аптечек, которое хотите приобрести:\nВ сейф дома поместится: "P"%d"W" аптечек\n\n"NO"*"G" У Вас недостаточно средств";
				new string[sizeof(f_str) + 5];
				format(string,sizeof(string),f_str,500-gHouses[houseid][houseHealth]);
				return D(playerid,D_BIZZ_MEDKIT_4,DSI, ""P"Покупка аптечки",string,"Купить","Закрыть");
			}
			GiveMoney(playerid, -gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext), "покупка в 24-7");
			if(gBusiness[id][bizzProduct]-(gShopProduct[6]*strval(inputtext)) > 0) {
				gBusiness[id][bizzProduct]-= gShopProduct[6]*strval(inputtext);
				bizz_pay(id,gShopPrice[6]*gBusiness[id][bizzPrice]*strval(inputtext));
			}
			UpdateBusinessText(id);
			show_24(playerid,id);
			gHouses[houseid][houseHealth] += strval(inputtext);
			new query[128];
			format(query,sizeof(query),"UPDATE `houses` SET `medkit` = '%d' WHERE id = '%d'",gHouses[houseid][houseHealth],houseid+1);
			mysql_tquery(connects, query);
			SendUse(playerid, "Поздравляем с покупкой аптечек! Использовать аптечку в доме: /hhealme");
		}
		case D_BIZZ_FISH: {
		    if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			if(id < 0) return 1;
			if(listitem != 4) if(GetPlayerMoneyEx(playerid) < gFishCosts[listitem]*gBusiness[id][bizzPrice]) return ErrorMessage(playerid,"У Вас недостаточно денег");
			switch(listitem) {
				case 0: {
					if(PI[playerid][pRod]) return ErrorMessage(playerid,"У Вас уже есть удочка");
					PI[playerid][pRod] = 1;
					UpdatePlayerData(playerid,"pRod",1);
					SendUse(playerid,"Поздравляем с приобретением удочки!");
				}
				case 1: {
				    if(PI[playerid][pRopes]) return ErrorMessage(playerid,"У Вас уже есть снасти");
					PI[playerid][pRopes] = 1;
					UpdatePlayerData(playerid,"pRopes",1);
					SendUse(playerid,"Поздравляем с приобретением снастей для удочки!");
				}
				case 2: {
					if(PI[playerid][pWorms] + 10 > 30) return ErrorMessage(playerid,"Вы не можете купить более 30 шт наживки.");
					PI[playerid][pWorms] += 10;
					SendUse(playerid,"Поздравляем с приобретением наживки!");
				}
				case 3: {
					if(GetPVarInt(playerid,"fish_yes")) return ErrorMessage(playerid,"У Вас уже есть пропуск на ловлю рыбы");
					if(!lic[playerid][2]) return ErrorMessage(playerid, "У Вас нет лицензии на водный транспорт");
					SetPVarInt(playerid,"fish_yes",1);
					SendUse(playerid,"Поздравляем с приобретением одноразового пропуска для ловли рыбы!");
					SendUse(playerid,"Для начала рыбалки сядьте в свободную рыболовную лодку на пирсе!");
				}
				case 4: {
					D(playerid, DIALOG_NONE, DSM, ""P"Информация", ""W"Для начала рыбалки приобретите всё необходимое и сядьте в свободную лодку на пирсе\nПойманую рыбу Вы можете продать на складе\n возле рыболовного магазина по курсу "ORANGE"$160 - 1кг"W",\n или положить в холодильник в доме.\n\n\
						"NO"Внимание! "W"Для наиболее эффективной и выгодной рыбалки рекомендуем приобрести 30шт.\n Наживки. Пропуск одноразовый. Удочка и снасти покупаются раз и навсегда.\nУдачной рыбалки!", "Закрыть", "");
					return 1;
				}
			}
			GiveMoney(playerid, -gFishCosts[listitem]*gBusiness[id][bizzPrice],"покупка в рыб.бизнесе");
			if(gBusiness[id][bizzProduct]-(gFishCosts[listitem] / 10) > 0) {
				gBusiness[id][bizzProduct] -= gFishCosts[listitem] / 10;
				bizz_pay(id,gFishCosts[listitem]*gBusiness[id][bizzPrice]);
			}
			show_fish(playerid);
		}
		case D_BIZZ_BAR: {
		    if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			if(id < 0) return 1;
			new price = gBarCosts[listitem] * 10 * gBusiness[id][bizzPrice];
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid, -price,"покупка в баре");
			if(gBusiness[id][bizzProduct] - (gBarCosts[listitem]) > 0){
				gBusiness[id][bizzProduct] -= gBarCosts[listitem];
				bizz_pay(id,price);
			}
			if(listitem == 0) SetPlayerSpecialAction(playerid, 22);
			else SetPlayerSpecialAction(playerid, 20);
		}
		case D_BIZZ_COMP: {
		    if(!response) return 1;
			if(GetPVarInt(playerid,"comp_game") > unix) return ErrorMessage(playerid,"У Вас уже куплен билет");
			new id = TI[playerid][tSelectedBusinessID];
			if(id < 0) return 1;
			new price = gCompCosts[listitem] * gBusiness[id][bizzPrice];
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid, -price,"покупка в комп клубе");
			bizz_pay(id,price);
			switch(listitem) {
				case 0: {
					SendUse(playerid,"Поздравляем с приобретением игрового времени [30 мин] в клубе");
					SetPVarInt(playerid,"comp_game",unix+1800);
				}
				case 1: {
					SendUse(playerid,"Поздравляем с приобретением игрового времени [1 час] в клубе");
					SetPVarInt(playerid,"comp_game",unix+3600);
				}
				case 2: {
					SendUse(playerid,"Поздравляем с приобретением игрового времени [2 часа] в клубе");
					SetPVarInt(playerid,"comp_game",unix+7200);
				}
				case 3: {
					SendUse(playerid,"Поздравляем с приобретением игрового времени [3 часа] в клубе");
					SetPVarInt(playerid,"comp_game",unix+10800);
				}
			}
		}
  		case D_BIZZ_TAVERN: {
			if(!response) return 1;
			new id = TI[playerid][tSelectedBusinessID];
			new price = gTavernCosts[listitem] * gBusiness[id][bizzPrice] * 10;
			if(id < 0) return 1;
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			new amount = gTavernCosts[listitem];
			if(gBusiness[id][bizzProduct] -amount > 0) {
				gBusiness[id][bizzProduct]-= amount;
				bizz_pay(id,price);
			}
			if(PI[playerid][pSatiety] >= 100) return ErrorMessage(playerid,"Вы не голодны");
			GiveMoney(playerid, -price,"покупка в закусочной");
			new name[32],string[64];
			switch(listitem) {
				case 0: {
					strcat(name,"салат");
					GiveFullness(playerid, 25);
				}
				case 1: {
					strcat(name,"наггетсы");
					GiveFullness(playerid, 35);
				}
				case 2: {
					strcat(name,"бургер");
					GiveFullness(playerid, 45);
				}
				case 3: {
					strcat(name,"пиццу");
					GiveFullness(playerid, 55);
				}
			}
			format(string,sizeof(string),"съел(а) %s", name);
			MeAction(playerid,string);
			ApplyAnimation(playerid,"FOOD","EAT_Burger", 2.0,0,0,0,0,5000,1);
			show_tavern(playerid,id);

			if(QuestProgress[playerid][6] < 1 && AcceptQuest[playerid][6] != 0)
			{
				QuestProgress[playerid][6] ++,save_quest(playerid,6);
				D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно перекусили. Данное задание можно завершить и забрать за него награду","Закрыть","");
				NextStapQI(playerid,6);
			}
		}
		case D_BOOK: {
			if(!response) return 1;
			SetPVarInt(playerid,"select_idphone",listitem);
			if(PI[playerid][pPhoneNumber][listitem] == 0) return D(playerid, D_BOOK_2, DSI, ""P"Новый контакт", ""W"Введите номер телефона:", "Далее", "Отмена");
			D(playerid, D_BOOK_3, DSL, ""P"Телефонная книга", ""P"1."W" Позвонить\n"P"2."W" Написать сообщение\n"P"3."W" Удалить контакт", "Выбрать", "Отмена");
			return 1;
		}
		case D_BOOK_2: {
			if(!response) return DeletePVar(playerid,"select_idphone");
			if(!IsNumber(inputtext) || strlen(inputtext) != 6) {
				D(playerid,D_BOOK_2,DSI, ""P"Новый контакт",""W"Введите номер телефона:\n\n"NO"*"G" Номер должен состоять из 6 цифр","Далее","Отмена");
				return 1;
			}
			new number = strval(inputtext);
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				//new bool:isnumber = false;
				if(!TI[i][tLogin]) continue;
				if(PI[i][pPhone] == number) {
					//isnumber = true;
					new id = GetPVarInt(playerid,"select_idphone");
					PI[playerid][pPhoneNumber][id] = number;
					strmid(pPhoneName[playerid][id],player_name[i],0,strlen(player_name[i]),MAX_PLAYER_NAME);
					SavePlayerNumber(playerid);
					SendOk(playerid,"Контакт успешно добавлен");
					break;
				}
				//if(!isnumber) return D(playerid,D_BOOK_2,DSI, ""P"Новый контакт",""W"Введите номер телефона:\n\n"NO"*"G" Номер не найден/игрок оффлайн","Далее","Отмена");
			}
		}
		case D_BOOK_3: {
			if(!response) return 1;
			new id = GetPVarInt(playerid,"select_idphone");
			switch(listitem) {
				case 0: {
					new string[24];
					format(string, sizeof(string), "%i",PI[playerid][pPhoneNumber][id]);
					callcmd::call(playerid,string);
				}
				case 1: D(playerid,D_BOOK_4,DSI, ""P"Сообщение",""W"Введите текст СМС сообщения:\nПримечание: Длинна текста от 1 до 120 символов","Далее","Закрыть");
				case 2: {
					PI[playerid][pPhoneNumber][id] = 0;
					strmid(pPhoneName[playerid][id], "Нет", 0, strlen("Нет"), MAX_PLAYER_NAME);
					SavePlayerNumber(playerid);
					SendOk(playerid,"Контакт успешно удалён");
					callcmd::book(playerid);
				}
			}
		}
		case D_BOOK_4: {
			if(!response) return 1;
			if(NonSym(inputtext,120,1)) return D(playerid,D_BOOK_4,DSI, ""P"Сообщение",""W"Введите текст СМС сообщения:\n\n"NO"*"G" Запрещены некорректные символы","Далее","Закрыть");
			if(strlen(inputtext) < 1 || strlen(inputtext) > 120) return D(playerid,D_BOOK_4,DSI, ""P"Сообщение",""W"Введите текст СМС сообщения:\n\n"NO"*"G" Длинна текста от 1 до 120 символов","Далее","Закрыть");
			new id = GetPVarInt(playerid,"select_idphone");
			new string[146];
			format(string, sizeof(string), "%i %s",PI[playerid][pPhoneNumber][id],inputtext);
			callcmd::sms(playerid,string);
			return 1;
		}
		case dBuyCarSalon: {
			if(!response) return true;
			if(TI[playerid][tSelectedBusinessID] < 0) return true;
			TI[playerid][tTPpick] = true;
			SetPlayerPosAC(playerid, 1449.4907,702.5972,1087.9011, GetPVarInt(playerid,"sellcarClass"), 82);
			SetPlayerFacingAngle(playerid,88.9930);
			SetCameraBehindPlayer(playerid);
			OnPlayerUpdateLoadingMode(playerid);
		}
		case D_ARENDA: {
		    if(!response) return RemovePlayerFromVehicleAC(playerid),DeletePVar(playerid,"SelectPlane");
			if(lic[playerid][1] < 1) return ErrorMessage(playerid,"У Вас нет лицензии на воздушный транспорт"),RemovePlayerFromVehicleAC(playerid),DeletePVar(playerid,"SelectPlane");
			new ID = GetPVarInt(playerid,"SelectPlane");
			DeletePVar(playerid,"SelectPlane");
			new price = gAirs[gAirplanes[ID][aAirport]-1][airCoast] * gAirplanes[ID][aPrice];
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"Недостаточно средств для аренды"),RemovePlayerFromVehicleAC(playerid),DeletePVar(playerid,"SelectPlane");
			new plane = -1;
			for(new i=1;i<=gPlaneCount;i++) {
				if(GetString(player_name[playerid],gAirplanes[i][aOwner])) {plane = i; break;}
			}
			if(plane != -1) return ErrorMessage(playerid,"Вы уже арендуете воздушный транспорт"), RemovePlayerFromVehicleAC(playerid);
			strmid(gAirplanes[ID][aOwner],player_name[playerid], 0, strlen(player_name[playerid]), 24);
			gAirplanes[ID][aTime] = unix + 86400 * 10;
			SavePlane(ID);
			gAirs[gAirplanes[ID][aAirport]-1][airBank] += price;
			GiveMoney(playerid,-price,"оплата аренды самолета");
			UpdateAirportData(gAirplanes[ID][aAirport],"bank",gAirs[gAirplanes[ID][aAirport]-1][airBank]);
			new str[64];
			format(str, sizeof(str),"Арендатор - "O"%s", gAirplanes[ID][aOwner]);
			UpdateDynamic3DTextLabelText(gAirplanes[ID][aText],-1,str);
			D(playerid,DIALOG_NONE,DSM, ""P"Аренда",""GREEN"Поздравляем с арендой воздушного транспорта!\n\n"W"Срок аренды: "P"10 дней\n"W"Открыть/закрыть воздушный транспорт: "P"/rlock(/rlk)\n\
												"W"Отказаться от аренды воздушного транспорта: "P"/norent","Хорошо","");
		}
		case D_HOUSE: {
			if(!response) return true;
			new houseid = TI[playerid][tSelectHouse];
			if(!gHouses[houseid][houseOwner]) {
				if(PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас уже есть дом");
				if(PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас уже есть номер в отеле");
				new string[128];
				format(string,sizeof(string),""W"Вы действительно хотите купить этот дом за "GREEN"$%d?",gHouses[houseid][housePrice]);
				D(playerid, D_HOUSE_BUY, DSM, ""P"Покупка дома",string,"Да","Нет");
			}
			else {
				if(PI[playerid][pHouse] != houseid+1 && gHouses[houseid][houseClose]) return GameTextForPlayer(playerid,"~r~closed",2000,1);
				SetPlayerPosAC(playerid, hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][0],hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][1],hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][2], houseid+1, hinterior_info[gHouses[houseid][houseHint]][h_interior]);
				SetPlayerFacingAngle(playerid,hinterior_info[gHouses[houseid][houseHint]][h_pos_exit][3]);
				TI[playerid][tInHouse] = true;
				FreezePlayerForTime(playerid, 3);
			}
		}
		case D_HOUSE_BUY: {
			if(!response) return true;
			new houseid = TI[playerid][tSelectHouse];
			if(!gHouses[houseid][houseOwner]) {
				new price = gHouses[houseid][housePrice];
				if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег на руках");
				new query[80 + MAX_PLAYER_NAME];
				format(query,sizeof(query),"UPDATE `houses` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],gHouses[houseid][houseID]);
				mysql_tquery(connects, query,"","");
				UpdatePlayerData(playerid,"house",gHouses[houseid][houseID]);
				gHouses[houseid][houseOwnerID] = PI[playerid][pID];
				format(gHouses[houseid][houseOwner],MAX_PLAYER_NAME,"%s",player_name[playerid]);
				PI[playerid][pHouse] = gHouses[houseid][houseID];

				gHouses[houseid][houseDay] = unix + 60*60*24;

				format(query,sizeof(query),"UPDATE `houses` SET `day` = '%d' WHERE id = '%d'",gHouses[houseid][houseDay],gHouses[houseid][houseID]);
				mysql_tquery(connects, query,"","");

				SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили дом. Не забывайте оплачивать его, иначе его продадут государству!");
				SendClientMessage(playerid,CGOLD,"Панель управления домом: "W"/house");
				PlayerPlaySound(playerid,1185,0.0,0.0,0.0);
				SetTimerEx("PlayerPlaySoundDelay",6900,false,"ii",playerid,1186);
				GiveMoney(playerid,-price,"покупка дома");
				DestroyDynamicPickup(gHousePickup[houseid]);
				gHousePickup[houseid] = CreateDynamicPickup(1272,1,gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ],0,0);
				DestroyDynamicMapIcon(gHouseIcon[houseid]);
				gHouseIcon[houseid] = CreateDynamicMapIcon(gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ],32,CWHITE);
				PI[playerid][pSpawn] = HOME_SPAWN;
				loading_cars(playerid,0);
			}
		}
		case D_HOUSE_BUY_2: {
			if(!response) {
				if(GetPVarInt(playerid,"houseSeller")) {
					new id_prodaet = GetPVarInt(playerid,"houseSeller")-1;
					SendOk(playerid,"Вы отказались от покупки дома");
					SendOk(id_prodaet,"Игрок отказался от покупки Вашего дома");
					DeletePVar(playerid,"houseSeller");
					DeletePVar(playerid,"housePrices");
					DeletePVar(id_prodaet,"houseBuyer");
				}
			}
			else {
				if(GetPVarInt(playerid,"houseSeller")) {
					new id_prodaet = GetPVarInt(playerid,"houseSeller")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"houseBuyer")-1;
					new house_price = GetPVarInt(playerid,"housePrices");
					if(id_pokupaet == playerid) {
						if(PI[playerid][pCash] < house_price) {
							ErrorMessage(playerid,"У Вас недостаточно денег на руках");
							ErrorMessage(id_prodaet,"У покупателя недостаточно денег на руках");
							DeletePVar(playerid,"houseSeller");
							DeletePVar(playerid,"housePrices");
							DeletePVar(id_prodaet,"houseBuyer");
						}
						else {
							new houseid = GetPVarInt(playerid,"houseIDs");
							UpdatePlayerData(id_prodaet,"house",0);
							UpdatePlayerData(playerid,"house",houseid+1);

							new query[256];
							format(query,sizeof(query),"UPDATE `houses` SET `ownerid` = '%d', owner = '%s',peopleid1 = '0',peopleid2 = '0',peopleid3 = '0',people1='',people2='',people3='',family = '0' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],houseid+1);
							mysql_tquery(connects, query,"","");
							if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #14");

							PI[playerid][pHouse] = houseid+1;
							PI[id_prodaet][pHouse] = 0;

							new string[156];
							format(string,64,"покупка дома у %s",player_name[id_prodaet]);
							GiveMoney(playerid,-house_price,string);
							string[0] = EOS;
							format(string,64,"продажа дома %s",player_name[playerid]);
							GiveMoney(id_prodaet,house_price,string);

							gHouses[houseid][houseOwnerID] = PI[playerid][pID];
							format(gHouses[houseid][houseOwner],MAX_PLAYER_NAME,"%s",player_name[playerid]);
							strmid(gHouseArendator[houseid][0],"None",0,strlen("None"),MAX_PLAYER_NAME);
							strmid(gHouseArendator[houseid][1],"None",0,strlen("None"),MAX_PLAYER_NAME);
							strmid(gHouseArendator[houseid][2],"None",0,strlen("None"),MAX_PLAYER_NAME);
							gHouses[houseid][houseHabitID][0] = 0;
							gHouses[houseid][houseHabitID][1] = 0;
							gHouses[houseid][houseHabitID][2] = 0;
							gHouses[houseid][houseFamily] = 0;
							gHouses[houseid][houseSkin][0] = PI[playerid][pSkin];
							SendOk(playerid,"Ваш скин помещен в шкаф купленного вами дома");
							UpdateHouseDress(houseid);
							if(PI[id_prodaet][pMember] && !start_work[id_prodaet]) {
								A_SetPlayerSkin(id_prodaet,PI[id_prodaet][pFracSkin]);
								SendOk(id_prodaet,"Рабочий день начат");
								TI[playerid][tMasked] = 0;
								SetPlayerColor(id_prodaet,gFractionSpawn[PI[id_prodaet][pMember]][fracColor]);
								start_work[id_prodaet] = 1;
								PI[id_prodaet][pJob] = 0;
							}
							if(gHouses[houseid][houseImprove][2] == 1) {
								loading_cars(playerid,0);
								loading_cars(playerid,1);
							}
							else loading_cars(playerid,0);
							if(house_car[id_prodaet][0] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[id_prodaet][0]),house_car[id_prodaet][0] = INVALID_VEHICLE_ID;
							if(house_car[id_prodaet][1] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[id_prodaet][1]),house_car[id_prodaet][1] = INVALID_VEHICLE_ID;
							gHouses[houseid][houseSkin][0] = 0;
							gHouses[houseid][houseSkin][1] = 0;
							gHouses[houseid][houseSkin][2] = 0;

							format(string,sizeof(string),"Вы приобрели дом у "P"%s"G" за "ORANGE"$%i",player_name[id_prodaet],house_price);
							SendUse(playerid,string);
							SendOk(playerid,"Панель управления домом - "ORANGE"/house");
							format(string,sizeof(string),"Вы продали дом "P"%s"G" за "ORANGE"$%i",player_name[playerid],house_price);
							SendUse(id_prodaet,string);
							DeletePVar(playerid,"houseSeller");
							DeletePVar(playerid,"housePrices");
							DeletePVar(id_prodaet,"houseBuyer");
						}
					}
					else {
						ErrorMessage(playerid,"Игрок оффлайн");
						DeletePVar(playerid,"houseSeller");
						DeletePVar(playerid,"housePrices");
					}
				}
			}
		}
		case D_HOUSE_SELL: {
			if(!response) return true;
			if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома");
			new houseid = PI[playerid][pHouse]-1;
			UpdatePlayerData(playerid,"house",0);
			if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #1");
			new query[294]; 
			format(query,sizeof(query),"UPDATE `houses` SET `ownerid` = '0', `owner` = '', improve = '0|0|0|0|0|0', gun = '0|0|0|0|0|0|0|0|0', skin = '0|0|0|0',safecode='0', safemoney='0', drugs='0', medkit='0', products='0',peopleid1 = '0',peopleid2 = '0',peopleid3 = '0',people1='',people2='',people3='',family = '0' WHERE `id` = '%d'",houseid+1);
			mysql_tquery(connects, query);
			if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #2");
			PI[playerid][pHouse] = 0;
			gHouses[houseid][houseOwnerID] = 0;
			strdel(gHouses[houseid][houseOwner],0,24);

			arendaor_closed(houseid);

			strmid(gHouseArendator[houseid][0],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(gHouseArendator[houseid][1],"None",0,strlen("None"),MAX_PLAYER_NAME);
			strmid(gHouseArendator[houseid][2],"None",0,strlen("None"),MAX_PLAYER_NAME);
			gHouses[houseid][houseHabitID][0] = 0;
			gHouses[houseid][houseHabitID][1] = 0;
			gHouses[houseid][houseHabitID][2] = 0;
			for(new i;i<9;i++) {
				if(PI[playerid][pMember] && !start_work[playerid]) {
					A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
					SendOk(playerid,"Рабочий день начат");
					TI[playerid][tMasked] = 0;
					SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
					start_work[playerid] = 1;
					PI[playerid][pJob] = 0;
				}
				if(i < 3) gHouses[houseid][houseImprove][i] = 0,gHouses[houseid][houseSkin][i] = 0;
				gHouses[houseid][houseGun][i] = 0;
				SaveHouseGun(houseid);
			}
			gHouses[houseid][houseSafeCode] = 0;
			gHouses[houseid][houseSafeMoney] = 0;
			gHouses[houseid][houseDrugs] = 0;
			gHouses[houseid][houseHealth] = 0;
			gHouses[houseid][houseProducts] = 0;
			gHouses[houseid][houseFamily] = 0;
			GiveMoney(playerid,floatround(gHouses[houseid][housePrice]/100*80),"продажа дома");

			FI[fWHITEHOUSE][fBank] += floatround(gHouses[houseid][housePrice]/100*20);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			DestroyDynamicPickup(gHousePickup[houseid]);
			gHousePickup[houseid] = CreateDynamicPickup(1273,1,gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ],0,0);
			DestroyDynamicMapIcon(gHouseIcon[houseid]);
			gHouseIcon[houseid] = CreateDynamicMapIcon(gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ],31,CWHITE);
			SendOk(playerid,"Дом успешно продан государству!");
			if(house_car[playerid][0] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[playerid][0]),house_car[playerid][0] = INVALID_VEHICLE_ID;
			if(house_car[playerid][1] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[playerid][1]),house_car[playerid][1] = INVALID_VEHICLE_ID;
		}
		case D_HOUSE_MENU: {
			if(!response) return true;
			new houseid = PI[playerid][pHouse] - 1;
			switch(listitem) {
				case 0:{
					if(!gHouses[houseid][houseClose]) {
						gHouses[houseid][houseClose] = 1;
						GameTextForPlayer(playerid,"~r~closed",2000,3);
					}
					else {
						gHouses[houseid][houseClose] = 0;
						GameTextForPlayer(playerid,"~g~opened",2000,3);
					}
					new query[54];
					format(query,sizeof(query),"UPDATE `houses` SET `close` = '%d' WHERE `id` = '%d'",gHouses[houseid][houseClose],houseid+1);
					mysql_tquery(connects, query);
					return callcmd::house(playerid);
				}
				case 1: {
					new classname[20],status[12];
					switch(gHouses[houseid][houseClass]) {
						case 0:classname = "Эконом";
						case 1:classname = "Cредний";
						case 2:classname = "Элитный";
						case 3:classname = "Особняк";
						default: classname = "Неизвестно";
					}
					new cnt;
					for(new i;i<3;i++) {
						if(gHouses[houseid][houseHabitID][i]) cnt++;
					}
					strcat(status, (!gHouses[houseid][houseClose] ? "Открыт" : "Закрыт"));
					new improve[128];
					if(gHouses[houseid][houseImprove][0]) strcat(improve,"1. Автоматические двери\n");
					if(gHouses[houseid][houseImprove][1]) strcat(improve,"2. Снижение субсидий\n");
					if(gHouses[houseid][houseImprove][2]) strcat(improve,"3. Гараж\n");
					if(gHouses[houseid][houseImprove][0] == 0 && gHouses[houseid][houseImprove][1] == 0 && gHouses[houseid][houseImprove][2] == 0) strcat(improve,"Отсутствуют");

					new day;
					day = (gHouses[houseid][houseDay]-gettime())/86400;
					static const f_str[] = ""W"Номер дома: \t\t"ORANGE"%d\n\
											"W"Класс: \t\t\t"ORANGE"%s\n\
											"W"КОЛ-во жильцов: \t"ORANGE"%d/%d\n\
											"W"Аренда дома: \t\t"ORANGE"%iд\n\
											"W"Статус: \t\t"ORANGE"%s\n\
											"W"Гос. цена: \t\t"ORANGE"%d\n\n\
											"W"Улучшения:\n\
											"ORANGE"%s";
					new string[sizeof(f_str) + (-2 * 8 + 4 + 20 + 3 * 2 + 11 + 7 + 11 + 58)];
					format(string,sizeof(string),f_str,houseid+1,classname,cnt,gHouses[houseid][houseClass],day,status,gHouses[houseid][housePrice],improve);
					return D(playerid,D_HOUSE_STATS,DSM, ""P"Управление домом",string,"Назад","");
				}
				case 2: {
					new mes[210];
					for(new i;i<3;i++) {
						new c[12];
						if(gHouses[houseid][houseImprove][i]) c = ""GREEN"";
						else if(!i || gHouses[houseid][houseImprove][i-1]) c = ""W"";
						else c = ""G"";
						if(!i) format(mes,sizeof(mes),"%s%d. %s",c,i+1,gHouseImproveName[i]);
						else format(mes,sizeof(mes),"%s\n%s%d. %s",mes,c,i+1,gHouseImproveName[i]);
					}
					return D(playerid,D_HOUSE_IMPROVE,DSL,""P"Управление домом",mes,"Купить","Отмена");
				}
				case 3: {
					if(gHouses[houseid][houseClass] == 0) return ErrorMessage(playerid,"Недоступно для класса Вашего дома");
					new string[15 + MAX_PLAYER_NAME * 3];
					string = "№\tАрендатор\tСтатус\n";
					for(new i = 0; i < 3; i++) {
						switch(gHouses[houseid][houseClass]) {
							case 1: if(i > 0) break;
							case 2: if(i > 1) break;
						}
						if(!strcmp(gHouseArendator[houseid][i],"None")) {
							format(string,sizeof(string),"%s%i\tОтсутствует\tСвободно\n", string,i+1);
						}
						else format(string,sizeof(string),"%s%i\t%s\tЗанято\n",string,i+1,gHouseArendator[houseid][i]);
					}
					D(playerid,dArendator,DSTH,"Управление жителями",string,"Выбрать","Закрыть");
				}
				case 4: {
					new hint = gHouses[houseid][houseHint];
					new Float:x, Float:y, Float:z;
					x = hinterior_info[hint][h_pos_exit][0];
					y = hinterior_info[hint][h_pos_exit][1];
					z = hinterior_info[hint][h_pos_exit][2];
					if(!IsPlayerInRangeOfPoint(playerid,100.0,x,y,z) && GetPlayerVirtualWorld(playerid) != PI[playerid][pHouse]) return ErrorMessage(playerid,"Необходимо находиться в своём доме");

					static const fmt_str[] = ""P"1."W" Наркотики "P"[%d г.]\n"P"2."W" Аптечки "P"[%d шт.]\n"P"3."W" Деньги "P"[$%d]\n"P"4."W" Sniper Rifle "P"[%d пт.]\n"P"5."W" Country Rifle "P"[%d пт.]\n"P"6."W" M4 "P"[%d пт.]\n"P"7."W" AK-47 "P"[%d пт.]\n"P"8."W" MP5 "P"[%d пт.]\n"P"9."W" Shotgun "P"[%d пт.]\n"P"10."W" Desert Eagle "P"[%d пт.]\n"P"11."W" SD Pistol "P"[%d пт.]\n"P"12."W" Baseball Bat "P"[%d шт.]";
					new string[sizeof(fmt_str) + (-12 * 2 + 12 * 11 + 5 * 12)];

					format(string,sizeof(string),fmt_str,gHouses[houseid][houseDrugs],gHouses[houseid][houseHealth],gHouses[houseid][houseSafeMoney],gHouses[houseid][houseGun][0],gHouses[houseid][houseGun][1],gHouses[houseid][houseGun][2],gHouses[houseid][houseGun][3],gHouses[houseid][houseGun][4],gHouses[houseid][houseGun][5],gHouses[houseid][houseGun][6],gHouses[houseid][houseGun][7],gHouses[houseid][houseGun][8]);
					D(playerid,dSafeAction,DSL,"Сейф",string,"Далее","Отмена");
				}
				case 5: {
					new hint = gHouses[houseid][houseHint];
					new Float:x, Float:y, Float:z;
					x = hinterior_info[hint][h_pos_exit][0];
					y = hinterior_info[hint][h_pos_exit][1];
					z = hinterior_info[hint][h_pos_exit][2];
					if(!IsPlayerInRangeOfPoint(playerid,100.0,x,y,z) && GetPlayerVirtualWorld(playerid) != PI[playerid][pHouse]) return ErrorMessage(playerid,"Необходимо находиться в своём доме");
					if(start_work[playerid]) return ErrorMessage(playerid,"Для начала нужно закончить рабочий день");
					new cnt;
					new mes2[128];
					for(new i;i<3;i++) {
						if(gHouses[houseid][houseSkin][i]) format(mes2,sizeof(mes2),"%sОдежда %d\n",mes2,i+1);
						else continue;
						cnt++;
					}
					if(!cnt) return ErrorMessage(playerid,"Нет одежды в шкафу");
					D(playerid,dStoreSkin,DSL,"Шкаф",mes2,"Одеть","Отмена");
				}
				case 6: {
					new string[144];
					if(PI[playerid][pVips] != VIP_GOLD || PI[playerid][pVips] != VIP_PLATINA || PI[playerid][pVips] != VIP_ECSCLUSIVE) {
						format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
						D(playerid,D_FIXCAR,DSL,""P"Доставить транспорт",string,"Выбрать","Закрыть");
					}
					else {
						format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]"W" - "ORANGE"$500\n"W"2. Автомобиль №2 "P"[%s]"W" - "ORANGE"$500",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
						D(playerid,D_FIXCAR,DSL,""P"Доставить транспорт",string,"Выбрать","Закрыть");
					}
				}
				case 7: callcmd::sellcar(playerid);
				case 8: {
					new hint = gHouses[houseid][houseHint];
					new Float:x, Float:y, Float:z;
					x = hinterior_info[hint][h_pos_exit][0];
					y = hinterior_info[hint][h_pos_exit][1];
					z = hinterior_info[hint][h_pos_exit][2];
					if(!IsPlayerInRangeOfPoint(playerid,100.0,x,y,z) && GetPlayerVirtualWorld(playerid) != PI[playerid][pHouse]) return ErrorMessage(playerid,"Необходимо находиться в своём доме");
					new string[2000],str[128],id = 1;
					string = ""P"№. Название\n";
					for(new i; i < 42; i++) {
						if(hinterior_info[i][h_type] != gHouses[houseid][houseClass]) continue;
						format:str( ""P"%d."W" %s\n", id,hinterior_info[i][h_int_name]);
						strcat(string, str);
						id++;
					}
					D(playerid, D_HOUSE_BUYINT, DIALOG_STYLE_TABLIST_HEADERS, ""P"Покупка интерьера", string, "Осмотреть", "Назад");
				}
				case 9: {
					EnableGPSForPlayer(playerid,gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ]);
					SCM(playerid, COLOR_YELLOW, "Местоположение Вашего дома отмечено у вас на GPS");
				}
				case 10: callcmd::sellhouse(playerid,"");
			}
		}
		case D_HOUSE_BUYINT: {
			if(!response) return 1;
			new houseid = PI[playerid][pHouse] - 1;
			for(new i; i < 42; i++) {
				if(hinterior_info[i][h_type] != gHouses[houseid][houseClass]) continue;
				if(hinterior_info[i][h_id] == listitem) {
					SetPlayerPosAC(playerid, hinterior_info[i][h_pos_exit][0],hinterior_info[i][h_pos_exit][1],hinterior_info[i][h_pos_exit][2], houseid+1, hinterior_info[i][h_interior]);
					SetPlayerFacingAngle(playerid,hinterior_info[i][h_pos_exit][3]);
					SetCameraBehindPlayer(playerid);
					SendOk(playerid,"Для покупки данного интерьера, введите: "P"/buyint"G" и нажмите на пункт 'Купить'");
					SendOk(playerid,"Для отмены покупки данного интерьера, введите: "P"/buyint"G" и нажмите на пункт 'Отмена'");
					SetPVarInt(playerid,"buy_interior",listitem+1);
					break;
				}
			}
		}
		case D_HOUSE_BUYINT_2: {
			if(!response) {
				new house = PI[playerid][pHouse] - 1;
				new i = gHouses[house][houseHint];
				SetPlayerPosAC(playerid, hinterior_info[i][h_pos_exit][0],hinterior_info[i][h_pos_exit][1],hinterior_info[i][h_pos_exit][2], house+1, hinterior_info[i][h_interior]);
				SetPlayerFacingAngle(playerid,hinterior_info[i][h_pos_exit][3]);
				SetCameraBehindPlayer(playerid);
				DeletePVar(playerid, "buy_interior");
				return 1;
			}
			new house = PI[playerid][pHouse] - 1;
			for(new x; x < 42; x++) {
				if(hinterior_info[x][h_type] != gHouses[house][houseClass]) continue;
				if(hinterior_info[x][h_id] == GetPVarInt(playerid,"buy_interior")-1) {
					if(PI[playerid][pCash] < 150000) return ErrorMessage(playerid,"У Вас недостаточно средств");
					GiveMoney(playerid,-150000,"покупка интерьера");
					gHouses[house][houseHint] = x;
					new query[156];
					format(query,sizeof(query),"UPDATE `houses` SET `hint` = '%d' WHERE id = '%d'",gHouses[house][houseHint],house+1);
					mysql_tquery(connects, query);

					new i = gHouses[house][houseHint];
					SetPlayerPosAC(playerid, hinterior_info[i][h_pos_exit][0],hinterior_info[i][h_pos_exit][1],hinterior_info[i][h_pos_exit][2], house+1, hinterior_info[i][h_interior]);
					SetPlayerFacingAngle(playerid,hinterior_info[i][h_pos_exit][3]);
					SetCameraBehindPlayer(playerid);
					SendOk(playerid,"Поздравляем с покупкой нового интерьера!");
					DeletePVar(playerid,"buy_interior");
					break;
				}
			}
			Streamer_Update(playerid);
		}
		case D_HOUSE_EXIT: {
			if(!response) return 1;
			new houseid = TI[playerid][tSelectHouse];
			switch(listitem) {
				case 0: {
					TI[playerid][tTPpick] = true;
					SetPlayerPosAC(playerid, gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ], 0, 0);
					SetPlayerFacingAngle(playerid,gHouses[houseid][houseR]);
					TI[playerid][tInHouse] = false;
					SetCameraBehindPlayer(playerid);
				}
				case 1: {
					SetPlayerPosAC(playerid, exitgarage[gHouses[houseid][houseClass]][0],exitgarage[gHouses[houseid][houseClass]][1],exitgarage[gHouses[houseid][houseClass]][2], TI[playerid][tVirtualWorld], TI[playerid][tInterior]);
					SetPlayerFacingAngle(playerid,exitgarage[gHouses[houseid][houseClass]][3]);
					SetCameraBehindPlayer(playerid);
				}
			}
		}
		case D_HOUSE_CARSELL: {
			if(!response) return 1;
			if(GetPVarInt(playerid,"carPokupaet")) return ErrorMessage(playerid,"У Вас активный обмен Т/С с игроком");
			new modelid = gPlayerCars[playerid][carModel][listitem] - 400;
			new Float:factor;
			factor = 0.8;
			new price = floatround(gTransport[modelid][trPrice]*factor);
			SetPVarInt(playerid,"car_sell",listitem);
			new string[144];
			format(string,sizeof(string),""W"Вы собираетесь продать свой автомобиль "P"%s "W"за "GREEN"$%i\n\n"NO"Продать автомобиль?",gTransport[gPlayerCars[playerid][carModel][listitem]-400][trName],price);
			return D(playerid,D_HOUSE_CARSELL_2,DSM, ""P"Продажа автомобиля",string, "Да", "Нет");
		}
		case D_HOUSE_CARSELL_2: {
			if(!response) return callcmd::house(playerid);
			sell_cars(playerid,GetPVarInt(playerid,"car_sell"));
		}
		case D_FIXCAR:{
			if(!response) return 1;
			if(theftplayer[playerid][0] != 1010) { //угон
				if(theftIDveh[theftplayer[playerid][0]][2] == listitem) return ErrorMessage(playerid, "Ваша машина в угоне");
			}
			if(PI[playerid][pVips] == VIP_NONE || PI[playerid][pVips] == VIP_SILVER || PI[playerid][pVips] == VIP_SILVER || PI[playerid][pVips] == VIP_SILVER) {
				if(GetPlayerMoneyEx(playerid) < 500) return ErrorMessage(playerid,"У Вас недостаточно средств");
				GiveMoney(playerid,-500,"Доставка ТС к дому");
			}
			loading_cars(playerid, listitem);
			SendOk(playerid,"Автомобиль успешно доставлен");
		}
		case D_HOUSE_STATS: callcmd::house(playerid);
		case D_HOUSE_IMPROVE: {
			if(!response) return callcmd::house(playerid);
			new houseid = PI[playerid][pHouse] - 1;
			if(gHouses[houseid][houseImprove][listitem]) {
				ErrorMessage(playerid,"У Вас уже установлено данное улучшение");
				callcmd::house(playerid);
			}
			else if((!listitem && !gHouses[houseid][houseImprove][listitem]) || (gHouses[houseid][houseImprove][listitem-1] && !gHouses[houseid][houseImprove][listitem])) {
				new mes[160];
				new price;
				switch(gHouses[PI[playerid][pHouse]-1][houseClass]) {
					case 0: {
						if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
							new seller = floatround(gHouseImprovePriceN[listitem]/100*vip_status[PI[playerid][pVips]][vip_houseupdate]);
							price = (gHouseImprovePriceN[listitem]-seller);
						}
						else {
							if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
								new seller = floatround(gHouseImprovePriceN[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceN[listitem]-seller);
							}
							else if(BonusInfo[act_select] == 2) {
								new seller = floatround(gHouseImprovePriceN[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceN[listitem]-seller);
							}
						    else price = gHouseImprovePriceN[listitem];
						}
						format(mes, sizeof(mes),""W"Улучшение: "O"%s\n"W"Стоимость "GREEN"$%d",gHouseImproveName[listitem],price);
					}
					case 1: {
						if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
							new seller = floatround(gHouseImprovePriceD[listitem]/100*vip_status[PI[playerid][pVips]][vip_houseupdate]);
							price = (gHouseImprovePriceD[listitem]-seller);
						}
						else {
							if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
								new seller = floatround(gHouseImprovePriceD[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceD[listitem]-seller);
							}
							else if(BonusInfo[act_select] == 2) {
								new seller = floatround(gHouseImprovePriceD[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceD[listitem]-seller);
							}
						    else price = gHouseImprovePriceD[listitem];
						}
						format(mes, sizeof(mes),""W"Улучшение: "O"%s\n"W"Стоимость "GREEN"$%d",gHouseImproveName[listitem],price);
					}
					case 2: {
						if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
							new seller = floatround(gHouseImprovePriceB[listitem]/100*vip_status[PI[playerid][pVips]][vip_houseupdate]);
							price = (gHouseImprovePriceD[listitem]-seller);
						}
						else {
							if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
								new seller = floatround(gHouseImprovePriceB[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceB[listitem]-seller);
							}
							else if(BonusInfo[act_select] == 2) {
								new seller = floatround(gHouseImprovePriceB[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceB[listitem]-seller);
							}
						    else price = gHouseImprovePriceB[listitem];
						}
						format(mes, sizeof(mes),""W"Улучшение: "O"%s\n"W"Стоимость "GREEN"$%d",gHouseImproveName[listitem],price);
					}
					case 3: {
						if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
							new seller = floatround(gHouseImprovePriceA[listitem]/100*vip_status[PI[playerid][pVips]][vip_houseupdate]);
							price = (gHouseImprovePriceD[listitem]-seller);
						}
						else {
							if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
								new seller = floatround(gHouseImprovePriceA[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceA[listitem]-seller);
							}
							else if(BonusInfo[act_select] == 2) {
								new seller = floatround(gHouseImprovePriceA[listitem]/100*BonusInfo[act_buyimprove]);
								price = (gHouseImprovePriceA[listitem]-seller);
							}
						    else price = gHouseImprovePriceA[listitem];
						}
						format(mes, sizeof(mes),""W"Улучшение: "O"%s\n"W"Стоимость "GREEN"$%d",gHouseImproveName[listitem],price);
					}
				}
				SetPVarInt(playerid,"improveid_price",price);
				D(playerid,D_HOUSE_IMPROVE_2,DSM, ""P"Покупка улучшений",mes,"Купить","Отмена");
				SetPVarInt(playerid,"improveid",listitem);
			}
			else {
				ErrorMessage(playerid,"Это улучшение Вам недоступно. Откройте улучшения выше");
				callcmd::house(playerid);
			}
		}
		case D_HOUSE_IMPROVE_2: {
			new improveid = GetPVarInt(playerid,"improveid");
			DeletePVar(playerid,"improveid");
			if(!response) return callcmd::house(playerid);
			new price = GetPVarInt(playerid,"improveid_price");
			DeletePVar(playerid,"improveid_price");
			if(GetPlayerMoneyEx(playerid) < price) {
				callcmd::house(playerid);
				return ErrorMessage(playerid,"У Вас недостаточно денег");
			}
			new houseid = PI[playerid][pHouse] - 1;
			gHouses[houseid][houseImprove][improveid] = 1;
			if(improveid == 2) loading_cars(playerid,1);
			new data[32],query[128];
			for(new i;i<3;i++) {
				if(!i) format(data,sizeof(data),"%d",gHouses[houseid][houseImprove][i]);
				else format(data,sizeof(data),"%s|%d",data,gHouses[houseid][houseImprove][i]);
			}
			mysql_format(connects,query,sizeof(query),"UPDATE `houses` SET `improve` = '%e' WHERE id = '%d'",data,houseid+1);
			mysql_tquery(connects, query);
			if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #4");
			GiveMoney(playerid, -price,"покупка улучшения в дом");
			SendOk(playerid,"Поздравляем с приобретением улучшения в дом");
			callcmd::house(playerid);
		}
		case dStoreSkin: {
			if(!response) return 1;
			new skin,id;
			new mes2[128];
			new houseid = PI[playerid][pHouse] - 1;
			sscanf(inputtext,"{s[100]}i",id);
			skin = gHouses[houseid][houseSkin][id-1];
			PI[playerid][pSkin] = skin;
			UpdatePlayerData(playerid, "Skin", skin);
			A_SetPlayerSkin(playerid,skin);
			new cnt;
			for(new i;i<3;i++) {
				if(gHouses[houseid][houseSkin][i]) format(mes2,sizeof(mes2),"%sОдежда %d\n",mes2,i+1);
				else continue;
				cnt ++;
			}
			if(!cnt) {
				ErrorMessage(playerid,"Нет одежды в шкафу");
				return D(playerid,dStore,2,"Шкаф","Выбрать одежду","Далее","Отмена");
			}
			D(playerid,dStoreSkin,2,"Шкаф",mes2,"Одеть","Отмена");
		}
		case dSafe: {
			if(!response) return true;
			D(playerid,dSafePutMoney,DSI,""P"Сейф","\n\n"W"Введите количество:\n\n","Ввод","Отмена");
			SetPVarInt(playerid,"safe_idx",listitem+1);
		}
		case dSafeAction: {
			if(!response) return 1;
			SetPVarInt(playerid,"safe_select",listitem+1);
			D(playerid,dSafe,DSL,""P"Сейф",""P"1."W" Взять\n"P"2."W" Положить","Далее","Отмена");
		}
		case dSafePutMoney: {
			if(!response) return 1;
			if(!strlen(inputtext) || strval(inputtext) < 1) return D(playerid,dSafePutMoney,DSI,""P"Сейф","\n\n"W"Введите количество:\n\n","Ввод","Отмена");
			new i = GetPVarInt(playerid,"safe_select")-1;
			new houseid = PI[playerid][pHouse] - 1;
			new money = strval(inputtext);
			if(GetPVarInt(playerid,"safe_idx") == 1) {
				switch(i) {
					case 0: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 наркотиков\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseDrugs] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно наркотиков в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						if(PI[playerid][pDrugs] + money > vip_status[PI[playerid][pVips]][vip_drugs]) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите взять из сейфа:\n\n"NO"*"G" В карман поместится слишком много наркотиков\n\n","Взять","Отмена");
							return 1;
						}
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `drugs` = '%d' WHERE id = '%d'",gHouses[houseid][houseDrugs]-money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return ErrorMessage(playerid,"Ошибка MySQL при сохранении наркотиков в сейфе");
						gHouses[houseid][houseDrugs] -= money;
						PI[playerid][pDrugs] += money;
						MeAction(playerid,"взял(а) наркотики из сейфа");
					}
					case 1: {
						if(money < 1 || money > 20) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во аптечек, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 20 аптечек\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseHealth] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во аптечек, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно аптечек в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						if(PI[playerid][pMedKit] + money > vip_status[PI[playerid][pVips]][vip_heal]) {
							new string[160];
							format(string,sizeof(string),"\n\n"W"Укажите кол-во аптечек, которое Вы хотите взять из сейфа:\n\n"NO"*"G" В карман поместится не больше %d аптечек\n\n",vip_status[PI[playerid][pVips]][vip_heal]);
							D(playerid,dSafePutMoney,DSI, ""P"Сейф",string,"Взять","Отмена");
							return 1;
						}
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `medkit` = '%d' WHERE id = '%d'",gHouses[houseid][houseHealth]-money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return ErrorMessage(playerid,"Ошибка MySQL при сохранении аптечек в сейфе");
						gHouses[houseid][houseHealth] -= money;
						PI[playerid][pMedKit] += money;
						UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
						MeAction(playerid,"взял(а) аптечки из сейфа");
					}
					case 2: {
						if(money < 1 || money > 1000000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите сумму, которую хотите взять из сейфа:\n\n"NO"*"G" Сумма должна быть от $1 до $1.000.000\n\n","Взять","Отмена");
							return 1;
						}
						if(money > gHouses[houseid][houseSafeMoney]) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите сумму, которую хотите взять из сейфа:\n\n"NO"*"G" В сейфе недостаточно средств\n\n","Взять","Отмена");
							return 1;
						}
						//if(gHouses[houseid][houseSafeMoney]+money > 5000000) return ErrorMessage(playerid,"Нельзя хранить более $5.000.000");
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `safemoney` = '%d' WHERE id = '%d'",gHouses[houseid][houseSafeMoney]-money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #6");
						gHouses[houseid][houseSafeMoney] -= money;
						GiveMoney(playerid, money,"взял(а) деньги с сейфа");
						MeAction(playerid,"взял(а) деньги с сейфа");
					}
					case 3: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Sniper Rifle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][0] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Sniper Rifle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон Sniper Rifle в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][0] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 34, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 4: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Country Rifle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][1] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Country Rifle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон Country Rifle в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][1] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 33, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 5: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон M4, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][2] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон M4, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон M4 в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][2] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 31, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 6: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон AK-47, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][3] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон AK-47, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон AK-47 в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][3] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 30, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 7: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон MP5, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][4] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон MP5, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон MP5 в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][4] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 29, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 8: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Shotgun, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][5] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Shotgun, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон Shotgun в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][5] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 25, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 9: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Desert Eagle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][6] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Desert Eagle, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон Desert Eagle в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][6] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 24, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 10: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон SD Pistol, которое Вы хотите взять из сейфа:\n\n"NO"*"G" От 1 до 500 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][7] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон SD Pistol, которое Вы хотите взять из сейфа:\n\n"NO"*"G" Недостаточно патрон SD Pistol в сейфе\n\n","Взять","Отмена");
							return 1;
						}
						gHouses[houseid][houseGun][7] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 23, money);
						MeAction(playerid,"взял(а) патроны из сейфа");
					}
					case 11: {
						if(gHouses[houseid][houseGun][8] < 1) return ErrorMessage(playerid,"Недостаточно Baseball Bat в сейфе");
						gHouses[houseid][houseGun][8] -= money;
						SaveHouseGun(houseid);
						AC_GivePlayerWeapon(playerid, 5, money);
						MeAction(playerid,"взял(а) Baseball Bat из сейфа");
					}
				}
			}
			else if(GetPVarInt(playerid,"safe_idx") == 2) {
				switch(i) {
					case 0: {
						if(money < 1 || money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 500 наркотиков\n\n","Положить","Отмена");
							return 1;
						}
						if(PI[playerid][pDrugs] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно наркотиков\n\n","Положить","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseDrugs]+money > 1000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во наркотиков, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 1000г наркотиков\n\n","Положить","Отмена");
							return 1;
						}
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `drugs` = '%d' WHERE id = '%d'",gHouses[houseid][houseDrugs]+money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return ErrorMessage(playerid,"Ошибка MySQL при сохранении наркотиков в сейфе");
						gHouses[houseid][houseDrugs] += money;
						PI[playerid][pDrugs] -= money;
						MeAction(playerid,"положил(а) наркотики в сейф");
					}
					case 1: {
						if(money < 1 || money > 20) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во аптечек, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 20 аптечек\n\n","Положить","Отмена");
							return 1;
						}
						if(PI[playerid][pMedKit] < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во аптечек, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно аптечек\n\n","Положить","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseHealth]+money > 500) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во аптечек, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 500 аптечек\n\n","Положить","Отмена");
							return 1;
						}
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `medkit` = '%d' WHERE id = '%d'",gHouses[houseid][houseHealth]+money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return ErrorMessage(playerid,"Ошибка MySQL при сохранении аптечек в сейфе");
						gHouses[houseid][houseHealth] += money;
						PI[playerid][pMedKit] -= money;
						UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
						MeAction(playerid,"положил(а) аптечки в сейф");
					}
					case 2: {
						if(money < 1 || money > 1000000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите сумму, которую хотите положить в сейф:\n\n"NO"*"G" Сумма должна быть от $1 до $1.000.000\n\n","Положить","Отмена");
							return 1;
						}
						if(GetPlayerMoneyEx(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите сумму, которую хотите положить в сейф:\n\n"NO"*"G" Недостаточно средств\n\n","Положить","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseSafeMoney]+money > 10000000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите сумму, которую хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более $10.000.000\n\n","Положить","Отмена");
							return 1;
						}
						new query[128];
						format(query,sizeof(query),"UPDATE `houses` SET `safemoney` = '%d' WHERE id = '%d'",gHouses[houseid][houseSafeMoney]+money,houseid+1);
						mysql_tquery(connects, query);
						if(mysql_errno()) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #6");
						gHouses[houseid][houseSafeMoney] += money;
						GiveMoney(playerid, -money,"положил(а) деньги в сейф");
						MeAction(playerid,"положил(а) деньги в сейф");
					}
					case 3: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Sniper Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 34 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Sniper Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][0]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Sniper Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 34, -money);
						gHouses[houseid][houseGun][0] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 4: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Country Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 33 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Country Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][1]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Country Rifle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 33, -money);
						gHouses[houseid][houseGun][1] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 5: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон M4, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 31 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон M4, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][2]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон M4, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 31, -money);
						gHouses[houseid][houseGun][2] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 6: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон AK-47, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 30 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон AK-47, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][3]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон AK-47, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 30, -money);
						gHouses[houseid][houseGun][3] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 7: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон MP5, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 29 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон MP5, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][4]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон MP5, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 29, -money);
						gHouses[houseid][houseGun][4] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 8: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Shotgun, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 25 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Shotgun, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][5]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Shotgun, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 25, -money);
						gHouses[houseid][houseGun][5] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 9: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Desert Eagle, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 24 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Desert Eagle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][6]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон Desert Eagle, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 24, -money);
						gHouses[houseid][houseGun][6] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 10: {
						if(money < 1 || money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон SD Pistol, которое Вы хотите положить в сейф:\n\n"NO"*"G" От 1 до 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(GetPlayerWeapon(playerid) != 23 || GetPlayerAmmo(playerid) < money) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон SD Pistol, которое Вы хотите положить в сейф:\n\n"NO"*"G" Недостаточно патрон\n\n","Взять","Отмена");
							return 1;
						}
						if(gHouses[houseid][houseGun][7]+money > 5000) {
							D(playerid,dSafePutMoney,DSI, ""P"Сейф","\n\n"W"Укажите кол-во патрон SD Pistol, которое Вы хотите положить в сейф:\n\n"NO"*"G" Нельзя хранить в сейфе более 5000 патрон\n\n","Взять","Отмена");
							return 1;
						}
						AC_GivePlayerWeapon(playerid, 23, -money);
						gHouses[houseid][houseGun][7] += money;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) патроны в сейф");
					}
					case 11: {
						if(GetPlayerWeapon(playerid) != 5 || GetPlayerAmmo(playerid) < money) return ErrorMessage(playerid,"Недостаточно Baseball Bat");
						if(gHouses[houseid][houseGun][7]+money > 1) return ErrorMessage(playerid,"Нельзя хранить в сейфе более 1 Baseball Bat");
						AC_GivePlayerWeapon(playerid, 5, -1);
						gHouses[houseid][houseGun][8] += 1;
						SaveHouseGun(houseid);
						MeAction(playerid,"положил(а) Baseball Bat в сейф");
					}
				}
			}
		}
		case dArendator: {
			if(!response) return callcmd::house(playerid);
			new house = PI[playerid][pHouse] -1;
			if(!strcmp(gHouseArendator[house][listitem],"None")) {
				D(playerid,dArendatorAction,DSI, ""P"Жители","\n\n"W"Введите ID игрока, которого хотите подеслить в дом:\n\n","Ввод","Закрыть");
			}
			else D(playerid,dZhitelSettings,DSL,""P"Жители","Выселить жителя","Выбрать","Закрыть");
			SetPVarInt(playerid,"arenda_listitem",listitem+1);
			return 1;
		}
		case dZhitelSettings: {
			if(!response) return 1;
			new house = PI[playerid][pHouse] -1;
			new id_rent = GetPVarInt(playerid,"arenda_listitem")-1;
			new string[128];
			format(string, sizeof(string), "Вы выселили жителя из комнаты "ORANGE"№%i", id_rent+1);
			SendUse(playerid,string);
			new bool:check_online = false;
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(!strcmp(gHouseArendator[house][id_rent],player_name[i])) {
					PI[i][pTempKey] = 0;
					UpdatePlayerData(i,"tempkey",0);
					SendOk(i,"Владелец выселил Вас из дома");
					check_online = true;
					break;
				}
			}
			if(!check_online) {
				new query[128];
				mysql_format(connects,query,sizeof(query),"UPDATE `accounts` SET `tempkey` = '0' WHERE `Name` = '%e' LIMIT 1",gHouseArendator[house][id_rent]);
				mysql_tquery(connects, query, "", "");
			}
			strmid(gHouseArendator[house][id_rent],"None",0,strlen("None"),MAX_PLAYER_NAME);
			SaveHome(house);
			return 1;
		}
		case dArendatorAction: {
			if(!response) return 1;
			new house = PI[playerid][pHouse] -1;
			new id_rent = GetPVarInt(playerid,"arenda_listitem")-1;

			if(!IsNumber(inputtext)) {
				D(playerid,dArendatorAction,DSI, ""P"Жители","\n\n"W"Введите ID игрока, которого хотите подеслить в дом:\n\n"NO"*"G" Произошла ошибка при вводе ID. Попробуйте заного\n\n","Ввод","Закрыть");
				return 1;
			}
			if(!PlayerToPoint(5,playerid,gHouses[house][houseX], gHouses[house][houseY], gHouses[house][houseZ])) return ErrorMessage(playerid, "Необходимо находиться рядом со своим домом");
			if(!IsPlayerConnected(strval(inputtext)) && !TI[strval(inputtext)][tLogin]) {
				D(playerid,dArendatorAction,DSI, ""P"Жители","\n\n"W"Введите ID игрока, которого хотите подеслить в дом:\n\n"NO"*"G" Данный игрок не авторизован на сервере\n\n","Ввод","Закрыть");
				return 1;
			}
			if(!ProxDetectorS(5.0, playerid, strval(inputtext))) {
				D(playerid,dArendatorAction,DSI, ""P"Жители","\n\n"W"Введите ID игрока, которого хотите подеслить в дом:\n\n"NO"*"G" Игрок далеко от Вас\n\n","Ввод","Закрыть");
				return 1;
			}
			if(PI[strval(inputtext)][pTempKey] || PI[strval(inputtext)][pHouse] || PI[strval(inputtext)][pRoom]) {
				D(playerid,dArendatorAction,DSI, ""P"Жители","\n\n"W"Введите ID игрока, которого хотите подеслить в дом:\n\n"NO"*"G" У игрока уже есть дом/номер в отеле/подселен в одном из домов\n\n","Ввод","Закрыть");
				return 1;
			}
			PI[strval(inputtext)][pTempKey] = house+1;
			UpdatePlayerData(strval(inputtext),"tempkey",PI[strval(inputtext)][pTempKey]);
			PI[strval(inputtext)][pSpawn] = HOME_SPAWN;
			UpdatePlayerData(strval(inputtext),"spawn",PI[strval(inputtext)][pSpawn]);
			SendUse(strval(inputtext),"Вас прописали в доме, используйте: "ORANGE"/house");
			SetString(gHouseArendator[house][id_rent],player_name[strval(inputtext)]);
			new string[144];
			format(string,sizeof(string),"Вы добавили нового жителя: "P"%s "G"в комнату "ORANGE"№%i",gHouseArendator[house][id_rent],id_rent+1);
			SendUse(playerid,string);
			SaveHome(house);
			return 1;
		}
		case dRentMenu: {
			if(!response) return 1;
			new tempkey = PI[playerid][pTempKey]-1;
			for(new i; i < 3; i++) {
				if(!strcmp(gHouseArendator[tempkey][i],player_name[playerid])) {
					strmid(gHouseArendator[tempkey][i],"None",0,strlen("None"),MAX_PLAYER_NAME);
					break;
				}
			}
			SendOk(playerid,"Вы выселились из дома");
			PI[playerid][pTempKey] = 0;
			UpdatePlayerData(playerid,"tempkey",0);

			SaveHome(tempkey);
			return 1;
		}
		case D_HOTEL: {
			if(!response) return 1;
			switch(listitem) {
				case 0: ShowHotelRooms(playerid);
				case 1: D(playerid,D_HOTEL_OWNER,DSL,""P"Отель",""P"1."W" Баланс отеля\n"P"2."W" Снять деньги\n"P"3."W" Статистика отеля\n"P"4."W" Установить цену за сутки проживания\n"P"5."NO" Продать отель","Выбрать","Отмена");
			}
		}
		case D_HOTEL_OWNER: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new string[64];
					format(string,sizeof(string),""W"В кассе: "GREEN"$%d",gHotels[PI[playerid][pHotel]-1][hotelBank]);
					D(playerid,DIALOG_NONE,DSM, ""P"Касса",string,"Хорошо","");
				}
				case 1: D(playerid,D_HOTEL_BANK,DSI, ""P"Отель",""W"Введите сумму, которую хотите взять с кассы отеля:","Взять","Отмена");
				case 2: ShowHotelInformation(playerid,PI[playerid][pHotel]-1,DIALOG_NONE);
				case 3: D(playerid,D_HOTEL_PRICE,DSI, ""P"Отель",""W"Введите цену за сутки проживания\nПримечание: от "GREEN"$400"W" до "GREEN"$1000","ОК","Отмена");
				case 4: {
					static const f_str[] = ""W"Вы хотите продать отель государству за "GREEN"$%d?\n\n"G"Для продажи отеля игроку введите: /sellhotel [ID игрока] [Сумма]";
					new string[sizeof(f_str) +1 + (-2 + 8)];
					format(string,sizeof(string),f_str,floatround(gHotels[PI[playerid][pHotel]-1][hotelPrice]/100*80));
					D(playerid,D_HOTEL_SELL,DSM, ""P"Отель",string,"Продать","Отмена");
				}
			}
		}
		case D_HOTEL_BANK: {
			if(!response) return 1;
			if(!PI[playerid][pHotel]) return 1;
			new id = PI[playerid][pHotel]-1;
			new sum = strval(inputtext);
			if(sum < 1 || sum > 500000) return D(playerid,D_HOTEL_BANK,DSI, ""P"Отель",""W"Введите сумму, которую хотите взять с кассы отеля:\n\n"NO"*"G" От $1 до $500000","Взять","Отмена");
			if(gHotels[id][hotelBank] < sum) return D(playerid,D_HOTEL_BANK,DSI, ""P"Отель",""W"Введите сумму, которую хотите взять с кассы отеля:\n\n"NO"*"G" В кассе недостаточно средств","Взять","Отмена");
			if(UpdateHotelData(id,"bank",gHotels[id][hotelBank] - sum)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #30");
			gHotels[id][hotelBank] -= sum;
			UpdateHotelData(id+1,"bank",gHotels[id][hotelBank]);
			GiveMoney(playerid,sum,"прибыль с отеля");

			new string[128];
			format(string,sizeof(string),"Вы взяли с кассы отеля: "ORANGE"$%d",sum);
			SendUse(playerid,string);
		}
		case D_HOTEL_PRICE: {
			if(!response) return 1;
			new id = PI[playerid][pHotel] - 1;
			if(id < 0) return true;
			new price = strval(inputtext);
			if(price < 400 || price > 1000) return D(playerid,D_HOTEL_PRICE,DSI, ""P"Отель",""W"Введите цену за сутки проживания\n\n"NO"*"G" От $400 до $1000","ОК","Отмена");
			gHotels[id][hotelCoast] = price;
			UpdateHotelData(id+1,"coast",price);
			UpdateHotelText(id);
			new string[128];
			format(string,sizeof(string),"Цена за сутки проживания установлена: "ORANGE"$%d",price);
			SendUse(playerid,string);
		}
		case D_HOTEL_SELL: {
			if(!response) return 1;
			if(PI[playerid][pHotel] < 1) return ErrorMessage(playerid,"У Вас нет отеля");
			new id = PI[playerid][pHotel] - 1;
			new sum = floatround(gHotels[id][hotelPrice]/100*80);

			FI[fWHITEHOUSE][fBank] += floatround(gHotels[id][hotelPrice]/100*20);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			if(UpdateHotelData(id+1,"ownerid",0)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #29");
			gHotels[id][hotelOwnerID] = 0;
			SetString(gHotels[id][hotelOwner],"");
			new query[90];
			format(query,sizeof(query),"UPDATE `hotels` SET `ownerid` = '0', `owner` = '' ,`bank` = '0',`bankday` = '0' WHERE `id` = '%d'",id+1);
			mysql_tquery(connects, query,"","");
			UpdateHotelText(id);
			PI[playerid][pHotel] = 0;
			UpdatePlayerData(playerid,"hotelid",0);
			GiveMoney(playerid,sum,"продажа отеля");
			SendOk(playerid,"Отель продан государству");
		}
		case D_HOTEL_BUY: {
			if(PI[playerid][pHotel]) return ErrorMessage(playerid,"У Вас уже есть отель");
			new otelid = GetPVarInt(playerid,"selectedhotel");
			if(response) {
				if(GetPlayerMoneyEx(playerid) < gHotels[otelid][hotelPrice]) return ErrorMessage(playerid,"У Вас недостаточно денег");
				gHotels[otelid][hotelDay] = unix + 60*60*24;
				new query[172];

				format(query,sizeof(query),"UPDATE `hotels` SET `ownerid` = '%d', `owner` = '%s', `day` = '%d' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],gHotels[otelid][hotelDay],otelid+1);
				mysql_tquery(connects, query,"","");
				GiveMoney(playerid,-gHotels[otelid][hotelPrice],"покупка отеля");
				gHotels[otelid][hotelOwnerID] = PI[playerid][pID];
				format(gHotels[otelid][hotelOwner],24,"%s",player_name[playerid]);

				UpdateHotelText(otelid);

				PI[playerid][pHotel] = otelid+1;
				UpdatePlayerData(playerid,"hotelid",PI[playerid][pHotel]);

				SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили отель. Не забывайте оплачивать его, иначе его продадут государству!");
				return 1;
			}
			else {
				TI[playerid][tTPpick] = true;
				SetPlayerPosAC(playerid, 1405.3140,-15.8006,1000.9132, otelid, 79);
				SetPlayerFacingAngle(playerid,90.1475);
				SetCameraBehindPlayer(playerid);
				gHotels[otelid][hotelVisitors]++;
				UpdateHotelData(otelid+1,"visitors",gHotels[otelid][hotelVisitors]);
				OnPlayerUpdateLoadingMode(playerid);
			}
		}
		case D_HOTEL_BUY_2: {
			if(!response) {
				if(GetPVarInt(playerid,"hotelProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"hotelProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"hotelPokupaet")-1;
					SendOk(playerid,"Вы отказались от покупки отеля");
					SendOk(id_prodaet,"Игрок отказался от покупки Вашего отеля");
					DeletePVar(playerid,"hotelProdaet");
					DeletePVar(playerid,"hotelCena");
					DeletePVar(id_pokupaet,"hotelPokupaet");
				}
			}
			else {
				if(GetPVarInt(playerid,"hotelProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"hotelProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"hotelPokupaet")-1;
					new hotel_cena = GetPVarInt(playerid,"hotelCena");
					if(id_pokupaet == playerid) {
						if(PI[playerid][pCash] < hotel_cena) {
							ErrorMessage(playerid,"У Вас недостаточно денег на руках");
							ErrorMessage(id_prodaet,"У покупателя недостаточно денег на руках");
							DeletePVar(playerid,"hotelProdaet");
							DeletePVar(playerid,"hotelCena");
							DeletePVar(id_pokupaet,"hotelPokupaet");
						}
						else {
							new string[128];
							format(string,64,"покупка отеля у %s",player_name[id_prodaet]);
							GiveMoney(playerid,-hotel_cena,string);
							string[0] = EOS;
							format(string,64,"продажа отеля %s",player_name[playerid]);
							GiveMoney(id_prodaet,hotel_cena,string);
							PI[playerid][pHotel] = PI[id_prodaet][pHotel];
							PI[id_prodaet][pHotel] = 0;
							UpdatePlayerData(id_prodaet,"hotelid",0);
							UpdatePlayerData(playerid,"hotelid",PI[playerid][pHotel]);
							strmid(gHotels[PI[playerid][pHotel]-1][hotelOwner],player_name[playerid],0,strlen(player_name[playerid]),MAX_PLAYER_NAME);
							new query[80 + MAX_PLAYER_NAME];
							format(query,sizeof(query),"UPDATE `hotels` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],PI[playerid][pHotel]);
							mysql_tquery(connects, query);
							new bizid = PI[playerid][pHotel]-1;
							UpdateHotelText(bizid);

							format(string,sizeof(string),"Вы приобрели отель у "P"%s"G" за "ORANGE"$%i",player_name[id_prodaet],hotel_cena);
							SendUse(playerid,string);
							format(string,sizeof(string),"Вы продали отель "P"%s"G" за "ORANGE"$%i",player_name[playerid],hotel_cena);
							SendUse(id_prodaet,string);
							DeletePVar(playerid,"hotelProdaet");
							DeletePVar(playerid,"hotelCena");
							DeletePVar(id_pokupaet,"hotelPokupaet");
						}
					}
					else {
						ErrorMessage(playerid,"Игрок оффлайн");
						DeletePVar(playerid,"hotelProdaet");
						DeletePVar(playerid,"hotelCena");
					}
				}
			}
		}
		case D_HOTEL_RECEPTION: {
		    if(!response) return 1;
			if(PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас уже есть дом");
			new hotel = GetPVarInt(playerid,"select_room") + listitem;
			SetPVarInt(playerid,"select_room",hotel);
			SetPVarInt(playerid,"select_room_1",listitem);

			if(GetString(gRooms[hotel][roomsOwner], "None")) {
				if(PI[playerid][pRoom] == 0) {
					new price;
					if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
						new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*vip_status[PI[playerid][pVips]][vip_hotel]);
						price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
					}
					else {
						if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
							new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*BonusInfo[act_renthotel]);
							price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
						}
						else if(BonusInfo[act_select] == 2) {
							new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*BonusInfo[act_renthotel]);
							price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
						}
					    else price = gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast];
					}

					static const f_str[] = ""W"Вы действительно хотите арендовать номер в отеле на 1 день за "GREEN"$%d?";
					new string[sizeof(f_str) +1 + (-2 + 4)];
					format(string, sizeof(string), f_str,price);
					D(playerid, D_HOTEL_ROOM_BUY, DSM, ""P"Отель", string, "Арендовать", "Отмена");
				}
				else ErrorMessage(playerid, "Вы уже арендуете номер в отеле");
			}
			else {
				if(GetString(gRooms[hotel][roomsOwner], player_name[playerid])) {
					D(playerid, D_HOTEL_RECEPTION_2, DSL, ""P"Отель", ""P"1."W" Информация\n"P"2."W" Продлить аренду\n"P"3."W" Отказаться от аренды\n"P"4."W" Автопарк", "Выбрать", "Отмена");
				}
				else ErrorMessage(playerid, "Номер занят");
			}
		}
		case D_HOTEL_ROOM_BUY: {
		    if(response) {
				if(PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас уже есть дом");
				new otel = GetPVarInt(playerid,"selectedhotel");
				new room = GetPVarInt(playerid,"select_room");
	            if(!GetString(gRooms[room][roomsOwner], "None")) return ErrorMessage(playerid,"Выбранный номер уже арендован");

	            if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
	            	new seller = floatround(gHotels[otel][hotelCoast]/100*vip_status[PI[playerid][pVips]][vip_hotel]);
					if(GetPlayerMoneyEx(playerid) < (gHotels[otel][hotelCoast]-seller)) return ErrorMessage(playerid,"Недостаточно денег для аренды");
					GiveMoney(playerid,-(gHotels[otel][hotelCoast]-seller),"аренда номера отель");
	            }
	            else {
		            if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(gHotels[otel][hotelCoast]/100*BonusInfo[act_renthotel]);
						if(GetPlayerMoneyEx(playerid) < (gHotels[otel][hotelCoast]-seller)) return ErrorMessage(playerid,"Недостаточно денег для аренды");
						GiveMoney(playerid,-(gHotels[otel][hotelCoast]-seller),"аренда номера отель");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(gHotels[otel][hotelCoast]/100*BonusInfo[act_renthotel]);
						if(GetPlayerMoneyEx(playerid) < (gHotels[otel][hotelCoast]-seller)) return ErrorMessage(playerid,"Недостаточно денег для аренды");
						GiveMoney(playerid,-(gHotels[otel][hotelCoast]-seller),"аренда номера отель");
					}
				    else {
				    	if(GetPlayerMoneyEx(playerid) < gHotels[otel][hotelCoast]) return ErrorMessage(playerid,"Недостаточно денег для аренды");
				    	GiveMoney(playerid,-gHotels[otel][hotelCoast],"аренда номера отель");
				    }
				}

				SetString(gRooms[room][roomsOwner], player_name[playerid]);

				gRooms[room][roomsDay] = unix + 60*60*24;

				new query[70 + MAX_PLAYER_NAME];
				format(query,sizeof(query),"UPDATE `rooms` SET `owner` = '%s',`day` = '%d' WHERE `id` = '%d'",player_name[playerid],gRooms[room][roomsDay],gRooms[room][roomsID]);
				mysql_tquery(connects, query);

				UpdatePlayerData(playerid,"hotelroom",room+1);
				PI[playerid][pRoom] = gRooms[room][roomsID];
				PI[playerid][pSpawn] = HOME_SPAWN;
				new room_lift;
				switch(GetPVarInt(playerid,"select_room_1")) {
					case 0..9: room_lift = 2;
					case 10..19: room_lift = 3;
					case 20..29: room_lift = 4;
					case 30..39: room_lift = 5;
					case 40..49: room_lift = 6;
					case 50..59: room_lift = 7;
				}
				new string[330];
				format(string,sizeof(string),""W"Добро пожаловать в отель: "P"%s\n\n\
											 "W"Ваш номер: "O"%d"W" успешно забронирован на "O"1"W" день.\n\
											 Находится он на "O"%d "W"этаже.\n\
											 Наш дворецкий уже отнёс Ваши вещи в номер.\n\n\
											 "GREEN"Приятного отдыха!",gHotels[GetPVarInt(playerid,"selectedhotel")][hotelName], GetPVarInt(playerid,"select_room_1")+1,room_lift);
				D(playerid,DIALOG_NONE,DSM, ""P"Отель",string,"Закрыть","");

				gHotels[otel][hotelBank] += gHotels[otel][hotelCoast];
				gHotels[otel][hotelBankDay] += gHotels[otel][hotelCoast];
				SaveHotels(otel);
				loading_cars(playerid,0);
				DeletePVar(playerid,"select_room_1");
		    }
			else ShowHotelRooms(playerid);
		}
		case D_HOTEL_RECEPTION_2: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new day;
					day = (gRooms[PI[playerid][pRoom]-1][roomsDay]-gettime())/86400;

					new string[128];
					format(string,sizeof(string),"Отель:\t"O"%s\n\
												Оплачено на:\t"O"%iд",gHotels[GetPVarInt(playerid,"selectedhotel")][hotelName],day);
					D(playerid,DIALOG_NONE,DST,"Информация",string,"Хорошо","");
				}
				case 1: {
					new price;
					if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
						new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*vip_status[PI[playerid][pVips]][vip_hotel]);
						price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
					}
					else {
						if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
							new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*BonusInfo[act_renthotel]);
							price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
						}
						else if(BonusInfo[act_select] == 2) {
							new seller = floatround(gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]/100*BonusInfo[act_renthotel]);
							price = (gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast]-seller);
						}
					    else price = gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast];
					}

					static const f_str[] = ""W"Введите кол-во дней на которое хотите продлить аренду за номер:\nСтоимость за день аренды: "GREEN"$%d";
					new string[sizeof(f_str) +1 + (-2 + 5)];
					format(string,sizeof(string),f_str,price);
					D(playerid,D_HOTEL_OPLATA,DSI, ""P"Оплата номера",string,"Оплатить","Отмена");
				}
				case 2: D(playerid,D_HOTEL_NORENT,DSM, ""P"Отказ от номера","\n\n"W"Вы действительно хотите отказаться от аренды номера?\n\n","Да","Отмена");
				case 3: {
					new string[144];
					if(PI[playerid][pVips] != VIP_GOLD || PI[playerid][pVips] != VIP_PLATINA || PI[playerid][pVips] != VIP_ECSCLUSIVE) {
						format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
						D(playerid,D_FIXCAR,DSL,""P"Доставить транспорт",string,"Выбрать","Закрыть");
					}
					else {
						format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]"W" - "ORANGE"$500\n"W"2. Автомобиль №2 "P"[%s]"W" - "ORANGE"$500",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
						D(playerid,D_FIXCAR,DSL,""P"Доставить транспорт",string,"Выбрать","Закрыть");
					}
				}
			}
		}
		case D_HOTEL_OPLATA: {
			if(!response) return 1;
			if(!PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет номера в отеле");
			new amount = strval(inputtext);
			new hotel = PI[playerid][pRoom] - 1;

			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])/100*vip_status[PI[playerid][pVips]][vip_hotel]);
				price = ((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])/100*BonusInfo[act_renthotel]);
					price = ((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])/100*BonusInfo[act_renthotel]);
					price = ((amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast])-seller);
				}
			    else price = amount*gHotels[GetPVarInt(playerid,"selectedhotel")][hotelCoast];
			}

			new day;
			day = (gRooms[hotel][roomsDay]-gettime())/86400;
			if(amount < 1 || amount > 15) return D(playerid,D_HOTEL_OPLATA,DSI, ""P"Оплата номера",""W"Введите кол-во дней на которое хотите продлить аренду за номер:\n\n"NO"*"G" От 1 до 15 дней","Ок","Отмена");
			if(day + amount > 15) return D(playerid,D_HOTEL_OPLATA,DSI, ""P"Оплата номера",""W"Введите кол-во дней на которое хотите продлить аренду за номер:\n\n"NO"*"G" Максимальное кол-во оплаченных дней 15","Ок","Отмена");
			if(PI[playerid][pCash] < price) return D(playerid,D_HOTEL_OPLATA,DSI, ""P"Оплата номера",""W"Введите кол-во дней на которое хотите продлить аренду за номер:\n\n"NO"*"G" Недостаточно средств","Ок","Отмена");
			gRooms[hotel][roomsDay] += 86400 * amount;
			new query[128];
			format(query,sizeof(query),"UPDATE `rooms` SET `day` = '%d' WHERE id = '%d'",gRooms[hotel][roomsDay],hotel+1);
			mysql_tquery(connects, query,"","");

			gHotels[GetPVarInt(playerid,"selectedhotel")][hotelBank] += price;
			gHotels[GetPVarInt(playerid,"selectedhotel")][hotelBankDay] += price;
			SaveHotels(GetPVarInt(playerid,"selectedhotel"));
			GiveMoney(playerid,-price,"аренда номера отель");

			static const f_str[] = ""W"Вы оплатили: "O"%d"W" дней. Снято средств: "GREEN"$%d";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,price);
			return D(playerid,DIALOG_NONE,DSM, ""P"Оплата номера",string,"Хорошо","");
		}
		case D_HOTEL_NORENT: {
			if(!response) return ShowHotelRooms(playerid);
			if(PI[playerid][pRoom] != 0) {
				new hotel = PI[playerid][pRoom]-1;
				if(GetString(gRooms[hotel][roomsOwner],player_name[playerid])) SetString(gRooms[hotel][roomsOwner],"None");

				new query[64];
				format(query,sizeof(query),"UPDATE `rooms` SET `owner` = 'None' WHERE `id` = '%d'",gRooms[hotel][roomsID]);
				mysql_tquery(connects, query);

				PI[playerid][pRoom] = 0;
				UpdatePlayerData(playerid,"hotelroom",0);
				SendOk(playerid,"Вы успешно отказались от аренды номера");

				if(house_car[playerid][0] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[playerid][0]),house_car[playerid][0] = INVALID_VEHICLE_ID;
				else if(house_car[playerid][1] != INVALID_VEHICLE_ID) A_DestroyVehicle(house_car[playerid][1]),house_car[playerid][1] = INVALID_VEHICLE_ID;
			}
		}
		case D_HOTEL_LIFT_1: {
			if(!response) return 1;
			TI[playerid][tTPpick] = true;
			new otelid = GetPVarInt(playerid,"selectedhotel");
			updaterooms(playerid,gHotels[otelid][hotelVW][listitem+1]);
			SetPlayerPosAC(playerid, 159.7573,-15.1663,1002.1111, gHotels[otelid][hotelVW][listitem+1], 80);
			SetPlayerFacingAngle(playerid,359.6357);
			SetCameraBehindPlayer(playerid);
			OnPlayerUpdateLoadingMode(playerid);
		}
		case D_HOTEL_LIFT_2: {
			if(!response) return 1;
			TI[playerid][tTPpick] = true;
			new otelid = GetPVarInt(playerid, "selectedhotel");
			if(listitem == 0) {
				SetPlayerPosAC(playerid, 1394.9865,-16.6047,1000.9176, otelid, 79);
				SetPlayerFacingAngle(playerid,270.1191);
			}
			else {
				updaterooms(playerid,gHotels[otelid][hotelVW][listitem+1]);
				SetPlayerPosAC(playerid, 159.7573,-15.1663,1002.1111, gHotels[otelid][hotelVW][listitem+1], 80);
				SetPlayerFacingAngle(playerid,359.6357);
			}
			SetCameraBehindPlayer(playerid);
			OnPlayerUpdateLoadingMode(playerid);
		}
		case D_AIRPORT: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new string[64];
					format(string,sizeof(string),""W"В кассе: "GREEN"$%d",gAirs[PI[playerid][pAirport]-1][airBank]);
					D(playerid,DIALOG_NONE,DSM, ""P"Касса",string,"Хорошо","");
				}
				case 1: D(playerid,D_AIRPORT_BANK,DSI, ""P"Аэропорт",""W"Введите сумму, которую хотите взять с кассы аэропорта:","Взять","Отмена");
				case 2: ShowAirportInformation(playerid,PI[playerid][pAirport]-1,DIALOG_NONE);
				case 3: D(playerid,D_AIRPORT_PRICE,DSI, ""P"Аэропорт",""W"Введите цену за аренду воздушной техники\nПримечание: от "GREEN"$120.000"W" до "GREEN"$170.000","ОК","Отмена");
				case 4: {
					static const f_str[] = ""W"Вы хотите продать аэропорт государству за "GREEN"$%d?\n\n"G"Для продажи аэропорта игроку введите: /sellairport [ID игрока] [Сумма]";
					new string[sizeof(f_str) +1 + (-2 + 8)];
					format(string,sizeof(string),f_str,floatround(gAirs[PI[playerid][pAirport]-1][airPrice]/100*80));
					D(playerid,D_AIRPORT_SELL,DSM, ""P"Аэропорт",string,"Продать","Отмена");
				}
			}
		}
		case D_AIRPORT_BANK: {
			if(!response) return 1;
			if(!PI[playerid][pAirport]) return 1;
			new id = PI[playerid][pAirport]-1;
			new sum = strval(inputtext);
			if(sum < 1 || sum > 1000000) return D(playerid,D_AIRPORT_BANK,DSI, ""P"Аэропорт",""W"Введите сумму, которую хотите взять с кассы аэропорта:\n\n"NO"*"G" От $1 до $1.000.000","Взять","Отмена");
			if(gAirs[id][airBank] < sum) return D(playerid,D_AIRPORT_BANK,DSI, ""P"Аэропорт",""W"Введите сумму, которую хотите взять с кассы аэропорта:\n\n"NO"*"G" В кассе недостаточно средств","Взять","Отмена");
			if(UpdateHotelData(id,"bank",gAirs[id][airBank] - sum)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #31");
			gAirs[id][airBank] -= sum;
			UpdateAirportData(id+1,"bank",gAirs[id][airBank]);
			GiveMoney(playerid,sum,"прибыль с аэропорта");

			new string[128];
			format(string,sizeof(string),"Вы взяли с кассы аэропорта: "ORANGE"$%d",sum);
			SendUse(playerid,string);
		}
		case D_AIRPORT_PRICE: {
			if(!response) return 1;
			new id = PI[playerid][pAirport] - 1;
			if(id < 0) return true;
			new price = strval(inputtext);
			if(price < 120000 || price > 170000) return D(playerid,D_AIRPORT_PRICE,DSI, ""P"Аэропорт",""W"Введите цену за аренду воздушной техники\n\n"NO"*"G" От $120.000 до $170.000","ОК","Отмена");
			gAirs[id][airCoast] = price;
			UpdateAirportData(id+1,"coast",price);
			UpdateAirportsText(id);
			new string[128];
			format(string,sizeof(string),"Цена за за аренду воздушной техники установлена: "ORANGE"$%d",price);
			SendUse(playerid,string);
		}
		case D_AIRPORT_SELL: {
			if(!response) return 1;
			if(PI[playerid][pAirport] < 1) return ErrorMessage(playerid,"У Вас нет аэропорта");
			new id = PI[playerid][pAirport] - 1;
			new sum = floatround(gAirs[id][airPrice]/100*80);

			FI[fWHITEHOUSE][fBank] += floatround(gAirs[id][airPrice]/100*20);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			if(UpdateAirportData(id+1,"ownerid",0)) return SendClientMessage(playerid,COLOR_REDD,"Ошибка #32");
			gAirs[id][airOwnerID] = 0;
			SetString(gAirs[id][airOwner],"");
			new query[256];
			format(query,sizeof(query),"UPDATE `airports` SET `ownerid` = '0', `owner` = '' ,`bank` = '0',`bankday` = '0' WHERE `id` = '%d'",id+1);
			mysql_tquery(connects, query,"","");
			UpdateAirportsText(id);
			PI[playerid][pAirport] = 0;
			UpdatePlayerData(playerid,"airport",0);
			GiveMoney(playerid,sum,"продажа аэропорта");
			SendOk(playerid,"Аэропорт продан государству");
		}
		case D_AIRPORT_BUY: {
			if(!response) return DeletePVar(playerid,"selectedair");
			if(PI[playerid][pAirport]) return ErrorMessage(playerid,"Вы уже владеете одним из аэропортов");
			new airid = GetPVarInt(playerid,"selectedair");
			if(GetPlayerMoneyEx(playerid) < gAirs[airid][airPrice]) return ErrorMessage(playerid,"У Вас недостаточно денег");
			gAirs[airid][airDay] = unix + 60*60*24;

			new query[172];
			format(query,sizeof(query),"UPDATE `airports` SET `ownerid` = '%d', `owner` = '%s', `day` = '%d' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],gAirs[airid][airDay],airid+1);
			mysql_tquery(connects, query,"","");

			GiveMoney(playerid,-gAirs[airid][airPrice],"покупка аэропорта");
			gAirs[airid][airOwnerID] = PI[playerid][pID];
			format(gAirs[airid][airOwner],24,"%s",player_name[playerid]);

			UpdateAirportsText(airid);

			PI[playerid][pAirport] = airid+1;
			UpdatePlayerData(playerid,"airport",PI[playerid][pAirport]);

			SendClientMessage(playerid,CGOLD,"Поздравляем, Вы купили аэропорт. Не забывайте оплачивать его, иначе его продадут государству!");
			return 1;
		}
		case D_AIRPORT_BUY_2: {
			if(!response) {
				if(GetPVarInt(playerid,"airProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"airProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"airPokupaet")-1;
					SendOk(playerid,"Вы отказались от покупки аэропорта");
					SendOk(id_prodaet,"Игрок отказался от покупки Вашего аэропорта");
					DeletePVar(playerid,"airProdaet");
					DeletePVar(playerid,"airCena");
					DeletePVar(id_pokupaet,"airPokupaet");
				}
			}
			else {
				if(GetPVarInt(playerid,"airProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"airProdaet")-1;
					new id_pokupaet = GetPVarInt(id_prodaet,"airPokupaet")-1;
					new airport_cena = GetPVarInt(playerid,"airCena");
					if(id_pokupaet == playerid) {
						if(PI[playerid][pCash] < airport_cena) {
							ErrorMessage(playerid,"У Вас недостаточно денег на руках");
							ErrorMessage(id_prodaet,"У покупателя недостаточно денег на руках");
							DeletePVar(playerid,"airProdaet");
							DeletePVar(playerid,"airCena");
							DeletePVar(id_pokupaet,"airPokupaet");
						}
						else {
							GiveMoney(playerid,-airport_cena,"покупка аэропорта");
							GiveMoney(id_prodaet,airport_cena,"продажа аэропорта");
							PI[playerid][pAirport] = PI[id_prodaet][pAirport];
							PI[id_prodaet][pAirport] = 0;
							UpdatePlayerData(id_prodaet,"airport",0);
							UpdatePlayerData(playerid,"airport",PI[playerid][pAirport]);
							strmid(gAirs[PI[playerid][pAirport]-1][airOwner],player_name[playerid],0,strlen(player_name[playerid]),MAX_PLAYER_NAME);
							new query[200],string[128];
							format(query,sizeof(query),"UPDATE `airports` SET `ownerid` = '%d', `owner` = '%s' WHERE `id` = '%d'",PI[playerid][pID],player_name[playerid],PI[playerid][pAirport]);
							mysql_tquery(connects, query);
							UpdateAirportsText(PI[playerid][pAirport]-1);

							format(string,sizeof(string),"Вы приобрели аэропорт у "P"%s"G" за "ORANGE"$%i",player_name[id_prodaet],airport_cena);
							SendUse(playerid,string);
							format(string,sizeof(string),"Вы продали аэропорт "P"%s"G" за "ORANGE"$%i",player_name[playerid],airport_cena);
							SendUse(id_prodaet,string);
							DeletePVar(playerid,"airProdaet");
							DeletePVar(playerid,"airCena");
							DeletePVar(id_pokupaet,"airPokupaet");
						}
					}
					else {
						ErrorMessage(playerid,"Игрок оффлайн");
						DeletePVar(playerid,"airProdaet");
						DeletePVar(playerid,"airCena");
					}
				}
			}
		}
		case D_FAMILY_CREATE_2: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid,D_FAMILY_CREATE_3,DSL, ""P"ТОП Семей",""P"1."W" По уровню\n"P"2."W" По EXP\n"P"3."W" По поинтам","Выбрать","Отмена");
				case 1: {
					if(PI[playerid][pFamily] > 0) return ErrorMessage(playerid,"Вы состоите в семье");
					D(playerid,D_FAMILY_CREATE,DSI, ""P"Создание семьи","\n\n"W"Введите название семьи:\n\nСтоимость создания семьи стоит - "GREEN"1.000.000$\n\n","Создать","Отмена");
				}
			}
		}
		case D_FAMILY_CREATE_3: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `name`,`lvl` FROM `family` ORDER BY `lvl` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new lvl;
						new name[44];
						new string[300];
	       				string = ""P"№ Название семьи\t"P"Уровень\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "name", name, 44);
							cache_get_value_name_int(i, "lvl",lvl);
							format(str, sizeof(str), f_str, i+1, name,lvl);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, ""P"Топ семей по уровню", string, "Закрыть", "");
					}
					cache_delete(result);
				}
				case 1: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `name`,`exp` FROM `family` ORDER BY `exp` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new name[44];
						new exp;
						new string[300];
	       				string = ""P"№ Название семьи\t"P"EXP\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "name", name, 44);
							cache_get_value_name_int(i, "exp",exp);
							format(str, sizeof(str), f_str, i+1, name,exp);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, ""P"Топ семей по EXP", string, "Закрыть", "");
					}
					cache_delete(result);
				}
				case 2: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `name`,`point` FROM `family` ORDER BY `point` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new name[44];
						new point;
						new string[300];
	       				string = ""P"№ Название семьи\t"P"Поинты\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "name", name, 44);
							cache_get_value_name_int(i, "point",point);
							format(str, sizeof(str), f_str, i+1, name,point);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, ""P"Топ семей по поинтам", string, "Закрыть", "");
					}
					cache_delete(result);
				}
			}
		}
		case D_FAMILY_CREATE: {
			if(!response) return 1;
			if(PI[playerid][pFamily] > 0) return ErrorMessage(playerid,"Вы состоите в семье");
			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 30) {
			    D(playerid,D_FAMILY_CREATE,DSI, ""P"Создание семьи","\n\n"W"Введите название семьи:\n\nСтоимость создания семьи стоит - "GREEN"1.000.000$\n"NO"*"G" От 6 до 30 символов\n\n","Создать","Отмена");
				return true;
			}
			if(is_text_invalid(inputtext)) {
				D(playerid,D_FAMILY_CREATE,DSI, ""P"Создание семьи","\n\n"W"Введите название семьи:\n\nСтоимость создания семьи стоит - "GREEN"1.000.000$\n"NO"*"G" Присутствуют запрещенные символы\n\n","Создать","Отмена");
				return true;
			}
			if(PI[playerid][pCash] < 1000000) return ErrorMessage(playerid,"Для создания семьи необходимо иметь 1.000.000$");
			if(TotalFamily >= FAMILY_COUNT) return ErrorMessage(playerid,"На сервере достигнут лимит семей");
			new query[100];
			mysql_format(connects,query, sizeof(query), "SELECT * FROM family WHERE name = '%e'", inputtext);
			new Cache:result = mysql_query(connects, query);
			if(cache_num_rows()) {
				ErrorMessage(playerid, "Семья с таким именем уже существует");
				cache_delete(result);
				return 1;
			}
			cache_delete(result);

			strmid(gFamily[TotalFamily][famCName],inputtext,0,strlen(inputtext),strlen(inputtext)+1);
			strmid(gFamily[TotalFamily][famName],inputtext,0,strlen(inputtext),strlen(inputtext)+1);
			SetString(FamRanks[TotalFamily][0],"None");
			SetString(FamRanks[TotalFamily][1],"None");
			SetString(FamRanks[TotalFamily][2],"None");
			SetString(FamRanks[TotalFamily][3],"None");
			SetString(FamRanks[TotalFamily][4],"None");
			SetString(FamRanks[TotalFamily][5],"None");
			SetString(FamRanks[TotalFamily][6],"None");
			SetString(FamRanks[TotalFamily][7],"None");
			SetString(FamRanks[TotalFamily][8],"None");
			SetString(gFamily[TotalFamily][famMessage],"None");
			gFamily[TotalFamily][famInvRang] = gFamily[TotalFamily][famUninvRang] = gFamily[TotalFamily][famGiveRang] = 7;
			gFamily[TotalFamily][famLvl] = 1;
			new string[128];
			format(string,sizeof(string),"Поздравляем с созданием семьи - "ORANGE"%s",gFamily[TotalFamily][famCName]);
			SendUse(playerid,string);
			SendOk(playerid,"Управление семьей - "W"/fmenu");
			PI[playerid][pFamily] = TotalFamily + 1;
			UpdatePlayerData(playerid,"family",PI[playerid][pFamily]);
			PI[playerid][pFamRank] = 8;
			UpdatePlayerData(playerid,"pFamRank",8);
			strmid(gFamily[TotalFamily][famCOwner],player_name[playerid],0,strlen(player_name[playerid]),MAX_PLAYER_NAME);
			strmid(gFamily[TotalFamily][famOwner],player_name[playerid],0,strlen(player_name[playerid]),MAX_PLAYER_NAME);
			new querys[200];
			mysql_format(connects, querys, sizeof(querys), "INSERT INTO `family`(`cname`,`name`,`time`,`cowner`,`owner`) VALUES ('%e','%e',NOW(),'%e','%e')",
				gFamily[TotalFamily][famCName],gFamily[TotalFamily][famName],gFamily[TotalFamily][famCOwner],gFamily[TotalFamily][famOwner]);
			mysql_tquery(connects, querys, "creategFamily", "i", TotalFamily);
			TotalFamily++;
			GiveMoney(playerid, -1000000, "создание семьи");
		}
		case D_FAMILY: {
			if(!response) return 1;
			new fam = PI[playerid][pFamily]-1;
			switch(listitem) {
				case 0: {
					new str[24];
					if(gFamily[fam][famHouse] && gHouses[gFamily[fam][famHouse]-1][houseFamily] == gFamily[fam][famHouse]) format(str,sizeof(str),"Дом №%d",gHouses[gFamily[fam][famHouse]-1][houseFamily]);
					else str = "Отсутствует";
					static const f_str[] = "\t\t\t"W"Семья - "YELLOW"%s\n\n\
												"W"Основатель: \t\t\t"P"%s (%s)\n\
												"W"Дата основания: \t\t"P"%s\n\
												"W"Владелец: \t\t\t"P"%s\n\
												"W"Тип семьи: \t\t\t"P"%s\n\
												"W"Численность: \t\t\t"P"%d\n\n\
												"W"Уровень: \t\t\t"P"%d\n\
												"W"EXP: \t\t\t\t"P"%d/%d\n\
												"W"Поинты: \t\t\t"P"%d\n\n\
												"W"Деньги: \t\t\t"P"$%d / $%d\n\
												"W"Наркотики: \t\t\t"P"%d гр. / %d гр.\n\
												"W"Боеприпасы: \t\t\t"P"%d ед. / %d ед.\n\
												"W"Бронежилеты: \t\t"P"%d ед. / %d ед.\n\
												"W"Аптечки: \t\t\t"P"%d ед. / %d ед.\n\
												"W"Маски: \t\t\t"P"%d ед. / %d ед.\n\
												"W"Канистр с бензином: \t\t"P"%d ед. / %d ед.\n\
												"W"Ремкомплекты: \t\t"P"%d ед. / %d ед.\n\n\
												"W"Место жительства: \t\t"P"%s";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 24) + (-2 + 24) + (-2 + 24) + (-2 + 11) + (-2 + 11) + (-2 + 11) + (-2 + 11)];
					format(string,sizeof(string),f_str,
												gFamily[fam][famName],
												gFamily[fam][famCOwner],
												gFamily[fam][famCName],
												gFamily[fam][famDate],
												gFamily[fam][famOwner],
												(gFamily[fam][famType] == 0)?("Standart"):("Pro"),
												fam_members(fam+1),
												gFamily[fam][famLvl],
												gFamily[fam][famExp],
												fam_point_upgrade[gFamily[fam][famLvl]-1],
												gFamily[fam][famPoint],
												gFamily[fam][famMoney],
												FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],
												gFamily[fam][famDrugs],
												FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],
												gFamily[fam][famMats],
												FamilyMatsUpdate[gFamily[fam][famMatsMax]],
												gFamily[fam][famArmour],
												FamilyArmourUpdate[gFamily[fam][famArmourMax]],
												gFamily[fam][famHealth],
												FamilyHealthUpdate[gFamily[fam][famHealthMax]],
												gFamily[fam][famMask],
												FamilyMaskUpdate[gFamily[fam][famMaskMax]],
												gFamily[fam][famFuel],
												FamilyFuelUpdate[gFamily[fam][famFuelMax]],
												gFamily[fam][famRemp],
												FamilyRempUpdate[gFamily[fam][famRempMax]],
												str);
					return D(playerid,D_FAMILY_INFO,DSM, ""P"Информация",string,"Назад","");
				}
				case 1: {
					new count_family = 0,string[1512];
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(PI[i][pFamily] == PI[playerid][pFamily]) {
							format(string,sizeof(string),"%s"P"%i."W" %s\n",string,count_family+1,player_name[i]);
							count_family++;
						}
					}
					return D(playerid,D_FAMILY_INFO,DSL,""P"Семья online",string,"Назад","");
				}
				case 2: {
					FirstFamily[playerid] = 0;
					new query[64],rows;
				    format(query, sizeof(query), "SELECT * FROM `"TABLE_ACCOUNTS"` WHERE `family` = '%d' LIMIT 20", PI[playerid][pFamily]);
   					new Cache:result = mysql_query(connects, query);
   					cache_get_row_count(rows);
					new names[MAX_PLAYER_NAME + 1],Level,bool:ids = false;   
					string_1024[0] = EOS;
					for(new i; i < rows; i ++) {
						cache_get_value_name(i, "Name", names, MAX_PLAYER_NAME);
						cache_get_value_name_int(i, "pLevel",Level);
						if(IsPlayerConnected(GetPlayerID(names))) continue;
						if(Level < 3) format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "NO"%d LEVEL\n", string_1024, i+1, names, Level);
						else format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "GREEN"%d LEVEL\n", string_1024, i+1, names, Level);
						ids = true;
					}
					if(ids == true) D(playerid, D_FAMILY_OFFLINE, 0, "Семья offline", string_1024, "Далее", "Назад");
					else ErrorMessage(playerid, "Список членов семьи offline пуст");
					cache_delete(result);
				}
				case 3: {
					static const f_str[] = "№ Наименование\tКоличество\n\
											1. Деньги\t$%d / $%d\n\
											2. Наркотики\t%d гр. / %d гр.\n\
											3. Боеприпасы\t%d ед. / %d ед.\n\
											4. Бронежилеты\t%d ед. / %d ед.\n\
											5. Аптечки\t%d ед. / %d ед.\n\
											6. Маски\t%d ед. / %d ед.\n\
											7. Канистр с бензином\t%d ед. / %d ед.\n\
											8. Ремкомплекты\t%d ед. / %d ед.";
					new string[sizeof(f_str) + 50];
					format(string,sizeof(string),f_str,
												gFamily[fam][famMoney],
												FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],
												gFamily[fam][famDrugs],
												FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],
												gFamily[fam][famMats],
												FamilyMatsUpdate[gFamily[fam][famMatsMax]],
												gFamily[fam][famArmour],
												FamilyArmourUpdate[gFamily[fam][famArmourMax]],
												gFamily[fam][famHealth],
												FamilyHealthUpdate[gFamily[fam][famHealthMax]],
												gFamily[fam][famMask],
												FamilyMaskUpdate[gFamily[fam][famMaskMax]],
												gFamily[fam][famFuel],
												FamilyFuelUpdate[gFamily[fam][famFuelMax]],
												gFamily[fam][famRemp],
												FamilyRempUpdate[gFamily[fam][famRempMax]]);
					return D(playerid,D_FAMILY_STORE,DSTH,"Сбережения",string,"Выбрать","Назад");
				}
				case 4: {
					if(strcmp(gFamily[fam][famOwner],player_name[playerid],true)) return ErrorMessage(playerid,"Доступно только владельцу семьи");
					family_setting(playerid);
				}
				case 5: {
					if(GetString(gFamily[fam][famOwner],player_name[playerid])) return ErrorMessage(playerid,"Вы не можете покинуть семью, так как владелец");
					new string[128];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} покинул семью",player_name[playerid],FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
					PI[playerid][pFamily] = 0;
					UpdatePlayerData(playerid,"family",0);
					PI[playerid][pFamRank] = 0;
					UpdatePlayerData(playerid,"pFamRank",0);
				}
			}
		}
		case D_FAMILY_SET: {
			if(!response) return family_dialog(playerid);
			new fam = PI[playerid][pFamily]-1;
			if(strcmp(gFamily[fam][famOwner],player_name[playerid],true)) return ErrorMessage(playerid,"Доступно только владельцу семьи");
			switch(listitem) {
				case 0..3: {
					string_1024[0] = EOS;
					for(new i = 1; i <= 8; i++) {
						new frac_rank_check = -1;
						switch(listitem)
						{
							case 0: frac_rank_check = gFamily[fam][famInvRang];
							case 1: frac_rank_check = gFamily[fam][famUninvRang];
							case 2: frac_rank_check = gFamily[fam][famGiveRang];
							case 3: frac_rank_check = gFamily[fam][famSklad];
						}
						if(frac_rank_check == -1) return true;
						format(string_1024,sizeof(string_1024),"%s%i. %s%s\n", string_1024,i,(i == frac_rank_check)?(""P""):(""W""),GetFamName(fam,i));
					}
					SetPVarInt(playerid,"fam_rank", listitem);
					D(playerid,D_FAMILY_SET_RANK,DSL,""P"Выберите ранг",string_1024,"Выбрать", "Закрыть");
				}
				case 4: {
					string_1024[0] = EOS;
					strcat(string_1024, ""W"");
					for(new i = 1; i <= 8; i++) {
						format(string_1024,sizeof(string_1024),"%s%s\n",string_1024,GetFamName(fam,i));
					}
					D(playerid,D_FAMILY_ERANK_1,DSL,""P"Выберите ранг",string_1024,"Выбрать","Назад");
					return 1;
				}
				case 5: {
					new string[256];
					format(string,sizeof(string),"{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---\n{%s}---",FamilyColor[0],
												FamilyColor[1],FamilyColor[2],FamilyColor[3],FamilyColor[4],FamilyColor[5],FamilyColor[6],FamilyColor[7],FamilyColor[8],FamilyColor[9],FamilyColor[10],FamilyColor[11],FamilyColor[12]);
					D(playerid,D_FAMILY_COLOR,DSL,""P"Изменение цвета",string,"Выбрать","Отмена");
				}
				case 6: D(playerid,D_FAMILY_NAME,DSI,""P"Изменение названя","\n\n"W"Введите новое название семьи:\n\n","Изменить","Назад");
				case 7: {
					static const f_str[] = "№ Наименование\tСостояние склада\tВместимость\tУровень улучшений\n\
											1. Деньги\t$%d\t%d\t%d/20\n\
											2. Наркотики\t%d гр.\t%d\t%d/20\n\
											3. Боеприпасы\t%d ед.\t%d\t%d/20\n\
											4. Бронежилеты\t%d ед.\t%d\t%d/20\n\
											5. Аптечки\t%d ед.\t%d\t%d/20\n\
											6. Маски\t%d ед.\t%d\t%d/20\n\
											7. Канистр с бензином\t%d ед.\t%d\t%d/20\n\
											8. Ремкомплекты\t%d ед.\t%d\t%d/20";
					new string[sizeof(f_str) + 70];
					format(string,sizeof(string),f_str,
						gFamily[fam][famMoney],
						FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],
						gFamily[fam][famMoneyMax]+1,
						gFamily[fam][famDrugs],
						FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],
						gFamily[fam][famDrugsMax]+1,
						gFamily[fam][famMats],
						FamilyMatsUpdate[gFamily[fam][famMatsMax]],
						gFamily[fam][famMatsMax]+1,
						gFamily[fam][famArmour],
						FamilyArmourUpdate[gFamily[fam][famArmourMax]],
						gFamily[fam][famArmourMax]+1,
						gFamily[fam][famHealth],
						FamilyHealthUpdate[gFamily[fam][famHealthMax]],
						gFamily[fam][famHealthMax]+1,
						gFamily[fam][famMask],
						FamilyMaskUpdate[gFamily[fam][famMaskMax]],
						gFamily[fam][famMaskMax]+1,
						gFamily[fam][famFuel],
						FamilyFuelUpdate[gFamily[fam][famFuelMax]],
						gFamily[fam][famFuelMax]+1,
						gFamily[fam][famRemp],
						FamilyRempUpdate[gFamily[fam][famRempMax]],
						gFamily[fam][famRempMax]+1);
					D(playerid,D_FAMILY_UPDATE,DIALOG_STYLE_TABLIST_HEADERS,""P"Улучшение склада",string,"Улучшить","Назад");
				}
				case 8: D(playerid,D_FAMILY_TEXT, DSI, ""P"Сообщение семье", "\n\n"W"Введите сообщение, которое будет показано членам Вашей семьи при входе:\nДля удаления сообщения введите: "ORANGE"None\n\n", "Ввод", "Отмена");
				case 9: {
					if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома");
					if(gHouses[PI[playerid][pHouse]-1][houseClass] != 3) return ErrorMessage(playerid,"Класс дома не соответствует классу 'ОСОБНЯК'");
					D(playerid,D_FAMILY_HOUSE,DSM,""P"Дом семьи","\n\n"W"Вы действительно хотите выбрать Ваш дом, спавном своей семьи?\n\n","Да","Отмена");
				}
			}
		}
		case D_FAMILY_TEXT: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new message[71];
			if(NonSym(inputtext,70,1)) return D(playerid,D_FAMILY_TEXT, DSI, ""P"Сообщение семье", "\n\n"W"Введите сообщение, которое будет показано членам Вашей семьи при входе:\nДля удаления сообщения введите: "ORANGE"None\n\n"NO"* "G"Запрещены некорректные символы\n\n", "Ввод", "Отмена");
			if(sscanf(inputtext,"s[70]",message)) return D(playerid,D_FAMILY_TEXT, DSI, ""P"Сообщение семье", "\n\n"W"Введите сообщение, которое будет показано членам Вашей семьи при входе:\nДля удаления сообщения введите: "ORANGE"None\n\n"NO"* "G"От 1 до 70 символов\n\n", "Ввод", "Отмена");
			strmid(gFamily[PI[playerid][pFamily]-1][famMessage],message,0,strlen(message),70);

			new query[350];
			mysql_format(connects, query, sizeof(query),"UPDATE `family` SET message = '%e' WHERE `id` = '%d' LIMIT 1",gFamily[PI[playerid][pFamily]-1][famMessage],PI[playerid][pFamily]);
			mysql_tquery(connects,query);

			new string[128];
			format(string,sizeof(string),"Сообщение: "ORANGE"%s "G"успешно установлено",message);
			SendOk(playerid,string);
		}
		case D_FAMILY_HOUSE: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома");
			if(gHouses[PI[playerid][pHouse]-1][houseClass] != 3) return ErrorMessage(playerid,"Класс дома не соответствует классу 'ОСОБНЯК'");
			gFamily[PI[playerid][pFamily]-1][famHouse] = PI[playerid][pHouse];
			UpdateFamily(PI[playerid][pFamily],"house",PI[playerid][pHouse]);
			gHouses[PI[playerid][pHouse]-1][houseFamily] = PI[playerid][pHouse];
			new query[128];
			format(query,sizeof(query),"UPDATE `houses` SET `family` = '%d' WHERE id = '%d'",gHouses[PI[playerid][pHouse]-1][houseFamily],PI[playerid][pHouse]);
			mysql_tquery(connects, query);
			SendOk(playerid,"Дом семьи успешно выбран");
		}
		case D_FAMILY_UPDATE: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new fam = PI[playerid][pFamily]-1;
			new max_upgrade = 19,lvl = -1;
			new name_upgrade[8][19] = {"денег","наркотиков","боеприпасов","бронежилетов","аптечек","масок","канистр с бензином","ремкомплектов"};
			switch(listitem) {
				case 0: {
					if(gFamily[fam][famMoneyMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famMoneyMax];
				}
				case 1: {
					if(gFamily[fam][famDrugsMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famDrugsMax];
				}
				case 2: {
					if(gFamily[fam][famMatsMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famMatsMax];
				}
				case 3: {
					if(gFamily[fam][famArmourMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famArmourMax];
				}
				case 4: {
					if(gFamily[fam][famHealthMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famHealthMax];
				}
				case 5: {
					if(gFamily[fam][famMaskMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famMaskMax];
				}
				case 6: {
					if(gFamily[fam][famFuelMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famFuelMax];
				}
				case 7: {
					if(gFamily[fam][famRempMax] == max_upgrade) return ErrorMessage(playerid,"Данный склад достиг максимального уровня");
					lvl = gFamily[fam][famRempMax];
				}
			}
			if(gFamily[fam][famLvl] < lvl+2) return ErrorMessage(playerid,"Уровень семьи недостаточен");
			SetPVarInt(playerid, "fam_upgrade_stock", listitem);
			new string[144];
			format(string,sizeof(string),"\n\n"W"Вы действительно хотите улучшить склад "P"%s"W" до "P"%d"W" уровня за "ORANGE"%d"W" поинтов?",name_upgrade[listitem],lvl+2,fam_point_upgrade[lvl]);
			D(playerid,D_FAMILY_UPDATE_2,DSM,""P"Улучшение склада",string,"Улучшить","Отмена");
		}
		case D_FAMILY_UPDATE_2: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new fam = PI[playerid][pFamily]-1;
			switch(GetPVarInt(playerid, "fam_upgrade_stock")) {
				case 0: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famMoneyMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famMoneyMax]];
					gFamily[fam][famMoneyMax]++;
					UpdateFamily(fam+1,"money_max",gFamily[fam][famMoneyMax]);
				}
				case 1: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famDrugsMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famDrugsMax]];
					gFamily[fam][famDrugsMax]++;
					UpdateFamily(fam+1,"drugs_max",gFamily[fam][famDrugsMax]);
				}
				case 2: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famMatsMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famMatsMax]];
					gFamily[fam][famMatsMax]++;
					UpdateFamily(fam+1,"mats_max",gFamily[fam][famMatsMax]);
				}
				case 3: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famArmourMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famArmourMax]];
					gFamily[fam][famArmourMax]++;
					UpdateFamily(fam+1,"armour_max",gFamily[fam][famArmourMax]);
				}
				case 4: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famHealthMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famHealthMax]];
					gFamily[fam][famHealthMax]++;
					UpdateFamily(fam+1,"health_max",gFamily[fam][famHealthMax]);
				}
				case 5: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famMaskMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famMaskMax]];
					gFamily[fam][famMaskMax]++;
					UpdateFamily(fam+1,"mask_max",gFamily[fam][famMaskMax]);
				}
				case 6: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famFuelMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famFuelMax]];
					gFamily[fam][famFuelMax]++;
					UpdateFamily(fam+1,"fuel_max",gFamily[fam][famFuelMax]);
				}
				case 7: {
					if(gFamily[fam][famPoint] < fam_point_upgrade[gFamily[fam][famRempMax]]) return ErrorMessage(playerid,"У Вашей семьи недостаточно поинтов");
					gFamily[fam][famPoint]-=fam_point_upgrade[gFamily[fam][famRempMax]];
					gFamily[fam][famRempMax]++;
					UpdateFamily(fam+1,"remp_max",gFamily[fam][famRempMax]);
				}
			}
			SendOk(playerid,"Склад успешно улучшен");
			UpdateFamily(fam+1,"point",gFamily[fam][famPoint]);
		}
		case D_FAM_RANK: {
			if(!response) return 1;
			if(listitem == -1) return 1;
			if(PI[playerid][pFamRank] <= listitem) return ErrorMessage(playerid, "Ваш ранг недостаточен");
			new rank_id = GetPVarInt(playerid,"id_fgiverank"),string[128];
			new fam = PI[playerid][pFamily]-1;
			format(string,sizeof(string),"Вы повысили/понизили "W"%s{%s} до ранга "W"%s",player_name[rank_id],FamilyColor[gFamily[fam][famColor]],GetFamName(fam,listitem+1));
			SendClientMessage(playerid,FamilyColorG[gFamily[fam][famColor]],string);

			format(string,sizeof(string),"Вас повысил/понизил "W"%s{%s} до ранга "W"%s",player_name[playerid],FamilyColor[gFamily[fam][famColor]],GetFamName(fam,listitem+1));
			SendClientMessage(rank_id,FamilyColorG[gFamily[fam][famColor]],string);

			PI[rank_id][pFamRank] = listitem + 1;
			UpdatePlayerData(rank_id,"pFamRank",PI[rank_id][pFamRank]);

			DeletePVar(playerid,"id_fgiverank");
			return 1;
		}
		case D_FAMILY_COLOR: {
			if(!response) return family_dialog(playerid);
			if(!PI[playerid][pFamily]) return 1;
			new fam = PI[playerid][pFamily]-1;
			gFamily[fam][famColor] = listitem;
			UpdateFamily(fam+1,"color",listitem);

			new string[128];
			format(string,sizeof(string),"Вы успешно изменили цвет Вашей семье на - {%s}ЦВЕТ СЕМЬИ",FamilyColor[gFamily[fam][famColor]]);
			SendUse(playerid,string);

			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[playerid][pFamily] != PI[i][pFamily]) continue;
				new famtext[50];
				format(famtext,sizeof(famtext),"{%s}%s",FamilyColor[gFamily[PI[i][pFamily]-1][famColor]],gFamily[PI[i][pFamily]-1][famName]);
				UpdateDynamic3DTextLabelText(fam_lable[i], -1, famtext);
			}
			family_setting(playerid);
		}
		case D_FAMILY_SET_RANK: {
			if(!response) return DeletePVar(playerid,"fam_rank"),family_dialog(playerid);
			if(!PI[playerid][pFamily]) return 1;
			new fam = PI[playerid][pFamily]-1;
			UpdateFamily(fam+1,"invite",listitem + 1);
			switch(GetPVarInt(playerid,"fam_rank"))
			{
				case 0: gFamily[fam][famInvRang] = listitem + 1,UpdateFamily(fam+1,"invite",listitem + 1);
				case 1: gFamily[fam][famUninvRang] = listitem + 1,UpdateFamily(fam+1,"uninvite",listitem + 1);
				case 2: gFamily[fam][famGiveRang] = listitem + 1,UpdateFamily(fam+1,"giverank",listitem + 1);
				case 3: gFamily[fam][famSklad] = listitem + 1,UpdateFamily(fam+1,"sklad",listitem + 1);
			    default: return 1;
			}

			DeletePVar(playerid,"fam_rank");
			family_setting(playerid);
			return 1;
		}
		case D_FAMILY_ERANK_1: {
			if(!response) return family_dialog(playerid);
			if(!PI[playerid][pFamily]) return 1;
			SetPVarInt(playerid,"edit_frank",listitem);
			D(playerid, D_FAMILY_ERANK_2, DSI, ""P"Смена названия ранга", "\n\n"W"Введите новое название ранга:\n\n", "Изменить", "Отмена");
			return 1;
		}
		case D_FAMILY_ERANK_2: {
			if(!response) return family_dialog(playerid);
			if(!PI[playerid][pFamily]) return 1;
			new fam = PI[playerid][pFamily]-1;
			if(strlen(inputtext) <= 1 || strlen(inputtext) >= 24) return D(playerid, D_FAMILY_ERANK_2, DSI, ""P"Смена названия ранга", "\n\n"W"Введите новое название ранга:\n\n"NO"*"G" От 2 и до 24 симолов\n\n", "Изменить", "Отмена");
			string_replace(inputtext, "'", ' ');
			new slot = GetPVarInt(playerid, "edit_frank");

			new string[128];
			format(string,sizeof(string),"Ранг №%d переименован с %s на %s",slot+1,GetFamName(fam,slot+1),inputtext);
			SendClientMessage(playerid,FamilyColorG[gFamily[fam][famColor]],string);

			strmid(FamRanks[fam][slot], inputtext, 0, strlen(inputtext));
			SavefRank(slot+1,fam);
			family_setting(playerid);
			return 1;
		}
		case D_FAMILY_INFO: {
  			if(response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
		}
		case D_FAMILY_NAME: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			if(!strlen(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 30) {
				D(playerid,D_FAMILY_NAME,DSI, ""P"Название","\n\n"W"Введите новое название семьи:\n\n","Изменить","Отмена");
				return true;
			}
			if(is_text_invalid(inputtext)) {
				D(playerid,D_FAMILY_NAME,DSI, ""P"Название","\n\n"W"Введите новое название семьи:\n"NO"*"G" Присутствуют запрещенные символы\n\n","Изменить","Отмена");
				return true;
			}
			new query[128];
			mysql_format(connects, query, sizeof(query), "SELECT * FROM family WHERE name = '%e'", inputtext);
			new Cache:result = mysql_query(connects, query);
			if(cache_num_rows()) {
				ErrorMessage(playerid, "Семья с таким именем уже существует");
				cache_delete(result);
				return 1;
			}
			cache_delete(result);
			new fam = PI[playerid][pFamily]-1;
			strmid(gFamily[fam][famName],inputtext,0,strlen(inputtext),strlen(inputtext)+1);
			query = "";
			mysql_format(connects,  query, sizeof(query), "UPDATE `family` SET name = '%e' WHERE id = '%d'", gFamily[fam][famName],gFamily[fam][famID]);
			mysql_tquery(connects, query, "","");

			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[playerid][pFamily] != PI[i][pFamily]) continue;
				new famtext[50];
				format(famtext,sizeof(famtext),"{%s}%s",FamilyColor[gFamily[PI[i][pFamily]-1][famColor]],gFamily[PI[i][pFamily]-1][famName]);
				UpdateDynamic3DTextLabelText(fam_lable[i], -1, famtext);
			}
			new string[128];
			format(string,sizeof(string),"Вы успешно изменили название Вашей семье на - "W"%s",gFamily[fam][famName]);
			SendClientMessage(playerid,FamilyColorG[gFamily[fam][famColor]],string);
			return 1;
		}
		case D_FAMILY_STORE: {
			if(!response) {
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			switch(listitem) {
				case 0: D(playerid,D_FAMILY_STORE_1,DSL,""P"Деньги",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 1: D(playerid,D_FAMILY_STORE_1,DSL,""P"Наркотики",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 2: D(playerid,D_FAMILY_STORE_1,DSL,""P"Боеприпасы",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 3: D(playerid,D_FAMILY_STORE_1,DSL,""P"Бронежилеты",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 4: D(playerid,D_FAMILY_STORE_1,DSL,""P"Аптечки",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 5: D(playerid,D_FAMILY_STORE_1,DSL,""P"Маски",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 6: D(playerid,D_FAMILY_STORE_1,DSL,""P"Канистры с бензином",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
				case 7: D(playerid,D_FAMILY_STORE_1,DSL,""P"Ремкомплекты",""P"1."W" Взять\n"P"2."W" Положить","Выбрать","Отмена");
			}
			SetPVarInt(playerid,"select_famscore",listitem);
		}
		case D_FAMILY_STORE_1: {
			if(!response) {
				DeletePVar(playerid,"select_famscore");
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new fam = PI[playerid][pFamily]-1;
			new name_upgrade[8][19] = {"денег","наркотиков","боеприпасов","бронежилетов","аптечек","масок","канистр с бензином","ремкомплектов"};
			new lvl,colvo,all_1,all_2;
			switch(GetPVarInt(playerid,"select_famscore")) {
				case 0: {
					colvo = gFamily[fam][famMoney];
					lvl = FamilyMoneyUpdate[gFamily[fam][famMoneyMax]];
					all_2 = PI[playerid][pCash];
				}
				case 1: {
					colvo = gFamily[fam][famDrugs];
					lvl = FamilyDrugsUpdate[gFamily[fam][famDrugsMax]];
					all_1 = vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs];
					all_2 = PI[playerid][pDrugs];
				}
				case 2: {
					colvo = gFamily[fam][famMats];
					lvl = FamilyMatsUpdate[gFamily[fam][famMatsMax]];
					all_1 = vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats];
					all_2 = PI[playerid][pMats];
				}
				case 3: {
					colvo = gFamily[fam][famArmour];
					lvl = FamilyArmourUpdate[gFamily[fam][famArmourMax]];
				}
				case 4: {
					colvo = gFamily[fam][famHealth];
					lvl = FamilyHealthUpdate[gFamily[fam][famHealthMax]];
					all_1 = vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit];
					all_2 = PI[playerid][pMedKit];
				}
				case 5: {
					colvo = gFamily[fam][famMask];
					lvl = FamilyMaskUpdate[gFamily[fam][famMaskMax]];
					all_1 = vip_status[PI[playerid][pVips]][vip_mask]-PI[playerid][pMask];
					all_2 = PI[playerid][pMask];
				}
				case 6: {
					colvo = gFamily[fam][famFuel];
					lvl = FamilyFuelUpdate[gFamily[fam][famFuelMax]];
					all_1 = vip_status[PI[playerid][pVips]][vip_fuel]-PI[playerid][pFuel];
					all_2 = PI[playerid][pFuel];
				}
				case 7: {
					colvo = gFamily[fam][famRemp];
					lvl = FamilyRempUpdate[gFamily[fam][famRempMax]];
					all_1 = 5-PI[playerid][pInstrument];
					all_2 = PI[playerid][pInstrument];
				}
			}
			switch(listitem) {
				case 0: {
					if(gFamily[fam][famSklad] > PI[playerid][pFamRank]) return ErrorMessage(playerid,"Ваш ранг недостаточен");
					if(GetPVarInt(playerid,"select_famscore") != 0 && GetPVarInt(playerid,"select_famscore") != 3) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество "GREEN"%s"W", которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",name_upgrade[GetPVarInt(playerid,"select_famscore")],colvo,lvl,all_1);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					else {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество "GREEN"%s"W", которое хотите взять:\nСостояние склада: "P"%d / %d"W"\n\n",name_upgrade[GetPVarInt(playerid,"select_famscore")],colvo,lvl);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
				}
				case 1: {
					if(GetPVarInt(playerid,"select_famscore") != 3) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество "GREEN"%s"W", которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно %s: "P"%d\n\n",name_upgrade[GetPVarInt(playerid,"select_famscore")],colvo,lvl,name_upgrade[GetPVarInt(playerid,"select_famscore")],all_2);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					else {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество "GREEN"%s"W", которое хотите положить:\nСостояние склада: "P"%d / %d"W"\n\n",name_upgrade[GetPVarInt(playerid,"select_famscore")],colvo,lvl);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
				}
			}
		}
		case D_FAMILY_STORE_2: {
			if(!response) {
				DeletePVar(playerid,"select_famscore");
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new fam = PI[playerid][pFamily]-1;
			if(gFamily[fam][famSklad] > PI[playerid][pFamRank]) return ErrorMessage(playerid,"Ваш ранг недостаточен");
			new col = strval(inputtext);
			switch(GetPVarInt(playerid,"select_famscore")) {
				case 0: {
					if(col < 1) {
						new string[170];
						format(string,sizeof(string),"\n\n"W"Введите количество денег, "W"которое хотите взять:\nСостояние склада: "P"%d / %d\n\n",gFamily[fam][famMoney],FamilyMoneyUpdate[gFamily[fam][famMoneyMax]]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famMoney] < col) {
						new string[170];
						format(string,sizeof(string),"\n\n"W"Введите количество денег, "W"которое хотите взять:\nСостояние склада: "P"%d / %d\n\n"NO"*"G" На складе семьи недостаточно средств",gFamily[fam][famMoney],FamilyMoneyUpdate[gFamily[fam][famMoneyMax]]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					gFamily[fam][famMoney] -= col;
					UpdateFamily(fam+1,"money",gFamily[fam][famMoney]);
					GiveMoney(playerid,col,"снял(а) со склада семьи");
					SendOk(playerid,"Вы взяли деньги со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} денег",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 1: {
					if(col < 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famDrugs] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно наркотиков",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pDrugs]+ col > vip_status[PI[playerid][pVips]][vip_drugs]) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много наркотиков",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],vip_status[PI[playerid][pVips]][vip_drugs]-PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					gFamily[fam][famDrugs] -= col;
					UpdateFamily(fam+1,"drugs",gFamily[fam][famDrugs]);
					PI[playerid][pDrugs] +=col;
					UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
					SendOk(playerid,"Вы взяли наркотики со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} наркотиков",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 2: {
					if(col < 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famMats] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно боеприпасов",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pMats]+ col > vip_status[PI[playerid][pVips]][vip_mats]) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много боеприпасов",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],vip_status[PI[playerid][pVips]][vip_mats]-PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}

					gFamily[fam][famMats] -= col;
					UpdateFamily(fam+1,"mats",gFamily[fam][famMats]);
					PI[playerid][pMats] +=col;
					UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);
					SendOk(playerid,"Вы взяли боеприпасы со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} боеприпасов",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 3: {
					if(col != 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество бронежилетов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d\n\n",gFamily[fam][famArmour],FamilyArmourUpdate[gFamily[fam][famArmourMax]]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famArmour] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество бронежилетов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d\n\n"NO"*"G" На складе семьи недостаточно бронежилетов",gFamily[fam][famArmour],FamilyArmourUpdate[gFamily[fam][famArmourMax]]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					SetPlayerArmour(playerid,100);
					gFamily[fam][famArmour] -= col;
					UpdateFamily(fam+1,"armour",gFamily[fam][famArmour]);
					SendOk(playerid,"Вы взяли бронежилет со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} бронежилет",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 4: {
					if(col < 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famHealth] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно аптечек",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pMedKit]+ col > vip_status[PI[playerid][pVips]][vip_heal]) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много аптечек",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],vip_status[PI[playerid][pVips]][vip_heal]-PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					gFamily[fam][famHealth] -= col;
					UpdateFamily(fam+1,"health",gFamily[fam][famHealth]);
					PI[playerid][pMedKit]+=col;
					UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
					SendOk(playerid,"Вы взяли аптечки со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} аптечек",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 5: {
					if(col < 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMask]],vip_status[PI[playerid][pVips]][vip_mask]-PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famMask] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно масок",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMask]],vip_status[PI[playerid][pVips]][vip_mask]-PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pMask]+ col > vip_status[PI[playerid][pVips]][vip_mask]) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много масок",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMask]],vip_status[PI[playerid][pVips]][vip_mask]-PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}

					gFamily[fam][famMask] -= col;
					UpdateFamily(fam+1,"mask",gFamily[fam][famMask]);
					PI[playerid][pMask] +=col;
					UpdatePlayerData(playerid,"pMask",PI[playerid][pMask]);
					SendOk(playerid,"Вы взяли маски со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} масок",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 6: {
					if(col != 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],vip_status[PI[playerid][pVips]][vip_fuel]-PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famFuel] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно канистр с бензином",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],vip_status[PI[playerid][pVips]][vip_fuel]-PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pFuel]+ col > vip_status[PI[playerid][pVips]][vip_fuel]) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много канистр с бензином",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],vip_status[PI[playerid][pVips]][vip_fuel]-PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					gFamily[fam][famFuel] -= col;
					UpdateFamily(fam+1,"fuel",gFamily[fam][famFuel]);
					PI[playerid][pFuel]+=col;
					UpdatePlayerData(playerid,"pFuel",PI[playerid][pFuel]);
					SendOk(playerid,"Вы взяли канистру с бензином со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} канистру с бензином",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 7: {
					if(col < 1) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],5-PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(gFamily[fam][famRemp] < col) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" На складе семьи недостаточно ремкомплектов",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],5-PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					if(PI[playerid][pInstrument]+ col > 5) {
						new string[240];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите взять:\nСостояние склада: "P"%d / %d"W"\nВ карман поместится: "P"%d\n\n"NO"*"G" Вы не можете хранить у себя так много ремкомплектов",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],5-PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_2,DSI, ""P"Сбережения",string,"Взять","Отмена");
					}
					gFamily[fam][famRemp] -= col;
					UpdateFamily(fam+1,"remp",gFamily[fam][famRemp]);
					PI[playerid][pInstrument]+=col;
					UpdatePlayerData(playerid,"pInstr",PI[playerid][pInstrument]);
					SendOk(playerid,"Вы взяли ремкоплекты со склада семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} взял(а) "W"%d{%s} ремкомплектов",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
			}
		}
		case D_FAMILY_STORE_3: {
			if(!response) {
				DeletePVar(playerid,"select_famscore");
				if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
		    	family_dialog(playerid);
		    	return true;
			}
			new fam = PI[playerid][pFamily]-1;
			new col = strval(inputtext);
			switch(GetPVarInt(playerid,"select_famscore")) {
				case 0: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество денег, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно денег: "P"%d\n\n",gFamily[fam][famMoney],FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],PI[playerid][pCash]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pCash]- col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество денег, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно денег: "P"%d\n\n"NO"*"G" У Вас недостаточно средств",gFamily[fam][famMoney],FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],PI[playerid][pCash]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famMoney]+col > FamilyMoneyUpdate[gFamily[fam][famMoneyMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество денег, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно денег: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famMoney],FamilyMoneyUpdate[gFamily[fam][famMoneyMax]],PI[playerid][pCash]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famMoney] += col;
					UpdateFamily(fam+1,"money",gFamily[fam][famMoney]);
					GiveMoney(playerid,-col,"пополнил(а) склад семьи");
					SendOk(playerid,"Вы положили деньги на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} денег на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 1: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно наркотиков: "P"%d\n\n",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pDrugs]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно наркотиков: "P"%d\n\n"NO"*"G" У Вас недостаточно наркотиков",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famDrugs]+col > FamilyDrugsUpdate[gFamily[fam][famDrugsMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество наркотиков, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно наркотиков: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famDrugs],FamilyDrugsUpdate[gFamily[fam][famDrugsMax]],PI[playerid][pDrugs]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famDrugs] += col;
					UpdateFamily(fam+1,"drugs",gFamily[fam][famDrugs]);
					PI[playerid][pDrugs]-=col;
					UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
					SendOk(playerid,"Вы положили наркотики на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} наркотиков на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 2: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно боеприпасов: "P"%d\n\n",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pMats]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно боеприпасов: "P"%d\n\n"NO"*"G" У Вас недостаточно боеприпасов",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famMats]+col > FamilyMatsUpdate[gFamily[fam][famMatsMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество боеприпасов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно боеприпасов: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famMats],FamilyMatsUpdate[gFamily[fam][famMatsMax]],PI[playerid][pMats]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famMats] += col;
					UpdateFamily(fam+1,"mats",gFamily[fam][famMats]);
					PI[playerid][pMats]-=col;
					UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);
					SendOk(playerid,"Вы положили боеприпасы на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} боеприпасов на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 3: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество бронежилетов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d\n\n",gFamily[fam][famArmour],FamilyArmourUpdate[gFamily[fam][famArmourMax]]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					new Float:arm;
					GetPlayerArmour(playerid, arm);
					if(arm < 80) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество бронежилетов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d\n\n"NO"*"G" У Вас нет бронежилета/он сильно изношен",gFamily[fam][famArmour],FamilyArmourUpdate[gFamily[fam][famArmourMax]]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famArmour]+col > FamilyArmourUpdate[gFamily[fam][famArmourMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество бронежилетов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famArmour],FamilyArmourUpdate[gFamily[fam][famArmourMax]]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famArmour] += col;
					UpdateFamily(fam+1,"armour",gFamily[fam][famArmour]);
					SendOk(playerid,"Вы положили бронежилет на склад семьи");
					SetPlayerArmour(playerid, 0);
					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} бронежилет на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 4: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно аптечек: "P"%d\n\n",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pMedKit]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно аптечек: "P"%d\n\n"NO"*"G" У Вас недостаточно аптечек",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famHealth]+col > FamilyHealthUpdate[gFamily[fam][famHealthMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество аптечек, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно аптечек: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famHealth],FamilyHealthUpdate[gFamily[fam][famHealthMax]],PI[playerid][pMedKit]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famHealth] += col;
					UpdateFamily(fam+1,"health",gFamily[fam][famHealth]);
					PI[playerid][pMedKit]-=col;
					UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
					SendOk(playerid,"Вы положили аптечки на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} аптечек на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 5: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно масок: "P"%d\n\n",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMaskMax]],PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pMask]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно масок: "P"%d\n\n"NO"*"G" У Вас недостаточно масок",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMaskMax]],PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famMask]+col > FamilyMaskUpdate[gFamily[fam][famMaskMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество масок, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно масок: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famMask],FamilyMaskUpdate[gFamily[fam][famMaskMax]],PI[playerid][pMask]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famMask] += col;
					UpdateFamily(fam+1,"mask",gFamily[fam][famMask]);
					PI[playerid][pMask]-=col;
					UpdatePlayerData(playerid,"pMask",PI[playerid][pMask]);
					SendOk(playerid,"Вы положили маски на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} масок на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 6: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно канистр с бензином: "P"%d\n\n",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pFuel]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно канистр с бензином: "P"%d\n\n"NO"*"G" У Вас недостаточно канистр с бензином",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famFuel]+col > FamilyFuelUpdate[gFamily[fam][famFuelMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество канистр с бензином, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно канистр с бензином: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famFuel],FamilyFuelUpdate[gFamily[fam][famFuelMax]],PI[playerid][pFuel]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famFuel] += col;
					UpdateFamily(fam+1,"fuel",gFamily[fam][famFuel]);
					PI[playerid][pFuel]-=col;
					UpdatePlayerData(playerid,"pFuel",PI[playerid][pFuel]);
					SendOk(playerid,"Вы положили канистру с бензином на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} канистр с бензином на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
				case 7: {
					if(col < 1) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно ремкомплектов: "P"%d\n\n",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(PI[playerid][pInstrument]-col < 0) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"nДоступно ремкомплектов: "P"%d\n\n"NO"*"G" У Вас недостаточно ремкомплектов",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					if(gFamily[fam][famRemp]+col > FamilyRempUpdate[gFamily[fam][famRempMax]]) {
						new string[230];
						format(string,sizeof(string),"\n\n"W"Введите количество ремкомплектов, "W"которое хотите положить:\nСостояние склада: "P"%d / %d"W"\nДоступно ремкомплектов: "P"%d\n\n"NO"*"G" На складе семьи недостаточно места",gFamily[fam][famRemp],FamilyRempUpdate[gFamily[fam][famRempMax]],PI[playerid][pInstrument]);
						return D(playerid,D_FAMILY_STORE_3,DSI, ""P"Сбережения",string,"Положить","Отмена");
					}
					gFamily[fam][famRemp] += col;
					UpdateFamily(fam+1,"remp",gFamily[fam][famRemp]);
					PI[playerid][pInstrument]-=col;
					UpdatePlayerData(playerid,"pInstr",PI[playerid][pInstrument]);
					SendOk(playerid,"Вы положили ремкоплекты на склад семьи");

					new string[144];
					format(string,sizeof(string),"[FAMILY] "W"%s{%s} положил(а) "W"%d{%s} ремкоплеков на склад семьи",player_name[playerid],FamilyColor[gFamily[fam][famColor]],col,FamilyColor[gFamily[fam][famColor]]);
					FamMSG(fam+1,string);
				}
			}
		}
		case D_BUY_SKIN: {
			if(!response) return true;
			new houseid = PI[playerid][pHouse]-1;
			if(!PI[playerid][pHouse] || ((houseid+1) > 0 && !GetString(player_name[playerid],gHouses[houseid][houseOwner]))) D(playerid,D_BUY_SKIN_2,DSM, ""P"Покупка одежды",""W"У Вас нет шкафа для одежды.\nЕсли Вы купите эту одежду, то она "NO"заменит"W" Вашу текущую\n\n"P"Вы все равно хотите купить выбранную одежду?","Да","Нет");
			else {
				new skin = ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][0];
				new price = ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1];
				new id = TI[playerid][tSelectedBusinessID];
				new slot=-1;
				for(new i;i<3;i++) {
					if(skin == gHouses[houseid][houseSkin][i]) return ErrorMessage(playerid,"У Вас уже есть эта одежда в шкафу");
					if(!gHouses[houseid][houseSkin][i]) {slot = i; break;}
				}
				if(slot == -1) return D(playerid,D_BUY_SKIN_2,DSM, ""P"Покупка одежды",""W"У Вас недостаточно места в шкафу.\nЕсли Вы купите эту одежду, то она "NO"заменит"W" Вашу текущую\n\n"P"Вы все равно хотите купить выбранную одежду?","Да","Нет");

				if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
					new seller = floatround(price/100*vip_status[PI[playerid][pVips]][vip_chose]);
					if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
					GiveMoney(playerid,-(price-seller),"покупка скина");
				}
				else {
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(price/100*BonusInfo[act_buyskin]);
						if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
						GiveMoney(playerid,-(price-seller),"покупка скина");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(price/100*BonusInfo[act_buyskin]);
						if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
						GiveMoney(playerid,-(price-seller),"покупка скина");
					}
				    else {
				    	if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"Недостаточно средств");
				    	GiveMoney(playerid,-price,"покупка скина");
				    }
				}
	 			if(QuestProgress[playerid][9] < 1 && AcceptQuest[playerid][9] != 0)
			 	{
				 	QuestProgress[playerid][9] ++,save_quest(playerid,9);
					D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно приобрели новую одежду. Данное задание можно завершить и забрать за него награду","Закрыть","");
					NextStapQI(playerid,9);
				}
				if(gBusiness[id][bizzProduct] - floatround((price / 150) * 5) / 10 > 0) {
					bizz_pay(id,floatround(price * 0.1647));
					gBusiness[id][bizzProduct] -= floatround((price / 150) * 5) / 10;
				}
				UpdateBusinessText(id);
				SaveBusiness(id);
				gHouses[houseid][houseSkin][slot] = skin;
				UpdateHouseDress(houseid);
				if(mysql_errno()) return ErrorMessage(playerid,"Ошибка #11");

				SendOk(playerid,"Одежда была помещена в Ваш шкаф");
				if(GetPVarInt(playerid, "curskin") == PI[playerid][pFracSkin] || PI[playerid][pMember]) A_SetPlayerSkin(playerid, GetPVarInt(playerid, "curskin"));
				else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
				cancel_skin(playerid);
			}
		}
		case D_BUY_SKIN_2: {
			if(!response) return true;
			new houseid = PI[playerid][pHouse]-1;
			new skin = ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][0];
			new price = ped_buyclothes[GetPVarInt(playerid,"join_ped_item")][1];
			new id = TI[playerid][tSelectedBusinessID];
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(price/100*vip_status[PI[playerid][pVips]][vip_chose]);
				if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
				GiveMoney(playerid,-(price-seller),"покупка скина");
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(price/100*BonusInfo[act_buyskin]);
					if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
					GiveMoney(playerid,-(price-seller),"покупка скина");
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(price/100*BonusInfo[act_buyskin]);
					if(GetPlayerMoneyEx(playerid) < (price-seller)) return ErrorMessage(playerid,"Недостаточно средств");
					GiveMoney(playerid,-(price-seller),"покупка скина");
				}
			    else {
			    	if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"Недостаточно средств");
			    	GiveMoney(playerid,-price,"покупка скина");
				}
			}
			if(QuestProgress[playerid][9] < 1 && AcceptQuest[playerid][9] != 0)
			{
				QuestProgress[playerid][9] ++,save_quest(playerid,9);
				D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно приобрели новую одежду. Данное задание можно завершить и забрать за него награду","Закрыть","");
				NextStapQI(playerid,9);
			}
			if(gBusiness[id][bizzProduct] - floatround((price / 150) * 5) / 10 > 0) {
				bizz_pay(id,floatround(price * 0.1647));
				gBusiness[id][bizzProduct] -= floatround((price / 150) * 5) / 10;
			}
			UpdateBusinessText(id);
			SaveBusiness(id);
			if(houseid+1) {
			    if(GetString(player_name[playerid],gHouses[houseid][houseOwner])) {
					new slot=-1, cnt;
					for(new i;i<3;i++) {
						if(gHouses[houseid][houseSkin][i]) cnt++;
						if(gHouses[houseid][houseSkin][i] == PI[playerid][pSkin]) slot = i;
					}
					if(cnt >= 3) {
						if(slot == -1) return ErrorMessage(playerid,"Ошибка при нахождении заменямого скина в шкафу");
						gHouses[houseid][houseSkin][slot] = skin;
						UpdateHouseDress(houseid);
					}
				}
			}
			if(UpdatePlayerData(playerid,"Skin",skin)) return ErrorMessage(playerid,"Ошибка #10");

			PI[playerid][pSkin] = skin;
			SetPVarInt(playerid,"ChangingSkin",0);
			if(GetPVarInt(playerid, "curskin") == PI[playerid][pFracSkin] || PI[playerid][pMember]) A_SetPlayerSkin(playerid, GetPVarInt(playerid, "curskin"));
			else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
			cancel_skin(playerid);
		}
		case D_AUTOSCHOOL_1: {
			if(!response) return DeletePVar(playerid,"use_test");
			new question = TestASKMassive[playerid][0];
			return D(playerid,D_AUTOSCHOOL_2,QueInfo[question][dDialog],QueInfo[question][dQuestion],QueInfo[question][dAnswers],"Далее","");
		}
		case D_AUTOSCHOOL_2: {
			new que, question;
			que = GetPVarInt(playerid,"pTestQNumber");
			question = TestASKMassive[playerid][que];
			if(QueInfo[question][dSuccesQwe] != -1 && listitem != QueInfo[question][dSuccesQwe]) SetPVarInt(playerid,"error_test",GetPVarInt(playerid,"error_test")+1);
			SetPVarInt(playerid,"pTestQNumber",GetPVarInt(playerid,"pTestQNumber")+1);
			que = GetPVarInt(playerid,"pTestQNumber");
			if(que < 7) {
				question = TestASKMassive[playerid][que];
				D(playerid,D_AUTOSCHOOL_2,QueInfo[question][dDialog],QueInfo[question][dQuestion],QueInfo[question][dAnswers],"Далее","");
			}
			else {
				if(GetPVarInt(playerid,"error_test") > 2) {
					new string[156];
					format(string,sizeof(string),""NO"Экзамен завален!\n\n"W"Ошибок допущено: "NO"%d\nСоветуем подготовиться лучше!",GetPVarInt(playerid,"error_test"));
					D(playerid,DIALOG_NONE,DSM, ""P"Экзамен",string,"Закрыть","");
					DeletePVar(playerid,"error_test");
					DeletePVar(playerid,"use_test");
					DeletePVar(playerid,"pTestQNumber");
					TI[playerid][tAutoSchool] = 0;
					return 1;
				}
				else {
					if(!PI[playerid][pVips] || PI[playerid][pVips] == VIP_SILVER) {
						D(playerid,DIALOG_NONE,DSM, ""P"Экзамен",""GREEN"Поздравляем с успешной сдачей теоретической части!\n\n\
												"W"Для прохождения практической части займите свободный автомобиль на парковке АвтоШколы","Хорошо","");


						switch(random(6))
						{
	    					case 0: EnableGPSForPlayer(playerid, -2068.563, -84.370, 34.825); // АШ кар
							case 1: EnableGPSForPlayer(playerid, -2072.843, -84.370, 34.822); // АШ кар
							case 2: EnableGPSForPlayer(playerid, -2077.122, -84.370, 34.822); // АШ кар
							case 3: EnableGPSForPlayer(playerid, -2081.402, -84.370, 34.822); // АШ кар
							case 4: EnableGPSForPlayer(playerid, -2085.824, -84.397, 34.816); // АШ кар
							case 5: EnableGPSForPlayer(playerid, -2089.961, -84.370, 34.822); // АШ кар
							case 6: EnableGPSForPlayer(playerid, -2094.961, -84.324, 34.812); // АШ кар
						}
						SetPVarInt(playerid,"WaitExam", true);
						SetPVarInt(playerid,"pWaitingExam", true);
						DeletePVar(playerid,"use_test");
					}
					else {
						SendClientMessage(playerid,CGOLD,"Поздравляем с получением водительского удостоверения");
						lic[playerid][0] = 1;
						UpdateLicenses(playerid);
						DeletePVar(playerid,"LessonSlot");
						DeletePVar(playerid,"WaitExam");
						DeletePVar(playerid,"pWaitingExam");
						DisablePlayerRaceCheckpoint(playerid);
						DisablePlayerCheckpoint(playerid);

						if(QuestProgress[playerid][10] < 1 && AcceptQuest[playerid][10] != 0) {
							QuestProgress[playerid][10] ++,save_quest(playerid,10);
							D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно получили вод. права. Данное задание можно завершить и забрать за него награду","Закрыть","");
							NextStapQI(playerid,10);
						}

					}
				}
			}
		}
		case D_AUTOSCHOOL_3: {
			if(!response) return 1;
			new Float:pos[3];
			GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
			SetPVarFloat(playerid,"pos_x_autos",pos[0]);
			SetPVarFloat(playerid,"pos_y_autos",pos[1]);
			SetPVarFloat(playerid,"pos_z_autos",pos[2]);
			if(TI[playerid][tAutoSchool] == 2) {
				car_autoschool[playerid] = A_CreateVehicle(487, -2227.2703, 2327.0129, 7.6348, 0.0000, -1, -1, -1,VEHICLE_TYPE_AUTOSCHOOL);
				SetPlayerVirtualWorld(playerid,playerid+1);
				SetVehicleVirtualWorld(car_autoschool[playerid],playerid+1);
				SetPlayerInterior(playerid,0);
				PutPlayerInVehicle(playerid, car_autoschool[playerid], 0);
				SetPlayerRaceCheckpoint(playerid, 3, AutoCPMav[0][0], AutoCPMav[0][1], AutoCPMav[0][2], AutoCPMav[1][0], AutoCPMav[1][1], AutoCPMav[1][2], 5.0);
			}
			else if(TI[playerid][tAutoSchool] == 3) {
				car_autoschool[playerid] = A_CreateVehicle(452, -2212.9558, 2408.5977, 1.4924, 45.0000, -1, -1, -1,VEHICLE_TYPE_AUTOSCHOOL);
				SetPlayerVirtualWorld(playerid,playerid+1);
				SetVehicleVirtualWorld(car_autoschool[playerid],playerid+1);
				SetPlayerInterior(playerid,0);
				PutPlayerInVehicle(playerid, car_autoschool[playerid], 0);
				SetPlayerRaceCheckpoint(playerid, 0, AutoCPBoat[0][0], AutoCPBoat[0][1], AutoCPBoat[0][2], AutoCPBoat[1][0], AutoCPBoat[1][1], AutoCPBoat[1][2], 4.5);
			}
			return 1;
		}
		case D_BANK: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new string[300], str[120];
					string = ""P"№ счёта\t"P"Название\n"ORANGE"-\tОсновной счёт\n";
					for(new i;i < score_number[playerid];i++) {
						format(str, sizeof(str),""ORANGE"%i\t"W"%s\n",gBanks[playerid][bankNumber][i],score_name[playerid][i]), strcat(string, str);
					}
					return D(playerid,D_BANK_ACTIVE,DSTH,"Активные счета",string, "Выбрать", "Назад");
				}
				case 1: {
				    if(score_number[playerid] == 3) return ErrorMessage(playerid, "Максимальное количество счетов - 3");
				    return D(playerid,D_BANK_OPEN,DSI, ""P"Открытие нового счета","\n\n"W"Введите название для нового лицевого счёта:\n\n","Открыть","Отмена");
				}
			}
		}
		case D_BANK_ACTIVE: {
			if(!response) return bank_dialog(playerid);
			if(listitem == 0) return D(playerid,D_BANK_GLOBAL,DSL,""P"Основной счёт",""P"1."W" Информация о счёте\n"P"2."W" Пополнить счёт\n"P"3."W" Выдача наличных","Выбрать","Назад");
			SetPVarInt(playerid, "select_score",listitem-1);
			return D(playerid,D_BANK_AUTORISATION,DSI,""P"Авторизация","\n\n"W"Для получения доступа к счёту введите "P"PIN-код:\n\n","Ввод","Назад");
		}
		case D_BANK_OPEN: {
			if(!response) return bank_dialog(playerid);
			if(strlen(inputtext) < 1 || strlen(inputtext) > 12) return D(playerid,D_BANK_OPEN,DSI, ""P"Открытие нового счета","\n\n"W"Введите название для нового лицевого счёта:\n\n"NO"*"G" Максимальная длина 12 символов\n\n","Открыть","Отмена");
            new query[150];
			strmid(score_name[playerid][score_number[playerid]], inputtext, 0, strlen(inputtext), 20);
			strmid(gBanks[playerid][bankOwner][score_number[playerid]], player_name[playerid], 0, strlen(player_name[playerid]), 24);
			gBanks[playerid][bankPassword][score_number[playerid]] = 0000;
			gBanks[playerid][bankBalance][score_number[playerid]] = 0;
			mysql_format(connects, query, sizeof(query),"INSERT INTO `bank` (`name`,`owner`,`balance`,`code`) VALUES ('%e','%e','0','0000')",score_name[playerid][score_number[playerid]], player_name[playerid]);
			mysql_tquery(connects,query,"","");
			score_number[playerid]++;
			mysql_format(connects,query,sizeof(query),"SELECT * FROM `bank` WHERE BINARY `owner` = '%s'", player_name[playerid]);
    		mysql_tquery(connects,query, "update_bank", "i", playerid);
			D(playerid,DIALOG_NONE,DSM, ""P"Счёт открыт",
				""W"Поздравляем! С открытием нового счёта в банке.\n\n\
				PIN-код по умолчанию: "P"0000\n\
				"W"Для защиты денежных сбережений, советуем сменить PIN-код на более сложный!","Готово","");
			return 1;
		}
    	case D_BANK_AUTORISATION: {
	    	if(!response) return bank_dialog(playerid);
			if(strlen(inputtext) != 4) return D(playerid,D_BANK_AUTORISATION,DSI,""P"Авторизация","\n\n"W"Для получения доступа к счёту введите "O"PIN-код:\n\n"NO"*"G" PIN-код должен состоять из 4 цифр\n\n","Ввод","Назад");
			if(gBanks[playerid][bankPassword][GetPVarInt(playerid, "select_score")] == strval(inputtext)) return bank_score(playerid);
			else D(playerid,D_BANK_AUTORISATION,DSI,""P"Авторизация","\n\n"W"Для получения доступа к счёту введите "P"PIN-код:\n\n"NO"*"G" PIN-код не верный\n\n","Ввод","Назад");
	    }
		case D_BANK_LIST: {
			if(response) {
				return D(playerid,D_BANK_TOP,DSL, ""P"Список операций", ""P"1."W" Информация о счёте\n"P"2."W" Пополнить счёт\n"P"3."W" Выдача наличных\n"P"4."W" Перевести на другой счёт\n"P"5."W" Список операций\n"P"6."W" Переименовать счёт\n"P"7."W" Изменить PIN-код", "Выбрать", "Назад");
			}
		}
		case D_BANK_GLOBAL_LIST: {
			if(response) {
				return D(playerid,D_BANK_GLOBAL,DSL,""P"Основной счёт",""P"1."W" Информация о счёте\n"P"2."W" Пополнить счёт\n"P"3."W" Выдача наличных","Выбрать","Отмена");
			}
		}
     	case D_BANK_TOP: {
			if(!response) return bank_dialog(playerid);
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Счёт:\t\t\t"P"№ %i\n\
								"W"Название:\t\t"P"%s\n\
								"W"Баланс:\t\t"GREEN"$%i\n";
					new string[sizeof(f_str) +1 + (-2 + 8) + (-2 + 13)+ (-2 + 11)];
					format(string, sizeof(string), f_str,gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")],score_name[playerid][GetPVarInt(playerid, "select_score")],gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")]);
					return D(playerid,D_BANK_LIST,DSM, ""P"Информация",string,"Назад","");
				}
				case 1: D(playerid,D_BANK_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить на банковский счёт:\n\n","Положить","Назад");
				case 2: D(playerid,D_BANK_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять с банковского счёта:\n\n","Снять","Назад");
				case 3: {
					new Float:percent;
					switch(GetPlayerVirtualWorld(playerid)) {
						case 46: percent = FuncBizz[8][funcbPercent2];
						case 47: percent = FuncBizz[9][funcbPercent2];
						case 48: percent = FuncBizz[10][funcbPercent2];
						default: {
							switch(GetPVarInt(playerid, "bank_donate")) {
								case 0: percent = FuncBizz[8][funcbPercent2];
								case 1: percent = FuncBizz[9][funcbPercent2];
								case 2: percent = FuncBizz[10][funcbPercent2];
								default: return 1;
							}
						}
					}
					static const f_str[] = "\n\n"W"Введите номер счёта, на который хотите перевести деньги:\nВнимание: комиссия за перевод: "ORANGE"%.1f\n\n";
					new string[sizeof(f_str) +1 + (-2 + 4)];
					format(string,sizeof(string),f_str,percent);
					return D(playerid,D_BANK_TRANSFER_ONE,DSI, ""P"Перевод средств",string,"Далее","Назад");
				}
				case 4: {
					new query[150];
					mysql_format(connects,query, sizeof(query), "SELECT * FROM `history` WHERE BINARY `number_1` = '%d' or `number_2` = '%d' ORDER BY `date` DESC LIMIT 10", gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")], gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")]);
					return mysql_tquery(connects, query, "OnPlayerBankOperations", "i", playerid);
				}
				case 5: D(playerid,D_BANK_CHANGE_NAME,DSI, ""P"Переименовать счёт","\n\n"W"Введите новое название Вашего счёта:\n\n","Изменить","Назад");
				case 6: D(playerid,D_BANK_CHANGE_PIN,DSI, ""P"Смена PIN-кода","\n\n"W"Введите новый PIN-код состоящий из 4 цифр:\n\n","Изменить","Назад");
			}
		}
		case D_BANK_INPUT: {
			if(!response) return bank_score(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000000) {
				D(playerid,D_BANK_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять:\n\n"NO"*"G" Можно снимать от $1 до $10.000.000\n\n","Снять","Назад");
				return 1;
			}
			if(gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")] < amount) return D(playerid,D_BANK_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять:\n\n"NO"*"G" Недостаточно средств\n\n","Снять","Назад");
			gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")] -= amount;
		 	GiveMoney(playerid, amount,"снятие с банк счета");

			SaveScore(playerid);

			static const f_str[] = ""W"Снято средств:\t\t"GREEN"$%d\n\
								"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")]);
			D(playerid,D_BANK_LIST,DSM, ""P"Выдача наличных",string,"Назад","");

			new query[256];
			mysql_format(connects, query, sizeof(query), "INSERT `history` (`number_1`,`status`,`money`, `date`) VALUES('%d', '3', '%d', '%d' )", gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")],amount, gettime());
			return mysql_tquery(connects, query, "", "");
		}
  		case D_BANK_PUT: {
			if(!response) return bank_score(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000000) {
				D(playerid,D_BANK_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить:\n\n"NO"*"G" Можно класть от $1 до 10.000.000$\n\n","Положить","Назад");
				return 1;
			}
			if(PI[playerid][pCash] < amount) return D(playerid,D_BANK_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить:\n\n"NO"*"G" Недостаточно средств\n\n","Положить","Назад");
			gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")] += amount;
			GiveMoney(playerid, -amount,"положил на банк счет");

			SaveScore(playerid);

			static const f_str[] = ""W"Внесено средств:\t\t"GREEN"$%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")]);
			D(playerid,D_BANK_LIST,DSM, ""P"Пополнение счёта",string,"Назад","");

			new query[256];
			mysql_format(connects, query, sizeof(query), "INSERT `history` (`number_1`,`status`,`money`, `date`) VALUES('%d', '4', '%d', '%d' )", gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")],amount, gettime());
			return mysql_tquery(connects, query, "", "");
		}
    	case D_BANK_TRANSFER_ONE: {
			if(!response) return bank_score(playerid);
			if(!strlen(inputtext)) {
				new Float:percent;
				switch(GetPlayerVirtualWorld(playerid)) {
					case 46: percent = FuncBizz[8][funcbPercent2];
					case 47: percent = FuncBizz[9][funcbPercent2];
					case 48: percent = FuncBizz[10][funcbPercent2];
					default: {
						switch(GetPVarInt(playerid, "bank_donate")) {
							case 0: percent = FuncBizz[8][funcbPercent2];
							case 1: percent = FuncBizz[9][funcbPercent2];
							case 2: percent = FuncBizz[10][funcbPercent2];
							default: return 1;
						}
					}
				}
				static const f_str[] = "\n\n"W"Введите номер счёта, на который хотите перевести деньги:\nВнимание: комиссия за перевод: "ORANGE"%.1f%\n\n";
				new string[sizeof(f_str) +1 + (-2 + 4)];
				format(string,sizeof(string),f_str,percent);
				return D(playerid,D_BANK_TRANSFER_ONE,DSI, ""P"Перевод средств",string,"Далее","Назад");
			}
			new query[128];
			format(query,sizeof(query),"SELECT * FROM `bank` WHERE `number` = '%i' LIMIT 1", strval(inputtext));
			mysql_tquery(connects,query, "check_score", "ii", playerid, strval(inputtext));
			return 1;
		}
		case D_BANK_TRANSFER_TWO: {
			if(!response) return bank_score(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000000) {
				D(playerid,D_BANK_TRANSFER_TWO,DSI, ""P"Перевод средств","\n\n"W"Введите сумму, которую хотите перевести на введенный Вами счёт:\n\n"NO"*"G" Можно переводить от $1 до 10.000.000$\n\n","Далее","Назад");
				return 1;
			}
			new percent,Float:percent2;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = floatround(amount/100*FuncBizz[8][funcbPercent2]),percent2 = FuncBizz[8][funcbPercent2];
				case 47: percent = floatround(amount/100*FuncBizz[9][funcbPercent2]),percent2 = FuncBizz[9][funcbPercent2];
				case 48: percent = floatround(amount/100*FuncBizz[10][funcbPercent2]),percent2 = FuncBizz[10][funcbPercent2];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = floatround(amount/100*FuncBizz[8][funcbPercent2]),percent2 = FuncBizz[8][funcbPercent2];
						case 1: percent = floatround(amount/100*FuncBizz[9][funcbPercent2]),percent2 = FuncBizz[9][funcbPercent2];
						case 2: percent = floatround(amount/100*FuncBizz[10][funcbPercent2]),percent2 = FuncBizz[10][funcbPercent2];
						default: return 1;
					}
				}
			}
			if(gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")] < amount+percent) return D(playerid,D_BANK_TRANSFER_TWO,DSI, ""P"Перевод средств",""W"Введите сумму, которую хотите перевести на введенный Вами счёт:\n\n"NO"*"G" Недостаточно средств","Далее","Назад");
			new string[256];
			format(string, sizeof(string),""W"Перевод денежных средств\n\n\
				Имя получателя: \t"P"%s\n\
				"W"Номер счёта: \t\t"P"%d\n\
				"W"Комиссия: \t\t"P"%.1f%\n\n\
				"W"Вы действительно хотите перевести "GREEN"$%d"W"?",
			gBanks[playerid][bankTowner][GetPVarInt(playerid, "select_score")], GetPVarInt(playerid, "select_number"),percent2,amount+percent);
			D(playerid,D_BANK_TRANSFER_THREE,DIALOG_STYLE_MSGBOX,"Перевод средств",string,"Перевод","Отмена");
			SetPVarInt(playerid, "select_money",amount);
			return 1;
		}
		case D_BANK_TRANSFER_THREE: {
			if(!response) {
				DeletePVar(playerid, "select_number");
				DeletePVar(playerid, "select_money");
				strmid(gBanks[playerid][bankTowner][GetPVarInt(playerid, "select_score")], "None", 0, strlen("None"), 4);
				return bank_score(playerid);
			}
   			new query[256];
			format(query,sizeof(query), "UPDATE `bank` SET `balance` = `balance` + '%i' WHERE `number` = '%i'",
			GetPVarInt(playerid, "select_money"), GetPVarInt(playerid, "select_number"));
			mysql_tquery(connects,query,"","");

			new id = GetPlayerID(gBanks[playerid][bankTowner][GetPVarInt(playerid, "select_score")]);
			if(IsPlayerConnected(id)) {
				for(new i;i < score_number[id];i++) {
					if(gBanks[id][bankNumber][i] != GetPVarInt(playerid, "select_number")) continue;
					gBanks[id][bankBalance][i] += GetPVarInt(playerid, "select_money");

					static const f_str[] = ""P"%s "G"осуществил перевод на Ваш банковский счёт "W"№ %d"W" в размере - "ORANGE"$%d";
					new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 11) + (-2 + 11)];
					format(string,sizeof(string),f_str,player_name[playerid],GetPVarInt(playerid, "select_number"),GetPVarInt(playerid, "select_money"));
					SendUse(id,string);
				}
			}
			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[8][funcbPercent2]),bizz_pay(7,percent);
				case 47: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[9][funcbPercent2]),bizz_pay(8,percent);
				case 48: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[10][funcbPercent2]),bizz_pay(9,percent);
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[8][funcbPercent2]),bizz_pay(7,percent);
						case 1: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[9][funcbPercent2]),bizz_pay(8,percent);
						case 2: percent = floatround(GetPVarInt(playerid, "select_money")/100*FuncBizz[10][funcbPercent2]),bizz_pay(9,percent);
						default: return 1;
					}
				}
			}
			gBanks[playerid][bankBalance][GetPVarInt(playerid, "select_score")] -= (GetPVarInt(playerid, "select_money")+percent);

			SaveScore(playerid);

			new yeart, montht, dayt, hourt, minutet;
			getdate(yeart,montht,dayt) , gettime(hourt,minutet);
			new mtext[20],string[256];
			switch(montht) {
				case 1: mtext = "Января";
				case 2: mtext = "Февраля";
				case 3: mtext = "Марта";
				case 4: mtext = "Апреля";
				case 5: mtext = "Мая";
				case 6: mtext = "Июня";
				case 7: mtext = "Июля";
				case 8: mtext = "Августа";
				case 9: mtext = "Сентебря";
				case 10: mtext = "Октября";
				case 11: mtext = "Ноября";
				case 12: mtext = "Декабря";
			}
			if (minutet < 10)    format(string, sizeof(string), ""W"Перевод успешно завершен\n\nИмя получателя: "P"%s\n\
				"W"№ счёта: "P"%i\n"W"Сумма: "GREEN"$%i\n\n"W"Время: "P"%i %s %i в %i:0%i",
			gBanks[playerid][bankTowner][GetPVarInt(playerid, "select_score")],GetPVarInt(playerid, "select_number"),GetPVarInt(playerid, "select_money"),dayt,mtext,yeart,hourt,minutet);
			else format(string, sizeof(string), ""W"Перевод успешно завершен\n\nИмя получателя: "P"%s\n\
				"W"№ счёта: "P"%i\n"W"Сумма: "GREEN"$%i\n\n"W"Время: "P"%i %s %i в %i:%i",
			gBanks[playerid][bankTowner][GetPVarInt(playerid, "select_score")],GetPVarInt(playerid, "select_number"),GetPVarInt(playerid, "select_money"),dayt,mtext,yeart,hourt,minutet);
			D(playerid,DIALOG_NONE,DIALOG_STYLE_MSGBOX,"Чек",string,"Готово","");

			mysql_format(connects, query, sizeof(query), "INSERT `history` (`name_1`, `number_1`,`number_2`,`status`, `money`, `date`) VALUES('%s', '%d', '%d', '2', '%d', '%d')", player_name[playerid],gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")],GetPVarInt(playerid, "select_number"),GetPVarInt(playerid, "select_money"), gettime());
			return mysql_tquery(connects, query, "", "");
		}
		case D_BANK_CHANGE_PIN: {
		    if(!response) return bank_score(playerid);
	     	if(strlen(inputtext) != 4 || !IsNumber(inputtext)) return D(playerid,D_BANK_CHANGE_PIN,DSI, ""P"Смена PIN-кода","\n\n"W"Введите новый PIN-код состоящий из 4 цифр:\n\n","Изменить","Назад");
	     	gBanks[playerid][bankPassword][GetPVarInt(playerid, "select_score")] = strval(inputtext);
			new query[165];
			format(query,sizeof(query),"UPDATE `bank` SET `code` = '%d' WHERE `number` = '%d'",gBanks[playerid][bankPassword][GetPVarInt(playerid, "select_score")], gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")]);
  			mysql_tquery(connects,query,"","");

			static const f_str[] = ""W"PIN-код успешно изменён\nВаш новый PIN - "P"%s";
			new string[sizeof(f_str) +1 + (-2 + 5)];
			format(string,sizeof(string),f_str,inputtext);
			D(playerid,D_BANK_LIST,DSM, ""P"Смена PIN-кода", string, "Назад","");
			mysql_format(connects, query, sizeof(query), "INSERT `history` (`name_1`, `number_1`,`status`, `date`) VALUES('%s', '%d', '1', '%d')", player_name[playerid],gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")], gettime());
			return mysql_tquery(connects, query, "", "");
		}
		case D_BANK_CHANGE_NAME: {
			if(!response) return bank_score(playerid);
	     	if(strlen(inputtext) < 1 || strlen(inputtext) > 12) return D(playerid,D_BANK_CHANGE_NAME,DSI, ""P"Переименовать счёт","\n\n"W"Введите новое название Вашего счёта:\n\n"NO"*"G" Максимальная длина 12 символов\n\n","Изменить","Назад");
	     	strmid(score_name[playerid][GetPVarInt(playerid, "select_score")], inputtext, 0, strlen(inputtext), 20);
			new query[100];
			mysql_format(connects, query, sizeof(query),"UPDATE `bank` SET `name` = '%e' WHERE `number` = '%d'",score_name[playerid][GetPVarInt(playerid, "select_score")],gBanks[playerid][bankNumber][GetPVarInt(playerid, "select_score")]);
  			mysql_tquery(connects,query,"","");

			static const f_str[] = ""W"Имя банковского счёта успешно изменено\nНовое имя - "P"%s";
			new string[sizeof(f_str) +1 + (-2 + 13)];
			format(string,sizeof(string),f_str,score_name[playerid][GetPVarInt(playerid, "select_score")]);
			D(playerid,D_BANK_LIST,DSM, ""P"Переименовать счёт", string, "Назад","");
			return 1;
		}
		case D_BANK_GLOBAL: {
			if(!response) return bank_dialog(playerid);
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Название:\t\t"O"Основной счёт\n\
								"W"Баланс:\t\t"GREEN"$%i\n";
					new string[sizeof(f_str) +1 + (-2 + 11)];
					format(string, sizeof(string), f_str,PI[playerid][pBank]);
					return D(playerid,D_BANK_GLOBAL_LIST,DSM, ""P"Информация",string,"Назад","");
				}
				case 1: D(playerid,D_BANK_GLOBAL_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить на банковский счёт:\n\n","Положить","Назад");
				case 2: D(playerid,D_BANK_GLOBAL_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять с банковского счёта:\n\n","Снять","Назад");
			}
		}
		case D_BANK_GLOBAL_INPUT: {
			if(!response) return bank_dialog(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000000) {
				D(playerid,D_BANK_GLOBAL_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять:\n\n"NO"*"G" Можно снимать от $1 до $10.000.000\n\n","Снять","Назад");
				return 1;
			}
			if(PI[playerid][pBank] < amount) return D(playerid,D_BANK_GLOBAL_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму которую хотите снять:\n\n"NO"*"G" Недостаточно средств\n\n","Снять","Назад");
			PI[playerid][pBank] -= amount;
			UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
		 	GiveMoney(playerid, amount,"снятие с банк счета");

			static const f_str[] = ""W"Снято средств:\t\t"GREEN"$%d\n\
								"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pBank]);
			return D(playerid,D_BANK_GLOBAL_LIST,DSM, ""P"Выдача наличных",string,"Назад","");
		}
  		case D_BANK_GLOBAL_PUT: {
			if(!response) return bank_dialog(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000000) {
				D(playerid,D_BANK_GLOBAL_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить:\n\n"NO"*"G" Можно класть от $1 до $10.000.000\n\n","Положить","Назад");
				return 1;
			}
			if(PI[playerid][pCash] < amount) return D(playerid,D_BANK_GLOBAL_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить:\n\n"NO"*"G" Недостаточно средств\n\n","Положить","Назад");
			PI[playerid][pBank] += amount;
			UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
			GiveMoney(playerid, -amount,"положил на банк счет");

			static const f_str[] = ""W"Внесено средств:\t\t"GREEN"$%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pBank]);
			return D(playerid,D_BANK_GLOBAL_LIST,DSM, ""P"Пополнение счёта",string,"Назад","");
		}
		case D_BANK_OPLATA: {
			if(!response) return 1;
			new day;
			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = FuncBizz[8][funcbPercent];
				case 47: percent = FuncBizz[9][funcbPercent];
				case 48: percent = FuncBizz[10][funcbPercent];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = FuncBizz[8][funcbPercent];
						case 1: percent = FuncBizz[9][funcbPercent];
						case 2: percent = FuncBizz[10][funcbPercent];
						default: return 1;
					}
				}
			}
			switch(listitem) {
				case 0: {
					if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома");
					new house = PI[playerid][pHouse]-1,oplata;
					if(gHouses[house][houseImprove][1]) oplata = floatround(gHouses[house][housePrice]*house_rent/2);
					else oplata = floatround(gHouses[house][housePrice]*house_rent);
					day = (gHouses[house][houseDay]-gettime())/86400;
					static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за дом:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 17)];
					format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
					D(playerid,D_BANK_OPLATA_HOUSE,DSI, ""P"Оплата дома",string,"Оплатить","Отмена");
				}
				case 1: {
					if(!PI[playerid][pBusiness]) return ErrorMessage(playerid,"У Вас нет бизнеса");
					new bizz = PI[playerid][pBusiness]-1,oplata;
					if(gBusiness[bizz][bizzUpgrade][2]) oplata = floatround(gBusiness[bizz][bizzSellPrice]*bizz_rent/2);
					else oplata = floatround(gBusiness[bizz][bizzSellPrice]*bizz_rent);
					day = (gBusiness[bizz][bizzDay]-gettime())/86400;
					static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за бизнес:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 17)];
					format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
					D(playerid,D_BANK_OPLATA_BIZZ,DSI, ""P"Оплата бизнеса",string,"Оплатить","Отмена");
				}
				case 2: {
					if(!PI[playerid][pHotel]) return ErrorMessage(playerid,"У Вас нет отеля");
					new hotel = PI[playerid][pHotel]-1;
					day = (gHotels[hotel][hotelDay]-gettime())/86400;
					new oplata = floatround(gHotels[hotel][hotelPrice]*hotel_rent);
					static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за отель:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 17)];
					format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
					D(playerid,D_BANK_OPLATA_HOTEL,DSI, ""P"Оплата отеля",string,"Оплатить","Отмена");
				}
				case 3: {
					if(!PI[playerid][pAirport]) return ErrorMessage(playerid,"У Вас нет аэропорта");
					new air = PI[playerid][pAirport]-1;
					day = (gAirs[air][airDay]-gettime())/86400;
					new oplata = floatround(gAirs[air][airPrice]*airport_rent);
					static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за аэропорт:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 17)];
					format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
					D(playerid,D_BANK_OPLATA_AIRPORT,DSI, ""P"Оплата аэропорта",string,"Оплатить","Отмена");
				}
			}
		}
		case D_BANK_OPLATA_HOUSE: {
			if(!response) return 1;
			if(!PI[playerid][pHouse]) return ErrorMessage(playerid,"У Вас нет дома");
			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = FuncBizz[8][funcbPercent];
				case 47: percent = FuncBizz[9][funcbPercent];
				case 48: percent = FuncBizz[10][funcbPercent];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = FuncBizz[8][funcbPercent];
						case 1: percent = FuncBizz[9][funcbPercent];
						case 2: percent = FuncBizz[10][funcbPercent];
						default: return 1;
					}
				}
			}
			new amount = strval(inputtext);
			new houseid = PI[playerid][pHouse] - 1,oplata;
			if(gHouses[houseid][houseImprove][1]) oplata = floatround(gHouses[houseid][housePrice]*house_rent/2);
			else oplata = floatround(gHouses[houseid][housePrice]*house_rent);
			new day;
			day = (gHouses[houseid][houseDay]-gettime())/86400;
			new plata = floatround((oplata/100*percent)+oplata);
			if(amount < 1 || amount > 20) {
				static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за дом:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n"NO"*"G" От 1 до 20 дней\n\n";
				new string[sizeof(f_str) +1 + (-2 + 17)];
				format(string,sizeof(string),f_str,oplata,percent,plata,day);
				D(playerid,D_BANK_OPLATA_HOUSE,DSI, ""P"Оплата дома",string,"Оплатить","Отмена");
				return 1;
			}
			if(day + amount > 20) return ErrorMessage(playerid,"Максимальное кол-во оплаченных дней 20");
			if(GetPlayerMoneyEx(playerid) < amount*plata) return ErrorMessage(playerid,"Недостаточно средств");
			gHouses[houseid][houseDay] += 86400 * amount;
			new query[128];
			format(query,sizeof(query),"UPDATE `houses` SET `day` = '%d' WHERE id = '%d'",gHouses[houseid][houseDay],houseid+1);
			mysql_tquery(connects, query,"","");
			GiveMoney(playerid,-(amount*plata),"оплата за дом");

			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: bizz_pay(7,amount*floatround(oplata/100*percent));
				case 47: bizz_pay(8,amount*floatround(oplata/100*percent));
				case 48: bizz_pay(9,amount*floatround(oplata/100*percent));
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: bizz_pay(7,amount*floatround(oplata/100*percent));
						case 1: bizz_pay(8,amount*floatround(oplata/100*percent));
						case 2: bizz_pay(9,amount*floatround(oplata/100*percent));
						default: return 1;
					}
				}
			}
			FI[fWHITEHOUSE][fBank] += ((amount*plata)-amount*floatround(oplata/100*percent));
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			static const f_str[] = ""W"Оплачено дней:\t\t"O"%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pCash]);
			return D(playerid,DIALOG_NONE,DSM, ""P"Оплата дома",string,"Хорошо","");
		}
		case D_BANK_OPLATA_BIZZ: {
			if(!response) return 1;
			if(!PI[playerid][pBusiness]) return ErrorMessage(playerid,"У Вас нет бизнеса");
			new amount = strval(inputtext);
			new bizid = PI[playerid][pBusiness] - 1,oplata;
			if(gBusiness[bizid][bizzUpgrade][2]) oplata = floatround(gBusiness[bizid][bizzSellPrice]*bizz_rent/2);
			else oplata = floatround(gBusiness[bizid][bizzSellPrice]*bizz_rent);

			new day;
			day = (gBusiness[bizid][bizzDay]-gettime())/86400;

			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = FuncBizz[8][funcbPercent];
				case 47: percent = FuncBizz[9][funcbPercent];
				case 48: percent = FuncBizz[10][funcbPercent];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = FuncBizz[8][funcbPercent];
						case 1: percent = FuncBizz[9][funcbPercent];
						case 2: percent = FuncBizz[10][funcbPercent];
						default: return 1;
					}
				}
			}
			if(amount < 1 || amount > 20) {
				static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за бизнес:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n"NO"*"G" От 1 до 20 дней\n\n";
				new string[sizeof(f_str) +1 + (-2 + 17)];
				format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
				return D(playerid,D_BANK_OPLATA_BIZZ,DSI, ""P"Оплата бизнеса",string,"Оплатить","Отмена");
			}
			new plata = floatround((oplata/100*percent)+oplata);
			if(day + amount > 20) return ErrorMessage(playerid,"Максимальное кол-во оплаченных дней 20");
			if(GetPlayerMoneyEx(playerid) < amount*plata) return ErrorMessage(playerid,"Недостаточно средств");
			gBusiness[bizid][bizzDay] += 86400 * amount;
			UpdateBusinessData(bizid+1,"deliving",gBusiness[bizid][bizzDay]);
			GiveMoney(playerid,-(amount*plata),"оплата за бизнес");

			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: bizz_pay(7,amount*floatround(oplata/100*percent));
				case 47: bizz_pay(7,amount*floatround(oplata/100*percent));
				case 48: bizz_pay(9,amount*floatround(oplata/100*percent));
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: bizz_pay(7,amount*floatround(oplata/100*percent));
						case 1: bizz_pay(7,amount*floatround(oplata/100*percent));
						case 2: bizz_pay(9,amount*floatround(oplata/100*percent));
						default: return 1;
					}
				}
			}

			FI[fWHITEHOUSE][fBank] += ((amount*plata)-amount*floatround(oplata/100*percent));
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			static const f_str[] = ""W"Оплачено дней:\t\t"O"%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pCash]);
			return D(playerid,DIALOG_NONE,DSM, ""P"Оплата бизнеса",string,"Хорошо","");
		}
		case D_BANK_OPLATA_HOTEL: {
			if(!response) return 1;
			if(!PI[playerid][pHotel]) return ErrorMessage(playerid,"У Вас нет отеля");
			new amount = strval(inputtext);
			new hotel = PI[playerid][pHotel] - 1;
			new day;
			day = (gHotels[hotel][hotelDay]-gettime())/86400;
			new oplata = floatround(gHotels[hotel][hotelPrice]*hotel_rent);
			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = FuncBizz[8][funcbPercent];
				case 47: percent = FuncBizz[9][funcbPercent];
				case 48: percent = FuncBizz[10][funcbPercent];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = FuncBizz[8][funcbPercent];
						case 1: percent = FuncBizz[9][funcbPercent];
						case 2: percent = FuncBizz[10][funcbPercent];
						default: return 1;
					}
				}
			}
			if(amount < 1 || amount > 20) {
				static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за отель:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n"NO"*"G" От 1 до 20 дней\n\n";
				new string[sizeof(f_str) +1 + (-2 + 17)];
				format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
				return D(playerid,D_BANK_OPLATA_HOTEL,DSI, ""P"Оплата отеля",string,"Оплатить","Отмена");
			}
			new plata = floatround((oplata/100*percent)+oplata);
			if(day + amount > 20) return ErrorMessage(playerid,"Максимальное кол-во оплаченных дней 20");
			if(GetPlayerMoneyEx(playerid) < amount*plata) return ErrorMessage(playerid,"Недостаточно средств");
			gHotels[hotel][hotelDay] += 86400 * amount;
			UpdateHotelData(hotel+1,"day",gHotels[hotel][hotelDay]);
			GiveMoney(playerid,-(amount*plata),"оплата за отель");

			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: bizz_pay(7,amount*floatround(oplata/100*percent));
				case 47: bizz_pay(8,amount*floatround(oplata/100*percent));
				case 48: bizz_pay(9,amount*floatround(oplata/100*percent));
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: bizz_pay(7,amount*floatround(oplata/100*percent));
						case 1: bizz_pay(8,amount*floatround(oplata/100*percent));
						case 2: bizz_pay(9,amount*floatround(oplata/100*percent));
						default: return 1;
					}
				}
			}

			FI[fWHITEHOUSE][fBank] += ((amount*plata)-amount*floatround(oplata/100*percent));
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			static const f_str[] = ""W"Оплачено дней:\t\t"O"%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pCash]);
			return D(playerid,DIALOG_NONE,DSM, ""P"Оплата отеля",string,"Хорошо","");
		}
		case D_BANK_OPLATA_AIRPORT: {
			if(!response) return 1;
			if(!PI[playerid][pAirport]) return ErrorMessage(playerid,"У Вас нет аэропорта");
			new amount = strval(inputtext);
			new airid = PI[playerid][pAirport] - 1;
			new day;
			day = (gAirs[airid][airDay]-gettime())/86400;
			new oplata = floatround(gAirs[airid][airPrice]*airport_rent);
			new percent;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: percent = FuncBizz[8][funcbPercent];
				case 47: percent = FuncBizz[9][funcbPercent];
				case 48: percent = FuncBizz[10][funcbPercent];
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: percent = FuncBizz[8][funcbPercent];
						case 1: percent = FuncBizz[9][funcbPercent];
						case 2: percent = FuncBizz[10][funcbPercent];
						default: return 1;
					}
				}
			}
			if(amount < 1 || amount > 20) {
				static const f_str[] = "\n\n"W"Введите кол-во дней на которое хотите продлить аренду за аэропорт:\nПримечание: "ORANGE"1"W" день = "GREEN"$%d"W" (Комиссия банка: "ORANGE"%d"W" процент(ов), сумма с комиссией: "GREEN"$%d"W")\nОплачено дней: "P"%d\n\n"NO"*"G" От 1 до 20 дней\n\n";
				new string[sizeof(f_str) +1 + (-2 + 17)];
				format(string,sizeof(string),f_str,oplata,percent,floatround((oplata/100*percent)+oplata),day);
				return D(playerid,D_BANK_OPLATA_AIRPORT,DSI, ""P"Оплата аэропорта",string,"Оплатить","Отмена");
			}
			new plata = floatround((oplata/100*percent)+oplata);
			if(day + amount > 20) return ErrorMessage(playerid,"Максимальное кол-во оплаченных дней 20");
			if(GetPlayerMoneyEx(playerid) < amount*plata) return ErrorMessage(playerid,"Недостаточно средств");
			gAirs[airid][airDay] += 86400 * amount;
			UpdateAirportData(airid+1,"day",gAirs[airid][airDay]);
			GiveMoney(playerid,-(amount*plata),"оплата за аэропорт");

			switch(GetPlayerVirtualWorld(playerid)) {
				case 46: bizz_pay(7,amount*floatround(oplata/100*percent));
				case 47: bizz_pay(8,amount*floatround(oplata/100*percent));
				case 48: bizz_pay(9,amount*floatround(oplata/100*percent));
				default: {
					switch(GetPVarInt(playerid, "bank_donate")) {
						case 0: bizz_pay(7,amount*floatround(oplata/100*percent));
						case 1: bizz_pay(8,amount*floatround(oplata/100*percent));
						case 2: bizz_pay(9,amount*floatround(oplata/100*percent));
						default: return 1;
					}
				}
			}

			FI[fWHITEHOUSE][fBank] += ((amount*plata)-amount*floatround(oplata/100*percent));
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			static const f_str[] = ""W"Оплачено дней:\t\t"O"%d\n\
									"W"Баланс:\t\t\t"GREEN"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,PI[playerid][pCash]);
			return D(playerid,DIALOG_NONE,DSM, ""P"Оплата отеля",string,"Хорошо","");
		}
		case dBusRent: {
			if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(GetPlayerMoneyEx(playerid) < BUS_PRICE_RENT) return ErrorMessage(playerid,"У Вас недостаточно средств"),RemovePlayerFromVehicleAC(playerid);
			new vehicleid = GetPlayerVehicleID(playerid);
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
			SetPVarInt(playerid,"bus_id",vehicleid);
			switch(VehicleInfo[GetPlayerVehicleID(playerid)][vBus]) {
				case 1: D(playerid,dBusChangeRoute,2,"Выберите маршрут:","1. ЖДЛС - Яблочный сад\n2. ЖДЛС - Оружейный завод\n3. ЖДЛС - Нефтезавод\n4. ЖДЛС - ЖДСФ\n5. ЖДЛС - ЖДЛВ","Выбрать","Отмена");
				case 2: {
					new string[156];
					new model = GetVehicleModel(vehicleid);
					if(vehicleid == INVALID_VEHICLE_ID || (model != 431 && model != 437)) return 1;
					SetString(gRouteName[5], "ЖДЛВ - ЖДЛС");
					format(string,sizeof(string),""P"%s\n"W"Стоимость билета: "GREEN"$%i",gRouteName[5],100);
					gPlayerBusText[playerid] = CreateDynamic3DTextLabel(string,-1, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, GetPlayerVehicleID(playerid));

					SetPVarInt(playerid,"route",6);
					SetNextBusCP(playerid);
				}
				case 3: {
					new string[156];
					new model = GetVehicleModel(vehicleid);
					if(vehicleid == INVALID_VEHICLE_ID || (model != 431 && model != 437)) return 1;
					SetString(gRouteName[6], "ЖДСФ - ЖДЛС");
					format(string,sizeof(string),""P"%s\n"W"Стоимость билета: "GREEN"$%i",gRouteName[6],100);
					gPlayerBusText[playerid] = CreateDynamic3DTextLabel(string,-1, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, GetPlayerVehicleID(playerid));

					SetPVarInt(playerid,"route",7);
					SetNextBusCP(playerid);
				}
			}
			GiveMoney(playerid,-BUS_PRICE_RENT,"аренда автобуса");
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerBusText[playerid],E_STREAMER_ATTACH_OFFSET_Y, -0.5);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerBusText[playerid],E_STREAMER_ATTACH_OFFSET_Z, 3.0);
			SetPVarFloat(playerid,"bus_damage", 1000.0);
			return 1;
		}
		case dBusChangeRoute: {
			if(!response) {
				D(playerid,dBusChangeRoute,2,"Выберите маршрут:","1. ЖДЛС - Яблочный сад\n2. ЖДЛС - Оружейный завод\n3. ЖДЛС - Нефтезавод\n4. ЖДЛС - ЖДСФ\n5. ЖДЛС - ЖДЛВ","Выбрать","Отмена");
				return 1;
			}
			SetPVarInt(playerid,"route_item",listitem);
			new route = GetPVarInt(playerid,"route_item");
			DeletePVar(playerid,"route_item");
			new vehicleid = GetPlayerVehicleID(playerid);
			new model = GetVehicleModel(vehicleid);
			if(vehicleid == INVALID_VEHICLE_ID || (model != 431 && model != 437)) return 1;

			switch(route) {
				case 0: SetString(gRouteName[0], "ЖДЛС - Яблочный сад");
				case 1: SetString(gRouteName[1], "ЖДЛС - Оружейный завод");
				case 2: SetString(gRouteName[2], "ЖДЛС - Нефтезавод");
				case 3: SetString(gRouteName[3], "ЖДЛС - ЖДСФ");
				case 4: SetString(gRouteName[4], "ЖДЛС - ЖДЛВ");
			}

			new string[71];
			format(string,sizeof(string),""P"%s\n"W"Стоимость билета: "GREEN"$%i",gRouteName[route],100);
			SetPVarInt(playerid,"route",route + 1);
			return D(playerid,dBusChangePrice,DSI,""P"Стоимость билета", "Укажите стоимость билета для данного маршрута", "Ввод", "Отмена");
		}
		case dBusChangePrice: {
			if (!response) {
				return D(playerid,dBusChangePrice,DSI,""P"Стоимость билета", "Укажите стоимость билета для данного маршрута", "Ввод", "Отмена");
			}
			new vehicleid = GetPlayerVehicleID(playerid);
			new model = GetVehicleModel(vehicleid);
			if (vehicleid == INVALID_VEHICLE_ID || (model != 431 && model != 437)) return 1;

			new amount;
			if (sscanf(inputtext,"i",amount)) return D(playerid,dBusChangePrice,DSI,""P"Стоимость билета", "Укажите стоимость билета для данного маршрута", "Ввод", "Отмена");
			if (amount < 1 || amount > 300) {
				return D(playerid,dBusChangePrice,DSI,""P"Стоимость билета", "Укажите стоимость билета для данного маршрута", "Ввод", "Отмена");
			}
			gRoutePrice[playerid] = amount;

			new string[71];
			format(string,sizeof(string),""P"%s\n"W"Стоимость билета: "GREEN"$%i",gRouteName[GetPVarInt(playerid, "route") - 1],gRoutePrice[playerid]);

			
			gPlayerBusText[playerid] = CreateDynamic3DTextLabel(string,-1, 0.0, 0.0, 0.0, 50.0, INVALID_PLAYER_ID, GetPlayerVehicleID(playerid));
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerBusText[playerid],E_STREAMER_ATTACH_OFFSET_Y, -0.5);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerBusText[playerid],E_STREAMER_ATTACH_OFFSET_Z, 3.0);

			SetNextBusCP(playerid);
			SetPVarInt(playerid,"bus_id",vehicleid);
			SetPVarFloat(playerid,"bus_damage", 1000.0);
			return 1;
		}
		case D_SPAWN: {
			if(!response) return 1;
			switch(listitem) {
				case DEFAULT_SPAWN: SendOk(playerid,"Вы выбрали местом спавна: "W"вокзал");
				case HOME_SPAWN: {
					if(!PI[playerid][pHouse] && !PI[playerid][pTempKey] && !PI[playerid][pRoom]) return ErrorMessage(playerid, "У Вас нет дома/номера в отеле");
					SendOk(playerid,"Вы выбрали местом спавна: "W"дом/отель");
				}
				case FRACTION_SPAWN:	{
					if(!PI[playerid][pMember]) return ErrorMessage(playerid, "Вы не состоите в организации");
					if(!start_work[playerid]) return ErrorMessage(playerid, "Необходимо начать рабочий день в организации");
					SendOk(playerid,"Вы выбрали местом спавна: "W"организация");
				}
				case FAMILY_SPAWN: {
					if(PI[playerid][pFamily] && !gFamily[PI[playerid][pFamily]-1][famHouse]) return ErrorMessage(playerid,"Дом семьи не выбран");
					SendOk(playerid,"Вы выбрали местом спавна: "W"дом семьи");
				}
			}
			PI[playerid][pSpawn] = listitem;
		}
		case D_MAFIA_CARM: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 482) return ErrorMessage(playerid, "Вы не в фургоне для развозки наркотиков");
			switch(listitem) {
				case 0: {
					if(PI[playerid][pMember] == fLCN) SetPlayerCheckpoint(playerid, 1542.5566,751.2112,10.8279, 5);
					else if(PI[playerid][pMember] == fYAKUZA) SetPlayerCheckpoint(playerid, 2626.6301,1766.1650,10.8203, 5);
					else if(PI[playerid][pMember] == fRM) SetPlayerCheckpoint(playerid, 945.0831,1810.5544,8.6484, 5);
					SendOk(playerid, "Место загрузки помечено на радаре");
				}
				case 1: SetPlayerCheckpoint(playerid, 1941.4858,-1121.8149,26.5436, 5);
				case 2: SetPlayerCheckpoint(playerid, 2753.4912,-1176.2693,69.4065, 5);
				case 3: SetPlayerCheckpoint(playerid, 2500.5557,-1681.2760,13.3686, 5);
				case 4: SetPlayerCheckpoint(playerid, 1672.8441,-2141.0789,13.5469, 5);
				case 5: SetPlayerCheckpoint(playerid, 2728.3887,-1946.3820,13.5469, 5);
				case 6: {
					new string_gung[512] = ""P"Банда\t"P"Кол-во наркотиков\t"P"Цена за 1г\n";
					if(FI[fBALLAS][fDrugsBuy]) {
						format(string_gung,sizeof(string_gung),"%s{CC00FF}The Ballas\t"P"%d\t"ORANGE"%d\n",string_gung,FI[fBALLAS][fDrugsBuy],FI[fBALLAS][fDrugsPrice]);
					}
					if(FI[fVAGOS][fDrugsBuy]) {
						format(string_gung,sizeof(string_gung),"%s{ffff00}Los Santos Vagos\t"P"%d\t"ORANGE"%d\n",string_gung,FI[fVAGOS][fDrugsBuy],FI[fVAGOS][fDrugsPrice]);
					}
					if(FI[fGROVE][fDrugsBuy]) {
						format(string_gung,sizeof(string_gung),"%s{009900}Grove Street\t"P"%d\t"ORANGE"%d\n",string_gung,FI[fGROVE][fDrugsBuy],FI[fGROVE][fDrugsPrice]);
					}
					if(FI[fAZTEC][fDrugsBuy]) {
						format(string_gung,sizeof(string_gung),"%s{00CCFF}Varrios Los Aztecas\t"P"%d\t"ORANGE"%d\n",string_gung,FI[fAZTEC][fDrugsBuy],FI[fAZTEC][fDrugsPrice]);
					}
					if(FI[fRIFA][fDrugsBuy]) {
						format(string_gung,sizeof(string_gung),"%s{6666FF}The Rifa\t"P"%d\t"ORANGE"%d\n",string_gung,FI[fRIFA][fDrugsBuy],FI[fRIFA][fDrugsPrice]);
					}
                    D(playerid,DIALOG_NONE,DSTH,"Заказы",string_gung,"Скрыть","");
                    return 1;
				}
			}
			if(listitem) SendOk(playerid, "Место разгрузки помечено на радаре");
			SetPVarInt(playerid,"DrugsMafiaCar",listitem+1);
			return 1;
		}
		case D_MAFIA_CARM_2: {
			if(!response) return 1;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 482) return ErrorMessage(playerid, "Вы не в фургоне для развозки наркотиков");
			new drugs = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(FI[PI[playerid][pMember]][fDrugs] - drugs < 0) {
				static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите загрузить в грузовик:\n\n\
									Доступно наркотиков: "ORANGE"%d\n\
									"W"В грузовик поместится: "ORANGE"%d\n\n\
									"NO"*"G" На складе недостаточно наркотиков";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,FI[PI[playerid][pMember]][fDrugs],500-VG[vehicleid][vgDrugs]);
				D(playerid, D_MAFIA_CARM_2, DSI, ""P"Загрузка наркотиков",string, "Загрузить", "Отмена");
				return 1;
			}
			if(VG[vehicleid][vgDrugs] + drugs > 500) {
				static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите загрузить в грузовик:\n\n\
									Доступно наркотиков: "ORANGE"%d\n\
									"W"В грузовик поместится: "ORANGE"%d\n\n\
									"NO"*"G" В фургоне недостаточно места";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,FI[PI[playerid][pMember]][fDrugs],500-VG[vehicleid][vgDrugs]);
				D(playerid, D_MAFIA_CARM_2, DSI, ""P"Загрузка наркотиков",string, "Загрузить", "Отмена");
				return 1;
			}
			VG[vehicleid][vgDrugs] += drugs;
			FI[PI[playerid][pMember]][fDrugs]-=drugs;
			UpdateFraction(GetTeamID(playerid),"Drugs",FI[PI[playerid][pMember]][fDrugs]);
			new string[128];
			format(string,sizeof(string),"Наркотики успешно загружены. В фургоне доступно: "ORANGE"%d"G" наркотиков",VG[vehicleid][vgDrugs]);
			SendOk(playerid,string);
		}
		case D_MAFIA_CARM_3: {
			if(!response) return DeletePVar(playerid,"sell_gdrugs");
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 482) return ErrorMessage(playerid, "Вы не в фургоне для развозки наркотиков");
			new gung,name[24];
			switch(GetPVarInt(playerid,"sell_gdrugs")) {
				case 1: gung = fBALLAS, name = "The Ballas";
				case 2: gung = fVAGOS, name = "The Vagos";
				case 3: gung = fGROVE, name = "The Grove";
				case 4: gung = fAZTEC, name = "The Aztec";
				case 5: gung = fRIFA, name = "The Rifa";
				default: return ErrorMessage(playerid,"Попробуйте позже");
			}
			if(!FI[gung][fDrugsBuy]) return ErrorMessage(playerid,"Банда не нуждается в покупке наркотиков");
			new drugs = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(drugs < 100 || drugs > 500) {
				static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать %s:\n\n\
										Доступно наркотиков: "ORANGE"%d\n\
										Склад банды: "ORANGE"%d"W"\n\
										"W"Заказ банды: "ORANGE"%d / $%d 1г\n\n\
										"NO"*"G" Продать можно от 100 и до 500 грамм";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,name,VG[vehicleid][vgDrugs],FI[gung][fDrugs],FI[gung][fDrugsBuy],FI[gung][fDrugsPrice]);
				D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
				return 1;
			}
			if(VG[vehicleid][vgDrugs] - drugs < 0) {
				static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать %s:\n\n\
										Доступно наркотиков: "ORANGE"%d\n\
										Склад банды: "ORANGE"%d"W"\n\
										"W"Заказ банды: "ORANGE"%d / $%d 1г\n\n\
										"NO"*"G" В фургоне недостаточно наркотиков";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,name,VG[vehicleid][vgDrugs],FI[gung][fDrugs],FI[gung][fDrugsBuy],FI[gung][fDrugsPrice]);
				D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
				return 1;
			}
			if(FI[gung][fDrugs] + drugs > 10000) {
				static const f_str[] = ""W"Введите кол-во наркотиков, которое хотите продать %s:\n\n\
										Доступно наркотиков: "ORANGE"%d\n\
										Склад банды: "ORANGE"%d"W"\n\
										"W"Заказ банды: "ORANGE"%d / $%d 1г\n\n\
										"NO"*"G" На склад банды не поместится столько наркотиков";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,name,VG[vehicleid][vgDrugs],FI[gung][fDrugs],FI[gung][fDrugsBuy],FI[gung][fDrugsPrice]);
				D(playerid, D_MAFIA_CARM_3, DSI, ""P"Продажа наркотиков",string, "Продать", "Отмена");
				return 1;
			}
			VG[vehicleid][vgDrugs] -= drugs;
			FI[gung][fDrugs]+=drugs;
			UpdateFraction(gung,"Drugs",FI[gung][fDrugs]);

			FI[PI[playerid][pMember]][fBank] += (FI[gung][fDrugsPrice] * drugs);
			UpdateFraction(GetTeamID(playerid),"Bank",FI[PI[playerid][pMember]][fBank]);

			new string[128];
			format(string,sizeof(string),"Наркотики успешно проданы за "ORANGE"%d."G" В фургоне доступно: "ORANGE"%d"G" наркотиков",(FI[gung][fDrugsPrice] * drugs),VG[vehicleid][vgDrugs]);
			SendOk(playerid,string);

			FI[gung][fDrugsBuy]-=drugs;
			UpdateFraction(gung,"DrugsBuy",FI[gung][fDrugsBuy]);
			if(FI[gung][fDrugsBuy] == 0) {
				FI[gung][fDrugsPrice] = 0;
				UpdateFraction(gung,"DrugsPrice",FI[gung][fDrugsPrice]);
			}
			DeletePVar(playerid,"sell_gdrugs");
		}
		case D_ARMY_CARM: {
		    if(!response) return true;
			if(start_work[playerid] && PI[playerid][pMember] == fARMYLV) {}
			else return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 433) return ErrorMessage(playerid, "Вы не в матовозе");
			switch(listitem) {
				case 0: SetPlayerCheckpoint(playerid, 1535.8534,-1674.4445,13.3828, 5);
				case 1: SetPlayerCheckpoint(playerid, -1606.6760,726.5093,12.0220, 5);
				case 2: SetPlayerCheckpoint(playerid, 2288.5105,2421.4209,10.8203, 5);
				case 3: SetPlayerCheckpoint(playerid, -1978.0072,-1008.3723,32.0234, 5);
				case 4: {
					new string[300];
    				format(string, sizeof(string), "\tОрганизация\tБоеприпасы\n"W"Армия ЛВ:\t"P"%d\n"W"Армия СФ:\t"P"%d\n"W"Полиция ЛС:\t"P"%d\n"W"Полиция СФ:\t"P"%d\n"W"Полиция ЛВ:\t"P"%d\n"W"ФБР:\t"P"%d",
					FI[fARMYLV][fMats],FI[fARMYSF][fMats],FI[fLSPD][fMats],FI[fSFPD][fMats],FI[fLVPD][fMats],FI[fFBI][fMats]);
                    D(playerid, DIALOG_NONE, DST,"Склады организаций",string,"Скрыть","");
                    return 1;
				}
			}
			SendOk(playerid, "Место разгрузки помечено на радаре");
			SetPVarInt(playerid,"MatsArmyCar",listitem+1);
			return 1;
		}
		case D_ARMY_CARM_SF: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			switch(listitem) {
				case 0: D(playerid, D_ARMY_CARM_SF_2, DSL, ""P"Загрузка боеприпасов",""P"1."W" Загрузка оружейный завод\n"P"2."W" Загрузка склад Army SF", "Выбрать", "Отмена");
				case 1: D(playerid, D_ARMY_CARM_SF_3, DSL, ""P"Разгрузка боеприпасов",""P"1."W" Разгрузка Army SF\n"P"2."W" Разгрузка Army LV", "Выбрать", "Отмена");
			}
			return 1;
		}
		case D_ARMY_CARM_SF_2: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			switch(listitem) {
				case 0: {
					SetPlayerCheckpoint(playerid, 2693.2300,-2370.8938,16.0798, 5);
					SendOk(playerid, "Место загрузки (оружейный завод) помечено на радаре");
					SetPVarInt(playerid,"MatsArmyCar",5);
				}
				case 1: {
					SetPlayerCheckpoint(playerid, -1607.3578,285.5919,7.1875, 5);
					SendOk(playerid, "Место загрузки (склад Army SF) помечено на радаре");
					SetPVarInt(playerid,"MatsArmyCar",6);
				}
			}
			return 1;
		}
		case D_ARMY_CARM_SF_3: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			switch(listitem) {
				case 0: {
					SetPlayerCheckpoint(playerid, -1607.3578,285.5919,7.1875, 5);
					SendOk(playerid, "Место разгрузки (Army SF) помечено на радаре");
					SetPVarInt(playerid,"MatsArmyCar",7);
				}
				case 1: {
					SetPlayerCheckpoint(playerid, 294.8125,2045.5763,17.6406, 5);
					SendOk(playerid, "Место загрузки (Army LV) помечено на радаре");
					SetPVarInt(playerid,"MatsArmyCar",8);
				}
			}
			return 1;
		}
		case D_ARMY_CARM_SF_4: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			new mats = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(zavodsklad - mats < 0) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d\n\
									"NO"*"G" На оружейном складе недостаточно боеприпасов";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,zavodsklad,30000-VG[vehicleid][vgAmount][0]);
				D(playerid, D_ARMY_CARM_SF_4, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				return 1;
			}
			if(VG[vehicleid][vgAmount][0] + mats > 30000) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d\n\
									"NO"*"G" В матолёте недостаточно места";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,zavodsklad,30000-VG[vehicleid][vgAmount][0]);
				D(playerid, D_ARMY_CARM_SF_4, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				return 1;
			}
			VG[vehicleid][vgAmount][0] += mats;
			zavodsklad -= mats;
			UpdateOtherData("gun_mats",zavodsklad);
			new string[128];
			format(string,sizeof(string),"Боеприпасы успешно загружены. В матолёте доступно: "ORANGE"%d"G" боеприпасов",VG[vehicleid][vgAmount][0]);
			SendOk(playerid,string);
		}
		case D_ARMY_CARM_SF_5: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			new mats = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(FI[fARMYSF][fMats] - mats < 0) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d\n\
									"NO"*"G" На складе Army SF недостаточно боеприпасов";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,FI[fARMYSF][fMats],30000-VG[vehicleid][vgAmount][0]);
				D(playerid, D_ARMY_CARM_SF_5, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				return 1;
			}
			if(VG[vehicleid][vgAmount][0] + mats > 30000) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите загрузить в матолёт:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"В матолёт поместится: "ORANGE"%d\n\
									"NO"*"G" В матолёте недостаточно места";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,FI[fARMYSF][fMats],30000-VG[vehicleid][vgAmount][0]);
				D(playerid, D_ARMY_CARM_SF_5, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				return 1;
			}
			VG[vehicleid][vgAmount][0] += mats;
			FI[fARMYSF][fMats] -= mats;
			UpdateFraction(fARMYSF,"Mats",FI[fARMYSF][fMats]);
			new string[128];
			format(string,sizeof(string),"Боеприпасы успешно загружены. В матолёте доступно: "ORANGE"%d"G" боеприпасов",VG[vehicleid][vgAmount][0]);
			SendOk(playerid,string);
		}
		case D_ARMY_CARM_SF_6: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			new mats = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(VG[vehicleid][vgAmount][0] - mats < 0) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"На склад поместится: "ORANGE"%d\n\
									"NO"*"G" В матолёте недостаточно боеприпасов";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYSF][fMats]);
				D(playerid, D_ARMY_CARM_SF_6, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				DeletePVar(playerid,"MatsArmyCar");
				return 1;
			}
			if(FI[fARMYSF][fMats] + mats > 1000000) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
										Доступно боеприпасов: "ORANGE"%d\n\
										"W"На склад поместится: "ORANGE"%d\n\
										"NO"*"G" На складе недосаточно места";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYSF][fMats]);
				D(playerid, D_ARMY_CARM_SF_6, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				DeletePVar(playerid,"MatsArmyCar");
				return 1;
			}
			VG[vehicleid][vgAmount][0] -= mats;
			FI[fARMYSF][fMats] += mats;
			UpdateFraction(fARMYSF,"Mats",FI[fARMYSF][fMats]);
			new string[128];
			format(string,sizeof(string),"Боеприпасы успешно разгружены. В матолёте доступно: "ORANGE"%d"G" боеприпасов",VG[vehicleid][vgAmount][0]);
			SendOk(playerid,string);
		}
		case D_ARMY_CARM_SF_7: {
		    if(!response) return true;
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 548) return ErrorMessage(playerid, "Вы не в матолёте");
			new mats = strval(inputtext);
			new vehicleid = GetPlayerVehicleID(playerid);
			if(VG[vehicleid][vgAmount][0] - mats < 0) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"На склад поместится: "ORANGE"%d\n\
									"NO"*"G" В матолёте недостаточно боеприпасов";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYLV][fMats]);
				D(playerid, D_ARMY_CARM_SF_7, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				DeletePVar(playerid,"MatsArmyCar");
				return 1;
			}
			if(FI[fARMYLV][fMats] + mats > 1000000) {
				static const f_str[] = ""W"Введите кол-во боеприпасов, которое хотите разгрузить на склад:\n\n\
									Доступно боеприпасов: "ORANGE"%d\n\
									"W"На склад поместится: "ORANGE"%d\n\
									"NO"*"G" На складе недосаточно места";
				new string[sizeof(f_str) +1 + (-2 + 7) + (-2 + 7)];
				format(string,sizeof(string),f_str,VG[vehicleid][vgAmount][0],1000000-FI[fARMYLV][fMats]);
				D(playerid, D_ARMY_CARM_SF_7, DSI, ""P"Загрузка боеприпасов",string, "Загрузить", "Отмена");
				DeletePVar(playerid,"MatsArmyCar");
				return 1;
			}
			VG[vehicleid][vgAmount][0] -= mats;
			FI[fARMYLV][fMats] += mats;
			UpdateFraction(fARMYLV,"Mats",FI[fARMYLV][fMats]);
			new string[128];
			format(string,sizeof(string),"Боеприпасы успешно разгружены. В матолёте доступно: "ORANGE"%d"G" боеприпасов",VG[vehicleid][vgAmount][0]);
			SendOk(playerid,string);
		}
		case dProdList: {
			if(!response) return 1;
			new car = GetVehicleModel(GetPlayerVehicleID(playerid));
			switch(listitem) {
				case 0: {
					//if(GetVehicleModel(veh) == 403 && !GetVehicleTrailer(veh)) return ErrorMessage(playerid,"У Вас нет цистерны с топливом");
					new string[3600];
					strcat(string, ""YELLOW"№\t"GREEN"Название бизнеса\t"GREEN"Цена за ед продукта\t"GREEN"Требуется продуктов\n");

					new count_est = 0;

					for(new i; i<gBusinessCount; i++) {
						if(!gBusiness[i][bizzOwnerID]) continue;
						if(gBusiness[i][bizzProdOrder] <= 0) continue;
						if(count_est >= 30) break;
						switch(car)
						{
							case 456: if(gBusiness[i][bizzType] == 7) continue;//24-7
							case 609: if(gBusiness[i][bizzType] != 7) continue;//АЗС
						}
						format(string,sizeof(string),"%s%d\t%s\t%d\t%d\n",string,i+1,gBusiness[i][bizzName],gBusiness[i][bizzProdOrderPrice],gBusiness[i][bizzProdOrder]);
						count_est++;
					}

					if(count_est == 0) return ErrorMessage(playerid,"Бизнесмены не оставляли заявки на доставку продуктов");
					D(playerid,dProdPut,DSTH,"Бизнес",string,"Выбрать","Отмена");
				}
				case 1: {
					switch(car) {
						case 456: EnableGPSForPlayer(playerid, 1144.7769,1975.1379,10.8203);
						case 609: SetPlayerCheckpoint(playerid, -159.3170,-289.3537,3.9053, 4.0);
					}
				}
			}
		}
		case dProdPut: {

			if(!response) {
				return 1;
			}

			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ErrorMessage(playerid, "Вы должны быть за рулем автомобиля");

			new
			    veh = GetPlayerVehicleID(playerid),
				car = GetVehicleModel(veh);

			//if(car == 403 && !GetVehicleTrailer(veh)) return ErrorMessage(playerid,"У Вас нет цистерны с топливом");

			if(!GetPVarInt(playerid,"count_prod")) return ErrorMessage(playerid,"В Вашей машине отсутствуют продукты");

			prod_id[playerid] = strval(inputtext); // особенность DSTH, inputtext - содержание первого столбца, т.е id бизнеса
			new biz = prod_id[playerid]-1;

			switch(car)
			{
				case 456: if(gBusiness[biz][bizzType] == 7) return ErrorMessage(playerid,"Неверно указан номер бизнеса");
				case 609: if(gBusiness[biz][bizzType] != 7) return ErrorMessage(playerid,"Неверно указан номер бизнеса");
			}

			new string[256];
			format(string, sizeof(string), ""W"Бизнес: "O"%s\n"W"Цена за 1 продукт: "GREEN"$%d\n"W"Требуется продуктов: "O"%d", gBusiness[biz][bizzName],gBusiness[biz][bizzProdOrderPrice],gBusiness[biz][bizzProdOrder]);
			D(playerid,DIALOG_NONE,DSM, ""P"Бизнес",string,"Закрыть","");

			format(string,144,""W"%s: "GREEN"%d/2000\n"W"Бизнес: "GREEN"%s", (car == 456) ? ("Продукты") : ("Бензин"), GetPVarInt(playerid,"count_prod"),gBusiness[biz][bizzName]);
			UpdateDynamic3DTextLabelText(gPlayerProdText[playerid],COLOR_BLUE,string);

			SetPVarInt(playerid,"prod_id", biz + 1);

			SCM(playerid, COLOR_YELLOW, "Местоположение бизнеса отмечено у вас на GPS");
			if(gBusiness[biz][bizzID] != 20 || gBusiness[biz][bizzType] != 18) {
				gPlayerProdCP[playerid] = CreateDynamicCP(gBusiness[biz][bizzX] + (3.5 * floatsin(-gBusiness[biz][bizzR], degrees)),gBusiness[biz][bizzY] + (3.5 * floatcos(-gBusiness[biz][bizzR], degrees)),gBusiness[biz][bizzZ],8.0,-1,-1,playerid,100.0);
				EnableGPSForPlayer(playerid, gBusiness[biz][bizzX] + (3.5 * floatsin(-gBusiness[biz][bizzR], degrees)),gBusiness[biz][bizzY] + (3.5 * floatcos(-gBusiness[biz][bizzR], degrees)),gBusiness[biz][bizzZ]);
			}
			else if(gBusiness[biz][bizzType] == 18) {
				gPlayerProdCP[playerid] = CreateDynamicCP(645.5316,-1468.6841,14.5592,8.0,-1,-1,playerid,100.0); // perfomance tuning
				EnableGPSForPlayer(playerid, 645.5316,-1468.6841,14.5592);
			}
			else if(gBusiness[biz][bizzID] == 20) {
				gPlayerProdCP[playerid] = CreateDynamicCP(693.7745,1948.5906,5.5432,8.0,-1,-1,playerid,100.0);
				EnableGPSForPlayer(playerid, 693.7745,1948.5906,5.5432);
			}
			return 1;
		}
		case D_BUKSIR: {
			if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(PI[playerid][pCash] < 500) {
				ErrorMessage(playerid, "У Вас не достаточно денег для аренды буксира");
				RemovePlayerFromVehicleAC(playerid);
				return 0;
			}
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
			SendOk(playerid, "Для просмотра доступных заказов, введите - "W"/repairs");
			GiveMoney(playerid,-500,"аренда буксира");
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
			SetPVarInt(playerid,"mehjob", GetPlayerVehicleID(playerid));
			PlayerMehText[playerid] = CreateDynamic3DTextLabel(""G"Топлива нет",-1,0.0,0.0,0.0,15.0,INVALID_PLAYER_ID,GetPlayerVehicleID(playerid));
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,PlayerMehText[playerid],E_STREAMER_ATTACH_OFFSET_Z, 2.0);
			return 1;
		}
		case dProdRent: {
			if(GetPlayerState(playerid) != 2) return 1;
			if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(GetPlayerMoneyEx(playerid) < 500) return ErrorMessage(playerid,"У Вас недостаточно средств"),RemovePlayerFromVehicleAC(playerid);
			GiveMoney(playerid,-500,"аренда транспорта(развозчики)");
			new veh = GetPlayerVehicleID(playerid);
			DeletePVar(playerid,"prod_id");
			SetPVarInt(playerid,"prod_vehicle_id",veh);
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
			new string[70];
			format(string,sizeof(string),"Загружено: "GREEN"%d/2000\n"W"Бизнес: "GREEN"Отсутствует", GetPVarInt(playerid,"count_prod"));
			gPlayerProdText[playerid] = CreateDynamic3DTextLabel(string,-1, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, GetPlayerVehicleID(playerid));
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerProdText[playerid],E_STREAMER_ATTACH_OFFSET_Y, -0.5);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,gPlayerProdText[playerid],E_STREAMER_ATTACH_OFFSET_Z, 2.0);
			SendOk(playerid,"Транспорт для развозки продуктов/топлива арендован. Управление заказами - "W"/prods");
			SetPlayerCheckpoint(playerid, -159.3170,-289.3537,3.9053, 4.0);
			return 1;
		}
		case dEatRent: {
			if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(PI[playerid][pCash] < 500) {
				ErrorMessage(playerid, "У Вас не достаточно денег для аренды авто для продажи еды");
				RemovePlayerFromVehicleAC(playerid);
				return 0;
			}
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
			GiveMoney(playerid,-500,"аренда развозчика еды");
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
			SetPVarInt(playerid,"eatjob", GetPlayerVehicleID(playerid));
			PlayerEatText[playerid] = CreateDynamic3DTextLabel(""G"Хот-догов: "P"0 ед.",-1,0.0,0.0,0.0,15.0,INVALID_PLAYER_ID,GetPlayerVehicleID(playerid));
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL,PlayerEatText[playerid],E_STREAMER_ATTACH_OFFSET_Z, 2.0);
			return 1;
		}
		case dProdGet: {
			if(!response) return 1;
			if(GetPlayerState(playerid)!=PLAYER_STATE_DRIVER) return 1;
			if(strval(inputtext) < 1000 || strval(inputtext) > 2000) {
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609) {
					return D(playerid,dProdGet,DSI, ""P"Покупка топлива","\n\n"W"Введите количество литров для покупки:\nПримечание: "ORANGE"1"W" литр = "GREEN"$1\n\n"NO"*"G" От 1000 до 2000\n\n","Купить","Отмена");
				}
				else return D(playerid,dProdGet,DSI, ""P"Покупка продуктов","\n\n"W"Введите количество продуктов для покупки:\nПримечание: "ORANGE"1"W" продукт = "GREEN"$1\n\n"NO"*"G" От 1000 до 2000\n\n","Купить","Отмена");
			}
			if(GetPVarInt(playerid,"count_prod") + strval(inputtext) > 2000) {
				if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 609) {
					return D(playerid,dProdGet,DSI, ""P"Покупка топлива","\n\n"W"Введите количество литров для покупки:\nПримечание: "ORANGE"1"W" литр = "GREEN"$1\n\n"NO"*"G" В Вашу машину столько не влезет. Максимум 2000\n\n","Купить","Отмена");
				}
				else return D(playerid,dProdGet,DSI, ""P"Покупка продуктов","\n\n"W"Введите количество продуктов для покупки:\nПримечание: "ORANGE"1"W" продукт = "GREEN"$1\n\n"NO"*"G" В Вашу машину столько не влезет. Максимум 2000\n\n","Купить","Отмена");
			}
			if(GetPlayerMoneyEx(playerid) < strval(inputtext)) return ErrorMessage(playerid,"Недостаточно средств");

			GiveMoney(playerid,-strval(inputtext),"покупка продуктов(развозчик)");
			new string[128];
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 609) {
				format(string,sizeof(string),"Вы купили: "P"%d"G" ед. продуктов за "ORANGE"$%d"G". Ожидайте загрузку продуктов",strval(inputtext),strval(inputtext));
				SendUse(playerid,string);
				SetTimerEx("LoadProd",0,0,"i",playerid);
			}
			else {
				format(string,sizeof(string),"Вы купили: "P"%d"G" л. топлива за "ORANGE"$%d"G". Ожидайте загрузку топлива",strval(inputtext),strval(inputtext));
				SendUse(playerid,string);
				DisablePlayerCheckpoint(playerid);
				SetTimerEx("LoadProd",0,0,"i",playerid);
			}
			SetPVarInt(playerid,"count_prod2", strval(inputtext));
			return 1;
		}
		case dProdSell: {
			if(!response) return 1;
			new bizid = GetPVarInt(playerid,"prod_id")-1;
			new prod = GetPVarInt(playerid,"count_prod");
			new price = strval(inputtext);
			new string[286],str[10];
			switch(GetVehicleModel(GetPlayerVehicleID(playerid))) {
				case 456: str = "продуктов";
				case 609: str = "топлива";
			}
			if(price < 1 || price > 2000) {
				format(string, sizeof(string), ""W"Бизнес: "P"%s\n\n\
											"W"Требуется %s: "O"%d\n\
											"W"Доступно для разгрузки: "O"%d\n\
											"W"Введите кол-во %s для продажи:\n\n\
											"NO"*"G" От 1 ед до 2000 ед",
											gBusiness[bizid][bizzName],str,gBusiness[bizid][bizzProdOrder],prod,str);
				return D(playerid,dProdSell,DSI, ""P"Доставка",string,"Продать","Отмена");
			}
			if(gBusiness[bizid][bizzProdOrder] < price) {
				format(string, sizeof(string), ""W"Бизнес: "P"%s\n\n\
											"W"Требуется %s: "O"%d\n\
											"W"Доступно для разгрузки: "O"%d\n\
											"W"Введите кол-во %s для продажи:\n\n\
											"NO"*"G" Владелец бизнеса не заказывал столько %s"
											,gBusiness[bizid][bizzName],str,gBusiness[bizid][bizzProdOrder],prod,str,str);
				return D(playerid,dProdSell,DSI, ""P"Доставка",string,"Продать","Отмена");
			}
			if(prod < price) {
				format(string, sizeof(string), ""W"Бизнес: "P"%s\n\n\
											"W"Требуется %s: "O"%d\n\
											"W"Доступно для разгрузки: "O"%d\n\
											"W"Введите кол-во %s для продажи:\n\n\
											"NO"*"G" В Вашей машине нет столько %s"
											,gBusiness[bizid][bizzName],str,gBusiness[bizid][bizzProdOrder],prod,gBusiness[bizid][bizzProdOrder],str,str);
				return D(playerid,dProdSell,DSI, ""P"Доставка",string,"Продать","Отмена");
			}

			GiveMoney(playerid,gBusiness[bizid][bizzProdOrderPrice] * price,"оплата развозчику");

			gBusiness[bizid][bizzProdOrder] -= price;
			gBusiness[bizid][bizzProduct] += price;

			format(string, sizeof(string), ""W"Бизнес: "P"%s\n\n\
											"W"Продуктов доставлено: "O"%d\n\
											"W"Требуется продуктов: "O"%d\n\
											"W"Заработано: "GREEN"$%d",gBusiness[bizid][bizzName],price,gBusiness[bizid][bizzProdOrder],gBusiness[bizid][bizzProdOrderPrice] * price);
			D(playerid,DIALOG_NONE,DSM, ""P"Доставлено",string,"Закрыть","");

			if(gBusiness[bizid][bizzProdOrder] == 0) gBusiness[bizid][bizzProdOrderPrice] = 0;
			SaveBusiness(bizid);

			DeletePVar(playerid,"prod_id");
			SetPVarInt(playerid,"count_prod", GetPVarInt(playerid,"count_prod") - price);

            new string_3dtext[70];

			format(string_3dtext,sizeof(string_3dtext),"Загружено: "GREEN"%d/2000\n"W"Бизнес: "GREEN"Отсутствует", GetPVarInt(playerid,"count_prod"));
			UpdateDynamic3DTextLabelText(gPlayerProdText[playerid],-1,string_3dtext);
			UpdateBusinessText(bizid);

			if(gPlayerProdCP[playerid] != -1) DestroyDynamicCP(gPlayerProdCP[playerid]);
			return 1;
		}
		case D_AUTOSALON:{
			if(!response) return 1;
			switch(listitem){
				case 0:{
					new vw;
					switch(GetPlayerVirtualWorld(playerid)){
						case 1: vw = GetPVarInt(playerid,"sellcarClass")+1;
						case 2: vw = GetPlayerVirtualWorld(playerid)-1;
						case 3: vw = GetPVarInt(playerid,"sellcarClass")+1;
						case 4: vw = GetPlayerVirtualWorld(playerid)-1;
					}
					SetPlayerPosAC(playerid, 1449.4907,702.5972,1087.9011, vw, 82);
					SetPlayerFacingAngle(playerid,88.9930);
					SetCameraBehindPlayer(playerid);
				}
				case 1:{
					new id = TI[playerid][tSelectedBusinessID];
					TI[playerid][tTPpick] = true;
					SetPlayerPosAC(playerid, gBusiness[id][bizzX],gBusiness[id][bizzY],gBusiness[id][bizzZ], 0, 0);
					SetPlayerFacingAngle(playerid,gBusiness[id][bizzR]);
					SetCameraBehindPlayer(playerid);
				}
			}
		}
		case D_BUY_CAR: {
			if(!response) return true;
			if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет дома/номера в отеле");
			new string[128];
			format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
			D(playerid,D_BUY_CAR_2,DSL,""P"Автосалон",string,"Купить","Закрыть");
		}
		case D_BUY_CAR_2: {
			if(!response) return 1;
			new businessid = TI[playerid][tSelectedBusinessID];
			if(businessid < 0) return true;
			new carid = GetPVarInt(playerid,"car_number");
			DeletePVar(playerid,"car_number");
			new price = gTransport[carid][trPrice];
			if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет дома/номера в отеле");
			if(gPlayerCars[playerid][carModel][listitem] != 481) return ErrorMessage(playerid,"Для начала продайте автомобиль на данном слоте");

			new prices;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(price/100*vip_status[PI[playerid][pVips]][vip_buycar]);
				if(PI[playerid][pCash] < (price-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
				GiveMoney(playerid,-(price-seller),"покупка авто");
				prices = (price-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(price/100*BonusInfo[act_buycar]);
					if(PI[playerid][pCash] < (price-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					GiveMoney(playerid,-(price-seller),"покупка авто");
					prices = (price-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(price/100*BonusInfo[act_buycar]);
					if(PI[playerid][pCash] < (price-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					GiveMoney(playerid,-(price-seller),"покупка авто");
					prices = (price-seller);
				}
			    else {
			    	if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно средств");
			    	GiveMoney(playerid,-price,"покупка авто");
			    	prices = price;
			    }
			}

			gPlayerCars[playerid][carModel][listitem] = gTransport[carid][trModel];
			gPlayerCars[playerid][carFuel][listitem] = gTransport[carid][trTank];
			gPlayerCars[playerid][carDrived][listitem] = 0;
			save_car(playerid,listitem);
			loading_cars(playerid,listitem);

			if(gBusiness[businessid][bizzProduct]-gTransport[carid][trProds] > 0) {
				gBusiness[businessid][bizzProduct] -= gTransport[carid][trProds];
				switch(GetPVarInt(playerid,"sellcarClass")) {
					case 1: bizz_pay(businessid,floatround(price * 0.095));//LS
					case 3: bizz_pay(businessid,floatround(price * 0.095));//SF
					case 5: bizz_pay(businessid,floatround(price * 0.0495));//LV
					case 6: bizz_pay(businessid,floatround(price * 0.075));//Мото
				}
			}
			UpdateBusinessText(businessid);

			static const fmt_str[] = "\
				"W"Поздравляем с покупкой автомобиля: "P"%s\n\n\
				"W"Автомобиль куплен за: "GREEN"$%d\n\
				"W"И доставлен к Вашему дому";

			new string[sizeof(fmt_str) + 4 * 5 + 1 + (-4 + 32 + 11)];
			format(string, sizeof(string), fmt_str, gTransport[carid][trName],prices);
			D(playerid,DIALOG_NONE,DSM, ""P"Автосалон",string,"Спасибо","");
		}
		case D_MEDCARD:{
			if(!response) return 1;

			new price;
			if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
				new seller = floatround(1000/100*BonusInfo[act_medcard]);
				if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств. Стоимость медкарты - $1.000");
				price = (1000-seller);
			}
			else if(BonusInfo[act_select] == 2) {
				new seller = floatround(1000/100*BonusInfo[act_medcard]);
				if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств. Стоимость медкарты - $1.000");
				price = (1000-seller);
			}
		    else price = 1000;

			use_medcards(playerid);
			GiveMoney(playerid,-price,"получение мед карты");

			if(QuestProgress[playerid][4] < 1 && AcceptQuest[playerid][4] != 0) {
				QuestProgress[playerid][4] ++,save_quest(playerid,4);
				D(playerid,DIALOG_NONE,DSM, ""P"Квест",""W"Вы успешно получили медицинскую карту. Данное задание можно завершить и забрать за него награду","Закрыть","");
				NextStapQI(playerid,4);
			}

			FI[fWHITEHOUSE][fBank] += price;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
		}
		case D_MEDSEX:{
			if(!response) return 1;
			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(50000/100*vip_status[PI[playerid][pVips]][vip_changesex]);
				price = (50000-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(50000/100*BonusInfo[act_changesex]);
					price = (50000-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(50000/100*BonusInfo[act_changesex]);
					price = (50000-seller);
				}
			    else price = 50000;
			}
		    if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"У Вас недостаточно денег для операции. Стоимость операции - $50.000");
		    use_medsex(playerid);
			GiveMoney(playerid,-price,"смена пола");
			FI[fWHITEHOUSE][fBank] += price;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
		}
		case D_SU: {
			if(!response) return 1;
			SetPVarInt(playerid,"su_listitem",listitem);
			D(playerid,D_SU_2,DSL,""P"Преступление",suspect_player[listitem][suspect_name_reason],"Выбрать","Назад");
			return 1;
		}
		case D_SU_2: {
			new params[2];
			params[1] = GetPVarInt(playerid,"su_listitem");
			new string[128];
			if(!response || suspect_player[params[1]][suspect_level][listitem] == -1) {
				strcat(string, ""W"");
				for(new i=0; i<13; i++) {
					format(string,sizeof(string),"%s%s\n",string,suspect_player[i][suspect_name_folder]);
				}
				D(playerid,D_SU,DSL,""P"Преступление",string,"Выбрать","Закрыть");
				DeletePVar(playerid,"su_listitem");
				return 1;
			}
			params[0] = GetPVarInt(playerid,"su_player");

			static const fmt_str_local[] = "%s объявил Вас в розыск. Причина: %s";
			static const fmt_str_global[] = "[Внимание] %s объявлен(а) в розыск [%d/6]. Обвинитель: %s. Причина: %s";
			
			new
				string_local[sizeof(fmt_str_local) + (-4 + MAX_PLAYER_NAME + 32)],
				string_global[sizeof(fmt_str_global) + (-8 + MAX_PLAYER_NAME * 2 + 1 + 32)];

			format(string_local, sizeof(string_local), fmt_str_local, player_name[playerid],inputtext);
			format(string_global,sizeof(string_global), fmt_str_global ,player_name[params[0]],PI[params[0]][pSearch],player_name[playerid],inputtext);
		
			SendClientMessage(params[0],CBADINFO,string_local);
			SendTeamMessage(CDEPARTMENT,string_global);

			PI[params[0]][pSearch] += suspect_player[params[1]][suspect_level][listitem];
			SetPlayerCriminal(params[0],player_name[playerid], inputtext);


			ANDROID_SetPlayerWantedLevel(params[0], PI[params[0]][pSearch]);

/* 			PlayerTextDrawSetString(params[0], mobile_local_hud[params[0]][6], "txd:wanted_0");
			PlayerTextDrawShow(params[0], mobile_local_hud[params[0]][6]); */

			DeletePVar(playerid,"su_player");
			DeletePVar(playerid,"su_listitem");
			return 1;
		}
		case D_TAZER: {
			if(!response ) return 1;
			for(new i; i <= 11; i++) {
				new gunid, ammo, storeslot = -1;
				GetPlayerWeaponData(playerid, i, gunid,ammo);
				new gun_text[32];
				GetWeaponName(gunid,gun_text,32);
				switch(gunid) {
					case 24,25: if(strfind(inputtext,gun_text) != -1) storeslot ++;
				}
				if(!gunid || !ammo || storeslot == -1) continue;
				if(storeslot != -1) {
					new string[97];

					format(string,97,""P"%s"G" успешно заряжено парализующими патронами [2 шт]",gun_text);
					SendUse(playerid,string);

					string[0] = EOS;
					format(string, 66,"заряжает %s парализующими патронами",gun_text);
					MeAction(playerid,string);

					TI[playerid][tTazers][0] = 2;
					TI[playerid][tTazers][1] = gunid;
					break;
				}
			}
			return 1;
		}
		case dInviteSkin: {
			new string[156];
			format(string, sizeof(string), ""P"%s"G" предложил Вам вступить в организацию "ORANGE"%s",player_name[playerid],FI[PI[playerid][pMember]][fName]);
			SendUse(GetPVarInt(playerid,"invkot"), string);
			SendClientMessage(GetPVarInt(playerid,"invkot"), COLOR_BLUE,"Нажмите "YES"Y "BLUE"чтобы согласиться "NO"N "BLUE"для отказа");

			format(string, sizeof(string),"Вы предложили "P"%s"G" вступить в организацию "ORANGE"%s",player_name[GetPVarInt(playerid,"invkot")],FI[PI[playerid][pMember]][fName]);
			SendUse(playerid, string);

	        SetPVarInt(GetPVarInt(playerid,"invkot"),"invstat",GetPVarInt(playerid,"invkot"));
			SetPVarInt(GetPVarInt(playerid,"invkot"),"invinv",playerid);
			SetPVarInt(GetPVarInt(playerid,"invkot"),"invskin",gFractionSkin[PI[playerid][pMember]][listitem]);

			DeletePVar(playerid, "invkot");
		}
		case dFractionSkin: {
			if(!response) return 1;
			new actplayerid = GetPVarInt(playerid,"params[0]");
			if(!IsPlayerConnected(actplayerid) || PI[actplayerid][pMember] != PI[playerid][pMember]) return 1;
			new fractionid = PI[actplayerid][pMember];
			new skinid = gFractionSkin[fractionid][listitem];
			if(skinid == PI[actplayerid][pFracSkin]) return 1;

			static const fmt_str_target[] = "Ваша внешность была изменена лидером организации "P"%s[%d]";
			static const fmt_str_player[] = "Вы изменили внешность игрока "P"%s[%d]";
			
			new
				string_target[sizeof(fmt_str_target) + 5 + (-4 + MAX_PLAYER_NAME + 4)],
				string_player[sizeof(fmt_str_player) + 5 + (-4 + MAX_PLAYER_NAME + 4)];

			format(string_target, sizeof(string_target), fmt_str_target, player_name[playerid],playerid);
			format(string_player,sizeof(string_player), fmt_str_player, player_name[actplayerid],actplayerid);

			SendUse(actplayerid, string_target);
			SendUse(playerid, string_player);
			UpdatePlayerData(actplayerid,"pModel",skinid);
			PI[actplayerid][pFracSkin] = skinid;

			if(start_work[actplayerid]) A_SetPlayerSkin(actplayerid,skinid);
		}
		case dRank: {
			if(!response) return 1;
			if(listitem == -1) return 1;
			if(PI[playerid][pRank] <= listitem) return ErrorMessage(playerid, "Ваш ранг недостаточен");
			new rank_id = GetPVarInt(playerid,"id_giverank"),string[128];

			format(string,sizeof(string),"Вы повысили/понизили "P"%s"G" до ранга "ORANGE"%s",player_name[rank_id],GetRankName(PI[playerid][pMember],listitem+1));
			SendUse(playerid,string);

			format(string,sizeof(string),"Вас повысил/понизил "P"%s"G" до ранга "ORANGE"%s",player_name[playerid],GetRankName(PI[playerid][pMember],listitem+1));
			SendUse(rank_id,string);

			PI[rank_id][pRank] = listitem + 1;
			UpdatePlayerData(rank_id,"pRank",PI[rank_id][pRank]);

			new rangs[4];
			format(rangs,sizeof(rangs),"%d",PI[rank_id][pRank]);
			FracLog(LOGS_RANK,player_name[playerid],player_name[rank_id],rangs);
			DeletePVar(playerid,"id_giverank");
			return 1;
		}
		case D_CALL_SERVICESS: {
			if(!response) return 1;
			if(GetPlayerVirtualWorld(playerid) != 0) return ErrorMessage(playerid,"Для вызова служб спасения выйдите из помещения");
			new Float:pos[3];
            GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
			switch(listitem) {
				case 0: {
					new bool:online = false;
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!IsACop(i) && !start_work[playerid]) continue;
						if(!IsPlayerInRangeOfPoint(i, 1000.0, pos[0],pos[1],pos[2])) continue;
						online = true;
						break;
					}
					if(!online) return ErrorMessage(playerid,"Диспетчер: в данный момент, нет полицейских поблизости");
					SendOk(playerid, "Диспетчер: Ваш вызов принят, ожидайте...");
					SetPVarInt(playerid,"call_police",1);
				}
				case 1: {
					new bool:online = false;
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!IsAMedic(i) && !start_work[playerid]) continue;
						if(!IsPlayerInRangeOfPoint(i, 1000.0, pos[0],pos[1],pos[2])) continue;
						online = true;
						break;
					}
					if(!online) return ErrorMessage(playerid,"Диспетчер: в данный момент, нет медиков поблизости");
					SendOk(playerid, "Диспетчер: Ваш вызов принят, ожидайте...");
					SetPVarInt(playerid,"call_medics",1);
				}
				case 2: {
					new online = 0;
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(PI[i][pJob] != 2) continue;
						if(!IsPlayerInRangeOfPoint(i, 1000.0, pos[0],pos[1],pos[2])) continue;
						online = true;
						break;
					}
					if(!online) return ErrorMessage(playerid,"Диспетчер: в данный момент, нет механиков поблизости");
					SendOk(playerid, "Диспетчер: Ваш вызов принят, ожидайте...");
					SetPVarInt(playerid,"call_mechanics",1);
				}
			}
		}
/* 		case D_TOW: {
			if(!response) return true;
			new trailer = GetPlayerVehicleID(playerid);
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || !trailer) return true;
			new offer = GetPVarInt(playerid,"towoffer");
			if(GetPlayerDistanceToPlayer(playerid,offer) > 10.0 || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(offer)) return ErrorMessage(playerid,"Вы далеко друг от друга");
			RemovePlayerFromVehicleAC(playerid);
			new vehicleid = TI[playerid][tArendaCar];
			SetTimerEx("AttachTrailerToVehicleEx",3000,false,"ii",trailer,vehicleid);
			SetPVarInt(playerid,"towoffe",playerid);
			SendOk(playerid,"Буксировка транспортного средства...");
		} */
		case dEndWork: {
			if(!response) return 1;
			callcmd::endwork(playerid);
		}
		case D_MAKEGUN: {
			if(!response) return 1;
			new needgun = MakeGunData[listitem][mgunamount];
			new bool:noneedgun;
			SetPVarInt(playerid,"noneedgun",0);
			for(new i;i<12;i++) {
				new weapid,ammot;
				GetPlayerWeaponData(playerid,i,weapid,ammot);
				if(weapid == MakeGunData[listitem][mgunid]) {noneedgun = true; SetPVarInt(playerid,"noneedgun",1); break;}
			}
			if(PI[playerid][pMats] < needgun && !noneedgun) {
				new string[64];
				format(string, sizeof(string), "Вам нужно %d ед. оружия для сборки этого оружия",needgun);
				ErrorMessage(playerid,string);
				return 1;
			}
			D(playerid,D_MAKEGUN_2,DSI, ""P"Сборка оружия","\n\n"W"Сколько патронов вы хотите использовать для этого оружия?\n\n","Собрать","Отмена");
			SetPVarInt(playerid,"makegun_listitem",listitem);
			return 1;
		}
		case D_MAKEGUN_2: {
			if(!response) return 1;
			new ammos = strval(inputtext);
			new listitem_gun = GetPVarInt(playerid,"makegun_listitem");
			if(ammos < 1 || ammos > 200) return D(playerid,D_MAKEGUN_2,DSI, ""P"Сборка оружия","\n\n"W"Сколько патронов вы хотите использовать для этого оружия?\n\n"NO"*"G" От 1 до 200 патронов\n\n","Собрать","Отмена");
			if(PI[playerid][pMats]<(ammos+MakeGunData[listitem_gun][mgunamount]) && !GetPVarInt(playerid,"noneedgun")) return ErrorMessage(playerid, "Недостаточно боеприпасов");
			if(PI[playerid][pMats]<ammos && GetPVarInt(playerid,"noneedgun")) return ErrorMessage(playerid, "Недостаточно боеприпасов");
			DeletePVar(playerid,"makegun_listitem");
			MeAction(playerid,"собрал(а) оружие");
			if(!GetPVarInt(playerid,"noneedgun")) PI[playerid][pMats] -= MakeGunData[listitem_gun][mgunamount];
			SetPVarInt(playerid,"noneedgun",0);

			PI[playerid][pMats] -= ammos;
			UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);

			if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) AC_GivePlayerWeapon(playerid,MakeGunData[listitem_gun][mgunid],ammos*BonusInfo[act_gun]);
			else if(BonusInfo[act_select] == 2) AC_GivePlayerWeapon(playerid,MakeGunData[listitem_gun][mgunid],ammos*BonusInfo[act_gun]);
		    else AC_GivePlayerWeapon(playerid,MakeGunData[listitem_gun][mgunid],ammos);
			return 1;
		}
		case D_BIZWAR: {
			if(response) {
				SendClientMessage(playerid,0x3399FFFF,"Откройте карту и поставьте правой кнопкой мыши метку там, где будет стрела");
				SetPVarInt(playerid,"bizwar_selectpoint",1);
				//D(playerid, D_BIZWAR_LIST, DSL, ""P"Выбор места", ""P"1."W" Метеостанция\n"P"2."W" Деревня СВ-ВВС\n"P"3."W" Каменная деревня\n"P"4."W" Порт СФ\n"P"5."W" Вестоун\n"P"6."W" Угольная шахта\n"P"7."W" Порт ЛС", "Выбрать", "Отмена");
			}
			else {
				ErrorMessage(playerid, "Вы отменили захват");
				DeletePVar(playerid, "bizwar_id");
			}
			return 1;
		}
		case D_BIZWAR_CONFIRM: {
			if(response) {
				new i = GetPVarInt(playerid,"bizwar_id");
				DeletePVar(playerid, "bizwar_id");
				DeletePVar(playerid, "bizwar_selectpoint");

				if(BizWarTime > 0) return ErrorMessage(playerid, "Война за бизнес уже идет");
				if(bizwar_kd[PI[playerid][pMember]] > unix) {
					new year, month, day, hour, minute, second;
					new string[128];
					timestamp_to_date(bizwar_kd[PI[playerid][pMember]] - unix, year, month, day, hour, minute, second);
					format(string,128,"Таймер до следующего захвата {1965D9}[%02d:%02d:%02d]", hour, minute, second);
					ErrorMessage(playerid, string);
					return 1;
				}
				if(PI[playerid][pMember] == gBusiness[i][bizzMafia]) return ErrorMessage(playerid,"Вы не можете захватить собственный бизнес");

				if(!IsPlayerInBandOnline(gBusiness[i][bizzMafia])) return ErrorMessage(playerid, "Мафия на которую Вы собираетесь напасть нет в сети / Меньше трёх человек");
				new gang1 = -1;
				switch(PI[playerid][pMember]) {
					case fLCN: gang1 = MOROZ_LCN;
					case fYAKUZA: gang1 = MOROZ_YAKUZA;
					case fRM: gang1 = MOROZ_RM;
				}
				if(gang1 != -1) {
					if(fracmoroz[gang1] > unix) return ErrorMessage(playerid, "Ваша мафия не может принимать участия в войнах. (заморожена администратором)");
				}
				new Float:x, Float:y;
				x = GetPVarFloat(playerid,"bizwar_selectpointX");
				y = GetPVarFloat(playerid,"bizwar_selectpointY");

				DeletePVar(playerid, "bizwar_selectpoint");
				DeletePVar(playerid, "bizwar_selectpointX");
				DeletePVar(playerid, "bizwar_selectpointY");

				bizwar_coordinates[0] = x - 65.0; // min x
				bizwar_coordinates[1] = y - 65.0; // min y
				bizwar_coordinates[2] = x + 65.0; // max x
				bizwar_coordinates[3] = y + 65.0; // max y

				SendOk(playerid,"Место проведения стрелы успешно установлено.");
				biz_war_gangzone = GangZoneCreate(bizwar_coordinates[0], bizwar_coordinates[1], bizwar_coordinates[2], bizwar_coordinates[3]);
				GangZoneShowForAll(biz_war_gangzone, 0xFF0000AA);

				BizWarTime = 60*15;
				MZInfo[bNapad] = PI[playerid][pMember];
				MZInfo[bFrakVlad] = gBusiness[i][bizzMafia];
				MZInfo[bBiz] = i;
				MZInfo[bCountDead][MZInfo[bNapad]] = 0;
				MZInfo[bCountDead][MZInfo[bFrakVlad]] = 0;

				//GangZoneFlashForAll(biz_war_gangzone, 0xFF0000FF);

				static const
					fmt_str_first[] = "%s забила стрелу Вашей мафии за бизнес %s. встречи обозначено на карте",
					fmt_str_second[] = "Ваша мафия забила стрелу %s за бизнес %s. Место встречи обозначено на карте",
					fmt_str_general[] = "Начал захват бизнеса: %s"; // общий string
				new
					string_first[sizeof(fmt_str_first) + (-4 + 32 * 2)],
					string_second[sizeof(fmt_str_second) + (-4 + 32 * 2)],
					string_general[sizeof(fmt_str_general) + (-2 + 32)];

				format(string_first,sizeof(string_first), fmt_str_first, GetMN(PI[playerid][pMember]),gBusiness[i][bizzName]);
				SendFamilyMessage(gBusiness[i][bizzMafia],0xFF0000FF,string_first);

				format(string_general, sizeof(string_general), fmt_str_general, player_name[playerid]);

				SendFamilyMessage(gBusiness[i][bizzMafia],-1,string_general);

				format(string_second,sizeof(string_second), fmt_str_second, GetMN(gBusiness[i][bizzMafia]),gBusiness[i][bizzName]);
				SendFamilyMessage(PI[playerid][pMember],0xFF0000FF,string_second);

				SendFamilyMessage(PI[playerid][pMember],-1,string_general);
			}
			else {
				ErrorMessage(playerid, "Вы отменили захват");
				DeletePVar(playerid, "bizwar_id");
				DeletePVar(playerid, "bizwar_selectpoint");
				DeletePVar(playerid, "bizwar_selectpointX");
				DeletePVar(playerid, "bizwar_selectpointY");
			}
			return 1;
		}
		case D_ANIM: {
			if(!response) return 1;
			switch(listitem) {
				case 0: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE1);
				case 1: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE2);
				case 2: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE3);
				case 3: SetPlayerSpecialAction (playerid, SPECIAL_ACTION_DANCE4);
				case 4: GoAnim(playerid,"DEALER","Dealer_idle",4.1,1,0,0,0,0,0);
				case 5: ApplyAnimation(playerid,"DEALER","Dealer_Deal",4.1,0,0,0,0,0,1);
				case 6: ApplyAnimation(playerid,"FOOD","Eat_Burger",4.1,0,0,0,0,0,1);
				case 7: ApplyAnimation(playerid,"PAULNMAC","Piss_in",4.1,0,0,0,0,0,1);
				case 8: GoAnim(playerid,"PARK","Tai_Chi_Loop",4.1,1,0,0,0,0,0);
				case 9: GoAnim(playerid,"CRACK","Crckidle1",4.1,1,0,0,0,0,0);
				case 10: GoAnim(playerid,"CRACK","Crckidle2",4.1,1,0,0,0,0,0);
				case 11: GoAnim(playerid,"CRACK","Crckidle4",4.1,1,0,0,0,0,0);
				case 12: ApplyAnimation(playerid,"SWEET","sweet_ass_slap",4.1,0,0,0,0,0,1);
				case 13: GoAnim(playerid,"SPRAYCAN","spraycan_full",4.1,1,0,0,0,0,0);
				case 14: GoAnim(playerid,"GRAFFITI","spraycan_fire",4.1,1,0,0,0,0,0);
				case 15: GoAnim(playerid,"SMOKING","M_smkstnd_loop",4.1,1,0,0,0,0,0);
				case 16: GoAnim(playerid,"SHOP","ROB_Loop_Threat",4.1,1,0,0,0,0,0);
				case 17: ApplyAnimation(playerid,"SHOP","ROB_shifty",4.1,0,0,0,0,0,1);
				case 18: GoAnim(playerid,"PED","handsup",4.1,1,0,0,0,0,0);
				case 19: GoAnim(playerid,"RYDER","Ryd_Beckon_02",4.1,1,0,0,0,0,0);
				case 20: ApplyAnimation(playerid,"RIOT","Riot_Angry",4.1,0,0,0,0,0,0);
				case 21: GoAnim(playerid,"RIOT","Riot_Angry_B",4.1,1,0,0,0,0,0);
				case 22: GoAnim(playerid,"RIOT","Riot_Chant",4.1,1,1,0,0,0,0);
				case 23: GoAnim(playerid,"RIOT","Riot_Punches",4.1,1,0,0,0,0,0);
				case 24: ApplyAnimation(playerid,"PED","fucku",4.1,0,0,0,0,0,1);
				case 25: ApplyAnimation(playerid,"BAR","dnK_StndM_loop",4.1,0,0,0,0,0,1);
				case 26: GoAnim(playerid,"BD_FIRE","BD_Panic_03",4.1,1,0,0,0,0,0);
				case 27: GoAnim(playerid,"BD_FIRE","M_smklean_loop",4.1,1,0,0,0,0,0);
				case 28: GoAnim(playerid,"BEACH","bather",4.1,1,0,0,0,0,0);
				case 29: GoAnim(playerid,"BEACH","Lay_Bac_loop",4.1,1,0,0,0,0,0);
				case 30: GoAnim(playerid,"BEACH","Parksit_w_loop",4.1,1,0,0,0,0,0);
				case 31: GoAnim(playerid,"BEACH","Sitnwait_Loop_W",4.1,1,0,0,0,0,0);
				case 32: GoAnim(playerid,"BEACH","Parksit_M_loop",4.1,1,0,0,0,0,0);
				case 33: GoAnim(playerid,"benchpress","gym_bp_celebrate",4.1,1,0,0,0,0,0);
				case 34: GoAnim(playerid,"LOWRIDER","Rap_C_loop",4.1,1,0,0,0,0,0);
				case 35: GoAnim(playerid,"LOWRIDER","Rap_B_loop",4.1,1,0,0,0,0,0);
				case 36: GoAnim(playerid,"LOWRIDER","Rap_A_loop",4.1,1,0,0,0,0,0);
				case 37: GoAnim(playerid,"BSKTBALL","BBALL_idleloop",4.1,1,0,0,0,0,0);
				case 38: ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot",4.1,0,0,0,0,0,1);
				case 39: ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup",4.1,0,0,0,0,0,1);
				case 40: ApplyAnimation(playerid,"CAMERA","camstnd_cmon",4.1,0,0,0,0,0,1);
				case 41: GoAnim(playerid,"CAR","fixn_car_loop",4.1,1,0,0,0,0,0);
				case 42: GoAnim(playerid,"CAR_CHAT","car_talkm_loop",4.1,1,0,0,0,0,0);
				case 43: GoAnim(playerid,"COP_AMBIENT","coplook_loop",4.1,1,0,0,0,0,0);
				case 44: GoAnim(playerid,"CRACK","Bbalbat_Idle_01",4.1,1,0,0,0,0,0);
				case 45: GoAnim(playerid,"CRACK","Bbalbat_Idle_02",4.1,1,0,0,0,0,0);
				case 46: ApplyAnimation(playerid,"GHANDS","gsign1",4.1,0,0,0,0,0,1);
				case 47: ApplyAnimation(playerid,"GHANDS","gsign2",4.1,0,0,0,0,0,1);
				case 48: ApplyAnimation(playerid,"GHANDS","gsign3",4.1,0,0,0,0,0,1);
				case 49: ApplyAnimation(playerid,"GHANDS","gsign4",4.1,0,0,0,0,0,1);
				case 50: ApplyAnimation(playerid,"GHANDS","gsign5",4.1,0,0,0,0,0,1);
				case 51: ApplyAnimation(playerid,"GHANDS","gsign1LH",4.1,0,0,0,0,0,1);
				case 52: ApplyAnimation(playerid,"GHANDS","gsign2LH",4.1,0,0,0,0,0,1);
				case 53: ApplyAnimation(playerid,"GHANDS","gsign4LH",4.1,0,0,0,0,0,1);
				case 54: GoAnim(playerid,"GRAVEYARD","mrnF_loop",4.1,1,0,0,0,0,0);
				case 55: GoAnim(playerid,"MISC","seat_LR",4.1,1,0,0,0,0,0);
				case 56: GoAnim(playerid,"INT_HOUSE","Lou_in",4.1,0,1,1,1,1,0);
				case 57: GoAnim(playerid,"INT_OFFICE","OFF_sit_Bored_loop",4.1,1,0,0,0,0,0);
				case 58: GoAnim(playerid,"LOWRIDER","F_smklean_loop",4.1,1,0,0,0,0,0);
				case 59: ApplyAnimation(playerid,"MEDIC","CPR",4.1,0,0,0,0,0,1);
				case 60: GoAnim(playerid,"GANGS","LeanIn",4.1,0,1,1,1,1,0);
				case 61: GoAnim(playerid,"MISC","plyrlean_loop",4.1,1,0,0,0,0,0);
				case 62: ApplyAnimation(playerid,"MISC","plyr_shkhead",4.1,0,0,0,0,0,1);
				case 63: GoAnim(playerid,"MISC","scratchballs_01",4.1,1,0,0,0,0,0);
			}
			SetPVarInt(playerid,"Animation", 2);
			TextDrawShowForPlayer(playerid, AnimDraw);
			return 1;
		}
		case D_TAKE: {
			if(!response) return DeletePVar(playerid,"takelic");
			new acter = GetPVarInt(playerid,"takelic");
			if(!IsPlayerStream(10.0, playerid, acter)) return ErrorMessage(playerid, "Игрок не рядом с Вами");
			if(listitem < 4) {
				if(!lic[acter][listitem]) return ErrorMessage(playerid,"У игрока нет этой лицензии");
			}
			new string[156];
			if(listitem >= 4) {
				switch(listitem) {
					case 4: {
						if(!PI[acter][pDrugs]) return ErrorMessage(playerid,"У игрока нет наркотиков");
						format(string, sizeof(string), "Вы изъяли у "P"%s"G" наркотики", player_name[acter]);
						SendUse(playerid, string);
						format(string, sizeof(string), "Сотрудник "P"%s"G" изъял у Вас наркотики", player_name[playerid]);
						SendUse(acter, string);
						format(string, sizeof(string), "изъял(а) наркотики у %s", player_name[acter]);
						MeAction(playerid,string);

						PI[acter][pDrugs] = 0;
						UpdatePlayerData(playerid,"pDrugs",0);
					}
					case 5: {
						if(!PI[acter][pMats]) return ErrorMessage(playerid,"У игрока нет боеприпасов");
						format(string, sizeof(string), "Вы изъяли у "P"%s"G" боеприпасы", player_name[acter]);
						SendUse(playerid, string);
						format(string, sizeof(string), "Сотрудник "P"%s"G" изъял у Вас боеприпасы", player_name[playerid]);
						SendUse(acter, string);
						format(string, sizeof(string), "изъял(а) боеприпасы у %s", player_name[acter]);
						MeAction(playerid,string);
						PI[acter][pMats] = 0;
						UpdatePlayerData(playerid,"pMats",0);
					}
				}
				DeletePVar(playerid,"takelic");
				return 1;
			}
			new lics[28];
			switch(listitem) {
				case 0: lics = "на водительские права";
				case 1: lics = "пилота";
				case 2: lics = "на водный транспорт";
				case 3: lics = "на оружие";
			}
			format(string, sizeof(string), "Вы изъяли у "P"%s"G" лицензию %s", player_name[acter],lics);
			SendUse(playerid, string);
			format(string, sizeof(string), "Сотрудник "P"%s"G" изъял у Вас лицензию %s", player_name[playerid],lics);
			SendUse(acter, string);
			format(string, sizeof(string), "изъял(а) лицензию %s у %s",lics, player_name[acter]);
			MeAction(playerid,string);
			lic[acter][listitem]=0;
			UpdateLicenses(acter);
			DeletePVar(playerid,"takelic");
			return 1;
		}
		case D_ATM: {
			if(!response) return 1;
			new atm = GetNearestATM(playerid),percent;
			switch(ATMData[atm][atm_Bank]) {
				case 7: percent = FuncBizz[8][funcbPercent3];
				case 8: percent = FuncBizz[9][funcbPercent3];
				case 9: percent = FuncBizz[10][funcbPercent3];
				default:  percent = 1;
			}
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"На Вашем основном банковском счету доступно: "ORANGE"$%d\n\n"W"Введите сумму, которую хотите снять с основного банковского счёта:\nПримечание: комиссия за пользование банкоматом "P"%d%";
					new string[sizeof(f_str) +1 + (-2 + 11)];
					format(string,sizeof(string),f_str,PI[playerid][pBank],percent);
					D(playerid,D_ATM_INPUT,DSI, ""P"Снять деньги",string,"Снять","Отмена");
				}
				case 1: {
					static const f_str[] = ""W"На Вашем счету доступно: "ORANGE"$%d\n\n"W"Введите сумму, которую хотите положить на основной банковский счёт:\nПримечание: комиссия за пользование банкоматом "P"%d%";
					new string[sizeof(f_str) +1 + (-2 + 11)];
					format(string,sizeof(string),f_str,PI[playerid][pCash],percent);
					D(playerid,D_ATM_PUT,DSI, ""P"Положить деньги",string,"Положить","Отмена");
				}
				case 2: {
					if(!PI[playerid][pPhone]) return ErrorMessage(playerid,"У Вас нет мобильного телефона");
					static const f_str[] = ""W"Доступно средств наличными: "ORANGE"$%d\n\
											"W"На Вашем мобильном счету доступно: "ORANGE"$%d\n\n\
											"W"Введите сумму, которую хотите положить на мобильный счёт:\n\
											Примечание: комиссия за пользование банкоматом "P"%d%";
					new string[sizeof(f_str) +1 + (-2 + 11)];
					format(string,sizeof(string),f_str,PI[playerid][pCash],PI[playerid][pMobile],percent);
					D(playerid,D_ATM_PHONE,DSI, ""P"Оплата мобильного",string,"Снять","Отмена");
				}
			}
		}
		case D_ATM_INPUT: {
			if(!response) return ShowATMMenu(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 1000000) {
				D(playerid,D_ATM_INPUT,DSI, ""P"Выдача наличных","\n\n"W"Введите сумму, которую хотите снять с основного банковского счёта:\n\n"NO"*"G" От $1 до 1.000.000$\n\n","Снять","Назад");
				return 1;
			}
			if(PI[playerid][pBank] < amount) return D(playerid,D_ATM_INPUT,DSI, ""P"Выдача наличных",""W"Введите сумму, которую хотите снять с основного банковского счёта:\n\n"NO"*"G" Недостаточно средств","Снять","Назад");

			new atm = GetNearestATM(playerid),percent;
			switch(ATMData[atm][atm_Bank]) {
				case 7: percent = FuncBizz[8][funcbPercent3];
				case 8: percent = FuncBizz[9][funcbPercent3];
				case 9: percent = FuncBizz[10][funcbPercent3];
				default:  percent = 1;
			}
			//new plata = floatround((amount/100*percent)+amount);
			new payment = floatround(amount/100*(100 - percent)); // будет зачислено с учётом комиссии R.Ivanov
			PI[playerid][pBank] -= amount;
			UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
			GiveMoney(playerid, payment,"снятие с банк счета");

			bizz_pay(ATMData[atm][atm_Bank],floatround(amount - payment));

			static const f_str[] = ""W"Снято средств:\t\t"ORANGE"$%d"W" (комиссия: "P"%d)\n\
								"W"Баланс:\t\t\t"ORANGE"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,amount-payment,PI[playerid][pBank]);
			D(playerid,DIALOG_NONE,DSM, ""P"Выдача наличных",string,"Закрыть","");
		}
		case D_ATM_PUT: {
			if(!response) return ShowATMMenu(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 1000000) {
				D(playerid,D_ATM_PUT,DSI, ""P"Пополнение счёта","\n\n"W"Введите сумму которую хотите положить на основной банковский счёт:\n\n"NO"*"G" От $1 до $1000000\n\n","Положить","Назад");
				return 1;
			}
			if(PI[playerid][pCash] < amount) return D(playerid,D_ATM_PUT,DSI, ""P"Пополнение счёта",""W"Введите сумму которую хотите положить на основной банковский счёт:\n\n"NO"*"G" Недостаточно средств","Положить","Назад");

			new atm = GetNearestATM(playerid),percent;
			switch(ATMData[atm][atm_Bank]) {
				case 7: percent = FuncBizz[8][funcbPercent3];
				case 8: percent = FuncBizz[9][funcbPercent3];
				case 9: percent = FuncBizz[10][funcbPercent3];
				default:  percent = 1;
			}
			new payment = floatround(amount/100*(100 - percent)); // будет зачислено с учётом комиссии R.Ivanov

			PI[playerid][pBank] += payment;
			UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
			GiveMoney(playerid, -amount,"пополнение банк счета");

			bizz_pay(ATMData[atm][atm_Bank],floatround(amount-payment));

			static const f_str[] = ""W"Внесено средств:\t\t"ORANGE"$%d"W" (комиссия: "P"%d)\n\
								"W"Баланс:\t\t\t"ORANGE"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,amount-payment,PI[playerid][pBank]);
			D(playerid,DIALOG_NONE,DSM, ""P"Пополнение счёта",string,"Закрыть","");
		}
		case D_ATM_PHONE: {
			if(!response) return ShowATMMenu(playerid);
			new amount = strval(inputtext);
			if(amount < 1 || amount > 10000) return D(playerid,D_ATM_PHONE,DSI, ""P"Оплата мобильного счёта",""W"Введите сумму которую хотите положить:\n\n"NO"*"G" От $1 до $10.000","Положить","Назад");
			if(GetPlayerMoneyEx(playerid) < amount) return D(playerid,D_ATM_PHONE,DSI, ""P"Оплата мобильного счёта",""W"Введите сумму которую хотите положить:\n\n"NO"*"G" Недостаточно средств","Положить","Назад");

			new atm = GetNearestATM(playerid),percent;
			switch(ATMData[atm][atm_Bank]) {
				case 7: percent = FuncBizz[8][funcbPercent3];
				case 8: percent = FuncBizz[9][funcbPercent3];
				case 9: percent = FuncBizz[10][funcbPercent3];
				default:  percent = 1;
			}
			new payment = floatround(amount/100*(100 - percent)); // будет зачислено с учётом комиссии R.Ivanov
			GiveMoney(playerid,-amount,"пополнение моб.телфона");
			PI[playerid][pMobile] += payment;

			bizz_pay(ATMData[atm][atm_Bank],floatround(amount-payment));

			static const f_str[] = ""W"Внесено средств:\t\t"ORANGE"$%d"W" (комиссия: "P"%d)\n\
								"W"На мобильном счёте:\t\t"ORANGE"$%d\n";
			new string[sizeof(f_str) +1 + (-2 + 11) + (-2 + 11)];
			format(string,sizeof(string),f_str,amount,amount-payment,PI[playerid][pMobile]);
			D(playerid,DIALOG_NONE,DSM, ""P"Оплата мобильного счёта",string,"Закрыть","");
		}
		case D_TICKET: {
	        if(!response) return 1;
	        switch(listitem) {
	            case 0: {
					new price;
					for(new i = 0; i < TOTALTICKETS[playerid]; i++) price += TL[playerid][i][tPrice];
					static const f_str[] = ""W"Вы собираетесь оплатить "YELLOW"%i"W" штрафов на сумму: "GREEN"$%i\n"W"Вы действительно хотите произвести оплату?";
					new string[sizeof(f_str) +1 + (-2 + 5)];
					format(string,sizeof(string),f_str,TOTALTICKETS[playerid],price);
				 	D(playerid,D_TICKET_1,DSM, ""P"Оплата штрафа",string,"Оплатить","Назад");
				}
				default: SetPVarInt(playerid,"ticket",listitem), D(playerid,D_TICKET_2,DSL,""P"Штрафы",""GREEN"1."W" Оплатить штраф\n"GREEN"2."W" Информация о штрафе","Далее","Назад");
			}
		}
		case D_TICKET_1: {
		    if(!response) return GetTickets(playerid);
		    new price;
			for(new i = 0; i < TOTALTICKETS[playerid]; i++) price += TL[playerid][i][tPrice];
			if(PI[playerid][pBank] < price) return ErrorMessage(playerid,"На основном банковском счету недостаточно средств"), GetTickets(playerid);
			PI[playerid][pBank] -= price;
			UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
			new query[128];
			for(new i = 0; i < TOTALTICKETS[playerid]; i++) {
			    format(query,sizeof(query), "DELETE FROM `"TABLE_TICKETS"` WHERE `id` = '%i'",TL[playerid][i][tID]);
    			mysql_tquery(connects,query,"","");
			}
			static const f_str[] = "Вы оплатили "P"%i"G" штрафов на сумму "ORANGE"$%i";
			new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 8)];
		 	format(string,sizeof(string),f_str, TOTALTICKETS[playerid],price);
			SendUse(playerid,string);
			return 1;
		}
		case D_TICKET_2: {
		    if(!response) return GetTickets(playerid);
		    new i = GetPVarInt(playerid,"ticket")-1;
		    switch(listitem) {
		        case 0: {
		            if(PI[playerid][pBank] < TL[playerid][i][tPrice]) return ErrorMessage(playerid,"На основном банковском счету недостаточно средств"), GetTickets(playerid);
		            PI[playerid][pBank] -= TL[playerid][i][tPrice];
					UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
					new query[128];
		            format(query,sizeof(query), "DELETE FROM `"TABLE_TICKETS"` WHERE `id` = '%i'",TL[playerid][i][tID]);
 					mysql_tquery(connects,query,"","");
					static const f_str[] = "Вы оплатили штраф: "W"№%i";
					new string[sizeof(f_str) +1 + (-2 + 7)];
		 			format(string,sizeof(string),f_str, i+1);
					SendOk(playerid,string);
		 			return GetTickets(playerid);
				}
				case 1: {
					static const f_str[] = ""W"Штраф №%i\n\n\
										Причина: "NO"%s\n\
										"W"Сумма штрафа: {FACC2E}%i вирт\n\
										"W"Кем был выдан: {1DADF0}%s\n\
										"W"Дата выдачи: {04B404}%s";
					new string[sizeof(f_str) +1 + (-2 + 64) + (-2 + 7) + (-2 + MAX_PLAYER_NAME) + (-2 + 32)];
				    format(string,sizeof(string),f_str,i+1,TL[playerid][i][tReason],TL[playerid][i][tPrice],
										TL[playerid][i][tName],TL[playerid][i][tDate]);
					return D(playerid,D_TICKET_3,DSM, ""P"Информация",string,"Назад","");
				}
			}
			return true;
		}
		case D_TICKET_3: return GetTickets(playerid);
		case D_SHOWALL: {
			if(!response) return 1;
			new query[200];
			format(query,sizeof(query),"SELECT `Name`,`pRank` FROM `accounts` WHERE `pMember` = '%i' ORDER BY `pRank` LIMIT %d, 20", PI[playerid][pMember],(SALLROWS[playerid] * 20));
			mysql_pquery(connects, query, "showall_callback", "i", playerid);
			return 1;
		}
		case D_TIPSTER: {
			new veh = GetPVarInt(playerid,"veh");
			if(!response) {
				GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
				SetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,false,objective);
				DeletePVar(playerid,"veh");
				return 1;
			}
			switch(listitem) {
				case 0: {
					if(GetPVarInt(playerid,"tipster")) {
						ErrorMessage(playerid, "У Вас уже есть жучок");
						GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
						SetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,false,objective);
						return 1;
					}
					SendUse(playerid, "Вы взяли "P"1"G" жучок. Для использования,введите: "W"/tipster");
					SetPVarInt(playerid,"tipster", true);
					MeAction(playerid,"взял(а) жучок");
				}
			}
			GetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,boot,objective);
			SetVehicleParamsEx(veh,engine,lights,alarm,doors,bonnet,false,objective);
			DeletePVar(playerid,"veh");
			return 1;
		}
		case D_FUEL: {
			if(!response) return 1;
			new fuel = GetNearestTrunckFuel(playerid);
			if(fuel==-1) return 1;
			new vehicleid = GetPlayerVehicleID(playerid);
			new modelid = GetVehicleModel(vehicleid) - 400;
			new tank = strval(inputtext);

			if(tank < 1 || tank > 100 || VehicleInfo[vehicleid][vFuel]+tank > gTransport[modelid][trTank]) {

				new Float: can_fill = gTransport[modelid][trTank] - VehicleInfo[vehicleid][vFuel];
				if(can_fill <= 0.0) return ErrorMessage(playerid, "В данный момент вам не требуется заправка");

				static const f_str[] = "\n"W"Укажите на сколько литров вы хотите заправиться?:\n\n\nСтоимость 1л: "GREEN"$%d"W"\nТекущее состояние бака: {FF9968}%.0f"W"\nВместимость бака: {FF9968}%d"W"\nМожно заправиться максимум на: {FF9968}%.0fл";
				new string[sizeof(f_str) +1 + 30];
				format(string, sizeof(string), f_str, gBusiness[fuel][bizzPrice], VehicleInfo[vehicleid][vFuel],gTransport[modelid][trTank],can_fill);
				D(playerid,D_FUEL,DSI, ""P"Заправка",string,"Заправить", "Отмена");
				return 1;
			}
			SetPVarInt(playerid,"tank_fill",tank);
			new number = GetPVarInt(playerid,"tank_fill");

			new string[128];
			format(string, sizeof(string), " \n  \n"W"Вы действительно хотите заправиться на "CA"%d"W" литров?\nСтоимость: "GREEN"$%d\n  \n ",
			number,number*gBusiness[fuel][bizzPrice]);
			D(playerid,D_FUEL_2,DSM, ""P"Заправка",string,"Да", "Нет");
			return 1;
		}
		case D_FUEL_2: {
			if(!response) return DeletePVar(playerid,"tank_fill");
			new fuel = GetNearestTrunckFuel(playerid);
			if(fuel==-1) return 1;
			new price = GetPVarInt(playerid,"tank_fill")*gBusiness[fuel][bizzPrice];
			if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid,-price,"заправка авто АЗС");
			if(gBusiness[fuel][bizzProduct] - GetPVarInt(playerid,"tank_fill") > 0) {
				gBusiness[fuel][bizzProduct] -= GetPVarInt(playerid,"tank_fill");
				bizz_pay(fuel,price);
			}
			DoAction(playerid, "Транспорт заправляется.");
			UpdateBusinessText(fuel);
			SetPVarInt(playerid,"tank_vfuel", floatround(VehicleInfo[GetPlayerVehicleID(playerid)][vFuel]));
			SetTimerEx("FuelCar",500,0,"i",playerid);
			TogglePlayerControllable(playerid,false);
		}
		case D_BUY_FUEL: {
			if(!response) return 1;
			new fuel = GetNearestTrunckFuel(playerid);
			if(fuel==-1) return 1;
			new price = 10*gBusiness[fuel][bizzPrice];
			if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(gBusiness[fuel][bizzProduct] - 10 > 0) {
				gBusiness[fuel][bizzProduct] -= 10;
				bizz_pay(fuel,price);
			}
			GiveMoney(playerid,-price,"покупка канистры");
			UpdateBusinessText(fuel);
			PI[playerid][pFuel] ++;
			UpdatePlayerData(playerid,"pFuel",PI[playerid][pFuel]);
			SendOk(playerid,"Вы купили канистру с бензином. Для заправки Т/С, введите: "W"/fillcar");
		}
		case D_CHANGECAR: {
			new id_pokupaet = GetPVarInt(playerid,"carPokupaet")-1;
			if(!response) {
				DeletePVar(id_pokupaet,"carProdaet");
				DeletePVar(id_pokupaet,"carCena");

				DeletePVar(playerid,"carPokupaet");
				DeletePVar(playerid,"numbercar1");
				DeletePVar(playerid,"numbercar2");
				DeletePVar(playerid,"sellcar_type");
				return 1;
			}
			new string[350];
			format(string, sizeof(string), ""P"%s"G" предложил(а) обмен "W"[%s] на [%s]"G". Доплата: "ORANGE"$%i",player_name[playerid],gTransport[gPlayerCars[playerid][carModel][GetPVarInt(playerid,"numbercar1")-1]-400][trName],gTransport[gPlayerCars[id_pokupaet][carModel][GetPVarInt(playerid,"numbercar2")-1]-400][trName], GetPVarInt(id_pokupaet,"carCena"));
			SendUse(id_pokupaet, string);
			SendClientMessage(id_pokupaet,COLOR_BLUE,"Нажмите "YES"Y "BLUE"чтобы согласиться "NO"N "BLUE"для отказа");
			format(string, sizeof(string), "Вы предложили "P"%s "G"обмен "W"[%s] на [%s]"G". Доплата: "ORANGE"$%i",player_name[id_pokupaet],gTransport[gPlayerCars[playerid][carModel][GetPVarInt(playerid,"numbercar1")-1]-400][trName],gTransport[gPlayerCars[id_pokupaet][carModel][GetPVarInt(playerid,"numbercar2")-1]-400][trName], GetPVarInt(id_pokupaet,"carCena"));
			SendUse(playerid, string);
			DeletePVar(playerid,"sellcar_type");
			SetPVarInt(id_pokupaet,"sellcar_type",1);
		}
		case D_CAR_BUY: {
			if(!response) {
				if(GetPVarInt(playerid,"carProdaet")) {
					new id_prodaet = GetPVarInt(playerid,"carProdaet")-1;
					SendOk(playerid,"Вы отказались от предложения на обмен транспортом");
					SendOk(id_prodaet,"Игрок отказался от предложения на обмен транспортом");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
			}
			new id_prodaet = GetPVarInt(playerid,"carProdaet")-1;
			new id_pokupaet = GetPVarInt(id_prodaet,"carPokupaet")-1;
			new car_cena = GetPVarInt(playerid,"carCena");
			new number_car1 = GetPVarInt(id_prodaet,"numbercar1")-1;
			new number_car2 = GetPVarInt(id_prodaet,"numbercar2")-1;
			if(!response) return change_carcancel(playerid,id_prodaet);
			if(id_pokupaet == playerid) {
				if(PI[playerid][pCash] < car_cena) {
					ErrorMessage(playerid,"У Вас не достаточно денег наличными");
					SendOk(id_prodaet,"У покупателя недостаточно денег наличными");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
				if(!PI[id_prodaet][pHouse] && !PI[id_prodaet][pRoom]) {
					ErrorMessage(id_prodaet,"У Вас нет дома/номера в отеле");
					SendOk(playerid,"У продавца обмен нет дома/номера в отеле");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
				if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) {
					ErrorMessage(playerid,"У Вас нет дома/номера в отеле");
					SendOk(id_prodaet,"У покупателя нет дома/номера в отеле");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
				if(house_car[playerid][0] == INVALID_VEHICLE_ID && house_car[playerid][1] == INVALID_VEHICLE_ID) {
					ErrorMessage(playerid,"Ваш автомобиль не создан/не на парковочном месте");
					SendOk(id_prodaet,"У покупателя автомобиль не создан/не на парковочном месте");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
				if(house_car[id_prodaet][0] == INVALID_VEHICLE_ID && house_car[id_prodaet][1] == INVALID_VEHICLE_ID) {
					ErrorMessage(id_prodaet,"Ваш автомобиль не создан/не на парковочном месте");
					SendOk(playerid,"У продавца автомобиль не создан/не на парковочном месте");
					change_carcancel(playerid,id_prodaet);
					return 1;
				}
				GiveMoney(playerid, -car_cena,"Покупка авто");
				GiveMoney(id_prodaet, car_cena,"Продажа авто");

				new string[156];
				format(string,sizeof(string),"Вы обменялись Т/С с "P"%s"G". Ваша доплата "ORANGE"$%i",player_name[id_prodaet],car_cena);
				SendUse(playerid,string);
				format(string,sizeof(string),"Вы обменялись Т/С с "P"%s"G". Доплата с его стороны: "ORANGE"$%i",player_name[playerid],car_cena);
				SendUse(id_prodaet,string);

				SetPVarInt(id_prodaet,"car",gPlayerCars[playerid][carID][number_car2]);
				gPlayerCars[playerid][carID][number_car2] = gPlayerCars[id_prodaet][carID][number_car1];
				gPlayerCars[id_prodaet][carID][number_car1] = GetPVarInt(id_prodaet,"car");
				DeletePVar(id_prodaet,"car");

				if(house_car[id_prodaet][0] != INVALID_VEHICLE_ID) {
					save_perf(id_prodaet,0);
					A_DestroyVehicle(house_car[id_prodaet][0]);
					house_car[id_prodaet][0] = INVALID_VEHICLE_ID;
				}
				if(house_car[id_prodaet][1] != INVALID_VEHICLE_ID) {
					save_perf(id_prodaet,1);
					A_DestroyVehicle(house_car[id_prodaet][1]);
					house_car[id_prodaet][1] = INVALID_VEHICLE_ID;
				}

				if(house_car[playerid][0] != INVALID_VEHICLE_ID) {
					save_perf(playerid,0);
					A_DestroyVehicle(house_car[playerid][0]);
					house_car[playerid][0] = INVALID_VEHICLE_ID;
				}
				if(house_car[playerid][1] != INVALID_VEHICLE_ID) {
					save_perf(playerid,1);
					A_DestroyVehicle(house_car[playerid][1]);
					house_car[playerid][1] = INVALID_VEHICLE_ID;
				}
				save_car(id_prodaet,0);
				save_car(id_prodaet,1);
				save_car(playerid,0);
				save_car(playerid,1);

				new query_str[128];
				format(query_str,sizeof(query_str),"SELECT * FROM `"TABLE_CARS"` WHERE BINARY `owner` = '%s'",player_name[playerid]);
				mysql_tquery(connects,query_str,"load_cars","i",playerid);

				format(query_str,sizeof(query_str),"SELECT * FROM `"TABLE_CARS"` WHERE BINARY `owner` = '%s'",player_name[id_prodaet]);
				mysql_tquery(connects,query_str,"load_cars","i",id_prodaet);

				change_carcancel(playerid,id_prodaet);
				return 1;
			}
			else {
				ErrorMessage(playerid,"Игрок оффлайн");
				DeletePVar(playerid,"carProdaet");
				DeletePVar(playerid,"carCena");
				DeletePVar(playerid,"sellcar_type");
			}
		}
		case D_SET_BET: {
			if(!response) return true;
			new s = Casino_Flag[playerid][select_casino_table];
			if(s==-1) return 1;
			if(InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"В данный момент идёт игра");
			if(InfoDice[s][dice_bank] != 0) return ErrorMessage(playerid,"Кто то из игроков уже поставил ставку");
			new stavka;
			if(sscanf(inputtext,"i",stavka)) return D(playerid, D_SET_BET, DSI, ""P"Ставка", ""W"Введите сумму ставки!\nСтавка должна быть не менее "ORANGE"$"#MIN_STAVKA"\n"W"и не более "ORANGE"$"#MAX_STAVKA"", "Далее", "Отмена");
			if(stavka < MIN_STAVKA || stavka > MAX_STAVKA) return ErrorMessage(playerid,"Неверная ставка"),D(playerid, D_SET_BET, DSI, ""P"Ставка", ""W"Введите сумму ставки!\nСтавка должна быть не менее "ORANGE"$"#MIN_STAVKA"\n"W"и не более "ORANGE"$"#MAX_STAVKA"", "Далее", "Отмена");
			if(InfoDice[s][dice_game_start]) return ErrorMessage(playerid,"Вы не можете изменить ставку в процессе игры");
			InfoDice[s][dice_stavka] = stavka;
			SendOk(playerid,"Ставка успешно установлена");
			UpdateTextCasino(s);
			new string_set_bet[180];
			format(string_set_bet, 179, ""P"%s "G"установил ставку "ORANGE"$%d "G"Нажмите "W"SET BET "G"чтобы её поддержать", player_name[playerid], stavka);
			for(new p = 0; p < 5; p++) {
				if(InfoDice[s][dice_gamer][p]==INVALID_PLAYER_ID) continue;
				SendUse(InfoDice[s][dice_gamer][p],string_set_bet);
			}
			if(InfoDice[s][dice_crup]!=INVALID_PLAYER_ID) SendUse(InfoDice[s][dice_crup],string_set_bet);
		}
		case dBizList: {
			if(!response) return 1;
			new fracid = -1;
			new
				count_business = 1,
				string[5000];

			switch(PI[playerid][pMember]) {
				case fLCN: fracid = 0;
				case fYAKUZA: fracid = 1;
				case fRM: fracid = 2;
			}
			string = "№. Название + Доход бизнеса за сегодня\n\n";
			for(new i; i<gBusinessCount; i++) {
				if(gBusiness[i][bizzMafia] != PI[playerid][pMember]) continue;
				if(fracid != -1) {
					if(count_business <= 50) {
						count_business++;
						continue;
					}
					format(string, sizeof(string), ""W"%s%i. %s + "GREEN"$%d\n",string, count_business, gBusiness[i][bizzName],gBankMafia[fracid][i]);
				}
			}
			D(playerid, DIALOG_NONE, DSM, ""P"Бизнесы мафии", string, "Закрыть", "");
			return 1;
		}
		case D_LMENU: {
			if(!response) return 1;
			switch(listitem) {
				case 0..2: dialog_lmenu(playerid,listitem);
				case 3..7: dialog_lmenu(playerid,listitem+1);
			}
		}
		case D_LMENU_2: {
			if(!response) return 1;
			dialog_lmenu(playerid,listitem);
		}
		case D_GANGTOP: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new gz_total[5];
					for(new i = 0; i < TOTALGZ; i++) {
						switch(GZInfo[i][gFrakVlad])
						{
							case fBALLAS: gz_total[0]++;
							case fVAGOS: gz_total[1]++;
							case fGROVE: gz_total[2]++;
							case fAZTEC: gz_total[3]++;
							case fRIFA: gz_total[4]++;
						}
					}
					static const f_str[] = "{8813E7}Ballas"W"\t{8813E7}%d/100"W"\n\
											{DBD604}Vagos"W"\t{DBD604}%d/100"W"\n\
											{009F00}Grove"W"\t{009F00}%d/100"W"\n\
											{01FCFF}Aztecas"W"\t{01FCFF}%d/100"W"\n\
											{83BFBF}Rifa"W"\t{83BFBF}%d/100"W"";
					new string[sizeof(f_str) + 40];
					format(string,sizeof(string),f_str,gz_total[0],gz_total[1],gz_total[2],gz_total[3],gz_total[4]);
					D(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, ""P"Территории",string, "Закрыть", "");
				}
				case 1: {
					new graff[5];
					for(new i; i<CountGraffity; i++) {
						switch(GrafInfo[i][gFrak])
						{
							case fBALLAS: graff[0]++;
							case fVAGOS: graff[1]++;
							case fGROVE: graff[2]++;
							case fAZTEC: graff[3]++;
							case fRIFA: graff[4]++;
						}
					}
					static const f_str[] = "{8813E7}Ballas"W"\t{8813E7}%d/120"W"\n\
											{DBD604}Vagos"W"\t{DBD604}%d/120"W"\n\
											{009F00}Grove"W"\t{009F00}%d/120"W"\n\
											{01FCFF}Aztecas"W"\t{01FCFF}%d/120"W"\n\
											{83BFBF}Rifa"W"\t{83BFBF}%d/120"W"";
					new string[sizeof(f_str) + 40];
					format(string,sizeof(string),f_str,graff[0],graff[1],graff[2],graff[3],graff[4]);
					D(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, ""P"Граффити",string, "Закрыть", "");
				}
				case 2: {
					static const f_str[] = "{8813E7}Ballas"W"\t{8813E7}%d"W"\n\
											{DBD604}Vagos"W"\t{DBD604}%d"W"\n\
											{009F00}Grove"W"\t{009F00}%d"W"\n\
											{01FCFF}Aztecas"W"\t{01FCFF}%d"W"\n\
											{83BFBF}Rifa"W"\t{83BFBF}%d"W"";
					new string[sizeof(f_str) + 40];
					format(string,sizeof(string),f_str,FI[fBALLAS][fRating],FI[fVAGOS][fRating],FI[fGROVE][fRating],FI[fAZTEC][fRating],FI[fRIFA][fRating]);
					D(playerid, DIALOG_NONE, DIALOG_STYLE_TABLIST, ""P"Рейтинг",string, "Закрыть", "");
				}
			}
		}
		case D_DIPLOMATION: {
			if (!response) {
				for (new i = 0 ; i < 7; i ++) {
					new pvar_string[8];
					format(pvar_string, 8, "d_%d",i);
					DeletePVar(playerid, pvar_string);
				}
				return 1;
			}
			new header_string[64];
			format(header_string, 8, "d_%d", listitem);
			new fr_id = GetPVarInt(playerid, header_string);
			SetPVarInt ( playerid, "d_listitem", listitem ) ;

			header_string[0] = EOS;
			strcat(header_string, "{");
			strcat(header_string, GetColorFrac(fr_id));
			strcat(header_string, "}");
			strcat(header_string, FI[fr_id][fName]);
			D(playerid, D_DIPLOMATION_2, DSL, header_string, ""P"1."W" Нейтралитет\n"P"2."W" Война\n"P"3."W" Союз", "Выбрать", "Закрыть" ) ;
		}
		case D_DIPLOMATION_2: {
			if(zahvat == true) return ErrorMessage(playerid,"Запрещено изменять дипломатию во время захвата территории");
			if(!response) return dialog_diplom(playerid,true);
			new pvar_string[8];
			format(pvar_string, 8, "d_%d", GetPVarInt(playerid, "d_listitem"));
			DeletePVar(playerid, "d_listitem");
			new fr_id = GetPVarInt(playerid, pvar_string);
			if(listitem == 2) {
				if (f_diplomacy[PI[playerid][pMember] - 14][fr_id - 14] == dip_status_alliance_get_invite) {
					f_diplomacy[PI[playerid][pMember] - 14][fr_id - 14] = dip_status_alliance;
					f_diplomacy[fr_id - 14][PI[playerid][pMember] - 14] = dip_status_alliance;

					dialog_diplom(playerid,true);
					save_diplomation(playerid,PI[playerid][pMember]);
					save_diplomation(playerid,fr_id);
					return 1;
				}
				f_diplomacy[PI[playerid][pMember] - 14][fr_id - 14] = dip_status_alliance_invite;
				f_diplomacy[fr_id - 14][PI[playerid][pMember] - 14] = dip_status_alliance_get_invite;

				dialog_diplom(playerid,true);
				save_diplomation(playerid,PI[playerid][pMember]);
				save_diplomation(playerid,fr_id);
				return 1 ;
			}
			f_diplomacy[PI[playerid][pMember] - 14][fr_id - 14] = listitem;
			f_diplomacy[fr_id - 14][PI[playerid][pMember] - 14] = listitem;

			dialog_diplom(playerid,true);
			save_diplomation(playerid,PI[playerid][pMember]);
			save_diplomation(playerid,fr_id);
		}
		case D_LMENU_BANK: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Состояние счета: "ORANGE"$%d\n"P"1."W" Снять деньги";
					new string[sizeof(f_str) +1 + (-2 + 10)];
					format(string,sizeof(string),f_str,FI[PI[playerid][pMember]][fBank]);
					D(playerid,D_LMENU_BANK,DSL,""P"Управление банком фракции",string,"Далее","Назад");
				}
				case 1: D(playerid,D_LMENU_BANK_INPUT,DSI, ""P"Управление банком фракции","\n\n"W"Введите сумму, которую хотите взять с банка фракции:\n\n","Взять","Отмена");
			}
		}
		case D_LMENU_BANK_INPUT: {
			if(!response) return 1;
			if(!PI[playerid][pLeader]) return ErrorMessage(playerid,"Вам недоступна данная функция");
			if(!strlen(inputtext)) return D(playerid,D_LMENU_BANK_INPUT,DSI, ""P"Управление банком фракции","\n\n"W"Введите сумму, которую хотите взять с банка фракции:\n\n","Взять","Отмена");
			new dengi = strval(inputtext),maxmoney = 0;
			switch(PI[playerid][pMember]) {
				case fLSPD,fSFPD,fLVPD,fFBI,fARMYSF,fARMYLV,fMEDICLS,fMEDICSF,fMEDICLV,fLSNEWS,fSFNEWS,fLVNEWS,fRM,fLCN,fYAKUZA: maxmoney = 300000;
				case fBALLAS,fVAGOS,fGROVE,fAZTEC,fRIFA: maxmoney = 200000;
				case fWHITEHOUSE: maxmoney = 500000;
			}
			if(dengi < 1 || dengi > maxmoney) {
				static const f_str[] = "\n\n"W"Введите сумму, которую хотите взять с банка фракции:\n\n"NO"* "G"От $1 до $%d\n\n";
				new string[sizeof(f_str) +1 + (-2 + 9)];
				format(string,sizeof(string),f_str,maxmoney);
				D(playerid,D_LMENU_BANK_INPUT,DSI, ""P"Управление банком фракции",string,"Взять","Отмена");
				return 1;
			}
			if(FI[GetTeamID(playerid)][fBankCash] + dengi > maxmoney) {
				new string[128];
				format(string,sizeof(string),"\n\n"W"Введите сумму, которую хотите взять с банка фракции:\n\n"NO"* "G"Суточный лимит на перевод/снятие средств с общага - $%d. Доступный лимит: $%d\n\n",maxmoney,maxmoney-FI[GetTeamID(playerid)][fBankCash]);
				D(playerid,D_LMENU_BANK_INPUT,DSI, ""P"Управление банком фракции",string,"Взять","Отмена");
				return 1;
			}
			if(FI[GetTeamID(playerid)][fBank] < dengi) return D(playerid,D_LMENU_BANK_INPUT,DSI, ""P"Управление банком фракции","\n\n"W"Введите сумму, которую хотите взять с банка фракции:\n\n"NO"* "G"В банке фракции нет такой суммы\n\n","Взять","Отмена");
			FI[GetTeamID(playerid)][fBank] -= dengi;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			FI[GetTeamID(playerid)][fBankCash] += dengi;
			UpdateFraction(GetTeamID(playerid),"BankCash",FI[GetTeamID(playerid)][fBankCash]);
			GiveMoney(playerid, dengi,"снял со счета фракции");
			new string[128];
			format(string,sizeof(string),"Вы сняли с банка фракции: "ORANGE"$%d",dengi);
			SendOk(playerid,string);
		}
		case D_LMENU_TEXT: {
			if(!response) return 1;
			new message[71];
			if(NonSym(inputtext,70,1)) return D(playerid,D_LMENU_TEXT, DSI, ""P"Сообщение фракции", "\n\n"W"Введите сообщение, которое будет показано членам Вашей организации при входе:\nДля удаления сообщения введите: "ORANGE"None\n\n"NO"* "G"Запрещены некорректные символы\n\n", "Ввод", "Отмена" ) ;
			if(sscanf(inputtext,"s[70]",message)) return D(playerid,D_LMENU_TEXT, DSI, ""P"Сообщение фракции", "\n\n"W"Введите сообщение, которое будет показано членам Вашей организации при входе:\nДля удаления сообщения введите: "ORANGE"None\n\n"NO"* "G"От 1 до 70 символов\n\n", "Ввод", "Отмена" ) ;
			strmid(FI[PI[playerid][pMember]][fMessage],message,0,strlen(message),70);

			new query[350];
			mysql_format(connects,query,sizeof(query),"UPDATE fractions SET Message = '%e' WHERE `ID` = '%d' LIMIT 1",FI[PI[playerid][pMember]][fMessage],PI[playerid][pMember]);
			mysql_tquery(connects,query);

			new string[128];
			format(string,sizeof(string),"Сообщение: "ORANGE"%s "G"успешно установлено",message);
			SendOk(playerid,string);
		}
		case D_LMENU_RANK: {
			if(!response) return DeletePVar(playerid,"leader_rank");
			if(!PI[playerid][pMember]) return 1;

			switch(GetPVarInt(playerid,"leader_rank"))
			{

				case 0: FI[GetTeamID(playerid)][fInviteRang] = listitem + 1,UpdateFraction(GetTeamID(playerid),"RangInvite",listitem + 1);
				case 1: FI[GetTeamID(playerid)][fUninviteRang] = listitem + 1,UpdateFraction(GetTeamID(playerid),"RangUninvite",listitem + 1);
				case 2: FI[GetTeamID(playerid)][fGiveRang] = listitem + 1,UpdateFraction(GetTeamID(playerid),"GiveRang",listitem + 1);
				case 3: FI[GetTeamID(playerid)][fUseStock] = listitem + 1,UpdateFraction(GetTeamID(playerid),"UseStock",listitem + 1);
				default: return 1;
			}
			DeletePVar(playerid,"leader_rank");
			callcmd::lmenu(playerid);
			return 1;
		}
		case D_EDIT_RANK_1: {
			if(!response) return callcmd::lmenu(playerid);
			if(!PI[playerid][pMember]) return 1;
			SetPVarInt(playerid,"edit_rank",listitem);
			D(playerid, D_EDIT_RANK_2, DSI, ""P"Смена названия ранга", "\n\n"W"Введите новое название ранга:\n\n", "Изменить", "Отмена");
			return 1;
		}
		case D_EDIT_RANK_2: {
			if(!response) return 1;
			if(!PI[playerid][pMember]) return 1;
			if(strlen(inputtext) <= 5 || strlen(inputtext) >= 24) return D(playerid, D_EDIT_RANK_2, DSI, ""P"Смена названия ранга", "\n\n"W"Введите новое название ранга:\n\n"NO"*"G" От 6 и до 24 симолов\n\n", "Изменить", "Отмена");
			string_replace(inputtext, "'", ' ') ;
			new slot = GetPVarInt(playerid, "edit_rank");

			new string[156];
			format(string,sizeof(string),"Ранг "P"№%d"G" переименован с "W"%s"G" на "W"%s",slot+1,GetRankName(PI[playerid][pMember],slot+1),inputtext);
			SendUse(playerid,string);

			strmid(RankName[PI[playerid][pMember]][slot], inputtext, 0, strlen(inputtext));
			SaveRank(slot+1,GetTeamID(playerid));
			return 1;
		}
		case D_CASINO: {
			if(!response) return 1;
			if(!GetPVarInt(playerid,"krup")) {
				new null = 0;
				foreach(new i:Player) {
					if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
					if(GetPVarInt(i,"krup")) null++;
					if(null >= 5) {
						break;
					}
				}
				if(null >= 5) return ErrorMessage(playerid,"Уже работают достаточно крупье(5 человек)");
				SetPVarInt(playerid,"oldskinkrup",GetPlayerSkin(playerid));
				Casino_Flag[playerid][casino_crup] = 1;
			}
			else Casino_Flag[playerid][casino_crup] = 0;
			new skin_fix = (PI[playerid][pSex] == 1) ? (171) : (194);
			A_SetPlayerSkin(playerid,(GetPVarInt(playerid,"krup")) ? (GetPVarInt(playerid,"oldskinkrup")) : (skin_fix));
			SetPVarInt(playerid,"krup",(GetPVarInt(playerid,"krup")) ? (false) : (true));
			SendOk(playerid,(!GetPVarInt(playerid,"krup")) ? ("Вы закончили работу крупье") : ("Вы устроились на работу крупье"));
			return 1;
		}
		case D_COP_ARREST: {
			if(!response) return 1;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 40: PI[playerid][pJail] = 1;
				case 41: PI[playerid][pJail] = 2;
				case 42: PI[playerid][pJail] = 3;
			}
			PI[playerid][pJailTime] = (PI[playerid][pSearch] * 600)/2;
			UpdatePlayerData(playerid,"pJail",PI[playerid][pJail]);
			UpdatePlayerData(playerid,"pJailTime",PI[playerid][pJailTime]);
			PI[playerid][pSearch] = 0;
			ANDROID_SetPlayerWantedLevel(playerid, PI[playerid][pSearch]);
			PlayerSpawn(playerid);
		}
		case D_DONATE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = "\
											"G"Покупка игровой валюты\n\n\
											"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
											Введите сумму, которую Вы хотите получить:\n\
											Курс: "GREEN"1 FC = $2000";
					new string[sizeof(f_str) +1 + (-2 + 13)];
					format(string, sizeof(string), f_str,PI[playerid][pRouble]);
					D(playerid, D_DONATE_CONVERT, DSI, ""P"Донат", string, "Купить", "Назад");
				}
				case 1: {
					if(PI[playerid][pLeader]) return ErrorMessage(playerid,"Лидерам запрещено менять ник");
					new plane = -1;
					for(new i=1;i<=gPlaneCount;i++) {
						if(GetString(player_name[playerid],gAirplanes[i][aOwner])) {plane = i; break;}
					}
					if(plane != -1) return ErrorMessage(playerid,"Для смены ника, необходимо отказаться от аренды воздушного транспорта");
					D(playerid, D_DONATE_CHANGENAME, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:\nСтоимость: "GREEN"20 FC", "Сменить", "Назад");
				}
				case 2: D(playerid, D_DONATE_UNWARN, DSM, ""P"Донат", ""G"Снятие предупреждения\n\n"W"Стоимость: "GREEN"100 FC\n"G"Вы действительно хотите снять предупреждение?", "Снять", "Назад");
				case 3: D(playerid, D_DONATE_ZAKON, DSM, ""P"Донат", ""G"Повышение законопослушности\n\n"W"Добавление: "P"+15"W" к законопослушности\nСтоимость: "GREEN"10 FC\n"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 4: {
					static const f_str[] = "Лицензия\tСтоимость\tНаличие\n\
											"W"Водительское удостоверение\t"GREEN"20р\t"P"%s\n\
											"W"Лицензия на вождение воздушного транспорта\t"GREEN"30р\t"P"%s\n\
											"W"Лицензия на вождение водного транспорта\t"GREEN"30р\t"P"%s\n\
											"W"Лицензия на ношение оружия\t"GREEN"50р\t"P"%s";
					new string[sizeof(f_str) + (-2 * 4 + 11 * 4) + 5 * 8 + 1 * 4];
					format(string,sizeof(string),f_str,(lic[0])?(""GREEN"Имеется"):(""NO"Отсутствует"),(lic[1])?(""GREEN"Имеется"):(""NO"Отсутствует"),(lic[2])?(""GREEN"Имеется"):(""NO"Отсутствует"),(lic[3])?(""GREEN"Имеется"):(""NO"Отсутствует"));
					D(playerid, D_DONATE_LICENSES, DSTH, ""P"Донат", string, "Купить", "Назад");
				}
				case 5: {
					static const f_str[] = "Оружие\tЦена\tСкилл\n\
											"G"SD-Pistol\t"GREEN"1р = 2%s\t"P"%d%s / 100%s\n\
											"G"Desert Eagle\t"GREEN"1р = 2%s\t"P"%d%s / 100%s\n\
											"G"ShotGun\t"GREEN"1р = 2%s\t"P"%d%s / 100%s\n\
											"G"MP5\t"GREEN"1р = 2%s\t"P"%d%s / 100%s\n\
											"G"AK-47\t"GREEN"1р = 2%s\t"P"%d%s / 100%s\n\
											"G"M4\t"GREEN"1р = 2%s\t"P"%d%s / 100%s";
					new string[sizeof(f_str) +1 + (-2 + 20)];
					format(string,sizeof(string),f_str,"%",PI[playerid][pGunSkill][0],"%","%","%",PI[playerid][pGunSkill][1],"%","%","%",PI[playerid][pGunSkill][2],"%","%","%",PI[playerid][pGunSkill][3],"%","%","%",PI[playerid][pGunSkill][4],"%","%","%",PI[playerid][pGunSkill][5],"%","%");
					D(playerid, D_DONATE_SKILLS, DSTH, ""P"Донат", string, "Купить", "Назад");
				}
				case 6: D(playerid, D_DONATE_SATIETY, DSM, ""P"Донат", ""G"Анти-Голод\n\n"W"Анти-Голод [100% шкала сытости]\nСтоимость: "GREEN"150 FC\n"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 7: D(playerid, D_DONATE_DISEASE, DSM, ""P"Донат", ""G"Иммунитет\n\n"W"Иммунитет от всех болезней\nСтоимость: "GREEN"150 FC\n"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 8: {
					new year, month, day, hour, minute, second,strs_0[30];
					if(PI[playerid][pVips] == VIP_NONE) {
						strs_0 = "-";
					}
					else {
						if(PI[playerid][pVipTime] >= unix) {
							timestamp_to_date(PI[playerid][pVipTime]-unix, year, month, day, hour, minute, second);
							format(strs_0,sizeof strs_0,""NO"%dм %dд %dч",month-1,day-1,hour);
						}
					}
					new string[600];
					new vip_name[6][20] = {"Отсутствует","V.I.P. Бронзовый","V.I.P. Серебряный","V.I.P. Золотой","V.I.P. Платиновый","V.I.P. Экстра"};
					format(string,sizeof(string),"Наименование\tЦена\n\
																	"P"V.I.P. Бронзовый\t"GREEN"От 60 рублей\n\
																	"P"V.I.P. Серебряный\t"GREEN"От 70 рублей\n\
																	"P"V.I.P. Золотой\t"GREEN"От 80 рублей\n\
																	"P"V.I.P. Платиновый\t"GREEN"От 90 рублей\n\
																	"GREEN"%s\t%s",vip_name[PI[playerid][pVips]],strs_0);
					D(playerid, D_DONATE_VIP, DSTH, ""P"Донат", string, "Купить", "Назад");
				}
				case 9: {
					if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет дома/номера в отеле");
					new string[1512],str[64];
					string = ""P"ID\t"P"Название автомобиля\t"P"Цена\n";
		            for(new i; i < sizeof(donate_car); i++) {
						format(str,sizeof(str), ""W"%d\t%s\t"ORANGE"%d\n",donate_car[i][0], gTransport[donate_car[i][0]-400][trName],donate_car[i][1]);
						strcat(string, str);
					}
					D(playerid, D_BUY_CAR_DONATE, DSTH, ""P"Покупка автомобиля", string, "Купить", "Назад");
				}
				case 10: {
					if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
					static const f_str[] = ""G"Покупка EXP + поинтов в семью\n\n\
											"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
											Введите сумму, которую Вы хотите получить:\n\
											Курс: "GREEN"1 FC = 10 поинтов";
					new string[sizeof(f_str) +1 + (-2 + 13)];
					format(string, sizeof(string), f_str,PI[playerid][pRouble]);
					D(playerid, D_DONATE_POINT, DSI, ""P"Донат", string, "Купить", "Назад");
				}
				case 11: D(playerid, D_DONATE_BANK, DSM, ""P"Донат", ""G"Мобильный банк\n\n\
						"W"Возможности:\n\
						\t"P"-"G" Выбор банка\n\
						\t"P"-"G" Вызов банковского меню с помощью /call 0000\n\
						\t"P"-"G" Вызов банковских услуг с помощью /call 0000\n\n\
						"W"Стоимость: "GREEN"150 FC\n\
						"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 12: D(playerid, D_DONATE_SKIN, DSI, ""P"Донат", ""G"Покупка уникального скина\n\n\
											Введите ID скина, который Вы хотите приобрести:\n\
											"W"Стоимость: "GREEN"200 FC", "Купить", "Назад");
				case 13: {
					D(playerid, D_DONATE_ZV, DSM, ""P"Донат", ""G"Уровнь розыска\n\n\
						"W"Убрать 1 уровень розыска\n\n\
						"W"Стоимость: "GREEN"10 FC\n\
						"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				}
				case 14: {
					if(PI[playerid][pBox] == 3) return ErrorMessage(playerid,"У Вас изучены все стили боя");
					new style_box[3][9] = {"Бокс","Кунг-Фу","Кик-Бокс"};
					static const f_str[] = "Стиль боя\tЦена\tНавыки\n\
											"G"%s\t"GREEN"1р = 2%s\t"P"%.1f%s / 1000%s";
					new string[sizeof(f_str) +1 + (-2 + 20)];
					format(string,sizeof(string),f_str,style_box[PI[playerid][pBox]],"%",PI[playerid][pSnow],"%","%");
					D(playerid, D_DONATE_BOX, DSTH, ""P"Донат", string, "Купить", "Назад");
				}
				case 15: {
					if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет Т/С");
					D(playerid, D_DONATE_TUNE_CAR, DSM, ""P"Донат", ""G"Убрать тюнинг с личного Т/С\n\n\
						"W"Убрать весь тюнинг с Т/С\n\n\
						"W"Стоимость: "GREEN"50 FC\n\
						"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				}
				case 16: {
					D(playerid, D_DONATE_NUMBER, DSTH, ""P"Донат", "Знаков в номере\tЦена\n\
																	"P"5 значный\t"GREEN"200 FC\n\
																	"P"4 значный\t"GREEN"300 FC\n\
																	"P"3 значный\t"GREEN"400 FC\n\
																	"P"2 значный\t"GREEN"500 FC", "Купить", "Назад");
				}
				case 17: D(playerid, D_DONATE_BLACK, DSTH, ""P"Донат", "№ Наименование\tЦена\n\
											"P"1."W" Выход из ЧС организации\t"GREEN"50 FC\n\
											"P"2."W" Выход из ЧС всех организаций\t"GREEN"300 FC", "Купить", "Назад");
				/*case 19: {
					if(!PI[playerid][pMute]) return ErrorMessage(playerid,"У Вас нет Бана Чата");
					D(playerid, D_DONATE_UNMUTE, DSM, ""P"Донат", ""G"Снять Бан Чата\n\n\
						"W"Стоимость: "GREEN"10 FC\n\
						"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				}
				case 20: {
					D(playerid, D_DONATE_UNBAN, DSI, ""P"Донат", ""G"Разблокировка аккаунта\n\n\
						"W"Стоимость: "GREEN"500 FC\n\
						"G"Введите ник игрока, которого хотите разблокировать:", "Купить", "Назад");
				}*/
				case 18: D(playerid, D_DONATE_UNNARK, DSM, ""P"Донат", ""G"Снять наркозависимость\n\n"W"Снять: "P"1000"W" от наркозависимости\nСтоимость: "GREEN"100 FC\n"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 19: D(playerid, D_DONATE_JOB, DSM, ""P"Донат", ""G"Новая трудовая книжка\n\nСтоимость: "GREEN"50 FC\n"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				case 20: callcmd::donate(playerid);
				case 21: {
					new query[256];
					format(query, sizeof(query), "SELECT * FROM unitpay_payments WHERE account = '%s' AND status = 1 ORDER BY dateComplete DESC LIMIT 0,20;", player_name[playerid]);
	 				mysql_tquery(connects, query, "unitpay_callback", "dd", playerid, 0);
				}
			}
		}
		case D_DONATE_JOB: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 50) return ErrorMessage(playerid,"У Вас недостаточно средств");
			PI[playerid][pRouble] -= 50;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			new query[53];
			format(query,sizeof(query),"DELETE FROM `jobinfo` WHERE `ji_uid` = '%d'",PI[playerid][pID]);
			mysql_query(connects, query);
			SendClientMessage(playerid,CGOLD,"Новая трудовая книжка успешно получена");
		}
		case D_DONATE_UNNARK: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 100) return ErrorMessage(playerid,"У Вас недостаточно средств");
			PI[playerid][pRouble] -= 100;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно сняли наркозависимость");
			if(PI[playerid][pAddiction] - 1000 < 0) PI[playerid][pAddiction] = 0;
			else PI[playerid][pAddiction] -= 1000;
			UpdatePlayerData(playerid,"pAddiction",PI[playerid][pAddiction]);
		}
		case D_DONATE_UNBAN: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 500) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(strval(inputtext) < 6 || strval(inputtext) > 24) {
				D(playerid, D_DONATE_UNBAN, DSI, ""P"Донат", ""G"Разблокировка аккаунта\n\n\
							"W"Стоимость: "GREEN"500 FC\n\
							"G"Введите ник игрока, которого хотите разблокировать:\n\n"NO"*"G" От 6 и до 24 символов\n\n", "Купить", "Назад");
				return 1;
			}
			if(!IsBannedName(inputtext)) {
				D(playerid, D_DONATE_UNBAN, DSI, ""P"Донат", ""G"Разблокировка аккаунта\n\n\
							"W"Стоимость: "GREEN"500 FC\n\
							"G"Введите ник игрока, которого хотите разблокировать:\n\n"NO"*"G" Данный игрок не заблокирован\n\n", "Купить", "Назад");
				return 1;
			}
			PI[playerid][pRouble] -= 500;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			UnBanName(inputtext);
			SendClientMessage(playerid,CGOLD,"Вы успешно сняли блокировку с игрока");
		}
		case D_DONATE_UNMUTE: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 10) return ErrorMessage(playerid,"У Вас недостаточно средств");
			PI[playerid][pRouble] -= 10;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно сняли Бан Чата");
			PI[playerid][pMute] = 0;
			UpdatePlayerData(playerid,"mute",0);
		}
		case D_DONATE_BLACK: {
			if(!response) return callcmd::donate(playerid);
			switch(listitem) {
				case 0: {
					new black_str[30] = {""G"Не в ЧС",""NO"В ЧС"};
					static const f_str[] = "Организация\tЦена\tСтатус\n\
											"G"Полиция г.ЛС\t"GREEN"50 FC\t%s\n\
											"G"Полиция г.СФ\t"GREEN"50 FC\t%s\n\
											"G"Полиция г.ЛВ\t"GREEN"50 FC\t%s\n\
											"G"ФБР\t"GREEN"50 FC\t%s\n\
											"G"Армия г.СФ\t"GREEN"50 FC\t%s\n\
											"G"Армия г.ЛВ\t"GREEN"50 FC\t%s\n\
											"G"Больница г.ЛС\t"GREEN"50 FC\t%s\n\
											"G"Больница г.СФ\t"GREEN"50 FC\t%s\n\
											"G"Больница г.ЛВ\t"GREEN"50 FC\t%s\n\
											"G"Радиоцентр г.ЛС\t"GREEN"50 FC\t%s\n\
											"G"Радиоцентр г.СФ\t"GREEN"50 FC\t%s\n\
											"G"Радиоцентр г.ЛВ\t"GREEN"50 FC\t%s\n\
											"G"Итальянская мафия\t"GREEN"50 FC\t%s\n\
											"G"Японская мафия\t"GREEN"50 FC\t%s\n\
											"G"Русская мафия\t"GREEN"50 FC\t%s\n\
											"G"Ballas\t"GREEN"50 FC\t%s\n\
											"G"Vagos\t"GREEN"50 FC\t%s\n\
											"G"Grove\t"GREEN"50 FC\t%s\n\
											"G"Aztec\t"GREEN"50 FC\t%s\n\
											"G"Rifa\t"GREEN"50 FC\t%s\n\
											"G"Правительство\t"GREEN"50 FC\t%s";
					new string[sizeof(f_str) + 280];
					format(string,sizeof(string),f_str,
						black_str[bl_info[playerid][bl_fraction][fLSPD]],black_str[bl_info[playerid][bl_fraction][fSFPD]],black_str[bl_info[playerid][bl_fraction][fLVPD]],
						black_str[bl_info[playerid][bl_fraction][fFBI]],black_str[bl_info[playerid][bl_fraction][fMAYOR]],black_str[bl_info[playerid][bl_fraction][fARMYSF]],
						black_str[bl_info[playerid][bl_fraction][fARMYLV]],black_str[bl_info[playerid][bl_fraction][fMEDICLS]],black_str[bl_info[playerid][bl_fraction][fMEDICSF]],
						black_str[bl_info[playerid][bl_fraction][fMEDICLV]],black_str[bl_info[playerid][bl_fraction][fLSNEWS]],black_str[bl_info[playerid][bl_fraction][fSFNEWS]],
						black_str[bl_info[playerid][bl_fraction][fLVNEWS]],black_str[bl_info[playerid][bl_fraction][fLCN]],black_str[bl_info[playerid][bl_fraction][fYAKUZA]],
						black_str[bl_info[playerid][bl_fraction][fRM]],black_str[bl_info[playerid][bl_fraction][fBALLAS]],black_str[bl_info[playerid][bl_fraction][fVAGOS]],
						black_str[bl_info[playerid][bl_fraction][fGROVE]],black_str[bl_info[playerid][bl_fraction][fAZTEC]],black_str[bl_info[playerid][bl_fraction][fRIFA]],
						black_str[bl_info[playerid][bl_fraction][fWHITEHOUSE]]);
					D(playerid, D_DONATE_BLACK_3, DSTH, ""P"Донат", string, "Купить", "Назад");
				}
				case 1: {
					D(playerid, D_DONATE_BLACK_2, DSM, ""P"Донат", ""G"Выход из ЧС всех организаций\n\n\
						"W"Стоимость: "GREEN"300 FC\n\
						"G"Вы действительно хотите купить данную услугу?", "Купить", "Назад");
				}
			}
		}
		case D_DONATE_BLACK_2: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 300) return ErrorMessage(playerid,"У Вас недостаточно средств");
			PI[playerid][pRouble] -= 300;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно вышли их ЧС всех организаций");
			bl_info[playerid][bl_fraction][fLSPD] = bl_info[playerid][bl_fraction][fSFPD] = bl_info[playerid][bl_fraction][fLVPD] =
			bl_info[playerid][bl_fraction][fFBI] = bl_info[playerid][bl_fraction][fMAYOR] = bl_info[playerid][bl_fraction][fARMYSF] =
			bl_info[playerid][bl_fraction][fARMYLV] = bl_info[playerid][bl_fraction][fMEDICLS] = bl_info[playerid][bl_fraction][fMEDICSF] =
			bl_info[playerid][bl_fraction][fMEDICLV] = bl_info[playerid][bl_fraction][fLSNEWS] = bl_info[playerid][bl_fraction][fSFNEWS] =
			bl_info[playerid][bl_fraction][fLVNEWS] = bl_info[playerid][bl_fraction][fLCN] = bl_info[playerid][bl_fraction][fYAKUZA] =
			bl_info[playerid][bl_fraction][fRM] = bl_info[playerid][bl_fraction][fBALLAS] = bl_info[playerid][bl_fraction][fVAGOS] =
			bl_info[playerid][bl_fraction][fGROVE] = bl_info[playerid][bl_fraction][fAZTEC] = bl_info[playerid][bl_fraction][fRIFA] =
			bl_info[playerid][bl_fraction][fWHITEHOUSE] = false;
			new query[74 + MAX_PLAYER_NAME + 6];
			format(query, sizeof(query), "DELETE FROM `fraction_bl` WHERE BINARY `f_bl_accused` = '%s'", player_name[playerid]);
			mysql_pquery(connects, query, "", "");
		}
		case D_DONATE_BLACK_3: {
			if(PI[playerid][pRouble] < 50) return ErrorMessage(playerid,"У Вас недостаточно средств");
			new frac;
			switch(listitem) {
				case 0: frac = fLSPD;
				case 1: frac = fSFPD;
				case 2: frac = fLVPD;
				case 3: frac = fFBI;
				case 4: frac = fARMYSF;
				case 5: frac = fARMYLV;
				case 6: frac = fMEDICLS;
				case 7: frac = fMEDICSF;
				case 8: frac = fMEDICLV;
				case 9: frac = fLSNEWS;
				case 10: frac = fSFNEWS;
				case 11: frac = fLVNEWS;
				case 12: frac = fLCN;
				case 13: frac = fYAKUZA;
				case 14: frac = fRM;
				case 15: frac = fBALLAS;
				case 16: frac = fVAGOS;
				case 17: frac = fGROVE;
				case 18: frac = fAZTEC;
				case 19: frac = fRIFA;
				case 20: frac = fWHITEHOUSE;
			}
			if(bl_info[playerid][bl_fraction][frac] == false) return ErrorMessage(playerid,"Вы не состоите в ЧС данной организации");
			bl_info[playerid][bl_fraction][frac] = false;
			new query[74 + MAX_PLAYER_NAME + 6];
			format(query, sizeof(query), "DELETE FROM `fraction_bl` WHERE BINARY `f_bl_accused` = '%s' AND `f_bl_id` = '%d'", player_name[playerid], frac);
			mysql_pquery(connects, query, "", "");
			PI[playerid][pRouble] -= 50;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно вышли их ЧС организации");
		}
		case D_DONATE_NUMBER: {
			if(!response) return callcmd::donate(playerid);
			SetPVarInt(playerid, "donate_number", listitem);
			new price_number[4] = {200,300,400,500};
			if(PI[playerid][pRouble] < price_number[listitem]) return ErrorMessage(playerid,"У Вас недостаточно средств");
			static const f_str[] = ""G"Покупка номера телефона\n\n\
											Введите %d значный номер телефона, который Вы хотите приобрести:\n\
											"W"Стоимость: "GREEN"%d FC\n";
			new string[sizeof(f_str) +7];
			format(string,sizeof(string),f_str,5-listitem,price_number[listitem]);
			D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",string,"Купить","Закрыть");
		}
		case D_DONATE_NUMBER_2: {
			if(!response) return callcmd::donate(playerid);
			new price_number[4] = {200,300,400,500};
			if(PI[playerid][pRouble] < price_number[GetPVarInt(playerid, "donate_number")]) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(strval(inputtext) == 111 || strval(inputtext) == 222 || strval(inputtext) == 333 || strval(inputtext) == 911) {
				D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",""G"Покупка номера телефона\n\n\
												Введите 3 значный номер телефона, который Вы хотите приобрести:\n\
												"W"Стоимость: "GREEN"400 FC\n\n"NO"*"G" Указанный номер занят\n\n","Купить","Закрыть");
				return true;
			}
			switch(GetPVarInt(playerid, "donate_number")) {
				case 0: {
					if(!IsNumber(inputtext) || strlen(inputtext) != 5 || inputtext[0] == '0') {
						D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",""G"Покупка номера телефона\n\n\
											Введите 5 значный номер телефона, который Вы хотите приобрести:\n\
											"W"Стоимость: "GREEN"200 FC\n\n"NO"*"G" Номер должен состоять из 5 цифр. Первая цифра не должны быть \"ноль\"\n\n","Купить","Закрыть");
						return true;
					}
				}
				case 1: {
					if(!IsNumber(inputtext) || strlen(inputtext) != 4 || inputtext[0] == '0') {
						D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",""G"Покупка номера телефона\n\n\
												Введите 4 значный номер телефона, который Вы хотите приобрести:\n\
												"W"Стоимость: "GREEN"300 FC\n\n"NO"*"G" Номер должен состоять из 4 цифр. Первая цифра не должны быть \"ноль\"\n\n","Купить","Закрыть");
						return true;
					}
				}
				case 2: {
					if(!IsNumber(inputtext) || strlen(inputtext) != 3 || inputtext[0] == '0') {
						D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",""G"Покупка номера телефона\n\n\
												Введите 3 значный номер телефона, который Вы хотите приобрести:\n\
												"W"Стоимость: "GREEN"400 FC\n\n"NO"*"G" Номер должен состоять из 3 цифр. Первая цифра не должны быть \"ноль\"\n\n","Купить","Закрыть");
						return true;
					}
				}
				case 3: {
					if(!IsNumber(inputtext) || strlen(inputtext) != 2 || inputtext[0] == '0') {
						D(playerid,D_DONATE_NUMBER_2,DSI,""P"Донат",""G"Покупка номера телефона\n\n\
												Введите 2 значный номер телефона, который Вы хотите приобрести:\n\
												"W"Стоимость: "GREEN"500 FC\n\n"NO"*"G" Номер должен состоять из 2 цифр. Первая цифра не должны быть \"ноль\"\n\n","Купить","Закрыть");
						return true;
					}
				}
			}
			new query[128];
			format(query,sizeof(query),"SELECT `pPhone` FROM `accounts` WHERE `pPhone` = '%i'",strval(inputtext));
			mysql_tquery(connects, query, "donate_shop", "dddd", playerid, strval(inputtext), GetPVarInt(playerid, "donate_number"), price_number[GetPVarInt(playerid, "donate_number")]);
		}
		
		case D_DONATE_TUNE_CAR: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 50) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет Т/С");
			new string[128];
			format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
			D(playerid,D_DONATE_TUNE_CAR_2,DSL,""P"Убрать тюнинг с личного Т/С",string,"Выбрать","Закрыть");
		}
		case D_DONATE_TUNE_CAR_2: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 50) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(!PI[playerid][pHouse] && !PI[playerid][pRoom] && house_car[playerid][listitem] == INVALID_VEHICLE_ID) return ErrorMessage(playerid,"У Вас нет Т/С");
			RemoveTuning(playerid,house_car[playerid][listitem],listitem);
			save_perf_sell(playerid,listitem);
			if(house_car[playerid][listitem] != INVALID_VEHICLE_ID) {
				for(new i; i < 5; i ++) {
					VehicleInfo[house_car[playerid][listitem]][vPEngine][i] = 0;
					VehicleInfo[house_car[playerid][listitem]][vPBrake][i] = 0;
				}
			}
			save_car(playerid,listitem);

			PI[playerid][pRouble] -= 50;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Тюнинг с личного Т/С успешно удалён");
		}
		case D_DONATE_BOX: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pBox] == 3) return ErrorMessage(playerid,"У Вас изучены все стили боя");
			if(PI[playerid][pRouble] < 2) return ErrorMessage(playerid,"У Вас недостаточно средств");
			PI[playerid][pRouble] -= 2;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			if(floatround(PI[playerid][pSnow]) < 1000) {
				PI[playerid][pSnow] += 2;
			}
			else if(floatround(PI[playerid][pSnow]) >= 1000) {
				PI[playerid][pBox] ++;
				UpdatePlayerData(playerid,"pBox",PI[playerid][pBox]);
				PI[playerid][pSnow] = 0;
				SendOk(playerid,"Вы изучили новый стиль боя. Для переключения введите: "W"/mn > личные настройки > стиль боя");
			}
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели навыки боевых исскуств");
			new style_box[3][9] = {"Бокс","Кунг-Фу","Кик-Бокс"};
			static const f_str[] = "Стиль боя\tЦена\tНавыки\n\
									"G"%s\t"GREEN"1р = 2%s\t"P"%.1f%s / 1000%s";
			new string[sizeof(f_str) +1 + (-2 + 20)];
			format(string,sizeof(string),f_str,style_box[PI[playerid][pBox]],"%",PI[playerid][pSnow],"%","%");
			D(playerid, D_DONATE_BOX, DSTH, ""P"Донат", string, "Купить", "Назад");
		}
		case D_DONATE_SKIN: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 200) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(!CheckSkin(strval(inputtext)) || strval(inputtext) < 1 || strval(inputtext) > 311) {
				D(playerid, D_DONATE_SKIN, DSI, ""P"Донат", ""G"Покупка уникального скина\n\n\
											Введите ID скина, который Вы хотите приобрести:\n\
											"W"Стоимость: "GREEN"200 FC\n\n"NO"*"G" Выбранный скин отсутствует в продаже", "Купить", "Назад");
				return 1;
			}
			PI[playerid][pRouble] -= 200;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			PI[playerid][pSkin] = strval(inputtext);
			UpdatePlayerData(playerid,"Skin",PI[playerid][pSkin]);
			if(PI[playerid][pMember] && start_work[playerid]) {
				A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
				SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
			}
			else A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели уникальный скин");
		}
		case D_DONATE_BANK: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 150) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(PI[playerid][pDonateBank]) return ErrorMessage(playerid,"У Вас уже есть данная услуга");
			PI[playerid][pRouble] -= 150;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			PI[playerid][pDonateBank] = 1;
			UpdatePlayerData(playerid,"pDonateBank",PI[playerid][pDonateBank]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели услугу - мобильный банк. Воспользоваться услугой: "W"/call 0000");
		}
		case D_BUY_CAR_DONATE: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < donate_car[listitem][1]) return ErrorMessage(playerid,"У Вас недостаточно средств");
			SetPVarInt(playerid, "car_donate", listitem);
			new string[128];
			format(string,sizeof(string),""W"1. Автомобиль №1 "P"[%s]\n"W"2. Автомобиль №2 "P"[%s]",gTransport[gPlayerCars[playerid][carModel][0]-400][trName],gTransport[gPlayerCars[playerid][carModel][1]-400][trName]);
			D(playerid,D_BUY_CAR_DONATE_2,DSL,""P"Донат",string,"Купить","Закрыть");
		}
		case D_BUY_CAR_DONATE_2: {
			if(!response) return DeletePVar(playerid, "car_donate");
			new carid = GetPVarInt(playerid, "car_donate");
			DeletePVar(playerid, "car_donate");
			if(!PI[playerid][pHouse] && !PI[playerid][pRoom]) return ErrorMessage(playerid,"У Вас нет дома/номера в отеле");
			if(gPlayerCars[playerid][carModel][listitem] != 481) return ErrorMessage(playerid,"Для начала продайте автомобиль на данном слоте");

			if(PI[playerid][pRouble] < donate_car[carid][1]) return ErrorMessage(playerid,"У Вас недостаточно средств");

			gPlayerCars[playerid][carModel][listitem] = donate_car[carid][0];
			gPlayerCars[playerid][carFuel][listitem] = 30;
			gPlayerCars[playerid][carDrived][listitem] = 0;
			save_car(playerid,listitem);
			loading_cars(playerid,listitem);

			PI[playerid][pRouble] -= donate_car[carid][1];
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);

			new string[200];
			format(string,sizeof(string),""W"Поздравляем с покупкой автомобиля: "P"%s\n\n\
										"W"Автомобиль куплен за: "GREEN"$%d\n\
										"W"И доставлен к Вашему дому",gTransport[donate_car[carid][0]-400][trName],donate_car[carid][1]);
			D(playerid,DIALOG_NONE,DSM, ""P"Донат",string,"Спасибо","");
		}
		case D_DONATE_LICENSES: {
			if(!response) return callcmd::donate(playerid);
			new price[] = {20,30,30,50};
			if(PI[playerid][pRouble] < price[listitem]) return ErrorMessage(playerid,"Недостаточно средств");
			if(lic[playerid][listitem]) return ErrorMessage(playerid,"У Вас уже есть данная лицензия");
			lic[playerid][listitem] = 1;
			UpdateLicenses(playerid);
			PI[playerid][pRouble] -= price[listitem];
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели лицензию");
		}
		case D_DONATE_SKILLS: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 2) return ErrorMessage(playerid,"Недостаточно средств");
			if(PI[playerid][pGunSkill][listitem] +2 >= 100) return ErrorMessage(playerid,"Выбранный навык владения оружием прокачен полностью");
			PI[playerid][pRouble] -= 2;
			PI[playerid][pGunSkill][listitem] += 2;
			if(PI[playerid][pGunSkill][listitem] > 100) PI[playerid][pGunSkill][listitem] = 100;
			SaveAccount(playerid);
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели навыки владения оружием");
			static const f_str[] = "Оружие\tЦена\tСкилл\n\
									"G"SD-Pistol\t"GREEN"1р = 2\t"P"%d%s / 100%s\n\
									"G"Desert Eagle\t"GREEN"1р = 2\t"P"%d%s / 100%s\n\
									"G"ShotGun\t"GREEN"1р = 2\t"P"%d%s / 100%s\n\
									"G"MP5\t"GREEN"1р = 2\t"P"%d%s / 100%s\n\
									"G"AK-47\t"GREEN"1р = 2\t"P"%d%s / 100%s\n\
									"G"M4\t"GREEN"1р = 2\t"P"%d%s / 100%s";
			new string[sizeof(f_str) +1 + (-2 + 20)];
			format(string,sizeof(string),f_str,PI[playerid][pGunSkill][0],"%","%",PI[playerid][pGunSkill][1],"%","%",PI[playerid][pGunSkill][2],"%","%",PI[playerid][pGunSkill][3],"%","%",PI[playerid][pGunSkill][4],"%","%",PI[playerid][pGunSkill][5],"%","%");
			D(playerid, D_DONATE_SKILLS, DSTH, ""P"Донат", string, "Купить", "Назад");
		}
		/*
		case D_DONATE_DISEASE: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 150) return D(playerid, D_DONATE_DISEASE, DSM, ""P"Донат", ""G"Иммунитет\n\n"W"Иммунитет от всех олезней\nСтомость: "GREEN"150 FC\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" Недостаточно средств", "Куить", "Назад");
			if(PI[playerid][pDDisease] == 1) return D(playerid, D_DONATE_DISEASE, DSM, ""P"Донат", ""G"Иммунитет\n\n"W"Иммунитет от всех болезней\nСтоимость: "GREEN"150 FC\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" У Вас уже куплена данная услуга", "Купить", "Назад");
			PI[playerid][pDDisease] = 1;
			UpdatePlayerData(playerid,"pDDisease",1);
			PI[playerid][pDisease][0] = 0;
			PI[playerid][pDisease][1] = 0;
			UpdatePlayerData(playerid,"pDisease_0",0);
			UpdatePlayerData(playerid,"pDisease_1",0);
			PI[playerid][pRouble] -= 150;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели Иммунитет");
		}*/
		case D_DONATE_DISEASE: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 150) return D(playerid, D_DONATE_DISEASE, DSM, ""P"Донат", ""G"Иммунитет\n\n"W"Иммунитет от всех болезней\nСтоимость: "GREEN"150 рублей\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" Недостаточно средств", "Купить", "Назад");
			if(PI[playerid][pDDisease] == 1) return D(playerid, D_DONATE_DISEASE, DSM, ""P"Донат", ""G"Иммунитет\n\n"W"Иммунитет от всех болезней\nСтоимость: "GREEN"150 рублей\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" У Вас уже куплена данная услуга", "Купить", "Назад");
			PI[playerid][pDDisease] = 1;
			UpdatePlayerData(playerid,"pDDisease",1);
			PI[playerid][pDisease][0] = 0;
			PI[playerid][pDisease][1] = 0;
			UpdatePlayerData(playerid,"pDisease_0",0);
			UpdatePlayerData(playerid,"pDisease_1",0);
			PI[playerid][pRouble] -= 150;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели Иммунитет");
		}
		case D_DONATE_SATIETY: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 150) return D(playerid, D_DONATE_SATIETY, DSM, ""P"Донат", ""G"Анти-Голод\n\n"W"Анти-Голод [100% шкала сытости]\nСтоимость: "GREEN"150 рублей\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" Недостаточно средств", "Купить", "Назад");
			if(PI[playerid][pDSatiety] == 1) return D(playerid, D_DONATE_SATIETY, DSM, ""P"Донат", ""G"Анти-Голод\n\n"W"Анти-Голод [100% шкала сытости]\nСтоимость: "GREEN"150 рублей\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" У Вас уже куплена данная услуга", "Купить", "Назад");
			PI[playerid][pDSatiety] = 1;
			UpdatePlayerData(playerid,"pDSatiety",1);
			SetFullness(playerid, 100);
			PI[playerid][pRouble] -= 150;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно приобрели Анти-Голод");
		}
		case D_DONATE_ZV: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 10) return ErrorMessage(playerid,"У Вас недостаточно средств");
			if(!PI[playerid][pSearch]) return ErrorMessage(playerid,"Вы не находитесь в розыске");
			PI[playerid][pSearch] --;
			ANDROID_SetPlayerWantedLevel(playerid,PI[playerid][pSearch]);
			PI[playerid][pRouble] -= 10;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно сняли один уровень розыска");
		}
		case D_DONATE_ZAKON: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 10) return D(playerid, D_DONATE_ZAKON, DSM, ""P"Донат", ""G"Повышение законопослушности\n\n"W"Добавление: "P"+15"W" к законопослушности\nСтоимость: "GREEN"10 FC\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" Недостаточно средств", "Купить", "Назад");
			if(PI[playerid][pZakonp]+15 > 100) return D(playerid, D_DONATE_ZAKON, DSM, ""P"Донат", ""G"Повышение законопослушности\n\n"W"Добавление: "P"+15"W" к законопослушности\nСтоимость: "GREEN"10 FC\n"G"Вы действительно хотите купить данную услугу?\n\n"NO"*"G" Нельзя иметь больше 100 законопослушности", "Купить", "Назад");
			PI[playerid][pZakonp] += 15;
			UpdatePlayerData(playerid,"pZakonp",PI[playerid][pZakonp]);
			PI[playerid][pRouble] -= 10;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно добавили +10 к законопослушности");
		}
		case D_DONATE_UNWARN: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 100) return D(playerid, D_DONATE_UNWARN, DSM, ""P"Донат", ""G"Снятие предупреждения\n\n"W"Стоимость: "GREEN"100 FC\n"G"Вы действительно хотите снять предупреждение?\n\n"NO"*"G" Недостаточно средств", "Снять", "Назад");
			if(!PI[playerid][pWarns]) return D(playerid, D_DONATE_UNWARN, DSM, ""P"Донат", ""G"Снятие предупреждения\n\n"W"Стоимость: "GREEN"100 FC\n"G"Вы действительно хотите снять предупреждение?\n\n"NO"*"G" На Вашем аккаунте нет предупреждений", "Снять", "Назад");
			PI[playerid][pWarns] --;
			UpdatePlayerData(playerid,"pWarns",PI[playerid][pWarns]);
			PI[playerid][pRouble] -= 100;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			SendClientMessage(playerid,CGOLD,"Вы успешно сняли 1 предупреждение");
		}
		case D_DONATE_VIP: {
			if(!response) return callcmd::donate(playerid);
			switch(listitem) {
				case 0: D(playerid, D_DONATE_VIP_SILVER, DSTH, ""P"V.I.P. Бронзовый", "№ Наименование\tДни\tЦена\tВыгода\n\
																					"P"1."W" V.I.P. Бронзовый\t7 дней\t60 FC.\t-\n\
																					"P"2."W" V.I.P. Бронзовый\t15 дней\t100 FC.\t29 FC.\n\
																					"P"3."W" V.I.P. Бронзовый\t30 дней\t180 FC.\t77 FC.\n\
																					"P"4."W" V.I.P. Бронзовый\t60 дней\t350 FC.\t164 FC.\n\
																					"P"6."W" Информация", "Выбрать", "Назад");
				case 1: D(playerid, D_DONATE_VIP_GOLD, DSTH, ""P"V.I.P. Серебряный", "№ Наименование\tДни\tЦена\tВыгода\n\
																					"P"1."W" V.I.P. Серебряный\t7 дней\t70 FC.\t-\n\
																					"P"2."W" V.I.P. Серебряный\t15 дней\t120 FC.\t30 FC.\n\
																					"P"3."W" V.I.P. Серебряный\t30 дней\t220 FC.\t80 FC.\n\
																					"P"4."W" V.I.P. Серебряный\t60 дней\t420 FC.\t180 FC.\n\
																					"P"6."W" Информация", "Выбрать", "Назад");
				case 2: {
					if(PI[playerid][pVips] == VIP_PLATINA) {
						D(playerid, D_DONATE_VIP_PLATIN, DSTH, ""P"V.I.P. Золотой", "№ Наименование\tДни\tЦена\tВыгода\n\
																						"P"1."W" V.I.P. Золотой\t7 дней\t80 FC.\t-\n\
																						"P"2."W" V.I.P. Золотой\t15 дней\t150 FC.\t21 FC.\n\
																						"P"3."W" V.I.P. Золотой\t30 дней\t290 FC.\t53 FC.\n\
																						"P"4."W" V.I.P. Золотой\t60 дней\t570 FC.\t116 FC.\n\
																						"P"6."W" Информация\n\
																						"P"7."W" Смена ника", "Выбрать", "Назад");
					}
					else {
						D(playerid, D_DONATE_VIP_PLATIN, DSTH, ""P"V.I.P. Золотой", "№ Наименование\tДни\tЦена\tВыгода\n\
																						"P"1."W" V.I.P. Золотой\t7 дней\t80 FC.\t-\n\
																						"P"2."W" V.I.P. Золотой\t15 дней\t150 FC.\t21 FC.\n\
																						"P"3."W" V.I.P. Золотой\t30 дней\t290 FC.\t53 FC.\n\
																						"P"4."W" V.I.P. Золотой\t60 дней\t570 FC.\t116 FC.\n\
																						"P"6."W" Информация", "Выбрать", "Назад");
					}
				}
				case 3: {
					if(PI[playerid][pVips] == VIP_ECSCLUSIVE) {
						D(playerid, D_DONATE_VIP_ECSCLUSIVE, DSTH, ""P"V.I.P. Платиновый", "№ Наименование\tДни\tЦена\tВыгода\n\
																						"P"1."W" V.I.P. Платиновый\t7 дней\t90 FC.\t-\n\
																						"P"2."W" V.I.P. Платиновый\t15 дней\t170 FC.\t23 FC.\n\
																						"P"3."W" V.I.P. Платиновый\t30 дней\t329 FC.\t66 FC.\n\
																						"P"4."W" V.I.P. Платиновый\t60 дней\t620 FC.\t151 FC.\n\
																						"P"5."W" V.I.P. Платиновый\tНавсегда\200 FC.\t151 FC.\n\
																						"P"6."W" Информация\n\
																						"P"7."W" Смена ника", "Выбрать", "Назад");
					}
					else {
						D(playerid, D_DONATE_VIP_ECSCLUSIVE, DSTH, ""P"V.I.P. Платиновый", "№ Наименование\tДни\tЦена\tВыгода\n\
																					"P"1."W" V.I.P. Платиновый\t7 дней\t90 FC.\t-\n\
																					"P"2."W" V.I.P. Платиновый\t15 дней\t170 FC.\t23 FC.\n\
																					"P"3."W" V.I.P. Платиновый\t30 дней\t329 FC.\t66 FC.\n\
																					"P"4."W" V.I.P. Платиновый\t60 дней\t620 FC.\t151 FC.\n\
																					"P"5."W" V.I.P. Платиновый\tНавсегда\t2000 FC.\t151 FC.\n\
																					"P"6."W" Информация", "Выбрать", "Назад");
					}
				}
			}
		}
		case D_DONATE_VIP_SILVER: {
			if(!response) return callcmd::donate(playerid);
			if(listitem != 4) {
				new price_vip[] = {60,100,180,350};
				new vip_day[] = {7,15,30,60};
				if(PI[playerid][pRouble] < price_vip[listitem]) return ErrorMessage(playerid,"Недостаточно средств");
				PI[playerid][pVips] = VIP_SILVER;
				PI[playerid][pVipTime] = (unix + 86400 * vip_day[listitem]);
				PI[playerid][pRouble] -= price_vip[listitem];
				UpdatePlayerData(playerid,"pVips",PI[playerid][pVips]);
				UpdatePlayerData(playerid,"pVipTime",PI[playerid][pVipTime]);
				UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
				SendClientMessage(playerid, CGOLD, "Поздравляем с покупкой V.I.P. Бронзовый");
			}
			else show_vip(playerid,VIP_SILVER);
		}
		case D_DONATE_VIP_GOLD: {
			if(!response) return callcmd::donate(playerid);
			if(listitem != 4) {
				new price_vip[] = {70,120,220,420};
				new vip_day[] = {7,15,30,60};
				if(PI[playerid][pRouble] < price_vip[listitem]) return ErrorMessage(playerid,"Недостаточно средств");
				PI[playerid][pVips] = VIP_GOLD;
				PI[playerid][pVipTime] = (unix + 86400 * vip_day[listitem]);
				PI[playerid][pRouble] -= price_vip[listitem];
				UpdatePlayerData(playerid,"pVips",PI[playerid][pVips]);
				UpdatePlayerData(playerid,"pVipTime",PI[playerid][pVipTime]);
				UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
				SendClientMessage(playerid, CGOLD, "Поздравляем с покупкой V.I.P. Серебряный");
			}
			else show_vip(playerid,VIP_GOLD);
		}
		case D_DONATE_VIP_PLATIN: {
			if(!response) return callcmd::donate(playerid);
			switch(listitem) {
				case 0..3: {
					new price_vip[] = {80,150,290,570};
					new vip_day[] = {7,15,30,60};
					if(PI[playerid][pRouble] < price_vip[listitem]) return ErrorMessage(playerid,"Недостаточно средств");
					PI[playerid][pVips] = VIP_PLATINA;
					PI[playerid][pVipTime] = (unix + 86400 * vip_day[listitem]);
					PI[playerid][pRouble] -= price_vip[listitem];
					UpdatePlayerData(playerid,"pVips",PI[playerid][pVips]);
					UpdatePlayerData(playerid,"pVipTime",PI[playerid][pVipTime]);
					UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
					SendClientMessage(playerid, CGOLD, "Поздравляем с покупкой V.I.P. Золотой");
				}
				case 4: show_vip(playerid,VIP_PLATINA);
				case 5: {
					if(PI[playerid][pVipName] > unix) return ErrorMessage(playerid,"Менять ник можно раз в 10 дней");
					D(playerid, D_DONATE_CHANGENAME_2, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:", "Сменить", "Назад");
				}
			}
		}
		case D_DONATE_VIP_ECSCLUSIVE: {
			if(!response) return callcmd::donate(playerid);
			switch(listitem) {
				case 0..4: {
					new price_vip[] = {90,170,320,620};
					new vip_day[] = {7,15,30,60};
					if(PI[playerid][pRouble] < price_vip[listitem]) return ErrorMessage(playerid,"Недостаточно средств");
					PI[playerid][pVips] = VIP_ECSCLUSIVE;

					if(listitem != 4) PI[playerid][pVipTime] = (unix + 86400 * vip_day[listitem]);
					else PI[playerid][pVipTime] = (unix + 86400 * 90);

					PI[playerid][pRouble] -= price_vip[listitem];
					UpdatePlayerData(playerid,"pVips",PI[playerid][pVips]);
					UpdatePlayerData(playerid,"pVipTime",PI[playerid][pVipTime]);
					UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
					SendClientMessage(playerid, CGOLD, "Поздравляем с покупкой V.I.P. Платиновый");
				}
				case 5: show_vip(playerid,VIP_ECSCLUSIVE);
				case 6: {
					if(PI[playerid][pVipName] > unix) return ErrorMessage(playerid,"Менять ник можно раз в 5 дней");
					D(playerid, D_DONATE_CHANGENAME_2, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:", "Сменить", "Назад");
				}
			}
		}
		/*case D_DONATE_VIP_FOREVER: {
			if(!response) return callcmd::donate(playerid);
			switch(listitem) {
				case 0: {
					if(PI[playerid][pRouble] < 2000) return ErrorMessage(playerid,"Недостаточно средств");
					PI[playerid][pVips] = VIP_FOREVER;
					PI[playerid][pVipTime] = (unix + 86400 * 90);
					PI[playerid][pRouble] -= 2000;
					UpdatePlayerData(playerid,"pVips",PI[playerid][pVips]);
					UpdatePlayerData(playerid,"pVipTime",PI[playerid][pVipTime]);
					UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
					SendClientMessage(playerid, CGOLD, "Поздравляем с покупкой V.I.P. Экстра");
				}
				case 1: show_vip(playerid,VIP_FOREVER);
				case 2: {
					if(PI[playerid][pVipName] > unix) return ErrorMessage(playerid,"Менять ник можно раз в 3 дня");
					D(playerid, D_DONATE_CHANGENAME_2, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:", "Сменить", "Назад");
				}
			}
		}*/
		case D_DONATE_POINT: {
			if(!response) return callcmd::donate(playerid);
			if(!PI[playerid][pFamily]) return ErrorMessage(playerid,"Вы не состоите в семье");
			new moneys;
			if(sscanf(inputtext,"i", moneys)) {
				static const f_str[] = "\
										"G"Покупка EXP + поинтов в семью\n\n\
										"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
										Введите сумму, которую Вы хотите получить:\n\
										Курс: "GREEN"1 FC = 10 поинтов";
				new string[sizeof(f_str) +1 + (-2 + 13)];
				format(string, sizeof(string), f_str,PI[playerid][pRouble]);
				D(playerid, D_DONATE_POINT, DSI, ""P"Донат", string, "Купить", "Назад");
				return 1;
			}
			if(PI[playerid][pRouble] < moneys) {
				static const f_str[] = "\
										"G"Покупка EXP + поинтов в семью\n\n\
										"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
										Введите сумму, которую Вы хотите получить:\n\
										Курс: "GREEN"1 FC = 10 поинтов\n\
										\n"NO"*"G" Недостаточно средств";
				new string[sizeof(f_str) +1 + (-2 + 13)];
				format(string, sizeof(string), f_str,PI[playerid][pRouble]);
				D(playerid, D_DONATE_POINT, DSI, ""P"Донат", string, "Купить", "Назад");
				return 1;
			}
			if(moneys > 10000 || moneys < 1) return ErrorMessage(playerid, "От 1 до 10000");
			reputation_family(PI[playerid][pFamily]-1,10*moneys);
			SendClientMessage(playerid, CGOLD, "Операция успешно произведена");
			PI[playerid][pRouble] -= moneys;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);

			new string[128];

			format(string,sizeof(string),"[!] %s %s: пополнил счёт семьи(EXP+Поинты) на %d",GetFamName(PI[playerid][pFamily]-1,PI[playerid][pFamRank]),player_name[playerid],10*moneys);
			FamMSG(PI[playerid][pFamily],string);
			return 1;
		}
		case D_DONATE_CONVERT: {
			if(!response) return callcmd::donate(playerid);
			new moneys;
			if(sscanf(inputtext,"i", moneys)) {
				static const f_str[] = "\
										"G"Покупка игровой валюты\n\n\
										"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
										Введите сумму, которую Вы хотите получить:\n\
										Курс: "GREEN"1 FC = $2000";
				new string[sizeof(f_str) +1 + (-2 + 13)];
				format(string, sizeof(string), f_str, PI[playerid][pRouble]);
				D(playerid, D_DONATE_CONVERT, DSI, ""P"Донат", string, "Купить", "Назад");
				return 1;
			}
			if(PI[playerid][pRouble] < moneys) {
				static const f_str[] = "\
										"G"Покупка игровой валюты\n\n\
										"W"На счету Вашего аккаунта "O"%d "W"FC.\n\
										Введите сумму, которую Вы хотите получить:\n\
										Курс: "GREEN"1 FC = $2000\n\
										\n"NO"*"G" Недостаточно средств";
				new string[sizeof(f_str) +1 + (-2 + 13)];
				format(string, sizeof(string), f_str, PI[playerid][pRouble]);
				D(playerid, D_DONATE_CONVERT, DSI, ""P"Донат", string, "Купить", "Назад");
				return 1;
			}
			if(moneys > 10000 || moneys < 1) return ErrorMessage(playerid, "От 1 до 10000");
			GiveMoney(playerid,moneys * 2000,"донат конверт");
			SendClientMessage(playerid, CGOLD, "Операция успешно произведена. Ваш счёт пополнен");
			PI[playerid][pRouble] -= moneys;
			UpdatePlayerData(playerid,"donatemoney",PI[playerid][pRouble]);
			return 1;
		}
		case D_DONATE_CHANGENAME: {
			if(!response) return callcmd::donate(playerid);
			if(PI[playerid][pRouble] < 20) return D(playerid, D_DONATE_CHANGENAME, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:\nСтоимость: "GREEN"20 FC\n\n"NO"*"G" Недостаточно средств", "Сменить", "Назад");
			if(!strlen(inputtext) || IsTextInvalid(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20 || !IsRPNick(inputtext)) return D(playerid, D_DONATE_CHANGENAME, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:\nСтоимость: "GREEN"20 FC\n\n"NO"*"G" Некорректный формат игрового имени", "Сменить", "Назад");
			SetPVarString(playerid,"WantNickChange", inputtext);
			new query[128];
			mysql_format(connects,query,sizeof(query), "SELECT `Name` FROM `accounts` WHERE `Name` = '%e' LIMIT 1", inputtext);
			mysql_tquery(connects, query, "GrandChangeName", "d", playerid);
			return 1;
		}
		case D_DONATE_CHANGENAME_2: {
			if(!response) return callcmd::donate(playerid);
			if(!strlen(inputtext) || IsTextInvalid(inputtext) || strlen(inputtext) < 6 || strlen(inputtext) > 20 || !IsRPNick(inputtext)) return D(playerid, D_DONATE_CHANGENAME_2, DSI, ""P"Донат", ""G"Смена игрового имени\n\n"W"Введите новое игровое имя:\n\n"NO"*"G" Некорректный формат игрового имени", "Сменить", "Назад");
			SetPVarString(playerid,"WantNickChange", inputtext);
			new query[128];
			mysql_format(connects,query,sizeof(query), "SELECT `Name` FROM `accounts` WHERE `Name` = '%e' LIMIT 1", inputtext);
			mysql_tquery(connects, query, "GrandChangeName2", "d", playerid);
			return 1;
		}
		case D_DJMAKE: {
			if(!response) return 1;
			if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 15) {
				D(playerid,D_DJMAKE,DSI, ""P"Введите ник DJ","\n\n"W"Введите ник DJ:\n\n\
																Минимальное количество символов: "P"3\n\
																"W"Максимальное количество символов: "P"15","Изменить","Отмена");
				return true;
			}
			new query[128], string[100];
			new iddj = 	GetPVarInt(playerid, "makeDJ");
			mysql_format(connects, query, sizeof(query), "INSERT INTO `rjlist` (`pid`, `lvl`, `nick`) VALUES ('%d', '1', '%e')", PI[iddj][pID],inputtext);
 			mysql_tquery(connects, query, "", "");

			format(string, sizeof(string), "%s успешно добавлен в список DJ под ником %s", player_name[iddj],inputtext);
			SendOk(playerid, string);
			format(string, sizeof(string), "[DJ]"W" %s(DJ %s) добавил в команду %s (DJ %s)",player_name[playerid],DJname[playerid],player_name[iddj],inputtext);
			SendDJMessage(COLOR_YELLOW, string);
		}
		case D_SELL_SIM: {
			if(response) {
				new sell_sim_id = GetPVarInt(playerid, "sim_id_sell")-1;
				new sell_sim_sum = GetPVarInt(playerid, "sim_summ");
				DeletePVar(playerid, "sim_id_sell");
				DeletePVar(playerid, "sim_summ");
				if(!IsPlayerConnected(sell_sim_id)) return ErrorMessage(playerid,"Игрок который хотел продать Вам SIM-карту оффлайн");
				if(PI[playerid][pCash] < sell_sim_sum) {
					ErrorMessage(playerid,"У Вас нет столько денег");
					SendOk(sell_sim_id,"У покупателя недостаточно средств");
					return 1;
				}
				new string[128];
				format(string, sizeof(string), "Вы приобрели SIM-карту у "P"%s "G"за "ORANGE"$%i", player_name[sell_sim_id],sell_sim_sum);
				SendUse(playerid, string);
				format(string, sizeof(string), ""P"%s "G"купил у Вас SIM-карту за "ORANGE"$%i", player_name[playerid],sell_sim_sum);
				SendUse(sell_sim_id, string);

				string[0] = EOS;
				format(string,64,"продал симку %s",player_name[playerid]);
				GiveMoney(sell_sim_id, sell_sim_sum, string);
				string[0] = EOS;
				format(string,64,"купил симку у %s",player_name[sell_sim_id]);
				GiveMoney(playerid, -sell_sim_sum, string);

				PI[playerid][pPhone] = PI[sell_sim_id][pPhone];
				PI[sell_sim_id][pPhone] = 0;
				UpdatePlayerData(playerid,"pPhone",PI[playerid][pPhone]);
				UpdatePlayerData(sell_sim_id,"pPhone",PI[sell_sim_id][pPhone]);
				format(string, sizeof(string), "Ваш новый номер: "W"%i",PI[playerid][pPhone]);
				SendClientMessage(playerid, CGOLD, string);
			}
			else {
				SendOk(GetPVarInt(playerid, "sim_id_sell")-1, "Игрок отказался от покупки SIM-карты");
				SendOk(playerid, "Вы отказались от покупки SIM-карты");
				DeletePVar(playerid, "sim_id_sell");
				DeletePVar(playerid, "sim_summ");
			}
		}
		case D_AMMOSG: { //тир
			if(!response) return 1;
			SetPVarInt(playerid, "ShootingStart", !GetPVarInt(playerid, "ShootingStart"));
		}
		case D_BIZZ_TAXI_INFO: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			switch(listitem) {
				case 0: showstattaxi(playerid,bizz);
				case 1: {
					if(PI[playerid][bizz_status] == 6) return ErrorMessage(playerid,"Вы не можете уволиться из таксопарка");
					PI[playerid][bizz_work] = 0;
					UpdatePlayerData(playerid,"bizz_work",0);
					PI[playerid][bizz_status] = 0;
					UpdatePlayerData(playerid,"bizz_status",0);
					SendOk(playerid,"Вы уволились из таксопарка");
				}
			}
		}
		case D_BIZZ_TAXI: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			dialog_taxi(playerid,bizz,listitem);
		}
		case D_BIZZ_TAXI_ZAM: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			switch(listitem) {
				case 0: dialog_taxi(playerid,bizz,0);
				case 1: dialog_taxi(playerid,bizz,10);
				case 2: dialog_taxi(playerid,bizz,11);
			}
		}
		case D_BIZZ_TAXI_CAR: {
			if(!response) return 1;
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			SetPVarInt(playerid,"func_car_taxi",listitem);
			switch(FuncBizz[bizz+1][funcbCar][listitem]) {
				case 0: {
					new string[328],str[128];
					if(gBusiness[bizz][bizzType] == 11) {
						strcat(string,"№. Модель\tКласс\tСтоимость\n");
						for(new i; i < sizeof(taxi_car); i ++) {
							format(str, sizeof(str), ""ORANGE"%d."W" %s\t%s\t%d\n", i+1,gTransport[taxi_car[i][0]-400][trName],taxi_class[taxi_car[i][1]],gTransport[taxi_car[i][0]-400][trPrice]),strcat(string,str);
						}
					}
					else if(gBusiness[bizz][bizzType] == 14) {
						strcat(string,"№. Модель\tГрузоподъемность\tСтоимость\n");
						for(new i; i < sizeof(tk_car); i ++) {
							format(str, sizeof(str), ""ORANGE"%d."W" %s\t%d\t%d\n", i+1,gTransport[tk_car[i][0]-400][trName],tk_car[i][1],gTransport[tk_car[i][0]-400][trPrice]),strcat(string,str);
						}
					}
					D(playerid,D_BIZZ_TAXI_CAR_2,DSTH,"Покупка машины",string,"Купить","Отмена");
				}
				default: {
					if(gBusiness[bizz][bizzType] == 11) {
						static const f_str[] = ""W"Вы собираетесь продать автомобиль "P"%s\n\n"YELLOW"Вы действительно хотите продать данный автомобиль за "GREEN"$%d?";
						new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + 9) + (-2 + 10)];
						format(string,sizeof(string),f_str,gTransport[FuncBizz[bizz+1][funcbCar][listitem]-400][trName],gTransport[FuncBizz[bizz+1][funcbCar][listitem]-400][trPrice]/2);
						D(playerid,D_BIZZ_TAXI_CAR_3,DSM, ""P"Продажа машины",string,"Да","Отмена");
					}
					else if(gBusiness[bizz][bizzType] == 14) {
						static const f_str[] = ""W"Вы собираетесь продать автомобиль "P"%s\n\n"YELLOW"Вы действительно хотите продать данный автомобиль за "GREEN"$%d?";
						new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + 9) + (-2 + 10)];
						format(string,sizeof(string),f_str,gTransport[FuncBizz[bizz+1][funcbCar][listitem]-400][trName],gTransport[FuncBizz[bizz+1][funcbCar][listitem]-400][trPrice]/2);
						D(playerid,D_BIZZ_TAXI_CAR_3,DSM, ""P"Продажа машины",string,"Да","Отмена");
					}
				}
			}
		}
		case D_BIZZ_TAXI_CAR_2: {
			if(!response) return DeletePVar(playerid,"func_car_taxi");
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			SetPVarInt(playerid,"func_car_taxi_2",listitem);
			new id_slot = GetPVarInt(playerid,"func_car_taxi");
			new id_car = GetPVarInt(playerid,"func_car_taxi_2");
			if(FuncBizz[bizz+1][funcbCar][id_slot] != 0) return ErrorMessage(playerid,"На данном слоте уже есть автомобиль");
			if(gBusiness[bizz][bizzType] == 11) {
				static const f_str[] = ""W"Вы собираетесь приобрести автомобиль "P"%s "YELLOW"[%s]\n\n"YELLOW"Вы действительно хотите купить данный автомобиль за "GREEN"$%d?";
				new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + 9) + (-2 + 10)];
				format(string,sizeof(string),f_str,gTransport[taxi_car[id_car][0]-400][trName],taxi_class[taxi_car[id_car][1]],gTransport[taxi_car[id_car][0]-400][trPrice]);
				D(playerid,D_BIZZ_TAXI_CAR_3,DSM, ""P"Покупка машины",string,"Да","Отмена");
			}
			else if(gBusiness[bizz][bizzType] == 14) {
				static const f_str[] = ""W"Вы собираетесь приобрести автомобиль "P"%s "YELLOW"[%d]\n\n"YELLOW"Вы действительно хотите купить данный автомобиль за "GREEN"$%d?";
				new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + 9) + (-2 + 10)];
				format(string,sizeof(string),f_str,gTransport[tk_car[id_car][0]-400][trName],tk_car[id_car][1],gTransport[tk_car[id_car][0]-400][trPrice]);
				D(playerid,D_BIZZ_TAXI_CAR_3,DSM, ""P"Покупка машины",string,"Да","Отмена");
			}
		}
		case D_BIZZ_TAXI_CAR_3: {
			if(!response) return DeletePVar(playerid,"func_car_taxi"),DeletePVar(playerid,"func_car_taxi_2");
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			new id_slot = GetPVarInt(playerid,"func_car_taxi");
			new id_car = GetPVarInt(playerid,"func_car_taxi_2");
			DeletePVar(playerid,"func_car_taxi");
			DeletePVar(playerid,"func_car_taxi_2");
			switch(FuncBizz[bizz+1][funcbCar][id_slot]) {
				case 0: {
					if(gBusiness[bizz][bizzType] == 11) {
						if(gBusiness[bizz][bizzBank] < gTransport[taxi_car[id_car][0]-400][trPrice]) return ErrorMessage(playerid,"В кассе таксопарка недостаточно средств для покупки");
						FuncBizz[bizz+1][funcbCar][id_slot] = taxi_car[id_car][0];
						gBusiness[bizz][bizzBank] -= gTransport[taxi_car[id_car][0]-400][trPrice];
						UpdateBusinessData(bizz+1,"bank",gBusiness[bizz][bizzBank]);
					}
					if(gBusiness[bizz][bizzType] == 14) {
						if(gBusiness[bizz][bizzBank] < gTransport[tk_car[id_car][0]-400][trPrice]) return ErrorMessage(playerid,"В кассе транспортной компании недостаточно средств для покупки");
						FuncBizz[bizz+1][funcbCar][id_slot] = tk_car[id_car][0];
						gBusiness[bizz][bizzBank] -= gTransport[tk_car[id_car][0]-400][trPrice];
						UpdateBusinessData(bizz+1,"bank",gBusiness[bizz][bizzBank]);
					}
					creare_funccar(bizz+1,id_slot);
					SendOk(playerid,"Автомобиль успешно куплен");
				}
				default: {
					if(gBusiness[bizz][bizzType] == 11) {
						gBusiness[bizz][bizzBank] += gTransport[FuncBizz[bizz+1][funcbCar][id_slot]-400][trPrice]/2;
						UpdateBusinessData(bizz+1,"bank",gBusiness[bizz][bizzBank]);

						DestroyDynamicObject(tuningtaxi[FuncBizz[bizz+1][funcbSlot]][id_slot]);
						DestroyDynamicObject(tuningtaxi_1[FuncBizz[bizz+1][funcbSlot]][id_slot]);
						DestroyDynamicObject(tuningtaxi_shash[FuncBizz[bizz+1][funcbSlot]][id_slot]);
						DestroyDynamicObject(tuningtaxi_text[FuncBizz[bizz+1][funcbSlot]][id_slot]);
						DestroyDynamicObject(tuningtaxi_text_1[FuncBizz[bizz+1][funcbSlot]][id_slot]);
					}
					if(gBusiness[bizz][bizzType] == 14) {
						gBusiness[bizz][bizzBank] += gTransport[FuncBizz[bizz+1][funcbCar][id_slot]-400][trPrice]/2;
						UpdateBusinessData(bizz+1,"bank",gBusiness[bizz][bizzBank]);
					}
					FuncBizz[bizz+1][funcbCar][id_slot] = 0;
					A_DestroyVehicle(FuncBizz[bizz+1][funcbCars][id_slot]);
					FuncBizz[bizz+1][funcbCars][id_slot] = INVALID_VEHICLE_ID;
					SendOk(playerid,"Автомобиль успешно продан");
				}
			}
			save_funcar(bizz+1);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_TAXI_NAME: {
			if(!response) return 1;
			new bizz = PI[playerid][pBusiness];
			if(!bizz) return 1;
			if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 20) {
				if(gBusiness[bizz][bizzType] == 11) {
					D(playerid,D_BIZZ_TAXI_NAME,DSI, ""P"Название такси","\n\n"W"Введите новое название таксопарка:\n\n\
																	Минимальное количество символов: "P"3\n\
																	"W"Максимальное количество символов: "P"20","Изменить","Отмена");
					return true;
				}
				else if(gBusiness[bizz][bizzType] == 14){
					D(playerid,D_BIZZ_TAXI_NAME,DSI, ""P"Название транспортной компании","\n\n"W"Введите новое название транспортной компании:\n\n\
														Минимальное количество символов: "P"3\n\
														"W"Максимальное количество символов: "P"20","Изменить","Отмена");
					return true;
				}
				else if(gBusiness[bizz][bizzType] == 15){
					D(playerid,D_BIZZ_TAXI_NAME,DSI, ""P"Название банковского отделения","\n\n"W"Введите новое название банковского отделения:\n\n\
														Минимальное количество символов: "P"3\n\
														"W"Максимальное количество символов: "P"20","Изменить","Отмена");
					return true;
				}
			}
			if(is_text_invalid(inputtext)) return ErrorMessage(playerid,"Присутствуют запрещенные символы");
			strmid(FuncBizz[bizz][funcbName],inputtext, 0, strlen(inputtext));
			new query[128];
			mysql_format(connects,query,sizeof(query),"UPDATE `business_func` SET `name` = '%e' WHERE `bizzID` = '%i'",FuncBizz[bizz][funcbName],bizz);
 			mysql_tquery(connects, query, "", "");

			new string[54];
			format(string,sizeof(string),"{%s}%s",color_td[FuncBizz[bizz][funcbColor]][col_rgb],FuncBizz[bizz][funcbName]);
			SetDynamicObjectMaterialText(biz_text[FuncBizz[bizz][funcbSlot]], 0, string, 130, "Segoe Script", 50, 1, 0xFF000000, 0x00000000, 1);
			UpdateBusinessText(bizz-1);
			if(gBusiness[bizz][bizzType] == 15) {
				static const f_str[] = "Новое название Вашего банковского отделения: {%s}%s";
				new str[sizeof(f_str) +1 + (-2 + 21) + (-2 + 20)];
				format(str,sizeof(str),f_str,color_td[FuncBizz[FuncBizz[bizz][funcbID]][funcbColor]][col_rgb],FuncBizz[bizz][funcbName]);
				SendUse(playerid,str);
			}
			else {
				static const f_str[] = "Новое название %s: {%s}%s";
				new str[sizeof(f_str) +1 + (-2 + 21) + (-2 + 21) + (-2 + 20)];
				format(str,sizeof(str),f_str,(gBusiness[bizz][bizzType] == 11) ? ("Вашего таксопарка") : ("Вашей транспортной компании"),color_td[FuncBizz[FuncBizz[bizz][funcbID]][funcbColor]][col_rgb],FuncBizz[bizz][funcbName]);
				SendUse(playerid,str);
			}
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_TAXI_NAMECAR: {
			if(!response) return 1;
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			if(!strlen(inputtext) || strlen(inputtext) < 3 || strlen(inputtext) > 12) {
				D(playerid,D_BIZZ_TAXI_NAMECAR,DSI, ""P"Название такси","\n\n"W"Введите новое название на автомобилях:\n\n\
																Минимальное количество символов: "P"3\n\
																"W"Максимальное количество символов: "P"12","Изменить","Отмена");
				return true;
			}
			if(is_text_invalid(inputtext)) return ErrorMessage(playerid,"Присутствуют запрещенные символы");
			strmid(FuncBizz[bizz+1][funcbNameCar],inputtext, 0, strlen(inputtext));
			new query[128];
			mysql_format(connects,query,sizeof(query),"UPDATE `business_func` SET `name_car` = '%e' WHERE `bizzID` = '%i'",FuncBizz[bizz+1][funcbNameCar],bizz+1);
 			mysql_tquery(connects, query, "", "");

			update_bfunc(2,bizz+1,-1);
			static const f_str[] = "Новый текст на автомобилях такси: "ORANGE"%s";
			new string[sizeof(f_str) +1 + (-2 + 13)];
			format(string,sizeof(string),f_str,FuncBizz[bizz+1][funcbNameCar]);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_TAXI_TARIF: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
			switch(listitem) {
				case 0: D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Эконом\n\n\
																"W"Доступный диапазон: от "GREEN"$50"W" до "GREEN"$200"W" за 1 км.","Изменить","Отмена");
				case 1: D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Комфорт\n\n\
																"W"Доступный диапазон: от "GREEN"$100"W" до "GREEN"$400"W" за 1 км.","Изменить","Отмена");
				case 2: D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Микроавтобус\n\n\
																"W"Доступный диапазон: от "GREEN"$100"W" до "GREEN"$400"W" за 1 км.","Изменить","Отмена");
				case 3: D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Бизнес\n\n\
																"W"Доступный диапазон: от "GREEN"$150"W" до "GREEN"$600"W" за 1 км.","Изменить","Отмена");
			}
			SetPVarInt(playerid,"select_tarif",listitem+1);
		}
		case D_BIZZ_TAXI_TARIF_2: {
			if(!response) return DeletePVar(playerid,"select_tarif");
			if(PI[playerid][pBusiness] < 1) return 1;
			new list = GetPVarInt(playerid,"select_tarif")-1;
			new tarif = strval(inputtext);
			switch(list) {
				case 0: {
					if(tarif < 50 || tarif > 200) {
						D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Эконом\n\n\
																"W"Доступный диапазон: от "GREEN"$50"W" до "GREEN"$200"W" за 1 км.","Изменить","Отмена");
						return 1;
					}
				}
				case 1: {
					if(tarif < 100 || tarif > 400) {
						D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Комфорт\n\n\
																"W"Доступный диапазон: от "GREEN"$100"W" до "GREEN"$400"W" за 1 км.","Изменить","Отмена");
						return 1;
					}
				}
				case 2: {
					if(tarif < 100 || tarif > 400) {
						D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Микроавтобус\n\n\
																"W"Доступный диапазон: от "GREEN"$100"W" до "GREEN"$400"W" за 1 км.","Изменить","Отмена");
						return 1;
					}
				}
				case 3: {
					if(tarif < 150 || tarif > 600) {
						D(playerid,D_BIZZ_TAXI_TARIF_2,DSI, ""P"Название такси","\n\n"W"Введите тариф для класса "P"Бизнес\n\n\
																"W"Доступный диапазон: от "GREEN"$150"W" до "GREEN"$600"W" за 1 км.","Изменить","Отмена");
						return 1;
					}
				}
			}
			FuncBizz[PI[playerid][pBusiness]][funcbTarif][list] = tarif;
			save_funtarif(PI[playerid][pBusiness]);
			static const f_str[] =  "Вы установили новый тариф "ORANGE"%d"G" для класса "P"%s";
			new str[sizeof(f_str) +1 + (-2 + 4) + (-2 + 24)];
			format(str,sizeof(str),f_str,tarif,taxi_class[list]);
			SendUse(playerid,str);

			static const f_string[] =  "Руководитель таксопарка установил тариф "GREEN"%d"YELLOW" для класса %s";
			new string[sizeof(f_string) +1 + (-2 + 4) + (-2 + 24)];
			format(string,sizeof(string),f_string,tarif,taxi_class[list]);
			BizzMSG(PI[playerid][pBusiness],COLOR_YELLOW,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_TAXI_PERCENT: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
			new bizz = PI[playerid][pBusiness]-1;
			new percent = strval(inputtext);
			if(percent < 1 || percent > 50) {
				if(gBusiness[bizz][bizzType] == 11) {
					D(playerid,D_BIZZ_TAXI_PERCENT,DSI, ""P"Процент от прибыли","\n\n"W"Введите процент взымаемый от прибыли таксистов Вашего таксопарка\n\n\
														Доступный диапазон: от "P"1% "W"до "P"50%","Изменить","Отмена");
					return 1;
				}
				else if(gBusiness[bizz][bizzType] == 14) {
					D(playerid,D_BIZZ_TAXI_PERCENT,DSI, ""P"Процент от прибыли","\n\n"W"Введите процент взымаемый от прибыли работников Вашей транспортной компании\n\n\
														Доступный диапазон: от "P"1% "W"до "P"50%","Изменить","Отмена");
					return 1;
				}
			}
			FuncBizz[PI[playerid][pBusiness]][funcbPercent] = percent;
			UpdateFuncBizzData(PI[playerid][pBusiness],"percent",FuncBizz[PI[playerid][pBusiness]][funcbPercent]);
			static const f_string[] = "Руководитель %s установил процент от прибыли в размере: %d процент(а)";
			new str[sizeof(f_string) +1 + (-2 + 20) + (-2 + 4)];
			format(str,sizeof(str),f_string,(gBusiness[bizz][bizzType] == 11) ? ("таксопарка") : ("транспортной компании"),FuncBizz[PI[playerid][pBusiness]][funcbPercent]);
			BizzMSG(PI[playerid][pBusiness],COLOR_YELLOW,str);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_BO_PERCENT: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
			switch(listitem) {
				case 0: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.1;
				case 1: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.2;
				case 2: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.3;
				case 3: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.4;
				case 4: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.5;
				case 5: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.6;
				case 6: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.7;
				case 7: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.8;
				case 8: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 0.9;
				case 9: FuncBizz[PI[playerid][pBusiness]][funcbPercent2] = 1.0;
			}
			new query[128];
			format(query,sizeof(query),"UPDATE `business_func` SET `percent2` = '%.1f' WHERE `bizzID` = '%d'",FuncBizz[PI[playerid][pBusiness]][funcbPercent2],PI[playerid][pBusiness]);
			mysql_tquery(connects, query,"","");
			static const f_str[] = "Вы изменили процент комиссий переводов: "ORANGE"%.1f процент(а)";
			new string[sizeof(f_str) +1 + (-2 + 4)];
			format(string,sizeof(string),f_str,FuncBizz[PI[playerid][pBusiness]][funcbPercent2]);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_BO_PERCENT_2: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
			new percent = strval(inputtext);
			if(percent < 1 || percent > 5) {
				D(playerid,D_BIZZ_BO_PERCENT_2,DSI, ""P"Комиссия за оплату недвижимости","\n\n"W"Введите процент комиссии взымаемый с человека во время опаты недвижимости\n\n\
																Доступный диапазон: от "P"1% "W"до "P"5%","Изменить","Отмена");
				return 1;
			}
			FuncBizz[PI[playerid][pBusiness]][funcbPercent] = percent;
			UpdateFuncBizzData(PI[playerid][pBusiness],"percent",FuncBizz[PI[playerid][pBusiness]][funcbPercent]);
			static const f_str[] = "Вы установили новый процент комиссии за оплату недвижимости: "ORANGE"%d процент(а)";
			new string[sizeof(f_str) +1 + (-2 + 4)];
			format(string,sizeof(string),f_str,FuncBizz[PI[playerid][pBusiness]][funcbPercent]);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_BO_PERCENT_3: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
			new percent = strval(inputtext);
			if(percent < 1 || percent > 5) {
				D(playerid,D_BIZZ_BO_PERCENT_3,DSI, ""P"Комиссия за пользование банкоматом","\n\n"W"Введите процент комиссии взымаемый с человека во время пользования банкоматом\n\n\
																Доступный диапазон: от "P"1% "W"до "P"5%","Изменить","Отмена");
				return 1;
			}
			FuncBizz[PI[playerid][pBusiness]][funcbPercent3] = percent;
			UpdateFuncBizzData(PI[playerid][pBusiness],"percent3",FuncBizz[PI[playerid][pBusiness]][funcbPercent3]);
			static const f_str[] = "Вы установили новый процент комиссии за пользование банкоматом: "ORANGE"%d процент(а)";
			new string[sizeof(f_str) +1 + (-2 + 4)];
			format(string,sizeof(string),f_str,FuncBizz[PI[playerid][pBusiness]][funcbPercent3]);
			SendUse(playerid,string);
			callcmd::bpanel(playerid);
		}
		case D_BIZZ_TAXI_PHONE: {
			if(!response) return 1;
			if(PI[playerid][pBusiness] < 1) return 1;
		    if(!IsNumber(inputtext) || strval(inputtext) < 1000 || strval(inputtext) > 9900) {
				static const f_str[] = "\n\n"W"Текущий номер вашего таксопарка: "YELLOW"%d\n\n\
											"W"Введите желаемый новый номер телефона для Вашего таксопарка\n\
											Доступный диапазон: от "P"1000"W" до "P"9900\n\
											"W"Стоимость номера: "GREEN"$50000\n\
											"W"Стоимость номера с 4 одинаоквыми числами: "GREEN"$300000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 5)];
				format(string,sizeof(string),f_str,FuncBizz[PI[playerid][pBusiness]][funcbNum]);
				D(playerid,D_BIZZ_TAXI_PHONE,DSI, ""P"Покупка номера телефона",string,"Купить","Отмена");
				return 1;
			}
			new query[128];
			format(query,sizeof(query),"SELECT `number` FROM `business_func` WHERE `number` = '%i'",strval(inputtext));
			mysql_tquery(connects, query, "sim_bizz", "dd", playerid, strval(inputtext));
		}
		case D_BIZZ_TAXI_MEM: {
			if(!response) return 1;
			GetWord(inputtext[3],0, select_member[playerid], strlen(inputtext[3])+1);
			new id = GetPlayerID(select_member[playerid]);
			new names[MAX_PLAYER_NAME + 1],status,query[128];
			mysql_format(connects,query, sizeof(query), "SELECT * FROM `accounts` WHERE BINARY `Name` = '%e' LIMIT 1", select_member[playerid]);
			new Cache:result = mysql_query(connects, query);
			new rows = cache_num_rows();
			if(rows > 0) {
				cache_get_value_name(0, "Name", names, MAX_PLAYER_NAME);
				cache_get_value_name_int(0, "bizz_status",status);
				if(PI[playerid][bizz_status] == 6 || PI[playerid][bizz_status] == 5) {
					if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
					if(status == 6) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
					if(PI[playerid][bizz_status] == 5) {
						if(status == 5 || status == 6) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
					}
					static const f_str[] = "\t%s\n\
											"P"1. "W"Изменить доступ:\n\
											\t%s- Эконом\n\
											\t%s- Комфорт\n\
											\t%s- Микроавтобус\n\
											\t%s- Бизнес\n\
											\t%s- Управляющий\n\
											"P"2. "NO"Уволить";
					new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 40)];
					format(str,sizeof(str),f_str,names,(status == 1) ? (""P"") : (""W""),(status == 2) ? (""P"") : (""W""),(status == 3) ? (""P"") : (""W""),(status == 4) ? (""P"") : (""W""),(status == 5) ? (""P"") : (""W""));
					D(playerid,D_BIZZ_TAXI_MEM_2,DSL,""P"Сотрудник",str,"Далее","Закрыть");
				}
			}
			else ErrorMessage(playerid, "Сотрудник не найден");
			cache_delete(result);
		}
		case D_BIZZ_TAXI_MEM_2: {
			if(!response) return 1;
			new id = GetPlayerID(select_member[playerid]);
			if(PI[playerid][bizz_status] == 5 || PI[playerid][bizz_status] == 6) {
				switch(listitem) {
					case 2..6: {
						if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
						if(IsPlayerConnected(id)) {
							PI[id][bizz_status] = listitem-1;
							UpdatePlayerData(id,"bizz_status",PI[id][bizz_status]);
						}
						else {
							new query[350];
							mysql_format(connects,query,sizeof(query), "UPDATE `accounts` SET `bizz_status` = '%d' WHERE `Name` = '%e' LIMIT 1",listitem-1,select_member[playerid]);
							mysql_tquery(connects, query, "", "");
						}
						static const f_str[] = "Вы изменили доступ к автомобилям таксопарка для сотрудника "ORANGE"%s"G" на "ORANGE"%s";
						new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 24)];
						format(string,sizeof(string),f_str,select_member[playerid],taxi_class[listitem-2]);
						SendUse(playerid,string);
						SetTimerEx("members_funcbizz", 150, 0, "ii", playerid,PI[playerid][bizz_work]);
						return 1;
					}
					case 7: {
						if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
						if(IsPlayerConnected(id)) {
							if(GetPlayerState(id) == PLAYER_STATE_DRIVER && VehicleInfo[GetPlayerVehicleID(id)][vBizz] == PI[id][bizz_work]) RemovePlayerFromVehicleAC(id);
							PI[id][bizz_work] = 0;
							UpdatePlayerData(id,"bizz_work",0);
							SendOk(id,"Управляющий таксопарка уволил вас из предприятия");
						}
						else {
							new query[350];
							mysql_format(connects,query,sizeof(query), "UPDATE `accounts` SET `bizz_work` = '0',`bizz_cash` = '0',`bizz_status` = '0' WHERE `Name` = '%e' LIMIT 1",select_member[playerid]);
							mysql_tquery(connects, query, "", "");
						}
						static const f_str[] = "Вы уволили сотрудника таксопарка "ORANGE"%s";
						new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];
						format(string,sizeof(string),f_str,select_member[playerid]);
						SendUse(playerid,string);
						SetTimerEx("members_funcbizz", 150, 0, "ii", playerid,PI[playerid][bizz_work]);
						return 1;
					}
					default: {
						new query[128];
						mysql_format(connects,query, sizeof(query), "SELECT * FROM `accounts` WHERE `Name` = '%e' LIMIT 1", select_member[playerid]);
						new Cache:result = mysql_query(connects, query);
						new rows = cache_num_rows();
						if(rows > 0) {
							new names[MAX_PLAYER_NAME + 1],status;
							cache_get_value_name(0, "Name", names, MAX_PLAYER_NAME);
							cache_get_value_name_int(0, "bizz_status",status);
							if(PI[playerid][bizz_status] == 6) {
								if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
								if(status == 6 || status == 5) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
								static const f_str[] = "\t%s\n\
														"P"1. "W"Изменить доступ:\n\
														\t%s- Эконом\n\
														\t%s- Комфорт\n\
														\t%s- Микроавтобус\n\
														\t%s- Бизнес\n\
														\t%s- Управляющий\n\
														"P"2. "NO"Уволить";
								new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 40)];
								format(str,sizeof(str),f_str,names,(status == 1) ? (""P"") : (""W""),(status == 2) ? (""P"") : (""W""),(status == 3) ? (""P"") : (""W""),(status == 4) ? (""P"") : (""W""),(status == 5) ? (""P"") : (""W""));
								D(playerid,D_BIZZ_TAXI_MEM_2,DSL,""P"Сотрудник",str,"Далее","Закрыть");
							}
						}
						else ErrorMessage(playerid, "Сотрудник не найден");
						cache_delete(result);
						return 1;
					}
				}
			}
			members_funcbizz(playerid,PI[playerid][bizz_work]);
		}
		case D_TAXI_CALL: {
			if(!response) return DeletePVar(playerid,"taxi_call_bizz");
			new bizz = GetPVarInt(playerid,"taxi_call_bizz");
			DeletePVar(playerid,"taxi_call_bizz");
			new ids[4];
			if(GetPlayerVirtualWorld(playerid) != 0) return ErrorMessage(playerid,"Для вызова такси выйдите из помещения");
			if(GetPVarInt(playerid,"taxi_time") > gettime()) return ErrorMessage(playerid,"Вы уже вызвали такси, попробуйте позже");
			for(new i = GetVehiclePoolSize()+1; --i != 0;) {
				if(!IsValidVehicle(i)) continue;
				if(VehicleInfo[i][vBizz] != bizz) continue;
				if(!IsVehicleOccupied(i)) continue;
				switch(GetVehicleModel(i)) {
					case 426,438: ids[0] ++;
					case 540,550: ids[1] ++;
					case 560,580: ids[3] ++;
					case 483: ids[2] ++;
				}
			}
			if(listitem < 2) return 1;
			if(!ids[listitem-2]) return ErrorMessage(playerid,"Нет свободных таксистов данного класса");
			SendOk(playerid,"Вы вызвали такси, ожидайте подтверждения заказа");

			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[i][bizz_work] != bizz) continue;
				if(GetPlayerVirtualWorld(i) != 0) continue;
				static const f_str[] = ""W"%s"YELLOW" вызывает такси класса "W"%s. "YELLOW"Расстояние: "W"%.2f км";
				new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 12) + (-2 + 6)];
				format(str,sizeof(str),f_str,player_name[playerid],taxi_class[listitem-2],GetDistanceBetweenPlayers(playerid,i));
				SendClientMessage(i,COLOR_YELLOW,str);
				SendClientMessage(i,COLOR_YELLOW,"Введите "W"/taxilist"YELLOW" для просмотра заказов");
			}
			SetPVarInt(playerid,"taxi_class",listitem-1);
			SetPVarInt(playerid,"taxi_bizz",bizz);
			SetPVarInt(playerid,"taxi_time",gettime()+60);
		}
		case D_TAXIST: {
			if(!response) return 1;
			new id = GetPlayerID(inputtext[3]);
			DeletePVar(id,"taxi_class");
			DeletePVar(id,"taxi_bizz");
			DeletePVar(id,"taxi_time");
			static const f_str[] = "[TAXI] "W"%s"YELLOW" принял Ваш заказ. Автомобиль: "W"%s";
			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 12)];
			format(str,sizeof(str),f_str,player_name[playerid],gTransport[GetVehicleModel(GetPlayerVehicleID(playerid))-400][trName]);
			SendClientMessage(id,COLOR_YELLOW,str);

			static const f_string[] = "[TAXI] "W"%s"YELLOW" принял заказ "W"%s";
			new string[sizeof(f_string) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + MAX_PLAYER_NAME)];
			format(string,sizeof(string),f_string,player_name[playerid],player_name[id]);
			BizzMSG(PI[playerid][bizz_work],COLOR_YELLOW,string);
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(id, X, Y, Z);
			EnableGPSForPlayer(playerid, X, Y, Z);
		}
		case D_TAXI_COUNT: {
			if(!response) return 1;
			new id = GetPlayerID(inputtext[3]);
			TI[playerid][tTaxiGoing] = true;
			TI[playerid][tTaxiPass] = id;
			TI[playerid][tTaxiStart] = VehicleInfo[GetPlayerVehicleID(playerid)][vDrived];
			return SendOk(playerid,"Вы включили счётчик");
		}
		case D_TAXI_WAYCHOICE:
		{
		    if(!response) return 1;
			if(GetPlayerState(playerid) != PLAYER_STATE_PASSENGER) return ErrorMessage(playerid,"Вы должны сидеть на пассажирском месте в такси");
			new driver_id = GetPVarInt(playerid, "taxidriver");

		    switch(listitem)
		    {
		        case 0:
				{
					SendOk(driver_id, "Пассажир выбрал 'выбор пункта по GPS'");
					return D(playerid, D_TAXI_WAYCHOICE_GPS, DSL, "Выбор пункта в GPS", "Автошкола\nВоенкомат\nМэрия\nЯблочный сад\nОружейный завод\nНефтезавод\nЛесопилка\nГрузчики\nБольница ЛС\nБольница СФ\nБольница ЛВ\nПолиция ЛС\nПолиция СФ\nПолиция ЛВ\nЖДЛС\nЖДСФ\nЖДЛВ\nЦерковь\nКазино\nЛовля рыбы\nСпортзал\nЦентр развлечений","Выбор", "Отмена");
				}
		        case 1:
		        {
		            SendOk(driver_id, "Пассажир выбрал 'отметить точку на карте'");
					SendClientMessage(playerid,0x3399FFFF,"Откройте карту и поставьте правой кнопкой мыши метку там, куда хотите отправиться");
					SetPVarInt(playerid,"selectpoint",1);
					SetPVarInt(playerid,"taxiplayeriddriver",driver_id);
					callcmd::count(driver_id);
		        }
		        case 2:
		        {
					SendOk(playerid, "Вы выбрали пункт 'договориться с водителем'");
					SendOk(driver_id, "Пассажир выбрал пункт 'договориться с водителем'");
					return callcmd::count(driver_id);

		        }
		    }
		}
		case D_TAXI_WAYCHOICE_GPS:
		{
		    if(!response) return D(playerid, D_TAXI_WAYCHOICE, DSL, "Такси", "1. Выбрать из доступных пунктов в GPS\n2. Отметить точку на карте\n3. Договориться с водителем", "Выбор", "Отмена" );

			new driverid = GetPVarInt(playerid,"taxidriver");
			if(GetPlayerState(playerid) != PLAYER_STATE_PASSENGER || VehicleInfo[GetPlayerVehicleID(playerid)][vBizz] != PI[driverid][bizz_work]) {
				SetPVarInt(playerid,"taxidriver",0);
				RemovePlayerMapIcon(playerid,iconTaxi);
			}
			new
				Float:x, Float:y,
				str[32];

 			switch(listitem)
		    {

				case 0: x = -2026.6128, y = -94.9509, str = "Автошкола";
				case 1: x = -318.0250, y = 1068.1536, str = "Военкомат";
				case 2: x = 1480.9188, y = -1740.3135, str = "Мэрия";
				case 3: x = -118.2737, y = 7.1584, str = "Яблочный сад";
				case 4: x = 2675.6917, y = -2405.5618, str = "Оружейный завод";
				case 5: x = 284.3835, y = 1426.6891, str = "Нефтезавод";
				case 6: x = -495.1036, y = -1568.1460, str = "Лесопилка";
				case 7: x = 866.3123, y = -1245.8463, str = "Склад";
				case 8: x = 1184.2065, y = -1325.4333, str = "Больница ЛС";
				case 9: x = -2654.8313, y = 623.7918, str = "Больница СФ";
				case 10: x = 1607.5950, y = 1831.1354, str = "Больница ЛВ";
				case 11: x = 1539.1508, y = -1675.5208, str = "Полиция ЛС";
				case 12: x = -1604.8586, y = 724.6096, str = "Полиция СФ";
				case 13: x = 2292.0945, y = 2421.0532, str = "Полиция ЛВ";
				case 14: x = 1814.4481, y = -1890.3649, str = "ЖДЛС";
				case 15: x = -1994.8622, y = 112.8504, str = "ЖДСФ";
				case 16: x = 2806.9531, y = 1312.4647, str = "ЖДЛВ";
				case 17: x = -1970.0964, y = 1118.4404, str = "Церковь";
				case 18: x = 2156.2654, y = 2155.5183, str = "Казино";
				case 19: x = -424.3238, y = -437.3412, str = "Ловля рыбы";
				case 20: x = 2225.3281, y = -1725.0433, str = "Спортзал";
				case 21: x = 2218.9026, y = 1838.8079, str = "Центр развлечений";
			}

			SetPlayerMapIcon(driverid,iconTaxi,x,y,0.0,0,COLOR_YELLOW,MAPICON_GLOBAL_CHECKPOINT);
			SetPlayerMapIcon(playerid,iconTaxi,x,y,0.0,0,COLOR_YELLOW,MAPICON_GLOBAL_CHECKPOINT);
			SendOk(playerid,"Данные о месте назначения отправлены таксисту");
			PlayerPlaySound(playerid, 1056, 0, 0, 0);

			new string_driver[55];
			format(string_driver, sizeof(string_driver), "Пассажир выбрал пункт "YELLOW"'%s'", str);

			SendUse(driverid, string_driver);
			callcmd::count(driverid);
		}
		case D_GPS: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 7) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[67];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшей АЗС (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 1: {
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 1) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[74];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшей закусочной (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 2: {
					new max_distance = 100000;
					new id_atm = -1;
					for(new i = 1; i < MAX_ATM; i ++) {
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, ATMData[i][ATM_Pos][0],ATMData[i][ATM_Pos][1],ATMData[i][ATM_Pos][2])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), ATMData[i][ATM_Pos][0],ATMData[i][ATM_Pos][1],ATMData[i][ATM_Pos][2]));
						if(here_distance < max_distance) {
							id_atm = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_atm == -1) return 1;

					new string_nearest[75];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшего банкомата (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, ATMData[id_atm][ATM_Pos][0],ATMData[id_atm][ATM_Pos][1],ATMData[id_atm][ATM_Pos][2]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,ATMData[id_atm][ATM_Pos][0],ATMData[id_atm][ATM_Pos][1],ATMData[id_atm][ATM_Pos][2]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 3: {
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 2) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[79];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшего магазина 24/7 (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 4: {
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 17) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[86];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшего магазина аксессуаров (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 5: {
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 5) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[80];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшего магазина одежды (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 6:
				{
					new max_distance = 100000;
					new id_biz = -1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 6) continue;
						new here_distance = (!IsPlayerInAnyVehicle(playerid)) ? floatround(GetPlayerDistanceFromPoint(playerid, gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ])) : floatround(GetVehicleDistanceFromPoint(GetPlayerVehicleID(playerid), gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]));
						if(here_distance < max_distance) {
							id_biz = i;
							max_distance = here_distance;
						}
					}
					if(max_distance == -1 || id_biz == -1) return 1;

					new string_nearest[81];
					format(string_nearest, sizeof(string_nearest), "Местоположение ближайшего магазина оружия (%.1f метров) отмечено на вашем GPS", GetPlayerDistanceFromPoint(playerid, gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]));
					SendClientMessage(playerid,COLOR_YELLOW, string_nearest);

					EnableGPSForPlayer(playerid,gBusiness[id_biz][bizzX],gBusiness[id_biz][bizzY],gBusiness[id_biz][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					return 1;
				}
				case 7: {
					static const fmt_dialog[] = ""P"1."W" Автошкола (%.1f метров)\n\
						"P"2."W" Военкомат (%.1f метров)\n\
						"P"3."W" Мэрия (%.1f метров)\n\
						"P"4."W" Центр занятости (%.1f метров)\n\
						"P"5."W" Больница LS (%.1f метров)\n\
						"P"6."W" Больница SF (%.1f метров)\n\
						"P"7."W" Больница LV (%.1f метров)\n\
						"P"8."W" Полицейский участок LS (%.1f метров)\n\
						"P"9."W" Полицейский участок SF (%.1f метров)\n\
						"P"10."W" Полицейский участок LV (%.1f метров)\n\
						"P"11."W" ЖД Лос-Сантос (%.1f метров)\n\
						"P"12."W" ЖД Сан-Фиерро (%.1f метров)\n\
						"P"13."W" ЖД Лас-Вентурас (%.1f метров)\n\
						"P"14."W" Церковь (%.1f метров)\n\
						"P"15."W" Казино (%.1f метров)\n\
						"P"16."W" Ловля рыбы (%.1f метров)\n\
						"P"17."W" Спортзал (%.1f метров)\n\
						"P"18."W" Центр развлечений (%.1f метров)";

					new string_dialog[sizeof(fmt_dialog) + (-2 * 18 + 7 * 18)];

					format(string_dialog, sizeof(string_dialog), fmt_dialog,
						GetPlayerDistanceFromPoint(playerid,-2026.6128,-94.9509,35.1641),
						GetPlayerDistanceFromPoint(playerid,-318.0250,1068.1536,19.5907),
						GetPlayerDistanceFromPoint(playerid,1480.9188,-1740.3135,13.5469),
						GetPlayerDistanceFromPoint(playerid,1697.1898,-1343.5090,17.4879),
						GetPlayerDistanceFromPoint(playerid,1184.2065,-1325.4333,13.5755),
						GetPlayerDistanceFromPoint(playerid,-2654.8313,623.7918,14.4531),
						GetPlayerDistanceFromPoint(playerid,1607.5950,1831.1354,10.8203),
						GetPlayerDistanceFromPoint(playerid,1539.1508,-1675.5208,13.5469),
						GetPlayerDistanceFromPoint(playerid,-1604.8586,724.6096,11.6933),
						GetPlayerDistanceFromPoint(playerid,2292.0945,2421.0532,10.8203),
						GetPlayerDistanceFromPoint(playerid,1814.4481,-1890.3649,13.4141),
						GetPlayerDistanceFromPoint(playerid,-1994.8622,112.8504,27.5391),
						GetPlayerDistanceFromPoint(playerid,2806.9531,1312.4647,10.7500),
						GetPlayerDistanceFromPoint(playerid,-1970.0964,1118.4404,53.1299),
						GetPlayerDistanceFromPoint(playerid,2156.2654,2155.5183,10.6719),
						GetPlayerDistanceFromPoint(playerid,-424.3238,-437.3412,17.2794),
						GetPlayerDistanceFromPoint(playerid,2225.3281,-1725.0433,13.5620),
						GetPlayerDistanceFromPoint(playerid,2218.9026,1838.8079,10.8203));

					D(playerid, D_GPS_O, DSL, ""P"Общественные места", string_dialog, "Выбрать", "Назад");

				}
				case 8: {
					static const fmt_dialog[] = ""P"1."W" Яблочный сад (%.1f метров)\n\
						"P"2."W" Оружейный завод (%.1f метров)\n\
						"P"3."W" Нефтезавод (%.1f метров)\n\
						"P"4."W" Лесопилка (%.1f метров)\n\
						"P"5."W" Склад (%.1f метров)\n\
						"P"6."W" Аренда автобусов LS (%.1f метров)\n\
						"P"7."W" Аренда автобусов SF (%.1f метров)\n\
						"P"8."W" Аренда автобусов LV (%.1f метров)\n\
						"P"9."W" Аренда развозчиков продуктов (%.1f метров)\n\
						"P"10."W" Аренда развозчиков топлива (%.1f метров)\n\
						"P"11."W" Аренда развозчиков еды LS (%.1f метров)\n\
						"P"12."W" Аренда развозчиков еды SF (%.1f метров)\n\
						"P"13."W" Аренда транспорта механиков LS №1 (%.1f метров)\n\
						"P"14."W" Аренда транспорта механиков LS №2 (%.1f метров)\n\
						"P"15."W" Аренда транспорта механиков SF №1 (%.1f метров)\n\
						"P"16."W" Аренда транспорта механиков SF №2 (%.1f метров)\n\
						"P"17."W" Аренда транспорта механиков LV №1 (%.1f метров)\n\
						"P"18."W" Аренда транспорта механиков LV №2 (%.1f метров)\n\
						"P"19."W" Аренда транспорта для уборки улиц (%.1f метров)\n\
						"P"20."W" Аренда транспорта для скашивания травы (%.1f метров)";

					new string_dialog[sizeof(fmt_dialog) + (-2 * 20 + 7 * 20)];

					format(string_dialog, sizeof(string_dialog), fmt_dialog,
						GetPlayerDistanceFromPoint(playerid,-118.2737,7.1584,3.1172),
						GetPlayerDistanceFromPoint(playerid,2675.6917,-2405.5618,13.4675),
						GetPlayerDistanceFromPoint(playerid,284.3835,1426.6891,10.5859),
						GetPlayerDistanceFromPoint(playerid,-495.1036,-1568.1460,9.8474),
						GetPlayerDistanceFromPoint(playerid,866.3123,-1245.8463,14.9381),
						GetPlayerDistanceFromPoint(playerid,1269.4330,-1846.6799,13.3974),
						GetPlayerDistanceFromPoint(playerid,-1986.1086,192.0124,27.7047),
						GetPlayerDistanceFromPoint(playerid,2784.5828,1274.3229,10.7500),
						GetPlayerDistanceFromPoint(playerid,1071.2417,1948.1721,10.8203),
						GetPlayerDistanceFromPoint(playerid,-10.1753,-314.8848,5.4229),
						GetPlayerDistanceFromPoint(playerid,218.3788,-1443.7483,13.2123),
						GetPlayerDistanceFromPoint(playerid,-2416.5146,-604.9440,132.5625),
						GetPlayerDistanceFromPoint(playerid,1636.6709,-1106.8654,23.9063),
						GetPlayerDistanceFromPoint(playerid,-82.6767,-1155.2017,1.7500),
						GetPlayerDistanceFromPoint(playerid,-2026.8943,142.5349,28.8359),
						GetPlayerDistanceFromPoint(playerid,-1648.2657,436.3811,7.1797),
						GetPlayerDistanceFromPoint(playerid,2127.3828,953.3461,10.8130),
						GetPlayerDistanceFromPoint(playerid,2624.8748,1072.8818,10.8203),
						GetPlayerDistanceFromPoint(playerid,1639.0746,-1105.7719,23.9063),
						GetPlayerDistanceFromPoint(playerid,1427.5365,-1837.8632,13.5469));

					D(playerid,D_GPS_WORK,DSL,""P"Работы", string_dialog, "Выбрать","Назад");
				}
				case 9: {
					D(playerid,D_GPS_AUTOSALON,DSL,""P"Автосалоны и тюнинги","\
											"P"1."W" Автосалон [Эконом]\n\
											"P"2."W" Автосалон [Стандарт]\n\
											"P"3."W" Автосалон [Спорт]\n\
											"P"4."W" Мотосалон\n\
											"P"5."W" Perfomance Tuning\n\
											"P"6."W" Тюнинг г. ЛС\n\
											"P"7."W" Тюнинг г. СФ\n\
											"P"8."W" Тюнинг г. ЛВ","Выбрать","Назад");
				}
				case 10: {
					D(playerid,D_GPS_GOS,DSL,""P"Государственные организации","\
											"P"1."W" Правительство\n\
											"P"2."W" Мэрия\n\
											"P"3."W" Полицейский участок г. ЛС\n\
											"P"4."W" Полицейский участок г. СФ\n\
											"P"5."W" Полицейский участок г. ЛВ\n\
											"P"6."W" Больница г. ЛС\n\
											"P"7."W" Больница г. СФ\n\
											"P"8."W" Больница г. ЛВ\n\
											"P"9."W" ФБР\n\
											"P"10."W" Армия [Сухопутные войска]\n\
											"P"11."W" Армия [Военно-морской флот]\n\
											"P"12."W" Радиоцентр г. ЛС\n\
											"P"13."W" Радиоцентр г. СФ\n\
											"P"14."W" Радиоцентр г. ЛВ","Выбрать","Назад");
				}
				case 11: {
					D(playerid,D_GPS_NOLEGAL,DSL,""P"Нелегальные организации","\
											"P"1."W" The Ballas\n\
											"P"2."W" Los Santos Vagos\n\
											"P"3."W" Grove Street\n\
											"P"4."W" Varrios Los Aztecas\n\
											"P"5."W" The Rifa\n\
											"P"6."W" Итальянская мафия\n\
											"P"7."W" Японская мафия\n\
											"P"8."W" Русская мафия\n\
											"P"9."W" Чёрный рынок\n\
											"P"10."W" Дуэли\n\
											"P"11."W" Ограбление домов","Выбрать","Назад");
				}
				case 12: {
					D(playerid,D_GPS_BANK,DSL,""P"Банки","\
											"P"1."W" Банк г. ЛС\n\
											"P"2."W" Банк г. СФ\n\
											"P"3."W" Банк г. ЛВ","Выбрать","Назад");
				}
				case 13: {
					new string[2512];
					new business_count;

					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzUpgrade][1] != 1) continue;
						format(string,sizeof(string),"%s"P"%d."W" %s\n",string,business_count,gBusiness[i][bizzName]);
						business_count++;
					}
					if(business_count >= 1) D(playerid, D_GPS_BIZZ, DSL, ""P"Бизнесы", string, "Выбрать", "Назад");
					else ErrorMessage(playerid,"Бизнесы не найдены");
				}
				case 14: {
					new string[256];
					new count_ammo = 1;
					for(new i = 0; i < gHotelCount; i ++) {
						format(string,sizeof(string),"%s"P"%d."W" %s\n",string,count_ammo,gHotels[i][hotelName]);
						count_ammo++;
					}
					D(playerid, D_GPS_HOTEL, DSL, ""P"Отели", string, "Выбрать", "Назад");
				}
				case 15: {
					D(playerid,D_GPS_AIRPORT,DSL,""P"Аэропорты","\
											"P"1."W" Аэропорт г. ЛС\n\
											"P"2."W" Аэропорт г. СФ\n\
											"P"3."W" Аэропорт г. ЛВ","Выбрать","Назад");
				}
				case 16: {
					new string[512];
					new count_ammo = 1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 11) continue;
						format(string,sizeof(string),"%s"P"%d."W" %s\n",string,count_ammo,FuncBizz[i+1][funcbName]);
						count_ammo++;
					}
					D(playerid, D_GPS_TAXI, DSL, ""P"Таксопарки", string, "Выбрать", "Назад");
				}
				case 17: {
					new string[700];
					new count_ammo = 1;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzType] != 14) continue;
						format(string,sizeof(string),"%s"P"%d."W" %s\n",string,count_ammo,FuncBizz[i+1][funcbName]);
						count_ammo++;
					}
					strcat(string,""P"4."W" [Загрузка] Оружейный завод\n"P"5."W" [Загрузка] Нефтезавод\n"P"6."W" [Разгрузка] Порт г. СФ\n"P"7."W" [Разгрузка] Порт г. ЛС");
					D(playerid, D_GPS_TK, DSL, ""P"Транспортные компании", string, "Выбрать", "Назад");
				}
				case 18: {
					D(playerid,D_GPS_GAME,DSL,""P"Развлечения","\
											"P"1."W" Компьютерный клуб\n\
											"P"2."W" Казино", "Выбрать", "Назад");
				}
				case 19: {
					D(playerid,D_GPS_RIELTOR,DSL,""P"Риэлторские агенства","\
											"P"1."W" Риэлторское агенство г. ЛС\n\
											"P"2."W" Риэлторское агенство г. СФ\n\
											"P"3."W" Риэлторское агенство г. ЛВ","Выбрать","Назад");
				}
			}
		}
		case D_GPS_O: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[28];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,-2026.6128,-94.9509,35.1641), str = "Автошколы";
				case 1: EnableGPSForPlayer(playerid,-318.0250,1068.1536,19.5907), str = "Военкомата";
				case 2: EnableGPSForPlayer(playerid,1480.9188,-1740.3135,13.5469), str = "Мэрии";
				case 3: EnableGPSForPlayer(playerid,1697.1898,-1343.5090,17.4879), str = "Центра занятости";
				case 4: EnableGPSForPlayer(playerid,1184.2065,-1325.4333,13.5755), str = "Больницы г. ЛС";
				case 5: EnableGPSForPlayer(playerid,-2654.8313,623.7918,14.4531), str = "Больницы г. СФ";
				case 6: EnableGPSForPlayer(playerid,1607.5950,1831.1354,10.8203), str = "Больницы г. ЛВ";
				case 7: EnableGPSForPlayer(playerid,1539.1508,-1675.5208,13.5469), str = "Полицейского участка г. ЛС";
				case 8: EnableGPSForPlayer(playerid,-1604.8586,724.6096,11.6933), str = "Полицейского участка г. СФ";
				case 9: EnableGPSForPlayer(playerid,2292.0945,2421.0532,10.8203), str = "Полицейского участка г. ЛВ";
				case 10: EnableGPSForPlayer(playerid,1814.4481,-1890.3649,13.4141), str = "ЖДЛС";
				case 11: EnableGPSForPlayer(playerid,-1994.8622,112.8504,27.5391), str = "ЖДСФ";
				case 12: EnableGPSForPlayer(playerid,2806.9531,1312.4647,10.7500), str = "ЖДЛВ";
				case 13: EnableGPSForPlayer(playerid,-1970.0964,1118.4404,53.1299), str = "Церкви";
				case 14: EnableGPSForPlayer(playerid,2156.2654,2155.5183,10.6719), str = "Казино";
				case 15: EnableGPSForPlayer(playerid,-424.3238,-437.3412,17.2794), str = "Ловли рыбы";
				case 16: EnableGPSForPlayer(playerid,2225.3281,-1725.0433,13.5620), str = "Спортзала";
				case 17: EnableGPSForPlayer(playerid,2218.9026,1838.8079,10.8203), str = "Центра развлечений";

			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SendClientMessage(playerid,COLOR_YELLOW,string);
		}
		case D_GPS_WORK: {
			if(!response) return pc_cmd_gps(playerid);
			new string[144],str[40];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,-118.2737,7.1584,3.1172), str = "Яблочного сада";
				case 1: EnableGPSForPlayer(playerid,2675.6917,-2405.5618,13.4675), str = "Оружейного завода";
				case 2: EnableGPSForPlayer(playerid,284.3835,1426.6891,10.5859), str = "Нефтезавода";
				case 3: EnableGPSForPlayer(playerid,-495.1036,-1568.1460,9.8474), str = "Лесопилки";
				case 4: EnableGPSForPlayer(playerid,866.3123,-1245.8463,14.9381), str = "Склада";
				case 5: EnableGPSForPlayer(playerid,1269.4330,-1846.6799,13.3974), str = "Аренды автобусов г. ЛС";
				case 6: EnableGPSForPlayer(playerid,-1986.1086,192.0124,27.7047), str = "Аренды автобусов г. СФ";
				case 7: EnableGPSForPlayer(playerid,2784.5828,1274.3229,10.7500), str = "Аренды автобусов г. ЛВ";
				case 8: EnableGPSForPlayer(playerid,1071.2417,1948.1721,10.8203), str = "Аренды развозчиков продуктов";
				case 9: EnableGPSForPlayer(playerid,-10.1753,-314.8848,5.4229), str = "Аренды топлива продуктов";
				case 10: EnableGPSForPlayer(playerid,218.3788,-1443.7483,13.2123), str = "Аренды развозчиков еды г. ЛС";
				case 11: EnableGPSForPlayer(playerid,-2416.5146,-604.9440,132.5625), str = "Аренды развозчиков еды г. СФ";
				case 12: EnableGPSForPlayer(playerid,1636.6709,-1106.8654,23.9063), str = "Аренды транспорта механиков г. ЛС №1";
				case 13: EnableGPSForPlayer(playerid,-82.6767,-1155.2017,1.7500), str = "Аренды транспорта механиков г. ЛС №2";
				case 14: EnableGPSForPlayer(playerid,-2026.8943,142.5349,28.8359), str = "Аренды транспорта механиков г. СФ №1";
				case 15: EnableGPSForPlayer(playerid,-1648.2657,436.3811,7.1797), str = "Аренды транспорта механиков г. СФ №2";
				case 16: EnableGPSForPlayer(playerid,2127.3828,953.3461,10.8130), str = "Аренды транспорта механиков г. ЛС №1";
				case 17: EnableGPSForPlayer(playerid,2624.8748,1072.8818,10.8203), str = "Аренды транспорта механиков г. ЛВ №2";
				case 18: EnableGPSForPlayer(playerid,1639.0746,-1105.7719,23.9063), str = "Аренды транспорта для уборки улиц";
				case 19: EnableGPSForPlayer(playerid,1427.5365,-1837.8632,13.5469), str = "Аренды транспорта для скашивания травы";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW,string);
		}
		case D_GPS_GOS: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[32];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,1270.4175,-2053.0439,59.1521), str = "Белого дома";
				case 1: EnableGPSForPlayer(playerid,1480.9188,-1740.3135,13.5469), str = "Мэрии Лос-Сантос";
				case 2: EnableGPSForPlayer(playerid,1539.1508,-1675.5208,13.5469), str = "Полицейского участка г. ЛС";
				case 3: EnableGPSForPlayer(playerid,-1604.8586,724.6096,11.6933), str = "Полицейского участка г. СФ";
				case 4: EnableGPSForPlayer(playerid,2292.0945,2421.0532,10.8203), str = "Полицейского участка г. ЛВ";
				case 5: EnableGPSForPlayer(playerid,1184.2065,-1325.4333,13.5755), str = "Больницы г. ЛС";
				case 6: EnableGPSForPlayer(playerid,-2654.8313,623.7918,14.4531), str = "Больницы г. СФ";
				case 7: EnableGPSForPlayer(playerid,1607.5950,1831.1354,10.8203), str = "Больницы г. ЛВ";
				case 8: EnableGPSForPlayer(playerid,-1980.5592,-1012.2474,32.1719), str = "ФБР";
				case 9: EnableGPSForPlayer(playerid,107.3565,2072.0569,17.4144), str = "Армии [сухопутные войска]";
				case 10: EnableGPSForPlayer(playerid,-1529.3359,502.5937,7.1797), str = "Армии [военно-морской флот]";
				case 11: EnableGPSForPlayer(playerid,1589.3326,-1317.3939,17.5201), str = "Радиоцентра г. ЛС";
				case 12: EnableGPSForPlayer(playerid,-2482.1636,-616.2321,132.5656), str = "Радиоцентра г. СФ";
				case 13: EnableGPSForPlayer(playerid,2615.1035,1172.8719,10.7614), str = "Радиоцентра г. ЛВ";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW, string);
		}
		case D_GPS_RIELTOR: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[28];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,777.3998,-1041.3154,24.1305), str = "Риэлторского агенства г. ЛС";
				case 1: EnableGPSForPlayer(playerid,-2545.3013,320.7252,19.6200), str = "Риэлторского агенства г. СФ";
				case 2: EnableGPSForPlayer(playerid,2016.7900,1101.9283,10.8203), str = "Риэлторского агенства г. ЛВ";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW, string);
		}
		case D_GPS_NOLEGAL: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[24];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,1933.5902,-1130.1890,25.3224), str = "The Ballas";
				case 1: EnableGPSForPlayer(playerid,2742.2312,-1177.2218,69.2422), str = "Los Santos Vagos";
				case 2: EnableGPSForPlayer(playerid,2461.8611,-1658.8733,13.3047), str = "Grove Street";
				case 3: EnableGPSForPlayer(playerid,1696.4821,-2112.6555,13.4739), str = "Varrios Los Aztecas";
				case 4: EnableGPSForPlayer(playerid,2720.2114,-1946.7925,13.5469), str = "The Rifa";
				case 5: EnableGPSForPlayer(playerid,1447.0746,657.3666,10.8671), str = "Итальянской мафии";
				case 6: EnableGPSForPlayer(playerid,2514.0728,1824.1353,10.7868), str = "Японской мафии";
				case 7: EnableGPSForPlayer(playerid,1004.1752,1755.4628,10.7734), str = "Русской мафии";
				case 8: EnableGPSForPlayer(playerid,2310.4119,-1218.0474,23.9775), str = "Чёрного рынка";
				case 9: EnableGPSForPlayer(playerid,2194.1531,-2279.8872,13.5469), str = "Дуэлей";
				case 10: EnableGPSForPlayer(playerid,2339.5876,-1313.6565,24.0629), str = "Ограбления домов";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW, string);
		}
		case D_GPS_BANK: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[14];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,1418.9523,-1699.3098,13.5469), str = "Банка г. ЛС";
				case 1: EnableGPSForPlayer(playerid,-2361.9106,493.2753,30.7346), str = "Банка г. СФ";
				case 2: EnableGPSForPlayer(playerid,2577.3542,1317.7053,10.6999), str = "Банка г. ЛВ";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW, string);
		}
		case D_GPS_AIRPORT: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[16];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,1910.6567,-2326.6270,13.5469), str = "Аэропорта г. ЛС";
				case 1: EnableGPSForPlayer(playerid,-1280.7502,8.5439,14.1484), str = "Аэропорта г. СФ";
				case 2: EnableGPSForPlayer(playerid,1695.4163,1446.6281,10.7626), str = "Аэропорта г. ЛВ";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SCM(playerid, COLOR_YELLOW, string);
		}
		case D_GPS_TAXI: {
			if(!response) return pc_cmd_gps(playerid);
			new count_ammo = 1,string[128];
			for(new i = 0; i < gBusinessCount; i ++) {
				if(gBusiness[i][bizzType] != 11) continue;
				if((count_ammo-1) == listitem) {
					format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",FuncBizz[i+1][funcbName]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					EnableGPSForPlayer(playerid,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					break;
				}
				count_ammo++;
			}
			return 1;
		}
		case D_GPS_TK: {
			if(!response) return pc_cmd_gps(playerid);
			new count_ammo = 1,string[200],str[28];
			for(new i = 0; i < gBusinessCount; i ++) {
				if(gBusiness[i][bizzType] != 14) continue;
				if((count_ammo-1) == listitem) {
					format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",FuncBizz[i+1][funcbName]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					EnableGPSForPlayer(playerid,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					break;
				}
				count_ammo++;
			}
			switch(listitem) {
				case 3: EnableGPSForPlayer(playerid,2653.8486,-2387.8660,13.6328), str = "[Загрузка] Оружейный завод";
				case 4: EnableGPSForPlayer(playerid,253.3007,1396.0299,10.5859), str = "[Загрузка] Нефтезавод";
				case 5: EnableGPSForPlayer(playerid,-1744.4447,149.4602,3.5496), str = "[Разгрузка] Порт г. СФ";
				case 6: EnableGPSForPlayer(playerid,2616.7119,-2226.7627,13.3819), str = "[Разгрузка] Порт г. ЛС";
				//case 7: EnableGPSForPlayer(playerid,2687.9753,-2480.1912,13.5008), str = "[Разгрузка] Оружейный завод";
			}
			if(listitem >= 3) {
				format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
				SendClientMessage(playerid,COLOR_YELLOW,string);
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			return 1;
		}
		case D_GPS_HOTEL: {
			if(!response) return pc_cmd_gps(playerid);
			new count_ammo = 1,string[128];
			for(new i = 0; i < gHotelCount; i ++) {
				if((count_ammo-1) == listitem) {
					format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",gHotels[i][hotelName]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					EnableGPSForPlayer(playerid,gHotels[i][hotelAreaX],gHotels[i][hotelAreaY],gHotels[i][hotelAreaZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					break;
				}
				count_ammo++;
			}
			return 1;
		}
		case D_GPS_BIZZ: {
			if(!response) return pc_cmd_gps(playerid);
			new count_ammo = 1,string[128];
			for(new i = 0; i < gBusinessCount; i ++) {
				if(gBusiness[i][bizzUpgrade][1] != 1) continue;
				if((count_ammo-1) == listitem) {
					format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",gBusiness[i][bizzName]);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					EnableGPSForPlayer(playerid,gBusiness[i][bizzX],gBusiness[i][bizzY],gBusiness[i][bizzZ]);
					PlayerPlaySound(playerid, 1056, 0, 0, 0);
					break;
				}
				count_ammo++;
			}
			return 1;
		}
		case D_GPS_AUTOSALON: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[22];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,557.0374,-1264.0369,17.2422), str = "Автосалона [Эконом]";
				case 1: EnableGPSForPlayer(playerid,-1980.1460,289.2669,35.1719), str = "Автосалона [Стандарт]";
				case 2: EnableGPSForPlayer(playerid,2107.0535,1377.9354,10.8607), str = "Автосалона [Спорт]";
				case 3: EnableGPSForPlayer(playerid,2126.6680,-1119.6429,25.3591), str = "Мотосалона";
				case 4: EnableGPSForPlayer(playerid,614.5059,-1505.9735,14.9054), str = "Perfomance Tuning"; // new
				case 5: EnableGPSForPlayer(playerid,1151.0156,-1224.6001,17.4627), str = "Тюнинга г. ЛС";
				case 6: EnableGPSForPlayer(playerid,-1787.5232,1197.9948,25.1194), str = "Тюнинга г. СФ";
				case 7: EnableGPSForPlayer(playerid,1643.3086,2187.9753,10.8203), str = "Тюнинга г. ЛВ";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SendClientMessage(playerid,COLOR_YELLOW,string);
		}
		case D_GPS_GAME: {
			if(!response) return pc_cmd_gps(playerid);
			new string[120],str[22];
			switch(listitem) {
				case 0: EnableGPSForPlayer(playerid,1022.5626,-1130.8978,23.8281), str = "Компьютерного клуба";
				case 1: EnableGPSForPlayer(playerid, 2163.6824,2160.8635,10.8203), str = "Казино";
			}
			PlayerPlaySound(playerid, 1056, 0, 0, 0);
			format(string,sizeof(string),"Местоположение %s отмечено у вас на GPS",str);
			SendClientMessage(playerid,COLOR_YELLOW,string);
		}
		case DIALOG_ATM_EDIT: {
			if(!response) {
				EdittingATM[playerid] = 0;
				return 1;
			}
			new string[128], atmID = EdittingATM[playerid];
			switch (listitem) {
				case 0: {
					EditDynamicObject(playerid, ATMData[atmID][atm_Object]);
					format(string, sizeof(string), "Вы изменяете позицию ATM (ID: %d).", atmID);
					SendOk(playerid, string);
				}
				case 1: {
					new vw, Float:ATMPosa[4], int;
					GetPlayerPos(playerid, ATMPosa[0], ATMPosa[1], ATMPosa[2]);
					GetPlayerFacingAngle(playerid, ATMPosa[3]);
					vw  = GetPlayerVirtualWorld(playerid);
					int = GetPlayerInterior(playerid);
					ATMData[atmID][ATM_Pos][0]   = ATMPosa[0];
					ATMData[atmID][ATM_Pos][1]   = ATMPosa[1];
					ATMData[atmID][ATM_Pos][2]   = ATMPosa[2];
					ATMData[atmID][ATM_Pos][3]   = 0;
					ATMData[atmID][ATM_Pos][4]   = 0;
					ATMData[atmID][ATM_Pos][5]   = ATMPosa[3];
					ATMData[atmID][atm_VW]  	 = vw;
					ATMData[atmID][atm_INT]  	 = int;
					ATMData[atmID][atm_Taken]    = 1;
					if (ATMData[atmID][atm_Object]) DestroyDynamicObject(ATMData[atmID][atm_Object]);
					ATMData[atmID][atm_Object] = CreateDynamicObject(2754, ATMData[atmID][ATM_Pos][0]+2, ATMData[atmID][ATM_Pos][1], ATMData[atmID][ATM_Pos][2], 0.0, 0.0, ATMData[atmID][ATM_Pos][5], ATMData[atmID][atm_VW], ATMData[atmID][atm_INT]);
					UpdateATMLabel(atmID);
					SaveATM(atmID);
				}
				case 2: D(playerid, DIALOG_ATM_EDIT_DELETE, DSM, ""P"Удаление ATM", "Удалить банкомат?", "Да", "Нет");
			}
		}
		case DIALOG_ATM_EDIT_DELETE: {
			new title[128], atmID = EdittingATM[playerid];
			if(!response) {
				format(title, sizeof(title), "Изменение ATM: (ID: %d)", atmID);
				D(playerid, DIALOG_ATM_EDIT, DSL, title, "Изменение позиции(редактор)\nПеренести позицию на свои координаты\nУдаление ATM", "Далее", "Отмена");
			}
			else DeleteATM(playerid, atmID);
		}
		case D_FREE: {
			if(!response) return 1;
			new id = GetPVarInt(playerid,"FreeOffer") - 1;
			new price = GetPVarInt(playerid,"FreePrice");
			new percent = floatround(price/100*15);
			DeletePVar(playerid,"FreePrice");
			DeletePVar(playerid,"FreeOffer");
			switch(listitem) {
				case 0: {
					if(PI[playerid][pCash] < price) {
						SendOk(id, "У игрока недостаточно средств для оплаты Ваших услуг");
						ErrorMessage(playerid, "Недостаточно средств для оплаты");
						return 1;
					}
					GiveMoney(playerid,-price,"оплата адвокату");
					GiveMoney(id,percent,"услуги адвоката");
				}
				case 1: {
					if(PI[playerid][pBank] < price) {
						SendOk(id, "У игрока недостаточно средств для оплаты Ваших услуг");
						ErrorMessage(playerid, "Недостаточно средств для оплаты");
						return 1;
					}
					PI[playerid][pBank] -= price;
					PI[id][pBank] += percent;
					UpdatePlayerData(playerid,"pBank",PI[playerid][pBank]);
					UpdatePlayerData(id,"pBank",PI[id][pBank]);
				}
			}
			FI[fWHITEHOUSE][fBank] += (price-percent);
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
			new string[156];
			format(string, sizeof(string), "Адвокат "P"%s"G" освободил Вас за "ORANGE"$%d",player_name[id], price);
			SendUse(playerid,string);

			format(string, sizeof(string), "Вы выпустили "P"%s"G" за "ORANGE"$%d."G" Способ оплаты: "W"%s",player_name[playerid], percent,(listitem == 0) ? ("наличные") : ("банк. счёт"));
			SendUse(id,string);
			SetPlayerPosAC(playerid, camExit[PI[playerid][pJail]-1][0],camExit[PI[playerid][pJail]-1][1],camExit[PI[playerid][pJail]-1][2], 0, 0);
			SetPlayerFacingAngle(playerid,camExit[PI[playerid][pJail]-1][3]);
			SetCameraBehindPlayer(playerid);
			PI[playerid][pJailTime] = 0;
			PI[playerid][pJail] = 0;
			UpdatePlayerData(playerid,"pJailTime",0);
			UpdatePlayerData(playerid,"pJail",0);
			GameTextForPlayer(playerid, "~g~~h~FREEDOM", 5000, 1);
			return 1;
		}
		case D_ECONOMY: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Казна штата: \t\t\t\t"YELLOW"$%d\n\n\
											"W"Заработная плата оружейный завод:\t"GREEN"$%d\n\
											"W"Заработная плата нефтезавод:\t"GREEN"$%d\n\
											"W"Заработная плата яблочный сад:\t"GREEN"$%d\n\
											"W"Заработная плата алькатрас:\t\t"GREEN"$%d\n\
											"W"Заработная плата лесопилка:\t\t"GREEN"$%d\n\
											"W"Заработная плата грузчики:\t\t"GREEN"$%d\n\
											"W"Налогообложение бизнесов:\t\t"ORANGE"%d%%\n\
											"W"Налоги заработных плат гос.структур:\t"ORANGE"%d%%";
					new string[sizeof(f_str) +1 + (-2 + 13) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3)];
					format(string,sizeof(string),f_str,FI[fWHITEHOUSE][fBank],WorkSalary[0],WorkSalary[1],WorkSalary[3],WorkSalary[2], WorkSalary[4], WorkSalary[5], Nalog[3],Nalog[0]);
					D(playerid,DIALOG_NONE,DSM, ""P"Информация",string,"Закрыть","");
				}
				case 1: {
					static const f_str[] = "\n\n"W"Заработная плата на оружейном заводе составляет: "GREEN"$%d\n\
											Установите новую заработную плату на оружейном заводе:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[0]);
					D(playerid,D_ECONOMY_GUN,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 2: {
					static const f_str[] = "\n\n"W"Заработная плата на нефтезаводе составляет: "GREEN"$%d\n\
											Установите новую заработную плату на нефтезаводе:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[1]);
					D(playerid,D_ECONOMY_OIL,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 3: {
					static const f_str[] = "\n\n"W"Заработная плата в яблочном саду составляет: "GREEN"$%d\n\
											Установите новую заработную плату в яблочном саду:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[3]);
					D(playerid,D_ECONOMY_APPLE,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 4: {
					static const f_str[] = "\n\n"W"Заработная плата в алькатрасе составляет: "GREEN"$%d\n\
											Установите новую заработную плату в алькатрасе:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[2]);
					D(playerid,D_ECONOMY_ALCO,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 5: {
					static const f_str[] = "\n\n"W"Заработная плата на лесопилке составляет: "GREEN"$%d\n\
											Установите новую заработную плату на лесопилке:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[4]);
					D(playerid,D_ECONOMY_WOOD,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 6: {
					static const f_str[] = "\n\n"W"Заработная плата грузчика составляет: "GREEN"$%d\n\
											Установите новую заработную плату грузчика:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[5]);
					D(playerid,D_ECONOMY_WOOD,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 7: {
					static const f_str[] = "\n\n"W"Заработная плата шахтёра составляет: "GREEN"$%d\n\
											Установите новую заработную плату шахтёра:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,WorkSalary[6]);
					D(playerid,D_ECONOMY_MINE,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 8: {
					static const f_str[] = "\n\n"W"Налогообложение бизнесов составляет: "GREEN"$%d\n\
											Установите новое налогообложение бизнесов:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,Nalog[3]);
					D(playerid,D_ECONOMY_BIZZ,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 9: {
					static const f_str[] = "\n\n"W"Налоги заработных плат гос.структур составляют: "GREEN"$%d\n\
											Установите новые налоги заработных плат гос.структур:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,Nalog[0]);
					D(playerid,D_ECONOMY_NALOG,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 10: D(playerid,D_ECONOMY_SALARY,DSL,""P"Управление штатом",""P"1."W" Полиция\n"P"2."W" ФБР\n"P"3."W" Мэрия\n"P"4."W" Армии\n"P"5."W" Больницы\n"P"6."W" Новостные студии\n"P"7."W" Белый дом","Выбрать", "Отмена");
				case 11: D(playerid,D_ECONOMY_PREM,DSL,""P"Управление штатом",""P"1."W" Полиция ЛС\n"P"2."W" Полиция СФ\n"P"3."W" Полиция ЛВ\n"P"4."W" ФБР\n"P"5."W" Армия СФ\n"P"6."W" Армия ЛВ\n"P"7."W" Больница г.ЛС\n"P"8."W" Больница г.СФ\n"P"9."W" Больница г.ЛВ\n"P"10."W" Радиоцентр ЛС\n"P"11."W" Радиоцентр СФ\n"P"12."W" Радиоцентр ЛВ","Выбрать", "Отмена");
				case 12: D(playerid,D_ECONOMY_PENS,DSL,""P"Управление штатом",""P"1."W" Размер пенсии\n"P"2."W" Пенсионный возраст","Выбрать", "Отмена");
				case 13: D(playerid,D_ECONOMY_PUT,DSI,""P"Управление штатом","\n\n"W"Укажите сумму, на которую хотите пополнить казну штата\n\n","Пополнить", "Отмена");
				case 14: D(playerid,D_ECONOMY_INPUT,DSI,""P"Управление штатом","\n\n"W"Укажите сумму, которую хотите снять с казны штата\n\n","Снять", "Отмена");
			}
		}
		case D_ECONOMY_PENS: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = "\n\n"W"Размер пенсии составляет: "GREEN"$%d\n\
											Установите новый размер пенсии:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,Nalog[2]);
					D(playerid,D_ECONOMY_PENS_1,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
				case 1: {
					static const f_str[] = "\n\n"W"Пенсионный возраст составляет: "GREEN"%d\n\
											Установите новый пенсионный возраст:\n\n";
					new string[sizeof(f_str) +1 + (-2 + 3)];
					format(string,sizeof(string),f_str,Nalog[1]);
					D(playerid,D_ECONOMY_PENS_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				}
			}
		}
		case D_ECONOMY_PENS_1: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 1000 || salary > 5000) {
				static const f_str[] = "\n\n"W"Размер пенсии составляет: "GREEN"$%d\n\
											Установите новый размер пенсии:\n\n"NO"*"G" От $1000 до $5000\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,Nalog[2]);
				D(playerid,D_ECONOMY_PENS_1,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			Nalog[2] = salary;
			UpdateEconomyData("nalog_3",salary);
			static const f_string[] = "Размер пенсии в размере "GREEN"$%d"G" установлен";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,Nalog[2]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_PENS_2: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 15 || salary > 25) {
				static const f_str[] = "\n\n"W"Пенсионный возраст составляет: "GREEN"%d\n\
											Установите новый пенсионный возраст:\n\n"NO"*"G" От 15 до 25\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,Nalog[1]);
				D(playerid,D_ECONOMY_PENS_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			Nalog[1] = salary;
			UpdateEconomyData("nalog_2",salary);
			static const f_string[] = "Пенсионный возраст "GREEN"$%d"G" лет установлен";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,Nalog[1]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_GUN: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 60 || salary > 160) {
				static const f_str[] = "\n\n"W"Заработная плата на оружейном заводе составляет: "GREEN"$%d\n\
											Установите новую заработную плату на оружейном заводе:\n\n"NO"*"G" От $60 до $160\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[0]);
				D(playerid,D_ECONOMY_GUN,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[0] = salary;
			UpdateEconomyData("work_gun",salary);
			static const f_string[] = "Заработная плата на оружейном заводе в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[0]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_OIL: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 60 || salary > 180) {
				static const f_str[] = "\n\n"W"Заработная плата на нефтезаводе составляет: "GREEN"$%d\n\
											Установите новую заработную плату на нефтезаводе:\n\n"NO"*"G" От $60 до $180\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[1]);
				D(playerid,D_ECONOMY_OIL,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[1] = salary;
			UpdateEconomyData("work_oil",salary);
			static const f_string[] = "Заработная плата на нефтезаводе в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[1]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_APPLE: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 10 || salary > 50) {
				static const f_str[] = "\n\n"W"Заработная плата в яблочном саду составляет: "GREEN"$%d\n\
											Установите новую заработную плату в яблочном саду:\n\n"NO"*"G" От $10 до $50\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[3]);
				D(playerid,D_ECONOMY_APPLE,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[3] = salary;
			UpdateEconomyData("work_apple",salary);
			static const f_string[] = "Заработная плата в яблочном саду в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[3]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_WOOD: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 30 || salary > 120) {
				static const f_str[] = "\n\n"W"Заработная плата на лесопилке составляет: "GREEN"$%d\n\
											Установите новую заработную плату на лесопилке:\n\n"NO"*"G" От $30 до $120\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[4]);
				D(playerid,D_ECONOMY_WOOD,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[4] = salary;
			UpdateEconomyData("work_wood",salary);
			static const f_string[] = "Заработная плата на лесопилке в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[4]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_LOADER:
		{

			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 30 || salary > 120) {
				static const f_str[] = "\n\n"W"Заработная плата грузчика составляет: "GREEN"$%d\n\
											Установите новую заработную плату грузчика:\n\n"NO"*"G" От $30 до $120\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[5]);
				D(playerid,D_ECONOMY_ALCO,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[5] = salary;
			UpdateEconomyData("work_loader",salary);
			static const f_string[] = "Заработная плата грузчика в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[5]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_MINE: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 1 || salary > 10) {
				static const f_str[] = "\n\n"W"Заработная плата шахта составляет: "GREEN"$%d\n\
											Установите новую заработную плату шахта:\n\n"NO"*"G" От $1 до $10\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[6]);
				D(playerid,D_ECONOMY_MINE,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[6] = salary;
			UpdateEconomyData("work_mine",salary);
			static const f_string[] = "Заработная плата шахте в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[6]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_ALCO: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 20 || salary > 40) {
				static const f_str[] = "\n\n"W"Заработная плата в алькатрасе составляет: "GREEN"$%d\n\
											Установите новую заработную плату в алькатрасе:\n\n"NO"*"G" От $20 до $40\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,WorkSalary[2]);
				D(playerid,D_ECONOMY_ALCO,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			WorkSalary[2] = salary;
			UpdateEconomyData("work_alco",salary);
			static const f_string[] = "Заработная плата в алькатрасе в размере "ORANGE"$%d"G" установлена";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,WorkSalary[2]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_BIZZ: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 1 || salary > 15) {
				static const f_str[] = "\n\n"W"Налогообложение бизнесов составляет: "P"%d%%\n\
											Установите новое налогообложение бизнесов:\n\n"NO"*"G" От 1%% до 15%%\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,Nalog[3]);
				D(playerid,D_ECONOMY_BIZZ,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			Nalog[3] = salary;
			UpdateEconomyData("nalog_4",salary);
			static const f_string[] = "Налогообложение бизнесов в размере "ORANGE"%d%%"G" установлено";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,Nalog[3]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_NALOG: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 5 || salary > 15) {
				static const f_str[] = "\n\n"W"Налоги заработных плат гос.структур составляют: "P"%d%%\n\
											Установите новые налоги заработных плат гос.структур:\n\n"NO"*"G" От 5%% до 15%%\n\n";
				new string[sizeof(f_str) +1 + (-2 + 3)];
				format(string,sizeof(string),f_str,Nalog[0]);
				D(playerid,D_ECONOMY_NALOG,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
				return 1;
			}
			Nalog[0] = salary;
			UpdateEconomyData("nalog_1",salary);
			static const f_string[] = "Налоги заработных плат гос.структур в размере "ORANGE"%d%%"G" установлены";
			new str[sizeof(f_string) +1 + (-2 + 4)];
			format(str,sizeof(str),f_string,Nalog[0]);
			SendUse(playerid,str);
		}
		case D_ECONOMY_SALARY: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			switch(listitem) {
				case 0: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fLSPD][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fLSPD,i),i,FracSalary[0][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 1: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fFBI][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fFBI,i),i,FracSalary[1][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 2: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fMAYOR][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fMAYOR,i),i,FracSalary[2][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 3: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fARMYSF][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fARMYSF,i),i,FracSalary[3][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 4: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fMEDICLS][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fMEDICLS,i),i,FracSalary[4][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 5: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fLSNEWS][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fLSNEWS,i),i,FracSalary[5][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
				case 6: {
					new string[555];
					string = "Должность\tРанг\tЗарплата\n";
					for(new i = 1; i <= FI[fWHITEHOUSE][fMaxRang]; i++) {
						format(string,sizeof(string),"%s%s\t%i\t%d\n",string,GetRankName(fWHITEHOUSE,i),i,FracSalary[8][i-1]);
						D(playerid,D_ECONOMY_SALARY_1,DSTH,""P"Выберите ранг",string,"Выбрать","Закрыть");
					}
				}
			}
			SetPVarInt(playerid, "variable_zp", listitem);
		}
		case D_ECONOMY_SALARY_1: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			SetPVarInt(playerid, "variable_rang", listitem);
			switch(GetPVarInt(playerid, "variable_zp")) {
				case 0: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Полиция\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fLSPD,listitem+1),listitem+1,FracSalary[0][listitem],GetRankName(fLSPD,listitem+1),salary_pd[listitem]/2,salary_pd[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 1: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - ФБР\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fFBI,listitem+1),listitem+1,FracSalary[1][listitem],GetRankName(fFBI,listitem+1),salary_fbi[listitem]/2,salary_fbi[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 2: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Мэрия\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fMAYOR,listitem+1),listitem+1,FracSalary[2][listitem],GetRankName(fMAYOR,listitem+1),salary_mayor[listitem]/2,salary_mayor[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 3: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Армии\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fARMYSF,listitem+1),listitem+1,FracSalary[3][listitem],GetRankName(fARMYSF,listitem+1),salary_army[listitem]/2,salary_army[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 4: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Больницы\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fMEDICLS,listitem+1),listitem+1,FracSalary[4][listitem],GetRankName(fMEDICLS,listitem+1),salary_medics[listitem]/2,salary_medics[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 5: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Новостная студия\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fLSNEWS,listitem+1),listitem+1,FracSalary[5][listitem],GetRankName(fLSNEWS,listitem+1),salary_news[listitem]/2,salary_news[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
				case 6: {
					static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Правительство\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
					new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,GetRankName(fWHITEHOUSE,listitem+1),listitem+1,FracSalary[8][listitem],GetRankName(fWHITEHOUSE,listitem+1),salary_wh[listitem]/2,salary_wh[listitem]);
					D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
					return 1;
				}
			}
		}
		case D_ECONOMY_SALARY_2: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			new list = GetPVarInt(playerid, "variable_rang");
			switch(GetPVarInt(playerid, "variable_zp")) {
				case 0: {
					if(salary < salary_pd[list]/2 || salary > salary_pd[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Полиция\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fLSPD,list+1),list+1,FracSalary[0][list],GetRankName(fLSPD,list+1),salary_pd[list]/2,salary_pd[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[0][list] = salary;
					save_salary(0);
				}
				case 1: {
					if(salary < salary_fbi[list]/2 || salary > salary_fbi[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - ФБР\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fFBI,list+1),list+1,FracSalary[1][list],GetRankName(fFBI,list+1),salary_fbi[list]/2,salary_fbi[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[1][list] = salary;
					save_salary(1);
				}
				case 2:
				{
					if(salary < salary_mayor[list]/2 || salary > salary_mayor[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Мэрия\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fWHITEHOUSE,list+1),list+1,FracSalary[2][list],GetRankName(fMAYOR,list+1),salary_mayor[list]/2,salary_mayor[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[2][list] = salary;
					save_salary(2);
				}
				case 3: {
					if(salary < salary_army[list]/2 || salary > salary_army[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Армии\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fARMYSF,list+1),list+1,FracSalary[3][list],GetRankName(fARMYSF,list+1),salary_army[list]/2,salary_army[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[3][list] = salary;
					save_salary(3);
				}
				case 4: {
					if(salary < salary_medics[list]/2 || salary > salary_medics[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Больницы\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fMEDICLS,list+1),list+1,FracSalary[4][list],GetRankName(fMEDICLS,list+1),salary_medics[list]/2,salary_medics[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[4][list] = salary;
					save_salary(4);
				}
				case 5: {
					if(salary < salary_news[list]/2 || salary > salary_news[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Новостная студия\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fLSNEWS,list+1),list+1,FracSalary[5][list],GetRankName(fLSNEWS,list+1),salary_news[list]/2,salary_news[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[5][list] = salary;
					save_salary(5);
				}
				case 6: {
					if(salary < salary_wh[list]/2 || salary > salary_wh[list]) {
						static const f_str[] = "\n\n"W"Заработная плата %s(%d) $%d - Правительство\n\
											Установите новую заработную плату для ранга %s:\n\n"NO"*"G" От %d до %d\n\n";
						new string[sizeof(f_str) +1 + (-2 + 24) + (-2 + 4) + (-2 + 6) + (-2 + 24) + (-2 + 5) + (-2 + 5)];
						format(string,sizeof(string),f_str,GetRankName(fWHITEHOUSE,list+1),list+1,FracSalary[8][list],GetRankName(fWHITEHOUSE,list+1),salary_wh[list]/2,salary_wh[list]);
						D(playerid,D_ECONOMY_SALARY_2,DSI, ""P"Управление штатом",string,"Установить", "Отмена");
						return 1;
					}
					FracSalary[8][list] = salary;
					save_salary(8);
				}
			}
			SendOk(playerid,"Заработная плата изменена");
		}
		case D_ECONOMY_PREM: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new frac;
			switch(listitem) {
				case 0: frac = fLSPD;
				case 1: frac = fSFPD;
				case 2: frac = fLVPD;
				case 3: frac = fFBI;
				case 4: frac = fARMYSF;
				case 5: frac = fARMYLV;
				case 6: frac = fMEDICLS;
				case 7: frac = fMEDICSF;
				case 8: frac = fMEDICLV;
				case 9: frac = fLSNEWS;
				case 10: frac = fSFNEWS;
				case 11: frac = fLVNEWS;
			}
			SetPVarInt(playerid,"prem_fration",frac);
			new string[156];
			format(string,sizeof(string),"\n\n"W"Укажите сумму перевода:\nОрганизация: "ORANGE"%s\n\n",FI[frac][fName]);
			D(playerid,D_ECONOMY_PREM_1,DSI, ""P"Управление штатом",string,"Перевести", "Отмена");
		}
		case D_ECONOMY_PREM_1: {
			if(!response) return DeletePVar(playerid,"prem_fration");
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 50000 || salary > 500000) {
				new string[156];
				format(string,sizeof(string),"\n\n"W"Укажите сумму перевода:\nОрганизация: "ORANGE"%s\n\n"NO"*"G" От $50.000 до $500.000\n\n",FI[GetPVarInt(playerid,"prem_fration")][fName]);
				D(playerid,D_ECONOMY_PREM_1,DSI, ""P"Управление штатом",string,"Перевести", "Отмена");
				return 1;
			}
			if(FI[fWHITEHOUSE][fBank] - salary < 0) return ErrorMessage(playerid,"В казне недостаточно средств");
			if(FI[fWHITEHOUSE][fBankCash] + salary > 500000) {
				new string[128];
				format(string,sizeof(string),"Суточный лимит на перевод/снятие средств с казны - $500.000. Доступный лимит: $%d",500000-FI[fWHITEHOUSE][fBankCash]);
				ErrorMessage(playerid,string);
				return 1;
			}
			FI[fWHITEHOUSE][fBankCash] += salary;
			UpdateFraction(fWHITEHOUSE,"BankCash",FI[fWHITEHOUSE][fBankCash]);
			FI[GetPVarInt(playerid,"prem_fration")][fBank] += salary;
			UpdateFraction(GetPVarInt(playerid,"prem_fration"),"Bank",FI[GetPVarInt(playerid,"prem_fration")][fBank]);
			FI[fWHITEHOUSE][fBank] -= salary;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
			static const f_string[] = "Перевод денежных средств в размере "ORANGE"$%d"G" организации "P"%s"G" выполнен успешно";
			new str[sizeof(f_string) +1 + (-2 + 4) + (-2 + 24)];
			format(str,sizeof(str),f_string,salary,FI[GetPVarInt(playerid,"prem_fration")][fName]);
			SendUse(playerid,str);
			DeletePVar(playerid,"prem_fration");
		}
		case D_ECONOMY_PUT: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 1 || salary > 500000) {
				D(playerid,D_ECONOMY_PUT,DSI, ""P"Управление штатом","\n\n"W"Укажите сумму, на которую хотите пополнить казну штата\n\n"NO"*"G" От $1 до $500.000\n\n","Пополнить", "Отмена");
				return 1;
			}
			if(GetPlayerMoneyEx(playerid) < salary) {
				D(playerid,D_ECONOMY_PUT,DSI, ""P"Управление штатом","\n\n"W"Укажите сумму, на которую хотите пополнить казну штата\n\n"NO"*"G" У Вас недостаточно средств\n\n","Пополнить", "Отмена");
				return 1;
			}
			GiveMoney(playerid,-salary,"пополнение казны");
			FI[fWHITEHOUSE][fBank] += salary;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			FI[fWHITEHOUSE][fBankCash] -= salary;
			if(FI[fWHITEHOUSE][fBankCash] < 0) FI[fWHITEHOUSE][fBankCash] = 0;
			UpdateFraction(fWHITEHOUSE,"BankCash",FI[fWHITEHOUSE][fBankCash]);

			static const f_string[] = "Вы пополнили казну штата на "ORANGE"$%d";
			new str[sizeof(f_string) +1 + (-2 + 5)];
			format(str,sizeof(str),f_string,salary);
			SendUse(playerid,str);
		}
		case D_ECONOMY_INPUT: {
			if(!response) return 1;
			if(PI[playerid][pLeader] != fWHITEHOUSE) return 1;
			new salary = strval(inputtext);
			if(salary < 1 || salary > 500000) {
				D(playerid,D_ECONOMY_INPUT,DSI, ""P"Управление штатом","\n\n"W"Укажите сумму, которую хотите снять с казны штата\n\n"NO"*"G" От $1 до $500.000\n\n","Снять", "Отмена");
				return 1;
			}
			if(FI[fWHITEHOUSE][fBank] < salary) {
				D(playerid,D_ECONOMY_INPUT,DSI, ""P"Управление штатом","\n\n"W"Укажите сумму, которую хотите снять с казны штата\n\n"NO"*"G" В казне недостаточно средств\n\n","Снять", "Отмена");
				return 1;
			}
			if(FI[fWHITEHOUSE][fBankCash] + salary > 500000) {
				static const f_str[] = "\n\n"W"Укажите сумму, которую хотите снять с казны штата\n\n"NO"*"G" Суточный лимит на перевод/снятие средств с казны - $500.000. Доступный лимит: $%d\n\n";
				new string[sizeof(f_str) +1 + (-2 + 6)];
				format(string,sizeof(string),f_str,500000-FI[fWHITEHOUSE][fBankCash]);
				D(playerid,D_ECONOMY_INPUT,DSI, ""P"Управление штатом",string,"Снять", "Отмена");
				return 1;
			}
			GiveMoney(playerid,salary,"снятие с казны");
			FI[fWHITEHOUSE][fBank] -= salary;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);

			FI[fWHITEHOUSE][fBankCash] += salary;
			UpdateFraction(fWHITEHOUSE,"BankCash",FI[fWHITEHOUSE][fBankCash]);

			static const f_string[] = "Вы сняли с казны штата "ORANGE"$%d";
			new str[sizeof(f_string) +1 + (-2 + 5)];
			format(str,sizeof(str),f_string,salary);
			SendUse(playerid,str);
		}
		case D_REC_KICK: {
			if(!response) return 1;
			if(SERIU[playerid][sID] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Произоша ошибка");
			if(!strlen(inputtext)) return D(playerid,D_REC_KICK,DSI, ""P"KICK","\n\n"W"Введите причину, по которой хотите кикнуть игрока с сервера:\n\n","Кикнуть","Отмена");
			new string[64];
			format(string,sizeof(string),"%d %s",SERIU[playerid][sID],inputtext);
			callcmd::kick(playerid,string);
			if(TI[playerid][pAndroid]) SelectTextDraw(playerid, 0xFF0000FF);
		}
		case D_REC_WARN: {
			if(!response) return 1;
			if(SERIU[playerid][sID] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Произоша ошибка");
			if(!strlen(inputtext)) return D(playerid,D_REC_WARN,DSI, ""P"WARN","\n\n"W"Введите причину, по которой хотите выдать Warn игроку:\n\n","Варн","Отмена");
			new string[64];
			format(string,sizeof(string),"%d %s",SERIU[playerid][sID],inputtext);
			callcmd::warn(playerid,string);
			if(TI[playerid][pAndroid]) SelectTextDraw(playerid, 0xFF0000FF);
		}
		case D_REC_BAN: {
			if(!response) return 1;
			if(SERIU[playerid][sID] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Произоша ошибка");
			new Days,Reason[31];
			if(sscanf(inputtext, "p<,>is[30]",Days,Reason)) return D(playerid,D_REC_BAN,DSI, ""P"BAN","\n\n"W"Введите причину, по которой хотите заблокировать аккаунт игроку:\n"NO"ВНИМАНИЕ!"W" Введите время и причину через запятую без пробелов (15,читер)\nВремя блокировки аккаунта: от 7 до 30 дней\n\n","Бан","Отмена");
			new string[78];
			format(string,sizeof(string),"%d %d %s",SERIU[playerid][sID],Days,Reason);
			callcmd::ban(playerid,string);
			if(TI[playerid][pAndroid]) SelectTextDraw(playerid, 0xFF0000FF);
		}
		case D_UNBAN: {
		    if(!response) return 1;
		    if(!IsBannedName(UnbanName[playerid])) return ErrorMessage(playerid,"Данный игрок не заблокирован");
			UnBanName(UnbanName[playerid]);
			new string[144];
			format(string,sizeof(string),"[A] Администратор %s разблокировал игрока %s",player_name[playerid],UnbanName[playerid]);
			AdmMSG(0x1965D9AA, string,1);
			WriteLog(LOG_UNBAN,player_name[playerid],UnbanName[playerid],"разблокировка");
		}
		case D_ELECTION: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					new string[54 * MAX_VOTES];
					string = ""W"";
					for(new i = 0; i < MAX_VOTES; i++) {
						if(strlen(vote_name[i])) {
							format(string, sizeof(string), "%s%i. %s (%i голосов)\n", string, i+1, vote_name[i],vote_count[i]);
						}
						else format(string,sizeof(string),"%s%i. -\n",string, i+1);
					}
					D(playerid,DIALOG_NONE,DSM, ""P"Список кандидатов",string,"Закрыть","");
				}
				case 1: {
					for(new i = 0; i < MAX_VOTES; i++) {
						if(!strlen(vote_name[i])) {
							SetPVarInt(playerid,"vote_slot", i);
							D(playerid,D_ELECTION_1, DSI, ""P"Добавление кандитата", "\n\nВведите имя кандитата:\n\n","Ввод","Отмена");
							return 1;
						}
					}
					return ErrorMessage(playerid,"Достигнут лимит кандитатов");
				}
				case 2: {
					new string[256];
					for(new i = 0; i < MAX_VOTES; i++) {
						if(strlen(vote_name[i])) {
							format(string,sizeof(string), "%s%s\n",string,vote_name[i]);
						}
						else strcat(string,"-\n");
					}
					if(!strlen(string)) return ErrorMessage(playerid,"Кандитатов нет");
					D(playerid,D_ELECTION_3, DSL, ""P"Удаление кандитата", string, "Выбрать", "Закрыть");
				}
				case 3: {
					if(election) return ErrorMessage(playerid,"Пикап для голосований уже установлен");
					election = CreateDynamicPickup(19134,1,697.8492,-114.2701,1071.6169,44); // Мэрия
					election3D = CreateDynamic3DTextLabel(""P"Голосование", -1, 697.8492,-114.2701,1071.6169+1.0, 15.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1, -1, -1); // Мэрия
					new string[144];
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Уважаемые жители штата", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Начались выборы президента", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Голосование доступно с 3-х лет проживания в штате", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Спасибо за внимание", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
				}
				case 4: {
					new win_count = 0;
					new win_slot = 0;
					for(new i = 0; i < MAX_VOTES; i++) {
						if(strlen(vote_name[i])) {
							if(vote_count[i] > win_count) {
								win_count = vote_count[i];
								win_slot = i;
								new query[128];
								mysql_format(connects,query,sizeof(query),"DELETE FROM `vote` WHERE `vote_name` = '%e'",vote_name[i]);
								mysql_pquery(connects, query, "", "");
								vote_count[i] = 0;
							}
						}
					}
					new string[144];
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Уважаемые жители штата", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Выборы окончены. Новый президент штата: %s (%i голосов)", player_name[playerid], playerid, vote_name[win_slot], win_count);
					SendClientMessageToAll(COLOR_RED, string);
					format(string, sizeof(string), "[ВЫБОРЫ] %s [%d]: Спасибо за внимание", player_name[playerid], playerid);
					SendClientMessageToAll(COLOR_RED, string);
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(PI[i][pGolos]) PI[i][pGolos] = 0;
					}
					mysql_pquery(connects, "UPDATE `accounts` SET `pGolos` = '0'", "", "");
					for(new i = 0; i < MAX_VOTES; i++) {
						if(strlen(vote_name[i])) {
							strmid(vote_name[i],"",strlen(""),MAX_PLAYER_NAME);
						}
					}
					if(election) DestroyDynamicPickup(election),election = 0;
					DestroyDynamic3DTextLabel(election3D);
				}
			}
			return 1;
		}
		case D_ELECTION_3: {
			if(!response) return 1;
			if(!strcmp(inputtext,"-")) return 1;
			new string[1120];
			format(string, sizeof(string), "Вы убрали "P"%s"G" с выборов", vote_name[listitem]);
			SendUse(playerid,string);
			new query[70];
			mysql_format(connects,query,sizeof(query),"DELETE FROM `vote` WHERE `vote_name` = '%e'",vote_name[listitem]);
			mysql_pquery(connects, query, "", "");
			strmid(vote_name[listitem],"",strlen(""),MAX_PLAYER_NAME);
			vote_count[listitem] = 0;
			return 1;
		}
		case D_ELECTION_1: {
			if(!response) return 1;
			if(!strlen(inputtext) || strlen(inputtext)>23) return ErrorMessage(playerid,"От 1 до 23");
			new slot = GetPVarInt(playerid,"vote_slot");
			strmid(vote_name[slot],inputtext,0,strlen(inputtext), MAX_PLAYER_NAME);
			new string[110];
			format(string,sizeof(string),"Вы добавили кандитата: "W"%s", inputtext);
			SendOk(playerid,string);
			new query[256];
			mysql_format(connects,query,sizeof(query),"INSERT INTO `vote`(`vote_name`, `vote_count`) VALUES ('%e','%i')",vote_name[slot],vote_count[slot]);
			mysql_pquery(connects, query, "", "");
			DeletePVar(playerid,"vote_slot");
			return 1;
		}
		case D_ELECTION_2: {
			if(!response) return 1;
			if(!strlen(vote_name[listitem])) return ErrorMessage(playerid,"Кандитат не назначен");
			vote_count[listitem]++;
			new query[128];
			mysql_format(connects,query,sizeof(query),"UPDATE `vote` SET `vote_count` = '%i' WHERE `vote_name` = '%e'",vote_count[listitem],vote_name[listitem]);
			mysql_pquery(connects, query, "", "");
			new string[144];
			format(string,sizeof(string),"Вы отдали свой голос за "P"%s. "G"Спасибо за участие в голосовании!",vote_name[listitem]);
			SendOk(playerid,string);
			PI[playerid][pGolos] = 1;
			UpdatePlayerData(playerid,"pGolos",PI[playerid][pGolos]);
			if(GetPVarInt(playerid,"anti_sbiv_time") <= unix) ApplyAnimation(playerid,"CRIB","CRIB_Use_Switch",4.0,0,0,0,0,0,0);
			return 1;
		}
		case D_MAYOR: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					static const f_str[] = ""W"Казна штата: \t\t\t\t"YELLOW"$%d\n\n\
											"W"Заработная плата оружейный завод:\t"GREEN"$%d\n\
											"W"Заработная плата нефтезавод:\t"GREEN"$%d\n\
											"W"Заработная плата яблочный сад:\t"GREEN"$%d\n\
											"W"Заработная плата алькатрас:\t\t"GREEN"$%d\n\
											"W"Заработная плата лесопилка:\t\t"GREEN"$%d\n\
											"W"Заработная плата грузчики:\t\t"GREEN"$%d\n\
											"W"Заработная плата шахта:\t\t"GREEN"$%d\n\
											"W"Налогообложение бизнесов:\t\t"ORANGE"%d%%\n\
											"W"Налоги заработных плат гос.структур:\t"ORANGE"%d%%";
					new string[sizeof(f_str) +1 + (-2 + 13) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3) + (-2 + 3)];
					format(string,sizeof(string),f_str,FI[fWHITEHOUSE][fBank],WorkSalary[0],WorkSalary[1],WorkSalary[3],WorkSalary[2], WorkSalary[4], WorkSalary[5], WorkSalary[6], Nalog[3],Nalog[0]);
					D(playerid,DIALOG_NONE,DSM, ""P"Информация",string,"Закрыть","");
				}
				case 1: D(playerid,D_MAYOR_BLAGO,DSI, ""P"Благотворительность","\n\n"W"Введите сумму, которую хотите пожертвовать в казну штата:\n\n","Перевести", "Отмена");
				case 2: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `Name`,`pBlago` FROM `accounts` ORDER BY `pBlago` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new name[MAX_PLAYER_NAME + 1];
						new blago;
						new string[300];
	       				string = ""P"№ Имя\t"P"Пожертвовал\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"$%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "Name", name, MAX_PLAYER_NAME);
							cache_get_value_name_int(i, "pBlago",blago);
							format(str, sizeof(str), f_str, i+1, name,blago);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, "Самые щедрые", string, "Закрыть", "");
					}
					cache_delete(result);
				}
			}
		}
		case D_MAYOR_BLAGO: {
			if(!response) return 1;
			new salary = strval(inputtext);
			if(salary < 1000 || salary > 1000000) {
				D(playerid,D_MAYOR_BLAGO,DSI, ""P"Благотворительность","\n\n"W"Введите сумму, которую хотите пожертвовать в казну штата:\n\n"NO"*"G" От $1.000 до $1.000.000\n\n","Перевести", "Отмена");
				return 1;
			}
			if(GetPlayerMoneyEx(playerid) < salary) return ErrorMessage(playerid,"У Вас недостаточно средств");
			GiveMoney(playerid,-salary,"пожертвование");
			PI[playerid][pBlago] += salary;
			UpdatePlayerData(playerid,"pBlago",PI[playerid][pBlago]);
			FI[fWHITEHOUSE][fBank] += salary;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
			static const f_string[] = "Вы успешно пожертвовали "ORANGE"$%d"G" в казну штата";
			new str[sizeof(f_string) +1 + (-2 + 9)];
			format(str,sizeof(str),f_string,salary);
			SendUse(playerid,str);
		}
		case dRentCar: {
		    if(!response) return DeletePVar(playerid,"rent_carid");
			new arid = GetArendCarID(GetPVarInt(playerid, "rent_carid"));
			DeletePVar(playerid,"rent_carid");
			if(!lic[playerid][0]) return ErrorMessage(playerid,"У Вас нет водительских прав");
			if(arid != -1) {
				if(TI[playerid][tArendKey] == -1) {
					if(ArendInfo[arid][aPlayerID] == INVALID_PLAYER_ID || !IsPlayerConnected(ArendInfo[arid][aPlayerID])) {
						if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
							new seller = floatround(ArendInfo[arid][aCost]/100*vip_status[PI[playerid][pVips]][vip_rentcar]);
							if(PI[playerid][pCash] < (ArendInfo[arid][aCost]-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
							GiveMoney(playerid,-(ArendInfo[arid][aCost]-seller),"аренда ТС");
						}
						else {
							if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
								new seller = floatround(ArendInfo[arid][aCost]/100*BonusInfo[act_rentcar]);
								if(PI[playerid][pCash] < (ArendInfo[arid][aCost]-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
								GiveMoney(playerid,-(ArendInfo[arid][aCost]-seller),"аренда ТС");
							}
							else if(BonusInfo[act_select] == 2) {
								new seller = floatround(ArendInfo[arid][aCost]/100*BonusInfo[act_rentcar]);
								if(PI[playerid][pCash] < (ArendInfo[arid][aCost]-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
								GiveMoney(playerid,-(ArendInfo[arid][aCost]-seller),"аренда ТС");
							}
						    else {
						    	if(PI[playerid][pCash] < ArendInfo[arid][aCost]) return ErrorMessage(playerid,"У Вас недостаточно средств");
						    	GiveMoney(playerid,-ArendInfo[arid][aCost],"аренда ТС");
						    }
						}

						bizz_pay(ArendInfo[arid][aBizz],floatround(ArendInfo[arid][aCost]*0.2));
						TI[playerid][tArendKey] = arid;

						ArendInfo[arid][aPlayerID] = playerid;
						D(playerid, DIALOG_NONE, DSM, ""P"Транспортное средство арендовано", ""W"Список доступных комманд:\n\n"YELLOW"/rlock(/rlk)"W" - Закрыть/Открыть арендованный транспорт\n"YELLOW"/unrent"W" - Отказаться от аренды\n\n"NO"При отдалении от Т/С на 2км контракт автоматически расторгается", "Закрыть", "");
					}
					else ErrorMessage(playerid, "Этот транспорт уже арендуют");
				}
				else ErrorMessage(playerid,"Вы уже арендуете транспорт");
			}
		}
		case D_COP_GUN: {
			if(!response) return 1;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 40: {

				}
				case 41: {}
				case 42: {}
			}
			switch(listitem) {
				case 0: AC_GivePlayerWeapon(playerid,24,21);
				case 1: AC_GivePlayerWeapon(playerid,25,30);
				case 2: AC_GivePlayerWeapon(playerid,29,90);
				case 3: AC_GivePlayerWeapon(playerid,31,150);
				case 4: AC_GivePlayerWeapon(playerid,3,1);
				case 5: SetPlayerArmour(playerid,100);
			}

		}
		case dGiveGunTD: {
			if(!response) return true;
			if(!PI[playerid][pMember]) return 1;

			if(strfind(inputtext, "Бронежилет") != -1) {
				SetPlayerArmour(playerid, 100.0);
				return true;
			}
			if(listitem >= 9) return true;
			if(GunTickGet[playerid][listitem] > unix) return ErrorMessage(playerid,"Нельзя брать оружие слишком часто");
			GunTickGet[playerid][listitem] = unix+20;
			new team;
			switch(GetPlayerVirtualWorld(playerid)) {
				case 40: team = fLSPD;
				case 41: team = fSFPD;
				case 42: team = fLVPD;
				case 43: team = fFBI;
			}
			for(new i = 0 ; i < 9 ; i++) {
				if(strfind(inputtext, FW[i][team][fwName]) != -1) {
					new count_minus = 100;
					switch(FW[i][team][fwGunID]) {
						case 24: count_minus = 60;
						case 25: count_minus = 60;
						case 29: count_minus = 80;
						case 31: count_minus = 100;
						case 30: count_minus = 100;
						case 34: count_minus = 250;
						case 99: count_minus = 30;
						default: count_minus = 90;
					}
					if(FI[team][fMats] < count_minus) return ErrorMessage(playerid,"Недостаточно боеприпасов");
					if(IsACop(playerid) && PI[playerid][pRank] == 1 && FW[i][team][fwGunID] != 3) {
						ErrorMessage(playerid,"Для Вашего ранга доступна только дубинка");
						return true;
					}
					FI[team][fMats] -= count_minus;
					UpdateFraction(team,"Mats",FI[team][fMats]);
					if(FW[i][team][fwGunID] == 99) {
						if(PI[playerid][pMask] == vip_status[PI[playerid][pVips]][vip_mask]) {
							new string[128];
							format(string,sizeof(string),"Нельзя хранить больше %d масок",vip_status[PI[playerid][pVips]][vip_mask]);
							ErrorMessage(playerid, string);
							return 1;
						}
						PI[playerid][pMask] += 1;
						UpdatePlayerData(playerid,"pMask",PI[playerid][pMask]);
						SendUse(playerid,"Использовать маску - "W"/mask");
						return 1;
					}
					AC_GivePlayerWeapon(playerid,FW[i][team][fwGunID],FW[i][team][fwGunAmmo]);
					break;
				}
			}
			ShowGetGun(playerid);
			return true;
		}
		case D_MATERIALS_BUY: {
			if(!response) return 1;
			if(!IsAMafia(playerid)) return ErrorMessage(playerid,"Вы не мафиози");
			if(GetPlayerMoneyEx(playerid) < 50000) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(GetPlayerMoneyEx(playerid) < 50000) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(FI[GetTeamID(playerid)][fMats]+10000 > 300000) return ErrorMessage(playerid,"На склад Вашей мафии не поместится столько боеприпасов");
			FI[GetTeamID(playerid)][fMats] += 10000;
			UpdateFraction(GetTeamID(playerid),"Mats",FI[GetTeamID(playerid)][fMats]);
			GiveMoney(playerid,-50000,"покупка матов мафии");
			SendOk(playerid, "Вы купили 10000 боеприпасов за 50000 вирт");
		}
		case dEContract: {
			if(!response) return 1;
			if(!IsNumber(inputtext) || !strlen(inputtext) || (strval(inputtext) < 5 && strval(inputtext) > 50)) return ErrorMessage(playerid,"От 5 до 50 хот-догов");
			new litres = strval(inputtext);
			new price = litres*gBusiness[GetPVarInt(playerid,"e_biz")][bizzPrice]*50;
			if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(GetPVarInt(playerid,"eatcolvo") + litres > 50) return ErrorMessage(playerid,"В машину не поместится больше 50 хот-догов");
			GiveMoney(playerid,-price,"развозчик еды контракт");
			if(gBusiness[GetPVarInt(playerid,"e_biz")][bizzProduct] - litres > 0) {
				gBusiness[GetPVarInt(playerid,"e_biz")][bizzProduct] -= litres;
				bizz_pay(GetPVarInt(playerid,"e_biz"),price);
			}
			new string[128];
			format(string, sizeof(string),""G"Хот-догов: "P"%d ед.",GetPVarInt(playerid,"eatcolvo") + litres);
			UpdateDynamic3DTextLabelText(PlayerEatText[playerid], -1, string);
			SetPVarInt(playerid,"eatcolvo",GetPVarInt(playerid,"eatcolvo") + litres);
			DeletePVar(playerid,"e_biz");
			return 1;
		}
		case dFContract: {
			if(!response) return 1;
			if(!IsNumber(inputtext) || !strlen(inputtext) || (strval(inputtext) < 1 && strval(inputtext) > 50)) return ErrorMessage(playerid,"От 1 до 50л");
			new litres = strval(inputtext);
			new price = litres*gBusiness[GetPVarInt(playerid,"f_biz")][bizzPrice];
			if(PI[playerid][pCash] < price) return ErrorMessage(playerid,"У Вас недостаточно денег");
			if(GetPVarInt(playerid,"toplivo") + litres > 100) return ErrorMessage(playerid,"В машину не поместится больше 100л топлива");
			GiveMoney(playerid,-price,"механик контракт");
			if(gBusiness[GetPVarInt(playerid,"f_biz")][bizzProduct] - litres > 0) {
				gBusiness[GetPVarInt(playerid,"f_biz")][bizzProduct] -= litres;
				bizz_pay(GetPVarInt(playerid,"f_biz"),price);
			}
			new string[128];
			format(string, sizeof(string),""G"Топливо: "P"%d л.",GetPVarInt(playerid,"toplivo") + litres);
			UpdateDynamic3DTextLabelText(PlayerMehText[playerid], -1, string);
			SetPVarInt(playerid,"toplivo",GetPVarInt(playerid,"toplivo") + litres);
			DeletePVar(playerid,"f_biz");
			return 1;
		}
		case dRefill: {
			new id_mhnk = GetPVarInt(playerid,"id_refill")-1;
			new price_mhnk = GetPVarInt(id_mhnk,"price_refill");
			new litres = GetPVarInt(id_mhnk,"litres_refill");
			DeletePVar(id_mhnk,"id_repair");
			DeletePVar(id_mhnk,"price_repair");
			DeletePVar(playerid,"id_repair");
			if(!response) {
				SendOk(id_mhnk,"Игрок отказался от предложения");
				SendOk(playerid,"Вы отказались от предложения");
			}
			else {
				if(GetPlayerMoneyEx(playerid) < price_mhnk) {
					SendOk(id_mhnk,"У игрока недостаточно средств");
					ErrorMessage(playerid,"У Вас недостаточно средств для оплаты");
					return 1;
				}
				new string[144];
				format(string,sizeof(string), "Механик "P"%s"G" заправил Вам автомобиль на "W"%d"G" литров за "ORANGE"$%i",player_name[id_mhnk],litres,price_mhnk);
				SendUse(playerid,string);

				format(string,sizeof(string), "Вы заправили автомобиль "P"%s "G"на "W"%d"G" литров за "ORANGE"$%i",player_name[playerid],litres,price_mhnk);
				SendUse(id_mhnk,string);

				GiveMoney(playerid,-price_mhnk,"оплата механику заправка");
				GiveMoney(id_mhnk,price_mhnk,"ЗП механику заправка");
				new vehicleid = GetPlayerVehicleID(playerid);

				if(vehicleid) VehicleInfo[vehicleid][vFuel] += float(litres);
				SetPVarInt(id_mhnk,"toplivo",GetPVarInt(id_mhnk,"toplivo") - litres);

				format(string, sizeof(string),""G"Топливо: "P"%d л.",GetPVarInt(id_mhnk,"toplivo"));
				UpdateDynamic3DTextLabelText(PlayerMehText[id_mhnk], -1, string);
			}
			return 1;
		}
		case dEHotDog: {
			new id_mhnk = GetPVarInt(playerid,"id_hotdog")-1;
			new price_mhnk = GetPVarInt(id_mhnk,"price_hotdog");
			DeletePVar(id_mhnk,"id_hotdog");
			DeletePVar(id_mhnk,"price_hotdog");
			DeletePVar(playerid,"id_hotdog");
			if(!response) {
				SendOk(id_mhnk,"Игрок отказался от предложения");
				SendOk(playerid,"Вы отказались от предложения");
			}
			else {
				if(GetPlayerMoneyEx(playerid) < price_mhnk) {
					SendOk(id_mhnk,"У игрока недостаточно средств");
					ErrorMessage(playerid,"У Вас недостаточно средств для оплаты");
					return 1;
				}
				new string[144];
				format(string,sizeof(string), "Продавец хот-догов "P"%s"G" продал Вам хот-дог за "ORANGE"$%i",player_name[id_mhnk],price_mhnk);
				SendUse(playerid,string);

				format(string,sizeof(string), "Вы продали хот-дог "P"%s"G" за "ORANGE"$%i",player_name[playerid],price_mhnk);
				SendUse(id_mhnk,string);

				GiveMoney(playerid,-price_mhnk,"оплата продавцу еды");
				GiveMoney(id_mhnk,price_mhnk,"ЗП продавцу еды");

				GiveFullness(playerid, 40);

				SetPVarInt(id_mhnk,"eatcolvo",GetPVarInt(id_mhnk,"eatcolvo") - 1);

				format(string, sizeof(string),""G"Хот-Догов: "P"%d ед.",GetPVarInt(id_mhnk,"eatcolvo"));
				UpdateDynamic3DTextLabelText(PlayerEatText[id_mhnk], -1, string);
			}
			return 1;
		}
		case D_MARRIED: {
			new id_marriage = GetPVarInt(playerid,"ProposeOffer")-1;
			DeletePVar(id_marriage,"ProposeOffer");
			if(!response) {
				SendOk(id_marriage,"Игрок отказался от предложения");
				SendOk(playerid,"Вы отказались от предложения");
			}
			else {
				if(!GetPVarInt(playerid,"ProposeOffer")) return ErrorMessage(playerid, "Вам ни кто не предлагал выйти замуж/жениться");
				if(!PlayerToPoint(10.0, playerid, -1988.6638,1117.8837,54.4726)) return ErrorMessage(playerid, "Вы не у церкви");
				if(!IsPlayerConnected(id_marriage)) return ErrorMessage(playerid, not_id);
				if(!IsPlayerStream(10.0, playerid, id_marriage)) return ErrorMessage(playerid, "Жених/Невеста не рядом с Вам");
				new string[144];
				format(string, sizeof(string), "Вы приняли предложение от "W"%s's", player_name[id_marriage]);
				SendOk(playerid, string);
				format(string, sizeof(string), "%s принял(а) Ваш запрос быть Вашей(ым) Женой/Мужем", player_name[playerid]);
				SendClientMessage(id_marriage, 0x6ab1ffaa, string);
				format(string, sizeof(string), "{FC6DEC}::: Поздравляем! %s и %s теперь муж и жена! :::", player_name[playerid], player_name[id_marriage]);
				SendClientMessageToAll(-1,string);

				strmid(PI[playerid][pMarried], player_name[id_marriage], 0, strlen(player_name[id_marriage]));
				strmid(PI[id_marriage][pMarried], player_name[playerid], 0, strlen(player_name[playerid]));

				new query[156];
				mysql_format(connects, query, sizeof(query), "UPDATE `accounts` SET `pMarried` = '%e' WHERE `pID` = '%d' LIMIT 1",PI[id_marriage][pMarried],PI[playerid][pID]);
				mysql_pquery(connects, query, "", "");

				mysql_format(connects,query, sizeof(query), "UPDATE `accounts` SET `pMarried` = '%e' WHERE `pID` = '%d' LIMIT 1",PI[playerid][pMarried],PI[id_marriage][pID]);
				mysql_pquery(connects, query, "", "");
			}
			return 1;
		}
		case D_BUYNARKO: {
			if(!response) return 1;
		    if(strval(inputtext) < 1 || strval(inputtext) > 51) {
				static const f_str[] = ""W"Укажите количество наркотиков для покупки:\n\n\
                "O"Примечание:"W"\n\
                \tСтоимость "P"1г"W" наркотиков: "GREEN"$%d"W"\n\
				\tВ карман поместится: "P"%d"W"\n";
				new string[sizeof(f_str) +1 + (-2 +5) + (-2 +5)];

				format(string,sizeof(string),f_str,pricedrugs,50-PI[playerid][pDrugs]);
				D(playerid,D_BUYNARKO,DSI, ""P"Покупка наркотиков", string, "Купить", "Отмена");
				return 1;
			}
		    if(PI[playerid][pDrugs] + strval(inputtext) > vip_status[PI[playerid][pVips]][vip_drugs]) return ErrorMessage(playerid,"Вы не можете взять слишком много");
			if(GetPlayerMoneyEx(playerid) < pricedrugs*strval(inputtext)) return ErrorMessage(playerid,"У Вас недостаточно денег");
			GiveMoney(playerid,-pricedrugs*strval(inputtext),"покупка нарко притон");
			PI[playerid][pDrugs] += strval(inputtext);
			UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
			new string[128];
			format(string,sizeof(string),"Вы купили "P"%dг "G"наркотиков за "ORANGE"$%d",strval(inputtext),pricedrugs*strval(inputtext));
			SendUse(playerid,string);
		}
		case D_ADMC: {
			if(!response) return 1;
			if(PI[playerid][pAdmin] < listitem+1) return ErrorMessage(playerid,"Мелкий ещё");
			new string[1800],str[120];
			for(new adm = 0;adm < MAX_ADM_CMDS;adm++) {
				if(AdminCommand[adm][cmdLVL] != listitem+1) continue;
				format(str, sizeof(str), "\n\t{70c425}%s"W" - %s", AdminCommand[adm][cmdName], AdminCommand[adm][cmdInfo]);
				strcat(string, str);
			}
			D(playerid,DIALOG_NONE,DSM, ""P"Админ команды",string,"Закрыть","");
		}
		case D_YOUTUBE_CMD: {
			if(!response) return 1;
			if(PI[playerid][pYoutube] < listitem+1) return ErrorMessage(playerid,"Мелкий ещё");
			new string[1800],str[120];
			for(new y = 0;y < MAX_YOUTUBE_CMDS;y++) {
				if(YoutubeCommand[y][cmdLVL] != listitem+1) continue;
				format(str, sizeof(str), "\n\t{70c425}%s"W" - %s", YoutubeCommand[y][cmdName], YoutubeCommand[y][cmdInfo]);
				strcat(string, str);
			}
			D(playerid,DIALOG_NONE,DSM, ""P"Ютуб команды",string,"Закрыть","");
		}
		case D_MP: {
	        if(!response) return 1;
        	switch(listitem) {
				case 0: {
					if(!Teleport) {
						new string[200];
						if(!Teleport_Players[0]) return ErrorMessage(playerid,"Необходимо указать кол-во участников мероприятия");
					    if(strcmp(Teleport_text,"None",true) == 0) return ErrorMessage(playerid,"Необходимо ввести название мероприятия");
						format(string,sizeof(string),""YELLOW"[МП]"W" Создано мероприятие "YELLOW"%s"W". Количество участников: "P"%d",Teleport_text,Teleport_Players[0]);
						SendClientMessageToAll(-1,string);
						SendClientMessageToAll(-1,""YELLOW"[МП]"W"Для телепорта введите: "P"'/mp'");
      					GetPlayerPos(playerid, TeleportFloat[0], TeleportFloat[1], TeleportFloat[2]);
				        TeleportInfo[0] = GetPlayerInterior(playerid);
				        TeleportInfo[1] = GetPlayerVirtualWorld(playerid);
            			Teleport = true;
						format(string, sizeof(string), "[A] %s[%d] создал мероприятие",player_name[playerid],playerid);
						AdmMSG(0x1965D9AA, string,1);
					}
					else {
						new string[128];
                        format(string,sizeof(string),""YELLOW"[МП]"W" Мероприятие "YELLOW"%s"W" телепорт удалён",Teleport_text);
						SendClientMessageToAll(-1,string);
						strmid(Teleport_text, "None", 0, strlen("None"), 36);
						Teleport = false;
						Teleport_Players[0] = Teleport_Players[1] = 0;
					}
				}
				case 1: D(playerid, D_MP_1, DSI, ""P"Выдача оружия", "\n\n"W"Введите "P"ID"W" оружия и патроны\nПример: 31,500\nГде 31 M4, а 500 патроны\n\n", "Выдать", "Выход");
				case 2: {
     				foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid, i) > 50) continue;
						SetPlayerHealth(i, 100);
						SendOk(i, "Администратор выдал Вам жизни");
					}
				}
    			case 3: {
     				foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid, i) > 50) continue;
						SetPlayerArmour(i, 100);
						SendOk(i, "Администратор выдал вам броню");
					}
				}
				case 4: {
     				foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid,i) > 50) continue;
						ResetPlayerWeapons(i);
						SendOk(i, "Администратор забрал у Вас оружие");
					}
				}
    			case 5: {
     				foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid,i) > 50) continue;
						SetPlayerArmour(i, 0);
						SendOk(i, "Администратор забрал у Вас броню");
					}
				}
				case 6: {
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid,i) > 50) continue;
						if(i == playerid) continue;
						TogglePlayerControllable(i, 0);
						SendOk(i, "Администратор заморозил Вас");
					}
					SendOk(playerid,"Игроки заморожены");
				}
				case 7: {
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(GetDistanceBetweenPlayers(playerid,i) > 50) continue;
						if(i == playerid) continue;
						TogglePlayerControllable(i, 1);
						SendOk(i, "Администратор разморозил Вас");
					}
					SendOk(playerid,"Игроки разморожены");
				}
				case 8: D(playerid, D_MP_5, DIALOG_STYLE_INPUT, "Название", "\n\n"W"Введите ID временного скина и радиус:\nПример: 299,10\nГде 299 ID скина, а 10 радиус\n\n", "Ввод", "Отмена");
				case 9: D(playerid, D_MP_2, DIALOG_STYLE_INPUT, "Название", "\n\n"W"Введите название мероприятия:\n\n", "Ввод", "Отмена");
				case 10: D(playerid, D_MP_4, DIALOG_STYLE_INPUT, "Кол-во участников", "\n\n"W"Введите количество участников:\n\n", "Ввод", "Отмена");
			}
		}
		case D_MP_5: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid, D_MP_5, DIALOG_STYLE_INPUT, "Название", "\n\n"W"Введите ID временного скина и радиус:\nПример: 299,10\nГде 299 ID скина, а 10 радиус\n\n", "Ввод", "Отмена");
			else if(strfind(inputtext,",", true) != -1) {
				new razdel[2][24];
				split(inputtext, razdel, ',');
				if(!(5 <= strval(razdel[1]) <= 50)) return D(playerid, D_MP_5, DIALOG_STYLE_INPUT, "Название", "\n\n"W"Введите ID временного скина и радиус:\nПример: 299,10\nГде 299 ID скина, а 10 радиус\n"NO"*"G" Радиус от 5 до 50\n\n", "Ввод", "Отмена");
				if(!(1 <= strval(razdel[0]) <= 311)) return D(playerid, D_MP_5, DIALOG_STYLE_INPUT, "Название", "\n\n"W"Введите ID временного скина и радиус:\nПример: 299,10\nГде 299 ID скина, а 10 радиус\n"NO"*"G" Скины от 1 до 311\n\n", "Ввод", "Отмена");
    			foreach(new i:Player) {
					if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
					if(GetDistanceBetweenPlayers(playerid, i) > strval(razdel[1])) continue;
					if(i == playerid) continue;
					A_SetPlayerSkin(i, strval(razdel[0]));
					SendOk(i, "Администратор выдал Вам временный скин");
				}
				SendOk(playerid,"Временные скины выданы");
			}
			return 1;
		}
      	case D_MP_1: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid, D_MP_1, DSI, ""P"Выдача оружия", "\n\nВведите "P"ID"W" оружия и патроны\nПример: 31,500\nГде 31 M4, а 500 патроны\n\n", "Выдать", "Выход");
			else if(strfind(inputtext,",", true) != -1) {
				new razdel[2][24];
				split(inputtext, razdel, ',');
    			foreach(new i:Player) {
					if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
					if(GetDistanceBetweenPlayers(playerid, i) > 50) continue;
					AC_GivePlayerWeapon(i, strval(razdel[0]), strval(razdel[1]));
					SendOk(i, "Администратор выдал вам оружие");
				}
			}
			return 1;
		}
    	case D_MP_3: {
            if(!response) return 1;
            SetPlayerPosAC(playerid, TeleportFloat[0], TeleportFloat[1]+2, TeleportFloat[2],TeleportInfo[1],TeleportInfo[0]);
			Teleport_Players[1]++;
            return 1;
        }
        case D_MP_4: {
			if(!response) return 1;
			if(!strlen(inputtext)) return D(playerid, D_MP_4, DSI, "Кол-во участников", "\n\n"W"Введите количество участников:\n\n", "Ввод", "Отмена");
			if(!(5 <= strval(inputtext) <= 100)) {
				return D(playerid, D_MP_4, DSI, "Кол-во участников", "\n\n"W"Введите количество участников:\n\n"NO"*"G" От 5 до 100 мест\n\n", "Ввод", "Отмена");
			}
			new string[128];
			format(string,sizeof(string),"Лимит участников: "P"%d"W" создан",strval(inputtext));
			SendOk(playerid,string);
			Teleport_Players[0] = strval(inputtext);
			return 1;
		}
		case D_MP_2: {
			if(!response) return 1;
			if(!strlen(inputtext)) D(playerid, D_MP_2, DSI, ""P"Название", "\n\n"W"Введите название мероприятия\n\n", "Ввод", "Отмена");
			else if(strfind(inputtext,"", true) != 0) {
			    strmid(Teleport_text,inputtext,0,strlen(inputtext),36);
			}
			new string[128];
			format(string,sizeof(string),"Название: "P"%s"W" создано",inputtext);
			SendOk(playerid,string);
			return 1;
		}
		case D_COMP_GAME: {
	    	if(!response) return 1;
	    	switch(listitem) {
	    	    case 0: D(playerid,D_COMP_GAME_1,DSL,""P"Capture Blocks",""P"1."W" Играть\n"P"2."W" Информация", "Выбрать", "Закрыть");
	    	    case 1: D(playerid,D_COMP_GAME_2,DSL,""P"DM - Арена",""P"1."W" Играть\n"P"2."W" Информация\n"P"3."W" TOP - 5", "Выбрать", "Закрыть");
	    	    case 2: D(playerid,D_COMP_GAME_3,DSL,""P"Гонка Вооружений",""P"1."W" Играть\n"P"2."W" Информация\n"P"3."W" TOP - 5", "Выбрать", "Закрыть");
			}
		}
		case D_COMP_GAME_1: {
	    	if(!response) return 1;
	    	switch(listitem) {
	    	    case 0: {
	          		if(g_game_status != 2) {
						new Float:pos[3];
						GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
						SetPVarFloat(playerid, "pos_comp_x", pos[0]);
						SetPVarFloat(playerid, "pos_comp_y", pos[1]);
						SetPVarFloat(playerid, "pos_comp_z", pos[2]);
						SetPVarInt(playerid, "comp_int", GetPlayerInterior(playerid));
						SetPVarInt(playerid, "comp_vw", GetPlayerVirtualWorld(playerid));
						DelGun(playerid);
						if(g_game_status == 0) {
							g_sign_up_timer = SetTimer("MinigamePrepare", 30000, false);
							g_game_status = 1;
							SendOk(playerid,"Вы создали сервер. Ожидайте подключение других игроков [30 секунд]");
							TI[playerid][tBlockWars] = true;
						}
						else if(g_game_status == 1) {
			    			if(!TI[playerid][tBlockWars]) {
								TI[playerid][tBlockWars] = true;
								SendOk(playerid, "Вы присоединились к игре");
								new null;
				    			foreach(new i:Player) {
									if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
									if(!TI[i][tBlockWars]) continue;
									null++;
									if(null == 4) {
										break;
									}
								}
								if(null == 4) {
									KillTimer(g_sign_up_timer);
									MinigamePrepare();
								}
							}
							else ErrorMessage(playerid,"Вы уже записались на игру");
						}
					}
					else ErrorMessage(playerid,"Игра уже началась");
				}
	    	    case 1: {
					static const f_str[] = "\t\t\t{FFFF00}- Capture Blocks -"W"\n\n\
						Суть данной мини-игры {FFFF00}'Capture Blocks'"W" такова:\n\
						За {FFFF00}1"W" минуту захватить большее количество квадратов,\n\
						квадрат захватывается и красится в {FFFF00}Ваш"W" цвет,\n\
						свой цвет можно узнать на текстдрайве при начале мини-игры.\n\
						Максимальное количество игроков - {FFFF00}4"W", минимальное - {FFFF00}2"W".";
				    new string[sizeof(f_str)];
					format(string,sizeof(string),f_str);
					D(playerid,DIALOG_NONE,DSM, ""P"Capture Blocks",string, "Закрыть", "");
				}
			}
		}
		case D_COMP_GAME_2: {
	    	if(!response) return 1;
	    	if(TI[playerid][tBlockWars]) return ErrorMessage(playerid,"Вы записаны на игру Capture Blocks");
	    	switch(listitem) {
	    	    case 0: {
					TI[playerid][tDMArea][0] = 1;
					TI[playerid][tDMArea][1] = 0;
					TI[playerid][tDMArea][2] = 0;
					new Float:pos[3];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					SetPVarFloat(playerid, "pos_comp_x", pos[0]);
					SetPVarFloat(playerid, "pos_comp_y", pos[1]);
					SetPVarFloat(playerid, "pos_comp_z", pos[2]);
					SetPVarInt(playerid, "comp_int", GetPlayerInterior(playerid));
					SetPVarInt(playerid, "comp_vw", GetPlayerVirtualWorld(playerid));
					new string[100];
     				format(string, sizeof(string), "Присоединился новый игрок - "ORANGE"%s",player_name[playerid]);
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!TI[i][tDMArea][0]) continue;
						SendClientMessage(i,-1,string);
					}
					SendOk(playerid,"Для выхода из DM-Арены,используйте: "W"/exitdm");
					DelGun(playerid);
					AC_GivePlayerWeapon(playerid, PaintGun[random(sizeof(PaintGun))], 3000);
	    	    	new rand = random(sizeof(DmArenaSpawns));
					SetPlayerPosAC(playerid, DmArenaSpawns[rand][0], DmArenaSpawns[rand][1], DmArenaSpawns[rand][2],8,0);
					SetPlayerHealth(playerid, 100.0);
					SetPlayerColor(playerid,0x56FB4EFF);
					format(string,sizeof(string),"{1bd12f}Убийств:{ffffff}%d\n{1bd12f}Смертей:{ffffff}%d",TI[playerid][tDMArea][1],TI[playerid][tDMArea][2]);
					DestroyDynamic3DTextLabel(DMSTATUS[playerid]);
					DMSTATUS[playerid] = CreateDynamic3DTextLabel(string, 0xFF6347FF, 0,0,0.4,10.0,playerid,INVALID_VEHICLE_ID,1,-1,-1,-1,10);
				}
				case 1: {
				    static const f_str[] = "\t\t\t\t{FFFF00}- DM - Арена -"W"\n\n\
						Добро пожаловать на {FFFF00}'DM - Арену'"W".\n\
						Данный режим предназначен для отдыха души и разума от повседневных забот.\n\
						Оружие: {FFFF00}Рандомное"W"\n\
						После убийства ваше здоровье пополняется на {FFFF00}25 хп"W".\n\
						Цель игры: Набрать наибольшее количество убийств\n\n\
						Приз - {FFFF00}ВСЕОБЩЕЕ УВАЖЕНИЕ";
				    new string[sizeof(f_str)];
					format(string,sizeof(string),f_str);
					D(playerid,DIALOG_NONE,DSM, ""P"DM - Арена",string, "Закрыть", "");
				}
				case 2: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `Name`,`pKills` FROM `accounts` ORDER BY `pKills` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new name[24];
						new kills;
						new string[300];
	       				string = ""P"№ Имя\t"P"Убийств\n\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "Name", name, MAX_PLAYER_NAME);
							cache_get_value_name_int(i, "pKills",kills);
							format(str, sizeof(str), f_str, i+1, name,kills);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, "ТОП игроки", string, "Закрыть", "");
					}
					else ErrorMessage(playerid,"Список еще не составлен");
					cache_delete(result);
				}
			}
		}
		case D_COMP_GAME_3: {
	    	if(!response) return 1;
	    	if(TI[playerid][tBlockWars]) return ErrorMessage(playerid,"Вы записаны на игру Capture Blocks");
	    	switch(listitem) {
	    	    case 0: {
					TI[playerid][tGunArea][0] = 1;
					TI[playerid][tGunArea][1] = 0;
					TI[playerid][tGunArea][2] = 0;
					TI[playerid][tGunArea][3] = 1;
					new Float:pos[3];
					GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
					SetPVarFloat(playerid, "pos_comp_x", pos[0]);
					SetPVarFloat(playerid, "pos_comp_y", pos[1]);
					SetPVarFloat(playerid, "pos_comp_z", pos[2]);
					SetPVarInt(playerid, "comp_int", GetPlayerInterior(playerid));
					SetPVarInt(playerid, "comp_vw", GetPlayerVirtualWorld(playerid));
					DelGun(playerid);
					new string[100];
     				format(string, sizeof(string), "Присоединился новый игрок - "ORANGE"%s",player_name[playerid]);
					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!TI[i][tGunArea][0]) continue;
						SendClientMessage(i,-1,string);
					}
					SendOk(playerid,"Для выхода из Гонки Вооружений,используйте: "W"/exitdm");
					DelGun(playerid);
					AC_GivePlayerWeapon(playerid, ArenaGun[5], 3000);
	    	    	new rand = random(sizeof(DMPositions));
					SetPlayerPosAC(playerid, DMPositions[rand][0], DMPositions[rand][1], DMPositions[rand][2],141,141);
					SetPlayerHealth(playerid, 100.0);
					SetPlayerColor(playerid,0x56FB4EFF);
					format(string,sizeof(string),"{1bd12f}Kills Gun:{ffffff}%d/3\n{1bd12f}Guns:{ffffff}%d/6",TI[playerid][tGunArea][1],TI[playerid][tGunArea][3]);
					DestroyDynamic3DTextLabel(DMSTATUS[playerid]);
					DMSTATUS[playerid] = CreateDynamic3DTextLabel(string, 0xFF6347FF, 0,0,0.4,10.0,playerid,INVALID_VEHICLE_ID,1,-1,-1,-1,10);
				}
				case 1: {
				    static const f_str[] = "\t{FFFF00}    - Гонка Вооружений -"W"\n\n\
						Суть данной игры {FFFF00}'Гонка Вооружений'"W" такова:\n\
						Пройти всю лесенку смены оружия.\n\
						Всего оружий {FFFF00}6"W".\n\
						Для смены оружия требуется убийств {FFFF00}3"W".\n\
						Оружие №1 {FFFF00}M4"W".\n\
						Оружие №2 {FFFF00}AK-47"W".\n\
						Оружие №3 {FFFF00}MP5"W".\n\
						Оружие №4 {FFFF00}Shotgun"W".\n\
						Оружие №5 {FFFF00}Deagle"W".\n\
						Оружие №6 {FFFF00}USP"W".\n\n\
						Приз - {FFFF00}ВСЕОБЩЕЕ УВАЖЕНИЕ";
					new string[sizeof(f_str)];
					format(string,sizeof(string),f_str);
					D(playerid,DIALOG_NONE,DSM, ""P"Гонка Вооружений",string, "Закрыть", "");
				}
    			case 2: {
					new rows;
					new Cache:result = mysql_query(connects, "SELECT `Name`,`pWinArea` FROM `accounts` ORDER BY `pWinArea` DESC LIMIT 5");
					cache_get_row_count(rows);
					if(rows) {
						new name[24];
						new kills;
						new string[300];
	       				string = ""P"№ Имя\t"P"Побед\n\n";
						static const f_str[] = ""YELLOW"%i. "W"%s\t"GREEN"%d\n";
	        			new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 7)];
						for(new i; i < rows; i ++) {
							cache_get_value_name(i, "Name", name, MAX_PLAYER_NAME);
							cache_get_value_name_int(i, "pWinArea",kills);
							format(str, sizeof(str), f_str, i+1, name,kills);
	            			strcat(string, str);
						}
						D(playerid, DIALOG_NONE, DSTH, "ТОП игроки", string, "Закрыть", "");
					}
					else ErrorMessage(playerid,"Список еще не составлен");
					cache_delete(result);
				}
			}
		}
		case D_DISEASE: {
			if(!response) return true;
			new i = GetPVarInt(playerid,"gheal");
			new string[156];

			new price_1,price_2;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller_1 = floatround(1500/100*vip_status[PI[playerid][pVips]][vip_disease]);
				new seller_2 = floatround(2500/100*vip_status[PI[playerid][pVips]][vip_disease]);
				price_1 = (1500-seller_1);
				price_2 = (2500-seller_2);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller_1 = floatround(1500/100*BonusInfo[act_disease]);
					new seller_2 = floatround(2500/100*BonusInfo[act_disease]);
					price_1 = (1500-seller_1);
					price_2 = (2500-seller_2);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller_1 = floatround(1500/100*BonusInfo[act_disease]);
					new seller_2 = floatround(2500/100*BonusInfo[act_disease]);
					price_1 = (1500-seller_1);
					price_2 = (2500-seller_2);
				}
			    else {
			    	price_1 = 1500;
			    	price_1 = 2500;
			    }
			}

			switch(take_items[playerid][listitem]) {
				case 0: {
					if(GetPlayerMoneyEx(i) < price_1) return ErrorMessage(playerid,"У игрока недостаточно средств");
					format(string, sizeof(string), "Вы предложили "P"%s"G" лечение болезни грипп",player_name[i]);
					SendUse(playerid,string);

					static const f_str[] = "\n"W"Доктор: "P"%s"W" предлагает вылечить Вас от болезни грипп.\n\
										Стоимость процедур: "GREEN"$%d.\n\n"YELLOW"\tВы согласны пройти курс лечения?";
					new str[sizeof(f_str) +1 + (-2 + 25) + (-2 + 6)];
					format(str, sizeof(str), f_str,player_name[playerid],price_1);
					D(i,D_DISEASE_2,DSM, ""P"Лечение",str,"Да", "Нет");
				}
				case 1: {
					if(GetPlayerMoneyEx(i) < price_2) return ErrorMessage(playerid,"У игрока недостаточно средств");
					format(string, sizeof(string), "Вы предложили "P"%s"G" лечение болезни анорексия",player_name[i]);
					SendUse(playerid,string);

					static const f_str[] = "\n"W"Доктор: "P"%s"W" предлагает вылечить Вас от болезни анорексия.\n\
										Стоимость процедур: "GREEN"$%d.\n\n"YELLOW"\tВы согласны пройти курс лечения?";
					new str[sizeof(f_str) +1 + (-2 + 25) + (-2 + 6)];
					format(str, sizeof(str), f_str,player_name[playerid],price_2);
					D(i,D_DISEASE_2,DSM, ""P"Лечение",str,"Да", "Нет");
				}
			}
			SetPVarInt(i,"gheal2",take_items[playerid][listitem]);
			SetPVarInt(i,"gheal2p",playerid);
		}
		case D_DISEASE_2: {
			new id = GetPVarInt(playerid,"gheal2p");
			new switem = GetPVarInt(playerid,"gheal2");
			DeletePVar(playerid,"gheal2p");
			DeletePVar(playerid,"gheal2");
			if(!response) {
				SendOk(playerid,"Вы отказались от лечения");
				SendOk(id,"Игрок отказался от лечения");
			}
			else {
				new price_1,price_2;
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller_1 = floatround(1500/100*BonusInfo[act_disease]);
					new seller_2 = floatround(2500/100*BonusInfo[act_disease]);
					price_1 = (1500-seller_1);
					price_2 = (2500-seller_2);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller_1 = floatround(1500/100*BonusInfo[act_disease]);
					new seller_2 = floatround(2500/100*BonusInfo[act_disease]);
					price_1 = (1500-seller_1);
					price_2 = (2500-seller_2);
				}
			    else {
			    	price_1 = 1500;
			    	price_1 = 2500;
			    }

				new string[144];
				switch(switem) {
					case 0: {
						SendOk(playerid,"Вы прошли курс лечения от болезни "W"грипп");
						format(string, sizeof(string),"Игрок "P"%s "G"прошел курс лечения от болезни "W"грипп"G" за "ORANGE"%d", player_name[playerid],price_1);
						SendUse(id,string);
						GiveMoney(playerid,-price_1,"лечение от гриппа");
						GiveMoney(id,225,"лечение от гриппа");
						FI[fWHITEHOUSE][fBank] += 1275;
						UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
						PI[playerid][pDisease][0] = 0;
						UpdatePlayerData(playerid,"pDisease_0",0);
					}
					case 1: {
						SendOk(playerid,"Вы прошли курс лечения от болезни "W"анорексия");
						format(string, sizeof(string),"Игрок "P"%s "G"прошел курс лечения от болезни "W"анорексия"G" за "ORANGE"%d", player_name[playerid],price_2);
						SendUse(id,string);
						GiveMoney(playerid,-price_2,"лечение от анорексии");
						GiveMoney(id,375,"лечение от гриппа");
						FI[fWHITEHOUSE][fBank] += 2125;
						UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
						PI[playerid][pDisease][1] = 0;
						UpdatePlayerData(playerid,"pDisease_1",0);
						SetFullness(playerid, 100);
					}
				}
			}
		}
	case D_QUEST: {
			if(!response) return 1;
			new id = QuestShow[playerid][listitem],string[512];
			if(QuestProgress[playerid][id] == 100) return SendBotMessage(playerid,"Дружище, ты уже выполнил данное задание");
			if(id >= 2 && id <= 11)
			{
				if(QuestProgress[playerid][id-1] != 100) return SendBotMessage(playerid,"Для начала выполни предыдущее задание");
			}
			if(QuestProgress[playerid][id] != 1 && ((id == 2 && PI[playerid][pPhone] != 0) || (id == 4 && PI[playerid][pMedCard] > 0) || (id == 10 && lic[playerid][0] > 0)))
			{
				switch(id)
				{
					case 2: SendBotMessage(playerid, "У вас уже есть мобильный телефон, Вы можете завершить задание"); 
					case 4: SendBotMessage(playerid, "У вас уже есть медицинская карта, Вы можете завершить задание"); 
					case 10: SendBotMessage(playerid, "У вас уже есть водительские права, Вы можете завершить задание"); 
				}
				new query[150];
				format(query, sizeof(query), "INSERT IGNORE INTO `questsprogress` (`idquest`, `name`, `progress`, `accept`) VALUES ('%d', '%s', '%d', '%d')", id, player_name[playerid], 1, 1);
				mysql_tquery(connects, query, "SaveQuests", "dd", playerid, id);
				AcceptQuest[playerid][id] = 1;
				QuestProgress[playerid][id] = 1;
				NextStapQI(playerid,id);

				return 1;
			}
			if(AcceptQuest[playerid][id] == 0) {
				format(string,sizeof(string),"%s\n\n"YELLOW"Вы действительно хотите начать данный квест?",QI[id][QuestText]);
				D(playerid,D_QUEST_1,DSM, ""P"Квест",string,"Начать","Отмена");
				QuestClick[playerid] = id;
			}
			else {
				if(QuestProgress[playerid][id] == QI[id][LastProgress]) {
					switch(id) {
						case 1: {
							SendBotMessage(playerid,"А ты хорош, но это только первое задание, получай награду!");
							GiveMoney(playerid,3000,"квест грузчики");
							PI[playerid][pExp] += 3;
						}
						case 2: {
							SendBotMessage(playerid,"Теперь я смогу следить за твоим успехом, держи награду");
							GiveMoney(playerid,4000,"квест мобила");
							PI[playerid][pExp] += 1;
						}
						case 3: {
							SendBotMessage(playerid,"Неплохо, держи награду!");
							GiveMoney(playerid,1500,"квест оружейка");
							PI[playerid][pExp] += 2;
						}
						case 4: {
							SendBotMessage(playerid,"Отлично! Теперь наш начальник не будет против взять тебя");
							GiveMoney(playerid,1000,"квест мед карта");
							PI[playerid][pExp] += 1;
						}
						case 5: {
							SendBotMessage(playerid,"Ух ты, и с этим справился, ты первый такой!");
							GiveMoney(playerid,1500,"квест яблочный сад");
							PI[playerid][pExp] += 2;
						}
						case 6: {
							SendBotMessage(playerid,"Вижу теперь ты полон сил, держи награду!");
							GiveMoney(playerid,1000,"квест перекус");
							PI[playerid][pExp] += 1;
						}
						case 7: {
							SendBotMessage(playerid,"Отлично! Видимо зря я тебя недооценил, ты ещё пригодишься!");
							GiveMoney(playerid,1500,"квест нефтезавод");
							PI[playerid][pExp] += 2;
						}
						case 8: {
							SendBotMessage(playerid,"А ты молодец! Быстрота выполнения задания меня шокирует! Держи награду!");
							GiveMoney(playerid,1500,"квест лесопилка");
							PI[playerid][pExp] += 2;
						}
						case 9: {
							SendBotMessage(playerid,"Поздравляю, теперь хоть выглядишь не как бомж!");
							GiveMoney(playerid,3000,"квест скин");
							PI[playerid][pExp] += 1;
						}
						case 10: {
							SendBotMessage(playerid,"Молодчина! Осталось последнее задание для тебя!");
							GiveMoney(playerid,2000,"квест права");
							PI[playerid][pExp] += 2;
						}
						case 11: {
							SendBotMessage(playerid,"Было приятно иметь дело с тобой! Желаю успехов и карьерного ростав в нашем штате!");
							GiveMoney(playerid,3000,"квест скиллы");
							PI[playerid][pExp] += 2;
						}

					}
					if(PI[playerid][pExp] >= (PI[playerid][pLevel])*6) {
						PI[playerid][pLevel] += 1;
						PI[playerid][pExp] = 0;
						DollahScoreUpdate(playerid);
						SendClientMessage(playerid, CGOLD, "Ваш игровой уровень был повышен");
						if(PI[playerid][pVips] != VIP_NONE && PI[playerid][pVips] != VIP_SILVER) {
							GiveMoney(playerid,vip_status[PI[playerid][pVips]][vip_lvl],"VIP lvl UP");
						}
					}
					if(PI[playerid][pFamily]) reputation_family(PI[playerid][pFamily]-1,1);
					QuestProgress[playerid][id] = 100;
					new query[256];
					format(query, sizeof(query), "UPDATE `questsprogress` SET `progress`='%d' WHERE `idquest`='%d' AND `name`='%s';", QuestProgress[playerid][id], id, player_name[playerid]);
					mysql_tquery(connects, query);
				}
			}
			return 1;
		}
		case D_QUEST_GANG: {
			if(!response) return 1;
			new id = QuestShow[playerid][listitem],string[512];
			if(QuestProgress[playerid][id] == 100) return SendBotMessage(playerid,"Дружище, ты уже выполнил данное задание");
			switch(id) {
				case 13..16: {
					if(QuestProgress[playerid][id-1] != 100) return SendBotMessage(playerid,"Для начала выполни предыдущее задание");
				}
			}
			if(AcceptQuest[playerid][id] == 0) {
				format(string,sizeof(string),"%s\n\n"YELLOW"Вы действительно хотите начать данный квест?",QI[id][QuestText]);
				D(playerid,D_QUEST_1,DSM, ""P"Квест",string,"Начать","Отмена");
				QuestClick[playerid] = id;
			}
			else {
				if(QuestProgress[playerid][id] == QI[id][LastProgress]) {
					switch(id) {
						case 12: {
							SendBotMessage(playerid,"Красавчик. Получи бабосики");
							GiveMoney(playerid,5000,"квест вор");
						}
						case 13: {
							SendBotMessage(playerid,"Отлично! Из тебя получился хороший грабитель!");
							GiveMoney(playerid,7000,"квест грабитель");
						}
						case 14: {
							SendBotMessage(playerid,"Ты не перестаешь меня удивлять! Я надеюсь ты еще и на продаже заработал!");
							GiveMoney(playerid,7000,"квест продавец");
						}
						case 15: {
							SendBotMessage(playerid,"А ты меткий стрелок! Быстро справился! У меня для тебя награда!");
							GiveMoney(playerid,10000,"квест тащер");
						}
						case 16: {
							SendBotMessage(playerid,"Поздравляю! Ты прошёл все задания у меня! Удачи!");
							GiveMoney(playerid,20000,"квест Провокатор");
						}
					}
					if(PI[playerid][pFamily]) reputation_family(PI[playerid][pFamily]-1,1);
					QuestProgress[playerid][id] = 100;
					new query[256];
					format(query, sizeof(query), "UPDATE `questsprogress` SET `progress`='%d' WHERE `idquest`='%d' AND `name`='%s';", QuestProgress[playerid][id], id, player_name[playerid]);
					mysql_tquery(connects, query);
				}
			}
			return 1;
		}
		case D_QUEST_1: {
			if(!response) return 1;
			new id = QuestClick[playerid];
			if(QuestProgress[playerid][id]==100) return ErrorMessage(playerid,"Вы уже выполняли у меня это задание!");//Вы уже его выполнили
			if(QuestProgress[playerid][id]>=0 && AcceptQuest[playerid][id]!=0) return ErrorMessage(playerid,"Вы уже приняли это задание!"); //Вы уже его приняли
			if(AcceptQuest[playerid][id]==0) {
				new query[150];
				format(query, sizeof(query), "INSERT IGNORE INTO `questsprogress` (`idquest`, `name`, `progress`, `accept`) VALUES ('%d', '%s', '%d', '%d')", id, player_name[playerid], 0, 1);
				mysql_tquery(connects, query, "SaveQuests", "dd", playerid, id);
				AcceptQuest[playerid][id] = 1;
				QuestProgress[playerid][id] = 0;
				SendBotMessage(playerid,"Желаю удачи! Для просмотра заданий введи: /quest");
				NextStapQI(playerid,id);
			}
			return 1;
		}
		case D_QUEST_2: {
		    if(!response) return 1;
			new id = QuestShow[playerid][listitem];
			if(QuestProgress[playerid][id]==100) return ErrorMessage(playerid,"Выбранный квест уже выполнен");
			new string[512];
			if(QuestProgress[playerid][id] < QI[id][LastProgress]) format(string,sizeof(string),""G"Прогресс: "ORANGE"%d/%d"W"",QuestProgress[playerid][id],QI[id][LastProgress]);
			else format(string,sizeof(string),""G"Прогресс: "NO"Можно завершить"W"");
			format(string,sizeof(string),"%s\n\n%s",QI[id][QuestText],string);
			D(playerid,D_QUEST_3,DSM,QI[id][QuestName],string,"Начать","Закрыть");
			QuestClick[playerid] = id;
		}
		case D_QUEST_3: {
		    if(!response) return 1;
			NextStapQI(playerid,QuestClick[playerid]);
		}
		case D_RIELTOR: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					drieltorka[playerid] = 0;
					new string[1512],houseidd = 0,classname[11];
					for(new i = 0; i < gHouseCount; i ++) {
						if(gHouses[i][houseOwnerID] != 0) continue;
						switch(gHouses[i][houseClass]) {
							case 0:classname = "Эконом";
							case 1:classname = "Cредний";
							case 2:classname = "Элитный";
							case 3:classname = "Особняк";
							default: classname = "Неизвестно";
						}
						format(string, sizeof(string), "%sДом "ORANGE"№%d "W"[%s]\n",string,i+1,classname);
						houseidd++;
						if(houseidd == 30) {
							format(string, sizeof(string), "%s{1965D9}Далее >>>\n", string);
							break;
						}
					}
					if(!houseidd) return ErrorMessage(playerid,"Свободных домов нет");
					D(playerid, D_RIELTOR_HOUSE, DSL, ""P"Выберите дом", string, "Выбрать", "Назад");
					return 1;
				}
				case 1: {
					drieltorka[playerid] = 0;
					new string[1512],bizzid = 0;
					for(new i = 0; i < gBusinessCount; i ++) {
						if(gBusiness[i][bizzOwnerID] != 0) continue;
						format(string, sizeof(string), "%sБизнес "ORANGE"№%d "W"[%s] [%s]\n",string,i+1,gBusiness[i][bizzName],gBusinessTypeName[gBusiness[i][bizzType]-1]);
						bizzid++;
						if(bizzid == 20) {
							format(string, sizeof(string), "%s{1965D9}Далее >>>\n", string);
							break;
						}
					}
					if(!bizzid) return ErrorMessage(playerid,"Свободных бизнесов нет");
					D(playerid, D_RIELTOR_BIZZ, DSL, ""P"Выберите бизнес", string, "Выбрать", "Назад");
					return 1;
				}
			}
		}
		case D_RIELTOR_HOUSE: {
			if(!response) return 1;
			if(listitem == 30 || listitem == 31) CheckHouses(playerid,listitem);
			else {
				new bizz = TI[playerid][tSelectedBusinessID];
				if(bizz < 0) return ErrorMessage(playerid, "Вы выбрали некорретный дом");
				new price = gBusiness[bizz][bizzPrice]*150;
				new houseid = strval(inputtext[4])-1;
				SetPVarInt(playerid,"hrieltor",houseid+1);
				if(GetString(inputtext, "<<< Назад")) return CheckHouses(playerid,31);
				new classname[20];
				switch(gHouses[houseid][houseClass]) {
					case 0:classname = "Эконом";
					case 1:classname = "Cредний";
					case 2:classname = "Элитный";
					case 3:classname = "Особняк";
					default: classname = "Неизвестно";
				}
				static const f_str[] = ""W"Дом № \t\t"P"%d\n\
					"W"Класс: \t\t\t"P"%s\n\
					"W"Гос.Цена: \t\t"GREEN"$%d\n\n\
					"W"Стоимость осмотра дома - "GREEN"$%d";
				new string[sizeof(f_str) +1 + (-2 + 10) + (-2 + 20) + (-2 + 7)];

				format(string,sizeof(string),f_str,houseid+1, classname, gHouses[houseid][housePrice],price);
				D(playerid,D_RIELTOR_HOUSE_2,DSM, ""P"Риэлторское агенство",string,"Осмотреть","Отмена");
			}
		}
		case D_RIELTOR_HOUSE_2: {
			if(!response) return DeletePVar(playerid,"hrieltor");
			new bizz = TI[playerid][tSelectedBusinessID];
			if(bizz < 0) return ErrorMessage(playerid, "Вы выбрали некорретный дом");
			new price = gBusiness[bizz][bizzPrice]*150;
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"Недостаточно средств");
			bizz_pay(bizz,price);
			GiveMoney(playerid,-price,"осмотр риэлторка");
			new houseid = GetPVarInt(playerid,"hrieltor")-1,Float:pos[3];

			GetPlayerPos(playerid,pos[0],pos[1],pos[2]);

			SetPVarFloat(playerid,"rielX",pos[0]);
			SetPVarFloat(playerid,"rielY",pos[1]);
			SetPVarFloat(playerid,"rielZ",pos[2]);
			SetPVarInt(playerid,"rielVW",GetPlayerVirtualWorld(playerid));

			SetPlayerPosAC(playerid,gHouses[houseid][houseX],gHouses[houseid][houseY],gHouses[houseid][houseZ]-50.0,0,0);
			TogglePlayerControllable(playerid,0);

			SetPlayerCameraPos(playerid,gHouses[houseid][houseX] + (-8.0 * floatsin(gHouses[houseid][houseR], degrees)),gHouses[houseid][houseY] + (5.0 * floatcos(gHouses[houseid][houseR], degrees)), gHouses[houseid][houseZ]+0.3);
			SetPlayerCameraLookAt(playerid, gHouses[houseid][houseX], gHouses[houseid][houseY], gHouses[houseid][houseZ]);

			SendOk(playerid,"Для выхода нажмите: "ORANGE"ALT");
			SendOk(playerid,"Отметить местоположение дома на Вашей карте: "ORANGE"/label");
		}
		case D_RIELTOR_BIZZ: {
			if(!response) return 1;
			if(listitem == 20 || listitem == 21) CheckBusiness(playerid,listitem);
			else {
				new bizz = TI[playerid][tSelectedBusinessID];
				if(bizz < 0) return 1;
				new price = gBusiness[bizz][bizzPrice]*150;
				new bizzid = strval(inputtext[4])-1;
				SetPVarInt(playerid,"bizzrielor",bizzid+1);
				if(GetString(inputtext, "<<< Назад")) return CheckBusiness(playerid,21);
				static const f_str[] = ""W"Бизнес № \t\t"P"%d [%s]\n\
					"W"Тип: \t\t\t"P"%s\n\
					"W"Гос.Цена: \t\t"GREEN"$%d\n\n\
					"W"Стоимость осмотра бизнеса - "GREEN"$%d";
				new string[sizeof(f_str) +1 + (-2 + 15) + (-2 + 20) + (-2 + 7)];

				format(string,sizeof(string),f_str,bizzid+1, gBusiness[bizzid][bizzName],gBusinessTypeName[gBusiness[bizzid][bizzType]-1], gBusiness[bizzid][bizzSellPrice],price);
				D(playerid,D_RIELTOR_BIZZ_2,DSM, ""P"Риэлторское агенство",string,"Осмотреть","Отмена");
			}
		}
		case D_RIELTOR_BIZZ_2: {
			if(!response) return DeletePVar(playerid,"bizzrielor");
			new bizz = TI[playerid][tSelectedBusinessID];
			if(bizz < 0) return 1;
			new price = gBusiness[bizz][bizzPrice]*150;
			if(GetPlayerMoneyEx(playerid) < price) return ErrorMessage(playerid,"Недостаточно средств");
			bizz_pay(bizz,price);
			GiveMoney(playerid,-price,"осмотр риэлторка");
			new bizzid = GetPVarInt(playerid,"bizzrielor")-1,Float:pos[3];

			GetPlayerPos(playerid,pos[0],pos[1],pos[2]);

			SetPVarFloat(playerid,"rielX",pos[0]);
			SetPVarFloat(playerid,"rielY",pos[1]);
			SetPVarFloat(playerid,"rielZ",pos[2]);
			SetPVarInt(playerid,"rielVW",GetPlayerVirtualWorld(playerid));

			SetPlayerPosAC(playerid,gBusiness[bizzid][bizzX],gBusiness[bizzid][bizzY],gBusiness[bizzid][bizzZ]-50.0,0,0);
			TogglePlayerControllable(playerid,0);

			SetPlayerCameraPos(playerid,gBusiness[bizzid][bizzX] + (-8.0 * floatsin(gBusiness[bizzid][bizzR], degrees)),gBusiness[bizzid][bizzY] + (5.0 * floatcos(gBusiness[bizzid][bizzR], degrees)), gBusiness[bizzid][bizzZ]+0.3);
			SetPlayerCameraLookAt(playerid, gBusiness[bizzid][bizzX], gBusiness[bizzid][bizzY], gBusiness[bizzid][bizzZ]);

			SendOk(playerid,"Для выхода нажмите: "ORANGE"F");
			SendOk(playerid,"Отметить местоположение бизнеса на Вашей карте: "ORANGE"/label");
		}
		case D_VEH_NUMBER: {
			if(!response) return 1;
			if(!IsACarNumber(gPlayerCars[playerid][carModel][listitem])) return ErrorMessage(playerid, "На данное Т/С нельзя установить гос.номер");
			if(!GetString(NumberVehicle[playerid][listitem],"TRANSIT")) return ErrorMessage(playerid,"У Вас уже получен гос.номер на данное Т/С");
			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(1000/100*vip_status[PI[playerid][pVips]][vip_number]);
				if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
				price = (1000-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(1000/100*BonusInfo[act_buynubmbercar]);
					if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					price = (1000-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(1000/100*BonusInfo[act_buynubmbercar]);
					if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					price = (1000-seller);
				}
			    else price = 1000;
			}

			new string[156];
			format(string,sizeof(string),"\n\n"W"Вы действительно хотите установить гос.номер на Т/С "P"%s"W" стоимостью - "ORANGE"%d"W"?\n\n",gTransport[gPlayerCars[playerid][carModel][listitem]-400][trName],price);
			D(playerid,D_VEH_NUMBER_2,DSM, ""P"Покупка гос.номера", string, "Купить", "Назад");
			SetPVarInt(playerid,"buy_carnumber",listitem);
		}
		case D_VEH_NUMBER_2: {
			if(!response) return DeletePVar(playerid,"buy_carnumber");
			if(!IsACarNumber(gPlayerCars[playerid][carModel][GetPVarInt(playerid,"buy_carnumber")])) return ErrorMessage(playerid, "На данное Т/С нельзя установить гос.номер");
			if(!GetString(NumberVehicle[playerid][GetPVarInt(playerid,"buy_carnumber")],"TRANSIT")) return ErrorMessage(playerid,"У Вас уже получен гос.номер на данное Т/С");

			new price;
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(1000/100*vip_status[PI[playerid][pVips]][vip_number]);
				if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
				price = (1000-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(1000/100*BonusInfo[act_buynubmbercar]);
					if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					price = (1000-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(1000/100*BonusInfo[act_buynubmbercar]);
					if(GetPlayerMoneyEx(playerid) < (1000-seller)) return ErrorMessage(playerid,"У Вас недостаточно средств");
					price = (1000-seller);
				}
			    else price = 1000;
			}

			GiveMoney(playerid,-price,"покупка гос.номера");
			new numbers[64],a1[32],a2[32],a3[32];
			a1 = ABC[random(20)];
			a2 = ABC[random(20)];
			a3 = ABC[random(20)];
			format(numbers,10, "%c %i %c%c", a1, 100 + random(900), a2, a3) ;
			format(NumberVehicle[playerid][GetPVarInt(playerid,"buy_carnumber")],MAX_PLAYER_NAME,"%s",numbers);
			new string[128];
			format(string,sizeof(string),"Поздравляем, с получением гос. номера: "W"%s",numbers);
			SendClientMessage(playerid,CGOLD,string);
			save_car(playerid,GetPVarInt(playerid,"buy_carnumber"));
			DeletePVar(playerid,"buy_carnumber");
		}
		case D_WORK: {
			if(!response) return 1;
			if(!PI[playerid][pMember]) return ErrorMessage(playerid,"Вы не состоите в организации");
			if(!start_work[playerid]) {
				A_SetPlayerSkin(playerid,PI[playerid][pFracSkin]);
				SendOk(playerid,"Рабочий день начат");
				TI[playerid][tMasked] = 0;
				SetPlayerColor(playerid,gFractionSpawn[PI[playerid][pMember]][fracColor]);
				start_work[playerid] = 1;
				PI[playerid][pJob] = 0;
				return 1;
			}
			if(IsAArm(playerid)) if(PI[playerid][pRank] < 3) return ErrorMessage(playerid, "Доступно с 3 ранга");
			DelGun(playerid);
			SendOk(playerid, "Рабочий день окончен");
			SetPlayerColor(playerid, TEAM_HIT_COLOR);
			start_work[playerid] = 0;
			A_SetPlayerSkin(playerid,PI[playerid][pSkin]);
			SetPlayerArmour(playerid, 0);
		}
		case D_RADIO: {
			if(!response) return 1;
			switch(listitem) {
				case 0: PlayAudioStreamForPlayer(playerid, "http://online-radiomelodia.tavrmedia.ua/RadioMelodia.m3u"),SendOk(playerid, "Онлайн радио включено"); // KISS FM (UA)
				case 1: PlayAudioStreamForPlayer(playerid, "http://air2.radiorecord.ru:805/rr_320"),SendOk(playerid, "Онлайн радио включено"); // RADIO RECORD
				case 2: PlayAudioStreamForPlayer(playerid, "http://nashe.streamr.ru/rock-128.mp3?728a"), SendOk(playerid, "Онлайн радио включено"); // SKY RADIO
				case 3: PlayAudioStreamForPlayer(playerid, "http://emgregion.hostingradio.ru:8064/moscow.retrofm.mp3?3ec7"), SendOk(playerid, "Онлайн радио включено"); // RETRO FM
				case 4: PlayAudioStreamForPlayer(playerid, "http://emgregion.hostingradio.ru:8064/moscow.europaplus.mp3?dc6ac484"), SendOk(playerid, "Онлайн радио включено"); // europaplus
				case 5: PlayAudioStreamForPlayer(playerid, "https://rusradio.hostingradio.ru/rusradio96.aacp?1164"), SendOk(playerid, "Онлайн радио включено"); // europaplus
				case 6: PlayAudioStreamForPlayer(playerid, "http://chanson.hostingradio.ru:8041/chanson256.mp3"), SendOk(playerid, "Онлайн радио включено"); // CHANSION
				case 7: StopAudioStreamForPlayer(playerid), SendOk(playerid,"Радио выключено");
			}
		}
		case D_BL: {
			if(!response ) return 1;
			switch(listitem) {
				case 0: {
					if(PI[playerid][pRank] < FI[PI[playerid][pMember]][fInviteRang]) {
						new string[128];
						format(string, sizeof(string), "Доступно с %d ранга", FI[PI[playerid][pMember]][fInviteRang]);
						ErrorMessage(playerid, string);
						return 1 ;
					}
					D(playerid,D_BL_ADD,DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n\n", "Далее", "Назад");
				}
				case 1: {
					if(PI[playerid][pRank] < FI[PI[playerid][pMember]][fInviteRang]) {
						new string[128];
						format(string, sizeof(string), "Доступно с %d ранга", FI[PI[playerid][pMember]][fInviteRang]);
						ErrorMessage(playerid, string);
						return 1 ;
					}
					D(playerid, D_BL_DELL, DSI, ""P"Удаление из ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите вычеркнуть из ЧС организации\n\n", "Принять", "Назад");
				}
				case 2: {
					new query[76];
					SetPVarInt(playerid, "bl_page", 1);

					format(query, sizeof(query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
					mysql_pquery(connects, query, "bl_callback", "i", playerid );
				}
				case 3: {
					string_1024[0] = EOS;
					string_1024 = "Имя\t\t\t\tПричина\n\n"W"";
					new COUNT_MEMBERS = 0 ;

					foreach(new i:Player) {
						if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
						if(!bl_info[i][bl_fraction][PI[playerid][pMember]]) continue;

						format(string_1024, sizeof(string_1024), "%s%s(%i)\t\t\t%s\n", string_1024, player_name[i], i, bl_info[i][bl_reason][PI[playerid][pMember]]);
						COUNT_MEMBERS ++ ;
					}
					if(COUNT_MEMBERS == 0) return ErrorMessage(playerid, "Чёрный список пуст");
					D(playerid, DIALOG_NONE, DSM, ""P"Черный список онлайн", string_1024, "Закрыть", "");
				}
			}
			return 1 ;
		}
		case D_BL_ADD: {
			if(!response ) return callcmd::bl(playerid);
			if(!strlen(inputtext) || strlen(inputtext)>23) return D(playerid, D_BL_ADD, DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n"NO"*"G" От 10 до 24 символов\n\n", "Далее", "Назад");
			strmid(bl_name,inputtext,0,strlen(inputtext), MAX_PLAYER_NAME);
			if(!IsBannedNameReg(bl_name)) return D(playerid, D_BL_ADD, DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n"NO"*"G" Данный игрок не зарегистрирован на сервере\n\n", "Далее", "Назад");
			if(IsBLName(bl_name,PI[playerid][pMember])) return D(playerid, D_BL_ADD, DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n"NO"*"G" Данный игрок уже в ЧС\n\n", "Далее", "Назад");
			if(IsBLNameMember(bl_name,PI[playerid][pMember])) return D(playerid, D_BL_ADD, DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n"NO"*"G" Данный игрок состоит в Вашей организации\n\n", "Далее", "Назад");
			D(playerid, D_BL_ADD_REASON, DSI, ""P"Причина внесения", "\n\n"W"Введите причину, по которой Вы хотите внести игрока в ЧС организации\n\n", "Принять", "Назад");
		}
		case D_BL_ADD_REASON: {
			if(!response) return D(playerid, D_BL_ADD, DSI, ""P"Добавление в ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите внести в ЧС организации\n\n", "Далее", "Назад");
			if(strlen(inputtext) < 2 || strlen(inputtext) > 32) return D(playerid, D_BL_ADD_REASON, DSI, ""P"Причина внесения", "\n\n"W"Введите причину, по которой Вы хотите внести игрока в ЧС организации\n"NO"*"G" Причина должна быть от 2 до 32 символов\n\n", "Принять", "Назад");
			new pl_id = GetCheckID(bl_name);

			new query[356];
			mysql_format(connects,query, sizeof(query), "INSERT INTO `fraction_bl` (`f_bl_id`, `f_bl_accused`, `f_bl_accuser`, `f_bl_date`, `f_bl_reason`) VALUES ('%i','%e','%e',NOW(),'%e')",
			PI[playerid][pMember], bl_name, player_name[playerid], inputtext);
			mysql_pquery(connects, query, "", "");

			new string[128];
			if(pl_id != INVALID_PLAYER_ID) {
				bl_info[pl_id][bl_fraction][PI[playerid][pMember]] = true;
				bl_info[pl_id][bl_reason][PI[playerid][pMember]] = strlen(inputtext);

				format(string, sizeof(string), "[ЧС] %s внёс Вас в чёрный список %s. Причина: %s", player_name[playerid], FI[PI[playerid][pMember]][fName], inputtext);
				SendClientMessage(pl_id, COLOR_LIGHTRED, string) ;
			}
			format(string, sizeof(string), "[ЧС] %s внёс %s в чёрный список %s. Причина: %s",  player_name[playerid], bl_name, FI[PI[playerid][pMember]][fName], inputtext);
			SendFamilyMessage(PI[playerid][pMember], COLOR_LIGHTRED, string);
		}
		case D_BL_DELL: {
			if(!response ) return callcmd::bl(playerid);
			if(!strlen(inputtext) || strlen(inputtext)>23) return D(playerid, D_BL_DELL, DSI, ""P"Удаление из ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите вычеркнуть из ЧС организации\n"NO"*"G" От 10 до 24 символов\n\n", "Далее", "Назад");
			strmid(bl_name,inputtext,0,strlen(inputtext), MAX_PLAYER_NAME);
			if(!IsBLName(bl_name,PI[playerid][pMember])) return D(playerid, D_BL_DELL, DSI, ""P"Удаление из ЧС", "\n\n"W"Введите Nick_Name игрока, которого хотите вычеркнуть из ЧС организации\n"NO"*"G" Данный игрок не в ЧС\n\n", "Далее", "Назад");

			//bl_info[pl_id][bl_fraction][PI[playerid][pMember]] = false;
			new query[74 + MAX_PLAYER_NAME + 6];
			mysql_format(connects,query, sizeof(query), "DELETE FROM `fraction_bl` WHERE BINARY `f_bl_accused` = '%e' AND `f_bl_id` = '%d'", bl_name, PI[playerid][pMember]);
			mysql_pquery(connects, query, "", "");

			new string[128];
			new pl_id = GetCheckID(bl_name);
			if(pl_id != INVALID_PLAYER_ID) {
				format(string, sizeof(string), "[ЧС] %s вычеркнул Вас из чёрного списка %s", player_name[playerid], FI[PI[playerid][pMember]][fName]);
				SendClientMessage(pl_id, COLOR_LIGHTRED, string);
				bl_info[pl_id][bl_fraction][PI[playerid][pMember]] = false;
			}
			format(string, sizeof(string), "[ЧС] %s вычеркнул %s из чёрного списка %s",  player_name[playerid], bl_name, FI[PI[playerid][pMember]][fName]);
			SendFamilyMessage(PI[playerid][pMember], COLOR_LIGHTRED, string);
		 }
		 case D_BL_ALL: {
			if(!response) {
				DeletePVar(playerid,"bl_page");
				DeletePVar(playerid,"bl_rows");
				return callcmd::bl(playerid);
			}
			if(listitem == 0) {
				new rows_list = GetPVarInt(playerid, "bl_page") - 1;
				new query[128];
				if(rows_list == 0) {
					format(query, sizeof (query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
					mysql_pquery(connects, query, "bl_callback", "i", playerid );
					ErrorMessage(playerid, "Вы на 1ой странице");
					return 1 ;
				}
				SetPVarInt(playerid, "bl_page", rows_list ) ;
				format(query, sizeof(query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
				mysql_pquery(connects, query, "bl_callback", "i", playerid);
			}
			else if(listitem == 1) {
				new rows_list = GetPVarInt ( playerid, "bl_page" ) - 1;
				new query[128];
				if((rows_list + 1 )*10 >= GetPVarInt(playerid, "bl_rows" )) {
					ErrorMessage(playerid, "Вы на последней странице");
					format(query, sizeof (query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
					mysql_pquery(connects, query, "bl_callback", "i", playerid);
					return 1 ;
				}
				SetPVarInt(playerid, "bl_page", rows_list + 2);
				format(query, sizeof (query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
				mysql_pquery(connects, query, "bl_callback", "i", playerid);
			}
			else {
				new query[128];
				format(query, sizeof (query), "SELECT * FROM `fraction_bl` WHERE `f_bl_id` = '%d'", PI[playerid][pMember]);
				mysql_pquery(connects, query, "bl_callback", "i", playerid);
			}
		}
		case D_REFERALS: {
		    if(response) FirstReferal[playerid] += 10;
		    else {
		        if(FirstReferal[playerid] >= 10) FirstReferal[playerid] -= 10;
		        else return true;
		    }
		    new rows,query[156];
		    format(query, sizeof(query), "SELECT `Name`,`pLevel` FROM `accounts` WHERE `pDrug` = '%s' ORDER BY `pLevel` DESC LIMIT %i, 10", player_name[playerid], FirstReferal[playerid]);
		    new Cache:result = mysql_query(connects, query);
      		cache_get_row_count(rows);
			if(rows) {
				string_1024[0] = EOS;
				new Name[MAX_PLAYER_NAME + 1], Level;
				for(new i; i < rows; i ++) {
					cache_get_value_name(i, "Name", Name, MAX_PLAYER_NAME);
					cache_get_value_name_int(i, "pLevel",Level);

					if(Level < 3) format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "NO"%d LEVEL\n", string_1024, i+FirstReferal[playerid]+1, Name, Level);
					else format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "GREEN"%d LEVEL\n", string_1024, i+FirstReferal[playerid]+1, Name, Level);
				}
				if(!D(playerid, D_REFERALS, 0, "Приглашенные", string_1024, "Далее", "Назад")) ErrorMessage(playerid, "Недоступно, попробуйте повторить заного");
			}
			else ErrorMessage(playerid,"Больше Вас никто не указывал как пригласившего на сервер");
      		cache_delete(result);
		}
		case D_FAMILY_OFFLINE: {
		    if(response) FirstFamily[playerid] += 20;
		    else {
		        if(FirstFamily[playerid] >= 20) FirstFamily[playerid] -= 20;
		        else return true;
		    }
			new query[64], rows;
		    format(query, sizeof(query), "SELECT * FROM `"TABLE_ACCOUNTS"` WHERE `family` = '%d' LIMIT %i, 20", PI[playerid][pFamily], FirstFamily[playerid]);
		    new Cache:result = mysql_query(connects, query);
      		cache_get_row_count(rows);
			if(rows > 0) {
				new names[MAX_PLAYER_NAME + 1],Level;
				string_1024[0] = EOS;
				for(new i; i < rows; i ++) {
					cache_get_value_name(i, "Name", names, MAX_PLAYER_NAME);
					cache_get_value_name_int(i, "pLevel",Level);
					if(IsPlayerConnected(GetPlayerID(names))) continue;
					if(Level < 3) format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "NO"%d LEVEL\n", string_1024, i+FirstFamily[playerid]+1, names, Level);
					else format(string_1024, sizeof(string_1024), "%s"ORANGE"%i."W" %s - "GREEN"%d LEVEL\n", string_1024, i+FirstFamily[playerid]+1, names, Level);
				}
				if(!D(playerid, D_FAMILY_OFFLINE, 0, "Семья offline", string_1024, "Далее", "Назад")) ErrorMessage(playerid, "Недоступно, попробуйте повторить заного");
			}
			else ErrorMessage(playerid, "Больше в Вашей семье никого нет");
			cache_delete(result);
		}
		case D_BIZZ_BO_BANK: {
			if(!response) return 1;
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			SetPVarInt(playerid,"atm_listitem",listitem+1);
			if(!ATMData[listitem+1][atm_Bank]) {
				new string[328];
				format(string, sizeof(string), "\n\n"W"Вы собираетесь арендовать банкомат "P"[%s]"W"\nСтоимость аренды: "ORANGE"$%d / 7 дней\n\n", ATMNames[listitem],15000);
				D(playerid,D_BIZZ_BO_BANK_2,DSM, ""P"Аренда банкомата",string,"Арендовать","Отмена");
			}
			else return ErrorMessage(playerid,"Выбранный банкомат арендован");
		}
		case D_BIZZ_BO_BANK_2: {
			if(!response) return DeletePVar(playerid,"atm_listitem");
			new bizz = PI[playerid][pBusiness]-1;
			if(!bizz) return 1;
			new id_slot = GetPVarInt(playerid,"atm_listitem");
			DeletePVar(playerid,"atm_listitem");
			if(ATMData[id_slot][atm_Bank]) return ErrorMessage(playerid,"Выбранный банкомат арендован");
			if(gBusiness[bizz][bizzBank] < 15000) return ErrorMessage(playerid,"В кассе банковского отделения недостаточно средств для аренды");
			gBusiness[bizz][bizzBank] -= 15000;
			UpdateBusinessData(bizz+1,"bank",gBusiness[bizz][bizzBank]);
			ATMData[id_slot][atm_Bank] = bizz;
			ATMData[id_slot][atm_BankTime] = (unix + 86400 * 7);
			UpdateAtmData(id_slot,"ATM_BANK",ATMData[id_slot][atm_Bank]);
			UpdateAtmData(id_slot,"ATM_BANKTIME",ATMData[id_slot][atm_BankTime]);
			SendOk(playerid,"Выбранный банкомат успешно арендован");
		}
		case D_BIZZ_BO: {
			if(!response) return 1;
			new bizz = PI[playerid][pBusiness];
			switch(listitem) {
				case 0: {
					new day;
					day = (gBusiness[bizz-1][bizzDay]-gettime())/86400;
					static const f_str[] = ""W"Название:\t\t"P"%s\n\
											"W"Владелец:\t\t"P"%s\n\
											"W"Количество дней:\t"P"%d\n\
											"W"Гос. цена\t\t"P"%d\n\
											"W"Касса:\t\t\t"P"$%d\n\
											"W"Оплата:\t\t"P"$%d/день\n\
											"W"Налогообложение:\t"P"%d%";
					new string[sizeof(f_str) +1 + (-2 + 20) + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + (-2 + 3) + (-2 + 8) + (-2 + 8) + (-2 + 8) + (-2 + 5) + (-2 + 5)];
					format(string,sizeof(string),f_str,FuncBizz[bizz][funcbName],gBusiness[bizz-1][bizzOwner],day,gBusiness[bizz-1][bizzSellPrice],gBusiness[bizz-1][bizzBank],floatround(gBusiness[bizz-1][bizzSellPrice]*bizz_rent/2),Nalog[3]);
					D(playerid,DIALOG_NONE,DSM, ""P"Банковское отделение",string,"Закрыть","");
				}
				case 1: {
					static const f_str[] = ""W"Состояние счета: "GREEN"$%d\n"P"1."W" Снять деньги\n"P"2."W" Положить деньги";
					new string[sizeof(f_str) +1 + (-2 + 10)];
					format(string,sizeof(string),f_str,gBusiness[PI[playerid][pBusiness] - 1][bizzBank]);
					D(playerid,D_BIZZ_BANK,DSL,""P"Управление кассой",string,"Далее","Назад");
				}
				case 2: {
					load_color(playerid);
					SetPVarInt(playerid,"color_allcolor",1);
				}
				case 3: {
					D(playerid,D_BIZZ_TAXI_NAME,DSI, ""P"Название банковского отделения","\n\n"W"Введите новое название банковского отделения:\n\n\
																Минимальное количество символов: "P"3\n\
																"W"Максимальное количество символов: "P"20","Изменить","Отмена");
				}
				case 4: {
					D(playerid,D_BIZZ_BO_PERCENT,DSL,""P"Комиссия за переводы",""P"1."W" 0.1%\n"P"2."W" 0.2%\n"P"3."W" 0.3%\n"P"4."W" 0.4%\n"P"5."W" 0.5%\n"P"6."W" 0.6%\n"P"7."W" 0.7%\n"P"8."W" 0.8%\n"P"9."W" 0.9%\n"P"10."W" 1.0%","Изменить","Отмена");
				}
				case 5: {
					D(playerid,D_BIZZ_BO_PERCENT_2,DSI, ""P"Комиссия за оплату недвижимости","\n\n"W"Введите процент комиссии взымаемый с человека во время опаты недвижимости\n\n\
																Доступный диапазон: от "P"1% "W"до "P"5%","Изменить","Отмена");
				}
				case 6: {
					D(playerid,D_BIZZ_BO_PERCENT_3,DSI, ""P"Комиссия за пользование банкоматом","\n\n"W"Введите процент комиссии взымаемый с человека во время пользования банкоматом\n\n\
																Доступный диапазон: от "P"1% "W"до "P"5%","Изменить","Отмена");
				}
				case 7: {
					new string[1512],str[128];
					strcat(string,"№\tБанкомат\tСтатус\tАренда\n");
					for(new i = 1; i < 16; i ++) {
						if(ATMData[i][atm_Bank] == 0) format(str, sizeof(str), ""GREEN"%d\t%s\tНе арендован\t---\n", i,ATMNames[i-1]),strcat(string,str);
						else {
							new year, month, day, hour, minute, second;
							timestamp_to_date(ATMData[i][atm_BankTime]-unix, year, month, day, hour, minute, second);
							format(str, sizeof(str), ""NO"%d\t%s\t{%s}%s\t"P"%dд %dч %dм\n", i,ATMNames[i-1],color_td[FuncBizz[ATMData[i][atm_Bank]+1][funcbColor]][col_rgb],FuncBizz[ATMData[i][atm_Bank]+1][funcbName],day-1, hour, minute),strcat(string,str);
						}
					}
					D(playerid, D_BIZZ_BO_BANK, DSTH, "Управление банкоматами", string, "Выбрать", "Отмена");
				}
				case 8: {
					new query[156];
					format(query, sizeof(query), "SELECT * FROM `business_stats` WHERE `bizz` = '%i'", PI[playerid][pBusiness]-1);
					mysql_tquery(connects, query, "bizz_stats", "ii", playerid,PI[playerid][pBusiness]-1);
				}
				case 9: {
					new string[230];
					format(string,sizeof(string),""W"Вы хотите продать банковское отделение государству за "GREEN"$%d?\n\n"G"Для продажи банковского отделения игроку введите: /sellbusiness [ID игрока] [Сумма]",floatround(gBusiness[bizz-1][bizzSellPrice]/100*80));
					D(playerid,D_BIZZ_SELL,DSM, ""P"Бизнесс",string,"Продать","Отмена");
				}
			}
		}
		case D_BIZZ_TK: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			dialog_tk(playerid,bizz,listitem);
		}
		case D_BIZZ_TK_ZAM: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			switch(listitem) {
				case 0: dialog_tk(playerid,bizz,0);
				case 1: dialog_tk(playerid,bizz,6);
				case 2: dialog_tk(playerid,bizz,7);
			}
		}
		case D_BIZZ_TK_MEM: {
			if(!response) return 1;
			GetWord(inputtext[3],0, select_member[playerid], strlen(inputtext[3])+2);
			new id = GetPlayerID(select_member[playerid]);
			new names[MAX_PLAYER_NAME + 1],status,query[128];
			mysql_format(connects,query, sizeof(query), "SELECT * FROM `accounts` WHERE BINARY `Name` = '%e' LIMIT 1", select_member[playerid]);
			new Cache:result = mysql_query(connects, query);
			new rows = cache_num_rows();
			if(rows > 0) {
				cache_get_value_name(0, "Name", names, MAX_PLAYER_NAME);
				cache_get_value_name_int(0, "bizz_status",status);
				if(PI[playerid][bizz_status] == 3 || PI[playerid][bizz_status] == 2) {
					if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
					if(status == 3) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
					if(PI[playerid][bizz_status] == 2) {
						if(status == 2) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
					}
					static const f_str[] = "\t%s\n\
											"P"1. "W"Изменить доступ:\n\
											\t%s- Водитель\n\
											\t%s- Управляющий\n\
											"P"2. "NO"Уволить";
					new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 40)];
					format(str,sizeof(str),f_str,names,(status == 1) ? (""P"") : (""W""),(status == 2) ? (""P"") : (""W""));
					D(playerid,D_BIZZ_TK_MEM_2,DSL,""P"Сотрудник",str,"Далее","Закрыть");
				}
			}
			else ErrorMessage(playerid, "Сотрудник не найден");
			cache_delete(result);
		}
		case D_BIZZ_TK_MEM_2: {
			if(!response) return 1;
			new id = GetPlayerID(select_member[playerid]);
			if(PI[playerid][bizz_status] == 3 || PI[playerid][bizz_status] == 2) {
				if(PI[playerid][bizz_status] == 2 && listitem == 3) return ErrorMessage(playerid,"Невозможно применить");
				switch(listitem) {
					case 2,3: {
						if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
						if(IsPlayerConnected(id)) {
							PI[id][bizz_status] = listitem-1;
							UpdatePlayerData(id,"bizz_status",PI[id][bizz_status]);
						}
						else {
							new query[350];
							mysql_format(connects,query,sizeof(query), "UPDATE `accounts` SET `bizz_status` = '%d' WHERE `Name` = '%e' LIMIT 1",listitem-1,select_member[playerid]);
							mysql_tquery(connects, query, "", "");
						}
						static const f_str[] = "Вы изменили должность для сотрудника "ORANGE"%s"G" на "ORANGE"%s";
						new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 24)];
						format(string,sizeof(string),f_str,select_member[playerid],tk_class[listitem-2]);
						SendUse(playerid,string);
						SetTimerEx("members_funcbizz_tk", 100, 0, "ii", playerid,PI[playerid][bizz_work]);
						return 1;
					}
					case 4: {
						if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
						if(IsPlayerConnected(id)) {
							if(GetPlayerState(id) == PLAYER_STATE_DRIVER && VehicleInfo[GetPlayerVehicleID(id)][vBizz] == PI[id][bizz_work]) RemovePlayerFromVehicleAC(id);
							PI[id][bizz_work] = 0;
							UpdatePlayerData(id,"bizz_work",0);
							SendOk(id,"Управляющий транспортной компании уволил вас из предприятия");
						}
						else {
							new query[350];
							mysql_format(connects,query,sizeof(query), "UPDATE `accounts` SET `bizz_work` = '0',`bizz_cash` = '0',`bizz_lcash` = '0',`bizz_status` = '0' WHERE `Name` = '%e' LIMIT 1",select_member[playerid]);
							mysql_tquery(connects, query, "", "");
						}
						static const f_str[] = "Вы уволили сотрудника транспортной компании "ORANGE"%s";
						new string[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME)];
						format(string,sizeof(string),f_str,select_member[playerid]);
						SendUse(playerid,string);
						SetTimerEx("members_funcbizz_tk", 100, 0, "ii", playerid,PI[playerid][bizz_work]);
						members_funcbizz_tk(playerid,PI[playerid][bizz_work]);
						return 1;
					}
					default: {
						new names[MAX_PLAYER_NAME + 1],status,query[128];
						mysql_format(connects,query, sizeof(query), "SELECT * FROM `accounts` WHERE BINARY `Name` = '%e' LIMIT 1", select_member[playerid]);
						new Cache:result = mysql_query(connects, query);
						new rows = cache_num_rows();
						if(rows > 0) {
							cache_get_value_name(0, "Name", names, MAX_PLAYER_NAME);
							cache_get_value_name_int(0, "bizz_status",status);
							if(PI[playerid][bizz_status] == 3 || PI[playerid][bizz_status] == 2) {
								if(id == playerid) return ErrorMessage(playerid,"Невозможно применить на себе");
								if(status == 3) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
								if(PI[playerid][bizz_status] == 2) {
									if(status == 2) return ErrorMessage(playerid,"Невозможно применить на Руководителе");
								}
								static const f_str[] = "\t%s\n\
														"P"1. "W"Изменить доступ:\n\
														\t%s- Водитель\n\
														\t%s- Управляющий\n\
														"P"2. "NO"Уволить";
								new str[sizeof(f_str) +1 + (-2 + MAX_PLAYER_NAME) + (-2 + 40)];
								format(str,sizeof(str),f_str,names,(status == 1) ? (""P"") : (""W""),(status == 2) ? (""P"") : (""W""));
								D(playerid,D_BIZZ_TK_MEM_2,DSL,""P"Сотрудник",str,"Далее","Закрыть");
							}
						}
						else ErrorMessage(playerid, "Сотрудник не найден");
						cache_delete(result);
						return 1;
					}
				}
			}
		}
		case D_BIZZ_TK_INFO: {
			if(!response) return 1;
			new bizz = PI[playerid][bizz_work];
			switch(listitem) {
				case 0: showstattk(playerid,bizz);
				case 1: {
					new string[128];
					format(string,sizeof(string),"Доход за сутки:\t"ORANGE"$%d\nДоход за всё время:\t"ORANGE"$%d",PI[playerid][bizz_lcash],PI[playerid][bizz_cash]);
					D(playerid,DIALOG_NONE,DST,""P"Доходы",string,"Закрыть","");
				}
				case 2: {
					if(PI[playerid][bizz_status] == 3) return ErrorMessage(playerid,"Вы не можете уволиться из транспортной компании");
					PI[playerid][bizz_work] = 0;
					UpdatePlayerData(playerid,"bizz_work",0);
					PI[playerid][bizz_status] = 0;
					UpdatePlayerData(playerid,"bizz_status",0);
					SendOk(playerid,"Вы уволились из транспортной компании");
				}
			}
		}
		case D_TRUCK: {
			if(!response) {
				new Veh = GetPlayerVehicleID(playerid);
				if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) {
					A_DestroyVehicle(TK_Trailer[playerid]);
					TK_Trailer[playerid] = INVALID_VEHICLE_ID;
					TI[playerid][tTrucker][3] = 0;
					TI[playerid][tTrucker][2] = 0;
					TI[playerid][tTrucker][1] = 0;
					TI[playerid][tTrucker][0] = 0;
				}
				new rand = random(sizeof(tk_gun));
				SetVehiclePos(Veh, tk_gun[rand][0],tk_gun[rand][1],tk_gun[rand][2]);
				SetVehicleZAngle(Veh, tk_gun[rand][3]);
				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);
				SetPlayerVirtualWorld(playerid,0);
				SetVehicleVirtualWorld(Veh,0);
				return 1;
			}
			new veh = GetPlayerVehicleID(playerid),prods;
			switch(GetVehicleModel(veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}
			if(!IsNumber(inputtext) || strval(inputtext) % 1000 != 0 || strval(inputtext) > prods || strval(inputtext) > zavodsklad)
			{
				static const f_str[] = ""W"Сколько боеприпасов вы хотите загрузить?\n\n\
									Максимальная грузоподъемность фуры: "ORANGE"%d"W" кг\n\
									Боеприпасов на складе: "ORANGE"%d"W" ед\n\n\
									"W"Количество загружаемых боеприпасов должно быть кратное: "ORANGE"1000"W" кг";
				new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
				format(string,sizeof(string),f_str,prods,zavodsklad);

				D(playerid,D_TRUCK,DSI, ""P"Оружейный завод",string,"Загрузить","Отмена");
				return 1;
			}
			SetPVarInt(playerid,"tk_spawn",1);
			SetTimerEx("tk_load",0,false,"ii",playerid,strval(inputtext));
			SendOk(playerid,"Загрузка фуры начата. Ожидайте завершения загрузки");
		}
		case D_TRUCK_2: {
			if(!response) {
				new Veh = GetPlayerVehicleID(playerid);
				if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) {
					A_DestroyVehicle(TK_Trailer[playerid]);
					TK_Trailer[playerid] = INVALID_VEHICLE_ID;
					TI[playerid][tTrucker][3] = 0;
					TI[playerid][tTrucker][2] = 0;
					TI[playerid][tTrucker][1] = 0;
					TI[playerid][tTrucker][0] = 0;
				}
				new rand = random(sizeof(tk_oil));
				SetVehiclePos(Veh, tk_oil[rand][0],tk_oil[rand][1],tk_oil[rand][2]);
				SetVehicleZAngle(Veh, tk_oil[rand][3]);
				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);
				SetPlayerVirtualWorld(playerid,0);
				SetVehicleVirtualWorld(Veh,0);
				return 1;
			}
			new veh = GetPlayerVehicleID(playerid),prods;
			switch(GetVehicleModel(veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}
			if(!IsNumber(inputtext) || strval(inputtext) % 1000 != 0 || strval(inputtext) > prods || strval(inputtext) > oilsklad*10000)
			{
				static const f_str[] = ""W"Сколько тонн нефти вы хотите загрузить?\n\n\
									Максимальная грузоподъемность фуры: "ORANGE"%d"W" т.\n\
									Нефти на складе: "ORANGE"%d"W" т.\n\n\
									"W"Количество загружаемого топлива должно быть кратное: "ORANGE"1000"W" т.";
				new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
				format(string,sizeof(string),f_str,prods,oilsklad*10000);

				D(playerid,D_TRUCK_2,DSI, ""P"Нефтезавод",string,"Загрузить","Отмена");
				return 1;
			}
			SetPVarInt(playerid,"tk_spawn",2);
			SetTimerEx("tk_load",0,false,"ii",playerid,strval(inputtext));
			SendOk(playerid,"Загрузка фуры начата. Ожидайте завершения загрузки");
		}
		case D_TRUCK_3: {
			if(!response) {
				new Veh = GetPlayerVehicleID(playerid);
				if(TK_Trailer[playerid] != INVALID_VEHICLE_ID) {
					A_DestroyVehicle(TK_Trailer[playerid]);
					TK_Trailer[playerid] = INVALID_VEHICLE_ID;
					TI[playerid][tTrucker][3] = 0;
					TI[playerid][tTrucker][2] = 0;
					TI[playerid][tTrucker][1] = 0;
					TI[playerid][tTrucker][0] = 0;
				}
				new rand = random(sizeof(tk_wood));
				SetVehiclePos(Veh, tk_wood[rand][0],tk_wood[rand][1],tk_wood[rand][2]);
				SetVehicleZAngle(Veh, tk_wood[rand][3]);
				TogglePlayerControllable(playerid, true);
				SetCameraBehindPlayer(playerid);
				SetPlayerVirtualWorld(playerid,0);
				SetVehicleVirtualWorld(Veh,0);
				return 1;
			}
			new veh = GetPlayerVehicleID(playerid),prods;
			switch(GetVehicleModel(veh)) {
				case 609: prods = 10000;
				case 514: prods = 12000;
				case 515: prods = 15000;
				default: prods = 10000;
			}
			if(!IsNumber(inputtext) || strval(inputtext) % 1000 != 0 || strval(inputtext) > prods || strval(inputtext) > woodsklad)
			{
				static const f_str[] = ""W"Сколько кг древесины вы хотите загрузить?\n\n\
									Максимальная грузоподъемность фуры: "ORANGE"%d"W" кг.\n\
									Древесины на складе: "ORANGE"%d"W" кг.\n\n\
									"W"Вес загружаемой древесины должно быть кратен: "ORANGE"1000"W"";
				new string[sizeof(f_str) +1 + (-2 + 4) + (-2 + 7) + (-2 + 5)];
				format(string,sizeof(string),f_str,prods,woodsklad);

				D(playerid,D_TRUCK_3,DSI, ""P"Лесопилка",string,"Загрузить","Отмена");
				return 1;
			}
			SetPVarInt(playerid,"tk_spawn",3);
			SetTimerEx("tk_load",0,false,"ii",playerid,strval(inputtext));
			SendOk(playerid,"Загрузка фуры начата. Ожидайте завершения загрузки");
		}
		case D_TRUCK_UNLOAD: {
			SetPlayerCheckpoint(playerid, -1744.4447,149.4602,3.5496, 5);
			SendOk(playerid,"Отправляйтесь к порту г. СФ");
			TI[playerid][tTrucker][1] = 1;
			TI[playerid][tTrucker][2] = tk_unloading[0];
		}
		case D_TRUCK_UNLOAD_2: {
			switch(listitem) {
				case 0: {
					SetPlayerCheckpoint(playerid, -1744.4447,149.4602,3.5496, 5);
					SendOk(playerid,"Отправляйтесь к порту г. СФ");
					TI[playerid][tTrucker][2] = tk_unloading[1];
				}
				case 1: {
					SetPlayerCheckpoint(playerid, 2616.7119,-2226.7627,13.3819, 5);
					SendOk(playerid,"Отправляйтесь к порту г. ЛС");
					TI[playerid][tTrucker][2] = tk_unloading[2];
				}
				case 2: {
					SetPlayerCheckpoint(playerid, 2687.9753,-2480.1912,13.5008, 5);
					SendOk(playerid,"Отправляйтесь к оружейному заводу");
					TI[playerid][tTrucker][2] = tk_unloading[3];
				}
			}
			TI[playerid][tTrucker][1] = listitem+1;
		}
		case D_TRUCK_UNLOAD_3: {
			switch(listitem) {
				case 0: {
					SetPlayerCheckpoint(playerid, -1744.4447,149.4602,3.5496, 5);
					SendOk(playerid,"Отправляйтесь к порту г. СФ");
					TI[playerid][tTrucker][2] = tk_unloading[1];
				}
				case 1: {
					SetPlayerCheckpoint(playerid, 2616.7119,-2226.7627,13.3819, 5);
					SendOk(playerid,"Отправляйтесь к порту г. ЛС");
					TI[playerid][tTrucker][2] = tk_unloading[2];
				}
				case 2: {
					SetPlayerCheckpoint(playerid, 2687.9753,-2480.1912,13.5008, 5);
					SendOk(playerid,"Отправляйтесь к оружейному заводу");
					TI[playerid][tTrucker][2] = tk_unloading[3];
				}
			}
			TI[playerid][tTrucker][1] = listitem+1;
		}
		case D_SPY: {
			if(!response) return 1;
			new string[7 * MAX_FRACTIONS];
			switch(listitem) {
				case 0: TI[playerid][tMasked] = fLSPD;
				case 1: TI[playerid][tMasked] = fSFPD;
				case 2: TI[playerid][tMasked] = fLVPD;
				case 3: TI[playerid][tMasked] = fMAYOR;
				case 4: TI[playerid][tMasked] = fARMYSF;
				case 5: TI[playerid][tMasked] = fARMYLV;
				case 6: TI[playerid][tMasked] = fMEDICLS;
				case 7: TI[playerid][tMasked] = fMEDICSF;
				case 8: TI[playerid][tMasked] = fMEDICLV;
				case 9: TI[playerid][tMasked] = fLSNEWS;
				case 10: TI[playerid][tMasked] = fSFNEWS;
				case 11: TI[playerid][tMasked] = fLVNEWS;
				case 12: TI[playerid][tMasked] = fLCN;
				case 13: TI[playerid][tMasked] = fYAKUZA;
				case 14: TI[playerid][tMasked] = fRM;
				case 15: TI[playerid][tMasked] = fBALLAS;
				case 16: TI[playerid][tMasked] = fVAGOS;
				case 17: TI[playerid][tMasked] = fGROVE;
				case 18: TI[playerid][tMasked] = fAZTEC;
				case 19: TI[playerid][tMasked] = fRIFA;
				case 20: TI[playerid][tMasked] = fWHITEHOUSE;
			}
			for(new i = 0; i < 10; i++) {
				if(!gFractionSkin[TI[playerid][tMasked]][i]) continue;
				format(string, sizeof(string), "%s%i\n",string,gFractionSkin[TI[playerid][tMasked]][i]);
			}
			D(playerid, D_SPY_2, DSL, ""P"Выберите скин", string, "Выбрать", "Закрыть");
			return 1;
		}
		case D_SPY_2: {
			if(!response) return TI[playerid][tMasked] = 0;
			new fraction = TI[playerid][tMasked];
			A_SetPlayerSkin(playerid,gFractionSkin[fraction][listitem]);
			SetPlayerColor(playerid,gFractionSpawn[fraction][fracColor]);
			new string[128];
			format(string, sizeof(string), "Вы взяли шпионскую одежду - "W"%s", FI[fraction][fName]);
			SendOk(playerid,string);
			SendOk(playerid,"Чтобы переодеться обратно, встаньте еще раз на пикап");
			return 1;
		}
		case D_DUEL: {
			if(!response) return 1;
			switch(listitem) {
				case 0: {
					if(TI[playerid][tDuel] != -1) {
						switch(DI[TI[playerid][tDuel]][duel_type])
						{
							case 0: return ErrorMessage(playerid,"Вы создатель лобби/уже состоите в лобби");
							case 1: return duel_lobby_2(playerid,TI[playerid][tDuel]);
							case 2: return duel_lobby_3(playerid,TI[playerid][tDuel]);
						}
					}
					string_1024[0] = EOS;
					strcat(string_1024,"№ | Создатель\tТип | Взнос\tКарта | Оружие | ХП | Броня\tСтатус\n");
					new duel_types[3][7] = {"1 VS 1","2 VS 2","3 VS 3"};
					new duel_guns[5][13] = {"Desert Eagle","ShotGun","MP5","AK-47","M4"};
					new duel_maps[3][11] = {"Карта №1","Карта №2","Карта №3"};
					new bool:duel_lobby = false;
					for(new d = 0; d < MAX_DUELS; d++) {
						if(DI[d][duel_create] == false || DI[d][duel_start] == true) continue;
						if(!DI[d][duel_password]) format(string_1024,sizeof(string_1024),"%s%d | %s\t%s | %d\t%s | %s | %d | %d\t"GREEN"OPEN"W"\n",string_1024,d,player_name[DI[d][duel_owner_id]],duel_types[DI[d][duel_type]],DI[d][duel_money],duel_maps[DI[d][duel_map]],duel_guns[DI[d][duel_gun]],DI[d][duel_health],DI[d][duel_armour]);
						else format(string_1024,sizeof(string_1024),"%s%d | %s\t%s | %d\t%s | %s | %d | %d\t"NO"CLOSE"W"\n",string_1024,d,player_name[DI[d][duel_owner_id]],duel_types[DI[d][duel_type]],DI[d][duel_money],duel_maps[DI[d][duel_map]],duel_guns[DI[d][duel_gun]],DI[d][duel_health],DI[d][duel_armour]);
						duel_lobby = true;
					}
					if(!duel_lobby) return SendBotMessage(playerid,"Доступных лобби нет");
					D(playerid,D_DUEL_2,DSTH,""P"Лобби",string_1024,"Выбрать","Закрыть");
				}
				case 1: {
					if(TI[playerid][tDuel] != -1) {
						if(playerid != DI[TI[playerid][tDuel]][duel_owner_id]) return ErrorMessage(playerid,"Вы состоите в лобби");
						else {
							duel_message(playerid,TI[playerid][tDuel]);
							return 1;
						}
					}
					new duel_t = 0;
					for(new d = 0; d < MAX_DUELS; d++) {
						if(DI[d][duel_owner_id] != INVALID_PLAYER_ID) continue;
						TI[playerid][tDuel] = d;
						DI[d][duel_owner_id] = playerid;
						duel_t++;
						break;
					}
					if(!duel_t) return SendBotMessage(playerid,"В данный момент нельзя создать лобби. Все слоты переполнены");
					duel_message(playerid,TI[playerid][tDuel]);
				}
			}
		}
		case D_DUEL_2: {
			if(!response) return 1;
			new id = strval(inputtext[0]);
			SetPVarInt(playerid,"duel_number",id);
			if(DI[id][duel_owner_id] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Выбранное лобби недоступно");
			if(DI[id][duel_start] == true) return ErrorMessage(playerid,"Выбранное лобби недоступно");
			if(!DI[id][duel_password]) {
				duel_enter(playerid,id);
				return 1;
			}
			else D(playerid,D_DUEL_ENTER_PSW,DSI,""P"Лобби | Вход","\n\n"W"Для входа в лобби введите пароль:\n\n","Войти","Отмена");
		}
		case D_DUEL_3: {
			if(!response) return 1;
			new id = GetPVarInt(playerid, "duel_number");
			DeletePVar(playerid, "duel_number");
			if(DI[id][duel_owner_id] == INVALID_PLAYER_ID) return 1;
			if(GetPlayerMoneyEx(playerid) < DI[id][duel_money]) return ErrorMessage(playerid,"Недостаточно средств");
			GiveMoney(playerid,-DI[id][duel_money],"взнос дуэль");
			DI[id][duel_cash] += DI[id][duel_money];
			TI[playerid][tDuel] = id;
			switch(DI[id][duel_type]) {
				case 0: {
					DI[id][duel_id][1] = playerid;

					start_duel_1(id);
					new Float:pos[3];
					GetPlayerPos(DI[id][duel_id][0], pos[0], pos[1], pos[2]);
					SetPVarFloat(DI[id][duel_id][0], "pos_comp_x", pos[0]);
					SetPVarFloat(DI[id][duel_id][0], "pos_comp_y", pos[1]);
					SetPVarFloat(DI[id][duel_id][0], "pos_comp_z", pos[2]);
					GetPlayerPos(DI[id][duel_id][1], pos[0], pos[1], pos[2]);
					SetPVarFloat(DI[id][duel_id][1], "pos_comp_x", pos[0]);
					SetPVarFloat(DI[id][duel_id][1], "pos_comp_y", pos[1]);
					SetPVarFloat(DI[id][duel_id][1], "pos_comp_z", pos[2]);
				}
				case 1: duel_lobby_2(playerid,id);
				case 2: duel_lobby_3(playerid,id);
			}
		}
		case D_DUEL_4: {
			if(TI[playerid][tDuel]) return 1;
			if(DI[TI[playerid][tDuel]][duel_start] == true) return 1;
			if(!response) {
				if(DI[TI[playerid][tDuel]][duel_owner_id] == playerid) duel_delete(TI[playerid][tDuel],false);
				if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,TI[playerid][tDuel]);
				TI[playerid][tDuel] = -1;
				return 1;
			}
			if(TI[playerid][tDuel] == -1) return 1;
			new id = TI[playerid][tDuel];
			switch(listitem) {
				case 0: {
					if(DI[id][duel_id][0] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][0] = playerid,TI[playerid][tDuelLobby] = 0;
						SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№1");
					}
					else duel_lobby_2(playerid,id);
				}
				case 1: {
					if(DI[id][duel_id][1] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][1] = playerid,TI[playerid][tDuelLobby] = 1;
						SendOk(playerid,"Вы заняли место "W"№2"G" в команде "W"№1");
					}
					else duel_lobby_2(playerid,id);
				}
				case 2: duel_lobby_2(playerid,id);
				case 3: {
					if(DI[id][duel_id][2] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][2] = playerid,TI[playerid][tDuelLobby] = 2;
						SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№2");
					}
					else duel_lobby_2(playerid,id);
				}
				case 4: {
					if(DI[id][duel_id][3] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][3] = playerid,TI[playerid][tDuelLobby] = 3;
						SendOk(playerid,"Вы заняли место "W"№2"G" в команде "W"№2");
					}
					else duel_lobby_2(playerid,id);
				}
			}
			if(DI[id][duel_id][0] != INVALID_PLAYER_ID && DI[id][duel_id][1] != INVALID_PLAYER_ID && DI[id][duel_id][2] != INVALID_PLAYER_ID && DI[id][duel_id][3] != INVALID_PLAYER_ID) {
				new Float:pos[3];
				GetPlayerPos(DI[id][duel_id][0], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][1], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][2], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][3], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_z", pos[2]);
				DI[id][duel_vw] = DI[id][duel_id][0]+1;
				start_duel_2(id);
			}
		}
		case D_DUEL_5: {
			if(TI[playerid][tDuel]) return 1;
			if(DI[TI[playerid][tDuel]][duel_start] == true) return 1;
			if(!response) {
				if(DI[TI[playerid][tDuel]][duel_owner_id] == playerid) duel_delete(TI[playerid][tDuel],false);
				if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,TI[playerid][tDuel]);
				TI[playerid][tDuel] = -1;
				return 1;
			}
			if(TI[playerid][tDuel] == -1) return 1;
			new id = TI[playerid][tDuel];
			switch(listitem) {
				case 0: {
					if(DI[id][duel_id][0] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][0] = playerid,TI[playerid][tDuelLobby] = 0;
						SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№1");
					}
					else duel_lobby_3(playerid,id);
				}
				case 1: {
					if(DI[id][duel_id][1] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][1] = playerid,TI[playerid][tDuelLobby] = 1;
						SendOk(playerid,"Вы заняли место "W"№2"G" в команде "W"№1");
					}
					else duel_lobby_3(playerid,id);
				}
				case 2: {
					if(DI[id][duel_id][2] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][2] = playerid,TI[playerid][tDuelLobby] = 2;
						SendOk(playerid,"Вы заняли место "W"№3"G" в команде "W"№1");
					}
					else duel_lobby_3(playerid,id);
				}
				case 3: duel_lobby_3(playerid,id);
				case 4: {
					if(DI[id][duel_id][3] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][3] = playerid,TI[playerid][tDuelLobby] = 3;
						SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№2");
					}
					else duel_lobby_3(playerid,id);
				}
				case 5: {
					if(DI[id][duel_id][4] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][4] = playerid,TI[playerid][tDuelLobby] = 4;
						SendOk(playerid,"Вы заняли место "W"№2"G" в команде "W"№2");
					}
					else duel_lobby_3(playerid,id);
				}
				case 6: {
					if(DI[id][duel_id][5] == INVALID_PLAYER_ID) {
						if(TI[playerid][tDuelLobby] != -1) duel_exit(playerid,id);
						DI[id][duel_id][5] = playerid,TI[playerid][tDuelLobby] = 5;
						SendOk(playerid,"Вы заняли место "W"№3"G" в команде "W"№2");
					}
					else duel_lobby_3(playerid,id);
				}
			}
			if(DI[id][duel_id][0] != INVALID_PLAYER_ID && DI[id][duel_id][1] != INVALID_PLAYER_ID && DI[id][duel_id][2] != INVALID_PLAYER_ID && DI[id][duel_id][3] != INVALID_PLAYER_ID && DI[id][duel_id][4] != INVALID_PLAYER_ID && DI[id][duel_id][5] != INVALID_PLAYER_ID) {
				new Float:pos[3];
				GetPlayerPos(DI[id][duel_id][0], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][0], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][1], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][1], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][2], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][2], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][3], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][3], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][4], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][4], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][4], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][4], "pos_comp_z", pos[2]);
				GetPlayerPos(DI[id][duel_id][5], pos[0], pos[1], pos[2]);
				SetPVarFloat(DI[id][duel_id][5], "pos_comp_x", pos[0]);
				SetPVarFloat(DI[id][duel_id][5], "pos_comp_y", pos[1]);
				SetPVarFloat(DI[id][duel_id][5], "pos_comp_z", pos[2]);
				DI[id][duel_vw] = DI[id][duel_id][0]+1;
				start_duel_3(id);
			}
		}
		case D_DUEL_ENTER_PSW: {
			if(!response) return 1;
			if(DI[GetPVarInt(playerid, "duel_number")][duel_owner_id] == INVALID_PLAYER_ID) return ErrorMessage(playerid,"Выбранное лобби недоступно");
			if(DI[GetPVarInt(playerid, "duel_number")][duel_start] == true) return ErrorMessage(playerid,"Выбранное лобби недоступно");
			if(strval(inputtext) != DI[GetPVarInt(playerid, "duel_number")][duel_password]) {
				D(playerid,D_DUEL_ENTER_PSW,DSI,""P"Лобби | Вход","\n\n"W"Для входа в лобби введите пароль:\n"NO"*"G" Неверный пароль\n\n","Войти","Отмена");
				return 1;
			}
			duel_enter(playerid,GetPVarInt(playerid, "duel_number"));
		}
		case D_DUEL_1: {
			if(!response) return 1;
			if(listitem != 9) {
				if(DI[TI[playerid][tDuel]][duel_create] == true) return ErrorMessage(playerid,"Запрещено изменять, после создания лобби");
			}
			switch(listitem) {
				case 0: {
					//DI[TI[playerid][tDuel]][duel_type] = 0;
					DI[TI[playerid][tDuel]][duel_type] = (DI[TI[playerid][tDuel]][duel_type] == 0) ? 1 : (DI[TI[playerid][tDuel]][duel_type] == 1) ? 2 : 0;
					duel_message(playerid,TI[playerid][tDuel]);
				}
				case 1: {
					DI[TI[playerid][tDuel]][duel_raund] = (DI[TI[playerid][tDuel]][duel_raund] == 1) ? 3 : (DI[TI[playerid][tDuel]][duel_raund] == 3) ? 5 : (DI[TI[playerid][tDuel]][duel_raund] == 5) ? 11 : 1;
					duel_message(playerid,TI[playerid][tDuel]);
				}
				case 2: {
					D(playerid,D_DUEL_MONEY,DSI, ""P"Взнос","\n\n"W"Введите сумму взноса:\n\n\
																Миниальный взнос: "ORANGE"$1000\n\
																"W"Максимальный взнос: "ORANGE"$50000","Изменить","Отмена");
				}
				case 3: {
					DI[TI[playerid][tDuel]][duel_gun] = (DI[TI[playerid][tDuel]][duel_gun] == 0) ? 1 : (DI[TI[playerid][tDuel]][duel_gun] == 1) ? 2 : (DI[TI[playerid][tDuel]][duel_gun] == 2) ? 3 : (DI[TI[playerid][tDuel]][duel_gun] == 3) ? 4 : 0;
					duel_message(playerid,TI[playerid][tDuel]);
				}
				case 4: {
					DI[TI[playerid][tDuel]][duel_gun_2] = (DI[TI[playerid][tDuel]][duel_gun_2] == 0) ? 1 : (DI[TI[playerid][tDuel]][duel_gun_2] == 1) ? 2 : (DI[TI[playerid][tDuel]][duel_gun_2] == 2) ? 3 : (DI[TI[playerid][tDuel]][duel_gun_2] == 3) ? 4 : (DI[TI[playerid][tDuel]][duel_gun_2] == 4) ? 5 : 0;
					duel_message(playerid,TI[playerid][tDuel]);
				}
				case 5: {
					DI[TI[playerid][tDuel]][duel_map] = 0;
					//DI[TI[playerid][tDuel]][duel_map] = (DI[TI[playerid][tDuel]][duel_map] == 0) ? 1 : (DI[TI[playerid][tDuel]][duel_map] == 1) ? 2 : 0;
					duel_message(playerid,TI[playerid][tDuel]);
				}
				case 6: {
					D(playerid,D_DUEL_HEALTH,DSI, ""P"Здоровье","\n\n"W"Введите состояние здоровья на дуэли:\n\n\
																Миниальное состояние: "P"10\n\
																"W"Максимальное состояние: "P"200","Изменить","Отмена");
				}
				case 7: {
					D(playerid,D_DUEL_ARMOUR,DSI, ""P"Броня","\n\n"W"Введите состояние брони на дуэли:\n\n\
																Миниальное состояние: "P"0\n\
																"W"Максимальное состояние: "P"100","Изменить","Отмена");
				}
				case 8: {
					D(playerid,D_DUEL_PASSWORD,DSI, ""P"Пароль","\n\n"W"Введите пароль для входа в лобби:\n\n\
																Пароль должен состоять из 4х цифр:","Изменить","Отмена");
				}
				case 9: {
					if(DI[TI[playerid][tDuel]][duel_create] == false) {
						if(GetPlayerMoneyEx(playerid) < DI[TI[playerid][tDuel]][duel_money]) {
							ErrorMessage(playerid,"У Вас недостаточно средств для взноса");
							new id = TI[playerid][tDuel];
							DI[id][duel_owner_id] = DI[id][duel_id][0] = DI[id][duel_id][1] = DI[id][duel_id][2] = DI[id][duel_id][3] = DI[id][duel_id][4] = DI[id][duel_id][5] = INVALID_PLAYER_ID;
							DI[id][duel_gun] = DI[id][duel_gun_2] = 0;
							DI[id][duel_money] = 1000;
							DI[id][duel_raund] = 1;
							DI[id][duel_type] = 0;
							DI[id][duel_map] = 0;
							DI[id][duel_health] = 100;
							DI[id][duel_armour] = 0;
							DI[id][duel_start] = false;
							DI[id][duel_create] = false;
							DI[id][duel_point_1] = DI[id][duel_point_2] = 0;
							TI[playerid][tDuel] = -1;
							return 1;
						}
						GiveMoney(playerid,-DI[TI[playerid][tDuel]][duel_money],"взнос дуэль");
						DI[TI[playerid][tDuel]][duel_owner_id] = playerid;
						DI[TI[playerid][tDuel]][duel_id][0] = playerid;
						DI[TI[playerid][tDuel]][duel_create] = true;
						TI[playerid][tDuelLobby] = 0;
						if(DI[TI[playerid][tDuel]][duel_type] == 1) SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№1");
						else if(DI[TI[playerid][tDuel]][duel_type] == 2) SendOk(playerid,"Вы заняли место "W"№1"G" в команде "W"№1");
						SendOk(playerid,"Лобби успешно создано");
					}
					else {
						DI[TI[playerid][tDuel]][duel_create] = false;
						SendOk(playerid,"Лобби успешно удалено");
						duel_delete(TI[playerid][tDuel],false);
					}
				}
			}
		}
		case D_DUEL_PASSWORD: {
			if(!response) {
				duel_message(playerid,TI[playerid][tDuel]);
				return 1;
			}
			if(strlen(inputtext) != 4 || !IsNumber(inputtext)) return D(playerid,D_DUEL_PASSWORD,DSI, ""P"Пароль","\n\n"W"Введите пароль для входа в лобби:\n\n\
																Пароль должен состоять из 4х цифр:","Изменить","Отмена");
			DI[TI[playerid][tDuel]][duel_password] = strval(inputtext);
			duel_message(playerid,TI[playerid][tDuel]);
		}
		case D_DUEL_HEALTH: {
			if(!response) {
				duel_message(playerid,TI[playerid][tDuel]);
				return 1;
			}
			if(strval(inputtext) < 10 || strval(inputtext) > 200) return D(playerid,D_DUEL_HEALTH,DSI, ""P"Здоровье","\n\n"W"Введите состояние здоровья на дуэли:\n\n\
																Миниальное состояние: "P"10\n\
																"W"Максимальное состояние: "P"200","Изменить","Отмена");
			DI[TI[playerid][tDuel]][duel_health] = strval(inputtext);
			duel_message(playerid,TI[playerid][tDuel]);
		}
		case D_DUEL_ARMOUR: {
			if(!response) {
				duel_message(playerid,TI[playerid][tDuel]);
				return 1;
			}
			if(strval(inputtext) < 0 || strval(inputtext) > 100) return D(playerid,D_DUEL_ARMOUR,DSI, ""P"Броня","\n\n"W"Введите состояние брони на дуэли:\n\n\
																Миниальное состояние: "P"0\n\
																"W"Максимальное состояние: "P"100","Изменить","Отмена");
			DI[TI[playerid][tDuel]][duel_armour] = strval(inputtext);
			duel_message(playerid,TI[playerid][tDuel]);
		}
		case D_DUEL_MONEY: {
			if(!response) {
				duel_message(playerid,TI[playerid][tDuel]);
				return 1;
			}
			if(strval(inputtext) < 1000 || strval(inputtext) > 50000) return D(playerid,D_DUEL_MONEY,DSI, ""P"Взнос","\n\n"W"Введите сумму взноса:\n\n\
																Миниальный взнос: "ORANGE"$1000\n\
																"W"Максимальный взнос: "ORANGE"$50000","Изменить","Отмена");
			DI[TI[playerid][tDuel]][duel_money] = strval(inputtext);
			duel_message(playerid,TI[playerid][tDuel]);
		}
		case D_REPORT_1: {
			new i = ReportID[playerid];
			if(!response) {
			    //ReportSlot[i] = -1, ReportID[playerid] = -1;
			    new 
					string[98 + MAX_PLAYER_NAME];

				format(string, 98 + MAX_PLAYER_NAME, "Администратор %s[%d] отказался отвечать на вашу жалобу. Ожидайте ответа от другого администратора",
					player_name[playerid], playerid);
	
				ErrorMessage(PlayerReport[i], string);

				format(string, 72 + MAX_PLAYER_NAME, "Вы отказались отвечать на жалобу игрока %s[%d]. Ваша репутация понижена", 
					player_name[PlayerReport[i]], PlayerReport[i]);

				ErrorMessage(playerid, string);

				gAdmin[ReportAdmin[playerid]][8] --;
				ReportDell(i);
				return 1;
			}
			if(!strlen(inputtext) || strlen(inputtext)>64) {
				static const fmt_str[] = ""W"Жалоба от %s[%i]\n\n"G"%s\n\n"NO"*"G" От 1 до 64 символов";
			    new string[sizeof(fmt_str) + 5 * 3 + 4 + (-6 + MAX_PLAYER_NAME + 4 + 64)];

				format(string, sizeof(string), fmt_str, player_name[PlayerReport[i]], PlayerReport[i], TextReport[i]);
		        D(playerid,D_REPORT_1,DSI, ""P"Репорт",string,"Принять","Отмена");
			    return 1;
			}
			if(!IsPlayerConnected(PlayerReport[i])) {
				ReportDell(i);
				ErrorMessage(playerid, "Игрок вышел с игры");
				return 1;
			}
			if(!IsAGang(PlayerReport[i])) {
				if(GetPVarInt(PlayerReport[i],"adchecking_fix")) {
					gAdvert[GetPVarInt(PlayerReport[i],"adchecking_fix")-1][adCheking]=false;
					DeletePVar(PlayerReport[i],"adchecking_fix");
				}
				static const fmt_str[] = ""W"Рассмотрена Ваша жалоба: "G"%s\n"W"Ответ от администратора %s: "P"%s\n\n";
			    new string[sizeof(fmt_str) + 5 * 4 + (-6 + 64 + MAX_PLAYER_NAME + 64)];

				format(string, sizeof(string), fmt_str, TextReport[i], player_name[playerid], inputtext);
				D(PlayerReport[i],D_REPORT_3,DSM, ""P"Репорт",string,"Спасибо","");
				ReportAdmin[PlayerReport[i]] = playerid;
			}
			else {
				new string[82 + MAX_PLAYER_NAME];
				format(string, sizeof(string), "Ответ от %s[%i]: %s",player_name[playerid],playerid,inputtext);
				SendClientMessage(PlayerReport[i], 0xff9945FF, string);
			}
			new string[98 + MAX_PLAYER_NAME * 2];
			format(string,sizeof(string),"Администратор %s[%i] для %s[%i]: %s",player_name[playerid], playerid, player_name[PlayerReport[i]], PlayerReport[i], inputtext);
			SendAdminMessage(0xff9945FF,string);
			gAdmin[playerid][ADMIN_PM] ++;

			strmid(TextReportAdmin[i], (inputtext),0,strlen(inputtext),64);
			ReportDell(i);
			ReportID[playerid] = -1;
			D(playerid,D_REPORT_4,DSL,"Быстрый ответ","Нет, это временный ответ\nДа, этот ответ может использоватся как быстрый ответ","Принять","Отмена");
			return 1;
		}
		case D_REPORT_4: {
		    //new i = ReportID[playerid];
		    switch(listitem) {
		        case 0: {
			 		SendOk(playerid, "Вы выбрали временный ответ");
			 		ReportID[playerid] = -1;
					//ReportDell(i);
		        }
		        case 1: {
					/*new query[300];
		        	format(query, sizeof(query), "INSERT INTO `reports` (`rText`, `rOtvet`, `rNick`) VALUE ('%s','%s','%s')", TextReport[i], TextReportAdmin[i], player_name[playerid]);
					mysql_tquery(connects, query);*/
					SendOk(playerid, "Вы выбрали как быстрый ответ");
					ReportID[playerid] = -1;
					//ReportDell(i);
		        }
		    }
		}
		case D_REPORT_3: return D(playerid, D_REPORT_2, DSL, ""P"Оценка работы", "Хороший ответ\nПлохой ответ", "Выбрать", "Отмена");
		case D_REPORT_2: {
			if(!response) {
			    D(playerid, D_REPORT_2, DSL, ""P"Оценка работы", "Хороший ответ\nПлохой ответ", "Выбрать", "Отмена");
			    return 1;
			}
			SendOk(playerid, "Спасибо! Ваш отзыв учтён!");
			if(ReportAdmin[playerid] == INVALID_PLAYER_ID) return 1;
			switch(listitem) {
				case 0: gAdmin[ReportAdmin[playerid]][8] ++;
				case 1: gAdmin[ReportAdmin[playerid]][8] --;
			}
			PI[playerid][pAsk]++;
			ReportAdmin[playerid] = INVALID_PLAYER_ID;
			return 1;
		}
		case D_ASK_1: {
			new i = ReportIDAsk[playerid];
			if(!response) {
			    ReportSlot[i] = -1, ReportIDAsk[playerid] = -1;
			    new string[85 + MAX_PLAYER_NAME];
				format(string, sizeof string, "Хелпер %s[%d] отказался отвечать на ваш вопрос. Ожидайте ответа от другого Хелпер'a'",player_name[playerid], playerid);
				ErrorMessage(PlayerReportAsk[i], string);
				return 1;
			}
			if(!strlen(inputtext) || strlen(inputtext)>100) {
			    new string[179 + MAX_PLAYER_NAME];
				format(string, sizeof(string), ""W"Вопрос от %s[%i]\n\n"G"%s\n\n"NO"*"G" От 1 до 100 символов", player_name[PlayerReportAsk[i]], PlayerReportAsk[i], TextAsk[i]);
		        D(playerid,D_ASK_1,DSI, ""P"Репорт",string,"Принять","Отмена");
			    return 1;
			}
			if(!IsPlayerConnected(PlayerReportAsk[i])) {
				ReportDellAsk(i);
				ReportIDAsk[playerid] = -1;
				ErrorMessage(playerid, "Игрок вышел с игры");
				return 1;
			}
			if(!strcmp(inputtext,"adm",true)){
				new bool:report = false,reps = 0;
				for(new id;id<MAX_REPORTS;id++) {
					if(PlayerReport[id] != -1) reps++;
				}
				for(new id;id<MAX_REPORTS;id++) {
					if(PlayerReport[reps] != -1) {
						reps++;
						continue;
					}
					PlayerReport[reps] = PlayerReportAsk[i];
					strmid(TextReport[reps], (TextAsk[i]),0,strlen(TextAsk[i]),110);
					new string[150];
					format(string, sizeof(string), "[REPORT] %s[%i]: %s."W" [%d] "ORANGE"(s-%d)", player_name[PlayerReportAsk[i]], PlayerReportAsk[i], TextAsk[i], reps+1,playerid);
					SendAdminMessage(COLOR_GOLD,string);
					format(string, sizeof(string), "Хелпер %s[%d] передал ваш вопрос администрации проекта",player_name[playerid],playerid);
					SendClientMessage(PlayerReportAsk[i], 0xffa141FF, string);
					format(string, sizeof string, "Ваше обращение: "G"%s"YELLOW" — успешно отправлено.", TextAsk[i]);
					SendClientMessage(PlayerReportAsk[i], COLOR_YELLOW, string);
					format(string, sizeof(string), "В скором времени вам ответит администратор. Вы в очереди репортов: "P"%d", reps+1);
					SendOk(PlayerReportAsk[i], string);
					report = true;
					ReportDellAsk(i);
					ReportIDAsk[playerid] = -1;
					break;
				}
				if(!report) {
					ReportSlot[i] = -1, ReportIDAsk[playerid] = -1;
					return ErrorMessage(playerid,"Вы не можете перенаправить вопрос администрации проекта");
				}
				return true;
			}
            new string[138 + MAX_PLAYER_NAME * 2];
			format(string, sizeof(string), "Ответ от %s[%i]: %s",player_name[playerid],playerid,inputtext);
			SendClientMessage(PlayerReportAsk[i], 0xff9945FF, string);

			format(string,sizeof(string),"Хелпер %s[%d] ответил игроку %s[%d]: %s",player_name[playerid], playerid, player_name[PlayerReportAsk[i]], PlayerReportAsk[i], inputtext);
			SendHelperMessage(0xff9945FF,string);
			PI[playerid][pAsk]++;
			ReportDellAsk(i);
			ReportIDAsk[playerid] = -1;
			return 1;
		}
		case D_LEAVE: {
			if(!response) return 1;
			if(PI[playerid][pLeader]) return ErrorMessage(playerid,"Лидеру запрещено");
			if(!PI[playerid][pMember]) return ErrorMessage(playerid,"Вы не состоите в организации");
			if(start_work[playerid]) {
				SendOk(playerid,"Рабочий день окончен");
				start_work[playerid] = 0;
			}
			add_jobinfo(playerid,"Собственное желание");
			PI[playerid][pRank] = 0;
			PI[playerid][pMember] = 0;
			PI[playerid][pJob] = 0;
			PI[playerid][pFracSkin] = 0;
			DelGun(playerid);
			SetPlayerArmour(playerid, 0);
			SetPlayerColor(playerid,0xFFFFFF11);
			skin_player(playerid);
			SaveAccount(playerid);
			FracLog(LOGS_LEAVE,player_name[playerid],player_name[playerid],"С/Ж LEAVE");
		}
		case D_LICENSES: {
			if(!response) return 1;
			new string[144];
			if(TI[playerid][tAutoSchool]) {
				new ekzamen[] = {"наземный транспорт","воздушный транспорт","водный транспорт"};
				format(string,sizeof(string),"%s завершите активный экзамен (%s)",player_name[playerid],ekzamen[TI[playerid][tAutoSchool]-1]);
				SendBotMessage(playerid,string);
				return 1;
			}
			switch(listitem) {
				case 0: {
					if(lic[playerid][0]) {
						format(string,sizeof(string),"%s у вас уже имеется данная лицензия",player_name[playerid]);
						SendBotMessage(playerid,string);
						return 1;
					}
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(500/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (500-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(500-seller),"покупка лицензии");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(500/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (500-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(500-seller),"покупка лицензии");
					}
				    else {
				    	if(PI[playerid][pCash] < 500) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
				    	GiveMoney(playerid,-500,"покупка лицензии");
				    }

					FI[fWHITEHOUSE][fBank] += 500;

					format(string,sizeof(string),"%s перейдите к прохождению теоретической части",player_name[playerid]);
					EnableGPSForPlayer(playerid, -2026.7968,-114.3422,1035.1719);
					SendBotMessage(playerid,string);
				}
				case 1: {
					if(lic[playerid][1]) {
						format(string,sizeof(string),"%s у вас уже имеется данная лицензия",player_name[playerid]);
						SendBotMessage(playerid,string);
						return 1;
					}
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(15000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (15000-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(15000-seller),"покупка лицензии");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(15000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (15000-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(15000-seller),"покупка лицензии");
					}
				    else {
				    	if(PI[playerid][pCash] < 15000) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
				    	GiveMoney(playerid,-15000,"покупка лицензии");
				    }

					FI[fWHITEHOUSE][fBank] += 15000;
					format(string,sizeof(string),"%s перейдите к прохождению практической части",player_name[playerid]);
					EnableGPSForPlayer(playerid, -2026.7968,-114.3422,1035.1719);
					SendBotMessage(playerid,string);
				}
				case 2: {
					if(lic[playerid][2]) {
						format(string,sizeof(string),"%s у вас уже имеется данная лицензия",player_name[playerid]);
						SendBotMessage(playerid,string);
						return 1;
					}
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(10000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (10000-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(10000-seller),"покупка лицензии");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(10000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (10000-seller)) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(10000-seller),"покупка лицензии");
					}
				    else {
				    	if(PI[playerid][pCash] < 10000) {
							format(string,sizeof(string),"%s у вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
				    	GiveMoney(playerid,-10000,"покупка лицензии");
				    }
				    FI[fWHITEHOUSE][fBank] += 10000;
				    if(PI[playerid][pVips] != VIP_NONE && PI[playerid][pVips] != VIP_SILVER) {
					    SendClientMessage(playerid,CGOLD,"Поздравляем с получением лицензии на полёты");
						lic[playerid][1] = 1;
						UpdateLicenses(playerid);
						return 1;
					}
					else {
						format(string,sizeof(string),"%s перейдите к прохождению практической части",player_name[playerid]);
						EnableGPSForPlayer(playerid, -2026.7968,-114.3422,1035.1719);
						SendBotMessage(playerid,string);
					}
				}
				case 3: {
					if(lic[playerid][3]) {
						format(string,sizeof(string),"%s у Вас уже имеется данная лицензия",player_name[playerid]);
						SendBotMessage(playerid,string);
						return 1;
					}
					if(PI[playerid][pVips] != VIP_PLATINA && PI[playerid][pVips] != VIP_ECSCLUSIVE) {
						if(!PI[playerid][pGunLic]) {
							format(string,sizeof(string),"%s чтобы получить лицензию на оружие требуется печать одного из врачей в любой больнице",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
					}
					if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
						new seller = floatround(20000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (20000-seller)) {
							format(string,sizeof(string),"%s у Вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(20000-seller),"покупка лицензии");
					}
					else if(BonusInfo[act_select] == 2) {
						new seller = floatround(20000/100*BonusInfo[act_buylic]);
						if(PI[playerid][pCash] < (20000-seller)) {
							format(string,sizeof(string),"%s у Вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
						GiveMoney(playerid,-(20000-seller),"покупка лицензии");
					}
				    else {
				    	if(PI[playerid][pCash] < 20000) {
							format(string,sizeof(string),"%s у Вас недостаточно средств на покупку данной лицензии",player_name[playerid]);
							SendBotMessage(playerid,string);
							return 1;
						}
				    	GiveMoney(playerid,-20000,"покупка лицензии");
				    }
					FI[fWHITEHOUSE][fBank] += 20000;

					format(string,sizeof(string),"%s Ваша лицензия готова",player_name[playerid]);
					SendBotMessage(playerid,string);
					lic[playerid][3] = 1;
					UpdateLicenses(playerid);
				}
			}
			if(listitem != 3) TI[playerid][tAutoSchool] = listitem + 1;
			UpdateFraction(fWHITEHOUSE,"Bank",FI[fWHITEHOUSE][fBank]);
		}
		case D_ADMIN_TIME: {
			if(!response) return 1;
	        if(!strlen(inputtext)) return D(playerid, D_ADMIN_TIME, DSI, ""P"Статистика администратора", "\n\n"W"Для просмотра статистики администратора\nукажите его ник:\n\n", "Ввод", "Отмена");
			new query[128];
			mysql_format(connects,query, sizeof(query), "SELECT * FROM admin WHERE Name = '%e' LIMIT 1", inputtext);
			mysql_tquery(connects, query, "OnCheckStatsAdmin", "is", playerid, inputtext);
		}
		case D_TUNE_UPDATE: {
			if(!response) return 1;
			new str[64],value,model,vehicleid = GetPlayerVehicleID(playerid);
			format(str,64,"TUN[%d][ModelID]",CustomListNum[playerid]);
			model = GetGVarInt(str,CustomType[playerid]);
			format(str,64,"TUN[%d][Value]",CustomListNum[playerid]);
			value = GetGVarInt(str,CustomType[playerid]);
			if(!IsVehicleUpgradeCompatible(GetVehicleModel(vehicleid),model)) return ErrorMessage(playerid, "Невозможно установить данную деталь");
			if(CheckTuning(playerid,GetNearestCar(playerid),model)) return ErrorMessage(playerid, "Данная деталь уже установлена");

			new price;

			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				new seller = floatround(value/100*vip_status[PI[playerid][pVips]][vip_tune]);
				price = (value-seller);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
				else if(BonusInfo[act_select] == 2) {
					new seller = floatround(value/100*BonusInfo[act_tune]);
					price = (value-seller);
				}
			    else price = value;
			}
		    if(PI[playerid][pCash] < price) return ErrorMessage(playerid, "У Вас недостаточно средств");

			new string[64];
			format(string,sizeof(string),"Вы установили деталь за "ORANGE"$%d",price);
			SendOk(playerid,string);
			ACC_AddVehicleComponent(house_car[playerid][GetNearestCar(playerid)],model);
			SaveTuning(playerid,house_car[playerid][GetNearestCar(playerid)],GetNearestCar(playerid));
			GiveMoney(playerid,-price,"Тюннинг");
			PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
		}
		case D_AMEMBERS: {
			if(!response) return 1;
			new ids = 0;
			new str[128];
			string_2048[0] = EOS;
			strcat(string_2048, "ID\tРанг\tТелефон\tВыговоры\tИмя"W"\n\n");
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[i][pMember] != listitem+1) continue;
				if(PI[i][pRank] < 1 || PI[i][pMember] < 1) continue;
				format(str, sizeof(str), "%d\t%d\t%d\t\t%d/3\t\t%s %s %s\n",i,PI[i][pRank],PI[i][pPhone],PI[i][pfWarn],player_name[i],(start_work[i]) ? ("[На работе]") : ("[Не на работе]"),(TI[i][tAFK] > 3) ? (""P"[AFK]"W""):(""));
				strcat(string_2048,str);
				ids++;
			}
			D(playerid, DIALOG_NONE, DSM, ""P"Члены организации онлайн", string_2048, "Закрыть", "");
			format(string_2048,128,"Всего игроков в организации: "ORANGE"%d",ids);
			SendOk(playerid,string_2048);
		}
		case D_LAB: {
			if(!response) return 1;
			if(!PI[playerid][pLeader]) return 1;
			new string[512],member = -1;
			if(PI[playerid][pMember] == fLCN) member = 0;
			else if(PI[playerid][pMember] == fYAKUZA) member = 1;
			else if(PI[playerid][pMember] == fRM) member = 2;
			if(member == -1) return 1;
			if(l_actor[member][listitem]) return ErrorMessage(playerid,"Рабочий уже нанят");
			format(string,sizeof(string),"\n\n"W"Вы действительно хотите нанять рабочего "P"№%d"W" за "ORANGE"$25000"W" на "P"7"W" дней?",listitem+1);
			D(playerid, D_LAB_2, DSM, ""P"Найм работника", string, "Нанять", "Закрыть");
			SetPVarInt(playerid,"lactor",listitem);
		}
		case D_LAB_2: {
			if(!response) return 1;
			new member = -1,list = GetPVarInt(playerid,"lactor");
			DeletePVar(playerid,"lactor");
			if(PI[playerid][pMember] == fLCN) member = 0;
			else if(PI[playerid][pMember] == fYAKUZA) member = 1;
			else if(PI[playerid][pMember] == fRM) member = 2;
			if(member == -1) return 1;
			if(l_actor[member][list]) return ErrorMessage(playerid,"Рабочий уже нанят");
			if(FI[PI[playerid][pMember]][fBank] < 25000) return ErrorMessage(playerid,"На складе мафии недостаточно средств");
			FI[GetTeamID(playerid)][fBank]-= 25000;
			UpdateFraction(GetTeamID(playerid),"Bank",FI[GetTeamID(playerid)][fBank]);
			SendOk(playerid,"Рабочий нанят");
			l_actort[member][list] = unix + 7*86400;
			l_actor[member][list] = 1;
			SaveLabrary(member);
			UseLabrary(member,list,1);
		}
		case D_FAKEPASS: {
			if(!response) return 1;
			if(PI[playerid][pMember] != fFBI || !start_work[playerid]) return ErrorMessage(playerid, "Вы не агент FBI");
			if(!TI[playerid][tMasked]) return ErrorMessage(playerid,"На Вас нет маскировочной формы");
			new id = GetPVarInt(playerid,"fpass2");
			DeletePVar(playerid,"fpass2");
			if(!IsPlayerConnected(id)) return ErrorMessage(playerid,not_id);
			if(GetPlayerDistanceToPlayer(playerid, id) > 5.0  || GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(id)) return ErrorMessage(playerid, "Игрок слишком далеко");
			if(active_accept(id)) return ErrorMessage(playerid,"У игрока есть активное предложение");
			TI[playerid][tFakePass] = listitem;
			new string[144];

			format(string, sizeof(string), ""P"%s "G"хочет показать Вам паспорт", player_name[playerid]);
			SendUse(id, string);
			SendClientMessage(id,COLOR_BLUE,"Нажмите "YES"Y "BLUE"чтобы согласиться "NO"N "BLUE"для отказа");

			format(string, sizeof(string), "Вы предложили "P"%s "G"показать Ваш паспорт", player_name[id]);
			SendUse(playerid, string);
			SetPVarInt(id,"fpass", playerid + 1);
		}
		case D_BUYACS: {
	        if(!response) {
				for(new i=0; i<9; i++) {
					TextDrawHideForPlayer(playerid,buy_skins[i]);
				}
				PlayerTextDrawHide(playerid,buy_player_skins[playerid]);
				CancelSelectTextDraw(playerid);
				DeletePVar(playerid,"buy_accses");
				TI[playerid][tTPpick] = true;
				SetPlayerPosAC(playerid, GetPVarFloat(playerid, "posx"), GetPVarFloat(playerid, "posy"), GetPVarFloat(playerid, "posz"),80,1);
				SetPlayerFacingAngle(playerid, GetPVarInt(playerid, "posa"));
				TogglePlayerControllable(playerid, 1);
				SetCameraBehindPlayer(playerid);
				DeletePVar(playerid, "posx");
				DeletePVar(playerid, "posy");
				DeletePVar(playerid, "posz");
				DeletePVar(playerid, "posa");
	        	return true;
			}
			new price;
	        switch(listitem) {
	        	case 0: {
	        		type_acces[playerid] = 1;
	        		SetPVarInt(playerid, "slot_acs", 1);
	        		PI[playerid][pSlotItem_Use][1] = 1;
	        		AtachPlayerAcces(playerid, acces_id_glass[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_glass[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_glass[0][0]);
	        	}
		    	case 1: {
		    	    type_acces[playerid] = 2;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_hat[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_hat[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_hat[0][0]);
		    	}
		    	case 2: {
		    	    type_acces[playerid] = 3;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_bonnet[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_bonnet[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_bonnet[0][0]);
		    	}
		    	case 3: {
		    	    type_acces[playerid] = 4;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_cap[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_cap[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_cap[0][0]);
		    	}
		    	case 4: {
		    	    type_acces[playerid] = 5;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_beret[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_beret[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_beret[0][0]);
		    	}
		    	case 5: {
		    	    type_acces[playerid] = 6;
			    	SetPVarInt(playerid, "slot_acs", 3);
	        		PI[playerid][pSlotItem_Use][3] = 1;
	        		AtachPlayerAcces(playerid, acces_id_bandanas[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_bandanas[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_bandanas[0][0]);
		    	}
		    	case 6: {
		    	    type_acces[playerid] = 7;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_panam[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_panam[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_panam[0][0]);
		    	}
		    	case 7: {
		    	    type_acces[playerid] = 8;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_sporthat[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_sporthat[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_sporthat[0][0]);
		    	}
		    	case 8: {
		    	    type_acces[playerid] = 9;
			    	SetPVarInt(playerid, "slot_acs", 0);
	        		PI[playerid][pSlotItem_Use][0] = 1;
	        		AtachPlayerAcces(playerid, acces_id_kask[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_kask[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_kask[0][0]);
		    	}
		    	case 9: {
		    	    type_acces[playerid] = 10;
			    	SetPVarInt(playerid, "slot_acs", 3);
	        		PI[playerid][pSlotItem_Use][3] = 1;
	        		AtachPlayerAcces(playerid, acces_id_mask[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_mask[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_mask[0][0]);
		    	}
		    	case 10: {
		    	    type_acces[playerid] = 11;
			    	SetPVarInt(playerid, "slot_acs", 6);
	        		PI[playerid][pSlotItem_Use][6] = 1;
	        		AtachPlayerAcces(playerid, acces_id_headphones[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 210.877365, -41.594570, 1002.757446, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 215.576373, -41.584163, 1002.658569, 1300);
					price = acces_id_headphones[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_headphones[0][0]);
		    	}
		    	case 11: {
		    	    type_acces[playerid] = 12;
			    	SetPVarInt(playerid, "slot_acs", 7);
	        		PI[playerid][pSlotItem_Use][7] = 1;
	        		AtachPlayerAcces(playerid, acces_id_watch[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 211.655944, -41.365447, 1002.099304, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 216.590118, -41.735664, 1001.380371, 1300);
					price = acces_id_watch[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_watch[0][0]);
		    	}
		    	case 12: {
		    	    type_acces[playerid] = 13;
			    	SetPVarInt(playerid, "slot_acs", 5);
	        		PI[playerid][pSlotItem_Use][5] = 1;
	        		AtachPlayerAcces(playerid, acces_id_backpack[0][0],GetPlayerSkin(playerid));
	        		InterpolateCameraPos(playerid, 212.5107 + (2.5 * floatsin(-89.8527, degrees)), -41.5253 + (2.5 * floatcos(-89.8527, degrees)), 1002.0234, 214.039825, -41.529178, 1002.489135, 1300);
					InterpolateCameraLookAt(playerid, 212.5107,-41.5253,1002.0234, 209.092712, -41.541694, 1001.763916, 1300);
					price = acces_id_backpack[0][1];
					SetPVarInt(playerid, "id_acs", acces_id_backpack[0][0]);
		    	}
			}
			SetPVarInt(playerid, "price_acs", price);
			for(new i=0; i<9; i++) {
				TextDrawShowForPlayer(playerid,buy_skins[i]);
			}
			PlayerTextDrawShow(playerid,buy_player_skins[playerid]);
			new string[12];
			format(string,sizeof(string),"$%d",price);
			PlayerTextDrawSetString(playerid,buy_player_skins[playerid],string);
			SelectTextDraw(playerid, 0x0080FFFF);
			for(new i = 0; i < 20; i++) SendClientMessage(playerid, -1, "\n");
			SCM(playerid, CGOLD, "Используйте "W"/next для просмотра следующего и "W"/prev для предыдущего");
 			SCM(playerid, CGOLD, "Используйте "W"/buy для покупки и "W"/cancel для отмены.");
	    }
	    case D_BUYACS_3: {
	        if(!response) {
	            AtachPlayerAcces(playerid, PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs")],GetPlayerSkin(playerid));
	        	DeletePVar(playerid, "slot_acs"),DeletePVar(playerid, "id_acs"),DeletePVar(playerid, "price_acs");
	        	buyacces(playerid);
	        	return true;
			}
			if(GetPlayerMoneyEx(playerid) < GetPVarInt(playerid, "price_acs")) {
	            AtachPlayerAcces(playerid, PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs")],GetPlayerSkin(playerid));
	        	DeletePVar(playerid, "slot_acs"),DeletePVar(playerid, "id_acs"),DeletePVar(playerid, "price_acs");
	        	buyacces(playerid);
	        	return true;
			}
			if(gBusiness[TI[playerid][tSelectedBusinessID]][bizzProduct] - 80 > 0) {
				gBusiness[TI[playerid][tSelectedBusinessID]][bizzProduct] -= 80;
				bizz_pay(TI[playerid][tSelectedBusinessID],GetPVarInt(playerid, "price_acs"));
			}
			SendOk(playerid, "Поздравляем с покупкой Аксесуара");
			SendOk(playerid, "Меню управления аксессуарами: "W"(/mn > Личные настройки > Аксессуары)");
			GiveMoney(playerid,-GetPVarInt(playerid, "price_acs"),"покупка аксессуара");
			PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs")] = GetPVarInt(playerid, "id_acs"); // записываем ид обьекта в слот
			PI[playerid][pSlotItem_Use][GetPVarInt(playerid, "slot_acs")] = 1;
			save_slotitem(playerid);
			save_slotitem_use(playerid);
			DeletePVar(playerid, "slot_acs"),DeletePVar(playerid, "id_acs"),DeletePVar(playerid, "price_acs");
			buyacces(playerid);
			accs_close(playerid);
	    }
		case D_BUYACS_4: {
	        if(!response) return callcmd::menu(playerid,"");
			switch(listitem) {
			    case 0:  {
			        SetPVarInt(playerid, "slot_acs_",0);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Головные уборы",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
				case 1: {
			        SetPVarInt(playerid, "slot_acs_",1);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Очки",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
				case 2: {
			        SetPVarInt(playerid, "slot_acs_",3);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Банданы",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
				case 3:  {
			        SetPVarInt(playerid, "slot_acs_",6);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Наушники",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
				case 4:  {
			        SetPVarInt(playerid, "slot_acs_",7);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Часы",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
				case 5:  {
			        SetPVarInt(playerid, "slot_acs_",5);
			        D(playerid, D_BUYACS_5, DSL,""P"Управление аксесурами: Рюкзаки",""P"1."W" Надеть\n"P"2."W" Снять\n"P"3."W" Удалить" , "Выбрать", "Отмена");
				}
			}
	    }
	    case D_BUYACS_5: {
	        if(!response) return true;
			switch(listitem) {
			    case 0: {
					if(PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs_")] == 0) return ErrorMessage(playerid, "У Вас нет этого аксессура");
					if(PI[playerid][pSlotItem_Use][GetPVarInt(playerid, "slot_acs_")] == 1) return ErrorMessage(playerid, "Этот аксессуар уже находится на Вашем персонаже");
					PI[playerid][pSlotItem_Use][GetPVarInt(playerid, "slot_acs_")] = 1;
					save_slotitem_use(playerid);
					AtachPlayerAcces(playerid, PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs_")],GetPlayerSkin(playerid));
					SendOk(playerid,"Аксессуар успешно надет");
				}
				case 1: {
			        if(PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs_")] == 0) return ErrorMessage(playerid, "У Вас нет этого аксессура");
					if(PI[playerid][pSlotItem_Use][GetPVarInt(playerid, "slot_acs_")] == 0) return ErrorMessage(playerid, "Этот аксессуар уже снят");
					PI[playerid][pSlotItem_Use][GetPVarInt(playerid, "slot_acs_")] = 0;
					save_slotitem_use(playerid);
					RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "slot_acs_"));
					SendOk(playerid,"Аксессуар успешно снят");
				}
				case 2: {
					if(PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs_")] == 0) return ErrorMessage(playerid, "У Вас нет этого аксессура");
					PI[playerid][pSlotItem][GetPVarInt(playerid, "slot_acs_")] = 0;
					save_slotitem(playerid);
					RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "slot_acs_"));
					SendOk(playerid,"Аксессуар успешно удалён");
				}
			}
			D(playerid, D_BUYACS_4, DSL,""P"Управление аксесурами",""P"1."W" Головные уборы\n"P"2."W" Очки\n"P"3."W" Банданы\n"P"4."W" Наушники\n"P"5."W" Часы\n"P"6."W" Рюкзаки" , "Выбрать", "Отмена");
	    }
		case D_GAME_DM: {
		    if(!response) return true;
		    switch(listitem) {
    			case 0: {
					if(!lic[playerid][3]) return ErrorMessage(playerid,"У Вас нет лицензии на оружие");
					if(open_game != 1) return  ErrorMessage(playerid, "В данный момент регистрация закрыта");
					new string[256];
					format(string, sizeof(string), "\n\n"W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\nОбщий взнос составляет "ORANGE"$%d\n\n", players_in_game,money_in_game);
				    D(playerid,D_GAME_DM_2,DSI,""P"Регистрация",string,"Внести","Назад");
				    return 1;
				}
				case 1: {
    		        new game_info1[650];
    		        for(new i; i < sizeof(game_info); i++) {
						strcat(game_info1,game_info[i]);
			  			D(playerid,DIALOG_NONE,DSM,""P"Информация", game_info1, "Закрыть", "");
					}
				}
			}
		}
		case D_GAME_DM_2: {
			if(!response) return 1;
			if(open_game != 1) return ErrorMessage(playerid, "В данный момент регистрация закрыта");
			if(player_to_game[playerid] == 1) return ErrorMessage(playerid, "Вы уже зарегистрировались");
			if(strval(inputtext) < 1000 ||strval(inputtext) > 10000) {
				new string[356];
				format(string, sizeof(string), "\n\n"W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\nОбщий взнос составляет "ORANGE"$%d\n\n"NO"*"G" Размер взноса от $1000 до $10000", players_in_game,money_in_game);
				D(playerid,D_GAME_DM_2,DSI,""P"Регистрация",string,"Внести","Назад");
				return 1;
			}
			if(strval(inputtext) > PI[playerid][pCash]) return ErrorMessage(playerid, "У Вас недостаточно средств");
			GiveMoney(playerid,-strval(inputtext),"взнос на сумасшедшие войны");
			TI[playerid][tCashDM] = strval(inputtext);
            SendOk(playerid, "Вы успешно зарегистрировались");
			players_in_game++;

            money_in_game += strval(inputtext);

			new string[70];
			format(string,sizeof(string),"Общий взнос: "O"$%d",money_in_game);
			UpdateDynamic3DTextLabelText(gamedm_text,-1,string);

            player_to_game[playerid] = 1;
			new query[148];
			format(query, sizeof(query), "INSERT INTO `dm_arena` (Name, kills_dm) VALUES ('%s', '0')", player_name[playerid]);
			mysql_tquery(connects, query);
		}
		case D_GAME_RACE: {
		    if(!response) return true;
		    switch(listitem) {
    			case 0: {
					if(!lic[playerid][0]) return ErrorMessage(playerid,"У Вас нет водительских прав");
    		        if(open_race_lv != 1) return ErrorMessage(playerid,"В данный момент регистрация закрыта");
					if(players_in_race_lv >= 25) return ErrorMessage(playerid,"Нет места для регистрации! Всего 25 участников");
					new string[256];
					format(string, sizeof(string), "\n\n"W""W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\n\n"W"Общий взнос составляет "ORANGE"$%d\n\n", players_in_race_lv,money_in_race_lv);
				    D(playerid,D_GAME_RACE_2,DSI,""P"Регистрация",string,"Внести","Назад");
				    return 1;
				}
				case 1: {
    		        new game_info2[650];
    		        for(new i; i < sizeof(game_info_race_lv); i++) {
						strcat(game_info2,game_info_race_lv[i]);
			  			D(playerid,DIALOG_NONE,DSM,""P"Информация", game_info2, "Закрыть", "");
					}
				}
			}
		}
		case D_GAME_RACE_2: {
			if(!response) return 1;
			if(player_to_race_lv[playerid] == 1) return ErrorMessage(playerid, "Вы уже зарегистрировались");
			if(players_in_race_lv >= 25) return ErrorMessage(playerid, "Нет места для регистрации! Всего 25 участников");
			if(open_race_lv != 1) return ErrorMessage(playerid, "В данный момент регистрация закрыт!");
			if(strval(inputtext) < 1000 ||strval(inputtext) > 10000) {
				new string[356];
				format(string, sizeof(string), "\n\n"W""W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\n\n"W"Общий взнос составляет "ORANGE"$%d\n\n"NO"*"G" Размер взноса от $1000 до $10000", players_in_race_lv,money_in_race_lv);
				D(playerid,D_GAME_RACE_2,DSI,""P"Регистрация",string,"Внести","Назад");
				return 1;
			}
			if(strval(inputtext) > PI[playerid][pCash]) return ErrorMessage(playerid, "У Вас недостаточно средств");
			GiveMoney(playerid,-strval(inputtext),"взнос на безумные гонки");
			TI[playerid][tCashRace] = strval(inputtext);
            SendOk(playerid, "Вы успешно зарегистрировались");
			players_in_race_lv ++;
            money_in_race_lv += strval(inputtext);
            player_to_race_lv[playerid] = 1;
            player_to_race_lv_id[playerid] = players_in_race_lv;

			new string[70];
			format(string,sizeof(string),"Общий взнос: "O"$%d",money_in_race_lv);
			UpdateDynamic3DTextLabelText(gamerace_text,-1,string);
		}
		case D_GAME_GOLOD: {
		    if(!response) return true;
		    switch(listitem) {
    			case 0: {
    		        if(!open_gamegolod) return ErrorMessage(playerid,"В данный момент регистрация закрыта");
					if(players_in_golod >= 21) return ErrorMessage(playerid,"Нет места для регистрации! Всего 21 участников");
					new string[256];
					format(string, sizeof(string), "\n\n"W""W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\n\n"W"Общий взнос составляет "ORANGE"$%d\n\n", players_in_golod,money_in_golod);
				    D(playerid,D_GAME_GOLOD_2,DSI,""P"Регистрация",string,"Внести","Назад");
				    return 1;
				}
				case 1: {
    		        new game_info2[650];
    		        for(new i; i < sizeof(golod_info); i++) {
						strcat(game_info2,golod_info[i]);
			  			D(playerid,DIALOG_NONE,DSM,""P"Информация", game_info2, "Закрыть", "");
					}
				}
			}
		}
		case D_GAME_GOLOD_2: {
			if(!response) return 1;
			if(player_to_golod[playerid]) return ErrorMessage(playerid, "Вы уже зарегистрировались");
			if(players_in_golod >= 21) return ErrorMessage(playerid, "Нет места для регистрации! Всего 21 участников");
			if(!open_gamegolod) return ErrorMessage(playerid, "В данный момент регистрация закрыта");
			if(strval(inputtext) < 1000 ||strval(inputtext) > 10000) {
				new string[356];
				format(string, sizeof(string), "\n\n"W""W"Для регистрации, необходимо сделать взнос.\nВ данный момент, минимальный взнос составляет "ORANGE"$1000\n"W"Всего зарегистрировались "P"%d "W"игроков\n\n"W"Общий взнос составляет "ORANGE"$%d\n\n"NO"*"G" Размер взноса от $1000 до $10000", players_in_golod,money_in_golod);
				D(playerid,D_GAME_GOLOD_2,DSI,""P"Регистрация",string,"Внести","Назад");
				return 1;
			}
			if(strval(inputtext) > PI[playerid][pCash]) return ErrorMessage(playerid, "У Вас недостаточно средств");
			GiveMoney(playerid,-strval(inputtext),"взнос на голодные игры");
			TI[playerid][tCashRace] = strval(inputtext);
            SendOk(playerid, "Вы успешно зарегистрировались");
			players_in_golod ++;
            money_in_golod += strval(inputtext);
            player_to_golod[playerid] = 1;
            player_to_golod_id[playerid] = players_in_golod;
            golod_use_pickup[playerid] = 0;

			new string[70];
			format(string,sizeof(string),"Общий взнос: "O"$%d",money_in_golod);
			UpdateDynamic3DTextLabelText(golod_text,-1,string);
		}
		case D_GIVE: {
		    if(!response) return true;
		    switch(listitem) {
    			case 0: D(playerid,D_GIVE_2,DSI,""P"Передача аптечки","\n\n"W"Укажите количество аптечек, которое хотите передать:\n\n","Передать","Отмена");
				case 1: D(playerid,D_GIVE_2,DSI,""P"Передача маски","\n\n"W"Укажите количество масок, которое хотите передать:\n\n","Передать","Отмена");
				case 2: D(playerid,D_GIVE_2,DSI,""P"Передача материалов","\n\n"W"Укажите количество материалов, которое хотите передать:\n\n","Передать","Отмена");
				case 3: D(playerid,D_GIVE_2,DSI,""P"Передача наркотиков","\n\n"W"Укажите количество наркотиков, которое хотите передать:\n\n","Передать","Отмена");
				case 4: D(playerid,D_GIVE_2,DSI,""P"Передача ремкомплекта","\n\n"W"Укажите количество ремкомплектов, которое хотите передать:\n\n","Передать","Отмена");
			}
			SetPVarInt(playerid, "Give_Tupe",listitem+1);
		}
		case D_GIVE_2: {
		    if(!response) return DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		    switch(GetPVarInt(playerid, "Give_Tupe")) {
		        case 1: {
					if(!response) return DeletePVar(playerid, "Give_ID");
					if(strval(inputtext) < 1 || strval(inputtext) > 5) {
						D(playerid,D_GIVE_2,DSI,""P"Передача аптечки","\n\n"W"Укажите количество аптечек, которое хотите передать:\n\n"NO"*"G"От 1 до 5 аптечек","Передать","Отмена");
						return 1;
					}
					if(strval(inputtext) > PI[playerid][pMedKit]) return ErrorMessage(playerid, "У Вас нет столько аптечек"), DeletePVar(playerid, "Give_ID");
					if((strval(inputtext)+PI[GetPVarInt(playerid, "Give_ID")][pMedKit]) > vip_status[PI[GetPVarInt(playerid, "Give_ID")][pVips]][vip_heal]) return ErrorMessage(playerid, "Игрок не унесет столько аптечек"),DeletePVar(playerid, "Give_ID");
		            PI[playerid][pMedKit] -=strval(inputtext);
					UpdatePlayerData(playerid,"pMedKit",PI[playerid][pMedKit]);
					PI[GetPVarInt(playerid, "Give_ID")][pMedKit] +=strval(inputtext);
					UpdatePlayerData(GetPVarInt(playerid, "Give_ID"),"pMedKit",PI[GetPVarInt(playerid, "Give_ID")][pMedKit]);
		            new string[128];
		            format(string,sizeof(string),"Вы передали "W"%s "ORANGE"%d"G" аптечку(и)",player_name[GetPVarInt(playerid, "Give_ID")],strval(inputtext));
					SendOk(playerid,string);
				 	format(string,sizeof(string),""W"%s передал Вам "ORANGE"%d"G" аптчечку(и)",player_name[playerid],strval(inputtext));
					SendOk(GetPVarInt(playerid, "Give_ID"),string);
				}
				case 2: {
					if(!response) return DeletePVar(playerid, "Give_ID");
					if(strval(inputtext) < 1 || strval(inputtext) > 3) {
						D(playerid,D_GIVE_2,DSI,""P"Передача маски","\n\n"W"Укажите количество масок, которое хотите передать:\n\n"NO"*"G"От 1 до 3 масок","Передать","Отмена");
						return 1;
					}
					if(strval(inputtext) > PI[playerid][pMask]) return ErrorMessage(playerid, "У Вас нет столько масок"),  DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
					if((strval(inputtext)+PI[GetPVarInt(playerid, "Give_ID")][pMask]) > vip_status[PI[GetPVarInt(playerid, "Give_ID")][pVips]][vip_mask]) return ErrorMessage(playerid, "Игрок не унесет столько масок"),DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		            PI[playerid][pMask] -=strval(inputtext);
					UpdatePlayerData(playerid,"pMask",PI[playerid][pMask]);
					PI[GetPVarInt(playerid, "Give_ID")][pMask] +=strval(inputtext);
					UpdatePlayerData(GetPVarInt(playerid, "Give_ID"),"pMask",PI[GetPVarInt(playerid, "Give_ID")][pMask]);
		            new string[128];
		            format(string,sizeof(string),"Вы передали "W"%s "ORANGE"%d"G" маску(и)",player_name[GetPVarInt(playerid, "Give_ID")],strval(inputtext));
					SendOk(playerid,string);
				 	format(string,sizeof(string),""W"%s передал Вам "ORANGE"%d"G" маску(и)",player_name[playerid],strval(inputtext));
					SendOk(GetPVarInt(playerid, "Give_ID"),string);
				}
				case 3: {
					if(!response) return DeletePVar(playerid, "Give_ID");
					if(strval(inputtext) < 1 || strval(inputtext) > 500) {
						D(playerid,D_GIVE_2,DSI,""P"Передача материалов","\n\n"W"Укажите количество материалов, которое хотите передать:\n\n"NO"*"G"От 1 до 500 боеприпасов","Передать","Отмена");
						return 1;
					}
					if(strval(inputtext) > PI[playerid][pMats]) return ErrorMessage(playerid, "У Вас нет столько боеприпасов"),  DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
					if((strval(inputtext)+PI[GetPVarInt(playerid, "Give_ID")][pMats]) > vip_status[PI[GetPVarInt(playerid, "Give_ID")][pVips]][vip_mats]) return ErrorMessage(playerid, "Игрок не унесет столько боеприпасов"),DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		            PI[playerid][pMats] -=strval(inputtext);
					UpdatePlayerData(playerid,"pMats",PI[playerid][pMats]);
				    PI[GetPVarInt(playerid, "Give_ID")][pMats] +=strval(inputtext);
					UpdatePlayerData(GetPVarInt(playerid, "Give_ID"),"pMats",PI[GetPVarInt(playerid, "Give_ID")][pMats]);
		            new string[128];
		            format(string,sizeof(string),"Вы передали "W"%s "ORANGE"%d"G" боеприпасов",player_name[GetPVarInt(playerid, "Give_ID")],strval(inputtext));
					SendOk(playerid,string);
				 	format(string,sizeof(string),""W"%s передал Вам "ORANGE"%d"G" боеприпасов",player_name[playerid],strval(inputtext));
					SendOk(GetPVarInt(playerid, "Give_ID"),string);
				}
				case 4: {
					if(!response) return DeletePVar(playerid, "Give_ID");
					if(strval(inputtext) < 1 || strval(inputtext) > 50) {
						D(playerid,D_GIVE_2,DSI,""P"Передача наркотиков","\n\n"W"Укажите количество наркотиков, которое хотите передать:\n\n"NO"*"G"От 1 до 50 наркотиков","Передать","Отмена");
						return 1;
					}
					if(strval(inputtext) > PI[playerid][pDrugs]) return  ErrorMessage(playerid, "У Вас нет столько наркотиков"),  DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
					if((strval(inputtext)+PI[GetPVarInt(playerid, "Give_ID")][pDrugs]) > vip_status[PI[GetPVarInt(playerid, "Give_ID")][pVips]][vip_drugs]) return ErrorMessage(playerid, "Игрок не унесет столько наркотиков"),DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		            PI[playerid][pDrugs] -=strval(inputtext);
					UpdatePlayerData(playerid,"pDrugs",PI[playerid][pDrugs]);
					PI[GetPVarInt(playerid, "Give_ID")][pDrugs] +=strval(inputtext);
					UpdatePlayerData(GetPVarInt(playerid, "Give_ID"),"pDrugs",PI[GetPVarInt(playerid, "Give_ID")][pDrugs]);
		            new string[128];
		            format(string,sizeof(string),"Вы передали "W"%s "ORANGE"%dг"G" наркотиков",player_name[GetPVarInt(playerid, "Give_ID")],strval(inputtext));
					SendOk(playerid,string);
				 	format(string,sizeof(string),""W"%s передал Вам "ORANGE"%dг"G" наркотиков",player_name[playerid],strval(inputtext));
					SendOk(GetPVarInt(playerid, "Give_ID"),string);
				}
				case 5: {
					if(!response) return DeletePVar(playerid, "Give_ID");
					if(strval(inputtext) < 1 || strval(inputtext) > 5) {
						D(playerid,D_GIVE_2,DSI,""P"Передача ремкомплекта","\n\n"W"Укажите количество ремкомплектов, которое хотите передать:\n\n"NO"*"G"От 1 до 5 ремкомплектов","Передать","Отмена");
						return 1;
					}
					if(strval(inputtext) > PI[playerid][pInstrument]) return  ErrorMessage(playerid, "У Вас нет столько ремкомплектов"),  DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
					if((strval(inputtext)+PI[GetPVarInt(playerid, "Give_ID")][pInstrument]) > 5) return ErrorMessage(playerid, "Игрок не унесет столько ремкомплектов"),DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		            PI[playerid][pInstrument] -=strval(inputtext);
					UpdatePlayerData(playerid,"pInstr",PI[playerid][pInstrument]);
					PI[GetPVarInt(playerid, "Give_ID")][pInstrument] +=strval(inputtext);
					UpdatePlayerData(GetPVarInt(playerid, "Give_ID"),"pInstr",PI[GetPVarInt(playerid, "Give_ID")][pInstrument]);
		            new string[128];
		            format(string,sizeof(string),"Вы передали "W"%s "ORANGE"%d"G" ремонтных комплектов",player_name[GetPVarInt(playerid, "Give_ID")],strval(inputtext));
					SendOk(playerid,string);
				 	format(string,sizeof(string),""W"%s передал Вам "ORANGE"%d"G" ремонтных комплектов",player_name[playerid],strval(inputtext));
					SendOk(GetPVarInt(playerid, "Give_ID"),string);
				}
			}
			SetPlayerChatBubble(playerid, "Что-то передал", COLOR_PURPLE, 30.0, 5000);
			ApplyAnimation(playerid, "INT_SHOP", "shop_pay", 4.1, 0, 0, 0, 0,0,1);
			DeletePVar(playerid, "Give_ID"),DeletePVar(playerid, "Give_Tupe");
		}
		case D_REPAIR_LIST: {
			if(!response) return true;
			if(PI[playerid][pInstrument] < 1) return ErrorMessage(playerid,"Недостаточно инструментов");
			new veh = GetPVarInt(playerid,"MechOsmotrVEHID");
			new Float:vhealth;
			GetVehicleHealth(veh, vhealth);
			new panels_job,doors_job,lights_job,tires_job;
			GetVehicleDamageStatus(veh,panels_job,doors_job,lights_job,tires_job);
			switch(listitem) {
				case 0: {
					if(!doors_job) return ErrorMessage(playerid,"Починка дверей не требуется");
					D(playerid,D_REPAIR,DSM,""P"Починка дверей","\n\n"W"Вы уверены, что хотите починить двери?\n\n","Да","Нет");
				}
				case 1: {
					if(!panels_job) return ErrorMessage(playerid,"Починка корпуса не требуется");
					D(playerid,D_REPAIR,DSM,""P"Починка корпуса","\n\n"W"Вы уверены, что хотите починить корпус?\n\n","Да","Нет");
				}
				case 2: {
					if(!lights_job) return ErrorMessage(playerid,"Починка фар не требуется");
					new Float:pos[6];
					GetCoordBonnetVehicle(veh, pos[0], pos[1], pos[2]);
					GetCoordBootVehicle(veh, pos[3], pos[4], pos[5]);
					if(!IsPlayerInRangeOfPoint(playerid,2.5,pos[0], pos[1], pos[2]) && !IsPlayerInRangeOfPoint(playerid,3.5,pos[3], pos[4], pos[5])) return ErrorMessage(playerid,"Вы далеко от фар Т/С");
					D(playerid,D_REPAIR,DSM,""P"Починка фар","\n\n"W"Вы уверены, что хотите починить фары?\n\n","Да","Нет");
				}
				case 3: {
					if(!tires_job) return ErrorMessage(playerid,"Починка колёс не требуется");
					D(playerid,D_REPAIR,DSM,""P"Починка колес","\n\n"W"Вы уверены, что хотите заменить колеса?\n\n","Да","Нет"),SetPVarInt(playerid,"JOBOSMOTR",4);
				}
	   			case 4: {
					if(vhealth >= 1000) return ErrorMessage(playerid,"Починка не требуется");
					new Float:pos[6];
					GetCoordBonnetVehicle(veh, pos[0], pos[1], pos[2]);
					GetCoordBootVehicle(veh, pos[3], pos[4], pos[5]);
					if(!IsPlayerInRangeOfPoint(playerid,2.5,pos[0], pos[1], pos[2]) && !IsPlayerInRangeOfPoint(playerid,3.5,pos[3], pos[4], pos[5])) return ErrorMessage(playerid,"Вы далеко от двигателя Т/С");
					D(playerid,D_REPAIR,DSM,""P"Починка двигателя","\n\n"W"Вы уверены, что хотите починить двигатель?\n\n","Да","Нет"),SetPVarInt(playerid,"JOBOSMOTR",5);
				}
				case 5: callcmd::remp(playerid,"");
			}
			SetPVarInt(playerid,"JOBOSMOTR",listitem+1);
			return 1;
		}
		case D_REPAIR: {
			if(!response) return true;
			new vehydid = GetPVarInt(playerid,"MechOsmotrVEHID");
			switch(GetPVarInt(playerid,"JOBOSMOTR")) {
				case 1: SetPlayerChatBubble(playerid, "осматривает двери транспорта", COLOR_PURPLE, 15, 5000);
				case 2: SetPlayerChatBubble(playerid, "осматривает копус транспорта", COLOR_PURPLE, 15, 5000);
				case 3: SetPlayerChatBubble(playerid, "осматривает фары транспорта", COLOR_PURPLE, 15, 5000);
				case 4: SetPlayerChatBubble(playerid, "осматривает колёса транспорта", COLOR_PURPLE, 15, 5000);
				case 5: {
					SetPlayerChatBubble(playerid, "осматривает двигатель транспорта", COLOR_PURPLE, 15, 5000);
					GetVehicleParamsEx(vehydid,engine,lights,alarm,doors,bonnet,boot,objective);
					SetVehicleParamsEx(vehydid,engine,lights,alarm,doors,true,boot,objective);
				}
			}
			TogglePlayerControllable(playerid, false);
			TI[playerid][tProcess][0] = 0;
			TI[playerid][tProcess][1] = 10;
			JobTempProcess[playerid] = 8;
			StartJobProcess(playerid);
			// RandomYareNforJOBS(playerid);
			// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
			// for(new YN = 0;YN < 3;YN++) {
			// 	TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
			// 	if(YN < 2) PlayerTextDrawShow(playerid,YandNsysTDPlayer[playerid][YN]);
			// }
			return true;
		}
		case D_VACANCY: {
			if(!response) return 1;
			new vacancies = 0;
			for(new i = 0; i < 14; i++) {
			    if(VacancyInfo[i][VacancyStatus]) vacancies++;
			}
			if(PI[playerid][pMember] && PI[playerid][pRank] >= FI[GetTeamID(playerid)][fInviteRang] && !IsAGang(playerid) && !IsAMafia(playerid)) {
			    if(listitem == 0 && vacancies == 0) return D(playerid, D_VACANCY_2,DSI, ""P"Добавить вакансию", "\n\n"W"Укажите требования для приёма в Вашу организацию:\n\n", "Принять", "Отмена");
				else if(vacancies != 14 && listitem == vacancies) return D(playerid, D_VACANCY_2, DIALOG_STYLE_INPUT, ""P"Добавить вакансию", "\n\n"W"Укажите требования для приёма в Вашу организацию:\n\n", "Принять", "Отмена");
			}
			if(vacancies == 0) return ErrorMessage(playerid, "Сейчас нет доступных вакансий");
			if(listitem == vacancies + 1) callcmd::vacancy(playerid);
			new items = 0;
			for(new i = 0; i < 14; i++) {
			    if(VacancyInfo[i][VacancyStatus] == true) items++;
			    if(items - 1 == listitem) {
			        new string[63+28+100];
					format(string, sizeof(string), ""W"Организация: {%s}%s\n"W"Критерии: "G"%s\n",  GetColorFrac(VacancyInfo[i][VacancyFraction]), FI[VacancyInfo[i][VacancyFraction]][fName], VacancyInfo[i][VacancyText]);
					if(VacancyInfo[i][VacancyFraction] != PI[playerid][pLeader]) return D(playerid, DIALOG_NONE, DSM, ""P"Вакансия", string, "Закрыть", "");
					return D(playerid, D_VACANCY_3, DSM, ""P"Вакансия", string, "Удалить", "Отмена");
			    }
			}
		}
		case D_VACANCY_2: {
			if(!response) return 1;
			new text[120];
			if(sscanf(inputtext, "s[120]", text) || strlen(inputtext) > 120) return D(playerid, D_VACANCY_2, DSI, ""P"Добавить вакансию", "\n\n"W"Укажите требования для приёма в Вашу организацию:\n\n"NO"*"G" Не более 120 символов", "Принять", "Отмена");
            for(new i = 0; i < 14; i++) {
			    if(VacancyInfo[i][VacancyFraction] == PI[playerid][pMember] && VacancyInfo[i][VacancyStatus] == true)
			        return ErrorMessage(playerid, "Вакансия Вашей организации уже добавлена, удалите старую");
            }
			for(new i = 0; i < 14; i++)  {
			    if(VacancyInfo[i][VacancyStatus] == false) {
			        VacancyInfo[i][VacancyText] = text;
                    VacancyInfo[i][VacancyFraction] = PI[playerid][pMember];
                    VacancyInfo[i][VacancyStatus] = true;
					VacancyInfo[i][VacancyCreator] = playerid;

                    SendOk(playerid, "Вакансия успешно добавлена");
                    return callcmd::vacancy(playerid);
				}
			}
			return callcmd::vacancy(playerid);
		}
		case D_VACANCY_3: {
		    if(!response) return callcmd::vacancy(playerid);
			for(new i = 0; i < 14; i++)  {
			    if(VacancyInfo[i][VacancyFraction] == PI[playerid] [pLeader]) {
			        VacancyInfo[i][VacancyStatus] = false;
					VacancyInfo[i][VacancyCreator] = INVALID_PLAYER_ID;
			        return SendOk(playerid, "Вакансия успешно удалена");
			     }
			}
		}
		case D_OBJ: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid,D_OBJ_2,DSL,""P"Ограждения",""P"1."W" Преграда №1\n"P"2."W" Преграда №2\n"P"3."W" Отбойник\n"P"4."W" Конус\n"P"5."W" Табличка\n"P"6."W" Лежачий полицеский\n"P"7."W" Железный забор №1\n"P"8."W" Железный забор №2","Выбрать","Отмена");
				case 1: D(playerid,D_OBJ_3,DSL,""P"Ограждения",""P"1."W" Ограничение скорости\n"P"2."W" Запрет движения прямо\n"P"3."W" Закрыто\n"P"4."W" Стоп\n"P"5."W" Уступить дорогу\n"P"6."W" Ремонт дороги\n"P"7."W" Направление движения прямо\n"P"8."W" Поворот налево\n"P"9."W" Поворот направо","Выбрать","Отмена");
				case 2: D(playerid,D_OBJ_4,DSL,""P"Ограждения",""P"1."W" Радар","Выбрать","Отмена");
				case 3: {
					new Float:x, Float:y, Float:z;
					GetPlayerPos(playerid, x, y, z);
					for(new i;i<MAX_OGRAD;i++) {
						if(object[i]!=-1) {
							GetDynamicObjectPos(object[i],x,y,z);
							if(IsPlayerInRangeOfPoint(playerid,2,x,y,z)) {
								if(objectrot[i] != -1) {
									DestroyDynamicObject(objectrot[i]);
									objectrot[i]=-1;
								}
								DestroyDynamicObject(object[i]);
								object[i]=-1;
								SendOk(playerid,"Ограждение успешно убрано");
								return 1;
							}
						}
					}
				}
			}
		}
		case D_OBJ_2: {
			if(!response) return callcmd::fences(playerid,"");
			new idobject;
			for(idobject = 0;idobject<MAX_OGRAD;idobject++) {
				if(object[idobject]==-1) break;
			}
			if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid)!=0 ) return ErrorMessage(playerid, "Запрещено использовать в здании");
			new Float:x, Float:y, Float:z, Float:angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			x += floatsin(-angle, degrees);
			y += floatcos(-angle, degrees);
			switch(listitem) {
				case 0: object[idobject] = CreateDynamicObject(1423, x, y, z-0.25, 0, 0, angle);
				case 1: object[idobject] = CreateDynamicObject(1282, x,y,z-0.3,0, 0, angle-90);
				case 2: object[idobject] = CreateDynamicObject(1237, x,y,z-1.0,0, 0, angle);
				case 3: object[idobject] = CreateDynamicObject(1238, x,y,z-0.65,0, 0, angle);
				case 4: D(playerid,D_OBJ_5,DSI,""P"Ограждения","\n\n"W"Введите текст, который будет отображаться на ограждении\n\n","Ввод","Отмена");
				case 5: object[idobject] = CreateDynamicObject(19425, x,y,z-0.9,0, 0, angle);
				case 6: object[idobject] = CreateDynamicObject(983, x,y,z-0.3,0, 0, angle-90);
				case 7: object[idobject] = CreateDynamicObject(970, x,y,z-0.5,0, 0, angle);
			}
			if(listitem != 4) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0),Streamer_Update(playerid);
		}
		case D_OBJ_3: {
			if(!response) return callcmd::fences(playerid,"");
			new idobject;
			for(idobject = 0;idobject<MAX_OGRAD;idobject++) {
				if(object[idobject]==-1) break;
			}
			if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid)!=0 ) return ErrorMessage(playerid, "Запрещено использовать в здании");
			new Float:x, Float:y, Float:z, Float:angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			x += floatsin(-angle, degrees);
			y += floatcos(-angle, degrees);
			switch(listitem) {
				case 0: object[idobject] = CreateDynamicObject(11699, x,y,z-1.1,0, 0, angle);
				case 1: object[idobject] = CreateDynamicObject(19950, x,y,z-1.1,0, 0, angle);
				case 2: object[idobject] = CreateDynamicObject(19967, x,y,z-1.1,0, 0, angle);
				case 3: object[idobject] = CreateDynamicObject(19966, x,y,z-1.1,0, 0, angle);
				case 4: object[idobject] = CreateDynamicObject(19976 , x,y,z-1.1,0, 0, angle);
				case 5: object[idobject] = CreateDynamicObject(19974, x,y,z-1.1,0, 0, angle);
				case 6: object[idobject] = CreateDynamicObject(19957, x,y,z-1.1,0, 0, angle);
				case 7: object[idobject] = CreateDynamicObject(19955, x,y,z-1.1,0, 0, angle);
				case 8: object[idobject] = CreateDynamicObject(19956, x,y,z-1.1,0, 0, angle);
			}
			Streamer_Update(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
		}
		case D_OBJ_4: {
			if(!response) return callcmd::fences(playerid,"");
			new idobject;
			for(idobject = 0;idobject<MAX_OGRAD;idobject++) {
				if(object[idobject]==-1) break;
			}
			if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid)!=0 ) return ErrorMessage(playerid, "Запрещено использовать в здании");
			new Float:x, Float:y, Float:z, Float:angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			x += floatsin(-angle, degrees);
			y += floatcos(-angle, degrees);
			switch(listitem) {
				case 0: object[idobject] = CreateDynamicObject(18880, x,y,z-1.3,0, 0, angle);
			}
			Streamer_Update(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
		}
		case D_OBJ_5: {
			if(!response) return callcmd::fences(playerid,"");
			if(strlen(inputtext) < 5 || strlen(inputtext) > 40) {
				D(playerid,D_OBJ_5,DSI,""P"Ограждения","\n\n"W"Введите текст, который будет отображаться на ограждении\n\n"NO"*"G" От 5 до 40 символов","Ввод","Отмена");
				return 1;
			}
			new idobject;
			for(idobject = 0;idobject<MAX_OGRAD;idobject++) {
				if(object[idobject]==-1) break;
			}
			if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid)!=0 ) return ErrorMessage(playerid, "Запрещено использовать в здании");
			new Float:x, Float:y, Float:z, Float:angle,Float:rx, Float:ry, Float:rz,Float:ox, Float:oy, Float:oz;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
			x += floatsin(-angle, degrees);
			y += floatcos(-angle, degrees);
			object[idobject] = CreateDynamicObject(19980, x,y,z-1.0,0, 0, angle);
			SetDynamicObjectMaterial(object[idobject], 2, 2823, "gb_kitchtake", "deep_red64", 0);
			GetDynamicObjectPos(object[idobject], ox, oy, oz);
			GetDynamicObjectRot(object[idobject], rx, ry, rz);
			objectrot[idobject] = CreateDynamicObject(19477,ox - 0.05 * floatsin(-rz, degrees), oy - 0.05 * floatcos(-rz, degrees), oz + 2.6, 0.000, 0.000, rz - 90.0);
			SetDynamicObjectMaterialText(objectrot[idobject], 0, inputtext,  120, "Ariel", 15, 1, COLOR_WHITE, 0 , 1);
			Streamer_Update(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
		}
		case D_TUNE_LIST: {
			if(!response) return 1;
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
			switch(listitem) {
				case 0: perfomans_engine(playerid);
				case 1: perfomans_brake(playerid);
			}
		}
		case D_PERF_ENGINE: {
			if(!response) return D(playerid, D_TUNE_LIST, DSL, ""P"Perfomance Tune", ""P"1."W" Улучшение двигателя\n"P"2."W" Улучшение тормозов", "Далее", "Закрыть");
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
			if(VehicleInfo[GetPlayerVehicleID(playerid)][vPEngine][listitem]) {
				ErrorMessage(playerid, "Данная деталь уже установлена");
				perfomans_engine(playerid);
				return 1 ;
			}
			SetPVarInt(playerid, "performance_list", listitem);

			new price[5],seller[5];

			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				seller[listitem] = floatround(engine_name_price[listitem]/100*vip_status[PI[playerid][pVips]][vip_perfonans]);
				price[listitem] = (engine_name_price[listitem]-seller[listitem]);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					seller[listitem] = floatround(engine_name_price[listitem]/100*BonusInfo[act_perfomance]);
					price[listitem] = (engine_name_price[listitem]-seller[listitem]);
				}
				else if(BonusInfo[act_select] == 2) {
					seller[listitem] = floatround(engine_name_price[listitem]/100*BonusInfo[act_perfomance]);
					price[listitem] = (engine_name_price[listitem]-seller[listitem]);
				}
			    else price[listitem] = engine_name_price[listitem];
			}

			new string[144];
			format(string, sizeof(string), "\n\n"W"Вы действительно желаете установить "P"%s"W"?\nСтоимость "ORANGE"$%d\n\n", engine_name[listitem], price[listitem]);
			D(playerid, D_PERF_ENGINE_2, DIALOG_STYLE_MSGBOX, ""P"Установка детали",string, "Купить", "Назад");
		}
		case D_PERF_ENGINE_2: {
			if(!response) {
				DeletePVar(playerid, "performance_list");
				perfomans_engine(playerid);
				return 1 ;
			}
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
			new list_item = GetPVarInt(playerid, "performance_list");
			DeletePVar(playerid, "performance_list");

			new price[5],seller[5];
			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				seller[list_item] = floatround(engine_name_price[list_item]/100*vip_status[PI[playerid][pVips]][vip_perfonans]);
				price[list_item] = (engine_name_price[list_item]-seller[list_item]);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					seller[list_item] = floatround(engine_name_price[list_item]/100*BonusInfo[act_perfomance]);
					price[list_item] = (engine_name_price[list_item]-seller[list_item]);
				}
				else if(BonusInfo[act_select] == 2) {
					seller[list_item] = floatround(engine_name_price[list_item]/100*BonusInfo[act_perfomance]);
					price[list_item] = (engine_name_price[list_item]-seller[list_item]);
				}
			    else price[list_item] = engine_name_price[list_item];
			}

			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetPlayerMoneyEx(playerid) < price[list_item]) {
				ErrorMessage(playerid, "У Вас недостаточно средств");
				perfomans_engine(playerid);
				return 1 ;
			}
			new b_price = floatround(engine_name_price[list_item]/10);
			if(gBusiness[81][bizzProduct]-70 > 0) {
				gBusiness[81][bizzProduct] -= 70;
				bizz_pay(81,b_price);
			}
			GiveMoney(playerid, -price[list_item],"Покупка тюнинга (Perfomance)");
			VehicleInfo[vehicleid][vEngineBoost] += engine_name_boost[list_item];
			SendOk(playerid, "Поздравляем с покупкой улучшения. Для переключения стиля езды в режим спорт, используйте: "W"E (/style)");
			VehicleInfo[vehicleid][vPEngine][list_item] = 1;
			perfomans_engine(playerid);
			new car = GetNearestCar(playerid);
			save_perf(playerid,car);
			//if(VehicleInfo[vehicleid][vEngineBoost] == 4) perf_engine_object(vehicleid);
		}
		case D_PERF_BRAKE: {
			if(!response) return D(playerid, D_TUNE_LIST, DSL, ""P"Perfomance Tune", ""P"1."W" Улучшение двигателя\n"P"2."W" Улучшение тормозов", "Далее", "Закрыть");
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
			if(VehicleInfo[GetPlayerVehicleID(playerid)][vPBrake][listitem]) {
				ErrorMessage(playerid, "Данная деталь уже установлена");
				perfomans_brake(playerid);
				return 1 ;
			}
			SetPVarInt(playerid, "performance_list", listitem);

			new price[5],seller[5];

			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				seller[listitem] = floatround(brake_name_price[listitem]/100*vip_status[PI[playerid][pVips]][vip_perfonans]);
				price[listitem] = (brake_name_price[listitem]-seller[listitem]);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					seller[listitem] = floatround(brake_name_price[listitem]/100*BonusInfo[act_perfomance]);
					price[listitem] = (brake_name_price[listitem]-seller[listitem]);
				}
				else if(BonusInfo[act_select] == 2) {
					seller[listitem] = floatround(brake_name_price[listitem]/100*BonusInfo[act_perfomance]);
					price[listitem] = (brake_name_price[listitem]-seller[listitem]);
				}
			    else price[listitem] = brake_name_price[listitem];
			}

			new string[144];
			format(string, sizeof(string), ""W"\n\nВы действительно желаете установить "P"%s"W"?\nСтоимость "ORANGE"$%d", brake_name[listitem],price[listitem]);
			D(playerid,D_PERF_BRAKE_2, DSM, ""P"Установка детали", string, "Купить", "Назад");
		}
		case D_PERF_BRAKE_2: {
			if(!response) {
				DeletePVar(playerid, "performance_list");
				perfomans_brake(playerid);
				return 1 ;
			}
			if(GetPlayerVehicleID(playerid) != house_car[playerid][0] && GetPlayerVehicleID(playerid) != house_car[playerid][1]) return 1;
			if(!IsACarNumber(GetVehicleModel(GetPlayerVehicleID(playerid)))) return 1;
			new list_item = GetPVarInt (playerid, "performance_list");
			DeletePVar(playerid, "performance_list");
			new vehicleid = GetPlayerVehicleID(playerid);

			new price[5],seller[5];

			if(PI[playerid][pVips] == VIP_PLATINA || PI[playerid][pVips] == VIP_ECSCLUSIVE) {
				seller[list_item] = floatround(brake_name_price[list_item]/100*vip_status[PI[playerid][pVips]][vip_perfonans]);
				price[list_item] = (brake_name_price[list_item]-seller[list_item]);
			}
			else {
				if(PI[playerid][pLevel] <= BonusInfo[act_level] && BonusInfo[act_select] == 1) {
					seller[list_item] = floatround(brake_name_price[list_item]/100*BonusInfo[act_perfomance]);
					price[list_item] = (brake_name_price[list_item]-seller[list_item]);
				}
				else if(BonusInfo[act_select] == 2) {
					seller[list_item] = floatround(brake_name_price[list_item]/100*BonusInfo[act_perfomance]);
					price[list_item] = (brake_name_price[list_item]-seller[list_item]);
				}
			    else price[list_item] = brake_name_price[list_item];
			}

			if(GetPlayerMoneyEx(playerid) < price[list_item]) {
				ErrorMessage(playerid, "У Вас недостаточно средств");
				perfomans_brake(playerid);
				return 1 ;
			}
			new b_price = floatround(brake_name_price[list_item]/20);
			if(gBusiness[81][bizzProduct]-80 > 0) {
				gBusiness[81][bizzProduct] -= 80;
				bizz_pay(81,b_price);
			}
			GiveMoney(playerid, -price[list_item],"Покупка тюнинга (Perfomance)");
			VehicleInfo[vehicleid][vBrakeBoost] += brake_name_boost[list_item];
			SendOk(playerid, "Поздравляем с покупкой улучшения. Для переключения стиля езды в режим спорт, используйте: "W"E (/style)");
			VehicleInfo[vehicleid][vPBrake][list_item] = 1;
			perfomans_brake(playerid);
			new car = GetNearestCar(playerid);
			save_perf(playerid,car);
		}
		case D_FIND: {
			if(!response) return 1;
			new frac;
			switch(PI[playerid][pRank]) {
				case MINISTRE_NEWS: {
					switch(listitem) {
						case 0: frac = fLSNEWS;
						case 1: frac = fSFNEWS;
						case 2: frac = fLVNEWS;
					}
				}
				case MINISTRE_ARMY: {
					switch(listitem) {
						case 0: frac = fARMYSF;
						case 1: frac = fARMYLV;
					}
				}
				case MINISTRE_PD: {
					switch(listitem) {
						case 0: frac = fLSPD;
						case 1: frac = fSFPD;
						case 2: frac = fLVPD;
						case 3: frac = fFBI;
					}
				}
				case MINISTRE_MEDICS: {
					switch(listitem) {
						case 0: frac = fMEDICLS;
						case 1: frac = fMEDICSF;
						case 2: frac = fMEDICLV;
					}
				}
				default: return 1;
			}
			new ids = 0;
			new str[128];
			string_2048[0] = EOS;
			strcat(str,"ID\tРанг\tТелефон\tВыговоры\tИмя"W"\n\n");
			strcat(string_2048,str);
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[i][pMember] != frac)continue;
				if(PI[i][pRank] < 1 || PI[i][pMember] < 1) continue;
				if(PI[i][pAdmin]) continue;
				format(str, sizeof(str), "%d\t%d\t%d\t\t%d/3\t\t%s %s %s\n",i,PI[i][pRank],PI[i][pPhone],PI[i][pfWarn],player_name[i],(start_work[i]) ? ("[На работе]") : ("[Не на работе]"),(TI[i][tAFK] > 3) ? (""P"[AFK]"W""):(""));
				strcat(string_2048,str);
				ids++;
			}
			D(playerid, DIALOG_NONE, DSM, ""P"Члены организации онлайн", string_2048, "Закрыть", "");
			new strr[128];
			format(strr,sizeof(strr),"Всего игроков в организации: "ORANGE"%d",ids);
			SendOk(playerid,strr);
		}
		case D_SHOWALL_2: {
			if(!response) return 1;
			new frac;
			switch(PI[playerid][pRank]) {
				case MINISTRE_NEWS: {
					switch(listitem) {
						case 0: frac = fLSNEWS;
						case 1: frac = fSFNEWS;
						case 2: frac = fLVNEWS;
					}
				}
				case MINISTRE_ARMY: {
					switch(listitem) {
						case 0: frac = fARMYSF;
						case 1: frac = fARMYLV;
					}
				}
				case MINISTRE_PD: {
					switch(listitem) {
						case 0: frac = fLSPD;
						case 1: frac = fSFPD;
						case 2: frac = fLVPD;
						case 3: frac = fFBI;
					}
				}
				case MINISTRE_MEDICS: {
					switch(listitem) {
						case 0: frac = fMEDICLS;
						case 1: frac = fMEDICSF;
						case 2: frac = fMEDICLV;
					}
				}
				default: return 1;
			}
			SALLROWS[playerid] = 0;
			new query[200];
			format(query,sizeof(query),"SELECT `Name`,`pRank` FROM `accounts` WHERE `pMember` = '%i' ORDER BY `pRank` LIMIT 0, 20", frac);
			mysql_pquery(connects, query, "showall_callback", "i", playerid);
		}
		case D_GANG_PAY: {
			if(!response) return DeletePVar(playerid, "prem_gang_money");
			new money = GetPVarInt(playerid, "prem_gang_money");
			DeletePVar(playerid, "prem_gang_money");

			new count = 0 ;
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[i][pMember] != PI[playerid][pMember] || playerid == i) continue;
				count ++;
			}
			if(PI[playerid][pCash] < count*money) return ErrorMessage(playerid, "У Вас недостаточно средств");
			GiveMoney(playerid, -count*money,"выдача премии банде");
			foreach(new i:Player) {
				if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
				if(PI[i][pMember] != PI[playerid][pMember] || playerid == i) continue;
				GiveMoney(i, money,"получение премии в банде");

				new string[128];
				format(string, sizeof(string), ""W"%s "G"выдал Вам премию в размере "ORANGE"$%d", player_name[playerid], money);
				SendOk(i,string);
			}
			SendOk(playerid, "Премиальные успешно выданы членам Вашей банды");
		}
		case D_AUTONEWS: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_BUY, DSL, ""P"Объявление | Купить", ""P"1."W" Дом\n"P"2."W" Бизнес\n"P"3."W" Отель\n"P"4."W" Аэропорт\n"P"5."W" Автомобиль\n"P"6."W" Мотоцикл\n"P"7."W" Сим-Карту", "Выбрать", "Отмена");
				case 1: D(playerid, D_AUTONEWS_SELL, DSL, ""P"Объявление | Продать", ""P"1."W" Дом\n"P"2."W" Бизнес\n"P"3."W" Отель\n"P"4."W" Аэропорт\n"P"5."W" А/М\n"P"6."W" М/Ц\n"P"7."W" Сим-Карту", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_CHANGE, DSL, ""P"Объявление | Обменять", ""P"1."W" Дом\n"P"2."W" Бизнес\n"P"3."W" Отель\n"P"4."W" Аэропорт\n"P"5."W" А/М\n"P"6."W" М/Ц\n"P"7."W" Сим-Карту", "Выбрать", "Отмена");
				case 3: D(playerid, D_AUTONEWS_SERVICES, DSL, ""P"Объявление | Услуги", ""P"1."W" Объявить о собеседовании", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_SERVICES: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_SERVICES_2, DSL, ""P"Объявление | Услуги | Собеседования", ""P"1."W" Русская Мафия\n"P"2."W" Японская мафия\n"P"3."W" Итальянская мафия\n"P"4."W" The Ballas\n"P"5."W" The Vagos\n"P"6."W" The Grove\n"P"7."W" The Aztec\n"P"8."W" The Rifa\n"P"9."W" Таксопарк\n"P"10."W" Транспортная компания", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_SERVICES_2: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			switch(listitem) {
				case 0: format(gAdvert[slot][adText],100,"Проходит собеседование в \"Русское посольство\". Подробности по телефону");
				case 1: format(gAdvert[slot][adText],100,"Идет набор официантов в \"Японский ресторан\". Подробности по телефону");
				case 2: format(gAdvert[slot][adText],100,"Итальянская сувенирная лавка ищет сотрудников. Подробности по телефону");
				case 3: format(gAdvert[slot][adText],100,"Проходит набор в баскетбольную команду \"Ballas\". Желающим прибыть на площадку");
				case 4: format(gAdvert[slot][adText],100,"Проходит набор в баскетбольную команду \"Vagos\". Желающим прибыть на площадку");
				case 5: format(gAdvert[slot][adText],100,"Проходит набор в баскетбольную команду \"Grove\". Желающим прибыть на площадку");
				case 6: format(gAdvert[slot][adText],100,"Проходит набор в баскетбольную команду \"Aztec\". Желающим прибыть на площадку");
				case 7: format(gAdvert[slot][adText],100,"Проходит набор в баскетбольную команду \"Rifa\". Желающим прибыть на площадку");
				case 8: format(gAdvert[slot][adText],100,"Проходит собеседование в такси. Подробности по телефону");
				case 9: format(gAdvert[slot][adText],100,"Проходит собеседование в транспортную компанию. Подробности по телефону");
			}
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_BUY: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_BUY_HOUSE, DSL, ""P"Объявление | Купить | Дом", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Cредний\n"P"4."W" Элитный\n"P"5."W" Особняк", "Выбрать", "Отмена");
				case 1: D(playerid, D_AUTONEWS_BUY_BIZZ, DSL, ""P"Объявление | Купить | Бизнес", ""P"1."W" Пропустить\n"P"2. "W"Закусочная\n"P"3. "W"24/7\n"P"4. "W"Бар\n"P"5. "W"Клуб\n"P"6. "W"Магазин одежды\n"P"7. "W"АММО\n"P"8. "W"АЗС\n"P"9. "W"Автосалон\n"P"10. "W"Рыболовный бизнес\n"P"11. "W"Компьютерный клуб\n"P"12. "W"Таксопарк\n"P"13. "W"Риэлторское агенство\n"P"14. "W"Спортзал\n"P"15. "W"Транспортная компания\n"P"16. "W"Банк\n"P"17. "W"Рекламное агенство\n"P"18. "W"Магазин Аксессуаров\n"P"19. "W"Perfomance Tune", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_BUY_HOTEL, DSI, ""P"Объявление | Купить | Отель", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести отель:\n\n", "Ввод", "Отмена");
				case 3: D(playerid, D_AUTONEWS_BUY_AIRPORT, DSI, ""P"Объявление | Купить | Аэропорт", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести аэропорт:\n\n", "Ввод", "Отмена");
				case 4: D(playerid, D_AUTONEWS_BUY_CAR, DSL, ""P"Объявление | Купить | Автомобиль", ""P"1."W" Без тюнинга\n"P"2."W" FT\n"P"3."W" PT\n"P"4."W" FT and PT", "Выбрать", "Отмена");
				case 5: D(playerid, D_AUTONEWS_BUY_MOTO, DSL, ""P"Объявление | Купить | Мотоцикл", ""P"1."W" Пропустить\n"P"2."W" Bike\n"P"3."W" BMX\n"P"4."W" Faggio\n"P"5."W" FCR-900\n"P"6."W" Freeway\n"P"7."W" Mountain-Bike\n"P"8."W" NRG-500\n"P"9."W" PCJ-600\n"P"10."W" Quad\n"P"11."W" Sanchez\n"P"12."W" Wayfarer", "Выбрать", "Отмена");
				case 6: D(playerid, D_AUTONEWS_BUY_SIM, DSL, ""P"Объявление | Купить | Сим-Карту", ""P"1."W" Без формата\n"P"2."W" Указать формат", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_SELL: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_SELL_HOUSE, DSL, ""P"Объявление | Продать | Дом", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Cредний\n"P"4."W" Элитный\n"P"5."W" Особняк", "Выбрать", "Отмена");
				case 1: D(playerid, D_AUTONEWS_SELL_BIZZ, DSL, ""P"Объявление | Продать | Бизнес", ""P"1."W" Пропустить\n"P"2. "W"Закусочная\n"P"3. "W"24/7\n"P"4. "W"Бар\n"P"5. "W"Клуб\n"P"6. "W"Магазин одежды\n"P"7. "W"АММО\n"P"8. "W"АЗС\n"P"9. "W"Автосалон\n"P"10. "W"Рыболовный бизнес\n"P"11. "W"Компьютерный клуб\n"P"12. "W"Таксопарк\n"P"13. "W"Риэлторское агенство\n"P"14. "W"Спортзал\n"P"15. "W"Транспортная компания\n"P"16. "W"Банк\n"P"17. "W"Рекламное агенство\n"P"18. "W"Магазин Аксессуаров\n"P"19. "W"Perfomance Tune", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_SELL_HOTEL, DSL, ""P"Объявление | Продать | Отель", "\n\n"W"Введите стоимость, за которую Вы хотите продать отель:\n\n", "Ввод", "Отмена");
				case 3: D(playerid, D_AUTONEWS_SELL_AIRPORT, DSL, ""P"Объявление | Продать | Аэропорт", "\n\n"W"Введите стоимость, за которую Вы хотите продать аэропорт:\n\n", "Ввод", "Отмена");
				case 4: D(playerid, D_AUTONEWS_SELL_CAR, DSL, ""P"Объявление | Продать | Автомобиль", ""P"1."W" Без тюнинга\n"P"2."W" FT\n"P"3."W" PT\n"P"4."W" FT and PT", "Выбрать", "Отмена");
				case 5: D(playerid, D_AUTONEWS_SELL_MOTO, DSL, ""P"Объявление | Продать | Мотоцикл", ""P"1."W" Пропустить\n"P"2."W" Bike\n"P"3."W" BMX\n"P"4."W" Faggio\n"P"5."W" FCR-900\n"P"6."W" Freeway\n"P"7."W" Mountain-Bike\n"P"8."W" NRG-500\n"P"9."W" PCJ-600\n"P"10."W" Quad\n"P"11."W" Sanchez\n"P"12."W" Wayfarer", "Выбрать", "Отмена");
				case 6: D(playerid, D_AUTONEWS_SELL_SIM, DSL, ""P"Объявление | Продать | Сим-Карту", ""P"1."W" Без формата\n"P"2."W" Указать формат", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_CHANGE: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_CHANGE_HOUSE, DSL, ""P"Объявление | Обменять | Дом", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Cредний\n"P"4."W" Элитный\n"P"5."W" Особняк", "Выбрать", "Отмена");
				case 1: D(playerid, D_AUTONEWS_CHANGE_BIZZ, DSL, ""P"Объявление | Обменять | Бизнес", ""P"1."W" Пропустить\n"P"2. "W"Закусочная\n"P"3. "W"24/7\n"P"4. "W"Бар\n"P"5. "W"Клуб\n"P"6. "W"Магазин одежды\n"P"7. "W"АММО\n"P"8. "W"АЗС\n"P"9. "W"Автосалон\n"P"10. "W"Рыболовный бизнес\n"P"11. "W"Компьютерный клуб\n"P"12. "W"Таксопарк\n"P"13. "W"Риэлторское агенство\n"P"14. "W"Спортзал\n"P"15. "W"Транспортная компания\n"P"16. "W"Банк\n"P"17. "W"Рекламное агенство\n"P"18. "W"Магазин Аксессуаров\n"P"19. "W"Perfomance Tune", "Выбрать", "Отмена");
				case 2: {
					if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
					new slot = -1;
					for(new i;i<MAX_ADVERT_COUNT;i++) {
						if(!gAdvert[i][adBusy]) {slot = i; break;}
					}
					if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					gAdvertCount ++;
					GiveMoney(playerid,-1000,"подача объявления");

					format(gAdvert[slot][adText],100,"Обменяю отель",strval(inputtext));
					auto_news(slot,playerid);
				}
				case 3: {
					if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
					new slot = -1;
					for(new i;i<MAX_ADVERT_COUNT;i++) {
						if(!gAdvert[i][adBusy]) {slot = i; break;}
					}
					if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					gAdvertCount ++;
					GiveMoney(playerid,-1000,"подача объявления");

					format(gAdvert[slot][adText],100,"Обменяю аэропорт",strval(inputtext));
					auto_news(slot,playerid);
				}
				case 4: D(playerid, D_AUTONEWS_CHANGE_CAR, DSL, ""P"Объявление | Обменять | Автомобиль", ""P"1."W" Без тюнинга\n"P"2."W" FT\n"P"3."W" PT\n"P"4."W" FT and PT", "Выбрать", "Отмена");
				case 5: D(playerid, D_AUTONEWS_CHANGE_MOTO, DSL, ""P"Объявление | Обменять | Мотоцикл", ""P"1."W" Пропустить\n"P"2."W" Bike\n"P"3."W" BMX\n"P"4."W" Faggio\n"P"5."W" FCR-900\n"P"6."W" Freeway\n"P"7."W" Mountain-Bike\n"P"8."W" NRG-500\n"P"9."W" PCJ-600\n"P"10."W" Quad\n"P"11."W" Sanchez\n"P"12."W" Wayfarer", "Выбрать", "Отмена");
				case 6: D(playerid, D_AUTONEWS_CHANGE_SIM, DSL, ""P"Объявление | Обменять | Сим-Карту", ""P"1."W" Без формата\n"P"2."W" Указать формат", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_BUY_HOUSE: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_house_class", listitem);
			D(playerid, D_AUTONEWS_BUY_HOUSE_2, DSL, ""P"Объявление | Купить | Дом", ""P"1."W" г. Лос Сантос\n"P"2."W" г. Сан Фиерро\n"P"3."W" г. Лас Вентурас\n"P"4."W" Гетто\n"P"5."W" Паломино-Крик\n"P"6."W" Диллимор\n"P"7."W" Блуберри\n"P"8."W" Монтгомери\n"P"9."W" Форт Карсон\n"P"10."W" Лас-Паясадас\n"P"11."W" Энджел-Пайн\n"P"12."W" Бэйсайд\n"P"13."W" Лас-Барранкас\n"P"14."W" Валле-Окультадо\n"P"15."W" Эль-Квебрадос", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_BUY_HOUSE_2: {
			if(!response) return DeletePVar(playerid, "auto_house_class");
			SetPVarInt(playerid, "auto_house_city", listitem);
			D(playerid, D_AUTONEWS_BUY_HOUSE_3, DSI, ""P"Объявление | Купить | Дом", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести дом:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_HOUSE_3: {
			if(!response) return DeletePVar(playerid, "auto_house_city");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_HOUSE_3, DSI, ""P"Объявление | Купить | Дом", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести дом:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new house_class[5][13] = {"no","эконом","средний","элитный","особняк"};
			new house_city[15][17] = {"г. Лос Сантос","г. Сан Фиерро","г. Лас Вентурас","опасном районе","Паломино-Крик","Диллимор","Блуберри","Монтгомери","Форт Карсон","Лас-Паясадас","Энджел-Пайн","Бэйсайд","Лас-Барранкас","Валле-Окультадо","Эль-Квебрадос"};

			if(!GetPVarInt(playerid, "auto_house_class")) {
 				format(gAdvert[slot][adText],100,"Куплю дом в %s. Цена: $%d",house_city[GetPVarInt(playerid, "auto_house_city")],strval(inputtext));
			}
			else format(gAdvert[slot][adText],100,"Куплю дом класса \"%s\" в %s. Цена: $%d",house_class[GetPVarInt(playerid, "auto_house_class")],house_city[GetPVarInt(playerid, "auto_house_city")],strval(inputtext));
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_house_city");
			DeletePVar(playerid, "auto_house_class");
		}
		case D_AUTONEWS_SELL_HOUSE: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_house_class", listitem);
			D(playerid, D_AUTONEWS_SELL_HOUSE_2, DSL, ""P"Объявление | Продать | Дом", ""P"1."W" г. Лос Сантос\n"P"2."W" г. Сан Фиерро\n"P"3."W" г. Лас Вентурас\n"P"4."W" Гетто\n"P"5."W" Паломино-Крик\n"P"6."W" Диллимор\n"P"7."W" Блуберри\n"P"8."W" Монтгомери\n"P"9."W" Форт Карсон\n"P"10."W" Лас-Паясадас\n"P"11."W" Энджел-Пайн\n"P"12."W" Бэйсайд\n"P"13."W" Лас-Барранкас\n"P"14."W" Валле-Окультадо\n"P"15."W" Эль-Квебрадос", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_SELL_HOUSE_2: {
			if(!response) return DeletePVar(playerid, "auto_house_class");
			SetPVarInt(playerid, "auto_house_city", listitem);
			D(playerid, D_AUTONEWS_SELL_HOUSE_3, DSI, ""P"Объявление | Продать | Дом", "\n\n"W"Введите стоимость, за которую Вы хотите продать дом:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_HOUSE_3: {
			if(!response) return DeletePVar(playerid, "auto_house_city");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_HOUSE_3, DSI, ""P"Объявление | Продать | Дом", "\n\n"W"Введите стоимость, за которую Вы хотите продать дом:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new house_class[5][13] = {"no","эконом","средний","элитный","особняк"};
			new house_city[15][17] = {"г. Лос Сантос","г. Сан Фиерро","г. Лас Вентурас","опасном районе","Паломино-Крик","Диллимор","Блуберри","Монтгомери","Форт Карсон","Лас-Паясадас","Энджел-Пайн","Бэйсайд","Лас-Барранкас","Валле-Окультадо","Эль-Квебрадос"};

			if(!GetPVarInt(playerid, "auto_house_class")) {
 				format(gAdvert[slot][adText],100,"Продам дом в %s. Цена: $%d",house_city[GetPVarInt(playerid, "auto_house_city")],strval(inputtext));
			}
			else format(gAdvert[slot][adText],100,"Продам дом класса \"%s\" в %s. Цена: $%d",house_class[GetPVarInt(playerid, "auto_house_class")],house_city[GetPVarInt(playerid, "auto_house_city")],strval(inputtext));
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_house_city");
			DeletePVar(playerid, "auto_house_class");
		}
		case D_AUTONEWS_CHANGE_HOUSE: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_house_class", listitem);
			D(playerid, D_AUTONEWS_CHANGE_HOUSE_2, DSL, ""P"Объявление | Обменять | Дом", ""P"1."W" г. Лос Сантос\n"P"2."W" г. Сан Фиерро\n"P"3."W" г. Лас Вентурас\n"P"4."W" Гетто\n"P"5."W" Паломино-Крик\n"P"6."W" Диллимор\n"P"7."W" Блуберри\n"P"8."W" Монтгомери\n"P"9."W" Форт Карсон\n"P"10."W" Лас-Паясадас\n"P"11."W" Энджел-Пайн\n"P"12."W" Бэйсайд\n"P"13."W" Лас-Барранкас\n"P"14."W" Валле-Окультадо\n"P"15."W" Эль-Квебрадос", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_CHANGE_HOUSE_2: {
			if(!response) return DeletePVar(playerid, "auto_house_city");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new house_class[5][13] = {"no","эконом","средний","элитный","особняк"};
			new house_city[15][17] = {"г. Лос Сантос","г. Сан Фиерро","г. Лас Вентурас","опасном районе","Паломино-Крик","Диллимор","Блуберри","Монтгомери","Форт Карсон","Лас-Паясадас","Энджел-Пайн","Бэйсайд","Лас-Барранкас","Валле-Окультадо","Эль-Квебрадос"};

			if(!GetPVarInt(playerid, "auto_house_class")) {
 				format(gAdvert[slot][adText],100,"Обменяю дом в %s",house_city[GetPVarInt(playerid, "auto_house_city")]);
			}
			else format(gAdvert[slot][adText],100,"Обменяю дом класса %s в %s",house_class[GetPVarInt(playerid, "auto_house_class")],house_city[GetPVarInt(playerid, "auto_house_city")]);
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_house_city");
			DeletePVar(playerid, "auto_house_class");
		}
		case D_AUTONEWS_BUY_BIZZ: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_bizz_type", listitem);
			D(playerid, D_AUTONEWS_BUY_BIZZ_2, DSI, ""P"Объявление | Купить | Бизнес", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести бизнес:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_BIZZ_2: {
			if(!response) return DeletePVar(playerid, "auto_bizz_type");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_BIZZ_2, DSI, ""P"Объявление | Купить | Бизнес", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести бизнес:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new bizz_type[19][28] = {"no","Закусочная","24/7","Бар","Клуб","Магазин одежды","АММО","АЗС","Автосалон","Рыболовный бизнес","Компьютерный клуб","Таксопарк","Риэлторское агенство","Спортзал","Транспортная компания","Банк","Рекламное агенство","Магазин Аксессуаров","Perfomance Tune"};
			if(!GetPVarInt(playerid, "auto_bizz_type")) format(gAdvert[slot][adText],100,"Куплю прибыльное предприятие. Цена: $%d",strval(inputtext));
			else format(gAdvert[slot][adText],100,"Куплю предприятие \"%s\". Цена: $%d",bizz_type[GetPVarInt(playerid, "auto_bizz_type")],strval(inputtext));
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_bizz_type");
		}
		case D_AUTONEWS_SELL_BIZZ: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_bizz_type", listitem);
			D(playerid, D_AUTONEWS_SELL_BIZZ_2, DSI, ""P"Объявление | Продать | Бизнес", "\n\n"W"Введите стоимость, за которую Вы хотите продать бизнес:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_BIZZ_2: {
			if(!response) return DeletePVar(playerid, "auto_bizz_type");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_BIZZ_2, DSI, ""P"Объявление | Продать | Бизнес", "\n\n"W"Введите стоимость, за которую Вы хотите продать бизнес:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new bizz_type[19][28] = {"no","Закусочная","24/7","Бар","Клуб","Магазин одежды","АММО","АЗС","Автосалон","Рыболовный бизнес","Компьютерный клуб","Таксопарк","Риэлторское агенство","Спортзал","Транспортная компания","Банк","Рекламное агенство","Магазин Аксессуаров","Perfomance Tune"};
			if(!GetPVarInt(playerid, "auto_bizz_type")) format(gAdvert[slot][adText],100,"Продам предприятие. Цена: $%d",strval(inputtext));
			else format(gAdvert[slot][adText],100,"Продам предприятие \"%s\". Цена: $%d",bizz_type[GetPVarInt(playerid, "auto_bizz_type")],strval(inputtext));
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_bizz_type");
		}
		case D_AUTONEWS_CHANGE_BIZZ: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new bizz_type[19][28] = {"no","Закусочная","24/7","Бар","Клуб","Магазин одежды","АММО","АЗС","Автосалон","Рыболовный бизнес","Компьютерный клуб","Таксопарк","Риэлторское агенство","Спортзал","Транспортная компания","Банк","Рекламное агенство","Магазин Аксессуаров","Perfomance Tune"};
			if(!listitem) format(gAdvert[slot][adText],100,"Обменяю предприятие");
			else format(gAdvert[slot][adText],100,"Обменяю предприятие \"%s\"",bizz_type[listitem]);
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_bizz_type");
		}
		case D_AUTONEWS_BUY_HOTEL: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_HOTEL, DSI, ""P"Объявление | Купить | Отель", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести отель:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			format(gAdvert[slot][adText],100,"Куплю отель. Цена: $%d",strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_BUY_AIRPORT: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_AIRPORT, DSI, ""P"Объявление | Купить | Аэропорт", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести аэропорт:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			format(gAdvert[slot][adText],100,"Куплю аэропорт. Цена: $%d",strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_SELL_HOTEL: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_HOTEL, DSI, ""P"Объявление | Продать | Отель", "\n\n"W"Введите стоимость, за которую Вы хотите продать отель:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			format(gAdvert[slot][adText],100,"Продам отель. Цена: $%d",strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_SELL_AIRPORT: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_AIRPORT, DSI, ""P"Объявление | Продать | Аэропорт", "\n\n"W"Введите стоимость, за которую Вы хотите продать аэропорт:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			format(gAdvert[slot][adText],100,"Продам аэропорт. Цена: $%d",strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_BUY_CAR: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_tune", listitem);
			D(playerid, D_AUTONEWS_BUY_CAR_2, DSL, ""P"Объявление | Купить | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Средний\n"P"4."W" Спорт", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_BUY_CAR_2: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_class", listitem);
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_BUY_CAR_4, DSI, ""P"Объявление | Купить | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести автомобиль:\n\n", "Ввод", "Отмена");
				case 1: D(playerid, D_AUTONEWS_BUY_CAR_3, DSL, ""P"Объявление | Купить | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Bravura\n"P"3."W" Broadway\n"P"4."W" Clover\n"P"5."W" Emperor\n"P"6."W" Glendale\n"P"7."W" Greenwood\n"P"8."W" Hermes\n"P"9."W" Hustler\n"P"10."W" Majestic\n"P"11."W" Manana\n"P"12."W" Oceanic\n"P"13."W" Perenniel\n"P"14."W" Picador\n"P"15."W" Regina\n"P"16."W" Sadler\n"P"17."W" Stallion\n"P"18."W" Tampa\n"P"19."W" Tornado\n"P"20."W" Voodoo", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_BUY_CAR_3, DSL, ""P"Объявление | Купить | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Admiral\n"P"3."W" Blist-Compact\n"P"4."W" Cadrona\n"P"5."W" Club\n"P"6."W" Feltzer\n"P"7."W" Huntley\n"P"8."W" Landstalker\n"P"9."W" Mesa\n"P"10."W" Phoenix\n"P"11."W" Premier\n"P"12."W" Rancher\n"P"13."W" Remington\n"P"14."W" Sabre\n"P"15."W" Savanna\n"P"16."W" Sentinel\n"P"17."W" Slamvan\n"P"18."W" Solair\n"P"19."W" Stafford\n"P"20."W" Tahoma\n"P"20."W" Uranus\n"P"20."W" Washington\n"P"20."W" Windsor\n"P"20."W" Yosemite", "Выбрать", "Отмена");
				case 3: D(playerid, D_AUTONEWS_BUY_CAR_3, DSL, ""P"Объявление | Купить | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Alpha\n"P"3."W" Banshee\n"P"4."W" Buffalo\n"P"5."W" Bullet\n"P"6."W" Cheetah\n"P"7."W" Comet\n"P"8."W" Elegy\n"P"9."W" Euros\n"P"10."W" Hotknife\n"P"11."W" Hotring\n"P"12."W" Infernus\n"P"13."W" Jester\n"P"14."W" SandKing\n"P"15."W" Sultan\n"P"16."W" Super GT\n"P"17."W" Turismo\n"P"18."W" ZR-350", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_BUY_CAR_3: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_class_2", listitem);
			D(playerid, D_AUTONEWS_BUY_CAR_4, DSI, ""P"Объявление | Купить | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести автомобиль:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_CAR_4: {
			if(!response) return DeletePVar(playerid, "auto_bizz_type");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_CAR_4, DSI, ""P"Объявление | Купить | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести автомобиль:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new car_tune[4][8] = {"No Tune","FT","PT","FT/PT"};
			new car_class[4][8] = {"no","эконом","средний","спорт"};
			if(!GetPVarInt(playerid, "auto_car_class")) {
				format(gAdvert[slot][adText],100,"Куплю автомобиль [%s]. Цена: $%d",car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
			}
			else if(!GetPVarInt(playerid, "auto_car_class_2")) {
				format(gAdvert[slot][adText],100,"Куплю автомобиль [%s] класса \"%s\". Цена: $%d",car_tune[GetPVarInt(playerid, "auto_car_tune")],car_class[GetPVarInt(playerid, "auto_car_class")],strval(inputtext));
			}
			else {
				switch(GetPVarInt(playerid, "auto_car_class")) {
					case 1: {
						new car_name[20][13] = {"No","Bravura","Broadway","Clover","Emperor","Glendale","Greenwood","Hermes","Hustler","Majestic","Manana","Oceanic","Perenniel","Picador","Regina","Sadler","Stallion","Tampa","Tornado","Voodoo"};
						format(gAdvert[slot][adText],100,"Куплю автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
					case 2: {
						new car_name[24][15] = {"No","Admiral","Blist-Compact","Cadrona","Club","Feltzer","Huntley","Landstalker","Mesa","Phoenix","Premier","Rancher","Remington","Sabre","Savanna","Sentinel","Slamvan","Solair","Stafford","Tahoma","Uranus","Washington","Windsor","Yosemite"};
						format(gAdvert[slot][adText],100,"Куплю автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
					case 3: {
						new car_name[18][13] = {"No","Alpha","Banshee","Buffalo","Bullet","Cheetah","Comet","Elegy","Euros","Hotknife","Hotring","Infernus","Jester","SandKing","Sultan","Super GT","Turismo","ZR-350"};
						format(gAdvert[slot][adText],100,"Куплю автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
				}
			}
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_SELL_CAR: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_tune", listitem);
			D(playerid, D_AUTONEWS_SELL_CAR_2, DSL, ""P"Объявление | Продать | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Средний\n"P"4."W" Спорт", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_SELL_CAR_2: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_class", listitem);
			switch(listitem) {
				case 0: D(playerid, D_AUTONEWS_SELL_CAR_4, DSI, ""P"Объявление | Продать | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите продать автомобиль:\n\n", "Ввод", "Отмена");
				case 1: D(playerid, D_AUTONEWS_SELL_CAR_3, DSL, ""P"Объявление | Продать | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Bravura\n"P"3."W" Broadway\n"P"4."W" Clover\n"P"5."W" Emperor\n"P"6."W" Glendale\n"P"7."W" Greenwood\n"P"8."W" Hermes\n"P"9."W" Hustler\n"P"10."W" Majestic\n"P"11."W" Manana\n"P"12."W" Oceanic\n"P"13."W" Perenniel\n"P"14."W" Picador\n"P"15."W" Regina\n"P"16."W" Sadler\n"P"17."W" Stallion\n"P"18."W" Tampa\n"P"19."W" Tornado\n"P"20."W" Voodoo", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_SELL_CAR_3, DSL, ""P"Объявление | Продать | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Admiral\n"P"3."W" Blist-Compact\n"P"4."W" Cadrona\n"P"5."W" Club\n"P"6."W" Feltzer\n"P"7."W" Huntley\n"P"8."W" Landstalker\n"P"9."W" Mesa\n"P"10."W" Phoenix\n"P"11."W" Premier\n"P"12."W" Rancher\n"P"13."W" Remington\n"P"14."W" Sabre\n"P"15."W" Savanna\n"P"16."W" Sentinel\n"P"17."W" Slamvan\n"P"18."W" Solair\n"P"19."W" Stafford\n"P"20."W" Tahoma\n"P"20."W" Uranus\n"P"20."W" Washington\n"P"20."W" Windsor\n"P"20."W" Yosemite", "Выбрать", "Отмена");
				case 3: D(playerid, D_AUTONEWS_SELL_CAR_3, DSL, ""P"Объявление | Продать | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Alpha\n"P"3."W" Banshee\n"P"4."W" Buffalo\n"P"5."W" Bullet\n"P"6."W" Cheetah\n"P"7."W" Comet\n"P"8."W" Elegy\n"P"9."W" Euros\n"P"10."W" Hotknife\n"P"11."W" Hotring\n"P"12."W" Infernus\n"P"13."W" Jester\n"P"14."W" SandKing\n"P"15."W" Sultan\n"P"16."W" Super GT\n"P"17."W" Turismo\n"P"18."W" ZR-350", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_SELL_CAR_3: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_class_2", listitem);
			D(playerid, D_AUTONEWS_SELL_CAR_4, DSI, ""P"Объявление | Продать | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите продать автомобиль:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_CAR_4: {
			if(!response) return DeletePVar(playerid, "auto_car_class_2");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_CAR_4, DSI, ""P"Объявление | Продать | Автомобиль", "\n\n"W"Введите стоимость, за которую Вы хотите продать автомобиль:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new car_tune[4][8] = {"No Tune","FT","PT","FT/PT"};
			new car_class[4][8] = {"no","эконом","средний","спорт"};
			if(!GetPVarInt(playerid, "auto_car_class")) {
				format(gAdvert[slot][adText],100,"Продам автомобиль [%s]. Цена: $%d",car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
			}
			else if(!GetPVarInt(playerid, "auto_car_class_2")) {
				format(gAdvert[slot][adText],100,"Продам автомобиль [%s] класса \"%s\". Цена: $%d",car_tune[GetPVarInt(playerid, "auto_car_tune")],car_class[GetPVarInt(playerid, "auto_car_class")],strval(inputtext));
			}
			else {
				switch(GetPVarInt(playerid, "auto_car_class")) {
					case 1: {
						new car_name[20][13] = {"No","Bravura","Broadway","Clover","Emperor","Glendale","Greenwood","Hermes","Hustler","Majestic","Manana","Oceanic","Perenniel","Picador","Regina","Sadler","Stallion","Tampa","Tornado","Voodoo"};
						format(gAdvert[slot][adText],100,"Продам автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
					case 2: {
						new car_name[24][15] = {"No","Admiral","Blist-Compact","Cadrona","Club","Feltzer","Huntley","Landstalker","Mesa","Phoenix","Premier","Rancher","Remington","Sabre","Savanna","Sentinel","Slamvan","Solair","Stafford","Tahoma","Uranus","Washington","Windsor","Yosemite"};
						format(gAdvert[slot][adText],100,"Продам автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
					case 3: {
						new car_name[18][13] = {"No","Alpha","Banshee","Buffalo","Bullet","Cheetah","Comet","Elegy","Euros","Hotknife","Hotring","Infernus","Jester","SandKing","Sultan","Super GT","Turismo","ZR-350"};
						format(gAdvert[slot][adText],100,"Продам автомобиль марки \"%s\" [%s]. Цена: $%d",car_name[GetPVarInt(playerid, "auto_car_class_2")],car_tune[GetPVarInt(playerid, "auto_car_tune")],strval(inputtext));
					}
				}
			}
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_CHANGE_CAR: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_tune", listitem);
			D(playerid, D_AUTONEWS_CHANGE_CAR_2, DSL, ""P"Объявление | Обменять | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Эконом\n"P"3."W" Средний\n"P"4."W" Спорт", "Выбрать", "Отмена");
		}
		case D_AUTONEWS_CHANGE_CAR_2: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_car_class", listitem);
			switch(listitem) {
				case 0: {
					if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
					new slot = -1;
					for(new i;i<MAX_ADVERT_COUNT;i++) {
						if(!gAdvert[i][adBusy]) {slot = i; break;}
					}
					if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
					gAdvertCount ++;
					GiveMoney(playerid,-1000,"подача объявления");

					new car_tune[4][8] = {"No Tune","FT","PT","FT/PT"};
					format(gAdvert[slot][adText],100,"Обменяю автомобиль [%s]",car_tune[GetPVarInt(playerid, "auto_car_tune")]);
					auto_news(slot,playerid);
				}
				case 1: D(playerid, D_AUTONEWS_CHANGE_CAR_3, DSL, ""P"Объявление | Обменять | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Bravura\n"P"3."W" Broadway\n"P"4."W" Clover\n"P"5."W" Emperor\n"P"6."W" Glendale\n"P"7."W" Greenwood\n"P"8."W" Hermes\n"P"9."W" Hustler\n"P"10."W" Majestic\n"P"11."W" Manana\n"P"12."W" Oceanic\n"P"13."W" Perenniel\n"P"14."W" Picador\n"P"15."W" Regina\n"P"16."W" Sadler\n"P"17."W" Stallion\n"P"18."W" Tampa\n"P"19."W" Tornado\n"P"20."W" Voodoo", "Выбрать", "Отмена");
				case 2: D(playerid, D_AUTONEWS_CHANGE_CAR_3, DSL, ""P"Объявление | Обменять | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Admiral\n"P"3."W" Blist-Compact\n"P"4."W" Cadrona\n"P"5."W" Club\n"P"6."W" Feltzer\n"P"7."W" Huntley\n"P"8."W" Landstalker\n"P"9."W" Mesa\n"P"10."W" Phoenix\n"P"11."W" Premier\n"P"12."W" Rancher\n"P"13."W" Remington\n"P"14."W" Sabre\n"P"15."W" Savanna\n"P"16."W" Sentinel\n"P"17."W" Slamvan\n"P"18."W" Solair\n"P"19."W" Stafford\n"P"20."W" Tahoma\n"P"20."W" Uranus\n"P"20."W" Washington\n"P"20."W" Windsor\n"P"20."W" Yosemite", "Выбрать", "Отмена");
				case 3: D(playerid, D_AUTONEWS_CHANGE_CAR_3, DSL, ""P"Объявление | Обменять | Автомобиль", ""P"1."W" Пропустить\n"P"2."W" Alpha\n"P"3."W" Banshee\n"P"4."W" Buffalo\n"P"5."W" Bullet\n"P"6."W" Cheetah\n"P"7."W" Comet\n"P"8."W" Elegy\n"P"9."W" Euros\n"P"10."W" Hotknife\n"P"11."W" Hotring\n"P"12."W" Infernus\n"P"13."W" Jester\n"P"14."W" SandKing\n"P"15."W" Sultan\n"P"16."W" Super GT\n"P"17."W" Turismo\n"P"18."W" ZR-350", "Выбрать", "Отмена");
			}
		}
		case D_AUTONEWS_CHANGE_CAR_3: {
			if(!response) return DeletePVar(playerid, "auto_car_class_2");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new car_tune[4][8] = {"No Tune","FT","PT","FT/PT"};
			new car_class[4][8] = {"no","эконом","средний","спорт"};
			if(!GetPVarInt(playerid, "auto_car_class")) {
				format(gAdvert[slot][adText],100,"Обменяю автомобиль [%s]",car_tune[GetPVarInt(playerid, "auto_car_tune")]);
			}
			else if(!GetPVarInt(playerid, "auto_car_class_2")) {
				format(gAdvert[slot][adText],100,"Обменяю автомобиль [%s] класса \"%s\"",car_tune[GetPVarInt(playerid, "auto_car_tune")],car_class[GetPVarInt(playerid, "auto_car_class")]);
			}
			else {
				switch(GetPVarInt(playerid, "auto_car_class")) {
					case 1: {
						new car_name[20][13] = {"No","Bravura","Broadway","Clover","Emperor","Glendale","Greenwood","Hermes","Hustler","Majestic","Manana","Oceanic","Perenniel","Picador","Regina","Sadler","Stallion","Tampa","Tornado","Voodoo"};
						format(gAdvert[slot][adText],100,"Обменяю автомобиль марки \"%s\" [%s]",car_name[listitem],car_tune[GetPVarInt(playerid, "auto_car_tune")]);
					}
					case 2: {
						new car_name[24][15] = {"No","Admiral","Blist-Compact","Cadrona","Club","Feltzer","Huntley","Landstalker","Mesa","Phoenix","Premier","Rancher","Remington","Sabre","Savanna","Sentinel","Slamvan","Solair","Stafford","Tahoma","Uranus","Washington","Windsor","Yosemite"};
						format(gAdvert[slot][adText],100,"Обменяю автомобиль марки \"%s\" [%s]",car_name[listitem],car_tune[GetPVarInt(playerid, "auto_car_tune")]);
					}
					case 3: {
						new car_name[18][13] = {"No","Alpha","Banshee","Buffalo","Bullet","Cheetah","Comet","Elegy","Euros","Hotknife","Hotring","Infernus","Jester","SandKing","Sultan","Super GT","Turismo","ZR-350"};
						format(gAdvert[slot][adText],100,"Обменяю автомобиль марки \"%s\" [%s]",car_name[listitem],car_tune[GetPVarInt(playerid, "auto_car_tune")]);
					}
				}
			}
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_BUY_SIM: {
			if(!response) return 1;
			if(listitem == 0) {
				SetPVarString(playerid, "auto_sim_format", "NONE");
				D(playerid, D_AUTONEWS_BUY_SIM_3, DSI, ""P"Объявление | Купить | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести сим-карту:\n\n", "Ввод", "Отмена");
			}
			else D(playerid, D_AUTONEWS_BUY_SIM_2, DSI, ""P"Объявление | Купить | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_SIM_2: {
			if(!response) return 1;
			if(!strlen(inputtext) || strlen(inputtext) != 6 || !CheckSim(inputtext)) return D(playerid, D_AUTONEWS_BUY_SIM, DSI, ""P"Объявление | Купить | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
			SetPVarString(playerid, "auto_sim_format", inputtext);
			D(playerid, D_AUTONEWS_BUY_SIM_3, DSI, ""P"Объявление | Купить | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести сим-карту:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_SIM_3: {
			if(!response) return DeletePVar(playerid, "auto_sim_format");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_SIM_3, DSI, ""P"Объявление | Купить | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести сим-карту:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new format_sim[7];
			GetPVarString(playerid,"auto_sim_format",format_sim,15);
			if(GetString(format_sim,"NONE")) {
				format(gAdvert[slot][adText],100,"Куплю сим-карту. Цена: $%d",strval(inputtext));
			}
			else format(gAdvert[slot][adText],100,"Куплю сим-карту формата \"%s\". Цена: $%d",format_sim,strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_SELL_SIM: {
			if(!response) return 1;
			if(listitem == 0) {
				SetPVarString(playerid, "auto_sim_format", "NONE");
				D(playerid, D_AUTONEWS_SELL_SIM_3, DSI, ""P"Объявление | Продать | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите продать сим-карту:\n\n", "Ввод", "Отмена");
			}
			else D(playerid, D_AUTONEWS_SELL_SIM_2, DSI, ""P"Объявление | Продать | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_SIM_2: {
			if(!response) return 1;
			if(!strlen(inputtext) || strlen(inputtext) != 6 || !CheckSim(inputtext)) return D(playerid, D_AUTONEWS_SELL_SIM, DSI, ""P"Объявление | Продать | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
			SetPVarString(playerid, "auto_sim_format", inputtext);
			D(playerid, D_AUTONEWS_SELL_SIM_3, DSI, ""P"Объявление | Продать | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите продать сим-карту:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_SIM_3: {
			if(!response) return DeletePVar(playerid, "auto_sim_format");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_SIM_3, DSI, ""P"Объявление | Продать | Сим-Карту", "\n\n"W"Введите стоимость, за которую Вы хотите продать сим-карту:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			new format_sim[7];
			GetPVarString(playerid,"auto_sim_format",format_sim,15);
			if(GetString(format_sim,"NONE")) {
				format(gAdvert[slot][adText],100,"Продам сим-карту. Цена: $%d",strval(inputtext));
			}
			else format(gAdvert[slot][adText],100,"Продам сим-карту формата \"%s\". Цена: $%d",format_sim,strval(inputtext));
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_CHANGE_SIM: {
			if(!response) return 1;
			if(listitem == 0) {
				if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
				if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
				new slot = -1;
				for(new i;i<MAX_ADVERT_COUNT;i++) {
					if(!gAdvert[i][adBusy]) {slot = i; break;}
				}
				if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
				gAdvertCount ++;
				GiveMoney(playerid,-1000,"подача объявления");
				format(gAdvert[slot][adText],100,"Обменяю сим-карту");
				auto_news(slot,playerid);
			}
			else D(playerid, D_AUTONEWS_CHANGE_SIM_2, DSI, ""P"Объявление | Обменять | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_CHANGE_SIM_2: {
			if(!response) return 1;
			if(!strlen(inputtext) || strlen(inputtext) != 6 || !CheckSim(inputtext)) return D(playerid, D_AUTONEWS_CHANGE_SIM_2, DSI, ""P"Объявление | Обменять | Сим-Карту", "\n\n"W"Введите формат номера сим-карты:\n"NO"*"G" Примечание: формат сим-карты: ABCDEF (6 букв)\n\n", "Ввод", "Отмена");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			format(gAdvert[slot][adText],100,"Обменяю сим-карту формата %s",inputtext);
			auto_news(slot,playerid);
		}
		case D_AUTONEWS_BUY_MOTO: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_moto_class", listitem);
			D(playerid, D_AUTONEWS_BUY_MOTO_2, DSI, ""P"Объявление | Купить | Мотоцикл", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести мотоцикл:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_BUY_MOTO_2: {
			if(!response) return DeletePVar(playerid, "auto_moto_class");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_BUY_MOTO_2, DSI, ""P"Объявление | Купить | Мотоцикл", "\n\n"W"Введите стоимость, за которую Вы хотите приобрести мотоцикл:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			if(!GetPVarInt(playerid, "auto_moto_class")) {
				format(gAdvert[slot][adText],100,"Куплю мотоцикл. Цена: $%d",strval(inputtext));
			}
			else {
				new car_name[12][14] = {"No","Bike","BMX","Faggio","FCR-900","Freeway","Mountain-Bike","NRG-500","PCJ-600","Quad","Sanchez","Wayfarer"};
				format(gAdvert[slot][adText],100,"Куплю мотоцикл марки \"%s\". Цена: $%d",car_name[GetPVarInt(playerid, "auto_moto_class")],strval(inputtext));
			}
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_moto_class");
		}
		case D_AUTONEWS_SELL_MOTO: {
			if(!response) return 1;
			SetPVarInt(playerid, "auto_moto_class", listitem);
			D(playerid, D_AUTONEWS_SELL_MOTO_2, DSI, ""P"Объявление | Продать | Мотоцикл", "\n\n"W"Введите стоимость, за которую Вы хотите продать мотоцикл:\n\n", "Ввод", "Отмена");
		}
		case D_AUTONEWS_SELL_MOTO_2: {
			if(!response) return DeletePVar(playerid, "auto_moto_class");
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(strval(inputtext) < 1 || strval(inputtext) > 50000000) return D(playerid, D_AUTONEWS_SELL_MOTO_2, DSI, ""P"Объявление | Продать | Мотоцикл", "\n\n"W"Введите стоимость, за которую Вы хотите продать мотоцикл:\n"NO"*"G" От $1 и до $50.000.000\n\n", "Ввод", "Отмена");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			if(!GetPVarInt(playerid, "auto_moto_class")) {
				format(gAdvert[slot][adText],100,"Продам мотоцикл. Цена: $%d",strval(inputtext));
			}
			else {
				new car_name[12][14] = {"No","Bike","BMX","Faggio","FCR-900","Freeway","Mountain-Bike","NRG-500","PCJ-600","Quad","Sanchez","Wayfarer"};
				format(gAdvert[slot][adText],100,"Продам мотоцикл марки \"%s\". Цена: $%d",car_name[GetPVarInt(playerid, "auto_moto_class")],strval(inputtext));
			}
			auto_news(slot,playerid);
			DeletePVar(playerid, "auto_moto_class");
		}
		case D_AUTONEWS_CHANGE_MOTO: {
			if(!response) return 1;
			if(gAdvertCount >= MAX_ADVERT_COUNT) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			if(PI[playerid][pCash] < 1000) return ErrorMessage(playerid,"У Вас недостаточно денег. Для публикации объяления необходимо иметь $1000");
			new slot = -1;
			for(new i;i<MAX_ADVERT_COUNT;i++) {
				if(!gAdvert[i][adBusy]) {slot = i; break;}
			}
			if(slot == -1) return ErrorMessage(playerid,"К сожалению, очередь на объявления занята, попробуйте позже");
			gAdvertCount ++;
			GiveMoney(playerid,-1000,"подача объявления");

			if(!listitem) {
				format(gAdvert[slot][adText],100,"Обменяю мотоцикл");
			}
			else {
				new car_name[12][14] = {"No","Bike","BMX","Faggio","FCR-900","Freeway","Mountain-Bike","NRG-500","PCJ-600","Quad","Sanchez","Wayfarer"};
				format(gAdvert[slot][adText],100,"Обменяю мотоцикл марки \"%s\"",car_name[listitem]);
			}
			auto_news(slot,playerid);
		}
		case D_JOB_CLEAR: {
			if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(PI[playerid][pCash] < 500) {
				ErrorMessage(playerid, "У Вас не достаточно денег для аренды авто для продажи еды");
				RemovePlayerFromVehicleAC(playerid);
				return 0;
			}
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
			GiveMoney(playerid,-500,"аренда уборщик улиц");
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
		    D(playerid, D_JOB_CLEAR_2, DSL,""P"Выбор маршрута",""P"1."W" Лос-Сантос №1\n"P"2."W" Лос-Сантос №2\n"P"3."W" Лос-Сантос №3", "Выбрать", "Отмена");
		}
		case D_JOB_CLEAR_2: {
		    if(!response) return D(playerid, D_JOB_CLEAR_2, DSL,""P"Выбор маршрута",""P"1."W" Лос-Сантос №1\n"P"2."W" Лос-Сантос №2\n"P"3."W" Лос-Сантос №3", "Выбрать", "Отмена");
		    SetPVarInt(playerid,"clear_id",GetPlayerVehicleID(playerid));
		    switch(listitem) {
			    case 0: SendOk(playerid,"Вы выбрали маршрут: Лос-Сантос №1. Начинайте уборку");
				case 1: SendOk(playerid,"Вы выбрали маршрут: Лос-Сантос №2. Начинайте уборку");
				case 2: SendOk(playerid,"Вы выбрали маршрут: Лос-Сантос №3. Начинайте уборку");
			}
			SetPVarInt(playerid,"route_job_cleaner",listitem);
			SetNextJobClearCP(playerid,GetPVarInt(playerid, "route_job_cleaner"));
		}
		case D_JOB_CLEAR_3: {
		    if(response) return D(playerid, D_JOB_CLEAR_2, DSL,""P"Выбор маршрута",""P"1."W" Лос-Сантос №1\n"P"2."W" Лос-Сантос №2\n"P"3."W" Лос-Сантос №3" , "Выбрать", "Отмена");
		    SetVehicleToRespawn(GetPVarInt(playerid, "clear_id"));
		}
		case D_JOB_GAZON: {
		   	if(!response) return RemovePlayerFromVehicleAC(playerid);
			if(PI[playerid][pCash] < 500) {
				ErrorMessage(playerid, "У Вас не достаточно денег для аренды авто для продажи еды");
				RemovePlayerFromVehicleAC(playerid);
				return 0;
			}
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return true;
			GiveMoney(playerid,-500,"аренда газонокосильщик");
			TI[playerid][tArendaCar] = GetPlayerVehicleID(playerid);
			VehicleInfo[TI[playerid][tArendaCar]][vPlayer] = playerid;
		    SetPVarInt(playerid, "start_job_mower",1);
		    SendOk(playerid,"Вы начали рабочий день. Выберите зону для работы");
		    callcmd::zonestatus(playerid);
		   	SetPVarInt(playerid, "veh_id_cleaner",GetPlayerVehicleID(playerid));
		}
		case D_JOB_GAZON_2: {
		    if(!response) return 1;
		    switch(listitem) {
		        case 0: {
		            SendOk(playerid, "Вы выбрали пляж Verona Beach.");
		            EnableGPSForPlayer(playerid,484.773346, -1783.324585, 5.595574);
		        }
		        case 1: {
		            SendOk(playerid, "Вы выбрали Правительство.");
		            EnableGPSForPlayer(playerid,1140.843628, -2078.608398, 68.357811);
		        }
		        case 2: {
		            SendOk(playerid, "Вы выбрали больницу Лос-Сантос.");
		            EnableGPSForPlayer(playerid,1220.061279, -1295.611450, 12.820630);
		        }
		        case 3: {
		            SendOk(playerid, "Вы выбрали Глен-парк №1.");
		            EnableGPSForPlayer(playerid,1867.358276, -1246.167114, 13.221643);
		        }
		        case 4: {
		            SendOk(playerid, "Вы выбрали Глен-парк №2.");
		            EnableGPSForPlayer(playerid, 2052.105957, -1248.333984, 23.101965);
		        }
			}
		}
		case D_PROMO_ACTIVATION:
        {
            if(!response) return callcmd::menu(playerid, "");
            if(!strlen(inputtext)) return D(playerid, D_PROMO_ACTIVATION, DSI, !""P"Промокод", !""W"Чтобы использовать "P"промокод"W" введите его в поле ниже:\n\n"G"Чтобы посмотреть сколько осталось до получения бонуса\nИспользуйте команду: /promolist", "Принять", "Закрыть");

			new query[88];
            mysql_format(connects, query, sizeof(query), "SELECT * FROM server_promocode WHERE s_promo='%e' LIMIT 1", inputtext);
            mysql_tquery(connects, query, "activation_promocode", "ds", playerid, inputtext);
        }
		case D_CREATE_PROMO:
        {
            if(!response) return 1;

            if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
                return D(playerid, D_CREATE_PROMO, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Вам необходимо придумать промокод\nДлина промокода должна быть от 4 до 32 символов, состоящая из цифр и букв латинского алфавита\n\nВведите промокод в строчку ниже:", !"Далее", !"Закрыть");

            SetPVarString(playerid, "PromoCode", inputtext);
            show_create_promocode(playerid);
        }

		//
		case D_CREATE_PROMO_SETTINGS:
        {
            if(!response) return callcmd::bpromo(playerid);

            switch(listitem)
            {
                case 0:
                {
                    if(!promo_params[listitem]) promo_params[listitem] = 1;
                    else promo_params[listitem] = 0;

                    show_create_promocode(playerid);
                }
                case 1: D(playerid, D_CREATE_PROMO_SETTINGS_2, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Введите количество часов для получения бонусов:", !"Далее", !"Назад");
                case 2: D(playerid, D_CREATE_PROMO_SETTINGS_3, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Введите количество активаций:", !"Далее", !"Назад");
                case 3: show_create_promocode(playerid);
                case 4: D(playerid, D_CREATE_PROMO_SETTINGS_4, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Введите количество игровой валюты:", !"Далее", !"Назад");
                case 5: D(playerid, D_CREATE_PROMO_SETTINGS_5, DIALOG_STYLE_INPUT, !""P"Создание промокода", !""W"Введите количество EXP:", !"Далее", !"Назад");
                case 6..15:
                {
                    if(!promo_params[listitem - 1]) promo_params[listitem - 1] = 1;
                    else promo_params[listitem - 1] = 0;

                    show_create_promocode(playerid);
                }
                case 16:
                {
                    new promoname[16];
                    GetPVarString(playerid, "PromoCode", promoname, sizeof(promoname));

                    new sql_string[128];
                    mysql_format(connects, sql_string, sizeof(sql_string), "SELECT * FROM server_promocode WHERE s_promo='%e' LIMIT 1", promoname);
                    mysql_tquery(connects, sql_string, "create_server_promocode", "ds", playerid, promoname);
                }
            }
        }
		case D_CREATE_PROMO_SETTINGS_2:
        {
            if(!response) return show_create_promocode(playerid);

            promo_params[1] = strval(inputtext);
            show_create_promocode(playerid);
        }
		case D_CREATE_PROMO_SETTINGS_3:
        {
            if(!response) return show_create_promocode(playerid);

            promo_params[2] = strval(inputtext);
            show_create_promocode(playerid);
        }
        case D_CREATE_PROMO_SETTINGS_4:
        {
            if(!response) return show_create_promocode(playerid);

            promo_params[3] = strval(inputtext);
            show_create_promocode(playerid);
        }
        case D_CREATE_PROMO_SETTINGS_5:
        {
            if(!response) return show_create_promocode(playerid);

            promo_params[4] = strval(inputtext);
            show_create_promocode(playerid);
        }
		//
		case D_DONATE_BANK_2: {
			if(!response) return 1;
			SetPVarInt(playerid, "donate_bank", listitem);
			D(playerid,D_DONATE_BANK_3,DSL, ""P"Банк", ""P"1."W" Банковские услуги\n"P"2."W" Недвижимость", "Выбрать", "Назад");
		}
		case D_DONATE_BANK_3: {
			if(!response) return 1;
			switch(listitem) {
				case 0: D(playerid,D_BANK,DSL, ""P"Банк", "Активные счета\nОткрыть новый счет", "Выбрать", "Назад");
				case 1: D(playerid,D_BANK_OPLATA,DSL,""P"Оплата недвижимости",""P"1."W" Дом\n"P"2."W" Бизнес\n"P"3."W" Отель\n"P"4."W" Аэропорт","Выбрать","Отмена");
			}
		}
		case D_NEWS_LIFT: {
			if(!response) return 1;

			switch(listitem) {
				case 0: {
					TI[playerid][tTPpick] = true;
					new otelid = GetPVarInt(playerid,"selectedhotel");
					updaterooms(playerid,gHotels[otelid][hotelVW][listitem+1]);
					SetPlayerPosAC(playerid, 1570.6003,-1333.5015,16.4844, 0, 0);
					SetPlayerFacingAngle(playerid,321.2440);
					SetCameraBehindPlayer(playerid);
				}
				case 1: {
					TI[playerid][tTPpick] = true;
					SetPlayerPosAC(playerid, 1547.8295,-1365.0126,326.2109, 0, 0);
					SetPlayerFacingAngle(playerid,145.4391);
					SetCameraBehindPlayer(playerid);
				}
			}
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerInterior(playerid, 0);
			return 1;
		}
		case D_BOOMBOX_MENU: {
			if(!response) return 1;
			if(!GetPVarType(playerid, "PlacedBB")) return 1;
			switch(listitem) 
			{
				case 0: SetPVarString(playerid, "BBStation", "http://online-radiomelodia.tavrmedia.ua/RadioMelodia.m3u");
				case 1: SetPVarString(playerid, "BBStation", "http://air2.radiorecord.ru:805/rr_320");
				case 2: SetPVarString(playerid, "BBStation", "http://nashe.streamr.ru/rock-128.mp3?728a");
				case 3: SetPVarString(playerid, "BBStation", "http://emgregion.hostingradio.ru:8064/moscow.retrofm.mp3?3ec7");
				case 4: SetPVarString(playerid, "BBStation", "http://emgregion.hostingradio.ru:8064/moscow.europaplus.mp3?dc6ac484");
				case 5: SetPVarString(playerid, "BBStation", "https://rusradio.hostingradio.ru/rusradio96.aacp?1164");
				case 6: SetPVarString(playerid, "BBStation", "http://chanson.hostingradio.ru:8041/chanson256.mp3");
				case 7: return D(playerid,D_BOOMBOX_INPUT_LINK,DSI, ""P"Введите ссылку", ""W"Вставляйте ссылку на радио / песню", "Включить", "Отменить");
				case 8: {
					if(GetPVarType(playerid, "BBArea"))
					{
						MeAction(playerid, "выключил бумбокс");
						foreach(new i: Player) if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) StopStream(i);
						DeletePVar(playerid, "BBStation");
					}
					return SendOk(playerid, "Вы выключили бумбокс");
				}
			}
			new audio_stream_link[100];
			GetPVarString(playerid, "BBStation", audio_stream_link, sizeof(audio_stream_link));
			foreach(new i: Player)
			{
				if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea"))) PlayStream(i, audio_stream_link, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 20.0, 1);
			}
			return 1;
		}
		case D_BOOMBOX_INPUT_LINK: {
			if(!response) return 1;
			if(strfind(inputtext, "http", true) == -1) return D(playerid,D_BOOMBOX_INPUT_LINK,DSI, "{FFFF00}Введите ссылку", "{FFFFFF}Вставляйте ссылку на радио / песню", "Включить", "Отменить");
			if(GetPVarType(playerid, "PlacedBB"))
			{
				foreach(new i: Player)
				{
					if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
					{
						PlayStream(i, (inputtext), GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 20.0, 1);
					}
				}
				SetPVarString(playerid, "BBStation", (inputtext));
			}
			return SendOk(playerid, "Песня установлена");
		}
		case D_GREENZONE: {
		    if(!response) return true;
			switch(listitem) {
			    case 0: D(playerid, D_GREENZONE_ADD, DSI, ""P"Создать зеленую зону", "Введите название зоны и дистанцию через знак ','", "Далее", "Закрыть");
			    default: {
			 		SetPVarInt(playerid,"ZONEID",listitem);
				  	D(playerid,D_GREENZONE_EDIT,DSL,""P"Редактирование зоны","{59DE00}1."W" Изменить название\n{59DE00}2."W" Изменить положение\n{59DE00}3."W" Изменить дистанцию", "Далее", "Закрыть");
				}
			}
		}
  		case D_GREENZONE_ADD: {
		    if(!response) return true;
		    new price,name[32];
  			if(sscanf(inputtext,"p<,>s[32]i",name,price)) return D(playerid, D_GREENZONE_ADD, DSI, ""P"Создать зеленую зону", "Введите название зоны и дистанцию через знак ','", "Далее", "Закрыть");
		    TOTALZONE++;
		    GetPlayerPos(playerid, GREENZONE[TOTALZONE][grX],GREENZONE[TOTALZONE][grY],GREENZONE[TOTALZONE][grZ]);
		    GREENZONE[TOTALZONE][grVirt] = GetPlayerVirtualWorld(playerid);
		    new query[180];
		    mysql_format(connects, query, sizeof(query), "INSERT INTO `"TABLE_GREENZONE"` (`grx`,`gry`,`grz`,`grd`,`grname`,`grvirt`) VALUES ('%f','%f','%f','%i','%s','%i')",GREENZONE[TOTALZONE][grX],GREENZONE[TOTALZONE][grY],GREENZONE[TOTALZONE][grZ],price,name,GREENZONE[TOTALZONE][grVirt]);
    		mysql_tquery(connects, query, "", "");
 			strmid(GREENZONE[TOTALZONE][grName],name, 0, strlen(name), 32);
 			GREENZONE[TOTALZONE][grid] = TOTALZONE;
 			GREENZONE[TOTALZONE][grD] = float(price);

 			static const f_str[] = "Зеленая зона под номером "ORANGE"%i"G" создана";
			new string[sizeof(f_str) +1 + (-2 + 3)];

 			format(string,sizeof(string),f_str,TOTALZONE);
			SendOk(playerid,string);
			return 1;
		}
		case D_GREENZONE_EDIT: {
		    if(!response) return true;
		    switch(listitem) {
		        case 0: D(playerid, D_GREENZONE_EDIT_NAME, DSI, ""P"Изменить название", "Введите название зоны:", "Далее", "Закрыть");
		        case 1: {
		            GetPlayerPos(playerid, GREENZONE[GetPVarInt(playerid,"ZONEID")][grX],GREENZONE[GetPVarInt(playerid,"ZONEID")][grY],GREENZONE[GetPVarInt(playerid,"ZONEID")][grZ]);
		    		GREENZONE[GetPVarInt(playerid,"ZONEID")][grVirt] = GetPlayerVirtualWorld(playerid);
		    		new query[128];
		    		mysql_format(connects, query, sizeof(query), "UPDATE `"TABLE_GREENZONE"` SET `grx` = '%f', `gry` = '%f', `grz` = '%f', `grvirt` = '%i'\
	 				WHERE `id` = '%i'",GREENZONE[GetPVarInt(playerid,"ZONEID")][grX],GREENZONE[GetPVarInt(playerid,"ZONEID")][grY],GREENZONE[GetPVarInt(playerid,"ZONEID")][grZ],
	 				GREENZONE[GetPVarInt(playerid,"ZONEID")][grVirt],GREENZONE[GetPVarInt(playerid,"ZONEID")][grid]);
     				mysql_tquery(connects, query, "", "");
					SendOk(playerid,"Позиция изменена");
				}
				case 2: D(playerid, D_GREENZONE_EDIT_DIST, DSI, ""P"Изменить дистанцию", "Введите дистанцию для зоны:", "Далее", "Закрыть");
			}
			return true;
		}
		case D_GREENZONE_EDIT_NAME: {
		    if(!response) return true;
		    strmid(GREENZONE[GetPVarInt(playerid,"ZONEID")][grName],inputtext, 0, strlen(inputtext), 32);
		    new query[128];
		    mysql_format(connects, query, sizeof(query), "UPDATE `"TABLE_GREENZONE"` SET `grname` = '%s' WHERE `id` = '%i'",
			GREENZONE[GetPVarInt(playerid,"ZONEID")][grName],GREENZONE[GetPVarInt(playerid,"ZONEID")][grid]);
   			mysql_tquery(connects, query, "", "");
			SendOk(playerid,"Название изменено");
		}
		case D_GREENZONE_EDIT_DIST: {
		    if(!response) return true;
		    GREENZONE[GetPVarInt(playerid,"ZONEID")][grD] = float(strval(inputtext));
		    new query[128];
		    mysql_format(connects, query, sizeof(query), "UPDATE `"TABLE_GREENZONE"` SET `grd` = '%f' WHERE `id` = '%i'",
			GREENZONE[GetPVarInt(playerid,"ZONEID")][grD],GREENZONE[GetPVarInt(playerid,"ZONEID")][grid]);
   			mysql_tquery(connects, query, "", "");
			SendOk(playerid,"Дистанция изменена");
		}
	}
	while(strfind(inputtext, "%s",true)!=-1) {
		strdel(inputtext,strfind(inputtext, "%s",true),strfind(inputtext, "%s",true)+2);
	}
	return true;
}
