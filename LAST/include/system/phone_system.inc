// Телефон / SIM: баланс в рублях (`sim_cards.balance`), звонки, SMS
#if defined _BR_PHONE_SYSTEM_INC_
	#endinput
#endif
#define _BR_PHONE_SYSTEM_INC_

#define PHONE_COLOR                   (0x33CC66FF)
#define PHONE_RUB_PER_MINUTE          (100)
#define PHONE_SMS_COST_RUB            (50)
#define PHONE_CALL_BILL_MS            (60000)
#define PHONE_PVAR_INCOMING           "PhoneIncoming"
#define PHONE_PVAR_OUTGOING           "PhoneOutgoing"
#define PHONE_PVAR_CALL_PEER          "PhoneCallPeer"
#define PHONE_PVAR_CALL_BILL_TIMER    "PhoneCallBillTmr"

#if !defined DIALOG_BR_PHONE_DIAL
	#define DIALOG_BR_PHONE_DIAL            (19560)
#endif
#if !defined DIALOG_BR_PHONE_BOOK
	#define DIALOG_BR_PHONE_BOOK            (19561)
#endif

#define PHONE_PVAR_BAL_LOAD_GEN       "PhoneBalLoadGen"

#define PHONE_DIAL_SVC_POLICE           (2)
#define PHONE_DIAL_SVC_MEDIC            (3)
#define PHONE_DIAL_SVC_MECHANIC         (90)
#define PHONE_DIAL_SVC_OPERATOR         (111)

new g_PhoneBalanceRub[MAX_PLAYERS];

forward Phone_OnBalanceLoaded(playerid, load_gen);
forward Phone_CallBillTick(playerid);
forward bool:Phone_IsCallActive(playerid);
forward bool:Phone_IsRinging(playerid);
forward bool:Phone_HasBalance(playerid, amount);
forward bool:Phone_AtmTopUp(playerid, sum);
forward bool:Phone_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);

stock Phone_SendMsg(playerid, const text[])
{
	new line[256];
	format(line, sizeof line, "{33CC66}[Телефон] {FFFFFF}%s", text);
	SendClientMessage(playerid, PHONE_COLOR, line);
}

stock Phone_EnsureTables()
{
	mysql_tquery(db_handle,
		"CREATE TABLE IF NOT EXISTS `sim_cards` (\
`number` INT NOT NULL,\
`balance` INT NOT NULL DEFAULT 0,\
`owner_id` INT NOT NULL DEFAULT 0,\
PRIMARY KEY (`number`),\
KEY `idx_sim_owner` (`owner_id`)\
) ENGINE=InnoDB DEFAULT CHARSET=cp1251", "", "");
	return 1;
}

stock Phone_OnGameModeInit()
{
	Phone_EnsureTables();
	return 1;
}

stock Phone_ClearCallState(playerid)
{
	Phone_StopCallBilling(playerid);
	if(GetPVarType(playerid, PHONE_PVAR_INCOMING) != PLAYER_VARTYPE_NONE)
		DeletePVar(playerid, PHONE_PVAR_INCOMING);
	if(GetPVarType(playerid, PHONE_PVAR_OUTGOING) != PLAYER_VARTYPE_NONE)
		DeletePVar(playerid, PHONE_PVAR_OUTGOING);
	if(GetPVarType(playerid, PHONE_PVAR_CALL_PEER) != PLAYER_VARTYPE_NONE)
		DeletePVar(playerid, PHONE_PVAR_CALL_PEER);
}

stock Phone_ResetPlayer(playerid)
{
	g_PhoneBalanceRub[playerid] = 0;
	Phone_ClearCallState(playerid);
}

stock Phone_OnPlayerConnect(playerid)
{
	Phone_ResetPlayer(playerid);
	return 1;
}

stock Phone_OnPlayerDisconnect(playerid)
{
	new peer = INVALID_PLAYER_ID;
	if(Phone_IsCallActive(playerid))
		peer = GetPVarInt(playerid, PHONE_PVAR_CALL_PEER);
	else if(GetPVarType(playerid, PHONE_PVAR_INCOMING) != PLAYER_VARTYPE_NONE)
		peer = GetPVarInt(playerid, PHONE_PVAR_INCOMING);
	else if(GetPVarType(playerid, PHONE_PVAR_OUTGOING) != PLAYER_VARTYPE_NONE)
		peer = GetPVarInt(playerid, PHONE_PVAR_OUTGOING);

	if(peer != INVALID_PLAYER_ID && IsPlayerConnected(peer))
	{
		if(GetPVarInt(peer, PHONE_PVAR_CALL_PEER) == playerid)
			Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
		else if(GetPVarInt(peer, PHONE_PVAR_INCOMING) == playerid)
			Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
		else if(GetPVarInt(peer, PHONE_PVAR_OUTGOING) == playerid)
			Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
		Phone_ClearCallState(peer);
	}
	Phone_SaveActiveBalance(playerid);
	Phone_ResetPlayer(playerid);
	return 1;
}

stock bool:Phone_IsCallActive(playerid)
{
	return (GetPVarType(playerid, PHONE_PVAR_CALL_PEER) != PLAYER_VARTYPE_NONE);
}

stock bool:Phone_IsRinging(playerid)
{
	return (GetPVarType(playerid, PHONE_PVAR_INCOMING) != PLAYER_VARTYPE_NONE ||
		GetPVarType(playerid, PHONE_PVAR_OUTGOING) != PLAYER_VARTYPE_NONE);
}

stock bool:Phone_IsPhoneBusy(playerid)
{
	return (Phone_IsCallActive(playerid) || Phone_IsRinging(playerid));
}

stock bool:Phone_CanUsePhone(playerid)
{
	if(Player[playerid][pID] <= 0) return false;
	if(!Player[playerid][pPhoneOwned]) return false;
	if(Player[playerid][pSimCard] <= 0) return false;
	return true;
}

// Не перезаписывает owner_id у чужой SIM (только свободная или уже ваша).
stock Phone_RegisterSim(simnumber, owner_id)
{
	if(simnumber <= 0 || owner_id <= 0) return 0;
	new q[256];
	mysql_format(db_handle, q, sizeof q,
		"INSERT INTO `sim_cards` (`number`,`balance`,`owner_id`) VALUES (%d,0,%d) \
ON DUPLICATE KEY UPDATE `owner_id`=IF(`owner_id`=0 OR `owner_id`=%d,%d,`owner_id`)",
		simnumber, owner_id, owner_id, owner_id);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

#if !defined ITEM_SIM_CARD
	#define ITEM_SIM_CARD (58)
#endif

forward SetPlayerSimCardSilent(playerid, simnumber);
forward RemoveInventorySim(playerid, slot);
forward IsPlayerOwnsSimNumber(playerid, simnumber);

stock Sim_FormatGlobalTakenCheckQuery(dest[], size, simnumber, except_uid)
{
	return mysql_format(db_handle, dest, size,
		"SELECT 1 FROM (SELECT `id` FROM `players` WHERE `sim_card`=%d AND `id`<>%d LIMIT 1) p \
		 UNION SELECT 1 FROM (SELECT `id` FROM `inventory` WHERE `item_id`=%d AND `value`=%d AND `uid`<>%d LIMIT 1) i \
		 UNION SELECT 1 FROM (SELECT `number` FROM `sim_cards` WHERE `number`=%d AND `owner_id`>0 AND `owner_id`<>%d LIMIT 1) s LIMIT 1",
		simnumber, except_uid, ITEM_SIM_CARD, simnumber, except_uid, simnumber, except_uid);
}

forward Sim_SanitizeDeferred(playerid);
public Sim_SanitizeDeferred(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	Sim_SanitizePlayerSims(playerid);
	return 1;
}

stock Sim_SanitizePlayerSims(playerid)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0) return 0;
	new uid = Player[playerid][pID];
	new q[768];
	mysql_format(db_handle, q, sizeof q,
		"SELECT n.`num`, n.`kind` FROM ( \
			SELECT `sim_card` AS `num`, 1 AS `kind` FROM `players` WHERE `id`=%d AND `sim_card`>0 \
			UNION ALL \
			SELECT `value` AS `num`, 2 AS `kind` FROM `inventory` WHERE `uid`=%d AND `item_id`=%d AND `value`>0 \
		) n WHERE \
			EXISTS(SELECT 1 FROM `players` p WHERE p.`sim_card`=n.`num` AND p.`id`<>%d LIMIT 1) OR \
			EXISTS(SELECT 1 FROM `inventory` i WHERE i.`item_id`=%d AND i.`value`=n.`num` AND i.`uid`<>%d LIMIT 1) OR \
			EXISTS(SELECT 1 FROM `sim_cards` s WHERE s.`number`=n.`num` AND s.`owner_id`>0 AND s.`owner_id`<>%d LIMIT 1)",
		uid, uid, ITEM_SIM_CARD, uid, ITEM_SIM_CARD, uid, uid);
	mysql_tquery(db_handle, q, "OnPlayerSimSanitize", "i", playerid);
	return 1;
}

forward OnPlayerSimSanitize(playerid);
public OnPlayerSimSanitize(playerid)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0) return 0;

	new rows = cache_num_rows();
	for(new r = 0; r < rows; r++)
	{
		new num = cache_get_field_content_int(r, "num", db_handle);
		new kind = cache_get_field_content_int(r, "kind", db_handle);
		if(num <= 0) continue;

		if(kind == 1)
		{
			if(Player[playerid][pSimCard] == num)
				Phone_ClearActiveSimNoHook(playerid);
		}
		else if(kind == 2)
		{
			for(new i = 0; i < MAX_INV_SLOTS; i++)
			{
				if(PlayerInventory[playerid][i][invItem] == ITEM_SIM_CARD &&
					PlayerInventory[playerid][i][invValue] == num)
				{
					RemoveInventorySim(playerid, i);
					break;
				}
			}
		}
	}

	if(Player[playerid][pSimCard] > 0)
		Phone_RegisterSim(Player[playerid][pSimCard], Player[playerid][pID]);

	for(new s = 0; s < MAX_INV_SLOTS; s++)
	{
		if(PlayerInventory[playerid][s][invItem] != ITEM_SIM_CARD) continue;
		new v = PlayerInventory[playerid][s][invValue];
		if(v > 0) Phone_RegisterSim(v, Player[playerid][pID]);
	}
	return 1;
}

stock Phone_SetSimOwner(simnumber, owner_id)
{
	if(simnumber <= 0) return 0;
	Phone_RegisterSim(simnumber, owner_id);
	return 1;
}

stock Phone_SaveActiveSimUnits(playerid) { return Phone_SaveActiveBalance(playerid); }

stock Phone_ClearActiveSimNoHook(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	Phone_SaveActiveBalance(playerid);
	Player[playerid][pSimCard] = 0;
	g_PhoneBalanceRub[playerid] = 0;
	if(Player[playerid][pID] > 0)
	{
		new q[96];
		mysql_format(db_handle, q, sizeof q,
			"UPDATE `players` SET `sim_card`=0 WHERE `id`=%d LIMIT 1", Player[playerid][pID]);
		mysql_tquery(db_handle, q, "", "");
	}
	return 1;
}

stock Phone_SaveActiveBalance(playerid)
{
	new sim = Player[playerid][pSimCard];
	new uid = Player[playerid][pID];
	if(sim <= 0 || uid <= 0) return 0;
	new q[160];
	mysql_format(db_handle, q, sizeof q,
		"UPDATE `sim_cards` SET `balance`=%d WHERE `number`=%d AND (`owner_id`=%d OR `owner_id`=0) LIMIT 1",
		g_PhoneBalanceRub[playerid], sim, uid);
	mysql_tquery(db_handle, q, "", "");
	return 1;
}

stock Phone_LoadActiveSim(playerid)
{
	new sim = Player[playerid][pSimCard];
	if(sim <= 0 || Player[playerid][pID] <= 0)
	{
		g_PhoneBalanceRub[playerid] = 0;
		return 0;
	}
	new gen = GetPVarInt(playerid, PHONE_PVAR_BAL_LOAD_GEN) + 1;
	SetPVarInt(playerid, PHONE_PVAR_BAL_LOAD_GEN, gen);
	new q[128];
	mysql_format(db_handle, q, sizeof q,
		"SELECT `balance`,`owner_id` FROM `sim_cards` WHERE `number`=%d LIMIT 1", sim);
	mysql_tquery(db_handle, q, "Phone_OnBalanceLoaded", "dd", playerid, gen);
	return 1;
}

public Phone_OnBalanceLoaded(playerid, load_gen)
{
	if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0) return 0;
	if(GetPVarInt(playerid, PHONE_PVAR_BAL_LOAD_GEN) != load_gen) return 0;

	new sim = Player[playerid][pSimCard];
	new uid = Player[playerid][pID];
	if(sim <= 0)
	{
		g_PhoneBalanceRub[playerid] = 0;
		return 0;
	}
	if(cache_num_rows() > 0)
	{
		new owner_id = cache_get_field_content_int(0, "owner_id", db_handle);
		if(owner_id > 0 && owner_id != uid)
		{
			Phone_ClearActiveSimNoHook(playerid);
			SendClientMessage(playerid, 0xCECECEFF,
				"Активная SIM снята: номер принадлежит другому аккаунту.");
			return 0;
		}
		g_PhoneBalanceRub[playerid] = cache_get_field_content_int(0, "balance", db_handle);
		if(owner_id == 0)
			Phone_RegisterSim(sim, uid);
	}
	else if(IsPlayerOwnsSimNumber(playerid, sim))
	{
		Phone_RegisterSim(sim, uid);
		g_PhoneBalanceRub[playerid] = 0;
	}
	else
		Phone_ClearActiveSimNoHook(playerid);
	return 1;
}

stock Phone_AfterActiveSimSet(playerid)
{
	if(Player[playerid][pID] <= 0) return 0;
	new sim = Player[playerid][pSimCard];
	if(sim <= 0)
	{
		g_PhoneBalanceRub[playerid] = 0;
		return 1;
	}
	if(!IsPlayerOwnsSimNumber(playerid, sim))
	{
		Phone_ClearActiveSimNoHook(playerid);
		return 0;
	}
	Phone_RegisterSim(sim, Player[playerid][pID]);
	return Phone_LoadActiveSim(playerid);
}

stock bool:Phone_HasBalance(playerid, amount)
{
	return (Player[playerid][pSimCard] > 0 && g_PhoneBalanceRub[playerid] >= amount);
}

stock bool:Phone_TakeBalance(playerid, amount)
{
	if(amount <= 0) return true;
	if(!Phone_HasBalance(playerid, amount)) return false;
	g_PhoneBalanceRub[playerid] -= amount;
	Phone_SaveActiveBalance(playerid);
	return true;
}

stock bool:Phone_AtmTopUp(playerid, sum)
{
	if(sum < PHONE_RUB_PER_MINUTE)
	{
		SendClientMessage(playerid, COLOR_WHITE,
			"{FFCD00}[Банк] {FFFFFF}Минимальное пополнение — 100 руб.");
		return false;
	}
	if(!Player[playerid][pPhoneOwned])
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Купите телефон в салоне связи.");
		return false;
	}
	if(Player[playerid][pSimCard] <= 0)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Установите SIM-карту в телефон.");
		return false;
	}
	if(Player[playerid][pBank] < sum)
	{
		SendClientMessage(playerid, COLOR_WHITE, "{FFCD00}[Банк] {FFFFFF}Недостаточно средств на основном счёте.");
		return false;
	}

	Player[playerid][pBank] -= sum;
	Bank_SaveMainMoney(playerid);
	g_PhoneBalanceRub[playerid] += sum;
	SetPVarInt(playerid, PHONE_PVAR_BAL_LOAD_GEN, GetPVarInt(playerid, PHONE_PVAR_BAL_LOAD_GEN) + 1);
	Phone_SaveActiveBalance(playerid);

	new msg[128];
	format(msg, sizeof msg,
		"{00FF00}[Банк] {FFFFFF}На SIM {FFD700}%d {FFFFFF}зачислено {FFD700}%d {FFFFFF}руб. (?%d мин. разговора).",
		Player[playerid][pSimCard], sum, sum / PHONE_RUB_PER_MINUTE);
	SendClientMessage(playerid, COLOR_WHITE, msg);
	return true;
}

stock Phone_StopCallBilling(playerid)
{
	new tid = GetPVarInt(playerid, PHONE_PVAR_CALL_BILL_TIMER);
	if(tid > 0)
	{
		KillTimer(tid);
		DeletePVar(playerid, PHONE_PVAR_CALL_BILL_TIMER);
	}
}

stock Phone_StartCallBilling(playerid)
{
	Phone_StopCallBilling(playerid);
	SetPVarInt(playerid, PHONE_PVAR_CALL_BILL_TIMER,
		SetTimerEx("Phone_CallBillTick", PHONE_CALL_BILL_MS, true, "i", playerid));
}

public Phone_CallBillTick(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!Phone_IsCallActive(playerid))
	{
		Phone_StopCallBilling(playerid);
		return 0;
	}
	if(!Phone_TakeBalance(playerid, PHONE_RUB_PER_MINUTE))
	{
		Phone_SendMsg(playerid, "Закончились средства на счёте. Звонок завершен.");
		Phone_Hangup(playerid, true);
		return 0;
	}
	return 0;
}

stock Phone_Hangup(playerid, bool:notify_peer = true)
{
	new peer = INVALID_PLAYER_ID;
	new bool:was_active = Phone_IsCallActive(playerid);
	new bool:had_incoming = (GetPVarType(playerid, PHONE_PVAR_INCOMING) != PLAYER_VARTYPE_NONE);

	if(was_active)
		peer = GetPVarInt(playerid, PHONE_PVAR_CALL_PEER);
	else if(had_incoming)
		peer = GetPVarInt(playerid, PHONE_PVAR_INCOMING);
	else if(GetPVarType(playerid, PHONE_PVAR_OUTGOING) != PLAYER_VARTYPE_NONE)
		peer = GetPVarInt(playerid, PHONE_PVAR_OUTGOING);

	Phone_ClearCallState(playerid);

	if(!notify_peer || peer == INVALID_PLAYER_ID || !IsPlayerConnected(peer))
		return 1;

	if(was_active && GetPVarInt(peer, PHONE_PVAR_CALL_PEER) == playerid)
	{
		Phone_ClearCallState(peer);
		Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
	}
	else if(had_incoming && GetPVarInt(peer, PHONE_PVAR_OUTGOING) == playerid)
	{
		Phone_ClearCallState(peer);
		Phone_SendMsg(peer, "Абонент сбросил вызов.");
	}
	else if(GetPVarInt(peer, PHONE_PVAR_INCOMING) == playerid)
	{
		Phone_ClearCallState(peer);
		Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
	}
	else if(GetPVarInt(peer, PHONE_PVAR_OUTGOING) == playerid)
	{
		Phone_ClearCallState(peer);
		Phone_SendMsg(peer, "Абонент положил трубку. Звонок завершен.");
	}
	return 1;
}

stock Phone_AnswerCall(playerid)
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нужны телефон и активная SIM-карта."), 0;
	if(GetPVarType(playerid, PHONE_PVAR_INCOMING) == PLAYER_VARTYPE_NONE)
		return SendClientMessage(playerid, 0xCECECEFF, "Нет входящего звонка. Используйте /p только для ответа."), 0;

	new caller = GetPVarInt(playerid, PHONE_PVAR_INCOMING);
	DeletePVar(playerid, PHONE_PVAR_INCOMING);

	if(!IsPlayerConnected(caller) || GetPVarInt(caller, PHONE_PVAR_OUTGOING) != playerid)
	{
		Phone_SendMsg(playerid, "Вызов уже недоступен.");
		return 0;
	}

	DeletePVar(caller, PHONE_PVAR_OUTGOING);
	SetPVarInt(playerid, PHONE_PVAR_CALL_PEER, caller);
	SetPVarInt(caller, PHONE_PVAR_CALL_PEER, playerid);

	new msg[96];
	format(msg, sizeof msg, "Вы подняли трубку. Собеседник: %s.", Player[caller][pName]);
	Phone_SendMsg(playerid, msg);
	format(msg, sizeof msg, "Абонент ответил. Собеседник: %s.", Player[playerid][pName]);
	Phone_SendMsg(caller, msg);

	if(!Phone_TakeBalance(caller, PHONE_RUB_PER_MINUTE))
	{
		Phone_SendMsg(caller, "Недостаточно средств — звонок прерван.");
		Phone_Hangup(playerid, true);
		return 0;
	}
	Phone_StartCallBilling(caller);
	return 1;
}

stock Phone_FindPlayerBySim(simnumber)
{
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(!IsPlayerConnected(i) || Player[i][pID] == 0) continue;
		if(Player[i][pSimCard] == simnumber) return i;
	}
	return INVALID_PLAYER_ID;
}

stock Phone_FindPlayerBySimOrId(ref)
{
	new target = Phone_FindPlayerBySim(ref);
	if(target != INVALID_PLAYER_ID) return target;
	if(ref >= 0 && ref <= MAX_PLAYERS && IsPlayerConnected(ref) && Player[ref][pID] > 0)
		return ref;
	return INVALID_PLAYER_ID;
}

stock Phone_TryStartCall(playerid, target_sim)
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Сначала купите телефон и установите SIM-карту."), 0;
	if(Phone_IsPhoneBusy(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Завершите текущий звонок (/h)."), 0;
	if(!Phone_HasBalance(playerid, PHONE_RUB_PER_MINUTE))
	{
		SendClientMessage(playerid, 0xCECECEFF,
			"Недостаточно средств на счёте SIM. Пополните в банкомате (мобильный счёт).");
		return 0;
	}
	if(target_sim <= 0)
		return SendClientMessage(playerid, 0xCECECEFF, "Неверный номер."), 0;
	if(target_sim == Player[playerid][pSimCard])
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя позвонить самому себе."), 0;

	new target = Phone_FindPlayerBySim(target_sim);
	if(target == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "Абонент не в сети или номер неверен."), 0;
	if(!Player[target][pPhoneOwned])
		return SendClientMessage(playerid, 0xCECECEFF, "У абонента нет телефона."), 0;
	if(Phone_IsPhoneBusy(target))
		return SendClientMessage(playerid, 0xCECECEFF, "Абонент занят."), 0;

	SetPVarInt(playerid, PHONE_PVAR_OUTGOING, target);
	SetPVarInt(target, PHONE_PVAR_INCOMING, playerid);

	new msg[128];
	format(msg, sizeof msg, "Звонит телефон. Вызывающий абонент: %s. Введите /p, чтобы ответить.", Player[playerid][pName]);
	Phone_SendMsg(target, msg);
	format(msg, sizeof msg, "Идёт вызов на номер %d (%s). Ожидание ответа. /h — отменить.", target_sim, Player[target][pName]);
	Phone_SendMsg(playerid, msg);
	return 1;
}

stock Phone_OnPlayerText(playerid, text[])
{
	if(!Phone_IsCallActive(playerid)) return 0;
	new peer = GetPVarInt(playerid, PHONE_PVAR_CALL_PEER);
	if(!IsPlayerConnected(peer) || GetPVarInt(peer, PHONE_PVAR_CALL_PEER) != playerid)
	{
		Phone_Hangup(playerid, false);
		return 0;
	}
	if(text[0] == '/' && text[1] != '\0') return 0;

	new msg[256];
	format(msg, sizeof msg, "%s сказал: %s", Player[playerid][pName], text);
	Phone_SendMsg(peer, msg);
	format(msg, sizeof msg, "(в эфире) %s", text);
	Phone_SendMsg(playerid, msg);
	return 1;
}

stock Phone_SendSms(playerid, target_ref, const sms_text[])
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нужны телефон и активная SIM-карта."), 0;
	if(!strlen(sms_text))
		return SendClientMessage(playerid, 0xCECECEFF, "Пустое сообщение."), 0;
	if(!Phone_HasBalance(playerid, PHONE_SMS_COST_RUB))
	{
		SendClientMessage(playerid, 0xCECECEFF,
			"Недостаточно средств на SIM. SMS — 50 руб. Пополните в банкомате.");
		return 0;
	}

	new target = Phone_FindPlayerBySimOrId(target_ref);
	if(target == INVALID_PLAYER_ID)
		return SendClientMessage(playerid, 0xCECECEFF, "Абонент не в сети или номер неверен."), 0;
	if(!Player[target][pPhoneOwned])
		return SendClientMessage(playerid, 0xCECECEFF, "У абонента нет телефона."), 0;

	Phone_TakeBalance(playerid, PHONE_SMS_COST_RUB);

	new msg[192];
	format(msg, sizeof msg, "SMS от %s (SIM %d): %s", Player[playerid][pName], Player[playerid][pSimCard], sms_text);
	Phone_SendMsg(target, msg);
	format(msg, sizeof msg, "SMS отправлено (%d руб. списано).", PHONE_SMS_COST_RUB);
	Phone_SendMsg(playerid, msg);
	return 1;
}

stock Phone_ShowPhoneBook(playerid)
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нужны телефон и активная SIM-карта."), 0;

	new body[256], line[64];
	format(body, sizeof body,
		CAR_CLR_WHITE "Ваш активный номер: " CAR_CLR_GOLD "%d\n\n", Player[playerid][pSimCard]);
	strcat(body, CAR_CLR_DIM "Онлайн абоненты с SIM:\n");

	new found = 0;
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if(i == playerid || !IsPlayerConnected(i) || Player[i][pID] == 0) continue;
		if(!Player[i][pPhoneOwned] || Player[i][pSimCard] <= 0) continue;
		format(line, sizeof line, CAR_CLR_WHITE "%s\t" CAR_CLR_GOLD "%d\n", Player[i][pName], Player[i][pSimCard]);
		if(strlen(body) + strlen(line) < sizeof body - 48)
		{
			strcat(body, line);
			found++;
		}
	}
	if(!found)
		strcat(body, CAR_CLR_DIM "Сейчас никого нет.\n");
	strcat(body, CAR_CLR_DIM "\nНабор: /c");

	ShowPlayerDialog(playerid, DIALOG_BR_PHONE_BOOK, DIALOG_STYLE_MSGBOX,
		CAR_DLG_PREFIX "Телефонная книга", body, "Закрыть", "");
	return 1;
}

stock Phone_TrimDialInput(const src[], dest[], size = sizeof dest)
{
	dest[0] = '\0';
	if(!src[0]) return 0;
	new j = 0;
	for(new i = 0; src[i] && j < size - 1; i++)
	{
		if(src[i] == ' ' || src[i] == '\t') continue;
		dest[j++] = src[i];
	}
	dest[j] = '\0';
	return j;
}

stock bool:Phone_IsDialDigits(const str[])
{
	if(!str[0]) return false;
	new len = strlen(str);
	if(len < 1 || len > 8) return false;
	for(new i = 0; i < len; i++)
		if(str[i] < '0' || str[i] > '9') return false;
	return true;
}

stock Phone_ShowDialDialog(playerid)
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Сначала купите телефон и установите SIM-карту."), 0;
	if(Phone_IsPhoneBusy(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Завершите текущий звонок (/h)."), 0;

	new hint[160];
	format(hint, sizeof hint,
		"SIM %d | баланс %d руб (~%d мин). Службы: 02, 03, 090, 111. Пополнение — банкомат.",
		Player[playerid][pSimCard],
		g_PhoneBalanceRub[playerid],
		g_PhoneBalanceRub[playerid] / PHONE_RUB_PER_MINUTE);
	Phone_SendMsg(playerid, hint);

	ShowPlayerDialog(playerid, DIALOG_BR_PHONE_DIAL, DIALOG_STYLE_INPUT,
		"{66CC00}Наберите номер",
		"{FFFFFF}Номер SIM абонента или службы (02, 03, 090, 111):",
		"Позвонить", "Отмена");
	return 1;
}

stock Phone_HandleServiceDial(playerid, svc_code)
{
	#pragma unused svc_code
	Phone_SendMsg(playerid, "В разработке.");
	return 1;
}

stock Phone_ProcessDialInput(playerid, const input[])
{
	if(!Phone_CanUsePhone(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Сначала купите телефон и установите SIM-карту."), 0;

	new dial[16];
	Phone_TrimDialInput(input, dial, sizeof dial);
	if(!Phone_IsDialDigits(dial))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Введите корректный номер (только цифры).");
		Phone_ShowDialDialog(playerid);
		return 0;
	}
	if(!strcmp(dial, "02", true) || !strcmp(dial, "2", true))
		return Phone_HandleServiceDial(playerid, PHONE_DIAL_SVC_POLICE);
	if(!strcmp(dial, "03", true) || !strcmp(dial, "3", true))
		return Phone_HandleServiceDial(playerid, PHONE_DIAL_SVC_MEDIC);
	if(!strcmp(dial, "090", true) || !strcmp(dial, "90", true))
		return Phone_HandleServiceDial(playerid, PHONE_DIAL_SVC_MECHANIC);
	if(!strcmp(dial, "111", true))
		return Phone_HandleServiceDial(playerid, PHONE_DIAL_SVC_OPERATOR);

	return Phone_TryStartCall(playerid, strval(dial));
}

stock bool:Phone_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused listitem
	if(dialogid == DIALOG_BR_PHONE_BOOK) return true;

	if(dialogid != DIALOG_BR_PHONE_DIAL) return false;

	new dial[16];
	Phone_TrimDialInput(inputtext, dial, sizeof dial);

	if(Phone_IsDialDigits(dial))
	{
		Phone_ProcessDialInput(playerid, dial);
		return true;
	}

	if(!response) return true;

	SendClientMessage(playerid, 0xCECECEFF, "Введите номер в поле ввода или: /c [номер]");
	Phone_ShowDialDialog(playerid);
	return true;
}

stock Phone_CmdCall(playerid, const params[])
{
	if(Player[playerid][pID] <= 0) return 0;
	if(!params[0]) return Phone_ShowDialDialog(playerid);

	new dial[16];
	Phone_TrimDialInput(params, dial, sizeof dial);
	if(!Phone_IsDialDigits(dial))
		return SendClientMessage(playerid, 0xCECECEFF, "Использование: /c [номер SIM]  или  /c"), 0;

	return Phone_ProcessDialInput(playerid, dial);
}

stock Phone_CmdAnswer(playerid)
{
	return Phone_AnswerCall(playerid);
}

stock Phone_CmdHangup(playerid)
{
	if(!Phone_IsPhoneBusy(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нет активного звонка или вызова."), 0;
	new bool:was_active = Phone_IsCallActive(playerid);
	Phone_Hangup(playerid, true);
	if(was_active)
		Phone_SendMsg(playerid, "Вы положили трубку. Звонок завершен.");
	else
		Phone_SendMsg(playerid, "Вызов сброшен.");
	return 1;
}
