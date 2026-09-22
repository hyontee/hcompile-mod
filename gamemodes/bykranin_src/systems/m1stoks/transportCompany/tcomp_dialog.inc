//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_dialog.inc  (524 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_OnDialogResponse
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_dialog.inc
#if defined _tcomp_dialog_included
	#endinput
#endif
#define _tcomp_dialog_included

stock TC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]){
	if(dialogid == DIALOG_TC_DEPOSIT)
	{
		new company_sql = GetPVarInt(playerid, "TCDepositCompany");
		DeletePVar(playerid, "TCDepositCompany"); // consume before any SQL; duplicate replies cannot pay again
		if(!IsPlayerLogged(playerid) || company_sql <= 0) return 1;
		if(response) TC_DepositMoney(playerid, company_sql, inputtext);
		TC_ShowMainMenu(playerid);
		return 1;
	}
	if(TC56_Dialog(playerid, dialogid, response, inputtext)) return 1;
	if(dialogid >= DIALOG_TC_MAIN_MENU && dialogid <= DIALOG_TC_RETURN_RENT)
	{
		if(!IsPlayerLogged(playerid)) return 1;
		if(!g_tc_companies_loaded)
			return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Компании ещё не загружены. Обратитесь к администратору.");
	}
	switch(dialogid)
	{
		case DIALOG_TC_MAIN_MENU:
		{
			if(!response) return 1;
			new company_idx = TC_GetPlayerCompanyIndex(playerid);
			new bool:is_owner = (company_idx != -1 && TC_IsCompanyOwner(playerid, company_idx));
			switch(listitem)
			{
				case 0: TC_ShowInfo(playerid);
				case 1: TC_ShowFleetList(playerid, 0);
				case 2: TC_ShowManageMenu(playerid);
				case 3: TC_ShowEmployeesMenu(playerid);
				case 4: TC_ShowFinance(playerid);
				case 5: TC_ShowPersonal(playerid);
				case 6: TC_ShowUpgrade(playerid);
				case 7: TC_ShowHelp(playerid);
				case 8:
				{
					if(is_owner)
						TC_ShowDepositDialog(playerid);
					else
						TC_ShowLeaveConfirm(playerid);
				}
				case 9: if(!is_owner) TC_ShowDepositDialog(playerid);
			}
			return 1;
		}
		case DIALOG_TC_INFO:
		{
			if(response) TC_ShowMainMenu(playerid);
			return 1;
		}
		case DIALOG_TC_HELP:
		{
			if(response) TC_ShowMainMenu(playerid);
			return 1;
		}
		case DIALOG_TC_FLEET_LIST:
		{
			if(!response) return 1;

			new company_idx = TC_GetPlayerCompanyIndex(playerid);
			if(company_idx == -1) return 1;

			new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
			new total = TC_GetFleetCountForCompany(company_sql);
			new page = p_tc_fleet_page[playerid];
			new row_offset = (page > 0) ? 1 : 0;
			new items_on_page = total - page * TC_FLEET_PAGE_SIZE;
			if(items_on_page > TC_FLEET_PAGE_SIZE) items_on_page = TC_FLEET_PAGE_SIZE;
			new has_next = ((page + 1) * TC_FLEET_PAGE_SIZE < total);
			new bool:owner_can_buy = TC_IsCompanyOwner(playerid, company_idx);
			new buy_row = -1;
			if(owner_can_buy && has_next)
				buy_row = row_offset + items_on_page + 1;
			else if(owner_can_buy && !has_next)
				buy_row = row_offset + items_on_page;

			if(page > 0 && listitem == 0)
			{
				TC_ShowFleetList(playerid, page - 1);
				return 1;
			}
			if(has_next && listitem == row_offset + items_on_page)
			{
				TC_ShowFleetList(playerid, page + 1);
				return 1;
			}
			if(owner_can_buy && listitem == buy_row)
			{
				TC_ShowBuyDialog(playerid);
				return 1;
			}

			new fleet_idx = GetPlayerListitemValue(playerid, listitem + 1);
			TC_ShowFleetVehicleMenu(playerid, fleet_idx);
			return 1;
		}
		case DIALOG_TC_FLEET_MANAGE:
		{
			new fleet_idx = p_tc_fleet_sel[playerid];
			new company_idx = TC_GetPlayerCompanyIndex(playerid);
			if(company_idx == -1) return 1;

			if(!TC_IsCompanyOwner(playerid, company_idx))
			{
				TC_ShowFleetList(playerid, p_tc_fleet_page[playerid]);
				return 1;
			}

			if(!response)
			{
				TC_ShowFleetList(playerid, p_tc_fleet_page[playerid]);
				return 1;
			}

			switch(listitem)
			{
				case 0: TC_ShowFleetRepairConfirm(playerid);
				case 1: TC_ShowFleetRentPriceDialog(playerid);
				case 2: TC_ShowFleetSellConfirm(playerid, fleet_idx);
			}
			return 1;
		}
		case DIALOG_TC_FLEET_REPAIR:
		{
			if(!response)
			{
				TC_ShowFleetVehicleMenu(playerid, p_tc_fleet_sel[playerid]);
				return 1;
			}
			TC_RepairFleet(playerid, p_tc_fleet_sel[playerid]);
			TC_ShowFleetVehicleMenu(playerid, p_tc_fleet_sel[playerid]);
			return 1;
		}
		case DIALOG_TC_FLEET_SELL_VEH:
		{
			if(!response)
			{
				TC_ShowFleetVehicleMenu(playerid, p_tc_fleet_sel[playerid]);
				return 1;
			}
			TC_SellFleetVehicle(playerid, p_tc_fleet_sel[playerid]);
			TC_ShowFleetList(playerid, p_tc_fleet_page[playerid]);
			return 1;
		}
		case DIALOG_TC_FLEET_RENTPRICE:
		{
			if(!response)
			{
				TC_ShowFleetVehicleMenu(playerid, p_tc_fleet_sel[playerid]);
				return 1;
			}
			if(!TC_SetFleetRentPrice(playerid, p_tc_fleet_sel[playerid], strval(inputtext)))
			{
				TC_ShowFleetRentPriceDialog(playerid);
				return 1;
			}
			TC_ShowFleetVehicleMenu(playerid, p_tc_fleet_sel[playerid]);
			return 1;
		}
		case DIALOG_TC_MANAGE:
		{
			if(!response) { TC_ShowMainMenu(playerid); return 1; }
			switch(listitem)
			{
				case 0: TC_ShowWithdrawDialog(playerid);
				case 1: TC_ShowRenameDialog(playerid);
				case 2: TC_ShowCommissionDialog(playerid);
				case 3: TC_ShowFireDialog(playerid);
				case 4: TC_ShowSellConfirm(playerid);
			}
			return 1;
		}
		case DIALOG_TC_WITHDRAW:
		{
			if(!response) { TC_ShowManageMenu(playerid); return 1; }
			TC_WithdrawMoney(playerid, strval(inputtext));
			return 1;
		}
		case DIALOG_TC_RENAME:
		{
			if(!response) { TC_ShowManageMenu(playerid); return 1; }
			TC_RenameCompany(playerid, inputtext);
			return 1;
		}
		case DIALOG_TC_COMMISSION:
		{
			if(!response) { TC_ShowManageMenu(playerid); return 1; }
			TC_SetCommission(playerid, strval(inputtext));
			return 1;
		}
		case DIALOG_TC_FIRE:
		{
			if(!response) { TC_ShowManageMenu(playerid); return 1; }
			if(!TC_PrepareFireTarget(playerid, inputtext))
			{
				TC_ShowFireDialog(playerid);
				return 1;
			}
			TC_ShowFireConfirm(playerid);
			return 1;
		}
		case DIALOG_TC_FIRE_CONFIRM:
		{
			if(!response) { TC_ShowFireDialog(playerid); return 1; }
			TC_FireEmployee(playerid, p_tc_fire_target[playerid]);
			return 1;
		}
		case DIALOG_TC_BUY:
		{
			if(!response) { TC_ShowFleetList(playerid, p_tc_fleet_page[playerid]); return 1; }
			if(listitem != 0) return 1;
			TC_BuyFleet(playerid, TC_BUY_TYPE_VAN);
			return 1;
		}
		case DIALOG_TC_SELL:
		{
			if(!response) { TC_ShowManageMenu(playerid); return 1; }
			TC_SellCompany(playerid);
			return 1;
		}
		case DIALOG_TC_EMPLOYEES:
		{
			if(!response) { TC_ShowMainMenu(playerid); return 1; }
			switch(listitem)
			{
				case 0: TC_ShowEmpListSubmenu(playerid);
				case 1: TC_ShowEmpRatingMenu(playerid);
			}
			return 1;
		}
		case DIALOG_TC_EMP_SUBMENU:
		{
			if(!response) { TC_ShowEmployeesMenu(playerid); return 1; }
			switch(listitem)
			{
				case 0: TC_ShowEmployeesInGame(playerid, 0);
				case 1: TC_ShowEmployeesDB(playerid, 1, 0);
				case 2: TC_ShowEmployeesDB(playerid, 2, 0);
			}
			return 1;
		}
		case DIALOG_TC_EMP_RATING_MENU:
		{
			if(!response) { TC_ShowEmployeesMenu(playerid); return 1; }
			switch(listitem)
			{
				case 0: TC_RequestRatingList(playerid, 0);
				case 1: TC_RequestRatingList(playerid, 1);
				case 2: TC_RequestRatingList(playerid, 2);
				case 3: TC_ShowRatingHelp(playerid);
			}
			return 1;
		}
		case DIALOG_TC_EMP_RATING_LIST:
		{
			TC_ShowEmpRatingMenu(playerid);
			return 1;
		}
		case DIALOG_TC_RATING_HELP:
		{
			TC_ShowEmpRatingMenu(playerid);
			return 1;
		}
		case DIALOG_TC_EMP_LIST:
		{
			new mode = p_tc_emp_view_mode[playerid];
			new page = p_tc_emp_page[playerid];
			new company_idx = TC_GetPlayerCompanyIndex(playerid);
			new bool:is_owner = (company_idx != -1 && TC_IsCompanyOwner(playerid, company_idx));

			if(!response)
			{
				if(mode == 0) TC_ShowEmpListSubmenu(playerid);
				else TC_ShowEmpListSubmenu(playerid);
				return 1;
			}

			if(mode == 0)
			{
				new owner_id = g_tc_companies[company_idx][TC_OWNER_ID];
				new total;
				foreach(new i : Player)
				{
					if(!IsPlayerLogged(i)) continue;
					if(p_tc_company[i] != company_idx) continue;
					if(GetPlayerAccountID(i) == owner_id) continue;
					total++;
				}
				new items_on_page = total - page * TC_EMPLOYEE_PAGE_SIZE;
				if(items_on_page > TC_EMPLOYEE_PAGE_SIZE) items_on_page = TC_EMPLOYEE_PAGE_SIZE;
				new has_next = ((page + 1) * TC_EMPLOYEE_PAGE_SIZE < total);

				if(has_next && listitem == items_on_page)
				{
					TC_ShowEmployeesInGame(playerid, page + 1);
					return 1;
				}

				if(is_owner && listitem < items_on_page)
				{
					new row = GetPlayerListitemValue(playerid, listitem + 1);
					format(p_tc_fire_target[playerid], 24, "%s", p_tc_emp_row_name[playerid][row]);
					TC_ShowFireConfirm(playerid);
					return 1;
				}
				return 1;
			}

			if(mode == 1 || mode == 2)
			{
				new shown = p_tc_emp_list_shown[playerid];
				new total = p_tc_emp_total[playerid];
				new has_next = ((page + 1) * TC_EMPLOYEE_PAGE_SIZE < total);

				if(has_next && listitem == shown)
				{
					TC_ShowEmployeesDB(playerid, mode, page + 1);
					return 1;
				}

				if(is_owner && listitem < shown)
				{
					new row = GetPlayerListitemValue(playerid, listitem + 1);
					format(p_tc_fire_target[playerid], 24, "%s", p_tc_emp_row_name[playerid][row]);
					TC_ShowFireConfirm(playerid);
				}
				return 1;
			}
			return 1;
		}
		case DIALOG_TC_FINANCE:
		{
			if(!response) { TC_ShowMainMenu(playerid); return 1; }
			switch(listitem)
			{
				case 0: TC_RequestFinanceDetail(playerid, TC_FIN_RENT);
				case 1: TC_RequestFinanceDetail(playerid, TC_FIN_TRANSPORT);
				case 2: TC_RequestFinanceDetail(playerid, TC_FIN_EXPENSE);
				case 3: TC_RequestFinanceDetail(playerid, TC_FIN_DEPOSIT);
			}
			return 1;
		}
		case DIALOG_TC_FINANCE_DETAIL:
		{
			if(response) TC_ShowFinance(playerid);
			return 1;
		}
		case DIALOG_TC_PERSONAL:
		{
			if(response) TC_ShowMainMenu(playerid);
			return 1;
		}
		case DIALOG_TC_UPGRADE:
		{
			if(!response) { TC_ShowMainMenu(playerid); return 1; }
			if(listitem < 0 || listitem > 2) return 1;
			TC_ShowUpgradeConfirm(playerid, listitem);
			return 1;
		}
		case DIALOG_TC_UPGRADE_CONFIRM:
		{
			if(!response)
			{
				TC_ShowUpgrade(playerid);
				return 1;
			}
			TC_BuyCompanyUpgrade(playerid, p_tc_upgrade_sel[playerid]);
			TC_ShowUpgrade(playerid);
			return 1;
		}
		case DIALOG_TC_LEAVE:
		{
			if(!response) { TC_ShowMainMenu(playerid); return 1; }
			TC_LeaveCompany(playerid);
			return 1;
		}
		case DIALOG_TC_COMPANY_LIST:
		{
			if(!response) return 1;

			new office = p_tc_office[playerid];
			new page = p_tc_company_page[playerid];
			new total;
			for(new i = 0; i < g_tc_companies_loaded; i++)
				if(g_tc_companies[i][TC_OFFICE] == office && g_tc_companies[i][TC_OWNER_ID] != -1)
					total++;

			new items_on_page = total - page * TC_COMPANY_PAGE_SIZE;
			if(items_on_page > TC_COMPANY_PAGE_SIZE) items_on_page = TC_COMPANY_PAGE_SIZE;
			new has_next = ((page + 1) * TC_COMPANY_PAGE_SIZE < total);

			if(has_next && listitem == items_on_page)
			{
				TC_ShowWorkerCompanyList(playerid, office, page + 1);
				return 1;
			}

			new company_idx = GetPlayerListitemValue(playerid, listitem + 1);
			if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 1;
			TC_ShowCompanyJoinConfirm(playerid, company_idx);
			return 1;
		}
		case DIALOG_TC_COMPANY_JOIN:
		{
			new company_idx = p_tc_join_company[playerid];
			if(!response)
			{
				if(company_idx >= 0)
					TC_ShowWorkerCompanyList(playerid, g_tc_companies[company_idx][TC_OFFICE], p_tc_company_page[playerid]);
				return 1;
			}
			if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 1;

			if(p_tc_company[playerid] != -1 || TC_GetOwnedCompanyIndex(playerid) != -1)
			{
				SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы уже состоите в транспортной компании.");
				return 1;
			}
			TC_JoinCompany(playerid, company_idx);
			return 1;
		}
		case DIALOG_TC_RENT_LIST:
		{
			if(!response) return 1;

			new page = p_tc_rent_page[playerid];
			new company_idx = TC_GetPlayerCompanyIndex(playerid);
			if(company_idx == -1) return 1;

			new company_sql = g_tc_companies[company_idx][TC_SQL_ID];
			new total;
			for(new i = 0; i < g_tc_fleet_loaded; i++)
			{
				if(g_tc_fleet[i][TF_COMPANY_ID] != company_sql) continue;
				if(g_tc_fleet[i][TF_BROKEN] || g_tc_fleet[i][TF_TRIPS_LEFT] <= 0) continue;
				if(g_tc_fleet[i][TF_RENTED_ACCOUNT_ID] != -1) continue;
				total++;
			}

			new items_on_page = total - page * TC_RENT_PAGE_SIZE;
			if(items_on_page > TC_RENT_PAGE_SIZE) items_on_page = TC_RENT_PAGE_SIZE;
			new has_next = ((page + 1) * TC_RENT_PAGE_SIZE < total);

			if(has_next && listitem == items_on_page)
			{
				TC_ShowRentList(playerid, page + 1);
				return 1;
			}

			new fleet_idx = GetPlayerListitemValue(playerid, listitem + 1);
			TC_StartRent(playerid, fleet_idx);
			return 1;
		}
		case DIALOG_TC_ORDERS_LIST:
		{
			if(!response) return 1;
			new order_idx = GetPlayerListitemValue(playerid, listitem + 1);
			TC_ShowOrderInfo(playerid, order_idx);
			return 1;
		}
		case DIALOG_TC_ORDER_INFO:
		{
			if(!response) { TC_ShowOrdersList(playerid, p_tc_orders_page[playerid]); return 1; }
			TC_AcceptOrder(playerid, p_tc_pick_order[playerid]);
			TC_Send(playerid, "Заказ принят.");
			return 1;
		}
		case DIALOG_TC_CARGO_RESPAWN:
		{
			if(!response) return 1;
			if(p_tc_order_progress[playerid] >= 2)
			{
				p_tc_trailer_last_recover_ms[playerid] = 0;
				TC_RecoverTrailerForActiveCargo(playerid, true);
				TC_RestoreActiveCheckpoint(playerid);
			}
			else TC_SpawnTrailerForPlayer(playerid, true);
			return 1;
		}
		case DIALOG_TC_RETURN_RENT:
		{
			if(!response) return 1;
			TC_ReturnRentedTruck(playerid);
			return 1;
		}
		case DIALOG_TC_ADMIN_LIST:
		{
			if(!response || !GetPlayerAdminEx(playerid)) return 1;
			if(listitem < 0 || listitem >= g_tc_companies_loaded) return 1;
			TC_ShowAdminGiveInput(playerid, listitem);
			return 1;
		}
		case DIALOG_TC_ADMIN_GIVE:
		{
			if(!response || !GetPlayerAdminEx(playerid))
			{
				if(GetPlayerAdminEx(playerid)) TC_RequestAdminCompanyList(playerid);
				return 1;
			}

			new company_idx = p_tc_admin_company[playerid];
			if(company_idx < 0 || company_idx >= g_tc_companies_loaded) return 1;

			new targetid = GetPlayerID(inputtext);
			if(targetid == INVALID_PLAYER_ID || !IsPlayerLogged(targetid))
			{
				SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Игрок не найден на сервере.");
				TC_ShowAdminGiveInput(playerid, company_idx);
				return 1;
			}
			TC_AdminGiveCompany(playerid, company_idx, targetid);
			return 1;
		}
	}
	return 0;
}
// END INLINED: modules/m1stoks/transportCompany/tcomp_dialog.inc
