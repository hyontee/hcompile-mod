//Автор: Welsi
//больше систем и работ в тг автора (https://t.me/welsistudio)
//Продажа сим-карты

//В КОНЕЦ МОДА
CMD:sellsim(playerid, params[])
{
	if(!(GetPlayerData(playerid, P_PHONE))) return SCM(playerid, -1, ""USC" У вас нет сим-карты");

	if(IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0x999999FF, "Нельзя использовать в машине");

	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellsum [id игрока] [price]");

	extract params -> new to_player, price;

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
	
	if(!(GetPlayerMoneyEx(to_player) >= price))
		return  SendClientMessage(playerid, -1, ""USC"У Игрока нет столько денег");
	
	if(!(price <= 100_000_000))
		return SendClientMessage(playerid, 0x999999FF, "Цена за вашу сим-карту превышает 100.000.000 р.");

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 4.0))
		return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");

	new text[84];

	format(text, sizeof text, "Игрок %s хочет продать вам сим-карту", GetPlayerNameEx(playerid));
	SCM(to_player, -1, text);

                //Автор: Welsi
            //больше систем и работ в тг автора (https://t.me/welsistudio)


	if(GetPVarInt(to_player, "player") || GetPVarInt(to_player, "price"))
	{
		DeletePVar(to_player, "player");
		DeletePVar(to_player, "price");
	}

	SetPVarInt(to_player, "player", playerid);
	SetPVarInt(to_player, "price", price);

	ShowNotification(to_player, 4, text, 7, "/sellyessum", ">>");

	return 1;
}
CMD:sellyessum(playerid)
{
	new to_player = GetPVarInt(playerid, "player"), 
	price = GetPVarInt(playerid, "price"), 
	text[214];

	if(!IsPlayerInRangeOfPlayer(playerid, to_player, 4.0))
	return SendClientMessage(playerid, 0x999999FF, "Игрок находится слишком далеко");
            //Автор: Welsi
            //больше систем и работ в тг автора (https://t.me/welsistudio)

	Dialog(to_player, -1, DIALOG_STYLE_MSGBOX, "Подождите...", "Игрок принимает решение...", "Закрыть", "");

	format(text, sizeof text, "Игрок:{FFFF00}%s {FFFFFF}предлагает вам купить\nего сим-карту:{FFFF00} %d {FFFFFF}за {FFFF00}%d {FFFFFF}рублей\n\
	Вы соглашаетесь на покупку сим-карты\n! После покупки - старая сим-карта удалиться",
	GetPlayerNameEx(to_player), GetPlayerPhone(to_player), price);

	Dialog(playerid, DIALOG_BUY_SIM, DIALOG_STYLE_MSGBOX, "Договор покупки Сим-Карты", text, "Соглашаюсь", "Отказаться");

	return 1;
}
//КО ВСЕМ ДИОЛОГАМ ГДЕ ОНИ ОБЬЯВЛЯЮТЬСЯ
DIALOG_BUY_SIM,
//В OnDialogResponse
	if(dialogid == DIALOG_BUY_SIM)
	{
		new to_player = GetPVarInt(playerid, "player"), 
		text[184],
		price = GetPVarInt(playerid, "price");

		if(response)
		{	
			format(text, sizeof text, "Вы купили сим-карту {D0FF00}%d {FFFFFF}у игрока {D0FF00}%s {FFFFFF}за {D0FF00}%d {FFFFFF}рублей", GetPlayerPhone(to_player), GetPlayerNameEx(to_player), price);
			SCM(playerid, -1, text);

			format(text, sizeof text, "Вы продали сим-карту {D0FF00}%d {FFFFFF}игроку {D0FF00}%s {FFFFFF}за {D0FF00}%d {FFFFFF}рублей", GetPlayerPhone(to_player), GetPlayerNameEx(playerid), price);
			SCM(to_player, -1, text);
			SetPlayerData(playerid, P_PHONE, GetPlayerPhone(to_player));
			UpdatePlayerDatabaseInt(playerid, "phone",  GetPlayerPhone(to_player));

			SetPlayerData(to_player, P_PHONE, 0);
			UpdatePlayerDatabaseInt(to_player, "phone", 0);

			GivePlayerMoneyEx(playerid, -price);
			GivePlayerMoneyEx(to_player, price);

            //Автор: Welsi
            //больше систем и работ в тг автора (https://t.me/welsistudio)

			DeletePVar(playerid, "player");
			DeletePVar(playerid, "price");
		}
		else
		{
			SCM(to_player, -1, ""USC" Игрок отказался");
			DeletePVar(playerid, "player");
			DeletePVar(playerid, "price");
		}
	}