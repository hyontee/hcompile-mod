/*
================================================================================
                        АВТОШКОЛА v3.0 - РАБОЧАЯ
================================================================================
*/

#include <a_samp>
#include <streamer>

// ============================================================================
// КОНСТАНТЫ
// ============================================================================
#define MAX_QUESTIONS 30
#define MAX_LICENSE_CATEGORIES 3
#define MAX_ROUTE_POINTS 10

// Диалоги
#define DIALOG_LICENSE_MAIN 4000
#define DIALOG_LICENSE_THEORY 4001
#define DIALOG_LICENSE_RESULT 4002
#define DIALOG_LICENSE_STATS 4003
#define DIALOG_LICENSE_PRACTICE 4004

// Категории
#define LICENSE_CAT_A 0
#define LICENSE_CAT_B 1
#define LICENSE_CAT_C 2

// ============================================================================
// ПЕРЕМЕННЫЕ
// ============================================================================

// Вопросы [Вопрос, Ответ1, Ответ2, Ответ3, Ответ4, Правильный(0-3)]
new g_Questions[MAX_QUESTIONS][6] = 
{
    {"Что означает красный сигнал светофора?", "Стоп", "Ехать", "Приготовиться", "Ждать", 0},
    {"Можно ли проезжать на красный свет?", "Нет", "Да", "Только ночью", "Если нет машин", 0},
    {"Что нужно делать при ДТП?", "Остановиться", "Уехать", "Позвонить другу", "Ничего", 0},
    {"Можно ли пить алкоголь за рулем?", "Нет", "Да", "Можно немного", "Только пиво", 0},
    {"Что такое ремень безопасности?", "Фиксатор", "Украшение", "Не нужен", "Только для детей", 0},
    {"Можно ли разговаривать по телефону за рулем?", "Только через гарнитуру", "Да", "Нет", "Можно всегда", 0},
    {"Что нужно делать перед поворотом?", "Включить поворотник", "Сигналить", "Ускориться", "Остановиться", 0},
    {"Кто главный на дороге?", "Пешеходы", "Водители", "Полиция", "Все равны", 0},
    {"Можно ли парковаться на газоне?", "Нет", "Да", "Только ночью", "Если нет мест", 0},
    {"Что такое выделенная полоса?", "Для автобусов", "Для велосипедов", "Для пешеходов", "Для всех", 0},
    {"Можно ли обгонять на перекрестке?", "Нет", "Да", "Только слева", "Только справа", 0},
    {"Что означает мигающий зеленый?", "Скоро красный", "Можно ехать", "Остановиться", "Уступить", 0},
    {"Можно ли выезжать на встречную?", "Нет", "Да", "Только при обгоне", "Только ночью", 0},
    {"Что нужно делать на пешеходном переходе?", "Уступить", "Сигналить", "Ускориться", "Ничего", 0},
    {"Можно ли перевозить детей без кресла?", "Нет", "Да", "Только маленьких", "Только больших", 0},
    {"Что такое тормозной путь?", "Расстояние до остановки", "Время до остановки", "Скорость торможения", "Ничего", 0},
    {"Как влияет дождь на дорогу?", "Увеличивает тормозной путь", "Уменьшает", "Не влияет", "Улучшает сцепление", 0},
    {"Можно ли ехать с неисправными фарами?", "Нет", "Да", "Только днем", "Только в городе", 0},
    {"Что такое аптечка?", "Набор медикаментов", "Аппарат", "Лекарство", "Медицинская книга", 0},
    {"Где должен быть огнетушитель?", "В салоне", "В багажнике", "Под капотом", "На крыше", 0},
    {"Можно ли перевозить животных без переноски?", "Нет", "Да", "Только кошек", "Только собак", 0},
    {"Что означает знак Кирпич?", "Въезд запрещен", "Выезд запрещен", "Стоянка запрещена", "Остановка запрещена", 0},
    {"Можно ли тонировать стекла?", "Да, по ГОСТу", "Нет", "Можно любые", "Только передние", 0},
    {"Что нужно сделать при аварии?", "Включить аварийку", "Уехать", "Позвонить другу", "Ничего", 0},
    {"Можно ли пересекать сплошную?", "Нет", "Да", "При обгоне", "При повороте", 0},
    {"Что такое дворники?", "Стеклоочистители", "Дворники", "Щетки", "Тряпки", 0},
    {"Можно ли ездить без прав?", "Нет", "Да", "Если учишься", "Только в поле", 0},
    {"Что нужно делать в тумане?", "Включить противотуманки", "Ехать быстрее", "Сигналить", "Ничего", 0},
    {"Можно ли парковаться под знаком?", "Зависит от знака", "Да", "Нет", "Только ночью", 0},
    {"Где должна быть аптечка?", "В легкодоступном месте", "В багажнике", "Под сиденьем", "На крыше", 0}
};

// Данные игроков
new g_PlayerLicense[MAX_PLAYERS][3];
new g_PlayerTest[MAX_PLAYERS];
new g_PlayerCategory[MAX_PLAYERS];
new g_PlayerQuestion[MAX_PLAYERS];
new g_PlayerScore[MAX_PLAYERS];
new g_TestQuestions[MAX_PLAYERS][10];
new g_ExamVehicle[MAX_PLAYERS];
new g_ExamCP[MAX_PLAYERS][MAX_ROUTE_POINTS];
new g_ExamCurrentPoint[MAX_PLAYERS];
new g_ExamTimer[MAX_PLAYERS];
new g_ExamStarted[MAX_PLAYERS];

// Координаты для экзаменов
new Float:g_StartPos[3][4] = 
{
    {-610.0, -290.0, 798.0, 0.0}, // A
    {-593.0, -291.0, 798.0, 0.0}, // B
    {-600.0, -295.0, 798.0, 0.0}  // C
};

// Маршруты
new Float:g_Route[3][MAX_ROUTE_POINTS][3] =
{
    {
        {-610.0, -290.0, 798.0},
        {-620.0, -290.0, 798.0},
        {-630.0, -290.0, 798.0},
        {-630.0, -300.0, 798.0},
        {-620.0, -300.0, 798.0},
        {-610.0, -300.0, 798.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0}
    },
    {
        {-593.0, -291.0, 798.0},
        {-603.0, -291.0, 798.0},
        {-613.0, -291.0, 798.0},
        {-613.0, -301.0, 798.0},
        {-603.0, -301.0, 798.0},
        {-593.0, -301.0, 798.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0}
    },
    {
        {-600.0, -295.0, 798.0},
        {-610.0, -295.0, 798.0},
        {-620.0, -295.0, 798.0},
        {-620.0, -305.0, 798.0},
        {-610.0, -305.0, 798.0},
        {-600.0, -305.0, 798.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0},
        {0.0, 0.0, 0.0}
    }
};

new g_ExamZones[3];
new g_LicensePrices[3] = {5000, 10000, 15000};
new g_LicenseNames[3][15] = {"A (Мотоцикл)", "B (Легковой)", "C (Грузовой)"};
new g_VehicleModels[3] = {481, 445, 403};

// ============================================================================
// FORWARD
// ============================================================================
forward ExamTimerCheck();
forward ShowQuestion(playerid);
forward StartPractice(playerid, category);
forward EndPractice(playerid, bool:passed);

// ============================================================================
// ФУНКЦИИ
// ============================================================================

stock GetCategoryName(category)
{
    return g_LicenseNames[category];
}

stock GetLicensePrice(category)
{
    return g_LicensePrices[category];
}

stock HasLicense(playerid, category)
{
    return g_PlayerLicense[playerid][category];
}

// ============================================================================
// OnGameModeInit
// ============================================================================

public OnGameModeInit()
{
    print("=====================================");
    print("   АВТОШКОЛА v3.0 ЗАГРУЖЕНА");
    print("=====================================");
    
    // Создаем зоны для экзаменов
    g_ExamZones[LICENSE_CAT_A] = CreateDynamicSphere(-610.0, -290.0, 798.0, 2.0);
    g_ExamZones[LICENSE_CAT_B] = CreateDynamicSphere(-593.0, -291.0, 798.0, 2.0);
    g_ExamZones[LICENSE_CAT_C] = CreateDynamicSphere(-600.0, -295.0, 798.0, 2.0);
    
    // 3D тексты
    CreateDynamic3DTextLabel("Автошкола\nКатегория A - Мотоцикл\n/school", 0xFFEE00FF, -610.0, -290.0, 798.0, 10.0);
    CreateDynamic3DTextLabel("Автошкола\nКатегория B - Легковой\n/school", 0xFFEE00FF, -593.0, -291.0, 798.0, 10.0);
    CreateDynamic3DTextLabel("Автошкола\nКатегория C - Грузовой\n/school", 0xFFEE00FF, -600.0, -295.0, 798.0, 10.0);
    
    // Таймер для экзаменов
    SetTimer("ExamTimerCheck", 1000, true);
    
    return 1;
}

// ============================================================================
// OnPlayerEnterDynamicArea
// ============================================================================

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < 3; i++)
    {
        if(areaid == g_ExamZones[i])
        {
            new category = i;
            new dialog[512];
            
            format(dialog, sizeof(dialog),
                "{FFD700}Автошкола - Категория %s\n\n"\
                "Стоимость обучения: %d$\n\n"\
                "Выберите действие:\n"\
                "1. Сдать теорию\n"\
                "2. Сдать практику\n"\
                "3. Информация",
                GetCategoryName(category),
                GetLicensePrice(category)
            );
            
            ShowPlayerDialog(playerid, DIALOG_LICENSE_MAIN, DIALOG_STYLE_LIST, 
                "Автошкола", dialog, "Выбрать", "Закрыть");
            return 1;
        }
    }
    return 1;
}

// ============================================================================
// OnDialogResponse
// ============================================================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new category = -1;
    for(new i = 0; i < 3; i++)
    {
        if(IsPlayerInDynamicArea(playerid, g_ExamZones[i]))
        {
            category = i;
            break;
        }
    }
    
    if(dialogid == DIALOG_LICENSE_MAIN)
    {
        if(!response) return 1;
        if(category == -1) 
        {
            SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Подойдите к зоне автошколы!");
            return 1;
        }
        
        switch(listitem)
        {
            case 0: // Теория
            {
                if(HasLicense(playerid, category))
                {
                    SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть эта категория!");
                    return 1;
                }
                
                new price = GetLicensePrice(category);
                if(GetPlayerMoney(playerid) < price)
                {
                    new msg[128];
                    format(msg, sizeof(msg), "{ff2400}| {ffffff}Нужно %d$", price);
                    SendClientMessage(playerid, -1, msg);
                    return 1;
                }
                
                GivePlayerMoney(playerid, -price);
                SendClientMessage(playerid, -1, "{ffff00}| {ffffff}Оплачено! Начинаем экзамен...");
                
                new used[MAX_QUESTIONS];
                new count = 0;
                while(count < 10)
                {
                    new qid = random(MAX_QUESTIONS);
                    if(!used[qid])
                    {
                        used[qid] = 1;
                        g_TestQuestions[playerid][count] = qid;
                        count++;
                    }
                }
                
                g_PlayerTest[playerid] = 1;
                g_PlayerCategory[playerid] = category;
                g_PlayerQuestion[playerid] = 0;
                g_PlayerScore[playerid] = 0;
                
                ShowQuestion(playerid);
                return 1;
            }
            
            case 1: // Практика
            {
                if(HasLicense(playerid, category))
                {
                    SendClientMessage(playerid, -1, "{ff2400}| {ffffff}У вас уже есть эта категория!");
                    return 1;
                }
                
                if(!g_PlayerLicense[playerid][category])
                {
                    SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Сначала сдайте теорию!");
                    return 1;
                }
                
                StartPractice(playerid, category);
                return 1;
            }
            
            case 2: // Информация
            {
                new info[512];
                format(info, sizeof(info),
                    "Категория %s\n\n"\
                    "Статус: %s\n"\
                    "Цена: %d$\n\n"\
                    "Теория: 10 вопросов, 70%%\n"\
                    "Практика: пройти маршрут\n"\
                    "Время: 60 секунд",
                    GetCategoryName(category),
                    HasLicense(playerid, category) ? "{00FF00}Есть" : "{FF0000}Нет",
                    GetLicensePrice(category)
                );
                ShowPlayerDialog(playerid, DIALOG_LICENSE_RESULT, DIALOG_STYLE_MSGBOX, "Информация", info, "OK", "");
                return 1;
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_LICENSE_THEORY)
    {
        if(!response)
        {
            g_PlayerTest[playerid] = 0;
            SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы вышли из экзамена!");
            return 1;
        }
        
        new qid = g_TestQuestions[playerid][g_PlayerQuestion[playerid]];
        if(listitem == g_Questions[qid][5])
        {
            g_PlayerScore[playerid]++;
            SendClientMessage(playerid, -1, "{00ff00}Правильно!");
        }
        else
        {
            new ans = g_Questions[qid][5] + 1;
            new msg[128];
            format(msg, sizeof(msg), "{ff2400}Неправильно! Правильный ответ: %s", g_Questions[qid][ans]);
            SendClientMessage(playerid, -1, msg);
        }
        
        g_PlayerQuestion[playerid]++;
        ShowQuestion(playerid);
        return 1;
    }
    
    if(dialogid == DIALOG_LICENSE_RESULT || dialogid == DIALOG_LICENSE_STATS)
    {
        return 1;
    }
    
    return 0;
}

// ============================================================================
// ФУНКЦИИ ТЕОРИИ
// ============================================================================

public ShowQuestion(playerid)
{
    if(g_PlayerQuestion[playerid] >= 10)
    {
        new score = g_PlayerScore[playerid];
        if(score >= 7)
        {
            g_PlayerLicense[playerid][g_PlayerCategory[playerid]] = 1;
            
            new msg[256];
            format(msg, sizeof(msg),
                "{00FF00}Поздравляем! Вы сдали теорию!\n\n"\
                "Баллов: %d из 10\n"\
                "Категория: %s\n\n"\
                "Теперь сдайте практику!",
                score, GetCategoryName(g_PlayerCategory[playerid])
            );
            
            ShowPlayerDialog(playerid, DIALOG_LICENSE_RESULT, DIALOG_STYLE_MSGBOX, 
                "Результат", msg, "OK", "");
            
            new reward = GetLicensePrice(g_PlayerCategory[playerid]) * 2;
            GivePlayerMoney(playerid, reward);
            
            new rewardMsg[128];
            format(rewardMsg, sizeof(rewardMsg), "{ffff00}| {ffffff}Бонус за сдачу: %d$", reward);
            SendClientMessage(playerid, -1, rewardMsg);
        }
        else
        {
            new msg[256];
            format(msg, sizeof(msg),
                "{FF0000}Вы не сдали теорию!\n\n"\
                "Баллов: %d из 10\n"\
                "Нужно: 7 баллов (70%%)\n\n"\
                "Попробуйте снова через 10 минут.",
                score
            );
            
            ShowPlayerDialog(playerid, DIALOG_LICENSE_RESULT, DIALOG_STYLE_MSGBOX, 
                "Результат", msg, "OK", "");
                
            GivePlayerMoney(playerid, -500);
            SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Штраф за провал: 500$");
        }
        
        g_PlayerTest[playerid] = 0;
        return;
    }
    
    new qid = g_TestQuestions[playerid][g_PlayerQuestion[playerid]];
    new dialog[512];
    
    format(dialog, sizeof(dialog),
        "Вопрос %d/10\n\n"\
        "{FFFFFF}%s\n\n"\
        "{FFB6C1}1. %s\n"\
        "{87CEEB}2. %s\n"\
        "{98FB98}3. %s\n"\
        "{FFD700}4. %s\n\n"\
        "{FFFFFF}Баллов: %d",
        g_PlayerQuestion[playerid] + 1,
        g_Questions[qid][0],
        g_Questions[qid][1],
        g_Questions[qid][2],
        g_Questions[qid][3],
        g_Questions[qid][4],
        g_PlayerScore[playerid]
    );
    
    ShowPlayerDialog(playerid, DIALOG_LICENSE_THEORY, DIALOG_STYLE_LIST, 
        "Экзамен ПДД", dialog, "Выбрать", "Выход");
}

// ============================================================================
// ФУНКЦИИ ПРАКТИКИ
// ============================================================================

public StartPractice(playerid, category)
{
    new Float:x = g_StartPos[category][0];
    new Float:y = g_StartPos[category][1];
    new Float:z = g_StartPos[category][2];
    new Float:a = g_StartPos[category][3];
    
    new veh = CreateVehicle(g_VehicleModels[category], x, y, z, a, -1, -1, -1);
    g_ExamVehicle[playerid] = veh;
    
    PutPlayerInVehicle(playerid, veh, 0);
    
    // Создаем чекпоинты
    new routeSize = MAX_ROUTE_POINTS;
    for(new i = 0; i < routeSize; i++)
    {
        if(g_Route[category][i][0] == 0.0 && g_Route[category][i][1] == 0.0 && g_Route[category][i][2] == 0.0)
            break;
            
        g_ExamCP[playerid][i] = CreateDynamicCP(
            g_Route[category][i][0],
            g_Route[category][i][1],
            g_Route[category][i][2],
            3.0,
            -1, -1, playerid
        );
    }
    
    g_ExamCurrentPoint[playerid] = 0;
    g_ExamTimer[playerid] = 60;
    g_ExamStarted[playerid] = 1;
    
    SetPlayerCheckpoint(playerid,
        g_Route[category][0][0],
        g_Route[category][0][1],
        g_Route[category][0][2],
        3.0
    );
    
    SendClientMessage(playerid, -1, "{ffff00}| {ffffff}Практика началась!");
    SendClientMessage(playerid, -1, "{ffff00}| {ffffff}Следуйте за чекпоинтами. Время: 60 сек.");
    SendClientMessage(playerid, -1, "{ffff00}| {ffffff}Не выходите из машины!");
}

public ExamTimerCheck()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!g_ExamStarted[i]) continue;
        
        g_ExamTimer[i]--;
        
        if(g_ExamTimer[i] % 10 == 0 && g_ExamTimer[i] > 0)
        {
            new msg[64];
            format(msg, sizeof(msg), "~y~Время: ~w~%d сек.", g_ExamTimer[i]);
            GameTextForPlayer(i, msg, 1000, 3);
        }
        
        if(g_ExamTimer[i] <= 0)
        {
            EndPractice(i, false);
            SendClientMessage(i, -1, "{ff2400}| {ffffff}Время вышло! Экзамен провален.");
        }
        
        if(!IsPlayerInAnyVehicle(i))
        {
            EndPractice(i, false);
            SendClientMessage(i, -1, "{ff2400}| {ffffff}Вы вышли из машины! Экзамен провален.");
        }
    }
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    for(new i = 0; i < MAX_ROUTE_POINTS; i++)
    {
        if(g_ExamCP[playerid][i] == checkpointid)
        {
            if(!g_ExamStarted[playerid]) return 1;
            
            new current = g_ExamCurrentPoint[playerid] + 1;
            new category = g_PlayerCategory[playerid];
            
            DisablePlayerCheckpoint(playerid);
            g_ExamCurrentPoint[playerid] = current;
            
            // Проверяем, есть ли следующая точка
            if(g_Route[category][current][0] == 0.0 && g_Route[category][current][1] == 0.0 && g_Route[category][current][2] == 0.0)
            {
                EndPractice(playerid, true);
                SendClientMessage(playerid, -1, "{00ff00}Поздравляем! Вы прошли маршрут!");
            }
            else
            {
                SetPlayerCheckpoint(playerid,
                    g_Route[category][current][0],
                    g_Route[category][current][1],
                    g_Route[category][current][2],
                    3.0
                );
                
                new msg[64];
                format(msg, sizeof(msg), "{ffff00}| {ffffff}Точка %d пройдена", current+1);
                SendClientMessage(playerid, -1, msg);
            }
            return 1;
        }
    }
    return 1;
}

public EndPractice(playerid, bool:passed)
{
    g_ExamStarted[playerid] = 0;
    
    if(IsValidVehicle(g_ExamVehicle[playerid]))
        DestroyVehicle(g_ExamVehicle[playerid]);
    
    for(new i = 0; i < MAX_ROUTE_POINTS; i++)
    {
        if(g_ExamCP[playerid][i] != -1)
        {
            DestroyDynamicCP(g_ExamCP[playerid][i]);
            g_ExamCP[playerid][i] = -1;
        }
    }
    
    DisablePlayerCheckpoint(playerid);
    
    if(passed)
    {
        new category = g_PlayerCategory[playerid];
        g_PlayerLicense[playerid][category] = 1;
        
        SendClientMessage(playerid, -1, "{00ff00}Поздравляем! Вы получили права!");
        
        new msg[128];
        format(msg, sizeof(msg), "Категория %s", GetCategoryName(category));
        SendClientMessage(playerid, -1, msg);
        
        new reward = GetLicensePrice(category) * 2;
        GivePlayerMoney(playerid, reward);
        
        format(msg, sizeof(msg), "{ffff00}| {ffffff}Бонус: %d$", reward);
        SendClientMessage(playerid, -1, msg);
        
        SetPlayerPos(playerid, g_StartPos[category][0], g_StartPos[category][1], g_StartPos[category][2] + 2);
    }
    else
    {
        SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Экзамен провален. Попробуйте снова!");
        GivePlayerMoney(playerid, -500);
        SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Штраф: 500$");
        
        SetPlayerPos(playerid, g_StartPos[g_PlayerCategory[playerid]][0], 
            g_StartPos[g_PlayerCategory[playerid]][1], 
            g_StartPos[g_PlayerCategory[playerid]][2] + 2);
    }
}

// ============================================================================
// КОМАНДЫ
// ============================================================================

CMD:school(playerid)
{
    new found = 0;
    for(new i = 0; i < 3; i++)
    {
        if(IsPlayerInDynamicArea(playerid, g_ExamZones[i]))
        {
            found = 1;
            break;
        }
    }
    
    if(!found)
    {
        SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Подойдите к зданию автошколы!");
        SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Координаты: -593, -291, 798");
        return 1;
    }
    
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFD700}Добро пожаловать в автошколу!\n\n"\
        "Выберите действие:\n"\
        "1. Получить права\n"\
        "2. Мои права\n"\
        "3. Информация\n\n"\
        "Доступные категории:\n"\
        "A - Мотоцикл (%d$)\n"\
        "B - Легковой (%d$)\n"\
        "C - Грузовой (%d$)",
        GetLicensePrice(LICENSE_CAT_A),
        GetLicensePrice(LICENSE_CAT_B),
        GetLicensePrice(LICENSE_CAT_C)
    );
    
    ShowPlayerDialog(playerid, DIALOG_LICENSE_STATS, DIALOG_STYLE_LIST, 
        "Автошкола", dialog, "Выбрать", "Закрыть");
    return 1;
}

CMD:licenses(playerid)
{
    new dialog[512];
    format(dialog, sizeof(dialog),
        "{FFD700}Мои права\n\n"\
        "Категория A (Мотоцикл): %s\n"\
        "Категория B (Легковой): %s\n"\
        "Категория C (Грузовой): %s\n\n"\
        "Итого прав: %d\n\n"\
        "Команда: /school - автошкола",
        g_PlayerLicense[playerid][LICENSE_CAT_A] ? "{00FF00}Есть" : "{FF0000}Нет",
        g_PlayerLicense[playerid][LICENSE_CAT_B] ? "{00FF00}Есть" : "{FF0000}Нет",
        g_PlayerLicense[playerid][LICENSE_CAT_C] ? "{00FF00}Есть" : "{FF0000}Нет",
        g_PlayerLicense[playerid][LICENSE_CAT_A] + 
        g_PlayerLicense[playerid][LICENSE_CAT_B] + 
        g_PlayerLicense[playerid][LICENSE_CAT_C]
    );
    
    ShowPlayerDialog(playerid, DIALOG_LICENSE_STATS, DIALOG_STYLE_MSGBOX, 
        "Права", dialog, "OK", "");
    return 1;
}

// ============================================================================
// ОЧИСТКА ДАННЫХ
// ============================================================================

public OnPlayerDisconnect(playerid, reason)
{
    if(g_ExamStarted[playerid])
    {
        EndPractice(playerid, false);
    }
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(g_ExamStarted[playerid])
    {
        EndPractice(playerid, false);
        SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Вы умерли! Экзамен провален.");
    }
    return 1;
}