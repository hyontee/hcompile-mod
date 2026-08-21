#define event_pass_info 		"30.300.000"valute_title_", 70 DP, 11 EXP"
#define event_coins				"Event Coins"
#define event_coins_letter		"EC"

#define MAX_BATTLE_ITEM_NAME	30

#define MAX_QUEST_NAME			24
#define MAX_QUEST_DESCRIPTION	100

#define MAX_BATTLE_PASS_ITEMS	60
#define MAX_EVENT_QUESTS		42
#define MAX_EVENT_DURATION		60


static Float: event_actor_position [ 4 ] = { 38.1164, -94.2285, 12.5545, 210.4231 } ;

const MAX_TRADE_ITEM			= 44 ;

enum _event_trade
{
	event_name [ 46 ],
	event_price,
	event_prise,
	event_inv_type,
	event_render
} ;

enum
{
	BATTLEPASS_NO_RENDER = -1,
	BATTLEPASS_RENDER_OBJECT = 2,
	BATTLEPASS_RENDER_CAR = 3,
	BATTLEPASS_RENDER_SKIN = 1
} ;

static const event_trade [ MAX_TRADE_ITEM ] [ _event_trade ] =
{
	{ "Рулетка удачи {cd7f32}Bronze{"#cWH"}", 600, 2045, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_OBJECT },
	{ "Рулетка удачи {c8c8c8}Silver{"#cWH"}", 1000, 2055, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_OBJECT },
	{ "Рулетка удачи {c3900a}Gold{"#cWH"}", 1400, 2125, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_OBJECT },
	{ "VIP {cd7f32}Bronze{"#cWH"} (3 дн.)", 500, 2024, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {cd7f32}Bronze{"#cWH"} (5 дн.)", 800, 2025, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {cd7f32}Bronze{"#cWH"} (7 дн.)", 1100, 2026, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {cd7f32}Bronze{"#cWH"} (10 дн.)", 1550, 2027, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {c8c8c8}Silver{"#cWH"} (3 дн.)", 800, 2028, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {c8c8c8}Silver{"#cWH"} (5 дн.)", 1300, 2029, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {c8c8c8}Silver{"#cWH"} (7 дн.)", 1800, 2030, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "VIP {c8c8c8}Silver{"#cWH"} (10 дн.)", 2650, 2031, GIVE_TYPE_INVENTORY, BATTLEPASS_NO_RENDER },
	{ "Крылья демона", 10000, 8221, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Самолётик", 3000, 117, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_OBJECT },
	{ "Рабочий жилет", 3000, 121, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_OBJECT },
	{ "Одежда #183", 3000, 183, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #184", 3000, 184, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #277", 2000, 277, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #281", 2000, 281, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #294", 600, 294, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #300", 1000, 300, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4500", 1000, 4500, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4501", 1000, 4501, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4502", 1000, 4502, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4503", 1000, 4503, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4504", 1000, 4504, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4505", 1000, 4505, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4505", 1000, 4505, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4655", 3000, 4655, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Одежда #4657", 3000, 4657, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_SKIN },
	{ "Toyota Supra GR", 5000, 3260, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Mercedes-Benz AMG GTR", 4000, 3248, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Dodge Hellcat", 10000, 3267, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Porsche Taycan", 20000, 3274, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Mercedes-Benz ML63", 10000, 3226, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Chevrolet Tahoe", 10000, 3360, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Nissan 240SX", 20000, 3356, GIVE_TYPE_INVENTORY, BATTLEPASS_RENDER_CAR },
	{ "Legoman (Аксессуар)", 5000, 12639, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Скейтбоард (Аксессуар)", 5000, 12652, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Бронежилет (1 ур.) (Аксессуар)", 7500, 11781, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Бронежилет (2 ур.) (Аксессуар)", 10000, 11782, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Бронежилет (3 ур.) (Аксессуар)", 15000, 11783, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Жилет Бургер Кинг", 5000, 8102, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Боксёрская перчатка", 5000, 8103, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT },
	{ "Корона Бургер Кинг", 5000, 8104, GIVE_TYPE_ACESSORIES, BATTLEPASS_RENDER_OBJECT }
} ;

new AdviceTitle [ 5 ] [ 128 ] =
{
	"Улучшенный пропуск",
	"Обменник "event_coins"",
	"Лимит заданий в сутки",
	"Техническая поддержка",
	"Помощь по игре"
} ;

new AdviceText [ 5 ] [ 512 ] =
{
	"Купив улучшенный пропуск Вам будет начисляться х1.5 опыта за задания",
	"Обменивайте "event_coins" полученные за повышение уровня пропуска у специального обменника (/gps - Прочее)",
	"Сняв лимит, когда выполните 6 заданий, задания будут обновляться автоматически",
	"Если у Вас возникают какие-либо трудности по игре, то обратитесь в техническую поддержку "vk_group_technical"",
	"Ознакомиться с множеством игровых систем можно использовав /help, а также обратиться на форум: "site_name""
} ;

enum
{
	BP_ITEM_COMMON = 0,
	BP_ITEM_RARE,
	BP_ITEM_EPIC,
	BP_ITEM_LEGENDARY
} ;

#define MAX_BP_ITEM 72

enum _bp_roulette
{
	bp_model,
	bp_rare,
	bp_render,
	bp_color [ 10 ]
} ;

new bp_buy_item [ 3 ] [ _bp_roulette ] = 
{
	{ 130, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "#33AA33" },
	{ 133, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT, "#4582A1" },
	{ 137, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_OBJECT, "#FFCC00" }
} ;

new bp_roulette [ MAX_BP_ITEM ] [ _bp_roulette ] =
{
	{ 910, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT, "" },
	{ 919, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT, "" },
	{ 985, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT, "" },
	{ 19042, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT, "" },
	{ 19424, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 12641, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 19037, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 11002, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 12051, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 12054, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 12081, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT, "" },
	
    { 110, BP_ITEM_COMMON, BATTLEPASS_RENDER_SKIN, "" },
	{ 180, BP_ITEM_COMMON, BATTLEPASS_RENDER_SKIN, "" },
	{ 83, BP_ITEM_COMMON, BATTLEPASS_RENDER_SKIN, "" },
	{ 294, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" },
	{ 139, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" },
	{ 193, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" },
	{ 35, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 43, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 10, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 4541, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 4538, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 302, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" },
	{ 304, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4545, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4546, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 315, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4521, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4549, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4550, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4562, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4563, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 315, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4556, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4557, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	{ 4559, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_SKIN, "" },
	
	{ 467, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 402, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 458, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 507, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 3292, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 566, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 401, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" },
	{ 421, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 424, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 466, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 494, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 585, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
    { 546, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 505, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 480, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 409, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 549, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 542, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 587, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 602, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 3294, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR, "" },
	{ 565, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 3308, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 3286, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 3291, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 489, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 491, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 3229, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 576, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 411, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 579, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" },
	{ 3264, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" },
	{ 3298, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" },
	{ 3296, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" },
	{ 3354, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" },
	{ 3313, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" }
} ;

new bp_case1 [ 15 ] [ _bp_roulette ] =
{
	{ 908, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // case crime
	{ 18947, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 19137, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" },
	{ 909, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // case crime
	{ 912, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // donate
	{ 18165, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // donate
	{ 304, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" }, // craft
	{ 210, BP_ITEM_COMMON, BATTLEPASS_RENDER_SKIN, "" }, // магаз скинов
	{ 4554, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" }, // event pass
	{ 4581, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // valentine
	{ 4600, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // valentine
	{ 4617, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // valentine
	{ 3229, BP_ITEM_COMMON, BATTLEPASS_RENDER_CAR, "" }, // Porsche Cayenne - автосалон
	{ 3271, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" }, // Mercedes-Benz GL63 - case crime
	{ 3345, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" } // Patriot Bagage // valentine
} ;

new bp_case2 [ 15 ] [ _bp_roulette ] =
{
	{ 12613, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT, "" }, // e2y
	{ 11912, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // valentine
	{ 12647, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // valentine
	{ 12652, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT, "" }, // event pass
	{ 12657, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // donate
	{ 12645, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // valentine
	{ 12648, BP_ITEM_RARE, BATTLEPASS_RENDER_OBJECT, "" }, // valentine
	{ 4592, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // craft
	{ 4606, BP_ITEM_RARE, BATTLEPASS_RENDER_SKIN, "" }, // case crime
	{ 4622, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // donate
	{ 4613, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN, "" }, // donate
	{ 3316, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" }, // Batman Car - донат - valentine
	{ 3332, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" }, // BMW M1 - donate
	{ 3359, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR, "" }, // Nissan Skyline R34 - craft
	{ 3238, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR, "" } // Molniya McQueen - донат
} ;

new common_item [ 50 ] = { 0, ... } ;
new common_count = 0 ;
new rare_item [ 50 ] = { 0, ... } ;
new rare_count = 0 ;
new epic_item [ 50 ] = { 0, ... } ;
new epic_count = 0 ;
new legendary_item [ 50 ] = { 0, ... } ;
new legendary_count = 0 ;

#define MAX_BATTLE_PASS_ROULETTE_ITEMS 15
new player_case [ MAX_PLAYERS ] [ MAX_BATTLE_PASS_ROULETTE_ITEMS ] ;
new player_case_last [ MAX_PLAYERS ] ;

enum
{
	d_event_quest = 20000,
	d_event_info,
	d_epass_return,
	d_event_select,
	
	d_event_trade
} ;

new
	gPlayerBattlePassCoins [ MAX_PLAYERS ],
	gPlayerBattlePassLVL [ MAX_PLAYERS char ],
	gPlayerBattlePassEXP [ MAX_PLAYERS char ],
	bool: gPlayerBattlePassPrem [ MAX_PLAYERS ],
	bool: gPlayerBattlePassLimit [ MAX_PLAYERS ],
	gPlayerBattlePassQuest [ MAX_PLAYERS ],
	event_count,
	EventDay = 0,
	stop_event = 0 ;

enum
{
	BP_NONE = 0,
	BP_MONEY = 1,
	BP_EXP = 2,
	BP_SKIN = 3,
	BP_DONATE = 4,
	BP_BRONZE_ROULETTE = 5,
	BP_SILVER_ROULETTE = 6,
	BP_GOLD_ROULETTE = 7,
	BP_ACCS = 8,
	BP_CAR = 9,
	BP_TYPE_OBJECT = 10,
	BP_TYPE_OBJECT_1 = 11,
	BP_TYPE_SKIN_1 = 12,
	BP_TYPE_SKIN_2 = 13,
	BP_TYPE_SKIN_3 = 14,
	BP_TYPE_SKIN_BLOG_1 = 15,
	BP_TYPE_SKIN_BLOG_2 = 16,
	BP_TYPE_SKIN_BLOG_3 = 17,
	BP_TYPE_CAR_1 = 18,
	BP_TYPE_CAR_2 = 19,
	BP_TYPE_CAR_3 = 20,
	BP_SECRET = 21,
	BP_FAMILY = 22,
	BP_SLOT_CAR = 23,
	BP_TREASURE = 24,
	BP_CRIME = 25,
	BP_DONATE_BONUS = 26,
	BP_DETAIL_CRAFT = 27,
	BP_LOTTERY = 28,
	BP_LOTTERY2 = 29,
	BP_ROULETTE_ITEM_0 = 96,
	BP_ROULETTE_ITEM_1 = 97,
	BP_ROULETTE_ITEM_2 = 98,
	BP_INVENTORY
	
} ;

enum ENUM_BATTLE_PASS_ITEMS
{
	bpiName [ MAX_BATTLE_ITEM_NAME ],
	bpiType,
	bpiAmount,
	bpiRare,
	bpiRender,
	
	bpiPremName [ MAX_BATTLE_ITEM_NAME ],
	bpiPremType,
	bpiPremAmount,
	bpiPremRare,
	bpiPremRender
} ;

new BattlePass [ MAX_BATTLE_PASS_ITEMS ] [ ENUM_BATTLE_PASS_ITEMS ] =
{
    {"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"X-Peng", 9, 3368, BP_ITEM_EPIC, BATTLEPASS_RENDER_CAR}, // 0
	{"2 EXP", 2, 2, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 											"Skin Рулетка", 12, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 1
	
	{"Аптечка", BP_INVENTORY, ITEM_AID_KIT, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,					"Деньги: 2 000 000"valute_title_"", 1, 2_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 2
	{"10 "donate_title"", 4, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"10 "donate_title"", 4, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 3
	
	//{"Лотерея", 28, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER, 											"Лотерея", 29, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 4
	{"Case #3", 8, 8331, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT, 									"Огурчик Рик", 8, 5093, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 4
	{"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 5
	
	{"Brozne Рулетка", 5, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 									"Skin Рулетка #2", 13, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 6
	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 7

	{"Канистра", BP_INVENTORY, 157, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 							"15 "donate_title"", 4, 15, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 8
	{"Рем. комплект", BP_INVENTORY, 156, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 						"4 EXP", 2, 4, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 9

	{"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 10
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 											"Car Рулетка", 18, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 11

	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER, 		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 12
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER, 									"Одежда #4735", 3, 4735, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN}, // 13

	{"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 14
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 15
	
	{"Gold Рулетка", 7, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 										"Рулетка аксессуаров", 10, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 16
	{"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 1 500 000"valute_title_"", 1, 1_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 17
	
	{"25 "donate_title"", 4, 25, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"C3PO", 8, 5036, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 18
	{"Одежда #4639", 3, 4639, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN,									"Одежда #4728", 3, 4728, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN}, // 19

	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 20
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 21

	{"Часы Храмова", 8, 8285, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT,								"BMW M3 E46", 9, 3337, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT}, // 22
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,									"Рулетка аксессуаров", 10, 1, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 23

	{"Деньги: 3 500 000"valute_title_"", 1, 3_500_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 500 000"valute_title_"", 1, 3_500_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 24
	{"Gold Рулетка", 7, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,									"+1 слот т/с", 23, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 25
	
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 26
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,									"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 27
	
	// 28
	
	{"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 28
	{"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Skin Рулетка #4", 15, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 29
	
	{"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 30
	{"Одежда #4623", 3, 4623, BP_ITEM_EPIC, BATTLEPASS_RENDER_SKIN,									"Деньги: 2 500 000"valute_title_"", 1, 2_500_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 31
	
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 32
	{"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 33
	
	{"Brozne Рулетка", 5, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,									"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 34
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,									"Crime Plus (3 часа)", 25, 3, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 35
	
	{"Gold Рулетка", 7, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,									"Skin Рулетка #5", 16, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 36
	{"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"20 "donate_title"", 26, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 37
	
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 38
	{"Дрон самолёт", 8, 8203, BP_ITEM_EPIC, BATTLEPASS_RENDER_OBJECT,								"Красная броня", 8, 5014, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_OBJECT}, // 39

	{"Деньги: 1 000 000"valute_title_"", 1, 1_000_000, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,		"Деньги: 5 000 000"valute_title_"", 1, 5_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 40
	{"Карта кладов (5 часов)", 24, 5, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,							"Car Рулетка #2", 19, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 41
	
	// 42

	{"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,								"10 "family_title"", 22, 10, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 42
	{"Audi CF", 9, 3373, BP_ITEM_RARE, BATTLEPASS_RENDER_CAR,										"Skin Рулетка #2", 14, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 43

	{"Crime Plus (1 час)", 25, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,								"Деньги: 10 000 000"valute_title_"", 1, 10_000_000, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 44
	{"Kawasaki", 9, 522, BP_ITEM_LEGENDARY, BATTLEPASS_RENDER_CAR,									"Карта кладов (15 часов)", 24, 15, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 45

	{"Золото (~5 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,						"Золото (~15 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 46
	{"Хлопок (~5 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,							"Хлопок (~15 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 47

	{"VIP Bronze (3 дн.)", 30, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,								"VIP Gold (3 дн.)", 30, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 48
	{"Рулетка удачи Bronze", 96, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,							"Рулетка удачи Gold", 98, 1, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 49

	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER,			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 50
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 51

	{"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 								"20 "donate_title"", 4, 20, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 52
	{"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER, 			"Деньги: 3 000 000"valute_title_"", 1, 3_000_000, BP_ITEM_RARE, BATTLEPASS_NO_RENDER}, // 53
		
	{"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER,											"3 EXP", 2, 3, BP_ITEM_COMMON, BATTLEPASS_NO_RENDER}, // 54
	{"Silver Рулетка", 6, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,									"Рулетка аксессуаров #2", 11, 1, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER}, // 55
	
	{"Золото (~5 шт.)", 27, 19941, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,						"Ключ от тюрьмы", 27, 11746, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 56
	{"Хлопок (~5 шт.)", 27, 2684, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT,							"Бампер", 27, 1140, BP_ITEM_COMMON, BATTLEPASS_RENDER_OBJECT}, // 57

	{"Деньги: 10 000 000"valute_title_"", 1, 10_000_000, BP_ITEM_EPIC, BATTLEPASS_NO_RENDER,		"Skin Рулетка #6", 17, 1, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER}, // 58
	{"Секретный приз", 21, 300, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER,							"Секретный приз", 21, 300, BP_ITEM_LEGENDARY, BATTLEPASS_NO_RENDER} // 59
} ;

enum
{
	THE_BUY_247 = 0,
	THE_ROCK = 1,
	BUY_OTHER_FOOD = 2,
	BUY_PAY_FRIEND = 3,
	
	THE_INCASSATION = 4,
	THE_SAWMILL = 5,
	THE_CASINO = 6,
	
	THE_FACTORY = 7,
	THE_HUNTING = 8,
	THE_ISLAND_QUEST = 9,
	USED_HEALTH = 10,
	
	THE_TREASURE = 11,
	THE_WEEKLY_CASE = 12,
	THE_TRUCKER = 13,
	PUT_MOBILE = 14,
	
	THE_FRACTION = 15,
	THE_GARAGE_WARS = 16,
	THE_FRIEND = 17,
	THE_AMMUNATION = 18,
	
	THE_FAMILY = 19,
	THE_DEPOSIT = 20,
	THE_PHONE_MODEL = 21,
	
	THE_FAMILY_QUEST = 22,
	THE_DELIVERY = 23,
	THE_GYM = 24,
	THE_TOWCAR = 25,
	
	THE_FLY_LIC = 26,
	THE_FUEL_DELIVERY = 27,
	
	THE_GIVE = 28,
	
	THE_ROULETTE = 29,
	THE_PAINT_VEHICLE = 30,
	
	THE_PANTERA_VEHICLE = 31,
	THE_PERFOMANCE_VEHICLE = 32,
	THE_FUEL = 33,
	
	THE_MEDIC = 34,
	THE_FISHING = 35,
	THE_FILLING = 36,
	
	THE_FAMILY_AIRDROP = 37,
	THE_TAX = 38,
	THE_COIN = 39,
	THE_PERK = 40,
	THE_FAMILY_DEALER = 41
} ;

enum ENUM_EVENT_QUESTS_DATA
{
	eqEPassEXP,
	eqProgress,
	eqType,
	eqName [ MAX_QUEST_NAME ],
	eqDescription [ MAX_QUEST_DESCRIPTION ]
} ;

new QuestData [ MAX_EVENT_QUESTS ] [ ENUM_EVENT_QUESTS_DATA ] =
{
    {25, 1, THE_BUY_247, "Приобретение", "купить что-нибудь в магазине 24/7"}, // 0
    {25, 15, THE_ROCK, "Шахта", "собрать 15 камня, на шахте"}, // 1
    {25, 1, BUY_OTHER_FOOD, "Голод", "пополнить сытость в любой закусочной"}, // 2
    {25, 5_000, BUY_PAY_FRIEND, "Помощь", "передать другу 5 000"valute_title_""}, // 3
    {25, 5, THE_INCASSATION, "Инкассатор", "инкассируйте 5 банкоматов"}, // 4
    {25, 5, THE_SAWMILL, "Лесопилка", "перенести 5 связок дров на склад"}, // 5
	
    {25, 1, THE_CASINO, "Казино", "сыграйте в любую игру в казино"}, // 6
    {25, 5, THE_FACTORY, "Завод", "соберите 5 деталей на заводе"}, // 7
    {25, 3, THE_HUNTING, "Охота", "подстрелите 3 оленей"}, // 8
    {25, 1, THE_ISLAND_QUEST, "Остров", "выполните задание на острове (/gps - Квесты)"}, // 9
    {25, 3, USED_HEALTH, "Здоровье", "используйте аптечку 3 раза"}, // 10
    {25, 1, THE_TREASURE, "Клад", "откопайте клад"}, // 11
    {25, 1, THE_WEEKLY_CASE, "Еженедельный кейс", "получите еженедельный кейс"}, // 12
    {25, 50_000, THE_TRUCKER, "Дальнобойщик", "заработайте будучи дальнобойщиком 50 000"valute_title_""}, // 13
    {25, 1000, PUT_MOBILE, "Пополнить телефон", "пополните баланс телефона на 1 000"valute_title_""}, // 14
    {25, 1, THE_FRACTION, "Организация", "вступите в любую организацию"}, // 15
    {25, 1, THE_GARAGE_WARS, "Аукцион", "примите участие в аукционе контейнеров"}, // 16
    {25, 1, THE_FRIEND, "Друг", "занесите игрока в список друзей (/friends)"}, // 17
    {25, 1, THE_AMMUNATION, "Аммо", "закупитесь в магазине оружия (/gps - Бизнесы - Магазин оружия)"}, // 18
    {25, 1, THE_FAMILY, "Семья", "вступите в любую семью"}, // 19
	
    {25, 10_000, THE_DEPOSIT, "Депозит", "внесите на Ваш банковский счёт 10 000"valute_title_""}, // 20
    {25, 1, THE_PHONE_MODEL, "Телефон", "поменяйте модель телефона в магазине 24/7"}, // 21
    {25, 1, THE_FAMILY_QUEST, "Семья", "выполните любое семейное задание (/gps - Прочее - Семейные задания)"}, // 22
    {25, 10_000, THE_DELIVERY, "Доставка", "заработайте доставщиком продуктов / пиццы 10 000"valute_title_""}, // 23
    {25, 1, THE_GYM, "Спортивный зал", "начните тренировку в спортивном зале (/gps - Бизнесы - Спорт. зал)"}, // 24
    {25, 1, THE_TOWCAR, "TowCar", "посетите бизнес TowCar"}, // 25
    {25, 1, THE_FLY_LIC, "Лицензия", "получите лицензию на воздушный транспорт"}, // 26
    {25, 10_000, THE_FUEL_DELIVERY, "Бензовоз", "заработайте развозчиком топлива 10 000"valute_title_""}, // 27
	
   	{25, 1, THE_GIVE, "Помощь", "передайте игроку аптечку, наркотики, медицинские препараты"}, // 28
    {25, 1, THE_ROULETTE, "Рулетка", "прокрутите рулетку (/roulette)"}, // 29
    {25, 1, THE_PAINT_VEHICLE, "Покраска", "перекрасьте транспорт в тюнинг центре"}, // 30
    {25, 1, THE_PANTERA_VEHICLE, "Pantera Security", "установите защиту на транспорт в Pantera Security"}, // 31
    {25, 1, THE_PERFOMANCE_VEHICLE, "Характеристики", "прокачайте характеристики транспорта в Perfomance Tuning"}, // 32
    {25, 1, THE_FUEL, "Канистра", "приобретите канистру на любой заправочной станции"}, // 33
    {25, 1, THE_MEDIC, "Болезни", "обследуйтесь у врача"}, // 34
    {25, 40, THE_FISHING, "Рыбалка", "поймайте 40 кг. рыбы"}, // 35
    {25, 1, THE_FILLING, "Бензин", "зарпавьте любой транспорт канистрой или на заправочной станции"}, // 36
    {25, 1, THE_FAMILY_AIRDROP, "AirDrop", "перехватите семейную посылку"}, // 37
    {25, 1, THE_TAX, "Налоги", "оплатите налоги в банке или банкомате"}, // 38
    {25, 1, THE_COIN, "Орёл и решка", "сыграйте в орла и решку в любом клубе / баре"}, // 39
    {25, 1, THE_PERK, "Перки", "прокачайте любой перк (/mm - 1 - 10)"}, // 40
    {25, 1, THE_FAMILY_DEALER, "Поставка", "перехватите семейную поставку"} // 41
};

#define MAX_PLAYER_EP_QUEST 6
new gPlayerEventQuestStatus [ MAX_PLAYERS ] [ MAX_PLAYER_EP_QUEST ] ;
new gPlayerEventQuestProgress [ MAX_PLAYERS ] [ MAX_PLAYER_EP_QUEST ] ;
new ClearPlayerEventProgress [ MAX_PLAYER_EP_QUEST ] = { 0, ... } ;
new gPlayerPA [ MAX_PLAYERS ], gPlayerPAPrem [ MAX_PLAYERS ] ;
new bool: gPlayerLoadedBattle [ MAX_PLAYERS ] ;
new bool: gPlayerEventGlobalAccept [ MAX_PLAYERS ] ;
new gPlayerEventGlobalProgress [ MAX_PLAYERS ] ;

new EventGlobalQuest, EventGlobalReset ;

enum ENUM_GLOBAL_QUESTS_DATA
{
	goProgress,
	goName [ 32 ],
	goDescription [ 256 ],
	goTarget [ 128 ],
	goPriseModel [ 3 ],
	goPriseType [ 3 ],
	goPriseCount [ 3 ]
} ;

new GlobalQuestData [ 8 ] [ ENUM_GLOBAL_QUESTS_DATA ] =
{
	{ 3, "Кейсы дальнобойщика", "Отправляйтесь в Мэрию для устройства на работу. Затем отправляйтесь в одну из транспортных компаний. Арендуйте фуру и развозите заказы.", "Откройте 3 кейса дальнобойщика", { 54, 45, 58 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_RENDER_OBJECT, BATTLEPASS_RENDER_OBJECT }, { 100, 2, 1 } },
	{ 3, "Порт контейнеров", "Выйграйте аукцион контейнеров в одном из портов. (/gps - Важные места)", "Выйграйте в аукционе 3 раза", { 54, 24, 2 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_NO_RENDER, BATTLEPASS_RENDER_OBJECT }, { 100, 1, 1 } },
	{ 100, "Рыбацкие угодья", "Пришло время порыбачить! Отправляйтесь в магазин для охоты и рыбалки, купите удочку и отправляйтесь рыбачить.", "Поймайте 100 кг рыбы", { 54, 8113, -1 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_NO_RENDER, -1 }, { 100, 1, -1 } },
	{ 1, "Рейд предприятия", "Вам необходимо вступить в семью 5го уровня и принять участие в рейде предприятия.", "Рейд одного предприятия", { 54, 129, -1 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_NO_RENDER, -1 }, { 100, 1, -1 } },
	{ 25, "Городская свалка", "Отправляйтесь на городску свалку (/gps) и копайтесь в мусоре.", "Откойпате 25 предметов", { 54, 132, -1 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_NO_RENDER, -1 }, { 100, 1, -1 } },
	{ 3, "Контрабанда", "Вам необходимо вступить в семью и принять участие в захвате 3ёх поставок.", "Захватите 3 поставки", { 54, 28, -1 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_NO_RENDER, -1 }, { 100, 1, -1 } },
	{ 1000, "Шахта", "Отправляйтесь в пригород Эдово и устройтесь на шахту.", "Соберите 1000 кг руды на шахте", { 54, 23, 54 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_RENDER_OBJECT, BATTLEPASS_RENDER_OBJECT }, { 100, 1, -1 } },
	{ 20, "Доставка продуктов", "Устройтесь в Мэрии развозчиком продуктов и возьми на стоянке фуру.", "Развезите продукты в 20 бизнесов", { 54, 45, 2 }, { BATTLEPASS_NO_RENDER, BATTLEPASS_RENDER_OBJECT, BATTLEPASS_RENDER_OBJECT }, { 100, 1, 1 } }
} ;

stock give_global_quest ( playerid, _q_id, _progress )
{
	if ( EventGlobalQuest != _q_id ) return 1 ;
	if ( gPlayerEventGlobalProgress [ playerid ] > GlobalQuestData [ _q_id ] [ goProgress ] ) return 1 ;

	gPlayerEventGlobalProgress [ playerid ] += _progress ;
	update_int_sql ( playerid, "u_eprogress", gPlayerEventGlobalProgress [ playerid ] ) ;
	return 1 ;
}

new NameTopLeader [ 100 ] [ MAX_PLAYER_NAME ] ;
new LevelTopLeader [ 100 ] ;
new ExpTopLeader [ 100 ] ;
new PremiumTopLeader [ 100 ] ;

//#include 									<custom/battlepass_new>
//#include 									<custom/battlepass>

#include 									"modules/other/crmp/m_newbie_pass.pwn"

stock update_battlepass_progress ( playerid, quest, progress, _id )
{
	if ( stop_event == 1 ) return 1 ;

	if ( gPlayerEventQuestProgress [ playerid ] [ _id ] < QuestData [ quest ] [ eqProgress ] )
	{
		gPlayerEventQuestProgress [ playerid ] [ _id ] += progress ;

		new scm_string [ 68 + 32 ] ;
		if ( gPlayerEventQuestProgress [ playerid ] [ _id ] == QuestData [ quest ] [ eqProgress ] )
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", gPlayerEventQuestProgress [ playerid ] [ _id ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		else if ( gPlayerEventQuestProgress [ playerid ] [ _id ] > QuestData [ quest ] [ eqProgress ] )
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", QuestData [ quest ] [ eqProgress ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		else 
		{
			format ( scm_string, sizeof scm_string, "Вы выполнили часть задания. {"#cWH"}Прогресс: %d из %d{"#cOR"}.", gPlayerEventQuestProgress [ playerid ] [ _id ], QuestData [ quest ] [ eqProgress ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
		}
		
		if ( gPlayerEventQuestProgress [ playerid ] [ _id ] >= QuestData [ quest ] [ eqProgress ] )
		{
			set_battlepass_levelup ( playerid, QuestData [ quest ] [ eqEPassEXP ] ) ;
				
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы успешно выполнили задание {"#cWH"}\"%s\"{"#cOR"}!", QuestData [ quest ] [ eqName ] ) ;
			SendClientMessage ( playerid, col_orange, scm_string ) ;
			
			gPlayerBattlePassQuest [ playerid ] += 1 ;
			
			battlepass_check_limit ( playerid ) ;
		}
		save_battlepass_progress ( playerid ) ;
	}
	return 1 ;
}

stock give_event_progress ( playerid, params_quest, params_amount )
{
	give_newbie_progress ( playerid, params_quest, params_amount ) ;
	if ( stop_event == 1 ) return 1 ;
	
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		if ( gPlayerEventQuestStatus [ playerid ] [ i ] != params_quest ) continue ;
		if ( gPlayerEventQuestProgress [ playerid ] [ i ] >= QuestData [ params_quest ] [ eqProgress ] ) continue ;
		
		update_battlepass_progress ( playerid, params_quest, params_amount, i ) ;
		break ;
	}
	return 1 ;
}

stock battlepass_check_limit ( playerid )
{
	if ( gPlayerBattlePassLimit [ playerid ] == false ) return 1 ;
	
	new _count = 0, _q_id ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		_q_id = gPlayerEventQuestStatus [ playerid ] [ i ] ;
		if ( gPlayerEventQuestProgress [ playerid ] [ i ] < QuestData [ _q_id ] [ eqProgress ] ) continue ;
		
		_count ++ ;
	}
	
	if ( _count == MAX_PLAYER_EP_QUEST )
	{
		gettime_clear_eventpass ( playerid ) ;
	}
	return 1 ;
}

stock save_battlepass_progress ( playerid )
{
	global_string [ 0 ] = EOS ;
	format ( global_string, 700, "UPDATE `users` SET `u_eventpass` = '%d|%d|%d|%d|%d|%d', `u_eventpass_progress` = '%d|%d|%d|%d|%d|%d', `u_equest` = '%d' WHERE `u_id` = '%d' LIMIT 1",
	gPlayerEventQuestStatus [ playerid ] [ 0 ], gPlayerEventQuestStatus [ playerid ] [ 1 ], gPlayerEventQuestStatus [ playerid ] [ 2 ],
	gPlayerEventQuestStatus [ playerid ] [ 3 ], gPlayerEventQuestStatus [ playerid ] [ 4 ], gPlayerEventQuestStatus [ playerid ] [ 5 ],
	gPlayerEventQuestProgress [ playerid ] [ 0 ], gPlayerEventQuestProgress [ playerid ] [ 1 ], gPlayerEventQuestProgress [ playerid ] [ 2 ],
	gPlayerEventQuestProgress [ playerid ] [ 3 ], gPlayerEventQuestProgress [ playerid ] [ 4 ], gPlayerEventQuestProgress [ playerid ] [ 5 ],
	gPlayerBattlePassQuest [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, global_string ) ;
	return 1 ;
}

stock update_twelve_hour_eventpass ( )
{	
	if ( ++ EventDay > MAX_EVENT_DURATION )
		EventDay = MAX_EVENT_DURATION, stop_event = 1 ;
	
	new query_string [ 64 + 4 + 4 ] ;
	format(query_string, sizeof query_string, "UPDATE `bp_event` SET `event_day` = '%d', `event_stop` = '%d'", EventDay, stop_event ) ;
	mysql_tquery ( sql_connection, query_string ) ;
	return 1 ;
}

stock show_eventpass ( playerid )
{
	if ( p_info [ playerid ] [ level ] < 3 )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Event Pass доступен с 3-го уровня!" ) ;

	global_string [ 0 ] = EOS ;
	new listitem [ 32 + ( - 2 + MAX_BATTLE_ITEM_NAME ) ], BPLevel = gPlayerBattlePassLVL { playerid } ;

	format ( global_string, sizeof global_string, "{"#cWH"}Уровень Event Pass: {F1C40F}%d{"#cWH"}\nОчки Event Pass: {F1C40F}%d{"#cWH"} из 100\n\n", BPLevel, gPlayerBattlePassEXP { playerid } ) ;

	new _max_lvl = ( BPLevel + 10 > MAX_BATTLE_PASS_ITEMS ) ? ( MAX_BATTLE_PASS_ITEMS ) : ( MAX_BATTLE_PASS_ITEMS - 10 ) ;
	for ( new i = BPLevel ; i < _max_lvl ; i ++ )
	{
		if ( BPLevel > i )
			format(listitem, sizeof listitem, "{"#cWH"}%d Уровень\tПриз: %s\n", i + 1, BattlePass [ i ] [ bpiName ], BattlePass [ i ] [ bpiAmount ] ) ;

		else if ( BPLevel == i )
			format(listitem, sizeof listitem, "{F1C40F}%d Уровень\tПриз: %s\n", i + 1, BattlePass [ i ] [ bpiName ], BattlePass [ i ] [ bpiAmount ] ) ;

		else
			format(listitem, sizeof listitem, "{353b48}%d Уровень\tПриз: %s\n", i + 1, BattlePass [ i ] [ bpiName ], BattlePass [ i ] [ bpiAmount ] ) ;

		strcat ( global_string, listitem ) ;
	}
	show_dialog ( playerid, d_epass_return, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Event Pass", global_string, "Назад", "" ) ;
	return 1 ;
}

stock show_daily_quests ( playerid )
{
	if ( p_info [ playerid ] [ level ] < 3 )
		return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Квесты доступны с 3-го уровня!" ) ;

	new
		listitem [ MAX_QUEST_NAME + 24 ],
		questProgress = -1 ;

	global_string [ 0 ] = EOS ;
	strcat ( global_string, "{"#cBL"}Задание:\t{"#cBL"}Прогресс:\n" ) ;
	for ( new i = 0 ; i < MAX_PLAYER_EP_QUEST ; i ++ )
	{
		questProgress = gPlayerEventQuestStatus [ playerid ] [ i ] ;

		format ( listitem, sizeof listitem, "%s\t{F1C40F}%d{"#cWH"}/%d\n", QuestData [ questProgress ] [ eqName ], gPlayerEventQuestProgress [ playerid ] [ i ], QuestData [ questProgress ] [ eqProgress ] ) ;
		strcat ( global_string, listitem ) ;
	}

	format ( listitem, sizeof listitem, "{"#cBHD"}Ежедневные задания {"#cWH"}| День {"#cBHD"}%d", EventDay ) ;
	show_dialog ( playerid, d_event_quest, DIALOG_STYLE_TABLIST_HEADERS, listitem, global_string, "Далее", "Закрыть" ) ;
	return 1 ;
}

/*stock get_daily_quest ( playerid )
{
	new
		questProgress = -1 ;

	if ( EventDay > MAX_EVENT_DURATION )
		EventDay = MAX_EVENT_DURATION ;

	for ( new items = ( EventDay - 1 ) * 4 + 4, i = items - 4 ; i < items ; i ++ )
	{
		if ( gPlayerEventQuestStatus [ playerid ] [ i ] == 1 )
			questProgress = i ;
	}

	return questProgress ;
}*/

stock set_battlepass_levelup ( playerid, _bexp )
{
	new
		BPLevel = gPlayerBattlePassLVL { playerid } ;

	if ( BPLevel == MAX_BATTLE_PASS_ITEMS )
		return 1 ;

	new _bexp_dop = 0 ;
	if ( gPlayerBattlePassPrem [ playerid ] ) _bexp_dop += floatround ( _bexp * 1.5 ) ;
	#if defined m_valentine
		if ( ValentineGettime ( ) == 1 ) _bexp_dop += floatround ( _bexp * 1.2 ) ;
	#endif
	gPlayerBattlePassEXP { playerid } += _bexp + _bexp_dop ;

	new BPExp = gPlayerBattlePassEXP { playerid }, string [ 102 + ( 4 * 9 ) ] ;
	if ( BPExp >= 100 )
	{
		gPlayerBattlePassEXP { playerid } 	= BPExp - 100 ;
		BPLevel 							= gPlayerBattlePassLVL { playerid } += 1 ;
		new BPCoins							= ( BPLevel * 2 ) + ( random ( 100 ) + 10 ) ;
		
		gPlayerBattlePassCoins [ playerid ] += BPCoins ;
		
		if ( player_device { playerid } != 2 )
		{
			format ( string, sizeof string, "{"#cWH"}Ваш уровень Event Pass повысился.\n\nВаша награда в Event Pass: {F1C40F}%s\n{"#cWH"}Получено "event_coins": {F1C40F}%d", BattlePass [ BPLevel ] [ bpiName ], BPCoins ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Event Pass", string, "Получить", "" ) ;

			switch ( BattlePass [ BPLevel ] [ bpiType ] )
			{
				case BP_NONE:
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошабка при выдаче приза. Идентификатор: неизвестный приз." ) ;
				}
				case BP_SKIN:
				{
					SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете скин!" ) ;

					give_inventory ( playerid, BattlePass [ BPLevel ] [ bpiAmount ], 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
					format ( string, sizeof string, "* Вам был добавлен предмет 'Одежда #%d'. Откройте инвентарь, используйте /mm или радиальное меню.", BattlePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_yellow, string ) ;
				}
				case BP_MONEY:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d"valute_title"{"#cSucces"}.", BattlePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;

					give_money ( playerid, BattlePass [ BPLevel ] [ bpiAmount ] ) ;
					insert_money_log ( playerid, INVALID_PLAYER_ID, BattlePass [ BPLevel ] [ bpiAmount ], "приз за EventPass" ) ;
				}
				case BP_SECRET:
				{
					if ( event_count >= 1 )
					{
						event_count -- ;
						
						new sql_string [ 100 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `bp_event` SET `event_count` = '%d' LIMIT 1", event_count ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
						
						new _car_id ;
						switch ( random ( 6 ) )
						{
							/*case 0: _car_id = 405 ;
							case 1: _car_id = 419 ;
							case 2: _car_id = 575 ;
							case 3: _car_id = 576 ;
							case 4: _car_id = 411 ;
							case 5: _car_id = 409 ;*/
							case 0: _car_id = 3322 ;
							case 1: _car_id = 3322 ;
							case 2: _car_id = 3323 ;
							case 3: _car_id = 3323 ;
							case 4: _car_id = 3324 ;
							case 5: _car_id = 3324 ;
						}
						veh_prise_create ( playerid, 0, _car_id ) ;
						
						new scm_string [ 52 + 9 ] ;
						format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", GetVehicleNameEx ( INVALID_VEHICLE_ID, _car_id ) ) ;
						SendClientMessage ( playerid, col_succes, scm_string ) ;
					}
					else
					{
						new scm_string [ 52 + 9 ] ;
						format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", BattlePass [ BPLevel ] [ bpiAmount ] ) ;
						SendClientMessage ( playerid, col_succes, scm_string ) ;
						
						give_player_donate ( playerid, BattlePass [ BPLevel ] [ bpiAmount ], 2 ) ;
					}
				}
				case BP_EXP:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d EXP{"#cSucces"}.", BattlePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					rewards_exp ( playerid, BattlePass [ BPLevel ] [ bpiAmount ] ) ;
				}
				case BP_DONATE:
				{
					new scm_string [ 52 + 9 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", BattlePass [ BPLevel ] [ bpiAmount ] ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
						
					give_player_donate ( playerid, BattlePass [ BPLevel ] [ bpiAmount ], 2 ) ;
				}
				case BP_BRONZE_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2045, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_SILVER_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2055, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_GOLD_ROULETTE:
				{
					new scm_string [ 52 + 9 ], _rou_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _rou_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
					
					give_inventory ( playerid, 2125, _rou_count, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ACCS:
				{
					new _acc_id = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _acc_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _acc_id ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_FAMILY:
				{
					new _er_count = BattlePass [ BPLevel ] [ bpiAmount ] ;

					give_inventory (
						playerid,
						ITEM_FAMILY_TALON,
						_er_count,
						0,
						"",
						"",
						NUMBERPLATE_TYPE_NONE,
						0,
						-1
					) ;
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "family_title"{"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_SLOT_CAR:
				{
					SendClientMessage ( playerid, col_succes, "Поздравляем! Вы получаете {"#cWH"}+1 слот для т/с{"#cSucces"}." ) ;
					
					p_info [ playerid ] [ max_veh ] ++ ;
					update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
				}
				case BP_TREASURE:
				{
					new _er_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					
					new _treasure_card ;
					if ( p_info [ playerid ] [ treasure_card ] > gettime ( ) )
					{
						_treasure_card = _er_count * 3600 ;

						p_info [ playerid ] [ treasure_card ] += _treasure_card ;
						update_int_sql ( playerid, "u_treasure_card", p_info [ playerid ] [ treasure_card ] ) ;
					}
					else
					{
						_treasure_card = SetElapsedTime ( gettime ( ), _er_count, CONVERT_TIME_TO_HOURS ) ;

						p_info [ playerid ] [ treasure_card ] = _treasure_card ;
						update_int_sql ( playerid, "u_treasure_card", _treasure_card ) ;
					}
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}карту кладов (%d ч.){"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_CRIME:
				{
					new _er_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					
					p_info [ playerid ] [ crime_plus ] = true ;
					if ( p_info [ playerid ] [ crime_plus_date ] > gettime ( ) ) p_info [ playerid ] [ crime_plus_date ] += _er_count * 3600 ;
					else p_info [ playerid ] [ crime_plus_date ] = SetElapsedTime ( gettime ( ), _er_count, CONVERT_TIME_TO_DAYS ) ;
					update_int_sql ( playerid, "u_crime_plus_date", p_info [ playerid ] [ crime_plus_date ] ) ;
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}Crime Plus (%d ч.){"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
				}
				case BP_DONATE_BONUS:
				{
					new _er_count = BattlePass [ BPLevel ] [ bpiAmount ] ;
					
					new scm_string [ 100 ] ;
					format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _er_count ) ;
					SendClientMessage ( playerid, col_succes, scm_string ) ;
							
					give_player_donate ( playerid, _er_count, 1 ) ;
				}
				case BP_DETAIL_CRAFT:
				{
					new _bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _bpiAmount, random ( 15 ) + 10, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
					SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
				}
				case BP_ROULETTE_ITEM_0:
				{
					new _bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ROULETTE_ITEM_1:
				{
					new _bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_ROULETTE_ITEM_2:
				{
					new _bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, 2125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				case BP_INVENTORY:
				{
					new _bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
					give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
						
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
			}
		}
		else
		{
			if ( BPLevel < MAX_BATTLE_PASS_ITEMS )
			{
				global_string [ 0 ] = EOS ;
				if ( gPlayerBattlePassPrem [ playerid ] )  format ( global_string, 256, "{"#cWH"}Ваш уровень Event Pass повысился.\n\nВаша награда в Event Pass: {F1C40F}%s\n{"#cWH"}Получено "event_coins": {F1C40F}%d", BattlePass [ BPLevel ] [ bpiPremName ], BPCoins ) ;
				else format ( global_string, 256, "{"#cWH"}Ваш уровень Event Pass повысился.\n\nВаша награда в Event Pass: {F1C40F}%s\n{"#cWH"}Получено "event_coins": {F1C40F}%d", BattlePass [ BPLevel ] [ bpiName ], BPCoins ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Event Pass", global_string, "Получить", "" ) ;
				
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Используйте /einfo для получения приза." ) ;
			}
		}
	}
	string [ 0 ] = EOS ;
	format ( string, sizeof string, "UPDATE `users` SET `u_epass` = '%d', `u_eexp` = '%d', `u_ecoins` = '%d' WHERE `u_id` = '%d' LIMIT 1", gPlayerBattlePassLVL { playerid }, gPlayerBattlePassEXP { playerid }, gPlayerBattlePassCoins [ playerid ], p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, string ) ;
	return 1 ;
}

stock show_upgrade_eventpass ( playerid, _lvl )
{
	static const _lvl_price [ ] = { 200, 800, 2700, 499 } ;
	static const _buy_lvl [ ] = { 1, 5, 15, 25 } ;

	if ( ! get_player_donate ( playerid, _lvl_price [ _lvl ], 2 ) )
	{
		SetBattleDialog ( playerid, "Ошибка", "У Вас недостаточно "donate_title".", "Принять", "" ) ;
		return 1 ;
	}
	
	if ( gPlayerBattlePassLVL { playerid } + _buy_lvl [ _lvl ] > MAX_BATTLE_PASS_ITEMS )
	{
		SetBattleDialog ( playerid, "Ошибка", "Вы не можете превысить максимальный уровень Event Pass.", "Принять", "" ) ;
		return 1 ;
	}

	set_player_donate ( playerid, _lvl_price [ _lvl ], 2 ) ;
	insert_donate_log ( playerid, INVALID_PLAYER_ID, _lvl_price [ _lvl ], p_info [ playerid ] [ donate ], "(donate) Event Pass" ) ;

	new _i_lvl = _buy_lvl [ _lvl ] ;
	for ( new i = 0 ; i < _i_lvl ; i ++ )
	{
		new
			BPLevel = gPlayerBattlePassLVL { playerid } ;

		new
			BPExp = ( gPlayerBattlePassEXP { playerid } += 100 ),
			string [ 129 + MAX_BATTLE_ITEM_NAME ] ;

		if ( BPExp >= 100 )
		{
			gPlayerBattlePassEXP { playerid } 	= BPExp - 100 ;
			BPExp 								-= 100 ;
			BPLevel 							= gPlayerBattlePassLVL { playerid } += 1 ;
			new BPCoins							= ( BPLevel * 2 ) + ( random ( 100 ) + 10 ) ;
			
			gPlayerBattlePassCoins [ playerid ] += BPCoins ;
			update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
			
			format ( string, sizeof string, "UPDATE `users` SET `u_epass` = '%d', `u_eexp` = '%d' WHERE `u_id` = '%d' LIMIT 1", gPlayerBattlePassLVL { playerid }, BPExp, p_info [ playerid ] [ id ] ) ;
			mysql_tquery ( sql_connection, string ) ;
		}
	}
	SetBattleDialog ( playerid, "Повышение уровня", "Вы успешно повысили Ваш уровень Event Pass.", "Принять", "" ) ;
	return 1 ;
}

stock show_premium_eventpass ( playerid )
{
	new _e_prem_price = 499 ;
	if ( ! get_player_donate ( playerid, _e_prem_price, 2 ) )
	{
		SetBattleDialog ( playerid, "Ошибка", "У Вас недостаточно "donate_title".", "Принять", "" ) ;
		return 1 ;
	}

	set_player_donate ( playerid, _e_prem_price, 2 ) ;
	insert_donate_log ( playerid, INVALID_PLAYER_ID, _e_prem_price, p_info [ playerid ] [ donate ], "(donate) Event Pass premium" ) ;
	
	gPlayerBattlePassPrem [ playerid ] = true ;
	gPlayerPAPrem [ playerid ] = 0 ;
	
	static const _str [ ] = "UPDATE `users` SET `u_epremium` = '1', `u_epriseuse_prem` = '0' WHERE `u_id` = '%d' LIMIT 1" ;
	new string [ sizeof _str + 9 ] ;
	format ( string, sizeof string, _str, p_info [ playerid ] [ id ] ) ;
	mysql_tquery ( sql_connection, string ) ;
	
	SetBattleDialog ( playerid, "Premium", "Вы успешно приобрели Premium-статус.", "Принять", "" ) ;
	return 1 ;
}

stock give_eventpass_prise ( playerid, bool: status )
{
	new BPLevel, _bpiType, _bpiAmount, bool: _bpiPrem = gPlayerBattlePassPrem [ playerid ] ;
	if ( status && _bpiPrem )
	{
		BPLevel = gPlayerPAPrem [ playerid ] ;
		_bpiType = BattlePass [ BPLevel ] [ bpiPremType ] ;
		_bpiAmount = BattlePass [ BPLevel ] [ bpiPremAmount ] ;
	}
	else
	{
		BPLevel = gPlayerPA [ playerid ] ;
		_bpiType = BattlePass [ BPLevel ] [ bpiType ] ;
		_bpiAmount = BattlePass [ BPLevel ] [ bpiAmount ] ;
	}
	switch ( _bpiType )
	{
	    case BP_NONE:
		{
			SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Произошла ошибка при выдаче приза. Идентификатор: неизвестный приз." ) ;
		}
		case BP_SKIN:
		{
			new sql_string [ 128 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_SKIN) #%d", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
		
            SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете скин!" ) ;
			   
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			format ( sql_string, sizeof sql_string, "* Вам был добавлен предмет 'Одежда #%d'. Откройте инвентарь, используйте /mm или радиальное меню.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_yellow, sql_string ) ;
		}
		case BP_CAR:
		{
			new sql_string [ 128 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_CAR) #%d", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
			
            SendClientMessage ( playerid, col_succes, !"Поздравляем! Вы получаете транспорт!" ) ;
			   
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, sql_string ) ;
		}
		case BP_MONEY:
		{
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d"valute_title"{"#cSucces"}.", _bpiAmount ) ;
            SendClientMessage ( playerid, col_succes, scm_string ) ;

            give_money ( playerid, _bpiAmount ) ;
			insert_money_log ( playerid, INVALID_PLAYER_ID, _bpiAmount, "приз за EventPass" ) ;
		}
		case BP_SECRET:
		{
			new sql_string [ 100 ] ;
			format ( sql_string, sizeof sql_string, "%s (BP_SECRET)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, sql_string ) ;
			
			if ( event_count >= 1 )
			{
				event_count -- ;
				
				sql_string [ 0 ] = EOS ;
				format ( sql_string, sizeof sql_string, "UPDATE `bp_event` SET `event_count` = '%d' LIMIT 1", event_count ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
				
				if ( status && _bpiPrem )
				{
					switch ( random ( 3 ) )
					{
						case 0:
						{
							give_inventory ( playerid, 8249, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 8249 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;

							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", get_accessorie_name ( 8249 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
						case 1:
						{
							give_inventory ( playerid, 4716, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 4716 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;
							
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", item_name ( 4716 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
						case 2:
						{
							give_inventory ( playerid, 3370, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 3370 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;
							
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", GetVehicleNameEx ( INVALID_VEHICLE_ID, 3370 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
					}
				}
				else
				{
					switch ( random ( 3 ) )
					{
						case 0:
						{
							give_inventory ( playerid, 8247, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 8247 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;
							
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", get_accessorie_name ( 8247 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
						case 1:
						{
							give_inventory ( playerid, 4679, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 4679 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;
							
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", item_name ( 4679 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
						case 2:
						{
							give_inventory ( playerid, 3365, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 3365 ) ) ;
							SendClientMessage ( playerid, col_yellow, sql_string ) ;
							
							sql_string [ 0 ] = EOS ;
							format ( sql_string, sizeof sql_string, "Поздравляем! Вы получаете {"#cWH"}%s{"#cSucces"}.", GetVehicleNameEx ( INVALID_VEHICLE_ID, 3365 ) ) ;
							SendClientMessage ( playerid, col_succes, sql_string ) ;
						}
					}
				}
			}
			else
			{
				new scm_string [ 52 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
				SendClientMessage ( playerid, col_succes, scm_string ) ;
				
				give_player_donate ( playerid, _bpiAmount, 2 ) ;
			}
		}
		case BP_EXP:
		{
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d EXP{"#cSucces"}.", _bpiAmount ) ;
            SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_EXP) %d EXP", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
			
			rewards_exp ( playerid, _bpiAmount ) ;
		}
		case BP_DONATE:
		{
            new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_DONATE) %d "donate_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
					
			give_player_donate ( playerid, _bpiAmount, 2 ) ;
		}
		case BP_BRONZE_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
		
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_SILVER_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
			
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_GOLD_ROULETTE:
		{
			if ( player_device { playerid } == 2 ) return SendClientMessage ( playerid, col_white, "{"#cBInfo"}* {"#cWH"}Откройте {"#cBInfo"}Event Pass {"#cWH"}и используйте рулетку." ) ;
			
			new scm_string [ 52 + 9 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d рулетку(ок){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
					
			give_inventory ( playerid, 2125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ACCS:
		{
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
			new scm_string [ 66 + 32 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете аксессуар {"#cWH"}\"%s\"{"#cSucces"}.", get_accessorie_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_ACCS) %s", p_info [ playerid ] [ name ], get_accessorie_name ( _bpiAmount ) ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_FAMILY:
		{
			give_inventory (
				playerid,
				ITEM_FAMILY_TALON,
				_bpiAmount,
				0,
				"",
				"",
				NUMBERPLATE_TYPE_NONE,
				0,
				-1
			) ;
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "family_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_FAMILY) %d "family_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_SLOT_CAR:
		{
			SendClientMessage ( playerid, col_succes, "Поздравляем! Вы получаете {"#cWH"}+1 слот для т/с{"#cSucces"}." ) ;
			
			p_info [ playerid ] [ max_veh ] ++ ;
			update_int_sql ( playerid, "u_maxveh", p_info [ playerid ] [ max_veh ] ) ;
			
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "%s (BP_SLOT_CAR)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_TREASURE:
		{
			new _treasure_card ;
			if ( p_info [ playerid ] [ treasure_card ] > gettime ( ) )
			{
				_treasure_card = _bpiAmount * 3600 ;

				p_info [ playerid ] [ treasure_card ] += _treasure_card ;
				update_int_sql ( playerid, "u_treasure_card", p_info [ playerid ] [ treasure_card ] ) ;
			}
			else
			{
				_treasure_card = SetElapsedTime ( gettime ( ), _bpiAmount, CONVERT_TIME_TO_HOURS ) ;

				p_info [ playerid ] [ treasure_card ] = _treasure_card ;
				update_int_sql ( playerid, "u_treasure_card", _treasure_card ) ;
			}
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}карту кладов (%d ч.){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
		}
		case BP_CRIME:
		{
			p_info [ playerid ] [ crime_plus ] = true ;
			if ( p_info [ playerid ] [ crime_plus_date ] > gettime ( ) ) p_info [ playerid ] [ crime_plus_date ] += _bpiAmount * 3600 ;
			else p_info [ playerid ] [ crime_plus_date ] = SetElapsedTime ( gettime ( ), _bpiAmount, CONVERT_TIME_TO_DAYS ) ;
			update_int_sql ( playerid, "u_crime_plus_date", p_info [ playerid ] [ crime_plus_date ] ) ;
				
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}Crime Plus (%d ч.){"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_CRIME)", p_info [ playerid ] [ name ] ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
		}
		case BP_DONATE_BONUS:
		{
			new scm_string [ 100 ] ;
			format ( scm_string, sizeof scm_string, "Поздравляем! Вы получаете {"#cWH"}%d "donate_title"{"#cSucces"}.", _bpiAmount ) ;
			SendClientMessage ( playerid, col_succes, scm_string ) ;
			
			scm_string [ 0 ] = EOS ;
			format ( scm_string, sizeof scm_string, "%s (BP_DONATE_BONUS) %d "donate_title"", p_info [ playerid ] [ name ], _bpiAmount ) ;
			WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
					
			give_player_donate ( playerid, _bpiAmount, 1 ) ;
		}
		case BP_DETAIL_CRAFT:
		{
			give_inventory ( playerid, _bpiAmount, random ( 15 ) + 10, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
			SendClientMessage ( playerid, col_yellow, !"* Предмет понадобится для крафта. ({"#cGRInfo"}/help - Крафт{FFFF00})" ) ;
		}
		case BP_ROULETTE_ITEM_0:
		{
			give_inventory ( playerid, 2045, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2045 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ROULETTE_ITEM_1:
		{
			give_inventory ( playerid, 2055, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2055 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_ROULETTE_ITEM_2:
		{
			give_inventory ( playerid, 2125, _bpiAmount, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( 2125 ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		case BP_INVENTORY:
		{
			give_inventory ( playerid, _bpiAmount, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _bpiAmount ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
	}
	return 1 ;
}

CMD:hud_cmd_2 ( playerid )
{
	new bool: status = false, bool: status2 = false ;
	if ( gNewBiePA [ playerid ] < MAX_BATTLE_PASS_ITEMS ) status = true ;
	if ( ( gPlayerPA [ playerid ] < MAX_BATTLE_PASS_ITEMS || gPlayerPAPrem [ playerid ] < MAX_BATTLE_PASS_ITEMS ) && stop_event != 1 ) status2 = true ;
	
	if ( status && status2 )
	{
		show_dialog ( playerid, d_event_select, DIALOG_STYLE_LIST, "{"#cBHD"}Event Pass", "{"#cBL"}1. {"#cWH"}Основной\n{"#cBL"}2. {"#cWH"}Приветственный", "Выбрать", "Закрыть" ) ;
	}
	else if ( ! status && status2 )
	{
		callcmd::einfo ( playerid ) ;
	}
	else if ( status && ! status2 )
	{
		callcmd::testbp ( playerid ) ;
	}
	return 1 ;
}

CMD:einfo ( playerid )
{
	if ( stop_event == 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Event Pass окончен." ) ;
	
	if ( player_device { playerid } != 2 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
			{"#cBL"}1. {"#cWH"}Информация\n\
			{"#cBL"}2. {"#cWH"}Event Pass\n\
			{"#cBL"}3. {"#cWH"}Ежедневные задания\n \n\
			{"#cGRDialog"}- {"#cWH"}"event_coins": {"#cGN"}%d шт.{"#cWH"}\n\
			{"#cGRDialog"}- {"#cWH"}Отметить торговца на GPS", gPlayerBattlePassCoins [ playerid ] ) ;
		show_dialog ( playerid, d_event_info, DIALOG_STYLE_LIST, "{"#cBHD"}Информация", global_string, "Далее", "Отмена" ) ;
	}
	else 
	{
		if ( p_info [ playerid ] [ member ] ) give_event_progress ( playerid, THE_FRACTION, 1 ) ;
		if ( p_info [ playerid ] [ family ] ) give_event_progress ( playerid, THE_FAMILY, 1 ) ;
		if ( p_info [ playerid ] [ fly_lic ] ) give_event_progress ( playerid, THE_FLY_LIC, 1 ) ;
		
		/*new _str [ 24 ] ;
		format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
		SetMainPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
		SetAddBpItem ( playerid, 10 ) ;
	
		toggle_controlable ( playerid, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;*/
		
		new _end_str [ 48 ] ;
		format ( _end_str, sizeof _end_str, "Сезон закончится через %d дней", MAX_EVENT_DURATION - EventDay ) ;
		if ( ! gPlayerBattlePassPrem [ playerid ] ) bpShow ( playerid, _end_str, true, "Купить улучшенный пропуск", "криминальный" ) ;
		else bpShow ( playerid, _end_str, true, "Купить +1 уровень", "криминальный" ) ;
		selectBattlePass ( playerid, 0 ) ;
		
		new _count = 0, _id ;
		for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
		{
			_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
			if ( _id == -1 ) continue ;
			if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
			
			_count ++ ;
		}
		
		new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
		format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
		if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
		else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
		format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
		if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
		else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
		bpAddBPItem ( playerid, 10 ) ;
		
		bpAddGuideMainLayout ( playerid ) ;
		
		toggle_controlable ( playerid, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	}
	return 1 ;
}

stock show_gps_event_actor ( playerid )
{
	SetPlayerRaceCheckpoint ( playerid, 1, event_actor_position [ 0 ], event_actor_position [ 1 ], event_actor_position [ 2 ], 0.0, 0.0, 0.0, 2.0 ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
	is_gps_used { playerid } = 1 ;
	return 1 ;
}

stock epass_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
	#pragma unused inputtext
	switch ( dialogid )
	{
		case d_event_select:
		{
			if ( ! response ) return 1 ;
			
			if ( listitem == 0 ) callcmd::einfo ( playerid ) ;
			else callcmd::testbp ( playerid ) ;
			return 1 ;
		}
		case d_event_trade:
		{
			if ( ! response ) return 1 ;
			
			if ( gPlayerBattlePassCoins [ playerid ] < event_trade [ listitem ] [ event_price ] )
				return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно "event_coins"." ) ;
			
			gPlayerBattlePassCoins [ playerid ] -= event_trade [ listitem ] [ event_price ] ;
			update_int_sql ( playerid, "u_ecoins", gPlayerBattlePassCoins [ playerid ] ) ;
			
			new query_string [ 92 + 46 + 9 ] ;
			format ( query_string, sizeof query_string, "{"#cGInfo"}* {"#cWH"}Вы приобрели {"#cGN"}%s {"#cWH"}за {"#cGN"}%d "event_coins"{"#cWH"}.",
			event_trade [ listitem ] [ event_name ], event_trade [ listitem ] [ event_price ] ) ;
			SendClientMessage ( playerid, col_white, query_string ) ;
			
			new _inv_type = event_trade [ listitem ] [ event_inv_type ] ;
			if ( _inv_type == GIVE_TYPE_INVENTORY )
			{
				give_inventory ( playerid, event_trade [ listitem ] [ event_prise ], 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( event_trade [ listitem ] [ event_prise ] ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
			else if ( _inv_type == GIVE_TYPE_ACESSORIES )
			{
				give_inventory ( playerid, event_trade [ listitem ] [ event_prise ], 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
				global_string [ 0 ] = EOS ;
				format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( event_trade [ listitem ] [ event_prise ] ) ) ;
				SendClientMessage ( playerid, col_yellow, global_string ) ;
			}
			
			format ( query_string, sizeof query_string, "%s приобрел(а) %s за "event_coins".", p_info [ playerid ] [ name ], event_trade [ listitem ] [ event_name ] ) ;
			WriteLogs ( playerid, -1, TYPE_LOG_EVENTTRADE, query_string ) ;
			return 1 ;
		}
		case d_event_info:
		{
			if ( ! response )
				return 1 ;

			switch ( listitem )
			{
				case 0:
				{
					show_dialog ( playerid, d_epass_return, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "\
					{"#cOR"}Event Pass{"#cWH"} - это Уникальное двух недельное мероприятие\n\n\
					{"#cWH"}Мы подготовили для Вас очередную партию квестов которые Вам следует обязательно пройти,\n\
					ведь за них Вы можете получить не только денежные средства, но и массу редких и уникальных вещей\n\
					За все пройденные квесты Вы сможете получить: до "event_pass_info"\n\
					{14A3FF}Важная информация!\n\n\
					{"#cWH"}Каждый день на протяжении двух недель на сервере будут появлятьca по четыре новых задания\n\
					Мы назвали их \"Ежедневные задания\" за каждое из которых Вы будете получать очки опыта и в последствии\n\
					прокачивать свой уровень Event Pass, у каждого уровня свои призы! {"#cOR"}(/einfo)", "Назад", "");
				}
				case 1: return show_eventpass ( playerid ) ;
				case 2: return show_daily_quests ( playerid ) ;
				case 3, 4: return callcmd::einfo ( playerid ) ;
				case 5: return show_gps_event_actor ( playerid ) ;
			}
			return 1 ;
		}
		case d_epass_return:
		{
			callcmd::einfo ( playerid ) ;
			return 1 ;
		}
		case d_event_quest:
		{
			if ( ! response )
				return callcmd::einfo ( playerid ) ;

			listitem = gPlayerEventQuestStatus [ playerid ] [ listitem ] ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 200, "{"#cGRDialog"}Задача: {"#cWH"}%s\n\n{"#cGRDialog"}Награда:\n{"#cWH"}%d очков опыта Event Pass", QuestData [ listitem ] [ eqDescription ], QuestData [ listitem ] [ eqEPassEXP ] ) ;
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Ежедневное задание", global_string, "Закрыть", "" ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock show_event_pass ( playerid )
{
	  show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", "\
	  {"#cOR"}Event Pass{"#cWH"} - это двухнедельная квестовая линия\n\n\
	  {"#cWH"}Мы подготовили для Вас очередную партию квестов которые Вам следует обязательно пройти,\n\
	  ведь за них Вы можете получить не только денежные средства, но и массу редких и уникальных вещей\n\
	  За все пройденные квесты Вы сможете получить: до "event_pass_info"", "Назад", "" ) ;
	  return 1 ;
}

stock show_event_trade ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ] ;
	for ( new i = 0 ; i < MAX_TRADE_ITEM ; i ++ )
	{
		format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cWH"}%s\t%d "event_coins"\n", i + 1, event_trade [ i ] [ event_name ], event_trade [ i ] [ event_price ] ) ;
		strcat ( global_string, line_string ) ;
	}
	
	line_string [ 0 ] = EOS ;
	format ( line_string, sizeof line_string, "{"#cBHD"}У Вас {"#cWH"}%d {"#cBHD"}"event_coins"", gPlayerBattlePassCoins [ playerid ] ) ;
	show_dialog ( playerid, d_event_trade, DIALOG_STYLE_TABLIST, line_string, global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock epass_EnterDynamicArea ( playerid, areaid )
{
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		switch ( area_info [ areaid ] [ a_type ] )
		{
			case area_type_eventpass:
			{
				if ( player_device { playerid } == 2 )
					send_check_cinfo ( playerid, "Лавка для обмена "event_coins"", 1, -1, CINFO_EVENTACTOR_ID, PICTURE_INFO_SUCESS, "Обменник", "" ) ;
				
				else
					show_event_trade ( playerid ) ;
				return 1 ;
			}
		}
	}
	return 0 ;
}

stock epass_LeaveDynamicArea ( playerid, areaid )
{
	switch ( area_info [ areaid ] [ a_type ] )
	{
		case area_type_eventpass:
		{
			clear_check_info ( playerid, CINFO_EVENTACTOR_ID ) ;
			return 1 ;
		}
	}
	return 0 ;
}

CMD:eptest ( playerid )
{
    if ( admin_info [ playerid ] [ admin ] < 8 )
		return 1 ;

	if ( ++ EventDay > MAX_EVENT_DURATION )
		EventDay = 1 ;
	
	new query_string [ 50 ] ;
	format ( query_string, sizeof query_string, "UPDATE `bp_event` SET `event_day` = '%d'", EventDay ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	mysql_tquery ( sql_connection, "UPDATE `users` SET `u_eventpass` = '1|2|3|4|5|6', `u_eventpass_progress` = '0|0|0|0|0|0'", "callback_update_bp", "i", 1 ) ;
	
	new scm_string [ 86 + MAX_PLAYER_NAME + 4 ] ;
	format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A] {"#cGRAdmin"}%s[%d] передвинул Event Pass на день. Текущий день: %d.", p_info [ playerid ] [ name ], playerid, EventDay ) ;
	foreach(new i: admin_players) SendClientMessage ( i, col_admin, scm_string ) ;
	return 1 ;
}

CMD:epstart ( playerid, params [ ] )
{
	if ( admin_info [ playerid ] [ admin ] < 8 )
		return 1 ;
	
	if ( sscanf ( params, "d", params [ 0 ] ) )
		return SendClientMessage ( playerid, col_gray, !"Используйте: /epstart [количество секретных призов]" ) ;
	
	EventDay = 1 ;

	stop_event = 0 ;
	event_count = params [ 0 ] ;
	
	new query_string [ 110 ] ;
	format ( query_string, sizeof query_string, "UPDATE `bp_event` SET `event_day` = '%d', `event_stop` = '%d', `event_count` = '%d'", EventDay, stop_event, event_count ) ;
	mysql_tquery ( sql_connection, query_string ) ;

	new scm_string [ 59 + MAX_PLAYER_NAME + 4 ] ;
	format ( scm_string, sizeof ( scm_string ), "{"#cBAdmin"}[A] {"#cGRAdmin"}%s[%d] запустил Event Pass.", p_info [ playerid ] [ name ], playerid ) ;
	foreach(new i: admin_players) SendClientMessage ( i, col_admin, scm_string ) ;
	return 1 ;
}

callback: callback_update_bp ( _type )
{
	foreach(new i: logged_players)
	{
		gettime_clear_eventpass ( i ) ;
		
		if ( _type == 2 )
		{
			gPlayerPA [ i ] 					=
			gPlayerPAPrem [ i ]					= 
			gPlayerBattlePassQuest [ i ]		= 0 ;
			
			gPlayerBattlePassLVL { i } 			=
			gPlayerBattlePassEXP { i } 			= 0 ;
			
			gPlayerBattlePassPrem [ i ] 		=
			gPlayerBattlePassLimit [ i ]		= false ;
		}
	}
	return 1 ;
}

stock clear_player_epass ( playerid )
{
	player_case_last [ playerid ] = -1 ;
	return 1 ;
}

stock epass_OnGameModeInit ( )
{
	for ( new i = 0 ; i < MAX_BP_ITEM ; i ++ )
	{
		if ( bp_roulette [ i ] [ bp_rare ] == BP_ITEM_COMMON )
		{
			common_item [ common_count ] = i ;
			common_count ++ ;
		}
		else if ( bp_roulette [ i ] [ bp_rare ] == BP_ITEM_RARE )
		{
			rare_item [ rare_count ] = i ;
			rare_count ++ ;
		}
		else if ( bp_roulette [ i ] [ bp_rare ] == BP_ITEM_EPIC )
		{
			epic_item [ epic_count ] = i ;
			epic_count ++ ;
		}
		else if ( bp_roulette [ i ] [ bp_rare ] == BP_ITEM_LEGENDARY )
		{
			legendary_item [ legendary_count ] = i ;
			legendary_count ++ ;
		}
	}
	
	mysql_tquery ( sql_connection, !"SELECT * FROM `bp_event`", "loading_event_pass", "" ) ;
	mysql_tquery ( sql_connection, !"SELECT `u_name`, `u_epass`, `u_eexp`, `u_epremium` FROM `users` ORDER BY `users`.`u_epass` DESC LIMIT 100", "loading_event_pass_leader", "" ) ;
	
	CreateActor ( 100, event_actor_position [ 0 ], event_actor_position [ 1 ], event_actor_position [ 2 ], event_actor_position [ 3 ] ) ;
	
	//new areaid = CreateDynamicSphere ( event_actor_position [ 0 ], event_actor_position [ 1 ], event_actor_position [ 2 ], 3.0, -1, -1, -1 ) ;
	//area_info [ areaid ] [ a_type ] = area_type_eventpass ;
	
	CreateDynamic3DTextLabel ( "** Эвент трейдер **\n{"#cGR3D"}Подойдите для взаимодействия", col_blue, event_actor_position [ 0 ], event_actor_position [ 1 ], event_actor_position [ 2 ], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0 ) ;
	
	for ( new i = 0 ; i < MAX_TRADE_ITEM ; i ++ )
	{
		add_market ( 7, 1, i, event_trade [ i ] [ event_prise ], 2, event_trade [ i ] [ event_price ],
							event_actor_position [ 0 ], event_actor_position [ 1 ], event_actor_position [ 2 ], "Обменник "event_coins"", false ) ;
	}
	return 1 ;
}

callback: loading_event_pass ( )
{
	new fields, rows ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;
	
	EventDay = cache_get_field_content_int ( 0, "event_day", sql_connection ) ;
	event_count = cache_get_field_content_int ( 0, "event_count", sql_connection ) ;
	stop_event = cache_get_field_content_int ( 0, "event_stop", sql_connection ) ;
	EventGlobalQuest = cache_get_field_content_int ( 0, "event_global_quest", sql_connection ) ;
	EventGlobalReset = cache_get_field_content_int ( 0, "event_global_reset", sql_connection ) ;
	return 1 ;
}

callback: loading_event_pass_leader ( )
{
	new fields, rows ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) 
	{
		for ( new i = 0 ; i < 100 ; i ++ )
		{
			format ( NameTopLeader [ i ], MAX_PLAYER_NAME, "None" ) ;
			LevelTopLeader [ i ] =
			ExpTopLeader [ i ] = 0 ;
		}
		return 1 ;
	}
	
	for ( new i = 0 ; i < rows ; i ++ )
	{
	    cache_get_field_content ( i, "u_name", NameTopLeader [ i ], sql_connection, MAX_PLAYER_NAME ) ;
		LevelTopLeader [ i ] = cache_get_field_content_int ( i, "u_epass", sql_connection ) ;
		ExpTopLeader [ i ] = cache_get_field_content_int ( i, "u_eexp", sql_connection ) ;
		PremiumTopLeader [ i ] = cache_get_field_content_int ( i, "u_epremium", sql_connection ) ;
	}
	return 1 ;
}

stock gettime_clear_eventpass ( playerid )
{
	gettime_clear_newbiepass ( playerid ) ;
	
	if ( stop_event == 1 ) return 1 ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ ) gPlayerEventQuestStatus [ playerid ] [ q ] = -1 ;
	
	new _random ;
	
	start_random_ep:
	_random = random ( MAX_EVENT_QUESTS ) ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
	{
		if ( gPlayerEventQuestStatus [ playerid ] [ q ] == _random )
		{
			goto start_random_ep ;
			break ;
		}
		if ( gPlayerEventQuestStatus [ playerid ] [ q ] != -1 ) continue ;
		
		gPlayerEventQuestStatus [ playerid ] [ q ] = _random ;
		goto start_random_ep ;
		break ;
	}
	
	gPlayerEventQuestProgress [ playerid ] = ClearPlayerEventProgress ;
    save_battlepass_progress ( playerid ) ;
	return 1 ;
}

stock clear_player_event_pass ( playerid )
{
	gPlayerLoadedBattle [ playerid ] = false ;
	return 1 ;
}

stock SetBattleRoulettePrise ( playerid, _roulette_id, _bp_type )
{
	new time = GetTickCount ( ) ;
	printf ( "[SetBattleRoulettePrise] started..." ) ;
	
	new _prise_id = -1, _render ;
	if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
	{
		new donate_count = random ( 50000 ), random_item ;
		if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
		else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
		else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
		else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
		
		_retry_battle_roulette:
		if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
		{
			if ( random_item == 0 )
			{
				for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
				{
					new _id = player_case [ playerid ] [ i ] ;
					if ( bp_roulette [ _id ] [ bp_rare ] != BP_ITEM_COMMON ) continue ;
					
					if ( random ( 5 ) == 1 )
					{
						_prise_id = bp_roulette [ _id ] [ bp_model ] ;
						_render = bp_roulette [ _id ] [ bp_render ] ;
					}
				}
				
				if ( _prise_id == -1 )
				{
					random_item = 1 ;
					goto _retry_battle_roulette;
				}
			}
			else if ( random_item == 1 )
			{
				for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
				{
					new _id = player_case [ playerid ] [ i ] ;
					if ( bp_roulette [ _id ] [ bp_rare ] != BP_ITEM_RARE ) continue ;
					
					if ( random ( 4 ) == 1 )
					{
						_prise_id = bp_roulette [ _id ] [ bp_model ] ;
						_render = bp_roulette [ _id ] [ bp_render ] ;
					}
				}
				
				if ( _prise_id == -1 )
				{
					goto _retry_battle_roulette;
				}
			}
			else if ( random_item == 2 )
			{
				for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
				{
					new _id = player_case [ playerid ] [ i ] ;
					if ( bp_roulette [ _id ] [ bp_rare ] != BP_ITEM_EPIC ) continue ;
					
					if ( random ( 3 ) == 1 )
					{
						_prise_id = bp_roulette [ _id ] [ bp_model ] ;
						_render = bp_roulette [ _id ] [ bp_render ] ;
					}
				}
				
				if ( _prise_id == -1 )
				{
					goto _retry_battle_roulette;
				}
			}
			else if ( random_item == 3 )
			{
				for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
				{
					new _id = player_case [ playerid ] [ i ] ;
					if ( bp_roulette [ _id ] [ bp_rare ] != BP_ITEM_LEGENDARY ) continue ;
					
					if ( random ( 2 ) == 1 )
					{
						_prise_id = bp_roulette [ _id ] [ bp_model ] ;
						_render = bp_roulette [ _id ] [ bp_render ] ;
					}
				}
				
				if ( _prise_id == -1 )
				{
					goto _retry_battle_roulette;
				}
			}
		}
		else
		{
			SetBattleDialog ( playerid, "Ошибка", "Данный уровень не является рулеткой.", "Принять", "" ) ;
			return 0 ;
		}
		
		new _str_name [ 32 ] ;
		if ( _render == BATTLEPASS_RENDER_OBJECT )
		{
			format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( _prise_id ) ) ;
			give_inventory ( playerid, _prise_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _prise_id ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else if ( _render == BATTLEPASS_RENDER_SKIN )
		{
			format ( _str_name, sizeof _str_name, "%s", item_name ( _prise_id ) ) ;
			give_inventory ( playerid, _prise_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;

			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _prise_id ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		else if ( _render == BATTLEPASS_RENDER_CAR )
		{
			format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( INVALID_VEHICLE_ID, _prise_id ) ) ;
			give_inventory ( playerid, _prise_id, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
			global_string [ 0 ] = EOS ;
			format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _prise_id ) ) ;
			SendClientMessage ( playerid, col_yellow, global_string ) ;
		}
		
		new scm_string [ 100 ] ;
		format ( scm_string, sizeof scm_string, "%s (BP_ROULETTE) %s", p_info [ playerid ] [ name ], _str_name ) ;
		WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;

		if ( _bp_type == 1 ) CaseRouletteShowPrize ( playerid, _prise_id, _str_name ) ;
		else if ( _bp_type == 2 ) SetBattleRoulette ( playerid, 1, _prise_id, _str_name ) ;
		player_case_last [ playerid ] = -1 ;
		
		printf ( "[SetBattleRoulettePrise] end. (%d ms)", GetTickCount ( ) - time ) ;
	}
	else
	{
		printf ( "[SetBattleRoulettePrise] end. (%d ms)", GetTickCount ( ) - time ) ;
		return 0 ;
	}
	return 1 ;
}

stock player_roulette_update ( playerid, _case_type, _bp_type )
{
	new _common = 0, _rare = 0, _epic = 0, _legendary = 0 ;
	if ( _case_type >= 5 && _case_type <= 7 )
	{
		_common = 5 ;
		_rare = 4 ;
		_epic = 4 ;
		_legendary = 2 ;
	}
	else if ( _case_type >= 10 && _case_type <= 20 )
	{
		_common = 0 ;
		_rare = 7 ;
		_epic = 4 ;
		_legendary = 4 ;
	}
	
	for ( new i = 0 ; i < MAX_BATTLE_PASS_ROULETTE_ITEMS ; i ++ )
	{
		if ( _common > 0 )
		{
			player_case [ playerid ] [ i ] = common_item [ random ( common_count ) ] ;
			_common -= 1 ;
			continue ;
		}
		if ( _rare > 0 )
		{
			player_case [ playerid ] [ i ] = rare_item [ random ( rare_count ) ] ;
			_rare -= 1 ;
			continue ;
		}
		if ( _epic > 0 )
		{
			player_case [ playerid ] [ i ] = epic_item [ random ( epic_count ) ] ;
			_epic -= 1 ;
			continue ;
		}
		if ( _legendary > 0 )
		{
			player_case [ playerid ] [ i ] = legendary_item [ random ( legendary_count ) ] ;
			_legendary -= 1 ;
			continue ;
		}
	}
	
	if ( _bp_type == 1 )
	{
		CaseRoulettePage ( playerid, _case_type, true, MAX_BATTLE_PASS_ROULETTE_ITEMS ) ;
		CaseRouletteItem ( playerid ) ;
		CaseRouletteGlasses ( playerid, -1, 1, 0, "Battle Roullette" ) ;
	}
	else
	{
		SetRouletteItem ( playerid ) ;
		SetRoulettePage ( playerid, _case_type, true, 1 ) ;
	}
	return 1 ;
}

stock show_packet_battlepass ( playerid, _param1, _param2, _param3, _param4 )
{
	if ( _param4 == 1 ) // arizona
	{
		if ( _param1 == 0 )
		{
			if ( _param2 == 0 ) // back to bp
			{
				new _end_str [ 48 ] ;
				format ( _end_str, sizeof _end_str, "Сезон закончится через %d дней", MAX_EVENT_DURATION - EventDay ) ;
				if ( ! gPlayerBattlePassPrem [ playerid ] ) bpShow ( playerid, _end_str, true, "Купить улучшенный пропуск", "криминальный" ) ;
				else bpShow ( playerid, _end_str, true, "Купить +1 уровень", "криминальный" ) ;
				selectBattlePass ( playerid, 0 ) ;
				
				new _count = 0, _id ;
				for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
				{
					_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
					if ( _id == -1 ) continue ;
					if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
					
					_count ++ ;
				}
				
				new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
				format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
				if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
				else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
				format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
				if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
				else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
				bpAddBPItem ( playerid, 10 ) ;
			}
			else if ( _param2 == 1 ) // buy prem
			{
				if ( gPlayerBattlePassPrem [ playerid ] )
				{
					new _str [ 24 ], _discount = 0 ;
					if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 1 ) _discount = 10 ;
					else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 1 ) _discount = 30 ;
					else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 1 ) _discount = 50 ;
					format ( _str, sizeof _str, "%d", 200 - floatround ( ( 200 * _discount ) / 100 ) ) ;
					buyBattlePass ( playerid, true, "+1 уровень", "Для того, чтобы ускорить повышение уровня,\
																	Вы можете воспользоваться платной услугой повышения.",
																_str, "donate_title" ) ;
					updateBuyBattlePass ( playerid, 0, false ) ;
					updateBuyBattlePass ( playerid, 1, false ) ;
					updateBuyBattlePass ( playerid, 2, false ) ;
					set_player_use_listitem ( playerid, 0 ) ;
					return 1 ;
				}
				
				new _str [ 24 ], _discount = 0 ;
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 1 ) _discount = 10 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 1 ) _discount = 30 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 1 ) _discount = 50 ;
				format ( _str, sizeof _str, "%d", 2000 - floatround ( ( 2000 * _discount ) / 100 ) ) ;
				buyBattlePass ( playerid, true, "стандартный", "Это уникальное погружение в мир ностальгии и детских воспоминаний.\
																Он перенесет вас в беззаботные времена, когда все было возможно,\
																а мир казался огромным. BattlePass наполнен разнообразными скинами,\
																автомобилями и другими эксклюзивными предметами,\
																которые помогут вам окунуться в атмосферу детства и вновь почувствовать себя юным исследователем.",
																_str, "donate_title" ) ;
				updateBuyBattlePass ( playerid, 0, true ) ;
				updateBuyBattlePass ( playerid, 1, true ) ;
				updateBuyBattlePass ( playerid, 2, true ) ;
				set_player_use_listitem ( playerid, 4 ) ;
			}
			else if ( _param2 == 2 ) // item take
			{
				new _roulette_id = BattlePass [ gPlayerPA [ playerid ] ] [ bpiType ] ;
				if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
				{
					if ( player_case_last [ playerid ] != gPlayerPA [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPA [ playerid ] ;
						player_roulette_update ( playerid, _roulette_id, _param4 ) ;
					}
					else
					{
						CaseRoulettePage ( playerid, _roulette_id, true, MAX_BATTLE_PASS_ROULETTE_ITEMS ) ;
						CaseRouletteItem ( playerid ) ;
					}
					bpHide ( playerid ) ;
					return 1 ;
				}
				/*else if ( _roulette_id == BP_LOTTERY )
				{
					if ( player_case_last [ playerid ] != gPlayerPA [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPA [ playerid ] ;
						
						for ( new i = 0 ; i < 15 ; i ++ )
						{
							player_case [ playerid ] [ i ] = i ;
						}
					}
					SetCasePage ( playerid, _roulette_id ) ;
					SetCaseItem ( playerid, _roulette_id ) ;
					return 1 ;
				}*/
			
				if ( gPlayerPA [ playerid ] <= gPlayerBattlePassLVL { playerid } )
				{
					give_eventpass_prise ( playerid, false ) ;
					
					gPlayerPA [ playerid ] += 1 ;
					new _activated = gPlayerPA [ playerid ] ;
					update_int_sql ( playerid, "u_epriseuse", _activated ) ;
					bpUpdateBPItem ( playerid, _activated - 1 ) ;
					if ( _activated < MAX_BATTLE_PASS_ITEMS ) bpUpdateBPItem ( playerid, _activated ) ;
				}
			}
			else if ( _param2 == 3 ) // prem item take
			{
				if ( ! gPlayerBattlePassPrem [ playerid ] ) return 1 ;
				
				new _roulette_id = BattlePass [ gPlayerPAPrem [ playerid ] ] [ bpiPremType ] ;
				if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
				{
					if ( player_case_last [ playerid ] != gPlayerPAPrem [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPAPrem [ playerid ] ;
						player_roulette_update ( playerid, _roulette_id, _param4 ) ;
					}
					else
					{
						CaseRoulettePage ( playerid, _roulette_id, true, MAX_BATTLE_PASS_ROULETTE_ITEMS ) ;
						CaseRouletteItem ( playerid ) ;
					}
					bpHide ( playerid ) ;
					return 1 ;
				}
				/*else if ( _roulette_id == BP_LOTTERY || _roulette_id == BP_LOTTERY2 )
				{
					if ( player_case_last [ playerid ] != gPlayerPAPrem [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPAPrem [ playerid ] ;
						
						for ( new i = 0 ; i < 15 ; i ++ )
						{
							player_case [ playerid ] [ i ] = i ;
						}
					}
					SetCasePage ( playerid, _roulette_id ) ;
					SetCaseItem ( playerid, _roulette_id ) ;
					return 1 ;
				}*/
				
				if ( gPlayerPAPrem [ playerid ] <= gPlayerBattlePassLVL { playerid } )
				{
					give_eventpass_prise ( playerid, true ) ;
					
					gPlayerPAPrem [ playerid ] += 1 ;
					new _activated = gPlayerPAPrem [ playerid ] ;
					update_int_sql ( playerid, "u_epriseuse_prem", _activated ) ;
					bpUpdateBPItem ( playerid, _activated - 1 ) ;
					if ( _activated < MAX_BATTLE_PASS_ITEMS ) bpUpdateBPItem ( playerid, _activated ) ;
				}
			}
			else if ( _param2 == 4 ) // add item in main (прогрузка каждые 10 позиций)
			{
				if ( _param3 < MAX_BATTLE_PASS_ITEMS )
					bpAddBPItem ( playerid, _param3 + 10 ) ;
			}
			else if ( _param2 == 5 ) // limit
			{
				new _str [ 24 ], _discount = 0 ;
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 1 ) _discount = 10 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 1 ) _discount = 30 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 1 ) _discount = 50 ;
				format ( _str, sizeof _str, "%d", 1000 - floatround ( ( 1000 * _discount ) / 100 ) ) ;
				buyBattlePass ( playerid, true, "лимит заданий", "Вы можете снять лимит заданий в сутки.\
															Сняв лимит задания будут обновляться сразу после выполнения.",
																_str, "donate_title" ) ;
				updateBuyBattlePass ( playerid, 0, false ) ;
				updateBuyBattlePass ( playerid, 1, false ) ;
				updateBuyBattlePass ( playerid, 2, false ) ;
				set_player_use_listitem ( playerid, 1 ) ;
			}
		}
		else if ( _param1 == 1 )
		{
			selectBattlePass ( playerid, 0 ) ;
				
			new _count = 0, _id ;
			for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
			{
				_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
				if ( _id == -1 ) continue ;
				if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
					
				_count ++ ;
			}

			new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
			format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
			if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
			else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
			format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
			if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
			else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
		}
		else if ( _param1 == 2 )
		{
			selectBattlePass ( playerid, 1 ) ;
			if ( EventGlobalReset < gettime ( ) )
			{
				EventGlobalQuest = random ( sizeof GlobalQuestData ) ;
				EventGlobalReset = SetElapsedTime ( gettime ( ), 3, CONVERT_TIME_TO_DAYS ) ;
				
				new query_string [ 81 + ( 2 * 9 ) ] ;
				format ( query_string, sizeof query_string, "UPDATE `bp_event` SET `event_global_quest` = '%d', `event_global_reset` = '%d'", EventGlobalQuest, EventGlobalReset ) ;
				mysql_tquery ( sql_connection, query_string ) ;
			}
			
			if ( EventGlobalQuest != -1 )
			{
				new s_year, s_month, s_day, s_hour, s_minute, s_second, _str [ 24 ], _str2 [ 24 ], _str3 [ 12 ], _q_id = EventGlobalQuest ;
				timestamp_to_date ( EventGlobalReset - gettime ( ), s_year, s_month, s_day, s_hour, s_minute, s_second ) ;
				
				if ( gPlayerEventGlobalAccept [ playerid ] )
				{
					format ( _str, sizeof _str, "Новое задание дня будет доступно\nчерез %dд %dч %dм", s_day, s_hour, s_minute ) ;
					bpUpdateDayTaskLayout ( playerid, 1, _str, "", "", "", -1, -1, "", "" ) ;
					return 1 ;
				}
				
				format ( _str, sizeof _str, "%dд %dч %dм", s_day, s_hour, s_minute ) ;
				format ( _str2, sizeof _str2, "%d/%d", gPlayerEventGlobalProgress [ playerid ], GlobalQuestData [ _q_id ] [ goProgress ] ) ;
				if ( gPlayerEventGlobalProgress [ playerid ] < 1 ) format ( _str3, sizeof _str3, "0%" ) ;
				else format ( _str3, sizeof _str3, "%d", floatround ( ( floatdiv ( GlobalQuestData [ _q_id ] [ goProgress ], gPlayerEventGlobalProgress [ playerid ] ) ) * 100 ) ) ;
				bpUpdateDayTaskLayout ( playerid, 2, _str, 
										GlobalQuestData [ _q_id ] [ goName ], 
										GlobalQuestData [ _q_id ] [ goDescription ], 
										GlobalQuestData [ _q_id ] [ goTarget ],
										GlobalQuestData [ _q_id ] [ goProgress ], gPlayerEventGlobalProgress [ playerid ], _str2, _str3 ) ;

				if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 0 ] == -1 ) bpUpdateDayTasksPrize ( playerid, 0, _q_id, false, "опыта" ) ;
				else bpUpdateDayTasksPrize ( playerid, 0, _q_id, true, "опыта" ) ;
				
				if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 1 ] == -1 ) bpUpdateDayTasksPrize ( playerid, 1, _q_id, false, "опыта" ) ;
				else bpUpdateDayTasksPrize ( playerid, 1, _q_id, true, "опыта" ) ;
				
				if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 2 ] == -1 ) bpUpdateDayTasksPrize ( playerid, 2, _q_id, false, "опыта" ) ;
				else bpUpdateDayTasksPrize ( playerid, 2, _q_id, true, "опыта" ) ;
			}
		}
		else if ( _param1 == 3 )
		{
			selectBattlePass ( playerid, 2 ) ;
			bpAddTasks ( playerid, "очков опыта" ) ;
		}
		else if ( _param1 == 6 ) // roll roulette
		{
			if ( _param2 == 1 )
			{
				if ( _param3 >= 5 && _param3 <= 7 )
				{
					if ( gPlayerPA [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPA [ playerid ] += 1 ;
						new _activated = gPlayerPA [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
						
						SetBattleRoulettePrise ( playerid, _param3, 1 ) ;
					}
				}
				else if ( _param3 >= 10 && _param3 <= 20 )
				{
					if ( gPlayerPAPrem [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPAPrem [ playerid ] += 1 ;
						new _activated = gPlayerPAPrem [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse_prem", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
						
						SetBattleRoulettePrise ( playerid, _param3, 1 ) ;
					}
				}
			}
			else if ( _param2 == 2 )
			{
				CaseRouletteHide ( playerid ) ;
				show_packet_battlepass ( playerid, 0, 0, 0, 1 ) ;
			}
		}
		else if ( _param1 == 7 )
		{
			new _listitem = get_player_use_listitem ( playerid ) ;
			if ( _listitem == 0 )
			{
				new _e_lvl_price = 200, _discont = 0, _type = 0 ;
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 0 ) _discont = 10, _type = 1 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 0 ) _discont = 30, _type = 2 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 0 ) _discont = 50, _type = 3 ;
				_e_lvl_price = 200 - floatround ( ( 200 * _discont ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _e_lvl_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				if ( _type == 1 ) clear_inventory ( playerid, 2184, 1 ) ;
				else if ( _type == 2 ) clear_inventory ( playerid, 2185, 1 ) ;
				else if ( _type == 3 ) clear_inventory ( playerid, 2186, 1 ) ;

				set_player_donate ( playerid, _e_lvl_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _e_lvl_price, p_info [ playerid ] [ donate ], "(donate) Event Pass +1 lvl" ) ;
				
				new
					BPLevel = gPlayerBattlePassLVL { playerid },
					BPExp = ( gPlayerBattlePassEXP { playerid } += 100 ) ;

				if ( BPExp >= 100 )
				{
					gPlayerBattlePassEXP { playerid } 	= BPExp - 100 ;
					BPExp 								-= 100 ;
					BPLevel 							= gPlayerBattlePassLVL { playerid } += 1 ;
					new BPCoins							= ( BPLevel * 2 ) + ( random ( 100 ) + 10 ) ;
					
					gPlayerBattlePassCoins [ playerid ] += BPCoins ;
					
					static const _str [ ] = "UPDATE `users` SET `u_epass` = '%d', `u_eexp` = '%d', `u_ecoins` = '%d' WHERE `u_id` = '%d' LIMIT 1" ;
					new string [ sizeof _str + ( 3 * 9 ) ] ;
					format ( string, sizeof string, _str, gPlayerBattlePassLVL { playerid }, BPExp, gPlayerBattlePassCoins [ playerid ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, string ) ;
				}
				
				bpUpdateBPItem ( playerid, BPLevel ) ;
				
				new _count = 0, _id ;
				for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
				{
					_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
					if ( _id == -1 ) continue ;
					if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
						
					_count ++ ;
				}
				
				new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
				format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
				if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
				else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
				format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
				if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
				else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
			}
			else if ( _listitem == 1 )
			{
				if ( gPlayerBattlePassLimit [ playerid ] )
				{
					send_check_cinfo ( playerid, "У Вас уже снят лимит заданий!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new _e_limit_price = 1000, _discont = 0, _type = 0 ;
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 0 ) _discont = 10, _type = 1 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 0 ) _discont = 30, _type = 2 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 0 ) _discont = 50, _type = 3 ;
				_e_limit_price = 1000 - floatround ( ( 1000 * _discont ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _e_limit_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				if ( _type == 1 ) clear_inventory ( playerid, 2184, 1 ) ;
				else if ( _type == 2 ) clear_inventory ( playerid, 2185, 1 ) ;
				else if ( _type == 3 ) clear_inventory ( playerid, 2186, 1 ) ;

				set_player_donate ( playerid, _e_limit_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _e_limit_price, p_info [ playerid ] [ donate ], "(donate) Event Pass limit" ) ;
				
				gPlayerBattlePassLimit [ playerid ] = true ;
				update_int_sql ( playerid, "u_elimit", 1 ) ;
				
				battlepass_check_limit ( playerid ) ;
				buyBattlePass ( playerid, false, "", "", "", "" ) ;
				
				new _count = 0, _id ;
				for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
				{
					_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
					if ( _id == -1 ) continue ;
					if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
						
					_count ++ ;
				}
				
				new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
				format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
				if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
				else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
				format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
				if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
				else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
			}
			else if ( _listitem == 4 )
			{
				if ( gPlayerBattlePassPrem [ playerid ] )
				{
					send_check_cinfo ( playerid, "У Вас уже есть премиум-статус!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
				
				new _e_prem_price = 2000, _discont = 0, _type = 0 ;
				if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2184 ) > 0 ) _discont = 10, _type = 1 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2185 ) > 0 ) _discont = 30, _type = 2 ;
				else if ( GetInventoryFindItem ( playerid, SUB_INVENTORY, 2186 ) > 0 ) _discont = 50, _type = 3 ;
				_e_prem_price = 2000 - floatround ( ( 2000 * _discont ) / 100 ) ;
				if ( ! get_player_donate ( playerid, _e_prem_price, 2 ) )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно "donate_title"!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
					
				if ( _type == 1 ) clear_inventory ( playerid, 2184, 1 ) ;
				else if ( _type == 2 ) clear_inventory ( playerid, 2185, 1 ) ;
				else if ( _type == 3 ) clear_inventory ( playerid, 2186, 1 ) ;

				set_player_donate ( playerid, _e_prem_price, 2 ) ;
				insert_donate_log ( playerid, INVALID_PLAYER_ID, _e_prem_price, p_info [ playerid ] [ donate ], "(donate) Event Pass premium" ) ;
				
				gPlayerBattlePassPrem [ playerid ] = true ;
				
				gPlayerPAPrem [ playerid ] = 0 ;
				buyBattlePass ( playerid, false, "", "", "", "" ) ;
				
				static const _str [ ] = "UPDATE `users` SET `u_epremium` = '1', `u_epriseuse_prem` = '0' WHERE `u_id` = '%d' LIMIT 1" ;
				new string [ sizeof _str + 9 ] ;
				format ( string, sizeof string, _str, p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, string ) ;
				
				new _end_str [ 48 ] ;
				format ( _end_str, sizeof _end_str, "Сезон закончится через %d дней", MAX_EVENT_DURATION - EventDay ) ;
				if ( ! gPlayerBattlePassPrem [ playerid ] ) bpShow ( playerid, _end_str, true, "Купить улучшенный пропуск", "криминальный" ) ;
				else bpShow ( playerid, _end_str, true, "Купить +1 уровень", "криминальный" ) ;
				
				if ( bp_buy_item [ 0 ] [ bp_model ] != -1 )
				{
					new _model = bp_buy_item [ 0 ] [ bp_model ] ;
					give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				if ( bp_buy_item [ 1 ] [ bp_model ] != -1 )
				{
					new _model = bp_buy_item [ 1 ] [ bp_model ] ;
					give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				if ( bp_buy_item [ 2 ] [ bp_model ] != -1 )
				{
					new _model = bp_buy_item [ 2 ] [ bp_model ] ;
					give_inventory ( playerid, _model, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
			}
		}
		else if ( _param1 == 8 )
		{
			if ( EventGlobalQuest != -1 )
			{
				new _q_id = EventGlobalQuest ;
				if ( ! gPlayerEventGlobalAccept [ playerid ] && gPlayerEventGlobalProgress [ playerid ] >= GlobalQuestData [ _q_id ] [ goProgress ] )
				{
					send_check_cinfo ( playerid, "Вы получили вознаграждение.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
					
					gPlayerEventGlobalAccept [ playerid ] = true ;
					update_int_sql ( playerid, "u_eaccept", 1 ) ;
					
					if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 0 ] != -1 )
					{
						new _model = GlobalQuestData [ _q_id ] [ goPriseModel ] [ 0 ] ;
						if ( _model == 54 ) set_battlepass_levelup ( playerid, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 0 ] ) ;
						else
						{
							give_inventory ( playerid, _model, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 0 ], 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
			
							global_string [ 0 ] = EOS ;
							format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
					}
					if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 1 ] != -1 )
					{
						new _model = GlobalQuestData [ _q_id ] [ goPriseModel ] [ 1 ] ;
						if ( _model == 54 ) set_battlepass_levelup ( playerid, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 1 ] ) ;
						else
						{
							give_inventory ( playerid, _model, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 1 ], 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
							global_string [ 0 ] = EOS ;
							format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
					}
					if ( GlobalQuestData [ _q_id ] [ goPriseModel ] [ 2 ] != -1 )
					{
						new _model = GlobalQuestData [ _q_id ] [ goPriseModel ] [ 2 ] ;
						if ( _model == 54 ) set_battlepass_levelup ( playerid, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 2 ] ) ;
						else
						{
							give_inventory ( playerid, _model, GlobalQuestData [ _q_id ] [ goPriseCount ] [ 2 ], 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
				
							global_string [ 0 ] = EOS ;
							format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _model ) ) ;
							SendClientMessage ( playerid, col_yellow, global_string ) ;
						}
					}
					
					new query_string [ 48 + MAX_PLAYER_NAME ] ;
					format ( query_string, sizeof query_string, "[BP EVERY] %s выполнил(а) ежедневное задание.", p_info [ playerid ] [ name ] ) ;
					WriteLog ( playerid, TYPE_LOG_BATTLEPASS, query_string ) ;
					return 1 ;
				}
			}
		}
		else if ( _param1 == 255 ) // hide
		{
			if ( get_player_use_listitem ( playerid ) != -1 )
			{
				clear_player_use_listitem ( playerid ) ;
				buyBattlePass ( playerid, false, "", "", "", "" ) ;
			}
			else
			{
				bpHide ( playerid ) ;
	
				toggle_controlable ( playerid, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
				TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
			}
		}
	}
	else if ( _param4 == 2 ) // matreshka
	{
		if ( _param1 == 0 )
		{
			if ( _param2 == 0 ) // back to bp
			{
				new _str [ 24 ] ;
				format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
				SetMainPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
				SetAddBpItem ( playerid, 10 ) ;
			}
			else if ( _param2 == 1 ) // buy prem
			{
				if ( gPlayerBattlePassPrem [ playerid ] )
				{
					new _str [ 24 ] ;
					format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
					SetExpPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
					SetExpInfo ( playerid, "Купить за", "рублей" ) ;
					return 1 ;
				}
				SetBattleDialog ( playerid, "Premium-Статус", "Вы действительно хотите приобрести Premium-Статус за 499 рублей?", "Да", "Нет" ) ;
				set_player_use_listitem ( playerid, 4 ) ;
			}
			else if ( _param2 == 2 ) // item take
			{
				new _roulette_id = BattlePass [ gPlayerPA [ playerid ] ] [ bpiType ] ;
				if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
				{
					if ( player_case_last [ playerid ] != gPlayerPA [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPA [ playerid ] ;
						player_roulette_update ( playerid, _roulette_id, _param4 ) ;
					}
					else
					{
						SetRouletteItem ( playerid ) ;
						SetRoulettePage ( playerid, _roulette_id, true, 1 ) ;
					}
					return 1 ;
				}
				else if ( _roulette_id == BP_LOTTERY )
				{
					if ( player_case_last [ playerid ] != gPlayerPA [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPA [ playerid ] ;
						
						for ( new i = 0 ; i < 15 ; i ++ )
						{
							player_case [ playerid ] [ i ] = i ;
						}
					}
					SetCasePage ( playerid, _roulette_id ) ;
					SetCaseItem ( playerid, _roulette_id ) ;
					return 1 ;
				}
			
				if ( gPlayerPA [ playerid ] <= gPlayerBattlePassLVL { playerid } )
				{
					give_eventpass_prise ( playerid, false ) ;
					
					gPlayerPA [ playerid ] += 1 ;
					new _activated = gPlayerPA [ playerid ] ;
					update_int_sql ( playerid, "u_epriseuse", _activated ) ;
					UpdateAddBpItem ( playerid, _activated - 1 ) ;
					if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
				}
			}
			else if ( _param2 == 3 ) // prem item take
			{
				if ( ! gPlayerBattlePassPrem [ playerid ] ) return 1 ;
				
				new _roulette_id = BattlePass [ gPlayerPAPrem [ playerid ] ] [ bpiPremType ] ;
				if ( _roulette_id >= 5 && _roulette_id <= 7 || _roulette_id >= 10 && _roulette_id <= 20 )
				{
					if ( player_case_last [ playerid ] != gPlayerPAPrem [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPAPrem [ playerid ] ;
						player_roulette_update ( playerid, _roulette_id, _param4 ) ;
					}
					else
					{
						SetRouletteItem ( playerid ) ;
						SetRoulettePage ( playerid, _roulette_id, true, 1 ) ;
					}
					return 1 ;
				}
				else if ( _roulette_id == BP_LOTTERY || _roulette_id == BP_LOTTERY2 )
				{
					if ( player_case_last [ playerid ] != gPlayerPAPrem [ playerid ] )
					{
						player_case_last [ playerid ] = gPlayerPAPrem [ playerid ] ;
						
						for ( new i = 0 ; i < 15 ; i ++ )
						{
							player_case [ playerid ] [ i ] = i ;
						}
					}
					SetCasePage ( playerid, _roulette_id ) ;
					SetCaseItem ( playerid, _roulette_id ) ;
					return 1 ;
				}
				
				if ( gPlayerPAPrem [ playerid ] <= gPlayerBattlePassLVL { playerid } )
				{
					give_eventpass_prise ( playerid, true ) ;
					
					gPlayerPAPrem [ playerid ] += 1 ;
					new _activated = gPlayerPAPrem [ playerid ] ;
					update_int_sql ( playerid, "u_epriseuse_prem", _activated ) ;
					UpdateAddBpItem ( playerid, _activated - 1 ) ;
					if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
				}
			}
			else if ( _param2 == 4 ) // add item in main (прогрузка каждые 10 позиций)
			{
				if ( _param3 < MAX_BATTLE_PASS_ITEMS )
					SetAddBpItem ( playerid, _param3 + 10 ) ;
			}
		}
		else if ( _param1 == 1 ) // tasks
		{
			if ( _param2 == 0 ) // open
			{
				new _str [ 24 ] ;
				format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
				SetTasksPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
				SetAddTasks ( playerid ) ;
			}
		}
		else if ( _param1 == 2 ) // buy exp
		{
			if ( _param2 == 0 ) // open
			{
				new _str [ 24 ] ;
				format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
				SetExpPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
				SetExpInfo ( playerid, "Купить за", "рублей" ) ;
			}
			else if ( _param2 == 1 ) // buy
			{
				static const _lvl_price [ ] = { 200, 800, 2700, 499 } ;
				static const _buy_lvl [ ] = { 1, 5, 15, 25 } ;
		
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "Вы действительно хотите приобрести %d уровней за %d рублей?", _buy_lvl [ _param3 ], _lvl_price [ _param3 ] ) ;
				SetBattleDialog ( playerid, "Уровни", global_string, "Да", "Нет" ) ;
				set_player_use_listitem ( playerid, _param3 + 1 ) ;
			}
		}
		else if ( _param1 == 3 ) // top
		{
			new _str [ 24 ] ;
			format ( _str, sizeof _str, "До конца сезона: %d дн.", MAX_EVENT_DURATION - EventDay ) ;
			SetStatPage ( playerid, _str, "Обменивайте Event Coins в обменнике призов! /gps - Прочее" ) ;
			SetBattleStat ( playerid, "уровень", "опыта" ) ;
		}
		else if ( _param1 == 4 ) // roll case
		{
			if ( _param2 == 1 )
			{
				if ( _param3 == BP_LOTTERY )
				{
					if ( gPlayerPA [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPA [ playerid ] += 1 ;
						new _activated = gPlayerPA [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
					}
				}
				else if ( _param3 == BP_LOTTERY2 )
				{
					if ( gPlayerPAPrem [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPAPrem [ playerid ] += 1 ;
						new _activated = gPlayerPAPrem [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse_prem", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
					}
				}
				
				new _item, _render, _id = player_case [ playerid ] [ random ( MAX_BATTLE_PASS_ROULETTE_ITEMS ) ] ;
				
				if ( _param3 == BP_LOTTERY ) 
				{
					_item = bp_case1 [ _id ] [ bp_model ] ;
					_render = bp_case1 [ _id ] [ bp_render ] ;
				}
				else if ( _param3 == BP_LOTTERY2 )
				{
					_item = bp_case2 [ _id ] [ bp_model ] ;
					_render = bp_case2 [ _id ] [ bp_render ] ;
				}

				if ( _render == BATTLEPASS_RENDER_OBJECT )
				{
					give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				else if ( _render == BATTLEPASS_RENDER_SKIN )
				{
					give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}
				else if ( _render == BATTLEPASS_RENDER_CAR )
				{
					give_inventory ( playerid, _item, 1, 0, "", "", NUMBERPLATE_TYPE_NONE, 0 ) ;
					
					global_string [ 0 ] = EOS ;
					format ( global_string, 128, "* Вам в инвентарь был добавлен предмет '%s'.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, global_string ) ;
				}

				new scm_string [ 100 ] ;
				format ( scm_string, sizeof scm_string, "%s (BP_CASE) item: %d", p_info [ playerid ] [ name ], _item ) ;
				WriteLog ( playerid, TYPE_LOG_BATTLEPASS, scm_string ) ;
			
				SetCaseStart ( playerid, _param3, _item, _id ) ;
			}
		}
		else if ( _param1 == 6 ) // roll roulette
		{
			if ( _param2 == 1 )
			{
				if ( _param3 >= 5 && _param3 <= 7 )
				{
					if ( gPlayerPA [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPA [ playerid ] += 1 ;
						new _activated = gPlayerPA [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
						
						SetBattleRoulettePrise ( playerid, _param3, 2 ) ;
					}
				}
				else if ( _param3 >= 10 && _param3 <= 20 )
				{
					if ( gPlayerPAPrem [ playerid ] <= gPlayerBattlePassLVL { playerid } )
					{
						gPlayerPAPrem [ playerid ] += 1 ;
						new _activated = gPlayerPAPrem [ playerid ] ;
						update_int_sql ( playerid, "u_epriseuse_prem", _activated ) ;
						UpdateAddBpItem ( playerid, _activated - 1 ) ;
						if ( _activated < MAX_BATTLE_PASS_ITEMS ) UpdateAddBpItem ( playerid, _activated ) ;
						
						SetBattleRoulettePrise ( playerid, _param3, 2 ) ;
					}
				}
			}
		}
		else if ( _param1 == 7 ) // dialog
		{
			if ( _param2 == 1 ) // accept
			{
				new _id = get_player_use_listitem ( playerid ) ;
				if ( _id < 1 ) return 1 ;
				if ( _id == 4 ) show_premium_eventpass ( playerid ) ;
				else show_upgrade_eventpass ( playerid, _id - 1 ) ;
				set_player_use_listitem ( playerid, 0 ) ;
			}
			else if ( _param2 == 2 ) // cancel
			{
				
			}
		}
		else if ( _param1 == 255 ) // hide
		{
			SetBattleHide ( playerid ) ;
	
			toggle_controlable ( playerid, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
		}
	}
	return 1 ;
}

CMD:testb ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	new _end_str [ 48 ] ;
	format ( _end_str, sizeof _end_str, "Сезон закончится через %d дней", MAX_EVENT_DURATION - EventDay ) ;
	if ( ! gPlayerBattlePassPrem [ playerid ] ) bpShow ( playerid, _end_str, true, "Купить улучшенный пропуск", "криминальный" ) ;
	else bpShow ( playerid, _end_str, true, "Купить +1 уровень", "криминальный" ) ;
	selectBattlePass ( playerid, 0 ) ;
	
	new _count = 0, _id ;
	for ( new q = 0 ; q < MAX_PLAYER_EP_QUEST ; q ++ )
	{
		_id = gPlayerEventQuestStatus [ playerid ] [ q ] ;
		if ( _id == -1 ) continue ;
		if ( gPlayerEventQuestProgress [ playerid ] [ q ] < QuestData [ _id ] [ eqProgress ] ) continue ;
		
		_count ++ ;
	}
	
	new _str [ 12 ], _str2 [ 12 ], _str3 [ 12 ], bool: _limit = gPlayerBattlePassLimit [ playerid ] ;
	format ( _str, sizeof _str, "%d", gPlayerBattlePassLVL { playerid } + 1 ) ;
	if ( _limit ) format ( _str2, sizeof _str2, "%d", _count ) ;
	else format ( _str2, sizeof _str2, "%d/%d", _count, MAX_PLAYER_EP_QUEST ) ;
	format ( _str3, sizeof _str3, "%d", gPlayerBattlePassQuest [ playerid ] ) ;
	if ( _limit ) bpUpdateMainLayout ( playerid, _str, _str2, false, _str3 ) ;
	else bpUpdateMainLayout ( playerid, _str, _str2, true, _str3 ) ;
	bpAddBPItem ( playerid, 10 ) ;
	
	bpAddGuideMainLayout ( playerid ) ;
	
	toggle_controlable ( playerid, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
	TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, false ) ;
	return 1 ;
}

CMD:testrr ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	player_roulette_update ( playerid, 10, 1 ) ;
	return 1 ;
}