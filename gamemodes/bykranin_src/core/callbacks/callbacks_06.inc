//>> Файл: bykranin_src/core/callbacks/callbacks_06.inc  (376 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerClickPlayerTextDraw, OnPlayerEnterDynamicCP, CreateFactoryProd, OnPlayerLeaveDynamicCP, Funchion3
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == PlayerText:INVALID_TEXT_DRAW)
    {
        // Клик вне текстдравов — можно отключить режим
        CancelSelectTextDraw(playerid);
        SendClientMessage(playerid, -1, "Режим выбора текстдравов отключён.");
        return 1;
    }

    if(pin_code_PTD[playerid][0] <= playertextid <= pin_code_PTD[playerid][9])
    {
        new pc_state = GetPlayerPinCodeState(playerid);
        new index = _:(playertextid - pin_code_PTD[playerid][0]);

        if(pc_state != PIN_CODE_STATE_NONE && 0 <= index <= 9)
        {
            new ch[2];
            valstr(ch, GetPlayerPinCodeValue(playerid, index));
            strcat(pin_code_input[playerid], ch);

            if(strlen(pin_code_input[playerid]) >= 4)
            {
                if(pc_state == PIN_CODE_STATE_CHECK)
                {
                    HidePlayerPinCodePTD(playerid, false);
                }
					else HidePlayerPinCodePTD(playerid);

                switch(pc_state)
                {
                    case PIN_CODE_STATE_SET, PIN_CODE_STATE_CHANGE:
                    {
                        new query[75];
                        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET setting_pin_code='%e' WHERE id=%d LIMIT 1", pin_code_input[playerid], GetPlayerAccountID(playerid));
                        mysql_query(mysql, query, false);

                        if(!mysql_errno())
                        {
                            format(g_player[playerid][P_SETTING_PIN], 5, "%s", pin_code_input[playerid]);
                            mysql_format(mysql, query, sizeof query, "PIN-код %s: {FFFF00}%s", pc_state == PIN_CODE_STATE_SET ? ("успешно установлен") : ("изменен на"), GetPlayerData(playerid, P_SETTING_PIN));
                            SendClientMessage(playerid, 0x66CC00FF, query);
                            SendClientMessage(playerid, 0x66CC00FF, "Запомните или запишите это число");
                            ShowPlayerSecuritySettings(playerid);
                        }
					else
                        {
                            SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 04)");
                            ShowPlayerPinCodePTD(playerid, pc_state);
                        }
                    }
                    case PIN_CODE_STATE_CHECK:
                    {
                        if(strcmp(pin_code_input[playerid], GetPlayerData(playerid, P_SETTING_PIN)) != 0)
                        {
                            SendClientMessage(playerid, 0xFF6600FF, "PIN-код введен неверно");
                            ShowPlayerSecuritySettings(playerid);
                        }
					else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_CHANGE);
                    }
                    case PIN_CODE_STATE_LOGIN_CHECK:
                    {
                        if(!IsPlayerLogged(playerid))
                        {
                            if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_LOGIN)
                            {
                                new step = GetPlayerData(playerid, P_ACCOUNT_STEP_STATE);
                                new bool:wrong_pass = false;

                                if(!strlen(GetPlayerData(playerid, P_SETTING_PIN)) || strcmp(GetPlayerData(playerid, P_SETTING_PIN), pin_code_input[playerid]) != 0)
                                {
                                    wrong_pass = true;
                                    step--;
                                }
                                ShowPlayerLoginDialog(playerid, step + 1, wrong_pass);
                            }
                        }
                    }
                }
                pin_code_input[playerid][0] = 0;
            }
        }
    }
    if(GetPlayerData(playerid, P_USE_SELECT_PANEL) == SELECT_PANEL_TYPE_CAR_MARKET)
    {
        if(playertextid == buy_car_PTD[playerid][2]) // кнопка переключения типа цвета 1/2
        {
            new type = buy_car_select_color_type[playerid];
            buy_car_select_color_type[playerid] = type ? 0 : 1;
            CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        }
        else if(playertextid == buy_car_PTD[playerid][3]) // цвет влево
        {
            if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;

            new type = buy_car_select_color_type[playerid];
            new color1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
            new color2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);

            if(type == 0)
            {
                color1--;
                if(color1 < 0) color1 = MAX_COLOR_ID;
                SetPlayerData(playerid, P_AUTOSALON_COLOR1, color1);
                buy_car_select_color[playerid][0] = color1;
            }
            else
            {
                color2--;
                if(color2 < 0) color2 = MAX_COLOR_ID;
                SetPlayerData(playerid, P_AUTOSALON_COLOR2, color2);
                buy_car_select_color[playerid][1] = color2;
            }

            ApplyAutosalonPreviewColor(playerid);
            CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        }
        else if(playertextid == buy_car_PTD[playerid][5]) // цвет вправо
        {
            if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;

            new type = buy_car_select_color_type[playerid];
            new color1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
            new color2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);

            if(type == 0)
            {
                color1++;
                if(color1 > MAX_COLOR_ID) color1 = 0;
                SetPlayerData(playerid, P_AUTOSALON_COLOR1, color1);
                buy_car_select_color[playerid][0] = color1;
            }
            else
            {
                color2++;
                if(color2 > MAX_COLOR_ID) color2 = 0;
                SetPlayerData(playerid, P_AUTOSALON_COLOR2, color2);
                buy_car_select_color[playerid][1] = color2;
            }

            ApplyAutosalonPreviewColor(playerid);
            CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        }
    }
    return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{

	//if(help_info_CP[0] <= checkpointid <= help_info_CP[sizeof help_info_CP - 1])
	if(checkpointid == markerhelp)
	{
		callcmd::help(playerid, "");
	}
	if(checkpointid == markerhelp1)
	{
		callcmd::help(playerid, "");
	}
					else if(checkpointid == driving_exam_CP)
	{
		Dialog
		(
			playerid, DIALOG_DRIVING_EXAM_INFO, DIALOG_STYLE_MSGBOX,
			"{FFCD00}Экзамен по вождению",
			"{FFFFFF}Здравствуйте!\n"\
			"Вы готовы приступить к экзамену? Тогда начнем.\n"\
			"Экзамен будет состоять из теоретической и практической части\n"\
			"В теории вам нужно будет ответить на вопросы из вашего экзаменационного билета,\n"\
			"а в практике применить полученные знания за рулем учебного автомобиля.\n\n"\
			"{CC9900}Сдача на права стоит 600 рублей и в случае провала деньги не будут возвращены!\n"\
			"Поэтому перед сдачей внимательно прочитайте обучающий раздел",
			"Начать", "Отмена"
		);
	}
					else if(factory_desk[0][FD_CHEK_ID] <= checkpointid <= factory_desk[sizeof(factory_desk)-1][FD_CHEK_ID])
	{
		new index = checkpointid - factory_desk[0][FD_CHEK_ID];
		SetPlayerFactoryDeskUse(playerid, index, true);
	}
					else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_CLUB, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_CLUB)
			{
				if(IsPlayerInJob(playerid) || GetPlayerTempJob(playerid) != TEMP_JOB_NONE)
					return SendClientMessage(playerid, 0xCECECEFF, "Перед посещением бара необходимо завершить рабочий день");

				Dialog
				(
					playerid, DIALOG_BIZ_CLUB, DIALOG_STYLE_LIST,
					GetBusinessData(businessid, B_NAME),
					"1. Лимонад\t\t{00CC00}60 руб\n"\
					"2. Пиво\t\t\t{00CC00}100 руб\n"\
					"3. Вино\t\t\t{00CC00}200 руб\n"\
					"4. Шампанское\t\t{00CC00}270 руб\n"\
					"5. Водка\t\t{00CC00}300 руб\n"\
					"6. Коньяк\t\t{00CC00}450 руб\n"\
					"7. Виски\t\t{00CC00}630 руб\n"\
					"8. Абсент\t\t{00CC00}750 руб\n"\
					"{CC9900}9. Закуска\t\t{00CC00}50 руб\n"\
					"{CC9900}10. Сигара\t\t{00CC00}80 руб",
					"Купить", "Отмена"
				);
			}
		}
	}
					else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_CASINO)
			{
				if(IsPlayerInJob(playerid) || GetPlayerTempJob(playerid) != TEMP_JOB_NONE)
					return SendClientMessage(playerid, 0xCECECEFF, "Перед посещением бара необходимо завершить рабочий день");

				Dialog
				(
					playerid, DIALOG_BIZ_CLUB, DIALOG_STYLE_LIST,
					GetBusinessData(businessid, B_NAME),
					"1. Лимонад\t\t{00CC00}60 руб\n"\
					"2. Пиво\t\t\t{00CC00}100 руб\n"\
					"3. Вино\t\t\t{00CC00}200 руб\n"\
					"4. Шампанское\t\t{00CC00}270 руб\n"\
					"5. Водка\t\t{00CC00}300 руб\n"\
					"6. Коньяк\t\t{00CC00}450 руб\n"\
					"7. Виски\t\t{00CC00}630 руб\n"\
					"8. Абсент\t\t{00CC00}750 руб\n"\
					"{CC9900}9. Закуска\t\t{00CC00}50 руб\n"\
					"{CC9900}10. Сигара\t\t{00CC00}80 руб",
					"Купить", "Отмена"
				);
			}
		}
	}
					else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_REALTOR_BIZ, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_REALTOR_BIZ)
			{
				Dialog
				(
					playerid, DIALOG_BIZ_REALTOR_BIZ_LIST, DIALOG_STYLE_LIST,
					"{66FF99}Номера свободных бизнесов",
					g_business_realtor_list,
					"Инфо 70р", "Закрыть"
				);
			}
		}
	}
					else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_REALTOR_HOME, BT_BUY_CHECK_ID))
	{
		new businessid = GetPlayerInBiz(playerid);
		if(businessid != -1)
		{
			new type = GetBusinessData(businessid, B_TYPE);
			if(type == BUSINESS_TYPE_REALTOR_HOME)
			{
				ShowPlayerRealtorHomeDialog(playerid);
			}
		}
	}
					else if(checkpointid == GetBusinessInteriorInfo(BUSINESS_INTERIOR_HOTEL, BT_BUY_CHECK_ID))
	{
		ShowPlayerHotelDialog(playerid);
	}
					else if(g_hotel_lift_CP[0] <= checkpointid <= g_hotel_lift_CP[1])
	{
		new hotel_id = GetPlayerInHotelID(playerid);
		if(hotel_id != -1)
		{
			new floor_id = GetPlayerData(playerid, P_IN_HOTEL_FLOOR);
			ShowPlayerHotelFloorsLift(playerid, hotel_id, floor_id);
		}
	}
					else if(checkpointid == army_ammo_CP)
	{
		SetPVarInt(playerid, "player_in_ammo_cp", 1);
	}
/*	else if(miner_job_load_cp[0] <= checkpointid <= sizeof miner_job_load_cp - 1)
	{
		SetPlayerMinerJobLoadCP(playerid);

		if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER && GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_LOAD)
		{
			ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
			SetTimerEx("SetPlayerMinerJobTakeOre", 15_000, false, "ii", playerid, 1);
		}
	}*/
	return 1;
}

public: CreateFactoryProd(playerid)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_CREATED)
		{
		//	RemovePlayerAttachedObjectEx(playerid, A_OBJECT_SLOT_HAND, A_OBJECT_SLOT_HAND + 1);

			new skill = GetPVarInt(playerid, "factory_skill");
			if(!(random(5) + skill == 1))
			{
				if(random(6) == 1)
				{
					new fmt_str[80];

					SetPVarInt(playerid, "factory_skill", skill + 1);

					format(fmt_str, sizeof fmt_str, "Рабочий навык увеличен. Теперь шанс создать бракованый продукт 1 из %d", skill + 5);
					SendClientMessage(playerid, 0x66CC00FF, fmt_str);
				}

				ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0, USE_ANIM_TYPE_NONE - 1);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);

				SetPlayerChatBubble(playerid, "+ 1 продукт", 0x66CC00FF, 10.0, 1500);

			//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM, 1279, A_OBJECT_BONE_LEFT_FOREARM, 0.4, -0.09, -0.2, 85.0, 0.0, 90.0, 1.0, 1.0, 1.0, 0);
				GameTextForPlayer(playerid, "~g~~h~SUCCESS", 4000, 1);

				SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_PUT_PROD);
				SetPlayerTempJobCheckAnim(playerid, true);
			}
					else FactoryPlayerDrop(playerid);

			SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);
		}
	}
}

public OnPlayerLeaveDynamicCP(playerid, checkpointid)
{
	if(checkpointid == army_ammo_CP)
		DeletePVar(playerid, "player_in_ammo_cp");
	return 1;
}

forward Funchion3(playerid);
public Funchion3(playerid)
{
new fmt_text[75];
new itog;
new withdraw_money[32];
if(shetochkovferma<200)
{
shetochkovferma++;
 itog = shetochkovferma+1;// 1 можете заменить на любое количесво очков
  //      new withdraw_money[8];
//  format(fmt_text, sizeof fmt_text, "Очки %d ", itog);
       format(withdraw_money,32,"~r~%d",itog);
GameTextForPlayer(playerid, withdraw_money, 2000, 6);
                timerochkov = SetTimer("Funchion3", 15000, true);
                return 1;
        }
					else      if(shetochkovferma==200)
        {
        itog=0;
        shetochkovferma=0;
        SendMessageToTeam(GetPlayerData(playerid, P_FAMILY), "Битва за феру гарель закончилась", 0x33CC66FF);
        KillTimer(timerochkov);
        return 1;
}	
KillTimer(timerochkov);
return 1;
        }

