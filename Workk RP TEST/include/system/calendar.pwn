// ==============================================
// СИСТЕМА КАЛЕНДАРЯ СОБЫТИЙ (ПОЛНАЯ ВЕРСИЯ)
// ==============================================

// ---------- ПЕРЕМЕННЫЕ ----------
new Text:g_CalendarTD[50];
new bool:g_CalendarVisible[MAX_PLAYERS];
new bool:g_CalendarDayStatus[MAX_PLAYERS][35];
new g_CalendarCurrentDay[MAX_PLAYERS];
new g_CalendarTimer;
new g_CalendarTimeHour = 15;
new g_CalendarTimeMinute = 14;
new g_CalendarTimeSecond = 24;
new g_CalendarRewardLevel[MAX_PLAYERS];

// ---------- ЗАГРУЗКА/СОХРАНЕНИЕ ----------
stock Calendar_LoadPlayer(playerid)
{
    for(new i = 0; i < 35; i++)
        g_CalendarDayStatus[playerid][i] = false;
    g_CalendarCurrentDay[playerid] = 0;
    g_CalendarRewardLevel[playerid] = 0;
    return 1;
}

stock Calendar_SavePlayer(playerid) { return 1; }

// ---------- СОЗДАНИЕ КАЛЕНДАРЯ ----------
stock Calendar_TextDrawLoad()
{
    // ===== СЕРЫЙ ФОН С ЧЁРНЫМ (НЕ ПРОЗРАЧНЫЙ) =====
    g_CalendarTD[0] = TextDrawCreate(50.0, 40.0, "_");
    TextDrawTextSize(g_CalendarTD[0], 720.0, 320.0);
    TextDrawAlignment(g_CalendarTD[0], 1);
    TextDrawColor(g_CalendarTD[0], 0x222222FF); // Тёмно-серый, непрозрачный
    TextDrawBackgroundColor(g_CalendarTD[0], 255);
    TextDrawFont(g_CalendarTD[0], 4);
    TextDrawSetProportional(g_CalendarTD[0], 0);
    TextDrawSetShadow(g_CalendarTD[0], 0);

    // ===== РАМКА (СЕРАЯ) =====
    g_CalendarTD[1] = TextDrawCreate(48.0, 38.0, "_");
    TextDrawTextSize(g_CalendarTD[1], 724.0, 324.0);
    TextDrawAlignment(g_CalendarTD[1], 1);
    TextDrawColor(g_CalendarTD[1], 0x888888FF);
    TextDrawBackgroundColor(g_CalendarTD[1], 255);
    TextDrawFont(g_CalendarTD[1], 4);
    TextDrawSetProportional(g_CalendarTD[1], 0);
    TextDrawSetShadow(g_CalendarTD[1], 0);

    // ===== КНОПКА МЕНЮ (КВАДРАТ В ЛЕВОМ УГЛУ) =====
    g_CalendarTD[2] = TextDrawCreate(60.0, 45.0, "МЕНЮ");
    TextDrawLetterSize(g_CalendarTD[2], 0.25, 1.2);
    TextDrawAlignment(g_CalendarTD[2], 1);
    TextDrawColor(g_CalendarTD[2], 0x00FF00FF);
    TextDrawBackgroundColor(g_CalendarTD[2], 255);
    TextDrawFont(g_CalendarTD[2], 1);
    TextDrawSetProportional(g_CalendarTD[2], 1);
    TextDrawSetShadow(g_CalendarTD[2], 0);
    TextDrawSetSelectable(g_CalendarTD[2], true);

    // ===== КНОПКА ВЫХОДА (КРЕСТИК) =====
    g_CalendarTD[3] = TextDrawCreate(735.0, 42.0, "X");
    TextDrawLetterSize(g_CalendarTD[3], 0.6, 2.2);
    TextDrawAlignment(g_CalendarTD[3], 2);
    TextDrawColor(g_CalendarTD[3], 0xFF3333FF);
    TextDrawBackgroundColor(g_CalendarTD[3], 255);
    TextDrawFont(g_CalendarTD[3], 1);
    TextDrawSetProportional(g_CalendarTD[3], 1);
    TextDrawSetShadow(g_CalendarTD[3], 0);
    TextDrawSetSelectable(g_CalendarTD[3], true);

    // ===== ЗАГОЛОВОК (ЗЕЛЁНЫЙ) =====
    g_CalendarTD[4] = TextDrawCreate(400.0, 50.0, "КАЛЕНДАРЬ СОБЫТИЯ: ПРЕДВКУШЕНИЕ");
    TextDrawLetterSize(g_CalendarTD[4], 0.4, 1.6);
    TextDrawAlignment(g_CalendarTD[4], 2);
    TextDrawColor(g_CalendarTD[4], 0x00FF00FF);
    TextDrawBackgroundColor(g_CalendarTD[4], 255);
    TextDrawFont(g_CalendarTD[4], 1);
    TextDrawSetProportional(g_CalendarTD[4], 1);
    TextDrawSetShadow(g_CalendarTD[4], 1);

    // ===== 49/49 (БЕЛЫЙ) =====
    g_CalendarTD[5] = TextDrawCreate(120.0, 80.0, "49/49");
    TextDrawLetterSize(g_CalendarTD[5], 0.3, 1.5);
    TextDrawAlignment(g_CalendarTD[5], 1);
    TextDrawColor(g_CalendarTD[5], 0xFFFFFFFF);
    TextDrawBackgroundColor(g_CalendarTD[5], 255);
    TextDrawFont(g_CalendarTD[5], 1);
    TextDrawSetProportional(g_CalendarTD[5], 1);
    TextDrawSetShadow(g_CalendarTD[5], 1);

    // ===== 15:14:24 (ЖЁЛТЫЙ) =====
    g_CalendarTD[6] = TextDrawCreate(220.0, 80.0, "15:14:24");
    TextDrawLetterSize(g_CalendarTD[6], 0.3, 1.5);
    TextDrawAlignment(g_CalendarTD[6], 1);
    TextDrawColor(g_CalendarTD[6], 0xFFFF00FF);
    TextDrawBackgroundColor(g_CalendarTD[6], 255);
    TextDrawFont(g_CalendarTD[6], 1);
    TextDrawSetProportional(g_CalendarTD[6], 1);
    TextDrawSetShadow(g_CalendarTD[6], 1);

    // ===== 35 (БЕЛЫЙ) =====
    g_CalendarTD[7] = TextDrawCreate(320.0, 80.0, "35");
    TextDrawLetterSize(g_CalendarTD[7], 0.3, 1.5);
    TextDrawAlignment(g_CalendarTD[7], 1);
    TextDrawColor(g_CalendarTD[7], 0xFFFFFFFF);
    TextDrawBackgroundColor(g_CalendarTD[7], 255);
    TextDrawFont(g_CalendarTD[7], 1);
    TextDrawSetProportional(g_CalendarTD[7], 1);
    TextDrawSetShadow(g_CalendarTD[7], 1);

    // ===== 31:48 (БЕЛЫЙ) =====
    g_CalendarTD[8] = TextDrawCreate(420.0, 80.0, "31:48");
    TextDrawLetterSize(g_CalendarTD[8], 0.3, 1.5);
    TextDrawAlignment(g_CalendarTD[8], 1);
    TextDrawColor(g_CalendarTD[8], 0xFFFFFFFF);
    TextDrawBackgroundColor(g_CalendarTD[8], 255);
    TextDrawFont(g_CalendarTD[8], 1);
    TextDrawSetProportional(g_CalendarTD[8], 1);
    TextDrawSetShadow(g_CalendarTD[8], 1);

    // ===== VIP Diamond 14 ДН. (ЗОЛОТОЙ) =====
    g_CalendarTD[9] = TextDrawCreate(90.0, 110.0, "VIP Diamond 14 ДН.");
    TextDrawLetterSize(g_CalendarTD[9], 0.22, 1.0);
    TextDrawAlignment(g_CalendarTD[9], 1);
    TextDrawColor(g_CalendarTD[9], 0xFFD700FF);
    TextDrawBackgroundColor(g_CalendarTD[9], 255);
    TextDrawFont(g_CalendarTD[9], 1);
    TextDrawSetProportional(g_CalendarTD[9], 1);
    TextDrawSetShadow(g_CalendarTD[9], 0);

    // ===== ДНИ 29-35 (КЛИКАБЕЛЬНЫЕ, ЗОЛОТЫЕ) =====
    new Float:start_x = 330.0;
    new days_vip[7][] = {"29", "30", "31", "32", "33", "34", "35"};
    for(new i = 0; i < 7; i++)
    {
        new idx = 10 + i;
        g_CalendarTD[idx] = TextDrawCreate(start_x + (i * 50.0), 110.0, days_vip[i]);
        TextDrawLetterSize(g_CalendarTD[idx], 0.22, 1.0);
        TextDrawAlignment(g_CalendarTD[idx], 1);
        TextDrawColor(g_CalendarTD[idx], 0xFFD700FF);
        TextDrawBackgroundColor(g_CalendarTD[idx], 255);
        TextDrawFont(g_CalendarTD[idx], 1);
        TextDrawSetProportional(g_CalendarTD[idx], 1);
        TextDrawSetShadow(g_CalendarTD[idx], 0);
        TextDrawSetSelectable(g_CalendarTD[idx], true);
    }

    // ===== Бонусы (БЕЛЫЙ) =====
    g_CalendarTD[17] = TextDrawCreate(90.0, 135.0, "Бонусы");
    TextDrawLetterSize(g_CalendarTD[17], 0.22, 1.0);
    TextDrawAlignment(g_CalendarTD[17], 1);
    TextDrawColor(g_CalendarTD[17], 0xFFFFFFFF);
    TextDrawBackgroundColor(g_CalendarTD[17], 255);
    TextDrawFont(g_CalendarTD[17], 1);
    TextDrawSetProportional(g_CalendarTD[17], 1);
    TextDrawSetShadow(g_CalendarTD[17], 0);

    // ===== 8 (ЖЁЛТЫЙ) =====
    g_CalendarTD[18] = TextDrawCreate(330.0, 135.0, "8");
    TextDrawLetterSize(g_CalendarTD[18], 0.22, 1.0);
    TextDrawAlignment(g_CalendarTD[18], 1);
    TextDrawColor(g_CalendarTD[18], 0xFFFF00FF);
    TextDrawBackgroundColor(g_CalendarTD[18], 255);
    TextDrawFont(g_CalendarTD[18], 1);
    TextDrawSetProportional(g_CalendarTD[18], 1);
    TextDrawSetShadow(g_CalendarTD[18], 0);

    // ===== Бронзовый (БРОНЗОВЫЙ) =====
    g_CalendarTD[19] = TextDrawCreate(90.0, 160.0, "Бронзовый");
    TextDrawLetterSize(g_CalendarTD[19], 0.22, 1.0);
    TextDrawAlignment(g_CalendarTD[19], 1);
    TextDrawColor(g_CalendarTD[19], 0xCD7F32FF);
    TextDrawBackgroundColor(g_CalendarTD[19], 255);
    TextDrawFont(g_CalendarTD[19], 1);
    TextDrawSetProportional(g_CalendarTD[19], 1);
    TextDrawSetShadow(g_CalendarTD[19], 0);

    // ===== 5 ДНЕЙ (БЕЛЫЙ) =====
    g_CalendarTD[20] = TextDrawCreate(330.0, 160.0, "5 ДНЕЙ");
    TextDrawLetterSize(g_CalendarTD[20], 0.22, 1.0);
    TextDrawAlignment(g_CalendarTD[20], 1);
    TextDrawColor(g_CalendarTD[20], 0xFFFFFFFF);
    TextDrawBackgroundColor(g_CalendarTD[20], 255);
    TextDrawFont(g_CalendarTD[20], 1);
    TextDrawSetProportional(g_CalendarTD[20], 1);
    TextDrawSetShadow(g_CalendarTD[20], 0);

    // ===== НАГРАДЫ (В РЯД, КЛИКАБЕЛЬНЫЕ) =====
    new Float:rewards_x = 70.0;
    new rewards[4][] = {"Бронзовый x2", "Серебряный", "Золотой", "Автокейс"};
    new colors[4] = {0xCD7F32FF, 0xC0C0C0FF, 0xFFD700FF, 0x00FF88FF};
    for(new i = 0; i < 4; i++)
    {
        new idx = 21 + i;
        g_CalendarTD[idx] = TextDrawCreate(rewards_x + (i * 150.0), 185.0, rewards[i]);
        TextDrawLetterSize(g_CalendarTD[idx], 0.18, 0.9);
        TextDrawAlignment(g_CalendarTD[idx], 1);
        TextDrawColor(g_CalendarTD[idx], colors[i]);
        TextDrawBackgroundColor(g_CalendarTD[idx], 255);
        TextDrawFont(g_CalendarTD[idx], 1);
        TextDrawSetProportional(g_CalendarTD[idx], 1);
        TextDrawSetShadow(g_CalendarTD[idx], 0);
        TextDrawSetSelectable(g_CalendarTD[idx], true);
    }

    // ===== НОВЫЙ СЕЗОН! (ОРАНЖЕВЫЙ) =====
    g_CalendarTD[25] = TextDrawCreate(90.0, 210.0, "НОВЫЙ СЕЗОН!");
    TextDrawLetterSize(g_CalendarTD[25], 0.25, 1.2);
    TextDrawAlignment(g_CalendarTD[25], 1);
    TextDrawColor(g_CalendarTD[25], 0xFF6600FF);
    TextDrawBackgroundColor(g_CalendarTD[25], 255);
    TextDrawFont(g_CalendarTD[25], 1);
    TextDrawSetProportional(g_CalendarTD[25], 1);
    TextDrawSetShadow(g_CalendarTD[25], 0);
    TextDrawSetSelectable(g_CalendarTD[25], true);

    // ===== BLACK PASS (ЧЁРНЫЙ) =====
    g_CalendarTD[26] = TextDrawCreate(330.0, 210.0, "BLACK PASS");
    TextDrawLetterSize(g_CalendarTD[26], 0.25, 1.2);
    TextDrawAlignment(g_CalendarTD[26], 1);
    TextDrawColor(g_CalendarTD[26], 0x333333FF);
    TextDrawBackgroundColor(g_CalendarTD[26], 255);
    TextDrawFont(g_CalendarTD[26], 1);
    TextDrawSetProportional(g_CalendarTD[26], 1);
    TextDrawSetShadow(g_CalendarTD[26], 0);
    TextDrawSetSelectable(g_CalendarTD[26], true);

    // ===== BMW MS SAKURA (ЗЕЛЁНЫЙ) =====
    g_CalendarTD[27] = TextDrawCreate(90.0, 235.0, "BMW MS SAKURA");
    TextDrawLetterSize(g_CalendarTD[27], 0.25, 1.2);
    TextDrawAlignment(g_CalendarTD[27], 1);
    TextDrawColor(g_CalendarTD[27], 0x00FF88FF);
    TextDrawBackgroundColor(g_CalendarTD[27], 255);
    TextDrawFont(g_CalendarTD[27], 1);
    TextDrawSetProportional(g_CalendarTD[27], 1);
    TextDrawSetShadow(g_CalendarTD[27], 0);
    TextDrawSetSelectable(g_CalendarTD[27], true);

    // ===== YELLOW (ЖЁЛТЫЙ) =====
    g_CalendarTD[28] = TextDrawCreate(90.0, 260.0, "YELLOW");
    TextDrawLetterSize(g_CalendarTD[28], 0.25, 1.2);
    TextDrawAlignment(g_CalendarTD[28], 1);
    TextDrawColor(g_CalendarTD[28], 0xFFFF00FF);
    TextDrawBackgroundColor(g_CalendarTD[28], 255);
    TextDrawFont(g_CalendarTD[28], 1);
    TextDrawSetProportional(g_CalendarTD[28], 1);
    TextDrawSetShadow(g_CalendarTD[28], 0);
    TextDrawSetSelectable(g_CalendarTD[28], true);

    // ===== X2 (ЖЁЛТЫЙ) =====
    g_CalendarTD[29] = TextDrawCreate(330.0, 260.0, "X2");
    TextDrawLetterSize(g_CalendarTD[29], 0.3, 1.5);
    TextDrawAlignment(g_CalendarTD[29], 1);
    TextDrawColor(g_CalendarTD[29], 0xFFFF00FF);
    TextDrawBackgroundColor(g_CalendarTD[29], 255);
    TextDrawFont(g_CalendarTD[29], 1);
    TextDrawSetProportional(g_CalendarTD[29], 1);
    TextDrawSetShadow(g_CalendarTD[29], 0);
    TextDrawSetSelectable(g_CalendarTD[29], true);

    return 1;
}

// ---------- ПОКАЗАТЬ/СКРЫТЬ ----------
stock Calendar_Show(playerid)
{
    if(g_CalendarVisible[playerid]) return;
    
    // Скрываем чат
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
    
    for(new i = 0; i < 30; i++)
    {
        TextDrawShowForPlayer(playerid, g_CalendarTD[i]);
    }
    
    g_CalendarVisible[playerid] = true;
    SelectTextDraw(playerid, 0x00FF00FF);
}

stock Calendar_Hide(playerid)
{
    if(!g_CalendarVisible[playerid]) return;
    
    // Показываем чат обратно
    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
    
    for(new i = 0; i < 30; i++)
    {
        TextDrawHideForPlayer(playerid, g_CalendarTD[i]);
    }
    
    g_CalendarVisible[playerid] = false;
    CancelSelectTextDraw(playerid);
}

// ---------- ПОЛУЧЕНИЕ НАГРАДЫ ----------
stock Calendar_GiveReward(playerid, day)
{
    if(day < 0 || day >= 35) return 0;
    
    if(g_CalendarDayStatus[playerid][day])
    {
        SendClientMessage(playerid, -1, ""USC" Вы уже получили награду за этот день!");
        return 0;
    }
    
    if(day > g_CalendarCurrentDay[playerid])
    {
        SendClientMessage(playerid, -1, ""USC" Этот день ещё не доступен!");
        return 0;
    }
    
    g_CalendarDayStatus[playerid][day] = true;
    g_CalendarRewardLevel[playerid]++;
    
    new str[128];
    if(day >= 0 && day <= 28)
    {
        GivePlayerMoneyEx(playerid, 1000);
        format(str, sizeof(str), ""SC" Вы получили 1000 рублей за день "we_c"%d!", day + 1);
    }
    else
    {
        GivePlayerMoneyEx(playerid, 5000);
        format(str, sizeof(str), ""SC" Вы получили VIP Diamond на 14 дней за день "we_c"%d!", day + 1);
    }
    SendClientMessage(playerid, -1, str);
    return 1;
}

// ---------- КОМАНДЫ ----------
CMD:calendar(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return SendClientMessage(playerid, -1, "Вы не авторизованы");
    Calendar_LoadPlayer(playerid);
    Calendar_Show(playerid);
    return 1;
}

CMD:playercad(playerid, params[])
{
    if(!IsPlayerLogged(playerid)) return SendClientMessage(playerid, -1, "Вы не авторизованы");
    
    new str[128];
    format(str, sizeof(str),
        ""we_c"| {FFFFFF}Времени до закрытия календаря: {FFD700}%02d:%02d:%02d",
        g_CalendarTimeHour, g_CalendarTimeMinute, g_CalendarTimeSecond
    );
    SendClientMessage(playerid, -1, str);
    return 1;
}

// ---------- ТАЙМЕР ----------
forward Calendar_Update();
public Calendar_Update()
{
    static count = 0;
    count++;
    
    if(g_CalendarTimeSecond > 0)
    {
        g_CalendarTimeSecond--;
    }
    else
    {
        g_CalendarTimeSecond = 59;
        if(g_CalendarTimeMinute > 0)
        {
            g_CalendarTimeMinute--;
        }
        else
        {
            g_CalendarTimeMinute = 59;
            if(g_CalendarTimeHour > 0)
            {
                g_CalendarTimeHour--;
            }
            else
            {
                // Таймер закончился - выдаём уровень каждые 10 минут
                if(count % 600 == 0)
                {
                    for(new i = 0; i < MAX_PLAYERS; i++)
                    {
                        if(IsPlayerConnected(i) && IsPlayerLogged(i))
                        {
                            SetPlayerScore(i, GetPlayerScore(i) + 1);
                            SendClientMessage(i, -1, ""SC" Календарь завершён! Вы получили +1 уровень!");
                        }
                    }
                }
                return 1;
            }
        }
    }
    return 1;
}

// ---------- КЛИКИ ----------
forward Calendar_OnPlayerClickTextDraw(playerid, Text:clickedid);
public Calendar_OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(!g_CalendarVisible[playerid]) return 0;
    
    // КНОПКА МЕНЮ (СЛЕВА)
    if(clickedid == g_CalendarTD[2])
    {
        Calendar_Hide(playerid);
        return 1;
    }
    
    // КНОПКА ЗАКРЫТЬ (КРЕСТИК)
    if(clickedid == g_CalendarTD[3])
    {
        Calendar_Hide(playerid);
        return 1;
    }
    
    // ДНИ 29-35
    for(new i = 0; i < 7; i++)
    {
        if(clickedid == g_CalendarTD[10 + i])
        {
            new day = 29 + i;
            Calendar_GiveReward(playerid, day);
            return 1;
        }
    }
    
    // Бронзовый x2
    if(clickedid == g_CalendarTD[21])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}Бронзовый x2 - бонус за 5 дней");
        return 1;
    }
    
    // Серебряный
    if(clickedid == g_CalendarTD[22])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}Серебряный бонус");
        return 1;
    }
    
    // Золотой
    if(clickedid == g_CalendarTD[23])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}Золотой бонус");
        return 1;
    }
    
    // Автокейс
    if(clickedid == g_CalendarTD[24])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}Автокейс - случайный автомобиль");
        return 1;
    }
    
    // НОВЫЙ СЕЗОН!
    if(clickedid == g_CalendarTD[25])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}НОВЫЙ СЕЗОН! BLACK PASS");
        return 1;
    }
    
    // BLACK PASS
    if(clickedid == g_CalendarTD[26])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}BLACK PASS - новый сезон");
        return 1;
    }
    
    // BMW MS SAKURA
    if(clickedid == g_CalendarTD[27])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}BMW MS SAKURA - эксклюзивный автомобиль");
        return 1;
    }
    
    // YELLOW X2
    if(clickedid == g_CalendarTD[28] || clickedid == g_CalendarTD[29])
    {
        SendClientMessage(playerid, -1, ""we_c"| {FFFFFF}YELLOW X2 - двойной опыт");
        return 1;
    }
    
    return 0;
}

// ---------- ИНИЦИАЛИЗАЦИЯ ----------
stock Calendar_OnGameModeInit()
{
    Calendar_TextDrawLoad();
    g_CalendarTimer = SetTimer("Calendar_Update", 1000, true);
    return 1;
}

// ---------- ПРИ ВЫХОДЕ ----------
forward Calendar_OnPlayerDisconnect(playerid, reason);
public Calendar_OnPlayerDisconnect(playerid, reason)
{
    if(g_CalendarVisible[playerid])
    {
        Calendar_Hide(playerid);
    }
    Calendar_SavePlayer(playerid);
    return 1;
}

// ---------- ПРИ ВХОДЕ ----------
forward Calendar_OnPlayerConnect(playerid);
public Calendar_OnPlayerConnect(playerid)
{
    Calendar_LoadPlayer(playerid);
    return 1;
}