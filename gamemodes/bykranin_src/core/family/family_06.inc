//>> Файл: bykranin_src/core/family/family_06.inc  (242 строк)
//>> Тема: семьи / банды / организации
//>> Внутри: LoadFamily, GetFamilyRang, ShowPayFamilyDialog, ShowChangeRangDialog, ShowFamilyAllPlayers, ShowFamilyInfo, CreateRentZone
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: LoadFamily()
{
    new idx;
    //new query[85];
    new Cache: result, rows;

    result = mysql_query(mysql, "SELECT * FROM family", true);
    rows = cache_num_rows(result);

    if(rows >= sizeof(g_family))
    {
        rows = sizeof(g_family) - 1;
        printf("[MYSQL][FAMILY] Rows exceeded family pool, capped to %d", rows);
    }


    for(idx = 0; idx < rows; idx ++)
    {
        SetFamilyData(idx+1, F_SQL_ID,        cache_get_field_content_int(idx, "id"));

        cache_get_field_content(idx, "name", g_family[idx+1][F_NAME], mysql, 64);

        SetFamilyData(idx+1, F_USER_ID,       cache_get_field_content_int(idx, "u_id"));
        SetFamilyData(idx+1, F_TIME,          cache_get_field_content_int(idx, "time"));
        SetFamilyData(idx+1, F_COLOR,         cache_get_field_content_int(idx, "color"));
        SetFamilyData(idx+1, F_LEVEL,         cache_get_field_content_int(idx, "level"));
        SetFamilyData(idx+1, F_EXP,           cache_get_field_content_int(idx, "exp"));


        cache_get_field_content(idx, "rank1", g_family[idx+1][F_RANK1], mysql, 32);
        cache_get_field_content(idx, "rank2", g_family[idx+1][F_RANK2], mysql, 32);
        cache_get_field_content(idx, "rank3", g_family[idx+1][F_RANK3], mysql, 32);
        cache_get_field_content(idx, "rank4", g_family[idx+1][F_RANK4], mysql, 32);
        cache_get_field_content(idx, "rank5", g_family[idx+1][F_RANK5], mysql, 32);
        cache_get_field_content(idx, "rank6", g_family[idx+1][F_RANK6], mysql, 32);
        cache_get_field_content(idx, "rank7", g_family[idx+1][F_RANK7], mysql, 32);
        cache_get_field_content(idx, "rank8", g_family[idx+1][F_RANK8], mysql, 32);
        cache_get_field_content(idx, "rank9", g_family[idx+1][F_RANK9], mysql, 32);
        cache_get_field_content(idx, "rank10", g_family[idx+1][F_RANK10], mysql, 32);

        g_family[idx+1][F_SPAWN_POSITION][0] = cache_get_field_content_float(idx, "pos_x");
        g_family[idx+1][F_SPAWN_POSITION][1] = cache_get_field_content_float(idx, "pos_y");
        g_family[idx+1][F_SPAWN_POSITION][2] = cache_get_field_content_float(idx, "pos_z");
        g_family[idx+1][F_SPAWN_POSITION][3] = cache_get_field_content_float(idx, "pos_fa");

        g_family[idx+1][F_SPAWN_IV][0] =    cache_get_field_content_int(idx, "inter");
        g_family[idx+1][F_SPAWN_IV][1] =    cache_get_field_content_int(idx, "world");

        SetFamilyData(idx+1, F_MONEY,         cache_get_field_content_int(idx, "money"));
        SetFamilyData(idx+1, F_DRUGS,         cache_get_field_content_int(idx, "drugs"));
        SetFamilyData(idx+1, F_TREE,          cache_get_field_content_int(idx, "tree"));
        SetFamilyData(idx+1, F_METAL,         cache_get_field_content_int(idx, "metal"));
        SetFamilyData(idx+1, F_AMMO,          cache_get_field_content_int(idx, "ammo"));
        SetFamilyData(idx+1, F_HOUSE_ID,      cache_get_field_content_int(idx, "house_id"));
        SetFamilyData(idx+1, F_OCKIFARMA,          cache_get_field_content_int(idx, "ochki"));
        SetFamilyData(idx+1, F_OCZAVOD,          cache_get_field_content_int(idx, "ochki1"));
        SetFamilyData(idx+1, F_VISHARZ,          cache_get_field_content_int(idx, "ochki2"));
        SetFamilyData(idx+1, F_VISHKAR,          cache_get_field_content_int(idx, "ochki3"));
        SetFamilyData(idx+1, F_VISBUS,          cache_get_field_content_int(idx, "ochki4"));
        
        SetFamilyData(idx+1, F_TAKE_MONEY,	cache_get_field_content_int(idx, "r_TakeMoney"));
		SetFamilyData(idx+1, F_TAKE_DRUGS,	cache_get_field_content_int(idx, "r_TakeDrugs"));
		SetFamilyData(idx+1, F_TAKE_METALL,	cache_get_field_content_int(idx, "r_TakeMetall"));
		SetFamilyData(idx+1, F_TAKE_AMMO,		cache_get_field_content_int(idx, "r_TakeAmmo"));
		SetFamilyData(idx+1, F_RANG_INV,		cache_get_field_content_int(idx, "r_Inv"));
		SetFamilyData(idx+1, F_RANG_UNINV,		cache_get_field_content_int(idx, "r_UnInv"));
		SetFamilyData(idx+1, F_RANG_MUTE,		cache_get_field_content_int(idx, "r_Mute"));
		SetFamilyData(idx+1, F_RANG_UNMUTE,		cache_get_field_content_int(idx, "r_UnMute"));
		SetFamilyData(idx+1, F_RANG_WARN,		cache_get_field_content_int(idx, "r_Warn"));
		SetFamilyData(idx+1, F_RANG_UNWARN,		cache_get_field_content_int(idx, "r_UnWarn"));
		SetFamilyData(idx+1, F_RANG_GIVER,		cache_get_field_content_int(idx, "r_GiveRang"));
		
		SetFamilyData(idx+1, F_FAMILY_CARS,		cache_get_field_content_int(idx, "family_cars"));

        // -------------------------
    }
    g_family_loaded = rows;
    cache_delete(result);

    printf("[Family]: Семьи : %d", g_family_loaded);
	//LoadFamilyCars();
}
stock GetFamilyRang(fam_id, rang_id)
{
    new fmt_rank[32];

    switch(rang_id)
    {
        case 1: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK1]);
        case 2: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK2]);
        case 3: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK3]);
        case 4: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK4]);
        case 5: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK5]);
        case 6: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK6]);
        case 7: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK7]);
        case 8: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK8]);
        case 9: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK9]);
        case 10: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK10]);
        default: format(fmt_rank, sizeof fmt_rank, "%s", g_family[fam_id][F_RANK1]);
    }

    return fmt_rank;
}

stock ShowPayFamilyDialog(playerid)
{
    Dialog
    (
        playerid, DIALOG_PAY_FAMILY, DIALOG_STYLE_INPUT,
        "Банк семьи",
        "{FFFFFF} Введите сумму которую хотите снять с банка семьи",
        "Снять", "Назад"
    );
    return 1;
}

stock ShowChangeRangDialog(playerid)
{
    new fmt_text[1086],
        query[1086],
        fam_id = GetPlayerData(playerid, P_FAMILY);

    format(fmt_text, sizeof fmt_text, "");

    format(query, sizeof query, "{%s}1. %s\n", !strcmp(g_family[fam_id][F_RANK1], "Пусто") ? ("FFFFFF") : ("32a44b"), g_family[fam_id][F_RANK1]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}2. %s\n", !strcmp(g_family[fam_id][F_RANK2], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK2]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}3. %s\n", !strcmp(g_family[fam_id][F_RANK3], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK3]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}4. %s\n", !strcmp(g_family[fam_id][F_RANK4], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK4]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}5. %s\n", !strcmp(g_family[fam_id][F_RANK5], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK5]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}6. %s\n", !strcmp(g_family[fam_id][F_RANK6], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK6]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}7. %s\n", !strcmp(g_family[fam_id][F_RANK7], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK7]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}8. %s\n", !strcmp(g_family[fam_id][F_RANK8], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK8]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}9. %s\n", !strcmp(g_family[fam_id][F_RANK9], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK9]);
    strcat(fmt_text, query);
    format(query, sizeof query, "{%s}10. %s\n", !strcmp(g_family[fam_id][F_RANK10], "Пусто") ? ("FFFFFF") : ("32a44b"),g_family[fam_id][F_RANK10]);
    strcat(fmt_text, query);

    Dialog
    (
        playerid, DIALOG_FAMILY_RANG, DIALOG_STYLE_LIST,
        "Выберите номер ранга",
        fmt_text,
        "Выбрать", "Отмена"
    );
}
public: ShowFamilyAllPlayers(playerid)
{
    new rows = cache_num_rows();

    new p_name[21];
    new lvl, family_rank;

    new fmt_str[33];
    new text[1290] = "Уровень\tРанг\tИмя\n\n{FFFFFF}";

    new idx, j = rows;
    if(j > 45)
        j = 45;

    for(idx = 0; idx < j; idx ++)
    {
        cache_get_row(idx, 0, p_name);
        lvl = cache_get_row_int(idx, 1);
        family_rank = cache_get_row_int(idx,2);

        format(fmt_str, sizeof fmt_str, "%d\t%d\t%s\n", lvl, family_rank, p_name);
        strcat(text, fmt_str);
    }

    format(fmt_str, sizeof fmt_str, "Показаны %d/%d игроков", idx, rows);
    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, fmt_str, text, "Закрыть", "");
    return 1;
}
stock ShowFamilyInfo(playerid)
{
    new fmt_text[450],
        fam_id = GetPlayerData(playerid, P_FAMILY);

    format(fmt_text, sizeof fmt_text,
    "{FFFFFF}Название: [%s]\n\
    Лидер семьи: %d\n\
     Репутация: [%d (%d/500)]\n\
     Количество людей: скоро\n\
     \t\t\t\n\
      Улучшение склада: скоро\n\
      Улучшение оружья: скоро\n\
      Улучшение состава: скоро\n\
      \t\t\t\n\
      Денег: %s/20000000 рублей\n\
      Материалов: %d кг.\n\
      Масок: скоро\n\
      Канистр с бензином: скоро\n\
      Бронежилеты: скоро\n\
      Патронов:  %f/20000", 
     GetFamilyData(fam_id, F_NAME),
     GetFamilyData(fam_id, F_USER_ID),
     GetFamilyData(fam_id, F_LEVEL),
     GetFamilyData(fam_id, F_MONEY),
     GetFamilyData(fam_id, F_METAL),
     GetFamilyData(fam_id, F_AMMO));
      

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Информация семьи", fmt_text, "Закрыть", "");
}
stock CreateRentZone(Float:pickup_x, Float:pickup_y, Float:pickup_z, const Float:parking[][4], parking_count)
{
    if(TotalRentZones >= MAX_RENT_ZONES)
        return 0;

    if(parking_count < 0)
        return 0;

    if(parking_count > MAX_RENT_ZONE_SLOTS)
        parking_count = MAX_RENT_ZONE_SLOTS;

    new zone_id = TotalRentZones;
    gRentZoneSlotCount[zone_id] = parking_count;

    for(new i; i < parking_count; i++)
    {
        gRentZoneParking[zone_id][i][0] = parking[i][0];
        gRentZoneParking[zone_id][i][1] = parking[i][1];
        gRentZoneParking[zone_id][i][2] = parking[i][2];
        gRentZoneParking[zone_id][i][3] = parking[i][3];
    }

    CreatePickup(19131, 23, pickup_x, pickup_y, pickup_z, -1, PICKUP_ACTION_RENT_BIKE, zone_id);
    CreateDynamic3DTextLabel("{FFFF00}Управление транспортом\n{FFFFFF}Подойдите для взаимодействия", 0x3399FFFF, pickup_x, pickup_y, pickup_z + 0.7, 10.0);

    TotalRentZones++;
    return 1;
}

