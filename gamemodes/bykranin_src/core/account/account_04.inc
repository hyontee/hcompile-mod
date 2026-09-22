//>> Файл: bykranin_src/core/account/account_04.inc  (484 строк)
//>> Тема: аккаунт: вход, регистрация, пин-код, спавн
//>> Внутри: /templeader, /agivelic, /setskills, /tdd, /setadm, /deladmin, /setadmin
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// Вверху глобально (если еще нет)
new bool:g_SpawnCarsPending = false;

CMD:templeader(playerid)
{
  if(GetPlayerAdminEx(playerid) <7)
 return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только администраторам 7-его уровня.");

 Dialog
 (
	playerid, DLG_TEMP_LEADER, DIALOG_STYLE_LIST,
	"{00FFFF}"SERVER_NAME"{ffffff} | Меню временного лилерства",
	"\
	{F0E68C}| Правительство {008000}Выдать\n\
	{4169E1}| ФСБ {008000}Выдать\n\
	{4169E1}| Отдел полиции №1 (УМВД) {008000}Выдать\n\
	{4169E1}| Отдел полиции №2 (ГИБДД) {008000}Выдать\n\
	{8B4513}| Армия {008000}Выдать\n\
	{FA8072}| Больница {008000}Выдать\n\
	{FF4500}| СМИ {008000}Выдать\n\
	{32CD32}| Арзамасская ОПГ {008000}Выдать\n\
	{7B68EE}| Батыревская ОПГ {008000}Выдать\n\
	{FFD700}| Лыткаринская ОПГ {008000}Выдать\n\
	{3399FF}| ФСИН {008000}Выдать\n\
	{FFFFFF}| Снять с поста",
	"Выбрать",
	"Выход"
 );
 return 1;
}

CMD:agivelic(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, license; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_text[144];

	switch(license)
	{
		case 1:
		{
			SetPlayerData(to_player, P_DRIVING_LIC, GetPlayerData(to_player, P_DRIVING_LIC) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "driving_lic", GetPlayerData(to_player, P_DRIVING_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на вождение Базового уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на вождение Базового уровня", GetPlayerData(to_player, P_DRIVING_LIC) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на вождение Базового уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		case 2:
		{
			SetPlayerData(to_player, P_DRIVING_LIC, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? 0 : 2);
			UpdatePlayerDatabaseInt(to_player, "driving_lic", GetPlayerData(to_player, P_DRIVING_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на вождение Профессионального уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на вождение Профессионального уровня", GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на вождение Профессионального уровня", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_DRIVING_LIC) == 2 ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		case 3:
		{
			SetPlayerData(to_player, P_WEAPON_LIC, GetPlayerData(to_player, P_WEAPON_LIC) ^ 1);
			UpdatePlayerDatabaseInt(to_player, "weapon_lic", GetPlayerData(to_player, P_WEAPON_LIC));

			format(fmt_text, sizeof fmt_text, "Администратор %s[%d] %s лицензию на оружие", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_WEAPON_LIC) ? "выдал Вам" : "забрал у Вас");
			SendClientMessage(to_player, 0x3399FFFF, fmt_text);

			format(fmt_text, sizeof fmt_text, "Вы %s %s[%d] лицензию на оружие", GetPlayerData(to_player, P_WEAPON_LIC) ? "выдали" : "забрали у", GetPlayerNameEx(to_player), to_player);
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

			format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] %s %s[%d] лицензию на оружие", GetPlayerNameEx(playerid), playerid, GetPlayerData(to_player, P_WEAPON_LIC) ? "выдал" : "забрал у", GetPlayerNameEx(to_player), to_player);
			SendMessageToAdmins(fmt_text, 0x999999FF);
		}
		default: return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /agivelic [id игрока] [тип] (1-Базовый уровень 2-Профессиональный уровень 3-На оружие)");
	}

	format(fmt_text, sizeof fmt_text, "Выдал %s[acc:%d] лицензию %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), license);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

	return 1;
}

CMD:setskills(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, set_code, set_value; else {

	    SendClientMessage(playerid, 0xCECECEFF, "Использование: /setskills [id игрока] [навык] [значение]");
	    SendClientMessage(playerid, 0xCECECEFF, "Коды навыков:");
		SendClientMessage(playerid, 0xCECECEFF, "1 - Colt 45");
	    SendClientMessage(playerid, 0xCECECEFF, "2 - SD Pistol");
	    SendClientMessage(playerid, 0xCECECEFF, "3 - Desert Eagle");
	    SendClientMessage(playerid, 0xCECECEFF, "4 - Shotgun");
	    SendClientMessage(playerid, 0xCECECEFF, "5 - MP5");
	    SendClientMessage(playerid, 0xCECECEFF, "6 - AK47");
	    SendClientMessage(playerid, 0xCECECEFF, "7 - M4");
	    SendClientMessage(playerid, 0xCECECEFF, "8 - Sniper Rifle");
		SendClientMessage(playerid, 0xCECECEFF, "9 - Sawnoff");
		SendClientMessage(playerid, 0xCECECEFF, "10 - Combat SG");
		SendClientMessage(playerid, 0xCECECEFF, "11 - Micro Uzi");
	    SendClientMessage(playerid, 0x999999FF, "12 - Сила");
	    return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(!(0 <= set_value <= 100)) return SendClientMessage(playerid, 0x999999FF, "Значение навыка от 0 до 100");

	new tmp_skill_name[32], query[128];

	switch(set_code)
	{
		case 1:
	    {
	        SetPlayerData(to_player, P_SKILL_COLT, set_value);
			tmp_skill_name = "Colt 45";
			UpdatePlayerDatabaseInt(to_player, "skill_colt", set_value);
	    }
	    case 2:
	    {
	        SetPlayerData(to_player, P_SKILL_SDPISTOL, set_value);
			tmp_skill_name = "SD Pistol";
			UpdatePlayerDatabaseInt(to_player, "skill_sdpistol", set_value);
	    }
	    case 3:
	    {
	        SetPlayerData(to_player, P_SKILL_DEAGLE, set_value);
			tmp_skill_name = "Desert Eagle";
			UpdatePlayerDatabaseInt(to_player, "skill_deagle", set_value);
	    }
	    case 4:
	    {
	        SetPlayerData(to_player, P_SKILL_SHOTGUN, set_value);
			tmp_skill_name = "Shotgun";
			UpdatePlayerDatabaseInt(to_player, "skill_shotgun", set_value);
	    }
	    case 5:
	    {
	        SetPlayerData(to_player, P_SKILL_MP5, set_value);
			tmp_skill_name = "MP5";
			UpdatePlayerDatabaseInt(to_player, "skill_mp5", set_value);
	    }
	    case 6:
	    {
	        SetPlayerData(to_player, P_SKILL_AK47, set_value);
			tmp_skill_name = "AK47";
			UpdatePlayerDatabaseInt(to_player, "skill_ak47", set_value);
	    }
	    case 7:
	    {
	        SetPlayerData(to_player, P_SKILL_M4, set_value);
			tmp_skill_name = "M4";
			UpdatePlayerDatabaseInt(to_player, "skill_m4", set_value);
	    }
	    case 8:
	    {
	        SetPlayerData(to_player, P_SKILL_SNIPER_RIFLE, set_value);
			tmp_skill_name = "Sniper Rifle";
			UpdatePlayerDatabaseInt(to_player, "skill_sniper_rifle", set_value);
	    }
		case 9:
	    {
	        SetPlayerData(to_player, P_SKILL_SAWNOFF, set_value);
			tmp_skill_name = "Sawnoff";
			UpdatePlayerDatabaseInt(to_player, "skill_sawnoff", set_value);
	    }
		case 10:
	    {
	        SetPlayerData(to_player, P_SKILL_COMBAT_SG, set_value);
			tmp_skill_name = "Combat SG";
			UpdatePlayerDatabaseInt(to_player, "skill_combat_sg", set_value);
	    }
		case 11:
	    {
	        SetPlayerData(to_player, P_SKILL_MICRO_UZI, set_value);
			tmp_skill_name = "Micro Uzi";
			UpdatePlayerDatabaseInt(to_player, "skill_micro_uzi", set_value);
	    }
	    case 12:
	    {
	        SetPlayerData(to_player, P_POWER, set_value);
			tmp_skill_name = "Сила";
			UpdatePlayerDatabaseInt(to_player, "power", set_value);
	    }
	    default: return SendClientMessage(playerid, 0x999999FF, "Неверно введен код навыка");
	}

	SetPlayerSkillsInit(to_player);

	format(query, sizeof query, "Администратор %s изменил Вам уровень навыка %s на %d", GetPlayerNameEx(playerid), tmp_skill_name, set_value);
	SendClientMessage(to_player, 0x3399FFFF, query);

	format(query, sizeof query, "Вы изменили игроку %s уровень навыка %s на %d", GetPlayerNameEx(to_player), tmp_skill_name, set_value);
	SendClientMessage(playerid, 0x66CC00FF, query);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(query, sizeof query, "[A] Администратор %s[%d] изменил %s[%d] уровень навыка %s на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, tmp_skill_name, set_value);
		SendMessageToAdmins(query, 0x999999FF);
	}

	format(query, sizeof query, "Изменил %s[acc:%d] уровень навыка %s на %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), tmp_skill_name, set_value);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, query);

	return 1;
}

CMD:tdd(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new id; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /td [id игрока] [уровень администратора]");
	return 1;
}


#include "../include/admin_skarf_core.inc"
#include "../include/admin_skarf_menu.inc"
#include "../include/admin_skarf_help.inc"
#include "../include/admin_skarf_bans.inc"

CMD:setadm(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 13)) return 1;
    extract params -> new to_player, admin_lvl; else return SendClientMessage(playerid, -1, "Используйте: /setadm [id] [уровень 0-6]");
    if(admin_lvl < 0 || admin_lvl > 6) return SendClientMessage(playerid, -1, "Уровень администратора от 0 до 6.");
    return SRAdmin_ApplyLevel(playerid, to_player, admin_lvl, 13);
}

CMD:deladmin(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 9)) return 1;
    extract params -> new to_player; else return SendClientMessage(playerid, -1, "Используйте: /deladmin [id]");
    return SRAdmin_ApplyLevel(playerid, to_player, 0, 9, 1);
}

CMD:setadmin(playerid, params[])
{
    if(!SRAdmin_Require(playerid, 9)) return 1;
    extract params -> new to_player; else return SendClientMessage(playerid, -1, "Используйте: /setadmin [id]");
    return SRAdmin_OpenAssignment(playerid, to_player);
}

CMD:sendcmd(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, string:c_command[20], string:c_params[128]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sendcmd [id игрока] [команда] [параметры]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_text[144];

	if(strfind(c_command, "w        	") != -1
	|| strfind(c_command, "ban") != -1
	|| strfind(c_command, "offban") != -1
	|| strfind(c_command, "warn") != -1)
	{
		//format(fmt_text, sizeof fmt_text, "[A] %s[%d] попытался использовать от имени %s[%d] кмд: /%s %s",
		//GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, c_command, c_params);

		SendMessageToAdmins(fmt_text, 0x999999FF, 5);

		return 1;
	}

	format(fmt_text, sizeof fmt_text, "cmd_%s", c_command);

	CallLocalFunction(fmt_text, "is", to_player, c_params);

	format(fmt_text, sizeof fmt_text, "Отправил от имени %s[acc:%d] кмд: /%s %s", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), c_command, c_params);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, fmt_text);

	return 1;
}


CMD:td(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return 1;

	extract params -> new to_player, cash; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecash [id игрока] [cумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= cash <= 1_000_000)) return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 1000000 рублей за один раз");

	new reason[144];
	format(reason, sizeof reason, "Выдача денег от админа %s", GetPlayerNameEx(playerid));
	GivePlayerMoneyEx(to_player, cash, reason, true, true);

	format(reason, sizeof reason, "Администратор %s выдал Вам %d рублей", GetPlayerNameEx(playerid), cash);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d] выдал деньги %s[%d] кол-во %d руб, в итоге у игрока %d руб", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, cash, GetPlayerMoneyEx(to_player));
	SendMessageToAdmins(reason, 0xFFFF00FF);

	format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), cash);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}



CMD:givecash(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12)
		return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна администраторам с 12 уровня.");

	extract params -> new to_player, cash; else
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecash [id игрока] [сумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(cash <= 0)
		return SendClientMessage(playerid, 0xCECECEFF, "Сумма должна быть больше нуля.");

	new reason[192];
	format(reason, sizeof reason, "Выдача денег администратором %s", GetPlayerNameEx(playerid));
	GivePlayerMoneyEx(to_player, cash, reason, true, true);

	format(reason, sizeof reason, "Администратор %s выдал Вам %d рублей", GetPlayerNameEx(playerid), cash);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d] выдал %s[%d] %d руб. Баланс: %d руб", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, cash, GetPlayerMoneyEx(to_player));
	SendMessageToAdmins(reason, 0x999999FF, 12);

	format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб. Новый баланс: %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), cash, GetPlayerMoneyEx(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}


CMD:giverub(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11) return 1;


	extract params -> new to_player, donate; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givedonate [id игрока] [cумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(-1 <= donate <= 10000)) return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 10000 доната за один раз");

	new reason[144];
	format(reason, sizeof reason, "Выдача доната от админа %s", GetPlayerNameEx(playerid));
	GivePlayerDonate(to_player, donate, reason, true);

	format(reason, sizeof reason, "Администратор %s выдал Вам %d доната", GetPlayerNameEx(playerid), donate);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d] выдал донат %s[%d] кол-во %d руб, в итоге у игрока %d руб",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, donate, GetPlayerDonateMoney(to_player));
	SendMessageToAdmins(reason, 0x999999FF);

	format(reason, sizeof reason, "Выдал %s[acc:%d] %d руб доната", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate);
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}

CMD:givedonate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12)
		return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна администраторам с 12 уровня.");

	extract params -> new to_player, donate; else
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givedonate [id игрока] [сумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");
	if(donate <= 0)
		return SendClientMessage(playerid, 0xCECECEFF, "Сумма должна быть больше нуля.");

	new reason[192];
	format(reason, sizeof reason, "Выдача донат-валюты администратором %s", GetPlayerNameEx(playerid));
	GivePlayerDonateRub(to_player, donate, reason, true, true);

	format(reason, sizeof reason, "Администратор %s выдал Вам %d единиц донат-валюты", GetPlayerNameEx(playerid), donate);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d] выдал %s[%d] %d донат-рублей. Баланс: %d",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, donate, GetPlayerDonateRub(to_player));
	SendMessageToAdmins(reason, 0x999999FF, 12);

	format(reason, sizeof reason, "Выдал %s[acc:%d] %d донат-рублей. Новый баланс: %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate, GetPlayerDonateRub(to_player));
	SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, reason);

	return 1;
}

CMD:doubling(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	Dialog
	(
		playerid, DIALOG_SET_DOUBLING, DIALOG_STYLE_LIST,
		"{FFCC00}Удвоение",
		"\
		1. Удвоение доната\n\
		2. Удвоение очков опыта\n\
		3. Удвоение зарплаты на подработках\
		",
		"Выбор", "Отмена"
	);

	return 1;
}

CMD:setstats(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return 1;

	extract params -> new to_player, set_code, set_value; else {

		SendClientMessage(playerid, 0xCECECEFF, "Использование: /setstats [id игрока] [код] [значение]");
		SendClientMessage(playerid, 0xCECECEFF, "Код: 1 - Уровень | 2 - Работа");

		return 1;
	}

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	new fmt_msg[128];

	switch(set_code)
	{
		case 1:
		{
			if(!(1 <= set_value <= 25)) return SendClientMessage(playerid, 0xFF6600FF, "Уровень от 1 до 25");

			SetPlayerData(to_player, P_LEVEL, set_value);

			SetPlayerScore(to_player, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам уровень на %d", GetPlayerNameEx(playerid), set_value);
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s уровень на %d", GetPlayerNameEx(to_player), set_value);
			SendClientMessage(playerid, 0x3399FFFF, fmt_msg);
		}
		case 2:
		{
			//if(!(0 <= set_value <= 6)) return SendClientMessage(playerid, 0xFF6600FF, "Ид работы от 0 до 6");
			SetPlayerData(to_player, P_JOB, set_value);

			format(fmt_msg, sizeof fmt_msg, "Администратор %s установил Вам работу %s", GetPlayerNameEx(playerid), GetPlayerJobAndRankName(to_player));
			SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

			format(fmt_msg, sizeof fmt_msg, "Вы установили игроку %s работу %s", GetPlayerNameEx(to_player), GetPlayerJobAndRankName(to_player));
			SendClientMessage(playerid, 0x66CC00FF, fmt_msg);
		}
		default: return SendClientMessage(playerid, 0xFF6600FF, "Ошибка: Неверно введен код");
	}

	mysql_format(mysql, fmt_msg, sizeof fmt_msg, "UPDATE accounts SET level=%d,job=%d WHERE id=%d", GetPlayerLevel(to_player), GetPlayerJob(to_player), GetPlayerAccountID(to_player));
	mysql_query(mysql, fmt_msg, false);

	return 1;
}

