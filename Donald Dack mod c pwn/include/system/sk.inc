#if defined _sk_inc
    #endinput
#endif
#define _sk_inc

// Переменные
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
new mysor;
new meshokcd[MAX_PLAYERS];
new conecstr[MAX_PLAYERS];

// Инициализация
stock InitSK()
{
    Create3DTextLabel("Владелец строительной компании\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 179.305343, 391.597808, 16.192012, 3);
    CreateActor(73, 179.305343, 391.597808, 16.192012);
    stroykomp = CreateDynamicSphere(179.305343, 391.597808, 16.192012, 0.9, 0, 0, -1);

    CreateActor(228, -9.116186, 1807.725463, 9.477350, 86.516845);
    Create3DTextLabel("Прораб {FFFF00}Василий\n {FFFFFF}подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, -9.116186, 1807.725463, 9.477350, 3);
    prorabb = CreateDynamicSphere(-9.116186, 1807.725463, 9.477350, 0.8, 0, 0, -1);

    Create3DTextLabel("Электрический щит\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 18.071474, 1875.481445, 9.907059, 10);
    electr = CreatePickup(1210, 23, 18.071474, 1875.481445, 9.907059, -1);

    Create3DTextLabel("Электрический щит\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 18.053916, 1875.414550, 18.907058, 10);
    electr1 = CreatePickup(1210, 23, 18.053916, 1875.414550, 18.907058, -1);

    Create3DTextLabel("Электрический щит\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 18.054027, 1875.414428, 15.407059, 10);
    electr2 = CreatePickup(1210, 23, 18.054027, 1875.414428, 15.407059, -1);

    meshok = CreatePickup(1210, 23, 44.907081, 1868.700561, 15.407059, -1);
    Create3DTextLabel("Мешок с цементом\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 44.907081, 1868.700561, 15.407059, 10);

    meshokv = CreateDynamicSphere(7.416964, 1869.525146, 15.407059, 1, 0, 0, -1);
    Create3DTextLabel("Место выгрузки мешков\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 7.416964, 1869.525146, 15.407059, 10);

    meshokdva = CreatePickup(1210, 23, 39.442390, 1868.927612, 22.407058, -1);
    Create3DTextLabel("Мешок с цементом\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 39.442390, 1868.927612, 22.407058, 10);

    meshokv2 = CreateDynamicSphere(75.329261, 1863.635009, 18.907058, 1, 0, 0, -1);
    Create3DTextLabel("Место выгрузки мешков\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 75.329261, 1863.635009, 18.907058, 10);

    meshoktri = CreatePickup(1210, 23, 7.857259, 1876.818725, 15.407059, -1);
    Create3DTextLabel("Мешок с цементом\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 7.857259, 1876.818725, 15.407059, 10);

    meshokv3 = CreateDynamicSphere(7.346275, 1869.510864, 9.907059, 1, 0, 0, -1);
    Create3DTextLabel("Место выгрузки мешков\n подойдите для {FFFF00}взаимодействия", 0xFFFFFFFF, 7.346275, 1869.510864, 9.907059, 10);

    mysor = CreatePickup(1575, 23, 79.4179980, 1836.903564, 9.408595, -1);
    return 1;
}

// Обработка пикапов
stock SK_OnPlayerPickUpPickupEx(playerid, pickupid)
{
    if(pickupid == electr)
    {
        Dialog(playerid, DIALOG_ELECTR, DIALOG_STYLE_MSGBOX, "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }
    if(pickupid == electr1)
    {
        Dialog(playerid, DIALOG_ELECTRO, DIALOG_STYLE_MSGBOX, "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }
    if(pickupid == electr2)
    {
        Dialog(playerid, DIALOG_ELECTROO, DIALOG_STYLE_MSGBOX, "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }
    if(pickupid == meshok)
    {
        Dialog(playerid, DIALOG_MESHOK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }
    if(pickupid == meshokdva)
    {
        Dialog(playerid, DIALOG_MESHOKK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }
    if(pickupid == meshoktri)
    {
        Dialog(playerid, DIALOG_MESHOKKK, DIALOG_STYLE_MSGBOX, "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }
    if(pickupid == mysor)
    {
        Dialog(playerid, DIALOG_MYSORA, DIALOG_STYLE_MSGBOX, "Строительный контейнер", "Вы привезли мусор на погрузчике, хотите его выгрузить?", "Далее", "Назад");
        return 1;
    }
    return 0;
}

// Обработка диалогов
stock SK_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_STROY)
    {
        if(response)
        {
            if(listitem == 0)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, -3.654715, 1815.037353, 9.398981, 3.0);
            }
            else if(listitem == 1)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, 1772.700439, -2505.793457, 10.815861, 3.0);
            }
            else if(listitem == 2)
            {
                stroyka[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы устроились в Строительную Компанию. Отправляйтесь на {FFFF00}стройку");
                SetPlayerCheckpoint(playerid, -2175.430664, -405.804870, 29.426282, 3.0);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_PRORAB)
    {
        if(response)
        {
            if(stroyka[playerid] == 0)
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
            else
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Следуйте на метку и начинайте работу.");
                SetPlayerCheckpoint(playerid, 18.071474, 1875.481445, 9.907059, 1);
                SetPlayerSkin(playerid, 206);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_ELECTR)
    {
        if(response)
        {
            if(!stroyka[playerid])
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не работаете на стройке");
            else
            {
                shit[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 18.053916, 1875.414550, 18.907058, 1);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_ELECTRO)
    {
        if(response)
        {
            if(!shit[playerid])
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");
            else
            {
                shittwo[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 18.054027, 1875.414428, 15.407059, 1);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_ELECTROO)
    {
        if(response)
        {
            if(!shittwo[playerid])
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");
            else
            {
                shitend[playerid] = 1;
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}1 Этап стройки {FFFF00}завершен{FFFFFF}.");
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Отправляйтесь к мешкам и начинайте переносить их.");
                TeleportFreeze(playerid, 5000);
                SetPlayerCheckpoint(playerid, 44.907081, 1868.700561, 15.407059, 1);
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
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на {FFFF00}метку{FFFFFF}.");
            SetPlayerCheckpoint(playerid, 7.416964, 1869.525146, 15.407059, 1);
            TeleportFreeze(playerid, 5000);
            meshokda[playerid] = 1;
            meshokect[playerid] = 1;
        }
        return 1;
    }
    if(dialogid == DIALOG_MESHOKK)
    {
        if(response)
        {
            if(!meshokect[playerid])
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на {FFFF00}метку{FFFFFF}.");
            SetPlayerCheckpoint(playerid, 75.329261, 1863.635009, 18.907058, 1);
            TeleportFreeze(playerid, 5000);
            meshokda[playerid] = 1;
            meshokecttri[playerid] = 1;
        }
        return 1;
    }
    if(dialogid == DIALOG_MESHOKKK)
    {
        if(response)
        {
            if(!meshokecttri[playerid])
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");
                return 1;
            }
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на {FFFF00}метку{FFFFFF}.");
            SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1);
            TeleportFreeze(playerid, 5000);
            meshokda[playerid] = 1;
        }
        return 1;
    }
    if(dialogid == DIALOG_MYSORA)
    {
        if(response)
        {
            if(!conecstr[playerid])
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}|{FFFFFF}Вы не выполнили 2 этап.");
                return 1;
            }
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}|{FFFFFF}Вы успешно выполнили стройку.");
            GivePlayerMoney(playerid, 150000);
            meshokcd[playerid] = GetTickCount() + 18000000;
            DestroyVehicle(stroykaveh[playerid]);
            SetPlayerSkinInit(playerid);
            stroyka[playerid] = 0;
        }
        return 1;
    }
    return 0;
}

// Обработка Dynamic Areas
stock SK_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == stroykomp)
    {
        if(GetPlayerLevel(playerid) >= 8)
            ShowPlayerDialog(playerid, DIALOG_STROY, DIALOG_STYLE_LIST, "Строительная компания", "Арзамас\nЮжный\nЛыткарино", "Выбрать", "Назад");
        return 1;
    }
    if(areaid == prorabb)
    {
        ShowPlayerDialog(playerid, DIALOG_PRORAB, DIALOG_STYLE_MSGBOX, "Прораб {FFFF00}Василий", "Вы желаете начать рабочий день?", "Начать", "Назад");
        return 1;
    }
    if(areaid == meshokv)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок, отправляйтесь за следующим");
        SetPlayerCheckpoint(playerid, 39.442390, 1868.927612, 22.407058, 1);
        meshokda[playerid] = 0;
        return 1;
    }
    if(areaid == meshokv2)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок, отправляйтесь за следующим");
        SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1);
        meshokda[playerid] = 0;
        return 1;
    }
    if(areaid == meshokv3)
    {
        if(!meshokda[playerid])
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}|{FFFFFF}У вас нет мешка в руках.");
            return 1;
        }
        SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок. Начинайте работу на {FFFF00}погрузчике{FFFFFF}. После, езжайте на метку.");
        meshokda[playerid] = 0;
        SetPlayerCheckpoint(playerid, 79.4179980, 1836.903564, 9.408595, 1.5);
        stroykaveh[playerid] = CreateVehicle(486, -41.542228, 1881.632202, 4.548228, 177.128326, 3, 3, -1, 1);
        PutPlayerInVehicle(playerid, stroykaveh[playerid], 0);
        conecstr[playerid] = 1;
        return 1;
    }
    return 0;
}