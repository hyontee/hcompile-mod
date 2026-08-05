/*
06.12.2017
*/
#define AC_PARAMS_ENGINE			(0)                                         // Двигатель
#define AC_PARAMS_LIGHTS			(1)                                         // Фары
#define AC_PARAMS_ALARM				(2)                                         // Сигнализация
#define AC_PARAMS_DOORS				(3)                                         // Двери
#define AC_PARAMS_BONNET			(4)                                         // Капот
#define AC_PARAMS_BOOT				(5)                                         // Багажник
#define AC_PARAMS_OBJECTIVE			(6)                                         // Стрелка над автомобилем

#define AC_STATE_ONFOOT				(0)											// Пешеход
#define AC_STATE_DRIVER				(1)											// Водитель
#define AC_STATE_PASSENGER			(2)											// Пассажир

#define AC_STATUS_PANEL             (0)                                         // Корпус
#define AC_STATUS_DOOR              (1)                                         // Двери
#define AC_STATUS_LIGHT             (2)                                         // Фары
#define AC_STATUS_TIRE              (3)                                         // Колеса

// Даёт или отнимает у игрока определенную сумму денег.
stock AC_GivePlayerMoney(playerid, money) return CallRemoteFunction("AC_GivePlayerMoney", "dd", playerid, money);
#if defined _ALS_GivePlayerMoney
    #undef GivePlayerMoney
#else
    #define _ALS_GivePlayerMoney
#endif
#define GivePlayerMoney AC_GivePlayerMoney

// Устанавливает игроку определенную суму денег.
stock AC_SetPlayerMoney(playerid, money) return CallRemoteFunction("AC_SetPlayerMoney", "dd", playerid, money);

// Забирает у игрока все деньги.
stock AC_ResetPlayerMoney(playerid) return CallRemoteFunction("AC_ResetPlayerMoney", "d", playerid);
#if defined _ALS_ResetPlayerMoney
    #undef ResetPlayerMoney
#else
    #define _ALS_ResetPlayerMoney
#endif
#define ResetPlayerMoney AC_ResetPlayerMoney

// Позволяет узнать количество денег игрока.
stock AC_GetPlayerMoney(playerid) return CallRemoteFunction("AC_GetPlayerMoney", "d", playerid);
#if defined _ALS_GetPlayerMoney
    #undef GetPlayerMoney
#else
    #define _ALS_GetPlayerMoney
#endif
#define GetPlayerMoney AC_GetPlayerMoney

// Устанавливает уровень здоровья игрока.
stock AC_SetPlayerHealth(playerid, Float:health) return CallRemoteFunction("AC_SetPlayerHealth", "df", playerid, health);
#if defined _ALS_SetPlayerHealth
    #undef SetPlayerHealth
#else
    #define _ALS_SetPlayerHealth
#endif
#define SetPlayerHealth AC_SetPlayerHealth

// Устанавливает уровень брони игрока.
stock AC_SetPlayerArmour(playerid, Float:armour) return CallRemoteFunction("AC_SetPlayerArmour", "df", playerid, armour);
#if defined _ALS_SetPlayerArmour
    #undef SetPlayerArmour
#else
    #define _ALS_SetPlayerArmour
#endif
#define SetPlayerArmour AC_SetPlayerArmour

// Переключает игрока в режим Spectating.
stock AC_TogglePlayerSpectating(playerid, toggle) return CallRemoteFunction("AC_TogglePlayerSpectating", "dd", playerid, toggle);
#if defined _ALS_TogglePlayerSpectating
    #undef TogglePlayerSpectating
#else
    #define _ALS_TogglePlayerSpectating
#endif
#define TogglePlayerSpectating AC_TogglePlayerSpectating

// Замораживает игрока.
stock AC_TogglePlayerControllable(playerid, toggle) return CallRemoteFunction("AC_TogglePlayerControllable", "dd", playerid, toggle);
#if defined _ALS_TogglePlayerControllable
    #undef TogglePlayerControllable
#else
    #define _ALS_TogglePlayerControllable
#endif
#define TogglePlayerControllable AC_TogglePlayerControllable

// Устанавливает интерьер игроку.
stock AC_SetPlayerInterior(playerid, interiorid) return CallRemoteFunction("AC_SetPlayerInterior", "dd", playerid, interiorid);
#if defined _ALS_SetPlayerInterior
    #undef SetPlayerInterior
#else
    #define _ALS_SetPlayerInterior
#endif
#define SetPlayerInterior AC_SetPlayerInterior

// Узнает в каком интерьере игрок.
stock AC_GetPlayerInterior(playerid) return CallRemoteFunction("AC_GetPlayerInterior", "d", playerid);
#if defined _ALS_GetPlayerInterior
    #undef GetPlayerInterior
#else
    #define _ALS_GetPlayerInterior
#endif
#define GetPlayerInterior AC_GetPlayerInterior

// Установить действие игроку
stock AC_SetPlayerSpecialAction(playerid, actionid) return CallRemoteFunction("AC_SetPlayerSpecialAction", "dd", playerid, actionid);
#if defined _ALS_SetPlayerSpecialAction
    #undef SetPlayerSpecialAction
#else
    #define _ALS_SetPlayerSpecialAction
#endif
#define SetPlayerSpecialAction AC_SetPlayerSpecialAction

// Сажает игрока в транспортное средство.
stock AC_PutPlayerInVehicle(playerid, vehicleid, seatid) return CallRemoteFunction("AC_PutPlayerInVehicle", "ddd", playerid, vehicleid, seatid);
#if defined _ALS_PutPlayerInVehicle
    #undef PutPlayerInVehicle
#else
    #define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle AC_PutPlayerInVehicle

// Выбрасывает игрока из транспорта.
stock AC_RemovePlayerFromVehicle(playerid) return CallRemoteFunction("AC_RemovePlayerFromVehicle", "d", playerid);
#if defined _ALS_RemovePlayerFromVehicle
    #undef RemovePlayerFromVehicle
#else
    #define _ALS_RemovePlayerFromVehicle
#endif
#define RemovePlayerFromVehicle AC_RemovePlayerFromVehicle

// Даёт конкретное оружие и конкретное кол-во патронов игроку.
stock AC_GivePlayerWeapon(playerid, weaponid, ammo) return CallRemoteFunction("AC_GivePlayerWeapon", "ddd", playerid, weaponid, ammo);
#if defined _ALS_GivePlayerWeapon
    #undef GivePlayerWeapon
#else
    #define _ALS_GivePlayerWeapon
#endif
#define GivePlayerWeapon AC_GivePlayerWeapon

// Устанавливает кол-во патронов для указанного оружия.
stock AC_SetPlayerAmmo(playerid, weaponslot, ammo) return CallRemoteFunction("AC_SetPlayerAmmo", "ddd", playerid, weaponslot, ammo);
#if defined _ALS_SetPlayerAmmo
    #undef SetPlayerAmmo
#else
    #define _ALS_SetPlayerAmmo
#endif
#define SetPlayerAmmo AC_SetPlayerAmmo

// Отбирает всё оружие у игрока.
stock AC_ResetPlayerWeapons(playerid) return CallRemoteFunction("AC_ResetPlayerWeapons", "d", playerid);
#if defined _ALS_ResetPlayerWeapons
    #undef ResetPlayerWeapons
#else
    #define _ALS_ResetPlayerWeapons
#endif
#define ResetPlayerWeapons AC_ResetPlayerWeapons

// Забирает определенное оружие у игрока.
stock AC_RemovePlayerWeapon(playerid, weaponid) return CallRemoteFunction("AC_RemovePlayerWeapon", "dd", playerid, weaponid);

// Узнает время сколько игрок находиться не у клавиатуры.
stock AC_GetPlayerAfk(playerid) return CallRemoteFunction("AC_GetPlayerAfk", "d", playerid);

// Проверяет заспавнен игрок или нет.
stock AC_GetPlayerSpawn(playerid) return CallRemoteFunction("AC_GetPlayerSpawn", "d", playerid);

// Эта функция изменяет текущую позицию игрока.
stock AC_SetPlayerPos(playerid, Float:x, Float:y, Float:z) return CallRemoteFunction("AC_SetPlayerPos", "dddd", playerid, x, y, z);
#if defined _ALS_SetPlayerPos
    #undef SetPlayerPos
#else
    #define _ALS_SetPlayerPos
#endif
#define SetPlayerPos AC_SetPlayerPos

// Меняет позицию транспорта.
stock AC_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z) return CallRemoteFunction("AC_SetVehiclePos", "dddd", vehicleid, x, y, z);
#if defined _ALS_SetVehiclePos
    #undef SetVehiclePos
#else
    #define _ALS_SetVehiclePos
#endif
#define SetVehiclePos AC_SetVehiclePos

// Устанавливает параметры машины
stock AC_SetVehicleParamsEx(vehicleid, engines, lightss, alarms, doorss, bonnets, boots, objectives) return CallRemoteFunction("AC_SetVehicleParamsEx", "dddddddd", vehicleid, engines, lightss, alarms, doorss, bonnets, boots, objectives);
#if defined _ALS_SetVehicleParamsEx
    #undef SetVehicleParamsEx
#else
    #define _ALS_SetVehicleParamsEx
#endif
#define SetVehicleParamsEx AC_SetVehicleParamsEx

// Узнает параметры транспортного средства
stock AC_GetVehicleParamsEx(vehicleid, &engines, &lightss, &alarms, &doorss, &bonnets, &boots, &objectives) {
    CallRemoteFunction("AC_GetVehicleParamsEx", "d", vehicleid);
    engines = GetGVarInt("VehicleParamsEx0", vehicleid);
    lightss = GetGVarInt("VehicleParamsEx1", vehicleid);
    alarms = GetGVarInt("VehicleParamsEx2", vehicleid);
    doorss = GetGVarInt("VehicleParamsEx3", vehicleid);
    bonnets = GetGVarInt("VehicleParamsEx4", vehicleid);
    boots = GetGVarInt("VehicleParamsEx5", vehicleid);
    objectives = GetGVarInt("VehicleParamsEx6", vehicleid);
}
#if defined _ALS_GetVehicleParamsEx
    #undef GetVehicleParamsEx
#else
    #define _ALS_GetVehicleParamsEx
#endif
#define GetVehicleParamsEx AC_GetVehicleParamsEx

// Узнает состояние определенного параметра у автомобиля.
stock AC_GetVehicleParams(vehicleid, params) return CallRemoteFunction("AC_GetVehicleParams","dd", vehicleid, params);

// Изменяет состояние определенного параметра автомобилю.
stock AC_SetVehicleParams(vehicleid, params, status) return CallRemoteFunction("AC_SetVehicleParams", "ddd", vehicleid, params, status);

// Переключить состояние определенного параметра автомобилю.
stock AC_ToggleVehicleParams(vehicleid, params) return CallRemoteFunction("AC_ToggleVehicleParams", "dd", vehicleid, params);

// Меняем поворот транспорта.
stock AC_SetVehicleZAngle(vehicleid, Float:a) return CallRemoteFunction("AC_SetVehicleZAngle", "df", vehicleid, a);
#if defined _ALS_SetVehicleZAngle
    #undef SetVehicleZAngle
#else
    #define _ALS_SetVehicleZAngle
#endif
#define SetVehicleZAngle AC_SetVehicleZAngle

// Создает транспортное средство.
stock AC_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay, addsiren=0) return CallRemoteFunction("AC_CreateVehicle", "dffffdddd", modelid, x, y, z, a, color1, color2, respawn_delay, addsiren);
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle AC_CreateVehicle

// Добавляет статичный транспорт, без указания времени его респавна.
stock AC_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2) return CallRemoteFunction("AC_AddStaticVehicle", "dffffdd", modelid, x, y, z, a, color1, color2);
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle AC_AddStaticVehicle

// Добавляет статичный транспорт, с указанием времени его респавна.
stock AC_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:a, color1, color2, respawn_delay, addsiren=0) return CallRemoteFunction("AC_AddStaticVehicleEx", "dffffddd", modelid, x, y, z, a, color1, color2, respawn_delay, addsiren);
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx AC_AddStaticVehicleEx

// Уничтожает ранее созданный транспорт.
stock AC_DestroyVehicle(vehicleid) return CallRemoteFunction("AC_DestroyVehicle", "d", vehicleid);
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle AC_DestroyVehicle

// Устанавливает транспортное средство обратно на ту позицию, где оно было создано.
stock AC_SetVehicleToRespawn(vehicleid) return CallRemoteFunction("AC_SetVehicleToRespawn", "d", vehicleid);
#if defined _ALS_SetVehicleToRespawn
    #undef SetVehicleToRespawn
#else
    #define _ALS_SetVehicleToRespawn
#endif
#define SetVehicleToRespawn AC_SetVehicleToRespawn

// Устанавливает транспорту интерьер.
stock AC_SetVehicleInterior(vehicleid, interiorid) return CallRemoteFunction("AC_SetVehicleInterior", "dd", vehicleid, interiorid);
#if defined _ALS_SetVehicleInterior
    #undef SetVehicleInterior
#else
    #define _ALS_SetVehicleInterior
#endif
#define SetVehicleInterior AC_SetVehicleInterior

// Узнать интерьер транспорта.
stock AC_GetVehicleInterior(vehicleid) return CallRemoteFunction("AC_GetVehicleInterior", "d", vehicleid);

// Применяет указанную анимацию для игрока.
stock AC_ApplyAnimation(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync=0) return CallRemoteFunction("AC_ApplyAnimation", "dssfdddddd", playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
#if defined _ALS_ApplyAnimation
    #undef ApplyAnimation
#else
    #define _ALS_ApplyAnimation
#endif
#define ApplyAnimation AC_ApplyAnimation

// Узнает уровень жизней игрока.
stock Float:AC_GetPlayerHealth(playerid, &Float:health = 0.0) {
    CallRemoteFunction("AC_GetPlayerHealth", "d", playerid);
	return (health = GetGVarFloat("PlayerHealth", playerid));
}
#if defined _ALS_GetPlayerHealth
    #undef GetPlayerHealth
#else
    #define _ALS_GetPlayerHealth
#endif
#define GetPlayerHealth AC_GetPlayerHealth

// Узнает уровень брони игрока.
stock Float:AC_GetPlayerArmour(playerid, &Float:armour = 0.0) {
    CallRemoteFunction("AC_GetPlayerArmour", "d", playerid);
    return (armour = GetGVarFloat("PlayerArmour", playerid));
}
#if defined _ALS_GetPlayerArmour
    #undef GetPlayerArmour
#else
    #define _ALS_GetPlayerArmour
#endif
#define GetPlayerArmour AC_GetPlayerArmour

// Узнать позицию игрока в игре.
stock AC_GetPlayerPos(playerid, &Float:x, &Float:y, &Float:z) {
	if(GetPlayerState(playerid) == PLAYER_STATE_SPECTATING) {
		GetPlayerPos(playerid, x, y, z);
	} else {
		CallRemoteFunction("AC_GetPlayerPos", "d", playerid);
		x = GetGVarFloat("PlayerPos0", playerid);
		y = GetGVarFloat("PlayerPos1", playerid);
		z = GetGVarFloat("PlayerPos2", playerid);
	}
}
#if defined _ALS_GetPlayerPos
    #undef GetPlayerPos
#else
    #define _ALS_GetPlayerPos
#endif
#define GetPlayerPos AC_GetPlayerPos

// Установить здоровье транспортного средства.
stock AC_SetVehicleHealth(vehicleid, Float:health) return CallRemoteFunction("AC_SetVehicleHealth", "df", vehicleid, health);
#if defined _ALS_SetVehicleHealth
    #undef SetVehicleHealth
#else
    #define _ALS_SetVehicleHealth
#endif
#define SetVehicleHealth AC_SetVehicleHealth

// Ремонт повреждений транспортного средства. (удары, вмятины, царапины, колеса и фактическое здоровье)
stock AC_RepairVehicle(vehicleid) return CallRemoteFunction("AC_RepairVehicle", "d", vehicleid);
#if defined _ALS_RepairVehicle
    #undef RepairVehicle
#else
    #define _ALS_RepairVehicle
#endif
#define RepairVehicle AC_RepairVehicle

// Изменить первичный и вторичный цвет уже созданного транспорта.
stock AC_ChangeVehicleColor(vehicleid, color1, color2) return CallRemoteFunction("AC_ChangeVehicleColor", "ddd", vehicleid, color1, color2);
#if defined _ALS_ChangeVehicleColor
    #undef ChangeVehicleColor
#else
    #define _ALS_ChangeVehicleColor
#endif
#define ChangeVehicleColor AC_ChangeVehicleColor

// Узнать цвет транспорта.
stock AC_GetVehicleColor(vehicleid, &color1, &color2) {
    CallRemoteFunction("AC_GetVehicleColor", "d", vehicleid);
    color1 = GetGVarInt("VehicleColor0", vehicleid);
    color2 = GetGVarInt("VehicleColor1", vehicleid);
}

// Узнать здоровье машины.
stock Float:AC_GetVehicleHealth(vehicleid, &Float:health = 0.0) {
    CallRemoteFunction("AC_GetVehicleHealth", "d", vehicleid);
	return (health = GetGVarFloat("VehicleHealth", vehicleid));
}
#if defined _ALS_GetVehicleHealth
    #undef GetVehicleHealth
#else
    #define _ALS_GetVehicleHealth
#endif
#define GetVehicleHealth AC_GetVehicleHealth

// Узнать позицию транспорта.
stock AC_GetVehiclePos(vehicleid, &Float:x, &Float:y, &Float:z) {
    CallRemoteFunction("AC_GetVehiclePos", "d", vehicleid);
    x = GetGVarFloat("VehiclePos0", vehicleid);
    y = GetGVarFloat("VehiclePos1", vehicleid);
    z = GetGVarFloat("VehiclePos2", vehicleid);
}
#if defined _ALS_GetVehiclePos
    #undef GetVehiclePos
#else
    #define _ALS_GetVehiclePos
#endif
#define GetVehiclePos AC_GetVehiclePos

// Узнать угол поворота транспорта.
stock Float:AC_GetVehicleZAngle(vehicleid, &Float:z_angle = 0.0) {
	CallRemoteFunction("AC_GetVehicleZAngle", "d", vehicleid);
	return (z_angle = GetGVarFloat("VehicleZAngle", vehicleid));
}
#if defined _ALS_GetVehicleZAngle
    #undef GetVehicleZAngle
#else
    #define _ALS_GetVehicleZAngle
#endif
#define GetVehicleZAngle AC_GetVehicleZAngle

// Получает ID оружия и размер боеприпасов в указанном слоте.
stock AC_GetPlayerWeaponData(playerid, slot, &weapons, &ammo) {
	CallRemoteFunction("AC_GetPlayerWeaponData", "dd", playerid, slot);
	weapons = GetGVarInt("PlayerWeaponData0", playerid);
	ammo = GetGVarInt("PlayerWeaponData1", playerid);
}
#if defined _ALS_GetPlayerWeaponData
    #undef GetPlayerWeaponData
#else
    #define _ALS_GetPlayerWeaponData
#endif
#define GetPlayerWeaponData AC_GetPlayerWeaponData

// Устанавливает транспорту компонент.
stock AC_AddVehicleComponent(vehicleid, componentid) return CallRemoteFunction("AC_AddVehicleComponent", "dd", vehicleid, componentid);
#if defined _ALS_AddVehicleComponent
    #undef AddVehicleComponent
#else
    #define _ALS_AddVehicleComponent
#endif
#define AddVehicleComponent AC_AddVehicleComponent

// Удаляет данный компонент с транспортного средства.
stock AC_RemoveVehicleComponent(vehicleid, componentid) return CallRemoteFunction("AC_RemoveVehicleComponent", "dd", vehicleid, componentid);
#if defined _ALS_RemoveVehicleComponent
    #undef RemoveVehicleComponent
#else
    #define _ALS_RemoveVehicleComponent
#endif
#define RemoveVehicleComponent AC_RemoveVehicleComponent

// Получает ID установленного компонента из транспортного средства в определенный слот.
stock AC_GetVehicleComponentInSlot(vehicleid, slot) return CallRemoteFunction("AC_GetVehicleComponentInSlot", "dd", vehicleid, slot);
#if defined _ALS_GetVehicleComponentInSlot
    #undef GetVehicleComponentInSlot
#else
    #define _ALS_GetVehicleComponentInSlot
#endif
#define GetVehicleComponentInSlot AC_GetVehicleComponentInSlot

// Используется для установки повреждения транспорта.
stock AC_SetVehicleDamageStatus(vehicleid, panels, doorss, lightss, tires) return CallRemoteFunction("AC_SetVehicleDamageStatus", "ddddd", vehicleid, panels, doorss, lightss, tires);
#if defined _ALS_UpdateVehicleDamageStatus
    #undef UpdateVehicleDamageStatus
#else
    #define _ALS_UpdateVehicleDamageStatus
#endif
#define UpdateVehicleDamageStatus AC_SetVehicleDamageStatus

// Узнать на сколько поврежден транспорт.
stock AC_GetVehicleDamage(vehicleid, status) return CallRemoteFunction("AC_GetVehicleDamage", "dd", vehicleid, status);

// Установить повреждение для транспорта
stock AC_SetVehicleDamage(vehicleid, status, value) return CallRemoteFunction("AC_SetVehicleDamage", "ddd", vehicleid, status, value);

// Узнать на сколько поврежден транспорт.
stock AC_GetVehicleDamageStatus(vehicleid, &panels, &doorss, &lightss, &tires) {
	CallRemoteFunction("AC_GetVehicleDamageStatus", "d", vehicleid);
	panels = GetGVarInt("VehicleDamageStatus0", vehicleid);
	doorss = GetGVarInt("VehicleDamageStatus1", vehicleid);
	lightss = GetGVarInt("VehicleDamageStatus2", vehicleid);
	tires = GetGVarInt("VehicleDamageStatus3", vehicleid);
}
#if defined _ALS_GetVehicleDamageStatus
    #undef GetVehicleDamageStatus
#else
    #define _ALS_GetVehicleDamageStatus
#endif
#define GetVehicleDamageStatus AC_GetVehicleDamageStatus

// Изменить обнаружение
stock AC_SetPlayerDetection(playerid, index, value) return CallRemoteFunction("AC_SetPlayerDetection", "ddd", playerid, index, value);

// Узнать обнаружение
stock AC_GetPlayerDetection(playerid, index) return CallRemoteFunction("AC_GetPlayerDetection", "dd", playerid, index);

// Узнать заморожен игрок или нет
stock AC_GetPlayerControllable(playerid) return CallRemoteFunction("AC_GetPlayerControllable", "d", playerid);

// Спавнит игрока
stock AC_SpawnPlayer(playerid) return CallRemoteFunction("AC_SpawnPlayer", "d", playerid);
#if defined _ALS_SpawnPlayer
    #undef SpawnPlayer
#else
    #define _ALS_SpawnPlayer
#endif
#define SpawnPlayer AC_SpawnPlayer

// Возвращает ID транспорта на котором стоит игрок
stock AC_GetPlayerSurfingVehicleID(playerid) return CallRemoteFunction("AC_GetPlayerSurfingVehicleID", "d", playerid);
#if defined _ALS_GetPlayerSurfingVehicleID
    #undef GetPlayerSurfingVehicleID
#else
    #define _ALS_GetPlayerSurfingVehicleID
#endif
#define GetPlayerSurfingVehicleID AC_GetPlayerSurfingVehicleID

// Возвращает ID объекта на котором стоит игрок
stock AC_GetPlayerSurfingObjectID(playerid) return CallRemoteFunction("AC_GetPlayerSurfingObjectID", "d", playerid);
#if defined _ALS_GetPlayerSurfingObjectID
    #undef GetPlayerSurfingObjectID
#else
    #define _ALS_GetPlayerSurfingObjectID
#endif
#define GetPlayerSurfingObjectID AC_GetPlayerSurfingObjectID

// Изменить покраску автомобиля
stock AC_ChangeVehiclePaintjob(vehicleid, paintjobid) return CallRemoteFunction("AC_ChangeVehiclePaintjob", "dd", vehicleid, paintjobid);
#if defined _ALS_ChangeVehiclePaintjob
    #undef ChangeVehiclePaintjob
#else
    #define _ALS_ChangeVehiclePaintjob
#endif
#define ChangeVehiclePaintjob AC_ChangeVehiclePaintjob

// Узнать покраску автомобиля
stock AC_GetVehiclePaintjob(vehicleid) return CallRemoteFunction("AC_GetVehiclePaintjob", "d", vehicleid);

// OnPlayerConnect
#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect AC_OnPlayerConnect
#if defined AC_OnPlayerConnect
	forward AC_OnPlayerConnect(playerid);
#endif

// OnPlayerDisconnect
#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect AC_OnPlayerDisconnect
#if defined AC_OnPlayerDisconnect
	forward AC_OnPlayerDisconnect(playerid, reason);
#endif

// OnPlayerSpawn
#if defined _ALS_OnPlayerSpawn
	#undef OnPlayerSpawn
#else
	#define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn AC_OnPlayerSpawn
#if defined AC_OnPlayerSpawn
    forward AC_OnPlayerSpawn(playerid);
#endif

// OnPlayerDeath
#if defined _ALS_OnPlayerDeath
	#undef OnPlayerDeath
#else
	#define _ALS_OnPlayerDeath
#endif
#define OnPlayerDeath AC_OnPlayerDeath
#if defined AC_OnPlayerDeath
    forward AC_OnPlayerDeath(playerid, killerid, reason);
#endif

forward AC_OnPlayerHealth(playerid, Float:health, Float:c_health);
forward AC_OnPlayerArmour(playerid, Float:armour, Float:c_armour);
forward AC_OnPlayerWeapon(playerid, weaponid, ammo);
forward AC_OnPlayerMoney(playerid, money, c_money);
forward AC_OnPlayerSpeed(playerid, playerstate, Float:speed);
forward AC_OnPlayerWarpCar(playerid, vehicleid, seat);
forward AC_OnPlayerInvisibility(playerid, type);
forward AC_OnPlayerInterior(playerid, interior, c_interior);
forward AC_OnPlayerAction(playerid, actionid);
forward AC_OnPlayerTeleport(playerid, playerstate, Float:distance);
forward AC_OnPlayerFreeze(playerid);
forward AC_OnPlayerFakeKill(playerid);
forward AC_OnPlayerFly(playerid);
forward AC_OnPlayerShooting(playerid, weaponid);
forward AC_OnPlayerEngine(playerid, vehicleid, Float:speed);
forward AC_OnPlayerRvanka(playerid, playerstate);
forward AC_OnPlayerFakeShot(playerid, weaponid);
forward AC_OnPlayerAim(playerid, aimid, weaponid);
forward AC_OnPlayerDamager(playerid, targetid, weaponid);
forward AC_OnPlayerAfkGhost(playerid, weaponid);
forward AC_OnPlayerAirBrk(playerid, playerstate);
forward AC_OnVehicleHealth(vehicleid, driverid, Float:health, Float:c_health);
forward AC_OnVehicleTuning(vehicleid, driverid, componentid);
forward AC_OnPlayerDistanceShooting(playerid, weaponid, Float:distance);
forward AC_OnPlayerParkour(playerid);
forward AC_OnPlayerGodMode(playerid, type);
forward AC_OnPlayerWeaponZoom(playerid, weaponid, Float:zoom);
forward AC_OnPlayerFlood(playerid, type);

/*#define PCHECK_TYPE_AIRBRK				(0)									// Air Break 000 | +
#define PCHECK_TYPE_INTERIOR     			(1)									// Интерьер	016 | +
#define PCHECK_TYPE_MONEY        			(2)									// Деньги	017 | +
#define PCHECK_TYPE_HEALTH       			(3)									// Жизни	018 | +
#define PCHECK_TYPE_ARMOUR       			(4)									// Броня	019 | +
#define PCHECK_TYPE_WEAPON       			(5)									// Оружия	020 | нету функции по 3 кику
#define PCHECK_TYPE_TELEPORT     			(6)									// Телепорт 001 | +
#define PCHECK_TYPE_FLY          			(7)									// Fly Hack	002 | +
#define PCHECK_TYPE_PULSER       			(8)									// Пульсатор 021 | +
#define PCHECK_TYPE_ACTION           		(9)									// Действия  022 | +
#define PCHECK_TYPE_DGUN					(10)								// Dgun		003 | +
#define PCHECK_TYPE_FREEZE           		(11)								// Заморозка	023 | +
#define PCHECK_TYPE_RAPIDFIRE        		(12)								// Быстрая стрельба	004 | +
#define PCHECK_TYPE_UAMMO					(13)								// Безконечные патроны 005 | +
#define PCHECK_TYPE_SPEED            		(14)								// Спидхак				006 | +
#define PCHECK_TYPE_WARPCAR          		(15)								// Телепорт в автомобиль	007 | +
#define PCHECK_TYPE_ENGINE					(16) 								// Выключен двигатель		008 | +
#define PCHECK_TYPE_RVANKA           		(17)								// Рванка					009 | +
#define PCHECK_TYPE_AIM              		(18)								// Аим						010 | +
#define PCHECK_TYPE_DAMAGER          		(19)								// Демагер					011 | +
#define PCHECK_TYPE_DSHOT                   (20)                                // Дальность стрельбы		012 | +
#define PCHECK_TYPE_GM                      (21)                                // Бессмертие				013 | +
#define PCHECK_TYPE_MOTO                    (22)                                // Анти разгон на мото		024 | нету функции
#define PCHECK_TYPE_BUG                     (23)                                // Провалился под землю		025 | нету функции
#define PCHECK_TYPE_ZOOM                    (24)                                // Zoom weapon				026 | +
#define PCHECK_TYPE_CARSHOT                 (25)                                // CarShot пасажиром		014 | + нету функции
#define PCHECK_TYPE_FAKEKILL                (26)                                // Fakekill					015 | +*/

public AC_OnPlayerHealth(playerid, Float:health, Float:c_health) {
	SetPlayerHealth(playerid, health); // Возвращаем реальное здоровья, лучше не трогать
	OnCheatDetected(playerid, 18);
	return 1;
}

public AC_OnPlayerArmour(playerid, Float:armour, Float:c_armour) {
	SetPlayerArmour(playerid, armour); // Возвращаем реульную броню, лучше не трогать
	OnCheatDetected(playerid, 19);
	return 1;
}

public AC_OnPlayerWeapon(playerid, weaponid, ammo) {
	AC_RemovePlayerWeapon(playerid, weaponid);
	OnCheatDetected(playerid, 3);
    return 1;
}

public AC_OnPlayerMoney(playerid, money, c_money) {
	OnCheatDetected(playerid, 17);
    return 1;
}

public AC_OnPlayerSpeed(playerid, playerstate, Float:speed) {
	OnCheatDetected(playerid, 6);
    return 1;
}

public AC_OnPlayerWarpCar(playerid, vehicleid, seat) {
	RemovePlayerFromVehicle(playerid); // Выкидываем с транспорта, лучше не трогать
	OnCheatDetected(playerid, 7);
    return 1;
}

public AC_OnPlayerInvisibility(playerid, type) {
	OnCheatDetected(playerid, 31);
    return 1;
}

public AC_OnPlayerInterior(playerid, interior, c_interior) {
    SetPlayerInterior(playerid, interior);
	OnCheatDetected(playerid, 16);
    return 1;
}

public AC_OnPlayerAction(playerid, actionid) {
    SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE); // Отключаем специальное действие, лучше не трогать
	OnCheatDetected(playerid, 22);
    return 1;
}

public AC_OnPlayerTeleport(playerid, playerstate, Float:distance) {
	OnCheatDetected(playerid, 1);
    return 1;
}

public AC_OnPlayerFreeze(playerid) {
    TogglePlayerControllable(playerid, 0); // Замораживаем игрока, лучше не трогать
	OnCheatDetected(playerid, 23);
    return 1;
}

public AC_OnPlayerFakeKill(playerid) {
    OnCheatDetected(playerid, 15);
    return 1;
}

public AC_OnPlayerFly(playerid) {
	OnCheatDetected(playerid, 2);
	return 1;
}

public AC_OnPlayerShooting(playerid, weaponid) {
    OnCheatDetected(playerid, 4);
    return 1;
}

public AC_OnPlayerEngine(playerid, vehicleid, Float:speed) {
    OnCheatDetected(playerid, 8);
	return 1;
}

public AC_OnPlayerRvanka(playerid, playerstate) {
    OnCheatDetected(playerid, 9);
	return 1;
}

public AC_OnPlayerFakeShot(playerid, weaponid) {
    OnCheatDetected(playerid, 15);
    return 1;
}

public AC_OnPlayerAim(playerid, aimid, weaponid) {
    OnCheatDetected(playerid, 10);
    return 1;
}

public AC_OnPlayerDamager(playerid, targetid, weaponid) {
    OnCheatDetected(playerid, 11);
    return 1;
}

public AC_OnPlayerAfkGhost(playerid, weaponid) {
    OnCheatDetected(playerid, 30);
    return 1;
}

public AC_OnPlayerAirBrk(playerid, playerstate) {
    OnCheatDetected(playerid, 0);
    return 1;
}

public AC_OnVehicleHealth(vehicleid, driverid, Float:health, Float:c_health) {
	SetVehicleHealth(vehicleid, health); // Возвращаем реальное хп, лучше не трогать
	if(driverid != INVALID_PLAYER_ID) {
		OnCheatDetected(playerid, 29);
	}
    return 1;
}

public AC_OnVehicleTuning(vehicleid, driverid, componentid) {
    RemoveVehicleComponent(vehicleid, componentid); // Удаляем читерский тюнинг, лучше не трогать
    if(driverid != INVALID_PLAYER_ID) {
        OnCheatDetected(playerid, 28);
    }
    return 1;
}

public AC_OnPlayerDistanceShooting(playerid, weaponid, Float:distance) {
    OnCheatDetected(playerid, 12);
	return 1;
}

public AC_OnPlayerParkour(playerid) {
    ClearAnimations(playerid); // Очищаем анимацию, лучше не трогать
	OnCheatDetected(playerid, 27);
    return 1;
}

public AC_OnPlayerGodMode(playerid, type) {
    OnCheatDetected(playerid, 13);
	return 1;
}

public AC_OnPlayerWeaponZoom(playerid, weaponid, Float:zoom) {
    OnCheatDetected(playerid, 26);
    return 1;
}

public AC_OnPlayerFlood(playerid, type) {
	OnCheatDetected(playerid, 21);
	return 1;
}
