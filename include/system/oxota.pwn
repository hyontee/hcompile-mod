



#if defined _oxota_included
    #endinput
#endif
#define _oxota_included

// Объявление диалогов
#define DIALOG_OXOTNIK       1000
#define DIALOG_OXOTA         1001
#define DIALOG_OXOTNIKTRI    1002
#define DIALOG_OXOTNIKDVA    1003
#define DIALOG_OXOTNIKODIN   1004
#define DIALOG_OXOTNIKCHET   1005
#define DIALOG_OXOTNIKPYAT   1006
#define DIALOG_OXOTNIKSHEST  1007

// Переменные
static oxotnik;
static oxotnikk;
static bear, bearr, duck, duckk, duckkk, hare, haree, hareee, deer, deerr;

// Массивы для учёта добычи
static bearyes[MAX_PLAYERS];
static bearryes[MAX_PLAYERS];
static duckyes[MAX_PLAYERS];
static duckkyes[MAX_PLAYERS];
static duckkkyes[MAX_PLAYERS];
static hareyes[MAX_PLAYERS];
static hareeyes[MAX_PLAYERS];
static hareeeyes[MAX_PLAYERS];
static deeryes[MAX_PLAYERS];
static deerryes[MAX_PLAYERS];

// Таймеры для работы
static PlayerWorkTimer[MAX_PLAYERS];

// Инициализация системы охоты (вызвать в OnGameModeInit)
stock InitOxotaSystem()
{
    // Создание NPC охотника
    oxotnik = CreateActor(58, 1985.583740, 459.479614, 13.306870);
    Create3DTextLabel("{FFFF00}Николыч - Охотник\n {FFFFFF}подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 1985.583740, 459.479614, 13.306870, 3.0, 0, 1);
    oxotnikk = CreateDynamicSphere(1985.583740, 459.479614, 13.306870, 1.0);
    
    // Создание объектов животных
    CreateObject(935, 1962.890747, 635.540649, 16.062086, 0.0, 0.0, 100.0);
    CreateObject(935, 2279.294434, 483.308716, 17.176340, 0.0, 0.0, 100.0);
    CreateObject(937, 2126.690674, 647.208008, 11.904692, 0.0, 0.0, 200.0);
    CreateObject(937, 2099.226074, 640.961060, 13.713184, 0.0, 0.0, 100.0);
    CreateObject(937, 2062.120850, 575.798035, 12.450968, 0.0, 0.0, 100.0);
    CreateObject(938, 2107.848145, 696.609253, 13.375849, 0.0, 0.0, 100.0);
    CreateObject(938, 2225.247314, 646.524048, 24.670685, 0.0, 0.0, 100.0);
    CreateObject(938, 2252.786865, 571.908142, 26.584200, 0.0, 0.0, 100.0);
    CreateObject(936, 1869.011230, 709.783386, 13.247627, 0.0, 0.0, 100.0);
    CreateObject(936, 2486.657959, 432.048859, 21.723936, 0.0, 0.0, 100.0);
    
    // Создание зон взаимодействия с животными
    bear = CreateDynamicSphere(1962.890747, 635.540649, 16.062086, 1.5);
    bearr = CreateDynamicSphere(2279.294434, 483.308716, 17.176340, 1.5);
    duck = CreateDynamicSphere(2126.690674, 647.208008, 11.904692, 1.5);
    duckk = CreateDynamicSphere(2099.226074, 640.961060, 13.713184, 1.5);
    duckkk = CreateDynamicSphere(2062.120850, 575.798035, 12.450968, 1.5);
    hare = CreateDynamicSphere(2107.848145, 696.609253, 13.375849, 1.5);
    haree = CreateDynamicSphere(2225.247314, 646.524048, 24.670685, 1.5);
    hareee = CreateDynamicSphere(2252.786865, 571.908142, 26.584200, 1.5);
    deer = CreateDynamicSphere(1869.011230, 709.783386, 13.247627, 1.5);
    deerr = CreateDynamicSphere(2486.657959, 432.048859, 21.723936, 1.5);
    
    return 1;
}

// Показ главного меню охотника
stock ShowWorkOxotnik(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_OXOTNIK, DIALOG_STYLE_LIST,
    "{FF0000}SANDER RUSSIA |{FFFAFA} Основное меню",
    "{FF4500}#1 {FFFAFA}Посмотреть свою статистику охотника\n\
    {FF4500}#2 {FFFAFA}Посмотреть доступные тарифы для охотника\n\
    {FF4500}#3 {FFFAFA}Посмотреть все трофеи охотника\n\
    {FF4500}#4 {FFFAFA}Приобрести приманки для животных\n\
    {FF4500}#5 {FFFAFA}Продать полученную добычу\n\
    {FF4500}#6 {FFFAFA}Посмотреть стоимость животных",
    "Выбрать", "Закрыть");
    return 1;
}

// Обработка взаимодействия с животными
stock ShowWorkBear(playerid)    { if(bearyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого медведя!"), 0; bearyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу медведя! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkBearr(playerid)   { if(bearryes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого медведя!"), 0; bearryes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу медведя! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkDuck(playerid)    { if(duckyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этой утки!"), 0; duckyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу утки! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkDuckk(playerid)   { if(duckkyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этой утки!"), 0; duckkyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу утки! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkDuckkk(playerid)  { if(duckkkyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этой утки!"), 0; duckkkyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу утки! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkHare(playerid)    { if(hareyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого зайца!"), 0; hareyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу зайца! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkHaree(playerid)   { if(hareeyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого зайца!"), 0; hareeyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу зайца! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkHareee(playerid)  { if(hareeeyes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого зайца!"), 0; hareeeyes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу зайца! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkDeer(playerid)    { if(deeryes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого оленя!"), 0; deeryes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу оленя! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }
stock ShowWorkDeerr(playerid)   { if(deerryes[playerid]) return SendClientMessage(playerid, -1, "{FF0000}| {FFFFFF}Вы уже подобрали тушу этого оленя!"), 0; deerryes[playerid]=1; SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы подобрали тушу оленя! +250 рублей"); GivePlayerMoney(playerid,250); return 1; }

// Таймеры
forward TEST1(playerid); public TEST1(playerid) { if(PlayerWorkTimer[playerid]) KillTimer(PlayerWorkTimer[playerid]); PlayerWorkTimer[playerid]=0; SetPlayerVirtualWorld(playerid,0); SetPlayerSkin(playerid,0); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Ваше время работы охотником истекло!"); return 1; }
forward TEST2(playerid); public TEST2(playerid) { if(PlayerWorkTimer[playerid]) KillTimer(PlayerWorkTimer[playerid]); PlayerWorkTimer[playerid]=0; SetPlayerVirtualWorld(playerid,0); SetPlayerSkin(playerid,0); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Ваше время работы охотником истекло!"); return 1; }
forward TEST3(playerid); public TEST3(playerid) { if(PlayerWorkTimer[playerid]) KillTimer(PlayerWorkTimer[playerid]); PlayerWorkTimer[playerid]=0; SetPlayerVirtualWorld(playerid,0); SetPlayerSkin(playerid,0); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Ваше время работы охотником истекло!"); return 1; }
forward TEST4(playerid); public TEST4(playerid) { if(PlayerWorkTimer[playerid]) KillTimer(PlayerWorkTimer[playerid]); PlayerWorkTimer[playerid]=0; SetPlayerVirtualWorld(playerid,0); SetPlayerSkin(playerid,0); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Ваше время работы охотником истекло!"); return 1; }

// Обработка входа в зоны (вызвать из OnPlayerEnterDynamicArea)
stock OnPlayerEnterOxotaArea(playerid, areaid)
{
    if(areaid == oxotnikk)
    {
        ShowWorkOxotnik(playerid);
        return 1;
    }
    if(areaid == bear) return ShowWorkBear(playerid);
    if(areaid == bearr) return ShowWorkBearr(playerid);
    if(areaid == duck) return ShowWorkDuck(playerid);
    if(areaid == duckk) return ShowWorkDuckk(playerid);
    if(areaid == duckkk) return ShowWorkDuckkk(playerid);
    if(areaid == hare) return ShowWorkHare(playerid);
    if(areaid == haree) return ShowWorkHaree(playerid);
    if(areaid == hareee) return ShowWorkHareee(playerid);
    if(areaid == deer) return ShowWorkDeer(playerid);
    if(areaid == deerr) return ShowWorkDeerr(playerid);
    return 0;
}

// Обработка диалогов (вызвать из OnDialogResponse)
stock OnOxotaDialogResponse(playerid, dialogid, response, listitem)
{
    if(dialogid == DIALOG_OXOTNIK)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: ShowPlayerDialog(playerid, DIALOG_OXOTNIKODIN, DIALOG_STYLE_LIST, "{FF0000}SANDER RUSSIA |{FFFFFF} Статистика охотника", "Уток: 0\nЗайцев: 0\nОленей: 0\nМедведей: 0\nВсего: 0\nСкилл: Новичок", "Выйти", "Назад");
            case 1: ShowPlayerDialog(playerid, DIALOG_OXOTNIKDVA, DIALOG_STYLE_LIST, "{FF0000}SANDER RUSSIA |{FFFFFF} Тарифы охоты", "#1\tНачинающий (15 мин)\t3.000 руб.\n#2\tБывалый (25 мин)\t6.000 руб.\n#3\tНеутомимый (45 мин)\t8.000 руб.\n#4\tЗаядлый (60 мин)\t10.000 руб.", "Выбрать", "Назад");
            case 2: ShowPlayerDialog(playerid, DIALOG_OXOTNIKTRI, DIALOG_STYLE_LIST, "{FF0000}SANDER RUSSIA |{FFFFFF} Трофеи", "Медвежьи шкуры: 0\nУтиные тушки: 0\nЗаячьи тушки: 0\nОленьи рога: 0", "Назад", "Закрыть");
            case 3: ShowPlayerDialog(playerid, DIALOG_OXOTNIKCHET, DIALOG_STYLE_LIST, "{FF0000}SANDER RUSSIA |{FFFFFF} Приманки", "#1\tУтки\t1.000 руб.\n#2\tЗайцы\t1.000 руб.\n#3\tОлени\t1.500 руб.\n#4\tМедведи\t1.500 руб.", "Купить", "Назад");
            case 4: SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}У вас нет добычи для продажи.");
            case 5: ShowPlayerDialog(playerid, DIALOG_OXOTNIKSHEST, DIALOG_STYLE_LIST, "{FF0000}SANDER RUSSIA |{FFFFFF} Стоимость", "#1\tУтка\t1.150 руб.\n#2\tЗаяц\t1.150 руб.\n#3\tОлень\t1.150 руб.\n#4\tМедведь\t1.200 руб.", "Выйти", "Назад");
        }
        return 1;
    }
    if(dialogid == DIALOG_OXOTNIKDVA)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: SetPlayerSkin(playerid,58); SetPlayerVirtualWorld(playerid,1); GivePlayerMoney(playerid,-3000); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Вы устроились Начинающим охотником! Выход: /exito"); PlayerWorkTimer[playerid]=SetTimerEx("TEST1",900000,false,"i",playerid);
            case 1: SetPlayerSkin(playerid,58); SetPlayerVirtualWorld(playerid,1); GivePlayerMoney(playerid,-6000); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Вы устроились Бывалым охотником! Выход: /exito"); PlayerWorkTimer[playerid]=SetTimerEx("TEST2",1500000,false,"i",playerid);
            case 2: SetPlayerSkin(playerid,58); SetPlayerVirtualWorld(playerid,1); GivePlayerMoney(playerid,-8000); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Вы устроились Неутомимым охотником! Выход: /exito"); PlayerWorkTimer[playerid]=SetTimerEx("TEST3",2700000,false,"i",playerid);
            case 3: SetPlayerSkin(playerid,58); SetPlayerVirtualWorld(playerid,1); GivePlayerMoney(playerid,-10000); SendClientMessage(playerid,-1,"{FF0000}| {FFFFFF}Вы устроились Заядлым охотником! Выход: /exito"); PlayerWorkTimer[playerid]=SetTimerEx("TEST4",3600000,false,"i",playerid);
        }
        return 1;
    }
    if(dialogid == DIALOG_OXOTNIKCHET)
    {
        if(!response) return 1;
        new money = GetPlayerMoney(playerid);
        switch(listitem)
        {
            case 0: if(money>=1000) GivePlayerMoney(playerid,-1000), SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы купили приманки для уток!"); else SendClientMessage(playerid,-1,"{FF0000}| Недостаточно рублей!");
            case 1: if(money>=1000) GivePlayerMoney(playerid,-1000), SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы купили приманки для зайцев!"); else SendClientMessage(playerid,-1,"{FF0000}| Недостаточно рублей!");
            case 2: if(money>=1500) GivePlayerMoney(playerid,-1500), SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы купили приманки для оленей!"); else SendClientMessage(playerid,-1,"{FF0000}| Недостаточно рублей!");
            case 3: if(money>=1500) GivePlayerMoney(playerid,-1500), SendClientMessage(playerid,-1,"{00FF00}| {FFFFFF}Вы купили приманки для медведей!"); else SendClientMessage(playerid,-1,"{FF0000}| Недостаточно рублей!");
        }
        return 1;
    }
    return 0;
}


stock ResetOxotaData(playerid)
{
    bearyes[playerid]=bearryes[playerid]=duckyes[playerid]=duckkyes[playerid]=duckkkyes[playerid]=0;
    hareyes[playerid]=hareeyes[playerid]=hareeeyes[playerid]=deeryes[playerid]=deerryes[playerid]=0;
    if(PlayerWorkTimer[playerid]) KillTimer(PlayerWorkTimer[playerid]), PlayerWorkTimer[playerid]=0;
    return 1;
}