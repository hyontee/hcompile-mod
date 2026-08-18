enum
{
/* 1 */   TYPE_LOG_BAN = 1,
/* 2 */   TYPE_LOG_SBAN,
/* 3 */   TYPE_LOG_IBAN,
/* 4 */   TYPE_LOG_MUTE,
/* 5 */   TYPE_LOG_KICK,
/* 6 */   TYPE_LOG_WARN,
/* 7 */   TYPE_LOG_JAIL,
/* 8 */   TYPE_LOG_UVAL,
/* 9 */   TYPE_LOG_SKICK,
/* 10 */  TYPE_LOG_SETHP,
/* 11 */  TYPE_LOG_BANIP,
/* 12 */  TYPE_LOG_DELACC,
/* 13 */  TYPE_LOG_SETNICK,

/* 14 */  TYPE_LOG_UNBAN,
/* 15 */  TYPE_LOG_UNMUTE,
/* 16 */  TYPE_LOG_UNWARN,
/* 17 */  TYPE_LOG_UNJAIL,
/* 18 */  TYPE_LOG_UNBANIP,

/* 19 */  TYPE_LOG_OFFBAN,
/* 20 */  TYPE_LOG_OFFWARN,
/* 21 */  TYPE_LOG_OFFJAIL,
/* 22 */  TYPE_LOG_OFFUNWARN,
/* 23 */  TYPE_LOG_OFFMUTE,
/* 24 */  TYPE_LOG_SETSTATS,
/* 25 */  TYPE_LOG_NEW_DONATE,
/* 26 */  TYPE_LOG_BUY_ITEM_MARKET,
/* 27 */  TYPE_LOG_SELL_ITEM_MARKET,
/* 28 */  TYPE_LOG_BUY_ITEM_INVENTORY,
/* 29 */  TYPE_LOG_SELL_ITEM_INVENTORY,
/* 30 */  TYPE_LOG_ADD_ITEM_MARKET,
/* 31 */  TYPE_LOG_RETURN_ITEM_MARKET,
/* 31 */  TYPE_LOG_GIVE_ACCESSORIES,
/* 31 */  TYPE_LOG_GIVE_VEHICLE,
/* 31 */  TYPE_LOG_GIVE_VIP
}

stock WriteAdminLog(TYPE_LOG, const NamePlayerid[], const NameTargetid[], const ReasonLog[])
{
    STRING_GLOBAL[0] = EOS;
    mysql_format(con_bd, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `admin_log` (`TYPE`, `ADMIN`, `PLAYER`, `REASON`) VALUES (%d, '%e', '%e', '%e')",
    TYPE_LOG, NamePlayerid, NameTargetid, ReasonLog);
    mysql_tquery(con_bd, STRING_GLOBAL);
    return 0x1;
}
