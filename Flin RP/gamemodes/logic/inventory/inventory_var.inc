#define MAX_PLAYER_EQUIPMENT        100

#define MAX_EQUIPMENT_ALL           160 //

#define INVALID_SKIN_ID     0

enum
{
    INVENTORY_OWNER_TYPE_PLAYER,
    INVENTORY_OWNER_TYPE_VEHICLE,
    INVENTORY_OWNER_TYPE_HOUSE,
    INVENTORY_OWNER_TYPE_TRASHBOX,
}

enum
{
    INVENTORY_SELECT_TYPE_RIGHT = 0,
    INVENTORY_SELECT_TYPE_USE_ACC,
    INVENTORY_SELECT_TYPE_LEFT
}

enum INVENTORY_INFO
{
    inv_mysql_id, // хд ад
    inv_slot_id, // якнр
    inv_item_id, // хд опедлерю
    inv_amount, // йнкхвеярбн
    inv_status_use, // хяонкэгсеряъ хкх мер
    // accessories
    inv_acc_slot,
    Float:inv_acc_wear, // wear
    inv_acc_mt[2],
    Float:inv_acc_pos[9], // pos
    inv_acc_premium,

    // skin
    Float:inv_skin_wear, // wear
    inv_skin_premium,

    // TEMP:
    inv_market_sell_amount, // йнкхвеярбн мю опндюфе
    inv_market_sell_price, // жемю гю 1 едхмхжс мю гюйсойе

    inv_market_buy_amount, // йнкхвеярбн мю гюйсойе
    inv_market_buy_price, // жемю гю 1 едхмхжс мю опндюфе
}
new InventoryPlayer[MAX_PLAYERS][MAX_EQUIPMENT_ALL][INVENTORY_INFO];
