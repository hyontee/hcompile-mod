// ==================== HEL TOP ХЭЛЛОУИН ИВЕНТ 2025 ====================
#include <a_samp>
#include <streamer>

#if defined _HEL_top_included
	#endinput
#endif
#define _HEL_top_included

// Настройки
#define HEL_NPC_SKIN 208
#define HEL_SHOP_SKIN 5360
#define HEL_GUARD_SKIN 285
#define HEL_BOSS_SKIN 5367
#define HEL_WEATHER 8
#define HEL_WORLD_TIME 23

// Награды
#define HEL_CASH_REWARD 50000000
#define HEL_BC_REWARD 3000

// Магазин
#define HEL_SKIN_HISHMISH 300000000
#define HEL_SKIN_MYERS 100000000
#define HEL_CAR_FERRARI 150000000
#define HEL_CAR_BMW 200000000

// Диалоги
#define HEL_DIALOG_START 15000
#define HEL_DIALOG_SHOP 15001
#define HEL_DIALOG_ZONE 15002
#define HEL_DIALOG_PROGRESS 15003
#define HEL_DIALOG_WIN 15004
#define HEL_DIALOG_LEAVE 15005

// Переменные
new bool:HEL_EventActive = false;
new HEL_PlayerStep[MAX_PLAYERS];
new HEL_ZombieKills[MAX_PLAYERS];
new HEL_GhostKills[MAX_PLAYERS];
new HEL_BossDamage[MAX_PLAYERS];
new bool:HEL_PlayerInEvent[MAX_PLAYERS];
new HEL_EventStartTime[MAX_PLAYERS];
new HEL_PlayerWaveTimer[MAX_PLAYERS];

// Актеры
new HEL_HalloweenBoss = -1;
new HEL_ZombieActors[20] = {-1, ...};
new HEL_GhostActors[10] = {-1, ...};

// Таймер
new HEL_CheckTimer;

// Координаты из твоих фото
static const Float:HEL_EventSpawns[][] = {
    {-440.163208, -176.945327, 26.772689, 67.254104}, // Фредди Крюгер
    {-460.369201, -235.485900, 34.400775, -236.657470}, // Магазин
    {-443.441345, -236.005218, 32.221454, 35.992034}, // Стражник
    {-442.998046, 162.960388, 26.226863, 169.023574}, // Зона ивента
    {-450.0, -200.0, 35.0, 0.0}, // Босс
    {-430.0, -180.0, 33.0, 90.0}, // Волна 1
    {-460.0, -160.0, 33.0, 180.0}, // Волна 2
    {-480.0, -200.0, 33.0, 270.0}, // Волна 3
    {832.039489, 801.205017, 13.167973, 245.885352} // Возврат
};

// ==================== АВТОМАТИЧЕСКАЯ СИСТЕМА ПОДХОДОВ ====================
forward HEL_CheckPlayerPositions();
public HEL_CheckPlayerPositions()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(IsPlayerConnected(playerid))
        {
            if(!HEL_PlayerInEvent[playerid])
            {
                if(IsPlayerInRangeOfPoint(playerid, 3.0, HEL_EventSpawns[0][0], HEL_EventSpawns[0][1], HEL_EventSpawns[0][2]))
                {
                    HEL_StartHalloweenNPC(playerid);
                }
            }
            else
            {
                if(IsPlayerInRangeOfPoint(playerid, 3.0, HEL_EventSpawns[1][0], HEL_EventSpawns[1][1], HEL_EventSpawns[1][2]))
                {
                    HEL_ShowShop(playerid);
                }
                else if(IsPlayerInRangeOfPoint(playerid, 3.0, HEL_EventSpawns[2][0], HEL_EventSpawns[2][1], HEL_EventSpawns[2][2]))
                {
                    if(HEL_PlayerStep[playerid] == 0)
                    {
                        HEL_ShowZoneDialog(playerid);
                    }
                }
            }
        }
    }
}

// ==================== ИНИЦИАЛИЗАЦИЯ ИВЕНТА ====================
HEL_InitializeHalloweenEvent()
{
    HEL_EventActive = true;
    
    // Создаем NPC через стример
    CreateDynamicActor(HEL_NPC_SKIN, HEL_EventSpawns[0][0], HEL_EventSpawns[0][1], HEL_EventSpawns[0][2], HEL_EventSpawns[0][3], .worldid = 0, .interiorid = 0, .streamdistance = 300.0);
    CreateDynamicActor(HEL_SHOP_SKIN, HEL_EventSpawns[1][0], HEL_EventSpawns[1][1], HEL_EventSpawns[1][2], HEL_EventSpawns[1][3], .worldid = 0, .interiorid = 0, .streamdistance = 300.0);
    CreateDynamicActor(HEL_GUARD_SKIN, HEL_EventSpawns[2][0], HEL_EventSpawns[2][1], HEL_EventSpawns[2][2], HEL_EventSpawns[2][3], .worldid = 0, .interiorid = 0, .streamdistance = 300.0);
    
    // Запускаем проверку позиций
    HEL_CheckTimer = SetTimer("HEL_CheckPlayerPositions", 1000, true);
    
    // Устанавливаем атмосферу
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i))
        {
            SetPlayerWeather(i, HEL_WEATHER);
            SetPlayerTime(i, HEL_WORLD_TIME, 0);
            SendClientMessage(i, 0xFF4500AA, "[HEL] Хэллоуинский ивент начался! Найдите Фредди Крюгера!");
        }
    }
    
    print("[HEL] TOP Хэллоуин ивент активирован!");
    return 1;
}

// ==================== СТАРТОВЫЙ NPC ====================
stock HEL_StartHalloweenNPC(playerid)
{
    ShowPlayerDialog(playerid, HEL_DIALOG_START, DIALOG_STYLE_MSGBOX,
        "Фредди Крюгер [HEL]",
        "Приветствую в моих кошмарах! Город поглотила тьма.\n\nТебя ждут:\n• 3 волны врагов\n• Битва с боссом\n• Уникальные награды\n\nГотов ли ты?",
        "Начать", "Уйти");
    return 1;
}

// ==================== ДИАЛОГ СТРАЖНИКА ====================
HEL_ShowZoneDialog(playerid)
{
    ShowPlayerDialog(playerid, HEL_DIALOG_ZONE, DIALOG_STYLE_MSGBOX,
        "Стражник Врат [HEL]",
        "Ты дошел до Логова Ужаса! Испытания:\n• Волна зомби (15 убийств)\n• Охота на призраков (10 убийств)\n• Битва с боссом\n\nНаграда: 50.000.000$ + 3.000 доната",
        "Начать", "Выйти");
}

// ==================== ТЕЛЕПОРТАЦИЯ В ЗОНУ ====================
HEL_TeleportToZone(playerid)
{
    SetPlayerPos(playerid, HEL_EventSpawns[3][0], HEL_EventSpawns[3][1], HEL_EventSpawns[3][2]);
    SetPlayerFacingAngle(playerid, HEL_EventSpawns[3][3]);
    
    SetPlayerWeather(playerid, HEL_WEATHER);
    SetPlayerTime(playerid, HEL_WORLD_TIME, 0);
    
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, 29, 500);
    GivePlayerWeapon(playerid, 5, 1);
    GivePlayerWeapon(playerid, 25, 100);
    SetPlayerArmour(playerid, 100.0);
    SetPlayerHealth(playerid, 100.0);
    
    HEL_PlayerInEvent[playerid] = true;
    HEL_EventStartTime[playerid] = gettime();
    
    SendClientMessage(playerid, 0xFF0000AA, "[HEL] Добро пожаловать в Зону Кошмаров!");
    return 1;
}

// ==================== СИСТЕМА ВОЛН ====================
HEL_StartFirstWave(playerid)
{
    HEL_PlayerStep[playerid] = 1;
    HEL_ZombieKills[playerid] = 0;
    
    SendClientMessage(playerid, 0xFF4500AA, "[HEL] ВОЛНА 1: Уничтожьте 15 зомби!");
    
    for(new i = 0; i < 8; i++)
    {
        new Float:x = HEL_EventSpawns[5][0] + float(random(30) - 15);
        new Float:y = HEL_EventSpawns[5][1] + float(random(30) - 15);
        new Float:z = HEL_EventSpawns[5][2];
        
        HEL_ZombieActors[i] = CreateActor(68 + random(5), x, y, z, 0.0);
        SetActorHealth(HEL_ZombieActors[i], 100.0);
    }
    
    HEL_PlayerWaveTimer[playerid] = SetTimerEx("HEL_CheckWaveProgress", 1000, true, "i", playerid);
}

HEL_StartSecondWave(playerid)
{
    HEL_PlayerStep[playerid] = 2;
    HEL_GhostKills[playerid] = 0;
    
    for(new i = 0; i < sizeof(HEL_ZombieActors); i++)
    {
        if(IsValidActor(HEL_ZombieActors[i]))
        {
            DestroyActor(HEL_ZombieActors[i]);
        }
    }
    
    SendClientMessage(playerid, 0x00FFFFAA, "[HEL] ВОЛНА 2: Уничтожьте 10 призраков!");
    
    for(new i = 0; i < 6; i++)
    {
        new Float:x = HEL_EventSpawns[6][0] + float(random(40) - 20);
        new Float:y = HEL_EventSpawns[6][1] + float(random(40) - 20);
        new Float:z = HEL_EventSpawns[6][2];
        
        HEL_GhostActors[i] = CreateActor(0, x, y, z, 0.0);
        SetActorHealth(HEL_GhostActors[i], 80.0);
    }
}

HEL_StartBossWave(playerid)
{
    HEL_PlayerStep[playerid] = 3;
    HEL_BossDamage[playerid] = 0;
    
    for(new i = 0; i < sizeof(HEL_GhostActors); i++)
    {
        if(IsValidActor(HEL_GhostActors[i]))
        {
            DestroyActor(HEL_GhostActors[i]);
        }
    }
    
    SendClientMessage(playerid, 0xFF0000AA, "[HEL] ВОЛНА 3: Уничтожьте босса с 5000 HP!");
    
    HEL_HalloweenBoss = CreateActor(HEL_BOSS_SKIN, HEL_EventSpawns[4][0], HEL_EventSpawns[4][1], HEL_EventSpawns[4][2], 0.0);
    SetActorHealth(HEL_HalloweenBoss, 5000.0);
}

// ==================== ПРОВЕРКА ПРОГРЕССА ====================
forward HEL_CheckWaveProgress(playerid);
public HEL_CheckWaveProgress(playerid)
{
    if(!IsPlayerConnected(playerid) || !HEL_PlayerInEvent[playerid]) 
    {
        KillTimer(HEL_PlayerWaveTimer[playerid]);
        return 0;
    }
    
    switch(HEL_PlayerStep[playerid])
    {
        case 1:
        {
            if(HEL_ZombieKills[playerid] >= 15)
            {
                KillTimer(HEL_PlayerWaveTimer[playerid]);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] ВОЛНА 1 ПРОЙДЕНА!");
                SetTimerEx("HEL_StartSecondWave", 3000, false, "i", playerid);
            }
        }
        case 2:
        {
            if(HEL_GhostKills[playerid] >= 10)
            {
                KillTimer(HEL_PlayerWaveTimer[playerid]);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] ВОЛНА 2 ПРОЙДЕНА!");
                SetTimerEx("HEL_StartBossWave", 5000, false, "i", playerid);
            }
        }
        case 3:
        {
            if(!IsValidActor(HEL_HalloweenBoss))
            {
                KillTimer(HEL_PlayerWaveTimer[playerid]);
                HEL_CompleteEvent(playerid);
                return 0;
            }
            
            new Float:bossHP;
            GetActorHealth(HEL_HalloweenBoss, bossHP);
            
            if(bossHP <= 0.0)
            {
                KillTimer(HEL_PlayerWaveTimer[playerid]);
                HEL_CompleteEvent(playerid);
            }
        }
    }
    return 1;
}

// ==================== ЗАВЕРШЕНИЕ ИВЕНТА ====================
HEL_CompleteEvent(playerid)
{
    GameTextForPlayer(playerid, "~g~ПОБЕДА!~n~~w~ИВЕНТ ПРОЙДЕН!", 5000, 3);
    
    GivePlayerMoney(playerid, HEL_CASH_REWARD);
    
    new string[128];
    format(string, sizeof(string), "Поздравляем! Вы получаете:\n$%s\n%d доната", HEL_FormatNumber(HEL_CASH_REWARD), HEL_BC_REWARD);
    
    ShowPlayerDialog(playerid, HEL_DIALOG_WIN, DIALOG_STYLE_MSGBOX, "[HEL] ПОБЕДА!", string, "Ура!", "");
    
    SetTimerEx("HEL_ReturnPlayer", 5000, false, "i", playerid);
    
    HEL_ResetPlayerData(playerid);
}

// ==================== МАГАЗИН ====================
stock HEL_ShowShop(playerid)
{
    ShowPlayerDialog(playerid, HEL_DIALOG_SHOP, DIALOG_STYLE_LIST, 
        "[HEL] МАГАЗИН",
        "Хиш-Миш - 300.000.000$\n\
        Майкл Майерс - 100.000.000$\n\
        Ferrari - 150.000.000$\n\
        BMW - 200.000.000$\n\
        Тыквенная Голова - 50.000.000$",
        "Купить", "Назад");
    return 1;
}

HEL_ProcessShop(playerid, listitem)
{
    switch(listitem)
    {
        case 0:
        {
            if(GetPlayerMoney(playerid) >= HEL_SKIN_HISHMISH)
            {
                GivePlayerMoney(playerid, -HEL_SKIN_HISHMISH);
                SetPlayerSkin(playerid, 6864);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы купили скин 'Хиш-Миш'!");
            }
            else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Недостаточно денег!");
        }
        case 1:
        {
            if(GetPlayerMoney(playerid) >= HEL_SKIN_MYERS)
            {
                GivePlayerMoney(playerid, -HEL_SKIN_MYERS);
                SetPlayerSkin(playerid, 5367);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы купили скин 'Майкл Майерс'!");
            }
            else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Недостаточно денег!");
        }
        case 2:
        {
            if(GetPlayerMoney(playerid) >= HEL_CAR_FERRARI)
            {
                GivePlayerMoney(playerid, -HEL_CAR_FERRARI);
                new Float:x, Float:y, Float:z, Float:a;
                GetPlayerPos(playerid, x, y, z);
                GetPlayerFacingAngle(playerid, a);
                new carid = CreateVehicle(2614, x+3.0, y+3.0, z, a, -1, -1, 300);
                PutPlayerInVehicle(playerid, carid, 0);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы купили Ferrari!");
            }
            else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Недостаточно денег!");
        }
        case 3:
        {
            if(GetPlayerMoney(playerid) >= HEL_CAR_BMW)
            {
                GivePlayerMoney(playerid, -HEL_CAR_BMW);
                new Float:x, Float:y, Float:z, Float:a;
                GetPlayerPos(playerid, x, y, z);
                GetPlayerFacingAngle(playerid, a);
                new carid = CreateVehicle(772, x+3.0, y+3.0, z, a, -1, -1, 300);
                PutPlayerInVehicle(playerid, carid, 0);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы купили BMW!");
            }
            else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Недостаточно денег!");
        }
        case 4:
        {
            if(GetPlayerMoney(playerid) >= 50000000)
            {
                GivePlayerMoney(playerid, -50000000);
                SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы купили Тыквенную Голову!");
            }
            else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Недостаточно денег!");
        }
    }
}

// ==================== ОБРАБОТЧИК ДИАЛОГОВ ====================
stock HEL_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case HEL_DIALOG_START:
        {
            if(response) HEL_TeleportToZone(playerid);
            else SendClientMessage(playerid, 0xCCCCCCAA, "[HEL] Возвращайтесь позже!");
            return 1;
        }
        case HEL_DIALOG_SHOP:
        {
            if(response) HEL_ProcessShop(playerid, listitem);
            return 1;
        }
        case HEL_DIALOG_ZONE:
        {
            if(response) HEL_StartFirstWave(playerid);
            else
            {
                ShowPlayerDialog(playerid, HEL_DIALOG_LEAVE, DIALOG_STYLE_MSGBOX,
                    "[HEL] Выход",
                    "Вы уверены? Прогресс будет потерян!",
                    "Да", "Нет");
            }
            return 1;
        }
        case HEL_DIALOG_LEAVE:
        {
            if(response)
            {
                HEL_ReturnPlayer(playerid);
                SendClientMessage(playerid, 0xFFFF00AA, "[HEL] Вы покинули ивент.");
            }
            return 1;
        }
    }
    return 0;
}

// ==================== КОМАНДЫ ====================
CMD:hel_start(playerid) 
{
    HEL_InitializeHalloweenEvent(); 
    SendClientMessageToAll(0xFF4500AA, "[HEL] Хэллоуин ивент запущен! Найдите Фредди Крюгера!"); 
    return 1; 
}

CMD:hel_shop(playerid) 
{ 
    if(HEL_PlayerInEvent[playerid]) HEL_ShowShop(playerid); 
    else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Вы не в ивенте!"); 
    return 1; 
}

CMD:hel_progress(playerid) 
{ 
    if(HEL_PlayerInEvent[playerid]) 
    {
        new string[256];
        format(string, sizeof(string), "ПРОГРЕСС:\n\nЗомби: %d/15\nПризраки: %d/10\nУрон боссу: %d/5000\nВремя: %d сек.", HEL_ZombieKills[playerid], HEL_GhostKills[playerid], HEL_BossDamage[playerid], gettime() - HEL_EventStartTime[playerid]);
        ShowPlayerDialog(playerid, HEL_DIALOG_PROGRESS, DIALOG_STYLE_MSGBOX, "[HEL] ПРОГРЕСС", string, "ОК", "");
    }
    else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Вы не в ивенте!");
    return 1; 
}

CMD:hel_leave(playerid) 
{ 
    if(HEL_PlayerInEvent[playerid]) 
    {
        ShowPlayerDialog(playerid, HEL_DIALOG_LEAVE, DIALOG_STYLE_MSGBOX, "[HEL] Выход", "Вы уверены?", "Да", "Нет");
    }
    else SendClientMessage(playerid, 0xFF0000AA, "[HEL] Вы не в ивенте!");
    return 1; 
}

CMD:hel_help(playerid) 
{
    SendClientMessage(playerid, 0xFFFF00AA, "=== HEL КОМАНДЫ ===");
    SendClientMessage(playerid, 0xFFFFFFAA, "/hel_progress - Прогресс");
    SendClientMessage(playerid, 0xFFFFFFAA, "/hel_shop - Магазин");
    SendClientMessage(playerid, 0xFFFFFFAA, "/hel_leave - Выйти");
    SendClientMessage(playerid, 0x00FF00AA, "/hel_start - Запустить");
    return 1;
}

// ==================== ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ ====================
HEL_FormatNumber(number)
{
    new string[32];
    format(string, sizeof(string), "%d", number);
    for(new i = strlen(string) - 3; i > 0; i -= 3) strins(string, ",", i);
    return string;
}

forward HEL_ReturnPlayer(playerid);
public HEL_ReturnPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return;
    SetPlayerPos(playerid, HEL_EventSpawns[8][0], HEL_EventSpawns[8][1], HEL_EventSpawns[8][2]);
    SetPlayerFacingAngle(playerid, HEL_EventSpawns[8][3]);
    SetPlayerWeather(playerid, 0);
    SetPlayerTime(playerid, 12, 0);
    ResetPlayerWeapons(playerid);
    SendClientMessage(playerid, 0x00FF00AA, "[HEL] Вы возвращены!");
}

HEL_ResetPlayerData(playerid)
{
    HEL_PlayerStep[playerid] = 0;
    HEL_ZombieKills[playerid] = 0;
    HEL_GhostKills[playerid] = 0;
    HEL_BossDamage[playerid] = 0;
    HEL_PlayerInEvent[playerid] = false;
    
    if(IsValidActor(HEL_HalloweenBoss)) DestroyActor(HEL_HalloweenBoss);
    HEL_HalloweenBoss = -1;
    
    for(new i = 0; i < sizeof(HEL_ZombieActors); i++) 
    {
        if(IsValidActor(HEL_ZombieActors[i])) DestroyActor(HEL_ZombieActors[i]);
        HEL_ZombieActors[i] = -1;
    }
    
    for(new i = 0; i < sizeof(HEL_GhostActors); i++) 
    {
        if(IsValidActor(HEL_GhostActors[i])) DestroyActor(HEL_GhostActors[i]);
        HEL_GhostActors[i] = -1;
    }
}

// ==================== ИНИЦИАЛИЗАЦИЯ ====================
forward HEL_AutoStart();
public HEL_AutoStart() 
{ 
    HEL_InitializeHalloweenEvent(); 
    return 1; 
}

stock HEL_Init()
{
    print("===================================");
    print(" HEL TOP Halloween Event Loaded!");
    print(" Version: 1.0 | No Decorations");
    print("===================================");
    SetTimer("HEL_AutoStart", 5000, false);
    return 1;
}

stock HEL_Exit() 
{ 
    if(HEL_CheckTimer) KillTimer(HEL_CheckTimer); 
    return 1; 
}

stock HEL_OnPlayerDeath(playerid, killerid, reason)
{
    if(killerid != INVALID_PLAYER_ID && HEL_PlayerInEvent[killerid])
    {
        if(HEL_PlayerStep[killerid] == 1)
        {
            HEL_ZombieKills[killerid]++;
            new string[128];
            format(string, sizeof(string), "[HEL] Зомби убит! %d/15", HEL_ZombieKills[killerid]);
            SendClientMessage(killerid, 0xFF4500AA, string);
        }
        else if(HEL_PlayerStep[killerid] == 2)
        {
            HEL_GhostKills[killerid]++;
            new string[128];
            format(string, sizeof(string), "[HEL] Призрак уничтожен! %d/10", HEL_GhostKills[killerid]);
            SendClientMessage(killerid, 0x00FFFFAA, string);
        }
    }
    return 1;
}

// Функция для SendClientMessage
stock HEL_SendClientMessage(playerid, color, const message[])
{
    return SendClientMessage(playerid, color, message);
}