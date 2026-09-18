#if defined _inc_blackpass
    #endinput
#endif
#define _inc_blackpass

#define BLACKPASS_SEASON_NUMBER         26
#define BLACKPASS_SEASON_NAME           "ГОЛОС УЛИЦ"
#define BLACKPASS_MAX_LEVELS            60
#define BLACKPASS_DEFAULT_PREMIUM_PRICE 790
#define BLACKPASS_DEFAULT_DELUXE_PRICE  1690
#define BLACKPASS_SEASON_DAYS           42
#define BLACKPASS_LEVEL_EXP             1000
#define BLACKPASS_LEVEL_PRICE           150
#define BLACKPASS_STATUS_NONE           0
#define BLACKPASS_STATUS_PREMIUM        1
#define BLACKPASS_STATUS_DELUXE         2

enum E_BLACKPASS_PLAYER_DATA
{
    bool:BP_DATA_LOADED,
    BP_ACCOUNT_ID,
    BP_EXPERIENCE,
    BP_LEVEL,
    BP_PREMIUM_STATUS,
    BP_DUST,
    BP_SELECTED_LAYOUT,
    bool:BP_DELUXE_REWARDS_CLAIMED
};

new g_blackpass_player[MAX_PLAYERS][E_BLACKPASS_PLAYER_DATA];
new bool:g_blackpass_claimed_standard[MAX_PLAYERS][BLACKPASS_MAX_LEVELS + 1];
new bool:g_blackpass_claimed_premium[MAX_PLAYERS][BLACKPASS_MAX_LEVELS + 1];

#define BLACKPASS_TASK_SLOT_COUNT        11
#define BLACKPASS_TASK_DEF_COUNT         54
#define BLACKPASS_DAILY_TASK_COUNT       6
#define BLACKPASS_WEEKLY_TASK_COUNT      5
#define BLACKPASS_TASK_GROUP_DAILY       1
#define BLACKPASS_TASK_GROUP_WEEKLY      2
#define BLACKPASS_TASK_STATUS_REWARD     1
#define BLACKPASS_TASK_STATUS_PREMIUM    2
#define BLACKPASS_TASK_STATUS_TRACKED    3
#define BLACKPASS_TASK_STATUS_GO_TO      4
#define BLACKPASS_TASK_STATUS_LOCKED     5
#define BLACKPASS_TASK_STATUS_CLAIMED    6
#define BLACKPASS_TASK_GUI_READY         65
#define BLACKPASS_EXCHANGE_COST          10

enum E_BLACKPASS_TASK_DEF
{
    BP_TASK_DEF_ID,
    BP_TASK_DEF_GROUP,
    BP_TASK_DEF_TARGET,
    BP_TASK_DEF_EXP_REWARD,
    BP_TASK_DEF_MONEY_REWARD,
    BP_TASK_DEF_ROUTE_ID,
    BP_TASK_DEF_BUTTON_TYPE,
    BP_TASK_DEF_LEVEL,
    bool:BP_TASK_DEF_PREMIUM_ONLY
};

new const g_blackpass_task_defs[BLACKPASS_TASK_DEF_COUNT][E_BLACKPASS_TASK_DEF] =
{
    {99,   2, 15000,  800,  0,    144,   1,      1,     false},
    {143,  2, 2,      800,  0,    0,     1,      1,     false},
    {148,  2, 1,      800,  0,    0,     1,      1,     false},
    {255,  2, 5,      800,  0,    0,     4,      1,     false},
    {256,  2, 8,      800,  0,    49,    6,      1,     false},
    {257,  2, 100000, 800,  0,    0,     6,      1,     false},
    {6,    2, 1,      800,  0,    69,    1,      1,     false},
    {254,  1, 1,      200,  0,    0,     1,      1,     false},
    {258,  1, 1,      200,  0,    1,     1,      1,     false},
    {1,    1, 1,      200,  0,    142,   1,      1,     false},
    {2,    1, 1,      200,  0,    144,   1,      1,     false},
    {3,    1, 1,      200,  0,    130,   1,      1,     false},
    {4,    1, 1,      200,  0,    49,    1,      1,     false},
    {159,  1, 1,      200,  0,    129,   1,      1,     false},
    {168,  1, 1,      200,  0,    145,   1,      10,    false},
    {155,  1, 1,      200,  0,    73,    1,      1,     false},
    {156,  1, 1,      200,  0,    74,    1,      1,     false},
    {157,  1, 1,      200,  0,    77,    1,      1,     false},
    {158,  1, 1,      200,  0,    72,    1,      1,     false},
    {100,  1, 1,      200,  0,    61,    1,      1,     false},
    {101,  1, 1,      200,  0,    62,    1,      1,     false},
    {102,  1, 1,      200,  0,    63,    1,      1,     false},
    {103,  1, 1,      200,  0,    65,    1,      1,     false},
    {105,  1, 1,      200,  0,    66,    1,      1,     false},
    {8,    1, 1,      200,  0,    129,   1,      1,     false},
    {9,    1, 1,      200,  0,    129,   1,      1,     false},
    {121,  1, 1,      200,  0,    134,   1,      1,     false},
    {149,  1, 1,      200,  0,    129,   1,      1,     false},
    {249,  1, 1,      200,  0,    134,   1,      1,     false},
    {141,  1, 1,      200,  0,    19,    1,      6,     false},
    {169,  1, 1,      200,  0,    10,    1,      1,     false},
    {171,  1, 1,      200,  0,    1,     1,      2,     false},
    {250,  1, 1,      200,  0,    9,     1,      1,     false},
    {251,  1, 1,      200,  0,    98,    1,      1,     false},
    {252,  1, 1,      200,  0,    13,    1,      2,     false},
    {7,    1, 20,     200,  0,    0,     6,      2,     false},
    {150,  1, 1,      200,  0,    0,     6,      1,     false},
    {151,  1, 1,      200,  0,    0,     6,      1,     false},
    {5,    1, 1,      200,  0,    127,   6,      1,     false},
    {97,   1, 1,      200,  0,    157,   6,      1,     false},
    {106,  1, 1,      200,  0,    127,   6,      1,     false},
    {47,   1, 1,      200,  0,    16,    6,      2,     false},
    {52,   1, 1,      200,  0,    0,     6,      1,     false},
    {56,   1, 3000,   200,  0,    98,    6,      1,     false},
    {57,   1, 3000,   200,  0,    98,    6,      2,     false},
    {58,   1, 3000,   200,  0,    98,    6,      2,     false},
    {59,   1, 10000,  200,  0,    98,    6,      2,     false},
    {60,   1, 3000,   200,  0,    9,     6,      1,     false},
    {61,   1, 3000,   200,  0,    10,    6,      1,     false},
    {96,   1, 1,      200,  0,    32,    6,      2,     false},
    {104,  1, 1,      200,  0,    147,   6,      2,     false},
    {108,  1, 1,      200,  0,    126,   6,      1,     false},
    {124,  1, 1,      200,  0,    0,     6,      1,     false},
    {147,  1, 1,      200,  0,    0,     6,      1,     false}
};

new const g_blackpass_default_task_ids[BLACKPASS_TASK_SLOT_COUNT] =
{
    // Ежедневные (6 слотов) - ТОЛЬКО ТЕ ID, КОТОРЫЕ ЕСТЬ В JSON!
    254,  // Войдите в игру (есть)
    4,    // Посетите казино (есть)
    2,    // Посетите Банк (есть)
    159,  // Посетите Магазин 24/7 (есть)
    124,  // Наденьте аксессуар (есть)
    52,   // Отыграйте 1 час (есть)
    // Еженедельные (5 слотов)
    99,   // Пожертвуйте 15000+ в Банке (есть)
    143,  // Сыграйте 8 игр в Казино (есть)
    6,    // Сделайте тюнинг (есть)
    255,  // Откройте 5 кейсов (есть)
    257   // Заработайте 100000 рублей (есть)
};

enum E_BLACKPASS_TASK_DATA
{
    BP_TASK_ROW_ID,
    BP_TASK_ID,
    BP_TASK_GROUP,
    BP_TASK_PERIOD_KEY,
    BP_TASK_PROGRESS,
    BP_TASK_STORED_STATUS,
    bool:BP_TASK_TRACKED,
    bool:BP_TASK_COMPLETE_NOTIFIED
};

new g_blackpass_tasks[MAX_PLAYERS][BLACKPASS_TASK_SLOT_COUNT][E_BLACKPASS_TASK_DATA];
new bool:g_blackpass_tasks_loaded[MAX_PLAYERS];
new g_blackpass_daily_period[MAX_PLAYERS];
new g_blackpass_weekly_period[MAX_PLAYERS];
new g_blackpass_task_popup[MAX_PLAYERS];
new g_blackpass_tracked_task[MAX_PLAYERS];
new g_blackpass_rating_refresh_until[MAX_PLAYERS];

#define BLACKPASS_REWARD_CASE_ID        99
#define BLACKPASS_REWARD_CASE_INDEX     98
#define BLACKPASS_STANDARD_REWARD_BASE  1000
#define BLACKPASS_PREMIUM_REWARD_BASE   2000
#define BLACKPASS_DELUXE_REWARD_BASE    3000

enum E_BLACKPASS_REWARD_INFO
{
    BP_REWARD_TYPE,
    BP_REWARD_INTERNAL,
    BP_REWARD_COUNT,
    BP_REWARD_RARITY,
    BP_REWARD_PRICE
};

new const g_blackpass_standard_reward_data[BLACKPASS_MAX_LEVELS + 1][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0}, // 0
    {9, 2, 1, 2, 0},    // 1: GOLD 1Д.
    {2, 0, 10000, 1, 0}, // 2: 10.000 Р
    {3, 0, 10, 2, 0},   // 3: 10 BC
    {21, 0, 5, 1, 0},   // 4: X5 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 5: ЕЖЕДНЕВНЫЙ X1
    {9, 1, 1, 1, 0},    // 6: SILVER 1Д.
    {2, 0, 10000, 1, 0}, // 7: 10.000 Р
    {3, 0, 10, 2, 0},   // 8: 10 BC
    {8, 0, 24, 1, 0},   // 9: X2 НА 24Ч.
    {11, 1062, 1, 4, 0}, // 10: Маска (кепарик)
    {9, 1, 1, 1, 0},    // 11: SILVER 1Д
    {2, 0, 10000, 1, 0}, // 12: 10.000 Р
    {3, 0, 10, 2, 0},   // 13: 10 BC
    {21, 0, 5, 1, 0},   // 14: X5 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 15: ЕЖЕДНЕВНЫЙ X1
    {9, 1, 1, 1, 0},    // 16: SILVER 1Д
    {2, 0, 10000, 1, 0}, // 17: 10.000 Р
    {3, 0, 10, 2, 0},   // 18: 10 BC
    {8, 0, 24, 1, 0},   // 19: X2 НА 24Ч.
    {4, 2, 1, 2, 0},    // 20: БОМЖА X1
    {9, 1, 1, 1, 0},    // 21: SILVER 1Д
    {2, 0, 10000, 1, 0}, // 22: 10.000 Р
    {3, 0, 10, 2, 0},   // 23: 10 BC
    {21, 0, 5, 1, 0},   // 24: X5 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 25: ЕЖЕДНЕВНЫЙ X1
    {9, 1, 2, 1, 0},    // 26: SILVER 2Ч.
    {2, 0, 10000, 1, 0}, // 27: 10.000 Р
    {3, 0, 10, 2, 0},   // 28: 10 BC
    {8, 0, 24, 1, 0},   // 29: X2 НА 24Ч.
    {11, 134, 5500078, 4, 0}, // 30: Соня (скин)
    {9, 1, 2, 1, 0},    // 31: SILVER 2Д.
    {2, 0, 20000, 1, 0}, // 32: 20.000 Р
    {3, 0, 20, 2, 0},   // 33: 20 BC
    {21, 0, 5, 1, 0},   // 34: X5 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 35: ЕЖЕДНЕВНЫЙ X1
    {9, 1, 2, 1, 0},    // 36: SILVER 2Д.
    {2, 0, 20000, 1, 0}, // 37: 20.000 Р
    {3, 0, 10, 2, 0},   // 38: 10 BC
    {8, 0, 24, 1, 0},   // 39: X2 НА 24Ч.
    {4, 2, 1, 2, 0},    // 40: БОМЖА X1
    {9, 2, 2, 2, 0},    // 41: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 42: 20.000 Р
    {3, 0, 20, 2, 0},   // 43: 20 BC
    {21, 0, 10, 1, 0},  // 44: X10 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 45: ЕЖЕДНЕВНЫЙ X1
    {9, 2, 2, 2, 0},    // 46: GOLD 2Д.
    {2, 0, 175000, 1, 0}, // 47: 175.000 Р
    {3, 0, 20, 2, 0},   // 48: 20 BC
    {8, 0, 24, 1, 0},   // 49: X2 НА 24Ч.
    {4, 2, 2, 2, 0},    // 50: БОМЖА X2
    {9, 2, 2, 2, 0},    // 51: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 52: 20.000 Р
    {3, 0, 20, 2, 0},   // 53: 20 BC
    {21, 0, 10, 1, 0},  // 54: X10 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 55: ЕЖЕДНЕВНЫЙ X1
    {9, 2, 2, 2, 0},    // 56: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 57: 20.000 Р
    {3, 0, 20, 2, 0},   // 58: 20 BC
    {8, 0, 24, 1, 0},   // 59: X2 НА 24Ч.
    {5, 28730, 0, 5, 0} // 60: VAZ-2105 Street
};

new const g_blackpass_standard_reward_names[BLACKPASS_MAX_LEVELS + 1][64] =
{
    "",
    "GOLD 1Д.",
    "10.000 Р",
    "10 BC",
    "X5 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "SILVER 1Д.",
    "10.000 Р",
    "10 BC",
    "X2 НА 24Ч.",
    "Маска",
    "SILVER 1Д",
    "10.000 Р",
    "10 BC",
    "X5 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "SILVER 1Д",
    "10.000 Р",
    "10 BC",
    "X2 НА 24Ч.",
    "БОМЖА X1",
    "SILVER 1Д",
    "10.000 Р",
    "10 BC",
    "X5 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "SILVER 2Ч.",
    "10.000 Р",
    "10 BC",
    "X2 НА 24Ч.",
    "Соня",
    "SILVER 2Д.",
    "20.000 Р",
    "20 BC",
    "X5 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "SILVER 2Д.",
    "20.000 Р",
    "10 BC",
    "X2 НА 24Ч.",
    "БОМЖА X1",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "X10 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "GOLD 2Д.",
    "175.000 Р",
    "20 BC",
    "X2 НА 24Ч.",
    "БОМЖА X2",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "X10 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "X2 НА 24Ч.",
    "VAZ-2105 Street"
};

new const g_blackpass_premium_reward_data[BLACKPASS_MAX_LEVELS + 1][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0}, // 0
    {3, 0, 40, 3, 0},   // 1: 40 BC
    {2, 0, 20000, 1, 0}, // 2: 20.000 Р
    {3, 0, 20, 2, 0},   // 3: 20 BC
    {21, 0, 10, 1, 0},  // 4: X10 ПЫЛЬ
    {11, 1064, 1, 4, 0}, // 5: Жилет (мама сшила)
    {9, 2, 2, 2, 0},    // 6: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 7: 20.000 Р
    {3, 0, 20, 2, 0},   // 8: 20 BC
    {4, 2, 1, 2, 0},    // 9: БОМЖА X1
    {5, 28727, 0, 5, 0}, // 10: HONDA CB 750
    {9, 2, 2, 2, 0},    // 11: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 12: 20.000 Р
    {3, 0, 20, 2, 0},   // 13: 20 BC
    {21, 0, 10, 1, 0},  // 14: X10 ПЫЛЬ
    {4, 1, 1, 2, 0},    // 15: ЕЖЕДНЕВНЫЙ X1
    {9, 2, 2, 2, 0},    // 16: GOLD 2Д.
    {2, 0, 20000, 2, 0}, // 17: 20.000 Р
    {3, 0, 20, 2, 0},   // 18: 20 BC
    {4, 1, 1, 2, 0},    // 19: ЕЖЕДНЕВНЫЙ X1
    {11, 134, 5500085, 4, 0}, // 20: Стасян (скин)
    {9, 2, 2, 2, 0},    // 21: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 22: 20.000 Р
    {3, 0, 20, 2, 0},   // 23: 20 BC
    {21, 0, 10, 1, 0},  // 24: X10 ПЫЛЬ
    {4, 2, 2, 2, 0},    // 25: БОМЖА X2
    {9, 2, 2, 2, 0},    // 26: GOLD 2Д.
    {2, 0, 20000, 1, 0}, // 27: 20.000 Р
    {3, 0, 20, 2, 0},   // 28: 20 BC
    {4, 2, 1, 2, 0},    // 29: БОМЖА X1
    {5, 28728, 0, 5, 0}, // 30: Honda RD1 CR-V 5
    {9, 2, 2, 2, 0},    // 31: GOLD 2Д.
    {2, 0, 300000, 1, 0}, // 32: 300.000 Р
    {3, 0, 30, 2, 0},   // 33: 30 BC
    {21, 0, 15, 1, 0},  // 34: X15 ПЫЛЬ
    {11, 134, 5500086, 4, 0}, // 35: Артем (скин)
    {9, 2, 2, 2, 0},    // 36: GOLD 2Д.
    {2, 0, 300000, 1, 0}, // 37: 300.000 Р
    {3, 0, 20, 2, 0},   // 38: 20 BC
    {4, 2, 1, 2, 0},    // 39: БОМЖА X1
    {11, 134, 5500087, 4, 0}, // 40: Простак (скин)
    {9, 3, 2, 3, 0},    // 41: PLATINUM 2Д.
    {2, 0, 300000, 1, 0}, // 42: 300.000 Р
    {3, 0, 20, 2, 0},   // 43: 20 BC
    {21, 0, 15, 1, 0},  // 44: X15 ПЫЛЬ
    {11, 31967, 1, 4, 0}, // 45: Шляпа (Голова Лягушки)
    {9, 3, 2, 2, 0},    // 46: PLATINUM 2Д.
    {2, 0, 300000, 1, 0}, // 47: 300.000 Р
    {3, 0, 30, 2, 0},   // 48: 30 BC
    {4, 2, 1, 2, 0},    // 49: БОМЖА X1
    {11, 1065, 1, 4, 0}, // 50: Рюкзак (плеер)
    {9, 3, 2, 3, 0},    // 51: PLATINUM 2Д.
    {2, 0, 300000, 1, 0}, // 52: 300.000 Р
    {3, 0, 30, 2, 0},   // 53: 30 BC
    {21, 0, 20, 2, 0},  // 54: X20 ПЫЛЬ
    {4, 9, 1, 4, 0},    // 55: КЕЙС: ВЕСЕННИЙ X1
    {9, 3, 2, 2, 0},    // 56: PLATINUM 2Д.
    {2, 0, 300000, 1, 0}, // 57: 300.000 Р
    {3, 0, 30, 2, 0},   // 58: 30 BC
    {4, 2, 1, 2, 0},    // 59: БОМЖА X1
    {5, 28729, 0, 5, 0} // 60: Mercedes-Benz 500 SL R107
};

new const g_blackpass_premium_reward_names[BLACKPASS_MAX_LEVELS + 1][64] =
{
    "",
    "40 BC",
    "20.000 Р",
    "20 BC",
    "X10 ПЫЛЬ",
    "Жилет",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "БОМЖА X1",
    "HONDA CB 750",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "X10 ПЫЛЬ",
    "ЕЖЕДНЕВНЫЙ X1",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "ЕЖЕДНЕВНЫЙ X1",
    "Стасян",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "X10 ПЫЛЬ",
    "БОМЖА X2",
    "GOLD 2Д.",
    "20.000 Р",
    "20 BC",
    "БОМЖА X1",
    "Honda RD1 CR-V 5",
    "GOLD 2Д.",
    "300.000 Р",
    "30 BC",
    "X15 ПЫЛЬ",
    "Артем",
    "GOLD 2Д.",
    "300.000 Р",
    "20 BC",
    "БОМЖА X1",
    "Простак",
    "PLATINUM 2Д.",
    "300.000 Р",
    "20 BC",
    "X15 ПЫЛЬ",
    "Шляпа",
    "PLATINUM 2Д.",
    "300.000 Р",
    "30 BC",
    "БОМЖА X1",
    "Рюкзак",
    "PLATINUM 2Д.",
    "300.000 Р",
    "30 BC",
    "X20 ПЫЛЬ",
    "КЕЙС: ВЕСЕННИЙ X1",
    "PLATINUM 2Д.",
    "300.000 Р",
    "30 BC",
    "БОМЖА X1",
    "Mercedes-Benz 500 SL R107"
};

new const g_blackpass_deluxe_reward_data[5][E_BLACKPASS_REWARD_INFO] =
{
    {0, 0, 0, 0, 0},
    {5, 28726, 0, 5, 0}, // BMW 635CSi (E24) 2025
    {9, 3, 360, 5, 0},   // VIP PLATINUM НА 15 Д.
    {21, 0, 250, 5, 0},  // X250 ПЫЛЬ
    {10, 0, 10000, 5, 0} // 10 уровней BP
};

new const g_blackpass_deluxe_reward_names[5][64] =
{
    "",
    "BMW 635CSi (E24) 2025",
    "VIP PLATINUM НА 15 Д.",
    "X250 ПЫЛЬ",
    "10 уровней BP"
};

stock BlackPass_LogEvent(playerid, const action[], reward_id = 0, reward_type = 0, reward_value = 0, amount = 0, extra = 0)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO blackpass_logs (account_id,season_number,action,reward_id,reward_type,reward_value,amount,extra,created_at) VALUES (%d,%d,'%e',%d,%d,%d,%d,%d,UNIX_TIMESTAMP())",
        GetPlayerAccountID(playerid),
        BLACKPASS_SEASON_NUMBER,
        action,
        reward_id,
        reward_type,
        reward_value,
        amount,
        extra
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock BlackPass_ResetPlayer(playerid)
{
    g_blackpass_player[playerid][BP_DATA_LOADED] = false;
    g_blackpass_player[playerid][BP_ACCOUNT_ID] = -1;
    g_blackpass_player[playerid][BP_EXPERIENCE] = 0;
    g_blackpass_player[playerid][BP_LEVEL] = 1;
    g_blackpass_player[playerid][BP_PREMIUM_STATUS] = BLACKPASS_STATUS_NONE;
    g_blackpass_player[playerid][BP_DUST] = 0;
    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;
    g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED] = false;

    for(new i = 0; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        g_blackpass_claimed_standard[playerid][i] = false;
        g_blackpass_claimed_premium[playerid][i] = false;
    }

    g_blackpass_tasks_loaded[playerid] = false;
    g_blackpass_daily_period[playerid] = 0;
    g_blackpass_weekly_period[playerid] = 0;
    g_blackpass_task_popup[playerid] = 0;
    g_blackpass_tracked_task[playerid] = 0;
    g_blackpass_rating_refresh_until[playerid] = 0;

    for(new task_idx = 0; task_idx < BLACKPASS_TASK_SLOT_COUNT; task_idx++)
    {
        g_blackpass_tasks[playerid][task_idx][BP_TASK_ROW_ID] = 0;
        new default_task_id = g_blackpass_default_task_ids[task_idx];
        new def_index = BlackPass_FindTaskDefIndex(default_task_id);
        g_blackpass_tasks[playerid][task_idx][BP_TASK_ID] = default_task_id;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_GROUP] = def_index == -1 ? (task_idx < BLACKPASS_DAILY_TASK_COUNT ? BLACKPASS_TASK_GROUP_DAILY : BLACKPASS_TASK_GROUP_WEEKLY) : g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP];
        g_blackpass_tasks[playerid][task_idx][BP_TASK_PERIOD_KEY] = 0;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_PROGRESS] = 0;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_STORED_STATUS] = BLACKPASS_STATUS_NONE;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_TRACKED] = false;
        g_blackpass_tasks[playerid][task_idx][BP_TASK_COMPLETE_NOTIFIED] = false;
    }
    return 1;
}

stock BlackPass_GetLevelFromExperience(experience)
{
    new level = 1 + (experience / BLACKPASS_LEVEL_EXP);
    if(level < 1) level = 1;
    if(level > BLACKPASS_MAX_LEVELS) level = BLACKPASS_MAX_LEVELS;
    return level;
}

stock BlackPass_GetMaxExperience()
{
    return (BLACKPASS_MAX_LEVELS - 1) * BLACKPASS_LEVEL_EXP;
}

stock BlackPass_BuildClaimFlagsString(playerid, bool:is_premium, output[], output_len)
{
    output[0] = EOS;
    for(new i = 1; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        new part[2];
        part[0] = (is_premium ? g_blackpass_claimed_premium[playerid][i] : g_blackpass_claimed_standard[playerid][i]) ? '1' : '0';
        part[1] = EOS;
        strcat(output, part, output_len);
    }
    return 1;
}

stock BlackPass_ParseClaimFlagsString(playerid, bool:is_premium, const source[])
{
    for(new i = 1; i <= BLACKPASS_MAX_LEVELS; i++)
    {
        new bool:is_claimed = ((i - 1) < strlen(source) && source[i - 1] == '1');
        if(is_premium) g_blackpass_claimed_premium[playerid][i] = is_claimed;
        else g_blackpass_claimed_standard[playerid][i] = is_claimed;
    }
    return 1;
}

stock BlackPass_GetCurrentLevel(playerid)
{
    g_blackpass_player[playerid][BP_LEVEL] = BlackPass_GetLevelFromExperience(g_blackpass_player[playerid][BP_EXPERIENCE]);
    return g_blackpass_player[playerid][BP_LEVEL];
}

stock BlackPass_GetClientPremiumStatus(status)
{
    switch(status)
    {
        case BLACKPASS_STATUS_PREMIUM: return 2;
        case BLACKPASS_STATUS_DELUXE: return 1;
    }
    return 0;
}

stock BlackPass_SetJsonInt(Node:json, const key[], value)
{
    JSON_SetObject(json, key, JSON_Int(value));
    return 1;
}

stock BlackPass_RefreshStateFlags(playerid, Node:json)
{
    new current_level = BlackPass_GetCurrentLevel(playerid);
    JSON_SetInt(json, "lv", current_level);
    JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
    JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
    JSON_SetInt(json, "es", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "l", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "lc", g_blackpass_player[playerid][BP_SELECTED_LAYOUT]);
    JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][current_level] ? 0 : 1);
    JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][current_level] ? 0 : 1);
    return 1;
}

stock BlackPass_GetRewardInventoryItemId(level, bool:is_premium)
{
    return (is_premium ? BLACKPASS_PREMIUM_REWARD_BASE : BLACKPASS_STANDARD_REWARD_BASE) + level;
}

stock BlackPass_GetDeluxeInventoryItemId(index)
{
    return BLACKPASS_DELUXE_REWARD_BASE + index;
}

stock BlackPass_IsRewardInventoryItem(itemid)
{
    if(itemid >= BLACKPASS_STANDARD_REWARD_BASE + 1 && itemid <= BLACKPASS_STANDARD_REWARD_BASE + BLACKPASS_MAX_LEVELS) return 1;
    if(itemid >= BLACKPASS_PREMIUM_REWARD_BASE + 1 && itemid <= BLACKPASS_PREMIUM_REWARD_BASE + BLACKPASS_MAX_LEVELS) return 1;
    if(itemid >= BLACKPASS_DELUXE_REWARD_BASE + 1 && itemid <= BLACKPASS_DELUXE_REWARD_BASE + 4) return 1;
    return 0;
}

stock BlackPass_GetRewardInventoryData(itemid, name[], name_len, &type, &internal, &count, &rarity, &price)
{
    name[0] = EOS;
    type = 0;
    internal = 0;
    count = 0;
    rarity = 0;
    price = 0;
    if(itemid >= BLACKPASS_STANDARD_REWARD_BASE + 1 && itemid <= BLACKPASS_STANDARD_REWARD_BASE + BLACKPASS_MAX_LEVELS)
    {
        new level = itemid - BLACKPASS_STANDARD_REWARD_BASE;
        if(1 <= level <= BLACKPASS_MAX_LEVELS)
        {
            format(name, name_len, "%s", g_blackpass_standard_reward_names[level]);
            type = g_blackpass_standard_reward_data[level][BP_REWARD_TYPE];
            internal = g_blackpass_standard_reward_data[level][BP_REWARD_INTERNAL];
            count = g_blackpass_standard_reward_data[level][BP_REWARD_COUNT];
            rarity = g_blackpass_standard_reward_data[level][BP_REWARD_RARITY];
            price = g_blackpass_standard_reward_data[level][BP_REWARD_PRICE];
            return 1;
        }
        return 0;
    }
    if(itemid >= BLACKPASS_PREMIUM_REWARD_BASE + 1 && itemid <= BLACKPASS_PREMIUM_REWARD_BASE + BLACKPASS_MAX_LEVELS)
    {
        new level = itemid - BLACKPASS_PREMIUM_REWARD_BASE;
        if(1 <= level <= BLACKPASS_MAX_LEVELS)
        {
            format(name, name_len, "%s", g_blackpass_premium_reward_names[level]);
            type = g_blackpass_premium_reward_data[level][BP_REWARD_TYPE];
            internal = g_blackpass_premium_reward_data[level][BP_REWARD_INTERNAL];
            count = g_blackpass_premium_reward_data[level][BP_REWARD_COUNT];
            rarity = g_blackpass_premium_reward_data[level][BP_REWARD_RARITY];
            price = g_blackpass_premium_reward_data[level][BP_REWARD_PRICE];
            return 1;
        }
        return 0;
    }
    if(itemid >= BLACKPASS_DELUXE_REWARD_BASE + 1 && itemid <= BLACKPASS_DELUXE_REWARD_BASE + 4)
    {
        new index = itemid - BLACKPASS_DELUXE_REWARD_BASE;
        if(1 <= index <= 4)
        {
            format(name, name_len, "%s", g_blackpass_deluxe_reward_names[index]);
            type = g_blackpass_deluxe_reward_data[index][BP_REWARD_TYPE];
            internal = g_blackpass_deluxe_reward_data[index][BP_REWARD_INTERNAL];
            count = g_blackpass_deluxe_reward_data[index][BP_REWARD_COUNT];
            rarity = g_blackpass_deluxe_reward_data[index][BP_REWARD_RARITY];
            price = g_blackpass_deluxe_reward_data[index][BP_REWARD_PRICE];
            return 1;
        }
    }
    return 0;
}

stock BlackPass_HasQueuedReward(playerid, itemid)
{
    for(new i = 0; i < g_PlayerRewardsCount[playerid]; i++)
    {
        if(g_PlayerRewards[playerid][i][rCase] == BLACKPASS_REWARD_CASE_ID && g_PlayerRewards[playerid][i][rItem] == itemid)
        {
            return 1;
        }
    }
    return 0;
}

stock BlackPass_QueueInventoryReward(playerid, itemid)
{
    if(!BlackPass_IsRewardInventoryItem(itemid)) return 0;
    
    new name[64], type, internal, count, rarity, price;
    BlackPass_GetRewardInventoryData(itemid, name, sizeof(name), type, internal, count, rarity, price);
    
    // Определяем тип награды для BPR
    new bpr_type;
    new image_id = internal;
    new skin_model = -1;
    new days = 30;
    
    if(type == 1) // EXP
    {
        BPR_GiveReward(playerid, 1, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 2) // Деньги
    {
        BPR_GiveReward(playerid, 2, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 3) // BC
    {
        BPR_GiveReward(playerid, 3, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 4) // Кейсы
    {
        BPR_GiveReward(playerid, 4, internal, name, rarity, count, 0, 0, -1);
    }
    else if(type == 5) // Автомобили
    {
        BPR_GiveCar(playerid, internal, name, rarity, 30, -1);
    }
    else if(type == 8)
    {
        BPR_GiveReward(playerid, 8, 1, name, rarity, count, 0, 0, 0);
    }
    else if(type == 9) // VIP
    {
        BPR_GiveReward(playerid, 9, internal, name, rarity, count, days, 0, -1);
    }
    else if(type == 10)
    {
        BPR_GiveReward(playerid, 10, internal, name, rarity, count, days, 0, -1);
    }
    else if(type == 11) // Инвентарь
    {
        if(internal == 134) // Скин
        {
            BPR_GiveSkin(playerid, count, name, rarity, days, 0);
        }
        else // Аксессуар
        {
            BPR_GiveAccessory(playerid, count, internal, name, rarity, days, 0);
        }
    }
    else if(type == 21)
    {
        BPR_GiveReward(playerid, 21, 1, name, rarity, count, days, 0, -1);
    }
    else
    {
        BPR_GiveReward(playerid, type, internal, name, rarity, count, days, 0, -1);
    }
    return 1;
}

stock BlackPass_QueueLevelReward(playerid, level, bool:is_premium)
{
    if(level < 1 || level > BLACKPASS_MAX_LEVELS) return 0;
    
    new itemid = BlackPass_GetRewardInventoryItemId(level, is_premium);
    new name[64], type, internal, count, rarity, price;
    BlackPass_GetRewardInventoryData(itemid, name, sizeof(name), type, internal, count, rarity, price);
    
    // Определяем срок действия для премиум наград
    new days = is_premium ? 365 : 30;
    
    // Выдаём награду через BPR
    if(type == 1) // EXP
    {
        BPR_GiveReward(playerid, 1, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 2) // Деньги
    {
        BPR_GiveReward(playerid, 2, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 3) // BC
    {
        BPR_GiveReward(playerid, 3, 1, name, rarity, count, 0, 0, -1);
    }
    else if(type == 4) // Кейсы
    {
        BPR_GiveReward(playerid, 4, internal, name, rarity, count, 0, 0, -1);
    }
    else if(type == 5) // Автомобили
    {
        BPR_GiveCar(playerid, internal, name, rarity, 30, -1);
    }
    else if(type == 8)
    {
        BPR_GiveReward(playerid, 8, 1, name, rarity, count, 0, 0, 0);
    }
    else if(type == 9) // VIP
    {
        BPR_GiveReward(playerid, 9, internal, name, rarity, count, days, 0, -1);
    }
    else if(type == 10)
    {
        BPR_GiveReward(playerid, 10, internal, name, rarity, count, days, 0, -1);
    }
    else if(type == 11) // Инвентарь
    {
        if(internal == 134) // Скин
        {
            BPR_GiveSkin(playerid, count, name, rarity, days, 0);
        }
        else // Аксессуар
        {
            BPR_GiveAccessory(playerid, internal, internal, name, rarity, days, 0);
        }
    }
    else if(type == 21)
    {
        BPR_GiveReward(playerid, 21, 1, name, rarity, count, days, 0, -1);
    }
    else
    {
        BPR_GiveReward(playerid, type, internal, name, rarity, count, days, 0, -1);
    }
    
    return 1;
}

stock BlackPass_QueueDeluxeRewards(playerid, bool:skip_level_reward = true)
{
    for(new i = 1; i <= 4; i++)
    {
        if(skip_level_reward && i == 4) continue;
        new itemid = BlackPass_GetDeluxeInventoryItemId(i);
        BlackPass_QueueInventoryReward(playerid, itemid);
    }
    return 1;
}

stock BlackPass_ShowLootNotification(playerid, message[])
{
    ShowNotificationSile(playerid, 3, 3, 0, 0, message);
    return 1;
}

stock BlackPass_SendLayoutPacket(playerid, layout_id)
{
    new Node:layout_json = JSON_Object();
    BlackPass_SendMainPacket(playerid, layout_json, layout_id);
    JSON_Cleanup(layout_json);
    return 1;
}

stock BlackPass_OpenLoot(playerid)
{
    BPR_Open(playerid);
    return 1;
}

stock BlackPass_SendStateRefresh(playerid, current_layout = 0, visible_layout = -1)
{
    new Node:refresh_json = JSON_Object();
    BlackPass_FillBasePacket(playerid, refresh_json);
    JSON_SetInt(refresh_json, "t", -1);
    JSON_SetInt(refresh_json, "ty", -1);
    JSON_SetInt(refresh_json, "la", visible_layout);
    JSON_SetInt(refresh_json, "lv", g_blackpass_player[playerid][BP_LEVEL]);
    JSON_SetInt(refresh_json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
    JSON_SetInt(refresh_json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
    JSON_SetInt(refresh_json, "es", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(refresh_json, "l", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(refresh_json, "lc", current_layout);
    JSON_SetInt(refresh_json, "is", g_blackpass_claimed_standard[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);
    JSON_SetInt(refresh_json, "ps", g_blackpass_claimed_premium[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);
    SendPacketToClient(playerid, 22, refresh_json);
    JSON_Cleanup(refresh_json);
    return 1;
}
stock BlackPass_AutoClaimRewardsRange(playerid, start_level, end_level, bool:claim_standard, bool:claim_premium)
{
    if(start_level < 1) start_level = 1;
    if(end_level > BLACKPASS_MAX_LEVELS) end_level = BLACKPASS_MAX_LEVELS;
    if(start_level > end_level) return 0;

    for(new level = start_level; level <= end_level; level++)
    {
        if(claim_standard && !g_blackpass_claimed_standard[playerid][level])
        {
            g_blackpass_claimed_standard[playerid][level] = true;
            BlackPass_QueueLevelReward(playerid, level, false);
        }

        if(claim_premium && !g_blackpass_claimed_premium[playerid][level])
        {
            g_blackpass_claimed_premium[playerid][level] = true;
            BlackPass_QueueLevelReward(playerid, level, true);
        }
    }
    return 1;
}

stock BlackPass_AddDust(playerid, amount)
{
    if(!g_blackpass_player[playerid][BP_DATA_LOADED])
    {
        if(!BlackPass_LoadPlayer(playerid)) return 0;
    }

    g_blackpass_player[playerid][BP_DUST] += amount;
    if(g_blackpass_player[playerid][BP_DUST] < 0) g_blackpass_player[playerid][BP_DUST] = 0;
    BlackPass_SavePlayer(playerid);
    BlackPass_LogEvent(playerid, "dust_add", 0, 21, 0, amount, g_blackpass_player[playerid][BP_DUST]);
    return 1;
}

stock BlackPass_GrantExperience(playerid, experience)
{
    if(!g_blackpass_player[playerid][BP_DATA_LOADED])
    {
        if(!BlackPass_LoadPlayer(playerid)) return 0;
    }

    g_blackpass_player[playerid][BP_EXPERIENCE] += experience;
    if(g_blackpass_player[playerid][BP_EXPERIENCE] < 0) g_blackpass_player[playerid][BP_EXPERIENCE] = 0;
    if(g_blackpass_player[playerid][BP_EXPERIENCE] > BlackPass_GetMaxExperience())
    {
        g_blackpass_player[playerid][BP_EXPERIENCE] = BlackPass_GetMaxExperience();
    }

    g_blackpass_player[playerid][BP_LEVEL] = BlackPass_GetLevelFromExperience(g_blackpass_player[playerid][BP_EXPERIENCE]);
    BlackPass_SavePlayer(playerid);
    return 1;
}

stock BlackPass_SetLevelWithReset(playerid, target_level)
{
    if(!g_blackpass_player[playerid][BP_DATA_LOADED])
    {
        if(!BlackPass_LoadPlayer(playerid)) return 0;
    }

    if(target_level < 1) target_level = 1;
    if(target_level > BLACKPASS_MAX_LEVELS) target_level = BLACKPASS_MAX_LEVELS;

    g_blackpass_player[playerid][BP_LEVEL] = target_level;
    g_blackpass_player[playerid][BP_EXPERIENCE] = (target_level - 1) * BLACKPASS_LEVEL_EXP;
    BlackPass_SavePlayer(playerid);
    return 1;
}

stock BlackPass_AddLevelsWithReset(playerid, levels_to_add)
{
    if(levels_to_add <= 0) return BlackPass_GetCurrentLevel(playerid);

    new old_level = BlackPass_GetCurrentLevel(playerid);
    new target_level = old_level + levels_to_add;
    if(target_level > BLACKPASS_MAX_LEVELS) target_level = BLACKPASS_MAX_LEVELS;

    BlackPass_SetLevelWithReset(playerid, target_level);
    return BlackPass_GetCurrentLevel(playerid);
}

stock BlackPass_SendLevelSyncPacket(playerid, level = -1, exp_value = -1)
{
    new Node:sync_json = JSON_Object();
    if(level == -1) level = BlackPass_GetCurrentLevel(playerid);
    if(exp_value == -1) exp_value = g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP;
    JSON_SetInt(sync_json, "t", -1);
    JSON_SetInt(sync_json, "ty", 3);
    JSON_SetInt(sync_json, "tb", -2);
    JSON_SetInt(sync_json, "e", exp_value);
    JSON_SetInt(sync_json, "l", level);
    SendPacketToClient(playerid, 22, sync_json);
    JSON_Cleanup(sync_json);
    return 1;
}

stock BlackPass_SendLevelSyncRange(playerid, old_level, new_level)
{
    if(new_level <= old_level)
    {
        return BlackPass_SendLevelSyncPacket(playerid);
    }

    for(new level = old_level + 1; level <= new_level; level++)
    {
        BlackPass_SendLevelSyncPacket(playerid, level, level == new_level ? g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP : 0);
    }
    return 1;
}


stock BlackPass_SavePlayer(playerid)
{
    if(!g_blackpass_player[playerid][BP_DATA_LOADED]) return 0;

    new claimed_standard[BLACKPASS_MAX_LEVELS + 1];
    new claimed_premium[BLACKPASS_MAX_LEVELS + 1];
    new query[1024];

    BlackPass_BuildClaimFlagsString(playerid, false, claimed_standard, sizeof(claimed_standard));
    BlackPass_BuildClaimFlagsString(playerid, true, claimed_premium, sizeof(claimed_premium));

    mysql_format(mysql, query, sizeof(query),
        "UPDATE blackpass_players SET experience=%d, level=%d, premium_status=%d, dust=%d, selected_layout=%d, deluxe_rewards_claimed=%d, claimed_standard='%e', claimed_premium='%e', updated_at=UNIX_TIMESTAMP() WHERE account_id=%d AND season_number=%d LIMIT 1",
        g_blackpass_player[playerid][BP_EXPERIENCE],
        g_blackpass_player[playerid][BP_LEVEL],
        g_blackpass_player[playerid][BP_PREMIUM_STATUS],
        g_blackpass_player[playerid][BP_DUST],
        g_blackpass_player[playerid][BP_SELECTED_LAYOUT],
        g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED],
        claimed_standard,
        claimed_premium,
        GetPlayerAccountID(playerid),
        BLACKPASS_SEASON_NUMBER
    );
    mysql_query(mysql, query, false);

    printf("[BLACKPASS][SAVE] player=%d account=%d exp=%d level=%d premium=%d dust=%d layout=%d deluxe=%d",
        playerid,
        GetPlayerAccountID(playerid),
        g_blackpass_player[playerid][BP_EXPERIENCE],
        g_blackpass_player[playerid][BP_LEVEL],
        g_blackpass_player[playerid][BP_PREMIUM_STATUS],
        g_blackpass_player[playerid][BP_DUST],
        g_blackpass_player[playerid][BP_SELECTED_LAYOUT],
        g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED]
    );
    return 1;
}


stock BlackPass_SendRewardClaimPacket(playerid, reward_id, bool:is_premium, layout_id = 0)
{
    new Node:claim_json = JSON_Object();
    JSON_SetInt(claim_json, "t", -1);
    JSON_SetInt(claim_json, "ty", 2);
    JSON_SetInt(claim_json, "la", layout_id);
    JSON_SetInt(claim_json, "s", 1);
    JSON_SetInt(claim_json, "id", reward_id);
    JSON_SetInt(claim_json, "p", is_premium ? 1 : 0);
    SendPacketToClient(playerid, 22, claim_json);
    JSON_Cleanup(claim_json);
    return 1;
}


stock BlackPass_SendClaimPacketsRange(playerid, start_level, end_level, bool:claim_standard, bool:claim_premium, layout_id = 0)
{
    if(start_level < 1) start_level = 1;
    if(end_level > BLACKPASS_MAX_LEVELS) end_level = BLACKPASS_MAX_LEVELS;
    if(start_level > end_level) return 0;

    for(new level = start_level; level <= end_level; level++)
    {
        if(claim_standard && g_blackpass_claimed_standard[playerid][level])
        {
            BlackPass_SendRewardClaimPacket(playerid, level, false, layout_id);
        }

        if(claim_premium && g_blackpass_claimed_premium[playerid][level])
        {
            BlackPass_SendRewardClaimPacket(playerid, level, true, layout_id);
        }
    }
    return 1;
}
stock BlackPass_SendAutoClaimSyncRange(playerid, old_level, new_level, bool:claim_standard, bool:claim_premium, layout_id = 0)
{
    if(new_level <= old_level)
    {
        return 0;
    }

    for(new level = old_level + 1; level <= new_level; level++)
    {
        BlackPass_SendLevelSyncPacket(playerid, level, level == new_level ? g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP : 0);

        if(claim_standard && g_blackpass_claimed_standard[playerid][level])
        {
            BlackPass_SendRewardClaimPacket(playerid, level, false, layout_id);
        }

        if(claim_premium && g_blackpass_claimed_premium[playerid][level])
        {
            BlackPass_SendRewardClaimPacket(playerid, level, true, layout_id);
        }
    }
    return 1;
}
stock BlackPass_LoadPlayer(playerid)
{

    BlackPass_ResetPlayer(playerid);

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT * FROM blackpass_players WHERE account_id=%d AND season_number=%d LIMIT 1",
        GetPlayerAccountID(playerid),
        BLACKPASS_SEASON_NUMBER
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[BLACKPASS][ERROR] Load failed: player=%d account=%d errno=%d query=%s", playerid, GetPlayerAccountID(playerid), mysql_errno(), query);
        cache_delete(result);
        return 0;
    }

    if(cache_num_rows() == 0)
    {
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO blackpass_players (account_id,season_number,experience,level,premium_status,dust,selected_layout,deluxe_rewards_claimed,claimed_standard,claimed_premium,created_at,updated_at) VALUES (%d,%d,0,1,0,0,0,0,'%s','%s',UNIX_TIMESTAMP(),UNIX_TIMESTAMP())",
            GetPlayerAccountID(playerid),
            BLACKPASS_SEASON_NUMBER,
            "0000000000000000000000000000000000000000000000000000000000000",
            "0000000000000000000000000000000000000000000000000000000000000"
        );
        mysql_query(mysql, query, false);
        g_blackpass_player[playerid][BP_DATA_LOADED] = true;
        g_blackpass_player[playerid][BP_ACCOUNT_ID] = GetPlayerAccountID(playerid);
        cache_delete(result);
        return 1;
    }

    new claimed_standard[BLACKPASS_MAX_LEVELS + 1];
    new claimed_premium[BLACKPASS_MAX_LEVELS + 1];

    g_blackpass_player[playerid][BP_EXPERIENCE] = cache_get_field_content_int(0, "experience");
    g_blackpass_player[playerid][BP_LEVEL] = cache_get_field_content_int(0, "level");
    g_blackpass_player[playerid][BP_PREMIUM_STATUS] = cache_get_field_content_int(0, "premium_status");
    g_blackpass_player[playerid][BP_DUST] = cache_get_field_content_int(0, "dust");
    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = cache_get_field_content_int(0, "selected_layout");
    g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED] = bool:cache_get_field_content_int(0, "deluxe_rewards_claimed");

    cache_get_field_content(0, "claimed_standard", claimed_standard, sizeof(claimed_standard));
    cache_get_field_content(0, "claimed_premium", claimed_premium, sizeof(claimed_premium));
    BlackPass_ParseClaimFlagsString(playerid, false, claimed_standard);
    BlackPass_ParseClaimFlagsString(playerid, true, claimed_premium);

    if(g_blackpass_player[playerid][BP_LEVEL] < 1)
    {
        g_blackpass_player[playerid][BP_LEVEL] = BlackPass_GetLevelFromExperience(g_blackpass_player[playerid][BP_EXPERIENCE]);
    }

    g_blackpass_player[playerid][BP_DATA_LOADED] = true;
    g_blackpass_player[playerid][BP_ACCOUNT_ID] = GetPlayerAccountID(playerid);
    cache_delete(result);

    return 1;
}

stock BlackPass_GetCurrentTaskPeriod(task_group)
{
    switch(task_group)
    {
        case BLACKPASS_TASK_GROUP_DAILY: return gettime() / 86400;
        case BLACKPASS_TASK_GROUP_WEEKLY: return gettime() / 604800;
    }
    return 0;
}

stock BlackPass_GetTaskResetTimer()
{
    new left = 86400 - (gettime() % 86400);
    if(left <= 0) left = 1;
    return left;
}

stock BlackPass_FindTaskDefIndex(task_id)
{
    for(new idx = 0; idx < BLACKPASS_TASK_DEF_COUNT; idx++)
    {
        if(g_blackpass_task_defs[idx][BP_TASK_DEF_ID] == task_id)
        {
            return idx;
        }
    }
    return -1;
}

stock BlackPass_FindTaskSlot(playerid, task_id)
{
    for(new idx = 0; idx < BLACKPASS_TASK_SLOT_COUNT; idx++)
    {
        if(g_blackpass_tasks[playerid][idx][BP_TASK_ID] == task_id)
        {
            return idx;
        }
    }
    return -1;
}

stock BlackPass_GetTaskDefIndexFromSlot(playerid, task_index)
{
    if(!(0 <= task_index < BLACKPASS_TASK_SLOT_COUNT)) return -1;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_ID] <= 0) return -1;
    return BlackPass_FindTaskDefIndex(g_blackpass_tasks[playerid][task_index][BP_TASK_ID]);
}

stock BlackPass_ClearTaskSlot(playerid, task_index, task_group)
{
    g_blackpass_tasks[playerid][task_index][BP_TASK_ROW_ID] = 0;
    g_blackpass_tasks[playerid][task_index][BP_TASK_ID] = 0;
    g_blackpass_tasks[playerid][task_index][BP_TASK_GROUP] = task_group;
    g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY] = BlackPass_GetCurrentTaskPeriod(task_group);
    g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] = 0;
    g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = BLACKPASS_STATUS_NONE;
    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = false;
    g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = false;
    return 1;
}

stock BlackPass_AssignTaskSlot(playerid, task_index, task_id, row_id = 0)
{
    new def_index = BlackPass_FindTaskDefIndex(task_id);
    if(def_index == -1) return 0;

    g_blackpass_tasks[playerid][task_index][BP_TASK_ROW_ID] = row_id;
    g_blackpass_tasks[playerid][task_index][BP_TASK_ID] = task_id;
    g_blackpass_tasks[playerid][task_index][BP_TASK_GROUP] = g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP];
    g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY] = BlackPass_GetCurrentTaskPeriod(g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP]);
    g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] = 0;
    g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = BLACKPASS_STATUS_NONE;
    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = false;
    g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = false;
    printf("[DEBUG] Assigned task %d to slot %d for player %d", task_id, task_index, playerid);
    return 1;
}

stock BlackPass_GetNextFreeTaskSlot(playerid, task_group)
{
    new start_idx = (task_group == BLACKPASS_TASK_GROUP_WEEKLY) ? BLACKPASS_DAILY_TASK_COUNT : 0;
    new end_idx = (task_group == BLACKPASS_TASK_GROUP_WEEKLY) ? BLACKPASS_TASK_SLOT_COUNT : BLACKPASS_DAILY_TASK_COUNT;

    for(new idx = start_idx; idx < end_idx; idx++)
    {
        if(g_blackpass_tasks[playerid][idx][BP_TASK_ID] == 0)
        {
            return idx;
        }
    }
    return -1;
}

stock BlackPass_IsTaskActive(playerid, task_id)
{
    return BlackPass_FindTaskSlot(playerid, task_id) != -1;
}

stock BlackPass_GetTaskDescription(task_id, output[], output_len)
{
    output[0] = EOS;
    switch(task_id)
    {
        // ===== ЕЖЕНЕДЕЛЬНЫЕ (7 штук) =====
        case 99:  format(output, output_len, "Пожертвуйте 15000 рублей или более в Банке");
        case 143: format(output, output_len, "Поздоровайтесь с 2 игроками");
        case 148: format(output, output_len, "Подарите букет цветов персонажу противоположного пола");
        case 255: format(output, output_len, "Откройте 5 любых кейсов");
        case 256: format(output, output_len, "Сыграйте 8 любых игр в Казино");
        case 257: format(output, output_len, "Заработайте 100 000 рублей");
        case 6:   format(output, output_len, "Сделайте тюнинг своего автомобиля в СТО");

        // ===== ЕЖЕДНЕВНЫЕ (45 штук) =====
        // ID 254
        case 254: format(output, output_len, "Войдите в игру");
        // ID 258, 1, 2, 3, 4, 159, 168 (посещения)
        case 258: format(output, output_len, "Посетите Правительство");
        case 1:   format(output, output_len, "Посетите Больницу");
        case 2:   format(output, output_len, "Посетите Банк");
        case 3:   format(output, output_len, "Посетите Закусочную");
        case 4:   format(output, output_len, "Посетите Казино");
        case 159: format(output, output_len, "Посетите Магазин 24/7");
        case 168: format(output, output_len, "Посетите офис Транспортной компании");
        // ID 155, 156, 157, 158 (города)
        case 155: format(output, output_len, "Посетите Арзамас");
        case 156: format(output, output_len, "Посетите Рублевку");
        case 157: format(output, output_len, "Посетите Лыткарино");
        case 158: format(output, output_len, "Посетите Южный");
        // ID 100, 101, 102, 103, 105 (автосалоны)
        case 100: format(output, output_len, "Посетите Автосалон Низкого класса");
        case 101: format(output, output_len, "Посетите Автосалон Среднего класса");
        case 102: format(output, output_len, "Посетите Автосалон Высокого класса");
        case 103: format(output, output_len, "Посетите Мотосалон");
        case 105: format(output, output_len, "Посетите любой авторынок");
        // ID 8, 9, 121, 149, 249 (покупки)
        case 8:   format(output, output_len, "Купите букет цветов");
        case 9:   format(output, output_len, "Купите 1 ремонтный набор");
        case 121: format(output, output_len, "Купите 1 любой товар в Ларьке");
        case 149: format(output, output_len, "Купите аптечку в Магазине 24/7");
        case 249: format(output, output_len, "Купите 1 любой товар в киоске у Вокзала");
        // ID 141, 169, 171, 250, 251, 252 (начало работы)
        case 141: format(output, output_len, "Начните рабочий день в МЧС");
        case 169: format(output, output_len, "Начните рабочий день Сборщиком на заводе");
        case 171: format(output, output_len, "Начните рабочий день Водителем автобуса");
        case 250: format(output, output_len, "Начните рабочий день на Шахте");
        case 251: format(output, output_len, "Начните рабочий день на Ферме");
        case 252: format(output, output_len, "Начните рабочий день Курьером");
        // ID 7, 150, 151 (транспорт)
        case 7:   format(output, output_len, "Проедьте 20 км на транспорте, будучи за рулем");
        case 150: format(output, output_len, "Разгонитесь до 150 км/ч на любом транспорте");
        case 151: format(output, output_len, "Разгонитесь до 100 км/ч на мотоцикле");
        // ID 5, 97, 106 (АЗС и ГИБДД)
        case 5:   format(output, output_len, "Заправьте свой транспорт на АЗС");
        case 97:  format(output, output_len, "Прокрутите случайные номера авто в ГИБДД");
        case 106: format(output, output_len, "Купите канистру с бензином на АЗС");
        // ID 47, 52, 56, 57, 58, 59, 60, 61 (работа)
        case 47:  format(output, output_len, "Подстрелите 1 животное на работе Охотник");
        case 52:  format(output, output_len, "Отыграйте 1 час");
        case 56:  format(output, output_len, "Заработайте 3000 рублей Сборщиком на ферме");
        case 57:  format(output, output_len, "Заработайте 3000 рублей Дояром на ферме");
        case 58:  format(output, output_len, "Заработайте 3000 рублей Комбайнером на ферме");
        case 59:  format(output, output_len, "Заработайте 10000 рублей Пчеловодом на ферме");
        case 60:  format(output, output_len, "Заработайте 3000 рублей Шахтером");
        case 61:  format(output, output_len, "Заработайте 3000 рублей Сборщиком на заводе");
        // ID 96, 104, 108, 124, 147 (разное)
        case 96:  format(output, output_len, "Подайте объявление в СМИ (/ad)");
        case 104: format(output, output_len, "Возьмите машину на тест-драйв в автосалоне");
        case 108: format(output, output_len, "Арендуйте скутер");
        case 124: format(output, output_len, "Наденьте любой аксессуар");
        case 147: format(output, output_len, "Используйте аптечку");

        default:  format(output, output_len, "Задание Black Pass");
    }
    return 1;
}

stock BlackPass_TaskHasAction(playerid, task_index)
{
    if(!(0 <= task_index < BLACKPASS_TASK_SLOT_COUNT)) return 0;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return 0;
    if(g_blackpass_task_defs[def_index][BP_TASK_DEF_ROUTE_ID] > 0) return 1;
    if(g_blackpass_task_defs[def_index][BP_TASK_DEF_BUTTON_TYPE] >= 4) return 1;
    return 0;
}

stock BlackPass_GetStoredTaskStatus(playerid, task_index)
{
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return BLACKPASS_STATUS_NONE;

    if(g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] == BLACKPASS_TASK_STATUS_CLAIMED)
    {
        return BLACKPASS_TASK_STATUS_CLAIMED;
    }

    if(g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] >= g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET])
    {
        return BLACKPASS_TASK_STATUS_REWARD;
    }

    if(g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] && BlackPass_TaskHasAction(playerid, task_index))
    {
        return BLACKPASS_TASK_STATUS_TRACKED;
    }

    return BLACKPASS_STATUS_NONE;
}

stock BlackPass_GetClientTaskStatus(playerid, task_index)
{
    if(!(0 <= task_index < BLACKPASS_TASK_SLOT_COUNT)) return BLACKPASS_TASK_STATUS_LOCKED;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return BLACKPASS_TASK_STATUS_LOCKED;

    // ПРОВЕРКА НА CLAIMED В ПЕРВУЮ ОЧЕРЕДЬ!
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] == BLACKPASS_TASK_STATUS_CLAIMED)
    {
        return BLACKPASS_TASK_STATUS_CLAIMED;
    }

    if(GetPlayerLevel(playerid) < g_blackpass_task_defs[def_index][BP_TASK_DEF_LEVEL])
    {
        return BLACKPASS_TASK_STATUS_LOCKED;
    }

    if(g_blackpass_task_defs[def_index][BP_TASK_DEF_PREMIUM_ONLY] && g_blackpass_player[playerid][BP_PREMIUM_STATUS] == BLACKPASS_STATUS_NONE)
    {
        return BLACKPASS_TASK_STATUS_PREMIUM;
    }

    if(g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] >= g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET])
    {
        return BLACKPASS_TASK_STATUS_REWARD;
    }

    if(g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] && BlackPass_TaskHasAction(playerid, task_index))
    {
        return BLACKPASS_TASK_STATUS_TRACKED;
    }

    if(BlackPass_TaskHasAction(playerid, task_index))
    {
        return BLACKPASS_TASK_STATUS_GO_TO;
    }

    return BLACKPASS_TASK_STATUS_LOCKED;
}

stock BlackPass_EnableTaskGps(playerid, task_id)
{
    switch(task_id)
    {
        case 1, 85: return EnablePlayerGPS(playerid, gps_banks[0][G_MARKET_TYPE], gps_banks[0][G_POS_X], gps_banks[0][G_POS_Y], gps_banks[0][G_POS_Z], "");
        case 2, 28: return EnablePlayerGPS(playerid, gps_banks[1][G_MARKET_TYPE], gps_banks[1][G_POS_X], gps_banks[1][G_POS_Y], gps_banks[1][G_POS_Z], "");
        case 3, 7, 27, 58: return EnablePlayerGPS(playerid, gps_state_organizations[1][G_MARKET_TYPE], gps_state_organizations[1][G_POS_X], gps_state_organizations[1][G_POS_Y], gps_state_organizations[1][G_POS_Z], "");
        case 4, 12, 23, 24, 71, 72: return EnablePlayerGPS(playerid, gps_entertainment[0][G_MARKET_TYPE], gps_entertainment[0][G_POS_X], gps_entertainment[0][G_POS_Y], gps_entertainment[0][G_POS_Z], "");
        case 5, 35, 37, 54: return EnablePlayerGPS(playerid, gps_jobs[1][G_MARKET_TYPE], gps_jobs[1][G_POS_X], gps_jobs[1][G_POS_Y], gps_jobs[1][G_POS_Z], "");
        case 6: return EnablePlayerGPS(playerid, gps_jobs[0][G_MARKET_TYPE], gps_jobs[0][G_POS_X], gps_jobs[0][G_POS_Y], gps_jobs[0][G_POS_Z], "");
        case 8, 9, 10, 11, 13, 25, 31, 34, 44, 52, 56, 57, 66, 70: return EnablePlayerGPS(playerid, gps_autosalons[0][G_MARKET_TYPE], gps_autosalons[0][G_POS_X], gps_autosalons[0][G_POS_Y], gps_autosalons[0][G_POS_Z], "");
        case 14: return EnablePlayerGPS(playerid, gps_state_organizations[3][G_MARKET_TYPE], gps_state_organizations[3][G_POS_X], gps_state_organizations[3][G_POS_Y], gps_state_organizations[3][G_POS_Z], "");
        case 15: return 1; // Таймер
        case 16, 45, 65: return EnablePlayerGPS(playerid, gps_jobs[2][G_MARKET_TYPE], gps_jobs[2][G_POS_X], gps_jobs[2][G_POS_Y], gps_jobs[2][G_POS_Z], "");
        case 17, 82: return EnablePlayerGPS(playerid, gps_jobs[3][G_MARKET_TYPE], gps_jobs[3][G_POS_X], gps_jobs[3][G_POS_Y], gps_jobs[3][G_POS_Z], "");
        case 18, 19, 20, 83: return EnablePlayerGPS(playerid, gps_jobs[4][G_MARKET_TYPE], gps_jobs[4][G_POS_X], gps_jobs[4][G_POS_Y], gps_jobs[4][G_POS_Z], "");
        case 21: return EnablePlayerGPS(playerid, gps_jobs[5][G_MARKET_TYPE], gps_jobs[5][G_POS_X], gps_jobs[5][G_POS_Y], gps_jobs[5][G_POS_Z], "");
        case 22, 68: return EnablePlayerGPS(playerid, gps_state_organizations[0][G_MARKET_TYPE], gps_state_organizations[0][G_POS_X], gps_state_organizations[0][G_POS_Y], gps_state_organizations[0][G_POS_Z], "");
        case 26: return EnablePlayerGPS(playerid, gps_state_organizations[5][G_MARKET_TYPE], gps_state_organizations[5][G_POS_X], gps_state_organizations[5][G_POS_Y], gps_state_organizations[5][G_POS_Z], "");
        case 29, 33: return EnablePlayerGPS(playerid, gps_autosalons[1][G_MARKET_TYPE], gps_autosalons[1][G_POS_X], gps_autosalons[1][G_POS_Y], gps_autosalons[1][G_POS_Z], "");
        case 30: return EnablePlayerGPS(playerid, gps_state_organizations[4][G_MARKET_TYPE], gps_state_organizations[4][G_POS_X], gps_state_organizations[4][G_POS_Y], gps_state_organizations[4][G_POS_Z], "");
        case 32: return EnablePlayerGPS(playerid, gps_autosalons[2][G_MARKET_TYPE], gps_autosalons[2][G_POS_X], gps_autosalons[2][G_POS_Y], gps_autosalons[2][G_POS_Z], "");
        case 36: return EnablePlayerGPS(playerid, gps_jobs[6][G_MARKET_TYPE], gps_jobs[6][G_POS_X], gps_jobs[6][G_POS_Y], gps_jobs[6][G_POS_Z], "");
        case 38: return EnablePlayerGPS(playerid, gps_state_organizations[2][G_MARKET_TYPE], gps_state_organizations[2][G_POS_X], gps_state_organizations[2][G_POS_Y], gps_state_organizations[2][G_POS_Z], "");
        case 39: return EnablePlayerGPS(playerid, gps_jobs[7][G_MARKET_TYPE], gps_jobs[7][G_POS_X], gps_jobs[7][G_POS_Y], gps_jobs[7][G_POS_Z], "");
        case 40: return EnablePlayerGPS(playerid, gps_jobs[8][G_MARKET_TYPE], gps_jobs[8][G_POS_X], gps_jobs[8][G_POS_Y], gps_jobs[8][G_POS_Z], "");
        case 42, 43: return EnablePlayerGPS(playerid, gps_entertainment[1][G_MARKET_TYPE], gps_entertainment[1][G_POS_X], gps_entertainment[1][G_POS_Y], gps_entertainment[1][G_POS_Z], "");
        case 46, 47, 48, 49, 50, 69: return EnablePlayerGPS(playerid, gps_jobs[0][G_MARKET_TYPE], gps_jobs[0][G_POS_X], gps_jobs[0][G_POS_Y], gps_jobs[0][G_POS_Z], "");
        case 51: return EnablePlayerGPS(playerid, gps_jobs[9][G_MARKET_TYPE], gps_jobs[9][G_POS_X], gps_jobs[9][G_POS_Y], gps_jobs[9][G_POS_Z], "");
        case 61: return EnablePlayerGPS(playerid, gps_banks[2][G_MARKET_TYPE], gps_banks[2][G_POS_X], gps_banks[2][G_POS_Y], gps_banks[2][G_POS_Z], "");
        case 62: return EnablePlayerGPS(playerid, gps_cities[0][G_MARKET_TYPE], gps_cities[0][G_POS_X], gps_cities[0][G_POS_Y], gps_cities[0][G_POS_Z], "");
        case 63: return EnablePlayerGPS(playerid, gps_cities[1][G_MARKET_TYPE], gps_cities[1][G_POS_X], gps_cities[1][G_POS_Y], gps_cities[1][G_POS_Z], "");
        case 64: return EnablePlayerGPS(playerid, gps_cities[2][G_MARKET_TYPE], gps_cities[2][G_POS_X], gps_cities[2][G_POS_Y], gps_cities[2][G_POS_Z], "");
        case 67, 73, 74, 75, 76, 77, 78, 79, 80: return EnablePlayerGPS(playerid, gps_jobs[10][G_MARKET_TYPE], gps_jobs[10][G_POS_X], gps_jobs[10][G_POS_Y], gps_jobs[10][G_POS_Z], "");
        case 81: return EnablePlayerGPS(playerid, gps_jobs[4][G_MARKET_TYPE], gps_jobs[4][G_POS_X], gps_jobs[4][G_POS_Y], gps_jobs[4][G_POS_Z], "");
        case 84: return EnablePlayerGPS(playerid, gps_state_organizations[6][G_MARKET_TYPE], gps_state_organizations[6][G_POS_X], gps_state_organizations[6][G_POS_Y], gps_state_organizations[6][G_POS_Z], "");
    }
    return 0;
}

stock BlackPass_SaveTaskSlot(playerid, task_index)
{
    if(!(0 <= task_index < BLACKPASS_TASK_SLOT_COUNT)) return 0;

    new query[512];
    new stored_status = BlackPass_GetStoredTaskStatus(playerid, task_index);
    g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = stored_status;

    mysql_format(mysql, query, sizeof(query),
        "UPDATE blackpass_tasks SET progress=%d,status=%d,tracked=%d,complete_notified=%d,updated_at=UNIX_TIMESTAMP() WHERE id=%d LIMIT 1",
        g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS],
        stored_status,
        g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED],
        g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED],
        g_blackpass_tasks[playerid][task_index][BP_TASK_ROW_ID]
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock BlackPass_InsertTaskSlot(playerid, task_index)
{
    if(!(0 <= task_index < BLACKPASS_TASK_SLOT_COUNT)) return 0;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return 0;

    new query[768];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO blackpass_tasks (account_id,season_number,task_id,task_group,period_key,target_count,reward_exp,reward_money,route_id,button_type,premium_only,progress,status,tracked,complete_notified,created_at,updated_at) VALUES (%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,0,0,0,0,UNIX_TIMESTAMP(),UNIX_TIMESTAMP())",
        GetPlayerAccountID(playerid),
        BLACKPASS_SEASON_NUMBER,
        g_blackpass_task_defs[def_index][BP_TASK_DEF_ID],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP],
        g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_EXP_REWARD],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_MONEY_REWARD],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_ROUTE_ID],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_BUTTON_TYPE],
        g_blackpass_task_defs[def_index][BP_TASK_DEF_PREMIUM_ONLY]
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock BlackPass_LoadTasks(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;

    new daily_period = BlackPass_GetCurrentTaskPeriod(BLACKPASS_TASK_GROUP_DAILY);
    new weekly_period = BlackPass_GetCurrentTaskPeriod(BLACKPASS_TASK_GROUP_WEEKLY);

    if(g_blackpass_tasks_loaded[playerid]
    && g_blackpass_daily_period[playerid] == daily_period
    && g_blackpass_weekly_period[playerid] == weekly_period)
    {
        return 1;
    }

    g_blackpass_tracked_task[playerid] = 0;

    for(new task_idx = 0; task_idx < BLACKPASS_DAILY_TASK_COUNT; task_idx++) BlackPass_ClearTaskSlot(playerid, task_idx, BLACKPASS_TASK_GROUP_DAILY);
    for(new task_idx = BLACKPASS_DAILY_TASK_COUNT; task_idx < BLACKPASS_TASK_SLOT_COUNT; task_idx++) BlackPass_ClearTaskSlot(playerid, task_idx, BLACKPASS_TASK_GROUP_WEEKLY);

    for(new pass = 0; pass < 2; pass++)
    {
        new bool:loaded_defs[BLACKPASS_TASK_DEF_COUNT];
        new daily_loaded, weekly_loaded;
        new query[256];
        mysql_format(mysql, query, sizeof(query),
            "SELECT id,task_id,task_group,period_key,progress,status,tracked,complete_notified FROM blackpass_tasks WHERE account_id=%d AND season_number=%d AND ((task_group=%d AND period_key=%d) OR (task_group=%d AND period_key=%d)) ORDER BY task_group ASC,id ASC",
            GetPlayerAccountID(playerid),
            BLACKPASS_SEASON_NUMBER,
            BLACKPASS_TASK_GROUP_DAILY,
            daily_period,
            BLACKPASS_TASK_GROUP_WEEKLY,
            weekly_period
        );

        new Cache:result = mysql_query(mysql, query, true);
        if(mysql_errno())
        {
            printf("[BLACKPASS][TASKS][ERROR] Load failed: player=%d errno=%d query=%s", playerid, mysql_errno(), query);
            cache_delete(result);
            return 0;
        }

        for(new row = 0; row < cache_num_rows(); row++)
        {
            new task_id = cache_get_field_content_int(row, "task_id");
            new task_group = cache_get_field_content_int(row, "task_group");
            new def_index = BlackPass_FindTaskDefIndex(task_id);
            new task_status = cache_get_field_content_int(row, "status");
            if(def_index == -1) continue;
            if(g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP] != task_group) continue;
            if(loaded_defs[def_index]) continue;

            /*if(task_status == BLACKPASS_TASK_STATUS_CLAIMED)
            {
                loaded_defs[def_index] = true;
                continue;
            }*/

            new task_index = BlackPass_GetNextFreeTaskSlot(playerid, task_group);
            if(task_index == -1) continue;

            BlackPass_AssignTaskSlot(playerid, task_index, task_id, cache_get_field_content_int(row, "id"));
            g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY] = cache_get_field_content_int(row, "period_key");
            g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] = cache_get_field_content_int(row, "progress");
            g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = cache_get_field_content_int(row, "status");
            g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = bool:cache_get_field_content_int(row, "tracked");
            g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = bool:cache_get_field_content_int(row, "complete_notified");
            loaded_defs[def_index] = true;

            if(task_group == BLACKPASS_TASK_GROUP_DAILY) daily_loaded++;
            else weekly_loaded++;

            if(g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED])
            {
                g_blackpass_tracked_task[playerid] = task_id;
            }
        }
        cache_delete(result);

        if(pass == 1) break;

        new missing_tasks;
        for(new task_idx = 0; task_idx < BLACKPASS_TASK_SLOT_COUNT; task_idx++)
        {
            new default_task_id = g_blackpass_default_task_ids[task_idx];
            new def_index = BlackPass_FindTaskDefIndex(default_task_id);
            if(def_index == -1 || loaded_defs[def_index]) continue;

            new task_group = g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP];
            if(task_group == BLACKPASS_TASK_GROUP_DAILY && daily_loaded >= BLACKPASS_DAILY_TASK_COUNT) continue;
            if(task_group == BLACKPASS_TASK_GROUP_WEEKLY && weekly_loaded >= BLACKPASS_WEEKLY_TASK_COUNT) continue;

            BlackPass_AssignTaskSlot(playerid, task_idx, default_task_id);
            BlackPass_InsertTaskSlot(playerid, task_idx);
            loaded_defs[def_index] = true;
            if(task_group == BLACKPASS_TASK_GROUP_DAILY) daily_loaded++;
            else weekly_loaded++;
            missing_tasks++;
        }

        if(missing_tasks == 0) break;
    }

    g_blackpass_daily_period[playerid] = daily_period;
    g_blackpass_weekly_period[playerid] = weekly_period;
    g_blackpass_tasks_loaded[playerid] = true;

    printf("[DEBUG] Loading tasks for player %d", playerid);
    printf("[DEBUG] Daily period: %d, Weekly period: %d", daily_period, weekly_period);
    return 1;
}

stock BlackPass_ShowTaskReadyGui(playerid, task_id)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "t", 2);
    JSON_SetInt(json, "tm", 6);
    JSON_SetString(json, "h", "Заберите награду BLACK PASS");
    JSON_SetString(json, "s", "Условия задания <font color='#ffd801'></font> выполнены. Нажмите, чтобы  получить награду.");
    JSON_SetString(json, "b", "Получить");
    ShowPlayerGUI(playerid, BLACKPASS_TASK_GUI_READY, json);
    JSON_Cleanup(json);

    g_blackpass_task_popup[playerid] = task_id;
    return 1;
}

stock BlackPass_ShowTrackedTaskGui(playerid, task_id)
{
    new task_text[96];
    BlackPass_GetTaskDescription(task_id, task_text, sizeof(task_text));

    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "m", 5);
    JSON_SetInt(json, "t", 4);
    JSON_SetString(json, "mq", task_text);
    JSON_SetInt(json, "mt", 0);
    JSON_SetInt(json, "ma", 1);
    JSON_SetString(json, "mc", "#0BDA51");
    JSON_SetArray(json, "aq", JSON_Array());
    JSON_SetArray(json, "at", JSON_Array());
    JSON_SetArray(json, "aa", JSON_Array());
    JSON_SetArray(json, "ac", JSON_Array());
    JSON_SetInt(json, "f", 0);
    ShowPlayerGUI(playerid, 39, json);
    JSON_Cleanup(json);
    return 1;
}

stock BlackPass_OpenTasksScreen(playerid)
{
    if(!BlackPass_LoadPlayer(playerid)) return 0;
    if(!BlackPass_LoadTasks(playerid)) return 0;

    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;

    new Node:gui_json = JSON_Object();
    JSON_SetInt(gui_json, "o", 1);
    JSON_SetInt(gui_json, "t", 0);
    JSON_SetInt(gui_json, "lc", 3);
    JSON_SetInt(gui_json, "k", 0);
    JSON_SetInt(gui_json, "sv", 1);
    JSON_SetInt(gui_json, "ds", 0);
    JSON_SetInt(gui_json, "r", GetPlayerMoney(playerid));
    JSON_SetInt(gui_json, "d", GetPlayerDonateRub(playerid));
    JSON_SetInt(gui_json, "p", GetPlayerData(playerid, P_SALE_TIME));
    JSON_SetArray(gui_json, "s", g_player_donate_data[playerid][JSON_PROMOTIONS_ARRAY]);
    if(strcmp("None", GetPlayerData(playerid, P_EMAIL)))
    {
        JSON_SetString(gui_json, "em", GetPlayerData(playerid, P_EMAIL));
    }
    else
    {
        JSON_SetString(gui_json, "em", "0");
    }
    JSON_SetString(gui_json, "nm", GetPlayerNameEx(playerid));
    SendPacketToClient(playerid, 22, gui_json);
    JSON_Cleanup(gui_json);

    new Node:init_json = JSON_Object();
    BlackPass_SendMainPacket(playerid, init_json, 0);
    JSON_Cleanup(init_json);

    new Node:tasks_json = JSON_Object();
    new result = BlackPass_SendMainPacket(playerid, tasks_json, 1);
    JSON_Cleanup(tasks_json);
    return result;
}

stock BlackPass_AddTaskProgress(playerid, task_id, amount)
{
    if(amount <= 0) return 0;
    if(!BlackPass_LoadPlayer(playerid)) return 0;
    if(!BlackPass_LoadTasks(playerid)) return 0;

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1) return 0;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return 0;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] == BLACKPASS_TASK_STATUS_CLAIMED) return 0;

    new target = g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET];
    new old_progress = g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS];

    g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] += amount;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] > target)
    {
        g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] = target;
    }

    if(old_progress < target
    && g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] >= target
    && !g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED])
    {
        g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = true;
        BlackPass_ShowTaskReadyGui(playerid, task_id);
    }

    BlackPass_SaveTaskSlot(playerid, task_index);

    if(g_blackpass_player[playerid][BP_SELECTED_LAYOUT] == 1)
    {
        BlackPass_SendLayoutPacket(playerid, 1);
    }
    return 1;
}

stock BlackPass_ClaimTaskReward(playerid, task_id)
{
    if(!BlackPass_LoadPlayer(playerid)) return 0;
    if(!BlackPass_LoadTasks(playerid)) return 0;

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1) return 0;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return 0;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] == BLACKPASS_TASK_STATUS_CLAIMED) return 0;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] < g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET]) return 0;

    new old_level = BlackPass_GetCurrentLevel(playerid);
    new exp_reward = g_blackpass_task_defs[def_index][BP_TASK_DEF_EXP_REWARD];
    new money_reward = g_blackpass_task_defs[def_index][BP_TASK_DEF_MONEY_REWARD];
    new group = g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP];
    new notify_str[96];

    // Меняем статус на CLAIMED, НО НЕ ОЧИЩАЕМ слот!
    g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = BLACKPASS_TASK_STATUS_CLAIMED;
    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = false;
    g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = true;
    
    if(g_blackpass_tracked_task[playerid] == task_id) g_blackpass_tracked_task[playerid] = 0;
    if(g_blackpass_task_popup[playerid] == task_id) g_blackpass_task_popup[playerid] = 0;
    
    HidePlayerGUI(playerid, 39);
    DisablePlayerGPS(playerid);
    HidePlayerGUI(playerid, BLACKPASS_TASK_GUI_READY);

    // СОХРАНЯЕМ, НО НЕ ОЧИЩАЕМ
    BlackPass_SaveTaskSlot(playerid, task_index);
    // BlackPass_ClearTaskSlot(playerid, task_index, group); // <-- УБИРАЕМ ЭТУ СТРОКУ!
    
    BlackPass_GrantExperience(playerid, exp_reward);
    if(money_reward > 0)
    {
        GivePlayerMoneyEx(playerid, money_reward, "BlackPass task reward", true, true);
    }
    BlackPass_LogEvent(playerid, "task_claim", task_id, 10, exp_reward, 1, group);

    format(notify_str, sizeof(notify_str), "Вы получили %d опыта и %d рублей", exp_reward, money_reward);
    ShowNotificationSile(playerid, 3, 4, 0, 0, notify_str, "qq");

    if(BlackPass_GetCurrentLevel(playerid) > old_level)
    {
        ShowNotificationSile(playerid, 3, 3, 0, 0, "Вы успешно получили новый уровень Black Pass.", "qq");
        BlackPass_SendLevelSyncRange(playerid, old_level, BlackPass_GetCurrentLevel(playerid));
    }

    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
    
    // Открываем экран заданий, но задания уже не обновятся, так как они помечены как CLAIMED
    return BlackPass_OpenTasksScreen(playerid);
}

stock BlackPass_BeginTrackTask(playerid, task_id)
{
    if(!BlackPass_LoadTasks(playerid)) return 0;

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1) return 0;
    if(!BlackPass_TaskHasAction(playerid, task_index)) return 0;

    for(new idx = 0; idx < BLACKPASS_TASK_SLOT_COUNT; idx++)
    {
        if(g_blackpass_tasks[playerid][idx][BP_TASK_TRACKED] && idx != task_index)
        {
            g_blackpass_tasks[playerid][idx][BP_TASK_TRACKED] = false;
            BlackPass_SaveTaskSlot(playerid, idx);
        }
    }

    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = true;
    g_blackpass_tracked_task[playerid] = task_id;
    BlackPass_SaveTaskSlot(playerid, task_index);

    BlackPass_EnableTaskGps(playerid, task_id);
    HidePlayerGUI(playerid, 22);
    ShowNotificationSile(playerid, 3, 3, 0, 0, "Место отмечено у Вас на GPS", "qq");
    BlackPass_ShowTrackedTaskGui(playerid, task_id);
    return 1;
}

stock BlackPass_StopTrackTask(playerid, task_id)
{
    if(!BlackPass_LoadTasks(playerid)) return 0;

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1) return 0;
    if(!g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED]) return 0;

    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = false;
    if(g_blackpass_tracked_task[playerid] == task_id) g_blackpass_tracked_task[playerid] = 0;
    BlackPass_SaveTaskSlot(playerid, task_index);
    DisablePlayerGPS(playerid);
    HidePlayerGUI(playerid, 39);

    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
    return BlackPass_OpenTasksScreen(playerid);
}

stock BlackPass_FindExchangeReplacement(playerid, task_index)
{
    new current_task_id = g_blackpass_tasks[playerid][task_index][BP_TASK_ID];
    new current_def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(current_def_index == -1) return -1;

    for(new def_index = 0; def_index < BLACKPASS_TASK_DEF_COUNT; def_index++)
    {
        if(def_index == current_def_index) continue;
        if(g_blackpass_task_defs[def_index][BP_TASK_DEF_GROUP] != g_blackpass_task_defs[current_def_index][BP_TASK_DEF_GROUP]) continue;
        if(BlackPass_IsTaskActive(playerid, g_blackpass_task_defs[def_index][BP_TASK_DEF_ID])) continue;
        if(g_blackpass_task_defs[def_index][BP_TASK_DEF_ID] == current_task_id) continue;
        return def_index;
    }
    return -1;
}

stock BlackPass_HandleTaskPress(playerid, Node:json)
{
    if(!BlackPass_LoadPlayer(playerid)) return 0;
    if(!BlackPass_LoadTasks(playerid)) return 0;

    new task_id;
    JSON_GetInt(json, "id", task_id);

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1)
    {
        g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
        return BlackPass_SendMainPacket(playerid, json, 1);
    }

    switch(BlackPass_GetClientTaskStatus(playerid, task_index))
    {
        case BLACKPASS_TASK_STATUS_REWARD: return BlackPass_ClaimTaskReward(playerid, task_id);
        case BLACKPASS_TASK_STATUS_TRACKED: return BlackPass_StopTrackTask(playerid, task_id);
        case BLACKPASS_TASK_STATUS_GO_TO: return BlackPass_BeginTrackTask(playerid, task_id);
    }

    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
    return BlackPass_SendMainPacket(playerid, json, 1);
}

stock BlackPass_HandleTaskExchange(playerid, Node:json)
{
    new task_id;
    JSON_GetInt(json, "id", task_id);

    if(!BlackPass_LoadPlayer(playerid)) return 1;
    if(!BlackPass_LoadTasks(playerid)) return 1;

    new task_index = BlackPass_FindTaskSlot(playerid, task_id);
    if(task_index == -1) return 1;
    new def_index = BlackPass_GetTaskDefIndexFromSlot(playerid, task_index);
    if(def_index == -1) return 1;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] == BLACKPASS_TASK_STATUS_CLAIMED) return 1;
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] >= g_blackpass_task_defs[def_index][BP_TASK_DEF_TARGET]) return 1;

    if(GetPlayerDonateRub(playerid) < BLACKPASS_EXCHANGE_COST)
    {
        ShowNotificationSile(playerid, 2, 3, 0, 0, "Недостаточно BC.", "qq");
        return 1;
    }

    new replacement_def_index = BlackPass_FindExchangeReplacement(playerid, task_index);
    if(replacement_def_index == -1)
    {
        ShowNotificationSile(playerid, 2, 3, 0, 0, "Сейчас это задание нельзя заменить.", "qq");
        return 1;
    }

    new row_id = g_blackpass_tasks[playerid][task_index][BP_TASK_ROW_ID];
    if(g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED])
    {
        DisablePlayerGPS(playerid);
        HidePlayerGUI(playerid, 39);
    }

    GivePlayerDonateRub(playerid, -BLACKPASS_EXCHANGE_COST, "Смена задания BlackPass", true, true);

    g_blackpass_tasks[playerid][task_index][BP_TASK_ID] = g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_ID];
    g_blackpass_tasks[playerid][task_index][BP_TASK_GROUP] = g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_GROUP];
    g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY] = BlackPass_GetCurrentTaskPeriod(g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_GROUP]);
    g_blackpass_tasks[playerid][task_index][BP_TASK_PROGRESS] = 0;
    g_blackpass_tasks[playerid][task_index][BP_TASK_STORED_STATUS] = BLACKPASS_STATUS_NONE;
    g_blackpass_tasks[playerid][task_index][BP_TASK_TRACKED] = false;
    g_blackpass_tasks[playerid][task_index][BP_TASK_COMPLETE_NOTIFIED] = false;
    g_blackpass_tasks[playerid][task_index][BP_TASK_ROW_ID] = row_id;
    if(g_blackpass_tracked_task[playerid] == task_id) g_blackpass_tracked_task[playerid] = 0;

    new query[768];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE blackpass_tasks SET task_id=%d,task_group=%d,period_key=%d,target_count=%d,reward_exp=%d,reward_money=%d,route_id=%d,button_type=%d,premium_only=%d,progress=0,status=0,tracked=0,complete_notified=0,updated_at=UNIX_TIMESTAMP() WHERE id=%d LIMIT 1",
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_ID],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_GROUP],
        g_blackpass_tasks[playerid][task_index][BP_TASK_PERIOD_KEY],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_TARGET],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_EXP_REWARD],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_MONEY_REWARD],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_ROUTE_ID],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_BUTTON_TYPE],
        g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_PREMIUM_ONLY],
        row_id
    );
    mysql_query(mysql, query, false);

    BlackPass_LogEvent(playerid, "task_exchange", task_id, 0, BLACKPASS_EXCHANGE_COST, 1, g_blackpass_task_defs[replacement_def_index][BP_TASK_DEF_ID]);
    ShowNotificationSile(playerid, 3, 3, 0, 0, "Вы потратили 10 ВС и {FFFF00}успешно\nсменили задание{FFFF00}{FFFFFF}!", "qq");

    return BlackPass_OpenTasksScreen(playerid);
}

stock BlackPass_HandleExtraGui(playerid, guiid, Node:json)
{
    new type, close_state;
    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "c", close_state);

    switch(guiid)
    {
        case BLACKPASS_TASK_GUI_READY:
        {
            if(close_state == 1 || type == 1)
            {
                g_blackpass_task_popup[playerid] = 0;
                HidePlayerGUI(playerid, BLACKPASS_TASK_GUI_READY);
                return 1;
            }

            if(type == 2)
            {
                g_blackpass_task_popup[playerid] = 0;
                g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
                HidePlayerGUI(playerid, BLACKPASS_TASK_GUI_READY);
                return BlackPass_OpenTasksScreen(playerid);
            }
        }

        case 39:
        {
            if(close_state == 1)
            {
                HidePlayerGUI(playerid, 39);
                return 1;
            }

            if(type == 4)
            {
                HidePlayerGUI(playerid, 39);
                return BlackPass_OpenTasksScreen(playerid);
            }
        }
    }

    return 0;
}

// ===== ЕЖЕНЕДЕЛЬНЫЕ =====

// Задание 99: Пожертвуйте 15000 рублей или более в Банке
stock BlackPass_OnBankDonate(playerid, amount)
{
    if(amount == 15000)
        return BlackPass_AddTaskProgress(playerid, 99, amount);
    return 0;
}

// Задание 143: Поздоровайтесь с 2 игроками
stock BlackPass_OnPlayerGreeting(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 143, 1);
}

// Задание 148: Подарите букет цветов персонажу противоположного пола
stock BlackPass_OnFlowerGift(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 148, 1);
}

// Задание 255: Откройте 5 любых кейсов
stock BlackPass_OnCaseOpen(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 255, 1);
}

// Задание 256: Сыграйте 8 любых игр в Казино
stock BlackPass_OnCasinoGame(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 256, 1);
}

// Задание 257: Заработайте 100 000 рублей
stock BlackPass_OnMoneyEarned(playerid, amount, const description[] = "")
{
    if(amount <= 0) return 0;
    if(strfind(description, "BlackPass", true) != -1) return 0;
    return BlackPass_AddTaskProgress(playerid, 257, amount);
}

// Задание 6: Сделайте тюнинг своего автомобиля в СТО
stock BlackPass_OnTuningPurchase(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 6, 1);
}

// ===== ЕЖЕДНЕВНЫЕ =====

// Задание 254: Войдите в игру
stock BlackPass_OnPlayerLogin(playerid)
{
    if(!BlackPass_LoadPlayer(playerid)) return 0;
    if(!BlackPass_LoadTasks(playerid)) return 0;
    return BlackPass_AddTaskProgress(playerid, 254, 1); // заодно и час
}

// Задание 258: Посетите Правительство
stock BlackPass_OnVisitGovernment(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 258, 1);
}

// Задание 1: Посетите Больницу
stock BlackPass_OnVisitHospital(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 1, 1);
}

// Задание 2: Посетите Банк
stock BlackPass_OnVisitBank(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 2, 1);
}

// Задание 3: Посетите Закусочную
stock BlackPass_OnVisitDiner(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 3, 1);
}

// Задание 4: Посетите Казино
stock BlackPass_OnVisitCasino(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 4, 1);
}

// Задание 159: Посетите Магазин 24/7
stock BlackPass_OnVisit247(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 159, 1);
}

// Задание 168: Посетите офис Транспортной компании
stock BlackPass_OnVisitTransportCompany(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 168, 1);
}

// Задание 155: Посетите Арзамас
stock BlackPass_OnVisitArzamas(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 155, 1);
}

// Задание 156: Посетите Рублевку
stock BlackPass_OnVisitRublevka(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 156, 1);
}

// Задание 157: Посетите Лыткарино
stock BlackPass_OnVisitLytkarino(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 157, 1);
}

// Задание 158: Посетите Южный
stock BlackPass_OnVisitYuzhny(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 158, 1);
}

// Задание 100: Посетите Автосалон Низкого класса
stock BlackPass_OnVisitLowAutosalon(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 100, 1);
}

// Задание 101: Посетите Автосалон Среднего класса
stock BlackPass_OnVisitMidAutosalon(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 101, 1);
}

// Задание 102: Посетите Автосалон Высокого класса
stock BlackPass_OnVisitHighAutosalon(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 102, 1);
}

// Задание 103: Посетите Мотосалон
stock BlackPass_OnVisitMotosalon(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 103, 1);
}

// Задание 105: Посетите любой авторынок
stock BlackPass_OnVisitCarmarket(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 105, 1);
}

// Задание 8: Купите букет цветов
stock BlackPass_OnFlowersBuy(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 8, 1);
}

// Задание 9: Купите 1 ремонтный набор
stock BlackPass_OnRepairKitBuy(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 9, 1);
}

// Задание 121: Купите 1 любой товар в Ларьке
stock BlackPass_OnKioskBuy(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 121, 1);
}

// Задание 149: Купите аптечку в Магазине 24/7
stock BlackPass_OnMedkitBuy247(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 149, 1);
}

// Задание 249: Купите 1 любой товар в киоске рядом с Вокзалом
stock BlackPass_OnStationKioskBuy(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 249, 1);
}

// Задание 141: Начните рабочий день в МЧС
stock BlackPass_OnStartEmercom(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 141, 1);
}

// Задание 169: Начните рабочий день Сборщик на заводе
stock BlackPass_OnStartFactoryWorker(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 169, 1);
}

// Задание 171: Начните рабочий день Водитель автобуса
stock BlackPass_OnStartBusDriver(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 171, 1);
}

// Задание 250: Начните рабочий день на Шахте
stock BlackPass_OnStartMiner(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 250, 1);
}

// Задание 251: Начните рабочий день на Ферме
stock BlackPass_OnStartFarm(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 251, 1);
}

// Задание 252: Начните рабочий день Курьер
stock BlackPass_OnStartCourier(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 252, 1);
}

// Задание 7: Проедьте 20 км на транспорте
stock BlackPass_OnDriveDistance(playerid, km)
{
    return BlackPass_AddTaskProgress(playerid, 7, km);
}

// Задание 150: Разгонитесь до 150 км/ч
stock BlackPass_OnSpeedReach150(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 150, 1);
}

// Задание 151: Разгонитесь до 100 км/ч на мотоцикле
stock BlackPass_OnSpeedReach100Moto(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 151, 1);
}

// Задание 5: Заправьте свой транспорт на АЗС
stock BlackPass_OnVehicleRefuel(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 5, 1);
}

// Задание 97: Прокрутите случайные номера авто в ГИБДД
stock BlackPass_OnPlateRegenerate(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 97, 1);
}

// Задание 106: Купите канистру с бензином в любой АЗС
stock BlackPass_OnGasCanBuy(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 106, 1);
}

// Задание 47: Подстрелите 1 животное на работе Охотник
stock BlackPass_OnHuntAnimal(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 47, 1);
}

// Задание 52: Отыграйте 1 час
stock BlackPass_OnPlayedHour(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 52, 1);
}

// Задание 56: Заработайте 3000 рублей Сборщик на ферме
stock BlackPass_OnFarmEarnCollector(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 56, amount);
}

// Задание 57: Заработайте 3000 рублей Дояр на ферме
stock BlackPass_OnFarmEarnMilker(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 57, amount);
}

// Задание 58: Заработайте 3000 рублей Комбайнер на ферме
stock BlackPass_OnFarmEarnCombine(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 58, amount);
}

// Задание 59: Заработайте 10000 рублей Пчеловод на ферме
stock BlackPass_OnFarmEarnBeekeeper(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 59, amount);
}

// Задание 60: Заработайте 3000 рублей Шахтер
stock BlackPass_OnMinerEarn(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 60, amount);
}

// Задание 61: Заработайте 3000 рублей Сборщик на заводе
stock BlackPass_OnFactoryEarn(playerid, amount)
{
        return BlackPass_AddTaskProgress(playerid, 61, amount);
}

// Задание 96: Подайте объявление в СМИ (/ad)
stock BlackPass_OnAdvertSent(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 96, 1);
}

// Задание 104: Возьмите машину на тест-драйв
stock BlackPass_OnTestDrive(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 104, 1);
}

// Задание 108: Арендуйте скутер
stock BlackPass_OnScooterRent(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 108, 1);
}

// Задание 124: Наденьте любой аксессуар
stock BlackPass_OnAccessoryWear(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 124, 1);
}

// Задание 147: Используйте аптечку
stock BlackPass_OnMedkitUse(playerid)
{
    return BlackPass_AddTaskProgress(playerid, 147, 1);
}

stock BlackPass_FillBasePacket(playerid, Node:json)
{
    new current_level = BlackPass_GetCurrentLevel(playerid);

    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "ty", -1);
    JSON_SetInt(json, "la", 0);
    JSON_SetInt(json, "lv", current_level);
    JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
    JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
    JSON_SetInt(json, "es", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "l", g_blackpass_player[playerid][BP_EXPERIENCE]);
    JSON_SetInt(json, "lc", g_blackpass_player[playerid][BP_SELECTED_LAYOUT]);
    JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][current_level] ? 0 : 1);
    JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][current_level] ? 0 : 1);
    return 1;
}

stock BlackPass_SendMainPacket(playerid, Node:json, latype)
{
    printf("[BLACKPASS][SEND] player=%d la=%d", playerid, latype);

    switch(latype)
    {
        case 0:
        {
            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", -1);
            JSON_SetInt(json, "la", 0);
            JSON_SetString(json, "sn", BLACKPASS_SEASON_NAME);
            JSON_SetString(json, "ln", GetPlayerNameEx(playerid));
            JSON_SetInt(json, "lv", g_blackpass_player[playerid][BP_LEVEL]);
            JSON_SetInt(json, "td", BLACKPASS_SEASON_DAYS * 86400);
            JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
            JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
            JSON_SetInt(json, "sp", 0);
            JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);
            JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);

            SendPacketToClient(playerid, 22, json);
            return 1;
        }

        case 1:
        {
            printf("[BLACKPASS][SEND] tasks packet");

            BlackPass_LoadTasks(playerid);

            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", 0);
            JSON_SetInt(json, "la", 1);
            JSON_SetString(json, "sn", BLACKPASS_SEASON_NAME);
            JSON_SetString(json, "ln", GetPlayerNameEx(playerid));
            JSON_SetInt(json, "lv", g_blackpass_player[playerid][BP_LEVEL]);
            JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);

            new Node:tkArray = JSON_Array();
            for(new task_idx = 0; task_idx < BLACKPASS_TASK_SLOT_COUNT; task_idx++)
            {
                if(g_blackpass_tasks[playerid][task_idx][BP_TASK_ID] <= 0) continue;
                new Node:task_object = JSON_Object();
                JSON_SetInt(task_object, "id", g_blackpass_tasks[playerid][task_idx][BP_TASK_ID]);
                JSON_SetInt(task_object, "p", g_blackpass_tasks[playerid][task_idx][BP_TASK_PROGRESS]);
                JSON_SetInt(task_object, "s", BlackPass_GetClientTaskStatus(playerid, task_idx));
                tkArray = JSON_Append(tkArray, JSON_Array(task_object));
            }

            JSON_SetArray(json, "tk", tkArray);
            JSON_SetInt(json, "tm", BlackPass_GetTaskResetTimer());

            SendPacketToClient(playerid, 22, json);
            return 1;
        }

        case 2:
        {
            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", 0);
            JSON_SetInt(json, "la", 2);

            SendPacketToClient(playerid, 22, json);
            return 1;
        }

        case 3:
        {
            printf("[BLACKPASS][SEND] rating packet");

            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", 0);
            JSON_SetInt(json, "la", 3);

            new query[1024];
            mysql_format(mysql, query, sizeof(query),
                "SELECT a.name,IFNULL(SUM(l.reward_value),0) AS quest_exp FROM blackpass_players bp INNER JOIN accounts a ON a.id=bp.account_id LEFT JOIN blackpass_logs l ON l.account_id=bp.account_id AND l.season_number=bp.season_number AND l.action='task_claim' WHERE bp.season_number=%d GROUP BY bp.account_id,a.name ORDER BY quest_exp DESC,a.name ASC LIMIT 50",
                BLACKPASS_SEASON_NUMBER
            );

            new Cache:rating_cache = mysql_query(mysql, query, true);
            new Node:rating_array = JSON_Array();
            for(new row = 0; row < cache_num_rows(); row++)
            {
                new nickname[MAX_PLAYER_NAME + 1];
                new Node:rating_player = JSON_Object();

                cache_get_field_content(row, "name", nickname, sizeof(nickname));
                JSON_SetString(rating_player, "n", nickname);
                JSON_SetInt(rating_player, "och", cache_get_field_content_int(row, "quest_exp"));
                rating_array = JSON_Append(rating_array, JSON_Array(rating_player));
            }
            cache_delete(rating_cache);

            mysql_format(mysql, query, sizeof(query),
                "SELECT COUNT(*) + 1 AS place_value FROM (SELECT bp.account_id,IFNULL(SUM(l.reward_value),0) AS quest_exp FROM blackpass_players bp LEFT JOIN blackpass_logs l ON l.account_id=bp.account_id AND l.season_number=bp.season_number AND l.action='task_claim' WHERE bp.season_number=%d GROUP BY bp.account_id) rating WHERE rating.quest_exp > (SELECT IFNULL(SUM(reward_value),0) FROM blackpass_logs WHERE account_id=%d AND season_number=%d AND action='task_claim')",
                BLACKPASS_SEASON_NUMBER,
                GetPlayerAccountID(playerid),
                BLACKPASS_SEASON_NUMBER
            );

            new Cache:place_cache = mysql_query(mysql, query, true);
            new place_value = 1;
            if(cache_num_rows())
            {
                place_value = cache_get_field_content_int(0, "place_value");
            }
            cache_delete(place_cache);

            JSON_SetArray(json, "j", rating_array);
            JSON_SetInt(json, "m", place_value);

            SendPacketToClient(playerid, 22, json);
            return 1;
        }

        case 4:
        {
            new premium_price = 790;
            new deluxe_price = 1690;

            if(g_blackpass_player[playerid][BP_PREMIUM_STATUS] == BLACKPASS_STATUS_PREMIUM)
            {
                deluxe_price = 900;
            }

            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", 0);
            JSON_SetInt(json, "la", 4);
            JSON_SetInt(json, "p", premium_price);
            JSON_SetInt(json, "pp", deluxe_price);
            JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
            JSON_SetString(json, "leftImage", "img_bp_left_ch.png");
            JSON_SetString(json, "rightImage", "img_bp_right_ch.png");
            JSON_SetString(json, "renderId", "img_28744.png");

            SendPacketToClient(playerid, 22, json);
            return 1;
        }
    }

    return 0;
}

stock BlackPass_HandleBuyLevels(playerid, Node:json)
{
    new levels_to_buy;
    JSON_GetInt(json, "p", levels_to_buy);
    if(levels_to_buy <= 0) levels_to_buy = 1;

    new old_level = BlackPass_GetCurrentLevel(playerid);
    if(old_level >= BLACKPASS_MAX_LEVELS)
    {
        JSON_SetInt(json, "t", -1);
        JSON_SetInt(json, "ty", 1);
        JSON_SetInt(json, "la", 0);
        JSON_SetInt(json, "s", 0);
        SendPacketToClient(playerid, 22, json);
        return 1;
    }

    new target_level = old_level + levels_to_buy;
    if(target_level > BLACKPASS_MAX_LEVELS) target_level = BLACKPASS_MAX_LEVELS;
    levels_to_buy = target_level - old_level;

    new price = levels_to_buy * BLACKPASS_LEVEL_PRICE;
    if(GetPlayerDonateRub(playerid) < price)
    {
        JSON_SetInt(json, "t", -1);
        JSON_SetInt(json, "ty", 1);
        JSON_SetInt(json, "la", 0);
        JSON_SetInt(json, "s", 0);
        SendPacketToClient(playerid, 22, json);
        return 1;
    }

    BlackPass_SetLevelWithReset(playerid, target_level);
    new new_level = BlackPass_GetCurrentLevel(playerid);

    if(new_level > old_level)
    {
        BlackPass_AutoClaimRewardsRange(
            playerid,
            old_level + 1,
            new_level,
            true,
            (g_blackpass_player[playerid][BP_PREMIUM_STATUS] != BLACKPASS_STATUS_NONE)
        );
    }

    GivePlayerDonateRub(playerid, -price, "Покупка уровней BlackPass", true, true);
    BlackPass_SavePlayer(playerid);
    BlackPass_LogEvent(playerid, "buy_levels", 0, 10, 0, levels_to_buy, price);

    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "ty", 1);
    JSON_SetInt(json, "la", 0);
    JSON_SetInt(json, "s", 1);
    SendPacketToClient(playerid, 22, json);
    BlackPass_SendAutoClaimSyncRange(playerid, old_level, new_level, true, (g_blackpass_player[playerid][BP_PREMIUM_STATUS] != BLACKPASS_STATUS_NONE), 0);
    BlackPass_SendMainPacket(playerid, json, 0);
    BlackPass_SendStateRefresh(playerid, 0, -1);
    BlackPass_ShowLootNotification(playerid, "Награды получены в «Добычу»");
    return 1;
}

stock BlackPass_HandlePurchasePremium(playerid, Node:json)
{
    new premium_id;
    JSON_GetInt(json, "id", premium_id);

    new bool:is_deluxe = (premium_id == 0);
    new new_status = is_deluxe ? BLACKPASS_STATUS_DELUXE : BLACKPASS_STATUS_PREMIUM;
    new old_level = BlackPass_GetCurrentLevel(playerid);
    new price = is_deluxe ? BLACKPASS_DEFAULT_DELUXE_PRICE : BLACKPASS_DEFAULT_PREMIUM_PRICE;

    if(new_status == BLACKPASS_STATUS_DELUXE && g_blackpass_player[playerid][BP_PREMIUM_STATUS] == BLACKPASS_STATUS_PREMIUM)
    {
        price = 900;
    }

    if(g_blackpass_player[playerid][BP_PREMIUM_STATUS] >= new_status)
    {
        JSON_SetInt(json, "t", -1);
        JSON_SetInt(json, "ty", 1);
        JSON_SetInt(json, "la", 4);
        JSON_SetInt(json, "s", 1);
        JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
        JSON_SetInt(json, "td", BLACKPASS_SEASON_DAYS * 86400);
        SendPacketToClient(playerid, 22, json);
        return 1;
    }

    if(GetPlayerDonateRub(playerid) < price)
    {
        JSON_SetInt(json, "t", -1);
        JSON_SetInt(json, "ty", 1);
        JSON_SetInt(json, "la", 4);
        JSON_SetInt(json, "s", 0);
        SendPacketToClient(playerid, 22, json);
        return 1;
    }

    GivePlayerDonateRub(playerid, -price, is_deluxe ? "Покупка BlackPass Deluxe" : "Покупка BlackPass Premium", true, true);
    g_blackpass_player[playerid][BP_PREMIUM_STATUS] = new_status;
    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;

    if(is_deluxe)
    {
        BlackPass_AddLevelsWithReset(playerid, 10);
        BlackPass_AutoClaimRewardsRange(playerid, 1, BlackPass_GetCurrentLevel(playerid), true, true);
        if(!g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED])
        {
            g_blackpass_player[playerid][BP_DELUXE_REWARDS_CLAIMED] = true;
            BlackPass_QueueDeluxeRewards(playerid, true);
        }
    }
    else
    {
        BlackPass_AutoClaimRewardsRange(playerid, 1, BlackPass_GetCurrentLevel(playerid), false, true);
    }

    BlackPass_SavePlayer(playerid);
    BlackPass_LogEvent(playerid, "buy_pass", 0, 0, new_status, 1, price);

    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "ty", 1);
    JSON_SetInt(json, "la", 4);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
    JSON_SetInt(json, "td", BLACKPASS_SEASON_DAYS * 86400);
    JSON_SetInt(json, "lv", BlackPass_GetCurrentLevel(playerid));
    JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
    SendPacketToClient(playerid, 22, json);

    if(is_deluxe)
    {
        new new_level = BlackPass_GetCurrentLevel(playerid);
        BlackPass_SendAutoClaimSyncRange(playerid, old_level, new_level, true, (g_blackpass_player[playerid][BP_PREMIUM_STATUS] != BLACKPASS_STATUS_NONE), 0);
        BlackPass_SendMainPacket(playerid, json, 0);
        BlackPass_SendStateRefresh(playerid, 0, -1);
        BlackPass_ShowLootNotification(playerid, "Награды Premium Deluxe получены в «Добычу»");
    }
    else
    {
        BlackPass_SendClaimPacketsRange(playerid, 1, BlackPass_GetCurrentLevel(playerid), false, true, 0);
        BlackPass_SendMainPacket(playerid, json, 0);
        BlackPass_SendStateRefresh(playerid, 0, -1);
        BlackPass_ShowLootNotification(playerid, "Награды Premium получены в «Добычу»");
    }
    return 1;
}

stock BlackPass_HandleGetPrize(playerid, Node:json)
{
    new reward_id, is_premium, layout_id;
    JSON_GetInt(json, "id", reward_id);
    JSON_GetInt(json, "p", is_premium);
    JSON_GetInt(json, "la", layout_id);

    if(reward_id < 1 || reward_id > BLACKPASS_MAX_LEVELS) return 1;
    if(BlackPass_GetCurrentLevel(playerid) < reward_id) return 1;
    if(is_premium && g_blackpass_player[playerid][BP_PREMIUM_STATUS] == BLACKPASS_STATUS_NONE) return 1;

    if(is_premium)
    {
        if(g_blackpass_claimed_premium[playerid][reward_id]) return 1;
        g_blackpass_claimed_premium[playerid][reward_id] = true;
        BlackPass_QueueLevelReward(playerid, reward_id, true);
    }
    else
    {
        if(g_blackpass_claimed_standard[playerid][reward_id]) return 1;
        g_blackpass_claimed_standard[playerid][reward_id] = true;
        BlackPass_QueueLevelReward(playerid, reward_id, false);
    }

    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = layout_id;
    BlackPass_SavePlayer(playerid);
    BlackPass_LogEvent(playerid, "reward_claim", reward_id, 0, 0, 1, is_premium);

    JSON_SetInt(json, "t", -1);
    JSON_SetInt(json, "ty", 2);
    JSON_SetInt(json, "la", layout_id);
    JSON_SetInt(json, "s", 1);
    JSON_SetInt(json, "id", reward_id);
    JSON_SetInt(json, "p", is_premium);
    SendPacketToClient(playerid, 22, json);
    return 1;
}

stock BlackPass_HandleRefreshRating(playerid, Node:json)
{
    new current_time = gettime();
    if(g_blackpass_rating_refresh_until[playerid] > current_time)
    {
        printf("[BLACKPASS][RATING] cooldown player=%d left=%d", playerid, g_blackpass_rating_refresh_until[playerid] - current_time);
        ShowNotificationSile(playerid, 2, 4, 0, 0, "Обновлять рейтинг можно раз в 30 секунд", "qq");
        return 1;
    }

    g_blackpass_rating_refresh_until[playerid] = current_time + 30;
    g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 3;
    return BlackPass_SendMainPacket(playerid, json, 3);
}

stock BlackPass_HandlePacket(playerid, Node:json)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(!BlackPass_LoadPlayer(playerid)) return 0;

    new type;
    JSON_GetInt(json, "t", type);

    new ty;
    JSON_GetInt(json, "ty", ty);

    new latype;
    JSON_GetInt(json, "la", latype);


    if(type == -2)
    {
        type = -1;
        ty = -1;
        latype = 0;

        JSON_SetInt(json, "t", -1);
        JSON_SetInt(json, "ty", -1);
        JSON_SetInt(json, "la", 0);
    }

    switch(type)
    {
        case -1:
        {

            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", ty);
            JSON_SetInt(json, "la", latype);
            JSON_SetInt(json, "lv", g_blackpass_player[playerid][BP_LEVEL]);
            JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
            JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
            JSON_SetInt(json, "es", g_blackpass_player[playerid][BP_EXPERIENCE]);
            JSON_SetInt(json, "l", g_blackpass_player[playerid][BP_EXPERIENCE]);
            JSON_SetInt(json, "lc", g_blackpass_player[playerid][BP_SELECTED_LAYOUT]);
            JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);
            JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);

            switch(ty)
            {
                case -1:
                {

                    switch(latype)
                    {
                        case 0:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;

                            JSON_SetInt(json, "t", -1);
                            JSON_SetInt(json, "ty", -1);
                            JSON_SetInt(json, "la", 0);
                            JSON_SetString(json, "sn", BLACKPASS_SEASON_NAME);
                            JSON_SetString(json, "ln", GetPlayerNameEx(playerid));
                            JSON_SetInt(json, "lv", g_blackpass_player[playerid][BP_LEVEL]);
                            JSON_SetInt(json, "td", BLACKPASS_SEASON_DAYS * 86400);
                            JSON_SetInt(json, "ec", g_blackpass_player[playerid][BP_EXPERIENCE] % BLACKPASS_LEVEL_EXP);
                            JSON_SetInt(json, "a", BlackPass_GetClientPremiumStatus(g_blackpass_player[playerid][BP_PREMIUM_STATUS]));
                            JSON_SetInt(json, "sp", 0);
                            JSON_SetInt(json, "is", g_blackpass_claimed_standard[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);
                            JSON_SetInt(json, "ps", g_blackpass_claimed_premium[playerid][BlackPass_GetCurrentLevel(playerid)] ? 0 : 1);

                            SendPacketToClient(playerid, 22, json);
                            return 1;
                        }
                    }

                    return 0;
                }

                case 0:
                {
                    switch(latype)
                    {
                        case -1:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;
                            return BlackPass_SendMainPacket(playerid, json, 0);
                        }

                        case 0:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 0;
                            return BlackPass_SendMainPacket(playerid, json, 0);
                        }

                        case 1:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 1;
                            new task_id;
                            JSON_GetInt(json, "id", task_id);
                            if(task_id > 0)
                            {
                                return BlackPass_HandleTaskPress(playerid, json);
                            }
                            return BlackPass_SendMainPacket(playerid, json, 1);
                        }

                        case 2:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 2;
                            return BlackPass_SendMainPacket(playerid, json, 2);
                        }

                        case 3:
                        {
                            return BlackPass_HandleRefreshRating(playerid, json);
                        }

                        case 4:
                        {
                            g_blackpass_player[playerid][BP_SELECTED_LAYOUT] = 4;
                            return BlackPass_SendMainPacket(playerid, json, 4);
                        }
                    }

                    return 0;
                }

                case 1:
                {
                    JSON_SetInt(json, "t", -1);
                    JSON_SetInt(json, "ty", 1);

                    switch(latype)
                    {
                        case 0: return BlackPass_HandleBuyLevels(playerid, json);
                        case 1: return BlackPass_HandleTaskExchange(playerid, json);
                        case 3: return BlackPass_HandleRefreshRating(playerid, json);
                        case 4: return BlackPass_HandlePurchasePremium(playerid, json);
                    }

                    return 1;
                }

                case 2:
                {

                    switch(latype)
                    {
                        case 0: return BlackPass_HandleGetPrize(playerid, json);
                    }

                    return 1;
                }
            }

            return 0;
        }
    }

    return 0;
}


CMD:blackpass(playerid)
{
    new Node:bp_json = JSON_Object();
    JSON_SetInt(bp_json, "t", -2);
    new result = BlackPass_HandlePacket(playerid, bp_json);
    JSON_Cleanup(bp_json);
    return result;
}








