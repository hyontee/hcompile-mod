#define MAX_GUARDS 					4
#define MAX_GUARDS_SLOT 			6

enum GUARD_STRUCT
{
	GUARD_ID,
	GUARD_SKIN,
	GUARD_NAME [ 32 ],
	GUARD_TYPE,
	GUARD_LEVEL,
	GUARD_EXP,
	GUARD_HP,
	GUARD_MAX_HP,
	GUARD_ARM,
	GUARD_MAX_ARM,
	GUARD_SATIETY,
	GUARD_MAIN_STATS [ 5 ],
	GUARD_MAIN_LEVEL [ 5 ],
	GUARD_OPEN_STATS [ 6 ],
	GUARD_GUN_SKILLS [ 7 ],
	bool: GUARD_LOAD
} ;
new GUARD_INFO [ MAX_PLAYERS ] [ MAX_GUARDS ] [ GUARD_STRUCT ] ;

#define GetGuardInfo(%0,%1,%2)			GUARD_INFO[%0][%2][%1]
#define GetGuardStats(%0,%1,%2,%3)		GUARD_INFO[%0][%2][%1][%3]
#define SetGuardName(%0,%1,%2)			format(GUARD_INFO[%0][%1][GUARD_NAME], 32, "%s", %2)

new clearGuardStruct [ GUARD_STRUCT ] =
{
	0,
	0,
	"",
	0,
	0,
	0,
	0,
	0,
	0,
	0,
	0,

	/* main */
	{ 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0 },

	/* open */
	{ 0, 0, 0, 0, 0, 0 },

	/* skills */
	{ 0, 0, 0, 0, 0, 0, 0 },

	/* load */
	false
} ;