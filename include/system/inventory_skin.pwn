// Инвентарь
#define DIALOG_INVENTORY_MAIN       1788
#define DIALOG_MYSKINS_LIST         1789
#define DIALOG_MYSKINS_ACTIONS      1790
#define DIALOG_MYACCS_LIST          1791
#define DIALOG_MYACCS_ACTIONS       1792

// Редактор аксессуаров
#define DIALOG_EDITACS_MAIN         1793
#define DIALOG_EDITACS_PARAMS       1794
#define DIALOG_EDITACS_ACTIONS      1795
#define DIALOG_EDITACS_INPUT        1796
#define DIALOG_EDITACS_BONE         1797
#define DIALOG_EDITACS_SUBPARAMS    1798

// Лимиты
#define MAX_PLAYER_SKINS            100
#define MAX_PLAYER_ACCESSORIES      100

#define DIALOG_EDITACS_NEW_MAIN         1799
#define DIALOG_EDITACS_NEW_ACTIONS      1800

// ========== ENUMS ==========
enum E_PLAYER_SKIN_DATA
{
    skindb_id,
    skindb_game_id,
    skindb_in_use
}

enum E_PLAYER_ACC_DATA
{
    accdb_id,
    accdb_model,
    accdb_bone,
    Float:accdb_x,
    Float:accdb_y,
    Float:accdb_z,
    Float:accdb_rot_x,
    Float:accdb_rot_y,
    Float:accdb_rot_z,
    Float:accdb_scale_x,
    Float:accdb_scale_y,
    Float:accdb_scale_z,
    accdb_in_use
}

enum E_ACCS_DATA
{
    accModel,
    accBone,
    Float:accX,
    Float:accY,
    Float:accZ,
    Float:accRotX,
    Float:accRotY,
    Float:accRotZ,
    Float:accScaleX,
    Float:accScaleY,
    Float:accScaleZ
}

// ========== ПЕРЕМЕННЫЕ ==========
new PlayerSkinsData[MAX_PLAYERS][MAX_PLAYER_SKINS][E_PLAYER_SKIN_DATA];
new PlayerSkinsCount[MAX_PLAYERS];

new PlayerAccsData[MAX_PLAYERS][MAX_PLAYER_ACCESSORIES][E_PLAYER_ACC_DATA];
new PlayerAccsCount[MAX_PLAYERS];

new Float:gPlayerTempAccData[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][11];

// ========== ДАННЫЕ АКСЕССУАРОВ ==========
new AccsData[][E_ACCS_DATA] = {
    {4196, 1, 0.049998, -0.280000, 0.000000, 10.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 0 Крылья бабочки
    {5374, 1, 0.149999, -0.170000, -0.019999, 0.000000, 90.000000, -175.000000, 1.000000, 1.000000, 1.000000}, // 1 Череп Воробья
    {4199, 1, 0.079999, -0.129999, 0.000000, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 2 Реактивный ранец
    {14574, 1, 0.049999, -0.280000, 0.000000, 10.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 3 Крылья демона
    {18377, 2, 0.089999, 0.049999, -0.009999, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 4 Очки сердечки
    {18392, 2, 0.089999, 0.049999, -0.009999, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 5 Очки огни
    {14593, 1, -0.069999, -0.119999, -0.009999, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 6 Карамельные крылья
    {7369, 6, 0.240000, 0.000000, 0.000000, 0.000000, -90.000000, -100.000000, 1.000000, 1.000000, 1.000000}, // 7 Кейс черный
    {4197, 2, 0.119999, 0.049999, 0.000000, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 8 Маска пчелы
    {5383, 2, 0.219999, -0.029999, -0.049999, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 9 Шляпа пират бп
    {1747, 2, 0.159999, 0.000000, -0.009999, 45.000000, 95.000000, -225.000000, 1.000000, 1.000000, 1.000000}, // 10 Нов. год Hello kitty 1
    {1729, 17, -0.089999, 0.049998, 0.000000, 105.000000, 60.000000, 90.000000, 1.000000, 1.000000, 1.000000}, // 11 Нов. год шарф
    {5378, 7, 0.099999, 0.029999, -0.069999, 5.000000, -90.000000, -5.000000, 1.000000, 1.000000, 1.000000}, // 12 Меч короля пиратов
    {18409, 2, 0.089999, 0.049999, -0.009999, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 13 Очки снежинки
    {5384, 6, 0.240000, 0.000000, 0.000000, 0.000000, -90.000000, -100.000000, 1.000000, 1.000000, 1.000000}, // 14 Фонарь пирата
    {13740, 6, 0.240000, 0.000000, 0.000000, 0.000000, -90.000000, -100.000000, 1.000000, 1.000000, 1.000000}, // 15 Кейс Градиент
    {13736, 2, 0.189999, -0.029999, -0.069999, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 16 Венок
    {13744, 2, 0.189999, -0.029999, -0.069999, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 17 Бабочки
    {18502, 2, 0.119999, 0.049999, 0.000000, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 18 Маска троля
    {18504, 2, 0.119999, 0.049999, 0.000000, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 19 Троль с париком
    {18503, 2, 0.119999, 0.049999, 0.000000, 0.000000, 85.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 20 Инопланетянин
    {916, 1, -0.17, -0.029998, -0.079998, -30.0, 75.0, -155.0, 1.000000, 1.000000, 1.000000}, // 21 Спортивная сумка Supreme
    {1783, 2, 0.20, 0.019999, 0.000000, 168.800003, 92.389999, 7.489999, 1.000000, 1.000000, 1.000000}, // 22 Маска снеговика
    {18396, 2, 0.039998, -0.029998, -0.009998, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 23 Шапка гнома с бородой
    {18576, 15, -0.09999, 0.000000, 0.000000, 180.000000, -90.000000, 20.000000, 1.000000, 1.000000, 1.000000}, // 24 Вертолет
    {18403, 2, 0.059999, 0.000000, 0.000000, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 25 Маска тигра
    {14575, 1, 0.159999, -0.070000, 0.000000, 0.000000, 90.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 26 Крылья ангела
    {907, 1, 0.069999, -0.039999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000}, // 27 Рюкзак LV
    {7368, 6, 0.240000, 0.000000, 0.000000, 0.000000, -90.000000, -100.000000, 1.000000, 1.000000, 1.000000}, // 28 Кейс (2)
    {7367, 6, 0.240000, 0.000000, 0.000000, 0.000000, -90.000000, -100.000000, 1.000000, 1.000000, 1.000000}, // 29 Кожаный кейс
    {4198, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 30 Кленовая корона
    {4200, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 31 Кленовая сумка
    {4201, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 32 Метла
    {4203, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 33 Рюкзак с овощами
    {4204, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 34 Школьный рюкзак
    {4205, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 35 Шапка - подсолнух
    {4206, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 36 Черный зонт
    {4207, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 37 Зонт с листьями
    {4208, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 38 Розовый зонт
    {15134, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 39 Рюкзак инопланетянин
    {15135, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 40 Шляпа ведьмы
    {15136, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 41 Шляпа ведьмы
    {15137, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 42 Шляпа ведьмы
    {15138, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 43 Шляпа звезды
    {15139, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 44 Красная шляпа ведьмы
    {15140, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 45 Шляпа ведьмы
    {15141, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 46 Шляпа ведьмы
    {15142, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 47 Железная коса
    {15143, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 48 Металлическая коса
    {15144, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 49 Светящиеся красная маска
    {15145, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 50 Маска маньяка
    {15146, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 51 Плачущая маска
    {15147, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 52 Страшная маска
    {15149, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 53 Метла
    {15150, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 54 Рюкзак FnaF
    {15151, 2, 0.08999, 0.121109, -0.010001, 0.0, 450.0, 0.0, 1.0, 1.0, 1.0}, // 55 Маска ведущего
    {15152, 2, 0.08999, 0.121109, -0.010001, 0.0, 450.0, 0.0, 1.0, 1.0, 1.0}, // 56 Светящаяся синяя маска
    {15153, 2, 0.08999, 0.121109, -0.010001, 0.0, 450.0, 0.0, 1.0, 1.0, 1.0}, // 57 Светящаяся фиолетовая маска
    {18513, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 58 Корона короля
    {18509, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 59 Кейс макита
    {18414, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 60 Очки прямые варнинг
    {18500, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}, // 61 Маска клоуна
    {18501, 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0}  // 62 Маска клоуна 2
};

// Названия аксессуаров
new const AccsNames[][] = {
    "Крылья бабочки", "Череп Воробья", "Реактивный ранец", "Крылья демона", "Очки сердечки",
    "Очки огни", "Карамельные крылья", "Кейс черный", "Маска пчелы", "Шляпа пират бп",
    "Нов. год Hello kitty 1", "Нов. год шарф", "Меч короля пиратов", "Очки снежинки", "Фонарь пирата",
    "Кейс Градиент", "Венок", "Бабочки", "Маска троля", "Троль с париком",
    "Инопланетянин", "Спортивная сумка Supreme", "Маска снеговика", "Шапка гнома с бородой", "Вертолет",
    "Маска тигра", "Крылья ангела", "Рюкзак LV", "Кейс (2)", "Кожаный кейс",
    "Кленовая корона", "Кленовая сумка", "Метла", "Рюкзак с овощами", "Школьный рюкзак",
    "Шапка - подсолнух", "Черный зонт", "Зонт с листьями", "Розовый зонт", "Рюкзак инопланетянин",
    "Шляпа ведьмы (черная)", "Шляпа ведьмы (темная)", "Шляпа ведьмы (серая)", "Шляпа звезды", "Красная шляпа ведьмы",
    "Шляпа ведьмы (фиолетовая)", "Шляпа ведьмы (зеленая)", "Железная коса", "Металлическая коса", "Светящаяся красная маска",
    "Маска маньяка", "Плачущая маска", "Страшная маска", "Метла (хэллоуин)", "Рюкзак FnaF",
    "Маска ведущего", "Светящаяся синяя маска", "Светящаяся фиолетовая маска", "Корона короля", "Кейс макита",
    "Очки прямые варнинг", "Маска клоуна", "Маска клоуна 2"
};

// ========== ФУНКЦИЯ ПОЛУЧЕНИЯ НАЗВАНИЯ СКИНА ==========
stock GetSkinNameByGameId(game_id)
{
    new name[128];
    
    switch(game_id)
    {
        case 2: format(name, sizeof name, "Рикардо Милос");
        case 5: format(name, sizeof name, "Известный блогер");
        case 10: format(name, sizeof name, "Девочка-кролик");
        case 22: format(name, sizeof name, "Советский солдат М");
        case 23: format(name, sizeof name, "Советский солдат Ж");
        case 24: format(name, sizeof name, "Дед Мороз");
        case 48: format(name, sizeof name, "Заключенный М");
        case 49: format(name, sizeof name, "Игрок 001");
        case 53: format(name, sizeof name, "Игрок 067");
        case 57: format(name, sizeof name, "Известный эксперт");
        case 62: format(name, sizeof name, "Темный лорд");
        case 63: format(name, sizeof name, "Заключенный Ж");
        case 86: format(name, sizeof name, "Пивозавр");
        case 88: format(name, sizeof name, "Дед Мороз голубой");
        case 89: format(name, sizeof name, "Мальчик один дома");
        case 92: format(name, sizeof name, "Девушка на коньках");
        case 95: format(name, sizeof name, "Мексу Вещает");
        case 99: format(name, sizeof name, "Мужчина на коньках");
        case 106: format(name, sizeof name, "Известный блогер");
        case 108: format(name, sizeof name, "Известный блогер");
        case 109: format(name, sizeof name, "Известный блогер");
        case 110: format(name, sizeof name, "Известный блогер");
        case 122: format(name, sizeof name, "Фирменная одежда BR");
        case 129: format(name, sizeof name, "Шляпник");
        case 130: format(name, sizeof name, "Санта Клаус");
        case 160: format(name, sizeof name, "Игрок 456");
        case 162: format(name, sizeof name, "Известный футболист");
        case 165: format(name, sizeof name, "Илон Маск");
        case 166: format(name, sizeof name, "Известный блогер");
        case 174: format(name, sizeof name, "Даня Милохин");
        case 175: format(name, sizeof name, "Крик");
        case 196: format(name, sizeof name, "Снегурочка");
        case 197: format(name, sizeof name, "Девочка-кролик");
        case 199: format(name, sizeof name, "Девушка клоун");
        case 200: format(name, sizeof name, "Известный стример");
        case 202: format(name, sizeof name, "Известный рэпер");
        case 204: format(name, sizeof name, "Известный геймер");
        case 208: format(name, sizeof name, "Страшный друг");
        case 210: format(name, sizeof name, "Известный футболист");
        case 220: format(name, sizeof name, "Профессор-маг");
        case 224: format(name, sizeof name, "Пивозавр");
        case 225: format(name, sizeof name, "Аниме-тян");
        case 229: format(name, sizeof name, "Известный блогер");
        case 231: format(name, sizeof name, "Ведьма Ди");
        case 232: format(name, sizeof name, "Красавица");
        case 234: format(name, sizeof name, "Председатель");
        case 235: format(name, sizeof name, "Известный блогер");
        case 236: format(name, sizeof name, "Барыга");
        case 243: format(name, sizeof name, "Снегурочка");
        case 245: format(name, sizeof name, "Снегурочка");
        case 249: format(name, sizeof name, "Президент");
        case 252: format(name, sizeof name, "Игла");
        case 262: format(name, sizeof name, "Убийца");
        case 264: format(name, sizeof name, "Злой клоун");
        case 266: format(name, sizeof name, "Скелетон");
        case 267: format(name, sizeof name, "Джеймс Бонд");
        case 269: format(name, sizeof name, "Красавчик");
        case 270: format(name, sizeof name, "Муханов Кирилл");
        case 283: format(name, sizeof name, "Аристократ");
        case 298: format(name, sizeof name, "Леди");
        case 301: format(name, sizeof name, "Иван Блогер");
        case 302: format(name, sizeof name, "Блогер");
        case 310: format(name, sizeof name, "Саша бандит");
        case 311: format(name, sizeof name, "Бандит боксер");
        case 5323: format(name, sizeof name, "Вурдалак");
        case 5325: format(name, sizeof name, "Новогодний пингвин");
        case 5326: format(name, sizeof name, "Снеговик");
        case 5362: format(name, sizeof name, "Дюшес");
        case 5365: format(name, sizeof name, "Маньяк");
        case 5367: format(name, sizeof name, "Маньяк Майерс");
        case 6780: format(name, sizeof name, "Элегантная леди");
        case 6832: format(name, sizeof name, "Блогер Enzo");
        case 6871: format(name, sizeof name, "Масленников");
        case 6872: format(name, sizeof name, "INSTASAMKA");
        case 6892: format(name, sizeof name, "Женщина кошка");
        case 6893: format(name, sizeof name, "Горячий мужчина");
        case 6894: format(name, sizeof name, "Посейдон");
        case 6895: format(name, sizeof name, "Сотрудник Фирмы");
        case 6896: format(name, sizeof name, "Бизнес Леди");
        case 11917: format(name, sizeof name, "Хоуми");
        case 11933: format(name, sizeof name, "Алишер");
        case 11934: format(name, sizeof name, "Толстый Алишер");
        case 11935: format(name, sizeof name, "Мент");
        case 11944: format(name, sizeof name, "Даня Милохин");
        case 11947: format(name, sizeof name, "Мейстер");
        case 11948: format(name, sizeof name, "Всадник");
        case 11951: format(name, sizeof name, "Маг волшебник");
        case 11953: format(name, sizeof name, "Страж Замка");
        case 11956: format(name, sizeof name, "Аленушка");
        case 11957: format(name, sizeof name, "Знахарь");
        case 11958: format(name, sizeof name, "Пчелка убийца");
        case 11959: format(name, sizeof name, "Байкер");
        case 11961: format(name, sizeof name, "Рыбачка");
        case 11962: format(name, sizeof name, "Рыбак");
        case 12291: format(name, sizeof name, "Солдатка");
        case 12293: format(name, sizeof name, "Емеля");
        case 14386: format(name, sizeof name, "Бархатные тяги");
        case 14388: format(name, sizeof name, "Бархатные тяги особые");
        case 18606: format(name, sizeof name, "Поззи");
        case 18620: format(name, sizeof name, "Бандит BEE");
        case 18621: format(name, sizeof name, "Бандит ТТ");
        case 18623: format(name, sizeof name, "Бандит стилевый");
        case 18624: format(name, sizeof name, "Бандит ровный");
        case 18625: format(name, sizeof name, "Бандит ДИМООООН");
        case 18626: format(name, sizeof name, "Бандит рама");
        case 18628: format(name, sizeof name, "Бандит азиат");
        case 19262: format(name, sizeof name, "Опасный мужчина");
        case 19273: format(name, sizeof name, "Бабуля Нюра");
        default: format(name, sizeof name, "Скин %d", game_id);
    }
    
    return name;
}

// ========== КОМАНДА ОТКРЫТИЯ ГЛАВНОГО МЕНЮ ИНВЕНТАРЯ ==========
CMD:inventory(playerid)
{
    ShowInventoryMainMenu(playerid);
    return 1;
}

// Альтернативная команда
CMD:inv(playerid)
{
    return callcmd::inventory(playerid, "");
}

// ========== ГЛАВНОЕ МЕНЮ ИНВЕНТАРЯ ==========
stock ShowInventoryMainMenu(playerid)
{
    new dialog_text[512];
    
    strcat(dialog_text, "{FAD201}номер\t{FAD201}категория\t{FAD201}описание кнопки\n");
    strcat(dialog_text, "{FFFFFF}1\t{FF5C5C}Мои скины\t{FFFFFF}Просмотр скинов\n");
    strcat(dialog_text, "{FFFFFF}2\t{FFFFFF}Мои аксессуары\t{FFFFFF}Просмотр аксессуаров\n");
    
    ShowPlayerDialog(playerid, DIALOG_INVENTORY_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Инвентарь {FFFFFF}| Выберите нужное Вам меню инвентаря",
        dialog_text,
        "Выбрать", "Отмена"
    );
    
    return 1;
}

// ========== КОМАНДА ДЛЯ СКИНОВ (СТАРАЯ) ==========
CMD:myskins(playerid)
{
    LoadPlayerSkins(playerid);
    return 1;
}

// ========== ЗАГРУЗКА СКИНОВ ИГРОКА ==========
stock LoadPlayerSkins(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof query, 
        "SELECT id, game_id, use_skin FROM inventory_skins WHERE owner_skin=%d ORDER BY use_skin DESC, id ASC", 
        GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    
    new rows = cache_num_rows();
    
    if(!rows)
    {
        cache_delete(result);
        SCM(playerid, 2, 6, 0, 0, "Ваш инвентарь пуст", "Купите скины в донат-магазине");
        CheckDefaultSkin(playerid);
        return 1;
    }
    
    PlayerSkinsCount[playerid] = 0;
    
    new temp_str[32];
    for(new i = 0; i < rows && i < MAX_PLAYER_SKINS; i++)
    {
        cache_get_field_content(i, "id", temp_str);
        PlayerSkinsData[playerid][i][skindb_id] = strval(temp_str);
        
        cache_get_field_content(i, "game_id", temp_str);
        PlayerSkinsData[playerid][i][skindb_game_id] = strval(temp_str);
        
        cache_get_field_content(i, "use_skin", temp_str);
        PlayerSkinsData[playerid][i][skindb_in_use] = strval(temp_str);
        
        PlayerSkinsCount[playerid]++;
    }
    
    cache_delete(result);
    ShowPlayerSkinsDialog(playerid);
    return 1;
}

// ========== ПОКАЗАТЬ ДИАЛОГ СО СПИСКОМ СКИНОВ ==========
stock ShowPlayerSkinsDialog(playerid)
{
    new dialog_text[2048];
    
    strcat(dialog_text, "{FAD201}номер\t{FAD201}образ персонажа\t{FAD201}статус\n");
    
    for(new i = 0; i < PlayerSkinsCount[playerid]; i++)
    {
        new game_id = PlayerSkinsData[playerid][i][skindb_game_id];
        new in_use = PlayerSkinsData[playerid][i][skindb_in_use];
        new skin_name[128];
        
        format(skin_name, sizeof skin_name, "%s", GetSkinNameByGameId(game_id));
        
        strcat(dialog_text, "{FFFFFF}");
        
        new temp[16];
        valstr(temp, i + 1);
        strcat(dialog_text, temp);
        strcat(dialog_text, "\t");
        
        strcat(dialog_text, skin_name);
        strcat(dialog_text, " {999999}(ID: ");
        valstr(temp, game_id);
        strcat(dialog_text, temp);
        strcat(dialog_text, ")\t");
        
        if(in_use) strcat(dialog_text, "{FF0000}[ используется ]");
        else strcat(dialog_text, "{66CC00}[ в наличии ]");
        
        strcat(dialog_text, "\n");
    }
    
    ShowPlayerDialog(playerid, DIALOG_MYSKINS_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Инвентарь {FFFFFF}| Выберите скин для персонажа",
        dialog_text,
        "Выбрать", "Назад"
    );
    
    return 1;
}

// ========== МЕНЮ ДЕЙСТВИЙ СО СКИНОМ ==========
stock ShowSkinActionsDialog(playerid, listitem)
{
    if(listitem < 0 || listitem >= PlayerSkinsCount[playerid]) return 0;
    
    SetPVarInt(playerid, "selected_skin_listitem", listitem);
    
    new game_id = PlayerSkinsData[playerid][listitem][skindb_game_id];
    new in_use = PlayerSkinsData[playerid][listitem][skindb_in_use];
    
    new dialog_text[512];
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}номер\t{FAD201}действие\t{FAD201}описание\n"\
        "{FFFFFF}1.\t%s\t{999999}Использовать этот образ\n"\
        "{FFFFFF}2.\t{FF0000}Убрать\t{999999}Удалить из инвентаря",
        in_use ? "{999999}Применить" : "{66CC00}Применить"
    );
    
    ShowPlayerDialog(playerid, DIALOG_MYSKINS_ACTIONS, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Инвентарь {FFFFFF}| Управление скинами персонажа",
        dialog_text,
        "Выбрать", "Назад"
    );
    
    return 1;
}

// ========== КОМАНДА ДЛЯ АКСЕССУАРОВ (СТАРАЯ) ==========
CMD:myaccs(playerid)
{
    LoadPlayerAccessories(playerid);
    return 1;
}

// ========== ЗАГРУЗКА АКСЕССУАРОВ ИГРОКА ==========
stock LoadPlayerAccessories(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    
    if(account_id <= 0)
    {
        printf("[ERROR] LoadPlayerAccessories: Неверный account_id для playerid=%d", playerid);
        return 0;
    }
    
    // printf("[DEBUG] LoadPlayerAccessories: playerid=%d, account_id=%d", playerid, account_id);
    
    new query[512];
    mysql_format(mysql, query, sizeof query,
        "SELECT id, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z, in_use FROM inventory_accessories WHERE account_id=%d ORDER BY in_use DESC, id ASC",
        account_id);
    
    // printf("[DEBUG] SQL Query: %s", query);

// ДОБАВЬТЕ СРАЗУ ПОСЛЕ printf ЭТИ СТРОКИ:

    // ВАЖНО: Сбрасываем массив перед загрузкой
    PlayerAccsCount[playerid] = 0;
    for(new i = 0; i < MAX_PLAYER_ACCESSORIES; i++)
    {
        PlayerAccsData[playerid][i][accdb_id] = 0;
        PlayerAccsData[playerid][i][accdb_model] = 0;
        PlayerAccsData[playerid][i][accdb_in_use] = 0;
    }
    
    // Продолжается дальше...
    new Cache:result = mysql_query(mysql, query, true);
    
    new rows = cache_num_rows();
    
    // printf("[DEBUG] Найдено аксессуаров: %d", rows);
    
    if(!rows)
    {
        cache_delete(result);
        SCM(playerid, 2, 6, 0, 0, "У вас нет аксессуаров", "Купите их в донат-магазине");
        return 1;
    }
    
    PlayerAccsCount[playerid] = 0;
    
    new temp_str[32];
    for(new i = 0; i < rows && i < MAX_PLAYER_ACCESSORIES; i++)
    {
        cache_get_field_content(i, "id", temp_str);
        PlayerAccsData[playerid][i][accdb_id] = strval(temp_str);
        
        cache_get_field_content(i, "modelid", temp_str);
        PlayerAccsData[playerid][i][accdb_model] = strval(temp_str);
        
        cache_get_field_content(i, "bone", temp_str);
        PlayerAccsData[playerid][i][accdb_bone] = strval(temp_str);
        
        cache_get_field_content(i, "pos_x", temp_str);
        PlayerAccsData[playerid][i][accdb_x] = floatstr(temp_str);
        
        cache_get_field_content(i, "pos_y", temp_str);
        PlayerAccsData[playerid][i][accdb_y] = floatstr(temp_str);
        
        cache_get_field_content(i, "pos_z", temp_str);
        PlayerAccsData[playerid][i][accdb_z] = floatstr(temp_str);
        
        cache_get_field_content(i, "rot_x", temp_str);
        PlayerAccsData[playerid][i][accdb_rot_x] = floatstr(temp_str);
        
        cache_get_field_content(i, "rot_y", temp_str);
        PlayerAccsData[playerid][i][accdb_rot_y] = floatstr(temp_str);
        
        cache_get_field_content(i, "rot_z", temp_str);
        PlayerAccsData[playerid][i][accdb_rot_z] = floatstr(temp_str);
        
        cache_get_field_content(i, "scale_x", temp_str);
        PlayerAccsData[playerid][i][accdb_scale_x] = floatstr(temp_str);
        
        cache_get_field_content(i, "scale_y", temp_str);
        PlayerAccsData[playerid][i][accdb_scale_y] = floatstr(temp_str);
        
        cache_get_field_content(i, "scale_z", temp_str);
        PlayerAccsData[playerid][i][accdb_scale_z] = floatstr(temp_str);
        
        cache_get_field_content(i, "in_use", temp_str);
        PlayerAccsData[playerid][i][accdb_in_use] = strval(temp_str);
        
        PlayerAccsCount[playerid]++;
    }
    
    cache_delete(result);
    
    // printf("[DEBUG] Загружено аксессуаров в массив: %d", PlayerAccsCount[playerid]);
    
    ShowPlayerAccsDialog(playerid);
    return 1;
}

// Функция получения названия по modelid
stock GetAccessoryNameByModelId(modelid)
{
    new name[64] = "Неизвестный предмет";
    
    for(new i = 0; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid)
        {
            if(i < sizeof(AccsNames))
            {
                format(name, sizeof name, "%s", AccsNames[i]);
            }
            break;
        }
    }
    
    return name;
}

// ========== ПОКАЗАТЬ ДИАЛОГ СО СПИСКОМ АКСЕССУАРОВ ==========
stock ShowPlayerAccsDialog(playerid)
{
    new dialog_text[2048];
    
    strcat(dialog_text, "{FAD201}номер\t{FAD201}наименование\t{FAD201}статус\n");
    
    for(new i = 0; i < PlayerAccsCount[playerid]; i++)
    {
        new model = PlayerAccsData[playerid][i][accdb_model];
        new in_use = PlayerAccsData[playerid][i][accdb_in_use];
        
        // Получаем название аксессуара
        new acc_name[64];
        format(acc_name, sizeof acc_name, "%s", GetAccessoryNameByModelId(model));
        
        strcat(dialog_text, "{FFFFFF}");
        
        new temp[16];
        valstr(temp, i + 1);
        strcat(dialog_text, temp);
        strcat(dialog_text, "\t");
        
        strcat(dialog_text, acc_name);
        strcat(dialog_text, " {999999}(ID: ");
        valstr(temp, model);
        strcat(dialog_text, temp);
        strcat(dialog_text, ")\t");
        
        if(in_use) strcat(dialog_text, "{FF0000}[ используется ]");
        else strcat(dialog_text, "{66CC00}[ в наличии ]");
        
        strcat(dialog_text, "\n");
    }
    
    ShowPlayerDialog(playerid, DIALOG_MYACCS_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Инвентарь {FFFFFF}| Выберите аксессуар",
        dialog_text,
        "Выбрать", "Назад"
    );
    
    return 1;
}

// ========== МЕНЮ ДЕЙСТВИЙ С АКСЕССУАРОМ ==========
stock ShowAccActionsDialog(playerid, listitem)
{
    if(listitem < 0 || listitem >= PlayerAccsCount[playerid]) return 0;
    
    SetPVarInt(playerid, "selected_acc_listitem", listitem);
    
    new in_use = PlayerAccsData[playerid][listitem][accdb_in_use];
    
    new dialog_text[512];
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}номер\t{FAD201}действие\t{FAD201}описание\n"\
        "{FFFFFF}1.\t%s\t{999999}Использовать/снять предмет\n"\
        "{FFFFFF}2.\t{FAD201}Редактировать\t{999999}Настроить расположение\n"\
        "{FFFFFF}3.\t{FF0000}Убрать\t{999999}Удалить из инвентаря",
        in_use ? "{FF0000}Снять" : "{66CC00}Надеть"
    );
    
    ShowPlayerDialog(playerid, DIALOG_MYACCS_ACTIONS, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Инвентарь {FFFFFF}| Управление аксессуарами",
        dialog_text,
        "Выбрать", "Назад"
    );
    
    return 1;
}

// ========== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ==========

// Для совместимости со старым кодом
stock GivePlayerOwnableSkin(playerid, skinid)
{
    new query[256];
    
    mysql_format(mysql, query, sizeof query, 
        "SELECT id FROM inventory_skins WHERE owner_skin=%d AND game_id=%d LIMIT 1", 
        GetPlayerAccountID(playerid), skinid);
    new Cache:result = mysql_query(mysql, query, true);
    
    new rows = cache_num_rows();
    cache_delete(result);
    
    if(rows > 0)
    {
        ShowNotification(playerid, 2, 6, 0, 0, "У вас уже есть этот скин", "Откройте /inventory");
        return 0;
    }
    
    mysql_format(mysql, query, sizeof query, 
        "INSERT INTO inventory_skins (owner_skin, game_id, use_skin) VALUES (%d, %d, 0)", 
        GetPlayerAccountID(playerid), skinid);
    mysql_query(mysql, query, false);
    
    new error = mysql_errno();
    
    if(error == 0)
    {
        ShowNotification(playerid, 3, 6, 0, 0, "Скин добавлен в инвентарь!", "Откройте /inventory");
        return 1;
    }
    else
    {
        new err_msg[128];
        format(err_msg, sizeof err_msg, "Не удалось сохранить скин (E:%d)", error);
        ShowNotification(playerid, 0, 6, 0, 0, err_msg, " ");
        return 0;
    }
}

// Функция выдачи аксессуара в инвентарь
stock GivePlayerOwnableAccessory(playerid, modelid)
{
    new query[512];
    
    // Проверяем, есть ли уже этот аксессуар
    mysql_format(mysql, query, sizeof query, 
        "SELECT id FROM inventory_accessories WHERE account_id=%d AND modelid=%d LIMIT 1", 
        GetPlayerAccountID(playerid), modelid);
    new Cache:result = mysql_query(mysql, query, true);
    
    new rows = cache_num_rows();
    cache_delete(result);
    
    if(rows > 0)
    {
        ShowNotification(playerid, 2, 6, 0, 0, "У вас уже есть этот аксессуар", "Откройте /inventory");
        return 0;
    }
    
    // Ищем настройки в AccsData
    new acc_index = -1;
    for(new i = 0; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid)
        {
            acc_index = i;
            break;
        }
    }
    
    // Если есть настройки - используем их, если нет - дефолтные (0, 0, 0...)
    if(acc_index != -1)
    {
        // Добавляем с настройками из AccsData
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO inventory_accessories (account_id, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z, in_use, slot) "\
            "VALUES (%d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, 0, -1)",
            GetPlayerAccountID(playerid),
            modelid,
            AccsData[acc_index][accBone],
            AccsData[acc_index][accX], AccsData[acc_index][accY], AccsData[acc_index][accZ],
            AccsData[acc_index][accRotX], AccsData[acc_index][accRotY], AccsData[acc_index][accRotZ],
            AccsData[acc_index][accScaleX], AccsData[acc_index][accScaleY], AccsData[acc_index][accScaleZ]
        );
    }
    else
    {
        // Добавляем с дефолтными настройками (кость 2 = голова, остальное 0)
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO inventory_accessories (account_id, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z, in_use, slot) "\
            "VALUES (%d, %d, 2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, -1)",
            GetPlayerAccountID(playerid),
            modelid
        );
    }
    
    mysql_query(mysql, query, false);
    
    new error = mysql_errno();
    
    if(error == 0)
    {
        ShowNotification(playerid, 3, 6, 0, 0, "Аксессуар добавлен!", "Откройте /inventory");
        return 1;
    }
    else
    {
        new err_msg[128];
        format(err_msg, sizeof err_msg, "Не удалось сохранить аксессуар (E:%d)", error);
        ShowNotification(playerid, 0, 6, 0, 0, err_msg, " ");
        return 0;
    }
}

// Функция для получения индекса аксессуара по modelid (больше не нужна, но оставляю для совместимости)
stock GetAccsIndexByModelId(modelid)
{
    for(new i = 0; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid)
        {
            return i;
        }
    }
    return -1;
}

stock CheckDefaultSkin(playerid)
{
    new query[256], Cache:result;
    mysql_format(mysql, query, sizeof query, 
        "SELECT id FROM inventory_skins WHERE owner_skin=%d LIMIT 1", 
        GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    
    new rows = cache_num_rows();
    cache_delete(result);
    
    if(!rows)
    {
        new current_skin = GetPlayerSkinEx(playerid);
        mysql_format(mysql, query, sizeof query, 
            "INSERT INTO inventory_skins (owner_skin, game_id, use_skin) VALUES (%d, %d, 1)", 
            GetPlayerAccountID(playerid), current_skin);
        mysql_query(mysql, query, false);
        
        SCM(playerid, 3, 6, 0, 0, "Стартовый скин добавлен", "Откройте /inventory");
        return 1;
    }
    return 0;
}

stock RemoveAllAccessories(playerid)
{
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            RemovePlayerAttachedObject(playerid, i);
        }
    }
    
    new query[256];
    format(query, sizeof(query), "UPDATE inventory_accessories SET in_use=0 WHERE account_id=%d", GetPlayerAccountID(playerid));
    mysql_query(mysql, query);
}

// ========== ЗАГРУЗКА АКСЕССУАРОВ ПРИ ВХОДЕ ==========
forward OnLoadPlayerAccessories(playerid);
public OnLoadPlayerAccessories(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    // printf("[DEBUG] OnLoadPlayerAccessories вызвана для ID:%d | Строк: %d", playerid, rows);

    if(rows)
    {
        new str_val[32];
        new loaded_count = 0;
        
        for(new i = 0; i < rows; i++)
        {
            new slot, modelid, bone, in_use;
            new Float:pos_x, Float:pos_y, Float:pos_z;
            new Float:rot_x, Float:rot_y, Float:rot_z;
            new Float:scale_x, Float:scale_y, Float:scale_z;

            cache_get_field_content(i, "slot", str_val, mysql, sizeof(str_val));
            slot = strval(str_val);

            cache_get_field_content(i, "modelid", str_val, mysql, sizeof(str_val));
            modelid = strval(str_val);

            cache_get_field_content(i, "bone", str_val, mysql, sizeof(str_val));
            bone = strval(str_val);

            cache_get_field_content(i, "pos_x", str_val, mysql, sizeof(str_val));
            pos_x = floatstr(str_val);

            cache_get_field_content(i, "pos_y", str_val, mysql, sizeof(str_val));
            pos_y = floatstr(str_val);

            cache_get_field_content(i, "pos_z", str_val, mysql, sizeof(str_val));
            pos_z = floatstr(str_val);

            cache_get_field_content(i, "rot_x", str_val, mysql, sizeof(str_val));
            rot_x = floatstr(str_val);

            cache_get_field_content(i, "rot_y", str_val, mysql, sizeof(str_val));
            rot_y = floatstr(str_val);

            cache_get_field_content(i, "rot_z", str_val, mysql, sizeof(str_val));
            rot_z = floatstr(str_val);

            cache_get_field_content(i, "scale_x", str_val, mysql, sizeof(str_val));
            scale_x = floatstr(str_val);

            cache_get_field_content(i, "scale_y", str_val, mysql, sizeof(str_val));
            scale_y = floatstr(str_val);

            cache_get_field_content(i, "scale_z", str_val, mysql, sizeof(str_val));
            scale_z = floatstr(str_val);

            cache_get_field_content(i, "in_use", str_val, mysql, sizeof(str_val));
            in_use = strval(str_val);

            // printf("[DEBUG] Аксессуар %d: modelid=%d, slot=%d, bone=%d, in_use=%d", i, modelid, slot, bone, in_use);

            // Надеваем только активные аксессуары (in_use=1 И slot >= 0)
            if(in_use && slot >= 0 && slot < MAX_PLAYER_ATTACHED_OBJECTS)
            {
                SetPlayerAttachedObject(playerid, slot, modelid, bone,
                    pos_x, pos_y, pos_z,
                    rot_x, rot_y, rot_z,
                    scale_x, scale_y, scale_z
                );
                
                gPlayerTempAccData[playerid][slot][0] = float(modelid);
                gPlayerTempAccData[playerid][slot][1] = float(bone);
                gPlayerTempAccData[playerid][slot][2] = pos_x;
                gPlayerTempAccData[playerid][slot][3] = pos_y;
                gPlayerTempAccData[playerid][slot][4] = pos_z;
                gPlayerTempAccData[playerid][slot][5] = rot_x;
                gPlayerTempAccData[playerid][slot][6] = rot_y;
                gPlayerTempAccData[playerid][slot][7] = rot_z;
                gPlayerTempAccData[playerid][slot][8] = scale_x;
                gPlayerTempAccData[playerid][slot][9] = scale_y;
                gPlayerTempAccData[playerid][slot][10] = scale_z;
                
                loaded_count++;
                // printf("[DEBUG] Аксессуар ID:%d НАДЕТ на слот %d", modelid, slot);
            }
            else
            {
                // printf("[DEBUG] Аксессуар ID:%d НЕ НАДЕТ (in_use=%d, slot=%d)", modelid, in_use, slot);
            }
        }
        
        // printf("[DEBUG] Загружено и надето аксессуаров: %d из %d", loaded_count, rows);
    }
    else
    {
        // printf("[DEBUG] У игрока ID:%d нет активных аксессуаров в БД", playerid);
    }
}
CMD:editacs(playerid)
{
    // Проверяем есть ли надетые аксессуары
    new count = 0;
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            count++;
        }
    }
    
    if(count == 0)
    {
        SCM(playerid, 2, 6, 0, 0, "Нет аксессуаров", "Наденьте аксессуар через /inventory");
        return 1;
    }
    
    ShowEditAcsMainDialog(playerid);
    return 1;
}

// ========== МЕНЮ СМЕНЫ КОСТИ ==========
stock ShowEditAcsBoneDialog(playerid)
{
    new dialog_text[512];
    
    strcat(dialog_text, "{FAD201}номер кости\t{FAD201}название части тела\n");
    strcat(dialog_text, "{FFFFFF}1\tПозвоночник (центр спины)\n");
    strcat(dialog_text, "{FFFFFF}2\tГолова (верхняя часть)\n");
    strcat(dialog_text, "{FFFFFF}3\tЛевая рука (плечо)\n");
    strcat(dialog_text, "{FFFFFF}4\tПравая рука (плечо)\n");
    strcat(dialog_text, "{FFFFFF}5\tЛевая рука (кисть)\n");
    strcat(dialog_text, "{FFFFFF}6\tПравая рука (кисть)\n");
    strcat(dialog_text, "{FFFFFF}7\tЛевое бедро (нога)\n");
    strcat(dialog_text, "{FFFFFF}8\tПравое бедро (нога)\n");
    strcat(dialog_text, "{FFFFFF}9\tЛевая нога (стопа)\n");
    strcat(dialog_text, "{FFFFFF}10\tПравая нога (стопа)\n");
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_BONE, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Редактор аксессуаров {FFFFFF}| Выберите кость для прикрепления",
        dialog_text,
        "Применить", "Назад"
    );
}

// ========== ГЛАВНОЕ МЕНЮ РЕДАКТИРОВАНИЯ ==========
stock ShowEditAcsMainDialog(playerid)
{
    new dialog_text[1024];
    new acc_name[64];
    
    strcat(dialog_text, "{FAD201}слот\t{FAD201}название аксессуара\t{FAD201}прикреплённая кость\n");
    
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            new modelid = floatround(gPlayerTempAccData[playerid][i][0]);
            new bone = floatround(gPlayerTempAccData[playerid][i][1]);
            
            format(acc_name, sizeof acc_name, "%s", GetAccessoryNameByModelId(modelid));
            
            format(dialog_text, sizeof dialog_text, "%s{FFFFFF}%d\t%s\t{999999}%s\n", 
                dialog_text, i, acc_name, GetBoneName(bone));
        }
    }
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Редактор аксессуаров {FFFFFF}| Выберите предмет для настройки",
        dialog_text,
        "Выбрать", "Закрыть"
    );
}

// ========== МЕНЮ ПАРАМЕТРОВ ==========
stock ShowEditAcsParamsDialog(playerid, slot)
{
    if(!IsPlayerAttachedObjectSlotUsed(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: слот не используется");
        return 0;
    }
    
    SetPVarInt(playerid, "editing_acc_slot", slot);
    
    new modelid = floatround(gPlayerTempAccData[playerid][slot][0]);
    new bone = floatround(gPlayerTempAccData[playerid][slot][1]);
    new acc_name[64];
    format(acc_name, sizeof acc_name, "%s", GetAccessoryNameByModelId(modelid));
    
    new dialog_text[1024];
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}настройка параметра\t{FAD201}информация о параметре\n\
        Позиция\t{FAD201}X:%.2f Y:%.2f Z:%.2f\n\
        Поворот\t{FAD201}X:%.1f Y:%.1f Z:%.1f\n\
        Масштаб\t{FAD201}X:%.2f Y:%.2f Z:%.2f\n\
        {66CC00}Сменить кость прикрепления\t{999999}Текущая: %s\n\
        {FF9900}Сохранить изменения\t{999999}Записать в базу данных\n\
        {FF0000}Сбросить настройки\t{999999}Вернуть по умолчанию",
        gPlayerTempAccData[playerid][slot][2],
        gPlayerTempAccData[playerid][slot][3],
        gPlayerTempAccData[playerid][slot][4],
        gPlayerTempAccData[playerid][slot][5],
        gPlayerTempAccData[playerid][slot][6],
        gPlayerTempAccData[playerid][slot][7],
        gPlayerTempAccData[playerid][slot][8],
        gPlayerTempAccData[playerid][slot][9],
        gPlayerTempAccData[playerid][slot][10],
        GetBoneName(bone)
    );
    
    new header[128];
    format(header, sizeof header, "{FAD201}Редактор аксессуаров {FFFFFF}| %s | Кость: %s", acc_name, GetBoneName(bone));
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_PARAMS, DIALOG_STYLE_TABLIST_HEADERS,
        header,
        dialog_text,
        "Изменить", "Назад"
    );
    
    return 1;
}

// ========== МЕНЮ ДЕЙСТВИЙ С ПАРАМЕТРОМ ==========
stock ShowEditAcsActionsDialog(playerid, param_index)
{
    new slot = GetPVarInt(playerid, "editing_acc_slot");
    
    new param_names[][] = {
        "Позиция X", "Позиция Y", "Позиция Z",
        "Поворот X", "Поворот Y", "Поворот Z",
        "Масштаб X", "Масштаб Y", "Масштаб З"
    };
    
    SetPVarInt(playerid, "editing_param", param_index);
    
    new dialog_text[512];
    new header[128];
    
    // Преобразуем float в string
    new value_str[32];
    format(value_str, sizeof value_str, "%.3f", gPlayerTempAccData[playerid][slot][param_index + 2]);
    
    format(header, sizeof header, 
        "{FAD201}Изменение параметра {FFFFFF}| %s | Текущее значение: %s", 
        param_names[param_index], 
        value_str
    );
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}доступное действие\t{FAD201}описание действия\n\
        {66CC00}Увеличить значение\t{FFFFFF}Прибавить +0.1\n\
        {FF0000}Уменьшить значение\t{FFFFFF}Вычесть -0.1\n\
        {FAD201}Точное значение\t{999999}Ввести число вручную"
    );
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_ACTIONS, DIALOG_STYLE_TABLIST_HEADERS,
        header,
        dialog_text,
        "Применить", "Назад"
    );
}
stock ShowEditAcsSubParamsDialog(playerid, group)
{
    new slot = GetPVarInt(playerid, "editing_acc_slot");
    new dialog_text[512];
    new header[128];
    
    SetPVarInt(playerid, "edit_group", group);
    
    switch(group)
    {
        case 0: // Позиция
        {
            format(header, sizeof header, "{FAD201}Редактор параметров {FFFFFF}| Настройка позиции аксессуара");
            
            format(dialog_text, sizeof dialog_text, 
                "{FAD201}название параметра\t{FAD201}текущее значение\n\
                Позиция по оси X\t{FAD201}%f\n\
                Позиция по оси Y\t{FAD201}%f\n\
                Позиция по оси Z\t{FAD201}%f",
                gPlayerTempAccData[playerid][slot][2],
                gPlayerTempAccData[playerid][slot][3],
                gPlayerTempAccData[playerid][slot][4]
            );
        }
        case 1: // Поворот
        {
            format(header, sizeof header, "{FAD201}Редактор параметров {FFFFFF}| Настройка поворота аксессуара");
            
            format(dialog_text, sizeof dialog_text, 
                "{FAD201}название параметра\t{FAD201}текущее значение\n\
                Поворот по оси X\t{FAD201}%f\n\
                Поворот по оси Y\t{FAD201}%f\n\
                Поворот по оси Z\t{FAD201}%f",
                gPlayerTempAccData[playerid][slot][5],
                gPlayerTempAccData[playerid][slot][6],
                gPlayerTempAccData[playerid][slot][7]
            );
        }
        case 2: // Масштаб
        {
            format(header, sizeof header, "{FAD201}Редактор параметров {FFFFFF}| Настройка масштаба аксессуара");
            
            format(dialog_text, sizeof dialog_text, 
                "{FAD201}название параметра\t{FAD201}текущее значение\n\
                Масштаб по оси X\t{FAD201}%f\n\
                Масштаб по оси Y\t{FAD201}%f\n\
                Масштаб по оси Z\t{FAD201}%f",
                gPlayerTempAccData[playerid][slot][8],
                gPlayerTempAccData[playerid][slot][9],
                gPlayerTempAccData[playerid][slot][10]
            );
        }
    }
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_SUBPARAMS, DIALOG_STYLE_TABLIST_HEADERS,
        header,
        dialog_text,
        "Выбрать", "Назад"
    );
}
stock ShowEditAcsDialogNew(playerid)
{
    new dialog_text[512];
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}параметр\t{FAD201}значение\n\
        Влево/Вправо\t{FFFFFF}%.3f\n\
        Вверх/Вниз\t{FFFFFF}%.3f\n\
        От себя/На себя\t{FFFFFF}%.3f\n\
        Поворот X\t{FFFFFF}%.1f\n\
        Поворот Y\t{FFFFFF}%.1f\n\
        Поворот Z\t{FFFFFF}%.1f\n\
        Масштаб\t{FFFFFF}%.2f\n\
        {66CC00}Сохранить изменения\t{999999}В базу данных\n\
        {FF0000}Выйти\t{999999}Без сохранения",
        GetPVarFloat(playerid, "edit_z"), // Z = влево/вправо
        GetPVarFloat(playerid, "edit_x"), // X = вверх/вниз
        GetPVarFloat(playerid, "edit_y"), // Y = от себя/на себя
        GetPVarFloat(playerid, "edit_rX"),
        GetPVarFloat(playerid, "edit_rY"),
        GetPVarFloat(playerid, "edit_rZ"),
        GetPVarFloat(playerid, "edit_scaleX")
    );
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_NEW_MAIN, DIALOG_STYLE_TABLIST_HEADERS,
        "{FAD201}Редактор аксессуаров {FFFFFF}| Выберите параметр",
        dialog_text,
        "Изменить", "Закрыть"
    );
}

stock ShowEditAcsActionsDialogNew(playerid, param_type)
{
    new param_names[][] = {
        "Влево/Вправо", "Вверх/Вниз", "От себя/На себя", 
        "Поворот X", "Поворот Y", "Поворот Z", "Масштаб"
    };
    
    new Float:current_value;
    
    switch(param_type)
    {
        case 0: current_value = GetPVarFloat(playerid, "edit_z"); // Z = влево/вправо
        case 1: current_value = GetPVarFloat(playerid, "edit_x"); // X = вверх/вниз
        case 2: current_value = GetPVarFloat(playerid, "edit_y"); // Y = от себя/на себя
        case 3: current_value = GetPVarFloat(playerid, "edit_rX");
        case 4: current_value = GetPVarFloat(playerid, "edit_rY");
        case 5: current_value = GetPVarFloat(playerid, "edit_rZ");
        case 6: current_value = GetPVarFloat(playerid, "edit_scaleX");
    }
    
    SetPVarInt(playerid, "edit_param_type", param_type);
    
    new dialog_text[256], header[128];
    
    format(header, sizeof header, "{FAD201}Редактор {FFFFFF}| %s | Значение: %.3f", param_names[param_type], current_value);
    
    format(dialog_text, sizeof dialog_text,
        "{FAD201}действие\t{FAD201}изменение\n\
        {66CC00}Увеличить\t{FFFFFF}+\n\
        {FF0000}Уменьшить\t{FFFFFF}-"
    );
    
    ShowPlayerDialog(playerid, DIALOG_EDITACS_NEW_ACTIONS, DIALOG_STYLE_TABLIST_HEADERS,
        header,
        dialog_text,
        "Применить", "Назад"
    );
}


stock UpdateAccessoryNew(playerid)
{
    new slot = GetPVarInt(playerid, "edit_acc_slot");
    
    // Обновляем массив
    gPlayerTempAccData[playerid][slot][2] = GetPVarFloat(playerid, "edit_x");
    gPlayerTempAccData[playerid][slot][3] = GetPVarFloat(playerid, "edit_y");
    gPlayerTempAccData[playerid][slot][4] = GetPVarFloat(playerid, "edit_z");
    gPlayerTempAccData[playerid][slot][5] = GetPVarFloat(playerid, "edit_rX");
    gPlayerTempAccData[playerid][slot][6] = GetPVarFloat(playerid, "edit_rY");
    gPlayerTempAccData[playerid][slot][7] = GetPVarFloat(playerid, "edit_rZ");
    gPlayerTempAccData[playerid][slot][8] = GetPVarFloat(playerid, "edit_scaleX");
    gPlayerTempAccData[playerid][slot][9] = GetPVarFloat(playerid, "edit_scaleY");
    gPlayerTempAccData[playerid][slot][10] = GetPVarFloat(playerid, "edit_scaleZ");
    
    // Обновляем на персонаже
    RemovePlayerAttachedObject(playerid, slot);
    
    SetPlayerAttachedObject(
        playerid, 
        slot,
        floatround(gPlayerTempAccData[playerid][slot][0]), // modelid
        floatround(gPlayerTempAccData[playerid][slot][1]), // bone
        gPlayerTempAccData[playerid][slot][2],
        gPlayerTempAccData[playerid][slot][3],
        gPlayerTempAccData[playerid][slot][4],
        gPlayerTempAccData[playerid][slot][5],
        gPlayerTempAccData[playerid][slot][6],
        gPlayerTempAccData[playerid][slot][7],
        gPlayerTempAccData[playerid][slot][8],
        gPlayerTempAccData[playerid][slot][9],
        gPlayerTempAccData[playerid][slot][10]
    );
}

stock SaveAccessoryNew(playerid)
{
    new db_id = GetPVarInt(playerid, "edit_acc_db_id");
    new slot = GetPVarInt(playerid, "edit_acc_slot");
    
    new query[512];
    mysql_format(mysql, query, sizeof query,
        "UPDATE inventory_accessories SET \
        pos_x=%f, pos_y=%f, pos_z=%f, \
        rot_x=%f, rot_y=%f, rot_z=%f, \
        scale_x=%f, scale_y=%f, scale_z=%f \
        WHERE id=%d",
        GetPVarFloat(playerid, "edit_x"),
        GetPVarFloat(playerid, "edit_y"),
        GetPVarFloat(playerid, "edit_z"),
        GetPVarFloat(playerid, "edit_rX"),
        GetPVarFloat(playerid, "edit_rY"),
        GetPVarFloat(playerid, "edit_rZ"),
        GetPVarFloat(playerid, "edit_scaleX"),
        GetPVarFloat(playerid, "edit_scaleY"),
        GetPVarFloat(playerid, "edit_scaleZ"),
        db_id
    );
    
    mysql_query(mysql, query, false);
    
    // Очищаем PVar'ы
    DeletePVar(playerid, "edit_acc_db_id");
    DeletePVar(playerid, "edit_acc_slot");
    DeletePVar(playerid, "edit_acc_modelid");
    DeletePVar(playerid, "edit_acc_bone");
    DeletePVar(playerid, "edit_x");
    DeletePVar(playerid, "edit_y");
    DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX");
    DeletePVar(playerid, "edit_rY");
    DeletePVar(playerid, "edit_rZ");
    DeletePVar(playerid, "edit_scaleX");
    DeletePVar(playerid, "edit_scaleY");
    DeletePVar(playerid, "edit_scaleZ");
    DeletePVar(playerid, "edit_param_type");
    
    SendClientMessage(playerid, -1, "{66CC00}Настройки аксессуара сохранены!");
}