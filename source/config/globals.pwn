#if !defined MAX_HOUSE_CLASS_NAME
    #define MAX_HOUSE_CLASS_NAME        (4)
#endif

#if !defined HOUSE_COUNT
    #define HOUSE_COUNT                  (750)
#endif

#if !defined MAX_VIP_RANK_NAME
    #define MAX_VIP_RANK_NAME        (24)
#endif

#if !defined MAX_ITEMS_SLOTS
    #define MAX_ITEMS_SLOTS        30
#endif

#if !defined MAX_SEATDOWN
    #define MAX_SEATDOWN        (300)
#endif

#if !defined STORE_LIMITS_MATERIALS
    #define STORE_LIMITS_MATERIALS        300000
#endif 	

#if !defined STORE_MAFIA_MATERIALS
    #define STORE_MAFIA_MATERIALS        200000
#endif
#if !defined STORE_GANG_MATERIALS
    #define STORE_GANG_MATERIALS        250000
#endif

#if !defined STORE_BIKERS_MATERIALS
    #define STORE_BIKERS_MATERIALS        300000
#endif 	

#if !defined CARAVAN_MATERIALS_LIMITS
    #define CARAVAN_MATERIALS_LIMITS        15000
#endif 	

#if !defined WAREHOUSE_LIMITS_DRUGS
    #define WAREHOUSE_LIMITS_DRUGS        250000
#endif 

#if !defined STORE_LIMITS_DRUGS
    #define STORE_LIMITS_DRUGS        50000
#endif 

#define RACE_RATE_MIN_MONEY		1000
#define RACE_RATE_MAX_MONEY		50000

#if !defined MAX_COUNT_POLYGON_ZONE
    #define MAX_COUNT_POLYGON_ZONE     	(60)//60
#endif 	

#if !defined INVALID_DYNAMIC_OBJECT_ID
	#define INVALID_DYNAMIC_OBJECT_ID	-1
#endif

//ALTER TABLE `s_vehicle_player` ADD `vTax` INT(11) NOT NULL DEFAULT '0' AFTER `vSellCarMarket`, ADD `vDayFine` INT(11) NOT NULL DEFAULT '0' AFTER `vTax`;
//ALTER TABLE `s_others` ADD `gPokerGame` INT(11) NOT NULL DEFAULT '0' AFTER `hellowen_Nosorry`;
enum E_SYSTEM_ACTION {
    gPokerGame,
    gCDReSpawnCar[FRACTION_COUNT],
    gCaptureOnlyDay[3],
    gAntiCBug,
    gTheftGang,
    gCaptureEveryOneHour
}

new SystemConfig[E_SYSTEM_ACTION];

