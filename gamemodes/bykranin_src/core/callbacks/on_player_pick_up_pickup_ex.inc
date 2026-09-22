//>> Файл: bykranin_src/core/callbacks/on_player_pick_up_pickup_ex.inc  (1538 строк)
//>> Тема: стандартные колбэки SA-MP/плагинов (OnPlayerConnect, OnDialogResponse и т.д.)
//>> Внутри: OnPlayerPickUpPickupEx
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	if(FsinFull_OnPlayerPickUpPickup(playerid,pickupid)) return 1;
	if(GarageSys_OnPickup(playerid, pickupid, action_type, action_id)) return 1;
	if(TC_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)) return 1;
	if(Larek_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)) return 1;

	if(action_type == PICKUP_ACTION_TYPE_STATIC_GUN_SHOP)
	{
		return WeaponShop_EnterStaticShop(playerid, action_id);
	}
	if(action_type == PICKUP_ACTION_TYPE_STATIC_GUN_SHOP_EXIT)
	{
		return WeaponShop_ExitStaticShop(playerid);
	}

	new locker_org_id;
	if(pickupid == razdev) locker_org_id = TEAM_FBI;
	else if(pickupid == razdev1) locker_org_id = TEAM_GOVERNMENT;
	else if(pickupid == razdev2) locker_org_id = TEAM_ARMY;
	else if(pickupid == razdev3) locker_org_id = TEAM_HOSPITAL;
	else if(pickupid == razdev9) locker_org_id = TEAM_RADIO;
	else if(pickupid == razdev4) locker_org_id = TEAM_DPS;
	else if(pickupid == razdev5) locker_org_id = TEAM_PPS;
	else if(pickupid == razdev6) locker_org_id = TEAM_OPG_ARZAMASKAYA;
	else if(pickupid == razdev7) locker_org_id = TEAM_OPG_BATYREVSKAYA;
	else if(pickupid == razdev8) locker_org_id = TEAM_OPG_LYTKARINSKAYA;

	if(locker_org_id)
	{
		if(GetPlayerTeamEx(playerid) != locker_org_id)
			return ShowNotificationNew(playerid, 2, 5, 0, 0, "Эта раздевалка доступна только сотрудникам организации", "");
		if(GetPlayerData(playerid, P_OSKIN) <= 0)
			return ShowNotificationNew(playerid, 2, 5, 0, 0, "Для Вашего ранга не назначена рабочая форма", "");

		SetPVarInt(playerid, "OrgLockerTeam", locker_org_id);
		new locker_text[80];
		if(GetPVarInt(playerid, "Form"))
			format(locker_text, sizeof(locker_text), "Вы хотите закончить рабочий день и снять форму?");
		else
			format(locker_text, sizeof(locker_text), "Вы хотите начать рабочий день и надеть форму?");
		Dialog(playerid, DIALOG_FRAKSKINS, DIALOG_STYLE_MSGBOX, "Раздевалка организации", locker_text, "Да", "Нет");
		return 1;
	}
    //===============[вот сюдыыыыы]=============================

	
	if(pickupid == pickup_rent_main)
    {
        ShowRentMenu(playerid);
    }
    if(pickupid == g_casino_bonus_entry_pickup)
    {
        new casino_biz = GetNearestBiz(playerid, BUSINESS_TYPE_CASINO, 0.0);

        if(casino_biz != -1)
        {
            EnterPlayerToBiz(playerid, casino_biz);
            return 1;
        }

        SetPlayerPosEx
        (
            playerid,
            GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_ENTER_POS_X),
            GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_ENTER_POS_Y),
            GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_ENTER_POS_Z),
            GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_ENTER_ANGLE),
            GetBusinessInteriorInfo(BUSINESS_INTERIOR_CASINO, BT_ENTER_INTERIOR),
            0, false
        );
        return 1;
    }

    if(pickupid == g_casino_bonus_exit_pickup)
    {
        SetPlayerPosEx
        (
            playerid,
            1332.560546,
            2361.656738,
            17.712001,
            357.240692,
            0,
            0, false
        );
        return 1;
    }

    if(pickupid == g_casino_croupier_pickup)
    {
        if(pInfo[playerid][CasinoDealerJob] || pInfo[playerid][CasinoManagerJob])
        {
            Dialog(playerid, DIALOG_CASINO_JOB_QUIT, DIALOG_STYLE_MSGBOX, "Раздевалка казино", "Вы хотите снять рабочую форму?", "Да", "Нет");
            return 1;
        }

        new casino_business = GetPlayerInBiz(playerid);
        if(GetPlayerData(playerid, P_CASINO_JOB) == 0 || GetPlayerData(playerid, P_CASINO_BUSINESS) != casino_business)
            return SendClientMessage(playerid, 0xCECECEFF, "Вы не работаете в казино.");

        Dialog(playerid, DIALOG_CASINO_JOB_SELECT, DIALOG_STYLE_MSGBOX, "Раздевалка казино", "Надеть рабочую форму?", "Да", "Нет");
        return 1;
    }
    if(pickupid == family_create_pickup)
    {
	    if(GetPlayerIdFamily(playerid) != -1)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы уже состоите в семье.", " ");

        if(GetPlayerMoneyEx(playerid) < 3_000_000)
        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Для создания семьи у Вас должно быть 3.000.000 рублей.", " ");

        Dialog
        (
            playerid, DIALOG_CREATE_FAMILY, DIALOG_STYLE_INPUT,
            "{FF0000}Создание семьи",
            "{FFFFFF}Здесь Вы можете создать свою семью.\n"\
            "Цена: {FFFF00}3.000.000 рублей.\n\n"\
            "{FFFFFF}Напишите название Вашей будущей семьи:",
            "Далее", "Выйти"
        );
        return 1;
    }
	
	                   if(pickupid == vxodpravo)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid vxodpravo");
                         SetPlayerPos(playerid, 978.711975,-18.241992,1380.996215); 
                         SetPlayerFacingAngle(playerid, 365.0000); 
                         SetPlayerInterior(playerid, 0); 
                         }
                        
                        if(pickupid == vixodpravo)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid vixodpravo");
                         SetPlayerPos(playerid, -141.419021,613.931823,12.116942); 
                         SetPlayerFacingAngle(playerid, 365.0000); 
                         SetPlayerInterior(playerid, 0); 
                         }

if(pickupid == tkvxodpon)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid tkvxodpon");
                         SetPlayerPos(playerid, 0.216851,2501.760498,2011.005126); 
                         SetPlayerFacingAngle(playerid, 270.0000); 
                         SetPlayerInterior(playerid, 1); 
                         }
                         
                        if(pickupid == tkvixodpon)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid tkvixodpon");
                         SetPlayerPos(playerid, 2327.538574,2012.246826,16.121875); 
                         SetPlayerFacingAngle(playerid, 365.0000); 
                         SetPlayerInterior(playerid, 0); 
                         }
                        
                        if(pickupid == lazaretvhod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid lazaretvhod");
                         SetPlayerPos(playerid, -2002.991333,-1504.858642,1751.005249); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == lazaretvihod)
                        {
                       // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} lazaretvihod");
                         SetPlayerPos(playerid, -1800.220703,-2757.756591,1501.000000); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == cameravhod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid cameravhod");
                         SetPlayerPos(playerid, -1699.121582,-2702.468261,1499.500000); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == cameravihod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid cameravihod");
                         SetPlayerPos(playerid, -1800.229248,-2766.166015,1501.000000); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == lesopilvhod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid lesopilvhod");
                         SetPlayerPos(playerid, -1887.554321,-2608.276611,1501.000000); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == lesopilvihod)
                        {
                       // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid lesopilvihod");
                         SetPlayerPos(playerid, -1799.559448,-2759.095947,1501.000000); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 270.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                         if(pickupid == pkvxod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid pkvxod");
                         SetPlayerPos(playerid, 1309.926147,1711.613647,1498.363159); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 365.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 1); // 0 - выход на улицу.
                         }
                        
                        if(pickupid == pkvixod)
                        {
                        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid pkvixod");
                         SetPlayerPos(playerid, -2380.000244,31.873023,26.519172); // Координаты игрока при выходе на улицу.
                         SetPlayerFacingAngle(playerid, 365.0000); // Угол поворота игрока.
                         SetPlayerInterior(playerid, 0); // 0 - выход на улицу.
                         }
                         
/*                      	if(pickupid == cblit)
	{
	SetPlayerPos(playerid, 1501.90, 2490.86, 2501.00);
	SetPlayerInterior(playerid, 1);
	SetPlayerVirtualWorld(playerid, 1);
	return 1;
	}
	if(pickupid == cblitexit)
	{
	SetPlayerPos(playerid, -2334.60, -173.15, 26.81);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
	}*/
     	/*if(pickupid == tehsentervlad)
	{
	    SendClientMessage(playerid, 0xCECECEFF, "В данный тип бизнеса нельзя войти");
	}*/
                        if(pickupid == pickupferma)
                        {
                        callcmd::sosososo(playerid);
                       } 
                        
//==============[вот сюдыыыыы ...(*?0?)?]=============================
if(pickupid == medka)
	{
	
		{
		    if(g_player[playerid][P_MEDKA] == 0)
		    {
		        ShowPlayerDialog(playerid, 1006, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Получение медицинской карты.", "Вы действитеьно хотите получить мед-карту за 5000 рублей?", "Да", "Отмена");
		    }
					else
		    {
		        SCM(playerid, COLOR_WHITE, "У вас уже есть медкарта!");
		    }
		//SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid medka");
		}
	}
	if(pickupid == avtorinokz)
                        {
                            if(!IsPlayerLogged(playerid) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
                            if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return 1;
                            if(!IsPlayerInRangeOfPoint(playerid, 3.0, 887.844970, -922.904968, 41.470359)) return 1;
                            // Sales vehicles and tp_buy already use world 101, interior 1.
                            SetPlayerPosEx(playerid, 440.320770, 982.426330, 1001.000000, 270.0, 1, 101, false);
                            return 1;
                         }
                         if(pickupid == avtorinokv)
                        {
                            if(!IsPlayerLogged(playerid) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) return 1;
                            if(GetPlayerVirtualWorld(playerid) != 101 || GetPlayerInterior(playerid) != 1) return 1;
                            if(!IsPlayerInRangeOfPoint(playerid, 3.0, 437.292938, 982.754150, 1001.000000)) return 1;
                            SetPlayerPosEx(playerid, 887.844970, -922.904968, 41.470359, 24.541509, 0, 0, false);
                            return 1;
                         }
 if(quest != -1 && pickupid == quest)
    {
        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid quest");
        ShowPlayerQuestMenu(playerid);
	}

	if(pickupid == pickup_shop247_medkit)
	{
		if(GetPlayerInterior(playerid) != 1)
			return 1;

		if(GetPlayerHealthEx(playerid) >= 100.0)
			return 1;

		new price = 150;
		if(GetPlayerMoneyEx(playerid) < price)
			return SendClientMessage(playerid, 0x999999FF, "Аптечка стоит 150 рублей");

		new query[128];
		format(query, sizeof query, "UPDATE accounts SET money=%d WHERE id=%d LIMIT 1", GetPlayerMoneyEx(playerid) - price, GetPlayerAccountID(playerid));
		mysql_query(mysql, query, false);

		if(mysql_errno())
			return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 24)");

		GivePlayerMoneyEx(playerid, -price, "Покупка аптечки 24/7", false, true);
		SetPlayerHealthEx(playerid, 99.0);
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Вы потратили 150 рублей", "OK");
		return 1;
	}

	if(pickupid == PickupPoint)
    {
        //SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} pickupid PickupPoint");
        PickupCreated = 0;
        DestroyPickup(PickupPoint);
        RemovePlayerMapIcon(playerid, 25);
        return 1;
    }

	if(pickupid == mexpick)
	{
		if(GetPlayerJob(playerid) == JOB_UNUSED_3)
		{
			new job_car = GetPlayerJobCar(playerid);

				Dialog
				(
					playerid, DIALOG_UNUSED_LEGACY_6, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Автопарк",
					"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
					"Вы действительно хотите заключить договор аренды?",
					"Да", "Нет"
				);
		}
					else
		{
			RemovePlayerFromVehicle(playerid);
			SendClientMessage(playerid, 0xCECECEFF, "Вы не автомеханик");
		}
	}

		
	if(pickupid == buspick1)
	{
		if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
		{
			new job_car = GetPlayerJobCar(playerid);
			new vehicleid = GetPlayerVehicleID(playerid);

			if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
			{
				Dialog
				(
					playerid, DIALOG_BUS_RENT_CAR, DIALOG_STYLE_MSGBOX,
					"{FFCD00}Автобусный парк",
					"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
					"Вы действительно хотите взять автобус в аренду?",
					"Да", "Нет"
				);
				}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не водитель автобуса");
						}
	}
	if(pickupid == buspick2)
	{
		if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
						{
							new job_car = GetPlayerJobCar(playerid);
							new vehicleid = GetPlayerVehicleID(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_BUS_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Автобусный парк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
									"Вы действительно хотите взять автобус в аренду?",
									"Да", "Нет"
								);
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не водитель автобуса");
						}
	}
	
	if(pickupid == buspick3)
	{
		if(GetPlayerJob(playerid) == JOB_BUS_DRIVER)
						{
							new job_car = GetPlayerJobCar(playerid);
							new vehicleid = GetPlayerVehicleID(playerid);

							if(!IsPlayerInJob(playerid) && job_car != vehicleid && action_id == VEHICLE_ACTION_ID_NONE)
							{
								Dialog
								(
									playerid, DIALOG_BUS_RENT_CAR, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Автобусный парк",
									"{FFFFFF}Чтобы взять машину, необходимо заплатить городскому автопарку 180 рублей\n"\
									"Вы действительно хотите взять автобус в аренду?",
									"Да", "Нет"
								);
							}
					else KillEndJobTimer(playerid);
						}
					else
						{
							RemovePlayerFromVehicle(playerid);
							SendClientMessage(playerid, 0xCECECEFF, "Вы не водитель автобуса");
						}
	}



	if(GetPlayerData(playerid, P_PICKUP_TIME) < gettime())
	{
		g_player[playerid][P_PICKUP_TIME] = gettime()+3;
		/*if(action_type != PICKUP_ACTION_TYPE_TELEPORT && GetPlayerData(playerid, P_LAST_PICKUP) != -1)
		{
			return 0;
		}
	*/
		if(IsPlayerInRangeOfPoint(playerid, 5.0, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
		{
			SetPlayerData(playerid, P_LAST_PICKUP, pickupid);
			if(pickupid == moto_salon_entry_pickup)
			{
				new moto_exit_block = GetPVarInt(playerid, "moto_salon_exit_block");
				DebugMotoSalonLog(playerid, "Pickup:MOTO_ENTER:triggered", pickupid, action_type);
				if(moto_exit_block > GetTickCount())
				{
					DebugMotoSalonLog(playerid, "Pickup:MOTO_ENTER:blocked_by_timer", pickupid, action_type);
					return 1;
				}
				if(!IsPlayerInRangeOfPoint(playerid, 2.0, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
				{
					DebugMotoSalonLog(playerid, "Pickup:MOTO_ENTER:blocked_by_distance", pickupid, action_type);
					return 1;
				}

				if(!PlayerHasFreeCarSlotForMarket(playerid, STATIC_BIZ_ID_MOTO_SALON))
				{
					DebugMotoSalonLog(playerid, "Pickup:MOTO_ENTER:no_slots", pickupid, action_type);
					return 1;
				}

				HidePlayerSelectPanel(playerid);
				ToggleInteractionWindow(playerid, false);
				SetPlayerInBiz(playerid, STATIC_BIZ_ID_MOTO_SALON);
				SetPlayerPosEx(playerid, -587.947204, 2310.773681, 1501.040039, 168.514511, 1, 0, false);
				DebugMotoSalonLog(playerid, "Pickup:MOTO_ENTER:teleported_inside", pickupid, action_type);
				return 1;
			}
			if(pickupid == moto_salon_exit_pickup)
			{
				DebugMotoSalonLog(playerid, "Pickup:MOTO_EXIT:triggered", pickupid, action_type);
				if(!IsPlayerInRangeOfPoint(playerid, 2.0, GetPickupInfo(pickupid, P_POS_X), GetPickupInfo(pickupid, P_POS_Y), GetPickupInfo(pickupid, P_POS_Z)))
				{
					DebugMotoSalonLog(playerid, "Pickup:MOTO_EXIT:blocked_by_distance", pickupid, action_type);
					return 1;
				}

				HidePlayerSelectPanel(playerid);
				ToggleInteractionWindow(playerid, false);
				SetPlayerInBiz(playerid, -1);
				SetPVarInt(playerid, "moto_salon_exit_block", GetTickCount() + 3000);
				SetPlayerPosEx(playerid, -912.098510, 1185.263305, 10.724749, 232.377990, 0, 0, false);
				DebugMotoSalonLog(playerid, "Pickup:MOTO_EXIT:teleported_outside", pickupid, action_type);
				return 1;
			}

			switch(action_type)
			{
				case PICKUP_ACTION_TYPE_TELEPORT:
				{
					if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_NONE)
					{
						switch(GetTeleportData(action_id, T_ACTION_TYPE))
						{
							case T_ACTION_TYPE_BLOCK_LEAVE_AREA:
							{
								SetPlayerData(playerid, P_BLOCK_LEAVE_AREA, true);
							}
							case T_ACTION_TYPE_END_JOB:
							{
								EndPlayerTempJob(playerid, TEMP_JOB_FACTORY, true);
							}
							case T_ACTION_TYPE_LEAVE_HOSPITAL:
							{
								if(GetPlayerData(playerid, P_HOSPITAL))
								{
									if(GetPlayerHealthEx(playerid) < 70.0) return SendClientMessage(playerid, -1, "Медперсонал не может отпустить Вас в таком состоянии. Отправляйтесь на лечение");
									else if(GetPlayerData(playerid, P_OCCUPIED_BED) != -1)
									{
										SendClientMessage(playerid, 0x66CC00FF, "Вы выписались из больницы");
										ClearMedBed(playerid, GetPlayerData(playerid, P_OCCUPIED_BED));
									}
									SetPlayerData(playerid, P_HOSPITAL, false);
									UpdatePlayerDatabaseInt(playerid, "hospital", 0);
								}
							}
							case T_ACTION_TYPE_LEAVE_PPS:
							{
								if(GetPlayerData(playerid, P_JAIL))
								{
									SendClientMessage(playerid, 0x999999FF, "Время заключения не истекло");

									SetPlayerSpawnPos(playerid);

									return 1;
								}
							}
						}

						SetPlayerPosEx
						(
							playerid,
							GetTeleportData(action_id, T_POS_X),
							GetTeleportData(action_id, T_POS_Y),
							GetTeleportData(action_id, T_POS_Z),
							GetTeleportData(action_id, T_ANGLE),
							GetTeleportData(action_id, T_INTERIOR),
							GetTeleportData(action_id, T_VIRTUAL_WORLD)
						);
					}
				}
				case PICKUP_ACTION_TYPE_DRIVING_TUTO:
				{
					ShowPlayerDrivingTutorial(playerid);
				}
				case PICKUP_ACTION_TYPE_ATM:
				{
					ShowPlayerATMDialog(playerid);
				}
				case PICKUP_ACTION_OBMEN_MONET:
				{
				    ShowPlayerObmenMonet(playerid);
				}

				case PICKUP_ACTION_TYPE_BANK:
				{
					if(action_id)
					{
						callcmd::bank(playerid, "");
					}
					else ShowPlayerPayForRentDialog(playerid);
				}
				case PICKUP_ACTION_TYPE_ENTRANCE_FLA:
							{

									new entranceid = GetPlayerInEntrance(playerid);
									new floor = GetPlayerInEntranceFloor(playerid);

									if(entranceid != -1 && floor >= 1)
									{
										ShowPlayerHouseInfo(playerid, g_entrance_flat[entranceid][floor - 1][action_id]);
									}

							}
							case PICKUP_ACTION_TYPE_HOTEL_ROOM:
							{
									new hotel_id = GetPlayerInHotelID(playerid);
									new floor = GetPlayerData(playerid, P_IN_HOTEL_FLOOR);

									if(hotel_id != -1 && floor >= 1)
									{
										new room_id = ((floor-1)*12) + action_id;
										EnterPlayerToHotelRoom(playerid, hotel_id, room_id);
									}

							}
				case PICKUP_ACTION_TYPE_ORG_CAR:
	            {
	                printf("%d != %d", GetPlayerData(playerid, P_TEAM), g_org_car[action_id][O_FRAC_ID]);
	                if(GetPlayerData(playerid, P_TEAM) != g_org_car[action_id][O_FRAC_ID])
	                	return SendClientMessage(playerid, -1, ""USC" Вам не доступен данный раздел!");

	                new fraction_vehicleid = GetPlayerData(playerid, P_FRACTION_CAR);
	                if(fraction_vehicleid != INVALID_VEHICLE_ID)
	                {
	                    if(!IsValidVehicle(fraction_vehicleid) ||
	                        GetVehicleData(fraction_vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_ORG_CAR ||
	                        GetVehicleData(fraction_vehicleid, V_ACTION_OWNER) != playerid)
	                    {
	                        SetPlayerData(playerid, P_FRACTION_CAR, INVALID_VEHICLE_ID);
	                        fraction_vehicleid = INVALID_VEHICLE_ID;
	                    }
	                }

	                if(fraction_vehicleid == INVALID_VEHICLE_ID)
	                {
	                    stringer[0] = EOS, sctring [0] = EOS;

	                    for(new i = 0; i < 4; i++)
	                    {
	                        if(g_org_car[action_id][O_MODEL][i] == 0) continue;

	                        format(sctring , sizeof(sctring), "{FFFFFF}[%d]\t%s\t\t[%d]\n",i+1, g_vehicle_info[g_org_car[action_id][O_MODEL][i]-400][VI_NAME], g_org_car[action_id][O_MODEL][i]);
	                        strcat(stringer, sctring );
	                    }
	                    SetPlayerListitemValue(playerid, 0, action_id);
	                    Dialog(playerid, DIALOG_ORG_CAR_GET, DIALOG_STYLE_LIST, g_org_car[action_id][O_NAME], stringer, "Выбрать", "Отмена");
	                }
					else
	                SendClientMessage(playerid, -1, ""USC"Вы уже взяли транспорт, для отмены прошлого транспорта введите {FFFF00}/unfcar");

	                return 1;
	            }
				case PICKUP_ACTION_TYPE_MAYOR_JOB:
				{
					if(IsPlayerInJob(playerid) || GetPlayerTempJob(playerid) != TEMP_JOB_NONE)
						return SendClientMessage(playerid, 0xCECECEFF, ""USC"В данный момент Вы не можете устроиться на работу");

					Dialog
					(
						playerid, DIALOG_VIEV_JOBS_LIST, DIALOG_STYLE_MSGBOX,
						"{FFCD00}Прием на работу",
						"{FFFFFF}Вы хотите просмотреть список доступных работ?",
						"Да", "Нет"
					);
				}
				case PICKUP_ACTION_HELP_SPAWN:
				{
				    callcmd::help(playerid, "");
				}
case PICKUP_ACTION_RENT_BIKE:
{
    SetPVarInt(playerid, "rent_zone_id", action_id);
    return ShowRentBikeDialog(playerid, 0);
}

            case PICKUP_ACTION_QUEST_MENU:
				{
			    	ShowPlayerQuestMenu(playerid);
				}
				case PICKUP_ACTION_TYPE_PUT_PROD:
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
					{
						if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_PUT_PROD)
						{
							new objectid;
							new items = GetPlayerJobLoadItems(playerid);
							new Float: x, Float: y, Float: z, Float: angle;

							ApplyAnimationEx(playerid, "CARRY", "PUTDWN", 4.0, 0, 0, 0, 0, 0, 1, USE_ANIM_TYPE_NONE);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);

							TogglePlayerFactoryCP(playerid, true);
							SetPlayerJobLoadItems(playerid, items + 1);

							AddPlayerData(playerid, P_JOB_WAGE, +, 1);
							SendClientMessage(playerid, 0x00FF00FF, "* {8FC0FF}Вы положили продукт на склад.");

							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);

							GetPlayerPos(playerid, x, y, z);
							GetPlayerFacingAngle(playerid, angle);

							//objectid = CreateDynamicObject(1279, x, -200.81883, 1006.51978, 0.9, 0.0, angle);
						//	MoveDynamicObject(objectid, 263.8, -200.81880, 1006.51978, 2.0, 0.9, 0.0, angle);

							Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, OBJECT_TYPE_FACTORY);

							GameTextForPlayer(playerid,"~y~+1 skill",5200,5);

							AddPlayerData(playerid, P_LOADER_SKILL, +, 1);

							UpdatePlayerDatabaseInt(playerid, "loader_skill", GetPlayerData(playerid, P_LOADER_SKILL));

			                new type = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT);

							SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD, R_AMOUNT, type + 1);
							UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_PROD);
						}
					}
				}
	   			case PICKUP_ACTION_TYPE_TEMP_ARMY:
	   			{
	   			    SetPVarInt(playerid, "player_in_ammo_cp", 1);
	   			}
				case PICKUP_ACTION_TYPE_TEMP_JOB:
				{
					new job = GetPlayerTempJob(playerid);
					if(job != action_id && IsPlayerInJob(playerid) || GetPlayerSpecialAction(playerid) != SPECIAL_ACTION_NONE)
					{
						job = TEMP_JOB_NONE - 1;
					}

					switch(action_id)
					{
						case TEMP_JOB_LOADER:
						{
							if(job == TEMP_JOB_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_LOADER_START, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа грузчика",
									"{FFFFFF}Вы хотите устроиться на работу грузчиком?",
									"Да", "Нет"
								);
							}
					else if(job == action_id)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_LOADER_END, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа грузчика",
									"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
									"Да", "Нет"
								);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "Чтобы устроиться сюда закончите текущую работу");
						}
						case TEMP_JOB_MINER:
						{
							if(job == TEMP_JOB_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_MINER_START, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа шахтера",
									"{FFFFFF}Вы хотите устроиться на работу шахтера?",
									"Да", "Нет"
								);
							}
					else if(job == action_id)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_MINER_END, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа шахтера",
									"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
									"Да", "Нет"
								);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "В данный момент устроиться на эту работу нельзя");
						}
						case TEMP_JOB_FACTORY_TRUCKER:
						{
							if(job == TEMP_JOB_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_FACTORY_TRUCKER, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Завод",
									"{FFFFFF}Вы хотите начать работу в отделе доставки исходных материалов?",
									"Да", "Нет"
								);
							}
					else if(job == action_id)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_FACTORY_TRUCKER, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Завод",
									"{FFFFFF}Закончить работу в отделе доставки исходных материалов?",
									"Да", "Нет"
								);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "В данный момент устроиться на эту работу нельзя");
						}
						case TEMP_JOB_FACTORY:
						{
							if(job == TEMP_JOB_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_FACTORY, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Завод",
									"{FFFFFF}Вы хотите начать работу в производственном цеху?",
									"Да", "Нет"
								);
							}
					else if(job == action_id)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_FACTORY, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Завод",
									"{FFFFFF}Закончить работу в производственном цеху?",
									"Да", "Нет"
								);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "В данный момент устроиться на эту работу нельзя");
						}
						case TEMP_JOB_LUMBERJACK:
						{
							if(job == TEMP_JOB_NONE)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_LUMBERJACK_ST, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа лесоруба",
									"{FFFFFF}Вы хотите устроиться на работу лесоруба?",
									"Да", "Нет"
								);
							}
					else if(job == action_id)
							{
								Dialog
								(
									playerid, DIALOG_TEMP_JOB_LUMBERJACK_END, DIALOG_STYLE_MSGBOX,
									"{FFCD00}Работа лесоруба",
									"{FFFFFF}Вы уверены что хотите завершить рабочий день?",
									"Да", "Нет"
								);
							}
					else SendClientMessage(playerid, 0xCECECEFF, "В данный момент устроиться на эту работу нельзя");
						}
					}
				}

				case PICKUP_ACTION_TYPE_GIFT:
				{
					if(GetPlayerData(playerid, P_LEVEL) > 3)
					{
						new query[256],
							Cache: result,
							rows;

						mysql_format(mysql, query, sizeof query, "SELECT * FROM gift_lose WHERE uid='%d' AND gift_id='%d'", GetPlayerAccountID(playerid), action_id+1);
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows(result);

						if(rows)
						{
							SendClientMessage(playerid, 0xCECECEFF, "Вы уже собрали этот подарок!");
							cache_delete(result);
							return 1;
						}

						cache_delete(result);

						mysql_format(mysql, query, sizeof query, "INSERT INTO gift_lose (uid, gift_id) VALUES (%d, %d)", GetPlayerAccountID(playerid), action_id+1);
						mysql_query(mysql, query, false);

						new fmt_str[144];

						mysql_format(mysql, query, sizeof query, "SELECT * FROM gift_lose WHERE uid='%d'", GetPlayerAccountID(playerid));
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows(result);


						AddPlayerData(playerid, P_GIFTS, +, 1);

						format(fmt_str, sizeof fmt_str, "Вы собрали подарок! У Вас всего %d шт. подарков!", GetPlayerData(playerid, P_GIFTS));

						SendClientMessage(playerid, 0xffff00FF, fmt_str);

						format(fmt_str, sizeof fmt_str, "Всего собрано %d подарков!", GetPlayerData(playerid, P_GIFTS));

						SendClientMessage(playerid, 0xffff00FF, fmt_str);

	                    SendClientMessage(playerid, 0xffff00FF, "Подарки можно обменять в правительстве!");

	                    format(query, sizeof query, "{D6325B}[Подарки]: {FFFFFF}%s[%d] собрал подарок.", GetPlayerNameEx(playerid), playerid, GetPlayerData(playerid, P_GIFTS), g_gift_loaded);
	                    SendClientMessageToAll(-1, query);

						cache_delete(result);


						format(query, sizeof query, "UPDATE accounts SET gifts=%d WHERE id=%d", GetPlayerData(playerid, P_GIFTS), GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Собирать подарки можно с 3-х лет проживания в штате");
				}
				case PICKUP_ACTION_TYPE_SELL_GIFT:
				{
					if(!GetPlayerData(playerid, P_GIFTS)) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет подарков!");

					Dialog(playerid, DIALOG_SELL_GIFT, DIALOG_STYLE_MSGBOX, "Обмен", "{FFFFFF}Вы действительно хотите обменять один подарок?\n\n\
					Вам может выпасть:\n\
					{1E90FF}- Донат\n\
					{1E90FF}- Донат-Рубли\n\
					{32a44b}- Деньги\n\
					{3399FF}- Патроны\n\
					{32a44b}- Материалы\n\
					{CECECE}- Наркотики", "Да", "Нет");
				}
				case PICKUP_ACTION_TYPE_MINER_SELL_M:
				{
					ShowPlayerBuyMetalDialog(playerid);
				}
				case PICKUP_ACTION_TYPE_FACTORY_MET:
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
					{
						new j_state = GetPlayerTempJobState(playerid);
						switch(j_state)
						{
							case TEMP_JOB_STATE_FACTORY_TAKE_MET:
							{
								new factory_metal = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT);
								new factory_fuel = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);

								new take_metall = random(2) + 1;
								if(factory_metal > take_metall && factory_fuel > (take_metall * 6))
								{
									SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL, R_AMOUNT, factory_metal - take_metall);
									UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_METAL);

									new fmt_str[16];
									SetPVarInt(playerid, "factory_take_metall", take_metall);

									format(fmt_str, sizeof fmt_str, "~b~~h~+%d kg", take_metall);
									GameTextForPlayer(playerid, fmt_str, 4000, 1);

									SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_CREATE_P);
								}
					else GameTextForPlayer(playerid, "~r~no fuel or metal", 4000, 1);
							}
							case TEMP_JOB_STATE_FACTORY_CREATE_P:
							{
								SendClientMessage(playerid, 0x999999FF, "Вы уже взяли Материалы");
							}
						}
					}
				}
				case PICKUP_ACTION_TYPE_P_CREATE:
				{
					// The pickup action stores the desk index, not a streamer CP id.
					if(action_id >= 0 && action_id < sizeof factory_put_metall_pos)
						SetPlayerFactoryDeskUse(playerid, action_id, true);
				}
				case PICKUP_ACTION_TYPE_LUMBERJACK_P:
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_LUMBERJACK)
					{
						if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_LUMBERJACK_PUT)
						{
							new desk;

							SetPlayerTempJobState(playerid, TEMP_JOB_STATE_LUMBERJACK_CHOP);
							ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.1, 1, 0, 1, 0, 800, 0);

							RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
							//SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 326, A_OBJECT_BONE_RIGHT_HAND, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0);

							SetPlayerJobLoadItems(playerid, GetPlayerJobLoadItems(playerid) + 1);

							new fmt_text[65];

							format(fmt_text, sizeof fmt_text, "Дрова доставлены на склад! Всего перенесено дров: {FF9900}%d шт", GetPlayerJobLoadItems(playerid));
							SendClientMessage(playerid, 0x66CC00FF, fmt_text);

							SetPlayerLumberJackChopCP(playerid);

							desk = GetPickupInfo(pickupid, P_ACTION_ID);

							//new objectid;
							if(!desk)
							{
							//	objectid = CreateDynamicObject(1463, 2378.1465, -603.0632, 12.0885, 0.0, 0.0, 90.0);
							//	MoveDynamicObject(objectid, 2382.3528, -603.0815, 12.0885, 2.0, 0.0, 0.0, 0.0);
							}
					else
							{
							//	objectid = CreateDynamicObject(1463, 2378.1465, -606.80481, 12.0885, 0.0, 0.0, 90.0);
							//	MoveDynamicObject(objectid, 2382.3528, -606.80481, 12.0885, 2.0, 0.0, 0.0, 0.0);
							}

						//	Streamer_SetIntData(STREAMER_TYPE_OBJECT, objectid, E_STREAMER_EXTRA_ID, OBJECT_TYPE_WOOD);
						}
					}
				}
				case PICKUP_ACTION_TYPE_FUEL_STATION:
				{
					ShowPlayerBuyJerricanDialog(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_BIZ_ENTER:
				{
				    SetPlayerInBiz(playerid, -1);
				    
					if(GetPlayerInBiz(playerid) == -1)
					{
						if(IsBusinessNoEnter(action_id))
							return SendClientMessage(playerid, 0xCECECEFF, "В данный тип бизнеса нельзя войти");

						if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_CLOTHING_SHOP)
						{
							SetPlayerInBiz(playerid, action_id);
							
							ShowPlayerClothingShopPanel(playerid);
							
							return 1;
						}

						if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_ACCESSORY_SHOP)
						{
							SetPlayerInBiz(playerid, action_id);
							
							EntryAccessoryMarket(playerid);
							
							return 1;
						}

						if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_CAR_MARKET)
						{
							SetPlayerListitemValue(playerid, 0, action_id);
							return EnterPlayerBuyCarMarket(playerid, action_id);
						}


						new i_paid_biz = GetPlayerUseListitem(playerid);

						if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_CAR_TUNING)
						{
							new oc_id = GetPlayerOwnableCar(playerid);

							if(oc_id == INVALID_VEHICLE_ID)
							{
								if(GetPlayerOwnableCars(playerid) == 0)
									SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
								else
									SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");

								return 1;
							}
					else
							{
								new Float: veh_x,
									Float: veh_y,
									Float: veh_z;

								GetVehiclePos(oc_id, veh_x, veh_y, veh_z);

								if(!IsPlayerInRangeOfPoint(playerid, 15.0, veh_x, veh_y, veh_z))
								{
									SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт слишком далеко от Вас");

									return 1;
								}
							}
						}

						if(IsBusinessOwned(action_id))
						{
							if(GetBusinessData(action_id, B_OWNER_ID) != GetPlayerAccountID(playerid))
							{
								if(GetBusinessData(action_id, B_LOCK_STATUS))
									return GameTextForPlayer(playerid, "~w~business~n~~r~closed", 4000, 1);

								if(GetBusinessData(action_id, B_ENTER_PRICE) > 0 && i_paid_biz != action_id)
								{
									new fmt_str[128];
									SetPVarInt(playerid, "biz_enter", action_id + 1);

									format
									(
										fmt_str, sizeof fmt_str,
										"{FFFFFF}Вход платный и составляет {FF9900}%d руб\n"\
										"{99FF00}Вы уверены что хотите войти сюда?",
										GetBusinessData(action_id, B_ENTER_PRICE)
									);
									return Dialog(playerid, DIALOG_BIZ_ENTER, DIALOG_STYLE_MSGBOX, GetBusinessData(action_id, B_NAME), fmt_str, "Да", "Нет");
								}
							}
						}
						
						EnterPlayerToBiz(playerid, action_id);
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_EXIT:
				{
					new in_biz = GetPlayerInBiz(playerid);
					if(in_biz == -1 && action_id == BUSINESS_INTERIOR_CASINO)
					{
						SetPlayerPosEx
						(
							playerid,
							1332.560546,
							2361.656738,
							17.712001,
							357.240692,
							0,
							0
						);
					}
					else if(in_biz != -1)
					{
						new type = GetBusinessData(in_biz, B_INTERIOR);
						if(action_id == type)
						{
							SetPlayerPosEx
							(
								playerid,
								GetBusinessData(in_biz, B_EXIT_POS_X),
								GetBusinessData(in_biz, B_EXIT_POS_Y),
								GetBusinessData(in_biz, B_EXIT_POS_Z),
								GetBusinessData(in_biz, B_EXIT_ANGLE),
								0,
								0
							);
							SetPlayerInBiz(playerid, -1);

							new type_2 = GetBusinessData(in_biz, B_TYPE);
							
							if(type_2 == BUSINESS_TYPE_CAR_TUNING)
							{
								new vehicleid = GetPlayerOwnableCar(playerid);

								SetVehiclePos(vehicleid, vehicle_temp_position[playerid][0], vehicle_temp_position[playerid][1], vehicle_temp_position[playerid][2]);
								SetVehicleZAngle(vehicleid, vehicle_temp_position[playerid][3]);

								LinkVehicleToInterior(vehicleid, 0);
								SetVehicleVirtualWorld(vehicleid, 0);
				LinkVehicleToInterior(vehicleid, 0);
							}
						}
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_HEALTH:
				{
					new businessid = GetPlayerInBiz(playerid);
					if(businessid != -1)
					{
						if(businessid == action_id)
						{
							new time = gettime();
							if(GetPVarInt(playerid, "biz_health_use") <= time)
							{
								new price = BIZ_HEALTH_SERVICE_PRICE;
								if(GetPlayerMoneyEx(playerid) >= price)
								{
									new query[255];

									format(query, sizeof query, "UPDATE accounts a,business b SET a.money=%d,b.products=10000,b.balance=%d WHERE a.id=%d AND b.id=%d", GetPlayerMoneyEx(playerid)-price, 10_000, GetBusinessData(businessid, B_PRODS) > 0 ? GetBusinessData(businessid, B_BALANCE)+price : 0, GetPlayerAccountID(playerid), GetBusinessData(businessid, B_SQL_ID));
									mysql_query(mysql, query, false);

									if(!mysql_errno())
									{
										GivePlayerMoneyEx(playerid, -price, "Использование аптечки в бизнесе", false, true);

										if(GetBusinessData(businessid, B_PRODS) >= 1)
										{
											SetBusinessData(businessid, B_PRODS, 10_000);
											AddBusinessData(businessid, B_BALANCE, +, price/2);
										}
										SetPlayerHealthEx(playerid, 99.0);
										SetPVarInt(playerid, "biz_health_use", time + 300); // 300 сек (5 минут)

										mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), time, price, IsBusinessOwned(businessid));
										mysql_query(mysql, query, false);
									}
					else SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения, повторите попытку {FF0000}(equ-code 24)");
								}
					else SendClientMessage(playerid, 0x999999FF, "Услуги медпункта стоят 150 рублей");
							}
					else SendClientMessage(playerid, 0x999999FF, "Недавно Вы уже пользовались услугами медпункта");

							// SetPlayerHealthEx(playerid, 95.0);
						}
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_SHOP_247:
				{
					new businessid = GetPlayerInBiz(playerid);
					if(businessid != -1)
					{
						new type = GetBusinessData(businessid, B_TYPE);
						if(type == BUSINESS_TYPE_SHOP_24_7)
						{
							callcmd::buy(playerid, "");
						}
					}
				}
				case PICKUP_ACTION_TYPE_CELL_SALON:
				{
					new businessid = GetPlayerInBiz(playerid);
					
					if(businessid != -1)
					{
						new type = GetBusinessData(businessid, B_TYPE);
						if(type == BUSINESS_TYPE_CELL_SALON)
						{
							callcmd::buy(playerid, "");
						}
					}
				}
				case PICKUP_ACTION_TYPE_HOUSE_LIFT:
				{
					ShowPlayerLiftInfo(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_FLAT_EXIT:{
					HandleExitPlayerFlatNewPickup(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_HOUSE:
				{
					ShowPlayerHouseInfo(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_HOUSE_NEW:
				{
					HandlePlayerHouseNewPickup(playerid, action_id);
				}
				
				case PICKUP_ACTION_TYPE_HOUSE_NEWS:
				{
					HandlePlayerHouseNewPickupb(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_HOUSE_MED:
				{
					SetPlayerHealthEx(playerid, 100.0);
				}
				case PICKUP_ACTION_TYPE_EXIT_HOME:
				{
					HandleExitPlayerHouseNewPickup(playerid, action_id);
					return 1;
				}
			    case PICKUP_ACTION_TYPE_EXIT_BASEMENT:
				{
					HandleExitPlayerBasement(playerid, action_id);
					return 1;
				}
				case PICKUP_ACTION_TYPE_HOUSE_HEALTH:
				{
					new houseid = GetPlayerInHouse(playerid);
					if(houseid != -1)
					{
						new type = GetHouseData(houseid, H_TYPE);

						if(IsPlayerInRangeOfPoint(playerid, 4.0, GetHouseTypeInfo(type, HT_HEALTH_POS_X), GetHouseTypeInfo(type, HT_HEALTH_POS_Y), GetHouseTypeInfo(type, HT_HEALTH_POS_Z)))
						{
							SetPlayerHealthEx(playerid, 100.0);
							GameTextForPlayer(playerid, "~b~~h~100 hp", 3000, 1);
						}
					}
				}
				case PICKUP_ACTION_TYPE_REALTOR_HOME:
				{
					new businessid = GetPlayerInBiz(playerid);
					if(businessid != -1)
					{
						new type = GetBusinessData(businessid, B_TYPE);
						if(type == BUSINESS_TYPE_REALTOR_HOME)
						{
							Dialog
							(
								playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX,
								"{99CC00}Номера свободных домов",
								g_house_realtor_list,
								"Закрыть", ""
							);
						}
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_CLOTHING:
				{
					new businessid = GetPlayerInBiz(playerid);
					if(businessid != -1)
					{
						new type = GetBusinessData(businessid, B_TYPE);
						if(type == BUSINESS_TYPE_CLOTHING_SHOP)
						{
							ShowPlayerClothingShopPanel(playerid);
						}
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_CAR_MARK:
				{
					/*Dialog
					(
						playerid, DIALOG_BIZ_CAR_MARKET, DIALOG_STYLE_MSGBOX,
						"{FFCC00}Покупка транспорта",
						"{FFFFFF}На территории авторынка могут находиться не все модели транспорта, которые\n\
						можно приобрести (некоторые отсутствуют из-за того, что их взяли на прокат)\n\
						Нажмите кнопку \"Далее\" чтобы посмотреть весь доступный для покупки транспорт",
						"Далее", "Отмена"
					);*/
					
					return EnterPlayerBuyCarMarket(playerid, GetPlayerListitemValue(playerid, 0));
				}
				case PICKUP_ACTION_TYPE_ENTRANCE_ENT:
				{
					EnterPlayerToEntrance(playerid, action_id);
				}
				case PICKUP_ACTION_TYPE_ENTRANCE_EXI:
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						if(GetPlayerInEntranceFloor(playerid) == 0)
						{
							SetPlayerPosEx
							(
								playerid,
								GetEntranceData(entranceid, E_EXIT_POS_X),
								GetEntranceData(entranceid, E_EXIT_POS_Y),
								GetEntranceData(entranceid, E_EXIT_POS_Z),
								GetEntranceData(entranceid, E_EXIT_ANGLE),
								0,
								0
							);

							SetPlayerInEntrance(playerid, -1);
							SetPlayerInEntranceFloor(playerid, -1);
						}
					else
							SendClientMessage(playerid, -1, "Выход работает только на этаже 'Подъезд'!");
					}
				}
				case PICKUP_ACTION_TYPE_ENTRANCE_LIF:
				{
					new entranceid = GetPlayerInEntrance(playerid);
					if(entranceid != -1)
					{
						new floor = GetPlayerInEntranceFloor(playerid);
						if(floor != -1)
						{
							ShowPlayerEntranceFloorsLift(playerid, entranceid, floor);
						}
					}
				}
				case PICKUP_ACTION_TYPE_BIZ_CAR_ENT:
				{
					SetPlayerPosEx(playerid, 5.4881, -27.7033, 1085.9291, 180.0, _, _, false);
					SetCameraBehindPlayer(playerid);
				}
				case PICKUP_ACTION_TYPE_BIZ_CAR_EXI:
				{
					SetPlayerPosEx(playerid, 5.4975, -26.3967, 1080.9968, 180.0, _, _, false);
					SetCameraBehindPlayer(playerid);
				}
				case PICKUP_ACTION_TYPE_GET_CAR_NUM:
{
    new JSON:json = JSON_Object();
    DeletePVar(playerid, PVAR_PLATE_BUY_ACCESS);
    DeletePVar(playerid, PVAR_PLATE_BC_PRICE);
    ClearPlateDraftCache(playerid);
    gPlayerCountry[playerid] = -1;
    PlateDraft_EnsureLoaded(playerid);
    JSON_SetInt(json, "t", 0); // тип пакета = выбор страны
    ShowPlayerGUI(playerid, 1, json);
    ~json;

    printf("[PICKUP] Player %d открыл GUI выбора номеров", playerid);
}
                case PICKUP_ACTION_TYPE_MINER_CARRI:
				{
					if(GetPlayerTempJob(playerid) == TEMP_JOB_MINER
					&& GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_MINER_UNLOAD)
					{
						if(!miner_carriage[0][MC_STATUS])
						{
							new fmt_str[64];

							new rand = random(45) + 16;
							new items = GetPlayerJobLoadItems(playerid) + rand;

							RemovePlayerAttachedObjects(playerid);
						//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18634, A_OBJECT_BONE_RIGHT_HAND, 0.07, 0.02, 0.04, 0.0, 270.0, 270.0, 1.5, 2.1, 1.8, 0);

							ApplyAnimationEx(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);
							SetPlayerJobLoadItems(playerid, items);

							format(fmt_str, sizeof fmt_str, "Вы доставили в вагонетку {FF9900}%d кг {66CC00}руды", rand);
							SendClientMessage(playerid, 0x66CC00FF, fmt_str);

							format(fmt_str, sizeof fmt_str, "Общее количество добытого сырья: {FF9900}%d кг", items);
							SendClientMessage(playerid, 0x3399FFFF, fmt_str);

							format(fmt_str, sizeof fmt_str, "+ %d кг", rand);
							SetPlayerChatBubble(playerid, fmt_str, 0x66CC00FF, 10.0, 2000);

							miner_carriage[0][MC_ORE_COUNT] += rand;

							if(miner_carriage[0][MC_ORE_COUNT] >= 10000)
							{
								DestroyPickup(miner_carriage[0][MC_PICKUP_ID]);
								miner_carriage[0][MC_PICKUP_ID] = -1;

								SetTimerEx("MinerCarriageMove", 7_000, false, "i", 0);

								UpdateDynamic3DTextLabelText(miner_carriage[0][MC_LABEL], 0xFFFF00FF, "Ожидание...");
							}
					else
							{
								format(fmt_str, sizeof fmt_str, "Загрузка\n\n{FFCC00}Количество руды\n%d / 10000 кг", miner_carriage[0][MC_ORE_COUNT]);
								UpdateDynamic3DTextLabelText(miner_carriage[0][MC_LABEL], 0x66CC00FF, fmt_str);
							}

							SetPlayerMinerJobLoadCP(playerid);
						}
					}
				}
				case PICKUP_ACTION_TYPE_MPREG:
				{
					Dialog
						(
							playerid, DIALOG_MPREG, DIALOG_STYLE_LIST,
							"{FFCD00}Регистрация на мероприятия",
							""c_s"[1] "c_b"DeathMatch Zone",
							"Выбрать", "Отмена"
						);
				}
				case PICKUP_ACTION_TYPE_GANG_REPOSIT:
				{
					if(GetPlayerTeamEx(playerid) != (action_id + TEAM_OPG_ARZAMASKAYA - 1))
						return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этому складу");

					Dialog
					(
						playerid, DIALOG_GANG_REPOSITORY, DIALOG_STYLE_LIST,
						"{FFCD00}Склад банды",
						"\
						{00CC00}1. Положить наркотики\n\
						{00CC00}2. Положить Патроны\n\
						{00CC00}3. Положить Материалы\n\
						{00CC00}4. Положить деньги\n\
						5. Взять наркотики\n\
						6. Взять Патроны\n\
						7. Взять Материалы\n\
						8. Взять деньги\n\
						",
						"Выбрать", "Отмена"
					);
				}
				case PICKUP_ACTION_TYPE_ARMORY:
				{
					switch(action_id)
					{
						case ARMORY_TYPE_ARMOR:
						{
							if(GetPlayerTeamEx(playerid) != TEAM_ARMY)
								return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этому");

							new Float: armour;

							GetPlayerArmour(playerid, armour);

							if(armour > 20.0)
								return SendClientMessage(playerid, 0x999999FF, "У Вас уже есть бронежилет");

							SetPlayerArmour(playerid, 100.0);
						}
						case ARMORY_TYPE_SECURITY:
						{
							if(GetPlayerTeamEx(playerid) != TEAM_GOVERNMENT)
								return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этому");

							if(!(1 <= GetPlayerJob(playerid) <= 3))
								return SendClientMessage(playerid, 0x999999FF, "Оружейный склад доступен только сотрудникам службы охраны");

							Dialog
							(
								playerid, DIALOG_ARMORY, DIALOG_STYLE_LIST,
								"{FFCD00}Оружейный склад",
								"1. Взять дубинку\n"\
								"2. Взять маску\n"\
								"3. Взять бронежилет\n"\
								"4. Взять пистолет с глушителем\n"\
								"5. Взять Desert Eagle\n"\
								"6. Взять MP5\n"\
								"7. Взять дробовик",
								"Взять", "Отмена"
							);
						}
						case ARMORY_TYPE_POLICE:
						{
							new armory_index;

							switch(GetPlayerVirtualWorld(playerid))
							{
								case 5: armory_index = 0;
								case 6: armory_index = 1;
								case 17: armory_index = 2;
							}

							if(GetPlayerTeamEx(playerid) != (TEAM_DPS + armory_index))
								return SendClientMessage(playerid, 0x999999FF, "У Вас нет доступа к этому");

							Dialog
							(
								playerid, DIALOG_ARMORY, DIALOG_STYLE_LIST,
								"{FFCD00}Оружейный склад",
								"1. Взять дубинку\n"\
								"2. Взять маску\n"\
								"3. Взять бронежилет\n"\
								"4. Взять пистолет с глушителем\n"\
								"5. Взять Desert Eagle\n"\
								"6. Взять MP5\n"\
								"7. Взять дробовик\n"\
								"8. Взять AK47\n"\
								"9. Взять винтовку",
								"Взять", "Отмена"
							);
						}
					}
				}
                case PICKUP_ACTION_TYPE_BIZ_SHOP_GUN:
                {
                    return 1;
                }
				case PICKUP_ACTION_TYPE_BIZ_CAR_TUN:
				{
				    if(GetPlayerOwnableCars(playerid) == 0)
						SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
					///else
						//SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
									
				    new businessid = GetPlayerInBiz(playerid);
				    if(businessid != -1)
					{
						if(IsPlayerInBuyPosBiz(playerid, businessid, BUSINESS_TYPE_CAR_TUNING))
						{
						    SetPlayerPos(playerid, 2482.655517,1488.368652,1498.179687);
							Dialog
							(
								playerid, DIALOG_BIZ_CAR_TUNING, DIALOG_STYLE_LIST,
								"{ffff00}Тюнинг транспорта",
								"1. Починить транспорта\t{ffff00}25.000 руб\n"\
								"2. Прокачка комплектующих\n"\
								"3. Покраска транспорта\t{ffff00}5.000 руб\n"\
								"4. Установить цвет фар\t{ffff00}10.000 руб\n"\
								"5. Большие шины и диски\t{ffff00}2.000 руб\n"\
								"5. Установка подцветки автомобиля\t{ffff00}2.000 руб",
								"Выбрать", "Отмена"
							);
						}
					}
				}
			}
		}
	}
	return 1;
}

