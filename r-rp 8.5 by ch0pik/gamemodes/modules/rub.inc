#if defined _rub_menu_included
    #endinput
#endif
#define _rub_menu_included

cmd:coins(playerid) return callcmd::donatemenu(playerid);
cmd:rub(playerid) return callcmd::donatemenu(playerid);
cmd:adm(playerid) return callcmd::donatemenu(playerid);
cmd:donat(playerid) return callcmd::donatemenu(playerid);
cmd:donatmenu(playerid) return callcmd::donatemenu(playerid);
cmd:rcoins(playerid) return callcmd::donatemenu(playerid);
cmd:donatemenu(playerid)
{
    new str[512];
    format(str, sizeof(str),
        "В этом разделе вы можете использовать дополнительные\n"\
        "возможности сервера. Чтобы получить к ним доступ,\n"\
        "необходимо пополнить свой игровой счёт. Описание всех\n"\
        "дополнительных возможностей, а также о способах\n"\
        "пополнения счёта вы можете узнать на нашем сайте:\n"\
        "{"SERVER_COLOR"}%s\n\n"\
        "{"SERVER_COLOR"}Информация:\n"\
        "{FFFFFF}Номер аккаунта:{"SERVER_COLOR"}\t%d\n"\
        "{FFFFFF}Текущее состояние счёта:{"SERVER_COLOR"}\t%d Donate\n"\
        "{FFFFFF}Общая сумма пополнений:{"SERVER_COLOR"}\t%d Donate",
        SERVER_SITE,
        GetPlayerAccountID(playerid),
        GetPlayerData(playerid, P_DONATE_CURRENT),
        GetPlayerData(playerid, P_DONATE_TOTAL)
    );
    Dialog(playerid, DIALOG_RUB_MAIN, DIALOG_STYLE_MSGBOX,
        "{FFCD00}ДОПОЛНИТЕЛЬНЫЕ ВОЗМОЖНОСТИ",
        str,
        "Просмотр", "Назад"
    );
    return 1;
}
stock IsVehicleNumberExists(number[], region[], type33)
{
    new query[256], Cache:result, rows;
    mysql_format(mysql, query, sizeof(query), "SELECT id FROM ownable_cars WHERE number='%s' AND region='%s' AND typenumber=%d", number, region, type33);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) return true;
    mysql_format(mysql, query, sizeof(query), "SELECT id FROM family_cars WHERE number='%s' AND region='%s' AND typenumber=%d", number, region, type33);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) return true;
    mysql_format(mysql, query, sizeof(query), "SELECT id FROM items WHERE number='%s' AND region='%s' AND typenumber=%d AND type_item=1", number, region, type33);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) return true;
    mysql_format(mysql, query, sizeof(query), "SELECT id FROM kiosks_items WHERE number='%s' AND region='%s' AND typenumber=%d", number, region, type33);
    result = mysql_query(mysql, query, true);
    rows = cache_num_rows();
    cache_delete(result);
    if (rows) return true;
    return false;
}

stock IsCharLetter(c)
{
    return ('A' <= c <= 'Z') || ('a' <= c <= 'z');
}
stock IsCharDigit(c)
{
    return ('0' <= c <= '9');
}

stock IsValidRussianCarNumber(str[])
{
    if (strlen(str) != 8)
        return false;
    return IsCharLetter(str[0]) &&
           IsCharDigit(str[1]) &&
           IsCharDigit(str[2]) &&
           IsCharDigit(str[3]) &&
           IsCharLetter(str[4]) &&
           IsCharLetter(str[5]) &&
           IsCharDigit(str[6]) &&
           IsCharDigit(str[7]);
}