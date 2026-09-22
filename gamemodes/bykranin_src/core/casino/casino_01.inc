//>> Файл: bykranin_src/core/casino/casino_01.inc  (794 строк)
//>> Тема: казино (рулетка, блэкджек и т.п.)
//>> Внутри: CreateMenus, CreateMedBeds, CreateCasinoTables, CreateBlackJackTables, CreateArmories, IsPlayerInRangeOfAnyBlackJackTable, GetNearestBlackJackTable
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateMenus()
{
	admin_spec_menu = CreateMenu("_", 1, 550.0, 130.0, 50.0);
    AddMenuItem(admin_spec_menu, 0, "-EXIT-");
    AddMenuItem(admin_spec_menu, 0, "Update");
    AddMenuItem(admin_spec_menu, 0, "Stats");
    AddMenuItem(admin_spec_menu, 0, "Skick");
    AddMenuItem(admin_spec_menu, 0, "Mute");
    AddMenuItem(admin_spec_menu, 0, "Slap");
    AddMenuItem(admin_spec_menu, 0, "GMTest");
    AddMenuItem(admin_spec_menu, 0, "Info");
    AddMenuItem(admin_spec_menu, 0, "-EXIT-");

	print("[Menu]: Все меню созданы");
}


stock CreateMedBeds()
{
	for(new i; i < sizeof g_med_bed_pos; i ++)
	{
		g_med_bed_label[i] = CreateDynamic3DTextLabel(" ", 0xFFFFFFEE, g_med_bed_pos[i][0], g_med_bed_pos[i][1], g_med_bed_pos[i][2], 5.0, _, _, _, -1, -1, _, 30.0);
		UpdateMedBed(i);
	}
}

stock CreateCasinoTables()
{
    g_casino_croupier_pickup = CreatePickup(1275, 23, 2517.664550, 2489.715820, 2501.118164, -1);

    for(new idx; idx < sizeof g_casino_table_pos; idx ++)
    {
        g_casino_area[idx] = CreateDynamicSphere
        (
            g_casino_table_pos[idx][0],
            g_casino_table_pos[idx][1],
            g_casino_table_pos[idx][2],
            2.0
        );

        g_casino_table_dealer[idx] = INVALID_PLAYER_ID;
        g_casino_table_bet[idx] = 1000;
        g_casino_table_bet_set[idx] = false;
        g_casino_round_active[idx] = false;
        g_casino_round_timer[idx] = 0;
        g_casino_round_left[idx] = 0;

        new fmt_text[96];
        format(fmt_text, sizeof fmt_text, "{FFFF00}Столик %d\n{FFFFFF}Подойдите для взаимодействия", idx + 1);

        CreateDynamic3DTextLabel
        (
            fmt_text,
            0xFFFFFFFF,
            g_casino_table_pos[idx][0], g_casino_table_pos[idx][1], g_casino_table_pos[idx][2],
            10.0
        );
    }
}

stock CreateBlackJackTables()
{
    for(new idx; idx < sizeof g_blackjack_table_pos; idx ++)
    {
        g_blackjack_area[idx] = CreateDynamicSphere
        (
            g_blackjack_table_pos[idx][0],
            g_blackjack_table_pos[idx][1],
            g_blackjack_table_pos[idx][2],
            2.0
        );

        new fmt_text[112];
        format(fmt_text, sizeof fmt_text, "{FFFF00}BlackJack Стол %d\n{FFFFFF}Подойдите для взаимодействия", idx + 1);

        CreateDynamic3DTextLabel
        (
            fmt_text,
            0xFFFFFFFF,
            g_blackjack_table_pos[idx][0], g_blackjack_table_pos[idx][1], g_blackjack_table_pos[idx][2],
            10.0
        );
    }
}

stock CreateArmories()
{
	for(new idx; idx < sizeof g_armory; idx ++)
	{
		CreatePickup
		(
			g_armory[idx][A_TYPE] == ARMORY_TYPE_ARMOR ? 1242 : 1239,
			23,
			g_armory[idx][A_POS_X], g_armory[idx][A_POS_Y], g_armory[idx][A_POS_Z],
			-1,
			PICKUP_ACTION_TYPE_ARMORY, g_armory[idx][A_TYPE]
		);

		new fmt_text[55];

		format(fmt_text, sizeof fmt_text, "- %s -\n{FFFFFF}%s",
		g_armory[idx][A_TYPE] == ARMORY_TYPE_ARMOR ? "Получение бронежилета" : "Оружейный склад",
		g_armory[idx][A_DESCRIPTION]);

		CreateDynamic3DTextLabel
		(
			fmt_text,
			0x3399FFFF,
			g_armory[idx][A_POS_X], g_armory[idx][A_POS_Y], g_armory[idx][A_POS_Z] + 1.5,
			8.0,
			_, _, _, -1, -1, _,
			15.0
		);
	}
}

stock IsPlayerInRangeOfAnyBlackJackTable(playerid)
{
    for(new idx; idx < MAX_BJ_LOBBY; idx ++)
    {
        if(IsPlayerInDynamicArea(playerid, BlackJackSphere[idx])) return 1;
    }

    return 0;
}

stock GetNearestBlackJackTable(playerid)
{
    for(new idx; idx < MAX_BJ_LOBBY; idx ++)
    {
        if(IsPlayerInDynamicArea(playerid, BlackJackSphere[idx])) return idx;
    }

    return -1;
}

stock IsPlayerInRangeOfAnyCasinoTable(playerid)
{
	for(new idx; idx < sizeof g_casino_table_pos; idx ++)
	{
		if(IsPlayerInDynamicArea(playerid, g_casino_area[idx])) return 1;
	}

	return 0;
}

stock SetCasinoEmployment(playerid, businessid, job)
{
    SetPlayerData(playerid, P_CASINO_JOB, job);
    SetPlayerData(playerid, P_CASINO_BUSINESS, job ? businessid : -1);
    pInfo[playerid][CasinoDealerJob] = false;
    pInfo[playerid][CasinoManagerJob] = false;
    SetPlayerSkin(playerid, GetPlayerSkinEx(playerid));

    new query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET casino_job=%d,casino_business=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_CASINO_JOB), GetPlayerData(playerid, P_CASINO_BUSINESS), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}

stock GetPlayerManagedCasino(playerid)
{
    if(GetPlayerData(playerid, P_CASINO_JOB) == 2)
    {
        new employee_business = GetPlayerData(playerid, P_CASINO_BUSINESS);
        if(0 <= employee_business < g_business_loaded && GetBusinessData(employee_business, B_TYPE) == BUSINESS_TYPE_CASINO) return employee_business;
    }
    new selected_business = GetSelectedBusiness(playerid);
    if(0 <= selected_business < g_business_loaded && GetBusinessData(selected_business, B_TYPE) == BUSINESS_TYPE_CASINO && GetBusinessData(selected_business, B_OWNER_ID) == GetPlayerAccountID(playerid)) return selected_business;
    for(new businessid; businessid < g_business_loaded; businessid++)
        if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CASINO && GetBusinessData(businessid, B_OWNER_ID) == GetPlayerAccountID(playerid)) return businessid;
    return -1;
}

stock ShowCasinoEmployeesDialog(playerid)
{
    new businessid = GetSelectedBusiness(playerid);
    if(!(0 <= businessid < g_business_loaded) || GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO || GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Управление сотрудниками доступно только владельцу казино.");
    return Dialog(playerid, DIALOG_CASINO_EMPLOYEES, DIALOG_STYLE_LIST, "Управление казино", "Поставить на менеджера\nПоставить на крупье\n{FF6666}Снять менеджера\n{FF6666}Снять крупье\n{33AACC}Список сотрудников\n{66CC33}Баланс бизнеса\n{33CC66}Снять прибыль", "Выбрать", "Назад");
}
stock ShowCasinoEmployeeList(playerid, businessid)
{
    new list[1024] = "Имя\tДолжность\n", count;
    foreach(new employee: Player)
    {
        if(GetPlayerData(employee, P_CASINO_BUSINESS) != businessid || !GetPlayerData(employee, P_CASINO_JOB)) continue;
        format(list, sizeof list, "%s%s [%d]\t%s\n", list, GetPlayerNameEx(employee), employee, GetPlayerData(employee, P_CASINO_JOB) == 2 ? ("Менеджер") : ("Крупье"));
        count++;
    }
    if(!count) strcat(list, "Нет сотрудников\t-");
    return Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS, "Сотрудники казино", list, "Закрыть", "");
}

stock ShowCasinoManagerDialog(playerid)
{
    new businessid = GetPlayerManagedCasino(playerid);
    if(businessid == -1) return SendClientMessage(playerid, 0xCECECEFF, "Вы не являетесь менеджером или владельцем казино.");
    return Dialog(playerid, DIALOG_CASINO_MANAGER_MENU, DIALOG_STYLE_LIST, "Управление сотрудниками казино", "Список сотрудников\nУволить крупье по нику\nПринять крупье по ID", "Выбрать", "Закрыть");
}
stock CasinoDice_RecordStakeProfit(playerid, stake)
{
    if(stake <= 0) return 0;
    new businessid = GetPlayerInBiz(playerid);
    if(!(0 <= businessid < g_business_loaded) || GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO || !IsBusinessOwned(businessid)) return 0;
    new profit = stake / 5;
    if(profit <= 0) return 0;
    if(GetBusinessData(businessid, B_BALANCE) > cellmax - profit) profit = cellmax - GetBusinessData(businessid, B_BALANCE);
    if(profit <= 0) return 0;
    AddBusinessData(businessid, B_BALANCE, +, profit);
    new query[224];
    mysql_format(mysql, query, sizeof query, "UPDATE business SET balance=%d WHERE id=%d LIMIT 1", GetBusinessData(businessid, B_BALANCE), GetBusinessData(businessid, B_SQL_ID));
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), profit, 1);
    mysql_query(mysql, query, false);
    return profit;
}
stock GetNearestCasinoTable(playerid)
{
    for(new idx; idx < sizeof g_casino_table_pos; idx ++)
    {
        if(IsPlayerInDynamicArea(playerid, g_casino_area[idx])) return idx;
    }

    return -1;
}

stock IsPlayerCasinoDealer(playerid, table_idx)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 0;
    if(g_casino_table_dealer[table_idx] != playerid) return 0;
    if(!(pInfo[playerid][CasinoDealerJob] || pInfo[playerid][CasinoManagerJob])) return 0;
    return 1;
}

stock GetCasinoTableJoinedPlayersCount(table_idx, except_playerid = INVALID_PLAYER_ID)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 0;

    new count;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(i == except_playerid) continue;
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(!pInfo[i][CasinoDiceUiOpen]) continue;
        if(pInfo[i][CasinoDiceTable] != table_idx + 1) continue;
        if(g_casino_table_dealer[table_idx] == i) continue;

        count++;
    }

    return count;
}

stock ResetCasinoTablePaidPlayers(table_idx)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 1;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!pInfo[i][CasinoDiceBetPaid]) continue;
        if(pInfo[i][CasinoDiceBetPaidTable] != table_idx + 1) continue;

        pInfo[i][CasinoDiceBetPaid] = false;
        pInfo[i][CasinoDiceBetPaidTable] = 0;
    }

    return 1;
}

stock GetCasinoTablePlayers(table_idx, players_out[], max_count)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 0;

    new count;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(!pInfo[i][CasinoDiceUiOpen]) continue;
        if(pInfo[i][CasinoDiceTable] != table_idx + 1) continue;
        if(g_casino_table_dealer[table_idx] == i) continue;
        if(!pInfo[i][CasinoDiceBetPaid]) continue;
        if(pInfo[i][CasinoDiceBetPaidTable] != table_idx + 1) continue;

        if(count < max_count)
        {
            players_out[count] = i;
        }
        count++;
    }

    return count;
}

stock StopCasinoDiceRound(table_idx)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 1;

    if(g_casino_round_timer[table_idx] != 0)
    {
        KillTimer(g_casino_round_timer[table_idx]);
        g_casino_round_timer[table_idx] = 0;
    }

    g_casino_round_active[table_idx] = false;
    g_casino_round_left[table_idx] = 0;
    TextDrawSetString(casino_dice_timer, "--");

    return 1;
}

forward CasinoDiceRoundTick(table_idx);
public CasinoDiceRoundTick(table_idx)
{
    if(!(0 <= table_idx < sizeof g_casino_table_pos)) return 1;
    if(!g_casino_round_active[table_idx]) return 1;

    new players[MAX_PLAYERS];
    new count = GetCasinoTablePlayers(table_idx, players, sizeof players);

    if(count < 2)
    {
        StopCasinoDiceRound(table_idx);
        RefreshCasinoDicePlayersListForTable(table_idx);
        return 1;
    }

    new timer_str[8];
    format(timer_str, sizeof timer_str, "%d", g_casino_round_left[table_idx]);
    TextDrawSetString(casino_dice_timer, timer_str);

    new gt_str[16];
    format(gt_str, sizeof gt_str, "~g~%d", g_casino_round_left[table_idx]);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(!pInfo[i][CasinoDiceUiOpen]) continue;
        if(pInfo[i][CasinoDiceTable] != table_idx + 1) continue;

        GameTextForPlayer(i, gt_str, 1100, 3);
        TextDrawShowForPlayer(i, casino_dice_timer);
    }

    if(g_casino_round_left[table_idx] <= 0)
    {
        new winnerid = players[random(count)];
        new winner_name[MAX_PLAYER_NAME];
        GetPlayerName(winnerid, winner_name, sizeof winner_name);

        new winner_points = random(10) + 1;

        new win_money;
        if(count > 0 && g_casino_table_bet[table_idx] > (cellmax / count)) win_money = cellmax;
        else win_money = g_casino_table_bet[table_idx] * count;
        if(win_money < 0) win_money = 0;

        if(win_money > 0)
        {
            GivePlayerMoneyEx(winnerid, win_money);
        }

        new reward_str[80];
        format(reward_str, sizeof reward_str, "Вы получили %d рублей", win_money);

        new win_msg[128];
        format(win_msg, sizeof win_msg, "{00693e}Побеждает %s. У него %d очков", winner_name, winner_points);

        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
            if(!pInfo[i][CasinoDiceUiOpen]) continue;
            if(pInfo[i][CasinoDiceTable] != table_idx + 1) continue;

            SendClientMessage(i, 0xFFFFFFFF, win_msg);
        }

        ShowNotificationNew(winnerid, 3, 6, 0, 0, reward_str, " ");

        g_casino_table_bet[table_idx] = 0;
        g_casino_table_bet_set[table_idx] = false;
        ResetCasinoTablePaidPlayers(table_idx);

        StopCasinoDiceRound(table_idx);
        RefreshCasinoDicePlayersListForTable(table_idx);
        return 1;
    }

    g_casino_round_left[table_idx]--;
    return 1;
}
stock UpdateCasinoDiceBalancePTD(playerid)
{
    new money_str[24], fmt_str[64];
    ConvertMoney(GetPlayerMoneyEx(playerid), money_str);
    format(fmt_str, sizeof fmt_str, "Баланс: %s", money_str);
    PlayerTextDrawSetString(playerid, casino_dice_balance[playerid], fmt_str);
    return 1;
}

forward CasinoDiceUiTick();
public CasinoDiceUiTick()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) continue;
        if(!pInfo[playerid][CasinoDiceUiOpen]) continue;

        new table_idx = GetNearestCasinoTable(playerid);
        if(table_idx == -1)
        {
            HideCasinoDiceUi(playerid);
            continue;
        }

        pInfo[playerid][CasinoDiceTable] = table_idx + 1;

        UpdateCasinoDicePlayersListForPlayer(playerid);
        UpdateCasinoDiceBalancePTD(playerid);
        PlayerTextDrawShow(playerid, casino_dice_balance[playerid]);
    }

    return 1;
}
stock UpdateCasinoDicePlayersListForPlayer(playerid)
{
    if(!pInfo[playerid][CasinoDiceUiOpen]) return 1;

    new table_idx = pInfo[playerid][CasinoDiceTable] - 1;

    new table_str[24];
    format(table_str, sizeof table_str, "СТОЛ %d", pInfo[playerid][CasinoDiceTable]);
    TextDrawSetString(casino_dice_table, table_str);

    new table_bet = 0;
    if(0 <= table_idx < sizeof g_casino_table_bet) table_bet = g_casino_table_bet[table_idx];

    new bet_str[32];
    format(bet_str, sizeof bet_str, "CTABKA: %d", table_bet);
    TextDrawSetString(casino_dice_bet, bet_str);

    if(!(0 <= table_idx < sizeof g_casino_area))
    {
        TextDrawSetString(casino_dice_bank, "ОБЩИЙ БАНК: 0");

        for(new i; i < 5; i++)
        {
            TextDrawSetString(casino_dice_members[i], "--");
            TextDrawSetString(casino_dice_members_ready[i], "--");
        }

        return 1;
    }

    new count;
    new paid_count;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(!pInfo[i][CasinoDiceUiOpen]) continue;
        if(pInfo[i][CasinoDiceTable] != table_idx + 1) continue;
        if(g_casino_table_dealer[table_idx] == i) continue;

        new bool:is_paid = pInfo[i][CasinoDiceBetPaid] && pInfo[i][CasinoDiceBetPaidTable] == table_idx + 1;
        if(is_paid) paid_count++;

        if(count < 5)
        {
            new line_name[MAX_PLAYER_NAME + 2];
            format(line_name, sizeof line_name, "%s", GetPlayerNameEx(i));

            TextDrawSetString(casino_dice_members[count], line_name);
            TextDrawSetString(casino_dice_members_ready[count], is_paid ? "++" : "--");
        }

        count++;
    }

    for(new i = count; i < 5; i++)
    {
        TextDrawSetString(casino_dice_members[i], "--");
        TextDrawSetString(casino_dice_members_ready[i], "--");
    }

    new bank_str[40];
    new bank_total;
    if(paid_count > 0 && table_bet > (cellmax / paid_count)) bank_total = cellmax;
    else bank_total = table_bet * paid_count;
    format(bank_str, sizeof bank_str, "ОБЩИЙ БАНК: %d", bank_total);
    TextDrawSetString(casino_dice_bank, bank_str);

    return 1;
}
stock RefreshCasinoDicePlayersListForTable(table_idx)
{
    if(!(0 <= table_idx < sizeof g_casino_area)) return 1;

    for(new player = 0; player < MAX_PLAYERS; player++)
    {
        if(!IsPlayerConnected(player) || !IsPlayerLogged(player)) continue;
        if(!pInfo[player][CasinoDiceUiOpen]) continue;
        if(pInfo[player][CasinoDiceTable] != table_idx + 1) continue;

        UpdateCasinoDicePlayersListForPlayer(player);

        TextDrawShowForPlayer(player, casino_dice_table);
        TextDrawShowForPlayer(player, casino_dice_bet);
        TextDrawShowForPlayer(player, casino_dice_bank);

        for(new i; i < 5; i++)
        {
            TextDrawShowForPlayer(player, casino_dice_members[i]);
            TextDrawShowForPlayer(player, casino_dice_members_ready[i]);
        }
    }

    return 1;
}
stock HideCasinoDiceUi(playerid)
{
    if(!pInfo[playerid][CasinoDiceUiOpen]) return 1;

    new paid_table_idx = pInfo[playerid][CasinoDiceBetPaidTable] - 1;
    new bool:refund_bet = false;
    new refund_sum = pInfo[playerid][CasinoDiceBet];

    if(pInfo[playerid][CasinoDiceBetPaid] && 0 <= paid_table_idx < sizeof g_casino_table_pos)
    {
        if(!g_casino_round_active[paid_table_idx] && refund_sum > 0)
        {
            refund_bet = true;
        }
    }

    TextDrawHideForPlayer(playerid, casino_dice_bg);
    TextDrawHideForPlayer(playerid, casino_dice_title);
    TextDrawHideForPlayer(playerid, casino_dice_info);
    TextDrawHideForPlayer(playerid, casino_dice_btn_setbet);
    TextDrawHideForPlayer(playerid, casino_dice_btn_start);
    TextDrawHideForPlayer(playerid, casino_dice_btn_exit);
    TextDrawHideForPlayer(playerid, casino_dice_players);
    TextDrawHideForPlayer(playerid, casino_dice_timer);
    TextDrawHideForPlayer(playerid, casino_dice_table);
    TextDrawHideForPlayer(playerid, casino_dice_bet);
    TextDrawHideForPlayer(playerid, casino_dice_bank);
    PlayerTextDrawHide(playerid, casino_dice_balance[playerid]);

    for(new i; i < 5; i++)
    {
        TextDrawHideForPlayer(playerid, casino_dice_members[i]);
        TextDrawHideForPlayer(playerid, casino_dice_members_ready[i]);
    }

    CancelSelectTextDraw(playerid);

    pInfo[playerid][CasinoDiceUiOpen] = false;
    pInfo[playerid][CasinoDiceTable] = 0;

    if(pInfo[playerid][CasinoDiceBetPaid])
    {
        pInfo[playerid][CasinoDiceBetPaid] = false;
        pInfo[playerid][CasinoDiceBetPaidTable] = 0;
        pInfo[playerid][CasinoDiceBet] = 1000;

        if(refund_bet && refund_sum > 0)
        {
            GivePlayerMoneyEx(playerid, refund_sum);
        }

        if(0 <= paid_table_idx < sizeof g_casino_table_pos)
        {
            RefreshCasinoDicePlayersListForTable(paid_table_idx);
        }
    }

    return 1;
}
stock ShowCasinoDiceUi(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;
    new table_id = GetNearestCasinoTable(playerid);
    if(!(0 <= table_id < sizeof g_casino_table_pos)) return SendClientMessage(playerid, 0x999999FF, "Вы должны находиться рядом со столом для игры в кости");

    if(!(pInfo[playerid][CasinoDealerJob] || pInfo[playerid][CasinoManagerJob]))
    {
        if(GetCasinoTableJoinedPlayersCount(table_id, playerid) >= 5)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "За этим столом нет мест", " ");
            return 1;
        }
    }

    if(pInfo[playerid][CasinoDiceBetPaid] && pInfo[playerid][CasinoDiceBetPaidTable] != table_id + 1)
    {
        pInfo[playerid][CasinoDiceBetPaid] = false;
        pInfo[playerid][CasinoDiceBetPaidTable] = 0;
    }

    if(pInfo[playerid][CasinoDealerJob] || pInfo[playerid][CasinoManagerJob])
    {
        new dealerid = g_casino_table_dealer[table_id];

        if(dealerid != INVALID_PLAYER_ID && !IsPlayerConnected(dealerid))
        {
            g_casino_table_dealer[table_id] = INVALID_PLAYER_ID;
            dealerid = INVALID_PLAYER_ID;
        }

        if(dealerid != INVALID_PLAYER_ID && dealerid != playerid)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "За этим столом уже есть крупье", " ");
            return 1;
        }

        for(new idx = 0; idx < sizeof g_casino_table_dealer; idx++)
        {
            if(idx == table_id) continue;
            if(g_casino_table_dealer[idx] != playerid) continue;

            g_casino_table_dealer[idx] = INVALID_PLAYER_ID;
            if(g_casino_round_active[idx]) StopCasinoDiceRound(idx);
        }

        g_casino_table_dealer[table_id] = playerid;
    }

    pInfo[playerid][CasinoDiceTable] = table_id + 1;
    if(0 <= table_id < sizeof g_casino_table_bet)
    {
        pInfo[playerid][CasinoDiceBet] = g_casino_table_bet[table_id];
    }
					else
    {
        pInfo[playerid][CasinoDiceBet] = 1000;
    }

    TextDrawShowForPlayer(playerid, casino_dice_bg);
    TextDrawShowForPlayer(playerid, casino_dice_title);
    TextDrawShowForPlayer(playerid, casino_dice_info);
    TextDrawShowForPlayer(playerid, casino_dice_btn_setbet);
    TextDrawShowForPlayer(playerid, casino_dice_btn_start);
    TextDrawShowForPlayer(playerid, casino_dice_btn_exit);
    TextDrawShowForPlayer(playerid, casino_dice_players);
    TextDrawShowForPlayer(playerid, casino_dice_timer);

    TextDrawShowForPlayer(playerid, casino_dice_table);
    TextDrawShowForPlayer(playerid, casino_dice_bet);
    TextDrawShowForPlayer(playerid, casino_dice_bank);

    for(new i; i < 5; i++)
    {
        TextDrawShowForPlayer(playerid, casino_dice_members[i]);
        TextDrawShowForPlayer(playerid, casino_dice_members_ready[i]);
    }

    pInfo[playerid][CasinoDiceUiOpen] = true;
    UpdateCasinoDicePlayersListForPlayer(playerid);
    UpdateCasinoDiceBalancePTD(playerid);
    PlayerTextDrawShow(playerid, casino_dice_balance[playerid]);

    SelectTextDraw(playerid, 0xFF5252FF);

    return 1;
}
stock CreateCasinoDiceTextDraws()
{
    casino_dice_bg = TextDrawCreate(467.200042, 109.760002, "dicebykbass:brdice");
    TextDrawLetterSize(casino_dice_bg, 0.000000, 0.000000);
    TextDrawTextSize(casino_dice_bg, 163.199951, 218.773101);
    TextDrawAlignment(casino_dice_bg, 1);
    TextDrawColor(casino_dice_bg, -1);
    TextDrawSetShadow(casino_dice_bg, 0);
    TextDrawSetOutline(casino_dice_bg, 0);
    TextDrawFont(casino_dice_bg, 4);

    casino_dice_btn_setbet = TextDrawCreate(476.799987, 280.746673, "textures:button");
TextDrawLetterSize(casino_dice_btn_setbet, 0.000000, 0.000000);
TextDrawTextSize(casino_dice_btn_setbet, 59.200000, 17.920021);
TextDrawAlignment(casino_dice_btn_setbet, 1);
TextDrawColor(casino_dice_btn_setbet, 0xFFFFFF00);
TextDrawSetShadow(casino_dice_btn_setbet, 0);
TextDrawSetOutline(casino_dice_btn_setbet, 0);
TextDrawFont(casino_dice_btn_setbet, 4);
TextDrawSetSelectable(casino_dice_btn_setbet, true);

casino_dice_btn_start = TextDrawCreate(541.799865, 280.253326, "textures:button");
TextDrawLetterSize(casino_dice_btn_start, 0.000000, 0.000000);
TextDrawTextSize(casino_dice_btn_start, 59.200000, 17.920021);
TextDrawAlignment(casino_dice_btn_start, 1);
TextDrawColor(casino_dice_btn_start, 0xFFFFFF00);
TextDrawSetShadow(casino_dice_btn_start, 0);
TextDrawSetOutline(casino_dice_btn_start, 0);
TextDrawFont(casino_dice_btn_start, 4);
TextDrawSetSelectable(casino_dice_btn_start, true);

casino_dice_btn_exit = TextDrawCreate(607.600036, 280.506652, "textures:button");
TextDrawLetterSize(casino_dice_btn_exit, 0.000000, 0.000000);
TextDrawTextSize(casino_dice_btn_exit, 15.200000, 17.920021);
TextDrawAlignment(casino_dice_btn_exit, 1);
TextDrawColor(casino_dice_btn_exit, 0xFFFFFF00);
TextDrawSetShadow(casino_dice_btn_exit, 0);
TextDrawSetOutline(casino_dice_btn_exit, 0);
TextDrawFont(casino_dice_btn_exit, 4);
TextDrawSetSelectable(casino_dice_btn_exit, true);

    casino_dice_table = TextDrawCreate(550.399719, 136.639968, "CТОЛ 1");
    TextDrawLetterSize(casino_dice_table, 0.357998, 1.405866);
    TextDrawAlignment(casino_dice_table, 2);
    TextDrawColor(casino_dice_table, -1);
    TextDrawSetShadow(casino_dice_table, 0);
    TextDrawSetOutline(casino_dice_table, 1);
    TextDrawBackgroundColor(casino_dice_table, 51);
    TextDrawFont(casino_dice_table, 1);
    TextDrawSetProportional(casino_dice_table, 1);

    casino_dice_bet = TextDrawCreate(550.599731, 159.293319, "CTABKA: 1000000");
    TextDrawLetterSize(casino_dice_bet, 0.357998, 1.405866);
    TextDrawAlignment(casino_dice_bet, 2);
    TextDrawColor(casino_dice_bet, -1);
    TextDrawSetShadow(casino_dice_bet, 0);
    TextDrawSetOutline(casino_dice_bet, 1);
    TextDrawBackgroundColor(casino_dice_bet, 51);
    TextDrawFont(casino_dice_bet, 1);
    TextDrawSetProportional(casino_dice_bet, 1);

    casino_dice_bank = TextDrawCreate(550.799743, 172.240036, "ОБЩИЙ БАНК: 0");
    TextDrawLetterSize(casino_dice_bank, 0.357998, 1.405866);
    TextDrawAlignment(casino_dice_bank, 2);
    TextDrawColor(casino_dice_bank, -1);
    TextDrawSetShadow(casino_dice_bank, 0);
    TextDrawSetOutline(casino_dice_bank, 1);
    TextDrawBackgroundColor(casino_dice_bank, 51);
    TextDrawFont(casino_dice_bank, 1);
    TextDrawSetProportional(casino_dice_bank, 1);

    casino_dice_members[0] = TextDrawCreate(474.400085, 212.800033, "BY KBAS's");
    casino_dice_members[1] = TextDrawCreate(474.400085, 225.000106, "BY KBAS's");
    casino_dice_members[2] = TextDrawCreate(474.400085, 237.200180, "BY KBAS's");
    casino_dice_members[3] = TextDrawCreate(474.400085, 249.400253, "BY KBAS's");
    casino_dice_members[4] = TextDrawCreate(474.400085, 262.347015, "BY KBAS's");

    for(new i; i < 5; i++)
    {
        TextDrawLetterSize(casino_dice_members[i], 0.285198, 1.174396);
        TextDrawAlignment(casino_dice_members[i], 1);
        TextDrawColor(casino_dice_members[i], -1);
        TextDrawSetShadow(casino_dice_members[i], 0);
        TextDrawSetOutline(casino_dice_members[i], 1);
        TextDrawBackgroundColor(casino_dice_members[i], 51);
        TextDrawFont(casino_dice_members[i], 1);
        TextDrawSetProportional(casino_dice_members[i], 1);
    }

    casino_dice_members_ready[0] = TextDrawCreate(611.599999, 213.053359, "--");
    casino_dice_members_ready[1] = TextDrawCreate(611.599999, 226.746749, "--");
    casino_dice_members_ready[2] = TextDrawCreate(611.599999, 239.693405, "--");
    casino_dice_members_ready[3] = TextDrawCreate(611.599999, 251.893463, "--");
    casino_dice_members_ready[4] = TextDrawCreate(611.599999, 263.346862, "--");

    for(new i; i < 5; i++)
    {
        TextDrawLetterSize(casino_dice_members_ready[i], 0.285198, 1.174396);
        TextDrawAlignment(casino_dice_members_ready[i], 1);
        TextDrawColor(casino_dice_members_ready[i], -1);
        TextDrawSetShadow(casino_dice_members_ready[i], 0);
        TextDrawSetOutline(casino_dice_members_ready[i], 1);
        TextDrawBackgroundColor(casino_dice_members_ready[i], 51);
        TextDrawFont(casino_dice_members_ready[i], 1);
        TextDrawSetProportional(casino_dice_members_ready[i], 1);
    }

    casino_dice_info = TextDrawCreate(550.0, 188.0, "");
    TextDrawLetterSize(casino_dice_info, 0.0, 0.0);
    TextDrawAlignment(casino_dice_info, 2);
    TextDrawColor(casino_dice_info, -1);
    TextDrawBackgroundColor(casino_dice_info, 51);
    TextDrawFont(casino_dice_info, 1);
    TextDrawSetProportional(casino_dice_info, 1);
    TextDrawSetShadow(casino_dice_info, 0);

    casino_dice_players = TextDrawCreate(550.0, 205.0, "");
    TextDrawLetterSize(casino_dice_players, 0.0, 0.0);
    TextDrawAlignment(casino_dice_players, 2);
    TextDrawColor(casino_dice_players, -1);
    TextDrawBackgroundColor(casino_dice_players, 51);
    TextDrawFont(casino_dice_players, 1);
    TextDrawSetProportional(casino_dice_players, 1);
    TextDrawSetShadow(casino_dice_players, 0);

    return 1;
}
