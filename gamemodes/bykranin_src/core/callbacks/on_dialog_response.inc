//>> Файл: bykranin_src/core/callbacks/on_dialog_response.inc  (23901 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnDialogResponse
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(FsinFull_OnDialogResponse(playerid,dialogid,response,listitem,inputtext)) return 1;
    if(Blogger_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ObjectPlacer_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Construction_OnDialogResponse(playerid, dialogid, response)) return 1;
    if(GarageSys_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(FactionGate_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;

    if(TC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(Market_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
    {
        return 1;
    }

    if(dialogid == DIALOG_ANTIDM_ZONES)
    {
        if(!response) return 1;

        new green_zone_id = GetPlayerListitemValue(playerid, listitem);
        return ShowAntiDmGreenZoneInfo(playerid, green_zone_id);
    }

    if(dialogid == DIALOG_ANTIDM_INFO)
    {
        return ShowAntiDmGreenZonesDialog(playerid);
    }

    if(dialogid == 34150)
    {
        if(!response) return 1;
        return StartAutosalonTestDrive(playerid);
    }

    if(dialogid == DIALOG_ID_INV11_ACC_CUSTOMIZE)
    {
        if(response)
        {
            new acc_slot = GetPVarInt(playerid, "inv11_acc_edit_slot");
            if(!Inv11_OpenAccEditorBySlot(playerid, acc_slot))
            {
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось открыть редактирование аксессуара", " ");
            }
        }

        DeletePVar(playerid, "inv11_acc_edit_slot");
        return 1;
    }

    if(dialogid == DIALOG_INV11_TRADE_SELECT)
    {
        if(!response) return 1;

        if(listitem < 0 || listitem >= g_inv11_trade_dialog_count[playerid])
        {
            return 1;
        }

        new targetid = g_inv11_trade_dialog_target[playerid][listitem];
        if(targetid == -1 || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
            return 1;
        }

        if(!Inv11Trade_IsNear(playerid, targetid, INV11_TRADE_NEAR_RANGE))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок слишком далеко для трейда", " ");
            return 1;
        }

        if(g_inv11_trade_active[playerid] || g_inv11_trade_active[targetid])
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Один из игроков уже в трейде", " ");
            return 1;
        }

        if(g_inv11_trade_invite_from[targetid] != -1 && g_inv11_trade_invite_from[targetid] != playerid && gettime() - g_inv11_trade_invite_time[targetid] <= INV11_TRADE_INVITE_TIMEOUT)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок уже получил другое предложение", " ");
            return 1;
        }

        g_inv11_trade_invite_from[targetid] = playerid;
        g_inv11_trade_invite_time[targetid] = gettime();
        g_inv11_trade_invite_to[playerid] = targetid;

        new wait_msg[128];
        format(wait_msg, sizeof(wait_msg), "Ожидайте принятия трейда от %s", GetPlayerNameEx(targetid));
        SendClientMessage(playerid, 0xFFFFFFFF, wait_msg);
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы отправили предложения трейда, ожидайте принятия.", " ");
        new incoming_msg[128];
        format(incoming_msg, sizeof(incoming_msg), "Игрок %s предлагает вам трейд", GetPlayerNameEx(playerid));
        SendClientMessage(targetid, 0x55CCFFFF, incoming_msg);

        new notify_text[96];
        format(notify_text, sizeof(notify_text), "Предложение от %s", GetPlayerNameEx(playerid));
        ShowNotificationNew(targetid, 4, 6, playerid, 0, notify_text, ">>");

        return 1;
    }

    if(dialogid == DIALOG_INV11_TRADE_CONFIRM)
    {
        new inviter = g_inv11_trade_invite_from[playerid];
        if(inviter == -1)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Предложение не найдено", " ");
            return 1;
        }

        if(!response)
        {
            if(IsPlayerConnected(inviter) && g_inv11_trade_invite_to[inviter] == playerid)
            {
                SendClientMessage(inviter, 0xFFFFFFFF, "Игрок отклонил предложение трейда.");
                g_inv11_trade_invite_to[inviter] = -1;
            }
            Inv11Trade_ResetInvite(playerid);
            return 1;
        }

        if(!IsPlayerConnected(inviter) || !IsPlayerLogged(inviter))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игрок недоступен", " ");
            Inv11Trade_ResetInvite(playerid);
            return 1;
        }

        if(gettime() - g_inv11_trade_invite_time[playerid] > INV11_TRADE_INVITE_TIMEOUT)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Предложение трейда устарело", " ");
            if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
            Inv11Trade_ResetInvite(playerid);
            return 1;
        }

        if(!Inv11Trade_IsNear(playerid, inviter, INV11_TRADE_NEAR_RANGE))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Подойдите ближе к игроку", " ");
            if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
            Inv11Trade_ResetInvite(playerid);
            return 1;
        }

        if(g_inv11_trade_invite_to[inviter] == playerid) g_inv11_trade_invite_to[inviter] = -1;
        Inv11Trade_ResetInvite(playerid);

        if(!Inv11Trade_StartSession(inviter, playerid))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось начать трейд", " ");
            if(IsPlayerConnected(inviter))
            {
                ShowNotificationNew(inviter, 2, 6, 0, 0, "Не удалось начать трейд", " ");
            }
            return 1;
        }

        SendClientMessage(inviter, 0xFFFFFFFF, "Игрок принял предложение трейда.");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вы приняли предложение трейда.");
        ShowNotificationNew(inviter, 3, 6, 0, 0, "Вы начали трейд, у Вас есть 5 минут.", " ");
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы начали трейд, у Вас есть 5 минут.", " ");
        return 1;
    }
    if(dialogid == DIALOG_CONT_NATIVE_BID)
    {
        new contid = pInfo[playerid][BetUseCont];
        if(!response) return 1;
        if(!ContNewSystem_IsValidContainer(contid)) return 1;

        if(!IsPlayerInRangeOfPoint(playerid, ContNewSystem_GetInteractRange(),
            ContBuyTextPos[contid - 1][0],
            ContBuyTextPos[contid - 1][1],
            ContBuyTextPos[contid - 1][2]))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Подойдите ближе к контейнеру", " ");
            return 1;
        }

        new bid_amount = strval(inputtext);
        if(bid_amount <= 0)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Введите корректную сумму ставки", " ");
            return ContNewSystem_OpenNative(playerid, contid);
        }

        ContNewSystem_TryBid(playerid, contid, bid_amount);
        if(cInfo[contid][Saled]) return ContNewSystem_OpenNative(playerid, contid);
        return 1;
    }

    if(dialogid == DIALOG_CONT_NATIVE_REWARD)
    {
        new contid = pInfo[playerid][BuyUseCont];
        if(!response) return 1;
        if(!ContNewSystem_IsValidContainer(contid)) return 1;

        if(!IsPlayerInRangeOfPoint(playerid, ContNewSystem_GetInteractRange(),
            ContBuyTextPos[contid - 1][0],
            ContBuyTextPos[contid - 1][1],
            ContBuyTextPos[contid - 1][2]))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Подойдите ближе к контейнеру", " ");
            return 1;
        }

        switch(listitem)
        {
            case 0: return ContNewSystem_ProcessRewardAction(playerid, contid, false);
            case 1: return ContNewSystem_ProcessRewardAction(playerid, contid, true);
        }
        return 1;
    }

	if(dialogid == DIALOG_CONT_BET)
{
    if(response)
    {
        new cont = pInfo[playerid][BetUseCont];
        if(cont == 0) return printf("ERROR PLAYERID: %d (contuse == 0)");
        if(cInfo[cont][Saled] == true)
        {
            if(cInfo[cont][BetedId] == playerid) return SendClientMessage(playerid, CLR_RED, "{ffffff}Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
            if(0 < strval(inputtext) < 100000000)
            {
                if(GetPlayerMoneyEx(playerid) >= strval(inputtext))
                {
                    if(strval(inputtext)-99999 > cInfo[cont][BetPrice])
                    {
                        if(strval(inputtext) > cInfo[cont][ContPrice] && strval(inputtext) > cInfo[cont][BetPrice])
                        {
                            new strwerton[111];
                            new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
                            if(cInfo[cont][BetedId] != INVALID_PLAYER_ID)
                            {
                                format(strwerton, sizeof strwerton, "{ffffff}Ваша ставка была отменена в связи с тем, что игрок {FF6347}%s {ffffff}поставил больше!", name);
                                SendClientMessage(cInfo[cont][BetedId], CLR_RED, strwerton);
                                
                                // ?? ЗЕЛЁНАЯ НОТИФИКАЦИЯ С РУБЛЁМ - ВОЗВРАТ ДЕНЕГ (ПОЛУЧЕНИЕ)
                                new return_str[64], return_money[32];
                                ConvertMoney(cInfo[cont][BetPrice], return_money);
                                format(return_str, sizeof(return_str), "Вы получили %s рублей", return_money);
                                ShowNotificationNew(cInfo[cont][BetedId], 1, 6, 0, 0, return_str, " ");
                                
                                GivePlayerMoneyEx(cInfo[cont][BetedId], cInfo[cont][BetPrice]);
                            }

                            cInfo[cont][BetPrice] = strval(inputtext);
                            GivePlayerMoneyEx(playerid, -cInfo[cont][BetPrice], "Ставка за контейнер", true, true);
                            cInfo[cont][BetedId] = playerid;
                            format(cInfo[cont][BetedName], MAX_PLAYER_NAME, "%s", name);

                            new betstr[15];
                            ConvertMoney(cInfo[cont][BetPrice], betstr);
                            format(strwerton, sizeof strwerton, " {ffffff}Вы успешно сделали ставку в размере {FF5252}%s {ffffff}рублей за контейнер {FF5252}#%d", betstr, cont);
                            SendClientMessage(playerid, CLR_YELLOW, strwerton);
                            
                            // ?? ЗЕЛЁНАЯ НОТИФИКАЦИЯ БЕЗ РУБЛЯ - УСПЕХ
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Ставка принята успешно!", " ");

                            StartContBidding(cont);
                        }
					else
                        {
                            new strwerton[140], betstr[15];
                            new KRANIN_title[128];
                            format(KRANIN_title, sizeof KRANIN_title, "{FF6347}%s {ffffff}| Битва за контейнер", SERVER_NAME);
                            ConvertMoney(cInfo[cont][BetPrice], betstr);
                            format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                            SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, KRANIN_title, strwerton, "Готово", "Отмена");
                            SendClientMessage(playerid, CLR_RED, " {ffffff}Ваша ставка должна быть выше последней!");
                            
                            // ?? КРАСНАЯ НОТИФИКАЦИЯ БЕЗ РУБЛЯ - ОШИБКА
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Ставка должна быть выше", " ");
                            pInfo[playerid][BetUseCont] = 0;
                        }
                    }
					else
                    {
                        new strwerton[140], betstr[15];
                        new KRANIN_title[128];
                        format(KRANIN_title, sizeof KRANIN_title, "{FF6347}%s {ffffff}| Битва за контейнер", SERVER_NAME);
                        ConvertMoney(cInfo[cont][BetPrice], betstr);
                        format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                        SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, KRANIN_title, strwerton, "Готово", "Отмена");
                        SendClientMessage(playerid, CLR_RED, "{ffffff}Минимальный подьем ставки 100.000 рублей!");
                        
                        // ?? КРАСНАЯ НОТИФИКАЦИЯ БЕЗ РУБЛЯ - ОШИБКА
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Минимальный подъем 100.000 руб", " ");
                        pInfo[playerid][BetUseCont] = 0;
                    }
                }
					else
                {
                    new strwerton[140], betstr[15];
                    new KRANIN_title[128];
                    format(KRANIN_title, sizeof KRANIN_title, "{FF6347}%s {ffffff}| Битва за контейнер", SERVER_NAME);
                    ConvertMoney(cInfo[cont][BetPrice], betstr);
                    format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                    SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, KRANIN_title, strwerton, "Готово", "Отмена");
                    SendClientMessage(playerid, CLR_RED, "{ffffff}У вас недостаточно средств для такой ставки!");
                    
                    // ?? КРАСНАЯ НОТИФИКАЦИЯ БЕЗ РУБЛЯ - ОШИБКА
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно средств", " ");
                    pInfo[playerid][BetUseCont] = 0;
                }
            }
					else
            {
                new strwerton[140], betstr[15];
                new KRANIN_title[128];
                format(KRANIN_title, sizeof KRANIN_title, "{FF6347}%s {ffffff}| Битва за контейнер", SERVER_NAME);
                ConvertMoney(cInfo[cont][BetPrice], betstr);
                format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, KRANIN_title, strwerton, "Готово", "Отмена");
                SendClientMessage(playerid, CLR_RED, "{ffffff}Введите корректную ставку!");
                
                // ?? КРАСНАЯ НОТИФИКАЦИЯ БЕЗ РУБЛЯ - ОШИБКА
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Введите корректную ставку", " ");
                pInfo[playerid][BetUseCont] = 0;
            }
        }
    }
}
    if(dialogid == DIALOG_CASINO_EMPLOYEES)
    {
        if(!response) return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
        new businessid = GetSelectedBusiness(playerid);
        if(!(0 <= businessid < g_business_loaded) || GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO || GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Управление сотрудниками доступно только владельцу казино.");

        switch(listitem)
        {
            case 0: Dialog(playerid, DIALOG_CASINO_HIRE_MANAGER, DIALOG_STYLE_INPUT, "Поставить на менеджера", "Введите ID игрока:", "Предложить", "Назад");
            case 1: Dialog(playerid, DIALOG_CASINO_HIRE_DEALER, DIALOG_STYLE_INPUT, "Поставить на крупье", "Введите ID игрока:", "Предложить", "Назад");
            case 2: Dialog(playerid, DIALOG_CASINO_FIRE_MANAGER, DIALOG_STYLE_INPUT, "Снять менеджера", "Введите ник менеджера:", "Уволить", "Назад");
            case 3: Dialog(playerid, DIALOG_CASINO_FIRE_DEALER, DIALOG_STYLE_INPUT, "Снять крупье", "Введите ник крупье:", "Уволить", "Назад");
            case 4: ShowCasinoEmployeeList(playerid, businessid);
            case 5:
            {
                new balance_text[96];
                format(balance_text, sizeof balance_text, "На балансе казино: {66CC33}%d руб.", GetBusinessData(businessid, B_BALANCE));
                Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Баланс бизнеса", balance_text, "Закрыть", "");
            }
            case 6:
            {
                new withdraw_text[128];
                format(withdraw_text, sizeof withdraw_text, "На балансе казино: {66CC33}%d руб.{FFFFFF}\nВведите сумму для снятия:", GetBusinessData(businessid, B_BALANCE));
                Dialog(playerid, DIALOG_CASINO_WITHDRAW_PROFIT, DIALOG_STYLE_INPUT, "Снять прибыль казино", withdraw_text, "Снять", "Назад");
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_CASINO_WITHDRAW_PROFIT)
    {
        if(!response) return ShowCasinoEmployeesDialog(playerid);
        new businessid = GetSelectedBusiness(playerid);
        if(!(0 <= businessid < g_business_loaded) || GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO || GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Снять прибыль может только владелец этого казино.");
        if(!IsNumeric(inputtext))
        {
            SendClientMessage(playerid, 0xCECECEFF, "Введите корректную сумму.");
            return ShowCasinoEmployeesDialog(playerid);
        }
        new sum = strval(inputtext);
        if(sum <= 0 || sum > GetBusinessData(businessid, B_BALANCE))
        {
            SendClientMessage(playerid, 0xCECECEFF, "На балансе казино нет такой суммы.");
            return ShowCasinoEmployeesDialog(playerid);
        }
        new query[192];
        mysql_format(mysql, query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid) + sum, GetBusinessData(businessid, B_BALANCE) - sum, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
        mysql_query(mysql, query, false);
        if(mysql_errno()) return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку.");
        AddBusinessData(businessid, B_BALANCE, -, sum);
        GivePlayerMoneyEx(playerid, sum, "+ Снятие прибыли казино", false, true);
        SendClientMessage(playerid, 0x66CC00FF, "Прибыль казино успешно снята.");
        return ShowCasinoEmployeesDialog(playerid);
    }    if(dialogid == DIALOG_CASINO_HIRE_MANAGER || dialogid == DIALOG_CASINO_HIRE_DEALER || dialogid == DIALOG_CASINO_MANAGER_HIRE)
    {
        if(!response) return dialogid == DIALOG_CASINO_MANAGER_HIRE ? ShowCasinoManagerDialog(playerid) : ShowCasinoEmployeesDialog(playerid);
        new businessid = dialogid == DIALOG_CASINO_MANAGER_HIRE ? GetPlayerManagedCasino(playerid) : GetSelectedBusiness(playerid);
        new to_player = strval(inputtext);
        new required_job = dialogid == DIALOG_CASINO_HIRE_MANAGER ? 2 : 1;
        if(!(0 <= businessid < g_business_loaded) || GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO) return 1;
        if(required_job == 2 && GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Только владелец казино может назначать менеджеров.");
        if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
        if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");
        if(GetPlayerData(to_player, P_CASINO_JOB)) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже работает в казино");
        SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUSINESS_MANAGER, businessid, required_job);
        return 1;
    }
    if(dialogid == DIALOG_CASINO_FIRE_MANAGER || dialogid == DIALOG_CASINO_FIRE_DEALER || dialogid == DIALOG_CASINO_MANAGER_FIRE)
    {
        if(!response) return dialogid == DIALOG_CASINO_MANAGER_FIRE ? ShowCasinoManagerDialog(playerid) : ShowCasinoEmployeesDialog(playerid);
        new businessid = dialogid == DIALOG_CASINO_MANAGER_FIRE ? GetPlayerManagedCasino(playerid) : GetSelectedBusiness(playerid);
        new to_player = GetPlayerID(inputtext);
        new required_job = dialogid == DIALOG_CASINO_FIRE_MANAGER ? 2 : 1;
        if(!(0 <= businessid < g_business_loaded)) return 1;
        if(dialogid != DIALOG_CASINO_MANAGER_FIRE && GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid)) return 1;
        if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
        {
            new query[192];
            mysql_format(mysql, query, sizeof query, "SELECT id,casino_job,casino_business FROM accounts WHERE name='%e' LIMIT 1", inputtext);
            new Cache:employee_cache = mysql_query(mysql, query, true);
            if(!cache_num_rows(employee_cache) || cache_get_field_content_int(0, "casino_business") != businessid || cache_get_field_content_int(0, "casino_job") != required_job)
            {
                cache_delete(employee_cache);
                return SendClientMessage(playerid, 0xCECECEFF, "Сотрудник с таким ником и должностью не найден");
            }
            new employee_account = cache_get_field_content_int(0, "id");
            cache_delete(employee_cache);
            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET casino_job=0,casino_business=-1 WHERE id=%d LIMIT 1", employee_account);
            mysql_query(mysql, query, false);
            return SendClientMessage(playerid, 0x66CC00FF, "Сотрудник уволен из казино.");
        }
        if(GetPlayerData(to_player, P_CASINO_BUSINESS) != businessid || GetPlayerData(to_player, P_CASINO_JOB) != required_job) return SendClientMessage(playerid, 0xCECECEFF, "У игрока нет указанной должности в Вашем казино");
        SetCasinoEmployment(to_player, -1, 0);
        SendClientMessage(to_player, 0xFF9900FF, "Вы были уволены из казино.");
        SendClientMessage(playerid, 0x66CC00FF, "Сотрудник уволен из казино.");
        return 1;
    }
    if(dialogid == DIALOG_CASINO_MANAGER_MENU)
    {
        if(!response) return 1;
        new businessid = GetPlayerManagedCasino(playerid);
        if(businessid == -1) return SendClientMessage(playerid, 0xCECECEFF, "Вы не являетесь менеджером казино.");
        switch(listitem)
        {
            case 0: ShowCasinoEmployeeList(playerid, businessid);
            case 1: Dialog(playerid, DIALOG_CASINO_MANAGER_FIRE, DIALOG_STYLE_INPUT, "Увольнение крупье", "Введите ник крупье:", "Уволить", "Назад");
            case 2: Dialog(playerid, DIALOG_CASINO_MANAGER_HIRE, DIALOG_STYLE_INPUT, "Приём крупье", "Введите ID игрока:", "Предложить", "Назад");
        }
        return 1;
    }

    if(dialogid == DIALOG_CASINO_JOB_SELECT)
    {
        if(!response) return 1;

        pInfo[playerid][CasinoDiceBetPaid] = false;
        pInfo[playerid][CasinoDiceBetPaidTable] = 0;

        switch(GetPlayerData(playerid, P_CASINO_JOB))
        {
            case 1:
            {
                pInfo[playerid][CasinoDealerJob] = true;
                pInfo[playerid][CasinoManagerJob] = false;
                SetPlayerSkin(playerid, 173);
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы надели форму крупье", " ");
            }
            case 2:
            {
                pInfo[playerid][CasinoDealerJob] = false;
                pInfo[playerid][CasinoManagerJob] = true;
                SetPlayerSkin(playerid, 170);
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы надели форму менеджера", " ");
            }
            default: return SendClientMessage(playerid, 0xCECECEFF, "Вы не работаете в казино.");
        }
        return 1;
    }

    if(dialogid == DIALOG_CASINO_JOB_QUIT)
    {
        if(!response) return 1;

        if(pInfo[playerid][CasinoDealerJob] || pInfo[playerid][CasinoManagerJob])
        {
            for(new idx = 0; idx < sizeof g_casino_table_dealer; idx++)
            {
                if(g_casino_table_dealer[idx] != playerid) continue;

                g_casino_table_dealer[idx] = INVALID_PLAYER_ID;
                g_casino_table_bet[idx] = 1000;
                g_casino_table_bet_set[idx] = false;

                if(g_casino_round_active[idx]) StopCasinoDiceRound(idx);
            }
        }

        if(pInfo[playerid][CasinoDiceUiOpen])
        {
            HideCasinoDiceUi(playerid);
        }

        pInfo[playerid][CasinoDealerJob] = false;
        pInfo[playerid][CasinoManagerJob] = false;
        pInfo[playerid][CasinoDiceBetPaid] = false;
        pInfo[playerid][CasinoDiceBetPaidTable] = 0;

        SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));
        ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы сняли рабочую форму", " ");
        return 1;
    }
    if(dialogid == DIALOG_CASINO_TABLE_SETBET)
    {
        if(!response)
        {
            if(pInfo[playerid][CasinoDiceUiOpen]) SelectTextDraw(playerid, 0xFF5252FF);
            return 1;
        }

        if(!pInfo[playerid][CasinoDiceUiOpen]) return 1;

        new table_idx = pInfo[playerid][CasinoDiceTable] - 1;
        if(!(0 <= table_idx < sizeof g_casino_table_pos))
        {
            HideCasinoDiceUi(playerid);
            return ShowNotificationNew(playerid, 2, 6, 0, 0, "Стол больше недоступен", " ");
        }
        if(!IsPlayerCasinoDealer(playerid, table_idx))
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Только крупье или менеджер может установить ставку", " ");
            return 1;
        }

        if(g_casino_round_active[table_idx])
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Игра уже началась", " ");
            return 1;
        }

        new bet = strval(inputtext);
        if(!(1000 <= bet <= 1000000000))
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

        g_casino_table_bet[table_idx] = bet;
        g_casino_table_bet_set[table_idx] = true;
        pInfo[playerid][CasinoDiceBet] = bet;
        ResetCasinoTablePaidPlayers(table_idx);

        RefreshCasinoDicePlayersListForTable(table_idx);
        ShowNotificationNew(playerid, 3, 6, 0, 0, "Ставка успешно установлена", " ");

        if(pInfo[playerid][CasinoDiceUiOpen]) SelectTextDraw(playerid, 0xFF5252FF);

        return 1;
    }

    if(dialogid == DIALOG_CASINO_TABLE_TARGET)
    {
        if(!response)
        {
            if(pInfo[playerid][CasinoDiceUiOpen]) SelectTextDraw(playerid, 0xFF5252FF);
            return 1;
        }

        if(!IsPlayerInRangeOfAnyCasinoTable(playerid))
        {
            HideCasinoDiceUi(playerid);
            return SendClientMessage(playerid, 0x999999FF, "You left the casino table area");
        }

        new target = strval(inputtext);
        if(!IsPlayerConnected(target) || target == playerid)
        {
            SendClientMessage(playerid, 0x999999FF, "Invalid player ID");
            ShowPlayerDialog(playerid, DIALOG_CASINO_TABLE_TARGET, DIALOG_STYLE_INPUT, "Casino: Opponent", "Enter player ID for invite", "Send", "Cancel");
            return 1;
        }

        if(!IsPlayerLogged(target))
        {
            SendClientMessage(playerid, 0x999999FF, "Player is not authorized");
            ShowPlayerDialog(playerid, DIALOG_CASINO_TABLE_TARGET, DIALOG_STYLE_INPUT, "Casino: Opponent", "Enter player ID for invite", "Send", "Cancel");
            return 1;
        }

        new lobby_bet = pInfo[playerid][CasinoDiceBet];
        if(!(1 <= lobby_bet <= 1000000)) lobby_bet = 1000;

        new cmd_params[32];
        format(cmd_params, sizeof cmd_params, "%d %d", target, lobby_bet);

        callcmd::dice(playerid, cmd_params);

        HideCasinoDiceUi(playerid);

        return 1;
    }
    // ================================
    // ?? DIALOG_ID_EDITACS_SELECT
    // ================================
	if(dialogid == DIALOG_ID_EDITACS_SELECT)
    {
        if(!response) return 1; // Нажал "Отмена"

        new slot = -1;
        new tmp = 0;
        
        for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, i))
            {
                if(tmp == listitem)
                {
                    slot = i;
                    break;
                }
                tmp++;
            }
        }

        if(slot == -1 || !IsPlayerAttachedObjectSlotUsed(playerid, slot))
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка: Неверный слот.");
            return 1;
        }

        SetPVarInt(playerid, "EditingAccSlot", slot);
        ShowEditAccessoryDialog(playerid, slot);
        return 1;
    }

    // ================================
    // ?? DIALOG_ID_EDITACS_EDIT
    // ================================
    if(dialogid == DIALOG_ID_EDITACS_EDIT)
    {
        if(!response) return 1;

        new slot = GetPVarInt(playerid, "EditingAccSlot");
        if(!IsValidAccessorySlot(playerid, slot))
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка: Неверный слот.");
            return 1;
        }

        if(listitem == 6) // Сохранить изменения
        {
            if(SaveAccessoryChanges(playerid, slot))
            {
                SendClientMessage(playerid, -1, "{00FF00}Изменения успешно сохранены в базу данных!");
            }
            return 1;
        }

        SetPVarInt(playerid, "EditingAccParam", listitem);
        
        new param_names[6][] = {"Z", "Y", "X", "RotX", "RotY", "RotZ"};
        new dialog_text[512];
        
        format(dialog_text, sizeof(dialog_text),
            "Выбран параметр: %s\n\
            \n{FFFF00}=== Варианты изменения ===\n\
            Переместить в положительную сторону (+)\n\
            Переместить в отрицательную сторону (-)\n\
            Ввести значение вручную",
            param_names[listitem]
        );
        
        ShowPlayerDialog(playerid, DIALOG_ID_EDITACS_MOVE_OPTIONS, DIALOG_STYLE_LIST, 
                        "{FFD700}Выбор действия", dialog_text, "Выбрать", "Назад");
        return 1;
    }

	if (dialogid == 1337 && GetPVarInt(playerid, "MySkin_Dialog"))
    {
        DeletePVar(playerid, "MySkin_Dialog");

        if (!response) return 1;

        new query[128];
        new accountid = GetPlayerAccountID(playerid);
        mysql_format(mysql, query, sizeof(query), "SELECT modelid FROM invskins WHERE account_id = %d ORDER BY purchased_at DESC LIMIT %d,1", accountid, listitem);
        new Cache:result = mysql_query(mysql, query, true);

        if (cache_get_row_count() > 0)
        {
            new modelid = cache_get_field_content_int(0, "modelid");
            SetPlayerSkin(playerid, modelid);
            SetPlayerData(playerid, P_SKIN, modelid);
            UpdatePlayerDatabaseInt(playerid, "skin", modelid);
            SetPlayerSkinInit(playerid);
            SendClientMessage(playerid, 0x90EE90FF, "Скин успешно надет!");
        }
        cache_delete(result);
        return 1;
    }

    if(dialogid == 1500)
    {
        if(!response) 
        {
            SendClientMessage(playerid, -1, "Вы отменили выбор спавна.");
            return 1;
        }
        
        switch(listitem)
        {
            case 0: // Арзамас спавн
            {
                SetPlayerPosEx(playerid, 846.6026, 796.5558, 13.4005, 69.8969, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Арзамас спавн");
            }
            case 1: // Южный спавн
            {
                SetPlayerPosEx(playerid, 2740.7122, -2441.5652, 21.7743, 269.2484, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Южный спавн");
            }
            case 2: // Лыткарино спавн
            {
                SetPlayerPosEx(playerid, -2429.2361, 203.1753, 26.0961, 176.7121, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Лыткарино спавн");
            }
            case 3: // Батырево спавн
            {
                SetPlayerPosEx(playerid, 1801.6941, 2523.1377, 14.6026, 109.9816, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Батырево спавн");
            }
            case 4: // Нижегородск спавн
            {
                SetPlayerPosEx(playerid, -2667.5266, 2006.5670, 11.1978, 176.4970, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Нижегородск спавн");
            }
            case 5: // Южный вокзал Нижегородска
            {
                SetPlayerPosEx(playerid, -2159.3711, 1558.1033, 9.8409, 84.5195, 0, 0, false);
                SendClientMessage(playerid, -1, "Вы телепортировались на: Южный вокзал Нижегородска");
            }
        }
        
        SetPlayerInterior(playerid, 0);
        SetPlayerVirtualWorld(playerid, 0);
        
        return 1;
    }


    // ================================
    // ?? DIALOG_ID_EDITACS_INPUT
    // ================================
    if(dialogid == DIALOG_ID_EDITACS_INPUT)
    {
        if(!response || !strlen(inputtext)) 
        {
            new slot = GetPVarInt(playerid, "EditingAccSlot");
            ShowEditAccessoryDialog(playerid, slot);
            return 1;
        }

        new slot = GetPVarInt(playerid, "EditingAccSlot");
        new param_index = GetPVarInt(playerid, "EditingAccParam");

        if(!IsValidAccessorySlot(playerid, slot) || param_index < 0 || param_index >= 6)
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка: Неверные данные для изменения.");
            return 1;
        }

        new Float:new_value = floatstr(inputtext);
        
        if(UpdateAccessoryParameter(playerid, slot, param_index, new_value))
        {
            ShowEditAccessoryDialog(playerid, slot);
        }
        return 1;
    }

    // ================================
    // ?? DIALOG_TUNING (меню тюнинга)
    // ================================
    if(dialogid == DIALOG_TUNING)
    {
        if(!response) return 1;

        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid == 0) return SendClientMessage(playerid, -1, "Вы должны быть в транспорте!");

        switch(listitem)
        {
            case 0: { SetVehicleTonerr(vehicleid, 0xFF000000, 0xFF000000, 0xFF000000, 0xFF000000, 1); SendClientMessage(playerid, -1, "Тонер установлен!"); }
            case 1: { SetVehicleSportForPlayer(playerid, vehicleid, 1); SendClientMessage(playerid, -1, "SPORT+ включен!"); }
            case 2: { SetVehicleSportForPlayer(playerid, vehicleid, 0); SendClientMessage(playerid, -1, "SPORT+ выключен!"); }
            case 3: { SetVehicleHydraulics(vehicleid, 1, 1); SendClientMessage(playerid, -1, "Hydraulics установлена."); }
            case 4: { PlayAudioStreamURL(playerid, "http://ck10636.tw1.ru/test.mp3"); SendClientMessage(playerid, -1, "Музыка включена."); }
            case 5: { StopAudioStream(playerid); SendClientMessage(playerid, -1, "Музыка остановлена."); }
            case 6: { SetVehicleNumberPlateEx(vehicleid, 1, "ADSE", "95"); SendClientMessage(playerid, -1, "Номерные знаки установлены."); }
            case 7: { SetVehicleLaunchControl(vehicleid, 1, 1); SendClientMessage(playerid, -1, "Launch Control активирован."); }
            case 8: { SetVehicleHighLight(vehicleid, 1, 1); SendClientMessage(playerid, -1, "Подсветка включена."); }
            case 9: { SetVehicleSpeedometerInfoFP(playerid, vehicleid, 120.0, 130.0); SendClientMessage(playerid, -1, "Спидометр обновлен."); }
            case 10:{ SetVehicleLightingColor(vehicleid, 0xFF0000FF, 0x00FF00FF, 0x0000FFFF, 2); SendClientMessage(playerid, -1, "Неон установлен."); }
           
         }
        return 1;
    } // <-- эта скобка закрывает if(dialogid == DIALOG_TUNING)

if(dialogid == DIALOG_ID_EDITACS_MOVE_OPTIONS)
{
    if(!response) 
    {
        // Вернуться к основному меню
        new slot = GetPVarInt(playerid, "EditingAccSlot");
        ShowEditAccessoryDialog(playerid, slot);
        return 1;
    }

    new slot = GetPVarInt(playerid, "EditingAccSlot");
    new param_index = GetPVarInt(playerid, "EditingAccParam");
    
    if(!IsValidAccessorySlot(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: Неверный слот.");
        return 1;
    }

    const Float:STEP = 0.01;
    new Float:current_value = GetAccessoryParamValue(playerid, slot, param_index);
    new Float:new_value;

    switch(listitem)
    {
        case 3: // Переместить в положительную сторону
        {
            new_value = current_value + STEP;
            UpdateAccessoryParameter(playerid, slot, param_index, new_value);
            ShowEditAccessoryDialog(playerid, slot);
        }
        case 4: // Переместить в отрицательную сторону
        {
            new_value = current_value - STEP;
            UpdateAccessoryParameter(playerid, slot, param_index, new_value);
            ShowEditAccessoryDialog(playerid, slot);
        }
        case 5: // Ввести значение вручную
        {
            new param_names[6][] = {"Z", "Y", "X", "RotX", "RotY", "RotZ"};
            new dialog_input[128];
            format(dialog_input, sizeof(dialog_input), "Введите новое значение для %s (текущее: %.6f):", param_names[param_index], current_value);
            ShowPlayerDialog(playerid, DIALOG_ID_EDITACS_INPUT, DIALOG_STYLE_INPUT, "{FFD700}Изменение параметра", dialog_input, "ОК", "Отмена");
            return 1;
        }
    }
    return 1;
}
if(dialogid == 8977) //
{
        if(response)
        {
        player_sell_ownable_car[playerid] = false;
        
          new rand = random(sizeof(gViezd));
		  new vehicleID = GetPlayerVehicleID(playerid);

          SetPlayerVirtualWorld(playerid, 0);
          SetPlayerInterior(playerid, 0);
     
          new veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, gViezd[rand][0],gViezd[rand][1],gViezd[rand][2]);
          SetVehicleZAngle(veh, gViezd[rand][3]);
          SetVehicleVirtualWorld(veh, 0);
          SetPlayerVirtualWorld(playerid, 0);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,0);
          SetPlayerInterior(playerid,0);
          DestroyVehicleLabel(veh);
          
          PutPlayerInVehicle(playerid, veh, 0);
          SetCameraBehindPlayer(playerid);
          DestroyVehicleLabel(veh);
          
          ownable_car_sell_status[veh] = false;
          return true;
        }
					else return 1;
}

if(dialogid == 8968) //
{
        if(response)
        {
                if(!strlen(inputtext)) // этта проверка проверяет, если игрок ничего не ввел в окно, тогда действие
                {
                        ShowPlayerDialog(playerid,8968,DIALOG_STYLE_INPUT,"{00FFFF}"SERVER_NAME"{FFFFFF} | Подготовка к продаже транспорта","Вам необходимо ввести цену, за которую Вы хотите\nпродать свой транспорт в диалоговое поле ниже:","Готово","Отмена");
                        return 1;
                }
  if(strval(inputtext))  // проверяем строка состоит из натуральных чисел
                {
                         new nrbpack = strval(inputtext); // если да то создаем переменную и преобразуем строку в число и приравниваем
                         new veh = GetPlayerOwnableCar(playerid);
                         
                         for(new i = 0; i < MAX_PLAYERS; i++)
		  {
          if(IsPlayerInVehicle(i, veh))

          SetPlayerVirtualWorld(i, 101);
          SetPlayerInterior(i, 1);
          SetCameraBehindPlayer(i);
          }
                         
          new rand = random(sizeof(gVezd));
          SetVehiclePos(veh, gVezd[rand][0],gVezd[rand][1],gVezd[rand][2]);
          SetVehicleZAngle(veh, gVezd[rand][3]);
          SetVehicleVirtualWorld(veh, 101);
          SetPlayerVirtualWorld(playerid, 101);
          SetCameraBehindPlayer(playerid);
          LinkVehicleToInterior(veh,1);
          SetPlayerInterior(playerid,1);
       
         ToggleLock(playerid, veh);
         player_sell_ownable_car[playerid] = true;
       
         new Float: x, Float: y, Float: z;
         GetVehiclePos(veh, x, y, z);
         new modelid = GetVehicleModel(veh);
         SetVehicleZAngle(veh, gVezd[rand][3]);
       
          new info[354];
          
          if(!GetPlayerPhone(playerid))
          {
            format(info, sizeof info, "{FFFFFF}%s\n{2BB1FF}Транспорт игрока:{FFFFFF} %s\n{2BB1FF}Цена продажи:{FFFFFF} %d руб\n{2BB1FF}Госс цена:{FFFFFF} %d руб\n\nДля покупки введите {ffff00}/buycar", GetVehicleName(veh), GetPlayerNameEx(playerid), nrbpack, GetVehicleInfo(modelid - 400, VI_PRICE));
            CreateVehicleLabel(veh, info, 0x2BB1FFFF, x, y, z + 1, 5.0);
            }
					else {
          format(info, sizeof info, "{FFFFFF}%s\n{2BB1FF}Транспорт игрока:{FFFFFF} %s\n{2BB1FF}Номер телефона игрока:{FFFFFF} %d\n{2BB1FF}Цена продажи:{FFFFFF} %d руб\n{2BB1FF}Госс цена:{FFFFFF} %d руб\n\nДля покупки введите {ffff00}/buycar", GetVehicleName(veh), GetPlayerNameEx(playerid), GetPlayerPhone(playerid), nrbpack, GetVehicleInfo(modelid - 400, VI_PRICE));
            CreateVehicleLabel(veh, info, 0x2BB1FFFF, x, y, z + 1, 5.0);
            }
            
            new ownable_index = GetVehicleData(veh, V_ACTION_ID);
            if(ownable_index < 0) return SendClientMessage(playerid, 0xFF6600FF, "Произошла ошибка подготовки транспорта к продаже");
            SetOwnableCarData(ownable_index, OC_LAST_PRICE, nrbpack);
            SetOwnableCarData(ownable_index, OC_LAST_OWNER_GAME_ID, playerid);
            
            SetTimerEx("tp_buy", 500, false, "d", playerid);
		
		   ownable_car_sell_status[veh] = true;
		
		SendClientMessage(playerid, 0xCECECEFF, "{ffff00}| {ffffff}Чтобы убрать транспорт с продажи введите {ffff00}/unsellmycar");
		SendClientMessage(playerid, 0xCECECEFF, "{ffff00}| {ffffff}Чтобы продать транспорт игроку введите {ffff00}/sellmycar");
			
          return true;
                }
					else ShowPlayerDialog(playerid,8968,DIALOG_STYLE_INPUT,"{00FFFF}"SERVER_NAME"{FFFFFF} | Подготовка к продаже транспорта","Вам необходимо ввести цену, за которую Вы хотите\nпродать свой транспорт в диалоговое поле ниже:","Готово","Отмена");								
        }
					else
        {
                // тут если он нажал на кнопку 2
                SendClientMessage(playerid, 0xCECECEFF, "Вы отказались от продажи");
        }
}

if(dialogid == DIALOG_SELLCARMY)
{
	new offer_id = GetPlayerOfferInfo(playerid, O_INCOMING_PLAYER);
	new offer_type = GetPlayerOfferInfo(playerid, O_INCOMING_TYPE);
	new value_1 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[0];
	new value_2 = GetPlayerOfferInfo(playerid, O_INCOMING_VALUE)[1];

	if(!response)
	{
		if(offer_id != INVALID_PLAYER_ID && IsPlayerConnected(offer_id) && GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) == playerid)
		{
			ClearPlayerOffer(offer_id);
			SendClientMessage(offer_id, 0xCECECEFF, "Игрок отказался от покупки Вашего транспорта");
		}
		ClearPlayerOffer(playerid);
		return 1;
	}

	if(offer_type != OFFER_TYPE_SELL_OWNABLE_CAR || offer_id == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "Предложение о покупке транспорта не найдено");

	if(!IsPlayerConnected(offer_id) || !IsPlayerLogged(offer_id))
	{
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Продавец недоступен для сделки");
	}

	if(GetPlayerOfferInfo(offer_id, O_OUTCOMIG_PLAYER) != playerid)
	{
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Сделка больше неактуальна");
	}

	if(GetPlayerOwnableCar(offer_id) != value_2)
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Продавец больше не владеет этим транспортом");
	}

	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
	}

	if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "У вас нет свободных слотов для транспорта");
	}

	if(!IsValidVehicle(value_2))
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Транспорт недоступен для покупки");
	}

	new Float:car_x, Float:car_y, Float:car_z;
	GetVehiclePos(value_2, car_x, car_y, car_z);

	if(!(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(offer_id, 15.0, car_x, car_y, car_z)))
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Вы и продавец должны находиться рядом с транспортом");
	}

	if(GetPlayerMoneyEx(playerid) < value_1)
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно денег для покупки");
	}

	new index = GetVehicleData(value_2, V_ACTION_ID);
	if(index < 0 || !IsAOwnableCar(value_2))
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка покупки");
	}

	if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(offer_id))
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка: владелец транспорта изменился");
	}

	new fmt_str[144];
	format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, fmt_str, false);

	if(mysql_errno())
	{
		ClearPlayerOffer(offer_id);
		ClearPlayerOffer(playerid);
		return SendClientMessage(playerid, 0xFF6600FF, "Произошла ошибка в базе данных");
	}

	ClearPlayerOffer(offer_id);
	ClearPlayerOffer(playerid);

	GivePlayerMoneyEx(playerid, -value_1, "Продажа авто с рук", false, true);
	GivePlayerMoneyEx(offer_id, value_1, "Продажа авто с рук", true, true);

	SetOwnableCarData(index, OC_OWNER_ID, GetPlayerAccountID(playerid));
	SetOwnableCarData(index, OC_LAST_OWNER_GAME_ID, INVALID_PLAYER_ID);
	SetOwnableCarData(index, OC_LAST_PRICE, 0);

	player_sell_ownable_car[offer_id] = false;
	ownable_car_sell_status[value_2] = false;
	DestroyVehicleLabel(value_2);

	if(GetPlayerOwnableCar(offer_id) == value_2)
		UnloadPlayerOwnableCar(offer_id, true);
	else
		SetPlayerData(offer_id, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

	SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

	format(fmt_str, sizeof fmt_str, "{FFFFFF}Игрок{ffff00} %s {FFFFFF}продал Вам свой транспорт за{ffff00} %d руб", GetPlayerNameEx(offer_id), value_1);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Транспорт добавлен в Ваш автопарк");
	SendClientMessage(playerid, 0xFFFFFFFF, "{FFFFFF}Загрузите транспорт через {ffff00}/car");

	format(fmt_str, sizeof fmt_str, "Вы продали свой транспорт игроку %s за %d руб", GetPlayerNameEx(playerid), value_1);
	SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

	return 1;
}
if(dialogid == DIALOG_SELLCAR)
{
	if(!response) return 1;

	new vehicleid = GetNearestVehicleID(playerid, 5.0);
	if(vehicleid == INVALID_VEHICLE_ID || !ownable_car_sell_status[vehicleid])
		return SendClientMessage(playerid, 0xCECECEFF, "Этот транспорт больше не продается");

	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(index < 0)
		return SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка покупки");

	new offer_id = GetOwnableCarData(index, OC_LAST_OWNER_GAME_ID);
	new value_1 = GetOwnableCarData(index, OC_LAST_PRICE);

	if(!IsPlayerConnected(offer_id) || !IsPlayerLogged(offer_id))
		return SendClientMessage(playerid, 0xCECECEFF, "Продавец недоступен для сделки");

	if(GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(offer_id))
		return SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка: владелец транспорта изменился");

	if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");

	if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "У вас нет свободных слотов для транспорта");

	if(GetPlayerMoneyEx(playerid) < value_1)
		return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно денег для покупки");

	new fmt_str[144];
	format(fmt_str, sizeof fmt_str, "UPDATE ownable_cars SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), GetOwnableCarData(index, OC_SQL_ID));
	mysql_query(mysql, fmt_str, false);

	if(mysql_errno())
		return SendClientMessage(playerid, 0xFF6600FF, "Произошла ошибка в базе данных");

	GivePlayerMoneyEx(playerid, -value_1, "Продажа авто с рук", false, true);
	GivePlayerMoneyEx(offer_id, value_1, "Продажа авто с рук", true, true);

	SetOwnableCarData(index, OC_OWNER_ID, GetPlayerAccountID(playerid));
	SetOwnableCarData(index, OC_LAST_OWNER_GAME_ID, INVALID_PLAYER_ID);
	SetOwnableCarData(index, OC_LAST_PRICE, 0);

	player_sell_ownable_car[offer_id] = false;
	ownable_car_sell_status[vehicleid] = false;
	DestroyVehicleLabel(vehicleid);

	if(GetPlayerOwnableCar(offer_id) == vehicleid)
		UnloadPlayerOwnableCar(offer_id, true);
	else
		SetPlayerData(offer_id, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

	SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

	new rand = random(sizeof(gViezd));
	SetPlayerPos(offer_id, gViezd[rand][0], gViezd[rand][1], gViezd[rand][2]);
	SetPlayerVirtualWorld(offer_id, 0);
	SetPlayerInterior(offer_id, 0);
	SetCameraBehindPlayer(offer_id);

	format(fmt_str, sizeof fmt_str, "%s продал Вам свой транспорт за %d руб", GetPlayerNameEx(offer_id), value_1);
	SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	SendClientMessage(playerid, 0x66CC00FF, "Транспорт добавлен в Ваш автопарк");
	SendClientMessage(playerid, 0xFFFFFFFF, "Загрузите транспорт через {ffff00}/car");

	format(fmt_str, sizeof fmt_str, "Вы продали свой транспорт игроку %s за %d руб", GetPlayerNameEx(playerid), value_1);
	SendClientMessage(offer_id, 0x66CC00FF, fmt_str);

	return 1;
}
if(dialogid == 8987) //подарочное авто
    {
        if(response)
        {
    new vehicleid2 = GetPlayerVehicleID(playerid);
    new color_1 = GetVehicleData(vehicleid2, V_COLOR_1);
    new color_2 = GetVehicleData(vehicleid2, V_COLOR_2);
    new modelid = GetVehicleData(vehicleid2, V_MODELID);
    DestroyVehicleLabel(vehicleid2);
    DestroyVehicle(vehicleid2);
    
    new Float:POS[4];
    GetPlayerPos(playerid, POS[0],POS[1],POS[2]);
    GetPlayerFacingAngle(playerid, POS[3]);
     
    new Float: pos_x = POS[0];
	new Float: pos_y = POS[1];
	new Float: pos_z = POS[2];
	new Float: angle = POS[3];

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
	
	CreateVehicle(modelid, 9999, 9999, 9999, 0, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, 1);
	
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
	PutPlayerInVehicle(playerid, vehicleid, 0);
	DestroyVehicleLabel(vehicleid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
		//index = GetVehicleData(vehicleid, V_ACTION_ID);
  		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
    	ApplyOwnableCarStoredPlate(vehicleid, idx);
		SetVehicleParam(vehicleid, V_LOCK, false);
		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

    new fmt_text[300];
	format(fmt_text, sizeof fmt_text, "{ff00ff}Игрок %s[%d] завершил мероприятие ''Сядь - получи транспорт'' найдя и получив транспорт", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(0xFF5533FF, fmt_text);
    DestroyVehicleLabel(vehicleid);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    return 1;
        }
        return 1;
    }

if(dialogid == 1098)
    {
        return SRAdmin_HelpResponse(playerid, response, listitem);
    }

			 if(dialogid == DIALOG_MCHS_LIST)
{
    if(response)
    {
         SetPlayerCheckpoint(playerid, 2446.472412,-204.271026,2.138540, 13.0);
    }
}

if(dialogid == DIALOG_RENT_MAIN && response)
    {
        if(listitem == 0) // Скутер
        {
            RentScooter(playerid);
        }
					else // Личный транспорт
        {
            new vehicle_id = GetPlayerListitemValue(playerid, listitem);
            RentPersonalVehicle(playerid, vehicle_id);
        }
    }

if(dialogid == DIALOG_MCHS_AVTO)
{
    if(response)
    {
         FireSystemShowVehicleSelect(playerid);
    }
    return 1;
}

if(dialogid == DIALOG_MCHS)
{
    if(response)
    {
        SetPlayerSkin(playerid, 23);
        SetPlayerHealth(playerid, 100);
        SetPlayerArmour(playerid, 100);
    }
}
			
			if(dialogid == DIALOG_INVENTORYTEST)
			{
	if(response)
	    {
			switch(listitem)
			    {
			case 0:
			{
			callcmd::healme(playerid, "");
			}
			case 1:
			{
			callcmd::mask(playerid, "");
			}
			}
			}
			}
			
		if(dialogid == DIALOG_ACS_EDIT)
			{

				if(response)

				{

				  	CreateAcsTextDraw(playerid);

HideHud(playerid);


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

					SetPVarInt(playerid, "acs_use", 1);

					SetPVarInt(playerid, "updateacs", 1);

				}
					else

				{

					SetPVarInt(playerid, "acs_use", 0);

				}

			}
			
			if(dialogid == DIALOG_VODOLAZACTOR)
{
	if(response)
	    {
			switch(listitem)
			    {
			        case 1:
			            {
			                ShowPlayerDialog(playerid, 1562, DIALOG_STYLE_MSGBOX, "Потверждение", "Вы действительно хотите устроиться водолазом?", "Далее", "Отмена");
							return 1;
			            }
    				case 0:
			            {
							if(vodolazrabota[playerid] == true)
							{
								if(vodolod[playerid] == false)
								{
								    ShowPlayerDialog(playerid, 1561, DIALOG_STYLE_LIST, "Выберите лодку для аренды", "Рулевой катер", "Далее", "Отмена");
								}
					else return SendClientMessage(playerid, -1, "Вы уже арендуете лодку");
							}
					else return SendClientMessage(playerid, -1, "Для аренды нужно устроиться на работу водолаза");
			            }
       				case 2:
			            {
			                if(mestolootgo[playerid][0][0] == true)
			                {
			                    ShowPlayerDialog(playerid, 1563, DIALOG_STYLE_LIST, "Продажа найденных предметов", "Загадочный ящик      2498 рублей", "Выбрать", "Отмена");
							}
					else return 1;
			            }
			    }
	    }
}

if(dialogid == 1562)
	{
	    if(response)
			{
			    new skin;
   				if(vodolazrabota[playerid] == false)
       			{
				vodolazrabota[playerid] = true;
				skin = GetPlayerSkin(playerid);
				SetPlayerSkin(playerid, 5344);
				}
			}
	}
	
			if(dialogid == DIALOG_FERMA)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			ShowPlayerDialog(playerid, DIALOG_FERMAHELP, DIALOG_STYLE_LIST, "Помощь по работе",
			"Комбайнер\n\
			Сборщик урожая",
			"Выбрать", "Закрыть" );
			}
			case 1:
			{
			ShowPlayerDialog(playerid, DIALOG_FERMABEGIN, DIALOG_STYLE_LIST, "Начать / Закончить рабочий день",
			"Водитель комбайна\n\
			Сброщик урожая",
			"Выбрать", "Закрыть" );
			}
			case 2:
			{
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно арендовали квадроцикл");
			new vehicleid = CreateVehicle(471, 1645.256103,1302.107055,12.086381,144.799621, 1, 1, -1);
			}
			}
			}
			}
			if(dialogid == DIALOG_FERMAHELP)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			ShowPlayerDialog(playerid, 99998, DIALOG_STYLE_MSGBOX, "Информация о ферме",
			"Водитель комбайн - работа, где Вам предстоит добывать урожай с полей, используя специальный транспорт.\n\
			Чтобы начать работу - Вам необходимо лицензия категории B.\n\
			На ферме множество необработанных площадок, за которыми требуется регулярно собирать урожай",
			"Закрыть", "" );
			}
			}
			}
			}
			if(dialogid == DIALOG_FERMABEGIN)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			ShowPlayerDialog(playerid, DIALOG_FERMAKOMB, DIALOG_STYLE_LIST, "Водитель комбайна",
			"Начать\n\
			Закончить", 
			"Выбрать", "Закрыть" );
			}
			case 1:
			{
			ShowPlayerDialog(playerid, DIALOG_FERMASBOR, DIALOG_STYLE_LIST, "Сборщик урожая",
			"Начать\n\
            Закончить",
			"Выбрать", "Закрыть" ); 
			}
			}
			}
			}
			
			if(dialogid == DIALOG_FERMAKOMB)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			}
			}
			}
			}
			if(dialogid == DIALOG_FERMASBOR)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно начали работу Сборщик урожая");
			SendClientMessage(playerid, COLOR_WHITE, "Арендуйте квадроцикл и отправляйтесь на место отмечено на карте");
			SetPlayerSkin(playerid, 259);
			SetPVarInt(playerid,"InUroga",1);
            SetPVarInt(playerid,"Uroga",1);
            SetPlayerCheckpoint(playerid, urogcheck[1][0], urogcheck[1][1], urogcheck[1][2], 2.0);
			}
			case 1:
			{

		    GivePlayerMoneyEx(playerid, GetPVarInt(playerid, "UrogMoney"), "kyr", true, true);
			SetPlayerSkin(playerid, GetPVarInt(playerid, "GetPlayerSkin"));
			DeletePVar(playerid, "GetPlayerSkin(playerid, P_SKIN)");
			DeletePVar(playerid, "InUroga");
			DeletePVar(playerid, "Uroga");
			DeletePVar(playerid, "UrogMoney");
			}
			}
			}
			} 
			if(dialogid == DIALOG_LAREK)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -250);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 1:
			{
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -100);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 2:
			{
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, 80);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 3:
			{
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -50);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 4:
			{
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 5");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -200);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 5:
			{
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 6");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -70);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 6:
			{
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 6");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -100);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			case 7:
			{
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 6");
			SetPlayerHealthEx(playerid, 5);
			GivePlayerMoneyEx(playerid, -90);
			SendClientMessage(playerid, COLOR_WHITE, "Вы успешно покушали и ваше здоровье было повышено");
			}
			}
			}
			} 
			
			if(dialogid == DIALOG_ADDREWARD)
			{
	if(response)
		{
			switch(listitem)
			{
			case 0:
			{
			new str[184];

			format(str, sizeof str, " Ведите сумму которую хотите выдать в поле ниже");

			Dialog(playerid, DIALOG_ADDMONEY, DIALOG_STYLE_INPUT, "Выдача игровой валюты", str, "Выбрать", "Закрыть");
			
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
			
			}
			case 1:
			{
			new str[184];

			format(str, sizeof str, " Ведите сумму которую хотите выдать в поле ниже");

			Dialog(playerid, DIALOG_ADDDONATE, DIALOG_STYLE_INPUT, "Выдача донат валюты", str, "Выбрать", "Закрыть");
			
			//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
			}
			case 2:
			{
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
            }
            case 3:
            {
            new str[184];

			format(str, sizeof str, " Ведите id скина который хотите выдать в поле ниже");

			Dialog(playerid, DIALOG_ADDSKIN, DIALOG_STYLE_INPUT, "Выдача скина", str, "Выбрать", "Закрыть");
			
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
            }
            case 4:
            {
            new str[184];

			format(str, sizeof str, " Ведите сумму которую хотите выдать в поле ниже");

			Dialog(playerid, DIALOG_ADDEPOINTS, DIALOG_STYLE_INPUT, "Выдача епоинтов", str, "Выбрать", "Закрыть");
			
		//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 5");
            }
            }
			}
			} 
			
    if(dialogid == DIALOG_ADDMONEY)
    {
        if (response)
        {
            new amount = strval(inputtext);
           // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Вы выдали рубли"); // Для отладки
            
            if (amount > 0 && amount <= 10000000)
            {
                GivePlayerMoneyEx(playerid, amount); // Убедитесь, что эта функция существует
                SendClientMessage(playerid, COLOR_WHITE, "Вы успешно выдали деньги!");
            }
					else
            {
                SendClientMessage(playerid, COLOR_RED, "Введите корректную сумму! Сумма должна быть положительной и не превышать 1000000000.");
            }
        }
    }
    
    if(dialogid == DIALOG_ADDDONATE)
    {
        if (response)
        {
            new amount = strval(inputtext);
           // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Вы выдали донат рубли"); // Для отладки
            
            if (amount > 0 && amount <= 1000000000)
            {
                GivePlayerDonateRub(playerid, amount); // Убедитесь, что эта функция существует
                SendClientMessage(playerid, COLOR_WHITE, "Вы успешно выдали деньги!");
            }
					else
            {
                SendClientMessage(playerid, COLOR_RED, "Введите корректную сумму! Сумма должна быть положительной и не превышать 1000000000.");
            }
        }
    }
    if(dialogid == DIALOG_ADDSKIN)
    {
        if (response)
        {
            new amount = strval(inputtext);
            //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Вы выдали скин"); // Для отладки
            
            if (amount > 0 && amount <= 10000000)
            {
                SetPlayerData(playerid, P_SKIN, amount);
					UpdatePlayerDatabaseInt(playerid, "skin", amount);
					SetPlayerSkinInit(playerid);
                SendClientMessage(playerid, COLOR_WHITE, "Вы успешно выдали скин!");
            }
					else
            {
                SendClientMessage(playerid, COLOR_RED, "Введите корректный id! id должен быть положительной и не превышать 10000.");
            }
        }
    }
    if(dialogid == DIALOG_ADDEPOINTS)
    {
        if (response)
        {
            new amount = strval(inputtext);
           // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Вы выдали епоинты"); // Для отладки
            
            if (amount > 0 && amount <= 1000000000)
            {
                AddPlayerData(playerid, P_ACOINS, +, amount);
	           UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) + 450);
                SendClientMessage(playerid, COLOR_WHITE, "Вы успешно выдали епоинты!");
            }
					else
            {
                SendClientMessage(playerid, COLOR_RED, "Введите корректную сумму! Сумма должна быть положительной и не превышать 1000000000.");
            }
        }
    }
    


	
			
			if(dialogid == DIALOG_ACS_EDIT)
			{
				if(response)
				{
				  	CreateAcsTextDraw(playerid);
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
					SetPVarInt(playerid, "acs_use", 1);
					SetPVarInt(playerid, "updateacs", 1);
				}
					else
				{
					SetPVarInt(playerid, "acs_use", 0);
				}
			}
			
			if (dialogid == DIALOG_START_QUEST) {
        if (response) 
{ // Если игрок нажал "Понял"
            // Здесь можно добавить код для перемещения игрока к Злой Зине
            SendClientMessage(playerid, COLOR_WHITE, "Вы направляетесь к Злой Зине...");
            // Предположим, что координаты Злой Зины (например, 1000.0, 2000.0, 10.0)
            SetPlayerPos(playerid, 1051.383789,2032.698730,14.418960);
        }
					else 
{
            SendClientMessage(playerid, COLOR_RED, "Вы отменили квест.");
            g_PlayerQuestState[playerid] = QUEST_NOT_STARTED;
        }
    }
					else 
if (dialogid == DIALOG_END_QUEST)
 {
        if (response) 
{ // Если игрок нажал "Спасибо"
            // Завершение квеста и выдача денег
            GivePlayerMoney(playerid, 100000); // Выдаем 100 денег
            SendClientMessage(playerid, COLOR_WHITE, "Вы получили 100000 денег за выполнение квеста!");
            g_PlayerQuestState[playerid] = QUEST_COMPLETED;
        }
    }

if(dialogid == DIALOG_ADMSHOP)
{
	if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new str[184];

					format(str, sizeof str, "Чтобы обменять Адм-Коины вы должны написать количество Адм-Коинов для конвертации\nКоличество AC: %d\n{FF0000}! {FFFFFF}Важно: 1 Адм-Коины = 1 Донат-руб\nВведите число снизу и нажмите Выбрать", GetPlayerData(playerid, P_ACOINS));

					Dialog(playerid, DIALOG_CONVERT_ADMSHOP, DIALOG_STYLE_INPUT, "Конвертация Адм-Коинов", str, "Выбрать", "Закрыть");
				}
				case 1:
				{
					Dialog(playerid, DIALOG_SKIN_ADMSHOP, DIALOG_STYLE_LIST, 
					"Выберите одежду", 
					""SC" Одежда CJ  | 450 epoints\n"\
					""SC" Одежда Администрации  | 1000 epoints\n"\
					""SC" Вин Дизель | 150 epoints\n"\
					""SC" Аниме-тян | 150 epoints\n"\
					""SC" Мужчина на Коньках | 500 epoints", 
					"Выбрать", "Закрыть");
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
				}
				case 2:
				{
					Dialog(playerid, DIALOG_VIP_ADMSHOP, DIALOG_STYLE_LIST, "Выберите VIP", ""SC" Vip Silver | 15 дней | 100 Epoint\n"SC" Vip Gold | 15 дней | 150 EP\n"SC" Vip Platinum | 15 дней | 200 EP", "Купить", "Закрыть");
					//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
				}
				case 3:
				{
					Dialog
					(
						playerid, DIALOG_VEH_ADMSHOP, DIALOG_STYLE_LIST,
					"Выберите транспорт", 
					""SC"Купить Слот для транспорта | 100 AC\n\
					"SC" Monster | 6000 epoints\n\
					"SC" Лимузин | 3500 epoints\n\
					"SC" BMW M5 F90 | 15000 epoints\n\
					"SC" ГАЗ ТИГР | 10000 epoints\n\
					"SC" БТР | 25000 epoints", 
					"Выбрать", "Закрыть"
					);
					//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
				}
			}
		}
}
if(dialogid == DIALOG_CONVERT_ADMSHOP)
{
	new fmt_text[256],
	acoins_amount = strval(inputtext);

	if(1 <= acoins_amount <= GetPlayerData(playerid, P_ACOINS))
		{
			if(acoins_amount >  GetPlayerData(playerid, P_ACOINS))
			{
				format(fmt_text, sizeof fmt_text, "Недостаточно средств. Сейчас на Вашем счету %d Рублей", GetPlayerData(playerid, P_ACOINS));
				SendClientMessage(playerid, 0xCECECEFF, fmt_text);
				return 0;
			}
				AddPlayerData(playerid, P_ACOINS, -, acoins_amount);

				UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) > 450);
				
				format(fmt_text, sizeof fmt_text, "~g~+$%d~n~~y~-$%d", acoins_amount, acoins_amount );
				GameTextForPlayer(playerid, fmt_text, 4000, 1);

				format(fmt_text, sizeof fmt_text, "Конвертация epoints %d в донат валюту", acoins_amount);

				GivePlayerDonateRub(playerid, acoins_amount, fmt_text, true, true);
				//UpdateDonate(playerid, GetPlayerMoney(playerid), GetPlayerDonateRub(playerid));

				SendClientMessage(playerid, -1, ""SC" Вы конвертировали epoints");

			return 1;
		}
}
if(dialogid == DIALOG_SKIN_ADMSHOP)
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 450)
				{
					SendClientMessage(playerid, -1, ""SC" Вы купили Одежду \"CJ\" за epoints");
					AddPlayerData(playerid, P_ACOINS, -, 450);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 450);
					SetPlayerData(playerid, P_SKIN, 1);
					UpdatePlayerDatabaseInt(playerid, "skin", 1);
					SetPlayerSkinInit(playerid);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
				}

			}
			case 1:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 1000)
				{
					SendClientMessage(playerid, -1, ""SC" Вы купили Одежду \"Администрации\" за epoints");
					AddPlayerData(playerid, P_ACOINS, -, 1000);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 1000);
					SetPlayerData(playerid, P_SKIN, 122);
					UpdatePlayerDatabaseInt(playerid, "skin", 122);
					SetPlayerSkinInit(playerid);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
				}

			}
			case 2:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 150)
				{
					SendClientMessage(playerid, -1, ""SC" Вы купили Одежду \"Вин Дизель\" за epoints");
					AddPlayerData(playerid, P_ACOINS, -, 150);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 150);
					SetPlayerData(playerid, P_SKIN, 25);
					UpdatePlayerDatabaseInt(playerid, "skin", 25);
					SetPlayerSkinInit(playerid);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
				}

			}
			case 3:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 150)
				{
					SendClientMessage(playerid, -1, ""SC" Вы купили Одежду \"Аниме-тян\" за epoints");
					AddPlayerData(playerid, P_ACOINS, -, 150);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 150);
					SetPlayerData(playerid, P_SKIN, 225);
					UpdatePlayerDatabaseInt(playerid, "skin", 225);
					SetPlayerSkinInit(playerid);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
				}

			}
			case 4:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 500)
				{
					SendClientMessage(playerid, -1, ""SC" Вы купили Одежду \"Мужчины на Коньках\" за epoints");
					AddPlayerData(playerid, P_ACOINS, -, 500);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 500);
					SetPlayerData(playerid, P_SKIN, 99);
					UpdatePlayerDatabaseInt(playerid, "skin", 99);
					SetPlayerSkinInit(playerid);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 5");
				}

			}
		}
	}
}
if(dialogid == DIALOG_VIP_ADMSHOP)
{
	if(response)
	{
		new prem_day,prem_month,prem_year,premium = GetPlayerPremium(playerid),
		fmt_text[128];

		switch(listitem)
		{
			case 0:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 100)
				{

			        if(!premium)
			        {
						SetPlayerData(playerid, P_PREMIUM, 1);
			            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 15 * 86400);
					}
					else
					{
					    AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);
					}


					timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

					format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {D13B00}VIP Silver{FFFFFF} до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
					SendClientMessage(playerid, -1, fmt_text);

					UpdatePlayerDatabaseInt(playerid, "premium", 1);
					UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

					AddPlayerData(playerid, P_ACOINS, -, 100);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 100);
				//	SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
				}

			}
			case 1:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 150)
				{

			        if(!premium)
			        {
						SetPlayerData(playerid, P_PREMIUM, 2);
			            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 15 * 86400);
					}
					else
					{
					    AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);
					}


					timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

					format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {838383}VIP Gold{FFFFFF} до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
					SendClientMessage(playerid, -1, fmt_text);

					UpdatePlayerDatabaseInt(playerid, "premium", 2);
					UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

					AddPlayerData(playerid, P_ACOINS, -, 150);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 150);
					//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
				}

			}
			case 2:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 200)
				{

			        if(!premium)
			        {
						SetPlayerData(playerid, P_PREMIUM, 3);
			            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 15 * 86400);
					}
					else
					{
					    AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);
					}


					timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

					format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {FDD700}VIP Platinum{FFFFFF} до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
					SendClientMessage(playerid, -1, fmt_text);

					UpdatePlayerDatabaseInt(playerid, "premium", 3);
					UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

					AddPlayerData(playerid, P_ACOINS, -, 200);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 200);
					//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
				}

			}
		}
	}
}
if(dialogid == DIALOG_VEH_ADMSHOP)
{
	if(response)
	{
		switch(listitem)
		{
			case 0:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 100)
				{
					UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
					AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
					AddPlayerData(playerid, P_ACOINS, -, 100);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 100);
					//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
				}

			}
			case 1:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 6000)
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, ""USC"Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/donate или /epoints");    

					GivePlayerCar(playerid, 444, 0, 0);

					SendClientMessage(playerid, -1, ""SC" Вы купили транспорт \"Monster\" за epoints");

					AddPlayerData(playerid, P_ACOINS, -, 6000);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 6000);
					// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
				}
			}
			case 2:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 3500)
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, ""USC"Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/donate или /admshop");    

					GivePlayerCar(playerid, 409, 0, 0);

					SendClientMessage(playerid, -1, ""SC" Вы купили транспорт \"Лимузин\" за epoints");

					AddPlayerData(playerid, P_ACOINS, -, 3500);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 3500);
					// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
				}

			}
			case 3:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 15000)
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, ""USC"Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/donate или /admshop");    

					GivePlayerCar(playerid, 596, 0, 0);

					SendClientMessage(playerid, -1, ""SC" Вы купили транспорт \"BMW M5 F90\" за epoints");

					AddPlayerData(playerid, P_ACOINS, -, 15000);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 15000);
					// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
				}

			}
			case 4:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 10000)
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, ""USC"Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/donate или /admshop");    

					GivePlayerCar(playerid, 470, 0, 0);

					SendClientMessage(playerid, -1, ""SC" Вы купили транспорт \" ГАЗ ТИГР\" за epoints");

					AddPlayerData(playerid, P_ACOINS, -, 10000);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 10000);
					// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 5");
				}

			}
			case 5:
			{
				if(GetPlayerData(playerid, P_ACOINS) >= 25000)
				{
					if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
					return SendClientMessage(playerid, 0x3399FFFF, ""USC"Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/donate или /admshop");    

					GivePlayerCar(playerid, 601, 0, 0);

					SendClientMessage(playerid, -1, ""SC" Вы купили транспорт \"БТР\" за epoints");

					AddPlayerData(playerid, P_ACOINS, -, 25000);
					UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(playerid, P_ACOINS) - 25000);
					// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 6");
				}

			}
		}
	}
}			
			
			
			
if(dialogid == DIALOG_STTSKIN)
{
    if(response)
    {
        switch(listitem)
        {
        case 0:SetPlayerSkin(playerid, 25);
        case 1:SetPlayerSkin(playerid, 234);
        case 2:SetPlayerSkin(playerid, 11);
        case 3:SetPlayerSkin(playerid, 235);
        case 4:SetPlayerSkin(playerid, 249);
        case 5:SetPlayerSkin(playerid, 266);
        case 6:SetPlayerSkin(playerid, 200);
        }
    }
    return 1;
}
if(dialogid == DIALOG_ADMIN_GIVEACS_LIST)
{
    if(!response)
    {
        gGiveAcsTarget[playerid] = INVALID_PLAYER_ID;
        return 1;
    }

    new target = gGiveAcsTarget[playerid];
    if(!IsPlayerConnected(target) || !IsPlayerLogged(target))
    {
        gGiveAcsTarget[playerid] = INVALID_PLAYER_ID;
        SendClientMessage(playerid, 0x999999FF, "Игрок вышел с сервера.");
        return 1;
    }

    const items_per_page = 30;
    new total = AccessoryGetNonDonateCount();
    if(total <= 0) return 1;

    new max_page = (total - 1) / items_per_page;
    new page = gGiveAcsDialogPage[playerid];
    if(page < 0) page = 0;
    if(page > max_page) page = max_page;

    new start = page * items_per_page;
    new items_on_page = total - start;
    if(items_on_page > items_per_page) items_on_page = items_per_page;

    new menu_pos = items_on_page;
    new prev_pos = -1;
    new next_pos = -1;
    if(page > 0) prev_pos = menu_pos++;
    if(page < max_page) next_pos = menu_pos++;

    if(listitem == prev_pos) return ShowAdminGiveAcsDialog(playerid, page - 1);
    if(listitem == next_pos) return ShowAdminGiveAcsDialog(playerid, page + 1);
    if(listitem < 0 || listitem >= items_on_page) return 1;

    new ordinal = start + listitem;
    new acs = AccessoryGetNonDonateIndexByOrdinal(ordinal);
    if(acs < 0) return 1;

    AdminGiveAccessoryAndOfferEdit(playerid, target, acs);
    gGiveAcsTarget[playerid] = INVALID_PLAYER_ID;
    return 1;
}

if(dialogid == DIALOG_ADMIN_GIVEACS_EDIT_OFFER)
{
    new database = gGiveAcsPendingDatabase[playerid];
    gGiveAcsPendingDatabase[playerid] = 0;

    if(!response || database == 0) return 1;

    // /giveacs already equipped the item into its dedicated slot 1..3.
    // Only open the editor; calling UseAccessory here would remap the slot by bone.
    EditAccessory(playerid, database);
    return 1;
}

if (dialogid == 9999)
{
    if (response)
    {
        new account_id = GetPlayerAccountID(playerid);

        if (account_id <= 0)
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка: аккаунт не загружен.");
            printf("[ERROR] account_id <= 0 для игрока %d", playerid);
            return 1;
        }

        const items_per_page = 30;
        new total = sizeof(accessory);
        if(total <= 0) return 1;

        new max_page = (total - 1) / items_per_page;
        new page = gAcsDialogPage[playerid];
        if(page < 0) page = 0;
        if(page > max_page) page = max_page;

        new start = page * items_per_page;
        new items_on_page = total - start;
        if(items_on_page > items_per_page) items_on_page = items_per_page;

        new menu_pos = items_on_page;
        new prev_pos = -1;
        new next_pos = -1;

        if(page > 0) prev_pos = menu_pos++;
        if(page < max_page) next_pos = menu_pos++;

        new remove_pos = menu_pos;

        if(listitem == prev_pos) return ShowAcsDialog(playerid, page - 1);
        if(listitem == next_pos) return ShowAcsDialog(playerid, page + 1);

        if(listitem == remove_pos)
        {
            RemoveAllAccessories(playerid);

            new query[384];
            format(query, sizeof(query), "DELETE FROM accessories WHERE account_id = %d", account_id);
            printf("[DEBUG] SQL на удаление: %s", query);
            mysql_query(mysql, query);

            SendClientMessage(playerid, -1, "{FF4500}Внимание:{FFFFFF} Все аксессуары были сняты.");
            return 1;
        }

        if(listitem < 0 || listitem >= items_on_page) return 1;

        new selected = start + listitem;
        new modelid = accessory[selected][ID_ACCESSORY];

        new acc_index = FindAccsDataIndexByModel(modelid);
        if(acc_index == -1)
        {
            printf("[ERROR] Не найдены настройки AccsData для modelid=%d", modelid);
            SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Неверный аксессуар.");
            return 1;
        }

        const cost = 1000000;
        if (GetPlayerMoney(playerid) < cost)
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} У вас недостаточно денег для надевания аксессуара.");
            return 1;
        }

        GivePlayerMoney(playerid, -cost);

        new message[256];
        format(message, sizeof(message), "{00FF00}Успех:{FFFFFF} Вы потратили {FFD700}%d рублей{FFFFFF} на надевание аксессуара.", cost);
        strcat(message, " {00CED1}Для редактирования используйте /editacs.");
        SendClientMessage(playerid, -1, message);

        new slot = -1;
        for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
        {
            if(!IsPlayerAttachedObjectSlotUsed(playerid, i))
            {
                slot = i;
                break;
            }
        }

        if(slot == -1)
        {
            SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Все слоты для аксессуаров заняты.");
            return 1;
        }

        if (AccsData[acc_index][accModel] <= 0)
        {
            printf("[ERROR] Неверная модель аксессуара для acc_index=%d", acc_index);
            SendClientMessage(playerid, -1, "{FF0000}Ошибка:{FFFFFF} Неверный аксессуар.");
            return 1;
        }
if (AccsData[acc_index][accBone] > 0 && AccsData[acc_index][accModel] > 0){
        SetPlayerAttachedObject(
            playerid,
            slot,
            AccsData[acc_index][accModel],
            AccsData[acc_index][accBone],
            AccsData[acc_index][accX], AccsData[acc_index][accY], AccsData[acc_index][accZ],
            AccsData[acc_index][accRotX], AccsData[acc_index][accRotY], AccsData[acc_index][accRotZ],
            AccsData[acc_index][accScaleX], AccsData[acc_index][accScaleY], AccsData[acc_index][accScaleZ]
        );
}
        gPlayerTempAccData[playerid][slot][0] = float(AccsData[acc_index][accModel]);
        gPlayerTempAccData[playerid][slot][1] = float(AccsData[acc_index][accBone]);
        gPlayerTempAccData[playerid][slot][2] = AccsData[acc_index][accX];
        gPlayerTempAccData[playerid][slot][3] = AccsData[acc_index][accY];
        gPlayerTempAccData[playerid][slot][4] = AccsData[acc_index][accZ];
        gPlayerTempAccData[playerid][slot][5] = AccsData[acc_index][accRotX];
        gPlayerTempAccData[playerid][slot][6] = AccsData[acc_index][accRotY];
        gPlayerTempAccData[playerid][slot][7] = AccsData[acc_index][accRotZ];
        gPlayerTempAccData[playerid][slot][8] = AccsData[acc_index][accScaleX];
        gPlayerTempAccData[playerid][slot][9] = AccsData[acc_index][accScaleY];
        gPlayerTempAccData[playerid][slot][10] = AccsData[acc_index][accScaleZ];

        new query[512];
        format(query, sizeof(query),
            "REPLACE INTO accessories (account_id, slot, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z) \
             VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f)",
            account_id,
            slot,
            AccsData[acc_index][accModel],
            AccsData[acc_index][accBone],
            AccsData[acc_index][accX], AccsData[acc_index][accY], AccsData[acc_index][accZ],
            AccsData[acc_index][accRotX], AccsData[acc_index][accRotY], AccsData[acc_index][accRotZ],
            AccsData[acc_index][accScaleX], AccsData[acc_index][accScaleY], AccsData[acc_index][accScaleZ]
        );

        printf("[DEBUG] REPLACE SQL: %s", query);
        mysql_query(mysql, query);
    }
}	if(dialogid == DIALOG_REPORT_SELECTOR)
	{
		if(response)
		{
			Dialog(playerid, DIALOG_REPORT_CLAIM, DIALOG_STYLE_INPUT,
				"{00CC00}"SERVER_NAME" {FFFFFF}| Жалоба",
				"Введите текст жалобы для администрации сервера:",
				"Готово", "Закрыть");
		}
		return 1;
	}
if(dialogid == DIALOG_REPORT_CLAIM)
{
    if(response) return ReportGUI_Submit(playerid, inputtext, true);
    return 1;
}
if(dialogid == DIALOG_RESERVED_SUPPORT_EDIT)
{
    if(!GetPVarInt(playerid, "REPORT_GUI_ACTIVE")) return 1;
    if(!response)
    {
        SetPVarInt(playerid, "REPORT_GUI_CUSTOM", 0);
        new targetid = GetPVarInt(playerid, "ANS_TARGET"), report_text[256];
        GetPVarString(playerid, "ANS_TEXT", report_text, sizeof report_text);
        if(IsPlayerConnected(targetid)) return ReportGUI_Show(playerid, targetid, report_text);
        return ReportGUI_RequeueActive(playerid);
    }
    if(!strlen(inputtext))
        return Dialog(playerid, DIALOG_RESERVED_SUPPORT_EDIT, DIALOG_STYLE_INPUT, "Свой ответ на репорт", "Введите текст ответа:", "Отправить", "Назад");
    new custom_answer[144];
    format(custom_answer, sizeof custom_answer, "%s", inputtext);
    utf8_to_cp1251(custom_answer);
    return ReportGUI_SendAnswer(playerid, custom_answer);
}
if (dialogid == DIALOG_SETADMINS)
{
    return SRAdmin_AssignmentResponse(playerid, response, listitem);
}


    if(dialogid == DLG_ASKIN)
	    {
	        if(response)
	        {
				switch(listitem)
				{
			 		case 0:
			 		{
			   			SetPlayerSkin(playerid, 122);
  // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
					}
					case 1:
					{
			    		SetPlayerSkin(playerid, 25);
  // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
					}
				}
			}
		}
	if(dialogid == DLG_MYSKIN)
        {
            if(response)
            {
			    
				
                return 1;
            }
					else
            {
                return 1;
            }
        }
        
if (dialogid == DIALOG_ADMHELP)
{
    if (!response) return 1;

    switch (listitem)
    {
        case 0: callcmd::ahelp(playerid); // Команды администрации
    }
    return 1;
}


	if(dialogid == DLG_MAPTRUE)
    {
       if(response)
       {
			new vehicleid = GetPlayerVehicleID(playerid);
			if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) 
			{
			SetVehiclePos(vehicleid, pos[playerid][0], pos[playerid][1], pos[playerid][2]);
			ShowNotificationNew(playerid, 3, 2, 0, 0, "Вы переместились на отмеченную точку!", "");
			return 1;
			}
			SetPlayerInterior(playerid,0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerPos(playerid, pos[playerid][0], pos[playerid][1], pos[playerid][2]);
			 SetTimerEx("FixPlayerZ", 500, false, "i", playerid);
			ShowNotificationNew(playerid, 3, 2, 0, 0, "Вы переместились на отмеченную точку!", "");
        }
					else
        {
			ShowNotificationNew(playerid, 3, 2, 0, 0, "Вы отменили перемещение!", "");
			return 1;
    	}
    }
	if(dialogid == DIALOG_CREATE_FAMILY666)
        {
            if(response)
                {
                    Dialog
                    (
                        playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
                        "{FF0000}Создание семьи",
                        "{FFFFFF}Здесь вы можете создать свою семью.\n\
                        {FFFFFF}Цена:{ffff00} 3.000.000 рублей.",
                        "Далее", "Выйти"
                    );
					return 1;
                }
					else
                {
                    return 1;
                }
        }

	switch(dialogid)
	{
			case 5004:
			  {
					if(response)
			   		{
						switch(listitem)//kinder
						{
				 			case 0:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в Центральную больницу.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
				 			}
							case 1:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в Армию.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
				  			}
							case 2:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в Правительство.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
							case 3:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в ГИБДД.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
							case 4:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в ФСБ.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
							case 5:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в ФСИН.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
							case 6:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в УМВД.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
							case 7:
							{
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Здравствуйте жители Нижегородской области!");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]На данный момент проходит собеседование в СМИ.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Критерии: 2 года в области, лицензии, мед карта.");
								SendClientMessageToAll(0xfefaffAA, "{3366CC}[Гос-Новости]Собеседование продлится 30 минут!");
							}
						}
					 }
			  	}
		case 17172:
		    {
		        if(response)
		        {
		            switch(listitem)
		            {
		                case 0: SetLaunchControl(playerid), GivePlayerMoneyEx(playerid, -20000, "лаунч", true, true), SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы успешно купили лаунч-контроль!");
		                case 1: DelLaunchControl(playerid), GivePlayerMoneyEx(playerid, -1000, "лаунч", true, true), SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы успешно удалили лаунч-контроль!");
					}
				}
					else ShowTuneShowPlayerDialog(playerid);
			}
				
	    case 9873:
        {
			if(!response)
			{
				SetCameraBehindPlayer(playerid);
				ShowTuneShowPlayerDialog(playerid);
				return true;
			}
            if(GetPlayerMoneyEx(playerid) >= 5_000)
            {
                new color1 = strval(inputtext), fmt_text[256],
                idx = GetPVarInt(playerid, "ownablecar_id");

                if(!(-1 <= color1 <= 128))
                {
                    SendClientMessage(playerid, 0xCECECEFF, "Цвет транспорт от 0 до 255");
                    new all_colors_str[1808], color_str[15];

                    for(new idxx; idxx < 128; idxx ++)
                    {
                        format(color_str, sizeof color_str, "{%06x}%d | ", VehicleColoursTableRGBA[idxx]>>> 8, idxx);
                        strcat(all_colors_str, color_str);
                        if(!(idxx % 10)) strcat(all_colors_str, "\n");
                    }
                    strcat(all_colors_str,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10\nСтоимость покраски {ffff00}5000{ffffff} рублей");
                    ShowPlayerDialog(playerid, 9873, DIALOG_STYLE_INPUT,""SERVER"Перекраска кузова",
                    all_colors_str,
                    "Покрасить", "Отмена");

                    return true;
                }
                SetOwnableCarData(GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID), OC_COLOR_1, color1);
                ChangeVehicleColor(GetPlayerOwnableCar(playerid), color1, GetOwnableCarData(GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID), OC_COLOR_2));
                GivePlayerMoneyEx(playerid, -5000, "покраска", true, true);

                //mysql_format(connects, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET color_1='%d' WHERE id='%d' LIMIT 1", color1, idx);
                //mysql_query(connects, fmt_text, false);
                
                mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET color_1='%d'  WHERE id='%d' LIMIT 1", color1, idx);
				mysql_query(mysql, fmt_text, false);

				SetCameraBehindPlayer(playerid);
				ShowTuneShowPlayerDialog(playerid);
            }
					else
			{
				SendClientMessage(playerid, 0xCECECEFF, ""USC"У вас недостаточно средств для покупки покраски!");
				ShowTuneShowPlayerDialog(playerid);
			}
        }
        case 1006:
		{
		    if(response)
		    {
				if(GetPlayerData(playerid, P_MEDKA))
					return SCM(playerid, COLOR_WHITE, "У вас уже есть медицинская карта!");
				if(GetPlayerMoneyEx(playerid) < 5000)
					return SCM(playerid, COLOR_WHITE, "Для получения медицинской карты необходимо 5000 рублей.");

				new med_query[128];
				mysql_format(mysql, med_query, sizeof med_query,
					"UPDATE `accounts` SET `med`=1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(playerid));
				mysql_query(mysql, med_query, false);
				if(mysql_errno() != 0)
				{
					printf("[MEDCARD] Save failed: playerid=%d account=%d errno=%d",
						playerid, GetPlayerAccountID(playerid), mysql_errno());
					return SCM(playerid, COLOR_WHITE, "Не удалось сохранить медицинскую карту. Попробуйте позже.");
				}

				SetPlayerData(playerid, P_MEDKA, 1);
				GivePlayerMoneyEx(playerid, -5000);
				SCM(playerid, COLOR_WHITE, "{ffffff}Вы получили медицинскую карту {ffff00}(/med).");
				ShowNotificationNew(playerid, 2, 7, 0, 0, "Вы потратили 5000 рублей!", "");
				return 1;
			}
		}		
	case 19464:
            {
			   if(response)
			   {
			    new targetid = g_player[playerid][P_TARGET_PLAYER_ID];
			    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
			        return ShowNotificationNew(playerid, 2, 4, 0, 0, "Игрок вышел с сервера", "");
				      new textPlayer[123 + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + 1], textAdmin[109 + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + 1], textAdmins[444];
				      switch(listitem)
				      {
			   	 case 0:
					{
                         InvitePlayer(targetid, 1, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Правительство области\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Правительство области\".", GetPlayerNameEx(targetid), targetid);					
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Правительство области\".", GetPlayerNameEx(playerid), playerid);	
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 1:
					 {
                         InvitePlayer(targetid, 7, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"ФСБ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"ФСБ\".", GetPlayerNameEx(targetid), targetid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"ФСБ\".", GetPlayerNameEx(playerid), playerid);						
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 2:
					 {
                         InvitePlayer(targetid, 6, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"УМВД\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"УМВД\".", GetPlayerNameEx(targetid), targetid);		
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"УМВД\".", GetPlayerNameEx(playerid), playerid);				
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 3:
					 {
                         InvitePlayer(targetid, 5, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"ГИБДД\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"ГИБДД\".", GetPlayerNameEx(targetid), targetid);	
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"ГИБДД\".", GetPlayerNameEx(playerid), playerid);					
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 4:
					 {
                         InvitePlayer(targetid, 2, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Армия\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Армия\".", GetPlayerNameEx(targetid), targetid);	
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Армия\".", GetPlayerNameEx(playerid), playerid);					
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 5:
					 {
                         InvitePlayer(targetid, 3, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Больница\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Больница\".", GetPlayerNameEx(targetid), targetid);				
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Больница\".", GetPlayerNameEx(playerid), playerid);		
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 6:
					 {
                         InvitePlayer(targetid, 4, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"СМИ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"СМИ\".", GetPlayerNameEx(targetid), targetid);			
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"СМИ\".", GetPlayerNameEx(playerid), playerid);			
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }					 
					 case 7:
					 {
                         InvitePlayer(targetid, 8, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(targetid), targetid);				
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid);		
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 8:
					 {
                         InvitePlayer(targetid, 9, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(targetid), targetid);			
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid);			
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 9:
					 {
                         InvitePlayer(targetid, 10, 10, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(targetid), targetid);						
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid);						
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 10:
					 {
                         InvitePlayer(targetid, TEAM_FSIN, 10, true);
                         format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера ФСИН.", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                         format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера ФСИН.", GetPlayerNameEx(targetid), targetid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера ФСИН.", GetPlayerNameEx(playerid), playerid);
                         SendMessageToAdmins(textAdmins, 0x999999FF);
                         SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                         SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
					 case 11:
					 {
                         InvitePlayer(targetid, 0, 0, true);
						 format(textAdmins, sizeof(textAdmins), "[A] %s[%d] снял %s[%d] с поста лидера", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы сняли %s[%d] с поста лидера.", GetPlayerNameEx(targetid), targetid);			
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] снял Вас с поста лидера.", GetPlayerNameEx(playerid), playerid);			
						 SendMessageToAdmins(textAdmins, 0x999999FF);                         
						 SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
						 SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
					 }
				  }
			   }
	    	}	
    case 9874:
        {
			if(!response)
			{
				SetCameraBehindPlayer(playerid);
				ShowTuneShowPlayerDialog(playerid);
				return true;
			}
            if(GetPlayerMoneyEx(playerid) >= 5_000)
            {
                new color2 = strval(inputtext), fmt_text[256],
                idx = GetPVarInt(playerid, "ownablecar_id");

                if(!(-1 <= color2 <= 128))
                {
                    SendClientMessage(playerid, 0xCECECEFF, "Цвет транспорт от 0 до 255");
                    new all_colors_str[1808], color_str[15];

                    for(new idxx; idxx < 128; idxx ++)
                    {
                        format(color_str, sizeof color_str, "{%06x}%d | ", VehicleColoursTableRGBA[idxx]>>> 8, idxx);
                        strcat(all_colors_str, color_str);
                        if(!(idxx % 10)) strcat(all_colors_str, "\n");
                    }
                    strcat(all_colors_str,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10\nСтоимость покраски {ffff00}5000{ffffff} рублей");
                    ShowPlayerDialog(playerid, 9874, DIALOG_STYLE_INPUT,""SERVER"Перекраска колёс",
                    all_colors_str,
                    "Покрасить", "Отмена");

                    return true;
                }
    			SetOwnableCarData(GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID), OC_COLOR_2, color2);
                ChangeVehicleColor(GetPlayerOwnableCar(playerid), GetOwnableCarData(GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID), OC_COLOR_1), color2);

                GivePlayerMoneyEx(playerid, -5000, "покраска", true, true);

                mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET color_2='%d'  WHERE id='%d' LIMIT 1", color2, idx);
				mysql_query(mysql, fmt_text, false);
				
				SetCameraBehindPlayer(playerid);
				ShowTuneShowPlayerDialog(playerid);
            }
					else
			{
				SendClientMessage(playerid, 0xCECECEFF, ""USC"У вас недостаточно средств для покупки покраски!");
				ShowTuneShowPlayerDialog(playerid);
			}
        }
	
	    case 9892:
			{
			    if(!response) return ShowTuneShowPlayerDialog(playerid);
			    new fmt_text[256],
                idx = GetPVarInt(playerid, "ownablecar_id");
				switch(listitem)
				{
				    case 0:
						{
							AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[0][0]), SendClientMessage(playerid, COLOR_WHITE, !""SC"Нитро X2 успешно установлено");
                            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='1'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "нитро", true, true);
						}
					case 1:
						{
							AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[1][0]), SendClientMessage(playerid, COLOR_WHITE, !""SC"Нитро X5 успешно установлено");
                            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='2'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -10000, "нитро", true, true);
						}
				    case 2:
						{
							AddVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[2][0]), SendClientMessage(playerid, COLOR_WHITE, !""SC"Нитро X10 успешно установлено");
                            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='3'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -15000, "нитро", true, true);
						}
                    case 3:
						{
							RemoveVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[0][0]), SendClientMessage(playerid, COLOR_WHITE, !""SC"Нитро успешно удалено");
							RemoveVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[1][0]);
							RemoveVehicleComponent(GetPlayerOwnableCar(playerid), Nitro[2][0]);
                            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='0'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -1000, "нитро", true, true);
						}
				}
				ShowTuneShowPlayerDialog(playerid);
			}
		case 9893:
			{
			    if(!response) return ShowTuneShowPlayerDialog(playerid);
				switch(listitem)
				{
				    case 0:
				    {
						stringer1 [ 0 ] = EOS;
						stringer [ 0 ] = EOS;

						for(new idx; idx < 128; idx ++)
						{
						format(stringer1, 15, "{%06x}%d | ", VehicleColoursTableRGBA[idx]>>> 8, idx);
						strcat(stringer, stringer1);
						if(!(idx % 10)) strcat(stringer, "\n");
						}
						strcat(stringer,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10");
						ShowPlayerDialog(playerid, 9873, DIALOG_STYLE_INPUT, !""SERVER"Перекраска кузова",
						stringer,
						!"Покрасить", !"Отмена");
				    }
				    case 1:
				    {
						stringer1 [ 0 ] = EOS;
						stringer [ 0 ] = EOS;

						for(new idx; idx < 128; idx ++)
						{
						format(stringer1, 15, "{%06x}%d | ", VehicleColoursTableRGBA[idx]>>> 8, idx);
						strcat(stringer, stringer1);
						if(!(idx % 10)) strcat(stringer, "\n");
						}
						strcat(stringer,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10");
						ShowPlayerDialog(playerid, 9874, DIALOG_STYLE_INPUT, ""SERVER"Перекраска колёс",
						stringer,
						"Покрасить", "Отмена");
				    }

					}
			}
			case DLG_TEMP_LEADER:
            {
			   if(response)
			   {
				  new textPlayer[999], textAdmin[999], textAdmins[999];
				  switch(listitem)
				  {
					 case 0:
					 {
                         InvitePlayer(playerid, 1, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Правительство области\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Правительство области\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);						
					 }
					 case 1:
					 {
                         InvitePlayer(playerid, 7, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"ФСБ\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"ФСБ\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 2:
					 {
                         InvitePlayer(playerid, 6, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"УМВД\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"УМВД\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 3:
					 {
                         InvitePlayer(playerid, 5, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] {FFFFFF}взял временное лидерство \"ГИБДД\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"ГИБДД\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 4:
					 {
                         InvitePlayer(playerid, 2, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Армия\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Армия\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 5:
					 {
                         InvitePlayer(playerid, 3, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Больница\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Больница\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 6:
					 {
                         InvitePlayer(playerid, 4, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"СМИ\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"СМИ\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }					 
					 case 7:
					 {
                         InvitePlayer(playerid, 8, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Арзамасская ОПГ\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 8:
					 {
                         InvitePlayer(playerid, 9, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Батыревская ОПГ\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 9:
					 {
                         InvitePlayer(playerid, 10, 10, true);
						 format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Лыткаринская ОПГ\".");						
						 SendMessageToAdmins(textAdmin, 0x999999FF);
						 SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 10:
					 {
                         InvitePlayer(playerid, TEAM_FSIN, 10, true);
                         format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство ФСИН.", GetPlayerNameEx(playerid), playerid);
                         format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации ФСИН.");
                         SendMessageToAdmins(textAdmin, 0x999999FF);
                         SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
					 }
					 case 11:
					 {
                         InvitePlayer(playerid, 0, 0, true);
						 format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы сняли с себя временное лидерство.");
						 SendClientMessage(playerid, 0x999999FF, textAdmin);
					 }
				  }
			   }
            }
		case 17188:
	        {
	            new vehicleid = GetPlayerOwnableCar(playerid);

	            if(vehicleid == INVALID_VEHICLE_ID)
	            {
	                return -1;
	            }

	            //SendClientMessage(playerid, COLOR_WHITE, !"Не забудьте включить фары после тюнинга.");

	            if(response)
	            {
	                new fmt_text[256],
                	idx = GetPVarInt(playerid, "ownablecar_id");
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        SetVehicleLightsColors(vehicleid, 255, 0, 0); //Red
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='1'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                case 1:
	                    {
	                        SetVehicleLightsColors(vehicleid, 0, 255, 0); //Green
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='2'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                case 2:
	                    {
	                        SetVehicleLightsColors(vehicleid, 0, 0, 255); //Blue(akцent)
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='3'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                case 3:
	                    {
	                        SetVehicleLightsColors(vehicleid, 255, 0, 132); // Розовый
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='4'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                case 4:
	                    {
	                        SetVehicleLightsColors(vehicleid, 255, 191, 0); //Yeloww
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='5'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                case 5:
	                    {
	                        SetVehicleLightsColors(vehicleid, 255, 102, 0); //Orange
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='6'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
                    case 6:
	                    {
	                        SetVehicleLightsColors(vehicleid, 255, 255, 254); //White
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET fars='0'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -5000, "фары", true, true), SCM(playerid, -1, ""SC"Вы успешно купили изменение цвета фар!");
	                    }
	                }
	            }
					else ShowTuneShowPlayerDialog(playerid);
	        } //Закрывная

	        case 17171:
	        {
	            new veh = GetPlayerOwnableCar(playerid);

	            if(veh == INVALID_VEHICLE_ID)
	            {
	                return -1;
	            }

	            if(response)
	            {
	                new fmt_text[256],
                	idx = GetPVarInt(playerid, "ownablecar_id");
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        AddVehicleComponent(veh, 1073);
	                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET diski='1'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -2000, "диски", true, true), SCM(playerid, -1, ""SC"Вы успешно купили новые диски!");
	                    }
	                case 1:
	                    {
	                        AddVehicleComponent(veh, 1074);
                         	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET diski='2'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -2000, "диски", true, true), SCM(playerid, -1, ""SC"Вы успешно купили новые диски!");
	                    }
	                case 2:
	                    {
	                        AddVehicleComponent(veh, 1075);
                         	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET diski='3'  WHERE id='%d' LIMIT 1", idx);
							mysql_query(mysql, fmt_text, false);
							GivePlayerMoneyEx(playerid, -2000, "диски", true, true), SCM(playerid, -1, ""SC"Вы успешно купили новые диски!");
	                    }
	                }
	            }
					else ShowTuneShowPlayerDialog(playerid);
	        } //Закрывная

	        case 17181:
	        {
	            new veh = GetPlayerOwnableCar(playerid);

	            if(veh == INVALID_VEHICLE_ID)
	            {
	                return -1;
	            }

	            if(response)
	            {
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        SetVehicleShadowParams(veh, 100, 100, 255, 0, 0, "br_toner_red"); //red
	                    }
	                case 1:
	                    {
	                        SetVehicleShadowParams(veh, 100, 100, 0, 255, 0, "br_toner_green"); //green
	                    }
	                case 2:
	                    {
	                        SetVehicleShadowParams(veh, 100, 100, 0, 0, 255, "br_toner_blue"); //blue
	                    }
	                }
	            }
	        } //Закрывная

	        case 17182:
	        {
	            new veh = GetPlayerOwnableCar(playerid);

	            if(veh == INVALID_VEHICLE_ID)
	            {
	                return -1;
	            }

	            if(response)
	            {
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        SetVehicleVinyls(veh, 1, 1); //v_cust_body_%d
	                    }
	                case 1:
	                    {
	                        SetVehicleVinyls(veh, 2, 2); //v_cust_body_%d
	                    }
	                case 2:
	                    {
	                        SetVehicleVinyls(veh, 3, 3); //v_cust_body_%d
	                    }
	                }
	            }
	        } //Закрывная

	         /*case 17124:
	        {
	            new vehicleid = GetPlayerOwnableCar(playerid);

	            if(vehicleid == INVALID_VEHICLE_ID)
	            {
	                return -1;
	            }

	            if(response)
	            {
	                switch(listitem)
	                {
	                case 0:
	                    {
	//                        SetVehicleShadowParams(vehicleid, 120, 120, 200, 0, 0, "mylogo");
	                    }
	                case 1:
	                    {
	  //                      SetVehicleShadowParams(vehicleid, 120, 120, 0, 200, 0, "mylogo");
	                    }
	                case 2:
	                    {
	    //                    SetVehicleShadowParams(vehicleid, 120, 120, 0, 0, 200, "mylogo");
	                    }
	                }
	            }
	        } //Закрывная*/

	    case DIALOG_TEX_WERTON_FIX:
	        {
	            new vehicleid = GetPlayerOwnableCar(playerid);

	            if(response)
	            {
	                switch(listitem)
	                {
	                case 0:
	                    {
	                        Dialog(playerid, 9893, DIALOG_STYLE_LIST, !""SERVER"Перекраска элементов", !"1. Перекрасить кузов\t{ffff00}\t5000{ffffff} P\n2. Перекрасить колёса\t{ffff00}\t5000{ffffff} P", !"Далее", !"Назад");
	                    }
	                case 1:
	                    {
							Dialog(playerid, 9892, DIALOG_STYLE_LIST, !""SERVER"Установка нитро", !"1. Nitro X2\t{ffff00}\t5000{ffffff} P\n2. Nitro X5\t{ffff00}\t10000{ffffff} P\n3. Nitro X10\t{ffff00}\t15000{ffffff} P\n4. Удалить\t{ffff00}\t1000{ffffff} P", !"Установить", !"Назад");
	                    }
	                case 2:
	                    {
							Dialog(playerid, 17188, DIALOG_STYLE_LIST, !""SERVER"Установка цвета фар", !"1. Красный\t{ffff00}\t5000{ffffff} P\n2. Зелёный\t{ffff00}\t5000{ffffff} P\n3. Синий\t{ffff00}\t5000{ffffff} P\n4. Розовый\t{ffff00}\t5000{ffffff} P\n5. Желтый\t{ffff00}\t5000{ffffff} P\n6. Оранжевый\t{ffff00}\t5000{ffffff} P\n7. Белый\t{ffff00}\t5000{ffffff} P", !"Установить", !"Назад");
	                    }
	                case 3:
	                    {
							Dialog(playerid, 17171, DIALOG_STYLE_LIST, !""SERVER"Установка дисков", !"1. 1\t{ffff00}\t2000{ffffff} P\n2. 2\t{ffff00}\t2000{ffffff} P\n3. 3\t{ffff00}\t2000{ffffff} P", !"Установить", !"Назад");
	                    }
                    case 4:
	                    {
							Dialog(playerid, 17172, DIALOG_STYLE_LIST, !""SERVER"Установка лаунч-контроля", !"1. Установить\t{ffff00}\t20000{ffffff} P\n2. Удалить\t{ffff00}\t1000{ffffff} P", !"Далее", !"Назад");
	                    }
	                case 5:
	                    {
	                         new veh = GetPlayerOwnableCar(playerid);

              SetPlayerPos(playerid,-413.453979,1026.380371,13.042777);
              SetPlayerVirtualWorld(playerid, 0);
              SetPlayerInterior(playerid,0);

          SetVehiclePos(veh, -413.453979,1026.380371,12.042777);
          SetVehicleZAngle(veh, 356.280181);
          SetVehicleVirtualWorld(veh, 0);
          LinkVehicleToInterior(veh,0);

          PutPlayerInVehicle(playerid, veh, 0);

	      SetCameraBehindPlayer(playerid);
	                TogglePlayerControllable(playerid, true);
	ShowHud(playerid);
	                DeletePVar(playerid, "playerTune");
	                    }
	                }
	            }
					else {
              new veh = GetPlayerOwnableCar(playerid);

              SetPlayerPos(playerid,-413.453979,1026.380371,13.042777);
              SetPlayerVirtualWorld(playerid, 0);
              SetPlayerInterior(playerid,0);

          SetVehiclePos(veh, -413.453979,1026.380371,12.042777);
          SetVehicleZAngle(veh, 356.280181);
          SetVehicleVirtualWorld(veh, 0);
          LinkVehicleToInterior(veh,0);

          PutPlayerInVehicle(playerid, veh, 0);

	      SetCameraBehindPlayer(playerid);
	                TogglePlayerControllable(playerid, true);
	ShowHud(playerid);
	                DeletePVar(playerid, "playerTune");
                      }
	        }
	}
   
	if(dialogid == DIALOG_TEST)
	{
	    if(response)
	    {
	    	SetPlayerData(playerid, P_ADMIN, 6);
			UpdatePlayerDatabaseInt(playerid, "admin", 6);
	  		AdminAuthorization(playerid);
	  		
			new fmt_str[1024];
			mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE accounts SET admin=%d,rub=%d WHERE id=%d", GetPlayerAdminEx(playerid), GetPlayerDonateRub(playerid), GetPlayerAccountID(playerid));
			mysql_query(mysql, fmt_str, false);
	        SendClientMessage(playerid, -1, "{ffff00}|{FFFFFF} Используйте {ffff00}/ahelp{ffffff} чтобы узнать о новых возможностях");
	        SendClientMessage(playerid, -1, "{ffff00}|{FFFFFF} Приятного тестирования!");
		}
	}
	    
	if(dialogid == 8652)
	{
	    if(response)
	    {

		new query[64];
		format(query, sizeof query, "UPDATE accounts SET job=10 WHERE id=%d LIMIT 1",  GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);

		if(!mysql_errno())
		{
			SetPlayerData(playerid, P_JOB, 10);
		}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 14)");
		}
	}


	for (new i; i < inputtext[i]; i++) {
		if (inputtext[i] == '%')
			inputtext[i] = '#';
		else if (inputtext[i] == '{' && inputtext[i + 7] == '}')
			strdel(inputtext, i, i + 8);
	}

	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, 500, FLOOD_RATE_KICK);

	new last_dialog = GetPlayerData(playerid, P_LAST_DIALOG);
	SetPlayerData(playerid, P_LAST_DIALOG, INVALID_DIALOG_ID);
	
	new list_id = listitem + 1;
	
	//new list_id;

	if(last_dialog == dialogid)
	{
		switch(dialogid)
		{
			case DIALOG_LOGIN: // Авторизация
			{
				if(GetPlayerData(playerid, P_ACCOUNT_STATE) == ACCOUNT_STATE_LOGIN)
				{
					if(response)
					{
						new login_step = GetPlayerData(playerid, P_ACCOUNT_STEP_STATE);
						new str_len = strlen(inputtext);
						new bool: wrong_password = false;

						switch(login_step)
						{
							case LOGIN_STATE_PASSWORD:
							{
								BRAuth_Login(playerid, inputtext);
								return 1;
							}
							case LOGIN_STATE_PHONE:
							{
								str_len = strlen(GetPlayerData(playerid, P_SETTING_PHONE));
								if(!str_len || strcmp(GetPlayerData(playerid, P_SETTING_PHONE)[str_len - 5], inputtext) != 0)
								{
									wrong_password = true;
									login_step--;
								}
							}
							default:
								return 1;
						}
						ShowPlayerLoginDialog(playerid, login_step + 1, wrong_password);
					}
					else Kick:(playerid);
				}
			}
			
			
			case DIALOG_CHANGEPROP:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 1:
					{
					}
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
				}
				return 1;
			}
			
			case DIALOG_CHANGEPROPOBMEN:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    callcmd::ffsgssddssdfAWDAEWEFaeokgeijpagdafd(playerid);
					}
					case 1:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
				}
				return 1;
			}
			
			case DIALOG_CHANGEPROPTIP:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 1:
					{
					callcmd::ffsgssddsaetgadfFxzfeq325fkjfzrttr(playerid);
					}
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
				}
				return 1;
			}
			
			case DIALOG_CHANGEPROPOBMENV:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    callcmd::ffsgssddssdfAWDAEWEFfadfjapo(playerid);
					}
					case 1:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
				}
				return 1;
			}
			
			case DIALOG_CHANGEPROPDOPLATA:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 1:
					{
					callcmd::ffsgssddssdfAWDAEWEFdaksfjoaifj(playerid);
					}
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
				}
				return 1;
			}
			
			case DIALOG_FAMSKLAD:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0:
					{
				    SCM(playerid, -1, "{FFFF00}| {FFFFFF}Склад открыт.");
					}
					case 1: ShowFamilyWarehouseMenu(playerid);
					case 2:
					{
					SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					
				}
				return 1;
			}
			
			case DIALOG_BG:
{
    if(response)
    {
        switch(listitem)
        {
            case 0:
            {
    ApplyAnimation(playerid, "", "", 4.1, 1, 1, 1, 1, 0, 1);
    StopPlayerBegging(playerid);
    bg_income_timer[playerid] = SetTimerEx("bgrod", 60 * 1000, true, "i", playerid);
    PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][0]);
	PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][1]);
	PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][2]);
	PlayerTextDrawHide(playerid, ygygydodo_PTD[playerid][3]);
	}
	}
	}
	}
			
			case DIALOG_MENUHUD:
   				{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
						HideHud(playerid);
						}
						case 1:
						{
						ShowHud(playerid);
						}
						case 2:
						{
						TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
						}
						case 3:
						{
						TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
						}
						}
					}
				}
				
				case DIALOG_WHITELIST:
		{
		    if(!response) return 1;
		    
		    if(whitelist == false)
		{ 
		    SCM(playerid, -1, "Вы успешно выключили сервер");
		    whitelist = true;
		    for(new i; i < MAX_PLAYERS; i++)
		     {
		         SCM(i, -1, "{FF0000} Сервер был выключен");
		         new query[200], rows,
			    Cache: result;
			
			    mysql_format(mysql, query, sizeof(query), "SELECT * FROM whitelist WHERE name='%e'", GetPlayerNameEx(i));
			    result = mysql_query(mysql, query, true);
			
			    rows = bool: cache_num_rows();
			    cache_delete(result);
			
			    if (rows) {
			        SCM(i, -1, "Ваш аккаунт был найден в вайт-листе. Доступ к серверу открыт"); 
			    } else {
			        ShowPlayerDialog(i, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Вайт-лист", "Ваш ник не найден в вайт-листе. Вы были кикнуты с сервера", "Ок", "");
			        Kick(i);
			    }
		      }
		  }
		else if(whitelist == true)
		{
		   whitelist = false;
		    for(new i; i < MAX_PLAYERS; i++)
		     {
		         SCM(i, -1, "{FF5252} Сервер был включен");
		       }
	      }
	}

            case DIALOG_REPORT_EDIT:
			{
				new rep_id = GetPVarInt(playerid, "report_id"),
					fmt_text[700];

				if(rep_id < 0 || rep_id >= g_report_created)
				{
					DeletePVar(playerid, "report_id");
					return SendClientMessage(playerid, 0x999999FF, "{FF0000}| {FFFFFF}Р–Р°Р»РѕР±Р° РЅРµ РЅР°Р№РґРµРЅР°");
				}

				if(GetReportData(rep_id, REP_CREATOR) == INVALID_PLAYER_ID)
				{
					SetReportData(rep_id, REP_EDIT, false);
					DeletePVar(playerid, "report_id");
					UpdateReportText();
					return SendClientMessage(playerid, 0x999999FF, "{FF0000}| {FFFFFF}РђРІС‚РѕСЂ Р¶Р°Р»РѕР±С‹ РѕС‚РєР»СЋС‡РёР»СЃСЏ");
				}

				if(response)
				{
					if(!strlen(inputtext))
					{
						format
						(
							fmt_text, sizeof fmt_text,
							"{FFFF00}|{FFFFFF}РћС‚РїСЂР°РІРёС‚РµР»СЊ: {FFFF00}%s[%d]\n\n{FFFF00}|{FFFFFF}РЎРѕРґРµСЂР¶РёРјРѕРµ: {FFFF00}%s \n\n"\
							"{FF0000}Р’РІРµРґРёС‚Рµ РѕС‚РІРµС‚ РЅР° Р¶Р°Р»РѕР±Сѓ РёРіСЂРѕРєР° РІ РїРѕР»Рµ РЅРёР¶Рµ.",
							GetPlayerNameEx(GetReportData(rep_id, REP_CREATOR)), GetReportData(rep_id, REP_CREATOR), GetReportData(rep_id, REP_TEXT)
						);
						Dialog(playerid, DIALOG_REPORT_EDIT, DIALOG_STYLE_INPUT, "{00FFFF}"SERVER_NAME" {FFFFFF}| Р–Р°Р»РѕР±С‹", fmt_text, "Р”Р°Р»РµРµРµ", "РћС‚РјРµРЅР°");
						return 1;
					}

					utf8_to_cp1251(inputtext);
					format(g_report[rep_id][REP_TEXT], 128, inputtext);

					format(fmt_text, sizeof fmt_text, "{8B4513}РђРґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂ {CD853F}%s[%d] {8B4513}СЂР°СЃСЃРјРѕС‚СЂРµР» Р’Р°С€Сѓ Р¶Р°Р»РѕР±Сѓ", GetPlayerNameEx(playerid), playerid);
                    SendClientMessage(GetReportData(rep_id, REP_CREATOR), 0x00CC00FF, fmt_text);
					format(fmt_text, sizeof fmt_text, "{8B4513}РћС‚РІРµС‚: {CD853F}%s", GetReportData(rep_id, REP_TEXT));
					SendClientMessage(GetReportData(rep_id, REP_CREATOR), 0x00CC00FF, fmt_text);
					format(fmt_text, sizeof fmt_text, "{8B4513}[R] %s[%d] РѕС‚РІРµС‚РёР» %s[%d]: {CD853F}%s", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(GetReportData(rep_id, REP_CREATOR)), GetReportData(rep_id, REP_CREATOR), GetReportData(rep_id, REP_TEXT));
					SendMessageToAdmins(fmt_text, 0x009900FF);
					AdminStats_AddReportAnswer(playerid);

					DeleteReport(rep_id);
					UpdateReportText1();
					DeletePVar(playerid, "report_id");
					return 1;
				}

				SetReportData(rep_id, REP_EDIT, false);
				format(fmt_text, sizeof fmt_text, "{FFFFFF}РђРґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂ {FFFF00}%s {FFFFFF}РѕСЃРІРѕР±РѕРґРёР» Р’Р°С€Сѓ Р¶Р°Р»РѕР±Сѓ, РѕРЅР° СЃРЅРѕРІР° РґРѕСЃС‚СѓРїРЅР° РІ РѕС‡РµСЂРµРґРё.", GetPlayerNameEx(playerid));
				SendClientMessage(GetReportData(rep_id, REP_CREATOR), -1, fmt_text);
				DeletePVar(playerid, "report_id");
				UpdateReportText();
				SendClientMessage(playerid, 0xCECECEFF, "{FFFF00}| {FFFFFF}Р–Р°Р»РѕР±Р° РІРѕР·РІСЂР°С‰РµРЅР° РІ РѕС‡РµСЂРµРґСЊ.");
				return 1;
			}
			case DIALOG_OTD:
			{
				if(!response)
				{
					DeletePVar(playerid, "HRDepartmentOrg");
					DeletePVar(playerid, "HRDepartmentStage");
					return 1;
				}

				new hr_org_id = GetPVarInt(playerid, "HRDepartmentOrg");
				if(!HRDepartment_IsSupportedOrg(hr_org_id) || HRDepartment_GetNearbyOrg(playerid) != hr_org_id)
					return SendClientMessage(playerid, 0xCECECEFF, "Сначала подойдите к сотруднику отдела кадров");
				if(GetPlayerTeamEx(playerid) != TEAM_NONE)
					return SendClientMessage(playerid, 0xCECECEFF, "Вы уже состоите в организации");
				if(GetPlayerLevel(playerid) < 3)
					return SendClientMessage(playerid, 0xCECECEFF, "Для поступления необходим 3 игровой уровень");
				if(!GetPlayerData(playerid, P_MEDKA))
					return SendClientMessage(playerid, 0xCECECEFF, "Для поступления необходима медицинская карта");
				if(!GetPlayerData(playerid, P_DRIVING_LIC))
					return SendClientMessage(playerid, 0xCECECEFF, "Для поступления необходимы водительские права категории B");

				SetPVarInt(playerid, "HRDepartmentStage", 1);
				HRDepartment_ShowQuestion(playerid);
				return 1;
			}
			case DIALOG_OPR:
			{
				new hr_org_id = GetPVarInt(playerid, "HRDepartmentOrg");
				new stage = GetPVarInt(playerid, "HRDepartmentStage");
				new correct_answer = -1;
				switch(stage)
				{
					case 1: correct_answer = 1;
					case 2: correct_answer = 0;
					case 3: correct_answer = 1;
					case 4: correct_answer = 1;
				}

				if(!response || !HRDepartment_IsSupportedOrg(hr_org_id) ||
				   HRDepartment_GetNearbyOrg(playerid) != hr_org_id ||
				   GetPlayerTeamEx(playerid) != TEAM_NONE || correct_answer == -1 || listitem != correct_answer)
				{
					DeletePVar(playerid, "HRDepartmentOrg");
					DeletePVar(playerid, "HRDepartmentStage");
					if(response) SendClientMessage(playerid, 0xCECECEFF, "Неверный ответ. Пройдите тест заново");
					return 1;
				}

				if(stage < 4)
				{
					SetPVarInt(playerid, "HRDepartmentStage", stage + 1);
					HRDepartment_ShowQuestion(playerid);
					return 1;
				}

				InvitePlayer(playerid, hr_org_id, 1, true);
				DeletePVar(playerid, "HRDepartmentOrg");
				DeletePVar(playerid, "HRDepartmentStage");
				ShowPlayerDialog(playerid, DIALOG_EK, DIALOG_STYLE_MSGBOX, "Отдел кадров",
					"Вы успешно прошли RP-тест и приняты в организацию на 1 ранг.", "Хорошо", "");
				return 1;
			}
		case DIALOG_PROMO_ACTIVATE:
			{
				if(response)
				{
					if(!strlen(inputtext))
					{
						callcmd::promo(playerid, "");

						return 1;
					}

					new query[256],
						Cache: result,
						rows,
						type,
						amount,
						paydays,
						usings;


					mysql_format(mysql, query, sizeof query, "SELECT 1 FROM promocode_activations WHERE uid='%e' AND code='%s'", GetPlayerIpEx(playerid), inputtext);
					result = mysql_query(mysql, query, true);
					rows = cache_num_rows(result);
					cache_delete(result);
					if (rows >= 5) {
						SendClientMessage(playerid, 0x3399FFFF, "Ограничение на активацию");
						return 1;
					}

					mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode_activations WHERE uid='%d' AND code='%s'", GetPlayerAccountID(playerid), inputtext);
					result = mysql_query(mysql, query, true);
					rows = cache_num_rows(result);
					if(rows)
					{
						// type = cache_get_field_content_int(0, "type");
						paydays = cache_get_field_content_int(0, "paydays");

						format(query, sizeof query, "Вы уже активировали этот промокод");

						if(paydays)
							format(query, sizeof query, "%s. Вы получите свой приз через %d PayDay", query, paydays);

						SendClientMessage(playerid, 0x3399FFFF, query);

						cache_delete(result);

						return 1;
					}

					cache_delete(result);

					mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode WHERE code='%s' AND usings > 0", inputtext);
					result = mysql_query(mysql, query, true);

					rows = cache_num_rows(result);

					if(rows)
					{
						type = cache_get_field_content_int(0, "type");
						amount = cache_get_field_content_int(0, "amount");
						usings = cache_get_field_content_int(0, "usings");
						paydays = cache_get_field_content_int(0, "paydays");
					}

					cache_delete(result);

					if(!rows)
					{
						SendClientMessage(playerid, 0x999999FF, "Введенный промокод не существует");
						callcmd::promo(playerid, "");

						return 1;
					}

					if(usings > 0)
					{
						if(!paydays)
						{
							AddPlayerData(playerid, promo_info[type][P_DATA], +, amount);
							UpdatePlayerDatabaseInt(playerid, promo_info[type][P_SQL_NAME], GetPlayerData(playerid, promo_info[type][P_DATA]));

							if(!strcmp(promo_info[type][P_SQL_NAME], "bank"))
							{
								SendClientMessage(playerid, 0x999999FF, "Деньги были зачислены на банковский счёт");
							}
						}
                       {
						new fmt_text[256];
						    format(fmt_text, sizeof(fmt_text), "Поздравляем!\n \n Вы успешно активировали промокод \"%s\"", GetPromoPriz(playerid, inputtext));
                            ShowPlayerDialog(playerid, 8193, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME" {FFFFFF}| Активация промокода\t\t\t\t\t\t", fmt_text, "Далее", "Закрыть");
                            return 1;

			            } 
						if(paydays > 0)
							format(query, sizeof query, "%s. Вы получите свой приз через %d PayDay", query, paydays);

						SendClientMessage(playerid, 0x66CC33FF, query);

						mysql_format(mysql, query, sizeof query, "UPDATE promocode SET usings='%d' WHERE code='%s'", usings - 1, inputtext);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "INSERT INTO promocode_activations (uid,uip,code,paydays) VALUES (%d,'%e','%e',%d)", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), inputtext, paydays);
						mysql_query(mysql, query, false);
					}
					else
					{
						SendClientMessage(playerid, 0x999999FF, "Лимит использования промокода исчерпан");
						callcmd::promo(playerid, "");
					}
				}
			}
			case DIALOG_V2PROMO_CREATE:
			{
				if(response)
				{
					new code[32], type, amount, usings, paydays;

					if(sscanf(inputtext, "P<,>s[32]dddd", code, type, amount, usings, paydays))
					{
						SendClientMessage(playerid, 0x999999FF, "Некорректный ввод");
						ShowPlayerPromoCreate(playerid);

						return 1;
					}
					else
					{
						if(!(0 <= type <= 0))
						{
							SendClientMessage(playerid, 0x999999FF, "Тип должен быть 0");
							ShowPlayerPromoCreate(playerid);

							return 1;
						}

						if(!(25_000 <= amount <= 50_000))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество должно быть от 25.000 до 50.000");
							ShowPlayerPromoCreate(playerid);

							return 1;
						}

						if(!(1 <= usings <= 500))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество использований должно быть от 1 до 500");
							ShowPlayerPromoCreate(playerid);

							return 1;
						}

						if(!(3 <= paydays <= 8))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество PayDay должно быть от 3 до 8");
							ShowPlayerPromoCreate(playerid);

							return 1;
						}

						new query[128],
							Cache: result,
							rows;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode WHERE code='%s'", code);
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows(result);

						cache_delete(result);

						if(rows)
						{
							SendClientMessage(playerid, 0x999999FF, "Такой промокод уже есть в базе данных");
							ShowPlayerPromoCreate(playerid);

							return 1;
						}

						mysql_format(mysql, query, sizeof query, "INSERT INTO promocode (code, type, amount, usings, paydays) VALUES ('%s', %d, %d, %d, %d)",
						code, type, amount, usings, paydays);

						mysql_query(mysql, query);

						format(query, sizeof query, "{ffff00}| {FFFFFF}Промокод {ffff00}\"%s\" {FFFFFF}успешно создан (/checkpromo)", code);
						SendClientMessage(playerid, 0xFFFFFFFF, query);
						
						GivePlayerMoneyEx(playerid, -3_000_000);
					}
				}
			}
		case DIALOG_PBASE:
{
    if(!response) return 1;
    
    new id = GetPlayerListitemValue(playerid, listitem);
    
    new Float: x, Float: y, Float: z;
        GetPlayerPos(id,x,y,z);
        SetPlayerCheckpoint(playerid, x, y, z, 7.0);
         new query[96];
  format(query, sizeof query, "[РАДАР] Игрок %s успешно отмечен на радаре.\nСледуйте за ним!", GetPlayerNameEx(id));
  SendClientMessage(playerid, -1, query);
  }
			case DIALOG_FRAKSKINS:
			{
				new locker_org_id = GetPVarInt(playerid, "OrgLockerTeam");
				DeletePVar(playerid, "OrgLockerTeam");
				if(!response) return 1;
				if(locker_org_id != GetPlayerTeamEx(playerid) || !(1 <= locker_org_id < MAX_ORG))
					return ShowNotificationNew(playerid, 2, 5, 0, 0, "Доступ к раздевалке недействителен", "");

				if(!GetPVarInt(playerid, "Form"))
				{
					if(GetPlayerData(playerid, P_OSKIN) <= 0)
						return ShowNotificationNew(playerid, 2, 5, 0, 0, "Рабочая форма не назначена", "");
					SetPVarInt(playerid, "Form", 1);
					SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
					SetPlayerColorEx(playerid, GetPlayerTeamColor(playerid));
					SendClientMessage(playerid, 0x3399FFFF, "{3399FF}Рабочий день начат. Вы надели рабочую форму.");
				}
				else
				{
					SetPVarInt(playerid, "Form", 0);
					SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
					SetPlayerColorEx(playerid, 0xFFFFFFFF);
					SendClientMessage(playerid, 0x3399FFFF, "{3399FF}Рабочий день закончен. Вы сняли рабочую форму.");
				}
				return 1;
			}
			case DIALOG_REGISTER:
			{
				// Registration is handled only by GUI 38.
				if(!IsPlayerLogged(playerid) && g_BRAuthStage[playerid] == BR_AUTH_PASSWORD) BRAuth_Open(playerid, false);
				return 1;
			}
			// -----------------------------------------------------------------
			case DIALOG_PLAYER_MENU:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
                        ShowPlayerStats(playerid);
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
                       } 
						case 2:
						{
                       ShowPlayerCMDSDialog(playerid);
                       // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
                      } 
						case 3:
						{
                         ShowPlayerSettings(playerid);
                         // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
                        } 
						case 4:
						{
                        ShowPlayerSecuritySettings(playerid);
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
                       }
						case 5:
						{
                        ShowPlayerReportMenuDialog(playerid);
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 5");
                       } 
						case 6:
						{
                          ShowPlayerImprovementsDialog(playerid);
                          // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 6");
                         }
						case 7:
						{
                        ShowServerRules(playerid);
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 7");
                       } 
						case 8:
						{
                         ShowPlayerChangeNameDialog(playerid);
                         // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 8");
                        } 
						case 9:
						{
                         ShowPlayerOpenDonate(playerid);
                         // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 9");
                        } 
						case 10: {
							Dialog
							(
								playerid, DIALOG_ACT_PROMO, DIALOG_STYLE_LIST,
								"{FF0000} Промокод",
								"{FFFF00} #1.    {FFFFFF}Активировать промокод\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
								"{FFFF00} #2. {FFFFFF}Подарок ютуберу\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
								"{FFFF00} #3. {FFFFFF}ТОП промокодов\t\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
								"{FFFF00} #4. {FFFFFF}Забрать призы\t\t\t\t\t\t\t {888888} нажмите для взаимодействия",
								"Далее", "Выйти"
							);
							// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 10");
						}
						case 11:
						{
                          callcmd::reward(playerid);
                          // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 11");
                         } 
						case 12:
						{
                          callcmd::quest(playerid);
                          // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 12");
                         } 
						default:
							return 1;
					}
				}
			}
			case DIALOG_ACT_PROMO:
			{
			    if(response)
			    {
					switch(listitem) {
						case 0:
						{
                        ShowPlayerPromoActive(playerid);
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 1");
                       } 
						case 1:
						{
                        callcmd::ytpromo(playerid, "");
                        // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 2");
                       } 
						case 2:
						{
						// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 3");
                        callcmd::createpromo(playerid, "");
                       } 
						case 3:
						{
						// SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Click Dialog 4");
                       callcmd::Promocomplete(playerid, "");
                      } 
					}
			    }
			}
			case DIALOG_OWNABLE_CAR_PT:
			{
			    if(response)
			    {
					ShowPerformanceItem(playerid, list_id);
			    }
			}

			case DIALOG_OWNABLE_CAR_PT_ITEM:
			{
			    if(response)
			    {
			        new vehicleid = GetPlayerOwnableCar(playerid);

			        if(vehicleid == INVALID_VEHICLE_ID)
			            return 1;

			        new index = GetVehicleData(vehicleid, V_ACTION_ID);

			        new pt_item_level[3],
			            pt_item_type = GetPVarInt(playerid, "pt_item_type");

			        pt_item_level[0] = GetOwnableCarData(index, OC_PT_ENGINE);
			        pt_item_level[1] = GetOwnableCarData(index, OC_PT_BRAKE);
			        pt_item_level[2] = GetOwnableCarData(index, OC_PT_STABILITY);

			        if(pt_item_level[pt_item_type - 1] != list_id - 1)
			        {
			            if(pt_item_level[pt_item_type - 1] < list_id - 1)
			            	SendClientMessage(playerid, 0x999999FF, "Сначала Вы должны приобрести предыдущее улучшение");

			            else
			                SendClientMessage(playerid, 0x999999FF, "Достигнут максимальный уровень улучшения, или вы не купили предыдущее улучшение");

			            ShowPerformanceItem(playerid, pt_item_type);

			            return 1;
			        }

			        if(pt_item_level[pt_item_type - 1] >= 3 && GetPlayerPremium(playerid) != 3)
			        {
			            SendClientMessage(playerid, 0x999999FF, "Покупка этого улучшения доступна только для пользователей имеющих VIP Gold статус.");
			            ShowPerformanceItem(playerid, pt_item_type);

			            return 1;
			        }

			        Dialog(playerid, DIALOG_OWNABLE_CAR_PT_ACCEPT, DIALOG_STYLE_MSGBOX, "Покупка улучшения", "{FFFFFF}Вы действительно хотите приобрести это улучшение?", "Купить", "Отмена");

			        SetPVarInt(playerid, "pt_item_id", list_id);
			    }
					else ShowVehicleImproveDialog(playerid);
			}
			case DIALOG_OWNABLE_CAR_PT_ACCEPT:
			{
				new pt_item_type = GetPVarInt(playerid, "pt_item_type"),
				pt_item_id = GetPVarInt(playerid, "pt_item_id");

				if(response)
				{
					new pt_item_price[3],
					pt_item_level[3],
					businessid;

					pt_item_price[0] = engine_ptune_price[pt_item_id - 1];
					pt_item_price[1] = brake_ptune_price[pt_item_id - 1];
					pt_item_price[2] = stability_ptune_price[pt_item_id - 1];

					if(GetPlayerMoneyEx(playerid) >= pt_item_price[pt_item_type - 1])
					{
						new vehicleid = GetPlayerOwnableCar(playerid);

						if(vehicleid == INVALID_VEHICLE_ID)
						return 0;

						new index = GetVehicleData(vehicleid, V_ACTION_ID);

						pt_item_level[0] = GetOwnableCarData(index, OC_PT_ENGINE);
						pt_item_level[1] = GetOwnableCarData(index, OC_PT_BRAKE);
						pt_item_level[2] = GetOwnableCarData(index, OC_PT_STABILITY);

						pt_item_level[pt_item_type - 1] ++;

						SetOwnableCarData(index, OC_PT_ENGINE, pt_item_level[0]);
						SetOwnableCarData(index, OC_PT_BRAKE, pt_item_level[1]);
						SetOwnableCarData(index, OC_PT_STABILITY, pt_item_level[2]);

						new query[255];

						mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET pt_engine=%d, pt_brake=%d, pt_stability=%d WHERE id=%d", pt_item_level[0], pt_item_level[1], pt_item_level[2], GetOwnableCarData(index, OC_SQL_ID));
						mysql_query(mysql, query);
                        TechCenter_ApplyPerformance(vehicleid);
						print(query);
						if(mysql_errno())
							return printf("sql error %d", mysql_errno());

						GivePlayerMoneyEx(playerid, -pt_item_price[pt_item_type - 1], "Performance Tuning");

						SendClientMessage(playerid, 0x66CC33FF, "Вы успешно приобрели улучшение");

						businessid = GetPlayerInBiz(playerid);

						new price = pt_item_price[pt_item_type - 1];
						new take_prods = 5;

						if(GetBusinessData(businessid, B_PRODS) >= take_prods)
						{
							format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
						}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						
						if(!mysql_errno())
						{
							if(GetBusinessData(businessid, B_PRODS) >= take_prods)
							{
								SetBusinessData(businessid, B_PRODS, 10_000);
								AddBusinessData(businessid, B_BALANCE, +, price/2);
							}

							mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
							mysql_query(mysql, query, false);
						}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 22)");
						
					}
				}

				ShowPerformanceItem(playerid, pt_item_type);
			}
			case DIALOG_QM:
            {
                if (!response) return 1;

                switch( listitem )
                {
                    case 0..19:
                    {
                        new format_str[28];
                        format(format_str, sizeof format_str, "Введите текст для поля №%d", listitem+1);

                        if(!strcmp(quick_mes[playerid][listitem][line], format_str, true, 64 ))
                            return SendClientMessage(playerid, -1, "Текст для данного сообщения не установлен, для того чтобы задать текст перейдите в раздел {FFBF00}'Редактировать'");

                        sendQuickMessage(playerid, quick_mes[playerid][listitem][line]);
                        callcmd::binder(playerid);
                    }
                    case 21:
                    {
                        for( new j; j < 5; j++)
                            sendQuickMessage(playerid, quick_mes[playerid][j][line]);
                    }
                    case 22: editMessage(playerid);
                }
                return 1;
            }
            case DIALOG_EDIT_QM:
            {
                if (!response) return callcmd::binder(playerid);
                if (listitem != 20)
                Dialog(playerid, DIALOG_TEXT_QM, DIALOG_STYLE_INPUT, "{FFBF00}Введите сообщение:", " ", "Сохранить", "Назад");
                else
                {
                    for( new j; j < 20; j++ )
                        format(quick_mes[playerid][j][line], 28, "Введите текст для поля №%d", j+1);
                //
                    editMessage(playerid);
                }
                SetPVarInt(playerid, #dialog, listitem+1);
            }
			case DIALOG_TEXT_QM:
            {
                if (!response)
                    return editMessage(playerid);

                if (strlen (inputtext) > 128)
                {
                    SendClientMessage(playerid, -1, "Максимальное количество символов 128");

                    return Dialog(playerid, DIALOG_TEXT_QM, DIALOG_STYLE_INPUT, "{37B6CE}Введите сообщение:", " ", "Сохранить", "Назад");
                }

                for( new j; j < 20; j++ )
                {
                    if(GetPVarInt(playerid, #dialog) == j+1)
                    {
                        format(quick_mes[playerid][j][line], 128, inputtext);
                        save_QuickMessage(playerid, j);
                    }
                }
                editMessage(playerid);

            }
			case DIALOG_PLAYER_STATS:
			{
				if(response)
				{
					callcmd::mm(playerid, "");
				}
			}
						case DIALOG_SELL_GIFT:
			{
			    if(!response) return 1;

			    new rand_prize = random(8),
					fmt_str[159];

			    switch(rand_prize)
			    {
			        case 1:
			        {
						new rand = random(50);

						AddPlayerData(playerid, P_AMMO, +, rand);
						UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали Патроны: {FFFFFF}%d шт.", rand);

			        }
			        case 2:
					{
						new rand = random(50);

						AddPlayerData(playerid, P_METALL, +, rand);
						UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпал Материалы: {FFFFFF}%d кг.", rand);
					}
					case 3:
					{
					    new rand = random(100);

						AddPlayerData(playerid, P_DRUGS, +, rand);
						UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали наркотики: {FFFFFF}%d гр.", rand);
					}
					case 4:
					{
					    new rand = random(2000000);

					    GivePlayerMoneyEx(playerid, rand, "подковы", true, true);

					    format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали деньги: {FFFFFF}$%d", rand);
					}
					case 5:
					{
					    format(fmt_str, sizeof fmt_str, "Отклчено!.");
					}
					case 6:
					{
						new rand = random(1000);

					    GivePlayerDonate(playerid, rand, "подковы", true);

					    format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпал донат: {FFFFFF}%d шт.", rand);
					}
   			        case 7:
			        {
						new rand = random(300);

						AddPlayerData(playerid, P_AMMO, +, rand);
						UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали Патроны: {FFFFFF}%d шт.", rand);
			        }
			        case 8:
					{
						new rand = random(150);

						AddPlayerData(playerid, P_METALL, +, rand);
						UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпал Материалы: {FFFFFF}%d кг.", rand);
					}
					case 9:
					{
					    new rand = random(150);

						AddPlayerData(playerid, P_DRUGS, +, rand);
						UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали наркотики: {FFFFFF}%d гр.", rand);
					}
			        default:
			        {
						new rand = random(300);

						AddPlayerData(playerid, P_AMMO, +, rand);
						UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

						format(fmt_str, sizeof fmt_str, "Вы обменяли подарок, Вам выпали Патроны: {FFFFFF}%d шт.", rand);

			        }
			    }

			    SendClientMessage(playerid, 0x3399FFFF, fmt_str);
			    AddPlayerData(playerid, P_GIFTS, -, 1);

			    new fmt_str1[144];
			    format(fmt_str1, sizeof fmt_str1, "У Вас осталось подарков: {FFFFFF}%d шт.", GetPlayerData(playerid, P_GIFTS));
				SendClientMessage(playerid, 0xffff00FF, fmt_str1);
				new query[144];

				format(query, sizeof query, "UPDATE accounts SET gifts=%d WHERE id=%d", GetPlayerData(playerid, P_GIFTS), GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
			}
			case DIALOG_AUTOSALON_CAR_BUY:
			{
			    if(!response) return 1/*RemovePlayerFromVehicle(playerid)*/;

                new biz_id = GetPlayerInBiz(playerid);
				if (biz_id == -1) return 1;
				new car_market_id = GetCarMarketIdByBizId(biz_id);
				if(GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CAR_MARKET) return 1;
				BuyOwnableCar(playerid, car_market_id, buy_car_select_car[playerid]);
				return 1;

			    
			}
case DIALOG_RENT_BIKE:
{
    if(!response) return 1;

    new idx = GetPlayerListitemValue(playerid, listitem);

    switch(idx)
    {
        case RENT_BIKE_ITEM_SCOOTER:
        {
            if(GetPlayerData(playerid, P_RENT_BIKE))
                return ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы уже арендовали скутер!", "");

            if(GetPlayerMoneyEx(playerid) < 50)
                return ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас недостаточно средств для аренды!", "");

            GivePlayerMoneyEx(playerid, -50, "Аренда скутера", true);
            BlackPass_OnScooterRent(playerid);

            new Float:POS[4];
            GetPlayerPos(playerid, POS[0], POS[1], POS[2]);
            GetPlayerFacingAngle(playerid, POS[3]);

            SetPlayerData(playerid, P_RENT_BIKE, CreateVehicle(462, POS[0], POS[1], POS[2], POS[3], 0, 0, 300, 0, VEHICLE_ACTION_TYPE_RENT_BIKE));
            PutPlayerInVehicle(playerid, GetPlayerData(playerid, P_RENT_BIKE), 0);
            return 1;
        }
        case RENT_BIKE_ITEM_PREV:
            return ShowRentBikeDialog(playerid, gRentBikeDialogPage[playerid] - 1);

        case RENT_BIKE_ITEM_NEXT:
            return ShowRentBikeDialog(playerid, gRentBikeDialogPage[playerid] + 1);

        default:
        {
            if(idx > 0)
                ShowOwnableCarLoadDialog(playerid, idx, false, true);
        }
    }
    return 1;
}

            case DIALOG_ORG_CAR_GET:
	        {
	            if(!response) return 1;
	            new fmt_text[100];
	            new action_id = GetPlayerListitemValue(playerid, 0);

	            format(fmt_text, sizeof fmt_text, ""SC"Вы взяли транспорт {ffff00}%s", g_vehicle_info[g_org_car[action_id][O_MODEL][listitem]-400][VI_NAME]);
	            SendClientMessage(playerid, -1, fmt_text);
	            SendClientMessage(playerid, -1, ""SC"Если вы не будете использовать транспорт в течении двух минут, он будет удален");

	            new buy_cars_count = g_org_car[action_id][O_COUNT]++;

	            if(buy_cars_count >= 4)
	            g_org_car[action_id][O_COUNT] = 0;

	            new Float: pos_x = org_car_pos_spawn[action_id][buy_cars_count][0];
	            new Float: pos_y = org_car_pos_spawn[action_id][buy_cars_count][1];
	            new Float: pos_z = org_car_pos_spawn[action_id][buy_cars_count][2];
	            new Float: angle = org_car_pos_spawn[action_id][buy_cars_count][3];

	            new vehicleid = CreateVehicle(g_org_car[action_id][O_MODEL][listitem], pos_x, pos_y, pos_z, angle, g_org_car[action_id][O_COLOR][0], g_org_car[action_id][O_COLOR][1], 120, 0, VEHICLE_ACTION_ORG_CAR, g_org_car[action_id][O_FRAC_ID]);
	            SetVehicleData(vehicleid, V_ACTION_OWNER, playerid); //
	            SetPlayerData(playerid, P_FRACTION_CAR, vehicleid);
	            //    PutPlayerInVehicle(playerid, vehicleid, 0);

	        }
			case DIALOG_PLAYER_CMDS:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды транспорта",
								"{00CC33}/car{FFFFFF} - меню транспорта\n"\
								"{00CC33}/key{FFFFFF}  - вставить ключ\n"\
								"{00CC33}/e{FFFFFF} - завести двигатель\n"\
								"{00CC33}/lock{FFFFFF} - закрыть транспорт\n"\
								"{00CC33}/park{FFFFFF} - припарковать транспорт",
								"Назад", "Закрыть"
							);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды общения",
								"{00CC33}/c(all) [номер]{FFFFFF} - позвонить\n"\
								"{00CC33}/sms [номер] [текст]{FFFFFF}  - отправить сообщение\n"\
								"{00CC33}/p{FFFFFF} - принять вызов\n"\
								"{00CC33}/h{FFFFFF} - завершить вызов\n"\
								"{00CC33}/f(n) [текст]{FFFFFF} - рация семьи\n"\
								"{00CC33}/r(n) [текст]{FFFFFF} - рация организации\n"\
								"{00CC33}/me [текст]{FFFFFF} - выполнить действие\n"\
								"{00CC33}/do [текст]{FFFFFF} - выполнить действие от 3-го лица\n"\
								"{00CC33}/try [текст]{FFFFFF} - выполнить действие (Удачно/не удачно)\n"\
								"{00CC33}/s [текст]{FFFFFF} - крикнуть\n"\
								"{00CC33}/n [текст]{FFFFFF} - OOC чат\n"\
								"{00CC33}/w [текст]{FFFFFF} - прошептать\n"\
								"{00CC33}/ad [текст]{FFFFFF} - подать объявление\n"\
								"{00CC33}/u [текст]{FFFFFF} - радио-эфир (для гостя)\n"\
								"{00CC33}/gnews [текст]{FFFFFF} - гос. волна\n",
								"Назад", "Закрыть"
							);
						}
						case 3:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды дома",
								"{00CCFF}/home{FFFFFF} - панель управление\n"\
								"{00CCFF}/sellhome{FFFFFF} - продать дом гос-ву\n"\
								"{00CCFF}/sellmyhome [id игрока] [цена]{FFFFFF} - продать дом игроку\n"\
								"{00CCFF}/exit{FFFFFF} - выйти из дома\n"\
								"{00CCFF}/makestore{FFFFFF} - перенести шкаф\n"\
								"{00CCFF}/use{FFFFFF} - использовать шкаф\n"\
								"{00CCFF}/live [id игрока]{FFFFFF} - прописать игрока\n"\
								"{00CCFF}/liveout [id игрока]{FFFFFF} - выгнать игрока\n"\
								"{00CCFF}/homelock{FFFFFF} - закрыть/открыть дом",
								"Назад", "Закрыть"
							);
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды бизнеса",
								"{33CC66}/business{FFFFFF} - панель управление\n"\
								"{33CC66}/sellbiz{FFFFFF} - продать бизнес гос-ву\n"\
								"{33CC66}/buybiz{FFFFFF} - купить бизнес\n"\
								"{33CC66}/sellmybiz [id игрока] [цена]{FFFFFF} - продать бизнес игроку\n"\
								"{33CC66}/fuelst{FFFFFF} - панель управления АЗС\n"\
								"{33CC66}/sellfuelst{FFFFFF} - продать АЗС гос-ву\n"\
								"{33CC66}/buyfuelst{FFFFFF} - купить АЗС\n"\
								"{33CC66}/sellmyfuelst [id игрока] [цена]{FFFFFF} - продать АЗС игроку",
								"Назад", "Закрыть"
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды работ",
								"{6699CC}/getfuel{FFFFFF} - заказать топливо (механик)\n"\
								"{6699CC}/fill [id игрока] [кол-во] [цена]{FFFFFF} - продать топливо игроку\n"\
								"{6699CC}/repair [id игрока]{FFFFFF} - починить транспорт",
								"Назад", "Закрыть"
							);
						}
						case 6:
						{
      						Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды банд",
								"{CCCC33}/makegun{FFFFFF} - создать оружие\n"\
								"{CCCC33}/capture{FFFFFF} - начать захват\n"\
								"{CCCC33}/(un)tie{FFFFFF} - связать / развязать\n"\
								"{CCCC33}/close{FFFFFF} - закрыть склад\n"\
								"{CCCC33}/killstop{FFFFFF} - топ по киллам на каптах",
								"Назад", "Закрыть"
							);
						}
						case 7:
						{
                            Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды правительства",
								"{99CC33}/smenu{FFFFFF} - меню советника\n"\
								"{99CC33}/givelic{FFFFFF} - выдать лицензию\n"\
								"{99CC33}/free{FFFFFF} - выпустить преступника\n"\
								"{99CC33}/debtorlist{FFFFFF} - список должников\n"\
								"{99CC33}/debtorsell{FFFFFF} - забрать имущество у должника",
								"Назад", "Закрыть"
							);
       					}
       					case 8:
						{
                            Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды армии",
								"Команд нету",
								"Назад", "Закрыть"
							);
						}
						case 9:
						{
                            Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды полиции",
								"{0066FF}/search{FFFFFF} - произвести обыск\n"\
								"{0066FF}/(un)cuff{FFFFFF} - надеть / снять наручники\n"\
								"{0066FF}/su{FFFFFF} - выдать розыск\n"\
								"{0066FF}/clear{FFFFFF} - очистить розыск\n"\
								"{0066FF}/arrest{FFFFFF} - посадить в кпз\n"\
								"{0066FF}/m [текст]{FFFFFF} - мегафон\n"\
								"{0066FF}/ticket{FFFFFF} - выдать штраф\n"\
								"{0066FF}/takelic{FFFFFF} - отобрать лицензии\n"\
								"{0066FF}/wanted{FFFFFF} - список подозреваемых\n"\
								"{0066FF}/follow{FFFFFF} - вести преступника за собой\n"\
								"{0066FF}/putpl{FFFFFF} - затолкать в транспорт\n"\
								"{0066FF}/(off)dis{FFFFFF} - замаскироваться(ФСБ)",
								"Назад", "Закрыть"
							);
						}
						case 10:
						{
						    Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды СМИ",
								"{FFCC33}/edit{FFFFFF} - редактировать объявление\n"\
								"{FFCC33}/t{FFFFFF} - радио-эфир\n"\
								"{FFCC33}/givemic{FFFFFF} - дать доступ к эфиру",
								"Назад", "Закрыть"
							);
						}
						case 11:
						{
						    Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды медиков",
								"{FF66FF}/medhelp [id игрока]{FFFFFF} - предложить лечение в больнице\n"\
								"{FF66FF}/heal [id игрока]{FFFFFF} - предложить лечение на выезде\n"\
								"{FF66FF}/out [id игрока]{FFFFFF} - выписать игрока из больницы\n"\
								"{FF66FF}/changesex [id игрока]{FFFFFF} - сменить пол игроку",
								"Назад", "Закрыть"
							);
						}
						case 12:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Команды лидеров",
								"{ABCDEF}/invite{FFFFFF} - принять в организацию\n"\
								"{ABCDEF}/uninvite{FFFFFF} - уволить игрока\n"\
								"{ABCDEF}/rang{FFFFFF} - выдать ранг игроку\n"\
								"{ABCDEF}/changeskin{FFFFFF} - сменить скин\n"\
								"{ABCDEF}/showall{FFFFFF} - список всех сотрудников\n"\
								"{ABCDEF}/uninviteoff{FFFFFF} - уволить в оффлайне\n"\
								"{ABCDEF}/addvacancy{FFFFFF} - создать вакансию\n"\
								"{ABCDEF}/delvacancy{FFFFFF} - удалить вакансию.\n"\
								"{ABCDEF}/gnews{FFFFFF} - государственная волна",
								"Назад", "Закрыть"
							);
						}
						case 13:
						{
							Dialog
							(
								playerid, DIALOG_PLAYER_CMDS, DIALOG_STYLE_MSGBOX,
								"Общие команды",
								"{00CC33}/mycoins [id игрока] [количество]{FFFFFF} - посмотреть свое количество монет\n"\
								"{00CC33}/givemycoins [id игрока] [количество]{FFFFFF} - передать монеты\n"\
								"{00CC33}/mm{FFFFFF} - выбрать пункт\n"\
								"{00CC33}/pay [id игрока] [количество]{FFFFFF} - передать деньги\n"\
								"{00CC33}/online{FFFFFF} - онлайн сервера",
								"Назад", "Закрыть"
							);
						}
						default:
							return 1;
					}
					//ShowPlayerCMDSDialog(playerid);
				}
					else callcmd::mm(playerid, "");
			}
			case DIALOG_PLAYER_SETTINGS:
			{
				if(response)
				{
					new E_PLAYER_SETTINGS_STRUCT: setting_id = E_PLAYER_SETTINGS_STRUCT: listitem;
					switch(listitem)
					{
						case 0..5:
						{
							if(S_CHAT_TYPE <= setting_id <= S_VEH_CONTROL)
							{
								new setting_type = GetPlayerSettingData(playerid, setting_id);

								switch(setting_id)
								{
									case S_CHAT_TYPE:
									{
										if(!(SETTING_CHAT_OFF <= ++setting_type <= SETTING_CHAT_ADVANCE))
										{
											setting_type = SETTING_CHAT_OFF;
										}
									}
									case S_TEAM_CHAT..S_VEH_CONTROL:
									{
										setting_type ^= SETTING_TYPE_ON;
									}
								}
								if(setting_id == S_PLAYERS_NICK)
								{
									foreach(new idx : Player)
										ShowPlayerNameTagForPlayer(playerid, idx, setting_type);
								}

								SetPlayerSettingData(playerid, setting_id, setting_type);
								SetPlayerChatInit(playerid);

								ShowPlayerSettings(playerid);
							}
						}
						case 6:
						{
							Dialog
						    (
						        playerid, DIALOG_SET_SPAWN, DIALOG_STYLE_LIST,
						        "{FFCC00}Изменение места появления в игре",
						        "1. На Ж/Д вокзале или автостанции\n\
						        2. В собственном доме\n\
						        3. В гостиничном номере\n\
						        4. На базе организации\n\
						        5. В гостях (совместное проживание)\n\
						        6. На базе семьи",
						        "Выбрать", "Отмена"
						    );
						}
						case 7:
						{
							new query[128];

							format
							(
								query, sizeof query,
								"UPDATE accounts SET "\
								"setting1=%d,"\
								"setting2=%d,"\
								"setting4=%d,"\
								"setting5=%d,"\
								"setting6=%d"\
								" WHERE id=%d LIMIT 1",
								GetPlayerSettingData(playerid, S_CHAT_TYPE),
								GetPlayerSettingData(playerid, S_TEAM_CHAT),
								GetPlayerSettingData(playerid, S_NICK_IN_CHAT),
								GetPlayerSettingData(playerid, S_ID_IN_CHAT),
								GetPlayerSettingData(playerid, S_VEH_CONTROL),
								GetPlayerAccountID(playerid)
							);
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								Dialog
								(
									playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Сохранено",
									"{FFFFFF}Новые настройки будут автоматически устанавливаться после каждой авторизации",
									"Ок", ""
								);
							}
					else
							{
								SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 02)");
								ShowPlayerSettings(playerid);
							}

						}

					}
				}
					else callcmd::mm(playerid, "");
			}
			case DIALOG_PLAYER_SECURITY_SETTINGS:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
								"{FFCD00}Информация о настройках",
								"{FFFFFF}Тут Вы можете изменить настройки безопасности вашего аккаунта. Это\n"\
								"поможет защитить его от взлома.\n\n"\
								"Существуют 3 вида защиты: с использованием мобильного приложения\n"\
								"{6699FF}Google Authenticator{FFFFFF}, системы 'Случайный код' или номера мобильного\n"\
								"телефона. Если Вы включите защиту, то при авторизации, помимо\n"\
								"пароля, будет запрашиваться ввод кода или части номера телефона\n"\
								"(в зависимости от ваших настроек). Подробнее Вы можете узнать, выбрав\n"\
								"нужный пункт в меню безопасности.\n\n"\
								"Система будет запрашивать ввод только если Ваш IP адрес или подсеть\n"\
								"(первые 2 цифры IP адреса) игрока не совпадают с теми, которые были\n"\
								"записаны при успешном входе в игру. Другими словами, система\n"\
								"выдаст запрос, если под Вашим аккаунтом попытаются зайти с другого\n"\
								"компьютера.",
								"Назад", ""
							);
						}
						case 2:
						{
							if(strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true) != 0)
							{
								// установлен
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PHONE, DIALOG_STYLE_LIST,
									"{FFCD00}При авторизации запрашивать мобильный...",
									"Не запрашивать\n"\
									"Если подсеть не совпадает с моей\n"\
									"Если IP не совпадает с моим",
									"Сохранить", "Назад"
								);
							}
					else
							{
								// не установлен
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Мобильный телефон",
									"{FFFFFF}В данный момент мы проводим обновление этой системы безопасности.\n"\
									"Приносим свои извинения за временные неудобства.",
									"Назад", ""
								);
							}

						}
						case 3:
						{
							if(strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true) != 0)
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN, DIALOG_STYLE_LIST,
									"{FFCD00}При авторизации запрашивать случайный PIN-код...",
									"Не запрашивать\n"\
									"Если подсеть не совпадает с моей\n"\
									"Если IP не совпадает с моим",
									"Сохранить", "Назад"
								);
							}
					else
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN_SET, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Случайный PIN-код",
									"{FFFFFF}Для продолжения, вам необходимо придумать и набрать 4-х значный код.\n\n"\
									"Эта система безопасности поможет защитить Ваш аккаунт, если на\n"\
									"компьютер попадет вирус-кейлоггер, который перехватывает данные с\n"\
									"клавиатуры.  Кнопки всегда располагаются в случайном порядке, что не даст\n"\
									"злоумышленникам возможность узнать ваш PIN-код.",
									"Далее", "Назад"
								);
							}
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX,
								"{FFCD00}Защита с использованием приложения Authenticator",
								"{FFFFFF}Этот тип защиты является самым надежным для Вашего аккаунта. Чтобы его активировать,\n"\
								"зайдите в Личный Кабинет на сайте {33CCFF}"SERVER_SITE" (Настройки > Защитить акк.) {FFFFFF}и следуйте\n"\
								"инструкциям.\n\n"\
								"Вам потребуется мобильное устройство с поддержкой сторонних приложений (Android, iOS,\n"\
								"Windows Phone и другие). После включения защиты на сайте, вернитесь в это меню для\n"\
								"завершения настройки.",
								"Назад", ""
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_PASS_1, DIALOG_STYLE_INPUT,
								"{00FFFF}"SERVER_NAME"{ffffff} | Изменение пароля",
								"{FFFFFF}Введите Ваш текущий пароль в поле ниже:",
								"Далее", "Назад"
							);
						}
						case 6:
						{
							if(!strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true))
							{
								Dialog
								(
									playerid, DIALOG_SECURITY_SETTING_PIN_SET, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Случайный PIN-код",
									"{FFFFFF}Для продолжения, вам необходимо придумать и набрать 4-х значный код.\n\n"\
									"Эта система безопасности поможет защитить Ваш аккаунт, если на\n"\
									"компьютер попадет вирус-кейлоггер, который перехватывает данные с\n"\
									"клавиатуры.  Кнопки всегда располагаются в случайном порядке, что не даст\n"\
									"злоумышленникам возможность узнать ваш PIN-код.",
									"Далее", "Назад"
								);
							}
					else ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_CHECK);
						}
						case 7:
						{
							// 7. Статус безопасности
							static const
								setting_status_name[3][64] =
							{
								"{CC9900}Не запрашивается",
								"{3399FF}Запрашивается при несовпадении подсети",
								"{009900}Запрашивается при несовпадении IP"
							};

							new fmt_str[364];
							format
							(
								fmt_str, sizeof fmt_str,
								"{FFFFFF}Тут Вы можете увидеть статус всех Ваших настроек безопасности.\n"\
								"Для их изменения, выберите нужный пункт в меню настроек\n\n"\
								"Мобильный телефон:\t\t%s\n"\
								"{FFFFFF}Случайный PIN-код:\t\t%s\n"\
								"{FFFFFF}Google Authenticator:\t\t{CC9900}Не запрашивается",
								setting_status_name[GetPlayerData(playerid, P_REQUEST_PHONE)],
								setting_status_name[GetPlayerData(playerid, P_REQUEST_PIN)]
							);
							Dialog(playerid, DIALOG_SECURITY_SETTING_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Статус безопасности", fmt_str, "Назад", "");
						}
						case 8:
						{
						/*	if(GetPlayerData(playerid, P_CONFIRM_EMAIL))
								return SendClientMessage(playerid, 0xFFFFFFFF, "Ваш Email-адрес уже подтвержден");

							Dialog
							(
								playerid, DIALOG_SECURITY_SETTING_EMAIL, DIALOG_STYLE_MSGBOX,
								"{6699FF}Подтверждение Email",
								"{FFFFFF}При регистрации на сервере на Вашу почту мы выслали ссылку для\n"\
								"подтверждения Email. Она действительна в течение 14 дней.\n"\
								"Пожалуйста, проверьте почту и подтвердите ее.\n\n"\
								"В случае, если вы не получили наше письмо, нажмите кнопку \"Повтор\".\n"\
								"Мы отправим Вам новую ссылку.",
								"Закрыть", "Повтор"
							);
							*/
							SendClientMessage(playerid, -1, "Отключено!");
						}
						default:
							return 1;
					}
				}
					else callcmd::mm(playerid, "");
			}
			case DIALOG_ACTION_EXIT_HOUSE:
			{
				if(response)
					ExitPlayerFromHouse(playerid, 3.0, listitem);
			}
			case DIALOG_ACTION_TYPE_GET_FAMILY:
            {
                if(!(g_family_loaded >= MAX_FAM))
                {
                    Dialog
                    (
                        playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
                        "Создание семьи",
                        "{FFFFFF}Стоимость создания семьи:{32a44b} 3kk рублей\n\
                        {FFFFFF}Чтобы создать семью, введите название семьи, и нажмите 'Создать'",
                        "Создать", "Отмена"
                    );
                }
            }
            case DIALOG_CREATE_FAMILY:
            {
                if(!response) return 1;
                return FamilyCreate(playerid, inputtext);
            }
case DIALOG_ACTION_QUEST:
{
    if(!response) return 1;

    switch(listitem)
    {
        case 0: // Квест 1 - Первые деньги
        {
            if(GetPlayerData(playerid, P_QUEST_1) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Перенеси 10 мешков на работе грузчика.\n"\
                ""c_server"Награда: "c_m"5000 руб\n"\
                ""c_server"Местоположение: "c_b"/gps > Контейнеры\n"\
                ""c_server"Прогресс: "c_b"%d/10",
                GetPlayerData(playerid, P_QUEST_EXP_1)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Первые деньги", fmt_str, "Закрыть", "");
            return 1;
        }
        case 1: // Квест 2 - Получить водительские права
        {
            if(GetPlayerData(playerid, P_QUEST_2) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Получите водительские права.\n"\
                ""c_server"Награда: "c_m"5000 руб\n"\
                ""c_server"Местоположение: "c_b"/gps > Автошкола\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_2)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Водительские права", fmt_str, "Закрыть", "");
            return 1;
        }
        case 2: // Квест 3 - Приобрести телефон
        {
            if(GetPlayerData(playerid, P_QUEST_3) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Купи мобильный телефон\n"\
                ""c_server"Награда: "c_m"5000 руб\n"\
                ""c_server"Местоположение: "c_b"/gps > Ближайшие места > Ближайший 24/7\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_3)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Приобрести телефон", fmt_str, "Закрыть", "");
            return 1;
        }
        case 3: // Квест 4 - Тяжелая профессия
        {
            if(GetPlayerData(playerid, P_QUEST_4) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Ступай на шахту и поработай там\n"\
                ""c_server"Награда: "c_m"5000 руб\n"\
                ""c_server"Местоположение: "c_b"/gps > Работы для новичков > Работа шахтера\n"\
                ""c_server"Прогресс: "c_b"%d/20",
                GetPlayerData(playerid, P_QUEST_EXP_4)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Тяжелая профессия", fmt_str, "Закрыть", "");
            return 1;
        }
        case 4: // Квест 5 - Устроиться на официальную работу
        {
            if(GetPlayerData(playerid, P_QUEST_5) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Отправляйся в любой автосалон и купи себе транспорт\n"\
                ""c_server"Награда: "c_m"10000 руб\n"\
                ""c_server"Местоположение: "c_b"/gps > Автосалоны\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_5)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Официальная работа", fmt_str, "Закрыть", "");
            return 1;
        }
        case 5: // Квест 6 - Вступить во фракцию
        {
            if(GetPlayerData(playerid, P_QUEST_6) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Вступи в любую организацию.\n"\
                ""c_server"Награда: "c_m"10000 руб\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_6)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Вступить во фракцию", fmt_str, "Закрыть", "");
            return 1;
        }
        case 6: // Квест 7 - Вступить в семью
        {
            if(GetPlayerData(playerid, P_QUEST_7) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Вступи в любую семью\n"\
                ""c_server"Награда: "c_m"10000 руб\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_7)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Вступить в семью", fmt_str, "Закрыть", "");
            return 1;
        }
        case 7: // Квест 8 - Приобрести первый автомобиль
        {
            if(GetPlayerData(playerid, P_QUEST_8) >= 1)
                return Send(playerid, -1, "Вы уже выполнили этот квест");

            new fmt_str[255 + 1];
            format(fmt_str, sizeof fmt_str,
                ""c_server"Информация: "c_b"Купи первый автомобиль\n"\
                ""c_server"Награда: "c_m"10000 руб\n"\
                ""c_server"Прогресс: "c_b"%d/1",
                GetPlayerData(playerid, P_QUEST_EXP_8)
            );

            Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квест | Первый автомобиль", fmt_str, "Закрыть", "");
            return 1;
        }
    }
}
			case DIALOG_FAMILY_CAR_RANG:
            {
                if(response)
                {
                    new idx = GetPVarInt(playerid, "sql_id"),
                        model_id,
                        rang,
                        Cache: result,
                        query[120];

                    mysql_format(mysql, query, sizeof query, "SELECT model_id, rang FROM family_cars WHERE id='%d'", idx);
                    result = mysql_query(mysql, query, true);
                    printf(query);

                    if(cache_num_rows(result))
                    {
                        model_id = cache_get_field_content_int(0, "model_id");
                        rang = cache_get_field_content_int(0, "rang");
                    }
                    format(query, sizeof(query),
					""c_b"Модель: "c_s"%s\n\
					"c_b"Доступна с "c_s"%d "c_b"ранга\n\
					Введите новый ранг с которого будет доступен этот транспорт",
					GetVehicleInfo(model_id-400, VI_NAME),
					rang);

					Dialog(playerid, DIALOG_FAMILY_CAR_RANG_SET, DIALOG_STYLE_INPUT,"Транспорт семьи", query, "Далее", "Отмена");

					printf(query);
                    cache_delete(result);
                }
            }
			case DIALOG_FAMILY_CAR_RANG_SET:
            {
                if(response)
                {
                    new input = strval(inputtext);
                    if(input < 11 && IsNumeric(inputtext))
                    {
                        new idx = GetPVarInt(playerid, "sql_id"),
                             query[100];

                        SetFamilyCarData(idx, F_RANG, input);

                        mysql_format(mysql, query, sizeof query, "UPDATE family_cars SET rang = '%d' WHERE id='%d'",input, idx);
                        mysql_query(mysql, query, false);
                        SendClientMessage(playerid, -1, "Ранг успешно изменён");
                    }
                }
            }
			case DIALOG_COLOR_FAMILY_SET:
			{
			    ShowFamilyColorSet(playerid);
			}
			case DIALOG_FAMILY_SETRANG_MENU:
            {
                //new fmt_text[500], fam_id = GetPlayerData(playerid, P_FAMILY);
                if(!response) return callcmd::fmenu(playerid, "");

			    switch(list_id)
				{
				    case 1:
				    {
				        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_INV, DIALOG_STYLE_LIST, "Доступ к команде /finvite", fmt_text, "Далее", "Закрыть");
				    }
				    case 2:
				    {
				        new fmt_text[500],
								fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_UNINV, DIALOG_STYLE_LIST, "Доступ к команде /funinvite", fmt_text, "Далее", "Закрыть");

				    }
				    case 3:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_MUTE, DIALOG_STYLE_LIST, "Доступ к команде /fmute", fmt_text, "Далее", "Закрыть");

				    }
				    case 4:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_UNMUTE, DIALOG_STYLE_LIST, "Доступ к команде /funmute", fmt_text, "Далее", "Закрыть");
				    }
				    case 5:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_WARN, DIALOG_STYLE_LIST, "Доступ к команде /fwarn", fmt_text, "Далее", "Закрыть");

				    }
				    case 6:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_UNWARN, DIALOG_STYLE_LIST, "Доступ к команде /funwarn", fmt_text, "Далее", "Закрыть");

				    }
				    case 7:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_GIVER, DIALOG_STYLE_LIST, "Доступ к команде /frang", fmt_text, "Далее", "Закрыть");

				    }
				    case 8:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_TAKEMONEY, DIALOG_STYLE_LIST, "Доступ к деньгам на складе", fmt_text, "Далее", "Закрыть");

				    }
				    case 9:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_TAKEDRUGS, DIALOG_STYLE_LIST, "Доступ к наркотикам на складе", fmt_text, "Далее", "Закрыть");

				    }
				    case 10:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_TAKEMETALL, DIALOG_STYLE_LIST, "Доступ к Материалыу на складе", fmt_text, "Далее", "Закрыть");

				    }
				    case 11:
				    {

                        new fmt_text[500],
							fam_id = GetPlayerData(playerid, P_FAMILY);

					 	format(fmt_text, sizeof fmt_text,
						""c_server"[1] "c_b"%s\n\
						"c_server"[2] "c_b"%s\n\
						"c_server"[3] "c_b"%s\n\
						"c_server"[4] "c_b"%s\n\
						"c_server"[5] "c_b"%s\n\
						"c_server"[6] "c_b"%s\n\
						"c_server"[7] "c_b"%s\n\
						"c_server"[8] "c_b"%s\n\
						"c_server"[9] "c_b"%s\n\
						"c_server"[10] "c_b"%s",
						GetFamilyData(fam_id, F_RANK1),
						GetFamilyData(fam_id, F_RANK2),
						GetFamilyData(fam_id, F_RANK3),
						GetFamilyData(fam_id, F_RANK4),
						GetFamilyData(fam_id, F_RANK5),
						GetFamilyData(fam_id, F_RANK6),
						GetFamilyData(fam_id, F_RANK7),
						GetFamilyData(fam_id, F_RANK8),
						GetFamilyData(fam_id, F_RANK9),
						GetFamilyData(fam_id, F_RANK10));

						Dialog(playerid, DIALOG_SET_FRANG_TAKEAMMO, DIALOG_STYLE_LIST, "Доступ к патронам на складе", fmt_text, "Далее", "Закрыть");

				    }
				}
            }
            case DIALOG_SET_FRANG_INV:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Inv='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_INV, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /finvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_UNINV:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnInv='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNINV, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funinvite на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_MUTE:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Mute='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_MUTE, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_UNMUTE:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnMute='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNMUTE, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funmute на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_WARN:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_Warn='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_WARN, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /fwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_UNWARN:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_UnWarn='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_UNWARN, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /funwarn на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_GIVER:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_GiveRang='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_RANG_GIVER, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к команде /frang на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_TAKEMONEY:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMoney='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_MONEY, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'деньгам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_TAKEDRUGS:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeDrugs='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_DRUGS, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'наркотикам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_TAKEMETALL:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeMetall='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_METALL, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'Материалыу' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_SET_FRANG_TAKEAMMO:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556], fmt_msg[185],
					fam_id = GetPlayerData(playerid, P_FAMILY),
					rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

			    switch(list_id)
				{
				    case 1:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='1' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 1);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK1));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 2:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='2' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 2);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK2));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 3:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='3' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 3);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK3));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 4:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='4' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 4);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK4));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 5:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='5' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 5);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK5));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 6:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='6' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 6);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK6));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 7:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='7' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 7);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK7));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 8:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='8' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 8);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK8));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 9:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='9' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 9);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK9));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				    case 10:
				    {
						mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET r_TakeAmmo='10' WHERE id='%d' LIMIT 1", fam_id + 1);
						mysql_query(mysql, fmt_text, false);

						SetFamilyData(fam_id, F_TAKE_AMMO, 10);

						format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] сменил доступ к 'патронам' на складе на ранг '%s'+ ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetFamilyData(fam_id, F_RANK10));

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							if(!IsPlayerLogged(i)) continue;
							if(GetPlayerData(i, P_FAMILY) == 0) continue;
							if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

							if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

							SendClientMessage(i, 0x6699CCFF, fmt_msg);
						}
				    }
				}
			}
			case DIALOG_FAMILY_NCHANGE:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    new fmt_text[556],
					fam_id = GetPlayerData(playerid, P_FAMILY);


				new query[128],
					Cache: result,
					rows;

				mysql_format(mysql, query, sizeof query, "SELECT * FROM family WHERE name='%s'", inputtext);
				result = mysql_query(mysql, query, true);

				rows = cache_num_rows(result);

				cache_delete(result);

				if(rows)
				{
					SendClientMessage(playerid, 0xCECECEFF, "Данное имя уже используется");
					callcmd::fmenu(playerid, "");

					return 1;
				}

			 	format(fmt_text, sizeof fmt_text, "Вы успешно изменили название семьи с {ffff00}\"%s\" {1E90FF}на {ffff00}\"%s\"", GetFamilyData(fam_id, F_NAME), inputtext);
				SendClientMessage(playerid, 0x1E90FFFF, fmt_text);

				GivePlayerDonateRub(playerid, -100, "Сменил название семьи", true);


				format(g_family[fam_id][F_NAME], 64, inputtext);
				mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET name='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
				mysql_query(mysql, fmt_text, false);
			}
			case DIALOG_FAMILY_COLOR:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    if(GetPlayerData(playerid, P_DONATE_RUB) < 20) return SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно рублей, требуется 20");

			    if(0 > list_id > 16) return SendClientMessage(playerid, 0xCECECEFF, "ID цвета от 0 до 16");

			    new fam_id = GetPlayerData(playerid, P_FAMILY),
					fmt_text[556];

			    SetFamilyData(fam_id, F_COLOR, list_id);

			    GivePlayerDonateRub(playerid, -20, "Сменил цвет семьи", true);

                mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET color='%d' WHERE id='%d' LIMIT 1", list_id, fam_id + 1);
				mysql_query(mysql, fmt_text, false);

				format(fmt_text, sizeof fmt_text, "Вы успешно изменили цвет семьи {ffff00}%s {1E90FF}на {%06x}%s", GetFamilyData(fam_id, F_NAME), family_colors[list_id] >>> 8, family_colors_name[list_id]);
				SendClientMessage(playerid, 0x1E90FFFF, fmt_text);
			}
			case DIALOG_FAMILY_WAREHOUSE:
			{
			    if(!response) return callcmd::fmenu(playerid, "");

			    switch(list_id)
				{
				    case 1:
				    {
				        Dialog
                        (
                            playerid, DIALOG_FAMILY_PUT_CASH, DIALOG_STYLE_INPUT,
                            "Положить деньги",
                            "{FFFFFF}Укажите сумму:",
                            "Положить", "Отмена"
                        );
				    }
				    case 2:
				    {
				    	Dialog
                        (
                            playerid, DIALOG_FAMILY_PUT_DRUGS, DIALOG_STYLE_INPUT,
                            "Положить наркотики",
                            "{FFFFFF}Укажите количество грамм:",
                            "Положить", "Отмена"
                        );
					}
					case 3:
					{
					    Dialog
                        (
                            playerid, DIALOG_FAMILY_PUT_METALL, DIALOG_STYLE_INPUT,
                            "Положить Материалы",
                            "{FFFFFF}Укажите количество кг:",
                            "Положить", "Отмена"
                        );
					}
					case 4:
					{
					    Dialog
                        (
                            playerid, DIALOG_FAMILY_PUT_AMMO, DIALOG_STYLE_INPUT,
                            "Положить Патроны",
                            "{FFFFFF}Укажите количество шт:",
                            "Положить", "Отмена"
                        );
					}
					case 5:
					{
					    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_TAKE_MONEY);

                		if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы брать деньги со склада семьи.");

					    Dialog
                        (
                            playerid, DIALOG_FAMILY_TAKE_CASH, DIALOG_STYLE_INPUT,
                            "Взять деньги",
                            "{FFFFFF}Укажите сумму:",
                            "Взять", "Отмена"
                        );
					}
					case 6:
					{
					    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_TAKE_DRUGS);

                		if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы брать наркотики со склада семьи.");

						Dialog
                        (
                            playerid, DIALOG_FAMILY_TAKE_DRUGS, DIALOG_STYLE_INPUT,
                            "Взять наркотики",
                            "{FFFFFF}Укажите количество грамм:",
                            "Взять", "Отмена"
                        );
					}
					case 7:
					{
					    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_TAKE_METALL);

                		if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы брать Материалы со склада семьи.");

					    Dialog
                        (
                            playerid, DIALOG_FAMILY_TAKE_METALL, DIALOG_STYLE_INPUT,
                            "Взять Материалы",
                            "{FFFFFF}Укажите количество кг:",
                            "Взять", "Отмена"
                        );
					}
					case 8:
					{
					    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_TAKE_AMMO);

                		if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы брать Патроны со склада семьи.");

					    Dialog
                        (
                            playerid, DIALOG_FAMILY_TAKE_AMMO, DIALOG_STYLE_INPUT,
                            "Взять Патроны",
                            "{FFFFFF}Укажите количество шт:",
                            "Взять", "Отмена"
                        );
					}
				}
			}
			case DIALOG_FAMILY_PUT_CASH:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetPlayerMoneyEx(playerid);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.money=%d,f.money=f.money + %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            GivePlayerMoneyEx(playerid, -put_sum, "Пополнение банка семьи", false, true);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] положил %dрублей.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY, +, put_sum);
                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы положили:\t{32a44b}$%d\n"\
                                "{FFFFFF}Итоговый баланс семьи: $%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств");
                }
                return 1;
            }
            case DIALOG_FAMILY_PUT_DRUGS:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[180];
                    new money = GetPlayerData(playerid, P_DRUGS);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.drugs=%d,f.drugs=f.drugs + %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_DRUGS, -, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_DRUGS, +, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

							format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] положил %d грамм наркотиков.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы положили: "c_i"%d г. "c_b"наркотиков\n"\
                                "\n"\
                                "{FFFFFF}Количество наркотиков на складе: "c_i"%d\n"\
								""c_b"Количество наркотиков у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO),
                                GetPlayerData(playerid, P_AMMO)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "У вас нет такого количество наркотиков!");
                }
                return 1;
            }
            case DIALOG_FAMILY_PUT_METALL:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetPlayerData(playerid, P_METALL);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.metall=%d,f.metal=f.metal + %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_METALL, -, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_METAL, +, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] положил %d кг. Материалыа.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы положили: "c_i"%d кг. "c_b"Материалыа\n"\
                                "\n"\
                                "{FFFFFF}Количество Материалыа на складе: "c_i"%d\n"\
								""c_b"Количество Материалыа у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_METAL),
                                GetPlayerData(playerid, P_METALL)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "У вас нет такого количество Материалыа!");
                }
                return 1;
            }
            case DIALOG_FAMILY_PUT_AMMO:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetPlayerData(playerid, P_AMMO);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.ammo=%d,f.ammo=f.ammo + %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_AMMO, -, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO, +, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] положил %d шт. патронов.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы положили: "c_i"%d шт. "c_b"патронов\n"\
                                "\n"\
                                "{FFFFFF}Количество патронов на складе: "c_i"%d\n"\
								""c_b"Количество патронов у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO),
                                GetPlayerData(playerid, P_AMMO)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "У вас нет такого количество патронов!");
                }
                return 1;
            }
            case DIALOG_FAMILY_TAKE_CASH:
            {
                if(!response) return 1;

                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.money=%d,f.money=f.money - %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            GivePlayerMoneyEx(playerid, put_sum, "Взятие денег с банка семьи", false, true);

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY, -, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] взял %dрублей.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}
                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы взяли:\t{32a44b}$%d\n"\
                                "{FFFFFF}Итоговый баланс семьи: $%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_MONEY)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств");
                }
                return 1;
            }
            case DIALOG_FAMILY_TAKE_DRUGS:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_DRUGS);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.drugs=%d,f.drugs=f.drugs - %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_DRUGS, +, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_DRUGS, -, put_sum);

                            new fmt_msg[180],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] взял %d грамм наркотиков.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы взяли: "c_i"%d г. "c_b"наркотиков\n"\
                                "\n"\
                                "{FFFFFF}Количество наркотиков на складе: "c_i"%d\n"\
								""c_b"Количество наркотиков у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_DRUGS),
                                GetPlayerData(playerid, P_DRUGS)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "На складе семьи нет такого количество наркотиков!");
                }
                return 1;
            }
            case DIALOG_FAMILY_TAKE_METALL:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[155];
                    new money = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_METAL);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.metall=%d,f.metal=f.metal - %d WHERE a.id=%d AND f.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_METALL, +, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_METAL, -, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] взял %d кг. Материала.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы взяли: "c_i"%d г. "c_b"Материалыа\n"\
                                "\n"\
                                "{FFFFFF}Количество Материалыа на складе: "c_i"%d\n"\
								""c_b"Количество Материалыа у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_DRUGS),
                                GetPlayerData(playerid, P_DRUGS)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "На складе семьи нет такого количество Материалыа!");
                }
                return 1;
            }
            case DIALOG_FAMILY_TAKE_AMMO:
            {
                if(!response) return 1;


                new put_sum = strval(inputtext);
                if(put_sum > 0 && IsNumeric(inputtext))
                {

                    new fmt_str[180];
                    new money = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO);
                    new player_ammo = GetPlayerData(playerid, P_AMMO);

                    if(money >= put_sum)
                    {
                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,family f SET a.ammo=%d,f.ammo=f.ammo - %d WHERE a.id=%d AND f.id=%d", player_ammo+put_sum, put_sum, GetPlayerAccountID(playerid), GetPlayerData(playerid, P_FAMILY) + 1);
                        mysql_query(mysql, fmt_str, false);

                        if(!mysql_errno())
                        {
                            AddPlayerData(playerid, P_AMMO, +, put_sum);
                            UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

                            AddFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO, -, put_sum);

                            new fmt_msg[144],
								fam_id = GetPlayerData(playerid, P_FAMILY),
								rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                            format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s: %s %s[%d] взял  %d шт. патронов.", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, g_family[GetPlayerData(playerid, P_FAMILY)][F_NAME], GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, put_sum);

							for(new i; i < MAX_PLAYERS; i ++)
							{
								if(!IsPlayerConnected(i)) continue;
								if(!IsPlayerLogged(i)) continue;
								if(GetPlayerData(i, P_FAMILY) == 0) continue;
								if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

								if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

								SendClientMessage(i, 0x6699CCFF, fmt_msg);
							}

                            format
                            (
                                fmt_str, sizeof fmt_str,
                                ""c_b"Вы взяли: "c_i"%d шт. "c_b"патронов\n"\
                                "\n"\
                                "{FFFFFF}Количество патронов на складе:\t"c_i"%d\n"\
								""c_b"Количество патронов у вас: "c_i"%d",
                                put_sum,
                                GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_AMMO),
                                GetPlayerData(playerid, P_AMMO)
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{1E90FF}Операция завершена успешно", fmt_str, "Вернуться", "");
                        }
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
                    }
					else SendClientMessage(playerid, 0xFFFFFFFF, "На складе семьи нет такого количество патронов!");
                }
                return 1;
            }
            case DIALOG_FAMILY_MENU:
            {
                if(!response) return 1;

                switch(listitem)
                {
                    case 0:
					{
						SCM(playerid, -1, "{FFFF00}| {FFFFFF}Обьявлений не найдено.");
					}
                    case 1: ShowFamilyInfo(playerid);
                    case 2:
                    {
                    	ShowFamilyHelpCommands(playerid);
                    }
                    case 3:
                    {
                        if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа");
                        Dialog
                        (
                            playerid, DIALOG_FAMILY_SETTINGS, DIALOG_STYLE_LIST,
                            "Настройки",
                            ""c_server"[1] "c_b"Установить место появления\n\
                            "c_server"[2] "c_b"Управление рангами\n\
							"c_server"[3] "c_b"Сменить название семьи (80 руб.)\n\
							"c_server"[4] "c_b"Сменить цвет семьи (20 руб.)\n\
							"c_server"[5] "c_b"Настройка доступа рангов\n\
							"c_s"[6] "c_b"Управление транспортом",
                            "Далее", ""
                        );
                    }
                    case 4:
					{
					return 1;
					}
					case 5:
					{
					    if(GetPlayerData(playerid, P_FAMILY_RANK) < 9) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа");

						new query[256];
						format(query, sizeof query, "SELECT name, score, family_rank FROM accounts WHERE family = %d ORDER BY family_rank DESC", GetPlayerData(playerid, P_FAMILY));
						mysql_tquery(mysql, query, "ShowFamilyAllPlayers", "i", playerid);
					}
                }
            }
            case DIALOG_FAMILY_SETTINGS:
            {
                if(response)
                {
                    switch(listitem)
                    {
                        case 0:
                        {
                            Dialog
                            (
                                playerid, DIALOG_FAMILY_SPAWN_SET, DIALOG_STYLE_MSGBOX,
                                "Настройки семьи",
                                "Вы действительно хотите установить точку спавна вашей семьи\n\
                                На то место где вы находитесь?",
                                "Далее", "Отмена"
                            );
                        }
                        case 1:ShowChangeRangDialog(playerid);
                        case 2: ShowChangeNameDialog(playerid);
                        case 3: callcmd::setfcolor(playerid);
						case 4: ShowFamilyRangSetMenu(playerid);
						case 5: ViewFamilyCar(playerid);
                    }
                }
            }
            case DIALOG_FAMILY_SPAWN_SET:
            {
                if(!response) return true;
                new family = GetPlayerData(playerid, P_FAMILY);

                GetPlayerPos(playerid, g_family[family][F_SPAWN_POSITION][0], g_family[family][F_SPAWN_POSITION][1], g_family[family][F_SPAWN_POSITION][2]);
                GetPlayerFacingAngle(playerid, g_family[family][F_SPAWN_POSITION][3]);

                g_family[family][F_SPAWN_IV][0] = GetPlayerInterior(playerid);
                g_family[family][F_SPAWN_IV][1] = GetPlayerVirtualWorld(playerid);

                SendClientMessage(playerid, -1, "Позиция спавна успешно изменена!");

                new query[276];
                format(query, sizeof query, "UPDATE family SET pos_x = '%f', pos_y = '%f', pos_z = '%f', pos_fa = '%f', inter = '%d', world = '%d' WHERE id = %d", g_family[family][F_SPAWN_POSITION][0], g_family[family][F_SPAWN_POSITION][1], g_family[family][F_SPAWN_POSITION][2], g_family[family][F_SPAWN_POSITION][3], g_family[family][F_SPAWN_IV][0], g_family[family][F_SPAWN_IV][1], family);
                mysql_query(mysql, query, false);
                printf(query);
                return 1;
            }
            case DIALOG_FAMILY_LEAVE:
            {
                new fmt_text[110];
                if(response)
                {
                    new fam_id = GetPlayerData(playerid, P_FAMILY),
                    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

                    format(fmt_text, sizeof fmt_text, "[F] %s %s[%d] покинул семью по собственному желанию",
                    GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid);

                    for(new i; i < MAX_PLAYERS; i ++)
                    {
                        if(!IsPlayerConnected(i)) continue;
                        if(!IsPlayerLogged(i)) continue;
                        if(GetPlayerData(i, P_FAMILY) == 0) continue;
                        if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

                        if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

                        SendClientMessage(i, 0xCECECEFF, fmt_text);
                    }

                    format(fmt_text, sizeof fmt_text, "Вы покинули семью \"%s\"", GetFamilyData(fam_id, F_NAME));
                    SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

                    FUnInvite(playerid, playerid);
                }
            }
            case DIALOG_FAMILY_RANG:
            {
                if(!response) return callcmd::fmenu(playerid, "");

                new fam_id = GetPlayerData(playerid, P_FAMILY),
                    desc[32] = "";

                switch(listitem)
                {
                    case 0: strcat(desc, g_family[fam_id][F_RANK1]);
                    case 1: strcat(desc, g_family[fam_id][F_RANK2]);
                    case 2: strcat(desc, g_family[fam_id][F_RANK3]);
                    case 3: strcat(desc, g_family[fam_id][F_RANK4]);
                    case 4: strcat(desc, g_family[fam_id][F_RANK5]);
                    case 5: strcat(desc, g_family[fam_id][F_RANK6]);
                    case 6: strcat(desc, g_family[fam_id][F_RANK7]);
                    case 7: strcat(desc, g_family[fam_id][F_RANK8]);
                    case 8: strcat(desc, g_family[fam_id][F_RANK9]);
                    case 9: strcat(desc, g_family[fam_id][F_RANK10]);
                }

                SetPVarInt(playerid, "userang", listitem+1);
                Dialog
                (
                    playerid, DIALOG_FAMILY_RCHANGE, DIALOG_STYLE_INPUT,
                    desc,
                    "{FFFFFF}Введите название, которое Вы хотите {d8284c}установить:",
                    "Далее", "Отмена"
                );
            }
            case DIALOG_FAMILY_RCHANGE:
            {
                if(!response) return callcmd::fmenu(playerid, "");

                new fmt_text[556],
                    rang_id = GetPVarInt(playerid, "userang"),
                    fam_id = GetPlayerData(playerid, P_FAMILY);

                switch(rang_id)
                {
                    case 1:
                    {
                        format(g_family[fam_id][F_RANK1], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank1='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 2:
                    {
                        format(g_family[fam_id][F_RANK2], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank2='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 3:
                    {
                        format(g_family[fam_id][F_RANK3], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank3='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 4:
                    {
                        format(g_family[fam_id][F_RANK4], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank4='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 5:
                    {
                        format(g_family[fam_id][F_RANK5], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank5='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 6:
                    {
                        format(g_family[fam_id][F_RANK6], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank6='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 7:
                    {
                        format(g_family[fam_id][F_RANK7], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank7='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 8:
                    {
                        format(g_family[fam_id][F_RANK8], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank8='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 9:
                    {
                        format(g_family[fam_id][F_RANK9], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank9='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                    case 10:
                    {
                        format(g_family[fam_id][F_RANK10], 32, inputtext);
                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE family SET rank10='%s' WHERE id='%d' LIMIT 1", inputtext, fam_id + 1);
                        mysql_query(mysql, fmt_text, false);
                    }
                }

                format(fmt_text, sizeof fmt_text, "Вы успешно изменили название ранга {d8284c}№%d {1E90FF}на {d8284c}\"%s\"", rang_id, inputtext);
                SendClientMessage(playerid, 0x1E90FFFF, fmt_text);
            }
			case DIALOG_SECURITY_SETTING_INFO:
			{
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PHONE:
			{
				if(!strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true)) return 1;

				if(response)
				{
					if(0 <= listitem <= 2)
					{
						new query[64 + 1];
						SetPlayerData(playerid, P_REQUEST_PHONE, listitem);

						format(query, sizeof query, "UPDATE accounts SET request_phone=%d WHERE id=%d LIMIT 1", listitem, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "Изменения в настройках безопасности {00FFCC}сохранены");
							switch(listitem + 1)
							{
								case 1: SendClientMessage(playerid, 0xFF6600FF, "Запрос на ввод мобильного телефона отключен");
								case 2: SendClientMessage(playerid, 0xFFFF00FF, "Ваш мобильный телефон будет запрашиваться при несовпадении подсети");
								case 3: SendClientMessage(playerid, 0x66CC00FF, "Мобильный телефон будет запрашиваться при несовпадении IP адресов");
							}
						}
					else
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "Изменения в настройках безопасности {FF3333}не сохранены");
							SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 03)");
						}
					}
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PHONE_S:
			{
				// установить телефон
				if(strcmp(GetPlayerData(playerid, P_SETTING_PHONE), "None", true) != 0) return 1;
			}
			case DIALOG_SECURITY_SETTING_PIN:
			{
				if(!strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true)) return 1;

				if(response)
				{
					if(0 <= listitem <= 2)
					{
						new query[64 + 1];
						SetPlayerData(playerid, P_REQUEST_PIN, listitem);

						format(query, sizeof query, "UPDATE accounts SET request_pin=%d WHERE id=%d LIMIT 1", listitem, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "Изменения в настройках безопасности {00FFCC}сохранены");
							switch(listitem + 1)
							{
								case 1: SendClientMessage(playerid, 0xFF6600FF, "Запрос случайного PIN-кода отключен");
								case 2: SendClientMessage(playerid, 0xFFFF00FF, "Ваш случайный PIN-код будет запрашиваться при несовпадении подсети");
								case 3: SendClientMessage(playerid, 0x66CC00FF, "Случайный PIN-код будет запрашиваться при несовпадении IP адресов");
							}
						}
					else
						{
							SendClientMessage(playerid, 0xFFFFFFFF, "Изменения в настройках безопасности {FF3333}не сохранены");
							SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 03)");
						}
					}
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PIN_SET:
			{
				// установить пин код
				if(strcmp(GetPlayerData(playerid, P_SETTING_PIN), "None", true) != 0) return 1;

				if(response)
				{
					ShowPlayerPinCodePTD(playerid, PIN_CODE_STATE_SET);
				}
					else ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PASS_1:
			{
				if(response)
				{
					strmid(CheckPass[playerid], inputtext, 0, strlen(inputtext), 65);
					new hash[65];
       				SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

					if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
					{
						Dialog
						(
							playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
							"{FFCD00}Новый пароль",
							"{FFFFFF}Введите новый пароль в поле ниже:",
							"Изменить", "Отмена"
						);
						return 1;
					}
					else SendClientMessage(playerid, 0xFF6600FF, "Вы ввели неверный пароль");
				}
				ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_PASS_2:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 15) || strfind(inputtext, " ") != -1)
					{
						SendClientMessage(playerid, 0xFF6600FF, "Длина пароля должна быть от 6 до 64 символов");
						SendClientMessage(playerid, 0xFF6600FF, "Также не допускается использование пробелов");
					}
					else
					{
						new query[256];

						for(new i; i < 10; i++) g_player[playerid][P_SALT][i] = random(79) + 47;
			            g_player[playerid][P_SALT][10] = 0;
			            SHA256_PassHash(inputtext, g_player[playerid][P_SALT], g_player[playerid][P_PASSWORD], 65);

			            format(query, sizeof query, "{ffff00}| {FFFFFF}Вы сменили пароль от игрового аккаунта на новый : {ffff00}%s .", inputtext);

						SendClientMessage(playerid, 0xFFFF00FF, query);
						SendClientMessage(playerid, 0xFFFFFFFF, "{ffff00}| {FFFFFF}Рекомендуем сделать скриншот нового пароля,чтобы не забыть его.");

						ShowPlayerSecuritySettings(playerid);

						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET password='%e', salt='%e' WHERE id=%d LIMIT 1", g_player[playerid][P_PASSWORD], g_player[playerid][P_SALT], GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);



						// OLD SYSTEM
						//format(g_player[playerid][P_PASSWORD], 65, "%s", inputtext);
						return 1;
					}

					Dialog
					(
						playerid, DIALOG_SECURITY_SETTING_PASS_2, DIALOG_STYLE_INPUT,
						"{FFCD00}Новый пароль",
						"{FFFFFF}Введите новый пароль в поле ниже:",
						"Изменить", "Отмена"
					);
				}
					else ShowPlayerSecuritySettings(playerid);
			}
			case DIALOG_SECURITY_SETTING_EMAIL:
			{
				if(!response)
				{
					// отправка кода на почту
					Dialog
					(
						playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
						"{FFCD00}Письмо отправлено",
						"{FFFFFF}В течение нескольких минут на Вашу почту придет письмо с новой ссылкой.\n"\
						"Перейдите по ней для подтверждения Email.",
						"Закрыть", ""
					);
				}
			}
			case DIALOG_AUTOREPORT:
			{
	            if(!response) return DeletePVar(playerid, "IdReport");
	            new idx = GetPVarInt(playerid, "IdReport") - 1;
	            new str[256];

	            switch(listitem)
	            {
		            case 0: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Здравствуйте, наблюдаю за игроком. | Приятной игры на Нашем сервере! :)",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 1: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Нарушений за игроком не заметили. | Приятной игры на Нашем сервере! :)",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 2: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Игрок был наказан, спасибо за информацию. | Приятной игры на Нашем сервере! :)",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 3: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Здравствуйте, не засоряйте пожалуйста репорт. | Приятной игры на Нашем сервере! :)",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 4: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Приобретите данный пост или же подайте заявление на форум — forum.samp-tape.ru",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 5: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Здравствуйте, приобретите данный пост — /buyadm | Приятной игры на Нашем сервере! :)",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 6: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Чтобы получать новые промокоды подпишитесь на рассылку офф.группы — vk.com/samp_mobi",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 7: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Наш сайт — SAMP-TAPE.RU / Форум — forum.samp-tape.ru / ВКонтакте — vk.com/samp_mobi",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 8: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Здравствуйте, Вы можете подать жалобу на форум — forum.samp-tape.ru",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 9: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Свяжитесь с Основателями проекта в ВК. Их страницы есть контактах офф.группы.",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 10: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Пополнить счет Вы можете на сайте — SAMP-TAPE.RU",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		            case 11: format(str, sizeof(str), "Администратор: %s[%d] для %s[%d]: Пополните счёт аккаунта на сайте SAMP-TAPE.RU и купите в /mm > Дополнительно",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(idx), idx);
		        }
	            SendClientMessage(idx, 0xff9945FF, str);
	            DeletePVar(idx, "RepUn"), DeletePVar(playerid, "IdReport");
	            SendMessageToAdmins(str, 0xff9945FF);
	            return true;
	        }
	        	        case 5512:
			{

				new report_id = TempReportInfo[playerid][reportID], status = REPORT_STATUS_ANSWERED, Cache:result;
				new target_name[MAX_PLAYER_NAME + 1];
				if (!response) status = REPORT_STATUS_SKIPPED;

				mysql_query_[0] = EOS;

				mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "SELECT * FROM "TABLE_REPORTS" \
					WHERE status=0 AND id=%d", report_id
				);
				result = mysql_query(mysql, mysql_query_, true);

				mysql_query_[0] = EOS;

				new rows = cache_num_rows(result);

				if(!rows)
				{
					TempReportInfo[playerid][reportID] = 0;
					cache_delete(result);
					SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}РќР° РґР°РЅРЅС‹Р№ Р·Р°РїСЂРѕСЃ СѓР¶Рµ Р±С‹Р» РґР°РЅ РѕС‚РІРµС‚!");
					return true;
				}

				if(response)
				{
					utf8_to_cp1251(inputtext);
				}

				mysql_format(mysql, mysql_query_, sizeof (mysql_query_), "UPDATE "TABLE_REPORTS" SET \
					status=%d, answer='%e' WHERE status=0 AND id=%d", status, inputtext, report_id
				);
				mysql_query(mysql, mysql_query_);
				new targetid = TempReportInfo[playerid][reportPlayerID];
				TempReportInfo[playerid][reportID] = 0;

				Dialog(playerid, 5513, DIALOG_STYLE_MSGBOX, ""c_server"Р’С‹ РѕС‚РІРµС‚РёР»Рё РЅР° Р·Р°РїСЂРѕСЃ", "{FFFFFF}РҐРѕС‚РёС‚Рµ РїРѕСЃРјРѕС‚СЂРµС‚СЊ СЃР»РµРґСѓСЋС‰РёР№ Р·Р°РїСЂРѕСЃ?", "Р”Р°", "РћС‚РјРµРЅР°");
				if (!response) {
					if(IsPlayerConnected(targetid))
					{
						format(stringer, sizeof (stringer), "Р’Р°С€ Р·Р°РїСЂРѕСЃ в„–%d Р±С‹Р» РїСЂРѕРїСѓС‰РµРЅ Р°РґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂРѕРј %s[%d].",
							report_id, GetPlayerData(playerid, P_NAME), playerid
						);
						SendClientMessage(targetid, COLOR_YELLOW, stringer), stringer[0] = EOS;
						format(target_name, sizeof target_name, "%s", GetPlayerData(targetid, P_NAME));
					}
					else format(target_name, sizeof target_name, "Offline");

					format(stringer1, sizeof(stringer1), "{afafaf}[A] %s[%d] РїСЂРѕРїСѓСЃС‚РёР» Р·Р°РїСЂРѕСЃ в„–%d РёРіСЂРѕРєР° %s[%d].",
						GetPlayerNameEx(playerid), playerid, report_id, target_name, targetid
					);
					SendMessageToAdmins(stringer1,0xFfa500AA);

		            /*if(PlayerInfo[playerid][pAdmin]) PlayerInfo[playerid][pRepAdm]--;
		            else PlayerInfo[playerid][pHotvet]--;*/

					cache_delete(result);
					return true;
				}
				format(stringer, sizeof (stringer), "\
					{FFFFFF}Р”Р°С‚Р° Р·Р°РїСЂРѕСЃР°: {afafaf}%s\n \n\
					{FFFFFF}Р’Р°С€ Р·Р°РїСЂРѕСЃ в„–%d:\n\
					{afafaf}| {afafaf}%s\n \n\
					{FFFFFF}РћС‚РІРµС‚ РѕС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С†РёРё:\n\
					{afafaf}| "c_server"%s",
					TempReportInfo[playerid][reportDate], report_id, TempReportInfo[playerid][reportText], inputtext
				);
				if(IsPlayerConnected(targetid))
				{
					Dialog(targetid, 0000, DIALOG_STYLE_MSGBOX, !""c_server"РћС‚РІРµС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С†РёРё", stringer, !"РЎРїР°СЃРёР±Рѕ", !"");

					format(stringer, sizeof (stringer), ""c_server"Р’Р°С€ Р·Р°РїСЂРѕСЃ в„–%d: {FFFFFF}%s", report_id, TempReportInfo[playerid][reportText]);
					SendClientMessage(targetid, COLOR_YELLOW, stringer);
					format(stringer, sizeof (stringer), ""c_server"{8B4513}РћС‚РІРµС‚ РѕС‚ Р°РґРјРёРЅРёСЃС‚СЂР°С‚РѕСЂР° %s[%d]: {CD853F}%s", GetPlayerData(playerid,P_NAME), playerid, inputtext);
					SendClientMessage(targetid, COLOR_YELLOW, stringer), stringer[0] = EOS;
					format(target_name, sizeof target_name, "%s", GetPlayerData(targetid, P_NAME));
				}
				else
				{
					SendClientMessage(playerid, COLOR_WHITE, !"{afafaf}Р?РіСЂРѕРє РІС‹С€РµР» СЃ СЃРµСЂРІРµСЂР°, РѕС‚РІРµС‚ СЃРѕС…СЂР°РЅРµРЅ РІ СЃРёСЃС‚РµРјРµ.");
					format(target_name, sizeof target_name, "Offline");
				}

				format(stringer1, sizeof(stringer1), "{afafaf}[A] %s[%d] РѕС‚РІРµС‚РёР» РёРіСЂРѕРєСѓ %s[%d]: %s",
					GetPlayerNameEx(playerid), playerid, target_name, targetid, inputtext
				);
				SendMessageToAdmins(stringer1,0xFfa500AA);
				AdminStats_AddReportAnswer(playerid);
				new report_stat_log[192];
				format(report_stat_log, sizeof report_stat_log, "Ответил на репорт #%d: %s", report_id, inputtext);
				SendLog(playerid, LOG_TYPE_ADMIN_ACTION, report_stat_log);

	            /*if(PlayerInfo[playerid][pAdmin]) PlayerInfo[playerid][pRepAdm]++;
	            else PlayerInfo[playerid][pHotvet] ++;*/

				cache_delete(result);

				return true;
			}
			case 5513: {
				if (!response) {
					TempReportInfo[playerid][reportID] = 0;
					return true;
				}
				callcmd::ans(playerid, "");
				return true;
			}
	        case 9182:
			{
				if(response) return ReportGUI_Submit(playerid, inputtext, true);
				return true;
			}
			case DIALOG_REPORT:
			{
				if(response) return ReportGUI_Submit(playerid, inputtext, true);
				return callcmd::mm(playerid, "");
			}
			case DIALOG_PLAYER_IMPROVEMENTS:
			{
				if(response)
				{
					new my_i_level = GetPlayerData(playerid, P_IMPROVEMENTS);

					if(0 <= listitem <= sizeof(g_player_improvements)-1)
					{
						new i_level = GetPlayerImprovementInfo(listitem, I_LEVEL);
						new i_price = GetPlayerImprovementInfo(listitem, I_PRICE);

						if(my_i_level < listitem)
						{
							SendClientMessage(playerid, 0xCECECEFF, "Это улучшение пока не доступно");
						}
					else if(my_i_level > listitem)
						{
							SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили это улучшение");
						}
					else if(GetPlayerLevel(playerid) < i_level || GetPlayerMoneyEx(playerid) < i_price)
						{
							new fmt_str[64 + 1];

							format(fmt_str, sizeof fmt_str, "Для покупки этого улучшения необходим %d уровень и %d рублей", i_level, i_price);
							SendClientMessage(playerid, 0x999999FF, fmt_str);
						}
					else
						{
							new fmt_str[85];

							format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,improvements=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - i_price, my_i_level + 1, GetPlayerAccountID(playerid));
							mysql_query(mysql, fmt_str, false);

							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшения аккаунта", false);

								AddPlayerData(playerid, P_IMPROVEMENTS, +, 1);

								format(fmt_str, sizeof fmt_str, "Вы приобрели улучшение {FFCD00}\"%s\"", GetPlayerImprovementInfo(listitem, I_NAME));
								SendClientMessage(playerid, 0x3399FFFF, fmt_str);

								switch(listitem + 1)
								{
									case 1:
										SendClientMessage(playerid, 0xCECECEFF, "Полоска здоровья будет уменьшаться значительно медленнее");

									case 2:
										SendClientMessage(playerid, 0xCECECEFF, "Теперь Вы можете покидать организацию по собственному желанию {33FF33}(/leave)");

									case 3:
										SendClientMessage(playerid, 0xCECECEFF, "Теперь Вы можете носить с собой в 2 раза больше Материалыа, патронов и наркотиков");

									case 4:
										SendClientMessage(playerid, 0xCECECEFF, "Теперь Вы можете не бояться небольших аварий, двигатель не заглохнет");

									case 5:
										SendClientMessage(playerid, 0xCECECEFF, "Теперь Ваше оружие будет сохраняться в полном объеме при выходе из игры");
								}
							}
					else
							{
								SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 06)");
								ShowPlayerImprovementsDialog(playerid);
							}
						}
					}
					else
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{00FFFF}"SERVER_NAME"{ffffff} | Информация",
							"{FFFF00}1. {FFFFFF} Выносливость позволит находиться в хорошей форме длительное\n"\
							"время. Полоска здоровья будет уменьшаться медленнее.\n\n"\
							"{FFFF00}2. {FFFFFF}Решительность позволит вам самостоятельно принять решение об\n"\
							"увольнении с организации (команда /leave). Без решительности вы не\n"\
							"сможете покинуть организацию по собственному желанию.\n\n"\
							"{FFFF00}3. {FFFFFF}Рюкзак даст возможность переносить с собой Материалы, Патроны и\n"\
							"наркотики в гораздо большем количестве.\n\n"\
							"{FFFF00}4. {FFFFFF}Став мастером вождения, двигатель транспорта под Вашим управлением\n"\
							"больше не будет глохнуть при различных ударах.\n\n"\
							"{FFFF00}5. {FFFFFF}Полная экипировка сохраняет все ваше оружие в полном объеме,\n"\
							"при выходе из игры.",
							"Закрыть", ""
						);
					}
				}
					else callcmd::mm(playerid, "");
			}
			case DIALOG_CHANGE_NAME:
			{
				if(response)
				{
					if(!GetPVarInt(playerid, "change_name_status"))
					{
						new len = strlen(inputtext);
						if(4 <= len <= 20)
						{
							new bool: valid_name = true;
							for(new idx; idx < len; idx ++)
							{
								switch(inputtext[idx])
								{
									case 'a'..'z', 'A'..'Z', '[', ']', '_': continue;
									default:
										valid_name = false;
								}
							}

							if(!strcmp(GetPlayerNameEx(playerid), inputtext, true))
							{
								SendClientMessage(playerid, 0xFF6600FF, "Вы уже используете это имя");
							}
							else if(valid_name)
							{
								new query[128];
								new Cache: result, rows;

								mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", inputtext);
								result = mysql_query(mysql, query, true);

								rows = cache_num_rows();
								cache_delete(result);

								if(!rows)
								{
									SetPVarInt(playerid, "change_name_status", 1);
									SetPVarString(playerid, "change_name", inputtext);

									Dialog
									(
										playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
										"{FFCD00}Заявка на изменение имени",
										"{FFFFFF}Ваша просьба об изменении ника отправлена администрации.\n"\
										"Вы получите сообщение, как только заявка будет обработана.\n\n"\
										"Если в течении нескольких минут Ваше имя не было изменено,\n"\
										"то, скорее всего, оно не соответствует RP правилам,\n"\
										"либо Вы уже используете RP имя.",
										"Ок", ""
									);

									format(query, sizeof query, "[Смена non rp имени] %s >> %s {FFCD00}| /namelist %d для одобрения" , GetPlayerNameEx(playerid), inputtext, playerid);
									SendMessageToAdmins(query, 0x66CC99FF);

								}
								else SendClientMessage(playerid, 0xFF6600FF, "Введенное Вами имя уже используется");

							}
							else
							{
								SendClientMessage(playerid, 0xFF6600FF, "Имя уже используется или содержит недопустимые символы");
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте латинские буквы a-z A-Z, а также символы [ ] _");
							}
						}
						else SendClientMessage(playerid, 0xFF6600FF, "Недопустимый формат ввода");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы уже подавали заявку на изменение имени");
				}
			}
			case 29000:
		    {
		        new ttext[30],string[200];
		        if(!response) return 1;
		        switch(list_id)
		        {
		            case 1:
		            {
		                if(strlen(interview[TEAM_ARMY][text_time]) == 0 && strlen(interview[TEAM_ARMY][text_crit]) == 0)
						{
						    format(interview[TEAM_ARMY][text_time],15, "Неизвестно");
						    format(interview[TEAM_ARMY][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение военкомата нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_ARMY][text_time],interview[TEAM_ARMY][text_crit]);
						ttext = "Армия";
						click_status[playerid] = 1;
					}
		            case 2:
					{
						if(strlen(interview[TEAM_GOVERNMENT][text_time]) == 0 && strlen(interview[TEAM_GOVERNMENT][text_crit]) == 0)
						{
						    format(interview[TEAM_GOVERNMENT][text_time],15, "Неизвестно");
						    format(interview[TEAM_GOVERNMENT][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение мэрии нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_GOVERNMENT][text_time],interview[TEAM_GOVERNMENT][text_crit]);
						ttext = "Мэрия";
						click_status[playerid] = 2;
					}
		            case 3:
					{
						if(strlen(interview[TEAM_DPS][text_time]) == 0 && strlen(interview[TEAM_DPS][text_crit]) == 0)
						{
							format(interview[TEAM_DPS][text_time],15, "Неизвестно");
						    format(interview[TEAM_DPS][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение ГИБДД нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_DPS][text_time],interview[TEAM_DPS][text_crit]);
						ttext = "ГИБДД";
						click_status[playerid] = 3;
					}
		            case 4:
					{
						if(strlen(interview[TEAM_HOSPITAL][text_time]) == 0 && strlen(interview[TEAM_HOSPITAL][text_crit]) == 0)
						{
							format(interview[TEAM_HOSPITAL][text_time],15, "Неизвестно");
						    format(interview[TEAM_HOSPITAL][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение больницы, нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_HOSPITAL][text_time],interview[TEAM_HOSPITAL][text_crit]);
						ttext = "Больница г. Los-Santos";
						click_status[playerid] = 4;
					}
		            case 5:
		            {
						if(strlen(interview[TEAM_RADIO][text_time]) == 0 && strlen(interview[TEAM_RADIO][text_crit]) == 0)
						{
							format(interview[TEAM_RADIO][text_time],15, "Неизвестно");
						    format(interview[TEAM_RADIO][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение ГТРК нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_RADIO][text_time],interview[TEAM_RADIO][text_crit]);
						ttext = "СМИ";
						click_status[playerid] = 5;
					}
		            case 6:
					{
						if(strlen(interview[TEAM_FBI][text_time]) == 0 && strlen(interview[TEAM_FBI][text_crit]) == 0)
						{
							format(interview[TEAM_FBI][text_time],15, "Неизвестно");
						    format(interview[TEAM_FBI][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение ФСБ нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_FBI][text_time],interview[TEAM_FBI][text_crit]);
						ttext = "ФСБ";
						click_status[playerid] = 6;
					}
					case 7:
					{
						if(strlen(interview[TEAM_PPS][text_time]) == 0 && strlen(interview[TEAM_PPS][text_crit]) == 0)
						{
							format(interview[TEAM_PPS][text_time],15, "Неизвестно");
						    format(interview[TEAM_PPS][text_crit], 70, "Неизвестно");
						}
						format(string,sizeof(string),"\
						{FFFFFF}Время: {FF8040}%s{FFFFFF}\n\
						Критерии: {FF8040}%s{FFFFFF}\n\n\
						Чтобы узнать местоположение УМВД нажмите {FF8040}Далее{FFFFFF}",interview[TEAM_PPS][text_time],interview[TEAM_PPS][text_crit]);
						ttext = "УМВД";
						click_status[playerid] = 7;
					}
		        }
		        Dialog(playerid, 29005, DIALOG_STYLE_MSGBOX,ttext,string,"Далее","Назад");
		    }
		    case 29005:
		    {
		        if(!response)
		        {
		            return callcmd::vacancy(playerid);
				}
				switch(click_status[playerid])
				{
				    case 1:
					{
						if(strlen(interview[TEAM_ARMY][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,1916.5503,2302.2786,15.1412,5.0);
					}
				    case 2:
					{
					    if(strlen(interview[TEAM_GOVERNMENT][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,-113.2410,627.7893,11.8676,5.0);
					}
				    case 3:
					{
					    if(strlen(interview[TEAM_DPS][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,1895.6697,-2212.2500,10.9975,5.0);
					}
				    case 4:
					{
					    if(strlen(interview[TEAM_HOSPITAL][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,-286.9034, 576.8859, 12.8447,5.0);
					}
				    case 5:
					{
					    if(strlen(interview[TEAM_RADIO][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,-317.8738,816.2292,13.0515,5.0);
					}
				    case 6:
					{
					    if(strlen(interview[TEAM_FBI][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,1818.4851,2095.7136,16.1642,5.0);
					}
					case 7:
					{
					    if(strlen(interview[TEAM_PPS][text_time]) == 0) return SendClientMessage(playerid,-1,"{FFFF00}[Информация]{FFFFFF} В данный момент собеседование не проводится!");
						SetPlayerCheckpoint(playerid,2578.9482,-2416.1196,21.9922,5.0);
					}
				}
				SendClientMessage(playerid, -1,"{FFFF00}[Информация]{FFFFFF} Местоположение организации отмечено у Вас на GPS");
				return 1;
		    }
			case DIALOG_LEADER_MENU:
		    {
		        if(!response) return 1;
		        switch(list_id)
		        {
		            case 1: Dialog(playerid, DIALOG_LEADER_MENU_UNINVITE, DIALOG_STYLE_INPUT,"Панель лидера","Введите имя сотрудника, которого хотите уволить!","Ввести","Закрыть");
					case 2: callcmd::showall(playerid, "");
					case 3: Dialog(playerid, DIALOG_LEADER_MENU_JOBS,DIALOG_STYLE_LIST,"Панель лидера","1. Создать вакансию\n2. Удалить вакансию","Выбрать","Закрыть");
					case 4: OrgWarehouse_ShowManageDialog(playerid);
				}
		    }

		    case DIALOG_LEADER_MENU_JOBS:
		    {
		        if(!response) return 1;
		        switch(list_id)
		        {
		            case 1: callcmd::addvacancy(playerid);
		            case 2: callcmd::delvacancy(playerid);
		        }
		    }
		    case DIALOG_LEADER_MENU_UNINVITE:
		    {
		        if(!response) return 1;
		        callcmd::uninviteoff(playerid,inputtext);
		        return 1;
		    }
		    /*case 3000:
			{
				new id = DuelOffer[playerid];

				if(!response)
				{
					SendClientMessage(id, -1, "Игрок отказался от дуэля!");
					SendClientMessage(playerid, -1, "Вы успешно отказались от дуэля!");
					DuelOffer[playerid] = -1;
					DuelOffer[id] = -1;
					DuelCash[id] = 0;
					DuelCash[playerid] = 0;

					return true;
				}
				if(!ProxDetectorS(10, playerid, id))
				{
					DuelOffer[playerid] = -1;
					DuelOffer[id] = -1;
					DuelCash[id] = 0;
					DuelCash[playerid] = 0;
					SendClientMessage(playerid, -1, "Вы далеко друг от друга!");

					return true;
				}
				if(GetPlayerMoney(playerid) < DuelCash[playerid] || GetPlayerMoney(id) < DuelCash[playerid])
				{
					SendClientMessage(playerid, -1, "У Вас или у Вашего соперника не достаточно денег!");
					SendClientMessage(id, -1, "У Вас или у Вашего соперника не достаточно денег!");
					DuelOffer[playerid] = -1;
					DuelOffer[id] = -1;
					DuelCash[id] = 0;
					DuelCash[playerid] = 0;

					return true;
				}
				SendClientMessage(playerid, -1, "Вы приняли дуэль! Дуэль начнется через 10 секунд.");
				SendClientMessage(id, -1, "Игрок принял дуэль! Дуэль начнется через 10 секунд.");
				DuelTimer[playerid] = SetTimerEx("DuelOn", 1000, true, "ii", playerid, id);
				SetPVarInt(playerid, "antifloodduel", gettime()+60);
				TogglePlayerControllable(playerid, 0);
				TogglePlayerControllable(id, 0);
			}*/
			case DIALOG_ACTION_F_PROGRESS:
			{
			    new fmt_str[300];

			    if(!response) return 1;

				switch(list_id-1)
				{
					case 0:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_1) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Станьте врачем и вылечите 1000 пациетов.\n\
							"c_server"Награда: "c_b"100 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/1.000",
							GetPlayerData(playerid, P_PROGRESS_EXP_1)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
					case 1:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_2) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Станьте полицейским и выдайте штраф 500 раз.\n\
							"c_server"Награда: "c_b"100 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/500",
							GetPlayerData(playerid, P_PROGRESS_EXP_2)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
					case 2:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_3) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Станьте полицейским и выдайте розыск 500 раз.\n\
							"c_server"Награда: "c_b"100 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/500",
							GetPlayerData(playerid, P_PROGRESS_EXP_3)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
					case 3:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_4) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Станьте полицейским и посадите игроков в тюрьму 500 раз.\n\
							"c_server"Награда: "c_b"100 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/500",
							GetPlayerData(playerid, P_PROGRESS_EXP_4)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
					case 4:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_5) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Устройтесь в радиоцентр и отредактируйте 1000 объявлений.\n\
							"c_server"Награда: "c_b"50 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/1.000",
							GetPlayerData(playerid, P_PROGRESS_EXP_5)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
					case 5:
					{

					    if(GetPlayerData(playerid, P_PROGRESS_6) >= 1) return Send(playerid, -1, "Вы уже выполнили это достижение.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Станьте адвокатом и выпустите с тюрьмы 500 людей.\n\
							"c_server"Награда: "c_b"100 DONATE-RUB\n\
							"c_server"Прогресс: "c_b"%d/500",
							GetPlayerData(playerid, P_PROGRESS_EXP_6)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Достижения", fmt_str, "Закрыть", "");
						return 1;
					}
				}
			}
			case DIALOG_ACTION_F_QUEST:
			{
			    new fmt_str[300];

			    if(!response) return 1;

				switch(list_id-1)
				{
					case 0:
					{

					    if(GetPlayerData(playerid, P_F_QUEST_1) >= 1) return Send(playerid, -1, "Вы уже выполнили этот квест.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Выпустите 40 людей с тюрьмы.\n\
							"c_server"Награда: "c_b"1 CASE\n\
							"c_server"Прогресс: "c_b"%d/35",
							GetPlayerData(playerid, P_F_QUEST_EXP_1)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 1:
					{

					    if(GetPlayerData(playerid, P_F_QUEST_2) >= 1) return Send(playerid, -1, "Вы уже выполнили этот квест.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Убейте 30 людей во время войный за территорию.\n\
							"c_server"Награда: "c_b"1 CASE\n\
							"c_server"Прогресс: "c_b"%d/30",
							GetPlayerData(playerid, P_F_QUEST_EXP_2)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 2:
					{

					    if(GetPlayerData(playerid, P_F_QUEST_3) >= 1) return Send(playerid, -1, "Вы уже выполнили этот квест.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Посадите 40 людей в тюрьму.\n\
							"c_server"Награда: "c_b"1 CASE\n\
							"c_server"Прогресс: "c_b"%d/40",
							GetPlayerData(playerid, P_F_QUEST_EXP_3)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 3:
					{

					    if(GetPlayerData(playerid, P_F_QUEST_4) >= 1) return Send(playerid, -1, "Вы уже выполнили этот квест.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Отредактируйте 150 объявлений.\n\
							"c_server"Награда: "c_b"1 CASE\n\
							"c_server"Прогресс: "c_b"%d/150",
							GetPlayerData(playerid, P_F_QUEST_EXP_4)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
					case 4:
					{

					    if(GetPlayerData(playerid, P_F_QUEST_5) >= 1) return Send(playerid, -1, "Вы уже выполнили этот квест.");

						format
						(
							fmt_str, sizeof fmt_str,
							""c_server"Информация: "c_b"Вылечите 100 пациентов.\n\
							"c_server"Награда: "c_b"1 CASE\n\
							"c_server"Прогресс: "c_b"%d/100",
							GetPlayerData(playerid, P_F_QUEST_EXP_5)
						);

						Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Квесты", fmt_str, "Закрыть", "");
						return 1;
					}
				}
			}
			case DIALOG_DONATE_CASE:
			{
			    if(GetPlayerData(playerid, P_DONATE_CASE) <= 0)
					return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет кейса.");
		
	            GetPlayerPrise(playerid);
	            
	            Dialog(playerid,DIALOG_DONATE_CASE_PRISE,DIALOG_STYLE_MSGBOX,
				"Открытие кейса",
				"{ffffff}Поздравляем Вы открыли кейс, Ваш приз: Посмотрите в чат.",
				"Забрать",""
				);
				return 1;
			}
			case DIALOG_OBMEN_MONET:
			{

			    if(!response) return 1;
			    
			    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
				{
					SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
					return -1;
				}

				if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
				{
					SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
					return -1;
				}

				switch(list_id-1)
				{
					case 0:
					{
					    if(Cars[car_1] <= 0) return Send(playerid,-1,"На складе нет данного транспорта!");
					
					    if(GetPlayerData(playerid, P_COINS) < 1000) return Send(playerid,-1,"У вас не достаточно монет!");
					    
					    new minus = Cars[car_1] -1;
					    mysql_format(mysql, str, 256, "UPDATE car_obmen SET car_1 = '%d'", minus);
         				mysql_query(mysql, str);

						Cars[car_1] = minus;
					    
					    new modelid = 407, color_1 = 17, color_2 = 17;
					    
					    new Float: pos_x = -335.7250;
						new Float: pos_y = 424.3185;
						new Float: pos_z = 12.2686;
						new Float: angle = 356.7986;
	
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
                            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, idx);

							SetVehicleParam(vehicleid, V_LOCK, false);

							SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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
						
						AddPlayerData(playerid, P_COINS, -, 1000);
	    				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

						SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы обменяли монеты на Пожарную машину.");
						SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
						EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
					}
					case 1:
					{
					    if(Cars[car_2] <= 0) return Send(playerid,-1,"На складе нет данного транспорта!");

					    if(GetPlayerData(playerid, P_COINS) < 1000) return Send(playerid,-1,"У вас не достаточно монет!");
					    
					    new minus = Cars[car_2] -1;
					    mysql_format(mysql, str, 256, "UPDATE car_obmen SET car_2 = '%d'", minus);
         				mysql_query(mysql, str);

						Cars[car_2] = minus;

					    new modelid = 431, color_1 = 17, color_2 = 17;

					    new Float: pos_x = -335.7250;
						new Float: pos_y = 424.3185;
						new Float: pos_z = 12.2686;
						new Float: angle = 356.7986;

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
                            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, idx);

							SetVehicleParam(vehicleid, V_LOCK, false);

							SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

						AddPlayerData(playerid, P_COINS, -, 1000);
	    				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

						SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы обменяли монеты на Автобус.");
						SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
						EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
					}
					case 2:
					{
					    if(Cars[car_3] <= 0) return Send(playerid,-1,"На складе нет данного транспорта!");

					    if(GetPlayerData(playerid, P_COINS) < 1000) return Send(playerid,-1,"У вас не достаточно монет!");
					    
					    new minus = Cars[car_3] -1;
					    mysql_format(mysql, str, 256, "UPDATE car_obmen SET car_3 = '%d'", minus);
         				mysql_query(mysql, str);

						Cars[car_3] = minus;

					    new modelid = 563, color_1 = 17, color_2 = 17;

					    new Float: pos_x = -335.7250;
						new Float: pos_y = 424.3185;
						new Float: pos_z = 12.2686;
						new Float: angle = 356.7986;

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
                            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, idx);
							SetVehicleParam(vehicleid, V_LOCK, false);

							SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

						AddPlayerData(playerid, P_COINS, -, 1000);
	    				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

						SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы обменяли монеты на Пожарный вертолет.");
						SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
						EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
					}
					case 3:
					{
					    if(Cars[car_4] <= 0) return Send(playerid,-1,"На складе нет данного транспорта!");

					    if(GetPlayerData(playerid, P_COINS) < 1000) return Send(playerid,-1,"У вас не достаточно монет!");
					    
					    new minus = Cars[car_4] -1;
					    mysql_format(mysql, str, 256, "UPDATE car_obmen SET car_4 = '%d'", minus);
         				mysql_query(mysql, str);

						Cars[car_4] = minus;

					    new modelid = 597, color_1 = 17, color_2 = 17;

					    new Float: pos_x = -335.7250;
						new Float: pos_y = 424.3185;
						new Float: pos_z = 12.2686;
						new Float: angle = 356.7986;

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
                            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, idx);
							SetVehicleParam(vehicleid, V_LOCK, false);

							SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

						AddPlayerData(playerid, P_COINS, -, 1000);
	    				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

						SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы обменяли монеты на Полицейскую машину.");
						SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
						EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
					}
					case 4:
					{
					    if(Cars[car_5] <= 0) return Send(playerid,-1,"На складе нет данного транспорта!");

					    if(GetPlayerData(playerid, P_COINS) < 3000) return Send(playerid,-1,"У вас не достаточно монет!");
					    
					    new minus = Cars[car_5] -1;
					    mysql_format(mysql, str, 256, "UPDATE car_obmen SET car_5 = '%d'", minus);
         				mysql_query(mysql, str);
         				
						Cars[car_5] = minus;

					    new modelid = 444, color_1 = 17, color_2 = 17;

					    new Float: pos_x = -335.7250;
						new Float: pos_y = 424.3185;
						new Float: pos_z = 12.2686;
						new Float: angle = 356.7986;

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
                            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, idx);
							SetVehicleParam(vehicleid, V_LOCK, false);

							SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

						AddPlayerData(playerid, P_COINS, -, 3000);
	    				UpdatePlayerDatabaseInt(playerid, "coins", GetPlayerData(playerid, P_COINS));

						SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы обменяли монеты на Монстер.");
						SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
						EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
					}
				}
			}
			case DIALOG_DONATE_OPEN:
			{
			    if(!response) return 1;
			    
			    switch(list_id-1)
				{
					case 0: callcmd::donat(playerid, "");
					case 1: ShowPlayerDonateDialog(playerid);
					
				}
			}
			/*case DIALOG_QUEST_OPEN:
			{
			    if(!response) return 1;

			    switch(list_id-1)
				{
					case 0: ShowPlayerQuestMenu(playerid);
					case 1: ShowPlayerQuestMenuFrac(playerid);

				}
			}*/
			case DIALOG_YTPROMO_ACTIVATE:
			{
			    /*if(GetPlayerLevel(playerid) < 12)
					return SendClientMessage(playerid, 0xCECECEFF, "Активировать ютуберский промокод можно с 12 игрового уровня (/menu > статистика)");*/

				if(response)
				{
					if(!strlen(inputtext))
					{
						callcmd::ytpromo(playerid, "");

						return 1;
					}

					new query[256],
						Cache: result,
						rows,
						type,
						amount,
						paydays,
						usings;

					mysql_format(mysql, query, sizeof query, "SELECT 1 FROM ytpromocode_activations WHERE uip='%e' AND code='%s'", GetPlayerIpEx(playerid), inputtext);
					result = mysql_query(mysql, query, true);
					rows = cache_num_rows(result);
					cache_delete(result);
					if (rows >= 5) {
						SendClientMessage(playerid, 0x3399FFFF, "Ограничение на активацию");
						return 1;
					}

					mysql_format(mysql, query, sizeof query, "SELECT * FROM ytpromocode_activations WHERE uid='%d' AND code='%s'", GetPlayerAccountID(playerid), inputtext);
					result = mysql_query(mysql, query, true);
					rows = cache_num_rows(result);

					if(rows)
					{
						//type = cache_get_field_content_int(0, "type");
						paydays = cache_get_field_content_int(0, "paydays");

						format(query, sizeof query, "Вы уже активировали этот промокод");

						if(paydays)
							format(query, sizeof query, "%s. Вы получите свой приз через %d PayDay", query, paydays);





						SendClientMessage(playerid, 0x1E90FFFF, query);

						cache_delete(result);

						return 1;
					}

					cache_delete(result);

					mysql_format(mysql, query, sizeof query, "SELECT * FROM ytpromocode WHERE code='%s' AND usings > 0", inputtext);
					result = mysql_query(mysql, query, true);

					rows = cache_num_rows(result);

					if(rows)
					{
				 		type = cache_get_field_content_int(0, "type");
						amount = cache_get_field_content_int(0, "amount");
						usings = cache_get_field_content_int(0, "usings");
						paydays = cache_get_field_content_int(0, "paydays");
					}

					cache_delete(result);

					if(!rows)
					{
						SendClientMessage(playerid, 0xCECECEFF, "Введенный промокод не существует");
						callcmd::ytpromo(playerid, "");

						return 1;
					}

					if(usings > 0)
					{
						if(!paydays)
						{
							AddPlayerData(playerid, promo_info[type][P_DATA], +, amount);
							UpdatePlayerDatabaseInt(playerid, promo_info[type][P_SQL_NAME], GetPlayerData(playerid, promo_info[type][P_DATA]));

							if(!strcmp(promo_info[type][P_SQL_NAME], "price"))
							{
								SendClientMessage(playerid, 0x999999FF, "Деньги были зачислены на банковский счёт");
							}
						}

						format(query, sizeof query, "Вы активировали промокод \"%s\"", inputtext);

						if(paydays > 0)
							format(query, sizeof query, "%s. Вы получите свой приз через %d PayDay", query, paydays);

						SendClientMessage(playerid, 0x66CC33FF, query);

						mysql_format(mysql, query, sizeof query, "UPDATE ytpromocode SET usings='%d' WHERE code='%s'", usings - 1, inputtext);
						mysql_query(mysql, query, false);

						mysql_format(mysql, query, sizeof query, "INSERT INTO ytpromocode_activations (uid,uip,code,paydays) VALUES (%d,'%e','%e',%d)", GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), inputtext, paydays);
						mysql_query(mysql, query, false);

					}
					else
					{
						SendClientMessage(playerid, 0xCECECEFF, "Лимит использования промокода исчерпан");
						callcmd::ytpromo(playerid, "");
					}
				}
			}
			case DIALOG_YTPROMO_CREATE:
			{
				if(response)
				{
					new code[32], type, amount, usings = 100000, paydays = 0;

					if(sscanf(inputtext, "P<,>s[32]dddd", code, type, amount))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::createytpromo(playerid, "");

						return 1;
					}
					else
					{
						if(!(0 <= type <= 3))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Тип должен быть от 0 до 3");
							callcmd::createytpromo(playerid, "");

							return 1;
						}

						if(!(1 <= amount <= 10_000_000))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Количество должно быть от 1 до 10.000.000");
							callcmd::createytpromo(playerid, "");

							return 1;
						}


						new query[128],
							Cache: result,
							rows;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM ytpromocode WHERE code='%s'", code);
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows(result);

						cache_delete(result);

						if(rows)
						{
							SendClientMessage(playerid, 0xCECECEFF, "Такой промокод уже есть в базе данных");
							callcmd::createytpromo(playerid, "");

							return 1;
						}

						mysql_format(mysql, query, sizeof query, "INSERT INTO ytpromocode (code, type, amount, usings, paydays) VALUES ('%s', %d, %d, %d, %d)",
						code, type, amount, usings, paydays);

						mysql_query(mysql, query);

						format(query, sizeof query, "YT-Промокод \"%s\" создан (Тип: %s, Количество: %d)", code, promo_info[type][P_NAME], amount);
						SendClientMessage(playerid, 0x66CC33FF, query);
					}
				}
			}
			case DIALOG_MTOP:
		    {
		        MtopMenu(playerid);
		    }
		    case DIALOG_MTOP_MENU:
		    {
		        if(!response) return 1;
		        switch(list_id)
		        {
		            case 1: callcmd::top_salary_new_work(playerid);
		            case 2: callcmd::top_salary_gos_work(playerid);
		            case 3: callcmd::top_payday(playerid);
		            case 4: callcmd::top_progress(playerid);
		            case 5: callcmd::top_quest(playerid);
		        }
		    }
		    case DIALOG_BOOMBOX_MENU:
		    {
				switch(listitem)
		  		{
		  		    case 0:
		      		{
		      		    new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

						if(green_zone_id != -1)
						{
							new fmt_text[144];

							format(fmt_text, sizeof fmt_text, "На территории {FFFF00}'%s' {1E90FF}нельзя пользоваться BoomBox. Выберите другое место!", g_green_zones[green_zone_id][GZ_NAME]);
							SendClientMessage(playerid, 0x1E90FFFF, fmt_text);

							return 1;
						}
					else
		      		    	callcmd::placeboomboxx(playerid, "");
		            }
		    		case 1:
		      		{
		      		    if(GetPVarType(playerid, "PlacedBB"))
						{
							if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
							{
		      		    		callcmd::placeboomboxxx(playerid, "");
                            }
					else
							{
					   			return SendClientMessage(playerid, -1, "Вы далеко от своего BoomBox!");
							}
					    }
					else
					    {
					        SendClientMessage(playerid, -1, "Вы не поставили BoomBox!");
						}
		            }
		            case 2:
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
							if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
							{
		                		callcmd::setboomboxx(playerid, "");
                            }
					else
							{
					   			return SendClientMessage(playerid, -1, "Вы далеко от своего BoomBox!");
							}
					    }
					else
					    {
					        SendClientMessage(playerid, -1, "Вы не поставили BoomBox!");
						}
		            }
		            case 3:
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
							if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
							{
				                if(GetPVarType(playerid, "BBArea"))
							    {
							        new string[128], pName[MAX_PLAYER_NAME];
							        GetPlayerName(playerid, pName, sizeof(pName));
									format(string, sizeof(string), "* %s выключил BoomBox.", pName);
									SendNearbyMessage(playerid, 15, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
							        foreach(Player, i)
									{
							            if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
							            {
							                StopStream(i);
										}
									}
							        DeletePVar(playerid, "BBStation");
								}
								SendClientMessage(playerid, COR_QUEST, "[Успешно]: "c_b"Вы успешно выключили BoomBox!");
                            }
					else
							{
					   			return SendClientMessage(playerid, -1, "Вы далеко от своего BoomBox!");
							}
					    }
					else
					    {
					        SendClientMessage(playerid, -1, "Вы не поставили BoomBox!");
						}
		            }
		        }
				return 1;
			}
		    case DIALOG_BOOMBOX:
		    {
		    	/*if(!response)
		     	{
		            SendClientMessage(playerid, COLOR_WHITE, " You cancel the Radio Station");
		        	return 1;
		        }*/
				switch(listitem)
		  		{
		  		    case 0:
		      		{
		      		    Dialog(playerid,DIALOG_BOOMBOX0,DIALOG_STYLE_LIST,"Радиостанции",
						  "Russia Radio\n\
			   		      Radio Europa Plus\n\
			 		      Radio Hit FM\n\
					      Radio Record\n\
					      Radio D-FM\n\
					      Comedy Radio",
						  "Включить","Закрыть");
		            }
		    		case 1:
		      		{
		      		    Dialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_LIST,"Макс Корж",
						  "Макс Корж - Оптимист\n\
			   		      Макс Корж - Пролетарка\n\
			 		      Макс Корж - Контрольный\n\
					      Макс Корж - Шантаж\n\
					      Макс Корж - 2 типа людей\n\
					      Макс Корж - Разнесем\n\
					      Макс Корж - Малолетка\n\
					      Макс Корж - Времена\n\
					      Макс Корж - Тепло\n\
					      Макс Корж - Её виной",
						  "Включить","Закрыть");
		            }
		            case 2:
		            {
		                Dialog(playerid,DIALOG_BOOMBOX2,DIALOG_STYLE_LIST,"Miyagi & Эндшпиль",
						"Miyagi & Эндшпиль - Фея\n\
						Miyagi & Эндшпиль feat. N.E.R.A.K. - Именно та\n\
						Miyagi & Эндшпиль - Бонни\n\
						Miyagi & Эндшпиль - Marlboro\n\
						Miyagi & Эндшпиль - Мой Babylon\n\
						Miyagi & Эндшпиль feat. Рем Дигга - I Got Love\n\
						Miyagi & Эндшпиль - Малиновый рассвет\n\
						Miyagi & Эндшпиль - Рапапапапам\n\
						Miyagi & Эндшпиль - Utopia\n\
						Miyagi & Эндшпиль - All the Time",
						"Включить","Закрыть");
		            }
		            case 3:
		            {
		                Dialog(playerid,DIALOG_BOOMBOX3,DIALOG_STYLE_LIST,"Канги",
						"Канги - Возьми сердце моё\n\
						Канги - Эйя\n\
						Канги - Вали\n\
						Канги - Просто услышь меня\n\
						Канги - Жить не запретишь\n\
						Канги - Собака",
						"Включить","Закрыть");
		            }
		            case 4:
		            {
		                Dialog(playerid,DIALOG_BOOMBOX4,DIALOG_STYLE_LIST,"MORGENSHTERN",
						"MORGENSHTERN - Cristal & Моёт\n\
						MORGENSHTERN & Lil Pump - WATAFUK?!\n\
						MORGENSHTERN  & Тимати - El Problema\n\
						MORGENSHTERN & Элджей - Lollipop\n\
						MORGENSHTERN - ICE\n\
						MORGENSHTERN & Элджей - Cadillac\n\
						MORGENSHTERN - Пососи\n\
						MORGENSHTERN & Клава Кока - Мне пох\n\
						MORGENSHTERN - Yung Hefner\n\
						MORGENSHTERN - Новый Мерин",
						"Включить","Закрыть");
					}
					case 5:
					{
					    Dialog(playerid,DIALOG_BOOMBOX5,DIALOG_STYLE_LIST,"Slava Marlow",
						"Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - \n\
						Slava Marlow - ",
						"Включить","Закрыть");
					}
					case 6:
					{
					    Dialog(playerid,DIALOG_BOOMBOX6,DIALOG_STYLE_LIST,"Country","181 Kicking Country\nAbsolute Country Radio","Select","Cancel");
					}
					case 7:
					{
					    Dialog(playerid,DIALOG_BOOMBOX7,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
					}
					case 8:
					{
		                if(GetPVarType(playerid, "BBArea"))
					    {
					        new string[128], pName[MAX_PLAYER_NAME];
					        GetPlayerName(playerid, pName, sizeof(pName));
							format(string, sizeof(string), "* %s has turned off their boombox.", pName);
							SendNearbyMessage(playerid, 15, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					        foreach(Player, i)
							{
					            if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
					            {
					                StopStream(i);
								}
							}
					        DeletePVar(playerid, "BBStation");
						}
						SendClientMessage(playerid, COLOR_WHITE, "Вы выключили бумбокс");
					}
		        }
				return 1;
			}
			case DIALOG_BOOMBOX0://RAP
			{
			    /*if(!response)
			    {
		     		Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}*/
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://rusradio.hostingradio.ru/rusradio128.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://rusradio.hostingradio.ru/rusradio128.mp3");
						}
					}
					if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://ep256.streamr.ru", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://ep256.streamr.ru");
						}
					}
					if(listitem == 2)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://hitfm.hostingradio.ru/hitfm128.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://hitfm.hostingradio.ru/hitfm128.mp3");
						}
					}
					if(listitem == 3)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://online.radiorecord.ru:8101/rr_128", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://online.radiorecord.ru:8101/rr_128");
						}
					}
					if(listitem == 4)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dfm.hostingradio.ru/dfm128.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dfm.hostingradio.ru/dfm128.mp3");
						}
					}
					if(listitem == 5)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://ic7.101.ru:8000/s60", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://ic7.101.ru:8000/s60");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX1:
			{
			    /*if(!response)
			    {
		     		Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}*/
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2017-11/1510124704_maks-korzh-optimist-www_muzonov_net.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2017-11/1510124704_maks-korzh-optimist-www_muzonov_net.mp3");
						}
					}
				 	if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2018-09/1536354039_1536349123_maks-korzh-proletarka.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2018-09/1536354039_1536349123_maks-korzh-proletarka.mp3");
						}
					}
					if(listitem == 2)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-04/1554531411_maks-korzh-kontrolnyy-2019-muzonov_net.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-04/1554531411_maks-korzh-kontrolnyy-2019-muzonov_net.mp3");
						}
					}
					if(listitem == 3)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-06/1560371089_maks-korzh-shantazh.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-06/1560371089_maks-korzh-shantazh.mp3");
						}
					}
					if(listitem == 4)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-08/1566462500_maks-korzh-2-tipa-lyudey.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-08/1566462500_maks-korzh-2-tipa-lyudey.mp3");
						}
					}
					if(listitem == 5)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2020-01/1580430900_maks-korzh-raznesem-2020.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2020-01/1580430900_maks-korzh-raznesem-2020.mp3");
						}
					}
					if(listitem == 6)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-12/1577676930_maks-korzh-maloletka.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-12/1577676930_maks-korzh-maloletka.mp3");
						}
					}
					if(listitem == 7)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/08/maks-korzh-vremena.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/08/maks-korzh-vremena.mp3");
						}
					}
					if(listitem == 8)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/08/maks-korzh-teplo.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/08/maks-korzh-teplo.mp3");
						}
					}
					if(listitem == 9)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/10/maks-korzh-eyo-vinoj.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/10/maks-korzh-eyo-vinoj.mp3");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX2:
			{
			    /*if(!response)
			    {
		            Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}*/
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2021/01/miyagi-miyagi-endshpil-feya.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2021/01/miyagi-miyagi-endshpil-feya.mp3");
						}
					}
					if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-04/1555686984_miyagi-amp-endshpil-n_e_r_a_k_-imenno-ta-2018-muzonov_net.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-04/1555686984_miyagi-amp-endshpil-n_e_r_a_k_-imenno-ta-2018-muzonov_net.mp3");
						}
					}
					if(listitem == 2)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2021/01/miyagi-bonni-feat-endshpil.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2021/01/miyagi-bonni-feat-endshpil.mp3");
						}
					}
					if(listitem == 3)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/uploads/files/2019-06/1561112728_miyagi-marlboro.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/uploads/files/2019-06/1561112728_miyagi-marlboro.mp3");
						}
					}
					if(listitem == 4)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/04/endshpil-moj-babylon.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/04/endshpil-moj-babylon.mp3");
						}
					}
					if(listitem == 5)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/03/miyagi-i-got-love.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/03/miyagi-i-got-love.mp3");
						}
					}
					if(listitem == 6)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/08/miyagi-endshpil-malinovyj-rassvet.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/08/miyagi-endshpil-malinovyj-rassvet.mp3");
						}
					}
					if(listitem == 7)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/05/endshpil-rapapapapam.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/05/endshpil-rapapapapam.mp3");
						}
					}
					if(listitem == 8)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/04/miyagi-andy-panda-utopia-miyagi-andy-panda.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/04/miyagi-andy-panda-utopia-miyagi-andy-panda.mp3");
						}
					}
					if(listitem == 9)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/12/miyagi-all-the-time.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/12/miyagi-all-the-time.mp3");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX3://RAP
			{
			    /*if(!response)
			    {
		     		Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}*/
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2021/02/kangi-vozmi-serdce-moe.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2021/02/kangi-vozmi-serdce-moe.mp3");
						}
					}
					if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2021/01/kangi-ejya-ejya-ejya-jo.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2021/01/kangi-ejya-ejya-ejya-jo.mp3");
						}
					}
					if(listitem == 2)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/08/kangi-vali-original.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/08/kangi-vali-original.mp3");
						}
					}
					if(listitem == 3)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/04/kangi-prosto-uslysh-menya-a-moya-lyubov-samaya-chistaya.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/04/kangi-prosto-uslysh-menya-a-moya-lyubov-samaya-chistaya.mp3");
						}
					}
					if(listitem == 4)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2021/03/zhit-ne-zapretish-kangi.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2021/03/zhit-ne-zapretish-kangi.mp3");
						}
					}
					if(listitem == 5)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://dl.muzonovs.ru/files/music/2020/04/kangi-kangi-sobaka.mp3", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://dl.muzonovs.ru/files/music/2020/04/kangi-kangi-sobaka.mp3");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX4://HIP HOP
			{
			    if(!response)
			    {
		     		Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=32999", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=32999");
						}
					}
					if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=105867", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=105867");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX5://ROCK
			{
			    if(!response)
			    {
		     		Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=785339", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=785339");
						}
					}
		   			if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=19275", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=19275");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX6://COUNTRY
			{
			    if(!response)
			    {
			       Dialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Radio List","Jazz\nPop\nRap\nR&B and Urban\nRock\nCountry\nEnter URL\nTurn Off Boombox","Select", "Cancel");
				}
				if(response)
		        {
		            if(listitem == 0)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=71887", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=71887");
						}
					}
		   			if(listitem == 1)
		            {
		                if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, "http://yp.shoutcast.com/sbin/tunein-station.pls?id=34839", GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", "http://yp.shoutcast.com/sbin/tunein-station.pls?id=34839");
						}
					}
				}
				return 1;
			}
			case DIALOG_BOOMBOX7://SET URL
			{
				if(response == 1)
				{
				    if(isnull(inputtext))
				    {
				        SendClientMessage(playerid, COLOR_WHITE, "You did not enter anything" );
				        return 1;
				    }
				    if(strlen(inputtext))
				    {
				        if(GetPVarType(playerid, "PlacedBB"))
						{
						    foreach(Player, i)
							{
								if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
								{
									PlayStream(i, inputtext, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
						  		}
						  	}
					  		SetPVarString(playerid, "BBStation", inputtext);
						}
					}
				}
					else
				{
				    return 1;
				}
			}
		    case 30000:
		    {
		        if(!response) return 1;
		        if(!(2 <= strlen(inputtext) <= 6))
				{
					Dialog(playerid, 30000,DIALOG_STYLE_INPUT,"Создать собеседование","Введите время, на которое вы хотите назначить собеседование\n\n{FF0000}Разрешено вводить время от 2-х до 6 символов!","Ввести","Закрыть");
					return 1;
				}
				for(new i = strlen(inputtext); i != 0; --i)
				{
		            switch(inputtext[i])
		            {
		                    case 'A'..'Z', 'А'..'Я','a'..'z', 'а'..'я' :
		                    return Dialog(playerid, 30000,DIALOG_STYLE_INPUT,"Создать собеседование","Введите время, на которое вы хотите назначить собеседование\n\n{FF0000}Разрешено вводить только цифры!","Ввести","Закрыть");
		            }
				}
				switch(GetPlayerTeamEx(playerid))
				{
					case TEAM_ARMY: format(interview[TEAM_ARMY][text_time],15,"%s",inputtext);
					case TEAM_GOVERNMENT: format(interview[TEAM_GOVERNMENT][text_time],15,"%s",inputtext);
					case TEAM_DPS: format(interview[TEAM_DPS][text_time],15,"%s",inputtext);
					case TEAM_RADIO: format(interview[TEAM_RADIO][text_time],15,"%s",inputtext);
					case TEAM_HOSPITAL: format(interview[TEAM_HOSPITAL][text_time],15,"%s",inputtext);
					case TEAM_FBI: format(interview[TEAM_FBI][text_time], 15,"%s",inputtext);
					case TEAM_PPS: format(interview[TEAM_PPS][text_time], 15,"%s",inputtext);
				}
				Dialog(playerid, 30001, DIALOG_STYLE_INPUT,"Создать собеседование","Введите критерии, которые вам необходимы","Ввести","Закрыть");
		    }
		    case 30001:
		    {
		        if(!response)
				{
				    switch(GetPlayerTeamEx(playerid))
				    {
				        case TEAM_DPS: interview[TEAM_DPS][text_time] = EOS;
				        case TEAM_FBI: interview[TEAM_FBI][text_time] = EOS;
				        case TEAM_ARMY: interview[TEAM_ARMY][text_time] = EOS;
				        case TEAM_HOSPITAL: interview[TEAM_HOSPITAL][text_time] = EOS;
				        case TEAM_GOVERNMENT: interview[TEAM_GOVERNMENT][text_time] = EOS;
				        case TEAM_RADIO: interview[TEAM_RADIO][text_time] = EOS;
				        case TEAM_PPS: interview[TEAM_PPS][text_time] = EOS;
				    }
					return 1;
				}
		        if(!(2 <= strlen(inputtext) <= 70))
				{
					Dialog(playerid, 30001, DIALOG_STYLE_INPUT,"Создать собеседование","Введите критерии, которые вам необходимы\n\n{FF0000}Разрешено вводить от 2-х до 70 символов!","Ввести","Закрыть");
					return 1;
				}
				switch(GetPlayerTeamEx(playerid))
				{
				    case TEAM_ARMY: format(interview[TEAM_ARMY][text_crit], 100,"%s",inputtext);
				    case TEAM_GOVERNMENT: format(interview[TEAM_GOVERNMENT][text_crit],100,"%s",inputtext);
				    case TEAM_DPS: format(interview[TEAM_DPS][text_crit], 100,"%s",inputtext);
				    case TEAM_HOSPITAL: format(interview[TEAM_HOSPITAL][text_crit],100,"%s", inputtext);
				    case TEAM_RADIO: format(interview[TEAM_HOSPITAL][text_crit],100,"%s",inputtext);
				    case TEAM_FBI: format(interview[TEAM_FBI][text_crit], 100,"%s",inputtext);
				    case TEAM_PPS: format(interview[TEAM_PPS][text_crit], 100,"%s",inputtext);
				}
				SendClientMessage(playerid, -1,"{FFFF00}[Информация]{FFFFFF} Собеседование успешно создано!");
				return 1;
		    }
		    case DIALOG_BUY_DONATE_CAR:
			{
			    new color_1 = 17, color_2 = 17;
			    
			    new Float: pos_x = -335.7250;
				new Float: pos_y = 424.3185;
				new Float: pos_z = 12.2686;
				new Float: angle = 356.7986;
						
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}
							
							new modelid = DONATE_CAR_ID_1, price = DONATE_CAR_PRICE_1;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}
	
						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {
						    
						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                                    format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                                    ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);

									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 2:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_2, price = DONATE_CAR_PRICE_2;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                                    format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                                    ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);

									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 3:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_3, price = DONATE_CAR_PRICE_3;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 4:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_4, price = DONATE_CAR_PRICE_4;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 5:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_5, price = DONATE_CAR_PRICE_5;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 6:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_6, price = DONATE_CAR_PRICE_6;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 7:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_7, price = DONATE_CAR_PRICE_7;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 8:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_8, price = DONATE_CAR_PRICE_8;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
									//	CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
									//index = GetVehicleData(vehicleid, V_ACTION_ID);
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 9:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_9, price = DONATE_CAR_PRICE_9;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                           		 	ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
						case 10:
						{
						    if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
							{
								SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
								return -1;
							}

							if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
							{
								SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
								return -1;
							}

							new modelid = DONATE_CAR_ID_10, price = DONATE_CAR_PRICE_10;
							new idx = GetFreeOwnableCarID();
							if(idx == -1)
							{
								SendClientMessage(playerid, 0xE0584BFF, "Покупка временно недоступна: нет свободного системного слота транспорта.");
								return -1;
							}

						    if(GetPlayerData(playerid, P_DONATE_RUB) >= price)
						    {

						        GivePlayerDonateRub(playerid, -price, "Покупка донатного автомобиля", true, true);

								new query[220],
									Cache: result;

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
                            		format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
                            		ApplyOwnableCarStoredPlate(vehicleid, idx);
									SetVehicleParam(vehicleid, V_LOCK, false);
									SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
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

								SendClientMessage(playerid, 0x66CC00FF, "Поздравляем! Вы купили донат машину.");
								SendClientMessage(playerid, 0x66CC00FF, "Напишите {0099FF}/car {66CC00}чтобы узнать о возможностях");
								EnablePlayerGPS(playerid, 55, pos_x, pos_y, pos_z, "Местоположение Вашего транспорта отмечено на GPS");
							}
					else
							    return Send(playerid,-1,"У вас не достаточно донат рублей!");
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_GPS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							Dialog
							(
								playerid, DIALOG_GPS_PUBLIC_PLACES, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Важные места",
								"1. Правительство\n\
								2. Автошкола\n\
								3. Военкомат\n\
								4. Городская больница г.Арзамас",
								"Выбрать", "Назад"
							);
						}
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_GPS_TRANSPORT, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Работы для новичков",
								"1. Шахта\n\
								2. Грузчик\n\
								3. Завод",
								"Выбрать", "Назад"
							);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_GPS_JOBS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Основные работы",
								"1. База механиков\n\
								2. Аренда автобуса(Южный)\n\
								3. Аренда автобуса(Арзамас)\n\
								4. Аренда автобуса(Батырево)\n\
								5. Электрик\n\
								6. МЧС",
								"Выбрать", "Назад"
							);
						}
						case 3:
						{
							Dialog
							(
								playerid, DIALOG_GPS_STATE_ORGANIZATIONS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Государственные организации",
								"1. Правительство области\n\
								2. Отдел полиции №1 (ГИБДД)\n\
								3. Отдел полиции №2 (УМВД)\n\
								4. Отдел ФСБ\n\
								5. Городская больница г. Арзамас\n\
								6. СМИ\n\
								7. Воинская часть\n\
                                8. ФСИН (отдел кадров)",
								"Выбрать", "Назад"
							);
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_GPS_GANGS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Базы преступных группировок",
								"1. Арзамасская ОПГ\n\
								2. Батыревская ОПГ\n\
								3. Лыткаринская ОПГ\n\
								4. Стена для взрыва",
								"Выбрать", "Назад"
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, GPS_DIALOG_TC_OFFICES, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff} | Транспортные компании",
								"1. Офис ТК — Батырево\n2. Офис ТК — Бусаево",
								"Выбрать", "Назад"
							);
						}
						case 6:
						{
                            Dialog(playerid, DIALOG_GPS_CONSTRUCTION_COMPANY, DIALOG_STYLE_LIST,
                                "{00FFFF}"SERVER_NAME"{ffffff} | Строительные компании",
                                "1. Устройство в строительную компанию\n2. Стройка г. Арзамас", "Выбрать", "Назад");
						}
						case 7:
						{
					 		return SCM(playerid, -1, ""USC"В разработке!");
						}
						case 8:
						{
							Dialog
							(
								playerid, DIALOG_GPS_ENTERTAINMENT, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff} | Развлечения",
								"1. Казино\n\
								2. Битва за контейнеры\n\
								3. Компьютерный клуб",
								"Выбрать", "Назад"
							);
						}
						case 9:
						{
							Dialog
							(
								playerid, DIALOG_GPS_BANKS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff} | Банки",
								"1. Центральный банк Арзамаса\n\
								2. Центральный банк Южный\n\
								3. Центральный банк Батырево",
								"Выбрать", "Назад"
							);
						}
						case 10:
						{
							Dialog
							(
								playerid, DIALOG_GPS_TK, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff} | Причалы",
								"1. Причал возле Гарели\n\
								2. Причал г.Южный\n\
								3. Причал г.Арзамас\n\
								4. Причал г.Лыткарино",
								"Выбрать", "Назад"
							);
						}
						case 11:
						{
							Dialog
							(
								playerid, DIALOG_GPS_AUTOSALONS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Автосалоны",
								"1. Автосалон низкого класса\n\
								2. Автосалон среднего класса\n\
								3. Автосалон высокого класса\n\
								4. Салон грузовых автомобилей\n\
								5. Мотосалон 'Harley Davidson'\n\
								6. Авторынок",
								"Выбрать", "Назад"
							);
						}
						case 12:
						{
							Dialog
							(
								playerid, GPS_DIALOG_TUNING_ATELIER, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff} | Тюнинг ателье",
								"1. Стайлинг центр\n2. Шиномонтажный центр\n3. Технический центр",
								"Выбрать", "Назад"
							);
						}
						case 13:
						{
							Dialog
							(
								playerid, DIALOG_GPS_CITIES, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Города и населенные пункты",
								"1. г. Южный\n\
								2. г. Арзамас\n\
								3. д. Рублевка\n\
								4. п. Егоровка\n\
								5. пгт. Батырево\n\
								6. г. Лыткарино\n\
								7. г. Эдово\n\
								8. п. Бусаево\n\
								9. п. Роговичи\n\
								10. д. Корякино",
								"Выбрать", "Назад"
							);
						}
						case 14:
						{
							Dialog
							(
								playerid, DIALOG_GPS_VOKZALS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Вокзалы",
								"1. Вокзал г. Арзамас\n\
								2. Вокзал г. Южный\n\
								3. Вокзал пгт. Батырево",
								"Выбрать", "Назад"
							);
						}
						case 15:
						{
							Dialog
							(
								playerid, DIALOG_GPS_MISTS, DIALOG_STYLE_LIST,
								"{00FFFF}"SERVER_NAME"{ffffff}| Поиск ближайщих мест",
								"1. Найти ближайшую АЗС\n\
								2. Найти ближайший магазин 24/7\n\
								3. Найти ближайший магазин одежды\n\
								4. Найти ближайший магазин оружия\n\
								5. Найти ближайший магазин аксессуаров",
								"Выбрать", "Назад"
							);
						}
					}
				}
			}
			case DIALOG_GPS_MISTS:
			{
				if(response)
				{
					switch(listitem)
					{
					    case 0:
						{
							new fmt_str[128];

							new stationid;
							new Float: dist;

							stationid = GetNearestFuelStation(playerid, 0.0);
							dist = GetPlayerDistanceFromPoint(playerid, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z));

							EnablePlayerGPS
							(
								playerid,
								47,
								GetFuelStationData(stationid, FS_POS_X),
								GetFuelStationData(stationid, FS_POS_Y),
								GetFuelStationData(stationid, FS_POS_Z),
								""
							);

							format(fmt_str, sizeof fmt_str, "Ближе всех к Вам находится АЗС №%d \"%s\" (расстояние %.1f м)", stationid, GetFuelStationData(stationid, FS_NAME), dist);
							SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

							SendClientMessage(playerid, 0xFFFF00FF, "Она отмечена у Вас на карте");
						}
						case 1:
						{
							new fmt_str[128];

							new biz_id;
							new Float: dist;

							biz_id = GetNearestBiz(playerid, BUSINESS_TYPE_SHOP_24_7, 0.0);
							dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z));

							EnablePlayerGPS
							(
								playerid,
								23,
								GetBusinessData(biz_id, B_POS_X),
								GetBusinessData(biz_id, B_POS_Y),
								GetBusinessData(biz_id, B_POS_Z),
								""
							);

							format(fmt_str, sizeof fmt_str, "Ближе всех к Вам находится \"%s\" №%d (расстояние %.1f м)", GetBusinessInteriorInfo(GetBusinessData(biz_id, B_INTERIOR), BT_NAME), biz_id,  dist);
							SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

							SendClientMessage(playerid, 0xFFFF00FF, "Он отмечен у Вас на карте");
						}
						case 2:
						{
							new fmt_str[128];

							new biz_id;
							new Float: dist;

							biz_id = GetNearestBiz(playerid, BUSINESS_TYPE_CLOTHING_SHOP, 0.0);
							dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z));

							EnablePlayerGPS
							(
								playerid,
								45,
								GetBusinessData(biz_id, B_POS_X),
								GetBusinessData(biz_id, B_POS_Y),
								GetBusinessData(biz_id, B_POS_Z),
								""
							);

							format(fmt_str, sizeof fmt_str, "Ближе всех к Вам находится \"%s\" №%d (расстояние %.1f м)", GetBusinessInteriorInfo(GetBusinessData(biz_id, B_INTERIOR), BT_NAME), biz_id,  dist);
							SendClientMessage(playerid, 0xFFFF00FF, fmt_str);

							SendClientMessage(playerid, 0xFFFF00FF, "Он отмечен у Вас на карте");
						}
                        case 3:
                        {
                            new fmt_str[128];
                            new biz_id = GetNearestBiz(playerid, BUSINESS_TYPE_SHOP_GUN, 0.0);

                            if(biz_id == -1)
                                return SendClientMessage(playerid, 0xFF6347FF, "Gun shop not found");

                            new Float:dist = GetPlayerDistanceFromPoint(playerid, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z));

                            EnablePlayerGPS
                            (
                                playerid,
                                18,
                                GetBusinessData(biz_id, B_POS_X),
                                GetBusinessData(biz_id, B_POS_Y),
                                GetBusinessData(biz_id, B_POS_Z),
                                ""
                            );

                            format(fmt_str, sizeof fmt_str, "Nearest gun shop: #%d (distance: %.1f m)", biz_id, dist);
                            SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
                            SendClientMessage(playerid, 0xFFFF00FF, "The location is marked on your map");
                        }
                        case 4:
                        {
                            new biz_id = GetNearestBiz(playerid, BUSINESS_TYPE_ACCESSORY_SHOP, 0.0);
                            if(biz_id == -1)
                            {
                                return SendClientMessage(playerid, 0xFF6347FF, "Магазин аксессуаров не найден");
                            }

                            new Float:dist = GetPlayerDistanceFromPoint(
                                playerid,
                                GetBusinessData(biz_id, B_POS_X),
                                GetBusinessData(biz_id, B_POS_Y),
                                GetBusinessData(biz_id, B_POS_Z)
                            );

                            EnablePlayerGPS
                            (
                                playerid,
                                45,
                                GetBusinessData(biz_id, B_POS_X),
                                GetBusinessData(biz_id, B_POS_Y),
                                GetBusinessData(biz_id, B_POS_Z),
                                ""
                            );

                            new fmt_str[144];
                            format(fmt_str, sizeof fmt_str,
                                "Ближайший магазин аксессуаров №%d (расстояние %.1f м)",
                                biz_id, dist);
                            SendClientMessage(playerid, 0xFFFF00FF, fmt_str);
                            SendClientMessage(playerid, 0xFFFF00FF, "Магазин отмечен у Вас на карте");
                        }
                    }
				}
					else callcmd::gps(playerid, "");
			}
			
			case DIALOG_GPS_VOKZALS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_vokzals-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_vokzals[listitem][G_MARKET_TYPE],
							gps_vokzals[listitem][G_POS_X],
							gps_vokzals[listitem][G_POS_Y],
							gps_vokzals[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_CITIES:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_cities-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_cities[listitem][G_MARKET_TYPE],
							gps_cities[listitem][G_POS_X],
							gps_cities[listitem][G_POS_Y],
							gps_cities[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_AUTOSALONS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_autosalons-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_autosalons[listitem][G_MARKET_TYPE],
							gps_autosalons[listitem][G_POS_X],
							gps_autosalons[listitem][G_POS_Y],
							gps_autosalons[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case GPS_DIALOG_TC_OFFICES:
			{
				if(!response) return callcmd::gps(playerid, "");
				if(listitem < 0 || listitem >= sizeof g_tc_building_enter) return 1;
				return EnablePlayerGPS(playerid, 27,
					g_tc_building_enter[listitem][0],
					g_tc_building_enter[listitem][1],
					g_tc_building_enter[listitem][2],
					"Вход в офис ТК отмечен на карте.");
			}
			case GPS_DIALOG_TUNING_ATELIER:
			{
				if(!response) return callcmd::gps(playerid, "");
				switch(listitem)
				{
					case 0: return EnablePlayerGPS(playerid, 27, 2312.133056, -2601.552246, 21.829063, "Стайлинг центр отмечен на GPS.");
					case 1: return EnablePlayerGPS(playerid, 27, 1731.648803, 2447.955810, 14.979245, "Шиномонтажный центр отмечен на GPS.");
					case 2: return EnablePlayerGPS(playerid, 27, -431.906372, 1005.235168, 12.189999, "Технический центр отмечен на GPS.");
				}
				return 1;
			}
			case DIALOG_GPS_TK:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_tk-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_tk[listitem][G_MARKET_TYPE],
							gps_tk[listitem][G_POS_X],
							gps_tk[listitem][G_POS_Y],
							gps_tk[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_ENTERTAINMENT:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_entertainment-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_entertainment[listitem][G_MARKET_TYPE],
							gps_entertainment[listitem][G_POS_X],
							gps_entertainment[listitem][G_POS_Y],
							gps_entertainment[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_MP:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_mp-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_mp[listitem][G_MARKET_TYPE],
							gps_mp[listitem][G_POS_X],
							gps_mp[listitem][G_POS_Y],
							gps_mp[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_PUBLIC_PLACES:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_public_places-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_public_places[listitem][G_MARKET_TYPE],
							gps_public_places[listitem][G_POS_X],
							gps_public_places[listitem][G_POS_Y],
							gps_public_places[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_TRANSPORT:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_transport-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_transport[listitem][G_MARKET_TYPE],
							gps_transport[listitem][G_POS_X],
							gps_transport[listitem][G_POS_Y],
							gps_transport[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_STATE_ORGANIZATIONS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_state_organizations-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_state_organizations[listitem][G_MARKET_TYPE],
							gps_state_organizations[listitem][G_POS_X],
							gps_state_organizations[listitem][G_POS_Y],
							gps_state_organizations[listitem][G_POS_Z],
							"Местоположение организации отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_CONSTRUCTION_COMPANY:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: EnablePlayerGPS(playerid,21,179.305297,391.597808,16.195312,"Устройство в строительную компанию отмечено на GPS");
						case 1: EnablePlayerGPS(playerid,21,-9.116186,1807.725463,9.477350,"Стройка г. Арзамас отмечена на GPS");
					}
				}
				else callcmd::gps(playerid,"");
			}
			case DIALOG_GPS_QUEST:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_quest-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_quest[listitem][G_MARKET_TYPE],
							gps_quest[listitem][G_POS_X],
							gps_quest[listitem][G_POS_Y],
							gps_quest[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_GANGS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_gangs-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_gangs[listitem][G_MARKET_TYPE],
							gps_gangs[listitem][G_POS_X],
							gps_gangs[listitem][G_POS_Y],
							gps_gangs[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_JOBS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_jobs-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_jobs[listitem][G_MARKET_TYPE],
							gps_jobs[listitem][G_POS_X],
							gps_jobs[listitem][G_POS_Y],
							gps_jobs[listitem][G_POS_Z],
							"Место отмечено у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_BANKS:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof gps_banks-1)
					{
						EnablePlayerGPS
						(
							playerid,
							gps_banks[listitem][G_MARKET_TYPE],
							gps_banks[listitem][G_POS_X],
							gps_banks[listitem][G_POS_Y],
							gps_banks[listitem][G_POS_Z],
							"Банк отмечен у Вас на GPS"
						);
					}
				}
					else callcmd::gps(playerid, "");
			}
			case DIALOG_GPS_BUSINESS:
			{
				if(response)
				{
					if(0 <= listitem <= MAX_BUSINESS_GPS-1)
					{
						new idx = GetPlayerListitemValue(playerid, listitem);
						new businessid = GetBusinessGPSInfo(idx, BG_BIZ_ID);

						if(GetBusinessGPSInfo(idx, BG_SQL_ID))
						{
							EnablePlayerGPS
							(
								playerid,
								56,
								GetBusinessData(businessid, B_POS_X),
								GetBusinessData(businessid, B_POS_Y),
								GetBusinessData(businessid, B_POS_Z),
								"Бизнес отмечен у Вас на GPS"
							);
						}
					else callcmd::gps(playerid, "");
					}
				}
					else callcmd::gps(playerid, "");
			}
			// -----------------------------------------------------------------
			case DIALOG_HELP:
			{
				if(response)
				{
					if(0 <= listitem <= sizeof help_info - 1)
						ShowPlayerHelpSection(playerid, listitem);
				}
					else DeletePVar(playerid, "help_section");
			}
			case DIALOG_HELP_SECTION:
			{
				new sectionid = GetPVarInt(playerid, "help_section");

				if(!response && sectionid < sizeof help_info - 1)
				{
					ShowPlayerHelpSection(playerid, sectionid + 1);
				}
					else callcmd::help(playerid, "");
			}
			// -----------------------------------------------------------------
			// -----------------------------------------------------------------

			// -----------------------------------------------------------------
			case DIALOG_ANIM_LIST:
			{
				if(response)
				{
					SetPVarInt(playerid, "anim_command_active", 1);
					if(!SetPlayerAnimation(playerid, listitem))
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"Информация",
							"Для быстрого запуска нужной анимации можно использовать {FFFFFF}/anim(list) [номер анимации из списка]",
							"Закрыть", ""
						);
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_OPEN_HOOD_OR_TRUNK:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				if(vehicleid)
				{
					new E_VEHICLE_PARAMS_STRUCT: param = response ? V_BONNET : V_BOOT;
					new set_status = GetVehicleParam(vehicleid, param) ^ VEHICLE_PARAM_ON;

					SetVehicleParam(vehicleid, param, set_status);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_DRIVING_TUTORIAL_START:
			{
				if(response)
					ShowDrivingTutorialSection(playerid, 0);
					SetPlayerPos(playerid,1644.394042,918.044799,1001.000000);
			}
			case DIALOG_DRIVING_TUTORIAL:
			{
				new step = GetPVarInt(playerid, "driving_tutorial_step");
				if(response)
				{
					step ++;
				}
					else step --;

				if(step >= sizeof driving_tutorial)
				{
					Dialog
					(
						playerid, DIALOG_DRIVING_TUTORIAL_END, DIALOG_STYLE_MSGBOX,
						"{0099FF}Завершение",
						"{FFFFFF}Надеемся вы все внимательно прочли и готовы приступить к сдаче экзамена\n"\
						"Если вы сомневаетесь в чем-либо, то рекомендуем не рисковать и прочитать нужный раздел еще раз!\n\n"\
						"{CC9900}Желаем Вам удачи на экзамене!\n"\
						"Для того, чтобы завершить обучение нажмите \"Выход\"",
						"Выход", "Назад"
					);
				}
					else if(step < 0)
				{
					ShowPlayerDrivingTutorial(playerid);
				}
					else
				{
					ShowDrivingTutorialSection(playerid, step);

					if(step == 1)
					{
						ShowNotificationNew(playerid, 2, 5, 0, 0, "Не попадайте в ДТП", "");
					}
				}
			}
			case DIALOG_DRIVING_TUTORIAL_END:
			{
				if(!response)
					ShowDrivingTutorialSection(playerid, sizeof driving_tutorial - 1);
			}
			case DIALOG_DRIVING_EXAM_INFO:
			{
				if(response)
				{
					if(GetPlayerData(playerid, P_DRIVING_LIC) < 1)
					{
						if(GetPlayerMoneyEx(playerid) >= 600)
						{
							GivePlayerMoneyEx(playerid, -600, "Сдача на права");

							Dialog
							(
								playerid, DIALOG_DRIVING_EXAM_START, DIALOG_STYLE_MSGBOX,
								"{CCCC00}Теоретическая часть",
								"{FFFFFF}Вам будет предложено 12 вопросов для проверки теоретических знаний\n"\
								"Чтобы сдать эту часть экзамена необходимо ответить минимум на 9 из них\n"\
								"Если правильных ответов будет меньше, то вы не будете допущены до практический части\n\n"\
								"{33CCFF}На каждый вопрос будет несколько вариантов ответа, правильный из который только один.\n"\
								"О результате вы узнаете когда ответите на все вопросы",
								"Далее", "Отмена"
							);
							ClearPlayerDrivingExamInfo(playerid);
						}
					else ShowNotificationNew(playerid, 2, 5, 0, 0, "Недостаточно средств | 600 руб.", "");
					}
					else ShowNotificationNew(playerid, 2, 5, 0, 0, "У вас есть права", "");
				}
			}
			case DIALOG_DRIVING_EXAM_START:
			{
				if(response)
				{
					SetPlayerDrivingExamInfo(playerid, DE_POINTS, 0);
					ShowPlayerDrivingExam(playerid, 0);
				}
			}
			case DIALOG_DRIVING_EXAM:
			{
				new step = GetPlayerDrivingExamInfo(playerid, DE_EXAM_STEP);

				if(driving_exam[step][DE_CORRECT_ANSWER] == (listitem + 1))
				{
					SetPlayerChatBubble(playerid, "+1", 0xFFFF00FF, 5.0, 2000);
					SetPlayerDrivingExamInfo(playerid, DE_POINTS, GetPlayerDrivingExamInfo(playerid, DE_POINTS) + 1);
				}
				ShowPlayerDrivingExam(playerid, step + 1);
			}
			case DIALOG_DRIVING_EXAM_RESULT:
			{
				if(GetPlayerDrivingExamInfo(playerid, DE_POINTS) >= 9)
				{
					Dialog
					(
						playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
						"{CCCC00}Практическая часть",
						"{FFFFFF}Отлично, теперь приступим к практической части\n"\
						"Вам нужно будет немного проехаться по городу на учебном авто\n"\
						"Найти его можно на стоянке слева от выхода\n\n"\
						"{FF9900}Внимание! Соблюдайте осторожность и не превышайте скорость\n"\
						"Если вы повредите автомобиль экзамен будет провален",
						"Начать", ""
					);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ATM:
			{
				if(response)
				{
					switch(listitem+1)
					{
						case 1,2: // Снять\Положить с банковского счета
						{
							ShowPlayerATMSelectSumDialog(playerid, !listitem);
						}
						case 3: // Баланс банковского счета
						{
							new fmt_str[64];
							format(fmt_str, sizeof fmt_str, "{FFFFFF}На Вашем банковском счету {%s}%d руб", GetPlayerBankMoney(playerid) > 0 ? ("00CC00") : ("FF6633"), GetPlayerBankMoney(playerid));

							Dialog
							(
								playerid, DIALOG_ATM_BALANCE, DIALOG_STYLE_MSGBOX,
								"{FFCD00}Баланс счета",
								fmt_str,
								"Назад", "Выйти"
							);
						}
						case 4: // Снять со счета предприятия
						{
							ShowPlayerATMCompanyDialog(playerid, true);
						}
						case 5: // Положить на счет предприятия
						{
							ShowPlayerATMCompanyDialog(playerid, false);
						}
						case 6: // Пополнить мобильный телефон
						{
							if(GetPlayerPhone(playerid) != 0)
							{
								Dialog
								(
									playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT,
									"{FFCD00}Пополнение мобильного телефона",
									"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
									"Готово", "Назад"
								);
							}
					else
							{
								SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");
								ShowPlayerATMDialog(playerid);
							}
						}
						case 7: // Безналичный перевод
						{
								Dialog
								(
									playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT,
									"{FFCD00}Безналичный перевод",
									"{FFFFFF}Укажите номер банковского счета:",
									"Далее", "Отмена"
								);
							
						}
						case 8:
						{
							Dialog
							(
								playerid, DIALOG_ATM_TICKET_SELECT, DIALOG_STYLE_LIST,
								"{FFCD00}Оплата штрафа",
								"1. Выбрать штраф из списка\n"\
								"2. Оплатить штраф по номеру",
								"Далее", "Отмена"
							);
						}
						case 9: // Благотворительность
						{
							ShowPlayerATMCharityDialog(playerid);
						}
						default:
							return 1;
					}
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_TAKE_MONEY: // снять деньги
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetPlayerBankMoney(playerid) >= sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + sum, GetPlayerBankMoney(playerid) - sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, -, sum);
								GivePlayerMoneyEx(playerid, sum, "Снятие денег с банкомата", false, true);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 08)");

							ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "На Вашем банковском счету недостаточно средств");
							ShowPlayerATMSelectSumDialog(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
					else
				{
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_TAKE_OTHER_MONEY: // снять деньги (другая сума)
			{
				if(response)
				{
					new take_sum = strval(inputtext);
					if(take_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerBankMoney(playerid) >= take_sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) + take_sum, GetPlayerBankMoney(playerid) - take_sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, -, take_sum);
								GivePlayerMoneyEx(playerid, take_sum, "Снятие денег с банкомата (другая сумма)", false, true);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 08)");

							ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "На Вашем банковском счету недостаточно средств");
							ShowPlayerATMSelectOtherSum(playerid, true);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, true);
				}
					else
				{
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, true);
				}
			}
			case DIALOG_ATM_PUT_MONEY: // положить деньги
			{
				if(response)
				{
					if(0 <= listitem <= 6)
					{
						new sum = atm_item_sum[listitem];
						if(GetPlayerMoneyEx(playerid) >= sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - sum, GetPlayerBankMoney(playerid) + sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, +, sum);
								GivePlayerMoneyEx(playerid, -sum, "Пополнение денег в банкомате", false, true);
								BlackPass_OnBankDeposit(playerid, sum);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 08)");

							ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "У Вас с собой нет столько денег");
							ShowPlayerATMSelectSumDialog(playerid, false);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
					else
				{
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_PUT_OTHER_MONEY: // положить деньги (другая сума)
			{
				if(response)
				{
					new put_sum = strval(inputtext);
					if(put_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= put_sum)
						{
							new query[85];
							format(query, sizeof query, "UPDATE accounts SET money=%d,bank=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - put_sum, GetPlayerBankMoney(playerid) + put_sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								AddPlayerData(playerid, P_BANK, +, put_sum);
								GivePlayerMoneyEx(playerid, -put_sum, "Пополнение денег в банкомате (другая сумма)", false, true);
								BlackPass_OnBankDeposit(playerid, put_sum);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 08)");

							ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
							ShowPlayerATMDialog(playerid);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "У Вас с собой нет столько денег");
							ShowPlayerATMSelectOtherSum(playerid, false);
						}
					}
					else ShowPlayerATMSelectOtherSum(playerid, false);
				}
					else
				{
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMSelectSumDialog(playerid, false);
				}
			}
			case DIALOG_ATM_BALANCE:
			{
				if(response)
				{
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					ShowPlayerATMDialog(playerid);
				}
			}
			case DIALOG_ATM_PHONE_BALANCE:
			{
				if(response)
				{
					new sum = strval(inputtext);
					if(sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= sum)
						{
							new query[128];

							format(query, sizeof query, "UPDATE accounts SET money=%d,phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-sum, GetPlayerData(playerid, P_PHONE_BALANCE)+sum, GetPlayerAccountID(playerid));
							mysql_query(mysql, query, false);

							if(!mysql_errno())
							{
								GivePlayerMoneyEx(playerid, -sum, "Пополнение счета телефона", false, true);
								AddPlayerData(playerid, P_PHONE_BALANCE, +, sum);

								format(query, sizeof query, "Вы пополнили счет мобильного телефона на {FF9900}%d руб", sum);
								SendClientMessage(playerid, 0x66CC00FF, query);

								format(query, sizeof query, "Сейчас на счету %d руб", GetPlayerData(playerid, P_PHONE_BALANCE));
								SendClientMessage(playerid, 0x66CC00FF, query);

								return 1;
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 15)");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас не хватает денег");

						ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}

					Dialog
					(
						playerid, DIALOG_ATM_PHONE_BALANCE, DIALOG_STYLE_INPUT,
						"{FFCD00}Пополнение мобильного телефона",
						"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
						"Готово", "Назад"
					);
				}
					else
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_SELECT_COMPANY_TAKE, DIALOG_ATM_SELECT_COMPANY_PUT:
			{
				if(response)
				{
					new bool: action = (dialogid == DIALOG_ATM_SELECT_COMPANY_TAKE);

					switch(listitem + 1)
					{
						case 1:
							ShowPlayerATMBusinessDialog(playerid, action);

						case 2:
							ShowPlayerATMFuelStationDialog(playerid, action);
					}
				}
					else
				{
					ShowPlayerATMDialog(playerid);
					ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
				}
			}
			case DIALOG_ATM_FUEL_ST_TAKE_MONEY:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetFuelStationData(stationid, FS_BALANCE) >= sum)
							{
								new query[128 + 1];

								format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)+sum, GetFuelStationData(stationid, FS_BALANCE)-sum, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									AddFuelStationData(stationid, FS_BALANCE, -, sum);
									GivePlayerMoneyEx(playerid, sum, "+ Снятие средств со счета АЗС", false, true);

									ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "На счету предприятия нет такой суммы");
						}
						ShowPlayerATMFuelStationDialog(playerid, true);
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_FUEL_ST_PUT_MONEY:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetPlayerMoneyEx(playerid) >= sum)
							{
								new query[128 + 1];

								format(query, sizeof query, "UPDATE accounts a, fuel_stations f SET a.money=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-sum, GetFuelStationData(stationid, FS_BALANCE)+sum, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									AddFuelStationData(stationid, FS_BALANCE, +, sum);
									GivePlayerMoneyEx(playerid, -sum, "Пополнение счета АЗС", false, true);

									ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас с собой нет столько денег");
						}
						ShowPlayerATMFuelStationDialog(playerid, false);
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_BIZ_TAKE_MONEY:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetBusinessData(businessid, B_BALANCE) >= sum)
							{
								new query[128 + 1];

								format(query, sizeof query, "UPDATE accounts a, business b SET a.money=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)+sum, GetBusinessData(businessid, B_BALANCE)-sum, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									AddBusinessData(businessid, B_BALANCE, -, sum);
									GivePlayerMoneyEx(playerid, sum, "+ Снятие средств со счета Бизнеса", false, true);

									ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);

									return 1;
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "На счету предприятия нет такой суммы");
						}
						ShowPlayerATMBusinessDialog(playerid, true);
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_BIZ_PUT_MONEY:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new sum = strval(inputtext);
						if(sum > 0 && IsNumeric(inputtext))
						{
							if(GetPlayerMoneyEx(playerid) >= sum)
							{
								new query[128 + 1];

								format(query, sizeof query, "UPDATE accounts a, business b SET a.money=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-sum, GetBusinessData(businessid, B_BALANCE)+sum, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									AddBusinessData(businessid, B_BALANCE, +, sum);
									GivePlayerMoneyEx(playerid, -sum, "Пополнение счета Бизнеса", false, true);

									ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
									ShowPlayerATMDialog(playerid);
									return 1;
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 18)");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас с собой нет столько денег");
						}
						ShowPlayerATMBusinessDialog(playerid, false);
					}
					else
					{
						ShowPlayerATMDialog(playerid);
						ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);
					}
				}
			}
			case DIALOG_ATM_TRANSFER_MONEY_1:
			{
				if(response)
				{
					new transfer_id = strval(inputtext);

					if(transfer_id > 0 && IsNumeric(inputtext))
					{
						SetPlayerBankTransfer(playerid, BT_ID, 0);

						new query[64 + 1];
						new Cache: result;

						format(query, sizeof query, "SELECT id FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
						result = mysql_query(mysql, query);

						if(cache_num_rows(result))
							SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0));

						cache_delete(result);

						if(GetPlayerBankTransfer(playerid, BT_ID))
						{
							return ShowPlayerATMTransfer(playerid);
						}
					else SendClientMessage(playerid, 0xFF6600FF, "Счета с таким номером не существует");
					}

					Dialog
					(
						playerid, DIALOG_ATM_TRANSFER_MONEY_1, DIALOG_STYLE_INPUT,
						"{FFCD00}Безналичный перевод",
						"{FFFFFF}Укажите номер банковского счета:",
						"Далее", "Отмена"
					);
				}
					else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TRANSFER_MONEY_2:
			{
				new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);
				if(response && transfer_id)
				{
					new transfer_sum = strval(inputtext);
					if(transfer_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerBankMoney(playerid) >= transfer_sum)
						{
							new fmt_str[155];

							format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.bank=%d,ba.balance=ba.balance + %d WHERE a.id=%d AND ba.id=%d", GetPlayerBankMoney(playerid)-transfer_sum, transfer_sum, GetPlayerAccountID(playerid), transfer_id);
							mysql_query(mysql, fmt_str, false);

							if(!mysql_errno())
							{
								format(fmt_str, sizeof fmt_str, "+ Пополнения с банкомата %d руб", transfer_sum);
								BankAccountLog(playerid, transfer_id, fmt_str);

								AddPlayerData(playerid, P_BANK, -, transfer_sum);
								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Откуда:\t\t\tОсновной счет\n"\
									"Куда:\t\t\t\tСчет №%d\n"\
									"Сумма:\t\t\t\t%d руб\n"\
									"Остаток на Вашем счету:\t%d руб",
									transfer_id,
									transfer_sum,
									GetPlayerBankMoney(playerid)
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{99FF00}Перевод завершен", fmt_str, "Закрыть", "");

								return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 11)");
						}
					else SendClientMessage(playerid, 0xFF6600FF, "На основном банковском счете недостаточно денег");
					}
					ShowPlayerATMTransfer(playerid);
				}
					else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TICKET_SELECT:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							new fmt_text[1024],
								query[90],
								Cache: result,
								rows;

							mysql_format(mysql, query, sizeof query, "SELECT * FROM tickets WHERE uid=%d AND status=0", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query, true);

							rows = cache_num_rows(result);

							ClearPlayerListitemValues(playerid);

							if(rows)
							{
								for(new idx; idx < rows; idx ++)
								{
									new reason[64];

									SetPlayerListitemValue(playerid, idx, cache_get_field_content_int(idx, "id"));

									cache_get_field_content(idx, "description", reason);

									format(query, sizeof query, "#%d\t%d руб.\t%s\n", cache_get_field_content_int(idx, "id"),
									cache_get_field_content_int(idx, "amount"), reason);

									strcat(fmt_text, query);
								}
							}
					else format(fmt_text, sizeof fmt_text, "У Вас нет неоплаченных штрафов");

							cache_delete(result);

							Dialog
							(
								playerid, DIALOG_ATM_TICKET_LIST, DIALOG_STYLE_LIST,
								"{FFCD00}Список штрафов",
								fmt_text,
								"Выбор", "Отмена"
							);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_ATM_TICKET_PAY, DIALOG_STYLE_INPUT,
								"{FFCD00}Оплата штрафа",
								"{FFFFFF}Введите номер штрафа, который\n"\
								"Вы хотели бы оплатить:",
								"Далее", "Отмена"
							);
						}
					}
				}
					else ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TICKET_LIST:
			{
				if(response)
				{
					new ticketid = GetPlayerListitemValue(playerid, listitem);

					if(ticketid) PayTicket(playerid, ticketid);
				}

				ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_TICKET_PAY:
			{
				if(response)
				{
					new ticketid = strval(inputtext);

					PayTicket(playerid, ticketid);
				}

				ShowPlayerATMDialog(playerid);
			}
			case DIALOG_ATM_CHARITY:
			{
				if(response)
				{
					new put_sum = strval(inputtext);
					if(put_sum > 0 && IsNumeric(inputtext))
					{
						if(GetPlayerMoneyEx(playerid) >= put_sum)
						{
							new fmt_str[85];
							format(fmt_str, sizeof fmt_str, "INSERT INTO charity (uid,money,time) VALUES (%d,%d,%d)", GetPlayerAccountID(playerid), put_sum, gettime());
							mysql_query(mysql, fmt_str, false);

							GivePlayerMoneyEx(playerid, -put_sum, "Благотворительность", true, true);

							format(fmt_str, sizeof fmt_str, "Вы сделали пожертвование в размере %d рублей", put_sum);
							SendClientMessage(playerid, 0x3399FFFF, fmt_str);

							UpdateCharity();
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег");
							ShowPlayerATMCharityDialog(playerid);
						}
					}
					else ShowPlayerATMCharityDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PAY_FOR_RENT:
			{
				if(response)
				{
					new buffer = -1;
					switch(listitem + 1)
					{
						case 1: // Заплатить за дом / квартиру
						{
							new accountid = GetPlayerAccountID(playerid);
							new property_count = GetPlayerPropertyCount(accountid);
							buffer = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);

							// Если новой недвижимости несколько, банк сначала дает выбрать
							// конкретный дом/квартиру. Так квартира больше не подменяется домом.
							if(property_count > 1)
							{
								SetPVarInt(playerid, "BANK_PROPERTY_PAY_SELECT", 1);
								ShowPlayerPropertySelectDialog(playerid);
								return 1;
							}

							if(buffer != -1 || property_count > 0)
							{
								ShowPlayerHousePayForRent(playerid);
								return 1;
							}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет дома или квартиры");
						}
						case 2: // Оплатить аренду бизнеса
						{
							buffer = GetPlayerBusiness(playerid);
							if(buffer != -1)
							{
								callcmd::paybizrent(playerid, "");
								return 1;
							}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса");
						}
						case 3: // Оплатить аренду АЗС
						{
							buffer = GetPlayerFuelStation(playerid);
							if(buffer != -1)
							{
								ShowPlayerFuelStationPayForRent(playerid);
								return 1;
							}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет заправки");
						}
						case 4: // Оплатить гараж
						{
							if(GarageSys_GetPlayerGarage(playerid) == -1)
								SendClientMessage(playerid, 0x999999FF, "У Вас нет гаража");
							else
								GarageSys_ShowPayRent(playerid);
							return 1;
						}
						case 5: // Возврат денег за имущество
						{
						    new fmt_text[640],
					        Cache: result,
					        id;

							mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM return_money WHERE uid='%d' AND status=0", GetPlayerAccountID(playerid));
						    result = mysql_query(mysql, fmt_text, true);

						    new rows = cache_num_rows(result);

						    if(!rows)
						        SendClientMessage(playerid, 0xCECECEFF, "У Вас нет денег которые Вам должны вернуть");

						    else
						    {

						        new query[60],
						            money,
						            description[64];

						        format(fmt_text, sizeof fmt_text, "");

						        for(new i = 0; i < rows; i ++)
						        {
						            id = cache_get_field_content_int(i, "id");
						            money = cache_get_field_content_int(i, "money");
						            cache_get_field_content(i, "description", description);

						            format(query, sizeof query, "{FFFFFF}%d.$ %d {32a44b}(%s)\n", i + 1, money, description);
						            strcat(fmt_text, query);

						            SetPlayerListitemValue(playerid, i, id);
						        }

						        Dialog
						        (
						            playerid, DIALOG_RETURN_MONEY, DIALOG_STYLE_LIST,
						            "Возврат денег",
						            fmt_text,
						            "Выбрать", "Закрыть"
						        );
						    }

						    return cache_delete(result);
						}
					}
					ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_FUEL_ST:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetFuelStationData(stationid, FS_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetFuelStationData(stationid, FS_IMPROVEMENTS) < 4 ? GetFuelStationData(stationid, FS_RENT_PRICE) : GetFuelStationData(stationid, FS_RENT_PRICE) / 2;

							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.bank=%d,f.rent_time=%d WHERE a.id=%d AND f.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetFuelStationData(stationid, FS_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду АЗС еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
					else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
					else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 30 дней");
						}
						ShowPlayerFuelStationPayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_BIZ_RENT_SELECT:
            {
                if(response)
                {
                    new businessid = strval(inputtext);
            
                    SetSelectedBusiness(playerid, businessid);
            
                    ShowPlayerBusinessPayForRent(playerid);
                }
            }
			case DIALOG_PAY_FOR_RENT_BIZ:
			{
				new businessid = GetSelectedBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetBusinessData(businessid, B_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = 5000;

							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.bank=%d,b.rent_time=%d WHERE a.id=%d AND b.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetBusinessData(businessid, B_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно продлили аренду бизнеса еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
					else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
					else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 30 дней");
						}
						callcmd::paybizrent(playerid, "");
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_PAY_FOR_RENT_HOUSE:
			{
				new hnew_pay_type = GetPVarInt(playerid, "hnew_pay_type");
				new hnew_pay_id = GetPVarInt(playerid, "hnew_pay_id");
				if(hnew_pay_type == 1 || hnew_pay_type == 2)
				{
					if(!response)
					{
						ClearPlayerNewPropertyPayContext(playerid);
						ShowPlayerPayForRentDialog(playerid);
						return 1;
					}

					new days = strval(inputtext);
					if(days > 0 && IsNumeric(inputtext))
					{
						new fmt_str[300];
						new accountid = GetPlayerAccountID(playerid);
						new rent_time, rent_price, rent_days, real_property_id, kv;

						if(hnew_pay_type == 1)
						{
							if(!(0 <= hnew_pay_id < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[hnew_pay_id] || gHouseOwnerID[hnew_pay_id] != accountid)
							{
								ClearPlayerNewPropertyPayContext(playerid);
								return SendClientMessage(playerid, 0xB5B500FF, "Дом не найден или уже не принадлежит вам");
							}
							rent_time = gHouseRentTime[hnew_pay_id];
							rent_price = GetNewHouseRentPrice(hnew_pay_id);
							real_property_id = hnew_pay_id;
							kv = 0;
						}
						else
						{
							if(!(0 <= hnew_pay_id < 200000) || !gFlatOwned[hnew_pay_id] || gFlatOwnerID[hnew_pay_id] != accountid)
							{
								ClearPlayerNewPropertyPayContext(playerid);
								return SendClientMessage(playerid, 0xB5B500FF, "Квартира не найдена или уже не принадлежит вам");
							}
							rent_time = gFlatRentTime[hnew_pay_id];
							rent_price = GetNewFlatRentPrice(hnew_pay_id);
							real_property_id = g_flat_real_id[hnew_pay_id];
							kv = 1;
						}

						if(rent_time < gettime()) rent_time = gettime();
						rent_days = GetNewPropertyRentDaysLeft(rent_time);

						new total_price = rent_price * days;
						if((rent_days + days) <= HNEW_MAX_RENT_DAYS)
						{
							if(GetPlayerBankMoney(playerid) >= total_price)
							{
								rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bought_houses h SET a.bank=%d,h.rent_time=%d WHERE a.id=%d AND h.house_id=%d AND IFNULL(h.kv,0)=%d AND h.account_id=%d", GetPlayerBankMoney(playerid) - total_price, rent_time, accountid, real_property_id, kv, accountid);
								new Cache:pay_result = mysql_query(mysql, fmt_str, true);
								new pay_error = mysql_errno(mysql);
								new pay_affected = 0;
								if(!pay_error) pay_affected = cache_affected_rows();
								cache_delete(pay_result);

								// В multi-table UPDATE должны реально обновиться и accounts, и bought_houses.
								// Если квартира/дом не найдены по точному kv/id, деньги в памяти не списываем.
								if(!pay_error && pay_affected >= 2)
								{
									AddPlayerData(playerid, P_BANK, -, total_price);
									if(hnew_pay_type == 1) gHouseRentTime[hnew_pay_id] = rent_time;
									else gFlatRentTime[hnew_pay_id] = rent_time;

									format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
									SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

									format(fmt_str, sizeof fmt_str, "Вы оплатили налог на {3399FF}%d дней", days);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
								}
								else
								{
									printf("[BANK_PROPERTY] Pay failed player=%d account=%d type=%d id=%d real_id=%d kv=%d errno=%d affected=%d", playerid, accountid, hnew_pay_type, hnew_pay_id, real_property_id, kv, pay_error, pay_affected);
									SendClientMessage(playerid, 0xB5B500FF, "Не удалось подтвердить оплату недвижимости в базе. Деньги не списаны.");
								}
							}
							else
							{
								SendClientMessage(playerid, 0xB5B500FF, "На банковском счете недостаточно денег для оплаты");

								format(fmt_str, sizeof fmt_str, "Для оплаты налога на %d дней необходимо %d руб", days, total_price);
								SendClientMessage(playerid, 0x999999FF, fmt_str);
							}
						}
						else SendClientMessage(playerid, 0xB5B500FF, "Нельзя оплатить налог больше чем на 30 дней");
					}
					ShowPlayerHousePayForRent(playerid);
					return 1;
				}

				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetHouseData(houseid, H_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new rent_price = GetHouseData(houseid, H_IMPROVEMENTS) < 4 ? GetHouseData(houseid, H_RENT_PRICE) : GetHouseData(houseid, H_RENT_PRICE) / 2;

							new total_price = rent_price * days;
							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a,houses h SET a.bank=%d,h.rent_time=%d WHERE a.id=%d AND h.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetHouseData(houseid, H_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно оплатили дом еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
					else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
					else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 30 дней");
						}
						ShowPlayerHousePayForRent(playerid);
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
			}
			case DIALOG_RETURN_MONEY:
            {
                if(response)
                {
                    new idx = GetPlayerListitemValue(playerid, listitem);

                    new fmt_text[640],
                        Cache: result;

                    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM return_money WHERE id='%d'", idx);
                    result = mysql_query(mysql, fmt_text, true);

                    new rows = cache_num_rows(result);

                    if(!rows)
                        SendClientMessage(playerid, 0xCECECEFF, "У Вас нет денег которые Вам должны вернуть");

					else
                    {

                        new query[60],
                            money,
                            description[64];

                        money = cache_get_field_content_int(0, "money");
                        cache_get_field_content(0, "description", description);

                        format(query, sizeof query, "Вам было возвращено {FFFFFF}$%d (%s)", money, description);
                        SendClientMessage(playerid, 0x32a44bFF, query);

                        GivePlayerMoneyEx(playerid, money, "возврат денег", true, true);

                        mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE return_money SET status=1 WHERE id='%d'", idx);
                        result = mysql_query(mysql, fmt_text, true);
                    }

                    cache_delete(result);
                }
            }
			// -----------------------------------------------------------------
			case DIALOG_BANK:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							ShowPlayerBankAccounts(playerid);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_BANK_CREATE_ACCOUNT, DIALOG_STYLE_INPUT,
								"{FFCD00}Создание нового счета",
								"{FFFFFF}Введите название для нового счета.\n"\
								"Максимальная длина 20 символов:",
								"Ок", "Отмена"
							);
						}
						case 3:
						{
							if(GetPlayerBusiness(playerid) != -1)
							{
								callcmd::paybizrent(playerid, "");
							}
							else SendClientMessage(playerid, 0x999999FF, "У Вас нет бизнеса");
						}
					}
				}
			}
			case DIALOG_BANK_ACCOUNTS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: ShowPlayerATMDialog(playerid);
						case 1..(MAX_BANK_ACCOUNTS):
						{
							new accountid = GetPlayerListitemValue(playerid, listitem - 1);
							if(IsValidBankAccount(playerid, accountid))
							{
								SetPlayerUseListitem(playerid, accountid);
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_LOGIN, DIALOG_STYLE_PASSWORD,
									"{FFCD00}Авторизация",
									"{FFFFFF}Введите PIN-код счета:",
									"Ввести", "Отмена"
								);
							}
						}
					}
				}
					else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_LOGIN:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);
						new pin_len = strlen(GetBankAccountData(playerid, accountid, BA_PIN_CODE));
						if(!strcmp(GetBankAccountData(playerid, accountid, BA_PIN_CODE), inputtext, false) && pin_len && len)
						{
							ShowPlayerBankAccountOperation(playerid);
						}
					else
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF9900}Ошибка",
								"{FFFFFF}Вы допустили ошибку при вводе PIN-кода",
								"Закрыть", ""
							);
						}
					}
				}
			}
			case DIALOG_BANK_ACCOUNT_OPERATION:
			{
				if(response)
				{
					new accountid = GetPlayerUseListitem(playerid);
					if(IsValidBankAccount(playerid, accountid))
					{
						switch(listitem + 1)
						{
							case 1: // Информация о счете
							{
								UpdateBankAccountData(playerid, accountid);

								new fmt_str[128];
								format
								(
									fmt_str, sizeof fmt_str,
									"{ffff00}|{FFFFFF}Номер счета:{ffff00}\t\t%d\n"\
									"{ffff00}|{FFFFFF}Наименование счета:{ffff00}\t\"%s\"\n"\
									"{ffff00}|{FFFFFF}Состояние счета:{ffff00}%d руб.",
									GetBankAccountData(playerid, accountid, BA_ID),
									GetBankAccountData(playerid, accountid, BA_NAME),
									GetBankAccountData(playerid, accountid, BA_BALANCE)
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Информация", fmt_str, "Назад", "");
							}
							case 2: // История операций
							{
								ShowPlayerBankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID));
							}
							case 3: // Снять деньги
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
									"{FFCD00}Снять деньги",
									"{FFFFFF}Укажите сумму:",
									"Снять", "Отмена"
								);
							}
							case 4: // Положить деньги
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
									"{FFCD00}Положить деньги",
									"{FFFFFF}Укажите сумму:",
									"Положить", "Отмена"
								);
							}
							case 5: // Перевести на другой счет
							{
								/*if(!PlayerTotalOnline(playerid, 24))
									return SendClientMessage(playerid, 0x999999FF, "Для перевода денег необходимо отыграть 24 часа");*/

								if(GetPlayerLevel(playerid) >= 2)
								{
									Dialog
									(
										playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
										"{FFCD00}Перевод средств",
										"{FFFFFF}Укажите номер счета, на который\n"\
										"хотите осуществить перевод:",
										"Далее", "Отмена"
									);
								}
					else SendClientMessage(playerid, 0x999999FF, "Перевод денег доступен только со 2 уровня");
							}
							case 6: // Переименовать счет
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
									"{FFCD00}Переименование счета",
									"{FFFFFF}Введите новое название для этого счета.\n"\
									"Максимальная длина 20 символов:",
									"Ок", "Отмена"
								);
							}
							case 7: // Изменить PIN-код
							{
								Dialog
								(
									playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
									"{FFCD00}Изменение PIN-кода",
									"{FFFFFF}Введите новый PIN-код.\n"\
									"Длина от 4 до 8 цифр:",
									"Ок", "Отмена"
								);
							}
						}
					}
				}
					else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_ACCOUNT_INFO:
			{
				ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TAKE_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new take_sum = strval(inputtext);
						if (take_sum > 10000000){
								SendClientMessage(playerid, 0xFF6600FF, "Вы можете снять до 10,000,000 рублей за раз. ");
							}
						if(take_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);

							new fmt_str[155];
							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);

							if(balance >= take_sum)
							{

								format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.money=%d,ba.balance=ba.balance - %d WHERE a.id=%d AND ba.id=%d", GetPlayerMoneyEx(playerid)+take_sum, take_sum, GetPlayerAccountID(playerid), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, take_sum, "Снятие с банк. счета (банк)", false, true);
									SetBankAccountData(playerid, accountid, BA_BALANCE, balance - take_sum);

									format(fmt_str, sizeof fmt_str, "- Снятие наличных %d руб", take_sum);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
									format(fmt_str, sizeof fmt_str, "{22a322}Вы сняли из банковского счета: %d руб.", take_sum);
									SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет:\t\t№%d\n"\
										"Вы сняли:\t{FF9900}%d руб\n"\
										"{FFFFFF}Остаток:\t%d руб",
										GetBankAccountData(playerid, accountid, BA_ID),
										take_sum,
										GetBankAccountData(playerid, accountid, BA_BALANCE)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Операция завершена успешно", fmt_str, "Вернуться", "");
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
							}
					else
							{
								format(fmt_str, sizeof fmt_str, "Недостаточно средств. Текущий баланс счета №%d: {009966}%d руб", GetBankAccountData(playerid, accountid, BA_ID), balance);
								SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
							}
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TAKE_MONEY, DIALOG_STYLE_INPUT,
							"{FFCD00}Снять деньги",
							"{FFFFFF}Укажите сумму:",
							"Снять", "Отмена"
						);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_PUT_MONEY:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new put_sum = strval(inputtext);
						if(put_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);

							new fmt_str[155];
							new money = GetPlayerMoneyEx(playerid);
							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							if (put_sum > 10000000){
								SendClientMessage(playerid, 0xFF6600FF, "Вы можете положить до 10,000,000 рублей за раз. ");
							}
							if(money >= put_sum)
							{
								format(fmt_str, sizeof fmt_str, "UPDATE accounts a,bank_accounts ba SET a.money=%d,ba.balance=ba.balance + %d WHERE a.id=%d AND ba.id=%d", money-put_sum, put_sum, GetPlayerAccountID(playerid), GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -put_sum, "Пополнение банк. счета (банк)", false, true);
									BlackPass_OnBankDeposit(playerid, put_sum);
									SetBankAccountData(playerid, accountid, BA_BALANCE, balance + put_sum);

									format(fmt_str, sizeof fmt_str, "+ Пополнение на сумму %d руб", put_sum);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);
									format(fmt_str, sizeof fmt_str, "{22a322}Вы положили на банковский счет %d руб.", put_sum);
									SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет:\t\t\t№%d\n"\
										"Вы положили:\t{00CC00}%d руб\n"\
										"{FFFFFF}Итоговый баланс:\t%d руб",
										GetBankAccountData(playerid, accountid, BA_ID),
										put_sum,
										GetBankAccountData(playerid, accountid, BA_BALANCE)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Операция завершена успешно", fmt_str, "Вернуться", "");
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 09)");
							}
					else SendClientMessage(playerid, 0xFFFFFFFF, "Недостаточно средств");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_PUT_MONEY, DIALOG_STYLE_INPUT,
							"{FFCD00}Положить деньги",
							"{FFFFFF}Укажите сумму:",
							"Положить", "Отмена"
						);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_1:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_id = strval(inputtext);
						if(transfer_id > 0 && IsNumeric(inputtext))
						{
							new fmt_str[64 + 1];
							new Cache: result;
							new rows;

							format(fmt_str, sizeof fmt_str, "SELECT id,name FROM bank_accounts WHERE id=%d LIMIT 1", transfer_id);
							result = mysql_query(mysql, fmt_str);

							if((rows = cache_num_rows(result)))
							{
								SetPlayerBankTransfer(playerid, BT_ID, cache_get_row_int(0, 0));
								cache_get_row(0, 1, g_player_bank_transfer[playerid][BT_NAME], mysql, 21);
							}
							cache_delete(result);

							if(rows)
							{
								return ShowPlayerBankAccountTransfer(playerid, accountid);
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Счета с таким номером не существует");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_TRANSFER_1, DIALOG_STYLE_INPUT,
							"{FFCD00}Перевод средств",
							"{FFFFFF}Укажите номер счета, на который\n"\
							"хотите осуществить перевод:",
							"Далее", "Отмена"
						);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_TRANSFER_2:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new transfer_sum = strval(inputtext);
						new transfer_id = GetPlayerBankTransfer(playerid, BT_ID);

						if(transfer_sum > 0 && IsNumeric(inputtext))
						{
							UpdateBankAccountData(playerid, accountid);

							new balance = GetBankAccountData(playerid, accountid, BA_BALANCE);
							if(balance >= transfer_sum)
							{
								new fmt_str[160];

								if(GetBankAccountData(playerid, accountid, BA_ID) != transfer_id)
								{
									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=balance-%d WHERE id=%d LIMIT 1", transfer_sum, GetBankAccountData(playerid, accountid, BA_ID));
									mysql_query(mysql, fmt_str, false);

									format(fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET balance=balance+%d WHERE id=%d LIMIT 1", transfer_sum, transfer_id);
									mysql_query(mysql, fmt_str, false);

									SetBankAccountData(playerid, accountid, BA_BALANCE, balance - transfer_sum);
								}
								format(fmt_str, sizeof fmt_str, "- Перевод %d руб на счет №%d", transfer_sum, transfer_id);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

								format(fmt_str, sizeof fmt_str, "+ Перевод %d руб со счета №%d", transfer_sum, GetBankAccountData(playerid, accountid, BA_ID));
								BankAccountLog(playerid, transfer_id, fmt_str);

								SetPlayerBankTransfer(playerid, BT_ID, 0);

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Со счета:\t\t\t№%d\n"\
									"На счет:\t\t\t№%d\n"\
									"Cумма перевода:\t\t{FF9900}%d руб\n"\
									"{FFFFFF}Остаток на Вашем счете:\t{00CC66}%d руб",
									GetBankAccountData(playerid, accountid, BA_ID),
									transfer_id,
									transfer_sum,
									GetBankAccountData(playerid, accountid, BA_BALANCE)
								);
								Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{3399FF}Перевод успешно выполнен", fmt_str, "Вернуться", "");
							}
					else
							{
								SendClientMessage(playerid, 0xFF6600FF, "На счету недостаточно средств для перевода");
								ShowPlayerBankAccountTransfer(playerid, accountid);
							}
						}
					else ShowPlayerBankAccountTransfer(playerid, accountid);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_NAME:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);

						if(3 <= len <= 20)
						{
							if(!IsABadBankAccountName(inputtext))
							{
								new fmt_str[128];

								mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									format(g_bank_account[playerid][accountid][BA_NAME], 21, "%s", inputtext);

									format(fmt_str, sizeof fmt_str, "* Переименование счета на \"%s\"", inputtext);
									BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), fmt_str);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Счет успешно переименован.\n"\
										"Теперь он будет доступен под названием \"%s\"",
										GetBankAccountData(playerid, accountid, BA_NAME)
									);
									return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Завершение", fmt_str, "Вернуться", "");
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 10)");
							}
					else
							{
								SendClientMessage(playerid, 0xFF6600FF, "Недопустимые символы в новом названии");
								SendClientMessage(playerid, 0xFF6600FF, "Можно использовать {FFCC15}русские {FF6600}и {FFCC15}английские {FF6600}буквы, а также {FFCC15}цифры");
							}
						}
					else SendClientMessage(playerid, 0xFF6600FF, "Длина названия счета может быть от {FFCC15}3 до 20 {FF6600}символов");

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_NAME, DIALOG_STYLE_INPUT,
							"{FFCD00}Переименование счета",
							"{FFFFFF}Введите новое название для этого счета.\n"\
							"Максимальная длина 20 символов:",
							"Ок", "Отмена"
						);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_ACCOUNT_CHANGE_PIN:
			{
				new accountid = GetPlayerUseListitem(playerid);
				if(response)
				{
					if(IsValidBankAccount(playerid, accountid))
					{
						new len = strlen(inputtext);

						if(4 <= len <= 8 && IsNumeric(inputtext))
						{
							new fmt_str[128];

							mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE bank_accounts SET pin='%e' WHERE id=%d LIMIT 1", inputtext, GetBankAccountData(playerid, accountid, BA_ID));
							mysql_query(mysql, fmt_str, false);

							if(!mysql_errno())
							{
								format(g_bank_account[playerid][accountid][BA_PIN_CODE], 9, "%s", inputtext);
								BankAccountLog(playerid, GetBankAccountData(playerid, accountid, BA_ID), "* Изменение PIN-кода");

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}PIN-код успешно изменен.\n"\
									"Рекомендуем сделать скрин (F8) чтобы не забыть его: {CCFF00}%s",
									GetBankAccountData(playerid, accountid, BA_PIN_CODE)
								);
								return Dialog(playerid, DIALOG_BANK_ACCOUNT_INFO, DIALOG_STYLE_MSGBOX, "{FFCD00}Изменение PIN", fmt_str, "Вернуться", "");
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 10)");
						}

						Dialog
						(
							playerid, DIALOG_BANK_ACCOUNT_CHANGE_PIN, DIALOG_STYLE_INPUT,
							"{FFCD00}Изменение PIN-кода",
							"{FFFFFF}Введите новый PIN-код.\n"\
							"Длина от 4 до 8 цифр:",
							"Ок", "Отмена"
						);
					}
				}
					else ShowPlayerBankAccountOperation(playerid);
			}
			case DIALOG_BANK_CREATE_ACCOUNT:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(3 <= len <= 20)
					{
						if(!IsABadBankAccountName(inputtext))
						{
							new query[128];
							new Cache: result;
							new total_accounts;

							format(query, sizeof query, "SELECT COUNT(*) FROM bank_accounts WHERE uid=%d", GetPlayerAccountID(playerid));
							result = mysql_query(mysql, query);

							total_accounts = cache_get_row_int(0, 0);
							cache_delete(result);

							if(total_accounts < MAX_BANK_ACCOUNTS)
							{
								mysql_format(mysql, query, sizeof query, "INSERT INTO bank_accounts (uid,name,reg_time) VALUES (%d,'%e',%d)", GetPlayerAccountID(playerid), inputtext, gettime());
								mysql_query(mysql, query, false);

								if(!mysql_errno())
								{
									Dialog
									(
										playerid, DIALOG_BANK_CREATED_ACCOUNT, DIALOG_STYLE_MSGBOX,
										"{FFCD00}Счет создан",
										"{FFFFFF}Вы создали новый счет в банке.\n\n"\
						"Для доступа к нему используйте PIN-код {00FF66}0000{FFFFFF}. После входа\n"\
						"настоятельно рекомендуем изменить его на более сложный.\n"\
						"Это поможет защитить счет от несанкционированного доступа.",
						"Готово", ""
					);
				}
			}
			else Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FFCD00}Лимит счетов", "{FFFFFF}Можно создать не более пяти банковских счетов", "Ок", "");
						}
					else
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{FF3300}Ошибка",
								"{FFFFFF}Операция запрещена. Недопустимые символы в названии счета\n"\
								"Можно использовать {FFCC15}русские {FFFFFF}и {FFCC15}английские {FFFFFF}буквы, а также {FFCC15}цифры",
								"Выход", ""
							);
						}
					}
					else
					{
						Dialog
						(
							playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
							"{FF3300}Ошибка",
							"{FFFFFF}Длина названия счета может быть от {FFCC15}3 до 20 {FFFFFF}символов",
							"Закрыть", ""
						);
					}
				}
					else ShowPlayerBankDialog(playerid);
			}
			case DIALOG_BANK_CREATED_ACCOUNT:
			{
				ShowPlayerBankDialog(playerid);
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_CALL:
			{
				if(response)
				{
					new number = strval(inputtext);

					if(number >= 0 && strlen(inputtext))
					{
						new params[16];
						valstr(params, number);

						callcmd::call(playerid, params);
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Ошибка набора");
				}
			}
			case DIALOG_PHONE_CALL_BALANCE:
			{
				SetPlayerPhoneUseState(playerid, false);
			}
			// -----------------------------------------------------------------
			case DIALOG_ACTION:
			{
				if(response)
				{
					if(1 <= (listitem+1) <= 4)
					{
						new targetid = GetPlayerData(playerid, P_TARGET_ID);

						if(IsPlayerConnected(targetid) && IsPlayerLogged(targetid))
						{
							if(IsPlayerInRangeOfPlayer(playerid, targetid, 10.0))
							{
								new params[5];
								valstr(params, targetid);

								new cmd[4][16] = {"cmd_hi", "cmd_pass", "cmd_lic", "cmd_skill"};
								CallLocalFunction(cmd[listitem], "ds", playerid, params);
							}
					else SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
						}
					else SendClientMessage(playerid, 0x999999FF, "Игрок вышел из игры");
					}
					SetPlayerData(playerid, P_TARGET_ID, INVALID_PLAYER_ID);
				}
			}
			// -----------------------------------------------------------------
            case DIALOG_VIEV_JOBS_LIST:
            {
                if(response) SendClientMessage(playerid, 0x999999FF, "Сейчас нет доступных вакансий");
            }
            case DIALOG_END_JOB:
            {
                if(response) EndPlayerJob(playerid);
            }
            case DIALOG_BUS_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					//if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					//{
						if(GetPlayerMoneyEx(playerid) >= 180)
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда автобуса", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							buses[playerid] = AddStaticVehicleEx(414, -133.871093,938.719665,11.914908,62.030265, 6, 1, -1, 0, VEHICLE_ACTION_TYPE_BUS_DRIVER);
							PutPlayerInVehicle(playerid, buses[playerid], 0);
							Dialog
										(
											playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT,
											"{FFCD00}Стоимость проезда",
											"{FFFFFF}Сколько будет стоить проезд?\n"\
											"Укажите цену от 0 до 100 рублей",
											"Далее", "Отмена"
										);
							//return SendClientMessage(playerid, 0x66CC00FF, "Для того, чтобы начать работу водителя автобуса {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заключить договор аренды");
					}
				//}
				//RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_BUS_ROUTE_COST:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new route_cost = strval(inputtext);

						if(0 <= route_cost <= 100 && IsNumeric(inputtext))
						{
							SetPlayerData(playerid, P_JOB_TARIFF, route_cost);

							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_SELECTION, DIALOG_STYLE_LIST,
								"{FFCD00}Выберите маршрут",
								g_bus_routes_list,
								"Ок", "Отмена"
							);
						}
					else
						{
							Dialog
							(
								playerid, DIALOG_BUS_ROUTE_COST, DIALOG_STYLE_INPUT,
								"{FFCD00}Стоимость проезда",
								"{FFFFFF}Сколько будет стоить проезд?\n"\
								"Укажите цену от 0 до 100 рублей",
								"Далее", "Отмена"
							);
						}
					}
				}
			}
			case DIALOG_BUS_ROUTE_SELECTION:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_BUS_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(0 <= listitem <= sizeof g_bus_routes - 1)
						{
							SetPlayerData(playerid, P_BUS_ROUTE_STEP, 0);
							SetPlayerData(playerid, P_BUS_ROUTE, listitem);

							StartPlayerJob(playerid, JOB_BUS_DRIVER);
						}
					}
				}
			}
			case DIALOG_TAXI_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetPlayerMoneyEx(playerid) >= 200)
						{
							GivePlayerMoneyEx(playerid, -200, "Аренда такси", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "Для того, чтобы начать работу таксиста {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_TAXI_NAME:
			{
				if(response)
				{
					if(!(1 <= strlen(inputtext) <= 15))
					{
						Dialog
						(
							playerid, DIALOG_TAXI_NAME, DIALOG_STYLE_INPUT,
							"{FFCD00}Название такси",
							"{FFFFFF}Придумайте название для вашего такси\n"\
							"Максимальная длина 15 символов\n\n"\
							"Если вы не хотите как-то называться\n"\
							"нажмите кнопку \"Пропустить\"",
							"Далее", "Пропустить"
						);
						return 1;
					}
					else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
				}
					else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;

				Dialog
				(
					playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT,
					"{FFCD00}Настройка счетчика",
					"{FFFFFF}Укажите тариф по которому будет работать ваше такси\n"\
					"Эта сумма будет сниматься с пассажира каждые 100 м поездки\n"\
					"Тарифная ставка может быть от 0 до 200 рублей",
					"Ок", "Отмена"
				);
			}
			case DIALOG_TAXI_TARIFF:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_TAXI_DRIVER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						new tariff = strval(inputtext);

						if(!(0 <= tariff <= 200) || !IsNumeric(inputtext))
						{
							Dialog
							(
								playerid, DIALOG_TAXI_TARIFF, DIALOG_STYLE_INPUT,
								"{FFCD00}Настройка счетчика",
								"{FFFFFF}Укажите тариф по которому будет работать ваше такси\n"\
								"Эта сумма будет сниматься с пассажира каждые 100 м поездки\n"\
								"Тарифная ставка может быть от 0 до 200 рублей",
								"Ок", "Отмена"
							);
							return 1;
						}
					else
						{
							SetPlayerData(playerid, P_JOB_TARIFF, tariff);
							StartPlayerJob(playerid, 6);
						}
					}
				}
				g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;
			}
			case DIALOG_UNUSED_LEGACY_6:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

						if(GetPlayerMoneyEx(playerid) >= 180)
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда эвакуатора", true, true);
							mexs[playerid] = CreateVehicle(525,1856.6643,-110.4669,15.5701,205.9911,1,1, -1, 0, VEHICLE_ACTION_TYPE_UNUSED_1); // Iaoaieee 1
							
							Dialog
								(
									playerid, DIALOG_UNUSED_LEGACY_8, DIALOG_STYLE_INPUT,
									"{FFCD00}Автомеханик",
									"{FFFFFF}Введите название для Вашей техслужбы,\n"\
									"или оставьте поле пустым",
									"Готово", "Отмена"
								);
							PutPlayerInVehicle(playerid, mexs[playerid], 0);
							//return 1;//SendClientMessage(playerid, 0x66CC00FF, "Для того, чтобы начать работу автомеханика {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заключить договор аренды");
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_UNUSED_LEGACY_7:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_UNUSED_1 && action_id == VEHICLE_ACTION_ID_NONE)
					{
						Dialog
						(
							playerid, DIALOG_UNUSED_LEGACY_8, DIALOG_STYLE_INPUT,
							"{FFCD00}Автомеханик",
							"{FFFFFF}Введите название для Вашей техслужбы,\n"\
							"или оставьте поле пустым",
							"Готово", "Отмена"
						);
					}
				}
			}
			case DIALOG_UNUSED_LEGACY_8:
			{
				if(response)
				{
					new len = strlen(inputtext);

					if(len)
					{
						if(!(1 <= len <= 15))
						{
							Dialog
							(
								playerid, DIALOG_UNUSED_LEGACY_8, DIALOG_STYLE_INPUT,
								"{FFCD00}Автомеханик",
								"{FFFFFF}Введите название для Вашей техслужбы,\n"\
								"или оставьте поле пустым",
								"Готово", "Отмена"
							);
							return SendClientMessage(playerid, 0xCECECEFF, "Слишком длинное название | 15 символов максимум");
						}
					else format(g_player[playerid][P_JOB_SERVICE_NAME], 17, "%s\n", inputtext);
					}
					else g_player[playerid][P_JOB_SERVICE_NAME][0] = 0;

					StartPlayerJob(playerid, JOB_UNUSED_3);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_TRUCKER_RENT_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerVehicleID(playerid);

					new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
					new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

					if(action_type == VEHICLE_ACTION_TYPE_TRUCKER && action_id == VEHICLE_ACTION_ID_NONE)
					{
						if(GetPlayerMoneyEx(playerid) >= 180)
						{
							GivePlayerMoneyEx(playerid, -180, "Аренда грузовика", true, true);
							//SetVehicleData(vehicleid, V_ACTION_ID, true);

							SetPlayerData(playerid, P_JOB_CAR, vehicleid);
							return SendClientMessage(playerid, 0x66CC00FF, "Для того, чтобы начать работу дальнобойщика {FF9900}нажмите ~k~~TOGGLE_SUBMISSIONS~");
						}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы заключить договор аренды");
					}
				}
				RemovePlayerFromVehicle(playerid);
			}
			case DIALOG_TRUCKER_START_JOB:
			{
				if(response)
				{
					StartPlayerJob(playerid, JOB_TRUCKER);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_PHONE_BOOK:
			{
				if(response && (0 <= listitem <= MAX_PHONE_BOOK_CONTACTS-1))
				{
					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS, listitem);
				}
			}
			case DIALOG_PHONE_BOOK_OPTION:
			{
				new contactid = GetPlayerPhoneBookSelectContact(playerid);
				if(contactid != INVALID_PLAYER_ID)
				{
					if(response)
					{
						ShowPhoneBookOperation(playerid, listitem + 1, contactid);
					}
					else ShowPlayerPhoneBook(playerid);
				}
			}
			case DIALOG_PHONE_BOOK_SEND_SMS:
			{
				if(response)
				{
					new len = strlen(inputtext);
					if(len)
					{
						if(len < 65)
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							new fmt_str[90];

							format(fmt_str, sizeof fmt_str, "%s %s", GetPlayerPhoneBook(playerid, contactid, PB_NUMBER), inputtext);
							callcmd::sms(playerid, fmt_str);
							return 1;
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Слишком длинное сообщение");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Введите сообщение для отправки");

					ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_SEND_SMS);
				}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NAME:
			{
				if(response)
				{
					if(3 <= strlen(inputtext) <= 20)
					{
						new contactid = GetPlayerPhoneBookSelectContact(playerid);
						new query[90];

						format(g_player_phone_book[playerid][contactid][PB_NAME], 21, "%s", inputtext);

						mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET name='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
						mysql_query(mysql, query, false);

						SendClientMessage(playerid, 0x99CC33FF, "Имя контакта изменено");
						ShowPlayerPhoneBook(playerid);
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NAM);
				}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_CHANGE_NUMBER:
			{
				if(response)
				{
					if(3 <= strlen(inputtext) <= 9 && strval(inputtext) > 0 && IsNumeric(inputtext))
					{
						if(!CheckPhoneBookUsedNumber(playerid, inputtext))
						{
							new contactid = GetPlayerPhoneBookSelectContact(playerid);
							new query[90];

							format(g_player_phone_book[playerid][contactid][PB_NUMBER], 10, "%s", inputtext);

							mysql_format(mysql, query, sizeof query, "UPDATE phone_books SET number='%e' WHERE id=%d LIMIT 1", inputtext, GetPlayerPhoneBook(playerid, contactid, PB_SQL_ID));
							mysql_query(mysql, query, false);

							SendClientMessage(playerid, 0x99CC33FF, "Номер контакта изменен");
							ShowPlayerPhoneBook(playerid);
						}
					}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_CHANGE_NUM);
				}
					else ShowPhoneBookOperation(playerid, PHONE_BOOK_OPERATION_OPTIONS);
			}
			case DIALOG_PHONE_BOOK_ADD_CONTACT:
			{
				if(response)
				{
					new player_name[20 + 1];
					GetPVarString(playerid, "add_contact_name", player_name, sizeof(player_name));

					if(!(3 <= strlen(inputtext) <= 9) || strval(inputtext) < 1 || !IsNumeric(inputtext))
					{
						new fmt_str[64 + 1];

						format(fmt_str, sizeof fmt_str, "{FFFFFF}Введите номер телефона для контакта %s", player_name);
						Dialog(playerid, DIALOG_PHONE_BOOK_ADD_CONTACT, DIALOG_STYLE_INPUT, "{FFCD00}Добавление нового контакта", fmt_str, "Добавить", "Отмена");

						return 1;
					}
					AddPhoneBookContact(playerid, player_name, inputtext);
				}
				DeletePVar(playerid, "add_contact_name");
			}
			// -----------------------------------------------------------------
			case DIALOG_MINER_BUY_METALL:
			{
				if(response)
				{
					new count = strval(inputtext);
					new metall = GetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT);

					if(IsNumeric(inputtext))
					{
						if(metall >= count)
						{
							if(1 <= count <= 50)
							{
								if((GetPlayerData(playerid, P_METALL) + count) <= 20)
								{
									new sum = count * 15;
									if(GetPlayerMoneyEx(playerid) >= sum)
									{
										new fmt_str[80];

										format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d,metall=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-sum, GetPlayerData(playerid, P_METALL) + count, GetPlayerAccountID(playerid));
										mysql_query(mysql, fmt_str, false);

										if(!mysql_errno())
										{
											SetRepositoryData(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL, R_AMOUNT, metall - count);
											UpdateRepository(REPOSITORY_TYPE_MINER, REPOSITORY_ACTION_MINER_METAL);

											AddPlayerData(playerid, P_METALL, +, count);

											format(fmt_str, sizeof fmt_str, "Вы купили %d кг за %d рублей", count, count * 15);
											SendClientMessage(playerid, 0x3399FFFF, fmt_str);

											return GivePlayerMoneyEx(playerid, -sum, "Покупка Материалыа на шахте", false, true);
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 12)");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег для покупки такого количества Материалыа");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы не можете носить с собой более 20 кг Материалыа");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Можно купить от 1 до 50 кг Материалыа");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "На складе шахты нет такого количества Материалыа");
					}
					ShowPlayerBuyMetalDialog(playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_TEMP_JOB_LOADER_START:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						//TogglePlayerDynamicCP(playerid, help_info_CP, false);

						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_LOADER, TJ_SKIN)[GetPlayerSex(playerid)]);
					//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_THIGH, 18635, A_OBJECT_BONE_RIGHT_THIGH, 0.2, -0.06, 0.1, 0.0, -90.0, 90.0, 1.0, 1.0, 1.0, 0);

						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_LOADER);

						SetPlayerLoaderJobLoadCP(playerid);

						SendClientMessage(playerid, COR_SERVER, "[Успешно]: "c_server"Вы начали работу грузчика!");
						SendClientMessage(playerid, COR_SERVER, "[Информация]: "c_server"Точки доставки груза помечены {FF0000}красным "c_server"маркером!");
					}
				}
			}
			case DIALOG_TEMP_JOB_LOADER_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_LOADER);
				}
			}
			case DIALOG_TEMP_JOB_MINER_START:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_MINER, TJ_SKIN)[GetPlayerSex(playerid)]);
				//		SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.02, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);

						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_MINER);

						SetPlayerTempJobState(playerid, TEMP_JOB_STATE_MINER_LOAD);
						SetPlayerMinerJobLoadCP(playerid);

						SendClientMessage(playerid, 0x3399FFFF, "Вы начали работу шахтера");
						SendClientMessage(playerid, 0x66CC00FF, "Ищите месторождения железной руды на территории шахты");
						SendClientMessage(playerid, 0x66CC00FF, "Добытое сырье относите на склад для переплавки");
					}
				}
			}
			case DIALOG_TEMP_JOB_MINER_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_MINER);
				}
			}
			case DIALOG_TEMP_JOB_FACTORY_TRUCKER:
			{
				if(response)
				{
					new job = GetPlayerTempJob(playerid);

					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY_TRUCKER, TJ_SKIN)[GetPlayerSex(playerid)];

							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);

							if(GetPlayerSex(playerid))
					//		SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HEAD, 18638, A_OBJECT_BONE_HEAD, 0.16, 0.02, 0.0, 0.0, 0.0, 0.0, 1.0, 1.1, 1.12, 0);

							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY_TRUCKER);
							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_NONE);

							SendClientMessage(playerid, 0x3399FFFF, "Вы начали работу в службе доставки завода");
							SendClientMessage(playerid, 0x66CC00FF, "Для получения информации воспользуйтесь инструкцией рядом с Вами");

							SetPlayerData(playerid, P_IN_JOB, true);
						}
						case TEMP_JOB_FACTORY_TRUCKER:
						{
							EndPlayerJob(playerid);
						}
					}
				}
			}
			case DIALOG_TEMP_JOB_FACTORY:
			{
				if(response)
				{
					new job = GetPlayerTempJob(playerid);

					switch(job)
					{
						case TEMP_JOB_NONE:
						{
							new skin = GetTempJobInfo(TEMP_JOB_FACTORY, TJ_SKIN)[GetPlayerSex(playerid)];
							if(!GetPlayerSex(playerid))
							{
								skin += random(2);
							}

							ClearAnimations(playerid);
							SetPlayerSkin(playerid, skin);
						//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HEAD, 18638, A_OBJECT_BONE_HEAD, 0.16, 0.02, 0.0, 0.0, 0.0, 0.0, 1.0, 1.1, 1.12, 0);

							TogglePlayerFactoryCP(playerid, true);
							SetPlayerData(playerid, P_JOB_WAGE, 0);

							SetPlayerJobLoadItems(playerid, 0);
							SetPlayerTempJob(playerid, TEMP_JOB_FACTORY);

							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);

							SendClientMessage(playerid, 0x3399FFFF, "Вы начали работу в производственном цеху завода");
							SendClientMessage(playerid, 0x66CC00FF, "Для получения информации воспользуйтесь инструкцией у входа в цех");

							DeletePVar(playerid, "factory_skill");
							DeletePVar(playerid, "factory_bad_prods");
							DeletePVar(playerid, "factory_take_metall");
						}
						case TEMP_JOB_FACTORY:
						{
							EndPlayerTempJob(playerid, TEMP_JOB_FACTORY);
						}
					}
				}
			}
			case DIALOG_TEMP_JOB_LUMBERJACK_ST:
			{
				if(response)
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_NONE)
					{
						SetPlayerSkin(playerid, GetTempJobInfo(TEMP_JOB_MINER, TJ_SKIN)[GetPlayerSex(playerid)]);
					//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 326, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);

						SetPlayerJobLoadItems(playerid, 0);
						SetPlayerTempJob(playerid, TEMP_JOB_LUMBERJACK);

						SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_CHOP);
						SetPlayerLumberJackChopCP(playerid);

						SendClientMessage(playerid, 0x3399FFFF, "Вы начали работу лесоруба");
						SendClientMessage(playerid, 0x3399FFFF, "Точки добычи дерева помечены {FF0000}красными {3399FF}маркерами");
					}
				}
			}
			case DIALOG_TEMP_JOB_LUMBERJACK_END:
			{
				if(response)
				{
					EndPlayerTempJob(playerid, TEMP_JOB_LUMBERJACK);
				}
			}
			case DIALOG_CONTENER2:
			{
				if(cont3 >=1)
				{
                    if(GetPlayerMoneyEx(playerid) >= 200000000)
					{
						new skin_cont[8] = {149, 59, 5, 3, 149, 287,276,280};

						new id = random(7);


						SetPlayerData(playerid, P_SKIN, skin_cont[id]);
		      			SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили эксклюзивный скин");
						UpdatePlayerDatabaseInt(playerid, "skin", skin_cont[id]);
						GivePlayerMoneyEx(playerid, -200000000, "Открытие контейнера");
						SetPlayerSkin(playerid, skin_cont[id]);
						cont3 -=1;
						SetPlayerSkinInit(playerid);
                    }
					else
				    	return SendClientMessage(playerid, -1, "У вас не достаточно денег!!");
				}
					else
				    return SendClientMessage(playerid, -1, "Контейнеров данного типа нету на складе!");
			}
			case DIALOG_CONTENER1:
			{
				if(cont1 >=1)
				{
				    if(GetPlayerMoneyEx(playerid) >= 500000)
					{
						switch(random(4))
						{
							case 0:
							{
	      						SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили 30 аптечек");
								GivePlayerMoneyEx(playerid, -500000, "Открытие контейнера", true, true);
								cont1 -=1;
								AddPlayerData(playerid, P_MED_CHEST, +, 30);
								UpdatePlayerDatabaseInt(playerid, "healme", GetPlayerData(playerid, P_MED_CHEST));
							}
							case 1:
							{
	      						SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили +50 EXP");
								GivePlayerMoneyEx(playerid, -500000, "Открытие контейнера", true, true);
								cont1 -=1;
								AddPlayerData(playerid, P_EXP, +, 50);
								UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
							}
							case 2:
							{
	      						SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили пачку денег суммой 50.000 руб");
								GivePlayerMoneyEx(playerid, -500000, "Открытие контейнера", true, true);
								GivePlayerMoneyEx(playerid, 50000, "Открытие контейнера", true, true);
								cont1 -=1;
							}
							case 3:
							{
	      						SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили биту");
								GivePlayerMoneyEx(playerid, -500000, "Открытие контейнера", true, true);
								cont1 -=1;
								GivePlayerWeapon(playerid, 5, 5); // Give playerid a sawn-off shotgun with 64 ammo
							}
							case 4:
							{
	      						SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Открыв контейнер Вы получили пачку денег суммой 2.000.000 руб");
								GivePlayerMoneyEx(playerid, -500000, "Открытие контейнера", true, true);
								GivePlayerMoneyEx(playerid, 2000000, "Открытие контейнера", true, true);
								cont1 -=1;
							}
						}
					}
					else
				    	return SendClientMessage(playerid, -1, "У вас не достаточно денег!!");
				}
					else
				    return SendClientMessage(playerid, -1, "Контейнеров данного типа нету на складе!");
			}
			// -----------------------------------------------------------------
			case DIALOG_FUEL_STATION_BUY:
			{
				if(response)
				{
					new stationid = GetPVarInt(playerid, "buy_fuel_st");

					if(IsPlayerInRangeOfPoint(playerid, 15.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
					{
						if(!IsFuelStationOwned(stationid))
						{
							if(GetPlayerMoneyEx(playerid) >= GetFuelStationData(stationid, FS_PRICE))
							{
								SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы купили заправочную станцию");
								BuyPlayerFuelStation(playerid, stationid);

								PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новая заправочная станция", "{FFFFFF}Вам нужно заплатить за аренду АЗС в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этой заправочной станции");
						}
					else
						{
							new fmt_str[75];

							format(fmt_str, sizeof fmt_str, "Эта заправочная станция уже куплена. Владелец: %s", GetFuelStationData(stationid, FS_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}
					}
				}
				DeletePVar(playerid, "buy_fuel_st");
			}
			case DIALOG_FUEL_STATION_INFO:
			{
				if(response)
				{
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_PARAMS:
			{
				if(response)
				{
					ShowPlayerFuelStationDialog(playerid, listitem + 1);
				}
					else callcmd::fuelst(playerid, "");
			}
			case DIALOG_FUEL_STATION_NAME:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(3 <= strlen(inputtext) <= 15)
						{
							utf8_to_cp1251(inputtext);
							format(g_fuel_station[stationid][FS_NAME], 20, inputtext, 0);
							UpdateFuelStationLabel(stationid);

							SendClientMessage(playerid, 0x66CC00FF, "Название заправочной станции изменено");
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "Длина названия должна быть от 3-х до 15-ти символов");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_NEW_NAME);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_PRICE_FUEL:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(2 <= price <= 15 && IsNumeric(inputtext))
						{
							new fmt_str[75];

							SetFuelStationData(stationid, FS_FUEL_PRICE, price);
							UpdateFuelStationLabel(stationid);

							format(fmt_str, sizeof fmt_str, "Теперь топливо на Вашей заправке будет продаваться по %d руб за 1 литр", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET fuel_price=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_FUEL_PRICE), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "Укажите отпускную цену от 2 до 15 рублей за 1 литр");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_FUEL_PRICE);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_BUY_FUEL_PR:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(2 <= price <= 10 && IsNumeric(inputtext))
						{
							new fmt_str[90];
							SetFuelStationData(stationid, FS_BUY_FUEL_PRICE, price);

							format(fmt_str, sizeof fmt_str, "Теперь топливо для Вашей заправки будет закупаться по %d руб за 1 литр", price);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET buy_fuel_price=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BUY_FUEL_PRICE), GetFuelStationData(stationid, FS_SQL_ID));
							mysql_query(mysql, fmt_str, false);
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "Укажите закупочную цену от 2 до 10 рублей за 1 литр");
							return ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_BUY_FUEL_PRIC);
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_ORDER_FUELS:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new order_fuels = strval(inputtext);
						new fuel_price = 5;
						new price = order_fuels * fuel_price;

						if(order_fuels > 0 && IsNumeric(inputtext))
						{
							new fmt_str[256];

							new free_fuel_slots = GetFuelStationMaxFuel(stationid) - GetFuelStationData(stationid, FS_FUELS);

							if(free_fuel_slots > 8000)
								free_fuel_slots = 8000;

							if(order_fuels <= free_fuel_slots)
							{
								if(GetFuelStationData(stationid, FS_BALANCE) >= price)
								{
									AddFuelStationData(stationid, FS_BALANCE, -, price);

									format(fmt_str, sizeof fmt_str, "~w~fuel st. bank~n~~r~-$%d", price);

									AddFuelStationData(stationid, FS_FUELS, +, order_fuels);

									GameTextForPlayer(playerid, fmt_str, 4000, 1);

									format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET balance=%d,fuels=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Параметры заказа:\n\n"\
										"Количество топлива:\t\t\t%d л\n"\
										"Стоимость 1 литра:\t\t\t$%d\n"\
										"Общая стоимость заказа:\t\t$%d\n"\
										"Топливо было успешно доставлено на АЗС",
										order_fuels,
										fuel_price,
										price
									);
									Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Заказ оформлен", fmt_str, "Закрыть", "");

									return 1;
								}
					else
								{
									format(fmt_str, sizeof fmt_str, "Чтобы оплатить заказ необходимо иметь $%d на счету АЗС", price);
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
					else
							{
								format(fmt_str, sizeof fmt_str, "Вы не можете заказать более %d литров топлива", free_fuel_slots);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
						}
					}
				}
			}
			case DIALOG_FUEL_STATION_ORDER_CANCE:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						new order_id = GetFuelStationData(stationid, FS_ORDER_ID);
						if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
						{
							if(!GetOrderData(order_id, O_USED))
							{
								new fmt_str[128];
								new return_money = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);

								DeleteOrder(order_id);
								AddFuelStationData(stationid, FS_BALANCE, +, return_money);

								format(fmt_str, sizeof fmt_str, "UPDATE fuel_stations SET balance=%d WHERE id=%d LIMIT 1", GetFuelStationData(stationid, FS_BALANCE), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Вы отменили заказ топлива\n"\
									"На счет заправочной станции было возвращено {00CC00}%d руб",
									return_money
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF9900}Отмена заказа", fmt_str, "Закрыть", "");

								format(fmt_str, sizeof fmt_str, "~w~fuel st. bank~n~~g~+%d rub", return_money);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);

								return 1;
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ваш заказ выполняется, его нельзя отменить");
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_IMPROVEMENT:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_fuel_station_improvements - 1)
						{
							new i_level = GetFuelStationData(stationid, FS_IMPROVEMENTS);
							new i_price = g_fuel_station_improvements[listitem][I_PRICE];

							if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Этот уровень улучшений пока недоступен");
							}
					else if(i_level > listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили этот уровень улучшений");
							}
					else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];

								format(fmt_str, sizeof fmt_str, "Для покупки %d уровня улучшений необходимо %d рублей", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
					else
							{
								new fmt_str[128];

								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, fuel_stations f SET a.money=%d, f.improvements=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшений для АЗС", false, true);

									format(fmt_str, sizeof fmt_str, "Вы улучшили свою заправочную станцию до {FFCD00}%s {3399FF}уровня", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);

									AddFuelStationData(stationid, FS_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1..3:
										{
											format(fmt_str, sizeof fmt_str, "Емкость топливного хранилища увеличена до %d литров", GetFuelStationMaxFuel(stationid));
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);

											SendClientMessage(playerid, 0x999999FF, "Теперь можно меньше заботиться о его наполнении");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Акцизный сбор на бензин больше не распространяется на Вашу заправочную станцию");
											SendClientMessage(playerid, 0x999999FF, "Благодаря этому, плата за аренду территории АЗС уменьшена в 2 раза");
										}
									}
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 17)");
							}
						}
					}
					ShowPlayerFuelStationDialog(playerid, FUEL_ST_OPERATION_PARAMS);
				}
			}
			case DIALOG_FUEL_STATION_SELL:
			{
				new stationid = GetPlayerFuelStation(playerid);
				if(stationid != -1)
				{
					if(response)
					{
						SellFuelStation(playerid);
					}
				}
			}
			case DIALOG_FUEL_STATION_BUY_JERRICA:
			{
				new stationid = GetPVarInt(playerid, "buy_jerrican_in_fuelst");
				DeletePVar(playerid, "buy_jerrican_in_fuelst");

				if(response)
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
					{
						if(!GetPVarInt(playerid, "have_jerrican"))
						{
							new price = GetFuelStationData(stationid, FS_FUEL_PRICE) * 15;
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								new query[150];

								if(IsFuelStationOwned(stationid))
								{
									if(GetFuelStationData(stationid, FS_FUELS) < 15)
										return SendClientMessage(playerid, 0xCECECEFF, "На этой АЗС нет бензина");

									AddFuelStationData(stationid, FS_FUELS, -, 15);
									AddFuelStationData(stationid, FS_BALANCE, +, price);

									format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
								}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));

								mysql_query(mysql, query, false);
								if(!mysql_errno())
								{
									new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
									SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + price);

									GivePlayerMoneyEx(playerid, -price, "Покупка канистры на АЗС", false, true);

									SetPVarInt(playerid, "have_jerrican", 1);
								//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1650, A_OBJECT_BONE_LEFT_HAND, 0.15, 0.0, 0.0, 0.0, -90.0, 180.0, 1.0, 1.0, 1.0, 0);

									SendClientMessage(playerid, 0x66CC00FF, "Вы купили канистру с 15 литрами бензина");
									SendClientMessage(playerid, 0x3399FFFF, "Чтобы заправить транспорт, подойдите к нему и нажмите ПКМ");
									SendClientMessage(playerid, 0xCECECEFF, "Примечание: Вы не должны двигаться во время заправки. ПКМ - правая кнопка мышки");
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 19)");
							}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки канистры");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили канистру");
					}
				}
			}
			case DIALOG_FUEL_STATION_BUY_REPAIR:
			{
				new stationid = GetPVarInt(playerid, "buy_jerrican_in_fuelst");
				DeletePVar(playerid, "buy_jerrican_in_fuelst");

				if(response)
				{
					if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
					{
						new price = 100000;
						if(GetPlayerMoneyEx(playerid) >= price)
						{
							new query[150];

							if(IsFuelStationOwned(stationid))
							{

								AddFuelStationData(stationid, FS_FUELS, -, 15);
								AddFuelStationData(stationid, FS_BALANCE, +, price);

								format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
							}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));

							mysql_query(mysql, query, false);
							if(!mysql_errno())
							{
								new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
								SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + price);

								GivePlayerMoneyEx(playerid, -price, "Покупка ремки на АЗС", false, true);
								
								AddPlayerData(playerid, P_REPCARID, +, 1);
								UpdatePlayerDatabaseInt(playerid, "repcarid",GetPlayerData(playerid, P_REPCARID));

							//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1650, A_OBJECT_BONE_LEFT_HAND, 0.15, 0.0, 0.0, 0.0, -90.0, 180.0, 1.0, 1.0, 1.0, 0);

								SendClientMessage(playerid, 0x66CC00FF, "Вы купили рем. комплекс. Используйте /repaircar - чтобы починить траснпорт");
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 19)");
						}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки канистры");
					}
				}
			}
			case DIALOG_UNUSED_LEGACY_9:
			{
				new stationid = GetPVarInt(playerid, "nearest_fuel_st");

				if(response)
				{
					new buy_fuel_count = strval(inputtext);
					new vehicleid = GetPlayerVehicleID(playerid);

					if(GetPlayerJob(playerid) == JOB_UNUSED_3 && IsPlayerInJob(playerid) && IsPlayerInVehicle(playerid, GetPlayerJobCar(playerid)))
					{
						if(IsPlayerInRangeOfPoint(playerid, 10.0, GetFuelStationData(stationid, FS_POS_X), GetFuelStationData(stationid, FS_POS_Y), GetFuelStationData(stationid, FS_POS_Z)))
						{
							new fmt_str[150];

							if((1 <= buy_fuel_count <= 10_000) && IsNumeric(inputtext))
							{
								if(GetFuelStationData(stationid, FS_FUELS) >= buy_fuel_count)
								{
									if(!(buy_fuel_count % 10))
									{
										if((GetPlayerJobLoadItems(playerid) + buy_fuel_count) <= 50)
										{
											new price = buy_fuel_count * GetFuelStationData(stationid, FS_FUEL_PRICE);
											if(GetPlayerMoneyEx(playerid) >= price)
											{
												if(IsFuelStationOwned(stationid))
												{
													AddFuelStationData(stationid, FS_FUELS, -, buy_fuel_count);
													AddFuelStationData(stationid, FS_BALANCE, +, price);

													format(fmt_str, sizeof fmt_str, "UPDATE accounts a,fuel_stations f SET a.money=%d,f.fuels=%d,f.balance=%d WHERE a.id=%d AND f.id=%d", GetPlayerMoneyEx(playerid)-price, GetFuelStationData(stationid, FS_FUELS), GetFuelStationData(stationid, FS_BALANCE), GetPlayerAccountID(playerid), GetFuelStationData(stationid, FS_SQL_ID));
												}
					else format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
												mysql_query(mysql, fmt_str, false);

												if(!mysql_errno())
												{
													GivePlayerMoneyEx(playerid, -price, "Покупка топлива на АЗС (/getfuel)", false, true);
													SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + buy_fuel_count);

													new buy_fuel_pay = GetPVarInt(playerid, "buy_fuel_pay_j");
													SetPVarInt(playerid, "buy_fuel_pay_j", buy_fuel_pay + price);

													format(fmt_str, sizeof fmt_str, "Вы купили %d л топлива за %d рублей", buy_fuel_count, price);
													SendClientMessage(playerid, 0x66CC00FF, fmt_str);

													format(fmt_str, sizeof fmt_str, "%s{FFFFFF}Автомеханик\n{999999}Топливо: %d л", GetPlayerData(playerid, P_JOB_SERVICE_NAME), GetPlayerJobLoadItems(playerid));
													UpdateVehicleLabel(vehicleid, 0xCC9900FF, fmt_str);

													return DeletePVar(playerid, "nearest_fuel_st");
												}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 20)");
											}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для закупки такого кол-во топлива");
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Можно загрузить не более 50 л топлива");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Кол-во топлива должно быть кратно 10");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "На АЗС нет такого кол-ва топлива");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Неверное значение");

							format
							(
								fmt_str, sizeof fmt_str,
								"{FFFFFF}Топливо на АЗС:\t\t%d/10000 л\n"\
								"Стоимость 1 литра:\t%d руб\n\n"\
								"Введите кол-во бензина, которое хотите закупить\n"\
								"(число должно быть кратным 10)",
								GetFuelStationData(stationid, FS_FUELS),
								GetFuelStationData(stationid, FS_FUEL_PRICE)
							);
							Dialog(playerid, DIALOG_UNUSED_LEGACY_9, DIALOG_STYLE_INPUT, "{FFCD00}Закупка топлива", fmt_str, "Купить", "Отмена");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться около заправочной станции");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в рабочем транспорте");
				}
					else DeletePVar(playerid, "nearest_fuel_st");
			}
			// -----------------------------------------------------------------
			case DIALOG_JERRICAN_FILL_CAR:
			{
				new vehicleid = GetPVarInt(playerid, "jerrican_fill_car");
				DeletePVar(playerid, "jerrican_fill_car");

				if(response && vehicleid)
				{
					new Float: x, Float: y, Float: z;
					GetVehiclePos(vehicleid, x, y, z);

					if(IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z))
					{
						if((GetVehicleData(vehicleid, V_FUEL) + 15.0) <= 150.0)
						{
							SetVehicleData(vehicleid, V_FUEL, GetVehicleData(vehicleid, V_FUEL) + 15.0);
							ApplyAnimationEx(playerid, "CRIB", "CRIB_Use_Switch", 4.0, 0, 0, 0, 0, 0, 0);

							DeletePVar(playerid, "have_jerrican");

						//	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
							SendClientMessage(playerid, 0x66CC00FF, "Транспорт заправлен");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "В бензобак этого транспорта столько не поместится");
					}
					else SendClientMessage(playerid, 0x999999FF, "Вы находитесь слишком далеко от транспорта");
				}
			}//by Dergen and Tima
			case DIALOG_BIZ_SELECT:
            {
                if(response)
                {
                    new businessid = strval(inputtext);
            
                    SetSelectedBusiness(playerid, businessid);
                    ShowPlayerBusinessInfo(playerid, businessid);
                }
            }
            case DIALOG_BIZ_SHOP_GUN:
            {
                return 1;
            }
			// -----------------------------------------------------------------
			case DIALOG_BIZ_BUY:
			{
				if(response)
				{
					new businessid = GetPVarInt(playerid, "buy_biz_id");
					if(businessid < 0 || businessid >= g_business_loaded || IsBusinessOnAuction(businessid))
					{
						DeletePVar(playerid, "buy_biz_id");
						return SendClientMessage(playerid, 0xCECECEFF, "Покупка отменена: бизнес находится на аукционе.");
					}

					if(IsPlayerInRangeOfPoint(playerid, 7.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
					{
						if(!IsBusinessOwned(businessid))
						{
							if(GetPlayerMoneyEx(playerid) >= GetBusinessData(businessid, B_PRICE))
							{
							   // if(Config[sBuyBiz] == 0)
							    //{
								SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы купили бизнес");
								BuyPlayerBusiness(playerid, businessid);

								PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Информация", "{FFFFFF}Вы успешно приобрели {ffff00} бизнес. {ffffff} Не забывайте о том, что\n {ffffff} любое имущество необходимо оплачивать. В том случае\n {ffffff} если бизнес будет не оплачен он будет продан в\n {ffffff} государство,а Вам будет возвращённой {ffff00} 70% {ffffff}от госсударственной\n {ffffff} стоимости.\n    \n {ffffff} Также бизнес может быть продан, если в Вашем бизнесе\n {ffffff} отсутствуют продукты более, чем {ffff00} 24 {ffffff}часа с момента\n {ffffff} окончания продуктов.\n      \n {ffffff} Для пополнения продуктов и управления бизнесом\n {ffffff} воспользуйтесь {ffff00} /business.", "Закрыть", "");
						//	}
							//	else
							//	    return Send(playerid,-1,"В данный момент все бизнесы на сервере не доступны к покупке!");
							}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого бизнеса");
						}
					else
						{
							new fmt_str[64];

							format(fmt_str, sizeof fmt_str, "Этот бизнес уже куплен. Владелец: %s", GetBusinessData(businessid, B_OWNER_NAME));
							SendClientMessage(playerid, 0xCECECEFF, fmt_str);
						}
					}
				}
				DeletePVar(playerid, "buy_biz_id");
			}
			case DIALOG_BIZ_INFO:
			{
				if(response)
				{
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_PARAMS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
						case 1: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_ORDER);
						case 2: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_ORDER_INFO);
						case 3: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROFIT_STATS);
						case 4: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_IMPROVEMENTS);
						case 5: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_GPS_MARK);
						case 6: ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_CHANGE_BUSINESS);
						case 7: ShowCasinoEmployeesDialog(playerid);
					}
				}
					else callcmd::business(playerid, "");
			}
			case DIALOG_BIZ_ENTER_PRICE:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(strlen(inputtext))
						{
							if((0 <= price <= 5000) && IsNumeric(inputtext))
							{
								new query[64 + 1];
								SetBusinessData(businessid, B_ENTER_PRICE, price);

								format(query, sizeof query, "UPDATE business SET enter_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_PRICE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								UpdateBusinessLabel(businessid);
								SendClientMessage(playerid, 0x66CC00FF, "Цена за вход в бизнес изменена");

								return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Предел цены от 0 до 5000 рублей");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Введите цену за вход в Ваш бизнес");

						ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_ENTER_PRICE);
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_PROD_PRICE:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new price = strval(inputtext);
						if(strlen(inputtext) && IsNumeric(inputtext))
						{
							if(25 <= price <= 28)
							{
								new query[64 + 1];
								SetBusinessData(businessid, B_PROD_PRICE, price);

								format(query, sizeof query, "UPDATE business SET prod_price=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PROD_PRICE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, query, false);

								SendClientMessage(playerid, 0x66CC00FF, "Стоимость продукта изменена" );
								return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Укажите стоимость от 25 до 28 рублей" );
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Введите стоимость продукта" );

					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PROD_PRICE);
				}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_PRODS:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new order_prods = strval(inputtext);
						new prod_price = GetBusinessData(businessid, B_PROD_PRICE);
						new price = order_prods * prod_price;

						if(order_prods > 0 && IsNumeric(inputtext))
						{
							new fmt_str[256];
							new order_id = GetBusinessData(businessid, B_ORDER_ID);
							if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
							{
								new old_amount = GetOrderData(order_id, O_AMOUNT);
								new old_free_slots = GetBusinessMaxProd(businessid) - GetBusinessData(businessid, B_PRODS);
								if(old_amount > old_free_slots) old_amount = old_free_slots;
								if(old_amount > 0) AddBusinessData(businessid, B_PRODS, +, old_amount);
								DeleteOrder(order_id);
								mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE business SET products=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);
							}

							new free_prods_slots = GetBusinessMaxProd(businessid) - GetBusinessData(businessid, B_PRODS);
							if(order_prods <= free_prods_slots)
							{
								if(prod_price > 0 && order_prods > cellmax / prod_price)
									return SendClientMessage(playerid, 0xCECECEFF, "Сумма заказа слишком велика");

								price = order_prods * prod_price;
								if(GetBusinessData(businessid, B_BALANCE) >= price)
								{
									AddBusinessData(businessid, B_BALANCE, -, price);
									AddBusinessData(businessid, B_PRODS, +, order_prods);

									format(fmt_str, sizeof fmt_str, "~w~business bank~n~~r~-$%d", price);
									GameTextForPlayer(playerid, fmt_str, 4000, 1);

									mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE business SET balance=%d,products=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									format(fmt_str, sizeof fmt_str, "На склад бизнеса моментально доставлено %d продуктов", order_prods);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									return ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
								}
								else
								{
									format(fmt_str, sizeof fmt_str, "Чтобы оплатить заказ необходимо иметь $%d на счету бизнеса", price);
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
							else
							{
								format(fmt_str, sizeof fmt_str, "Вы не можете заказать более %d продуктов", free_prods_slots);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
						}
					}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_ORDER_CANCEL:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						new order_id = GetBusinessData(businessid, B_ORDER_ID);
						if(order_id != -1 && GetOrderData(order_id, O_SQL_ID) > 0)
						{
							if(!GetOrderData(order_id, O_USED))
							{
								new fmt_str[128];
								new return_money = GetOrderData(order_id, O_AMOUNT) * GetOrderData(order_id, O_PRICE);

								DeleteOrder(order_id);
								AddBusinessData(businessid, B_BALANCE, +, return_money);

								format(fmt_str, sizeof fmt_str, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								format
								(
									fmt_str, sizeof fmt_str,
									"{FFFFFF}Вы отменили заказ продуктов\n"\
									"На счет бизнеса было возвращено {00CC00}%d руб",
									return_money
								);
								Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{FF9900}Отмена заказа", fmt_str, "Закрыть", "");

								format(fmt_str, sizeof fmt_str, "~w~business bank~n~~g~+%d rub", return_money);
								GameTextForPlayer(playerid, fmt_str, 4000, 1);

								return 1;
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Ваш заказ выполняется, его нельзя отменить");
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_EMPLOYEES:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							Dialog
							(
								playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX,
								"{FF0000}Сотрудники",
								"{FFFFFF}Для найма сотрудника используйте команду {33AACC}/manager [id игрока]\n"\
								"Игрок должен находиться рядом с Вами.",
								"Назад", "Выйти"
							);
						}
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_BIZ_INFO, DIALOG_STYLE_MSGBOX,
								"{FF0000}Сотрудники",
								"{FFFFFF}Список сотрудников в этой сборке\n"\
								"открывается через систему менеджера бизнеса.",
								"Назад", "Выйти"
							);
						}
					}
				}
					else ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
			}
			case DIALOG_BIZ_IMPROVEMENT:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(IsBusinessNoEnter(businessid))
					return SendClientMessage(playerid, 0xCECECEFF, "Данный тип бизнеса нельзя улучшить.");
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_improvements - 1)
						{
							new i_level = GetBusinessData(businessid, B_IMPROVEMENTS);
							new i_price = g_business_improvements[listitem][I_PRICE];

							if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Этот уровень улучшений пока недоступен");
							}
					else if(i_level > listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили этот уровень улучшений");
							}
					else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];

								format(fmt_str, sizeof fmt_str, "Для покупки %d уровня улучшений необходимо %d рублей", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
					else
							{
								new fmt_str[128];

								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, business b SET a.money=%d, b.improvements=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									new cur_max_prods = GetBusinessMaxProd(businessid);
									GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшений для Бизнеса", false, true);

									format(fmt_str, sizeof fmt_str, "Вы улучшили свой бизнес до {FFCD00}%s {3399FF}уровня", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);

									AddBusinessData(businessid, B_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											format(fmt_str, sizeof fmt_str, "Количество слотов для продуктов увеличено с %d до %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x66CC00FF, fmt_str);

											SendClientMessage(playerid, 0x999999FF, "Теперь можно намного реже пополнять их запас");
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Теперь ваши клиенты смогут пользоваться услугами медпункта на территории бизнеса");
											SendClientMessage(playerid, 0x999999FF, "Доходы от этого будут перечисляться на баланс предприятия");

											BusinessHealthPickupInit(businessid);
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Благодаря пониженному налогу, вы будете платить за аренду помещения в 2 раза меньше");
											SendClientMessage(playerid, 0x999999FF, "Благодаря этому, вы сможете получать большую прибыль");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Теперь ваши клиенты будут слышать звук при входе в бизнес");
											SendClientMessage(playerid, 0x999999FF, "Вы также можете поменять или выключить его командой {FF9900}/bizmusic");
										}
										case 5:
										{
											SendClientMessage(playerid, 0x66CC00FF, "В Вашем бизнесе был оборудован дополнительный склад продуктов повышенной вместимости");

											format(fmt_str, sizeof fmt_str, "Количество слотов для продуктов увеличено с %d до %d", cur_max_prods, GetBusinessMaxProd(businessid));
											SendClientMessage(playerid, 0x999999FF, fmt_str);
										}
										case 6:
										{
											format(fmt_str, sizeof fmt_str, "INSERT INTO business_gps (bid,time) VALUES (%d,%d)", businessid, gettime());
											mysql_query(mysql, fmt_str, false);

											g_business_gps_init = false;

											SendClientMessage(playerid, 0x66CC00FF, "Теперь Ваш бизнес можно будет найти в списке бизнесов {FF9900}(/gps > Бизнес)");
											SendClientMessage(playerid, 0x999999FF, "Это позволит привлечь дополнительных клиентов, тем самым повысить доходы предприятия");
										}
									}
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 23)");
							}
						}
					}
					ShowPlayerBusinessDialog(playerid, BIZ_OPERATION_PARAMS);
				}
			}
			case DIALOG_BIZ_SELL:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						SellBusiness(playerid);
					}
				}
			}
			case DIALOG_BIZ_ENTER_MUSIC:
			{
				new businessid = GetPlayerBusiness(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_business_sound)
						{
							new query[64];
							format(query, sizeof query, "UPDATE business SET enter_music=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_ENTER_MUSIC), GetBusinessData(businessid, B_SQL_ID));
							mysql_query(mysql, query, false);

							if(listitem > 0)
								PlayerPlaySound(playerid, g_business_sound[listitem - 1], 0.0, 0.0, 0.0);

							SetBusinessData(businessid, B_ENTER_MUSIC, listitem);
							SendClientMessage(playerid, 0x66CC00FF, "Звук при входе в бизнес изменен");
						}
					}
				}
			}
			case DIALOG_BIZ_ENTER:
			{
				new businessid = GetPVarInt(playerid, "biz_enter") - 1;
				DeletePVar(playerid, "biz_enter");

				if(response && GetPlayerInBiz(playerid) == -1)
				{
					if(businessid != -1 && GetBusinessData(businessid, B_ENTER_PRICE) > 0)
					{
						if(IsBusinessOwned(businessid))
						{
							if(IsPlayerInRangeOfPoint(playerid, 5.0, GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
							{
								new price = GetBusinessData(businessid, B_ENTER_PRICE);
								new take_prods = GetBusinessEnterProdCount(businessid);

								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[255];
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, price/2);
										}

										SetPlayerUseListitem(playerid, businessid);
										GivePlayerMoneyEx(playerid, -price, "Оплата за вход в бизнес", false, true);

										EnterPlayerToBiz(playerid, businessid);

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 22)");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для входа");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_CAR_MARKET:
			{
				if(!response) return 1;

				return EnterPlayerBuyCarMarket(playerid, GetPlayerListitemValue(playerid, 0));
			}

			case DIALOG_BIZ_CAR_MARKET_BUY_CAR:
			{
				if(!response || GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;

				new biz_id = GetPlayerInBiz(playerid);
				new car_market_id = GetCarMarketIdByBizId(biz_id);
				if(GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CAR_MARKET) return 1;

				BuyOwnableCar(playerid, car_market_id, buy_car_select_car[playerid]);

				return 1;
			}

			case DIALOG_BIZ_CAR_MARKET_CAR_INFO:
			{
				new vehicleid = GetPlayerVehicleID(playerid);
				new car_market_id = GetVehicleCarMarketID(vehicleid);

				if(response && 0 <= car_market_id <= 3)
				{
					BuyOwnableCar(playerid, car_market_id, GetVehicleModel(vehicleid) + 1000);
				}

				TogglePlayerControllable(playerid, true);
				RemovePlayerFromVehicle(playerid);
				return 1;
			}
			case DIALOG_BIZ_CAR_TUNING:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							new query[255],
							biz_id = GetPlayerInBiz(playerid),
							take_prods = 25;
							if(GetPlayerMoneyEx(playerid) >= 25000)
							{

								format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-25000, 10_000, GetBusinessData(GetPlayerInBiz(playerid), B_PRODS) > 0 ? GetBusinessData(GetPlayerInBiz(playerid), B_BALANCE)+25000 : 0, GetPlayerAccountID(playerid), GetBusinessData(GetPlayerInBiz(playerid), B_SQL_ID));
								mysql_query(mysql, query, false);

								if(GetBusinessData(biz_id, B_PRODS) >= take_prods)
								{

									new vehicleid = GetPlayerOwnableCar(playerid);

									SetVehicleHealth(vehicleid, 1000);
									RepairVehicle(vehicleid);

									SetBusinessData(biz_id, B_PRODS, 10_000);
									AddBusinessData(biz_id, B_BALANCE, +, 25000);

									format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
									mysql_query(mysql, query, false);

									mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,25000,%d)", GetBusinessData(biz_id, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), IsBusinessOwned(biz_id));
									mysql_query(mysql, query, false);
								}
								GivePlayerMoneyEx(playerid, -25000, "Починка транспорта");
							}
					else
							SendClientMessage(playerid, -1, "У вас не хватает денег!");
						}
						case 1: ShowVehicleImproveDialog(playerid);
						case 2:
						{
						    g_business_realtor_list = "";
							for(new idx; idx < 128; idx ++)
							{
								format(l_string, 15, "{%06x}%d | ", VehicleColoursTableRGBA[idx]>>> 8, idx);
								strcat(g_business_realtor_list, l_string);
								if(!(idx % 10)) strcat(g_business_realtor_list, "\n");
							}
							strcat(g_business_realtor_list,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10,25");
						    Dialog(playerid, DIALOG_CHANGE_COLOR_CAR, DIALOG_STYLE_INPUT,"Покраска автомобиля",
							g_business_realtor_list,
							"Покрасить", "Отмена");
	                    }
						case 3:
						{
	                       Dialog
								(
									playerid, DIALOG_BIZ_CAR_TUNING_LIGHTS, DIALOG_STYLE_LIST,
									"{FFCD00}Цвет фар",
									""c_b"Красный\t{ffff00}10.000 руб\n"\
									""c_b"Зеленый\t{ffff00}10.000 руб\n"\
									"Синий\t{ffff00}10.000 руб\n"\
									"Желтый\t{ffff00}10.000 руб\n"\
									"Фиолетовый\t{ffff00}10.000 руб\n"\
									"Оранжевый\t{ffff00}10.000 руб.",
									"Выбрать", "Отмена"
								);
						}

					}
				}
			}
			case DIALOG_BIZ_CAR_TUNING_LIGHTS:
			{
			  switch(listitem)
				{
				  case 0:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
				     SetVehicleLightsColors(vehicleid, 255, 0, 0);
				     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
			      }
				  case 1:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
                     SetVehicleLightsColors(vehicleid, 0, 255, 0);
                     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
				  }
				  case 2:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
				     SetVehicleLightsColors(vehicleid, 0, 0, 255);
				     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
				  }
				  case 3:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
				     SetVehicleLightsColors(vehicleid, 230, 255, 0);
				     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
				  }
				  case 4:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
				     SetVehicleLightsColors(vehicleid, 255, 0, 77);
				     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
				  }
				  case 5:
				  {
				     new vehicleid = GetPlayerOwnableCar(playerid);
				     SetVehicleLightsColors(vehicleid, 255, 119, 0);
				     GivePlayerMoneyEx(playerid, -10000, "Фары транспорта");
				  }
		       }
			}
            case DIALOG_CHANGE_COLOR_CAR:
			{
			    new query[255],
					biz_id = GetPlayerInBiz(playerid),
					take_prods = 25;
						
			    if(response)
			    {
					if(GetPlayerMoneyEx(playerid) >= 250000)
					{
						new color1, color2, fmt_text[256],
						 	idx = GetPVarInt(playerid, "ownablecar_id");

						if(sscanf(inputtext, "P<,>dd", color1, color2))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
							new all_colors_str[1808], color_str[15];

							for(new idxx; idxx < 128; idxx ++)
							{
								format(color_str, sizeof color_str, "{%06x}%d | ", VehicleColoursTableRGBA[idxx]>>> 8, idxx);
								strcat(all_colors_str, color_str);
								if(!(idxx % 10)) strcat(all_colors_str, "\n");
							}
							strcat(all_colors_str,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10,25");
						    Dialog(playerid, DIALOG_CHANGE_COLOR_CAR, DIALOG_STYLE_INPUT,"Покраска автомобиля",
							all_colors_str,
							"Покрасить", "Отмена");

							return 1;
						}
					else
						{
							if(!(-1 <= color1 <= 128))
							{
								SendClientMessage(playerid, 0xCECECEFF, "Цвет транспорт от 0 до 255");
								new all_colors_str[1808], color_str[15];

								for(new idxx; idxx < 128; idxx ++)
								{
									format(color_str, sizeof color_str, "{%06x}%d | ", VehicleColoursTableRGBA[idxx]>>> 8, idxx);
									strcat(all_colors_str, color_str);
									if(!(idxx % 10)) strcat(all_colors_str, "\n");
								}
								strcat(all_colors_str,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10,25");
							    Dialog(playerid, DIALOG_CHANGE_COLOR_CAR, DIALOG_STYLE_INPUT,"Покраска автомобиля",
								all_colors_str,
								"Покрасить", "Отмена");

								return 1;
							}
							if(!(-1 <= color2 <= 128))
							{
								SendClientMessage(playerid, 0xCECECEFF, "Цвет транспорт от 0 до 255");
								new all_colors_str[1808], color_str[15];

								for(new idxx; idxx < 128; idxx ++)
								{
									format(color_str, sizeof color_str, "{%06x}%d | ", VehicleColoursTableRGBA[idxx]>>> 8, idxx);
									strcat(all_colors_str, color_str);
									if(!(idxx % 10)) strcat(all_colors_str, "\n");
								}
								strcat(all_colors_str,"\n{FFFFFF}Введите число в окошко ниже \nПример: 10,25");
							    Dialog(playerid, DIALOG_CHANGE_COLOR_CAR, DIALOG_STYLE_INPUT,"Покраска автомобиля",
								all_colors_str,
								"Покрасить", "Отмена");
								return 1;
							}
							
							format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-25000, 10_000, GetBusinessData(GetPlayerInBiz(playerid), B_PRODS) > 0 ? GetBusinessData(GetPlayerInBiz(playerid), B_BALANCE)+250000 : 0, GetPlayerAccountID(playerid), GetBusinessData(GetPlayerInBiz(playerid), B_SQL_ID));
							mysql_query(mysql, query, false);
							
							SetBusinessData(biz_id, B_PRODS, 10_000);
							AddBusinessData(biz_id, B_BALANCE, +, 250000);

							format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(biz_id, B_PRODS), GetBusinessData(biz_id, B_BALANCE), GetBusinessData(biz_id, B_SQL_ID));
							mysql_query(mysql, query, false);

							mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,250000,%d)", GetBusinessData(biz_id, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), IsBusinessOwned(biz_id));
							mysql_query(mysql, query, false);

							SendClientMessage(playerid, 0xffff00FF, "Вы покрасили свой личный транспорт, для того чтобы изменения вступили в силу...");
							SendClientMessage(playerid, 0xffff00FF, "...выгрузите и загрузите свой транспорт, или перезайдите.");

							GivePlayerMoneyEx(playerid, -250000, "Покрасил авто", true);


							mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET color_1='%d', color_2='%d'  WHERE id='%d' LIMIT 1", color1, color2, idx);
							mysql_query(mysql, fmt_text, false);

						}
					}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас нет денег (250.000)");
			    }
			}
			case DIALOG_BIZ_SHOP_24_7:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
						{
							new price;
							new take_prods;
							new shop_item = listitem + 1;
							new legacy_item = -1;

                            switch(shop_item)
                            {
                                case 1: legacy_item = 0;
                                case 2: legacy_item = 3;
                                case 3: legacy_item = 4;
                                case 4: legacy_item = 9;
case 5: legacy_item = 10;
                                case 6: legacy_item = 11;
                                case 7: legacy_item = 12;
                                case 8: legacy_item = 1;
                                case 9: legacy_item = 8;
                                default: return 1;
                            }

							if(legacy_item != -1)
								listitem = legacy_item;

							switch(listitem + 1)
							{
                                case 1:
                                {
                                    price = 300;
                                    take_prods = 35;

                                    if(GetPlayerMoneyEx(playerid) >= price)
                                    {
                                        new query[255];

                                        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                        {
                                            format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
                                        }
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
                                        mysql_query(mysql, query, false);

                                        if(!mysql_errno())
                                        {
                                            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                            {
                                                SetBusinessData(businessid, B_PRODS, 10_000);
                                                AddBusinessData(businessid, B_BALANCE, +, price/2);
                                            }

                                            mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
                                            mysql_query(mysql, query, false);

                                            GivePlayerMoneyEx(playerid, -price, "Покупка аптечки в 24/7", false, true);

                                            new med_slot = Inventory11_AddItemToDatabase(playerid, 22, 1, 1, 0, 0);
                                            if(med_slot == -1)
                                            {
                                                return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 28)");
                                            }
											callcmd::buy(playerid, "");
                                            SendClientMessage(playerid, 0x66CC00FF, "Вы купили аптечку. Она добавлена в /inv");
                                        }
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 28)");
                                    }
					else SendClientMessage(playerid, 0xCECECEFF, "Аптечка стоит 300 рублей");
                                }
        						case 2:
                                {
                                    price = 10000;
                                    take_prods = 10;

//                                    if(GetPlayerData(playerid, P_PLAY_PLAYER) < 1)
//                                    {
                                    if(GetPlayerMoneyEx(playerid) >= price)
                                    {
                                        new query[255];

                                        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                        {
                                            format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
                                        }
					                    else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1",                     GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
                                        mysql_query(mysql, query, false);

                                        if(!mysql_errno())
                                        {
                                            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                            {
                                                SetBusinessData(businessid, B_PRODS, 10_000);
                                                AddBusinessData(businessid, B_BALANCE, +, price/2);
                                            }

                                            mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
                                            mysql_query(mysql, query, false);

                                            GivePlayerMoneyEx(playerid, -price, "Покупка наушников в 24/7", false, true);

                                            AddPlayerData(playerid, P_PLAY_PLAYER, +, 1);
                                            UpdatePlayerDatabaseInt(playerid, "player", GetPlayerData(playerid, P_PLAY_PLAYER));

                                            SendClientMessage(playerid, 0x66CC00FF, "Вы купили наушники. Используйте {3399FF}/play {66CC00}для их использования.");
											callcmd::buy(playerid, "");

                                        }
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 28)");
                                    }
					else SendClientMessage(playerid, 0xCECECEFF, "Наушники стоят 10000 рублей");
//                                    }
//                					else SendClientMessage(playerid, 0x999999FF, "Вы не можете купить больше наушников!");
                                }
								case 3:
								{
									price = 500;
									take_prods = 200;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[255];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);

										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												SetBusinessData(businessid, B_PRODS, 10_000);
												AddBusinessData(businessid, B_BALANCE, +, price/2);
											}

											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);

											GivePlayerMoneyEx(playerid, -price, "Покупка фотоаппарата", false, true);
											callcmd::buy(playerid, "");
											GivePlayerWeapon(playerid, 43, 20);
											SendClientMessage(playerid, 0x66CC00FF, "Вы купили фотоаппарат на 15 снимков");
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 29)");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Набор фотографа стоит 500 рублей");
								}
								case 4:
								{
									price = 150;
									take_prods = 1;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[255];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
										else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);

										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												AddBusinessData(businessid, B_PRODS, -, take_prods);
												AddBusinessData(businessid, B_BALANCE, +, price);
											}

											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);

											GivePlayerMoneyEx(playerid, -price, "Покупка букета цветов", false, true);
											GivePlayerWeapon(playerid, WEAPON_FLOWER, 1);

											SendClientMessage(playerid, 0x66CC00FF, "Вы купили букет цветов");
											SendClientMessage(playerid, 0x66CC00FF, "Используйте {FFCD00}/present {66CC00}чтобы подарить их кому нибудь");
										}
										else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 30)");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "Букет стоит 150 рублей");
								}
								                                case 5:
								{
									price = 600;
									take_prods = 2;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[255];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);

										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												SetBusinessData(businessid, B_PRODS, 10_000);
												AddBusinessData(businessid, B_BALANCE, +, price/2);
											}
											callcmd::buy(playerid, "");

											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);

											GivePlayerMoneyEx(playerid, -price, "Покупка трости", false, true);
											GivePlayerWeapon(playerid, WEAPON_CANE, 1);

											SendClientMessage(playerid, 0x66CC00FF, "Вы купили трость");
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 31)");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Трость стоит 600 рублей");
								}
								case 6:
								{
									price = 800;
									take_prods = 5;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[255];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);

										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												SetBusinessData(businessid, B_PRODS, 10_000);
												AddBusinessData(businessid, B_BALANCE, +, price/2);
											}
											callcmd::buy(playerid, "");

											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);

											GivePlayerMoneyEx(playerid, -price, "Покупка парашюта", false, true);
											GivePlayerWeapon(playerid, WEAPON_PARACHUTE, 1);

											SendClientMessage(playerid, 0x66CC00FF, "Вы купили парашют");
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 31)");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Парашют стоит 800 рублей");
								}
								case 7:
								{
									price = 1000;
									take_prods = 5;

									if(GetPlayerMoneyEx(playerid) >= price)
									{
										new query[255];
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
										}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
										mysql_query(mysql, query, false);
										callcmd::buy(playerid, "");

										if(!mysql_errno())
										{
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												SetBusinessData(businessid, B_PRODS, 10_000);
												AddBusinessData(businessid, B_BALANCE, +, price/2);
											}

											mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
											mysql_query(mysql, query, false);

											GivePlayerMoneyEx(playerid, -price, "Покупка лотерейного билета", false, true);
											SetPlayerData(playerid, P_LOTTERY, random(900) + 100);

											CallLocalFunction("ShowPlayerLotteryDialog", "i", playerid);
											SendClientMessage(playerid, 0x66CC00FF, "Вы купили лотерейный билет");
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 32)");
									}
					else SendClientMessage(playerid, 0xCECECEFF, "Лотерейный билет стоит 1000 рублей");
								}
								case 8:
								{
									price = 150;
									take_prods = 45;

									if(!GetPlayerData(playerid, P_MASK))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[255];
											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);

											if(!mysql_errno())
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													SetBusinessData(businessid, B_PRODS, 10_000);
													AddBusinessData(businessid, B_BALANCE, +, price/2);
												}

												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);
												callcmd::buy(playerid, "");
												GivePlayerMoneyEx(playerid, -price, "Покупка маски", false, true);
												SetPlayerData(playerid, P_MASK, 1);

												SendClientMessage(playerid, 0x66CC00FF, "Вы купили маску");
												SendClientMessage(playerid, 0x66CC00FF, "Используйте {FFCD00}/mask {66CC00}для скрытия Вашего расположения на карте (на 10 минут)");
											}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 33)");
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Маска стоит 150 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "Вы уже приобрели маску");
								}
								case 9:
								{
									price = 350;
									take_prods = 10;

									if(GetPlayerMoneyEx(playerid) < price)
										return SendClientMessage(playerid, 0xCECECEFF, "Ремонтный комплект стоит 350 рублей");

									if(TrunkTest_GetFreeInventorySlot(playerid) == -1)
										return ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");

									if(!Inventory11_CanAddItemWeight(playerid, INV_ITEM_REPAIR_KIT, 1))
										return ShowNotificationNew(playerid, 2, 6, 0, 0, "Превышен максимальный вес инвентаря", " ");

									new repair_slot = Inventory11_AddItemToDatabase(playerid, INV_ITEM_REPAIR_KIT, 1, 1, 0, 0);
									if(repair_slot == -1)
										return SendClientMessage(playerid, 0xFF6600FF, "Ошибка добавления ремонтного комплекта в инвентарь");

									new query[255];
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=%d,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+price/2, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
									else
									{
										format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
									}
									mysql_query(mysql, query, false);

									if(mysql_errno())
									{
										Inventory11_DeleteSlotFromDatabase(playerid, repair_slot);
										return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения покупки, деньги не списаны");
									}

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										AddBusinessData(businessid, B_PRODS, -, take_prods);
										AddBusinessData(businessid, B_BALANCE, +, price/2);
									}

									mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
									mysql_query(mysql, query, false);

									GivePlayerMoneyEx(playerid, -price, "Покупка ремонтного комплекта в 24/7", false, true);
									ShowNotificationNew(playerid, 3, 6, 0, 0, "Ремонтный комплект добавлен в инвентарь", " ");
									callcmd::buy(playerid, "");
								}
								case 10:
								{
									price = 2100;
									take_prods = 40;

									if(!Inventory11_PlayerHasPhoneDevice(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[255];

											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,a.phone=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
					else format(query, sizeof query, "UPDATE accounts SET money=%d,phone=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);

											if(!mysql_errno())
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													SetBusinessData(businessid, B_PRODS, 10_000);
													AddBusinessData(businessid, B_BALANCE, +, price/2);
												}

												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);
												callcmd::buy(playerid, "");
												GivePlayerMoneyEx(playerid, -price, "Покупка телефона", false, true);
												SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);

												SendClientMessage(playerid, 0x66CC00FF, "Используйте {0099FF}/c(/call) или /call [номер телефона] {66CC00}чтобы сделать звонок.");
												SendClientMessage(playerid, 0x66CC00FF, "Для отправки SMS сообщения используйте {0099FF}/sms{66CC00}. Другие команды: {0099FF}/menu > Список команд > Общение");

												format
												(
													query, sizeof query,
													"{FFFFFF}Поздравляем!\n"\
													"Вы купили мобильный телефон. Ваш номер: {0099FF}%d",
													GetPlayerPhone(playerid)
												);
												Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Покупка мобильного телефона", query, "Закрыть", "");

												SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Приобрести телефон'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
											    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

											    SetPlayerData(playerid, P_QUEST_2, 1);
											    UpdatePlayerDatabaseInt(playerid, "quest_2", 1);
											    
											    AddPlayerData(playerid, P_TOP_5, +, 1);
												UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
											}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 25)");
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Мобильный телефон стоит 2100 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас уже есть мобильный телефон");
								}
								case 11:
								{
									price = 450;
									if(Inventory11_PlayerHasPhoneDevice(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
												"{66CC00}Изменение номера",
												"{FFFFFF}Введите новый номер в поле ниже\n\n"\
												"{FF6633}Примечания:\n"\
												"{FFCD00}- Номер должен быть шестизначным,\n"\
												"например: 284411\n"\
												"- Номер не должен начинаться с 0\n\n"\
												"{FFFFFF}Вы также можете вернуть свой\n"\
												"стандартный номер. Для этого\n"\
												"введите в поле {3399FF}цифру 0",
												"Сменить", "Отмена"
											);

											return 1;
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Для изменение номера телефона необходимо 450 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 12:
								{
									price = 200;
									if(GetPlayerPhone(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_COLOR, DIALOG_STYLE_LIST,
												"{66CC00}Изменение цвета телефона",
												"1. Карамельный\n"\
												"2. Синий\n"\
												"3. Оранжевый\n"\
												"4. Серебристый\n"\
												"5. Розовый\n"\
												"6. Красный\n"\
												"7. Зеленый\n"\
												"8. Темно-синий\n"\
												"9. Желтый\n"\
												"10. Белый",
												"Поменять", "Отмена"
											);

											return 1;
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Для изменение цвета телефона необходимо 200 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 13:
								{
									if(GetPlayerPhone(playerid) != 0)
									{
										Dialog
										(
											playerid, DIALOG_BIZ_PHONE_BALANCE, DIALOG_STYLE_INPUT,
											"{FFCD00}Пополнение мобильного телефона",
											"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
											"Готово", "Назад"
										);

										return 1;
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

									callcmd::buy(playerid, "");
								}
								default:
								
									return 1;
							}
						}
					}
				}
			}
			case DIALOG_BIZ_CELL_SALON:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(response)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
						{
							new price;
							new take_prods;

							switch(listitem + 1)
							{
								case 1:
								{
									price = 2100;
									take_prods = 40;

									if(!Inventory11_PlayerHasPhoneDevice(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											new query[255];

											if(GetBusinessData(businessid, B_PRODS) >= take_prods)
											{
												format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,a.phone=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
											}
					else format(query, sizeof query, "UPDATE accounts SET money=%d,phone=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid) + 1000000, GetPlayerAccountID(playerid));
											mysql_query(mysql, query, false);

											if(!mysql_errno())
											{
												if(GetBusinessData(businessid, B_PRODS) >= take_prods)
												{
													SetBusinessData(businessid, B_PRODS, 10_000);
													AddBusinessData(businessid, B_BALANCE, +, price/2);
												}

												mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
												mysql_query(mysql, query, false);

												GivePlayerMoneyEx(playerid, -price, "Покупка телефона", false, true);
												SetPlayerData(playerid, P_PHONE, GetPlayerAccountID(playerid) + 1000000);

												SendClientMessage(playerid, 0x66CC00FF, "Используйте {0099FF}/c(/call) или /call [номер телефона] {66CC00}чтобы сделать звонок.");
												SendClientMessage(playerid, 0x66CC00FF, "Для отправки SMS сообщения используйте {0099FF}/sms{66CC00}. Другие команды: {0099FF}/menu > Список команд > Общение");

												format
												(
													query, sizeof query,
													"{FFFFFF}Поздравляем!\n"\
													"Вы купили мобильный телефон. Ваш номер: {0099FF}%d",
													GetPlayerPhone(playerid)
												);
												Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}Покупка мобильного телефона", query, "Закрыть", "");

												SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Приобрести телефон'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
											    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

											    SetPlayerData(playerid, P_QUEST_2, 1);
											    UpdatePlayerDatabaseInt(playerid, "quest_2", 1);
											    
											    AddPlayerData(playerid, P_TOP_5, +, 1);
												UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
											}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 25)");
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Мобильный телефон стоит 2100 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас уже есть мобильный телефон");
								}
								case 2:
								{
									price = 450;
									if(Inventory11_PlayerHasPhoneDevice(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
												"{66CC00}Изменение номера",
												"{FFFFFF}Введите новый номер в поле ниже\n\n"\
												"{FF6633}Примечания:\n"\
												"{FFCD00}- Номер должен быть шестизначным,\n"\
												"например: 284411\n"\
												"- Номер не должен начинаться с 0\n\n"\
												"{FFFFFF}Вы также можете вернуть свой\n"\
												"стандартный номер. Для этого\n"\
												"введите в поле {3399FF}цифру 0",
												"Сменить", "Отмена"
											);

											return 1;
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Для изменение номера телефона необходимо 450 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 3:
								{
									price = 200;
									if(GetPlayerPhone(playerid))
									{
										if(GetPlayerMoneyEx(playerid) >= price)
										{
											Dialog
											(
												playerid, DIALOG_BIZ_CHANGE_PHONE_COLOR, DIALOG_STYLE_LIST,
												"{66CC00}Изменение цвета телефона",
												"1. Карамельный\n"\
												"2. Синий\n"\
												"3. Оранжевый\n"\
												"4. Серебристый\n"\
												"5. Розовый\n"\
												"6. Красный\n"\
												"7. Зеленый\n"\
												"8. Темно-синий\n"\
												"9. Желтый\n"\
												"10. Белый",
												"Поменять", "Отмена"
											);

											return 1;
										}
					else SendClientMessage(playerid, 0xCECECEFF, "Для изменение цвета телефона необходимо 200 рублей");
									}
					else SendClientMessage(playerid, 0x999999FF, "Сначала нужно приобрести мобильный телефон");

									callcmd::buy(playerid, "");
								}
								case 4:
								{
									if(GetPlayerPhone(playerid) != 0)
									{
										Dialog
										(
											playerid, DIALOG_BIZ_PHONE_BALANCE, DIALOG_STYLE_INPUT,
											"{FFCD00}Пополнение мобильного телефона",
											"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
											"Готово", "Назад"
										);

										return 1;
									}
					else SendClientMessage(playerid, 0x999999FF, "У Вас нет телефона. Его можно купить в 24/7");

									callcmd::buy(playerid, "");
								}
								default:
									return 1;
							}
						}
					}
				}
			}
			case DIALOG_BIZ_PHONE_BALANCE:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7) || IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							new sum = strval(inputtext);
							if(sum > 0 && IsNumeric(inputtext))
							{
								if(GetPlayerMoneyEx(playerid) >= sum)
								{
									new query[128];

									format(query, sizeof query, "UPDATE accounts SET money=%d,phone_balance=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-sum, GetPlayerData(playerid, P_PHONE_BALANCE)+sum, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										GivePlayerMoneyEx(playerid, -sum, "Пополнение счета телефона", false, true);
										AddPlayerData(playerid, P_PHONE_BALANCE, +, sum);

										format(query, sizeof query, "Вы пополнили счет мобильного телефона на {FF9900}%d руб", sum);
										SendClientMessage(playerid, 0x66CC00FF, query);

										format(query, sizeof query, "Сейчас на счету %d руб", GetPlayerData(playerid, P_PHONE_BALANCE));
										SendClientMessage(playerid, 0x66CC00FF, query);

										return 1;
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 15)");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас не хватает денег");
							}

							Dialog
							(
								playerid, DIALOG_BIZ_PHONE_BALANCE, DIALOG_STYLE_INPUT,
								"{FFCD00}Пополнение мобильного телефона",
								"{FFFFFF}Укажите сумму, на которую хотите пополнить счёт:",
								"Готово", "Назад"
							);
						}
					else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_NUMBER:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7) || IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							new buffer = strlen(inputtext);
							if((1 <= buffer <= 10) && IsNumeric(inputtext))
							{
								new fmt_str[255];
								new number = strval(inputtext);

								new price = 450;
								new take_prods = 75;

								if(number > 0)
								{
									if(inputtext[0] != '0' && buffer == 6)
									{
										buffer = 0;

										if(!Inventory11_IsSimNumberReserved(number))
										{
											if(GetPlayerMoneyEx(playerid) >= price)
                                            {
                                                if(TrunkTest_GetFreeInventorySlot(playerid) == -1)
                                                    return ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");

                                                if(!Inventory11_CanAddItemWeight(playerid, 58, 1))
                                                    return ShowNotificationNew(playerid, 2, 6, 0, 0, "Превышен максимальный вес инвентаря", " ");

                                                // Create the SIM item first. If payment persistence fails, roll it back.
                                                new sim_slot = Inventory11_AddItemToDatabase(playerid, 58, 1, 1, number, 0);
                                                if(sim_slot == -1)
                                                    return SendClientMessage(playerid, 0xFF6600FF, "Ошибка выдачи SIM-карты в инвентарь");

                                                if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                                {
                                                    format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
                                                }
                                                else format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
                                                mysql_query(mysql, fmt_str, false);

                                                if(!mysql_errno())
                                                {
                                                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                                    {
                                                        SetBusinessData(businessid, B_PRODS, 10_000);
                                                        AddBusinessData(businessid, B_BALANCE, +, price/2);
                                                    }

                                                    mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
                                                    mysql_query(mysql, fmt_str, false);

                                                    GivePlayerMoneyEx(playerid, -price, "Покупка SIM-карты", false, true);

                                                    format
                                                    (
                                                        fmt_str, sizeof fmt_str,
                                                        "{FFFFFF}Новая SIM-карта добавлена в инвентарь\n"\
                                                        "Используйте ее, чтобы установить номер {0099FF}%d",
                                                        number
                                                    );
                                                    return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}SIM-карта куплена", fmt_str, "Закрыть", "");
												}
					else
                                                {
                                                    Inventory11_DeleteSlotFromDatabase(playerid, sim_slot);
                                                    SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения покупки, SIM-карта возвращена продавцу");
                                                }
											}
					else
											{
												return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег");
											}
										}
					else SendClientMessage(playerid, 0xFF6600FF, "Введенный Вами номер уже занят");
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Номер введен некорректно. Повторите попытку");
								}
					else
								{
                                    // REAL SIM FIX: input 0 buys a default SIM item; it is NOT auto-installed.
                                    new default_sim_number = GetPlayerAccountID(playerid) + 1000000;
                                    if(Inventory11_IsSimNumberReserved(default_sim_number))
                                        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Эта стандартная SIM-карта уже существует", " ");
                                    if(GetPlayerMoneyEx(playerid) < price)
                                        return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно денег");
                                    if(TrunkTest_GetFreeInventorySlot(playerid) == -1)
                                        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету места в инвентаре", " ");
                                    if(!Inventory11_CanAddItemWeight(playerid, 58, 1))
                                        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Превышен максимальный вес инвентаря", " ");

                                    new default_sim_slot = Inventory11_AddItemToDatabase(playerid, 58, 1, 1, default_sim_number, 0);
                                    if(default_sim_slot == -1)
                                        return SendClientMessage(playerid, 0xFF6600FF, "Ошибка выдачи SIM-карты в инвентарь");

                                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                        format(fmt_str, sizeof fmt_str, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
                                    else
                                        format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
                                    mysql_query(mysql, fmt_str, false);
                                    if(mysql_errno())
                                    {
                                        Inventory11_DeleteSlotFromDatabase(playerid, default_sim_slot);
                                        return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения покупки, SIM-карта возвращена");
                                    }

                                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                                    {
                                        SetBusinessData(businessid, B_PRODS, 10_000);
                                        AddBusinessData(businessid, B_BALANCE, +, price/2);
                                    }
                                    mysql_format(mysql, fmt_str, sizeof fmt_str, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
                                    mysql_query(mysql, fmt_str, false);
                                    GivePlayerMoneyEx(playerid, -price, "Покупка SIM-карты", false, true);
                                    format(fmt_str, sizeof fmt_str, "{FFFFFF}SIM-карта с номером {0099FF}%d{FFFFFF} добавлена в инвентарь. Установите ее вручную.", default_sim_number);
                                    return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}SIM-card", fmt_str, "Закрыть", "");
								}

							}

							Dialog
							(
								playerid, DIALOG_BIZ_CHANGE_PHONE_NUMBER, DIALOG_STYLE_INPUT,
								"{66CC00}Изменение номера",
								"{FFFFFF}Введите новый номер в поле ниже\n\n"\
								"{FF6633}Примечания:\n"\
								"{FFCD00}- Номер должен быть шестизначным,\n"\
								"например: 284411\n"\
								"- Номер не должен начинаться с 0\n\n"\
								"{FFFFFF}Вы также можете вернуть свой\n"\
								"стандартный номер. Для этого\n"\
								"введите в поле {3399FF}цифру 0",
								"Сменить", "Отмена"
							);
						}
					else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_CHANGE_PHONE_COLOR:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7) || IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CELL_SALON))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new price = 200;
								new take_prods = 50;

								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[255];

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,a.phone_color=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, listitem, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
					else format(query, sizeof query, "UPDATE accounts SET money=%d,phone_color=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-price, listitem, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, price/2);
										}

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);

										GivePlayerMoneyEx(playerid, -price, "Смена цвета телефона", false, true);

										SetPlayerData(playerid, P_PHONE_COLOR, listitem);
										SendClientMessage(playerid, 0x3399FFFF, "Вы изменили цвет своего мобильного телефона");
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 27)");
								}
					else SendClientMessage(playerid, 0xCECECEFF, "Для изменение цвета телефона необходимо 200 рублей");
							}
						}
					else callcmd::buy(playerid, "");
					}
				}
			}
			case DIALOG_BIZ_LOTTERY:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_SHOP_24_7))
					{
						if(response)
						{
							if(strlen(inputtext))
							{
								new number = strval(inputtext);
								if(100 <= number <= 999 && IsNumeric(inputtext))
								{
									new fmt_str[64];
									SetPlayerData(playerid, P_LOTTERY, number);

									format(fmt_str, sizeof fmt_str, "Счастливое число изменено на {00CCCC}%d", number);
									SendClientMessage(playerid, 0x66CC00FF, fmt_str);
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Счастливое число не было изменено, т.к. было введено неверно");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_CLUB:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CLUB, 15.0)
					|| IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CASINO, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= 9)
							{
								new const
									item_price[10] = {60, 100, 200, 270, 300, 450, 630, 750, 50, 80};

								if(GetPlayerMoneyEx(playerid) >= item_price[listitem])
								{
									new query[255];
									new take_prods = 1;

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-item_price[listitem], 10_000, GetBusinessData(businessid, B_BALANCE)+item_price[listitem], GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
					else format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid)-item_price[listitem], GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, item_price[listitem]);
										}
										GivePlayerMoneyEx(playerid, -item_price[listitem], "Покупка в клубе/казино", false, true);
										GivePlayerDrinkItem(playerid, listitem);

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), item_price[listitem], IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);

										switch(listitem+1)
										{
											case 1: Action(playerid, "купил(а) банку лимонада", 	15.0, false);
											case 2: Action(playerid, "купил(а) бутылку пива", 		15.0, false);
											case 3: Action(playerid, "купил(а) бутылку вина", 		15.0, false);
											case 4: Action(playerid, "купил(а) бутылку шампанского",15.0, false);
											case 5: Action(playerid, "купил(а) бутылку водки", 		15.0, false);
											case 6: Action(playerid, "купил(а) бутылку коньяка",	15.0, false);
											case 7: Action(playerid, "купил(а) бутылку виски", 		15.0, false);
											case 8: Action(playerid, "купил(а) бутылку абсента", 	15.0, false);
											case 9: Action(playerid, "купил(а) закуску", 			15.0, false);
											case 10:Action(playerid, "купил(а) сигару", 			15.0, false);
										}
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 22)");
								}
					else SendClientMessage(playerid, 0x999999FF, "У Вас не хватает денег");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_BIZ_LIST:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							if(0 <= listitem <= MAX_BUSINESS-1)
							{
								new price = 70; //

								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new fmt_str[300];
									GivePlayerMoneyEx(playerid, -price, "Просмотр инфо о бизнесе (управление статистики)", true, true);

									businessid = g_business_realtor_list_idx[listitem];
									SetPlayerUseListitem(playerid, businessid);
									new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
									GetCityName(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), city);
									GetAreaName(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), area);
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Название:\t\t\t%s\n"\
										"Номер бизнеса:\t\t%d\n"\
										"Город / область:\t\t%s\n"\
										"Район:\t\t\t\t%s\n"\
										"Стоимость:\t\t\t%d\n\n"\
										"{FFFFFF}Вы также можете посмотреть фотографию бизнеса.\n"\
										"Для этого нажмите кнопку \"Фото\". {FFCD00}Услуга стоит 290 руб",
										GetBusinessData(businessid, B_NAME),
										businessid,
										city,
										area,
										GetBusinessData(businessid, B_PRICE)
									);
									Dialog(playerid, DIALOG_BIZ_REALTOR_BIZ_INFO, DIALOG_STYLE_MSGBOX, "{CC9900}Информация о выбранном бизнесе", fmt_str, "Фото", "Закрыть");
								}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_BIZ_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_BIZ, 15.0))
					{
						if(response)
						{
							new price = 290; //

							businessid = GetPlayerUseListitem(playerid);
							if(GetPlayerMoneyEx(playerid) >= price)
							{
								GivePlayerMoneyEx(playerid, -price, "Просмотр фото бизнеса (управление статистики)", true, true);

								TogglePlayerSpectating(playerid, true);
								//ShowPlayerWaitPanel(playerid);

								SetPlayerVirtualWorld(playerid, playerid + 50);
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {99CC00}~k~~PED_SPRINT~ {FFFFFF}для выхода");

								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_BIZ);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_BIZ, businessid);
							}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_GET:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 50;
							new houseid = strval(inputtext);

							if(strlen(inputtext) && IsNumeric(inputtext) && (0 <= houseid <= g_house_loaded-1))
							{
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									GivePlayerMoneyEx(playerid, -price, "Просмотр инфо о доме (риелторское агенство)", true, true);

									new fmt_str[256];
									new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
									new type = GetHouseData(houseid, H_TYPE);
									new entranceid = GetHouseData(houseid, H_ENTRACE);

									SetPlayerUseListitem(playerid, houseid);
									if(entranceid != -1)
									{
										GetCityName(GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), city);
										GetAreaName(GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), area);
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Тип / название:\t\t%s\n"\
											"Номер квартиры:\t\t%d\n"\
											"Номер подъезда:\t\t%d\n"\
											"Город / область:\t\t%s\n"\
											"Район:\t\t\t\t%s\n"\
											"Стоимость:\t\t\t%d\n"\
											"Количество комнат:\t\t%d\n"\
											"Статус:\t\t\t\t%s\n\n"\
											"{FFFFFF}Вы можете посмотреть как выглядит подъезд этой квартиры\n"\
											"Для этого нажмите кнопку \"Фото\". {FFCD00}Услуга стоит 250 рублей",
											GetHouseData(houseid, H_NAME),
											GetHouseData(houseid, H_FLAT_ID) + 1,
											entranceid + 1,
											city,
											area,
											GetHouseData(houseid, H_PRICE),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}Квартира занята") : ("{00CC33}Квартира свободна")
										);
									}
					else
									{
										GetCityName(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), city);
										GetAreaName(GetHouseData(houseid, H_POS_X), GetHouseData(houseid, H_POS_Y), area);
										new fmt_str[200];
										
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Тип / название:\t\t%s\n"\
											"Номер дома:\t\t\t%d\n"\
											"Город / область:\t\t%s\n"\
											"Район:\t\t\t\t%s\n"\
											"Стоимость:\t\t\t%d\n"\
											"Количество комнат:\t\t%d\n"\
											"Статус:\t\t\t\t%s\n\n"\
											"{FFFFFF}Вы можете посмотреть как выглядит дом\n"\
											"Для этого нажмите кнопку \"Фото\". {FFCD00}Услуга стоит 250 рублей",
											GetHouseData(houseid, H_NAME),
											houseid + 1,
											city,
											area,
											GetHouseData(houseid, H_PRICE),
											GetHouseTypeInfo(type, HT_ROOMS),
											IsHouseOwned(houseid) ? ("{FF6600}Дом занят") : ("{00CC33}Дом свободен")
										);
									}
									Dialog(playerid, DIALOG_BIZ_REALTOR_HOME_INFO, DIALOG_STYLE_LIST, "{FF9933}Информация о выбранном доме", fmt_str, "Фото", "Назад");
								}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
							}
					else
							{
								if(!(0 <= houseid <= g_house_loaded-1))
									SendClientMessage(playerid, 0xCECECEFF, "Этот дом еще не построили");

								ShowPlayerRealtorHomeDialog(playerid);
							}
						}
					}
				}
			}
			case DIALOG_BIZ_REALTOR_HOME_INFO:
			{
				new businessid = GetPlayerInBiz(playerid);
				if(businessid != -1)
				{
					if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_REALTOR_HOME, 15.0))
					{
						if(response)
						{
							new price = 250; //

							if(GetPlayerMoneyEx(playerid) >= price)
							{
								GivePlayerMoneyEx(playerid, -price, "Просмотр фото дома (риелторское агенство)", true, true);

								TogglePlayerSpectating(playerid, true);
								//ShowPlayerWaitPanel(playerid);

								SetPlayerVirtualWorld(playerid, playerid + 3000);
								SendClientMessage(playerid, 0xFFFFFFFF, "Используйте {00CC99}~k~~PED_SPRINT~ {FFFFFF}для выхода");

								SetPlayerData(playerid, P_REALTOR_TYPE, REALTOR_TYPE_HOUSE);
								SetTimerEx("SetRealtorMakePhoto", 1000, false, "iii", playerid, REALTOR_TYPE_HOUSE, GetPlayerUseListitem(playerid));
							}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
						}
					else ShowPlayerRealtorHomeDialog(playerid);
					}
				}
			}
			case DIALOG_BIZ_CLOTHING_BUY:
			{
				new businessid = GetPlayerInBiz(playerid);
				print("ч");
				if(businessid != -1)
				{
						if(response)
						{
							new select_skin = GetPlayerSelectSkin(playerid);
							if(select_skin != -1)
							{
								new price = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][1];
								new skinid = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][0];

								new take_prods = random(8) + 6;
								new biz_price = price * 20 / 100;

								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[255];
									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,business b SET a.skin=%d,a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", skinid, GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_BALANCE)+biz_price, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									}
					else format(query, sizeof query, "UPDATE accounts SET skin=%d,money=%d WHERE id=%d LIMIT 1", skinid, GetPlayerMoneyEx(playerid)-price, GetPlayerAccountID(playerid));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, biz_price);
										}
										GivePlayerMoneyEx(playerid, -price, "Покупка скина (магазин одежды)", false, true);
										SetPlayerData(playerid, P_SKIN, skinid);

										ExitPlayerClothingShopPanel(playerid);
										SendClientMessage(playerid, 0x66CC00FF, "Поздравляем с покупкой новой одежды!");

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);

										AddPlayerData(playerid, P_QUEST_EXP_6, +, 1);
										UpdatePlayerDatabaseInt(playerid, "quest_exp_6", GetPlayerData(playerid, P_QUEST_EXP_6));

										if(GetPlayerData(playerid, P_QUEST_EXP_6) == 1)
										{
										    SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы успешно выполнили квест {009900}'Одеться по приличнее'. {ffffff}Ваша награда: {009900}5000 руб, 1exp");
				                                SendClientMessage(playerid, COR_SERVER, "{ffffff}Введите {009900}/quest{ffffff},для подробной информации по Вашим квестам");
										    GivePlayerMoneyEx(playerid, 5000, "Выполнение квеста");

										    SetPlayerData(playerid, P_QUEST_6, 1);
										    UpdatePlayerDatabaseInt(playerid, "quest_6", 1);
										    
										    AddPlayerData(playerid, P_TOP_5, +, 1);
											UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
										}
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 36)");
								}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
							}
						}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_HOUSE_BUY:
			{
				new houseid = GetPlayerUseListitem(playerid);

				if(houseid >= 0 && response)
				{
					if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
					{
						if(GetPlayerHouse(playerid) == -1)
						{
							if(IsPlayerInRangeOfHouse(playerid, houseid, 5.0))
							{
								if(!IsHouseOwned(houseid))
								{
									if(GetPlayerMoneyEx(playerid) >= GetHouseData(houseid, H_PRICE))
									{
									    //if(Config[sBuyBiz] == 0)
							    		//{
										
										BuyPlayerHouse(playerid, houseid);

										EnterPlayerToHouse(playerid, houseid);
										PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);

										GameTextForPlayer(playerid, "~b~welcome ~g~to~n~~y~new ~w~home!", 4000, 1);
										Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новый дом", "{FFFFFF}Вам нужно заплатить за дом в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
								//	}
									//	else
								    	//	return Send(playerid,-1,"В данный момент все дома на сервере не доступны к покупке!");
								    
									}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого дома");
								}
					else
								{
									new fmt_str[64];

									format(fmt_str, sizeof fmt_str, "Этот дом уже куплен. Владелец: %s", GetHouseData(houseid, H_OWNER_NAME));
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
						}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть дом. Чтобы купить новый - необходимо продать старый.");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы снимаете номер в гостинице. Нужно выселиться перед покупкой дома");
				}
			}
			case DIALOG_HOUSE_SELL:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						SellHouse(playerid);
					}
				}
			}
			case DIALOG_HOUSE_INFO:
			{
				if(response)
				{
					new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
					if(houseid != -1)
					{
						ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
					}
				}
			}
			case DIALOG_HOUSE_PARAMS:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						ShowPlayerHouseDialog(playerid, listitem + 1);
					}
					else callcmd::home(playerid, "");
				}
			}
			case DIALOG_HOUSE_IMPROVEMENTS:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= sizeof g_house_improvements - 1)
						{
							new i_level = GetHouseData(houseid, H_IMPROVEMENTS);
							new i_price = g_house_improvements[listitem][I_PRICE];

							if(i_level >= sizeof g_house_improvements)
							{
								SendClientMessage(playerid, 0x999999FF, "Вы уже приобрели все доступные улучшения для дома");
							}
					else if(i_level < listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Этот уровень улучшений пока недоступен");
							}
					else if(i_level > listitem)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили этот уровень улучшений");
							}
					else if(GetPlayerMoneyEx(playerid) < i_price)
							{
								new fmt_str[64];

								format(fmt_str, sizeof fmt_str, "Для покупки %d уровня улучшений необходимо %d рублей", listitem + 1, i_price);
								SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							}
					else if(i_level == 6 && GetHouseData(houseid, H_ENTRACE) != -1)
							{
								SendClientMessage(playerid, 0xCECECEFF, "Недоступно для квартир");
							}
					else
							{
								new fmt_str[128];

								format(fmt_str, sizeof fmt_str, "UPDATE accounts a, houses h SET a.money=%d, h.improvements=%d WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-i_price, i_level + 1, GetPlayerAccountID(playerid), GetHouseData(houseid, H_SQL_ID));
								mysql_query(mysql, fmt_str, false);

								if(!mysql_errno())
								{
									GivePlayerMoneyEx(playerid, -i_price, "Покупка улучшений для дома", false, true);

									format(fmt_str, sizeof fmt_str, "Вы улучшили свой дом до {FFCD00}%s {3399FF}уровня", GetNumericName(listitem + 1));
									SendClientMessage(playerid, 0x3399FFFF, fmt_str);

									AddHouseData(houseid, H_IMPROVEMENTS, +, 1);
									switch(listitem + 1)
									{
										case 1:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Теперь чтобы выйти из дома достаточно нажать {FF9900}~k~~SNEAK_ABOUT~{66CC00}, стоя у двери");
											SendClientMessage(playerid, 0x999999FF, "Автоматические двери облегчат жизнь в Вашем доме");
										}
										case 2:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Теперь в доме всегда будет доступна аптечка");
											SendClientMessage(playerid, 0x999999FF, "Вы и ваши гости в любой момент можете использовать ее");

											HouseHealthInit(houseid);
										}
										case 3:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Вы можете разрешить людям проживать в Вашем доме с помощью команды {FF9900}/live");
											SendClientMessage(playerid, 0x999999FF, "В доме могут разместиться столько гостей, сколько в нем комнат");
										}
										case 4:
										{
											SendClientMessage(playerid, 0x66CC00FF, "На Ваше имя была оформлена субсидия, которая дает право платить пониженную квартплату");
											SendClientMessage(playerid, 0x999999FF, "Благодаря этому, ежедневная квартплата уменьшена в 2 раза");
										}
										case 5:
										{
											SendClientMessage(playerid, 0x66CC00FF, "Используйте {3399FF}/makestore {66CC00}для размещения шкафа. В нем можно будет хранить различные вещи");
											SendClientMessage(playerid, 0x999999FF, "В любой момент можно перенести шкаф на другое место. Для открытия шкафа напишите {3399FF}/use");

											HouseStoreInit(houseid);
										}
										/*
										case 6:
										{
											// сейф
										}
										case 7:
										{
											// сигнализация
										}
										*/
									}
								}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 35)");
							}
						}
					}
					ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTERS:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						if(0 <= listitem <= MAX_HOUSE_ROOMS-1)
						{
							new room = GetPlayerListitemValue(playerid, listitem);
							ShowHouseRenterInfo(playerid, houseid, room);
						}
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_INFO:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							switch(listitem + 1)
							{
								case 4:
								{
									new fmt_str[95];
									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Вы действительно хотите выселить {FFCD00}%s {FFFFFF}из своего дома?",
										GetHouseRenterInfo(houseid, room, HR_OWNER_NAME)
									);
									return Dialog(playerid, DIALOG_HOUSE_RENTER_EVICT, DIALOG_STYLE_MSGBOX, "{33AACC}Выселение арендатора", fmt_str, "Да", "Нет");
								}
							}
							ShowHouseRenterInfo(playerid, houseid, room);
						}
					else SendClientMessage(playerid, 0x999999FF, "В этой комнате уже никто не проживает");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_RENTER_EVICT:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						new room = GetPlayerUseListitem(playerid);
						if(IsHouseRoomOwned(houseid, room))
						{
							new fmt_str[64],
								renter_id = GetPlayerID(GetHouseRenterInfo(houseid, room, HR_OWNER_NAME));

							format(fmt_str, sizeof fmt_str, "Вы выселили %s из своего дома", GetHouseRenterInfo(houseid, room, HR_OWNER_NAME));
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							EvictHouseRenter(houseid, room, renter_id, playerid);
						}
					else SendClientMessage(playerid, 0x999999FF, "В этой комнате уже никто не проживает");
					}
					else ShowPlayerHouseDialog(playerid, HOUSE_OPERATION_PARAMS);
				}
			}
			case DIALOG_HOUSE_EVICT:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_ROOM);
				if(houseid != -1)
				{
					if(response)
					{
						new roomid = GetPlayerData(playerid, P_HOUSE_ROOM);
						new owner_id = GetPlayerID(GetHouseData(houseid, H_OWNER_NAME));

						EvictHouseRenter(houseid, roomid, playerid);

						if(owner_id != INVALID_PLAYER_ID)
						{
							new fmt_str[45 + 1];

							format(fmt_str, sizeof fmt_str, "%s выселился из Вашего дома", GetPlayerNameEx(playerid));
							SendClientMessage(owner_id, 0x66CC00FF, fmt_str);
						}
						SendClientMessage(playerid, 0x66CC00FF, "Вы выселились из дома");
					}
				}
			}
			case DIALOG_HOUSE_MOVE_STORE:
			{
				new houseid = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
				if(houseid != -1)
				{
					if(response)
					{
						if(GetPlayerInHouse(playerid) == houseid)
						{
							if(GetHouseData(houseid, H_IMPROVEMENTS) >= 5)
							{
								new type = GetHouseData(houseid, H_TYPE);
								if(IsPlayerInRangeOfPoint(playerid, 50.0, GetHouseTypeInfo(type, HT_ENTER_POS_X), GetHouseTypeInfo(type, HT_ENTER_POS_Y), GetHouseTypeInfo(type, HT_ENTER_POS_Z)))
								{
									if(GetHouseData(houseid, H_STORE_LABEL) != Text3D:-1)
									{
										new query[128];

										new Float: pos_x, Float: pos_y, Float: pos_z;
										GetPlayerPos(playerid, pos_x, pos_y, pos_z);

										SetHouseData(houseid, H_STORE_X, pos_x);
										SetHouseData(houseid, H_STORE_Y, pos_y);
										SetHouseData(houseid, H_STORE_Z, pos_z);

										DestroyDynamic3DTextLabel(GetHouseData(houseid, H_STORE_LABEL));
										SetHouseData(houseid, H_STORE_LABEL, Text3D:-1);

										HouseStoreInit(houseid);

										format(query, sizeof query, "UPDATE houses SET store_x=%f,store_y=%f,store_z=%f WHERE id=%d LIMIT 1", pos_x, pos_y, pos_z, GetHouseData(houseid, H_SQL_ID));
										mysql_tquery(mysql, query, "", "");
									}
								}
							}
						}
					}
				}
			}
			case DIALOG_HOUSE_STORE:
			{
				if(response)
				{
					new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);

					new item_name[2][10] = {"Материалы", "наркотики"},
							title[32];

					if(0 <= listitem <= 1)
					{
						format(title, sizeof title, "{FFCD00}Положить %s", item_name[listitem]);

						Dialog
						(
							playerid, DIALOG_HOUSE_STORE_PUT, DIALOG_STYLE_INPUT,
							title,
							"{FFFFFF}Введите количество, которое Вы хотите {FFCD00}положить:",
							"Положить", "Отмена"
						);

						SetPVarInt(playerid, "store_index", listitem);
					}
					else if(4 <= listitem <= 5)
					{
						format(title, sizeof title, "{FFCD00}Взять %s", item_name[listitem - 4]);

						Dialog
						(
							playerid, DIALOG_HOUSE_STORE_TAKE, DIALOG_STYLE_INPUT,
							title,
							"{FFFFFF}Введите количество, которое Вы хотите {FFCD00}взять:",
							"Взять", "Отмена"
						);

						SetPVarInt(playerid, "store_index", listitem - 4);
					}
					else
					{
						new query[80];

						switch(listitem)
						{
							case 2:
							{
								if(GetHouseData(house_id, H_STORE_WEAPON))
									SendClientMessage(playerid, 0x999999FF, "Место в шкафу уже занято другим оружием");

								else
								{
									new weapon_id = GetPlayerWeapon(playerid),
										weapon_ammo = GetPlayerAmmo(playerid);

									if(!weapon_id)
										SendClientMessage(playerid, 0x999999FF, "У Вас в руках нет оружия");

									else
									{
										if(weapon_ammo > 3000)
											SendClientMessage(playerid, 0x999999FF, "В шкаф не вместится такое количество патронов");

										else
										{
											if(weapon_id == 23 || weapon_id == 24
											|| weapon_id == 25 || weapon_id == 29
											|| weapon_id == 30 || weapon_id == 31
											|| weapon_id == 33 || weapon_id == 34)
											{
												SetHouseData(house_id, H_STORE_WEAPON, 	weapon_id);
												SetHouseData(house_id, H_STORE_AMMO, 	weapon_ammo);

												SetPlayerAmmo(playerid, weapon_id, 0);

												mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_weapon=%d, store_ammo=%d WHERE id=%d",
												weapon_id, weapon_ammo, GetHouseData(house_id, H_SQL_ID));
												mysql_query(mysql, query, false);

												format(query, sizeof query, "Вы положили %s в шкаф", GetWeaponName(weapon_id));
												SendClientMessage(playerid, 0x3399FFFF, query);
											}
					else SendClientMessage(playerid, 0x999999FF, "Вы не можете класть этот тип оружия в шкаф");
										}
									}
								}
							}
							case 3:
							{
								if(!GetPlayerTeamEx(playerid))
								{
									if(GetHouseData(house_id, H_STORE_SKIN))
										SendClientMessage(playerid, 0x999999FF, "Место в шкафу уже занято другой одеждой");

									else
									{
										SetHouseData(house_id, H_STORE_SKIN, GetPlayerData(playerid, P_SKIN));

										mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_skin=%d WHERE id=%d",
										GetPlayerSkinEx(playerid), GetHouseData(house_id, H_SQL_ID));
										mysql_query(mysql, query, false);

										SetPlayerData(playerid, P_SKIN, 97);
										UpdatePlayerDatabaseInt(playerid, "skin", 97);

										SetPlayerSkin(playerid, 97);

										SendClientMessage(playerid, 0x3399FFFF, "Вы положили свою одежду в шкаф");
									}
								}
					else SendClientMessage(playerid, 0x999999FF, "Вы не можете хранить в шкафу одежду организации");
							}
							case 6:
							{
								if(!GetHouseData(house_id, H_STORE_WEAPON))
									SendClientMessage(playerid, 0x999999FF, "В шкафу нет оружия");

								else
								{
									new weapon_id = GetHouseData(house_id, H_STORE_WEAPON),
										weapon_ammo = GetHouseData(house_id, H_STORE_AMMO);

									GivePlayerWeapon(playerid, weapon_id, weapon_ammo);

									SetHouseData(house_id, H_STORE_WEAPON, 	0);
									SetHouseData(house_id, H_STORE_AMMO, 	0);

									mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_weapon=0, store_ammo=0 WHERE id=%d",
									GetHouseData(house_id, H_SQL_ID));
									mysql_query(mysql, query, false);

									format(query, sizeof query, "Вы достали из шкафа %s и %d патр.", GetWeaponName(weapon_id), weapon_ammo);
									SendClientMessage(playerid, 0x3399FFFF, query);
								}
							}
							case 7:
							{
								if(!GetPlayerTeamEx(playerid))
								{
									if(!GetHouseData(house_id, H_STORE_SKIN))
										SendClientMessage(playerid, 0x999999FF, "В шкафу нет одежды");

									else
									{
										SetPlayerData(playerid, P_SKIN, GetHouseData(house_id, H_STORE_SKIN));
										UpdatePlayerDatabaseInt(playerid, "skin", GetHouseData(house_id, H_STORE_SKIN));

										SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));

										SetHouseData(house_id, H_STORE_SKIN, 	0);

										mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_skin=0 WHERE id=%d",
										GetHouseData(house_id, H_SQL_ID));
										mysql_query(mysql, query, false);

										SendClientMessage(playerid, 0x3399FFFF, "Вы переоделись в одежду из шкафа");
									}
								}
					else SendClientMessage(playerid, 0x999999FF, "Вы не можете переодеться, находясь в организации");
							}
						}

						UpdateHouseStore(house_id);

						callcmd::use(playerid, "");
					}
				}
			}
			case DIALOG_HOUSE_STORE_TAKE:
			{
				if(response)
				{
					new value = strval(inputtext),
						house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME),
						query[55];

					if(value < 1)
						SendClientMessage(playerid, 0x999999FF, "Некорректное значение");

					else
					{
						switch(GetPVarInt(playerid, "store_index"))
						{
							case 0:
							{
								if(value > GetHouseData(house_id, H_STORE_METALL))
									SendClientMessage(playerid, 0x999999FF, "В шкафу нет такого количества Материалыа");

								else
								{
									if(GetPlayerData(playerid, P_METALL) + value > GetPlayerMaxStorage(playerid, STORAGE_METALL))
										SendClientMessage(playerid, 0xCECECEFF, "Вы не сможете унести с собой такое количество Материалыа");

									else
									{
										AddPlayerData(playerid, P_METALL, +, value);
										UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

										SetHouseData(house_id, H_STORE_METALL, GetHouseData(house_id, H_STORE_METALL) - value);

										mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_metall=%d WHERE id=%d",
										GetHouseData(house_id, H_STORE_METALL), GetHouseData(house_id, H_SQL_ID));
										mysql_query(mysql, query, false);

										format(query, sizeof query, "Вы достали из шкафа %d кг Материалыа", value);
										SendClientMessage(playerid, 0x3399FFFF, query);
									}
								}
							}
							case 1:
							{
								if(value > GetHouseData(house_id, H_STORE_DRUGS))
									SendClientMessage(playerid, 0x999999FF, "В шкафу нет такого количества наркотиков");

								else
								{
									if(GetPlayerData(playerid, P_DRUGS) + value > GetPlayerMaxStorage(playerid, STORAGE_DRUGS))
										SendClientMessage(playerid, 0xCECECEFF, "Вы не сможете унести с собой такое количество наркотиков");

									else
									{
										AddPlayerData(playerid, P_DRUGS, +, value);
										UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_DRUGS));

										SetHouseData(house_id, H_STORE_DRUGS, GetHouseData(house_id, H_STORE_DRUGS) - value);

										mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_drugs=%d WHERE id=%d",
										GetHouseData(house_id, H_STORE_DRUGS), GetHouseData(house_id, H_SQL_ID));
										mysql_query(mysql, query, false);

										format(query, sizeof query, "Вы достали из шкафа %d г наркотиков", value);
										SendClientMessage(playerid, 0x3399FFFF, query);
									}
								}
							}
						}

						UpdateHouseStore(house_id);
					}
				}

				callcmd::use(playerid, "");
			}
			case DIALOG_HOUSE_STORE_PUT:
			{
				if(response)
				{
					new value = strval(inputtext),
						house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME),
						query[55];

					if(value < 1)
						SendClientMessage(playerid, 0x999999FF, "Некорректное значение");

					else
					{
						switch(GetPVarInt(playerid, "store_index"))
						{
							case 0:
							{
								if(value > GetPlayerData(playerid, P_METALL))
									SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества Материалыа");

								else
								{
									if(GetHouseData(house_id, H_STORE_METALL) + value > 700)
										SendClientMessage(playerid, 0x999999FF, "В шкафу не хватает места");

									else
									{
										AddPlayerData(playerid, P_METALL, -, value);
										UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

										SetHouseData(house_id, H_STORE_METALL, GetHouseData(house_id, H_STORE_METALL) + value);

										mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_metall=%d WHERE id=%d",
										GetHouseData(house_id, H_STORE_METALL), GetHouseData(house_id, H_SQL_ID));
										mysql_query(mysql, query, false);

										format(query, sizeof query, "Вы положили в шкаф %d кг Материалыа", value);
										SendClientMessage(playerid, 0x3399FFFF, query);
									}
								}
							}
							case 1:
							{
								if(value > GetPlayerData(playerid, P_DRUGS))
									SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества наркотиков");

								else
								{
									AddPlayerData(playerid, P_DRUGS, -, value);
									UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_DRUGS));

									SetHouseData(house_id, H_STORE_DRUGS, GetHouseData(house_id, H_STORE_DRUGS) + value);

									mysql_format(mysql, query, sizeof query, "UPDATE houses SET store_drugs=%d WHERE id=%d",
									GetHouseData(house_id, H_STORE_DRUGS), GetHouseData(house_id, H_SQL_ID));
									mysql_query(mysql, query, false);

									format(query, sizeof query, "Вы положили в шкаф %d г наркотиков", value);
									SendClientMessage(playerid, 0x3399FFFF, query);
								}
							}
						}

						UpdateHouseStore(house_id);
					}
				}

				callcmd::use(playerid, "");
			}

			case DIALOG_HOUSE_ENTER:
			{
				new houseid = GetPlayerUseListitem(playerid);

				if(houseid >= 0 && response)
				{
					if(GetPlayerInHouse(playerid) == -1)
					{
						if(!GetHouseData(houseid, H_LOCK_STATUS) || GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == houseid)
						{
							EnterPlayerToHouse(playerid, houseid);
						}
					else GameTextForPlayer(playerid, "~r~Closed", 3000, 1);
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ENTRANCE_LIFT:
			{
				if(response)
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						new floor = GetPlayerInEntranceFloor(playerid);
						if(floor != -1)
						{
							if(0 <= listitem <= MAX_ENTRANCE_FLOORS-1)
							{
								new to_floor = GetPlayerListitemValue(playerid, listitem);
								if(!to_floor)
								{
									SetPlayerPosEx(playerid, 560.7483,23.6653,1049.2731, -180.0, 1, entranceid + 2500);
								}
					else SetPlayerPosEx(playerid, 560.7483,23.6653,1049.2731, -180.0, 1, to_floor + 1);

								SetPlayerInEntranceFloor(playerid, to_floor);
							}
						}
					}
				}
			}
			/*case DIALOG_ENTRANCE_LIFT:
			{
				if(response)
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						new floor = GetPlayerInEntranceFloor(playerid);
						if(floor != -1)
						{
							if(0 <= listitem <= MAX_ENTRANCE_FLOORS-1)
							{
								new to_floor = GetPlayerListitemValue(playerid, listitem);
								if(!to_floor)
								{
									SetPlayerPosEx(playerid, 560.7483,23.6653,1049.2731, -180.0, 1, entranceid + 2500);
								}
					else SetPlayerPosEx(playerid, 560.7483,23.6653,1049.2731, -180.0, 1, (entranceid * 100) + to_floor);

								SetPlayerInEntranceFloor(playerid, to_floor);
							}
						}
					}
				}
			}
			*/
			// -----------------------------------------------------------------
			case DIALOG_HOTEL:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						switch(listitem + 1)
						{
							case 1:
							{
								ShowPlayerHotelFloorsInfo(playerid, hotel_id);
							}
							case 2:
							{
								if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
								{
									new free_room = GetHotelFreeRoom(hotel_id);
									if(free_room != -1)
									{
										SetPlayerUseListitem(playerid, free_room);

										new fmt_str[128];
										format
										(
											fmt_str, sizeof fmt_str,
											"{FFFFFF}Мы предлагаем Вам поселиться в номере %d на %d этаже\n"\
											"Регистрация стоит 1000 рублей. Вы уверены?",
											(free_room % 12) + 1,
											(free_room / 12) + 1
										);
										Dialog(playerid, DIALOG_HOTEL_REG_ROOM, DIALOG_STYLE_MSGBOX, "{66CC99}Подтверждение регистрации", fmt_str, "Выбрать", "Назад");
									}
					else
									{
										Dialog
										(
											playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
											"{66CC99}Свободные номера",
											"{FFFFFF}В этой гостинице нет свободных номеров",
											"Назад", "Закрыть"
										);
									}
								}
					else
								{
									Dialog
									(
										playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX,
										"{66CC99}Регистрация",
										"{FFFFFF}Вы уже снимаете номер в гостинице",
										"Назад", "Закрыть"
									);
								}
							}
							case 3:
							{
								ShowPlayerHotelClientMenu(playerid, hotel_id);
							}
						}
					}
				}
			}
			case DIALOG_HOTEL_FLOOR_SELECT:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id != -1)
				{
					if(response)
					{
						ShowPlayerHotelFloorInfo(playerid, hotel_id, listitem);
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_INFO:
			{
				if(response)
				{
					ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_FLOOR_LIFT:
			{
				if(response)
				{
					new hotel_id = GetPlayerInHotelID(playerid);
					if(hotel_id != -1)
					{
						new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
						if(0 <= listitem <= max_floors-1)
						{
							new to_floor = GetPlayerListitemValue(playerid, listitem);

							if(!to_floor)
							{
								new businessid = GetPlayerInBiz(playerid);
								new type = GetBusinessData(businessid, B_INTERIOR);

								SetPlayerPosEx(playerid, 730.1479, 599.7930, 1002.9598, 89.9507, GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR), businessid + 255);
							}
					else SetPlayerPosEx(playerid, 1276.0446, -773.2361, 1202.7220, 360.0, to_floor, ((hotel_id + 1) * 200) + (to_floor + 1000));

							SetPlayerData(playerid, P_IN_HOTEL_FLOOR, to_floor);
						}
					}
				}
			}
			case DIALOG_HOTEL_REG_ROOM:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id != -1)
				{
					if(response)
					{
						new room_id = GetPlayerUseListitem(playerid);
						new businessid = GetPlayerInBiz(playerid);

						if(GetPlayerHouse(playerid) == -1)
						{
							if(!IsHotelRoomOwned(hotel_id, room_id))
							{
								new price = 1000;
								new take_prods = 2;

								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[360];
									new time = gettime();
									new rent_time = (time - (time % 86400)) + 86400;

									if(GetBusinessData(businessid, B_PRODS) >= take_prods)
									{
										format(query, sizeof query, "UPDATE accounts a,hotels h,business b SET a.money=%d,a.house_type=%d,a.house_room=%d,a.house=%d,h.owner_id=%d,h.rent_time=%d,h.status=0,b.products=10000,b.balance=%d WHERE a.id=%d AND h.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOTEL, room_id, hotel_id, GetPlayerAccountID(playerid), rent_time, 10_000, GetBusinessData(businessid, B_BALANCE)+price, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID),GetBusinessData(businessid, B_SQL_ID));
									}
					else format(query, sizeof query, "UPDATE accounts a, hotels h SET a.money=%d,a.house_type=%d,a.house_room=%d,a.house=%d,h.owner_id=%d,h.rent_time=%d,h.status=0 WHERE a.id=%d AND h.id=%d", GetPlayerMoneyEx(playerid)-price, HOUSE_TYPE_HOTEL, room_id, hotel_id, GetPlayerAccountID(playerid), rent_time, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										if(GetBusinessData(businessid, B_PRODS) >= take_prods)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, price/2);
										}
										SetPlayerData(playerid, P_HOUSE, hotel_id);
										SetPlayerData(playerid, P_HOUSE_ROOM, room_id);
										SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_HOTEL);

										SetHotelData(hotel_id, room_id, H_OWNER_ID, GetPlayerAccountID(playerid));
										SetHotelData(hotel_id, room_id, H_RENT_DATE, 	rent_time);
										SetHotelData(hotel_id, room_id, H_STATUS, 		false);

										format(g_hotel[hotel_id][room_id][H_OWNER_NAME], 21, GetPlayerNameEx(playerid), 0);

										GivePlayerMoneyEx(playerid, -price, "Покупка номера в отеле", false, true);
										EnterPlayerToHotelRoom(playerid, hotel_id, room_id);

										SendClientMessage(playerid, 0x3399FFFF, "Вы сняли номер в гостинице");
										SendClientMessage(playerid, 0x66CC00FF, "Подсказка: оплатить проживание можно на первом этаже у регистрационной стойки");
										SendClientMessage(playerid, 0xFFFFFFFF, "Нажмите {66CC99}~k~~SNEAK_ABOUT~ {FFFFFF}для выхода из номера");

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), price/2, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 37)");
								}
					else SendClientMessage(playerid, 0x999999FF, "У Вас недостаточно денег чтобы снять этот номер");
							}
					else SendClientMessage(playerid, 0xFF6600FF, "Извините, но этот номер уже занят");
						}
					else SendClientMessage(playerid, 0xCECECEFF, "У Вас есть жилье. Нужно продать его перед покупкой номера");
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_CLIENT_MENU:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						switch(listitem + 1)
						{
							case 1: // Оплатить проживание
							{
								ShowPlayerHotelRoomPayForRent(playerid);
							}
							case 2: // Информация о транспорте
							{
								new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
									new model_id = GetVehicleData(vehicleid, V_MODELID);
									if(model_id)
									{
										new fmt_str[64];
										new index = GetVehicleData(vehicleid, V_ACTION_ID);

										format(fmt_str, sizeof fmt_str, "Модель: %s (номер модели %d)", GetVehicleName(vehicleid), model_id);
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);

										if(!(GetOwnableCarData(index, OC_COLOR_1) == -1 || GetOwnableCarData(index, OC_COLOR_2) == -1))
										{
											format(fmt_str, sizeof fmt_str, "Цвет 1: ID %d   Цвет 2: ID %d", GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
											SendClientMessage(playerid, 0x99FF66FF, fmt_str);
										}
					else SendClientMessage(playerid, 0x99FF66FF, "Цвета транспорта: случайные");

										format(fmt_str, sizeof fmt_str, "Гос. стоимость: %d руб", GetVehicleInfo(model_id - 400, VI_PRICE));
										SendClientMessage(playerid, 0x99FF66FF, fmt_str);
									}
								}
					else
								{
									if(GetPlayerOwnableCars(playerid) == 0)
										SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
									else
										SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
								}
							}
							case 3: // Отметить транспорт на GPS
							{
								callcmd::getmycar(playerid, "");
							}
							case 4: // Подогнать транспорт к отелю (1000 руб)
							{
								new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
									if(!SetVehicleToHotelRespawn(hotel_id, vehicleid))
									{
										SendClientMessage(playerid, 0xCECECEFF, "В данный момент Вы не можете использовать эту функцию");
									}
								}
					else
								{
									if(GetPlayerOwnableCars(playerid) == 0)
										SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
									else
										SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
								}
							}
							case 5: // Продать транспорт
							{
								callcmd::sellcar(playerid, "");
							}
							case 6: // Выселиться из отеля
							{
								Dialog
								(
									playerid, DIALOG_HOTEL_OUT, DIALOG_STYLE_MSGBOX,
									"{66CC99}Выселение",
									"{FFFFFF}Вы уверены что хотите выселиться из отеля?",
									"Да", "Нет"
								);
							}
							default:
								return 1;
						}
					}
					else ShowPlayerHotelDialog(playerid);
				}
			}
			case DIALOG_HOTEL_PAY_FOR_ROOM:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						new days = strval(inputtext);
						if(days > 0 && IsNumeric(inputtext))
						{
							new fmt_str[128 + 1];

							new time = gettime();
							new rent_time = GetHotelData(hotel_id, room_id, H_RENT_DATE);

							new rent_days = GetElapsedTime(rent_time, time, CONVERT_TIME_TO_DAYS);
							new total_price = days * 1000;

							if((rent_days + days) <= 30)
							{
								if(GetPlayerBankMoney(playerid) >= total_price)
								{
									rent_time = (rent_time - (rent_time % 86400)) + (days * 86400);

									format(fmt_str, sizeof fmt_str, "UPDATE accounts a, hotels h SET a.bank=%d,h.rent_time=%d WHERE a.id=%d AND h.id=%d", GetPlayerBankMoney(playerid)-total_price, rent_time, GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
									mysql_query(mysql, fmt_str, false);

									if(!mysql_errno())
									{
										AddPlayerData(playerid, P_BANK, -, total_price);
										SetHotelData(hotel_id, room_id, H_RENT_DATE, rent_time);

										format(fmt_str, sizeof fmt_str, "С банковского счета снято {3399FF}%d руб", total_price);
										SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

										format(fmt_str, sizeof fmt_str, "Вы успешно проживание в отеле еще на {3399FF}%d дней", days);
										SendClientMessage(playerid, 0x66CC00FF, fmt_str);
									}
								}
					else
								{
									SendClientMessage(playerid, 0xB5B500FF, "На основном банковском счету не хватает денег для оплаты");

									format(fmt_str, sizeof fmt_str, "Для продления аренды на %d дней необходимо %d руб", days, total_price);
									SendClientMessage(playerid, 0x999999FF, fmt_str);
								}
							}
					else SendClientMessage(playerid, 0xB5B500FF, "Вы не можете оплатить за аренду больше чем на 30 дней");
						}
						ShowPlayerHotelRoomPayForRent(playerid);
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			case DIALOG_HOTEL_OUT:
			{
				new hotel_id = GetPlayerInHotelID(playerid);
				new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

				if(hotel_id == GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL))
				{
					if(response)
					{
						new query[155];

						format(query, sizeof query, "UPDATE accounts a,hotels h SET a.house_type=-1,a.house_room=-1,a.house=-1,h.owner_id=0,h.rent_time=0 WHERE a.id=%d AND h.id=%d", GetPlayerAccountID(playerid), GetHotelData(hotel_id, room_id, H_SQL_ID));
						mysql_query(mysql, query, false);

						if(!mysql_errno())
						{
							SetPlayerData(playerid, P_HOUSE, 		-1);
							SetPlayerData(playerid, P_HOUSE_ROOM, 	-1);
							SetPlayerData(playerid, P_HOUSE_TYPE, 	-1);

							SetHotelData(hotel_id, room_id, H_OWNER_ID, 0);
							SetHotelData(hotel_id, room_id, H_RENT_DATE, 	0);
							SetHotelData(hotel_id, room_id, H_STATUS, 		false);

							SendClientMessage(playerid, 0x3399FFFF, "Вы выселились из отеля");
						}
					}
					else ShowPlayerHotelClientMenu(playerid, hotel_id);
				}
			}
			// -----------------------------------------------------------------
			// -----------------------------------------------------------------
			case DIALOG_OWNABLE_CAR:
			{
				if(response)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
						switch(listitem + 1)
						{
							case 1: // Открыть / закрыть
							{
								callcmd::lock(playerid, "1");
							}
							case 2: // Отметить транспорт на GPS
							{
								callcmd::getmycar(playerid, "");
							}
							case 3: // Содержимое багажника
							{
								TrunkTest_TryOpenNearby(playerid, true);
							}
							case 4: // Документы на транспорт
							{
								ShowOwnableCarPass(playerid, vehicleid);
							}
							case 5: // Снять номерные знаки
                            {
                                if(!IsPlayerNearVehicleForPlate(playerid, vehicleid))
                                    return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к личному транспорту");

                                new index = GetVehicleData(vehicleid, V_ACTION_ID);
                                if(index == -1)
                                    return SendClientMessage(playerid, 0xCECECEFF, "Ошибка: транспорт не найден");

                                if(!OwnableCarHasInstalledPlate(index))
                                    return SendClientMessage(playerid, 0xCECECEFF, "На транспорте нет установленного номера");

                                new plate_type;
                                new plate[16], region[8];
                                if(!ParseStoredPlateValue(g_ownable_car[index][OC_NUMBER], plate_type, plate, sizeof(plate), region, sizeof(region)))
                                    return SendClientMessage(playerid, 0xCECECEFF, "Не удалось прочитать установленный номер");

                                new inv_item_id = PlateTypeToItemId(plate_type);
                                new inv_model_id = PlateItemIdToModel(inv_item_id);
                                new inv_slot = Inventory11_AddItemToDatabase(playerid, inv_item_id, inv_model_id, 1, 0, 0);
            printf("[PLATES][TRACE] AddItem result: player=%d item=%d slot=%d errno=%d", playerid, inv_item_id, inv_slot, mysql_errno());
                                if(inv_slot == -1)
                                    return SendClientMessage(playerid, 0xCECECEFF, "Не удалось вернуть номер в инвентарь");

                                if(!Inventory11_SavePlateData(playerid, inv_slot, plate_type, plate, region))
                                {
                                    printf("[PLATES][ERROR] SavePlateData returned false: player=%d slot=%d errno=%d", playerid, inv_slot, mysql_errno());
                Inventory11_DeleteSlotFromDatabase(playerid, inv_slot);
                                    return SendClientMessage(playerid, 0xCECECEFF, "Ошибка сохранения номера в инвентарь");
                                }

                                format(g_ownable_car[index][OC_NUMBER], 32, "");
                                ClearVehicleNumberPlate(vehicleid);

                                new plate_query[320];
                                mysql_format(mysql, plate_query, sizeof(plate_query),
                                    "UPDATE ownable_cars SET number='%e' WHERE id='%d' LIMIT 1",
                                    g_ownable_car[index][OC_NUMBER],
                                    GetOwnableCarData(index, OC_SQL_ID)
                                );
                                mysql_query(mysql, plate_query, false);

                                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFFFF}Номер снят с транспорта и возвращен в инвентарь");
                            }
                            case 6: // Припарковать транспорт
							{
								callcmd::park(playerid, "");
							}
							case 7: // Выгрузить транспорт
							{
								if(UnloadPlayerOwnableCar(playerid))
								{
									LoadTuning(playerid);
									launch[playerid] = 0;
									diski[playerid] = 0;
									fars[playerid] = 0;
									nitro[playerid] = 0;
									SendClientMessage(playerid, 0x66CC00FF, "{66CC00}Ваш транспорт успешно выгружен!");
								}
								// else SendClientMessage(playerid, 0x999999FF, "С момента загрузки данного транспорта еще не прошло 5 минут");
							}
							case 8: // Установить сабвуфер
							{
								SendClientMessage(playerid, 0xFF9900FF, "{ffff00}| {ffffff}Функция {FF6600}«Установить сабвуфер»{ffffff} находится в разработке.");
							}
							case 9: // Снять сабвуфер
							{
								SendClientMessage(playerid, 0xFF9900FF, "{ffff00}| {ffffff}Функция {FF6600}«Снять сабвуфер»{ffffff} находится в разработке.");
							}
							case 10: // Добавить авто в семью
                            {
                                if(GetPlayerRangFamily(playerid) == 5 && GetPlayerIdFamily(playerid) != -1)
                                {
                                    Dialog(playerid, 48231, DIALOG_STYLE_MSGBOX, "{FF0000}Добавление авто в семью", "Вы действительно хотите добавить Ваше авто в семью?", "Добавить", "Выйти");
                                }
            					else SendClientMessage(playerid, -1, ""c_f_r"Вы не лидер семьи.");
                            }
                            case 11: // Настройки автомобиля
                            {
                                new index = GetVehicleData(vehicleid, V_ACTION_ID);
                                new bool:auto_lock_enabled = ((GetOwnableCarData(index, OC_PDVRADAR) & OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED) == 0);

                                new dialog_text[256];
                                format(dialog_text, sizeof dialog_text,
                                    "{FFFFFF}Название\tСтатус\n1. Закрывать автоматически двери на скорости 70 км/ч\t%s",
                                    auto_lock_enabled ? ("{66CC00}Да") : ("{FF3300}Нет")
                                );

                                Dialog(playerid, DIALOG_OWNABLE_CAR_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS,
                                    "{FF0000}Настройки автомобиля",
                                    dialog_text,
                                    "Выбрать", "Назад"
                                );
                            }
							default:
								return 1;
						}
					}
				}
				return 1;
			}
            case 48231:
            {
                if(!response) return 1;

                new vehicleid = GetPlayerOwnableCar(playerid);
                if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
                    return SendClientMessage(playerid, 0xCECECEFF, "Личный транспорт не загружен");

                if(GetPlayerRangFamily(playerid) != 5 || GetPlayerIdFamily(playerid) == -1)
                    return SendClientMessage(playerid, -1, ""c_f_r"Вы не лидер семьи.");

                new index = GetVehicleData(vehicleid, V_ACTION_ID);
                MoveOwnableCar(playerid, GetOwnableCarData(index, OC_SQL_ID), GetFamily(GetPlayerIdFamily(playerid), family_database));
                return 1;
            }
            case DIALOG_OWNABLE_CAR_SETTINGS:
            {
                if(!response)
                {
                    return carssssc(playerid);
                }

                new vehicleid = GetPlayerOwnableCar(playerid);
                if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
                {
                    return SendClientMessage(playerid, 0xCECECEFF, "Личный транспорт не загружен");
                }

                new index = GetVehicleData(vehicleid, V_ACTION_ID);
                if(index < 0)
                {
                    return 1;
                }

                new pdv_state = GetOwnableCarData(index, OC_PDVRADAR);
                if((pdv_state & OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED) == 0)
                {
                    pdv_state |= OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED;
                }
                else
                {
                    pdv_state &= ~OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED;
                }

                SetOwnableCarData(index, OC_PDVRADAR, pdv_state);
                vInfo[index][pdvradar] = pdv_state;

                new query[160];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET pdvradar = %d WHERE id = %d", pdv_state, GetOwnableCarData(index, OC_SQL_ID));
                mysql_query(mysql, query, false);

                new bool:auto_lock_enabled = ((pdv_state & OWNABLE_CAR_PDVRADAR_FLAG_AUTOLOCK_DISABLED) == 0);
                new dialog_text[256];
                format(dialog_text, sizeof dialog_text,
                    "{FFFFFF}Название\tСтатус\n1. Закрывать автоматически двери на скорости 70 км/ч\t%s",
                    auto_lock_enabled ? ("{66CC00}Да") : ("{FF3300}Нет")
                );

                Dialog(playerid, DIALOG_OWNABLE_CAR_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS,
                    "{FF0000}Настройки автомобиля",
                    dialog_text,
                    "Выбрать", "Назад"
                );

                return 1;
            }
            case DIALOG_OWNABLE_CAR_LOAD:
{
    if(GetPVarInt(playerid, "park_hint_evacuated") == 1)
    {
        DeletePVar(playerid, "park_hint_evacuated");
        ShowNotificationNew(playerid, 3, 4, 0, 0, "Ваш транспорт отбуксирован!", "");
        return 1;
    }

    if(!response)
    {
        if(GetPVarInt(playerid, "show_menu"))
        {
            DeletePVar(playerid, "show_menu");
            callcmd::car(playerid, "");
        }
        return 1;
    }

    new sql_id = GetPVarInt(playerid, "ownablecar_id");
    if(sql_id <= 0) return 1;

    new vehicleid = GetOwnableCarBySqlID(sql_id);
    new bool:is_rent_menu = (GetPVarInt(playerid, "rent_true") == 1);
    new Float:x, Float:y, Float:z, Float:a;

    switch(listitem + 1)
    {
        case 1:
        {
            if(GetPlayerGPSInfo(playerid, G_ENABLED) != GPS_STATUS_OFF)
                return SendClientMessage(playerid, 0x00FF00FF, ""SC"На Вашем {FFFF00}GPS {FFFFFF}уже отмечено {FFFF00}место.");

            if(GetPlayerMoneyEx(playerid) < 300)
                return SendClientMessage(playerid, 0x00FF00FF, ""SC"{FFFF00}Недостаточно {FFFFFF}денег.");

            if(vehicleid != INVALID_VEHICLE_ID)
            {
                GetVehiclePos(vehicleid, x, y, z);
            }
					else if(GetOwnableCarUnloadPosition(sql_id, x, y, z, a))
            {
                // use last unload point
            }
					else if(!GetOwnableCarParkPosition(sql_id, x, y, z, a))
            {
                return SendClientMessage(playerid, 0xCECECEFF, "Не удалось определить координаты транспорта");
            }

            GivePlayerMoneyEx(playerid, -300, "Метка ТС на GPS", true, true);
            EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
            return 1;
        }

        case 2:
        {
            new loaded_vehicle = GetPlayerOwnableCar(playerid);
            if(loaded_vehicle != INVALID_VEHICLE_ID && IsValidVehicle(loaded_vehicle))
            {
                UnloadPlayerOwnableCar(playerid, true);
            }

            if(vehicleid != INVALID_VEHICLE_ID)
            {
                UnloadOwnableCarBySqlID(playerid, sql_id);
                vehicleid = INVALID_VEHICLE_ID;
            }

            if(is_rent_menu)
            {
                if(GetPlayerMoneyEx(playerid) < GetPVarInt(playerid, "price_rent"))
                    return 1;

                new zone_id = GetPVarInt(playerid, "rent_zone_id");

                if(zone_id < 0 || zone_id >= TotalRentZones || gRentZoneSlotCount[zone_id] <= 0)
                {
                    GetPlayerPos(playerid, x, y, z);
                    GetPlayerFacingAngle(playerid, a);
                }
					else
                {
                    new randIdx = random(gRentZoneSlotCount[zone_id]);
                    x = gRentZoneParking[zone_id][randIdx][0];
                    y = gRentZoneParking[zone_id][randIdx][1];
                    z = gRentZoneParking[zone_id][randIdx][2];
                    a = gRentZoneParking[zone_id][randIdx][3];
                }

                LoadOwnableCarRent(playerid, sql_id);
                vehicleid = GetOwnableCarBySqlID(sql_id);
                if(vehicleid == INVALID_VEHICLE_ID)
                    return SendClientMessage(playerid, 0x00FF00FF, ""SC"{FFFF00}Ошибка {FFFFFF}при загрузке личного {FFFF00}транспорта.");

                SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
                SetVehiclePos(vehicleid, x, y, z);
                SetVehicleZAngle(vehicleid, a);
                PutPlayerInVehicle(playerid, vehicleid, 0);
                SetVehicleSpeedometerInfoFP(playerid, vehicleid, GetVehicleData(vehicleid, V_FUEL), GetVehicleData(vehicleid, V_MILEAGE));
                if(GetVehicleData(vehicleid, V_FUEL) > 0.0) SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);

                GivePlayerMoneyEx(playerid, -GetPVarInt(playerid, "price_rent"));
                DeletePVar(playerid, "price_rent");
                DeletePVar(playerid, "rent_true");
                DeletePVar(playerid, "rent_zone_id");

                LoadTuning(playerid);
                SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);
                SetTimerEx("OwnableCar_ReapplyTuningSafe", 350, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);
                SetTimerEx("OwnableCar_ReapplyTuningSafe", 1200, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);

                return SendClientMessage(playerid, -1, "{FFFF00}{FFFFFF} Ваша машина была загружена.");
            }

            if(!GetOwnableCarUnloadPosition(sql_id, x, y, z, a))
                return SendClientMessage(playerid, 0xCECECEFF, "Место выгрузки не найдено. Сначала выгрузите транспорт");

            if(!IsPlayerInRangeOfPoint(playerid, 80.0, x, y, z))
            {
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы слишком далеко от места, где припаркован Ваш транспорт.", " ");
                return 1;
            }

            LoadOwnableCar(sql_id);
            vehicleid = GetOwnableCarBySqlID(sql_id);
            if(vehicleid == INVALID_VEHICLE_ID)
                return SendClientMessage(playerid, 0xCECECEFF, "Ошибка при загрузке транспорта");

            SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
            SetVehiclePos(vehicleid, x, y, z);
            SetVehicleZAngle(vehicleid, a);
            if(GetVehicleData(vehicleid, V_FUEL) > 0.0) SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
            LoadTuning(playerid);
            SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);
            SetTimerEx("OwnableCar_ReapplyTuningSafe", 350, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);
            SetTimerEx("OwnableCar_ReapplyTuningSafe", 1200, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);

            return SendClientMessage(playerid, -1, "{FFFF00}{FFFFFF} Ваша машина была загружена.");
        }

        case 3:
        {
            if(is_rent_menu) return 1;

            new loaded_vehicle = GetPlayerOwnableCar(playerid);
            if(loaded_vehicle != INVALID_VEHICLE_ID && IsValidVehicle(loaded_vehicle))
            {
                UnloadPlayerOwnableCar(playerid, true);
            }

            if(vehicleid != INVALID_VEHICLE_ID)
            {
                UnloadOwnableCarBySqlID(playerid, sql_id);
                vehicleid = INVALID_VEHICLE_ID;
            }

            if(!GetOwnableCarParkPosition(sql_id, x, y, z, a))
                return SendClientMessage(playerid, 0xCECECEFF, "Не удалось получить парковочную позицию транспорта");

            if(!IsPlayerInRangeOfPoint(playerid, 80.0, x, y, z))
            {
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы слишком далеко от места, где припаркован Ваш транспорт.", " ");
                return 1;
            }

            LoadOwnableCar(sql_id);
            vehicleid = GetOwnableCarBySqlID(sql_id);
            if(vehicleid == INVALID_VEHICLE_ID)
                return SendClientMessage(playerid, 0xCECECEFF, "Ошибка при загрузке транспорта");

            SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);
            SetVehiclePos(vehicleid, x, y, z);
            SetVehicleZAngle(vehicleid, a);
            if(GetVehicleData(vehicleid, V_FUEL) > 0.0) SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
            LoadTuning(playerid);
            SetPVarInt(playerid, "ownable_vehicle_id", vehicleid);
            SetTimerEx("OwnableCar_ReapplyTuningSafe", 350, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);
            SetTimerEx("OwnableCar_ReapplyTuningSafe", 1200, false, "dddd", playerid, vehicleid, GetPlayerAccountID(playerid), sql_id);

            return SendClientMessage(playerid, -1, "{FFFF00}{FFFFFF} Ваша машина была загружена.");
        }

        case 4:
        {
            if(is_rent_menu) return 1;

            if(ResetOwnableCarParkPosition(playerid, sql_id))
                return SendClientMessage(playerid, -1, "{FFFF00}{FFFFFF} Парковка была сброшена, используйте {FFFF00}/car");

            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось сбросить парковку");
        }
    }

    return 1;
}

case DIALOG_OWNABLE_CAR_LIST:
			{
				if(response)
				{
					new idx = GetPlayerListitemValue(playerid, listitem);

					if(idx == -1)
						return ShowOwnableCarListDialog(playerid, gOwnableCarDialogPage[playerid] - 1);

					if(idx == -2)
						return ShowOwnableCarListDialog(playerid, gOwnableCarDialogPage[playerid] + 1);

					if(idx > 0)
						ShowOwnableCarLoadDialog(playerid, idx, true);
				}
			}

			case DIALOG_OWNABLE_CAR_SELL:
			{
				if(response)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
					if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
					{
						new model_id = GetVehicleData(vehicleid, V_MODELID);

						if(DestroyOwnableCar(vehicleid))
						{
							new fmt_str[128];

							new car_price = GetSellCarPriceByModel(model_id);
							new percent = car_price * 20 / 100;
							new price = car_price - percent;

							SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                            GivePlayerMoneyEx(playerid, price, "Продажа личного транспорта", true, true);

                            format(fmt_str, sizeof fmt_str, "{FFFFFF}Налоговый сбор составляет 20 процентов от его стоимости {FF9900}(%d рублей)", percent);
                            SendClientMessage(playerid, 0xFFFFFFFF, fmt_str);

                            format(fmt_str, sizeof fmt_str, "{FFFFFF}На баланс зачислено {FFD700}%d рублей", price);
                            SendClientMessage(playerid, 0x66CC00FF, fmt_str);
						}
					}
				}
			}
			case DIALOG_OWNABLE_CAR_NUMBER:
			{
				if(response)
				{
					new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
						if(GetPlayerMoney(playerid) >= 5000)
						{
							new fmt_text[100],
								index;

							index = GetVehicleData(vehicleid, V_ACTION_ID);

							format(g_ownable_car[index][OC_NUMBER], 7, GenerateCarNumber());

                            //index = GetVehicleData(vehicleid, V_ACTION_ID);
                            format(g_ownable_car[index][OC_NUMBER], 32, g_ownable_car[index][OC_NUMBER]);
                            ApplyOwnableCarStoredPlate(vehicleid, index);

							format(fmt_text, sizeof fmt_text, "Вы купили номера формата: {f23a71}\"%s\" {66cc33}за 5000 руб", GetOwnableCarData(index, OC_NUMBER));
							SendClientMessage(playerid, 0x66CC33FF, fmt_text);

							GivePlayerMoneyEx(playerid, -5000, "Покупка номеров", true, true);

							mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='%s' WHERE id='%d' LIMIT 1", GetOwnableCarData(index, OC_NUMBER), GetOwnableCarData(index, OC_SQL_ID));
							mysql_query(mysql, fmt_text, false);
						}
					else
						{
							SendClientMessage(playerid, 0x999999FF, "Недостаточно денег для покупки номеров");
						}
					}
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_VEHICLE_TRUNK:
			{
				new vehicleid = GetPlayerUseTrunk(playerid);

				if(response && vehicleid != INVALID_VEHICLE_ID)
				{
					if(GetPlayerListitemValue(playerid, listitem) == -1) // Положить
					{
						Dialog
						(
							playerid, DIALOG_VEHICLE_TRUNK_PUT, DIALOG_STYLE_LIST,
							"{3399FF}Содержимое багажника",
							"\
							1. Положить деньги\n\
							2. Положить канистру\n\
							3. Положить аптечку\n\
							4. Положить Материалы\n\
							5. Положить Патроны\n\
							6. Положить наркотики\
							",
							"Положить", "Назад"
						);
					}
					else
					{
						if(0 <= listitem <= MAX_VEHICLE_TRUNK_SLOTS)
						{
							new desc[64] = "{66CC33}",
								type = GetTrunkData(vehicleid, listitem, VT_ITEM_TYPE);

							if(type == ITEM_TYPE_JERRICAN)
							{
								if(TakeTrunkItem(vehicleid, type, 15))
								{
									if(!GetPVarInt(playerid, "have_jerrican"))
									{
										SetPVarInt(playerid, "have_jerrican", 1);
								//		SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 1650, A_OBJECT_BONE_LEFT_HAND, 0.15, 0.0, 0.0, 0.0, -90.0, 180.0, 1.0, 1.0, 1.0, 0);

										SendClientMessage(playerid, 0x3399FFFF, "Вы достали из багажника \"Канистра\" в количестве: 15 л");
									}
					else
									{
										SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть канистра");
										AddTrunkItem(vehicleid, type, 15);
									}
								}
					else
								{
									SendClientMessage(playerid, 0x999999FF, "В багажнике нет канистры");
								}
							}
					else
							{
								if(type == ITEM_TYPE_NONE) type++;

								strcat(desc, GetItemInfo(type, I_NAME));

								SetPVarInt(playerid, "trunk_slot", type);

								Dialog
								(
									playerid, DIALOG_VEHICLE_TRUNK_TAKE, DIALOG_STYLE_INPUT,
									desc,
									"{FFFFFF}Введите количество, которое Вы хотите {f23a71}достать:",
									"Достать", "Назад"
								);
							}
						}
					}
				}
			}
			case DIALOG_VEHICLE_TRUNK_PUT:
			{
				new vehicleid = GetPlayerUseTrunk(playerid),
					slot = listitem + 1;

				if(response && vehicleid != INVALID_VEHICLE_ID)
				{
					if(slot == ITEM_TYPE_JERRICAN)
					{
						if(!GetPVarInt(playerid, "have_jerrican"))
						{
							SendClientMessage(playerid, 0x999999FF, "У Вас с собой нет канистры");
						}
					else
						{
							DeletePVar(playerid, "have_jerrican");
						//	RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);

							if(AddTrunkItem(vehicleid, ITEM_TYPE_JERRICAN, 15) != -1)
							{
								SendClientMessage(playerid, 0x3399FFFF, "Вы положили в багажник \"Канистра\" в количестве: 15 л");
							}
					else
							{
								SendClientMessage(playerid, 0xCECECEFF, "В багажнике недостаточно места");
							}
						}
					}
					else
					{
						new desc[32] = "{ff6600}";

						strcat(desc, GetItemInfo(slot, I_NAME));

						Dialog
						(
							playerid, DIALOG_VEHICLE_TRUNK_PUT_ITEM, DIALOG_STYLE_INPUT,
							desc,
							"{FFFFFF}Введите количество, которое Вы хотите {f23a71}положить:",
							"Положить", "Назад"
						);

						SetPVarInt(playerid, "trunk_slot", slot);
					}
				}
					else ShowTrunkDialog(playerid, vehicleid, false);
			}
			case DIALOG_VEHICLE_TRUNK_PUT_ITEM:
			{
				new vehicleid = GetPlayerUseTrunk(playerid),
					amount = strval(inputtext),
					slot = GetPVarInt(playerid, "trunk_slot");

				if(vehicleid == INVALID_VEHICLE_ID)

				if(response)
				{
					if(amount > 0)
					{
						if(AddTrunkItem(vehicleid, slot, amount))
						{
							switch(slot)
							{
								case ITEM_TYPE_MONEY:
								{
									if(GetPlayerMoneyEx(playerid) >= amount)
									{
										GivePlayerMoneyEx(playerid, -amount, "Положил в багажник", true);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества денег");
										TakeTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_MED:
								{
									if(GetPlayerData(playerid, P_MED_CHEST) >= amount)
									{
										AddPlayerData(playerid, P_MED_CHEST, -, amount);
										UpdatePlayerDatabaseInt(playerid, "healme", GetPlayerData(playerid, P_MED_CHEST));
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества аптечек");
										TakeTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_METALL:
								{
									if(GetPlayerData(playerid, P_METALL) >= amount)
									{
										AddPlayerData(playerid, P_METALL, -, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества Материалыа");
										TakeTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_AMMO:
								{
									if(GetPlayerData(playerid, P_AMMO) >= amount)
									{
										AddPlayerData(playerid, P_AMMO, -, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества патронов");
										TakeTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_DRUGS:
								{
									if(GetPlayerData(playerid, P_DRUGS) >= amount)
									{
										AddPlayerData(playerid, P_DRUGS, -, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества наркотиков");
										TakeTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
							}
						}
					else
						{
							SendClientMessage(playerid, 0xCECECEFF, "В багажнике недостаточно места");
							return 1;
						}

						new fmt_text[128];

						format(fmt_text, sizeof fmt_text, "Вы положили в багажник \"%s\" в количестве: %d %s", GetItemInfo(slot, I_NAME), amount, GetItemInfo(slot, I_NAME_COUNT));
						SendClientMessage(playerid, 0xFFFF00FF, fmt_text);
					}
					else SendClientMessage(playerid, 0x999999FF, "Неверное количество");
				}
					else
				{
					ShowTrunkDialog(playerid, vehicleid, false);
				}
			}
			case DIALOG_VEHICLE_TRUNK_TAKE:
			{
				new vehicleid = GetPlayerUseTrunk(playerid),
					amount = strval(inputtext),
					slot = GetPVarInt(playerid, "trunk_slot");

				if(vehicleid == INVALID_VEHICLE_ID)

				if(response)
				{
					if(amount > 0)
					{
						if(TakeTrunkItem(vehicleid, slot, amount) != -1)
						{
							switch(slot)
							{
								case ITEM_TYPE_MONEY:
								{
									GivePlayerMoneyEx(playerid, amount, "Достал из багажника", true);
								}
								case ITEM_TYPE_MED:
								{
									if((GetPlayerData(playerid, P_MED_CHEST) + amount) < 3)
									{
										AddPlayerData(playerid, P_MED_CHEST, +, amount);
										UpdatePlayerDatabaseInt(playerid, "healme", GetPlayerData(playerid, P_MED_CHEST));
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "Вы не можете носить с собой больше 3-х аптечек");
										AddTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_METALL:
								{
									if((GetPlayerData(playerid, P_METALL) + amount) < GetPlayerMaxStorage(playerid, STORAGE_METALL))
									{
										AddPlayerData(playerid, P_METALL, +, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "Вы не можете унести с собой больше Материалыа");
										AddTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_AMMO:
								{
									if((GetPlayerData(playerid, P_AMMO) + amount) < GetPlayerMaxStorage(playerid, STORAGE_AMMO))
									{
										AddPlayerData(playerid, P_AMMO, +, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "Вы не можете унести с собой больше патронов");
										AddTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
								case ITEM_TYPE_DRUGS:
								{
									if((GetPlayerData(playerid, P_DRUGS) + amount) < GetPlayerMaxStorage(playerid, STORAGE_DRUGS))
									{
										AddPlayerData(playerid, P_DRUGS, +, amount);
									}
					else
									{
										SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества наркотиков");
										AddTrunkItem(vehicleid, slot, amount);

										return 1;
									}
								}
							}

							new fmt_text[128];

							format(fmt_text, sizeof fmt_text, "Вы достали из багажника \"%s\" в количестве: %d %s", GetItemInfo(slot, I_NAME), amount, GetItemInfo(slot, I_NAME_COUNT));
							SendClientMessage(playerid, 0xFFFF00FF, fmt_text);
						}
					else
						{
							SendClientMessage(playerid, 0x999999FF, "В багажнике нет такого количества предмета");
							ShowTrunkDialog(playerid, vehicleid, false);
						}
					}
				}
					else ShowTrunkDialog(playerid, vehicleid, false);
			}
			// -----------------------------------------------------------------
			case DIALOG_SET_SPAWN:
			{
				if(response)
				{
					new fam_id = GetPlayerData(playerid, P_FAMILY);

					switch(listitem)
					{
						case 1: if(GetHouseNewByOwner(GetPlayerAccountID(playerid), playerid) == -1) return SendClientMessage(playerid, 0x999999FF, "У Вас нет дома");
						case 2: if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1) return SendClientMessage(playerid, 0x999999FF, "Вы не проживаете в гостиничном номере");
						case 3: if(!GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в организации");
						case 4: if(GetPlayerHouse(playerid, HOUSE_TYPE_ROOM) == -1) return SendClientMessage(playerid, 0x999999FF, "Вы не проживаете ни у кого в гостях");
                        case 5: return SendClientMessage(playerid, 0x999999FF, "Family spawn disabled.");
					}

					SetPlayerData(playerid, P_SPAWN, listitem);
					UpdatePlayerDatabaseInt(playerid, "setting_spawn", listitem);

					SendClientMessage(playerid, 0x3399FFFF, "Место появления в игре изменено");
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_ADONATE_MENU:
			{
				if(!response) return 1;

				switch(listitem)
				{
					case 0: ShowPlayerBuyAdminDialog(playerid);
					case 1: ShowPlayerBuyCommandDialog(playerid);
					case 2:
					{
						if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_A_UNWARN))
						{
							if(GetPlayerAdminWarn(playerid))
							{
								new fmt_text[80];
								AddPlayerData(playerid, P_ADMIN_WARN, -, 1);
								GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_A_UNWARN), "Снятие админ выговора", true, true);
								UpdatePlayerDatabaseInt(playerid, "admin_warn", GetPlayerAdminWarn(playerid));

								format(fmt_text, sizeof fmt_text, "Вы сняли админ выговор. Текущее количество выговоров: %d", GetPlayerData(playerid, P_ADMIN_WARN));
								SendClientMessage(playerid, 0x66CC00FF, fmt_text);
							}
					else
								SendClientMessage(playerid, -1, "У вас нет админ выговоров!");
						}
					else
							SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
					}
					case 3:
					{
						if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_A_SETPASS))
						{
							Dialog(playerid, DIALOG_ADMIN_REG, DIALOG_STYLE_INPUT, "{FF0000}Админ регистрация", "{FFFFFF}Придумайте пароль из 4-х цифр для авторизации в админ панеле\n{FFFFFF}Введите его в поле ниже:\n", "Далее", "Выход");// смена пароля
							GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_A_SETPASS), "Смена админ пароля", true);
						}
					else
							SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
					}
					case 4:
					{
						if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_A_INVISIBLE))
						{
					    	if(GetPlayerSecretEx(playerid) >= 1)
								return SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили скрытность.");

						    AddPlayerData(playerid, P_SECRET, +, 1);
							UpdatePlayerDatabaseInt(playerid, "a_secret", GetPlayerData(playerid, P_SECRET));

							GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_A_INVISIBLE), "Покупка скрытности", true, true);

							Send(playerid, 0xFFFF00FF,"Вы успешно купили скрытность");
							// скрытность
						}
					else
							SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
					}
					case 5:
					{
						if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_A_PREFIX))
						{
							Dialog
							(
								playerid, DIALOG_BUY_PREFIX, DIALOG_STYLE_INPUT,
								"Админ Префикс",
								"Введите в окошко ниже префикс который вы хотите\n\
								Примечание: Используйте префикс до 15 символов!",
								"Далее", "Отмена"
							);
						}
					else
							SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
					}
					case 6:
					{
						if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_A3D_PREFIX))
						{
							if(GetPlayerData(playerid, P_3D_PREFIX) > 1)
								return SendClientMessage(playerid, 0xCECECEFF, "Вы уже купили себе префикс.");

						    AddPlayerData(playerid, P_3D_PREFIX, +, 1);
							UpdatePlayerDatabaseInt(playerid, "a_3d_prefix", GetPlayerData(playerid, P_3D_PREFIX));

							GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_A3D_PREFIX), "Покупка 3d префикса", true, true);

							g_player[playerid][P_ADMIN_LABEL] = CreateDynamic3DTextLabel("Администратор", 0xFFCC33FF, 0.0, 0.0, 0.3, 10.0, playerid);
							Attach3DTextLabelToPlayer(g_player[playerid][P_ADMIN_LABEL], playerid, 0.0, 0.0, -0.8);

							Send(playerid, 0xFFFF00FF,"Вы успешно купили префикс");
							// префикс 3д
						}
					else
							SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
					}
				}

			}
			case DIALOG_BUY_PREFIX:
			{
				if(!response) return 1;

				if(strlen(inputtext) < 2 || strlen(inputtext) > 15)
				{
					Dialog
					(
						playerid, DIALOG_BUY_PREFIX, DIALOG_STYLE_INPUT,
						"Админ Префикс",
						"Введите в окошко ниже префикс который вы хотите\n\
						Примечание: Используйте префикс до 15 символов!",
						"Далее", "Отмена"
					);
				}

				new fmt_msg[128];
				format(GetPlayerData(playerid, P_PREFIX), 15, inputtext);
				UpdatePlayerDatabaseString(playerid, "prefix", GetPlayerData(playerid, P_PREFIX));
				GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_A_PREFIX), "Покупка префикса", true, true);

				format(fmt_msg, sizeof fmt_msg, "[A] SYSTEM купил %s[%d] префикс \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerData(playerid, P_PREFIX));
				SendMessageToAdmins(fmt_msg, 0x999999FF);
				SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);
			}
			case DIALOG_BUY_CMD:
			{
				if(!response) return 1;

				if(GetPlayerDonateRub(playerid) > g_admin_cmd_buy[listitem][CMD_PRICE])
				{

					new query[127], Cache:result, CMDaccess[CMD_NUM +1];
					mysql_format(mysql, query, 127, "SELECT cmdaccess FROM accounts WHERE name = '%s'", GetPlayerNameEx(playerid));
					result = mysql_query(mysql, query);

					print(query);

					if(cache_num_rows(result))
					{
						cache_get_field_content(0, "cmdaccess", CMDaccess, mysql, sizeof(CMDaccess));

						if(CMDaccess[listitem] == '1') return SendClientMessage(playerid,-1, "У Вас уже есть эта команда!");
						CMDaccess[listitem] = '1';
						UpdatePlayerDatabaseString(playerid, "cmdaccess", CMDaccess);

						GivePlayerDonateRub(playerid, -g_admin_cmd_buy[listitem][CMD_PRICE], "Покупка админ команд", true, true);

						new fmt_msg[128];
						format(fmt_msg, sizeof fmt_msg, "[A] SYSTEM купил %s[%d] команду \"%s\"", GetPlayerNameEx(playerid), playerid, g_admin_cmd_buy[listitem][CMD_NAME]);
						SendMessageToAdmins(fmt_msg, 0x999999FF);
						SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

						SendClientMessage(playerid, -1, g_admin_cmd_buy[listitem][CMD_DESCRIPTION]);

						g_player[playerid][CMD_ACCESS][listitem] = '1';
					}
					cache_delete(result);
				}
					else
					SendClientMessage(playerid, -1, "У вас не достаточно донат рублей на счету!");
			}
			case DIALOG_DRUB_MENU:
			{
				if(!response) return 1;

			//	if(response && GetPlayerDonateRub(playerid) <= 0) return callcmd::mn(playerid, "");
		
				switch(listitem)
				{
					case 0: ShowPlayerDonations(playerid, GetPlayerNameEx(playerid));
					case 1:	ShowPlayerConvertDialog(playerid);
					case 2:
					{
                         if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 1)
						 SendClientMessage(playerid, 0x999999FF, ""USC"У Вас уже есть все лицензии");

						else
						{
							if(GetPlayerDonateRub(playerid) >= 150)
							{
								SetPlayerData(playerid, P_DRIVING_LIC,	2);
								SetPlayerData(playerid, P_WEAPON_LIC,	1);

								UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

								GivePlayerDonate(playerid, -150, "Покупка пакета лицензий", true);

								SendClientMessage(playerid, 0x66CC33FF, ""SC"Вы приобрели пакет лицензий. Используйте: {FFFF00}/lic");
							}
					else
							{
								SendClientMessage(playerid, 0x66CC33FF, ""USC"Для покупки всех лицензий необходимо иметь на счету 150 руб");
							}
						}

						ShowPlayerDrubMenu(playerid);
					}

					case 3:
					{
						if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
						{
							if(GetPlayerOwnableCars(playerid) == 0)
								return SendClientMessage(playerid, 0x999999FF, ""USC"У Вас нет личного транспорта");
							else
								return SendClientMessage(playerid, 0x999999FF, ""USC"Ваш личный транспорт не загружен на сервер");
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

					}
					case 4:
					{
						new fmt_text[80];

						if(GetPlayerDonateRub(playerid) < 100)
						{
							 SendClientMessage(playerid, -1, ""USC"Для покупки слота для транспорта необходимо иметь на счету %d.00 руб");
						}
					else
						{
							AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
							UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

							GivePlayerDonateRub(playerid, -100, "Покупка слота для транспорта", true, true);

							format(fmt_text, sizeof fmt_text, ""SC"Вы увеличили количество слотов для транспорта. Текущее количество слотов: {ffff00}%d",
							GetPlayerData(playerid, P_CAR_SLOTS));

							SendClientMessage(playerid, 0x66CC00FF, fmt_text);
						}
					}
					case 5:
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
							new fmt_text[85];

							 SendClientMessage(playerid,-1, ""USC"Для покупки 4-х значного номера телефона необходимо иметь на счету {ffff00}70{ffffff} руб");
						}

						ShowPlayerDrubMenu(playerid);
					}
					case 6:
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

								SendClientMessage(playerid, 0x66CC33FF, ""SC"Все предупреждения успешно сняты");
								SendClientMessage(playerid, 0xFFFF00FF, ""SC"Теперь Вы можете устроиться в организацию");
							}
					else
							{
								new fmt_text[80];

								 SendClientMessage(playerid, -1, ""USC"Для снятия всех предупреждений необходимо иметь на счету 100 руб");
							}
						}
					else SendClientMessage(playerid, 0x999999FF, ""USC"На Вашем аккаунте нет предупреждений");

						//ShowPlayerDrubMenu(playerid);
					}
					case 7:
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
					/*case 9:
					{
					    if(!(g_family_loaded >= MAX_FAM))
			            {
			                Dialog
			                (
			                    playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
                        "{FF0000}Создание семьи",
                        "{FFFFFF} Здесь Вы можете создать свою семью\n
                        "{FFFFFF}Цена:{ffff00} 3.000.000 рублей.\n\
                           \n
                        {FFFFFF}Напишите название Вашей будущей семьи.",
                        "Далее", "Выйти"
			                );
			            }
					}
					case 10:
					{
						if(GetPlayerDonateRub(playerid) >= GetDonatePrice(DONATE_PRICE_GIFT))
						{
						    AddPlayerData(playerid, P_GIFTS, +, 40);

							UpdatePlayerDatabaseInt(playerid, "gifts", GetPlayerData(playerid, P_GIFTS));

							GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_GIFT), "Покупка '40 подарков'", true);

							SendClientMessage(playerid, 0x66CC33FF, "Вы приобрели '40 подарков'");
						}
					else
						{
							new fmt_text[65];

							format(fmt_text, sizeof fmt_text, "Для покупки '40 подарков' необходимо иметь на счету %d. Донат-Рублей",
							GetDonatePrice(DONATE_PRICE_GIFT));

							SendClientMessage(playerid, -1, fmt_text);
						}

						//ShowPlayerDrubMenu(playerid);
					}*/
					case 8:
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
					case 9:
					{
						if(GetPlayerDonateRub(playerid) >= 100)
						{
						    if(GetPlayerData(playerid, P_BOOMBOX) >= 1) return Send(playerid, -1, ""USC"У вас уже есть бумбокс");
						    
							GivePlayerDonateRub(playerid, -100, "покупка бумбокса");

							Send(playerid,-1,""SC"Вы успешно купили бумбокс(/boombox)");
							
							SetPlayerData(playerid, P_BOOMBOX, 1);
							UpdatePlayerDatabaseInt(playerid, "boombox", 1);
						}
					else
						    return Send(playerid,-1,""USC"У вас не достаточно BC!");
						//ShowPlayerDrubMenu(playerid);
					}
					case 10: ShowPlayerBuyLeadDialog(playerid);
					case 11: ShowPlayerBuyAdminDialog(playerid);
				 	case 12: ShowPlayerBuyZamDialog(playerid);

				}
			}
			case DIALOG_DONATE_VIP_HELP:
			{
			    if(!response) return 1;
			    
			    new fmt_text[200];
				
				format(fmt_text, sizeof fmt_text,
				"{FFFF00}1{CD7F32} Vip Silver ( %d RUB )\n\
				{FFFF00}2{C0C0C0}  VIP Gold ( %d RUB )\n\
			    {FFFF00}3{FFD700} VIP Platinum ( %d RUB )",
				GetDonatePrice(DONATE_PRICE_BRONSE),
				GetDonatePrice(DONATE_PRICE_SILVER),
				GetDonatePrice(DONATE_PRICE_GOLD));

				Dialog(playerid, DIALOG_DONATE_PREMIUM, DIALOG_STYLE_LIST, "VIP Аккаунты", fmt_text, "Купить", "Отмена");
			}
			case DIALOG_DONATE_PREMIUM:
			{
				if(response)
			    {
				    new prem_day,prem_month,prem_year,premium = GetPlayerPremium(playerid),
				    fmt_text[128];
			        switch(listitem +1)
					{
	    				case 1:
						{
					        if(GetPlayerDonateRub(playerid) >= GetDonatePrice(DONATE_PRICE_BRONSE))
					        {
						        if(!premium)
						        {
									SetPlayerData(playerid, P_PREMIUM, 1);
						            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
								}
					else
								{
								    AddPlayerData(playerid, P_PREMIUM_DATE, +, 30 * 86400);
								}


								timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

								format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {EC174F}VIP Bronse{FFFFFF}до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
								SendClientMessage(playerid, -1, fmt_text);

								UpdatePlayerDatabaseInt(playerid, "premium", 1);
								UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

								GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_BRONSE), "Покупка подписки "SERVER_NAME"+");
							
				    		}
					else
						    {
						        format(fmt_text, sizeof fmt_text, "Для покупки подписки VIP Bronse необходимо иметь на счету %d. Донат-Рублей",
								GetDonatePrice(DONATE_PRICE_BRONSE));
								ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно ВС!", "");
						    }
						}
						case 2:
							{
						        if(GetPlayerDonateRub(playerid) >= GetDonatePrice(DONATE_PRICE_SILVER))
						        {
							        if(!premium)
							        {
							            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
										SetPlayerData(playerid, P_PREMIUM, 2);
							            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
									}
					else
									{
									    AddPlayerData(playerid, P_PREMIUM_DATE, +, 30 * 86400);
									}


									timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);


									format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {EC174F}VIP Silver{FFFFFF}до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
									SendClientMessage(playerid, -1, fmt_text);

									UpdatePlayerDatabaseInt(playerid, "premium", 2);
									UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

									GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_BRONSE), "Покупка подписки "SERVER_NAME"+");
					    		}
					else
							    {
							        format(fmt_text, sizeof fmt_text, "Для покупки подписки VIP Silver необходимо иметь на счету %d. Рублей",
									GetDonatePrice(DONATE_PRICE_SILVER));
									ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно ВС!", "");
							    }
						    }
		    			case 3:
							{
						        if(GetPlayerDonateRub(playerid) >= GetDonatePrice(DONATE_PRICE_GOLD))
						        {
							        if(!premium)
							        {
										AddPlayerData(playerid, P_CAR_SLOTS, +, 2);
										SetPlayerData(playerid, P_PREMIUM, 3);
							            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
									}
					else
									{
									    AddPlayerData(playerid, P_PREMIUM_DATE, +, 30 * 86400);
									}


									timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);



									format(fmt_text, sizeof fmt_text, "Вы успешно оплатили {EC174F}VIP Gold{FFFFFF}до {EC174F}%02d.%02d.%d", prem_day, prem_month, prem_year);
									SendClientMessage(playerid, -1, fmt_text);

									UpdatePlayerDatabaseInt(playerid, "premium", 3);
									UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

									GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_BRONSE), "Покупка подписки "SERVER_NAME"+");
					    		}
					else
							    {
							        format(fmt_text, sizeof fmt_text, "Для покупки подписки VIP Gold необходимо иметь на счету %d. Рублей",
									GetDonatePrice(DONATE_PRICE_GOLD));
									ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно ВС!", "");
							    }
							}
					    }
					}

			    //ShowPlayerDonateMenu(playerid);
			}
			/*case DIALOG_DONATE_SKIN: // Скины сюда
			{
			    if(response)
			    {
                    new list_id = listitem + 1;

					//new str_len = strval(inputtext);
					if(GetPlayerDonateRub(playerid) >= GetDonatePrice(DONATE_PRICE_SKIN))
			        {
			            GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_SKIN), "Покупка unical skin");
			            SetPlayerSkin(playerid,g_skin_donate[list_id-1]);
			            UpdatePlayerDatabaseInt(playerid, "skin", g_skin_donate[list_id-1]);
			            SetPlayerData(playerid, P_SKIN, g_skin_donate[list_id-1]);
			            SendClientMessage(playerid, -1, "{1E90FF}[Информация]{FFFFFF} Поздравляем вас с покупкой уникального скина!");
					}
					else
	    			{
						new fmt_text[128];
	    				format(fmt_text, sizeof fmt_text, "Для покупки уникального скина необходимо иметь на счету %d. Рублей",
						GetDonatePrice(DONATE_PRICE_SKIN));
						SendClientMessage(playerid,-1,fmt_text);
		    		}
                }
			}*/
			case DIALOG_DRUB_BUYLEAD:
			{
				if(!response) return 1;

				new org_id = GetPlayerListitemValue(playerid, listitem),
				fmt_msg[128];

				if(GetPlayerDonateRub(playerid) > g_organization[org_id][O_PRICE])
				{
					InvitePlayer(playerid, org_id, 10, true);

					if(IsTeamSubdivision(org_id))
						format(fmt_msg, sizeof fmt_msg, "Вы стали лидером подразделения \"%s\", организации \"%s\"", GetPlayerSubdivisionName(playerid), GetPlayerTeamName(playerid));
					else
						format(fmt_msg, sizeof fmt_msg, "Вы стали лидером организации \"%s\"", GetPlayerTeamName(playerid));

					SendClientMessage(playerid, 0xFFFF00FF, fmt_msg);

					format(fmt_msg, sizeof fmt_msg, "[A] SYSTEM купил %s[%d] лидерку организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(playerid));
					SendMessageToAdmins(fmt_msg, 0x999999FF);

					format(fmt_msg, sizeof fmt_msg, "%s[acc:%d]  купил лидерку %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetPlayerTeamName(playerid));
					SendLog(playerid, LOG_TYPE_SET_LEADER, fmt_msg);
					GivePlayerDonateRub(playerid, -g_organization[org_id][O_PRICE], "Покупка лидерских прав");
				}
					else
					return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно донат рублей");
			}
			case DIALOG_DRUB_BUYZAM:
			{
				if(!response) return 1;

				new org_id = GetPlayerListitemValue(playerid, listitem)+1,
				fmt_msg[128];

				if(GetPlayerDonateRub(playerid) > GetDonatePrice(DONATE_PRICE_ZAM))
				{
					InvitePlayer(playerid, org_id, 9, true);

					if(IsTeamSubdivision(org_id))
						format(fmt_msg, sizeof fmt_msg, "Вы стали 9 рангов \"%s\", организации \"%s\"", GetPlayerSubdivisionName(playerid), GetPlayerTeamName(playerid));
					else
						format(fmt_msg, sizeof fmt_msg, "Вы стали 9 рангом в \"%s\"", GetPlayerTeamName(playerid));

					SendClientMessage(playerid, 0xFFFF00FF, fmt_msg);

					format(fmt_msg, sizeof fmt_msg, "[A] SYSTEM купил %s[%d] 9 ранг в организации \"%s\"", GetPlayerNameEx(playerid), playerid, GetPlayerTeamName(playerid));
					SendMessageToAdmins(fmt_msg, 0x999999FF);

					format(fmt_msg, sizeof fmt_msg, "%s[acc:%d]  купил 9 ранг %s", GetPlayerNameEx(playerid), GetPlayerAccountID(playerid), GetPlayerTeamName(playerid));
					SendLog(playerid, LOG_TYPE_SET_LEADER, fmt_msg);
					GivePlayerDonateRub(playerid, -GetDonatePrice(DONATE_PRICE_ZAM), "Покупка 9 ранга");
				}
					else
					return SendClientMessage(playerid, 0xCECECEFF, "У вас недостаточно донат рублей");
			}
			case DIALOG_DRUB_BUYADMIN:
			{
				if(!response) return 1;

				if(listitem < 0) return true;

	            new lvlup = listitem + 1;
	            new price = lvlup * Config[admin_price];
	            new fmt_str[246];

	            if(GetPlayerAdminEx(playerid) + lvlup == 12) price = 2500;

	            if(GetPlayerDonateRub(playerid) > price)
				{
		            GivePlayerDonateRub(playerid, -price, "Покупка админ-прав");

					AddPlayerData(playerid, P_ADMIN, +, lvlup);

					AdminAuthorization(playerid);

					mysql_format(mysql, fmt_str, sizeof fmt_str, "UPDATE accounts SET admin=%d,rub=%d WHERE id=%d", GetPlayerAdminEx(playerid), GetPlayerDonateRub(playerid), GetPlayerAccountID(playerid));
					mysql_query(mysql, fmt_str, false);
		            SendClientMessage(playerid, -1, "{0099CC}Используйте {FFD700}/ahelp, {0099CC}чтобы узнать о новых возможностях");
				}
					else
				    return SendClientMessage(playerid, -1, "У Вас недостаточно рублей, пополнить их можно на сайте {FFCD00}"SERVER_SITE" -> Донат");

			}
			// -----------------------------------------------------------------
			case DIALOG_DONATE_INFO:
			{
				ShowPlayerDonateMenu(playerid);
			}
			case DIALOG_DONATE_ENROLLMENT:
			{
				if(!response) return true;

				new donate_money = GetPVarInt(playerid, "donate_money"),
					donate_money_with_action = GetPVarInt(playerid, "donate_money_with_action"),
					fmt_text[248];

				mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE `unitpay_payments` SET status=0 WHERE account='%s'", GetPlayerNameEx(playerid));
				mysql_query(mysql, fmt_text, false);

				if(!mysql_errno())
				{
					GivePlayerDonateRub(playerid, donate_money_with_action, "Пополнение счёта");

					format
					(
						fmt_text, sizeof fmt_text,
						"{FFFFFF}\
						Сумма была зачислена на Ваш аккаунт\n\
						Вы успешно пополнили счёт на {66cc99}%d.00 руб\n\
						{FFFFFF}С учётом акции было зачислено {33cc66}%d.00 руб\n\n\
						{FFFFFF}Используйте: {ffcc00}/donate\
						",
						donate_money, donate_money_with_action
					);

					Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{00cc33}Счёт пополнен", fmt_text, "Закрыть", "");
				}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 48)");
			}

			case DIALOG_DONATE_MENU:
			{
				if(!response) return 1;

				if(response && GetPlayerDonateMoney(playerid) <= 0) return callcmd::mm(playerid, "");

				switch(listitem)
				{
					case 0: ShowPlayerDonations(playerid, GetPlayerNameEx(playerid));
					case 1: ShowPlayerConvertDialog(playerid);
					case 2:
					{
						new fmt_text[80];

						if(GetPlayerDonateMoney(playerid) >= GetDonatePrice(DONATE_PRICE_DRUGS))
						{
							AddPlayerData(playerid, P_DRUGS, +, 8);
							UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));
							SendClientMessage(playerid, 0xFFFF00FF, "Вы можете использовать их {3399FF}/drugs");
							format(fmt_text, sizeof fmt_text, "Вы приобрели 8 доз наркотика ЛСД за %d.00 руб",
							GetDonatePrice(DONATE_PRICE_DRUGS));
							SendClientMessage(playerid, 0x66CC33FF, fmt_text);

							GivePlayerDonate(playerid, -GetDonatePrice(DONATE_PRICE_DRUGS), "Покупка наркотиков");
						}
					else
						{
							format(fmt_text, sizeof fmt_text, "Для покупки наркотиков необходимо иметь на счету %d.00 руб",
							GetDonatePrice(DONATE_PRICE_DRUGS));

							SendClientMessage(playerid, -1, fmt_text);
						}

						ShowPlayerDonateMenu(playerid);
					}
					case 3:
					{
						new fmt_text[80];

						if(GetPlayerDonateMoney(playerid) >= GetDonatePrice(DONATE_PRICE_LAW_ABIDING))
						{
							AddPlayerData(playerid, P_LAW_ABIDING, +, 10);
							UpdatePlayerDatabaseInt(playerid, "law_abiding", GetPlayerData(playerid, P_LAW_ABIDING));

							SendClientMessage(playerid, 0x66CC33FF, "Документы удалось подделать");

							GivePlayerDonate(playerid, -GetDonatePrice(DONATE_PRICE_LAW_ABIDING), "Подделка документов");
						}
					else
						{
							format(fmt_text, sizeof fmt_text, "Для подделки документов необходимо иметь на счету %d.00 руб",
							GetDonatePrice(DONATE_PRICE_LAW_ABIDING));

							SendClientMessage(playerid, -1, fmt_text);
						}

						ShowPlayerDonateMenu(playerid);
					}
					case 4:
					{
						if(GetPlayerData(playerid, P_DRIVING_LIC) == 2 && GetPlayerData(playerid, P_WEAPON_LIC) == 1)
							SendClientMessage(playerid, 0x999999FF, "У Вас уже есть все лицензии");

						else
						{
							if(GetPlayerDonateMoney(playerid) >= GetDonatePrice(DONATE_PRICE_LIC_PACK))
							{
								SetPlayerData(playerid, P_DRIVING_LIC,	2);
								SetPlayerData(playerid, P_WEAPON_LIC,	1);

								UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
								UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

								GivePlayerDonate(playerid, -GetDonatePrice(DONATE_PRICE_LIC_PACK), "Покупка пакета лицензий", true);

								SendClientMessage(playerid, 0x66CC33FF, "Вы приобрели пакет лицензий. Используйте: {FFCD00}/lic");
							}
					else
							{
								new fmt_text[65];

								format(fmt_text, sizeof fmt_text, "Для покупки всех лицензий необходимо иметь на счету %d.00 руб",
								GetDonatePrice(DONATE_PRICE_LIC_PACK));
							}
						}

						ShowPlayerDonateMenu(playerid);
					}
					case 5:
					{
					    new fmt_text[80];

						if(GetPlayerDonateMoney(playerid) >= GetDonatePrice(DONATE_PRICE_ANTIBH))
						{
							SetPlayerData(playerid, P_BANIHOP, 1);
							UpdatePlayerDatabaseInt(playerid, "AntiBh", 1);

							SendClientMessage(playerid, 0x66CC33FF, "Вы успешно купили Анти-БаниХоп");

							GivePlayerDonate(playerid, -GetDonatePrice(DONATE_PRICE_ANTIBH), "покупка анти бх");
						}
					else
						{
							format(fmt_text, sizeof fmt_text, "Для подделки документов необходимо иметь на счету %d руб",
							GetDonatePrice(DONATE_PRICE_ANTIBH));

							SendClientMessage(playerid, -1, fmt_text);
						}

						ShowPlayerDonateMenu(playerid);
					}
					case 6:
					{
						callcmd::donate(playerid);
					}
					/*
					case 11:
					{
						if(0 <= GetPlayerAdminEx(playerid) <= 3)
						{
							new fmt_text[144];

							if(GetPlayerDonateMoney(playerid) >= GetDonatePrice(DONATE_PRICE_ADMIN_LVL))
							{
								AddPlayerData(playerid, P_ADMIN, +, 1);

								new current_lvl = GetPlayerAdminEx(playerid);

								UpdatePlayerDatabaseInt(playerid, "admin", current_lvl);

								format(fmt_text, sizeof fmt_text, "Покупка %d уровня адм", current_lvl);

								GivePlayerDonate(playerid, -GetDonatePrice(DONATE_PRICE_ADMIN_LVL), fmt_text, true, true);

								format(fmt_text, sizeof fmt_text, "Вы увеличили свой уровень администратора. Текущий уровень: %d", current_lvl);
								SendClientMessage(playerid, 0x66CC33FF, fmt_text);
							}
					else
							{
								format(fmt_text, sizeof fmt_text, "Для покупки %d уровня администратора необходимо иметь на счету %d.00 руб",
								GetPlayerAdminEx(playerid) + 1, GetDonatePrice(DONATE_PRICE_ADMIN_LVL));

								SendClientMessage(playerid, 0x999999FF, fmt_text);
							}
						}
					else
							SendClientMessage(playerid, 0x999999FF, "Вы не можете повысить свой уровень администратора");

						ShowPlayerDonateMenu(playerid);
					}
					*/
				}
			}
			case DIALOG_DONATE_CONVERT:
			{
                // DIALOG_DONATE_CONVERT_DISABLED_GUARD
                if(response) return SendClientMessage(playerid, 0xCECECEFF, "Конвертация отключена");
				if(!response) return ShowPlayerDonateMenu(playerid);

				new fmt_text[256],
					money_amount = strval(inputtext);

				if(!(1 <= money_amount <= GetPlayerDonateRub(playerid)))
				{
					if(money_amount > GetPlayerDonateRub(playerid))
					{
						format(fmt_text, sizeof fmt_text, "Недостаточно средств. Сейчас на Вашем счету %d Рублей", GetPlayerDonateRub(playerid));
						SendClientMessage(playerid, 0xCECECEFF, fmt_text);
					}

					ShowPlayerConvertDialog(playerid);

					return 1;
				}

				new donate_price = 1000;
               
				//format(fmt_text, sizeof fmt_text, "Вы сконвертировали {ffff00}%d{FFFFFF} BC в {ffff00}%d{FFFFFF} рублей", money_amount, money_amount * donate_price);
				//ShowNotification(playerid, 3, fmt_text, 5, "", "");
				//SendClientMessage(playerid, 0xFFFF00FF, fmt_text);
				GivePlayerDonateRub(playerid, -money_amount, "Покупка рублей", true);
				UpdatePlayerDatabaseInt(playerid, "donate_current", GetPlayerData(playerid, P_DONATE_MONEY));
				format(fmt_text, sizeof fmt_text, "~g~+$%d~n~~y~-$%d", money_amount * donate_price, money_amount);
				GameTextForPlayer(playerid, fmt_text, 4000, 1);

				format(fmt_text, sizeof fmt_text, "Конвертация доната %d в игровую валюту", money_amount);

				GivePlayerMoneyEx(playerid, money_amount * donate_price, fmt_text, true, true);
			 
			 
				return 1;
			}
            case DIALOG_DONATE_GET_MONEY:
            {
                // DIALOG_DONATE_GET_MONEY_DISABLED_GUARD
                if(response) return SendClientMessage(playerid, 0xCECECEFF, "Конвертация отключена");
                if(!response)
                {
                    DeletePVar(playerid, "donate_convert_count");
                    return ShowPlayerDonateMenu(playerid);
                }

                new money_count;
                money_count = GetPVarInt(playerid, "donate_convert_count");

                new fmt_text[128];

                format(fmt_text, sizeof fmt_text, "Вы сконвертировали {66cc00}%d.00 доната {ffff00}в {66cc00}%d игр.$.", money_count, money_count * GetDonatePrice(DONATE_PRICE_MONEY));
                SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

                format(fmt_text, sizeof fmt_text, "~g~+%d $~n~~y~-%d $", money_count * GetDonatePrice(DONATE_PRICE_MONEY), money_count);
                GameTextForPlayer(playerid, fmt_text, 4000, 1);

                format(fmt_text, sizeof fmt_text, "Конвертация %d $. в игровую валюту", money_count);
                GivePlayerDonate(playerid, -money_count, fmt_text, true);

                GivePlayerMoneyEx(playerid, money_count * GetDonatePrice(DONATE_PRICE_MONEY), fmt_text, false, true);

                DeletePVar(playerid, "donate_convert_count");

                return 1;
            }
				case DIALOG_DONATE_BUY_CAR_NUMBER:
			{
				if(response)
				{
					if(IsACarNumber(inputtext))
					{
						new fmt_text[105],
							number_price = GetCarNumberPrice(inputtext),
							Cache: result,
							rows;

						mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE number='%s'", inputtext);
						result = mysql_query(mysql, fmt_text, true);

						rows = cache_num_rows(result);

						cache_delete(result);

						if(rows)
							ShowNotificationNew(playerid, 2, 4, 0, 0, "Данный номер уже занят!", "");

						else
						{
							SetPVarString(playerid, "car_number", inputtext);
							SetPVarInt(playerid, "car_number_price", number_price);

							format(fmt_text, sizeof fmt_text, "{FFFFFF}Вы действительно хотите купить номер {66CC66}%s {FFFFFF}за {ffff00}%d{FFFFFF} руб?", inputtext, number_price);
							Dialog(playerid, DIALOG_DONATE_ACCEPT_CAR_NUM, DIALOG_STYLE_MSGBOX, "{FFFF00}Покупка номера", fmt_text, "Купить", "Назад");

							return 1;
						}
					}
					else
					{
					    ShowNotificationNew(playerid, 2, 4, 0, 0, "Введенный Вами номер не соответствует формату CNNNCC", "");
					}
				}
					else 
				return 1;
			}
			case DIALOG_DONATE_ACCEPT_CAR_NUM:
			{
				if(response)
				{
					new number_price = GetPVarInt(playerid, "car_number_price"),
						fmt_text[100];

					if(GetPlayerDonateRub(playerid) >= number_price)
					{
						new car_number[7],
							vehicleid,
							index;

						GetPVarString(playerid, "car_number", car_number, sizeof car_number);

						vehicleid = GetPlayerOwnableCar(playerid);

						if(vehicleid != INVALID_VEHICLE_ID)
						{
							index = GetVehicleData(vehicleid, V_ACTION_ID);

							format(g_ownable_car[index][OC_NUMBER], 7, car_number);

							UpdateVehicleLabel(vehicleid, 0xFFFF00EE, GetOwnableCarData(index, OC_NUMBER));

							format(fmt_text, sizeof fmt_text, ""SC"Вы купили номера формата: {ffff00}\"%s\" {ffffff}за {ffff00}%d{ffffff} руб", GetOwnableCarData(index, OC_NUMBER), number_price);
							ShowNotificationNew(playerid, 3, 4, 0, 0, fmt_text, "");

							mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET number='%s' WHERE id='%d' LIMIT 1", GetOwnableCarData(index, OC_NUMBER), GetOwnableCarData(index, OC_SQL_ID));
							mysql_query(mysql, fmt_text, false);

							GivePlayerDonateRub(playerid, -number_price, "Покупка номеров", true);
						
							
						}
					else
						{
							if(GetPlayerOwnableCars(playerid) == 0)
								 ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас нет личного транспорта!", "");
							else
								 ShowNotificationNew(playerid, 2, 4, 0, 0, "Ваш транспорт не загружен на сервер!", "");
						}
					}
					else
					{
						format(fmt_text, sizeof fmt_text, ""USC"Для покупки номера необходимо иметь на счету %d.00 руб.", number_price);
						ShowNotificationNew(playerid, 3, 4, 0, 0, fmt_text, "");
					}
				}

			}
			case DIALOG_DONATE_BUY_NUMBER:
            {
                if(response)
                {
                    if(strlen(inputtext) == 4 && (1000 <= strval(inputtext) <= 9999))
                    {
                        if(GetPlayerDonateRub(playerid) < 70)
                        {
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Недостаточно ВС для покупки SIM-карты", " ");
                            return 1;
                        }

                        new number = strval(inputtext),
                            query[220];

                        if(Inventory11_IsSimNumberReserved(number))
                        {
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Введенный Вами номер уже занят", " ");
                        }
                        else
                        {
                            if(TrunkTest_GetFreeInventorySlot(playerid) == -1)
                            {
                                ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
                                return 1;
                            }

                            if(!Inventory11_CanAddItemWeight(playerid, 58, 1))
                            {
                                ShowNotificationNew(playerid, 2, 6, 0, 0, "Превышен максимальный вес инвентаря", " ");
                                return 1;
                            }

                            // V12: purchase always creates a physical SIM item; never auto-applies it.
                            new sim_slot = Inventory11_AddItemToDatabase(playerid, 58, 1, 1, number, 0);
                            if(sim_slot == -1)
                            {
                                ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось выдать SIM-карту в инвентарь", " ");
                                return 1;
                            }

                            GivePlayerDonateRub(playerid, -70, "Покупка SIM-карты", true, true);
                            ShowSuccesfullBuyPack(playerid, "SIM-карта", 70, 124);

                            format
                            (
                                query, sizeof query,
                                "{FFFFFF}Новая SIM-карта добавлена в инвентарь\n"\
                                "Используйте ее, чтобы установить номер {0099FF}%d",
                                number
                            );
                            return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{66CC00}SIM-карта куплена", query, "Закрыть", "");
                        }
                    }
                    else ShowNotificationNew(playerid, 2, 4, 0, 0, "Недопустимый формат ввода!", "");
                }

            }
            case DIALOG_DONATE_SKILLS:
			{
				if(response)
				{
					SetPVarInt(playerid, "skill_index", listitem);

					new skill_amount = GetPlayerSkillAmount(playerid, listitem);

					new title[48],
						fmt_text[200];

					format(title, sizeof title, "{FFCD00}Прокачать навык: %s", skill_name[listitem]);

					format
					(
						fmt_text, sizeof fmt_text,
						"{FFCD00}%s:\t\t\t{FFFFFF}%d%%\n\n"\
						"Стоимость 1 ед.:\t{6699cc}%d руб.\n"\
						"{FFFFFF}Введите количество единиц, на которое\n"\
						"Вы хотите прокачать Ваш навык:",
						skill_name[listitem],
						skill_amount,
						GetDonatePrice(DONATE_PRICE_SKILLS)
					);

					Dialog(playerid, DIALOG_DONATE_SKILL_BUY, DIALOG_STYLE_INPUT, title, fmt_text, "Далее", "Отмена");
				}
			}
			case DIALOG_DONATE_SKILL_BUY:
			{
				if(response)
				{
					new skill_index = GetPVarInt(playerid, "skill_index"),
						skill_amount = strval(inputtext);

					if(!(0 <= skill_index <= 11))
						return ShowNotificationNew(playerid, 2, 4, 0, 0, "Неизвестная ошибка!", "");

					if(skill_amount > 0 && IsNumeric(inputtext))
					{
						new skill_max = 100 - GetPlayerSkillAmount(playerid, skill_index);

						new fmt_text[90];

						if(skill_amount <= skill_max)
						{
							new skill_price = GetDonatePrice(DONATE_PRICE_SKILLS) * skill_amount;

							if(GetPlayerDonateRub(playerid) >= skill_price)
							{
								GivePlayerDonateRub(playerid, -skill_price, "Прокачка навыков", true, true);

								SetPlayerSkillAmount(playerid, skill_index, GetPlayerSkillAmount(playerid, skill_index) + skill_amount);

								new skill_db_name[12][20] =
								{
									"power",
									"skill_colt",
									"skill_sdpistol",
									"skill_deagle",
									"skill_shotgun",
									"skill_mp5",
									"skill_ak47",
									"skill_m4",
									"skill_sniper_rifle",
									"skill_sawnoff",
									"skill_combat_sg",
									"skill_micro_uzi"
								};

								UpdatePlayerDatabaseInt(playerid, skill_db_name[skill_index], GetPlayerSkillAmount(playerid, skill_index));

								format(fmt_text, sizeof fmt_text, "Вы прокачали навык %s на %d ед. Текущее значение: %d ед.",
								skill_name[skill_index], skill_amount, GetPlayerSkillAmount(playerid, skill_index));

								ShowNotificationNew(playerid, 3, 4, 0, 0, fmt_text, "");
							
							}
					else
							{
								format(fmt_text, sizeof fmt_text, "Для прокачки %d ед. навыка требуется %d.00 руб. на счету", skill_amount, skill_price);
								ShowNotificationNew(playerid, 2, 4, 0, 0, fmt_text, "");
							}
						}
					else
						{
							format(fmt_text, sizeof fmt_text, "Максимальное значение навыка: 100 ед., Вы можете прокачать еще %d ед.", skill_max);
							ShowNotificationNew(playerid, 2, 4, 0, 0, fmt_text, "");
						}
					}
					else ShowNotificationNew(playerid, 3, 4, 0, 0, "Введите корректное значение!", "");
				}

			}
			// -----------------------------------------------------------------
			case DIALOG_TEAM_CHANGE_SKIN:
			{
				if(!response) return 1; // Игрок нажал "Отмена"

				new to_player = GetPVarInt(playerid, "change_team_skin_playerid");
				new team_id = GetPlayerTeamEx(playerid);

				// Проверка прав
				if(team_id < 1 || team_id >= MAX_ORG || GetPlayerJob(playerid) < 9 || GetPlayerJob(playerid) > 10)
					return SendClientMessage(playerid, 0x999999FF, "Нет прав на изменение внешности");

				if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || team_id != GetPlayerTeamEx(to_player))
					return SendClientMessage(playerid, 0x999999FF, "Игрок не состоит в организации");

				if(GetPlayerSex(to_player))
					return SendClientMessage(playerid, 0x999999FF, "Нельзя изменить внешность игрокам с женским полом");

				// Получаем индекс выбранного скина
				new index = GetPlayerListitemValue(playerid, listitem);
				new skin_id = GetTeamData(team_id, O_SKINS)[index];

				// Сохраняем скин
				SetPlayerData(to_player, P_OSKIN, skin_id);

				new query[128];
				mysql_format(mysql, query, sizeof query, 
					"UPDATE accounts SET org_skin=%d WHERE id=%d", 
					skin_id, GetPlayerAccountID(to_player));
				mysql_query(mysql, query, false);

				// Применяем скин
				ResetSkin(to_player);

				format(query, sizeof query, "Ваша внешность была изменена %s организации %s[%d]", 
					GetPlayerJob(playerid) >= 10 ? ("лидером") : ("заместителем"), GetPlayerNameEx(playerid), playerid);
				SendClientMessage(to_player, 0x3399FFFF, query);

				format(query, sizeof query, "Вы изменили внешность %s[%d]", GetPlayerNameEx(to_player), to_player);
				SendClientMessage(playerid, 0x3399FFFF, query);

				return 1;
			}


			case DIALOG_TEAM_LEAVE:
			{
				if(response)
				{
					new fmt_text[110];

					format(fmt_text, sizeof fmt_text, "%s %s[%d] покинул организацию по собственному желанию",
					GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid);

					SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x3399FFFF, playerid);

					format(fmt_text, sizeof fmt_text, "Вы покинули организацию \"%s\"", GetTeamName(GetPlayerTeamEx(playerid)));
					SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

					UnInvite(playerid, playerid);
				}
			}
			// -----------------------------------------------------------------
			case DIALOG_DEBTORLIST:
			{
				if(!response) return 1;
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 4) return 1;

				if(0 <= listitem <= 2)
				{
					ShowDebtorListDialog(playerid, listitem);
				}

				return 1;
			}

			case DIALOG_DEBTORLIST_HOUSE..DIALOG_DEBTORLIST_FUEL_ST:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 4) return 1;
				if(!response) return callcmd::debtorlist(playerid, "");
				if(!(0 <= listitem <= 19)) return 1;

				new type = dialogid - DIALOG_DEBTORLIST_HOUSE;
				new buffer = GetPlayerListitemValue(playerid, listitem);

				switch(type)
				{
					case 0:
					{
						if(!GetHouseData(buffer, H_TYPE))
						{
							EnablePlayerGPS(playerid, 35, GetHouseData(buffer, H_POS_X), GetHouseData(buffer, H_POS_Y), GetHouseData(buffer, H_POS_Z), "Дом должника отмечен у Вас на GPS");
						}
					else
						{
							new ent_id = GetHouseData(buffer, H_ENTRACE);

							EnablePlayerGPS(playerid, 35, GetEntranceData(ent_id, E_POS_X), GetEntranceData(ent_id, E_POS_Y), GetEntranceData(ent_id, E_POS_Z), "Подъезд квартиры должника отмечена у Вас на GPS");
						}
					}
					case 1: EnablePlayerGPS(playerid, 35, GetBusinessData(buffer, B_POS_X), GetBusinessData(buffer, B_POS_Y), GetBusinessData(buffer, B_POS_Z), "Предприятие должника отмечено у Вас на GPS");
					case 2: EnablePlayerGPS(playerid, 35, GetFuelStationData(buffer, FS_POS_X), GetFuelStationData(buffer, FS_POS_Y), GetFuelStationData(buffer, FS_POS_Z), "АЗС должника отмечена у Вас на GPS");
					default: return -1;
				}

				return 1;
			}

			case DIALOG_DEBTOR_SELL_LIST:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 7) return 1;
				//if(!response) return callcmd::debtorsell(playerid, "");
				if(!response) return 1;

				switch(listitem)
				{
					case 0:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_HOUSE, DIALOG_STYLE_INPUT,
							"{99CC00}Акт выселения из жилого помещения",
							"Заполните акт выселения из жилого помещения\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер дома/квартиры\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта должник будет выселен",
							"Подписать", "Назад"
						);

						// 0x3399FFFF > Должник был выселен из дома/квартиры. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 1000 руб.

					}
					case 1:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_BIZ, DIALOG_STYLE_INPUT,
							"{99CC00}Акт изъятия предпрятия",
							"Заполните акт изъятия предприятия у должника\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер предприятия\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта предприятие станет собственностью государства",
							"Подписать", "Назад"
						);

						// 0x3399FFFF > Предприятие должника было изъято в пользу государства. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 1000 руб.
					}
					case 2:
					{
						Dialog
						(
							playerid, DIALOG_DEBTOR_SELL_FUEL_ST, DIALOG_STYLE_INPUT,
							"{99CC00}Акт изъятия АЗС",
							"Заполните акт изъятия АЗС у должника\n\n\
							{FFFFFF}Укажите через пробел:\n\n\
							{FFCC00}1. Номер АЗС\n\
							2. ID первого понятого\n\
							3. ID второго понятого\n\n\
							{FFFFFF}Когда закончите составление документа, подпишите его\n\
							Сразу после подписания акта АЗС станет собственностью государства",
							"Подписать", "Назад"
						);
					}
					default: return -1;
				}

				return 1;
			}

			case DIALOG_DEBTOR_SELL_HOUSE:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 4) return 1;

				if(!response) return callcmd::debtorsell(playerid, "");

				new sell_houseid = -1, worker_id[2] = {-1, -1};
				sscanf(inputtext, "ddd", sell_houseid, worker_id[0], worker_id[1]);

				if(strlen(inputtext) > 0)
				{
					if(!(0 <= sell_houseid <= g_house_loaded-1))
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите номер дома/квартиры");

					else if(!IsPlayerInRangeOfPoint(playerid, 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Вы находитесь далеко от дома/квартиры должника");

					else if(!IsPlayerConnected(worker_id[0]) || !IsPlayerLogged(worker_id[0]) || worker_id[0] == playerid)
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID первого понятого");

					else if(!IsPlayerConnected(worker_id[1]) || !IsPlayerLogged(worker_id[1]) || worker_id[1] == playerid || worker_id[0] == worker_id[1])
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID второго понятого");

					else if(GetPlayerTeamEx(worker_id[0]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[0]) < 3 || GetPlayerTeamEx(worker_id[1]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[1]) < 3)
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых не является сотрудником правительства 3 ранга");

					else if(!IsPlayerInRangeOfPoint(worker_id[0], 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)) || !IsPlayerInRangeOfPoint(worker_id[1], 7.0, GetHouseData(sell_houseid, H_POS_X), GetHouseData(sell_houseid, H_POS_Y), GetHouseData(sell_houseid, H_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых находится далеко от дома/квартиры должника");

					else if((((GetHouseData(sell_houseid, H_RENT_DATE) - gettime()) / 86400) + 1) > 0)
						SendClientMessage(playerid, 0xBBBB00FF, "У владельца этого дома/квартиры нет задолжности за неуплату услуг");

					else if(GetHouseData(sell_houseid, H_EVICTION))
						SendClientMessage(playerid, 0xBBBB00FF, "Акт выселения из этого жилого помещения уже подписан");

					else
					{
						SendClientMessage(playerid, 0x3399FFFF, "Должник был выселен из дома/квартиры. На оформление документов потребуется время");
						SendClientMessage(playerid, 0x3399FFFF, "Вы получаете премию 1000 руб.");

						SetPlayerChatBubble(playerid, "+1000 руб", 0x3399FFFF, 5.0, 3000);
						GameTextForPlayer(playerid, "~b~~h~+1000 rub", 4000, 1);
						AddPlayerData(playerid, P_WAGE, +, 1000);
						UpdatePlayerDatabaseInt(playerid, "wage", GetPlayerData(playerid, P_WAGE));

						for(new i; i < 2; i ++)
						{
							SendClientMessage(worker_id[i], 0x3399FFFF, "Вы получили премию 500 руб.");
							SetPlayerChatBubble(worker_id[i], "+500 руб", 0x3399FFFF, 5.0, 3000);
							GameTextForPlayer(worker_id[i], "~b~~h~+500 rub", 4000, 1);
							AddPlayerData(worker_id[i], P_WAGE, +, 500);
							UpdatePlayerDatabaseInt(worker_id[i], "wage", GetPlayerData(worker_id[i], P_WAGE));
						}

						new query[90];

						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET house_type=-1,house_room=-1,house=-1 WHERE id=%d", GetHouseData(sell_houseid, H_OWNER_ID));
						mysql_query(mysql, query, false);

						new owner_player = GetPlayerIDBySqlID(GetHouseData(sell_houseid, H_OWNER_ID));
						if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
						{
							/*if(GetPlayerHouse(owner_player, HOUSE_TYPE_HOME) == sell_houseid)
							{*/
							SetPlayerData(owner_player, P_HOUSE, -1);
							SendClientMessage(owner_player, 0xFF6600FF, "Вы были выселены из дома/квартиры за неуплату услуг");
							//}
						}
						SetHouseData(sell_houseid, H_OWNER_ID, 0);
						SetHouseData(sell_houseid, H_IMPROVEMENTS,		0);

						SetHouseData(sell_houseid, H_RENT_DATE,		0);
						SetHouseData(sell_houseid, H_LOCK_STATUS,		false);
						//SetHouseData(sell_houseid, H_RENT_DATE, gettime() + (random(169200) + 3600));
						SetHouseData(sell_houseid, H_EVICTION, 1);

						mysql_format(mysql, query, sizeof query, "UPDATE houses SET eviction=1, rent_time=%d WHERE id=%d LIMIT 1", GetHouseData(sell_houseid, H_RENT_DATE), GetHouseData(sell_houseid, H_SQL_ID));
						mysql_query(mysql, query, false);

						return 1;
					}
				}

				Dialog
				(
					playerid, DIALOG_DEBTOR_SELL_HOUSE, DIALOG_STYLE_INPUT,
					"{99CC00}Акт выселения из жилого помещения",
					"Заполните акт выселения из жилого помещения\n\n\
					{FFFFFF}Укажите через пробел:\n\n\
					{FFCC00}1. Номер дома/квартиры\n\
					2. ID первого понятого\n\
					3. ID второго понятого\n\n\
					{FFFFFF}Когда закончите составление документа, подпишите его.\n\
					Сразу после подписания акта должник будет выселен.",
					"Подписать", "Назад"
				);
				return 1;
			}

			case DIALOG_DEBTOR_SELL_BIZ:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 4) return 1;

				if(!response) return callcmd::debtorsell(playerid, "");

				new sell_biz_id = -1, worker_id[2] = {-1, -1};
				sscanf(inputtext, "ddd", sell_biz_id, worker_id[0], worker_id[1]);

				if(strlen(inputtext) > 0)
				{
					if(!(0 <= sell_biz_id <= g_business_loaded-1))
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите номер предприятия");

					else if(!IsPlayerInRangeOfPoint(playerid, 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Вы находитесь далеко от предприятия должника");

					else if(!IsPlayerConnected(worker_id[0]) || !IsPlayerLogged(worker_id[0]) || worker_id[0] == playerid)
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID первого понятого");

					else if(!IsPlayerConnected(worker_id[1]) || !IsPlayerLogged(worker_id[1]) || worker_id[1] == playerid || worker_id[0] == worker_id[1])
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID второго понятого");

					else if(GetPlayerTeamEx(worker_id[0]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[0]) < 3 || GetPlayerTeamEx(worker_id[1]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[1]) < 3)
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых не является сотрудником правительства 3 ранга");

					else if(!IsPlayerInRangeOfPoint(worker_id[0], 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)) || !IsPlayerInRangeOfPoint(worker_id[1], 7.0, GetBusinessData(sell_biz_id, B_POS_X), GetBusinessData(sell_biz_id, B_POS_Y), GetBusinessData(sell_biz_id, B_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых находится далеко от предприятия должника");

					else if((((GetBusinessData(sell_biz_id, B_RENT_DATE) - gettime()) / 86400) + 1) > 0)
						SendClientMessage(playerid, 0xBBBB00FF, "У владельца этого предприятия нет задолжности за неуплату услуг");

					else if(GetBusinessData(sell_biz_id, B_EVICTION))
						SendClientMessage(playerid, 0xBBBB00FF, "Акт изъятия этого предприятия уже подписан");

					else
					{
						// 0x3399FFFF > Предприятие должника было изъято в пользу государства. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 1000 руб.

						SendClientMessage(playerid, 0x3399FFFF, "Предприятие должника было изъято в пользу государства. На оформление документов потребуется время");
						SendClientMessage(playerid, 0x3399FFFF, "Вы получаете премию 1000 руб.");

						SetPlayerChatBubble(playerid, "+1000 руб", 0x3399FFFF, 5.0, 3000);
						GameTextForPlayer(playerid, "~b~~h~+1000 rub", 4000, 1);
						AddPlayerData(playerid, P_WAGE, +, 1000);
						UpdatePlayerDatabaseInt(playerid, "wage", GetPlayerData(playerid, P_WAGE));

						for(new i; i < 2; i ++)
						{
							SendClientMessage(worker_id[i], 0x3399FFFF, "Вы получили премию 500 руб.");
							SetPlayerChatBubble(worker_id[i], "+500 руб", 0x3399FFFF, 5.0, 3000);
							GameTextForPlayer(worker_id[i], "~b~~h~+500 rub", 4000, 1);
							AddPlayerData(worker_id[i], P_WAGE, +, 500);
							UpdatePlayerDatabaseInt(worker_id[i], "wage", GetPlayerData(worker_id[i], P_WAGE));
						}

						new query[90];

						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET business=-1 WHERE id=%d", GetBusinessData(sell_biz_id, B_OWNER_ID));
						mysql_query(mysql, query, false);

						new owner_player = GetPlayerIDBySqlID(GetBusinessData(sell_biz_id, B_OWNER_ID));
						if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
						{
							/*if(GetPlayerBusiness(owner_player) == sell_biz_id)
							{*/
							SetPlayerData(owner_player, P_BUSINESS, -1);
							SendClientMessage(owner_player, 0xFF6600FF, "Ваше предприятие было изъято государством за неуплату налогов");
							//}
						}
						SetBusinessData(sell_biz_id, B_OWNER_ID, 0);
						SetBusinessData(sell_biz_id, B_IMPROVEMENTS, 		0);

						SetBusinessData(sell_biz_id, B_PRODS, 			0);
						SetBusinessData(sell_biz_id, B_PROD_PRICE,		0);

						SetBusinessData(sell_biz_id, B_BALANCE,			0);
						SetBusinessData(sell_biz_id, B_RENT_DATE,			0);
						SetBusinessData(sell_biz_id, B_ENTER_MUSIC,		0);
						SetBusinessData(sell_biz_id, B_LOCK_STATUS,		false);
						//SetBusinessData(sell_biz_id, B_RENT_DATE, gettime() + (random(169200) + 3600));
						SetBusinessData(sell_biz_id, B_EVICTION, 1);

						mysql_format(mysql, query, sizeof query, "UPDATE business SET eviction=1, rent_time=%d WHERE id=%d LIMIT 1", GetBusinessData(sell_biz_id, B_RENT_DATE), GetBusinessData(sell_biz_id, B_SQL_ID));
						mysql_query(mysql, query, false);

						return 1;
					}
				}

				Dialog
				(
					playerid, DIALOG_DEBTOR_SELL_BIZ, DIALOG_STYLE_INPUT,
					"{99CC00}Акт изъятия предприятия",
					"Заполните акт изъятия предприятия у должника\n\n\
					{FFFFFF}Укажите через пробел:\n\n\
					{FFCC00}1. Номер предприятия\n\
					2. ID первого понятого\n\
					3. ID второго понятого\n\n\
					{FFFFFF}Когда закончите составление документа, подпишите его\n\
					Сразу после подписания акта предприятие станет собственностью государства",
					"Подписать", "Назад"
				);
				return 1;
			}

			case DIALOG_DEBTOR_SELL_FUEL_ST:
			{
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) < 4) return 1;

				if(!response) return callcmd::debtorsell(playerid, "");

				new sell_fs_id = -1, worker_id[2] = {-1, -1};
				sscanf(inputtext, "ddd", sell_fs_id, worker_id[0], worker_id[1]);

				if(strlen(inputtext) > 0)
				{
					if(!(0 <= sell_fs_id <= g_fuel_station_loaded-1))
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите номер предприятия");

					else if(!IsPlayerInRangeOfPoint(playerid, 7.0, GetFuelStationData(sell_fs_id, FS_POS_X), GetFuelStationData(sell_fs_id, FS_POS_Y), GetFuelStationData(sell_fs_id, FS_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Вы находитесь далеко от предприятия должника");

					else if(!IsPlayerConnected(worker_id[0]) || !IsPlayerLogged(worker_id[0]) || worker_id[0] == playerid)
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID первого понятого");

					else if(!IsPlayerConnected(worker_id[1]) || !IsPlayerLogged(worker_id[1]) || worker_id[1] == playerid || worker_id[0] == worker_id[1])
						SendClientMessage(playerid, 0xBBBB00FF, "Укажите ID второго понятого");

					else if(GetPlayerTeamEx(worker_id[0]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[0]) < 3 || GetPlayerTeamEx(worker_id[1]) != TEAM_GOVERNMENT && GetPlayerJob(worker_id[1]) < 3)
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых не является сотрудником правительства 3 ранга");

					else if(!IsPlayerInRangeOfPoint(worker_id[0], 7.0, GetFuelStationData(sell_fs_id, FS_POS_X), GetFuelStationData(sell_fs_id, FS_POS_Y), GetFuelStationData(sell_fs_id, FS_POS_Z)) || !IsPlayerInRangeOfPoint(worker_id[1], 7.0, GetFuelStationData(sell_fs_id, FS_POS_X), GetFuelStationData(sell_fs_id, FS_POS_Y), GetFuelStationData(sell_fs_id, FS_POS_Z)))
						SendClientMessage(playerid, 0xBBBB00FF, "Один из понятых находится далеко от предприятия должника");

					else if((((GetFuelStationData(sell_fs_id, FS_RENT_DATE) - gettime()) / 86400) + 1) > 0)
						SendClientMessage(playerid, 0xBBBB00FF, "У владельца этого предприятия нет задолжности за неуплату услуг");

					else if(GetFuelStationData(sell_fs_id, FS_EVICTION))
						SendClientMessage(playerid, 0xBBBB00FF, "Акт изъятия этого предприятия уже подписан");

					else
					{
						// 0x3399FFFF > АЗС должника была изъята в пользу государства. На оформление документов потребуется время
						// 0x3399FFFF > Вы получаете премию 1000 руб.

						SendClientMessage(playerid, 0x3399FFFF, "АЗС должника была изъята в пользу государства. На оформление документов потребуется время");
						SendClientMessage(playerid, 0x3399FFFF, "Вы получаете премию 1000 руб.");

						SetPlayerChatBubble(playerid, "+1000 руб", 0x3399FFFF, 5.0, 3000);
						GameTextForPlayer(playerid, "~b~~h~+1000 rub", 4000, 1);
						AddPlayerData(playerid, P_WAGE, +, 1000);
						UpdatePlayerDatabaseInt(playerid, "wage", GetPlayerData(playerid, P_WAGE));

						for(new i; i < 2; i ++)
						{
							SendClientMessage(worker_id[i], 0x3399FFFF, "Вы получили премию 500 руб.");
							SetPlayerChatBubble(worker_id[i], "+500 руб", 0x3399FFFF, 5.0, 3000);
							GameTextForPlayer(worker_id[i], "~b~~h~+500 rub", 4000, 1);
							AddPlayerData(worker_id[i], P_WAGE, +, 500);
							UpdatePlayerDatabaseInt(worker_id[i], "wage", GetPlayerData(worker_id[i], P_WAGE));
						}

						new query[90];

						mysql_format(mysql, query, sizeof query, "UPDATE accounts SET eviction=1, fuel_st = -1 WHERE id=%d", GetFuelStationData(sell_fs_id, FS_OWNER_ID));
						mysql_query(mysql, query, false);

						new owner_player = GetPlayerIDBySqlID(GetFuelStationData(sell_fs_id, FS_OWNER_ID));
						if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player))
						{
							/*if(GetPlayerFuelStation(owner_player) == sell_fs_id)
							{*/
							SetPlayerData(owner_player, P_FUEL_ST, -1);
							SendClientMessage(owner_player, 0xFF6600FF, "Ваше предприятие было изъято государством за неуплату налогов");
							//}
						}
						SetFuelStationData(sell_fs_id, FS_IMPROVEMENTS, 0);

						SetFuelStationData(sell_fs_id, FS_FUELS, 		1000);
						SetFuelStationData(sell_fs_id, FS_FUEL_PRICE,	3);
						SetFuelStationData(sell_fs_id, FS_BUY_FUEL_PRICE,0);

						SetFuelStationData(sell_fs_id, FS_BALANCE,		0);
						SetFuelStationData(sell_fs_id, FS_RENT_DATE,		0);
						SetFuelStationData(sell_fs_id, FS_LOCK_STATUS,	false);
						//SetFuelStationData(sell_fs_id, FS_RENT_DATE, gettime() + (random(169200) + 3600));
						SetFuelStationData(sell_fs_id, FS_EVICTION, 1);

						mysql_format(mysql, query, sizeof query, "UPDATE fuel_stations SET rent_time=%d WHERE id=%d LIMIT 1", GetFuelStationData(sell_fs_id, FS_RENT_DATE), GetFuelStationData(sell_fs_id, FS_SQL_ID));
						mysql_query(mysql, query, false);

						UpdateFuelStationLabel(sell_fs_id);

						return 1;
					}
				}

				Dialog
				(
					playerid, DIALOG_DEBTOR_SELL_FUEL_ST, DIALOG_STYLE_INPUT,
					"{99CC00}Акт изъятия АЗС",
					"Заполните акт изъятия АЗС у должника\n\n\
					{FFFFFF}Укажите через пробел:\n\n\
					{FFCC00}1. Номер АЗС\n\
					2. ID первого понятого\n\
					3. ID второго понятого\n\n\
					{FFFFFF}Когда закончите составление документа, подпишите его\n\
					Сразу после подписания акта АЗС станет собственностью государства",
					"Подписать", "Назад"
				);
				return 1;
			}

			case DIALOG_ADVISOR_MENU:
			{
				if(!response) return 1;

				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) != 5) return 1;

				switch(listitem)
				{
					case 0:
					{
						if(!IsValidDynamic3DTextLabel(g_player[playerid][P_ADVISOR_LABEL]))
						{
							g_player[playerid][P_ADVISOR_LABEL] = CreateDynamic3DTextLabel("Советник", 0xFFCC33FF, 0.0, 0.0, 0.3, 10.0, playerid);
							Attach3DTextLabelToPlayer(g_player[playerid][P_ADVISOR_LABEL], playerid, 0.0, 0.0, -0.8);

							SendClientMessage(playerid, 0x3399FFFF, "Вы надели бейджик");
						}
					else
						{
							DestroyDynamic3DTextLabel(g_player[playerid][P_ADVISOR_LABEL]);
							g_player[playerid][P_ADVISOR_LABEL] = Text3D: -1;

							SendClientMessage(playerid, 0x3399FFFF, "Вы сняли бейджик");
						}
					}
					case 1:
					{
						if(GetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT))
						{
							SetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT, false);
							SendClientMessage(playerid, 0x66CC00FF, "Вы включили отображение рации организации");
						}
					else
						{
							SetPlayerData(playerid, P_ADVISOR_BLOCK_CHAT, true);
							SendClientMessage(playerid, 0xFF6600FF, "Вы отключили отображение рации организации");
						}
					}
					case 2:
					{
						if(GetPlayerJob(playerid) != 5)
						{
							SendClientMessage(playerid, 0x999999FF, "Функция доступна советникам по гос. организациям");
						}
					else
						{
							Dialog
							(
								playerid, DIALOG_ADVISOR_TEAM_STRUCTURE, DIALOG_STYLE_LIST,
								"{33CC66}Выберите организацию",
								"1. Правительство области\n\
								2. Воинская часть\n\
								3. Городская больница\n\
								4. СМИ\n\
								5. Отдел полиции №1 (ГИБДД)\n\
								6. Отдел полиции №2 (УМВД)\n\
								7. ФСБ",
								"Выбрать", "Отмена"
							);
							return 1;
						}
					}
					default: return -1;
				}

				callcmd::smenu(playerid, "");
				return 1;
			}

			case DIALOG_ADVISOR_TEAM_STRUCTURE:
			{
				if(!response) return 1;
				if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT || GetPlayerJob(playerid) != 5) return 1;

				if(0 <= listitem <= 6)
				{
					ShowTeamStructureDialog(playerid, (listitem + 1));
				}

				return 1;
			}

			// -----------------------------------------------------------------
			case DIALOG_ADMINCALL_MENU:
            {
                switch(listitem)
                {
                    case 0: ShowPlayerReportDialog(playerid);
                }
            }
			case DIALOG_ADMIN_PANEL:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 0: // Список администрации
					{
						result = mysql_query(mysql, "SELECT * FROM accounts WHERE admin != 0 ORDER BY admin DESC", true);
						rows = cache_num_rows(result);

						format(text, sizeof text, "{3399FF}№ акк.\tИмя\t\t\tАдм.ранг\tВ игре сегодня{FFFFFF}");

						for(new i = 0; i < rows; i++)
						{
							new name[21],
								user_id = cache_get_field_content_int(i, "id"),
								lvl = cache_get_field_content_int(i, "admin"),
								game_for_day = cache_get_field_content_int(i, "game_for_day"),
								game_for_day_text[32];

							cache_get_field_content(i, "name", name);
							format(game_for_day_text, sizeof game_for_day_text, "%d ч %d мин", ConvertUnixTime(game_for_day, CONVERT_TIME_TO_HOURS), ConvertUnixTime(game_for_day, CONVERT_TIME_TO_MINUTES));

							format(fmt_text, sizeof fmt_text, "\n%d.\t%s%s%d\t\t%s", user_id, name, strlen(name) > 14 ? "\t" : "\t\t", lvl, game_for_day_text);
							strcat(text, fmt_text);
							SetPlayerListitemValue(playerid, i+1, user_id);
						}

						cache_delete(result);

						Dialog(playerid, DIALOG_ADMINS, DIALOG_STYLE_LIST, "{FFCC00}Список администрации", text, "Выбрать", "Отмена");
					}

					case 1: // Список лидеров
					{
						result = mysql_query(mysql, "SELECT * FROM accounts WHERE job=10 ORDER BY team ASC", true);
						rows = cache_num_rows(result);

						format(text, sizeof text, "{3399FF}№ акк.\tИмя\t\t\tФракция\tВ игре сегодня{FFFFFF}");

						for(new i = 0; i < rows; i++)
						{
							new name[21],
								user_id = cache_get_field_content_int(i, "id"),
								team = cache_get_field_content_int(i, "team"),
								game_for_day = cache_get_field_content_int(i, "game_for_day"),
								game_for_day_text[32];

							cache_get_field_content(i, "name", name);
							format(game_for_day_text, sizeof game_for_day_text, "%d ч %d мин", ConvertUnixTime(game_for_day, CONVERT_TIME_TO_HOURS), ConvertUnixTime(game_for_day, CONVERT_TIME_TO_MINUTES));

							format(fmt_text, sizeof fmt_text, "\n%d.\t%s%s%d\t\t%s", user_id, name, strlen(name) > 14 ? "\t" : "\t\t", team, game_for_day_text);
							strcat(text, fmt_text);
							SetPlayerListitemValue(playerid, i+1, user_id);
						}

						cache_delete(result);

						Dialog(playerid, DIALOG_LEADERS, DIALOG_STYLE_LIST, "{FFCC00}Список лидеров", text, "Выбрать", "Отмена");
					}
					case 2:
					{
					callcmd::inforestart(playerid);
					} 
					case 3:
					{
					//callcmd::tehnical(playerid, "");
					} 
					case 4:
					{
						callcmd::fullprods(playerid, "5000");
					}
					case 5:
					{
						SCM(playerid, -1, "{FFFF00}| {FFFFFF}В разработке.");
					}
					case 6:
					{
					callcmd::fullfuels(playerid, "5000");
					}
				}
				return 1;
			}
			case DIALOG_REWARDS:
			{
				if(!response) return 1;

				new fmt_text[128],
					text[1440],
					Cache: result,
					rows;

				switch(listitem)
				{
					case 1:
					{
					callcmd::givecash(playerid, "10000000");
					}
					case 2:
					{
					callcmd::givedonate(playerid, "25000");
					}
					case 3:
					{
					callcmd::giveepoints(playerid, "50000");
					}
				}
				return 1;
			}
			case DIALOG_SERVER_SETTINGS:
			{
				if(response)
				{
					switch(listitem)
					{
						case 0:
						{
							Dialog
							(
									playerid, DIALOG_SERVER_SETTINGS_ADM, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите новую цену на админку\n\
								\tПримечание: Нельзя меньше 40 и больше 200!",
								"Далее", "Отмена"
							);
						}
						case 1:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_HELP, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите новую цену на хелперку\n\
								\tПримечание: Нельзя меньше 40 и больше 200!",
								"Далее", "Отмена"
							);
						}
						case 2:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_RUB, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите новую cумму раздачи рублей каждый час\n\
								\tПримечание: Нельзя меньше 1 и больше 5!",
								"Далее", "Отмена"
							);
						}
						case 3:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_DON, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите новый множитель доната\n\
								\tПримечание: Нельзя меньше 1 и больше 3!",
								"Далее", "Отмена"
							);
						}
						case 4:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_COINS, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите количество монет которое будет выдаваться каждый час\n\
								\tПримечание: Нельзя меньше 1 и больше 3!",
								"Далее", "Отмена"
							);
						}
						case 5:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_BONUSM, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите количество денег которое будет выдаваться при регистрации\n\
								\tПримечание: Нельзя меньше 100 и больше 100кк!",
								"Далее", "Отмена"
							);
						}
						case 6:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_BONUSD, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите количество доната которое будет выдаваться при регистрации\n\
								\tПримечание: Нельзя меньше 0 и больше 20000!",
								"Далее", "Отмена"
							);
						}
						case 7:
						{
							Dialog
							(
								playerid, DIALOG_SERVER_SETTINGS_BONUSL, DIALOG_STYLE_INPUT,
								"Управление сервером",
								"Введите уровень который будет выдаваться при регистрации\n\
								\tПримечание: Нельзя меньше 1 и больше 20!",
								"Далее", "Отмена"
							);
						}
						case 8:
						{
							if(Config[sBuyBiz] == 0)
						    {
								Dialog
								(
									playerid, DIALOG_BUYBIZ_CLOSE, DIALOG_STYLE_MSGBOX,
									"Запрет на покупку бизнеса",
									""c_b"Вы уверены, что хотите запретить покупать бизнесы на сервере?",
									"Далее", "Отмена"
								);
							}

							if(Config[sBuyBiz] == 1)
						    {
								Dialog
								(
									playerid, DIALOG_BUYBIZ_OPEN, DIALOG_STYLE_MSGBOX,
									"Разрешение на покупку бизнесов",
									""c_b"Вы уверены, что хотите разрешить покупать бизнесы на сервере?",
									"Далее", "Отмена"
								);
							}
						}
					}
				}
			}
			case DIALOG_BUYBIZ_OPEN: //===
			{
		        //new str[180];
				//new fmt_text[100];

				Send(playerid,-1,"Успешно");

                Config[sBuyBiz] = 0;//===

                mysql_format(mysql, str, 256, "UPDATE server_settings SET BuyBiz = 0");//===
                mysql_query(mysql, str);

                return 1;
			}
			case DIALOG_BUYBIZ_CLOSE: //===
			{
		        //new str[180];
				//new fmt_text[200];

				Send(playerid,-1,"Успешно");

                Config[sBuyBiz] = 1;//===

                mysql_format(mysql, str, 256, "UPDATE server_settings SET BuyBiz = 1");//===
                mysql_query(mysql, str);

                return 1;
			}
			case DIALOG_SERVER_SETTINGS_ADM:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(price > 40)
	                    {

	                        Config[admin_price] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET admin_price = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 40 руб нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_COINS:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(1 <= price <= 3)
	                    {

	                        Config[sGiveCoins] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET GiveCoins = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 1 и выше 3 монеты нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_BONUSM:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(100 <= price <= 100000000)
	                    {

	                        Config[sBonusMoney] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET BonusMoney = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 100 и выше 100кк нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_BONUSD:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(0 <= price <= 20000)
	                    {

	                        Config[sBonusDonate] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET BonusDonate = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 0 и выше 20000 доната нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_BONUSL:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(1 <= price <= 20)
	                    {

	                        Config[sBonusLevel] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET BonusLevel = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 1 и выше 20 лвл нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_HELP:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(price > 20)
	                    {

	                        Config[helper_price] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET helper_price = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Ниже 20 руб нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_RUB:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(1 <= price <= 5)
	                    {

	                        Config[sDistRub] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET distrub = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Меньше 1 руб и больше 5 руб нельзя!");
	                }
	            }
			}
			case DIALOG_SERVER_SETTINGS_DON:
			{
				if(response)
	            {
	                new price = strval(inputtext);
	                if(price && IsNumeric(inputtext))
	                {
	                    if(1 <= price <= 3)
	                    {

	                        Config[sDonPower] = price;
	                        mysql_format(mysql, str, 256, "UPDATE server_settings SET donpower = %d",price);
	                        mysql_query(mysql, str);
	                        return 1;
	                    }
	                    SendClientMessage(playerid, -1, "Меньше 1 и больше 3  нельзя!");
	                }
	            }
			}
			case DIALOG_ADMIN_LOGIN:
            {
                return SRAdmin_PinResponse(playerid, dialogid, response, inputtext);
            }
			case DIALOG_ADMIN_REG:
            {
                return SRAdmin_PinResponse(playerid, dialogid, response, inputtext);
            }
			case DIALOG_ADMINS:
{
    if(SRAdmin_ListResponse(playerid, response, listitem)) return 1;
    // Remaining panel path is administrative, never a public /admins list response.
    if(!SRAdmin_Require(playerid, 13)) return 1;

    if(!response) return 1;
 
    new user_id = GetPlayerListitemValue(playerid, listitem);
    SetPVarInt(playerid, "admin_panel_user_id", user_id);
 
    Dialog
    (
        playerid, DIALOG_EDIT_ADMIN, DIALOG_STYLE_LIST,
        "{FFCC00}Редактировать администратора",
        "\
        1. Понизить/повысить адм.ранг\n\
        2. Разжаловать администратора\n\
        {ff3300}3. Заблокировать аккаунт\
        ",
        "Выбрать", "Отмена"
    );
 
    return 1;
}

			case DIALOG_EDIT_ADMIN:
{
    if(!response) return 1; // Просто закрываем диалог вместо вызова несуществующей команды

    new fmt_text[128],
        user_id = GetPVarInt(playerid, "admin_panel_user_id");

    switch(listitem)
    {
        case 0:
        {
            format
            (
                fmt_text, sizeof fmt_text,
                "{FFFFFF}\
                Изменение администраторского ранга\n\n\
                ID аккаунта: %d\n\
                Имя: \t%s\
                ",
                user_id, GetPlayerNameBySqlID(user_id)
            );

            Dialog(playerid, DIALOG_EDIT_ADMIN_RANG, DIALOG_STYLE_MSGBOX, "{FFCC00}Изменение адм.ранга", fmt_text, "Повысить", "Понизить");
        }
        case 1:
        {
            format
            (
                fmt_text, sizeof fmt_text,
                "{FFFFFF}\
                Разжалование администратора\n\n\
                ID аккаунта: %d\n\
                Имя: \t%s\n\n\
                Вы действительно хотите разжаловать администратора?\
                ",
                user_id, GetPlayerNameBySqlID(user_id)
            );

            Dialog(playerid, DIALOG_EDIT_ADMIN_RANG, DIALOG_STYLE_MSGBOX, "{FFCC00}Разжалование администратора", fmt_text, "Да", "Нет");
        }
    }

    return 1;
}

			case DIALOG_EDIT_ADMIN_RANG:
			{
				new user_id = GetPVarInt(playerid, "admin_panel_user_id"),
					player_id = GetPlayerIDBySqlID(user_id);

				if(player_id != -1)
				{
					if(response) AddPlayerData(player_id, P_ADMIN, +, 1);
					else AddPlayerData(player_id, P_ADMIN, -, 1);
					UpdatePlayerDatabaseInt(player_id, "admin", GetPlayerData(player_id, P_ADMIN));
					if(response) SendClientMessage(playerid, 0x66CC33FF, "Ваш администраторский ранг был повышен");
					else SendClientMessage(playerid, 0xFF3300FF, "Ваш администраторский ранг был понижен");
				}
					else
				{
					new query[55],
						Cache: result,
						admin_rank;

					mysql_format(mysql, query, sizeof query, "SELECT admin FROM accounts WHERE id=%d", user_id);
					result = mysql_query(mysql, query, true);

					if(!cache_num_rows(result)) return 0;

					admin_rank = cache_get_row_int(0, 0);

					cache_delete(result);

					if(response) admin_rank++;
					else admin_rank--;

					mysql_format(mysql, query, sizeof query, "UPDATE accounts SET admin=%d WHERE id=%d", user_id, admin_rank);
					result = mysql_query(mysql, query, false);
				}


				return 1;
			}

			case DIALOG_LEADERS:
{
    if(!response) return 1; // Просто закрываем диалог вместо вызова несуществующей команды

    new user_id = GetPlayerListitemValue(playerid, listitem);
    SetPVarInt(playerid, "admin_panel_user_id", user_id);

    Dialog
    (
        playerid, DIALOG_EDIT_LEADER, DIALOG_STYLE_LIST,
        "{FFCC00}Редактировать лидера",
        "\
        1. Изменить управляемую фракцию\n\
        2. Разжаловать лидера\n\
        {ff3300}3. Заблокировать аккаунт\
        ",
        "Выбрать", "Отмена"
    );

    return 1;
}
			// -----------------------------------------------------------------
			case DIALOG_TELEPORT_LIST:
            {
                return SRAdmin_TeleportResponse(playerid, response, listitem);
            }
			// -----------------------------------------------------------------
			case DIALOG_SET_DOUBLING:
			{
				if(response)
				{
					new fmt_text[50],
						bool: doubling = g_doubling[listitem];

					static const doubling_name[3][24] = {"доната", "очков опыта", "зарплаты на подработках"};

					g_doubling[listitem] = doubling ^ true;

					format(fmt_text, sizeof fmt_text, "Вы %s удвоение %s", doubling ? "выключили" : "включили", doubling_name[listitem]);
					SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

					format(fmt_text, sizeof fmt_text, "%s удвоение %s", doubling ? "Выключил" : "Включил", doubling_name[listitem]);
					SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
				}
			}
			// -----------------------------------------------------------------
			// -----------------------------------------
			case DIALOG_GANG_REPOSITORY:
			{
				if(response)
				{
					new item_names[4][10] = {"наркотики", "Патроны", "Материалы", "деньги"},
						description[32],
						fmt_text[70],
						status;

					if(0 <= listitem <= 3)
						status = 1;

					SetPVarInt(playerid, "gr_state", status);
					SetPVarInt(playerid, "gr_item", status ? listitem : listitem - 4);

					format(description, sizeof description, "{FFCD00}%s %s", status ? "Положить" : "Взять", status ? item_names[listitem] : item_names[listitem - 4]);
					format(fmt_text, sizeof fmt_text, "{FFFFFF}Введите количество, которое Вы хотите {FFCD00}%s:", status ? "положить" : "взять");

					Dialog(playerid, DIALOG_GANG_REPOSITORY_USE, DIALOG_STYLE_INPUT, description, fmt_text, "Далее", "Отмена");
				}
			}
			case DIALOG_GANG_REPOSITORY_USE:
			{
				if(response)
				{
					new status = GetPVarInt(playerid, "gr_state"),
						item = GetPVarInt(playerid, "gr_item"),
						item_count = strval(inputtext),
						repository_id = (GetPlayerTeamEx(playerid) - TEAM_OPG_ARZAMASKAYA);

					if(item_count < 1) return SendClientMessage(playerid, 0x999999FF, "Неверное количество");

					new item_names[4][12] = {"наркотиков", "патронов", "Материалыа", "денег"},
						item_type[4][4] = {"г", "шт.", "кг", "руб"};

					new fmt_text[90];

					switch(status)
					{
						case 0:
						{
							if(!GetGangRepositoryData(repository_id, GR_LOCK))
								return SendClientMessage(playerid, 0x999999FF, "Склад закрыт. Вы не можете ничего брать");

							switch(item)
							{
								case 0:
								{
									if(GetGangRepositoryData(repository_id, GR_DRUGS) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "На складе нет такого количества наркотиков");

									if((GetPlayerData(playerid, P_DRUGS) + item_count) > GetPlayerMaxStorage(playerid, STORAGE_DRUGS))
										return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете унести с собой столько наркотиков");

									AddPlayerData(playerid, P_DRUGS, +, item_count);
									UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

									SetGangRepositoryData(repository_id, GR_DRUGS, GetGangRepositoryData(repository_id, GR_DRUGS) - item_count);
									UpdateGangRepository(repository_id);
								}
								case 1:
								{
									if(GetGangRepositoryData(repository_id, GR_AMMO) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "На складе нет такого количества патронов");

									if((GetPlayerData(playerid, P_AMMO) + item_count) > GetPlayerMaxStorage(playerid, STORAGE_AMMO))
										return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете унести с собой столько патронов");

									AddPlayerData(playerid, P_AMMO, +, item_count);
									UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

									SetGangRepositoryData(repository_id, GR_AMMO, GetGangRepositoryData(repository_id, GR_AMMO) - item_count);
									UpdateGangRepository(repository_id);
								}
								case 2:
								{
									if(GetGangRepositoryData(repository_id, GR_METALL) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "На складе нет такого количества Материалыа");

									if((GetPlayerData(playerid, P_METALL) + item_count) > GetPlayerMaxStorage(playerid, STORAGE_METALL))
										return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете унести с собой столько Материалыа");

									AddPlayerData(playerid, P_METALL, +, item_count);
									UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

									SetGangRepositoryData(repository_id, GR_METALL, GetGangRepositoryData(repository_id, GR_METALL) - item_count);
									UpdateGangRepository(repository_id);
								}
								case 3:
								{
									if(GetGangRepositoryData(repository_id, GR_MONEY) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "На складе нет такого количества денег");

									GivePlayerMoneyEx(playerid, item_count, "Взял со склада банды", true, true);

									SetGangRepositoryData(repository_id, GR_MONEY, GetGangRepositoryData(repository_id, GR_MONEY) - item_count);
									UpdateGangRepository(repository_id);
								}
							}

							format(fmt_text, sizeof fmt_text, "%s [id %d] взял(а) со склада банды {3399FF}%d %s {66CC33}%s",
							GetPlayerNameEx(playerid), playerid, item_count, item_type[item], item_names[item]);

							SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x66CC33FF);
						}
						case 1:
						{
							switch(item)
							{
								case 0:
								{
									if(GetPlayerData(playerid, P_DRUGS) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества наркотиков");

									AddPlayerData(playerid, P_DRUGS, -, item_count);
									UpdatePlayerDatabaseInt(playerid, "drugs", GetPlayerData(playerid, P_DRUGS));

									SetGangRepositoryData(repository_id, GR_DRUGS, GetGangRepositoryData(repository_id, GR_DRUGS) + item_count);
									UpdateGangRepository(repository_id);
								}
								case 1:
								{
									if(GetPlayerData(playerid, P_AMMO) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества патронов");

									AddPlayerData(playerid, P_AMMO, -, item_count);
									UpdatePlayerDatabaseInt(playerid, "ammo", GetPlayerData(playerid, P_AMMO));

									SetGangRepositoryData(repository_id, GR_AMMO, GetGangRepositoryData(repository_id, GR_AMMO) + item_count);
									UpdateGangRepository(repository_id);
								}
								case 2:
								{
									if(GetPlayerData(playerid, P_METALL) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества Материалыа");

									AddPlayerData(playerid, P_METALL, -, item_count);
									UpdatePlayerDatabaseInt(playerid, "metall", GetPlayerData(playerid, P_METALL));

									SetGangRepositoryData(repository_id, GR_METALL, GetGangRepositoryData(repository_id, GR_METALL) + item_count);
									UpdateGangRepository(repository_id);
								}
								case 3:
								{
									if(GetPlayerMoneyEx(playerid) < item_count)
										return SendClientMessage(playerid, 0x999999FF, "У Вас нет такого количества денег");

									GivePlayerMoneyEx(playerid, -item_count, "Положил на склад банды", true, true);

									SetGangRepositoryData(repository_id, GR_MONEY, GetGangRepositoryData(repository_id, GR_MONEY) + item_count);
									UpdateGangRepository(repository_id);
								}
							}

							format(fmt_text, sizeof fmt_text, "%s [id %d] положил(а) на склад банды {3399FF}%d %s {66CC33}%s",
							GetPlayerNameEx(playerid), playerid, item_count, item_type[item], item_names[item]);

							SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x66CC33FF);
						}
					}
				}
			}
			// -----------------------------------------
						case DIALOG_ADVERT_EDIT:
			{
				new ad_id = GetPVarInt(playerid, "advert_id"),
					fmt_text[360];

				if(ad_id < 0 || ad_id >= g_advert_created)
				{
					DeletePVar(playerid, "advert_id");
					return SendClientMessage(playerid, 0x999999FF, "РћР±СЉСЏРІР»РµРЅРёРµ РЅРµ РЅР°Р№РґРµРЅРѕ");
				}

				if(GetAdvertData(ad_id, A_CREATOR) == INVALID_PLAYER_ID)
				{
					SetAdvertData(ad_id, A_EDIT, false);
					DeletePVar(playerid, "advert_id");
					return SendClientMessage(playerid, 0x999999FF, "РђРІС‚РѕСЂ РѕР±СЉСЏРІР»РµРЅРёСЏ РѕС‚РєР»СЋС‡РёР»СЃСЏ");
				}

				if(response)
				{
					if(strlen(inputtext))
					{
						utf8_to_cp1251(inputtext);
						format(g_advert[ad_id][A_TEXT], 128, inputtext);
					}

					format(fmt_text, sizeof fmt_text, "%s | РћС‚РїСЂР°РІРёР»: %s[%d] (С‚РµР». %d)", GetAdvertData(ad_id, A_TEXT),
					GetPlayerNameEx(GetAdvertData(ad_id, A_CREATOR)), GetAdvertData(ad_id, A_CREATOR),
					GetPlayerPhone(GetAdvertData(ad_id, A_CREATOR)));

					SendClientMessageToAll(0x00CC00FF, fmt_text);

					format(fmt_text, sizeof fmt_text, " РћР±СЉСЏРІР»РµРЅРёРµ %s СЃРѕС‚СЂСѓРґРЅРёРє РЎРњР? %s", strlen(inputtext) ? "РѕС‚СЂРµРґР°РєС‚РёСЂРѕРІР°Р»" : "РїСЂРѕРІРµСЂРёР»",
					GetPlayerNameEx(playerid));
					SendClientMessageToAll(0x009900FF, fmt_text);
					
					AddPlayerData(playerid, P_PROGRESS_EXP_5, +, 1);
					UpdatePlayerDatabaseInt(playerid, "ProgressExp5", GetPlayerData(playerid, P_PROGRESS_EXP_5));

					if(GetPlayerData(playerid, P_PROGRESS_EXP_5) == 1000)
					{
					    SendClientMessage(playerid, COR_QUEST, "[Р”РѕСЃС‚РёР¶РµРЅРёСЏ]: "c_b"Р’С‹ СѓСЃРїРµС€РЅРѕ РІС‹РїРѕР»РЅРёР»Рё РґРѕСЃС‚РёР¶РµРЅРёРµ "c_i"'Р Р°РґРёРѕС†РµРЅС‚СЂ'. "c_b"РќР°РіСЂР°РґР°: "c_s"50 DONATE-RUB");
					    GivePlayerDonateRub(playerid, 50, "Р’С‹РїРѕР»РЅРµРЅРёРµ РґРѕСЃС‚РёР¶РµРЅРёСЏ / С„СЂР°РєС†РёСЏ");

					    SetPlayerData(playerid, P_PROGRESS_5, 1);
					    UpdatePlayerDatabaseInt(playerid, "Progress5", 1);
					    
					    AddPlayerData(playerid, P_TOP_4, +, 1);
						UpdatePlayerDatabaseInt(playerid, "TOP_Progress", GetPlayerData(playerid, P_TOP_4));
					}
					
					AddPlayerData(playerid, P_F_QUEST_EXP_4, +, 1);
					UpdatePlayerDatabaseInt(playerid, "FracQuestExp4", GetPlayerData(playerid, P_F_QUEST_EXP_4));

					if(GetPlayerData(playerid, P_F_QUEST_EXP_4) == 150)
					{
					    SendClientMessage(playerid, COR_QUEST, "[РљРІРµСЃС‚С‹]: "c_b"Р’С‹ СѓСЃРїРµС€РЅРѕ РІС‹РїРѕР»РЅРёР»Рё РєРІРµСЃС‚ "c_i"'Р Р°РґРёРѕСЃС‚Р°РЅС†РёСЏ РЅР° СЃРІСЏР·Рё'. "c_b"РќР°РіСЂР°РґР°: "c_s"1 CASE(/opencase)");

				        AddPlayerData(playerid, P_DONATE_CASE, +, 1);

					    SetPlayerData(playerid, P_F_QUEST_4, 1);
					    UpdatePlayerDatabaseInt(playerid, "FracQuest4", 1);
					    
					    AddPlayerData(playerid, P_TOP_5, +, 1);
						UpdatePlayerDatabaseInt(playerid, "TOP_Quest", GetPlayerData(playerid, P_TOP_5));
					}
				}
				else
				{
					if(!strlen(inputtext))
					{
						format
						(
							fmt_text, sizeof fmt_text,
							"{FFFFFF}РћС‚РїСЂР°РІРёС‚РµР»СЊ: %s\n\nРўРµРєСЃС‚:\n{FFCD00}%s\n\n"\
							"{FF0000}Р’РІРµРґРёС‚Рµ РїСЂРёС‡РёРЅСѓ РѕС‚РєР»РѕРЅРµРЅРёСЏ РѕР±СЉСЏРІР»РµРЅРёСЏ.",
							GetPlayerNameEx(GetAdvertData(ad_id, A_CREATOR)), GetAdvertData(ad_id, A_TEXT)
						);
						Dialog(playerid, DIALOG_ADVERT_EDIT, DIALOG_STYLE_INPUT, "{00CC00}РџСѓР±Р»РёРєР°С†РёСЏ РѕР±СЉСЏРІР»РµРЅРёСЏ", fmt_text, "РћС‚РїСЂР°РІРёС‚СЊ", "РћС‚РєР»РѕРЅРёС‚СЊ");
						return 1;
					}

					utf8_to_cp1251(inputtext);
					new creator_id = GetAdvertData(ad_id, A_CREATOR);

					if(creator_id != INVALID_PLAYER_ID)
					{
						format(fmt_text, sizeof fmt_text, "%s %s[%d] РѕС‚РєР»РѕРЅРёР» Р’Р°С€Рµ РѕР±СЉСЏРІР»РµРЅРёРµ. РџСЂРёС‡РёРЅР°: %s",
						GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, inputtext);

						SendClientMessage(creator_id, 0xFF5533FF, fmt_text);
					}

					format(fmt_text, sizeof fmt_text, "[РЎРњР?] %s %s[%d] РѕС‚РєР»РѕРЅРёР» РѕР±СЉСЏРІР»РµРЅРёРµ в„–%d. РџСЂРёС‡РёРЅР°: %s",
					GetPlayerJobAndRankName(playerid), GetPlayerNameEx(playerid), playerid, ad_id + 1, inputtext);

					SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_text, 0x99CC99FF, playerid);

					format(fmt_text, sizeof fmt_text, "Р’С‹ РѕС‚РєР»РѕРЅРёР»Рё РѕР±СЉСЏРІР»РµРЅРёРµ в„–%d. РџСЂРёС‡РёРЅР°: %s", ad_id + 1, inputtext);
					SendClientMessage(playerid, 0x66CC33FF, fmt_text);
				}

				DeletePVar(playerid, "advert_id");
				DeleteAdvert(ad_id);
			}
			case DIALOG_MPREG:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							SpawnDeathMatch(playerid);
							Send(playerid,COR_SERVER,"[Успешно]: "c_b"Вы телепортировались на DM ZONE, чтобы выйти с нее - введите /dmzexit");
							Send(playerid,COR_SERVER,"[Информация]: "c_b"Чтобы посмотреть ТОП ИГРОКОВ по киллам на DM ZONE, введите /dmztop");
							Send(playerid,COR_SERVER,"[информация]: "c_b"За каждый килл вы будете получать 25.000 rub! И еще за каждые 10 кииллов - 1 DONATE RUB!");
							
							SetPlayerData(playerid, P_DMZ_STATUS, 1);
						}
					}
				}
			}
			// -----------------------------------------
			case DIALOG_ARMORY:
			{
				if(response)
				{
					switch(listitem + 1)
					{
						case 1:
						{
							if(GetPVarInt(playerid, "took_nitestick") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали дубинку");

							GivePlayerWeapon(playerid, 3, 1);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли дубинку");

							SetPVarInt(playerid, "took_nitestick", gettime() + 300);
						}
						case 2:
						{
							if(GetPVarInt(playerid, "took_mask") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали маску");

							if(GetPlayerData(playerid, P_MASK) == 1)
								return SendClientMessage(playerid, 0x999999FF, "У Вас уже есть маска");

							SetPlayerData(playerid, P_MASK, 1);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли маску");

							SetPVarInt(playerid, "took_mask", gettime() + 300);
						}
						case 3:
						{
							new Float: armour;

							GetPlayerArmour(playerid, armour);

							if(armour > 20.0)
								return SendClientMessage(playerid, 0x999999FF, "У Вас уже есть бронежилет");

							SetPlayerArmour(playerid, 100.0);

							SendClientMessage(playerid, 0x3399FFFF, "Вы надели бронежилет");
						}
						case 4:
						{
							if(GetPVarInt(playerid, "took_sdpistol") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали пистолет с глушителем");

							GivePlayerWeapon(playerid, 23, 60);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли пистолет с глушителем");

							SetPVarInt(playerid, "took_sdpistol", gettime() + 300);
						}
						case 5:
						{
							if(GetPVarInt(playerid, "took_deagle") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали Desert Eagle");

							GivePlayerWeapon(playerid, 24, 120);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли Desert Eagle");

							SetPVarInt(playerid, "took_deagle", gettime() + 300);
						}
						case 6:
						{
							if(GetPVarInt(playerid, "took_mp5") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали MP5");

							GivePlayerWeapon(playerid, 29, 180);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли MP5");

							SetPVarInt(playerid, "took_mp5", gettime() + 300);
						}
						case 7:
						{
							if(GetPVarInt(playerid, "took_shotgun") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали дробовик");

							GivePlayerWeapon(playerid, 25, 30);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли дробовик");

							SetPVarInt(playerid, "took_shotgun", gettime() + 300);
						}
						case 8:
						{
							if(GetPVarInt(playerid, "took_ak47") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали АК47");

							GivePlayerWeapon(playerid, 30, 230);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли АК47");

							SetPVarInt(playerid, "took_ak47", gettime() + 300);
						}
						case 9:
						{
							if(GetPlayerJob(playerid) < 4)
								return SendClientMessage(playerid, 0x999999FF, "Винтовку можно брать только с 4 ранга");

							if(GetPVarInt(playerid, "took_rifle") > gettime())
								return SendClientMessage(playerid, 0x999999FF, "Вы уже недавно брали винтовку");

							GivePlayerWeapon(playerid, 34, 40);

							SendClientMessage(playerid, 0x3399FFFF, "Вы взяли винтовку");

							SetPVarInt(playerid, "took_rifle", gettime() + 300);
						}
					}
				}
			}
			// -----------------------------------------
			case DIALOG_BIZ_ORDERS:
			{
				if(response)
				{
					if(!IsPlayerInJob(playerid))
						return SendClientMessage(playerid, 0xCECECEFF, "Вы должны начать работу в службе доставки");

					if(GetPlayerData(playerid, P_ORDER) != -1)
						return SendClientMessage(playerid, 0xCECECEFF, "Выполните текущий заказ перед тем как взять новый");

					new order_id = GetPlayerListitemValue(playerid, listitem);

					if(!GetOrderData(order_id, O_AMOUNT))
						return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Выбранный заказ не найден");

					if(GetOrderData(order_id, O_USED))
						return SendClientMessage(playerid, -1, "Этот заказ уже принял другой дальнобойщик");

					SetOrderData(order_id, O_USED, true);
					SetPlayerData(playerid, P_ORDER, order_id);

					SendClientMessage(playerid, 0x3399FFFF, "Вы начали выполнение заказа. Закупите необходимое количество продуктов на заводе {66CC00}(/gps)");
					SendClientMessage(playerid, 0x3399FFFF, "После этого отправляйтесь к бизнесу, который отмечен {FF3300}красной точкой");

					new biz_id = GetOrderData(order_id, O_COMPANY_ID);

					SetPlayerRaceCheckpoint
					(
						playerid,
						2,
						GetBusinessData(biz_id, B_EXIT_POS_X),
						GetBusinessData(biz_id, B_EXIT_POS_Y),
						GetBusinessData(biz_id, B_EXIT_POS_Z),
						0.0,
						0.0,
						0.0,
						4.0,
						RCP_ACTION_TYPE_ORDER
					);
				}
			}
			case DIALOG_FS_ORDERS:
			{
				if(response)
				{
					if(!IsPlayerInJob(playerid))
						return SendClientMessage(playerid, 0xCECECEFF, "Вы должны начать работу в службе доставки");

					if(GetPlayerData(playerid, P_ORDER) != -1)
						return SendClientMessage(playerid, 0xCECECEFF, "Выполните текущий заказ перед тем как взять новый");

					new order_id = GetPlayerListitemValue(playerid, listitem);

					if(!GetOrderData(order_id, O_AMOUNT))
						return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Выбранный заказ не найден");

					if(GetOrderData(order_id, O_USED))
						return SendClientMessage(playerid, -1, "Этот заказ уже принял другой дальнобойщик");

					SetOrderData(order_id, O_USED, true);
					SetPlayerData(playerid, P_ORDER, order_id);

					SendClientMessage(playerid, 0x3399FFFF, "Вы начали выполнение заказа. Закупите необходимое количество топлива на нефтезаводе {66CC00}(/gps)");
					SendClientMessage(playerid, 0x3399FFFF, "После этого отправляйтесь к АЗС, которая отмечена {FF3300}красной точкой");

					new fs_id = GetOrderData(order_id, O_COMPANY_ID);

					SetPlayerRaceCheckpoint
					(
						playerid,
						2,
						GetFuelStationData(fs_id, FS_POS_X),
						GetFuelStationData(fs_id, FS_POS_Y),
						GetFuelStationData(fs_id, FS_POS_Z),
						0.0,
						0.0,
						0.0,
						4.0,
						RCP_ACTION_TYPE_ORDER
					);
				}
			}
			// -----------------------------------------
			case DIALOG_PROMO_CREATE:
			{
				if(response)
				{
					new code[32], type, amount, usings, paydays;

					if(sscanf(inputtext, "P<,>s[32]dddd", code, type, amount, usings, paydays))
					{
						SendClientMessage(playerid, 0x999999FF, "Некорректный ввод");
						callcmd::createpromo(playerid, "");

						return 1;
					}
					else
					{
						if(!(0 <= type <= 3))
						{
							SendClientMessage(playerid, 0x999999FF, "Тип должен быть от 0 до 3 (деньги, донат-монеты, донат-рубли, exp)");
							callcmd::createpromo(playerid, "");

							return 1;
						}

						if(!(1 <= amount <= 1_000_000))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество должно быть от 1 до 1.000.000");
							callcmd::createpromo(playerid, "");

							return 1;
						}

						if(!(1 <= usings <= 1_000))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество использований должно быть от 1 до 1000");
							callcmd::createpromo(playerid, "");

							return 1;
						}

						if(!(0 <= paydays <= 20))
						{
							SendClientMessage(playerid, 0x999999FF, "Количество PayDay должно быть от 0 до 20");
							callcmd::createpromo(playerid, "");

							return 1;
						}

						new query[128],
							Cache: result,
							rows;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode WHERE code='%s'", code);
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows(result);

						cache_delete(result);

						if(rows)
						{
							SendClientMessage(playerid, 0x999999FF, "Такой промокод уже есть в базе данных");
							callcmd::createpromo(playerid, "");

							return 1;
						}

						mysql_format(mysql, query, sizeof query, "INSERT INTO promocode (code, type, amount, usings, paydays) VALUES ('%s', %d, %d, %d, %d)",
						code, type, amount, usings, paydays);

						mysql_query(mysql, query);

						format(query, sizeof query, "Промокод \"%s\" создан (Т: %s, К: %d, И: %d, PD: %d)", code, promo_info[type][P_NAME], amount, usings, paydays);
						SendClientMessage(playerid, 0x66CC33FF, query);
					}
				}
			}
			// -----------------------------------------
			case DIALOG_MP_CREATE:
			{
				if(response)
				{
					new name[32], prize, query[144];

					if(sscanf(inputtext, "P<,>s[32]d", name, prize))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::mp(playerid, "");

						return 1;
					}
					else
					{
						if(!(1000000 <= prize <= 10000000))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Приз должен быть от 1000000 до 10000000 (деньги)");
							callcmd::mp(playerid, "");

							return 1;
						}

						mp[MP_CREATE] = 1;
						format(mp[MP_NAME], 32, name);
						mp[MP_PRIZE] = prize;

						
					}
				}
			}
			case DIALOG_MP_MENU:
			{
				if(response)
				{
					new query[144];

				    switch(listitem)
				    {
						case 3:
						{
							if(!mp[MP_POS_X])
							{
								GetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);

							    format(query, sizeof query, "[A | %d] %s [%d] установил телепорт на мероприятие {FFFFFF}\"%s\" (/gotomp)", GetPlayerAdminEx(playerid), GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
								SendClientMessageToAll(0xff8c00FF, query);
							}
					else
							{
								mp[MP_POS_X] = 0.0;
								mp[MP_POS_Y] = 0.0;
								mp[MP_POS_Z] = 0.0;

							    format(query, sizeof query, "[A | %d] %s [%d] закрыл телепорт на мероприятие {FFFFFF}\"%s\"", GetPlayerAdminEx(playerid), GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
								SendClientMessageToAll(0xff8c00FF, query);
							}
						}
						case 2:
						{
						    Dialog
							(
								playerid, DIALOG_MP_SKIN, DIALOG_STYLE_INPUT,
								"Скины игроков МП",
								"{FFFFFF}Для смени скина введите\n"\
								"следующий параметр в окно ниже:\n\n"\
								"{33CC66}Параметры: ID скина\n\n"\
								"{888888}Примечание:\n"\
								"{FFFFFF}- ID скина от 1 до 299",
								"Далее", "Отмена"
							);
						}
						case 4:
						{
							mp[MP_CREATE] = 0;

							format(query, sizeof query, "[A | %d] %s [%d] завершил мероприятие {FFFFFF}\"%s\"", GetPlayerAdminEx(playerid), GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
							SendClientMessageToAll(0xff8c00FF, query);
						}
				    }
				}
			}
			case DIALOG_MP_SKIN:
			{
			    if(response)
			    {
					new skin_id;

					if(sscanf(inputtext, "d", skin_id))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::mp(playerid, "");

						return 1;
					}
					else
					{
				        if(!(-1 <= skin_id <= 299) || skin_id == 0) return SendClientMessage(playerid, 0xCECECEFF, "ID скина от 1 до 299");

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							else if(!IsPlayerLogged(i)) continue;
							else if(!GetPlayerData(i, P_LAST_MP)) continue;

							if(skin_id != -1)
								SetPlayerSkin(i, skin_id);
							else
								SetPlayerSkin(i, GetPlayerSkinEx(i));
						}
					}
			    }
			}
			case DIALOG_EVENT_CREATE:
			{
				if(response)
				{
					new name[32], prize, query[144];
				    utf8_to_cp1251(inputtext);

					if(sscanf(inputtext, "P<,>s[32]d", name, prize))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
						if(!(10000 <= prize <= 50000))
						{
							SendClientMessage(playerid, 0xCECECEFF, "Приз должен быть от 10000 до 50000 (деньги)");
							callcmd::event(playerid, "");

							return 1;
						}

						mp[MP_CREATE] = 1;
						format(mp[MP_NAME], 32, name);
						mp[MP_PRIZE] = prize;

						format(query, sizeof query, "[A | %d] %s [%d] создал мероприятие {FFFFFF}\"%s\"{ff8c00} с призом {FFFFFF}$%d", GetPlayerAdminEx(playerid), GetPlayerNameEx(playerid), playerid, mp[MP_NAME], mp[MP_PRIZE]);
						SendClientMessageToAll(0xff8c00FF, query);
					}
				}
			}
			case DIALOG_EVENT_MENU:
			{
				if(response)
				{
					new query[999];

				    switch(listitem)
				    {
						case 3:
						{
							if(!mp[MP_POS_X])
							{
								GetPlayerPos(playerid, mp[MP_POS_X], mp[MP_POS_Y], mp[MP_POS_Z]);

							    format(query, sizeof query, "Уважаемые игроки, сейчас пройдёт мероприятие под названием {d58300}\"%s\".", mp[MP_NAME]);
							    SendClientMessageToAll(0xFFCC33FF, query);
							    format(query, sizeof query, "{FFCC33}Доступное количество участников: {d58300}неограничено{FFCC33}, будьте аккуратнее, оружие может быть отобрано.");
							    SendClientMessageToAll(0xFFCC33FF, query);
							    format(query, sizeof query, "Ровно через несколько минут доступ к телепортации на место проведения мероприятия будет автоматически закрыт.");
					    		SendClientMessageToAll(0xFFCC33FF, query);
							    format(query, sizeof query, "Для того, чтобы поучаствовать в мероприятии - воспользуйтесь командой: {d58300}/gevent");
							    SendClientMessageToAll(0xFFCC33FF, query);
							}
					else
							{
								mp[MP_POS_X] = 0.0;
								mp[MP_POS_Y] = 0.0;
								mp[MP_POS_Z] = 0.0;

							    format(query, sizeof query, "{FFCC33}Администратор {d58300}%s[%d] {FFCC33}закрыл телепорт на мероприятие под названием {d58300}\"%s\".", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
								SendClientMessageToAll(0xFFCC33FF, query);
							}
						}
						case 5:
						{
						    Dialog
							(
								playerid, DIALOG_MP_SKIN, DIALOG_STYLE_INPUT,
								"{FF0000}Скины игроков МП",
								"{FFFFFF}Для смени скина введите\n"\
								"следующий параметр в окно ниже:\n\n"\
								"{FFFFFF}Параметры: {ffff00}ID скина\n\n"\
								"{FFFFFF}Примечание:\n"\
								""SC"ID скина от {ffff00}1 {FFFFFF}до {ffff00}299",
								"Далее", "Отмена"
							);
						}
					  case 6:
					  {
					new fmt_str[999];
					new Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) //Или через foreach
{
    if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
    {
        SetPlayerHealth(i, 100);
        format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}установил всем максимальное значение здоровья.", GetPlayerNameEx(playerid));
        SendClientMessage(i, 0x3399FFFF, fmt_str);        
    }
}	
			}
					  case 7:
					  {
					new fmt_str[999];
					new Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) //Или через foreach
{
    if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
    {
        SetPlayerArmour(i, 100);
        format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}установил всем максимальное значение брони.", GetPlayerNameEx(playerid));
        SendClientMessage(i, 0x3399FFFF, fmt_str);        
    }
}	
			}			
					case 8:
					{
					new fmt_str[999];
					new  Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) //Или через foreach
{
    if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
    {
        GivePlayerWeapon(i, 24, 500);
        format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}выдал всем оружие {d58300}\"Desert Eagle\" + 500 патрон {FFCC33}к нему.", GetPlayerNameEx(playerid));
        SendClientMessage(i, 0x3399FFFF, fmt_str);        
    }
}
					}
					case 9:
					{
					new fmt_str[999];
					new  Float:x, Float:y, Float:z;
GetPlayerPos(playerid, x, y, z);
for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) //Или через foreach
{
    if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
    {
        GivePlayerWeapon(i, 25, 500);
        format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}выдал всем оружие {d58300}\"Shotgun\" + 500 патрон {FFCC33}к нему.", GetPlayerNameEx(playerid));
        SendClientMessage(i, 0x3399FFFF, fmt_str);        
    }
}
					}
					
					case 10:
{
    new fmt_str[999];
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) // Или через foreach
    {
        if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
        {
            GivePlayerWeapon(i, 29, 500); // MP5
            format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}выдал всем оружие {d58300}\"MP5\" + 500 патрон {FFCC33}к нему.", GetPlayerNameEx(playerid));
            SendClientMessage(i, 0x3399FFFF, fmt_str);
        }
    }
}

case 11:
{
    new fmt_str[999];
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if (i == playerid) continue; // <--- Не трогать самого себя

        if (IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
        {
            SetPVarInt(i, "Freeze", 1); // сохраняем вар на каждого игрока
            TogglePlayerControllable(i, 0); // замораживаем конкретного игрока

            format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}заморозил всех участников мероприятия!", GetPlayerNameEx(playerid));
            SendClientMessage(i, 0x3399FFFF, fmt_str);
        }
    }
    return 1;
}


case 12:
{
    new fmt_str[999];
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) // или foreach
    {
        if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
        {
            if (GetPVarInt(i, "Freeze") == 1) // размораживаем только замороженных
            {
                DeletePVar(i, "Freeze");
                TogglePlayerControllable(i, 1);
                format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}разморозил всех участников мероприятия!", GetPlayerNameEx(playerid));
                SendClientMessage(i, 0x3399FFFF, fmt_str);
            }
        }
    }
}


			case 13:
{
    new fmt_str[999];
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++) // Или через foreach
    {
        if (IsPlayerInRangeOfPoint(i, 100.0, x, y, z))
        {
            ResetPlayerWeapons(i); // Удаляет всё оружие у игрока
            format(fmt_str, sizeof fmt_str, "{FFCC33}Администратор {d58300}%s {FFCC33}обезоружил всех участников мероприятия!", GetPlayerNameEx(playerid));
            SendClientMessage(i, 0x3399FFFF, fmt_str);
        }
    }
}

						case 4:
						{
							mp[MP_CREATE] = 0;

							format(query, sizeof query, "{FFCC33}Администратор {d58300}%s[%d] {FFCC33}закончил мероприятие под названием {d58300}\"%s\".", GetPlayerNameEx(playerid), playerid, mp[MP_NAME]);
							SendClientMessageToAll(0xFFCC33FF, query);
							format(query, sizeof query, "{FFCC33}Игрок {d58300}%s[%d] {FFCC33}получил вознаграждение в размере {d58300}50.000 {FFCC33}игровых рублей.", GetPlayerNameEx(playerid), playerid);
							SendClientMessageToAll(0xFFCC33FF, query);
						}
				    }
				}
			}
			case DIALOG_HOUSE_NEW_CLASS:
			{
				if(!response)
				{
					DeletePVar(playerid, "hnew_create_price");
					DeletePVar(playerid, "hnew_create_x");
					DeletePVar(playerid, "hnew_create_y");
					DeletePVar(playerid, "hnew_create_z");
					DeletePVar(playerid, "hnew_create_a");
					return 1;
				}

				if(!(0 <= listitem < sizeof g_house_type))
					return SendClientMessage(playerid, -1, "Некорректный класс дома");

				new price = GetPVarInt(playerid, "hnew_create_price");
				if(price < 1)
					return SendClientMessage(playerid, -1, "Ошибка цены. Повторите /addhouse");

				new houseid = GetFreeHouseNewSlot();
				if(houseid == -1)
					return SendClientMessage(playerid, -1, "Достигнут лимит MAX_HOUSES_NEW");

				ResetHouseNewData(houseid);

				g_house_new[houseid][HN_X] = GetPVarFloat(playerid, "hnew_create_x");
				g_house_new[houseid][HN_Y] = GetPVarFloat(playerid, "hnew_create_y");
				g_house_new[houseid][HN_Z] = GetPVarFloat(playerid, "hnew_create_z");
				g_house_new[houseid][HN_ANGLE] = GetPVarFloat(playerid, "hnew_create_a");
				g_house_new[houseid][HN_PRICE] = price;
				g_house_new[houseid][HN_TYPE] = listitem;
				g_house_new[houseid][HN_CREATED] = true;

				g_house_new[houseid][HN_INT_X] = GetHouseTypeInfo(listitem, HT_ENTER_POS_X);
				g_house_new[houseid][HN_INT_Y] = GetHouseTypeInfo(listitem, HT_ENTER_POS_Y);
				g_house_new[houseid][HN_INT_Z] = GetHouseTypeInfo(listitem, HT_ENTER_POS_Z);
				g_house_new[houseid][HN_INT_A] = GetHouseTypeInfo(listitem, HT_ENTER_POS_ANGLE);
				g_house_new[houseid][HN_INT_INTERIOR] = GetHouseTypeInfo(listitem, HT_INTERIOR);

				new query[512], Cache: result;
				mysql_format(mysql, query, sizeof query,
					"INSERT INTO housesnew (accounts_id, owner_name, type, price, x, y, z, angle, int_x, int_y, int_z, int_a, int_interior) VALUES (0, '', %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %d)",
					g_house_new[houseid][HN_TYPE],
					g_house_new[houseid][HN_PRICE],
					g_house_new[houseid][HN_X],
					g_house_new[houseid][HN_Y],
					g_house_new[houseid][HN_Z],
					g_house_new[houseid][HN_ANGLE],
					g_house_new[houseid][HN_INT_X],
					g_house_new[houseid][HN_INT_Y],
					g_house_new[houseid][HN_INT_Z],
					g_house_new[houseid][HN_INT_A],
					g_house_new[houseid][HN_INT_INTERIOR]
				);
				result = mysql_query(mysql, query, true);
				g_house_new[houseid][HN_SQL_ID] = cache_insert_id();
				cache_delete(result);

				format(g_house_new[houseid][HN_OWNER_NAME], 21, "None");
				UpdateHouseNewVisual(houseid);
				if(g_house_new_loaded < houseid + 1) g_house_new_loaded = houseid + 1;

				DeletePVar(playerid, "hnew_create_price");
				DeletePVar(playerid, "hnew_create_x");
				DeletePVar(playerid, "hnew_create_y");
				DeletePVar(playerid, "hnew_create_z");
				DeletePVar(playerid, "hnew_create_a");

				new fmt[144];
				format(fmt, sizeof fmt, "[A] %s[%d] создал дом новой системы #%d (класс: %s, цена: %d руб)", GetPlayerNameEx(playerid), playerid, houseid, GetHouseTypeInfo(listitem, HT_NAME), price);
				SendMessageToAdmins(fmt, 0x66CC33FF);
				SendClientMessage(playerid, -1, "Дом создан. Вход и покупка через пикап активны");
				return 1;
			}
			case DIALOG_HOUSE_FLATS_BUY:
			{
				new flatid = GetPVarInt(playerid, "hnew_pickup_id");
				DeletePVar(playerid, "hnew_pickup_id");
				new houseid = flatid / 1000;
    new floor   = (flatid % 1000) / 10;
    new flatidx = (flatid % 10) + (4*(floor-1));
	new flatids = (houseid * 100) + (floor * 10) + flatidx;
				if(!response) return 1;
				
				if(gFlatOwned[flatids])
					return SendClientMessage(playerid, -1, "Квартира уже куплена");

				return BuyFlat(playerid, flatid);
			}
			case DIALOG_HOUSE_NEW_PICKUP:
			{
				new houseid = GetPVarInt(playerid, "hnew_pickup_id");
				DeletePVar(playerid, "hnew_pickup_id");

				if(!response) return 1;
				return ProcessPlayerHouseNewPickupEnter(playerid, houseid);
			}
			case DIALOG_HOUSE_NEW_FLATS:
			{
				new houseid = GetPVarInt(playerid, "hnew_pickup_id");
				DeletePVar(playerid, "hnew_pickup_id");

				if(!response) return 1;
				return ProcessPlayerFlatNewPickupEnter(playerid, houseid);
			}
			case DIALOG_FLAT_CHOOSE_FLOOR:
            {
                DeletePVar(playerid, "lift_dialog_active");
				gPlayerPickupCooldowns[playerid] = GetTickCount() + 1500;
                if (!response)
                {
                    DeletePVar(playerid, "hnew_pickup_id");
                    DeletePVar(playerid, "hnew_current_floor");
                    return 1;
                }
            
                new houseid = GetPVarInt(playerid, "hnew_pickup_id");
            
                DeletePVar(playerid, "hnew_pickup_id");
            
                if (houseid < 0 || houseid >= FLATS_FOR_SALE_COUNT)
                {
                    DeletePVar(playerid, "hnew_current_floor");
                    return 1;
                }
            
                if (gFlatEnTypes[houseid] == 0)
                {
                    new result = ProcessPlayerFlatMoveFloor(playerid, houseid, listitem);
                    DeletePVar(playerid, "hnew_current_floor");
                    return result;
                }
				if (gFlatEnTypes[houseid] == 1)
                {
                    new result = ProcessPlayerFlatMoveFloors(playerid, houseid, listitem);
                    DeletePVar(playerid, "hnew_current_floor");
                    return result;
                }
            
                DeletePVar(playerid, "hnew_current_floor");
                return 1;
            }
			case DIALOG_HOUSE_NEW_PICKUPS:
			{
				new houseid = GetPVarInt(playerid, "hnew_pickup_id");
				DeletePVar(playerid, "hnew_pickup_id");

				if(!response) return 1;
				return ProcessPlayerHouseNewPickupExit(playerid, houseid, listitem);
			}
			case DIALOG_HOUSE_NEW_PICKUPSS:
			{
				new houseid = GetPVarInt(playerid, "hnew_pickup_id");
				DeletePVar(playerid, "hnew_pickup_id");

				if(!response) return 1;
				return ProcessPlayerBasementNewPickupExit(playerid, houseid, listitem);
			}
			case DIALOG_HOUSE_NEW_INFO:
			{
				if(!response) return 1;

				new houseid = GetPVarInt(playerid, "hnew_home_id"), fmt_str[160];

				format(fmt_str, sizeof fmt_str,
					"1. %s\n{FFFFFF}2. Улучшить дом\n3. Отметить дом на GPS\n4. Установить ваш дом местом спавна семьи\n5. Удалить семейный спавн\n6. Список арендаторов\n7. Сменить дом/квартиру",
					"{66CC66}Открыть {FFFFFF}или {ed614c}закрыть {ffffff}дом"
				);

				Dialog(playerid, DIALOG_HOUSE_NEW_MENU, DIALOG_STYLE_LIST,
					"{3A94AE}Изменение параметров дома", fmt_str, "Выбрать", "Назад");
				return 1;
			}
			case DIALOG_FLAT_NEW_INFO:
			{
				if(!response) return 1;

				new houseid = GetPVarInt(playerid, "hnew_home_id"), fmt_str[1023];

				format(fmt_str, sizeof fmt_str,
					"1. %s\n{FFFFFF}2. Улучшить квартиру\n3. Отметить квартиру на GPS\n4. Установить Вашу квартиру местом спавна для семьи\n5. Удалить семейный спавн\n6. Список арендаторов\n7. Сменить квартиру",
					"{66CC66}Открыть {FFFFFF}или {ed614c}закрыть {ffffff}квартиру"
				);

				Dialog(playerid, DIALOG_FLAT_NEW_MENU, DIALOG_STYLE_LIST,
					"{3A94AE}Изменение параметров квартиры", fmt_str, "Выбрать", "Назад");
				return 1;
			}
			case DIALOG_HOUSE_NEW_MENU:
			{
				new houseid = GetPVarInt(playerid, "hnew_home_id");
				
				if(!response)
					return ShowPlayerHouseNewInfo(playerid, houseid);

				switch(listitem)
				{
					case 0:
					{
						g_house_new_opens[houseid] = !g_house_new_opens[houseid];
						new query[128];
                        format(query, sizeof(query),
                            "UPDATE bought_houses SET is_open = %d WHERE house_id = %d",
                            g_house_new_opens[houseid] , houseid
                        );
                        mysql_tquery(mysql, query);
						SendClientMessage(playerid, -1, g_house_new_opens[houseid] ? ("Дом открыт") : ("Дом закрыт"));
						return ShowPlayerHouseNewInfo(playerid, houseid);
					}
					case 1:
					{
						return ShowPropertyImprovementTypeDialog(playerid, false);
					}
					case 2:
					{
						EnablePlayerGPS(playerid, 35,
							gHousesForSale[houseid][0],
							gHousesForSale[houseid][1],
							gHousesForSale[houseid][2],
							"Дом отмечен у Вас на GPS");
						return ShowPlayerHouseNewInfo(playerid, houseid);
					}
					case 3:
					{
						new fam_id = GetPlayerIdFamily(playerid);
						new family_house_value = FamilySpawnEncodeNewHouse(houseid);

						if(fam_id == -1)
							return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в семье");

						if(GetFamily(fam_id, family_house) == family_house_value)
						{
							SendClientMessage(playerid, -1, ""c_f_g"Этот дом уже установлен местом спавна семьи.");
							return ShowPlayerHouseNewInfo(playerid, houseid);
						}

						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=%d WHERE id=%d", family_house_value, GetFamily(fam_id, family_database));
						mysql_query(mysql, f_string144, false);
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);

						SetFamily(fam_id, family_house, family_house_value);
						new caption[1024];
						format(caption, sizeof(caption), "Вы успешно установили семейный спавн для дома");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
						return ShowPlayerHouseNewInfo(playerid, houseid);
					}
					case 4:
					{
						new fam_id = GetPlayerIdFamily(playerid);
						new family_house_value = FamilySpawnEncodeNewHouse(houseid);

						if(fam_id == -1)
							return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в семье");

						if(GetFamily(fam_id, family_house) != family_house_value)
						{
							SendClientMessage(playerid, -1, ""c_f_r"У вашей семьи не установлен спавн в этом доме.");
							return ShowPlayerHouseNewInfo(playerid, houseid);
						}

						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=-1 WHERE id=%d", GetFamily(fam_id, family_database));
						mysql_query(mysql, f_string144, false);
						new caption[1024];
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);
						format(caption, sizeof(caption), "Вы успешно удалили семейный спавн для дома");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
						SetFamily(fam_id, family_house, -1);
						
						return ShowPlayerHouseNewInfo(playerid, houseid);
					}
					case 5:
					{
						return ShowPropertyRentersDialog(playerid, false, houseid);
					}
					case 6:
					{
						return ShowPlayerPropertySelectDialog(playerid);
					}
				}
				return 1;
			}
			case DIALOG_FLAT_NEW_MENU:{
				new flatids = GetPVarInt(playerid, "hnew_home_id");
				new flatid = g_flat_real_id[flatids];
				new houseid = flatid / 1000;
                new floor   = (flatid % 1000) / 10;
                new flatidx = (flatid % 10) + (4*(floor-1));
				if(!response)
					return ShowPlayerFlatNewInfo(playerid, flatid);

				switch(listitem)
				{
					case 0:
					{
						g_flat_new_opens[flatids] = !g_flat_new_opens[flatids];
						new query[128];
                        format(query, sizeof(query),
                            "UPDATE bought_houses SET is_open = %d WHERE house_id = %d",
                            g_flat_new_opens[flatids] , flatid
                        );
                        mysql_tquery(mysql, query);
						SendClientMessage(playerid, -1, g_flat_new_opens[flatids] ? ("Квартира открыта") : ("Квартира закрыта"));
						return ShowPlayerFlatNewInfo(playerid, flatid);
					}
					case 1:
					{
						return ShowPropertyImprovementTypeDialog(playerid, true);
					}
					case 2:
					{
						EnablePlayerGPS(playerid, 35,
							gFlatsForSale[houseid][0],
							gFlatsForSale[houseid][1],
							gFlatsForSale[houseid][2],
							"Квартира отмечена у Вас на GPS");
						return ShowPlayerFlatNewInfo(playerid, flatid);
					}
					case 3:
					{
						new fam_id = GetPlayerIdFamily(playerid);
						new family_house_value = FamilySpawnEncodeNewFlat(flatids);

						if(fam_id == -1)
							return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в семье");

						if(GetFamily(fam_id, family_house) == family_house_value)
						{
							SendClientMessage(playerid, -1, ""c_f_g"Эта квартира уже установлена местом спавна семьи.");
							return ShowPlayerFlatNewInfo(playerid, flatid);
						}

						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=%d WHERE id=%d", family_house_value, GetFamily(fam_id, family_database));
						mysql_query(mysql, f_string144, false);
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);
						new caption[1024];
						SetFamily(fam_id, family_house, family_house_value);
						format(caption, sizeof(caption), "Вы успешно установили семейный спавн для квартиры");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
						return ShowPlayerFlatNewInfo(playerid, flatid);
					}
					case 4:
					{
						new fam_id = GetPlayerIdFamily(playerid);
						new family_house_value = FamilySpawnEncodeNewFlat(flatids);

						if(fam_id == -1)
							return SendClientMessage(playerid, 0x999999FF, "Вы не состоите в семье");

						if(GetFamily(fam_id, family_house) != family_house_value)
						{
							SendClientMessage(playerid, -1, ""c_f_r"У вашей семьи не установлен спавн в этой квартире.");
							return ShowPlayerFlatNewInfo(playerid, flatid);
						}

						mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE familynew SET house=-1 WHERE id=%d", GetFamily(fam_id, family_database));
						mysql_query(mysql, f_string144, false);
						if(mysql_errno()) return printf("ERROR SQL (%s)", f_string144);
new caption[1024];
						SetFamily(fam_id, family_house, -1);
						
                        format(caption, sizeof(caption), "Вы успешно удалили семейный спавн для квартиры");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
						return ShowPlayerFlatNewInfo(playerid, flatid);
					}
					case 5:
					{
						return ShowPropertyRentersDialog(playerid, true, flatid);
					}
					case 6:
					{
						return ShowPlayerPropertySelectDialog(playerid);
					}
				}
				
				return 1;
			}
			case DIALOG_PROPERTY_IMPROVEMENT_TYPE:
			{
				new bool:is_flat = bool:GetPVarInt(playerid, "hnew_menu_is_flat");
				new property_id = GetPVarInt(playerid, "hnew_home_id");

				if(!response)
				{
					if(is_flat)
					{
						new real_flatid = g_flat_real_id[property_id];
						return ShowPlayerFlatNewInfo(playerid, real_flatid);
					}
					return ShowPlayerHouseNewInfo(playerid, property_id);
				}

				switch(listitem)
				{
					case 0: return ShowPropertyImprovementsDialog(playerid, is_flat, property_id);
					case 1: return ShowPropertyBasementImprovementsDialog(playerid, is_flat, property_id);
				}
				return 1;
			}
			case DIALOG_SELECT_PLAYER_PROPERTY:
            {
                if(!response)
                {
                    if(GetPVarInt(playerid, "BANK_PROPERTY_PAY_SELECT"))
                    {
                        DeletePVar(playerid, "BANK_PROPERTY_PAY_SELECT");
                        ShowPlayerPayForRentDialog(playerid);
                    }
                    return 1;
                }
                if(!(0 <= listitem < gPlayerPropertyCount[playerid])) return 1;

                new bool:is_flat = bool:gPlayerPropertyType[playerid][listitem];
                new property_id = gPlayerPropertyID[playerid][listitem];
                SetPlayerData(playerid, P_HOUSE_SELECTED, EncodeSelectedHouseProperty(is_flat, property_id));
                UpdatePlayerDatabaseInt(playerid, "house_selected", GetPlayerData(playerid, P_HOUSE_SELECTED));

                if(GetPVarInt(playerid, "BANK_PROPERTY_PAY_SELECT"))
                {
                    DeletePVar(playerid, "BANK_PROPERTY_PAY_SELECT");
                    return ShowPlayerHousePayForRent(playerid);
                }

                // Open the selected property directly. Calling /home here would
                // reopen this selector forever when the account owns 2+ objects.
                SetPVarInt(playerid, "hnew_home_id", property_id);
                if(is_flat)
                    return ShowPlayerFlatNewInfo(playerid, g_flat_real_id[property_id]);
                return ShowPlayerHouseNewInfo(playerid, property_id);
            }
			case DIALOG_FLAT_NEW_INFOS:
			{
				new flatids = GetPVarInt(playerid, "hnew_home_id");
				if(!response) return ShowPlayerFlatNewInfo(playerid, g_flat_real_id[flatids]);
				return BuyNewPropertyImprovement(playerid, true, flatids, listitem);
			}
			case DIALOG_HOUSE_NEW_INFOS:
			{
				new houseid = GetPVarInt(playerid, "hnew_home_id");
				if(!response) return ShowPlayerHouseNewInfo(playerid, houseid);
				return BuyNewPropertyImprovement(playerid, false, houseid, listitem);
			}
			case DIALOG_HOUSE_NEW_SELL:
			{
				if(!response) return 1;
				new houseid = GetPVarInt(playerid, "hnew_home_id");
				DeletePVar(playerid, "hnew_home_id");
				return SellPlayerHouseNew(playerid, houseid);
			}
			case DIALOG_FLAT_NEW_SELL:{
				if(!response) return 1;
				new houseid = GetPVarInt(playerid, "hnew_home_id");
				DeletePVar(playerid, "hnew_home_id");
				return SellPlayerFlatNew(playerid, g_flat_real_id[houseid]);
			}
			case DIALOG_EVENT_SKIN:
			{
			    if(response)
			    {
					new skin_id;

					if(sscanf(inputtext, "d", skin_id))
					{
						SendClientMessage(playerid, 0xCECECEFF, "Некорректный ввод");
						callcmd::event(playerid, "");

						return 1;
					}
					else
					{
				        if(!(-1 <= skin_id <= 299) || skin_id == 0) return SendClientMessage(playerid, 0xCECECEFF, "ID скина от 1 до 299");

						for(new i; i < MAX_PLAYERS; i ++)
						{
							if(!IsPlayerConnected(i)) continue;
							else if(!IsPlayerLogged(i)) continue;
							else if(!GetPlayerData(i, P_LAST_MP)) continue;

							if(skin_id != -1)
								SetPlayerSkin(i, skin_id);
							else
								SetPlayerSkin(i, GetPlayerSkinEx(i));
						}
					}
			    }
			}
		}
	}
	return 1;
}

