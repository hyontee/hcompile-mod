//>> Файл: bykranin_src/core/callbacks/on_player_click_text_draw.inc  (1167 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerClickTextDraw
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{

    new businessid = GetPlayerBusiness(playerid);
    
    new buffer = 0;
    if(clickedid == avtsln_TD[1])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;

                new td_price = GetAutosalonTestDrivePrice(playerid);
        new dialog_text[512];
        format(dialog_text, sizeof dialog_text,
            "Вы действительно хотите начать проведение тест-драйва за {FFFF00}%d рублей{FFFFFF}?\n\nВремя проведения тест-драйва не ограничено. Вы сможете в полной мере \nоценить все характеристики выбранного транспортного средства.",
            td_price
        );
        ShowPlayerDialog(playerid, 34150, DIALOG_STYLE_MSGBOX, "{E0584B}{SERVER_NAME} {FFFFFF}| Подтверждение", dialog_text, "Да", "Отмена");
        return 1;
    }
    if(clickedid == avtsln_TD[4])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        CarMarketShowNextCar(playerid, '-');
        return 1;
    }
    if(clickedid == avtsln_TD[5])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        CarMarketShowNextCar(playerid, '+');
        return 1;
    }
    if(clickedid == avtsln_TD[2])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        ShowBuyCarFamilyAndOwnable(playerid);
        return 1;
    }
    if(clickedid == avtsln_TD[3])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        ExitPlayerBuyCarMarket(playerid);
        return 1;
    }
    if(clickedid == avtsln_TD[10])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        new color2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
        color2++;
        if(color2 > MAX_COLOR_ID) color2 = 0;
        SetPlayerData(playerid, P_AUTOSALON_COLOR2, color2);
        buy_car_select_color[playerid][1] = color2;
        ApplyAutosalonPreviewColor(playerid);
        CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        return 1;
    }
    if(clickedid == avtsln_TD[12])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        new color1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
        color1++;
        if(color1 > MAX_COLOR_ID) color1 = 0;
        SetPlayerData(playerid, P_AUTOSALON_COLOR1, color1);
        buy_car_select_color[playerid][0] = color1;
        ApplyAutosalonPreviewColor(playerid);
        CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        return 1;
    }
    if(clickedid == avtsln_TD[9])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        new color2 = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
        color2--;
        if(color2 < 0) color2 = MAX_COLOR_ID;
        SetPlayerData(playerid, P_AUTOSALON_COLOR2, color2);
        buy_car_select_color[playerid][1] = color2;
        ApplyAutosalonPreviewColor(playerid);
        CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        return 1;
    }
    if(clickedid == avtsln_TD[11])
    {
        if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
        new color1 = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
        color1--;
        if(color1 < 0) color1 = MAX_COLOR_ID;
        SetPlayerData(playerid, P_AUTOSALON_COLOR1, color1);
        buy_car_select_color[playerid][0] = color1;
        ApplyAutosalonPreviewColor(playerid);
        CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
        return 1;
    }
    if(clickedid == stop_anim_TD[0])
    {
        ClearPlayerUseAnim(playerid);
    }
    /*if(clickedid == enter_speedometr_TD[1])
    {
        SpeedometrEnterHideForPlayer(playerid);
        
        SetPlayerData(playerid, P_SPEEDOMETR, 1);
		UpdatePlayerDatabaseInt(playerid, "speedometr", 1);
    }
    if(clickedid == enter_speedometr_TD[2])
    {
        SpeedometrEnterHideForPlayer(playerid);
        
        SetPlayerData(playerid, P_SPEEDOMETR, 2);
		UpdatePlayerDatabaseInt(playerid, "speedometr", 2);
    }
    if(clickedid == enter_speedometr_TD[3])
    {
        SpeedometrEnterHideForPlayer(playerid);
    }*/

   	if(clickedid == cont_sell)
    {
        new cont = pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                new sell_price_string[120];
                new sell_price = cInfo[cont][ItemPrice];
				GivePlayerMoneyEx(playerid, sell_price);

				// ?? ЗЕЛЁНАЯ НОТИФИКАЦИЯ С РУБЛЁМ - ПОЛУЧЕНИЕ ДЕНЕГ
				new money_str[64];
				ConvertMoney(sell_price, money_str);
				format(money_str, sizeof(money_str), "Вы получили %s рублей", money_str);
				ShowNotificationNew(playerid, 1, 6, 0, 0, money_str, " ");

				format(sell_price_string, sizeof(sell_price_string), " {ffffff}Вы успешно продали содержимое контейнера {FF5252}#%d {ffffff}за {FF5252}%d {FF5252}рублей!", cont, sell_price);
				SendClientMessage(playerid, CLR_GREEN, sell_price_string);

                TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

                TextDrawHideForPlayer(playerid, cont_fon);
                TextDrawHideForPlayer(playerid, cont_take);
                TextDrawHideForPlayer(playerid, cont_sell);
                TextDrawHideForPlayer(playerid, cont_close);

                TextDrawHideForPlayer(playerid, cont_name[cont]);
                TextDrawHideForPlayer(playerid, cont_price[cont]);
                TextDrawHideForPlayer(playerid, cont_model[cont]);
                CancelSelectTextDraw(playerid);


                DestroyObject(cInfo[cont][ContObjectId]);
                DestroyObject(cInfo[cont][ContObjectOdejdaId]);
                DestroyVehicle(cInfo[cont][ContVehicleId]);
                KillTimer(ContsTimer[cont]);
                ResetContInfo(cont);
                pInfo[playerid][BuyUseCont] = 0;
                pInfo[playerid][BetUseCont] = 0;

                if(ContsRespawnTimer[cont] != 0) KillTimer(ContsRespawnTimer[cont]);
                ContsRespawnTimer[cont] = SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_take)
    {
        new cont = pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                if (cInfo[cont][ItemType] == 1) // Скин
                {
                    /*SetPlayerSkin(playerid, cInfo[cont][Item]);
                    SetPlayerData(playerid, P_SKIN, cInfo[cont][Item]);
                    UpdatePlayerDatabaseInt(playerid, "skin", cInfo[cont][Item]);
                    SetPlayerSkinInit(playerid);*/
                    GivePlayerOwnableSkinEx(playerid, cInfo[cont][Item]);
                    SendClientMessage(playerid, CLR_GREEN, " {ffffff}Вы получили новый скин из контейнера!");
                }
					else if (cInfo[cont][ItemType] == 2) // Автомобиль
                {
                    new car_modelid = cInfo[cont][Item];
                    new car_color = cInfo[cont][ContVehicleColor];
                    new Float:pos_x, Float:pos_y, Float:pos_z, Float:angle;
                    new query[256], Cache: result;

                    GetContainerRewardParkPosition(pos_x, pos_y, pos_z, angle);

                    format(query, sizeof query, "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%d')",
                        GetPlayerAccountID(playerid), car_modelid, car_color, car_color, pos_x, pos_y, pos_z, angle, gettime());
                    
                    result = mysql_query(mysql, query, true);
                    cache_delete(result);
                    SendClientMessage(playerid, CLR_GREEN, "{ffffff}Поздравляем! Вы получили новый автомобиль из контейнера!");
                }

                TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

                TextDrawHideForPlayer(playerid, cont_fon);
                TextDrawHideForPlayer(playerid, cont_take);
                TextDrawHideForPlayer(playerid, cont_sell);
                TextDrawHideForPlayer(playerid, cont_close);

                TextDrawHideForPlayer(playerid, cont_name[cont]);
                TextDrawHideForPlayer(playerid, cont_price[cont]);
                TextDrawHideForPlayer(playerid, cont_model[cont]);
                CancelSelectTextDraw(playerid);


                DestroyObject(cInfo[cont][ContObjectId]);
                DestroyObject(cInfo[cont][ContObjectOdejdaId]);
                DestroyVehicle(cInfo[cont][ContVehicleId]);
                KillTimer(ContsTimer[cont]);
                ResetContInfo(cont);
                pInfo[playerid][BuyUseCont] = 0;
                pInfo[playerid][BetUseCont] = 0;

                if(ContsRespawnTimer[cont] != 0) KillTimer(ContsRespawnTimer[cont]);
                ContsRespawnTimer[cont] = SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_close)
    {
        TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

        TextDrawHideForPlayer(playerid, cont_fon);
        TextDrawHideForPlayer(playerid, cont_take);
        TextDrawHideForPlayer(playerid, cont_sell);
        TextDrawHideForPlayer(playerid, cont_close);
        CancelSelectTextDraw(playerid);

        for(new cont=1; cont <= MAX_CONT; cont++)
        {
            TextDrawHideForPlayer(playerid, cont_name[cont]);
            TextDrawHideForPlayer(playerid, cont_price[cont]);
            TextDrawHideForPlayer(playerid, cont_model[cont]);
        }
    }
    if(clickedid == casino_dice_btn_setbet)
    {
        if(!pInfo[playerid][CasinoDiceUiOpen]) return 1;

        new table_idx = pInfo[playerid][CasinoDiceTable] - 1;
        if(!(0 <= table_idx < sizeof g_casino_table_pos))
        {
            HideCasinoDiceUi(playerid);
            return ShowNotificationNew(playerid, 2, 6, 0, 0, "Стол больше недоступен", " ");
        }

        if(IsPlayerCasinoDealer(playerid, table_idx))
        {
            ShowPlayerDialog
            (
                playerid,
                DIALOG_CASINO_TABLE_SETBET,
                DIALOG_STYLE_INPUT,
                "{FF0000}Установки ставки для игры:",
                "Ставка должна быть не менее 1000 рублей и не более 1000000000",
                "Далее",
                "Отмена"
            );
            return 1;
        }

        if(!g_casino_table_bet_set[table_idx] || g_casino_table_bet[table_idx] <= 0)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Ставка еще не установлена крупье", " ");
            return 1;
        }

        if(g_casino_round_active[table_idx])
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игра уже началась", " ");
            return 1;
        }

        if(pInfo[playerid][CasinoDiceBetPaid] && pInfo[playerid][CasinoDiceBetPaidTable] == table_idx + 1)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы уже поставили ставку", " ");
            return 1;
        }

        new pay_bet = g_casino_table_bet[table_idx];
        if(GetPlayerMoneyEx(playerid) < pay_bet)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно средств", " ");
            return 1;
        }

        GivePlayerMoneyEx(playerid, -pay_bet);

        pInfo[playerid][CasinoDiceBetPaid] = true;
        pInfo[playerid][CasinoDiceBetPaidTable] = table_idx + 1;
        pInfo[playerid][CasinoDiceBet] = pay_bet;

        new spend_str[80];
        format(spend_str, sizeof spend_str, "Вы потратили %d рублей", pay_bet);
        ShowNotificationNew(playerid, 2, 6, 0, 0, spend_str, " ");

        RefreshCasinoDicePlayersListForTable(table_idx);
        return 1;
    }

    if(clickedid == casino_dice_btn_start)
    {
        if(!pInfo[playerid][CasinoDiceUiOpen]) return 1;

        new table_idx = pInfo[playerid][CasinoDiceTable] - 1;
        if(!(0 <= table_idx < sizeof g_casino_table_pos))
        {
            HideCasinoDiceUi(playerid);
            return ShowNotificationNew(playerid, 2, 6, 0, 0, "Стол больше недоступен", " ");
        }
        if(!IsPlayerCasinoDealer(playerid, table_idx))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Только крупье или менеджер может начать игру", " ");
            return 1;
        }

        if(g_casino_round_active[table_idx] && g_casino_round_timer[table_idx] == 0)
        {
            g_casino_round_active[table_idx] = false;
        }

        if(g_casino_round_active[table_idx])
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игра уже началась", " ");
            return 1;
        }

        if(!g_casino_table_bet_set[table_idx] || g_casino_table_bet[table_idx] <= 0)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Сначала установите ставку", " ");
            return 1;
        }

        new players[MAX_PLAYERS];
        new count = GetCasinoTablePlayers(table_idx, players, sizeof players);
        if(count < 2)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Для старта нужно минимум 2 игрока", " ");
            return 1;
        }

        g_casino_round_active[table_idx] = true;
        g_casino_round_left[table_idx] = 10;

        if(g_casino_round_timer[table_idx] != 0)
        {
            KillTimer(g_casino_round_timer[table_idx]);
        }

        g_casino_round_timer[table_idx] = SetTimerEx("CasinoDiceRoundTick", 1000, true, "i", table_idx);
        if(g_casino_round_timer[table_idx] == 0)
        {
            g_casino_round_active[table_idx] = false;
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось запустить таймер", " ");
            return 1;
        }

        for(new stake_idx; stake_idx < count; stake_idx++)
        {
            CasinoDice_RecordStakeProfit(players[stake_idx], pInfo[players[stake_idx]][CasinoDiceBet]);
        }

        CasinoDiceRoundTick(table_idx);
        return 1;
    }

    if(clickedid == casino_dice_btn_exit)
    {
        HideCasinoDiceUi(playerid);
        return 1;
    }
if(clickedid == casino_TD[0])
    {
        SendClientMessage(playerid, 0x00FF00FF, "Ты кликнул по казино!");
        CancelSelectTextDraw(playerid); // Отключаем режим после клика
        // Здесь можно добавить логику: открыть диалог, начать игру и т.д.
    }
if(clickedid == acs_TD[1])
	{
	    for(new i; i < sizeof acs_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acs_TD[i]);
		}

		RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "slot"));

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acs_td_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "modelid");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "num_1");
		DeletePVar(playerid, "num_2");
		DeletePVar(playerid, "num_3");
		DeletePVar(playerid, "num_4");
		DeletePVar(playerid, "num_5");
		DeletePVar(playerid, "num_6");
		DeletePVar(playerid, "num_7");

		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
	}
	if(clickedid == acs_TD[2])
	{
		for(new i; i < sizeof acs_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acs_TD[i]);
		}

		new query[220], Cache: result;

		if(GetPVarInt(playerid, "updateacs") == 0)
		{
			format
			(
				query, sizeof query,
				"INSERT INTO accessories (id, slot, modelid, bone, x, y, z, rX, rY, rZ, scale)"\
				"VALUES ('%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
				GetPlayerAccountID(playerid),
				GetPVarInt(playerid, "slot"),
				GetPVarInt(playerid, "modelid"),
				GetPVarInt(playerid, "bone"),
				GetPVarFloat(playerid, "num_1"),
				GetPVarFloat(playerid, "num_2"),
				GetPVarFloat(playerid, "num_3"),
				GetPVarFloat(playerid, "num_4"),
				GetPVarFloat(playerid, "num_5"),
				GetPVarFloat(playerid, "num_6"),
				GetPVarFloat(playerid, "num_7")
			);
		}
					else
		{
			format
			(
				query, sizeof query,
				"UPDATE accessories SET modelid=%d, bone=%d, x=%f, y=%f, z=%f, rX=%f, rY=%f, rZ=%f, scale=%f WHERE id=%d AND slot=%d",
				GetPVarInt(playerid, "modelid"),
				GetPVarInt(playerid, "bone"),
				GetPVarFloat(playerid, "num_1"),
				GetPVarFloat(playerid, "num_2"),
				GetPVarFloat(playerid, "num_3"),
				GetPVarFloat(playerid, "num_4"),
				GetPVarFloat(playerid, "num_5"),
				GetPVarFloat(playerid, "num_6"),
				GetPVarFloat(playerid, "num_7"),
				GetPlayerAccountID(playerid),
				GetPVarInt(playerid, "slot")
			);
		}

		result = mysql_query(mysql, query, true);

		cache_delete(result);

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acs_td_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "modelid");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "num_1");
		DeletePVar(playerid, "num_2");
		DeletePVar(playerid, "num_3");
		DeletePVar(playerid, "num_4");
		DeletePVar(playerid, "num_5");
		DeletePVar(playerid, "num_6");
		DeletePVar(playerid, "num_7");

		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
		SCM(playerid, -1, "{FFFF00}| {FFFFFF}Аксессуар успешно сохранен.");
	}
    new clicked_param_td = -1;
    for(new i = 3; i < 10; i++)
    {
        if(clickedid == acs_TD[i])
        {
            clicked_param_td = i;
            break;
        }
    }

    if(clicked_param_td != -1)
    {
        new td_use = GetPVarInt(playerid, "acs_td_use");
        if(td_use < 1 || td_use > 7) td_use = 1;

        new count_TD = clicked_param_td - 3;

        TextDrawHideForPlayer(playerid, acs_TD[9 + td_use]);
        TextDrawShowForPlayer(playerid, acs_TD[2 + td_use]);
        TextDrawHideForPlayer(playerid, acs_TD[16 + td_use]);

        TextDrawHideForPlayer(playerid, acs_TD[3 + count_TD]);
        TextDrawShowForPlayer(playerid, acs_TD[10 + count_TD]);
        TextDrawShowForPlayer(playerid, acs_TD[17 + count_TD]);

        SetPVarInt(playerid, "acs_td_use", count_TD + 1);

        new Float:v;
        switch(count_TD + 1)
        {
            case 1: v = GetPVarFloat(playerid, "num_2");
            case 2: v = GetPVarFloat(playerid, "num_3");
            case 3: v = GetPVarFloat(playerid, "num_1");
            case 4: v = GetPVarFloat(playerid, "num_7");
            case 5: v = GetPVarFloat(playerid, "num_4");
            case 6: v = GetPVarFloat(playerid, "num_5");
            case 7: v = GetPVarFloat(playerid, "num_6");
        }

        new s[32];
        format(s, sizeof s, "%.6f", v);
        PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], s);
        return 1;
    }

    if(clickedid == acs_TD[24] || clickedid == acs_TD[25])
    {
        new Float:val = (clickedid == acs_TD[24]) ? (1.0) : (-1.0);
        new type = GetPVarInt(playerid, "acs_td_use");
        new s[32];

        switch(type)
        {
            case 1:
            {
                SetPVarFloat(playerid, "num_3", GetPVarFloat(playerid, "num_3") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_3"));
            }
            case 2:
            {
                SetPVarFloat(playerid, "num_1", GetPVarFloat(playerid, "num_1") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_1"));
            }
            case 3:
            {
                SetPVarFloat(playerid, "num_2", GetPVarFloat(playerid, "num_2") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_2"));
            }
            case 4:
            {
                SetPVarFloat(playerid, "num_7", GetPVarFloat(playerid, "num_7") + (val * 0.02));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_7"));
            }
            case 5:
            {
                SetPVarFloat(playerid, "num_4", GetPVarFloat(playerid, "num_4") + (val * 2.0));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_4"));
            }
            case 6:
            {
                SetPVarFloat(playerid, "num_5", GetPVarFloat(playerid, "num_5") + (val * 2.0));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_5"));
            }
            case 7:
            {
                SetPVarFloat(playerid, "num_6", GetPVarFloat(playerid, "num_6") + (val * 2.0));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "num_6"));
            }
            default:
            {
                return 1;
            }
        }

        PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], s);

if (GetPVarInt(playerid, "bone") > 0 && GetPVarInt(playerid, "modelid") > 0){
        SetPlayerAttachedObject
        (
            playerid,
            GetPVarInt(playerid, "slot"),
            GetPVarInt(playerid, "modelid"),
            GetPVarInt(playerid, "bone"),
            GetPVarFloat(playerid, "num_1"),
            GetPVarFloat(playerid, "num_2"),
            GetPVarFloat(playerid, "num_3"),
            GetPVarFloat(playerid, "num_4"),
            GetPVarFloat(playerid, "num_5"),
            GetPVarFloat(playerid, "num_6"),
            GetPVarFloat(playerid, "num_7"),
            GetPVarFloat(playerid, "num_7"),
            GetPVarFloat(playerid, "num_7"),
            0
        );
}
        return 1;
    }
//-Это в CreateTextDraws, ну или где у вас хранятся текстдравы
	//ТЕКСТ  "РЕЖИМ КАСТОМИЗАЦИЙ"
	#if 0 // legacy acs_TD creation moved out of click handler
	acs_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acs_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acs_TD[0], 1);
	TextDrawColor(acs_TD[0], -1);
	TextDrawBackgroundColor(acs_TD[0], 255);
	TextDrawFont(acs_TD[0], 4);

	//КНОПКА "ВЫХОД"
	acs_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acs_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acs_TD[1], 1);
	TextDrawColor(acs_TD[1], -1);
	TextDrawBackgroundColor(acs_TD[1], 255);
	TextDrawFont(acs_TD[1], 4);
	TextDrawSetSelectable(acs_TD[1], true);

	//КНОПКА "СОХРАНИТЬ"
	acs_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acs_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acs_TD[2], 1);
	TextDrawColor(acs_TD[2], -1);
	TextDrawBackgroundColor(acs_TD[2], 255);
	TextDrawFont(acs_TD[2], 4);
	TextDrawSetSelectable(acs_TD[2], true);

//-НЕ НАЖАТЫЕ КНОПКИ
   	//КНОПКА "ВЛЕВО/ВПРАВО"
	acs_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acs_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[3], 1);
	TextDrawColor(acs_TD[3], -1);
	TextDrawBackgroundColor(acs_TD[3], 255);
	TextDrawFont(acs_TD[3], 4);
	TextDrawSetSelectable(acs_TD[3], true);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acs_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acs_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[4], 1);
	TextDrawColor(acs_TD[4], -1);
	TextDrawBackgroundColor(acs_TD[4], 255);
	TextDrawFont(acs_TD[4], 4);
	TextDrawSetSelectable(acs_TD[4], true);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acs_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[5], 1);
	TextDrawColor(acs_TD[5], -1);
	TextDrawBackgroundColor(acs_TD[5], 255);
	TextDrawFont(acs_TD[5], 4);
	TextDrawSetSelectable(acs_TD[5], true);

	//КНОПКА "МАСШТАБ"
	acs_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acs_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[6], 1);
	TextDrawColor(acs_TD[6], -1);
	TextDrawBackgroundColor(acs_TD[6], 255);
	TextDrawFont(acs_TD[6], 4);
	TextDrawSetSelectable(acs_TD[6], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acs_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acs_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[7], 1);
	TextDrawColor(acs_TD[7], -1);
	TextDrawBackgroundColor(acs_TD[7], 255);
	TextDrawFont(acs_TD[7], 4);
	TextDrawSetSelectable(acs_TD[7], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acs_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acs_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[8], 1);
	TextDrawColor(acs_TD[8], -1);
	TextDrawBackgroundColor(acs_TD[8], 255);
	TextDrawFont(acs_TD[8], 4);
	TextDrawSetSelectable(acs_TD[8], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acs_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acs_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[9], 1);
	TextDrawColor(acs_TD[9], -1);
	TextDrawBackgroundColor(acs_TD[9], 255);
	TextDrawFont(acs_TD[9], 4);
	TextDrawSetSelectable(acs_TD[9], true);

//-НАЖАТЫЕ КНОПКИ
	//КНОПКА "ВЛЕВО/ВПРАВО"
	acs_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acs_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[10], 1);
	TextDrawColor(acs_TD[10], -1);
	TextDrawBackgroundColor(acs_TD[10], 255);
	TextDrawFont(acs_TD[10], 4);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acs_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acs_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[11], 1);
	TextDrawColor(acs_TD[11], -1);
	TextDrawBackgroundColor(acs_TD[11], 255);
	TextDrawFont(acs_TD[11], 4);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acs_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[12], 1);
	TextDrawColor(acs_TD[12], -1);
	TextDrawBackgroundColor(acs_TD[12], 255);
	TextDrawFont(acs_TD[12], 4);

	//КНОПКА "МАСШТАБ"
	acs_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acs_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[13], 1);
	TextDrawColor(acs_TD[13], -1);
	TextDrawBackgroundColor(acs_TD[13], 255);
	TextDrawFont(acs_TD[13], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acs_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acs_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[14], 1);
	TextDrawColor(acs_TD[14], -1);
	TextDrawBackgroundColor(acs_TD[14], 255);
	TextDrawFont(acs_TD[14], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acs_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acs_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[15], 1);
	TextDrawColor(acs_TD[15], -1);
	TextDrawBackgroundColor(acs_TD[15], 255);
	TextDrawFont(acs_TD[15], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acs_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acs_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[16], 1);
	TextDrawColor(acs_TD[16], -1);
	TextDrawBackgroundColor(acs_TD[16], 255);
	TextDrawFont(acs_TD[16], 4);

	//РЕДАКТОР "ВЛЕВО/ВПРАВО"
	acs_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acs_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[17], 1);
	TextDrawColor(acs_TD[17], -1);
	TextDrawBackgroundColor(acs_TD[17], 255);
	TextDrawFont(acs_TD[17], 4);
	TextDrawSetProportional(acs_TD[17], 0);
	TextDrawSetShadow(acs_TD[17], 0);

	//РЕДАКТОР "ВВЕРХ/ВНИЗ"
	acs_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acs_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[18], 1);
	TextDrawColor(acs_TD[18], -1);
	TextDrawBackgroundColor(acs_TD[18], 255);
	TextDrawFont(acs_TD[18], 4);
	TextDrawSetProportional(acs_TD[18], 0);
	TextDrawSetShadow(acs_TD[18], 0);

	//РЕДАКТОР "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acs_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[19], 1);
	TextDrawColor(acs_TD[19], -1);
	TextDrawBackgroundColor(acs_TD[19], 255);
	TextDrawFont(acs_TD[19], 4);
	TextDrawSetProportional(acs_TD[19], 0);
	TextDrawSetShadow(acs_TD[19], 0);

	//РЕДАКТОР "МАСШТАБ"
	acs_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acs_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[20], 1);
	TextDrawColor(acs_TD[20], -1);
	TextDrawBackgroundColor(acs_TD[20], 255);
	TextDrawFont(acs_TD[20], 4);
	TextDrawSetProportional(acs_TD[20], 0);
	TextDrawSetShadow(acs_TD[20], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ X"
	acs_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acs_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[21], 1);
	TextDrawColor(acs_TD[21], -1);
	TextDrawBackgroundColor(acs_TD[21], 255);
	TextDrawFont(acs_TD[21], 4);
	TextDrawSetProportional(acs_TD[21], 0);
	TextDrawSetShadow(acs_TD[21], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Y"
	acs_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acs_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[22], 1);
	TextDrawColor(acs_TD[22], -1);
	TextDrawBackgroundColor(acs_TD[22], 255);
	TextDrawFont(acs_TD[22], 4);
	TextDrawSetProportional(acs_TD[22], 0);
	TextDrawSetShadow(acs_TD[22], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Z"
	acs_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acs_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[23], 1);
	TextDrawColor(acs_TD[23], -1);
	TextDrawBackgroundColor(acs_TD[23], 255);
	TextDrawFont(acs_TD[23], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[23], 0);

	acs_TD[24] = TextDrawCreate(460.0000, 205.0000, "plus");
	TextDrawTextSize(acs_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acs_TD[24], 1);
	TextDrawColor(acs_TD[24], -1);
	TextDrawBackgroundColor(acs_TD[24], 255);
	TextDrawFont(acs_TD[24], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[24], 0);
	TextDrawSetSelectable(acs_TD[24], true);

	acs_TD[25] = TextDrawCreate(530.0000, 205.0000, "minus");
	TextDrawTextSize(acs_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acs_TD[25], 1);
	TextDrawColor(acs_TD[25], -1);
	TextDrawBackgroundColor(acs_TD[23], 255);
	TextDrawFont(acs_TD[25], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[25], 0);
	TextDrawSetSelectable(acs_TD[25], true);
#endif

  
    if(clickedid == buy_car_number_TD[2])
    {
    
        new fmt_text[150];
        if(GetPlayerData(playerid, P_CARREGION_ENTER) == 1)
        {
            if(GetPlayerData(playerid, P_CARNUMBER_ENTER) == 1)
        	{
        		format(fmt_text, sizeof fmt_text, "{FFFFFF}Вы действительно хотите купить данный номер на ваш личный транспорт?");
				Dialog(playerid, DIALOG_DONATE_ACCEPT_CAR_NUM, DIALOG_STYLE_MSGBOX, "{ffcd00}Покупка номера", fmt_text, "Купить", "Отмена");
			}
					else
			    return Send(playerid,-1,"Вы не ввели номер транспорта");
		}
					else
		    return Send(playerid,-1,"Вы не выбрали регион");
    }
    if(clickedid == buy_car_number_TD[3])
    {
        HideBuyCarNumberTextDraws(playerid);
    }
    if(clickedid == buy_car_number_TD[4]) //далее
    {
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
	}
    if(clickedid == buy_car_number_TD[6]) //далее
    {
        TextDrawHideForPlayer(playerid, buy_car_number_TD[1]); //rus
        TextDrawHideForPlayer(playerid, buy_car_number_TD[10]); //kz
        TextDrawHideForPlayer(playerid, buy_car_number_TD[12]); //ua
        TextDrawHideForPlayer(playerid, buy_car_number_TD[13]); //by
        
        TextDrawShowForPlayer(playerid, buy_car_number_TD[1]);
        
        SetPlayerData(playerid, P_CARNUMBER_REGION, 1);
        
        SetPlayerData(playerid, P_CARREGION_ENTER, 1);
	}
	if(clickedid == buy_car_number_TD[7]) //далее
    {
        TextDrawHideForPlayer(playerid, buy_car_number_TD[1]); //rus
        TextDrawHideForPlayer(playerid, buy_car_number_TD[10]); //kz
        TextDrawHideForPlayer(playerid, buy_car_number_TD[12]); //ua
        TextDrawHideForPlayer(playerid, buy_car_number_TD[13]); //by

        TextDrawShowForPlayer(playerid, buy_car_number_TD[10]);

        SetPlayerData(playerid, P_CARNUMBER_REGION, 2);
        
        SetPlayerData(playerid, P_CARREGION_ENTER, 1);
	}
	if(clickedid == buy_car_number_TD[8]) //далее
    {
        TextDrawHideForPlayer(playerid, buy_car_number_TD[1]); //rus
        TextDrawHideForPlayer(playerid, buy_car_number_TD[10]); //kz
        TextDrawHideForPlayer(playerid, buy_car_number_TD[12]); //ua
        TextDrawHideForPlayer(playerid, buy_car_number_TD[13]); //by

        TextDrawShowForPlayer(playerid, buy_car_number_TD[13]);

        SetPlayerData(playerid, P_CARNUMBER_REGION, 3);
        
        SetPlayerData(playerid, P_CARREGION_ENTER, 1);
	}
	if(clickedid == buy_car_number_TD[9]) //далее
    {
        TextDrawHideForPlayer(playerid, buy_car_number_TD[1]); //rus
        TextDrawHideForPlayer(playerid, buy_car_number_TD[10]); //kz
        TextDrawHideForPlayer(playerid, buy_car_number_TD[12]); //ua
        TextDrawHideForPlayer(playerid, buy_car_number_TD[13]); //by

        TextDrawShowForPlayer(playerid, buy_car_number_TD[12]);

        SetPlayerData(playerid, P_CARNUMBER_REGION, 4);
        
        SetPlayerData(playerid, P_CARREGION_ENTER, 1);
	}
    if(clickedid == shop_clothes_TD[1]) //далее
    {

        buffer = GetPlayerSelectSkin(playerid);
		if(!(0 <= ++buffer <= sizeof g_business_clothing_skins[] - 1))
		{
			buffer = 0;
		}
		SetPlayerSelectClothingSkin(playerid, buffer);

		CallLocalFunction("BuySkinPTDUpdate", "i", playerid);


	}
	if(clickedid == shop_clothes_TD[2]) //назад
    {


		buffer = GetPlayerSelectSkin(playerid);
		if(!(0 <= --buffer <= sizeof g_business_clothing_skins[] - 1))
		{
			buffer = sizeof g_business_clothing_skins[] - 1;
		}
		SetPlayerSelectClothingSkin(playerid, buffer);

		CallLocalFunction("BuySkinPTDUpdate", "i", playerid);
	}
	if(clickedid == shop_clothes_TD[3]) //покупка
    {
        buffer = GetPlayerSelectSkin(playerid);
		if(buffer != -1)
		{
			Dialog
			(
				playerid, DIALOG_BIZ_CLOTHING_BUY, DIALOG_STYLE_MSGBOX,
				"{FFCD00}Магазин одежды",
				"{FFFFFF}Вы действительно хотите приобрести этот набор одежды?",
				"Да", "Нет"
			);
		}
	}
	if(clickedid == shop_clothes_TD[4]) //выход
    {
        buffer = GetPlayerSelectSkin(playerid);
		if(buffer != -1)
		{
            ExitPlayerClothingShopPanel(playerid);
		}
	}
	if(clickedid == business_menu_TD[2])
    {
        if(businessid != -1)
		{
        	ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROFIT_STATS);
        	
        	HideBusinessMenuTextDraws(playerid);
		}
					else
		    return Send(playerid, -1, "У вас нету бизнеса");
	}
	if(clickedid == business_menu_TD[3])
    {
        HideBusinessMenuTextDraws(playerid);
	}
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		if(pInfo[playerid][CasinoDiceUiOpen])
		{
			HideCasinoDiceUi(playerid);
			return 1;
		}
		if(GetPlayerPinCodeState(playerid) != PIN_CODE_STATE_NONE)
		{
			HidePlayerPinCodePTD(playerid);
			if(!IsPlayerLogged(playerid))
			{
				Kick:(playerid);
			}
		}
		switch(GetPlayerData(playerid, P_USE_SELECT_PANEL))
		{
			case SELECT_PANEL_TYPE_CLOTHING:
			{
				ExitPlayerClothingShopPanel(playerid);
			}
case SELECT_PANEL_TYPE_REG_SKIN:
{
    // No legacy TextDraw registration alongside Android GUI 38.
    return 1;
}
			case SELECT_PANEL_TYPE_CAR_MARKET:
			{
				SelectTextDraw(playerid, 0x00FF00FF);
			}
			case SELECT_PANEL_TYPE_MOTO_SALON:
			{
				SelectTextDraw(playerid, 0x00FF00FF);
			}
		}
	}
	if(select_TD[0] <= clickedid <= select_TD[3])
	{
		new use_type = GetPlayerData(playerid, P_USE_SELECT_PANEL);
		if(use_type != SELECT_PANEL_TYPE_NONE)
		{
			buffer = 0;
			new index = _:(clickedid - select_TD[0]);


			switch(index)
			{
				case 2: // выбрать
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(buffer != -1)
							{
								Dialog
								(
									playerid, DIALOG_BIZ_CLOTHING_BUY, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Магазин одежды",
									"{FFFFFF}Вы действительно хотите приобрести этот набор одежды?",
									"Да", "Нет"
								);
							}
						}
case SELECT_PANEL_TYPE_REG_SKIN:
{
    // No legacy TextDraw registration alongside Android GUI 38.
    return 1;
}
						case SELECT_PANEL_TYPE_CAR_MARKET:
						{
							if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
							
							ShowBuyCarFamilyAndOwnable(playerid);

						/*	Dialog
							(
								playerid, DIALOG_BIZ_CAR_MARKET_BUY_CAR, DIALOG_STYLE_MSGBOX,
								new price = GetVehicleInfo(model_id-400, VI_PRICE);
								"{00FFFF}"SERVER_NAME"{ffffff} | Автосалон",
								"""SC"Транспортное средство:\t{ffff00}%s (№%d)\n"\
								"{FFFFFF}Выбранное траспортное средство - выглядит весьма\n шикарно. Вы действительно хотите его преобрести?",
								"Далее", "Отмена"
							);*/
						}
						case SELECT_PANEL_TYPE_MOTO_SALON:
						{
							if(GetPlayerInBiz(playerid) != STATIC_BIZ_ID_MOTO_SALON) return 1;

							HidePlayerSelectPanel(playerid);
							ToggleInteractionWindow(playerid, false);
							EnterPlayerBuyCarMarket(playerid, STATIC_BIZ_ID_MOTO_SALON);
						}
					}
				}
				case 1: // вправо
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(!(0 <= ++buffer <= sizeof g_business_clothing_skins[] - 1))
							{
								buffer = 0;
							}
							SetPlayerSelectClothingSkin(playerid, buffer);
						}
case SELECT_PANEL_TYPE_REG_SKIN:
{
    // No legacy TextDraw registration alongside Android GUI 38.
    return 1;
}
						case SELECT_PANEL_TYPE_CAR_MARKET:
						{
							if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
							CarMarketShowNextCar(playerid, '+');
						}
						case SELECT_PANEL_TYPE_MOTO_SALON:
						{
							SelectTextDraw(playerid, 0x00FF00FF);
						}
					}
				}
				case 0: // влево
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							buffer = GetPlayerSelectSkin(playerid);
							if(!(0 <= --buffer <= sizeof g_business_clothing_skins[] - 1))
							{
								buffer = sizeof g_business_clothing_skins[] - 1;
							}
							SetPlayerSelectClothingSkin(playerid, buffer);
						}
case SELECT_PANEL_TYPE_REG_SKIN:
{
    // No legacy TextDraw registration alongside Android GUI 38.
    return 1;
}
						case SELECT_PANEL_TYPE_CAR_MARKET:
						{
							if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;
							CarMarketShowNextCar(playerid, '-');
						}
						case SELECT_PANEL_TYPE_MOTO_SALON:
						{
							SelectTextDraw(playerid, 0x00FF00FF);
						}
					}
				}
				case 3: // закрыть
				{
					switch(use_type)
					{
						case SELECT_PANEL_TYPE_CLOTHING:
						{
							ExitPlayerClothingShopPanel(playerid);
						}
						case SELECT_PANEL_TYPE_CAR_MARKET:
						{
							ExitPlayerBuyCarMarket(playerid);
						}
						case SELECT_PANEL_TYPE_MOTO_SALON:
						{
							HidePlayerSelectPanel(playerid);
							ToggleInteractionWindow(playerid, false);
						}
					}
				}
			}
		}
	}
    return 1;
}

