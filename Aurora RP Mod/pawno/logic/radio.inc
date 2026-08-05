#if defined _radio_included
	#endinput
#endif
#define _radio_included

#define TABLE_RADIO						"radio_channels"
#define RADIO_CHANNEL_PLUS_OWNER_ID		10000
#define MAX_LOGIN_PASS_LENGHT			10

#define MAX_RADIO_FRACTION_CHANNEL		14 // 14 каналов гос.фрак

#define MAX_RADIO_BLACKLIST				50 // Максимальное количество игроков в ЧС канала

#define MAX_PERSONAL_RADIO_CHANNELS		3

#define IsFractionRadioChannel%0(%1)	(1 <= %1 <= MAX_RADIO_FRACTION_CHANNEL)

enum TEMP_RADIO_E {
	tRadioLogin[MAX_LOGIN_PASS_LENGHT + 2],
	tRadioPassword[MAX_LOGIN_PASS_LENGHT + 2],
	tCurrentLogin[MAX_LOGIN_PASS_LENGHT + 2],
	tTargetPlayerID
};
new TempRadioInfo[MAX_PLAYERS][TEMP_RADIO_E];

new PlayerRadioPassword[MAX_PLAYERS][MAX_PLAYER_RADIO_CHANNELS][MAX_LOGIN_PASS_LENGHT + 2];

stock radio_ChannelCreate(playerid) {
	playerListitemID[playerid][0] = -1;

	for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		if (PI[playerid][pRadioChannelsID][slotid]) 
			continue;
		playerListitemID[playerid][0] = slotid;
		break;
	}
	if (playerListitemID[playerid][0] == -1) {
		ErrorMessage(playerid, "У вас нет свободных из "#MAX_PLAYER_RADIO_CHANNELS" слотов, удалите один из каналов.");
		return false;
	}
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), "SELECT login FROM "TABLE_RADIO" WHERE login='%s' LIMIT 1",
		TempRadioInfo[playerid][tRadioLogin]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "radio_ChannelCreateCheck", "i", playerid);

	return true;
}
CB:radio_ChannelCreateCheck(playerid) {
	new rows;
	cache_get_row_count(rows);

	if (rows) {
		radio_ShowMenu(playerid, D_RADIO_CREATE_MENU);
		ErrorMessage(playerid, "Канал с таким идентификатором уже существует, используйте другой!");
		return;
	}
	MYSQL_GLOBAL[0] = EOS;

	if (strlen(TempRadioInfo[playerid][tRadioPassword]) < 4) {
		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"INSERT INTO "TABLE_RADIO" (login, password, owner) VALUES ('%e', '%e', '%e')",
			TempRadioInfo[playerid][tRadioLogin], "None", player_name[playerid]
		);
	} else {
		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"INSERT INTO "TABLE_RADIO" (login, password, owner) VALUES ('%e', '%e', '%e')",
			TempRadioInfo[playerid][tRadioLogin], MD5_Hash(TempRadioInfo[playerid][tRadioPassword]), player_name[playerid]
		);
	}
	new Cache:result = mysql_query(connects, MYSQL_GLOBAL);

	new slotid = playerListitemID[playerid][0];
	PI[playerid][pRadioChannelsID][slotid] = cache_insert_id();

	strmid(TempRadioInfo[playerid][tCurrentLogin], 
		TempRadioInfo[playerid][tRadioLogin], 0, strlen(TempRadioInfo[playerid][tRadioLogin]), MAX_LOGIN_PASS_LENGHT + 2
	);
	strmid(PlayerRadioPassword[playerid][slotid],
		TempRadioInfo[playerid][tRadioPassword], 0, strlen(TempRadioInfo[playerid][tRadioPassword]), MAX_LOGIN_PASS_LENGHT + 2
	);
	if (GetString(TempRadioInfo[playerid][tRadioPassword], "None"))
		TempRadioInfo[playerid][tRadioPassword][0] = EOS; 
	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
		"W"Поздравляем! Канал успешно создан.\n \n\
		"W"Идентификатор канала: "P"%s\n\
		"W"Пароль для подключения: "P"%s\n \n\
		"R"Сделайте скриншот (F8), чтобы не забыть!",
		TempRadioInfo[playerid][tCurrentLogin],
		TempRadioInfo[playerid][tRadioPassword]
	);
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, ""P"Информация", STRING_GLOBAL, "Закрыть", ""), STRING_GLOBAL[0] = EOS;

	TempRadioInfo[playerid][tRadioLogin][0] = EOS;
	TempRadioInfo[playerid][tRadioPassword][0] = EOS;

	PI[playerid][pRadioChannelID] = PI[playerid][pRadioChannelsID][slotid];
	radio_OnPlayerConnectChannel(playerid);
	SavePlayerRadio(playerid);

	SendOk(playerid, "Ваш канал успешно создан!");

	cache_delete(result);
}
stock radio_ChannelDestroy(playerid, id) {
	if (IsFractionRadioChannel(id)) {
		ErrorMessage(playerid, "Нельзя удалять фракционный канал!");
		return;
	}
	foreach (new i: Player) {
		if (!IsPlayerConnected(i)) continue;
		radio_ChannelRemove(i, id);
	}
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), "DELETE FROM "TABLE_RADIO" WHERE id=%i AND owner='%s' LIMIT 1", 
		id, player_name[playerid]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", "");

	SendOk(playerid, ""R"Вы успешно удалили свой канал!");
}
stock radio_ChannelRemove(playerid, id) {
	if (IsFractionRadioChannel(id)) {
		ErrorMessage(playerid, "Нельзя удалять фракционный канал!");
		return;
	}
	for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		if (PI[playerid][pRadioChannelsID][slotid] != id) 
			continue;
		if (PI[playerid][pRadioChannelID] == id) {
			radio_OnPlayerDisconnectChannel(playerid);
			PI[playerid][pRadioChannelID] = 0;
		}
		PI[playerid][pRadioChannelsID][slotid] = 0;

		SavePlayerRadio(playerid);
		SendOk(playerid, "Вы успешно удалили выбранный канал из списка!");
		break;
	}
}
stock radio_ChannelLoad(playerid) {
	for (new slotid = 0, channelid; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		channelid = PI[playerid][pRadioChannelsID][slotid];
		
		if (!channelid) continue;
		MYSQL_GLOBAL[0] = EOS;

		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"SELECT * FROM "TABLE_RADIO" WHERE `id`= %i LIMIT 1", channelid
		);
		new Cache:result = mysql_query(connects, MYSQL_GLOBAL), rows;
		cache_get_row_count(rows);

		if (!rows) {
			printf("channel %i not found.", channelid);
			PI[playerid][pRadioChannelsID][slotid] = 0;
		}
		cache_delete(result);
	}
	new channelid = PI[playerid][pRadioChannelID];
	PI[playerid][pRadioChannelID] = 0;
	if (channelid) radio_ChannelConnect(playerid, channelid);
}
stock radio_ChannelConnect(playerid, channelid) {
	for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		if (PI[playerid][pRadioChannelsID][slotid] != channelid) 
			continue;
		strmid(TempRadioInfo[playerid][tRadioPassword], 
			PlayerRadioPassword[playerid][slotid], 0, strlen(PlayerRadioPassword[playerid][slotid]), MAX_LOGIN_PASS_LENGHT + 2
		);
		break;
	}
	if (PI[playerid][pRadioChannelID] == channelid) {
		ErrorMessage(playerid, "Вы уже подключены к данному каналу.");
		return;
	}
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"SELECT id, password, login FROM "TABLE_RADIO" WHERE id=%i AND FIND_IN_SET(%i, blacklist) < 1 LIMIT 1", 
		channelid, PI[playerid][pID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "radio_CheckChannel", "isi", playerid, TempRadioInfo[playerid][tRadioLogin], 0);
}
CB:radio_CheckChannel(playerid, login[], add) {
	new rows;
	cache_get_row_count(rows);

	if (!rows) {
		ErrorMessage(playerid, "Канал с таким идентификатором не найден, либо вы в черном списке!");
		return;
	}
	new channelid;
	cache_get_value_name_int(0, "id", channelid);

	if (!IsFractionRadioChannel(channelid)) {
		new password[34];
		cache_get_value_name(0, "password", password, sizeof (password));

		if (!GetString(password, "None") && strlen(password) >= 4 && !GetString(MD5_Hash(TempRadioInfo[playerid][tRadioPassword]), password)) {
			ErrorMessage(playerid, "Введен неверный пароль от канала, возможно он был изменен!");
			return;
		}
	} else {
		if (add) {
			ErrorMessage(playerid, "Фракционный канал добавляется в список автоматически!");
			return;
		} else {
			if (channelid != radio_GetFractionChannelID(playerid)) {
				ErrorMessage(playerid, "У вас нет доступа к данному каналу рации!");
				return;
			}
		}
	}
	if (add) {
		new bool:isHave = false;
		for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
			if (PI[playerid][pRadioChannelsID][slotid] != channelid) 
				continue;
			isHave = true;
			break;
		}
		if (isHave) {
			ErrorMessage(playerid, "Канал с таким идентификатором уже у вас в списке!");
		}
		else radio_ChannelAdd(playerid, channelid);
	}
	else {
		for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
			if (PI[playerid][pRadioChannelsID][slotid] != channelid) 
				continue;
			cache_get_value_name(0, "login", TempRadioInfo[playerid][tCurrentLogin], MAX_LOGIN_PASS_LENGHT + 2);

			PI[playerid][pRadioChannelID] = channelid;
			radio_OnPlayerConnectChannel(playerid);

			/*format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Вы успешно подключились к каналу - \"%s\"!",
				TempRadioInfo[playerid][tCurrentLogin]
			);
			SendOk(playerid, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;*/

			SavePlayerRadio(playerid);
			break;
		}
	}
}
stock radio_ChannelAdd(playerid, channelid) {
	new free_slotid = -1;

	for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		if (PI[playerid][pRadioChannelsID][slotid] != 0) 
			continue;
		free_slotid = slotid;
		break;
	}
	if (free_slotid == -1) {
		ErrorMessage(playerid, "У вас нет свободных из "#MAX_PLAYER_RADIO_CHANNELS" слотов, удалите один из каналов.");
		return false;
	}
	PI[playerid][pRadioChannelsID][free_slotid] = channelid;

	if (!strlen(TempRadioInfo[playerid][tRadioPassword])) {
		strmid(TempRadioInfo[playerid][tRadioPassword], "0", 0, strlen("0"), MAX_LOGIN_PASS_LENGHT + 2);
	}
	strmid(PlayerRadioPassword[playerid][free_slotid], 
		TempRadioInfo[playerid][tRadioPassword], 0, strlen(TempRadioInfo[playerid][tRadioPassword]), MAX_LOGIN_PASS_LENGHT + 2
	);
	SavePlayerRadio(playerid);

	SendOk(playerid, "Канал успешно добавлен в список. Используйте - "P"/radio - \"Мои каналы\""G".");

	return true;
}
stock radio_Blacklist(playerid, channelid, target_name[], add = 1) {
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"SELECT pID FROM "TABLE_ACCOUNTS" WHERE Name='%e' AND FIND_IN_SET(%i, radioChannelsID) > 0 LIMIT 1",
		target_name, channelid
	);
	new Cache:result = mysql_query(connects, MYSQL_GLOBAL), rows;
	cache_get_row_count(rows);

	TempRadioInfo[playerid][tTargetPlayerID] = 0;

	if (!rows) {
		ErrorMessage(playerid, "Игрок с таким никнеймом не найден в списке вашего канала!");
		cache_delete(result);
		return;
	}
	cache_get_value_name_int(0, "pID", TempRadioInfo[playerid][tTargetPlayerID]);
	cache_delete(result);

	MYSQL_GLOBAL[0] = EOS;

	if (add) {
		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"SELECT blacklist FROM "TABLE_RADIO" WHERE id=%i LIMIT 1", channelid
		);
	} else {
		mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
			"SELECT blacklist FROM "TABLE_RADIO" WHERE id=%i LIMIT 1", channelid
		);
	}
	mysql_tquery(connects, MYSQL_GLOBAL, "radio_BlacklistAction", "iisi", playerid, channelid, target_name, add);
}
CB:radio_BlacklistAction(playerid, channelid, target_name[], add) {
	new rows;
	cache_get_row_count(rows);
	if (!rows) {
		ErrorMessage(playerid, "Данный игрок не состоит в вашем канале!");
		return;
	}
	new blacklistArray[MAX_RADIO_BLACKLIST * 5 + 2];
	cache_get_value_name(0, "blacklist", blacklistArray);
	sscanf(blacklistArray, "p<,>a<i>["#MAX_RADIO_BLACKLIST"]", blacklistArray);

	new free_slotid = -1;
	if (add) {
		for (new i = 0; i < MAX_RADIO_BLACKLIST; i++) {
			if (blacklistArray[i] != 0) {
				if (blacklistArray[i] == TempRadioInfo[playerid][tTargetPlayerID]) {
					free_slotid = -2;
					break;
				}
				continue;
			}
			if (free_slotid == -1) free_slotid = i;
		}
		if (free_slotid == -1) {
			ErrorMessage(playerid, "В черном списке максимальное количество игроков! ("#MAX_RADIO_BLACKLIST")");
			return;
		}
		if (free_slotid == -2) {
			ErrorMessage(playerid, "Данный игрок уже находится в черном списке!");
			return;
		}
		blacklistArray[free_slotid] = TempRadioInfo[playerid][tTargetPlayerID];

		foreach (new i: Player) {
			if (!IsPlayerConnected(i) || !TI[i][tLogin]) continue;
			if (PI[i][pID] != TempRadioInfo[playerid][tTargetPlayerID]) continue;

			if (PI[i][pRadioChannelID] == channelid) {
				radio_OnPlayerDisconnectChannel(i);
				PI[i][pRadioChannelID] = 0;
			}
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s занес Вас в черный список одного из каналов рации.",
				player_name[playerid]
			);
			SendOk(i, STRING_GLOBAL);
			break;
		}
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Игрок %s успешно занесен в черный список вашего канала.", target_name);
		SendOk(playerid, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
	} else {
		for (new i = 0; i < MAX_RADIO_BLACKLIST; i++) {
			if (blacklistArray[i] != TempRadioInfo[playerid][tTargetPlayerID]) 
				continue;
			free_slotid = i;
			break;
		}
		if (free_slotid == -1) {
			ErrorMessage(playerid, "Данный игрок не состоит в черном списке вашего канала!");
			return;
		}
		blacklistArray[free_slotid] = 0;

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Игрок %s успешно убран из черного списока вашего канала.", target_name);
		SendOk(playerid, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
	}
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"UPDATE "TABLE_RADIO" SET blacklist='\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i' WHERE id=%i LIMIT 1", 

		blacklistArray[0], blacklistArray[1], blacklistArray[2], blacklistArray[3], blacklistArray[4], 
		blacklistArray[5], blacklistArray[6], blacklistArray[7], blacklistArray[8], blacklistArray[9], 
		blacklistArray[10], blacklistArray[11], blacklistArray[12], blacklistArray[13], blacklistArray[14], 
		blacklistArray[15], blacklistArray[16], blacklistArray[17], blacklistArray[18], blacklistArray[19], 
		blacklistArray[20], blacklistArray[21], blacklistArray[22], blacklistArray[23], blacklistArray[24], 
		blacklistArray[25], blacklistArray[26], blacklistArray[27], blacklistArray[28], blacklistArray[29], 
		blacklistArray[30], blacklistArray[31], blacklistArray[32], blacklistArray[33], blacklistArray[34], 
		blacklistArray[35], blacklistArray[36], blacklistArray[37], blacklistArray[38], blacklistArray[39], 
		blacklistArray[40], blacklistArray[41], blacklistArray[42], blacklistArray[43], blacklistArray[44], 
		blacklistArray[45], blacklistArray[46], blacklistArray[47], blacklistArray[48], blacklistArray[49],
		channelid
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", "");

	TempRadioInfo[playerid][tTargetPlayerID] = 0;
}
stock radio_ShowMenu(playerid, menuid) {
	STRING_GLOBAL[0] = COMMAND_GLOBAL[0] = EOS;

	switch (menuid) {
		case D_RADIO_MENU: {
			TempRadioInfo[playerid][tRadioLogin][0] = EOS;
			TempRadioInfo[playerid][tRadioPassword][0] = EOS;

			new tag[32];

			if (strlen(PI[playerid][pRadioTag]) < RADIO_MIN_TAG_SYMBOLS) 
				format(tag, sizeof (tag), ""R"Не установлен"G"");
			else format(tag, sizeof (tag), PI[playerid][pRadioTag]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Добавить канал\n\
				"P"2. "W"Создать личный канал\n\
				"P"3. "W"Мои каналы\n\
				"P"4. "W"Личный тег "G"[%s]\n", tag
			);
			if (PI[playerid][pRadioChannelID]) {
				format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), 
					""P"5. Участники канала онлайн "G"[R:%s]", TempRadioInfo[playerid][tCurrentLogin]
				);
				strcat(STRING_GLOBAL, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
			}
			ShowPlayerDialog(playerid, D_RADIO_MENU, DIALOG_STYLE_LIST, ""P"Рация", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_RADIO_CREATE_MENU: {
			new login[32], password[32];

			if (strlen(TempRadioInfo[playerid][tRadioLogin]) < RADIO_MIN_TAG_SYMBOLS) 
				format(login, sizeof (login), ""R"Не установлен");
			else format(login, sizeof (login), TempRadioInfo[playerid][tRadioLogin]);

			if (strlen(TempRadioInfo[playerid][tRadioPassword]) < RADIO_MIN_TAG_SYMBOLS) 
				format(password, sizeof (password), ""G"Не установлен");
			else format(password, sizeof (password), TempRadioInfo[playerid][tRadioPassword]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Идентификатор: "P"%s\n\
				"P"2. "W"Пароль: "P"%s\n\
				"G">> "P"Создать канал",
				login, password
			);
			ShowPlayerDialog(playerid, D_RADIO_CREATE_MENU, DIALOG_STYLE_LIST, ""P"Создание канала", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case D_RADIO_CREATE_LOGIN: {
			ShowPlayerDialog(playerid, D_RADIO_CREATE_LOGIN, DIALOG_STYLE_INPUT, ""P"Идентификатор канала", "\
				"W"Введите название канала:\n \n\
				"G"Примечание: длина символов должна быть не менее 4 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
				Например: RadioChannel1",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CREATE_PASSWORD: {
			ShowPlayerDialog(playerid, D_RADIO_CREATE_PASSWORD, DIALOG_STYLE_INPUT, ""P"Пароль канала", "\
				"W"Введите пароль для подключения к каналу:\n \n\
				"G"Примечание: длина символов должна быть не менее 4 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
				Например: qwerty123",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CONNECT: {
			new login[32], password[32];

			if (strlen(TempRadioInfo[playerid][tRadioLogin]) < RADIO_MIN_TAG_SYMBOLS) 
				format(login, sizeof (login), ""R"Не введен");
			else format(login, sizeof (login), TempRadioInfo[playerid][tRadioLogin]);

			if (strlen(TempRadioInfo[playerid][tRadioPassword]) < RADIO_MIN_TAG_SYMBOLS) 
				format(password, sizeof (password), ""G"Не введен");
			else format(password, sizeof (password), TempRadioInfo[playerid][tRadioPassword]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Идентификатор: "P"%s\n\
				"P"2. "W"Пароль: "P"%s\n\
				"G">> "P"Подключиться к каналу",
				login, password
			);
			ShowPlayerDialog(playerid, D_RADIO_CONNECT, DIALOG_STYLE_LIST, ""P"Подключиться к каналу", STRING_GLOBAL, "Выбрать", "Отмена");
		}
		case D_RADIO_CONNECT_LOGIN: {
			ShowPlayerDialog(playerid, D_RADIO_CONNECT_LOGIN, DIALOG_STYLE_INPUT, ""P"Идентификатор канала", "\
				"W"Введите название канала:\n \n\
				"G"Примечание: длина символов должна быть не менее 3 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
				Например: RadioChannel1",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CONNECT_PASSWORD: {
			ShowPlayerDialog(playerid, D_RADIO_CONNECT_PASSWORD, DIALOG_STYLE_INPUT, ""P"Пароль канала", "\
				"W"Введите пароль для подключения к каналу:\n \n\
				"G"Примечание: длина символов должна быть не менее 4 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
				Например: qwerty123",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CHANNELS: {
			MYSQL_GLOBAL[0] = EOS;

			mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
				"SELECT * FROM "TABLE_RADIO" WHERE \
				(`id` IN (%i,%i,%i,%i,%i,%i,%i,%i,%i,%i)) AND `id` != 0 LIMIT %i", 
				PI[playerid][pRadioChannelsID][0], PI[playerid][pRadioChannelsID][1],
				PI[playerid][pRadioChannelsID][2], PI[playerid][pRadioChannelsID][3],
				PI[playerid][pRadioChannelsID][4], PI[playerid][pRadioChannelsID][5],
				PI[playerid][pRadioChannelsID][6], PI[playerid][pRadioChannelsID][7],
				PI[playerid][pRadioChannelsID][8], PI[playerid][pRadioChannelsID][9],
				/*,radio_GetFractionChannelID(playerid), MAX_PLAYER_RADIO_CHANNELS + 1 OR `id`=%i */
				MAX_PLAYER_RADIO_CHANNELS
			);
			new Cache:result = mysql_query(connects, MYSQL_GLOBAL), rows;
			cache_get_row_count(rows);

			if (!rows) {
				ShowPlayerDialog(playerid, D_RADIO_CHANNELS, DIALOG_STYLE_MSGBOX, ""P"Мои каналы", 
					""G"Список ваших каналов пуст, подключитесь хотя бы к одному!", 
					"Назад", ""
				);
				playerListitemID[playerid][0] = -1;
				cache_delete(result);
				return false;
			}
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"Идентификатор\t"P"Тип канала\t"P"Дата создания\n");

			new type[20], login[MAX_LOGIN_PASS_LENGHT + 2], password[MAX_LOGIN_PASS_LENGHT + 2], created[22], owner[MAX_PLAYER_NAME + 2], fraction;
			for (new i = 0; i < rows; i++) {
				cache_get_value_name_int(i, "id", playerListitemID[playerid][i]);
				cache_get_value_name(i, "owner", owner, sizeof (owner));
				cache_get_value_name(i, "login", login, sizeof (login));
				cache_get_value_name(i, "password", password, sizeof (password));
				cache_get_value_name(i, "date", created, sizeof (created));
				cache_get_value_name_int(i, "fraction", fraction);

				if (GetString(password, "None") || strlen(password) < 4) 
					format(type, sizeof (type), "{6B8E23}[открытый]");
				else format(type, sizeof (type), "{B22222}[закрытый]");

				if (fraction) {
					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%i. {%06x}%s\t%s\t"G"[%s]\n", 
						i + 1, (gFractionSpawn[PI[playerid][pMember]][fracColor] >>> 8), 
						login, type, created
					);
				}
				else if (GetString(owner, player_name[playerid])) {
					playerListitemID[playerid][i] += RADIO_CHANNEL_PLUS_OWNER_ID;

					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%i. {6B8E23}%s\t%s\t"G"[%s]\n", 
						i + 1, login, type, created
					);
				} else {
					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%i. "W"%s\t%s\t"G"[%s]\n", 
						i + 1, login, type, created
					);
				}
				strcat(STRING_GLOBAL, COMMAND_GLOBAL);
			}

			ShowPlayerDialog(playerid, D_RADIO_CHANNELS, DIALOG_STYLE_TABLIST_HEADERS, ""P"Мои каналы", STRING_GLOBAL, "Выбрать", "Назад"), STRING_GLOBAL[0] = EOS;
			cache_delete(result);
		}
		case D_RADIO_CHANNEL_BLACKLIST: {
			ShowPlayerDialog(playerid, D_RADIO_CHANNEL_BLACKLIST, DIALOG_STYLE_LIST, ""P"Черный список", "\
				"P"1. "W"Посмотреть черный список\n\
				"P"2. "W"Добавить в черный список\n\
				"P"3. "W"Убрать из черного списка",
				"Выбрать", "Назад"
			);
		}
		case D_RADIO_CHANNEL_BL_LIST: {
			new id = playerListitemID[playerid][0];
			if (id > RADIO_CHANNEL_PLUS_OWNER_ID) id -= RADIO_CHANNEL_PLUS_OWNER_ID;

			MYSQL_GLOBAL[0] = EOS;

			mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
				"SELECT Name FROM "TABLE_ACCOUNTS" WHERE FIND_IN_SET(pID, (SELECT blacklist FROM "TABLE_RADIO" WHERE id=%i)) ORDER BY Name", id
			);
			new Cache:result = mysql_query(connects, MYSQL_GLOBAL), rows, idx = 1;
			cache_get_row_count(rows);

			if (!rows) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""G"Черный список пуст.");
			} 
			else {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""G"В черном списке канала находятся:\n \n");

				for (new i = 0, owner[MAX_PLAYER_NAME + 2]; i < rows; i++) {
					cache_get_value_name(i, "Name", owner, sizeof (owner));

					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%i. "W"%s\n", idx++, owner);
					strcat(STRING_GLOBAL, COMMAND_GLOBAL);
				}
			}
			ShowPlayerDialog(playerid, D_RADIO_CHANNEL_BL_LIST, DIALOG_STYLE_MSGBOX, ""P"Черный список", STRING_GLOBAL, "Назад", "");
			cache_delete(result);
		}
		case D_RADIO_CHANNEL_BL_ADD: {
			ShowPlayerDialog(playerid, D_RADIO_CHANNEL_BL_ADD, DIALOG_STYLE_INPUT, ""P"Добавление в ЧС", "\
				"W"Введите никнейм игрока, которого хотите занести в ЧС канала:",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CHANNEL_BL_REMOVE: {
			ShowPlayerDialog(playerid, D_RADIO_CHANNEL_BL_REMOVE, DIALOG_STYLE_INPUT, ""P"Удаление из ЧС", "\
				"W"Введите никнейм игрока, которого хотите вынести из ЧС канала:",
				"Принять", "Назад"
			);
		}
		case D_RADIO_CHANNEL_MEMBERS: {
			new id = playerListitemID[playerid][0];
			if (!id) return radio_ShowMenu(playerid, D_RADIO_CHANNEL_MENU);
			if (id > RADIO_CHANNEL_PLUS_OWNER_ID) id -= RADIO_CHANNEL_PLUS_OWNER_ID;

			MYSQL_GLOBAL[0] = EOS;

			mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
				"SELECT Name, radioTag  FROM "TABLE_ACCOUNTS" WHERE FIND_IN_SET(%i, radioChannelsID) > 0 ORDER BY Name", id
			);
			new Cache:result = mysql_query(connects, MYSQL_GLOBAL), rows;
			cache_get_row_count(rows);

			if (!rows) {
				radio_ShowMenu(playerid, D_RADIO_CHANNEL_MENU);
				cache_delete(result);
				return false;
			}
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"Участники канала:\n \n");
			for (new i = 0, targetid, owner[MAX_PLAYER_NAME + 2], tag[RADIO_MAX_TAG_SYMBOLS + 2]; i < rows; i++) {
				cache_get_value_name(i, "Name", owner, sizeof (owner));
				cache_get_value_name(i, "radioTag", tag, sizeof (tag));
				
				targetid = GetPlayerID(owner);
				if (strlen(tag) >= RADIO_MIN_TAG_SYMBOLS) {
					if (targetid != INVALID_PLAYER_ID) {
						format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. "G"[%s] "W"%s\n", i+1, tag, owner);
					} else {
						format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. "G"[%s] {6B8E23}%s [%i]\n", i+1, tag, owner, targetid);
					}
				} else {
					if (targetid != INVALID_PLAYER_ID) {
						format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. "W"%s\n", i+1, owner);
					} else {
						format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. {6B8E23}%s [%i]\n", i+1, owner, targetid);
					}
				}
				strcat(STRING_GLOBAL, COMMAND_GLOBAL);
			}
			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\n"G"Всего участников в канале: %i.\n", rows);
			strcat(STRING_GLOBAL, COMMAND_GLOBAL);

			ShowPlayerDialog(playerid, D_RADIO_CHANNEL_MEMBERS, DIALOG_STYLE_MSGBOX, ""P"Список участников канала", STRING_GLOBAL, "Назад", "");
			cache_delete(result);
		}
		case D_RADIO_CHANNEL_MENU: {
			new id = playerListitemID[playerid][0];
			if (!id) return radio_ShowMenu(playerid, D_RADIO_CHANNELS);

			if (id > RADIO_CHANNEL_PLUS_OWNER_ID) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
					"P"1. "W"Подключиться к каналу\n\
					"P"2. "W"Список участников\n\
					"P"3. "W"Изменить пароль канала\n\
					"P"4. "G"Черный список\n"
				);
				if (!IsFractionRadioChannel(id)) 
					strcat(STRING_GLOBAL, ""P"5. "R"Удалить канал");
				ShowPlayerDialog(playerid, D_RADIO_CHANNEL_MENU_1, DIALOG_STYLE_LIST, ""P"Управление личным каналом", STRING_GLOBAL, "Выбрать", "Назад");
			} else {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
					"P"1. "W"Подключиться к каналу\n\
					"P"2. "W"Изменить пароль подключения\n"
				);
				if (!IsFractionRadioChannel(id)) 
					strcat(STRING_GLOBAL, ""P"3. "R"Удалить из списка");
				ShowPlayerDialog(playerid, D_RADIO_CHANNEL_MENU_2, DIALOG_STYLE_LIST, ""P"Управление чужим каналом", STRING_GLOBAL, "Выбрать", "Назад");
			}
		}
		case D_RADIO_EDIT_TAG: {
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"W"Введите новый личный тег:\n\
				"W"Ваш текущий тег: "P"[%s]\n \n\
				"G"Примечание: длина символов должна быть не менее "#RADIO_MIN_TAG_SYMBOLS" и не более "#RADIO_MAX_TAG_SYMBOLS" символов.",
				PI[playerid][pRadioTag]
			);
			ShowPlayerDialog(playerid, D_RADIO_EDIT_TAG, DIALOG_STYLE_INPUT, ""P"Изменение тега", STRING_GLOBAL, "Принять", "Назад");
		}
		case D_RADIO_CHANNEL_PASSWORD: {
			new id = playerListitemID[playerid][0];

			if (id > RADIO_CHANNEL_PLUS_OWNER_ID) {
				id -= RADIO_CHANNEL_PLUS_OWNER_ID;

				if (IsFractionRadioChannel(id)) 
					return ErrorMessage(playerid, "Нельзя изменить пароль от фракционного канала!");
				ShowPlayerDialog(playerid, D_RADIO_CHANNEL_PASSWORD_1, DIALOG_STYLE_INPUT, ""P"Изменение пароля канала", "\
					"W"Введите новый пароль канала:\n \n\
					"G"Примечание: длина символов должна быть не менее 4 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
					Например: qwerty123", "Принять", "Назад"
				);
			} else {
				if (IsFractionRadioChannel(id)) 
					return ErrorMessage(playerid, "Нельзя изменить пароль от фракционного канала!");
				ShowPlayerDialog(playerid, D_RADIO_CHANNEL_PASSWORD_2, DIALOG_STYLE_INPUT, ""P"Изменение пароля подключения", "\
					"W"Введите новый пароль для подключения к каналу:\n \n\
					"G"Примечание: длина символов должна быть не менее 4 и не более "#MAX_LOGIN_PASS_LENGHT" символов.\n\
					Например: qwerty123", "Принять", "Назад"
				);
			}
		}
		case D_RADIO_ONLINE: {
			if (!PI[playerid][pRadioChannelID])
				return ErrorMessage(playerid, "Вы не подключены ни к одному каналу! Используйте - /radio.");
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"Участники канала \"%s\" онлайн:\n \n",
				TempRadioInfo[playerid][tCurrentLogin]
			);
			new amount;
			foreach (new i: Player) {
				if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) 
					continue;
				if (PI[i][pRadioChannelID] != PI[playerid][pRadioChannelID])
					continue;
				if (!ItemContains(i, 501)) continue;
				amount++;

				if (strlen(PI[i][pRadioTag]) >= RADIO_MIN_TAG_SYMBOLS) {
					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. "G"[%s] "W"%s[%i]\n",
						amount, PI[i][pRadioTag], player_name[i], i
					);
				} else {
					format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t"P"%i. "W"%s[%i]\n",
						amount, player_name[i], i
					);
				}
				strcat(STRING_GLOBAL, COMMAND_GLOBAL);
			}
			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\n"G"Всего участников онлайн: %i.\n", amount);
			strcat(STRING_GLOBAL, COMMAND_GLOBAL);

			ShowPlayerDialog(playerid, D_RADIO_ONLINE, DIALOG_STYLE_MSGBOX, ""P"Участники канала", STRING_GLOBAL, "Закрыть", "");
		}
	}
	STRING_GLOBAL[0] = COMMAND_GLOBAL[0] = EOS;

	return true;
}
stock SavePlayerRadio(playerid) {
	MYSQL_GLOBAL[0] = EOS;

	for (new slotid = 0; slotid < MAX_PLAYER_RADIO_CHANNELS; slotid++) {
		if (PI[playerid][pRadioChannelsID][slotid])
			continue;
		strmid(PlayerRadioPassword[playerid][slotid], "0", 0, strlen("0"), MAX_LOGIN_PASS_LENGHT + 2);
	}
	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE accounts SET \
		radioPasswords='%e,%e,%e,%e,%e,%e,%e,%e,%e,%e',\
		radioID=%i, radioChannelsID='%i,%i,%i,%i,%i,%i,%i,%i,%i,%i', radioTag='%s' \
		WHERE `pID` = '%d' LIMIT 1", 

		PlayerRadioPassword[playerid][0], PlayerRadioPassword[playerid][1], PlayerRadioPassword[playerid][2], 
		PlayerRadioPassword[playerid][3], PlayerRadioPassword[playerid][4], PlayerRadioPassword[playerid][5], 
		PlayerRadioPassword[playerid][6], PlayerRadioPassword[playerid][7], PlayerRadioPassword[playerid][8], 
		PlayerRadioPassword[playerid][9],

		PI[playerid][pRadioChannelID], 

		PI[playerid][pRadioChannelsID][0], PI[playerid][pRadioChannelsID][1], PI[playerid][pRadioChannelsID][2], 
		PI[playerid][pRadioChannelsID][3], PI[playerid][pRadioChannelsID][4], PI[playerid][pRadioChannelsID][5], 
		PI[playerid][pRadioChannelsID][6], PI[playerid][pRadioChannelsID][7], PI[playerid][pRadioChannelsID][8], 
		PI[playerid][pRadioChannelsID][9], PI[playerid][pRadioTag],

		PI[playerid][pID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL), MYSQL_GLOBAL[0] = EOS;

	return true;
}
stock radio_SendMessage(channel, const result[]) {
	foreach (new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) 
			continue;
		if (PI[i][pRadioChannelID] != channel)
			continue;
		if (!ItemContains(i, 501)) continue;
		SendClientMessage(i, 0x31cf63FF, result);
	}
}
stock radio_OnPlayerConnectChannel(playerid) {
	if (!PI[playerid][pRadioChannelID]) return;

	if (strlen(PI[playerid][pRadioTag]) < RADIO_MIN_TAG_SYMBOLS) {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] Соединение с %s было установлено.", 
		 	TempRadioInfo[playerid][tCurrentLogin], player_name[playerid]
		);
	} else {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] Соединение с [%s] %s было установлено.", 
		 	TempRadioInfo[playerid][tCurrentLogin], PI[playerid][pRadioTag], 
		 	player_name[playerid]
		);
	}
	radio_SendMessage(PI[playerid][pRadioChannelID], STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}
stock radio_OnPlayerDisconnectChannel(playerid) {
	if (!PI[playerid][pRadioChannelID]) return;

	if (strlen(PI[playerid][pRadioTag]) < RADIO_MIN_TAG_SYMBOLS) {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] Соединение с %s было потеряно.", 
		 	TempRadioInfo[playerid][tCurrentLogin], player_name[playerid]
		);
	} else {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] Соединение с [%s] %s было потеряно.", 
		 	TempRadioInfo[playerid][tCurrentLogin], PI[playerid][pRadioTag], 
		 	player_name[playerid]
		);
	}
	radio_SendMessage(PI[playerid][pRadioChannelID], STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}
CMD:radio(playerid) {
	if (!ItemContains(playerid, 501))
		return ErrorMessage(playerid, "У вас нет рации, купите ее в магазине 24/7.");
	radio_ShowMenu(playerid, D_RADIO_MENU);
	return true;
}
CMD:channels(playerid) {
	if (!ItemContains(playerid, 501))
		return ErrorMessage(playerid, "У вас нет рации, купите ее в магазине 24/7.");
	radio_ShowMenu(playerid, D_RADIO_CHANNELS);
	return true;
}
CMD:ronline(playerid) {
	if (!ItemContains(playerid, 501))
		return ErrorMessage(playerid, "У вас нет рации, купите ее в магазине 24/7.");
	radio_ShowMenu(playerid, D_RADIO_ONLINE);
	return true;
}
CMD:rc(playerid, params[]) {
	if (PI[playerid][pStageDeath]) return true;
	if (!ItemContains(playerid, 501))
		return ErrorMessage(playerid, "У вас нет рации, купите ее в магазине 24/7.");
	if (!PI[playerid][pRadioChannelID])
		return ErrorMessage(playerid, "Вы не подключены ни к одному каналу! Используйте - /radio.");
	if (PI[playerid][pFMute] > 0) 
		return ErrorMessage(playerid, "У Вас заглушка");
	if (PI[playerid][pMute] > 0) 
		return ErrorMessage(playerid, "У Вас бан чата");
	if (TI[playerid][tGag]) 
		return ErrorMessage(playerid, "У Вас кляп");

	new result[128];
	if (sscanf(params, "s[110]", result)) 
		return SendEsp(playerid, "/r [текст]");

	if (strlen(PI[playerid][pRadioTag]) < RADIO_MIN_TAG_SYMBOLS) {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] %s[%d]: %s", 
			TempRadioInfo[playerid][tCurrentLogin], 
			player_RP_name[playerid], playerid, result
		);
	} else {
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
			"[R:%s] [%s] %s[%d]: %s", 
		 	TempRadioInfo[playerid][tCurrentLogin], PI[playerid][pRadioTag], 
		 	player_RP_name[playerid], playerid, result
		);
	}
	radio_SendMessage(PI[playerid][pRadioChannelID], STRING_GLOBAL), STRING_GLOBAL[0] = EOS;

	return true;
}
stock radio_GetFractionChannelID(playerid) {
	new fraction = PI[playerid][pMember];
	if (!IsFractionRadioChannel(fraction)) 
		return 0;
	return fraction;
}