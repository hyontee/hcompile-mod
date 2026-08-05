// *************************************

// *******************************************

#define COLOR_YELLOW       0xFFFF00AA

#define MAX_GOV_ORG 8
#define START_MAX_GANG 9

#define REPORT_STATUS_NONE			0
#define REPORT_STATUS_ANSWERED		1
#define REPORT_STATUS_SKIPPED		2
#define REPORT_STATUS_DISCONNECT	3

#define TABLE_REPORTS				"reports_list"

// ******************************************

#define neondialog 8131

#define MAX_FLOOD_RATE	(3000)
#define FLOOD_RATE_INC	(1000)
#define FLOOD_RATE_KICK	(5000)

#define RAND_WEATHER				// система рандомной погоды
#define ATM_CREATED_PICKUP			// создавать ли пикапы для банкоматов
#define FUEL_ST_CREATED_PICKUP		// создавать ли пикапы для азс

#define ENTER_PASSWORD_ATTEMPS 	(3)  // кол-во попыток на ввод пароля
#define REFER_BONUS_MONEY	(70_000) // бонус выдача денег реферу

#define MAX_FAMILY              (300) // максимальное кол-во семей
#define MAX_GIFT                (100) // максимальное кол-во подарков

#define MAX_AFK_TIME 			(120) // максимальное время афк (в минутах)
#define MAX_BANK_ACCOUNTS 		(5)	 // максимальное кол счетов в банке
#define MAX_PHONE_BOOK_CONTACTS (20) // макс. кол-во контактов для телефонной книги
#define MAX_AUTHORIZATION_TIME	(90) // время на авторизацию (в секундах)
#define MAX_FUEL_STATIONS		(18) // максимальное кол-во заправок
#define MAX_BUSINESS			(200)// максимальное кол-во предприятий
#define MAX_BUSINESS_GPS		(50) // максимальное кол-во предприятий в GPS
#define MAX_HOUSES				(900)// максимальное кол-во домов
#define MAX_HOUSE_ROOMS			(5)	 // максимальное кол-во комнат в доме
#define MAX_GATES				(1)	 // максимальное кол-во шлагбаум/ворот
#define MAX_ENTRANCES			(200) // максимальное кол-во подъездов
#define MAX_ENTRANCE_FLOORS		(5)	 // максимальное кол-во этажей в подъезде
#define MAX_HOTELS 				(3)	 // максимальное кол-во отелей
#define MAX_HOTEL_FLOORS 		(7)  // максимальное кол-во этажей отеля
#define MAX_HOTEL_ROOMS 		(MAX_HOTEL_FLOORS * 12) // максимальное кол-во номеров в отеле
#define MAX_OWNABLE_CARS		(1500)// максимальное кол-во личных ТС
#define MAX_VEHICLE_TRUNK_SLOTS	(8)	 // максимальное кол-во слотов багажника
#define MAX_GANG_REPOSITORIES	(3)  // максимальное кол-во складов для банд
#define MAX_GZ					(101)// максимальное кол-во ганг-зон
#define MAX_ADVERTS				(100)// максимальное кол-во объявлений
#define MAX_GREEN_ZONES			(13)	 // максимальное кол-во зеленых зон

#define MIN_PLAYERS_FOR_CAPTURE (1)	 // минимальное кол-во игроков для захвата территории

#define BIZ_HEALTH_SERVICE_PRICE (150)	// стоимость использование аптечки в бизнесе

#define ADVERT_SEND_PRICE		(250) // стоимость отправки объявления

#define MAP_ICON_STREAM_DISTANCE (100.0) // прорисовка иконок на карте (радиус)

#define MAX_ADMINS 14

#define MAX_BIND 20
#define DIALOG_QM 6565
#define DIALOG_EDIT_QM 6566
#define DIALOG_TEXT_QM 6567

// ******************************************

#define public:%0(%1) \
			forward %0(%1); \
				public %0(%1)

#define Kick:(%0) FixKick(%0)


#define RandomPrize   100000

#define HOLDING(%0) \
	((newkeys & (%0)) == (%0))

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define RELEASED(%0) \
	(((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define PRESSING(%0,%1) \
	(%0 & (%1))
	
#pragma warning disable 239
#pragma warning disable 214

// ******************************************

#define VEHICLE_COORD_TYPE_BOOT		(1)
#define VEHICLE_COORD_TYPE_BONNET	(2)

// ------------------------------------------

#define SELECT_PANEL_TYPE_NONE			0
#define SELECT_PANEL_TYPE_CLOTHING		1
#define SELECT_PANEL_TYPE_REG_SKIN		2
#define SELECT_PANEL_TYPE_CAR_MARKET 	3

// ------------------------------------------

#define PT_ITEM_TYPE_NONE   		(0)
#define PT_ITEM_TYPE_ENGINE     	(1)
#define PT_ITEM_TYPE_BRAKE     		(2)
#define PT_ITEM_TYPE_STABILITY     	(3)

// ------------------------------------------

#define GATE_STATUS_OPEN	true
#define GATE_STATUS_CLOSE	false

// ------------------------------------------

#define GPS_STATUS_ON	true
#define GPS_STATUS_OFF	false

// ------------------------------------------

#define ADMIN_TYPE_NONE 	0

// ------------------------------------------

#define CONVERT_TIME_TO_SECONDS 	1
#define CONVERT_TIME_TO_MINUTES 	2
#define CONVERT_TIME_TO_HOURS 		3
#define CONVERT_TIME_TO_DAYS 		4
#define CONVERT_TIME_TO_MONTHS 		5
#define CONVERT_TIME_TO_YEARS 		6

// ------------------------------------------

#define ACCOUNT_STATE_NONE 		0
#define ACCOUNT_STATE_REGISTER 	1
#define ACCOUNT_STATE_LOGIN 	2
#define ACCOUNT_STATE_REG_SKIN 	3

// ------------------------------------------

#define REQUEST_TYPE_OFF		-1
#define REQUEST_TYPE_SUBNET		1
#define REQUEST_TYPE_IP			2

// ------------------------------------------

#define PIN_CODE_STATE_NONE 	0
#define PIN_CODE_STATE_SET 		1 // установка пин кода
#define PIN_CODE_STATE_CHECK	2 // проверка пин кода
#define PIN_CODE_STATE_CHANGE	3 // смена пин кода
#define PIN_CODE_STATE_LOGIN_CHECK 4 // проверка пин кода при авторизации

// ------------------------------------------

#define HOUSE_TYPE_NONE		(-1) 	// нет
#define HOUSE_TYPE_HOME		(0) 	// дом
#define HOUSE_TYPE_ROOM		(1) 	// аренда комнаты
#define HOUSE_TYPE_HOTEL	(2) 	// отель

// ------------------------------------------

#define REALTOR_TYPE_NONE	(0)
#define REALTOR_TYPE_HOUSE	(1) // дом
#define REALTOR_TYPE_BIZ	(2) // биз

// ------------------------------------------

#define GetItemInfo(%0,%1) 		g_item_type[%0][%1]

// ------------------------------------------

#define GetTrunkData(%0,%1,%2) 			g_vehicle_trunk[%0][%1][%2]
#define SetTrunkData(%0,%1,%2,%3) 		g_vehicle_trunk[%0][%1][%2] = %3
#define AddTrunkData(%0,%1,%2,%3,%4) 	g_vehicle_trunk[%0][%1][%2] %3= %4

#define IsTrunkFreeSlot(%0,%1)			!GetTrunkData(%0, %1, VT_SQL_ID)
#define MAX_BIZ 150

// ------------------------------------------

#define GetOwnableCarData(%0,%1) 		g_ownable_car[%0][%1]
#define SetOwnableCarData(%0,%1,%2)		g_ownable_car[%0][%1] = %2
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

#define GetPlayerCurrentDonate(%0)      GetPlayerData(%0, P_DONATE_MONEY)     // текущий баланс BC Coins
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
#define GetServerRadioData(%0,%1)	g_server_radio[%0][%1]
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

#define GetPlayerAccountID(%0)	GetPlayerData(%0, pAccountID) 	// ид аккаунта
#define GetPlayerIpEx(%0)		GetPlayerData(%0, pIP) 			// ип игрока
#define GetPlayerNameEx(%0)		GetPlayerData(%0, pNickName) 			// имя игрока
#define GetPlayerColorEx(%0)	GetPlayerData(%0, P_COLOR)			// цвет игрока
#define GetPlayerSelectSkin(%0)	GetPlayerData(%0, P_SELECT_SKIN) 	// выбраный скин
#define GetPlayerLevel(%0)		GetPlayerData(%0, pLevel)			// уровень игрока
#define GetPlayerExp(%0)		GetPlayerData(%0, pExp)			// очки опыта игрока
#define GetPlayerSuspect(%0)	GetPlayerData(%0, pSuspect)		// уровень розыска игрока
#define GetExpToNextLevel(%0)	((GetPlayerData(%0, pLevel)+1)*4) 	// очков опыта к следуйщему уровню
#define GetPlayerPhone(%0)		GetPlayerData(%0, pPhone)			// номер телефона игрока
#define GetPlayerSex(%0)		GetPlayerData(%0, pSex)			// пол игрока
#define GetPlayerSexName(%0)	GetPlayerData(%0, pSex) ? ("Женский") : ("Мужской") // название пола
#define GetPlayerChatType(%0)	GetPlayerData(%0, P_CHAT_TYPE) 		// тип чата GetPlayerRepCar
#define GetPlayerRepCar(%0)	GetPlayerData(%0, P_REPCARID) 		// тип чата GetPlayerRepCar
#define	GetPlayerAdminEx(%0)	GetPlayerData(%0, pAdmin) 			// уровень админки
#define	GetPlayerWeaponLic(%0)	GetPlayerData(%0, pWeaponLic)
#define	GetPlayerHelperEx(%0)	GetPlayerData(%0, P_HELPER) 			// уровень хелперки
#define	GetPlayerSecretEx(%0)	GetPlayerData(%0, P_SECRET) 			// скрытность
#define GetPlayerMoneyEx(%0)	GetPlayerData(%0, pMoney) 			// деньги игрока
#define GetPlayerBankMoney(%0)	GetPlayerData(%0, pBank) 			// деньги игрока
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

//#define GetPlayerDonateRub(%0) 			GetPlayerData(%0, P_DONATE_RUB) 	// текущий баланс BC Coins

#define GetPlayerDonateMoney(%0) 		GetPlayerData(%0, P_DONATE_MONEY) 	// текущий баланс BC Coins
#define GetPlayerTotalDonate(%0) 		GetPlayerData(%0, P_DONATE_TOTAL) 	// всего пополнений баланса

#define GetPlayerInEntrance(%0)			GetPlayerData(%0, P_IN_ENTRANCE)		// в каком подъезде
#define GetPlayerInEntranceFloor(%0)	GetPlayerData(%0, P_IN_ENTRANCE_FLOOR)	// на каком этаже в подъезде

#define GetPlayerJobName(%0) 	job_name[GetPlayerData(%0, P_JOB)]

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

#define GetPlayerAdminWarn(%0)			GetPlayerData(%0, pAdmin_WARN)		// количество админ варнов

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
#define c_server            "{FF0000}"
#define c_s		            "{FF0000}"
#define c_b     	        "{FFFFFF}"
#define c_i		             "{32CD32}"
#define c_m		             "{009900}"
#define COR_RED             0xFF0000FF
#define c_red               "{FF0000}"

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

// **************************************

enum player_data// структура игрока
{
	pAccountID, 	// ид аккаунта
	pRefer,		// рефер
	pSex,			// пол игрока
	pSalt[11],		// Соль
	pPassword[65], // пароль игрока
	pEmail[60 + 1],// емайл игрока
	bool: pConfrimEmail,// подтвержден ли емайл
	pSkin,			// скин игрока
	pMoney,		// деньги игрока
	pBank,			// деньги в банке
	pAdmin,		// уровень админки
	pDrivingLic,	// лицензия на управление авто
	pWeaponLic,	// лицензия на оружие
	pRegTime,		// время регистрации
	pRegIP[16],	// ип при регистрации
	pLastIP[16],	// ип при последнем входе
	pLevel,		// уровень игрока
	pExp,			// очки опыта игрока
	pSuspect,		// уровень розыска
	pPhone,		// номер телефона
	pPhone_BALANCE,// на счету телефона
	pPhone_COLOR,	// цвет телефона
	pLawAbiding,	// законопослушность
	pImprovements, // улучшения
	pDrugs,		// наркотики
	pAmmo,			// патроны
	pMetall,		// металл
	pWife,			// жена
	P_TEAM,			// организация
	P_OSKIN,		// скин организации
	P_SUBDIVISON,	// подразделение
	P_WAGE,			// зарплата
	P_JOB,			// работа / должность(ранг)
	P_HOUSE_TYPE,	// тип жилья (дом/отель/в гостях)
	P_HOUSE_ROOM,	// комната в доме
	P_HOUSE,		// дом
	P_BUSINESS,		// бизнес
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
	Text3D: pAdmin_LABEL,	// АДМИН ПРЕФИКС
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
	pIP[16], 			// ип игрока
	pNickName[20 + 1], 	// имя игрока
	pWife_NAME[21],	// имя жены
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
// 	P_DONATE_RUB,	// Текущий баланс BC Coins
	P_DONATE_MONEY,	// текущий баланс BC Coins
	P_DONATE_TOTAL,		// всего приобретено BC Coins
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
	// ----------------------------
	P_APASS,			// Админ авторизация
	pAdmin_LOGGED,			// Админ авторизация
	pAdmin_WARN,			// Варн администрации
	P_SECRET,               //скрытность
	P_3D_PREFIX,            //3d префикс на персонаже
	// ----------------------------
	P_PLAY_PLAYER,
	// -----------------------------
	P_FAMILY,           // Семья
    P_FAMILY_RANK,      // Ранг в семье
    // -----------------------------
   	P_GIFTS,                // подковы
   	// ------------------------------
   	P_RENT_BIKE,        // Аренда велосипеда
   	// ------------------------------
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
	//
	P_QUEST_EXP_1,
	P_QUEST_EXP_2,
	P_QUEST_EXP_3,
	P_QUEST_EXP_4,
	P_QUEST_EXP_5,
	P_QUEST_EXP_6,
	P_QUEST_EXP_7,
	P_QUEST_EXP_8,
	//
	P_UNJ,
	//
	P_YOUTUBE,
	//
	P_BANIHOP,
	//
	pAdmin_STATUS,
	pAdmin_HOUR,
	P_GET_RUB,
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
	
	P_FMUTE,
	P_FWARN,
	P_OWARN,
	
	P_DMZ_STATUS,
	P_DMZ_KILL,
	P_DMZ_KILL1,
	
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
	
	P_DONATE_CASE,
	
	P_FLOWER_1,
	P_FLOWER_2,
	P_FLOWER_3,
	P_TAKE_FLOWER,
	P_CONGRATULATE_WOMEN,
	P_BUY_PERFUME,
	P_GIVE_PERFUME,
	P_BUY_CAKE,
	P_BUY_PRODUCTS,
	P_BUY_CANDLE,
	P_END_QUEST_8MARTA,
	
	P_COINS,
	
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
	
	P_AUTOSALON_COLOR,
	
	P_CARREGION_ENTER,
	P_CARNUMBER_ENTER,
	P_CARNUMBER_REGION,
	
	P_ATWORK,
	pVoenik,
	pMedCard,
};
new pData[MAX_PLAYERS][player_data];
