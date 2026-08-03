/*
    СК / Строительная компания
    Адаптировано под структуру текущего мода:
    - include/system/stroyka_system.inc
    - вызовы: SK_Init, SK_HandleDynamicPickup, SK_HandleDialog, SK_HandleDynamicArea,
      SK_HandleCheckpoint, SK_ResetPlayer
    Кодировка: Windows-1251
*/

#if !defined SK_DIALOG_STROY
    #define SK_DIALOG_STROY          29500
    #define SK_DIALOG_PRORAB         29501
    #define SK_DIALOG_ELECTR         29502
    #define SK_DIALOG_ELECTRO        29503
    #define SK_DIALOG_ELECTROO       29504
    #define SK_DIALOG_MESHOK         29505
    #define SK_DIALOG_MESHOKK        29506
    #define SK_DIALOG_MESHOKKK       29507
    #define SK_DIALOG_MYSORA         29508
#endif

#if !defined SK_COLOR_WHITE
    #define SK_COLOR_WHITE           0xFFFFFFFF
    #define SK_COLOR_ERROR           0xFF6666FF
    #define SK_COLOR_INFO            0xFFFF00FF
    #define SK_COLOR_SUCCESS         0x66CC00FF
#endif

#define SK_PAY_MONEY                 150000
#define SK_WORK_COOLDOWN             18000
#define SK_JOB_MIN_LEVEL             8

new SK_AreaCompany = -1;
new SK_AreaProrab = -1;
new SK_AreaBagDrop1 = -1;
new SK_AreaBagDrop2 = -1;
new SK_AreaBagDrop3 = -1;

new SK_PickupElectr1 = -1;
new SK_PickupElectr2 = -1;
new SK_PickupElectr3 = -1;
new SK_PickupBag1 = -1;
new SK_PickupBag2 = -1;
new SK_PickupBag3 = -1;
new SK_PickupFinal = -1;

new SK_ActorOwner = INVALID_ACTOR_ID;
new SK_ActorProrab = INVALID_ACTOR_ID;


stock __KeepStroykaActorSymbolsUsed()
{
    return SK_ActorOwner + SK_ActorProrab;
}


new bool:SK_Work[MAX_PLAYERS];
new bool:SK_Shield1[MAX_PLAYERS];
new bool:SK_Shield2[MAX_PLAYERS];
new bool:SK_Shield3[MAX_PLAYERS];
new bool:SK_BagInHands[MAX_PLAYERS];
new bool:SK_BagStage1[MAX_PLAYERS];
new bool:SK_BagStage2[MAX_PLAYERS];
new bool:SK_BagStage3[MAX_PLAYERS];
new bool:SK_FinalReady[MAX_PLAYERS];
new SK_Vehicle[MAX_PLAYERS];
new SK_Cooldown[MAX_PLAYERS];

forward SK_UnfreezePlayer(playerid);
public SK_UnfreezePlayer(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        TogglePlayerControllable(playerid, true);
    }
    return 1;
}

stock SK_Freeze(playerid, time_ms = 5000)
{
    TogglePlayerControllable(playerid, false);
    SetTimerEx("SK_UnfreezePlayer", time_ms, false, "i", playerid);
    return 1;
}

stock SK_ClearBag(playerid)
{
    SK_BagInHands[playerid] = false;
    if(IsPlayerAttachedObjectSlotUsed(playerid, 8))
    {
        RemovePlayerAttachedObject(playerid, 8);
    }
    return 1;
}

stock SK_GiveBag(playerid)
{
    SK_BagInHands[playerid] = true;
    SetPlayerAttachedObject(playerid, 8, 2060, 1, 0.172000, 0.486000, -0.018000, 0.000000, 84.000000, 0.000000, 0.711000, 0.599000, 0.557000);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
    return 1;
}

stock SK_ResetPlayer(playerid)
{
    SK_Work[playerid] = false;
    SK_Shield1[playerid] = false;
    SK_Shield2[playerid] = false;
    SK_Shield3[playerid] = false;
    SK_BagStage1[playerid] = false;
    SK_BagStage2[playerid] = false;
    SK_BagStage3[playerid] = false;
    SK_FinalReady[playerid] = false;
    SK_ClearBag(playerid);

    if(SK_Vehicle[playerid] != 0 && SK_Vehicle[playerid] != INVALID_VEHICLE_ID)
    {
        if(IsValidVehicle(SK_Vehicle[playerid]))
        {
            DestroyVehicle(SK_Vehicle[playerid]);
        }
    }

    SK_Vehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

stock SK_FinishWork(playerid)
{
    GivePlayerMoneyEx(playerid, SK_PAY_MONEY);
    SK_Cooldown[playerid] = gettime() + SK_WORK_COOLDOWN;

    SendClientMessage(playerid, SK_COLOR_SUCCESS, "{FFFF00}| {FFFFFF}Вы успешно выполнили работу в строительной компании.");
    ShowNotificationKirill(playerid, 3, 5, 0, 1, "Работа завершена. Оплата получена!", "");

    SetPlayerSkin(playerid, GetPlayerData(playerid, P_SKIN));
    DisablePlayerCheckpoint(playerid);
    SK_ResetPlayer(playerid);
    return 1;
}

stock SK_Init()
{
    SK_AreaCompany = CreateDynamicSphere(179.305343, 391.597808, 16.192012, 1.0, 0, 0, -1);
    SK_AreaProrab = CreateDynamicSphere(-9.116186, 1807.725463, 9.477350, 1.0, 0, 0, -1);

    SK_AreaBagDrop1 = CreateDynamicSphere(7.416964, 1869.525146, 15.407059, 1.3, 0, 0, -1);
    SK_AreaBagDrop2 = CreateDynamicSphere(75.329261, 1863.635009, 18.907058, 1.3, 0, 0, -1);
    SK_AreaBagDrop3 = CreateDynamicSphere(7.346275, 1869.510864, 9.907059, 1.3, 0, 0, -1);

    SK_PickupElectr1 = CreateDynamicPickup(1210, 23, 18.071474, 1875.481445, 9.907059, 0, 0, -1, 40.0);
    SK_PickupElectr2 = CreateDynamicPickup(1210, 23, 18.053916, 1875.414550, 18.907058, 0, 0, -1, 40.0);
    SK_PickupElectr3 = CreateDynamicPickup(1210, 23, 18.054027, 1875.414428, 15.407059, 0, 0, -1, 40.0);

    SK_PickupBag1 = CreateDynamicPickup(1210, 23, 44.907081, 1868.700561, 15.407059, 0, 0, -1, 40.0);
    SK_PickupBag2 = CreateDynamicPickup(1210, 23, 39.442390, 1868.927612, 22.407058, 0, 0, -1, 40.0);
    SK_PickupBag3 = CreateDynamicPickup(1210, 23, 7.857259, 1876.818725, 15.407059, 0, 0, -1, 40.0);

    SK_PickupFinal = CreateDynamicPickup(1575, 23, 79.417999, 1836.903564, 9.408595, 0, 0, -1, 40.0);

    SK_ActorOwner = CreateActor(73, 179.305343, 391.597808, 16.192012, 0.0);
    SK_ActorProrab = CreateActor(228, -9.116186, 1807.725463, 9.477350, 86.516845);

    CreateDynamic3DTextLabel("Владелец строительной компании\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 179.305343, 391.597808, 16.992012, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Прораб {FFFF00}Василий\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, -9.116186, 1807.725463, 10.277350, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Электрический щит\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 18.071474, 1875.481445, 10.607059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Электрический щит\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 18.053916, 1875.414550, 19.607058, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Электрический щит\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 18.054027, 1875.414428, 16.107059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Мешок с цементом\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 44.907081, 1868.700561, 16.107059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Мешок с цементом\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 39.442390, 1868.927612, 23.107058, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Мешок с цементом\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 7.857259, 1876.818725, 16.107059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Место выгрузки мешков\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 7.416964, 1869.525146, 16.107059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Место выгрузки мешков\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 75.329261, 1863.635009, 19.607058, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Место выгрузки мешков\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 7.346275, 1869.510864, 10.607059, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    CreateDynamic3DTextLabel("Строительный контейнер\n{FFFFFF}подойдите для {FFFF00}взаимодействия",
        SK_COLOR_WHITE, 79.417999, 1836.903564, 10.108595, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, 0, -1, 40.0);

    print("[SK] Строительная компания загружена.");
    return 1;
}

stock SK_ShowJobDialog(playerid)
{
    if(GetPlayerData(playerid, P_LEVEL) < SK_JOB_MIN_LEVEL)
    {
        SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Работа доступна с 8 уровня.");
        return 1;
    }

    if(SK_Cooldown[playerid] > gettime())
    {
        new left = SK_Cooldown[playerid] - gettime();
        new string[96];
        format(string, sizeof(string), "{FFFF00}| {FFFFFF}Вы уже работали недавно. Осталось: %d мин.", left / 60);
        SendClientMessage(playerid, SK_COLOR_ERROR, string);
        return 1;
    }

    ShowPlayerDialog(playerid, SK_DIALOG_STROY, DIALOG_STYLE_LIST, "Строительная компания",
        "Арзамас\nЮжный\nЛыткарино", "Выбрать", "Назад");
    return 1;
}

stock SK_HandleDynamicPickup(playerid, pickupid)
{
    if(pickupid == SK_PickupElectr1)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_ELECTR, DIALOG_STYLE_MSGBOX,
            "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }

    if(pickupid == SK_PickupElectr2)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_ELECTRO, DIALOG_STYLE_MSGBOX,
            "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }

    if(pickupid == SK_PickupElectr3)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_ELECTROO, DIALOG_STYLE_MSGBOX,
            "Электрический щит", "Вы желаете начать ремонт щита?", "Начать", "Выйти");
        return 1;
    }

    if(pickupid == SK_PickupBag1)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_MESHOK, DIALOG_STYLE_MSGBOX,
            "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }

    if(pickupid == SK_PickupBag2)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_MESHOKK, DIALOG_STYLE_MSGBOX,
            "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }

    if(pickupid == SK_PickupBag3)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_MESHOKKK, DIALOG_STYLE_MSGBOX,
            "Склад мешков", "Вы желаете взять мешок?", "Взять", "Назад");
        return 1;
    }

    if(pickupid == SK_PickupFinal)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_MYSORA, DIALOG_STYLE_MSGBOX,
            "Строительный контейнер", "Вы привезли мусор на погрузчике, хотите его выгрузить?", "Далее", "Назад");
        return 1;
    }

    return 0;
}

stock SK_HandleDynamicArea(playerid, areaid)
{
    if(areaid == SK_AreaCompany)
    {
        return SK_ShowJobDialog(playerid);
    }

    if(areaid == SK_AreaProrab)
    {
        ShowPlayerDialog(playerid, SK_DIALOG_PRORAB, DIALOG_STYLE_MSGBOX,
            "Прораб {FFFF00}Василий", "Вы желаете начать рабочий день?", "Начать", "Назад");
        return 1;
    }

    if(areaid == SK_AreaBagDrop1)
    {
        if(!SK_BagInHands[playerid])
        {
            SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}У вас нет мешка в руках.");
            return 1;
        }

        SK_ClearBag(playerid);
        SK_BagStage1[playerid] = true;
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок, отправляйтесь за следующим.");
        SetPlayerCheckpoint(playerid, 39.442390, 1868.927612, 22.407058, 1.5);
        return 1;
    }

    if(areaid == SK_AreaBagDrop2)
    {
        if(!SK_BagInHands[playerid])
        {
            SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}У вас нет мешка в руках.");
            return 1;
        }

        SK_ClearBag(playerid);
        SK_BagStage2[playerid] = true;
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок, отправляйтесь за следующим.");
        SetPlayerCheckpoint(playerid, 7.857259, 1876.818725, 15.407059, 1.5);
        return 1;
    }

    if(areaid == SK_AreaBagDrop3)
    {
        if(!SK_BagInHands[playerid])
        {
            SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}У вас нет мешка в руках.");
            return 1;
        }

        SK_ClearBag(playerid);
        SK_BagStage3[playerid] = true;
        SK_FinalReady[playerid] = true;

        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы успешно сдали мешок. Начинайте работу на {FFFF00}погрузчике{FFFFFF}.");
        SetPlayerCheckpoint(playerid, 79.417999, 1836.903564, 9.408595, 1.5);

        if(SK_Vehicle[playerid] != 0 && SK_Vehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(SK_Vehicle[playerid]))
        {
            DestroyVehicle(SK_Vehicle[playerid]);
        }

        SK_Vehicle[playerid] = CreateVehicle(486, -41.542228, 1881.632202, 4.548228, 177.128326, 3, 3, -1);
        if(SK_Vehicle[playerid] != INVALID_VEHICLE_ID)
        {
            SetVehicleVirtualWorld(SK_Vehicle[playerid], GetPlayerVirtualWorld(playerid));
            LinkVehicleToInterior(SK_Vehicle[playerid], GetPlayerInterior(playerid));
            PutPlayerInVehicle(playerid, SK_Vehicle[playerid], 0);
        }
        return 1;
    }

    return 0;
}

stock SK_HandleCheckpoint(playerid)
{
    if(!SK_Work[playerid]) return 0;

    if(SK_FinalReady[playerid])
    {
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Подойдите к строительному контейнеру для завершения работы.");
        return 1;
    }

    return 0;
}

stock SK_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == SK_DIALOG_STROY)
    {
        if(!response)
        {
            SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы отказались от трудоустройства.");
            return 1;
        }

        if(SK_Cooldown[playerid] > gettime())
        {
            SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Вы уже работали недавно, ожидайте.");
            return 1;
        }

        SK_ResetPlayer(playerid);
        SK_Work[playerid] = true;

        switch(listitem)
        {
            case 0: SetPlayerCheckpoint(playerid, -3.654715, 1815.037353, 9.398981, 3.0);
            case 1: SetPlayerCheckpoint(playerid, 1772.700439, -2505.793457, 10.815861, 3.0);
            case 2: SetPlayerCheckpoint(playerid, -2175.430664, -405.804870, 29.426282, 3.0);
            default: SetPlayerCheckpoint(playerid, -3.654715, 1815.037353, 9.398981, 3.0);
        }

        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы успешно устроились в строительную компанию. Отправляйтесь на стройку.");
        return 1;
    }

    if(dialogid == SK_DIALOG_PRORAB)
    {
        if(!response)
        {
            SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы отказались от работы.");
            return 1;
        }

        if(!SK_Work[playerid])
        {
            SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Вы не работаете на стройке.");
            return 1;
        }

        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Следуйте на метку и начинайте работу.");
        SetPlayerSkin(playerid, 206);
        SetPlayerCheckpoint(playerid, 18.071474, 1875.481445, 9.907059, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_ELECTR)
    {
        if(!response) return 1;
        if(!SK_Work[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Вы не работаете на стройке.");

        SK_Shield1[playerid] = true;
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку.");
        SK_Freeze(playerid, 5000);
        SetPlayerCheckpoint(playerid, 18.053916, 1875.414550, 18.907058, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_ELECTRO)
    {
        if(!response) return 1;
        if(!SK_Shield1[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");

        SK_Shield2[playerid] = true;
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}После окончания работы следуйте на следующую метку.");
        SK_Freeze(playerid, 5000);
        SetPlayerCheckpoint(playerid, 18.054027, 1875.414428, 15.407059, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_ELECTROO)
    {
        if(!response) return 1;
        if(!SK_Shield2[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Почините предыдущий щиток.");

        SK_Shield3[playerid] = true;
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}1 этап стройки завершен.");
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Отправляйтесь к мешкам и начинайте переносить их.");
        SK_Freeze(playerid, 5000);
        SetPlayerCheckpoint(playerid, 44.907081, 1868.700561, 15.407059, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_MESHOK)
    {
        if(!response) return 1;
        if(!SK_Shield3[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Вы не закончили 1 этап стройки.");

        SK_GiveBag(playerid);
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на метку.");
        SK_Freeze(playerid, 3000);
        SetPlayerCheckpoint(playerid, 7.416964, 1869.525146, 15.407059, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_MESHOKK)
    {
        if(!response) return 1;
        if(!SK_BagStage1[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Сначала сдайте предыдущий мешок.");

        SK_GiveBag(playerid);
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на метку.");
        SK_Freeze(playerid, 3000);
        SetPlayerCheckpoint(playerid, 75.329261, 1863.635009, 18.907058, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_MESHOKKK)
    {
        if(!response) return 1;
        if(!SK_BagStage2[playerid]) return SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Сначала сдайте предыдущий мешок.");

        SK_GiveBag(playerid);
        SendClientMessage(playerid, SK_COLOR_WHITE, "{FFFF00}| {FFFFFF}Вы взяли мешок. Отнесите его на метку.");
        SK_Freeze(playerid, 3000);
        SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1.5);
        return 1;
    }

    if(dialogid == SK_DIALOG_MYSORA)
    {
        if(!response) return 1;
        if(!SK_FinalReady[playerid])
        {
            SendClientMessage(playerid, SK_COLOR_ERROR, "{FFFF00}| {FFFFFF}Вы не выполнили 2 этап.");
            return 1;
        }

        return SK_FinishWork(playerid);
    }

    return 0;
}

CMD:stroyka(playerid, params[])
{
    #pragma unused params
    return SK_ShowJobDialog(playerid);
}
