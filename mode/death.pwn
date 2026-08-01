#include <a_samp>
#include <a_mysql>
#include "json.inc"
#include "../include/Pawn.CMD.inc"
#include "../include/Pawn.RakNet.inc"
#include "../include/streamer.inc"
#include "../include/sscanf2.inc"
#include <float>

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "user42131"
#define MYSQL_PASS "aV3eW2HxxIlT"
#define MYSQL_DB   "user42131"

// Цвета
#define COLOR_RED    0xE0584BFF
#define COLOR_GREY   0xAAAAAAFF
#define COLOR_WHITE  0xFFFFFFFF
#define ADMIN_COLOR 0x87CEEBFF
#define UNIV_COLOR 0xFF999999

// структура диалогов
enum
{
    DIALOG_UNUSED = 0,
    DIALOG_ADMIN_REG,
    DIALOG_ADMIN_LOGIN,
    DIALOG_MY_CARS,
    DIALOG_CAR_ACTION,
    DIALOG_BUY_CAR_CONFIRM,
    DIALOG_MAP_TP,
	DIALOG_BUYHOUSE,
	DIALOG_ENTER_HOUSE,
	DIALOG_MENU_HOUSE
};

new db_handle;
// slot Тс
#define MAX_PLAYER_VEHICLES 150

// структура транспорта
enum v_info
{
    vID,
    vDBID,
    vModel,
    vColor[2],
    vBodyColor,
    vDiskColor,
    vWheel,
    vPrice,
    Float:vPos[4], // X, Y, Z, Angle
    bool:vSpawned,
    // stage
	vSport,
    vDrift,
    vComfort,
    vSportPlus,
    bool:vSportA,
    bool:vDriftA,
    bool:vComfortA,
    bool:vSportPlusA,
    vNitro,
    vWindFront,
    vWindRear,
    vNeonMain,
    vNeon1,
    vNeon2,
    vLightsColor,
    vStrob,
    bool:vStrobState,
    vVinyl[16],
    vDalniysvet,
    bool:Dalniysvet,
    Float:vClearance,
    Float:vClearanceFront,
    Float:vClearanceRear,
    vWheelModel,
    Float:vOffsetFront,
    Float:vOffsetRear,
    Float:vCamberFront,
    Float:vCamberRear,
    Float:vWheelWidthFront,
    Float:vWheelWidthRear,
    Float:vWheelRadius,
    vHydra,
    vPnevmo
}
new VehicleInfo[MAX_PLAYERS][MAX_PLAYER_VEHICLES][v_info];

// структура игрока
enum p_info
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[65],
    pLevel,
    pSkin,
    pMoney,
    pAdminLvl,
    pAdminPass,
    pAdminPrefix[32],
    bool:pAdminAuth,
    pAdminVeh,
    pMuteTime,
    pJailTime,
    pWarns,
    pBanTime,
    pExp,
    pBanReason[64],
    pBanAdmin[24],
    pSecondsHour,
    pSecondsToday,
    pSecondsYesterday,
    pBC,
    pSimCard,
    pVipType,
    pVipTime,
    pLoginAttempts,
    pCountTodayCases,
    pCountBomjCases,
    pCountStandartCases,
    pCountCarCases,
    pCountOsobiyCases,
    pGiftDelay
}
new Player[MAX_PLAYERS][p_info];

enum E_VEHICLE_PARAMS_STRUCT
{
    V_ENGINE,
    V_LIGHTS,
    V_ALARM,
    V_LOCK,
    V_BONNET,
    V_BOOT,
    V_OBJECTIVE
};
new bool:g_vehicle_params[MAX_VEHICLES][E_VEHICLE_PARAMS_STRUCT];

#define MAX_HOUSES 1000

enum h_info {
    hID,
    hOwnerID,
    hOwnerName[24],
    hType,
    hPrice,
    Float:hEntX,
    Float:hEntY,
    Float:hEntZ,
    Float:hExitX,
    Float:hExitY,
    Float:hExitZ,
    Float:hExitA,
    hPickup,
    Text3D:hLabel,
    bool:hLock
}
new HouseInfo[MAX_HOUSES][h_info];
new TotalHouses = 0;

enum E_H_INT_DATA {
    iName[32],
    Float:iX,
    Float:iY,
    Float:iZ,
    Float:iA,
    iInt
}

new HouseInteriors[7][E_H_INT_DATA] = {
    {"Деревенский", 2491.4910, 1003.5193, 1499.5813, 268.0, 1},
    {"Эконом", 2903.2188, 1498.0972, 2001.0000, 268.0, 1},
    {"Средний", 667.4174, 29.3543, 1024.1985, 268.0, 1},
    {"Средний+", 994.7635, 2021.9585, 1561.0112, 268.0, 1},
    {"Высокий", -2.3367, 483.5531, 1381.0022, 270.0, 1},
    {"Наивысший", 10.3718, 2494.1458, 1540.9941, 0.0, 1},
    {"Премиум", 294.7161, 2139.3115, 1765.4641, 0.0, 1}
};

main()
{
    print(" ");
    print("----------------------------------");
    print("  PWN compile Successfully!     ");
    print("----------------------------------");
    print(" ");
}


/////////////////// ПЕРЕМЕННЫЕ //////////////
new PayDayMinutesCount = 0;
// координаты спавна
new Float:RandomSpawns[][] = {
    {844.8248, 794.6372, 13.3816, 69.8335},
    {1804.63, 2518.68, 14.64, 119.86},
    {2740.7158, -2441.7961, 21.7810, 289.5002},
    {-2430.7253, 204.7393, 26.0951, 171.7708}
};
new Float:MapTPPos[MAX_PLAYERS][3];
new pickup_salon_high;
new pickup_salon_medium;
new pickup_salon_low;
new bool:InStailing[MAX_PLAYERS];

#include "../include/system/autosalon.inc"
#include "../include/system/vehiclenames.inc"
#include "../include/system/cases.inc"
#include "../include/system/acsessory.inc"
#include "../include/system/shinka.inc"
#include "../include/system/stailing.inc"
#include "../include/system/inventory.inc"
#include "../include/system/donate.inc"
#include "../include/system/bussines_clothing.inc"
#include "../include/system/blackpass.inc"
#include "../include/system/admintools.inc"
#include "../gamemodes/ipacket.inc"
#include "../include/system/techcenter.inc"
#define X2_SYSTEM 1
public OnGameModeInit()
{
    db_handle = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
    if(mysql_errno() != 0) print("MySQL: Connection Failed");
    else {
        print("MySQL: Connection Success");
        mysql_tquery(db_handle, "SET NAMES cp1251", "", "");
    }
    
    mysql_tquery(db_handle, "SET CHARACTER SET cp1251", "", "");

    AddPlayerClass(0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 0, 0);
    
    SetTimer("GiftTimer", 1000, true);
    SetTimer("UpdatePunishments", 60000, true);
    SetTimer("DoubleTimeTimer", 600000, true);
   	CreateEditAccessoryTD();
   	mysql_tquery(db_handle, "SELECT * FROM `black_pass` ORDER BY `total_points` DESC LIMIT 15", "LoadBPTop", "");
    mysql_tquery(db_handle, "SELECT * FROM `houses`", "LoadHouses", "");
    // Высокий класс автосалон
    pickup_salon_high = CreateDynamicPickup(19134, 23, 660.6171, 2667.5517, 14.5011, 0, 0);
    // Средний класс
    pickup_salon_medium = CreateDynamicPickup(19134, 23, 1410.6278, 459.6904, 13.2030, 0, 0);
    // Низкий класс
    pickup_salon_low = CreateDynamicPickup(19134, 23, 2477.0832, -718.5198, 12.7074, 0, 0);
    
    // тюнинг центры
	CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -426.2352, 1005.4126, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
	CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -420.0545, 1005.4092, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
	CreateDynamic3DTextLabel("{f6fa05}Технический центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, -413.5492, 1005.5430, 14.8, 50.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
	CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.418945,-2607.487304,21.808467, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.424804,-2613.460937,21.808467, 9.0, _, _, _, -1, -1);
    CreateDynamic3DTextLabel("{f6fa05}Стайлинг центр\n{ffffff}Нажмите: {e81717}'гудок' {ffffff}находясь в машине", -1, 2311.318603,-2619.407470,21.808467, 9.0, _, _, _, -1, -1);
    return 1;
}

public OnGameModeExit()
{
    mysql_close(db_handle);
    return 1;
}

public OnPlayerConnect(playerid)
{
    Player[playerid][pLoginAttempts] = 0;
    Player[playerid][pID] = 0;
    Player[playerid][pLevel] = 0;
    Player[playerid][pMoney] = 0;
    Player[playerid][pCountTodayCases] = 0;
    Player[playerid][pCountBomjCases] = 0;
    Player[playerid][pCountStandartCases] = 0;
    Player[playerid][pCountCarCases] = 0;
    Player[playerid][pCountOsobiyCases] = 0;
    Player[playerid][pAdminLvl] = 0;
    Player[playerid][pAdminAuth] = false;
    Player[playerid][pSkin] = 0;
    format(Player[playerid][pName], MAX_PLAYER_NAME, "");
    GetPlayerName(playerid, Player[playerid][pName], MAX_PLAYER_NAME);
    
    for(new i = 0; i < MAX_INV_SLOTS; i++)
    {
        PlayerInventory[playerid][i][invID] = 0;
        PlayerInventory[playerid][i][invItem] = 0;
        PlayerInventory[playerid][i][invCount] = 0;
        PlayerInventory[playerid][i][invValue] = 0;
    }
    Player[playerid][pAdminVeh] = INVALID_VEHICLE_ID;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `players` WHERE `name` = '%e' LIMIT 1", Player[playerid][pName]);
    mysql_tquery(db_handle, query, "CheckPlayerAccount", "i", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayerAccount(playerid);
    SavePlayerBP(playerid);
    for(new i = 0; i < 10; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i))
            RemovePlayerAttachedObject(playerid, i);
    }
    if(acs_editing[playerid]) StopAccessoryEdit(playerid, true);
    for(new i = 0; i < MAX_INV_SLOTS; i++) {
    PlayerInventory[playerid][i][invID] = 0;
    PlayerInventory[playerid][i][invItem] = 0;
    PlayerInventory[playerid][i][invCount] = 0;
    PlayerInventory[playerid][i][invValue] = 0;
}
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
{
    if(VehicleInfo[playerid][i][vSpawned])
    {
        DestroyVehicle(VehicleInfo[playerid][i][vID]);
        VehicleInfo[playerid][i][vSpawned] = false;
    }
}
    if(Player[playerid][pAdminVeh] != INVALID_VEHICLE_ID) DestroyVehicle(Player[playerid][pAdminVeh]);

    return 1;
}

public OnPlayerSpawn(playerid)
{
#if X2_SYSTEM
    SetPlayerX2(playerid, true, 0);
#endif
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, 0);

    SetCameraBehindPlayer(playerid);
    TogglePlayerSpectating(playerid, false);
    FreezePlayer(playerid, false);
    TogglePlayerControllable(playerid, true);
	SendClientMessage(playerid, -1, "{66CC66}| {ffffff}Добро пожаловать на {E0584B}BAZE RUSSIA!");
    SetPlayerScore(playerid, Player[playerid][pLevel]);
    SetPlayerSkin(playerid, Player[playerid][pSkin]);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);
    LoadAndAttachAccessories(playerid);

    if(Player[playerid][pAdminLvl] > 0 && !Player[playerid][pAdminAuth]) ShowAdminLogin(playerid);
    return 1;
}

stock ShowAdminLogin(playerid)
{
    if(Player[playerid][pAdminPass] == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_REG, DIALOG_STYLE_INPUT,
            "{E0584B}BAZE RUSSIA | Регистрация",
            "{FFFFFF}Вы были назначены администратором проекта.\n"\
            "Придумайте секретный пароль, состоящий из {E0584B}4-х цифр{FFFFFF}, и введите его ниже:",
            "Далее", "Отмена");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_LOGIN, DIALOG_STYLE_PASSWORD,
            "{E0584B}BAZE RUSSIA | Авторизация",
            "{FFFFFF}Введите Ваш административный пароль, указанный при регистрации.\n"\
            "Пароль должен состоять из {E0584B}4-х цифр{FFFFFF}:",
            "Далее", "Отмена");
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_BUYHOUSE) {
        if(!response) return 1;
        new id = GetPVarInt(playerid, "BuyHouseID");
        for(new h = 0; h < TotalHouses; h++)
    {
        if(HouseInfo[h][hOwnerID] == Player[playerid][pID])
        {
            return ShowNotification(playerid, 0, 5, 0, 0, "У Вас уже имеется личный дом!", "");
        }
    }
        if(Player[playerid][pMoney] < HouseInfo[id][hPrice]) return ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно денег!", "");

        GivePlayerMoneyEx(playerid, -HouseInfo[id][hPrice]);
        HouseInfo[id][hOwnerID] = Player[playerid][pID];
        format(HouseInfo[id][hOwnerName], 24, "%s", Player[playerid][pName]);

        new query[128];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `houses` SET owner_id=%d, owner_name='%e' WHERE id=%d", HouseInfo[id][hOwnerID], HouseInfo[id][hOwnerName], HouseInfo[id][hID]);
        mysql_tquery(db_handle, query, "", "");

        UpdateHouseStatus(id);
        return 1;
    }

	if(dialogid == DIALOG_ENTER_HOUSE) {
        if(!response) return 1;
        new i = GetPVarInt(playerid, "InHouseID");

        if(HouseInfo[i][hLock] && HouseInfo[i][hOwnerID] != Player[playerid][pID])
            return GameTextForPlayer(playerid, "~r~Locked", 2000, 1);

        new t = HouseInfo[i][hType];
        SetPlayerPos(playerid, HouseInteriors[t][iX], HouseInteriors[t][iY], HouseInteriors[t][iZ]);
        SetPlayerFacingAngle(playerid, HouseInteriors[t][iA]);
        SetPlayerInterior(playerid, HouseInteriors[t][iInt]);
        SetPlayerVirtualWorld(playerid, HouseInfo[i][hID] + 500);
        return 1;
    }

	if(dialogid == DIALOG_MENU_HOUSE) {
        if(!response) return 1;
        new i = GetPVarInt(playerid, "ManageHouseID");
        if(listitem == 0) {
            HouseInfo[i][hLock] = !HouseInfo[i][hLock];
        }
        if(listitem == 1) {
            SetGPSMarker(playerid, HouseInfo[i][hEntX], HouseInfo[i][hEntY], HouseInfo[i][hEntZ]);
        }
        return 1;
    }
    if(dialogid == DIALOG_MAP_TP)
    {
        if(response)
        {
            if(Player[playerid][pAdminAuth] && Player[playerid][pAdminLvl] >= 1)
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new interior = GetPlayerInterior(playerid);
                new virtualworld = GetPlayerVirtualWorld(playerid);

                if(IsPlayerInAnyVehicle(playerid))
                {
                    SetVehiclePos(vehicleid, MapTPPos[playerid][0], MapTPPos[playerid][1], MapTPPos[playerid][2]);
                    SetVehicleVirtualWorld(vehicleid, virtualworld);
                    LinkVehicleToInterior(vehicleid, interior);
                }
                else
                {
                    SetPlayerPos(playerid, MapTPPos[playerid][0], MapTPPos[playerid][1], MapTPPos[playerid][2]);
                }

                SetPlayerInterior(playerid, interior);
                SetPlayerVirtualWorld(playerid, virtualworld);

                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы были телепортированы на отмеченную метку.");
            }
        }
        return 1;
    }
	if(dialogid == DIALOG_BUY_CAR_CONFIRM)
	{
		if(!response) return 1;

		new id = GetPVarInt(playerid, "BuyCarID");
		new slot = -1;

		for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
			if(VehicleInfo[playerid][i][vModel] == 0) { slot = i; break; }
		}

		if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Нет свободных слотов!");

		new car_model, car_price;
		if(p_SalonType[playerid] == 0) {
			car_model = SalonCars[id][sModel];
			car_price = SalonCars[id][sPrice];
		} else if(p_SalonType[playerid] == 1) {
			car_model = MediumSalonCars[id][sModel];
			car_price = MediumSalonCars[id][sPrice];
		} else {
			car_model = LowSalonCars[id][sModel];
			car_price = LowSalonCars[id][sPrice];
		}

		if(Player[playerid][pMoney] < car_price) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Недостаточно денег!");

		GivePlayerMoneyEx(playerid, -car_price);

		VehicleInfo[playerid][slot][vModel] = car_model;
		VehicleInfo[playerid][slot][vPrice] = car_price;
		VehicleInfo[playerid][slot][vColor][0] = p_SalonColor[playerid][0];
		VehicleInfo[playerid][slot][vColor][1] = p_SalonColor[playerid][1];
		VehicleInfo[playerid][slot][vSpawned] = true;
		VehicleInfo[playerid][slot][vNitro] = 0;

		new query[256];
		mysql_format(db_handle, query, sizeof(query),
			"INSERT INTO `ownable_cars` (`owner_id`, `model`, `price`, `color1`, `color2`) VALUES (%d, %d, %d, %d, %d)",
			Player[playerid][pID], car_model, car_price, p_SalonColor[playerid][0], p_SalonColor[playerid][1]);

		mysql_tquery(db_handle, query, "OnCarPurchased", "ii", playerid, slot);

		DeletePVar(playerid, "BuyCarID");
		HideAvtosalon(playerid);
		return 1;
	}
	else if(dialogid == DIALOG_MY_CARS)
{
    if(!response) return 1;

    new page = GetPVarInt(playerid, "CarMenuPage");
    new total_cars = 0;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
        if(VehicleInfo[playerid][i][vModel] != 0) total_cars++;
    }

    new cars_on_page = 0;
    new start_idx = page * 10;

    if(total_cars > start_idx) {
        cars_on_page = total_cars - start_idx;
        if(cars_on_page > 10) cars_on_page = 10;
    }

    if(listitem == cars_on_page)
    {
        if(total_cars > (page + 1) * 10) return ShowPlayerCars(playerid, page + 1);
        else return ShowPlayerCars(playerid, page - 1);
    }
    if(listitem == cars_on_page + 1) 
    {
        return ShowPlayerCars(playerid, page - 1);
    }

    new car_slot = -1, found_idx = 0, current_list_idx = 0;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] == 0) continue;

        if(found_idx >= start_idx && found_idx < start_idx + 10)
        {
            if(listitem == current_list_idx)
            {
                car_slot = i;
                break;
            }
            current_list_idx++;
        }
        found_idx++;
    }

    if(car_slot != -1)
    {
        SetPVarInt(playerid, "SelectedCarSlot", car_slot);
        ShowCarActionMenu(playerid, car_slot);
    }
    return 1;
}
	else if(dialogid == DIALOG_CAR_ACTION)
	{
		if(!response)
		{
			if(VehicleInfo[playerid][GetPVarInt(playerid, "SelectedCarSlot")][vSpawned]) return 1;
			return ShowPlayerCars(playerid, GetPVarInt(playerid, "CarMenuPage"));
		}

		new slot = GetPVarInt(playerid, "SelectedCarSlot");
		switch(listitem)
		{
			case 0:
			{
				if(VehicleInfo[playerid][slot][vID] == INVALID_VEHICLE_ID || !VehicleInfo[playerid][slot][vSpawned])
					return ShowNotification(playerid, 0, 5, 0, 0, "Сначало загрузите машину!", "");

				new Float:x, Float:y, Float:z;
				GetVehiclePos(VehicleInfo[playerid][slot][vID], x, y, z);
				SetGPSMarker(playerid, x, y, z);
			}
			case 1:
			{
				if(VehicleInfo[playerid][slot][vSpawned])
				{
					if(VehicleInfo[playerid][slot][vID] != INVALID_VEHICLE_ID)
					{
						DestroyVehicle(VehicleInfo[playerid][slot][vID]);
						VehicleInfo[playerid][slot][vID] = INVALID_VEHICLE_ID;
					}
                    VehicleInfo[playerid][slot][vSportA] = false;
                    VehicleInfo[playerid][slot][vDriftA] = false;
                    VehicleInfo[playerid][slot][vComfortA] = false;
                    VehicleInfo[playerid][slot][vSportPlusA] = false;
					VehicleInfo[playerid][slot][vSpawned] = false;
                    VehicleInfo[playerid][slot][vStrobState] = false;
					VehicleInfo[playerid][slot][Dalniysvet] = false;
					SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Ваша машина была выгружена.");
				}
				else
				{
					for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
					{
						if(VehicleInfo[playerid][i][vSpawned])
							return ShowNotification(playerid, 0, 5, 0, 0, "У Вас уже загружена машина", "");
					}

					VehicleInfo[playerid][slot][vID] = CreateVehicle(
						VehicleInfo[playerid][slot][vModel],
						VehicleInfo[playerid][slot][vPos][0],
						VehicleInfo[playerid][slot][vPos][1],
						VehicleInfo[playerid][slot][vPos][2],
						VehicleInfo[playerid][slot][vPos][3],
						VehicleInfo[playerid][slot][vColor][0],
						VehicleInfo[playerid][slot][vColor][1],
						-1
					);
					
                    VehicleInfo[playerid][slot][vStrobState] = false;
					VehicleInfo[playerid][slot][Dalniysvet] = false;
					
					SetVehicleParamsInit(VehicleInfo[playerid][slot][vID]);

					if(VehicleInfo[playerid][slot][vWheel] > 0)
						AddVehicleComponent(VehicleInfo[playerid][slot][vID], VehicleInfo[playerid][slot][vWheel]);

					VehicleInfo[playerid][slot][vSpawned] = true;
					SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Ваша машина была загружена.");
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_ADMIN_REG)
	{
		if(!response) return 1;
		if(strlen(inputtext) != 4 || strval(inputtext) < 1000) return ShowAdminLogin(playerid);

		Player[playerid][pAdminPass] = strval(inputtext);
		TogglePlayerControllable(playerid, true);
		SavePlayerAccount(playerid);
		ShowAdminLogin(playerid);
		return 1;
	}
	else if(dialogid == DIALOG_ADMIN_LOGIN)
	{
		if(!response) return 1;
		if(strval(inputtext) != Player[playerid][pAdminPass]) return ShowAdminLogin(playerid);

		Player[playerid][pAdminAuth] = true;
		TogglePlayerControllable(playerid, true);
		new str[128];
		format(str, sizeof(str), "[A] %s %s[%d] авторизовался в админ-панель.", Player[playerid][pAdminPrefix], Player[playerid][pName], playerid);
		SendAdminMessage(COLOR_GREY, str);
		return 1;
	}
	return 0;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    if(GetPVarInt(playerid, "PickupDelay") > gettime()) return 1;

    for(new i = 0; i < TotalHouses; i++)
    {
        if(pickupid == HouseInfo[i][hPickup])
        {
            SetPVarInt(playerid, "PickupDelay", gettime() + 5);

            if(HouseInfo[i][hOwnerID] == 0)
            {
                SetPVarInt(playerid, "BuyHouseID", i);
                new str[512];
                str = "Название\tИнформация\n";
                format(str, sizeof(str), "%s{FFFFFF}Тип:\t{66CC66}%s\n", str, HouseInteriors[HouseInfo[i][hType]][iName]);
                format(str, sizeof(str), "%s{FFFFFF}Номер дома:\t{66CC66}%d\n", str, HouseInfo[i][hID]);
                format(str, sizeof(str), "%s{FFFFFF}Стоимость:\t{66CC66}%d руб\n", str, HouseInfo[i][hPrice]);
                format(str, sizeof(str), "%s{FFFFFF}Ежедневная квартплата:\t{66CC66}%d руб", str, HouseInfo[i][hPrice] / 150);

                ShowPlayerDialog(playerid, DIALOG_BUYHOUSE, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Покупка", str, "Купить", "Отмена");
            }
            else
            {
                SetPVarInt(playerid, "InHouseID", i);
                new str[250];
                format(str, sizeof(str),
                    "{FFFFFF}Вы уверены, что хотите войти в этот дом?\n\n"\
                    "{FFFFFF}Номер дома: {E0584B}%d\n"\
                    "{FFFFFF}Владелец: {E0584B}%s",
                    HouseInfo[i][hID], HouseInfo[i][hOwnerName]
                );

                ShowPlayerDialog(playerid, DIALOG_ENTER_HOUSE, DIALOG_STYLE_MSGBOX,
                    "{E0584B}BAZE RUSSIA {FFFFFF}| Вход в дом",
                    str, "Войти", "Отмена");
            }
            return 1;
        }
    }
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vSpawned])
        {
            SendClientMessage(playerid, COLOR_RED, "[Автосалон] Ошибка: Сначала выгрузите свой транспорт (/car)!");
            return 1;
        }
    }

    if(pickupid == pickup_salon_high)
    {
        p_SalonType[playerid] = 0;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{FFD700}[Автосалон]{FFFFFF} Добро пожаловать в салон Высокого класса!");
    }
    else if(pickupid == pickup_salon_medium)
    {
        p_SalonType[playerid] = 1;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{C0C0C0}[Автосалон]{FFFFFF} Добро пожаловать в салон Среднего класса!");
    }
    else if(pickupid == pickup_salon_low)
    {
        p_SalonType[playerid] = 2;
        OpenAutoSalon(playerid);
        SendClientMessage(playerid, -1, "{CD7F32}[Автосалон]{FFFFFF} Добро пожаловать в салон Низкого класса!");
    }
    return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    Player[playerid][pID] = cache_insert_id();

    Player[playerid][pLevel] = 1;
    Player[playerid][pMoney] = 150000;
    Player[playerid][pCountTodayCases] = 0;
    Player[playerid][pCountBomjCases] = 1;
    Player[playerid][pCountStandartCases] = 0;
    Player[playerid][pCountCarCases] = 0;
    Player[playerid][pCountOsobiyCases] = 0;
    Player[playerid][pAdminLvl] = 0;
    Player[playerid][pAdminPass] = 0;
    format(Player[playerid][pAdminPrefix], 32, "None");

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    printf("[MySQL] Аккаунт %s зарегистирован. ID: %d", Player[playerid][pName], Player[playerid][pID]);
    return 1;
}

forward OnAccountLoad(playerid);
public OnAccountLoad(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    if(rows > 0)
    {
        Player[playerid][pID] = cache_get_field_content_int(0, "id", db_handle);
        Player[playerid][pLevel] = cache_get_field_content_int(0, "level", db_handle);
        Player[playerid][pSkin] = cache_get_field_content_int(0, "skin", db_handle);
        Player[playerid][pMoney] = cache_get_field_content_int(0, "money", db_handle);
        Player[playerid][pBC] = cache_get_field_content_int(0, "bc", db_handle);
        Player[playerid][pCountTodayCases] = cache_get_field_content_int(0, "counttodaycases", db_handle);
        Player[playerid][pCountBomjCases] = cache_get_field_content_int(0, "countbomjcases", db_handle);
        Player[playerid][pCountStandartCases] = cache_get_field_content_int(0, "countstandartcases", db_handle);
        Player[playerid][pCountCarCases] = cache_get_field_content_int(0, "countcarcases", db_handle);
        Player[playerid][pCountOsobiyCases] = cache_get_field_content_int(0, "countosobiycases", db_handle);
        Player[playerid][pSimCard] = cache_get_field_content_int(0, "sim_card", db_handle);
        Player[playerid][pVipType] = cache_get_field_content_int(0, "vip_type", db_handle);
        Player[playerid][pVipTime] = cache_get_field_content_int(0, "vip_time", db_handle);
		SetPVarInt(playerid, "player_dust", cache_get_field_content_int(0, "dust", db_handle));
        Player[playerid][pAdminLvl] = cache_get_field_content_int(0, "admlvl", db_handle);
        Player[playerid][pAdminPass] = cache_get_field_content_int(0, "admpass", db_handle);
        cache_get_field_content(0, "admprefix", Player[playerid][pAdminPrefix], db_handle, 32);
        
        Player[playerid][pGiftDelay] = cache_get_field_content_int(0, "giftdelay", db_handle);

        Player[playerid][pMuteTime] = cache_get_field_content_int(0, "mute_time", db_handle);
        Player[playerid][pJailTime] = cache_get_field_content_int(0, "jail_time", db_handle);
        Player[playerid][pWarns] = cache_get_field_content_int(0, "warns", db_handle);
        Player[playerid][pBanTime] = cache_get_field_content_int(0, "ban_time", db_handle);
        cache_get_field_content(0, "ban_reason", Player[playerid][pBanReason], db_handle, 64);
        cache_get_field_content(0, "ban_admin", Player[playerid][pBanAdmin], db_handle, 24);

        if(Player[playerid][pBanTime] > 0)
        {
            new string[512], days = Player[playerid][pBanTime] / 1440;
            new hours = (Player[playerid][pBanTime] % 1440) / 60;
            new time_str[64];

            if(Player[playerid][pBanTime] >= 100000) format(time_str, sizeof(time_str), "Навсегда");
            else format(time_str, sizeof(time_str), "%d дн. %d час.", days, hours);

            format(string, sizeof(string),
                "{FFFFFF}Ваш аккаунт заблокирован на сервере {E0584B}BAZE RUSSIA{FFFFFF}\n\n"\
                "Причина: {E0584B}%s\n"\
                "Администратор: {FFFFFF}%s\n"\
                "Срок: {FFFFFF}%s\n\n"\
                "Если вы не согласны с наказанием, обратитесь на форум.",
                Player[playerid][pBanReason], Player[playerid][pBanAdmin], time_str);

            ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}BAZE RUSSIA | Блокировка", string, "Понятно", "");
            SetTimerEx("KickPublic", 500, false, "i", playerid);
            return 1;
        }

        new Node:res = JSON_Object();
        JSON_SetInt(res, "c", 1);
        OnPacketIncoming(playerid, 38, res);
        JSON_Cleanup(res);

        new q[128];
        mysql_format(db_handle, q, sizeof(q), "SELECT * FROM `ownable_cars` WHERE `owner_id` = %d", Player[playerid][pID]);
        mysql_tquery(db_handle, q, "LoadPlayerVehicles", "i", playerid);

        new inv_query[128];
        mysql_format(db_handle, inv_query, sizeof(inv_query), "SELECT * FROM `inventory` WHERE `uid` = %d", Player[playerid][pID]);
        mysql_tquery(db_handle, inv_query, "LoadPlayerInventory", "i", playerid);

        LoadPlayerBP(playerid);

        TogglePlayerSpectating(playerid, false);
        new rand = random(sizeof(RandomSpawns));
        SetSpawnInfo(playerid, 0, 0, RandomSpawns[rand][0], RandomSpawns[rand][1], RandomSpawns[rand][2], RandomSpawns[rand][3], 0, 0, 0, 0, 0, 0);
        return 1;
    }
    else
    {
        Player[playerid][pLoginAttempts]++;
        if(Player[playerid][pLoginAttempts] >= 3)
        {
            new Node:res = JSON_Object();
        	JSON_SetInt(res, "c", 1);
        	OnPacketIncoming(playerid, 38, res);
       		JSON_Cleanup(res);
            ShowNotification(playerid, 1, 5, 0, 0, "Вы были кикнуты за превышение попыток ввода пароля!", "");
            SetTimerEx("KickPublic", 500, false, "i", playerid);
        }
        else
        {
            new string[128];
            format(string, sizeof(string), "Неверный пароль! Попыток осталось: %d", 3 - Player[playerid][pLoginAttempts]);
            ShowNotification(playerid, 0, 5, 0, 0, string, "");
        }
    }
    return 1;
}

forward GiftTimer();
public GiftTimer()
{
    for(new i = GetPlayerPoolSize(); i >= 0; i--)
    {
        if(!IsPlayerConnected(i) || Player[i][pID] == 0) continue;

        if(Player[i][pGiftDelay] > 0)
        {
            Player[i][pGiftDelay] --;
        }
    }
    return 1;
}

/*public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if (damagedid == INVALID_PLAYER_ID) return 1;

    new Float:hp, Float:arm, Float:damage = 20.0;
    GetPlayerHealth(damagedid, hp);
    GetPlayerArmour(damagedid, arm);

    if (arm > 0.0)
    {
        new Float:armLoss = floatmin(arm, damage);
        arm -= armLoss;
        damage -= armLoss;
        SetPlayerArmour(damagedid, arm);
    }

    if (damage > 0.0)
    {
        hp = floatmax(0.0, hp - damage);
        SetPlayerHealth(damagedid, hp);
    }
    return 1;
}

*/
stock SavePlayerAccount(playerid)
{
    if(Player[playerid][pID] == 0) return 0;

    new query[1024];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET \
        `level`=%d, `exp`=%d, `skin`=%d, `money`=%d, `bc`=%d, `sim_card`=%d, \
        `admlvl`=%d, `admpass`=%d, `admprefix`='%e', \
        `mute_time`=%d, `jail_time`=%d, `warns`=%d, \
        `ban_time`=%d, `ban_reason`='%e', `ban_admin`='%e', \
        `vip_type`=%d, `vip_time`=%d, `dust`=%d \
        WHERE `id`=%d",
        Player[playerid][pLevel], Player[playerid][pExp], Player[playerid][pSkin],
        Player[playerid][pMoney], Player[playerid][pBC], Player[playerid][pSimCard],
        Player[playerid][pAdminLvl], Player[playerid][pAdminPass], Player[playerid][pAdminPrefix],
        Player[playerid][pMuteTime], Player[playerid][pJailTime], Player[playerid][pWarns],
        Player[playerid][pBanTime], Player[playerid][pBanReason], Player[playerid][pBanAdmin],
        Player[playerid][pVipType], Player[playerid][pVipTime], GetPVarInt(playerid, "player_dust"),
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, query, "", "");

    new case_query[400];
    mysql_format(db_handle, case_query, sizeof(case_query),
        "UPDATE `players` SET `counttodaycases`=%d, `countbomjcases`=%d, `countstandartcases`=%d, \
        `countcarcases`=%d, `countosobiycases`=%d, `giftdelay`=%d WHERE `id`=%d",
        Player[playerid][pCountTodayCases],
        Player[playerid][pCountBomjCases],
        Player[playerid][pCountStandartCases],
        Player[playerid][pCountCarCases],
        Player[playerid][pCountOsobiyCases],
        Player[playerid][pGiftDelay],
        Player[playerid][pID]
    );
    mysql_tquery(db_handle, case_query, "", "");
    return 1;
}

stock LoadAndAttachAccessories(playerid)
{
    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `player_accessories` WHERE `uid` = %d", Player[playerid][pID]);
    mysql_tquery(db_handle, query, "OnAccessoriesLoaded", "i", playerid);
}

forward OnAccessoriesLoaded(playerid);
forward LoadPlayerVehicles(playerid);
public OnAccessoriesLoaded(playerid)
{
    new rows = cache_num_rows();
    for(new i = 0; i < rows && i < 10; i++)
    {
        new modelid = cache_get_field_content_int(i, "modelid");
        new bone = cache_get_field_content_int(i, "bone");
        new Float:px = cache_get_field_content_float(i, "pos_x");
        new Float:py = cache_get_field_content_float(i, "pos_y");
        new Float:pz = cache_get_field_content_float(i, "pos_z");
        new Float:rx = cache_get_field_content_float(i, "rot_x");
        new Float:ry = cache_get_field_content_float(i, "rot_y");
        new Float:rz = cache_get_field_content_float(i, "rot_z");
        new Float:sc = cache_get_field_content_float(i, "scale");

        SetPlayerAttachedObject(playerid, i, modelid, bone, px, py, pz, rx, ry, rz, sc, sc, sc);
    }
}

public LoadPlayerVehicles(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    
   	printf("[DEBUG] Машин найдено: %d", rows);

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        VehicleInfo[playerid][i][vModel] = 0;
        VehicleInfo[playerid][i][vID] = INVALID_VEHICLE_ID;
        VehicleInfo[playerid][i][vSpawned] = false;
        VehicleInfo[playerid][i][vVinyl][0] = '\0';
        VehicleInfo[playerid][i][vStrob] = 5;
    }

    for(new i = 0; i < rows && i < MAX_PLAYER_VEHICLES; i++)
    {
        VehicleInfo[playerid][i][vDBID] = cache_get_field_content_int(i, "id", db_handle);
        VehicleInfo[playerid][i][vModel] = cache_get_field_content_int(i, "model", db_handle);
        VehicleInfo[playerid][i][vColor][0] = cache_get_field_content_int(i, "color1", db_handle);
        VehicleInfo[playerid][i][vColor][1] = cache_get_field_content_int(i, "color2", db_handle);
        VehicleInfo[playerid][i][vBodyColor] = cache_get_field_content_int(i, "body_color", db_handle);
        VehicleInfo[playerid][i][vDiskColor] = cache_get_field_content_int(i, "disk_color", db_handle);
        VehicleInfo[playerid][i][vWheel] = cache_get_field_content_int(i, "wheel", db_handle);
        VehicleInfo[playerid][i][vWindFront] = cache_get_field_content_int(i, "pered_windcolor", db_handle);
        VehicleInfo[playerid][i][vWindRear] = cache_get_field_content_int(i, "zadni_windcolor", db_handle);
        VehicleInfo[playerid][i][vNeonMain] = cache_get_field_content_int(i, "neon_main", db_handle);
        VehicleInfo[playerid][i][vNeon1] = cache_get_field_content_int(i, "neon1", db_handle);
        VehicleInfo[playerid][i][vNeon2] = cache_get_field_content_int(i, "neon2", db_handle);
        VehicleInfo[playerid][i][vLightsColor] = cache_get_field_content_int(i, "lights_color", db_handle);
        VehicleInfo[playerid][i][vStrob] = cache_get_field_content_int(i, "strob", db_handle);
        if(VehicleInfo[playerid][i][vStrob] == 0) VehicleInfo[playerid][i][vStrob] = 5;

        cache_get_field_content(i, "vinyl", VehicleInfo[playerid][i][vVinyl], db_handle, 32);
        VehicleInfo[playerid][i][vSport] = cache_get_field_content_int(i, "sport", db_handle);
        VehicleInfo[playerid][i][vDrift] = cache_get_field_content_int(i, "drift", db_handle);
        VehicleInfo[playerid][i][vComfort] = cache_get_field_content_int(i, "comfort", db_handle);
        VehicleInfo[playerid][i][vSportPlus] = cache_get_field_content_int(i, "sport_plus", db_handle);
        VehicleInfo[playerid][i][vNitro] = cache_get_field_content_int(i, "nitro", db_handle);
        VehicleInfo[playerid][i][vPos][0] = cache_get_field_content_float(i, "x", db_handle);
        VehicleInfo[playerid][i][vPos][1] = cache_get_field_content_float(i, "y", db_handle);
        VehicleInfo[playerid][i][vPos][2] = cache_get_field_content_float(i, "z", db_handle);
        VehicleInfo[playerid][i][vPos][3] = cache_get_field_content_float(i, "a", db_handle);
        VehicleInfo[playerid][i][vDalniysvet] = cache_get_field_content_int(i, "dalniysvet", db_handle);
        VehicleInfo[playerid][i][vClearance] = cache_get_field_content_float(i, "clearance", db_handle);
        VehicleInfo[playerid][i][vClearanceFront] = cache_get_field_content_float(i, "clearance_front", db_handle);
        VehicleInfo[playerid][i][vClearanceRear] = cache_get_field_content_float(i, "clearance_rear", db_handle);
        VehicleInfo[playerid][i][vWheelModel] = cache_get_field_content_int(i, "wheel_model_id", db_handle);
        VehicleInfo[playerid][i][vOffsetFront] = cache_get_field_content_float(i, "offset_front", db_handle);
        VehicleInfo[playerid][i][vOffsetRear] = cache_get_field_content_float(i, "offset_rear", db_handle);
        VehicleInfo[playerid][i][vCamberFront] = cache_get_field_content_float(i, "camber_front", db_handle);
        VehicleInfo[playerid][i][vCamberRear] = cache_get_field_content_float(i, "camber_rear", db_handle);
        VehicleInfo[playerid][i][vWheelWidthFront] = cache_get_field_content_float(i, "wheel_width_front", db_handle);
        VehicleInfo[playerid][i][vWheelWidthRear] = cache_get_field_content_float(i, "wheel_width_rear", db_handle);
        VehicleInfo[playerid][i][vWheelRadius] = cache_get_field_content_float(i, "wheel_radius", db_handle);
        VehicleInfo[playerid][i][vHydra] = cache_get_field_content_int(i, "hydra", db_handle);
        VehicleInfo[playerid][i][vPnevmo] = cache_get_field_content_int(i, "pnevmo", db_handle);

        VehicleInfo[playerid][i][vID] = INVALID_VEHICLE_ID;
        VehicleInfo[playerid][i][vSpawned] = false;
    }

    if(Player[playerid][pJailTime] > 0) JailSystem(playerid);

    new Node:res = JSON_Object();
    JSON_SetInt(res, "c", 1);
    OnPacketIncoming(playerid, 38, res);
    JSON_Cleanup(res);

    return 1;
}

forward DoubleTimeTimer();
public DoubleTimeTimer()
{
    PayDayMinutesCount++;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;

        Player[i][pSecondsHour] += 600;

        if(PayDayMinutesCount >= 6) // Прошел час
        {
            if(Player[i][pSecondsHour] >= 900)
            {
                new exp_amount = 1;
                new bc_amount = 0;

                if(Player[i][pVipTime] > 0)
                {
                    Player[i][pVipTime] -= 60;
                    if(Player[i][pVipTime] < 0) Player[i][pVipTime] = 0;

                    switch(Player[i][pVipType])
                    {
                        case 1: { bc_amount = 200; exp_amount = 1; } // Silver
                        case 2: { bc_amount = 500; exp_amount = 2; } // Gold (x2)
                        case 3: { bc_amount = 800; exp_amount = 3; } // Premium (x3)
                    }
                }

                // Выдача
                Player[i][pExp] += exp_amount;
                Player[i][pLevel] = (Player[i][pExp] / 4) + 1;
                SetPlayerScore(i, Player[i][pLevel]);

                if(bc_amount > 0) GivePlayerBlackCoin(i, bc_amount);

                SendClientMessage(i, 0xFFFF00FF, "--------- PAYDAY ---------");
                if(Player[i][pVipTime] == 0 && Player[i][pVipType] > 0)
                {
                    Player[i][pVipType] = 0;
                    SendClientMessage(i, COLOR_RED, "Срок действия вашего VIP статуса истек!");
                }
            }
            Player[i][pSecondsHour] = 0;
        }
    }
    if(PayDayMinutesCount >= 6) PayDayMinutesCount = 0;
    return 1;
}

new Float:SalonSpawnCoordsLow[][] = {
    {2491.3955, -760.3754, 11.3192, 359.3163},
    {2491.6113, -741.9573, 11.3309, 359.3163},
    {2498.1772, -760.7000, 11.3195, 359.3163},
    {2498.1313, -742.0123, 11.3729, 359.3163},
    {2505.1767, -760.3374, 11.3196, 359.3163},
    {2505.3037, -742.1876, 11.3587, 359.3163},
    {2515.1606, -760.1191, 11.3196, 359.3163},
    {2515.1691, -742.4080, 11.3610, 359.3163}
};

new Float:SalonSpawnCoordsHigh[][] = {
    {670.1483, 2642.4289, 12.6087, 120.5313},
    {666.0426, 2635.0915, 12.6087, 120.5313},
    {661.5058, 2628.1518, 12.6087, 120.5313},
    {655.0651, 2616.9050, 12.6087, 120.5313},
    {591.9766, 2680.5249, 12.6087, 120.5313},
    {582.9478, 2665.9633, 12.6087, 120.5313},
    {565.5269, 2635.7612, 12.6087, 120.5313}
};

new Float:SalonSpawnCoordsMedium[][] = {
    {1375.0767, 435.0506, 12.6733, 50.5162},
    {1391.7937, 425.2384, 12.6749, 50.5162},
    {1403.1876, 435.3938, 12.6725, 50.5162},
    {1386.5764, 444.5348, 12.6747, 50.5162},
    {1372.5307, 453.2572, 12.6748, 50.5162},
    {1364.8300, 493.3633, 12.6745, 50.5162},
    {1370.7468, 505.6065, 12.6734, 50.5162}
};

forward OnCarPurchased(playerid, slot);
public OnCarPurchased(playerid, slot)
{
    VehicleInfo[playerid][slot][vDBID] = cache_insert_id();
    new r;

    if(p_SalonType[playerid] == 0)
    {
        r = random(sizeof(SalonSpawnCoordsHigh));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsHigh[r][i];
    }
    else if(p_SalonType[playerid] == 1)
    {
        r = random(sizeof(SalonSpawnCoordsMedium));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsMedium[r][i];
    }
    else
    {
        r = random(sizeof(SalonSpawnCoordsLow));
        for(new i=0; i<4; i++) VehicleInfo[playerid][slot][vPos][i] = SalonSpawnCoordsLow[r][i];
    }

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `id`='%d'",
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vDBID]);
    mysql_tquery(db_handle, query);

    VehicleInfo[playerid][slot][vID] = CreateVehicle(
        VehicleInfo[playerid][slot][vModel],
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vColor][0], VehicleInfo[playerid][slot][vColor][1], -1
    );
    
    if(p_SalonWheelID[playerid] > 0)
    {
        new wheelid = SalonWheels[p_SalonWheelID[playerid]];
        AddVehicleComponent(VehicleInfo[playerid][slot][vID], wheelid);
        VehicleInfo[playerid][slot][vWheel] = wheelid;

        mysql_format(db_handle, query, sizeof(query), "UPDATE `ownable_cars` SET `wheel`='%d' WHERE `id`='%d'", wheelid, VehicleInfo[playerid][slot][vDBID]);
        mysql_tquery(db_handle, query);
    }

    VehicleInfo[playerid][slot][vSpawned] = true;
    SendClientMessage(playerid, COLOR_WHITE, "Транспорт куплен и доставлен на парковку!");
    
    if(VehicleInfo[playerid][slot][vNitro] > 0)
{
    AddVehicleComponent(VehicleInfo[playerid][slot][vID], 1007 + VehicleInfo[playerid][slot][vNitro]);
}
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(!acs_editing[playerid]) return 0;

    if(clickedid == acss_TD[1] || clickedid == acss_TD[2])
    {
        StopAccessoryEdit(playerid, true);
        return 1;
    }

    if(acss_TD[3] <= clickedid <= acss_TD[9])
    {
        new TD = -1;
        for(new i = 3; i < 10; i++) if(clickedid == acss_TD[i]) { TD = i; break; }

        new td_use = GetPVarInt(playerid, "acss_TD_use");
        new count_TD = TD - 3;

        TextDrawHideForPlayer(playerid, acss_TD[10 + (td_use-1)]);
        TextDrawShowForPlayer(playerid, acss_TD[3 + (td_use-1)]);
        TextDrawHideForPlayer(playerid, acss_TD[17 + (td_use-1)]);

        TextDrawHideForPlayer(playerid, acss_TD[3 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_TD[10 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_TD[17 + count_TD]);

        SetPVarInt(playerid, "acss_TD_use", count_TD + 1);

        new Float:v;
        switch(count_TD + 1)
        {
            case 1: v = GetPVarFloat(playerid, "edit_y"); // Поменял местами под твой UI
            case 2: v = GetPVarFloat(playerid, "edit_z");
            case 3: v = GetPVarFloat(playerid, "edit_x");
            case 4: v = GetPVarFloat(playerid, "edit_scale");
            case 5: v = GetPVarFloat(playerid, "edit_rX");
            case 6: v = GetPVarFloat(playerid, "edit_rY");
            case 7: v = GetPVarFloat(playerid, "edit_rZ");
        }
        new s[32];
        format(s, sizeof s, "%.6f", v);
        PlayerTextDrawSetString(playerid, acss_coords_PTD[playerid], s);
        return 1;
    }

    if(clickedid == acss_TD[24] || clickedid == acss_TD[25])
    {
        new Float:val = (clickedid == acss_TD[24]) ? (1.0) : (-1.0);
        new s[32], type = GetPVarInt(playerid, "acss_TD_use");

        switch(type)
        {
            case 1: // UI Влево/Вправо -> на самом деле двигает Вверх/Вниз (Y)
            {
                SetPVarFloat(playerid, "edit_z", GetPVarFloat(playerid, "edit_z") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_z"));
            }
            case 2: // UI Вверх/Вниз -> на самом деле двигает От себя/На себя (Z)
            {
                SetPVarFloat(playerid, "edit_x", GetPVarFloat(playerid, "edit_x") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_x"));
            }
            case 3: // UI От себя/На себя -> на самом деле двигает Влево/Вправо (X)
            {
                SetPVarFloat(playerid, "edit_y", GetPVarFloat(playerid, "edit_y") + (val * 0.005));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_y"));
            }
            case 4:
            {
                SetPVarFloat(playerid, "edit_scale", GetPVarFloat(playerid, "edit_scale") + (val * 0.02));
                format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_scale"));
            }
            case 5: { SetPVarFloat(playerid, "edit_rX", GetPVarFloat(playerid, "edit_rX") + (val * 2.0)); format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_rX")); }
            case 6: { SetPVarFloat(playerid, "edit_rY", GetPVarFloat(playerid, "edit_rY") + (val * 2.0)); format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_rY")); }
            case 7: { SetPVarFloat(playerid, "edit_rZ", GetPVarFloat(playerid, "edit_rZ") + (val * 2.0)); format(s, sizeof s, "%.6f", GetPVarFloat(playerid, "edit_rZ")); }
        }

        PlayerTextDrawSetString(playerid, acss_coords_PTD[playerid], s);
        SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "slot"), GetPVarInt(playerid, "acs_model"), GetPVarInt(playerid, "bone"),
            GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"),
            GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"));
        return 1;
    }
    return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == avtsln_PTD[playerid][0])
    {
        new id = p_SalonCarID[playerid], car_price, car_name[32];
        if(p_SalonType[playerid] == 0) { car_price = SalonCars[id][sPrice]; strmid(car_name, SalonCars[id][sName], 0, strlen(SalonCars[id][sName]), 32); }
        else if(p_SalonType[playerid] == 1) { car_price = MediumSalonCars[id][sPrice]; strmid(car_name, MediumSalonCars[id][sName], 0, strlen(MediumSalonCars[id][sName]), 32); }
        else { car_price = LowSalonCars[id][sPrice]; strmid(car_name, LowSalonCars[id][sName], 0, strlen(LowSalonCars[id][sName]), 32); }

        if(Player[playerid][pMoney] < car_price) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] У вас недостаточно денег!");

        new slot = -1;
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) if(VehicleInfo[playerid][i][vModel] == 0) { slot = i; break; }
        if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] У вас нет свободных слотов!");

        new string[256];
        format(string, sizeof(string), "{FFFFFF}Параметр\t{FFFFFF}Значение\n{FFFFFF}Модель\t{FF4A4A}%s\n{FFFFFF}Цена\t{00FF00}%d RUB\n{FFFFFF}Цвет 1\t{66CC66}%d\n{FFFFFF}Цвет 2\t{66CC66}%d", car_name, car_price, p_SalonColor[playerid][0], p_SalonColor[playerid][1]);
        SetPVarInt(playerid, "BuyCarID", id);
        ShowPlayerDialog(playerid, DIALOG_BUY_CAR_CONFIRM, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Автосалон", string, "Купить", "Отмена");
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][1]) return HideAvtosalon(playerid);

    if(playertextid == avtsln_PTD[playerid][3])
    {
        new max_id = (p_SalonType[playerid] == 0) ? sizeof(SalonCars) : (p_SalonType[playerid] == 1) ? sizeof(MediumSalonCars) : sizeof(LowSalonCars);
        p_SalonCarID[playerid] = (p_SalonCarID[playerid] >= max_id - 1) ? 0 : p_SalonCarID[playerid] + 1;
        UpdateSalonVehicle(playerid, true);
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][4])
    {
        new max_id = (p_SalonType[playerid] == 0) ? sizeof(SalonCars) : (p_SalonType[playerid] == 1) ? sizeof(MediumSalonCars) : sizeof(LowSalonCars);
        p_SalonCarID[playerid] = (p_SalonCarID[playerid] <= 0) ? max_id - 1 : p_SalonCarID[playerid] - 1;
        UpdateSalonVehicle(playerid, true);
        return 1;
    }

    if(playertextid == avtsln_PTD[playerid][8]) { p_SalonColor[playerid][0] = (p_SalonColor[playerid][0] >= 126) ? 0 : p_SalonColor[playerid][0] + 1; ChangeVehicleColor(p_BuyCar[playerid], p_SalonColor[playerid][0], p_SalonColor[playerid][1]); return 1; }
    if(playertextid == avtsln_PTD[playerid][10]) { p_SalonColor[playerid][0] = (p_SalonColor[playerid][0] <= 0) ? 126 : p_SalonColor[playerid][0] - 1; ChangeVehicleColor(p_BuyCar[playerid], p_SalonColor[playerid][0], p_SalonColor[playerid][1]); return 1; }
    if(playertextid == avtsln_PTD[playerid][7]) { p_SalonWheelID[playerid] = (p_SalonWheelID[playerid] >= sizeof(SalonWheels)-1) ? 0 : p_SalonWheelID[playerid] + 1; UpdateSalonVehicle(playerid, false); return 1; }
    if(playertextid == avtsln_PTD[playerid][9]) { p_SalonWheelID[playerid] = (p_SalonWheelID[playerid] <= 0) ? sizeof(SalonWheels)-1 : p_SalonWheelID[playerid] - 1; UpdateSalonVehicle(playerid, false); return 1; }

    return 0;
}

stock SendAdminMessage(color, string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && Player[i][pAdminAuth]) SendClientMessage(i, color, string);
    return 1;
}

stock ProxDetector(Float:radi, playerid, string[], color)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid))
            if(IsPlayerInRangeOfPoint(i, radi, x, y, z)) SendClientMessage(i, color, string);
    }
    return 1;
}

forward SetRandomSpawn(playerid);
public SetRandomSpawn(playerid)
{
    new r = random(sizeof(RandomSpawns));
    SetCameraBehindPlayer(playerid);
    SetPlayerPos(playerid, RandomSpawns[r][0], RandomSpawns[r][1], RandomSpawns[r][2]);
    SetPlayerFacingAngle(playerid, RandomSpawns[r][3]);
    return 1;
}

forward CheckPlayerAccount(playerid);
public CheckPlayerAccount(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    new Node:j = JSON_Object();
    JSON_SetInt(j, "o", 1);
    JSON_SetInt(j, "r", (rows > 0) ? 1 : 0);
    OnPacketIncoming(playerid, 38, j);
    JSON_Cleanup(j);
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(Player[playerid][pMuteTime] > 0)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "У Вас имеется мут!", "");

        SetPlayerChatBubble(playerid, "(( MUTED ))", 0xE0584BFF, 10.0, 5000);

        return 0;
    }

    new s[144];
    format(s, sizeof(s), "%s[%d]: %s", Player[playerid][pName], playerid, text);
    ProxDetector(20.0, playerid, s, COLOR_WHITE);

    return 0;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if(result == -1)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "Введенная вами команда не найдена!", "");
        return 0;
    }
    return 1;
}

stock ShowNotification(playerid, type, duration, id, subId, caption[], btnCaption[])
{
    new Node:JSONObject = JSON_Object();

    JSON_SetInt(JSONObject, "o", 1);
    JSON_SetInt(JSONObject, "t", type);
    JSON_SetInt(JSONObject, "d", duration);
    JSON_SetInt(JSONObject, "s", id);
    JSON_SetInt(JSONObject, "b", subId);
    JSON_SetString(JSONObject, "i", caption, strlen(caption));
    JSON_SetString(JSONObject, "k", btnCaption, strlen(btnCaption));

    OnPacketIncoming(playerid, 13, JSONObject);
}

stock GivePlayerMoneyEx(playerid, amount)
{
    Player[playerid][pMoney] += amount;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);

    new fmt_str[64];
    if (amount < 0)
    {
        format(fmt_str, sizeof(fmt_str), "Вы потратили %d рублей.", -amount);
        ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
    }
    else
    {
        format(fmt_str, sizeof(fmt_str), "Вы получили %d рублей.", amount);
        ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
    }

    SavePlayerAccount(playerid);
    return 1;
}



stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    if(IsPlayerConnected(playerid))
    {
        format(name, sizeof(name), "%s", Player[playerid][pName]);
    }
    return name;
}

stock GetPlayerMoneyEx(playerid)
{
    return Player[playerid][pMoney];
}

public OnPlayerEnterCheckpoint(playerid)
{
    DisablePlayerCheckpoint(playerid);
    return 1;
}

public OnPlayerRequestClass(playerid, classid) {  return 1; }

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(Player[playerid][pAdminAuth] && Player[playerid][pAdminLvl] >= 1)
    {
        MapTPPos[playerid][0] = fX;
        MapTPPos[playerid][1] = fY;
        MapTPPos[playerid][2] = fZ;

        ShowPlayerDialog(playerid, DIALOG_MAP_TP, DIALOG_STYLE_MSGBOX,
            "{E0584B}Телепортация",
            "{FFFFFF}Вы действительно хотите телепортироваться в указанную точку?",
            "Да", "Отмена");
    }
    return 1;
}
public OnVehicleStreamIn(vehicleid, forplayerid)
{
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                if(VehicleInfo[i][v][vBodyColor] != 0 || VehicleInfo[i][v][vDiskColor] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x12, PR_UINT32, VehicleInfo[i][v][vBodyColor], PR_UINT32, VehicleInfo[i][v][vDiskColor], PR_UINT32, VehicleInfo[i][v][vDiskColor], PR_UINT32, VehicleInfo[i][v][vDiskColor]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }

                if(VehicleInfo[i][v][vLightsColor] != 0)
                {
                    SetVehicleLightsColorHEX(forplayerid, vehicleid, VehicleInfo[i][v][vLightsColor]);
                }

                if(VehicleInfo[i][v][vWindFront] != 0 || VehicleInfo[i][v][vWindRear] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x00, PR_UINT32, VehicleInfo[i][v][vWindFront], PR_UINT32, VehicleInfo[i][v][vWindRear], PR_UINT32, VehicleInfo[i][v][vWindFront], PR_UINT32, VehicleInfo[i][v][vWindRear]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }

                if(VehicleInfo[i][v][vNeonMain] != 0 || VehicleInfo[i][v][vNeon1] != 0 || VehicleInfo[i][v][vNeon2] != 0)
                {
                    new BitStream:bs = BS_New();
                    BS_WriteValue(bs, PR_UINT16, vehicleid, PR_UINT8, 0x09, PR_UINT32, VehicleInfo[i][v][vNeonMain], PR_UINT32, VehicleInfo[i][v][vNeon1], PR_UINT32, VehicleInfo[i][v][vNeon2]);
                    PR_SendRPC(bs, forplayerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
                    BS_Delete(bs);
                }
                
				if(VehicleInfo[i][v][vVinyl][0] != '\0')
                {
                    SetVehicleVinylForPlayer(forplayerid, vehicleid, VehicleInfo[i][v][vVinyl]);
                }
                
                if(VehicleInfo[i][v][vDalniysvet])
                {
                    SetVehicleDlaniy(forplayerid, vehicleid, VehicleInfo[i][v][Dalniysvet] ? 1 : 0);
                }

                new type_to_send = (VehicleInfo[i][v][vStrobState]) ? VehicleInfo[i][v][vStrob] : 5;
                SetVehicleStroboscopeForPlayer(forplayerid, vehicleid, type_to_send);
                return 1;
            }
        }
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_CROUCH)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, -426.235290, 1005.412658, 12.307508) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, -420.054534, 1005.409240, 12.307003) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, -413.549285, 1005.543029, 12.326748))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            if(!vehicleid) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны находиться в личном транспорте");

            if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
                return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы должны быть за рулем своего личного транспорта");

            callcmd::techcentergui(playerid, "");
            return 1;
        }

        if(IsPlayerInRangeOfPoint(playerid, 5.0, 2311.418945, -2607.487304, 21.808467) ||
           IsPlayerInRangeOfPoint(playerid, 5.0, 2311.424804, -2613.460937, 21.808467))
        {
 			new vehicleid = GetPlayerVehicleID(playerid);
            if(GetPlayerVehicleSlot(playerid, vehicleid) == -1)
            if(!vehicleid) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Доступно только на личном транспорте!");

            callcmd::tungui(playerid, "");
            return 1;
        }
    }
    return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    for(new i = 0; i <= GetPlayerPoolSize(); i++)
    {
        if(IsPlayerConnected(i) && GetPVarInt(i, "IsSpectating") && GetPVarInt(i, "SpectatingID") == playerid)
        {
            if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
            {
                PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
            }
            else if(newstate == PLAYER_STATE_ONFOOT)
            {
                PlayerSpectatePlayer(i, playerid);
            }
        }
    }
    if(oldstate == PLAYER_STATE_DRIVER)
    {
        new old_vehicleid = GetPlayerVehicleID(playerid);
        if(old_vehicleid != INVALID_VEHICLE_ID)
        {
            SetVehicleAcceleration(old_vehicleid, 0.0);
            SetVehicleDriftMode(playerid, old_vehicleid, false);
        }
    }

	if(newstate == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        new slot = GetPlayerVehicleSlot(playerid, vehicleid);
        new owner = playerid;

        if(slot != -1)
        {
            new nitro_type = VehicleInfo[playerid][slot][vNitro];
            if(nitro_type > 0)
            {
                new component_id = 1007 + nitro_type;
                if(!GetVehicleComponentInSlot(vehicleid, CARMODTYPE_NITRO))
                {
                    AddVehicleComponent(vehicleid, component_id);
                }
            }
        }
        else
        {
            for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
            {
                if(!IsPlayerConnected(i)) continue;
                slot = GetPlayerVehicleSlot(i, vehicleid);
                if(slot != -1)
                {
                    owner = i;
                    break;
                }
            }
        }

        if(slot != -1)
        {
            if(VehicleInfo[owner][slot][vComfortA]) SetVehicleAcceleration(vehicleid, 31.8);
            else if(VehicleInfo[owner][slot][vSportA]) SetVehicleAcceleration(vehicleid, 35.0);
            else if(VehicleInfo[owner][slot][vSportPlusA]) SetVehicleAcceleration(vehicleid, 36.0);
            else SetVehicleAcceleration(vehicleid, 0.0);

            SetVehicleDriftMode(playerid, vehicleid, VehicleInfo[owner][slot][vDriftA]);
        }
    }
    return 1;
}

CMD:car(playerid)
{
    new spawned_slot = -1;
    new total_cars = 0;

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] != 0)
        {
            total_cars++;

            if(VehicleInfo[playerid][i][vSpawned])
            {
                spawned_slot = i;
                break;
            }
        }
    }

    if(spawned_slot != -1)
    {
        SetPVarInt(playerid, "SelectedCarSlot", spawned_slot);
        ShowCarActionMenu(playerid, spawned_slot);
    }
    else
    {
        if(total_cars == 0)
        {
            ShowNotification(playerid, 0, 5, 0, 0, "У вас нет личного транспорта!", "");
        }
        else
        {
            DeletePVar(playerid, "CarMenuPage");
            ShowPlayerCars(playerid, 0);
        }
    }
    return 1;
}

stock ShowPlayerCars(playerid, page)
{
    new string[1536], count = 0, total = 0;
    format(string, sizeof(string), "Модель    Состояние    Слот\n");

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[playerid][i][vModel] == 0) continue;

        if(total >= page * 10 && count < 10)
        {
            format(string, sizeof(string), "%s{FFFFFF}%s    %s    {AAAAAA}#%d\n",
                string,
                GetVehicleNameByModel(VehicleInfo[playerid][i][vModel]),
                (VehicleInfo[playerid][i][vSpawned]) ? ("{4682B4}Загружен") : ("{E0584B}Выгружен"),
                i + 1
            );
            count++;
        }
        total++;
    }

    if(total == 0) return SendClientMessage(playerid, COLOR_RED, "У вас нет личного транспорта!");

    if(total > (page + 1) * 10)
        strcat(string, "{FF9900}>>>    Следующая страница     \n");

    if(page > 0)
        strcat(string, "{FF9900}<<<    Предыдущая страница     \n");

    SetPVarInt(playerid, "CarMenuPage", page);
    ShowPlayerDialog(playerid, DIALOG_MY_CARS, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Транспорты", string, "Выбрать", "Отмена");
    return 1;
}

stock ShowCarActionMenu(playerid, car_slot)
{
    new menu_str[256];
    strcat(menu_str, "Функция    Описание\n");
    strcat(menu_str, "Отметить на GPS    Найти транспорт на карте\n");

    if(VehicleInfo[playerid][car_slot][vSpawned] == true)
    {
        strcat(menu_str, "Выгрузить транспорт    Убрать транспорт с сервера");
    }
    else
    {
        strcat(menu_str, "Загрузить на сервере    Заспавнить транспорт");
    }

    ShowPlayerDialog(playerid, DIALOG_CAR_ACTION, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Управление", menu_str, "Далее", "Назад");
    return 1;
}

stock SetGPSMarker(playerid, Float:x, Float:y, Float:z)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;

    new BitStream:bs = BS_New();

    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs,
        PR_UINT8, 26,
        PR_UINT32, 0x00FFFFFF,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z
    );

    if(IsPlayerConnected(playerid))
    {
        PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    }
    SetPlayerCheckpoint(playerid, x, y, z, 4.0);
    ShowNotification(playerid, 3, 5, 0, 1, "GPS отмечено на карте", "");

    BS_Delete(bs);
    return 1;
}

CMD:mycoord(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

    new Float:x, Float:y, Float:z, Float:a;
    new str[144];

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    format(str, sizeof(str), "{FFFF00}| {FFFFFF}Вы находитесь на координатах: X: %.4f | Y: %.4f | Z: %.4f | A: %.4f", x, y, z, a);

    SendClientMessage(playerid, -1, str);

    new log_str[180];
    format(log_str, sizeof(log_str), "[COORD LOG] Админ %s[%d]: %.4f, %.4f, %.4f, %.4f", Player[playerid][pName], playerid, x, y, z, a);
    print(log_str);

    return 1;
}

CMD:park(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_RED, "Вы должны быть в машине!");

    new vehid = GetPlayerVehicleID(playerid);
    new slot = -1;

    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) {
        if(VehicleInfo[playerid][i][vID] == vehid) {
            slot = i;
            break;
        }
    }

    if(slot == -1) return SendClientMessage(playerid, COLOR_RED, "Это не ваш личный транспорт!");

    GetVehiclePos(vehid, VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1], VehicleInfo[playerid][slot][vPos][2]);
    GetVehicleZAngle(vehid, VehicleInfo[playerid][slot][vPos][3]);

    new query[256];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `ownable_cars` SET `x`='%f', `y`='%f', `z`='%f', `a`='%f' WHERE `id`='%d'",
        VehicleInfo[playerid][slot][vPos][0], VehicleInfo[playerid][slot][vPos][1],
        VehicleInfo[playerid][slot][vPos][2], VehicleInfo[playerid][slot][vPos][3],
        VehicleInfo[playerid][slot][vDBID]);
    mysql_tquery(db_handle, query);

    SendClientMessage(playerid, COLOR_WHITE, "Транспорт припаркован!");
    return 1;
}

CMD:radial(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid)) return 1;

    new vehicleid = GetPlayerVehicleID(playerid);
    new owner = -1, slot = -1;
    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
        {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid)
            {
                owner = i;
                slot = v;
                break;
            }
        }
        if(owner != -1) break;
    }

    new Node:radial_json = JSON_Object();
    new Node:Info = JSON_Array();

    JSON_SetInt(radial_json, "o", 1);

    Info = JSON_Append(Info, JSON_Array(JSON_Int(1)));

    if(GetVehicleParam(vehicleid, V_LOCK))   Info = JSON_Append(Info, JSON_Array(JSON_Int(3)));
    if(GetVehicleParam(vehicleid, V_ENGINE)) Info = JSON_Append(Info, JSON_Array(JSON_Int(6)));
    if(GetVehicleParam(vehicleid, V_LIGHTS)) Info = JSON_Append(Info, JSON_Array(JSON_Int(14)));

    if(slot != -1)
    {
        if(VehicleInfo[owner][slot][vDriftA])     Info = JSON_Append(Info, JSON_Array(JSON_Int(8), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vComfortA])   Info = JSON_Append(Info, JSON_Array(JSON_Int(9), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vSportA])     Info = JSON_Append(Info, JSON_Array(JSON_Int(10), JSON_Int(1)));
        if(VehicleInfo[owner][slot][vSportPlusA]) Info = JSON_Append(Info, JSON_Array(JSON_Int(11), JSON_Int(1)));
        
        if(VehicleInfo[owner][slot][vStrob] > 0)
        {
            if(VehicleInfo[owner][slot][vStrobState]) Info = JSON_Append(Info, JSON_Array(JSON_Int(15)));
        }
        
        if(VehicleInfo[owner][slot][vDalniysvet] > 0)
        {
            Info = JSON_Append(Info, JSON_Array(JSON_Int(13)));
        }
    }

    JSON_SetArray(radial_json, "s", Info);

    OnPacketIncoming(playerid, 27, radial_json);

    JSON_Cleanup(radial_json);
    JSON_Cleanup(Info);

    return 1;
}

stock SetVehicleParamsInit(vehicleid)
{
    g_vehicle_params[vehicleid][V_ENGINE]    = true;
    g_vehicle_params[vehicleid][V_LIGHTS]    = false; 
    g_vehicle_params[vehicleid][V_ALARM]     = false;
    g_vehicle_params[vehicleid][V_LOCK]      = false; 
    g_vehicle_params[vehicleid][V_BONNET]    = false;
    g_vehicle_params[vehicleid][V_BOOT]      = false;
    g_vehicle_params[vehicleid][V_OBJECTIVE] = false;

    SetVehicleParamsEx(vehicleid, 1, 0, 0, 0, 0, 0, 0);
    return 1;
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
    return _:g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    g_vehicle_params[vehicleid][paramid] = bool:set_value;

    switch(paramid)
    {
        case V_ENGINE:    engine = set_value;
        case V_LIGHTS:    lights = set_value;
        case V_ALARM:     alarm = set_value;
        case V_LOCK:      doors = set_value;
        case V_BONNET:    bonnet = set_value;
        case V_BOOT:      boot = set_value;
        case V_OBJECTIVE: objective = set_value;
    }

    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return 1;
}

stock IsABike(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
    return (model == 481 || model == 509 || model == 510);
}

alias:e("en")
CMD:e(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
    if(IsABike(vehicleid)) return 1;

    SetVehicleParam(vehicleid, V_ENGINE, !GetVehicleParam(vehicleid, V_ENGINE));
    return 1;
}

CMD:lk(playerid)
{
    new vehicleid = INVALID_VEHICLE_ID;
    if(IsPlayerInAnyVehicle(playerid)) vehicleid = GetPlayerVehicleID(playerid);
    else
    {
        for(new i = 1, j = GetVehiclePoolSize(); i <= j; i++)
        {
            if(!GetVehicleModel(i)) continue;
            new Float:pos[3];
            GetVehiclePos(i, pos[0], pos[1], pos[2]);
            if(IsPlayerInRangeOfPoint(playerid, 4.0, pos[0], pos[1], pos[2])) { vehicleid = i; break; }
        }
    }

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "Поблизости нет транспорта!", "");
        return 1;
    }

    new bool:canAccess = false;
    if(Player[playerid][pAdminVeh] == vehicleid) canAccess = true;

    if(!canAccess)
    {
        for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
        {
            if(VehicleInfo[playerid][i][vSpawned] && VehicleInfo[playerid][i][vID] == vehicleid)
            {
                canAccess = true;
                break;
            }
        }
    }

    if(!canAccess)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "У вас нет ключей от этого транспорта!", "");
        return 1;
    }

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    new name[MAX_PLAYER_NAME], str[128];
    GetPlayerName(playerid, name, sizeof(name));

    if(doors)
    {
        SetVehicleParam(vehicleid, V_LOCK, 0);
        format(str, sizeof(str), "{FF90FF}%s открыл(а) транспорт", name);
        PlayAudioStreamURL(playerid, "vehicle_sound_alarm.mp3");
    }
    else
    {
        SetVehicleParam(vehicleid, V_LOCK, 1);
        format(str, sizeof(str), "{FF90FF}%s закрыл(а) транспорт", name);
        PlayAudioStreamURL(playerid, "vehicle_sound_door.mp3");
    }

    SendClientMessage(playerid, 0xFFFF90FF, str);
    return 1;
}

CMD:setadmin(playerid, params[])
{
    if(!IsPlayerAdmin(playerid) && Player[playerid][pAdminLvl] < 6) return 1;
    new targetid, level, prefix[32];
    if(sscanf(params, "uds[32]", targetid, level, prefix)) return SendClientMessage(playerid, -1, "{999999}Используйте: /setadmin [id] [0-6] [префикс]");
    if(!IsPlayerConnected(targetid)) return 1;

    Player[targetid][pAdminLvl] = level;
    format(Player[targetid][pAdminPrefix], 32, "%s", prefix);
    if(level == 0) Player[targetid][pAdminAuth] = false;

    SavePlayerAccount(targetid);
    SendClientMessage(playerid, -1, "{999999}Права обновлены.");
    return 1;
}

CMD:getv(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new vehicleid, str[128];
    if(sscanf(params, "d", vehicleid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /getv [ID машины]");
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid <= 0) return SendClientMessage(playerid, 0xFF4B4BFF, "Неверный ID машины!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetVehiclePos(vehicleid, x, y + 2.0, z + 1.0);
    SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    format(str, sizeof(str), "{3399FF}[A] Вы телепортировали машину ID %d к себе.", vehicleid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:vget(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /vget [ID игрока]");
    if(!IsPlayerConnected(targetid)) return 1;

    new vehicle_slot = -1;
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++)
    {
        if(VehicleInfo[targetid][i][vSpawned] && VehicleInfo[targetid][i][vID] != INVALID_VEHICLE_ID)
        {
            vehicle_slot = i;
            break;
        }
    }

    if(vehicle_slot == -1) return SendClientMessage(playerid, 0xFF4B4BFF, "У игрока нет заспавненного личного транспорта!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);

    SetVehiclePos(VehicleInfo[targetid][vehicle_slot][vID], x + 2.0, y, z + 1.0);
    SetVehicleVirtualWorld(VehicleInfo[targetid][vehicle_slot][vID], GetPlayerVirtualWorld(targetid));
    LinkVehicleToInterior(VehicleInfo[targetid][vehicle_slot][vID], GetPlayerInterior(targetid));

    format(str, sizeof(str), "{3399FF}[A] Вы телепортировали личный транспорт игрока %s (слот %d) к нему.", Player[targetid][pName], vehicle_slot + 1);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:l(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID) return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

    new new_lights = !lights;
    SetVehicleParam(vehicleid, V_LIGHTS, new_lights);

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerStreamedIn(vehicleid, i)) continue;

        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(!IsPlayerConnected(p)) continue;
            for(new v = 0; v < MAX_PLAYER_VEHICLES; v++)
            {
                if(VehicleInfo[p][v][vSpawned] && VehicleInfo[p][v][vID] == vehicleid)
                {
                    if(new_lights == 1)
                    {
                        if(VehicleInfo[p][v][vLightsColor] != 0)
                        {
                            SetVehicleLightsColorHEX(i, vehicleid, VehicleInfo[p][v][vLightsColor]);
                        }
                    }
                }
            }
        }
    }
    return 1;
}

CMD:askin(playerid)
{
	if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

	if(GetPlayerSkin(playerid) == 122)
	{
		SetPlayerSkin(playerid, Player[playerid][pSkin]);
		SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы{FFFF00}сняли{FFFFFF} с себя скин {FFFF00}администратора.");
	}
	else
	{
		SetPlayerSkin(playerid, 122);
		SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы{FFFF00}надели{FFFFFF} на себя скин {FFFF00}администратора.");
	}
	return 1;
}

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{
    if(rpcid != 97) return 1;

    new action;
    new actionSubtype;

    if(!BS_ReadUint32(bs, action))
    {
        return 1;
    }

    if(action == 4)
    {
        callcmd::radial(playerid);
        return 1;
    }

    if(action == 14)
    {
        if(!BS_ReadUint8(bs, actionSubtype)) return 1;
        else if(actionSubtype == 2)
        {
            callcmd::donate(playerid);
        }
        else if(actionSubtype == 0)
        {
            callcmd::blackpass(playerid);
        }
    }

    return 1;
}
forward UpdatePunishments();
public UpdatePunishments()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || Player[i][pID] == 0) continue;

        new bool:changed = false;

        if(Player[i][pMuteTime] > 0)
        {
            Player[i][pMuteTime]--;
            changed = true;
        }

        if(Player[i][pJailTime] > 0)
        {
            Player[i][pJailTime]--;
            changed = true;

            if(Player[i][pJailTime] <= 0)
            {
                SetPlayerPos(i, 1345.0, 123.0, 1245.0);
                SetPlayerInterior(i, 0);
                SetPlayerVirtualWorld(i, 0);
                SendClientMessage(i, COLOR_WHITE, "{4682B4}[Информация] {FFFFFF}Срок вашего заключения окончен. Не нарушайте!");
            }
        }

        if(changed)
        {
            new query[128];
            mysql_format(db_handle, query, sizeof(query),
                "UPDATE `players` SET `mute_time` = %d, `jail_time` = %d WHERE `id` = %d",
                Player[i][pMuteTime], Player[i][pJailTime], Player[i][pID]);
            mysql_tquery(db_handle, query);
        }
    }
    return 1;
}

stock JailSystem(playerid)
{
    SetPlayerPos(playerid, 1000.0, 1000.0, 1000.0);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SendClientMessage(playerid, COLOR_RED, "Вы отбываете наказание в деморгане. Используйте /time для просмотра срока.");
    return 1;
}

CMD:time(playerid)
{
    new hour, minute, second, day, month, year;
    gettime(hour, minute, second);
    getdate(year, month, day);

    static const month_names[][] = {"", "января", "февраля", "марта", "апреля", "мая", "июня", "июля", "августа", "сентября", "октября", "ноября", "декабря"};
    static const day_names[][] = {"Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота"};

    new a = (14 - month) / 12;
    new y = year - a;
    new m = month + 12 * a - 2;
    new day_of_week = (day + y + y/4 - y/100 + y/400 + (31*m)/12) % 7;

    new str[1024], info[128];
    
    format(info, sizeof(info), "{FFFFFF}Сегодняшняя дата: {FFFF00}%d %s %dг.\n", day, month_names[month], year);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}День недели: {FFFF00}%s\n", day_names[day_of_week]);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Текущее время: {FFFF00}%02d:%02d:%02d\n\n", hour, minute, second);
    strcat(str, info);

    format(info, sizeof(info), "{FFFFFF}Время в игре за час: {FFFF00}%d мин.\n", Player[playerid][pSecondsHour] / 60);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Время в игре сегодня: {FFFF00}%d мин.\n", Player[playerid][pSecondsToday] / 60);
    strcat(str, info);
    format(info, sizeof(info), "{FFFFFF}Время в игре за вчера: {FFFF00}%d мин.\n", Player[playerid][pSecondsYesterday] / 60);
    strcat(str, info);

    if(Player[playerid][pJailTime] > 0)
    {
        format(info, sizeof(info), "\n{E0584B}До конца заключения: {FFFFFF}%d мин.", Player[playerid][pJailTime]);
        strcat(str, info);
    }
    if(Player[playerid][pMuteTime] > 0)
    {
        format(info, sizeof(info), "\n{E0584B}До конца мута: {FFFFFF}%d мин.", Player[playerid][pMuteTime]);
        strcat(str, info);
    }

    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}BAZE RUSSIA | Точное время", str, "Закрыть", "");
    return 1;
}

CMD:kick(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /kick [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    format(str, sizeof(str), "[A] Администратор %s кикнул %s. Причина: %s", Player[playerid][pName], Player[targetid][pName], reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    Kick(targetid);
    return 1;
}

CMD:ban(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, days, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, days, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /ban [id] [дни] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pBanTime] = days * 1440;
    format(Player[targetid][pBanReason], 64, reason);
    format(Player[targetid][pBanAdmin], 24, Player[playerid][pName]);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "[A] %s забанил %s на %d дн. Причина: %s", Player[playerid][pName], Player[targetid][pName], days, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    Kick(targetid);
    return 1;
}

CMD:permban(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /permban [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pBanTime] = 999999;
    format(Player[targetid][pBanReason], 64, reason);
    format(Player[targetid][pBanAdmin], 24, Player[playerid][pName]);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "[A] %s забанил %s НАВСЕГДА. Причина: %s", Player[playerid][pName], Player[targetid][pName], reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    Kick(targetid);
    return 1;
}

CMD:mute(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, mtime, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, mtime, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /mute [id] [мин] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pMuteTime] = mtime;
    format(str, sizeof(str), "[A] %s выдал мут %s на %d мин. Причина: %s", Player[playerid][pName], Player[targetid][pName], mtime, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    SavePlayerAccount(targetid);
    return 1;
}

CMD:jail(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, jtime, reason[64], str[128];
    if(sscanf(params, "uds[64]", targetid, jtime, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /jail [id] [мин] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pJailTime] = jtime;
    JailSystem(targetid);
    format(str, sizeof(str), "[A] %s посадил %s в деморган на %d мин. Причина: %s", Player[playerid][pName], Player[targetid][pName], jtime, reason);
    SendClientMessageToAll(0xFF4B4BFF, str);
    SavePlayerAccount(targetid);
    return 1;
}

CMD:warn(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, reason[64], str[128];
    if(sscanf(params, "us[64]", targetid, reason)) return SendClientMessage(playerid, -1, "{999999}Используйте: /warn [id] [причина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pWarns]++;
    format(str, sizeof(str), "[A] %s выдал варн %s. Причина: %s (%d/3)", Player[playerid][pName], Player[targetid][pName], reason, Player[targetid][pWarns]);
    SendClientMessageToAll(0xFF4B4BFF, str);
    if(Player[targetid][pWarns] >= 3)
    {
        Player[targetid][pWarns] = 0;
        Player[targetid][pBanTime] = 14400;
        format(Player[targetid][pBanReason], 64, "3/3 Warns");
        format(Player[targetid][pBanAdmin], 24, "Система");
        SavePlayerAccount(targetid);
        Kick(targetid);
    }
    return 1;
}

CMD:freeze(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /freeze [id]");
    if(!IsPlayerConnected(targetid)) return 1;
    TogglePlayerControllable(targetid, false);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] заморозил Вашего персонажа.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, ADMIN_COLOR, str);
    format(str, sizeof(str), "{3399FF}[A] Вы заморозили игрока %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:unfreeze(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /unfreeze [id]");
    if(!IsPlayerConnected(targetid)) return 1;
    TogglePlayerControllable(targetid, true);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] разморозил Вашего персонажа.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, -1, str);
    format(str, sizeof(str), "{3399FF}[A] Вы разморозили игрока %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:flip(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) targetid = playerid;
    if(!IsPlayerInAnyVehicle(targetid)) return 1;
    new Float:a;
    GetVehicleZAngle(GetPlayerVehicleID(targetid), a);
    SetVehicleZAngle(GetPlayerVehicleID(targetid), a);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] флипнул Ваш транспорт.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, -1, str);
    format(str, sizeof(str), "{3399FF}[A] Вы флипнули игрока %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:unmute(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /unmute [ID]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pMuteTime] = 0;
    format(str, sizeof(str), "[A] %s[%d] снял мут у игрока %s[%d].", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(0xFF4B4BFF, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] снял вам ограничение чата.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:unjail(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /unjail [ID]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pJailTime] = 0;
    SpawnPlayer(targetid);
    format(str, sizeof(str), "[A] %s[%d] выпустил из тюрьмы игрока %s[%d].", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(0xFF4B4BFF, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выпустил вас из тюрьмы.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:spawn(playerid, params[])
{
    if(!Player[playerid][pAdminAuth]) return 1;

    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /spawn [id]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, -1, "Игрок не найден.");

    SetRandomSpawn(targetid);
    SetPlayerInterior(targetid, 0);
    SetPlayerVirtualWorld(targetid, 0);
    SetCameraBehindPlayer(targetid);
    TogglePlayerControllable(targetid, true);

    SetPlayerScore(targetid, Player[targetid][pLevel]);
    SetPlayerSkin(targetid, Player[targetid][pSkin]);
    ResetPlayerMoney(targetid);
    GivePlayerMoney(targetid, Player[targetid][pMoney]);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] заспавнил Вас.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, ADMIN_COLOR, str);

    format(str, sizeof(str), "{3399FF}[A] Вы заспавнили игрока %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}
CMD:veh(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new modelid, color1, color2, str[128];
    if(sscanf(params, "ddd", modelid, color1, color2)) return SendClientMessage(playerid, -1, "{999999}Используйте: /veh [id модели] [цвет 1] [цвет 2]");
    if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, 0xFF4B4BFF, "ID машины должен быть от 400 до 611!");
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    if(Player[playerid][pAdminVeh] != INVALID_VEHICLE_ID) DestroyVehicle(Player[playerid][pAdminVeh]);
    Player[playerid][pAdminVeh] = CreateVehicle(modelid, x, y, z, a, color1, color2, -1);
    SetVehicleParamsInit(Player[playerid][pAdminVeh]);
    PutPlayerInVehicle(playerid, Player[playerid][pAdminVeh], 0);
    format(str, sizeof(str), "{3399FF}[A] Вы создали транспорт модель %d (ID: %d)", modelid, Player[playerid][pAdminVeh]);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:setskin(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 3) return 1;
    new targetid, skinid, str[128];
    if(sscanf(params, "ui", targetid, skinid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /setskin [id игрока] [id скина]");
    if(!IsPlayerConnected(targetid)) return 1;
    Player[targetid][pSkin] = skinid;
    SetPlayerSkin(targetid, skinid);
    SavePlayerAccount(targetid);
    format(str, sizeof(str), "{3399FF}[A] Вы установили игроку %s постоянный скин %d.", Player[targetid][pName], skinid);
    SendClientMessage(playerid, -1, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] установил вам постоянный скин %d.", Player[playerid][pName], playerid, skinid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

CMD:skin(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, skinid, str[128];

    if(sscanf(params, "ud", targetid, skinid)) return SendClientMessage(playerid, -1, "{999999} Используйте: /skin [ид игрока] [ид скина]");
    if(!IsPlayerConnected(targetid)) return 1;
    SetPlayerSkin(targetid, skinid);
    format(str, sizeof(str), "{3399FF}[A] Вы выдали игроку %s[%d] временный скин %d.", Player[targetid][pName], targetid, skinid);
    SendClientMessage(playerid, UNIV_COLOR, str);
    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал вам временный скин %d.", Player[playerid][pName], playerid, skinid);
    SendClientMessage(targetid, -1, str);
    return 1;
}

stock ShowDoubleTime(playerid)
{
    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}При получении зарплаты на каждой из доступных работ она будет умножаться в {33cc66}X2 {99cc00}раза.");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}Каждый 'PayDay' на сервере Вы будете получать в {33cc66}X2 {99cc00}раза больше очков опыта (EXP).");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}При пополнении баланса аккаунта (Black Coin) сумма пополнения будет умножаться в {33cc66}X2 {99cc00}раза!");

    SendClientMessage(playerid, 0xFFFFFFFF, "{E0584B}Счастливые часы | {99cc00}Пополнить счет своего игрового аккаунта можно прямо в лаунчере, или через сайт: {33cc66}none.online");
    return 1;
}

stock GetExpToNextLevel(playerid)
{
    return 8 + (Player[playerid][pLevel] - 1) * 4;
}

stock GivePlayerExp(playerid, amount)
{
    if(amount <= 0) return 0;

#if X2_SYSTEM
    new total_gain = amount * 2;
#else
    new total_gain = amount;
#endif

    Player[playerid][pExp] += total_gain;

    new needed = GetExpToNextLevel(playerid);

    while(Player[playerid][pExp] >= needed)
    {
        Player[playerid][pExp] -= needed;
        Player[playerid][pLevel]++;
        needed = GetExpToNextLevel(playerid);

        new str[128];
        format(str, sizeof(str), "{3399FF}Поздравляем! Ваш игровой уровень был повышен: %d", Player[playerid][pLevel]);
        SendClientMessage(playerid, -1, str);
        SetPlayerScore(playerid, Player[playerid][pLevel]);
    }

    SavePlayerAccount(playerid);
    return 1;
}

CMD:payday(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 6 || !Player[playerid][pAdminAuth])
        return 1;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(!IsPlayerConnected(i)) continue;

        else
        {
            GivePlayerExp(i, 1);
            SendClientMessage(i, -1, "{FF9900}========= PayDay =========");
        }

        Player[i][pSecondsHour] = 0;
    }

    new str[128];
    format(str, sizeof(str), "{FF9933}[A] Администратор %s[%d] активировал внеплановый PayDay.", Player[playerid][pName], playerid);
    SendAdminMessage(-1, str);

    return 1;
}

stock SetPlayerX2(playerid, bool:enable, time)
{
    if(!IsPlayerConnected(playerid) || playerid == INVALID_PLAYER_ID)
        return 0;

    new BitStream:bs = BS_New();
    if(bs == BitStream:0)
        return 0;

    BS_WriteValue(bs,
        PR_UINT8, 0x18,
        PR_UINT8, enable,
        PR_UINT8, time
    );

    if(IsPlayerConnected(playerid))
    {
        PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    }

    BS_Delete(bs);
    return 1;
}

stock GetPlayerBlackCoin(playerid)
{
    if(playerid == INVALID_PLAYER_ID) return 0;
    return Player[playerid][pBC];
}

stock GivePlayerBlackCoin(playerid, amount)
{
    if(playerid == INVALID_PLAYER_ID) return 0;

    Player[playerid][pBC] += amount;

    new fmt_str[64];
    if (amount < 0)
    {
        format(fmt_str, sizeof(fmt_str), "Вы потратили %d BC.", -amount);
        ShowNotification(playerid, 0, 5, 0, 1, fmt_str, "");
    }
    else
    {
        format(fmt_str, sizeof(fmt_str), "Вы получили %d BC.", amount);
        ShowNotification(playerid, 1, 5, 0, 1, fmt_str, "");
    }

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `bc` = %d WHERE `id` = %d", Player[playerid][pBC], Player[playerid][pID]);
    mysql_tquery(db_handle, query);

    return 1;
}

CMD:v(playerid, params[])
{
    if(Player[playerid][pVipType] < 1 || Player[playerid][pVipTime] <= 0)
        return ShowNotification(playerid, 0, 5, 0, 0, "У Вас нет vip-статуса!", "");

    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /v [текст]");

    new str[144], vip_name[24];
    switch(Player[playerid][pVipType])
    {
        case 1: vip_name = "Silver VIP";
        case 2: vip_name = "Gold VIP";
        case 3: vip_name = "Platinum VIP";
        default: vip_name = "VIP";
    }

    format(str, sizeof(str), "[%s] %s[%d]: %s", vip_name, Player[playerid][pName], playerid, params);

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
    {
        if(IsPlayerConnected(i))
        {
            if(Player[i][pVipType] > 0 || Player[i][pAdminLvl] > 0)
            {
                SendClientMessage(i, 0xFFD700FF, str);
            }
        }
    }
    return 1;
}

CMD:gethere(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /gethere [id]");
    if(!IsPlayerConnected(targetid)) return 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPlayerPos(targetid, x + 1.5, y, z);
    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] телепортировал Вас к себе.", Player[playerid][pName], playerid);
    SendClientMessage(targetid, ADMIN_COLOR, str);
    format(str, sizeof(str), "{3399FF}[A] Вы телепортировали игрока %s[%d] к себе.", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}
alias:gethere("gh")

CMD:goto(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;
    new targetid, str[128];
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, -1, "{999999}Используйте: /goto [id]");
    if(!IsPlayerConnected(targetid)) return 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(playerid, x + 1.5, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    format(str, sizeof(str), "{3399FF}[A] Вы телепортировались к игроку %s[%d].", Player[targetid][pName], targetid);
    SendClientMessage(playerid, -1, str);
    return 1;
}
alias:goto("g")

CMD:givecash(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 4) return 1; // Уровень на твое усмотрение
    new targetid, amount, str[128];
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givecash [id] [сумма]");
    if(!IsPlayerConnected(targetid)) return 1;

    GivePlayerMoneyEx(targetid, amount);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал Вам %d рублей.", Player[playerid][pName], playerid, amount);
    SendClientMessage(targetid, ADMIN_COLOR, str);
    format(str, sizeof(str), "{3399FF}[A] Вы выдали игроку %s[%d] %d рублей.", Player[targetid][pName], targetid, amount);
    SendClientMessage(playerid, -1, str);
    return 1;
}

CMD:givedonate(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 5) return 1;
    new targetid, amount, str[128];
    if(sscanf(params, "ui", targetid, amount)) return SendClientMessage(playerid, -1, "{999999}Используйте: /givedonate [id] [сумма]");
    if(!IsPlayerConnected(targetid)) return 1;

    GivePlayerBlackCoin(targetid, amount);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал Вам %d BlackCoins.", Player[playerid][pName], playerid, amount);
    SendClientMessage(targetid, ADMIN_COLOR, str);
    format(str, sizeof(str), "{3399FF}[A] Вы выдали игроку %s[%d] %d BlackCoins.", Player[targetid][pName], targetid, amount);
    SendClientMessage(playerid, -1, str);
    return 1;
}

stock GivePlayerWeaponEx(playerid, weaponid, ammo)
{
    if(weaponid < 1 || weaponid > 46) return 0;

    Player[playerid][pWeapon][GetWeaponSlot(weaponid)] = weaponid;
    Player[playerid][pAmmo][GetWeaponSlot(weaponid)] += ammo;

    GivePlayerWeapon(playerid, weaponid, ammo);
    
    return 1;
}
stock GetWeaponSlot(weaponid)
{
    new slot;
    switch(weaponid)
    {
        case 0, 1: slot = 0;
        case 2..9: slot = 1;
        case 10..15: slot = 10;
        case 16..18, 39: slot = 8;
        case 22..24: slot = 2;
        case 25..27: slot = 3;
        case 28, 29, 32: slot = 4;
        case 30, 31: slot = 5;
        case 33, 34: slot = 6;
        case 35..38: slot = 7;
        case 40: slot = 12;
        case 41..43: slot = 9;
        case 44..46: slot = 11;
    }
    return slot;
}

CMD:givegun(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 2) return 1;

    new targetid, weaponid, ammo, str[144];
    if(sscanf(params, "uii", targetid, weaponid, ammo))
        return SendClientMessage(playerid, -1, "{999999}Используйте: /givegun [id] [id оружия] [патроны]");

    if(!IsPlayerConnected(targetid)) return 1;
    if(weaponid < 1 || weaponid > 46)
        return SendClientMessage(playerid, -1, "{999999}Неверный ID оружия (1-46).");

    GivePlayerWeapon(targetid, weaponid, ammo);

    format(str, sizeof(str), "{3399FF}Администратор %s[%d] выдал Вам оружие (ID: %d, патроны: %d).", Player[playerid][pName], playerid, weaponid, ammo);
    SendClientMessage(targetid, ADMIN_COLOR, str);

    format(str, sizeof(str), "{3399FF}[A] Вы выдали игроку %s[%d] оружие %d (%d патронов).", Player[targetid][pName], targetid, weaponid, ammo);
    SendClientMessage(playerid, -1, str);
    return 1;
}
alias:givegun("gg")

stock GiveSimCard(playerid, simnumber)
{
    if(!IsPlayerConnected(playerid)) return 0;

    Player[playerid][pSimCard] = simnumber;

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `sim_card` = %d WHERE `id` = %d", simnumber, Player[playerid][pID]);
    mysql_tquery(db_handle, query, "", "");

    new str[64];
    format(str, sizeof(str), "Вы получили сим-карту с номером: %d", simnumber);
    ShowNotification(playerid, 1, 5, 0, 1, str, "");
    return 1;
}

stock GetPlayerSimCard(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    return Player[playerid][pSimCard];
}

stock SetVehicleMainColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    if(bs == BitStream:0) return 0;

    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x12,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleDiskColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new body_color = 0;

    for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++) {
        for(new v = 0; v < MAX_PLAYER_VEHICLES; v++) {
            if(VehicleInfo[i][v][vSpawned] && VehicleInfo[i][v][vID] == vehicleid) {
                body_color = VehicleInfo[i][v][vBodyColor];
                break;
            }
        }
    }

    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x12,
        PR_UINT32, body_color,
        PR_UINT32, color,
        PR_UINT32, color,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock UpdateVehicleTint(playerid, vehicleid, front, rear)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x00,
        PR_UINT32, front,
        PR_UINT32, rear,
        PR_UINT32, front,
        PR_UINT32, rear
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleLightsColorHEX(playerid, vehicleid, color)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    if(bs == BitStream:0) return 0;

    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x08,
        PR_UINT32, color
    );

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock UpdateVehicleNeon(playerid, vehicleid, main, left, right)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8,  0x09,
        PR_UINT32, main,
        PR_UINT32, left,
        PR_UINT32, right
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 19);

	BS_WriteValue(bitstream, PR_UINT32, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

stock SetVehicleVinylForPlayer(playerid, vehicleid, texture[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 12);

	BS_WriteValue(bitstream, PR_UINT8, strlen(texture));
	BS_WriteValue(bitstream, PR_STRING, texture);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

stock SetVehicleDlaniy(playerid, vehicleid, value)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs,
        PR_UINT16, vehicleid,
        PR_UINT8, 22,
        PR_UINT8, value
    );
    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

stock SetVehicleSuspension(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleSuspensionBias(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 2);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleSuspensionForce(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 1);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelSize(playerid, vehicleid, Float:value)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 3);
    BS_WriteValue(bitstream, PR_FLOAT, value);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelAngle(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 10);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelWidth(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 16);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleWheelCamber(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 0x0A);
    BS_WriteValue(bitstream, PR_FLOAT, front);
    BS_WriteValue(bitstream, PR_FLOAT, rear);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SetVehicleHydraulic(playerid, vehicleid, bool:enable)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 21);
    BS_WriteValue(bitstream, PR_UINT8, enable ? 1 : 0);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}
stock SetVehicleWheelSizeAdditive(playerid, vehicleid, Float:front, Float:rear)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 0x11); // case 17 (WheelSizeAdditive)
    BS_WriteValue(bitstream, PR_FLOAT, front); // передние колеса
    BS_WriteValue(bitstream, PR_FLOAT, rear);  // задние колеса
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

stock SendCreateWayPoint(playerid, waypoint_id, Float:x, Float:y, Float:z, icon_id, color, Float:dist, interior)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(
        bs,
        PR_UINT16, waypoint_id,
        PR_FLOAT, x,
        PR_FLOAT, y,
        PR_FLOAT, z,
        PR_UINT32, icon_id,
        PR_UINT32, color,
        PR_FLOAT, dist,
        PR_UINT8, interior
    );
    PR_SendRPC(bs, playerid, 169, PR_HIGH_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:waypoint(playerid)
{
    SendCreateWayPoint(playerid, 0, 1000.0, 1000.0, 10.0, 85, 27, 5000.0, 0);
    return 1;
}

stock PlayAudioStreamURL(playerid, const url[])
{
    new BitStream:bs = BS_New();
    new len = strlen(url);

    BS_WriteValue(bs, PR_INT32, 1);
    BS_WriteValue(bs, PR_UINT8, len);
    BS_WriteValue(bs, PR_STRING, url);
    BS_WriteValue(bs, PR_INT32, 0);
    BS_WriteValue(bs, PR_FLOAT, 1.0);
    BS_WriteValue(bs, PR_UINT8, 0);

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:htp(playerid, params[])
{
    new type;
    if(sscanf(params, "d", type)) return SendClientMessage(playerid, -1, "Используйте: /htp [0-6]");
    if(type < 0 || type > 6) return SendClientMessage(playerid, -1, "ID типа дома может быть от 0 до 6");

    switch(type)
    {
        case 0: SetPlayerPos(playerid, 2491.4910, 1003.5193, 1499.5813), SetPlayerFacingAngle(playerid, 268.0); // Деревенский
        case 1: SetPlayerPos(playerid, 2903.2188, 1498.0972, 2001.0000), SetPlayerFacingAngle(playerid, 268.0); // Эконом
        case 2: SetPlayerPos(playerid, 667.4174, 29.3543, 1024.1985), SetPlayerFacingAngle(playerid, 268.0);    // Средний 1
        case 3: SetPlayerPos(playerid, 994.7635, 2021.9585, 1561.0112), SetPlayerFacingAngle(playerid, 268.0); // Средний 2
        case 4: SetPlayerPos(playerid, -2.3367, 483.5531, 1381.0022), SetPlayerFacingAngle(playerid, 270.0);   // Высокий
        case 5: SetPlayerPos(playerid, 10.3718, 2494.1458, 1540.9941), SetPlayerFacingAngle(playerid, 0.0);     // Наивысший
        case 6: SetPlayerPos(playerid, 294.7161, 2139.3115, 1765.4641), SetPlayerFacingAngle(playerid, 0.0);   // Премиум
    }

    SetPlayerInterior(playerid, 1); // Во всех твоих данных указан интерьер ID 1
    SetPlayerVirtualWorld(playerid, 0); // Ставим в общий мир

    new str[64];
    format(str, sizeof(str), "Вы телепортированы в интерьер типа №%d", type);
    SendClientMessage(playerid, 0xFFFF00FF, str);
    return 1;
}

forward LoadHouses();
public LoadHouses() {
    new rows, fields;
    cache_get_data(rows, fields, db_handle);
    for(new i = 0; i < rows; i++) {
        HouseInfo[i][hID] = cache_get_field_content_int(i, "id", db_handle);
        HouseInfo[i][hOwnerID] = cache_get_field_content_int(i, "owner_id", db_handle);
        cache_get_field_content(i, "owner_name", HouseInfo[i][hOwnerName], db_handle, 24);
        HouseInfo[i][hType] = cache_get_field_content_int(i, "type", db_handle);
        HouseInfo[i][hPrice] = cache_get_field_content_int(i, "price", db_handle);
        HouseInfo[i][hEntX] = cache_get_field_content_float(i, "ent_x", db_handle);
        HouseInfo[i][hEntY] = cache_get_field_content_float(i, "ent_y", db_handle);
        HouseInfo[i][hEntZ] = cache_get_field_content_float(i, "ent_z", db_handle);
        HouseInfo[i][hExitX] = cache_get_field_content_float(i, "exit_x", db_handle);
        HouseInfo[i][hExitY] = cache_get_field_content_float(i, "exit_y", db_handle);
        HouseInfo[i][hExitZ] = cache_get_field_content_float(i, "exit_z", db_handle);
        HouseInfo[i][hExitA] = cache_get_field_content_float(i, "exit_a", db_handle);
        UpdateHouseStatus(i);
        TotalHouses++;
    }
    printf("Загружено домов: %d", TotalHouses);
    return 1;
}

stock UpdateHouseStatus(id)
{
    if(HouseInfo[id][hPickup] != 0) DestroyDynamicPickup(HouseInfo[id][hPickup]);
    if(HouseInfo[id][hLabel] != Text3D:INVALID_3DTEXT_ID) DestroyDynamic3DTextLabel(HouseInfo[id][hLabel]);

    new str[256];
    if(HouseInfo[id][hOwnerID] == 0)
    {
        HouseInfo[id][hPickup] = CreateDynamicPickup(1273, 23, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ], 0, 0);
        format(str, sizeof(str), "{FFFF00}« Деревенский дом »\n{FFFF00}« {FFFFFF}Дом свободен {FFFFFF}| Номер: {FFFF00}%d", HouseInfo[id][hID]);
    }
    else
    {
        HouseInfo[id][hPickup] = CreateDynamicPickup(1272, 23, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ], 0, 0);
        format(str, sizeof(str), "{FFFF00}« Деревенский дом »\n{FFFFFF}Владелец: {FFFF00}%s", HouseInfo[id][hOwnerName]);
    }
    HouseInfo[id][hLabel] = CreateDynamic3DTextLabel(str, -1, HouseInfo[id][hEntX], HouseInfo[id][hEntY], HouseInfo[id][hEntZ] + 0.8, 12.0);
    return 1;
}

CMD:addhouse(playerid, params[]) {
    if(Player[playerid][pAdminLvl] < 5) return 1;
    new htype, hprice;
    if(sscanf(params, "dd", htype, hprice)) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: /addhouse [0-6] [цена]");
    if(htype < 0 || htype > 6) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Тип дома от 0 до 6!");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new i = TotalHouses;
    HouseInfo[i][hType] = htype;
    HouseInfo[i][hPrice] = hprice;
    HouseInfo[i][hEntX] = x;
    HouseInfo[i][hEntY] = y;
    HouseInfo[i][hEntZ] = z;
    HouseInfo[i][hOwnerID] = 0;
    format(HouseInfo[i][hOwnerName], 24, "None");

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "INSERT INTO `houses` (type, price, ent_x, ent_y, ent_z) VALUES (%d, %d, '%f', '%f', '%f')", htype, hprice, x, y, z);
    mysql_tquery(db_handle, query, "OnHouseCreated", "i", i);
    return 1;
}

forward OnHouseCreated(id);
public OnHouseCreated(id) {
    HouseInfo[id][hID] = cache_insert_id();
    UpdateHouseStatus(id);
    TotalHouses++;
}

CMD:sethouseexit(playerid, params[]) {
    if(Player[playerid][pAdminLvl] < 5) return 1;
    new hid;
    if(sscanf(params, "d", hid)) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: /sethouseexit [id дома]");

    new slot = -1;
    for(new i=0; i<TotalHouses; i++) if(HouseInfo[i][hID] == hid) { slot = i; break; }
    if(slot == -1) return ShowNotification(playerid, 0, 5, 0, 0, "Дом не найден!", "");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    HouseInfo[slot][hExitX] = x; HouseInfo[slot][hExitY] = y; HouseInfo[slot][hExitZ] = z; HouseInfo[slot][hExitA] = a;

    new query[256];
    mysql_format(db_handle, query, sizeof(query), "UPDATE `houses` SET exit_x='%f', exit_y='%f', exit_z='%f', exit_a='%f' WHERE id=%d", x, y, z, a, hid);
    mysql_tquery(db_handle, query, "", "");
    SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Координаты выхода установлены!");
    return 1;
}

CMD:exit(playerid) {
    new i = GetPVarInt(playerid, "InHouseID");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, HouseInteriors[HouseInfo[i][hType]][iX], HouseInteriors[HouseInfo[i][hType]][iY], HouseInteriors[HouseInfo[i][hType]][iZ])) return 1;

    SetPlayerPos(playerid, HouseInfo[i][hExitX], HouseInfo[i][hExitY], HouseInfo[i][hExitZ]);
    SetPlayerFacingAngle(playerid, HouseInfo[i][hExitA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    DeletePVar(playerid, "InHouseID");
    return 1;
}

CMD:house(playerid)
{
    new houseid = -1;
    for(new i = 0; i < TotalHouses; i++)
    {
        if(HouseInfo[i][hOwnerID] == Player[playerid][pID])
        {
            houseid = i;
            break;
        }
    }

    if(houseid == -1) return ShowNotification(playerid, 0, 5, 0, 0, "У вас нет личного дома!", "");

    SetPVarInt(playerid, "ManageHouseID", houseid);

    new str[512];
    str = "Название    Информация\n";
    format(str, sizeof(str), "%s{FFFFFF}1. Состояние двери    {E0584B}%s\n", str, (HouseInfo[houseid][hLock]) ? ("Закрыта") : ("Открыта"));
    format(str, sizeof(str), "%s{FFFFFF}2. Найти дом    {E0584B}GPS", str);

    ShowPlayerDialog(playerid, DIALOG_MENU_HOUSE, DIALOG_STYLE_TABLIST_HEADERS,
        "{E0584B}BAZE RUSSIA {FFFFFF}| Управление",
        str, "Выбрать", "Закрыть"
    );
    return 1;
}


CMD:donate(playerid)
{
    new Node:donate_json = JSON_Object();

    JSON_SetInt(donate_json, "o", 1);
    JSON_SetInt(donate_json, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(donate_json, "d", GetPlayerBlackCoin(playerid));
    JSON_SetInt(donate_json, "ds", 1);
    JSON_SetString(donate_json, "em", "");
    JSON_SetInt(donate_json, "k", 0);
    JSON_SetInt(donate_json, "lc", 0);
    JSON_SetInt(donate_json, "sv", 1);
    JSON_SetInt(donate_json, "p", Player[playerid][pGiftDelay]);
    JSON_SetString(donate_json, "nm", GetPlayerNameEx(playerid));

    new Node:i_array = JSON_Array();
    JSON_SetArray(donate_json, "i", i_array);

    new Node:s_array = JSON_Array(
        JSON_Int(94), JSON_Int(65362), JSON_Int(40),
        JSON_Int(448), JSON_Int(65362), JSON_Int(29),
        JSON_Int(544), JSON_Int(65362), JSON_Int(35)
    );
    JSON_SetArray(donate_json, "s", s_array);

    OnPacketIncoming(playerid, 22, donate_json);

    JSON_Cleanup(donate_json);
    return 1;
}

CMD:blackpass(playerid)
{
    new Node:donate_json = JSON_Object();

    JSON_SetInt(donate_json, "o", 1);
    JSON_SetInt(donate_json, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(donate_json, "d", GetPlayerBlackCoin(playerid));
    JSON_SetInt(donate_json, "ds", 1);
    JSON_SetString(donate_json, "em", "");
    JSON_SetInt(donate_json, "k", 0);
    JSON_SetInt(donate_json, "lc", 4);
    JSON_SetInt(donate_json, "sv", 1);
    JSON_SetInt(donate_json, "p", Player[playerid][pGiftDelay]);
    JSON_SetString(donate_json, "nm", GetPlayerNameEx(playerid));

    new Node:s_array = JSON_Array(
        JSON_Int(94), JSON_Int(65362), JSON_Int(40),
        JSON_Int(448), JSON_Int(65362), JSON_Int(29),
        JSON_Int(544), JSON_Int(65362), JSON_Int(35)
    );
    JSON_SetArray(donate_json, "s", s_array);

    OnPacketIncoming(playerid, 22, donate_json);

    JSON_Cleanup(donate_json);

    new Node:json = JSON_Object();

    JSON_SetInt(json, "ec", PlayerBP[playerid][bpExp]);
    JSON_SetInt(json, "a", PlayerBP[playerid][bpPremium]);
    JSON_SetInt(json, "is", 0);
    JSON_SetInt(json, "la", 0);
    JSON_SetString(json, "ln", BlackPassTop[0][topName]);
    JSON_SetInt(json, "lv", PlayerBP[playerid][bpLevel]);
    JSON_SetInt(json, "ps", 0);
    JSON_SetString(json, "sn", BP_SEASON_NAME);
    JSON_SetInt(json, "sp", 0);
    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "td", 2505600);
    JSON_SetInt(json, "ty", -1);
    JSON_SetInt(json, "s", 1);
    
    OnPacketIncoming(playerid, 22, json);

    JSON_Cleanup(json);

    return 1;
}

CMD:guiid(playerid, params[])
{
    new id;
    if(sscanf(params, "d", id)) return SendClientMessage(playerid, -1, "Используйте: /guiid [id]");

    new Node:gui_json = JSON_Object();

	JSON_SetInt(gui_json, "o", 1);
	
    OnPacketIncoming(playerid, id, gui_json);

    JSON_Cleanup(gui_json);

    return 1;
}


