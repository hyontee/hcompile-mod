new g_time_slet;

enum auto_slet
{

    bool:as_Status,
    as_Hour,
    as_Min,
    as_Owner[24],
    as_Type,
    as_ID

};
new const AutoSlet[MAX_WOODS][auto_slet];
stock CheckSlet()
{
    new bind[18];
    GetServerVarAsString("bind", bind, 17);

    g_time_slet = gettime() + RandomEx(1, 3600);
    printf("gettime slet - %d", g_time_slet);
    return 1;
}
cmd:time_slet(playerid)
{
    if (GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
    else if (!SuccessfulAura(playerid) && admin_logged[playerid] == false)
        return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");


    SCMF(playerid, -1, "%d ч / %d мин.", GetElapsedTime(g_time_slet, gettime(), CONVERT_TIME_TO_HOURS), GetElapsedTime(g_time_slet, gettime(), CONVERT_TIME_TO_MINUTES));

    return true;
}
stock SletMenu(playerid, dId = 0)
{
    static list[2048];
    list = "{FFFF00}ID\t{FFFF00}Тип\t{FFFF00}Время\t{ae433d}Поставил на слет";

    static query[1024];

    for new i;
i < sizeof AutoSlet;
i++ do
{

    if (AutoSlet[i][as_Status] == false)
        {
            strcat(list, "\n{ae433d}-\t{ae433d}-\t{ae433d}-\t{ae433d}-");
        }
        else
        {
            format(query, sizeof query, "\n%d\t%s\t%02d:%02d\t%s\t%s", AutoSlet[i][as_ID], GetSletName(AutoSlet[i][as_Type]), AutoSlet[i][as_Hour], AutoSlet[i][as_Min], AutoSlet[i][as_Owner]);
            strcat(list, query);
        }
    }

    return Dialog(playerid, dId, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Автоматический слет | {ae433d}MORALLWENS", list, dId ? "Параметры" : "Выйти", dId ? "Выйти" : "");
}

stock GetSletName(type)
{
    static name[24];
    switch (type)
    {
        case 0: format(name, 24, "Бизнес");
        case 1: format(name, 24, "Дом");
        case 3: format(name, 24, "Огород");
        case 4: format(name, 24, "Гараж");
        case 5: format(name, 24, "Сим-карта");
    }
    return name;
}