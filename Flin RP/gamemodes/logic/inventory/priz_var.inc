new Prize[MAX_PLAYERS][50][7]; // Отображение призов в /priz;
new PrizeMySQLCheck[MAX_PLAYERS]; // Время использования /priz;
new PrizeIDx[MAX_PLAYERS]; // ID приза;

enum
{
    TYPE_NEW_PRIZE_EXP = 1,
    TYPE_NEW_PRIZE_MONEY,
    TYPE_NEW_PRIZE_U_MONEY,
    TYPE_NEW_PRIZE_DONATE,
    TYPE_NEW_PRIZE_U_DONATE,
    TYPE_NEW_PRIZE_INVENTORY,
    TYPE_NEW_PRIZE_ACCESSORIES,
    TYPE_NEW_PRIZE_SKIN,
    TYPE_NEW_PRIZE_U_SKIN,
    TYPE_NEW_PRIZE_VEHICLE,
    TYPE_NEW_PRIZE_U_VEHICLE,
    TYPE_NEW_PRIZE_VIP
}

new TypePrizeName[13][64] = {"Нет", "Очки опыта", "Деньги", "Уникальное количество денег", ""NAME_DONATE"", "Уникальное количество "NAME_DONATE"", "Предмет инвентаря", "Уникальный аксессуар", "Скин", "Уникальный скин", "Транспортное средство", "Уникальное транспортное средство", "VIP"};

new TypeVIPName[3][12] = {"Bronze", "Silver", "Gold"};