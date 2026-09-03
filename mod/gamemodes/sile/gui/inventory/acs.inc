#if defined _acs_included
    #endinput
#endif
#define _acs_included

#include <a_samp>
#include <a_mysql>

#define ACCESSORY_DIALOG_SLOT_SELECT (1190)
#define ACCESSORY_DIALOG_EDITOR_ACTION (1191)
#define ACCESSORY_DIALOG_WEAR_CONFIRM (1192)
#define ACCESSORY_DIALOG_BONE_SELECT (1193)
#define ACCESSORY_DIALOG_BUY_CONFIRM (1194)

#define ITEM_TYPE_ACCESSORY 6
#define INVENTORY_ACCESSORY_ITEM_BASE 1000
#define INVENTORY_ACCESSORY_ITEM_LIMIT 2000
#define SLOT_ACCESSORY_START 2
#define SLOT_ACCESSORY_END 7

enum E_ACCESSORY
{
    ID_ACCESSORY,
    BONE_ACCESSORY,
    NAME_ACCESSORY[64],
    PRICE_ACCESSORY
}

static const accessory[][E_ACCESSORY] =
{
    {4196, 1, "Крылья бабочки", 15000000},
    {10492, 2, "Шлем Bunny", 10000000},
    {939, 2, "Кленовая корона", 7000000},
    {4199, 1, "Рюкзак - реактивный ранец", 5000000},
    {4200, 1, "Кленовая сумка", 5000000},
    {14647, 1, "Сумка SpeedPack", 1000000},
    {4203, 1, "Рюкзак с овощами", 3000000},
    {4204, 1, "Школьный рюкзак", 3000000},
    {4205, 2, "Шапка - подсолнух", 2500000},
    {4206, 1, "Черный зонт", 1500000},
    {4207, 1, "Зонт с листьями", 1000000},
    {4208, 1, "Розовый зонт", 900000},
    {14574, 1, "Крылья демона", 15000000},
    {14575, 1, "Крылья ангела", 15000000},
    {14593, 1, "Карамельные крылья", 15000000},
    {14791, 1, "Голова монстра", 12000000},
    {14643, 2, "Рюкзак Energy", 2000000},
    {4702, 2, "Маска Fresh'a", 2000000},
    {13884, 2, "Вилы демона", 2000000},
    {5378, 2, "Меч короля пиратов", 2000000},
    {5384, 2, "Фонарь пирата", 2500000},
    {5383, 2, "Легендарная шляпа", 2000000},
    {5372, 2, "Пиратская шляпа", 2000000},
    {5374, 1, "Череп воробья", 2000000},
    {5375, 1, "Обезьяна на плечо", 1500000},
    {15144, 2, "Светящаяся красная маска", 500000},
    {15145, 2, "Маска маньяка", 500000},
    {15146, 2, "Плачущая маска", 500000},
    {15147, 2, "Страшная маска", 700000},
    {15149, 1, "Метла", 1000000},
    {15150, 1, "Рюкзак FnaF", 1500000},
    {15151, 2, "Маска ведущего", 3000000},
    {15152, 2, "Светящаяся синяя маска", 500000},
    {15153, 2, "Светящаяся фиолетовая маска", 500000},
    {7329, 2, "Красная повязка", 300000},
    {7330, 2, "Красная повязка", 300000},
    {7331, 2, "Военная каска 2", 500000},
    {7332, 2, "Черная шапка", 300000},
    {7333, 2, "Белая шапка", 300000},
    {7334, 2, "Синяя шапка", 300000},
    {7336, 2, "Синяя кепка 2", 300000},
    {7337, 2, "Синяя кепка 3", 300000},
    {7338, 2, "Разноцветная кепка", 300000},
    {7339, 2, "Черная кепка", 300000},
    {7341, 2, "Кепка (NY)", 400000},
    {7342, 2, "Шапка (Шерлок)", 400000},
    {7343, 2, "Панама №1 супе", 300000},
    {7344, 2, "Панама №2 (StoneIS)", 300000},
    {7345, 2, "Панама №3", 300000},
    {7346, 2, "Панама №4", 300000},
    {7347, 2, "Панама №5", 300000},
    {7348, 2, "Панама №6", 300000},
    {7349, 2, "Панама №7", 300000},
    {7350, 2, "Панама №8 (ао)", 300000},
    {18377, 2, "Очки сердечки", 7000000},
    {18386, 2, "Очки глаза", 7000000},
    {18389, 2, "Шапочка с оленьими рожками", 300000},
    {18390, 2, "Очки матрица", 6000000},
    {18391, 2, "Очки огонь", 7000000},
    {18392, 2, "Очки огонь прямые", 8000000},
    {18396, 2, "Маска гнома", 2500000},
    {18397, 2, "Маска гринча", 2000000},
    {18399, 2, "Рожки", 1000000},
    {18400, 2, "Рожки 2", 100000},
    {18401, 2, "Очки салют", 7000000},
    {18402, 2, "Маска котика", 3000000},
    {18403, 2, "Маска тигра", 3000000},
    {18404, 2, "Очки глюки", 7000000},
    {18409, 2, "Очки снежинки", 7000000},
    {7351, 2, "Кепка", 300000},
    {7352, 2, "Кепка 2", 300000},
    {7353, 2, "Кепка", 300000},
    {7354, 2, "Кепка", 300000},
    {7355, 2, "Шляпа №1", 400000},
    {7356, 2, "Шляпа №2", 450000},
    {7357, 2, "Шляпа №3 (New)", 450000},
    {7358, 2, "Шляпа №4", 500000},
    {7359, 2, "Шляпа №5", 500000},
    {7360, 2, "Шляпа №6", 500000},
    {7362, 2, "Синяя шапка", 350000},
    {7364, 1, "Зонт (Разноцветный)", 8000000},
    {7367, 6, "Кожаный кейс", 5000000},
    {7368, 6, "Кейс (2)", 10000000},
    {7369, 6, "Черный кейс", 12000000},
    {7370, 2, "Маска петуха", 5000000},
    {7371, 2, "Маска голубя", 5000000},
    {7372, 2, "Маска зелёная", 3000000},
    {7374, 2, "Маска медведя", 4000000},
    {7375, 2, "Маска самурай", 5000000},
    {7376, 2, "Маска самурай", 5000000},
    {7377, 1, "Катана", 1000000},
    {7378, 1, "Катана", 1000000},
    {7379, 2, "Шляпа самурая №1", 1500000},
    {7380, 2, "Шляпа самурая №2", 1500000},
    {7381, 2, "Шляпа самурая №3", 1500000},
    {7382, 2, "Шляпа индейца", 1500000},
    {7383, 1, "Доска для серфинга №1", 500000},
    {7384, 1, "Доска для серфинга №2", 500000},
    {7385, 1, "Доска для серфинга №3", 500000},
    {7386, 1, "Доска для серфинга №4", 500000},
    {7387, 1, "Акула", 750000},
    {7390, 1, "Гитара №1", 700000},
    {7391, 1, "Гитара №2", 700000},
    {7392, 1, "Гитара №3", 700000},
    {7393, 1, "Гитара №4", 700000},
    {7394, 1, "Скейт №1", 750000},
    {7395, 1, "Скейт №2", 750000},
    {790, 1, "Новогодний Дракон", 4000000},
    {787, 2, "Маска Дракона", 7000000},
    {9824, 1, "Весёлая тыква", 5000000},
    {9825, 1, "Хеллоуинские ночи", 3000000},
    {9827, 1, "Кукла Вуду", 5000000},
    {9828, 1, "Призрачный портал", 4000000},
    {11919, 2, "Акула на голову", 6000000},
    {11923, 1, "Рюкзак Мопс на спину", 5000000},
    {14589, 2, "Маска Оленя", 6000000},
    {31949, 6, "Берет 80", 13800000},
    {677, 1, "Советская", 100000},
    {676, 2, "Очки", 13000000},
    {2655, 1, "Шлем", 200000},
    {2656, 1, "Надувной", 11400000},
    {2657, 2, "Очки", 6200000},
    {16055, 2, "Лапка", 700000},
    {9826, 2, "Маска", 6600000},
    {11922, 1, "Геймбой", 7200000},
    {11925, 6, "Летняя доска", 2800000},
    {13801, 6, "Катюша", 4200000},
    {13803, 1, "Рюкзак", 5200000},
    {14591, 2, "Белые рога", 200000},
    {14592, 6, "Уши эльфа", 1300000},
    {14596, 2, "Маска ёлочки", 800000},
    {14597, 2, "Рождественские рога", 2900000},
    {14598, 2, "Маска Деда Мороза", 600000},
    {14603, 6, "Шапка-Ушанка", 2900000},
    {4160, 6, "Новогодний кекс", 3100000},
    {4161, 6, "Новогодний мишка", 1100000},
    {4162, 2, "Маска Снегурочки", 6500000},
    {4163, 2, "Маска Снеговика", 200000},
    {4165, 1, "Сумка Снеговика", 12900000},
    {13883, 2, "Корона демона", 100000},
    {18509, 6, "Кейс", 100000},
    {18510, 6, "Кейс черный", 800000},
    {18511, 6, "Кейс серый", 600000},
    {18512, 2, "Золотая корона", 12300000},
    {18513, 2, "Корона короля", 300000},
    {18514, 2, "Серебряная корона", 4600000},
    {18515, 6, "Лавровый венец", 800000},
    {18516, 2, "Диадема", 500000},
    {18517, 2, "Очки Доллар", 600000},
    {18518, 2, "Очки День Рождения", 300000},
    {18519, 2, "Праздничный колпак", 600000},
    {18520, 2, "Неоновые очки", 11200000},
    {18521, 2, "Неоновые очки", 1500000},
    {18522, 2, "Неоновые очки", 12300000},
    {18523, 2, "Неоновые очки", 12100000},
    {18524, 2, "Неоновые очки", 2200000},
    {18525, 2, "Неоновые очки", 1300000},
    {18526, 2, "Очки пиксели", 4900000},
    {18527, 2, "Шар", 3300000},
    {18528, 1, "Шар", 2900000},
    {18529, 1, "Шар", 8500000},
    {18530, 2, "Шар", 6200000},
    {18497, 2, "Шарик", 800000},
    {18498, 2, "Очки 'Выпуклые глаза'", 600000},
    {18499, 2, "Очки 'Обычные глаза'", 100000},
    {18500, 2, "Маска клоуна", 1600000},
    {18501, 2, "Маска клоуна", 3300000},
    {18502, 2, "Лицо тролля", 2400000},
    {18503, 6, "Инопланетянин", 4500000},
    {18504, 2, "Тролль с париком", 14300000},
    {18505, 6, "Инопланетянин с париком", 14500000},
    {18506, 2, "Очки с носом", 100000},
    {18507, 1, "Нос клоуна", 10700000},
    {18508, 1, "Парик клоуна", 100000},
    {18233, 1, "Деревянный", 1600000},
    {18232, 6, "Берет", 900000},
    {18243, 2, "Карамельная конфета", 600000},
    {18250, 1, "Белая панама", 6900000},
    {18383, 6, "Черная панама", 6900000},
    {18384, 6, "Серая панама", 2500000},
    {18385, 2, "Темная панама", 3000000},
    {18263, 6, "Белая панама", 5500000},
    {18264, 6, "Черная панама", 13000000},
    {18273, 2, "Высокая панама", 600000},
    {18279, 2, "Черная шапка", 100000},
    {18285, 6, "Посох-зонт", 1800000},
    {18286, 2, "Кандибобер", 1600000},
    {18346, 6, "Синий посох", 10400000},
    {18347, 6, "Синий посох", 2300000},
    {18348, 6, "Голубой посох", 7100000},
    {18369, 2, "Новогодний топорик", 1300000},
    {18375, 6, "Новогодняя палочка", 2100000},
    {18378, 1, "Рюкзак 'Котик'", 5300000},
    {18379, 1, "Рюкзак 'Санта-Клауса'", 11800000},
    {18410, 2, "Очки", 1500000},
    {18411, 6, "Голубой посох", 100000},
    {18412, 2, "Очки", 1000000},
    {18414, 2, "Прямые очки", 4200000},
    {15158, 6, "Кепка", 2800000},
    {15154, 2, "Неоновая маска", 9900000},
    {15155, 2, "Неоновая маска", 2200000},
    {15157, 1, "Рюкзак", 6500000},
    {15148, 2, "Маска Дали", 900000},
    {15160, 2, "Маска круга", 9300000},
    {15161, 2, "Маска треугольника", 200000},
    {15159, 2, "Маска квадрата", 8400000},
    {907, 2, "Donate accessory 1", 0},
    {908, 2, "Donate accessory 2", 0},
    {909, 2, "Donate accessory 3", 0},
    {912, 2, "Donate accessory 4", 0},
    {916, 2, "Donate accessory 5", 0},
    {926, 2, "Donate accessory 6", 0},
    {918, 2, "Donate accessory 7", 0},
    {910, 2, "Donate accessory 8", 0},
    {914, 2, "Donate accessory 9", 0},
    {919, 2, "Donate accessory 10", 0},
    {921, 2, "Donate accessory 11", 0},
    {923, 2, "Donate accessory 12", 0},
    {915, 2, "Donate accessory 13", 0},
    {917, 2, "Donate accessory 14", 0},
    {922, 2, "Donate accessory 15", 0},
    {924, 2, "Donate accessory 16", 0},
    {925, 2, "Donate accessory 17", 0},
    {911, 2, "Donate accessory 18", 0},
    {913, 2, "Donate accessory 19", 0},
    {920, 2, "Donate accessory 20", 0},
    {1650, 2, "Donate accessory 21", 0},
    {945, 2, "Donate accessory 26", 0},
    {946, 2, "Donate accessory 27", 0},
    {19882, 2, "Donate accessory 28", 0},
    {19632, 2, "Donate accessory 29", 0},
    {985, 2, "Donate accessory 30", 0},
    {986, 2, "Donate accessory 31", 0},
    {990, 2, "Donate accessory 32", 0},
    {994, 2, "Donate accessory 33", 0},
    {995, 2, "Donate accessory 34", 0},
    {967, 2, "Donate accessory 35", 0},
    {968, 2, "Donate accessory 36", 0},
    {969, 2, "Donate accessory 37", 0},
    {979, 2, "Donate accessory 38", 0},
    {980, 2, "Donate accessory 39", 0},
    {981, 2, "Donate accessory 40", 0},
    {982, 2, "Donate accessory 41", 0},
    {984, 2, "Donate accessory 42", 0},
    {987, 2, "Donate accessory 43", 0},
    {988, 2, "Donate accessory 44", 0},
    {989, 2, "Donate accessory 45", 0},
    {992, 2, "Donate accessory 46", 0},
    {993, 2, "Donate accessory 47", 0},
    {970, 2, "Donate accessory 48", 0},
    {971, 2, "Donate accessory 49", 0},
    {972, 2, "Donate accessory 50", 0},
    {973, 2, "Donate accessory 51", 0},
    {974, 2, "Donate accessory 52", 0},
    {975, 2, "Donate accessory 53", 0},
    {976, 2, "Donate accessory 54", 0},
    {977, 2, "Donate accessory 55", 0},
    {978, 2, "Donate accessory 56", 0},
    {983, 2, "Donate accessory 57", 0},
    {997, 2, "Donate accessory 58", 0},
    {1754, 2, "Donate accessory 59", 0},
    {1194, 2, "Donate accessory 60", 0},
    {1195, 2, "Donate accessory 61", 0},
    {1196, 2, "Donate accessory 62", 0},
    {1197, 2, "Donate accessory 63", 0},
    {1198, 2, "Donate accessory 64", 0},
    {1199, 2, "Donate accessory 65", 0},
    {2646, 2, "Donate accessory 66", 0},
    {1716, 2, "Donate accessory 67", 0},
    {1699, 2, "Donate accessory 68", 0},
    {1701, 2, "Donate accessory 69", 0},
    {1702, 2, "Donate accessory 70", 0},
    {1703, 2, "Donate accessory 71", 0},
    {1704, 2, "Donate accessory 72", 0},
    {1705, 2, "Donate accessory 73", 0},
    {1706, 2, "Donate accessory 74", 0},
    {1707, 2, "Donate accessory 75", 0},
    {1708, 2, "Donate accessory 76", 0},
    {1709, 2, "Donate accessory 77", 0},
    {1710, 2, "Donate accessory 78", 0},
    {1711, 2, "Donate accessory 79", 0},
    {1654, 2, "Donate accessory 80", 0},
    {1755, 2, "Donate accessory 81", 0},
    {1756, 2, "Donate accessory 82", 0},
    {1757, 2, "Donate accessory 83", 0},
    {1720, 2, "Donate accessory 84", 0},
    {1721, 2, "Donate accessory 85", 0},
    {1722, 2, "Donate accessory 86", 0},
    {1723, 2, "Donate accessory 87", 0},
    {1724, 2, "Donate accessory 88", 0},
    {1725, 2, "Donate accessory 89", 0},
    {1726, 2, "Donate accessory 90", 0},
    {1747, 2, "Donate accessory 91", 0},
    {1748, 2, "Donate accessory 92", 0},
    {1749, 2, "Donate accessory 93", 0},
    {1750, 2, "Donate accessory 94", 0},
    {1751, 2, "Donate accessory 95", 0},
    {1727, 2, "Donate accessory 96", 0},
    {1728, 2, "Donate accessory 97", 0},
    {1729, 2, "Donate accessory 98", 0},
    {1730, 2, "Donate accessory 99", 0},
    {1731, 2, "Donate accessory 100", 0},
    {1732, 2, "Donate accessory 101", 0},
    {1743, 2, "Donate accessory 102", 0},
    {1744, 2, "Donate accessory 103", 0},
    {1745, 2, "Donate accessory 104", 0},
    {1746, 2, "Donate accessory 105", 0},
    {1733, 2, "Donate accessory 106", 0},
    {1734, 2, "Donate accessory 107", 0},
    {1735, 2, "Donate accessory 108", 0},
    {1736, 2, "Donate accessory 109", 0},
    {1737, 2, "Donate accessory 110", 0},
    {1783, 2, "Donate accessory 111", 0},
    {1779, 2, "Donate accessory 112", 0},
    {1778, 2, "Donate accessory 113", 0},
    {1777, 2, "Donate accessory 114", 0},
    {1776, 2, "Donate accessory 115", 0},
    {2641, 2, "Donate accessory 116", 0},
    {1795, 2, "Donate accessory 117", 0},
    {1790, 2, "Donate accessory 118", 0},
    {1789, 2, "Donate accessory 119", 0},
    {1791, 2, "Donate accessory 120", 0},
    {10952, 2, "Donate accessory 121", 0},
    {10836, 2, "Donate accessory 122", 0},
    {12229, 2, "Donate accessory 123", 0},
    {12233, 2, "Donate accessory 124", 0},
    {12222, 2, "Donate accessory 125", 0},
    {12223, 2, "Donate accessory 126", 0},
    {12224, 2, "Donate accessory 127", 0},
    {12226, 2, "Donate accessory 128", 0},
    {12225, 2, "Donate accessory 129", 0},
    {12231, 2, "Donate accessory 130", 0},
    {12227, 2, "Donate accessory 131", 0},
    {12228, 2, "Donate accessory 132", 0},
    {12635, 2, "Donate accessory 133", 0},
    {0, 2, "Donate accessory 134", 0},
    {15134, 2, "Donate accessory 135", 0},
    {15135, 2, "Donate accessory 136", 0},
    {15136, 2, "Donate accessory 137", 0},
    {15137, 2, "Donate accessory 138", 0},
    {15138, 2, "Donate accessory 139", 0},
    {15139, 2, "Donate accessory 140", 0},
    {15140, 2, "Donate accessory 141", 0},
    {15141, 2, "Donate accessory 142", 0},
    {15142, 2, "Donate accessory 143", 0},
    {15143, 2, "Donate accessory 144", 0},
    {1212, 2, "Donate accessory 162", 0},
    {18226, 2, "Donate accessory 163", 0},
    {18227, 2, "Donate accessory 164", 0},
    {18228, 2, "Donate accessory 165", 0},
    {18229, 2, "Donate accessory 166", 0},
    {18230, 2, "Donate accessory 167", 0},
    {18231, 2, "Donate accessory 168", 0},
    {18234, 2, "Donate accessory 171", 0},
    {18235, 2, "Donate accessory 172", 0},
    {18236, 2, "Donate accessory 173", 0},
    {18237, 2, "Donate accessory 174", 0},
    {18238, 2, "Donate accessory 175", 0},
    {18239, 2, "Donate accessory 176", 0},
    {18240, 2, "Donate accessory 177", 0},
    {18241, 2, "Donate accessory 178", 0},
    {18242, 2, "Donate accessory 179", 0},
    {18244, 2, "Donate accessory 181", 0},
    {18245, 2, "Donate accessory 182", 0},
    {18246, 2, "Donate accessory 183", 0},
    {18247, 2, "Donate accessory 184", 0},
    {18248, 2, "Donate accessory 185", 0},
    {18249, 2, "Donate accessory 186", 0},
    {18251, 2, "Donate accessory 188", 0},
    {18252, 2, "Donate accessory 189", 0},
    {18253, 2, "Donate accessory 190", 0},
    {18254, 2, "Donate accessory 191", 0},
    {18255, 2, "Donate accessory 192", 0},
    {18256, 2, "Donate accessory 193", 0},
    {18257, 2, "Donate accessory 194", 0},
    {18258, 2, "Donate accessory 195", 0},
    {18259, 2, "Donate accessory 196", 0},
    {18260, 2, "Donate accessory 197", 0},
    {18261, 2, "Donate accessory 198", 0},
    {18262, 2, "Donate accessory 199", 0},
    {18265, 2, "Donate accessory 202", 0},
    {18266, 2, "Donate accessory 203", 0},
    {18267, 2, "Donate accessory 204", 0},
    {18268, 2, "Donate accessory 205", 0},
    {18269, 2, "Donate accessory 206", 0},
    {18270, 2, "Donate accessory 207", 0},
    {18271, 2, "Donate accessory 208", 0},
    {18272, 2, "Donate accessory 209", 0},
    {18274, 2, "Donate accessory 211", 0},
    {18275, 2, "Donate accessory 212", 0},
    {18276, 2, "Donate accessory 213", 0},
    {18277, 2, "Donate accessory 214", 0},
    {18278, 2, "Donate accessory 215", 0},
    {18282, 2, "Donate accessory 217", 0},
    {18283, 2, "Donate accessory 218", 0},
    {18284, 2, "Donate accessory 219", 0},
    {18287, 2, "Donate accessory 222", 0},
    {18288, 2, "Donate accessory 223", 0},
    {18289, 2, "Donate accessory 224", 0},
    {18290, 2, "Donate accessory 225", 0},
    {18291, 2, "Donate accessory 226", 0},
    {18292, 2, "Donate accessory 227", 0},
    {18293, 2, "Donate accessory 228", 0},
    {18294, 2, "Donate accessory 229", 0},
    {18295, 2, "Donate accessory 230", 0},
    {18296, 2, "Donate accessory 231", 0},
    {18297, 2, "Donate accessory 232", 0},
    {18298, 2, "Donate accessory 233", 0},
    {18299, 2, "Donate accessory 234", 0},
    {18300, 2, "Donate accessory 235", 0},
    {18301, 2, "Donate accessory 236", 0},
    {18302, 2, "Donate accessory 237", 0},
    {18303, 2, "Donate accessory 238", 0},
    {18304, 2, "Donate accessory 239", 0},
    {18305, 2, "Donate accessory 240", 0},
    {18306, 2, "Donate accessory 241", 0},
    {18307, 2, "Donate accessory 242", 0},
    {18308, 2, "Donate accessory 243", 0},
    {18309, 2, "Donate accessory 244", 0},
    {18310, 2, "Donate accessory 245", 0},
    {18311, 2, "Donate accessory 246", 0},
    {18312, 2, "Donate accessory 247", 0},
    {18313, 2, "Donate accessory 248", 0},
    {18314, 2, "Donate accessory 249", 0},
    {18315, 2, "Donate accessory 250", 0},
    {18316, 2, "Donate accessory 251", 0},
    {18317, 2, "Donate accessory 252", 0},
    {18318, 2, "Donate accessory 253", 0},
    {18319, 2, "Donate accessory 254", 0},
    {18320, 2, "Donate accessory 255", 0},
    {18321, 2, "Donate accessory 256", 0},
    {18322, 2, "Donate accessory 257", 0},
    {18323, 2, "Donate accessory 258", 0},
    {18324, 2, "Donate accessory 259", 0},
    {18325, 2, "Donate accessory 260", 0},
    {18326, 2, "Donate accessory 261", 0},
    {18327, 2, "Donate accessory 262", 0},
    {18328, 2, "Donate accessory 263", 0},
    {18329, 2, "Donate accessory 264", 0},
    {18330, 2, "Donate accessory 265", 0},
    {18331, 2, "Donate accessory 266", 0},
    {18332, 2, "Donate accessory 267", 0},
    {18333, 2, "Donate accessory 268", 0},
    {18334, 2, "Donate accessory 269", 0},
    {18335, 2, "Donate accessory 270", 0},
    {18336, 2, "Donate accessory 271", 0},
    {18337, 2, "Donate accessory 272", 0},
    {18338, 2, "Donate accessory 273", 0},
    {18339, 2, "Donate accessory 274", 0},
    {18340, 2, "Donate accessory 275", 0},
    {18341, 2, "Donate accessory 276", 0},
    {18342, 2, "Donate accessory 277", 0},
    {18343, 2, "Donate accessory 278", 0},
    {18344, 2, "Donate accessory 279", 0},
    {18345, 2, "Donate accessory 280", 0},
    {18349, 2, "Donate accessory 284", 0},
    {18350, 2, "Donate accessory 285", 0},
    {18351, 2, "Donate accessory 286", 0},
    {18352, 2, "Donate accessory 287", 0},
    {18353, 2, "Donate accessory 288", 0},
    {18354, 2, "Donate accessory 289", 0},
    {18355, 2, "Donate accessory 290", 0},
    {18356, 2, "Donate accessory 291", 0},
    {18357, 2, "Donate accessory 292", 0},
    {18358, 2, "Donate accessory 293", 0},
    {18359, 2, "Donate accessory 294", 0},
    {18360, 2, "Donate accessory 295", 0},
    {18361, 2, "Donate accessory 296", 0},
    {18362, 2, "Donate accessory 297", 0},
    {18363, 2, "Donate accessory 298", 0},
    {18364, 2, "Donate accessory 299", 0},
    {18365, 2, "Donate accessory 300", 0},
    {18366, 2, "Donate accessory 301", 0},
    {18367, 2, "Donate accessory 302", 0},
    {18368, 2, "Donate accessory 303", 0},
    {18370, 2, "Donate accessory 305", 0},
    {18371, 2, "Donate accessory 306", 0},
    {18372, 2, "Donate accessory 307", 0},
    {18373, 2, "Donate accessory 308", 0},
    {18374, 2, "Donate accessory 309", 0},
    {18376, 2, "Donate accessory 311", 0},
    {18380, 2, "Donate accessory 315", 0},
    {18381, 2, "Donate accessory 316", 0},
    {18382, 2, "Donate accessory 317", 0},
    {18387, 2, "Donate accessory 322", 0},
    {18388, 2, "Donate accessory 323", 0},
    {18393, 2, "Donate accessory 328", 0},
    {18394, 2, "Donate accessory 329", 0},
    {18395, 2, "Donate accessory 330", 0},
    {18398, 2, "Donate accessory 333", 0},
    {18405, 2, "Donate accessory 340", 0},
    {18406, 2, "Donate accessory 341", 0},
    {18407, 2, "Donate accessory 342", 0},
    {18408, 2, "Donate accessory 343", 0},
    {18413, 2, "Donate accessory 348", 0},
    {18415, 2, "Donate accessory 350", 0},
    {18416, 2, "Donate accessory 351", 0},
    {18417, 2, "Donate accessory 352", 0},
    {18418, 2, "Donate accessory 353", 0},
    {18419, 2, "Donate accessory 354", 0},
    {18420, 2, "Donate accessory 355", 0},
    {18421, 2, "Donate accessory 356", 0},
    {18422, 2, "Donate accessory 357", 0},
    {18423, 2, "Donate accessory 358", 0},
    {18424, 2, "Donate accessory 359", 0},
    {18425, 2, "Donate accessory 360", 0},
    {18426, 2, "Donate accessory 361", 0},
    {18427, 2, "Donate accessory 362", 0},
    {18428, 2, "Donate accessory 363", 0},
    {18429, 2, "Donate accessory 364", 0},
    {18430, 2, "Donate accessory 365", 0},
    {18431, 2, "Donate accessory 366", 0},
    {18432, 2, "Donate accessory 367", 0},
    {18433, 2, "Donate accessory 368", 0},
    {18434, 2, "Donate accessory 369", 0},
    {18435, 2, "Donate accessory 370", 0},
    {18436, 2, "Donate accessory 371", 0},
    {18437, 2, "Donate accessory 372", 0},
    {18438, 2, "Donate accessory 373", 0},
    {18439, 2, "Donate accessory 374", 0},
    {18440, 2, "Donate accessory 375", 0},
    {18441, 2, "Donate accessory 376", 0},
    {18442, 2, "Donate accessory 377", 0},
    {18443, 2, "Donate accessory 378", 0},
    {18444, 2, "Donate accessory 379", 0},
    {18445, 2, "Donate accessory 380", 0},
    {18446, 2, "Donate accessory 381", 0},
    {18447, 2, "Donate accessory 382", 0},
    {18448, 2, "Donate accessory 383", 0},
    {18449, 2, "Donate accessory 384", 0},
    {18450, 2, "Donate accessory 385", 0},
    {18451, 2, "Donate accessory 386", 0},
    {18452, 2, "Donate accessory 387", 0},
    {18453, 2, "Donate accessory 388", 0},
    {18454, 2, "Donate accessory 389", 0},
    {18455, 2, "Donate accessory 390", 0},
    {18456, 2, "Donate accessory 391", 0},
    {18457, 2, "Donate accessory 392", 0},
    {18458, 2, "Donate accessory 393", 0},
    {18459, 2, "Donate accessory 394", 0},
    {18460, 2, "Donate accessory 395", 0},
    {18461, 2, "Donate accessory 396", 0},
    {18462, 2, "Donate accessory 397", 0},
    {18463, 2, "Donate accessory 398", 0},
    {18464, 2, "Donate accessory 399", 0},
    {18465, 2, "Donate accessory 400", 0},
    {18466, 2, "Donate accessory 401", 0},
    {18467, 2, "Donate accessory 402", 0},
    {18468, 2, "Donate accessory 403", 0},
    {18469, 2, "Donate accessory 404", 0},
    {18470, 2, "Donate accessory 405", 0},
    {18471, 2, "Donate accessory 406", 0},
    {18472, 2, "Donate accessory 407", 0},
    {18473, 2, "Donate accessory 408", 0},
    {18474, 2, "Donate accessory 409", 0},
    {18475, 2, "Donate accessory 410", 0},
    {18476, 2, "Donate accessory 411", 0},
    {18477, 2, "Donate accessory 412", 0},
    {18478, 2, "Donate accessory 413", 0},
    {18479, 2, "Donate accessory 414", 0},
    {18480, 2, "Donate accessory 415", 0},
    {18481, 2, "Donate accessory 416", 0},
    {18482, 2, "Donate accessory 417", 0},
    {18483, 2, "Donate accessory 418", 0},
    {18484, 2, "Donate accessory 419", 0},
    {18485, 2, "Donate accessory 420", 0},
    {18486, 2, "Donate accessory 421", 0},
    {18487, 2, "Donate accessory 422", 0},
    {18488, 2, "Donate accessory 423", 0},
    {18489, 2, "Donate accessory 424", 0},
    {18490, 2, "Donate accessory 425", 0},
    {18491, 2, "Donate accessory 426", 0},
    {18492, 2, "Donate accessory 427", 0},
    {18493, 2, "Donate accessory 428", 0},
    {18494, 2, "Donate accessory 429", 0},
    {18495, 2, "Donate accessory 430", 0},
    {18496, 2, "Donate accessory 431", 0},
    {18531, 2, "Donate accessory 466", 0},
    {18532, 2, "Donate accessory 467", 0},
    {18533, 2, "Donate accessory 468", 0},
    {18534, 2, "Donate accessory 469", 0},
    {18535, 2, "Donate accessory 470", 0},
    {18536, 2, "Donate accessory 471", 0},
    {18537, 2, "Donate accessory 472", 0},
    {18538, 2, "Donate accessory 473", 0},
    {18539, 2, "Donate accessory 474", 0},
    {18540, 2, "Donate accessory 475", 0},
    {18541, 2, "Donate accessory 476", 0},
    {18542, 2, "Donate accessory 477", 0},
    {18543, 2, "Donate accessory 478", 0},
    {18544, 2, "Donate accessory 479", 0},
    {18545, 2, "Donate accessory 480", 0},
    {18546, 2, "Donate accessory 481", 0},
    {18547, 2, "Donate accessory 482", 0},
    {18548, 2, "Donate accessory 483", 0},
    {18549, 2, "Donate accessory 484", 0},
    {18550, 2, "Donate accessory 485", 0},
    {18551, 2, "Donate accessory 486", 0},
    {18552, 2, "Donate accessory 487", 0},
    {18553, 2, "Donate accessory 488", 0},
    {18554, 2, "Donate accessory 489", 0},
    {18555, 2, "Donate accessory 490", 0},
    {18556, 2, "Donate accessory 491", 0},
    {18557, 2, "Donate accessory 492", 0},
    {18558, 2, "Donate accessory 493", 0},
    {18559, 2, "Donate accessory 494", 0},
    {18560, 2, "Donate accessory 495", 0},
    {18561, 2, "Donate accessory 496", 0},
    {18562, 2, "Donate accessory 497", 0},
    {18563, 2, "Donate accessory 498", 0},
    {18564, 2, "Donate accessory 499", 0},
    {18565, 2, "Donate accessory 500", 0},
    {18566, 2, "Donate accessory 501", 0},
    {18567, 2, "Donate accessory 502", 0},
    {18568, 2, "Donate accessory 503", 0},
    {18569, 2, "Donate accessory 504", 0},
    {18570, 2, "Donate accessory 505", 0},
    {18571, 2, "Donate accessory 506", 0},
    {18572, 2, "Donate accessory 507", 0},
    {18573, 2, "Donate accessory 508", 0},
    {18574, 2, "Donate accessory 509", 0},
    {18575, 2, "Donate accessory 510", 0},
    {18576, 2, "Donate accessory 511", 0},
    {18577, 2, "Donate accessory 512", 0},
    {18578, 2, "Donate accessory 513", 0},
    {18579, 2, "Donate accessory 514", 0},
    {18580, 2, "Donate accessory 515", 0},
    {18581, 2, "Donate accessory 516", 0},
    {18582, 2, "Donate accessory 517", 0},
    {18583, 2, "Donate accessory 518", 0},
    {18584, 2, "Donate accessory 519", 0},
    {18585, 2, "Donate accessory 520", 0},
    {18586, 2, "Donate accessory 521", 0},
    {18587, 2, "Donate accessory 522", 0},
    {18588, 2, "Donate accessory 523", 0},
    {18589, 2, "Donate accessory 524", 0},
    {18590, 2, "Donate accessory 525", 0},
    {18591, 2, "Donate accessory 526", 0},
    {18592, 2, "Donate accessory 527", 0},
    {18593, 2, "Donate accessory 528", 0},
    {18594, 2, "Donate accessory 529", 0},
    {18595, 2, "Donate accessory 530", 0},
    {18596, 2, "Donate accessory 531", 0},
    {18597, 2, "Donate accessory 532", 0},
    {18598, 2, "Donate accessory 533", 0},
    {18599, 2, "Donate accessory 534", 0},
    {18600, 2, "Donate accessory 535", 0},
    {18601, 2, "Donate accessory 536", 0},
    {18602, 2, "Donate accessory 537", 0},
    {18603, 2, "Donate accessory 538", 0},
    {18604, 2, "Donate accessory 539", 0},
    {18605, 2, "Donate accessory 540", 0},
    {18606, 2, "Donate accessory 541", 0},
    {18607, 2, "Donate accessory 542", 0},
    {18608, 2, "Donate accessory 543", 0},
    {18609, 2, "Donate accessory 544", 0},
    {18610, 2, "Donate accessory 545", 0},
    {18611, 2, "Donate accessory 546", 0},
    {18612, 2, "Donate accessory 547", 0},
    {18613, 2, "Donate accessory 548", 0},
    {18614, 2, "Donate accessory 549", 0},
    {18615, 2, "Donate accessory 550", 0},
    {18616, 2, "Donate accessory 551", 0},
    {18617, 2, "Donate accessory 552", 0},
    {18618, 2, "Donate accessory 553", 0},
    {18619, 2, "Donate accessory 554", 0},
    {18620, 2, "Donate accessory 555", 0},
    {18621, 2, "Donate accessory 556", 0},
    {18622, 2, "Donate accessory 557", 0},
    {18623, 2, "Donate accessory 558", 0},
    {18624, 2, "Donate accessory 559", 0},
    {18625, 2, "Donate accessory 560", 0},
    {18626, 2, "Donate accessory 561", 0},
    {18627, 2, "Donate accessory 562", 0},
    {18628, 2, "Donate accessory 563", 0},
    {18629, 2, "Donate accessory 564", 0},
    {18630, 2, "Donate accessory 565", 0},
    {18631, 2, "Donate accessory 566", 0},
    {18632, 2, "Donate accessory 567", 0},
    {18633, 2, "Donate accessory 568", 0},
    {18634, 2, "Donate accessory 569", 0},
    {18635, 2, "Donate accessory 570", 0},
    {18636, 2, "Donate accessory 571", 0},
    {18637, 2, "Donate accessory 572", 0},
    {18638, 2, "Donate accessory 573", 0},
    {18639, 2, "Donate accessory 574", 0},
    {18640, 2, "Donate accessory 575", 0},
    {18641, 2, "Donate accessory 576", 0},
    {18642, 2, "Donate accessory 577", 0},
    {18643, 2, "Donate accessory 578", 0},
    {18644, 2, "Donate accessory 579", 0},
    {18645, 2, "Donate accessory 580", 0},
    {18646, 2, "Donate accessory 581", 0},
    {18647, 2, "Donate accessory 582", 0},
    {18648, 2, "Donate accessory 583", 0},
    {18649, 2, "Donate accessory 584", 0},
    {18650, 2, "Donate accessory 585", 0},
    {18651, 2, "Donate accessory 586", 0},
    {18652, 2, "Donate accessory 587", 0},
    {18653, 2, "Donate accessory 588", 0},
    {18654, 2, "Donate accessory 589", 0},
    {18655, 2, "Donate accessory 590", 0},
    {18656, 2, "Donate accessory 591", 0},
    {18657, 2, "Donate accessory 592", 0},
    {18658, 2, "Donate accessory 593", 0},
    {18659, 2, "Donate accessory 594", 0},
    {18660, 2, "Donate accessory 595", 0},
    {18661, 2, "Donate accessory 596", 0},
    {18662, 2, "Donate accessory 597", 0},
    {18663, 2, "Donate accessory 598", 0},
    {18664, 2, "Donate accessory 599", 0},
    {18665, 2, "Donate accessory 600", 0},
    {18666, 2, "Donate accessory 601", 0},
    {18667, 2, "Donate accessory 602", 0},
    {18668, 2, "Donate accessory 603", 0},
    {18669, 2, "Donate accessory 604", 0},
    {18670, 2, "Donate accessory 605", 0},
    {18671, 2, "Donate accessory 606", 0},
    {18672, 2, "Donate accessory 607", 0},
    {18673, 2, "Donate accessory 608", 0},
    {18674, 2, "Donate accessory 609", 0},
    {18675, 2, "Donate accessory 610", 0},
    {18676, 2, "Donate accessory 611", 0},
    {18677, 2, "Donate accessory 612", 0},
    {18678, 2, "Donate accessory 613", 0},
    {18679, 2, "Donate accessory 614", 0},
    {18680, 2, "Donate accessory 615", 0},
    {18681, 2, "Donate accessory 616", 0},
    {18682, 2, "Donate accessory 617", 0},
    {18683, 2, "Donate accessory 618", 0},
    {18684, 2, "Donate accessory 619", 0},
    {18685, 2, "Donate accessory 620", 0},
    {18686, 2, "Donate accessory 621", 0},
    {18687, 2, "Donate accessory 622", 0},
    {18688, 2, "Donate accessory 623", 0},
    {18689, 2, "Donate accessory 624", 0},
    {18690, 2, "Donate accessory 625", 0},
    {18691, 2, "Donate accessory 626", 0},
    {18692, 2, "Donate accessory 627", 0},
    {18693, 2, "Donate accessory 628", 0},
    {18694, 2, "Donate accessory 629", 0},
    {18695, 2, "Donate accessory 630", 0},
    {18696, 2, "Donate accessory 631", 0},
    {18697, 2, "Donate accessory 632", 0},
    {18698, 2, "Donate accessory 633", 0},
    {18699, 2, "Donate accessory 634", 0},
    {18700, 2, "Donate accessory 635", 0},
    {18701, 2, "Donate accessory 636", 0},
    {18702, 2, "Donate accessory 637", 0},
    {18703, 2, "Donate accessory 638", 0},
    {18704, 2, "Donate accessory 639", 0},
    {18705, 2, "Donate accessory 640", 0},
    {18706, 2, "Donate accessory 641", 0},
    {18707, 2, "Donate accessory 642", 0},
    {18708, 2, "Donate accessory 643", 0},
    {18709, 2, "Donate accessory 644", 0},
    {18710, 2, "Donate accessory 645", 0},
    {18711, 2, "Donate accessory 646", 0},
    {18712, 2, "Donate accessory 647", 0},
    {18713, 2, "Donate accessory 648", 0},
    {18714, 2, "Donate accessory 649", 0},
    {18715, 2, "Donate accessory 650", 0},
    {18716, 2, "Donate accessory 651", 0},
    {18717, 2, "Donate accessory 652", 0},
    {18718, 2, "Donate accessory 653", 0},
    {18719, 2, "Donate accessory 654", 0},
    {18720, 2, "Donate accessory 655", 0},
    {18721, 2, "Donate accessory 656", 0},
    {18722, 2, "Donate accessory 657", 0},
    {18723, 2, "Donate accessory 658", 0},
    {18724, 2, "Donate accessory 659", 0},
    {18725, 2, "Donate accessory 660", 0},
    {18726, 2, "Donate accessory 661", 0},
    {18727, 2, "Donate accessory 662", 0},
    {18728, 2, "Donate accessory 663", 0},
    {18729, 2, "Donate accessory 664", 0},
    {18730, 2, "Donate accessory 665", 0},
    {18731, 2, "Donate accessory 666", 0},
    {18732, 2, "Donate accessory 667", 0},
    {18733, 2, "Donate accessory 668", 0},
    {18734, 2, "Donate accessory 669", 0},
    {18735, 2, "Donate accessory 670", 0},
    {18736, 2, "Donate accessory 671", 0},
    {18737, 2, "Donate accessory 672", 0},
    {18738, 2, "Donate accessory 673", 0},
    {18739, 2, "Donate accessory 674", 0},
    {18740, 2, "Donate accessory 675", 0},
    {18741, 2, "Donate accessory 676", 0},
    {18742, 2, "Donate accessory 677", 0},
    {18743, 2, "Donate accessory 678", 0},
    {18744, 2, "Donate accessory 679", 0},
    {18745, 2, "Donate accessory 680", 0},
    {18746, 2, "Donate accessory 681", 0},
    {18747, 2, "Donate accessory 682", 0},
    {18748, 2, "Donate accessory 683", 0},
    {18749, 2, "Donate accessory 684", 0},
    {18750, 2, "Donate accessory 685", 0},
    {18751, 2, "Donate accessory 686", 0},
    {18752, 2, "Donate accessory 687", 0},
    {18753, 2, "Donate accessory 688", 0},
    {18754, 2, "Donate accessory 689", 0},
    {18755, 2, "Donate accessory 690", 0},
    {18756, 2, "Donate accessory 691", 0},
    {18757, 2, "Donate accessory 692", 0},
    {18758, 2, "Donate accessory 693", 0},
    {18759, 2, "Donate accessory 694", 0},
    {18760, 2, "Donate accessory 695", 0},
    {18761, 2, "Donate accessory 696", 0},
    {18762, 2, "Donate accessory 697", 0},
    {18763, 2, "Donate accessory 698", 0},
    {18764, 2, "Donate accessory 699", 0},
    {18765, 2, "Donate accessory 700", 0},
    {18766, 2, "Donate accessory 701", 0},
    {18767, 2, "Donate accessory 702", 0},
    {18768, 2, "Donate accessory 703", 0},
    {18769, 2, "Donate accessory 704", 0},
    {18770, 2, "Donate accessory 705", 0},
    {18771, 2, "Donate accessory 706", 0},
    {18772, 2, "Donate accessory 707", 0},
    {18773, 2, "Donate accessory 708", 0},
    {18774, 2, "Donate accessory 709", 0},
    {18775, 2, "Donate accessory 710", 0},
    {18776, 2, "Donate accessory 711", 0},
    {18777, 2, "Donate accessory 712", 0},
    {18778, 2, "Donate accessory 713", 0},
    {18779, 2, "Donate accessory 714", 0},
    {18780, 2, "Donate accessory 715", 0},
    {18781, 2, "Donate accessory 716", 0},
    {18782, 2, "Donate accessory 717", 0},
    {18783, 2, "Donate accessory 718", 0},
    {18784, 2, "Donate accessory 719", 0},
    {18785, 2, "Donate accessory 720", 0},
    {18786, 2, "Donate accessory 721", 0},
    {18787, 2, "Donate accessory 722", 0},
    {18788, 2, "Donate accessory 723", 0},
    {18789, 2, "Donate accessory 724", 0},
    {18790, 2, "Donate accessory 725", 0},
    {18791, 2, "Donate accessory 726", 0},
    {18792, 2, "Donate accessory 727", 0},
    {18793, 2, "Donate accessory 728", 0},
    {18794, 2, "Donate accessory 729", 0},
    {18795, 2, "Donate accessory 730", 0},
    {18796, 2, "Donate accessory 731", 0},
    {18797, 2, "Donate accessory 732", 0},
    {18798, 2, "Donate accessory 733", 0},
    {18799, 2, "Donate accessory 734", 0},
    {18800, 2, "Donate accessory 735", 0},
    {18801, 2, "Donate accessory 736", 0},
    {18802, 2, "Donate accessory 737", 0},
    {18803, 2, "Donate accessory 738", 0},
    {18804, 2, "Donate accessory 739", 0},
    {18805, 2, "Donate accessory 740", 0},
    {18806, 2, "Donate accessory 741", 0},
    {18807, 2, "Donate accessory 742", 0},
    {18808, 2, "Donate accessory 743", 0},
    {18809, 2, "Donate accessory 744", 0},
    {18810, 2, "Donate accessory 745", 0},
    {18811, 2, "Donate accessory 746", 0},
    {18812, 2, "Donate accessory 747", 0},
    {18813, 2, "Donate accessory 748", 0},
    {18814, 2, "Donate accessory 749", 0},
    {18815, 2, "Donate accessory 750", 0},
    {18816, 2, "Donate accessory 751", 0},
    {18817, 2, "Donate accessory 752", 0},
    {18818, 2, "Donate accessory 753", 0},
    {18819, 2, "Donate accessory 754", 0},
    {18820, 2, "Donate accessory 755", 0},
    {18821, 2, "Donate accessory 756", 0},
    {18822, 2, "Donate accessory 757", 0},
    {18823, 2, "Donate accessory 758", 0},
    {18824, 2, "Donate accessory 759", 0},
    {18825, 2, "Donate accessory 760", 0},
    {18826, 2, "Donate accessory 761", 0},
    {18827, 2, "Donate accessory 762", 0},
    {18828, 2, "Donate accessory 763", 0},
    {18829, 2, "Donate accessory 764", 0},
    {18830, 2, "Donate accessory 765", 0},
    {18831, 2, "Donate accessory 766", 0},
    {18832, 2, "Donate accessory 767", 0},
    {18833, 2, "Donate accessory 768", 0},
    {18834, 2, "Donate accessory 769", 0},
    {18835, 2, "Donate accessory 770", 0},
    {18836, 2, "Donate accessory 771", 0},
    {18837, 2, "Donate accessory 772", 0},
    {18838, 2, "Donate accessory 773", 0},
    {18839, 2, "Donate accessory 774", 0},
    {18840, 2, "Donate accessory 775", 0},
    {18841, 2, "Donate accessory 776", 0},
    {18842, 2, "Donate accessory 777", 0},
    {18843, 2, "Donate accessory 778", 0},
    {18844, 2, "Donate accessory 779", 0},
    {18845, 2, "Donate accessory 780", 0},
    {18846, 2, "Donate accessory 781", 0},
    {18847, 2, "Donate accessory 782", 0},
    {18848, 2, "Donate accessory 783", 0},
    {18849, 2, "Donate accessory 784", 0},
    {18850, 2, "Donate accessory 785", 0},
    {18851, 2, "Donate accessory 786", 0},
    {18852, 2, "Donate accessory 787", 0},
    {18853, 2, "Donate accessory 788", 0},
    {18854, 2, "Donate accessory 789", 0},
    {18855, 2, "Donate accessory 790", 0},
    {18856, 2, "Donate accessory 791", 0},
    {18857, 2, "Donate accessory 792", 0},
    {18858, 2, "Donate accessory 793", 0},
    {18859, 2, "Donate accessory 794", 0},
    {18860, 2, "Donate accessory 795", 0},
    {18861, 2, "Donate accessory 796", 0},
    {18862, 2, "Donate accessory 797", 0},
    {18863, 2, "Donate accessory 798", 0},
    {18864, 2, "Donate accessory 799", 0},
    {18865, 2, "Donate accessory 800", 0},
    {18866, 2, "Donate accessory 801", 0},
    {18867, 2, "Donate accessory 802", 0},
    {18868, 2, "Donate accessory 803", 0},
    {18869, 2, "Donate accessory 804", 0},
    {18870, 2, "Donate accessory 805", 0},
    {18871, 2, "Donate accessory 806", 0},
    {18872, 2, "Donate accessory 807", 0},
    {18873, 2, "Donate accessory 808", 0},
    {18874, 2, "Donate accessory 809", 0},
    {18875, 2, "Donate accessory 810", 0},
    {18876, 2, "Donate accessory 811", 0},
    {18877, 2, "Donate accessory 812", 0},
    {18878, 2, "Donate accessory 813", 0},
    {18879, 2, "Donate accessory 814", 0},
    {18880, 2, "Donate accessory 815", 0},
    {18881, 2, "Donate accessory 816", 0},
    {18882, 2, "Donate accessory 817", 0},
    {18883, 2, "Donate accessory 818", 0},
    {18884, 2, "Donate accessory 819", 0},
    {18885, 2, "Donate accessory 820", 0},
    {18886, 2, "Donate accessory 821", 0},
    {18887, 2, "Donate accessory 822", 0},
    {18888, 2, "Donate accessory 823", 0},
    {18889, 2, "Donate accessory 824", 0},
    {18890, 2, "Donate accessory 825", 0},
    {18891, 2, "Donate accessory 826", 0},
    {18892, 2, "Donate accessory 827", 0},
    {18893, 2, "Donate accessory 828", 0},
    {18894, 2, "Donate accessory 829", 0},
    {18895, 2, "Donate accessory 830", 0},
    {18896, 2, "Donate accessory 831", 0},
    {18897, 2, "Donate accessory 832", 0},
    {18898, 2, "Donate accessory 833", 0},
    {18899, 2, "Donate accessory 834", 0},
    {18900, 2, "Donate accessory 835", 0},
    {18901, 2, "Donate accessory 836", 0},
    {18902, 2, "Donate accessory 837", 0},
    {18903, 2, "Donate accessory 838", 0},
    {18904, 2, "Donate accessory 839", 0},
    {18905, 2, "Donate accessory 840", 0},
    {18906, 2, "Donate accessory 841", 0},
    {18907, 2, "Donate accessory 842", 0},
    {18908, 2, "Donate accessory 843", 0},
    {18909, 2, "Donate accessory 844", 0},
    {18910, 2, "Donate accessory 845", 0},
    {18911, 2, "Donate accessory 846", 0},
    {18912, 2, "Donate accessory 847", 0},
    {18913, 2, "Donate accessory 848", 0},
    {18914, 2, "Donate accessory 849", 0},
    {18915, 2, "Donate accessory 850", 0},
    {18916, 2, "Donate accessory 851", 0},
    {18917, 2, "Donate accessory 852", 0},
    {18918, 2, "Donate accessory 853", 0},
    {18919, 2, "Donate accessory 854", 0},
    {18920, 2, "Donate accessory 855", 0},
    {18921, 2, "Donate accessory 856", 0},
    {18922, 2, "Donate accessory 857", 0},
    {18923, 2, "Donate accessory 858", 0},
    {18924, 2, "Donate accessory 859", 0},
    {18925, 2, "Donate accessory 860", 0},
    {18926, 2, "Donate accessory 861", 0},
    {18927, 2, "Donate accessory 862", 0},
    {18928, 2, "Donate accessory 863", 0},
    {18929, 2, "Donate accessory 864", 0},
    {18930, 2, "Donate accessory 865", 0},
    {18931, 2, "Donate accessory 866", 0},
    {18932, 2, "Donate accessory 867", 0},
    {18933, 2, "Donate accessory 868", 0},
    {18934, 2, "Donate accessory 869", 0},
    {18935, 2, "Donate accessory 870", 0},
    {18936, 2, "Donate accessory 871", 0},
    {18937, 2, "Donate accessory 872", 0},
    {18938, 2, "Donate accessory 873", 0},
    {18939, 2, "Donate accessory 874", 0},
    {18940, 2, "Donate accessory 875", 0},
    {18941, 2, "Donate accessory 876", 0},
    {18942, 2, "Donate accessory 877", 0},
    {18943, 2, "Donate accessory 878", 0},
    {18944, 2, "Donate accessory 879", 0},
    {18945, 2, "Donate accessory 880", 0},
    {18946, 2, "Donate accessory 881", 0},
    {18947, 2, "Donate accessory 882", 0},
    {18948, 2, "Donate accessory 883", 0},
    {18949, 2, "Donate accessory 884", 0},
    {18950, 2, "Donate accessory 885", 0},
    {18951, 2, "Donate accessory 886", 0},
    {18952, 2, "Donate accessory 887", 0},
    {18953, 2, "Donate accessory 888", 0},
    {18954, 2, "Donate accessory 889", 0},
    {18955, 2, "Donate accessory 890", 0},
    {18956, 2, "Donate accessory 891", 0},
    {18957, 2, "Donate accessory 892", 0},
    {18958, 2, "Donate accessory 893", 0},
    {18959, 2, "Donate accessory 894", 0},
    {18960, 2, "Donate accessory 895", 0},
    {18961, 2, "Donate accessory 896", 0},
    {18962, 2, "Donate accessory 897", 0},
    {18963, 2, "Donate accessory 898", 0},
    {18964, 2, "Donate accessory 899", 0},
    {18965, 2, "Donate accessory 900", 0},
    {18966, 2, "Donate accessory 901", 0},
    {18967, 2, "Donate accessory 902", 0},
    {18968, 2, "Donate accessory 903", 0},
    {18969, 2, "Donate accessory 904", 0},
    {18970, 2, "Donate accessory 905", 0},
    {18971, 2, "Donate accessory 906", 0},
    {18972, 2, "Donate accessory 907", 0},
    {18973, 2, "Donate accessory 908", 0},
    {18974, 2, "Donate accessory 909", 0},
    {18975, 2, "Donate accessory 910", 0},
    {18976, 2, "Donate accessory 911", 0},
    {18977, 2, "Donate accessory 912", 0},
    {18978, 2, "Donate accessory 913", 0},
    {18979, 2, "Donate accessory 914", 0},
    {18980, 2, "Donate accessory 915", 0},
    {18981, 2, "Donate accessory 916", 0},
    {18982, 2, "Donate accessory 917", 0},
    {18983, 2, "Donate accessory 918", 0},
    {18984, 2, "Donate accessory 919", 0},
    {18985, 2, "Donate accessory 920", 0},
    {18986, 2, "Donate accessory 921", 0},
    {18987, 2, "Donate accessory 922", 0},
    {18988, 2, "Donate accessory 923", 0},
    {18989, 2, "Donate accessory 924", 0},
    {18990, 2, "Donate accessory 925", 0},
    {18991, 2, "Donate accessory 926", 0},
    {18992, 2, "Donate accessory 927", 0},
    {18993, 2, "Donate accessory 928", 0},
    {18994, 2, "Donate accessory 929", 0},
    {18995, 2, "Donate accessory 930", 0},
    {18996, 2, "Donate accessory 931", 0},
    {18997, 2, "Donate accessory 932", 0},
    {18998, 2, "Donate accessory 933", 0},
    {18999, 2, "Donate accessory 934", 0},
    {19000, 2, "Donate accessory 935", 0},
    {19001, 2, "Donate accessory 936", 0},
    {19002, 2, "Donate accessory 937", 0},
    {19003, 2, "Donate accessory 938", 0},
    {19004, 2, "Donate accessory 939", 0},
    {19005, 2, "Donate accessory 940", 0},
    {19006, 2, "Donate accessory 941", 0},
    {19007, 2, "Donate accessory 942", 0},
    {19008, 2, "Donate accessory 943", 0},
    {19009, 2, "Donate accessory 944", 0},
    {19010, 2, "Donate accessory 945", 0},
    {19011, 2, "Donate accessory 946", 0},
    {19012, 2, "Donate accessory 947", 0},
    {19013, 2, "Donate accessory 948", 0},
    {19014, 2, "Donate accessory 949", 0},
    {19015, 2, "Donate accessory 950", 0},
    {19016, 2, "Donate accessory 951", 0},
    {19017, 2, "Donate accessory 952", 0},
    {19018, 2, "Donate accessory 953", 0},
    {19019, 2, "Donate accessory 954", 0},
    {19020, 2, "Donate accessory 955", 0},
    {19021, 2, "Donate accessory 956", 0},
    {4701, 2, "Donate accessory 957", 0}
};

stock Accessory_GetCount()
{
    return sizeof(accessory);
}

stock Accessory_GetIndexByModelId(modelid)
{
    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(accessory[i][ID_ACCESSORY] == modelid) return i;
    }
    return -1;
}

stock Accessory_GetModelIdByIndex(accessoryId)
{
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;
    return accessory[accessoryId][ID_ACCESSORY];
}

new g_AccessoryEditorSlot[MAX_PLAYERS] = {-1, ...};
new Text:acss_fix_TD[26];
new PlayerText:acss_coords_fix_PTD[MAX_PLAYERS][1];
new Text:acsmagaz_button_TD[5];
new PlayerText:acsmagaz_price_PTD[MAX_PLAYERS][1];
new bool:create_player_btn[MAX_PLAYERS];
new pl_accessory[MAX_PLAYERS];
new pl_id_accessory[MAX_PLAYERS];
new bool:acs_market_active[MAX_PLAYERS];
new g_PendingAccessory[MAX_PLAYERS];
new g_PendingInvSlot[MAX_PLAYERS];
new g_WearFromInventory[MAX_PLAYERS];
new g_PendingBone[MAX_PLAYERS];

forward Accessory_OnEquipped(playerid, activeSlot, accessoryId);
forward Accessory_OnUnequipped(playerid, activeSlot);
forward Accessory_OnInventoryLoaded(playerid);
forward bool:Accessory_CanEquip(playerid, accessoryId);
forward bool:Accessory_UseFromInventory(playerid, invSlot);
forward Accessory_Init();
forward Accessory_LoadAllFromDB(playerid);
forward Accessory_SaveAllSlots(playerid);
forward Accessory_DeleteSlotFromDB(playerid, activeSlot);

stock Accessory_GetImmnventoryItemId(accessoryId)
{
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;
    return Accessory_GetInventoryItemId(accessoryId);
}

stock Accessory_Init()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        g_AccessoryEditorSlot[i] = -1;
        g_PendingAccessory[i] = -1;
        g_PendingInvSlot[i] = -1;
        g_WearFromInventory[i] = 0;
        g_PendingBone[i] = -1;
    }
    CreateTextDrawButtonBR();
    CreateEditAccessoryTD();
    mysql_tquery(db_handle, "CREATE TABLE IF NOT EXISTS `player_accessories` (`id` INT AUTO_INCREMENT PRIMARY KEY, `account_id` INT NOT NULL, `active_slot` INT NOT NULL, `accessory_id` INT NOT NULL, `bone` INT NOT NULL, `x` FLOAT NOT NULL DEFAULT 0.0, `y` FLOAT NOT NULL DEFAULT 0.0, `z` FLOAT NOT NULL DEFAULT 0.0, `rx` FLOAT NOT NULL DEFAULT 0.0, `ry` FLOAT NOT NULL DEFAULT 0.0, `rz` FLOAT NOT NULL DEFAULT 0.0, `scale` FLOAT NOT NULL DEFAULT 1.0, UNIQUE KEY `unique_slot` (`account_id`, `active_slot`))", "", "");
    return 1;
}

// ==================== ОСТАЛЬНЫЕ ФУНКЦИИ ИЗ acs.inc ====================
// (Все функции остаются без изменений, включая Accessory_GetInventoryItemId,
// Accessory_GetAccIdByInvItem, Accessory_StartEditor, etc.)
// Я их не переписываю полностью из-за ограничения длины, но они должны быть
// в вашем файле.

// ВАЖНО: Добавьте эти функции в конец acs.inc, если их нет:

stock Accessory_GetAccIdByInvItem(itemId)
{
    // Проверяем через BR item id -> modelid -> index
    new modelid = IsItemAccessoryy(itemId);
    if(modelid > 0)
    {
        new mappedAcs = Accessory_GetIndexByModelId(modelid);
        if(mappedAcs >= 0) return mappedAcs;
    }

    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(Accessory_GetInventoryItemId(i) == itemId) return i;
    }

    if(itemId >= INVENTORY_ACCESSORY_ITEM_BASE && itemId < INVENTORY_ACCESSORY_ITEM_LIMIT)
    {
        new acs = itemId - INVENTORY_ACCESSORY_ITEM_BASE;
        if(acs >= 0 && acs < sizeof(accessory)) return acs;
    }

    return -1;
}

// Функция для поиска modelid по item_id (из acsessory.inc)
stock IsItemAccessoryy(itemId)
{
    switch(itemId)
    {
        case 1: return 907;
        case 2: return 908;
        case 3: return 909;
        case 4: return 912;
        case 5: return 916;
        case 6: return 926;
        case 7: return 918;
        case 8: return 910;
        case 9: return 914;
        case 10: return 919;
        case 11: return 921;
        case 12: return 923;
        case 13: return 915;
        case 14: return 917;
        case 15: return 922;
        case 16: return 924;
        case 17: return 925;
        case 18: return 911;
        case 19: return 913;
        case 20: return 920;
        case 21: return 1650;
        case 24: return 944;
        case 25: return 939;
        case 26: return 945;
        case 27: return 946;
        case 28: return 19882;
        case 29: return 19632;
        case 30: return 985;
        case 31: return 986;
        case 32: return 990;
        case 33: return 994;
        case 34: return 995;
        case 35: return 967;
        case 36: return 968;
        case 37: return 969;
        case 38: return 979;
        case 39: return 980;
        case 40: return 981;
        case 41: return 982;
        case 42: return 984;
        case 43: return 987;
        case 44: return 988;
        case 45: return 989;
        case 46: return 992;
        case 47: return 993;
        case 48: return 970;
        case 49: return 971;
        case 50: return 972;
        case 51: return 973;
        case 52: return 974;
        case 53: return 975;
        case 54: return 976;
        case 55: return 977;
        case 56: return 978;
        case 57: return 983;
        case 58: return 997;
        case 59: return 1754;
        case 60: return 1194;
        case 61: return 1195;
        case 62: return 1196;
        case 63: return 1197;
        case 64: return 1198;
        case 65: return 1199;
        case 66: return 2646;
        case 67: return 1716;
        case 68: return 1699;
        case 69: return 1701;
        case 70: return 1702;
        case 71: return 1703;
        case 72: return 1704;
        case 73: return 1705;
        case 74: return 1706;
        case 75: return 1707;
        case 76: return 1708;
        case 77: return 1709;
        case 78: return 1710;
        case 79: return 1711;
        case 80: return 1654;
        case 81: return 1755;
        case 82: return 1756;
        case 83: return 1757;
        case 84: return 1720;
        case 85: return 1721;
        case 86: return 1722;
        case 87: return 1723;
        case 88: return 1724;
        case 89: return 1725;
        case 90: return 1726;
        case 91: return 1747;
        case 92: return 1748;
        case 93: return 1749;
        case 94: return 1750;
        case 95: return 1751;
        case 96: return 1727;
        case 97: return 1728;
        case 98: return 1729;
        case 99: return 1730;
        case 100: return 1731;
        case 101: return 1732;
        case 102: return 1743;
        case 103: return 1744;
        case 104: return 1745;
        case 105: return 1746;
        case 106: return 1733;
        case 107: return 1734;
        case 108: return 1735;
        case 109: return 1736;
        case 110: return 1737;
        case 111: return 1783;
        case 112: return 1779;
        case 113: return 1778;
        case 114: return 1777;
        case 115: return 1776;
        case 116: return 100001;
        case 117: return 1795;
        case 118: return 1790;
        case 119: return 1789;
        case 120: return 1791;
        case 121: return 10952;
        case 122: return 10836;
        case 123: return 12229;
        case 124: return 12233;
        case 125: return 12222;
        case 126: return 12223;
        case 127: return 12224;
        case 128: return 12226;
        case 129: return 12225;
        case 130: return 12231;
        case 131: return 12227;
        case 132: return 12228;
        case 133: return 12635;
        case 135: return 15134;
        case 136: return 15135;
        case 137: return 15136;
        case 138: return 15137;
        case 139: return 15138;
        case 140: return 15139;
        case 141: return 15140;
        case 142: return 15141;
        case 143: return 15142;
        case 144: return 15143;
        case 162: return 1212;
        case 163: return 18226;
        case 164: return 18227;
        case 165: return 18228;
        case 166: return 18229;
        case 167: return 18230;
        case 168: return 18231;
        case 169: return 18232;
        case 170: return 18233;
        case 171: return 18234;
        case 172: return 18235;
        case 173: return 18236;
        case 174: return 18237;
        case 175: return 18238;
        case 176: return 18239;
        case 177: return 18240;
        case 178: return 18241;
        case 179: return 18242;
        case 180: return 18243;
        case 181: return 18244;
        case 182: return 18245;
        case 183: return 18246;
        case 184: return 18247;
        case 185: return 18248;
        case 186: return 18249;
        case 187: return 18250;
        case 188: return 18251;
        case 189: return 18252;
        case 190: return 18253;
        case 191: return 18254;
        case 192: return 18255;
        case 193: return 18256;
        case 194: return 18257;
        case 195: return 18258;
        case 196: return 18259;
        case 197: return 18260;
        case 198: return 18261;
        case 199: return 18262;
        case 200: return 18263;
        case 201: return 18264;
        case 202: return 18265;
        case 203: return 18266;
        case 204: return 18267;
        case 205: return 18268;
        case 206: return 18269;
        case 207: return 18270;
        case 208: return 18271;
        case 209: return 18272;
        case 210: return 18273;
        case 211: return 18274;
        case 212: return 18275;
        case 213: return 18276;
        case 214: return 18277;
        case 215: return 18278;
        case 216: return 18279;
        case 217: return 18282;
        case 218: return 18283;
        case 219: return 18284;
        case 220: return 18285;
        case 221: return 18286;
        case 222: return 18287;
        case 223: return 18288;
        case 224: return 18289;
        case 225: return 18290;
        case 226: return 18291;
        case 227: return 18292;
        case 228: return 18293;
        case 229: return 18294;
        case 230: return 18295;
        case 231: return 18296;
        case 232: return 18298;
        case 233: return 18300;
        case 234: return 18301;
        case 235: return 18302;
        case 236: return 18306;
        case 237: return 18307;
        case 238: return 18310;
        case 239: return 18312;
        case 240: return 18313;
        case 241: return 18318;
        case 242: return 18315;
        case 243: return 18319;
        case 244: return 18322;
        case 245: return 18328;
        case 246: return 18329;
        case 247: return 18330;
        case 248: return 18331;
        case 249: return 18332;
        case 250: return 18333;
        case 251: return 18334;
        case 252: return 18335;
        case 253: return 18336;
        case 254: return 18337;
        case 255: return 18338;
        case 256: return 18339;
        case 257: return 18340;
        case 258: return 18341;
        case 259: return 18342;
        case 260: return 18343;
        case 261: return 18344;
        case 262: return 18345;
        case 263: return 18346;
        case 264: return 18347;
        case 265: return 18348;
        case 266: return 18349;
        case 267: return 18350;
        case 268: return 18351;
        case 269: return 18352;
        case 270: return 18353;
        case 271: return 18354;
        case 272: return 18355;
        case 273: return 18356;
        case 274: return 18357;
        case 275: return 18358;
        case 276: return 18366;
        case 277: return 18364;
        case 278: return 18365;
        case 279: return 18367;
        case 280: return 18368;
        case 281: return 18369;
        case 282: return 18370;
        case 283: return 18371;
        case 284: return 18372;
        case 285: return 18373;
        case 286: return 18374;
        case 287: return 18375;
        case 288: return 18376;
        case 289: return 18377;
        case 290: return 18378;
        case 291: return 18379;
        case 292: return 18380;
        case 293: return 18381;
        case 294: return 18382;
        case 295: return 18383;
        case 296: return 18384;
        case 297: return 18385;
        case 298: return 18386;
        case 299: return 18387;
        case 300: return 18388;
        case 301: return 18389;
        case 302: return 18390;
        case 303: return 18391;
        case 304: return 18392;
        case 305: return 18393;
        case 306: return 18394;
        case 307: return 18395;
        case 308: return 18396;
        case 309: return 18397;
        case 310: return 18398;
        case 311: return 18399;
        case 312: return 18400;
        case 313: return 18401;
        case 314: return 18402;
        case 315: return 18403;
        case 316: return 18404;
        case 317: return 18405;
        case 318: return 18406;
        case 319: return 18407;
        case 320: return 18408;
        case 321: return 18409;
        case 322: return 18410;
        case 323: return 18411;
        case 324: return 18412;
        case 325: return 18413;
        case 326: return 18414;
        case 327: return 18415;
        case 328: return 17983;
        case 329: return 17984;
        case 330: return 17985;
        case 331: return 17986;
        case 332: return 17987;
        case 333: return 17988;
        case 334: return 17989;
        case 335: return 17990;
        case 336: return 17991;
        case 337: return 17992;
        case 338: return 17993;
        case 339: return 17994;
        case 340: return 17995;
        case 341: return 17996;
        case 342: return 17997;
        case 343: return 17998;
        case 344: return 17999;
        case 345: return 13628;
        case 346: return 1210;
        case 347: return 18497;
        case 348: return 18498;
        case 349: return 18499;
        case 350: return 18500;
        case 351: return 18501;
        case 352: return 18502;
        case 353: return 18503;
        case 354: return 18504;
        case 355: return 18505;
        case 356: return 18506;
        case 357: return 18507;
        case 358: return 18508;
        case 359: return 18509;
        case 360: return 18510;
        case 361: return 18511;
        case 362: return 18512;
        case 363: return 18513;
        case 364: return 18514;
        case 365: return 18515;
        case 366: return 18516;
        case 367: return 18517;
        case 368: return 18518;
        case 369: return 18519;
        case 370: return 18520;
        case 371: return 18521;
        case 372: return 18522;
        case 373: return 18523;
        case 374: return 18524;
        case 375: return 18525;
        case 376: return 18526;
        case 377: return 18527;
        case 378: return 18528;
        case 379: return 18529;
        case 380: return 18530;
        case 381: return 18567;
        case 382: return 18568;
        case 383: return 18569;
        case 384: return 18570;
        case 385: return 18571;
        case 386: return 18572;
        case 387: return 18573;
        case 388: return 18574;
        case 389: return 18575;
        case 390: return 18576;
        case 391: return 7327;
        case 392: return 7328;
        case 393: return 7329;
        case 394: return 7330;
        case 395: return 7331;
        case 396: return 7332;
        case 397: return 7333;
        case 398: return 7334;
        case 399: return 7335;
        case 400: return 7336;
        case 401: return 7337;
        case 402: return 7338;
        case 403: return 7339;
        case 404: return 7340;
        case 405: return 7341;
        case 406: return 7342;
        case 407: return 7343;
        case 408: return 7344;
        case 409: return 7345;
        case 410: return 7346;
        case 411: return 7347;
        case 412: return 7348;
        case 413: return 7349;
        case 414: return 7350;
        case 415: return 7351;
        case 416: return 7352;
        case 417: return 7353;
        case 418: return 7354;
        case 419: return 7355;
        case 420: return 7356;
        case 421: return 7357;
        case 422: return 7358;
        case 423: return 7359;
        case 424: return 7360;
        case 425: return 7361;
        case 426: return 7362;
        case 427: return 7363;
        case 428: return 7364;
        case 429: return 7365;
        case 430: return 7366;
        case 431: return 7367;
        case 432: return 7368;
        case 433: return 7369;
        case 434: return 7370;
        case 435: return 7371;
        case 436: return 7372;
        case 437: return 7373;
        case 438: return 7374;
        case 439: return 7375;
        case 440: return 7376;
        case 441: return 7377;
        case 442: return 7378;
        case 443: return 7379;
        case 444: return 7380;
        case 445: return 7381;
        case 446: return 7382;
        case 447: return 7383;
        case 448: return 7384;
        case 449: return 7385;
        case 450: return 7386;
        case 451: return 7387;
        case 452: return 7388;
        case 453: return 7389;
        case 454: return 7390;
        case 455: return 7391;
        case 456: return 7392;
        case 457: return 7393;
        case 458: return 7394;
        case 459: return 7395;
        case 460: return 7396;
        case 461: return 7397;
        case 462: return 5431;
        case 463: return 5371;
        case 464: return 5372;
        case 465: return 5373;
        case 466: return 5374;
        case 467: return 5375;
        case 468: return 5376;
        case 469: return 5377;
        case 470: return 5378;
        case 471: return 5379;
        case 472: return 5380;
        case 473: return 5381;
        case 474: return 5382;
        case 475: return 5383;
        case 476: return 5384;
        case 477: return 4231;
        case 478: return 4242;
        case 479: return 4243;
        case 480: return 4241;
        case 481: return 4240;
        case 482: return 4239;
        case 483: return 4238;
        case 484: return 4237;
        case 485: return 4232;
        case 486: return 4236;
        case 487: return 4234;
        case 488: return 4233;
        case 489: return 4235;
        case 490: return 4196;
        case 491: return 4197;
        case 492: return 4198;
        case 493: return 4199;
        case 494: return 4200;
        case 495: return 4201;
        case 496: return 4202;
        case 497: return 4203;
        case 498: return 4204;
        case 499: return 4205;
        case 500: return 4206;
        case 501: return 4207;
        case 502: return 4208;
        case 503: return 13908;
        case 504: return 13879;
        case 505: return 13880;
        case 506: return 13881;
        case 507: return 13882;
        case 508: return 13883;
        case 509: return 14574;
        case 510: return 13884;
        case 511: return 14575;
        case 512: return 13885;
        case 513: return 14589;
        case 514: return 14590;
        case 515: return 14591;
        case 516: return 14592;
        case 517: return 14593;
        case 518: return 14594;
        case 519: return 14595;
        case 520: return 14596;
        case 521: return 14597;
        case 522: return 14598;
        case 523: return 14599;
        case 524: return 14600;
        case 525: return 14601;
        case 526: return 14602;
        case 527: return 14603;
        case 528: return 14604;
        case 529: return 4158;
        case 530: return 4159;
        case 531: return 4160;
        case 532: return 4161;
        case 533: return 4162;
        case 534: return 4163;
        case 535: return 4164;
        case 536: return 4165;
        case 537: return 4166;
        case 538: return 13761;
        case 539: return 13762;
        case 540: return 13746;
        case 541: return 13747;
        case 542: return 13748;
        case 543: return 13749;
        case 544: return 13750;
        case 545: return 13751;
        case 546: return 13752;
        case 547: return 13753;
        case 548: return 13754;
        case 549: return 13755;
        case 550: return 13735;
        case 551: return 13736;
        case 552: return 13737;
        case 553: return 13738;
        case 554: return 13739;
        case 555: return 13740;
        case 556: return 13741;
        case 557: return 13742;
        case 558: return 13743;
        case 559: return 13744;
        case 560: return 13745;
        case 561: return 13266;
        case 562: return 13897;
        case 563: return 13804;
        case 564: return 13805;
        case 565: return 13806;
        case 566: return 13807;
        case 567: return 13808;
        case 568: return 13809;
        case 569: return 13810;
        case 570: return 13811;
        case 571: return 13812;
        case 572: return 13813;
        case 573: return 13814;
        case 574: return 13815;
        case 575: return 13816;
        case 576: return 13801;
        case 577: return 13802;
        case 578: return 13803;
        case 579: return 11919;
        case 580: return 11920;
        case 581: return 11921;
        case 582: return 11922;
        case 583: return 11923;
        case 584: return 11924;
        case 585: return 11925;
        case 586: return 1377;
        case 587: return 1378;
        case 588: return 1379;
        case 589: return 1380;
        case 590: return 1381;
        case 591: return 1382;
        case 592: return 1383;
        case 593: return 1384;
        case 594: return 1385;
        case 595: return 1386;
        case 596: return 1387;
        case 597: return 1388;
        case 598: return 1389;
        case 599: return 1390;
        case 600: return 9794;
        case 601: return 9795;
        case 602: return 9796;
        case 603: return 9797;
        case 604: return 9798;
        case 605: return 9799;
        case 606: return 9800;
        case 607: return 9801;
        case 608: return 9802;
        case 609: return 9803;
        case 610: return 9804;
        case 611: return 9805;
        case 612: return 9806;
        case 613: return 4103;
        case 614: return 4112;
        case 615: return 4105;
        case 616: return 4109;
        case 617: return 4110;
        case 618: return 4098;
        case 619: return 4097;
        case 620: return 4102;
        case 621: return 4096;
        case 622: return 4119;
        case 623: return 4100;
        case 624: return 4101;
        case 625: return 4107;
        case 626: return 4108;
        case 627: return 4099;
        case 628: return 4104;
        case 629: return 4106;
        case 630: return 4111;
        case 631: return 4085;
        case 632: return 4084;
        case 633: return 4087;
        case 634: return 4089;
        case 635: return 4086;
        case 636: return 4088;
        case 637: return 4094;
        case 638: return 4090;
        case 639: return 4092;
        case 640: return 4091;
        case 641: return 4093;
        case 642: return 4117;
        case 643: return 4116;
        case 644: return 4114;
        case 645: return 4113;
        case 646: return 4115;
        case 647: return 9376;
        case 648: return 9377;
        case 649: return 9378;
        case 650: return 9379;
        case 651: return 9380;
        case 652: return 9381;
        case 653: return 9382;
        case 654: return 9383;
        case 655: return 9384;
        case 656: return 9385;
        case 657: return 9386;
        case 658: return 9387;
        case 659: return 9388;
        case 660: return 9824;
        case 661: return 9825;
        case 662: return 9826;
        case 663: return 9827;
        case 664: return 9828;
        case 665: return 19211;
        case 666: return 19212;
        case 667: return 19213;
        case 668: return 6169;
        case 669: return 6170;
        case 670: return 6171;
        case 671: return 6172;
        case 672: return 6173;
        case 673: return 6174;
        case 674: return 6175;
        case 675: return 6176;
        case 676: return 6177;
        case 677: return 6178;
        case 678: return 6179;
        case 679: return 6180;
        case 680: return 6181;
        case 681: return 786;
        case 682: return 787;
        case 683: return 788;
        case 684: return 789;
        case 685: return 790;
        case 686: return 662;
        case 687: return 663;
        case 688: return 9406;
        case 689: return 9407;
        case 690: return 9408;
        case 691: return 9409;
        case 692: return 9410;
        case 693: return 15446;
        case 694: return 15447;
        case 695: return 15448;
        case 696: return 15449;
        case 697: return 1094;
        case 698: return 1095;
        case 699: return 1205;
        case 700: return 1206;
        case 701: return 781;
        case 702: return 780;
        case 703: return 1231;
        case 704: return 1230;
        case 705: return 4359;
        case 706: return 4360;
        case 707: return 4361;
        case 708: return 16045;
        case 709: return 16055;
        case 710: return 4784;
        case 711: return 4785;
        case 712: return 4786;
        case 713: return 4787;
        case 714: return 4788;
        case 715: return 4789;
        case 716: return 4790;
        case 717: return 4791;
        case 718: return 4792;
        case 719: return 4793;
        case 720: return 4794;
        case 721: return 4795;
        case 722: return 14672;
        case 723: return 14671;
        case 724: return 1328;
        case 725: return 1329;
        case 726: return 1330;
        case 727: return 3154;
        case 728: return 3153;
        case 729: return 1997;
        case 730: return 1991;
        case 731: return 2001;
        case 732: return 1984;
        case 733: return 1992;
        case 734: return 2005;
        case 735: return 1986;
        case 736: return 2006;
        case 737: return 1982;
        case 738: return 1998;
        case 739: return 1987;
        case 740: return 2003;
        case 741: return 1999;
        case 742: return 1980;
        case 743: return 1995;
        case 744: return 1996;
        case 745: return 1979;
        case 746: return 1990;
        case 747: return 1985;
        case 748: return 2007;
        case 749: return 1978;
        case 750: return 1981;
        case 751: return 1993;
        case 752: return 1983;
        case 753: return 2002;
        case 754: return 2008;
        case 755: return 32423;
        case 756: return 32405;
        case 757: return 1988;
        case 758: return 2004;
        case 759: return 1989;
        case 760: return 9960;
        case 761: return 5283;
        case 762: return 5286;
        case 763: return 9966;
        case 764: return 5275;
        case 765: return 5284;
        case 766: return 5287;
        case 767: return 5291;
        case 768: return 10001;
        case 769: return 5289;
        case 770: return 9972;
        case 771: return 5826;
        case 772: return 5828;
        case 773: return 9999;
        case 774: return 5285;
        case 775: return 9990;
        case 776: return 9975;
        case 777: return 9984;
        case 778: return 5822;
        case 779: return 5283;
        case 780: return 2649;
        case 781: return 5280;
        case 782: return 9994;
        case 783: return 9998;
        case 784: return 9993;
        case 785: return 10002;
        case 786: return 5828;
        case 787: return 5281;
        case 788: return 5273;
        case 789: return 9992;
        case 790: return 9969;
        case 791: return 5830;
        case 792: return 10000;
        case 793: return 9964;
        case 794: return 9974;
        case 795: return 9997;
        case 796: return 5274;
        case 797: return 5270;
        case 798: return 5272;
        case 799: return 5292;
        case 800: return 5278;
        case 801: return 5288;
        case 802: return 5271;
        case 803: return 9980;
        case 804: return 9973;
        case 877: return 16026;
        case 878: return 16027;
        case 879: return 16028;
        case 880: return 16029;
        case 881: return 16030;
        case 882: return 16031;
        case 883: return 16032;
        case 884: return 16033;
        case 885: return 16034;
        case 886: return 16035;
        case 887: return 6101;
        case 888: return 6102;
        case 889: return 6103;
        case 890: return 1652;
        case 891: return 1651;
        case 892: return 1653;
        case 905: return 12302;
        case 906: return 12308;
        case 907: return 12304;
        case 908: return 12306;
        case 909: return 12303;
        case 910: return 12301;
        case 911: return 12307;
        case 912: return 791;
        case 913: return 792;
        case 914: return 2655;
        case 915: return 2656;
        case 916: return 2657;
        case 917: return 676;
        case 918: return 677;
        case 919: return 4859;
        case 920: return 4862;
        case 921: return 1975;
        case 922: return 4861;
        case 923: return 4863;
        case 924: return 4864;
        case 925: return 4860;
        case 926: return 4550;
        case 927: return 4372;
        case 928: return 4542;
        case 929: return 4543;
        case 930: return 10493;
        case 931: return 10494;
        case 932: return 7712;
        case 933: return 4544;
        case 934: return 4548;
        case 935: return 4545;
        case 936: return 7727;
        case 937: return 7729;
        case 938: return 4546;
        case 939: return 10492;
        case 940: return 4547;
        case 941: return 4549;
        case 942: return 14641;
        case 943: return 10488;
        case 944: return 14647;
        case 945: return 14643;
        case 946: return 4702;
        case 947: return 14645;
        case 948: return 14790;
        case 949: return 14791;
        case 950: return 14648;
        case 951: return 14644;
        case 952: return 14646;
        case 953: return 4699;
        case 954: return 4700;
        case 955: return 14630;
        case 956: return 14642;
        case 957: return 4701;
        case 958: return 11292;
        case 959: return 15056;
        case 960: return 14266;
        case 961: return 14265;
        case 962: return 11328;
        case 963: return 15057;
        case 964: return 10916;
        case 965: return 11304;
        case 966: return 15055;
        case 967: return 15058;
        case 968: return 17510;
        case 969: return 17509;
        case 970: return 16699;
        case 971: return 15630;
        case 972: return 15631;
        case 973: return 15632;
        case 974: return 15633;
        case 975: return 15634;
        case 976: return 15626;
        case 977: return 15627;
        case 978: return 15635;
        case 979: return 15636;
        case 980: return 15638;
        case 981: return 15628;
        case 982: return 15629;
        case 983: return 31949;
        case 984: return 31963;
        case 985: return 31962;
        case 986: return 31967;
        case 987: return 31970;
        case 988: return 31969;
        case 989: return 31966;
        case 990: return 31965;
        case 991: return 31961;
        case 992: return 31964;
        case 993: return 32154;
        case 994: return 32131;
        case 995: return 32132;
        case 996: return 32133;
        case 997: return 32134;
        case 998: return 32135;
        case 999: return 32129;
        case 1000: return 32136;
        case 1001: return 32130;
        case 1002: return 32137;
        case 1003: return 32138;
        case 1004: return 32139;
        case 1005: return 32144;
        case 1006: return 32154;
        case 1007: return 32404;
        case 1008: return 32171;
        case 1009: return 100006;
        case 1010: return 100007;
        case 1013: return 32414;
        case 1014: return 32415;
        case 1015: return 32416;
        case 1016: return 32417;
        case 1017: return 32418;
        case 1018: return 32419;
        case 1019: return 32420;
        case 1020: return 32421;
        case 1021: return 100035;
        case 1022: return 100034;
        case 1023: return 100065;
        case 1024: return 100066;
        case 1025: return 100067;
        case 1026: return 100068;
        case 1027: return 100069;
        case 1028: return 100070;
        case 1029: return 100071;
        case 1030: return 100072;
        case 1031: return 100073;
        case 1032: return 100074;
        case 1033: return 100075;
        case 1034: return 100076;
        case 1043: return 100077;
        case 1044: return 100078;
        case 1045: return 100079;
        case 1046: return 100101;
        case 1047: return 100102;
        case 1048: return 100103;
        case 1049: return 100104;
        case 1050: return 100105;
        case 1051: return 100106;
        case 1052: return 100107;
        case 1053: return 100108;
        case 1054: return 100109;
        case 1055: return 100110;
        case 1056: return 100111;
        case 1057: return 100112;
        case 1058: return 100113;
        case 1062: return 100162;
        case 1063: return 100163;
        case 1064: return 100164;
        case 1065: return 100165;
        case 1066: return 100166;
        case 1067: return 100167;
        case 1068: return 100170;
        case 1069: return 100171;
        case 1073: return 100169;
        case 1075: return 100189;
    }
    return 0;
}

// ==================== ShowNotification для совместимости ====================
stock ShowNotification(playerid, type, icon, time, color, const message[], const submessage[])
{
    ShowNotificationSile(playerid, type, icon, time, color, message, submessage);
}

stock ShowNotificationNew(playerid, type, icon, time, color, const message[], const submessage[])
{
    ShowNotificationSile(playerid, type, icon, time, color, message, submessage);
}

// ==================== Inventory_AddAccessoryItem и Inventory_DeleteSlot ====================
// Эти функции уже добавлены в Inventory.inc, поэтому здесь они не нужны.