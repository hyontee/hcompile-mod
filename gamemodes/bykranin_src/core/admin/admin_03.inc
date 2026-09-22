//>> Файл: bykranin_src/core/admin/admin_03.inc  (336 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: /kick, /skick, /mute, /unmute, /jail, /unjail, /getcam
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:kick(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid, reason[65];
    if(sscanf(params, "dS(Без причины)[65]", targetid, reason)) return SendClientMessage(playerid, -1, "Используйте: /kick [id] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    if(AntiSliv(playerid, "/kick")) return 1;
    new message[192];
    format(message, sizeof message, "Администратор %s кикнул игрока %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return SRAdmin_SafeKick(targetid);
}


CMD:skick(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid;
    if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, -1, "Используйте: /skick [id]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    new message[144];
    format(message, sizeof message, "[A] %s[%d] кикнул %s[%d] без публичного объявления", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
    if(SRAdmin_Level(playerid) < 6) SendMessageToAdmins(message, 0x999999FF);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return SRAdmin_SafeKick(targetid);
}

CMD:mute(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid, minutes, reason[65];
    if(sscanf(params, "ddS(Без причины)[65]", targetid, minutes, reason)) return SendClientMessage(playerid, -1, "Используйте: /mute [id] [минуты] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    if(minutes < 1 || minutes > 360) return SendClientMessage(playerid, -1, "Срок: от 1 до 360 минут.");
    if(GetPlayerData(targetid, P_MUTE) > 0) return SendClientMessage(playerid, -1, "У игрока уже есть мут.");
    if(AntiSliv(playerid, "/mute")) return 1;
    if(!SRAdmin_SaveTimer(playerid, targetid, minutes * 60, 0)) return SendClientMessage(playerid, -1, "Ошибка сохранения мута.");
    SetPlayerData(targetid, P_MUTE, minutes * 60);
    new message[192];
    format(message, sizeof message, "Администратор %s заблокировал чат %s на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), minutes, reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}

CMD:unmute(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid, reason[65];
    if(sscanf(params, "ds[65]", targetid, reason)) return SendClientMessage(playerid, -1, "Используйте: /unmute [id] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    if(GetPlayerData(targetid, P_MUTE) <= 0) return SendClientMessage(playerid, -1, "У игрока нет мута.");
    if(!SRAdmin_SaveTimer(playerid, targetid, 0, 0)) return SendClientMessage(playerid, -1, "Ошибка сохранения снятия мута.");
    SetPlayerData(targetid, P_MUTE, 0);
    new message[192];
    format(message, sizeof message, "Администратор %s снял мут с %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}

CMD:jail(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid, minutes, reason[65];
    if(sscanf(params, "ddS(Без причины)[65]", targetid, minutes, reason)) return SendClientMessage(playerid, -1, "Используйте: /jail [id] [минуты] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    if(minutes < 1 || minutes > 360) return SendClientMessage(playerid, -1, "Срок: от 1 до 360 минут.");
    if(GetPlayerData(targetid, P_JAIL) > 0) return SendClientMessage(playerid, -1, "Игрок уже находится в тюрьме.");
    if(AntiSliv(playerid, "/jail")) return 1;
    if(!SRAdmin_SaveTimer(playerid, targetid, minutes * 60, 1)) return SendClientMessage(playerid, -1, "Ошибка сохранения заключения.");
    if(GetPlayerSpectateData(targetid, S_PLAYER) != -1) StopSpectate(targetid);
    JailPlayer(targetid, minutes);
    new message[192];
    format(message, sizeof message, "Администратор %s отправил %s в тюрьму на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), minutes, reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}

CMD:unjail(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new targetid, reason[65];
    if(sscanf(params, "ds[65]", targetid, reason)) return SendClientMessage(playerid, -1, "Используйте: /unjail [id] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 1)) return 1;
    if(GetPlayerData(targetid, P_JAIL) <= 0) return SendClientMessage(playerid, -1, "Игрок не находится в тюрьме.");
    if(!SRAdmin_SaveTimer(playerid, targetid, 0, 1)) return SendClientMessage(playerid, -1, "Ошибка сохранения освобождения.");
    UnjailPlayer(targetid);
    new message[192];
    format(message, sizeof message, "Администратор %s освободил %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_ADMIN_ACTION, message);
    return 1;
}
CMD:getcam(playerid, params[])
{
						new
                        Float:fPX, Float:fPY, Float:fPZ,
                        Float:fVX, Float:fVY, Float:fVZ,
                        Float:object_x, Float:object_y, Float:object_z;

		                const
		                Float:fScale = 5.0;

		                GetPlayerCameraPos(playerid, fPX, fPY, fPZ);
		                GetPlayerCameraFrontVector(playerid, fVX, fVY, fVZ);

		                object_x = fPX + floatmul(fVX, fScale);
		                object_y = fPY + floatmul(fVY, fScale);
		                object_z = fPZ + floatmul(fVZ, fScale);

		                format(sctring, sizeof(sctring), "CameraPos: %f,%f,%f | LookAt: %f,%f,%f",fPX,fPY,fPZ,object_x,object_y,object_z);
		                print(sctring);
		                SendClientMessage(playerid, -1, sctring);
						return 1;
}
CMD:ban(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 3)) return 1;
    new targetid, days, reason[65];
    if(sscanf(params, "ddS(Без причины)[65]", targetid, days, reason)) return SendClientMessage(playerid, -1, "Используйте: /ban [id] [дней] [причина]");
    if(!SRAdmin_Target(playerid, targetid, 3)) return 1;
    new maximum = SRAdmin_Level(playerid) > 4 ? 90 : 30;
    if(days < 1 || days > maximum)
    {
        new text[96];
        format(text, sizeof text, "Допустимый срок: от 1 до %d дней.", maximum);
        return SendClientMessage(playerid, -1, text);
    }
    if(AntiSliv(playerid, "/ban")) return 1;
    new result = SRAdmin_BanAccount(playerid, GetPlayerAccountID(targetid), days, GetPlayerIpEx(targetid), reason);
    if(result == -1) return SendClientMessage(playerid, -1, "Аккаунт уже заблокирован.");
    if(result != 1) return SendClientMessage(playerid, -1, "Блокировка не подтверждена БД. Проверьте серверный журнал.");
    new message[192];
    format(message, sizeof message, "Администратор %s заблокировал %s на %d дней. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), days, reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, message);
    return SRAdmin_SafeKick(targetid);
}


CMD:unban(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 3)) return 1;
    new name[MAX_PLAYER_NAME];
    if(sscanf(params, "s[24]", name)) return SendClientMessage(playerid, -1, "Используйте: /unban [ник]");
    new account, level, ip[16];
    new found = SRAdmin_FindAccount(name, account, level, ip, sizeof ip, 1);
    if(found == 0) found = SRAdmin_FindAccount(name, account, level, ip, sizeof ip);
    if(found == -1) return SendClientMessage(playerid, -1, "Ошибка БД при поиске аккаунта. Проверьте серверный журнал.");
    if(found != 1)
    {
        new not_found_text[144];
        format(not_found_text, sizeof not_found_text, "Аккаунт '%s' не найден в БД (можно указать ник или номер аккаунта).", name);
        return SendClientMessage(playerid, -1, not_found_text);
    }
    new result = SRAdmin_UnbanAccount(playerid, account);
    if(result == -1) return SendClientMessage(playerid, -1, "Аккаунт не заблокирован.");
    if(result != 1) return SendClientMessage(playerid, -1, "Разблокировка не подтверждена БД. Проверьте серверный журнал.");
    new message[160];
    format(message, sizeof message, "Администратор %s разблокировал аккаунт %s", GetPlayerNameEx(playerid), name);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, message);
    return 1;
}
CMD:setskin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	// to_player, skin_id are declared in extract below
	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /setskin [id игрока] [id скина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	if(!(2 <= skin_id <= 20000000)) return SendClientMessage(playerid, 0xCECECEFF, ""SC"ID скина от 2 до 20000000");

	new old_skin_id = GetPlayerData(to_player, P_SKIN);
	SetPlayerData(to_player, P_SKIN, skin_id);
	UpdatePlayerDatabaseInt(to_player, "skin", skin_id);
	SetPlayerSkinInit(to_player);

	new fmt_text[144];

	if(to_player == playerid)
	{
		format(fmt_text, sizeof fmt_text, "{1E90FF}Вы установили себе скин №%d", skin_id);
		SendClientMessage(playerid, -1, fmt_text);
	}
	else
	{
		format(fmt_text, sizeof fmt_text, "{1E90FF}Вы установили %s[%d] скин №%d", GetPlayerNameEx(to_player), to_player, skin_id);
		SendClientMessage(playerid, -1, fmt_text);

		format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] установил Вам скин №%d", GetPlayerNameEx(playerid), playerid, skin_id);
		SendClientMessage(to_player, -1, fmt_text);
	}

	format(fmt_text, sizeof fmt_text, "{FF5533}[A] %s[%d] установил %s[%d] скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
	SendMessageToAdmins(fmt_text, 0xCECECEFF);

	format(fmt_text, sizeof fmt_text, "Установил %s[acc:%d] скин %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), skin_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	new skin_change[48];
	format(skin_change, sizeof skin_change, "%d -> %d", old_skin_id, skin_id);

	return 1;
}

CMD:myskin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return 1;
	
	ShowPlayerDialog(playerid,DLG_MYSKIN,DIALOG_STYLE_INPUT,"Мой скин","Введите ID скина от 1 до 600","Применить","Отмена");

	

	return 1;
}

CMD:offban(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 3)) return 1;
    new name[MAX_PLAYER_NAME], days, reason[65];
    if(sscanf(params, "s[24]ds[65]", name, days, reason)) return SendClientMessage(playerid, -1, "Используйте: /offban [ник] [дней] [причина]");
    if(days < 1 || days > 90) return SendClientMessage(playerid, -1, "Допустимый срок: от 1 до 90 дней.");
    if(IsPlayerConnected(GetPlayerID(name))) return SendClientMessage(playerid, -1, "Игрок онлайн. Используйте /ban.");
    new account, level, ip[16];
    new found = SRAdmin_FindAccount(name, account, level, ip, sizeof ip);
    if(found == -1) return SendClientMessage(playerid, -1, "Ошибка БД при поиске аккаунта. Проверьте серверный журнал.");
    if(found != 1)
    {
        new not_found_text[144];
        format(not_found_text, sizeof not_found_text, "Аккаунт '%s' не найден в БД (можно указать ник или номер аккаунта).", name);
        return SendClientMessage(playerid, -1, not_found_text);
    }
    if(level == 14) level = 13;
    if(level < 0 || level > SRAdmin_Level(playerid)) return SendClientMessage(playerid, -1, "Недостаточно прав для блокировки этого аккаунта.");
    if(AntiSliv(playerid, "/offban")) return 1;
    new result = SRAdmin_BanAccount(playerid, account, days, ip, reason);
    if(result == -1) return SendClientMessage(playerid, -1, "Аккаунт уже заблокирован.");
    if(result != 1) return SendClientMessage(playerid, -1, "Блокировка не подтверждена БД. Проверьте серверный журнал.");
    new message[192];
    format(message, sizeof message, "Администратор %s заблокировал %s на %d дней. Причина: %s", GetPlayerNameEx(playerid), name, days, reason);
    SendClientMessageToAll(0xFF5533FF, message);
    SRAdmin_WriteLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, message);
    return 1;
}

CMD:delacc(playerid, params[])
{

	if(GetPlayerAdminEx(playerid) < 9) return 1;

	extract params -> new string:name[21], string:reason[30]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delacc [имя игрока] [причина]");

	new query[128],
		Cache: result,
		admin,
		rows;

	mysql_format(mysql, query, sizeof query, "SELECT admin FROM accounts WHERE name='%s' LIMIT 1", name);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	if(rows)
	{
		admin = cache_get_row_int(0, 0);

		if(admin && GetPlayerAdminEx(playerid) < 5)
		{
			SendClientMessage(playerid, 0x999999FF, "Вы не можете удалить аккаунт администратора выше Вас рангом");

			cache_delete(result);

			format(query, sizeof query, "Попытался удалить аккаунт %s", name);
			SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);

			return 1;
		}

		mysql_format(mysql, query, sizeof query, "DELETE FROM accounts WHERE name='%s' LIMIT 1", name);
		mysql_query(mysql, query, false);

		format(query, sizeof query, "Администратор %s обнулил имущество игрока %s", GetPlayerNameEx(playerid), name);

		if(strlen(reason) > 0)
		{
			new fmt_text[45];

			format(fmt_text, sizeof fmt_text, ". Причина: %s", reason);
			strcat(query, fmt_text);
		}

		SendClientMessageToAll(0xFF5533FF, query);

		format(query, sizeof query, "Удалил аккаунт %s. Причина: %s", name, reason);
		SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, query);
	}
					else SendClientMessage(playerid, 0x999999FF, "Игрок с таким именем не найден");

	cache_delete(result);

	return 1;
}

/*CMD:skin(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new to_player, skin_id; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /skin [id игрока] [id скина]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");
	if(TEST_SERVER == 1)
	{
	    if(playerid != to_player) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данную команду можно использовать на ТЕСТ СЕРВЕРЕ только по отношению к себе!");
	}

	if(!(-1 <= skin_id <= 20000) || skin_id == 0) return SendClientMessage(playerid, 0x999999FF, ""SC"ID скина от 1 до 20000");

	if(skin_id != -1)
		SetPlayerSkin(to_player, skin_id);
	else
		SetPlayerSkin(to_player, GetPlayerSkinEx(to_player));

	new fmt_text[999];

	format(fmt_text, sizeof fmt_text, "{1E90FF}Вы выдали игроку %s[%d] скин %s", GetPlayerNameEx(to_player), to_player, skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(playerid, -1, fmt_text);
	
	format(fmt_text, sizeof fmt_text, "{1E90FF}Администратор %s[%d] выдал Вам %s скин", GetPlayerNameEx(playerid), playerid, skin_id != -1 ? "временный" : "прежний");
	SendClientMessage(to_player, -1, fmt_text);	

	if(skin_id != -1)
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] выдал %s[%d] временный скин №%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, skin_id);
	else
		format(fmt_text, sizeof fmt_text, "[A] %s[%d] выдал %s[%d] прежний скин", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
	SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Выдал %s[acc:%d] скин %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), skin_id);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}*/

