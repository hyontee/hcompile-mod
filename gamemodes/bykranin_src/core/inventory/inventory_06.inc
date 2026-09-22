//>> Файл: bykranin_src/core/inventory/inventory_06.inc  (299 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: /delacs, LoadSvetfor, SvetforsChangeColor, /mat, /rem, /remoff, /delveh
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:delacs(playerid, params[])
{
    extract params -> new command_slot; else
        return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: {FFFF00}/delacs [1-3]");
    if(command_slot < 1 || command_slot > 3)
        return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Слот /giveacs должен быть от 1 до 3.");

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 1;
    AdminGiveAccessoryEnsureStorage();

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "SELECT physical_slot,acs_id FROM admin_given_accessories WHERE player_id=%d AND command_slot=%d LIMIT 1",
        account_id, command_slot);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno()) { cache_delete(result); return SCM(playerid, -1, "Ошибка базы данных."); }
    if(!cache_num_rows())
    {
        cache_delete(result);
        return SCM(playerid, -1, "{FFFF00}| {FFFFFF}В этом слоте /giveacs нет аксессуара.");
    }

    new physical_slot = cache_get_field_content_int(0, "physical_slot");
    new acs_id = cache_get_field_content_int(0, "acs_id");
    cache_delete(result);
    if(physical_slot < 7 || physical_slot > 9) return SCM(playerid, -1, "Некорректный командный слот.");

    mysql_format(mysql, query, sizeof query,
        "DELETE FROM accessories_players WHERE player_id=%d AND slot=%d", account_id, physical_slot);
    mysql_query(mysql, query, false);
    mysql_format(mysql, query, sizeof query,
        "DELETE FROM admin_given_accessories WHERE player_id=%d AND command_slot=%d", account_id, command_slot);
    mysql_query(mysql, query, false);

    if(IsPlayerAttachedObjectSlotUsed(playerid, physical_slot)) RemovePlayerAttachedObject(playerid, physical_slot);
    for(new temp_idx = 0; temp_idx < 11; temp_idx++) gPlayerTempAccData[playerid][physical_slot][temp_idx] = 0.0;

    new msg[160];
    format(msg, sizeof msg, "{FFFF00}| {FFFFFF}Командный аксессуар удалён из слота /giveacs {FFFF00}%d{FFFFFF}.", command_slot);
    SCM(playerid, -1, msg);
    printf("[DELACS][OK] player=%d account=%d command_slot=%d physical=%d acs=%d", playerid, account_id, command_slot, physical_slot, acs_id);
    return 1;
}
stock LoadSvetfor()

{

	for(new i; i < sizeof SvetforsPos; i++)

	{

	    CreateObject(931, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

	    SvetforsColor[i] = CreateObject(930, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

	    SetTimerEx("SvetforsChangeColor", 15000, false, "ddd", i, 1, 0);

	}

}



forward SvetforsChangeColor(i, type, warn);

public SvetforsChangeColor(i, type, warn)

{

	//светофоры писал KBASs <3

	switch(type)

	{

		//1 красный

	    case 1:

	    {

	        DestroyObject(SvetforsColor[i]);

	    	SvetforsColor[i] = CreateObject(929, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

	    	SetTimerEx("SvetforsChangeColor", 3000, false, "ddd", i, 2, 1);

	    }

		//2 желтый

	    case 2:

	    {

	        if(warn == 1) //красный - зеленый

	        {

		        DestroyObject(SvetforsColor[i]);

		    	SvetforsColor[i] = CreateObject(928, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

		    	SetTimerEx("SvetforsChangeColor", 10000, false, "ddd", i, 3, 0);

			}
					else //зеленый - красный

			{

		        DestroyObject(SvetforsColor[i]);

		    	SvetforsColor[i] = CreateObject(930, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

		    	SetTimerEx("SvetforsChangeColor", 10000, false, "ddd", i, 1, 0);

			}

	    }

		//3 зеленый

	    case 3:

	    {

	        DestroyObject(SvetforsColor[i]);

	    	SvetforsColor[i] = CreateObject(929, SvetforsPos[i][0], SvetforsPos[i][1], SvetforsPos[i][2], 0,0,SvetforsPos[i][3]);

	    	SetTimerEx("SvetforsChangeColor", 3000, false, "dd", i, 2, 2);

	    }

	}

	

}

CMD:mat(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 4) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /mat [ID игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
	return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new mute_time = 30;
	if(GetPlayerData(to_player, P_MUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, ""SC"У этого игрока уже есть мут");
	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"Нельзя выдать мут администратору выше вашего ранга");

	if(AntiSliv(playerid, "/mat")) return true;

	new fmt_msg[999];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s выдал блокировку чата игроку %s на %d минут", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player), mute_time);

	format(fmt_msg, sizeof fmt_msg, "%s. Причина: Мат в вип чат", fmt_msg);

	SendClientMessageToAll(0xFF5533FF, fmt_msg);

	SetPlayerData(to_player, P_MUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "mute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, ""SC"Время до окончания бана чата: {CCCC00}/time");
	SendClientMessage(to_player, 0xCECECEFF, ""SC"Советуем ознакомится с правилами сервера, чтобы не получать подобных наказаний.");
	ShowNotificationNew(to_player, 2, 3, 0, 0, "{FFFFFF}У вас имеется активный мут. Время до\n{FFFFFF}разблокировки: {CCCC00}/time", "");

	format(fmt_msg, sizeof fmt_msg, "Выдал %s[acc:%d] блокировку чата на %d минут. Причина: Мат в вип чат",
	GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), mute_time);

	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

CMD:rem(playerid, params[])
{
   if(!IsPlayerDriver(playerid)) return SendClientMessage(playerid, COLOR_WHITE, ""USC"Вы должны находиться в транспорте");
   Action(playerid, "пристегнул ремень безопасности");
   ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы успешно пристегнули ремень безопасности", "");
}

CMD:remoff(playerid, params[])
{
   if(!IsPlayerDriver(playerid)) return SendClientMessage(playerid, COLOR_WHITE, ""USC"Вы должны находиться в транспорте");
   Action(playerid, "отстегнул ремень безопасности");
   ShowNotificationNew(playerid, 3, 4, 0, 0, "Вы успешно отстегнули ремень безопасности", "");
}

// ---------------- Админские команды для транспорта ----------------
// /veh [модель] [цвет1] [цвет2] [доступ 0/1] - создать (callbacks_08.inc), лимита нет
// /delveh [id тс]  - удалить админский ТС по его ID
// /gveh [id игрока] - телепортировать ТС игрока к себе
// /vehg [id тс]    - телепортировать ТС к себе
// /tpv [id тс]     - телепортироваться к ТС

stock AdminVeh_IsValid(vehicleid)
{
    return (vehicleid >= 1 && vehicleid < MAX_VEHICLES && IsValidVehicle(vehicleid));
}

stock AdminVeh_SetOccupantsWorld(vehicleid, interior, world)
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || GetPlayerVehicleID(i) != vehicleid) continue;
        SetPlayerInterior(i, interior);
        SetPlayerVirtualWorld(i, world);
    }
    return 1;
}

// Ставит ТС в 4 метрах перед игроком (вместе с пассажирами), в его интерьере и виртуальном мире.
stock AdminVeh_MoveToPlayer(vehicleid, playerid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new interior = GetPlayerInterior(playerid), world = GetPlayerVirtualWorld(playerid);

    x += 4.0 * floatsin(-a, degrees);
    y += 4.0 * floatcos(-a, degrees);

    SetVehicleVirtualWorld(vehicleid, world);
    LinkVehicleToInterior(vehicleid, interior);
    SetVehiclePos(vehicleid, x, y, z + 0.5);
    SetVehicleZAngle(vehicleid, a);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    AdminVeh_SetOccupantsWorld(vehicleid, interior, world);
    return 1;
}

CMD:delveh(playerid, params[])
{
    new is_admin = (GetPlayerAdminEx(playerid) >= 4);
    if(!is_admin && GetPlayerYouTubeEx(playerid) < 1)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /delveh [id транспорта]");

    if(!AdminVeh_IsValid(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Транспорта с таким ID не существует.");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_ADMIN_CAR)
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Через /delveh можно удалять только админский транспорт (созданный через /veh).");

    if(!is_admin && g_AdminVehOwner[vehicleid] != playerid + 1)
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Вы можете удалить только транспорт, созданный вами.");

    new model = GetVehicleModel(vehicleid);

    DestroyVehicle(vehicleid);
    g_AdminVehOwner[vehicleid] = 0;

    new fmt_text[160];
    format(fmt_text, sizeof(fmt_text), "{ffff00}|{ffffff} Вы удалили транспорт [ID %d, модель %d].", vehicleid, model);
    SendClientMessage(playerid, 0xCECECEFF, fmt_text);

    format(fmt_text, sizeof(fmt_text), "[A] %s[%d] удалил админский транспорт [ID %d, модель %d]", GetPlayerNameEx(playerid), playerid, vehicleid, model);
    SendMessageToAdmins(fmt_text, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}

CMD:gveh(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /gveh [id игрока] - телепортировать транспорт игрока к себе");

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

    new vehicleid = GetPlayerVehicleID(targetid);
    if(vehicleid < 1)
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Игрок не находится в транспорте.");

    if(vehicleid == GetPlayerVehicleID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Игрок уже находится в вашем транспорте.");

    AdminVeh_MoveToPlayer(vehicleid, playerid);

    new fmt_text[160];
    format(fmt_text, sizeof(fmt_text), "{ffff00}|{ffffff} Вы телепортировали к себе транспорт игрока %s[%d] [ID тс %d].", GetPlayerNameEx(targetid), targetid, vehicleid);
    SendClientMessage(playerid, 0xCECECEFF, fmt_text);

    format(fmt_text, sizeof(fmt_text), "[A] %s[%d] телепортировал к себе транспорт игрока %s[%d] [ID тс %d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, vehicleid);
    SendMessageToAdmins(fmt_text, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}

CMD:vehg(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /vehg [id транспорта] - телепортировать транспорт к себе");

    if(!AdminVeh_IsValid(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Транспорта с таким ID не существует.");

    if(vehicleid == GetPlayerVehicleID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Вы уже находитесь в этом транспорте.");

    AdminVeh_MoveToPlayer(vehicleid, playerid);

    new fmt_text[160];
    format(fmt_text, sizeof(fmt_text), "{ffff00}|{ffffff} Вы телепортировали к себе транспорт [ID %d, модель %d].", vehicleid, GetVehicleModel(vehicleid));
    SendClientMessage(playerid, 0xCECECEFF, fmt_text);

    format(fmt_text, sizeof(fmt_text), "[A] %s[%d] телепортировал к себе транспорт [ID %d, модель %d]", GetPlayerNameEx(playerid), playerid, vehicleid, GetVehicleModel(vehicleid));
    SendMessageToAdmins(fmt_text, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}

CMD:tpv(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 4)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new vehicleid;
    if(sscanf(params, "i", vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /tpv [id транспорта] - телепортироваться к транспорту");

    if(!AdminVeh_IsValid(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Транспорта с таким ID не существует.");

    if(vehicleid == GetPlayerVehicleID(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Вы уже находитесь в этом транспорте.");

    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    // У ТС нет getter'а интерьера - берём его у пассажира, если он есть
    new interior = 0, world = GetVehicleVirtualWorld(vehicleid);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || GetPlayerVehicleID(i) != vehicleid) continue;
        interior = GetPlayerInterior(i);
        break;
    }

    // Становимся справа от транспорта
    x += 3.0 * floatcos(a, degrees);
    y += 3.0 * floatsin(a, degrees);

    SetPlayerInterior(playerid, interior);
    SetPlayerVirtualWorld(playerid, world);
    SetPlayerPos(playerid, x, y, z + 0.5);

    new fmt_text[160];
    format(fmt_text, sizeof(fmt_text), "{ffff00}|{ffffff} Вы телепортировались к транспорту [ID %d, модель %d].", vehicleid, GetVehicleModel(vehicleid));
    SendClientMessage(playerid, 0xCECECEFF, fmt_text);

    format(fmt_text, sizeof(fmt_text), "[A] %s[%d] телепортировался к транспорту [ID %d, модель %d]", GetPlayerNameEx(playerid), playerid, vehicleid, GetVehicleModel(vehicleid));
    SendMessageToAdmins(fmt_text, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}


CMD:reset_cash(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	//else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /reset_cash [ID игрока] [cумма]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new reason[999];
	new fmt_msg[999];
	format(reason, sizeof reason, "{1E90FF}Администратор %s[%d] обнулил вам деньги", GetPlayerNameEx(playerid), playerid);
	GivePlayerMoneyEx(to_player, -cash, reason, true, true);
	SendClientMessage(to_player, 0x66CC00FF, reason);
	
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] обнулил деньги игроку %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(fmt_msg, 0x999999FF);	

	format(reason, sizeof reason, "{1E90FF}Вы обнулили %s %d рублей", GetPlayerNameEx(to_player), cash);
	SendClientMessage(playerid, 0x66CC00FF, reason);

	format(reason, sizeof reason, "Обнулил %s[%d] %d руб", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), cash);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, reason);
	return 1;
}

