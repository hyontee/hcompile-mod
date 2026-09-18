new vzkadrov1;
new vzkadrov2;
new vzkadrov3;
new vzkadrov4;
new vzkadrov5;
new errorotdel[MAX_PLAYERS];


public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if (areaid == vzkadrov1) {
        SetPVarInt(playerid, "otdel", 1);
        ShowNotificationNew(playerid, 4, 6, OTDEL_OFFER, 0, "Взаимодействовать", ">>");
    }
    if (areaid == vzkadrov2){
        SetPVarInt(playerid, "otdel", 2);
        ShowNotificationNew(playerid, 4, 6, OTDEL_OFFER, 0, "Взаимодействовать", ">>");
    }
    if (areaid == vzkadrov3) {
        SetPVarInt(playerid, "otdel", 3);
        ShowNotificationNew(playerid, 4, 6, OTDEL_OFFER, 0, "Взаимодействовать", ">>");
    }
    if (areaid == vzkadrov4) {
    if(GetPlayerVirtualWorld(playerid) == 101)
    {
        SetPVarInt(playerid, "otdel", 4);
        ShowNotificationNew(playerid, 4, 6, OTDEL_OFFER, 0, "Взаимодействовать", ">>");
        }
        else if(GetPlayerVirtualWorld(playerid) == 50)
    {
    SetPVarInt(playerid, "otdel", 5);
        ShowNotificationNew(playerid, 4, 6, OTDEL_OFFER, 0, "Взаимодействовать", ">>");
    }
    }
    #if defined t_OnPlayerEnterDynamicArea
        t_OnPlayerEnterDynamicArea(playerid, areaid);
    #endif
    return 1;
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea t_OnPlayerEnterDynamicArea
#if defined t_OnPlayerEnterDynamicArea
forward t_OnPlayerEnterDynamicArea(playerid, areaid);
#endif  

public OnGameModeInit()
{
    //военкомат
    vzkadrov1 = CreateDynamicSphere(498.718017,1511.595458,1501.000000, 2.0);
    //сми
    vzkadrov2 = CreateDynamicSphere(1985.329711,-3.292105,1381.003540, 2.0);
    //право
    vzkadrov3 = CreateDynamicSphere(-886.724182,-1576.502441,1398.501098, 2.0);
    //гибдд
    vzkadrov4 = CreateDynamicSphere(-1106.177490,1513.784179,1499.953247, 2.0);
    vzkadrov5 = CreateDynamicSphere(-2528.527832,357.601684,2.100287, 2.0);
    
    CreateDynamic3DTextLabel("Прием на работу", 0xFFFF00FF, -886.708557,-1570.492309,1398.50109 + 1.8, 10.0);
    CreatePickup(1210, 23, -886.708557,-1570.492309,1398.50109, 1, PICKUP_ACTION_TYPE_MAYOR_JOB);
    
    OtdelKadrovCb = CreateActor(81, 1502.981933,2500.498535,2501.000000,270.907531, 0.0, 1);
    Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, 1502.981933,2500.498535,2501.000000, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovCb, 1);
    
    OtdelKadrovSmi = CreateActor(81, 1985.329711,-3.292105,1381.003540,358.328704, 0.0, 1);
    Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, 1985.329711,-3.292105,1381.003540, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovSmi, 1);
    
    OtdelKadrovVoenkom = CreateActor(81, 498.718017,1511.595458,1501.000000, 0.0, 1);
    Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, 498.889312,1511.592651,1501.000000, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovVoenkom, 1);
    
    OtdelKadrovPravo = CreateActor(81, -886.724182,-1576.502441,1398.501098,85.519363, 0.0, 1);
    Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, 969.463562,-2.966348,1380.996215, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovPravo, 1);
    
    OtdelKadrovGibdd = CreateActor(81, -1106.177490,1513.784179,1499.953247,58.987396, 0.0, 1);
    Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, -1106.177490,1513.784179,1499.953247, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovGibdd, 101);
    OtdelKadrovMVD = CreateActor(81, -1106.177490,1513.784179,1499.953247,58.987396, 0.0, 1);
    //Create3DTextLabel("{ffff00}« Отдел кадров »\n{ffffff}Подойдите для\nвзоимодействия", -1, -1106.177490,1513.784179,1499.953247, 15.0, 1);
    SetActorVirtualWorld(OtdelKadrovMVD, 50);
    
    #if defined t_OnGameModeInit
        t_OnGameModeInit();
    #endif
    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit t_OnGameModeInit
#if defined t_OnGameModeInit
forward t_OnGameModeInit();
#endif  

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])    
{
    if (dialogid == 21000) // Было 77890
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0:
            {
                errorotdel[playerid] = 0;
                errorotdel[playerid]++;
                ShowPlayerDialog(playerid, 21001, DIALOG_STYLE_LIST, "Что такое Role Play?", "1.Дм, убийство, криминал\n2.Ролевые игры\n3.Игра по ролям. Если я полицейский - я играю роль полицейского", "Далее", "Отмена");
            }
            case 1:
            {
                ShowPlayerDialog(playerid, 21001, DIALOG_STYLE_LIST, "Что такое Role Play?", "1.Дм, убийство, криминал\n2.Ролевые игры\n3.Игра по ролям. Если я полицейский - я играю роль полицейского", "Далее", "Отмена");
            }
        }
        return 1;
    }
    
    if (dialogid == 21001) // Было 77891
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0, 1:
            {
                errorotdel[playerid]++;
                if(errorotdel[playerid] >=2) 
                {
                    SendClientMessage(playerid, -1,"Вы совершили много ошибок.\nТестирование окончено.");
                    DeletePVar(playerid, "otdel");
                    return 1;
                }
                ShowPlayerDialog(playerid, 21002, DIALOG_STYLE_LIST, "Разрешено ли возвращаться на место смерти?", "1.Разрешено\n2.Только в некоторых случаях\n3.Запрещено. Это нарушает правила игры", "Далее", "Отмена");
            }
            case 2:
            {
                ShowPlayerDialog(playerid, 21002, DIALOG_STYLE_LIST, "Разрешено ли возвращаться на место смерти?", "1.Разрешено\n2.Только в некоторых случаях\n3.Запрещено. Это нарушает правила игры", "Далее", "Отмена");
            }
        }
        return 1;
    }
    
    if (dialogid == 21002) // Было 77892
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0, 1:
            {
                errorotdel[playerid]++;
                if(errorotdel[playerid] >=2) 
                {
                    SendClientMessage(playerid, -1,"Вы совершили много ошибок.\nТестирование окончено.");
                    DeletePVar(playerid, "otdel");
                    return 1;
                }
                ShowPlayerDialog(playerid, 21003, DIALOG_STYLE_LIST, "Разрешено ли убивать коллег из организации?", "1.Разрешено\n2.Только в некоторых случаях\n3.Запрещено. Это нарушает правила игры", "Далее", "Отмена");
            }
            case 2:
            {
                ShowPlayerDialog(playerid, 21003, DIALOG_STYLE_LIST, "Разрешено ли убивать коллег из организации?", "1.Разрешено\n2.Только в некоторых случаях\n3.Запрещено. Это нарушает правила игры", "Далее", "Отмена");
            }
        }
        return 1;
    }
    
    if (dialogid == 21003) // Было 77893
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0, 1:
            {
                errorotdel[playerid]++;
                if(errorotdel[playerid] >=2) 
                {
                    SendClientMessage(playerid, -1,"Вы совершили много ошибок.\nТестирование окончено.");
                    DeletePVar(playerid, "otdel");
                    return 1;
                }
                ShowPlayerDialog(playerid, 21004, DIALOG_STYLE_LIST, "Что означает ООС информация?", "1.Информация, которая касается игрового процесса\n2.Информация, которая не касается игрового процесса", "Далее", "Отмена");
            }
            case 2:
            {
                ShowPlayerDialog(playerid, 21004, DIALOG_STYLE_LIST, "Что означает ООС информация?", "1.Информация, которая касается игрового процесса\n2.Информация, которая не касается игрового процесса", "Далее", "Отмена");
            }
        }
        return 1;
    }
    
    if(dialogid == 21004) // Было 77894
    {
        if(!response) 
        {
            DeletePVar(playerid, "otdel");
            return 1;
        }
        
        switch(listitem)
        {
            case 0:
            {
                errorotdel[playerid]++;
                if(errorotdel[playerid] >= 2) 
                {
                    SendClientMessage(playerid, -1, "Вы совершили много ошибок.\nТестирование окончено.");
                    DeletePVar(playerid, "otdel");
                    return 1;
                }
                SendClientMessage(playerid, -1, "Тестирование провалено.");
                DeletePVar(playerid, "otdel");
                return 1;
            }
            case 1:
            {
                new Otdel = GetPVarInt(playerid, "otdel");
                new fmt_text[128];
                new Name_Org[32];
                new org_id = 0;
                
                switch(Otdel)
                {
                    case 1: 
                    {
                        org_id = 2;
                        format(Name_Org, sizeof(Name_Org), "Воинской части");
                    }
                    case 2: 
                    {
                        org_id = 4;
                        format(Name_Org, sizeof(Name_Org), "СМИ");
                    }
                    case 3: 
                    {
                        org_id = 1;
                        format(Name_Org, sizeof(Name_Org), "Правительство области");
                    }
                    case 4: 
                    {
                        org_id = 5;
                        format(Name_Org, sizeof(Name_Org), "ГИБДД");
                    }
                    case 5: 
                    {
                        org_id = 6;
                        format(Name_Org, sizeof(Name_Org), "УМВД");
                    }
                    default:
                    {
                        SendClientMessage(playerid, -1, "Ошибка отдела. Обратитесь к администратору.");
                        DeletePVar(playerid, "otdel");
                        return 1;
                    }
                }
                
                if(org_id > 0)
                {
                    InvitePlayer(playerid, org_id, 1, true);
                    
                    format(fmt_text, sizeof(fmt_text), "Вы успешно прошли тестирование и были зачислены в ряды организации %s", Name_Org);
                    ShowPlayerDialog(playerid, 21005, DIALOG_STYLE_MSGBOX, "Отдел кадров", fmt_text, "OK", "");
                    
                    SendClientMessage(playerid, 0x00FF00FF, fmt_text);
                }
                DeletePVar(playerid, "otdel");
                return 1;
            }
        }
        return 1;
    }
    
    // Тут проблема - нужно либо вернуть результат хука, либо 0
    #if defined t_OnDialogResponse
    return t_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif

#define OnDialogResponse t_OnDialogResponse
#if defined t_OnDialogResponse
forward t_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

CMD:otdelkadrov(playerid, params[])
{
    ShowPlayerDialog(playerid, 21000, DIALOG_STYLE_LIST, "Что означает IC информация?", "1.Информация, которая не касается игрового процесса\n2.Информация, которая касается игрового процесса", "Далее", "Отмена");
}