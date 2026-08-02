// РАБОТА ШАХТЕРА + НОЧНОЙ КЛУБ (MODULAR VERSION)
#if defined _miners_job_included
    #endinput
#endif
#define _miners_job_included

#include <a_samp>
#include <streamer> // Для динамических объектов

// Настройки шахты
#define JOB_SKIN 16
#define MAX_MINING_POINTS 3
#define MAX_DROP_POINTS 2

// Настройки клуба
#define CLUB_ENTER_X 661.394592
#define CLUB_ENTER_Y 262.068786
#define CLUB_ENTER_Z 13.904136
#define CLUB_ENTER_ANGLE 180.0

#define CLUB_EXIT_X 7.67
#define CLUB_EXIT_Y -14.38
#define CLUB_EXIT_Z 1511.43

#define CLUB_INTERIOR_X 2.949258
#define CLUB_INTERIOR_Y -14.114147
#define CLUB_INTERIOR_Z 1511.428833
#define CLUB_INTERIOR_ANGLE 99.883666

// Переменные шахты
static miners_job_pickup;
static bool:IsWorking[MAX_PLAYERS];
static bool:HasOre[MAX_PLAYERS];
static bool:IsMining[MAX_PLAYERS];
static bool:IsDropping[MAX_PLAYERS];
static Float:PlayerSalary[MAX_PLAYERS];

static Float:MiningPos[MAX_MINING_POINTS][3] = {
    {541.781188, 536.942138, 998.599914},
    {553.632751, 543.906188, 998.715026},
    {575.882080, 539.994384, 998.688415}
};

static Float:DropPos[MAX_DROP_POINTS][3] = {
    {557.126281, 515.864257, 999.715576},
    {557.126281, 515.864257, 999.715576}
};

// Переменные клуба
static bool:InClub[MAX_PLAYERS];
static Text3D:clubEnterLabel;
static Text3D:clubExitLabel;
static PlayerClubInterior[MAX_PLAYERS]; // Запоминаем интерьер до входа

// Хук OnGameModeInit
public OnGameModeInit()
{
    // Инициализация шахты
    CreateActor(JOB_SKIN, 540.975830, 514.147460, 1000.320739, 93.113723);
    miners_job_pickup = CreatePickup(1275, 23, 540.123291, 514.074218, 1000.319030, -1);
    
    Create3DTextLabel("{FFFFFF}ШАХТА\n{FFFFFF}Чтобы устроиться, подойдите поближе", -1, 540.975830, 514.147460, 1000.320739, 10.0, 0);
    
    for(new i = 0; i < MAX_MINING_POINTS; i++) 
        Create3DTextLabel("{FFFF00}Место добычи руды\n{FFFFFF}Подойдите поближе", -1, MiningPos[i][0], MiningPos[i][1], MiningPos[i][2], 10.0, 0);

    for(new i = 0; i < MAX_DROP_POINTS; i++)
        Create3DTextLabel("{00FF00}Место сдачи руды\n{FFFFFF}Подойдите поближе", -1, DropPos[i][0], DropPos[i][1], DropPos[i][2], 10.0, 0);

    // Инициализация клуба
    CreateClubInterior();
    
    // 3D текст у входа
    clubEnterLabel = Create3DTextLabel("{FFFF00}НОЧНОЙ КЛУБ\n{FFFFFF}Нажмите {00FF00}Y {FFFFFF}для входа", 
        -1, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z + 1.0, 10.0, 0);
    
    // 3D текст у выхода внутри клуба
    clubExitLabel = Create3DTextLabel("{FFFF00}ВЫХОД ИЗ КЛУБА\n{FFFFFF}Нажмите {FF0000}Y {FFFFFF}для выхода", 
        -1, CLUB_EXIT_X, CLUB_EXIT_Y, CLUB_EXIT_Z + 1.0, 10.0, 0);

    #if defined miner_OnGameModeInit
        return miner_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit miner_OnGameModeInit
#if defined miner_OnGameModeInit
    forward miner_OnGameModeInit();
#endif

// Хук OnPlayerKeyStateChange для входа/выхода
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    // Нажатие клавиши Y (YES)
    if(newkeys & KEY_YES)
    {
        // Проверка входа в клуб
        if(IsPlayerInRangeOfPoint(playerid, 2.0, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z))
        {
            EnterClub(playerid);
            return 1;
        }
        
        // Проверка выхода из клуба
        if(InClub[playerid] && IsPlayerInRangeOfPoint(playerid, 2.0, CLUB_EXIT_X, CLUB_EXIT_Y, CLUB_EXIT_Z))
        {
            ExitClub(playerid);
            return 1;
        }
    }

    #if defined miner_OnPlayerKeyStateChange
        return miner_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange miner_OnPlayerKeyStateChange
#if defined miner_OnPlayerKeyStateChange
    forward miner_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

// Хук OnPlayerPickUpPickupEx (шахта)
public OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
    if(pickupid == miners_job_pickup)
    {
        if(IsWorking[playerid])
        {
            IsWorking[playerid] = false;
            IsMining[playerid] = false;
            IsDropping[playerid] = false;
            
            TogglePlayerControllable(playerid, 1);
            ClearAnimations(playerid);

            if(PlayerSalary[playerid] > 0.0) 
                GiveMinerSalary(playerid);
            else 
            {
                SendClientMessage(playerid, -1, "{FF0000}Вы уволились с работы шахтера.");
                SendClientMessage(playerid, -1, "{00FF00}Что-бы переодеться в свою одежду используй /inv.");
            }

            if(HasOre[playerid]) 
            {
                if(IsPlayerAttachedObjectSlotUsed(playerid, 1)) RemovePlayerAttachedObject(playerid, 1);
                HasOre[playerid] = false;
            }
        }
        else
        {
            IsWorking[playerid] = true;
            IsMining[playerid] = false;
            IsDropping[playerid] = false;
            HasOre[playerid] = false;
            PlayerSalary[playerid] = 0.0;
            
            SetPlayerSkin(playerid, JOB_SKIN);
            SendClientMessage(playerid, -1, "{00FF00}Вы устроились шахтером! Идите к местам добычи руды.");
        }
        return 1;
    }

    #if defined miner_OnPlayerPickUpPickupEx
        return miner_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerPickUpPickupEx
    #undef OnPlayerPickUpPickupEx
#else
    #define _ALS_OnPlayerPickUpPickupEx
#endif
#define OnPlayerPickUpPickupEx miner_OnPlayerPickUpPickupEx
#if defined miner_OnPlayerPickUpPickupEx
    forward miner_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id);
#endif

// Хук OnPlayerUpdate (шахта)
public OnPlayerUpdate(playerid)
{
    if(IsWorking[playerid])
    {
        if(!HasOre[playerid] && !IsMining[playerid]) {
            for(new i = 0; i < MAX_MINING_POINTS; i++) {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, MiningPos[i][0], MiningPos[i][1], MiningPos[i][2])) {
                    StartMining(playerid);
                    break;
                }
            }
        }
        else if(HasOre[playerid] && !IsDropping[playerid]) {
            for(new i = 0; i < MAX_DROP_POINTS; i++) {
                if(IsPlayerInRangeOfPoint(playerid, 2.0, DropPos[i][0], DropPos[i][1], DropPos[i][2])) {
                    FinishDrop(playerid);
                    break;
                }
            }
        }
    }

    #if defined miner_OnPlayerUpdate
        return miner_OnPlayerUpdate(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerUpdate
    #undef OnPlayerUpdate
#else
    #define _ALS_OnPlayerUpdate
#endif
#define OnPlayerUpdate miner_OnPlayerUpdate
#if defined miner_OnPlayerUpdate
    forward miner_OnPlayerUpdate(playerid);
#endif

// Функции шахты
forward StartMining(playerid);
public StartMining(playerid)
{
    IsMining[playerid] = true;
    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BASEBALL", "Bat_4", 4.1, 1, 1, 1, 1, 1, 1);
    SendClientMessage(playerid, -1, "{FFFF00}Вы начали добычу руды... {FFFFFF}Подождите 10 секунд.");
    SetTimerEx("OnMiningFinished", 10000, false, "i", playerid);
}

forward OnMiningFinished(playerid);
public OnMiningFinished(playerid)
{
    if(!IsWorking[playerid]) return 0;
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);
    HasOre[playerid] = true;
    IsMining[playerid] = false;
    SendClientMessage(playerid, -1, "{00FF00}Вы добыли руду! {FFFFFF}Отнесите её на место сдачи.");
    return 1;
}

forward FinishDrop(playerid);
public FinishDrop(playerid)
{
    IsDropping[playerid] = true;
    HasOre[playerid] = false;
    ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 1);
    
    new weight = 25 + random(26);
    new price_per_kg = 15000 + random(16000);
    new earned = weight * price_per_kg;

    PlayerSalary[playerid] += float(earned);

    new str[144];
    format(str, sizeof(str), "{00FF00}Вы сдали %d кг руды. {FFFFFF}Заработано: %d руб. (Всего: %d руб.)", weight, earned, floatround(PlayerSalary[playerid]));
    SendClientMessage(playerid, -1, str);
    SetTimerEx("UnlockDrop", 3000, false, "i", playerid);
}

forward UnlockDrop(playerid);
public UnlockDrop(playerid) IsDropping[playerid] = false;

forward GiveMinerSalary(playerid);
public GiveMinerSalary(playerid)
{
    new salary = floatround(PlayerSalary[playerid]);
    PlayerSalary[playerid] = 0.0;
    GivePlayerMoney(playerid, salary);
    new str[128];
    format(str, sizeof(str), "{FFFF00}Вы уволились. Получено за смену: {00FF00}%d руб.", salary);
    SendClientMessage(playerid, -1, str);
    SendClientMessage(playerid, -1, "{00FF00}Что-бы переодеться в свою одежду используй /inv.");
}

// Функции клуба
CreateClubInterior()
{
    // Создаем интерьер клуба (можно добавить объекты)
    // Например, диваны, столики, танцпол, светомузыку
    
    // Танцпол (круглый)
    CreateDynamicObject(19355, 2.949258, -14.114147, 1510.428833, 0.0, 0.0, 0.0);
    
    // Добавим несколько столиков
    CreateDynamicObject(1670, 0.0, -10.0, 1510.5, 0.0, 0.0, 0.0); // Столик
    CreateDynamicObject(1670, 5.0, -10.0, 1510.5, 0.0, 0.0, 0.0);
    CreateDynamicObject(1670, -3.0, -18.0, 1510.5, 0.0, 0.0, 0.0);
    CreateDynamicObject(1670, 9.0, -18.0, 1510.5, 0.0, 0.0, 0.0);
    
    // Диваны
    CreateDynamicObject(1714, -5.0, -12.0, 1510.0, 0.0, 0.0, 90.0);
    CreateDynamicObject(1714, -5.0, -16.0, 1510.0, 0.0, 0.0, 90.0);
    CreateDynamicObject(1714, 10.0, -12.0, 1510.0, 0.0, 0.0, 270.0);
    CreateDynamicObject(1714, 10.0, -16.0, 1510.0, 0.0, 0.0, 270.0);
    
    // Барная стойка
    CreateDynamicObject(19366, 2.949258, -6.0, 1510.0, 0.0, 0.0, 0.0);
    
    // Светомузыка на потолке
    for(new i = 0; i < 8; i++)
    {
        CreateDynamicObject(19457, 2.949258 + float(i) * 1.5, -14.114147, 1515.0, 0.0, 0.0, 0.0);
    }
}

// Вход в клуб
EnterClub(playerid)
{
    if(InClub[playerid]) return;
    
    // Сохраняем интерьер перед входом
    PlayerClubInterior[playerid] = GetPlayerInterior(playerid);
    InClub[playerid] = true;
    
    // Телепортируем игрока внутрь
    SetPlayerPos(playerid, CLUB_INTERIOR_X, CLUB_INTERIOR_Y, CLUB_INTERIOR_Z);
    SetPlayerFacingAngle(playerid, CLUB_INTERIOR_ANGLE);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1000); // Свой виртуальный мир для каждого
    
    // Включаем ночное видение (эффект клуба)
    SetPlayerWeather(playerid, 0); // Ночная погода
    SetPlayerTime(playerid, 22, 0); // 22:00
    
    SendClientMessage(playerid, -1, "{FFFF00}Добро пожаловать в ночной клуб!");
    SendClientMessage(playerid, -1, "{FFFFFF}Чтобы выйти, подойдите к выходу и нажмите {FF0000}Y");
}

// Выход из клуба
ExitClub(playerid)
{
    if(!InClub[playerid]) return;
    
    // Возвращаем игрока обратно
    InClub[playerid] = false;
    
    SetPlayerPos(playerid, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z);
    SetPlayerFacingAngle(playerid, CLUB_ENTER_ANGLE);
    SetPlayerInterior(playerid, PlayerClubInterior[playerid]);
    SetPlayerVirtualWorld(playerid, 0);
    
    // Возвращаем нормальную погоду
    SetPlayerWeather(playerid, 0);
    SetPlayerTime(playerid, 12, 0);
    
    SendClientMessage(playerid, -1, "{00FF00}Вы вышли из ночного клуба.");
}

// Команда /club - информация о клубе
CMD:club(playerid, params[])
{
    SendClientMessage(playerid, -1, "{FFFF00}=== НОЧНОЙ КЛУБ ===");
    SendClientMessage(playerid, -1, "{FFFFFF}Вход: {00FF00}/enterclub или нажмите {FFFF00}Y {FFFFFF}у входа");
    SendClientMessage(playerid, -1, "{FFFFFF}Выход: подойдите к выходу внутри и нажмите {FF0000}Y");
    SendClientMessage(playerid, -1, "{FFFFFF}В клубе вы можете: отдохнуть, потанцевать, пообщаться");
    return 1;
}

// Команда /enterclub - войти в клуб (если не хотите использовать Y)
CMD:enterclub(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, CLUB_ENTER_X, CLUB_ENTER_Y, CLUB_ENTER_Z))
    {
        EnterClub(playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, "{FF0000}Вы не у входа в ночной клуб!");
    }
    return 1;
}

// Команда /exitclub - выйти из клуба
CMD:exitclub(playerid, params[])
{
    if(InClub[playerid])
    {
        ExitClub(playerid);
    }
    else
    {
        SendClientMessage(playerid, -1, "{FF0000}Вы не в ночном клубе!");
    }
    return 1;
}

// Дополнительный функционал для клуба
// Танцы (/dance)
CMD:dance(playerid, params[])
{
    if(!InClub[playerid])
    {
        SendClientMessage(playerid, -1, "{FF0000}Вы должны быть в клубе, чтобы танцевать!");
        return 1;
    }
    
    new danceType = 0;
    if(sscanf(params, "d", danceType))
    {
        SendClientMessage(playerid, -1, "{FFFF00}Использование: /dance [тип]");
        SendClientMessage(playerid, -1, "{FFFFFF}1 - Медленный, 2 - Быстрый, 3 - Диско");
        return 1;
    }
    
    switch(danceType)
    {
        case 1: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0);
        case 2: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0);
        case 3: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
        default: SendClientMessage(playerid, -1, "{FF0000}Неверный тип танца! Используйте 1-3.");
    }
    
    SendClientMessage(playerid, -1, "{00FF00}Вы начали танцевать!");
    return 1;
}

// Остановить танец
CMD:stopdance(playerid, params[])
{
    ClearAnimations(playerid);
    SendClientMessage(playerid, -1, "{FFFF00}Вы остановили танец.");
    return 1;
}

// /clubinfo - информация о клубе
CMD:clubinfo(playerid, params[])
{
    new str[256];
    format(str, sizeof(str), 
        "{FFFF00}=== ИНФОРМАЦИЯ О КЛУБЕ ===\n" \
        "{FFFFFF}Посетителей: {00FF00}%d\n" \
        "{FFFFFF}Статус: {00FF00}Открыт\n" \
        "{FFFFFF}Время работы: Круглосуточно", 
        GetClubVisitors());
    SendClientMessage(playerid, -1, str);
    return 1;
}

// Функция подсчета посетителей в клубе
stock GetClubVisitors()
{
    new count = 0;
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && InClub[i])
            count++;
    }
    return count;
}