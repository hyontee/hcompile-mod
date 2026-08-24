#if defined _acs_included
    #endinput
#endif
#define _acs_included

#include <a_samp>
//#include "../include/system/inv.inc"
#include "../include/system/acsessory.inc"

#define ACCESSORY_DIALOG_SLOT_SELECT (1190)
#define ACCESSORY_DIALOG_EDITOR_ACTION (1191)
#define ACCESSORY_DIALOG_WEAR_CONFIRM (1192)
#define ACCESSORY_DIALOG_BONE_SELECT (1193)
#define ACCESSORY_DIALOG_BUY_CONFIRM (1194)

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

stock ConvertMoneyACS(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9') strins(string, ".", i, length);
        else return;
    }
    if(money < 0) strins(string, "-", 0, length);
}

stock CreatePlTDButtonBR(playerid)
{
    acsmagaz_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 319.7778, 373.6799, "100.000_руб.");
    PlayerTextDrawLetterSize(playerid, acsmagaz_price_PTD[playerid][0], 0.2531, 1.3509);
    PlayerTextDrawTextSize(playerid, acsmagaz_price_PTD[playerid][0], 0.0000, -17.0000);
    PlayerTextDrawAlignment(playerid, acsmagaz_price_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, acsmagaz_price_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, acsmagaz_price_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, acsmagaz_price_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, acsmagaz_price_PTD[playerid][0], 1);
    create_player_btn[playerid] = true;
    return 1;
}

stock CreateTextDrawButtonBR()
{
    acsmagaz_button_TD[0] = TextDrawCreate(69.0000, 202.0000, "txd:brrainleft");
    TextDrawTextSize(acsmagaz_button_TD[0], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[0], 1);
    TextDrawColor(acsmagaz_button_TD[0], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[0], 255);
    TextDrawFont(acsmagaz_button_TD[0], 4);
    TextDrawSetSelectable(acsmagaz_button_TD[0], true);

    acsmagaz_button_TD[1] = TextDrawCreate(542.0000, 202.0000, "txd:brrainright");
    TextDrawTextSize(acsmagaz_button_TD[1], 27.0000, 43.0000);
    TextDrawAlignment(acsmagaz_button_TD[1], 1);
    TextDrawColor(acsmagaz_button_TD[1], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[1], 255);
    TextDrawFont(acsmagaz_button_TD[1], 4);
    TextDrawSetSelectable(acsmagaz_button_TD[1], true);

    acsmagaz_button_TD[2] = TextDrawCreate(234.7776, 371.0354, "txd:brtuning4nstage2");
    TextDrawTextSize(acsmagaz_button_TD[2], 171.0000, 21.0000);
    TextDrawAlignment(acsmagaz_button_TD[2], 1);
    TextDrawColor(acsmagaz_button_TD[2], -12705281);
    TextDrawBackgroundColor(acsmagaz_button_TD[2], 255);
    TextDrawFont(acsmagaz_button_TD[2], 4);

    acsmagaz_button_TD[3] = TextDrawCreate(240.4443, 384.0000, "txd:braucubuy");
    TextDrawTextSize(acsmagaz_button_TD[3], 78.0000, 58.0000);
    TextDrawAlignment(acsmagaz_button_TD[3], 1);
    TextDrawColor(acsmagaz_button_TD[3], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[3], 255);
    TextDrawFont(acsmagaz_button_TD[3], 4);
    TextDrawSetSelectable(acsmagaz_button_TD[3], true);

    acsmagaz_button_TD[4] = TextDrawCreate(320.2221, 382.5065, "txd:braucexit");
    TextDrawTextSize(acsmagaz_button_TD[4], 83.0000, 60.0000);
    TextDrawAlignment(acsmagaz_button_TD[4], 1);
    TextDrawColor(acsmagaz_button_TD[4], -1);
    TextDrawBackgroundColor(acsmagaz_button_TD[4], 255);
    TextDrawFont(acsmagaz_button_TD[4], 4);
    TextDrawSetSelectable(acsmagaz_button_TD[4], true);
    return 1;
}

stock CreateEditAccessoryTD()
{
    acss_fix_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
    TextDrawTextSize(acss_fix_TD[0], 127.0000, 45.0000);
    TextDrawAlignment(acss_fix_TD[0], 1);
    TextDrawColor(acss_fix_TD[0], -1);
    TextDrawBackgroundColor(acss_fix_TD[0], 255);
    TextDrawFont(acss_fix_TD[0], 4);

    acss_fix_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
    TextDrawTextSize(acss_fix_TD[1], 45.0000, 50.0000);
    TextDrawAlignment(acss_fix_TD[1], 1);
    TextDrawColor(acss_fix_TD[1], -1);
    TextDrawBackgroundColor(acss_fix_TD[1], 255);
    TextDrawFont(acss_fix_TD[1], 4);
    TextDrawSetSelectable(acss_fix_TD[1], true);

    acss_fix_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
    TextDrawTextSize(acss_fix_TD[2], 130.0000, 40.0000);
    TextDrawAlignment(acss_fix_TD[2], 1);
    TextDrawColor(acss_fix_TD[2], -1);
    TextDrawBackgroundColor(acss_fix_TD[2], 255);
    TextDrawFont(acss_fix_TD[2], 4);
    TextDrawSetSelectable(acss_fix_TD[2], true);

    for(new i = 3; i < 10; i++)
    {
        new txdStr[16];
        format(txdStr, sizeof(txdStr), "txd:bracsn%d", i-2);
        acss_fix_TD[i] = TextDrawCreate(35.0000, 65.0 + (i-3)*45.0, txdStr);
        TextDrawTextSize(acss_fix_TD[i], 117.0000, 42.0000);
        TextDrawAlignment(acss_fix_TD[i], 1);
        TextDrawColor(acss_fix_TD[i], -1);
        TextDrawBackgroundColor(acss_fix_TD[i], 255);
        TextDrawFont(acss_fix_TD[i], 4);
        TextDrawSetSelectable(acss_fix_TD[i], true);
    }

    for(new i = 10; i < 17; i++)
    {
        new txdStr[16];
        format(txdStr, sizeof(txdStr), "txd:bracsa%d", i-9);
        acss_fix_TD[i] = TextDrawCreate(35.0000, 65.0 + (i-10)*45.0, txdStr);
        TextDrawTextSize(acss_fix_TD[i], 117.0000, 42.0000);
        TextDrawAlignment(acss_fix_TD[i], 1);
        TextDrawColor(acss_fix_TD[i], -1);
        TextDrawBackgroundColor(acss_fix_TD[i], 255);
        TextDrawFont(acss_fix_TD[i], 4);
    }

    for(new i = 17; i < 24; i++)
    {
        new txdStr[16];
        format(txdStr, sizeof(txdStr), "txd:bracsm%d", i-16);
        acss_fix_TD[i] = TextDrawCreate(430.0000, 100.0000, txdStr);
        TextDrawTextSize(acss_fix_TD[i], 180.0000, 230.0000);
        TextDrawAlignment(acss_fix_TD[i], 1);
        TextDrawColor(acss_fix_TD[i], -1);
        TextDrawBackgroundColor(acss_fix_TD[i], 255);
        TextDrawFont(acss_fix_TD[i], 4);
        TextDrawSetProportional(acss_fix_TD[i], 0);
        TextDrawSetShadow(acss_fix_TD[i], 0);
    }

    acss_fix_TD[24] = TextDrawCreate(460.0000, 205.0000, "ld_beat:up");
    TextDrawTextSize(acss_fix_TD[24], 45.0000, 45.0000);
    TextDrawAlignment(acss_fix_TD[24], 1);
    TextDrawColor(acss_fix_TD[24], 0xFFFFFF00);
    TextDrawBackgroundColor(acss_fix_TD[24], 255);
    TextDrawFont(acss_fix_TD[24], 4);
    TextDrawSetSelectable(acss_fix_TD[24], true);

    acss_fix_TD[25] = TextDrawCreate(530.0000, 205.0000, "ld_beat:up");
    TextDrawTextSize(acss_fix_TD[25], 45.0000, 45.0000);
    TextDrawAlignment(acss_fix_TD[25], 1);
    TextDrawColor(acss_fix_TD[25], 0xFFFFFF00);
    TextDrawBackgroundColor(acss_fix_TD[25], 255);
    TextDrawFont(acss_fix_TD[25], 4);
    TextDrawSetSelectable(acss_fix_TD[25], true);
    return 1;
}

stock SetPriceAccesory(playerid, acs)
{
    new string[32], moneyStringAcs[24];
    if(acs < 0 || acs >= sizeof(accessory)) return 0;
    ConvertMoneyACS(accessory[acs][PRICE_ACCESSORY], moneyStringAcs);
    format(string, sizeof string, "%s_руб.", moneyStringAcs);
    PlayerTextDrawSetString(playerid, acsmagaz_price_PTD[playerid][0], string);
    return 1;
}

stock Accessory_SaveEditedSlot(playerid)
{
    new slot = g_AccessoryEditorSlot[playerid];
    if(slot < 2 || slot >= MAX_ACTIVE_SLOTS) return 0;
    if(Player[playerid][pID] <= 0) return 0;
    new acs = GetPVarInt(playerid, "acs_id");
    if(acs < 0 || acs >= sizeof(accessory)) return 0;
    new bone = GetPVarInt(playerid, "bone");
    new Float:x = GetPVarFloat(playerid, "edit_x");
    new Float:y = GetPVarFloat(playerid, "edit_y");
    new Float:z = GetPVarFloat(playerid, "edit_z");
    new Float:rx = GetPVarFloat(playerid, "edit_rX");
    new Float:ry = GetPVarFloat(playerid, "edit_rY");
    new Float:rz = GetPVarFloat(playerid, "edit_rZ");
    new Float:scale = GetPVarFloat(playerid, "edit_scale");
    new query[512];
    mysql_format(db_handle, query, sizeof(query), "INSERT INTO `player_accessories` (`account_id`, `active_slot`, `accessory_id`, `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale`) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f) ON DUPLICATE KEY UPDATE `accessory_id` = VALUES(`accessory_id`), `bone` = VALUES(`bone`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `rx` = VALUES(`rx`), `ry` = VALUES(`ry`), `rz` = VALUES(`rz`), `scale` = VALUES(`scale`)", Player[playerid][pID], slot, acs, bone, x, y, z, rx, ry, rz, scale);
    mysql_query(db_handle, query);
    return 1;
}

stock Accessory_ApplyAndSaveSlot(playerid, activeSlot, accessoryId, bone)
{
    if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;

    new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
    new Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:scale = 1.0;

    if(Player[playerid][pID] > 0)
    {
        new q[256];
        mysql_format(db_handle, q, sizeof(q), "SELECT `x`,`y`,`z`,`rx`,`ry`,`rz`,`scale` FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1", Player[playerid][pID], activeSlot);
        new Cache:result = mysql_query(db_handle, q);
        if(cache_num_rows() > 0)
        {
            x = cache_get_field_content_float(0, "x");
            y = cache_get_field_content_float(0, "y");
            z = cache_get_field_content_float(0, "z");
            rx = cache_get_field_content_float(0, "rx");
            ry = cache_get_field_content_float(0, "ry");
            rz = cache_get_field_content_float(0, "rz");
            scale = cache_get_field_content_float(0, "scale");
            if(scale <= 0.0) scale = 1.0;
        }
        cache_delete(result);

        new query[512];
        mysql_format(db_handle, query, sizeof(query), "INSERT INTO `player_accessories` (`account_id`, `active_slot`, `accessory_id`, `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale`) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f) ON DUPLICATE KEY UPDATE `accessory_id` = VALUES(`accessory_id`), `bone` = VALUES(`bone`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `rx` = VALUES(`rx`), `ry` = VALUES(`ry`), `rz` = VALUES(`rz`), `scale` = VALUES(`scale`)", Player[playerid][pID], activeSlot, accessoryId, bone, x, y, z, rx, ry, rz, scale);
        mysql_query(db_handle, query);
    }

    SetPlayerAttachedObject(playerid, activeSlot, accessory[accessoryId][ID_ACCESSORY], bone, x, y, z, rx, ry, rz, scale, scale, scale);
    return 1;
}

stock Accessory_OnEquipped(playerid, activeSlot, accessoryId)
{
    return Accessory_LoadAndApplySlot(playerid, activeSlot, accessoryId);
}

stock bool:Accessory_CanEquip(playerid, accessoryId)
{
    return true;
}

stock Accessory_OnUnequipped(playerid, activeSlot)
{
    if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(IsPlayerAttachedObjectSlotUsed(playerid, activeSlot)) RemovePlayerAttachedObject(playerid, activeSlot);
    return 1;
}

stock Accessory_GetSlotAccessoryId(playerid, slot)
{
    if(slot < SLOT_ACCESSORY_START || slot > SLOT_ACCESSORY_END) return -1;
    if(GetItemType(g_PlayerActiveSlots[playerid][slot][inv_itemId]) != ITEM_TYPE_ACCESSORY) return -1;

    new acs = -1;
    if(g_PlayerActiveSlots[playerid][slot][inv_itemPlate][0] != 0) acs = strval(g_PlayerActiveSlots[playerid][slot][inv_itemPlate]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = Accessory_GetAccIdByInvItem(g_PlayerActiveSlots[playerid][slot][inv_itemId]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = g_PlayerActiveSlots[playerid][slot][inv_itemCount];
    if(acs < 0 || acs >= sizeof(accessory)) return -1;
    return acs;
}

stock Accessory_OnInventoryLoaded(playerid)
{
    new bool:needSave = false;

    for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
    {
        if(GetItemType(g_PlayerActiveSlots[playerid][s][inv_itemId]) == ITEM_TYPE_ACCESSORY)
        {
            new acs = -1;

            if(g_PlayerActiveSlots[playerid][s][inv_itemPlate][0] != 0)
            {
                acs = strval(g_PlayerActiveSlots[playerid][s][inv_itemPlate]);
            }

            if(acs < 0 || acs >= sizeof(accessory))
            {
                acs = Accessory_GetAccIdByInvItem(g_PlayerActiveSlots[playerid][s][inv_itemId]);
            }

            if(acs < 0 || acs >= sizeof(accessory))
            {
                acs = g_PlayerActiveSlots[playerid][s][inv_itemCount];
            }

            if(acs >= 0 && acs < sizeof(accessory))
            {
                new guiItemId = Accessory_GetInventoryItemId(acs);
                new acsPlate[12];
                valstr(acsPlate, acs);

                if(g_PlayerActiveSlots[playerid][s][inv_itemId] != guiItemId || strcmp(g_PlayerActiveSlots[playerid][s][inv_itemPlate], acsPlate, true) != 0)
                {
                    g_PlayerActiveSlots[playerid][s][inv_itemId] = guiItemId;
                    g_PlayerActiveSlots[playerid][s][inv_itemCount] = 1;
                    g_PlayerActiveSlots[playerid][s][inv_itemType] = ITEM_TYPE_ACCESSORY;
                    format(g_PlayerActiveSlots[playerid][s][inv_itemPlate], 32, "%s", acsPlate);
                    needSave = true;
                }

                Accessory_LoadAndApplySlot(playerid, s, acs);
            }
        }
        else
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, s)) RemovePlayerAttachedObject(playerid, s);
        }
    }

    if(needSave) Inventory_Save(playerid);
    return 1;
}

stock Accessory_OnPlayerSpawn(playerid)
{
    Accessory_LoadAllFromDB(playerid);
    return Accessory_OnInventoryLoaded(playerid);
}

stock Accessory_StopEditor(playerid, bool:save)
{
    if(g_AccessoryEditorSlot[playerid] < 2) return 0;
    if(save)
    {
        Accessory_SaveEditedSlot(playerid);
        Accessory_OnInventoryLoaded(playerid);
        Inventory_Save(playerid);
    }
    for(new i = 0; i < sizeof(acss_fix_TD); i++) TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, acss_coords_fix_PTD[playerid][0]);
        acss_coords_fix_PTD[playerid][0] = PlayerText:INVALID_TEXT_DRAW;
    }
    CancelSelectTextDraw(playerid);
    g_AccessoryEditorSlot[playerid] = -1;
    DeletePVar(playerid, "acs_id");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "edit_x");
    DeletePVar(playerid, "edit_y");
    DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX");
    DeletePVar(playerid, "edit_rY");
    DeletePVar(playerid, "edit_rZ");
    DeletePVar(playerid, "edit_scale");
    DeletePVar(playerid, "acss_TD_use");
    if(g_WearFromInventory[playerid])
    {
        g_WearFromInventory[playerid] = 0;
        ShowPlayerInventory(playerid);
    }
    return 1;
}

stock Accessory_WearWithBone(playerid, accessoryId, invSlot, bone)
{
    new activeSlot = -1;

    for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
    {
        if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0)
        {
            activeSlot = s;
            break;
        }
    }

    if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS)
    {
        ShowNotification(playerid, 2, 6, 0, 0, "Нет свободного слота для аксессуара", "");
        ShowPlayerInventory(playerid);
        return false;
    }

    new itemId = Accessory_GetInventoryItemId(accessoryId);
    new plateStr[12];
    valstr(plateStr, accessoryId);

    Inventory_SetActiveItem(playerid, activeSlot, itemId, 1, plateStr);
    Inventory_DeleteSlot(playerid, invSlot);
    Inventory_Save(playerid);
    Accessory_ApplyAndSaveSlot(playerid, activeSlot, accessoryId, bone);
    ShowNotification(playerid, 1, 6, 0, 0, "Аксессуар надет", "");
    return true;
}

stock Accessory_ShowWearDialog(playerid, accessoryId, invSlot)
{
    g_PendingAccessory[playerid] = accessoryId;
    g_PendingInvSlot[playerid] = invSlot;
    g_WearFromInventory[playerid] = 1;

    new dialogText[256];
    dialogText[0] = EOS;
    strcat(dialogText, "{DD5757}1. {FFFFFF}Отредактировать аксессуар\n");
    strcat(dialogText, "{DD5757}2. {FFFFFF}Изменить часть тела\n");
    strcat(dialogText, "{DD5757}3. {FFFFFF}Продолжить без изменений");

    ShowPlayerDialog(playerid, ACCESSORY_DIALOG_WEAR_CONFIRM, DIALOG_STYLE_LIST, "{DD5757}RAGE RUSSIA {FFFFFF}| Управление аксессуарами", dialogText, "Выбрать", "Закрыть");
}

stock bool:Accessory_UseFromInventory(playerid, invSlot)
{
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return false;
    if(GetItemType(g_PlayerInventory[playerid][invSlot][inv_itemId]) != ITEM_TYPE_ACCESSORY) return false;

    new accessoryId = -1;

    if(g_PlayerInventory[playerid][invSlot][inv_itemPlate][0] != EOS)
    {
        accessoryId = strval(g_PlayerInventory[playerid][invSlot][inv_itemPlate]);
    }

    if(accessoryId < 0 || accessoryId >= sizeof(accessory))
    {
        accessoryId = Accessory_GetAccIdByInvItem(g_PlayerInventory[playerid][invSlot][inv_itemId]);
    }

    if(accessoryId < 0 || accessoryId >= sizeof(accessory))
    {
        accessoryId = g_PlayerInventory[playerid][invSlot][inv_itemCount];
    }

    if(accessoryId < 0 || accessoryId >= sizeof(accessory))
    {
        ShowNotification(playerid, 2, 6, 0, 0, "Ошибка: неизвестный аксессуар", "");
        return false;
    }

    Accessory_ShowWearDialog(playerid, accessoryId, invSlot);
    return true;
}

stock bool:Accessory_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    if(dialogid == ACCESSORY_DIALOG_WEAR_CONFIRM)
    {
        if(!response)
        {
            g_PendingAccessory[playerid] = -1;
            g_PendingInvSlot[playerid] = -1;
            g_WearFromInventory[playerid] = 0;
            ShowPlayerInventory(playerid);
            return true;
        }

        new accessoryId = g_PendingAccessory[playerid];
        new invSlot = g_PendingInvSlot[playerid];

        if(accessoryId < 0 || accessoryId >= sizeof(accessory) || invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS)
        {
            ShowNotification(playerid, 2, 6, 0, 0, "Ошибка: аксессуар не найден", "");
            ShowPlayerInventory(playerid);
            g_PendingAccessory[playerid] = -1;
            g_PendingInvSlot[playerid] = -1;
            g_WearFromInventory[playerid] = 0;
            return true;
        }

        switch(listitem)
        {
            case 0:
            {
                new activeSlot = -1;
                for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
                {
                    if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0)
                    {
                        activeSlot = s;
                        break;
                    }
                }
                if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS)
                {
                    ShowNotification(playerid, 2, 6, 0, 0, "Нет свободного слота для аксессуара", "");
                    ShowPlayerInventory(playerid);
                    g_PendingAccessory[playerid] = -1;
                    g_PendingInvSlot[playerid] = -1;
                    return true;
                }

                new plateStr[12];
                valstr(plateStr, accessoryId);
                Inventory_SetActiveItem(playerid, activeSlot, Accessory_GetInventoryItemId(accessoryId), 1, plateStr);
                Inventory_DeleteSlot(playerid, invSlot);
                Inventory_Save(playerid);
                Accessory_ApplyAndSaveSlot(playerid, activeSlot, accessoryId, accessory[accessoryId][BONE_ACCESSORY]);
                Accessory_StartEditor(playerid, activeSlot);
                g_PendingAccessory[playerid] = -1;
                g_PendingInvSlot[playerid] = -1;
            }
            case 1:
            {
                new boneList[1024];
                boneList[0] = EOS;
                strcat(boneList, "{DD5757}1. {FFFFFF}Спина\n");
                strcat(boneList, "{DD5757}2. {FFFFFF}Голова\n");
                strcat(boneList, "{DD5757}3. {FFFFFF}Левое предплечье\n");
                strcat(boneList, "{DD5757}4. {FFFFFF}Правое предплечье\n");
                strcat(boneList, "{DD5757}5. {FFFFFF}Левая рука\n");
                strcat(boneList, "{DD5757}6. {FFFFFF}Правая рука\n");
                strcat(boneList, "{DD5757}7. {FFFFFF}Левое бедро\n");
                strcat(boneList, "{DD5757}8. {FFFFFF}Правое бедро\n");
                strcat(boneList, "{DD5757}9. {FFFFFF}Левая нога\n");
                strcat(boneList, "{DD5757}10. {FFFFFF}Правая нога\n");
                strcat(boneList, "{DD5757}11. {FFFFFF}Правая голень\n");
                strcat(boneList, "{DD5757}12. {FFFFFF}Левая голень\n");
                strcat(boneList, "{DD5757}13. {FFFFFF}Левое плечо\n");
                strcat(boneList, "{DD5757}14. {FFFFFF}Правое плечо\n");
                strcat(boneList, "{DD5757}15. {FFFFFF}Левая ключица\n");
                strcat(boneList, "{DD5757}16. {FFFFFF}Правая ключица\n");
                strcat(boneList, "{DD5757}17. {FFFFFF}Шея\n");
                strcat(boneList, "{DD5757}18. {FFFFFF}Челюсть");
                SetPVarInt(playerid, "temp_acc_id", accessoryId);
                SetPVarInt(playerid, "temp_inv_slot", invSlot);
                ShowPlayerDialog(playerid, ACCESSORY_DIALOG_BONE_SELECT, DIALOG_STYLE_LIST, "{DD5757}Выберите часть тела для аксессуара", boneList, "Выбрать", "Закрыть");
            }
            case 2:
            {
                Accessory_WearWithBone(playerid, accessoryId, invSlot, accessory[accessoryId][BONE_ACCESSORY]);
                g_PendingAccessory[playerid] = -1;
                g_PendingInvSlot[playerid] = -1;
                g_WearFromInventory[playerid] = 0;
                ShowPlayerInventory(playerid);
            }
        }
        return true;
    }
    if(dialogid == ACCESSORY_DIALOG_BONE_SELECT)
    {
        if(!response)
        {
            Accessory_ShowWearDialog(playerid, GetPVarInt(playerid, "temp_acc_id"), GetPVarInt(playerid, "temp_inv_slot"));
            DeletePVar(playerid, "temp_acc_id");
            DeletePVar(playerid, "temp_inv_slot");
            return true;
        }

        new bone = listitem + 1;
        SetPVarInt(playerid, "temp_bone", bone);

        new editText[192];
        editText[0] = EOS;
        strcat(editText, "{DD5757}1. {FFFFFF}Отредактировать аксессуар\n");
        strcat(editText, "{DD5757}2. {FFFFFF}Продолжить без изменений");

        ShowPlayerDialog(playerid, ACCESSORY_DIALOG_EDITOR_ACTION, DIALOG_STYLE_LIST, "{DD5757}RAGE RUSSIA {FFFFFF}| Управление аксессуарами", editText, "Выбрать", "Назад");
        return true;
    }
    if(dialogid == ACCESSORY_DIALOG_EDITOR_ACTION && GetPVarInt(playerid, "temp_bone") != 0)
    {
        if(!response)
        {
            Accessory_ShowWearDialog(playerid, GetPVarInt(playerid, "temp_acc_id"), GetPVarInt(playerid, "temp_inv_slot"));
            DeletePVar(playerid, "temp_acc_id");
            DeletePVar(playerid, "temp_inv_slot");
            DeletePVar(playerid, "temp_bone");
            return true;
        }

        new accessoryId = GetPVarInt(playerid, "temp_acc_id");
        new invSlot = GetPVarInt(playerid, "temp_inv_slot");
        new bone = GetPVarInt(playerid, "temp_bone");
        DeletePVar(playerid, "temp_acc_id");
        DeletePVar(playerid, "temp_inv_slot");
        DeletePVar(playerid, "temp_bone");

        if(accessoryId < 0 || accessoryId >= sizeof(accessory) || invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) return true;

        new activeSlot = -1;
        for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
        {
            if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 0)
            {
                activeSlot = s;
                break;
            }
        }

        if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS)
        {
            ShowNotification(playerid, 2, 6, 0, 0, "Нет свободного слота для аксессуара", "");
            ShowPlayerInventory(playerid);
            return true;
        }

        new plateStr[12];
        valstr(plateStr, accessoryId);
        Inventory_SetActiveItem(playerid, activeSlot, Accessory_GetInventoryItemId(accessoryId), 1, plateStr);
        Inventory_DeleteSlot(playerid, invSlot);
        Inventory_Save(playerid);
        Accessory_ApplyAndSaveSlot(playerid, activeSlot, accessoryId, bone);

        if(listitem == 0)
        {
            Accessory_StartEditor(playerid, activeSlot);
            SetPVarInt(playerid, "bone", bone);
            SetPlayerAttachedObject(playerid, activeSlot, accessory[accessoryId][ID_ACCESSORY], bone, GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"), GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"));
        }
        else if(listitem == 1)
        {
            ShowNotification(playerid, 1, 6, 0, 0, "Аксессуар надет", "");
            g_WearFromInventory[playerid] = 0;
            ShowPlayerInventory(playerid);
        }
        return true;
    }
    if(dialogid == ACCESSORY_DIALOG_SLOT_SELECT)
    {
        if(!response) return true;
        new idx = 0;
        for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
        {
            if(GetItemType(g_PlayerActiveSlots[playerid][s][inv_itemId]) != ITEM_TYPE_ACCESSORY) continue;
            if(idx == listitem)
            {
                SetPVarInt(playerid, "acc_sel_slot", s);
                ShowPlayerDialog(playerid, ACCESSORY_DIALOG_EDITOR_ACTION, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA{FFFFFF} | Управление аксессуаром", "#\tДействие\n1\tРедактировать\n2\tСнять", "Выбрать", "Закрыть");
                return true;
            }
            idx++;
        }
        return true;
    }
    if(dialogid == ACCESSORY_DIALOG_EDITOR_ACTION && GetPVarInt(playerid, "acc_sel_slot") != -1)
    {
        if(!response) return true;
        new slot = GetPVarInt(playerid, "acc_sel_slot");
        if(slot < 2 || slot >= MAX_ACTIVE_SLOTS) return true;
        if(listitem == 0) Accessory_StartEditor(playerid, slot);
        else if(listitem == 1)
        {
            new freeSlot = Inventory_GetFreeSlot(playerid);
            if(freeSlot == -1) return SendClientMessage(playerid, 0xFF0000FF, "Инвентарь заполнен"), true;
            if(Inventory_MoveFromSlotToInv(playerid, g_PlayerActiveSlots[playerid][slot][inv_itemId], slot, freeSlot)) Inventory_Save(playerid);
        }
        DeletePVar(playerid, "acc_sel_slot");
        return true;
    }
    if(dialogid == ACCESSORY_DIALOG_BUY_CONFIRM)
    {
        if(!response)
        {
            Accessory_OpenMarket(playerid);
            return true;
        }
        new acs = GetPVarInt(playerid, "buy_acs_id");
        if(acs < 0 || acs >= sizeof(accessory))
        {
            ShowNotification(playerid, 2, 6, 0, 0, "Ошибка", "");
            Accessory_OpenMarket(playerid);
            return true;
        }
        new price = accessory[acs][PRICE_ACCESSORY];
        if(Player[playerid][pMoney] < price)
        {
            ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно денег", "");
            Accessory_OpenMarket(playerid);
            return true;
        }
        new itemId = Accessory_GetInventoryItemId(acs);
        if(GetPlayerWeight(playerid) + GetItemWeight(itemId) > GetPlayerMaxWeight(playerid))
        {
            ShowNotification(playerid, 2, 6, 0, 0, "Инвентарь полон", "");
            Accessory_OpenMarket(playerid);
            return true;
        }
        if(!Inventory_AddItem(playerid, itemId, 1))
        {
            ShowNotification(playerid, 2, 6, 0, 0, "Инвентарь полон", "");
            Accessory_OpenMarket(playerid);
            return true;
        }
        Player[playerid][pMoney] -= price;
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, Player[playerid][pMoney]);
        new query[128];
        mysql_format(db_handle, query, sizeof(query), "UPDATE players SET money = %d WHERE id = %d", Player[playerid][pMoney], Player[playerid][pID]);
        mysql_query(db_handle, query);
        Inventory_Save(playerid);
        ShowNotification(playerid, 1, 6, 0, 0, "Аксессуар приобретён", "");
        Accessory_CloseMarket(playerid);
        ShowPlayerInventory(playerid);
        return true;
    }
    return false;
}

stock bool:Accessory_HandleTextDraw(playerid, Text:clickedid)
{
    if(g_AccessoryEditorSlot[playerid] < 2) return false;
    if(clickedid == acss_fix_TD[1]) { Accessory_StopEditor(playerid, false); return true; }
    if(clickedid == acss_fix_TD[2]) { Accessory_StopEditor(playerid, true); return true; }
    if(acss_fix_TD[3] <= clickedid <= acss_fix_TD[9])
    {
        new TD = -1;
        for(new i = 3; i < 10; i++) if(clickedid == acss_fix_TD[i]) { TD = i; break; }
        if(TD == -1) return false;
        new td_use = GetPVarInt(playerid, "acss_TD_use");
        new count_TD = TD - 3;
        TextDrawHideForPlayer(playerid, acss_fix_TD[9 + td_use]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[2 + td_use]);
        TextDrawHideForPlayer(playerid, acss_fix_TD[16 + td_use]);
        TextDrawHideForPlayer(playerid, acss_fix_TD[3 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[10 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[17 + count_TD]);
        SetPVarInt(playerid, "acss_TD_use", count_TD + 1);
        new Float:float_count;
        switch(TD)
        {
            case 3: float_count = GetPVarFloat(playerid, "edit_x");
            case 4: float_count = GetPVarFloat(playerid, "edit_y");
            case 5: float_count = GetPVarFloat(playerid, "edit_z");
            case 6: float_count = GetPVarFloat(playerid, "edit_scale");
            case 7: float_count = GetPVarFloat(playerid, "edit_rX");
            case 8: float_count = GetPVarFloat(playerid, "edit_rY");
            case 9: float_count = GetPVarFloat(playerid, "edit_rZ");
        }
        new acs_coords[18];
        format(acs_coords, sizeof acs_coords, "%.4f", float_count);
        PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
        return true;
    }
    if(clickedid == acss_fix_TD[24] || clickedid == acss_fix_TD[25])
    {
        new delta = (clickedid == acss_fix_TD[24]) ? 1 : -1;
        new td_use = GetPVarInt(playerid, "acss_TD_use");
        new Float:newVal;
        new acs_coords[18];
        switch(td_use)
        {
            case 1:
            {
                newVal = GetPVarFloat(playerid, "edit_x") + (delta * 0.01);
                if(newVal > 0.5 || newVal < -0.5) return true;
                SetPVarFloat(playerid, "edit_x", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", newVal);
            }
            case 2:
            {
                newVal = GetPVarFloat(playerid, "edit_y") + (delta * 0.01);
                if(newVal > 1.0 || newVal < -1.0) return true;
                SetPVarFloat(playerid, "edit_y", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", newVal);
            }
            case 3:
            {
                newVal = GetPVarFloat(playerid, "edit_z") + (delta * 0.01);
                if(newVal > 0.5 || newVal < -0.5) return true;
                SetPVarFloat(playerid, "edit_z", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", newVal);
            }
            case 4:
            {
                newVal = GetPVarFloat(playerid, "edit_scale") + (delta * 0.1);
                if(newVal > 2.0 || newVal < 0.1) return true;
                SetPVarFloat(playerid, "edit_scale", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", newVal);
            }
            case 5:
            {
                newVal = GetPVarFloat(playerid, "edit_rX") + (delta * 5.0);
                if(newVal > 360.0) SetPVarFloat(playerid, "edit_rX", -5.0);
                else if(newVal < -360.0) SetPVarFloat(playerid, "edit_rX", 5.0);
                else SetPVarFloat(playerid, "edit_rX", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", GetPVarFloat(playerid, "edit_rX"));
            }
            case 6:
            {
                newVal = GetPVarFloat(playerid, "edit_rY") + (delta * 5.0);
                if(newVal > 360.0) SetPVarFloat(playerid, "edit_rY", -5.0);
                else if(newVal < -360.0) SetPVarFloat(playerid, "edit_rY", 5.0);
                else SetPVarFloat(playerid, "edit_rY", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", GetPVarFloat(playerid, "edit_rY"));
            }
            case 7:
            {
                newVal = GetPVarFloat(playerid, "edit_rZ") + (delta * 5.0);
                if(newVal > 360.0) SetPVarFloat(playerid, "edit_rZ", -5.0);
                else if(newVal < -360.0) SetPVarFloat(playerid, "edit_rZ", 5.0);
                else SetPVarFloat(playerid, "edit_rZ", newVal);
                format(acs_coords, sizeof acs_coords, "%.4f", GetPVarFloat(playerid, "edit_rZ"));
            }
        }
        PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
        SetPlayerAttachedObject(playerid, g_AccessoryEditorSlot[playerid], accessory[GetPVarInt(playerid, "acs_id")][ID_ACCESSORY], GetPVarInt(playerid, "bone"), GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"), GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"));
        return true;
    }
    return false;
}

static Accessory_OpenMarket(playerid)
{
    if(acs_market_active[playerid]) return;
    acs_market_active[playerid] = true;
    pl_accessory[playerid] = 0;
    pl_id_accessory[playerid] = -1;
    SetPlayerPos(playerid, 2896.610839, 1496.067871, 2499.343750);
    SetPlayerFacingAngle(playerid, 355.015014);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, 2000);
    InterpolateCameraPos(playerid, 2901.951660, 1498.124877, 2499.343750, 2900.450927, 1500.220703, 2499.363750, 2000, CAMERA_MOVE);
    InterpolateCameraLookAt(playerid, 2903.739257, 1499.161499, 2499.343750, 2899.104980, 1503.386230, 2499.562500, 2000, CAMERA_MOVE);
    if(pl_id_accessory[playerid] != -1) DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
    pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[0][ID_ACCESSORY], 2899.104980, 1503.386230, 2499.062500, 0.0, 0.0, 0.0);
    if(!create_player_btn[playerid]) CreatePlTDButtonBR(playerid);
    SetPriceAccesory(playerid, 0);
    SelectTextDraw(playerid, 0xFF5252FF);
    for(new i; i < sizeof(acsmagaz_button_TD); i++) TextDrawShowForPlayer(playerid, acsmagaz_button_TD[i]);
    PlayerTextDrawShow(playerid, acsmagaz_price_PTD[playerid][0]);
    TogglePlayerControllable(playerid, false);
}

static Accessory_MarketNext(playerid)
{
    new acs = pl_accessory[playerid];
    if(acs < sizeof(accessory) - 1)
    {
        if(pl_id_accessory[playerid] != -1) DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs + 1][ID_ACCESSORY], 2899.104980, 1503.386230, 2499.062500, 0.0, 0.0, 0.0);
        pl_accessory[playerid] = acs + 1;
        SetPriceAccesory(playerid, acs + 1);
    }
}

static Accessory_MarketPrev(playerid)
{
    new acs = pl_accessory[playerid];
    if(acs > 0)
    {
        if(pl_id_accessory[playerid] != -1) DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[acs - 1][ID_ACCESSORY], 2899.104980, 1503.386230, 2499.062500, 0.0, 0.0, 0.0);
        pl_accessory[playerid] = acs - 1;
        SetPriceAccesory(playerid, acs - 1);
    }
}

stock bool:Accessory_MarketHandleTextDraw(playerid, Text:clickedid)
{
    if(!acs_market_active[playerid]) return false;
    if(clickedid == acsmagaz_button_TD[0]) { Accessory_MarketPrev(playerid); return true; }
    if(clickedid == acsmagaz_button_TD[1]) { Accessory_MarketNext(playerid); return true; }
    if(clickedid == acsmagaz_button_TD[3]) { Accessory_MarketBuy(playerid); return true; }
    if(clickedid == acsmagaz_button_TD[4]) { Accessory_CloseMarket(playerid); return true; }
    return false;
}

CMD:acs(playerid, params[])
{
    Accessory_OpenMarket(playerid);
    return 1;
}

CMD:myacs(playerid, params[])
{
    new list[1024];
    format(list, sizeof(list), "Слот\tАксессуар\n");
    new count = 0;
    for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
    {
        if(GetItemType(g_PlayerActiveSlots[playerid][s][inv_itemId]) != ITEM_TYPE_ACCESSORY) continue;
        new acs = -1;
        if(g_PlayerActiveSlots[playerid][s][inv_itemPlate][0] != 0) acs = strval(g_PlayerActiveSlots[playerid][s][inv_itemPlate]);
        if(acs < 0 || acs >= sizeof(accessory)) acs = Accessory_GetAccIdByInvItem(g_PlayerActiveSlots[playerid][s][inv_itemId]);
        if(acs < 0 || acs >= sizeof(accessory)) acs = g_PlayerActiveSlots[playerid][s][inv_itemCount];
        if(acs < 0 || acs >= sizeof(accessory)) continue;
        new row[128];
        format(row, sizeof(row), "%d\t%s\n", s-1, accessory[acs][NAME_ACCESSORY]);
        strcat(list, row, sizeof(list));
        count++;
    }
    if(count == 0) return SendClientMessage(playerid, -1, "У вас нет надетых аксессуаров.");
    ShowPlayerDialog(playerid, ACCESSORY_DIALOG_SLOT_SELECT, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA{FFFFFF} | Мои аксессуары", list, "Выбрать", "Закрыть");
    return 1;
}

CMD:accedit(playerid, params[])
{
    new slot;
    if(sscanf(params, "i", slot)) return SendClientMessage(playerid, -1, "Использование: /accedit [слот 1-6]");
    slot += 1;
    if(slot < 2 || slot >= MAX_ACTIVE_SLOTS) return SendClientMessage(playerid, -1, "Неверный слот (1-6)");
    if(GetItemType(g_PlayerActiveSlots[playerid][slot][inv_itemId]) != ITEM_TYPE_ACCESSORY) return SendClientMessage(playerid, -1, "В этом слоте нет аксессуара.");
    Accessory_StartEditor(playerid, slot);
    return 1;
}

stock Accessory_LoadAndApplySlot(playerid, activeSlot, accessoryId)
{
    if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;
    new bone = accessory[accessoryId][BONE_ACCESSORY];
    new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
    new Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:scale = 1.0;
    if(Player[playerid][pID] > 0)
    {
        new q[256];
        mysql_format(db_handle, q, sizeof(q), "SELECT `bone`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`scale` FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1", Player[playerid][pID], activeSlot);
        new Cache:result = mysql_query(db_handle, q);
        if(cache_num_rows() > 0)
        {
            bone = cache_get_field_content_int(0, "bone");
            x = cache_get_field_content_float(0, "x");
            y = cache_get_field_content_float(0, "y");
            z = cache_get_field_content_float(0, "z");
            rx = cache_get_field_content_float(0, "rx");
            ry = cache_get_field_content_float(0, "ry");
            rz = cache_get_field_content_float(0, "rz");
            scale = cache_get_field_content_float(0, "scale");
        }
        cache_delete(result);
    }
    SetPlayerAttachedObject(playerid, activeSlot, accessory[accessoryId][ID_ACCESSORY], bone, x, y, z, rx, ry, rz, scale, scale, scale);
    SetPVarInt(playerid, "acc_id_slot", accessoryId);
    SetPVarInt(playerid, "acc_bone_slot", bone);
    SetPVarFloat(playerid, "acc_x_slot", x);
    SetPVarFloat(playerid, "acc_y_slot", y);
    SetPVarFloat(playerid, "acc_z_slot", z);
    SetPVarFloat(playerid, "acc_rx_slot", rx);
    SetPVarFloat(playerid, "acc_ry_slot", ry);
    SetPVarFloat(playerid, "acc_rz_slot", rz);
    SetPVarFloat(playerid, "acc_scale_slot", scale);
    return 1;
}

stock Accessory_DeleteSlotFromDB(playerid, activeSlot)
{
    if(Player[playerid][pID] <= 0) return 0;
    if(activeSlot < SLOT_ACCESSORY_START || activeSlot > SLOT_ACCESSORY_END) return 0;

    new query[160];
    mysql_format(db_handle, query, sizeof(query), "DELETE FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1", Player[playerid][pID], activeSlot);
    mysql_query(db_handle, query);
    return 1;
}

stock Accessory_SaveAllSlots(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;

    for(new slot = SLOT_ACCESSORY_START; slot <= SLOT_ACCESSORY_END; slot++)
    {
        new accessoryId = Accessory_GetSlotAccessoryId(playerid, slot);

        if(accessoryId < 0 || accessoryId >= sizeof(accessory))
        {
            Accessory_DeleteSlotFromDB(playerid, slot);
            continue;
        }

        new bone = accessory[accessoryId][BONE_ACCESSORY];
        new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
        new Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:scale = 1.0;

        new load_query[192];
        mysql_format(db_handle, load_query, sizeof(load_query), "SELECT `bone`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`scale` FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1", Player[playerid][pID], slot);
        new Cache:result = mysql_query(db_handle, load_query);
        if(cache_num_rows() > 0)
        {
            bone = cache_get_field_content_int(0, "bone");
            x = cache_get_field_content_float(0, "x");
            y = cache_get_field_content_float(0, "y");
            z = cache_get_field_content_float(0, "z");
            rx = cache_get_field_content_float(0, "rx");
            ry = cache_get_field_content_float(0, "ry");
            rz = cache_get_field_content_float(0, "rz");
            scale = cache_get_field_content_float(0, "scale");
        }
        cache_delete(result);

        if(g_AccessoryEditorSlot[playerid] == slot && GetPVarInt(playerid, "acs_id") == accessoryId)
        {
            bone = GetPVarInt(playerid, "bone");
            x = GetPVarFloat(playerid, "edit_x");
            y = GetPVarFloat(playerid, "edit_y");
            z = GetPVarFloat(playerid, "edit_z");
            rx = GetPVarFloat(playerid, "edit_rX");
            ry = GetPVarFloat(playerid, "edit_rY");
            rz = GetPVarFloat(playerid, "edit_rZ");
            scale = GetPVarFloat(playerid, "edit_scale");
        }

        new query[512];
        mysql_format(db_handle, query, sizeof(query), "INSERT INTO `player_accessories` (`account_id`, `active_slot`, `accessory_id`, `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale`) VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f) ON DUPLICATE KEY UPDATE `accessory_id` = VALUES(`accessory_id`), `bone` = VALUES(`bone`), `x` = VALUES(`x`), `y` = VALUES(`y`), `z` = VALUES(`z`), `rx` = VALUES(`rx`), `ry` = VALUES(`ry`), `rz` = VALUES(`rz`), `scale` = VALUES(`scale`)", Player[playerid][pID], slot, accessoryId, bone, x, y, z, rx, ry, rz, scale);
        mysql_query(db_handle, query);
    }
    return 1;
}

stock Accessory_LoadAllFromDB(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;
    new query[256];
    mysql_format(db_handle, query, sizeof(query), "SELECT `active_slot`, `accessory_id`, `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale` FROM `player_accessories` WHERE `account_id` = %d", Player[playerid][pID]);
    mysql_tquery(db_handle, query, "OnAccessoriesLoadedFromDB", "i", playerid);
    return 1;
}

forward OnAccessoriesLoadedFromDB(playerid);
public OnAccessoriesLoadedFromDB(playerid)
{
    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++)
    {
        new activeSlot = cache_get_field_content_int(i, "active_slot");
        new accessoryId = cache_get_field_content_int(i, "accessory_id");
        new bone = cache_get_field_content_int(i, "bone");
        new Float:x = cache_get_field_content_float(i, "x");
        new Float:y = cache_get_field_content_float(i, "y");
        new Float:z = cache_get_field_content_float(i, "z");
        new Float:rx = cache_get_field_content_float(i, "rx");
        new Float:ry = cache_get_field_content_float(i, "ry");
        new Float:rz = cache_get_field_content_float(i, "rz");
        new Float:scale = cache_get_field_content_float(i, "scale");

        if(activeSlot >= SLOT_ACCESSORY_START && activeSlot <= SLOT_ACCESSORY_END && accessoryId >= 0 && accessoryId < sizeof(accessory))
        {
            if(GetItemType(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId]) == ITEM_TYPE_ACCESSORY)
            {
                SetPlayerAttachedObject(playerid, activeSlot, accessory[accessoryId][ID_ACCESSORY], bone, x, y, z, rx, ry, rz, scale, scale, scale);
            }
        }
    }
    return 1;
}

stock Accessory_StartEditor(playerid, activeSlot)
{
    if(activeSlot < 2 || activeSlot >= MAX_ACTIVE_SLOTS) return 0;
    if(GetItemType(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId]) != ITEM_TYPE_ACCESSORY) return 0;
    new acs = -1;
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] != 0) acs = strval(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = Accessory_GetAccIdByInvItem(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount];
    if(acs < 0 || acs >= sizeof(accessory)) return 0;

    new guiItemId = Accessory_GetInventoryItemId(acs);
    new acsPlate[12];
    valstr(acsPlate, acs);
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] != guiItemId || strcmp(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], acsPlate, true) != 0)
    {
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = guiItemId;
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 1;
        g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = ITEM_TYPE_ACCESSORY;
        format(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32, "%s", acsPlate);
        Inventory_Save(playerid);
    }

    new bone = accessory[acs][BONE_ACCESSORY];
    new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
    new Float:rX = 0.0, Float:rY = 0.0, Float:rZ = 0.0, Float:scale = 1.0;
    if(Player[playerid][pID] > 0)
    {
        new q[196];
        mysql_format(db_handle, q, sizeof(q), "SELECT `bone`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`scale` FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1", Player[playerid][pID], activeSlot);
        new Cache:result = mysql_query(db_handle, q);
        if(cache_num_rows())
        {
            bone = cache_get_field_content_int(0, "bone");
            x = cache_get_field_content_float(0, "x");
            y = cache_get_field_content_float(0, "y");
            z = cache_get_field_content_float(0, "z");
            rX = cache_get_field_content_float(0, "rx");
            rY = cache_get_field_content_float(0, "ry");
            rZ = cache_get_field_content_float(0, "rz");
            scale = cache_get_field_content_float(0, "scale");
        }
        cache_delete(result);
    }
    g_AccessoryEditorSlot[playerid] = activeSlot;
    DeletePVar(playerid, "acc_id_slot");
    DeletePVar(playerid, "acc_bone_slot");
    DeletePVar(playerid, "acc_x_slot");
    DeletePVar(playerid, "acc_y_slot");
    DeletePVar(playerid, "acc_z_slot");
    DeletePVar(playerid, "acc_rx_slot");
    DeletePVar(playerid, "acc_ry_slot");
    DeletePVar(playerid, "acc_rz_slot");
    DeletePVar(playerid, "acc_scale_slot");
    SetPVarInt(playerid, "acs_id", acs);
    SetPVarInt(playerid, "bone", bone);
    SetPVarFloat(playerid, "edit_x", x);
    SetPVarFloat(playerid, "edit_y", y);
    SetPVarFloat(playerid, "edit_z", z);
    SetPVarFloat(playerid, "edit_rX", rX);
    SetPVarFloat(playerid, "edit_rY", rY);
    SetPVarFloat(playerid, "edit_rZ", rZ);
    SetPVarFloat(playerid, "edit_scale", scale);
    SetPVarInt(playerid, "acss_TD_use", 1);
    SetPlayerAttachedObject(playerid, activeSlot, accessory[acs][ID_ACCESSORY], bone, x, y, z, rX, rY, rZ, scale, scale, scale);
    SelectTextDraw(playerid, -1);
    for(new i = 0; i < 11; i++) TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[17]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[24]);
    TextDrawShowForPlayer(playerid, acss_fix_TD[25]);
    new acs_coords[18];
    format(acs_coords, sizeof acs_coords, "%.4f", x);
    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW) PlayerTextDrawDestroy(playerid, acss_coords_fix_PTD[playerid][0]);
    acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
    PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
    PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
    PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);
    PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);
    SetCameraBehindPlayer(playerid);
    return 1;
}

stock Accessory_GetLegacyInvItemIdByModel(modelid)
{
    switch(modelid)
    {
        case 676: return 917;
        case 10492: return 939;
        case 677: return 918;
        case 787: return 682;
        case 790: return 685;
        case 2655: return 914;
        case 2656: return 915;
        case 2657: return 916;
        case 4160: return 531;
        case 4161: return 532;
        case 4162: return 533;
        case 4163: return 534;
        case 4165: return 536;
        case 4196: return 490;
        case 4199: return 493;
        case 4200: return 494;
        case 14647: return 944;
        case 4203: return 497;
        case 4204: return 498;
        case 4205: return 499;
        case 4206: return 500;
        case 4207: return 501;
        case 4208: return 502;
        case 7329: return 393;
        case 7330: return 394;
        case 7331: return 395;
        case 7332: return 396;
        case 7333: return 397;
        case 7334: return 398;
        case 7336: return 400;
        case 7337: return 401;
        case 7338: return 402;
        case 7339: return 403;
        case 7341: return 405;
        case 7342: return 406;
        case 7343: return 407;
        case 7344: return 408;
        case 7345: return 409;
        case 7346: return 410;
        case 7347: return 411;
        case 7348: return 412;
        case 7349: return 413;
        case 7350: return 414;
        case 7351: return 415;
        case 7352: return 416;
        case 7353: return 417;
        case 7354: return 418;
        case 7355: return 419;
        case 7356: return 420;
        case 7357: return 421;
        case 7358: return 422;
        case 7359: return 423;
        case 7360: return 424;
        case 7362: return 426;
        case 7364: return 428;
        case 7367: return 431;
        case 7368: return 432;
        case 7369: return 433;
        case 7370: return 434;
        case 7371: return 435;
        case 7372: return 436;
        case 7374: return 438;
        case 7375: return 439;
        case 7376: return 440;
        case 7377: return 441;
        case 7378: return 442;
        case 7379: return 443;
        case 7380: return 444;
        case 7381: return 445;
        case 7382: return 446;
        case 7383: return 447;
        case 7384: return 448;
        case 7385: return 449;
        case 7386: return 450;
        case 7387: return 451;
        case 7390: return 454;
        case 7391: return 455;
        case 7392: return 456;
        case 7393: return 457;
        case 7394: return 458;
        case 7395: return 459;
        case 9824: return 660;
        case 9825: return 661;
        case 9826: return 662;
        case 9827: return 663;
        case 9828: return 664;
        case 11919: return 579;
        case 11922: return 582;
        case 11923: return 583;
        case 11925: return 585;
        case 13801: return 576;
        case 13803: return 578;
        case 13883: return 508;
        case 14574: return 509;
        case 14575: return 511;
        case 14589: return 513;
        case 14591: return 515;
        case 14592: return 516;
        case 14593: return 517;
        case 14596: return 520;
        case 14597: return 521;
        case 14598: return 522;
        case 14603: return 527;
        case 14791: return 949;
        case 14643: return 945;
        case 4702: return 946;
        case 13884: return 510;
        case 5378: return 470;
        case 5384: return 476;
        case 5383: return 475;
        case 5372: return 464;
        case 5374: return 466;
        case 5375: return 467;
        case 15144: return 145;
        case 15145: return 146;
        case 15146: return 147;
        case 15147: return 148;
        case 15148: return 149;
        case 15149: return 150;
        case 15150: return 155;
        case 15151: return 159;
        case 15152: return 151;
        case 15153: return 152;
        case 15154: return 153;
        case 15155: return 154;
        case 15157: return 160;
        case 15158: return 161;
        case 15159: return 158;
        case 15160: return 156;
        case 15161: return 157;
        case 16055: return 709;
        case 18232: return 169;
        case 18233: return 170;
        case 18243: return 180;
        case 18250: return 187;
        case 18263: return 200;
        case 18264: return 201;
        case 18273: return 210;
        case 18279: return 216;
        case 18285: return 220;
        case 18286: return 221;
        case 18346: return 263;
        case 18347: return 264;
        case 18348: return 265;
        case 18369: return 281;
        case 18375: return 287;
        case 18377: return 289;
        case 18378: return 290;
        case 18379: return 291;
        case 18383: return 295;
        case 18384: return 296;
        case 18385: return 297;
        case 18386: return 298;
        case 18389: return 301;
        case 18390: return 302;
        case 18391: return 303;
        case 18392: return 304;
        case 18396: return 308;
        case 18397: return 309;
        case 18399: return 311;
        case 18400: return 312;
        case 18401: return 313;
        case 18402: return 314;
        case 18403: return 315;
        case 18404: return 316;
        case 18409: return 321;
        case 18410: return 322;
        case 18411: return 323;
        case 18412: return 324;
        case 18414: return 326;
        case 18497: return 347;
        case 18498: return 348;
        case 18499: return 349;
        case 18500: return 350;
        case 18501: return 351;
        case 18502: return 352;
        case 18503: return 353;
        case 18504: return 354;
        case 18505: return 355;
        case 18506: return 356;
        case 18507: return 357;
        case 18508: return 358;
        case 18509: return 359;
        case 18510: return 360;
        case 18511: return 361;
        case 18512: return 362;
        case 18513: return 363;
        case 18514: return 364;
        case 18515: return 365;
        case 18516: return 366;
        case 18517: return 367;
        case 18518: return 368;
        case 18519: return 369;
        case 18520: return 370;
        case 18521: return 371;
        case 18522: return 372;
        case 18523: return 373;
        case 18524: return 374;
        case 18525: return 375;
        case 18526: return 376;
        case 18527: return 377;
        case 18528: return 378;
        case 18529: return 379;
        case 18530: return 380;
    }
    

    return 0;
}

stock Accessory_GetInventoryItemId(accessoryId)
{
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;

    new modelid = accessory[accessoryId][ID_ACCESSORY];

    // 1) Full BR accessory id list from acsessory.inc: item_id -> model_id.
    // This is the full id table used by the BR wiki/client.
    for(new i = 0; i < sizeof(InventoryItemss); i++)
    {
        if(InventoryItemss[i][1] == modelid) return InventoryItemss[i][0];
    }

    // 2) Fallback for old/custom object models already present in this mod.
    new legacyItem = Accessory_GetLegacyInvItemIdByModel(modelid);
    if(legacyItem > 0) return legacyItem;

    return INVENTORY_ACCESSORY_ITEM_BASE + accessoryId;
}

stock Accessory_GetAccIdByInvItem(itemId)
{
    // First check BR accessory ids from acsessory.inc: item_id -> object model -> local accessory index.
    // This is the important part for donate/BP/reward: inventory keeps the BR item id,
    // while item_plate keeps the local accessory index for wearing/editing.
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


static Accessory_MarketBuy(playerid)
{
    if(!acs_market_active[playerid]) return;
    new acs = pl_accessory[playerid];
    if(acs < 0 || acs >= sizeof(accessory)) return;
    
    new price = accessory[acs][PRICE_ACCESSORY];
    
    if(Player[playerid][pMoney] < price)
    {
        ShowNotification(playerid, 0, 5, 0, 0, "Недостаточно денег", "");
        return;
    }
    
    new itemId = Accessory_GetInventoryItemId(acs);
    
    if(GetPlayerWeight(playerid) + GetItemWeight(itemId) > GetPlayerMaxWeight(playerid))
    {
        ShowNotification(playerid, 2, 6, 0, 0, "Инвентарь полон", "");
        return;
    }
    
    if(!Inventory_AddAccessoryItem(playerid, acs, itemId))
    {
        ShowNotification(playerid, 2, 6, 0, 0, "Инвентарь полон", "");
        return;
    }
    
    Player[playerid][pMoney] -= price;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, Player[playerid][pMoney]);
    
    new query[128];
    mysql_format(db_handle, query, sizeof(query), "UPDATE players SET money = %d WHERE id = %d", Player[playerid][pMoney], Player[playerid][pID]);
    mysql_query(db_handle, query);
    
    Inventory_Save(playerid);
    ShowNotification(playerid, 1, 6, 0, 0, "Аксессуар приобретён", "");
    Accessory_CloseMarket(playerid);
    ShowPlayerInventory(playerid);
}

static Accessory_CloseMarket(playerid)
{
    if(pl_id_accessory[playerid] != -1)
    {
        DestroyPlayerObject(playerid, pl_id_accessory[playerid]);
        pl_id_accessory[playerid] = -1;
    }
    for(new i; i < sizeof(acsmagaz_button_TD); i++) TextDrawHideForPlayer(playerid, acsmagaz_button_TD[i]);
    PlayerTextDrawHide(playerid, acsmagaz_price_PTD[playerid][0]);
    CancelSelectTextDraw(playerid);
    TogglePlayerControllable(playerid, true);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, 846.602600, 796.555847, 13.400512);
    SetPlayerFacingAngle(playerid, 69.896881);
    SetCameraBehindPlayer(playerid);
    acs_market_active[playerid] = false;
}
