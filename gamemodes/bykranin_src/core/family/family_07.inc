//>> Файл: bykranin_src/core/family/family_07.inc  (709 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: ShowFamilyWarehouseMenu, /owarn, /ounwarn, /fwarn, /funwarn, /fmute, /funmute
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ShowFamilyWarehouseMenu(playerid)
{
	new fmt_text[700],
		fam_id = GetPlayerData(playerid, P_FAMILY);

 	format(fmt_text, sizeof fmt_text,
	""c_server"[1] "c_b"Положить деньги | "c_m"%d$"c_b"\n\
	"c_server"[2] "c_b"Положить наркотики | "c_i"%d гр."c_b"\n\
	"c_server"[3] "c_b"Положить Материалы | "c_i"%d кг."c_b"\n\
	"c_server"[4] "c_b"Положить Патроны | "c_i"%d шт."c_b"\n\
	"c_server"[5] "c_b"Взять деньги | "c_m"%d$"c_b" | Ранг доступа: "c_i"%d+\n\
	"c_server"[6] "c_b"Взять наркотики | "c_i"%d гр."c_b" | Ранг доступа: "c_i"%d+\n\
	"c_server"[7] "c_b"Взять Материалы | "c_i"%d кг."c_b" | Ранг доступа: "c_i"%d+\n\
	"c_server"[8] "c_b"Взять Патроны | "c_i"%d шт."c_b" | Ранг доступа: "c_i"%d+",
	GetPlayerData(playerid, P_MONEY),
	GetPlayerData(playerid, P_DRUGS),
	GetPlayerData(playerid, P_METALL),
	GetPlayerData(playerid, P_AMMO),
	GetFamilyData(fam_id, F_MONEY),
	GetFamilyData(fam_id, F_TAKE_MONEY),
	GetFamilyData(fam_id, F_DRUGS),
	GetFamilyData(fam_id, F_TAKE_DRUGS),
	GetFamilyData(fam_id, F_METAL),
	GetFamilyData(fam_id, F_TAKE_METALL),
	GetFamilyData(fam_id, F_AMMO),
	GetFamilyData(fam_id, F_TAKE_AMMO));

	Dialog(playerid, DIALOG_FAMILY_WAREHOUSE, DIALOG_STYLE_LIST, "Склад семьи", fmt_text, "Далее", "Закрыть");
}

CMD:owarn(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /owarn [id игрока] [причина]");

	extract params -> new to_player, string:reason[32];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= strlen(reason) <= 32))
		return SendClientMessage(playerid, 0xCECECEFF, "Введите причину увольнения");

	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей организации");

	if(GetPlayerJob(to_player) >= GetPlayerJob(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать пред. заместителю/лидеру организации");
		
		
    AddPlayerData(to_player, P_OWARN, +, 1);

	new fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "[ORG]: "c_b"%s[%d] выдал предупреждение игроку %s [%d/3]. Причина: %s",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), GetPlayerData(to_player, P_OWARN), reason);

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33CC66FF);

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_OWARN);

	if(warns >= 3)
	{
		SendClientMessage(to_player, 0xFF5533FF, "Вы были исключены из организации. Причина: 3 варна.");

		format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET owarn=0,team=0,job=0 WHERE id=%d", uid);
		mysql_query(mysql, fmt_msg, false);
		
		SetPlayerData(to_player, P_OWARN, 0);
		SetPlayerData(to_player, P_TEAM, 0);
		SetPlayerData(to_player, P_JOB, 0);
	}

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET owarn=%d WHERE id=%d", warns, uid);
	mysql_query(mysql, fmt_msg, false);


	return 1;
}

CMD:ounwarn(playerid, params[])
{
	if(!(1 <= GetPlayerTeamEx(playerid) < MAX_ORG)) return SendClientMessage(playerid, 0x999999FF, "Вам недоступна данная функция");
	if(!(9 <= GetPlayerJob(playerid) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна лидерам организации и их заместителям");

	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ounwarn [id игрока]");

	extract params -> new to_player;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
		
    if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя снять варн с самого себя");


	if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей организации");


    AddPlayerData(to_player, P_OWARN, -, 1);

	new fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "[ORG]: "c_b"%s[%d] снял предупреждение игроку %s [%d/3].",GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), GetPlayerData(to_player, P_OWARN));

	SendMessageToTeam(GetPlayerTeamEx(playerid), fmt_msg, 0x33CC66FF);

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_OWARN);

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET owarn=%d WHERE id=%d", warns, uid);
	mysql_query(mysql, fmt_msg, false);


	return 1;
}


CMD:fwarn(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;new fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_WARN);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы выдавать семейное предупреждение.");


	if(GetPlayerAdminEx(playerid) < 2) return 1;
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fwarn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string:reason[66];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать мут заместителю/лидеру семьи");

	//if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение самому себе");

	AddPlayerData(to_player, P_FWARN, +, 1);

	new fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] выдал предупреждение игроку %s [%d|3]. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), GetPlayerData(to_player, P_FWARN), reason);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	new uid = GetPlayerAccountID(to_player);
	new warns = GetPlayerData(to_player, P_FWARN);

	if(warns >= 3)
	{
		SendClientMessage(to_player, 0xFF5533FF, "Вы были исключены из семьи. Причина: 3 варна.");

		format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET fwarn=0,family=0,family_rank=1 WHERE id=%d", uid);
		mysql_query(mysql, fmt_msg, false);
		
		SetPlayerData(to_player, P_FWARN, 0);
		SetPlayerData(to_player, P_FAMILY, 0);
	}

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET fwarn=%d WHERE id=%d", warns, uid);
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

CMD:funwarn(playerid, params[])
{
    new fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_UNWARN);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы снимать семейное предупреждение.");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /warn [id игрока] [причина (необязательно)]");

	extract params -> new to_player, string: reason[66];
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");

    if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя снять варн с самого себя");

	SetPlayerData(to_player, P_FWARN, 		0);
	UpdatePlayerDatabaseInt(to_player, "fwarn", 		0);

	new fmt_msg[128];

    format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] снял все предупреждения с игрока %s. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), reason);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	return 1;
}

CMD:fmute(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;new fam_id = GetPlayerData(playerid, P_FAMILY),
	    rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_MUTE);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы выдавать бан семейного чата.");


	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fmute [id игрока] [время в минутах] [причина (необязательно)]");

	extract params -> new to_player, mute_time, string: reason[30];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать мут заместителю/лидеру семьи");

	if(!(1 <= mute_time <= 360)) return SendClientMessage(playerid, 0xCECECEFF, "Время должно быть не меньше 1 и не больше 360 минут");
	if(GetPlayerData(to_player, P_FMUTE) > 0) return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока уже есть мут");
//	if(GetPlayerAdminEx(to_player) > GetPlayerAdminEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить затычку администратору выше по рангу");
	//else if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя поставить затычку самому себе");

	new fmt_msg[150];

	format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] поставил затычку игроку %s на %d минут. Причина: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), mute_time, reason);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	SetPlayerData(to_player, P_FMUTE, mute_time * 60);
	UpdatePlayerDatabaseInt(to_player, "fmute", mute_time * 60);

	SendClientMessage(to_player, 0xCECECEFF, "Время до окончания бана чата семейного чата: {CCCC00}/time");

	return 1;
}

CMD:funmute(playerid, params[])
{
    new fam_id = GetPlayerData(playerid, P_FAMILY),
        rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

    new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_UNMUTE);

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы снимать бан семейного чата.");


	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /funmute [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");

    if(to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя снять затычку с самого себя");

	else if(GetPlayerData(to_player, P_FMUTE) <= 0) return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет мута");

	new fmt_msg[100];

	format(fmt_msg, sizeof fmt_msg, "{%06x}[F] %s %s[%d] снял затычку с игрока %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id, rang_id), GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player));

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}

	SetPlayerData(to_player, P_FMUTE, 0);
	UpdatePlayerDatabaseInt(to_player, "fmute", 0);

	SendClientMessage(to_player, 0x32a44bFF, "Доступ в чат восстановлен");

	return 1;
}

CMD:finvite(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_INV);

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы приглашать людей в семью.");

	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
//	if(!(9 <= GetPlayerData(playerid, P_FAMILY_RANK) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна сотздателю семьи и его заместителям");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /finvite [id игрока]");

	extract params -> new to_player;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(GetPlayerData(to_player, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже состоит в семье");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_FINVITE);
	return 1;
}

CMD:funinvite(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_UNINV);

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы увольнять людей с семьи.");

	if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");
//	if(!(9 <= GetPlayerData(playerid, P_FAMILY_RANK) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна сотздателю семьи и его заместителям");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /funinvite [id игрока] [причина]");

	extract params -> new to_player, string:reason[32];

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= strlen(reason) <= 32))
		return SendClientMessage(playerid, 0xCECECEFF, "Введите причину увольнения");

	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY))
		return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");

	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK))
		return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить уволить заместителя/лидера организации");

	FUnInvite(playerid, to_player, reason);

	return 1;
}

CMD:frang(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вам недоступна данная функция");

	new rank = GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_RANG_GIVER);

	if(GetPlayerData(playerid, P_FAMILY_RANK) < rank) return Send(playerid, COR_RED, "[Ошибка]: "c_b" У вас не достаточно нужный ранг в семье, чтобы изменять ранги в семье.");

	//if(!(9 <= GetPlayerData(playerid, P_FAMILY_RANK) <= 10)) return SendClientMessage(playerid, 0xCECECEFF, "Функция доступна сотздателю семьи и его заместителям");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /frang [id игрока] [ранг]");
	extract params -> new to_player, give_rang;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid) return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(GetPlayerData(to_player, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок не состоит в Вашей семье");
	if(GetPlayerData(to_player, P_FAMILY_RANK) >= GetPlayerData(playerid, P_FAMILY_RANK)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить уволить заместителя/лидера организации");
	if(1 < give_rang > 9) return SendClientMessage(playerid, 0xCECECEFF, "Ранг от 1 до 9");

	new fmt_msg[256];

	SetPlayerData(to_player, P_FAMILY_RANK, give_rang);
	format(fmt_msg, sizeof fmt_msg, "Ваш ранг в семье был изменен на %d (%s)", GetPlayerData(to_player, P_FAMILY_RANK), GetFamilyRang(GetPlayerData(to_player, P_FAMILY), GetPlayerData(to_player, P_FAMILY_RANK)));
	SendClientMessage(to_player, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили ранг %s[%d] до %d (%s)",  GetPlayerNameEx(to_player), to_player, GetPlayerData(to_player, P_FAMILY_RANK), GetFamilyRang(GetPlayerData(to_player, P_FAMILY), GetPlayerData(to_player, P_FAMILY_RANK)));
	SendClientMessage(playerid, 0x1E90FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "UPDATE accounts SET family_rank=%d WHERE id=%d", GetPlayerData(to_player, P_FAMILY_RANK), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}
CMD:sellmyskin(playerid, params[])
{
	new skinid = GetPlayerData(playerid, P_SKIN);
	if(skinid == 252) return false;
	if(GetPlayerSkin(playerid) == 252) return SendClientMessage(playerid, -1, "{FFFF00}[Информация]{FFFFFF} Вы не можете продать скин!");
	if(!strlen(params))
	return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmyskin [id игрока] [стоимость]");

	extract params -> new to_player, price;
	if(price == 0) return false;
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

   	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится далеко от Вас");

	if(GetPlayerMoneyEx(to_player) < price)
		return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет такой суммы");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_SKIN, skinid, price);
	return 1;
}

CMD:f(playerid, params[])
{
	if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
	if(IsPlayerFMuted(playerid) > 0) return Send(playerid, -1, "У вас бан семейного чата");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /f [текст]");

	new fmt_msg[144],
		fam_id = GetPlayerData(playerid, P_FAMILY),
		rang_id = GetPlayerData(playerid, P_FAMILY_RANK) + 1;

	format(fmt_msg, sizeof fmt_msg, "{%06x}[%s] %s %s[%d]: %s", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyData(fam_id, F_NAME), GetFamilyRang(fam_id + 1, rang_id), GetPlayerNameEx(playerid), playerid, params);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}
	return 1;
}
alias:f("fam")

CMD:fn(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;if(GetPlayerData(playerid, P_FAMILY) == 0) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");
	if(IsPlayerMuted(playerid) > 0) return SendClientMessage(playerid, 0xCECECEFF, "Доступ в чат заблокирован. Время до разблокировки: {66CC33}/time");
	if(IsPlayerFMuted(playerid) > 0) return Send(playerid, -1, "У вас бан семейного чата");
	if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fn [текст]");

	new fmt_msg[144],
		fam_id = GetPlayerData(playerid, P_FAMILY) + 1,
		rang_id = GetPlayerData(playerid, P_FAMILY_RANK);

	format(fmt_msg, sizeof fmt_msg, "(( {%06x}OOC: [F] %s %s[%d]: %s ))", family_colors[GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_COLOR)] >>> 8, GetFamilyRang(fam_id + 1, rang_id), GetPlayerNameEx(playerid), playerid, params);

	for(new i; i < MAX_PLAYERS; i ++)
	{
		if(!IsPlayerConnected(i)) continue;
		if(!IsPlayerLogged(i)) continue;
		if(GetPlayerData(i, P_FAMILY) == 0) continue;
		if(GetPlayerData(i, P_ADVISOR_BLOCK_CHAT)) continue;

		if(GetPlayerData(i, P_FAMILY) != GetPlayerData(playerid, P_FAMILY)) continue;

		SendClientMessage(i, 0x6699CCFF, fmt_msg);
	}
	return 1;
}

stock ShowChangeNameDialog(playerid)
{
	if(GetPlayerData(playerid, P_DONATE_RUB) < 100) return SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно рублей, требуется 100");

	Dialog
	(
		playerid, DIALOG_FAMILY_NCHANGE, DIALOG_STYLE_INPUT,
		"Смена названия семьи",
		"{FFFFFF}Введите название, которое Вы хотите {ffff00}установить:",
		"Далее", "Отмена"
	);

	return 1;
}

stock ShowFamilyRangSetMenu(playerid)
{
	new fmt_text[800],
		fam_id = GetPlayerData(playerid, P_FAMILY);

 	format(fmt_text, sizeof fmt_text,
	""c_server"[1] "c_b"Команда /finvite | Ранг доступа: "c_i"%d+\n\
	"c_server"[2] "c_b"Команда /funinvite | Ранг доступа: "c_i"%d+\n\
	"c_server"[3] "c_b"Команда /fmute | Ранг доступа: "c_i"%d+\n\
	"c_server"[4] "c_b"Команда /funmute | Ранг доступа: "c_i"%d+\n\
	"c_server"[5] "c_b"Команда /fwarn | Ранг доступа: "c_i"%d+\n\
	"c_server"[6] "c_b"Команда /funwarn | Ранг доступа: "c_i"%d+\n\
	"c_server"[7] "c_b"Команда /frang | Ранг доступа: "c_i"%d+\n\
	"c_server"[8] "c_b"Взятие денег со склада | Ранг доступа: "c_i"%d+\n\
	"c_server"[9] "c_b"Взятие наркотиков со склада | Ранг доступа: "c_i"%d+\n\
	"c_server"[10] "c_b"Взятие Материалыа со склада | Ранг доступа: "c_i"%d+\n\
	"c_server"[11] "c_b"Взятие патронов со склада | Ранг доступа: "c_i"%d+",
	GetFamilyData(fam_id, F_RANG_INV),
	GetFamilyData(fam_id, F_RANG_UNINV),
	GetFamilyData(fam_id, F_RANG_MUTE),
	GetFamilyData(fam_id, F_RANG_UNMUTE),
	GetFamilyData(fam_id, F_RANG_WARN),
	GetFamilyData(fam_id, F_RANG_UNWARN),
	GetFamilyData(fam_id, F_RANG_GIVER),
	GetFamilyData(fam_id, F_TAKE_MONEY),
	GetFamilyData(fam_id, F_TAKE_DRUGS),
	GetFamilyData(fam_id, F_TAKE_METALL),
	GetFamilyData(fam_id, F_TAKE_AMMO));

	Dialog(playerid, DIALOG_FAMILY_SETRANG_MENU, DIALOG_STYLE_LIST, "Настройка доступа", fmt_text, "Далее", "Закрыть");
}

stock ShowFamilyHelpCommands(playerid)
{
	new fmt_text[800],
		fam_id = GetPlayerData(playerid, P_FAMILY);

 	format(fmt_text, sizeof fmt_text,
	""c_server"/finvite "c_b"- принять игрока в семью "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
	"c_server"/funinvite "c_b"- выгнать игрока с семьи "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
    "c_server"/fmute "c_b"- выдать бан семейного чата "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
    "c_server"/funmute "c_b"- снять бан семейного чата "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
    "c_server"/fwarn "c_b"- выдать семейное предупреждение "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
    "c_server"/funwarn "c_b"- снять семейное предупреждение "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
	"c_server"/frang "c_b"- сменить игроку ранг в семье "c_i"| "c_b"Ранг доступа: "c_server"%d+\n\
	"c_server"/f "c_b"- чат семьи\n\
	"c_server"/fn "c_b"- NonRP чат семьи\n\
	"c_server"/fpark "c_b"- припарковать семейный транспорт\n\
	"c_server"/sellfcar "c_b"- продать семейный транспорт",
	GetFamilyData(fam_id, F_RANG_INV),
	GetFamilyData(fam_id, F_RANG_UNINV),
	GetFamilyData(fam_id, F_RANG_MUTE),
	GetFamilyData(fam_id, F_RANG_UNMUTE),
	GetFamilyData(fam_id, F_RANG_WARN),
	GetFamilyData(fam_id, F_RANG_UNWARN),
	GetFamilyData(fam_id, F_RANG_GIVER));

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Команды семьи", fmt_text, "Закрыть", "");

}

CMD:setfcolor(playerid)
{
if(IsPlayerConnected(playerid)) return 1;Dialog
    (
        playerid, DIALOG_COLOR_FAMILY_SET, DIALOG_STYLE_MSGBOX,
        "Смена цвета семьи","Стоимость смены цвета семьи составляет: "c_m"20 донат-рублей\n\
		\n\
		"c_b"Вы уверены что хотите сменить цвет семьи?",
		"Далее", "Назад");
}

stock ShowFamilyColorSet(playerid)
{
    if(GetPlayerData(playerid, P_FAMILY_RANK) != 10) return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа");

    Dialog
    (
        playerid, DIALOG_FAMILY_COLOR, DIALOG_STYLE_LIST,
        "Смена цвета семьи",
		""c_server"[1] "f_2"Багровый\n\
		"c_server"[2] "f_3"Красный\n\
		"c_server"[3] "f_4"Темно-красный\n\
		"c_server"[4] "f_5"Светло-розовый\n\
		"c_server"[5] "f_6"Цвет кожи\n\
		"c_server"[6] "f_7"Желтый\n\
		"c_server"[7] "f_8"Золотой\n\
		"c_server"[8] "f_9"Фиолетовый\n\
		"c_server"[9] "f_10"Темно-фиолетовый\n\
		"c_server"[10] "f_11"Серый\n\
		"c_server"[11] "f_12"Серебристый\n\
		"c_server"[12] "f_13"Лайм\n\
		"c_server"[13] "f_14"Зеленый\n\
		"c_server"[14] "f_15"Лесной\n\
		"c_server"[15] "f_16"Синий\n\
		"c_server"[16] "f_17"Цвет неба",
        "Далее", "Назад"
    );

    return 1;

}

/*CMD:hihi(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;
	
	Send(playerid, -1,"test");

	SetPlayerData(playerid, P_HELPER, 0);
	UpdatePlayerDatabaseInt(playerid, "helper", 0);

	return 1;

}*/

CMD:addpadikadse(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	new fmt_text[300];


	new Cache: result,
		idx = g_entrance_loaded;

	GetPlayerPos(playerid, g_entrance[idx][E_POS_X], g_entrance[idx][E_POS_Y], g_entrance[idx][E_POS_Z]);

	SetEntranceData(idx, E_FLOORS,			2);

	//SetEntranceData(idx, _ENTRACE,		-1);

	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO entrances \
		(floors, x, y, z)\
		VALUES ('%d', '%f', '%f', '%f')",
		GetEntranceData(idx, E_FLOORS),
		GetEntranceData(idx, E_POS_X),
		GetEntranceData(idx, E_POS_Y),
		GetEntranceData(idx, E_POS_Z)
	);

	result = mysql_query(mysql, fmt_text, true);

	SetEntranceData(idx, E_SQL_ID, 		cache_insert_id());

	cache_delete(result);

	g_entrance_loaded ++;
	
	new e_houses = 0;

	UpdateEntrance(idx, e_houses);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), city);
	GetAreaName(GetEntranceData(idx, E_POS_X), GetEntranceData(idx, E_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал подъезд №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

	SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/esetexitpos {3399FF}- чтобы установить координаты выхода ");

	return 1;
}

CMD:esetexitpos(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new house_id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /esetexitpos [id подъезда]");

	if(!(0 <= house_id <= g_entrance_loaded - 1)) return SendClientMessage(playerid, 0x999999FF, "Данного подъезда не существует на сервере");

	GetPlayerPos(playerid, g_entrance[house_id][E_EXIT_POS_X], g_entrance[house_id][E_EXIT_POS_Y], g_entrance[house_id][E_EXIT_POS_Z]);
	GetPlayerFacingAngle(playerid, g_entrance[house_id][E_EXIT_ANGLE]);

	new fmt_text[144];

	format
	(
		fmt_text, sizeof fmt_text,
		"UPDATE entrances SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
		GetEntranceData(house_id, E_EXIT_POS_X),
		GetEntranceData(house_id, E_EXIT_POS_Y),
		GetEntranceData(house_id, E_EXIT_POS_Z),
		GetEntranceData(house_id, E_EXIT_ANGLE),
		GetEntranceData(house_id, E_SQL_ID)
	);

	mysql_query(mysql, fmt_text, false);

	format(fmt_text, sizeof fmt_text, "Вы успешно изменили координаты выхода у подэезда №%d", house_id);

	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

