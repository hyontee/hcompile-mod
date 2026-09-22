//>> Файл: bykranin_src/core/inventory/inventory_03.inc  (267 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: AddBan, GivePlayerDrinkItem, FactoryPlayerDrop, ShowPlayerClothingShopPanel, ExitPlayerClothingShopPanel, BuySkinPTDUpdate, HidePlayerSelectPanelPrice
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock AddBan(user_id, time, days, ip[], description[], admin_name[])
{
	new query[512];
	new c_time = time-(time % 86400);
	new unban_time = c_time + (days * 86400);
	new bool:ok = true;

	mysql_format(mysql, query, sizeof query, "INSERT INTO ban_list (user_id,time,ban_time,ip,description,admin) VALUES (%d,%d,%d,'%e','%e','%e')", user_id, c_time, unban_time, ip, description, admin_name);
	mysql_query(mysql, query, false);

	if(mysql_errno())
	{
		ok = false;
		printf("[BAN][ERROR] ban_list insert failed: uid=%d errno=%d query=%s", user_id, mysql_errno(), query);
	}

	if(user_id > 0)
	{
		mysql_format(mysql, query, sizeof query,
			"INSERT INTO listban (acc_id, player_name, admin_name, reason, ban_time, unban_time) VALUES (%d, IFNULL((SELECT name FROM accounts WHERE id=%d LIMIT 1), 'Unknown'), '%e', '%e', %d, %d) ON DUPLICATE KEY UPDATE player_name = VALUES(player_name), admin_name = VALUES(admin_name), reason = VALUES(reason), ban_time = VALUES(ban_time), unban_time = VALUES(unban_time)",
			user_id, user_id, admin_name, description, c_time, unban_time
		);
		mysql_query(mysql, query, false);

		if(mysql_errno())
		{
			ok = false;
			printf("[BAN][ERROR] listban insert failed: uid=%d errno=%d query=%s", user_id, mysql_errno(), query);
		}
	}

	return ok;
}

stock GivePlayerDrinkItem(playerid, itemid)
{
	new action_id = -1;
	switch(itemid+1)
	{
		case 1: // Лимонад
		{
			action_id = 23;
		}
		case 2, 6..7: // Пиво, Коньяк, Виски
		{
			action_id = 20;
		}
		case 3..5, 8: // Вино, Шампанское, Водка, Абсент
		{
			action_id = 22;
		}
		case 9: // Закуска
		{
			if(GetPlayerData(playerid, P_DRINK_STEP))
			{
				SetPlayerData(playerid, P_DRINK_STEP, 0);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			}

		//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 10213, A_OBJECT_BONE_RIGHT_HAND, 0.08, 0.05, 0.06, 180.0, 270.0, -30.0, 1.0, 1.0, 1.0, 0, 0);
			SetPlayerData(playerid, P_SNACK, true);
		}
		case 10: // Сигара
		{
			action_id = 21;
		}
	}
	if(action_id != -1)
	{
		if(GetPlayerData(playerid, P_SNACK))
		{
			SetPlayerData(playerid, P_SNACK, false);
		//	T_RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND);
		}

		SetPlayerData(playerid, P_DRINK_STEP, 7);
		SetPlayerSpecialAction(playerid, action_id);
	}
	return 1;
}

stock FactoryPlayerDrop(playerid, bool: reject = true)
{
	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(reject)
		{
			if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_CREATED) return ;

			SetPlayerChatBubble(playerid, "Брак", 0xFF0000FF, 10.0, 1500);
			ApplyAnimationEx(playerid, "OTB", "WTCHRACE_LOSE", 4.1, 0, 0, 0, 0, 0, 0, USE_ANIM_TYPE_NONE);
		}
					else
		{
			if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_DROP_P) return ;
			SetPlayerTempJobCheckAnim(playerid, false);

			//RemovePlayerAttachedObject(playerid, A_OBJECT_SLOT_FOREARM);
			SetPlayerFactoryDeskUse(playerid, GetPlayerData(playerid, P_FACTORY_USE_DESK), false);

			ApplyAnimationEx(playerid, "CARRY", "crry_prtial", 4.1, 0, 0, 0, 0, 1, 0, USE_ANIM_TYPE_NONE);
		}

		new bad_prods = GetPVarInt(playerid, "factory_bad_prods") + 1;
		SetPVarInt(playerid, "factory_bad_prods", bad_prods);

		SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_TAKE_MET);
	}
}

stock ShowPlayerClothingShopPanel(playerid)
{
	new businessid = GetPlayerInBiz(playerid);

	if(businessid == -1)
		return 0;

	    //new fmt_str[50];
	    //new price = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][1];
	    
	if(GetPlayerTeamEx(playerid) <= 0)
	{
	    
		new select_skin = GetPlayerSelectSkin(playerid);
		
		if(select_skin == -1)
		{
			new type = GetBusinessData(businessid, B_INTERIOR);
			new interior = GetBusinessInteriorInfo(type, BT_ENTER_INTERIOR);
			new
				Float: cam_x, Float: cam_y, Float: cam_z,
				Float: v_cam_x, Float: v_cam_y, Float: v_cam_z;

			GetPlayerCameraPos(playerid, cam_x, cam_y, cam_z);
			GetPlayerCameraFrontVector(playerid, v_cam_x, v_cam_y, v_cam_z);

			SetPlayerPosEx(playerid,498.6025, 23.4823, 1370.5823, 359.3968, interior, playerid + 32, false);

			SetPlayerCameraPos(playerid, 498.124511,27.611799,1371.237548);
			SetPlayerCameraLookAt(playerid, 498.699462,22.645408,1371.171142);
			
			CreateClothesShopTextDraws(playerid);
			
			SetPlayerSelectClothingSkin(playerid, 0);
			
			CallLocalFunction("BuySkinPTDUpdate", "i", playerid);
			
			TogglePlayerControllable(playerid, false);

		}
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы состоите в организации, купить новую внешность нельзя");
//	}
}

stock ExitPlayerClothingShopPanel(playerid)
{
	new in_biz = GetPlayerInBiz(playerid);
	if(in_biz != -1)
	{
		HidePlayerSelectPanel(playerid);

		SetPlayerSkinInit(playerid);
		SetCameraBehindPlayer(playerid);
		TogglePlayerControllable(playerid, true);

		//SetPlayerData(playerid, P_USE_SELECT_PANEL, SELECT_PANEL_TYPE_NONE);

		PlayerTextDrawSetString(playerid, price_select_TD[playerid][0], "exit...");
		SetTimerEx("HidePlayerSelectPanelPriceTimer", 1000, false, "i", playerid);

		SetPlayerData(playerid, P_SELECT_SKIN, -1);
		
		HideClothesShopTextDraws(playerid);

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

	}
}

public: BuySkinPTDUpdate(playerid)
{
    new select_skin = GetPlayerSelectSkin(playerid);
    
	new price = g_business_clothing_skins[GetPlayerSex(playerid)][select_skin][1];

	new fmt_str[50];
	
	PlayerTextDrawHide(playerid, shop_clothes_PTD[playerid][0]);
	
	PlayerTextDrawShow(playerid, shop_clothes_PTD[playerid][0]);

    format(fmt_str, sizeof fmt_str, "%d РУБ", price);
	PlayerTextDrawSetString(playerid, shop_clothes_PTD[playerid][0], fmt_str);
	
	return 1;
}

stock HidePlayerSelectPanelPrice(playerid)
{
	for(new idx; idx < sizeof price_select_TD[]; idx ++)
	{
		if(price_select_TD[playerid][idx] != PlayerText: -1)
		{
			PlayerTextDrawHide(playerid, price_select_TD[playerid][idx]);
			PlayerTextDrawDestroy(playerid, price_select_TD[playerid][idx]);

			price_select_TD[playerid][idx] = PlayerText: -1;
		}
	}
}

stock SetPlayerSelectClothingSkin(playerid, index = 0)
{
	new sex = GetPlayerSex(playerid);

	SetPlayerSelectSkin(playerid, index, g_business_clothing_skins[sex][index][0]);
}

/*stock CreateTeleportObjects(playerid)
{
	for(new idx; idx < 2; idx ++)
	{
		if(g_teleport_object[playerid][idx] == -1)
		{
			g_teleport_object[playerid][idx] = CreatePlayerObject(playerid, 3034, 0.0, 0.0, -2000.0, 0.0, 0.0, 0.0);
		}
	}
}

stock DestroyTeleportObjects(playerid)
{
	for(new idx; idx < 2; idx ++)
	{
		if(g_teleport_object[playerid][idx] != -1)
		{
			DestroyPlayerObject(playerid, g_teleport_object[playerid][idx]);
			g_teleport_object[playerid][idx] = -1;
		}
	}
}

stock PlayerTeleportInit(playerid, Float: x, Float: y, Float: z, Float: angle)
{
	new Float: dist = -0.862;
	angle += 90.0; //прибавление угла; можно и отнимать

	for(new idx = 2; idx --; )
	{
		SetPlayerObjectPos(playerid, g_teleport_object[playerid][idx], x + dist * -floatsin(angle, degrees), y + dist * floatcos(angle, degrees), z - 1.02);
		SetPlayerObjectRot(playerid, g_teleport_object[playerid][idx], 90.0, 90.0, angle - 90.0);

		dist = floatabs(dist);
	}
}*/

