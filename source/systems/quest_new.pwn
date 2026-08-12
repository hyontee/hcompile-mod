#if defined _quest_inc
	#endinput
#endif
#define _quest_inc

enum 
{
	QUEST_GUEST = 0,
	QUEST_GHETTO,
	QUEST_MAFIA,
	QUEST_PD,
	QUEST_FBI, // закон
	QUEST_ARMY,
	QUEST_SCHOOL,
	QUEST_BIKERS,
	QUEST_HOSPITAL,
	QUEST_LAST
}
//Гетто\nЗакон\nМафия\nАрмия\nИнструкторы\nБайкеры\nМЧС

enum E_PLAYER_QUEST 
{
	pQuestID[QUEST_LAST], // сохранение квеста на сколько прошел 
	pQuestTemp[QUEST_LAST] // как квест на сколько пройденный 
};

new pQuest[MAX_PLAYERS][E_PLAYER_QUEST];

enum {
	QUEST_TASK_LOADER_BAGS,
	QUEST_TASK_FACTORY,
	QUEST_TASK_FARM,
	QUEST_TASK_LICENCE_CAR,
	QUEST_TASK_VICTIM,
	QUEST_TASK_MAYOR,
	QUEST_TASK_BUS, // квесты работы начало
	QUEST_TASK_TAXI,
	QUEST_TASK_MEH,
	QUEST_TASK_COLLECTOR,
	QUEST_TASK_COACH,
	QUEST_TASK_TRUCK,
	QUEST_TASK_HOUSE,
	QUEST_TASK_CAR, 

	QUEST_TASK_SLOT1, // свободный слот для гражданских 1
	QUEST_TASK_SLOT2, // свободный слот для гражданских 2
	QUEST_TASK_SLOT3, // свободный слот для гражданских 3
	QUEST_TASK_SLOT4, // свободный слот для гражданских 4
	QUEST_TASK_SLOT5, // свободный слот для гражданских 5
	QUEST_TASK_SLOT6, // свободный слот для гражданских 6
	QUEST_TASK_SLOT7, // свободный слот для гражданских 7
	QUEST_TASK_SLOT8, // свободный слот для гражданских 8
	QUEST_TASK_SLOT9, // свободный слот для гражданских 9

/*

COUNT_COMPLATE_BAGS, 
COUNT_COMPLATE_FACTORY, 
COUNT_COMPLATE_FARM, 1,1,1,  // QuestComplationLineMax[select][0] + pInfo[playerid][NumberQuest]
	COUNT_COMPLATE_BUS,COUNT_COMPLATE_TAXI,COUNT_COMPLATE_MEH,COUNT_COMPLATE_COLLECTOR,COUNT_COMPLATE_COACH,COUNT_COMPLATE_TRUCK,1,1,
	2,3,4,5,6,7,8,9,10,*/


	QUEST_TASK_GUN,
	QUEST_TASK_DRUGS,
	QUEST_TASK_ROBHOUSE,
	QUEST_TASK_DUEL_5,
	QUEST_TASK_ROB_CAR,
	QUEST_TASK_DMG_5,
	QUEST_TASK_GPOINT_100,
	QUEST_TASK_PAINT,
	QUEST_TASK_CAPTURE,
	QUEST_TASK_KILLS_400,
	QUEST_TASK_WIN_CAPTURE,
	QUEST_TASK_LSA_300,
	QUEST_TASK_MATS_250,
	QUEST_TASK_KILL_LEADER,

	QUEST_TASK_RACKET_BIZ,
	QUEST_TASK_RACKET,
	QUEST_TASK_HACKBASE,
	QUEST_TASK_MAFIA_WAR,
	QUEST_TASK_MAFIA_DICE,
	QUEST_TASK_MAFIA_KILLER,
	QUEST_TASK_MAFIA_TIE,
	QUEST_TASK_MAFIA_JAIL,

	// ПД + ФБР

	QUEST_TASK_PD_NEWBIE, // Слуга народа
	QUEST_TASK_PD_ARREST, // Дежурный офицер
	QUEST_TASK_PD_TAZER, // Нападения на сотрудников
	QUEST_TASK_PD_DRUGS, // Контроль оборотов
	QUEST_TASK_PD_ARREST6, // Без башни
	QUEST_TASK_PD_PATRUL, // Патрульная служба
	QUEST_TASK_PD_GANG, // Наркобароны

	QUEST_TASK_PD_1,
	QUEST_TASK_PD_2,
	QUEST_TASK_PD_3,
	QUEST_TASK_PD_4,
	QUEST_TASK_PD_5,
	QUEST_TASK_PD_6,
	QUEST_TASK_PD_7,
	QUEST_TASK_PD_8,
	QUEST_TASK_PD_9,
	QUEST_TASK_PD_10,
	QUEST_TASK_PD_11,
	QUEST_TASK_PD_12,
	QUEST_TASK_PD_13,

	// ФБР 
	QUEST_TASK_FBI_ARREST, // Стажировка
	QUEST_TASK_FBI_TIPSTER, // Поддержка безопасности
	QUEST_TASK_FBI_ARREST_GHETTO, // Работа под прикрытием
	QUEST_TASK_FBI_DRUGS, // Контроль оборотов II
	QUEST_TASK_FBI_TAKE, // Неполноценные сотрудники
	QUEST_TASK_FBI_PATRUL, // Имея должность Агент CID
	QUEST_TASK_FBI_FIND, // Имея должность Глава GNK
	QUEST_TASK_FBI_ARREST_GANG, // Нелегальные иммигранты
	QUEST_TASK_FBI_ARREST_LEADER, // Имея должность глава CID

	QUEST_TASK_FBI_1,
	QUEST_TASK_FBI_2,
	QUEST_TASK_FBI_3,
	QUEST_TASK_FBI_4,
	QUEST_TASK_FBI_5,
	QUEST_TASK_FBI_6,
	QUEST_TASK_FBI_7,
	QUEST_TASK_FBI_8,
	QUEST_TASK_FBI_9,
	QUEST_TASK_FBI_10,

	// ARMY
	QUEST_TASK_ARMY_NEWBIE,
	QUEST_TASK_ARMY_KMB,
	QUEST_TASK_ARMY_SNIPER,
	QUEST_TASK_ARMY_MP5,
	QUEST_TASK_ARMY_UNLOAD_PORT,
	QUEST_TASK_ARMY_UNLOAD_GOS,
	QUEST_TASK_ARMY_GANG,
	QUEST_TASK_ARMY_GANG_LS,
	QUEST_TASK_ARMY_GANG_NODIE,

	QUEST_TASK_LAST
};

// выдача денег
// гражданские
#define			MONEY_QUEST_LOADER_BAGS			2000
#define			MONEY_QUEST_FACTORY				2000 // свободный слот для гражданских 0
#define			MONEY_QUEST_FARM				3000
#define			MONEY_QUEST_LICENCE_CAR			2000
#define			MONEY_QUEST_VICTIM				1000
#define			MONEY_QUEST_MAYOR				2000
#define			MONEY_QUEST_BUS					20000
#define			MONEY_QUEST_TAXI				5000
#define			MONEY_QUEST_MEH					5000
#define			MONEY_QUEST_COLLECTOR			5000
#define			MONEY_QUEST_COACH				5000
#define			MONEY_QUEST_TRUCK				10000
#define			MONEY_QUEST_HOUSE				100000
#define			MONEY_QUEST_CAR					100000

#define			MONEY_QUEST_TASK_SLOT1			2000 // свободный слот для гражданских 1
#define			MONEY_QUEST_TASK_SLOT2			2000 // свободный слот для гражданских 2
#define			MONEY_QUEST_TASK_SLOT3			2000 // свободный слот для гражданских 3
#define			MONEY_QUEST_TASK_SLOT4			2000 // свободный слот для гражданских 4
#define			MONEY_QUEST_TASK_SLOT5			2000 // свободный слот для гражданских 5
#define			MONEY_QUEST_TASK_SLOT6			2000 // свободный слот для гражданских 6
#define			MONEY_QUEST_TASK_SLOT7			2000 // свободный слот для гражданских 7
#define			MONEY_QUEST_TASK_SLOT8			2000 // свободный слот для гражданских 8
#define			MONEY_QUEST_TASK_SLOT9			2000 // свободный слот для гражданских 9
 // QUEST GHETTO
#define			MONEY_TASK_GUN				3000
#define			MONEY_TASK_DRUGS			3000
#define			MONEY_TASK_ROBHOUSE			10000
#define			MONEY_TASK_DUEL_5			10000
#define			MONEY_TASK_ROB_CAR			10000
#define			MONEY_TASK_DMG_5			50000
#define			MONEY_TASK_GPOINT_100		20000
#define			MONEY_TASK_PAINT			20000
#define			MONEY_TASK_CAPTURE			100000
#define			MONEY_TASK_KILLS_400		100000
#define			MONEY_TASK_WIN_CAPTURE		30000
#define			MONEY_TASK_LSA_300			50000
#define			MONEY_TASK_MATS_250			50000
#define			MONEY_TASK_KILL_LEADER		200000
#define 		MATERIALS_TASK_GUN			1000
#define 		MATERIALS_TASK_DUEL			1000
#define 		MATERIALS_TASK_KILLS		2000
#define 		MATERIALS_TASK_WIN_WAR		5000
#define 		MATERIALS_TASK_KILL_LEADER	5000
// mafia

#define			MONEY_TASK_RACKET_BIZ		100000
#define			MONEY_TASK_RACKET			50000
#define			MONEY_TASK_HACKBASE			30000
#define			MONEY_TASK_MAFIA_WAR		40000
#define			MONEY_TASK_MAFIA_DICE		50000
#define			MONEY_TASK_MAFIA_KILLER		50000
#define			MONEY_TASK_MAFIA_TIE		70000
#define			MONEY_TASK_MAFIA_JAIL		150000

// lawyer

#define			MONEY_TASK_PD_NEWBIE				5000
#define			MONEY_TASK_PD_ARREST				10000
#define			MONEY_TASK_PD_TAZER					20000
#define			MONEY_TASK_PD_DRUGS					25000
#define			MONEY_TASK_PD_ARREST6				30000
#define			MONEY_TASK_PD_PATRUL				30000
#define			MONEY_TASK_PD_GANG					100000

// PD

#define			MONEY_TASK_PD_SLOT_1				1
#define			MONEY_TASK_PD_SLOT_2				1
#define			MONEY_TASK_PD_SLOT_3				1
#define			MONEY_TASK_PD_SLOT_4				1
#define			MONEY_TASK_PD_SLOT_5				1
#define			MONEY_TASK_PD_SLOT_6				1
#define			MONEY_TASK_PD_SLOT_7				1
#define			MONEY_TASK_PD_SLOT_8				1
#define			MONEY_TASK_PD_SLOT_9				1
#define			MONEY_TASK_PD_SLOT_10				1
#define			MONEY_TASK_PD_SLOT_11				1
#define			MONEY_TASK_PD_SLOT_12				1
#define			MONEY_TASK_PD_SLOT_13				1

// fbi

#define			MONEY_TASK_FBI_ARREST				20000
#define			MONEY_TASK_FBI_TIPSTER				10000
#define			MONEY_TASK_FBI_ARREST_GHETTO		30000
#define			MONEY_TASK_FBI_DRUGS				20000
#define			MONEY_TASK_FBI_TAKE					20000
#define			MONEY_TASK_FBI_PATRUL				50000
#define			MONEY_TASK_FBI_FIND					30000
#define			MONEY_TASK_FBI_ARREST_GANG			50000
#define			MONEY_TASK_FBI_ARREST_LEADER		100000

#define			MONEY_TASK_FBI_SLOT_1				1
#define			MONEY_TASK_FBI_SLOT_2				1
#define			MONEY_TASK_FBI_SLOT_3				1
#define			MONEY_TASK_FBI_SLOT_4				1
#define			MONEY_TASK_FBI_SLOT_5				1
#define			MONEY_TASK_FBI_SLOT_6				1
#define			MONEY_TASK_FBI_SLOT_7				1
#define			MONEY_TASK_FBI_SLOT_8				1
#define			MONEY_TASK_FBI_SLOT_9				1
#define			MONEY_TASK_FBI_SLOT_10				1

// army

#define			MONEY_TASK_ARMY_NEWBIE				5000
#define			MONEY_TASK_ARMY_KMB					10000	
#define			MONEY_TASK_ARMY_SNIPER				10000
#define			MONEY_TASK_ARMY_MP5					10000
#define			MONEY_TASK_ARMY_UNLOAD_PORT			50000
#define			MONEY_TASK_ARMY_UNLOAD_GOS			50000
#define			MONEY_TASK_ARMY_GANG				30000
#define			MONEY_TASK_ARMY_GANG_LS				20000
#define			MONEY_TASK_ARMY_GANG_NODIE			100000


// выдача exp
#define			EXP_QUEST_LOADER_BAGS			2
#define			EXP_QUEST_FACTORY				2 // свободный слот для гражданских 0
#define			EXP_QUEST_FARM					2
#define			EXP_QUEST_LICENCE_CAR			2
#define			EXP_QUEST_VICTIM				1
#define			EXP_QUEST_MAYOR					8
#define			EXP_QUEST_BUS					2
#define			EXP_QUEST_TAXI					2
#define			EXP_QUEST_MEH					2
#define			EXP_QUEST_COLLECTOR				2
#define			EXP_QUEST_COACH					2
#define			EXP_QUEST_TRUCK					2
#define			EXP_QUEST_HOUSE					2
#define			EXP_QUEST_CAR					2

#define			EXP_QUEST_TASK_SLOT1			1 // свободный слот для гражданских 1
#define			EXP_QUEST_TASK_SLOT2			1 // свободный слот для гражданских 2
#define			EXP_QUEST_TASK_SLOT3			1 // свободный слот для гражданских 3
#define			EXP_QUEST_TASK_SLOT4			1 // свободный слот для гражданских 4
#define			EXP_QUEST_TASK_SLOT5			1 // свободный слот для гражданских 5
#define			EXP_QUEST_TASK_SLOT6			1 // свободный слот для гражданских 6
#define			EXP_QUEST_TASK_SLOT7			1 // свободный слот для гражданских 7
#define			EXP_QUEST_TASK_SLOT8			1 // свободный слот для гражданских 8
#define			EXP_QUEST_TASK_SLOT9			1 // свободный слот для гражданских 9
// QUEST GHETTO
#define			EXP_TASK_GUN					1
#define			EXP_TASK_DRUGS					1
#define			EXP_TASK_ROBHOUSE				2
#define			EXP_TASK_DUEL_5					2
#define			EXP_TASK_ROB_CAR				1
#define			EXP_TASK_DMG_5					3
#define			EXP_TASK_GPOINT_100				3
#define			EXP_TASK_PAINT					2
#define			EXP_TASK_CAPTURE				2
#define			EXP_TASK_KILLS_400				2
#define			EXP_TASK_WIN_CAPTURE			3
#define			EXP_TASK_LSA_300				5
#define			EXP_TASK_MATS_250				5
#define			EXP_TASK_KILL_LEADER			5
// mafia 

#define			EXP_TASK_RACKET_BIZ				2
#define			EXP_TASK_RACKET					2
#define			EXP_TASK_HACKBASE				1
#define			EXP_TASK_MAFIA_WAR				3
#define			EXP_TASK_MAFIA_DICE				1
#define			EXP_TASK_MAFIA_KILLER			2
#define			EXP_TASK_MAFIA_TIE				2
#define			EXP_TASK_MAFIA_JAIL				3

// lawyer

#define			EXP_TASK_PD_NEWBIE					1
#define			EXP_TASK_PD_ARREST					1
#define			EXP_TASK_PD_TAZER					1
#define			EXP_TASK_PD_DRUGS					1
#define			EXP_TASK_PD_ARREST6					1
#define			EXP_TASK_PD_PATRUL					1
#define			EXP_TASK_PD_GANG					1

#define			EXP_TASK_PD_SLOT_1				1
#define			EXP_TASK_PD_SLOT_2				1
#define			EXP_TASK_PD_SLOT_3				1
#define			EXP_TASK_PD_SLOT_4				1
#define			EXP_TASK_PD_SLOT_5				1
#define			EXP_TASK_PD_SLOT_6				1
#define			EXP_TASK_PD_SLOT_7				1
#define			EXP_TASK_PD_SLOT_8				1
#define			EXP_TASK_PD_SLOT_9				1
#define			EXP_TASK_PD_SLOT_10				1
#define			EXP_TASK_PD_SLOT_11				1
#define			EXP_TASK_PD_SLOT_12				1
#define			EXP_TASK_PD_SLOT_13				1

// FBI

#define			EXP_TASK_FBI_ARREST					1
#define			EXP_TASK_FBI_TIPSTER				1
#define			EXP_TASK_FBI_ARREST_GHETTO			1
#define			EXP_TASK_FBI_DRUGS					1
#define			EXP_TASK_FBI_TAKE					1
#define			EXP_TASK_FBI_PATRUL					1
#define			EXP_TASK_FBI_FIND					1
#define			EXP_TASK_FBI_ARREST_GANG			1
#define			EXP_TASK_FBI_ARREST_LEADER			1

#define			EXP_TASK_FBI_SLOT_1				1
#define			EXP_TASK_FBI_SLOT_2				1
#define			EXP_TASK_FBI_SLOT_3				1
#define			EXP_TASK_FBI_SLOT_4				1
#define			EXP_TASK_FBI_SLOT_5				1
#define			EXP_TASK_FBI_SLOT_6				1
#define			EXP_TASK_FBI_SLOT_7				1
#define			EXP_TASK_FBI_SLOT_8				1
#define			EXP_TASK_FBI_SLOT_9				1
#define			EXP_TASK_FBI_SLOT_10			1


// army

#define			EXP_TASK_ARMY_NEWBIE				1
#define			EXP_TASK_ARMY_KMB					2	
#define			EXP_TASK_ARMY_SNIPER				1
#define			EXP_TASK_ARMY_MP5					1
#define			EXP_TASK_ARMY_UNLOAD_PORT			3
#define			EXP_TASK_ARMY_UNLOAD_GOS			3
#define			EXP_TASK_ARMY_GANG					1
#define			EXP_TASK_ARMY_GANG_LS				1
#define			EXP_TASK_ARMY_GANG_NODIE			3


// сколько нужно до завершения квеста
// гражданские
#define			COUNT_COMPLATE_BAGS				20
#define			COUNT_COMPLATE_FACTORY			20
#define			COUNT_COMPLATE_FARM				20
#define			COUNT_COMPLATE_BUS				30000
#define			COUNT_COMPLATE_TAXI				20
#define			COUNT_COMPLATE_MEH				20
#define			COUNT_COMPLATE_COLLECTOR		50
#define 		COUNT_COMPLATE_COACH			20
#define 		COUNT_COMPLATE_TRUCK			30
// ghetto
#define			COUNT_TASK_GUN					100
#define			COUNT_TASK_DRUGS				150
#define			COUNT_TASK_ROBHOUSE				10
#define			COUNT_TASK_DUEL_5				5
#define			COUNT_TASK_ROB_CAR				10
#define			COUNT_TASK_DMG_5				5000
#define			COUNT_TASK_GPOINT_100			100
#define			COUNT_TASK_PAINT				10
#define			COUNT_TASK_CAPTURE				3
#define			COUNT_TASK_KILLS_400			400
#define			COUNT_TASK_WIN_CAPTURE			3
#define			COUNT_TASK_LSA_300				300000
#define			COUNT_TASK_MATS_250				250000
#define			COUNT_TASK_KILL_LEADER			1
// mafia
#define			COUNT_TASK_RACKET_BIZ 			10
#define			COUNT_TASK_RACKET 				5
#define			COUNT_TASK_HACKBASE				3
#define			COUNT_TASK_MAFIA_WAR			20
#define			COUNT_TASK_MAFIA_DICE			15000
#define			COUNT_TASK_MAFIA_KILLER			5
#define			COUNT_TASK_MAFIA_TIE			2
#define			COUNT_TASK_MAFIA_JAIL			1

// lawyer

#define			COUNT_TASK_PD_NEWBIE				20
#define			COUNT_TASK_PD_ARREST				30
#define			COUNT_TASK_PD_TAZER					20
#define			COUNT_TASK_PD_DRUGS					500
#define			COUNT_TASK_PD_ARREST6				25
#define			COUNT_TASK_PD_PATRUL				30
#define			COUNT_TASK_PD_GANG					20


#define			COUNT_TASK_PD_SLOT_1				1
#define			COUNT_TASK_PD_SLOT_2				1
#define			COUNT_TASK_PD_SLOT_3				1
#define			COUNT_TASK_PD_SLOT_4				1
#define			COUNT_TASK_PD_SLOT_5				1
#define			COUNT_TASK_PD_SLOT_6				1
#define			COUNT_TASK_PD_SLOT_7				1
#define			COUNT_TASK_PD_SLOT_8				1
#define			COUNT_TASK_PD_SLOT_9				1
#define			COUNT_TASK_PD_SLOT_10				1
#define			COUNT_TASK_PD_SLOT_11				1
#define			COUNT_TASK_PD_SLOT_12				1
#define			COUNT_TASK_PD_SLOT_13				1

// FBI

#define			COUNT_TASK_FBI_ARREST				20
#define			COUNT_TASK_FBI_TIPSTER				1
#define			COUNT_TASK_FBI_ARREST_GHETTO		3
#define			COUNT_TASK_FBI_DRUGS				5000
#define			COUNT_TASK_FBI_TAKE					1
#define			COUNT_TASK_FBI_PATRUL				40
#define			COUNT_TASK_FBI_FIND					30
#define			COUNT_TASK_FBI_ARREST_GANG			10
#define			COUNT_TASK_FBI_ARREST_LEADER		5

#define			COUNT_TASK_FBI_SLOT_1				1
#define			COUNT_TASK_FBI_SLOT_2				1
#define			COUNT_TASK_FBI_SLOT_3				1
#define			COUNT_TASK_FBI_SLOT_4				1
#define			COUNT_TASK_FBI_SLOT_5				1
#define			COUNT_TASK_FBI_SLOT_6				1
#define			COUNT_TASK_FBI_SLOT_7				1
#define			COUNT_TASK_FBI_SLOT_8				1
#define			COUNT_TASK_FBI_SLOT_9				1
#define			COUNT_TASK_FBI_SLOT_10				1

// ARMY

#define			COUNT_TASK_ARMY_NEWBIE				20
#define			COUNT_TASK_ARMY_KMB					1	
#define			COUNT_TASK_ARMY_SNIPER				30
#define			COUNT_TASK_ARMY_MP5					50
#define			COUNT_TASK_ARMY_UNLOAD_PORT			600000
#define			COUNT_TASK_ARMY_UNLOAD_GOS			200000
#define			COUNT_TASK_ARMY_GANG				10
#define			COUNT_TASK_ARMY_GANG_LS				15
#define			COUNT_TASK_ARMY_GANG_NODIE			20



/*
static const QuestComplationALL[QUEST_LAST] = {
	// номер квеста || кол-во для окончания
	MAX_LINE_QUEST_GUEST,
	MAX_LINE_QUEST_JOBS
};*/

static const QuestComplationLineMax[QUEST_LAST][2] = { // для каждой линии мин. и максимальное значение QuestComplationLine
	{QUEST_TASK_LOADER_BAGS, QUEST_TASK_CAR},
	{QUEST_TASK_GUN, QUEST_TASK_KILL_LEADER},
	{QUEST_TASK_RACKET_BIZ, QUEST_TASK_MAFIA_JAIL},
	{QUEST_TASK_PD_NEWBIE, QUEST_TASK_PD_GANG},
	{QUEST_TASK_FBI_ARREST, QUEST_TASK_FBI_ARREST_LEADER},
	{QUEST_TASK_ARMY_NEWBIE, QUEST_TASK_ARMY_GANG_NODIE},

	{QUEST_TASK_LAST, QUEST_TASK_LAST},
	{QUEST_TASK_LAST, QUEST_TASK_LAST},
	{QUEST_TASK_LAST, QUEST_TASK_LAST}
};


static const QuestComplationLine[QUEST_TASK_LAST] = {// максимальное кол-во для выполнения подквеста
	COUNT_COMPLATE_BAGS, COUNT_COMPLATE_FACTORY, COUNT_COMPLATE_FARM,1,1,1,  // QuestComplationLineMax[select][0] + pInfo[playerid][NumberQuest]
	COUNT_COMPLATE_BUS,COUNT_COMPLATE_TAXI,COUNT_COMPLATE_MEH,COUNT_COMPLATE_COLLECTOR,COUNT_COMPLATE_COACH,COUNT_COMPLATE_TRUCK,1,1,
	2,3,4,5,6,7,8,9,10,
	// QUEST GHETTO
	COUNT_TASK_GUN,COUNT_TASK_DRUGS,COUNT_TASK_ROBHOUSE,
	COUNT_TASK_DUEL_5,COUNT_TASK_ROB_CAR,COUNT_TASK_DMG_5,
	COUNT_TASK_GPOINT_100,COUNT_TASK_PAINT,COUNT_TASK_CAPTURE,
	COUNT_TASK_KILLS_400,COUNT_TASK_WIN_CAPTURE,COUNT_TASK_LSA_300,
	COUNT_TASK_MATS_250,COUNT_TASK_KILL_LEADER,
	// QUEST MAFIA
	COUNT_TASK_RACKET_BIZ, COUNT_TASK_RACKET, COUNT_TASK_HACKBASE, COUNT_TASK_MAFIA_WAR,
	COUNT_TASK_MAFIA_DICE, COUNT_TASK_MAFIA_KILLER, COUNT_TASK_MAFIA_TIE, COUNT_TASK_MAFIA_JAIL,


	// QUEST LAWYER

	COUNT_TASK_PD_NEWBIE,
	COUNT_TASK_PD_ARREST,
	COUNT_TASK_PD_TAZER,
	COUNT_TASK_PD_DRUGS,
	COUNT_TASK_PD_ARREST6,
	COUNT_TASK_PD_PATRUL,
	COUNT_TASK_PD_GANG,

	COUNT_TASK_PD_SLOT_1,COUNT_TASK_PD_SLOT_2,COUNT_TASK_PD_SLOT_3,COUNT_TASK_PD_SLOT_4,COUNT_TASK_PD_SLOT_5,
	COUNT_TASK_PD_SLOT_6,COUNT_TASK_PD_SLOT_7,COUNT_TASK_PD_SLOT_8,COUNT_TASK_PD_SLOT_9,COUNT_TASK_PD_SLOT_10,
	COUNT_TASK_PD_SLOT_11,COUNT_TASK_PD_SLOT_12,COUNT_TASK_PD_SLOT_13,
	// fbi
	COUNT_TASK_FBI_ARREST,
	COUNT_TASK_FBI_TIPSTER,
	COUNT_TASK_FBI_ARREST_GHETTO,
	COUNT_TASK_FBI_DRUGS,
	COUNT_TASK_FBI_TAKE,
	COUNT_TASK_FBI_PATRUL,
	COUNT_TASK_FBI_FIND,
	COUNT_TASK_FBI_ARREST_GANG,
	COUNT_TASK_FBI_ARREST_LEADER,

	COUNT_TASK_FBI_SLOT_1,COUNT_TASK_FBI_SLOT_2,COUNT_TASK_FBI_SLOT_3,COUNT_TASK_FBI_SLOT_4,COUNT_TASK_FBI_SLOT_5,
	COUNT_TASK_FBI_SLOT_6,COUNT_TASK_FBI_SLOT_7,COUNT_TASK_FBI_SLOT_8,COUNT_TASK_FBI_SLOT_9,COUNT_TASK_FBI_SLOT_10,


	COUNT_TASK_ARMY_NEWBIE,COUNT_TASK_ARMY_KMB,COUNT_TASK_ARMY_SNIPER,
	COUNT_TASK_ARMY_MP5,COUNT_TASK_ARMY_UNLOAD_PORT,COUNT_TASK_ARMY_UNLOAD_GOS,
	COUNT_TASK_ARMY_GANG,COUNT_TASK_ARMY_GANG_LS,COUNT_TASK_ARMY_GANG_NODIE


};

static const QuestComplationLineReward[QUEST_TASK_LAST][3] = {// выдача денег за выполнения подквеста
	{MONEY_QUEST_LOADER_BAGS, EXP_QUEST_LOADER_BAGS, 0},
	{MONEY_QUEST_FACTORY, EXP_QUEST_FACTORY, 0},
	{MONEY_QUEST_LICENCE_CAR, EXP_QUEST_FARM, 0}, 
	{MONEY_QUEST_FARM, EXP_QUEST_LICENCE_CAR, 0},
	{MONEY_QUEST_VICTIM, MONEY_QUEST_VICTIM, 0},
	{MONEY_QUEST_MAYOR, EXP_QUEST_MAYOR, 0},
	{MONEY_QUEST_BUS, EXP_QUEST_BUS, 0},
	{MONEY_QUEST_TAXI, EXP_QUEST_TAXI, 0},
	{MONEY_QUEST_MEH, EXP_QUEST_MEH, 0},
	{MONEY_QUEST_COLLECTOR,EXP_QUEST_COLLECTOR, 0},
	{MONEY_QUEST_COACH,EXP_QUEST_COACH, 0},
	{MONEY_QUEST_TRUCK,EXP_QUEST_TRUCK, 0},
	{MONEY_QUEST_HOUSE,EXP_QUEST_HOUSE, 0},
	{MONEY_QUEST_CAR,EXP_QUEST_CAR, 0},
	
	{MONEY_QUEST_TASK_SLOT1,MONEY_QUEST_TASK_SLOT1, 0},
	{MONEY_QUEST_TASK_SLOT2,MONEY_QUEST_TASK_SLOT2, 0},
	{MONEY_QUEST_TASK_SLOT3,MONEY_QUEST_TASK_SLOT3, 0},
	{MONEY_QUEST_TASK_SLOT4,MONEY_QUEST_TASK_SLOT4, 0},
	{MONEY_QUEST_TASK_SLOT5,MONEY_QUEST_TASK_SLOT5, 0},
	{MONEY_QUEST_TASK_SLOT6,MONEY_QUEST_TASK_SLOT6, 0},
	{MONEY_QUEST_TASK_SLOT7,MONEY_QUEST_TASK_SLOT7, 0},
	{MONEY_QUEST_TASK_SLOT8,MONEY_QUEST_TASK_SLOT8, 0},
	{MONEY_QUEST_TASK_SLOT9,MONEY_QUEST_TASK_SLOT9, 0},
	// QUEST GHETTO

	{MONEY_TASK_GUN,EXP_TASK_GUN, MATERIALS_TASK_GUN},
	{MONEY_TASK_DRUGS,EXP_TASK_DRUGS, 0},
	{MONEY_TASK_ROBHOUSE,EXP_TASK_ROBHOUSE, 0},
	{MONEY_TASK_DUEL_5,EXP_TASK_DUEL_5, MATERIALS_TASK_DUEL},
	{MONEY_TASK_ROB_CAR,EXP_TASK_ROB_CAR, 0},
	{MONEY_TASK_DMG_5,EXP_TASK_DMG_5, 0},
	{MONEY_TASK_GPOINT_100,EXP_TASK_GPOINT_100, 0},
	{MONEY_TASK_PAINT,EXP_TASK_PAINT, 0},
	{MONEY_TASK_CAPTURE,EXP_TASK_CAPTURE, 0},
	{MONEY_TASK_KILLS_400,EXP_TASK_KILLS_400, MATERIALS_TASK_KILLS},
	{MONEY_TASK_WIN_CAPTURE,EXP_TASK_WIN_CAPTURE, MATERIALS_TASK_WIN_WAR},
	{MONEY_TASK_LSA_300,EXP_TASK_LSA_300, 0},
	{MONEY_TASK_MATS_250,EXP_TASK_MATS_250, 0},
	{MONEY_TASK_KILL_LEADER,EXP_TASK_KILL_LEADER, MATERIALS_TASK_KILL_LEADER},

	// QUEST MAFIA

	{MONEY_TASK_RACKET_BIZ,EXP_TASK_RACKET_BIZ, 0},
	{MONEY_TASK_RACKET,EXP_TASK_RACKET, 0},
	{MONEY_TASK_HACKBASE,EXP_TASK_HACKBASE, 0},
	{MONEY_TASK_MAFIA_WAR,EXP_TASK_MAFIA_WAR, 0},
	{MONEY_TASK_MAFIA_DICE,EXP_TASK_MAFIA_DICE, 0},
	{MONEY_TASK_MAFIA_KILLER,EXP_TASK_MAFIA_KILLER, 0},
	{MONEY_TASK_MAFIA_TIE,EXP_TASK_MAFIA_TIE, 0},
	{MONEY_TASK_MAFIA_JAIL, EXP_TASK_MAFIA_JAIL, 0},

	// pd
	{MONEY_TASK_PD_NEWBIE, EXP_TASK_PD_NEWBIE, 0},
	{MONEY_TASK_PD_ARREST, EXP_TASK_PD_ARREST, 0},
	{MONEY_TASK_PD_TAZER, EXP_TASK_PD_TAZER, 0},
	{MONEY_TASK_PD_DRUGS, EXP_TASK_PD_DRUGS, 0},
	{MONEY_TASK_PD_ARREST6, EXP_TASK_PD_ARREST6, 0},
	{MONEY_TASK_PD_PATRUL, EXP_TASK_PD_PATRUL, 0},
	{MONEY_TASK_PD_GANG, EXP_TASK_PD_GANG, 0},

	{MONEY_TASK_PD_SLOT_1,EXP_TASK_PD_SLOT_1, 0},
	{MONEY_TASK_PD_SLOT_2,EXP_TASK_PD_SLOT_2, 0},
	{MONEY_TASK_PD_SLOT_3,EXP_TASK_PD_SLOT_3, 0},
	{MONEY_TASK_PD_SLOT_4,EXP_TASK_PD_SLOT_4, 0},
	{MONEY_TASK_PD_SLOT_5,EXP_TASK_PD_SLOT_5, 0},
	{MONEY_TASK_PD_SLOT_6,EXP_TASK_PD_SLOT_6, 0},
	{MONEY_TASK_PD_SLOT_7,EXP_TASK_PD_SLOT_7, 0},
	{MONEY_TASK_PD_SLOT_8,EXP_TASK_PD_SLOT_8, 0},
	{MONEY_TASK_PD_SLOT_9,EXP_TASK_PD_SLOT_9, 0},
	{MONEY_TASK_PD_SLOT_10,EXP_TASK_PD_SLOT_10, 0},
	{MONEY_TASK_PD_SLOT_11,EXP_TASK_PD_SLOT_11, 0},
	{MONEY_TASK_PD_SLOT_12,EXP_TASK_PD_SLOT_12, 0},
	{MONEY_TASK_PD_SLOT_13,EXP_TASK_PD_SLOT_13, 0},

	// fbi
	{MONEY_TASK_FBI_ARREST, EXP_TASK_FBI_ARREST, 0},
	{MONEY_TASK_FBI_TIPSTER, EXP_TASK_FBI_TIPSTER, 0},
	{MONEY_TASK_FBI_ARREST_GHETTO, EXP_TASK_FBI_ARREST_GHETTO, 0},
	{MONEY_TASK_FBI_DRUGS, EXP_TASK_FBI_DRUGS, 0},
	{MONEY_TASK_FBI_TAKE, EXP_TASK_FBI_TAKE, 0},
	{MONEY_TASK_FBI_PATRUL, EXP_TASK_FBI_PATRUL, 0},
	{MONEY_TASK_FBI_FIND, EXP_TASK_FBI_FIND, 0},
	{MONEY_TASK_FBI_ARREST_GANG, EXP_TASK_FBI_ARREST_GANG, 0},
	{MONEY_TASK_FBI_ARREST_LEADER, EXP_TASK_FBI_ARREST_LEADER, 0},

	{MONEY_TASK_FBI_SLOT_1,EXP_TASK_FBI_SLOT_1, 0},
	{MONEY_TASK_FBI_SLOT_2,EXP_TASK_FBI_SLOT_2, 0},
	{MONEY_TASK_FBI_SLOT_3,EXP_TASK_FBI_SLOT_3, 0},
	{MONEY_TASK_FBI_SLOT_4,EXP_TASK_FBI_SLOT_4, 0},
	{MONEY_TASK_FBI_SLOT_5,EXP_TASK_FBI_SLOT_5, 0},
	{MONEY_TASK_FBI_SLOT_6,EXP_TASK_FBI_SLOT_6, 0},
	{MONEY_TASK_FBI_SLOT_7,EXP_TASK_FBI_SLOT_7, 0},
	{MONEY_TASK_FBI_SLOT_8,EXP_TASK_FBI_SLOT_8, 0},
	{MONEY_TASK_FBI_SLOT_9,EXP_TASK_FBI_SLOT_9, 0},
	{MONEY_TASK_FBI_SLOT_10,EXP_TASK_FBI_SLOT_10, 0},

	// army

	{MONEY_TASK_ARMY_NEWBIE,EXP_TASK_ARMY_NEWBIE, 0},
	{MONEY_TASK_ARMY_KMB,EXP_TASK_ARMY_KMB, 0},
	{MONEY_TASK_ARMY_SNIPER,EXP_TASK_ARMY_SNIPER, 0},
	{MONEY_TASK_ARMY_MP5,EXP_TASK_ARMY_MP5, 0},
	{MONEY_TASK_ARMY_UNLOAD_PORT,EXP_TASK_ARMY_UNLOAD_PORT, 0},
	{MONEY_TASK_ARMY_UNLOAD_GOS,EXP_TASK_ARMY_UNLOAD_GOS, 0},
	{MONEY_TASK_ARMY_GANG,EXP_TASK_ARMY_GANG, 0},
	{MONEY_TASK_ARMY_GANG_LS,EXP_TASK_ARMY_GANG_LS, 0},
	{MONEY_TASK_ARMY_GANG_NODIE,EXP_TASK_ARMY_GANG_NODIE, 0}
};



//#define GetPlayerQuestTask(%1)		QuestComplationLineMax[ pInfo[%0][QuestSelect] ][0] +  pInfo[%0][NumberQuest]	pInfo[playerid][NumberQuest]


stock GetPlayerQuestTask(playerid, quest_id)
{
	new task;
	if (!(QUEST_GUEST <= quest_id <= QUEST_LAST-1)) return 0;
	task =  QuestComplationLineMax[quest_id][0] + pQuest[playerid][pQuestID][quest_id];
	//printf("task = %d",task);
	if (task >= QUEST_TASK_LAST) task = 0;
	return task;
}


#define IsPlayerQuestProgressFinish(%2,%1)		QuestComplationLine[ GetPlayerQuestTask(%2,%1) ]
#define GetMoneyQuest(%2,%1) 					QuestComplationLineReward[ GetPlayerQuestTask(%2,%1)][0]
#define GetExpQuest(%2,%1) 						QuestComplationLineReward[ GetPlayerQuestTask(%2,%1)][1]
#define GetMaterialsQuest(%2,%1) 				QuestComplationLineReward[ GetPlayerQuestTask(%2,%1)][2]

static const TitleQuest[QUEST_TASK_LAST][] = {
	// мешки
	""colwhi"Привет! Меня зовут Александр. Я помогу тебе освоиться в нашем штате и найти работу.\n\
	В порту работает мой друг — Артём, ему требуются крепкие ребята — это отличный способ заработать первые деньги.\n\
	С помощью своего навигатора ты сможешь найти его по данному маршруту: /gps —[1]Работы — [0]Работа грузчика.\n\
	Если справишься с задачей, то через некоторое время я напишу тебе снова.\n\
	У меня будут дела посложнее, но и награда будет соответствующая.\n{ffff99}Задача: Перетащить "#COUNT_COMPLATE_BAGS" мешков\n\
	{33cc99}Награда: "#MONEY_QUEST_LOADER_BAGS"$, "#EXP_QUEST_LOADER_BAGS" - EXP",  

	// мешки
	""colwhi"Привет, моему коллеге требуется хороший упаковщик продуктов.\n\
	Отправляйся в цех, там ты встретишь Максима, он заведует одним из крупнейших цехов в штате. Пообщайся с ним, а там глядишь и начнёшь свой первый рабочий день.\n\
	Если будешь плотно работать, то глядишь и сертификат на жильё подгонят. Начальника найдёшь в раздевалке, он даст тебе работу.\n\
	Кординаты уже забиты в твоём навигаторе: /gps — [1]Работы — [1]Цех.\n\n\
	{ffff99}Задача: Перетащить "#COUNT_COMPLATE_FACTORY" ящиков\n\
	{33cc99}Награда: "#MONEY_QUEST_FACTORY"$, "#EXP_QUEST_FACTORY" - EXP",  

	// Фермы
	""colwhi"Здарова, слыхал про Яхт-Клуб на берегу пляжа Санта-Мария?\n\
	Там сейчас аномальный приток рыбы, просто рай для рыбака.\n\
	Так вот, в хижине, рядом с берегом, работает мой старый друг Дон.\n\
	Ты сможешь найти его неподалёку от берега, он даст тебе интересное задание, удачной ловли!\n\
	Координаты этого места уже есть в твоём навигаторе: /gps — [1]Работы — [2]Яхт-клуб.\n\
	{ffff99}Задача: Поймать "#COUNT_COMPLATE_FARM" рыб\n{33cc99}Награда: "#MONEY_QUEST_FARM"$, "#EXP_QUEST_FARM" - EXP",
   
	// права
	""colwhi"Это снова Александр, вижу, что тебе нужны водительские права.\n\
	У меня есть знакомые в местной Автошколе, они помогут сдать тебе экзамен совершенно бесплатно.\n\
	Чтобы добраться до автошколы воспользуйся автобусом или такси, если их нет — арендуй мопед.\n\
	Координаты в твоём навигаторе: /gps — [0]Важные места — [1]Автошкола.\n\
	{ffff99}Задача: Пройдите автосдачу на права (не покупая права у инструктора)\n\
	{33cc99}Награда: Бесплатная сдача на права, "#MONEY_QUEST_LICENCE_CAR"$, "#EXP_QUEST_LICENCE_CAR" - EXP",

	// магазин одежды
	""colwhi"Молодчик, теперь у тебя есть права и деньги, пора приодеться.\n\
	В каждом городе есть магазин одежды. Приедь в любой из них и найди себе что-нибудь приличное.\n\
	Координаты в твоём навигаторе: /gps — [2]Бизнесы — [4]Магазины одежды.\n\
	Не забывай использовать /gps.\n{ffff99}Задача: Купить любой скин\n{33cc99}Награда: "#MONEY_QUEST_VICTIM"$, "#EXP_QUEST_VICTIM" - EXP",

	// мэрия
	""colwhi"Войдите в Мэрии штата.\n{ffff99}Задача: Войти в мэрию (/gps - [0] Важные места - [3] Мэрия)\n\
	{33cc99}Награда: "#MONEY_QUEST_MAYOR"$ , Начальный пакет: Стартовый на 7 дней, "#EXP_QUEST_MAYOR" - EXP",

	// автобусник
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	Городу требуются водители автобуса. Отличный способ заработать на жильё и транспорт.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия\n\
	/gps — [1]Работы — [15]Стоянки автобусов.\n\
	{ffff99}Задача: Заработать "#COUNT_COMPLATE_BUS"$\n{33cc99}Награда: "#MONEY_QUEST_BUS"$, "#EXP_QUEST_BUS" - EXP",

	// такси
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	Такспопарк объявляет о наборе водителей такси. Попробуйте себя в роли таксиста и увеличьте свой доход в разы.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия;\n\
	/gps — [1]Работы — [3]Автопарк такси.\n\
	{ffff99}Задача: Обслужить "#COUNT_COMPLATE_TAXI" пассажиров\n{33cc99}Награда: "#MONEY_QUEST_TAXI"$, "#EXP_QUEST_TAXI" - EXP",

	// механик
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	В городской автопарк набирают опытных и не пьющих механиков. Работа сложная, но у вас всё получится.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия;\n\
	/gps — [1]Работы — [4]Автопарк механиков.\n\
	{ffff99}Задача: Обслужить "#COUNT_COMPLATE_MEH" авто\n{33cc99}Награда: "#MONEY_QUEST_MEH"$, "#EXP_QUEST_MEH" - EXP",

	// инкасатор
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	В государственный банк требуются инкассаторы. Работа сложная но и прибыль неплохая, отправляйтесь на собеседование.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты уже в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия;\n\
	/gps — [1]Работы — [9]Стоянки инкассаторов.\n\
	{ffff99}Задача: Провести инкассацию "#COUNT_COMPLATE_COLLECTOR" банкоматов\n{33cc99}Награда: "#MONEY_QUEST_COLLECTOR"$, "#EXP_QUEST_COLLECTOR" - EXP",

	// тренер
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	В спортзал требуются Тренеры по рукопашному бою\n\
	Отправляйтесь в спортзал и приступайте к тренировке, форму возьмете в шкафчике.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты уже в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия;\n\
	/gps — [1]Работы — [6]Спортзал.\n\
	{ffff99}Задача: Начать "#COUNT_COMPLATE_COACH" уроков\n{33cc99}Награда: "#MONEY_QUEST_COACH"$, "#EXP_QUEST_COACH" - EXP",

	// дальнобойщик
	""colwhi"Приветствую! Вас беспокоит служба занятости Redux.\n\
	Нам требуются водители для перевозки грузов. Арендуйте тягач и приступайте к грузоперевозкам, ваша заветная цель — жильё и собственный транспорт все ближе.\n\
	Ах да, перед этим подпишите документы в Мэрии(устройтесь на работу).\n\
	Координаты уже в вашем навигаторе: /gps — [0]Важные места — [3]Мэрия;\n\
	/gps — [1]Работы — [17]Дальнобойщики.\n\
	{ffff99}Задача: Перевезти "#COUNT_COMPLATE_TRUCK" грузов.\n{33cc99}Награда: "#MONEY_QUEST_TRUCK"$, "#EXP_QUEST_TRUCK" - EXP",

	// покупка дома
	""colwhi"Я удивлён, ваше трудолюбие заслуживает уважения.\n\
	Вы долго и упорно работали, что даёт вам возможность приобрести Вам собственное жильё.\n\
	{ffff99}Задача: Приобрести недвижимость\n{33cc99}Награда: "#MONEY_QUEST_HOUSE"$, "#EXP_QUEST_HOUSE" - EXP", 
	 
	// покупка тачки
	""colwhi"Вам необходим достойный транспорт, подыщите себе что-нибудь стоящее.\n\
	{ffff99}Задача: Купить транспорт в автосалоне\n{33cc99}Награда: "#MONEY_QUEST_CAR"$, "#EXP_QUEST_CAR" - EXP",

	//"QUEST_TASK_SLOT0", // свободный слот для гражданских 0
	"QUEST_TASK_SLOT1", // свободный слот для гражданских 1
	"QUEST_TASK_SLOT2", // свободный слот для гражданских 2
	"QUEST_TASK_SLOT3", // свободный слот для гражданских 3
	"QUEST_TASK_SLOT4", // свободный слот для гражданских 4
	"QUEST_TASK_SLOT5", // свободный слот для гражданских 5
	"QUEST_TASK_SLOT6", // свободный слот для гражданских 6
	"QUEST_TASK_SLOT7", // свободный слот для гражданских 7
	"QUEST_TASK_SLOT8", // свободный слот для гражданских 8
	"QUEST_TASK_SLOT9", // свободный слот для гражданских 9

	""colwhi"Создай себе оружие: Хола Амигос, сейчас проведу тебе инструктаж по первому правилу для выживания в Гетто. \n\
	Всегда нужно иметь с собой пушку, чтобы защитить себя от других бандитов. Если не ты, то тебя\n\n\
	{ffff99}Задача: Сделать "#COUNT_TASK_GUN" патрон Desert Eagle.\n\
	{33cc99}Награда: \n\
	\t - "#MONEY_TASK_GUN"$, "#EXP_TASK_GUN" - EXP\n\
	\t - "#MATERIALS_TASK_GUN" - материалов",

	""colwhi"Найди себе дурь: Отлично, вижу пушка у тебя уже есть. \n\
	Теперь чтобы выглядеть естественно нужно закупиться наркотиками в нашем местном наркопритоне,\n\
	чтобы тебя начали уважать свои. Ведь порой они устраивают вечеринки с дурью.\n\n\
	{ffff99}Задача: Купить "#COUNT_TASK_DRUGS" грамм наркоты.\n\
	{33cc99}Награда: "#MONEY_TASK_DRUGS"$, "#EXP_TASK_DRUGS" - EXP",

	""colwhi"Мои руки чисты: Теперь после основного инструктажа, пора делать грязь.\n\
	Тебе нужно вынести пару домов на территории противоположных банд.\n\n\
	{ffff99}Задача: Ограбить "#COUNT_TASK_ROBHOUSE" домов.\n\
	{33cc99}Награда: "#MONEY_TASK_ROBHOUSE"$, "#EXP_TASK_ROBHOUSE" - EXP",

	""colwhi"\"Победа и только победа!\": Отлично вижу с тебя будет толк, недавно на нас начали гнать противоположные банды,\n\
	тебе нужно показать кто тут король. Пойди и завали 5-ых человек на смертельной арене.\n\n\
	{ffff99}Задача: Выйграть "#COUNT_TASK_DUEL_5" дуэлей.\n\
	{33cc99}Награда: \n\
	\t - "#MONEY_TASK_DUEL_5"$, "#EXP_TASK_DUEL_5" - EXP\n\
	\t - "#MATERIALS_TASK_DUEL" - материалов", 

	""colwhi"\"Ключи есть, а что ещё надо?\": По нашей наводке, с нами недавно связались ребята,\n\
	которые занимаются автоугоном и познакомили нас с одним человеком, который предложил доставить\n\
	ему 10 автомобилей за каждый из них он заплатит, даже не хилой суммой g-points для нашей банды.\n\
	Бери напарников которые могут тебе помочь, только бери проверенных мало-ли это будут крысы.\n\
	Дело реально важное, возможно мы будем с ними сотрудничать дальше и нам будут капать проценты.\n\n\
	{ffff99}Задача: Угнать "#COUNT_TASK_ROB_CAR" машин.\n\
	{33cc99}Награда: "#MONEY_TASK_ROB_CAR"$, "#EXP_TASK_ROB_CAR" - EXP",

	""colwhi"\"Покажи свою силу\": Вижу ты и с этим справился, молодец.\n\
	Теперь у тебя начинается настоящая война против другой банды.\n\
	Во время этого противостояния твоя задача вылить с них 5 литров крови. Удачи!\n\n\
	{ffff99}Задача: Нанести "#COUNT_TASK_DMG_5" урона.\n\
	{33cc99}Награда: "#MONEY_TASK_DMG_5"$, "#EXP_TASK_DMG_5" - EXP",

	""colwhi"\"Заработай уважение\": Так же важной частью нахождение в банде, является то насколько\n\
	ты много зарабатываешь репутацию в виде g-points. Тебе нужно заработать 100 g-points, они помогут\n\
	твоей банде развиться, ведь это основная валюта чёрного рынка.\n\n\
	{ffff99}Задача: Заработать "#COUNT_TASK_GPOINT_100" g-points.\n\
	{33cc99}Награда: "#MONEY_TASK_GPOINT_100"$, "#EXP_TASK_GPOINT_100" - EXP",

	""colwhi"\"Дай всем знать о своей банде\": Основной частью Гетто так же являются граффити,\n\
	за их закраску твоя банда получает репутацию, после какая банда получит больше репутации \n\
	в конце недели будет вознаграждена. Это небольшая пиар компания для твоей банды.\n\n\
	{ffff99}Задача: Закрасить "#COUNT_TASK_PAINT" граффити.\n\
	{33cc99}Награда: "#MONEY_TASK_PAINT"$, "#EXP_TASK_PAINT" - EXP",

	""colwhi"\"Дикий запад\": Теперь твоя задача показать кто тут самый быстрый на диком западе,\n\
	стань инициатором 3 захватов вражеских территорий\n\n\
	{ffff99}Задача: Инициировать "#COUNT_TASK_CAPTURE" войны за территорию.\n\
	{33cc99}Награда: "#MONEY_TASK_CAPTURE"$, "#EXP_TASK_CAPTURE" - EXP",

	""colwhi"\"В чём твоя польза?\": Отлично, с тебя уже получился хороший бандит,\n\
	а вот сможешь ли ты убить 400 противников на захватах?\n\
	Возможно именно ты попадешь в топ-15 стрелков наших районов. Дерзай!\n\n\
	{ffff99}Задача: Убить "#COUNT_TASK_KILLS_400" противников.\n\
	{33cc99}Награда: \n\
	\t - "#MONEY_TASK_KILLS_400"$, "#EXP_TASK_KILLS_400" - EXP\n\
	\t - "#MATERIALS_TASK_KILLS" - материалов",  



	""colwhi"\"Сила есть, ума не надо\": Грац, теперь твоя задача принести как можно больше пользы на захвате территорий,\n\
	чтобы твоя банда могла стать королями. Помоги своей банде захватить 3 территории. Только без посторонних программ.\n\n\
	{ffff99}Задача: Захватить "#COUNT_TASK_WIN_CAPTURE" территории.\n\
	{33cc99}Награда: \n\
	\t - "#MONEY_TASK_WIN_CAPTURE"$, "#EXP_TASK_WIN_CAPTURE" - EXP\n\
	\t - "#MATERIALS_TASK_WIN_WAR" - материалов",   

	""colwhi"\"Чужой среди своих\": К нам дошла информация, что сейчас в магазине одежды 3-х городов завалялась военная форма для новобранцев,\n\
	твоя задача поехать с напарниками и забрать форму. После этого едьте на базу, берите вертолёт и разгрузите с корабля на базу LSA 300.000 материалов.\n\
	Дальше наши сами развезут эти материалы нам на базу.\n\n\
	{ffff99}Задача: Разгрузить "#COUNT_TASK_LSA_300" материалов на склад LSA.\n\
	{33cc99}Награда: "#MONEY_TASK_LSA_300"$, "#EXP_TASK_LSA_300" - EXP",

	""colwhi"\"Лидер долго не ждёт\": Слушай, у нас тут появились неприятности, помнишь я тебе говорил, что наши ребята разгрузят\n\
	материалы которые ты доставил на LSA? Так вот их поймали, теперь возьми с собой людей и доставь нам эти материалы\n\
	пока другие бандиты их не забрали. Good luck!\n\n\
	{ffff99}Задача: Выгрузить "#COUNT_TASK_MATS_250" материалов на склад банды.\n\
	{33cc99}Награда: "#MONEY_TASK_MATS_250"$, "#EXP_TASK_MATS_250" - EXP",

	""colwhi"\"Последний рывок\": Ну что же, финальное задание от меня. Недавно на меня наехал лидер противоположной банды с его шайкой,\n\
	тебе нужно будет на захвате унизить этого лидера посадив его на биту. Как выполнишь задание, на этом мы расходимся.\n\n\
	{ffff99}Задача: Убить "#COUNT_TASK_KILL_LEADER" лидера из противоположной банды битой.\n\
	{33cc99}Награда: \n\
	\t - "#MONEY_TASK_KILL_LEADER"$, "#EXP_TASK_KILL_LEADER" - EXP\n\
	\t - "#MATERIALS_TASK_KILL_LEADER" - материалов",    

  
	// MAFIA

	""colwhi"\"Первый рэкет\":{ffff99}Задача: инициировать "#COUNT_TASK_RACKET_BIZ" войну за бизнес.\n\
	{33cc99}Награда: "#MONEY_TASK_RACKET_BIZ"$, "#EXP_TASK_RACKET_BIZ" - EXP",

	""colwhi"\"Рэкет в слепую\":{ffff99}Задача: Рэкитировать "#COUNT_TASK_RACKET" рабочих.\n\
	{33cc99}Награда: "#MONEY_TASK_RACKET"$, "#EXP_TASK_RACKET" - EXP",

	""colwhi"\"Хакер\":{ffff99}Задача: Удалить из базы данных информацию о членах своей фракции "#COUNT_TASK_HACKBASE" раз.\n\
	{33cc99}Награда: "#MONEY_TASK_HACKBASE"$, "#EXP_TASK_HACKBASE" - EXP",


	""colwhi"\"Уважение\":{ffff99}Задача: Учавствовать в войне между мафиями "#COUNT_TASK_MAFIA_WAR" раз.\n\
	{33cc99}Награда: "#MONEY_TASK_MAFIA_WAR"$, "#EXP_TASK_MAFIA_WAR" - EXP",

	""colwhi"\"Азарт\":{ffff99}Задача: Поставить ставку в игре \"кости\"  на  сумму "#COUNT_TASK_MAFIA_DICE"$ + .\n\
	{33cc99}Награда: "#MONEY_TASK_MAFIA_DICE"$, "#EXP_TASK_MAFIA_DICE" - EXP",

	""colwhi"\"Убийство\":{ffff99}Задача: выследить и убить адвоката/полицейского "#COUNT_TASK_MAFIA_KILLER" раз.\n\
	{33cc99}Награда: "#MONEY_TASK_MAFIA_KILLER"$, "#EXP_TASK_MAFIA_KILLER" - EXP",

	""colwhi"\"Похищение\":{ffff99}Задача: похитеть игрока используя команду /tie "#COUNT_TASK_MAFIA_TIE" раз.\n\
	{33cc99}Награда: "#MONEY_TASK_MAFIA_TIE"$, "#EXP_TASK_MAFIA_TIE" - EXP",

	""colwhi"\"Давление\": У адвокатов есть негласное правило \"Не заниматся делами особо опасных преступников\"\n\
	Вам нужно надовить на адвоката, что бы он оправдал Вас ( выпустил из тюрьмы ).\n\n\
	{ffff99}Задача: выйти из тюрьмы.\n\
	{33cc99}Награда: "#MONEY_TASK_MAFIA_JAIL"$, "#EXP_TASK_MAFIA_JAIL" - EXP\n\
	{F0DA3C}200 H-Crystals",


	// ЗАКОН

	"{ffff99}Задача: выписать "#COUNT_TASK_PD_NEWBIE" штрафов/проверок документов.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_NEWBIE"$, "#EXP_TASK_PD_NEWBIE" - EXP",

	"{ffff99}Задача: Имя звание [2] \"офицер\" или выше арестовать "#COUNT_TASK_PD_ARREST" преступников.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_ARREST"$, "#EXP_TASK_PD_ARREST" - EXP",

	"{ffff99}Задача:  Обезвредить "#COUNT_TASK_PD_ARREST" преступников при помощи резиновых пуль.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_TAZER"$, "#EXP_TASK_PD_TAZER" - EXP",

	"{ffff99}Задача: Имея звание [4] Сержант или выше, изымите "#COUNT_TASK_PD_DRUGS" грамм наркотиков.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_DRUGS"$, "#EXP_TASK_PD_DRUGS" - EXP",

	"{ffff99}Задача: посадить "#COUNT_TASK_PD_ARREST6" человек имеющих уровень розыска 6.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_ARREST6"$, "#EXP_TASK_PD_ARREST6" - EXP",

	"{ffff99}Задача: Имея звание [5] \"Ст. Сержант\" или выше, арестуйте  "#COUNT_TASK_PD_PATRUL" человек имеющих уровень розыска 6.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_PATRUL"$, "#EXP_TASK_PD_PATRUL" - EXP",

	"{ffff99}Задача: Посадите "#COUNT_TASK_PD_GANG" бандитов или мафиози, имеющих ранг заместителя.\n\
	{33cc99}Награда: "#MONEY_TASK_PD_GANG"$, "#EXP_TASK_PD_GANG" - EXP\n\
	{F0DA3C}200 H-Crystals",

	"PD_SLOT 1",
	"PD_SLOT 2",
	"PD_SLOT 3",
	"PD_SLOT 4",
	"PD_SLOT 5",
	"PD_SLOT 6",
	"PD_SLOT 7",
	"PD_SLOT 8",
	"PD_SLOT 9",
	"PD_SLOT 10",
	"PD_SLOT 11",
	"PD_SLOT 12",
	"PD_SLOT 13",

	""colwhi"\"Стажировка\":{ffff99}Задача: находясь в FBI проведите "#COUNT_TASK_FBI_ARREST" арестов в опасном районе.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_ARREST"$, "#EXP_TASK_FBI_ARREST" - EXP",

	""colwhi"\"Поддержка безопасности\":{ffff99}Задача: Имея звание [2] \"Дежурный\" или выше, установите жучок слежения на гос. организацию.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_TIPSTER"$, "#EXP_TASK_FBI_TIPSTER" - EXP",

	""colwhi"\"Работа под прикрытием\":{ffff99}Задача: Произведите задержание "#COUNT_TASK_FBI_ARREST_GHETTO" бандитов в гетто, \
	имеющих ранг 7 или выше, будуче в маскировки.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_ARREST_GHETTO"$, "#EXP_TASK_FBI_ARREST_GHETTO" - EXP",

	""colwhi"\"Контроль оборотов II\":{ffff99}Задача: Имея ранг [4] \"Агент DEA\" или выше изъять "#COUNT_TASK_FBI_DRUGS" грамм наркотиков.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_DRUGS"$, "#EXP_TASK_FBI_DRUGS" - EXP",

	""colwhi"\"Неполноценные сотрудники\":{ffff99}Задача: Изымите наркотики у гос. сотрудника.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_TAKE"$, "#EXP_TASK_FBI_TAKE" - EXP",

	""colwhi"\"Сотрудник месяца\":{ffff99}Задача: Имея должность [5] \"Агент CID\" или выше задежите "#COUNT_TASK_FBI_PATRUL" преступников, используя /patrul.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_PATRUL"$, "#EXP_TASK_FBI_PATRUL" - EXP",

	""colwhi"\"Корпоротивная работа\":{ffff99}Задача: Имея должность [6] \"Глава DEA\" или выше задежите "#COUNT_TASK_FBI_FIND" преступников, используя /find.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_FIND"$, "#EXP_TASK_FBI_FIND" - EXP",

	""colwhi"\"Нелегальные иммигранты\":{ffff99}Задача: Арестуйте "#COUNT_TASK_FBI_ARREST_GANG" заместителей мафии.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_ARREST_GANG"$, "#EXP_TASK_FBI_ARREST_GANG" - EXP",

	""colwhi"\"Блюститель закона\":{ffff99}Задача: Имея должность [7] \"Глава CID\" или выше арестуйте лидера каждой банды.\n\
	{33cc99}Награда: "#MONEY_TASK_FBI_ARREST_LEADER"$, "#EXP_TASK_FBI_ARREST_LEADER" - EXP\n\
	{F0DA3C}200 H-Crystals",

	"FBI_SLOT 1",
	"FBI_SLOT 2",
	"FBI_SLOT 3",
	"FBI_SLOT 4",
	"FBI_SLOT 5",
	"FBI_SLOT 6",
	"FBI_SLOT 7",
	"FBI_SLOT 8",
	"FBI_SLOT 9",
	"FBI_SLOT 10",


	""colwhi"\"Начало службы\":{ffff99}Задача: Обезвредить "#COUNT_TASK_ARMY_NEWBIE" бандитов на территории армии.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_NEWBIE"$, "#EXP_TASK_ARMY_NEWBIE" - EXP",

	""colwhi"\"КМБ\":{ffff99}Задача: Получить звание [2] Ефрейтор или выше.\n\
	Прокачать скиллы Deagle и M4 до 100%.\n\
	Заправить Армейские автомобиль.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_KMB"$, "#EXP_TASK_ARMY_KMB" - EXP",

	""colwhi"\"Снайперская подготовка\":{ffff99}Задача: Находять в звании [3] \"младший Сержант\" и выше.\n\
	Расправьтесь с "#COUNT_TASK_ARMY_SNIPER" членами банд на территории армии при помощи оружия Rifle.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_SNIPER"$, "#EXP_TASK_ARMY_SNIPER" - EXP",

	""colwhi"\"Новые склады\":{ffff99}Задача: Обезвредить "#COUNT_TASK_ARMY_MP5" бандитов на территории армейских складов ЛС используюя MP5.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_MP5"$, "#EXP_TASK_ARMY_MP5" - EXP",

	""colwhi"\"Доставка\":{ffff99}Задача: Имея звание [4] \"Сержант\" и выше, разгрузите в порт ЛС "#COUNT_TASK_ARMY_UNLOAD_PORT" материалов.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_UNLOAD_PORT"$, "#EXP_TASK_ARMY_UNLOAD_PORT" - EXP",

	""colwhi"\"Пополнение арсенала\":{ffff99}Задача: Разгрузите на склад любой гос. организации "#COUNT_TASK_ARMY_UNLOAD_GOS" материалов.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_UNLOAD_GOS"$, "#EXP_TASK_ARMY_UNLOAD_GOS" - EXP",

	""colwhi"\"Придорожные мародеры\":{ffff99}Задача: Имея звание [4] \"Сержант\" и выше, обезвредить "#COUNT_TASK_ARMY_GANG" переодетых бандитов, используя Desert Eagle.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_GANG"$, "#EXP_TASK_ARMY_GANG" - EXP",

	""colwhi"\"Генеральная уборка\":{ffff99}Задача: Имея звание [7] \"Прапорщик\" и выше, обезвредить "#COUNT_TASK_ARMY_GANG_LS" бандитов в порту ЛС имеющих ранг заместителя из оружия Shotgun.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_GANG_LS"$, "#EXP_TASK_ARMY_GANG_LS" - EXP",

	""colwhi"\"Морской котик\":{ffff99}Задача: Имея звание [9] \"Лейтенант\" и выше, обезвредить "#COUNT_TASK_ARMY_GANG_NODIE" бандитов на территории любой военной базы, ни разу ни умерев.\n\
	{33cc99}Награда: "#MONEY_TASK_ARMY_GANG_NODIE"$, "#EXP_TASK_ARMY_GANG_NODIE" - EXP\n\
	{F0DA3C}200 H-Crystals"

};



static const TitleGiveMoneyQuest[QUEST_TASK_LAST][] = {
	"QUEST_GUEST > грузчик", "QUEST_GUEST > цех", 
	"QUEST_GUEST > фермы","QUEST_GUEST > права", "QUEST_GUEST > скин","QUEST_GUEST > мэрия",
	"QUEST_GUEST > автобус","QUEST_GUEST > такси","QUEST_GUEST > механик","QUEST_GUEST > инкасатор","QUEST_GUEST > тренер",
	"QUEST_GUEST > дальнобой","QUEST_GUEST > дом","QUEST_GUEST > кар", 
	"QUEST_TASK_SLOT1", // свободный слот для гражданских 1
	"QUEST_TASK_SLOT2", // свободный слот для гражданских 2
	"QUEST_TASK_SLOT3", // свободный слот для гражданских 3
	"QUEST_TASK_SLOT4", // свободный слот для гражданских 4
	"QUEST_TASK_SLOT5", // свободный слот для гражданских 5
	"QUEST_TASK_SLOT6", // свободный слот для гражданских 6
	"QUEST_TASK_SLOT7", // свободный слот для гражданских 7
	"QUEST_TASK_SLOT8", // свободный слот для гражданских 8
	"QUEST_TASK_SLOT9", // свободный слот для гражданских 9
	// GHETTO
	"QUEST_GHETTO > 1",
	"QUEST_GHETTO > 2",
	"QUEST_GHETTO > 3",
	"QUEST_GHETTO > 4",
	"QUEST_GHETTO > 5",
	"QUEST_GHETTO > 6",
	"QUEST_GHETTO > 7",
	"QUEST_GHETTO > 8",
	"QUEST_GHETTO > 9",
	"QUEST_GHETTO > 10",
	"QUEST_GHETTO > 11",
	"QUEST_GHETTO > 12",
	"QUEST_GHETTO > 13",
	"QUEST_GHETTO > 14",
	// MAFIA
	"QUEST_MAFIA > 1",
	"QUEST_MAFIA > 2",
	"QUEST_MAFIA > 3",
	"QUEST_MAFIA > 4",
	"QUEST_MAFIA > 5",
	"QUEST_MAFIA > 6",
	"QUEST_MAFIA > 7",
	"QUEST_MAFIA > 8",

	// PD
	"QUEST_PD > 1",
	"QUEST_PD > 2",
	"QUEST_PD > 3",
	"QUEST_PD > 4",
	"QUEST_PD > 5",
	"QUEST_PD > 6",
	"QUEST_PD > 7",

	"PD SLOT > 1",
	"PD SLOT > 2",
	"PD SLOT > 3",
	"PD SLOT > 4",
	"PD SLOT > 5",
	"PD SLOT > 6",
	"PD SLOT > 7",
	"PD SLOT > 8",
	"PD SLOT > 9",
	"PD SLOT > 10",
	"PD SLOT > 11",
	"PD SLOT > 12",
	"PD SLOT > 13",

	// FBI 
	"QUEST_FBI > 2",
	"QUEST_FBI > 3",
	"QUEST_FBI > 4",
	"QUEST_FBI > 5",
	"QUEST_FBI > 6",
	"QUEST_FBI > 7",
	"QUEST_FBI > 8",
	"QUEST_FBI > 9",
	"QUEST_FBI > 10",

	"FBI SLOT > 1",
	"FBI SLOT > 2",
	"FBI SLOT > 3",
	"FBI SLOT > 4",
	"FBI SLOT > 5",
	"FBI SLOT > 6",
	"FBI SLOT > 7",
	"FBI SLOT > 8",
	"FBI SLOT > 9",
	"FBI SLOT > 10",

	"ARMY SLOT > 1",
	"ARMY SLOT > 2",
	"ARMY SLOT > 3",
	"ARMY SLOT > 4",
	"ARMY SLOT > 5",
	"ARMY SLOT > 6",
	"ARMY SLOT > 7",
	"ARMY SLOT > 8",
	"ARMY SLOT > 9"
};

/*
static const QuestName[QUEST_LAST][] = {
	"Гражданский",
	"Гетто"
};*/

static const QuestNameX[QUEST_LAST][] = {
	"Дом, милый дом!",
	"Извини мама, я вырос бандитом",
	"Мафиози",
	"Полиция",
	"ФБР",
	"Армия",
	"Автошкола",
	"Байкеры",
	"МЧС"
};

static const TitleQuestMissionName[QUEST_TASK_LAST][] = {
	"Первая работа", // мешки
	"Работа не сахар", // свободный слот для гражданских 0
	"Я рыбачка, ты рыбак",// Фермы
	"Я водитель..", // права
	"Отличный прикид", // магазин одежды
	"Почти биржа", // мэрия
	"Ох, уж эти пассажиры", // автобусник
	"Знакомство с городом", // такси
	"Много машин",// механик
	"Банкир",// инкасатор
	"Я босс!",// тренер
	"Железный конь",// дальнобойщик
	"Жить на широкую ногу",// покупка дома
	"Финансовые проблемы",// покупка тачки
	
	"QUEST_TASK_SLOT1", // свободный слот для гражданских 1
	"QUEST_TASK_SLOT2", // свободный слот для гражданских 2
	"QUEST_TASK_SLOT3", // свободный слот для гражданских 3
	"QUEST_TASK_SLOT4", // свободный слот для гражданских 4
	"QUEST_TASK_SLOT5", // свободный слот для гражданских 5
	"QUEST_TASK_SLOT6", // свободный слот для гражданских 6
	"QUEST_TASK_SLOT7", // свободный слот для гражданских 7
	"QUEST_TASK_SLOT8", // свободный слот для гражданских 8
	"QUEST_TASK_SLOT9", // свободный слот для гражданских 9

	"Создай себе оружие",
	"Найди себе дурь",
	"Мои руки чисты",
	"Победа и только победа!",
	"Ключи есть, а что ещё надо?",
	"Покажи свою силу",
	"Заработай уважение",
	"Дай всем знать о своей банде",
	"Дикий запад",
	"В чём твоя польза?",
	"Сила, есть ума не надо",
	"Чужой среди своих",
	"Лидер долго не ждёт",
	"Последний рывок",

	// mafia

	"Первый рэкет",
	"Рэкет в слепую",
	"Хакер",
	"Уважение",
	"Азарт",
	"Убийство",
	"Похищение",
	"Давление",

	// PD
	"Слуга народа",
	"Дежурный офицер",
	"Промежуточное решение",
	"Контроль оборотов",
	"Без башни",
	"Патрульная служба",
	"Наркобароны",

	"PD SLOT > 1",
	"PD SLOT > 2",
	"PD SLOT > 3",
	"PD SLOT > 4",
	"PD SLOT > 5",
	"PD SLOT > 6",
	"PD SLOT > 7",
	"PD SLOT > 8",
	"PD SLOT > 9",
	"PD SLOT > 10",
	"PD SLOT > 11",
	"PD SLOT > 12",
	"PD SLOT > 13",

	// fbi
	"Стажировка",
	"Поддержка безопасности",
	"Работа под прикрытием",
	"Контроль оборотов II",
	"Неполноценные сотрудники",
	"Сотрудник месяца",
	"Корпоротивная работа",
	"Нелегальные иммигранты",
	"Блюститель закона",

	"FBI SLOT > 1",
	"FBI SLOT > 2",
	"FBI SLOT > 3",
	"FBI SLOT > 4",
	"FBI SLOT > 5",
	"FBI SLOT > 6",
	"FBI SLOT > 7",
	"FBI SLOT > 8",
	"FBI SLOT > 9",
	"FBI SLOT > 10",

	"Начало службы",
	"КМБ",
	"Снайперская подготовка",
	"Новые склады",
	"Доставка",
	"Пополнение арсенала",
	"Придорожные мародеры",
	"Генеральная уборка",
	"Морской котик"
};


stock ShowNameQuest(playerid,quest_id)
{
	new tmp_str[34], task = GetPlayerQuestTask(playerid,quest_id);
	format(tmp_str,sizeof(tmp_str),""colserver"М: %s",TitleQuestMissionName[task]);
	ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, tmp_str, TitleQuest[GetPlayerQuestTask(playerid,quest_id)] ,"Готово", "");
	return 1;
}

stock ShowNameQuestTask(playerid,quest_task)
{
	if (!(QUEST_TASK_LOADER_BAGS <= quest_task <= QUEST_TASK_LAST-1)) return 0;
	new tmp_str[34];
	format(tmp_str,sizeof(tmp_str),""colserver"М: %s",TitleQuestMissionName[quest_task]);
	ShowPlayerDialog(playerid, D_QUEST_7, DIALOG_STYLE_MSGBOX, tmp_str, TitleQuest[quest_task] ,"Готово", "");
	return 1;
}

stock CheckQuestTeam(playerid,quest_id)
{
	switch(quest_id)
	{
		case QUEST_GUEST: {
			if (pInfo[playerid][pMember] == 0 || pTemp[playerid][tDutyWork] == 0) return 1;
		}
		case QUEST_GHETTO:{
			if (IsAGang(playerid)) return 1;
		}
		case QUEST_MAFIA:{
			if (IsAMafia(playerid)) return 1;
		}
		case QUEST_PD:{
			if (IsACopQuest(playerid)) return 1;
		}
		case QUEST_FBI:{
			if (IsAFBI(playerid)) return 1;
		}
		case QUEST_ARMY:{
			if (IsAArmy(playerid)) return 1;
		}
		case QUEST_SCHOOL:{
			if (IsALicenser(playerid)) return 1;
		}
		case QUEST_BIKERS:{
			if (IsABiker(playerid)) return 1;
		}
		case QUEST_HOSPITAL:{
			if (IsAMedic(playerid)) return 1;
		}
	}
	return 0;
}



stock OnPlayerQuestProgress(playerid, select, quest_task, progress = 1)
{
	//printf("OnPlayerQuestProgress START");
	if (!(QUEST_TASK_LOADER_BAGS <= quest_task <= QUEST_TASK_LAST-1) || !CheckQuestTeam(playerid,select)) return 0;
	//printf("OnPlayerQuestProgress 1");
	if (GetPlayerQuestTask(playerid,select) != quest_task) return 0;
	//printf("OnPlayerQuestProgress 2");
	pQuest[playerid][pQuestTemp][select] += progress;

	if (pQuest[playerid][pQuestTemp][select]  >  (IsPlayerQuestProgressFinish(playerid,select))-1)
	{
		//printf("GetMoneyQuest( %d) reason %s  >> 3",GetMoneyQuest(playerid,select), TitleGiveMoneyQuest[GetPlayerQuestTask(playerid,select)]);
		kLibGivePlayerMoney(playerid, GetMoneyQuest(playerid,select), TitleGiveMoneyQuest[GetPlayerQuestTask(playerid,select)]);
		if (GetMaterialsQuest(playerid, select) != 0) {
			pInfo[playerid][pMats] += GetMaterialsQuest(playerid, select);
		}
		new exp = GetExpQuest(playerid,select);
		pQuest[playerid][pQuestTemp][select] = 0;
		pQuest[playerid][pQuestID][select]++;

		
		if (GetPlayerQuestTask(playerid,select) == QUEST_TASK_ROB_CAR){
			SendClientMessage(playerid, COLOR_GREY, !"Линия с кражей авто в разработке, Вам засчитало Quest.");
			pQuest[playerid][pQuestID][select]++;
		}
		

		if (pQuest[playerid][pQuestID][select] > QuestComplationLineMax[select][1])//QuestComplationALL[select] -1 ){
		{
		    {
			SendClientMessage(playerid, COLOR_GREY, !"Поздравляем сюжетная линия пройдена! Используйте команду /quest, чтобы выбрать новую");
			SendClientMessage(playerid, COLOR_GREY, !"Вам зачислено 30 H-Crystalss!");
				pInfo[playerid][pDonate] += 30;
				SavePlayerInteger(playerid, "u_donate", pInfo[playerid][PlayerSettings]);
			}
		}
		else ShowNameQuest(playerid,select);

		save_player_quest(playerid, 1);
		UpdatePlayerExp(playerid, exp);
	}
	//printf("OnPlayerQuestProgress 4");
	return 1;
}


CMD:quest(playerid)
{
	return ShowPlayerDialog(playerid, D_QUEST_0, DIALOG_STYLE_LIST, "Управление квестами","\
	[0] Гражданский\n\
	[1] Фракционные\n[2] Достижения","Далее","Отмена");
}


stock StatsQuestLine(playerid,quest_id)
{
	new tmp_str[240] = ""colwhi"Наименование\t"colwhi"Параметр\n";
	printf("pQuest[playerid][pQuestID][quest_id](%d) >  QuestComplationLineMax[quest_id][1] (%d)",pQuest[playerid][pQuestID][quest_id],QuestComplationLineMax[quest_id][1]);
	if (pQuest[playerid][pQuestID][quest_id] >  QuestComplationLineMax[quest_id][1])
		format(tmp_str,sizeof(tmp_str),
		"%s"colwhi"Пролог:\t"collime"Завершено\n\
		"colwhi"Миссия:\t"c_green"Выполнен\n\
		"colwhi"Статистика:\t["collime"Нет{FFFFFF}]\n\
		"colwhi"Информация",tmp_str);
	else
		format(tmp_str,sizeof(tmp_str),
		"%s"colwhi"Пролог:\t"collime"%s\n\
		"colwhi"Миссия:\t"collime"%s\n\
		"colwhi"Статистика:\t["collime"%d %%{FFFFFF}]\n\
		"colwhi"Информация",tmp_str,
		CheckQuestTeam(playerid,quest_id) == 0 ? ("["col_li_red"Не доступен"collime"]") : QuestNameX[quest_id],
		CheckQuestTeam(playerid,quest_id) == 0 ? ("["col_li_red"Не доступен"collime"]") :
		TitleQuestMissionName[GetPlayerQuestTask(playerid, quest_id)],
		((pQuest[playerid][pQuestTemp][quest_id]*100)/IsPlayerQuestProgressFinish(playerid,quest_id))
		);

	ShowPlayerDialog(playerid,D_QUEST_1,DIALOG_STYLE_TABLIST_HEADERS,"Квесты", tmp_str, !"Далее",!"Назад");
	return 1;
}

stock PathQuestLine(playerid,quest_id)
{
	new min_line = QuestComplationLineMax[quest_id][0],
		max_line = QuestComplationLineMax[quest_id][1];
	new full_str[500] = !""colwhi"Миссия\t"colwhi"Статус\n",
		tmp_str[100],
		pos,
		status = pQuest[playerid][pQuestID][quest_id];

	for(new i = min_line; i <=  max_line; i++)
	{
		format(tmp_str, sizeof(tmp_str), ""colwhi"%s\t%s\n",TitleQuestMissionName[i],

			status > pos ?  (""c_green"Выполнен"):
			CheckQuestTeam(playerid,quest_id) == 0 ? (""col_li_red"Не доступен") :
			pos == status ? (""collime"Активен"): (""col_li_red"Не выполнен")
			/*
			CheckQuestTeam(playerid,quest_id) == 0 ? (""col_li_red"Не доступен") :
			pos > status ? (""col_li_red"Не выполнен"): pos == status ? (""collime"Активен"): (""c_green"Выполнен")*/
		);
		pos++;
		strcat(full_str,tmp_str);
	}

	ShowPlayerDialog(playerid, D_QUEST_2, DIALOG_STYLE_TABLIST_HEADERS, "Квесты", full_str, !"Далее",!"Назад");
	return 1;
}

stock StatsTempQuest(playerid,quest_id)
{
	new tmp_str[180];
	if (pQuest[playerid][pQuestID][quest_id] >  QuestComplationLineMax[quest_id][1])
		format(tmp_str,sizeof(tmp_str),"\
		"colwhi"Пролог\t\t"collime"Завершено\n\
		"colwhi"Миссия:\t"c_green"Выполнен\n\
		"colwhi"Прогресс:\t"collime"Нет\n\
		"colwhi"Прогресс №2:\t"collime"Нет");
	else
		format(tmp_str,sizeof(tmp_str),"\
		"colwhi"Пролог\t\t"collime"%s\n\
		"colwhi"Миссия:\t"collime"%s\n\
		"colwhi"Прогресс:\t"collime"%d%%\n\
		"colwhi"Прогресс №2:\t"collime"%d/%d",
		QuestNameX[quest_id],
		TitleQuestMissionName[GetPlayerQuestTask(playerid, quest_id)],
		((pQuest[playerid][pQuestTemp][quest_id]*100)/(IsPlayerQuestProgressFinish(playerid,quest_id))),
		pQuest[playerid][pQuestTemp][quest_id],
		(IsPlayerQuestProgressFinish(playerid,quest_id)));

	//printf("progress %d%% (pQuestTemp = %d * 100 / %d )",
	//((pQuest[playerid][pQuestTemp][quest_id]*100)/(IsPlayerQuestProgressFinish(playerid,quest_id))),
	//pQuest[playerid][pQuestTemp][quest_id], IsPlayerQuestProgressFinish(playerid,quest_id));

	ShowPlayerDialog(playerid,D_QUEST_3,DIALOG_STYLE_MSGBOX,"Квесты", tmp_str, !"ок",!"Назад");
	return 1;
}

stock ShowQuestDialog(playerid,dialogid)
{
	switch(dialogid)
	{
		case D_QUEST_5:
		{
			static str_frac_quest[] = "Информация\nПуть\t["collime"%s{ffffff}]";
			new str_fq[sizeof(str_frac_quest) + 40];
			format(str_fq,sizeof(str_fq),str_frac_quest,

			CheckQuestTeam(playerid, QUEST_GHETTO) == 1 ?  QuestNameX[QUEST_GHETTO] :
			CheckQuestTeam(playerid, QUEST_MAFIA) == 1 ?  QuestNameX[QUEST_MAFIA] :
			CheckQuestTeam(playerid, QUEST_PD) == 1 ?  QuestNameX[QUEST_PD] :
			CheckQuestTeam(playerid, QUEST_FBI) == 1 ?  QuestNameX[QUEST_FBI] :
			CheckQuestTeam(playerid, QUEST_ARMY) == 1 ?  QuestNameX[QUEST_ARMY] :
			CheckQuestTeam(playerid, QUEST_SCHOOL) == 1 ?  QuestNameX[QUEST_SCHOOL] :
			CheckQuestTeam(playerid, QUEST_BIKERS) == 1 ?  QuestNameX[QUEST_BIKERS] :
			CheckQuestTeam(playerid, QUEST_HOSPITAL) == 1 ?  QuestNameX[QUEST_HOSPITAL] : 
			(""col_li_red"Не доступен")

			);

			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, !"Квесты > Фракции", str_fq, !"Далее", !"Назад");
		}
		case D_QUEST_6:
		{
			static str_frac_all_quest[] = "\
				Гетто\t%s\n\
				Мафия\t%s\n\
				Полиция\t%s\n\
				ФБР\t%s\n\
				Армия\t%s\n\
				Автошкола\t%s\n\
				Байкеры\t%s\n\
				МЧС\t%s"
			;

			new str_frac_all[sizeof(str_frac_all_quest) + (7*20)];

			format(str_frac_all,sizeof(str_frac_all),str_frac_all_quest,

			pQuest[playerid][pQuestID][QUEST_GHETTO] >=  QuestComplationLineMax[QUEST_GHETTO][1] ? (""c_green"Выполнен") :
			IsAGang(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_MAFIA] >=  QuestComplationLineMax[QUEST_MAFIA][1] ? (""c_green"Выполнен") :
			IsAMafia(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),
			
			pQuest[playerid][pQuestID][QUEST_PD] >=  QuestComplationLineMax[QUEST_PD][1] ? (""c_green"Выполнен") :
			IsACopQuest(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_FBI] >=  QuestComplationLineMax[QUEST_FBI][1] ? (""c_green"Выполнен") :
			IsAFBI(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_ARMY] >=  QuestComplationLineMax[QUEST_ARMY][1] ? (""c_green"Выполнен") :
			IsAArmy(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_SCHOOL] >=  QuestComplationLineMax[QUEST_SCHOOL][1] ? (""c_green"Выполнен") :
			IsALicenser(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_BIKERS] >=  QuestComplationLineMax[QUEST_BIKERS][1] ? (""c_green"Выполнен") :
			IsABiker(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен"),

			pQuest[playerid][pQuestID][QUEST_HOSPITAL] >=  QuestComplationLineMax[QUEST_HOSPITAL][1] ? (""c_green"Выполнен") :
			IsAMedic(playerid) == 1 ? (""collime"Активен") : (""col_li_red"Не доступен")

			);

			ShowPlayerDialog(playerid,dialogid,DIALOG_STYLE_TABLIST,!"Квесты > Фракции",str_frac_all,!"Далее",!"Назад");
		}
	}
	return 1;
}

stock quest_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	#pragma unused inputtext
	switch(dialogid)
	{
		case D_QUEST_0:
		{
			if (response){
				playerListItem[playerid][0] = listitem;
				if (listitem == 0)
					StatsQuestLine(playerid,QUEST_GUEST);
				else if (listitem == 1) ShowQuestDialog(playerid,D_QUEST_5);
				else if (listitem == 2) {
					ShowPlayerDialog(playerid, D_ACHIV_MENU, DIALOG_STYLE_LIST, !""colserver"Достижения", !"\
						[0] Посмотреть: {009900}Ежедневные достижения\n\
						[1] Посмотреть: {F4A900}Глобальные достижения\n\
						[2] Посмотреть: {DDB201}Достижения на работах\n\
						[3] Посмотреть: {EEDC82}Достижения во фракциях\n\
						{828282}Посмотреть лог выполненных достижений",!"Выбрать",!"Закрыть"
					);
				}
				else
					SendClientMessage(playerid, CGRAY2, !"В разработке");
			}
			return 1;
		}
		case D_QUEST_1:
		{
			if (response){
				switch(listitem)
				{
					case 0: StatsQuestLine(playerid, playerListItem[playerid][0]);
					case 1: PathQuestLine(playerid, playerListItem[playerid][0]);
					case 2: StatsTempQuest(playerid, playerListItem[playerid][0]);
					case 3: ShowNameQuest(playerid, playerListItem[playerid][0]);
					default: SendClientMessage(playerid, CGRAY2, !"В разработке");
				}
			}
			else callcmd::quest(playerid);
			return 1;
		}
		case D_QUEST_2:
		{
			if (response){
				new min_line = QuestComplationLineMax[ playerListItem[playerid][0] ][0];
				ShowNameQuestTask(playerid, min_line + listitem);
				//PathQuestLine(playerid,playerListItem[playerid][0]);
			}
			else StatsQuestLine(playerid,playerListItem[playerid][0]);
			return 1;
		}
		case D_QUEST_3:
		{
			if (response){
				StatsTempQuest(playerid,playerListItem[playerid][0]);
			}
			else StatsQuestLine(playerid,playerListItem[playerid][0]);
		}
		case D_QUEST_4:
		{
			SendClientMessage(playerid, COLOR_YELLOW, !"Используйте команду /quest, чтобы повторно посмотреть текущий квест");
			ShowNameQuest(playerid,playerListItem[playerid][0]);
		}
		case D_QUEST_5:
		{
			if (response){
				if (listitem == 0)
				{
					ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Информация",
					"{FFFFFF}Награда за прохождение квестов:\n- за каждую линию {F0DA3C}50 H-Crystals", "Готово", "");
				}
				else if (listitem == 1)
					ShowQuestDialog(playerid,D_QUEST_6);
				else SendClientMessage(playerid, CGRAY2, !"В разработке");
			}
			else callcmd::quest(playerid);
		}
		case D_QUEST_6:
		{
			if (response){
				playerListItem[playerid][0] = listitem+1;
				if (listitem < 5)
					StatsQuestLine(playerid,listitem+1);
				else SendClientMessage(playerid, CGRAY2, !"В разработке");
			}
			else callcmd::quest(playerid);
		}
		case D_QUEST_7:
		{
			if (response)
			{
				PathQuestLine(playerid,playerListItem[playerid][0]);
			}
		}
	}
	return 0;
}


stock quest_OnPlayerConnect(playerid)
{
	for(new i; i < QUEST_LAST; i++)
	{
		pQuest[playerid][pQuestID][i] = 0;
		pQuest[playerid][pQuestTemp][i] = 0;
	}
}

stock quest_OnPlayerDisconnect(playerid)
{
	save_player_quest(playerid);
}



CMD:qn(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new targetid,quest_line,quest_task;
	if (sscanf(params,"uii",targetid,quest_line,quest_task)) return SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /qn [ид игрока] [линия квеста] [задание]");
	if (!(QUEST_GUEST <= quest_line <= QUEST_LAST-1)) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верную линию квеста");
	if (!(QUEST_TASK_LOADER_BAGS <= quest_task <= QUEST_TASK_LAST-1)) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верное задание");
	pQuest[targetid][pQuestID][quest_line] =  quest_task;
	pQuest[targetid][pQuestTemp][quest_line] = 0;
	return 1;
}
CMD:qs(playerid) return ShowNameQuest(playerid,QUEST_GUEST);
CMD:qp(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new targetid,quest_line,quest_task;
	if (sscanf(params,"uii",targetid,quest_line,quest_task)) return SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /qp [ид игрока] [линия квеста] [задача] ");
	if (!(QUEST_GUEST <= quest_line <= QUEST_LAST-1)) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верную линию квеста");
	if (!(QUEST_TASK_LOADER_BAGS <= quest_task <= QUEST_TASK_LAST-1))return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верную задачу линии квеста");
	quest_task += QuestComplationLineMax[quest_line][0];
	new str_tmp[100];
	format(str_tmp,sizeof(str_tmp),"Принудительный вызов прогресса: QLine = %d, QTask = %d (%d)",quest_line,quest_task,GetPlayerQuestTask(targetid,quest_line) );
	if (OnPlayerQuestProgress(targetid, quest_line,quest_task))
		SendClientMessage(playerid, CGRAY2, str_tmp);
	else SendClientMessage(playerid, CGRAY2, !"Этому игроку не доступен данный квест");
	return 1;
}

CMD:setprog(playerid,params[])
{
	if (pInfo[playerid][pAdmin] < 6 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new targetid, quest_line,quest_task;
	if (sscanf(params,"uii",targetid,quest_line,quest_task)) return SendClientMessage(playerid,0xFFFFFFFF,!"Используйте: /setprog [ид игрока] [линия квеста] [прогресс] ");
	if (!(QUEST_GUEST <= quest_line <= QUEST_LAST-1)) return SendClientMessage(playerid, COLOR_GREY, !"Вы указали не верную линию квеста");
	new str_tmp[100];
	format(str_tmp,sizeof(str_tmp),"Вы установили: QUEST = %d, PROGRESS = %d (%d)",quest_line,quest_task,pQuest[targetid][pQuestTemp][quest_line]);
	SendClientMessage(playerid, CGRAY2, str_tmp);
	pQuest[targetid][pQuestTemp][quest_line] =  quest_task;
	return 1;
}


stock save_player_quest(playerid, type = 0)
{
	if (pInfo[playerid][pLogin] != 1 ) return 0;
	new tmp_query[128];

	if (type == 0 )
	{
		format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `pQuestTemp` = '%d,%d,%d,%d,%d,%d,%d,%d,%d' WHERE `pID` = '%d' LIMIT 1",

			pQuest[playerid][pQuestTemp][QUEST_GUEST],
			pQuest[playerid][pQuestTemp][QUEST_GHETTO],
			pQuest[playerid][pQuestTemp][QUEST_PD],
			pQuest[playerid][pQuestTemp][QUEST_FBI],
			pQuest[playerid][pQuestTemp][QUEST_MAFIA],
			pQuest[playerid][pQuestTemp][QUEST_ARMY],
			pQuest[playerid][pQuestTemp][QUEST_SCHOOL],
			pQuest[playerid][pQuestTemp][QUEST_BIKERS],
			pQuest[playerid][pQuestTemp][QUEST_HOSPITAL],
			
			pInfo[playerid][pID]
		);
	}
	else
	{

		format(tmp_query, sizeof (tmp_query),"UPDATE `s_users` SET `pQuestID` = '%d,%d,%d,%d,%d,%d,%d,%d,%d' WHERE `pID` = '%d' LIMIT 1",
			pQuest[playerid][pQuestID][QUEST_GUEST],
			pQuest[playerid][pQuestID][QUEST_GHETTO],
			pQuest[playerid][pQuestID][QUEST_PD],
			pQuest[playerid][pQuestID][QUEST_FBI],
			pQuest[playerid][pQuestID][QUEST_MAFIA],
			pQuest[playerid][pQuestID][QUEST_ARMY],
			pQuest[playerid][pQuestID][QUEST_SCHOOL],
			pQuest[playerid][pQuestID][QUEST_BIKERS],
			pQuest[playerid][pQuestID][QUEST_HOSPITAL],

			pInfo[playerid][pID]
		);
	}
    mysql_tquery(dbHandle, tmp_query, "", "");
    if (MYSQL_DEBUG) printf("CALLBACK | save_player_quest (%d) | Good", strlen(tmp_query));
	return 1;
}


stock IsACopQuest(playerid)
{
	if (!IsPlayerConnected(playerid)) return 0;
	if (pInfo[playerid][pMember] == 1 || pInfo[playerid][pMember] == 10 || pInfo[playerid][pMember] == 21) return 1; 
	return 0;
}

stock IsPlayerProgress(playerid,progressid)
{
	switch(progressid)
	{
		case QUEST_TASK_ARMY_KMB:
		{
			if (
				pInfo[playerid][pRank] > 1 &&
				pInfo[playerid][pGunSkill][1] > 99 &&
				pInfo[playerid][pGunSkill][5] > 99
			) return 1;
		}
	}
	return 0;
}
