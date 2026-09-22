//>> Файл: bykranin_src/core/economy/economy_04.inc  (222 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: GetCarNumberPrice, /checknumber, /skill, /creategift, /donat, /donatee, /setspawn
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetCarNumberPrice(number[])
{
	if(strlen(number) != 6) return 0;

	new chars[4],
		price = GetDonatePrice(DONATE_PRICE_CAR_NUMBER);

	format(chars, sizeof chars, "%c%c%c", number[0], number[4], number[5]);

	if(!strcmp(chars, "amp", true)) price += 800;
	else if(!strcmp(chars, "ooo", true)) price += 700;
	else if(!strcmp(chars, "aaa", true)) price += 700;
	else if(!strcmp(chars, "ekx", true)) price += 600;
	else if(!strcmp(chars, "xam", true)) price += 600;
	else if(!strcmp(chars, "bop", true)) price += 300;
	else if(!strcmp(chars, "xep", true)) price += 200;
	else if(!strcmp(chars, "hax", true)) price += 200;
	else if(!strcmp(chars, "bbb", true)) price += 700;
	else if(!strcmp(chars, "ttt", true)) price += 700;
	else
	{
		if(chars[0] == chars[1] && chars[0] != chars[2]) price += 50;
		else if(chars[0] == chars[1] && chars[0] == chars[2]) price += 200;
		else if(chars[0] == chars[2] && chars[0] != chars[1]) price += 100;
	}

	if(number[1] == 0 && number[1] == 0) price += 200;
	else if(number[1] == number[2] && number[1] != number[3]) price += 150;
	else if(number[1] == number[2] && number[1] == number[3]) price += 250;

	return price;
}

CMD:checknumber(playerid, params[])
{
	extract params -> new string: number[7]; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /checknumber [номер]");

	if(strlen(number) != 6) return SendClientMessage(playerid, 0x999999FF, "Длина номера должна быть 6 символов");

	new fmt_text[90];
	format(fmt_text, sizeof fmt_text, "Стоимость введенного Вами номера: %d рублей", GetCarNumberPrice(number));
	SendClientMessage(playerid, 0x66CC33FF, fmt_text);

	return 1;
}

CMD:skill(playerid, params[])
{
	extract params -> new to_player; else return SendClientMessage(playerid, 0x999999FF, "Используйте: /skill [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");

	if(to_player == playerid)
	{
		ShowPlayerSkills(playerid);
		return Action(playerid, "просматривает свои навыки владения оружием", _, false);
	}

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	SendPlayerOffer(playerid, to_player, OFFER_TYPE_SHOW_SKILL);

	return 1;
}

CMD:creategift(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 5) return 1;

	new query[128],
		Cache: result,
		Float: X,
		Float: Y,
		Float: Z,
		idx = g_gift_loaded;

	GetPlayerPos(playerid, X, Y, Z);

	mysql_format(mysql, query, sizeof query, "INSERT INTO gift (x, y, z) VALUES (%f, %f, %f)", X, Y, Z);
	result = mysql_query(mysql, query, true);

	SetGiftData(idx, G_SQL_ID, 		cache_insert_id());

	SetGiftData(idx, G_POS_X,		X);
	SetGiftData(idx, G_POS_Y,		Y);
	SetGiftData(idx, G_POS_Z,		Z);

	CreatePickup
	(
		1279,
		23,
		X, Y, Z,
		-1,
		PICKUP_ACTION_TYPE_GIFT,
		idx
	);

	g_gift_loaded++;

	cache_delete(result);

	SendClientMessage(playerid, 0x32a44bFF, "Вы создали подарок!");

	return 1;
}

CMD:donat(playerid, params[])
{
  new fmt_str[500];
 
 format
 (
   fmt_str, sizeof(fmt_str),
   "{FFFFFF}В этом разделе Вы можете использовать дополнительные\n"\
   "возможности сервера. Чтобы получить к ним доступ,\n"\
   "необходимо пополнить свой игровой счёт. Описание всех\n"\
   "дополнительных возможностей, а также о способах\n"\
   "пополнения счёта Вы можете узнать на нашем сайте:\n"\
   "{32CD32}"SERVER_SITE" (раздел Донат)\n\n"\
   "{1E90FF}Информация:\n"\
   "{FFFFFF}Номер аккаунта:  %d\n"\
   "{FFFFFF}Текущее состояние счёта:  %d BC\n"\
   "{FFFFFF}Последние пополнение: %d BC\n"\
   "{FFFFFF}Общая сумма пополнение: %d BC\n",
   GetPlayerAccountID(playerid),
   GetPlayerDonateRub(playerid),
   GetPlayerLastDonation(playerid),
   GetPlayerTotalDonate(playerid)
  );
  return Dialog(playerid, DIALOG_DINFO, DIALOG_STYLE_MSGBOX, "{FF0000}Информация", fmt_str, "Далее", "Выйти");
}


CMD:donatee(playerid)
{
	ShowPlayerDonateMenu(playerid);
	return true;
}

CMD:setspawn(playerid, params[])

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
    return 1;
}

alias:setspawn("spawnchange")

CMD:setspawnpos(playerid)
{
    if(GetPlayerData(playerid, P_FAMILY) && GetPlayerData(playerid, P_FAMILY_RANK) == 10)
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
    return 1;
}

CMD:fleave(playerid, params[])
{
    //if(GetPlayerData(playerid, P_IMPROVEMENTS) < 2) return SendClientMessage(playerid, 0xCECECEFF, "Приобретите улучшение \"Решительность\", чтобы уволиться по собственному желанию");

    if(!GetPlayerData(playerid, P_FAMILY)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите в семье");

    new fmt_text[210];

    format
    (
        fmt_text, sizeof fmt_text,
        "{FFFFFF}Вы состоите в семье {ffff00} \"%s\".\n"\
        "{FFFFFF}Если Вы уволитесь, то потеряете все свои достижения в ней, такие как ранг.\n\n"\
        "Вы уверены, что хотите покинуть семью?",
        GetFamilyData(GetPlayerData(playerid, P_FAMILY), F_NAME)
    );

    Dialog(playerid, DIALOG_FAMILY_LEAVE, DIALOG_STYLE_MSGBOX, "{FF0000}Выйти из семьи.", fmt_text, "Уйти", "Отмена");

    return 1;
}

CMD:fmenu(playerid, params[])
{
    return ShowFamilyGui(playerid);
}
alias:fmenu("fm")


/*CMD:settint(playerid, params[])
{
	extract params -> new tint_id, tint_color; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /settint [id раскраски] [id цвета]");

	if(!(0 <= tint_id <= MAX_WEAPON_TINTS - 1)) return SendClientMessage(playerid, 0x999999FF, "Некорректный идентификатор раскраски");

	if(!(0 <= tint_color <= sizeof weapon_tints)) return SendClientMessage(playerid, 0x999999FF, "Некорректный идентификатор цвета");

	g_player[playerid][P_WEAPON_TINT][tint_id] = tint_color;

	SendClientMessage(playerid, -1, "Успешно изменено");

	return 1;
}*/

