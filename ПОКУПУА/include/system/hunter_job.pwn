
#if defined _KIRILL_HUNTER_JOB_INCLUDED
    #endinput
#endif
#define _KIRILL_HUNTER_JOB_INCLUDED

#define HUNTER_DIALOG_MAIN      (23100)
#define HUNTER_DIALOG_STATS     (23101)
#define HUNTER_DIALOG_TARIFFS   (23102)
#define HUNTER_DIALOG_BAITS     (23103)
#define HUNTER_DIALOG_PRICES    (23104)
#define HUNTER_DIALOG_TROPHIES  (23105)
#define HUNTER_NOTIFY_ACTION    (23190)
#define HUNTER_SKIN_ID          (58)
#define HUNTER_MIN_LEVEL        (4)
#define HUNTER_ANIMAL_COUNT     (10)
#define HUNTER_WEAPON_ID        (30)
#define HUNTER_WEAPON_AMMO      (250)
#define HUNTER_MAP_ICON_SLOT    (30)
#define HUNTER_MAP_ICON_SLOT2   (31)
#define HUNTER_MAP_ICON_TYPE    (52)
#define HUNTER_MAP_ICON_TYPE2   (41)
#define HUNTER_MAP_ICON_COLOR   (0xFF0000FF)
#define HUNTER_MAP_ICON_STYLE   (MAPICON_GLOBAL_CHECKPOINT)
#define HUNTER_MARKER_REFRESH_MS (3000)
#define HUNTER_ZONE_RADIUS      (45.0)

new HunterActor;
new HunterNpcArea;
new HunterAnimalArea[HUNTER_ANIMAL_COUNT];
new HunterAnimalObject[MAX_PLAYERS][HUNTER_ANIMAL_COUNT];
new HunterJobTimer[MAX_PLAYERS];
new HunterMarkerTimer[MAX_PLAYERS];
new HunterTargetZone[MAX_PLAYERS] = {-1, ...};
new HunterAnimalMapIcon[HUNTER_ANIMAL_COUNT];
new bool:HunterJobActive[MAX_PLAYERS];
new bool:HunterAnimalTaken[MAX_PLAYERS][HUNTER_ANIMAL_COUNT];
new HunterDuckKills[MAX_PLAYERS];
new HunterHareKills[MAX_PLAYERS];
new HunterDeerKills[MAX_PLAYERS];
new HunterBearKills[MAX_PLAYERS];
new HunterBaitDuck[MAX_PLAYERS];
new HunterBaitHare[MAX_PLAYERS];
new HunterBaitDeer[MAX_PLAYERS];
new HunterBaitBear[MAX_PLAYERS];
new bool:HunterWeaponIssued[MAX_PLAYERS];
new HunterCurrentTarget[MAX_PLAYERS];

new const Float:HunterAnimalPos[HUNTER_ANIMAL_COUNT][3] =
{
    {1972.4775, 643.6232, 21.6862},
    {1960.2148, 651.9075, 21.3000},
    {1984.9835, 634.8228, 21.9000},
    {1951.7683, 632.4461, 20.8000},
    {1995.3401, 657.1164, 22.1000},
    {1978.9052, 666.4923, 22.0000},
    {1944.6135, 659.7027, 20.5000},
    {2006.8470, 641.0158, 22.5000},
    {1968.3171, 620.8246, 20.9000},
    {1988.6542, 617.3339, 21.5000}
};

new const HunterAnimalModel[HUNTER_ANIMAL_COUNT] =
{
    19315, 19315, 19315, 19315, 19315, 19315, 19315, 19315, 19315, 19315
};

new const Float:HunterAnimalRotZ[HUNTER_ANIMAL_COUNT] =
{
    100.0, 100.0, 200.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0, 100.0
};

stock Hunter_ClearMarker(playerid)
{
    if(HunterMarkerTimer[playerid] != 0)
    {
        KillTimer(HunterMarkerTimer[playerid]);
        HunterMarkerTimer[playerid] = 0;
    }

    DisablePlayerCheckpoint(playerid);
    DisablePlayerRaceCheckpoint(playerid);
    RemovePlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT);
    RemovePlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT2);

    if(HunterTargetZone[playerid] != -1)
    {
        GangZoneHideForPlayer(playerid, HunterTargetZone[playerid]);
        GangZoneDestroy(HunterTargetZone[playerid]);
        HunterTargetZone[playerid] = -1;
    }

    SetPlayerGPSPoint(playerid, 0.0, 0.0, 0.0, 0x00000000);
    SendDestroyWayPoint(playerid, 1);
    HideGPS(playerid);
    return 1;
}

stock Hunter_ShowTargetZone(playerid, target)
{
    if(HunterTargetZone[playerid] != -1)
    {
        GangZoneHideForPlayer(playerid, HunterTargetZone[playerid]);
        GangZoneDestroy(HunterTargetZone[playerid]);
        HunterTargetZone[playerid] = -1;
    }

    new Float:x = HunterAnimalPos[target][0];
    new Float:y = HunterAnimalPos[target][1];

    HunterTargetZone[playerid] = GangZoneCreate(x - HUNTER_ZONE_RADIUS, y - HUNTER_ZONE_RADIUS, x + HUNTER_ZONE_RADIUS, y + HUNTER_ZONE_RADIUS);
    GangZoneShowForPlayer(playerid, HunterTargetZone[playerid], 0xFF000066);
    return 1;
}

stock Hunter_ApplyTargetMarker(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!HunterJobActive[playerid] || !HunterWeaponIssued[playerid]) return 0;
    if(HunterCurrentTarget[playerid] < 0 || HunterCurrentTarget[playerid] >= HUNTER_ANIMAL_COUNT) return 0;

    new target = HunterCurrentTarget[playerid];
    new Float:x = HunterAnimalPos[target][0];
    new Float:y = HunterAnimalPos[target][1];
    new Float:z = HunterAnimalPos[target][2];

    SetPlayerCheckpoint(playerid, x, y, z, 5.0);
    SetPlayerRaceCheckpoint(playerid, 1, x, y, z, x, y, z, 5.0);

    RemovePlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT);
    RemovePlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT2);
    SetPlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT, x, y, z, HUNTER_MAP_ICON_TYPE, HUNTER_MAP_ICON_COLOR, HUNTER_MAP_ICON_STYLE);
    SetPlayerMapIcon(playerid, HUNTER_MAP_ICON_SLOT2, x, y, z, HUNTER_MAP_ICON_TYPE2, HUNTER_MAP_ICON_COLOR, MAPICON_GLOBAL);

    SetPlayerGPSPoint(playerid, x, y, z, 0xFF5252FF);
    SendCreateWayPoint(playerid, 1, x, y, z, 85, 1, 30000.0, 0);
    ShowGPS(playerid);
    Hunter_ShowTargetZone(playerid, target);
    return 1;
}

forward Hunter_RefreshMarker(playerid);
public Hunter_RefreshMarker(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!HunterJobActive[playerid] || !HunterWeaponIssued[playerid] || HunterCurrentTarget[playerid] == -1)
    {
        Hunter_ClearMarker(playerid);
        return 0;
    }

    Hunter_ApplyTargetMarker(playerid);
    return 1;
}

stock Hunter_RemoveAnimalObject(playerid, animalid)
{
    if(animalid < 0 || animalid >= HUNTER_ANIMAL_COUNT) return 0;

    if(HunterAnimalObject[playerid][animalid] != INVALID_STREAMER_ID)
    {
        if(IsValidDynamicObject(HunterAnimalObject[playerid][animalid]))
            DestroyDynamicObject(HunterAnimalObject[playerid][animalid]);

        HunterAnimalObject[playerid][animalid] = INVALID_STREAMER_ID;
    }
    return 1;
}

stock Hunter_DestroyPlayerAnimals(playerid)
{
    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
        Hunter_RemoveAnimalObject(playerid, i);

    return 1;
}

stock Hunter_CreateAnimalObject(playerid, animalid)
{
    if(animalid < 0 || animalid >= HUNTER_ANIMAL_COUNT) return 0;
    if(HunterAnimalTaken[playerid][animalid]) return 0;

    Hunter_RemoveAnimalObject(playerid, animalid);

    HunterAnimalObject[playerid][animalid] = CreateDynamicObject(
        HunterAnimalModel[animalid],
        HunterAnimalPos[animalid][0],
        HunterAnimalPos[animalid][1],
        HunterAnimalPos[animalid][2] + 0.70,
        0.0,
        0.0,
        HunterAnimalRotZ[animalid],
        -1,
        -1,
        playerid,
        350.0,
        350.0
    );
    return 1;
}

stock Hunter_SpawnPlayerAnimals(playerid)
{
    Hunter_DestroyPlayerAnimals(playerid);

    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        if(!HunterAnimalTaken[playerid][i])
            Hunter_CreateAnimalObject(playerid, i);
    }
    return 1;
}

stock Hunter_GetAnimalByObject(playerid, STREAMER_TAG_OBJECT:objectid)
{
    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        if(HunterAnimalObject[playerid][i] == _:objectid)
            return i;
    }
    return -1;
}

stock Hunter_ResetAnimals(playerid)
{
    Hunter_DestroyPlayerAnimals(playerid);
    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++) HunterAnimalTaken[playerid][i] = false;
    HunterCurrentTarget[playerid] = -1;
    Hunter_ClearMarker(playerid);
    return 1;
}

stock Hunter_GetAnimalName(animalid, name[], size = sizeof(name))
{
    switch(animalid)
    {
        case 0, 1: format(name, size, "медведь");
        case 2, 3, 4: format(name, size, "утка");
        case 5, 6, 7: format(name, size, "заяц");
        case 8, 9: format(name, size, "олень");
        default: format(name, size, "животное");
    }
    return 1;
}

stock Hunter_FindNextAnimal(playerid)
{
    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        if(!HunterAnimalTaken[playerid][i]) return i;
    }
    return -1;
}

stock Hunter_MarkNextAnimal(playerid)
{
    new target = Hunter_FindNextAnimal(playerid);
    if(target == -1)
    {
        HunterCurrentTarget[playerid] = -1;
        Hunter_ClearMarker(playerid);
        SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Все животные в текущей охоте уже отмечены/убиты. Можете завершить работу через {FFFF00}/exito{FFFFFF}.");
        return 1;
    }

    Hunter_ClearMarker(playerid);
    HunterCurrentTarget[playerid] = target;
    Hunter_ApplyTargetMarker(playerid);
    HunterMarkerTimer[playerid] = SetTimerEx("Hunter_RefreshMarker", HUNTER_MARKER_REFRESH_MS, true, "i", playerid);

    new animal_name[24], msg[144];
    Hunter_GetAnimalName(target, animal_name, sizeof(animal_name));
    format(msg, sizeof(msg), "{FFFF00}| {FFFFFF}На карте отмечена зона охоты. Цель: {FFFF00}%s{FFFFFF}. Двигайтесь к красной метке.", animal_name);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    return 1;
}

stock Hunter_GiveWeaponAndMark(playerid)
{
    if(!HunterJobActive[playerid])
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала купите тариф охоты у Николыча.");

    GivePlayerWeapon(playerid, HUNTER_WEAPON_ID, HUNTER_WEAPON_AMMO);
    SetPlayerArmedWeapon(playerid, HUNTER_WEAPON_ID);
    HunterWeaponIssued[playerid] = true;
    Hunter_SpawnPlayerAnimals(playerid);

    SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Николыч выдал вам {FFFF00}АК-47{FFFFFF}. Животные разбросаны по разным точкам охоты. Езжайте к метке и стреляйте по цели.");
    Hunter_MarkNextAnimal(playerid);
    return 1;
}

stock Hunter_GetTotalKills(playerid)
{
    return HunterDuckKills[playerid] + HunterHareKills[playerid] + HunterDeerKills[playerid] + HunterBearKills[playerid];
}

stock Hunter_GetSkill(playerid)
{
    new total = Hunter_GetTotalKills(playerid);
    if(total >= 100) return 5;
    if(total >= 50) return 4;
    if(total >= 25) return 3;
    if(total >= 10) return 2;
    return 1;
}

stock Hunter_ShowNotify(playerid, subid, text[])
{
    ShowNotificationKirill(playerid, 5, 5, HUNTER_NOTIFY_ACTION, subid, text, "E");
    return 1;
}

stock Hunter_ShowMainMenu(playerid)
{
    new text[1200];
    format(text, sizeof(text),
        "{FF4500}#1 {FFFFFF}Посмотреть статистику охотника {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#2 {FFFFFF}Посмотреть доступные тарифы охоты {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#3 {FFFFFF}Посмотреть трофеи охотника {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#4 {FFFFFF}Приобрести приманки для животных {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#5 {FFFFFF}Продать полученную добычу {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#6 {FFFFFF}Посмотреть стоимость животных {7D7D7D}нажмите чтобы посмотреть\n\
{FF4500}#7 {FFFFFF}Получить АК-47 и метку на животных {7D7D7D}работает после покупки тарифа"
    );
    ShowPlayerDialog(playerid, HUNTER_DIALOG_MAIN, DIALOG_STYLE_LIST, "{FF0000}BLACK RUSSIA | {FFFFFF}Охотник", text, "Выбрать", "Закрыть");
    return 1;
}

stock ShowWorkOxotnik(playerid)
{
    return Hunter_ShowMainMenu(playerid);
}

stock Hunter_ShowStats(playerid)
{
    new text[512];
    format(text, sizeof(text),
        "{FFFFFF}Количество убитых уток: {FFFF00}%d\n\
{FFFFFF}Количество убитых зайцев: {FFFF00}%d\n\
{FFFFFF}Количество убитых оленей: {FFFF00}%d\n\
{FFFFFF}Количество убитых медведей: {FFFF00}%d\n\
{FFFFFF}Общее количество убитых животных: {FFFF00}%d\n\
{FFFFFF}Ваш скилл охотника: {FFFF00}%d",
        HunterDuckKills[playerid], HunterHareKills[playerid], HunterDeerKills[playerid], HunterBearKills[playerid], Hunter_GetTotalKills(playerid), Hunter_GetSkill(playerid)
    );
    ShowPlayerDialog(playerid, HUNTER_DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{FF0000}BLACK RUSSIA | {FFFFFF}Статистика охотника", text, "Назад", "Закрыть");
    return 1;
}

stock Hunter_ShowTariffs(playerid)
{
    ShowPlayerDialog(playerid, HUNTER_DIALOG_TARIFFS, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF0000}BLACK RUSSIA | {FFFFFF}Тарифы охоты",
        "#\tТариф\tЦена\tОписание\n\
{FF0000}#1\t{FFFFFF}Начинающий охотник, 15 минут\t3000\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#2\t{FFFFFF}Бывалый охотник, 25 минут\t6000\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#3\t{FFFFFF}Неутомимый охотник, 45 минут\t8000\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#4\t{FFFFFF}Заядлый охотник, 60 минут\t10000\t{7D7D7D}нажмите чтобы приобрести",
        "Выбрать", "Назад");
    return 1;
}

stock Hunter_ShowBaits(playerid)
{
    ShowPlayerDialog(playerid, HUNTER_DIALOG_BAITS, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF0000}BLACK RUSSIA | {FFFFFF}Приманки",
        "#\tПриманка\tЦена\tОписание\n\
{FF0000}#1\t{FFFFFF}Приманка для уток\t1000\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#2\t{FFFFFF}Приманка для зайцев\t1000\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#3\t{FFFFFF}Приманка для оленя\t1500\t{7D7D7D}нажмите чтобы приобрести\n\
{FF0000}#4\t{FFFFFF}Приманка для медведя\t1500\t{7D7D7D}нажмите чтобы приобрести",
        "Выбрать", "Назад");
    return 1;
}

stock Hunter_ShowPrices(playerid)
{
    ShowPlayerDialog(playerid, HUNTER_DIALOG_PRICES, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF0000}BLACK RUSSIA | {FFFFFF}Стоимость добычи",
        "Животное\tНаграда\n\
{FFFFFF}Утка\t{FFFF00}250 рублей\n\
{FFFFFF}Заяц\t{FFFF00}250 рублей\n\
{FFFFFF}Олень\t{FFFF00}250 рублей\n\
{FFFFFF}Медведь\t{FFFF00}250 рублей",
        "Назад", "Закрыть");
    return 1;
}

stock Hunter_ShowTrophies(playerid)
{
    new text[384];
    format(text, sizeof(text),
        "{FFFFFF}Утки: {FFFF00}%d\n{FFFFFF}Зайцы: {FFFF00}%d\n{FFFFFF}Олени: {FFFF00}%d\n{FFFFFF}Медведи: {FFFF00}%d\n\n{AFAFAF}Трофеи засчитываются во время активной охоты.",
        HunterDuckKills[playerid], HunterHareKills[playerid], HunterDeerKills[playerid], HunterBearKills[playerid]
    );
    ShowPlayerDialog(playerid, HUNTER_DIALOG_TROPHIES, DIALOG_STYLE_MSGBOX, "{FF0000}BLACK RUSSIA | {FFFFFF}Трофеи", text, "Назад", "Закрыть");
    return 1;
}

stock Hunter_StartJob(playerid, minutes, price, jobname[])
{
    if(GetPlayerLevel(playerid) < HUNTER_MIN_LEVEL)
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Работа охотника доступна с 4 уровня.");

    if(HunterJobActive[playerid])
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Вы уже работаете охотником. Для выхода используйте {FFFF00}/exito{FFFFFF}.");

    if(GetPlayerMoneyEx(playerid) < price)
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Недостаточно денег для покупки тарифа охоты.");

    GivePlayerMoneyEx(playerid, -price, "Охота: покупка тарифа", true, true);
    HunterJobActive[playerid] = true;
    HunterWeaponIssued[playerid] = false;
    Hunter_ResetAnimals(playerid);

    if(HunterJobTimer[playerid] != 0) KillTimer(HunterJobTimer[playerid]);
    HunterJobTimer[playerid] = SetTimerEx("Hunter_EndPlayerJob", minutes * 60 * 1000, false, "i", playerid);

    SetPlayerSkin(playerid, HUNTER_SKIN_ID);
    SetPlayerVirtualWorld(playerid, 1);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, 1985.5837, 459.4796, 13.3068);
    SetCameraBehindPlayer(playerid);

    new msg[144];
    format(msg, sizeof(msg), "{FFFF00}| {FFFFFF}Вы устроились охотником: {FFFF00}%s{FFFFFF}. Ищите животных. Для выхода используйте {FFFF00}/exito", jobname);
    SendClientMessage(playerid, COLOR_WHITE, msg);
    Hunter_GiveWeaponAndMark(playerid);
    return 1;
}

stock Hunter_StopJob(playerid, bool:byTimer)
{
    if(HunterJobTimer[playerid] != 0)
    {
        KillTimer(HunterJobTimer[playerid]);
        HunterJobTimer[playerid] = 0;
    }

    HunterJobActive[playerid] = false;
    HunterWeaponIssued[playerid] = false;
    Hunter_ResetAnimals(playerid);

    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerSkinInit(playerid);
    SetPlayerPos(playerid, 1985.5837, 459.4796, 13.3068);
    SetCameraBehindPlayer(playerid);

    Hunter_SpawnPlayerAnimals(playerid);

    if(byTimer) SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Время охоты закончилось. Вы покинули зону охоты.");
    else SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы успешно покинули зону охоты!");
    return 1;
}

forward Hunter_EndPlayerJob(playerid);
public Hunter_EndPlayerJob(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    HunterJobTimer[playerid] = 0;
    if(HunterJobActive[playerid]) Hunter_StopJob(playerid, true);
    return 1;
}

stock Hunter_BuyBait(playerid, baitid, price)
{
    if(GetPlayerMoneyEx(playerid) < price) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Недостаточно денег для покупки приманки.");
    GivePlayerMoneyEx(playerid, -price, "Охота: покупка приманки", true, true);

    switch(baitid)
    {
        case 0: HunterBaitDuck[playerid]++;
        case 1: HunterBaitHare[playerid]++;
        case 2: HunterBaitDeer[playerid]++;
        case 3: HunterBaitBear[playerid]++;
    }
    SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы приобрели приманку.");
    return 1;
}

stock Hunter_TakeAnimal(playerid, animalid)
{
    if(animalid < 0 || animalid >= HUNTER_ANIMAL_COUNT) return 0;

    if(!HunterJobActive[playerid])
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала начните работу охотника у Николыча.");

    if(HunterAnimalTaken[playerid][animalid])
        return SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы уже подобрали данное животное.");

    if(!HunterWeaponIssued[playerid])
        return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала получите АК-47 у Николыча или введите /huntgun.");

    HunterAnimalTaken[playerid][animalid] = true;
    Hunter_RemoveAnimalObject(playerid, animalid);

    switch(animalid)
    {
        case 0, 1: HunterBearKills[playerid]++;
        case 2, 3, 4: HunterDuckKills[playerid]++;
        case 5, 6, 7: HunterHareKills[playerid]++;
        case 8, 9: HunterDeerKills[playerid]++;
    }

    GivePlayerMoneyEx(playerid, 250, "Охота: добыча", true, true);
    SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Животное убито. Награда: {FFFF00}250 рублей{FFFFFF}. Отправляйтесь на поиски следующей цели.");
    Hunter_MarkNextAnimal(playerid);
    return 1;
}

stock ShowWorkBear(playerid)   { return Hunter_TakeAnimal(playerid, 0); }
stock ShowWorkBearr(playerid)  { return Hunter_TakeAnimal(playerid, 1); }
stock ShowWorkDuck(playerid)   { return Hunter_TakeAnimal(playerid, 2); }
stock ShowWorkDuckk(playerid)  { return Hunter_TakeAnimal(playerid, 3); }
stock ShowWorkDuckkk(playerid) { return Hunter_TakeAnimal(playerid, 4); }
stock ShowWorkHare(playerid)   { return Hunter_TakeAnimal(playerid, 5); }
stock ShowWorkHaree(playerid)  { return Hunter_TakeAnimal(playerid, 6); }
stock ShowWorkHareee(playerid) { return Hunter_TakeAnimal(playerid, 7); }
stock ShowWorkDeer(playerid)   { return Hunter_TakeAnimal(playerid, 8); }
stock ShowWorkDeerr(playerid)  { return Hunter_TakeAnimal(playerid, 9); }

stock Hunter_OnNotificationClick(playerid, id, sub_id)
{
    if(id != HUNTER_NOTIFY_ACTION) return 0;

    switch(sub_id)
    {
        case 0: return ShowWorkOxotnik(playerid);
        case 1: return ShowWorkBear(playerid);
        case 2: return ShowWorkBearr(playerid);
        case 3: return ShowWorkDuck(playerid);
        case 4: return ShowWorkDuckk(playerid);
        case 5: return ShowWorkDuckkk(playerid);
        case 6: return ShowWorkHare(playerid);
        case 7: return ShowWorkHaree(playerid);
        case 8: return ShowWorkHareee(playerid);
        case 9: return ShowWorkDeer(playerid);
        case 10: return ShowWorkDeerr(playerid);
    }
    return 1;
}

stock Hunter_InitWorld()
{
    HunterActor = CreateActor(HUNTER_SKIN_ID, 1985.5837, 459.4796, 13.3068, 180.0);
    CreateDynamic3DTextLabel("{FFFF00}Николыч - Охотник\n{FFFFFF}подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 1985.5837, 459.4796, 13.3068, 8.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    HunterNpcArea = CreateDynamicSphere(1985.5837, 459.4796, 13.3068, 1.2, 0, 0, -1);


    HunterAnimalArea[0] = CreateDynamicSphere(1972.4775, 643.6232, 21.6862, 1.4, -1, -1, -1);
    HunterAnimalArea[1] = CreateDynamicSphere(1960.2148, 651.9075, 21.3000, 1.4, -1, -1, -1);
    HunterAnimalArea[2] = CreateDynamicSphere(1984.9835, 634.8228, 21.9000, 1.4, -1, -1, -1);
    HunterAnimalArea[3] = CreateDynamicSphere(1951.7683, 632.4461, 20.8000, 1.4, -1, -1, -1);
    HunterAnimalArea[4] = CreateDynamicSphere(1995.3401, 657.1164, 22.1000, 1.4, -1, -1, -1);
    HunterAnimalArea[5] = CreateDynamicSphere(1978.9052, 666.4923, 22.0000, 1.4, -1, -1, -1);
    HunterAnimalArea[6] = CreateDynamicSphere(1944.6135, 659.7027, 20.5000, 1.4, -1, -1, -1);
    HunterAnimalArea[7] = CreateDynamicSphere(2006.8470, 641.0158, 22.5000, 1.4, -1, -1, -1);
    HunterAnimalArea[8] = CreateDynamicSphere(1968.3171, 620.8246, 20.9000, 1.4, -1, -1, -1);
    HunterAnimalArea[9] = CreateDynamicSphere(1988.6542, 617.3339, 21.5000, 1.4, -1, -1, -1);

    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        new animal_name[24], label_text[96];
        Hunter_GetAnimalName(i, animal_name, sizeof(animal_name));
        format(label_text, sizeof(label_text), "{FFFF00}%s\n{FFFFFF}Животное охоты", animal_name);
        CreateDynamic3DTextLabel(label_text, 0xFFFFFFFF, HunterAnimalPos[i][0], HunterAnimalPos[i][1], HunterAnimalPos[i][2] + 1.70, 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, -1);
    }

    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        HunterAnimalMapIcon[i] = CreateDynamicMapIcon(
            HunterAnimalPos[i][0],
            HunterAnimalPos[i][1],
            HunterAnimalPos[i][2],
            HUNTER_MAP_ICON_TYPE,
            HUNTER_MAP_ICON_COLOR,
            -1,
            -1,
            -1,
            6000.0,
            MAPICON_GLOBAL_CHECKPOINT
        );
    }
    return 1;
}

public OnGameModeInit()
{
    Hunter_InitWorld();

    #if defined Hunter_OnGameModeInit
        return Hunter_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Hunter_OnGameModeInit
#if defined Hunter_OnGameModeInit
    forward Hunter_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == HunterNpcArea)
    {
        if(GetPlayerLevel(playerid) < HUNTER_MIN_LEVEL)
        {
            SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Работа охотника доступна с 4 уровня.");
            return 1;
        }
        Hunter_ShowNotify(playerid, 0, "Взаимодействие");
        SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Нажмите кнопку взаимодействия или используйте {FFFF00}/hunt{FFFFFF}.");
        return 1;
    }

    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        if(areaid == HunterAnimalArea[i])
        {
            if(!HunterJobActive[playerid])
            {
                SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала начните работу охотника у Николыча.");
                return 1;
            }
            if(HunterAnimalTaken[playerid][i])
            {
                SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы уже подобрали данное животное.");
                return 1;
            }
            if(!HunterWeaponIssued[playerid])
            {
                SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала получите АК-47 у Николыча или используйте /huntgun.");
                return 1;
            }
            SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы нашли животное. Застрелите его из АК-47, чтобы получить добычу.");
            return 1;
        }
    }

    #if defined Hunter_OnPlayerEnterDynamicArea
        return Hunter_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea Hunter_OnPlayerEnterDynamicArea
#if defined Hunter_OnPlayerEnterDynamicArea
    forward Hunter_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnPlayerShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z)
{
    #pragma unused x
    #pragma unused y
    #pragma unused z

    new animalid = Hunter_GetAnimalByObject(playerid, objectid);
    if(animalid != -1)
    {
        if(!HunterJobActive[playerid])
            return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала начните работу охотника у Николыча.");

        if(!HunterWeaponIssued[playerid] || weaponid != HUNTER_WEAPON_ID)
            return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Животное можно убить только из выданного АК-47.");

        return Hunter_TakeAnimal(playerid, animalid);
    }

    #if defined Hunter_OnPlayerShootDynamicObject
        return Hunter_OnPlayerShootDynamicObject(playerid, weaponid, objectid, x, y, z);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerShootDynamicObject
    #undef OnPlayerShootDynamicObject
#else
    #define _ALS_OnPlayerShootDynamicObject
#endif
#define OnPlayerShootDynamicObject Hunter_OnPlayerShootDynamicObject
#if defined Hunter_OnPlayerShootDynamicObject
    forward Hunter_OnPlayerShootDynamicObject(playerid, weaponid, STREAMER_TAG_OBJECT:objectid, Float:x, Float:y, Float:z);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    if(dialogid == HUNTER_DIALOG_MAIN)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: Hunter_ShowStats(playerid);
            case 1: Hunter_ShowTariffs(playerid);
            case 2: Hunter_ShowTrophies(playerid);
            case 3: Hunter_ShowBaits(playerid);
            case 4: SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}У вас нет с собой ни туши, ни шкуры какого-либо животного.");
            case 5: Hunter_ShowPrices(playerid);
            case 6: Hunter_GiveWeaponAndMark(playerid);
        }
        return 1;
    }
    if(dialogid == HUNTER_DIALOG_STATS || dialogid == HUNTER_DIALOG_TROPHIES || dialogid == HUNTER_DIALOG_PRICES)
    {
        if(response) Hunter_ShowMainMenu(playerid);
        return 1;
    }
    if(dialogid == HUNTER_DIALOG_TARIFFS)
    {
        if(!response) return Hunter_ShowMainMenu(playerid);
        switch(listitem)
        {
            case 0: Hunter_StartJob(playerid, 15, 3000, "Начинающий охотник");
            case 1: Hunter_StartJob(playerid, 25, 6000, "Бывалый охотник");
            case 2: Hunter_StartJob(playerid, 45, 8000, "Неутомимый охотник");
            case 3: Hunter_StartJob(playerid, 60, 10000, "Заядлый охотник");
        }
        return 1;
    }
    if(dialogid == HUNTER_DIALOG_BAITS)
    {
        if(!response) return Hunter_ShowMainMenu(playerid);
        switch(listitem)
        {
            case 0: Hunter_BuyBait(playerid, 0, 1000);
            case 1: Hunter_BuyBait(playerid, 1, 1000);
            case 2: Hunter_BuyBait(playerid, 2, 1500);
            case 3: Hunter_BuyBait(playerid, 3, 1500);
        }
        return 1;
    }

    #if defined Hunter_OnDialogResponse
        return Hunter_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse Hunter_OnDialogResponse
#if defined Hunter_OnDialogResponse
    forward Hunter_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerConnect(playerid)
{
    HunterMarkerTimer[playerid] = 0;
    HunterTargetZone[playerid] = -1;
    HunterJobTimer[playerid] = 0;
    HunterJobActive[playerid] = false;
    HunterWeaponIssued[playerid] = false;
    HunterCurrentTarget[playerid] = -1;
    for(new i = 0; i < HUNTER_ANIMAL_COUNT; i++)
    {
        HunterAnimalTaken[playerid][i] = false;
        HunterAnimalObject[playerid][i] = INVALID_STREAMER_ID;
    }
    Hunter_SpawnPlayerAnimals(playerid);

    #if defined Hunter_OnPlayerConnect
        return Hunter_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Hunter_OnPlayerConnect
#if defined Hunter_OnPlayerConnect
    forward Hunter_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(HunterJobTimer[playerid] != 0)
    {
        KillTimer(HunterJobTimer[playerid]);
        HunterJobTimer[playerid] = 0;
    }
    HunterJobActive[playerid] = false;
    HunterWeaponIssued[playerid] = false;
    Hunter_ResetAnimals(playerid);

    #if defined Hunter_OnPlayerDisconnect
        return Hunter_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Hunter_OnPlayerDisconnect
#if defined Hunter_OnPlayerDisconnect
    forward Hunter_OnPlayerDisconnect(playerid, reason);
#endif

CMD:hunt(playerid, params[])
{
    #pragma unused params
    if(GetPlayerLevel(playerid) < HUNTER_MIN_LEVEL) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Работа охотника доступна с 4 уровня.");
    return Hunter_ShowMainMenu(playerid);
}

CMD:oxota(playerid, params[])
{
    #pragma unused params
    if(GetPlayerLevel(playerid) < HUNTER_MIN_LEVEL) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Работа охотника доступна с 4 уровня.");
    return Hunter_ShowMainMenu(playerid);
}

CMD:huntgun(playerid, params[])
{
    #pragma unused params
    return Hunter_GiveWeaponAndMark(playerid);
}

stock Hunter_CommandMark(playerid)
{
    if(!HunterJobActive[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Вы сейчас не работаете охотником.");
    if(!HunterWeaponIssued[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Сначала получите АК-47: /huntgun.");
    Hunter_MarkNextAnimal(playerid);
    SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Метка животного обновлена: радар, GPS, checkpoint и зона на карте.");
    return 1;
}

CMD:huntmark(playerid, params[])
{
    #pragma unused params
    return Hunter_CommandMark(playerid);
}

CMD:huntanimals(playerid, params[])
{
    #pragma unused params
    Hunter_SpawnPlayerAnimals(playerid);
    SendClientMessage(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF}Животные охоты заново созданы рядом с меткой.");
    return 1;
}

CMD:animalmark(playerid, params[])
{
    #pragma unused params
    return Hunter_CommandMark(playerid);
}

CMD:exito(playerid, params[])
{
    #pragma unused params
    if(!HunterJobActive[playerid]) return SendClientMessage(playerid, COLOR_WHITE, "{FF0000}| {FFFFFF}Вы сейчас не работаете охотником.");
    return Hunter_StopJob(playerid, false);
}
