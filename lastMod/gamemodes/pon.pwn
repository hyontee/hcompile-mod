CMD:donate(playerid)
{
    ShowDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
}
stock ShowDonate(playerid, money, bc)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x37);

    BS_WriteValue(bitstream, PR_INT32, money);
    BS_WriteValue(bitstream, PR_INT32, bc);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);

    return true;
}
stock UpdateDonate(playerid, money, bc)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x38);

    BS_WriteValue(bitstream, PR_INT32, money);
    BS_WriteValue(bitstream, PR_INT32, bc);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);
//UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
    return true;
}
stock show_sc(playerid, money, bc)
{
	new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
    BS_WriteValue(bitstream, PR_UINT32, 0x39);

    BS_WriteValue(bitstream, PR_INT32, money);
    BS_WriteValue(bitstream, PR_INT32, bc);

    BS_Send(bitstream, playerid);

    BS_Delete(bitstream);

    return true;
}
IPacket:0x41(playerid, BitStream:bs)
{
	    new header, rpcid, carid, carcost;

	        BS_ReadValue(bs,
	        PR_UINT8, header,
	        PR_UINT32, rpcid);
	        BS_ReadValue(bs,
	        PR_INT32, carid);
	        BS_ReadValue(bs,
	        PR_INT32, carcost);


			new marketid;
   			if(carid < 28)
      			marketid = 1;
			else if(carid < 46)
   				marketid = 3;
			else
   				marketid = 2;

			switch(carid)
			{
				case 8: BuyCarDonat(playerid, marketid, 555, carcost);
				case 56: BuyCarDonat(playerid, marketid, 400, carcost);
				case 10: BuyCarDonat(playerid, marketid, 401, carcost);
				case 53: BuyCarDonat(playerid, marketid, 402, carcost);
				case 14: BuyCarDonat(playerid, marketid, 404, carcost);
				case 60: BuyCarDonat(playerid, marketid, 405, carcost);
				case 62: BuyCarDonat(playerid, marketid, 410, carcost);
				case 69: BuyCarDonat(playerid, marketid, 411, carcost);
				case 12: BuyCarDonat(playerid, marketid, 412, carcost);
				case 70: BuyCarDonat(playerid, marketid, 415, carcost);
				case 27: BuyCarDonat(playerid, marketid, 419, carcost);
				case 26: BuyCarDonat(playerid, marketid, 421, carcost);
				case 30: BuyCarDonat(playerid, marketid, 426, carcost);
				case 65: BuyCarDonat(playerid, marketid, 429, carcost);
				case 38: BuyCarDonat(playerid, marketid, 436, carcost);
				case 16: BuyCarDonat(playerid, marketid, 439, carcost);
				case 15: BuyCarDonat(playerid, marketid, 439, carcost);
				case 45: BuyCarDonat(playerid, marketid, 442, carcost);
				case 36: BuyCarDonat(playerid, marketid, 445, carcost);
				case 66: BuyCarDonat(playerid, marketid, 451, carcost);
				case 18: BuyCarDonat(playerid, marketid, 458, carcost);
				case 73: BuyCarDonat(playerid, marketid, 461, carcost);
				case 71: BuyCarDonat(playerid, marketid, 462, carcost);
				case 74: BuyCarDonat(playerid, marketid, 463, carcost);
				case 59: BuyCarDonat(playerid, marketid, 466, carcost);
				case 33: BuyCarDonat(playerid, marketid, 467, carcost);
				case 72: BuyCarDonat(playerid, marketid, 468, carcost);
				case 51: BuyCarDonat(playerid, marketid, 475, carcost);
				case 11: BuyCarDonat(playerid, marketid, 479, carcost);
				case 48: BuyCarDonat(playerid, marketid, 480, carcost);
				case 46: BuyCarDonat(playerid, marketid, 489, carcost);
				case 61: BuyCarDonat(playerid, marketid, 490, carcost);
				case 17: BuyCarDonat(playerid, marketid, 547, carcost);
				case 64: BuyCarDonat(playerid, marketid, 494, carcost);
				case 50: BuyCarDonat(playerid, marketid, 495, carcost);
				case 13: BuyCarDonat(playerid, marketid, 496, carcost);
				case 55: BuyCarDonat(playerid, marketid, 502, carcost);
				case 52: BuyCarDonat(playerid, marketid, 503, carcost);
				case 54: BuyCarDonat(playerid, marketid, 505, carcost);
				case 58: BuyCarDonat(playerid, marketid, 506, carcost);
				case 29: BuyCarDonat(playerid, marketid, 507, carcost);
				case 32: BuyCarDonat(playerid, marketid, 516, carcost);
				case 76: BuyCarDonat(playerid, marketid, 521, carcost);
				case 78: BuyCarDonat(playerid, marketid, 522, carcost);
				case 75: BuyCarDonat(playerid, marketid, 523, carcost);
				case 44: BuyCarDonat(playerid, marketid, 526, carcost);
				case 35: BuyCarDonat(playerid, marketid, 527, carcost);
				case 21: BuyCarDonat(playerid, marketid, 529, carcost);
				case 63: BuyCarDonat(playerid, marketid, 533, carcost);
				case 22: BuyCarDonat(playerid, marketid, 534, carcost);
				case 20: BuyCarDonat(playerid, marketid, 536, carcost);
				case 24: BuyCarDonat(playerid, marketid, 540, carcost);
				case 68: BuyCarDonat(playerid, marketid, 541, carcost);
				case 23: BuyCarDonat(playerid, marketid, 542, carcost);
				case 47: BuyCarDonat(playerid, marketid, 543, carcost);
				case 31: BuyCarDonat(playerid, marketid, 546, carcost);
				case 9: BuyCarDonat(playerid, marketid, 549, carcost);
				case 40: BuyCarDonat(playerid, marketid, 550, carcost);
				case 43: BuyCarDonat(playerid, marketid, 551, carcost);
				case 49: BuyCarDonat(playerid, marketid, 558, carcost);
				case 25: BuyCarDonat(playerid, marketid, 559, carcost);
				case 39: BuyCarDonat(playerid, marketid, 560, carcost);
				case 28: BuyCarDonat(playerid, marketid, 562, carcost);
				case 42: BuyCarDonat(playerid, marketid, 565, carcost);
				case 67: BuyCarDonat(playerid, marketid, 579, carcost);
				case 77: BuyCarDonat(playerid, marketid, 581, carcost);
				case 19: BuyCarDonat(playerid, marketid, 585, carcost);
				case 34: BuyCarDonat(playerid, marketid, 587, carcost);
				case 37: BuyCarDonat(playerid, marketid, 589, carcost);
				case 41: BuyCarDonat(playerid, marketid, 603, carcost);
				case 57: BuyCarDonat(playerid, marketid, 604, carcost);
				case 79: BuyCarDonat(playerid, marketid, 597, carcost);
				case 80: BuyCarDonat(playerid, marketid, 470, carcost);
				case 81: BuyCarDonat(playerid, marketid, 598, carcost);
				case 82: BuyCarDonat(playerid, marketid, 596, carcost);
				case 83: BuySkinDonate(playerid, 122, carcost);
			}

	    return 1;
}

stock BuySkinDonate(playerid, skinid, cost)
{
    if(GetPlayerDonateRub(playerid) < cost)
	{
 		ShowNotification(playerid, 2, "Недостаточно BC!", 4, "", "");
		return -1;
	}
	SetPlayerData(playerid, P_SKIN, skinid);
	UpdatePlayerDatabaseInt(playerid, "skin", skinid);
	SetPlayerSkinInit(playerid);

	GivePlayerDonateRub(playerid, -cost, "Покупка скина", true, true);
	UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
	show_sc(playerid, -666, -666);
	return 1;
}

stock BuyCarDonat(playerid, marketid, ownablecar, cost)
{
    new color_1 = 1;
	new color_2 = 1;

	printf("player_cars: %d / player_slots: %d", GetPlayerOwnableCars(playerid), GetPlayerCarSlots(playerid));

	printf("BuyOwnableCar(%d, %d, %d, %d, %d)", playerid, marketid, ownablecar, color_1, color_2);

	if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
	{
 		ShowNotification(playerid, 2, "Все слоты для транспорта заняты!", 4, "", "");
		return -1;
	}

	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
	 	ShowNotification(playerid, 2, "Для покупки транспорта нужно выгрузить уже загруженный транспорт с сервера!", 4, "", "");
	 	return -1;
	}

	new modelid = ownablecar;

	printf("modelid = %d | ownablecar = %d", modelid, ownablecar);

	if(GetPlayerDonateRub(playerid) < cost)
	{
 		ShowNotification(playerid, 2, "Недостаточно BC!", 4, "", "");
		return -1;
	}

	GivePlayerDonateRub(playerid, -cost, "Покупка ТС в автосалоне", true, true);
	UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));

	new buy_cars_count = cars_after_purchase_count[marketid]++;

	if(buy_cars_count >= 4)
		cars_after_purchase_count[marketid] = 0;

	new Float: pos_x = cars_pos_after_purchase[marketid][buy_cars_count][0];
	new Float: pos_y = cars_pos_after_purchase[marketid][buy_cars_count][1];
	new Float: pos_z = cars_pos_after_purchase[marketid][buy_cars_count][2];
	new Float: angle = cars_pos_after_purchase[marketid][buy_cars_count][3];

	new query[220],
		Cache: result,
		idx;

	idx = GetFreeOwnableCarID();

	SetOwnableCarData(idx, OC_OWNER_ID, 	GetPlayerAccountID(playerid));

	SetOwnableCarData(idx, OC_MODEL_ID, 	modelid);
	SetOwnableCarData(idx, OC_COLOR_1, 		color_1);
	SetOwnableCarData(idx, OC_COLOR_2, 		color_2);

	SetOwnableCarData(idx, OC_POS_X, 		pos_x);
	SetOwnableCarData(idx, OC_POS_Y, 		pos_y);
	SetOwnableCarData(idx, OC_POS_Z, 		pos_z);
	SetOwnableCarData(idx, OC_ANGLE, 		angle);

	strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 8);

	SetOwnableCarData(idx, OC_ALARM, 		false);
	SetOwnableCarData(idx, OC_KEY_IN, 		false);

	SetOwnableCarData(idx, OC_CREATE, 		gettime());

	format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
	// ----------------------------------------------------------------------------------------

	new vehicleid = CreateVehicle
	(
		GetOwnableCarData(idx, OC_MODEL_ID),
		GetOwnableCarData(idx, OC_POS_X),
		GetOwnableCarData(idx, OC_POS_Y),
		GetOwnableCarData(idx, OC_POS_Z),
		GetOwnableCarData(idx, OC_ANGLE),
		GetOwnableCarData(idx, OC_COLOR_1),
		GetOwnableCarData(idx, OC_COLOR_2),
		-1,
		0,
		VEHICLE_ACTION_TYPE_OWNABLE_CAR,
		idx
	);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
		//index = GetVehicleData(vehicleid, V_ACTION_ID);
        format(g_ownable_car[idx][OC_NUMBER], 12, g_ownable_car[idx][OC_NUMBER]);
        SetVehicleRuNumberPlate(vehicleid, g_ownable_car[idx][OC_NUMBER], "17");
		SetVehicleParam(vehicleid, V_LOCK, false);

		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
	}

	SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);

	format
	(
		query, sizeof query,
		"INSERT INTO ownable_cars \
		(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
		VALUES \
		('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
		GetPlayerAccountID(playerid),
		modelid,
		color_1,
		color_2,
		pos_x,
		pos_y,
		pos_z,
		angle,
		gettime()
	);
	result = mysql_query(mysql, query, true);

	SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());

	cache_delete(result);

    launch[playerid] = 0;
    diski[playerid] = 0;
    fars[playerid] = 0;
    nitro[playerid] = 0;
	SendClientMessage(playerid, 0x66CC00FF, "Поздравляем с покупкой нового транспорта!");
	SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
	EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
	UnloadPlayerOwnableCar(playerid);
	show_sc(playerid, -777, -777);

	AddPlayerData(playerid, P_QUEST_EXP_5, +, 1);
	UpdatePlayerDatabaseInt(playerid, "quest_exp_5", GetPlayerData(playerid, P_QUEST_EXP_5));

	if(GetPlayerData(playerid, P_QUEST_EXP_5) == 1)
	{
	    SendClientMessage(playerid, COR_SERVER, "[Квесты]: "c_b"Вы успешно выполнили квест "c_i"'Первый транспорт'. "c_b"Награда: "c_m"10000 руб");
	    GivePlayerMoneyEx(playerid, 10000, "Выполнение квеста");

	    SetPlayerData(playerid, P_QUEST_5, 1);
	    UpdatePlayerDatabaseInt(playerid, "quest_5", 1);

	    AddPlayerData(playerid, P_TOP_5, +, 1);
		UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
	}

	return 1;
}


CMD:openbc(playerid)
{
    OpenLinkForPlayer(playerid, "https://reytiz.com");
}

CMD:openrub(playerid)
{
    new fmt_text[200];
    format
    (
        fmt_text,
        sizeof fmt_text,
        "{FFFFFF}\
        Ставка: {009900}1000Р\n\
        {FFFFFF}Наличие: {009900}%d\n\
  		\n\
        {6666CC}Введите количество, которое\n\
        Вы хотите конвертировать в игровые деньги:\
        ",
        GetPlayerDonateRub(playerid)
    );

    Dialog(playerid, DIALOG_DONATE_CONVERT, DIALOG_STYLE_INPUT, "{ffcc00}Обмен валют (конвертер)", fmt_text, "Далее", "Назад");
}
CMD:keys(playerid)
{
    ShowNotification(playerid, 2, "Кейсы находятся в разработке!", 4, "", "");
}
CMD:bp(playerid)
{
    ShowNotification(playerid, 2, "BLACK PASS находится в разработке!", 4, "", "");
}
CMD:nabori(playerid)
{
    ShowNotification(playerid, 2, "Наборы находятся в разработке!", 4, "", "");
}
CMD:akss(playerid)
{
   ShowNotification(playerid, 2, "Аксессуары находятся в разработке!", 4, "", "");
}

CMD:changename(playerid)
{
	if(GetPlayerDonateRub(playerid) >= 50)
	{
		Dialog
		(
			playerid, DIALOG_DONATE_CHANGE_NAME, DIALOG_STYLE_INPUT,
			"{FFCD00}Изменение имени",
			"{FFFFFF}Введите новое имя в поле ниже:",
			"Изменить", "Закрыть"
		);
	}
	else ShowNotification(playerid, 2, "Недостаточно ВС!", 4, "", "");
	return 1;
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

								ShowNotification(playerid, 3, "Все предупреждения успешно сняты", 4, "", "");
								ShowNotification(playerid, 3, "Теперь Вы можете устроиться в организацию!", 4, "", "");
								UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
								show_sc(playerid, -1, -1);
							}
							else
							{
								new fmt_text[80];
							 	ShowNotification(playerid, 2, "Для снятия всех предупреждений необходимо иметь на счету 100 руб!", 4, "", "");
							}
						}
						else ShowNotification(playerid, 2, "На Вашем аккаунте нет предупреждений!", 4, "", "");

						return 1;

}
CMD:alllic(playerid)
{
						if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 1)
                          ShowNotification(playerid, 2, "У Вас уже есть все лицензии!", 4, "", "");

						else
						{
							if(GetPlayerDonateRub(playerid) >= 150)
							{
								SetPlayerData(playerid, P_DRIVING_LIC,	2);
								SetPlayerData(playerid, P_WEAPON_LIC,	1);

								UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

								GivePlayerDonate(playerid, -150, "Покупка пакета лицензий", true);

								ShowNotification(playerid, 3, "Вы приобрели пакет лицензий. Используйте: {FFFF00}/lic!", 4, "", "");
								UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
								show_sc(playerid, -1, -1);
							}
							else
							{
								return ShowNotification(playerid, 2, "Для покупки всех лицензий необходимо иметь на счету 150 руб!", 4, "", "");
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
						    if(GetPlayerData(playerid, P_BOOMBOX) >= 1) return ShowNotification(playerid, 2, "У вас уже есть бумбокс!", 4, "", "");

							GivePlayerDonateRub(playerid, -1000, "покупка бумбокса");

                            ShowNotification(playerid, 3, "Вы успешно купили бумбокс(/boombox)", 4, "", "");

							SetPlayerData(playerid, P_BOOMBOX, 1);
							UpdatePlayerDatabaseInt(playerid, "boombox", 1);
							UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
							show_sc(playerid, -1, -1);
						}
						else ShowNotification(playerid, 2, "Недостаточно ВС!", 4, "", "");


	return 1;

}
CMD:buyslot(playerid)
{
						new fmt_text[80];

						if(GetPlayerDonateRub(playerid) < 100)
						{
						    ShowNotification(playerid, 2, "Для покупки слота для транспорта необходимо иметь на счету 100 руб!", 4, "", "");
						}
						else
						{
							AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
							UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

							GivePlayerDonateRub(playerid, -100, "Покупка слота для транспорта", true, true);

							format(fmt_text, sizeof fmt_text, ""SC"Вы увеличили количество слотов для транспорта. Текущее количество слотов: {ffff00}%d", GetPlayerData(playerid, P_CAR_SLOTS));

							ShowNotification(playerid, 3, fmt_text, 4, "", "");
							UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));
							show_sc(playerid, -1, -1);
						}

						return 1;
}
CMD:buynomber(playerid)
{
						if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
						{
							if(GetPlayerOwnableCars(playerid) == 0)
								return ShowNotification(playerid, 2, "У вас нет личного транспорта!", 4, "", "");
							else
								return ShowNotification(playerid, 2, "Ваш транспорт не загружен на сервер!", 4, "", "");
						}

									Dialog
					(
						playerid, DIALOG_DONATE_BUY_CAR_NUMBER, DIALOG_STYLE_INPUT,
						"{ffcd00}Введите номер для личного ТС",
						"{FFFFFF}\
						Введите номер, который\n\
						Вы хотите установить на личный транспорт\n\n\
						- Разрешено использовать цифры, а так же буквы: A, B, E, K, M, H, O, P, C, T, X\n\
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
								"{FFCD00}Покупка 4-х значного номера телефона",
								"{FFFFFF}Введите номер, который\n"\
								"Вы хотели бы приобрести:",
								"Далее", "Отмена"
							);

							return 1;
						}
						else
						{

							ShowNotification(playerid, 2, "Недостаточно ВС!", 4, "", "");
						}

						return 1;
}

CMD:pon(playerid)
{
	SendCustomRPC(playerid, 0x45);
	//ox45 это айди
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

