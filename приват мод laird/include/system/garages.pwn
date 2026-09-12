#define COLOR_GREEN 0x00FF00FF
#define MAX_GARAGES				(900)	// максимальное кол-во гаражей

#define GARAGE_TYPE_NONE		(-1) 	// нет
#define GARAGE_TYPE_GARAGE		(0) 	// дом

#define SetPlayerInGarage(%0,%1)				SetPlayerData(%0, P_IN_GARAGE, %1)		// установить дом в котором находится
#define GetGarageData(%0,%1)			g_garage[%0][%1]
#define SetGarageData(%0,%1,%2)		g_garage[%0][%1] = %2
#define AddGarageData(%0,%1,%2,%3)	g_garage[%0][%1] %2= %3
#define IsGarageOwned(%0)			(GetGarageData(%0, G_OWNER_ID) > 0) // куплен ли гараж

// FIX: макрос игнорировал переданный %0 и всегда читал playerid из области видимости
// вызывающей функции - если бы где-то вызвали GetPlayerGarage(otherid), он бы всё равно
// вернул данные текущего playerid. Плюс читал P_GARAGE_TYPE (тип гаража), а не то,
// какой конкретно гараж принадлежит игроку - используй свой актуальный P_GARAGE
// (индекс гаража в g_garage[], который игрок купил). Если такого поля ещё нет в
// enum игрока - добавь его рядом с P_IN_GARAGE.
#define	GetPlayerGarage(%0)	GetPlayerData(%0, P_GARAGE)

#define DIALOG_PAY_FOR_RENT_GARAGE  15000		// оплата за гараж
#define DIALOG_GARAGE_BUY	15001			// покупка гаража
#define	DIALOG_GARAGE_SELL 15002			// продажа гаража
#define	DIALOG_GARAGE_INFO	15003			// инфо о гараже
#define	DIALOG_GARAGE_MINU 15004
#define DIALOG_GARAGE_UPGRADE 1056			// FIX: было магическое число "1056" прямо в коде без #define - вынес сюда
// FIX: было ВТОРОЕ переопределение DIALOG_GARAGE_SELL = 15005 - в паунне это
// ошибка компиляции (symbol already defined) либо тихо ломает id диалога.
// Второе значение нигде по имени не использовалось - просто удалил дубль.

// FIX: обе константы были равны 5000 - PICKUP_ACTION_TYPE_GARAGE и
// PICKUP_ACTION_TYPE_GARAGE_EXIT указывали на одно и то же число. В switch с двумя
// одинаковыми case-значениями компилятор выдаёт ошибку "duplicate case values",
// а даже если бы не выдавал - конструкция никогда не отличила бы вход от выхода.
#define PICKUP_ACTION_TYPE_GARAGE 5000
#define PICKUP_ACTION_TYPE_GARAGE_EXIT 5001

// FIX: этого define вообще не было в файле - отсюда "undefined symbol OFFER_TYPE_BUY_GARAGE".
// Если у тебя уже есть похожие OFFER_TYPE_* константы в других файлах (для домов/бизнесов и т.п.) -
// проверь, что 251 не занят, и поменяй на свободное число.
#define OFFER_TYPE_BUY_GARAGE 251

// ДОБАВЛЕНО: цены подняты по твоей просьбе - улучшение в диапазоне 20кк-50кк,
// базовая цена гаража увеличена пропорционально. Оба значения - просто константы,
// меняй как нужно.
#define GARAGE_UPGRADE_PRICE 35000000   // 35кк - середина диапазона 20кк-50кк
#define GARAGE_DEFAULT_PRICE 10000000   // 10кк - цена по умолчанию для /addgarage без параметра

enum E_GARAGE_STRUCT
{
	G_SQL_ID,
	G_OWNER_ID,
	G_RENT_DATE,
	G_RENT_PRICE,
	G_YLUCHENIE,
	G_PRICE,
	G_OPEN,
	G_ENTRACE,
	G_MAP_ICON,
	G_ENTER_PICKUP,
	Text3D: G_LABEL,			// 3д текст
	G_OWNER_NAME[20 + 1],		// имя владельца
	Float: G_POS_X,				// позиция пикапа входа
	Float: G_POS_Y,				// позиция пикапа входа
	Float: G_POS_Z,				// позиция пикапа входа
	Float: G_EXIT_POS_X,		// позиция после выхода из дома
	Float: G_EXIT_POS_Y,		// позиция после выхода из дома
	Float: G_EXIT_POS_Z,		// позиция после выхода из дома
	Float: G_EXIT_ANGLE		// угол поворота
}

enum E_GARAGE_TYPE_STRUCT
{
	GT_NAME[20],
	Float: GT_ENTER_POS_X,			// позиции после входа в интерьер
	Float: GT_ENTER_POS_Y,			// позиции после входа в интерьер
	Float: GT_ENTER_POS_Z,			// позиции после входа в интерьер
	Float: GT_ENTER_POS_ANGLE,		// позиции после входа в интерьер
	Float: GT_HEALTH_POS_X,		// позиции аптечки
	Float: GT_HEALTH_POS_Y,		// позиции аптечки
	Float: GT_HEALTH_POS_Z,		// позиции аптечки
	Float: GT_STORE_POS_X,			// позиции шкафа
	Float: GT_STORE_POS_Y,			// позиции шкафа
	Float: GT_STORE_POS_Z,			// позиции шкафа
	GT_INTERIOR					// ид интерьера
}

// FIX: массив был объявлен на 200 ячеек, а MAX_GARAGES = 900. LoadGarage() клэмпит
// rows до MAX_GARAGES (900) и потом пишет в g_garage[idx] для idx вплоть до 899 -
// при 201+ гараже в БД это запись за пределы массива (краш/порча памяти).
// Размер массива теперь = MAX_GARAGES.
new g_garage[MAX_GARAGES][E_GARAGE_STRUCT];
new g_garage_loaded;

public OnGameModeInit()
{
	LoadGarage();
	#if defined garage_OnGameModeInit
		garage_OnGameModeInit();
	#endif
	return 1;
}
#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit garage_OnGameModeInit
#if defined garage_OnGameModeInit
	forward garage_OnGameModeInit();
#endif

public OnPlayerSpawn(playerid)
{
	SetPlayerData(playerid, P_IN_GARAGE, -1);

	#if defined garage_OnPlayerSpawn
		garage_OnPlayerSpawn(playerid);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn garage_OnPlayerSpawn
#if defined garage_OnPlayerSpawn
	forward garage_OnPlayerSpawn(playerid);
#endif

public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	// FIX: было switch(pickupid) - pickupid это уникальный ID конкретного пикапа
	// в SA-MP (у каждого созданного пикапа он свой), сравнивать его с константами
	// 5000/5001 бессмысленно - совпадение почти невозможно. Нужно switch(action_type),
	// это то значение, которое ты сам передал в CreatePickup(...). Из-за этой
	// строки вход в гараж по пикапу вообще не работал.
	switch(action_type)
	{
		case PICKUP_ACTION_TYPE_GARAGE:
		{
			if(GetGarageData(action_id, G_OWNER_ID) > 1)
			{
				if(GetGarageData(action_id, G_OPEN) == 0)
				{
					if(GetGarageData(action_id, G_YLUCHENIE) == 0)
					{
						SetPlayerData(playerid, P_IN_GARAGE, action_id);
						EnterPlayerToGarage(playerid, action_id);
						ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
					}
					else if(GetGarageData(action_id, G_YLUCHENIE) == 1)
					{
						SetPlayerData(playerid, P_IN_GARAGE, action_id);
						SetPlayerInGarage(playerid, action_id);

						SetPlayerPosEx(playerid, 495.961517, 1989.867797, 1547.679687, 271.342468, 1, action_id);

						ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
					}
				}
			}
			else if(GetGarageData(action_id, G_OWNER_ID) == GetPlayerAccountID(playerid))
			{
				if(GetGarageData(action_id, G_YLUCHENIE) == 0)
				{
					SetPlayerData(playerid, P_IN_GARAGE, action_id);
					EnterPlayerToGarage(playerid, action_id);
					ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}
				else
				{
					SetPlayerData(playerid, P_IN_GARAGE, action_id);
					SetPlayerInGarage(playerid, action_id);

					SetPlayerPosEx(playerid, 495.961517, 1989.867797, 1547.679687, 271.342468, 1, action_id);

					ShowNotification(playerid, 2, "Вы вошли в гараж", 4, " ", "");
				}
			}
			else return ShowPlayerGarageInfo(playerid, action_id);
		}
		case PICKUP_ACTION_TYPE_GARAGE_EXIT:
		{
			new garageid = GetPlayerData(playerid, P_IN_GARAGE);
			SetPlayerPosEx
			(
				playerid,
				GetGarageData(garageid, G_EXIT_POS_X),
				GetGarageData(garageid, G_EXIT_POS_Y),
				GetGarageData(garageid, G_EXIT_POS_Z),
				GetGarageData(garageid, G_EXIT_ANGLE),
				0,
				0
			);
			SetPlayerData(playerid, P_IN_GARAGE, -1);
		}
	}

	#if defined garage_OnPlayerPickUpPickupEx
		garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerPickUpPickupEx
	#undef OnPlayerPickUpPickupEx
#else
	#define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx garage_OnPlayerPickUpPickupEx
#if defined garage_OnPlayerPickUpPickupEx
	forward garage_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

stock IsPlayerNearGaragePickup(playerid, garageID)
{
	new Float:garageX = GetGarageData(garageID, G_POS_X);
	new Float:garageY = GetGarageData(garageID, G_POS_Y);
	new Float:garageZ = GetGarageData(garageID, G_POS_Z);

	if (IsPlayerInRangeOfPoint(playerid, 5.0, garageX, garageY, garageZ))
	{
		return true;
	}
	return false;
}

public EnterGarage(playerid)
{
	new action_id = GetPlayerData(playerid, P_IN_GARAGE);
	new vehicleid = GetPlayerVehicleID(playerid);

	if (vehicleid != 0) // Проверяем, находится ли игрок в автомобиле
	{
		if(GetGarageData(action_id, G_YLUCHENIE) == 0)
		{
			SetPlayerPosEx(playerid, -0.292650, 2000.242065, 1553.358764, 355.240234, 1, GetPlayerData(playerid, P_IN_GARAGE), false);
			SetVehiclePos(vehicleid, -0.292650, 2000.242065, 1553.358764);
			SetVehicleZAngle(vehicleid, 355.240234);
		}
		else if(GetGarageData(action_id, G_YLUCHENIE) == 1)
		{
			SetPlayerPosEx(playerid, 501.180450, 1998.823486, 1547.679687, 357.5, 1, GetPlayerData(playerid, P_IN_GARAGE), false);
			SetVehiclePos(vehicleid, 501.180450, 1998.823486, 1547.679687);
			SetVehicleZAngle(vehicleid, 348);
		}
		LinkVehicleToInterior(vehicleid, 1); // Связываем транспорт с интерьером
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
		PutPlayerInVehicle(playerid, vehicleid, 0); // Сажаем игрока в автомобиль
	}
	else
	{
		SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Вы не в автомобиле!");
	}
}

forward ExitPlayerGarage(playerid);
public ExitPlayerGarage(playerid)
{
	if(GetPlayerData(playerid, P_IN_GARAGE) == -1) return 1;

	new garageid = GetPlayerData(playerid, P_IN_GARAGE);
	new vehicleid = GetPlayerVehicleID(playerid);

	SetVehiclePos(vehicleid, GetGarageData(garageid, G_EXIT_POS_X),
		GetGarageData(garageid, G_EXIT_POS_Y),
		GetGarageData(garageid, G_EXIT_POS_Z),
		GetGarageData(garageid, G_EXIT_ANGLE) + 180);
	LinkVehicleToInterior(vehicleid, 0);
	SetVehicleVirtualWorld(vehicleid, 0);

	SetPlayerPosEx
	(
		playerid,
		GetGarageData(garageid, G_EXIT_POS_X),
		GetGarageData(garageid, G_EXIT_POS_Y),
		GetGarageData(garageid, G_EXIT_POS_Z),
		GetGarageData(garageid, G_EXIT_ANGLE),
		0,
		0
	);
	SetPlayerData(playerid, P_IN_GARAGE, -1);
	PutPlayerInVehicle(playerid, vehicleid, 0);
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	// FIX: было два отдельных "if (newkeys == KEY_CROUCH)" подряд - работало,
	// но зачем два блока на одно и то же событие. Объединил в один, логика та же.
	if (newkeys == KEY_CROUCH)
	{
		if (IsPlayerInRangeOfPoint(playerid, 5, 495.170532, 299.884582, 1339.000000) || IsPlayerInRangeOfPoint(playerid, 5, -19.821039, 4.290028, 1129.476562))
		{
			SetTimerEx("ExitPlayerGarage", 1000, false, "i", playerid);
			return 1;
		}

		if(GetPlayerGarage(playerid) != -1)
		{
			if(GetPlayerData(playerid, P_IN_GARAGE) != -1) return Send(playerid, -1, "[DEBUG] ERROR");
			new idx = GetPlayerGarage(playerid);
			if (IsPlayerNearGaragePickup(playerid, idx))
			{
				Send(playerid, -1, "[DEBUG] ENTER PLAYER TO GARAGE");
				SetPlayerData(playerid, P_IN_GARAGE, idx);
				EnterGarage(playerid);
				return 1;
			}
		}
		else return Send(playerid, -1, "[DEBUG] ERRORS 00456");
	}

	#if defined garage_OnPlayerKeyStateChange
		garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
	#endif
	return 1;
}
#if defined _ALS_OnPlayerKeyStateChange
	#undef OnPlayerKeyStateChange
#else
	#define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange garage_OnPlayerKeyStateChange
#if defined garage_OnPlayerKeyStateChange
	forward garage_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if (dialogid == DIALOG_GARAGE_SELL)
	{
		if (response)
		{
			new temp;
			new to_player;
			sscanf(inputtext, "i i", to_player, temp);

			new price = temp;
			new Float:x;
			new Float:y;
			new Float:z;
			GetPlayerPos(playerid, x, y, z);

			if(!IsPlayerInRangeOfPoint(to_player, 5.0, x, y, z)) return Send(playerid, -1, "Игрок далеко");
			if (to_player >= 0 && price > 0)
			{
				if(GetPlayerMoneyEx(to_player) < price) return ShowNotification(playerid, 2, "У игрока не достаточно денег", 4, " ", "");
				SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUY_GARAGE, price);
				SetPVarInt(to_player, "GarageSellerID", playerid);
				SetPVarInt(to_player, "GaragePrice", price);
				ShowNotification(to_player, 4, "Покупка гаража", 7, "/yes", ">>");
			}
			else
			{
				SendClientMessage(playerid, COLOR_RED, "Ошибка: Неверный ID игрока или цена.");
			}
		}
	}

	if (dialogid == DIALOG_GARAGE_UPGRADE)
	{
		if (!response) return 1;
		new idx = GetPlayerGarage(playerid);
		if(idx == -1) return 1;
		if(GetGarageData(idx, G_YLUCHENIE) == 1) return Send(playerid, -1, "Улучшение уже куплено");

		// FIX/ДОБАВЛЕНО: раньше улучшение ставилось бесплатно - диалог писал цену,
		// но деньги никогда не списывались. Теперь реально проверяем и берём деньги.
		if(GetPlayerMoneyEx(playerid) < GARAGE_UPGRADE_PRICE) return Send(playerid, -1, "У вас не достаточно денег");
		GivePlayerMoney(playerid, -GARAGE_UPGRADE_PRICE);

		SetGarageData(idx, G_YLUCHENIE, 1);
		new query[128];
		mysql_format(mysql, query, sizeof(query), "UPDATE garage SET uluchenie=1 WHERE id=%d", GetGarageData(idx, G_SQL_ID));
		mysql_query(mysql, query, false);

		Send(playerid, -1, "Гараж улучшен");
	}

	switch(dialogid)
	{
		case DIALOG_GARAGE_MINU:
		{
			if (response)
			{
				switch (listitem)
				{
					case 0: ShowPlGarageInfo(playerid);
					case 1: SellGarageGos(playerid);
					case 2: Dialog(playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_INPUT, "Гараж", "Введите id игрока и цену", "Далее", "Отмена");
					case 3:
					{
						new action_id = GetPlayerGarage(playerid);
						if(GetGarageData(action_id, G_YLUCHENIE) == 0)
						{
							SetPVarInt(playerid, "garagecar", 1);
						}
						else if(GetGarageData(action_id, G_YLUCHENIE) == 1)
						{
							SetPVarInt(playerid, "garagecar", 2);
						}
						callcmd::car(playerid, "");
					}
					case 4:
					{
						new idx = GetPlayerGarage(playerid);
						new query[128];
						if(GetGarageData(idx, G_OPEN) == 0)
						{
							SetGarageData(idx, G_OPEN, 1);
							Send(playerid, -1, "Гараж закрыт");
							mysql_format(mysql, query, sizeof(query), "UPDATE garage SET open=%d WHERE id=%d",
								GetGarageData(idx, G_OPEN), GetGarageData(idx, G_SQL_ID));

							mysql_query(mysql, query, false);
						}
						else
						{
							SetGarageData(idx, G_OPEN, 0);
							Send(playerid, -1, "Гараж открыт");
							mysql_format(mysql, query, sizeof(query), "UPDATE garage SET open=%d WHERE id=%d",
								GetGarageData(idx, G_OPEN), GetGarageData(idx, G_SQL_ID));

							mysql_query(mysql, query, false);
						}
						UpdateGarageInfo(idx);
					}
					case 5: ShowYluchGarage(playerid);
					case 6:
					{
						new idx = GetPlayerGarage(playerid);
						EnablePlayerGPS
						(
							playerid,
							18,
							GetGarageData(idx, G_POS_X),
							GetGarageData(idx, G_POS_Y),
							GetGarageData(idx, G_POS_Z),
							""
						);
					}
				}
			}
		}
		case DIALOG_GARAGE_BUY:
		{
			new garageid = GetPlayerUseListitem(playerid);

			if(response)
			{
				// FIX: раньше сравнивали с захардкоженными 450000 - цена конкретного
				// гаража (G_PRICE) вообще не учитывалась, /addgarage [цена] был бы бесполезен.
				if(GetPlayerMoneyEx(playerid) >= GetGarageData(garageid, G_PRICE))
				{
					SendClientMessage(playerid, 0xFFFFFFFF, "Поздравляем! Вы приобрели гараж");
					BuyPlayerGarage(playerid, garageid);
				}
				else return Send(playerid, -1, "У вас не достаточно денег");
			}
		}
	}

	#if defined garage_OnDialogResponse
		return garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnDialogResponse
	#undef OnDialogResponse
#else
	#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse garage_OnDialogResponse
#if defined garage_OnDialogResponse
	forward garage_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public: LoadGarage()
{
	new idx;
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT * FROM garage", true);
	rows = cache_num_rows();

	if (rows > MAX_GARAGES)
	{
		rows = MAX_GARAGES;
		print("[Garage]: DB rows > MAX_GARAGES");
	}

	for (idx = 0; idx < rows; idx++)
	{
		SetGarageData(idx, G_SQL_ID, cache_get_field_content_int(idx, "id"));
		SetGarageData(idx, G_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));

		cache_get_field_content(idx, "owner_name", g_garage[idx][G_OWNER_NAME], mysql, 20);
		SetGarageData(idx, G_PRICE, cache_get_field_content_int(idx, "price"));
		SetGarageData(idx, G_OPEN, cache_get_field_content_int(idx, "open"));
		SetGarageData(idx, G_RENT_PRICE, cache_get_field_content_int(idx, "rent"));
		SetGarageData(idx, G_RENT_DATE, cache_get_field_content_int(idx, "rent_time"));
		SetGarageData(idx, G_YLUCHENIE, cache_get_field_content_int(idx, "uluchenie"));

		SetGarageData(idx, G_POS_X, cache_get_field_content_float(idx, "pos_x"));
		SetGarageData(idx, G_POS_Y, cache_get_field_content_float(idx, "pos_y"));
		SetGarageData(idx, G_POS_Z, cache_get_field_content_float(idx, "pos_z"));

		SetGarageData(idx, G_EXIT_POS_X, cache_get_field_content_float(idx, "exit_x"));
		SetGarageData(idx, G_EXIT_POS_Y, cache_get_field_content_float(idx, "exit_y"));
		SetGarageData(idx, G_EXIT_POS_Z, cache_get_field_content_float(idx, "exit_z"));

		new labelText[128];
		format(labelText, sizeof(labelText), "Нажмите [гудок] чтобы выехать");
		SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(labelText, 0x3399FFFF, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z) + 1.0, 15.0));
		SetGarageData(idx, G_ENTER_PICKUP, CreatePickup(19134, 23, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z), 0, PICKUP_ACTION_TYPE_GARAGE, idx));

		printf("[Garage]: Гараж %d загружен - X: %f, Y: %f, Z: %f", idx, GetGarageData(idx, G_POS_X), GetGarageData(idx, G_POS_Y), GetGarageData(idx, G_POS_Z));

		UpdateGarageInfo(idx);
	}

	g_garage_loaded = rows;
	cache_delete(result);

	CreateDynamic3DTextLabel("Посигнальте чтобы выехать", 0xFFD700FF, 492.701324, 1991.680786, 1547.679687, 10.0);
	CreateDynamic3DTextLabel("Посигнальте чтобы выехать", 0xFFD700FF, 0.998209, 1994.307739, 1554.203125, 10.0);
	// FIX: у CreatePickup не хватало action_id (5-го параметра) - было
	// CreatePickup(1318, 23, x, y, z, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT), а сигнатура
	// требует action_id последним аргументом (используется в OnPlayerPickUpPickupEx).
	// Раньше он просто был бы 0 по умолчанию - не критично для EXIT (действие не
	// зависит от action_id), но для единообразия с остальным кодом добавил явный 0.
	CreatePickup(1318, 23, 492.701324, 1991.680786, 1547.679687, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, 0);
	CreatePickup(1318, 23, 0.998209, 1994.307739, 1554.203125, -1, PICKUP_ACTION_TYPE_GARAGE_EXIT, 0);

	printf("[Garage]: Загружено гаражей: %d", g_garage_loaded);
}

stock UpdateGarageInfo(idx)
{
	new query[666];
	new Cache: result;

	if (GetGarageData(idx, G_OWNER_ID) > 0)
	{
		format(query, sizeof(query), "SELECT name FROM accounts WHERE id = %d", GetGarageData(idx, G_OWNER_ID));
		result = mysql_query(mysql, query, true);

		if (cache_num_rows() > 0)
		{
			new ownerName[32];
			cache_get_field_content(0, "name", ownerName, mysql, 32);

			format(query, sizeof(query), "- Гараж[%d]\nВладелец: %s\nНажмите {db1200}[гудок] {faf2f6}для входа \n \t{38bd1a}[%s]",
				GetGarageData(idx, G_SQL_ID), ownerName, GetGarageData(idx, G_OPEN) ? ("Закрыт") : ("Открыт"));
		}
		else
		{
			format(query, sizeof(query), "- Гараж[%d]\nНеверный владелец\nНажмите {db1200}[гудок] {faf2f6}для входа", GetGarageData(idx, G_SQL_ID));
		}
	}
	else
	{
		format(query, sizeof(query), "- Гараж[%d]\nГараж продается за %d рублей", GetGarageData(idx, G_SQL_ID), GetGarageData(idx, G_PRICE));
	}

	if (GetGarageData(idx, G_LABEL) != Text3D:-1)
	{
		UpdateDynamic3DTextLabelText(GetGarageData(idx, G_LABEL), 0xfaf2f6AA, query);
	}
	else
	{
		printf("Метка для гаража [%d] не найдена при обновлении!", idx);
	}

	cache_delete(result);
}

public: ShowPlayerGarageInfo(playerid, houseid)
{
	SetPlayerUseListitem(playerid, houseid);
	new fmt_str[256];
	format(fmt_str, sizeof fmt_str, "{FFFFFF}Гараж[%d] \n Цена %d\n Аренда 2500 р\n Вы действительно хотите приобрести данный гараж?", houseid + 1, GetGarageData(houseid, G_PRICE));
	Dialog(playerid, DIALOG_GARAGE_BUY, DIALOG_STYLE_MSGBOX, "{33CC00}Гараж свободен", fmt_str, "Купить", "Отмена");
}

stock EnterPlayerToGarage(playerid, entranceid)
{
	SetPlayerInGarage(playerid, entranceid);
	SetPlayerPosEx(playerid, 1.387492, 1995.810791, 1554.203125, 180, 1, entranceid);
}

// FIX: этих 4 функций не было в файле вообще - отсюда "undefined symbol" на
// BuyPlayerGarage / ShowPlGarageInfo / SellGarageGos / ShowYluchGarage.
// Это, кстати, объясняет и твою исходную проблему "купил гараж - не могу зайти":
// BuyPlayerGarage не существовала, значит при покупке G_OWNER_ID гаража никогда
// не выставлялся - гараж физически не переходил тебе, хотя деньги, скорее всего,
// списывались бы (если б функция компилировалась).

// Использую GivePlayerMoney(playerid, amount) - подтверждено из другого файла мода.

stock BuyPlayerGarage(playerid, garageid)
{
	if(garageid < 0 || garageid >= g_garage_loaded) return Send(playerid, -1, "Гараж не найден");
	if(IsGarageOwned(garageid)) return Send(playerid, -1, "Этот гараж уже куплен");

	// FIX: раньше списывались фиксированные 450000, а не цена конкретного гаража
	GivePlayerMoney(playerid, -GetGarageData(garageid, G_PRICE));

	SetGarageData(garageid, G_OWNER_ID, GetPlayerAccountID(playerid));
	SetPlayerData(playerid, P_GARAGE, garageid);

	new query[128];
	mysql_format(mysql, query, sizeof(query), "UPDATE garage SET owner_id=%d WHERE id=%d", GetPlayerAccountID(playerid), GetGarageData(garageid, G_SQL_ID));
	mysql_query(mysql, query, false);

	UpdateGarageInfo(garageid); // подтянет имя владельца из БД и обновит 3D-метку
	return 1;
}

stock ShowPlGarageInfo(playerid)
{
	new idx = GetPlayerGarage(playerid);
	if(idx == -1) return Send(playerid, -1, "У вас нет гаража");

	new str[256];
	format(str, sizeof str, "Гараж[%d]\nВладелец: %s\nСтатус: %s\nУлучшение: %s",
		GetGarageData(idx, G_SQL_ID),
		GetGarageData(idx, G_OWNER_NAME),
		GetGarageData(idx, G_OPEN) ? ("Закрыт") : ("Открыт"),
		GetGarageData(idx, G_YLUCHENIE) ? ("Куплено") : ("Нет"));

	Dialog(playerid, DIALOG_GARAGE_INFO, DIALOG_STYLE_MSGBOX, "Информация о гараже", str, "Ок", "");
	return 1;
}

stock SellGarageGos(playerid)
{
	new idx = GetPlayerGarage(playerid);
	if(idx == -1) return Send(playerid, -1, "У вас нет гаража");

	// FIX: раньше возврат был захардкожен как 225000 (половина от старых 450000) -
	// теперь считается от реальной цены конкретного гаража.
	new refund = GetGarageData(idx, G_PRICE) / 2;
	GivePlayerMoney(playerid, refund);

	SetGarageData(idx, G_OWNER_ID, 0);
	SetGarageData(idx, G_YLUCHENIE, 0);
	SetGarageData(idx, G_OPEN, 0);
	SetPlayerData(playerid, P_GARAGE, -1);

	new query[128];
	mysql_format(mysql, query, sizeof(query), "UPDATE garage SET owner_id=0, uluchenie=0, open=0 WHERE id=%d", GetGarageData(idx, G_SQL_ID));
	mysql_query(mysql, query, false);

	UpdateGarageInfo(idx);
	Send(playerid, -1, "Вы продали гараж государству");
	return 1;
}

stock ShowYluchGarage(playerid)
{
	new idx = GetPlayerGarage(playerid);
	if(idx == -1) return Send(playerid, -1, "У вас нет гаража");
	if(GetGarageData(idx, G_YLUCHENIE) == 1) return Send(playerid, -1, "Улучшение уже куплено");

	new str[160];
	format(str, sizeof str, "Расширить гараж - доп. место под транспорт.\nЦена: %d руб.\nКупить улучшение?", GARAGE_UPGRADE_PRICE);
	Dialog(playerid, DIALOG_GARAGE_UPGRADE, DIALOG_STYLE_MSGBOX, "Улучшение гаража", str, "Купить", "Отмена");
	return 1;
}

// ================= КОМАНДЫ =================
// Их не было вообще - без команд попасть в меню DIALOG_GARAGE_MINU и в диалог
// продажи DIALOG_GARAGE_SELL было просто неоткуда, только через пикап.

CMD:garage(playerid, params[])
{
	#pragma unused params
	new idx = GetPlayerGarage(playerid);
	if(idx == -1) return Send(playerid, -1, "У вас нет гаража");

	new str[256];
	format(str, sizeof str, "Информация о гараже\nПродать гараж государству\nПродать гараж игроку\nВзять/поставить машину\n%s\nУлучшение гаража\nGPS до гаража",
		GetGarageData(idx, G_OPEN) ? ("Открыть гараж") : ("Закрыть гараж"));

	// FIX/ДОПОЛНЕНИЕ: пункты списка идут в том же порядке, что и switch(listitem)
	// внутри DIALOG_GARAGE_MINU в OnDialogResponse (case 0..6) - не меняй порядок строк.
	Dialog(playerid, DIALOG_GARAGE_MINU, DIALOG_STYLE_LIST, "Меню гаража", str, "Выбрать", "Закрыть");
	return 1;
}

CMD:sellmygarage(playerid, params[])
{
	#pragma unused params
	if(GetPlayerGarage(playerid) == -1) return Send(playerid, -1, "У вас нет гаража");
	SellGarageGos(playerid);
	return 1;
}

CMD:sellgarage(playerid, params[])
{
	if(GetPlayerGarage(playerid) == -1) return Send(playerid, -1, "У вас нет гаража");

	if(!isnull(params))
	{
		// /sellgarage [id игрока] [цена] - сразу отправляет оффер, без диалога
		new to_player, price;
		if(sscanf(params, "ud", to_player, price))
			return Send(playerid, -1, "Используй: /sellgarage [id] [цена]");

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		if(!IsPlayerInRangeOfPoint(to_player, 5.0, x, y, z)) return Send(playerid, -1, "Игрок далеко");
		if(GetPlayerMoneyEx(to_player) < price) return ShowNotification(playerid, 2, "У игрока не достаточно денег", 4, " ", "");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_BUY_GARAGE, price);
		SetPVarInt(to_player, "GarageSellerID", playerid);
		SetPVarInt(to_player, "GaragePrice", price);
		ShowNotification(to_player, 4, "Покупка гаража", 7, "/yes", ">>");
		return 1;
	}

	// без параметров - открывает тот же диалог ввода, что и пункт "2" в меню /garage
	Dialog(playerid, DIALOG_GARAGE_SELL, DIALOG_STYLE_INPUT, "Гараж", "Введите id игрока и цену", "Далее", "Отмена");
	return 1;
}

CMD:addgarage(playerid, params[])
{
	// FIX: было pInfo[playerid][pAdmin] - угадал неправильно. Реальная проверка
	// (взята из твоего /kick) - GetPlayerAdminEx(playerid).
	if(GetPlayerAdminEx(playerid) < 4) return Send(playerid, -1, "У вас нет доступа к этой команде");

	if(g_garage_loaded >= MAX_GARAGES) return Send(playerid, -1, "Достигнут лимит гаражей (MAX_GARAGES)");

	// ДОБАВЛЕНО: раньше params принимался, но полностью игнорировался - цена всегда
	// была захардкожена как 450000. Теперь /addgarage [цена] реально работает,
	// без параметра берётся GARAGE_DEFAULT_PRICE.
	new price = GARAGE_DEFAULT_PRICE;
	if(!isnull(params))
	{
		if(sscanf(params, "d", price))
			return Send(playerid, -1, "Используй: /addgarage [цена] (без параметра - цена по умолчанию)");
		if(price <= 0) return Send(playerid, -1, "Цена должна быть больше 0");
	}

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new query[400];
	mysql_format(mysql, query, sizeof(query),
		"INSERT INTO garage (owner_id, price, open, rent, rent_time, uluchenie, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z) VALUES (0, %d, 0, 0, 0, 0, %f, %f, %f, %f, %f, %f)",
		price, x, y, z, x, y, z);
	mysql_tquery(mysql, query, "OnGarageAdded", "id", playerid, price);
	return 1;
}

forward OnGarageAdded(playerid, price);
public OnGarageAdded(playerid, price)
{
	new insert_id = cache_insert_id();
	if(insert_id <= 0) return Send(playerid, -1, "Ошибка добавления гаража в БД");

	new idx = g_garage_loaded;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	SetGarageData(idx, G_SQL_ID, insert_id);
	SetGarageData(idx, G_OWNER_ID, 0);
	SetGarageData(idx, G_PRICE, price);
	SetGarageData(idx, G_OPEN, 0);
	SetGarageData(idx, G_YLUCHENIE, 0);
	SetGarageData(idx, G_POS_X, x);
	SetGarageData(idx, G_POS_Y, y);
	SetGarageData(idx, G_POS_Z, z);
	SetGarageData(idx, G_EXIT_POS_X, x);
	SetGarageData(idx, G_EXIT_POS_Y, y);
	SetGarageData(idx, G_EXIT_POS_Z, z);
	SetGarageData(idx, G_EXIT_ANGLE, 0.0);

	new labelText[128];
	format(labelText, sizeof(labelText), "Нажмите [гудок] чтобы выехать");
	SetGarageData(idx, G_LABEL, CreateDynamic3DTextLabel(labelText, 0x3399FFFF, x, y, z + 1.0, 15.0));
	SetGarageData(idx, G_ENTER_PICKUP, CreatePickup(19134, 23, x, y, z, 0, PICKUP_ACTION_TYPE_GARAGE, idx));

	g_garage_loaded++;
	UpdateGarageInfo(idx);

	Send(playerid, -1, "Гараж добавлен и создан на вашей текущей позиции");
	return 1;
}

// FIX: раньше в OnGarageAdded точка выхода нового гаража ставилась = точке входа
// (за неимением других координат) - если вход стоит не прямо на земле снаружи,
// игрока при выходе роняет в никуда (падение в небо, как на твоём скрине).
// Эта команда позволяет вручную выставить точку выхода конкретного гаража
// на текущую позицию/поворот админа.
stock FindGarageIndexBySqlId(sqlid)
{
	for(new i = 0; i < g_garage_loaded; i++)
	{
		if(GetGarageData(i, G_SQL_ID) == sqlid) return i;
	}
	return -1;
}

CMD:gsetexpos(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 4) return Send(playerid, -1, "У вас нет доступа к этой команде");
	if(isnull(params)) return Send(playerid, -1, "Используй: /gsetexpos [ID гаража]");

	new sqlid;
	if(sscanf(params, "d", sqlid)) return Send(playerid, -1, "Используй: /gsetexpos [ID гаража]");

	new idx = FindGarageIndexBySqlId(sqlid);
	if(idx == -1) return Send(playerid, -1, "Гараж с таким ID не найден");

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	SetGarageData(idx, G_EXIT_POS_X, x);
	SetGarageData(idx, G_EXIT_POS_Y, y);
	SetGarageData(idx, G_EXIT_POS_Z, z);
	SetGarageData(idx, G_EXIT_ANGLE, a);

	new query[200];
	mysql_format(mysql, query, sizeof(query), "UPDATE garage SET exit_x=%f, exit_y=%f, exit_z=%f, exit_angle=%f WHERE id=%d", x, y, z, a, GetGarageData(idx, G_SQL_ID));
	mysql_query(mysql, query, false);

	Send(playerid, -1, "Точка выхода гаража обновлена на вашу текущую позицию");
	return 1;
}

// ВНИМАНИЕ - эти вызовы остаются на твоей совести, должны быть определены где-то
// ещё в геймоде: SendPlayerOffer, callcmd::car, Send, ShowNotification, Dialog,
// GetPlayerMoneyEx, COLOR_RED, P_GARAGE (поле в enum игрока), CMD: (Pawn.CMD.inc), sscanf, isnull.
// Если при компиляции вылезет undefined symbol на что-то из этого списка - кинь
// ошибку, я гляну.
