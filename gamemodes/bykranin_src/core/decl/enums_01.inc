//>> Файл: bykranin_src/core/decl/enums_01.inc  (1545 строк)
//>> Тема: макросы, константы, enum и глобальные массивы (данные, без логики)
//>> Внутри: GetVehicleRGBAColorById, GetAngleToPoint, SendReport, DeleteReport, GetReportId, UpdateReportText, UpdateReportText1
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#define AddOwnableCarData(%0,%1,%2,%3)	g_ownable_car[%0][%1] %2= %3

#define IsOwnableCarOwned(%0)			(GetOwnableCarData(%0, OC_OWNER_ID) > 0)

// ------------------------------------------
#define GetHotelData(%0,%1,%2) 			g_hotel[%0][%1][%2]
#define SetHotelData(%0,%1,%2,%3) 		g_hotel[%0][%1][%2] = %3
#define AddHotelData(%0,%1,%2,%3,%4) 	g_hotel[%0][%1][%2] %3= %4

#define IsHotelRoomOwned(%0,%1)		(GetHotelData(%0, %1, H_OWNER_ID) > 0) // занят ли номер отеля

// ------------------------------------------
#define GetEntranceData(%0,%1) 			g_entrance[%0][%1]
#define SetEntranceData(%0,%1,%2) 		g_entrance[%0][%1] = %2
#define AddEntranceData(%0,%1,%2,%3) 	g_entrance[%0][%1] %2= %3

#define GetPlayerPremium(%0)	GetPlayerData(%0, P_PREMIUM)		// премиум-аккаунт

#define GetFamilyCarData(%0,%1)        g_family_car[%0][%1]
#define SetFamilyCarData(%0,%1,%2)     g_family_car[%0][%1] = %2
#define AddFamilyCarData(%0,%1,%2,%3)  g_family_car[%0][%1] %2= %3

// ------------------------------------------
/*#define GetGateData(%0,%1)			g_gate[%0][%1]
#define SetGateData(%0,%1,%2)		g_gate[%0][%1] = %2
#define AddGateData(%0,%1,%2,%3)	g_gate[%0][%1] %2= %3*/

// ------------------------------------------
#define GetOrderData(%0,%1)			g_order[%0][%1]
#define SetOrderData(%0,%1,%2)		g_order[%0][%1] = %2
#define AddOrderData(%0,%1,%2,%3)	g_order[%0][%1] %2= %3

#define	GetPlayerYouTubeEx(%0)	GetPlayerData(%0, P_YOUTUBE) 			// уровень ютуберки

#define GetReportData(%0,%1)			g_report[%0][%1]
#define SetReportData(%0,%1,%2)			g_report[%0][%1] = %2


// ------------------------------------------
#define AntiFloodPlayerInit(%0) 			g_player_flood[%0] = g_flood_default_values

#define GetPlayerAntiFloodData(%0,%1) 		g_player_flood[%0][%1]
#define SetPlayerAntiFloodData(%0,%1,%2)	g_player_flood[%0][%1] = %2
#define AddPlayerAntiFloodData(%0,%1,%2,%3)	g_player_flood[%0][%1] %2= %3

#define GetFamilyData(%0,%1)    g_family[%0][%1]
#define SetFamilyData(%0,%1,%2) g_family[%0][%1] = %2
#define AddFamilyData(%0,%1,%2,%3) g_family[%0][%1] %2= %3

#define GetGiftData(%0,%1) 			g_gift[%0][%1]
#define SetGiftData(%0,%1,%2)		g_gift[%0][%1] = %2
#define AddGiftData(%0,%1,%2,%3) 	g_gift[%0][%1] %2= %3

#define GetPlayerCurrentDonate(%0)      GetPlayerData(%0, P_DONATE_MONEY)     // текущий баланс донат-очков
#define GetPlayerTotalDonate(%0)        GetPlayerData(%0, P_DONATE_TOTAL)   // всего пополнений баланса

// ------------------------------------------
#define GetPlayerPhoneBook(%0,%1,%2) 	g_player_phone_book[%0][%1][%2]
#define SetPlayerPhoneBook(%0,%1,%2,%3)	g_player_phone_book[%0][%1][%2] = %3

#define IsPlayerPhoneBookInit(%0) 			g_player_phone_book_init[%0]
#define SetPlayerPhoneBookInitStatus(%0,%1) g_player_phone_book_init[%0] = %1

#define GetPlayerPhoneBookContacts(%0) 		g_player_phone_book_contacts[%0]
#define SetPlayerPhoneBookContacts(%0,%1) 	g_player_phone_book_contacts[%0] = %1

#define GetPlayerPhoneBookSelectContact(%0) 		g_player_phone_book_select_cont[%0]
#define SetPlayerPhoneBookSelectContact(%0,%1) 		g_player_phone_book_select_cont[%0] = %1

// ------------------------------------------
#define GetPlayerPhoneCall(%0,%1) 		g_player_phone_call[%0][%1]
#define SetPlayerPhoneCall(%0,%1,%2)	g_player_phone_call[%0][%1] = %2

#define ClearPlayerPhoneCall(%0) g_player_phone_call[%0] = g_phone_call_default_values

// ------------------------------------------
#define GetPlayerOfferInfo(%0,%1) 		g_player_offer[%0][%1]
#define SetPlayerOfferInfo(%0,%1,%2) 	g_player_offer[%0][%1] = %2

#define SetPlayerOfferValue(%0,%1,%2) g_player_offer[%0][O_INCOMING_VALUE][%1] = %2
#define ClearPlayerOffer(%0) g_player_offer[%0] = g_offer_default_values

// ------------------------------------------
#define GetRepositoryData(%0,%1,%2) 	g_repository[%0][%1][%2]
#define SetRepositoryData(%0,%1,%2,%3)	g_repository[%0][%1][%2] = %3

#define	GetPlayerTest(%0)	GetPlayerData(%0, P_TEST)

// ------------------------------------------
#define GetPlayerListitemValue(%0,%1) 		g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2) 	g_player_listitem[%0][%1] = %2

#define ClearPlayerListitemValues(%0)		g_player_listitem[%0] = g_listitem_values

#define GetPlayerUseListitem(%0) 		g_player_listitem_use[%0]
#define SetPlayerUseListitem(%0,%1) 	g_player_listitem_use[%0] = %1

// ------------------------------------------
#define GetBankAccountData(%0,%1,%2)		g_bank_account[%0][%1][%2]
#define SetBankAccountData(%0,%1,%2,%3) 	g_bank_account[%0][%1][%2] = %3

#define GetPlayerBankTransfer(%0,%1) 	g_player_bank_transfer[%0][%1]
#define SetPlayerBankTransfer(%0,%1,%2)	g_player_bank_transfer[%0][%1] = %2

// ------------------------------------------
#define GetInfoPickupData(%0,%1) info_pickup[%0][%1]

// ------------------------------------------
#define GetTempJobInfo(%0,%1) g_temp_jobs[%0][%1]

// ------------------------------------------
#define GetMonthName(%0) 	month_name[%0 - 1]
#define GetDayName(%0) 		day_name[%0 - 1]

// ------------------------------------------
#define GetNumericName(%0)	numeric_name[%0 - 1]

// ------------------------------------------
#define GetATMInfo(%0,%1)	g_atm[%0][%1]

// ------------------------------------------
#define GetPlayerDrivingExamInfo(%0,%1) 	g_player_driving_exam[%0][%1]
#define SetPlayerDrivingExamInfo(%0,%1,%2) 	g_player_driving_exam[%0][%1] = %2
#define ClearPlayerDrivingExamInfo(%0) 		g_player_driving_exam[%0] = g_driving_exam_default_values

// ------------------------------------------
#define GetTeleportData(%0,%1)		g_teleport[%0][%1]
#define SetTeleportData(%0,%1,%2)	g_teleport[%0][%1] = %2

// ------------------------------------------
#define GetTeleportListData(%0,%1)		g_teleport_list[%0][%1]

// ------------------------------------------
#define GetGangZoneData(%0,%1)			g_gang_zone[%0][%1]
#define SetGangZoneData(%0,%1,%2)		g_gang_zone[%0][%1] = %2

// ------------------------------------------
#define GetGangRepositoryData(%0,%1)		g_gang_repository[%0][%1]
#define SetGangRepositoryData(%0,%1,%2)		g_gang_repository[%0][%1] = %2

// ------------------------------------------
#define GetHelpInfoData(%0,%1) 		help_info[%0][%1]
#define GetAnimListData(%0,%1) 		anim_list[%0][%1]
#define GetMapIconsData(%0,%1) 		map_icons[%0][%1]

// ------------------------------------------
#define GetPlayerGPSInfo(%0,%1) 	g_player_gps[%0][%1]
#define SetPlayerGPSInfo(%0,%1,%2) 	g_player_gps[%0][%1] = %2

// ------------------------------------------
#define GetPlayerImprovementInfo(%0,%1) g_player_improvements[%0][%1]

// ------------------------------------------
#define GetPlayerPinCodeState(%0) 		pin_code_state[%0]
#define SetPlayerPinCodeState(%0,%1) 	pin_code_state[%0] = %1

#define GetPlayerPinCodeValue(%0,%1) 	pin_code_value[%0][%1]
#define SetPlayerPinCodeValue(%0,%1,%2)	pin_code_value[%0][%1] = %2

// ------------------------------------------
#define GetPlayerSettingData(%0,%1)		g_player_setting[%0][%1]
#define SetPlayerSettingData(%0,%1,%2)	g_player_setting[%0][%1] = %2
#define AddPlayerSettingData(%0,%1,%2)	g_player_setting[%0][%1] += %2

// ------------------------------------------
#define GetPlayerData(%0,%1) 	g_player[%0][%1]

//23
#define	GetPlayerBoxEx(%0)	GetPlayerData(%0, P_BOXQUEST) 			// уровень админки
//

#define SetPlayerData(%0,%1,%2)	g_player[%0][%1] = %2
#define AddPlayerData(%0,%1,%2,%3) g_player[%0][%1] %2= %3

#define GetPlayerAccountID(%0)	GetPlayerData(%0, P_ACCOUNT_ID) 	// ид аккаунта
#define GetPlayerIpEx(%0)		GetPlayerData(%0, P_IP) 			// ип игрока
#define GetPlayerNameEx(%0)		GetPlayerData(%0, P_NAME) 			// имя игрока
#define GetPlayerColorEx(%0)	GetPlayerData(%0, P_COLOR)			// цвет игрока
#define GetPlayerSelectSkin(%0)	GetPlayerData(%0, P_SELECT_SKIN) 	// выбраный скин
#define GetPlayerLevel(%0)		GetPlayerData(%0, P_LEVEL)			// уровень игрока
#define GetPlayerExp(%0)		GetPlayerData(%0, P_EXP)			// очки опыта игрока
#define GetPlayerSuspect(%0)	GetPlayerData(%0, P_SUSPECT)		// уровень розыска игрока
#define GetExpToNextLevel(%0)	((GetPlayerData(%0, P_LEVEL)+1)*4) 	// очков опыта к следуйщему уровню
#define GetPlayerPhone(%0)		GetPlayerData(%0, P_PHONE)			// номер телефона игрока
#define GetPlayerSex(%0)		GetPlayerData(%0, P_SEX)			// пол игрока
#define GetPlayerSexName(%0)	GetPlayerData(%0, P_SEX) ? ("Женский") : ("Мужской") // название пола
#define GetPlayerChatType(%0)	GetPlayerData(%0, P_CHAT_TYPE) 		// тип чата GetPlayerRepCar
#define GetPlayerRepCar(%0)	GetPlayerData(%0, P_REPCARID) 		// тип чата GetPlayerRepCar
#define	GetPlayerAdminEx(%0)	GetPlayerData(%0, P_ADMIN) 			// уровень админки
#define	GetPlayerWeaponLic(%0)	GetPlayerData(%0, P_WEAPON_LIC)
#define	GetPlayerHelperEx(%0)	GetPlayerData(%0, P_HELPER) 			// уровень хелперки
#define	GetPlayerSecretEx(%0)	GetPlayerData(%0, P_SECRET) 			// скрытность
#define GetPlayerMoneyEx(%0)	GetPlayerData(%0, P_MONEY) 			// деньги игрока
#define GetPlayerBankMoney(%0)	GetPlayerData(%0, P_BANK) 			// деньги игрока
#define GetPlayerAFKTime(%0)	GetPlayerData(%0, P_AFK_TIME) 		// время афк
#define GetPlayerLastVehicle(%0) GetPlayerData(%0, P_LAST_VEHICLE) 	// ид последнего авто в котором сидел
#define GetPlayerJobCar(%0)		GetPlayerData(%0, P_JOB_CAR) 		// рабочий транспорт
#define GetPlayerJob(%0)		GetPlayerData(%0, P_JOB) 			// работа
#define GetPlayerInBiz(%0)		GetPlayerData(%0, P_IN_BUSINESS) 	// в какой бизнес вошел\находится
#define GetPlayerInHouse(%0)	GetPlayerData(%0, P_IN_HOUSE) 		// в какой доме вошел\находится
#define GetPlayerTeamEx(%0)		GetPlayerData(%0, P_TEAM)			// организация в которой состоит игрок
#define GetPlayerHealthEx(%0)	GetPlayerData(%0, P_HEALTH)			// количество здоровья
#define GetPlayerPremiumTime(%0)	GetPlayerData(%0, P_PREMIUM_TIME) // время действия премиум-аккаунта

#define GetPlayerSpawnSetting(%0) 		GetPlayerData(%0, P_SPAWN)  // место спавна
#define SetPlayerSpawnSetting(%0,%1) 	SetPlayerData(%0, P_SPAWN, %1)  // установка места спавна

#define GetPlayerDonateRub(%0) 			GetPlayerData(%0, P_DONATE_RUB) 	// текущий баланс донат-рублей
#define GetPlayerMoneti(%0) 			GetPlayerData(%0, P_MONETI) 		// семейные монеты игрока

#define GetPlayerDonateMoney(%0) 		GetPlayerData(%0, P_DONATE_MONEY) 	// текущий баланс донат-очков
#define GetPlayerTotalDonate(%0) 		GetPlayerData(%0, P_DONATE_TOTAL) 	// всего пополнений баланса

#define GetPlayerInEntrance(%0)			GetPlayerData(%0, P_IN_ENTRANCE)		// в каком подъезде
#define GetPlayerInEntranceFloor(%0)	GetPlayerData(%0, P_IN_ENTRANCE_FLOOR)	// на каком этаже в подъезде

#define GetPlayerJobName(%0) 	GetJobNameSafe(GetPlayerData(%0, P_JOB))

#define GetPlayerTempJob(%0) 			GetPlayerData(%0, P_TEMP_JOB) 		// временная работа
#define GetPlayerTempJobState(%0) 		GetPlayerData(%0, P_TEMP_JOB_STATE) // что делать
#define GetPlayerTempJobCheckAnim(%0)	GetPlayerData(%0, P_TEMP_JOB_CHECK) // проверка анимки
#define GetPlayerJobLoadItems(%0) 		GetPlayerData(%0, P_JOB_LOAD_ITEMS) // загружено (...)
#define GetPlayerJobWage(%0) 			GetPlayerData(%0, P_JOB_WAGE) 		// зарплата

#define GetPlayerOwnableCar(%0)			GetPlayerData(%0, P_OWNABLE_CAR)	// ид личного ТС
#define GetPlayerRentCar(%0)			GetPlayerData(%0, P_RENT_CAR)		// ид арендованного ТС
#define GetPlayerAllowedCar(%0)			GetPlayerData(%0, P_ALLOWED_CAR)	// ид доверенного ТС
#define GetPlayerUseTrunk(%0)			GetPlayerData(%0, P_USE_TRUNK)		// ид авто используемого багажника

#define GetPlayerCarSlots(%0)			GetPlayerData(%0, P_CAR_SLOTS)		// количество слотов для транспорта

#define GetPlayerAdminWarn(%0)			GetPlayerData(%0, P_ADMIN_WARN)		// количество админ варнов

#define SetPlayerUseTrunk(%0,%1)			SetPlayerData(%0, P_USE_TRUNK,	%1)	// установить ид авто используемого багажника
#define SetPlayerLogged(%0,%1)				SetPlayerData(%0, P_LOGGED, %1) 	// установить статус авторизации
#define SetPlayerChatType(%0,%1)			SetPlayerData(%0, P_CHAT_TYPE, %1) 	// установить тип чата

#define SetPlayerInBiz(%0,%1)				SetPlayerData(%0, P_IN_BUSINESS, %1)	// установить биз в котором находится
#define SetPlayerInHouse(%0,%1)				SetPlayerData(%0, P_IN_HOUSE, %1)		// установить дом в котором находится
#define SetPlayerTeamEx(%0,%1)				SetPlayerData(%0, P_TEAM, %1)			// организация в которой состоит игрок

#define SetPlayerInEntrance(%0,%1)			SetPlayerData(%0, P_IN_ENTRANCE, %1)		// установить подъезд в котором находится
#define SetPlayerInEntranceFloor(%0,%1)		SetPlayerData(%0, P_IN_ENTRANCE_FLOOR, %1)  // установить этаж в подъезд котором находится

#define SetPlayerTempJob(%0,%1) 			SetPlayerData(%0, P_TEMP_JOB, %1) 		// временная работа
#define SetPlayerTempJobState(%0,%1) 		SetPlayerData(%0, P_TEMP_JOB_STATE, %1)	// что делать
#define SetPlayerTempJobCheckAnim(%0,%1)	SetPlayerData(%0, P_TEMP_JOB_CHECK, %1) // проверка анимки
#define SetPlayerJobLoadItems(%0,%1) 		SetPlayerData(%0, P_JOB_LOAD_ITEMS, %1)	// загружено (...)

#define IsPlayerLogged(%0)		GetPlayerData(%0, P_LOGGED)		// статус авторизации
#define IsPlayerUseAnim(%0)		GetPlayerData(%0, P_USE_ANIM)	// использует ли анимку (/anim)
#define IsPlayerInJob(%0)		GetPlayerData(%0, P_IN_JOB)		// на работе ли
#define IsPlayerAFK(%0)			(GetPlayerData(%0, P_AFK_TIME) >= 5) // афк ли игрок
#define IsPlayerMuted(%0)       GetPlayerData(%0, P_MUTE)       // есть ли мут
#define IsPlayerFMuted(%0)       GetPlayerData(%0, P_FMUTE)       // есть ли мут

// ------------------------------------------
#define GetHouseTypeInfo(%0,%1)		g_house_type[%0][%1]
#define SetHouseTypeInfo(%0,%1,%2)	g_house_type[%0][%1] = %2

#define GetHouseData(%0,%1)			g_house[%0][%1]
#define SetHouseData(%0,%1,%2)		g_house[%0][%1] = %2
#define AddHouseData(%0,%1,%2,%3)	g_house[%0][%1] %2= %3

#define IsHouseOwned(%0)			(GetHouseData(%0, H_OWNER_ID) > 0) // куплен ли дом

// ------------------------------------------
#define GetHouseRenterInfo(%0,%1,%2) 		g_house_renters[%0][%1][%2]
#define SetHouseRenterInfo(%0,%1,%2,%3) 	g_house_renters[%0][%1][%2] = %3
#define AddHouseRenterInfo(%0,%1,%2,%3,%4)	g_house_renters[%0][%1][%2] %3= %4

#define GetHouseRentersCount(%0)			g_house_renters_count[%0]
#define SetHouseRentersCount(%0,%1)			g_house_renters_count[%0] = %1
#define AddHouseRentersCount(%0,%1,%2)		g_house_renters_count[%0] %1= %2

#define IsHouseRoomOwned(%0,%1)				(GetHouseRenterInfo(%0, %1, HR_OWNER_ID) > 0)

// ------------------------------------------
#define GetBusinessInteriorInfo(%0,%1)	 	g_business_interiors[%0][%1]
#define SetBusinessInteriorInfo(%0,%1,%2) 	g_business_interiors[%0][%1] = %2

#define GetBusinessData(%0,%1) 			g_business[%0][%1]
#define SetBusinessData(%0,%1,%2) 		g_business[%0][%1] = %2
#define AddBusinessData(%0,%1,%2,%3) 	g_business[%0][%1] %2= %3

#define IsBusinessOwned(%0)				(GetBusinessData(%0, B_OWNER_ID) > 0)

#define GetBusinessGPSInfo(%0,%1)		g_business_gps[%0][%1]
#define SetBusinessGPSInfo(%0,%1,%2)	g_business_gps[%0][%1] = %2
#define AddBusinessGPSInfo(%0,%1,%2,%3) g_business_gps[%0][%1] %2= %3

// ------------------------------------------
#define GetFuelStationData(%0,%1)		g_fuel_station[%0][%1]
#define SetFuelStationData(%0,%1,%2)	g_fuel_station[%0][%1] = %2
#define AddFuelStationData(%0,%1,%2,%3)	g_fuel_station[%0][%1] %2= %3

#define IsFuelStationOwned(%0)			(GetFuelStationData(%0, FS_OWNER_ID) > 0) // куплена ли заправка

#define GetTeamRankName(%0,%1)			rank_names[%0-1][%1-1]
#define GetTeamData(%0,%1)				g_organization[%0][%1]
#define SetTeamData(%0,%1,%2)			g_organization[%0][%1] = %2
#define GetTeamName(%0)					GetTeamData(%0, O_NAME)

#define GetWeaponName(%0)				weapon_names[%0]

//#define GetWeaponTint(%0)				weapon_tints[%0]
#define GetWeaponTintData(%0,%1)		g_weapon_tint[%0][%1]

#define GetPlayerSpectateData(%0,%1)	g_spectate[%0][%1]
#define SetPlayerSpectateData(%0,%1,%2) g_spectate[%0][%1] = %2

// ------------------------------------------
#define GetDonatePrice(%0)				g_donate_prices[%0]

//

// ------------------------------------------
/*#define GetRadarData(%0,%1)				g_radar[%0][%1]
#define SetRadarData(%0,%1,%2)			g_radar[%0][%1] = %2*/

// ------------------------------------------
#define GetAdvertData(%0,%1)			g_advert[%0][%1]
#define SetAdvertData(%0,%1,%2)			g_advert[%0][%1] = %2
//***********
#define COR_SERVER          0xFF0000FF
#define COR_QUEST           0xFFD700FF
#define c_server            "{FFFF00}"
#define c_s		            "{FF0000}"
#define c_b     	        "{FFFFFF}"
#define c_i		             "{32CD32}"
#define c_m		             "{009900}"
#define COR_RED             0xFF0000FF
#define c_red               "{FF0000}"
#define c_white               "{FF0000}"
#define c_gray               "{FF0000}"
#define FIX_SYNC_COOLDOWN 3000


#define f_1					"{FFFFFF}" // белый
#define f_2					"{CD5C5C}" // багровый
#define f_3					"{FF0000}" // красный
#define f_4					"{8B0000}" // темно-красный
#define f_5					"{FFC0CB}" // светло-розовый
#define f_6					"{FFA07A}" // цвет кожи
#define f_7					"{FFFF00}" // желтый
#define f_8					"{FFD700}" // золотой
#define f_9					"{EE82EE}" // фиолетовый
#define f_10				"{800080}" // темно-фиолетовый
#define f_11				"{808080}" // серый
#define f_12				"{C0C0C0}" // серебристый
#define f_13				"{00FF00}" // лайм
#define f_14				"{008000}" // зеленый
#define f_15				"{228B22}" // лесной
#define f_16				"{1E90FF}" // синий
#define f_17				"{00BFFF}" // цвет неба

#define Send            SendClientMessage
#define SCM 											SendClientMessage
#define f( 				format(string, sizeof(string),
#define DIALOG_ID_EDITACS_SELECT 10000
#define DIALOG_ID_EDITACS_EDIT 10001
#define DIALOG_ID_EDITACS_INPUT 10002
#define DIALOG_ID_EDITACS_SELECT_AXIS   (DIALOG_ID_EDITACS_INPUT + 1)
#define DIALOG_ID_EDITACS_MOVE_OPTIONS  (DIALOG_ID_EDITACS_SELECT_AXIS + 1)
#define DIALOG_ID_INV11_ACC_CUSTOMIZE 10005
#define INVENTORY11_MAX_WEIGHT_KG 100
#define INVENTORY11_BASE_SLOTS 26
#define INVENTORY11_MAX_SLOTS 64
#define INVENTORY11_MAX_ACTIVE_ACCESSORIES 4

new const Inventory11AccessoryAddWeightByModel[][2] =
{
    { 791, 30 },
    { 907, 50 },
    { 908, 30 },
    { 909, 30 },
    { 911, 15 },
    { 912, 15 },
    { 913, 15 },
    { 916, 50 },
    { 918, 30 },
    { 920, 15 },
    { 926, 50 },
    { 984, 10 },
    { 987, 10 },
    { 988, 10 },
    { 989, 10 },
    { 992, 10 },
    { 993, 10 },
    { 1197, 30 },
    { 1198, 30 },
    { 1199, 30 },
    { 1379, 50 },
    { 1389, 50 },
    { 1651, 30 },
    { 3153, 30 },
    { 4199, 30 },
    { 4200, 30 },
    { 4203, 30 },
    { 4204, 30 },
    { 4359, 30 },
    { 4372, 30 },
    { 4549, 30 },
    { 4785, 30 },
    { 4789, 30 },
    { 4793, 30 },
    { 4795, 30 },
    { 4862, 20 },
    { 4864, 30 },
    { 6102, 30 },
    { 6171, 30 },
    { 6179, 20 },
    { 6180, 20 },
    { 7712, 30 },
    { 9387, 50 },
    { 9388, 20 },
    { 9796, 50 },
    { 9797, 50 },
    { 9798, 50 },
    { 9799, 50 },
    { 9800, 50 },
    { 9801, 50 },
    { 9825, 50 },
    { 9828, 50 },
    { 10488, 30 },
    { 10494, 30 },
    { 11328, 30 },
    { 11924, 50 },
    { 13735, 30 },
    { 13737, 30 },
    { 13738, 30 },
    { 13739, 30 },
    { 13740, 30 },
    { 13741, 30 },
    { 13742, 30 },
    { 13745, 30 },
    { 13746, 30 },
    { 13747, 30 },
    { 13750, 30 },
    { 13751, 30 },
    { 13755, 30 },
    { 13761, 30 },
    { 13803, 50 },
    { 13806, 50 },
    { 13809, 50 },
    { 13810, 50 },
    { 13897, 50 },
    { 14630, 30 },
    { 14643, 30 },
    { 14647, 30 },
    { 15055, 30 },
    { 15057, 30 },
    { 15134, 15 },
    { 15157, 50 },
    { 15626, 30 },
    { 15628, 30 },
    { 15634, 30 },
    { 16026, 30 },
    { 16028, 30 },
    { 16035, 30 },
    { 16045, 30 },
    { 16699, 30 },
    { 17509, 30 },
    { 18378, 50 },
    { 18379, 50 },
    { 18405, 50 },
    { 18406, 50 },
    { 18511, 10 },
    { 31961, 30 },
    { 31962, 30 },
    { 32129, 30 },
    { 32134, 30 },
    { 32138, 30 },
    { 32405, 30 },
    { 32416, 30 },
    { 32419, 30 },
    { 32421, 30 },
    { 100034, 30 },
    { 100067, 30 },
    { 100070, 30 },
    { 100073, 30 },
    { 100060, 30 },
    { 100077, 30 },
    { 100078, 30 },
    { 100079, 30 },
    { 100104, 30 },
    { 100109, 30 },
    { 100111, 30 },
    { 100112, 30 },
    { 100165, 30 },
    { 100169, 30 },
    { 100170, 30 }
};


new Float:gPlayerTempAccData[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][11];

new VehicleColoursTableRGBA[128] = {
// The existing colours from San Andreas
	0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
	0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
	0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
	0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
	0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
	0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
	0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
	0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
	0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
	0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
	0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
	0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
	0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF
};

// ------------------------------------------
stock GetVehicleRGBAColorById(colorid)
{
    if(0 <= colorid < sizeof(VehicleColoursTableRGBA))
    {
        return VehicleColoursTableRGBA[colorid];
    }
    return VehicleColoursTableRGBA[1];
}
stock Float: GetAngleToPoint(Float:x1, Float:y1, Float:x2, Float:y2)
{
	return atan2(y1-y2, x1-x2)-90.0;
}

stock SendReport(playerid, const message[])
{
	new rep_id = g_report_created;

	if (g_report_created >= MAX_REPORTS) return 1;

	SetReportData(rep_id, REP_CREATOR, 	playerid);
	SetReportData(rep_id, REP_EDIT, 		false);

	format(g_report[rep_id][REP_TEXT], 128, message);

	g_report_created ++;

	return 1;
}

stock DeleteReport(rep_id)
{
	if(!(0 <= rep_id <= g_report_created - 1)) return 0;

	SetReportData(rep_id, REP_CREATOR, 	INVALID_PLAYER_ID);
	SetReportData(rep_id, REP_EDIT, 		false);

	format(g_report[rep_id][REP_TEXT], 128, "");

	if(rep_id == g_report_created - 1 && rep_id != 0)
		g_report_created --;

	return 1;
}

stock GetReportId(rep_id)
{
	new index;

	for(new idx = g_report_created - 1; idx >= 0; idx --)
	{
		if(GetReportData(idx, REP_EDIT) || GetReportData(idx, REP_CREATOR) == INVALID_PLAYER_ID) continue;

		index ++;

		if(idx != rep_id) continue;
	}

	return index;
}

stock UpdateReportText()
{
	new count,
		fmt_text[15];

	for(new idx = g_report_created - 1; idx >= 0; idx --)
	{
		if(GetReportData(idx, REP_EDIT) || GetReportData(idx, REP_CREATOR) == INVALID_PLAYER_ID) continue;

		count ++;
	}
    if(g_report_created)
	{
		format(fmt_text, sizeof fmt_text, "REP: 1+");

		TextDrawSetString(report_edit_TD, fmt_text);
	}
}

stock UpdateReportText1()
{

    new count,
		fmt_text[15];

	for(new idx = g_report_created - 1; idx >= 0; idx --)
	{
		if(GetReportData(idx, REP_EDIT) || GetReportData(idx, REP_CREATOR) == INVALID_PLAYER_ID) continue;

		count ++;
	}
	if(!g_report_created)
	{

		format(fmt_text, sizeof fmt_text, "REP: 0");

		TextDrawSetString(report_edit_TD, fmt_text);
	}

}




// ------------------------------------------
stock Float: GetVehicleSpeed(vehicleid)
{
	new Float: speed = -1;

	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new Float: x,
			Float: y,
			Float: z,
			Float: angle;

		GetVehicleVelocity(vehicleid, x, y, z);
		GetVehicleZAngle(vehicleid, angle);

		speed = x / floatsin(-angle, degrees);

		speed *= 100.0;
	}

	return speed;
}


enum e_QM_DATA
{
	line[128]
}
new quick_mes[MAX_PLAYERS][MAX_BIND][e_QM_DATA];

// GLOBAL STRING


new sctring[256], stringer[2000];


new Float:pos[MAX_PLAYERS][3];


// ------------------------------------------
enum
{
	CMD_SETLEADER,
	CMD_SETADMIN,
	CMD_VEH,
	CMD_AWARN,
	CMD_AUNWARN,
	CMD_BANIP,
	CMD_NUM
};
// ------------------------------------------
enum E_PLAYER_STRUCT // структура игрока
{
	P_ACCOUNT_ID, 	// ид аккаунта
	P_REFER,		// рефер
	P_SEX,			// пол игрока
	P_SALT[11],		// Соль
	P_PASSWORD[65], // пароль игрока
	P_EMAIL[60 + 1],// емайл игрока
	bool: P_CONFIRM_EMAIL,// подтвержден ли емайл
	P_SKIN,			// скин игрока
	P_MONEY,		// деньги игрока
	P_BANK,			// деньги в банке
	P_ADMIN,		// уровень админки
	P_DRIVING_LIC,	// лицензия на управление авто
	P_WEAPON_LIC,	// лицензия на оружие
	P_REG_TIME,		// время регистрации
	P_REG_IP[16],	// ип при регистрации
	P_LAST_IP[16],	// ип при последнем входе
	P_LEVEL,		// уровень игрока
	P_EXP,			// очки опыта игрока
	P_SUSPECT,		// уровень розыска
	P_SALE_TIME,
	P_PHONE,		// номер телефона
	P_PHONE_BALANCE,// на счету телефона
	P_PHONE_COLOR,	// цвет телефона
	P_LAW_ABIDING,	// законопослушность
	P_IMPROVEMENTS, // улучшения
	P_DRUGS,		// наркотики
	P_AMMO,			// патроны
	P_METALL,		// Материалы
	P_WIFE,			// жена
	P_TEAM,			// организация
	P_OSKIN,		// скин организации
	P_SUBDIVISON,	// подразделение
	P_WAGE,			// зарплата
	P_JOB,			// работа / должность(ранг)
	P_HOUSE_TYPE,	// тип жилья (дом/отель/в гостях)
	P_HOUSE_ROOM,	// комната в доме
	P_HOUSE,		// дом
	P_BUSINESS,		// бизнес
	P_CASINO_JOB,		// должность в казино: 0 - нет, 1 - крупье, 2 - менеджер
	P_CASINO_BUSINESS,	// ID казино, в котором работает игрок
	P_FUEL_ST,	 	// заправка
	P_SETTING_PHONE[13],// реальный телефон игрока
	P_SETTING_PIN[5], 	// пин код
	P_REQUEST_PHONE,	// запрос телефона при авторизации
	P_REQUEST_PIN,		// запрос пин кода при авторизации
	// -------------------------
	P_LAST_LOGIN_TIME,	// время последнего входа\выхода
	// -------------------------
	P_GAME_FOR_HOUR,	// время игры за час
	P_GAME_FOR_DAY,		// время игры за день
	P_GAME_FOR_DAY_PREV,// время игры за вчерашний день
	// -------------------------
	P_COLOR,		// цвет игрока
	P_SELECT_SKIN, 	// выбраный скин
	P_CHAT_TYPE,	// тип чата
	P_AFK_TIME,		// время афк
	P_LAST_VEHICLE,	// ид последнего авто в котором сидел
	P_LAST_DIALOG,	// ид последнего диалога
	P_USE_ANIM_TYPE,// тип анимки который использует
	P_PASS_ATTEMPS, // кол-во попыток на авторизацию
	P_TARGET_ID,	// нацелен на игрока
	Float: P_HEALTH,// хп игрока
	// -------------------------
	P_TEMP_JOB,				// временная работа
	P_TEMP_JOB_STATE,		// действие что надо делать
	P_TEMP_JOB_CHECK,		// проверка анимки
	// -------------------------
	P_JOB_SERVICE_NAME[17],	// название службы
	P_JOB_TARIFF,			// тариф
	P_JOB_WAGE,				// Зарплата
	P_JOB_LOAD_ITEMS,		// загружено/перенесено (груза/руды)
	P_JOB_CAR,				// рабочий транспорт
	P_END_JOB_TIMER,		// таймер окончания работы
	P_FACTORY_USE_DESK,		// Какой стол использует на заводе
	P_BUS_ROUTE, 			// маршрут автобуса
	P_BUS_ROUTE_STEP,		// шаг маршрута
	P_MECHANIC_FILL_PAY,	// заправлено на N руб
	P_MECHANIC_REPAIR_PAY,	// отремонтировано на N руб
	bool: P_IN_JOB,			// на работе ли
	// -------------------------
	bool: P_LOGGED,				// статус авторизации
	bool: P_USE_ANIM,			// использует ли анимку (/anim)
	bool: P_BLOCK_LEAVE_AREA, 	// заблокировать вызов OnPlayerLeaveDynamicArea
	bool: P_ANIMS_INIT,			// прогружены ли анимки при спавне
	bool: P_ANIM_LIST_INIT,		// прогружен ли анимлист
	bool: P_SNACK,				// есть ли у игрока закуска
	Text3D: P_ADVISOR_LABEL,	// бейджик советника
	Text3D: P_ADMIN_LABEL,	// АДМИН ПРЕФИКС
	bool: P_ADVISOR_BLOCK_CHAT,	// отключение чата организации
	// -------------------------
	P_AUTH_TIME,		// время на авторизаци
	P_IN_BUSINESS,		// в какой бизнес вошел
	P_IN_HOUSE,			// в какой дом вошел
	P_IN_ENTRANCE,		// в каком подъезде
	P_IN_ENTRANCE_FLOOR,// на каком этаже в подъезде
	P_LAST_PICKUP,		// ид пикапа на которым стоял последний раз
	P_IN_HOTEL_ROOM,	// в каком номере в отеле
	P_IN_HOTEL_FLOOR,	// на каком этаже в отеле
	P_MED_CHEST,		// аптечка
	P_MASK,				// маска
	P_LOTTERY,			// лотерейный билет
	P_DRINK_STEP,		// кол-во использование напитка
	P_REALTOR_TYPE,		// риелторка
	P_USE_SELECT_PANEL,	// использует ли панель выбора
	P_OWNABLE_CAR,		// ид личного ТС
	P_USE_TRUNK,		// ид авто используемого багажника
	// -------------------------
	P_IP[16], 			// ип игрока
	P_NAME[20 + 1], 	// имя игрока
	P_WIFE_NAME[21],	// имя жены
	// -------------------------
	P_ACCOUNT_STATE, 		// статус аккаунта (авторизаци/регистрация)
	P_ACCOUNT_STEP_STATE, 	// шаг (регистрации/авторизации)
	// -------------------------
	P_WARN,             // варны
	P_WARN_TIME,        // время варнов
	P_MUTE,             // время мута
	// -------------------------
	P_POWER,			// сила
	P_SKILL_COLT,     	// скилл кольт
	P_SKILL_SDPISTOL,   // скилл пистолет с глушителем
	P_SKILL_DEAGLE,     // скилл дигл
	P_SKILL_SHOTGUN,    // скилл дробовик
	P_SKILL_MP5,        // скилл мп5
	P_SKILL_AK47,	    // скилл ак47
	P_SKILL_M4,         // скилл м4
	P_SKILL_SNIPER_RIFLE,	// скилл снайперская винтовка
	P_SKILL_SAWNOFF,    // скилл обрез
	P_SKILL_COMBAT_SG,  // скилл тактический дробовик
 	P_SKILL_MICRO_UZI,  // скилл микро-узи
 	// -------------------------
 	P_SPAWN,            // место спавна
 	// -------------------------
 	P_DONATE_RUB,	// Текущий баланс донат-рублей
	P_DONATE_MONEY,	// текущий баланс донат-очков
	P_DONATE_TOTAL,		// всего приобретено донат-очков
	// -------------------------
	bool: P_HOSPITAL,	// лежит ли в больнице
	P_OCCUPIED_BED,		// номер койки
	// -------------------------
	bool: P_WEAPON_RELOADING,	// перезаряжает ли оружие
	P_RELOADINGS_COUNT[11],		// количество перезарядок для каждого оружия
	bool: P_CUFFED,		// наручники на игроке
	// -------------------------
	P_BUY_CAR,			// покупает ли авто
	P_RENT_CAR,			// арендованная машина
	P_ALLOWED_CAR,		// доверенная машина
	P_CAR_SLOTS,		// количество слотов для авто
	
	// -------------------------
	P_JAIL,				// время заключения
	P_JAILFSIN,			// отдельный срок заключения ФСИН
	// -------------------------
//	P_WEAPON_TINT[MAX_WEAPON_TINTS], // раскраски оружия
	P_PREMIUM,			// уровень премиум аккаунта
	P_PREMIUM_DATE,
	P_PREMIUM_CHAT,
	// -------------------------
	P_ORDER,			// выполняет ли заказ
	// -------------------------
	P_PREMIUM_TIME,		// время действия премиум аккаунта
	//
	P_LOADER_SKILL,
	P_LAST_MP,              // мероприятие
	P_PREFIX[32], 				// prefix админ
	P_VIP_STATUS,
	// ----------------------------
	P_APASS,			// Админ авторизация
	P_ADMIN_LOGGED,			// Админ авторизация
	P_ADMIN_WARN,			// Варн администрации
	P_ADMIN_NICK_COLOR,		// Выбранный цвет ника (0 = по умолчанию)
	P_ADMIN_NICK_RAINBOW,		// 1 = включен переливающийся RGB ник
	P_SECRET,               //скрытность
	P_3D_PREFIX,            //3d префикс на персонаже
	// ----------------------------
	P_PLAY_PLAYER,
	// -----------------------------
	P_FAMILY,           // Семья
    P_FAMILY_RANK,      // Ранг в семье
    P_FAMILY_NAME,    // Имя семьи
    // -----------------------------
   	P_GIFTS,                // подковы
   	// ------------------------------
   	P_RENT_BIKE,        // Аренда велосипеда
   	// ------------------------------
   	CMD_ACCESS[CMD_NUM+1],
   	//
   	P_TEST,
   	//
    P_QUEST_1,
    P_QUEST_2,
    P_QUEST_3,
    P_QUEST_4,
    P_QUEST_5,
    P_QUEST_6,
    P_QUEST_7,
    P_QUEST_8,
    P_QUEST_9,
    P_QUEST_10,
    P_QUEST_11,
    P_QUEST_12,
    P_QUEST_13,
    P_QUEST_14,
    P_QUEST_15,

    P_QUEST_EXP_1,
    P_QUEST_EXP_2,
    P_QUEST_EXP_3,
    P_QUEST_EXP_4,
    P_QUEST_EXP_5,
    P_QUEST_EXP_6,
    P_QUEST_EXP_7,
    P_QUEST_EXP_8,
    P_QUEST_EXP_9,
    P_QUEST_EXP_10,
    P_QUEST_EXP_11,
    P_QUEST_EXP_12,
    P_QUEST_EXP_13,
    P_QUEST_EXP_14,
    P_QUEST_EXP_15,
	//
	P_UNJ,
	//
	P_YOUTUBE,
	//
	P_BANIHOP,
	//
	P_ADMIN_STATUS,
	P_ADMIN_HOUR,
	P_GET_RUB,
    P_TARGET_PLAYER_ID,

	//
	P_HELPER,
	P_FRACTION_CAR,
	P_PICKUP_TIME,
	P_ANTISLIV,
	P_TOTALHOUR,
	P_BOXQUEST,
	P_QUEST231,
	P_QUEST232,
	P_REPCARID,
	P_QUEST233,
	P_POSTCARD,
	P_BOX_QUEST_1,
	P_BOX_QUEST_2,
	P_BOX_QUEST_3,
	P_BOX_QUEST_4,
	P_BOX_QUEST_5,
	P_BOX_QUEST_6,
	
	P_VERIFICATION,
	
	P_FMUTE,
	P_FWARN,
	P_OWARN,
	
	P_DMZ_STATUS,
	P_DMZ_KILL,
	P_DMZ_KILL1,
	
	P_ACOINS,
	
	P_PROGRESS_EXP_1,
	P_PROGRESS_EXP_2,
	P_PROGRESS_EXP_3,
	P_PROGRESS_EXP_4,
	P_PROGRESS_EXP_5,
	P_PROGRESS_EXP_6,
	P_PROGRESS_1,
	P_PROGRESS_2,
	P_PROGRESS_3,
	P_PROGRESS_4,
	P_PROGRESS_5,
	P_PROGRESS_6,
	
	P_CAPT_KILL,
	
	P_AFREASON,
	
	P_MEDKA,
	
	P_DONATE_CASE,
	
	P_COINS,
	P_MONETI,
	P_FAMILY_NOTIF_SEEN,
	P_FAMILY_NOTIF_SEEN_FAMILY,
	
	P_YTPROMO_ACTIVATE,
	
	P_F_QUEST_EXP_1,
	P_F_QUEST_EXP_2,
	P_F_QUEST_EXP_3,
	P_F_QUEST_EXP_4,
	P_F_QUEST_EXP_5,
	
	P_F_QUEST_1,
	P_F_QUEST_2,
	P_F_QUEST_3,
	P_F_QUEST_4,
	P_F_QUEST_5,
	
	P_TOP_1,
	P_TOP_2,
	P_TOP_3,
	P_TOP_4,
	P_TOP_5,
	
	P_BOOMBOX,
	
	P_AUTOSALON_COLOR1,
	P_AUTOSALON_COLOR2,
	
	P_CARREGION_ENTER,
	P_CARNUMBER_ENTER,
	P_CARNUMBER_REGION,
	
	P_SPEEDOMETR,
	P_OHFAM,
	P_OHZAVOD,
	P_OHARZ,
	P_OHKAR,
	P_OHBUS,
	P_ONLINE_TODAY,
	P_LAST_TUNING,
	P_HOUSE_SLOTS,
	P_HOUSE_SELECTED,
	P_BUSS_SLOTS,
	P_TC_COMPANY_ID,
	P_TC_RATING,
};

enum E_GIFT_STRUCT
{
	G_SQL_ID,
	Float: G_POS_X,
	Float: G_POS_Y,
	Float: G_POS_Z
}

new g_gift[MAX_GIFT][E_GIFT_STRUCT];
new g_gift_loaded;

new CheckPass[MAX_PLAYERS][65];

// GUI 38 workflow only; IsPlayerLogged remains the game's source of truth.
enum E_BR_AUTH_STAGE { BR_AUTH_CHECK, BR_AUTH_PASSWORD, BR_AUTH_SEX, BR_AUTH_SKIN, BR_AUTH_LOGIN, BR_AUTH_LOADING, BR_AUTH_DONE, BR_AUTH_BLOCKED }
new E_BR_AUTH_STAGE:g_BRAuthStage[MAX_PLAYERS];
new bool:g_BRAuthVerified[MAX_PLAYERS];
new bool:g_BRAuthNewAccount[MAX_PLAYERS];
new g_BRAuthPreview[MAX_PLAYERS];
new g_BRAuthEpoch[MAX_PLAYERS];

// ------------------------------------------
enum
{
	PROMO_TYPE_MONEY = 0, 	// деньги
	PROMO_TYPE_DONATE,		// донат
	PROMO_TYPE_EXP,			// опыт
}

enum E_PROMO_STRUCT
{
	E_PLAYER_STRUCT: P_DATA,
	P_SQL_NAME[16],
	P_NAME[17]
}

new promo_info[4][E_PROMO_STRUCT] =
{
	{P_BANK, "bank", "Деньги"},
	{P_DONATE_MONEY, "donate_current", "Донат-Монеты"},
	{P_DONATE_RUB, "rub", "Донат-Рубли"},
	{P_EXP, "exp", "Exp"}
};

enum E_COMMAND_TIMER
{
    report,
    adm_nakaz,
	vipad,
}

new use_commad_time[MAX_PLAYERS][E_COMMAND_TIMER];

#define MAX_PERFORMANCE_ITEMS

new engine_ptune[MAX_PERFORMANCE_ITEMS][] =
{
	"Чип-тюнинг",
	"Удаление катализаторов",
	"Воздушный фильтр нулевого сопротивления",
	"Дроссельная заслонка увеличенного диаметра",
	"Кованые поршни двигателя"
};

new engine_ptune_price[MAX_PERFORMANCE_ITEMS] = {150000, 100000, 70000, 120000, 140000};
new Float:engine_ptune_boost[MAX_PERFORMANCE_ITEMS] = {0.15, 0.08, 0.08, 0.08, 0.10};

new brake_ptune[MAX_PERFORMANCE_ITEMS][] =
{
	"Керамические колодки",
	"Спортивные тормозные диски",
	"Расширенные суппорта",
	"Тормозной цилиндр",
	"Вакуумный усилитель тормозов"
};
new brake_ptune_price[MAX_PERFORMANCE_ITEMS] = {90000, 100000, 70000, 120000, 140000};
new Float:brake_ptune_boost[MAX_PERFORMANCE_ITEMS] = {2.5, 2.5, 2.0, 3.0, 3.5};

new stability_ptune[MAX_PERFORMANCE_ITEMS][] =
{
	"Распорки на стойки",
	"Амортизаторы",
	"Усиленные пружины",
	"Стабилизаторы поперечной устойчивости",
	"Шарниры подвески"
};

new stability_ptune_price[MAX_PERFORMANCE_ITEMS] = {25000, 70000, 50000, 80000, 65000};

// ------------------------------------------
enum
{
	STORAGE_METALL = 0, // максимальное кол-во Материалыа
	STORAGE_AMMO, // максимальное кол-во патронов
	STORAGE_DRUGS // максимальное кол-во наркотиков
}

// ------------------------------------------
enum PInfo
{
    pHelper,
}

// ------------------------------------------
enum E_OWNABLE_CAR_STRUCT
{
	OC_SQL_ID, 			// ид в базе
	OC_OWNER_ID,		// ид владельца
	OC_OWNER_NAME[21],	// имя владельца
	OC_NUMBER[32],		// номер ТС
	OC_MODEL_ID,		// модель
	OC_COLOR_1,			// цвет 1
	OC_COLOR_2,			// цвет 2
	Float: OC_POS_X,	// позиции ТС
	Float: OC_POS_Y,	// позиции ТС
	Float: OC_POS_Z,	// позиции ТС
	Float: OC_ANGLE,	// позиции ТС (угол поворота)
	bool: OC_ALARM,		// сигнализация
	bool: OC_KEY_IN,	// вставлен ли ключ
	OC_CREATE,	// время создания
	OC_VINILCAR,	// время создания
	OC_PT_ENGINE,       // performance tuning двигатель
	OC_PT_BRAKE,       	// performance tuning тормоза
	OC_PT_STABILITY,    // performance tuning устойчивость
	OC_LAST_PRICE,      // последняя цена на авторынке АВТОРЫНОК
	OC_LAST_OWNER_GAME_ID,      // последнее айди владельца авто АВТОРЫНОК
	OC_PROMO_STATUS_CAR, // 1 если авто выдано по промокоду, 0 если обычное
    OC_PROMO_ID,     // ID промокода, по которому выдано авто
	OC_COMFORT_PL,
	OC_vinil_current,
	OC_exhsuast_current,
	OC_strab_current,
	OC_EnableNeon,
	OC_horn_current,
    // --- Новые слоты ---
    OC_COMFORT1, OC_SPORT1, OC_DRIFT1, OC_SPORT_PL1,
    OC_COMFORT2, OC_SPORT2, OC_DRIFT2, OC_SPORT_PL2,
    OC_COMFORT3, OC_SPORT3, OC_DRIFT3, OC_SPORT_PL3,
    OC_COMFORT4, OC_SPORT4, OC_DRIFT4, OC_SPORT_PL4,
	OC_SPORT,
	OC_SPORT_PL,
	OC_DRIFT,
    OC_HIGHLIGHT,
    OC_STROBOSCOPE,
    OC_EXHAUST,
    OC_HORN,
    OC_HYDRAULICS,
    OC_BRAKE,
    OC_VINYL[32],
	OC_vynil_name,
    OC_LAUCH, 		
    OC_NITRO, 	
	OC_isHydroActive,
	OC_isHydroBought,
	OC_isFarLightBought,
	OC_isFarLightActive,
	OC_isPnevmoBought,
	OC_PnevmoSelected,
	OC_PDVRADAR,
	OC_ISCASE,
	OC_percentofclirness,
	OC_percentofclirnessZ,
	OC_wheel_offset_ft,
	OC_wheel_offset_rr,
	OC_align_ft,
	OC_align_rr,
	OC_width_ft,
	OC_width_rr,
	OC_wheel_radius,
	OC_wheelcolors,
	OC_lights_color,   
    OC_underlights_color, 
    OC_underlights_color_lf,  
    OC_underlights_color_rt,
	OC_body_colors,
	OC_tonir_ft,
	OC_tonir_rr,
	OC_wheelcomp,
	OC_FSTATE,	
    OC_SUPERCHARGER, 
    OC_PT_TURBO, 
    OC_COLOR_BODY_R,
    OC_COLOR_BODY_G,
    OC_COLOR_WHEELS,
    OC_TONER_FRONT, 
    OC_TONER_REAR, 
    OC_LIGHT_COLOR, 
    OC_NEON_CENTER, 
    OC_NEON_LEFT, 	
    OC_NEON_RIGHT, 	

};

enum E_FAMILY_CAR_STRUCT
{
    F_CAR_ID,           // Ид авто
    F_SQL_ID,          // ид в базе
    F_OWNER_ID,        // ид владельца
    F_OWNER_NAME[21],  // имя владельца
    F_MODEL_ID,        // модель
    F_COLOR_1,         // цвет 1
    F_COLOR_2,         // цвет 2
    F_RANG,             // С какого ранга
    Float: F_POS_X,    // позиции ТС
    Float: F_POS_Y,    // позиции ТС
    Float: F_POS_Z,    // позиции ТС
    Float: F_ANGLE,    // позиции ТС (угол поворота)
    F_World,
	F_Int,
    bool: OC_KEY_IN,    // вставлен ли ключ
    OC_CREATE,          // время создания
    Float: OC_FUEL      // топливо
};

new g_family_car[MAX_OWNABLE_CARS][E_FAMILY_CAR_STRUCT];
new g_family_car_loaded;

// ------------------------------------------
enum E_VEHICLE_TRUNK_STRUCT
{
	VT_SQL_ID,
	VT_ITEM_TYPE, 		// тип предмета
	VT_ITEM_AMOUNT,		// кол-во
	VT_ITEM_VALUE
};

//========donate systems=======
new player_sale_time_timer[MAX_PLAYERS];
new player_update_promotions_timer[MAX_PLAYERS];


#define MAX_PLAYERS_PROMOTIONS 3

enum player_donate_data
{
	JSON:JSON_PROMOTIONS_ARRAY,
	ADDED_PROMOTIONS
};
new g_player_donate_data[MAX_PLAYERS][player_donate_data];
new g_player_added_promotions_data[1000][3][3];
new gPlayerPickupCooldowns[MAX_PLAYERS];
new gPlayerPickupCooldownsV[MAX_PLAYERS];
new car_game_ids[][2] = {
{5, 555},
{6, 549},
{7, 401},
{8, 479},
{9, 496},
{10, 404},
{11, 458},
{12, 585},
{13, 536},
{14, 529},
{15, 534},
{16, 542},
{17, 540},
{18, 559},
{19, 421},
{20, 2554},
{21, 2548},
{22, 419},
{23, 562},
{24, 507},
{25, 426},
{26, 516},
{27, 467},
{347, 2580},
{28, 527},
{29, 445},
{30, 589},
{31, 587},
{32, 436},
{33, 560},
{34, 550},
{348, 2584},
{35, 603},
{36, 2552},
{37, 565},
{38, 551},
{39, 526},
{40, 442},
{41, 489},
{42, 543},
{43, 480},
{44, 558},
{45, 495},
{46, 475},
{47, 503},
{48, 410},
{49, 402},
{50, 2553},
{51, 505},
{52, 2547},
{53, 502},
{54, 400},
{55, 604},
{56, 405},
{57, 506},
{58, 2550},
{59, 466},
{60, 2545},
{61, 490},
{62, 420},
{349, 2582},
{63, 533},
{64, 2546},
{65, 494},
{66, 429},
{67, 451},
{68, 2544},
{69, 2551},
{70, 2549},
{71, 579},
{351, 2578},
{72, 541},
{352, 2581},
{73, 411},
{350, 2579},
{74, 415},
{75, 2543},
{76, 462},
{77, 468},
{78, 461},
{79, 463},
{80, 523},
{81, 586},
{82, 521},
{83, 581},
{84, 522},
{85, 582},
{86, 529},
{87, 470},
{88, 416},
{89, 516},
{90, 466},
{201, 413},
{202, 418},
{195, 440},
{211, 2555},
{212, 2557},
{213, 2565},
{214, 2566},
{215, 2560},
{216, 2561},
{217, 2568},
{218, 2567},
{219, 2559},
{220, 2558},
{353, 2583},
{221, 2564},
{222, 2563},
{223, 2570},
{224, 2569},
{275, 2571},
{276, 2572},
{327, 2574},
{328, 2575},
{329, 2573},
{330, 2577},
{331, 2576},
{366, 2586},
{367, 2585},
{400, 412},
{401, 439},
{402, 492},
{403, 547},
{404, 491},
{405, 546},
{406, 2589},
{407, 2588},
{408, 2587},
{409, 483},
{410, 2590},
{411, 2591},
{413, 452},
{414, 453},
{415, 454},
{416, 472},
{417, 473},
{418, 493},
{424, 2592},
{426, 2594},
{427, 2596},
{428, 2595},
{429, 2593},
{444, 2597},
{445, 2598},
{446, 2599},
{447, 2600},
{448, 2601},
{449, 2602},
{450, 2603},
{451, 2604},
{452, 2607},
{453, 2608},
{454, 2609},
{455, 2610},
{456, 2611},
{459, 448},
{460, 2616},
{461, 2617},
{465, 2618},
{466, 2619},
{467, 2620},
{468, 2621},
{469, 2622},
{470, 2623},
{471, 2624},
{472, 2625},
{473, 2626},
{474, 2627},
{484, 434},
{485, 2377},
{498, 2380},
{499, 2381},
{500, 2385},
{501, 2386},
{502, 2387},
{503, 2388},
{504, 2389},
{505, 2390},
{506, 2391},
{507, 2392},
{508, 2393},
{509, 2394},
{510, 2382},
{511, 2383},
{512, 2384},
{522, 614},
{523, 613},
{524, 622},
{543, 762},
{544, 763},
{545, 760},
{546, 759},
{547, 761},
{551, 28669},
{552, 28670},
{553, 28671},
{554, 28672},
{555, 28689},
{556, 28693},
{557, 28694},
{558, 28695},
{559, 28696},
{560, 28697}
};

new clothes_game_ids[][2] = {
    {475, 11917},
    {462, 12293},
    {463, 12291},
    {457, 14386},
    {458, 14388},
    {419, 5323},
    {430, 5326},
    {431, 5325},
    {425, 5362},
    {420, 5367},
    {421, 5365},
    {399, 18606},
    {390, 310},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {395, 18624},
    {396, 18625},
    {397, 18626},
    {398, 18628},
    {346, 2},
    {344, 302},
    {345, 301},
    {332, 196},
    {333, 129},
    {334, 130},
    {335, 24},
    {340, 197},
    {336, 245},
    {337, 243},
    {338, 89},
    {339, 88},
    {341, 10},
    {342, 92},
    {343, 99},
    {315, 110},
    {313, 108},
    {311, 95},
    {322, 49},
    {323, 53},
    {324, 160},
    {314, 109},
    {312, 106},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {325, 162},
    {326, 210},
    {238, 65},
    {257, 209},
    {239, 39},
    {240, 207},
    {225, 86},
    {226, 224},
    {227, 232},
    {228, 269},
    {205, 252},
    {206, 236},
    {207, 48},
    {208, 63},
    {91, 23},
    {92, 22},
    {229, 231},
    {93, 220},
    {94, 225},
    {230, 175},
    {95, 202},
    {96, 204},
    {97, 229},
    {203, 57},
    {231, 208},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {236, 298},
    {237, 266},
    {209, 270},
    {210, 122}
};
//========the end donate systems=======

