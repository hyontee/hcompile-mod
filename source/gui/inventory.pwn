#if defined _inventory_inc
	#endinput
#endif
#define _inventory_inc

#define DB_ACCOUNT_INVENTORY                        "`account_inventory`"

#define InventoryMain:%0( 		                    INV_%0(
#define InvText(InventoryMain:%0)                   #INV_%0

#define MAX_INVENTORY_PAGE_SLOTS                    (12)
#define MAX_INVENTORY_SLOTS                         (36)
#define INVALID_INVENTORY_SLOT                      (-1)
#define INVALID_INVENTORY_ITEM                      (0)
#define INVALID_DROP_ITEM_ID                        (0)

#define MAX_DROP_ITEMS                              (300)
#define MAX_DROP_ITEMS_FOR_PLAYER                   (20)


#define SetDropItemData(%0,%1,%2)                   drop_item[%0][%1] = %2
#define GetDropItemData(%0,%1)                      drop_item[%0][%1]               

#define SetPlayerInventoryStatus(%0,%1)             player_inventory_status[%0] = %1
#define GetPlayerInventoryStatus(%0)                player_inventory_status[%0]
#define SetPlayerInventoryPage(%0,%1)               player_inventory_page[%0] = %1
#define GetPlayerInventoryPage(%0)                  player_inventory_page[%0]
#define SetPlayerInventorySlotClicked(%0,%1)        player_inv_slot_clicked[%0] = %1
#define GetPlayerInventorySlotClicked(%0)           player_inv_slot_clicked[%0]
#define SetPlayerInventoryTDClicked(%0,%1)          player_inv_td_clicked[%0] = %1
#define GetPlayerInventoryTDClicked(%0)             player_inv_td_clicked[%0]
#define SetPlayerInventoryUseStatus(%0,%1)          player_inv_use_status[%0] = %1
#define GetPlayerInventoryUseStatus(%0)             player_inv_use_status[%0]

#define GetInventoryItemData(%0,%1)                 inventory_items[%0][%1]

#define GetPlayerInventoryData(%0,%1,%2)            player_inventory[%0][%1][%2]
#define SetPlayerInventoryData(%0,%1,%2,%3)         player_inventory[%0][%1][%2] = %3

enum 
{
    INV_PAGE_1, 
    INV_PAGE_2 = 12,
    INV_PAGE_3 = 24
};

enum 
{
	INDEX_SLOT_ITEMS_0 = 0,
	INDEX_SLOT_ITEMS_1,
	INDEX_SLOT_ITEMS_2,
	INDEX_SLOT_ITEMS_3,
	INDEX_SLOT_ITEMS_4,
	INDEX_SLOT_ITEMS_5,
	INDEX_SLOT_ITEMS_6,
	INDEX_SLOT_ITEMS_7,
	INDEX_SLOT_ITEMS_NULL,
	INDEX_SELL_OTHER
};
enum
{
	TYPE_ITEMS_NONE = 0,
	TYPE_ITEMS_COMMON = 1,
	TYPE_ITEMS_RARE,
	TYPE_ITEMS_MYTHICAL,
	TYPE_ITEMS_LEGENDARY,
	TYPE_ITEMS_UNIQUE,// 
	TYPE_ITEMS_ARCANA,
};
enum {
	TYPE_ITEMS_OBJECT,
	TYPE_ITEMS_SUIT
};


enum E_DROP_ITEM
{
    ITEM_ID,
    ITEM_VALUE,
    ITEM_OBJECT_ID,
    Text3D: ITEM_3DTEXT,
    ITEM_UNIX_TIME,
    Float: ITEM_X,
    Float: ITEM_Y,
    Float: ITEM_Z,
    ITEM_PLAYER_ID,
    ITEM_UNIX_TIME_DELETE,
    bool:ITEM_RAISED // проверка на поднял ли придмет. 
};
new drop_item[MAX_DROP_ITEMS][E_DROP_ITEM];

new drop_item_default[E_DROP_ITEM] = {
    INVALID_DROP_ITEM_ID,       // ITEM_ID
    0,                          // ITEM_VALUE
    INVALID_OBJECT_ID,          // ITEM_OBJECT_ID
    Text3D:INVALID_3DTEXT_ID,   // ITEM_3DTEXT
    0,                          // ITEM_UNIX_TIME
    0.0,                        // ITEM_X
    0.0,                        // ITEM_Y
    0.0,                        // ITEM_Z
    INVALID_PLAYER_ID,          // ITEM_PLAYER_ID
    0,
    false                       // ITEM_RAISED
};

enum E_INVENTORY
{
    ITEM_NAME[64],
    ITEM_INFO[128],
    ITEM_MODEL_ID,

    accesoryPrice,
	accesoryIndex,
	accesoryType,
	accesoryItemType,

    Float: ITEM_ROT_X,
    Float: ITEM_ROT_Y,
    Float: ITEM_ROT_Z,
    Float: ITEM_ROT_ZOOM
};

new inventory_items[][E_INVENTORY] = {
	// ( Название, модель ID, цена )
	{ "NONE", "NONE", 18911, 0, INDEX_SLOT_ITEMS_NULL, TYPE_ITEMS_NONE, TYPE_ITEMS_OBJECT, 0.000, 0.000, 0.000, 100.000},
	// (TYPE_ITEMS_COMMON)
	{ "Бандана с черепами", "NONE", 18911, 50000, INDEX_SLOT_ITEMS_0, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Чёрный узор\"", "NONE", 18912, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Зелёный узор\"", "NONE", 18913, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Камуфляж\"", "NONE", 18914, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Безумие\"", "NONE", 18915, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Абстракции\"", "NONE", 18916, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Молнии\"", "NONE", 18917, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Чёрный узор 2\"", "NONE", 18918, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Серый узор\"", "NONE", 18919, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Бандана \"Коноплянка\"", "NONE", 18920, 50000, INDEX_SLOT_ITEMS_0 , TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 223.000, 0.000, 333.000, 0.9240},
	{ "Армейская кепка", "NONE", 18926, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.9238},
	{ "Кепка \"Синий узор\"", "NONE", 18927, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Кислотная\"", "NONE", 18928, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Чёрный узор\"", "NONE", 18929, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Лава\"", "NONE", 18930, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Молния\"", "NONE", 18931, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Безумие\"", "NONE", 18932, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Кепка \"Серый узор\"", "NONE", 18933, 30000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Розовая кепка", "NONE", 18934, 50000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Жёлтая кепка", "NONE", 18935, 50000, INDEX_SLOT_ITEMS_1, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923},
	{ "Наушники белые", "NONE", 19421, 40000, INDEX_SLOT_ITEMS_2, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 120.000000, 0.000000, 0.000000, 1.000000},
	{ "Наушники чёрные", "NONE", 19422, 40000, INDEX_SLOT_ITEMS_2, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 120.000000, 0.000000, 0.000000, 1.000000},
	{ "Наушники розовые", "NONE", 19423, 50000, INDEX_SLOT_ITEMS_2, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 120.000000, 0.000000, 0.000000, 1.000000},
	{ "Наушники синие", "NONE", 19424, 50000, INDEX_SLOT_ITEMS_2, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 120.000000, 0.000000, 0.000000, 1.000000},
	{ "Синие спорт. очки", "NONE", 19140, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Красные спорт. очки", "NONE", 19139, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Черные очки", "NONE", 19033, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Очки \"Синяя молния\"", "NONE", 19035, 75000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Чёрные прозр. очки",  "NONE",19022, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Розовые очки", "NONE",19032, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Бежевые очки", "NONE",19031, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Зеленые авиаторы", "NONE",19029, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Жёлтые авиаторы", "NONE",19028, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Оранжевые авиаторы", "NONE",19027, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Фиолетовые авиаторы", "NONE",19024, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Красные очки", "NONE",19019, 20000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Оранжевые очки", "NONE",19018, 20000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Желтые очки", "NONE",19017, 20000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Очки \"X-RAY\"", "NONE",19016, 75000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Серые очки", "NONE",19015, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Очки в клетку", "NONE",19014, 75000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Очки \"Ясный взор\"", "NONE",19013, 35000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Серые очки", "NONE",19012, 15000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Очки \"Гипноз\"", "NONE",19011, 35000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Оранжевые очки", "NONE",19007, 50000, INDEX_SLOT_ITEMS_3, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 89.000, 0.909090}, 
	{ "Шляпа \"Лава\"", "NONE",18944, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Шляпа \"Серый узор\"", "NONE",18945, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Шляпа \"Линия\"", "NONE",18946, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Чёрная шляпа", "NONE",18947, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Синяя шляпа", "NONE",18948, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Зелёная шляпа", "NONE",18949, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Красная шляпа", "NONE",18950, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Жёлтая шляпа", "NONE",18951, 30000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 341.000, 271.000, 0.000, 0.923753}, 
	{ "Уникальная кепка \"Полицейского\"", "NONE", 18636, 100000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 142.000000, 29.000000, 123.000000, 1.465067},
	{ "Шлем \"Клакин Белл\"", "NONE", 19137, 500000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 182.000000, 190.000000, 259.000000, 1.001042},
	{ "Бандана на голову \"Оранжевая\"", "NONE", 18906, 70000, INDEX_SLOT_ITEMS_6, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},
	{ "Бандана на голову \"Хиппи\"", "NONE", 18907, 50000, INDEX_SLOT_ITEMS_6, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},
	{ "Бандана на голову \"Синия\"", "NONE", 18908, 50000, INDEX_SLOT_ITEMS_6, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},
	{ "Бандана на голову \"Перломутровая\"", "NONE", 18909, 50000, INDEX_SLOT_ITEMS_6, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},
	{ "Бандана на голову \"Красная\"", "NONE", 18910, 50000, INDEX_SLOT_ITEMS_6, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},
	{ "Часы", "NONE", 19042, 500000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19041, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19040, 150000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19039, 500000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19043, 150000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19044, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19045, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19046, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19048, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19049, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19050, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19051, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},
	{ "Часы", "NONE", 19053, 100000, INDEX_SLOT_ITEMS_7, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000, 0.000, 360.000, 0.910},

	// (TYPE_ITEMS_ARCANA)
	{ "Уникальный бумбокс \"Классический\"", "NONE", 2226, /*cost donate*/ 50_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 204.000000, 1.001042}, /* ID: 74 */
	{ "Уникальный бумбокс \"Черный\"", "NONE", 2102, /*cost donate*/  50_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 204.000000, 1.001042}, /* ID: 75 */
	{ "Уникальный бумбокс \"Белый\"", "NONE", 2103, /*cost donate*/  50_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 204.000000, 1.001042},/* ID: 76 */
	{ "Черный распиратор", "NONE", 19472, 40_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 182.000000, 190.000000, 259.000000, 1.001042},/* ID: 77 */
	

	// (TYPE_ITEMS_UNIQUE)
	{ "Гитара \"Бордовая\"", "NONE", 19319, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000, 315.000, 182.000, 0.923753}, /* ID: 78 */
	{ "Гитара \"Белая\"", "NONE", 19318, 500_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000, 315.000, 182.000, 0.923753}, /* ID: 79 */
	{ "Гитара \"Красно-Белая\"", "NONE", 19317, 750_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000, 315.000, 182.000, 0.923753}, /* ID: 80 */
	{ "Уникальный огнетушитель", "NONE", 2690, /*cost donate*/700_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 171.000000, 1.060479},/* ID: 81 */
	{ "Уникальная Катана", "NONE", 339, /*cost donate*/500_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 142.000000, 29.000000, 123.000000, 1.465067},/* ID: 82 */
	{ "Уникальный Кий", "NONE", 338, /*cost donate*/500_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 142.000000, 29.000000, 123.000000, 1.465067},/* ID: 83 */

	// (TYPE_ITEMS_LEGENDARY)
	{ "Бита с гвоздями", "NONE", 2045, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_LEGENDARY, TYPE_ITEMS_OBJECT, 90.000000, 119.000000, 0.000000, 0.929092},/* ID: 84 */
	{ "Меч", "NONE", 19590, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_LEGENDARY, TYPE_ITEMS_OBJECT, 90.000000, 119.000000, 0.000000, 1.451511},/* ID: 85 */

	// (TYPE_ITEMS_RARE)
	{ "Ковбойская шляпа \"Леопардовая\"", "NONE", 18970, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 86 */
	{ "Ковбойская шляпа \"Красно-Синия\"", "NONE", 18971, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 87 */
	{ "Ковбойская шляпа \"Персиковая\"", "NONE", 18972, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 88 */
	{ "Ковбойская шляпа \"Болотная\"", "NONE", 18973, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 89 */
	{ "Берет \"Темно-Синий\"", "NONE", 18921, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 0.000000, 90.000000, 1.00000},/* ID: 90 */
	{ "Берет \"Красный\"", "NONE", 18922, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 0.000000, 90.000000, 1.00000},/* ID: 91 */
	{ "Берет \"Синий\"", "NONE", 18923, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 0.000000, 90.000000, 1.00000},/* ID: 92 */
	{ "Берет \"Комуфляжный\"", "NONE", 18924, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 0.000000, 90.000000, 1.00000},/* ID: 93 */
	{ "Берет \"Малиновый\"", "NONE", 18925, 50_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 0.000000, 90.000000, 1.00000},/* ID: 94 */

	{ "Лом", "NONE", 18634, 100_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 95 */
	{ "Ключ \"Балонный\"", "NONE", 18633, 100_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 96 */
	{ "Молоток", "NONE", 18635, 100_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 97 */
	{ "Шляпа \"Мага\"", "NONE", 19528, 2_500_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_LEGENDARY, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 98 */
	{ "Рога", "NONE", 19314, 2_500_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 182.000000, 190.000000, 259.000000, 1.001042},/* ID: 99 */

	{ "Нимб \"Ангела\"", "NONE", 19197, 10_000_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 258.000000, 180.000000, 0.000000, 0.803962},/* ID: 100 */
	{ "Цилиндр \"Джентльмена\"", "NONE", 19352, 500_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_LEGENDARY, TYPE_ITEMS_OBJECT, 0.000000, 25.000000, 0.000000, 1.00000},  /* ID: 101 */
	{ "Удочка", "Данный предмет, доступен для рыбалки в специально отведенных места\nМожно купить в 24/7 и в магазине Рыбака", 18632, 500, INDEX_SELL_OTHER, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000}, /* ID: 102 */
	{ "Значок \"Рыбака\"", "Данный значок, возможно получить за достижение на рыбалке", 1599, 1000, INDEX_SELL_OTHER, TYPE_ITEMS_COMMON, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* 103 */
	{ "Головной убор \"Бургер\"", "NONE", 19094, 300_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 182.000000, 190.000000, 259.000000, 1.001042}, /* 104 Еще нигде не используеться*/ 
	{ "Полицейский щит", "NONE", 18637, 5_000_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 142.000000, 29.000000, 123.000000, 1.465067},/* 105 Еще нигде не используеться*/ 
	{ "Очки ночного видения", "NONE", 368, 2_000_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.000000},/* 106 Еще нигде не используеться*/ 
	{ "Хоккейная Маcка \"Белая\"", "NONE", 19036, 200_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 90.000000, 0.721063},/* ID: 107 */
	{ "Хоккейная Маcка \"Красная\"", "NONE", 19037, 200_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 90.000000, 0.721063},/* ID: 108 */
	{ "Хоккейная Маcка \"Зеленая\"", "NONE", 19038, 200_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 90.000000, 0.721063},/* ID: 109 */
	{ "Маска \"Демона\"", "NONE", 11704, 2_500_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 182.000000, 190.000000, 259.000000, 1.001042},/* ID: 110 */ 
	{ "Деревянный гроб", "NONE", 19339, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 171.000000, 1.060479},/* ID: 111 */
	{ "Череп дьявола", "NONE", 6865, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 171.000000, 1.060479},/* ID: 112 */

	{ "Воздушный шар \"Красный\"", "NONE", 19332, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 113 */
	{ "Воздушный шар \"Синий\"", "NONE", 19333, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 114 */
	{ "Воздушный шар \"Белый\"", "NONE", 19334, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 115 */
	{ "Воздушный шар \"Сине-жёлтый\"", "NONE", 19335, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 116 */
	{ "Воздушный шар \"Цветов Ф/Б/К\"", "NONE", 19336, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 117 */
	{ "Воздушный шар \"Цветов Ф/Б/З\"", "NONE", 19337, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 118 */
	{ "Воздушный шар \"Красно-зеленый\"", "NONE", 19338, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 119 */
	{ "Бензопила \"Дилдо\"", "NONE", 19086, 70_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 120 */
	{ "Попугай на плечо", "NONE", 19079, 5_000_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 90.000000, 90.000000, 0.000000, 1.000000},/* ID: 121 */
	{ "Церковный крест", "NONE", 11712, 5_000_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, -0.0000, 10.0000, 140.0000, 1.0000},/* ID: 122 */
	{ "Шапка \"Черная\"", "NONE", 18953, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 123 */
	{ "Шапка \"Серая\"", "NONE", 18954, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 341.000, 9.000, 0.000, 0.923753},/* ID: 124 */

	{ "Кепка, козыркем назад \"Молния\"", "NONE", 18939, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 125 */
	{ "Кепка, козыркем назад \"Голубо-синия\"", "NONE", 18940, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 126 */
	{ "Кепка, козыркем назад \"Черная\"", "NONE", 18941, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 127 */
	{ "Кепка, козыркем назад \"Серая\"", "NONE", 18942, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 128 */
	{ "Кепка, козыркем назад \"Зеленая\"", "NONE", 18943, 150_000, INDEX_SLOT_ITEMS_4, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 129 */

	{ "Новогодняя шапка", "NONE", 19064, 150_000, INDEX_SELL_OTHER, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 130 */
	{ "Новогодняя шапка \"С надписью Merry Xmas\"", "NONE", 19065, 150_000, INDEX_SELL_OTHER, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 131 */
	{ "Новогодняя шапка \"С надписью Happy Xmas\"", "NONE", 19066, 150_000, INDEX_SELL_OTHER, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000},/* ID: 132 */

	{ "Машинка \"RC Bandit\"", "NONE", 441, 10_500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 133 */
	{ "Самолёт \"RC Baron\"", "NONE", 464, 10_500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 134 */
	{ "Вертолёт \"RC Raider\"", "NONE", 465, 10_500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 135 */
	{ "Вертолёт \"RC Goblin\"", "NONE", 501, 10_500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 136 */
	{ "Танк \"RC Tiger\"", "NONE", 564, 10_500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 137 */
	{ "Спойлер \"Spoiler\"", "NONE", 1146, 500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_OBJECT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 138 */
	{ "Костюм \"Сосискин\"", "NONE", 19346, 500_000, INDEX_SELL_OTHER, TYPE_ITEMS_ARCANA, TYPE_ITEMS_SUIT, 333.000000, 0.000000, 27.000000, 0.337851},/* ID: 139 */
	{ "Пиццерия", "NONE", 2453, 100_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 140 */
	{ "Автомат \"АК-47\"", "NONE", 355, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 141 */
	{ "Самолётик на спину", "NONE", 2511, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 142 */	
	{ "Черепаха на спину", "NONE", 1609, 1_000_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 143 */	
	{ "Доска сёрфера", "NONE", 2406, 1_000_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 144 */	
	{ "Трость", "NONE", 326, 250_000, INDEX_SLOT_ITEMS_5, TYPE_ITEMS_RARE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 145 */	
	{ "Язык", "NONE", 888, 250_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 146 */	
	{ "Erotic в руку", "NONE", 7093, 250_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000},/* ID: 147 */
	{ "Крылья на спину", "NONE", 8492, 250_000, INDEX_SELL_OTHER, TYPE_ITEMS_UNIQUE, TYPE_ITEMS_OBJECT, 0.000000, 0.000000, 0.000000, 1.00000000}/* ID: 148 */	
	//18939 .. 18943
//

	/* - > Helloween Предметы
	TYPE_ITEMS_UNIQUE - 111, 112, 120, 122
	*/
	/* - > New year
	TYPE_ITEMS_UNIQUE - 113..119, 121, 130 .. 132
	*/
	/* - > Это можно выбить в Лавки Мики
	TYPE_ITEMS_ARCANA - 110, 109, 108, 107, 106, 105, 104, 99
	TYPE_ITEMS_LEGENDARY - 98, 85, 84,
	TYPE_ITEMS_UNIQUE - 97, 96,
	TYPE_ITEMS_RARE - 94, 93, 92, 91, 90, 89, 88, 87, 86, 
	TYPE_ITEMS_UNIQUE - 83, 82, 81, 80, 79, 78
	*/
};

#define MAX_ITEMS_COUNT	 sizeof(inventory_items)

enum E_INVENTORY_MAIN 
{
    I_ID[MAX_INVENTORY_SLOTS],
    I_ITEM[MAX_INVENTORY_SLOTS],
    I_COUNT[MAX_INVENTORY_SLOTS]
};

new player_inventory[MAX_PLAYERS][E_INVENTORY_MAIN];


new Text:Inventory_TD[63];

new 
    bool: player_inv_use_status[MAX_PLAYERS] = false,
    bool: player_inventory_status[MAX_PLAYERS] = false, // false (закрыт) | true (открыт) инвентарь
    player_inventory_page[MAX_PLAYERS] = {INV_PAGE_1, ...}, // страница инвентаря
    player_inv_slot_clicked[MAX_PLAYERS] = {-1, ...}, // выбраный слот в инвентаре
    player_inv_td_clicked[MAX_PLAYERS] = {0, ...}, // 
    PlayerText: InventorySlot_PTD[MAX_PLAYERS][12] = {PlayerText:INVALID_TEXT_DRAW, ...}, // 
    PlayerText: InventoryBar_PTD[MAX_PLAYERS][7] = {PlayerText:INVALID_TEXT_DRAW, ...},
    PlayerText: InventoryPage_PTD[MAX_PLAYERS][3] = {PlayerText:INVALID_TEXT_DRAW, ...},
    PlayerText: InventoryUse_PTD[MAX_PLAYERS][13] = {PlayerText:INVALID_TEXT_DRAW, ...};



CMD:giveinv(playerid, params[]) 
{
    if(sscanf(params, "dd", params[0], params[1])) return 1;

    InventoryMain:Giveitem(playerid, params[0], params[1]);

    return 1;
}

CMD:tdinv(playerid) 
{
   // if(pInfo[pAdmin] > 10) 
    if (!GetPlayerInventoryStatus(playerid)) InventoryMain:ShowPlayer(playerid); 
    else InventoryMain:HidePlayer(playerid);
    return 1;
}

stock InventoryMain:LoadPlayerData(playerid)
{
    mysql_format(
        dbHandle, 
        totalstring, 
        512, 
        "SELECT `item_id`, `count`, `id`, `slot_id` FROM "#DB_ACCOUNT_INVENTORY" WHERE `account_id` = '%d'", 
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(dbHandle, totalstring, InvText(InventoryMain:LoadPlayerDataDone), "d", playerid);
    totalstring[0] = EOS;
    return 1;
}

publics: InventoryMain:LoadPlayerDataDone(playerid)
{
    new rows; 

    cache_get_row_count(rows);

    for(new idx, temp_slot_id; idx != rows; idx++)
    {
        cache_get_value_name_int(idx, "slot_id", temp_slot_id);

        cache_get_value_name_int(idx, "id", GetPlayerInventoryData(playerid, I_ID, temp_slot_id));
        cache_get_value_name_int(idx, "item_id", GetPlayerInventoryData(playerid, I_ITEM, temp_slot_id));
        cache_get_value_name_int(idx, "count", GetPlayerInventoryData(playerid, I_COUNT, temp_slot_id));
    }


    return 1;
}
// ** Сохранение слота в инвентаре
stock InventoryMain:SavePlayerSlotData(playerid, slot_id)
{
    if(GetPlayerInventoryData(playerid, I_ITEM, slot_id) == 0) return 1;

    if(GetPlayerInventoryData(playerid, I_ID, slot_id) == INVALID_INVENTORY_SLOT)
    {
        mysql_format(
            dbHandle, 
            totalstring, 
            512, 
            "INSERT INTO "#DB_ACCOUNT_INVENTORY" (`account_id`, `item_id`, `count`, `slot_id`) VALUES ('%d', '%d', '%d', '%d')", 
            GetPlayerAccountID(playerid),
            GetPlayerInventoryData(playerid, I_ITEM, slot_id),
            GetPlayerInventoryData(playerid, I_COUNT, slot_id),
            slot_id
        );

        mysql_tquery(dbHandle, totalstring, InvText(InventoryMain:InsertAddItem), "dd", playerid, slot_id);
 
        totalstring[0] = EOS;

        return 1;
    }

    format(
        totalstring, sizeof totalstring, 
        "UPDATE "#DB_ACCOUNT_INVENTORY" SET `item_id` = '%d', `count` = '%d', `slot_id` = '%d' WHERE `id` = '%d'", 
        GetPlayerInventoryData(playerid, I_ITEM, slot_id),
        GetPlayerInventoryData(playerid, I_COUNT, slot_id),
        slot_id,
        GetPlayerInventoryData(playerid, I_ID, slot_id)
    );
    mysql_tquery(dbHandle, totalstring);

    totalstring[0] = EOS;

    return 1;
}

publics: InventoryMain:InsertAddItem(playerid, slot_id)
{
    SetPlayerInventoryData(playerid, I_ID, slot_id, cache_insert_id());
    return 1;
} 

stock InventoryMain:ClearPlayerData(playerid)
{
    for(new idx; idx != MAX_INVENTORY_SLOTS; idx++)
    {
        SetPlayerInventoryData(playerid, I_ID, idx, INVALID_INVENTORY_SLOT);
        SetPlayerInventoryData(playerid, I_ITEM, idx, INVALID_INVENTORY_ITEM);
        SetPlayerInventoryData(playerid, I_COUNT, idx, 0);
    }
    InventoryMain:SetUsePanelStatus(playerid, false);

    SetPlayerInventorySlotClicked(playerid, -1);
    SetPlayerInventoryStatus(playerid, false);
    SetPlayerInventoryPage(playerid, INV_PAGE_1);

    return 1;
}
// ** Меняем количество предмета в инвентаре
stock InventoryMain:SetCountItemPlayerData(playerid, slot_id, count)
{
    if(slot_id <= INVALID_INVENTORY_SLOT)
    {
        // Добавить оповещения об том что произошла ошибка инвентаря
        return 1;
    }

    new slot_count = GetPlayerInventoryData(playerid, I_COUNT, slot_id);

    SetPlayerInventoryData(playerid, I_COUNT, slot_id, slot_count + count);

    if(GetPlayerInventoryData(playerid, I_COUNT, slot_id) <= 0)
    {
        SetPlayerInventoryData(playerid, I_ITEM, slot_id, INVALID_INVENTORY_ITEM);
        SetPlayerInventoryData(playerid, I_COUNT, slot_id, 0);
    }

    InventoryMain:SavePlayerSlotData(playerid, slot_id);

    return 1;
}

// ** Узнаем слот инвентаря в котором лежит предмет
stock InventoryMain:GetItemSlotPlayerData(playerid, item_id)
{
    for(new idx; idx != MAX_INVENTORY_SLOTS; idx++)
    {
        if(GetPlayerInventoryData(playerid, I_ITEM, idx) == item_id)
        {
            return idx;
        }
    }
    return INVALID_INVENTORY_SLOT;
}

// ** Узнаем количество предмета в слоте
stock InventoryMain:GetCountItemPlayerData(playerid, slot_id)
{
    return (slot_id <= INVALID_INVENTORY_SLOT) ? 0 : GetPlayerInventoryData(playerid, I_COUNT, slot_id);
}

// ** Ищем свободный слот в инвентаре
stock InventoryMain:GetFreeSlotPlayerData(playerid)
{
    new slot_id = INVALID_INVENTORY_SLOT;

    for(new idx; idx != MAX_INVENTORY_SLOTS; idx++)
    {
        if(!GetPlayerInventoryData(playerid, I_ITEM, idx))
        {
            slot_id = idx; 
            break;
        }
    }

    return slot_id;
}

stock InventoryMain:Giveitem(playerid, item_id, count)
{
    new slot_id = INVALID_INVENTORY_SLOT;

    for(new idx; idx != MAX_INVENTORY_SLOTS; idx++)
    {
        if(GetPlayerInventoryData(playerid, I_ITEM, idx) != item_id) continue;
        slot_id = idx;
        break;
    }   
   
    if(slot_id == INVALID_INVENTORY_SLOT) slot_id = InventoryMain:GetFreeSlotPlayerData(playerid);

    new slot_count = GetPlayerInventoryData(playerid, I_COUNT, slot_id);

    SetPlayerInventoryData(playerid, I_ITEM, slot_id, item_id);
    SetPlayerInventoryData(playerid, I_COUNT, slot_id, slot_count + count);

    InventoryMain:SavePlayerSlotData(playerid, slot_id);
   // InventoryMain:SavePlayerSlotData(playerid, slot_count + count);
        
    return 1;
}

stock InventoryMain:ShowPlayer(playerid) 
{
    if (GetPlayerInventoryStatus(playerid)) return SendClientMessage(playerid, COLOR_GREY, !"У Вас уже открыт инвентарь");

    for(new i; i < sizeof Inventory_TD; i++) 
    {
        TextDrawShowForPlayer(playerid, Inventory_TD[i]);
    }

    InventoryMain:SetPage(playerid, INV_PAGE_1);
    InventoryMain:SetUpdatePlayerBar(playerid);
    SetPlayerInventoryStatus(playerid, true);
    SelectTextDraw(playerid, COLOR_SERVER);
    return 1;
}

stock InventoryMain:DestroyPlayerTD(playerid)
{
    if (!GetPlayerInventoryStatus(playerid)) return 0;

    for(new i; i < sizeof Inventory_TD; i++) 
    {
        if(i < 3) PlayerTextDrawDestroy(playerid, InventoryPage_PTD[playerid][i]);
        if(i < 7) PlayerTextDrawDestroy(playerid, InventoryBar_PTD[playerid][i]);
        if(i < 12) 
        {
            PlayerTextDrawDestroy(playerid, InventorySlot_PTD[playerid][i]);
            PlayerTextDrawDestroy(playerid, InventoryUse_PTD[playerid][i]);
        }
        TextDrawHideForPlayer(playerid, Inventory_TD[i]);
    }

    return 1;
}

stock InventoryMain:HidePlayer(playerid) 
{
    if (!GetPlayerInventoryStatus(playerid)) return false;

    InventoryMain:DestroyPlayerTD(playerid);

    SetPlayerInventoryStatus(playerid, false);

    SetPlayerInventoryUseStatus(playerid, false);

    SetPlayerInventoryPage(playerid, INV_PAGE_1);

    CancelSelectTextDraw(playerid);

    return 1;
}
stock InventoryMain:SetUpdatePlayerBar(playerid, bool: destroy = false) {
    if (destroy) {
        for(new idx = 0; idx < 7; idx++) {  
            PlayerTextDrawDestroy(playerid, InventoryBar_PTD[playerid][idx]);
        }
        return 1;
    }
    InventoryBar_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 256.600189, 146.814697, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][0], 5.000000, 76.000000);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][0], 673720575);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][0], 0); 

    InventoryBar_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 258.066589, 221.070297, "");//hp
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][1], 0.000000, 0.000000);
    new 
        Float: health = GetPlayerHP(playerid);
    if (health >= 100) {
        PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][1], 2.000000, /*-72.239997\160.0**/health*-0.45149998125); 
    }
    else {
        PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][1], 2.000000, health*-0.72239997);
    } 
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][1], 1); 
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][1], -9682689);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][1], 5);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][1], 0);
    PlayerTextDrawSetPreviewModel(playerid, InventoryBar_PTD[playerid][1], 19345);
    PlayerTextDrawSetPreviewRot(playerid, InventoryBar_PTD[playerid][1], 0.000000, 0.000000, 105.000000, 0.224000);

    InventoryBar_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 266.266906, 146.814697, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][2], 5.000000, 76.000000);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][2], 673720575);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][2], 0); 

    InventoryBar_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 267.799896, 221.070297, "");//armour
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][3], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][3], 2.000000, GetPlayer_Armour(playerid)*-0.72239997/*0.000000*/);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][3], -1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][3], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][3], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][3], 5);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][3], 0);
    PlayerTextDrawSetPreviewModel(playerid, InventoryBar_PTD[playerid][3], 19345);
    PlayerTextDrawSetPreviewRot(playerid, InventoryBar_PTD[playerid][3], 0.000000, 360.000000, 41.000000, 0.224000);

    InventoryBar_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 259.433288, 225.644500, "HP");
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][4], 0.141299, 0.708100);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][4], 2);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][4], -1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][4], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][4], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][4], 0);

    InventoryBar_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 269.599914, 225.644500, "ARM");
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][5], 0.141299, 0.708100);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][5], 2);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][5], -1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][5], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][5], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][5], 1);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][5], 1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][5], 0); 

    InventoryBar_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 251.699905, 133.314804, "");
    PlayerTextDrawLetterSize(playerid, InventoryBar_PTD[playerid][6], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryBar_PTD[playerid][6], 98.000000, 106.000000);
    PlayerTextDrawAlignment(playerid, InventoryBar_PTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, InventoryBar_PTD[playerid][6], -1);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][6], 0);
    PlayerTextDrawSetOutline(playerid, InventoryBar_PTD[playerid][6], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryBar_PTD[playerid][6], 77);
    PlayerTextDrawFont(playerid, InventoryBar_PTD[playerid][6], 5);
    PlayerTextDrawSetProportional(playerid, InventoryBar_PTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, InventoryBar_PTD[playerid][6], 0);
    new
        skin = GetPlayerSkin(playerid);
    PlayerTextDrawSetPreviewModel(playerid, InventoryBar_PTD[playerid][6], skin);
    PlayerTextDrawSetPreviewRot(playerid, InventoryBar_PTD[playerid][6], 0.000000, 0.000000, 27.000000, 1.084400);
    for(new idx = 0; idx < 7; idx++) {  
        PlayerTextDrawShow(playerid, InventoryBar_PTD[playerid][idx]);
    }
    return 1;
}

stock InventoryMain:SetPage(playerid, page, bool: destroy = false) 
{
    if (destroy)
    {
        for(new idx = 0; idx < 12; idx++) 
        {  
            if(idx < 3) PlayerTextDrawDestroy(playerid, InventoryPage_PTD[playerid][idx]);
            PlayerTextDrawDestroy(playerid, InventorySlot_PTD[playerid][idx]);
        }
        return 1;
    }

    if(GetPlayerInventoryUseStatus(playerid)) InventoryMain:SetUsePanelStatus(playerid, false); 
    

    SetPlayerInventoryPage(playerid, page);

    InventoryPage_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 391.933502, 305.074005, "LD_BEAT:chit"); // кружок 1
    PlayerTextDrawLetterSize(playerid,InventoryPage_PTD[playerid][0], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid,InventoryPage_PTD[playerid][0], 9.000000, 11.000000);
    PlayerTextDrawAlignment(playerid,InventoryPage_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid,InventoryPage_PTD[playerid][0], (page == INV_PAGE_1) ? -1368888577 : 673720575);
    PlayerTextDrawSetShadow(playerid,InventoryPage_PTD[playerid][0], 0);
    PlayerTextDrawSetOutline(playerid,InventoryPage_PTD[playerid][0], 0);
    PlayerTextDrawBackgroundColor(playerid,InventoryPage_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid,InventoryPage_PTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid,InventoryPage_PTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid,InventoryPage_PTD[playerid][0], 0);

    InventoryPage_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 403.600097, 305.074005, "LD_BEAT:chit"); // кружок 2
    PlayerTextDrawLetterSize(playerid, InventoryPage_PTD[playerid][1], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryPage_PTD[playerid][1], 9.000000, 11.000000);
    PlayerTextDrawAlignment(playerid, InventoryPage_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, InventoryPage_PTD[playerid][1], (page == INV_PAGE_2) ? -1368888577 : 673720575);
    PlayerTextDrawSetShadow(playerid, InventoryPage_PTD[playerid][1], 0);
    PlayerTextDrawSetOutline(playerid, InventoryPage_PTD[playerid][1], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryPage_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, InventoryPage_PTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, InventoryPage_PTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, InventoryPage_PTD[playerid][1], 0);

    InventoryPage_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 415.033508, 305.074005, "LD_BEAT:chit"); // кружок 3
    PlayerTextDrawLetterSize(playerid, InventoryPage_PTD[playerid][2], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, InventoryPage_PTD[playerid][2], 9.000000, 11.000000);
    PlayerTextDrawAlignment(playerid, InventoryPage_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, InventoryPage_PTD[playerid][2], (page == INV_PAGE_3) ? -1368888577 : 673720575);
    PlayerTextDrawSetShadow(playerid, InventoryPage_PTD[playerid][2], 0);
    PlayerTextDrawSetOutline(playerid, InventoryPage_PTD[playerid][2], 0);
    PlayerTextDrawBackgroundColor(playerid, InventoryPage_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, InventoryPage_PTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, InventoryPage_PTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, InventoryPage_PTD[playerid][2], 0);
    

    PlayerTextDrawShow(playerid, InventoryPage_PTD[playerid][0]);
    PlayerTextDrawShow(playerid, InventoryPage_PTD[playerid][1]);
    PlayerTextDrawShow(playerid, InventoryPage_PTD[playerid][2]);

    InventorySlot_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 361.766815, 145.744400, "");  
    InventorySlot_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 393.533294, 145.744400, "");  
    InventorySlot_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 425.299896, 145.744400, "");  
    InventorySlot_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 361.766815, 181.848403, "");  
    InventorySlot_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 393.533294, 181.848403, "");  
    InventorySlot_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 425.299896, 181.848403, "");  
    InventorySlot_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 361.766815, 218.122192, "");  
    InventorySlot_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 393.533294, 218.122192, "");  
    InventorySlot_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 425.299896, 218.122192, "");  
    InventorySlot_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 361.766815, 254.226104, "");  
    InventorySlot_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 393.533294, 254.226104, "");  
    InventorySlot_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 425.299896, 254.226104, "");

    new 
        item_slot = GetPlayerInventoryPage(playerid);

    for(new idx = 0; idx < 12; idx++) 
    { 
        PlayerTextDrawLetterSize(playerid, InventorySlot_PTD[playerid][idx], 0.000000, 0.000000);
        PlayerTextDrawTextSize(playerid, InventorySlot_PTD[playerid][idx], 28.000000, 31.000000);
        PlayerTextDrawAlignment(playerid, InventorySlot_PTD[playerid][idx], 1);
        PlayerTextDrawColor(playerid, InventorySlot_PTD[playerid][idx], -1);
        PlayerTextDrawSetShadow(playerid, InventorySlot_PTD[playerid][idx], 0);
        PlayerTextDrawSetOutline(playerid, InventorySlot_PTD[playerid][idx], 0);
        PlayerTextDrawBackgroundColor(playerid, InventorySlot_PTD[playerid][idx], 673720575);
        PlayerTextDrawFont(playerid, InventorySlot_PTD[playerid][idx], 5);
        PlayerTextDrawSetProportional(playerid, InventorySlot_PTD[playerid][idx], 0);
        PlayerTextDrawSetSelectable(playerid, InventorySlot_PTD[playerid][idx], 1);
        PlayerTextDrawSetShadow(playerid, InventorySlot_PTD[playerid][idx], 0);
        
        if(GetPlayerInventoryData(playerid, I_ITEM, item_slot))
        {
            new itemid = GetPlayerInventoryData(playerid, I_ITEM, item_slot); 
            PlayerTextDrawSetPreviewModel(playerid, InventorySlot_PTD[playerid][idx], GetInventoryItemData(itemid, ITEM_MODEL_ID));
            PlayerTextDrawSetPreviewRot(
                playerid,  
                InventorySlot_PTD[playerid][idx], 
                GetInventoryItemData(itemid, ITEM_ROT_X),
                GetInventoryItemData(itemid, ITEM_ROT_Y), 
                GetInventoryItemData(itemid, ITEM_ROT_Z), 
                GetInventoryItemData(itemid, ITEM_ROT_ZOOM)
            );
        }    
        else
        {
            PlayerTextDrawSetPreviewModel(playerid, InventorySlot_PTD[playerid][idx], 0);
            PlayerTextDrawSetPreviewRot(playerid, InventorySlot_PTD[playerid][idx], 0.000000, 0.000000, 0.000000, -1.000000);
        }
        
        PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][idx]);

        item_slot++;
    }

    return 1;
}

CMD:invtest(playerid, params[])
{
    new bool: use_panel, Float: x, Float: y, alig;
    if(sscanf(params,"dffd", use_panel, x, y, alig)) return 1;
   // InventoryMain:SetUsePanelStatus(playerid, use_panel, x, y, alig);
    SendMes(playerid, -1, "x: %f, y: %f", x, y);
    return 1;
}
CMD:invt(playerid, params[])
{
    new bool: use_panel, slot_id;
    if(sscanf(params,"dd", use_panel, slot_id)) return 1;
    InventoryMain:SetUsePanelStatus(playerid, use_panel, slot_id);
    return 1;
}

stock InventoryMain:SetUsePanelStatus(playerid, bool: panel_status, slot_id = -1)
{
    if(panel_status)
    {
        new 
            Float: td_x = 3.0, 
            Float: td_y = 0.0;

        switch(slot_id) 
        {
            case 1, 4, 7, 10: td_x = 35.0;
            case 2, 5, 8, 11: td_x = 65.0;
        }

        if(3 <= slot_id <= 5) td_y = 35.0; 
        else if(6 <= slot_id <= 8) td_y = 70.0;
        else if(9 <= slot_id <= 11) td_y = 105.0;


        InventoryUse_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 371.0000 + td_x, 163.1198 + td_y, "Box"); // пусто
        InventoryUse_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 371.0000 + td_x, 171.7997 + td_y, "LD_SPAC:white"); // пусто
        InventoryUse_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 371.0000 + td_x, 186.3596 + td_y, "LD_SPAC:white"); // пусто
        InventoryUse_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 371.0000 + td_x, 216.0395 + td_y, "LD_SPAC:white"); // кнопка close
        InventoryUse_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 370.0000 + td_x, 162.2798 + td_y, "LD_SPAC:white"); // пусто
        InventoryUse_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 369.5000 + td_x, 162.2795 + td_y, "particle:lamp_shad_64"); // пусто
        InventoryUse_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 369.5000 + td_x, 162.2795 + td_y, "particle:lamp_shad_64"); // пусто
        InventoryUse_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 380.0000 + td_x, 161.7196 + td_y, "particle:lamp_shad_64"); // пусто
        InventoryUse_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 385.0000 + td_x, 173.1996 + td_y, "USE"); // пусто
        InventoryUse_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 383.0000 + td_x, 188.3197 + td_y, "TAKE"); // пусто
        InventoryUse_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 381.5000 + td_x, 217.9994 + td_y , "CLOSE"); // пусто
        InventoryUse_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 371.0000 + td_x, 200.9196 + td_y, "LD_SPAC:white"); // кнопка drop
        InventoryUse_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 382.5000 + td_x, 202.8799 + td_y, "DROP"); // пусто

        PlayerTextDrawLetterSize(playerid, InventoryUse_PTD[playerid][0], 0.0000, 7.2998);
        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][0], 412.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][0], (slot_id == 2 || slot_id == 5 || slot_id == 8 || slot_id == 11) ? 2 : 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][0], -1);
        PlayerTextDrawUseBox(playerid, InventoryUse_PTD[playerid][0], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUse_PTD[playerid][0], 799);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][0], 1);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][0], 1);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][0], 0);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][1], 41.0000, 13.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][1], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][1], 673720575);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][1], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][1], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][1], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][1], 0);
        PlayerTextDrawSetSelectable(playerid, InventoryUse_PTD[playerid][1], true);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][2], 41.0000, 13.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][2], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][2], 673720575);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][2], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][2], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][2], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][2], 0);
        PlayerTextDrawSetSelectable(playerid, InventoryUse_PTD[playerid][2], true);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][3], 41.0000, 13.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][3], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][3], -1368888577);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][3], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][3], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][3], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][3], 0);
        PlayerTextDrawSetSelectable(playerid, InventoryUse_PTD[playerid][3], true);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][4], 43.0000, 7.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][4], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][4], -770877953);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][4], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][4], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][4], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][4], 0);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][5], 44.0000, 7.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][5], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][5], -982555905);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][5], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][5], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][5], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][5], 0);


        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][6], 44.0000, 7.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][6], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][6], -982555905);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][6], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][6], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][6], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][6], 0);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][7], 33.0000, 7.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][7], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][7], -998743553);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][7], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][7], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][7], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][7], 0);

        PlayerTextDrawLetterSize(playerid, InventoryUse_PTD[playerid][8], 0.2379, 0.9502);
        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][8], 502.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][8], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][8], -1);
        PlayerTextDrawUseBox(playerid, InventoryUse_PTD[playerid][8], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUse_PTD[playerid][8], 572661504);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][8], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][8], 1);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][8], 1);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][8], 0);

        PlayerTextDrawLetterSize(playerid, InventoryUse_PTD[playerid][9], 0.2344, 0.9222);
        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][9], 501.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][9], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][9], -1);
        PlayerTextDrawUseBox(playerid, InventoryUse_PTD[playerid][9], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUse_PTD[playerid][9], 572661504);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][9], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][9], 1);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][9], 1);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][9], 0);

        PlayerTextDrawLetterSize(playerid, InventoryUse_PTD[playerid][10], 0.2034, 0.8942);
        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][10], 410.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][10], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][10], -1);
        PlayerTextDrawUseBox(playerid, InventoryUse_PTD[playerid][10], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUse_PTD[playerid][10], 572661504);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][10], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][10], 1);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][10], 1);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][10], 0);

        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][11], 41.0000, 13.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][11], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][11], 673720575);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][11], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][11], 4);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][11], 0);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][11], 0);
        PlayerTextDrawSetSelectable(playerid, InventoryUse_PTD[playerid][11], true);

        PlayerTextDrawLetterSize(playerid, InventoryUse_PTD[playerid][12], 0.2180, 0.9447);
        PlayerTextDrawTextSize(playerid, InventoryUse_PTD[playerid][12], 413.0000, 0.0000);
        PlayerTextDrawAlignment(playerid, InventoryUse_PTD[playerid][12], 1);
        PlayerTextDrawColor(playerid, InventoryUse_PTD[playerid][12], -1);
        PlayerTextDrawUseBox(playerid, InventoryUse_PTD[playerid][12], 1);
        PlayerTextDrawBoxColor(playerid, InventoryUse_PTD[playerid][12], 572661504);
        PlayerTextDrawBackgroundColor(playerid, InventoryUse_PTD[playerid][12], 255);
        PlayerTextDrawFont(playerid, InventoryUse_PTD[playerid][12], 1);
        PlayerTextDrawSetProportional(playerid, InventoryUse_PTD[playerid][12], 1);
        PlayerTextDrawSetShadow(playerid, InventoryUse_PTD[playerid][12], 0);

        for(new idx; idx < 13; idx++) PlayerTextDrawShow(playerid, InventoryUse_PTD[playerid][idx]);
        
    }
    else if(!panel_status)
    {
        for(new idx; idx < 13; idx++) PlayerTextDrawDestroy(playerid, InventoryUse_PTD[playerid][idx]);
    
    }
    SetPlayerInventoryUseStatus(playerid, panel_status);
    return 1;
}

stock InventoryMain:UpdateSlotItem(playerid, itemid, textdrawid, value)
{
    #pragma unused value

    PlayerTextDrawHide(playerid, InventorySlot_PTD[playerid][textdrawid]);

    PlayerTextDrawBackgroundColor(playerid, InventorySlot_PTD[playerid][textdrawid], 673720575);

    if(itemid == 0)
    {
        PlayerTextDrawSetPreviewModel(playerid, InventorySlot_PTD[playerid][textdrawid], 0);
        PlayerTextDrawSetPreviewRot(playerid, InventorySlot_PTD[playerid][textdrawid], 0.000000, 0.000000, 0.000000, -1.000000);
    }
    else
    {
        PlayerTextDrawSetPreviewModel(playerid, InventorySlot_PTD[playerid][textdrawid], GetInventoryItemData(itemid, ITEM_MODEL_ID));
        PlayerTextDrawSetPreviewRot(
            playerid, InventorySlot_PTD[playerid][textdrawid], 
            GetInventoryItemData(itemid, ITEM_ROT_X),
            GetInventoryItemData(itemid, ITEM_ROT_Y), 
            GetInventoryItemData(itemid, ITEM_ROT_Z), 
            GetInventoryItemData(itemid, ITEM_ROT_ZOOM)
        );

    }

    PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][textdrawid]);
    return 1;
}



public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == Text:INVALID_TEXT_DRAW)
    {
        if(GetPlayerInventoryStatus(playerid)) return InventoryMain:HidePlayer(playerid);
    }
    if(GetPlayerInventoryStatus(playerid))
    {
        new page = GetPlayerInventoryPage(playerid);
        if(clickedid == Inventory_TD[61] && page != INV_PAGE_1) // left стрелка 
        {
            InventoryMain:SetPage(playerid, -1, .destroy = true);
            InventoryMain:SetPage(playerid, page - MAX_INVENTORY_PAGE_SLOTS);
            return 1;
        }
        if(clickedid == Inventory_TD[62] && page != INV_PAGE_3) // right стрелка 
        {
            InventoryMain:SetPage(playerid, -1, .destroy = true);
            InventoryMain:SetPage(playerid, page + MAX_INVENTORY_PAGE_SLOTS);
            return 1;
        }
        if(clickedid == Inventory_TD[38]) // gps 
        {
            InventoryMain:SetUsePanelStatus(playerid, false);
            callcmd::gps(playerid);
            return 1;
        } 
        if(clickedid == Inventory_TD[39]) // mm 
        {
            InventoryMain:SetUsePanelStatus(playerid, false);
 	        ShowPlayerDialog(playerid, D_MAINMENU_FUNC_0, DIALOG_STYLE_LIST, ""colserver"Личное меню", "[0] Настройки\n\
		        [1] Статистика персонажа\n\
		        [2] Команды сервера\n{FFFF00}[3] Задать вопрос / Отправить жалобу\n\
		        {FFFFFF}[4] Правила сервера\n[5] Сервисы\n[6] Квесты\n[7] Донат\n[8] Промокод\n[9] Бонусный код", "Выбрать", "Отмена");
            return 1;
        }   
        if(clickedid == Inventory_TD[40]) // achiev 
        {
            InventoryMain:SetUsePanelStatus(playerid, false);
            ShowPlayerDialog(playerid, D_ACHIV_MENU, DIALOG_STYLE_LIST, !""colserver"Достижения", !"\
		        [0] Посмотреть: {009900}Ежедневные достижения\n\
		        [1] Посмотреть: {F4A900}Глобальные достижения\n\
		        [2] Посмотреть: {DDB201}Достижения на работах\n\
		        [3] Посмотреть: {EEDC82}Достижения во фракциях\n\
		        {828282}Посмотреть лог выполненных достижений",!"Выбрать",!"Закрыть");
            return 1;
        }   
        if(clickedid == Inventory_TD[41]) // rep 
        {
            InventoryMain:SetUsePanelStatus(playerid, false);
            ShowPlayerDialog(playerid, D_MAINMENU_FUNC_2, DIALOG_STYLE_LIST, "Задать вопрос / Отправить жалобу","[0] Задать вопрос помощникам\n[1] Отправить жалобу", "Выбрать", "Назад");
            return 1;
        }   
        if(clickedid == Inventory_TD[42]) // donate 
        {
            InventoryMain:SetUsePanelStatus(playerid, false);
            ShowDonateMaxPidaras(playerid);
            return 1;
        }   
    }
    
    #if defined Inv_OnPlayerClickTextDraw
		return Inv_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerClickTextDraw
  #undef OnPlayerClickTextDraw
#else
  #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw Inv_OnPlayerClickTextDraw
#if  defined Inv_OnPlayerClickTextDraw
  forward Inv_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(GetPlayerInventoryStatus(playerid))
    {
        if(GetPlayerInventoryUseStatus(playerid))
        {
            new
                slot_id = GetPlayerInventorySlotClicked(playerid),
                item_id = GetPlayerInventoryData(playerid, I_ITEM, slot_id);
                //td_id = GetPlayerInventoryTDClicked(playerid);

            if(playertextid == InventoryUse_PTD[playerid][1]) // use
            {
                InventoryMain:SetUsePanelStatus(playerid, false, -1);
                InventoryMain:UseItem(playerid);
                return 1;
            }   
            if(playertextid == InventoryUse_PTD[playerid][2]) // take
            {   
                InventoryMain:SetUsePanelStatus(playerid, false, -1);
                InventoryMain:UnUseItem(playerid);
                return 1;
            }
            if(playertextid == InventoryUse_PTD[playerid][11]) // drop
            {
                InventoryMain:SetUsePanelStatus(playerid, false, -1);

                PlayerPlaySound(playerid, 6801, 0.0, 0.0, 0.0);

                SetPVarInt(playerid, "Drop:ItemID", item_id);
                SetPVarInt(playerid, "Drop:SlotID", slot_id);

                Dialog_Show(playerid, Dialog:D_ID_INV_DROP_SELECT);
                return 1;
            }
            if(playertextid == InventoryUse_PTD[playerid][3]) // close
            {
                InventoryMain:SetUsePanelStatus(playerid, false, -1);
                return 1;
            }
        }
        for(new i; i < MAX_INVENTORY_PAGE_SLOTS; i++)
        {
            if(playertextid == InventorySlot_PTD[playerid][i])
            {
                new 
                    item_slot = GetPlayerInventoryPage(playerid) + i,
                    slot_id = GetPlayerInventorySlotClicked(playerid),
                    td_id = GetPlayerInventoryTDClicked(playerid);

                if(GetPlayerInventoryData(playerid, I_ITEM, item_slot)) 
                {
                    if(!GetPlayerInventoryUseStatus(playerid)) 
                    {                     
                        PlayerTextDrawHide(playerid, InventorySlot_PTD[playerid][i]);
                        PlayerTextDrawSetSelectable(playerid, InventorySlot_PTD[playerid][i], false);
                        PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][i]);
                
                        InventoryMain:SetUsePanelStatus(playerid, true, i);
                    }
                    else 
                    {
                        InventoryMain:SetUsePanelStatus(playerid, false); 
                    }
                }
                else
                {
                    if(GetPlayerInventoryUseStatus(playerid)) InventoryMain:SetUsePanelStatus(playerid, false);
                }
    
                if(slot_id != -1)
                {
                    if(GetPlayerInventoryData(playerid, I_ITEM, item_slot))
                    {
                        new 
                            item_id = GetPlayerInventoryData(playerid, I_ITEM, item_slot),
                            item_count = GetPlayerInventoryData(playerid, I_COUNT, item_slot);

                        SetPlayerInventoryData(playerid, I_ITEM, item_slot, GetPlayerInventoryData(playerid, I_ITEM, slot_id));
                        SetPlayerInventoryData(playerid, I_COUNT, item_slot, GetPlayerInventoryData(playerid, I_COUNT, slot_id));

                        SetPlayerInventoryData(playerid, I_ITEM, slot_id, item_id);
                        SetPlayerInventoryData(playerid, I_COUNT, slot_id, item_count);
                        

                        InventoryMain:UpdateSlotItem(playerid, GetPlayerInventoryData(playerid, I_ITEM, item_slot), i, GetPlayerInventoryData(playerid, I_COUNT, item_slot));

                        if(GetPVarInt(playerid, "Inventory:Page") == GetPlayerInventoryPage(playerid))
                        {
                            InventoryMain:UpdateSlotItem(playerid, item_id, td_id, item_count);
                        }
                    }
                    else if(slot_id != item_slot)
                    {
                        
                        format(
                            totalstring,
                            144,
                            "DELETE FROM "#DB_ACCOUNT_INVENTORY" WHERE `id` = '%d'",
                            GetPlayerInventoryData(playerid, I_ID, slot_id)
                        );

                        mysql_tquery(dbHandle, totalstring);

                        totalstring[0] = EOS;
                        
                        SetPlayerInventoryData(playerid, I_ITEM, item_slot, GetPlayerInventoryData(playerid, I_ITEM, slot_id));
                        SetPlayerInventoryData(playerid, I_COUNT, item_slot, GetPlayerInventoryData(playerid, I_COUNT, slot_id));


                        SetPlayerInventoryData(playerid, I_ID, slot_id, INVALID_INVENTORY_SLOT);
                        SetPlayerInventoryData(playerid, I_ITEM, slot_id, 0);
                        SetPlayerInventoryData(playerid, I_COUNT, slot_id, 0);

                        InventoryMain:UpdateSlotItem(playerid, GetPlayerInventoryData(playerid, I_ITEM, item_slot), i, GetPlayerInventoryData(playerid, I_COUNT, item_slot));
                        if(td_id != i && GetPVarInt(playerid, "Inventory:Page") == GetPlayerInventoryPage(playerid))
                        {
                            PlayerTextDrawHide(playerid, InventorySlot_PTD[playerid][td_id]);
                            PlayerTextDrawSetSelectable(playerid, InventorySlot_PTD[playerid][td_id], true);
                            PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][td_id]);

                            InventoryMain:UpdateSlotItem(playerid, GetPlayerInventoryData(playerid, I_ITEM, slot_id), td_id, GetPlayerInventoryData(playerid, I_COUNT, slot_id));
                        }
                    }
                    else
                    {

                        PlayerTextDrawHide(playerid, InventorySlot_PTD[playerid][i]);
                        PlayerTextDrawBackgroundColor(playerid, InventorySlot_PTD[playerid][i], 673720575);
                        PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][i]);
                    }

                    SetPlayerInventorySlotClicked(playerid, -1);

                    // Добавить функцию отключения use panel 

                    InventoryMain:SavePlayerSlotData(playerid, slot_id);
                    InventoryMain:SavePlayerSlotData(playerid, item_slot);
                        
                    break;
                }
                if(GetPlayerInventoryData(playerid, I_ITEM, item_slot))
                {
                    SetPlayerInventorySlotClicked(playerid, item_slot);
                    SetPlayerInventoryTDClicked(playerid, i);

                    SetPVarInt(playerid, "Inventory:Page", GetPlayerInventoryPage(playerid));
                    
                    PlayerTextDrawHide(playerid, InventorySlot_PTD[playerid][i]);
                    PlayerTextDrawBackgroundColor(playerid, InventorySlot_PTD[playerid][i], COLOR_SERVER);
                    PlayerTextDrawShow(playerid, InventorySlot_PTD[playerid][i]);
                

                    break;
                }
                return 1;
            }
        }
    }


    #if defined Inv_OnPlayerClickPlayerTD
		return Inv_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerClickPlayerTextDra
  #undef OnPlayerClickPlayerTextDraw
#else
  #define _ALS_OnPlayerClickPlayerTextDra
#endif
#define OnPlayerClickPlayerTextDraw Inv_OnPlayerClickPlayerTD
#if  defined Inv_OnPlayerClickPlayerTD
  forward Inv_OnPlayerClickPlayerTD(playerid, PlayerText:playertextid);
#endif

/*public OnPlayerConnect(playerid)
{
    InventoryMain:LoadPlayerData(playerid);
    #if defined Inv_OnPlayerConnect
		return Inv_OnPlayerConnect(playerid);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
  #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Inv_OnPlayerConnect
#if  defined Inv_OnPlayerConnect
  forward Inv_OnPlayerConnect(playerid);
#endif*/

/*public OnPlayerDisconnect(playerid, reason)
{
    InventoryMain:ClearIdDropItems(playerid);
    #if defined Inv_OnPlayerDisconnect
		return Inv_OnPlayerDisconnect(playerid, reason);
	#else
		return 1;
	#endif
}

#if defined _ALS_OnPlayerDisconnect
  #undef OnPlayerDisconnect
#else
  #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Inv_OnPlayerDisconnect
#if  defined Inv_OnPlayerDisconnect
  forward Inv_OnPlayerDisconnect(playerid, reason);
#endif*/

public OnGameModeInit()
{
    for(new i; i < MAX_DROP_ITEMS; i++)
    {   
        drop_item[i] = drop_item_default; 
    }

    Inventory_TD[0] = TextDrawCreate(198.366302, 108.096099, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[0], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[0], 15.000000, 18.000000);
    TextDrawAlignment(Inventory_TD[0], 1);
    TextDrawColor(Inventory_TD[0], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[0], 0);
    TextDrawSetOutline(Inventory_TD[0], 0);
    TextDrawBackgroundColor(Inventory_TD[0], 255);
    TextDrawFont(Inventory_TD[0], 4);
    TextDrawSetProportional(Inventory_TD[0], 0);
    TextDrawSetShadow(Inventory_TD[0], 0);

    Inventory_TD[1] = TextDrawCreate(205.699600, 110.914497, "LD_SPAC:white");
    TextDrawLetterSize(Inventory_TD[1], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[1], 249.000000, 11.000000);
    TextDrawAlignment(Inventory_TD[1], 1);
    TextDrawColor(Inventory_TD[1], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[1], 0);
    TextDrawSetOutline(Inventory_TD[1], 0);
    TextDrawBackgroundColor(Inventory_TD[1], 255);
    TextDrawFont(Inventory_TD[1], 4);
    TextDrawSetProportional(Inventory_TD[1], 0);
    TextDrawSetShadow(Inventory_TD[1], 0);
    TextDrawSetSelectable(Inventory_TD[1], true);

    Inventory_TD[2] = TextDrawCreate(447.933197, 108.096099, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[2], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[2], 15.000000, 18.000000);
    TextDrawAlignment(Inventory_TD[2], 1);
    TextDrawColor(Inventory_TD[2], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[2], 0);
    TextDrawSetOutline(Inventory_TD[2], 0);
    TextDrawBackgroundColor(Inventory_TD[2], 255);
    TextDrawFont(Inventory_TD[2], 4);
    TextDrawSetProportional(Inventory_TD[2], 0);
    TextDrawSetShadow(Inventory_TD[2], 0);

    Inventory_TD[3] = TextDrawCreate(200.766403, 117.051803, "LD_SPAC:white");
    TextDrawLetterSize(Inventory_TD[3], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[3], 259.849700, 11.000000);
    TextDrawAlignment(Inventory_TD[3], 1);
    TextDrawColor(Inventory_TD[3], 421075455);
    TextDrawSetShadow(Inventory_TD[3], 0);
    TextDrawSetOutline(Inventory_TD[3], 0);
    TextDrawBackgroundColor(Inventory_TD[3], 255);
    TextDrawFont(Inventory_TD[3], 4);
    TextDrawSetProportional(Inventory_TD[3], 0);
    TextDrawSetShadow(Inventory_TD[3], 0);
    TextDrawSetSelectable(Inventory_TD[3], true);

    Inventory_TD[4] = TextDrawCreate(200.732803, 120.740600, "LD_SPAC:white");
    TextDrawLetterSize(Inventory_TD[4], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[4], 259.859802, 1.000000);
    TextDrawAlignment(Inventory_TD[4], 1);
    TextDrawColor(Inventory_TD[4], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[4], 0);
    TextDrawSetOutline(Inventory_TD[4], 0);
    TextDrawBackgroundColor(Inventory_TD[4], 255);
    TextDrawFont(Inventory_TD[4], 4);
    TextDrawSetProportional(Inventory_TD[4], 0);
    TextDrawSetShadow(Inventory_TD[4], 0);
    TextDrawSetSelectable(Inventory_TD[4], true);

    Inventory_TD[5] = TextDrawCreate(223.133300, 130.996200, "Box");
    TextDrawLetterSize(Inventory_TD[5], 0.000000, 22.231300);
    TextDrawTextSize(Inventory_TD[5], 0.000000, 42.000000);
    TextDrawAlignment(Inventory_TD[5], 2);
    TextDrawColor(Inventory_TD[5], -1);
    TextDrawUseBox(Inventory_TD[5], 1);
    TextDrawBoxColor(Inventory_TD[5], 505290495);
    TextDrawSetShadow(Inventory_TD[5], 0);
    TextDrawSetOutline(Inventory_TD[5], 0);
    TextDrawBackgroundColor(Inventory_TD[5], 255);
    TextDrawFont(Inventory_TD[5], 1);
    TextDrawSetProportional(Inventory_TD[5], 1);
    TextDrawSetShadow(Inventory_TD[5], 0);

    Inventory_TD[6] = TextDrawCreate(300.365905, 130.996200, "Box");
    TextDrawLetterSize(Inventory_TD[6], 0.000000, 22.233900);
    TextDrawTextSize(Inventory_TD[6], 0.000000, 103.000000);
    TextDrawAlignment(Inventory_TD[6], 2);
    TextDrawColor(Inventory_TD[6], -1);
    TextDrawUseBox(Inventory_TD[6], 1);
    TextDrawBoxColor(Inventory_TD[6], 505290495);
    TextDrawSetShadow(Inventory_TD[6], 0);
    TextDrawSetOutline(Inventory_TD[6], 0);
    TextDrawBackgroundColor(Inventory_TD[6], 255);
    TextDrawFont(Inventory_TD[6], 1);
    TextDrawSetProportional(Inventory_TD[6], 1);
    TextDrawSetShadow(Inventory_TD[6], 0);

    Inventory_TD[7] = TextDrawCreate(407.732604, 130.996200, "Box");
    TextDrawLetterSize(Inventory_TD[7], 0.000000, 22.240600);
    TextDrawTextSize(Inventory_TD[7], 0.000000, 103.000000);
    TextDrawAlignment(Inventory_TD[7], 2);
    TextDrawColor(Inventory_TD[7], -1);
    TextDrawUseBox(Inventory_TD[7], 1);
    TextDrawBoxColor(Inventory_TD[7], 505290495);
    TextDrawSetShadow(Inventory_TD[7], 0);
    TextDrawSetOutline(Inventory_TD[7], 0);
    TextDrawBackgroundColor(Inventory_TD[7], 255);
    TextDrawFont(Inventory_TD[7], 1);
    TextDrawSetProportional(Inventory_TD[7], 1);
    TextDrawSetShadow(Inventory_TD[7], 0);



    Inventory_TD[9] = TextDrawCreate(251.833206, 140.837005, "");
    TextDrawLetterSize(Inventory_TD[9], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[9], 98.000000, -7.000000);
    TextDrawAlignment(Inventory_TD[9], 1);
    TextDrawColor(Inventory_TD[9], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[9], 0);
    TextDrawSetOutline(Inventory_TD[9], 0);
    TextDrawBackgroundColor(Inventory_TD[9], 255);
    TextDrawFont(Inventory_TD[9], 5);
    TextDrawSetProportional(Inventory_TD[9], 0);
    TextDrawSetShadow(Inventory_TD[9], 0);
    TextDrawSetPreviewModel(Inventory_TD[9], 19345);
    TextDrawSetPreviewRot(Inventory_TD[9], 0.000000, 0.000000, 105.000000, 0.224000);

    Inventory_TD[10] = TextDrawCreate(300.665893, 253.781402, "Box");
    TextDrawLetterSize(Inventory_TD[10], 0.000000, 8.067199);
    TextDrawTextSize(Inventory_TD[10], 0.000000, 95.000000);
    TextDrawAlignment(Inventory_TD[10], 2);
    TextDrawColor(Inventory_TD[10], -1);
    TextDrawUseBox(Inventory_TD[10], 1);
    TextDrawBoxColor(Inventory_TD[10], 76);
    TextDrawSetShadow(Inventory_TD[10], 0);
    TextDrawSetOutline(Inventory_TD[10], 0);
    TextDrawBackgroundColor(Inventory_TD[10], 255);
    TextDrawFont(Inventory_TD[10], 1);
    TextDrawSetProportional(Inventory_TD[10], 1);
    TextDrawSetShadow(Inventory_TD[10], 0);

    Inventory_TD[11] = TextDrawCreate(251.733306, 251.436904, "");
    TextDrawLetterSize(Inventory_TD[11], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[11], 98.000000, -7.000000);
    TextDrawAlignment(Inventory_TD[11], 1);
    TextDrawColor(Inventory_TD[11], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[11], 0);
    TextDrawSetOutline(Inventory_TD[11], 0);
    TextDrawBackgroundColor(Inventory_TD[11], 255);
    TextDrawFont(Inventory_TD[11], 5);
    TextDrawSetProportional(Inventory_TD[11], 0);
    TextDrawSetShadow(Inventory_TD[11], 0);
    TextDrawSetPreviewModel(Inventory_TD[11], 19345);
    TextDrawSetPreviewRot(Inventory_TD[11], 0.000000, 0.000000, 105.000000, 0.224000);
    
    Inventory_TD[12] = TextDrawCreate(254.800003, 256.544403, "");
    TextDrawLetterSize(Inventory_TD[12], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[12], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[12], 1);
    TextDrawColor(Inventory_TD[12], -1);
    TextDrawSetShadow(Inventory_TD[12], 0);
    TextDrawSetOutline(Inventory_TD[12], 0);
    TextDrawBackgroundColor(Inventory_TD[12], 673720575);
    TextDrawFont(Inventory_TD[12], 5);
    TextDrawSetProportional(Inventory_TD[12], 0);
    TextDrawSetShadow(Inventory_TD[12], 0);
    TextDrawSetPreviewModel(Inventory_TD[12], 0);
    TextDrawSetPreviewRot(Inventory_TD[12], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[13] = TextDrawCreate(286.566497, 256.544403, "");
    TextDrawLetterSize(Inventory_TD[13], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[13], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[13], 1);
    TextDrawColor(Inventory_TD[13], -1);
    TextDrawSetShadow(Inventory_TD[13], 0);
    TextDrawSetOutline(Inventory_TD[13], 0);
    TextDrawBackgroundColor(Inventory_TD[13], 673720575);
    TextDrawFont(Inventory_TD[13], 5);
    TextDrawSetProportional(Inventory_TD[13], 0);
    TextDrawSetShadow(Inventory_TD[13], 0);
    TextDrawSetPreviewModel(Inventory_TD[13], 18631);
    TextDrawSetPreviewRot(Inventory_TD[13], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[14] = TextDrawCreate(318.333099, 256.544403, "");
    TextDrawLetterSize(Inventory_TD[14], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[14], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[14], 1);
    TextDrawColor(Inventory_TD[14], -1);
    TextDrawSetShadow(Inventory_TD[14], 0);
    TextDrawSetOutline(Inventory_TD[14], 0);
    TextDrawBackgroundColor(Inventory_TD[14], 673720575);
    TextDrawFont(Inventory_TD[14], 5);
    TextDrawSetProportional(Inventory_TD[14], 0);
    TextDrawSetShadow(Inventory_TD[14], 0);
    TextDrawSetPreviewModel(Inventory_TD[14], 0);
    TextDrawSetPreviewRot(Inventory_TD[14], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[15] = TextDrawCreate(254.800003, 292.648193, "");
    TextDrawLetterSize(Inventory_TD[15], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[15], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[15], 1);
    TextDrawColor(Inventory_TD[15], -1);
    TextDrawSetShadow(Inventory_TD[15], 0);
    TextDrawSetOutline(Inventory_TD[15], 0);
    TextDrawBackgroundColor(Inventory_TD[15], 673720575);
    TextDrawFont(Inventory_TD[15], 5);
    TextDrawSetProportional(Inventory_TD[15], 0);
    TextDrawSetShadow(Inventory_TD[15], 0);
    TextDrawSetPreviewModel(Inventory_TD[15], 0);
    TextDrawSetPreviewRot(Inventory_TD[15], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[16] = TextDrawCreate(286.566497, 292.648193, "");
    TextDrawLetterSize(Inventory_TD[16], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[16], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[16], 1);
    TextDrawColor(Inventory_TD[16], -1);
    TextDrawSetShadow(Inventory_TD[16], 0);
    TextDrawSetOutline(Inventory_TD[16], 0);
    TextDrawBackgroundColor(Inventory_TD[16], 673720575);
    TextDrawFont(Inventory_TD[16], 5);
    TextDrawSetProportional(Inventory_TD[16], 0);
    TextDrawSetShadow(Inventory_TD[16], 0);
    TextDrawSetPreviewModel(Inventory_TD[16], 0);
    TextDrawSetPreviewRot(Inventory_TD[16], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[17] = TextDrawCreate(318.333099, 292.648193, "");
    TextDrawLetterSize(Inventory_TD[17], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[17], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[17], 1);
    TextDrawColor(Inventory_TD[17], -1);
    TextDrawSetShadow(Inventory_TD[17], 0);
    TextDrawSetOutline(Inventory_TD[17], 0);
    TextDrawBackgroundColor(Inventory_TD[17], 673720575);
    TextDrawFont(Inventory_TD[17], 5);
    TextDrawSetProportional(Inventory_TD[17], 0);
    TextDrawSetShadow(Inventory_TD[17], 0);
    TextDrawSetPreviewModel(Inventory_TD[17], 0);
    TextDrawSetPreviewRot(Inventory_TD[17], 0.000000, 0.000000, 0.000000, -1.000000);

    Inventory_TD[18] = TextDrawCreate(266.366607, 134.329605, "PLAYER");
    TextDrawLetterSize(Inventory_TD[18], 0.128000, 0.596000);
    TextDrawAlignment(Inventory_TD[18], 2);
    TextDrawColor(Inventory_TD[18], -1);
    TextDrawSetShadow(Inventory_TD[18], 0);
    TextDrawSetOutline(Inventory_TD[18], -1);
    TextDrawBackgroundColor(Inventory_TD[18], 5);
    TextDrawFont(Inventory_TD[18], 1);
    TextDrawSetProportional(Inventory_TD[18], 1);
    TextDrawSetShadow(Inventory_TD[18], 0);

    Inventory_TD[19] = TextDrawCreate(267.366607, 245.085205, "AKCECCYAP");
    TextDrawLetterSize(Inventory_TD[19], 0.128000, 0.596000);
    TextDrawAlignment(Inventory_TD[19], 2);
    TextDrawColor(Inventory_TD[19], -1);
    TextDrawSetShadow(Inventory_TD[19], 0);
    TextDrawSetOutline(Inventory_TD[19], -1);
    TextDrawBackgroundColor(Inventory_TD[19], 5);
    TextDrawFont(Inventory_TD[19], 1);
    TextDrawSetProportional(Inventory_TD[19], 1);
    TextDrawSetShadow(Inventory_TD[19], 0);

    Inventory_TD[20] = TextDrawCreate(407.699310, 134.873901, "Box");
    TextDrawLetterSize(Inventory_TD[20], 0.000000, 17.067300);
    TextDrawTextSize(Inventory_TD[20], 0.000000, 95.000000);
    TextDrawAlignment(Inventory_TD[20], 2);
    TextDrawColor(Inventory_TD[20], -1);
    TextDrawUseBox(Inventory_TD[20], 1);
    TextDrawBoxColor(Inventory_TD[20], 76);
    TextDrawSetShadow(Inventory_TD[20], 0);
    TextDrawSetOutline(Inventory_TD[20], 0);
    TextDrawBackgroundColor(Inventory_TD[20], 255);
    TextDrawFont(Inventory_TD[20], 1);
    TextDrawSetProportional(Inventory_TD[20], 1);
    TextDrawSetShadow(Inventory_TD[20], 0);

    Inventory_TD[21] = TextDrawCreate(358.700103, 140.637100, "");
    TextDrawLetterSize(Inventory_TD[21], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[21], 98.000000, -7.000000);
    TextDrawAlignment(Inventory_TD[21], 1);
    TextDrawColor(Inventory_TD[21], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[21], 0);
    TextDrawSetOutline(Inventory_TD[21], 0);
    TextDrawBackgroundColor(Inventory_TD[21], 255);
    TextDrawFont(Inventory_TD[21], 5);
    TextDrawSetProportional(Inventory_TD[21], 0);
    TextDrawSetShadow(Inventory_TD[21], 0);
    TextDrawSetPreviewModel(Inventory_TD[21], 19345);
    TextDrawSetPreviewRot(Inventory_TD[21], 0.000000, 0.000000, 105.000000, 0.224000);

    /**/

    Inventory_TD[34] = TextDrawCreate(362.366607, 134.414703, "НЕНАР");
    TextDrawLetterSize(Inventory_TD[34], 0.128000, 0.596000);
    TextDrawAlignment(Inventory_TD[34], 1);
    TextDrawColor(Inventory_TD[34], -1);
    TextDrawSetShadow(Inventory_TD[34], 0);
    TextDrawSetOutline(Inventory_TD[34], -1);
    TextDrawBackgroundColor(Inventory_TD[34], 5);
    TextDrawFont(Inventory_TD[34], 1);
    TextDrawSetProportional(Inventory_TD[34], 1);
    TextDrawSetShadow(Inventory_TD[34], 0);

    Inventory_TD[35] = TextDrawCreate(223.132705, 134.873901, "Box");
    TextDrawLetterSize(Inventory_TD[35], 0.000000, 21.276300);
    TextDrawTextSize(Inventory_TD[35], 0.000000, 35.000000);
    TextDrawAlignment(Inventory_TD[35], 2);
    TextDrawColor(Inventory_TD[35], -1);
    TextDrawUseBox(Inventory_TD[35], 1);
    TextDrawBoxColor(Inventory_TD[35], 76);
    TextDrawSetShadow(Inventory_TD[35], 0);
    TextDrawSetOutline(Inventory_TD[35], 0);
    TextDrawBackgroundColor(Inventory_TD[35], 255);
    TextDrawFont(Inventory_TD[35], 1);
    TextDrawSetProportional(Inventory_TD[35], 1);
    TextDrawSetShadow(Inventory_TD[35], 0);

    Inventory_TD[36] = TextDrawCreate(204.566802, 140.637100, "");
    TextDrawLetterSize(Inventory_TD[36], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[36], 37.610000, -7.000000);
    TextDrawAlignment(Inventory_TD[36], 1);
    TextDrawColor(Inventory_TD[36], COLOR_SERVER);
    TextDrawSetShadow(Inventory_TD[36], 0);
    TextDrawSetOutline(Inventory_TD[36], 0);
    TextDrawBackgroundColor(Inventory_TD[36], 255);
    TextDrawFont(Inventory_TD[36], 5);
    TextDrawSetProportional(Inventory_TD[36], 0);
    TextDrawSetShadow(Inventory_TD[36], 0);
    TextDrawSetPreviewModel(Inventory_TD[36], 19345);
    TextDrawSetPreviewRot(Inventory_TD[36], 0.000000, 0.000000, 105.000000, 0.224000);

    Inventory_TD[37] = TextDrawCreate(207.733306, 134.414703, "Sections");
    TextDrawLetterSize(Inventory_TD[37], 0.128000, 0.596000);
    TextDrawAlignment(Inventory_TD[37], 1);
    TextDrawColor(Inventory_TD[37], -1);
    TextDrawSetShadow(Inventory_TD[37], 0);
    TextDrawSetOutline(Inventory_TD[37], -1);
    TextDrawBackgroundColor(Inventory_TD[37], 5);
    TextDrawFont(Inventory_TD[37], 1);
    TextDrawSetProportional(Inventory_TD[37], 1);
    TextDrawSetShadow(Inventory_TD[37], 0);

    Inventory_TD[38] = TextDrawCreate(207.866592, 146.677703, "LD_SPAC:white"); //GPS
    TextDrawLetterSize(Inventory_TD[38], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[38], 31.000000, 31.509799);
    TextDrawAlignment(Inventory_TD[38], 1);
    TextDrawColor(Inventory_TD[38], 673720575);
    TextDrawSetShadow(Inventory_TD[38], 0);
    TextDrawSetOutline(Inventory_TD[38], 0);
    TextDrawBackgroundColor(Inventory_TD[38], 255);
    TextDrawFont(Inventory_TD[38], 4);
    TextDrawSetProportional(Inventory_TD[38], 0);
    TextDrawSetShadow(Inventory_TD[38], 0);
    TextDrawSetSelectable(Inventory_TD[38], true);

    Inventory_TD[39] = TextDrawCreate(207.866592, 182.610900, "LD_SPAC:white");//MM
    TextDrawLetterSize(Inventory_TD[39], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[39], 31.000000, 31.509799);
    TextDrawAlignment(Inventory_TD[39], 1);
    TextDrawColor(Inventory_TD[39], 673720575);
    TextDrawSetShadow(Inventory_TD[39], 0);
    TextDrawSetOutline(Inventory_TD[39], 0);
    TextDrawBackgroundColor(Inventory_TD[39], 255);
    TextDrawFont(Inventory_TD[39], 4);
    TextDrawSetProportional(Inventory_TD[39], 0);
    TextDrawSetShadow(Inventory_TD[39], 0);
    TextDrawSetSelectable(Inventory_TD[39], true);

    Inventory_TD[40] = TextDrawCreate(207.866592, 218.588500, "LD_SPAC:white");//Achiv
    TextDrawLetterSize(Inventory_TD[40], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[40], 31.000000, 31.509799);
    TextDrawAlignment(Inventory_TD[40], 1);
    TextDrawColor(Inventory_TD[40], 673720575);
    TextDrawSetShadow(Inventory_TD[40], 0);
    TextDrawSetOutline(Inventory_TD[40], 0);
    TextDrawBackgroundColor(Inventory_TD[40], 255);
    TextDrawFont(Inventory_TD[40], 4);
    TextDrawSetProportional(Inventory_TD[40], 0);
    TextDrawSetShadow(Inventory_TD[40], 0);
    TextDrawSetSelectable(Inventory_TD[40], true);

    Inventory_TD[41] = TextDrawCreate(207.866592, 254.651306, "LD_SPAC:white");//Report
    TextDrawLetterSize(Inventory_TD[41], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[41], 31.000000, 31.509799);
    TextDrawAlignment(Inventory_TD[41], 1);
    TextDrawColor(Inventory_TD[41], 673720575);
    TextDrawSetShadow(Inventory_TD[41], 0);
    TextDrawSetOutline(Inventory_TD[41], 0);
    TextDrawBackgroundColor(Inventory_TD[41], 255);
    TextDrawFont(Inventory_TD[41], 4);
    TextDrawSetProportional(Inventory_TD[41], 0);
    TextDrawSetShadow(Inventory_TD[41], 0);
    TextDrawSetSelectable(Inventory_TD[41], true);

    Inventory_TD[42] = TextDrawCreate(207.866592, 290.999603, "LD_SPAC:white");//Donate
    TextDrawLetterSize(Inventory_TD[42], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[42], 31.000000, 31.509799);
    TextDrawAlignment(Inventory_TD[42], 1);
    TextDrawColor(Inventory_TD[42], 673720575);
    TextDrawSetShadow(Inventory_TD[42], 0);
    TextDrawSetOutline(Inventory_TD[42], 0);
    TextDrawBackgroundColor(Inventory_TD[42], 255);
    TextDrawFont(Inventory_TD[42], 4);
    TextDrawSetProportional(Inventory_TD[42], 0);
    TextDrawSetShadow(Inventory_TD[42], 0);
    TextDrawSetSelectable(Inventory_TD[42], true);

    Inventory_TD[43] = TextDrawCreate(218.866500, 169.525405, "");
    TextDrawLetterSize(Inventory_TD[43], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[43], 8.000000, -18.000000);
    TextDrawAlignment(Inventory_TD[43], 1);
    TextDrawColor(Inventory_TD[43], -1);
    TextDrawSetShadow(Inventory_TD[43], 0);
    TextDrawSetOutline(Inventory_TD[43], 0);
    TextDrawBackgroundColor(Inventory_TD[43], 0);
    TextDrawFont(Inventory_TD[43], 5);
    TextDrawSetProportional(Inventory_TD[43], 0);
    TextDrawSetShadow(Inventory_TD[43], 0);
    TextDrawSetPreviewModel(Inventory_TD[43], 19177);
    TextDrawSetPreviewRot(Inventory_TD[43], 337.000000, 0.000000, 0.000000, 0.182400);

    Inventory_TD[44] = TextDrawCreate(219.433105, 151.181304, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[44], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[44], 7.000000, 9.000000);
    TextDrawAlignment(Inventory_TD[44], 1);
    TextDrawColor(Inventory_TD[44], 673720575);
    TextDrawSetShadow(Inventory_TD[44], 0);
    TextDrawSetOutline(Inventory_TD[44], 0);
    TextDrawBackgroundColor(Inventory_TD[44], 255);
    TextDrawFont(Inventory_TD[44], 4);
    TextDrawSetProportional(Inventory_TD[44], 0);
    TextDrawSetShadow(Inventory_TD[44], 0);

    Inventory_TD[45] = TextDrawCreate(223.000000, 164.381301, "GPS");
    TextDrawLetterSize(Inventory_TD[45], 0.231900, 1.085600);
    TextDrawAlignment(Inventory_TD[45], 2);
    TextDrawColor(Inventory_TD[45], -1);
    TextDrawSetShadow(Inventory_TD[45], 0);
    TextDrawSetOutline(Inventory_TD[45], 0);
    TextDrawBackgroundColor(Inventory_TD[45], 255);
    TextDrawFont(Inventory_TD[45], 1);
    TextDrawSetProportional(Inventory_TD[45], 1);
    TextDrawSetShadow(Inventory_TD[45], 0);

    Inventory_TD[46] = TextDrawCreate(223.000000, 199.640701, "MM");
    TextDrawLetterSize(Inventory_TD[46], 0.231900, 1.085600);
    TextDrawAlignment(Inventory_TD[46], 2);
    TextDrawColor(Inventory_TD[46], -1);
    TextDrawSetShadow(Inventory_TD[46], 0);
    TextDrawSetOutline(Inventory_TD[46], 0);
    TextDrawBackgroundColor(Inventory_TD[46], 255);
    TextDrawFont(Inventory_TD[46], 1);
    TextDrawSetProportional(Inventory_TD[46], 1);
    TextDrawSetShadow(Inventory_TD[46], 0);

    Inventory_TD[47] = TextDrawCreate(223.600006, 184.077804, "::");
    TextDrawLetterSize(Inventory_TD[47], 0.411500, 1.931800);
    TextDrawAlignment(Inventory_TD[47], 2);
    TextDrawColor(Inventory_TD[47], -1);
    TextDrawSetShadow(Inventory_TD[47], 0);
    TextDrawSetOutline(Inventory_TD[47], 0);
    TextDrawBackgroundColor(Inventory_TD[47], 255);
    TextDrawFont(Inventory_TD[47], 2);
    TextDrawSetProportional(Inventory_TD[47], 1);
    TextDrawSetShadow(Inventory_TD[47], 0);

    Inventory_TD[48] = TextDrawCreate(223.300003, 236.729705, "ACHIEV");
    TextDrawLetterSize(Inventory_TD[48], 0.173800, 0.923699);
    TextDrawAlignment(Inventory_TD[48], 2);
    TextDrawColor(Inventory_TD[48], -1);
    TextDrawSetShadow(Inventory_TD[48], 0);
    TextDrawSetOutline(Inventory_TD[48], 0);
    TextDrawBackgroundColor(Inventory_TD[48], 255);
    TextDrawFont(Inventory_TD[48], 1);
    TextDrawSetProportional(Inventory_TD[48], 1);
    TextDrawSetShadow(Inventory_TD[48], 0);

    Inventory_TD[49] = TextDrawCreate(220.033203, 239.014404, "");
    TextDrawLetterSize(Inventory_TD[49], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[49], 6.000000, -14.000000);
    TextDrawAlignment(Inventory_TD[49], 1);
    TextDrawColor(Inventory_TD[49], -1);
    TextDrawSetShadow(Inventory_TD[49], 0);
    TextDrawSetOutline(Inventory_TD[49], 0);
    TextDrawBackgroundColor(Inventory_TD[49], 0);
    TextDrawFont(Inventory_TD[49], 5);
    TextDrawSetProportional(Inventory_TD[49], 0);
    TextDrawSetShadow(Inventory_TD[49], 0);
    TextDrawSetPreviewModel(Inventory_TD[49], 19177);
    TextDrawSetPreviewRot(Inventory_TD[49], 153.000000, 0.000000, 0.000000, 0.182400);

    Inventory_TD[50] = TextDrawCreate(219.766204, 224.777404, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[50], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[50], 7.000000, 8.000000);
    TextDrawAlignment(Inventory_TD[50], 1);
    TextDrawColor(Inventory_TD[50], -1);
    TextDrawSetShadow(Inventory_TD[50], 0);
    TextDrawSetOutline(Inventory_TD[50], 0);
    TextDrawBackgroundColor(Inventory_TD[50], 255);
    TextDrawFont(Inventory_TD[50], 4);
    TextDrawSetProportional(Inventory_TD[50], 0);
    TextDrawSetShadow(Inventory_TD[50], 0);

    Inventory_TD[51] = TextDrawCreate(226.599792, 221.466705, "+");
    TextDrawLetterSize(Inventory_TD[51], 0.148000, 0.670700);
    TextDrawAlignment(Inventory_TD[51], 2);
    TextDrawColor(Inventory_TD[51], -1);
    TextDrawSetShadow(Inventory_TD[51], 0);
    TextDrawSetOutline(Inventory_TD[51], 0);
    TextDrawBackgroundColor(Inventory_TD[51], 255);
    TextDrawFont(Inventory_TD[51], 1);
    TextDrawSetProportional(Inventory_TD[51], 1);
    TextDrawSetShadow(Inventory_TD[51], 0);

    Inventory_TD[52] = TextDrawCreate(223.300003, 272.518707, "REPORT");
    TextDrawLetterSize(Inventory_TD[52], 0.173800, 0.923699);
    TextDrawAlignment(Inventory_TD[52], 2);
    TextDrawColor(Inventory_TD[52], -1);
    TextDrawSetShadow(Inventory_TD[52], 0);
    TextDrawSetOutline(Inventory_TD[52], 0);
    TextDrawBackgroundColor(Inventory_TD[52], 255);
    TextDrawFont(Inventory_TD[52], 1);
    TextDrawSetProportional(Inventory_TD[52], 1);
    TextDrawSetShadow(Inventory_TD[52], 0);

    Inventory_TD[53] = TextDrawCreate(220.033203, 274.803405, "");
    TextDrawLetterSize(Inventory_TD[53], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[53], 6.000000, -14.000000);
    TextDrawAlignment(Inventory_TD[53], 1);
    TextDrawColor(Inventory_TD[53], -1);
    TextDrawSetShadow(Inventory_TD[53], 0);
    TextDrawSetOutline(Inventory_TD[53], 0);
    TextDrawBackgroundColor(Inventory_TD[53], 0);
    TextDrawFont(Inventory_TD[53], 5);
    TextDrawSetProportional(Inventory_TD[53], 0);
    TextDrawSetShadow(Inventory_TD[53], 0);
    TextDrawSetPreviewModel(Inventory_TD[53], 19177);
    TextDrawSetPreviewRot(Inventory_TD[53], 153.000000, 0.000000, 0.000000, 0.182400);

    Inventory_TD[54] = TextDrawCreate(219.766204, 260.566406, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[54], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[54], 7.000000, 8.000000);
    TextDrawAlignment(Inventory_TD[54], 1);
    TextDrawColor(Inventory_TD[54], -1);
    TextDrawSetShadow(Inventory_TD[54], 0);
    TextDrawSetOutline(Inventory_TD[54], 0);
    TextDrawBackgroundColor(Inventory_TD[54], 255);
    TextDrawFont(Inventory_TD[54], 4);
    TextDrawSetProportional(Inventory_TD[54], 0);
    TextDrawSetShadow(Inventory_TD[54], 0);

    Inventory_TD[55] = TextDrawCreate(227.266601, 261.803710, ")");
    TextDrawLetterSize(Inventory_TD[55], 0.191300, 0.521300);
    TextDrawAlignment(Inventory_TD[55], 2);
    TextDrawColor(Inventory_TD[55], -1);
    TextDrawSetShadow(Inventory_TD[55], 0);
    TextDrawSetOutline(Inventory_TD[55], 0);
    TextDrawBackgroundColor(Inventory_TD[55], 255);
    TextDrawFont(Inventory_TD[55], 1);
    TextDrawSetProportional(Inventory_TD[55], 1);
    TextDrawSetShadow(Inventory_TD[55], 0);

    Inventory_TD[56] = TextDrawCreate(228.933303, 260.329498, ")");
    TextDrawLetterSize(Inventory_TD[56], 0.221300, 0.770200);
    TextDrawAlignment(Inventory_TD[56], 2);
    TextDrawColor(Inventory_TD[56], -1);
    TextDrawSetShadow(Inventory_TD[56], 0);
    TextDrawSetOutline(Inventory_TD[56], 0);
    TextDrawBackgroundColor(Inventory_TD[56], 255);
    TextDrawFont(Inventory_TD[56], 1);
    TextDrawSetProportional(Inventory_TD[56], 1);
    TextDrawSetShadow(Inventory_TD[56], 0);

    Inventory_TD[57] = TextDrawCreate(223.300003, 308.792694, "DONATE");
    TextDrawLetterSize(Inventory_TD[57], 0.173800, 0.923699);
    TextDrawAlignment(Inventory_TD[57], 2);
    TextDrawColor(Inventory_TD[57], -1);
    TextDrawSetShadow(Inventory_TD[57], 0);
    TextDrawSetOutline(Inventory_TD[57], 0);
    TextDrawBackgroundColor(Inventory_TD[57], 255);
    TextDrawFont(Inventory_TD[57], 1);
    TextDrawSetProportional(Inventory_TD[57], 1);
    TextDrawSetShadow(Inventory_TD[57], 0);

    Inventory_TD[58] = TextDrawCreate(216.432907, 296.570007, "LD_BEAT:chit");
    TextDrawLetterSize(Inventory_TD[58], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[58], 11.000000, 13.000000);
    TextDrawAlignment(Inventory_TD[58], 1);
    TextDrawColor(Inventory_TD[58], -1);
    TextDrawSetShadow(Inventory_TD[58], 0);
    TextDrawSetOutline(Inventory_TD[58], 0);
    TextDrawBackgroundColor(Inventory_TD[58], 255);
    TextDrawFont(Inventory_TD[58], 4);
    TextDrawSetProportional(Inventory_TD[58], 0);
    TextDrawSetShadow(Inventory_TD[58], 0);

    Inventory_TD[59] = TextDrawCreate(227.666503, 295.588806, ")");
    TextDrawLetterSize(Inventory_TD[59], 0.566600, 1.317800);
    TextDrawAlignment(Inventory_TD[59], 2);
    TextDrawColor(Inventory_TD[59], -1);
    TextDrawSetShadow(Inventory_TD[59], 0);
    TextDrawSetOutline(Inventory_TD[59], 0);
    TextDrawBackgroundColor(Inventory_TD[59], 255);
    TextDrawFont(Inventory_TD[59], 1);
    TextDrawSetProportional(Inventory_TD[59], 1);
    TextDrawSetShadow(Inventory_TD[59], 0);

    Inventory_TD[60] = TextDrawCreate(222.233200, 298.451812, "$");
    TextDrawLetterSize(Inventory_TD[60], 0.245600, 0.919700);
    TextDrawAlignment(Inventory_TD[60], 2);
    TextDrawColor(Inventory_TD[60], 673720575);
    TextDrawSetShadow(Inventory_TD[60], 0);
    TextDrawSetOutline(Inventory_TD[60], 0);
    TextDrawBackgroundColor(Inventory_TD[60], 255);
    TextDrawFont(Inventory_TD[60], 1);
    TextDrawSetProportional(Inventory_TD[60], 1);
    TextDrawSetShadow(Inventory_TD[60], 0);

    Inventory_TD[61] = TextDrawCreate(368.700012, 302.395904, ""); // left стрелка
    TextDrawLetterSize(Inventory_TD[61], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[61], 17.000000, 18.000000);
    TextDrawAlignment(Inventory_TD[61], 1);
    TextDrawColor(Inventory_TD[61], -1);
    TextDrawSetShadow(Inventory_TD[61], 0);
    TextDrawSetOutline(Inventory_TD[61], 0);
    TextDrawBackgroundColor(Inventory_TD[61], 76);
    TextDrawFont(Inventory_TD[61], 5);
    TextDrawSetProportional(Inventory_TD[61], 0);
    TextDrawSetShadow(Inventory_TD[61], 0);
    TextDrawSetPreviewModel(Inventory_TD[61], 19177);
    TextDrawSetPreviewRot(Inventory_TD[61], 90.000000, 75.000000, 90.000000, 0.208399);
    TextDrawSetSelectable(Inventory_TD[61], true);

    Inventory_TD[62] = TextDrawCreate(431.700012, 302.395904, ""); // right стрелка
    TextDrawLetterSize(Inventory_TD[62], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[62], 17.000000, 18.000000);
    TextDrawAlignment(Inventory_TD[62], 1);
    TextDrawColor(Inventory_TD[62], -1);
    TextDrawSetShadow(Inventory_TD[62], 0);
    TextDrawSetOutline(Inventory_TD[62], 0);
    TextDrawBackgroundColor(Inventory_TD[62], 76);
    TextDrawFont(Inventory_TD[62], 5);
    TextDrawSetProportional(Inventory_TD[62], 0);
    TextDrawSetShadow(Inventory_TD[62], 0);
    TextDrawSetPreviewModel(Inventory_TD[62], 19177);
    TextDrawSetPreviewRot(Inventory_TD[62], 90.000000, 283.000000, 90.000000, 0.208399);
    TextDrawSetSelectable(Inventory_TD[62], true);


    /*
    Inventory_TD[66] = TextDrawCreate(318.033294, 204.192504, "");
    TextDrawLetterSize(Inventory_TD[66], 0.000000, 0.000000);
    TextDrawTextSize(Inventory_TD[66], 28.000000, 31.000000);
    TextDrawAlignment(Inventory_TD[66], 1);
    TextDrawColor(Inventory_TD[66], -1);
    TextDrawSetShadow(Inventory_TD[66], 0);
    TextDrawSetOutline(Inventory_TD[66], 0);
    TextDrawBackgroundColor(Inventory_TD[66], 673720575);
    TextDrawFont(Inventory_TD[66], 5);
    TextDrawSetProportional(Inventory_TD[66], 0);
    TextDrawSetShadow(Inventory_TD[66], 0);
    TextDrawSetPreviewModel(Inventory_TD[66], 18631);
    TextDrawSetPreviewRot(Inventory_TD[66], 0.000000, 0.000000, 0.000000, 0.813300);*/


    #if defined Inv_OnGameModeInit
		return Inv_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
  #undef OnGameModeInit
#else
  #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Inv_OnGameModeInit
#if  defined Inv_OnGameModeInit
  forward Inv_OnGameModeInit();
#endif

stock InventoryMain:GetAcsessoryItem(itemid)
{
    switch(itemid)
    {
        case 1 .. 141: return true;
    }
    return 0;
}


stock InventoryMain:UseItem(playerid)
{
    new
        slot_id = GetPlayerInventorySlotClicked(playerid),
        item_id = GetPlayerInventoryData(playerid, I_ITEM, slot_id);
       //td_id = GetPlayerInventoryTDClicked(playerid)
    
        UsePlayerItem(playerid, item_id);

    return 1;
}
stock InventoryMain:UnUseItem(playerid)
{
    new
        slot_id = GetPlayerInventorySlotClicked(playerid),
        item_id = GetPlayerInventoryData(playerid, I_ITEM, slot_id);
       //td_id = GetPlayerInventoryTDClicked(playerid)
    
        UnUsePlayerItem(playerid, item_id);

    return 1;
}

stock InventoryMain:ClearDropItem(playerid, dropid, type = 0)
{
    #pragma unused playerid
    if(IsValidDynamicObject(GetDropItemData(dropid, ITEM_OBJECT_ID)))
    {
        if(type == 0) DestroyDynamicObject(GetDropItemData(dropid, ITEM_OBJECT_ID));
        else SetDropItemData(dropid, ITEM_UNIX_TIME_DELETE, gettime() + 2);
    }
    if(IsValidDynamic3DTextLabel(GetDropItemData(dropid, ITEM_3DTEXT)) && GetDropItemData(dropid, ITEM_3DTEXT) != Text3D:INVALID_3DTEXT_ID)
    {
        DestroyDynamic3DTextLabel(GetDropItemData(dropid, ITEM_3DTEXT));

        SetDropItemData(dropid, ITEM_3DTEXT, Text3D:INVALID_3DTEXT_ID);
    }
    return 1;
}

stock InventoryMain:ClearIdDropItems(playerid)
{
    for(new i; i < MAX_DROP_ITEMS; i++)
    {
        if(GetDropItemData(i, ITEM_ID)) continue;

        if(GetDropItemData(i, ITEM_PLAYER_ID) == playerid)
        {
            SetDropItemData(i, ITEM_PLAYER_ID, INVALID_PLAYER_ID);
        }
    }
    return 1;
}

// ** Проверка на наличия предметов рядом
stock InventoryMain:GetDropItemOfPoint(playerid)
{
    for(new i; i < MAX_DROP_ITEMS; i++)
    {
        if(GetDropItemData(i, ITEM_ID)) continue;
    
        if(IsPlayerInRangeOfPoint(playerid, 1.2, GetDropItemData(i, ITEM_X), GetDropItemData(i, ITEM_Y), GetDropItemData(i, ITEM_Z))) return i;
    }
    return -1;
}

// ** Проверка на наличия свободного слота для дропа
stock InventoryMain:GetFreeSlotDropItem()
{
    for(new i; i < MAX_DROP_ITEMS; i++)
    {
        if(GetDropItemData(i, ITEM_ID) == 0) return i;
    }
    return -1;
}

stock InventoryMain:GetCountDropItemsForPlayer(playerid)
{
    new count_items;

    for(new i; i < MAX_DROP_ITEMS; i++)
    {
        if(!GetDropItemData(i, ITEM_ID)) continue;

        if(GetDropItemData(i, ITEM_PLAYER_ID) == playerid) count_items++;
    }
    return count_items;
}


stock InventoryMain:DropItem(playerid, itemid, value, slotid, bool:chat = true, bool: anim = true)
{
    new
        Float: x,
        Float: y,
        Float: z;

    GetPlayerPos(playerid, x, y, z);

    new
        dropid = InventoryMain:GetFreeSlotDropItem();

    if(chat)
    { 
        format(totalstring, 144, "%s %s на землю %s", GetName(playerid), (pInfo[playerid][pSex] == 2) ? "положила" : "положил", GetInventoryItemData(itemid, ITEM_NAME));
        MeAction(playerid, totalstring, SELECT_ACTION_IN_BUBBLE);
        totalstring[0] = EOS;
    }

    if(dropid == -1)
    {
        new
            max_gettime = gettime();

        for(new i; i < MAX_DROP_ITEMS; i++)
        {
            if(GetDropItemData(i, ITEM_UNIX_TIME) < max_gettime)
            {
                max_gettime = GetDropItemData(i, ITEM_UNIX_TIME);

                dropid = i;
            }
        }
        InventoryMain:ClearDropItem(playerid, dropid);
    }
    if(InventoryMain:GetCountDropItemsForPlayer(playerid) == MAX_DROP_ITEMS_FOR_PLAYER)
    {
        new
            max_gettime = gettime();

        for(new i; i < MAX_DROP_ITEMS; i++)
        {
            if(GetDropItemData(i, ITEM_UNIX_TIME) < max_gettime && GetDropItemData(i, ITEM_PLAYER_ID) == playerid)
            {
                max_gettime = GetDropItemData(i, ITEM_UNIX_TIME);

                dropid = i;
            }
        }
        InventoryMain:ClearDropItem(playerid, dropid);
    }

    if(anim) ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);

    new
        object_model_id = GetInventoryItemData(itemid, ITEM_MODEL_ID);

    switch(itemid)
    {   
        default: SetDropItemData(dropid, ITEM_OBJECT_ID, CreateDynamicObject(object_model_id, x, y, z - 0.93, 270.0, 0.0, 0.0));
    }
    if(!IsValidDynamic3DTextLabel(GetDropItemData(dropid, ITEM_3DTEXT)) && GetDropItemData(dropid, ITEM_3DTEXT) == Text3D:INVALID_3DTEXT_ID)
    {
        format(totalstring, 128, "« %s »\n{"#DC_GREY"}Количество: %d\n{"#DC_WHITE"}Поднять: {"#DC_MAIN"}H", GetInventoryItemData(itemid, ITEM_NAME), value);
        SetDropItemData(dropid, ITEM_3DTEXT, CreateDynamic3DTextLabel(totalstring, COLOR_YELLOW, x, y, z - 0.8, 2.0));
        totalstring[0] = EOS;
    }
    
    SetDropItemData(dropid, ITEM_ID, itemid);
    SetDropItemData(dropid, ITEM_VALUE, value);
    SetDropItemData(dropid, ITEM_UNIX_TIME, gettime());
    SetDropItemData(dropid, ITEM_PLAYER_ID, playerid);

    SetDropItemData(dropid, ITEM_X, x);
    SetDropItemData(dropid, ITEM_Y, y);
    SetDropItemData(dropid, ITEM_Z, z);

    Streamer_Update(playerid);

    InventoryMain:SetCountItemPlayerData(playerid, slotid, -value);
    return 1;
}

DialogCreate:D_ID_INV_DROP_SELECT(playerid)
{
   Dialog_Open(playerid, Dialog:D_ID_INV_DROP_SELECT, DIALOG_STYLE_LIST,""colserver"Выберите действие","\
        1. Положить на землю\n\
        2. Удалить предмет",
        "Далее", "Закрыть"
    );
    return 1;
}

DialogResponse:D_ID_INV_DROP_SELECT(playerid, response, listitem, inputtext[])
{
    /*
        1. Доделать диалоги
        2. Сделать чат с ошибками.
    */
    new
        itemid = GetPVarInt(playerid, "Drop:ItemID"),
        slotid = GetPVarInt(playerid, "Drop:SlotID");

    if(!response) return 1;

    switch(listitem)
    {
        case 0:
        {
            if(GetPlayerInterior(playerid) != 0 || GetPlayerVirtualWorld(playerid) != 0) return 1;

            if(GetPlayerInventoryData(playerid, I_COUNT, slotid) == 1)
            {
                if(GetPVarInt(playerid, "DropItem:Limit") > gettime()) return 1;
                else if(InventoryMain:GetDropItemOfPoint(playerid) != -1) return 1;

                InventoryMain:DropItem(playerid, itemid, 1, slotid);

                DeletePVar(playerid, "Drop:ItemID");
                DeletePVar(playerid, "Drop:SlotID");
                DeletePVar(playerid, "Drop:Value");
            }
        }
        case 1:
        {
            if(GetPlayerInventoryData(playerid, I_COUNT, slotid) == 1)
            {
                SetPVarInt(playerid, "Drop:Value", 1);
                Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE_ACCEPT);
            }
            else Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        }
    }

    return 1;
}


DialogCreate:D_ID_DROP_DELETE_ACCEPT(playerid)
{
    new
        itemid = GetPVarInt(playerid, "Drop:ItemID"),
        value = GetPVarInt(playerid, "Drop:Value");

    format(totalstring, 256, "\
        "colwhi"Вы действительно хотите удалить предмет "colserver"%s?\n\
        "colwhi"Количество: "colserver"%d", 
        GetInventoryItemData(itemid, ITEM_NAME),
        value
    );

    Dialog_Open(playerid, Dialog:D_ID_DROP_DELETE_ACCEPT, DIALOG_STYLE_MSGBOX, ""colserver"Удалить", totalstring, !"Да", !"Нет");

    totalstring[0] = EOS;
    return 1;
}

DialogResponse:D_ID_DROP_DELETE_ACCEPT(playerid, response, listitem, inputtext[])
{
    new 
//        itemid = GetPVarInt(playerid, "Drop:ItemID"),
        slotid = GetPVarInt(playerid, "Drop:SlotID"),
        value = GetPVarInt(playerid, "Drop:Value");

    DeletePVar(playerid, "Drop:ItemID");
    DeletePVar(playerid, "Drop:SlotID");
    DeletePVar(playerid, "Drop:Value");

    if(!response) return 1;

    InventoryMain:SetCountItemPlayerData(playerid, slotid, -value);

    SCM(playerid, COLOR_GREEN, "Вы успешно удалили предмет из инвентаря");
    
    return 1;
}

DialogCreate:D_ID_DROP_DELETE(playerid)
{
    Dialog_Open(playerid, Dialog:D_ID_DROP_DELETE, DIALOG_STYLE_INPUT, ""colserver"Удалить", !""colwhi"Укажите количество, которое хотите удалить:", !"Далее", !"Закрыть");
    return 1;
}

DialogResponse:D_ID_DROP_DELETE(playerid, response, listitem, inputtext[])
{
    new
//        itemid = GetPVarInt(playerid, "Drop:ItemID"),
        item_value,
        slotid = GetPVarInt(playerid, "Drop:SlotID");

    DeletePVar(playerid, "Drop:ItemID");
    DeletePVar(playerid, "Drop:SlotID");
    DeletePVar(playerid, "Drop:Value");

    if(!response) return 1;
    if(sscanf(inputtext, "d", item_value))
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return SCM(playerid, -1, "укажите количество");
    }
    else if(item_value < 1)
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return SCM(playerid, -1, "укажите количество больше 1");
    }
    else if(item_value > GetPlayerInventoryData(playerid, I_COUNT, slotid))
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return SCM(playerid, -1, "у Вас нет столько единиц данного предмета");
    }
/*
    if(sscanf(inputtext, "d", item_value))
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return Hud:ShowClisMessenger(playerid, ERROR, "укажите количество");
    }
    else if(item_value < 1)
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return Hud:ShowNotification(playerid, ERROR, "укажите количество больше 1");
    }
    else if(item_value > GetPlayerInventoryData(playerid, I_COUNT, slotid))
    {
        Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE);
        return Hud:ShowNotification(playerid, ERROR, "у Вас нет столько единиц данного предмета");
    }
*/
    SetPVarInt(playerid, "Drop:Value", item_value);

    Dialog_Show(playerid, Dialog:D_ID_DROP_DELETE_ACCEPT);

    return 1;
}
