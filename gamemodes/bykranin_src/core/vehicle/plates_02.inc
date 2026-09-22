//>> Файл: bykranin_src/core/vehicle/plates_02.inc  (1090 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: /donatskins, PlateCountryToType, PlateTypeUsesRegion, GetPlateDraftPVarName, ClearPlateDraftCache, PlateDraftGetDbColumn, PlateDraftBuildStoredValue
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
new const SkinNames[][64] = {
    "Одежда 0", "Одежда 1", "Одежда 2", "Одежда 3", "Одежда 4", "Известный", "Одежда 6", "Одежда 7", "Одежда 8", "Одежда 9",
    "Девочка-кролик", "Одежда 11", "Одежда 12", "Одежда 13", "Одежда 14", "Одежда 15", "Одежда 16", "Одежда 17", "Одежда 18", "Одежда 19",
    "Одежда 20", "Одежда 21", "Советский солдат", "Советский солдат", "Дед Мороз", "Одежда 25", "Одежда 26", "Одежда 27", "Одежда 28", "Одежда 29",
    "Одежда 30", "Одежда 31", "Одежда 32", "Одежда 33", "Одежда 34", "Одежда 35", "Одежда 36", "Одежда 37", "Одежда 38", "Бесстрашная",
    "Одежда 40", "Одежда 41", "Одежда 42", "Одежда 43", "Одежда 44", "Одежда 45", "Одежда 46", "Одежда 47", "Заключенный", "Игрок 001",
    "Одежда 50", "Одежда 51", "Одежда 52", "Игрок 067", "Одежда 54", "Одежда 55", "Одежда 56", "Известный", "Одежда 58", "Одежда 59",
    "Одежда 60", "Одежда 61", "Темный", "Заключенный", "Одежда 64", "Ведьма", "Одежда 66", "Одежда 67", "Одежда 68", "Одежда 69",
    "Одежда 70", "Одежда 71", "Одежда 72", "Одежда 73", "Одежда 75", "Одежда 76", "Одежда 77", "Одежда 78", "Одежда 79", "Одежда 80",
    "Одежда 81", "Одежда 82", "Одежда 83", "Одежда 84", "Одежда 85", "Пивозавр", "Одежда 87", "Дед Мороз", "Мальчик", "Одежда 90",
    "Одежда 91", "Девушка", "Одежда 93", "Одежда 94", "Мексу Вещает", "Одежда 96", "Одежда 97", "Одежда 98", "Мужчина", "Одежда 100",
    "Одежда 101", "Одежда 102", "Одежда 103", "Одежда 104", "Одежда 105", "Известный", "Одежда 107", "Известный", "Известный", "Известный",
    "Одежда 111", "Одежда 112", "Одежда 113", "Одежда 114", "Одежда 115", "Одежда 116", "Одежда 117", "Одежда 118", "Одежда 119", "Одежда 120",
    "Одежда 121", "Фирменная одежда", "Одежда 123", "Одежда 124", "Одежда 125", "Одежда 126", "Одежда 127", "Одежда 128", "Шляпник", "Санта Клаус",
    "Одежда 131", "Одежда 132", "Одежда 133", "Одежда 134", "Одежда 135", "Одежда 136", "Одежда 137", "Одежда 138", "Одежда 139", "Одежда 140",
    "Одежда 141", "Одежда 142", "Одежда 143", "Одежда 144", "Одежда 145", "Одежда 146", "Одежда 147", "Одежда 148", "Одежда 149", "Одежда 150",
    "Одежда 151", "Одежда 152", "Одежда 153", "Одежда 154", "Одежда 155", "Одежда 156", "Одежда 157", "Одежда 158", "Одежда 159", "Одежда 160",
    "Одежда 161", "Известный", "Одежда 163", "Одежда 164", "Илон Маск", "Известный", "Одежда 167", "Одежда 168", "Одежда 169", "Одежда 170",
    "Одежда 171", "Одежда 172", "Одежда 173", "Даня Милохин", "Крик", "Одежда 176", "Одежда 177", "Одежда 178", "Одежда 179", "Одежда 180",
    "Одежда 181", "Одежда 182", "Одежда 183", "Одежда 184", "Одежда 185", "Одежда 186", "Одежда 187", "Одежда 188", "Одежда 189", "Одежда 190",
    "Одежда 191", "Одежда 192", "Одежда 193", "Одежда 194", "Одежда 195", "Снегурочка", "Девочка-кролик", "Одежда 198", "Девушка", "Известный",
    "Одежда 201", "Известный", "Одежда 203", "Известный", "Одежда 205", "Одежда 206", "Девочка", "Страшный", "Красавчик", "Одежда 210",
    "Одежда 211", "Одежда 212", "Одежда 213", "Одежда 214", "Одежда 215", "Одежда 216", "Одежда 217", "Одежда 218", "Одежда 219", "Мужчина",
    "Одежда 221", "Одежда 222", "Одежда 223", "Пивозавр", "Аниме-тян", "Одежда 226", "Одежда 227", "Одежда 228", "Известный", "Одежда 230",
    "Ведьма", "Красавица", "Одежда 233", "Господин", "Известный", "Барыга", "Одежда 237", "Одежда 238", "Одежда 239", "Одежда 240",
    "Одежда 241", "Одежда 242", "Снегурочка", "Одежда 244", "Снегурочка", "Одежда 246", "Одежда 247", "Одежда 248", "Господин", "Одежда 250",
    "Одежда 251", "Игла", "Солдат в кепке", "Одежда 254", "Одежда 255", "Одежда 256", "Одежда 257", "Одежда 258", "Одежда 259", "Одежда 260",
    "Одежда 261", "Убийца", "Одежда 263", "Злой", "Одежда 265", "Скелетон", "Джеймс Бонд", "Одежда 268", "Красавчик", "Муханов Кирилл",
    "Одежда 271", "Одежда 272", "Одежда 273", "Одежда 274", "Одежда 275", "Одежда 276", "Одежда 277", "Одежда 278", "Одежда 279", "Одежда 280",
    "Одежда 281", "Одежда 282", "Известный", "Одежда 284", "Одежда 285", "Одежда 286", "Одежда 287", "Одежда 288", "Одежда 289", "Одежда 290",
    "Одежда 291", "Одежда 292", "Одежда 293", "Одежда 294", "Одежда 295", "Одежда 296", "Одежда 297", "Леди", "Одежда 299", "Одежда 300",
    "Одежда 301", "Одежда 302", "Одежда 303", "Одежда 304", "Одежда 305", "Одежда 306", "Одежда 307", "Одежда 308", "Одежда 309", "Саша",
    "Бандит", "Одежда 5321", "Одежда 5322", "Вурдалаак", "Одежда 5324", "Новогодний", "Снеговик", "Одежда 5327", "Одежда 5341", "Одежда 5342",
    "Одежда 5343", "Одежда 5344", "Одежда 5345", "Одежда 5346", "Одежда 5347", "Одежда 5348", "Одежда 5349", "Одежда 5350", "Одежда 5351",
    "Одежда 5352", "Одежда 5353", "Одежда 5354", "Одежда 5355", "Одежда 5356", "Одежда 5357", "Одежда 5358", "Одежда 5359", "Одежда 5360",
    "Одежда 5361", "Дюшес", "Одежда 5363", "Одежда 5364", "Маньяк", "Одежда 5366", "Маньяк", "Одежда 5368", "Одежда 5369", "Одежда 5370",
    "Одежда 6774", "Одежда 6775", "Одежда 6776", "Одежда 6777", "Одежда 6778", "Одежда 6779", "Элегантная", "Король Нью-Йорка", "Ледяная мечта", "Black Santa",
    "Свежий холод", "Монтана", "Новогодняя ночь", "Новогодняя бабка", "Синяк", "Эльф", "Мраколют", "Снегурочка", "Хозяин таверны", "Эллиот",
    "Танцор", "Образ Ночная жизнь", "Образ Снежная муза", "Неоновый плейбой", "Розовый патруль", "Городская фламинго", "Розовая хищница", "Сёрфер легенда", "Экзо-панк", "Ретро вибрация",
    "Образ Легенда Гетто", "Образ Красотка побережья", "Мужчина мусорщик 1", "Мужчина мусорщик 2", "Женщина мусорщица 1", "Женщина мусорщица 2", "Король бомжей", "Бесконечный", "Королева Манипуляций", "Мужчина с уткой на футболке",
    "Мужчина Гот в худи", "Мужчина в худи BRstyle", "Мужчина в худи Макэвой", "Девушка в желтом лонгсливе", "Мужчина в черной куртке", "Девушка в кардигане", "Девушка с уткой на футболке", "Мужчина в шортах", "Мужчина в футболке BOSS", "Девушка в клетчатых брюках",
    "Крэкер", "Белый цветок", "Джованни", "Вишенка", "Модный ниндзя", "Охотник на демонов", "Стройная эльфийка", "Король пиратов", "Блогер", "Одежда 11588",
    "Одежда 11589", "Одежда 11590", "Одежда 11591", "Одежда 11592", "Одежда 11593", "Одежда 11915", "Одежда 11916", "Хоуми", "Одежда 11918", "Степаныч",
    "Петрович", "Хищница", "Саныч", "Николаич", "Лесничая", "Охотница", "Алишер*", "Толстый Алишер*", "Мент", "Раскаленный асфальт",
    "Скоростная леди", "Королева гонок", "Мастер дрифта", "Чемпион Ле-Мана", "Ночной король", "Повелительница дорог", "Администратор (женский)", "Даня Милохин", "Гомес", "Ларч",
    "Мейстер", "Всадник", "Мортиша", "Фестер", "Маг", "Уэнсдей", "Страж", "Бьянка", "Энид", "Аленушка",
    "Знахарь", "Пчелка", "Байкер", "Рыбак 1", "Рыбачка 1", "Рыбак 2", "Рыбачка 2", "Одежда 11964", "Одежда 11965", "Одежда 11966",
    "Одежда 11967", "Одежда 11968", "Одежда 11969", "Одежда 11970", "Солдатка", "Емеля", "Одежда 13725", "Одежда 13726", "Одежда 13727", "Одежда 13728",
    "Одежда 13729", "Одежда 13730", "Одежда 13817", "Одежда 13818", "Одежда 13819", "Одежда 13820", "Одежда 13821", "Одежда 13822", "Одежда 13823", "Одежда 13824",
    "Бархатные тяги", "Одежда 14387", "Бархатные тяги", "Одежда 18589", "Одежда 18590", "Одежда 18591", "Одежда 18592", "Одежда 18593", "Одежда 18594", "Одежда 18595",
    "Одежда 18596", "Одежда 18597", "Одежда 18598", "Одежда 18599", "Одежда 18600", "Одежда 18601", "Одежда 18602", "Одежда 18603", "Одежда 18604", "Одежда 18605",
    "Поззи", "Одежда 18607", "Одежда 18608", "Одежда 18609", "Одежда 18610", "Одежда 18611", "Одежда 18612", "Одежда 18613", "Одежда 18614", "Одежда 18615",
    "Одежда 18616", "Одежда 18617", "Одежда 18618", "Одежда 18619", "Бандит", "Бандит", "Одежда 18622", "Бандит", "Бандит", "Бандит",
    "Бандит", "Одежда 18627", "Бандит", "Одежда 18629", "Одежда 18630", "Одежда 18860", "Одежда 18861", "Одежда 19199", "Одежда 19260", "Одежда 19261",
    "Опасный", "Одежда 19263", "Одежда 19264", "Одежда 19265", "Одежда 19266", "Одежда 19267", "Одежда 19268", "Одежда 19269", "Одежда 19270", "Одежда 19271",
    "Одежда 19272", "Бабуля", "Одежда 19274", "Одежда 19275", "Одежда 19276", "Одежда 19596", "Одежда 19901", "Одежда 19902", "Ас команды", "Дива Гольфа",
    "Футболист Лео", "Синий спринтер", "Теннисист Мартин", "Турист Арон", "Теннисистка Моника", "Путешественница Люси", "Спасательница Синди", "Егерь", "Щёголь", "Местный Шериф",
    "Качок Джонс", "Модница Ребекка", "Дрифт Дива", "Драйвер", "Женщина кошка", "Горячий мужчина", "Посейдон", "Бизнес Леди", "Сотрудник Фирмы", "Стритрейсер",
    "Неуловимый", "Агент Эйч", "Защитница закона", "Гонщица Икс", "Правитель трека", "Вязальщица Дебора", "Громила", "Кристо", "Механик Марк", "Странный фермер",
    "Ванко", "Полина", "Кумихо", "Хиш-Миш", "Айко", "Капрал EFC", "Ванко Одержимый", "Токсичная", "Cyber Lady", "Cyber Man",
    "Масленников", "INSTASAMKA", "Флэшка", "Спектр", "Петр Шторм", "Искра", "Молния Максим", "Ртуть", "Роберт Мрак", "Виктор",
    "Азартный гонщик", "Петр Тренер", "Кристина", "Анна", "Уличный Продюсер", "Колян Мажор", "Ян Техник", "Ника Добытчица", "Алиса Следопытка", "Охотник Филиппыч",
    "Лесник", "Бомж Иннокентий", "Леха", "Серый", "Следопыт", "Танковый Ас", "Банкир", "Боря Бульдозер", "Майор Лгунов", "Следователь Ловцова",
    "Кастет", "София", "Сокол", "Громов", "Дядя Жора", "Вульгарная Девушка", "Aarne", "Bushido Zho", "Герой Родины", "Даня",
    "Иван Береговой", "Дарина Серфер", "Кир Кирыч", "Яна Лагуна", "Варя", "Менеджер клуба", "Лера Кокетка", "Виктор Уличный", "Нико Драйвовый", "Филин Детектив",
    "Сема Кореш", "Саня Сестра", "Шторм Похудевший", "Луна Гонщица", "Руслан Дрифтер", "Санек Брат", "Уличный Лихач", "Страж", "Радистка", "Ветеран",
    "Начальница", "Шериф", "Одежда 5500034", "Одежда 5500035", "Одежда 5500036", "Адвокат", "Дон", "Инспектор", "Ямасаки", "Агент",
    "Школьный Гик", "Девушка Форварда", "Школьный Тренер", "Мишаня Хулиган", "Тяжелый Форвард", "Вика Отличница", "Леха Кура", "Одежда 5500037", "Одежда 5500038", "Одежда 5500033",
    "Одежда 5500032", "Одежда 5500031", "Одежда 5500030", "Дядя Слава", "Гость Района", "Образ Блогера", "Образ Блогера"
};

CMD:donatskins(playerid, params[])
{
    new query[128];
    new accountid = GetPlayerAccountID(playerid);
    mysql_format(mysql, query, sizeof(query), "SELECT internal_id, modelid FROM invskins WHERE account_id = %d ORDER BY purchased_at DESC", accountid);
    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows(result);
    
    if (!rows)
    {
        SendClientMessage(playerid, 0xFF6347FF, "У вас нет купленных скинов.");
        cache_delete(result);
        return 1;
    }
    
    new dialog_str[4096] = "Ваши скины:\n";
    new count = 0;
    
    for (new i = 0; i < rows && count < 50; i++, count++)
    {
        new internal_id = cache_get_field_content_int(i, "internal_id");
        new modelid = cache_get_field_content_int(i, "modelid");
        new pos = strlen(dialog_str);
        
        if (internal_id >= 0 && internal_id < sizeof(SkinNames))
            format(dialog_str[pos], sizeof(dialog_str)-pos, "%s (ID: %d)\n", SkinNames[internal_id], modelid);
        else
            format(dialog_str[pos], sizeof(dialog_str)-pos, "Одежда %d (ID: %d)\n", internal_id, modelid);
    }
    
    cache_delete(result);
    ShowPlayerDialog(playerid, 1337, DIALOG_STYLE_LIST, "Мои скины", dialog_str, "Надеть", "Отмена");
    SetPVarInt(playerid, "MySkin_Dialog", 1);
    return 1;
}

stock PlateCountryToType(country)
{
    switch(country)
    {
        case 0: return TYPE_RU;
        case 1: return TYPE_UA;
        case 2: return TYPE_BY;
        case 3: return TYPE_KZ;
    }
    return TYPE_RU;
}

stock PlateTypeUsesRegion(plate_type)
{
    return (plate_type == TYPE_RU || plate_type == TYPE_KZ);
}


stock bool:GetPlateDraftPVarName(country, bool:is_region, key[], size)
{
    key[0] = '\0';

    switch(country)
    {
        case 0:
        {
            format(key, size, "%s", is_region ? PVAR_PLATE_DRAFT_RU_REGION : PVAR_PLATE_DRAFT_RU_NUMBER);
        }
        case 1:
        {
            format(key, size, "%s", is_region ? PVAR_PLATE_DRAFT_UA_REGION : PVAR_PLATE_DRAFT_UA_NUMBER);
        }
        case 2:
        {
            format(key, size, "%s", is_region ? PVAR_PLATE_DRAFT_BY_REGION : PVAR_PLATE_DRAFT_BY_NUMBER);
        }
        case 3:
        {
            format(key, size, "%s", is_region ? PVAR_PLATE_DRAFT_KZ_REGION : PVAR_PLATE_DRAFT_KZ_NUMBER);
        }
    }

    return (strlen(key) > 0);
}

stock ClearPlateDraftCache(playerid)
{
    DeletePVar(playerid, PVAR_PLATE_DRAFT_RU_NUMBER);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_RU_REGION);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_UA_NUMBER);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_UA_REGION);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_BY_NUMBER);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_BY_REGION);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_KZ_NUMBER);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_KZ_REGION);
    DeletePVar(playerid, PVAR_PLATE_DRAFT_DB_LOADED);
    return 1;
}

stock bool:PlateDraftGetDbColumn(country, column[], size)
{
    column[0] = '\0';
    switch(country)
    {
        case 0: format(column, size, "rus");
        case 1: format(column, size, "ua");
        case 2: format(column, size, "by");
        case 3: format(column, size, "kz");
    }
    return (strlen(column) > 0);
}

stock PlateDraftBuildStoredValue(country, plate[], region[], out_value[], out_size)
{
    if(PlateTypeUsesRegion(PlateCountryToType(country)))
    {
        format(out_value, out_size, "%s|%s", plate, region);
    }
    else
    {
        format(out_value, out_size, "%s|", plate);
    }
    return 1;
}

stock bool:PlateDraftParseStoredValue(country, stored[], plate[], plate_size, region[], region_size)
{
    plate[0] = '\0';
    region[0] = '\0';

    if(!strlen(stored)) return false;

    new sep = strfind(stored, "|", true);
    if(sep == -1)
    {
        format(plate, plate_size, "%s", stored);
    }
    else
    {
        strmid(plate, stored, 0, sep, plate_size);
        strmid(region, stored, sep + 1, strlen(stored), region_size);
    }

    if(!PlateTypeUsesRegion(PlateCountryToType(country)))
    {
        format(region, region_size, "");
    }

    return strlen(plate) > 0;
}

stock PlateDraft_SaveToPVar(playerid, country, plate[], region[])
{
    new key_number[32], key_region[32];

    if(!GetPlateDraftPVarName(country, false, key_number, sizeof(key_number)))
    {
        return 0;
    }

    SetPVarString(playerid, key_number, plate);

    if(GetPlateDraftPVarName(country, true, key_region, sizeof(key_region)))
    {
        SetPVarString(playerid, key_region, region);
    }

    return 1;
}

stock PlateDraft_SaveToDatabase(playerid, country, plate[], region[])
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return 0;
    }

    new column[8];
    if(!PlateDraftGetDbColumn(country, column, sizeof(column)))
    {
        return 0;
    }

    new stored[32], query[256];
    PlateDraftBuildStoredValue(country, plate, region, stored, sizeof(stored));

    mysql_format(mysql, query, sizeof(query), "INSERT INTO `lastnumber` (`acc_id`, `%s`) VALUES (%d, '%e') ON DUPLICATE KEY UPDATE `%s` = VALUES(`%s`)", column, account_id, stored, column, column);
    mysql_query(mysql, query, false);
    return 1;
}

stock PlateDraft_GenerateAndSaveCountry(playerid, country)
{
    new plate_type = PlateCountryToType(country);
    new plate[16], region[8];

    RandomNumberPlateByType(plate_type, plate, sizeof(plate));
    RandomNumberRegion(country, region, sizeof(region));

    if(!PlateTypeUsesRegion(plate_type))
    {
        format(region, sizeof(region), "");
    }

    PlateDraft_SaveToPVar(playerid, country, plate, region);
    PlateDraft_SaveToDatabase(playerid, country, plate, region);
    return 1;
}

stock PlateDraft_EnsureLoaded(playerid)
{
    if(GetPVarInt(playerid, PVAR_PLATE_DRAFT_DB_LOADED) == 1)
    {
        return 1;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        return 0;
    }

    new query[256];
    mysql_format(mysql, query, sizeof(query), "SELECT `rus`, `ua`, `by`, `kz` FROM `lastnumber` WHERE `acc_id` = %d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[PLATES][ERROR] lastnumber load failed errno=%d account=%d", mysql_errno(), account_id);
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows(result);
    if(rows <= 0)
    {
        for(new country = 0; country <= 3; country++)
        {
            PlateDraft_GenerateAndSaveCountry(playerid, country);
        }

        cache_delete(result);
        SetPVarInt(playerid, PVAR_PLATE_DRAFT_DB_LOADED, 1);
        return 1;
    }

    for(new country = 0; country <= 3; country++)
    {
        new column[8], stored[32];
        if(!PlateDraftGetDbColumn(country, column, sizeof(column)))
        {
            continue;
        }

        cache_get_field_content(0, column, stored, mysql, sizeof(stored));

        new plate[16], region[8];
        if(!PlateDraftParseStoredValue(country, stored, plate, sizeof(plate), region, sizeof(region)))
        {
            PlateDraft_GenerateAndSaveCountry(playerid, country);
            continue;
        }

        new plate_type = PlateCountryToType(country);
        new normalized_plate[16], normalized_region[8];

        if(!NormalizeAndValidatePlateByType(plate_type, plate, normalized_plate, sizeof(normalized_plate)))
        {
            PlateDraft_GenerateAndSaveCountry(playerid, country);
            continue;
        }

        if(!NormalizeAndValidatePlateRegion(plate_type, region, normalized_region, sizeof(normalized_region)))
        {
            if(PlateTypeUsesRegion(plate_type))
            {
                RandomNumberRegion(country, normalized_region, sizeof(normalized_region));
            }
            else
            {
                format(normalized_region, sizeof(normalized_region), "");
            }
        }

        PlateDraft_SaveToPVar(playerid, country, normalized_plate, normalized_region);
        PlateDraft_SaveToDatabase(playerid, country, normalized_plate, normalized_region);
    }

    cache_delete(result);
    SetPVarInt(playerid, PVAR_PLATE_DRAFT_DB_LOADED, 1);
    return 1;
}

stock PlateDraft_RegenerateAll(playerid)
{
    for(new country = 0; country <= 3; country++)
    {
        PlateDraft_GenerateAndSaveCountry(playerid, country);
    }

    SetPVarInt(playerid, PVAR_PLATE_DRAFT_DB_LOADED, 1);
    return 1;
}

stock SavePlateDraft(playerid, country, plate[], region[])
{
    if(!PlateDraft_SaveToPVar(playerid, country, plate, region))
    {
        return 0;
    }

    PlateDraft_SaveToDatabase(playerid, country, plate, region);
    return 1;
}

stock SavePlateDraftByMode(playerid, country, plate[], region[], bool:is_bc_mode)
{
    if(!PlateDraft_SaveToPVar(playerid, country, plate, region))
    {
        return 0;
    }

    if(!is_bc_mode)
    {
        PlateDraft_SaveToDatabase(playerid, country, plate, region);
    }

    return 1;
}

stock bool:LoadPlateDraft(playerid, country, plate[], plate_size, region[], region_size)
{
    if(GetPVarInt(playerid, PVAR_PLATE_DRAFT_DB_LOADED) != 1)
    {
        PlateDraft_EnsureLoaded(playerid);
    }

    plate[0] = '\0';
    region[0] = '\0';

    new key_number[32], key_region[32];

    if(!GetPlateDraftPVarName(country, false, key_number, sizeof(key_number)))
    {
        return false;
    }

    GetPVarString(playerid, key_number, plate, plate_size);

    if(GetPlateDraftPVarName(country, true, key_region, sizeof(key_region)))
    {
        GetPVarString(playerid, key_region, region, region_size);
    }

    if(!PlateTypeUsesRegion(PlateCountryToType(country)))
    {
        format(region, region_size, "");
    }

    return strlen(plate) > 0;
}
stock PlateCountryToItemId(country)
{
    switch(country)
    {
        case 0: return INV_ITEM_PLATE_RU;
        case 1: return INV_ITEM_PLATE_UA;
        case 2: return INV_ITEM_PLATE_BY;
        case 3: return INV_ITEM_PLATE_KZ;
    }
    return INV_ITEM_PLATE_RU;
}

stock PlateTypeToItemId(plate_type)
{
    switch(plate_type)
    {
        case TYPE_RU: return INV_ITEM_PLATE_RU;
        case TYPE_UA: return INV_ITEM_PLATE_UA;
        case TYPE_BY: return INV_ITEM_PLATE_BY;
        case TYPE_KZ: return INV_ITEM_PLATE_KZ;
    }
    return INV_ITEM_PLATE_RU;
}

stock bool:OwnableCarHasInstalledPlate(idx)
{
    if(idx < 0)
    {
        return false;
    }

    if(!strlen(g_ownable_car[idx][OC_NUMBER]))
    {
        return false;
    }

    if(!strcmp(g_ownable_car[idx][OC_NUMBER], "------", true))
    {
        return false;
    }

    return true;
}
stock PlateItemIdToCountry(item_id)
{
    switch(item_id)
    {
        case INV_ITEM_PLATE_RU: return 0;
        case INV_ITEM_PLATE_UA: return 1;
        case INV_ITEM_PLATE_BY: return 2;
        case INV_ITEM_PLATE_KZ: return 3;
    }
    return -1;
}

stock PlateItemIdToModel(item_id)
{
    switch(item_id)
    {
        case INV_ITEM_PLATE_RU: return INV_MODEL_PLATE_RU;
        case INV_ITEM_PLATE_UA: return INV_MODEL_PLATE_UA;
        case INV_ITEM_PLATE_BY: return INV_MODEL_PLATE_BY;
        case INV_ITEM_PLATE_KZ: return INV_MODEL_PLATE_KZ;
    }
    return 1;
}

stock PlateModelToItemId(model_id)
{
    switch(model_id)
    {
        case INV_MODEL_PLATE_RU: return INV_ITEM_PLATE_RU;
        case INV_MODEL_PLATE_UA: return INV_ITEM_PLATE_UA;
        case INV_MODEL_PLATE_BY: return INV_ITEM_PLATE_BY;
        case INV_MODEL_PLATE_KZ: return INV_ITEM_PLATE_KZ;
    }
    return -1;
}

stock bool:Inventory11_IsPlateItem(item_id)
{
    return (item_id == INV_ITEM_PLATE_RU || item_id == INV_ITEM_PLATE_UA || item_id == INV_ITEM_PLATE_BY || item_id == INV_ITEM_PLATE_KZ);
}

stock bool:PlateIsAllowedLatinLetter(ch)
{
    switch(ch)
    {
        case 'a', 'b', 'c', 'e', 'h', 'k', 'm', 'o', 'p', 't', 'x', 'y': return true;
    }
    return false;
}

stock bool:PlateTextHasForbiddenSymbols(plate_type, const input[])
{
    for(new i = 0; i < strlen(input); i++)
    {
        new ch = input[i];

        if(ch >= 'A' && ch <= 'Z') ch += ('a' - 'A');

        if(ch >= '0' && ch <= '9') continue;
        if(ch == ' ' || ch == '-') continue;
        if(PlateIsAllowedLatinLetter(ch)) continue;

        return true;
    }

    return false;
}

stock bool:PlateRegionHasForbiddenSymbols(const input[])
{
    for(new i = 0; i < strlen(input); i++)
    {
        new ch = input[i];

        if(ch == ' ') continue;
        if(ch < '0' || ch > '9') return true;
    }

    return false;
}

stock SendPlateHint(playerid, text[])
{
    new JSON:response = JSON_Object();
    JSON_SetInt(response, "t", 1);
    JSON_SetString(response, "h", text, strlen(text));
    OnPacketIncoming(playerid, 1, response);
    JSON_Cleanup(response);
    return 1;
}

stock FormatPlateByTypeForDisplay(plate_type, input_plate[], output_plate[], output_size)
{
    output_plate[0] = '\0';

    new compact[16], idx = 0;
    for(new i = 0; i < strlen(input_plate); i++)
    {
        new ch = input_plate[i];

        if(ch == ' ' || ch == '-')
        {
            continue;
        }

        if(ch >= 'a' && ch <= 'z')
        {
            ch -= ('a' - 'A');
        }

        if(idx >= sizeof(compact) - 1)
        {
            break;
        }

        compact[idx++] = ch;
    }

    compact[idx] = '\0';

    switch(plate_type)
    {
        case TYPE_UA:
        {
            if(strlen(compact) == 8)
            {
                format(output_plate, output_size, "%c%c %c%c%c%c %c%c",
                    compact[0], compact[1],
                    compact[2], compact[3], compact[4], compact[5],
                    compact[6], compact[7]);
                return 1;
            }
        }
        case TYPE_BY:
        {
            if(strlen(compact) == 7)
            {
                format(output_plate, output_size, "%c%c%c%c %c%c-%c",
                    compact[0], compact[1], compact[2], compact[3],
                    compact[4], compact[5], compact[6]);
                return 1;
            }
        }
    }

    format(output_plate, output_size, "%s", input_plate);
    return 1;
}

stock bool:NormalizeAndValidatePlateByType(plate_type, const input_plate[], output_plate[], output_size)
{
    output_plate[0] = '\0';

    if(plate_type == TYPE_UA)
    {
        new compact[16], cidx = 0;
        for(new i = 0; i < strlen(input_plate); i++)
        {
            new ch = input_plate[i];
            if(ch == ' ' || ch == '-') continue;
            if(ch >= 'A' && ch <= 'Z') ch += ('a' - 'A');
            if(cidx >= sizeof(compact) - 1) return false;
            compact[cidx++] = ch;
        }
        compact[cidx] = '\0';

        if(strlen(compact) != 8) return false;
        if(!PlateIsAllowedLatinLetter(compact[0]) || !PlateIsAllowedLatinLetter(compact[1])) return false;
        if(compact[2] < '0' || compact[2] > '9') return false;
        if(compact[3] < '0' || compact[3] > '9') return false;
        if(compact[4] < '0' || compact[4] > '9') return false;
        if(compact[5] < '0' || compact[5] > '9') return false;
        if(!PlateIsAllowedLatinLetter(compact[6]) || !PlateIsAllowedLatinLetter(compact[7])) return false;

        format(output_plate, output_size, "%s", compact);
        return true;
    }

    if(plate_type == TYPE_BY)
    {
        new compact[16], cidx = 0;
        for(new i = 0; i < strlen(input_plate); i++)
        {
            new ch = input_plate[i];
            if(ch == ' ' || ch == '-') continue;
            if(ch >= 'A' && ch <= 'Z') ch += ('a' - 'A');
            if(cidx >= sizeof(compact) - 1) return false;
            compact[cidx++] = ch;
        }
        compact[cidx] = '\0';

        if(strlen(compact) != 7) return false;
        if(compact[0] < '0' || compact[0] > '9') return false;
        if(compact[1] < '0' || compact[1] > '9') return false;
        if(compact[2] < '0' || compact[2] > '9') return false;
        if(compact[3] < '0' || compact[3] > '9') return false;
        if(!PlateIsAllowedLatinLetter(compact[4]) || !PlateIsAllowedLatinLetter(compact[5])) return false;
        if(compact[6] < '0' || compact[6] > '9') return false;

        format(output_plate, output_size, "%s", compact);
        return true;
    }

    new idx = 0;
    for(new i = 0; i < strlen(input_plate); i++)
    {
        new ch = input_plate[i];

        if(ch == ' ' || ch == '-')
        {
            continue;
        }

        if(ch >= 'A' && ch <= 'Z')
        {
            ch += ('a' - 'A');
        }

        if(idx >= output_size - 1)
        {
            return false;
        }

        output_plate[idx++] = ch;
    }

    output_plate[idx] = '\0';

    switch(plate_type)
    {
        case TYPE_RU:
        {
            if(strlen(output_plate) != 6) return false;
            if(!PlateIsAllowedLatinLetter(output_plate[0])) return false;
            if(output_plate[1] < '0' || output_plate[1] > '9') return false;
            if(output_plate[2] < '0' || output_plate[2] > '9') return false;
            if(output_plate[3] < '0' || output_plate[3] > '9') return false;
            if(!PlateIsAllowedLatinLetter(output_plate[4])) return false;
            if(!PlateIsAllowedLatinLetter(output_plate[5])) return false;
        }
        case TYPE_KZ:
        {
            if(strlen(output_plate) != 6) return false;
            if(output_plate[0] < '0' || output_plate[0] > '9') return false;
            if(output_plate[1] < '0' || output_plate[1] > '9') return false;
            if(output_plate[2] < '0' || output_plate[2] > '9') return false;
            if(!PlateIsAllowedLatinLetter(output_plate[3])) return false;
            if(!PlateIsAllowedLatinLetter(output_plate[4])) return false;
            if(!PlateIsAllowedLatinLetter(output_plate[5])) return false;
        }
        default:
        {
            return false;
        }
    }

    return true;
}

stock bool:NormalizeAndValidatePlateRegion(plate_type, const input_region[], output_region[], output_size)
{
    output_region[0] = '\0';

    if(!PlateTypeUsesRegion(plate_type))
    {
        return true;
    }

    new idx = 0;
    for(new i = 0; i < strlen(input_region); i++)
    {
        new ch = input_region[i];

        if(ch == ' ')
        {
            continue;
        }

        if(ch < '0' || ch > '9')
        {
            return false;
        }

        if(idx >= output_size - 1)
        {
            return false;
        }

        output_region[idx++] = ch;
    }

    output_region[idx] = '\0';

    return (strlen(output_region) >= 2 && strlen(output_region) <= 3);
}

stock CalculateDonatePlatePriceByText(plate_type, const plate_text[], const region_text[], fallback_price)
{
    new plate_digits[4], plate_digits_count = 0;
    for(new i = 0; i < strlen(plate_text) && plate_digits_count < 3; i++)
    {
        if(plate_text[i] >= '0' && plate_text[i] <= '9')
        {
            plate_digits[plate_digits_count++] = plate_text[i] - '0';
        }
    }

    if(plate_digits_count < 3)
    {
        return (fallback_price > 0) ? fallback_price : 1085;
    }

    new d1 = plate_digits[0];
    new d2 = plate_digits[1];
    new d3 = plate_digits[2];

    new score = 0;
    if(d1 == d2 && d2 == d3)
    {
        score = 42;
    }
					else if(d1 == d2 || d2 == d3 || d1 == d3)
    {
        score = 37;
    }
					else
    {
        score = -1;

        if(d1 == 0 || d2 == 0 || d3 == 0)
        {
            score += 18;
        }
    }

    if(d1 == 7) score += 5;
    if(d2 == 7) score += 5;
    if(d3 == 7) score += 5;

    if(PlateTypeUsesRegion(plate_type))
    {
        new region_digits = 0;
        for(new i = 0; i < strlen(region_text); i++)
        {
            if(region_text[i] >= '0' && region_text[i] <= '9')
            {
                region_digits++;
            }
        }

        if(region_digits >= 3)
        {
            score += 10;
        }
    }

    if(score <= 0)
    {
        return (fallback_price > 0) ? fallback_price : 1085;
    }

    return score * 100 + 85;
}

stock BuildStoredPlateValue(plate_type, plate[], region[], dest[], size)
{
    if(PlateTypeUsesRegion(plate_type))
    {
        format(dest, size, "%d|%s|%s", plate_type, plate, region);
    }
					else
    {
        format(dest, size, "%d|%s|", plate_type, plate);
    }
    return 1;
}

stock bool:ParseStoredPlateValue(stored[], &plate_type, plate[], plate_size, region[], region_size)
{
    plate_type = TYPE_RU;
    plate[0] = '\0';
    region[0] = '\0';

    if(!strlen(stored))
    {
        return false;
    }

    new first = strfind(stored, "|");
    if(first != -1)
    {
        new second = strfind(stored, "|", false, first + 1);
        if(second != -1)
        {
            new tbuf[8];
            strmid(tbuf, stored, 0, first, sizeof(tbuf));

            plate_type = strval(tbuf);
            if(plate_type < TYPE_RU || plate_type > TYPE_KZ)
            {
                plate_type = TYPE_RU;
            }

            strmid(plate, stored, first + 1, second, plate_size);
            strmid(region, stored, second + 1, strlen(stored), region_size);

            return (strlen(plate) > 0);
        }
    }

    format(plate, plate_size, "%s", stored);

    switch(strlen(plate))
    {
        case 8: plate_type = TYPE_UA;
        case 7: plate_type = TYPE_BY;
        default: plate_type = TYPE_RU;
    }

    if(PlateTypeUsesRegion(plate_type))
    {
        format(region, region_size, "");
    }

    return true;
}

stock ApplyOwnableCarStoredPlate(vehicleid, idx)
{
    new plate_type;
    new plate[16], region[8];

    if(!ParseStoredPlateValue(g_ownable_car[idx][OC_NUMBER], plate_type, plate, sizeof(plate), region, sizeof(region)))
    {
        format(plate, sizeof(plate), "");
        plate_type = TYPE_RU;
        format(region, sizeof(region), "");
    }

    SetVehicleNumberPlateEx(vehicleid, plate_type, plate, region);
    return 1;
}

stock bool:IsPlayerNearVehicleForPlate(playerid, vehicleid, Float:range = 8.0)
{
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return false;
    }

    if(!IsValidVehicle(vehicleid))
    {
        return false;
    }

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(vehicleid, vx, vy, vz);

    return IsPlayerInRangeOfPoint(playerid, range, vx, vy, vz);
}

stock bool:Inventory11_SavePlateData(playerid, slot, plate_type, plate[], region[])
{
    new account_id = GetPlayerAccountID(playerid);
    printf("[INV11][TRACE] SavePlateData start: player=%d account_id=%d slot=%d type=%d plate=%s region=%s errno_pre=%d", playerid, account_id, slot, plate_type, plate, region, mysql_errno());

    if(account_id <= 0)
    {
        printf("[INV11][ERROR] SavePlateData skipped: invalid account_id=%d player=%d slot=%d", account_id, playerid, slot);
        return false;
    }

    new query[384];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO inventory_plates (account_id, slot, plate_type, plate_number, plate_region) VALUES (%d, %d, %d, '%e', '%e') ON DUPLICATE KEY UPDATE plate_type = VALUES(plate_type), plate_number = VALUES(plate_number), plate_region = VALUES(plate_region)",
        account_id, slot, plate_type, plate, region
    );
    printf("[INV11][SQL] SavePlateData UPSERT: %s", query);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] SavePlateData failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        return false;
    }

    printf("[INV11][TRACE] SavePlateData success: player=%d account_id=%d slot=%d type=%d errno=%d", playerid, account_id, slot, plate_type, mysql_errno());
    return true;
}

stock bool:Inventory11_GetPlateData(playerid, slot, &plate_type, plate[], plate_size, region[], region_size)
{
    plate_type = TYPE_RU;
    plate[0] = '\0';
    region[0] = '\0';

    new account_id = GetPlayerAccountID(playerid);
    printf("[INV11][TRACE] GetPlateData start: player=%d account_id=%d slot=%d errno_pre=%d", playerid, account_id, slot, mysql_errno());

    if(account_id <= 0)
    {
        printf("[INV11][ERROR] GetPlateData skipped: invalid account_id=%d player=%d slot=%d", account_id, playerid, slot);
        return false;
    }

    new query[196];
    mysql_format(mysql, query, sizeof(query), "SELECT plate_type, plate_number, plate_region FROM inventory_plates WHERE account_id = %d AND slot = %d LIMIT 1", account_id, slot);
    printf("[INV11][SQL] GetPlateData SELECT: %s", query);
    new Cache:result = mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] GetPlateData failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        cache_delete(result);
        return false;
    }

    new rows = cache_num_rows(result);
    if(rows <= 0)
    {
        printf("[INV11][WARN] GetPlateData empty: player=%d account_id=%d slot=%d errno=%d", playerid, account_id, slot, mysql_errno());
        cache_delete(result);
        return false;
    }

    plate_type = cache_get_field_content_int(0, "plate_type");
    cache_get_field_content(0, "plate_number", plate, mysql, plate_size);
    cache_get_field_content(0, "plate_region", region, mysql, region_size);
    cache_delete(result);

    if(plate_type < TYPE_RU || plate_type > TYPE_KZ)
    {
        printf("[INV11][WARN] GetPlateData invalid plate_type=%d slot=%d fallback=TYPE_RU", plate_type, slot);
        plate_type = TYPE_RU;
    }

    new bool:has_data = (strlen(plate) > 0);
    printf("[INV11][TRACE] GetPlateData end: player=%d slot=%d rows=%d type=%d plate=%s region=%s has_data=%d errno=%d", playerid, slot, rows, plate_type, plate, region, has_data, mysql_errno());
    return has_data;
}

stock bool:Inventory11_DeletePlateData(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    printf("[INV11][TRACE] DeletePlateData start: player=%d account_id=%d slot=%d errno_pre=%d", playerid, account_id, slot, mysql_errno());

    if(account_id <= 0)
    {
        printf("[INV11][ERROR] DeletePlateData skipped: invalid account_id=%d player=%d slot=%d", account_id, playerid, slot);
        return false;
    }

    new query[180];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM inventory_plates WHERE account_id = %d AND slot = %d", account_id, slot);
    printf("[INV11][SQL] DeletePlateData DELETE: %s", query);
    mysql_query(mysql, query, true);

    if(mysql_errno())
    {
        printf("[INV11][ERROR] DeletePlateData failed errno=%d account_id=%d slot=%d query=%s", mysql_errno(), account_id, slot, query);
        return false;
    }

    printf("[INV11][TRACE] DeletePlateData success: player=%d account_id=%d slot=%d errno=%d", playerid, account_id, slot, mysql_errno());
    return true;
}

stock bool:Inventory11_SwapPlateDataSlots(playerid, old_slot, new_slot)
{
    if(old_slot == new_slot)
    {
        printf("[INV11][TRACE] SwapPlateData skip: player=%d slot=%d", playerid, old_slot);
        return true;
    }

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        printf("[INV11][ERROR] SwapPlateData skipped: invalid account_id=%d player=%d old=%d new=%d", account_id, playerid, old_slot, new_slot);
        return false;
    }

    new query[196];
    new temp_slot = 900000 + old_slot;

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory_plates SET slot = %d WHERE account_id = %d AND slot = %d", temp_slot, account_id, old_slot);
    printf("[INV11][SQL] SwapPlateData step1: %s", query);
    mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] SwapPlateData step1 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return false;
    }
    printf("[INV11][TRACE] SwapPlateData step1 ok errno=%d", mysql_errno());

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory_plates SET slot = %d WHERE account_id = %d AND slot = %d", old_slot, account_id, new_slot);
    printf("[INV11][SQL] SwapPlateData step2: %s", query);
    mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] SwapPlateData step2 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return false;
    }
    printf("[INV11][TRACE] SwapPlateData step2 ok errno=%d", mysql_errno());

    mysql_format(mysql, query, sizeof(query), "UPDATE inventory_plates SET slot = %d WHERE account_id = %d AND slot = %d", new_slot, account_id, temp_slot);
    printf("[INV11][SQL] SwapPlateData step3: %s", query);
    mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        printf("[INV11][ERROR] SwapPlateData step3 failed errno=%d account_id=%d old=%d new=%d query=%s", mysql_errno(), account_id, old_slot, new_slot, query);
        return false;
    }

    printf("[INV11][TRACE] SwapPlateData success: player=%d account_id=%d old=%d new=%d errno=%d", playerid, account_id, old_slot, new_slot, mysql_errno());
    return true;
}
