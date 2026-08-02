/*
// ============================================================
СИСТЕМА BR COPY %70 WORK

АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp

ЕСЛИ ТЫ СМЕНИШЬ АВТОРА СИСТЕМЫ ТЫ НИЩИЙ И БУДЕШЬ ННОМ 

ПЕРЕСИЛИЛ БЛЕЙН x WEST
купить систему любую писать мне @west_dev

АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne

// ============================================================
*/

// -------------------- ПЕРЕМЕННЫЕ (ВСТАВИТЬ В НАЧАЛО МОДА) --------------------
new stroykomp;
new prorabb;
new stroyka[MAX_PLAYERS];
new electr;
new electr1;
new shit[MAX_PLAYERS];
new electr2;
new shittwo[MAX_PLAYERS];
new shitend[MAX_PLAYERS];
new meshok;
new meshokda[MAX_PLAYERS];
new meshokv;
new meshokdva;
new meshokv2;
new meshokect[MAX_PLAYERS];
new meshokecttri[MAX_PLAYERS];
new meshoktri;
new meshokv3;
new stroykaveh[MAX_PLAYERS];
new meshokcd[MAX_PLAYERS];
new conecstr[MAX_PLAYERS];
new mysor;
new stroy_timer[MAX_PLAYERS];
new stroy_seconds[MAX_PLAYERS];
new Text3D:stroy_label[MAX_PLAYERS];
new PlayerText:StroyTimerTD[MAX_PLAYERS];

// -------------------- ДИАЛОГИ (ВСТАВИТЬ ПОСЛЕ ПЕРЕМЕННЫХ) --------------------
#define DIALOG_STROY 2000
#define DIALOG_PRORAB 2001
#define DIALOG_ELECTR 2002
#define DIALOG_ELECTRO 2003
#define DIALOG_ELECTROO 2004
#define DIALOG_MESHOK 2005
#define DIALOG_MESHOKK 2006
#define DIALOG_MESHOKKK 2007
#define DIALOG_MYSORA 2008

// -------------------- ОПРЕДЕЛЕНИЯ ДЛЯ ИНВАЛИДОВ --------------------
#define INVALID_PLAYER_TEXT_DRAW PlayerText:0xFFFF
#define INVALID_3D_TEXT_ID Text3D:0xFFFF

// ============================================
// ТЕКСТДРАВ ТАЙМЕР (ТОЛЬКО ЦИФРЫ)
// ============================================
stock Stroy_ShowTimer(playerid, seconds)
{
    new string[8];
    format(string, sizeof(string), "%d", seconds);
    
    StroyTimerTD[playerid] = CreatePlayerTextDraw(playerid, 320.0, 210.0, string);
    PlayerTextDrawLetterSize(playerid, StroyTimerTD[playerid], 2.5, 5.0);
    PlayerTextDrawAlignment(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawColor(playerid, StroyTimerTD[playerid], 0xFF0000FF);
    PlayerTextDrawBackgroundColor(playerid, StroyTimerTD[playerid], 0x00000000);
    PlayerTextDrawFont(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawSetProportional(playerid, StroyTimerTD[playerid], 1);
    PlayerTextDrawSetShadow(playerid, StroyTimerTD[playerid], 0);
    PlayerTextDrawSetOutline(playerid, StroyTimerTD[playerid], 2);
    PlayerTextDrawShow(playerid, StroyTimerTD[playerid]);
    return 1;
}

stock Stroy_UpdateTimer(playerid, seconds)
{
    new string[8];
    format(string, sizeof(string), "%d", seconds);
    PlayerTextDrawSetString(playerid, StroyTimerTD[playerid], string);
    PlayerTextDrawShow(playerid, StroyTimerTD[playerid]);
    return 1;
}

stock Stroy_HideTimer(playerid)
{
    if(StroyTimerTD[playerid] != INVALID_PLAYER_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, StroyTimerTD[playerid]);
        StroyTimerTD[playerid] = INVALID_PLAYER_TEXT_DRAW;
    }
    return 1;
}

// ============================================
// ТАЙМЕР ДЛЯ РЕМОНТА
// ============================================
forward Stroy_RepairTimer(playerid);
public Stroy_RepairTimer(playerid)
{
    stroy_seconds[playerid]--;
    
    if(stroy_seconds[playerid] <= 0)
    {
        KillTimer(stroy_timer[playerid]);
        stroy_timer[playerid] = 0;
        
        if(stroy_label[playerid] != INVALID_3D_TEXT_ID)
        {
            Delete3DTextLabel(stroy_label[playerid]);
            stroy_label[playerid] = INVALID_3D_TEXT_ID;
        }
        
        Stroy_HideTimer(playerid);
        TogglePlayerControllable(playerid, 1);
        
        // Проверяем какой щиток чиним по порядку
        if(!shit[playerid]) // Первый щиток
        {
            shit[playerid] = 1;
            GivePlayerMoney(playerid, 5000);
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно починили щиток #1! +{FF0000}5000$");
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Поднимайтесь на 2-й этаж к щитку #2");
            SetPlayerCheckpoint(playerid, 18.053916, 1875.414550, 18.907058, 1.0);
            return 1;
        }
        else if(!shittwo[playerid]) // Второй щиток
        {
            shittwo[playerid] = 1;
            GivePlayerMoney(playerid, 5000);
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно починили щиток #2! +{FF0000}5000$");
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Идите к щитку #3 на 2-м этаже");
            SetPlayerCheckpoint(playerid, 18.054027, 1875.414428, 15.407059, 1.0);
            return 1;
        }
        else if(!shitend[playerid]) // Третий щиток
        {
            shitend[playerid] = 1;
            GivePlayerMoney(playerid, 5000);
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно починили щиток #3! +{FF0000}5000$");
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}1 Этап стройки {FFFF00}завершен{FFFFFF}.");
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Отправляйтесь к мешкам с мусором на 1-й этаж");
            SetPlayerCheckpoint(playerid, 44.907081, 1868.700561, 15.407059, 1.0);
            return 1;
        }
        return 1;
    }
    
    // Обновляем таймер на экране
    Stroy_UpdateTimer(playerid, stroy_seconds[playerid]);
    return 1;
}

// ============================================
// В OnGameModeInit (ВСТАВИТЬ В КОНЕЦ OnGameModeInit)
// ============================================
/*
    // Офис - Начальник Андреевич
    Create3DTextLabel("{FFDC33}Начальник Андреевич\n\n{FFFFFF}Подойдите ближе, чтобы устроиться в строительную компанию", 0xFFFFFFFF, 179.305343, 391.597808, 16.192012, 3);
    CreateActor(34, 179.305297, 391.597808, 16.195312, 92.8);
    stroykomp = CreateDynamicSphere(179.305343, 391.597808, 16.192012, 1.0);

    // Прораб - Александр
    CreateActor(228, -9.116186, 1807.725463, 9.477350, 86.516845);
    Create3DTextLabel("{FFDC33}Прораб - Александр\n\n{FFFFFF}Подойдите для взаимодействия с Александром", 0xFFFFFFFF, -9.116186, 1807.725463, 9.477350, 3);
    prorabb = CreateDynamicSphere(-9.116186, 1807.725463, 9.477350, 1.0);

    // Щитки
    Create3DTextLabel("{FFDC33}Электрический щиток #1\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.071474, 1875.481445, 9.907059, 10);
    electr = CreatePickup(1210, 23, 18.071474, 1875.481445, 9.907059, -1);

    Create3DTextLabel("{FFDC33}Электрический щиток #2\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.053916, 1875.414550, 18.907058, 10);
    electr1 = CreatePickup(1210, 23, 18.053916, 1875.414550, 18.907058, -1);

    Create3DTextLabel("{FFDC33}Электрический щиток #3\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.054027, 1875.414428, 15.407059, 10);
    electr2 = CreatePickup(1210, 23, 18.054027, 1875.414428, 15.407059, -1);

    // Мешки с мусором
    meshok = CreatePickup(1210, 23, 44.907081, 1868.700561, 15.407059, -1);
    Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 44.907081, 1868.700561, 15.407059, 10);
    meshokv = CreateDynamicSphere(7.416964, 1869.525146, 15.407059, 1.0);
    Create3DTextLabel("{FF0000}Выгрузка мусора\n\n{FFFFFF}Подойдите ближе для взятия транспортного средства", 0xFFFFFFFF, 7.416964, 1869.525146, 15.407059, 10);

    meshokdva = CreatePickup(1210, 23, 39.442390, 1868.927612, 22.407058, -1);
    Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 39.442390, 1868.927612, 22.407058, 10);
    meshokv2 = CreateDynamicSphere(75.329261, 1863.635009, 18.907058, 1.0);
    Create3DTextLabel("{FF0000}Выгрузка мусора\n\n{FFFFFF}Подойдите ближе для взятия транспортного средства", 0xFFFFFFFF, 75.329261, 1863.635009, 18.907058, 10);

    meshoktri = CreatePickup(1210, 23, 7.857259, 1876.818725, 15.407059, -1);
    Create3DTextLabel("{A9A9A9}Мешок с мусором\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 7.857259, 1876.818725, 15.407059, 10);
    meshokv3 = CreateDynamicSphere(7.346275, 1869.510864, 9.907059, 1.0);
    Create3DTextLabel("{FF0000}Выгрузка мусора\n\n{FFFFFF}Подойдите ближе для взятия транспортного средства", 0xFFFFFFFF, 7.346275, 1869.510864, 9.907059, 10);

    // Мусорный бак
    mysor = CreatePickup(1575, 23, 79.417998, 1836.903564, 9.408595, -1);
    Create3DTextLabel("Мусорный бак\n{FFFF00}Подъезжайте для выгрузки мусора", 
        0xFFFFFFFF, 79.417998, 1836.903564, 9.408595, 10.0);
*/

// ============================================
// В OnPlayerPickUpPickupEx (ВСТАВИТЬ В КОНЕЦ)
// ============================================
/*
    if(pickupid == electr)
    {
        if(!stroyka[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
        if(shit[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы уже починили этот щиток");
        if(stroy_timer[playerid] != 0) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Подождите, вы уже чините щиток");
        
        stroy_seconds[playerid] = 10;
        stroy_timer[playerid] = SetTimerEx("Stroy_RepairTimer", 1000, true, "i", playerid);
        
        Stroy_ShowTimer(playerid, 10);
        TogglePlayerControllable(playerid, 0);
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы начали ремонт щитка #1. Осталось: {FF0000}10 {FFFFFF}секунд");
        return 1;
    }
    
    if(pickupid == electr1)
    {
        if(!stroyka[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
        if(!shit[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Сначала почините щиток #1 на 1-м этаже");
        if(shittwo[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы уже починили этот щиток");
        if(stroy_timer[playerid] != 0) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Подождите, вы уже чините щиток");
        
        stroy_seconds[playerid] = 10;
        stroy_timer[playerid] = SetTimerEx("Stroy_RepairTimer", 1000, true, "i", playerid);
        
        Stroy_ShowTimer(playerid, 10);
        TogglePlayerControllable(playerid, 0);
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы начали ремонт щитка #2. Осталось: {FF0000}10 {FFFFFF}секунд");
        return 1;
    }
    
    if(pickupid == electr2)
    {
        if(!stroyka[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
        if(!shittwo[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Сначала почините щиток #2 на 2-м этаже");
        if(shitend[playerid]) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы уже починили этот щиток");
        if(stroy_timer[playerid] != 0) return SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Подождите, вы уже чините щиток");
        
        stroy_seconds[playerid] = 10;
        stroy_timer[playerid] = SetTimerEx("Stroy_RepairTimer", 1000, true, "i", playerid);
        
        Stroy_ShowTimer(playerid, 10);
        TogglePlayerControllable(playerid, 0);
        SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы начали ремонт щитка #3. Осталось: {FF0000}10 {FFFFFF}секунд");
        return 1;
    }
    
    if(pickupid == meshok)
    {
        Dialog(playerid, DIALOG_MESHOK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок с мусором?", "Взять", "Назад");
        return 1;
    }
    if(pickupid == meshokdva)
    {
        Dialog(playerid, DIALOG_MESHOKK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок с мусором?", "Взять", "Назад");
        return 1;
    }
    if(pickupid == meshoktri)
    {
        Dialog(playerid, DIALOG_MESHOKKK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок с мусором?", "Взять", "Назад");
        return 1;
    }
    
    if(pickupid == mysor)
    {
        if(!conecstr[playerid])
        {
            SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}Вы не выполнили 2 этап.");
            return 1;
        }
        
        SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}Вы успешно выгрузили мусор и завершили работу!");
        GivePlayerMoney(playerid, 150000);
        meshokcd[playerid] = GetTickCount() + 18000000;
        
        if(stroykaveh[playerid] != 0)
        {
            DestroyVehicle(stroykaveh[playerid]);
            stroykaveh[playerid] = 0;
        }
        
        SetPlayerSkinInit(playerid);
        stroyka[playerid] = 0;
        shit[playerid] = 0;
        shittwo[playerid] = 0;
        shitend[playerid] = 0;
        meshokda[playerid] = 0;
        meshokect[playerid] = 0;
        meshokecttri[playerid] = 0;
        conecstr[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        return 1;
    }
*/

// ============================================
// В OnDialogResponse (ВСТАВИТЬ В КОНЕЦ ПЕРЕД return)
// ============================================
/*
    if(dialogid == DIALOG_STROY)
    {
        if(meshokcd[playerid] > GetTickCount())
        {
            SendClientMessage(playerid, -1, "{FFFF00} | {FFFFFF}Вы уже работали недавно, ожидайте");
            return 1;
        }
        
        if(response)
        {
            if(listitem == 0)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, -3.654715, 1815.037353, 9.398981, 3.0);
            }
            else if(listitem == 1)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, 1772.700439, -2505.793457, 10.815861, 3.0);
            }
            else if(listitem == 2)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, -2175.430664, -405.804870, 29.426282, 3.0);
            }
        }
        else
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы отказались от трудоустройства.");
        }
        return 1;
    }

    if(dialogid == DIALOG_PRORAB)
    {
        if(response)
        {
            if(stroyka[playerid] == 0)
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
            }
            else
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Следуйте на метку и начинайте работу.");
                SetPlayerCheckpoint(playerid, 18.071474,1875.481445,9.907059, 1);
                SetPlayerSkin(playerid, 206);
            }
        }
        else
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы отказались от работы.");
        }
        return 1;
    }

    if(dialogid == DIALOG_ELECTR)
    {
        if(response)
        {
            if(!stroyka[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
            }
            else
            {
                shit[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 18.053916,1875.414550,18.907058, 1);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_ELECTRO)
    {
        if(response)
        {
            if(!shit[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");
            }
            else
            {
                shittwo[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 18.054027,1875.414428,15.407059, 1);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_ELECTROO)
    {
        if(response)
        {
            if(!shittwo[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");
            }
            else
            {
                shitend[playerid] = 1;
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}1 Этап стройки {FFFF00}завершен{FFFFFF}.");
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Отправляйтесь к мешкам с мусором.");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 44.907081,1868.700561,15.407059, 1);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_MESHOK)
    {
        if(response)
        {
            if(!shitend[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            else
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке.");
                SetPlayerCheckpoint(playerid, 7.416964, 1869.525146, 15.407059, 1);
                TeleportFreeze(playerid, 5000);
                meshokda[playerid] = 1;
                meshokect[playerid] = 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_MESHOKK)
    {
        if(response)
        {
            if(!meshokect[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            else
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке.");
                SetPlayerCheckpoint(playerid, 75.329261,1863.635009,18.907058, 1);
                TeleportFreeze(playerid, 5000);
                meshokda[playerid] = 1;
                meshokecttri[playerid] = 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_MESHOKKK)
    {
        if(response)
        {
            if(!meshokecttri[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            else
            {
                SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы взяли мешок с мусором. Отнесите его по указанной метке.");
                SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1);
                TeleportFreeze(playerid, 5000);
                meshokda[playerid] = 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_MYSORA)
    {
        if(response)
        {
            if(!conecstr[playerid])
            {
                SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}Вы не выполнили 2 этап.");
                return 1;
            }
            else
            {
                SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}Вы успешно выгрузили мусор и завершили работу!");
                GivePlayerMoney(playerid, 150000);
                meshokcd[playerid] = GetTickCount() + 18000000;
                DestroyVehicle(stroykaveh[playerid]);
                SetPlayerSkinInit(playerid);
                stroyka[playerid] = 0;
                return 1;
            }
        }
        return 1;
    }
*/

// ============================================
// В OnPlayerEnterDynamicArea (ВСТАВИТЬ В КОНЕЦ)
// ============================================
/*
    if(areaid == stroykomp)
{
    if(GetPlayerLevel(playerid) >= 8)
        ShowPlayerDialog(playerid, DIALOG_STROY, DIALOG_STYLE_LIST, 
            "Строительная компания — Андреевич", 
            "Арзамас - нажмите для взаимодействия\nЮжный - нажмите для взаимодействия\nЛыткарино - нажмите для взаимодействия", 
            "Выбрать", "Назад");
    return 1;
}

    if(areaid == prorabb)
    {
        ShowPlayerDialog(playerid, DIALOG_PRORAB, DIALOG_STYLE_MSGBOX, 
            "Прораб {FFFF00}Александр", 
            "Вы желаете начать рабочий день?", 
            "Да", "Нет");
        return 1;
    }

    if(areaid == meshokv)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        else
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором, отправляйтесь за следующим.");
            SetPlayerCheckpoint(playerid, 39.442390,1868.927612,22.407058, 1);
            meshokda[playerid] = 0;
        }
        return 1;
    }

    if(areaid == meshokv2)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        else
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором, отправляйтесь за следующим.");
            SetPlayerCheckpoint(playerid, 7.346275,1869.510864,9.907059, 1);
            meshokda[playerid] = 0;
        }
        return 1;
    }

    if(areaid == meshokv3)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, -1, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        else
        {
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок с мусором.");
            SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы начали работать погрузчиком, после чего езжайте к мусорному баку.");
            meshokda[playerid] = 0;
            conecstr[playerid] = 1;
            SetPlayerCheckpoint(playerid, 79.417998, 1836.903564, 9.408595, 1.5);
            stroykaveh[playerid] = CreateVehicle(486, -41.542228, 1881.632202, 4.548228, 177.128326, 3, 3, -1, 1);
            PutPlayerInVehicle(playerid, stroykaveh[playerid], 0);
        }
        return 1;
    }
*/

// ============================================
// В OnPlayerDisconnect (ВСТАВИТЬ В КОНЕЦ)
// ============================================
/*
    if(stroy_timer[playerid] != 0)
    {
        KillTimer(stroy_timer[playerid]);
        stroy_timer[playerid] = 0;
    }
    if(stroy_label[playerid] != INVALID_3D_TEXT_ID)
    {
        Delete3DTextLabel(stroy_label[playerid]);
        stroy_label[playerid] = INVALID_3D_TEXT_ID;
    }
    
    Stroy_HideTimer(playerid);
    TogglePlayerControllable(playerid, 1);
    
    // Удаляем транспорт при выходе игрока
    if(stroykaveh[playerid] != 0)
    {
        DestroyVehicle(stroykaveh[playerid]);
        stroykaveh[playerid] = 0;
    }
    
    stroyka[playerid] = 0;
    shit[playerid] = 0;
    shittwo[playerid] = 0;
    shitend[playerid] = 0;
    meshokda[playerid] = 0;
    meshokect[playerid] = 0;
    meshokecttri[playerid] = 0;
    conecstr[playerid] = 0;
    meshokcd[playerid] = 0;
*/

/*// ============================================
// ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ (ВСТАВИТЬ В КОНЕЦ МОДА)
// ============================================
forward UnfreezePlayer(playerid);
public UnfreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
    return 1;
}

stock TeleportFreeze(playerid, time)
{
    TogglePlayerControllable(playerid, 0);
    SetTimerEx("UnfreezePlayer", time, false, "i", playerid);
    return 1;
}

stock SetPlayerSkinInit(playerid)
{
    SetPlayerSkin(playerid, 0);
    return 1;
}*/