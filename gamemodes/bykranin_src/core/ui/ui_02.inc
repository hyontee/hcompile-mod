//>> Файл: bykranin_src/core/ui/ui_02.inc  (499 строк)
//>> Тема: интерфейс: текстдравы, панели, уведомления, меню
//>> Внутри: ToggleLock, load_tuning, ShowTuneShowPlayerDialog, SetLaunchControl, DelLaunchControl, LoadTun, CreateAvtosalonTextDraws
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ToggleLock(playerid,vehicleid)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        return 0;
    }

    if(GetVehicleParam(vehicleid, V_LOCK))
    {
        new fmt_str[128];
        format(fmt_str, sizeof fmt_str, "%s открыл(а) траснпорт", GetPlayerNameEx(playerid));
		SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

        SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_OFF);
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы открыли транспорт", " ");
        PlayAudioStreamURL(playerid, "vehicle_sound_door.mp3");

        DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
        DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
        DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
    }
    else
    {
        new fmt_str[128];
    	format(fmt_str, sizeof fmt_str, "%s закрыл(а) траснпорт", GetPlayerNameEx(playerid));
		SendMessageInLocal(playerid, fmt_str, 0xDD90FFFF, 25.0);

        SetVehicleParam(vehicleid, V_LOCK, VEHICLE_PARAM_ON);
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы закрыли транспорт", " ");
        PlayAudioStreamURL(playerid, "vehicle_sound_door.mp3");

        SetPVarInt(playerid, PVAR_CARLOCK_EXIT_TICK, GetTickCount());
        DeletePVar(playerid, PVAR_CARLOCK_HINT_SHOWN);
        DeletePVar(playerid, PVAR_CARLOCK_HINT_VEHICLE);
        DeletePVar(playerid, PVAR_CARLOCK_HINT_TICK);
    }

    return 1;
}
stock load_tuning()
{
	new text_string [ 56 ] ;
	for(new i = 0; i < 4; i ++)
	{
		CreateDynamicPickup(19135, 23, pos_tuning [ i ] [ 0 ], pos_tuning [ i ] [ 1 ], pos_tuning [ i ] [ 2 ], -1, -1 ) ;
		format(text_string, sizeof(text_string), ""SERVER"Посигнальте для продолжения", i + 1);
		CreateDynamic3DTextLabel(text_string, -1, pos_tuning [ i ] [ 0 ], pos_tuning [ i ] [ 1 ], pos_tuning [ i ] [ 2 ], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1);
	}
}

stock ShowTuneShowPlayerDialog(playerid)
{
	Dialog(playerid, DIALOG_TEX_WERTON_FIX, DIALOG_STYLE_LIST, ""SERVER"Автосервис", "1. Перекрасить элементы\n2. Установить нитро\n3. Установить цвет фар\n4. Установить диски\n5. Установка лаунч-контроля", "Выбрать", "Выход");
}

stock SetLaunchControl(playerid)
{
    new fmt_text[256],
    idx = GetPVarInt(playerid, "ownablecar_id");
	launch[playerid] = 1;
	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET launch='1'  WHERE id='%d' LIMIT 1", idx);
	mysql_query(mysql, fmt_text, false);
}

stock DelLaunchControl(playerid)
{
    new fmt_text[256],
    idx = GetPVarInt(playerid, "ownablecar_id");
    launch[playerid] = 0;
    mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET launch='0'  WHERE id='%d' LIMIT 1", idx);
	mysql_query(mysql, fmt_text, false);
}

stock LoadTun(playerid)
{
	//by Dergen and Tima
	new idx = GetPVarInt(playerid, "ownablecar_id"),
	Cache: result,
	query[100];

	mysql_format(mysql, query, sizeof query, "SELECT nitro_level, launch, fars, diski FROM ownable_cars WHERE id='%d'", idx);
	result = mysql_query(mysql, query, true);

	if(cache_num_rows(result))
	{
		//vehidtun[playerid] = cache_get_row_int(0, 0);
		nitro[playerid] = cache_get_row_int(0, 0);
		launch[playerid] = cache_get_row_int(0, 1);
		fars[playerid] = cache_get_row_int(0, 2);
		diski[playerid] = cache_get_row_int(0, 3);
		
	}

	cache_delete(result);
	if(nitro[playerid] == 1) AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[0][0]);
	if(nitro[playerid] == 2) AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[1][0]);
	if(nitro[playerid] == 3) AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[2][0]);
	if(fars[playerid] == 0) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 255, 255, 254); //White
	if(fars[playerid] == 1) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 255, 0, 0); //Red
	if(fars[playerid] == 2) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 0, 255, 0); //Green
	if(fars[playerid] == 3) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 0, 0, 255); //Blue
	if(fars[playerid] == 4) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 255, 0, 132); // Pink
	if(fars[playerid] == 5) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 255, 191, 0); //Yellow
 	if(fars[playerid] == 6) SetVehicleLightsColors(GetPlayerOwnableCar(playerid), 255, 102, 0); //Orange
 	if(diski[playerid] == 1) AddVehicleComponent(GetPlayerOwnableCar(playerid), 1073);
 	if(diski[playerid] == 2) AddVehicleComponent(GetPlayerOwnableCar(playerid), 1074);
 	if(diski[playerid] == 3) AddVehicleComponent(GetPlayerOwnableCar(playerid), 1075);
}

stock CreateAvtosalonTextDraws(playerid)
{
	avtsln_PTDD[playerid][0] = CreatePlayerTextDraw(playerid, 321.6664, 353.8521, "Lamborghini_Aventador"); // пусто
	PlayerTextDrawLetterSize(playerid, avtsln_PTDD[playerid][0], 0.2433, 1.5533);
	PlayerTextDrawTextSize(playerid, avtsln_PTDD[playerid][0], 0.0000, 6.0000);
	PlayerTextDrawAlignment(playerid, avtsln_PTDD[playerid][0], 2);
	PlayerTextDrawColor(playerid, avtsln_PTDD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, avtsln_PTDD[playerid][0], 255);
	PlayerTextDrawFont(playerid, avtsln_PTDD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, avtsln_PTDD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, avtsln_PTDD[playerid][0], 0);

	avtsln_PTDD[playerid][1] = CreatePlayerTextDraw(playerid, 390.0000, 387.5556, "20.000.000"); // пусто
	PlayerTextDrawLetterSize(playerid, avtsln_PTDD[playerid][1], 0.1920, 1.1332);
	PlayerTextDrawTextSize(playerid, avtsln_PTDD[playerid][1], 0.0000, -6.0000);
	PlayerTextDrawAlignment(playerid, avtsln_PTDD[playerid][1], 2);
	PlayerTextDrawColor(playerid, avtsln_PTDD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, avtsln_PTDD[playerid][1], 255);
	PlayerTextDrawFont(playerid, avtsln_PTDD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, avtsln_PTDD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, avtsln_PTDD[playerid][1], 0);

	avtsln_PTDD[playerid][2] = CreatePlayerTextDraw(playerid, 609.1671, 178.5924, "300_KM/Ќ"); // пусто
	PlayerTextDrawLetterSize(playerid, avtsln_PTDD[playerid][2], 0.1429, 1.2525);
	PlayerTextDrawTextSize(playerid, avtsln_PTDD[playerid][2], 0.0000, 4.0000);
	PlayerTextDrawAlignment(playerid, avtsln_PTDD[playerid][2], 2);
	PlayerTextDrawColor(playerid, avtsln_PTDD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, avtsln_PTDD[playerid][2], 255);
	PlayerTextDrawFont(playerid, avtsln_PTDD[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, avtsln_PTDD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, avtsln_PTDD[playerid][2], 0);

	avtsln_PTDD[playerid][3] = CreatePlayerTextDraw(playerid, 608.7506, 209.7035, "11.3_C."); // пусто
	PlayerTextDrawLetterSize(playerid, avtsln_PTDD[playerid][3], 0.1429, 1.2525);
	PlayerTextDrawTextSize(playerid, avtsln_PTDD[playerid][3], 0.0000, 4.0000);
	PlayerTextDrawAlignment(playerid, avtsln_PTDD[playerid][3], 2);
	PlayerTextDrawColor(playerid, avtsln_PTDD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, avtsln_PTDD[playerid][3], 255);
	PlayerTextDrawFont(playerid, avtsln_PTDD[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, avtsln_PTDD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, avtsln_PTDD[playerid][3], 0);

	avtsln_PTDD[playerid][4] = CreatePlayerTextDraw(playerid, 609.1674, 239.2590, "53"); // пусто
	PlayerTextDrawLetterSize(playerid, avtsln_PTDD[playerid][4], 0.1429, 1.2525);
	PlayerTextDrawTextSize(playerid, avtsln_PTDD[playerid][4], 0.0000, 4.0000);
	PlayerTextDrawAlignment(playerid, avtsln_PTDD[playerid][4], 2);
	PlayerTextDrawColor(playerid, avtsln_PTDD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, avtsln_PTDD[playerid][4], 255);
	PlayerTextDrawFont(playerid, avtsln_PTDD[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, avtsln_PTDD[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, avtsln_PTDD[playerid][4], 0);
}
stock ShowHud(playerid)
{
    SendCustomRPC(playerid, 0x35);
}

stock HideHud(playerid)
{
    SendCustomRPC(playerid, 0x36);
}

CMD:unnwarn(playerid)
{
    					if(GetPlayerData(playerid, P_WARN))
						{
							if(GetPlayerDonateRub(playerid) >= 100)
							{
								SetPlayerData(playerid, P_WARN, 		0);
								SetPlayerData(playerid, P_WARN_TIME, 	0);

								UpdatePlayerDatabaseInt(playerid, "warn", 		0);
								UpdatePlayerDatabaseInt(playerid, "warn_time", 	0);

								GivePlayerDonateRub(playerid, -100, "Снятие предупреждений");

								ShowNotificationNew(playerid, 3, 4, 0, 0, "Все предупреждения успешно сняты", "");
								ShowNotificationNew(playerid, 3, 4, 0, 0, "Теперь Вы можете устроиться в организацию!", "");
							
							}
					else
							{
								new fmt_text[80];
							 	ShowNotificationNew(playerid, 2, 4, 0, 0, "Для снятия всех предупреждений необходимо иметь на счету 100 руб!", "");
							}
						}
					else ShowNotificationNew(playerid, 2, 4, 0, 0, "На Вашем аккаунте нет предупреждений!", "");
						
						return 1;

}
CMD:alllic(playerid)
{
						if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 1)
                          ShowNotificationNew(playerid, 2, 4, 0, 0, "У Вас уже есть все лицензии!", "");

						else
						{
							if(GetPlayerDonateRub(playerid) >= 150)
							{
								SetPlayerData(playerid, P_DRIVING_LIC,	2);
								SetPlayerData(playerid, P_WEAPON_LIC,	1);

								UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

								GivePlayerDonate(playerid, -150, "Покупка пакета лицензий", true);

								ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы приобрели пакет лицензий. Используйте: {FFFF00}/lic!", "");
							
							}
					else
							{
								return ShowNotificationNew(playerid, 2, 4, 0, 0, "Для покупки всех лицензий необходимо иметь на счету 150 руб!", "");
							}
						}
						return 1;
}
CMD:powerbuy(playerid)
{
    new fmt_text[400];

						format
						(
							fmt_text, sizeof fmt_text,
							"1. Сила\t\t%d%%\n"\
							"2. Colt 45\t%d%%\n"\
							"3. SD Pistol\t%d%%\n"\
							"4. Desert Eagle\t%d%%\n"\
							"5. Shotgun\t%d%%\n"\
							"6. MP5\t\t%d%%\n"\
							"7. AK47\t\t%d%%\n"\
							"8. M4\t\t%d%%\n"\
							"9. Sniper Rifle\t%d%%\n"\
							"10. Sawnoff\t%d%%\n"\
							"11. Combat SG\t%d%%\n"\
							"12. Micro Uzi\t%d%%",
							GetPlayerData(playerid, P_POWER),
							GetPlayerData(playerid, P_SKILL_COLT),
							GetPlayerData(playerid, P_SKILL_SDPISTOL),
							GetPlayerData(playerid, P_SKILL_DEAGLE),
							GetPlayerData(playerid, P_SKILL_SHOTGUN),
							GetPlayerData(playerid, P_SKILL_MP5),
							GetPlayerData(playerid, P_SKILL_AK47),
							GetPlayerData(playerid, P_SKILL_M4),
							GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE),
							GetPlayerData(playerid, P_SKILL_SAWNOFF),
							GetPlayerData(playerid, P_SKILL_COMBAT_SG),
							GetPlayerData(playerid, P_SKILL_MICRO_UZI)
						);

						Dialog(playerid, DIALOG_DONATE_SKILLS, DIALOG_STYLE_LIST, "{FFFF00}Выберите навык", fmt_text, "Выбор", "Отмена");
}
CMD:bomboxbuy(playerid)
{
	if(GetPlayerDonateRub(playerid) >= 1000)
						{
						    if(GetPlayerData(playerid, P_BOOMBOX) >= 1) return ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас уже есть бумбокс!", "");

							GivePlayerDonateRub(playerid, -1000, "покупка бумбокса");

                            ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы успешно купили бумбокс(/boombox)", "");

							SetPlayerData(playerid, P_BOOMBOX, 1);
							UpdatePlayerDatabaseInt(playerid, "boombox", 1);
						
						}
					else ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно ВС!", "");
						
	
	return 1;
						    
}
CMD:buyslot(playerid)
{
						new fmt_text[80];

						if(GetPlayerDonateRub(playerid) < 100)
						{
						    ShowNotificationNew(playerid, 2, 4, 0, 0, "Для покупки слота для транспорта необходимо иметь на счету 100 руб!", "");
						}
					else
						{
							AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
							UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

							GivePlayerDonateRub(playerid, -100, "Покупка слота для транспорта", true, true);

							format(fmt_text, sizeof fmt_text, ""SC"Вы увеличили количество слотов для транспорта. Текущее количество слотов: {ffff00}%d", GetPlayerData(playerid, P_CAR_SLOTS));

							ShowNotificationNew(playerid, 3, 4, 0, 0, fmt_text, "");
						
						}
						
						return 1;
}
CMD:buynomber(playerid)
{
						if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
						{
							if(GetPlayerOwnableCars(playerid) == 0)
								return ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас нет личного транспорта!", "");
							else
								return ShowNotificationNew(playerid, 2, 4, 0, 0, "Ваш транспорт не загружен на сервер!", "");
						}

									Dialog
					(
						playerid, DIALOG_DONATE_BUY_CAR_NUMBER, DIALOG_STYLE_INPUT,
						"{ffcd00}Введите номер для личного ТС",
						"{FFFFFF}\
						Введите номер, который\n\
						Вы хотите установить на личный транспорт\n\n\
						- Разрешено использовать только английские буквы A-Z и цифры 0-9\n\
						- Чем больше одинаковых букв/цифр встречается в номере - тем он дороже\n\
						- Номер должен быть в формате CNNNCC; Где C - буква, где N - цифра\n\n\
						{888888}Например: B713EC\
						",
						"Далее", "Отмена"
					);
				
					return 1;

}
CMD:buyphonenum(playerid)
{
						if(GetPlayerDonateRub(playerid) >= 70)
						{
							Dialog
							(
								playerid, DIALOG_DONATE_BUY_NUMBER, DIALOG_STYLE_INPUT,
								"{FFCD00}Покупка SIM-карты",
								"{FFFFFF}Введите 4-х значный номер SIM-карты, который\n"\
								"Вы хотели бы приобрести:",
								"Далее", "Отмена"
							);

							return 1;
						}
					else
						{

							ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно ВС!", "");
						}
					
						return 1;
}



CMD:vipsilv(playerid)
{
    Dialog
						(
							playerid,
							DIALOG_DONATE_VIP_HELP,
							DIALOG_STYLE_MSGBOX,
							"Информация",
							"{CD7F32}______________________ SILVER VIP ______________________\n\
							{FFFF00}1{FFFFFF} /togphone - Отключить телефон\n\
							{FFFF00}1{FFFFFF} /admins - Просмотр администраторов онлайн\n\n\
							{C0C0C0}______________________ GOLD VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} VIP чат  /v | /voff \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 2 раза уменьшить наказание в тюрьме (/unj) \n\
							{FFFF00}4{FFFFFF} +1 Слот транспорта в подарок \n\
							{FFD700}______________________ PLATINUM VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} Все возможности GOLD VIP \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 3 раза уменьшить наказание в тюрьме (/unj)\n\
							{FFFF00}4{FFFFFF} +2 Слота транспорта в подарок\n\
							{FFFF00}4{FFFFFF} /vleave - увольнение из фракции в любое время!\n\
							{FFFF00}5{FFFFFF} Каждый третий PayDay + 1 EXP и 1000Р к зарплате\n\
							Покупая платные услуги, Вы помогаете проекту в развитии",
							"Далее","Отмена");
}

CMD:vipgld(playerid)
{
    Dialog
						(
							playerid,
							DIALOG_DONATE_VIP_HELP,
							DIALOG_STYLE_MSGBOX,
							"Информация",
							"{CD7F32}______________________ SILVER VIP ______________________\n\
							{FFFF00}1{FFFFFF} /togphone - Отключить телефон\n\
							{FFFF00}1{FFFFFF} /admins - Просмотр администраторов онлайн\n\n\
							{C0C0C0}______________________ GOLD VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} VIP чат  /v | /voff \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 2 раза уменьшить наказание в тюрьме (/unj) \n\
							{FFFF00}4{FFFFFF} +1 Слот транспорта в подарок \n\
							{FFD700}______________________ PLATINUM VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} Все возможности GOLD VIP \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 3 раза уменьшить наказание в тюрьме (/unj)\n\
							{FFFF00}4{FFFFFF} +2 Слота транспорта в подарок\n\
							{FFFF00}4{FFFFFF} /vleave - увольнение из фракции в любое время!\n\
							{FFFF00}5{FFFFFF} Каждый третий PayDay + 1 EXP и 1000Р к зарплате\n\
							Покупая платные услуги, Вы помогаете проекту в развитии",
							"Далее","Отмена");
}

CMD:vippltnum(playerid)
{
    Dialog
						(
							playerid,
							DIALOG_DONATE_VIP_HELP,
							DIALOG_STYLE_MSGBOX,
							"Информация",
							"{CD7F32}______________________ SILVER VIP ______________________\n\
							{FFFF00}1{FFFFFF} /togphone - Отключить телефон\n\
							{FFFF00}1{FFFFFF} /admins - Просмотр администраторов онлайн\n\n\
							{C0C0C0}______________________ GOLD VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} VIP чат  /v | /voff \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 2 раза уменьшить наказание в тюрьме (/unj) \n\
							{FFFF00}4{FFFFFF} +1 Слот транспорта в подарок \n\
							{FFD700}______________________ PLATINUM VIP ______________________\n\
							{FFFF00}1{FFFFFF} Все возможности SILVER VIP \n\
							{FFFF00}2{FFFFFF} Все возможности GOLD VIP \n\
							{FFFF00}3{FFFFFF} Раз в сутки можно в 3 раза уменьшить наказание в тюрьме (/unj)\n\
							{FFFF00}4{FFFFFF} +2 Слота транспорта в подарок\n\
							{FFFF00}4{FFFFFF} /vleave - увольнение из фракции в любое время!\n\
							{FFFF00}5{FFFFFF} Каждый третий PayDay + 1 EXP и 1000Р к зарплате\n\
							Покупая платные услуги, Вы помогаете проекту в развитии",
							"Далее","Отмена");
}

CMD:voice(playerid)
{
    SvAttachSpeakerToStream(lstream[playerid], playerid);
    SvAttachSpeakerToStream(gstream, playerid);
    SvDetachSpeakerFromStream(lstream[playerid], playerid);
    SvDetachSpeakerFromStream(gstream, playerid);
}

CMD:el(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
     switch(Povorotnk[0][carid])
     {
      case false:
       {
          Povorotnk[0][carid] = true;
          Povor[0] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0,0.0, 0.0,100.0);
          Povor[1] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0,0.0, 0.0,100.0);
          AttachObjectToVehicle(Povor[0], carid, 0.9, 2.5, 0.1, 0.0, 0.0, 0.0);
          AttachObjectToVehicle(Povor[1], carid, 0.9, -2.7, 0.1, 0.0, 0.0, 0.0);
           }
            case true:
            {
       Povorotnk[0][carid] = false;
           DestroyObject(Povor[0]);
           DestroyObject(Povor[1]);
            }
     }
 }
}

CMD:ql(playerid, params[])
{
    new carid = GetPlayerVehicleID(playerid);
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
      {
       switch(Povorotnk[1][carid])
       {
       case false:
        {
         Povorotnk[1][carid] = true;
         Povor[2] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0,0.0, 0.0,100.0);
         Povor[3] = CreateObject(19294, 0.0, 0.0, 0.0, 0.0,0.0,  0.0,100.0);
           AttachObjectToVehicle(Povor[2], carid, -0.9, 2.5, 0.1, 0.0, 0.0, 0.0);
              AttachObjectToVehicle(Povor[3], carid, -0.9, -2.7, 0.1, 0.0, 0.0, 0.0);
          }
       case true:
        {
           Povorotnk[1][carid] = false;
         DestroyObject(Povor[2]);
         DestroyObject(Povor[3]);
   }
  }
 }
}

