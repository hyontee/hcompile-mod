//>> Файл: bykranin_src/core/decl/enums_02.inc  (1571 строк)
//>> Тема: макросы, константы, enum и глобальные массивы (данные, без логики)
//>> Внутри: E_ITEM_STRUCT, E_ENTRANCE_STRUCT, E_HOTEL_STRUCT, E_HOTEL_CAR_PARK_STRUCT, E_HOUSE_STRUCT, E_HOUSE_TYPE_STRUCT, E_HOUSE_ROOM_STRUCT
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// ------------------------------------------
enum E_ITEM_STRUCT
{
	I_NAME[16],
	I_NAME_COUNT[8],
	bool: I_COMBINATION
};

// ------------------------------------------
enum E_ENTRANCE_STRUCT
{
	E_SQL_ID,		// ид в базе
	E_FLOORS,		// кол-во этажей
	Float: E_POS_X, // вход (пикап)
	Float: E_POS_Y, // вход (пикап)
	Float: E_POS_Z, // вход (пикап)
	Float: E_EXIT_POS_X,// выход
	Float: E_EXIT_POS_Y,// выход
	Float: E_EXIT_POS_Z,// выход
	Float: E_EXIT_ANGLE,// выход (угол)
	E_PICKUP_ID,		// ид пикапа
	E_MAP_ICON,			// иконка на карте
	Text3D: E_LABEL,	// 3д текст
	E_STATUS			// статус (куплены ли все квартиры)
};

// ------------------------------------------
enum E_HOTEL_STRUCT
{
	H_SQL_ID,
	H_OWNER_ID,
	H_RENT_DATE,
	bool: H_STATUS,
	H_OWNER_NAME[21]
};

enum E_HOTEL_CAR_PARK_STRUCT
{
	Float: HC_POS_X,
	Float: HC_POS_Y,
	Float: HC_POS_Z,
	Float: HC_ANGLE,
	HC_VEHICLE_ID
};

// ------------------------------------------
enum E_HOUSE_STRUCT
{
	H_SQL_ID,			// ид в базе данных
	H_NAME[20],			// название \ тип
	H_OWNER_ID,			// ид аккаунта владельца
	H_IMPROVEMENTS,		// уровень улучшений
	H_RENT_DATE,		// аренда на n времени
	H_PRICE,			// стоимость дома
	H_RENT_PRICE,		// плата за аренду в день
	H_LOCK_STATUS,		// статус (открыто/закрыто)
	H_ENTRACE,			// ид подьезда
	H_TYPE,				// тип дома (интерьер)
	Float: H_POS_X,		// позиция пикапа входа
	Float: H_POS_Y,		// позиция пикапа входа
	Float: H_POS_Z,		// позиция пикапа входа
	Float: H_EXIT_POS_X,// позиция после выхода из дома
	Float: H_EXIT_POS_Y,// позиция после выхода из дома
	Float: H_EXIT_POS_Z,// позиция после выхода из дома
	Float: H_EXIT_ANGLE,// угол поворота
	Float: H_CAR_POS_X,	// позиция транспорта
	Float: H_CAR_POS_Y,	// позиция транспорта
	Float: H_CAR_POS_Z,	// позиция транспорта
	Float: H_CAR_ANGLE,	// угол поворота транспорта
	Float: H_STORE_X,	// позиция шкафа
	Float: H_STORE_Y,	// позиция шкафа
	Float: H_STORE_Z,	// позиция шкафа
	// -------------------------
	H_OWNER_NAME[20 + 1],	// имя владельца
	Text3D: H_STORE_LABEL,	// 3д текст (шкаф)
	H_ENTER_PICKUP,			// пикап входа
	H_HEALTH_PICKUP,		// пикап аптечки
	H_MAP_ICON,				// иконка на карте
	H_FLAT_ID,				// номер квартиры
	// -------------------------
	H_EVICTION,			// продажа из-за задолженности
	// -------------------------
	H_STORE_METALL,		// Материалы в шкафу
	H_STORE_DRUGS,		// наркотики в шкафу
	H_STORE_WEAPON,		// оружие в шкафу
	H_STORE_AMMO,		// патроны оружия в шкафу
	H_STORE_SKIN		// одежда в шкафу
};

enum E_HOUSE_TYPE_STRUCT
{
	HT_NAME[20],
	Float: HT_ENTER_POS_X,		// позиции после входа в интерьера
	Float: HT_ENTER_POS_Y,		// позиции после входа в интерьера
	Float: HT_ENTER_POS_Z,		// позиции после входа в интерьера
	Float: HT_ENTER_POS_ANGLE,	// позиции после входа в интерьера
	Float: HT_HEALTH_POS_X,		// позиции аптечки
	Float: HT_HEALTH_POS_Y,		// позиции аптечки
	Float: HT_HEALTH_POS_Z,		// позиции аптечки
	Float: HT_STORE_POS_X,		// позиции шкафа
	Float: HT_STORE_POS_Y,		// позиции шкафа
	Float: HT_STORE_POS_Z,		// позиции шкафа
	HT_INTERIOR,				// ид интерьера
	HT_ROOMS					// кол-во комнат
};

enum E_HOUSE_ROOM_STRUCT
{
	HR_SQL_ID,			// ид в базе
	HR_OWNER_ID,		// ид игрока
	HR_RENT_DATE,		// насколько арендована комната
	HR_RENT_TIME,		// когда поселился
	HR_OWNER_NAME[21]	// ник арендатора
};

enum // управление домом
{
	HOUSE_OPERATION_PARAMS, 		// изменение параметров дома
	HOUSE_OPERATION_LOCK,			// открыть / закрыть
	HOUSE_OPERATION_IMPROVEMENTS,	// улучшение
	HOUSE_OPERATION_CAR_DELIVERY,	// доставить ТС к дому
	HOUSE_OPERATION_CAR_GPS,		// отметить транспорт на GPS
	HOUSE_OPERATION_RENTERS			// список арендаторов
}

// ------------------------------------------
enum E_BUSINESS_STRUCT
{
	B_SQL_ID,			// ид в базе данных
	B_NAME[24],			// название
	B_OWNER_ID,			// ид аккаунта владельца
	B_ENTER_PRICE,		// цена за вход в биз
	B_ENTER_MUSIC,		// звук при входе
	B_IMPROVEMENTS,		// уровень улучшений
	B_PRODS,			// количества продуктов
	B_PROD_PRICE,		// стоимость 1 продукта
	B_BALANCE,			// бюджет бизнеса
	B_RENT_DATE,		// аренда на n времени
	B_PRICE,			// стоимость бизнеса
	B_RENT_PRICE,		// плата за аренду в день
	B_LOCK_STATUS,		// статус (открыта/закрыта)
	B_TYPE,				// тип бизнеса
	B_INTERIOR,			// интерьер
	Float: B_POS_X,		// позиция бизнеса
	Float: B_POS_Y,		// позиция бизнеса
	Float: B_POS_Z,		// позиция бизнеса
	Float: B_EXIT_POS_X,// позиция после выхода из бизнеса
	Float: B_EXIT_POS_Y,// позиция после выхода из бизнеса
	Float: B_EXIT_POS_Z,// позиция после выхода из бизнеса
	Float: B_EXIT_ANGLE,// угол поворота
	// -------------------------
	B_OWNER_NAME[20 + 1],	// имя владельца
	Text3D: B_LABEL,		// 3д текст
	B_ORDER_ID,				// слот заказа
	B_HEALTH_PICKUP,		// ид пикапа аптечки
	// -------------------------
	B_EVICTION				// продажа из-за задолженности
};

enum // типы бизнесов
{
	BUSINESS_TYPE_SHOP_24_7 = 1, 	// магазин 24/7
	BUSINESS_TYPE_CLUB = 2, 		// клуб (алхамбра)
	BUSINESS_TYPE_REALTOR_BIZ = 3, 	// управление статистики (бизнесы)
	BUSINESS_TYPE_REALTOR_HOME = 4,	// риелторское агенство (дома)
	BUSINESS_TYPE_CLOTHING_SHOP = 5,// магазин одежды
	BUSINESS_TYPE_HOTEL = 6,		// отель
	BUSINESS_TYPE_CAR_MARKET = 7,	// авторынок
	BUSINESS_TYPE_CASINO = 8,		// казино
	BUSINESS_TYPE_CELL_SALON = 9,	// сотовый салон
	BUSINESS_TYPE_CAR_TUNING = 10, 	// станция тех. обслуживания
	BUSINESS_TYPE_SHOP_GUN = 11, 	// магазин оружия (либо просто добавьте этот)
	BUSINESS_TYPE_LAREK = 12, 	// ларек
	BUSINESS_TYPE_ACCESSORY_SHOP = 13, 	// магазин аксессуаров
	BUSINESS_TYPE_STYLING_CENTER = 14,
	BUSINESS_TYPE_TECH_CENTER = 15,
	BUSINESS_TYPE_TIRE_CENTER = 16,
};

enum E_GOS_INTERVIEW
{
	text_time[15],
	text_crit[100]
}
new interview[8][E_GOS_INTERVIEW];
new click_status[MAX_PLAYERS];


enum config
{
    admin_price,
    helper_price,
    sDistRub,
    sDonPower,
    sGiveCoins,
    sBonusMoney,
    sBonusDonate,
    sBonusLevel,
    sBuyBiz
}
new Config[config];

enum cars
{
    car_1,
    car_2,
    car_3,
    car_4,
    car_5
}
new Cars[cars];

enum //
{
	BIZ_OPERATION_PARAMS = 0,		// управление заправкой
	BIZ_OPERATION_LOCK,				// открыть / закрыть
	BIZ_OPERATION_ENTER_PRICE,		// установить цену за вход
	BIZ_OPERATION_PROD_PRICE,		// установить стоимость продукта
	BIZ_OPERATION_PROD_ORDER,		// заказать продукты
	BIZ_OPERATION_PROD_ORDER_CANCEL,// отменить заказ
	BIZ_OPERATION_PROFIT_STATS,		// финансовая статистика
	BIZ_OPERATION_IMPROVEMENTS,		// Улучшения
	BIZ_OPERATION_ORDER_INFO,		// Информация о заказе
	BIZ_OPERATION_EMPLOYEES,		// Сотрудники
	BIZ_OPERATION_GPS_MARK,			// Отметить на GPS
	BIZ_OPERATION_CHANGE_BUSINESS	// Сменить бизнес
};

enum E_BUSINESS_INTERIOR_STRUCT
{
	BT_NAME[64],			// Названия интерьера
	Float: BT_EXIT_POS_X, 	// позиции пикапа выхода
	Float: BT_EXIT_POS_Y, 	// позиции пикапа выхода
	Float: BT_EXIT_POS_Z, 	// позиции пикапа выхода
	// -------------------
	Float: BT_ENTER_POS_X, 	// позиции входа
	Float: BT_ENTER_POS_Y, 	// позиции входа
	Float: BT_ENTER_POS_Z, 	// позиции входа
	Float: BT_ENTER_ANGLE, 	// угол поворота
	BT_ENTER_INTERIOR,		// интерьер
	// -------------------
	Float: BT_HEALTH_POS_X,	// позиции аптечки
	Float: BT_HEALTH_POS_Y,	// позиции аптечки
	Float: BT_HEALTH_POS_Z,	// позиции аптечки
	// -------------------
	Float: BT_BUY_POS_X, 	// позиции покупки
	Float: BT_BUY_POS_Y, 	// позиции покупки
	Float: BT_BUY_POS_Z, 	// позиции покупки
	// -------------------
	Float: BT_LABEL_POS_X,	// позиции 3д текста
	Float: BT_LABEL_POS_Y,	// позиции 3д текста
	Float: BT_LABEL_POS_Z,	// позиции 3д текста
	BT_BUY_CHECK_ID			// ид чекпоинта
};

enum E_BUSINESS_GPS_STRUCT // список бизнесов в GPS
{
	BG_SQL_ID,
	BG_BIZ_ID,
	BG_POS,
	BG_TIME
};

// ------------------------------------------

enum E_FUEL_STATION_STRUCT
{
	FS_SQL_ID,			// ид в базе данных
	FS_NAME[20],		// название
	FS_OWNER_ID,		// ид аккаунта владельца
	FS_IMPROVEMENTS,	// уровень улучшений
	FS_FUELS,			// количества топлива
	FS_FUEL_PRICE,		// цена топлива за 1 л
	FS_BUY_FUEL_PRICE,	// закупочная цена за 1 л
	FS_BALANCE,			// бюджет заправки
	FS_RENT_DATE,		// аренда на n времени
	FS_PRICE,			// стоимость заправки
	FS_RENT_PRICE,		// плата за аренду в день
	FS_LOCK_STATUS,		// статус (открыта/закрыта)
	Float: FS_POS_X,	// позиция заправки
	Float: FS_POS_Y,	// позиция заправки
	Float: FS_POS_Z,	// позиция заправки
	// -------------------------
	FS_OWNER_NAME[20 + 1],	// имя владельца
	Text3D: FS_LABEL,		// 3д текст
	FS_ORDER_ID,			// слот заказа
	FS_AREA,				// зона
	// -------------------------
	FS_EVICTION				// продажа из-за задолженности
};

enum //
{
	FUEL_ST_OPERATION_PARAMS = 0,		// Управление заправкой
	FUEL_ST_OPERATION_LOCK,				// Открыть / закрыть
	FUEL_ST_OPERATION_NEW_NAME,			// Новое название
	FUEL_ST_OPERATION_FUEL_PRICE,		// установить цену за топливо
	FUEL_ST_OPERATION_BUY_FUEL_PRIC,	// установить закупочную цену топлива
	FUEL_ST_OPERATION_FUEL_ORDER,		// заказать топливо
	FUEL_ST_OPERATION_FUEL_ORDER_CA, 	// отменить заказ
	FUEL_ST_OPERATION_PROFIT_STATS,		// финансовая статистика
	FUEL_ST_OPERATION_IMPROVEMENTS		// Улучшения
};

// ------------------------------------------
enum E_WEATHER_STRUCT
{
	W_NAME[16],
	W_ID,
	W_DEGREES
};

// ------------------------------------------
enum E_ORDER_STRUCT
{
	O_SQL_ID, 		// ид заказа
	O_TYPE,			// тип (азс,биз)
	O_COMPANY_ID,	// ид предприятия
	O_AMOUNT,		// кол-во
	O_PRICE,		// цена за 1 (продукт/л топлива/...)
	O_TIME,			// время оформления
	O_USED			// выполняется ли
};

enum
{
	ORDER_TYPE_FUEL_STATION = 1, // заправка
	ORDER_TYPE_BUSINESS 		// бизнес
};

// ------------------------------------------
// 			Личные настройки

enum E_PLAYER_SETTINGS_STRUCT
{
	S_CHAT_TYPE,	// тип чата (Отключен,Стандарт,Advance)
	S_TEAM_CHAT,	// отображение чата организации
	S_PLAYERS_NICK,	// отображение ников над игроками
	S_NICK_IN_CHAT,	// отображение ников в чате
	S_ID_IN_CHAT,	// отображение ид игрока в чате
	S_VEH_CONTROL	// управление транспортом (клавиши и команды/команды)
};

enum
{
	SETTING_CHAT_OFF = 0,
	SETTING_CHAT_STANDART,
	SETTING_CHAT_ADVANCE,
	SETTING_TYPE_OFF = 0,
	SETTING_TYPE_ON
};

// ------------------------------------------
enum E_IMPROVEMENTS_STRUCT
{
	I_NAME[32],
	I_PRICE,
	I_LEVEL
};

// ------------------------------------------
enum E_PLAYER_GPS_STRUCT
{
	bool: G_ENABLED,
	Float: G_POS_X,
	Float: G_POS_Y,
	Float: G_POS_Z
};

enum E_GPS_STURCT
{
	Float: G_POS_X,
	Float: G_POS_Y,
	Float: G_POS_Z,
	G_MARKET_TYPE
};

// ------------------------------------------
enum E_HELP_INFO_STRUCT
{
	H_TITLE[64],
	H_INFO[1024]
};

// ------------------------------------------
enum E_MP_STRUCT
{
	MP_CREATE, 			// создано ли мероприятие
	MP_NAME[32],        // название
	MP_PRIZE,           // приз на мероприятии
	Float: MP_POS_X,    // координата X
	Float: MP_POS_Y,    // координата Y
	Float: MP_POS_Z     // координата Z
};

new mp[E_MP_STRUCT];

// ------------------------------------------

// ------------------------------------------
enum E_ANIM_LIST_STRUCT
{
	AL_DESCRIPTION[32],
	AL_LIB[32],
	AL_NAME[32],
	Float: AL_DELTA,
	AL_LOOP,
	AL_LOCK_X,
	AL_LOCK_Y,
	AL_FREEZE,
	AL_TIME
};

// ------------------------------------------
enum E_MAP_ICONS_STRUCT
{
	Float: MI_POS_X,
	Float: MI_POS_Y,
	Float: MI_POS_Z,
	MI_TYPE
};

// ------------------------------------------
enum E_TELEPORT_STRUCT
{
	T_NAME[64],
	Float: T_PICKUP_POS_X,
	Float: T_PICKUP_POS_Y,
	Float: T_PICKUP_POS_Z,
	T_PICKUP_VIRTUAL_WORLD,
	Float: T_POS_X,
	Float: T_POS_Y,
	Float: T_POS_Z,
	Float: T_ANGLE,
	T_INTERIOR,
	T_VIRTUAL_WORLD,
	T_ACTION_TYPE,
	Text3D: T_LABEL
};

enum // типы телепорта
{
	T_ACTION_TYPE_BLOCK_LEAVE_AREA = 1, // заблокировать вызов паблика OnPlayerLeaveDynamicArea
	T_ACTION_TYPE_END_JOB,	// анулировать деньги на временной работе если выходит из инта
	T_ACTION_TYPE_LEAVE_HOSPITAL, // проверить вылечился или нет в больнице
	T_ACTION_TYPE_LEAVE_PPS, // проверить сидит ли в тюрьме
};

// ------------------------------------------
enum E_DRIVING_TUTORIAL_STRUCT
{
	DT_TITLE[64],
	DT_INFO[2048]
};

enum E_PLAYER_DRIVING_EXAM_STRUCT
{
	DE_POINTS, // Балы
	DE_EXAM_STEP, // теория
	DE_ROUTE_STEP // практика
};

// ------------------------------------------
enum E_DRIVING_EXAM_STRUCT
{
	DE_TITLE[64],
	DE_LIST_ITEMS[256],
	DE_CORRECT_ANSWER
};

// ------------------------------------------
enum E_ATM_STRUCT
{
	Float: A_POS_X,
	Float: A_POS_Y,
	Float: A_POS_Z,
	Float: A_ROT_Z
};

enum E_REPORT_STRUCT
{
    Reptex[130],// Текст который пишет игрок 130 символов
    RepTime,
};
new RepInfo[MAX_PLAYERS][E_REPORT_STRUCT];
// ------------------------------------------
/*enum E_GATE_STRUCT
{
	G_DESCRIPTION[16],	// описание (наприм. жд-вьезд/жд-выезд)
	G_TYPE,				// тип (шлагбаум,ворота)
	Float: G_POS_X,		// позиции
	Float: G_POS_Y,		// позиции
	Float: G_POS_Z,		// позиции
	Float: G_ANGLE,		// угол
	Float: G_OPEN_POS_X, // позиции открытия
	Float: G_OPEN_POS_Y, // позиции открытия
	Float: G_OPEN_POS_Z, // позиции открытия
	Float: G_OPEN_ANGLE, // угол открытия (для кнопки)
	bool: G_STATUS,		// статус
	G_OBJECT_ID[2]		// иды обьектов
};

enum
{
	GATE_TYPE_BARRIER = 1,		// шлагбаум
	GATE_TYPE_BARRIER_MSG,		// шлагбаум (с сообщением)
	GATE_TYPE_BARRIER_BUTTON,	// шлагбаум (на кнопку)
	GATE_TYPE_NORMAL,	 		// ворота
}*/

// ------------------------------------------
enum E_BANK_ACCOUNT_STRUCT
{
	BA_ID,
	BA_NAME[20 + 1],
	BA_PIN_CODE[9],
	BA_BALANCE,
	BA_REG_TIME
};

enum E_BANK_TRANSFER_STRUCT
{
	BT_ID,
	BT_NAME[20 + 1]
};

// ------------------------------------------
enum E_PHONE_CALL_STRUCT
{
	PC_INCOMING_PLAYER,		// исходящий вызов
	PC_OUTCOMING_PLAYER,	// входящий вызов
	PC_TIME,				// время звонка
	bool:PC_ENABLED		// режим телефона (вкл\откл)
};

// ------------------------------------------
enum E_PHONE_BOOK_STRUCT
{
	PB_SQL_ID,
	PB_NAME[21],
	PB_NUMBER[10],
	PB_TIME
};

enum
{
	PHONE_BOOK_OPERATION_OPTIONS = 0,	// варианты
	PHONE_BOOK_OPERATION_CALL,			// позвонить
	PHONE_BOOK_OPERATION_SEND_SMS,		// отправить смс
	PHONE_BOOK_OPERATION_CHANGE_NAM,	// изменить имя
	PHONE_BOOK_OPERATION_CHANGE_NUM,	// изменить номер
	PHONE_BOOK_OPERATION_DELETE_CON,	// удалить контакт
};

// ------------------------------------------
enum E_MINER_CARRIAGE_STRUCT
{
	Float: MC_START_POS_X,
	Float: MC_START_POS_Y,
	Float: MC_START_POS_Z,
	Float: MC_END_POS_X,
	Float: MC_END_POS_Y,
	Float: MC_END_POS_Z,
	bool: MC_STATUS,
	MC_OBJECT_ID,
	MC_PICKUP_ID,
	Text3D: MC_LABEL,
	MC_ORE_COUNT,
	bool: MC_IN_MOVE
};

// ------------------------------------------
enum E_FACTORY_DESK_STRUCT
{
	Float: FD_POS_X,
	Float: FD_POS_Y,
	Float: FD_POS_Z,
	FD_CHEK_ID,
	FD_OBJECT_ID,
	bool: FD_USED,
	Text3D: FD_LABEl
};

// ------------------------------------------
enum E_REPOSITORY_STRUCT
{
	R_AMOUNT, // кол-во
	Text3D: R_LABEL,
	Text3D: R_LABEL_2,
	bool: R_NOT_SAVE
};

enum // типы складов
{
	REPOSITORY_TYPE_MINER, 		// шахта
	REPOSITORY_TYPE_FACTORY, 	// завод
	REPOSITORY_TYPE_OIL_FACTORY, // нефтезавод
	REPOSITORY_TYPE_ARMY,		// воинская часть
	REPOSITORY_TYPE_SAWMILL,	// лесопилка
};

enum
{
	// шахта
	REPOSITORY_ACTION_MINER_METAL = 0,	// Материалы шахты
	REPOSITORY_ACTION_MINER_ORE,		// руда
	REPOSITORY_ACTION_MINER_REMELTI,	// на переплавке

	// завод
	REPOSITORY_ACTION_FACTORY_METAL = 0, // Материалы
	REPOSITORY_ACTION_FACTORY_FUEL,		// топливо
	REPOSITORY_ACTION_FACTORY_PROD,		// продукты

	// нефтезавод
	REPOSITORY_ACTION_OIL_FACTORY_F = 0, // топливо на нефтезаводе

	// воинская часть
	REPOSITORY_ACTION_ARMY_METAL = 0,	// Материалы на складе воинской части
	REPOSITORY_ACTION_ARMY_AMMO,		// патроны на складе воинской части

	// лесопилка
	REPOSITORY_ACTION_SAWMILL_WOOD = 0,	// лесопилка дерево
};
new g_repository[5][3][E_REPOSITORY_STRUCT]; // склады

// ------------------------------------------
enum E_GANG_REPOSITORY_STRUCT
{
	GR_GANG,
	GR_METALL,
	GR_AMMO,
	GR_DRUGS,
	GR_MONEY,
	Text3D: GR_LABEL,
	GR_PICKUP,
	bool: GR_LOCK
}

new g_gang_repository[MAX_GANG_REPOSITORIES][E_GANG_REPOSITORY_STRUCT]; // склады банд

// ------------------------------------------
enum E_GANG_ZONES_STRUCT
{
	Float: GZ_MIN_X,
	Float: GZ_MIN_Y,
	Float: GZ_MAX_X,
	Float: GZ_MAX_Y,
	GZ_GANG,
	GZ_ZONE,
	GZ_AREA
}

new g_gang_zone[MAX_GZ][E_GANG_ZONES_STRUCT]; // гангзоны
new g_gang_zones_loaded; // количество загруженных гангзон

// ------------------------------------------
enum
{
	GANG_ARZ = 1,	// ОПГ Арзамасская
	GANG_BAT,		// ОПГ Батыревская
	GANG_LYT,		// ОПГ Лыткаринская
}

// ------------------------------------------
new gang_zone_colors[4] =
{
	0xFFFFFF75,	// Свободная зона
	0x00990060, // Арзамасская ОПГ
	0x6666FF75, // Батыревская ОПГ
	0xFFCD0075  // Лыткаринская ОПГ
};

new family_colors[17] =
{
	0xFFFFFFFF, // белый
	0xCD5C5CFF, // багровый
	0xFF0000FF, // красный
	0x8B0000FF, // темно-красный
	0xFFC0CBFF, // светло-розовый
	0xFFA07AFF, // цвет кожи
	0xFFFF00FF, // желтый
	0xFFD700FF, // золотой
	0xEE82EEFF, // фиолетовый
	0x800080FF, // темно-фиолетовый
	0x808080FF, // серый
	0xC0C0C0FF, // серебристый
	0x00FF00FF, // лайм
	0x008000FF, // зеленый
	0x228B22FF, // лесной
	0x1E90FFFF, // синий
	0x00BFFFFF // цвет неба
};

new family_colors_name[][32] =
{
	{"Белый"},
	{"Багровый"},
	{"Красный"},
	{"Темно-красный"},
	{"Светло-розовый"},
	{"Цвет кожи"},
	{"Желтый"},
	{"Золотой"},
	{"Фиолетовый"},
	{"Темно-фиолетовый"},
	{"Серый"},
	{"Серебристый"},
	{"Лайм"},
	{"Зеленый"},
	{"Лесной"},
	{"Синий"},
	{"Цвет неба"}
};

// ------------------------------------------
enum E_CAPTURE_STRUCT
{
	bool: C_STATUS,
	C_GANG_ZONE,
	C_ATTACK_TEAM,
	C_PROTECT_TEAM,
	C_ATTACKER_KILLS,
	C_PROTECTOR_KILLS,
	C_TIME,
	C_WAIT_TIME[3]
}

new g_capture[E_CAPTURE_STRUCT]; // капты для ОПГ

// ------------------------------------------
/*new weapon_tints[6] =
{
	0xFF4B5320, // Камуфляж
	0xFF9EAF43, // Зеленый
	0xFFFFAE1A, // Оранжевый
	0xFF0073E6, // Синий (полицейский)
	0xFFFF1493, // Розовый
	0xFFFFD700 	// Золотой
};

enum
{
	WEAPON_TINT_CAMO = 0,
	WEAPON_TINT_GREEN = 1,
	WEAPON_TINT_ORANGE,
	WEAPON_TINT_POLICE,
	WEAPON_TINT_PINK,
	WEAPON_TINT_GOLD
}*/

/*enum E_WEAPON_TINT_STRUCT
{
	WT_OBJECT,
	Float: WT_X,
	Float: WT_Y,
	Float: WT_Z,
	Float: WT_RX,
	Float: WT_RY,
	Float: WT_RZ,
	Float: WT_SCALE_X,
	Float: WT_SCALE_Y,
	Float: WT_SCALE_Z
}

new g_weapon_tint[MAX_WEAPON_TINTS][E_WEAPON_TINT_STRUCT] =
{
	{346, 	-0.004999, 	-0.003999, 	-0.006000, 	0.000000, 	0.000000, 	-1.800000, 	1.007000,	1.337999, 	1.069000},
	{347, 	-0.003999, 	-0.001999, 	-0.003999, 	0.000000, 	0.299999, 	-0.999999, 	1.000000,	1.188000, 	1.063000},
	{348, 	-0.006999, 	-0.004000, 	0.002000, 	-1.600000, 	-0.200000, 	0.400000, 	1.019999, 	1.146999, 	1.027000},
	{349, 	0.000000, 	-0.008999, 	-0.004000, 	0.000000, 	1.099999, 	1.499999, 	1.000000, 	1.222000, 	1.088000},
	{351, 	0.003000, 	-0.014000, 	-0.003000, 	0.000000, 	0.000000, 	2.199999, 	1.000000, 	1.371000, 	1.023000},
	{352, 	-0.002000, 	-0.008000, 	-0.001999, 	-0.300000, 	0.000000, 	1.199999, 	1.019999, 	1.245000, 	1.043000},
	{353, 	0.000000, 	-0.009000, 	-0.009000, 	0.000000, 	0.099999, 	2.100000, 	1.000000, 	1.290001, 	1.053000},
	{355, 	0.000000, 	-0.011000, 	0.000000, 	0.000000, 	0.000000, 	2.100000, 	1.009000, 	1.424000, 	1.013000},
	{356, 	-0.002000, 	-0.005999, 	0.001000, 	0.000000, 	0.899999, 	1.699999, 	0.997999, 	1.318999, 	1.088001},
	{372, 	-0.003000, 	-0.009000, 	-0.001999, 	0.000000, 	0.400000, 	0.800000, 	1.015000, 	1.232000, 	1.055000},
	{357, 	0.000000, 	-0.015000, 	-0.001999, 	0.000000, 	1.200000, 	2.199999, 	1.000000, 	1.286001, 	1.096001},
	{359, 	0.001999, 	-0.007000, 	-0.009000, 	0.000000, 	-0.100000, 	0.000000, 	0.989999, 	1.213001, 	1.084001},
	{360, 	0.001000, 	-0.004999, 	-0.008000, 	0.000000, 	0.000000, 	0.000000, 	1.000000, 	1.140000, 	1.055000}
};*/

enum E_FAMILY_STRUCT // структура семьи
{
    F_SQL_ID,       // ид аккаунта
    F_NAME[63 + 1], // название семьи
    F_USER_ID,      // создатель семьи
    F_TIME,         // время создания
    F_COLOR,        // цвет семьи
    F_LEVEL,        // уровень семьи
    F_EXP,          // опыт семьи
    F_RANK1[32],    // ранг 1
    F_RANK2[32],    // ранг 2
    F_RANK3[32],    // ранг 3
    F_RANK4[32],    // ранг 4
    F_RANK5[32],    // ранг 5
    F_RANK6[32],    // ранг 6
    F_RANK7[32],    // ранг 7
    F_RANK8[32],    // ранг 8
    F_RANK9[32],    // ранг 9
    F_RANK10[32],   // ранг 10
    F_MONEY,        // общак: деньги
    F_DRUGS,        // общак: наркотики
    F_TREE,         // общак: дерево
    F_METAL,        // общак: Материалы
    F_AMMO,         // общак: патроны
    F_HOUSE_ID,      // номер дома
    Float:F_SPAWN_POSITION[4],    // Позиция спавна
    F_SPAWN_IV[2],
    F_TAKE_MONEY,    //ранг доступа взятия денег со склада семьи
	F_TAKE_DRUGS,    //ранг доступа взятия нарко со склада семьи
	F_TAKE_METALL,    //ранг доступа взятия Материалыа со склада семьи
	F_TAKE_AMMO,    //ранг доступа взятия патронов со склада семьи
	F_RANG_INV,
	F_RANG_UNINV,
	F_RANG_MUTE,
	F_RANG_UNMUTE,
	F_RANG_WARN,
	F_RANG_UNWARN,
	F_RANG_GIVER,
	F_FAMILY_CARS,//количество тс у семьи
	F_OCKIFARMA,
	F_OCZAVOD,
	F_VISHARZ,
	F_VISHKAR,
	F_VISBUS
};

new g_family[200][E_FAMILY_STRUCT];

new g_family_loaded;

// ------------------------------------------





#define COLOR_LIGHTBLUE 0x00C3FFFF
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_LIME 0x00FF33FF
#define COLOR_GREY 0xAFAFAFFF
#define COL_WHITE "{FFFFFF}"
#define COL_LBLUE "{00C3FF}"
#define COL_RED "{FF0000}"
#define COL_LIME "{00FF33}"
#define COLOR_PURPLE 0xC2A2DAAA


// ------------------------------------------

enum E_BUY_CMD_STRUCT
{
	CMD_NAME[64],
	CMD_DESCRIPTION[128],
	CMD_PRICE
};

new
	g_admin_cmd_buy[CMD_NUM][E_BUY_CMD_STRUCT] =
{
	{"/setleader", "Данная команда даёт вам возможность выдавать права лидера", 800},
	{"/setadmin",  "Данная команда даёт вам возможность выдавать права администратора", 1500},
	{"/veh",       "Данная команда даёт вам возможность создать транспорт в любом месте", 500},
	{"/awarn",     "Данная команда даёт вам возможность выдавать админ варн", 800},
	{"/unawarn",   "Данная команда даёт вам возможность снимать админ варн", 750},
	{"/banip",     "Данная команда даёт вам возможность блокировать IP Адреса", 400}
};
// ------------------------------------------
enum E_BUS_ROUTE_STRUCT
{
	BR_NAME[32],
	BR_COLOR,
	BR_IN_JOB
};

enum E_BUS_ROUTE_STEP_STRUCT
{
	Float: BRS_POS_X,
	Float: BRS_POS_Y,
	Float: BRS_POS_Z,
	bool: BRS_STOP
};

// ------------------------------------------
enum E_PLAYER_SPECTATE_STRUCT
{
	Float: S_START_POS_X,
	Float: S_START_POS_Y,
	Float: S_START_POS_Z,
	Float: S_START_ANGLE,
	S_START_INTERIOR,
	S_START_VIRTUAL_WORLD,
	S_PLAYER
};
new g_spectate[MAX_PLAYERS][E_PLAYER_SPECTATE_STRUCT];
new g_spectate_gui_timer[MAX_PLAYERS];

// ------------------------------------------
enum
{
	PEDAL_TYPE_NONE = 0, // не жмёт ни на какую педаль
	PEDAL_TYPE_GAS, // педаль газа
	PEDAL_TYPE_BRAKE // педаль тормоза
}

new player_press_pedal[MAX_PLAYERS];

// ------------------------------------------
enum // иды диалогов
{
	INVALID_DIALOG_ID,
	// ---------------
	DIALOG_LOGIN,					// Авторизация
	DIALOG_REGISTER,				// Регистрация
	
	DIALOG_OBMEN_MONET,
	DIALOG_SERVER_SETTINGS_COINS,
	DIALOG_SERVER_SETTINGS_BONUSM,
	DIALOG_SERVER_SETTINGS_BONUSD,
	DIALOG_SERVER_SETTINGS_BONUSL,
	
	// ---------------
	DIALOG_PLAYER_MENU,  			// меню игрока
	DIALOG_PLAYER_STATS, 			// статистика игрока
	DIALOG_PLAYER_CMDS,  			// список команд
	DIALOG_PLAYER_SETTINGS,			// личные настройки
	DIALOG_PLAYER_SECURITY_SETTINGS,// настройки безопасности
	
	DIALOG_BOOMBOX0,
	DIALOG_BOOMBOX,
	DIALOG_BOOMBOX1,
	DIALOG_BOOMBOX2,
	DIALOG_BOOMBOX3,
	DIALOG_BOOMBOX4,
	DIALOG_LAREK, 
	DIALOG_BOOMBOX5,
	DIALOG_BOOMBOX6,
	DIALOG_BOOMBOX7,
	DIALOG_BOOMBOX_MENU,
	
	DIALOG_CONTENER1,
	DIALOG_CONTENER2,
	DIALOG_CONTENER3,

	DIALOG_TEST,
	
	DIALOG_ADMIN,
	

	
	DIALOG_SELLCARMY,
	DIALOG_SELLCAR, 
	
	DIALOG_MCHS_AVTO,
	DIALOG_MCHS_LIST,
	DIALOG_MCHS,
	
	DIALOG_CHANGEPROP,
	DIALOG_CHANGEPROPOBMEN,
	DIALOG_CHANGEPROPTIP,
	DIALOG_CHANGEPROPDOPLATA,
	DIALOG_CHANGEPROPSKOKDP,
	DIALOG_CHANGEPROPOBMENV,
	
	DIALOG_TESTERSKII,
	
	DIALOG_UNUSED_LEGACY_1,
	DIALOG_UNUSED_LEGACY_2,
	DIALOG_UNUSED_LEGACY_3,
	DIALOG_UNUSED_LEGACY_4,
	DIALOG_UNUSED_LEGACY_5,
	
	DIALOG_LAREK,
	
	DIALOG_BG,
	
	DIALOG_VERIF,
	
	DIALOG_ACSHELP,
	DIALOG_ACSHELP2,
	
	DIALOG_V2PROMO_CREATE,          // create promo
	DIALOG_YTPROMO_ACTIVATE, // legacy slot
	DIALOG_PROMO_ACTIVATE,	// legacy slot
	
	DIALOG_ADMSHOP,
	DIALOG_CONVERT_ADMSHOP,
	DIALOG_SKIN_ADMSHOP,
	DIALOG_VEH_ADMSHOP,
	DIALOG_VIP_ADMSHOP,
	
	DIALOG_INV,
	
	LOG_TYPE_ADMIN_SETADMIN,
	
	DIALOG_ASTATS,
		 
	DIALOG_SETADMINS, 
	
	DIALOG_DINFO,

	DIALOG_TEX_WERTON_FIX,

	DIALOG_GARAGE,
	
	DIALOG_ADMHELP,

	DIALOG_WHITELIST,

    DIALOG_PBASE,
	
	DIALOG_HELPERLIST,
	DIALOG_ADDREWARD,
	DIALOG_ADDDONATE,
	DIALOG_ADDMONEY,
	DIALOG_ADDSKIN,
	DIALOG_ADDCAR,
    DIALOG_ADDEPOINTS, 
	
	DIALOG_MPREG,
	
	DIALOG_HELPADM,
	
	DIALOG_HHELP,
	
	DIALOG_MENUHUD,
	
	DIALOG_STTSKIN,
	
	DIALOG_OTD,
    DIALOG_EX,
    DIALOG_EB,
    DIALOG_EM,
    DIALOG_OPR,
    DIALOG_EK,
    DIALOG_NG,
    

    
    DIALOG_HUD_MANAGER,
    DIALOG_MANAGER_HUDA_MENU,
    
    DIALOG_ACS_EDIT,
    DIALOG_FERMA,
    DIALOG_FERMAHELP,
    DIALOG_FERMABEGIN,
    DIALOV_FERMAARENDA,
    DIALOG_FERMAKOMB,
    DIALOG_FERMASBOR,
    DIALOG_INVENTORYTEST, 
    
	//
	DIALOG_LEADER_MENU,                 //Лидерское меню
	DIALOG_LEADER_MENU_UNINVITE,        //Лидерское меню
	DIALOG_LEADER_MENU_CARSPAWN,		//Лидерское меню
	DIALOG_LEADER_MENU_JOBS,            //Лидерское меню
	DIALOG_FRAKSKINS,
	//
 	DIALOG_RENT_BIKE,               // Аренда велосипеда
 	DIALOG_AUTOSALON_CAR_BUY,
	// ---------------
	DIALOG_SECURITY_SETTING_INFO,	// информацию о настройках
	DIALOG_SECURITY_SETTING_PHONE,	// запрос телефона при авторизации
	DIALOG_SECURITY_SETTING_PHONE_S,// устанавить запрос телефона при авторизации
	DIALOG_SECURITY_SETTING_PIN,	// запрос пин кода при авторизации
	DIALOG_SECURITY_SETTING_PIN_SET,// устанавить запрос пин кода при авторизации
	DIALOG_SECURITY_SETTING_PASS_1, // смена пароля (проверка текущего)
	DIALOG_SECURITY_SETTING_PASS_2, // смена пароля (смена)
	DIALOG_SECURITY_SETTING_EMAIL,	// подтверждения емайла
	DIALOG_LAUNCHPON, 
   DIALOG_TEX,
   DIALOG_PROSHIVKI,
   DIALOG_NITRO,
	// ---------------
	DIALOG_REPORT,					// репорт
	DIALOG_RESERVED_SUPPORT_INPUT,
	DIALOG_AUTOREPORT,				// Админ помощник
	// ---------------
	DIALOG_PLAYER_IMPROVEMENTS, 	// улучшения
	// ---------------
	DIALOG_CHANGE_NAME, 			// смена ника
	// ---------------
	
	DIALOG_CHANGE_COLOR_CAR,
	
	DIALOG_GPS, 					// gps
	DIALOG_GPS_PUBLIC_PLACES, 		// общественные места
	DIALOG_GPS_TRANSPORT, 			// транспортные узлы
	DIALOG_GPS_STATE_ORGANIZATIONS, // государственные организации
	DIALOG_GPS_GANGS,				// базы банд и мафий
	DIALOG_GPS_JOBS,				// по работе
	DIALOG_GPS_BANKS,				// по работе
	DIALOG_GPS_ENTERTAINMENT,
	DIALOG_GPS_AUTOSALONS,
	DIALOG_GPS_CITIES,
	DIALOG_GPS_VOKZALS,
	DIALOG_GPS_MISTS,
	DIALOG_GPS_TK,
	DIALOG_GPS_BUSINESS,			// реклама бизнеса
	DIALOG_GPS_MP,			// реклама бизнеса
	DIALOG_GPS_QUEST,
	// ---------------
	DIALOG_HELP,					// помощь по игре
	DIALOG_HELP_SECTION,			// раздел
	// ---------------
	// ---------------
	DIALOG_ANIM_LIST, 				// аним лист (/anim)
	// ---------------
	DIALOG_OPEN_HOOD_OR_TRUNK,		// управление капотом/багажником
	// ---------------
	DIALOG_DRIVING_TUTORIAL_START,	// теория в автошколе
	DIALOG_DRIVING_TUTORIAL,	 	// теория в автошколе
	DIALOG_DRIVING_TUTORIAL_END, 	// теория в автошколе
	DIALOG_DRIVING_EXAM_INFO, 		// экзамен по вождению
	DIALOG_DRIVING_EXAM_START,		// экзамен по вождению
	DIALOG_DRIVING_EXAM, 			// экзамен по вождению
	DIALOG_DRIVING_EXAM_RESULT, 	// экзамен по вождению
	
	DIALOG_MTOP,
	DIALOG_MTOP_MENU,
	// ---------------
	DIALOG_ATM, 					// банкомат
	DIALOG_ATM_TAKE_MONEY, 			// снять деньги
	DIALOG_ATM_TAKE_OTHER_MONEY,	// снять деньги (другая сума)
	DIALOG_ATM_PUT_MONEY, 			// положить деньги
	DIALOG_ATM_PUT_OTHER_MONEY, 	// положить деньги (другая сума)
	DIALOG_ATM_BALANCE, 			// баланс в банке
	DIALOG_ATM_PHONE_BALANCE,		// пополнить баланс телефона

	DIALOG_ATM_SELECT_COMPANY_TAKE,	// выбрать предприятие с которого снять деньги
	DIALOG_ATM_SELECT_COMPANY_PUT,	// выбрать предприятие на которое положить деньги
	DIALOG_ATM_FUEL_ST_TAKE_MONEY,	// снять деньги с заправочной станции
	DIALOG_ATM_FUEL_ST_PUT_MONEY,	// полижить деньги на счет заправочной станции
	DIALOG_ATM_BIZ_TAKE_MONEY,		// снять деньги с предприятия
	DIALOG_ATM_BIZ_PUT_MONEY,		// полижить деньги на счет предприятия

	DIALOG_ATM_TRANSFER_MONEY_1, 	// перевод на банковский счет
	DIALOG_ATM_TRANSFER_MONEY_2, 	// перевод на банковский счет
	DIALOG_ATM_CHARITY, 			// Благотворительность

	DIALOG_ATM_TICKET_SELECT,		// Выбор способа оплаты штрафа
	DIALOG_ATM_TICKET_LIST,			// Список штрафов
	DIALOG_ATM_TICKET_PAY,			// Оплата штрафа по номеру
	// ---------------
	DIALOG_PAY_FOR_RENT,			// оплата аренды (биз,дом,азс)
	DIALOG_PAY_FOR_RENT_FUEL_ST,	// оплата за АЗС
	DIALOG_PAY_FOR_RENT_BIZ,		// оплата за бизнес
	DIALOG_PAY_FOR_RENT_HOUSE,		// оплата за дом
	DIALOG_RETURN_MONEY,			// Возврат денег
	// ---------------
	DIALOG_BANK,					// банк
	DIALOG_BANK_ACCOUNTS, 			// мои счета
	DIALOG_BANK_ACCOUNT_LOGIN, 		// авторизация
	DIALOG_BANK_ACCOUNT_OPERATION,	// Список операций
	DIALOG_BANK_ACCOUNT_INFO, 		// информация о счете
	DIALOG_BANK_ACCOUNT_TAKE_MONEY,	// снять деньги
	DIALOG_BANK_ACCOUNT_PUT_MONEY,	// положить деньги
	DIALOG_BANK_ACCOUNT_TRANSFER_1, // перевод денег на другой счет 1
	DIALOG_BANK_ACCOUNT_TRANSFER_2, // перевод денег на другой счет 2
	DIALOG_BANK_ACCOUNT_CHANGE_NAME,// переименирование счета
	DIALOG_BANK_ACCOUNT_CHANGE_PIN,	// смена пин-кода

	DIALOG_BANK_CREATE_ACCOUNT, 	// создание счета
	DIALOG_BANK_CREATED_ACCOUNT, 	// создание счета
	// ---------------
	DIALOG_PHONE_CALL,				// Номера государственных организаций
	DIALOG_PHONE_CALL_BALANCE,		// Узнать баланс мобильного
	// ---------------
	DIALOG_ACTION,					// меню действия
	// ---------------
	DIALOG_VIEV_JOBS_LIST,			// посмотреть список работ
	DIALOG_JOIN_TO_JOB,				// устроится на работу
	// ---------------
	DIALOG_END_JOB,					// закончить работу
	// ---------------

	DIALOG_BUS_RENT_CAR,			// арендовать автобус
	DIALOG_BUS_ROUTE_COST,			// ввести стоимость проезда
	DIALOG_BUS_ROUTE_SELECTION,		// выбрать маршрут
	//---
	DIALOG_TAXI_RENT_CAR,			// арендовать такси
	DIALOG_TAXI_NAME,				// название такси
	DIALOG_TAXI_TARIFF,				// тариф
	
	DIALOG_ACTION_F_PROGRESS,
	DIALOG_ACTION_EXIT_HOUSE,
	//---
	DIALOG_UNUSED_LEGACY_6,		// арендовать эвакуатор
	DIALOG_UNUSED_LEGACY_7,		// начать работу механика
	DIALOG_UNUSED_LEGACY_8,			// название службы
	//---
	DIALOG_TRUCKER_RENT_CAR,		// арендовать грузовик
	DIALOG_TRUCKER_START_JOB,		// начать работу

	// ---------------
	DIALOG_PHONE_BOOK,				// телефонная книга
	DIALOG_PHONE_BOOK_OPTION,		// варианты
	DIALOG_PHONE_BOOK_SEND_SMS,		// отправить смс
	DIALOG_PHONE_BOOK_CHANGE_NAME,	// сменить имя контакта
	DIALOG_PHONE_BOOK_CHANGE_NUMBER,// сменить номер контакта

	DIALOG_PHONE_BOOK_ADD_CONTACT,	// телефонная книга (добавить контакт)
	// ---------------
	DIALOG_MINER_BUY_METALL, 		// покупка Материалыа на шахте
	// ---------------
	DIALOG_TEMP_JOB_LOADER_START,	// Начать работу грузчика
	DIALOG_TEMP_JOB_LOADER_END,		// Закончить работу грузчика
	DIALOG_TEMP_JOB_MINER_START,	// Начать работу шахтера
	DIALOG_TEMP_JOB_MINER_END,		// Закончить работу шахтера
	DIALOG_TEMP_JOB_FACTORY_TRUCKER,// Служба доставки завода
	DIALOG_TEMP_JOB_FACTORY,		// Производственный цех
	DIALOG_TEMP_JOB_LUMBERJACK_ST, 	// Начать работу лесоруба
	DIALOG_TEMP_JOB_LUMBERJACK_END,	// Закончить работу лесоруба
	// ---------------
	DIALOG_FUEL_STATION_BUY,		// покупка заправочной станции
	DIALOG_FUEL_STATION_INFO,		// инфо о заправочной станции
	DIALOG_FUEL_STATION_PARAMS,		// меню управления заправочной станцией
	DIALOG_FUEL_STATION_NAME,		// Смена названия
	DIALOG_FUEL_STATION_PRICE_FUEL,	// Цена топлива
	DIALOG_FUEL_STATION_BUY_FUEL_PR,// закупочная цена
	DIALOG_FUEL_STATION_ORDER_FUELS,// заказ топлива
	DIALOG_FUEL_STATION_ORDER_CANCE,// отмена заказа
	DIALOG_FUEL_STATION_IMPROVEMENT,// улучшения АЗС
	DIALOG_FUEL_STATION_SELL,		// продажа АЗС государству
	DIALOG_FUEL_STATION_BUY_JERRICA,// покупка канистры на АЗС
	DIALOG_FUEL_STATION_BUY_REPAIR,
	DIALOG_UNUSED_LEGACY_9,	// покупка топлива (механик)
	// ---------------
	DIALOG_JERRICAN_FILL_CAR,		// заправка авто с канистры
	DIALOG_BIZ_SELECT,
	DIALOG_YTPROMO_ACTIVATE,
	DIALOG_YTPROMO_CREATE,
	// ---------------
	DIALOG_BIZ_BUY,					// покупка бизнеса
	DIALOG_BIZ_INFO,				// инфо о бизнесе
	DIALOG_BIZ_PARAMS,				// меню управления бизнесом
	DIALOG_BIZ_ENTER_PRICE,			// установить цену за вход
	DIALOG_BIZ_PROD_PRICE,			// установить стоимость продутка
	DIALOG_BIZ_ORDER_PRODS,			// заказ продуктов
	DIALOG_BIZ_ORDER_CANCEL,		// отмена заказа
	DIALOG_BIZ_IMPROVEMENT,			// улучшение
	DIALOG_BIZ_SELL,				// продажа Бизнеса государству
	DIALOG_BIZ_ENTER_MUSIC,			// установить звук при входе
	DIALOG_BIZ_ENTER,				// платный вход
	DIALOG_BIZ_EMPLOYEES,			// сотрудники бизнеса

	DIALOG_BIZ_SHOP_24_7,			// магазин 24\7
	DIALOG_BIZ_LOTTERY,				// лотерея
	
	DIALOG_BIZ_SHOP_GUN,

	DIALOG_BIZ_CAR_MARKET,			// авторынок
	DIALOG_BIZ_CAR_MARKET_BUY_CAR,	// покупка авто
	DIALOG_BIZ_CAR_MARKET_CAR_INFO,	// информация об авто

	DIALOG_BIZ_CELL_SALON,			// сотовый салон
	DIALOG_BIZ_PHONE_BALANCE,		// пополнить счет телефона
	DIALOG_BIZ_CHANGE_PHONE_NUMBER,	// смена номера телефона
	DIALOG_BIZ_CHANGE_PHONE_COLOR,	// смена цвет телефона

	DIALOG_BIZ_CLUB,				// меню бара (клуб)

	DIALOG_BIZ_REALTOR_BIZ_LIST,	// список свободных бизнесов (управление статистики)
	DIALOG_BIZ_REALTOR_BIZ_INFO,	// фото бизнеса

	DIALOG_BIZ_REALTOR_HOME_GET,	// найти информацию о доме
	DIALOG_BIZ_REALTOR_HOME_INFO,	// фото дома

	DIALOG_BIZ_CLOTHING_BUY,		// покупка одежды

	DIALOG_BIZ_CAR_TUNING,          // -- новый тюнинг
	DIALOG_BIZ_CAR_TUNING_LIGHTS,	// -- тюнинг фар
	// ---------------
	DIALOG_HOUSE_BUY,				// покупка дома
	DIALOG_HOUSE_SELL,				// продажа дома
	DIALOG_HOUSE_INFO,				// инфо о доме
	DIALOG_HOUSE_PARAMS,			// меню управления домом
	DIALOG_HOUSE_IMPROVEMENTS,		// улучшение для дома
	DIALOG_HOUSE_RENTERS,			// список арендаторов
	DIALOG_HOUSE_RENTER_INFO,		// информация о арендаторе
	DIALOG_HOUSE_RENTER_EVICT,		// выселение арендатора
	DIALOG_HOUSE_EVICT,				// выселение арендатора (/liveout)
	DIALOG_HOUSE_MOVE_STORE,		// переставить шкаф (/makestore)
	DIALOG_HOUSE_STORE,				// использовать шкаф
	DIALOG_HOUSE_STORE_PUT,			// положить Материалы/наркотики
	DIALOG_HOUSE_STORE_TAKE,		// взять Материалы/наркотики

	DIALOG_HOUSE_ENTER,				// вход в дом
	// ---------------
	DIALOG_ENTRANCE_LIFT,			// лифт подъезда
	// ---------------
	DIALOG_HOTEL,					// меню отеля
	DIALOG_HOTEL_FLOOR_SELECT,		// Выбрать этаж (просмотр инфы о номерах)
	DIALOG_HOTEL_FLOOR_INFO,		// Информация о номерах этажа
	DIALOG_HOTEL_FLOOR_LIFT,		// лифт в отеле
	DIALOG_HOTEL_REG_ROOM,			// регистрация в номере
	DIALOG_HOTEL_CLIENT_MENU,		// меню клиента
	DIALOG_HOTEL_PAY_FOR_ROOM,		// оплата за комнату
	DIALOG_HOTEL_OUT,				// выселиться

	// ---------------

	DIALOG_ACT_PROMO,

	// ---------------

	DIALOG_OWNABLE_CAR,				// система управления транспортом
	DIALOG_OWNABLE_CAR_LOAD,		// загрузить транспорт
	DIALOG_OWNABLE_CAR_LIST,		// выбор транспорта из списка
	DIALOG_OWNABLE_CAR_SELL,		// продажа личного ТС
	DIALOG_FAMILY_CAR_SELL,		// продажа семейного ТС
	DIALOG_OWNABLE_CAR_NUMBER,		// получение номера на ТС
	DIALOG_OWNABLE_CAR_PT,          // performance tuning
	DIALOG_OWNABLE_CAR_PT_ITEM,     // улучшения
	DIALOG_OWNABLE_CAR_PT_ACCEPT,   // подтвердить улучшение
	DIALOG_OWNABLE_CAR_SETTINGS,    // настройки автомобиля

	// ---------------
	DIALOG_VEHICLE_TRUNK,			// багажник
	DIALOG_VEHICLE_TRUNK_PUT,		// положить предмет
	DIALOG_VEHICLE_TRUNK_PUT_ITEM,	// количество предметов
	DIALOG_VEHICLE_TRUNK_TAKE,		// достать предмет
	// ---------------
	DIALOG_SET_SPAWN,               // диалог смены спавна
	
	DIALOG_DONATE_CASE_PRISE,
	DIALOG_DONATE_CASE,
	
	DIALOG_DONATE_OPEN,
	
	DIALOG_ACTION_F_QUEST,
	DIALOG_QUEST_OPEN,
	
	// ---------------
	DIALOG_DONATE_INFO, 			// информация о донате (первый диалог)
	DIALOG_DONATE_MENU,				// меню доната
	DIALOG_DONATE_CONVERT,			// конвертация валюты
	DIALOG_DONATE_GET_MONEY,		// получение денег
	DIALOG_DONATIONS,				// все пополнения
	DIALOG_DONATE_ENROLLMENT,		// зачисление донат-очков
	DIALOG_DONATE_BUY_CAR_NUMBER,	// покупка номера на ТС
	DIALOG_DONATE_ACCEPT_CAR_NUM,	// подтверждение номера
	DIALOG_DONATE_BUY_NUMBER,		// смена номера телефона на 4-хзначный
	DIALOG_DONATE_SKILLS,			// список скиллов для прокачки
	DIALOG_DONATE_SKILL_BUY,		// прокачка скилла
	// ---------------
	DIALOG_DRUB_MENU,
	DIALOG_DRUB_BUYLEAD,
	DIALOG_DRUB_BUYADMIN,
	DIALOG_DRUB_BUYZAM,
	DIALOG_BUY_DONATE_CAR,
	
	
	//==============[ВОТ ЗДЕСЬ ДОБАВЛЯЙ НАЗВАНИЯ ДИАЛОГОВ]=======================================================
	
	DLG_ASKIN,
	
	
	DIALOG_PASSPORT,
	
	DLG_MAPTRUE,
	
	DIALOG_CREATE_FAMILY666,
	
	DLG_MYSKIN,
	
	DIALOG_REPORT_CLAIM,
	
	DIALOG_REPORT_EDIT,
	
	DIALOG_REPORT_SELECTOR,
	
	DIALOG_RESERVED_SUPPORT_CLAIM,
	
	DIALOG_RESERVED_SUPPORT_EDIT,
	
	DLG_HSTATS,
	
	DLG_TEMP_LEADER,
	
	DIALOG_REWARDS,
	
	DIALOG_VODOLAZACTOR,
	
	DIALOG_ARECOVERY,
	
	DIALOG_ROULETTE,
	
	DIALOG_REWARD,
	
	DIALOG_INFO,
	
	DIALOG_BUYBIZ_CLOSE,
	DIALOG_BUYBIZ_OPEN,
	// ----------------
	DIALOG_ADONATE_MENU,			// Меню доната
	DIALOG_BUY_PREFIX,				// Prefix
	DIALOG_BUY_CMD,					// Админ команды
	// ---------------
	DIALOG_TEAM_CHANGE_SKIN,		// смена скина игрока
	DIALOG_TEAM_LEAVE,				// уволиться по собственному желанию

	DIALOG_DEBTORLIST, 				// список должников
	DIALOG_DEBTORLIST_HOUSE, 		// дома должников
	DIALOG_DEBTORLIST_BIZ, 			// бизы должников
	DIALOG_DEBTORLIST_FUEL_ST, 		// АЗС должников

	DIALOG_DEBTOR_SELL_LIST, 		// Выселение
	DIALOG_DEBTOR_SELL_HOUSE, 		// Выселение дома
	DIALOG_DEBTOR_SELL_BIZ, 		// Выселение биза
	
	DIALOG_DEBTOR_SELL_FUEL_ST, 	// Выселение АЗС

	DIALOG_ADVISOR_MENU,			// Меню советника прав-ва
	DIALOG_ADVISOR_TEAM_STRUCTURE,	// Структура организации
	// ---------------
	DIALOG_ADMIN_PANEL,				// Панель управления сервером
	DIALOG_ADMIN_REG,				// Регистрация в админке
	DIALOG_ADMIN_LOGIN,				// Авторизация в админке
	DIALOG_ADMINS,					// Список администраторов
	DIALOG_LEADERS,					// Список лидеров
	DIALOG_EDIT_ADMIN,				// Редактирование администратора
	DIALOG_EDIT_LEADER,				// Редактирование лидера
	DIALOG_EDIT_ADMIN_RANG,			// Повысить/понизить администратора
	DIALOG_EDIT_LEADER_FRAC,		// Сменить управляемую фракцию
	DIALOG_REMOVE_ADMIN,			// Разжаловать администратора
	DIALOG_REMOVE_LEADER,			// Разжаловать лидера
	DIALOG_BLOCK_ACCOUNT,			// Заблокировать аккаунт
	DIALOG_BLOCK_ACCOUNT_CONFIRM,	// Подтвердить блокировку
	// ---------------
	DIALOG_TELEPORT_LIST,			// Список мест для телепорта
	DIALOG_SET_DOUBLING,			// Включить удвоение
	// ---------------
	DIALOG_GANG_REPOSITORY,			// Положить/взять со склада банды
	DIALOG_GANG_REPOSITORY_USE,		// Использование склада банды
	// ---------------
/*	DIALOG_RADAR_SELECT,			// Выбор типа радара
	DIALOG_RADAR_OBJECT,			// Выбор объекта радара
	DIALOG_RADAR_REMOVE,			// Удаление радара*/
	// ---------------
	DIALOG_ADVERT_EDIT,				// редактирование объявления
	// ---------------
	DIALOG_ARMORY,					// оружейный склад
	// ---------------
	DIALOG_BIZ_ORDERS,				// список заказов для бизнесов
	DIALOG_FS_ORDERS,				// список заказов для АЗС
	// ---------------
	DIALOG_PROMO_CREATE,			// создание промокода
	DIALOG_PROMO_ACTIVATE,			// активация промокода
	// ---------------
	DIALOG_MP_CREATE,               // создание МП
	DIALOG_MP_MENU,                 // панель МП
	DIALOG_MP_SKIN,                 // выдача скина на МП
	DIALOG_EVENT_CREATE,               // создание МП
	DIALOG_EVENT_MENU,                 // панель МП
	DIALOG_EVENT_SKIN,                 // выдача скина на МП
	DIALOG_EVENT_GUN,
	//
	DIALOG_FAMILY_CAR_RANG_SET,
	DIALOG_FAMILY_CAR_RANG,
 	DIALOG_CREATE_FAMILY,           // создание семьи
    DIALOG_FAMILY_MENU,             // Меню семьи
    DIALOG_FAMILY_RANG,             // смена рангов семьи
    DIALOG_FAMILY_RCHANGE,          // смена рангов семьи
    DIALOG_FAMILY_LEAVE,            // Выход из семьи
    DIALOG_FAMILY_SETTINGS,         // Настройки семьи
    DIALOG_ACTION_TYPE_GET_FAMILY,
    DIALOG_FAMILY_SPAWN_SET,
    DIALOG_FAMILY_WAREHOUSE, //склад семьи
    DIALOG_FAMILY_PUT_CASH,
	DIALOG_FAMILY_PUT_DRUGS,
	DIALOG_FAMILY_PUT_METALL,
	DIALOG_FAMILY_PUT_AMMO,
	DIALOG_FAMILY_TAKE_CASH,
	DIALOG_FAMILY_TAKE_DRUGS,
	DIALOG_FAMILY_TAKE_METALL,
	DIALOG_FAMILY_TAKE_AMMO,
	DIALOG_FAMILY_COLOR,
	DIALOG_COLOR_FAMILY_SET,
	DIALOG_FAMILY_NCHANGE,
	
	DIALOG_FAMILY_SETRANG_MENU,
	DIALOG_SET_FRANG_TAKEMONEY,
	DIALOG_SET_FRANG_TAKEDRUGS,
	DIALOG_SET_FRANG_TAKEMETALL,
	DIALOG_SET_FRANG_TAKEAMMO,
	DIALOG_SET_FRANG_INV,
	DIALOG_SET_FRANG_UNINV,
	DIALOG_SET_FRANG_MUTE,
	DIALOG_SET_FRANG_UNMUTE,
	DIALOG_SET_FRANG_WARN,
	DIALOG_SET_FRANG_UNWARN,
	DIALOG_SET_FRANG_GIVER,
	DIALOG_FAMSKLAD,
    //
    DIALOG_SELL_GIFT,               // продажа потков
    //
    DIALOG_DONATE_SKIN,

    DIALOG_ACTION_QUEST,
    //
    DIALOG_DONATE_PREMIUM,          // подписка "SERVER_NAME"+
    DIALOG_DONATE_VIP_HELP,			// VIP HELP
    // ----------
    DIALOG_SERVER_SETTINGS,
    DIALOG_SERVER_SETTINGS_ADM,
    DIALOG_SERVER_SETTINGS_HELP,
    DIALOG_SERVER_SETTINGS_RUB,
    DIALOG_SERVER_SETTINGS_DON,
    DIALOG_ADMINCALL_MENU,
    DIALOG_ORG_CAR_GET,
	DIALOG_TC_MAIN_MENU,
	DIALOG_TC_INFO,
	DIALOG_TC_FLEET_LIST,
	DIALOG_TC_FLEET_MANAGE,
	DIALOG_TC_FLEET_RENTPRICE,
	DIALOG_TC_FLEET_REPAIR,
	DIALOG_TC_FLEET_SELL_VEH,
	DIALOG_TC_MANAGE,
	DIALOG_TC_WITHDRAW,
	DIALOG_TC_RENAME,
	DIALOG_TC_COMMISSION,
	DIALOG_TC_FIRE,
	DIALOG_TC_BUY,
	DIALOG_TC_SELL,
	DIALOG_TC_EMPLOYEES,
	DIALOG_TC_EMP_SUBMENU,
	DIALOG_TC_EMP_LIST,
	DIALOG_TC_EMP_RATING_MENU,
	DIALOG_TC_EMP_RATING_LIST,
	DIALOG_TC_RATING_HELP,
	DIALOG_TC_FIRE_CONFIRM,
	DIALOG_TC_FINANCE,
	DIALOG_TC_FINANCE_DETAIL,
	DIALOG_TC_PERSONAL,
	DIALOG_TC_UPGRADE,
	DIALOG_TC_UPGRADE_CONFIRM,
	DIALOG_TC_HELP,
	DIALOG_TC_LEAVE,
	DIALOG_TC_COMPANY_LIST,
	DIALOG_TC_COMPANY_JOIN,
	DIALOG_TC_RENT_LIST,
	DIALOG_TC_ORDERS_LIST,
	DIALOG_TC_ORDER_INFO,
	DIALOG_TC_CARGO_RESPAWN,
	DIALOG_TC_ADMIN_LIST,
	DIALOG_TC_ADMIN_GIVE,
	DIALOG_TC_RETURN_RENT,
	DIALOG_TC_PURCHASE_NAME,
	DIALOG_TC_PURCHASE_CONFIRM,
	DIALOG_TC_DEPOSIT,
	DIALOG_ADMIN_NICK_COLOR
    /*DIALOG_NOTIF,       // уведомления как на бр
	DLG_MAKE_LEADER,    // Назначения лидера
	DLG_QUEST_FSKIN,   // Для обновления
	DIALOG_AHELP,      // Помощь администрации
	DIALOG_ASTATS,    // Статистика администратора
	DLG_TEMP_LEADER,  // Временное взятие лидерства
	DLG_SET_PREFIX,   // Префиксы администрации
	DLG_SET_PREFIX_ONE,
	DLG_SET_PREFIX_SELECT,
	DLG_SET_PREFIX_TWO,
	DIALOG_CHOOSE_PREFIX_ONE,
	DIALOG_CHOOSE_PREFIX_TWO,
	DLG_VIP_SILVER,
    DLG_BUY_VIP,
    DLG_VIP_SELECT*/
};

