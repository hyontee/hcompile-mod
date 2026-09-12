// ============================================================================
//  garages.pwn — Система гаражей (покупка / аренда / парковка)
//  Авторство: by_ml_skarf | Ml Skarf
//  Проект: Ml Skarf
//  Подключение: #include "garages.pwn"
// ============================================================================

#if defined _GARAGES_SYSTEM_INCLUDED
	#endinput
#endif
#define _GARAGES_SYSTEM_INCLUDED

// ---------------------------------------------------------------------------
//  Настройки
// ---------------------------------------------------------------------------
#define MAX_GARAGES                 50
#define GARAGE_INTERIOR             1
#define GARAGE_VW_OFFSET            50000
#define GARAGE_ENTER_DISTANCE       3.0
#define GARAGE_BUY_PRICE            1500000
#define GARAGE_RENT_PRICE           50000       // в сутки
#define GARAGE_PARK_PRICE           0
#define GARAGE_MAX_VEHICLES         2

// Диалоги
#define DIALOG_GARAGE_MAIN          18600
#define DIALOG_GARAGE_BUY           18601
#define DIALOG_GARAGE_RENT          18602
#define DIALOG_GARAGE_MANAGE        18603
#define DIALOG_GARAGE_CONFIRM_SELL  18604

// ---------------------------------------------------------------------------
//  Данные гаража
// ---------------------------------------------------------------------------
enum e_Garage
{
	gSQL_ID,
	gOwnerID,               // account id (-1 = свободен)
	gRenterID,              // кто арендует (-1 = никто)
	gRentUntil,             // unix timestamp
	Float:gEnterX,
	Float:gEnterY,
	Float:gEnterZ,
	Float:gEnterA,
	Float:gExitX,           // точка внутри
	Float:gExitY,
	Float:gExitZ,
	Float:gExitA,
	gInterior,
	gPickup,
	Text3D:gLabel,
	bool:gLoaded
}

new g_Garages[MAX_GARAGES][e_Garage];
new g_GarageCount = 0;

new g_PlayerInGarage[MAX_PLAYERS] = {-1, ...};
new g_PlayerGarageVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

// ---------------------------------------------------------------------------
//  Примерные точки гаражей (подставь свои координаты)
// ---------------------------------------------------------------------------
new Float:g_GarageEnterPos[][4] =
{
	{ 2495.0,  -1680.0,  13.5,  90.0  },   // пример 1
	{ 2130.0,  -1150.0,  24.0,  180.0 },   // пример 2
	{ 1650.0,  -1850.0,  13.5,  0.0   },   // пример 3
	{ -2000.0,  150.0,   27.5,  270.0 },   // пример 4
	{ 0.0, 0.0, 0.0, 0.0 }                 // конец
};

new Float:g_GarageInteriorPos[4] = { 607.0, -6.0, 1000.9, 90.0 }; // стандартный интерьер гаража

// ---------------------------------------------------------------------------
//  Инициализация
// ---------------------------------------------------------------------------
stock Garages_Init()
{
	// Создаём таблицу если нет
	mysql_tquery(mysql, "CREATE TABLE IF NOT EXISTS `player_garages` (\
		`id` INT(11) NOT NULL AUTO_INCREMENT,\
		`owner_id` INT(11) NOT NULL DEFAULT -1,\
		`renter_id` INT(11) NOT NULL DEFAULT -1,\
		`rent_until` INT(11) NOT NULL DEFAULT 0,\
		`enter_x` FLOAT NOT NULL,\
		`enter_y` FLOAT NOT NULL,\
		`enter_z` FLOAT NOT NULL,\
		`enter_a` FLOAT NOT NULL,\
		PRIMARY KEY (`id`)\
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;");

	// Загружаем
	mysql_tquery(mysql, "SELECT * FROM `player_garages`", "OnGaragesLoaded");

	printf("[GARAGES] Система гаражей загружена | by_ml_skarf");
	return 1;
}

forward OnGaragesLoaded();
public OnGaragesLoaded()
{
	new rows = cache_num_rows();
	g_GarageCount = 0;

	for(new i = 0; i < rows && i < MAX_GARAGES; i++)
	{
		g_Garages[i][gSQL_ID]     = cache_get_field_content_int(i, "id");
		g_Garages[i][gOwnerID]    = cache_get_field_content_int(i, "owner_id");
		g_Garages[i][gRenterID]   = cache_get_field_content_int(i, "renter_id");
		g_Garages[i][gRentUntil]  = cache_get_field_content_int(i, "rent_until");
		g_Garages[i][gEnterX]     = cache_get_field_content_float(i, "enter_x");
		g_Garages[i][gEnterY]     = cache_get_field_content_float(i, "enter_y");
		g_Garages[i][gEnterZ]     = cache_get_field_content_float(i, "enter_z");
		g_Garages[i][gEnterA]     = cache_get_field_content_float(i, "enter_a");

		g_Garages[i][gExitX] = g_GarageInteriorPos[0];
		g_Garages[i][gExitY] = g_GarageInteriorPos[1];
		g_Garages[i][gExitZ] = g_GarageInteriorPos[2];
		g_Garages[i][gExitA] = g_GarageInteriorPos[3];
		g_Garages[i][gInterior] = GARAGE_INTERIOR;
		g_Garages[i][gLoaded] = true;

		Garages_CreatePickup(i);
		g_GarageCount++;
	}

	// Если в БД пусто — создаём из массива координат
	if(g_GarageCount == 0)
	{
		for(new i = 0; i < sizeof(g_GarageEnterPos); i++)
		{
			if(g_GarageEnterPos[i][0] == 0.0 && g_GarageEnterPos[i][1] == 0.0) break;
			if(g_GarageCount >= MAX_GARAGES) break;

			Garages_CreateNew(
				g_GarageEnterPos[i][0],
				g_GarageEnterPos[i][1],
				g_GarageEnterPos[i][2],
				g_GarageEnterPos[i][3]
			);
		}
	}

	printf("[GARAGES] Загружено гаражей: %d | by_ml_skarf", g_GarageCount);
	return 1;
}

stock Garages_CreateNew(Float:x, Float:y, Float:z, Float:a)
{
	new idx = g_GarageCount;
	if(idx >= MAX_GARAGES) return -1;

	g_Garages[idx][gSQL_ID]    = 0;
	g_Garages[idx][gOwnerID]   = -1;
	g_Garages[idx][gRenterID]  = -1;
	g_Garages[idx][gRentUntil] = 0;
	g_Garages[idx][gEnterX]    = x;
	g_Garages[idx][gEnterY]    = y;
	g_Garages[idx][gEnterZ]    = z;
	g_Garages[idx][gEnterA]    = a;
	g_Garages[idx][gExitX]     = g_GarageInteriorPos[0];
	g_Garages[idx][gExitY]     = g_GarageInteriorPos[1];
	g_Garages[idx][gExitZ]     = g_GarageInteriorPos[2];
	g_Garages[idx][gExitA]     = g_GarageInteriorPos[3];
	g_Garages[idx][gInterior]  = GARAGE_INTERIOR;
	g_Garages[idx][gLoaded]    = true;

	new query[256];
	mysql_format(mysql, query, sizeof(query),
		"INSERT INTO `player_garages` (owner_id, renter_id, rent_until, enter_x, enter_y, enter_z, enter_a) \
		VALUES (-1, -1, 0, %f, %f, %f, %f)",
		x, y, z, a);
	mysql_tquery(mysql, query, "OnGarageInserted", "i", idx);

	Garages_CreatePickup(idx);
	g_GarageCount++;
	return idx;
}

forward OnGarageInserted(idx);
public OnGarageInserted(idx)
{
	g_Garages[idx][gSQL_ID] = cache_insert_id();
	return 1;
}

stock Garages_CreatePickup(idx)
{
	if(g_Garages[idx][gPickup]) DestroyPickup(g_Garages[idx][gPickup]);
	if(g_Garages[idx][gLabel]) Delete3DTextLabel(g_Garages[idx][gLabel]);

	g_Garages[idx][gPickup] = CreatePickup(19134, 23,
		g_Garages[idx][gEnterX],
		g_Garages[idx][gEnterY],
		g_Garages[idx][gEnterZ] + 0.3,
		-1);

	new label[128];
	if(g_Garages[idx][gOwnerID] == -1 && g_Garages[idx][gRenterID] == -1)
		format(label, sizeof(label), "{00FF00}Гараж на продаже\n{FFFFFF}Цена: %d$", GARAGE_BUY_PRICE);
	else if(g_Garages[idx][gRenterID] != -1)
		format(label, sizeof(label), "{FFD700}Гараж (аренда)\n{FFFFFF}ID: %d", idx);
	else
		format(label, sizeof(label), "{FFD700}Частный гараж\n{FFFFFF}ID: %d", idx);

	g_Garages[idx][gLabel] = Create3DTextLabel(label, 0xFFFFFFFF,
		g_Garages[idx][gEnterX],
		g_Garages[idx][gEnterY],
		g_Garages[idx][gEnterZ] + 1.1,
		12.0, 0, 0);
	return 1;
}

// ---------------------------------------------------------------------------
//  Вспомогательные
// ---------------------------------------------------------------------------
stock Garages_GetNear(playerid)
{
	for(new i = 0; i < g_GarageCount; i++)
	{
		if(!g_Garages[i][gLoaded]) continue;
		if(IsPlayerInRangeOfPoint(playerid, GARAGE_ENTER_DISTANCE,
			g_Garages[i][gEnterX], g_Garages[i][gEnterY], g_Garages[i][gEnterZ]))
			return i;
	}
	return -1;
}

stock Garages_IsOwner(playerid, garageid)
{
	if(garageid < 0 || garageid >= g_GarageCount) return 0;
	return (g_Garages[garageid][gOwnerID] == GetPlayerAccountID(playerid));
}

stock Garages_IsRenter(playerid, garageid)
{
	if(garageid < 0 || garageid >= g_GarageCount) return 0;
	return (g_Garages[garageid][gRenterID] == GetPlayerAccountID(playerid));
}

stock Garages_HasAccess(playerid, garageid)
{
	return (Garages_IsOwner(playerid, garageid) || Garages_IsRenter(playerid, garageid));
}

stock Garages_GetPlayerGarage(playerid)
{
	new acc = GetPlayerAccountID(playerid);
	for(new i = 0; i < g_GarageCount; i++)
	{
		if(g_Garages[i][gOwnerID] == acc || g_Garages[i][gRenterID] == acc)
			return i;
	}
	return -1;
}

// ---------------------------------------------------------------------------
//  Основные действия
// ---------------------------------------------------------------------------
stock Garages_Enter(playerid, garageid)
{
	if(garageid < 0 || garageid >= g_GarageCount) return 0;
	if(!Garages_HasAccess(playerid, garageid))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к этому гаражу", " ");
		return 0;
	}

	new vw = GARAGE_VW_OFFSET + garageid;

	SetPlayerPos(playerid,
		g_Garages[garageid][gExitX],
		g_Garages[garageid][gExitY],
		g_Garages[garageid][gExitZ]);
	SetPlayerFacingAngle(playerid, g_Garages[garageid][gExitA]);
	SetPlayerInterior(playerid, g_Garages[garageid][gInterior]);
	SetPlayerVirtualWorld(playerid, vw);

	g_PlayerInGarage[playerid] = garageid;

	SendClientMessage(playerid, 0xFFD700FF, "Вы вошли в гараж. Используйте /exitgarage чтобы выйти.");
	return 1;
}

stock Garages_Exit(playerid)
{
	new garageid = g_PlayerInGarage[playerid];
	if(garageid == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не в гараже", " ");
		return 0;
	}

	SetPlayerPos(playerid,
		g_Garages[garageid][gEnterX],
		g_Garages[garageid][gEnterY],
		g_Garages[garageid][gEnterZ] + 0.5);
	SetPlayerFacingAngle(playerid, g_Garages[garageid][gEnterA]);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

	g_PlayerInGarage[playerid] = -1;
	SendClientMessage(playerid, 0xFFD700FF, "Вы вышли из гаража.");
	return 1;
}

stock Garages_Buy(playerid, garageid)
{
	if(garageid < 0 || garageid >= g_GarageCount) return 0;

	if(g_Garages[garageid][gOwnerID] != -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Этот гараж уже куплен", " ");
		return 0;
	}

	if(Garages_GetPlayerGarage(playerid) != -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас уже есть гараж", " ");
		return 0;
	}

	if(GetPlayerMoney(playerid) < GARAGE_BUY_PRICE)
	{
		ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно денег", " ");
		return 0;
	}

	GivePlayerMoneyEx(playerid, -GARAGE_BUY_PRICE, "Покупка гаража", true, true);

	g_Garages[garageid][gOwnerID] = GetPlayerAccountID(playerid);
	g_Garages[garageid][gRenterID] = -1;
	g_Garages[garageid][gRentUntil] = 0;

	new query[160];
	mysql_format(mysql, query, sizeof(query),
		"UPDATE `player_garages` SET `owner_id` = %d, `renter_id` = -1, `rent_until` = 0 WHERE `id` = %d",
		GetPlayerAccountID(playerid), g_Garages[garageid][gSQL_ID]);
	mysql_tquery(mysql, query);

	// Обновляем поле garage в аккаунте
	SetPlayerData(playerid, P_GARAGE_TYPE, garageid);

	Garages_CreatePickup(garageid);

	SendClientMessage(playerid, 0x00FF00FF, "Вы успешно купили гараж!");
	return 1;
}

stock Garages_Sell(playerid)
{
	new garageid = Garages_GetPlayerGarage(playerid);
	if(garageid == -1 || !Garages_IsOwner(playerid, garageid))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет гаража для продажи", " ");
		return 0;
	}

	new returnMoney = floatround(GARAGE_BUY_PRICE * 0.7);
	GivePlayerMoneyEx(playerid, returnMoney, "Продажа гаража", true, true);

	g_Garages[garageid][gOwnerID] = -1;
	g_Garages[garageid][gRenterID] = -1;
	g_Garages[garageid][gRentUntil] = 0;

	new query[160];
	mysql_format(mysql, query, sizeof(query),
		"UPDATE `player_garages` SET `owner_id` = -1, `renter_id` = -1, `rent_until` = 0 WHERE `id` = %d",
		g_Garages[garageid][gSQL_ID]);
	mysql_tquery(mysql, query);

	SetPlayerData(playerid, P_GARAGE_TYPE, -1);

	Garages_CreatePickup(garageid);

	new msg[96];
	format(msg, sizeof(msg), "Вы продали гараж и получили %d$", returnMoney);
	SendClientMessage(playerid, 0x00FF00FF, msg);
	return 1;
}

stock Garages_ParkVehicle(playerid)
{
	new garageid = g_PlayerInGarage[playerid];
	if(garageid == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы должны быть внутри гаража", " ");
		return 0;
	}

	if(!Garages_HasAccess(playerid, garageid))
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Нет доступа", " ");
		return 0;
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == 0)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы должны быть в транспорте", " ");
		return 0;
	}

	// Здесь можно добавить сохранение позиции/модели в ownable_cars
	// Для простоты просто убираем машину
	RemovePlayerFromVehicle(playerid);
	DestroyVehicle(vehicleid); // или SetVehicleToRespawn + скрыть

	SendClientMessage(playerid, 0x00FF00FF, "Транспорт припаркован в гараже.");
	return 1;
}

// ---------------------------------------------------------------------------
//  Диалоги
// ---------------------------------------------------------------------------
stock ShowGarageMainDialog(playerid)
{
	new garageid = Garages_GetNear(playerid);
	if(garageid == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не рядом с гаражом", " ");
		return 0;
	}

	new string[512];
	new bool:isFree = (g_Garages[garageid][gOwnerID] == -1 && g_Garages[garageid][gRenterID] == -1);
	new bool:hasAccess = Garages_HasAccess(playerid, garageid);

	if(isFree)
	{
		format(string, sizeof(string),
			"{FFFFFF}Гараж свободен\n\n\
			{00FF00}1. Купить гараж ({FFFFFF}%d${00FF00})\n\
			{AAAAAA}2. Информация",
			GARAGE_BUY_PRICE);
	}
	else if(hasAccess)
	{
		format(string, sizeof(string),
			"{FFFFFF}Ваш гараж (ID %d)\n\n\
			{00FF00}1. Войти в гараж\n\
			{FFD700}2. Управление\n\
			{FF5252}3. Продать гараж",
			garageid);
	}
	else
	{
		format(string, sizeof(string),
			"{FFFFFF}Чужой гараж\n\n\
			{AAAAAA}Доступ закрыт.");
	}

	ShowPlayerDialog(playerid, DIALOG_GARAGE_MAIN, DIALOG_STYLE_LIST,
		"{FFD700}Гараж | by_ml_skarf", string, "Выбрать", "Закрыть");
	return 1;
}

// Переименовано под berkut.pwn: вызывается из основного public OnDialogResponse
stock Garages_MainDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{

	switch(dialogid)
	{
		case DIALOG_GARAGE_MAIN:
		{
			if(!response) return 1;

			new garageid = Garages_GetNear(playerid);
			if(garageid == -1) return 1;

			new bool:isFree = (g_Garages[garageid][gOwnerID] == -1 && g_Garages[garageid][gRenterID] == -1);
			new bool:hasAccess = Garages_HasAccess(playerid, garageid);

			if(isFree)
			{
				if(listitem == 0) Garages_Buy(playerid, garageid);
			}
			else if(hasAccess)
			{
				switch(listitem)
				{
					case 0: Garages_Enter(playerid, garageid);
					case 1:
					{
						ShowPlayerDialog(playerid, DIALOG_GARAGE_MANAGE, DIALOG_STYLE_LIST,
							"{FFD700}Управление гаражом",
							"1. Припарковать транспорт\n2. Информация",
							"Выбрать", "Назад");
					}
					case 2:
					{
						new string[160];
						format(string, sizeof(string),
							"{FFFFFF}Вы уверены, что хотите продать гараж?\n\
							Вы получите {00FF00}%d$", floatround(GARAGE_BUY_PRICE * 0.7));
						ShowPlayerDialog(playerid, DIALOG_GARAGE_CONFIRM_SELL, DIALOG_STYLE_MSGBOX,
							"{FF5252}Продажа гаража", string, "Продать", "Отмена");
					}
				}
			}
			return 1;
		}

		case DIALOG_GARAGE_MANAGE:
		{
			if(!response) return 1;
			if(listitem == 0) Garages_ParkVehicle(playerid);
			return 1;
		}

		case DIALOG_GARAGE_CONFIRM_SELL:
		{
			if(response) Garages_Sell(playerid);
			return 1;
		}
	}
	return 0;
}

// ---------------------------------------------------------------------------
//  Команды
// ---------------------------------------------------------------------------
CMD:garage(playerid, params[])
{
	ShowGarageMainDialog(playerid);
	return 1;
}

CMD:entergarage(playerid, params[])
{
	new garageid = Garages_GetNear(playerid);
	if(garageid == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Вы не рядом с гаражом", " ");
		return 1;
	}
	Garages_Enter(playerid, garageid);
	return 1;
}

CMD:exitgarage(playerid, params[])
{
	Garages_Exit(playerid);
	return 1;
}

CMD:parkgarage(playerid, params[])
{
	Garages_ParkVehicle(playerid);
	return 1;
}

CMD:addgarage(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 6)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "РЈ РІР°СЃ РЅРµС‚ РґРѕСЃС‚СѓРїР° Рє РёСЃРїРѕР»СЊР·РѕРІР°РЅРёСЋ РґР°РЅРЅРѕР№ РєРѕРјР°РЅРґС‹", " ");
		return 1;
	}

	if(g_GarageCount >= MAX_GARAGES)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "Р”РѕСЃС‚РёРіРЅСѓС‚ Р»РёРјРёС‚ РєРѕР»РёС‡РµСЃС‚РІР° РіР°СЂР°Р¶РµР№", " ");
		return 1;
	}

	new Float:x, Float:y, Float:z, Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new garageid = Garages_CreateNew(x, y, z, a);
	if(garageid == -1)
	{
		ShowNotificationNew(playerid, 2, 3, 0, 0, "РќРµ СѓРґР°Р»РѕСЃСЊ СЃРѕР·РґР°С‚СЊ РіР°СЂР°Р¶", " ");
		return 1;
	}

	new msg[128];
	format(msg, sizeof(msg), "Р’С‹ СЃРѕР·РґР°Р»Рё РЅРѕРІС‹Р№ РіР°СЂР°Р¶ (ID %d) РЅР° СЃРІРѕРµР№ РїРѕР·РёС†РёРё", garageid);
	SendClientMessage(playerid, 0x00FF00FF, msg);

	format(msg, sizeof(msg), "[A] %s[%d] СЃРѕР·РґР°Р» РіР°СЂР°Р¶ ID %d", GetPlayerNameEx(playerid), playerid, garageid);
	SendMessageToAdmins(msg, 0x999999FF);

	return 1;
}

// ---------------------------------------------------------------------------
//  Хуки
// ---------------------------------------------------------------------------
// Переименовано под berkut.pwn: вызывается из основного public OnPlayerConnect
stock Garages_ConnectHook(playerid)
{
	g_PlayerInGarage[playerid] = -1;
	g_PlayerGarageVehicle[playerid] = INVALID_VEHICLE_ID;
	return 1;
}

// Переименовано под berkut.pwn: вызывается из основного public OnPlayerDisconnect
stock Garages_DisconnectHook(playerid, reason)
{
	if(g_PlayerInGarage[playerid] != -1)
	{
		// Можно сохранять последнюю позицию
		g_PlayerInGarage[playerid] = -1;
	}
	return 1;
}

// Переименовано под berkut.pwn: вызывается из public OnPlayerPickUpPickup (include/system/pickup.pwn)
// Возвращает 1, если пикап обработан системой гаражей (дальше не идём в action_type диспетчер)
new g_GarageDialogCooldown[MAX_PLAYERS] = {0, ...};

stock Garages_HandlePickup(playerid, pickupid)
{
	for(new i = 0; i < g_GarageCount; i++)
	{
		if(g_Garages[i][gPickup] == pickupid)
		{
			if(g_GarageDialogCooldown[playerid] > GetTickCount())
				return 1;

			g_GarageDialogCooldown[playerid] = GetTickCount() + 1500;

			ShowGarageMainDialog(playerid);
			return 1;
		}
	}
	return 0;
}

// ---------------------------------------------------------------------------
//  Вызов при старте:
//  В OnGameModeInit():
//      Garages_Init();
// ============================================================================
