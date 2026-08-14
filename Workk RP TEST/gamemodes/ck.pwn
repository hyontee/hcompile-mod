/*
// ============================================================
строительная компания 
система  сырая но вы можете ее реализовать в случае фул 
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp
АВТОР СИСТЕМЫ: t.me/west_samp

ЕСЛИ ТЫ СМЕНИШЬ АВТОРА СИСТЕМЫ ТЫ НИЩИЙ И БУДЕШЬ ННОМ 

ПЕРЕСИЛИЛ БЛЕЙН x WEST
купить систему  писать мне @west_dev

АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne
АВТОР СЛИВА https://t.me/studio_bleyne

// ============================================================
*/
// -------------------- ПЕРЕМЕННЫЕ --------------------
new Stroy_Company_Sphere, Stroy_Prorab_Sphere;
new Stroy_Worker[MAX_PLAYERS];
new Stroy_Pickup_1, Stroy_Pickup_2, Stroy_Pickup_3;
new Stroy_Stage1[MAX_PLAYERS], Stroy_Stage2[MAX_PLAYERS], Stroy_Stage3[MAX_PLAYERS];
new Stroy_Bag1, Stroy_Bag2, Stroy_Bag3;
new Stroy_BagHold[MAX_PLAYERS];
new Stroy_Zone1, Stroy_Zone2, Stroy_Zone3;
new Stroy_BagDone1[MAX_PLAYERS], Stroy_BagDone2[MAX_PLAYERS];
new Stroy_Veh[MAX_PLAYERS];
new Stroy_Trash;
new Stroy_Cooldown[MAX_PLAYERS];
new Stroy_Finish[MAX_PLAYERS];

// -------------------- ДИАЛОГИ --------------------
#define DIALOG_STROY_MAIN       3200
#define DIALOG_STROY_WORK       3201
#define DIALOG_STROY_ELEC1      3202
#define DIALOG_STROY_ELEC2      3203
#define DIALOG_STROY_ELEC3      3204
#define DIALOG_STROY_BAG1       3205
#define DIALOG_STROY_BAG2       3206
#define DIALOG_STROY_BAG3       3207
#define DIALOG_STROY_TRASH      3208

// -------------------- ИНИЦИАЛИЗАЦИЯ (ДОБАВЬ ЭТО В СВОЙ OnGameModeInit) --------------------
// ВСТАВЬ ЭТОТ КОД ВНУТРЬ ТВОЕГО public OnGameModeInit()
/*
{
    // Офис
Create3DTextLabel("{FFDC33}Начальник Андреевич\n\n{FFFFFF}Подойдите ближе, чтобы устроиться в строительную компанию", 0xFFFFFFFF, 179.305343, 391.597808, 16.192012, 3);
CreateActor(34, 179.305297, 391.597808, 16.195312, 92.8);
Stroy_Company_Sphere = CreateDynamicSphere(179.305343, 391.597808, 16.192012, 1.0);

// Прорабы
CreateActor(228, -9.116186, 1807.725463, 9.477350, 86.516845);
Create3DTextLabel("{FFDC33}Прораб - Александр\n\n{FFFFFF}Подойдите для взаимодействия с Александром", 0xFFFFFFFF, -9.116186, 1807.725463, 9.477350, 3);
Stroy_Prorab_Sphere = CreateDynamicSphere(-9.116186, 1807.725463, 9.477350, 1.0);

// Щитки
Create3DTextLabel("{FFDC33}Электрический щиток\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.071474, 1875.481445, 9.907059, 10);
Stroy_Pickup_1 = CreatePickup(1210, 23, 18.071474, 1875.481445, 9.907059, -1);

Create3DTextLabel("{FFDC33}Электрический щиток\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.053916, 1875.414550, 18.907058, 10);
Stroy_Pickup_2 = CreatePickup(1210, 23, 18.053916, 1875.414550, 18.907058, -1);

Create3DTextLabel("{FFDC33}Электрический щиток\n\n{FFFFFF}Подойдите ближе для починки щитка", 0xFFFFFFFF, 18.054027, 1875.414428, 15.407059, 10);
Stroy_Pickup_3 = CreatePickup(1210, 23, 18.054027, 1875.414428, 15.407059, -1);

// Мешки 
Stroy_Bag1 = CreatePickup(1210, 23, 44.907081, 1868.700561, 15.407059, -1);
Create3DTextLabel("{A9A9A9}Мешок с цементом\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 44.907081, 1868.700561, 15.407059, 10);
Stroy_Zone1 = CreateDynamicSphere(7.416964, 1869.525146, 15.407059, 1.0);
Create3DTextLabel("{FF0000}Выгрузка мешков\n\n{FFFFFF}Подойдите ближе для взаимодействия с мешком", 0xFFFFFFFF, 7.416964, 1869.525146, 15.407059, 10);

Stroy_Bag2 = CreatePickup(1210, 23, 39.442390, 1868.927612, 22.407058, -1);
Create3DTextLabel("{A9A9A9}Мешок с песком\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 39.442390, 1868.927612, 22.407058, 10);
Stroy_Zone2 = CreateDynamicSphere(75.329261, 1863.635009, 18.907058, 1.0);
Create3DTextLabel("{FF0000}Выгрузка мешков\n\n{FFFFFF}Подойдите ближе для взаимодействия с мешком", 0xFFFFFFFF, 75.329261, 1863.635009, 18.907058, 10);

Stroy_Bag3 = CreatePickup(1210, 23, 7.857259, 1876.818725, 15.407059, -1);
Create3DTextLabel("{A9A9A9}Мешок с инструментами\n\n{FFFFFF}Подойдите ближе для взятия мешка", 0xFFFFFFFF, 7.857259, 1876.818725, 15.407059, 10);
Stroy_Zone3 = CreateDynamicSphere(7.346275, 1869.510864, 9.907059, 1.0);
Create3DTextLabel("{FF0000}Выгрузка мешков\n\n{FFFFFF}Подойдите ближе для взаимодействия с мешком", 0xFFFFFFFF, 7.346275, 1869.510864, 9.907059, 10);

// Мусор
Stroy_Trash = CreatePickup(1575, 23, 79.4179980, 1836.903564, 9.408595, -1);

*/

// -------------------- ЗОНЫ (ВСТАВЬ ЭТО В СВОЙ OnPlayerEnterDynamicArea) --------------------
// ВНУТРИ ТВОЕГО public OnPlayerEnterDynamicArea(playerid, areaid) ДОБАВЬ ЭТИ ПРОВЕРКИ:
/*
    if(areaid == Stroy_Company_Sphere)
    {
        ShowPlayerDialog(playerid, DIALOG_STROY_MAIN, DIALOG_STYLE_LIST,
            "{FFDC33}Строительная компания\n{FFFFFF}Арзамас - нажмите для взаимодействия\nЮжный - нажмите для взаимодействия\nЛыткарино - нажмите для взаимодействия",
            "Выбрать", "Назад");
        return 1;
    }

    if(areaid == Stroy_Prorab_Sphere)
    {
        if(!Stroy_Worker[playerid]) 
            return SendClientMessage(playerid, -1, "{FF6347}Вы не устроены на стройку!");
        
        ShowPlayerDialog(playerid, DIALOG_STROY_WORK, DIALOG_STYLE_MSGBOX,
            "{FFDC33}Прораб Александр",
            "{FFFFFF}Начать рабочий день?",
            "Да", "Нет");
        return 1;
    }

    if(areaid == Stroy_Zone1)
    {
        if(!Stroy_BagHold[playerid]) 
            return SendClientMessage(playerid, -1, "{FF6347}У вас нет мешка с цементом!");
        
        SendClientMessage(playerid, -1, "{33FF33}Вы успешно сдали мешок с цементом!");
        Stroy_BagHold[playerid] = 0;
        Stroy_BagDone1[playerid] = 1;
        SetPlayerCheckpoint(playerid, 39.442390, 1868.927612, 22.407058, 1.0);
        return 1;
    }

    if(areaid == Stroy_Zone2)
    {
        if(!Stroy_BagHold[playerid]) 
            return SendClientMessage(playerid, -1, "{FF6347}У вас нет мешка с песком!");
        
        SendClientMessage(playerid, -1, "{33FF33}Вы успешно сдали мешок с песком!");
        Stroy_BagHold[playerid] = 0;
        Stroy_BagDone2[playerid] = 1;
        SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1.0);
        return 1;
    }

    if(areaid == Stroy_Zone3)
    {
        if(!Stroy_BagHold[playerid]) 
            return SendClientMessage(playerid, -1, "{FF6347}У вас нет мешка с инструментами!");
        
        SendClientMessage(playerid, -1, "{33FF33}Вы успешно сдали мешок с инструментами!");
        Stroy_BagHold[playerid] = 0;
        Stroy_BagDone3[playerid] = 1;
        SetPlayerCheckpoint(playerid, -9.116186, 1807.725463, 9.477350, 1.0);
        return 1;
    }
*/
*/

// -------------------- ПИКАПЫ (ВСТАВЬ В СВОЙ OnPlayerPickUpPickup) --------------------
// ВНУТРИ public OnPlayerPickUpPickup(playerid, pickupid) ДОБАВЬ:
/*
    if(pickupid == Stroy_Pickup_1)
{
    if(Stroy_Stage1[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Щиток уже починен!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_ELEC1, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Электрический щиток",
        "{FFFFFF}Начать ремонт?",
        "Да", "Нет");
    return 1;
}

if(pickupid == Stroy_Pickup_2)
{
    if(!Stroy_Stage1[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Почините первый щиток!");
    if(Stroy_Stage2[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Щиток уже починен!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_ELEC2, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Электрический щиток",
        "{FFFFFF}Начать ремонт?",
        "Да", "Нет");
    return 1;
}

if(pickupid == Stroy_Pickup_3)
{
    if(!Stroy_Stage2[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Почините второй щиток!");
    if(Stroy_Stage3[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Щиток уже починен!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_ELEC3, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Электрический щиток",
        "{FFFFFF}Начать ремонт?",
        "Да", "Нет");
    return 1;
}

if(pickupid == Stroy_Bag1)
{
    if(!Stroy_Stage3[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Завершите 1 этап!");
    if(Stroy_BagHold[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}У вас уже есть мешок!");
    if(Stroy_BagDone1[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Вы уже сдали этот мешок!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_BAG1, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Мешок с цементом",
        "{FFFFFF}Взять мешок?",
        "Взять", "Назад");
    return 1;
}

if(pickupid == Stroy_Bag2)
{
    if(!Stroy_BagDone1[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Сдайте первый мешок!");
    if(Stroy_BagHold[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}У вас уже есть мешок!");
    if(Stroy_BagDone2[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Вы уже сдали этот мешок!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_BAG2, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Мешок с песком",
        "{FFFFFF}Взять мешок?",
        "Взять", "Назад");
    return 1;
}

if(pickupid == Stroy_Bag3)
{
    if(!Stroy_BagDone2[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Сдайте второй мешок!");
    if(Stroy_BagHold[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}У вас уже есть мешок!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_BAG3, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Мешок с инструментами",
        "{FFFFFF}Взять мешок?",
        "Взять", "Назад");
    return 1;
}

if(pickupid == Stroy_Trash)
{
    if(!Stroy_Finish[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}Вы не на погрузчике!");
    
    ShowPlayerDialog(playerid, DIALOG_STROY_TRASH, DIALOG_STYLE_MSGBOX,
        "{FFDC33}"SERVER_NAME" | Мусорный бак",
        "{FFFFFF}Выгрузить мусорный бак",
        "Да", "Нет");
    return 1;
}
*/

// -------------------- ДИАЛОГИ (ВСТАВЬ В СВОЙ OnDialogResponse) --------------------
// ВНУТРИ public OnDialogResponse(playerid, dialogid, response, listitem) ДОБАВЬ:
/*
    if(dialogid == DIALOG_STROY_MAIN)
    {
        if(!response) return 1;
        if(Stroy_Worker[playerid]) 
            return SendClientMessage(playerid, -1, "К сожалению  вы уже работаете  в строительной компании");
        if(Stroy_Cooldown[playerid] > gettime()) 
           /// return SendClientMessage(playerid, -1, "{FFFF00}| Подождите 5 часов"); вам это не нужно можете удалить 
        
        Stroy_Worker[playerid] = 1;
        SendClientMessage(playerid, -1, "{FFFF00}| Вы устроились на стройку!");
        
        switch(listitem)
        {
            case 0: SetPlayerCheckpoint(playerid, -3.654715, 1815.037353, 9.398981, 3.0);
            case 1: SetPlayerCheckpoint(playerid, 1772.700439, -2505.793457, 10.815861, 3.0);
            case 2: SetPlayerCheckpoint(playerid, -2175.430664, -405.804870, 29.426282, 3.0);
        }
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_WORK)
    {
        if(!response) return 1;
        if(!Stroy_Worker[playerid]) 
            return SendClientMessage(playerid, -1, "Вы не работайте в строительной компании для начала работы устройтесь у александра");
        if(Stroy_Stage3[playerid]) 
            return SendClientMessage(playerid, -1, "Вы успешно устроились Danny_West");
        
        SendClientMessage(playerid, -1, "Подойдите к электрическому щитку и почините их!");
        SetPlayerCheckpoint(playerid, 18.071474, 1875.481445, 9.907059, 1.0);
        SetPlayerSkin(playerid, 206);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_ELEC1)
    {
        if(!response) return 1;
        Stroy_Stage1[playerid] = 1;
        SendClientMessage(playerid, -1, "Вы успешно починили щиток!");
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("Stroy_Unfreeze", 3000, false, "i", playerid);
        SetPlayerCheckpoint(playerid, 18.053916, 1875.414550, 18.907058, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_ELEC2)
    {
        if(!response) return 1;
        Stroy_Stage2[playerid] = 1;
        SendClientMessage(playerid, -1, "Вы успешно починили щиток!");
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("Stroy_Unfreeze", 3000, false, "i", playerid);
        SetPlayerCheckpoint(playerid, 18.054027, 1875.414428, 15.407059, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_ELEC3)
    {
        if(!response) return 1;
        Stroy_Stage3[playerid] = 1;
        SendClientMessage(playerid, -1, "{FFFF00}| 1 этап завершен берите мешки");
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("Stroy_Unfreeze", 3000, false, "i", playerid);
        SetPlayerCheckpoint(playerid, 44.907081, 1868.700561, 15.407059, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_BAG1)
    {
        if(!response) return 1;
        Stroy_BagHold[playerid] = 1;
        SendClientMessage(playerid, -1, "{FFFF00}| Вы взяли мешок несите на метку");
        SetPlayerCheckpoint(playerid, 7.416964, 1869.525146, 15.407059, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_BAG2)
    {
        if(!response) return 1;
        Stroy_BagHold[playerid] = 1;
        SendClientMessage(playerid, -1, "{FFFF00}| Вы взяли мешок несите  на метку");
        SetPlayerCheckpoint(playerid, 75.329261, 1863.635009, 18.907058, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_BAG3)
    {
        if(!response) return 1;
        Stroy_BagHold[playerid] = 1;
        SendClientMessage(playerid, -1, "{FFFF00}| Вы взяли мешок несите на метку");
        SetPlayerCheckpoint(playerid, 7.346275, 1869.510864, 9.907059, 1.0);
        return 1;
    }
    
    if(dialogid == DIALOG_STROY_TRASH)
    {
        if(!response) return 1;
        
        SendClientMessage(playerid, -1, "{FFFF00}| Стройка завершена! +150.000 рублей");
        GivePlayerMoney(playerid, 150000);
        
        Stroy_Cooldown[playerid] = gettime() + 18000;
        
        if(Stroy_Veh[playerid] != INVALID_VEHICLE_ID)
        {
            DestroyVehicle(Stroy_Veh[playerid]);
            Stroy_Veh[playerid] = INVALID_VEHICLE_ID;
        }
        
        SetPlayerSkin(playerid, 0);
        Stroy_Worker[playerid] = 0;
        Stroy_Stage1[playerid] = 0;
        Stroy_Stage2[playerid] = 0;
        Stroy_Stage3[playerid] = 0;
        Stroy_BagHold[playerid] = 0;
        Stroy_BagDone1[playerid] = 0;
        Stroy_BagDone2[playerid] = 0;
        Stroy_Finish[playerid] = 0;
        DisablePlayerCheckpoint(playerid);
        return 1;
    }
*/

// -------------------- ТАЙМЕР --------------------
forward Stroy_Unfreeze(playerid);
public Stroy_Unfreeze(playerid)
{
    if(IsPlayerConnected(playerid))
        TogglePlayerControllable(playerid, 1);
}

// -------------------- КОМАНДЫ --------------------
CMD:stroyka(playerid)
{
    if(!Stroy_Worker[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}| Вы не работаете на стройке");
    SendClientMessage(playerid, -1, "{FFFF00}| Идите к прорабу!");
    SetPlayerCheckpoint(playerid, -9.116186, 1807.725463, 9.477350, 1.0);
    return 1;
}

CMD:stroy_off(playerid)
{
    if(!Stroy_Worker[playerid]) 
        return SendClientMessage(playerid, -1, "{FFFF00}| Вы не работаете");
    
    Stroy_Worker[playerid] = 0;
    Stroy_Stage1[playerid] = 0;
    Stroy_Stage2[playerid] = 0;
    Stroy_Stage3[playerid] = 0;
    Stroy_BagHold[playerid] = 0;
    Stroy_BagDone1[playerid] = 0;
    Stroy_BagDone2[playerid] = 0;
    Stroy_Finish[playerid] = 0;
    
    if(Stroy_Veh[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(Stroy_Veh[playerid]);
        Stroy_Veh[playerid] = INVALID_VEHICLE_ID;
    }
    
    SetPlayerSkin(playerid, 0);
    DisablePlayerCheckpoint(playerid);
    SendClientMessage(playerid, -1, "{FFFF00}| Вы уволились");
    return 1;
}
