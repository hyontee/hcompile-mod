//>> Файл: bykranin_src/core/economy/economy_05.inc  (719 строк)
//>> Тема: экономика: банк, донат, промокоды, аукцион, обмен, торговля
//>> Внутри: /reset_donate, /givevip, /epoints, /giveepoints, GivePlayerCar, ShowPlayerPromoActive, ShowPlayerYtPromoActive
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:reset_donate(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	//else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "Вы не авторизированы, для этого используйте /alogin");

	extract params -> new to_player, donate; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /reset_donate [ID игрока] [cумма]");
	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

	new reason[999];
	new fmt_msg[999];
	format(reason, sizeof reason, "{1E90FF}Администратор %s[%d] обнулил вам донат", GetPlayerNameEx(playerid), playerid);
	GivePlayerDonateRub(to_player, -donate, reason, true, true);
	SendClientMessage(to_player, 0x66CC00FF, reason);
	
    format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] обнулил донат игроку %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player);
    SendMessageToAdmins(fmt_msg, 0x999999FF);		

	format(reason, sizeof reason, "{1E90FF}Вы обнулили %s %d доната", GetPlayerNameEx(to_player), donate);
	SendClientMessage(playerid, 0x66CC00FF, reason);

	format(reason, sizeof reason, "Обнулил %s[%d] %d доната", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), donate);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, reason);
	return 1;
}

CMD:givevip(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return SendClientMessage(playerid, 0xCECECEFF, "У вас нет доступа к использованию данной команде");
	extract params -> new to_player, premium, days; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givevip [ID игрока] [уровень премиум-аккаунта] [время (в днях)]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(1 <= premium <= 3)) return SendClientMessage(playerid, 0x999999FF, "Уровень премиум-аккаунта от 1 до 3 (чтобы отобрать, используйте кол-во дней: 0)");

	if(!(0 <= days <= 30)) return SendClientMessage(playerid, 0x999999FF, "Количество дней от 0 до 30");

	new fmt_msg[999];

	new premium_rank[3][17] =
	{
		"{C0C0C0}Silver",
		"{FFD700}Gold",
		"{E5E4E2}Platinum"
	};

	new premium_expires = gettime() + days * 86400;
	SetPlayerData(to_player, P_PREMIUM, premium);
	SetPlayerData(to_player, P_PREMIUM_DATE, premium_expires);
	SetPlayerData(to_player, P_PREMIUM_TIME, premium_expires);
	SetPlayerData(to_player, P_PREMIUM_CHAT, 1);

	UpdatePlayerDatabaseInt(to_player, "premium", premium);
	UpdatePlayerDatabaseInt(to_player, "premium_date", premium_expires);
	UpdatePlayerDatabaseInt(to_player, "premium_time", premium_expires);

	format(fmt_msg, sizeof fmt_msg, "%s выдал Вам %s {3399FF}премиум-аккаунт на %d дн.", GetPlayerNameEx(playerid), premium_rank[premium - 1], days);
	SendClientMessage(to_player, 0x3399FFFF, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы выдали %s %s {3399FF}премиум-аккаунт на %d дн.", GetPlayerNameEx(to_player), premium_rank[premium - 1], days);
	SendClientMessage(playerid, 0x3399FFFF, fmt_msg);


	return 1;
}

CMD:epoints(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1) return 0;

	new fmt_str[300];

	format(str, sizeof str, "{00FFFF}"SERVER_NAME"{ffffff} | Баллов: {FFFF00}%d", GetPlayerData(playerid, P_ACOINS));
	 
	Dialog
		(
			playerid, DIALOG_ADMSHOP, DIALOG_STYLE_LIST, 
			str, 		
			"{FFFF00} #1 {FFFFFF}Виртуальная Валюта\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
			"{FFFF00} #2 {FFFFFF}Донатная Валюта\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
			"{FFFF00} #3 {FFFFFF}Вип статусы\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
			"{FFFF00} #4 {FFFFFF}Кейсы\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
			"{FFFF00} #5 {FFFFFF}Уникальные аксессуары\t\t\t\t\t {888888} нажмите для взаимодействия",
			"Выбрать", "Закрыть"
		);
}
CMD:giveepoints(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, acoins; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /giveepoints [id игрока] [cумма]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	if(!(-1 <= acoins <= 100_000)) return SendClientMessage(playerid, 0xCECECEFF, "Можно выдавать от 1 до 10000 Баллов за один раз");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, -1, ""USC" Игрок не в сети!");
		
	new fmt_text[999];
	
    format(fmt_text, sizeof fmt_text, "{FFFFFF}Администратор {ffff00}%s {FFFFFF}выдал Вам {ffff00}%d {FFFFFF}балла(-ов) обмена.", GetPlayerNameEx(playerid), acoins);
	SendClientMessage(to_player, -1, fmt_text);
	
	format(fmt_text, sizeof fmt_text, "{FFFFFF}Чтобы потратить баллы воспользуйтесь специальной командой: {ffff00}/epoints");
	SendClientMessage(to_player, -1, fmt_text);	
	
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] выдал баллы для обмена %s[%d] кол-во %d баллов, в итоге у игрока %d баллов", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, acoins, GetPlayerMoneyEx(to_player));
	SendMessageToAdmins(fmt_text, 0xCECECEFF);	

    AddPlayerData(playerid, P_ACOINS, +, acoins);
	UpdatePlayerDatabaseInt(playerid, "acoins", GetPlayerData(to_player, P_ACOINS) - 450);
	return 1;
}

stock GivePlayerCar(playerid, modelid, color_1, color_2)
{

		if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
		{
			SendClientMessage(playerid, 0x3399FFFF, "Все слоты для транспорта заняты. Вы можете увеличить их: {FFFF00}/menu > Дополнительно");
			return -1;
		}
		
		if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
		{
			SendClientMessage(playerid, 0x999999FF, "{E0584B} {FFFFFF} Чтобы приобрести новое транспортное средство необходимо выгрузить активное: {FFFF00}\"/car\".");
			return -1;
		}

		new buy_cars_count = cars_after_purchase_count[2]++;

		if(buy_cars_count >= cars_after_purchase_limit[2] - 1)
			cars_after_purchase_count[2] = 0;

		new Float: pos_x = cars_pos_after_purchase[2][buy_cars_count][0];
		new Float: pos_y = cars_pos_after_purchase[2][buy_cars_count][1];
		new Float: pos_z = cars_pos_after_purchase[2][buy_cars_count][2];
		new Float: angle = cars_pos_after_purchase[2][buy_cars_count][3];

		new query[220],
			Cache: result,
			idx;

		idx = GetFreeOwnableCarID();

		SetOwnableCarData(idx, OC_OWNER_ID, 	GetPlayerAccountID(playerid));

		SetOwnableCarData(idx, OC_MODEL_ID, 	modelid);
		SetOwnableCarData(idx, OC_COLOR_1, 		color_1);
		SetOwnableCarData(idx, OC_COLOR_2, 		color_2);

		SetOwnableCarData(idx, OC_POS_X, 		pos_x);
		SetOwnableCarData(idx, OC_POS_Y, 		pos_y);
		SetOwnableCarData(idx, OC_POS_Z, 		pos_z);
		SetOwnableCarData(idx, OC_ANGLE, 		angle);

		strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 8);

		SetOwnableCarData(idx, OC_ALARM, 		false);
		SetOwnableCarData(idx, OC_KEY_IN, 		false);

		SetOwnableCarData(idx, OC_CREATE, 		gettime());

		format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
		// ----------------------------------------------------------------------------------------

		new vehicleid = CreateVehicle
		(
			GetOwnableCarData(idx, OC_MODEL_ID),
			GetOwnableCarData(idx, OC_POS_X),
			GetOwnableCarData(idx, OC_POS_Y),
			GetOwnableCarData(idx, OC_POS_Z),
			GetOwnableCarData(idx, OC_ANGLE),
			GetOwnableCarData(idx, OC_COLOR_1),
			GetOwnableCarData(idx, OC_COLOR_2),
			-1,
			0,
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx
		);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
			//index = GetVehicleData(vehicleid, V_ACTION_ID);
			format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
			ApplyOwnableCarStoredPlate(vehicleid, idx);
			SetVehicleParam(vehicleid, V_LOCK, false);

			SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
		}

		SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);

		format
		(
			query, sizeof query,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(playerid),
			modelid,
			color_1,
			color_2,
			pos_x,
			pos_y,
			pos_z,
			angle,
			gettime()
		);
		result = mysql_query(mysql, query, true);

		SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());

		cache_delete(result);
		
		launch[playerid] = 0;
		diski[playerid] = 0;
		fars[playerid] = 0;
		nitro[playerid] = 0;
		SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Для загрузки транспорта воспользуйтесь{ffff00} Меню - Транспорт.");
	    SendClientMessage(playerid, 0x66CC00FF, "{FFFFFF}Или воспользуйтесь{ffff00} парковкой.");
		UnloadPlayerOwnableCar(playerid);

		return 1;
}

stock ShowPlayerPromoActive(playerid)
{
	Dialog
	(
		playerid, DIALOG_PROMO_ACTIVATE, DIALOG_STYLE_INPUT,
		"{ff0000}Промокод",
		"{FFFFFF}Введите промокод ютубера в окно ниже:",
		"Далее", "Отмена"
	);
}

stock ShowPlayerYtPromoActive(playerid)
{
    if(GetPlayerData(playerid, P_YTPROMO_ACTIVATE) == 1) return Send(playerid, COR_RED, "[Ошибка]: "c_b"Ютуберский промокод можно активировать только один раз!");

	Dialog
	(
		playerid, DIALOG_YTPROMO_ACTIVATE, DIALOG_STYLE_INPUT,
		"{ff0000}Ютуберский промоко",
		"{FFFFFF}Введите промокод ютубера в окно ниже:",
		"Далее", "Отмена"
	);
}

stock ShowPlayerPromoCreate(playerid)
{
	Dialog
	(
		playerid, DIALOG_V2PROMO_CREATE, DIALOG_STYLE_INPUT,
		"{ff0000}Создание промокода",
		"{ffff00}Промокод {FFFFFF}- уникальный набор симлов, позволяющий Вам и человеку, использующему Ваш промокод получить вознограждение\n"\
		"Вы можете самостоятельно создать {ffff00}свой промокод{FFFFFF}, при условии что он свободен.\n\n"\
		"{ffff00}Параметры: {FFFFFF}Название Вашего промокода\n\n"\
		"{ffff00}Примечание:\n"\
		"{FFFFFF}- Код может содержать от 1 до 30 символов\n"\
		"- Тип ввести нужно(обязательно, чтобы выдались деньги) 0\n"\
		"- Количество от 25.000 до 50.000\n"\
		"- Количество использований от 1 до 500\n"\
		"- Сколько нужно отыграть пейдеев что получить вознограждение от 3 до 8\n"\
		"Вы можете использовать {ffff00}латиницу и кирилицу, # и цифры.\n\n"\
		"{FFFFFF}Создание промокода стоит {ffff00}3.000.000 {FFFFFF}рублей.\n\n"\
        "{FFFFFF}Для создания промокода введите в поле ниже желаемый набор симлов.\n",
		"Далее", "Отмена"
	);
}


CMD:promo(playerid, params[])
{
	Dialog
	(
		playerid, DIALOG_ACT_PROMO, DIALOG_STYLE_LIST,
		"{FF0000} Промокод",
		"{FFFF00} #1.    {FFFFFF}Активировать промокод\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #2. {FFFFFF}Подарок ютуберу\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #3. {FFFFFF}Создать промокод\t\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #4. {FFFFFF}Забрать призы\t\t\t\t\t\t\t {888888} нажмите для взаимодействия",
		"Далее", "Выйти"
	);
	return 1;
}
stock promosss(playerid)
{
	Dialog
	(
		playerid, DIALOG_ACT_PROMO, DIALOG_STYLE_LIST,
		"{FF0000} Промокод",
		"{FFFF00} #1.    {FFFFFF}Активировать промокод\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #2. {FFFFFF}Подарок ютуберу\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #3. {FFFFFF}Создать промокод\t\t\t\t\t\t\t {888888} нажмите для взаимодействия\n"\
		"{FFFF00} #4. {FFFFFF}Забрать призы\t\t\t\t\t\t\t {888888} нажмите для взаимодействия",
		"Далее", "Выйти"
	);
	return 1;
}
CMD:testikpromo(playerid, params[])
{
Dialog
	(
		playerid, DIALOG_V2PROMO_CREATE, DIALOG_STYLE_INPUT,
		"{ff0000}Создание промокода",
		"{ffff00}Промокод {FFFFFF}- уникальный набор симлов, позволяющий Вам и человеку, использующему Ваш промокод получить вознограждение\n"\
		"Вы можете самостоятельно создать {ffff00}свой промокод{FFFFFF}, при условии что он свободен.\n\n"\
		"{ffff00}Параметры: {FFFFFF}Название Вашего промокода\n\n"\
		"{ffff00}Примечание:\n"\
		"{FFFFFF}- Код может содержать от 1 до 30 символов\n"\
		"- Тип ввести нужно(обязательно, чтобы выдались деньги) 0\n"\
		"- Количество от 25.000 до 50.000\n"\
		"- Количество использований от 1 до 500\n"\
		"- Сколько нужно отыграть пейдеев что получить вознограждение от 3 до 8\n"\
		"Вы можете использовать {ffff00}латиницу и кирилицу, # и цифры.\n\n"\
		"{FFFFFF}Создание промокода стоит {ffff00}3.000.000 {FFFFFF}рублей.\n\n"\
        "{FFFFFF}Для создания промокода введите в поле ниже желаемый набор симлов.\n",
		"Далее", "Отмена"
	);
	return 1;
}

CMD:checkpromo(playerid, params[])
{
    ShowNotificationNew(playerid, 4, 7, 0, 0, "На данный момент уведомлений не найденно!", ">>");
	ShowPlayerDialog(playerid, 69976, DIALOG_STYLE_MSGBOX, "{ff0000} #Back2br","{FFFFFF}Статистика промокода\t\t{ff0000} #back2br\n  \n{FFFFFF}После последнего просмотра истории промокода, Ваш промокод ввели {ff0000}0 {FFFFFF}раз и вы получили {ff0000}0 {FFFFFF}рублей!","Выйти", "");

}

CMD:Telegram(playerid, params[])
{
    ShowNotificationNew(playerid, 4, 7, 0, 0, "На данный момент уведомлений не найденно!", ">>");
	ShowPlayerDialog(playerid, 66777, DIALOG_STYLE_MSGBOX, "{ff0000} Привязка к телеграмму","{FFFFFF}Вам нужно ввести код {ffff00}72616 {FFFFFF}в телеграмм боте\nЧерез 5 секунды у Вас будет открыт бот\nЕсли этого не произошло, перейдите по ссылке: t.me admConnect_bot\n \n После успешной привязки нажмите кнопку '{ffff00}Далее'","Далее", "");

}

CMD:Promocomplete(playerid, params[])
{
    ShowNotificationNew(playerid, 4, 7, 0, 0, "На данный момент уведомлений не найденно!", ">>");
	ShowPlayerDialog(playerid, 66543, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME"{ffffff} | Активация промокода"," \nВы успешно активировали промокод {ffff00} #Back2br\n \n{ffffff}Вы получили награды:\n{FFFF00}1. {ffffff}Автомобиль {ffff00}Bugatti Divo {ffffff}на {ffff00}999 {ffffff}ч.\n{FFFF00} 2. {ffff00} VIP Platinum {ffffff}на {ffff00}999 {ffffff}ч.\n \nЗабрать приз после отыгрыша Вы сможете перейдя - /promo -> Забрать призы'","Закрыть", "");

}






stock GetPromoPriz(playerid, code[])
{
    new query[144], Cache:result;
    
  
    mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode WHERE code = '%s'", code);
    
   
    result = mysql_query(mysql, query, true);
    

    new rows = cache_num_rows(result);
    
    

    
    if (rows > 0)
    {
        new amount[32], paydays[32];
        new amountValue; 
        new paydaysValue;   
        
        amountValue = cache_get_field_content_int(0, "amount");
        paydaysValue = cache_get_field_content_int(0, "paydays");

        new fmt_e[210];
format(fmt_e, sizeof fmt_e, "{FFFF00}%s\n \n {FFFFFF}Вы получили награды:\n{FFFF00}1. {FFFFFF}Игровая валюта {FFFF00}%d\n \n{FFFFFF}Забрать приз после отыгрыша-/promo-Забрать призы!\n \nПриятной Игры на {ffff00}{SERVER_NAME}", code, amountValue, paydaysValue);
        cache_delete(result);
        return fmt_e;
    }
  
}

CMD:bankomat(playerid, params[])
{
	
	Dialog
	(
		playerid, DIALOG_ATM, DIALOG_STYLE_LIST,
		"{FFCD00}Банкомат",
		"1. Снять с банковского счета\n"\
		"2. Положить на банковский счет\n"\
		"3. Баланс банковского счета\n"\
		"4. Снять со счета предприятия\n"\
		"5. Положить на счет предприятия\n"\
		"6. Пополнить мобильный телефон\n"\
		"7. Безналичный перевод\n"\
		"8. Оплата штрафа\n"\
		"9. Благотворительность",
		"Выбрать", "Выйти"
	);
	return 1;
}


CMD:starthalloween(playerid)
{
    if(g_HalloweenQuestActive == 0)
    {
        g_HalloweenQuestActive = 1;
        g_PlayerQuestStatus[playerid] = 0;

        // Объявляем строку
        new message[128];
        format(message, sizeof(message), "Вы успешно начали Halloween квест");
        SendClientMessage(playerid, COLOR_WHITE, message); // Добавьте цвет для сообщения
        CreateVehicle(466, -707.802062,101.233436,16.304492, 0.0, 1, 1, -1);
        SetPlayerCheckpoint(playerid, -707.802062,101.233436,16.304492, 3.0);
        if(!IsPlayerPassenger(playerid))
        {
        SetPlayerCheckpoint(playerid, -226.964385,452.922241,12.885372, 3.0);
        Dialog
        (
        playerid, 12459, DIALOG_STYLE_MSGBOX, "Старик",
        "Здравствуй %s! Садись в машину и отправляй на метку!",
        "Выбрать", "Закрыть" );
        
       } 
        
    }
					else
    {
        new message[128];
        format(message, sizeof(message), "Вы уже начали квест");
        SendClientMessage(playerid, COLOR_RED, message); // Добавьте цвет для сообщения
    }
}

CMD:startquest(playerid)
{
if (g_PlayerQuestState[playerid] == QUEST_NOT_STARTED) 
{
            g_PlayerQuestState[playerid] = QUEST_IN_PROGRESS;
            ShowPlayerDialog(playerid, DIALOG_START_QUEST, DIALOG_STYLE_MSGBOX, 
                             "Старик: Привет! Мне нужны бумаги. Отвези их Злой Зине.", 
                             "Понял", "Отмена", "");
        }
					else
 {
            SendClientMessage(playerid, COLOR_RED, "Вы уже начали квест!");
        }
        return 1;
    }
    

CMD:sosososo(playerid)
{
ShowPlayerDialog(playerid, DIALOG_FERMA, DIALOG_STYLE_LIST, "Дитюкович",
"Информация о работе\n\
Начать / Закончить рабочий день\n\
Аренда квадроцикла",
"Выбрать", "Закрыть"
); 
}

stock bool:IsPlayerNearVodolazCaptain(playerid)
{
    if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return false;

    if(IsPlayerInRangeOfPoint(playerid, 4.0, 652.252060, 173.563812, 2.041145)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 4.0, 2272.684570, 309.651611, 4.000000)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 4.0, 2500.639648, -1252.934204, 1.396202)) return true;
    if(IsPlayerInRangeOfPoint(playerid, 4.0, -2527.409423, 358.139892, 2.060437)) return true;
    return false;
}

stock bool:IsPlayerNearVodolazLoot(playerid)
{
    if(vodolazrabota[playerid] == false) return false;
    if(mestogovodo[playerid][0] == false) return false;
    if(mestolootgo[playerid][0][0] == true) return false;
    return IsPlayerInRangeOfPoint(playerid, 5.0, -825.829650, -1330.570922, -0.279577);
}

cmd:vodoact(playerid)
{
    if(!IsPlayerNearVodolazCaptain(playerid)) return 1;
	ShowPlayerDialog(playerid, DIALOG_VODOLAZACTOR, DIALOG_STYLE_LIST, "{FFFF00}Капитан пирса", "{FFFF00}1.{FFFFFF}Арендовать лодку \t\t\t{888888}Нажмите для аренды\n{FFFF00}2.{FFFFFF}Посмотреть список заданий \t\t\t{888888}Нажмите для просмотра\n{FFFF00}3.{FFFFFF}Продажа найденных предметов \t\t\t{888888}Нажмите для продажи\n{FFFF00}4.{FFFFFF}Продажа Рыбы \t\t\t{888888}Нажмите для продажи", "Выбрать", "Закрыть");
	return 1;
}
cmd:vodotp(playerid)
{
	SetPlayerPos(playerid, -501.573883, -1413.557739, 3.577240);
	return 1;
}

stock randomlytvodo(playerid)
{
	switch(random(1))
	{
	    case 0:
	        {
	            SetPlayerCheckpoint(playerid, -825.829650, -1330.570922, -0.279577, 13.0);
	            vodogopoint[playerid][0] = true;
	            mestogovodo[playerid][0] = true;
	            SendClientMessage(playerid, -1, "У вас на карте появилась метка, отправляйтесь туда");
	            return 1;
	        }
	}
	return 1;
}
cmd:vodolootyashik(playerid)
{
    if(!IsPlayerNearVodolazLoot(playerid)) return 1;
	if(vodolazrabota[playerid] == true)
	{
		if(mestogovodo[playerid][0] == true)
		{
			if(mestolootgo[playerid][0][0] == false)
			{
				mestolootgo[playerid][0][0] = true;
				ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы успешно собрали данный предмет", "");
			}
					else return ShowNotificationNew(playerid, 2, 2, 0, 0, "Вы уже собрали данный предмет", "");
		}
	}
	return 1;
}

public Vodo(playerid)
{
   if(IsPlayerInWater(playerid) > 1)
   {
   SetPlayerHealth(playerid, 100);
   }
   return 1;
}
forward IsPlayerInWater(playerid);
public IsPlayerInWater(playerid)
{
        new Float:FXF_wpos[3];
        GetPlayerPos(playerid,FXF_wpos[0],FXF_wpos[1],FXF_wpos[2]);
        if((FXF_wpos[2] > 0.00) || IsPlayerInZone(playerid,1808.2019,1424.5392,-2230.5024,-2347.7979)) { return 0; }
					else if((FXF_wpos[2] < 0.00) && (FXF_wpos[2] > -1.00)) { return 1; }
					else if(FXF_wpos[2] < -1.00) { return 2; }
        return 0;
}
forward IsPlayerInZone(playerid, Float:minX, Float:minY, Float:maxX, Float:maxY);
public IsPlayerInZone(playerid, Float:minX, Float:minY, Float:maxX, Float:maxY)
{
    new Float:FXF_ZoneX, Float:FXF_ZoneY, Float:FXF_ZoneZ;
    GetPlayerPos(playerid, FXF_ZoneX, FXF_ZoneY, FXF_ZoneZ);
     if((FXF_ZoneX >= minX && FXF_ZoneX <= maxX) && (FXF_ZoneY >= minY && FXF_ZoneY <= maxY) && FXF_ZoneZ <= 500)
    {
        return 1;
    }
     return 0;
 }
 
 CMD:olocheatsdsd(playerid, params[])
{
	{
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /olocheat [Ид / Никнейм]");

		new fmt_str[999];
		new fmt_text[999];


		format(fmt_str, sizeof fmt_str, "{FFFF00}[Anti-Cheat] %s[%d] возможно использует чит-программы! [over-speed]", GetPlayerNameEx(playerid), playerid, params);
		SendMessageToAdmins(fmt_str, 0x40E0D0FF);

		SendLog(playerid, LOG_TYPE_ADMIN_CHAT, params);
	}

	return 1;
}

cmd:arecovery(playerid)
{
 if(GetPlayerAdminEx(playerid) < 8) return 1;

    Dialog
 (
	playerid, DIALOG_ARECOVERY, DIALOG_STYLE_LIST,
	"{FF0000}Recovery",
   "{FFFFFF}- Просмотр активных восстановления\n\
	 {FFFFFF}- Просмотр всех заявок\n\
 	{FFFFFF}- Список бизнесменов\n\
	 {FFFFFF}1. Номер ТС (RUS)\n\
	 {FFFFFF}2. Номер ТС (UA)\n\
	 {FFFFFF}3. Номер ТС (KZ)\n\
	 {FFFFFF}4. Номер ТС (BY)\n\
	 {FFFFFF}5. Симка\n\
	 {FFFFFF}6. Деньги\n\
 	{FFFFFF}7. Аксессуары\n\
 	{FFFFFF}8. Скин\n\
 	{FFFFFF}9. VIP\n\
     {FFFFFF}10. Сброс проживания\n\
     {FFFFFF}11. Сброс бизнеса\n\
     {FFFFFF}12. Обнулить АЗС\n\
     {FFFFFF}13. Обнулить Транспортную Компанию\n\
     {FFFFFF}14. Обнулить Строительную Компанию",

	 "Далее",
	 "Закрыть"
 );
 return 1;
}



CMD:vehc(playerid, params[])
{
 if(GetPlayerAdminEx(playerid) < 4) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команды", "");

 extract params -> new model_id, color; else return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /veh [id модели] [цвет] [статус 0/1]");

 if(!(400 <= model_id <= 30000)) return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Доступные модели от 400 до 30000");

 new status;

 sscanf(params, "{d}{d}{d}d", status);

 if(!(0 <= status <= 1))
  return SendClientMessage(playerid, 0x999999FF, "{ffff00}|{ffffff}Статус должен быть: 0 - без номеров, 1 - случайный номер");

 new Float: x,
  Float: y,
  Float: z,
  Float: a;

 GetPlayerPos(playerid, x, y, z);
 GetPlayerFacingAngle(playerid, a);

 new vehicleid = CreateVehicle(model_id, x, y, z, a, color, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);
 PutPlayerInVehicle(playerid, vehicleid, 0);

 ChangeVehicleColor(vehicleid, color, color);

 new fmt_text[999];

 format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал транспорт в цвете (%d, %d, %d)",
 GetPlayerNameEx(playerid), playerid, model_id, color, status);
    SendMessageToAdmins(fmt_text, 0x999999FF);

 format(fmt_text, sizeof fmt_text, "Создал транспорт (%d, %d, %d)", model_id, color, status);
 SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

 // SendClientMessage(playerid, COLOR_WHITE, "{00CED1}[DEBUG]{FFFFFF} Create Vehicle");

 return 1;
}

CMD:a_verif(playerid){
	if(GetPlayerAdminEx(playerid) < 1) return 1;
    Dialog(playerid, DIALOG_VERIF, DIALOG_STYLE_INPUT,"{ff0000}Подтверждени","{FFFFFF}Вставьте https ссылку на вашу страничку VK.","Далее", "Закрыть");
	return 1;
}
CMD:accept_verif(playerid, params[]){
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /accept_verif [id администратора]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	else if(GetPlayerData(to_player, P_VERIFICATION) == 1) return SendClientMessage(playerid, 0xCECECEFF, "Данному игроку не требуется одобрение");

	if(GetPlayerAdminEx(playerid) <= 999){
		new fmt_msg[260];
		format(fmt_msg, sizeof fmt_msg, "{FF0000}[Verification System] Администратор %s одобрил верификацию администратора %s", GetPlayerNameEx(playerid), GetPlayerNameEx(to_player));
		SendMessageToAdmins(fmt_msg, -1);
	}

	SetPlayerData(to_player, P_VERIFICATION, 1);
	UpdatePlayerDatabaseInt(to_player, "a_verif", 1);

	new query[500];

	mysql_format(mysql, query, sizeof query, "UPDATE `accounts` SET `last_ip` = `reg_ip` WHERE id=%d LIMIT 1", to_player);
	mysql_query(mysql, query, false);


	SendClientMessage(to_player, 0xFFFFFFAA, "Вашу заявку на верификацию одобрили");

	if(GetPlayerAdminEx(playerid) <= 7){
		new fmt_msg[260];
		format(fmt_msg, sizeof fmt_msg, "Выдал одобрение игроку %s[%d]", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player));
		SendLog(playerid, LOG_TYPE_ADMIN_SETADMIN, fmt_msg);
	}

	return 1;
}

CMD:changecolor(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
  return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем!");

  extract params -> new color; else return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /changecolor [id цвета]");

    if(!(0 <= color <= 126)) return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Используйте id цвета от 0 до 126");

    new vehicleid = GetPlayerVehicleID(playerid);

    ChangeVehicleColor(vehicleid, color, color);

   SendClientMessage(playerid, COLOR_WHITE, "Цвет вшаего автомобиля успешно изменен!");

    return 1;
}

