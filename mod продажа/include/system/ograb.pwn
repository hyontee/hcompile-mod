/*
ЭТОТ СИСТЕМА ОТЛИЧНО ПОДОЙДЁТ ДЛЯ ВАШЕГО ПРОЭКТА!

МОЖНО ОГРАБИТЬ ДОМОВ НО ВЫ САМИ ТАМ НАПИШИТЕ КОРДИНАТЫ ДОМОВ
НАПРИМЕР ДОМОВ РУБЛЕВКА ИЛИ БЕРЕГОВОЙ!

Грабить могут только игроки с 5+ уровнем.
Игроки ниже 5 уровня получат сообщение: "Вы должны иметь минимум 5 уровень, чтобы грабить дома!"
Ограничение 40 минут между кражами осталось.
Можно грабить только возле определённых домов.
Случайная сумма кражи от 500? до 1000?

АВТОР СИСТЕМА @dev_thor
АВТОР СЛИВА: @thorstudio
*/

// Координаты домов (можно добавить больше)
new Float:HousePos[5][3] =
{
    {-1404.881103, 401.265411, 32.589725},
    {-2809.069824, 1013.811584, 10.233240},
    {595.284179, -1201.444580, 41.490131},
    {2523.889160, -199.077728, 2.956801},
    {1837.863281, 1338.241333, 9.797812}
};

// Запоминаем время последнего ограбления игрока
new LastRobberyTime[MAX_PLAYERS];

// Сумма денег, которую получает игрок при ограблении
#define ROBBERY_AMOUNT 5000

// Время ожидания между ограблениями (40 минут = 2400 секунд)
#define ROBBERY_COOLDOWN 2400

// Отмечает ближайший дом на карте
public ShowNearestHouseOnMap(playerid)
{
    new Float:minDist = 99999.0;
    new Float:closestHouse[3];

    // Получаем координаты игрока
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for(new i = 0; i < 5; i++)
    {
        new Float:dist = floatsqroot(
            floatpower(x - HousePos[i][0], 2) +
            floatpower(y - HousePos[i][1], 2) +
            floatpower(z - HousePos[i][2], 2)
        );

        if(dist < minDist)
        {
            minDist = dist;
            closestHouse[0] = HousePos[i][0];
            closestHouse[1] = HousePos[i][1];
            closestHouse[2] = HousePos[i][2];
        }
    }

    if(minDist < 99999.0)
    {
        SetPlayerMapIcon(playerid, 0, closestHouse[0], closestHouse[1], closestHouse[2], 31, 0, MAPICON_GLOBAL);
        SendClientMessage(playerid, -1, "Ближайший дом отмечен на карте!");
    }
    else
    {
        SendClientMessage(playerid, -1, "Дома не найдены!");
    }
}

// Функция ограбления дома
public RobHouse(playerid)
{
    // Проверяем уровень игрока (должен быть 5+)
    if(GetPlayerScore(playerid) < 5)
    {
        SendClientMessage(playerid, -1, "Для ограбления вам нужен уровень 5 или выше!");
        return 1;
    }

    // Проверяем, прошло ли 40 минут после последнего ограбления
    new currentTime = GetTickCount() / 1000;
    if(LastRobberyTime[playerid] > 0 && currentTime - LastRobberyTime[playerid] < ROBBERY_COOLDOWN)
    {
        new timeLeft = ROBBERY_COOLDOWN - (currentTime - LastRobberyTime[playerid]);
        new string[64];
        format(string, sizeof(string), "Вы сможете ограбить дом через %d секунд!", timeLeft);
        SendClientMessage(playerid, -1, string);
        return 1;
    }

    // Ищем ближайший дом
    new Float:minDist = 99999.0;
    new Float:closestHouse[3];

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    for(new i = 0; i < 5; i++)
    {
        new Float:dist = floatsqroot(
            floatpower(x - HousePos[i][0], 2) +
            floatpower(y - HousePos[i][1], 2) +
            floatpower(z - HousePos[i][2], 2)
        );

        if(dist < minDist)
        {
            minDist = dist;
            closestHouse[0] = HousePos[i][0];
            closestHouse[1] = HousePos[i][1];
            closestHouse[2] = HousePos[i][2];
        }
    }

    if(minDist < 5.0) // Игрок должен быть рядом с домом (5 метров)
    {
        LastRobberyTime[playerid] = currentTime; // Запоминаем время ограбления

        // Даем деньги игроку
        GivePlayerMoney(playerid, ROBBERY_AMOUNT);

        // Отправляем сообщение игроку
        new string[64];
        format(string, sizeof(string), "Вы ограбили дом и получили %d$!", ROBBERY_AMOUNT);
        SendClientMessage(playerid, -1, string);
    }
    else
    {
        SendClientMessage(playerid, -1, "Вы слишком далеко от дома, подойдите ближе!");
    }

    return 1;
}

CMD:findhouse(playerid, params[])
{
    ShowNearestHouseOnMap(playerid);
    return 1;
}

CMD:robhouse(playerid, params[])
{
    RobHouse(playerid);
    return 1;
}
