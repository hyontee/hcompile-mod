

```pawn
#if defined _hacker_job_included
	#endinput
#endif
#define _hacker_job_included

// ============================================
//               НАСТРОЙКИ РАБОТЫ
// ============================================

#define HACKER_SKIN        111
#define HACKER_LEVEL_REQ   3      // требуемый уровень для работы

#define DIALOG_HACKER_MENU     6000
#define DIALOG_HACKER_GARAGE   6002

// ID тачек в автопарке хакера
#define CAR_BUS_ID    522   // Бусик
#define CAR_GELIK_ID  2573     // TODO: впиши ID Гелика
#define CAR_M5_ID     466   // M5 / BMW

// Координата NPC хакера
new Float:HackerNpcPos[3] = {2728.90, 2222.90, 18.03};

// Координаты машин в автопарке (впиши свои)
new Float:HackerGaragePos[3][3] =
{
    {0.0, 0.0, 0.0}, // Бусик
    {0.0, 0.0, 0.0}, // Гелик
    {0.0, 0.0, 0.0}  // M5
};

// ============================================
//              ЗАДАНИЯ (МИССИИ)
// ============================================

enum e_HackerMission
{
    E_MISSION_NAME[64],
    Float:E_MISSION_X,
    Float:E_MISSION_Y,
    Float:E_MISSION_Z,
    E_MISSION_REWARD
};

// TODO: подставь реальные координаты для каждого задания
new const HackerMissions[3][e_HackerMission] =
{
    {"Взломать КПП у армии",            0.0, 0.0, 0.0, 15000},
    {"Взломать компьютер босса армии",  0.0, 0.0, 0.0, 25000},
    {"Украсть патроны у армии",         0.0, 0.0, 0.0, 20000}
};

new HackerNpcActor;
new PlayerHackerMission[MAX_PLAYERS] = {-1, ...};   // текущее выбранное задание (-1 = нет)
new HackerMissionCP[MAX_PLAYERS];                   // динамический чекпоинт игрока
new PlayerHackerCooldown[MAX_PLAYERS];              // кулдаун между попытками одного и того же задания

// ============================================
//           СОЗДАНИЕ NPC ПРИ СТАРТЕ
// ============================================

hook OnGameModeInit()
{
    HackerNpcActor = CreateActor(HACKER_SKIN, HackerNpcPos[0], HackerNpcPos[1], HackerNpcPos[2], 0.0);
    ApplyActorAnimation(HackerNpcActor, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);

    print("[Hacker Job] Загружено.");
    return 1;
}

// ============================================
//        ПРОВЕРКА КЛИКА ПО NPC (МЕНЮ РАБОТЫ)
// ============================================

hook OnPlayerClickActor(playerid, actorid)
{
    if (actorid == HackerNpcActor)
    {
        if (GetPlayerLevel(playerid) < HACKER_LEVEL_REQ) // замени на свою функцию получения уровня
        {
            new msg[128];
            format(msg, sizeof(msg), "Вам нужен %d уровень, чтобы устроиться хакером.", HACKER_LEVEL_REQ);
            SendClientMessage(playerid, -1, msg);
            return 1;
        }

        new str[256];
        str = "Задание | Награда\n";
        for (new i = 0; i < 3; i++)
        {
            new line[128];
            format(line, sizeof(line), "%s|%d$\n", HackerMissions[i][E_MISSION_NAME], HackerMissions[i][E_MISSION_REWARD]);
            strcat(str, line);
        }
        strcat(str, "Автопарк хакера|-\n");

        ShowPlayerDialog(playerid, DIALOG_HACKER_MENU, DIALOG_STYLE_TABLIST_HEADERS, "Работа: Хакер", str, "Выбрать", "Закрыть");
    }
    return 1;
}

// ============================================
//              ОБРАБОТКА ДИАЛОГОВ
// ============================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_HACKER_MENU)
    {
        if (!response) return 1;

        if (listitem == 3) // Автопарк
        {
            new str[256];
            str = "Выберите машину|Бусик|Гелик|M5";
            ShowPlayerDialog(playerid, DIALOG_HACKER_GARAGE, DIALOG_STYLE_LIST, "Автопарк хакера", str, "Выбрать", "Закрыть");
            return 1;
        }

        // Выбрано одно из 3 заданий
        new currentTime = gettime();
        if (currentTime - PlayerHackerCooldown[playerid] < 1800) // 30 минут кулдаун
        {
            SendClientMessage(playerid, -1, "Вы недавно выполняли задание. Подождите перед следующим.");
            return 1;
        }

        PlayerHackerMission[playerid] = listitem;

        HackerMissionCP[playerid] = CreateDynamicCP(
            HackerMissions[listitem][E_MISSION_X],
            HackerMissions[listitem][E_MISSION_Y],
            HackerMissions[listitem][E_MISSION_Z],
            2.0, -1, -1, playerid, 50.0
        );

        new msg[160];
        format(msg, sizeof(msg), "Задание принято: %s. Следуйте маркеру на карте.", HackerMissions[listitem][E_MISSION_NAME]);
        SendClientMessage(playerid, -1, msg);
    }

    if (dialogid == DIALOG_HACKER_GARAGE)
    {
        if (!response) return 1;

        new vehicleid, carId, Float:px, Float:py, Float:pz;

        switch (listitem)
        {
            case 0: { carId = CAR_BUS_ID;   px = HackerGaragePos[0][0]; py = HackerGaragePos[0][1]; pz = HackerGaragePos[0][2]; }
            case 1: { carId = CAR_GELIK_ID; px = HackerGaragePos[1][0]; py = HackerGaragePos[1][1]; pz = HackerGaragePos[1][2]; }
            case 2: { carId = CAR_M5_ID;    px = HackerGaragePos[2][0]; py = HackerGaragePos[2][1]; pz = HackerGaragePos[2][2]; }
        }

        if (carId == 0)
        {
            SendClientMessage(playerid, -1, "Эта машина ещё не настроена (нет ID).");
            return 1;
        }

        vehicleid = CreateVehicle(carId, px, py, pz, 0.0, -1, -1, -1);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        SendClientMessage(playerid, -1, "Машина выдана. Хорошей поездки.");
    }
    return 1;
}

// ============================================
//        ЗАВЕРШЕНИЕ ЗАДАНИЯ ПО ЧЕКПОИНТУ
// ============================================

hook OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if (checkpointid == HackerMissionCP[playerid] && PlayerHackerMission[playerid] != -1)
    {
        new mission = PlayerHackerMission[playerid];

        GivePlayerMoney(playerid, HackerMissions[mission][E_MISSION_REWARD]);

        new msg[160];
        format(msg, sizeof(msg), "Задание \"%s\" выполнено! Получено: %d$", HackerMissions[mission][E_MISSION_NAME], HackerMissions[mission][E_MISSION_REWARD]);
        SendClientMessage(playerid, -1, msg);

        DestroyDynamicCP(HackerMissionCP[playerid]);
        PlayerHackerMission[playerid] = -1;
        PlayerHackerCooldown[playerid] = gettime();
    }
    return 1;
}
```

