#define TEAM_FSIN 11

/*
#define MAX_ORG 11

заменить на

#define MAX_ORG 12

ваш g_armory заменить на этот
new g_armory[6][E_ARMORY_STRUCT] =
{
	{"Воинская часть", ARMORY_TYPE_ARMOR, 1227.9379, -382.9861, 4.0076},
	{"Охрана правительства", ARMORY_TYPE_SECURITY, 1564.6099, -764.9561, 1114.7100},
	{"ГИБДД", ARMORY_TYPE_POLICE, 875.7951, 2096.1982, 2721.8101},
	{"УМВД", ARMORY_TYPE_POLICE, 1926.6577, 2196.3027, 2069.4800},
	{"ФСБ", ARMORY_TYPE_POLICE, 204.1425, -447.3391, 1006.4179},
    {"ФСИН", ARMORY_TYPE_POLICE, -1877.71, -2735.64, 7.58}
};

свой rank_wages заменить на это
new const
	rank_wages[8][10] =
{
	{1940, 2300, 2700, 3000, 3500, 3900, 4300, 4700, 4900, 5500}, // Правительство области
	{890,  1190, 1450, 1650, 2150, 2450, 2800, 3300, 3800, 4250}, // Воинская часть
	{1000, 1400, 1700, 2010, 2400, 2750, 2900, 3260, 3770, 4300}, // Городская больница
	{990,  1300, 1700, 2200, 2500, 2650, 2800, 3440, 3820, 4300}, // СМИ
	{915,  1300, 1800, 2200, 2500, 2700, 3200, 3600, 3900, 4350}, // Отдел полиции №1 (ГИБДД)
	{915,  1300, 1800, 2200, 2500, 2700, 3200, 3600, 3900, 4350}, // Отдел полиции №2 (УМВД)
	{1330, 1450, 1900, 2400, 2750, 3250, 3500, 3930, 4200, 4500},  // ФСБ
	{1950, 2540, 4500, 5700, 6325, 7950, 8700, 10550, 12000, 16000}  // ФСИН
};
 
свой rank_names заменить на это
new const
	rank_names[11][10][50] =
{
	// Правительство области
	{"Водитель", "Охранник", "Начальник Охраны", "Секретарь", "Советник", "Лицензер", "Адвокат", "Депутат", "Вице-губернатор", "Губернатор"},

	// Воинская часть
	{"Рядовой", "Ефрейтор", "Сержант", "Старшина", "Прапорщик", "Лейтенант", "Капитан", "Майор", "Подполковник", "Полковник"},

	// Городская больница
	{"Интерн", "Парамедик", "Фельдшер", "Нарколог", "Педиатр", "Терапевт", "Травматолог", "Хирург", "Заведующий", "Глав. врач"},

	// СМИ
	{"Практикант", "Фотограф", "Журналист", "Корреспондент", "Ведущий", "Редактор", "Маркетолог", "Менеджер", "Продюсер", "Директор"},

	// Отдел полиции №1 (ГИБДД)
	{"Рядовой полиции", "Сержант полиции", "Ст. сержант полиции", "Прапорщик полиции", "Лейтенант полиции", "Ст. лейтенант полиции", "Капитан полиции", "Майор полиции", "Подполковник полиции", "Полковник полиции"},

	// Отдел полиции №2 (УМВД)
	{"Рядовой полиции", "Сержант полиции", "Ст. сержант полиции", "Прапорщик полиции", "Лейтенант полиции", "Ст. лейтенант полиции", "Капитан полиции", "Майор полиции", "Подполковник полиции", "Полковник полиции"},

	// ФСБ
	{"Сотрудник ФСКН", "Сотрудник УБОП", "Зам. начальника ФСКН", "Зам. начальника УБОП", "Оперативник ЦСН", "Зам. начальника ЦСН", "Начальник ЦСН", "Инспектор ФСБ", "Зам. начальника УФСБ", "Начальник УФСБ"},

    // Арзамасская ОПГ
	{"Пацан", "Шнырь", "Фраер", "Барыга", "Блатной", "Свояк", "Браток", "Смотрящий", "Авторитет", "Вор в законе"},

	// Батыревская ОПГ
	{"Пацан", "Шнырь", "Фраер", "Барыга", "Блатной", "Свояк", "Браток", "Смотрящий", "Авторитет", "Вор в законе"},

	// Лыткаринская ОПГ
	{"Пацан", "Шнырь", "Фраер", "Барыга", "Блатной", "Свояк", "Браток", "Смотрящий", "Авторитет", "Вор в законе"},

    // ФСИН
	{"Рядовой", "Ефрейтор", "Сержант", "Старшина", "Прапорщик", "Лейтенант", "Капитан", "Майор", "Подполковник", "Полковник"}
};

в конец org_car_pos_spawn добавить

    {   // фсин
        {-1858.62,-2767.10,6.83,175.05},
        {-1853.41,-2771.51,6.82,175.05},
        {-1848.80,-2775.43,6.82,175.05},
        {-1843.09,-2777.72,6.82,175.05}
    }

в конец g_org_car добавить
    {
            "ФСИН",
        // PICKUP POS
        {-1857.56,-2776.02,7.58},
        // COUNT
        0,
        // MODEL
        {540,410,490,487},
        // COLOR ONE/TWO
        {1,1},
        // FRAC ID
        8,
        // PICKUP ID
        -1,
    }

new
	g_organization[MAX_ORG][E_ORG_DATA] =
{
	{"Нет",										{0, 0, 0, 0, 0, 0, 0, 0, 0, 0},		0,		{0.0,0.0,0.0,0.0},							{0.0, 0.0, 0.0}, 					0, 0, 0xFFFFFF11, 0, ""},
	{"Правительство области",					{17,187,227,147,147,147,147,147,147,147}, 141, 	{955.4947,10.5669,1381.0035,274.0993}, 		{0.0, 0.0, 0.0}, 					1, 1, 0xCCFF00FF, 450, ""},
	{"Воинская часть",							{179,253,287,61,61,61,61,61,61,61}, 191, 	{1817.029907,1700.969116,1493.047119,94.826721},	{2883.7461,1444.4747,1050.9984}, 	1, 1, 0x996633FF, 250, ""},
	{"Городская больница",						{276,274,275,70,70,70,70,70,70,70},	69, 	{1496.149658,2527.073730,2501.000000,264.984924}, 	{0.0, 0.0, 0.0},					1, 1, 0xFF6666FF, 150, ""},
	{"СМИ",								{184,188,171,186,186,186,186,186,186,186},	263, 	{1981.5616,-17.8172,1381.0035,354.2428}, 	{0.0, 0.0, 0.0}, 					1, 1, 0xFF6600FF, 250, ""},
	{"Отдел полиции №1 (ГИБДД)",				{282,281,280,288,288,288,288,288,288,288},	76, 	{-1094.254394,1523.638549,1499.947265,177.775161},	{0.0, 0.0, 0.0}, 					1, 1, 0x0000FFFF, 450, ""},
	{"Отдел полиции №2 (УМВД)",					{277,284,285,15,15,15,15,15,15,15}, 76, 	{-1094.254394,1523.638549,1499.947265,177.775161}, 	{0.0, 0.0, 0.0}, 					1, 2, 0x0000FFFF, 450, ""},
	{"ФСБ", 									{72,163,286,164,164,164,164,164,164,164}, 76, 	{2882.0996,2010.4512,2050.9980,179.2590}, 	{0.0, 0.0, 0.0}, 					1, 1, 0x0000FFFF, 300, ""},
	{"Арзамасская ОПГ",							{112,113,105,111,111,111,111,111,111,111},	148, 	{-2.180953,488.315734,1381.002197,359.671936}, 		{-10.164318,489.312469,1381.002197},		1, 1, 0x009900FF,450, ""},
	{"Батыревская ОПГ",							{116,114,115,117,117,117,117,117,117,117},	193, 	{-2.180953,488.315734,1381.002197,359.671936}, 	{-10.164318,489.312469,1381.002197},	1, 2, 0x6666FFFF, 350, ""},
	{"Лыткаринская ОПГ",						{104,103,102,111,111,111,111,111,111,111},	195, 	{-2.180953,488.315734,1381.002197,359.671936}, 		{-10.164318,489.312469,1381.002197},		1, 3, 0xFFCD00FF, 250, ""},
    {"ФСИН", 									{32,4,26,26,26,26,26,26,26,26}, 64, 	{-1876.63,-2727.15,8.58,227.22}, 	{0.0, 0.0, 0.0}, 							0, 0, 0xB0E0E6, 300, ""}
};

команду setleader заменить на
CMD:setleader(playerid, params[])
{
 if(GetPlayerAdminEx(playerid) < 6)
 return ShowNotification(playerid, 2, "У вас нет доступа к использованию данной команде", 3, "", "");
 
 if(sscanf(params, "u", params[0]))
 return SendClientMessage(playerid, 0xFFFFFFFF, ""SC"Используйте /setleader [ID игрока]");
 
 if(!IsPlayerConnected(params[0]))
 return ShowNotification(playerid, 2, "Такого игрока нет", 4, " ", "");
 
 new P_TARGET_PLAYER_ID;
 
 g_player[playerid][P_TARGET_PLAYER_ID] = params[0];
 
 Dialog
 (
	playerid, 19469, DIALOG_STYLE_LIST,
	"{FF6347}"SERVER_NAME" {FFFFFF}| Выдача постоянного лидерства",
    "{F0E68C}| Правительство {008000}Выдать\n\
	{4169E1}| ФСБ {008000}Выдать\n\
	{4169E1}| Отдел полиции №1 (УМВД) {008000}Выдать\n\
	{4169E1}| Отдел полиции №2 (ГИБДД) {008000}Выдать\n\
	{8B4513}| Армия {008000}Выдать\n\
	{FA8072}| Больница {008000}Выдать\n\
	{FF4500}| СМИ {008000}Выдать\n\
	{32CD32}| Арзамасская ОПГ {008000}Выдать\n\
	{7B68EE}| Батыревская ОПГ {008000}Выдать\n\
	{FFD700}| Лыткаринская ОПГ {008000}Выдать\n\
	{FFD700}| ФСИН {008000}Выдать\n\
	{FFFFFF}| Снять с поста",
	"Выбрать",
	"Выход"
 );
 return 1;
}

команду templeader заменить на
CMD:templeader(playerid)
{
  if(GetPlayerAdminEx(playerid) <6)
 return SendClientMessage(playerid, 0xFFFFFFFF, "{FF0000}| {FFFFFF}Доступно только администраторам 3-его уровня.");

 Dialog
 (
	playerid, 19470, DIALOG_STYLE_LIST,
	"{EB4C42}"SERVER_NAME"{ffffff} | Меню временного лилерства",
    "{F0E68C}| Правительство {008000}Выдать\n\
	{4169E1}| ФСБ {008000}Выдать\n\
	{4169E1}| Отдел полиции №1 (УМВД) {008000}Выдать\n\
	{4169E1}| Отдел полиции №2 (ГИБДД) {008000}Выдать\n\
	{8B4513}| Армия {008000}Выдать\n\
	{FA8072}| Больница {008000}Выдать\n\
	{FF4500}| СМИ {008000}Выдать\n\
	{32CD32}| Арзамасская ОПГ {008000}Выдать\n\
	{7B68EE}| Батыревская ОПГ {008000}Выдать\n\
	{FFD700}| Лыткаринская ОПГ {008000}Выдать\n\
    {FFD700}| ФСИН {008000}Выдать\n\
	{FFFFFF}| Снять с поста",
	"Выбрать",
	"Выход"
 );
 return 1;
}
*/

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if((newkeys & KEY_JUMP))
    {
        if(!IsPlayerInAnyVehicle(playerid))
        {
            if(GetPlayerTeamEx(playerid) != TEAM_FSIN)
            {
                if(IsPlayerInRangeOfPoint(playerid, 250.0, -1778.83, -2754.59, 7.58))
                {
                    TogglePlayerControllable(playerid, false);
                    SetTimerEx("UnfreezePlayerFsin", 300, false, "i", playerid);
                }
            }
        }
        return 1;
    }
    #if defined fsin_OnPlayerKeyStateChange
        return fsin_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange fsin_OnPlayerKeyStateChange
#if defined fsin_OnPlayerKeyStateChange
    forward fsin_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 19470)
    {
        if(response)
        {
            new textPlayer[100], textAdmin[100];
            switch(listitem)
            {
                case 0:
                {
                    InvitePlayer(playerid, 1, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Правительство области\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Правительство области\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 1:
                {
                    InvitePlayer(playerid, 7, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"ФСБ\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"ФСБ\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 2:
                {
                    InvitePlayer(playerid, 6, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"УМВД\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"УМВД\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 3:
                {
                    InvitePlayer(playerid, 5, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] {FFFFFF}взял временное лидерство \"ГИБДД\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"ГИБДД\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 4:
                {
                    InvitePlayer(playerid, 2, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Армия\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Армия\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 5:
                {
                    InvitePlayer(playerid, 3, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Больница\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Больница\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 6:
                {
                    InvitePlayer(playerid, 4, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"СМИ\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"СМИ\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 7:
                {
                    InvitePlayer(playerid, 8, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Арзамасская ОПГ\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 8:
                {
                    InvitePlayer(playerid, 9, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Батыревская ОПГ\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 9:
                {
                    InvitePlayer(playerid, 10, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"Лыткаринская ОПГ\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 10:
                {
                    InvitePlayer(playerid, 11, 10, true);
                    format(textAdmin, sizeof(textAdmin), "[A] %s[%d] взял временное лидерство \"ФСИН\".", GetPlayerNameEx(playerid), playerid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Вы взяли временное лидерство организации \"ФСИН\".");
                    SendMessageToAdmins(textAdmin, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textPlayer);
                }
                case 11:
                {
                    InvitePlayer(playerid, 0, 0, true);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы сняли с себя временное лидерство.");
                    SendClientMessage(playerid, 0x999999FF, textAdmin);
                }
            }
        }
    }
    if(dialogid == 19469)
    {
        if(response)
        {
            new P_TARGET_PLAYER_ID;
            new targetid = g_player[playerid][P_TARGET_PLAYER_ID];
            new textPlayer[123 + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + 1], textAdmin[109 + (-2 + MAX_PLAYER_NAME) + (-2 + 3) + 1], textAdmins[444];
            switch(listitem)
            {
                case 0:
                {
                    InvitePlayer(targetid, 1, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Правительство области\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Правительство области\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Правительство области\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 1:
                {
                    InvitePlayer(targetid, 7, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"ФСБ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"ФСБ\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"ФСБ\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 2:
                {
                    InvitePlayer(targetid, 6, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"УМВД\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"УМВД\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"УМВД\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 3:
                {
                    InvitePlayer(targetid, 5, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"ГИБДД\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"ГИБДД\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"ГИБДД\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 4:
                {
                    InvitePlayer(targetid, 2, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Армия\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Армия\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Армия\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 5:
                {
                    InvitePlayer(targetid, 3, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Больница\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Больница\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Больница\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 6:
                {
                    InvitePlayer(targetid, 4, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"СМИ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"СМИ\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"СМИ\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 7:
                {
                    InvitePlayer(targetid, 8, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Арзамасская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 8:
                {
                    InvitePlayer(targetid, 9, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Батыревская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 9:
                {
                    InvitePlayer(targetid, 10, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил Вас на пост лидера \"Лыткаринская ОПГ\".", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 10:
                {
                    InvitePlayer(targetid, 11, 10, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] назначил %s[%d] на пост лидера ФСИН", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы назначили %s[%d] на пост лидера ФСИН.", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] назначил вас на пост лидера ФСИН.", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
                case 11:
                {
                    InvitePlayer(targetid, 0, 0, true);
                    format(textAdmins, sizeof(textAdmins), "[A] %s[%d] снял %s[%d] с поста лидера", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
                    format(textAdmin, sizeof(textAdmin), "{1E90FF}Вы сняли %s[%d] с поста лидера.", GetPlayerNameEx(targetid), targetid);
                    format(textPlayer, sizeof(textPlayer), "{1E90FF}Администратор %s[%d] снял Вас с поста лидера.", GetPlayerNameEx(playerid), playerid);
                    SendMessageToAdmins(textAdmins, 0x999999FF);
                    SendClientMessage(playerid, 0xFFFFFFFF, textAdmin);
                    SendClientMessage(targetid, 0xFFFFFFFF, textPlayer);
                }
            }
        }
    }
    #if defined fsin_OnDialogResponse
        return fsin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 1;
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse fsin_OnDialogResponse

#if defined fsin_OnDialogResponse
    forward fsin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock IsPlayerInFsin(playerid)
{
	if(TEAM_FSIN <= GetPlayerTeamEx(playerid) <= TEAM_DPS, TEAM_PPS <= GetPlayerTeamEx(playerid) <= TEAM_GOVERNMENT) return true;
	return false;
}

forward UnfreezePlayerFsin(playerid);
public UnfreezePlayerFsin(playerid)
{
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, true);

	return 1;
}